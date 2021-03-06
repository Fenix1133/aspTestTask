USE [master]
GO
/****** Object:  Database [testTask_persons]    Script Date: 04.08.2017 7:33:37 ******/
CREATE DATABASE [testTask_persons]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'testTask_persons', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.LOCALHOST\MSSQL\DATA\testTask_persons.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'testTask_persons_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.LOCALHOST\MSSQL\DATA\testTask_persons_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [testTask_persons] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [testTask_persons].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [testTask_persons] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [testTask_persons] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [testTask_persons] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [testTask_persons] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [testTask_persons] SET ARITHABORT OFF 
GO
ALTER DATABASE [testTask_persons] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [testTask_persons] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [testTask_persons] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [testTask_persons] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [testTask_persons] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [testTask_persons] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [testTask_persons] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [testTask_persons] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [testTask_persons] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [testTask_persons] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [testTask_persons] SET  DISABLE_BROKER 
GO
ALTER DATABASE [testTask_persons] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [testTask_persons] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [testTask_persons] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [testTask_persons] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [testTask_persons] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [testTask_persons] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [testTask_persons] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [testTask_persons] SET RECOVERY FULL 
GO
ALTER DATABASE [testTask_persons] SET  MULTI_USER 
GO
ALTER DATABASE [testTask_persons] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [testTask_persons] SET DB_CHAINING OFF 
GO
ALTER DATABASE [testTask_persons] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [testTask_persons] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'testTask_persons', N'ON'
GO
USE [testTask_persons]
GO
/****** Object:  StoredProcedure [dbo].[addPerson]    Script Date: 04.08.2017 7:33:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[addPerson]
	@surname	varchar(75),
	@name		varchar(75),
	@patronymic	varchar(75)
As
Begin

	If Exists(
				Select id
				From persons
				Where surname = @surname
						And
					  name = @name	
						And
					  patronymic = @patronymic				
			 )
		Begin

			--RaisError('There is already such a person in the table', -1, -1)
			Declare @msg nvarchar(2048) = FORMATMESSAGE(60000, N'First string', N'second string'); 
			Throw 60000, 'There is already such a person in the table', 1; 
		End
	Else
		Begin

			Insert into persons
			Select @surname, @name, @patronymic, getDate() 

		End


End
GO
/****** Object:  StoredProcedure [dbo].[searchPerson]    Script Date: 04.08.2017 7:33:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[searchPerson]
	@surname	varchar(75) = null,
	@name		varchar(75) = null,
	@patronymic	varchar(75) = null
As
Begin

	Select	
		surname, 
		name, 
		patronymic
	From persons 
	Where	( surname like '%' + @surname + '%' Or @surname is NULL)
				And
			( name like '%' + @name + '%' Or @name is NULL)
				And
			( patronymic like '%' + @patronymic + '%' Or @patronymic is NULL)

End
GO
/****** Object:  Table [dbo].[persons]    Script Date: 04.08.2017 7:33:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[persons](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[surname] [varchar](75) NULL,
	[name] [varchar](75) NULL,
	[patronymic] [varchar](75) NULL,
	[createDate] [datetime] NULL,
 CONSTRAINT [PK_persons] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[persons] ON 

INSERT [dbo].[persons] ([id], [surname], [name], [patronymic], [createDate]) VALUES (2, N'Макаров', N'Анатолий', N'Алексеевич', CAST(N'2017-08-03 00:00:00.000' AS DateTime))
INSERT [dbo].[persons] ([id], [surname], [name], [patronymic], [createDate]) VALUES (3, N'Киселева', N'Валентина', N'Анатольевна', CAST(N'2017-08-03 00:00:00.000' AS DateTime))
INSERT [dbo].[persons] ([id], [surname], [name], [patronymic], [createDate]) VALUES (4, N'Галлямова', N'Роза', N'Мавлевеевна', CAST(N'2017-08-03 00:00:00.000' AS DateTime))
INSERT [dbo].[persons] ([id], [surname], [name], [patronymic], [createDate]) VALUES (5, N'Борюшкин', N'Александр', N'Андреевич', CAST(N'2017-08-03 00:00:00.000' AS DateTime))
INSERT [dbo].[persons] ([id], [surname], [name], [patronymic], [createDate]) VALUES (6, N'Сидорова', N'Людмила', N'Григорьевна', CAST(N'2017-08-03 00:00:00.000' AS DateTime))
INSERT [dbo].[persons] ([id], [surname], [name], [patronymic], [createDate]) VALUES (7, N'Мазитова', N'Мавлия', N'Разябовна', CAST(N'2017-08-03 18:36:54.367' AS DateTime))
INSERT [dbo].[persons] ([id], [surname], [name], [patronymic], [createDate]) VALUES (8, N'Иванов', N'Иван', N'Иванович', CAST(N'2017-08-03 20:07:39.860' AS DateTime))
SET IDENTITY_INSERT [dbo].[persons] OFF
USE [master]
GO
ALTER DATABASE [testTask_persons] SET  READ_WRITE 
GO
