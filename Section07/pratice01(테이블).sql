drop database if exists tabledb;
create database tabledb;
use tabledb;

drop table if exists usertbl;
create table usertbl(
	userid char(8) not null primary key,
    username varchar(10) not null,
    birthYear int not null,
    addr char(2) null,
    mobile1 char(3) null,
    mobile2 char(8) null,
    height smallint null,
    mdate date null
);
-- 위의 테이블을 만들고 PK를 설정해주면, 자동적으로 클러스터형 index가 만들어진다.
-- 이 부분은 index에서 집중적으로 다룰 것이니, 일단 PK 설정시 index가 
-- 만들어진다는 것만 기억하도록 하자.
-- 아래 테이블을 만들고 외래키를 설정하는데, 외래키를 설정시에는 
-- 참조하는 테이블의 컬럼명과 동일한 이름으로 해주고 데이터 타입도 
-- 일치하게 해주는 것이 관례이다.

drop table if exists buytbl;
create table buytbl(
	num int auto_increment not null primary key,
	userid char(8) not null,
    prodname char(6) not null,
    groupname char(4) null,
    price int not null,
    amount smallint not null,
    -- 외래키 추가부분은 통상 외래키가 있는 테이블이 자식테이블이 되고
    -- PK가 있는 테이블이 부모 테이블이 된다.
    -- 그리고 외래키가 꼭 PK하고 연동되는 것이 아니다.
    -- unique 제약조건을 가지고 있는 컬럼과 연동이 된다.
	foreign key (userid) references usertbl(userid)
    
    -- 외래키의 이름을 직접 지정해주는 코드이다.
    -- constraint FK_usertbl_buytbl foreign key (userid) references usertbl(userid)
);

-- 아래 코드는 테이블의 인덱스에 대한 것을 보는 코드이다.
show index from buytbl;

-- 외래키를 alter table을 가지고 외래키를 추가하는 코드 (현업에서 자주 사용되는 코드)
alter table buytbl
add constraint FK_usertbl_buytbl
foreign key (userid) references usertbl(userid);

-- 외래키를 alter table을 가지고 외래키를 삭제하는 코드
alter table buytbl
drop foreign key FK_usertbl_buytbl;

-- 아래 코드는 mySQL에 생성되어져 있는 모든 DB에 있는 table에 제약조건을 보는 코드이다.
select *
	from information_schema.table_constraints;
    

INSERT INTO userTBL VALUES('YJS', '유재석', 1972, '서울', '010', '11111111', 178, '2008-8-8');
INSERT INTO userTBL VALUES('KHD', '강호동', 1970, '경북', '011', '22222222', 182, '2007-7-7');
INSERT INTO userTBL VALUES('KKJ', '김국진', 1965, '서울', '019', '33333333', 171, '2009-9-9');

-- 아래 코드를 입력하고 실행을 시키면 에러가 난다.
-- 왜일까 ? => 바로, KYM에서 오류가 발생한 것을 확인할 수가 있다.
-- 그 이유는 바로 부모테이블이 되는 usertbl에 KYM이라는 데이터가 없기 때문이다.
-- 회원정보가 없는데 어떻게 구매를 할 수 있겠나?
-- 해결방법은 2가지가 있다.
INSERT INTO buyTBL VALUES(NULL, 'KHD', '운동화', NULL   , 30,   2);
INSERT INTO buyTBL VALUES(NULL, 'KHD', '노트북', '전자', 1000, 1);
INSERT INTO buyTBL VALUES(NULL, 'KYM', '모니터', '전자', 200,  1);

-- 외래키의 기능을 해제시킨다.
set foreign_key_checks = 0;

-- 외래키의 기능을 활성화시킨다.
set foreign_key_checks = 1;

select * 
	from buyTBL;

-- 테이블 삭제
-- usertbl 테이블이 삭제되지 않는다.
-- 이유는 usertbl이 참조하는 buytbl이 있다. 외래키로써 두 테이블은 관계를
-- 맺고 있어서 삭제가 되지 않는다. 하여, usertbl을 삭제를 하려면 
-- 먼저 buytbl을 삭제를 하고 그 후에 usertbl을 삭제 할 수가 있다.
-- 아니면, 외래키 기능을 해제시키거나, alter table을 이용하여
-- buytbl에 있는 외래키를 drop 시키고 삭제가 가능하다.    
drop table usertbl;
-- 첫 번째 방법은 자식 테이블 즉, 외래키가 있는 테이블을 drop을 하고
-- 부모 테이블을 삭제한다.
drop table buytbl;

-- 두 번째 방법은 자식테이블 외래키 기능을 삭제하거나 기능 해제하는 코드를
-- 넣어서 usertbl을 삭제한다.
set foreign_key_checks = 1;
alter table buytbl
drop foreign key FK_usertbl_buytbl;
