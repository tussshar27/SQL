A recursive CTE:
Starts from first row
Then moves to the next row
Remembers previous row’s value
Compares current vs previous
Repeats until table ends.

Read row 1 → go to row 2 → go to row 3 → …

#Eg 1:
WITH RECURSIVE emp_hierarchy AS (
    -- Anchor query (top-level employee)
    SELECT 
        emp_id,
        emp_name,
        manager_id,
        1 AS level
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive query
    SELECT
        e.emp_id,
        e.emp_name,
        e.manager_id,
        eh.level + 1 AS level
    FROM employees e
    JOIN emp_hierarchy eh
        ON e.manager_id = eh.emp_id
)
SELECT * FROM emp_hierarchy
ORDER BY level;


#Eg 2:
input: We have one column with numbers, ordered by id.
| id | val |
| -- | --- |
| 1  | 10  |
| 2  | 10  |
| 3  | 20  |
| 4  | 20  |
| 5  | 20  |
| 6  | 30  |

to find: We want to find rows where the same value appears in consecutive rows
(10–10, 20–20–20).




















