### Setup database
drop database if exists GolfCup;
create database GolfCup;
use GolfCup;

### Create tables
create table player(
	pnr char(20) not null,
	pname varchar(64),
    age int,
    primary key(pnr)
) engine=innodb;

create table competition(
	cname varchar(128) not null,
    cdate datetime,
    primary key(cname)
) engine=innodb;

create table weather(
	wtype varchar(32) not null,
    windspeed double,
    primary key(wtype)
) engine=innodb;

create table construction(
	snr char(20) not null,
    hardness double,
    primary key(snr)
) engine=innodb;

create table jacket(
	pnr char(20), 
	brand varchar(64),
    size varchar(10),
    material varchar(32),
    primary key(brand, pnr),
    foreign key(pnr) references player(pnr)
) engine=innodb;

create table club(
	pnr char(20),
	snr char(20),
    nr char(20),
    material varchar(32),
    primary key(pnr, snr, nr),
    foreign key(pnr) references player(pnr),
    foreign key(snr) references construction(snr)
) engine=innodb;

create table player_competition(
	pnr char(20),
    cname varchar(128),
    primary key(pnr, cname),
    foreign key(pnr) references player(pnr),
    foreign key(cname) references competition(cname)
) engine=innodb;

create table competition_weather(
	cname varchar(128),
    wtype varchar(32),
    wtime datetime,
    primary key(cname, wtype),
    foreign key(cname) references competition(cname),
    foreign key(wtype) references weather(wtype)
) engine=innodb;

### Insert data
insert into player values("19970102-4321", "Johan Andersson", 25);
insert into player values("19920304-6543", "Nicklas Johansson", 30);
insert into player values("19870506-5432", "Annika Persson", 35);
insert into competition values("Big Golf Cup Skövde", "2021-06-10 10:00:00");
insert into player_competition values("19970102-4321", "Big Golf Cup Skövde");
insert into player_competition values("19920304-6543", "Big Golf Cup Skövde");
insert into player_competition values("19870506-5432", "Big Golf Cup Skövde");
insert into weather values("Hail", 10);
insert into competition_weather values("Big Golf Cup Skövde", "Hail", "2021-06-10 12:00:00");
insert into jacket values("19970102-4321", "Generic", "L", "Fleeze");
insert into jacket values("19970102-4321", "Brandier", "L", "GoreTex");
insert into construction values("0123456789", 10);
insert into construction values("1234567890", 5);
insert into club values("19920304-6543", "0123456789", "9876543210", "Wood");
insert into club values("19870506-5432", "1234567890", "8765432109", "Wood");

### Queries
select age from player where pname like "Johan Andersson";
select cdate from competition where cname like "Big Golf Cup Skövde";
select material from club where pnr like "Johan Andersson";
select * from jacket where pnr like (
	select pnr from player where pname like "Johan Andersson"
);
select pname from player where pnr in (
	select pnr from player_competition where cname like "Big Golf Cup Skövde"
);
select windspeed from weather where wtype like (
	select wtype from competition_weather where cname like "Big Golf Cup Skövde"
); 
select * from player where age < 30;
delete from jacket where pnr like (
	select pnr from player where pname like "Johan Andersson"
);
delete from player where pname like "Nicklas Johansson";
select avg(age) from player;



