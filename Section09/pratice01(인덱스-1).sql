-- Section05 초기화 코드
use sqldb;

-- 일단 buytbl에 있는 외래키를 제거하도록 하자
alter table buytbl
	drop foreign key buytbl_ibfk_1;

-- 아래 코드는 전체 데이터베이스 안에 있는 테이블의 제약조건의 상세를 알 수가 있다.
select * from information_schema.table_constraints;

-- 자 조회를 하면, order by를 주지도 않았는데도 불구하고
-- 삽입할 때와는 다르게 알파벳 순으로 정렬이 되어있음을 알 수 있다.
-- 즉, 클러스터 인덱스의 효과인 것이다.
-- 영어사전의 단어 역할을 하는 것이다. 다시 말해 테이블에 PK를 설정을 하면
-- 그것이 곧 클러스터형 인덱스가 되어서 정렬이 되어진 것이다.
select * from usertbl;

-- 아래와 같이 테이블을 만들어보자.
drop table if exists tbl1;
create table tbl1(
	a int primary key,
    b int,
    c int
);

-- tbl1에 인덱스를 살펴보는 명령어이다.
-- 보면 non_unique는 거꾸로 되어있다. 0이라면 unique라는 것이다.
-- 또한 key name이 primary로 되어있다면, 클러스터형 인덱스라고 생각하면 된다.
-- primary가 아니라면, 보조 인덱스라고 생각하면 된다.
-- 아울러, a라는 필드가 primary 키인 것이다.
show index from tbl1;

-- 테이블을 하나 더 추가하자
drop table if exists tbl2;
create table tbl2(
	a int primary key,	-- 클러스터형 인덱스 (무조건 중복 불가)
    -- unique 제약조건은 중복 불가이지만, null은 허용
    -- null의 중복도 허용이된다고 한 바 있다.
    b int unique, 	-- 보조 인덱스
    c int unique 	-- 보조 인덱스
);

show index from tbl2;

drop table if exists tbl3;
create table tbl3(
	a int unique,
    b int unique,
    c int unique
);

-- 확인을 해보면 보조 인덱스로만 구성되어진 테이블이다.
-- 하여 클러스터형 인덱스가 필수인 것은 아니란 것을 여기서 알 수가 있다.
show index from tbl3;

drop table if exists tbl4;
create table tbl4(
	-- unique 제약 조건인데 not null을 추가했다.
    -- 그렇게 되면 클러스터형 인덱스가 된다.
    a int unique not null,
    b int unique,
    c int unique,
    d int 
);

-- 확인해보면, a필드에 null 값을 허용하지 아니한다라고 나온다.
-- 그럼 클러스터형 인덱스가 되는 것이다.
-- 정리를 하자면, 클러스터형 인덱스는 2가지가 될 수 있다. 
-- 1. PK
-- 2. unique not null
show index from tbl4;

insert into tbl4 values (3, 3, 3, 3);
insert into tbl4 values (1, 1, 1, 1);
insert into tbl4 values (4, 4, 4, 4);
insert into tbl4 values (5, 5, 5, 5);
insert into tbl4 values (6, 6, 6, 6);

select * from tbl4;

-- 만약에 테이블에 PK와 unique not null이 같이 있는 경우 어떻게 될끼?
-- 결론적으로 얘기하자면, PK가 클러스터형 인덱스가 되고,
-- nuique not null은 보조 인덱스가 되는 것이다.
drop table if exists tbl5;
create table tbl5(
	-- PK가 없다면 당연히 a가 클러스터형 인덱스가 되지만,
    -- 여기서는 d 필드가 PK이기 때문에 보조 인덱스가 된다.
	a int unique not null,
    b int unique,
    c int unique,
    -- 항상 PK가 클러스터형 인덱스가 된다는 것을 기억을 하자.
    d int primary key
);

show index from tbl5;

select * from usertbl;

alter table usertbl
	drop primary key;

insert into usertbl values('AAA', '아아아', 1988, '한국', null, null, 190, '20101010');
-- 위에 PK를 삭제를 하고 나서 아래와 같이 데이터를 추가해보니, 
-- userid별로 정렬이 안이루어짐을 확인할 수가 있다.
select * from usertbl; -- AAA가 맨 마지막에 나옴

-- username을 기본키로 설정하기
alter table usertbl
add constraint pk_username primary key(username);

-- 조회를 해보면, username의 가나다.... 순으로 자동 정렬이 된 것을 볼수가 있다.
-- username이 영어사전의 단어라고 생각하면 된다.
-- 근데, 이런 작업은 현업에서는 절대 하지 않는다.
-- PK를 드랍하고 추가하는 것은 현업에서는 가히 상상할 수도 없는 것이다.
select * from usertbl; 

