# 作业三：Listener练习

学院：省级示范性软件学院
题目：《 作业二：Listener练习》
姓名：罗云平
学号：2200770266
班级：软工2202
日期：2024-10-4

### 一、实现 `ServletRequestListener`

**创建ServletRequestListener接口的类：**

```java
// 注解这个类是一个监听器
@WebListener
public class RequestLoggingListener implements ServletRequestListener {

    private static final Logger logger = Logger.getLogger(RequestLoggingListener.class.getName());

    @Override
    public void requestInitialized(ServletRequestEvent sre) {
        // 转换为 HttpServletRequest
        HttpServletRequest request = (HttpServletRequest) sre.getServletRequest();

        // 加载资源
        // 记录请求开始时间
        sre.getServletRequest().setAttribute("startTime", System.currentTimeMillis());

        // 获取客户端IP地址
        String clientIp = sre.getServletRequest().getRemoteAddr();

        // 获取请求方法，eg:Get,Post
        String method = ((HttpServletRequest) sre.getServletRequest()).getMethod();

        // 获取请求URL
        String requestUri = ((HttpServletRequest) sre.getServletRequest()).getRequestURI();

        // 获取查询字符串
        String queryString = ((HttpServletRequest) sre.getServletRequest()).getQueryString();

        // 获取用户代理信息，eg:浏览器和OS的信息
        String userAgent = ((HttpServletRequest) sre.getServletRequest()).getHeader("User-Agent");

        // 记录请求开始信息
        logger.info(String.format("Request started: %s %s, Client IP: %s, User-Agent: %s",
                method, requestUri, clientIp, userAgent));
    }

    // 请求销毁
    @Override
    public void requestDestroyed(ServletRequestEvent sre) {
        // 转换为 HttpServletRequest
        HttpServletRequest request = (HttpServletRequest) sre.getServletRequest();

        // 计算处理时间
        long startTime = (Long) sre.getServletRequest().getAttribute("startTime");
        long duration = System.currentTimeMillis() - startTime;

        // 记录请求结束时间和处理时间
        String method = ((HttpServletRequest) sre.getServletRequest()).getMethod();
        String requestUri = ((HttpServletRequest) sre.getServletRequest()).getRequestURI();

        // 记录请求结束信息
        logger.info(String.format("Request completed: %s %s, Duration: %d ms",
                method, requestUri, duration));
    }
}


```



### 二、创建测试用例

用于验证日志记录功能

```java
@WebServlet("/test")
public class TestServlet extends HttpServlet {
    // 重写 doGet 方法，处理 HTTP GET 请求
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.getWriter().write("Test Servlet Response");

    }
}
```



### 三、配置日志记录

将日志输出到控制台或文件，使用 Java Util Logging 的配置文件 `logging.properties`：

```java
handlers= java.util.logging.FileHandler, java.util.logging.ConsoleHandler
.level= INFO

# File handler configuration
java.util.logging.FileHandler.pattern = logs/app.log
java.util.logging.FileHandler.limit = 50000
java.util.logging.FileHandler.count = 1
java.util.logging.FileHandler.formatter = java.util.logging.SimpleFormatter

# Console handler configuration
java.util.logging.ConsoleHandler.level = INFO
```

在应用启动时加载该配置。在 `web.xml` 中指定系统属性：

```java
    <context-param>
        <param-name>java.util.logging.config.file</param-name>
        <param-value>/path/to/logging.properties</param-value>
    </context-param>
```

### 四、思考与注意事项

1. `ServletRequest` 接口没有 `getMethod()`等方法。这些方法属于 `HttpServletRequest` 接口，因此需要将 `sre.getServletRequest()` 转换为 `HttpServletRequest`

2. 防止日志文件过大，可以实施轮换策略和定期清理日志文件

   
