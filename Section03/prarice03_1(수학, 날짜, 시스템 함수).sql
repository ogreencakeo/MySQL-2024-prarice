-- 수학함수
-- 절대값
select abs(-777);

-- ceiling() 무조건 올림, floor() 무조건 내림, round() 반올림 함수
select ceiling(10.001), floor(10.99), round(1111.478); 

-- conv() : 진법변환을 해줌
select conv('FF', 16, 2); -- 1111
select conv(100, 10, 8); -- 144

-- mod(), % : 이항연산자 -> 나머지 값을 구해준다.
select mod(220, 10), 228%8, 228 mod 8;

-- pow() : 거듭제곱 구함, sqrt() : 제곱근 구함
select pow(3, 3), sqrt(25);

-- rand() : 0.00000~0.99999사이의 임의값을 출력함 (시간을 기준)
-- 우측 컬럼은 주사위의 눈을 랜덤으로 구하는 공식
select rand(), floor(1 + (rand() * 6));

-- sign() : 양수 / 0 / 음수인지를 확인하는 함수이다.
select sign(123), sign(0), sign(-123);

-- truncate() : 해당 자릿수까지만 출력하고 나머지는 버린다.
select truncate(2222.2272, 2), truncate(2222.2272, -2);

-- 날짜 함수들
-- adddate() : 단위로 day, month, year 단위 interval을 주게되면
-- 주어진 날짜로부터 뒷날을 리턴한다. (더하는 개념)
select adddate('2024-04-11', interval 15 day);
select adddate('2024-04-11', interval 15 month);
select adddate('2024-04-11', interval 15 year);

-- subdate() : 단위로 day, month, year 단위 interval을 주게되면
-- 주어진 날짜로부터 앞날을 리턴한다. (빼는 개념)
select subdate('2024-04-11', interval 15 day);
select subdate('2024-04-11', interval 15 month);
select subdate('2024-04-11', interval 15 year);

-- addtime() : 시간을 더하는 함수이다.
select addtime('10:10:10', '1:1:1');

-- subtime() : 시간을 빼는 함수이다.
select subtime('10:10:10', '1:1:1');

-- curdate() : 현재날짜
-- curtime() : 현재시간
-- now(), sysdate() : 현재날짜 시간
select curdate(), curtime(), now(), sysdate();

-- year() : 날짜, month() : 월, day() : 일
select year(curdate()), month(curdate()), day(curdate());

select hour(curtime()), minute(curtime()), second(curtime());

-- 현재부터 인자값까지의 날짜 차이를 리턴한다.
select datediff('20240101', sysdate());
select datediff(now(), '20240101');
select datediff('20240701', sysdate());

-- timediff() : 시간의 차이를 구한다.
select timediff(curtime(), '10:10:10');
select timediff('10:10:10', curtime());

-- dayofweek() : 요일을 리턴하는데 상수값을 리턴한다. 일요일이 기준으로 1부터 시작함
-- monthname() : 달의 이름을 영어로 출력 해준다.
-- dayofyear() : 1년 중에 며칠째 인지를 리턴해준다.
select dayofweek(curdate()), monthname(curdate()), dayofyear(curdate());

-- last_day() : 주어진 달의 마지막 날을 구해준다.
select last_day(curdate());
select last_day('20240101');

-- makedate() : 2024년에서 60일째 되는 날을 리턴해준다.
select makedate(2024, 60);
-- maketime() : 인자값으로 시간을 만들어 리턴한다.
select maketime(10, 10, 5);

-- period_add(202401, 11) : 202401에 11개월을 추가한 결과를 반환
-- period_diff(202401, 201812) : 202401과 201812 사이의 월 수를 계산하여 반환
select period_add(202401, 11), period_diff(202401, 201812);

-- quarter() : 몇 사분기인지 리턴해줌
select concat(quarter(curdate()), '사분기') as '분기';

-- time_to_sec() : 시간을 초로 환산해줌.
select time_to_sec('12:12:12');

-- 시스템 함수
select current_user(), database();

select *
	from buytbl;

-- found_rows() : 이전 조회된 rows의 건수를 리턴함.
select found_rows();

update buytbl set price = price / 2;

-- row_count() : 이전 update, delete, insert한 건수를 리턴한다. (버전별로 상이함)
select row_count();

-- sleep() : 주어진 인자값만틈 멈추어준다.
select sleep(3);
select '3초후에 보입니다.';