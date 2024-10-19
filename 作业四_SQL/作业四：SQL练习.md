# 作业四：SQL练习

学院：省级示范性软件学院
题目：《 作业三：SQL练习》
姓名：罗云平
学号：2200770266
班级：软工2202
日期：2024-10-15

### 一、**SQL查询语句**

1. 建表&插入数据

    [test.sql](test.sql)  

   [emp.sql](emp.sql) 

2. 查询语句

    [demo_employee.sql](demo_employee.sql) 

    [demo_student.sql](demo_student.sql) 

### 二、**问题与思考学习**

- **1**.`case when ... then 1 end`:

  ​    `case` 是一个条件表达式

  ​    `when...then 1 `当条件满足时，返回值为`1`

  ​    `End `结束`case`表达式

-  **2**.`between ... and`是闭区间

- **3**.在 SQL 中，计算百分比时不能直接用列别名（如 `[100-85]`）来代替 `CASE WHEN` 表达式。原因是 SQL 的计算顺序，列别名是在 `SELECT` 语句执行后才被解析的，而在计算的时候，SQL 引擎并不会知道 `[100-85]` 是什么。

- **4**.使用 WITH 子句创建公共表表达式（CTE）

  **基本语法：**

  ```sql
  sqlCopy CodeWITH cte_name AS (
      SELECT ...
  )
  SELECT ...
  FROM cte_name;
  ```

- **5**.`join`和`left join`的区别

  `join`:

  - 只返回两个表中匹配的行。
  - 如果一个表中有某些行在另一个表中没有对应的行，这些不匹配的行将不会出现在结果集中。

  `left join`:

  - 返回左侧表中的所有行，以及右侧表中匹配的行。如果右侧表中没有匹配的行，则结果中的相应列将返回 `NULL`。
  - 这使得 `LEFT JOIN` 可以保留左侧表中的所有信息，不论右侧表是否有匹配数据。

- **6.**窗口函数

  窗口函数用于处理数据行的子集，通常与`OVER`子句一起使用，允许对数据集的特定部分进行计算，而不会聚合它们。窗口函数可以执行各种操作，如**计算运行总和、排名、领先/滞后值**等。

  1. `ROW_NUMBER`: 为每个行分配一个唯一的连续整数。
  2. `RANK`: 为每个行分配一个排名，相同值的行会有相同的排名，排名之间会有间隔。
  3. `DENSE_RANK`: 类似于`RANK`，但排名之间不会有间隔。
  4. `LEAD`: 返回当前行之后的下一行的值。
  5. `LAG`: 返回当前行之前的上一行的值。
  6. `SUM`: 计算特定窗口内的总和。
  7. `AVG`: 计算特定窗口内的平均值。

  窗口函数的`OVER`子句定义了窗口的规则，例如：

  - `PARTITION BY`: 将数据分成多个独立的窗口进行计算。
  - `ORDER BY`: 定义窗口内的排序方式。
  - `ROWS`或`RANGE`: 定义窗口的大小和范围。

  示例：

  ```sql
  SELECT employee_id, salary,
         RANK() OVER (ORDER BY salary DESC) AS salary_rank
  FROM employees;
  ```

  在这个例子中，`RANK()`窗口函数为每个员工的工资分配一个排名，按照工资的降序排列。

- **7.**聚合函数与窗口函数的区别：

  - **聚合函数**：将多行合并为一个值，不保留原始行。
  - **窗口函数**：对数据集的子集进行计算，同时保留原始行。

  聚合函数通常用于生成汇总数据，而窗口函数则用于生成每行的附加信息，而不会丢失原始数据的任何行。

- **8.**`TIMESTAMPDIFF()` 是 MySQL 中的一个函数，用于计算两个日期之间的差异。这个函数的语法如下：

  ```sql
  TIMESTAMPDIFF(unit, datetime1, datetime2)
  ```

  - `unit`：指定返回差异的单位，例如 DAY、MONTH、YEAR 等。

  - `datetime1` 和 `datetime2`：指定要比较的两个日期时间值。

    以下是一些使用 `TIMESTAMPDIFF()` 函数的例子：

    1. 计算两个日期之间的天数差异：

    ```sql
    SELECT TIMESTAMPDIFF(DAY, '2023-01-01', '2023-01-31');
    ```

    1. 计算两个日期之间的月数差异：

    ```sql
    SELECT TIMESTAMPDIFF(MONTH, '2023-01-01', '2023-12-01');
    ```

    1. 计算两个日期之间的年数差异：

    ```sql
    SELECT TIMESTAMPDIFF(YEAR, '2000-01-01', '2010-01-01');
    ```

- **9.**不能同时使用 `GROUP BY` 和窗口函数 `DENSE_RANK()`，因为窗口函数是在 `GROUP BY` 之后计算的.

- **10.**`DATE_ADD(date, INTERVAL value unit)`:

  - `date`: 要进行加法运算的原始日期。
  - `value`: 要增加的数量，可以是整数或浮点数。
  - `unit`:: 时间单位，指示`value`的单位。常用的单位包括：
    - `SECOND`: 秒
    - `MINUTE`: 分钟
    - `HOUR`: 小时
    - `DAY`: 天
    - `WEEK`: 星期
    - `MONTH`: 月
    - `QUARTER`: 季度
    - `YEAR`: 年

- **11.**`ROW_NUMBER()` 是一个窗口函数，用于为结果集中的每一行分配一个唯一的编号。该编号是基于某种排序规则，它在同一分区内是唯一的。在 MySQL 中，可以使用 `ROW_NUMBER()` 来实现许多传统的 SQL 查询或报表功能，例如获取分组的前 N 条记录。

