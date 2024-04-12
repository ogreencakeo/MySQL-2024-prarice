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
-- C:\ProgramData\MySQL\MySQL Server 8.0\my.ini파일에 max_allow_packet부분이 기본적으로 
-- 4MB로 설정되어 있는 걸 확인할수 있다. 이것을 4096MB로 바꿔주면 된다.
-- 설정이 바뀌면 재부팅을 하는것이 원칙이나, cmd창을 관리자모드로 열고
-- net stop mysql을 치자. 그럼 mysql서버가 중지되고, net start mysql을 치면 서비스를 
-- 시작하여 적용이 된다.이제 아래코드를 치면 에러가 발생하지 아니한다.  
insert into maxtbl values(repeat('A', 10000000), repeat('김', 10000000));

-- 분명 4GB로 설정을 했음에도 불구하고 1GB로 max_allow_packet이 출력된다.
show variables like 'max%';
-- my.ini파일의 변경이 있다면, mysql서비스를 중단하고 재시작하는 행위가 필요하다.
show variables like 'secure%';

-- 테이블의 내용을 텍스트 파일 내보내기
select *
  from usertbl
  into outfile 'C:\\SQL\\Movies\\usertbl_copy.txt' character set utf8mb4
  fields terminated by ',' optionally enclosed by '"'
  escaped by '\\'
  lines terminated by '\n';
  
-- 테이블의 내용을 csv 파일 내보내기
select *
  from employees.employees
  into outfile 'C:\\SQL\\Movies\\employees_copy.csv' character set utf8mb4
  fields terminated by ',' optionally enclosed by '"'
  escaped by '\\'
  lines terminated by '\n';