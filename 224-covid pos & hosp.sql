use CORDS
/*COVID-19 Positives*/
/*In total*/
select count(distinct person_id)
from measurement m
where m.measurement_concept_id in ('706163', '706158', '706160', '706161',
'706163', '706169', '706170', '706171')
and value_as_concept_id = '9191';

/*Broken down by site*/
select location_source_value, count(distinct p.person_id)
from measurement m, person p, location l
where m.measurement_concept_id in ('706163', '706158', '706160', '706161',
'706163', '706169', '706170', '706171')
and m.value_as_concept_id = '9191'
and p.location_id = l.location_id
and m.person_id = p.person_id
group by l.location_source_value

/*Hospitalized Patients*/
drop table if exists #covid_pos;
select m.person_id, m.measurement_date
into #covid_pos
from measurement m
where m.measurement_concept_id in ('706163', '706158', '706160', '706161',
'706163', '706169', '706170', '706171')
and m.value_as_concept_id = '9191';

drop table if exists #covid_hsp;
select cp.person_id
into #covid_hsp
from #covid_pos cp
join visit_occurrence vo on cp.person_id = vo.person_id
where vo.visit_concept_id in (9201, 262)
and DATEDIFF(day, cp.measurement_date, visit_start_date) > 0;

select l.location_source_value as site, count(distinct p.person_id) as
count
from #covid_hsp ch, person p, location l
where ch.person_id = p.person_id
and p.location_id = l.location_id
group by l.location_source_value
order by l.location_source_value;