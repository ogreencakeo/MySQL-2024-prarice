-- drop database if exists testdb;
-- create database testdb;
-- 위의 두줄을 한줄로 줄일 수 있는 코드가 아래코드이다.
create database if not exists testdb;
use testdb;

-- 아래와 같이 아무런 제약조건을 주지 않은 테이블을 만들었다.
drop table if exists mixedtbl;
create table mixedtbl(
	userid char(8) not null,
    username varchar(10) not null,
    addr char(2)
);

-- 데이터를 10건 삽입
insert into mixedtbl values('YSJ', '유재석', NULL);
insert into mixedtbl values('KHD', '강호동', NULL);
insert into mixedtbl values('KKJ', '김국진', NULL);
insert into mixedtbl values('KYM', '김용만', NULL);
insert into mixedtbl values('KJD', '김제동', NULL);
insert into mixedtbl values('NHS', '남희석', NULL);
insert into mixedtbl values('SDY', '신동엽', NULL);
insert into mixedtbl values('LHJ', '이휘재', NULL);
insert into mixedtbl values('LKK', '이경규', NULL);
insert into mixedtbl values('PSH', '박수홍', NULL);

-- 위의 mixedtbl테이블은 PK나 UNIQUE NOT NULL과 같은
-- 제약조건이 없다. 하여, SELECT를 하면 삽입된 순서대로 출력을 해준다.
-- 즉, 인덱스가 없다.
select * from mixedtbl;

-- 아래의 코드는 innodb가 지원하는 page 크기는 16KB라는 사실을 알 수가 있다.
show variables like 'innodb_page_size';

-- mixedtbl에 userid에 PK_mixedtbl란 명으로 PK를 추가해보자
-- 그럼 어떻게 되는가? 바로 userid가 PK가 됨과 동시에 클러스터형
-- 인덱스가 생성이 되고 오름차순으로 정렬이 이루어진다.
alter table mixedtbl
	add constraint PK_mixedtbl primary key(userid);

-- 확인 해 보면 인덱스를 확인할 수가 있다.    
show index from mixedtbl;

-- PK 컬럼을 기준으로 오름차순 정렬이 되어 있는 것을 확인할 수가 있다.
-- 이렇게 된 것은 클러스터형 인덱스가 만들어진 것을 의미한다.
-- 즉, 영어사전이 만들어 진 것이다.
select * from mixedtbl;

-- 이번에는 username에다가 unique 제약조건을 걸어보자.
alter table mixedtbl
	add constraint UK_mixedtbl_username unique(username);
    
-- 한 테이블에 클러스터형 인덱스와 보조 인덱스가 각각 같이 생성되어 있다.
select * from mixedtbl;