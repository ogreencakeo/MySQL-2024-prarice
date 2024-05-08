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