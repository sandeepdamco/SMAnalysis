USE [SMShort]
GO

/****** Object:  StoredProcedure [dbo].[sp_Cal]    Script Date: 1/18/2019 4:13:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[sp_Cal]
AS
Begin
Declare @query varchar(max),@name varchar(100)

DECLARE db_cursor CURSOR FOR 
select tablename from tblname where profit is null
OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @name  

WHILE @@FETCH_STATUS = 0  
BEGIN  



Declare @DateT varchar(100) 
Set @DateT =@name
Declare @Profit varchar(100),
@loss varchar(100),@successCount varchar(100),@failureCount varchar(100)

IF OBJECT_ID('tempdb..#temp') IS NOT NULL
    DROP TABLE #temp

select * into #temp from 
(
Select 
case when RSLT =0 then CONVERT(float,[Close])-CONVERT(float,[Open]) else RSLT* convert(float, [Open])*.01 end as FM,* from (
select case when t.high>t.TGT then 1 when t.Low<t.SL then -1 else  0 end as RSLT, * from (
select
CONVERT(float,dt.[open]) - CONVERT(float,dt.[open])*.01+.10 SL,
 CONVERT(float,dt.[open]) +CONVERT(float,dt.[open])*.01+.10 TGT, 
 dt.*
 from temp24 as t1
inner join tblName as tn on tn.TableName = t1.DateT
Inner join DailyStat as dt on 
tn.NextDayTableName=dt.Date
AND t1.Name = dt.Name
where DateT=@DateT 
 AND CONVERT(Float,t1.DifferenceSell) > 1
 AND CONVERT(float,dt.[open])  >100
 and dt.[Open] <  t1.BuyMinPrice 
 --and dt.[Open] >convert(float,t1.BuyMinPrice)+
 --and dt.[Open] between t1.BuyMinPrice and  t1.BuyMaxPrice 
 ) as t) as t2 

UNION ALL

select  case when RSLT =0 then CONVERT(float,[Close])-CONVERT(float,[Open]) else RSLT* convert(float, [Open])*.01 end as FM,* from (
select case when t.high>t.TGT then -1 when t.Low<t.SL then 1 else  0 end as RSLT, * from (
select
CONVERT(float,dt.[open]) - CONVERT(float,dt.[open])*.01+.10 SL,
 CONVERT(float,dt.[open]) +CONVERT(float,dt.[open])*.01+.10 TGT, dt.*
 from temp24 as t1
inner join tblName as tn on tn.TableName = t1.DateT
Inner join DailyStat as dt on 
tn.NextDayTableName=dt.Date
AND t1.Name = dt.Name
where DateT=@DateT 
 AND CONVERT(Float,t1.DifferenceSell) < 0.0
 AND CONVERT(float,dt.[open])  >100
 and dt.[Open] >  t1.BuyMaxPrice 
 --and dt.[Open] between t1.BuyMinPrice and  t1.BuyMaxPrice 
 ) as t) as t2
) as T2 

insert into Temp25 
select * from #temp
    


select @Profit = FM from (
Select RSLT,sum(FM) AS FM from #temp as t3 group by RSLT) as T1
where T1.RSLT=1


select @loss = FM from (
Select RSLT,sum(FM) AS FM from #temp as t3 group by RSLT) as T1
where T1.RSLT=-1



select @successCount = FM from (
Select RSLT,count(FM) AS FM from #temp as t3 group by RSLT) as T1
where T1.RSLT=1


select @failureCount = FM from (
Select RSLT,count(FM) AS FM from #temp as t3 group by RSLT) as T1
where T1.RSLT=-1

print  @Profit 

print  @loss

update tblname set Profit =@Profit,Loss=@loss,
SuccessCount = @successCount,FailureCount=@failureCount
 where TableName=@DateT


      FETCH NEXT FROM db_cursor INTO @name 
END 

CLOSE db_cursor  
DEALLOCATE db_cursor 


END
GO


