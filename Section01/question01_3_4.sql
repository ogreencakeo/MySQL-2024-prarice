-- 문제 3
USE MYDB;
DROP TABLE EMP;
Delete from emp;
SELECT * FROM EMP;

-- 추출된 데이터를 엑셀 데이터로 내보내기를 하기 위해서 export 클릭을 하면
-- .csv 내보내기를 하고 아래 2가지 방법을 이용하여 글자 깨짐을 방지토록 한다.
-- 1. 엑셀 프로그램을 열고 데이터 - 텍스트를 클랙해서 가져올 데이터 CSV 파일을 가져오면
-- 형식이 뜨는데 UTF-8로 설정후 다음을 누르면 쉼표로 구분을 해주면 된다.
-- 2. 저장된 .CSV 파일을 메모장으로 열어서 다른 이름으로 저장을 할 때, 인코딩을 ANSI로 설정후 저장을 하고 엑셀로 열면 된다.

-- 엑셀 데이터를 데이블로 가져오기 (import)를 하고자 한다면, MySQL은 UTF-8 형태로 지원 
-- csv 파일로 가져올 때는 반드시 UTF-8로 맞춰 글자 깨짐 현상이 없다.

CREATE TABLE EMP(
	deptNO INT NOT NULL,
    deptName char(10),
    job char(5),
    sal int,
    primary key (deptNo)
);

Insert into Emp Values(10, '인사팀', '사원', 250),
	(20, '재무팀', '대리', 300),
	(30, '법무팀', '과장', 350),
	(40, '영업팀', '사원', 250),
	(50, '설계팀', '부장', 500);

-- EMP 테이블에서 JOB이 '사원'들만 SAL을 180으로 고치시오.
update emp 
	set sal = 180
where job = '사원';

-- EMP 테이블에서 '법무팀'을 삭제하시오.
delete from emp
where deptno = 30;
