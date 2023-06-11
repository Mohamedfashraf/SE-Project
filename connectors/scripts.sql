CREATE TABLE IF NOT EXISTS se_project.users
(
    id SERIAL NOT NULL,
    firstname TEXT NOT NULL,
    lastname TEXT NOT NULL,
    email TEXT NOT NULL,
    password TEXT NOT NULL,
    roleid INTEGER NOT NULL,
    CONSTRAINT users_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS se_project.sessions
(
    id SERIAL NOT NULL,
    userid INTEGER NOT NULL,
    token TEXT NOT NULL,
    expiresat TIMESTAMP NOT NULL,
    CONSTRAINT sessions_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS se_project.roles
(
    id SERIAL NOT NULL,
    role TEXT NOT NULL,
    CONSTRAINT roles_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS se_project.zones
(
    id SERIAL NOT NULL,
    zonetype TEXT NOT NULL,
    price INTEGER NOT NULL,
    CONSTRAINT zones_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS se_project.subscription
(
    id SERIAL NOT NULL,
    subtype TEXT NOT NULL,
    zoneid INTEGER NOT NULL,
    userid INTEGER NOT NULL,
    nooftickets INTEGER NOT NULL,
    CONSTRAINT subscription_pkey PRIMARY KEY (id),
    FOREIGN KEY (userid) REFERENCES se_project.users(id),
    FOREIGN KEY (zoneid) REFERENCES se_project.zones(id)
);

CREATE TABLE IF NOT EXISTS se_project.tickets
(
    id SERIAL NOT NULL,
    origin TEXT NOT NULL,
    destination TEXT NOT NULL,
    userid INTEGER NOT NULL,
    subid INTEGER,
    tripdate TIMESTAMP NOT NULL,
    FOREIGN KEY (userid) REFERENCES se_project.users(id),
    FOREIGN KEY (subid) REFERENCES se_project.subscription(id),
    CONSTRAINT tickets_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS se_project.rides
(
    id SERIAL NOT NULL,
    status TEXT NOT NULL,
    origin TEXT NOT NULL,
    destination TEXT NOT NULL,
    userid INTEGER NOT NULL,
    ticketid INTEGER NOT NULL,
    tripdate TIMESTAMP NOT NULL,
    FOREIGN KEY (userid) REFERENCES se_project.users(id),
    FOREIGN KEY (ticketid) REFERENCES se_project.tickets(id),
    CONSTRAINT rides_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS se_project.transactions
(
    id SERIAL NOT NULL,
    amount INTEGER NOT NULL,
    userid INTEGER NOT NULL,
    purchasedid TEXT NOT NULL,
    FOREIGN KEY (userid) REFERENCES se_project.users(id),
    CONSTRAINT transactions_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS se_project.refund_requests
(
    id SERIAL NOT NULL,
    status TEXT NOT NULL,
    userid INTEGER NOT NULL,
    refundamount INTEGER NOT NULL,
    ticketid INTEGER NOT NULL,
    FOREIGN KEY (userid) REFERENCES se_project.users(id),
    FOREIGN KEY (ticketid) REFERENCES se_project.tickets(id),
    CONSTRAINT refund_requests_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS se_project.senior_requests
(
    id SERIAL NOT NULL,
    status TEXT NOT NULL,
    userid INTEGER NOT NULL,
    nationalid INTEGER NOT NULL,
    FOREIGN KEY (userid) REFERENCES se_project.users(id),
    CONSTRAINT senior_requests_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS se_project.stations
(
    id SERIAL NOT NULL,
    stationname TEXT NOT NULL,
    stationtype TEXT NOT NULL,
    stationposition TEXT,
    stationstatus TEXT NOT NULL,
    CONSTRAINT stations_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS se_project.routes
(
    id SERIAL NOT NULL,
    routename TEXT NOT NULL,
    fromstationid INTEGER NOT NULL,
    tostationid INTEGER NOT NULL,
    CONSTRAINT routes_pkey PRIMARY KEY (id),
    FOREIGN KEY (fromstationid) REFERENCES se_project.stations (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (tostationid) REFERENCES se_project.stations (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS se_project.stationroutes
(
    id SERIAL NOT NULL,
    stationid INTEGER NOT NULL,
    routeid INTEGER NOT NULL,
    CONSTRAINT stationroutes_pkey PRIMARY KEY (id),
    FOREIGN KEY (stationid) REFERENCES se_project.stations (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (routeid) REFERENCES se_project.routes (id) ON DELETE CASCADE ON PDATE CASCADE
);

INSERT INTO se_project.roles (role) VALUES ('user');
INSERT INTO se_project.roles (role) VALUES ('admin');
INSERT INTO se_project.roles (role) VALUES ('senior');