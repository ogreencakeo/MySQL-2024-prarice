use mydb;
select * from emp;
#문제74. emp테이블을 이용하여 부서번호로 부서명을 알아내는 sql프로그램을 작성하시오
#단, 사원번호가 1001인 사원만 출력하시오. if문을 사용하도록 합니다.
#프로시저의 이름은 deptname_if_proc()으로 합니다.
drop procedure if exists deptname_if_proc;
delimiter //
	create procedure deptname_if_proc()
    begin
		select empno as '사원번호', ename, 
			if(deptno = 10, '경리부',
			if(deptno = 20, '인사부',
            if(deptno = 30, '영업부', '전산부'))) as '부서명'
            from emp
            where empno = 1001;
    end //
delimiter ;

call deptname_if_proc();
#문제75. emp테이블을 이용하여 사원명이 '김사랑'의 연봉을 구하는 sql프로그램을 작성하시오
#if, else문을 사용합니다.
#연봉 = 월급 * 12 + 보너스
#프로시저의 이름은 yearsal_if_else_proc()으로 합니다.
drop procedure if exists yearsal_if_else_proc;
delimiter //
	create procedure yearsal_if_else_proc()
    begin
		declare comm int;
        set comm = (select comm from emp where ename = '김사랑');
        if comm is null then
			select ename as '사원명', (sal*12) as '연봉' 
				from emp
			where ename = '김사랑';
		else 
			select ename as '사원명', (sal*12+comm) as '연봉' 
				from emp
			where ename = '김사랑';
		end if;
    end //
delimiter ;

call yearsal_if_else_proc();

#문제76. 문제74을 if문이 아니라 if ~ elseif ~ else문으로 sql프로그램으로 작성하시오
#프로시져명 : deptname_if_proc()
drop procedure if exists deptname_if_proc;
delimiter //
	create procedure deptname_if_proc()
    begin
		declare dept_no int;
        declare dname char(3);
        
        set dept_no = (select deptno from emp
			where empno = 1001);
		
        if(dept_no = 10) then
			set dname = '경리부';
		elseif(dept_no = 20) then
			set dname = '인사부';
		elseif(dept_no = 30) then
			set dname = '영업부';
		else 
			set dname = '전산부';
		end if;
        
        select dname as '부서명';
    end //
delimiter ;

call deptname_if_proc();

# 문제77. emp테이블에서 보너스를 받지 않는 사람 중에 사원번호, 이름, 월급, 보너스, 부서번호를 
# 오름차순으로 출력하는 usp_emp()프로시져를 만들어라 
drop procedure if exists usp_emp;
delimiter //
	create procedure usp_emp()
    begin
		select empno '사원번호' , ename '이름' , sal '월급' , comm '보너스' , deptno '부서번호' 
			from emp 
			where comm is null
            order by deptno asc;
    end //
delimiter ;

call usp_emp();

#문제78. 학점을 출력하는 프로그램을 중첩 if문을 사용하는 프로시져를 만들어라.
#프로시져명 : grade_Proc()
#60점 미만 F, 60 ~ 64까지 D, 65 ~ 69까지 D+
#70 ~74까지 C, 75 ~ 79까지 C+
#80 ~ 84까지 B, 85 ~ 89까지 B+
#90 ~ 94까지 A, 95 ~ 100까지 A+
drop procedure if exists grade_Proc;
delimiter //
	create procedure grade_Proc()
    begin
		declare score int;
        declare grade char(2);
		
        set score = 88;
        
        if(score >= 90) then
			if(score >= 95) then set grade = 'A+';
			else set grade = 'A';
			end if;
		elseif(score >= 80) then
			if(score >= 85) then set grade = 'B+';
			else set grade = 'B';
			end if;
       elseif(score >= 70) then
			if(score >= 75) then set grade = 'C+';
			else set grade = 'C';
			end if;
		elseif(score >= 60) then
			if(score >= 65) then set grade = 'D+';
			else set grade = 'D';
			end if;
		else set grade = 'F';
		end if;
        
        select concat('취득점수', score, '이며, 학점은 ', grade, '입니다.');
    end //
delimiter ;

call grade_Proc();

#문제79. 문제78번을 case문으로 만들어보라.
#프로시져명 : grade_case_Proc()
drop procedure if exists grade_case_Proc;
delimiter //
	create procedure grade_case_Proc()
    begin
		declare score int;
        declare grade varchar(2);
        set score = 68;
        case
			when score >= 95 then set grade = 'A+';
            when score >= 90 then set grade = 'A';
            when score >= 85 then set grade = 'B+';
            when score >= 80 then set grade = 'B';
            when score >= 75 then set grade = 'C+';
            when score >= 70 then set grade = 'C';
            when score >= 65 then set grade = 'D+';
            when score >= 60 then set grade = 'D';
            else set grade = 'F';
            end case;
            
            select concat('취득점수', score, '이며, 학점은 ', grade, '입니다.');
    end //
