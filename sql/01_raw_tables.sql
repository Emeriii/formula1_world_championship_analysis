-- Run once in a new database. Import CSVs after this script.
CREATE SCHEMA raw;
CREATE SCHEMA core;
CREATE SCHEMA mart;

CREATE TABLE raw.circuits (
    circuit_id text,
    circuit_ref text,
    name text,
    location text,
    country text,
    lat text,
    lng text,
    alt text,
    url text
);

CREATE TABLE raw.drivers (
    driver_id text,
    driver_ref text,
    number text,
    code text,
    forename text,
    surname text,
    dob text,
    nationality text,
    url text
);

CREATE TABLE raw.races (
    race_id text,
    year text,
    round text,
    circuit_id text,
    name text,
    date text,
    time text,
    url text,
    fp1_date text,
    fp1_time text,
    fp2_date text,
    fp2_time text,
    fp3_date text,
    fp3_time text,
    quali_date text,
    quali_time text,
    sprint_date text,
    sprint_time text
);

CREATE TABLE raw.results (
    result_id text,
    race_id text,
    driver_id text,
    constructor_id text,
    number text,
    grid text,
    position text,
    position_text text,
    position_order text,
    points text,
    laps text,
    time text,
    milliseconds text,
    fastest_lap text,
    rank text,
    fastest_lap_time text,
    fastest_lap_speed text,
    status_id text
);
