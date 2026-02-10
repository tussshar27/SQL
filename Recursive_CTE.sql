A recursive CTE:
Starts from one row
Then moves to the next row
Remembers previous row’s value
Compares current vs previous
Repeats until table ends


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
