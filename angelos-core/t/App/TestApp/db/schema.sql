CREATE TABLE artist (
    artistid INTEGER PRIMARY KEY,
    name TEXT NOT NULL 
);

CREATE TABLE cd (
    cdid INTEGER PRIMARY KEY,
    artist INTEGER NOT NULL REFERENCES artist(artistid),
    title TEXT NOT NULL
);

CREATE TABLE track (
    trackid INTEGER PRIMARY KEY,
    cd INTEGER NOT NULL REFERENCES cd(cdid),
    title TEXT NOT NULL
);
