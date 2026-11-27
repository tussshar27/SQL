1. find missing number 
SELECT t1.id + 1 AS missing_id
FROM table_name t1
LEFT JOIN table_name t2
    ON t1.id + 1 = t2.id
WHERE t2.id IS NULL;

2. find employees without a matching department 
SELECT e.*
FROM employees e
LEFT JOIN departments d
    ON e.department_id = d.department_id
WHERE d.department_id IS NULL;

3. find duplicate entries 
SELECT name, COUNT(*) AS duplicate_count
FROM employees
GROUP BY name
HAVING COUNT(*) > 1;

alternative:
SELECT *
FROM (
    SELECT *,
           COUNT(*) OVER (
               PARTITION BY name
           ) AS cnt
    FROM employees
) t
WHERE cnt > 1;
