package com.jdbc.jdbcdemo2.Bulk;

import java.sql.*;
import java.time.LocalDate;

public class BulkUpdates {
    private static final String URL = "jdbc:mysql://localhost:3306/jdbc_demo?serverTimezone=GMT&characterEncoding=UTF-8";
    private static final String USER = "root";
    private static final String PASSWORD = "123456";
    private static final String UPDATE_SQL = "UPDATE teacher SET birthday = ? WHERE id = ?";

    public static void main(String[] args) {
        try(Connection conn = DriverManager.getConnection(URL,USER,PASSWORD);){
            conn.setAutoCommit(false);
            try(PreparedStatement ps = conn.prepareStatement(UPDATE_SQL)){
                LocalDate startDate = LocalDate.parse("2023-01-01");

                for (int i = 1; i <=20 ; i++) {
                    LocalDate newBirthday = startDate.plusDays(i-1);
                    ps.setDate(1, Date.valueOf(newBirthday));
                    ps.setInt(2,i);
                    //添加到批处理
                    ps.addBatch();
                    // 每 20 条执行一次批处理并提交
                    if (i % 20 == 0) {
                        ps.executeBatch(); // 执行批处理
                        conn.commit();
                    }
                }
                //更新剩余的记录,不足20条的批次
                ps.executeBatch();
                conn.commit();
            } catch (SQLException e) {
                conn.rollback(); // 如果出错则回滚事务
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}