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

-- 아래 코드는 테이블의 제약조건을 보는 것이다.
show index from buytbl;

-- 외래키를 alter table을 가지고 외래키를 추가하는 코드
alter table buytbl
add constraint FK_usertbl_buytbl
foreign key (userid) references usertbl(userid);
