Declare @smName varchar(1000)
Declare @table table
(
Name varchar(50),
BuyCount varchar(500),
SellCount varchar(500),
BuyMinPrice varchar(500),
BuyMaxPrice varchar(500),
SellMinPrice varchar(500),
SellMaxPrice varchar(500)
)
DECLARE emp_cursor CURSOR FOR     
SELECT distinct Name from sinfo 
--where name like '%HCLTECH%'
OPEN emp_cursor    
  
FETCH NEXT FROM emp_cursor     
INTO @smName
WHILE @@FETCH_STATUS = 0    
BEGIN    
IF OBJECT_ID('tempdb..#temp') IS NOT NULL
    DROP TABLE #temp

Declare @buycount varchar(100),
@sellCount varchar(100),
@buyMinPrice varchar(100),
@BuyMaxPrice varchar(100),
@sellMinPrice varchar(100),
@sellMaxPrice varchar(100)

select ROW_NUMBER() over(Order by addeddate) as rnumn ,REPLACE(volume,',','') as volumn1 ,*  into #temp from SInfo where name=@smName 
AND AddedDate >'2018-10-08 15:20:54.480'

select @buycount= sum(trade) from (
select case when t1.LastPrice>t2.LastPrice then -1 else 1 end as buy, CONVERT(int,t2.volumn1)-CONVERT(int, t1.volumn1) as trade from #temp as t1 inner join #temp as t2 
on t1.rnumn+1=t2.rnumn
where CONVERT(int,t2.volumn1-CONVERT(int, t1.volumn1))>0 ) as t2  where buy=1


select @sellcount= sum(trade) from (
select case when t1.LastPrice>t2.LastPrice then -1 else 1 end as buy, CONVERT(int,t2.volumn1)-CONVERT(int, t1.volumn1) as trade from #temp as t1 inner join #temp as t2 
on t1.rnumn+1=t2.rnumn
where CONVERT(int,t2.volumn1-CONVERT(int, t1.volumn1))>0 AND t2.AddedDate >'2018-10-08 15:20:54.480') as t2  where buy=-1

select @buyMinPrice= Min(LastPrice) from (
select case when t1.LastPrice>t2.LastPrice then -1 else 1 end as buy, t2.LastPrice from #temp as t1 inner join #temp as t2 
on t1.rnumn+1=t2.rnumn
where CONVERT(int,t2.volumn1-CONVERT(int, t1.volumn1))>0 AND t2.AddedDate >'2018-10-08 15:20:54.480') as t2  where buy=1


select @BuyMaxPrice= Max(LastPrice) from (
select case when t1.LastPrice>t2.LastPrice then -1 else 1 end as buy, t2.LastPrice from #temp as t1 inner join #temp as t2 
on t1.rnumn+1=t2.rnumn
where CONVERT(int,t2.volumn1-CONVERT(int, t1.volumn1))>0 AND t2.AddedDate >'2018-10-08 15:20:54.480') as t2  where buy=1


select @sellMinPrice= Min(LastPrice) from (
select case when t1.LastPrice>t2.LastPrice then -1 else 1 end as buy, t2.LastPrice from #temp as t1 inner join #temp as t2 
on t1.rnumn+1=t2.rnumn
where CONVERT(int,t2.volumn1-CONVERT(int, t1.volumn1))>0 AND t2.AddedDate >'2018-10-08 15:20:54.480') as t2  where buy=-1


select @sellMaxPrice= Max(LastPrice) from (
select case when t1.LastPrice>t2.LastPrice then -1 else 1 end as buy, t2.LastPrice from #temp as t1 inner join #temp as t2 
on t1.rnumn+1=t2.rnumn
where CONVERT(int,t2.volumn1-CONVERT(int, t1.volumn1))>0 AND t2.AddedDate >'2018-10-08 15:20:54.480') as t2  where buy=-1
		
insert into @table (Name,BuyCount,SellCount,BuyMinPrice,BuyMaxPrice,SellMinPrice,SellMaxPrice)
values(@smName,@buycount,@sellCount,@buyMinPrice,@BuyMaxPrice,@sellMinPrice,@sellMaxPrice)
		
		FETCH NEXT FROM emp_cursor     
INTO @smName
   
END     
CLOSE emp_cursor;    
DEALLOCATE emp_cursor;  

select *,CONVERT(decimal,BuyCount)- convert(decimal,SellCount) as Difference from @table