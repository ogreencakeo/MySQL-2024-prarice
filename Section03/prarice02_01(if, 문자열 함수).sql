use sqldb;

-- if함수는 '만약에 ~~이라면' 이라는 뜻이다. 즉, 1000 > 2000 수식의 결과가
-- 참이면 두 번째 인자값을 출력하고, 거짓이면 세 번째 인자값을 출력한다.
select if(1000 > 2000, '참입니다', '거짓입니다.');

-- ifnull은 첫 번째 인자값에 따라 널이면 두 번째 인자값이 출력되고,
-- 첫 번째 인자값이 널이 아니면, 1번째 인자 값을 출력한다.
select ifnull(null, '널이군요'), ifnull(1000, '널이군요');

-- nullif는 두 개의 인자값이 같으면 널을 리턴하고,
-- 두 개의 인자값이 다르면 첫 번째 인자값을 출력한다.
select nullif(1000, 1000), nullif(1000, 2000);

-- 프로그래밍 언어에서 switch 구문과 유사한다.
-- case는 함수가 아니라 연산자라고 이해를 해야한다.
-- case ... when ... then ... else ... end 형태가 문법이니까 알아두자.
select case 10
	when 1 then '일'
    when 5 then '오'
    when 10 then '십'
    else '해당되는 값이 없음'
end;

-- 문자열 함수
-- ascii 함수는 인자의 값을 아스키 코드 값으로 출력한다.
-- char 함수는 숫자로 준 내용을 문자로 나타낸다.
select ascii('A'), char(97);

-- -mySQL의 문자셋은 utf-8을 사용한다.
-- utf-8인 경우 영문은 1바이트, 한글은 3바이트로 사용이 된다.
-- bit_length()는 주어진 문자열의 바이트 수 * 8을 해서 비트 수를 리턴하는 함수
select bit_length('가나다'), bit_length('abc');

-- char_length()는 문자열의 문자의 수를 출력한다.
select char_length('가나다'), char_length('abc');

-- length()는 인자값의 바이트 수를 출력한다.
select length('안녕하세요!');

-- 문자열을 연결해주는 함수가 concat()이다.
select concat(100, '은 ', '100과 같다.');

-- concat_ws()는 첫번째 주어진 구분자로 문자열을 서로 연결해주는 함수이다.
select concat_ws('-', 24, '04', '09');

-- elt 함수는 첫 번째 주어진 값의 위치로 가서 있는 것을 출력한다.
select elt(2, '일이삼'); -- null
select elt(2, '일',' 이', '삼'); -- 이

-- field 함수는 첫 번째 주어진 값의 위치를 출력한다.
-- 찾는 값이 없으면 0을 리턴한다.
select field('이','일','이', '삼'); -- 이
select field('오','일','이', '삼'); -- 0
select field('이','일이삼'); -- 0

-- find_in_set 함수는 첫 번째 주어진 값의 구분자를 가지고 문자열의 문자 위치를 출력한다.
-- 찾는 값이 없으면 0을 리턴한다.
select find_in_set('이','일이삼'); -- 0
select find_in_set('이','일,이,삼'); -- 2

-- instr 함수는 첫 번째 문자열 값에서 두번째 값이 있으면 그 위치를 출력한다.
-- 찾는 값이 없으면 0을 리턴한다.
select instr('일이삼사', '삼'); -- 3
-- locate함수는 인자값의 위치만 다를 뿐 instr()와 동일하다.
select locate('삼', '일이삼사');

-- format()은 엑셀의 round()와 유사하다. 소수점 자리를 지정해서 반올림을 해준다.
-- 1000단위도 구분해줌
select format(7777.11111, 3);
select format(7777.11151, 3);

-- 2진수, 16진수, 8진수로 변환해주는 함수
select bin(10), hex(30), oct(10);

-- insert 함수는 replace 개념이 같다. 2번째 자리부터 3자리를 ??? 대치해달라.
select insert('11111', 2, 3, '???');

-- left함수는 왼쪽에서 3자, right는 오른쪽에서 3자를 출력한다.
select left('가나다라마', 3), right('가나다라마', 3);

-- 대소문자로 변환을 해주는 함수 4가지가 있다. 원하는 함수를 사용하면 된다.
select lower('ABCabc'), upper('ABCabc');
select ucase('ABCacb'), lcase('ABCacb');

-- 공백을 제거해주는 함수, 왼쪽 공백 제거(ltrim), 오른쪽 공백 제거(rtrim)
select ltrim('   데이터   '), rtrim('   데이터   ');

-- trim함수는 양쪽 공백을 제거한다. 하지만, 중간의 공백은 제거하지 못한다.
select trim('   데이터 베이스   ');

-- repeat 함수는 인자값을 반복해준다.
select repeat('안녕하세요', 5);

-- replace() : 문자열 치환 함수이다.
select replace('MySQL 학습', 'MySQL', '데이터');

-- reverse() : 주어진 인자값을 거꾸로 출력을 한다.
select reverse("대한민국");

-- space() : 공백을 만들어준다.
select concat('나의', space(50), '데이터 베이스');

-- substring() : 문자열을 잘라내서 출력한다.
select substring("데이터베이스", 4, 3);

-- substring_index() : 구분자 .을 기준으로하여 두 번째 이후는 출력하지 않는다.
-- -2를 주었을 때는 오른쪽부터 시작해서 2번째 이후는 출력하지 않는다.
select substring_index("데이터베이스/my/sql", '/', 2);
select substring_index("데이터베이스/my/sql", '/', -2);
