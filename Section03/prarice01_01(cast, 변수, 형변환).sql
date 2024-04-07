use sqldb;

-- MySQL의 엔진은 어떤 문자셋을 사용하고 있는지 알기 위한 코드
-- UTF-8이라는 문자셋을 사용한다. 한글이 3바이트로 설정되어 있다.
show variables like 'character_set_system';

-- 아래 cast문은 현재 문자열을 date 데이터타입으로 캐스팅(변환) 시켜준다.
select cast('2020-10-12 12:33:12:478' as date) as '날짜';
select cast('2020-10-12 12:33:12:478' as time) as '시각';
-- datetime 데이터 타입은 문자형 데이터 타입으로 저장된다.
select cast('2020-10-12 12:33:12:478' as datetime) as '날짜와 시각'; -- 8바이트
select now();
-- timestamp 데이터 타입은 숫자형 데이터 타입으로 저장이 된다.
select timestamp(now()); -- 4바이트

drop table if exists timetbl;
create table timetbl(
	num int,
	date_timestamp timestamp not null,
    date_datetime datetime not null
);

-- 타임존을 설정한다.
set time_zone = '+05:30';

insert into timetbl values(1, now(), now());
select * from timetbl;

select utc_timestamp(); -- utc 타임을 출력

-- 변수에 대해 살펴보자. SQL 프로그래밍에 변수가 많이 등장하므로 개념을 익힐 필요가 있다.
set @var1 = 5;
set @var2 = 3;
set @var3 = 5.77;
set @var4 = '이름 : ';

select @var1;
select @var1 + @var2;

-- 보기 좋게 출력하기 위해서 아래와 같이 변수를 사용해봄.
select @var4, username 
	from usertbl
where height > 180;

-- 하지만, 변수는 limit 절에는 못쓴다.
select @var4, username
	from usertbl
where height > 180
-- limit @var2;

