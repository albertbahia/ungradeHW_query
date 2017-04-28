-- dim_userCollection, dim_classesCollection, homeworkSubmissionCollection, dim_assignmentsCollection
SELECT [dim_classesCollection].[classesid], [dim_classesCollection].[class section], step6.[unit], step6.[title], step6.[userid] AS student_id
FROM [dim_classesCollection]
JOIN(
	SELECT step5.[unit], step5.[title], step5.[datediff], step5.[twoWeekDiff], [dim_usersCollection].[profile.firstname], [dim_usersCollection].[profile.lastname], [dim_usersCollection].[profile.classes.0], [dim_usersCollection].[userid]
	FROM [dim_usersCollection]
	JOIN(
		SELECT step4.[studentid], step4.[unit], step4.[title], step4.[duedates.0.duedate], step4.[timestamp], step4.[datediff], step4.[twoWeekDiff]
		FROM (
			SELECT step3.[studentid], step3.[unit], step3.[title], step3.[duedates.0.duedate], step3.[timestamp], 
			step3.[timestamp]- step3.[duedates.0.duedate] AS datediff,
			--AddSeconds(CreateDate(1970,1,1), step3.[timestamp]) AS convertedUnix,
			-- go back and figure hout to automate two weeks
			1493402246644 - step3.[duedates.0.duedate] AS twoWeekDiff
				FROM (
					SELECT step2.[studentid], step2.[due], step2.[homeworkassignmentid], step2.[timestamp], step2.[cohortid], step2.[title], step2.[assigneddate], step2.[duedates.0.duedate], step2.[homeworktype], step2.[unit]
					FROM (
						SELECT step1.[studentid], step1.[due], step1.[grade], step1.[bucket], step1.[timestamp], [dim_assignmentsCollection].[homeworkassignmentid], [dim_assignmentsCollection].[cohortid], [dim_assignmentsCollection].[title], [dim_assignmentsCollection].[assigneddate], [dim_assignmentsCollection].[duedates.0.duedate], [dim_assignmentsCollection].[homeworktype], [dim_assignmentsCollection].[unit]  
							FROM [dim_assignmentsCollection]
							JOIN(
								SELECT nullGrades.[studentid], nullGrades.[due], nullGrades.[homeworkassignmentid], nullGrades.[grade], nullGrades.[Bucket], nullGrades.[timestamp]
									FROM(
										SELECT studentid, due, timestamp, homeworkassignmentid, grade, Grade Bucket		
										FROM [homeworkSubmissionsCollection]
									WHERE grade IS NULL) AS nullGrades
								) AS step1
						ON step1.[homeworkassignmentid] = [dim_assignmentsCollection].[homeworkassignmentid]
					) AS step2
					WHERE step2.[homeworktype] = 'technology'
				)AS step3
			) AS step4
		WHERE step4.[datediff] < 86400000
			AND step4.twoWeekDiff > 1210000000
		)AS step5
	ON step5.[studentid] = [dim_usersCollection].[userid]
	)AS step6
ON step6.[profile.classes.0] = [dim_classesCollection].[classesid]
