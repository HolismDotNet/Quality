declare @newLine as char(2) = char(13) + char(10);
declare @query varchar(max) = '';
declare databasesCursor cursor for
select 'alter database ' + [name] + ' set recovery simple' + @newLine
from sys.databases
where database_id > 5
open databasesCursor
fetch next from databasesCursor into @query
while (@@fetch_status = 0)
begin
	exec (@query)
	print @query
	fetch next from databasesCursor into @query
end
close databasesCursor
deallocate databasesCursor