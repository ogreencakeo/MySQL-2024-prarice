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

-- outer join을 이용하여 구매내역이 없는 고객 리스트를 출력해보자.
select u.userid, u.username, b.prodname, u.addr,
	concat(u.mobile1, u.mobile2) as '연락처'
	from buytbl b
	right outer join usertbl u
	on u.userid = b.userid
	where b.prodname is null
	order by u.userid;
    
-- 아래 3개 테이블을 이용하여 학생중에 동아리에 가입하지 않은
-- 사람만 추출해내는 쿼리문을 작성해보자
select * from stdtbl;
select * from stdclubtbl;

select s.stdname, s.addr, c.clubname, c.roomnumber
	from stdtbl s
    left outer join stdclubtbl sc
    on s.stdname = sc.stdname
    left outer join clubtbl c
    on sc.clubname = c.clubname
    where c.clubname is null
    order by s.stdname;

-- 아래 쿼리는 left outer join과 right outer join을 이용해서 3개의 테이블을
-- 엮어서 학생이 한명도 가입하지 않은 동아리를 추출하는 쿼리문이다.
-- 왜 right outer join을 사용했는가? 동아리 명을 다 추출하기 위해서
select c.clubname, c.roomnumber, s.stdname, s.addr
	from stdtbl s
    left outer join stdclubtbl sc
    on s.stdname = sc.stdname
    right outer join clubtbl c
    on sc.clubname = c.clubname
    where s.stdname is null
    order by c.clubname;

-- 그런데 위의 두 개의 결과값을 동시에 보고 싶을때는 어떻게 할까?
-- 두 쿼리의 결과값을 연결해주는 키워드가 필요하다
-- 그게 바로 union이다. union은 합집합니다. 중복은 제거를 한다.
select c.clubname, c.roomnumber, s.stdname, s.addr
	from stdtbl s
    left outer join stdclubtbl sc
    on s.stdname = sc.stdname
    right outer join clubtbl c
    on sc.clubname = c.clubname
    where s.stdname is null
union 
select s.stdname, s.addr, c.clubname, c.roomnumber
	from stdtbl s
    left outer join stdclubtbl sc
    on s.stdname = sc.stdname
    left outer join clubtbl c
    on sc.clubname = c.clubname
    where c.clubname is null;

-- union : 중복제거
-- union all : 중복을 제거하지 않고 다 출력한다.
select * from stdtbl
union all
select * from stdtbl;

-- 상호 조인에 대해서 알아보자
-- cross join의 결과 개수는 두 테이블의 행의 개수를 곱하여 나온 개수가 된다.
-- 카티션 곱(Cartition Product)이라고도 부른다. 통상적으로 대용량 데이터를 생성할 때 사용한다.
-- buytbl : 13개의 행, usertbl : 10개의 행
select *
	from buytbl
cross join usertbl;

-- 셀프 조인
-- 셀프조인이란 테이블 하나로 두번 이상 엮어서 결과값을 추출해내는 방법이다.
-- 셀프조인은 주로 테이블이 계층적인 구조를 수평적인 관계로 바꾸는 역할을 한다.
use sqldb;
drop table if exists emptbl;
create table emptbl(
	emp char(3) not null primary key,
    manager char(3),
    emptel varchar(8)
);

insert into emptbl values ('나사장', null, '0000'),
('김재무', '나사장', '2222'),('김부장', '김재무', '2222-1'),('이부장', '김재무', '2222-2'),
('우대리', '이부장', '2222-2-1'),('지사원', '이부장', '2222-2-2'),('이영업', '나사장', '1111'),
('한과장', '이영업', '1111-1'),('최정보', '나사장', '3333'),('윤차장', '최정보', '3333-1'),
('이주임', '윤차장', '3333-1-1');

select * 
	from emptbl
    where emp = "우대리";

-- 아래 코드는 우대리의 상관인 이부장의 전화번호를 추출해내는 쿼리문이다.
-- emptbl을 마치 2개가 있는 것 처럼 만들어서 분리해서 생각하고 조건을 설정할 때
-- manager 필드와 emp 필드가 같고 where 절에 우대리로 조건을 설정을 하면 된다.
-- 개념이 조금 어렵다.
select A.emp as '부하직원', B.emp as '직속상관', B.emptel
	from emptbl A
    inner join emptbl B
    on A.manager = B.emp
    where A.emp = "우대리";