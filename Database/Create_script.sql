-- odeberu pokud existuje funkce na oodebrání tabulek a sekvencí
DROP FUNCTION IF EXISTS remove_all();

-- vytvořím funkci která odebere tabulky a sekvence
-- chcete také umět psát PLSQL? Zapište si předmět BI-SQL ;-)
CREATE or replace FUNCTION remove_all() RETURNS void AS $$
DECLARE
    rec RECORD;
    cmd text;
BEGIN
    cmd := '';

    FOR rec IN SELECT
            'DROP SEQUENCE ' || quote_ident(n.nspname) || '.'
                || quote_ident(c.relname) || ' CASCADE;' AS name
        FROM
            pg_catalog.pg_class AS c
        LEFT JOIN
            pg_catalog.pg_namespace AS n
        ON
            n.oid = c.relnamespace
        WHERE
            relkind = 'S' AND
            n.nspname NOT IN ('pg_catalog', 'pg_toast') AND
            pg_catalog.pg_table_is_visible(c.oid)
    LOOP
        cmd := cmd || rec.name;
    END LOOP;

    FOR rec IN SELECT
            'DROP TABLE ' || quote_ident(n.nspname) || '.'
                || quote_ident(c.relname) || ' CASCADE;' AS name
        FROM
            pg_catalog.pg_class AS c
        LEFT JOIN
            pg_catalog.pg_namespace AS n
        ON
            n.oid = c.relnamespace WHERE relkind = 'r' AND
            n.nspname NOT IN ('pg_catalog', 'pg_toast') AND
            pg_catalog.pg_table_is_visible(c.oid)
    LOOP
        cmd := cmd || rec.name;
    END LOOP;

    EXECUTE cmd;
    RETURN;
END;
$$ LANGUAGE plpgsql;
-- zavolám funkci co odebere tabulky a sekvence - Mohl bych dropnout celé schéma a znovu jej vytvořit, použíjeme však PLSQL
select remove_all();

CREATE TABLE droid (
    id_droid SERIAL NOT NULL,
    name VARCHAR(256) NOT NULL,
    type VARCHAR(256)
);
ALTER TABLE droid ADD CONSTRAINT pk_droid PRIMARY KEY (id_droid);

CREATE TABLE era (
    id_era SERIAL NOT NULL,
    name VARCHAR(256) NOT NULL,
    start_year INTEGER NOT NULL,
    end_year INTEGER
);
ALTER TABLE era ADD CONSTRAINT pk_era PRIMARY KEY (id_era);

CREATE TABLE event (
    id_event SERIAL NOT NULL,
    id_era INTEGER NOT NULL,
    name VARCHAR(256) NOT NULL,
    start_year INTEGER NOT NULL,
    end_year INTEGER
);
ALTER TABLE event ADD CONSTRAINT pk_event PRIMARY KEY (id_event);

CREATE TABLE fauna (
    id_living INTEGER NOT NULL,
    name_fauna VARCHAR(256) NOT NULL,
    weight INTEGER,
    body_covering VARCHAR(256),
    dietary VARCHAR(256)
);
ALTER TABLE fauna ADD CONSTRAINT pk_fauna PRIMARY KEY (id_living);

CREATE TABLE flora (
    id_living INTEGER NOT NULL,
    name_flora VARCHAR(256) NOT NULL,
    primary_color VARCHAR(256),
    grow_height INTEGER,
    preferred_climate VARCHAR(256)
);
ALTER TABLE flora ADD CONSTRAINT pk_flora PRIMARY KEY (id_living);

CREATE TABLE force_sensitive (
    id_figure INTEGER NOT NULL,
    uses_lightsaber BOOLEAN NOT NULL,
    side VARCHAR(256)
);
ALTER TABLE force_sensitive ADD CONSTRAINT pk_force_sensitive PRIMARY KEY (id_figure);

CREATE TABLE important_figure (
    id_figure SERIAL NOT NULL,
    id_race INTEGER NOT NULL,
    firstname VARCHAR(256) NOT NULL,
    surname VARCHAR(256),
    birth INTEGER,
    death INTEGER,
    home_planet VARCHAR(256)
);
ALTER TABLE important_figure ADD CONSTRAINT pk_important_figure PRIMARY KEY (id_figure);

CREATE TABLE living_thing (
    id_living SERIAL NOT NULL
);
ALTER TABLE living_thing ADD CONSTRAINT pk_living_thing PRIMARY KEY (id_living);

CREATE TABLE planet (
    id_planet SERIAL NOT NULL,
    name VARCHAR(256) NOT NULL,
    region VARCHAR(256),
    sector VARCHAR(256),
    population BIGINT,
    capital VARCHAR(256)
);
ALTER TABLE planet ADD CONSTRAINT pk_planet PRIMARY KEY (id_planet);
ALTER TABLE planet ADD CONSTRAINT uc_planet_name UNIQUE (name);

CREATE TABLE race (
    id_race SERIAL NOT NULL,
    name VARCHAR(256) NOT NULL,
    age INTEGER
);
ALTER TABLE race ADD CONSTRAINT pk_race PRIMARY KEY (id_race);
ALTER TABLE race ADD CONSTRAINT uc_race_name UNIQUE (name);

