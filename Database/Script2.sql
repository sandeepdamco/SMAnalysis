Declare @smName varchar(1000)
DECLARE emp_cursor CURSOR FOR     
SELECT distinct Name from sinfo 
--where name like '%MUTHOOTFIN%'
OPEN emp_cursor    
  
FETCH NEXT FROM emp_cursor     
INTO @smName
WHILE @@FETCH_STATUS = 0    
BEGIN    

with cte as (
      select row_number() over(partition by volume order by addeddate) as Seq,* from sinfo where Name=@smName
     )

	 select * from CTE as c1 where seq>1
--select convert(int,c2.Volume)-convert(int,c1.Volume),C2.AddedDate,C1.* from CTE as c1
--join CTE as c2
--on  c2.Seq=c1.Seq+1

--where convert(int,c2.Volume)-convert(int,c1.Volume)=0      
    FETCH NEXT FROM emp_cursor     
INTO @smName
   
END     
CLOSE emp_cursor;    
DEALLOCATE emp_cursor;  
