-- smazání všech záznamů z tabulek

CREATE OR REPLACE FUNCTION clean_tables() RETURNS void AS
$$
DECLARE
    l_stmt text;
BEGIN
    SELECT 'truncate ' || STRING_AGG(FORMAT('%I.%I', schemaname, tablename), ',')
    INTO l_stmt
    FROM pg_tables
    WHERE schemaname IN ('public');

    EXECUTE l_stmt || ' cascade';
END;
$$ LANGUAGE plpgsql;
SELECT clean_tables();

-- reset sekvenci

CREATE OR REPLACE FUNCTION restart_sequences() RETURNS void AS
$$
DECLARE
    i TEXT;
BEGIN
    FOR i IN (SELECT column_default FROM information_schema.columns WHERE column_default SIMILAR TO 'nextval%')
        LOOP
            EXECUTE 'ALTER SEQUENCE' || ' ' || SUBSTRING(SUBSTRING(i FROM '''[a-z_]*') FROM '[a-z_]+') || ' ' ||
                    ' RESTART 1;';
        END LOOP;
END
$$ LANGUAGE plpgsql;
SELECT restart_sequences();
-- konec resetu
-- konec mazání

-- Create Script for filling tables

INSERT INTO era (name, start_year, end_year) VALUES
('Pre-Republic period', -100000, -26000),
('Dawn Of The Jedi', -25025, NULL),
('Old Republic', -25000, -9991),
('Fall of the Old Republic', -7977, -500),
('High Republic', -500, -100),
('Fall of the Republic', -100, -1),
('Age of Rebellion', 0, 4),
('Fall of the Empire', 4, 5),
('New Republic', 25, 28),
('Rise of the First Order', 29, 35),
('New Jedi Order', 40, NULL);


INSERT INTO event (id_era, name, start_year, end_year) VALUES
(1, 'Rise of the Infinite Empire', -100000, -90000),
(1, 'Rakatan Expansion', -95000, -92000),
(1, 'Subjugation of Coruscant', -90000, -89500),
(2, 'Arrival of the Tho Yor', -36000, -25025),
(2, 'Founding of the Je’daii Order', -25025, -25000),
(2, 'Great Storms of Tython', -25010, -25005),
(3, 'Formation of the Galactic Republic', -25000, -24995),
(3, 'First Sith Schism', -24000, -23990),
(3, 'Great Hyperspace War', -5000, -4999),
(3, 'Rise of Darth Bane’s Sith Doctrine', -1006, -1000),
(4, 'Mandalorian Neo-Crusades', -3976, -3966),
(4, 'Jedi Civil War', -3959, -3956),
(4, 'Battle of Malachor V', -3960, -3960),
(4, 'Revan’s Return', -3955, -3954),
(4, 'Cold War Between Republic and Sith Empire', -3650, -3642),
(5, 'Opening of Starlight Beacon', -232, -232),
(5, 'Emergence of the Nihil', -230, -229),
(5, 'Great Disaster', -232, -231),
(5, 'Battle of Kur', -125, -124),
(6, 'Blockade of Naboo', -32, -32),
(6, 'Battle of Geonosis', -22, -22),
(6, 'Clone Wars', -22, -19),
(6, 'Order 66', -19, -19),
(6, 'Declaration of the Galactic Empire', -19, -19),
(7, 'Battle of Scarif', -1, -1),
(7, 'Battle of Yavin', 0, 0),
(7, 'Battle of Hoth', 3, 3),
(7, 'Battle of Endor', 4, 4),
(8, 'Death of Emperor Palpatine', 4, 4),
(8, 'Rise of the New Republic', 5, 5),
(9, 'Galactic Concordance Signed', 6, 6),
(9, 'Leia Organizes Resistance', 28, 28),
(9, 'Rebuilding of the Jedi Temple', 26, 28),
(10, 'First Order Rises in Unknown Regions', 30, 31),
(10, 'Destruction of Hosnian Prime', 34, 34),
(10, 'Battle of Crait', 34, 34),
(10, 'Final Battle of Exegol', 35, 35),
(11, 'Reformation of the Jedi Order', 40, 41),
(11, 'Establishment of New Jedi Academy', 41, NULL),
(11, 'Search for Force-sensitive Younglings', 42, NULL);


INSERT INTO Planet (name, region, sector, population, capital) VALUES
('Aaloth', 'Outer Rim Territories', 'Gaulus sector', NULL, NULL),
('Ab Dalis', 'Outer Rim Territories', 'Gaulus sector', 20000000, NULL),
('Alderaan', 'Core Worlds', 'Alderaan sector', 2000000000, 'Aldera'),
('Aldhani', 'Outer Rim Territories', 'Cademimu sector', NULL, NULL),
('Arcana', 'Outer Rim Territories', 'Lahara sector', NULL, NULL),
('Bantoo', 'Outer Rim Territories', NULL, NULL, NULL),
('Bardotta', 'Colonies', 'Shasos sector', 900000000, 'Bardotta Capital City'),
('Bracca', 'Mid Rim Territories', 'Lantillian sector', NULL, NULL),
('Brendok', NULL, NULL, NULL, NULL),
('Corellia', 'Core Worlds', 'Corellian sector', 3000000000, 'Coronet City'),
('Corulag', 'Core Worlds', NULL, NULL, NULL),
('Coruscant', 'Core Worlds', 'Corusca sector, Coruscant subsector', 2500000000000, 'Galactic City'),
('Corvus', 'Outer Rim Territories', 'Cronese Mandate', NULL, 'Calodan'),
('Council', 'Outer Rim Territories', 'Anoat sector', NULL, NULL),
('Dagobah', 'Outer Rim Territories', 'Sluis sector', 1, NULL),
('Dantooine', 'Outer Rim Territories', 'Raioballo sector', NULL, NULL),
('Dathomir', 'Outer Rim Territories', 'Quelii sector', 8000, NULL),
('Dromund Kaas', NULL, NULL, 10000, NULL),
('Endor', 'Outer Rim Territories', 'Moddell sector', 30000000, NULL),
('Exegol', 'Unknown Regions', NULL, NULL, NULL),
('Ferrix', 'Outer Rim Territories', 'Free Trade sector', 1500000, NULL),
('Galagolos V', 'Colonies', NULL, NULL, NULL),
('Geonosis', 'Outer Rim Territories', 'Arkanis sector', 100000000000, 'Stalgasin hive'),
('Ilum', 'Unknown Regions', '7G sector', 5200, NULL),
('Jakku', 'Inner Rim Territories', 'Jakku''s sector', 25000, NULL),
('Kamino', 'Wild Space', 'Abrion sector', 1000000000, 'Tipoca City'),
('Kashyyyk', 'Mid Rim Territories', 'Mytaranor sector', 56000000, 'Kachirho'),
('Kessel', 'Outer Rim Territories', 'Kessel sector', 10000, NULL),
('Khofar', 'Outer Rim Territories', NULL, NULL, NULL),
('Koboh', 'Outer Rim Territories', 'Varada sector', NULL, NULL),
('Kril''Dor', 'Mid Rim Territories', NULL, 850000, NULL),
('Lothal', 'Outer Rim Territories', 'Lothal sector', 285000000, 'Capital City'),
('Lotho Minor', 'Outer Rim Territories', 'Wazta sector', NULL, NULL),
('Malachor V', 'Outer Rim Territories', 'Chorlian sector', NULL, NULL),
('Mandalore', 'Outer Rim Territories', 'Mandalore sector', 4000000, 'Keldabe (formerly), Sundari'),
('Megalox Beta', 'Expansion Region', 'Bes Ber Bikade sector', NULL, NULL),
('Mirial', 'Outer Rim Territories', NULL, 345000000, NULL),
('Mon Cala', 'Outer Rim Territories', 'Calamari sector', 27000000000, 'Mon Cala city'),
('Mustafar', 'Outer Rim Territories', 'Atravis sector', 20000, 'Fralideja'),
('Naboo', 'Mid Rim Territories', 'Chommell sector', 542685847, 'Theed'),
('Oba Diah', 'Outer Rim Territories', 'Kessel sector', NULL, NULL),
('Ordo', NULL, NULL, NULL, NULL),
('Petris Major', 'Outer Rim Territories', NULL, NULL, NULL),
('Pion', 'Wild Space', NULL, NULL, NULL),
('Pippip 3', 'Outer Rim Territories', NULL, NULL, NULL),
('Tanalorr', 'Galactic Frontier', 'Varada sector', NULL, NULL),
('Tatooine', 'Outer Rim Territories', 'Arkanis sector', 200000, 'Bestine'),
('Thabeska', 'Outer Rim Territories', NULL, NULL, NULL),
('Tharben', 'The Slice', NULL, NULL, NULL),
('Tholoth', 'Colonies', NULL, NULL, NULL),
('Turrak', 'Outer Rim Territories', NULL, NULL, NULL),
('Vagadarr Prime', 'Inner Rim Territories', NULL, NULL, NULL),
('Valo', 'Outer Rim Territories', 'Rseik sector', NULL, 'Lonisa City'),
('Vardos', 'Core Worlds', NULL, NULL, NULL),
('Zayron', NULL, NULL, NULL, NULL),
('Zeffo', 'Outer Rim Territories', 'Kanz sector', NULL, NULL),
('Zeitooine', 'Inner Rim Territories', NULL, NULL, NULL),
('Zoh', NULL, NULL, NULL, NULL),
('Zyzek', 'Unknown Regions', NULL, NULL, NULL),
('Mortis', 'Wild Space', NULL, 3, NULL);


INSERT INTO Race (name, age) VALUES
('Human', 100000),
('Twi''lek', 10000),
('Zabrak', 30000),
('Togruta', 25000),
('Chiss', 27000),
('Chagrian', NULL),
('Devaronian', 27000),
('Falleen', NULL),
('Theelin', NULL),
('Pantoran', NULL),
('Palliduvan', NULL),
('Tholothian', NULL),
('Cerean', NULL),
('Iktotchi', 4000),
('Mirialan', NULL),
('Utapaun', NULL),
('Kage', NULL),
('Sakiyan', 25000),
('Mikkian', NULL),
('Umbaran', NULL),
('Wookiee', 2000000),
('Tusken', NULL),
('Trandoshan', 7000),
('Gungan', NULL),
('Duros', 100000),
('Quarren', NULL),
('Rodian', NULL),
('Nautolan', NULL),
('Bith', 1000000),
('Sullustan', NULL),
('Clawdite', NULL),
('Ongree', NULL),
('Vurk', NULL),
('Arcona', NULL),
('Mon Calamari', NULL),
('Bothan', NULL),
('Kel Dor', NULL),
('Nemoidian', 28000),
('Kyuzo', NULL),
('Snivvian', NULL),
('Gran', 10000),
('Nikto', 26000),
('Selkath', NULL),
('Skakoan', 16200),
('Kaleesh', NULL),
('Siniteen', NULL),
('Aqualish', 15000),
('Belugan', NULL),
('Zygerrian', NULL),
('Yoda''s species', NULL),
('Jawa', 25200),
('Ewok', 3639),
('Ugnaught', NULL),
('Gamorrean', 25000),
('Talz', 4000),
('Ithorian', 12000),
('Ortolan', NULL),
('Maz''s species', NULL),
('Lannik', 17000),
('Lasat', NULL),
('Kaminoan', NULL),
('Yuzzum', NULL),
('Dug', 8000),
('Muun', NULL),
('Utai', NULL),
('Phindian', NULL),
('Pyke', NULL),
('Anzellan', NULL),
('Hutt', NULL),
('Toydarian', NULL),
('Geonosian', NULL),
('Thisspiasian', NULL),
('Besalisk', NULL),
('Parwan', NULL),
('Harch', NULL),
('Troig', NULL),
('Ardennian', NULL),
('Bardottan', 5000),
('Barbadelan', NULL),
('Czerialan', NULL),
('Grindalid', NULL),
('Ugor', NULL),
('Taung', NULL),
('Zhell', NULL),
('Aki-Aki', NULL),
('Candovantan', NULL),
('Didynon', NULL),
('Abednedo', NULL),
('Kakala', NULL),
('Kubaz', NULL),
('Dwuni', NULL),
('Cloddogran', NULL),
('Acklay', NULL),
('Massiff', NULL),
('Nexu', NULL),
('Reek', NULL),
('Teedo', NULL),
('Gigoran', NULL),
('Anx', NULL),
('Balosar', NULL),
('Feeorin', NULL),
('Anacondan', NULL),
('Junker', NULL),
('Mustafarian', NULL),
('Zeffonian', NULL),
('Tash', NULL),
('Unknown', NULL),
('Sith', 100000),
('Fosh', NULL);


INSERT INTO race_planet (id_race, id_planet) VALUES
(1,3),   -- Human, Alderaan
(1,4),   -- Human, Aldhani
(3,17),  -- Zabrak, Dathomir
(1,10),  -- Human, Corellia
(1,54),  -- Human, Vardos
(73,10), -- Besalisk, Corellia
(27,10), -- Rodian, Corellia
(2,10),  -- Twi'lek, Corellia
(1,11),  -- Human, Corulag
(1,12),  -- Human, Coruscant
(1,16),  -- Human, Dantooine
(1,21),  -- Human, Ferrix
(71,23), -- Geonosian, Geonosis
(61,26), -- Kaminoan, Kamino
(21,27), -- Wookiee, Kashyyyk
(1,28),  -- Human, Kessel
(67,28), -- Pyke, Kessel
(2,28),  -- Twi'lek, Kessel
(21,28), -- Wookiee, Kessel
(47,32), -- Aqualish, Lothal
(1,32),  -- Human, Lothal
(27,32), -- Rodian, Lothal
(1,35),  -- Human, Mandalore
(15, 37),-- Mirialan, Mirial
(35,38), -- Mon Calamari, Mon Cala
(1,39),  -- Human, Mustafar
(1,40),  -- Human, Naboo
(24,40), -- Gungan, Naboo
(67,41), -- Pyke, Oba Diah
(51,47), -- Jawa, Tatooine
(22,47), -- Tusken, Tatooine
(12,50), -- Tholothian, Tholoth
(47,53), -- Aqualish, Valo
(1,53),  -- Human, Valo
(78,7),  -- Bardottan, Bardotta
(79,10), -- Barbadelan, Corellia
(80,10), -- Czerialan, Corellia
(81,10), -- Grindalid, Corellia
(82,10), -- Ugor, Corellia
(83,12), -- Taung, Coruscant
(84,12), -- Zhell, Coruscant
(85,21), -- Aki-Aki, Ferrix
(86,21), -- Candovantan, Ferrix
(87,21), -- Didynon, Ferrix
(88,21), -- Abednedo, Ferrix
(89,21), -- Kakala, Ferrix
(90,21), -- Kubaz, Ferrix
(91,21), -- Dwuni, Ferrix
(92,22), -- Cloddogran, Galagolos V
(93,23), -- Acklay, Geonosis
(94,23), -- Massiff, Geonosis
(95,23), -- Nexu, Geonosis
(96,23), -- Reek, Geonosis
(97,25), -- Teedo, Jakku
(91,28), -- Dwuni, Kessel
(98,28), -- Gigoran, Kessel
(99,32), -- Anx, Lothal
(100,32),-- Balosar, Lothal
(78,32), -- Bardottan, Lothal
(101,32),-- Feeorin, Lothal
(102,33),-- Anacondan, Lotho Minor
(103,33),-- Junker, Lotho Minor
(104,39),-- Mustafarian, Mustafar
(105,56),-- Zeffonian, Zeffo
(106,15);-- Tash, Dagobah


INSERT INTO living_thing
SELECT FROM GENERATE_SERIES(1, 20);


INSERT INTO fauna (id_living, name_fauna, weight, body_covering, dietary) VALUES
(1, 'Vornskr', 120.0, 'fur', 'carnivore'),
(2, 'Nexu', NULL, 'fur', 'carnivore'),
(3, 'Tauntaun', 300.0, 'scales', 'herbivore'),
(4, 'Bantha', 1500.0, 'fur', NULL),
(5, 'Acklay', 850.0, NULL, 'carnivore'),
(6, 'Wampa', 600.0, 'fur', 'carnivore'),
(7, 'Anooba', 55.0, 'fur', 'carnivore'),
(8, 'Rancor', 3200.0, 'leathery skin', 'carnivore'),
(9, 'Massiff', NULL, 'scales', NULL),
(10, 'Fyrnock', 180.0, NULL, 'omnivore');


INSERT INTO flora (id_living, name_flora, primary_color, grow_height, preferred_climate) VALUES
(11, 'Glowvine', 'blue', 1.2, 'temperate'),
(12, 'Bafforr Tree', 'green', 15.0, 'humid'),
(13, 'Ironwood Sapling', 'brown', 6.0, 'temperate'),
(14, 'Membra Bush', 'red', 0.7, NULL),
(15, 'Tamaris Moss', 'yellow', NULL, 'swampy'),
(16, 'Veshok Tree', 'green', 12.0, 'forest'),
(17, 'Rylothan Cactus', 'purple', 2.5, 'desert'),
(18, 'Glowshroom', 'white', 0.3, 'humid'),
(19, 'Shadow Fern', 'black', 0.5, NULL),
(20, 'Sunpetal Vine', NULL, 1.8, NULL);


INSERT INTO planet_living_thing (id_planet, id_living) VALUES
(3, 1), (3, 11),    -- Vornskr, Glowvine on Alderaan
(10, 2), (10, 12),  -- Nexu, Bafforr Tree on Corellia
(12, 3), (12, 13),  -- Tauntaun, Ironwood Sapling on Coruscant
(16, 4), (16, 14),  -- Bantha, Membra Bush on Dantooine
(25, 5), (25, 15),  -- Acklay, Tamaris Moss on Jakku
(27, 6), (27, 16),  -- Wampa, Veshok Tree on Kashyyyk
(28, 7), (28, 17),  -- Anooba, Rylothan Cactus on Kessel
(32, 8), (32, 18),  -- Rancor, Glowshroom on Lothal
(47, 9), (47, 19),  -- Massiff, Shadow Fern on Tatooine
(56, 10), (56, 20); -- Fyrnock, Sunpetal Vine on Zeffo


INSERT INTO droid (name, type) VALUES
('R2-D2', 'astromech'),
('C-3PO', 'protocol'),
('IG-88', 'assassin'),
('K-2SO', 'security'),
('BB-8', 'astromech'),
('L3-37', 'navigation'),
('HK-47', 'assassin'),
('T3-M4', 'utility'),
('EV-9D9', 'supervisor'),
('4-LOM', 'protocol'),
('R5-D4', 'astromech'),
('AP-5', NULL),
('D-O', 'repair'),
('AZI-3', NULL),
('MR-B9', 'maintenance'),
('BT-1', 'assassin'),
('0-0-0', 'protocol'),
('CH-33Z', NULL),
('C1-10P/Chopper', 'astromech'),
('Gonk', NULL);


INSERT INTO spaceship (name, type) VALUES
('Millennium Falcon', 'freighter'),
('X-Wing', 'starfighter'),
('TIE Fighter', 'starfighter'),
('Slave I', 'bounty hunter ship'),
('Imperial Star Destroyer', 'capital ship'),
('Naboo Royal Starship', 'diplomatic transport'),
('A-Wing', 'interceptor'),
('B-Wing', 'assault starfighter'),
('Y-Wing', 'bomber'),
('Lambda-class Shuttle', NULL),
('Ghost', 'freighter'),
('Razor Crest', 'gunship'),
('TIE Interceptor', 'interceptor'),
('Ebon Hawk', NULL),
('ARC-170', 'recon starfighter'),
('V-Wing', 'fighter'),
('Tantive IV', 'corvette'),
('Outrider', 'freighter'),
('Venator-class Star Destroyer', 'capital ship'),
('J-type 327 Nubian', NULL);


INSERT INTO important_figure (id_race, firstname, surname, birth, death, home_planet) VALUES
(1, 'Anakin', 'Skywalker', -41, 4, 'Tatooine'),
(1, 'Padmé', 'Amidala', -46, -19, 'Naboo'),
(1, 'Leia', 'Organa', -19, 35, 'Alderaan'),
(1, 'Luke', 'Skywalker', -19, 34, 'Tatooine'),
(1, 'Han', 'Solo', -29, 34, 'Corellia'),
(1, 'Ben', 'Solo', 5, 35, 'Chandrila'),
(1, 'Rey', 'Skywalker', 15, NULL, 'Jakku'),
(1, 'Obi-Wan', 'Kenobi', -57, 0, 'Stewjon'),
(1, 'Bail', 'Organa', -67, 0, 'Alderaan'),
(1, 'Cassian', 'Andor', -26, 0, 'Fest'),
(1, 'Jyn', 'Erso', -21, 0, 'Vallt'),
(1, 'Galen', 'Erso', -52, 0, 'Grange'),
(1, 'Lando', 'Calrissian', -31, NULL, 'Socorro'),
(1, 'Poe', 'Dameron', 2, NULL, 'Yavin IV'),
(1, 'Finn', NULL, 11, NULL, 'Unknown'),
(1, 'Rose', 'Tico', 11, NULL, 'Hays Minor'),
(1, 'Holdo', 'Amilyn', -29, 34, 'Gatalenta'),
(1, 'Ezra', 'Bridger', -19, NULL, 'Lothal'),
(1, 'Kanan', 'Jarrus', -33, -1, 'Coruscant'),
(1, 'Sabine', 'Wren', -21, NULL, 'Mandalore'),
(4, 'Ahsoka', 'Tano', -36, NULL, 'Shili'),
(50, 'Yoda', NULL, -896, 4, 'Unknown'),
(1, 'Mace', 'Windu', -72, -19, 'Haruun Kal'),
(1, 'Qui-Gon', 'Jinn', -92, -32, 'Coruscant'),
(1, 'Shmi', 'Skywalker', -72, -22, 'Tatooine'),
(1, 'Wilhuff', 'Tarkin', -64, 0, 'Eriadu'),
(1, 'Orson', 'Krennic', -51, 0, 'Lexrul'),
(1, 'Saw', 'Gerrera', -53, 2, 'Onderon'),
(1, 'Beru', 'Whitesun', -47, 0, 'Tatooine'),
(1, 'Owen', 'Lars', -52, 0, 'Tatooine'),
(1, 'Wedge', 'Antilles', -21, NULL, 'Corellia'),
(1, 'Biggs', 'Darklighter', -24, 0, 'Tatooine'),
(1, 'Dexter', 'Jettster', -90, NULL, 'Ojom'),
(21, 'Chewbacca', NULL, -200, 34, 'Kashyyyk'),
(1, 'Rex', NULL, -32, NULL, 'Kamino'),
(1, 'Cody', NULL, -32, NULL, 'Kamino'),
(1, 'Fives', NULL, -32, -19, 'Kamino'),
(1, 'Echo', NULL, -32, NULL, 'Kamino'),
(1, 'Crosshair', NULL, -32, NULL, 'Kamino'),
(1, 'Tech', NULL, -32, 18, 'Kamino'),
(1, 'Hunter', NULL, -32, NULL, 'Kamino'),
(1, 'Omega', NULL, -20, NULL, 'Kamino'),
(5, 'Thrawn', NULL, -60, NULL, 'Csilla'),
(23, 'Bossk', NULL, -53, NULL, 'Trandosha'),
(25, 'Cad', 'Bane', -62, 10, 'Duro'),
(21, 'Tarfful', NULL, -150, NULL, 'Kashyyyk'),
(50, 'Yaddle', NULL, -509, -32, 'Unknown'),
(45, 'Grievous', NULL, -100, -19, 'Kalee'),
(69, 'Jabba', 'Desilijic Tiure', -600, 4, 'Nal Hutta'),
(28, 'Kit', 'Fisto', -75, -19, 'Glee Anselm'),
(56, 'Roron', 'Corobb', -70, -21, 'Ithor'),
(37, 'Plo', 'Koon', -71, -19, 'Dorin'),
(2, 'Hera', 'Syndulla', -29, NULL, 'Ryloth'),
(1, 'Cham', 'Syndulla', -53, NULL, 'Ryloth'),
(1, 'Zeb', 'Orrelios', -34, NULL, 'Lasan'),
(1, 'Kallus', NULL, -30, NULL, 'Coruscant'),
(27, 'Greedo', NULL, -44, 0, 'Rodia'),
(69, 'Rotta', NULL, -25, NULL, 'Nal Hutta'),
(24, 'Jar Jar', 'Binks', -52, NULL, 'Naboo'),
(26, 'Tessek', NULL, -40, 4, 'Mon Cala'),
(35, 'Ackbar', NULL, -50, 30, 'Mon Cala'),
(35, 'Raddus', NULL, -60, 0, 'Mon Cala'),
(1, 'Beilert', 'Valance', -15, NULL, 'Chorin'),
(1, 'Dryden', 'Vos', -38, 10, 'Ord Mantell'),
(3, 'Maul', NULL, -54, 2, 'Dathomir'),
(3, 'Savage', 'Opress', -48, -19, 'Dathomir'),
(1, 'Qi''ra', NULL, -33, NULL, 'Corellia'),
(1, 'Enfys', 'Nest', -22, NULL, 'Unknown'),
(1, 'Bodhi', 'Rook', -13, 0, 'Jedha'),
(1, 'Baze', 'Malbus', -42, 0, 'Jedha'),
(1, 'Chirrut', 'Îmwe', -52, 0, 'Jedha'),
(64, 'San', 'Hill', -62, -19, 'Muunilinst'),
(38, 'Nute', 'Gunray', -67, -19, 'Cato Neimoidia'),
(69, 'Ziro', 'the Hutt', -100, -20, 'Nal Hutta'),
(32, 'Pong', 'Krell', -72, -21, 'Saleucami'),
(69, 'Gardulla', 'the Hutt', -200, NULL, 'Nal Hutta'),
(39, 'Embo', NULL, -62, NULL, 'Phatrong'),
(20, 'Sly', 'Moore', -58, NULL, 'Umbara'),
(66, 'Ratts', 'Tyerell', -70, -32, 'Aleen'),
(63, 'Sebulba', NULL, -60, NULL, 'Malastare'),
(1, 'Cliegg', 'Lars', -82, -22, 'Tatooine'),
(1, 'Dex', 'Tiree', -20, 1, 'Unknown'),
(1, 'Tobias', 'Beckett', -49, 10, 'Glee Anselm'),
(1, 'Val', NULL, -45, 10, 'Unknown'),
(59, 'Even', 'Piell', -120, -19, 'Lannik'),
(44, 'Wat', 'Tambor', -62, -19, 'Skako Minor'),
(29, 'Lirin', NULL, -200, NULL, 'Clak''dor VII'),
(1, 'Bo-Katan', 'Kryze', -43, NULL, 'Mandalore'),
(1, 'Satine', 'Kryze', -50, -19, 'Mandalore'),
(1, 'Pre', 'Vizsla', -52, -19, 'Mandalore'),
(1, 'Din', 'Djarin', 30, NULL, 'Aq Vetina'),
(50, 'Grogu', NULL, 41, NULL, 'Unknown'),
(1, 'Carson', 'Teva', -12, NULL, 'Alderaan'),
(1, 'Cara', 'Dune', 12, NULL, 'Alderaan'),
(1, 'Greef', 'Karga', 0, NULL, 'Unknown'),
(1, 'Mayfeld', NULL, 0, NULL, 'Unknown'),
(1, 'Paz', 'Vizsla', 5, 35, 'Mandalore'),
(1, 'The', 'Armorer', 5, NULL, 'Mandalore'),
(1, 'Elia', 'Kane', 19, NULL, 'Coruscant'),
(1, 'Galen', 'Marek', -19, 0, 'Corellia'),
(1, 'Sheev', 'Palpatine', -84, 4, 'Naboo'),
(107, 'Bendu', NULL, NULL, NULL, NULL),
(1, 'Gideon', NULL, NULL, 9, NULL),
(13, 'Ki-Adu-Mundi', NULL, NULL, -19, 'Cerea'),
(1, 'Jango', 'Fett', -66, -22, 'Concord Dawn'),
(1, 'Boba', 'Fett', -32, NULL, 'Kamino'),
(1, 'Dooku', NULL, -102, -19, 'Serenno'),
(1, 'Wilhuff', 'Tarkin', -64, 0, 'Eriadu'),
(1, 'Revan', NULL, -3994, -3626, NULL),
(64, 'Plagueis', NULL, NULL, -40, NULL),
(108, 'Tenebrea/Vitiate', NULL, -5113, -3626, 'Medriaas'),
(1, 'Nihilus', NULL, NULL, -3951, 'Malachor V'),
(1, 'Exar', 'Kun', NULL, -3996, NULL),
(1, 'Sion', NULL, NULL, -3951, NULL),
(1, 'Bane', NULL, -1026, -980, 'Apatros'),
(1, 'Malgus', NULL, -3700, NULL, 'Dromund Kaas'),
(1, 'Kreia/Traya', NULL, NULL, -3951, NULL),
(1, 'Alek/Malak', NULL, NULL, -3956, 'Quelii'),
(108, 'Marka', 'Ragnos', -5150, -5000, NULL),
(1, 'Zannah', NULL, -1010, -980, 'Somov Rit'),
(1, 'Jason/Caedus', 'Solo', 9, 41, 'Coruscant'),
(1, 'Mara', 'Jade Skywalker', 17, 40, NULL),
(109, 'Vergere', NULL, NULL, 28, NULL),
(29, 'Rugess/Tenebrous', 'Nome', -247, -67, NULL),
(1, 'Momin', NULL, NULL, -1100, NULL),
(108, 'Naga', 'Sadow', -5000, -4400, 'Ziost'),
(107, 'The Father', NULL, NULL, -20, 'Mortis'),
(107, 'The Daughter', NULL, NULL, -20, 'Mortis'),
(107, 'The Son', NULL, NULL, -20, 'Mortis'),
(107, 'Abeloth/The Mother', NULL, -100000, 44, NULL),
(107, 'Force Priestesses', NULL, NULL, NULL, NULL),
(107, 'Ochi', NULL, NULL, NULL, NULL);


INSERT INTO force_sensitive (id_figure, uses_lightsaber, side) VALUES
(1, TRUE, 'both'),         -- Anakin Skywalker
(3, FALSE, 'light'),       -- Leia Organa
(4, TRUE, 'light'),        -- Luke Skywalker
(6, TRUE, 'both'),         -- Ben Solo / Kylo Ren
(7, TRUE, 'light'),        -- Rey Skywalker (Palpatine...)
(8, TRUE, 'light'),        -- Obi-Wan Kenobi
(15, FALSE, NULL),         -- Finn was lowkey force sensitive
(18, TRUE, 'light'),       -- Ezra Bridger
(19, TRUE, 'light'),       -- Kanan Jarrus
(21, TRUE, 'light'),       -- Ahsoka Tano
(22, TRUE, 'light'),       -- Yoda
(23, TRUE, 'light'),       -- Mace Windu
(24, TRUE, 'light'),       -- Qui-Gon Jinn
(47, TRUE, 'light'),       -- Yaddle
(50, TRUE, 'light'),       -- Kit Fisto
(52, TRUE, 'light'),       -- Plo Koon
(59, FALSE, 'dark'),       -- Jar-Jar was a secret dark lord
(65, TRUE, 'dark'),        -- Maul
(66, TRUE, 'dark'),        -- Savage Opress
(85, TRUE, 'light'),       -- Even Piell
(91, FALSE, 'light'),      -- Grogu
(100, TRUE, 'both'),       -- Galen Marek (Starkiller)
(101, TRUE, 'dark'),       -- Palpatine
(102, FALSE, NULL),        -- Bendu
(104, TRUE, 'light'),      -- Ki-Adi-Mundi
(107, TRUE, 'both'),       -- Dooku
(109, TRUE, 'both'),       -- Revan
(110, TRUE, 'dark'),       -- Plagueis
(111, TRUE, 'dark'),       -- Tenebrea/Vitiate
(112, TRUE, 'dark'),       -- Nihilus
(113, TRUE, 'dark'),       -- Exar Kun
(114, TRUE, 'dark'),       -- Sion
(115, TRUE, 'dark'),       -- Bane
(116, TRUE, 'dark'),       -- Malgus
(117, TRUE, 'dark'),       -- Kreia/Traya
(118, TRUE, 'dark'),       -- Alek/Malak
(119, TRUE, 'dark'),       -- Marka Ragnos
(120, TRUE, 'dark'),       -- Zannah
(121, TRUE, 'both'),       -- Jason/Caedus Solo
(122, TRUE, 'light'),      -- Mara Jade Skywalker
(123, TRUE, 'both'),       -- Vergere
(124, TRUE, 'dark'),       -- Rugess/Tenebrous
(125, TRUE, 'dark'),       -- Momin
(126, TRUE, 'dark'),       -- Naga Sadow
(127, FALSE, NULL),        -- The Father
(128, FALSE, 'light'),     -- The Daughter
(129, FALSE, 'dark'),      -- The Son
(130, FALSE, 'dark'),      -- Abeloth/The Mother
(131, FALSE, NULL);        -- Force Priestesses


INSERT INTO important_figure_spaceship (id_spaceship, id_figure, year_acquired) VALUES
(1, 13,NULL),   -- Millennium Falcon - Lando, Unknown
(1, 5, -10),    -- Millennium Falcon - Han Solo, 10BBY
(2, 4, -1),     -- X-Wing - Luke Skywalker, 1BBY
(3, 1, NULL),   -- TIE Fighter - Anakin, Unknown
(4, 105, -32),  -- Slave I - Jango Fett, 32BBY
(4, 106, -22),  -- Slave I - Boba Fett, 22BBY
(5, 101, NULL), -- Star Destroyer - Palpatine, Unknown
(6, 2, -32),    -- Naboo Royal Starship - Padmé Amidala, 32BBY
(7, 18, NULL),  -- A-Wing - Ezra, Unknown
(7, 19, NULL),  -- A-Wing - Kanan, Unknown
(8, 53, NULL),  -- B-Wing - Hera, Unknown
(8, 20, NULL),  -- B-Wing - Sabine, Unknown
(9, 53, NULL),  -- Y-Wing - Hera, Unknown
(10, 1, NULL),  -- Lambda class shuttle - Darth Vader, Unknown
(10, 101, NULL),-- Lambda class shuttle - Palpatine, Unknown
(11, 53, -11),  -- Ghost - Hera, 11BBY
(12, 91, 9),    -- Razor Crest - Din Djarin, 9ABY
(13, 1, NULL),  -- TIE Interceptor - Vader, Unknown
(14, 109, NULL),-- Ebon Hawk - Revan, Unknown
(17, 3, -18),   -- Tantive IV - Leia Organa, 18BBY
(19, 9, -21),   -- Venator-class Star Destroyer - Mace Windu, 21BBY
(20, 2, -32);   -- J-type 327 Nubian - Padmé Amidala, 32BBY


INSERT INTO important_figure_droid (id_droid, id_figure, year_acquired) VALUES
(1, 2, -32),    -- R2-D2 - Padmé Amidala, 32BBY
(1, 1, -22),    -- R2-D2 - Anakin, 22BBY
(1, 21, NULL),  -- R2-D2 - Ahsoka Tano, Uknown
(1, 9, -9),     -- R2-D2 - Bail Organa, 9BBY
(1, 4, 0),      -- R2-D2 - Luke Skywalker, 0BBY
(1, 3, NULL),   -- R2-D2 - Leia, Unknown
(2, 25, -42),   -- C-3PO - Shmi Skywalker, 42BBY
(2, 2, -22),    -- C-3PO - Padmé Amidala, 22BBY (After Shmi's death)
(2, 9, -19),    -- C-3PO - Bail Organa, 19BBY
(2, 3, NULL),   -- C-3PO - Leia Organa, Unknown
(5, 14, 30),    -- BB-8 - Poe Dameron, 30ABY
(6, 13, NULL),  -- L3-37 - Lando, Unknown
(7, 109, NULL), -- HK-47 - Revan, Unknown
(8, 109, NULL), -- T3-M4 - Revan, Unknown
(9, 49, NULL),  -- EV-9D9 - Jabba the Hutt, Unknown
(11, 30, 0),    -- R5-D4 - Owen Lars, 0BBY
(13, 132, NULL),-- D-0 - Ochi, Unknown
(16, 1, NULL),  -- BT-1 - Vader, Unknown
(17, 1, NULL),  -- 0-0-0 - Vader, Unknown
(19, 18, NULL);  -- C1-10P - Ezra, Unknown



INSERT INTO important_figure_event (id_figure, id_event) VALUES
-- I lost comments to this insert
(126,9),  -- Naga Sadow         - Great Hyperspace War
(109,11), -- Revan              - Mandalorian Neo-Crusades
(112,11), -- Nihilus            - Mandalorian Neo-Crusades
(109,12), -- Revan              - Jedi Civil War
(111,12), -- Vitiate            - Jedi Civil War
(112,12), -- Nihilus            - Jedi Civil War
(113,12), -- Exar Kun           - Jedi Civil War
(114,12), -- Sion               - Jedi Civil War
(117,12), -- Traya              - Jedi Civil War
(118,12), -- Malak              - Jedi Civil War
(109,13), -- Revan              - Battle of Malachor V
(109,14), -- Revan              - Revan’s Return
(109,15), -- Revan              - Cold War Between Republic and Sith Empire
(111,15), -- Vitiate            - Cold War Between Republic and Sith Empire
(116,15), -- Malgus             - Cold War Between Republic and Sith Empire
(115,10), -- Bane               - Rise of Darth Bane’s Sith Doctrine
(22,16),  -- Yoda               - Opening of Starlight Beacon

(1,20),   -- Anakin             - Blockade of Naboo
(1,21),   -- Anakin             - Battle of Geonosis
(1,22),   -- Anakin             - Clone Wars
(1,23),   -- Anakin             - Order 66
(2,20),   -- Padmé              - Blockade of Naboo
(2,21),   -- Padmé              - Battle of Geonosis
(2,22),   -- Padmé              - Clone Wars
(8,20),   -- Obi-Wan            - Blockade of Naboo
(8,21),   -- Obi-Wan            - Battle of Geonosis
(8,22),   -- Obi-Wan            - Clone Wars
(8,23),   -- Obi-Wan            - Order 66
(21,22),  -- Ahsoka             - Clone Wars
(22,21),  -- Yoda               - Battle of Geonosis
(22,22),  -- Yoda               - Clone Wars
(22,23),  -- Yoda               - Order 66
(23,21),  -- Mace Windu         - Battle of Geonosis
(23,22),  -- Mace Windu         - Clone Wars
(23,23),  -- Mace Windu         - Order 66
(24,20),  -- Qui-Gon            - Blockade of Naboo
(35,22),  -- Rex                - Clone Wars
(36,22),  -- Cody               - Clone Wars
(37,22),  -- Fives              - Clone Wars
(38,22),  -- Echo               - Clone Wars
(39,22),  -- Crosshair          - Clone Wars
(40,22),  -- Tech               - Clone Wars
(41,22),  -- Hunter             - Clone Wars
(42,22),  -- Omega              - Clone Wars
(35,23),  -- Rex                - Order 66
(36,23),  -- Cody               - Order 66
(38,23),  -- Echo               - Order 66
(39,23),  -- Crosshair          - Order 66
(40,23),  -- Tech               - Order 66
(41,23),  -- Hunter             - Order 66
(42,23),  -- Omega              - Order 66
(48,22),  -- Grievous           - Clone Wars
(50,21),  -- Kit Fisto          - Battle of Geonosis
(50,22),  -- Kit Fisto          - Clone Wars
(50,23),  -- Kit Fisto          - Order 66
(51,22),  -- Roron Corobb       - Clone Wars
(51,23),  -- Roron Corobb       - Order 66
(52,22),  -- Plo Koon           - Clone Wars
(52,23),  -- Plo Koon           - Order 66
(59,20),  -- Jar-Jar            - Blockade of Naboo
(59,21),  -- Jar-Jar            - Battle of Geonosis
(65,20),  -- Maul               - Blockade of Naboo
(65,22),  -- Maul               - Clone Wars
(65,23),  -- Maul               - Order 66
(66,22),  -- Savage Opress      - Clone Wars
(80,20),  -- Sebula             - Blockade of Naboo
(90,22),  -- Pre Vizsla         - Clone Wars
(101,20), -- Palaptine          - Blockade of Naboo
(101,21), -- Palaptine          - Battle of Geonosis
(101,22), -- Palaptine          - Clone Wars
(101,23), -- Palaptine          - Order 66
(104,22), -- Ki-Adu-Mundi       - Clone Wars
(105,21), -- Jango Fett         - Battle of Geonosis

(1,24),   -- Anakin             - Declaration of the Galactic Empire
(8,24),   -- Obi-Wan            - Declaration of the Galactic Empire
(22,24),  -- Yoda               - Declaration of the Galactic Empire
(101,24), -- Palaptine          - Declaration of the Galactic Empire
(10,25),  -- Cassian Andor      - Battle of Scarif
(1,26),   -- Anakin             - Battle of Yavin
(101,26), -- Palaptine          - Battle of Yavin
(3,26),   -- Leia               - Battle of Yavin
(4,26),   -- Luke               - Battle of Yavin
(5,26),   -- Han Solo           - Battle of Yavin
(8,26),   -- Obi-Wan            - Battle of Yavin
(9,26),   -- Bail Organa        - Battle of Yavin
(11,26),  -- Jyn Erso           - Battle of Yavin
(12,26),  -- Galen Erso         - Battle of Yavin
(26,26),  -- Tarkin             - Battle of Yavin
(34,26),  -- Chewbacca          - Battle of Yavin
(1,27),   -- Anakin             - Battle of Hoth
(3,27),   -- Leia               - Battle of Hoth
(4,27),   -- Luke               - Battle of Hoth
(5,27),   -- Han Solo           - Battle of Hoth
(34,27),  -- Chewbacca          - Battle of Hoth
(1,28),   -- Anakin             - Battle of Endor
(101,28), -- Palaptine          - Battle of Endor
(3,28),   -- Leia               - Battle of Endor
(4,28),   -- Luke               - Battle of Endor
(5,28),   -- Han Solo           - Battle of Endor
(34,28),  -- Chewbacca          - Battle of Endor
(1,29),   -- Anakin             - Death of Emperor Palpatine
(101,29), -- Palaptine          - Death of Emperor Palpatine
(3,29),   -- Leia               - Death of Emperor Palpatine
(4,29),   -- Luke               - Death of Emperor Palpatine
(5,29),   -- Han Solo           - Death of Emperor Palpatine
(34,29),  -- Chewbacca          - Death of Emperor Palpatine

(3,30),   -- Leia               - Rise of the New Republic
(4,30),   -- Luke               - Rise of the New Republic
(3,31),   -- Leia               - Galactic Concordance Signed
(3,32),   -- Leia                - Leia Resistance
(4,33),   -- Luke               - Rebuild of Jedi Temple
(6,35),   -- Ben Solo           - Hosnian Prime
(7,35),   -- Rey                - Hosnian Prime
(6,36),   -- Ben Solo           - Battle of Crait
(7,36),   -- Rey                - Battle of Crait
(14,36),  -- Poe Dameron        - Battle of Crait
(15,36),  -- Finn               - Battle of Crait
(6,37),   -- Ben Solo           - Battle of Exegol
(7,37),   -- Rey                - Battle of Exegol
(14,37),  -- Poe Dameron        - Battle of Exegol
(15,37);  -- Finn               - Battle of Exegol


INSERT INTO race_race (superiority_id_race, inferiority_id_race) VALUES
-- Humans are superior to every race, then Sith, then Chiss
-- other races cannot be that directly compared
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6),
(1, 7),
(1, 8),
(1, 9),
(1, 10),
(1, 11),
(1, 12),
(1, 13),
(1, 14),
(1, 15),
(1, 16),
(1, 17),
(1, 18),
(1, 19),
(1, 20),
(1, 21),
(1, 22),
(1, 23),
(1, 24),
(1, 25),
(1, 26),
(1, 27),
(1, 28),
(1, 29),
(1, 30),
(1, 31),
(1, 32),
(1, 33),
(1, 34),
(1, 35),
(1, 36),
(1, 37),
(1, 38),
(1, 39),
(1, 40),
(1, 41),
(1, 42),
(1, 43),
(1, 44),
(1, 45),
(1, 46),
(1, 47),
(1, 48),
(1, 49),
(1, 50),
(1, 51),
(1, 52),
(1, 53),
(1, 54),
(1, 55),
(1, 56),
(1, 57),
(1, 58),
(1, 59),
(1, 60),
(1, 61),
(1, 62),
(1, 63),
(1, 64),
(1, 65),
(1, 66),
(1, 67),
(1, 68),
(1, 69),
(1, 70),
(1, 71),
(1, 72),
(1, 73),
(1, 74),
(1, 75),
(1, 76),
(1, 77),
(1, 78),
(1, 79),
(1, 80),
(1, 81),
(1, 82),
(1, 83),
(1, 84),
(1, 85),
(1, 86),
(1, 87),
(1, 88),
(1, 89),
(1, 90),
(1, 91),
(1, 92),
(1, 93),
(1, 94),
(1, 95),
(1, 96),
(1, 97),
(1, 98),
(1, 99),
(1, 100),
(1, 101),
(1, 102),
(1, 103),
(1, 104),
(1, 105),
(1, 106),
(1, 108),
(1, 109),
(108, 2),
(108, 3),
(108, 4),
(108, 5),
(108, 6),
(108, 7),
(108, 8),
(108, 9),
(108, 10),
(108, 11),
(108, 12),
(108, 13),
(108, 14),
(108, 15),
(108, 16),
(108, 17),
(108, 18),
(108, 19),
(108, 20),
(108, 21),
(108, 22),
(108, 23),
(108, 24),
(108, 25),
(108, 26),
(108, 27),
(108, 28),
(108, 29),
(108, 30),
(108, 31),
(108, 32),
(108, 33),
(108, 34),
(108, 35),
(108, 36),
(108, 37),
(108, 38),
(108, 39),
(108, 40),
(108, 41),
(108, 42),
(108, 43),
(108, 44),
(108, 45),
(108, 46),
(108, 47),
(108, 48),
(108, 49),
(108, 50),
(108, 51),
(108, 52),
(108, 53),
(108, 54),
(108, 55),
(108, 56),
(108, 57),
(108, 58),
(108, 59),
(108, 60),
(108, 61),
(108, 62),
(108, 63),
(108, 64),
(108, 65),
(108, 66),
(108, 67),
(108, 68),
(108, 69),
(108, 70),
(108, 71),
(108, 72),
(108, 73),
(108, 74),
(108, 75),
(108, 76),
(108, 77),
(108, 78),
(108, 79),
(108, 80),
(108, 81),
(108, 82),
(108, 83),
(108, 84),
(108, 85),
(108, 86),
(108, 87),
(108, 88),
(108, 89),
(108, 90),
(108, 91),
(108, 92),
(108, 93),
(108, 94),
(108, 95),
(108, 96),
(108, 97),
(108, 98),
(108, 99),
(108, 100),
(108, 101),
(108, 102),
(108, 103),
(108, 104),
(108, 105),
(108, 106),
(108, 109),
(5, 2),
(5, 3),
(5, 4),
(5, 6),
(5, 7),
(5, 8),
(5, 9),
(5, 10),
(5, 11),
(5, 12),
(5, 13),
(5, 14),
(5, 15),
(5, 16),
(5, 17),
(5, 18),
(5, 19),
(5, 20),
(5, 21),
(5, 22),
(5, 23),
(5, 24),
(5, 25),
(5, 26),
(5, 27),
(5, 28),
(5, 29),
(5, 30),
(5, 31),
(5, 32),
(5, 33),
(5, 34),
(5, 35),
(5, 36),
(5, 37),
(5, 38),
(5, 39),
(5, 40),
(5, 41),
(5, 42),
(5, 43),
(5, 44),
(5, 45),
(5, 46),
(5, 47),
(5, 48),
(5, 49),
(5, 50),
(5, 51),
(5, 52),
(5, 53),
(5, 54),
(5, 55),
(5, 56),
(5, 57),
(5, 58),
(5, 59),
(5, 60),
(5, 61),
(5, 62),
(5, 63),
(5, 64),
(5, 65),
(5, 66),
(5, 67),
(5, 68),
(5, 69),
(5, 70),
(5, 71),
(5, 72),
(5, 73),
(5, 74),
(5, 75),
(5, 76),
(5, 77),
(5, 78),
(5, 79),
(5, 80),
(5, 81),
(5, 82),
(5, 83),
(5, 84),
(5, 85),
(5, 86),
(5, 87),
(5, 88),
(5, 89),
(5, 90),
(5, 91),
(5, 92),
(5, 93),
(5, 94),
(5, 95),
(5, 96),
(5, 97),
(5, 98),
(5, 99),
(5, 100),
(5, 101),
(5, 102),
(5, 103),
(5, 104),
(5, 105),
(5, 106),
(5, 109),

-- Then we have a linear hierarchy:
-- Kaminoan - Zabrak - Wookie - Duros - Mon Calamari - Rodian -
-- Muun - Togruta - Cerean - Trandoshan - Twi'lek - Geonosian -
-- Gungan - Aqualish - Jawa - Tusken
(61, 3),
(61, 21),
(61, 25),
(61, 35),
(61, 27),
(61, 64),
(61, 4),
(61, 13),
(61, 23),
(61, 2),
(61, 71),
(61, 24),
(61, 47),
(61, 51),
(61, 22),

(3, 21),
(3, 25),
(3, 35),
(3, 27),
(3, 64),
(3, 4),
(3, 13),
(3, 23),
(3, 2),
(3, 71),
(3, 24),
(3, 47),
(3, 51),
(3, 22),

(21, 25),
(21, 35),
(21, 27),
(21, 64),
(21, 4),
(21, 13),
(21, 23),
(21, 2),
(21, 71),
(21, 24),
(21, 47),
(21, 51),
(21, 22),

(25, 35),
(25, 27),
(25, 64),
(25, 4),
(25, 13),
(25, 23),
(25, 2),
(25, 71),
(25, 24),
(25, 47),
(25, 51),
(25, 22),

(35, 27),
(35, 64),
(35, 4),
(35, 13),
(35, 23),
(35, 2),
(35, 71),
(35, 24),
(35, 47),
(35, 51),
(35, 22),

(27, 64),
(27, 4),
(27, 13),
(27, 23),
(27, 2),
(27, 71),
(27, 24),
(27, 47),
(27, 51),
(27, 22),

(64, 4),
(64, 13),
(64, 23),
(64, 2),
(64, 71),
(64, 24),
(64, 47),
(64, 51),
(64, 22),

(4, 13),
(4, 23),
(4, 2),
(4, 71),
(4, 24),
(4, 47),
(4, 51),
(4, 22),

(13, 23),
(13, 2),
(13, 71),
(13, 24),
(13, 47),
(13, 51),
(13, 22),

(23, 2),
(23, 71),
(23, 24),
(23, 47),
(23, 51),
(23, 22),

(2, 71),
(2, 24),
(2, 47),
(2, 51),
(2, 22),

(71, 24),
(71, 47),
(71, 51),
(71, 22),

(24, 47),
(24, 51),
(24, 22),

(47, 51),
(47, 22),

(51, 22),

-- Then we have Zhell superior to Taung
(84, 83);

