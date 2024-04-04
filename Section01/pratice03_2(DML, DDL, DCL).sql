-- 통상 sql은 아래와 같은 불류로 나눈다.
-- 1. DML (Data Manipulation Language) : 데이터 조작언어
-- DML은 얼마든지 취소 가능핟. rollback이란 키워드로 말이다.
-- ex) select, insert, delete update
-- 2. DDL (Data Definition Language) : 데이터 정의언어
-- DDL은 취소가 안된다. 실행하면 바로 물리적 저장공간에 적용된다.
-- ex) create, drop, alter, truncate(테이블의 구조를 그대로 남긴체 데이터를 다 지워준다.)
-- 3. DCL (Data Controll Language) : 데이터 제어언어
-- 유저에게 어떤 권한을 부여하거나 빼앗을 때 사용하는 구문
-- ex) grant, revoke

use sqldb;
drop table if exists testtbl1;
create table testtbl1(
	id int,
    username varchar(3),
    age int
);

insert into testtbl1 values(1, '홍길동', 33);
-- 원하는 필드에만 저장하고 싶다면 아래와 같이 쿼리를 작성.
-- 저장하지 않은 필드는 null
insert into testtbl1(id, username) values(2, '김연아');
-- 필드를 사용자 마음대로 설정해서 넣을 수 있음.
insert into testtbl1(username, id, age) values('김철수', 3, 28);

drop table if exists testtbl2;
-- auto_increment 구문은 DB엔진이 자동으로 행을 추가될 때마다 1씩 증가함
create table testtbl2(
	id int auto_increment primary key,
    username varchar(3),
    age int
);

insert into testtbl2 values
(null, "짱구", 8),
(null, "유리", 8),
(null, "훈이", 8);

delete from testtbl2 where id = 2; 

insert into testtbl2 values(null, "김군", 30);
insert into testtbl2 values(10, "김군", 30);

-- auto_increment한 필드가 마지막으로 삽입된 것을 조회할 때
select last_insert_id();

-- 테이블에 관련된 수정을 하고자 하면 alter을 이용하면 된다.
alter table testtbl2 auto_increment = 100;
insert into testtbl2 values(null, "손오공", 100);

drop table if exists testtbl3;
create table testtbl3(
	id int auto_increment primary key,
    username varchar(3),
    age int
);

alter table testtbl3 auto_increment = 1000;

-- 서버변수
-- set 구문 다음 @@ 붙으면 서버변수라고 생각을 하자.
-- 아래와 같이 코드를 줬다면 무조건 증가를 3씩하라.
set @@auto_increment_increment = 3;

insert into testtbl3 values(null, "나연", 22); -- 1000
insert into testtbl3 values(null, "쯔위", 20); -- 1003
insert into testtbl3 values(null, "미나", 23); -- 1006

-- truncater구문은 DDL이기 때문에 트랜잭션에 해당하지 않기 땨문에
-- 대용량 데이터를 한번에 지우고자 할 때 효율적이다.
truncate testtbl3; 

select * from testtbl3;
