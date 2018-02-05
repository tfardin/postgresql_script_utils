SELECT row_number, ordinal_position, x as valor, column_name
FROM (
  SELECT n AS row_number, x AS row_value,
         (INFORMATION_SCHEMA._PG_EXPANDARRAY(
               ('{'||
                 REGEXP_REPLACE(
                   REGEXP_REPLACE(x::VARCHAR, ',(?=,)', ',""', 'gi'),
                   E'^\\(|\\)$', '', 'gi'
                 )||'}'
               )::VARCHAR[])
         ).*
  FROM INFORMATION_SCHEMA._PG_EXPANDARRAY(ARRAY(
    SELECT table_test
    FROM table_test)) AS arr
) AS tpc
JOIN (
  SELECT column_name, ordinal_position
  FROM information_schema.columns
  WHERE (table_schema = 'public')
    AND (table_name = 'table_test')
) AS cln
ON (cln.ordinal_position = tpc.n)
order by row_number, ordinal_position