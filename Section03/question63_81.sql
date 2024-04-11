-- 문제63
-- -44, -77, -100 에 대한 절대값을 출력하시오.
select abs(-44), abs(-77), abs(-100);

-- 문제64
-- cast()를 이용하여 2015-09-01 11:22:44:777을 날짜만 출력하세요.
select cast('2015-09-01 11:22:44:777' as date);
select convert('2015-09-01 11:22:44:777', date);

-- 문제65
-- 문제64에서 준 데이터를 시간만 따로 출력하시오.
select cast('2015-09-01 11:22:44:777' as time);
select convert('2015-09-01 11:22:44:777', time);

-- 문제66
-- 34.5678을 소수점 아래를 버리시오.
select floor(34.5678);
select truncate(34.5678, 0);

-- 문제67
-- 27.8987을 반올림하여 소수점을 없애시오.
select round(27.8987);
select format(27.8987, 0);

-- 문제68
-- 19.6678을 소수점 1째자리까지 반올림하시오.
select round(19.6678, 1);
select format(19.6678, 1);

-- 문제69
-- 24.4535를 20이 나오도록 하세요.
select format(24.4535, -1);

-- 문제70
-- 78을 3으로 나누었을때 나머지를 구하시오.
select mod(78, 3);
select 78%3;
select 78 mod 3;

-- 문제71
-- 15의 4승을 출력하고, 81의 제곱근을 구하시오.
select pow(15, 4), sqrt(81);

-- 문제72
-- rand()룰 이용하여 로또 번호를 출력하세요.
select floor( 1 + (rand() * 45));

-- 문제73
-- 34.667788을 소수점 2째자리에서 버림하세요.
select truncate(34.667788, 2);

-- 문제74
-- 2017년 10월 5일에서 30일 후의 날짜와 한달 뒤의 날짜를 각각 출력하시오.
select adddate('20171005', interval 30 day);
select adddate('20171005', interval 1 month);


-- 문제75
-- 문제74의 데이터에서 각각 30일 이전 날짜와 한달전 날짜를 출력하시오.
select subdate('20171005', interval 30 day);
select subdate('20171005', interval 1 month);

-- 문제76
-- 자신의 태어난 날부터 현재까지 살아온 일수를 출력하시오.
select datediff(curdate(), '20000427');

-- 문제77
-- 오늘 날짜를 출력하고 1년 중에 몇일 째인지를 출력하시오.
select curdate(), dayofyear(curdate());

-- 문제78
-- 2021년 2월의 마지막날을 출력하시오.
select last_day('20210201');

-- 문제79
-- 9시 45분을 몇 초인지 출력하시오.
select time_to_sec('09:45');

-- 문제80
-- 5초 후 다음 문구를 출력하시오. 문구 : 열심히 하자.
select sleep(5);
select '열심히하자';

-- 문제81
-- 오늘 날짜를 출력하고 몇 사분기인지를 출력하시오.
select curdate(), quarter(curdate());

