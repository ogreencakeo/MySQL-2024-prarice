-- SHOPDB라는 데이터 베이스를 만드는 것
CREATE DATABASE SHOPDB;
-- use 명령어는 '~를 사용하겠다'
USE SHOPDB;

-- MEMBERTBL을 만드는 쿼리문
CREATE TABLE MEMBERTBL(
	memberID varchar(10) not null,
    memberName varchar(10) not null,
    memberAddress varchar(30),
    primary key(memberID) -- 중복방지
);

-- MemberTBL을 제거하는 명령어
DROP TABLE MEMBERTBL;

-- MEMBERTBL의 테이블 상태를 보는 명령어
DESC MEMBERTBL;

-- Membertbl에 있는 모든 열의 값들을 다 출력하는 쿼리문
SELECT * FROM MEMBERTBL;

-- 데이터를 membertbl에다가 저장하는 쿼리문
-- not null이라는 제약조건은 "" 저장을 시켜주지만, null이라고 저장을 하면 null이라고 인정을 하여
-- 저장을 시켜주지 아니한다.
INSERT INTO MEMBERTBL VALUES("KIM", "김철수1", "");
INSERT INTO MEMBERTBL VALUES("Lee", "", "");
INSERT INTO MEMBERTBL VALUES("Han", "", null);

INSERT INTO MEMBERTBL VALUES("kim", "김철수2", ""); -- 에러 : primary key가 겹쳐서 -- 

-- 사용할 데이터
INSERT INTO MEMBERTBL VALUES("KIM", "김철수", NULL);
INSERT INTO MEMBERTBL VALUES("Lee", "이순신", "서울");
INSERT INTO MEMBERTBL VALUES("Gang", "장기도", "경기도");
INSERT INTO MEMBERTBL VALUES("Han", "한부산", "부산");
INSERT INTO MEMBERTBL VALUES("Park", "박인천", "인천");

-- 데이터를 삭제해주는 명령어
DELETE FROM MEMBERTBL;

Create table productTbl(
	productName varchar(10) not null,
    cost int not null,
    makeDate date,
    company varchar(10) not null,
    ammount int not null,
    primary key(productName)
);

desc producttbl;

select * from producttbl;

INSERT INTO  producttbl values("컴퓨터", 10, "2024-03-01", "삼송", 17);
INSERT INTO  producttbl values("세탁기", 20, "20240111", "LD", 3);
INSERT INTO  producttbl values("냉장고", 30, "20240221", "데우", 22);