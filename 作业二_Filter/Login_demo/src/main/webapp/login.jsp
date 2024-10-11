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
