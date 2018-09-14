USE [SM]
GO

/****** Object:  Table [dbo].[SInfo]    Script Date: 9/14/2018 8:39:38 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[SInfo](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Open] [varchar](50) NULL,
	[High] [varchar](50) NULL,
	[Low] [varchar](50) NULL,
	[Close] [varchar](50) NULL,
	[Volume] [varchar](50) NULL,
	[AvgPrice] [varchar](50) NULL,
	[Name] [varchar](50) NULL,
	[LastPrice] [varchar](50) NULL,
	[orderColum] [varchar](50) NULL,
	[buycolumn] [varchar](max) NULL,
	[sellColumn] [varchar](max) NULL,
	[BuyOrders] [varchar](max) NULL,
	[SellOrders] [varchar](max) NULL,
	[AddedDate] [datetime] NULL CONSTRAINT [DF_SInfo_AddedDate14]  DEFAULT (getdate())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


