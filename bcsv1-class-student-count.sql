SELECT
	COUNT([student_list_historical].id) AS StudentCount,
	[student_list_historical].classid,
	[classesCollection.csv].[Class Section]

FROM [student_list_historical]

LEFT JOIN [classesCollection.csv]

ON [student_list_historical].classid = [classesCollection.csv].id

GROUP BY [student_list_historical].classid, [classesCollection.csv].[Class Section]
