--Kelompok 4--
--12S20013 - Lydia Tesalonika--
--12S20018 - Gabriella Putri Panjaitan--
--12S20020 - Wahyu Kridangol Yanti Simamora--
--12S20037 - Angelita Dumaria Panjaitan--
--12S20040 - Esphi Aphelina Hutabarat--
--12S20043 - Sevia Rajagukguk--


DROP DATABASE kickstarter
GO
CREATE DATABASE kickstarter
GO
ALTER DATABASE kickstarter
SET RECOVERY SIMPLE
GO

USE kickstarter
;

GO
CREATE SCHEMA kickstarter
GO






/* Drop table Kickstarter.dim_location*/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'kickstarter.DimLocation') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE kickstarter.dim_location
;

/* Create table kickstarter.dim_location */
CREATE TABLE kickstarter.dim_location(
   [location_id]	int NOT NULL
,  [country_name]	char(100)
, CONSTRAINT [PK_Kickstarter.dim_location] PRIMARY KEY CLUSTERED 
( [location_id] )
) ON [PRIMARY]
;

INSERT INTO Kickstarter.dim_location (location_id, country_name)
VALUES (1, 'United States')
;

;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[Kickstarter].[Location]'))
DROP VIEW [Kickstarter].[Location]
GO
CREATE VIEW [Kickstarter].[Location] AS 
SELECT [location_id] AS [location_id]
, [country_name] AS [country_name]
FROM Kickstarter.dim_location
GO

drop TABLE Kickstarter.dim_project;
/* Create table Kickstarter.dim_project */
CREATE TABLE Kickstarter.dim_project(
   [project_id]	int NOT NULL
,  [project_name]	varchar(500) NOT NULL
,  [project_blurb]	varchar(500) NOT NULL
,  [project_state]	varchar(15) NOT NULL
, CONSTRAINT [PK_Kickstarter.dim_project] PRIMARY KEY CLUSTERED 
( [project_id] )
) ON [PRIMARY]
;

INSERT INTO Kickstarter.dim_project (project_id, project_name, project_blurb, project_state)
VALUES (112, 'Tutomade - Enceinte DIY 2.1 100W Eco-Friendly', 'Enceinte hifi stereo 2.1 customisable et à assembler soi-même. Evolutive et éco-friendly. Connectivité bluetooth 4.2 et jack 3.5mm.', 'failed')
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[Kickstarter].[Project]'))
DROP VIEW [Kickstarter].[Project]
GO
CREATE VIEW [Kickstarter].[Project] AS 
SELECT [project_id] AS [project_id]
, [project_name] AS [project_name]
, [project_blurb] AS [project_blurb]
, [project_state] AS [project_state]
FROM Kickstarter.dim_project
GO

/* Drop table Kickstarter.dim_date */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'Kickstarter.DimDate') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE Kickstarter.dim_date 
;

/* Create table Kickstarter.dim_date  */
CREATE TABLE Kickstarter.dim_date  (
   [date_id]	int NOT NULL
,  [day_of_year] double precision
,  [month]  double precision
,  [year]   double precision
,  [quarter] double precision
,  [month_name] varchar(24)
,  [day_of_week] varchar(24)
,  [day_of_week_name] varchar(24)
,  [day_of_month] varchar(24)
,  [holiday_description] varchar(24)
,  [is_a_holiday] varchar(24)
, CONSTRAINT [PK_Kickstarter.dim_date] PRIMARY KEY CLUSTERED 
( [date_id] )
) ON [PRIMARY]
;


INSERT INTO Kickstarter.dim_date (date_id, day_of_year, month, year, quarter, month_name, day_of_week, day_of_week_name, day_of_month, holiday_description, is_a_holiday )
VALUES (1, 2.0, 1.0, 2009.0, 1.0, 'January', 'Friday', '6', '2', 'null', '0.0')
;


-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[ Kickstarter].[Date]'))
DROP VIEW [ Kickstarter].[Date]
GO
CREATE VIEW [Kickstarter].[Date] AS 
SELECT [date_id] AS [date_id]
,  [day_of_year] AS [day_of_year]
,  [month]  AS [month]
,  [year]   AS [year] 
,  [quarter] AS [quarter]
,  [month_name] AS [month_name]
,  [day_of_week] AS [day_of_week]
,  [day_of_week_name] AS [day_of_week_name]
,  [day_of_month] AS [day_of_month]
,  [holiday_description] AS [holiday_description]
,  [is_a_holiday] AS [is_a_holiday]
FROM Kickstarter.dim_date
GO

--create table dim_category--
CREATE TABLE Kickstarter.dim_category(
   [category_id]	int NOT NULL
,  [category_name]	varchar(500) NOT NULL
, CONSTRAINT [PK_Kickstarter.dim_category] PRIMARY KEY CLUSTERED 
( [category_id] )
) ON [PRIMARY]
;

INSERT INTO Kickstarter.dim_category (category_id, category_name)
VALUES (1, 'Webcomics')
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[Kickstarter].[Project]'))
DROP VIEW [Kickstarter].[Project]
GO
CREATE VIEW [Kickstarter].[Category] AS 
SELECT [category_id] AS [categoryid]
, [category_name] AS [category_name]
FROM Kickstarter.dim_category
GO



/* Drop table Kickstarter.fact_campaign*/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'Kickstarter.FactCampaign') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE Kickstarter.fact_campaign
;


/* Create table Kickstarter.fact_campaign */
CREATE TABLE Kickstarter.fact_campaign(
   [category_id]  int         NOT NULL
,  [location_id]  int         NOT NULL
,  [project_id]   int         NOT NULL
,  [date_id]      int        NOT NULL
,  [goal]  double precision         NOT NULL
,  [pledged] double precision         NOT NULL
CONSTRAINT CompositeKey PRIMARY KEY ([category_id], [location_id], [project_id], [date_id])
);

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[Kickstarter].[NotedCampaign]'))
DROP VIEW [Kickstarter].[Campaign]
GO
CREATE VIEW [Kickstarter].[Campaign] AS 
SELECT [category_id] AS [category_dim_id]
, [location_id] AS [location_id]
, [project_id] AS [project_id]
, [date_id] AS [date_id]
, [goal] AS [goal]
, [pledged] AS [pledged]
FROM Kickstarter.fact_campaign
GO

ALTER TABLE Kickstarter.fact_campaign ADD CONSTRAINT
   FK_Kickstarter_fact_campaign_location_id FOREIGN KEY
   (
   location_id
   ) REFERENCES Kickstarter.dim_location
   ( location_id)
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE Kickstarter.fact_campaign  ADD CONSTRAINT
   FK_Kickstarter_fact_campaign_project_id FOREIGN KEY
   (
   project_id
   ) REFERENCES Kickstarter.dim_project
   ( project_id )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;

ALTER TABLE Kickstarter.fact_campaign ADD CONSTRAINT
   FK_Kickstarter_fact_campaign_date_id FOREIGN KEY
   (
   date_id
   ) REFERENCES Kickstarter.dim_date
   ( date_id )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;

ALTER TABLE Kickstarter.fact_campaign ADD CONSTRAINT
   FK_Kickstarter_fact_campaign_category_dim_id FOREIGN KEY
   (
   category_id
   ) REFERENCES Kickstarter.dim_category
   ( category_id )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 