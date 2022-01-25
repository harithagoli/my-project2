/* Write a SQL query to find the date EURO Cup 2016 started on*/
SELECT min(play_date) FROM euro_cup_2016.match_mast;
/*Write a SQL query to find the number of matches that were won by penalty shootout*/
select distinct count(match_no) from    euro_cup_2016.match_mast where results = 'WIN' and decided_by = 'P';
/*Write a SQL query to find the match number, date, and score for matches in which no stoppage time was added in the 1st half */
SELECT distinct match_no,play_date,goal_score from    euro_cup_2016.match_mast where stop1_sec = 0;
/* Write a SQL query to compute a list showing the number of substitutions that happened in various stages of play for the entire tournament */
/*5.Write a SQL query to find the number of bookings that happened in stoppage time.*/
SELECT count(match_no) FROM euro_cup_2016.player_booked where play_schedule = 'ST';
/*6. Write a SQL query to find the number of matches that were won by a single point, but do not include matches decided by penalty shootout.*/
SELECT count(match_no)  FROM euro_cup_2016.match_details where goal_score = 1 and decided_by <>'P';
/*7. Write a SQL query to find all the venues where matches with penalty shootouts were played.*/
SELECT v.venue_id,venue_name from  euro_cup_2016.soccer_venue v  inner join  euro_cup_2016.match_mast  m on v.venue_id = m.venue_id where decided_by = 'P';
/*8. Write a SQL query to find the match number for the game with the highest number of penalty shots, and which countries played that match.*/
select ms.match_no,sc.country_name from 
(select match_no,row_number() over(order by penalty_score desc) as porder
from euro_cup_2016.match_details)pscore
join  euro_cup_2016.match_mast  ms  on  ms.match_no = pscore.match_no
join    euro_cup_2016.referee_mast rm   on  ms.referee_id = rm.referee_id
join euro_cup_2016.soccer_country  sc on rm.country_id = sc.country_id
where porder = 1;
/*9. Write a SQL query to find the goalkeeper’s name and jersey number, playing for Germany, who played in Germany’s group stage matches.*/
SELECT      distinct  pm.player_name, pm.jersey_no  FROM euro_cup_2016.player_mast pm
join    euro_cup_2016.match_details    md on         pm.team_id = md.team_id
join  euro_cup_2016.match_mast  ms  on  md.match_no = ms.match_no
join    euro_cup_2016.referee_mast rm   on  ms.referee_id = rm.referee_id
join euro_cup_2016.soccer_country  sc on rm.country_id = sc.country_id
 where posi_to_play = 'GK' and     md.play_stage   = 'G'      and sc.country_name = 'Germany';


/*10. Write a SQL query to find all available information about the players under contract to Liverpool F.C. playing for England in EURO Cup 2016.*/
SELECT      distinct  pm.*  FROM euro_cup_2016.player_mast pm
join    euro_cup_2016.match_details    md on         pm.team_id = md.team_id
join  euro_cup_2016.match_mast  ms  on  md.match_no = ms.match_no
join    euro_cup_2016.referee_mast rm   on  ms.referee_id = rm.referee_id
join euro_cup_2016.soccer_country  sc on rm.country_id = sc.country_id
 where       sc.country_name = 'England' and  playing_club = 'Liverpool';
/*11.Write a SQL query to find the players, their jersey number, and playing club who were the goalkeepers for England in EURO Cup 2016.*/
SELECT      distinct  pm.player_name, pm.jersey_no, playing_club  FROM euro_cup_2016.player_mast pm
join    euro_cup_2016.match_details    md on         pm.team_id = md.team_id
join  euro_cup_2016.match_mast  ms  on  md.match_no = ms.match_no
join    euro_cup_2016.referee_mast rm   on  ms.referee_id = rm.referee_id
join euro_cup_2016.soccer_country  sc on rm.country_id = sc.country_id
 where posi_to_play = 'GK'      and sc.country_name = 'England';
