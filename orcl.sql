--�������û�
create user cdk IDENTIFIED by root;

--���½��û���sessionȨ��
grant create session to cdk;

--��cdk�û�����ѯtb_usre���Ȩ��
grant select on tb_user to cdk;
grant update(orderName) on tb_order to cdk;
grant select on tb_order_view to cdk;

--����Ȩ��
revoke select on tb_order_view from cdk;
revoke select on tb_user from cdk;

alter user cdk account unlock;

create table tb_user(
       id number(10) primary key,
       usreName varchar2(20) not null
)

create table tb_order(
       id number primary key,
       orderName varchar2(20) not null,
       price number(6,2) not null,
       buy_time date not null,
       user_id number(10) not null,
       constraint ck_price1 check(price>0),
       constraint fk_user_id foreign key(user_id) references tb_user(id)
)

--��������ʹ���Ӳ�ѯ���ὫԼ������
create table AA(id,orderName,price,buy_time,user_id) as 
select id,orderName,price,buy_time,user_id from tb_order

insert into tb_user(id,usreName) values (1,'����');
insert into tb_order values(1,'�ֻ�',1999,'17-6��-20',1);
--���Բ���ɹ�����Ϊû�����Լ��
insert into AA values(1,'�ֻ�',1999,'17-6��-20',3);

--Ϊ��������
alter table tb_user add age number;

--�޸���
alter table tb_user modify age number(2);

--ɾ����
alter table tb_user drop column age;

--������ͼ
create view tb_order_view
as
select orderName from tb_order

--��������
create sequence tb_user_id_seq
start with 1
increment by 1

--�鿴��ǰ����ֵ
select tb_user_id_seq.nextval from dual;
select tb_user_id_seq.currval from dual;

select * from tb_user;
insert into tb_user values(tb_user_id_seq.nextval,'��ɺ');
insert into tb_user values(tb_user_id_seq.nextval,'����');

--�޸�����
alter sequence tb_user_id_seq
increment by 2

--ɾ������
drop sequence tb_user_id_seq

select * from tb_order;

--������ͼ
create view tb_order_view(��Ʒ��,����)
as
select ordername,price from tb_order;

--ǿ�ƴ�����ͼ
create force view bb
as
select * from aa;

--ɾ����ͼ
drop view tb_order_view;
drop view bb;

--�鿴��ͼ
select * from tb_order_view;



--T4

select * from tb_shop;
select * from tb_shoptype;
delete from tb_shoptype where id>2;

create sequence tb_shopType_id
start with 3
increment by 1

drop sequence tb_shopType_id

/*
pl/sql��
dbms_output.put_line:��ӡ���
\\:ƴ���ַ���
*/
declare
pri number;--�������
begin
  select price into pri from tb_shop where shopid=&shopId;--&shopId�Զ�������
  --�������
  dbms_output.put_line('���ۣ�'||pri);
  exception--�쳣
    when no_data_found then
      dbms_output.put_line('δ��ȡ��Ʒ');
end;

--:=����ֵ�����
declare
num1 number :=3;
num2 number :=5;
num3 number;
begin
  num3:=num1+num2;
  dbms_output.put_line('num3='||num3);
end;

--%type����ο�ĳһ�е���������
declare
pri tb_shop.price%type;
begin
  select price into pri from tb_shop where shopid=&shopId;--&shopId�Զ�������
  --�������
  dbms_output.put_line('���ۣ�'||pri);
  exception--�쳣
    when no_data_found then
      dbms_output.put_line('δ��ȡ��Ʒ');
end;

--%rowtype����ο�һ�е���������
declare
shop tb_shop%rowtype;
begin
  select * into shop from tb_shop where shopid=&shopId;--&shopId�Զ�������
  --�������
  dbms_output.put_line('���ۣ�'||shop.price);
  exception--�쳣
    when no_data_found then
      dbms_output.put_line('δ��ȡ��Ʒ');
end;

--������������(�ο�ĳ���е�)
declare
type price_name is record
(
     pri tb_shop.price%type,
     tname tb_shop.shopname%type
);
para price_name;
begin
  select price,shopname into para from tb_shop where shopid=&shopId;
   dbms_output.put_line('��Ʒ����'||para.tname);
   dbms_output.put_line('���ۣ�'||para.pri);
