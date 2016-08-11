PRAGMA foreign_keys=OFF;

BEGIN TRANSACTION;

DROP TABLE IF EXISTS sessions;
CREATE TABLE sessions (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	session_key TEXT UNIQUE,
	NAME TEXT,
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
	title TEXT,
	interval INTEGER,
	amount INTEGER DEFAULT NULL,
	time_det INTEGER DEFAULT NULL,
	period INTEGER DEFAULT NULL,
	number_error INTEGER DEFAULT NULL,
	period_repeated_det INTEGER DEFAULT NULL,
	flag INTEGER,
	FOREIGN KEY (master_exp_id) REFERENCES experiments(id),
	FOREIGN KEY (session_key) REFERENCES sessions(session_key)
);

DROP TABLE IF EXISTS setup_conf;
CREATE TABLE setup_conf (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	setup_id INTEGER,
	sensor_id TEXT,
	sensor_val_id INTEGER,
	NAME TEXT,
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
	TIME TEXT,
	sensor_id TEXT,
	sensor_val_id INTEGER,
	detection REAL,
	error TEXT DEFAULT NULL,
	FOREIGN KEY (exp_id) REFERENCES experiments(id),
	FOREIGN KEY (sensor_id) REFERENCES sensors(sensor_id)
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
	exp_id INTEGER,
	setup_id INTEGER,
	uuid TEXT,
	created TEXT,
	deleted INTEGER,
	FOREIGN KEY (exp_id) REFERENCES experiments(id),
	FOREIGN KEY (setup_id) REFERENCES setups(id)
);

COMMIT;
