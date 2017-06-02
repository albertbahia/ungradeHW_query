SELECT step4.[userid], step4.[profile.firstname], step4.[profile.lastname], step4.[classesid], step4.[class section], AVG(step4.[NumGrade]) AS avg_grade -- find out why this isn't a float
FROM(	
	SELECT step3.[userid], step3.[profile.firstname], step3.[profile.lastname], step3.[classesid], step3.[class section], step3.[University ID], step3.[grade],
		CAST((CASE step3.[grade] WHEN 'A+' THEN '100' 
			WHEN 'A' THEN '92'
			WHEN 'A-' THEN '92'
			WHEN 'B+' THEN '88'
			WHEN 'B' THEN '85'
			WHEN 'B-' THEN '82'
			WHEN 'C+' THEN '78'
			WHEN 'C' THEN '75'
			WHEN 'C-' THEN '72'
			WHEN 'D+' THEN '70'
			WHEN 'D' THEN '65'
			WHEN 'D-' THEN '62'
			ELSE '55'
		END) AS FLOAT) AS NumGrade
		FROM(
			SELECT step2.[userid], step2.[profile.firstname], step2.[profile.lastname], step2.[grade], classes.[classesid], classes.[class section], classes.[University ID]
			FROM [dim_classesCollection] AS classes
			JOIN(
				SELECT user.[userid], user.[createdat], user.[profile.classes.0], user.[profile.firstname], user.[profile.lastname], user.[profile.githubusername], user.[profile.email], user.[fullname], step1.[due], step1.[timestamp], step1.[homeworkassignmentid], step1.[grade]
				FROM [dim_usersCollection] AS user
				JOIN(
					SELECT grades.[studentid], grades.[due], grades.[timestamp], grades.[homeworkassignmentid], grades.[grade]
						FROM(
							SELECT studentid, due, timestamp, homeworkassignmentid, grade, Grade Bucket 
							FROM [homeworkSubmissionsCollection]
							WHERE grade IS NOT NULL
							)AS grades
					)AS step1
				ON step1.[studentid] = user.[userid]
			)AS step2
			ON step2.[profile.classes.0] = classes.[classesid]
		) AS step3
)AS step4
GROUP BY step4.[userid], step4.[profile.firstname], step4.[profile.lastname], step4.[classesid], step4.[class section]
ORDER BY step4.[userid] DESC
