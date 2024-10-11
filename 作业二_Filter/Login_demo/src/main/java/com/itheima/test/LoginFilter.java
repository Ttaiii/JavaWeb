package com.itheima.test;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * 登录验证的过滤器
 */
@WebFilter("/*")
public class LoginFilter implements Filter {
    private List<String> excludePaths;

    private static final Logger LOGGER = Logger.getLogger(LoginFilter.class.getName());

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 初始化排除路径
        excludePaths = Arrays.asList("/login", "/login.jsp", "/public.jsp", "/pictures/*");
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        String requestURI = request.getRequestURI();
        LOGGER.log(Level.INFO, "请求 URI: {0}", requestURI);

        // 检查请求路径是否在排除列表中
        if (isExcluded(requestURI)) {
            filterChain.doFilter(servletRequest, servletResponse);
            return;
        }

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            // 用户已登录，放行请求
            filterChain.doFilter(servletRequest, servletResponse);
        } else {
            // 用户未登录，重定向到登录页面
            LOGGER.log(Level.WARNING, "用户未登录，重定向到登录页面。");
            response.sendRedirect(response.encodeRedirectURL(request.getContextPath() + "/login.jsp"));
        }
    }

    @Override
    public void destroy() {
        // 清理资源（如果需要）
    }

    private boolean isExcluded(String path) {
        // 检查当前请求路径是否在排除列表中
        return excludePaths.stream().anyMatch(path::endsWith);
    }
}
