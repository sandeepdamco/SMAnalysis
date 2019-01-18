Drop table temp
GO
Create table temp (TradeDate varchar(100) ,Low varchar(100),high varchar(100))

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
Insert into temp(TradeDate,Low,High) values('''+@name+''',
(select count(distinct name)  as High from  [dbo].['+@name+']  where 
(convert(decimal(9,2),[Close]) >convert(decimal(9,2),[open]))) ,

(select count(distinct name) as Low from  [dbo].['+@name+']  where 
(convert(decimal(9,2),[Close]) <=convert(decimal(9,2),[open]))))'

print @query
exec (@query)
	  
      FETCH NEXT FROM db_cursor INTO @name 
END 

CLOSE db_cursor  
DEALLOCATE db_cursor 


select * from temp