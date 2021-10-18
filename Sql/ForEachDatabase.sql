declare @command nvarchar(max) = '
select count(*), db_name() from sys.columns
where [name] like N''%Country%''
';
declare @databaseName nvarchar(100)
declare @totalCommand nvarchar(max);
declare databasesCursor cursor for select [name] from sys.databases where database_id > 5 order by [name]
open databasesCursor
fetch next from databasesCursor into @databaseName
while @@fetch_status = 0
begin
	declare @isExecuted bit = 0;
	print @databaseName
	set @totalCommand = 'use ' + @databaseName + '; ' + @command;
	print @totalCommand
	while @isExecuted = 0
	begin
		begin try
			execute sp_executesql @totalCommand;
			fetch next from databasesCursor into @databaseName
			set @isExecuted = 1;
		end try
		begin catch
			print error_message()
			print @totalCommand
			waitfor delay '00:00:01'
		end catch
	end
end
close databasesCursor
deallocate databasesCursor