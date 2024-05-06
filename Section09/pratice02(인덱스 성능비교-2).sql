use indexdb;
-- 현재 emp 테이블은 인덱스가 하나도 없다.
-- 그럼 select 문을 실행하면 풀테이블스캔을 할 수 밖에 없는 것이다.
-- execution plan에서 알수가 있다.
-- 여기서는 약 1000페이지 정도를 읽는 것으로 나올 것이다.
-- 1000페이지 = 쿼리 실행 후 읽은 페이지 수 - 쿼리 실행전 읽은 페이지 수

-- 쿼리 실행전의 읽은 페이지 수를 알아보는 명령어
-- 30995.90(query cost)
-- 1050 페이지를 읽었다.
show global status like 'innodb_pages_read';
select * from emp 
	where emp_no = '100000';
show global status like 'innodb_pages_read';

-- 클러스터형 인덱스가 존재하는 emp_c 테이블의 실행결과를 보면
-- 약 10페이지 읽었다. 가히 100배 이상 차이가 남는 것을 확인 할 수가 있다.
show global status like 'innodb_pages_read';
select * from emp_c 
	where emp_no = '100000';
show global status like 'innodb_pages_read';

-- 이번에는 보조인덱스가 있는 emp_se의 실행결과를 보자
-- 약 5 페이지를 읽었다.
show global status like 'innodb_pages_read';
select * from emp_se 
	where emp_no = '100000';
show global status like 'innodb_pages_read';

-- 이로써 인덱스가 있고 없고에 따라 DB의 성능이 엄청나게 차이가 나는 것을 
-- 알 수가 있다.