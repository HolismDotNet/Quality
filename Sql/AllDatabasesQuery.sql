execute sp_msforeachdb 'select ''?'', count(*) from [?].sys.tables where [name] = ''Paragraphs'''