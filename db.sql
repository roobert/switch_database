-- networks

CREATE TABLE network (
  id       SERIAL PRIMARY KEY,
  location TEXT NOT NULL UNIQUE
);

-- switches

CREATE TABLE switch (
  id             SERIAL PRIMARY KEY,
  network        INTEGER REFERENCES network(id),
  hostname       TEXT NOT NULL,
  stack_position INTEGER NOT NULL,
  CHECK (stack_position > 0 AND stack_position < 1024)
);

CREATE TYPE trunk_mode  AS ENUM ('trunk', '');
CREATE TYPE admin_state AS ENUM ('enabled', 'disabled');
CREATE TYPE port_state  AS ENUM ('disconnected', 'down', 'up');

CREATE TABLE switch_interface (
  id           SERIAL PRIMARY KEY,
  switch       INTEGER REFERENCES switch(id),
  description  TEXT,
  port_group   TEXT,
  speed        INTEGER,
  port         INTEGER NOT NULL,
  duplex       INTEGER,
  state        port_state,
  admin_state  admin_state,
  trunk_mode   trunk_mode,
  CHECK (port > 0 and port < 1024),
  CHECK (duplex % 10 = 0)
);

CREATE TABLE vlan (
  id   SERIAL PRIMARY KEY,
  port INTEGER REFERENCES switch_interface(id),
  vlan INTEGER NOT NULL,
  CHECK (vlan > 0 AND vlan < 4064)
);

-- machines

CREATE TABLE machine (
  id       SERIAL PRIMARY KEY,
  network  INTEGER REFERENCES network(id),
  hostname TEXT NOT NULL UNIQUE,
  CHECK (hostname ~* '^(([a-zA-Z]|[a-zA-Z][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z]|[A-Za-z][A-Za-z0-9\-]*[A-Za-z0-9])$')
);

CREATE TABLE machine_interface (
  id        SERIAL PRIMARY KEY,
  hostname  INTEGER REFERENCES machine(id),
  interface TEXT NOT NULL,
  mac       MACADDR NOT NULL UNIQUE,
  CHECK (interface ~* '^[a-z]+[0-9]+(:[0-9]+)?$')
);

CREATE TABLE ip (
  id   SERIAL PRIMARY KEY,
  port INTEGER REFERENCES machine_interface(id),
  ip   INET NOT NULL
);
