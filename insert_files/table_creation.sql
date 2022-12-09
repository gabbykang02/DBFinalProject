DROP TABLE IF EXISTS CovidData;
CREATE TABLE CovidData(
    iso_code VARCHAR(10), 
    continent VARCHAR(100), 
    location VARCHAR(100), 
    dateofdata DATE, 
    total_cases INT, 
    new_cases INT, 
    new_cases_smoothed FLOAT, 
    total_deaths INT, 
    new_deaths FLOAT, 
    new_deaths_smoothed FLOAT, 
    total_cases_per_million FLOAT, 
    new_cases_per_million FLOAT, 
    new_cases_smoothed_per_million FLOAT, 
    total_deaths_per_million FLOAT, 
    new_deaths_per_million FLOAT, 
    new_deaths_smoothed_per_million FLOAT,
    reproduction_rate FLOAT,
    population_density FLOAT,
    median_age FLOAT,
    gdp_per_capita FLOAT,
    life_expectancy FLOAT,
    population INT,
    PRIMARY KEY(iso_code, continent, location, dateofdata)
);

DROP TABLE IF EXISTS TitleInfo;
SET CHARACTER SET utf8mb4;
CREATE TABLE TitleInfo (
    tconst VARCHAR(15) NOT NULL,
    type VARCHAR(20),
    promoTitle NVARCHAR(300),
    originalTitle NVARCHAR(600),
    startYear INT,
    endYear INT,
    runTime INT,
    genres VARCHAR(100),
    PRIMARY KEY (tconst)
);

DROP TABLE IF EXISTS TitleTranslated;
SET CHARACTER SET utf8mb4;
CREATE TABLE TitleTranslated(
    tconst VARCHAR(15) NOT NULL,
    translatedTitle NVARCHAR(1000) NOT NULL,
    region VARCHAR(20),
    language VARCHAR(20),
    type VARCHAR(20),
    isOriginalTitle BOOLEAN NOT NULL,
    PRIMARY KEY (tconst)
);

DROP TABLE IF EXISTS Crew;
CREATE TABLE Crew (
    tconst VARCHAR(10) NOT NULL,
    person VARCHAR(4500) NOT NULL,
    role VARCHAR(4500),
    PRIMARY KEY (tconst)
);

DROP TABLE IF EXISTS Episodes;
CREATE TABLE Episodes (
    tconst VARCHAR(10) NOT NULL,
    parentTConst VARCHAR(10) NOT NULL,
    seasonNum INT,
    episodeNum INT,
    PRIMARY KEY (tconst)
);

DROP TABLE IF EXISTS Principals;
CREATE TABLE Principals (
    tconst VARCHAR(10) NOT NULL,
    nconst VARCHAR(10) NOT NULL,
    ordering INT,
    job VARCHAR(200),
    characters VARCHAR(100),
    PRIMARY KEY (tconst)
);

DROP TABLE IF EXISTS Ratings;
CREATE TABLE Ratings (
    tconst VARCHAR(10) NOT NULL,
    averageRating INT,
    numVotes INT,
    PRIMARY KEY (tconst)
);

DROP TABLE IF EXISTS Basics;
CREATE TABLE Basics (
    nconst VARCHAR(10) NOT NULL,
    primaryName VARCHAR(100),
    birthYear INT,
    deathYear INT,
    profession VARCHAR(200),
    knownFor VARCHAR(200),
    PRIMARY KEY(nconst)
);

DROP TABLE IF EXISTS TwitchStats;
CREATE TABLE TwitchStats (
    month VARCHAR(20) NOT NULL,
    hoursWatched BIGINT,
    avgViewers INT,
    peakViewers INT,
    avgChannels INT,
    peakChannels INT,
    hoursStreamed BIGINT,
    gamesStreamed INT,
    activeAffiliates INT,
    activePartners INT,
    PRIMARY KEY(month)
);

DROP TABLE IF EXISTS TwitchWatched;
CREATE TABLE TwitchWatched (
    channel VARCHAR(70) NOT NULL,
    watchTime BIGINT,
    streamTime BIGINT,
    peakViewers INT,
    avgViewers INT,
    followers INT,
    followersGained INT,
    partnered BOOLEAN,
    mature BOOLEAN,
    language VARCHAR(20),
    PRIMARY KEY(channel)
);

DROP TABLE IF EXISTS TwitchGames;
CREATE TABLE TwitchGames (
    game VARCHAR(50) NOT NULL,
    watchTime BIGINT,
    streamTime BIGINT,
    peakViewers INT,
    peakChannels INT,
    streamers VARCHAR(50),
    avgViewers INT,
    avgChannels INT,
    avgViewRatio INT,
    PRIMARY KEY(game)
);


DROP TABLE IF EXISTS Metacritic;
CREATE TABLE Metacritic (
    game VARCHAR(500) NOT NULL,
    metascore FLOAT,
    platform VARCHAR(20),
    date VARCHAR(20),
    userscore FLOAT,
    summary NVARCHAR(6000),
    PRIMARY KEY(game, platform)
);

DROP TABLE IF EXISTS Months;
CREATE TABLE Months(
    num INT,
    full VARCHAR(20),
    abrev VARCHAR(5)
);

INSERT INTO Months VALUES(1, "January", "Jan");
INSERT INTO Months VALUES(2, "February", "Feb");
INSERT INTO Months VALUES(3, "March", "Mar");
INSERT INTO Months VALUES(4, "April", "Apr");
INSERT INTO Months VALUES(5, "May", "May");
INSERT INTO Months VALUES(6, "June", "Jun");
INSERT INTO Months VALUES(7, "July", "Jul");
INSERT INTO Months VALUES(8, "August", "Aug");
INSERT INTO Months VALUES(9, "September", "Sep");
INSERT INTO Months VALUES(10, "October", "Oct");
INSERT INTO Months VALUES(11, "November", "Nov");
INSERT INTO Months VALUES(12, "December", "Dec");

DROP TABLE IF EXISTS GameSales;
CREATE TABLE GameSales (
    game NVARCHAR(500) NOT NULL,
    platform VARCHAR(50),
    genres VARCHAR(100),
    publisher VARCHAR(100),
    developer VARCHAR(500),
    vgscore FLOAT,
    userscore FLOAT,
    totalSales INT,
    naSales INT,
    jpSales INT,
    otherSales INT,
    releaseDate VARCHAR(20),
    lastUpdate VARCHAR(20),
    PRIMARY KEY (game, platform)
);
