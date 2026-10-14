-- Run once after importing and checking all four raw tables.
-- Any failure: run ROLLBACK, resolve the issue, then retry.
BEGIN;

CREATE TABLE core.drivers (
    driver_id integer PRIMARY KEY,
    driver_ref text NOT NULL,
    number integer,
    code text,
    forename text NOT NULL,
    surname text NOT NULL,
    dob date NOT NULL,
    nationality text,
    url text
);

INSERT INTO core.drivers (driver_id, driver_ref, number, code, forename, surname, dob, nationality, url)
SELECT
    NULLIF(TRIM(driver_id), '')::integer,
    NULLIF(TRIM(driver_ref), ''),
    NULLIF(TRIM(number), '')::integer,
    NULLIF(TRIM(code), ''),
    NULLIF(TRIM(forename), ''),
    NULLIF(TRIM(surname), ''),
    NULLIF(TRIM(dob), '')::date,
    NULLIF(TRIM(nationality), ''),
    NULLIF(TRIM(url), '')
FROM raw.drivers;

CREATE TABLE core.circuits (
    circuit_id integer PRIMARY KEY,
    circuit_ref text NOT NULL,
    name text NOT NULL,
    location text,
    country text,
    latitude numeric,
    longitude numeric,
    altitude integer,
    url text
);

INSERT INTO core.circuits (circuit_id, circuit_ref, name, location, country, latitude, longitude, altitude, url)
SELECT
    NULLIF(TRIM(circuit_id), '')::integer,
    NULLIF(TRIM(circuit_ref), ''),
    NULLIF(TRIM(name), ''),
    NULLIF(TRIM(location), ''),
    NULLIF(TRIM(country), ''),
    NULLIF(TRIM(lat), '')::numeric,
    NULLIF(TRIM(lng), '')::numeric,
    NULLIF(TRIM(alt), '')::integer,
    NULLIF(TRIM(url), '')
FROM raw.circuits;

CREATE TABLE core.races (
    race_id integer PRIMARY KEY,
    year integer NOT NULL,
    round integer NOT NULL CHECK (round > 0),
    circuit_id integer NOT NULL REFERENCES core.circuits(circuit_id),
    name text NOT NULL,
    race_date date NOT NULL,
    race_time time,
    url text
);

INSERT INTO core.races (race_id, year, round, circuit_id, name, race_date, race_time, url)
SELECT
    NULLIF(TRIM(race_id), '')::integer,
    NULLIF(TRIM(year), '')::integer,
    NULLIF(TRIM(round), '')::integer,
    NULLIF(TRIM(circuit_id), '')::integer,
    NULLIF(TRIM(name), ''),
    NULLIF(TRIM(date), '')::date,
    NULLIF(TRIM(time), '')::time,
    NULLIF(TRIM(url), '')
FROM raw.races;

CREATE TABLE core.results (
    result_id integer PRIMARY KEY,
    race_id integer NOT NULL REFERENCES core.races(race_id),
    driver_id integer NOT NULL REFERENCES core.drivers(driver_id),
    constructor_id integer NOT NULL,
    number integer,
    grid integer,
    position integer,
    position_text text,
    position_order integer,
    points numeric NOT NULL,
    laps integer,
    time text,
    milliseconds bigint,
    fastest_lap integer,
    rank integer,
    fastest_lap_time text,
    fastest_lap_speed numeric,
    status_id integer NOT NULL
);

INSERT INTO core.results (result_id, race_id, driver_id, constructor_id, number, grid, position, position_text, position_order, points, laps, time, milliseconds, fastest_lap, rank, fastest_lap_time, fastest_lap_speed, status_id)
SELECT
    NULLIF(TRIM(result_id), '')::integer,
    NULLIF(TRIM(race_id), '')::integer,
    NULLIF(TRIM(driver_id), '')::integer,
    NULLIF(TRIM(constructor_id), '')::integer,
    NULLIF(TRIM(number), '')::integer,
    NULLIF(TRIM(grid), '')::integer,
    NULLIF(TRIM(position), '')::integer,
    NULLIF(TRIM(position_text), ''),
    NULLIF(TRIM(position_order), '')::integer,
    NULLIF(TRIM(points), '')::numeric,
    NULLIF(TRIM(laps), '')::integer,
    NULLIF(TRIM(time), ''),
    NULLIF(TRIM(milliseconds), '')::bigint,
    NULLIF(TRIM(fastest_lap), '')::integer,
    NULLIF(TRIM(rank), '')::integer,
    NULLIF(TRIM(fastest_lap_time), ''),
    NULLIF(TRIM(fastest_lap_speed), '')::numeric,
    NULLIF(TRIM(status_id), '')::integer
FROM raw.results;

COMMIT;
