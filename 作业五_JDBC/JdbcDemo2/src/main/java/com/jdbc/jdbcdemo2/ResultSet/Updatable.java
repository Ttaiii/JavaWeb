package com.jdbc.jdbcdemo2.ResultSet;

import java.sql.*;
import java.util.Scanner;

public class Updatable {
    private static final String URL = "jdbc:mysql://localhost:3306/jdbc_demo?serverTimezone=GMT&characterEncoding=UTF-8";
    private static final String USER = "root";
    private static final String PASSWORD = "123456";
    private static final String SQL = "SELECT id, name, course, birthday FROM teacher"; // 选择需要的字段

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD)) {
            // 创建可更新的 Statement
            try (Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE)) {
                ResultSet rs = stmt.executeQuery(SQL);

                // 显示所有结果
                System.out.println("教师记录：");
                while (rs.next()) {
                    System.out.println("ID: " + rs.getInt("id") +
                            ", Name: " + rs.getString("name") +
                            ", Course: " + rs.getString("course") +
                            ", Birthday: " + rs.getDate("birthday"));
                }

                // 让用户选择要更新的记录
                System.out.print("请输入要更新的教师的 ID：");
                int idToUpdate = scanner.nextInt();
                scanner.nextLine(); // 清空缓存
                System.out.print("请输入新的课程名称：");
                String newCourse = scanner.nextLine();

                // 移动结果集到开头以查找指定 ID 的记录
                boolean found = false;
                rs.beforeFirst(); // 重新定位到结果集的开始
                while (rs.next()) {
                    if (rs.getInt("id") == idToUpdate) {
                        found = true;
                        // 更新课程名称
                        rs.updateString("course", newCourse);
                        rs.updateRow(); // 提交更新
                        System.out.println("记录已更新！");

                        // 输出更新后的记录
                        System.out.println("更新后的记录：");
                        System.out.println("ID: " + rs.getInt("id") +
                                ", Name: " + rs.getString("name") +
                                ", Course: " + rs.getString("course") +
                                ", Birthday: " + rs.getDate("birthday"));
                        break;
                    }
                }

                if (!found) {
                    System.out.println("未找到 ID 为 " + idToUpdate + " 的记录。");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            scanner.close();
        }
    }
}