end;

--һά������ʽ[shopName1,shopName2...]
declare
type a_table is table of tb_shop.shopname%type index by binary_integer;
c a_table;
begin
  select tb.shopname into c(0) from tb_shop tb where tb.id=&b;
  dbms_output.put_line('��Ʒ����'||c(0));
end;

--��ά������ʽ[shop1[id,name,price],shop2[...]]
declare
type a_table is table of tb_shop%rowtype index by binary_integer;
c a_table;
begin
  select * into c(0) from tb_shop tb where tb.id=&b;
  dbms_output.put_line('��Ʒ����'||c(0).shopname);
end;

--varray����
declare
type a_varray is varray(4) of varchar2(10) ;--����
c a_varray:=a_varray(null,null,null,null);--����
begin
  c(1):='jack';--��ֵ['jack','tom','lucy','lily'],�±��1��ʼ
  c(2):='tom';
  c(3):='lucy';
  c(4):='lily';
  
  for i in 1..c.count loop--ѭ�����
    dbms_output.put_line('name='||c(i));
  end loop;
end;

--������֧���if else
declare
price tb_shop.price%type;
begin
  select tb.price into price from tb_shop tb where tb.id=&id;
  if price>3500 then
    dbms_output.put_line('̫����...');
  else
    dbms_output.put_line('���Կ���...');
  end if;
end;

--������֧���
declare
luck number(1);
begin
  luck := floor(dbms_random.value(1,9));--ȡ�����1-9,������9
  dbms_output.put_line(luck);
  case luck
    when 8 then
      dbms_output.put_line('һ�Ƚ�');
    when 7 then
      dbms_output.put_line('���Ƚ�');
    when 6 then
      dbms_output.put_line('���Ƚ�');
    else
      dbms_output.put_line('лл�ݹˡ�����');
   end case;
end;

--loopѭ��
declare
type a_varray is varray(4) of varchar2(50);
b a_varray:=a_varray('����','�߲�','ˮ��','���');
num number(1):=1;
c number(1);--���������
begin
  loop --ѭ����ʼ
    c:=floor(dbms_random.value(1,5));
    if num=5 then
      exit;--ѭ���˳�
    end if;
    insert into tb_shoptype values(tb_shopType_id.nextval,b(c));
    commit;--�ֶ��ύ����
    num:=num+1;--�ı�ѭ������
  end loop;--ѭ������
end;

--whileѭ��
declare
type a_varray is varray(4) of varchar2(50);
b a_varray:=a_varray('����','�߲�','ˮ��','���');
num number(1):=1;
c number(1);--���������
begin
  while num<5 loop --ѭ����ʼ
    c:=floor(dbms_random.value(1,5));
    insert into tb_shoptype values(tb_shopType_id.nextval,b(c));
    commit;--�ֶ��ύ����
    num:=num+1;--�ı�ѭ������
  end loop;--ѭ������
end;

--forѭ��
declare
type a_varray is varray(4) of varchar2(50);
b a_varray:=a_varray('����','�߲�','ˮ��','���');
c number(1);
begin
  for i in 1..b.count loop --ѭ����ʼ
    c:=floor(dbms_random.value(1,5));
    insert into tb_shoptype values(tb_shopType_id.nextval,b(c));
    commit;--�ֶ��ύ����
  end loop;--ѭ������
end;


--�Զ����쳣
declare
e exception;--����һ���쳣����
begin
  update tb_shoptype tb set tb.typename=&name where tb.id=&id;
  if sql%notfound then 
    raise e;--�����Զ����쳣
  else
    dbms_output.put_line('�Ѹ���...');
  end if;
  --�쳣����
  exception
    when e then
      dbms_output.put_line('δ���ҵ�����Ʒ����...');
end;

--�д�
declare
begin
  create table aa(
       id number(10) primary key,
       usreName varchar2(20) not null
       )
end;

declare
sql_language varchar2(2000);
begin
  sql_language:='create table aa(
       id number(10) primary key,
       usreName varchar2(20) not null
       )';
  execute immediate sql_language;
end;

