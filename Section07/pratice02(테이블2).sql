use tabledb;

drop table if exists prodtbl;
-- 아래 테이블에서는 PK나 FK같은 제약조건을 주지 않았다.
create table prodtbl(
	prodCode char(3) not null,
	prodId char(4) not null,
    prodDate datetime not null,
    prodcur char(10) null
    -- constraint PK_pordtbl_prodcode_prodid primary key(prodcode, prodid)
);

select * from prodtbl;
show index from prodtbl;

insert into prodtbl values('AAA', '001', 20191010, '판매완료');
insert into prodtbl values('AAA', '002', 20191010, '매장진열');
insert into prodtbl values('BBB', '001', 20191012, '재고창고');
insert into prodtbl values('CCC', '001', 20191013, '판매완료');
insert into prodtbl values('CCC', '002', 20191014, '판매완료');

-- 위에서 입력한 데이터를 보면 PK로 설정할 컬럼이 없다.
-- 이럴때는 2개의 컬럼을 조합해서 PK만들면 될 것이다.
alter table prodtbl
add constraint PK_prodtbl_prodcode_prodid
primary key(prodCode, prodId);

-- 테이블 삭제
