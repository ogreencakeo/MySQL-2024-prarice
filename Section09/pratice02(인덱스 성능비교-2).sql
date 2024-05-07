use indexdb;
-- 현재 emp 테이블은 인덱스가 하나도 없다.
-- 그럼 select 문을 실행하면 풀테이블스캔을 할 수 밖에 없는 것이다.
-- execution plan에서 알수가 있다.
-- 여기서는 약 1000페이지 정도를 읽는 것으로 나올 것이다.
-- 1000페이지 = 쿼리 실행 후 읽은 페이지 수 - 쿼리 실행전 읽은 페이지 수

-- 쿼리 실행전의 읽은 페이지 수를 알아보는 명령어
-- 30995.90(query cost)
-- 1050 페이지를 읽었다.
show global status like 'innodb_pages_read';
select * from emp 
	where emp_no = '100000';
show global status like 'innodb_pages_read';

-- 클러스터형 인덱스가 존재하는 emp_c 테이블의 실행결과를 보면
-- 약 10페이지 읽었다. 가히 100배 이상 차이가 남는 것을 확인 할 수가 있다.
show global status like 'innodb_pages_read';
select * from emp_c 
	where emp_no = '100000';
show global status like 'innodb_pages_read';

-- 이번에는 보조인덱스가 있는 emp_se의 실행결과를 보자
-- 약 5 페이지를 읽었다.
show global status like 'innodb_pages_read';
select * from emp_se 
	where emp_no = '100000';
show global status like 'innodb_pages_read';

-- 이로써 인덱스가 있고 없고에 따라 DB의 성능이 엄청나게 차이가 나는 것을 
-- 알 수가 있다.

-- 이제는 범위 검색을 해보자.

-- 인덱스가 없는 emp를 실행하면 역시 풀테이블 스캔을 하여 약 1030페이지
-- 를 읽는 것을 알 수가 있다.
-- 30995.90(query cost)
show global status like 'innodb_pages_read';
select * from emp 
	where emp_no < 11000;
show global status like 'innodb_pages_read';

-- 읽은 페이지 수 : 7페이지
-- 201.93(query cost)
show global status like 'innodb_pages_read';
select * from emp_c 
	where emp_no < 11000;
show global status like 'innodb_pages_read';

-- 읽은 페이지 수 : 900페이지
-- 1055.94(query cost)
show global status like 'innodb_pages_read';
select * from emp_se
	where emp_no < 11000;
show global status like 'innodb_pages_read';

-- 위와 같이 확인해 본 결과 범위검색에서는 클러스터형 인덱스 단연 성능이
-- 훨씬 뛰어나다라는 사실을 확인해 볼 수가 있다.

-- 하지만, where 절이 없다면 어떨까?
-- where 절이 없으니 풀테이블 스캔을 하여 약 928페이지를 읽는 것을 알 수가 있다.
show global status like 'innodb_pages_read';
select * from emp_c; 
	-- where emp_no < 11000;
show global status like 'innodb_pages_read';

-- 보조 인덱스가 있는 emp_se의 실행결과는 1038페이지를 읽고
-- 풀테이블 스캔을 했다.
show global status like 'innodb_pages_read';
select * from emp_se; 
	-- where emp_no < 11000;
show global status like 'innodb_pages_read';

-- 하여 위의 결론은 범위 검색에서는 클러스터령 인덱스가 가장 성능이 좋다는 것을
-- 알 수가 있다.

-- 하지만, mysql이 알아서 검색해줄 수도 있다.
-- emp_se에는 분명 보조 인덱스가 있다. 하지만 실행 계획을 보면 아래 것은
-- 인덱스를 사용하지 않고 풀테이블 스캔을 했음을 알 수가 있다.
-- 하여, 보조 인덱스가 있으나 마나 하는 것이니 제거해주는 것이 좋다.
-- 인덱스 물리적 공간을 차지하고 있으니 말이다.
-- mysql이 인덱스를 사용할 것인지 풀테이블 스캔을 할 것인지는
-- 해당 테이블의 약 20프로 이상 스캔하는 경우는 인덱스를 사용하지 않는다.
-- 전체 데이터 검색을 한다면 차라리 인덱스가 없는 것이 낫다.

show global status like 'innodb_pages_read';
select * from emp_se 
	where emp_no < 400000
    limit 5000000;
show global status like 'innodb_pages_read';

show global status like 'innodb_pages_read';
select * from emp_c 
	where emp_no = 100000;
show global status like 'innodb_pages_read';

-- 데이터의 중복도(카디널러티)
select * 
	from emp;

alter table emp
	add index idx_gender(gender);

alter table emp
	add primary key pk_emp_empno(emp_no);

-- 테이블에 적용하기
analyze table emp;

-- idx_gender인덱스가 추가 된 것을 볼 수가 있다.
-- 여기서 유심히 살펴볼 항목은 바로 cardinality 항목이다.
-- 이 항목은 관계대수를 의미하는 것이다.
-- 즉, 다시말해 테이블간에 릴레이션을 구성하는 행의 갯수를 의미한다.
-- 수학에서는 집합을 구성하는 원소들의 개수를 말한다.
-- 하여, 1:1관계대수 다라고 함은 두 집합의 원소가 같다는 것을 의미한다.
-- 1:N은 1개의 행에 N개의 행이 연결되는 것이다.
-- 하여, cardinality가 낮을수록 데이터의 중복도가 엄청 높다는 것이고
-- 높을수록 데이터 중복도가 낮다는 것이다. (상당히 중요함)
-- idx_gender는 cardinality가 1이다. 왜? gender컬럼은 M, F로 2개 밖에
-- 형식이 없고 아울러 30만건에서 둘 중에 하나이니깐 중복도가 엄청난 것이다.
show index from emp;

select * from emp
	where gender = 'M'
    limit 500000;

select *
	from emp
    ignore index(idx_gender) -- 인덱스를 사용하지 않겠다라고 명시적으로 알니는 코드
    where gender = 'M'
    limit 500000;

-- 결론
-- 1. 인덱스는 열(컬럼) 단위에 생성되어야 한다.
-- 2. where 절에서 자주 사용되는 열에 인덱스를 만들어야 효율성이 좋다.
-- 3. 데이터의 중복도가 높은 열은 인덱스 만들어보아야 효과가 없다.
-- 4. 외래키 지정한 열의 경우는 자동으로 인덱스가 생성이 된다.
-- 5. join에 자주 사용되는 열의 경우는 인덱스를 생성해주자.
-- 6. 인덱스는 단지 읽기에서만 성능이 향상되므로 얼마나 데이터의 변경이 자주
-- 일어나는지를 고려를 반드시 해야한다.
-- 7. 클러스터형 인덱스는 테이블당 1개만 생성이 가능하다.
-- 8. 사용하지 않는 인덱스는 과감히 제거하자 (저장공간 확보 및 부하를 줄여준다.)