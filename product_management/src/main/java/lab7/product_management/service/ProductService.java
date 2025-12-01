package lab7.product_management.service;

import lab7.product_management.entity.Product;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Page;

import java.math.BigDecimal;

public interface ProductService {
    List<Product> getAllProducts();

    Optional<Product> getProductById(Long id);

    Product saveProduct(Product product);

    void deleteProduct(Long id);

    List<Product> searchProducts(String keyword);

    Page<Product> searchProductsWithPage(String keyword, Pageable pageable);

    List<Product> getProductsByCategory(String category);

    List<Product> advancedSearch(String name, String category, BigDecimal minPrice,
            BigDecimal maxPrice);

    List<String> getAllCategories();
}
