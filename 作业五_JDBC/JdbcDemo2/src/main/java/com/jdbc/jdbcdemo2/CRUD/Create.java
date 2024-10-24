package com.jdbc.jdbcdemo2.CRUD;

import java.sql.*;

public class Create {

    private static final String URL = "jdbc:mysql://localhost:3306/jdbc_demo?serverTimezone=GMT&characterEncoding=UTF-8";
    private static final String USER = "root";
    private static final String PASSWORD = "123456";
    private static final String SQL = "INSERT INTO teacher(id,name,course,birthday) values(?,?,?,?);";

    public static void main(String[] args) {

        Connection conn = null;
        PreparedStatement ps = null;

        try {

            // 0.加载数据库驱动
            Class.forName("com.mysql.cj.jdbc.Driver");
            // 1.连接数据库
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            // 2.关闭自动提交，启动事务
            conn.setAutoCommit(false);
            // 3.创建预处理语句
            ps = conn.prepareStatement(SQL);
            ps.setInt(1, 3);
            ps.setString(2, "Ding");
            ps.setString(3, "ES");
                // 使用 java.sql.Date 设置日期
            ps.setDate(4,Date.valueOf("2000-01-01"));
            // 4.执行SQL更新
            ps.executeUpdate();
            // 5.手动提交事务
            conn.commit();
        }  catch (Exception e) {
            if(conn != null){
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    throw new RuntimeException(ex);
                }
            }
        } finally {
            if (ps != null) {
                try {
                    ps.close();
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
            }
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
                try {
                    conn.close();
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
            }

            System.out.println("Data inserted successfully!");
        }

    }
}
