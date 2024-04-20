-- 오류처리, 동적SQL문
-- action 부분 : continue라서 계속 하라는 뜻이다. 1146이란 오류가 뜨면
-- '테이블이 없습니다.'를 출력하는 것이다. 1146에러 코드는 테이블이 없을 때
-- mySQL에서 직접 발생시키는 오류코드 번호이다. sqlstate '42S02'도 역시 
-- 테이블이 존재하지 않을 때 나타나는 오류코드 번호이다.
-- 코드번호르 찾아서 넣어주면 오류처리 코드 구문을 충분히 만들 수가 있다.
-- 일반적으로 데이터베이스 오류코드는 너무 많기 때문에 사용자에게 직접 알아보기 쉽게
-- 오류처리 구문을 넣어주면 디버깅 할 때 상당한 도움이 될 것이다.
drop procedure if exists errorProc;
delimiter //
	create procedure errorProc()
    begin
		-- declare continue handler for 1146 select '테이블이 없습니다.' as '오류 메시지';
		declare continue handler for sqlstate '42S02' select '테이블이 없습니다.' as '오류 메시지';
        select *
			from AAA;
    end //
delimiter ;

call errorProc();

-- PK가 중복되었을 때, 오류처리를 하는 코드
drop procedure if exists pkErroProc;
delimiter //
	create procedure pkErroProc()
    begin
		-- 모든 오류를 다 받을 수 있도록 선언하였다.
		declare continue handler for sqlexception 
        begin
			show errors; 	-- 오류 메시지를 보여준다.
            select '오류가 발생하여 작업을 취소시킵니다.' as '메시지';
            rollback; 		-- 작업을 되돌림.
		end;
        
        -- select * from usertbl;
        
        -- PK LKK는 이미 이경규가 들어가있으므로 오류를 분명히 발생 시킬 것이다.
        insert into usertbl values('LKK', '이구기', 1988, '평양', null, null, 170, current_date());
    end //
delimiter ;

call pkErroProc();

-- 동적 SQL문, prepare, excute, using
-- prepare : myQuery를 변수라고 생각하고 그 변수에 쿼리문을 대입한 것이다.
-- 즉, 준비만 한다는 것이다. 결과문이 출력되진 않는다. 일종의 메모리 할당 개념이다.
prepare myQuery from 'select * from usertbl where userid = "LKK"';
execute myquery;
-- 메모리 사용 했으면 해제를 해줘야 한다.
deallocate prepare myQuery;

drop table if exists mytable;
create table mytable(
	id int auto_increment primary key,
    mdate datetime
);

-- 아래 3줄을 여러번 실행해보도록 하자.
-- 현재 날짜와 시간을 curdate변수에 저장한다. 즉, 실행시점에서 날짜와 시간이 저장되는 것
-- ex) 회원가입이나 구매시점, 출근퇴근시간 어느 시점을 기록하고 싶을 때 자주 사용한다.
set @curdate = current_timestamp();
prepare myQuery	from 'insert into mytable values (null, ?)';
execute myQuery using @curdate;
deallocate prepare myQuery;

select * 
	from mytable;