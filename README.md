# Formula 1 Data Engineering with PostgreSQL

A hands-on SQL learning project using pgAdmin 4 and a historical Formula 1 CSV snapshot. Version 1 focuses on drivers, circuits, races and results: ingestion, quality checks, typed relational modeling and reporting.

## Architecture

CSV → raw (bronze) → core (silver) → mart (gold)

Raw tables hold imported text. Core tables apply types, primary keys, required fields and foreign keys. The reporting view aggregates results to driver-season grain.

## Dataset

Source attachment: `archive 2.zip`, originally downloaded from Kaggle. The archive contains 14 CSVs. Version 1 uses:

| File | Expected rows |
|---|---:|
| drivers.csv | 861 |
| circuits.csv | 77 |
| races.csv | 1,125 |
| results.csv | 26,759 |

Race years span 1950–2024. This is a historical snapshot, not a current feed. Ignore `__MACOSX/` metadata files.

Source: [Formula 1 World Championship (1950–2024), published by Rohan Rao on Kaggle](https://www.kaggle.com/datasets/rohanrao/formula-1-world-championship-1950-2020). The URL retains its original 2020 suffix; the inspected attachment spans through 2024.

Dataset license: not independently verified from the accessible Kaggle page. Consult the dataset page before redistributing data. This repository contains SQL and documentation only; CSVs are excluded.

## Reproduce in a fresh database

1. Create a PostgreSQL database named `f1_engineering` and open its pgAdmin Query Tool.
2. Run `sql/01_raw_tables.sql` once.
3. Extract the source archive. Import each of the four CSVs into its matching raw table using pgAdmin: CSV, UTF-8, Header Yes, comma delimiter, double-quote quote/escape, NULL string `\N`. Match columns by position; the SQL definitions preserve CSV order.
4. Run `sql/02_quality_checks.sql`. Inspect outputs and investigate exceptions; repeated driver/race pairs are not an automatic failure.
5. Run `sql/03_core_tables.sql` once. If it fails, execute `ROLLBACK;`, diagnose the error, then retry. The script converts IDs, dates and numbers and enforces constraints.
6. Run `sql/04_reporting_view.sql` once, then explore `sql/05_analysis.sql`.
7. Run `sql/06_reconciliation.sql`. All row counts and point totals must reconcile; country race totals must equal 1,125.

These creation/load scripts target a fresh database. They are not rerunnable incremental pipelines. Do not run them blindly against the existing learning database, where tables have already been created and populated.

## Validation evidence

User-reported in pgAdmin:
- Drivers: raw/core counts 861/861; missing number/code counts 802/757 preserved.
- Driver IDs: zero missing or duplicated IDs.
- Birth dates: 1896-12-28 to 2005-05-08; zero future dates at the time of checking.
- Races: 1,125 rows spanning 1950–2024, zero missing race/circuit IDs, no duplicate race IDs.
- Circuits and races: raw/core counts 77/77 and 1,125/1,125.
- User reported zero from the results relationship check; confirm both unmatched race and driver counts in final reconciliation notes.
- Repeated result pairs investigated with 12 sample records; retained because they are different records.

Final reconciliation: user confirmed all expected outputs passed on 14 October 2026.
- Raw/core counts matched: drivers 861/861, circuits 77/77, races 1,125/1,125, results 26,759/26,759.
- Raw, core and mart point totals matched (numeric totals were not supplied in chat).
- Country race totals summed to 1,125.

Version 1 learning scope is complete. Validation was performed by the user in pgAdmin; the packaged fresh-database scripts have not been independently rerun end to end.

Packaged scripts have not been executed by the assistant against a PostgreSQL instance. The learning database was operated by the user in pgAdmin.

## Analyses

- Driver counts by nationality.
- Top 10 drivers by recorded race points in 2023.
- Race counts by circuit country.
- Top 10 drivers by recorded race points at circuits in Italy (user-authored SQL).

## Next version

Add constructors/status, qualifying, sprints, laps and pit stops; strengthen quality rules; introduce batch logging, repeatable loads and automated reconciliation. Build on the same GitHub repository after completing version 1.
