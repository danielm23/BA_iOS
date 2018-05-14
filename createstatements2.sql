CREATE TABLE `geoinformation` (
  `geoinformationID` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(127) DEFAULT NULL,
  `shortinformation` varchar(1023) DEFAULT NULL,
  `detailinformation` varchar(4000) DEFAULT NULL,
  `comment` varchar(63) DEFAULT NULL,
  `created` datetime NOT NULL,
  `updated` smallint(6) NOT NULL,
  `userID` smallint(6) DEFAULT NULL,
  `picture` int(11) DEFAULT NULL,
  PRIMARY KEY (`geoinformationID`)
);


CREATE TABLE geoinformationForGeolocation](
  geoinformationID int NOT NULL,
  geolocationID int NOT NULL,
  PRIMARY KEY (geoinformationID,geolocationID)
);


CREATE TABLE geolocation(
  geolocationID smallint(6) UNSIGNED NOT NULL AUTO_INCREMENT,
  address varchar(127) NULL,
  zip varchar(15) NULL,
  city varchar(63) NULL,
  country varchar(63) NULL,
  location int NULL,
  created datetime NULL,
  updated datetime NULL,
  userID smallint(6) NULL,
  PRIMARY KEY (geolocationID) 
);

USE [DB_mdanielv]
GO

/****** Object:  Table [core].[Group]    Script Date: 05/01/2018 15:24:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [core].[Group](
  [groupID] [int] IDENTITY(1,1) NOT NULL,
  [userID] [int] NULL,
  [moderate] [bit] NOT NULL,
  [title] [nvarchar](60) NOT NULL,
  [picture] [varbinary](max) NULL,
  [created] [smalldatetime] NOT NULL,
  [updated] [smalldatetime] NOT NULL,
  [description] [nvarchar](100) NULL,
  [groupStatusID] [int] NOT NULL,
  [referencedBy] [xml](DOCUMENT [model].[Group]) NULL,
  [pictureID] [int] NULL,
 CONSTRAINT [Group_PK] PRIMARY KEY CLUSTERED 
(
  [groupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [core].[Group]  WITH CHECK ADD  CONSTRAINT [FK_Group_Binary] FOREIGN KEY([pictureID])
REFERENCES [core].[Binary] ([binaryID])
GO

ALTER TABLE [core].[Group] CHECK CONSTRAINT [FK_Group_Binary]
GO

ALTER TABLE [core].[Group]  WITH CHECK ADD  CONSTRAINT [Group_GroupStatus_FK] FOREIGN KEY([groupStatusID])
REFERENCES [model].[GroupStatus] ([groupStatusID])
GO

ALTER TABLE [core].[Group] CHECK CONSTRAINT [Group_GroupStatus_FK]
GO

ALTER TABLE [core].[Group]  WITH CHECK ADD  CONSTRAINT [Group_User_FK] FOREIGN KEY([userID])
REFERENCES [core].[User] ([userID])
GO

ALTER TABLE [core].[Group] CHECK CONSTRAINT [Group_User_FK]
GO

ALTER TABLE [core].[Group] ADD  CONSTRAINT [DF__Group__moderate __2A4B4B5E]  DEFAULT ((0)) FOR [moderate]
GO

ALTER TABLE [core].[Group] ADD  CONSTRAINT [DF_Group_created]  DEFAULT (getdate()) FOR [created]
GO

ALTER TABLE [core].[Group] ADD  CONSTRAINT [DF_Group_updated]  DEFAULT (getdate()) FOR [updated]
GO

