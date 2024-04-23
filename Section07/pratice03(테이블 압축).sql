drop database if exists compressdb;
create database compressdb;
use compressdb;

-- 테이블 생성
drop table if exists normaltbl;
create table normaltbl(
	emp_no int,
    first_name varchar(14)
);

-- 테이블을 생성하는데 row_format = compressed를 설정을 하며,
-- 이 테이블은 앞으로 물리적(하드웨어)으로 데이터를 압축하여 저장하겠다라는 의미이다.
drop table if exists compresstbl;
create table compresstbl(
	emp_no int,
    first_name varchar(14)
) row_format = compressed; 	-- 압축하여 사용하겠다라는 의미가 된다.

select * from employees.employees;

insert into normaltbl( select emp_no, first_name 
	from employees.employees);

-- 데이터가 저장이 되면서 압축 과정을 거치기 때문에 상대적으로 nornaltbl에
-- 비해서 느린편이다.
insert into compresstbl( select emp_no, first_name 
	from employees.employees);

-- compresstbl의 용량은 약 6.7MB
-- normaltbl의 용량은 약 11.51MB
-- 확인 해보면 확실히 compresstbl이 normaltbl보다 압축이 되어서
-- data_length가 약 45% 정도가 물리적으로 공간을 절약하고 있는 것을
-- 볼수가 있다. 하지만, 압축 테이블은 기존 테이블에 비해서 성능이 
-- 좀 떨어지는 경향과 더불어 데이터가 깨질 확률도 다수 있다.
-- 서버의 공간을 절약하고 싶을 때 쓸수가 있다. (추천하지 않는다.)
show table status from compressdb;

