package lab7.product_management.controller;

import lab7.product_management.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/dashboard")
public class DashBoardController {

    @Autowired
    private ProductService productService;

    @GetMapping
    public String showDashboard(Model model) {
        model.addAttribute("totalCount", productService.getTotalProductsCount());

        model.addAttribute("totalValue", productService.getTotalValue());

        model.addAttribute("avgPrice", productService.getAveragePrice());

        model.addAttribute("lowStockProducts", productService.getLowStockProducts(10));

        model.addAttribute("recentProducts", productService.getRecentProducts());

        List<String> categories = productService.getAllCategories();
        Map<String, Long> categoryStats = new HashMap<>();
        for (String cat : categories) {
            categoryStats.put(cat, productService.getCountByCategory(cat));
        }
        model.addAttribute("categoryStats", categoryStats);

        return "dashboard";
    }
}