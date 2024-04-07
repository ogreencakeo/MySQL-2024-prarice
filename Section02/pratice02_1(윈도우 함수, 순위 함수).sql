use sqldb;

-- 순위 매기기 row_number() over()
-- 같은 키가 존재해도 순위를 정해버린다.
select row_number() over(order by height desc) as '키 순위', username, addr, height
	from usertbl;

-- 같은 키가 존재하면 이름으로 순위 정해보기
select row_number() over(order by height desc, username asc) as '키 순위',
	username, addr, height
from usertbl;

-- rank() over(), 일반적으로 가장 많이 사용되는 순위 함수
-- 같은 키가 존재하면 동일한 등수로 만들고, 동일한 등수의 수 만큼 띄우고 순위를 정하기
select rank() over(order by height desc) as '키 순위', username, addr, height
	from usertbl;

-- dense_rank() over()
-- 같은 키가 존재하면 동일한 등수로 만들고, 동일한 등수의 수 만큼 띄우지 않고 순위를 정하기
select dense_rank() over(order by height desc) as '키 순위', username, addr, height
	from usertbl;

-- over(partition by 컬럼명), 컬럼명에 따라서 그룹 지어서 그룹안에서 순위를 정함
select addr, username, height, 
	rank() over(partition by addr order by height desc) as '지역별 키 순위'
from usertbl;

-- ntile(정수), 해당하는 row개수에 그룹으로 나누어주는 함수
select ntile(2) over(order by height desc) as '반번호', username, addr, height
	from usertbl;

select ntile(3) over(order by height desc) as '반번호', username, addr, height
	from usertbl;

-- 분석 함수
-- lead(컬럼명, offset, default) : 현재 row를 기준으로 다음 행을 참조
-- lag(컬럼명, offset, default) : 현재 row를 기준으로 이전 행을 참조
select username, addr, height as '키',
	height - (lead(height, 2, 0) over(order by height desc)) as '다음 사람과 키 차이'
from usertbl;

select username, addr, height as '키',
	height - (lag(height, 2, 0) over(order by height desc)) as '다음 사람과 키 차이'
from usertbl;

-- 지역별 최대키와 차이
-- first_value(컬럼) : 정렬된 값 중에서 첫 번째 값을 의미한다.
-- last_value(컬럼) : 정렬된 값 중에서 맨 마지막 값을 의미한다.
select addr, username, height as '키',
	height - (first_value(height) over (partition by addr order by height desc))
    as '지역별 최대키와 차이'
from usertbl;

-- last_value() 사용할 때는 over절에 rows between unbounded preceding and unbounded following
-- 정렬결과의 처음과 끝을 대상으로 함.
select addr, username, height as '키',
	height - (last_value(height) over (partition by addr order by height desc 
			rows between unbounded preceding and unbounded following))
    as '지역별 최소키와의 차이'
from usertbl;

-- 누적 백분율 함수 cume_dist() : 0~1 사이를 리턴을 해준다.
select addr, username, height as '키',
	(cume_dist() over (partition by addr order by height desc)) * 100 
    as '누적인원 백분율'
from usertbl;

