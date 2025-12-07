package lab7.product_management.repository;

import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import lab7.product_management.entity.Product;

import java.math.BigDecimal;
import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
        List<Product> findByCategory(String category);

        List<Product> findByNameContaining(String keyword);

        Page<Product> findByNameContaining(String keyword, Pageable pageable);

        List<Product> findByPriceBetween(BigDecimal minPrice, BigDecimal maxPrice);

        List<Product> findByCategoryOrderByPriceAsc(String category);

        boolean existsByProductCode(String productCode);

        @Query("SELECT p FROM Product p WHERE " +
                        "LOWER(p.name) LIKE LOWER(:name) AND " +
                        "LOWER(p.category) LIKE LOWER(:category) AND " +
                        "p.price BETWEEN :minPrice AND :maxPrice")
        Page<Product> searchProducts(@Param("name") String name,
                        @Param("category") String category,
                        @Param("minPrice") BigDecimal minPrice,
                        @Param("maxPrice") BigDecimal maxPrice,
                        Pageable pageable);

        @Query("SELECT DISTINCT p.category FROM Product p ORDER BY p.category")
        List<String> findAllCategories();

        @Query("SELECT COUNT(p) FROM Product p WHERE p.category = :category")
        long countByCategory(@Param("category") String category);

        @Query("SELECT SUM(p.price * p.quantity) FROM Product p")
        BigDecimal calculateTotalValue();

        @Query("SELECT AVG(p.price) FROM Product p")
        BigDecimal calculateAveragePrice();

        List<Product> findTop5ByOrderByIdDesc();

        @Query("SELECT p FROM Product p WHERE p.quantity < :threshold")
        List<Product> findLowStockProducts(@Param("threshold") int threshold);

}