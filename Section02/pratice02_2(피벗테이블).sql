-- 간단한 피벗 테이블 만들기
use sqldb;
drop table if exists pivot;
create table pivot(
	uname varchar(10),
    season varchar(5),
    amount int
);

insert into pivot values
('김범수','겨울',10),('윤종신','여름',15),
('김범수','가을',25),('김범수','봄',5),
('김범수','봄',37),('윤종신','겨울',40),
('김범수','여름',14),('김범수','겨울',22),
('김범수','겨울',22),('윤종신','여름',64);

select * from pivot;

-- 피벗 테이블을 만드는 첫 번째 방법 (sum(), case when ... then ... end)
select uname, 
	sum(case when season = '봄' then amount end) as '봄',
	sum(case when season = '여름' then amount end) as '여름',
    sum(case when season = '가을' then amount end) as '가을',
    sum(case when season = '겨울' then amount end) as '겨울'
from pivot
group by uname;

-- 피벗 테이블을 만드는 두 번째 방법 (sum(), if())
select uname, 
	-- 만약에 season이 봄이면 amount을 sum을 해라
	sum(if(season = '봄', amount, 0 )) as '봄',
	sum(if(season = '여름', amount, 0 )) as '여름',
    sum(if(season = '가을', amount, 0 )) as '가을',
    sum(if(season = '겨울', amount, 0 )) as '겨울'
from pivot
group by uname;

select season,
	sum(if(uname = '김범수', amount, 0)) as '김범수',
    sum(if(uname = '윤종신', amount, 0)) as '운종신',
    sum(amount) as '합계'
from pivot
group by season
order by sum(amount) desc;

