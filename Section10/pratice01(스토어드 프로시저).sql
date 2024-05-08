use sqldb;

drop procedure if exists userproc;

delimiter //
	create procedure userproc()
    -- 현업에서는 스토어드 프로시져의 내용은 통상 begin ~ end 사이에 내용으로 이루어진다.
    -- 물론 지금은 쿼리문이 몇 줄밖에 없겠지만, 프로그래밍을 하시다 보면 몇백줄,
    -- 몇 천줄까지 될 수도 있다.
    -- 이 장에서는 begin ~ end 사이의 내용을 집중적으로 배우고 호출하면서 얼마나
    -- 편리한 기능인지 살펴보도록 하자.
    begin
		select * from usertbl;
    end //
delimiter ;

-- 위에서 만든 프로시저를 호출하는 방법
call userproc();

-- 입력매개변수 (인자값, 아규먼트, 파라메터)가 있을 때의 프로그래밍
drop procedure if exists userproc2;
-- 여기서는 in이란 매개변수를 이용해서 쿼리문의 조건의 대입값을 활용을
-- 하는 경우이다. 
delimiter //
	create procedure userproc2(in inusername varchar(10))
    begin
		select * from usertbl
			where username = inusername;
    end // 
delimiter ;
 
-- 매개변수 inusername의 데이터 형식에 맞게끔 값을 반드시 일치시켜야 한다.
call userproc2("유재석");
call userproc2("이경규");

-- 매개변수에 타입과 일치하지 않는 값을 주니 아무런 결과값을 주지 아니한다.
call userproc2("유");

-- 이번에는 매개변수가 2개인 것을 알아보자
drop procedure if exists userproc3;
delimiter //
	create procedure userproc3(in userbirth int, in userheight int)
    begin
		select * 
			from usertbl
		where birthyear > userbirth -- 출생년도를 비교
			and height > userheight; -- 키를 비교
    end //
delimiter ;

-- 1970년 이후에 태어났거, 키가 175 초과 조건을 만족하는 데이터를 검색하는 것
call userproc3(1970, 175);

-- 이번에는 출력 매개변수에 대해서 알아보자
drop procedure if exists userproc4;
-- 여기서는 입력매개변수가 1개, 출력 매개변수가 1개로 되어있다.
-- 근데, 중요한 것은 지금 현재 sqldb에는 testtbl이 없다.
-- 그럼에도 불구하고 procedure가 만들어지는데는 영향이 없다.
-- 단지 실행만 안하면 문제가 없다는 것을 의미한다. 즉, call을 할때는 반드시
-- testtbl테이블이 있어야 procedure가 실행된다.
delimiter //
	create procedure userproc4(in txtvalue char(10), out outvalue int)
    begin
		-- txtvalue값이 testtbl에 자동 저장된다.
		insert into testtbl values(null, txtvalue);
        select max(id) into outvalue
			from testtbl;
    end //
delimiter ;

-- 위의 userproc4에 필요한 testtbl을 정의하자.
drop table if exists testtbl;
create table testtbl(
	id int auto_increment primary key,
    txt char(10)
);

-- @가 붙으면 변수라는 것을 알 수 있다.
call userproc4('테스트', @value);
call userproc4('테스트1', @value);

select concat('현재 입력된 아이디 값 ->', @value);