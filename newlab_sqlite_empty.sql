PRAGMA automatic_index = ON;
PRAGMA busy_timeout = 50000000;
PRAGMA cache_size = 32768;
PRAGMA cache_spill = OFF;
PRAGMA foreign_keys = OFF;
PRAGMA journal_mode = WAL;
PRAGMA journal_size_limit = 67110000;
PRAGMA locking_mode = NORMAL;
PRAGMA page_size = 4096;
PRAGMA recursive_triggers = ON;
PRAGMA secure_delete = ON;
PRAGMA synchronous = NORMAL;
PRAGMA temp_store = MEMORY;
PRAGMA wal_autocheckpoint = 16384;

BEGIN TRANSACTION;

DROP TABLE IF EXISTS sessions;
CREATE TABLE sessions (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	session_key TEXT UNIQUE,
	name TEXT,
	DateStart INTEGER,
	DateEnd INTEGER,
	title TEXT,
	comments TEXT,
	expiry INTEGER
);

INSERT INTO sessions
VALUES (1,'123456','admin','','','Administrator','Administrator session','0');

DROP TABLE IF EXISTS experiments;
CREATE TABLE experiments (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	session_key TEXT,
	title TEXT,
	setup_id INTEGER,
	DateStart_exp INTEGER,
	DateEnd_exp INTEGER,
	comments INTEGER,
	FOREIGN KEY (session_key) REFERENCES sessions(session_key)
);

DROP TABLE IF EXISTS setups;
CREATE TABLE setups (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	master_exp_id INTEGER,
	session_key TEXT,
	access INTEGER DEFAULT NULL,
	title TEXT,
	interval INTEGER,
	amount INTEGER DEFAULT NULL,
	time_det INTEGER DEFAULT NULL,
	period INTEGER DEFAULT NULL,
	number_error INTEGER DEFAULT NULL,
	period_repeated_det INTEGER DEFAULT NULL,
	FOREIGN KEY (master_exp_id) REFERENCES experiments(id),
	FOREIGN KEY (session_key) REFERENCES sessions(session_key)
);

DROP TABLE IF EXISTS setup_conf;
CREATE TABLE setup_conf (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	setup_id INTEGER,
	sensor_id TEXT,
	sensor_val_id INTEGER,
	name TEXT,
	FOREIGN KEY (setup_id) REFERENCES setups(id)
);

DROP TABLE IF EXISTS consumers;
CREATE TABLE consumers (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	setup_id INTEGER,
	exp_id INTEGER,
	FOREIGN KEY (exp_id) REFERENCES experiments(id),
	FOREIGN KEY (setup_id) REFERENCES setups(id)
);

DROP TABLE IF EXISTS sensors;
CREATE TABLE sensors (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	sensor_id TEXT,
	sensor_val_id INTEGER,
	sensor_name TEXT,
	value_name TEXT,
	si_notation TEXT,
	si_name TEXT,
	max_range INTEGER DEFAULT NULL,
	min_range INTEGER DEFAULT NULL,
	error REAL,
	resolution BIGINT DEFAULT NULL
);

DROP TABLE IF EXISTS detections;
CREATE TABLE detections (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	exp_id INTEGER,
	mon_id INTEGER,
	time TEXT,
	sensor_id TEXT,
	sensor_val_id INTEGER,
	detection REAL,
	error TEXT DEFAULT NULL,
	FOREIGN KEY (exp_id) REFERENCES experiments(id),
	FOREIGN KEY (sensor_id) REFERENCES sensors(sensor_id),
	FOREIGN KEY (mon_id) REFERENCES monitors(id)
);

DROP TABLE IF EXISTS plots;
CREATE TABLE plots (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	exp_id INTEGER,
	id_sensor_x INTEGER,
	sensor_val_id_x INTEGER,
	scales REAL,
	start TEXT,
	stop TEXT,
	FOREIGN KEY (exp_id) REFERENCES experiments(id),
	FOREIGN KEY (id_sensor_x) REFERENCES sensors(id)
);

DROP TABLE IF EXISTS ordinate;
CREATE TABLE ordinate (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	id_plot INTEGER,
	id_sensor_y INTEGER,
	sensor_val_id_y INTEGER,
	scales REAL,
	start TEXT,
	stop TEXT,
	FOREIGN KEY (id_plot) REFERENCES plots(id),
	FOREIGN KEY (id_sensor_y) REFERENCES sensors(id)
);

DROP TABLE IF EXISTS monitors;
CREATE TABLE monitors (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	uuid TEXT,
	exp_id INTEGER,
	setup_id INTEGER,
	interval INTEGER,
	amount INTEGER DEFAULT 0,
	duration INTEGER DEFAULT 0,
	created TEXT,
	stopat TEXT,
	active INTEGER,
	FOREIGN KEY (exp_id) REFERENCES experiments(id),
	FOREIGN KEY (setup_id) REFERENCES setups(id)
);

DROP TABLE IF EXISTS monitors_values;
CREATE TABLE monitors_values (
	uuid TEXT,
	name TEXT,
	sensor TEXT,
	valueidx INTEGER,
	UNIQUE (uuid, sensor, valueidx),
	FOREIGN KEY (uuid) REFERENCES monitors(uuid)
);

DROP TABLE IF EXISTS monitors_counters;
CREATE TABLE monitors_counters (
	uuid TEXT PRIMARY KEY,
	done INTEGER,
	err INTEGER,
	FOREIGN KEY (uuid) REFERENCES monitors(uuid)
);

COMMIT;