/*12. Write a SQL query that returns the total number of goals scored by each position on each country’s team. Do not include positions which scored no goals.*/
select st.team_id,group_position,sum(goal_score) as totalgoals  from  euro_cup_2016.player_mast pm  
join euro_cup_2016.playing_position pp on pm.posi_to_play = pp.position_id
join euro_cup_2016.match_details    md on         pm.team_id = md.team_id
join euro_cup_2016.soccer_team st on pm.team_id  = st.team_id
group by st.team_id,group_position
having sum(goal_score)> 0;
/*13. Write a SQL query to find all the defenders who scored a goal for their teams.*/
select player_name,sum(goal_score) as totalgoals  from  euro_cup_2016.player_mast pm  
join euro_cup_2016.playing_position pp on pm.posi_to_play = pp.position_id
join euro_cup_2016.match_details    md on         pm.team_id = md.team_id
join euro_cup_2016.soccer_team st on pm.team_id  = st.team_id
where position_desc = 'Defenders'
group by player_name
having sum(goal_score)> 0;

/*14. Write a SQL query to find referees and the number of bookings they made for the entire tournament. Sort your answer by the number of bookings in descending order.*/
SELECT referee_name, sum(noofbookings) as totalnumber FROM euro_cup_2016.referee_mast rm join
euro_cup_2016.match_mast mm  on rm.referee_id = mm.referee_id
join (SELECT match_no,count(booking_time)  as 'noofbookings' FROM euro_cup_2016.player_booked
group by match_no
order by player_id) pb on mm.match_no = pb.match_no
group by referee_name 
order by totalnumber desc;
/*15. Write a SQL query to find the referees who booked the most number of players.*/
SELECT  referee_name,sum(noofplayersbooked) as totalno
FROM euro_cup_2016.referee_mast rm join euro_cup_2016.match_mast mm 
on rm.referee_id = mm.referee_id
join (SELECT match_no,count(player_id)   as 'noofplayersbooked'  FROM euro_cup_2016.player_booked
group by match_no
order by player_id) pb on mm.match_no = pb.match_no
group by referee_name
order by totalno desc;

/* 16. Write a SQL query to find referees and the number of matches they worked in each venue.*/

select referee_name,venue_name,count(match_no) as totalmatches  from 
(select referee_name,mm.match_no,sv.venue_name
,row_number() over(partition by mm.venue_id order by  mm.venue_id ) as contm
FROM euro_cup_2016.referee_mast rm join euro_cup_2016.match_mast mm 
on rm.referee_id = mm.referee_id
join euro_cup_2016.soccer_venue  sv on mm.venue_id = sv.venue_id
order by referee_name)v
group by referee_name,venue_name;

/*17. Write a SQL query to find the country where the most assistant referees come from,and the count of the assistant referees.*/
with cte as 
(SELECT distinct ass_ref_name,rm.country_id,country_name 
,row_number() over (partition by country_id order by country_id) as countre
FROM euro_cup_2016.asst_referee_mast rm
join euro_cup_2016.soccer_country   sc  on rm.country_id = sc.country_id
order by country_name)
select country_name,countre as maxreferees
from cte where countre = (select max(countre) from cte);
/*18. Write a SQL query to find the highest number of foul cards given in one match.*/
/*19. Write a SQL query to find the number of captains who were also goalkeepers.*/
SELECT count(distinct player_id) as 'number of capatians as GK' FROM euro_cup_2016.match_captain mc
join euro_cup_2016.player_mast md  on mc.player_captain = md.player_id
where posi_to_play = 'GK'
order by player_id;
/*20. Write a SQL query to find the substitute players who came into the field in the firsthalf of play, within a normal play schedule*/
SELECT distinct player_name as 'substitute player' FROM euro_cup_2016.player_in_out pio
join euro_cup_2016.player_mast pm on pio.player_id = pm.player_id
where  in_out = 'I' and play_half = 1 and play_schedule ='NT';