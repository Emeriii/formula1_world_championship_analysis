-- Raw/core row counts should match for each entity.
SELECT 'drivers' AS entity,
 (SELECT COUNT(*) FROM raw.drivers) AS raw_rows,
 (SELECT COUNT(*) FROM core.drivers) AS core_rows
UNION ALL SELECT 'circuits',
 (SELECT COUNT(*) FROM raw.circuits), (SELECT COUNT(*) FROM core.circuits)
UNION ALL SELECT 'races',
 (SELECT COUNT(*) FROM raw.races), (SELECT COUNT(*) FROM core.races)
UNION ALL SELECT 'results',
 (SELECT COUNT(*) FROM raw.results), (SELECT COUNT(*) FROM core.results);

-- All three point totals should match.
SELECT
 (SELECT SUM(points::numeric) FROM raw.results) AS raw_points,
 (SELECT SUM(points) FROM core.results) AS core_points,
 (SELECT SUM(recorded_race_points) FROM mart.driver_season_summary) AS mart_points;

-- Country totals must account for all 1125 races.
WITH country_totals AS (
 SELECT c.country, COUNT(*) AS total_races
 FROM core.races r JOIN core.circuits c ON r.circuit_id = c.circuit_id
 GROUP BY c.country
)
SELECT SUM(total_races) AS accounted_for_races FROM country_totals;
