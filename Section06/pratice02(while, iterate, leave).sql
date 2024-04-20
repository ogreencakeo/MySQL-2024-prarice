-- while(반복문), iterate(continue문과 동일), leave(반복문을 빠져나가는 break와 동일)

-- 1~100까지의 합을 구해보는 코드를 만들어보자.
drop procedure if exists whilePorc;
delimiter //
create procedure whilePorc()
begin
	declare i int;
    declare sum int;
    
    set i = 1;
    set sum = 0;
    
    while(i <= 100) do
		set sum = sum + i;
        set i = i + 1;
	end while;
    
    select concat('1~100까지의 합 : ', sum);
end // 
delimiter ;

call whilePorc();

-- 이제는 합계를 구하는데, 7의 배수를 제외하고 1000을 초과하면 그만 반복문을
-- 빠져 나가는 코드를 작성해보자.
drop procedure if exists whilePorc2;
delimiter //
	create procedure whilePorc2()
    begin
		declare i int;
        declare sum int;
        
        set i = 0;
        set sum = 0;
        
        mywhile : while(i <= 100) do
				if((i % 7) = 0) then
					set i = i+1;
					iterate mywhile;
				end if;
				set sum = sum + i;
				if(sum > 1000) then
					leave mywhile;
				end if;
				set i = i + 1;
			end while;
            select sum as '7의 배수 제외 100이하 합계';
    end //
delimiter ;

call whilePorc2();

-- 구구단 출력하기
drop procedure if exists gugudanProc;
delimiter //
	create procedure gugudanProc()
    begin
		declare i int;
        declare j int;
        
        set i = 2;
        set j = 1;
        
        while(j<=9) do
			select concat(i, '*', j, '=', (i*j));
            set j = j + 1;
		end while;
    end // 
delimiter ;

call gugudanProc();
