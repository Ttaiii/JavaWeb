package com.jdbc.jdbcdemo2.CRUD;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class Delete {
    private static final String URL = "jdbc:mysql://localhost:3306/jdbc_demo?serverTimezone=GMT&characterEncoding=UTF-8";
    private static final String USER = "root";
    private static final String PASSWORD = "123456";
    private static final String SQL = "Delete from teacher where name = ? ";

    public static void main(String[] args) {
        try(Connection conn = DriverManager.getConnection(URL,USER,PASSWORD);){
            conn.setAutoCommit(false);
            try(PreparedStatement ps = conn.prepareStatement(SQL)){
                //设置参数
                ps.setString(1,"Ding");
                //执行删除操作
                ps.executeUpdate();
                conn.commit();;
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
