package lab7.product_management.service;

import lab7.product_management.entity.Product;
import lab7.product_management.repository.ProductRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.math.BigDecimal;

@Service
@Transactional
public class ProductServiceImp implements ProductService {
    private final ProductRepository productRepository;

    public ProductServiceImp(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    @Override
    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }

    @Override
    public Optional<Product> getProductById(Long id) {
        return productRepository.findById(id);
    }

    @Override
    public Product saveProduct(Product product) {
        return productRepository.save(product);
    }

    @Override
    public void deleteProduct(Long id) {
        productRepository.deleteById(id);
    }

    @Override
    public List<Product> searchProducts(String keyword) {
        return productRepository.findByNameContaining(keyword);
    }

    @Override
    public List<Product> getProductsByCategory(String category) {
        return productRepository.findByCategory(category);
    }

    @Override
    public List<Product> advancedSearch(String name, String category, BigDecimal minPrice,
            BigDecimal maxPrice) {
        // convert empty string to null
        name = (name != null && name.trim().isEmpty()) ? null : name;
        category = (category != null && category.trim().isEmpty()) ? null : category;

        // if all parameters are null, return all products
        if (name == null && category == null && minPrice == null && maxPrice == null) {
            return productRepository.findAll();
        }

        // build dynamic query
        if (minPrice == null) {
            minPrice = BigDecimal.ZERO;
        }
        if (maxPrice == null) {
            maxPrice = BigDecimal.valueOf(Double.MAX_VALUE);
        }

        // use flexible search
        String namePattern = (name != null) ? "%" + name + "%" : "%";
        String categoryPattern = (category != null) ? "%" + category + "%" : "%";

        return productRepository.searchProducts(namePattern, categoryPattern, minPrice, maxPrice);
    }

    @Override
    public List<String> getAllCategories() {
        return productRepository.findAllCategories();
    }
}
