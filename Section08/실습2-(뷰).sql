use sqldb;

-- 집계함수와 group by와 order by를 이용하는 view도 작성을 해서 테스트를 하기
create or replace view v_sum
as 
	select userid as 'USER ID', sum(price * amount) as '합계'
	from buytbl
    group by userid
    order by sum(price * amount) desc;

-- 뷰를 통한 select의 결과는 잘 나오는 것을 알수가 있다.
select *
	from v_sum;

-- 아래의 결과와 같이 집계함수와 group by가 들어가 있는 뷰는 데이터를
-- 변경할 수 없음을 기억하도록 하자.
update v_sum
	set '합계' = 2000
where `USER ID` = 'PSH';

-- information_schema는 시스템 데이터베이스이다.
-- 확인해보면 is_updatable을 보면 no로 설정이 되어 있다.
-- 하여 v_sum은 뷰로써는 수정, 삭제, 삽입이 되질 안되는다라는 것이다.
-- 즉, 다시말해서 집계함수를 사용한 뷰는 절대 수정이나 삭제가 이루어지지 않는다.
-- 아울러, union all, join, distinct, group by도 역시 되지 않는다.
select *
	from information_schema.views
where table_schema = 'sqldb'
	and table_name = 'v_sum';

-- 키가 177이상인 사람을 조회하는 뷰를 생성해보자.
create or replace view v_height177
as
	select * from usertbl
    where height >= 177;

-- 실행은 되지만 키가 177미만인 사람은 뷰에 없다.
delete from v_height177
	where height < 177;

-- 유재석 없애기
delete from v_height177
	where height = 178;

select * from v_height177;
select * from usertbl;

-- 삽입은 된다. 하지만, 뷰를 조회를 해보면 나오지 않는다.
-- 왜? 뷰가 177이상만 조회를 하니까 나오지 않는다.
insert into v_height177 values('SEH', '신은혁', 2008, '구미', NULL, NULL, 140, '2010-05-05');
select * from v_height177;

select * from usertbl;