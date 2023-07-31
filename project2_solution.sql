select * from athletes;

select distinct medal from athlete_events;
select distinct season from athlete_events;
select min(year), max(year) from athlete_events;    --1896 - 2016

--1. which team has won the maximum gold medals over the years.
select a.team, count(ae.medal) count_gold
from athletes a
inner join athlete_events ae
on (a.id=ae.athlete_id)
where ae.medal='Gold'
group by a.team
order by count_gold desc
fetch first 1 row only;


--2. for each team print total silver medals and year in which they won maximum silver medal,
--..output 3 columns: team,total_silver_medals, year_of_max_silver
select * from (
select m.*, row_number() over(partition by m.team order by m.count_silver desc) rank
from
(
select a.team, count(ae.medal) count_silver, ae.year
from athletes a
inner join athlete_events ae
on (a.id=ae.athlete_id)
where ae.medal='Silver'
group by a.team, ae.year
order by count_silver desc
) m
)
where rank=1
order by count_silver desc;


--3a. which player has won maximum gold medals, 
--3b. amongst the players which have won only gold medal (never won silver or bronze) over the years

--3a
select a.name, count(ae.medal) count_gold
from athletes a
inner join athlete_events ae
on (a.id=ae.athlete_id)
where ae.medal='Gold'
group by a.name
order by count_gold desc
fetch first 1 row only;

--3b
select a.name, count(ae.medal) medal_count
from athletes a
inner join athlete_events ae
on (a.id=ae.athlete_id)
where ae.medal not in ('NA','Silver','Bronze')
group by a.name;

--4. in each year which player has won maximum gold medal. 
--Write a query to print year,player name and no of golds won in that year. 

--In case of a tie print comma separated player names.
select year, listagg(NAME,',') list_of_names
from 
(
select ae.year, a.name, count(ae.medal) count_gold
from athletes a
inner join athlete_events ae
on (a.id=ae.athlete_id)
where ae.medal='Gold'
group by ae.year, a.name
order by count_gold desc
)
group by year;

--5. In which event/sport and year India has won its first gold medal,first silver medal and first bronze medal
--print 3 columns medal,year,sport
select * from
(
select ae.medal,ae.year,ae.sport,ae.event, row_number() over(partition by ae.medal order by ae.year) rnk
from athletes a
inner join athlete_events ae
on (a.id=ae.athlete_id)
where a.team='India'
)
where rnk=1 and medal <> 'NA'
order by year;

--6. find players who won gold medal in summer and winter olympics both in same year.
select ae.year, a.name, count(ae.season)
from athletes a
inner join athlete_events ae
on (a.id=ae.athlete_id)
where ae.medal='Gold'
group by ae.year, a.name
having count(ae.season)=2;

--7. find players who won gold, silver and bronze medal in a single olympics. print player name along with year.
select ae.year, a.name, count(ae.medal) as count_medal
from athletes a
inner join athlete_events ae
on (a.id=ae.athlete_id)
where ae.medal in ('Gold', 'Silver', 'Bronze')
group by ae.year, a.name
having count(ae.medal)=3;

--8. find players who have won gold medals in consecutive 3 summer olympics in the same event . 
--Consider only olympics 2000 onwards. Assume summer olympics happens every 4 year starting 2000. print player name and event name.
select ae.event, a.name, count(ae.medal)
from athletes a
inner join athlete_events ae
on (a.id=ae.athlete_id)
where ae.year>=2000 and ae.medal='Gold'
group by ae.event, a.name
having count(ae.medal)=3
;










