package com.jdbc.jdbcdemo2.ResultSet;

import java.sql.*;

public class Scrollable {
    private static final String URL = "jdbc:mysql://localhost:3306/jdbc_demo?serverTimezone=GMT&characterEncoding=UTF-8";
    private static final String USER = "root";
    private static final String PASSWORD = "123456";
    private static final String SQL = "SELECT id, name, course, birthday FROM teacher"; // 选择需要的字段

    public static void main(String[] args) {
        try(Connection conn = DriverManager.getConnection(URL,USER,PASSWORD);){
            //创建可滚动的Statement
            try(Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY)){
                ResultSet rs = stmt.executeQuery(SQL);

                //移动到最后一条记录
                if(rs.last()){
                    //获取倒数第二条记录
                    rs.previous();//移动到倒数第二条记录

                    //提取数据并打印
                    int id = rs.getInt("id");
                    String name = rs.getString("name");
                    String course = rs.getString("course");
                    String birthday =rs.getDate("birthday").toString();

                    System.out.println("倒数第二条记录： ");
                    System.out.println("ID: " + id);
                    System.out.println("Name: " + name);
                    System.out.println("Course: " + course);
                    System.out.println("Birthday: " + birthday);
                }
            } catch (SQLException E) {
                E.printStackTrace();
            }
        } catch (SQLException E) {
            E.printStackTrace();
        }
    }
}
