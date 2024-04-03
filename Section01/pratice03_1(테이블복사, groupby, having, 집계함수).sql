-- 테이블을 복사하는 방법
use sqldb;
drop table if exists buytbl_copy;

-- buytbl의 데이터 전부를 쿼리를 해서 새로운 데이틀인 buytbl_copy로 복사해라.
create table buytbl_copy(
	select * from buytbl
);

desc buytbl;
-- 하지만, 테이블을 복사를 하게 되더라도 PK, FK등 제약조건은 복사되지 않음.
desc buytbl_copy;

-- 기본적 쿼리문 순서
-- 무조건 아래와 같은 순서로 작성
-- select -> from -> where -> group by -> having -> order by

-- 고객이 구매한 건수를 확인해보는 쿼리문이다. 문제는 중복되는게 많이 나온다.
-- 아울러, 집계가 되지 않아서 한눈에 보기가 어렵다.
-- 하여, group by절을 이용하면 편리하다.

-- 아래 쿼리문을 실행해보면 고객별로 구매한 건수가 한 눈에 들어옴
-- 여기서 sum() 은 집계함수이며, 아울러 group by를 할 때 userid로 하겠다라는 의미이다. 
-- 집계함수류가 나오면 무조건 group by절이 들어가야 한다는 것을 기억.
select userId, sum(ammount) 
	from buytbl
group by userId
order by sum(ammount) desc;

-- 아래는 알리아스를 사용하여 컬럼명을 바꾸어서 출력함
select userId as "아이디", sum(ammount) as "총 구매 건수"
	from buytbl
group by userId
order by sum(ammount) desc;

-- 총 구매액을 집계
-- 총 구매액은 총구매수량 * 단다가 될 것이다.
-- 아래 쿼리는 고객별로 총 구매액을 기준으로 오름차순을 정렬하는 쿼리문
select userId as "아이디", sum(price * ammount) as "총 구매액" 
	from buytbl
group by userid
order by sum(price * ammount);

-- 고객별로 평균 구매갯수를 알아봄
select userId as "아이디", avg(ammount) as "평균 구매갯수" 
	from buytbl
group by userid
order by sum(ammount);

-- 모든 고객을 대상으로 평균 구매갯수를 알아봄
select avg(ammount) from buytbl;

-- max(), min()
select name, height from usertbl;

-- 아래와 같이 쿼리를 치게 되면 원하는 값을 얻을 수 없다.
-- name별로 group by절을 적용시키니 10개의 데이터가 나옴
select name, max(height), min(height) 
	from usertbl
group by name;

-- 아래 서브쿼리를 이용하여 적절히 원하는 값을 도출할 수 있음.
select name, height
	from usertbl
where height = (
	select max(height) from usertbl) 
    or  height = (
	select min(height) from usertbl);

-- 건수를 집계하는 count() 
select count(*) from usertbl;

select count(*) as "휴대폰이 있는 사람" 
	from usertbl
where mobile1 is not null;

use employees;
select count(*) from employees;

-- 총 구매액으로 내림차순 정렬한 쿼리문
-- 근데, 총구매액이 1000만원 이상인 것만 보고 싶다면...
-- where절에 조건문을 제시하니까 에러가 남
-- where 조건절에는 집계함수를 사용할 수가 없다.
-- group by된 절들은 having조건을 줘야 한다.
select userId as "아이디", sum(price * ammount) as "총 구매액" 
	from buytbl
where sum(price * ammount) > 1000
group by userid
order by sum(price * ammount) desc;

-- having은 조건절이다.
select userId as "아이디", sum(price * ammount) as "총 구매 액" 
	from buytbl
group by userid
having sum(price * ammount) > 1000
order by sum(price * ammount) desc;

-- with roll up에 대해서 알아보자
-- 분류별로 소합계를 내어주고 마지막에 총합계를 보여준다.
-- num을 추가하게 되면 건바이건까지 다 출력
select num, groupName, sum(price * ammount) 
	from buytbl
group by groupname, num
with rollup;
