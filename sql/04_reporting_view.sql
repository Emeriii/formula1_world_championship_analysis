CREATE VIEW mart.driver_season_summary AS
SELECT r.year AS season, d.driver_id,
 d.forename || ' ' || d.surname AS driver_name, d.nationality,
 COUNT(*) AS result_entries,
 COUNT(DISTINCT res.race_id) AS races_with_results,
 SUM(res.points) AS recorded_race_points
FROM core.results res
JOIN core.races r ON res.race_id = r.race_id
JOIN core.drivers d ON res.driver_id = d.driver_id
GROUP BY r.year, d.driver_id, d.forename, d.surname, d.nationality;
