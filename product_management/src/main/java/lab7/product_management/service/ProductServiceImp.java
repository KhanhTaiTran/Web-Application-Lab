package lab7.product_management.service;

import lab7.product_management.entity.Product;
import lab7.product_management.repository.ProductRepository;

import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Sort;

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
    public List<Product> getAllProducts(Sort sort) {
        return productRepository.findAll(sort);
    }

    @Override
    public Page<Product> getAllProducts(Pageable pageable) {
        return productRepository.findAll(pageable);
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
    public Page<Product> searchProductsWithPage(String keyword, Pageable pageable) {
        return productRepository.findByNameContaining(keyword, pageable);
    }

    @Override
    public List<Product> getProductsByCategory(String category) {
        return productRepository.findByCategory(category);
    }

    @Override
    public Page<Product> advancedSearch(String name, String category, BigDecimal minPrice,
            BigDecimal maxPrice, Pageable pageable) {
        // convert empty string to null
        name = (name != null && name.trim().isEmpty()) ? null : name;
        category = (category != null && category.trim().isEmpty()) ? null : category;

        // if all parameters are null, return all products
        if (name == null && category == null && minPrice == null && maxPrice == null) {
            return productRepository.findAll(pageable);
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

        return productRepository.searchProducts(namePattern, categoryPattern, minPrice, maxPrice, pageable);
    }

    @Override
    public List<String> getAllCategories() {
        return productRepository.findAllCategories();
    }

    @Override
    public long getCountByCategory(String category) {
        return productRepository.countByCategory(category);
    }

    @Override
    public BigDecimal getTotalValue() {
        BigDecimal value = productRepository.calculateTotalValue();
        return value != null ? value : BigDecimal.ZERO;
    }

    @Override
    public BigDecimal getAveragePrice() {
        BigDecimal avg = productRepository.calculateAveragePrice();
        return avg != null ? avg : BigDecimal.ZERO;
    }

    @Override
    public List<Product> getLowStockProducts(int threshold) {
        return productRepository.findLowStockProducts(threshold);
    }

    @Override
    public List<Product> getRecentProducts() {
        return productRepository.findTop5ByOrderByIdDesc();
    }

    @Override
    public long getTotalProductsCount() {
        return productRepository.count();
    }
}
