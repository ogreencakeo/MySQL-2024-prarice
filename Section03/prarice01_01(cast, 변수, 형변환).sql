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
where height > 180;
-- limit @var2;

-- 동적쿼리문 사용하기
-- prepare ... execute ... using 문을 사용하면 된다.
-- 일단, 아래 쿼리는 변수를 지정하고, myquery라는 명으로 '' 안에 있는
-- 쿼리문을 준비를한다. ?는 변수명을 대입하고 execute 문을 실행 하는 것이다.
-- 예를들어 응용SW에서 사용자로부터 입력을 받아서 출력한다면 이렇게 변수를 
-- 사용하면 좋을 것이다. 중요한 부분이니 잘 정리를 해두자.
set @var1 = 3;
prepare myquery
	from 'select username, height
		from usertbl 
		order by height
        limit ? ';

execute myquery using @var1;

-- 아래 쿼리를 실행을 하면 buytbl의 amount 평균을 나타낸다.
-- 하지만, 소숫점을 반올림 하고 싶을 때는 cast, convert를 사용하면 된다.
select avg(ammount) as '평균 구매 갯수'
	from buytbl;

-- signed : 부호가 있는 (음수, 양수)
-- unsigned : 부호가 없는 (양수)
select cast(avg(ammount) as signed integer) as '평균 구매 갯수'
	from buytbl;

select convert(avg(ammount), signed integer) as '평균 구매 갯수'
	from buytbl;

-- 문자열 연결 함수 (concat)
select num, concat(cast(price as char(10)), ' * ', cast(ammount as char(4)), '=')
	as ' 단가 * 수량 ', price * ammount as '구매액'
	from buytbl;
    
-- cast, convert 함수를 쓰면 명시적 형변환에 속한다.
-- 아래 코드는 묵시적, 암시적, 자동 형변환이라고 한다. 용어를 혼동하지 말자.
select 100 + '100'; -- 200
-- select 100 + cast('100' as signed int); -- 명시적 형변환

-- concat 함수는 인자값으로 숫자가 들어있어도 문자로 묵시적 형변환이 일어난다.
select concat('100', '원입니다.');
select concat(100, '원입니다.');

-- 아래와 같은 쿼리는 실제 현업에서는 거의 사용이 안함.
-- false(거짓)은 0으로 대변이 되고, 0을 제외한 나머지 숫자는 true가 된다.
select 1 > '2mega'; -- 0
select 1 < '2mega'; -- 1 양수의 대표 값은 1이고, 음수의 대표적인 값은 -1이다.
select 1 < 'meag2'; -- 0