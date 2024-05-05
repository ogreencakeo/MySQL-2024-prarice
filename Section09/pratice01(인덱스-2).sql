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
-- 그럼 내부적으로 구성되는 것은 방금 그림을 그린 것과 같이 될 것이다.
-- 김용만 주소를 찾기 위해서는 클러스터형 인덱스를 이용을 하면 2페이지만 읽으면 된다.
-- 클러스터형 인덱스는 리프페이지가 곧 데이터 페이지이기 때문이다.
-- 그에 반해서 보조 인덱스는 데이터 페이지는 건드리지 않고
-- 별도의 공간의 인덱스를 생성해서 거기 인덱스에 실제 데이터가 들어가 있는
-- 주소+#오프셋 값이 들어가 있어서 3번 페이지를 읽게 되는 것이다.
select * from mixedtbl;

-- Section05 초기화 코드
-- sqldb 초기화 시키자
use sqldb;

select * from usertbl;

-- 인덱스가 있는지 확인
show index from usertbl;
-- 앞에서도 했지만, usertbl의 상태를 보는 것이다. 
-- data_length가 클러스터형 인덱스의 크기이다.
-- idx_length는 보조 인덱스의 크기를 나타내는 것이다. 지금은 없기 때문에
-- 0으로 출력이 된 것을 알 수 있다.
show table status like 'usertbl';

-- addr컬럼에 보조 인덱스를 생성하는 것이다.
create index idx_usertbl_addr
	on usertbl(addr);

-- 보조 인덱스를 만드면 바로 테이블에 적용이 되는 것이 아니라
-- 직접 테이블에 적용하는 코드를 실행해줘야 한다.
analyze table usertbl;
-- 보조 인덱스를 테이블에 적용을 시키니 비로소 index_length가 16kb가
-- 잡힌 것을 확인 할 수 있다.
show table status like 'usertbl';

-- birthYear 컬럼에다가 unique index를 만들어주고 실행하니 오류가 발생
-- 그 이유는 unique 제약조건은 중복 불가이기 때문에 birthYear 컬럼은
-- unique index의 자격으로 충분하지 않다.
create unique index idx_usertbl_birthYead
	on usertbl(birthYear);

select * from usertbl;

-- username에 unique index가 잘 만들어졌다.
create unique index idx_usertbl_name
	on usertbl(username);

show index from usertbl;

-- 아래의 데이터를 삽입하면 오류가 발생한다. 분명 userid는 다른데 말이다.
-- 그 이유는 username을 우리가 위에서 unique index로 만들었다.
-- 중복을 허용하지 않으니 오류가 나는 것이다.
-- 동명이인도 있는데 이러한 컬럼에다가 unique index를 잡으면,
-- '김용만'을 딱 한 명만 저장하는 꼴이 된다.
-- 현실적으로 이 내용은 맞지 않다.
-- 하여, 인덱스를 어느 컬럼에 설정을 해야할지 정말 고민을 많이 해야한다.
-- 아울러, 정말 unique한 것 (주민등록번호, 학번, 전화번호 앞자리)으로
-- 잡아주는 것이 상당히 현명한 것이다.
insert into usertbl values('GYM', '김용만', 1960, '미국', NULL, NULL, 170, NULL);

-- 그래서 위에 인덱스를 제거를 했다.
drop index idx_usertbl_name on usertbl;

show index from usertbl;