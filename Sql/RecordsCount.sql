declare @table nvarchar(100);
declare @schema nvarchar(100);
declare @tableRecords table
(
	Fqn varchar(100),
	RecordsCount int not null	
)
declare @all int;
declare @query nvarchar(max);
declare tablesCursor cursor for 
select name, schema_name([schema_id])
from sys.tables 
where [type] = 'U'
open tablesCursor
fetch next from tablesCursor into @table, @schema
while @@fetch_status = 0 
begin
	set @query = 'select ''[' + @schema + '].[' + @table + ']'', count(*) from [' + @schema + '].[' + @table + ']'
	print @query;
	insert into @tableRecords (Fqn, RecordsCount)
	execute sp_sqlexec @query
	fetch next from tablesCursor into @table, @schema
end 
select *
from @tableRecords
close tablesCursor
deallocate tablesCursor 