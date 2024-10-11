# 作业二：Filter练习

学院：省级示范性软件学院
题目：《 作业一：Filter练习》
姓名：罗云平
学号：2200770266
班级：软工2202
日期：2024-10-4

### 一、大体思路

1. 创建LoginFilter通过Session来跟着用户的登录状态，同时使用Cookie保持用户的登录状态（eg:“记住我”功能）

2. 设计登陆页面,主页面`login.jsp`,`home.jsp`

3. 设计登出功能，用户点击“退出”时，清除`Session`,`Cookie`

4. `doFilter`中实现逻辑：

   a.对登录页面、注册页面或公共资源的请求放行

   b.判断用户是否登录并设计相应功能

### 二、代码实现

- 创建LoginFilter

  在创建过滤器类 `LoginFilter.java`：

  ```java
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
  ```
  
  
  
- 创建登录页面

  在 `src/main/webapp` 目录下创建 `login.jsp` 页面：

  ```java
  <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
  
  <!DOCTYPE html>
  <html lang="zh">
  <head>
      <meta charset="UTF-8">
      <title>用户登录</title>
      <style>
          body, html {
              height: 100%;
              margin: 0;
              display: flex;
              justify-content: center;
              align-items: center;
              font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; /* 更新字体 */
              background-color: #f0f2f5; /* 添加背景色 */
          }
  
          .login-container {
              width: 300px;
              padding: 30px;
              box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
              border-radius: 8px;
              background: #ffffff; /* 显示白色背景 */
              transition: transform 0.2s; /* 添加过渡效果 */
          }
  
          .login-container:hover {
              transform: scale(1.02); /* 鼠标悬停时轻微放大效果 */
          }
  
          .login-container h2 {
              text-align: center;
              margin-bottom: 20px;
              color: #333; /* 更新标题颜色 */
          }
  
          .login-container .error-message {
              text-align: center;
              color: red;
              margin-bottom: 15px;
          }
  
          .login-container form div {
              margin-bottom: 15px;
          }
  
          .login-container label {
              display: block;
              margin-bottom: 5px;
              color: #555; /* 更新标签颜色 */
          }
  
          .login-container input[type="text"],
          .login-container input[type="password"] {
              width: 100%;
              padding: 10px; /* 增加内边距 */
              border: 1px solid #ccc;
              border-radius: 4px;
              box-sizing: border-box;
              font-size: 14px; /* 更新字体大小 */
          }
  
          .login-container input[type="checkbox"] {
              margin-top: 10px; /* 增加复选框顶部外边距 */
          }
  
          .login-container button {
              width: 100%;
              padding: 10px;
              border: none;
              border-radius: 4px;
              background-color: #4CAF50; /* 更新按钮颜色 */
              color: white;
              cursor: pointer;
              font-size: 16px; /* 更新按钮字体大小 */
              transition: background-color 0.3s;
          }
  
          .login-container button:hover {
              background-color: #45a049; /* 按钮悬停时变色 */
          }
  
          .login-container .footer {
              text-align: center;
              margin-top: 20px;
              font-size: 12px; /* 更新字体大小 */
              color: #777; /* 更新颜色 */
          }
      </style>
  </head>
  <body>
  <div class="login-container">
      <h2>用户登录</h2>
  
      <%
          // 如果有错误消息则显示
          if (request.getAttribute("errorMessage") != null) {
      %>
      <p class="error-message"><%= request.getAttribute("errorMessage") %></p>
      <%
          }
      %>
  
      <form action="login" method="post">
          <div>
              <label for="username">用户名:</label>
              <input type="text" id="username" name="username" required>
          </div>
          <div>
              <label for="password">密码:</label>
              <input type="password" id="password" name="password" required>
          </div>
          <div>
              <input type="checkbox" name="rememberMe"> 记住我
          </div>
          <div>
              <button type="submit">登录</button>
          </div>
      </form>
  
      <div class="footer">© 2024 你的公司名 - 保留所有权利</div>
  </div>
  </body>
  </html>
  ```
  
  
  
