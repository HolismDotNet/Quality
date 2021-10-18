declare @databaseName varchar(100);
declare @filesQuery nvarchar(max);
declare databasesCursor cursor for select [name] from sys.databases where database_id > 4
open databasesCursor
fetch next from databasesCursor into @databaseName
while @@fetch_status = 0
begin
	print @databaseName
	set @filesQuery = 'select * from ' + @databaseName + '.dbo.sysfiles'
	exec sp_executesql @statement = @filesQuery
	fetch next from databasesCursor into @databaseName
end
close databasesCursor
deallocate databasesCursor