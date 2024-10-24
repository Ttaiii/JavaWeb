package com.jdbc.jdbcdemo2.CRUD;

import java.sql.*;

public class Retrieve {
    private static final String URL = "jdbc:mysql://localhost:3306/jdbc_demo?serverTimezone=GMT&characterEncoding=UTF-8";
    private static final String USER = "root";
    private static final String PASSWORD = "123456";
    private static final String SQL = "select id,name,course,birthday from teacher where name=?;";

    public static void main(String[] args) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try{
            //0.加载数据库驱动
            Class.forName("com.mysql.cj.jdbc.Driver");
            //1.连接数据库
            conn = DriverManager.getConnection(URL,USER,PASSWORD);
            //2.创建预处理语句
            ps = conn.prepareStatement(SQL);
            ps.setString(1,"Ding");
            //3.执行SQL语句
            rs = ps.executeQuery();
            //4.遍历查询结果
            while(rs.next()){
                System.out.println(" id: " + rs.getInt(1));
                System.out.println(" name: " + rs.getString("name"));
                System.out.println(" course: " + rs.getString("course"));
                System.out.println(" birthday: " + rs.getObject(4));
            }
        }catch (SQLException e) {
            throw new RuntimeException(e);
        } catch (RuntimeException runtimeException) {
            throw new RuntimeException(runtimeException);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        } finally {
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
            }
            if (ps != null) {
                try {
                    ps.close();
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
            }
        }

    }
}


