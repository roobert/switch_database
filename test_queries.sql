-- populate networks
INSERT INTO network (location) VALUES ('brighton');
INSERT INTO network (location) VALUES ('bunker');

SELECT * FROM network;

-- add switch hosts
INSERT INTO host (name, stack_position, network_id) SELECT 'ispsw01f',  1, id FROM network WHERE location = 'brighton';
INSERT INTO host (name, stack_position, network_id) SELECT 'ispsw01f',  2, id FROM network WHERE location = 'brighton';
INSERT INTO host (name, stack_position, network_id) SELECT 'ispsw03xa', 1, id FROM network WHERE location = 'bunker';
INSERT INTO host (name, stack_position, network_id) SELECT 'ispsw03xa', 2, id FROM network WHERE location = 'bunker';
INSERT INTO host (name, stack_position, network_id) SELECT 'ispsw03xg', 1, id FROM network WHERE location = 'bunker';
INSERT INTO host (name, stack_position, network_id) SELECT 'ispsw03xg', 2, id FROM network WHERE location = 'bunker';
INSERT INTO host (name, stack_position, network_id) SELECT 'ispsw03yc', 1, id FROM network WHERE location = 'bunker';
INSERT INTO host (name, stack_position, network_id) SELECT 'ispsw03yc', 2, id FROM network WHERE location = 'bunker';
INSERT INTO host (name, stack_position, network_id) SELECT 'ispsw03yh', 1, id FROM network WHERE location = 'bunker';
INSERT INTO host (name, stack_position, network_id) SELECT 'ispsw03yh', 2, id FROM network WHERE location = 'bunker';

-- add machines
INSERT INTO host (name, network_id) SELECT 'devrob01a',  id FROM network WHERE location = 'brighton';
INSERT INTO host (name, network_id) SELECT 'devrob01b',  id FROM network WHERE location = 'brighton';
INSERT INTO host (name, network_id) SELECT 'devrob01c',  id FROM network WHERE location = 'brighton';
INSERT INTO host (name, network_id) SELECT 'devrob01d',  id FROM network WHERE location = 'brighton';

SELECT * FROM host;

-- add switch interfaces
INSERT INTO switch_interface (description, host_id) SELECT 'cspblah01a-description', id FROM host WHERE name = 'ispsw01f' AND stack_position = 1;
INSERT INTO switch_interface (description, host_id) SELECT 'cspblah01b-eth1', id FROM host WHERE name = 'ispsw01f' AND stack_position = 1;
INSERT INTO switch_interface (description, host_id) SELECT 'cspblah01c-eth8', id FROM host WHERE name = 'ispsw01f' AND stack_position = 2;
INSERT INTO switch_interface (description, host_id) SELECT 'cspblah01d-eth1', id FROM host WHERE name = 'ispsw01f' AND stack_position = 2;

SELECT * FROM switch_interface;

-- add machine interfaces
INSERT INTO machine_interface (name, mac, host_id) SELECT 'eth0', '000000000000', id FROM host WHERE name = 'devrob01a';
INSERT INTO machine_interface (name, mac, host_id) SELECT 'eth1', '000000000001', id FROM host WHERE name = 'devrob01a';
INSERT INTO machine_interface (name, mac, host_id) SELECT 'eth8', '000000000002', id FROM host WHERE name = 'devrob01c';
INSERT INTO machine_interface (name, mac, host_id) SELECT 'eth9', '000000000003', id FROM host WHERE name = 'devrob01d';

SELECT * FROM machine_interface;

-- join examples

SELECT network.location, host.name, host.stack_position, switch_interface.description FROM host
  INNER JOIN switch_interface
  ON switch_interface.host_id = host.id
  INNER JOIN network
  ON host.network_id = network.id;

SELECT network.location, host.name, machine_interface.name, machine_interface.mac FROM host
  INNER JOIN machine_interface
  ON machine_interface.host_id = host.id
  INNER JOIN network
  ON host.network_id = network.id;

-- view examples

CREATE VIEW switch_interface_stuff AS
SELECT network.location AS network, host.name AS switch, host.stack_position AS stack_position, switch_interface.description AS description FROM host
  INNER JOIN switch_interface
  ON switch_interface.host_id = host.id
  INNER JOIN network
  ON host.network_id = network.id;


SELECT * FROM switch_interface_stuff;

CREATE VIEW machine_interface_stuff AS
SELECT network.location AS network, host.name AS machine, machine_interface.name AS interface, machine_interface.mac AS mac FROM host
  INNER JOIN machine_interface
  ON machine_interface.host_id = host.id
  INNER JOIN network
  ON host.network_id = network.id;

SELECT * FROM machine_interface_stuff;
