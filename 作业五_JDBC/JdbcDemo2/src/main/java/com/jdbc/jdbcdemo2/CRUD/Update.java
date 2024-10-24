package com.jdbc.jdbcdemo2.CRUD;

import java.sql.*;

public class Update {
    private static final String URL = "jdbc:mysql://localhost:3306/jdbc_demo?serverTimezone=GMT&characterEncoding=UTF-8";
    private static final String USER = "root";
    private static final String PASSWORD = "123456";
    private static final String SQL = "UPDATE teacher SET birthday = ? WHERE name = ?";

    public static void main(String[] args) {
        try(Connection conn = DriverManager.getConnection(URL,USER,PASSWORD);){
            conn.setAutoCommit(false);
            try(PreparedStatement ps = conn.prepareStatement(SQL)){
                //设置参数
                ps.setDate(1, Date.valueOf("1990-01-01"));
                ps.setString(2,"Zhao");
                //执行插入或更新
                ps.executeUpdate();
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