CREATE TABLE spaceship (
    id_spaceship SERIAL NOT NULL,
    name VARCHAR(256) NOT NULL,
    type VARCHAR(256)
);
ALTER TABLE spaceship ADD CONSTRAINT pk_spaceship PRIMARY KEY (id_spaceship);

CREATE TABLE important_figure_droid (
    id_figure INTEGER NOT NULL,
    id_droid INTEGER NOT NULL,
    year_acquired INTEGER
);
ALTER TABLE important_figure_droid ADD CONSTRAINT pk_important_figure_droid PRIMARY KEY (id_figure, id_droid);

CREATE TABLE important_figure_spaceship (
    id_spaceship INTEGER NOT NULL,
    id_figure INTEGER NOT NULL,
    year_acquired INTEGER
);
ALTER TABLE important_figure_spaceship ADD CONSTRAINT pk_important_figure_spaceship PRIMARY KEY (id_spaceship, id_figure);

CREATE TABLE important_figure_event (
    id_figure INTEGER NOT NULL,
    id_event INTEGER NOT NULL
);
ALTER TABLE important_figure_event ADD CONSTRAINT pk_important_figure_event PRIMARY KEY (id_figure, id_event);

CREATE TABLE planet_living_thing (
    id_planet INTEGER NOT NULL,
    id_living INTEGER NOT NULL
);
ALTER TABLE planet_living_thing ADD CONSTRAINT pk_planet_living_thing PRIMARY KEY (id_planet, id_living);

CREATE TABLE race_planet (
    id_race INTEGER NOT NULL,
    id_planet INTEGER NOT NULL
);
ALTER TABLE race_planet ADD CONSTRAINT pk_race_planet PRIMARY KEY (id_race, id_planet);

CREATE TABLE race_race (
    superiority_id_race INTEGER NOT NULL,
    inferiority_id_race INTEGER NOT NULL,
    CHECK (superiority_id_race <> inferiority_id_race)
);
ALTER TABLE race_race ADD CONSTRAINT pk_race_race PRIMARY KEY (superiority_id_race, inferiority_id_race);



ALTER TABLE event ADD CONSTRAINT fk_event_era FOREIGN KEY (id_era) REFERENCES era (id_era) ON DELETE CASCADE;

ALTER TABLE fauna ADD CONSTRAINT fk_fauna_living_thing FOREIGN KEY (id_living) REFERENCES living_thing (id_living) ON DELETE CASCADE;

ALTER TABLE flora ADD CONSTRAINT fk_flora_living_thing FOREIGN KEY (id_living) REFERENCES living_thing (id_living) ON DELETE CASCADE;

ALTER TABLE force_sensitive ADD CONSTRAINT fk_force_sensitive_important_fi FOREIGN KEY (id_figure) REFERENCES important_figure (id_figure) ON DELETE CASCADE;

ALTER TABLE important_figure ADD CONSTRAINT fk_important_figure_race FOREIGN KEY (id_race) REFERENCES race (id_race) ON DELETE CASCADE;

ALTER TABLE important_figure_droid ADD CONSTRAINT fk_important_figure_droid_impor FOREIGN KEY (id_figure) REFERENCES important_figure (id_figure) ON DELETE CASCADE;
ALTER TABLE important_figure_droid ADD CONSTRAINT fk_important_figure_droid_droid FOREIGN KEY (id_droid) REFERENCES droid (id_droid) ON DELETE CASCADE;

ALTER TABLE important_figure_spaceship ADD CONSTRAINT fk_important_figure_spaceship_s FOREIGN KEY (id_spaceship) REFERENCES spaceship (id_spaceship) ON DELETE CASCADE;
ALTER TABLE important_figure_spaceship ADD CONSTRAINT fk_important_figure_spaceship_i FOREIGN KEY (id_figure) REFERENCES important_figure (id_figure) ON DELETE CASCADE;

ALTER TABLE important_figure_event ADD CONSTRAINT fk_important_figure_event_impor FOREIGN KEY (id_figure) REFERENCES important_figure (id_figure) ON DELETE CASCADE;
ALTER TABLE important_figure_event ADD CONSTRAINT fk_important_figure_event_event FOREIGN KEY (id_event) REFERENCES event (id_event) ON DELETE CASCADE;

ALTER TABLE planet_living_thing ADD CONSTRAINT fk_planet_living_thing_planet FOREIGN KEY (id_planet) REFERENCES planet (id_planet) ON DELETE CASCADE;
ALTER TABLE planet_living_thing ADD CONSTRAINT fk_planet_living_thing_living FOREIGN KEY (id_living) REFERENCES living_thing (id_living) ON DELETE CASCADE;

ALTER TABLE race_planet ADD CONSTRAINT fk_race_planet_race FOREIGN KEY (id_race) REFERENCES race (id_race) ON DELETE CASCADE;
ALTER TABLE race_planet ADD CONSTRAINT fk_race_planet_planet FOREIGN KEY (id_planet) REFERENCES planet (id_planet) ON DELETE CASCADE;

ALTER TABLE race_race ADD CONSTRAINT fk_race_race_sup FOREIGN KEY (superiority_id_race) REFERENCES race (id_race) ON DELETE CASCADE;
ALTER TABLE race_race ADD CONSTRAINT fk_race_race_inf FOREIGN KEY (inferiority_id_race) REFERENCES race (id_race) ON DELETE CASCADE;
