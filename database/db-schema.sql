USE FeedMeUpRest;
GO

CREATE TABLE [dbo].[Bill](
	[BillID] [int] NOT NULL,
	[BillDescription] [nvarchar](300) NOT NULL,
	[BillPrice] [float] NOT NULL,
 CONSTRAINT [PK_Bill] PRIMARY KEY CLUSTERED 
(
	[BillID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[Hospital](
	[HospitalID] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Address] [nvarchar](100) NOT NULL,
	[PhoneNumber] [nvarchar](50) NULL,
	[EmailAddress] [nvarchar](50) NULL,
	[Website] [nvarchar](50) NULL,
 CONSTRAINT [PK_Hospital] PRIMARY KEY CLUSTERED 
(
	[HospitalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[Patient](
	[PatientID] [int] NOT NULL,
	[FirstName] [nvarchar](100) NOT NULL,
	[LastName] [nvarchar](100) NOT NULL,
	[Age] [int] NOT NULL,
	[Gender] [nvarchar](50) NOT NULL,
	[PhoneNumber] [nvarchar](20) NULL,
	[Disease] [nvarchar](200) NULL,
	[Treatment] [nvarchar](300) NULL,
PRIMARY KEY CLUSTERED 
(
	[PatientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[Patient_Room](
	[PatientID] [int] NOT NULL,
	[RoomID] [int] NOT NULL,
	[BillID] [int] NOT NULL,
	[CheckInDate] [date] NOT NULL,
	[CheckOutDate] [date] NOT NULL
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[Patient_Staff](
	[PatientID] [int] NOT NULL,
	[StaffID] [int] NOT NULL
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[Room](
	[RoomID] [int] NOT NULL,
	[RoomNumber] [int] NOT NULL,
	[RoomType] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Room] PRIMARY KEY CLUSTERED 
(
	[RoomID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[Staff](
	[StaffID] [int] NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[StaffType] [nvarchar](50) NULL,
	[HospitalID] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_Staff] PRIMARY KEY CLUSTERED 
(
	[StaffID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[Patient_Staff]  WITH CHECK ADD  CONSTRAINT [FK_Patient_Staff_Staff] FOREIGN KEY([PatientID])
REFERENCES [dbo].[Staff] ([StaffID])
GO
ALTER TABLE [dbo].[Patient_Staff] CHECK CONSTRAINT [FK_Patient_Staff_Staff]
GO
USE [master]
GO
ALTER DATABASE [HOSPITAL] SET  READ_WRITE 
GO

/*************************************
		  		VIEWS
*************************************/


CREATE VIEW VW_ShowListOfPatientsByStaff
AS
	SELECT	P.FirstName AS PFN, 
			P.LastName AS PLN, 
			P.Age, 
			P.Gender, 
			P.PhoneNumber, 
			P.Disease, 
			P.Treatment, 
			PS.StaffID, 
			S.FirstName AS SFN, 
			S.LastName AS SLN, 
			S.StaffType
	FROM Patient AS P
		INNER JOIN Patient_Staff AS PS
		ON P.PatientID = PS.PatientID
		INNER JOIN Staff AS S
		ON PS.StaffID = S.StaffID
GO


CREATE VIEW VW_ShowTreatmentAndNumberOfDaysFromPatient
AS
	SELECT	P.FirstName AS 'Patient First Name',
			P.LastName,
			P.Disease,
			P.Treatment,
			PR.RoomID,
			PR.CheckInDate,
			PR.CheckOutDate,
			B.BillDescription,
			B.BillPrice	
	FROM Patient AS P
	INNER JOIN Patient_Room AS PR
	ON P.PatientID = PR.PatientID
	INNER JOIN Bill AS B
	ON PR.BillID = B.BillID
GO


CREATE VIEW VW_ListOfPatientsInSurgery
AS
	SELECT	P.FirstName AS 'Patient First Name',
			P.LastName AS 'Patient Last Name',
			P.Disease,
			P.Treatment,
			R.RoomType,
			S.StaffType
	FROM Patient AS P
	INNER JOIN Patient_Room AS PR
	ON P.PatientID = PR.PatientID
	INNER JOIN Room AS R
	ON PR.RoomID = R.RoomID
	INNER JOIN Patient_Staff AS PS
	ON P.PatientID = PS.PatientID
	INNER JOIN Staff AS S
	ON PS.StaffID = S.StaffID
GO

