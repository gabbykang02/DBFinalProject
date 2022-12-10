/*1. List the month, year, average scores and average number of Gamesales for GENRE games released after YEAR grouped by month.
*/

DELIMITER //
DROP PROCEDURE IF EXISTS GetGameScoresPerGenre;
CREATE PROCEDURE GetGameScoresPerGenre(IN genre VARCHAR(20), IN year VARCHAR(5))
BEGIN

        IF EXISTS(SELECT genres FROM GameSales WHERE GameSales.genres = genre) THEN 
        WITH ALLSUBGAMES AS(
        SELECT * FROM GameSales GS WHERE GS.genres = genre AND GS.releaseDate <> "NULL"
        )

        SELECT count(AG.game) Totalgamesreleased, MONTHNAME(date(AG.releaseDate)) Monthofrelease, YEAR(date(AG.releaseDate)) Year,
         Round(Avg(AG.vgscore),2) Avgvgscore, Round(Avg(AG.userscore),3) Avguserscore, Round(Avg(AG.totalSales),3) AvgtotalSales, Round(Avg(AG.jpSales),3) AvgjpSales, Round(Avg(AG.naSales),3) AvgnaSales 
        FROM ALLSUBGAMES AG WHERE genres = 'Action' and YEAR(date(AG.releaseDate)) > year 
        group by Monthofrelease;
        

                
        ELSE SELECT 'Specified genre doesn''t exist, Please enter a valid genre' AS 'Error Message';
        END IF;

END //
DELIMITER ; 


/*2. whats the most viewed game in twitch during the peak covid cases month in the country and continent in the input year tg
*/



DELIMITER //
DROP PROCEDURE IF EXISTS getmostwatchedgame;
CREATE PROCEDURE getmostwatchedgame(
  IN p_year INT,
  IN p_continent VARCHAR(255),
  IN p_country VARCHAR(255)
)
BEGIN
  IF EXISTS(SELECT location FROM CovidData WHERE LOWER(continent) = LOWER(p_continent) AND lower(CovidData.location) = lower(p_country)) THEN 
  SELECT 
    game Mostwatchedgame
  FROM TwitchGames
  WHERE
  game <> 'Just Chatting' and 
    year = p_year AND
    month = (SELECT T.MOH FROM (SELECT MONTH(dateofdata) MOH, SUM(new_cases) TCNEW FROM CovidData WHERE YEAR(dateofdata) = p_year and LOWER(continent) = LOWER(p_continent) AND
    LOWER(location) = LOWER(p_country) GROUP BY MOH ORDER BY TCNEW DESC LIMIT 1)T)
  ORDER BY
    hoursWatched DESC
  LIMIT 1;
  ELSE SELECT 'Specified country is not in that continent, Please enter a valid country' AS 'Error Message';
  END IF;
END //
DELIMITER ; 

/*3. Get movie recommendations based on genre, year, film type {tvEpisode    |
| short        |
| movie        |
| tvSeries     |
| video        |
| tvSpecial    |
| tvMiniSeries |
| tvMovie      |
| videoGame    |
| tvShort}input for all genres of top 10 ratings*/

DELIMITER //
DROP PROCEDURE IF EXISTS getmovieoninputgenre ;
CREATE PROCEDURE getmovieoninputgenre(IN P_YEAR INT, IN P_GENRE VARCHAR(20))
  BEGIN
    select t2.originalTitle,rt1.averageRating,t2.startYear,t2.genres,t2.type from 
      (select t1.tconst tconst, t1.originalTitle, t1.startYear, t1.type, t1.genres from TitleInfo t1 where t1.startYear = P_YEAR
                           AND  INSTR(LOWER(genres),LOWER(P_GENRE) ) > 0)t2
      INNER JOIN 
      (SELECT rt.averageRating, rt.tconst from Ratings rt)rt1
      on rt1.tconst = t2.tconst
      ORDER by rt1.averageRating desc limit 10;
  END //
  DELIMITER ;
  
  
 /*4. Get movie recommendations which have a give startyear as input for all genres of top 2 highest ratings*/

DELIMITER //
DROP PROCEDURE IF EXISTS getmoviesofall ;
CREATE PROCEDURE getmoviesofall(IN P_YEAR INT)
  BEGIN


  

    DECLARE LANGNAME VARCHAR(50) DEFAULT "";
    DECLARE FINISHED INTEGER DEFAULT 0;
    DECLARE CURRENT_RECORD CURSOR FOR
    SELECT T3.*
    FROM   (
                           SELECT DISTINCT(TW.genres)
                           FROM       TitleInfo     TW)T3;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET FINISHED = 1;
    OPEN CURRENT_RECORD;
    main_loop:
    LOOP
      FETCH CURRENT_RECORD
      INTO  LANGNAME;
      
      IF FINISHED = 1 THEN
        LEAVE MAIN_LOOP;
      END IF;
    
      select t2.originalTitle,rt1.averageRating,t2.startYear,t2.genres,t2.type from 
    (select ay.* from (select t1.tconst tconst, t1.originalTitle, t1.startYear, t1.type, t1.genres from TitleInfo t1 where t1.startYear > P_YEAR
                         AND  INSTR(LOWER(genres),LOWER(LANGNAME) ) > 0) ay)t2
    INNER JOIN 
    (SELECT rt.averageRating, rt.tconst from Ratings rt)rt1
    on rt1.tconst = t2.tconst
    ORDER by rt1.averageRating desc limit 2;

      SET FINISHED = 0;
    END LOOP;
    CLOSE CURRENT_RECORD;
  END //
  DELIMITER ;


