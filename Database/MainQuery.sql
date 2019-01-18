
Declare @query varchar(max),@name varchar(100)
Declare @NonClusteredName varchar(200) 

DECLARE db_cursor CURSOR FOR 
select name from sys.tables Order By name
OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @name  

WHILE @@FETCH_STATUS = 0  
BEGIN  


set @NonClusteredName=NewId();

set  @query = '
Declare @smName varchar(1000),
@AddedDate datetime =Replace('''+@name+''','' '',''-'') +'' 15:20:54.480''

	
Declare @table table
(
Name varchar(50),
BuyCount varchar(500),
SellCount varchar(500),
BuyMinPrice varchar(500),
BuyMaxPrice varchar(500),
SellMinPrice varchar(500),
SellMaxPrice varchar(500),
OpenPrice varchar(500),
HighPrice varchar(500),
LowPrice varchar(500),
ClosePrice varchar(500),
Volume varchar(500)
)

	
DECLARE emp_cursor CURSOR FOR     
SELECT distinct Name from [dbo].['+@name+'] 

OPEN emp_cursor    
  
FETCH NEXT FROM emp_cursor     
INTO @smName
WHILE @@FETCH_STATUS = 0    
BEGIN    
IF OBJECT_ID(''tempdb..#temp'') IS NOT NULL
    DROP TABLE #temp

Declare @buycount varchar(100),
@sellCount varchar(100),
@buyMinPrice varchar(100),
@BuyMaxPrice varchar(100),
@sellMinPrice varchar(100),
@sellMaxPrice varchar(100),
@openPrice varchar(100),
@LowPrice varchar(100),
@closePrice varchar(100),
@highPrice varchar(100),
@volume varchar(100),
@Percen varchar(100)

print @SMNAME
select ROW_NUMBER() over(Order by addeddate) as rnumn ,REPLACE(volume,'','','''') as volumn1 ,*  into #temp from [dbo].['+@name+'] where name=@smName and Volume!=''NA''
AND AddedDate >@AddedDate AND BuyOrders!=''0'' AND SellOrders!=''0''



select @buycount= sum(trade) from (
select case when t1.LastPrice>t2.LastPrice then -1 else 1 end as buy, CONVERT(int,t2.volumn1)-CONVERT(int, t1.volumn1) as trade from #temp as t1 inner join #temp as t2 
on t1.rnumn+1=t2.rnumn
where CONVERT(int,t2.volumn1-CONVERT(int, t1.volumn1))>0 ) as t2  where buy=1 
 

select @sellcount= sum(trade) from (
select case when t1.LastPrice>t2.LastPrice then -1 else 1 end as buy, CONVERT(int,t2.volumn1)-CONVERT(int, t1.volumn1) as trade from #temp as t1 inner join #temp as t2 
on t1.rnumn+1=t2.rnumn
where CONVERT(int,t2.volumn1-CONVERT(int, t1.volumn1))>0 AND t2.AddedDate >@AddedDate) as t2  where buy=-1

select @buyMinPrice= Min(LastPrice) from (
select case when t1.LastPrice>t2.LastPrice then -1 else 1 end as buy, t2.LastPrice from #temp as t1 inner join #temp as t2 
on t1.rnumn+1=t2.rnumn
where CONVERT(int,t2.volumn1-CONVERT(int, t1.volumn1))>0 AND t2.AddedDate >@AddedDate) as t2  where buy=1


select @BuyMaxPrice= Max(LastPrice) from (
select case when t1.LastPrice>t2.LastPrice then -1 else 1 end as buy, t2.LastPrice from #temp as t1 inner join #temp as t2 
on t1.rnumn+1=t2.rnumn
where CONVERT(int,t2.volumn1-CONVERT(int, t1.volumn1))>0 AND t2.AddedDate >@AddedDate) as t2  where buy=1


select @sellMinPrice= Min(LastPrice) from (
select case when t1.LastPrice>t2.LastPrice then -1 else 1 end as buy, t2.LastPrice from #temp as t1 inner join #temp as t2 
on t1.rnumn+1=t2.rnumn
where CONVERT(int,t2.volumn1-CONVERT(int, t1.volumn1))>0 AND t2.AddedDate >@AddedDate) as t2  where buy=-1


select @sellMaxPrice= Max(LastPrice) from (
select case when t1.LastPrice>t2.LastPrice then -1 else 1 end as buy, t2.LastPrice from #temp as t1 inner join #temp as t2 
on t1.rnumn+1=t2.rnumn
where CONVERT(int,t2.volumn1-CONVERT(int, t1.volumn1))>0 AND t2.AddedDate >@AddedDate) as t2  where buy=-1

select top 1 @openPrice =[Open],@closePrice=[Close],@highPrice=High,@LowPrice=Low,@volume=volumn1 from #temp order by AddedDate desc


		
insert into @table (Name,BuyCount,SellCount,BuyMinPrice,BuyMaxPrice,SellMinPrice,SellMaxPrice,LowPrice,ClosePrice,HighPrice,OpenPrice,Volume)
values(@smName,@buycount,@sellCount,@buyMinPrice,@BuyMaxPrice,@sellMinPrice,@sellMaxPrice,@LowPrice,@closePrice,@highPrice,@openPrice,@volume)
		
		FETCH NEXT FROM emp_cursor     
INTO @smName
   
END     
CLOSE emp_cursor;    
DEALLOCATE emp_cursor;  

insert into temp24
SELECT '''+Replace(@name,' ','')+''', * FROM (
select *,case when name!= '''' then CONVERT(decimal,BuyCount)- convert(decimal,SellCount) else 0 end as Difference
,case when name!= '''' AND CONVERT(decimal(16,2),BuyCount) >0 then convert(decimal(16,2),(CONVERT(decimal(16,2),SellCount)- convert(decimal(16,2),BuyCount))/CONVERT(decimal(16,2),BuyCount)) else 0 end as Difference1
,case when name!= '''' AND CONVERT(decimal(16,2),SellCount) >0 then convert(decimal(16,2),(CONVERT(decimal(16,2),BuyCount)- convert(decimal(16,2),SellCount))/CONVERT(decimal(16,2),SellCount)) else 0 end as DifferenceSell
 from @table) AS T1
 WHERE T1.Difference1>0.5 OR DifferenceSell>2
  '

print @query
exec (@query)
	  
      FETCH NEXT FROM db_cursor INTO @name 
END 

CLOSE db_cursor  
DEALLOCATE db_cursor 


--select * from temp24