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
  /**
   * 登陆验证的过滤器
   */
  
  @WebFilter("/*")
  public class LoginFilter implements Filter {
      // 判断访问资源路径是否和登陆注册相关
      // 注册页面、登陆页面、公共资源
      private static final List<String> EXCLUDED_PATHS = Arrays.asList("/login.jsp", "/register.jsp", "/public");
  
      @Override
      public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
  
          //这里是ServletRequest，需要向下强转为HttpServletRequest
          HttpServletRequest request = (HttpServletRequest) servletRequest;
  
          //1.判断session中是否有user
          HttpSession session = request.getSession();
          Object user = session.getAttribute("user");
  
          //2.判断是否已登录
          if (isLoggedIn(session)) {
              filterChain.doFilter(servletRequest, servletResponse);
          } else {
              // 检查cookie中是否有登录信息
              String userID = getUSerIDFromCookie(request);
              if (userID != null) {
                  // logined
                  session = request.getSession(true);
                  session.setAttribute("user", userID);
                  // 放行
                  filterChain.doFilter(servletRequest, servletResponse);
              } else {
                  // not logined 跳转到登陆页面
                  request.setAttribute("login_msg", "您尚未登录！");
                  request.getRequestDispatcher("/login.jsp").forward(request, servletResponse);
              }
              //放行
          }
      }
  
      private boolean isLoggedIn(HttpSession session) {
          return session != null && session.getAttribute("user") != null;
      }
  
      private String getUSerIDFromCookie(HttpServletRequest request) {
          // 实现读取 Cookie 的逻辑，返回用户 ID
          return Arrays.stream(request.getCookies())
                  .filter(cookie -> "userId".equals(cookie.getName()))
                  .map(cookie -> cookie.getValue())
                  .findFirst()
                  .orElse(null);
      }
  
      @Override
      public void init(FilterConfig filterConfig) throws ServletException {}
  
      @Override
      public void destroy() {}
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
    <link rel="stylesheet" href="style.css">
  </head>
  <body>
  <div class="login-container">
    <h2>用户登录</h2>
    <form action="login" method="post">
      <label for="username">用户名:</label>
      <input type="text" id="username" name="username" required>
  
      <label for="password">密码:</label>
      <input type="password" id="password" name="password" required>
  
      <input type="checkbox" id="rememberMe" name="rememberMe">
      <label for="rememberMe">记住我</label>
  
      <button type="submit">登录</button>
    </form>
  
    <!-- 显示错误消息 -->
    <c:if test="${not empty error_msg}">
      <p class="error">${error_msg}</p>
    </c:if>
  </div>
  </body>
  </html>
  
  ```

  

- 创建主页面

  在 `src/main/webapp` 目录下创建 `home.jsp` 页面：

  ```java
  <%--
    Created by IntelliJ IDEA.
    User: Taitai
    Date: 2024/10/6
    Time: 16:29
    To change this template use File | Settings | File Templates.
  --%>
  <%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <!DOCTYPE html>
  <html lang="zh">
  <head>
      <meta charset="UTF-8">
      <title>主页</title>
  </head>
  <body>
  <h1>欢迎, ${sessionScope.user}!</h1>
  <a href="logout">退出</a>
  </body>
  </html>
  
  
  ```

  

- 处理登录请求

  创建一个 Servlet 来处理登录逻辑 `LoginServlet.java`

  ```java
  public class LoginServlet extends HttpServlet {
      protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
          // 获取请求参数
          String username = request.getParameter("username");
          String password = request.getParameter("password");
  
          // 验证用户凭证
          if (isValidUser(username, password)) {
              HttpSession session = request.getSession(true);
              session.setAttribute("user", username);
  
              // 如果选中“记住我”
              if ("on".equals(request.getParameter("rememberMe"))) {
                  Cookie cookie = new Cookie("userId", username);
                  cookie.setMaxAge(7 * 24 * 60 * 60); // 7 天
                  cookie.setPath("/"); // 设置路径为根，以便在整个应用中可用
                  response.addCookie(cookie);
              }
  
              response.sendRedirect("home.jsp"); // 登录成功后重定向到主页
          } else {
              // 登录失败，设置错误消息并转发回登录页面
              request.setAttribute("error_msg", "用户名或密码错误");
              request.getRequestDispatcher("/login.jsp").forward(request, response);
          }
      }
  
      private boolean isValidUser(String username, String password) {
          // 这里可以连接数据库进行验证
          return "admin".equals(username) && "password".equals(password); // 示例
      }
  }
  
  ```

  

- 处理登出请求

  创建一个 Servlet 来处理登录逻辑 `LogoutServlet.java`

  ```java
  public class LogoutServlet extends HttpServlet {
      protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
          HttpSession session = request.getSession(false);
          if (session != null) {
              session.invalidate(); // 清除 session
          }
  
          // 清除 Cookie
          Cookie cookie = new Cookie("userId", null);
          cookie.setMaxAge(0); // 立即删除
          response.addCookie(cookie);
  
          response.sendRedirect("login.jsp"); // 重定向到登录页面
      }
  
  }
  
  ```

  

  ### **三**、问题与思考
  
  1. 设计过滤器的位置十分重要，一定要先想清楚放行前后的数据
  2. 还未尝试添加验证码功能，后续补充
  3. `Cookie`,`Session`都是完成一次会话内多次请求间的数据共享，需要分清楚其区别

