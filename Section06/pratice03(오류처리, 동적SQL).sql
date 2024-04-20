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
		declare continue handler for 1146 select '테이블이 없습니다.' as '오류 메시지';
        select *
			from AAA;
    end //
delimiter ;

call errorProc();