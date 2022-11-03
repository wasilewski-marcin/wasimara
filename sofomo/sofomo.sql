WITH map_distinct AS (
  SELECT DISTINCT
    m.dimension_1,
    m.correct_dimension_2
  FROM sofomo.map AS m
),

corrected AS (
  SELECT DISTINCT
    a.dimension_1,
    m.correct_dimension_2 AS dimension_2,
    a.measure_1,
    0 AS measure_2
  FROM
    sofomo.a AS a
  INNER JOIN map_distinct AS m
    ON a.dimension_1 = m.dimension_1

  UNION ALL

  SELECT DISTINCT
    b.dimension_1,
    m.correct_dimension_2 AS dimension_2,
    0 AS measure_1,
    b.measure_2
  FROM
    sofomo.b AS b
  INNER JOIN map_distinct AS m
    ON b.dimension_1 = m.dimension_1
)

SELECT
  dimension_1,
  dimension_2,
  COALESCE(SUM(measure_1), 0) AS measure_1,
  COALESCE(SUM(measure_2), 0) AS measure_2
FROM corrected
GROUP BY
  dimension_1,
  dimension_2
