
-- Cuantos equipos participan?

Select count(distinct noc) as Equipos
from athlete_events$
go


-- Cuantos deportes hay?

Select count(distinct sport) 
from athlete_events$
go

-- Cuantos eventos hay?

Select count(distinct event) as eventos
from athlete_events$
go

--Top 5 atletas mas jovenes en la historia de las olimpiadas

Select  DISTINCT top 5 
	name, age, sport, event, noc, games, city, medal 
from athlete_events$
where age <> 0
order by age
go


--Top 5 atletas mas viejos de las olimpiadas
--Se selecciona desde el año 2014 porque de otra forma el top 5 atletas es ocupado por competidores de deportes que no se juegan actualmente. (Competiciones de arte)

Select  DISTINCT top 5 name, age, sport, event, noc, games, city, medal 
from athlete_events$
where age <> 0 and sport in 
(Select distinct sport 
from athlete_events$
Where year >= 2014)
order by age desc
go

-- QUERIES PARA VISUALIZAR MAS ADELANTE

-- Cantidad de atletas por año (olimpiadas verano)
Select year, count(*) as num_atletas 
from athlete_events$
where season = 'Winter'
group by year
order by year desc
go

-- Cantidad de atletas por deporte (historico)
Select sport, count(*) as num_atletas
from athlete_events$
group by sport
having count(*) > 5000
order by count(*)
go


-- Cantidad de atletas por pais (historico)
Select region, count(*) as num_atletas
from athlete_events$
left join noc_regions$
on noc_regions$.noc = athlete_events$.noc
group by region
having count(*) > 5000
order by count(*) desc
go

-- Top 10 atletas con mas medallas
SELECT top 10
  name, sex, noc, sport, 
             SUM(CASE medal
                WHEN 'Gold' THEN 1
                ELSE 0
                END) AS num_oro,
             SUM(CASE medal
                WHEN 'Silver' THEN 1
                ELSE 0
                END) AS num_plata,
            SUM(CASE medal
             WHEN 'Bronze' THEN 1
             ELSE 0
             END) AS num_bronce
FROM 
  athlete_events$
GROUP BY 
  name, noc, sport, sex
ORDER BY num_oro DESC
go

--Select medal from athlete_events$
--where medal = 'Silver'


--Top 10 paises con mas medallas 
Select top 10
	region, 
		sum(case medal
			when 'Gold' then 1
			else 0
		end) as num_oro,
		sum(case medal 
			when 'Silver' then 1
			else 0
		end) as num_plata,
		sum(case medal
			when 'Bronze' then 1
			else 0
		end) as num_bronce
from athlete_events$ as ath
left join noc_regions$ as nr
on nr.noc = ath.noc
group by region 
order by num_oro desc
go