delimiter ;

call grade_case_Proc();

#문제80. 계절을 출력하는 프로시져를 만들어라(case문 사용)
#12,1,2 : 겨울
#3,4,5 : 봄
#6,7,8 : 여름
#9,10,11 : 가을
#프로시져명 : season_Proc()
#변수를 선언하여 5월로 지정합니다.
#출력결과
#5월은 봄입니다. 
drop procedure if exists season_Proc;
delimiter //
	create procedure season_Proc()
    begin
		declare today_month char(5);
		declare season char(5);
        
        set today_month = 5;
        
        case
			when today_month between 12 and 2 then set season = '겨울';
			when today_month between 3 and 5 then set season = '봄';
            when today_month between 6 and 8 then set season = '여름';
            else set season = '가을';
		end case;
        
		select concat(today_month, '월은' ,season, '입니다.');
	end //
delimiter ;

call season_Proc();

#문제81. 계산기 프로그램을 만들어봅니다.
#프로시져명 : calc_Proc()
#변수 2개를 선언후 각각 10, 5로 저장합니다.
#case문을 사용하여 + , -, / ,* , % 연산 기호에 따라 결과를 출력하세요 .
#연산 변수는 *연산자로 저장합니다
#출력결과
#10과 5의 곱은 50입니다.
drop procedure if exists calc_Proc;
delimiter //
	create procedure calc_Proc()
    begin
		declare x int;
        declare y int;
        declare operator char(1);
        declare result int;
        
        set x = 10;
        set y = 5;
        set operator = '*';
        set result = 0;
        
        case
			when operator = '+' then set result = x + y;
            when operator = '-' then set result = x - y;
			when operator = '/' then set result = x / y;
			when operator = '*' then set result = x * y;
            when operator = '%' then set result = x % y;
		end case;
        
        select concat(x, '과 ', y, '의 곱은 ', result, '입니다.');
        
    end //
delimiter ;

call calc_Proc();

#문제82. 
#주민등록번호를 변수를 선언하여 임의로 저장한 후, 7번째 자리를 가지고 아래와 같은 결과값을 출력하는 
#프로시져를 작성하시오.
#프로시져명 : identy_Proc()
#if문을 사용하여 1,2,3,4에 따라 아래와 같이 출력하세요
#출력결과
#당신은 2000년 이전에 출생한 남자입니다.
drop procedure if exists identy_Proc;
delimiter //
	create procedure identy_Proc()
    begin
		declare juminNo char(14);
        declare gender char(2);
        declare age char(10);
        
        set juminNo = '890315-1695442';
        
        if (substring(juminNo, 8, 1) = '1' ) then 
			set gender = '남자';
            set age = '2000년 이전';
		elseif (substring(juminNo, 8, 1) = '2' ) then 
			set gender = '여자';
            set age = '2000년 이전';
		elseif (substring(juminNo, 8, 1) = '3' ) then 
			set gender = '남자';
            set age = '2000년 이후';
		elseif (substring(juminNo, 8, 1) = '4' ) then 
			set gender = '여자';
            set age = '2000년 이후';
		end if;
        
        select concat('당신은 ', age, '에 출생한 ', gender, '입니다.');
    
    end //
delimiter ;

call identy_Proc();

#문제83
#1~100까지의 합을 구하는데, 2와 3의 공배수는 더하지 않고 나머지 수의 
#합계를 구하는 프로시져를 구현하시오
#프로시져명 : multiple_Proc()

#문제84
#1~1000까지 합을 구하는데 7의 배수이거나 9의 배수는 합에 포함하지 않고,
#나머지 수의 합계를 구하는 프로시져를 구현하시오/
#프로시져명 : multiple_Proc79()

#문제 85
#직급을 저장할 변수를 선언하여 차장으로 저장합니다.
#아래의 조건을 case문을 통해 작성하고 출력결과와 같이 
#나오게 프로시져를 구현하시오.
#프로시져명 : sal_Proc()
/*
조건		
1. 상무 : 1000만원		2. 부장 :  800만원		3. 차장 :  600만원		
4. 과장 :  400만원		5. 대리 :  250만원		6. 사원 :  180만원		
		
출력결과		
차장의 월급은 600만원입니다.		
*/