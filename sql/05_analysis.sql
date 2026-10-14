-- Driver counts by nationality.
SELECT nationality, COUNT(*) AS driver_count FROM core.drivers
GROUP BY nationality ORDER BY driver_count DESC;

-- Top 10 drivers by recorded race points in 2023 (excludes sprint results).
SELECT driver_name, races_with_results, recorded_race_points
FROM mart.driver_season_summary WHERE season = 2023
ORDER BY recorded_race_points DESC, driver_id LIMIT 10;

-- Races by circuit country; no results join, so races aren't multiplied.
SELECT c.country, COUNT(r.race_id) AS total_races
FROM core.races r JOIN core.circuits c ON r.circuit_id = c.circuit_id
GROUP BY c.country ORDER BY total_races DESC, c.country;

-- User-authored analysis: recorded race points at circuits in Italy.
SELECT d.driver_id, d.forename || ' ' || d.surname AS driver_name,
 COUNT(DISTINCT res.race_id) AS races_with_results,
 SUM(res.points) AS total_points
FROM core.results res
JOIN core.drivers d ON res.driver_id = d.driver_id
JOIN core.races r ON res.race_id = r.race_id
JOIN core.circuits c ON r.circuit_id = c.circuit_id
WHERE c.country = 'Italy'
GROUP BY d.driver_id, d.forename, d.surname
ORDER BY total_points DESC, d.driver_id LIMIT 10;
