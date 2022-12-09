DROP PROCEDURE IF EXISTS GetMaxCovid;
DELIMITER // 
CREATE PROCEDURE GetMaxCovid(country VARCHAR(100))
BEGIN
    SELECT baseTable.month, baseTable.year, baseTable.numCases
    FROM
            (SELECT month, year, numCases
            FROM 
            (SELECT MONTH(CovidData.dateofdata) AS month, YEAR(CovidData.dateofdata) as year, SUM(new_cases) AS numCases
                FROM CovidData
                WHERE CovidData.location = country
                GROUP BY MONTH(CovidData.dateofdata), YEAR(CovidData.dateofdata)) AS covidCountTable) AS baseTable
        RIGHT OUTER JOIN
            (SELECT MAX(numCases) AS max_cases
            FROM 
                (SELECT MONTH(CovidData.dateofdata) AS month, YEAR(CovidData.dateofdata) as year, SUM(new_cases) AS numCases
                FROM CovidData
                WHERE CovidData.location = country
                GROUP BY MONTH(CovidData.dateofdata), YEAR(CovidData.dateofdata)) AS covidCountTable) AS maxTable
        ON baseTable.numCases = maxTable.max_cases;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS GetCovidPlatforms;
DELIMITER //
CREATE PROCEDURE GetCovidPlatforms (country VARCHAR(100))
BEGIN
    SELECT platform, SUM(metascore) / COUNT(DISTINCT(game)) AS avg
    FROM
        (SELECT baseTable.month, baseTable.year, baseTable.numCases
        FROM 
            (SELECT month, year, numCases
            FROM 
            (SELECT MONTH(CovidData.dateofdata) AS month, YEAR(CovidData.dateofdata) as year, SUM(new_cases) AS numCases
                FROM CovidData
                WHERE CovidData.location = country
                GROUP BY MONTH(CovidData.dateofdata), YEAR(CovidData.dateofdata)) AS covidCountTable) AS baseTable
        RIGHT OUTER JOIN
            (SELECT MAX(numCases) AS max_cases
            FROM 
                (SELECT MONTH(CovidData.dateofdata) AS month, YEAR(CovidData.dateofdata) as year, SUM(new_cases) AS numCases
                FROM CovidData
                WHERE CovidData.location = country
                GROUP BY MONTH(CovidData.dateofdata), YEAR(CovidData.dateofdata)) AS covidCountTable) AS maxTable
        ON baseTable.numCases = maxTable.max_cases) AS max_date_table,
    (SELECT num as monthNum, game, platform, metascore, date, REGEXP_SUBSTR(RIGHT(date,4),"[0-9]+") AS year
    FROM Metacritic JOIN Months 
    ON Metacritic.date like concat('%', Months.full, '%')) AS meta_date_table

    WHERE meta_date_table.monthNum = max_date_table.month
        AND meta_date_table.date like concat('%', max_date_table.year, '%')
    GROUP BY platform;
END //
DELIMITER ;



INSERT INTO CovidData VALUES("AFG", "Asia", "US", '2020-02-24' ,5.0, 5.0, null, null, null, null, 0.122, 0.122, null, null, null, null, null, 54.422, 18.6, 1803.987, 64.83, 41128772.0);
INSERT INTO CovidData VALUES("AFG", "Asia", "US", '2020-03-24' ,5.0, 5.0, null, null, null, null, 0.122, 0.122, null, null, null, null, null, 54.422, 18.6, 1803.987, 64.83, 41128772.0);
INSERT INTO CovidData VALUES("AFG", "Asia", "US", '2020-02-26' ,5.0, 5.0, null, null, null, null, 0.122, 0.122, null, null, null, null, null, 54.422, 18.6, 1803.987, 64.83, 41128772.0);
INSERT INTO CovidData VALUES("AFG", "Asia", "US", '2020-04-24' ,5.0, 5.0, null, null, null, null, 0.122, 0.122, null, null, null, null, null, 54.422, 18.6, 1803.987, 64.83, 41128772.0);


DROP PROCEDURE IF EXISTS GetStatCumulative;
DELIMITER //
CREATE PROCEDURE GetStatCumulative ( country VARCHAR(100), startMonth INT, startYear INT, stopMonth INT, stopYear INT)
BEGIN
    SELECT dateofdata, new_cases, new_deaths
    FROM CovidData
    WHERE CovidData.location = country AND 
        MONTH(CovidData.dateofdata) >= startMonth AND MONTH(CovidData.dateofdata) <= stopMonth AND
        YEAR(CovidData.dateofdata) >= startYear AND YEAR(CovidData.dateofdata) <= stopYear;

    SELECT num AS months, year, SUM(hoursWatched) AS hoursWatched, SUM(avgViewers) AS avgViewers, SUM(peakViewers) AS peakViewers,
            SUM(avgChannels) AS avgChannels, SUM(peakChannels) AS peakChannels, SUM(hoursStreamed) AS hoursStreamed, 
            SUM(gamesStreamed) AS gamesStreamed, SUM(activeAffiliates) AS activeAffiliates, SUM(activePartners) AS activePartners
    FROM 
        (SELECT *, REGEXP_SUBSTR(month,"[0-9]+") AS year
        FROM TwitchStats JOIN Months 
        ON TwitchStats.month like concat('%', Months.full, '%')) AS twitchMonths
    WHERE twitchMonths.num >= startMonth AND twitchMonths.num <= stopMonth
        AND twitchMonths.year >= startYear AND twitchMonths.num <= stopYear
    GROUP BY num, year;
END //
DELIMITER ;



DROP PROCEDURE IF EXISTS GetCovidTwitchStats;
DELIMITER //
CREATE PROCEDURE GetCovidTwitchStats(command VARCHAR(15))
BEGIN
    SELECT num, abrev, REGEXP_SUBSTR(month,"[0-9]+") AS year, 
    CASE command
        WHEN 'hoursWatched' THEN hoursWatched
        WHEN 'avgViewers' THEN avgViewers
        WHEN 'peakViewers' THEN peakViewers
        WHEN 'avgChannels' THEN avgChannels
        WHEN 'peakChannels' THEN peakChannels
        WHEN 'hoursStreamed' THEN hoursStreamed
        WHEN 'gamesStreamed' THEN gamesStreamed
        WHEN 'activeAffiliates' THEN activeAffiliates
        WHEN 'activePartners' THEN activePartners
        ELSE 'ERROR: Invalid Twitch statistic'
    END AS selected
    FROM
    (SELECT *
    FROM TwitchStats JOIN Months 
    ON TwitchStats.month like concat('%', Months.full, '%')) AS twitchMonths;
END //
DELIMITER ; 