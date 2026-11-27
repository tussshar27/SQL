1. find missing number 
SELECT t1.id + 1 AS missing_id
FROM table_name t1
LEFT JOIN table_name t2
    ON t1.id + 1 = t2.id
WHERE t2.id IS NULL;