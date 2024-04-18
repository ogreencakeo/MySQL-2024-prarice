#문제 63
#emp이용하여 모든 사원의 매니저가 누구인지 다 출력하세요(셀프조인)
use mydb;
select * from emp;

select A.ename as '사원명', B.ename as '매니저'
	from emp A
    inner join emp B
    on A.mgr = B.empno;

#문제 64
#이문세의 부서명을 조회하여 출력하시요.
select * from emp;
select * from dept;

select E.ename as '사원명', D.dname as '부서명'
	from emp E
    inner join dept D
    on E.deptno = D.deptno
    where E.ename = "이문세";

#문제 65
#다음 테이블을 생성하시오
#테이블명 : dept01			
			
#열이름	데이터형식		NULL허용	제약조건
#deptno		int			x	PK설정
#dname		varchar(14)	x	
#location 	varchar(13)	x	

drop table if exists dept01;

create table dept01(
	deptno int not null primary key,
    dname varchar(14) not null,
    location varchar(13) not null
);

#문제 66
#dept01에 데이터를 추가하시오
# 10,'경리부','서울'
# 20,'인사부','인천'
insert into dept01 values(10,'경리부','서울');
insert into dept01 values(20,'인사부','인천');

#문제 67
#다음 테이블을 생성하시오
#테이블명 : dept02			
			
#열이름	데이터형식		NULL허용	제약조건
#deptno		int			x	FK설정
#dname		varchar(14)	x	
#location 	varchar(13)	x	
drop table if exists dept02;
create table dept02(
	deptno int not null,
    dname varchar(14) not null,
    location varchar(13) not null,
    foreign key (deptno) references dept01(deptno)
);
set foreign_key_checks = 0; -- 외래키 기능을 off하는 내용
set foreign_key_checks = 1; -- 외래키 기능을 on하는 내용
 
#문제 68
#dept02에 데이터를 추가하시오
#10, '경리부', '서울'
#30, '영업부', '용인'
insert into dept02 values(10, '경리부', '서울');
insert into dept02 values(30, '영업부', '용인');

#문제 69
#위의 detp01, dept02를 inner join을 하여 결과를 출력하세요
#결과는 1개 행만 나와야 올바른 쿼리입니다.
select * from dept01;
select * from dept02;
select * 
	from dept01 A
	inner join dept02 B
    on A.deptno = B.deptno;

#문제 70
#dept01테이블의 20번 부서와 조인할 부서번호가 dept02에는 없다.하지만 20번 부서도
#출력되도록 하시오.결과는 2개 행이 나와야합니다.
-- 외부조인
select * 
	from dept01 A
    left outer join dept02 B
    on A.deptno = B.deptno;

#문제 71
#이번에는 dept02테이블에만 있는 30번 부서까지 출력하시오.
select * 
	from dept01 A
    right outer join dept02 B
    on A.deptno = B.deptno;

#문제 72
#부서명, 지역명, 사원수, 부서 내의 모든 사원의 평균 급여를 출력하시오(emp, dept테이블 이용)
select * from emp;
select * from dept;
select D.dname as '부서명', D.loc as '지역명', 
	count(*) as '사원수', avg(E.sal) as '평균 급여'
    from emp E
    inner join dept D
    on E.deptno = D.deptno
    group by D.dname, D.loc;

#문제 73
#case문을 이용하여 emp테이블에서 직급에 따라 직급이 '부장'인 사원은 5%, '과장'인									
#사원은 10%, '대리'인 사원은 15%, '사원'인 사원은 20% 급여를									
#인상하는 SQL문을 작성하시오.								
#(단, 해당 컬럼은 empno, ename, job, sal을 이용한다.)		
select * from emp;

update emp 
	set sal =
		case 
			when job = "부장" then emp.sal * 1.05
			when job = "과장" then emp.sal * 1.1
            when job = "대리" then emp.sal * 1.15
            when job = "사원" then emp.sal * 1.2
            else emp.sal * 1
		end;
