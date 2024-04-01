# 문제 1, 2
CREATE DATABASE MYDB;
USE MYDB;

CREATE TABLE DEPT(
	deptno int not null,
    dname varchar(14),
    loc varchar(13),
    primary key(deptno)
);

insert into dept values(10, '경리부', '서울');
insert into dept values(20, '인사부', '인천');
insert into dept values(30, '영업부', '용인');
insert into dept values(40, '전산부', '수원');

select * from dept;

