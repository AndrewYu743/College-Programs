USE College;
show tables;

/* 
Test scores & competitiveness
(Note that this data is from 2019-2020, before
a lot of schools became test-optional. Perhaps
the results are different now)
*/

-- How correlated are admissions rates and ACT/SAT scores?
select inst_name, act_midpoint, adm_rate from universities 
as u join test_scores as t on u.unit_id = t.unit_id
where adm_rate is not null and act_midpoint is not null order by adm_rate;

select inst_name, sat_avg, adm_rate from universities 
as u join test_scores as t on u.unit_id = t.unit_id
where adm_rate is not null and sat_avg is not null order by adm_rate;

-- What schools have the highest admit rates with ACT/SAT avgs above 34/1500
select inst_name, act_midpoint, adm_rate from universities 
as u join test_scores as t on u.unit_id = t.unit_id
where adm_rate is not null and act_midpoint >= 34 order by adm_rate desc;

select inst_name, sat_avg, adm_rate from universities 
as u join test_scores as t on u.unit_id = t.unit_id
where adm_rate is not null and sat_avg >= 1500 order by adm_rate desc;

-- Which extremely competitive schools (<15% admit rate) have the lowest test scores?
select inst_name, act_midpoint, adm_rate from universities 
as u join test_scores as t on u.unit_id = t.unit_id
where adm_rate <= 0.15 and act_midpoint is not null order by act_midpoint;

select inst_name, sat_avg, adm_rate from universities 
as u join test_scores as t on u.unit_id = t.unit_id
where adm_rate <= 0.15 and sat_avg is not null order by sat_avg;

select inst_name, act_midpoint, sat_avg, adm_rate from universities 
as u join test_scores as t on u.unit_id = t.unit_id
where adm_rate is not null and act_midpoint is not null order by act_midpoint;

/*
Return on investment of each school
https://www.cnbc.com/2021/10/19/these-colleges-offer-students-the-best-return-on-investment.html
https://www.usnews.com/education/best-colleges/paying-for-college/slideshows/national-universities-liberal-arts-colleges-with-the-best-roi
*/

show columns from earnings;
show columns from costs;

-- let's first see which schools offer the best job placement, with cost of attendance in mind
select inst_name, number_not_working_6_years_after, number_working_6_years_after, 
number_not_working_6_years_after/(number_working_6_years_after + number_not_working_6_years_after)
as percent_not_working, avg_cost_of_attendance from earnings as e join costs as c on
e.unit_id = c.unit_id join universities as u on e.unit_id = u.unit_id 
where number_working_6_years_after is not null order by percent_not_working;

-- just for fun let's look at the opposite
select inst_name, number_not_working_6_years_after, number_working_6_years_after, 
number_not_working_6_years_after/(number_working_6_years_after + number_not_working_6_years_after)
as percent_not_working, avg_cost_of_attendance from earnings as e join costs as c on
e.unit_id = c.unit_id join universities as u on e.unit_id = u.unit_id 
where number_working_6_years_after is not null order by percent_not_working desc;
-- these largely seem to be schools in US territories

-- keeping % not working, let's look at median earnings
select inst_name, median_earnings_6_years_after, mean_earnings_6_years_after, avg_cost_of_attendance,
number_not_working_6_years_after/(number_working_6_years_after + number_not_working_6_years_after)
as percent_not_working from earnings as e join costs as c on
e.unit_id = c.unit_id join universities as u on e.unit_id = u.unit_id 
order by median_earnings_6_years_after desc;
-- note that while the ivys have high median earnings, they also have high-ish % not working: 
-- around 10% on avg, and 13% for Princeton

-- which schools have the highest costs of attendance? 
-- (we'll just look at the median earnings for now)
select inst_name, median_earnings_6_years_after, avg_cost_of_attendance, avg_cost_of_attendance_program_year,
number_not_working_6_years_after/(number_working_6_years_after + number_not_working_6_years_after)
as percent_not_working from earnings as e join costs as c on
e.unit_id = c.unit_id join universities as u on e.unit_id = u.unit_id 
order by avg_cost_of_attendance desc;

-- Do more competitive schools have higher median earnings?
select inst_name, median_earnings_6_years_after, mean_earnings_6_years_after, avg_cost_of_attendance,
number_not_working_6_years_after/(number_working_6_years_after + number_not_working_6_years_after)
as percent_not_working from earnings as e join costs as c on
e.unit_id = c.unit_id join universities as u on e.unit_id = u.unit_id 
where number_working_6_years_after is not null order by median_earnings_6_years_after desc;

-- Does faculty salary correlate with student salary?

-- What schools offer the best "career growth"?

-- What schools have the highest discrepancy in income?

-- How do public, private non-profit, and private for-profit schools compare?


/* 
Which areas of study offer the best results?

*/


select median_earnings_2_years_after, credlev, cipdesc, inst_name from degrees_offered as d
join specific_cip_codes as s on s.cipcode = d.cipcode join universities as u on u.unit_id = d.unit_id
where degree_id = 171;

select median_earnings_2_years_after, credlev, cipdesc, inst_name, city, state from degrees_offered as d
join specific_cip_codes as s on s.cipcode = d.cipcode join universities as u on u.unit_id = d.unit_id
where median_earnings_2_years_after is not null order by median_earnings_2_years_after desc;



select * from Universities;
select * from universities limit 20;
select COUNT(*) from universities;
select * from demographics;
select * from universities where unit_id = 105215;
select * from broad_cip_areas;
select * from specific_cip_codes;
select * from program_percentages;
select * from costs;
select * from degrees_offered;
select COUNT(*) from degrees_offered;
select * from test_scores as t join universities as u on u.unit_id = t.unit_id where act_midpoint >= 35;
select * from universities where currently_operating = 0;