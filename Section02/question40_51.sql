-- 문제40
-- emp테이블에서 담당 업무 유형별로 급여 최고액, 최저액, 총액 및 평균 급여 출력하시오.
select deptno, max(sal) as '급여 최고액', min(sal) as '최저액', sum(sal) as '총액', avg(sal) as '평균 급여'
  from emp
 group by deptno;

-- 문제41
-- emp테이블에서 직급별 명수 출력하세요.
select job, count(*)
  from emp
group by job;

-- 문제42
-- emp테이블에서 과장의 수 출력하세요.
select job, count(*)
  from emp
 where job = '과장';

-- 문제43
-- emp테이블에서 급여 최고액, 급여 최저액의 차액 출력하세요
select max(sal) - min(sal) as '최고액과 최저액의 차액'
  from emp;

-- 문제44
-- emp테이블에서 직급별 사원의 최저 급여를 내림차순 출력하세요.
select job, min(sal)
  from emp
group by job
order by min(sal) desc;

-- 문제45
-- emp테이블에서 부서별 사원수, 평균 급여를 부서별로 오름차순 출력하세요.
select deptno, count(*), avg(sal) as "평균급여"
	from emp
group by deptno
order by deptno asc;

-- 문제46
-- emp테이블에서 소속 부서별 최대급여와 최소급여 구하여 출력하시오.
select deptno, max(sal) as '최대급여', min(sal) as '최소급여'
	from emp
group by deptno;

-- 문제47
-- emp테이블에서 부서별 사원수와 커미션(comm)을 받는 사원들의 수를 출력하시오.
select deptno, count(*), count(comm) as '커미션'
	from emp
group by deptno;

-- 문제48
-- emp테이블에서 부서별 평균 급여가 500이상인 부서의 번호와 평균급여를 구하여 출력하시오.
select deptno, avg(sal) as '평균급여'
  from emp
group by deptno
having avg(sal) >= 500;

-- 문제49
-- emp테이블에서 부서별 최대급여가 500을 초과하는 부서에서 최대급여와 최소급여를 출력하시오.
select deptno, max(sal) as '최대급여', min(sal) as '최소급여'
  from emp
group by deptno
having max(sal) > 500;

-- 문제50
-- emp테이블에서 부서별 급여총액을 중간합계로 출력하고 사원전체에 대한 총합계를 출력하시오.
select deptno, sum(sal)
  from emp
group by deptno
with rollup;

-- 문제51
-- emp테이블에서 부서별 급여 총액을 구하되 부서 내 다시 직급별로 급여총액을 구하여 출력하시오 
select * from emp;
select deptno, job, sum(sal)
  from emp
group by deptno, job
with rollup;