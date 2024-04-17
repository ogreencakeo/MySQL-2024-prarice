use sqldb;

-- 내부 조인이 통상 조인이라고 칭한다.
-- 조인은 2개 이상의 테이블을 엮어서 쿼리문을 작성하여 또 다른 결과물을 도출해내는
-- SQL의 중급이상의 구문

-- usertbl이 첫 번째 테이블이 되고, buytbl이 두 번째 테이블이 돼서
-- usertbl에 PK인 userid와 buytbl의 FK인 userid를 서로 같은 것을
-- 조건으로 해서 내부조인을 했다. KYM의 조건을 줘서 KYM의 내용만 출력하도록
-- 쿼리문을 작성한 것이다.

-- usertbl과 buytbl을 내부 조인하여 KYM의 구매 기록만 출력하는 쿼리
select *
	from usertbl
    inner join buytbl
    on usertbl.userid = buytbl.userid
where buytbl.userid = "KYM";

desc usertbl;
desc buytbl;

-- 아래 코드는 실행을 하면 에러가 난다.
-- 왜 에러가 날까? 바로 userid 때문이다. userid는 buytbl, usertbl 두 개의 테이블에
-- 존재하기 때문에 userid 컬럼이 어떤 테이블의 userid인지 모호하기 때문이다.
select userid, username, prodname, addr, concat(mobile1, mobile2) as '연락처'
	from buytbl
	inner join usertbl
    on buytbl.userid = usertbl.userid;
    
select buytbl.userid, username, prodname, addr, concat(mobile1, mobile2) as '연락처'
	from buytbl
	inner join usertbl
    on buytbl.userid = usertbl.userid;

-- 아래 코드는 명시적으로 테이블명.컬럼명으로 해주었다.
-- 단점은 쿼리문이 상당히 길어진 것을 볼 수 있다.
-- 이럴때는 테이블에 알리아스를 추가해서 줄일 수 있다.

-- usertbl과 buytbl의 구매 기록을 출력하되, 모호한 컬럼명을 해결하기 위해 테이블명을 명시적으로 지정
select buytbl.userid, usertbl.username, buytbl.prodname, 
	usertbl.addr, concat(usertbl.mobile1, usertbl.mobile2) as '연락처'
	from buytbl
	inner join usertbl
    on buytbl.userid = usertbl.userid;

-- 아래 쿼리는 테이블에다가 직접 알리아스를 설정하여 활용한 쿼리문이다.
-- 결과는 동일하지만, 쿼리문이 많이 줄어든 것을 확인 할 수가 있다.
select B.userid, U.username, B.prodname, 
	U.addr, concat(U.mobile1, U.mobile2) as '연락처'
	from buytbl B
	inner join usertbl U
    on B.userid = U.userid;

-- 아래 쿼리는 전체 회원을 구할려고 하는 쿼리문이다.
-- 하지만, 김국진/이경규/남희석/신동엽/유재석 데이터들이 없다.
-- 다시 말해서, buytbl에 구매한 기록이 없는 데이터들이다.
-- 무엇을 의미하는가? 내부조인은 buytbl의 userid와 usertbl의
-- userid가 같은 것만 출력하는 것이다. 전체 회원을 다 보고자 한다면,
-- 외부조인을 사용해야 한다.
select B.userid, U.username, B.prodname, 
	U.addr, concat(U.mobile1, U.mobile2) as '연락처'
	from usertbl U
	inner join buytbl B
    on U.userid = B.userid
    order by U.userid;

select * from usertbl;
select * from buytbl;

-- 아래 쿼리가 left outer 조인이다. 즉, 왼쪽 테이블(usertbl)을 다 출력을 하는 구문이다.

-- 외부 조인을 사용하여 모든 회원의 구매 기록을 출력
-- usertbl에 구매 기록이 없는 사용자도 모두 포함됨
select B.userid, U.username, B.prodname, 
	U.addr, concat(U.mobile1, U.mobile2) as '연락처'
	from usertbl U
	left outer  join buytbl B
    on U.userid = B.userid
    order by U.userid;

-- buytbl에 구매기록이 존재하는 사람들에게 신년메시지를 보내고 싶을 때
-- 구매 기록이 있는 사용자에게만 신년 메시지를 전송하기 위한 쿼리
select distinct U.userid, U.username, 
	U.addr, concat(U.mobile1, U.mobile2) as '연락처'
	from usertbl U
	inner join buytbl B
    on U.userid = B.userid
    where U.mobile1 is not null
    order by U.userid;

-- exists 구문은 서브쿼리의 데이터가 있는지 없는지만 리턴한다.
-- 즉, boolean값을 리턴을 하는데, 첫 번째 select문의 결과를 토대로 하여
-- where exists의 select를 비교해서 맞는 행이 존재한다면 출력한다.
-- distinct와 비슷한 역할을 한다.

-- exists 구문을 사용하여 구매 기록이 있는 사용자를 조회하는 쿼리
select U.userid, U.username, 
	U.addr, concat(U.mobile1, U.mobile2) as '연락처'
	from usertbl U
	where exists(
		select * 
			from buytbl B
            where U.userid = B.userid
    );
    
-- 다대다의 관계를 테이블을 생성하여 조인을 해보도록 하자.

-- 학생 테이블
drop table if exists stdtbl;
create table stdtbl(
	stdname varchar(10) not null primary key,
    addr varchar(5) not null
);

desc stdtbl;

-- 동아리 테이블
drop table if exists clubtbl;
create table clubtbl(
	clubname varchar(10) not null primary key,
    roomnumber varchar(5) not null
);

desc clubtbl;

-- stdclubtbl을 만들어줘서 학생, 동아리 테이블에서 서로 필요한 데이터를
-- 가져갈 수 있도록 만들어준다.

drop table if exists stdclubtbl;
create table stdclubtbl(
	num int auto_increment not null primary key,
	stdname varchar(10) not null,
    clubname varchar(10) not null,
    foreign key (stdname) references stdtbl(stdname),
    foreign key (clubname) references clubtbl(clubname)
);

desc stdclubtbl;

-- 데이터 삽입하기
insert into stdtbl values ('강호동','경북'),('김제동','경남'),('김용만','서울'),
('이휘재','경기'),('박수홍','서울');

insert into clubtbl values ('수영','101호'),('바둑','102호'),('축구','103호'),
('봉사','104호');

insert into stdclubtbl values (null, '강호동','바둑'),(null, '강호동','축구'),
(null, '김용만','축구'),(null, '이휘재','축구'),(null, '이휘재','봉사'),
(null, '박수홍','봉사');

select * from stdtbl;
select * from clubtbl;
select * from stdclubtbl;

-- 위에서 만든 테이블 3개를 조인을 해서 이름, 지역, 동아리명, 동아리방 호수를 출력해보자
-- 여기서 조인을 하기 위해서 대부분 PK와 FK를 가지고 설정하는 경우가 많다는 것이다.

-- 학생명을 기준으로 쿼리문을 만들어보자.
select s.stdname, s.addr, c.clubname, c.roomnumber
	from stdtbl s
    inner join stdclubtbl sc
    on s.stdname = sc.stdname
    inner join clubtbl c
    on sc.clubname = c.clubname
    order by s.stdname;

-- 동아리명 기준으로 쿼리문을 만들어보자
select s.stdname, s.addr, c.clubname, c.roomnumber
	from stdtbl s
    inner join stdclubtbl sc
    on s.stdname = sc.stdname
    inner join clubtbl c
    on sc.clubname = c.clubname
    order by s.stdname;