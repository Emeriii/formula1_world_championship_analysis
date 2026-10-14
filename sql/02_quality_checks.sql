-- Expected counts: circuits 77, drivers 861, races 1125, results 26759.
SELECT 'circuits' AS entity, COUNT(*) AS loaded_rows FROM raw.circuits
UNION ALL SELECT 'drivers', COUNT(*) FROM raw.drivers
UNION ALL SELECT 'races', COUNT(*) FROM raw.races
UNION ALL SELECT 'results', COUNT(*) FROM raw.results;

-- Missing, repeated and non-digit IDs: each query should return no rows.
WITH ids AS (
 SELECT 'circuits' AS entity, circuit_id AS id FROM raw.circuits
 UNION ALL SELECT 'drivers', driver_id FROM raw.drivers
 UNION ALL SELECT 'races', race_id FROM raw.races
 UNION ALL SELECT 'results', result_id FROM raw.results
)
SELECT entity, id, COUNT(*) AS occurrences
FROM ids GROUP BY entity, id
HAVING id IS NULL OR TRIM(id) = '' OR TRIM(id) !~ '^[0-9]+$' OR COUNT(*) > 1;

SELECT COUNT(*) AS drivers,
 COUNT(*) FILTER (WHERE number IS NULL) AS missing_numbers,
 COUNT(*) FILTER (WHERE code IS NULL) AS missing_codes,
 COUNT(*) FILTER (WHERE dob IS NULL OR TRIM(dob) = '') AS missing_dob,
 MIN(TRIM(dob)::date) AS earliest_birth_date,
 MAX(TRIM(dob)::date) AS latest_birth_date,
 COUNT(*) FILTER (WHERE TRIM(dob)::date > CURRENT_DATE) AS future_birth_dates
FROM raw.drivers;

SELECT COUNT(*) AS races, MIN(year::integer) AS first_year,
 MAX(year::integer) AS last_year FROM raw.races;

-- Each unmatched-reference query should return no rows.
SELECT r.race_id, r.circuit_id FROM raw.races r
LEFT JOIN raw.circuits c ON TRIM(r.circuit_id) = TRIM(c.circuit_id)
WHERE c.circuit_id IS NULL;

SELECT res.result_id, res.race_id, res.driver_id FROM raw.results res
LEFT JOIN raw.races r ON res.race_id::integer = r.race_id::integer
LEFT JOIN raw.drivers d ON res.driver_id::integer = d.driver_id::integer
WHERE r.race_id IS NULL OR d.driver_id IS NULL;

-- Investigation, not an automatic deletion rule.
SELECT race_id, driver_id, COUNT(*) AS occurrences
FROM raw.results GROUP BY race_id, driver_id
HAVING COUNT(*) > 1 ORDER BY occurrences DESC, race_id, driver_id;
