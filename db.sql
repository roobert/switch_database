-- networks

CREATE TABLE network (
  id       SERIAL PRIMARY KEY,
  location TEXT NOT NULL UNIQUE
);

-- hosts

CREATE TABLE host (
  id       SERIAL PRIMARY KEY,
  name     TEXT NOT NULL UNIQUE,
  network  INTEGER REFERENCES network(id),
  CHECK (name ~* '^(([a-zA-Z]|[a-zA-Z][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z]|[A-Za-z][A-Za-z0-9\-]*[A-Za-z0-9])$')
);

-- switches

CREATE TABLE switch (
  id             SERIAL PRIMARY KEY,
  host           INTEGER REFERENCES host(id),
  stack_position INTEGER NOT NULL,
  CHECK (stack_position > 0 AND stack_position < 1024)
);

-- switch interfaces

CREATE TABLE switch_interface (
  id            SERIAL PRIMARY KEY,
  switch        INTEGER REFERENCES switch(id),
  description   TEXT
);

CREATE TYPE trunk_mode  AS ENUM ('trunk', '');
CREATE TYPE admin_state AS ENUM ('enabled', 'disabled');
CREATE TYPE port_state  AS ENUM ('disconnected', 'down', 'up');

CREATE TABLE switch_interface_ethernet (
  id            SERIAL PRIMARY KEY,
  interface     INTEGER REFERENCES switch_interface(id),
  port          INTEGER NOT NULL,
  channel_group TEXT,
  speed         INTEGER,
  duplex        INTEGER,
  state         port_state,
  admin_state   admin_state,
  CHECK (port > 0 and port < 1024),
  CHECK (duplex % 10 = 0)
);

-- switch interface attributes

CREATE TYPE vlan_mode AS ENUM ('add', 'remove');

CREATE TABLE vlan (
  id        SERIAL PRIMARY KEY,
  interface INTEGER REFERENCES switch_interface_ethernet(id),
  -- FIXME: add constraint
  vlan      INTEGER[] NOT NULL,
  mode      vlan_mode NOT NULL
);

-- currently we dont care about actual switchport params so no checks...
CREATE TABLE switchport (
  id        SERIAL PRIMARY KEY,
  interface INTEGER REFERENCES switch_interface_ethernet(id),
  params    TEXT
);

CREATE TYPE portfast_mode AS ENUM ('portfast', 'disable');

CREATE TABLE spanning_tree (
  id        SERIAL PRIMARY KEY,
  interface INTEGER REFERENCES switch_interface_ethernet(id),
  mode      portfast_mode
);

-- machines

CREATE TABLE machine (
  id       SERIAL PRIMARY KEY,
  host     INTEGER REFERENCES host(id)
);

CREATE TABLE machine_interface (
  id        SERIAL PRIMARY KEY,
  machine   INTEGER REFERENCES machine(id),
  name      TEXT,
  mac       MACADDR NOT NULL UNIQUE,
  CHECK (name ~* '^[a-z]+[0-9]+(:[0-9]+)?$')
);

-- machine interface related

CREATE TABLE ip (
  id   SERIAL PRIMARY KEY,
  port INTEGER REFERENCES machine_interface(id),
  ip   INET NOT NULL
);
