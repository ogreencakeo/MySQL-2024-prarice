-- Section05 초기화 코드
use sqldb;

-- 아래 코드는 view를 만드는 쿼리이다. 설명을 하자면 v_userbuytbl을
-- 만드는데 select문의 내용을 view로 만들겠다라는 것이다.

create view v_userbuytbl
as
	select U.userid as 'USER_ID', U.username as 'USER_NAME',
    B.prodname as 'PROD_NAME', U.addr as '주소',
    concat(U.mobile1, U.mobile2) as 'Mobile_Phone'
    from usertbl U
    inner join buytbl B
    on U.userid = B.userid;