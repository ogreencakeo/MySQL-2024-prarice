-- mydb를 이용하시오.
-- 문제 117
-- emp테이블을 이용하여 emp_index 테이블을 만들어보시오.
use mydb;
drop table if exists emp_index;
create table emp_index(
	select * from emp
);

-- 문제 118
-- 만들어진 emp_index 테이블에 제약조건이 걸려 있는지 직접 확인하는 
-- 코드를 작성하시오.
show index from emp_index;

-- 문제 119
-- emp_index에서 empno에 pk제약조건을 추가하시오.
-- 인덱스명은 PK_emp_index_pk로 지정하세요.
-- 이렇게 만든 인덱스를 무엇이라고 칭하나? : 클러스터형 인덱스
alter table emp_index
	add constraint PK_emp_index_pk primary key(empno);
select * from emp_index;

-- 문제 120
-- ename에 unique 제약조건을 걸어 보조인덱스를 생성해보시오.
-- 인덱스명은 UK_emp_index_name으로 하자
-- 혹시, 이름이 겹치면 해당 이름을 다른 이름으로 수정하시오.
alter table emp_index
	add constraint UK_emp_index_name unique key(ename);

select * from emp_index;

delete from emp_index where empno = 1010;

show index from emp_index;
    
-- 문제 121
-- 이렇게 만든 인덱스를 확인해보면 나타나지 않은 것이 있을 것이다.
-- 테이블에 인덱스를 적용시키고 다시 인덱스를 조회해보시오.
analyze table emp_index;
show index from emp_index;

-- 문제 122
-- 다시 job컬럼에 unique제약조건을 걸어 보조인덱스를 생성해보시오.
-- 인덱스명은 UK_emp_index_job으로 하자. (생성이 되나? 안될 것이다.)
-- 안되는 이유가 무엇인지 서술하시오.
alter table emp_index
	add constraint UK_emp_index_job unique key(job);

select * from emp_index;
-- unique index를 생성하지 못하는 이유 : job컬럼에는 중복데이터가 다수
-- 존재하므로 unique index를 추가하지 못한다.

-- 문제 123
-- 지금까지 만든 인덱스를 다 제거하시오.
show index from emp_index;
drop index UK_emp_index_name on emp_index;
alter table emp_index
	drop primary key;

-- 문제 124
-- 인덱스를 만들어야 하는 경우는 언제인가?
-- 아는데로 서술하시오.
-- 1. where절에 자주 사용되는 열에 인덱스를 생성해야 한다.
-- 2. 데이터의 중복도가 없는 곳에 인덱스를 생성해야 효과를 본다.
-- 3. 조인에 자주 사용되는 열의 경우 인덱스를 생성해야한다.

