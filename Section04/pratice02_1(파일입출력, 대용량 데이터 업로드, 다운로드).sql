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
  
-- 외부의 데이터를 가져와보자. 먼저 테이블을 생성하도록 하자.
drop table if exists membertbl;
-- like를 활용하면 테이블의 구조뿐만 아니라 제약조건까지 다 복사해온다.
create table membertbl like usertbl;

desc membertbl;

truncate membertbl;

select *
	from membertbl;

-- 외부 텍스트 파일을 테이블로 읽어들이기
load data infile 'C:\\SQL\\Movies\\usertbl_copy.txt'
	into table membertbl character set utf8mb4
fields terminated by ','
enclosed by '"'
lines terminated by '\n';
-- ignore 1 rows; -- 제목줄이 있을대 1행을 무시하고 테이블에 행을 저장해라.

-- 엑셀 파일을 읽어들이기 위한 테이블 생성
drop table if exists employees_text;

create table employees_text like employees.employees;
desc employees_text;

select *
	from employees_text;

-- 외부 엑셀 파일을 테이블에 읽어들이기
load data infile 'C:\\SQL\\Movies\\employees_copy.csv'
	into table employees_text character set utf8mb4
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows; -- 제목줄이 있을대 1행을 무시하고 테이블에 행을 저장해라.

-- 위에서 파일을 내보내고, 테이블로 읽어들이기 등 정말 중요하다. (현업 사용이 많음)
-- 명령어를 반드시 기억을 했으면 좋다.

drop database moviedb;
create database moviedb;

use moviedb;

drop table if exists movietbl;
-- 동영상(바이너리 파일)과 시나리오를 저장하기 위한 테이블을 생성함
create table movietbl(
	movie_id int auto_increment primary key,
    movie_title varchar(30),
    movie_director varchar(20),
    movie_star varchar(20),
    movie_script longtext,
    movie_film longblob
) default charset=utf8mb4;

desc movietbl;

-- 쿼리를 날린 후에, Lost Connection to MySQL Server during query 에러가 뜰 때가 있다.
-- 이 에러를 해결하기 위해서는 Editor -> SQL Editor -> DBMS connection read time out의 값에
-- 3,600초(1시간)를 설정을 해주면 에러가 해결 될 것이다.

-- 텍스트 파일, 동영상
insert into movietbl values (null, 'mysql1', 'oracle1', '대표1', 
	load_file('C:\\SQL\\Movies\\Mohikan.txt'), load_file('C:\\SQL\\Movies\\test.mp4'));

-- 텍스트 파일, 한글파일(.docx) 를 테이블에 저장
insert into movietbl values (null, 'mysql1', 'oracle1', '대표1', 
	load_file('C:\\SQL\\Movies\\Mohikan.txt'), load_file('C:\\SQL\\Movies\\dbms.docx'));

-- 텍스트 파일, 엑셀파일(.csv) 를 테이블에 저장
insert into movietbl values (null, 'mysql1', 'oracle1', '대표1', 
	load_file('C:\\SQL\\Movies\\Mohikan.txt'), load_file('C:\\SQL\\Movies\\employees_copy.csv'));

-- 아래와 같이 한글로 된 파일명을 주면 테이블에 저장이 되지 않으므로 영문으로 이름을
-- 바꿔서 업로드 하도록 하자.
select *
	from movietbl;