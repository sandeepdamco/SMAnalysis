
Declare @query varchar(max),@name varchar(100)

DECLARE db_cursor CURSOR FOR 
select name from sys.tables where name not like '%temp%' and name <>'DailyStat'
OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @name  

WHILE @@FETCH_STATUS = 0  
BEGIN  
      Set @query =' if not exists(select 1 from DailyStat where [Date]='''+@name+''')
Begin
insert into DailyStat
select 
[Open],
High,
Low,
[Close],
Volume,
AvgPrice,
Name,
LastPrice,
orderColum,
BuyOrders,
SellOrders,
'''+@name+''' as Date
 from (
select  *,ROW_NUMBER() over(partition by Name Order by Id desc) as rowNo from ['+@name+'] ) as t1 where t1.rowNo=1

END  
	  	   '
	  print 	  @query
	  exec (@query)
	  

      FETCH NEXT FROM db_cursor INTO @name 
END 

CLOSE db_cursor  
DEALLOCATE db_cursor 

