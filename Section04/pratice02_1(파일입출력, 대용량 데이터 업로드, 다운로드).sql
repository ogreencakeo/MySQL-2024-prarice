use sqldb;

-- 대용량 데이터 삽입해보기
-- 필드의 데이터 타입이 longtext이다.
-- longtext는 4GB만큼 text데이터를 넣을 수 있다.
drop table if exists maxtbl;
create table maxtbl(
	col1 longtext,
    col2 longtext
);

desc maxtbl;

-- 'A'문자는 1바이트이고, '김'이라는 한글은 3바이트이다.
-- 10만번을 반복해서 컬럼에다가 각각 대입한 것이다.
insert into maxtbl values(repeat('A', 100000), repeat('김', 100000));
select * 
	from maxtbl;

select length(col1), length(col2) -- col1은 약 0.95MB, col2는 약 0.28MB
	from maxtbl;

-- 분명히 longtext는 4GB 저장할 수 있다고 했는데, 1000만 바이트(9.5MB) 저장이 안된다고
-- 에러가 났다. 이 때는 mySQL에 대한 설정을 바꿔줘야 한다.
insert into maxtbl values(repeat('A', 10000000), repeat('김', 10000000));

-- 분명 4GB로 설정을 했음에도 불구하고 1GB로 max_allow_packet이 출력된다.
show variables like 'max%';

show variables like 'secure%';