USE springboardopt;

-- -------------------------------------
SET @v1 = 1612521;
SET @v2 = 1145072;
SET @v3 = 1828467;
SET @v4 = 'MGT382';
SET @v5 = 'Amber Hill';
SET @v6 = 'MGT';
SET @v7 = 'EE';			  
SET @v8 = 'MAT';

-- 1. List the name of the student with id equal to v1 (id).

create index id_index on student(id);
explain analyze
SELECT name FROM Student WHERE id = @v1;
/*(1)What was the bottleneck?
there is no index
(2)How did you identify it?
checked the cost of the query run time and execution plan
(3) What method you chose to resolve the bottleneck
created index*/
-- 2. List the names of students with id in the range of v2 (id) to v3 (inclusive).
explain analyze
SELECT name FROM Student WHERE id BETWEEN @v2 AND @v3;
/*(1)What was the bottleneck?
there is no index
(2)How did you identify it?
checked the cost of the query run time and execution plan
(3) What method you chose to resolve the bottleneck
created index*/
-- 3. List the names of students who have taken course v4 (crsCode).
explain analyze
/*SELECT name FROM Student WHERE id IN (SELECT studId FROM Transcript WHERE crsCode = @v4);*/
with cte as (SELECT studId FROM Transcript WHERE crsCode = @v4)
sELECT name FROM Student join cte on id = studid;
/*(1)What was the bottleneck?
used sub query instead of CTE
(2)How did you identify it?
checked the cost of the query run time and execution plan
(3) What method you chose to resolve the bottleneck
wrote cte and called in final query*/
-- 4. List the names of students who have taken a course taught by professor v5 (name).
Explain Analyze
with professor as 
			(SELECT crsCode,name FROM Professor
			JOIN course on Professor.deptid = course.deptid
            WHERE Professor.name = @v5 
            ) 
 select  distinct std.name  from professor pro  join  transcript tra
 on pro.crsCode =  tra.crsCode
	join student std on tra.studid = std.id
    order by tra.crscode;
   /*(1)What was the bottleneck?
query took long time and 
(2)How did you identify it?
checked the cost of the query run time and execution plan
(3) What method you chose to resolve the bottleneck
created CTE*/ 
    
-- 5. List the names of students who have taken a course from department v6 (deptId), but not v7.
/*explain  analyze
SELECT * FROM Student, 
	(SELECT studId FROM Transcript, Course WHERE deptId = @v6 AND Course.crsCode = Transcript.crsCode
	AND studId NOT IN
	(SELECT studId FROM Transcript, Course WHERE deptId = @v7 AND Course.crsCode = Transcript.crsCode)) as alias
WHERE Student.id = alias.studId;*/
explain analyze
with cte as 
(select  distinct name,@v6  from
student  s join transcript  t on s.id = t.studid
join  course  c on c.crsCode = t.crsCode 
 WHERE deptId = @v6)
 select  distinct name from 
cte s where name not in (select  distinct name  from
student  s join transcript  t on s.id = t.studid
join  course  c on c.crsCode = t.crsCode 
 WHERE deptId = @v7  );
   /*(1)What was the bottleneck?
query took long time and too many subqueies used 
(2)How did you identify it?
checked the cost of the query run time and execution plan
(3) What method you chose to resolve the bottleneck
created CTE*/ 
 
 USE springboardopt;

-- -------------------------------------
SET @v1 = 1612521;
SET @v2 = 1145072;
SET @v3 = 1828467;
SET @v4 = 'MGT382';
SET @v5 = 'Amber Hill';
SET @v6 = 'MGT';
SET @v7 = 'EE';			  
SET @v8 = 'MAT';

-- 6. List the names of students who have taken all courses offered by department v8 (deptId).
/*SELECT name FROM Student,
	(SELECT studId
	FROM Transcript
		WHERE crsCode IN
		(SELECT crsCode FROM Course WHERE deptId = @v8 AND crsCode IN (SELECT crsCode FROM Teaching))
		GROUP BY studId
		HAVING COUNT(*) = 
			(SELECT COUNT(*) FROM Course WHERE deptId = @v8 AND crsCode IN (SELECT crsCode FROM Teaching))) as alias
WHERE id = alias.studId;*/

explain analyze
select  distinct name  from
student  s join transcript  t on s.id = t.studid
where   crscode  in (SELECT distinct crscode FROM springboardopt.course where deptid =  @v8)  
  /*(1)What was the bottleneck?
query took long time and too many subquries used
(2)How did you identify it?
checked the cost of the query run time and execution plan
(3) What method you chose to resolve the bottleneck
used only  one subquery*/



 
 


