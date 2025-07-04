USE [master]
GO
/****** Object:  Database [US_Candy]    Script Date: 2025-04-08 3:08:13 PM ******/
CREATE DATABASE [US_Candy]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'US_Candy', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\US_Candy.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'US_Candy_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\US_Candy_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [US_Candy] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [US_Candy].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [US_Candy] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [US_Candy] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [US_Candy] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [US_Candy] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [US_Candy] SET ARITHABORT OFF 
GO
ALTER DATABASE [US_Candy] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [US_Candy] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [US_Candy] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [US_Candy] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [US_Candy] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [US_Candy] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [US_Candy] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [US_Candy] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [US_Candy] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [US_Candy] SET  DISABLE_BROKER 
GO
ALTER DATABASE [US_Candy] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [US_Candy] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [US_Candy] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [US_Candy] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [US_Candy] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [US_Candy] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [US_Candy] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [US_Candy] SET RECOVERY FULL 
GO
ALTER DATABASE [US_Candy] SET  MULTI_USER 
GO
ALTER DATABASE [US_Candy] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [US_Candy] SET DB_CHAINING OFF 
GO
ALTER DATABASE [US_Candy] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [US_Candy] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [US_Candy] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [US_Candy] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'US_Candy', N'ON'
GO
ALTER DATABASE [US_Candy] SET QUERY_STORE = ON
GO
ALTER DATABASE [US_Candy] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [US_Candy]
GO
/****** Object:  Table [dbo].[Candy_Factories]    Script Date: 2025-04-08 3:08:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Candy_Factories](
	[Factory] [nvarchar](50) NOT NULL,
	[Latitude] [float] NOT NULL,
	[Longitude] [float] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Candy_Products]    Script Date: 2025-04-08 3:08:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Candy_Products](
	[Division] [nvarchar](50) NOT NULL,
	[Product_Name] [nvarchar](50) NOT NULL,
	[Factory] [nvarchar](50) NOT NULL,
	[Product_ID] [nvarchar](50) NOT NULL,
	[Unit_Price] [float] NOT NULL,
	[Unit_Cost] [float] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Candy_Sales]    Script Date: 2025-04-08 3:08:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Candy_Sales](
	[Row_ID] [smallint] NOT NULL,
	[Order_ID] [nvarchar](50) NOT NULL,
	[Order_Date] [date] NOT NULL,
	[Ship_Date] [date] NOT NULL,
	[Ship_Mode] [nvarchar](50) NOT NULL,
	[Customer_ID] [int] NOT NULL,
	[Country_Region] [nvarchar](50) NOT NULL,
	[City] [nvarchar](50) NOT NULL,
	[State_Province] [nvarchar](50) NOT NULL,
	[Postal_Code] [nvarchar](50) NOT NULL,
	[Division] [nvarchar](50) NOT NULL,
	[Region] [nvarchar](50) NOT NULL,
	[Product_ID] [nvarchar](50) NOT NULL,
	[Product_Name] [nvarchar](50) NOT NULL,
	[Sales] [float] NOT NULL,
	[Units] [tinyint] NOT NULL,
	[Gross_Profit] [float] NOT NULL,
	[Cost] [float] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Candy_Targets]    Script Date: 2025-04-08 3:08:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Candy_Targets](
	[Division] [nvarchar](50) NOT NULL,
	[Target] [smallint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[US_Zips]    Script Date: 2025-04-08 3:08:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[US_Zips](
	[zip] [int] NOT NULL,
	[lat] [float] NULL,
	[lng] [float] NULL,
	[city] [nvarchar](50) NOT NULL,
	[state_id] [nvarchar](50) NOT NULL,
	[state_name] [nvarchar](50) NOT NULL,
	[zcta] [nvarchar](50) NOT NULL,
	[parent_zcta] [nvarchar](1) NULL,
	[population] [int] NULL,
	[density] [float] NULL,
	[county_fips] [int] NOT NULL,
	[county_name] [nvarchar](50) NOT NULL,
	[county_weights] [nvarchar](100) NOT NULL,
	[county_names_all] [nvarchar](100) NOT NULL,
	[county_fips_all] [nvarchar](50) NOT NULL,
	[imprecise] [nvarchar](50) NOT NULL,
	[military] [nvarchar](50) NOT NULL,
	[timezone] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
USE [master]
GO
ALTER DATABASE [US_Candy] SET  READ_WRITE 
GO