--�޲����޷��ؽ���Ķ�̬sql
declare
sql_language varchar2(100);
begin
  sql_language:='update tb_shop tb set tb.price=3500 where tb.id=001';
  execute immediate sql_language;
end;

--�в����޷��ؽ���Ķ�̬sql
declare
sql_language varchar2(100);
tb_price tb_shop.price%type;
begin
  sql_language:='update tb_shop tb set tb.price=2800 where tb.id=:aa';
  --using����ֵ
  execute immediate sql_language using 001;
end;

--�޲����з��ؽ���Ķ�̬sql
declare
sql_language varchar2(100);
tb_price tb_shop.price%type;
begin
  sql_language:='update tb_shop tb set tb.price=1800 where tb.id=002 returning tb.price into :aa';
  --returning into������շ���ֵ
  execute immediate sql_language returning into tb_price;
  dbms_output.put_line('�޸ĺ�ļ۸�'||tb_price);
end;

--�в����з��ؽ���Ķ�̬sql
declare
sql_language varchar2(100);
tb_price tb_shop.price%type;
begin
  sql_language:='update tb_shop tb set tb.price=3800 where tb.id=:bb returning tb.price into :aa';
  execute immediate sql_language using 002 returning into tb_price;
  dbms_output.put_line('�޸ĺ�ļ۸�'||tb_price);
end;

--���ض������ݵĶ�̬sql
declare
sql_language varchar2(100);
--����table����
type tb_shop_table is table of tb_shop.shopname%type index by binary_integer;
tb_shop_name tb_shop_table;
begin
  sql_language:='select tb.shopname from tb_shop tb';
  execute immediate sql_language bulk collect into tb_shop_name;
  --��������
  for i in 1..tb_shop_name.count loop
      dbms_output.put_line('��Ʒ����'||tb_shop_name(i));
  end loop;
end;

--�洢����
select * from tb_shop;
select * from tb_shoptype;
select * from tb_station;

--�����޲������޷���ֵ�Ĵ洢����
create procedure pro_test1
is
begin
  update tb_shop set price=1800 where shopid=002;
  commit;
end;

--�����в������޷���ֵ�Ĵ洢����
create procedure pro_test2(tb_id tb_shop.shopid%type)
is
begin
  update tb_shop set price=3800 where shopid=tb_id;
  commit;
end;

--�����޲������з���ֵ�Ĵ洢����
create procedure pro_test3(tb_price out tb_shop.price%type)
is
begin
  select tb.price into tb_price from tb_shop tb where shopid=002;
end;

--�����в������з���ֵ�Ĵ洢����
create or replace procedure pro_test4(tb_id tb_shoptype.id%type,tb_name out tb_shoptype.typename%type)
is
begin
  select tb.typename into tb_name from tb_shoptype tb where tb.id=tb_id;
end;

--������in out �Ĵ洢����
create or replace procedure pro_test5(num1 number,num2 in out number)
is
begin
  num2:=num2+num1;
end;

--ִ�д洢����
call pro_test1();
call pro_test2('001');

declare
tb_price tb_shop.price%type;
begin
  pro_test3(tb_price);
  dbms_output.put_line('����'||tb_price);
end;

declare
typeName tb_shoptype.typename%type;
begin
  pro_test4(1,typeName);
  dbms_output.put_line('����'||typeName);
end;

declare
num2 number := 3;
begin
  pro_test5(5,num2);
  dbms_output.put_line('num2='||num2);
end;

--������վ�Ĵ洢����
create or replace procedure bus_station(line_name tb_station.line_name%type,start_station_name tb_station.station_name%type,end_station_name tb_station.station_name%type)
is
type forder_table is table of tb_station.station_name%type index by binary_integer;
start_station_forder tb_station.forder%type;--���վ���
end_station_forder tb_station.forder%type;--�յ��վ���
station_names forder_table;--��Ų�ѯ������վ������
station_name varchar2(200);--վ����

