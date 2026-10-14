# First-version data model

| Table | Grain / identifier | Relationships |
|---|---|---|
| core.drivers | One driver / driver_id | Referenced by results |
| core.circuits | One circuit / circuit_id | Referenced by races |
| core.races | One race / race_id | circuit_id → circuits |
| core.results | One source result record / result_id | race_id → races; driver_id → drivers |
| mart.driver_season_summary | One driver per season / season + driver_id | Derived view |

Raw tables retain CSV column order with snake_case names and text types.
CSV NULL marker `\N` becomes SQL NULL; retain original CSVs separately.

## Modeling decisions

- Preserve repeated driver/race pairs. The inspected examples have different car numbers, points, positions or lap counts. Historical shared drives explain at least some cases; the sample does not independently validate every repeated pair.
- Do not impose a unique constraint on race_id + driver_id in results.
- Count DISTINCT race_id for races with results; count rows for result entries.
- Points are numeric, preserving fractions. Recorded race points are not final championship totals: sprint results and historical scoring rules are outside this version.
- Duration strings remain text. Use milliseconds for numeric duration analysis where populated; NULL is not zero.
- Birth date, driver reference and driver names are required for this project's core model. Raw inputs remain available when constraints reject rows.
- Race session dates remain in raw.races for future expansion.
- Constructor and status IDs are retained but have no foreign keys until their parent tables are added.
- Circuit country is a source label; country harmonization is outside version 1.

Historical reference: [Official 1951 French Grand Prix results](https://www.formula1.com/en/results/1951/races/104/france/race-result).
