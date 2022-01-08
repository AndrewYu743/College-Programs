select * from Universities;
select * from demographics;
select * from universities where unit_id = 105215;
select * from broad_cip_areas;
select * from specific_cip_codes;
select * from program_percentages;
select * from costs;
select * from degrees_offered;

select median_earnings_2_years_after, credlev, cipdesc, inst_name from degrees_offered as d
join specific_cip_codes as s on s.cipcode = d.cipcode join universities as u on u.unit_id = d.unit_id
where degree_id = 171 ;

USE College;

select median_earnings_2_years_after, credlev, cipdesc, inst_name, city, state from degrees_offered as d
join specific_cip_codes as s on s.cipcode = d.cipcode join universities as u on u.unit_id = d.unit_id
where median_earnings_2_years_after is not null order by median_earnings_2_years_after desc;

select * from test_scores as t join universities as u on u.unit_id = t.unit_id where act_midpoint >= 35;
select * from universities where currently_operating = 0;