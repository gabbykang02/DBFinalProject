DROP PROCEDURE IF EXISTS GetCovidGenres;
DELIMITER //
CREATE PROCEDURE GetCovidGenres (country VARCHAR(100))
BEGIN
"TODO do max aveerage and fix parenthesis"
    SELECT platform, SUM(metascore) / COUNT(DISTINCT(game)) AS avg
    ((SELECT MONTH(covidCountTable.dateofdata) AS month, YEAR(covidCountTable.dateofdata)
    FROM 
    (SELECT MONTH(CovidData.dateofdata) AS month, YEAR(CovidData.dateofdata) as year, SUM(new_cases) AS numCases
        FROM CovidData
        WHERE CovidData.location = country
        GROUP BY MONTH(CovidData.dateofdata), YEAR(CovidData.dateofdata)) AS covidCountTable) 
    RIGHT OUTER JOIN
    (SELECT MAX(numCases) AS max_cases
    FROM 
        (SELECT MONTH(CovidData.dateofdata) AS month, YEAR(CovidData.dateofdata) as year, SUM(new_cases) AS numCases
        FROM CovidData
        WHERE CovidData.location = country
        GROUP BY MONTH(CovidData.dateofdata), YEAR(CovidData.dateofdata)) AS covidCountTable) AS maxTable
    ON covidCountTable.numCases = maxTable.max_cases) AS max_date_table,

    (SELECT num as monthNum, game, platform, metascore, date
    FROM Metacritic JOIN Months 
    ON Metacritic.date like concat('%', Months.full, '%')) AS meta_date_table.monthNum
    WHERE meta_date_table.monthNum = max_date_table.month
        AND meta_date_table.date like concat('%', max_date_table.year, '%')
    GROUP BY platform;
END //
DELIMITER ;

INSERT INTO CovidData VALUES("AFG", "Asia", "Afghanistan", '2020-02-24' ,5.0, 5.0, null, null, null, null, 0.122, 0.122, null, null, null, null, null, 54.422, 18.6, 1803.987, 64.83, 41128772.0);
INSERT INTO CovidData VALUES("AFG", "Asia", "Afghanistan", '2020-03-24' ,5.0, 5.0, null, null, null, null, 0.122, 0.122, null, null, null, null, null, 54.422, 18.6, 1803.987, 64.83, 41128772.0);
INSERT INTO CovidData VALUES("AFG", "Asia", "Afghanistan", '2020-02-26' ,5.0, 5.0, null, null, null, null, 0.122, 0.122, null, null, null, null, null, 54.422, 18.6, 1803.987, 64.83, 41128772.0);
INSERT INTO CovidData VALUES("AFG", "Asia", "Afghanistan", '2020-04-24' ,5.0, 5.0, null, null, null, null, 0.122, 0.122, null, null, null, null, null, 54.422, 18.6, 1803.987, 64.83, 41128772.0);


DROP PROCEDURE IF EXISTS GetCovidViews;
DELIMITER //
CREATE PROCEDURE GetCovidViews (top INT, country VARCHAR(100), startDate DATE, stopDate DATE)
BEGIN

END //
DELIMITER



DROP PROCEDURE IF EXISTS GetCovidTwitchStats;
DELIMITER //
CREATE PROCEDURE GetCovidTwitchStats(command VARCHAR(15))
BEGIN
    SELECT command;
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
CALL GetCovidTwitchStats('hoursWatched');