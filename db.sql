--
-- TODO
-- * add stuff to delete related stuff on deletion
--


-- networks

CREATE TABLE network (
  id       SERIAL PRIMARY KEY,
  location TEXT NOT NULL UNIQUE
);

-- hosts

CREATE TABLE host (
  id             SERIAL PRIMARY KEY,
  name           TEXT NOT NULL,
  network_id     INTEGER REFERENCES network(id),
  stack_position INTEGER,
  CHECK          (name ~* '^(([a-zA-Z]|[a-zA-Z][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z]|[A-Za-z][A-Za-z0-9\-]*[A-Za-z0-9])$'),
  CHECK          (stack_position > 0 AND stack_position < 1024)
);

-- switch interfaces

CREATE TABLE switch_interface (
  id          SERIAL PRIMARY KEY,
  host_id     INTEGER REFERENCES host(id),
  description TEXT
);

CREATE TYPE trunk_mode  AS ENUM ('trunk', '');
CREATE TYPE admin_state AS ENUM ('enabled', 'disabled');
CREATE TYPE port_state  AS ENUM ('disconnected', 'down', 'up');

CREATE TABLE ethernet (
  id                   SERIAL PRIMARY KEY,
  switch_interface_id  INTEGER REFERENCES switch_interface(id),
  port                 INTEGER NOT NULL,
  channel_group        TEXT,
  speed                INTEGER,
  duplex               INTEGER,
  state                port_state,
  admin_state          admin_state,
  CHECK                (port > 0 and port < 1024),
  CHECK                (duplex % 10 = 0)
);

CREATE TABLE vlan (
  id                  SERIAL PRIMARY KEY,
  switch_interface_id INTEGER REFERENCES switch_interface(id)
);

CREATE TABLE port_channel (
  id                  SERIAL PRIMARY KEY,
  switch_interface_id INTEGER REFERENCES switch_interface(id)
);

-- switch interface attributes

CREATE TYPE switchport_mode AS ENUM ('access', 'general');

-- tagging mode can be 'tagged, tagging only or null?'
CREATE TABLE switchport (
  id              SERIAL PRIMARY KEY,
  ethernet_id     INTEGER REFERENCES ethernet(id),
  port_channel_id INTEGER REFERENCES port_channel(id),
  mode            switchport_mode NOT NULL,
  tagging         TEXT
);

CREATE TABLE channel_group (
  id          SERIAL  PRIMARY KEY,
  ethernet_id INTEGER REFERENCES ethernet(id),
  group_number INTEGER NOT NULL,
  mode        TEXT    NOT NULL
);

CREATE TYPE portfast_mode AS ENUM ('portfast', 'disable');

CREATE TABLE spanning_tree (
  id                  SERIAL PRIMARY KEY,
  ethernet_id         INTEGER REFERENCES ethernet(id),
  port_channel_id     INTEGER REFERENCES port_channel(id),
  mode                portfast_mode
);

-- machines

CREATE TABLE machine_interface (
  id         SERIAL PRIMARY KEY,
  host_id    INTEGER REFERENCES host(id),
  name       TEXT,
  mac        MACADDR NOT NULL UNIQUE,
  CHECK      (name ~* '^[a-z]+[0-9]+(:[0-9]+)?$')
);

-- machine interface related

CREATE TABLE ip (
  id                   SERIAL PRIMARY KEY,
  machine_interface_id INTEGER REFERENCES machine_interface(id),
  ip                   INET NOT NULL
);