begin
  --��ѯ���վ����Ӧ��վ����
  select st.forder into start_station_forder from tb_station st where st.line_name=line_name and st.station_name=start_station_name;
  
  --��ѯ�յ�վ����Ӧ��վ����
  select st.forder into end_station_forder from tb_station st where st.line_name=line_name and st.station_name=end_station_name;
  
  --��ѯ����վ����֮���վ����(����)
  if start_station_forder < end_station_forder then
     select st.station_name bulk collect into station_names from tb_station st where st.line_name=line_name and st.forder>=start_station_forder and st.forder<=end_station_forder order by st.forder ;
  else
     select st.station_name bulk collect into station_names from tb_station st where st.line_name=line_name and st.forder<=start_station_forder and st.forder>=end_station_forder order by st.forder desc;
  end if;
  
  --��������
  for i in 1..station_names.count loop
   station_name:=station_name||station_names(i)||'==>';
  end loop;
  
  --ȥ��ĩβ��==>
  station_name:=substr(station_name,0,length(station_name)-3);

  dbms_output.put_line('����������'||line_name||'·��������������վ�㣺'||station_name);
  
end;

--ִ�й����洢����
call bus_station('4','�����','۫��·��');
call bus_station('4','۫��·��','�����');

--�޲���������in������
create or replace function function_test1
return tb_station.station_name%type--������������
as
station_name tb_station.station_name%type;
begin
  select tb.station_name into station_name from tb_station tb where tb.forder=4; 
  return station_name;
end;

--�в�������in������
create or replace function function_test2(station_number tb_station.forder%type)
return tb_station.station_name%type--������������
as
station_name tb_station.station_name%type;
begin
  select tb.station_name into station_name from tb_station tb where tb.forder=station_number; 
  return station_name;
end;

--�вΣ���in������out�ĺ���
create or replace function function_test3(station_number tb_station.forder%type,station_line out tb_station.line_name%type)
return tb_station.station_name%type--������������
as
station_name tb_station.station_name%type;
begin
  select tb.station_name ,tb.line_name into station_name, station_line from tb_station tb where tb.forder=station_number; 
  return station_name;
end;

--�� in out�ĺ���
create or replace function function_test4(num1 number,num2 in out number)
return number--������������
as
num3 number;
begin
  num3:=num1+num2;
  num2:=num2+5;
  return num3;
end;

--ִ�к���
declare
station_name tb_station.station_name%type;
begin
  station_name:=function_test1();
  dbms_output.put_line('վ������'||station_name);
end;

declare
station_name tb_station.station_name%type;
begin
  station_name:=function_test2(2);
  dbms_output.put_line('վ������'||station_name);
end;

declare
station_name tb_station.station_name%type;
station_line tb_station.line_name%type;
begin
  station_name:=function_test3(4,station_line);
  dbms_output.put_line('��·����'||station_line);
  dbms_output.put_line('վ������'||station_name);
end;

declare
num2 number:=4;
num3 number;
begin
  num3:=function_test4(3,num2);
  dbms_output.put_line('num2��'||num2);
  dbms_output.put_line('num3��'||num3);
end;

--������(�ﵽ����������ʽִ��)
--��������
create or replace trigger t_test
before --before/after ����ʱ��
update or insert or delete on t_user --�����¼�
--for each row
begin --��������
  dbms_output.put_line('������ִ��');
end;

create or replace trigger t_sal
before --before/after ����ʱ��
update of sal on t_user --�����¼�
for each row --�����д�����
  when (old.id=1) --���н�����������
begin --��������
  if :new.sal<=:old.sal then
    raise_application_error(-20888,'�ӵ������ʼӴ���');
  end if;
end;

select * from t_user;

insert into t_user(id,name,sal) values()

update t_user set sal = 7000 where id!=1;

--������
create table tb_student
(
       id number primary key,
       name varchar2(50),
       sal number
)

select * from tb_student;
drop table tb_student;
drop sequence t_user_seq;

--��������
create sequence t_user_seq
start with 1
increment by 1

--ʵ��id�����Ĵ�����
create or replace trigger t_id
before --ִ��ʱ�� before/after
insert on tb_student --ִ������
for each row --ָ��Ϊ�д�����
begin --ִ�����
  select t_user_seq.nextval into :new.id from dual;
end;


insert into tb_student(name,sal) values('jack',1000);
insert into tb_student(name,sal) values('tom',800);
insert into tb_student(name,sal) values('lily',900);


