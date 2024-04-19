-- SQL 프로그래밍 기본적 문법
-- 1. if문, case문

use sqldb;

-- num이라는 변수명으로 int(정수)타입으로 4바이트 메모리(스택)에 할당해서,
-- num이라는 저장공간에다가 400을 저장한다.
-- if구문을 이용하여 num이 500이면 실행하고 500이 아니면 else 구문을 실행
-- delimiter은 구분자이다.
-- 프로시저를 만드는 코드에는 주석을 달면 프로시저가 만들어지지 않으므로
-- 주석을 달지 않도록 하자.

drop procedure if exists ifProc;
delimiter // 	
create procedure ifProc()
begin 
	declare num int;
    set num = 400;
    
    if num = 500 then 
		select '500입니다.';
	else 
		select '500이 아닙니다.';
	end if;
end //
delimiter ;

-- ifProc() 프로시저를 호출하는 코드
call ifProc();

select * from employees.employees;

-- 아래 프로시저는 입사한지 5년이 지났는지 직접 확인하는 프로그래밍
-- 먼저 변수를 date 타입으로 2개 (현재, 입사년도)를 선언하고, 날짜 계산하기 위해서
-- days를 int형으로 선언했다.
-- select hire_date into hiredate는 hire_date 컬럼의 내용을 변수 hiredate에 
-- 대입하라는 뭐리문이다. hiredate를 이용하여 계산을 하면 된다.
-- 근무일수는 현재날짜 - 입사날짜 이니까 datediff()를 이용해서 구하고
-- 날짜 / 365로 하면 근무년수가 나온다.
drop procedure if exists ifProc2;
delimiter $$
create procedure ifProc2()
begin
	declare hiredate date;
    declare curdate date;
    declare days int;
    
    select hire_date into hiredate
		from employees.employees
	where emp_no = 10001;
    
    set curdate = curdate();
    set days = datediff(curdate, hiredate);
    
    select concat('근무일수', days);
    
    if(days / 365) >= 5 then
		select concat('입사한지 ', days/365, '년이 넘었군요') as '입사경과 년수';
	else 
		select concat('아직 ', days/365, '년 밖에 안됐군요.') as '입사경과 년수';
	end if;
end $$
delimiter ;

call ifProc2();

-- 학점을 출력하는 SQL 프로그래밍을 해보도록 하자.
drop procedure if exists ifProc3;
delimiter //
create procedure ifProc3()
begin 
	declare score int;
    declare grade char(1);
    set score = 92;
    
    if score >= 90 then
		set grade = 'A';
	elseif score >= 80 then
		set grade = 'B';
	elseif score >= 70 then
		set grade = 'C';
	elseif score >= 60 then
		set grade = 'D';
	else 
		set grade = 'F';
	end if;
    select concat('점수 : ', score) as '점수', 
		concat('학점 : ' , grade) as '취득학점';
end //
delimiter ;

call ifProc3();

-- 위의 결과를 동일하게 나타내는 구문 중 case문으로 작성을 해보자.
drop procedure if exists caseProc;
delimiter //
	create procedure caseProc()
    begin
		declare score int;
		declare grade char(1);
		set score = 92;
        
        case 
			when score >= 90 then
				set grade = 'A';
			when score >= 80 then
				set grade = 'B';
			when score >= 70 then
				set grade = 'C';
			when score >= 60 then
				set grade = 'D';
			else 
				set grade = 'F';
			end case;
		select concat('점수 : ', score) as '점수', 
		concat('학점 : ' , grade) as '취득학점';
    end //
delimiter ;

call CaseProc();

-- Section 05 초기화 시킨 후, 아래 쿼리를 해보자.
use sqldb;

-- 총 구매액을 기준으로 userid 출력
select userid, sum(price * amount) as '총 구매액'
	from buytbl
    group by userid
    order by sum(price * amount) desc;

select * from buytbl;
select * from usertbl;

-- 고객 이름이 없으니 조인을 이용해서 usertbl과 엮도록 하자.
-- 내부조인을 하게 되면 구매내역만 있는 고객만 출력이 된다.
select U.userid, U.username, 
	sum(B.price * B.amount) as '총 구매액' from buytbl B
    inner join usertbl U
    on B.userid = U.userid
    group by U.userid, U.username
    order by sum(B.price * B.amount) desc;
    
-- 외부조인을 다시 하여 구매하지 않은 고객까지 출력을 해보도록 해야지 고객의 등급을
-- 나눌 수가 있다.
select U.userid, U.username, 
	sum(B.price * B.amount) as '총 구매액' from buytbl B
    right outer join usertbl U
    on B.userid = U.userid
    group by U.userid, U.username
    order by sum(B.price * B.amount) desc;

-- 고객 등급 나누어서 출력하기
-- select문 안에 하나의 컬럼처럼 고객등급을 case when then 구문으로 설정함.
select U.userid, U.username, 
	sum(B.price * B.amount) as '총 구매액' ,
    case 
		when sum(B.price * B.amount) >= 1500 then '최우수고객'
        when sum(B.price * B.amount) >= 1000 then '우수고객'
        when sum(B.price * B.amount) >= 1 then '일반고객'
        else '유령고객'
        end as '고객등급'
	from buytbl B
    right outer join usertbl U
    on B.userid = U.userid
    group by U.userid, U.username
    order by sum(B.price * B.amount) desc;
        