use sqldb;

-- 내부조인은 조건에 해당하는 행만 리턴하는 조인이었다.
-- 외부조인은 조건이 맞지 않아도 다 출력한다.
-- 구매기록이 없는 고객까지 다 출력을 하고 싶다면 left outer join을 사용하면 된다.
-- 다시말해, left outer join을 기준으로 해서 왼쪽 테이블 즉, 
-- usertbl의 모든 테이블을 다 출력하라는 것이다. 이것이 바로 left outer join이다.
select * from buytbl;
select * from usertbl;

-- 구매내역이 없는 회원정보까지 다 출력하는 쿼리문
select u.userid, u.username, b.prodname, u.addr,
	concat(u.mobile1, u.mobile2) as '연락처'
from usertbl u
left outer join buytbl b
on u.userid = b.userid
order by u.userid;

-- right outer join은 left outer join에서 테이블에 자리만 바꿔주면 되는 것이다.
select u.userid, u.username, b.prodname, u.addr,
	concat(u.mobile1, u.mobile2) as '연락처'
from buytbl b
right outer join usertbl u
on u.userid = b.userid
order by u.userid;