- 创建主页面

  在 `src/main/webapp` 目录下创建 `home.jsp` 页面：

  ```java
  <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
  <%@ page import="jakarta.servlet.http.HttpSession" %>
  <!DOCTYPE html>
  <html lang="zh">
  <head>
    <meta charset="UTF-8">
    <title>首页</title>
  </head>
  <body>
  <%
    // 直接使用内置的 session 对象
    String username = (String) session.getAttribute("user");
  
    // 如果用户未登录，重定向到登录页面
    if (username == null) {
      response.sendRedirect("login.jsp");
      return;
    }
  %>
  
  <h1>欢迎，<%= username %> 用户！</h1>
  
  <!-- 登出链接 -->
  <p>
    <a href="logout">退出登录</a>
  </p>
  
  <%
    // 显示注销消息
    String logoutMessage = request.getParameter("logout");
    if ("true".equals(logoutMessage)) {
  %>
  <p style="color: green;">您已成功注销。</p>
  <%
    }
  %>
  
  </body>
  </html>
  
  ```

- 处理登录请求

  创建一个 Servlet 来处理登录逻辑 `LoginServlet.java`

  ```java
  package com.itheima.test;
  
  import jakarta.servlet.ServletException;
  import jakarta.servlet.annotation.WebServlet;
  import jakarta.servlet.http.HttpServlet;
  import jakarta.servlet.http.HttpServletRequest;
  import jakarta.servlet.http.HttpServletResponse;
  import jakarta.servlet.http.HttpSession;
  
  import java.io.IOException;
  
  @WebServlet("/login")
  public class LoginServlet extends HttpServlet {
      @Override
      protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
          // 获取表单数据
          String username = req.getParameter("username");
          String password = req.getParameter("password");
  
          // 登录验证逻辑
          if ("admin".equals(username) && "123456".equals(password)) {
              // 登录成功，将用户信息存储在session中
              HttpSession session = req.getSession();
              session.setAttribute("user", username);
  
              resp.sendRedirect(req.getContextPath() + "/home.jsp");
          } else {
              // 登录失败，设置错误消息
              req.setAttribute("errorMessage", "账户名或者密码错误，请重新检查登录");
              // 转发回登录页面，显示错误消息
              req.getRequestDispatcher("/login.jsp").forward(req, resp);
          }
      }
  
      @Override
      protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
          // 对于GET请求，转发到登录页面
          request.getRequestDispatcher("/login.jsp").forward(request, response);
      }
  }
  ```
  
- 处理登出请求

  创建一个 Servlet 来处理登录逻辑 `LogoutServlet.java`

  ```java
  package com.itheima.test;
  
  import jakarta.servlet.ServletException;
  import jakarta.servlet.annotation.WebServlet;
  import jakarta.servlet.http.HttpServlet;
  import jakarta.servlet.http.HttpServletRequest;
  import jakarta.servlet.http.HttpServletResponse;
  import jakarta.servlet.http.HttpSession;
  
  import java.io.IOException;
  import java.util.logging.Level;
  import java.util.logging.Logger;
  
  @WebServlet("/logout")
  public class LogoutServlet extends HttpServlet {
      private static final Logger LOGGER = Logger.getLogger(LogoutServlet.class.getName());
  
      @Override
      protected void doGet(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
          HttpSession session = request.getSession(false);
  
          if (session != null) {
              String username = (String) session.getAttribute("user");
              session.invalidate(); // 使会话失效
              LOGGER.log(Level.INFO, "用户 {0} 已注销.", username); // 记录注销信息
          }
  
          // 增加一个重定向的退出消息
          response.sendRedirect("login.jsp?logout=true");
      }
  
      // 如果你需要处理 POST 请求，可以添加此方法
      @Override
      protected void doPost(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
          doGet(request, response);
      }
  }
  ```
  
  - 结果展示
  
    ![](./Login%20sucess.png)
  
    ![](./Login%20in.png)
  
    ![](./Login%20fail.png)
  
  ### **三**、问题与思考
  
  1. 设计过滤器的位置十分重要，一定要先想清楚放行前后的数据
  2. 还未尝试添加验证码功能，后续补充
  3. `Cookie`,`Session`都是完成一次会话内多次请求间的数据共享，需要分清楚其区别

