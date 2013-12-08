-- populate networks
INSERT INTO network (location) VALUES 'brighton';
INSERT INTO network (location) VALUES 'bunker';

-- add switches
INSERT INTO host (name) VALUES 'ispsw01f';
INSERT INTO host (name) VALUES 'ispsw03xa';
INSERT INTO host (name) VALUES 'ispsw03xg';
INSERT INTO host (name) VALUES 'ispsw03yc';
INSERT INTO host (name) VALUES 'ispsw03yh';

-- populates switches
INSERT INTO switch (host, stack_position, network) SELECT id FROM host WHERE name = 'ispsw01f', 1, id FROM network WHERE location = 'brighton';
INSERT INTO switch (host, stack_position, network) SELECT id FROM host WHERE name = 'ispsw01f', 2, id FROM network WHERE location = 'brighton';

INSERT INTO switch (host, stack_position, network) SELECT id FROM host WHERE name = 'ispsw03xa', 1, id FROM network WHERE location = 'bunker';
INSERT INTO switch (host, stack_position, network) SELECT id FROM host WHERE name = 'ispsw03xa', 2, id FROM network WHERE location = 'bunker';
INSERT INTO switch (host, stack_position, network) SELECT id FROM host WHERE name = 'ispsw03xg', 1, id FROM network WHERE location = 'bunker';
INSERT INTO switch (host, stack_position, network) SELECT id FROM host WHERE name = 'ispsw03xg', 2, id FROM network WHERE location = 'bunker';
INSERT INTO switch (host, stack_position, network) SELECT id FROM host WHERE name = 'ispsw03yc', 1, id FROM network WHERE location = 'bunker';
INSERT INTO switch (host, stack_position, network) SELECT id FROM host WHERE name = 'ispsw03yc', 2, id FROM network WHERE location = 'bunker';
INSERT INTO switch (host, stack_position, network) SELECT id FROM host WHERE name = 'ispsw03yh', 1, id FROM network WHERE location = 'bunker';
INSERT INTO switch (host, stack_position, network) SELECT id FROM host WHERE name = 'ispsw03yh', 2, id FROM network WHERE location = 'bunker';

-- populate switch interfaces
INSERT INTO switch_interface (port, switch) SELECT 1, id FROM switch WHERE hostname = 'ispsw01f' AND stack_position = 1;
INSERT INTO switch_interface (port, switch) SELECT 2, id FROM switch WHERE hostname = 'ispsw01f' AND stack_position = 1;
INSERT INTO switch_interface (port, switch) SELECT 3, id FROM switch WHERE hostname = 'ispsw01f' AND stack_position = 1;
INSERT INTO switch_interface (port, switch) SELECT 4, id FROM switch WHERE hostname = 'ispsw01f' AND stack_position = 1;
INSERT INTO switch_interface (port, switch) SELECT 5, id FROM switch WHERE hostname = 'ispsw01f' AND stack_position = 1;
INSERT INTO switch_interface (port, switch) SELECT 6, id FROM switch WHERE hostname = 'ispsw01f' AND stack_position = 1;
INSERT INTO switch_interface (port, switch) SELECT 7, id FROM switch WHERE hostname = 'ispsw01f' AND stack_position = 1;
INSERT INTO switch_interface (port, switch) SELECT 8, id FROM switch WHERE hostname = 'ispsw01f' AND stack_position = 1;
INSERT INTO switch_interface (port, switch) SELECT 9, id FROM switch WHERE hostname = 'ispsw01f' AND stack_position = 1;

INSERT INTO switch_interface (port, switch) SELECT 1, id FROM switch WHERE hostname = 'ispsw03xa' AND stack_position = 1;
INSERT INTO switch_interface (port, switch) SELECT 2, id FROM switch WHERE hostname = 'ispsw03xa' AND stack_position = 1;
INSERT INTO switch_interface (port, switch) SELECT 3, id FROM switch WHERE hostname = 'ispsw03xa' AND stack_position = 1;
INSERT INTO switch_interface (port, switch) SELECT 4, id FROM switch WHERE hostname = 'ispsw03xa' AND stack_position = 1;
INSERT INTO switch_interface (port, switch) SELECT 5, id FROM switch WHERE hostname = 'ispsw03xa' AND stack_position = 1;
INSERT INTO switch_interface (port, switch) SELECT 6, id FROM switch WHERE hostname = 'ispsw03xa' AND stack_position = 1;
INSERT INTO switch_interface (port, switch) SELECT 7, id FROM switch WHERE hostname = 'ispsw03xa' AND stack_position = 1;
INSERT INTO switch_interface (port, switch) SELECT 8, id FROM switch WHERE hostname = 'ispsw03xa' AND stack_position = 1;
INSERT INTO switch_interface (port, switch) SELECT 9, id FROM switch WHERE hostname = 'ispsw03xa' AND stack_position = 1;

-- populate machines
INSERT INTO machine (hostname, network) SELECT 'isptest01a', id FROM network WHERE location = 'brighton';
INSERT INTO machine_interface (interface, mac, hostname) SELECT 'eth0', '00:11:22:33:44:55', id FROM machine WHERE hostname = 'isptest01a';

-- run some queries
SELECT network.location, machine.hostname FROM machine
  INNER JOIN network ON machine.network = network.id;

SELECT network.location, machine.hostname, machine_interface.interface FROM network
  INNER JOIN machine ON network.id = machine.network
  INNER JOIN machine_interface ON machine.id = machine_interface.hostname;

