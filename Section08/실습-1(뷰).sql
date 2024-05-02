-- Section05 초기화 코드
use sqldb;

-- 아래 코드는 view를 만드는 쿼리이다. 설명을 하자면 v_userbuytbl을
-- 만드는데 select문의 내용을 view로 만들겠다라는 것이다.
-- 매번 아래와 같이 조회를 하게 되면 지속적으로 쿼리를 길게 쳐야될 것이다.
-- 한 번 만들고 view를 적절히 잘 활용을 하면 될 것이다.
create view v_userbuytbl
as
	select U.userid as 'USER_ID', U.username as 'USER_NAME',
    B.prodname as 'PROD_NAME', U.addr as '주소',
    concat(U.mobile1, U.mobile2) as 'Mobile_Phone'
    from usertbl U
    inner join buytbl B
    on U.userid = B.userid;

select *
	from v_userbuytbl;