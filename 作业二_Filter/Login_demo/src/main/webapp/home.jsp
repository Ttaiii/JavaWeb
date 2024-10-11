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
