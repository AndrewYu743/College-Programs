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

-- what about avg net price? (which takes into account aid awarded)
select inst_name, avg_net_price_public, avg_net_price_private, avg_cost_of_attendance,
avg_cost_of_attendance_program_year from costs as c join universities as u on 
c.unit_id = u.unit_id order by avg_net_price_private desc;
-- the more expensive ivy schools tend to give more aid, so that the most
-- expensive schools in terms of net price are music/art institutes

-- how do the best public schools measure up?
select inst_name, avg_net_price_public, avg_net_price_private, avg_cost_of_attendance,
avg_cost_of_attendance_program_year, median_earnings_6_years_after,
number_not_working_6_years_after/(number_working_6_years_after + number_not_working_6_years_after)
as percent_not_working
from costs as c join universities as u on 
c.unit_id = u.unit_id join earnings as e on e.unit_id = u.unit_id
where inst_name like "University of California-Los Angeles" or inst_name like "University of Michigan-Ann Arbor"; 
 
-- Do more competitive schools have higher median earnings?
select inst_name, adm_rate, median_earnings_6_years_after, avg_cost_of_attendance,
number_not_working_6_years_after/(number_working_6_years_after + number_not_working_6_years_after)
as percent_not_working from earnings as e join costs as c on
e.unit_id = c.unit_id join universities as u on e.unit_id = u.unit_id 
where adm_rate is not null order by median_earnings_6_years_after desc;

-- Does faculty salary correlate with student salary?
-- (faculty salary is given as a monthly value)
select inst_name, avg_faculty_salary, median_earnings_6_years_after, avg_cost_of_attendance, avg_cost_of_attendance_program_year,
number_not_working_6_years_after/(number_working_6_years_after + number_not_working_6_years_after)
as percent_not_working from earnings as e join costs as c on
e.unit_id = c.unit_id join universities as u on e.unit_id = u.unit_id 
order by avg_faculty_salary desc;

-- What schools offer the best "career growth"? (median earnings 10 years after - 6 years after)
select inst_name, median_earnings_6_years_after, median_earnings_10_years_after,
median_earnings_10_years_after - median_earnings_6_years_after as earnings_growth
from earnings as e join costs as c on
e.unit_id = c.unit_id join universities as u on e.unit_id = u.unit_id 
order by earnings_growth desc;
-- mostly medical schools

-- what if we used mean instead
select inst_name, mean_earnings_6_years_after, mean_earnings_10_years_after,
median_earnings_10_years_after - median_earnings_6_years_after as earnings_growth
from earnings as e join costs as c on
e.unit_id = c.unit_id join universities as u on e.unit_id = u.unit_id 
order by earnings_growth desc;
-- some schools like MIT and Yale have means more than 50k over the median 10 years after
-- there are some very successful people out of those schools

-- What schools have the highest discrepancy in income?
select inst_name, mean_earnings_6_years_after, mean_earnings_10_years_after,
standard_deviation_earnings_6_years_after, standard_deviation_earnings_10_years_after
from earnings as e join costs as c on
e.unit_id = c.unit_id join universities as u on e.unit_id = u.unit_id 
order by standard_deviation_earnings_10_years_after desc;
-- medical schools & "elite" schools like MIT, Stanford, Harvard
-- the "elite" schools have stdevs equal to or greater than the mean,
-- meaning the top 5% of graduates make >3 times the mean income

/*
How do public, private non-profit, and private for-profit schools compare?
*/
show columns from universities;

select avg_cost_of_attendance_program_year, avg_cost_of_attendance, coalesce(avg_cost_of_attendance, avg_cost_of_attendance_program_year) from costs
order by avg_cost_of_attendance_program_year desc;

-- we'll merge academic year/program year & public/private net price
select control, 
	avg(coalesce(avg_cost_of_attendance, avg_cost_of_attendance_program_year)) as avg_cost_of_attendance, 
	avg(coalesce(avg_net_price_public, avg_net_price_private)) as avg_net_price,
	avg(median_earnings_6_years_after) as avg_earnings,
	avg(number_not_working_6_years_after/(number_working_6_years_after + number_not_working_6_years_after))
    as avg_percent_not_working, count(control)
from universities as u join costs as c on u.unit_id = c.unit_id 
join earnings as e on e.unit_id = c.unit_id group by control;

/* 
Which areas of study offer the best results?

*/
show columns from degrees_offered;
select * from broad_cip_areas;

-- let's see which degrees from which schools earn the most
-- (2 years after completing highest credential)
select median_earnings_2_years_after, credlev, d.cipcode, cipdesc, inst_name, city, state from degrees_offered as d
join specific_cip_codes as s on s.cipcode = d.cipcode join universities as u on u.unit_id = d.unit_id
where median_earnings_2_years_after is not null order by median_earnings_2_years_after desc;
-- the top is almost all dentistry
-- note that credlev doesn't seem too accurate: some dentistry degrees are 5 (master's), 
-- some 7 or 8 (professional/graduate degree), at Upenn it's even 1 ("undergraduate certificate or diploma")

-- group by broad cip areas
select broad_subject_area, avg(median_earnings_2_years_after) as avg_earnings,
	avg(number_working_2_years_after / (number_working_2_years_after + number_not_working_2_years_after)) as avg_percent_working,
    count(broad_subject_area)
from degrees_offered as d
join broad_cip_areas as b on cip_2_digit = d.cipcode div 100
group by broad_subject_area
order by avg_earnings desc;
-- note the huge disparity in # of each subject area

-- what exactly is the difference between 60 and 61 (fellowships), and between the two military categories?
select broad_subject_area, cip_2_digit, cipdesc, inst_name, median_earnings_2_years_after
from degrees_offered as d
join specific_cip_codes as s on s.cipcode = d.cipcode join broad_cip_areas as b on cip_2_digit = d.cipcode div 100
join universities as u on u.unit_id = d.unit_id
where broad_subject_area like "%military%" -- cip_2_digit = 61 -- 
order by median_earnings_2_years_after desc;
-- 61 seems to be entirely radiology
-- note how the majority are null 

select * from degrees_offered where cipcode div 100 = 61;
select * from specific_cip_codes where cipcode div 100 = 61;

select * from degrees_offered where unit_id is null;
/* opening up the actual csv, i realized there's a ton of schools
   who don't have a unit_id. Most are foreign, but some are US schools.
   They do have an OPEID6 though, so in revising this i should make that
   the primary key rather than unit_id.
   This was an oversight on my part, but it shouldn't affect what
   we're doing too much*/

-- because of the many nulls, let's only analyze subject areas w/ >100 degrees
select broad_subject_area, avg(median_earnings_2_years_after) as avg_earnings,
	avg(number_working_2_years_after / (number_working_2_years_after + number_not_working_2_years_after)) as avg_percent_working,
    count(broad_subject_area) as degree_count
from degrees_offered as d
join broad_cip_areas as b on cip_2_digit = d.cipcode div 100
group by broad_subject_area
having degree_count > 100
order by avg_earnings desc;

-- now what about the popularity of degrees?
-- TODO: normalize program_percentages table to have unit_id, broad_cip_area, and percentage



select median_earnings_2_years_after, credlev, cipdesc, inst_name from degrees_offered as d
join specific_cip_codes as s on s.cipcode = d.cipcode join universities as u on u.unit_id = d.unit_id
where degree_id = 171;
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