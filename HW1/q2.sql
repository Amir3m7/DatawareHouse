CREATE TABLE trn_src_des
(
    VoucherId varchar(21) NULL,
    TrnDate   date        NULL,
    TrnTime   varchar(8)  NULL,
    Amount    bigint      NULL,
    SourceDep int         NULL,
    DesDep   int         NULL
);



create table final(
    VoucherId varchar(21) NULL,
    TrnDate   date        NULL,
    TrnTime   varchar(8)  NULL,
    Amount    bigint      NULL,
    SourceDep int         NULL,
    DesDep   int         NULL
);


create table temp(
    VoucherId varchar(21) NULL,
    TrnDate   date        NULL,
    TrnTime   varchar(8)  NULL,
    Amount    bigint      NULL,
    SourceDep int         NULL,
    DesDep   int         NULL
);

INSERT INTO Trn_src_des(voucherid, TrnDate, TrnTime, Amount, SourceDep, DesDep)
VALUES 
('1', '2024-03-11', '09:00:00', 1000, 101, 102),
('2', '2024-03-11', '09:00:00', 1000, 101, 102),
('3', '2024-03-12', '09:30:00', 2000, 103, null),
('4', '2024-03-12', '09:45:00', 2500, null, 105),
('5', '2024-03-20', '10:00:00', 3000, 105, 106),
('6', '2024-03-20', '10:00:00', 3000, 105, 106),
('7', '2024-03-18', '10:30:00', 4000, 107, 108),
('8', '2024-03-18', '10:45:00', 4500, 108, 109),
('9', '2024-03-27', '11:00:00', 5000, 109, 110),
('10', '2024-03-27', '11:15:00', 5500, 110, 111);

create or replace procedure concat()
language plpgsql
as $$
declare currentDate date;
    end_date date;
    minimum_date date;
begin
  SELECT MIN(trnDate) INTO minimum_date FROM trn_src_des;
  SELECT MAX(trnDate) INTO end_date FROM trn_src_des;  
  select max(trndate) + interval '1 day' into currentDate from final;
  if currentDate is null then currentDate=minimum_date;
  end if ;
  
  
  while currentDate <=end_date loop
    truncate table temp;
    
    insert into temp select voucherid, TrnDate, TrnTime, Amount, SourceDep, DesDep
    from trn_src_des where trnDate=currentDate;
    
    insert into final 
      	select string_agg(voucherId,'|')as voucherid,TrnDate, TrnTime, Amount, SourceDep, DesDep
		from temp
		group by TrnDate, TrnTime, Amount, SourceDep, DesDep;
        
        delete from trn_src_des where trndate=currentdate;
        currentdate= currentdate +interval '1 day';		
	commit;
  end loop;    
end;
$$;

call concat();

select * from final order by voucherid
select * from trn_src_des