delete 
from Quotes 
where Id in 
(
	select Id 
	from 
	(
		select *, row_number() over (partition by OriginalBrainyQuoteId order by Id) as RowNumber
		from Quotes 
		where OriginalBrainyQuoteId in 
		(
			select OriginalBrainyQuoteId
			from
			(
				select OriginalBrainyQuoteId, count(*) as [Count]
				from Quotes 
				group by OriginalBrainyQuoteId
				having count(*) > 1
			) as Temp
		)
	) as Temp2
	where RowNumber = 1
)