/*5. Get the individual top channel according to followers for given language */

DELIMITER //
DROP PROCEDURE IF EXISTS gettopchannelinlanguage;
CREATE PROCEDURE gettopchannelinlanguage(IN p_language VARCHAR(255))
BEGIN
    SELECT     TWITCHWATCHED1.CL1 channel,
                 TWITCHWATCHED1.WT1 followers ,
                 PRICETYPES.L2      language
      FROM       (
                          SELECT   TW.channel        CL1,
                                   Max(TW.followers) WT1
                          FROM     TwitchWatched TW
                          WHERE    TW.language = p_language
                          GROUP BY TW.channel ) TWITCHWATCHED1
      INNER JOIN
                 (
                          SELECT   T2.channel   CL2,
                                   T2.followers WT2,
                                   T2.language  L2
                          FROM     TwitchWatched T2
                          WHERE    T2.language = p_language
                          GROUP BY T2.channel,
                                   T2.watchTime ) PRICETYPES
      ON         PRICETYPES.CL2 = TWITCHWATCHED1.CL1
      AND        PRICETYPES.WT2 = TWITCHWATCHED1.WT1
      ORDER BY   TWITCHWATCHED1.WT1 DESC
      LIMIT      1 ;
END //
DELIMITER ; 


/*6. Get the individual top channel for each language which has been watched the most*/

DELIMITER //
DROP PROCEDURE IF EXISTS GETTOPCHANNELSBYLANGUAGE ;
CREATE PROCEDURE GETTOPCHANNELSBYLANGUAGE()
  BEGIN
    DECLARE LANGNAME VARCHAR(50) DEFAULT "";
    DECLARE FINISHED INTEGER DEFAULT 0;
    DECLARE CURRENT_RECORD CURSOR FOR
    SELECT T3.*
    FROM   (
                           SELECT DISTINCT(TW.language)
                           FROM            TwitchWatched TW)T3;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET FINISHED = 1;
    OPEN CURRENT_RECORD;
    main_loop:
    LOOP
      FETCH CURRENT_RECORD
      INTO  LANGNAME;
      
      IF FINISHED = 1 THEN
        LEAVE MAIN_LOOP;
      END IF;

      SELECT     TWITCHWATCHED1.CL1 channel,
                 TWITCHWATCHED1.WT1 watchTime ,
                 PRICETYPES.L2      language
      FROM       (
                          SELECT   TW.channel        CL1,
                                   Max(TW.watchTime) WT1
                          FROM     TwitchWatched TW
                          WHERE    TW.language = LANGNAME
                          GROUP BY TW.channel ) TWITCHWATCHED1
      INNER JOIN
                 (
                          SELECT   T2.channel   CL2,
                                   T2.watchTime WT2,
                                   T2.language  L2
                          FROM     TwitchWatched T2
                          WHERE    T2.language = LANGNAME
                          GROUP BY T2.channel,
                                   T2.watchTime ) PRICETYPES
      ON         PRICETYPES.CL2 = TWITCHWATCHED1.CL1
      AND        PRICETYPES.WT2 = TWITCHWATCHED1.WT1
      ORDER BY   TWITCHWATCHED1.WT1 DESC
      LIMIT      1 ;
      
      SET FINISHED = 0;
    END LOOP;
    CLOSE CURRENT_RECORD;
  END //
  DELIMITER ;
  
  /*7. whats are the top most viewed games in twitch during the peak covid cases month in the input year tg
*/



DELIMITER //
DROP PROCEDURE IF EXISTS gettopwatchedgames;
CREATE PROCEDURE gettopwatchedgames(
  IN p_year INT
)
BEGIN
  IF EXISTS(SELECT total_cases FROM CovidData WHERE YEAR(dateofdata) = p_year) THEN 
  
  SELECT 
    game Topwatchedgames
  FROM TwitchGames
  WHERE
  game <> 'Just Chatting' and 
    year = p_year AND
    month = (SELECT T.MOH FROM (SELECT MONTH(dateofdata) MOH, SUM(new_cases) TCNEW FROM CovidData WHERE YEAR(dateofdata) = p_year GROUP BY MOH ORDER BY TCNEW DESC LIMIT 1)T)
  ORDER BY
    hoursWatched DESC
  LIMIT 20;
  ELSE SELECT 'Specified year is not valid, Please enter a valid year' AS 'Error Message';
  END IF;
END //
DELIMITER ; 

