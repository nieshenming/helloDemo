--创建新用户
create user cdk IDENTIFIED by root;

--给新建用户付session权限
grant create session to cdk;

--给cdk用户付查询tb_usre表的权限
grant select on tb_user to cdk;
grant update(orderName) on tb_order to cdk;
grant select on tb_order_view to cdk;

--撤销权限
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

--创建表中使用子查询不会将约束带上
create table AA(id,orderName,price,buy_time,user_id) as 
select id,orderName,price,buy_time,user_id from tb_order

insert into tb_user(id,usreName) values (1,'刘秀');
insert into tb_order values(1,'手机',1999,'17-6月-20',1);
--可以插入成功，因为没有外键约束
insert into AA values(1,'手机',1999,'17-6月-20',3);

--为表新增列
alter table tb_user add age number;

--修改列
alter table tb_user modify age number(2);

--删除列
alter table tb_user drop column age;

--创建视图
create view tb_order_view
as
select orderName from tb_order

--创建序列
create sequence tb_user_id_seq
start with 1
increment by 1

--查看当前序列值
select tb_user_id_seq.nextval from dual;
select tb_user_id_seq.currval from dual;

select * from tb_user;
insert into tb_user values(tb_user_id_seq.nextval,'张珊');
insert into tb_user values(tb_user_id_seq.nextval,'李四');

--修改序列
alter sequence tb_user_id_seq
increment by 2

--删除序列
drop sequence tb_user_id_seq

select * from tb_order;

--创建视图
create view tb_order_view(商品名,单价)
as
select ordername,price from tb_order;

--强制创建视图
create force view bb
as
select * from aa;

--删除视图
drop view tb_order_view;
drop view bb;

--查看视图
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
pl/sql块
dbms_output.put_line:打印输出
\\:拼接字符串
*/
declare
pri number;--定义变量
begin
  select price into pri from tb_shop where shopid=&shopId;--&shopId自定义输入
  --输出内容
  dbms_output.put_line('单价：'||pri);
  exception--异常
    when no_data_found then
      dbms_output.put_line('未获取商品');
end;

--:=：赋值运算符
declare
num1 number :=3;
num2 number :=5;
num3 number;
begin
  num3:=num1+num2;
  dbms_output.put_line('num3='||num3);
end;

--%type代表参考某一列的数据类型
declare
pri tb_shop.price%type;
begin
  select price into pri from tb_shop where shopid=&shopId;--&shopId自定义输入
  --输出内容
  dbms_output.put_line('单价：'||pri);
  exception--异常
    when no_data_found then
      dbms_output.put_line('未获取商品');
end;

--%rowtype代表参考一行的数据类型
declare
shop tb_shop%rowtype;
begin
  select * into shop from tb_shop where shopid=&shopId;--&shopId自定义输入
  --输出内容
  dbms_output.put_line('单价：'||shop.price);
  exception--异常
    when no_data_found then
      dbms_output.put_line('未获取商品');
end;

--定义数据类型(参考某几列的)
declare
type price_name is record
(
     pri tb_shop.price%type,
     tname tb_shop.shopname%type
);
para price_name;
begin
  select price,shopname into para from tb_shop where shopid=&shopId;
   dbms_output.put_line('商品名：'||para.tname);
   dbms_output.put_line('单价：'||para.pri);
end;

--一维数组形式[shopName1,shopName2...]
declare
type a_table is table of tb_shop.shopname%type index by binary_integer;
c a_table;
begin
  select tb.shopname into c(0) from tb_shop tb where tb.id=&b;
  dbms_output.put_line('商品名：'||c(0));
end;

--二维数组形式[shop1[id,name,price],shop2[...]]
declare
type a_table is table of tb_shop%rowtype index by binary_integer;
c a_table;
begin
  select * into c(0) from tb_shop tb where tb.id=&b;
  dbms_output.put_line('商品名：'||c(0).shopname);
end;

--varray类型
declare
type a_varray is varray(4) of varchar2(10) ;--定义
c a_varray:=a_varray(null,null,null,null);--声明
begin
  c(1):='jack';--赋值['jack','tom','lucy','lily'],下标从1开始
  c(2):='tom';
  c(3):='lucy';
  c(4):='lily';
  
  for i in 1..c.count loop--循环输出
    dbms_output.put_line('name='||c(i));
  end loop;
end;

--条件分支语句if else
declare
price tb_shop.price%type;
begin
  select tb.price into price from tb_shop tb where tb.id=&id;
  if price>3500 then
    dbms_output.put_line('太贵了...');
  else
    dbms_output.put_line('可以考虑...');
  end if;
end;

--条件分支语句
declare
luck number(1);
begin
  luck := floor(dbms_random.value(1,9));--取随机数1-9,不包含9
  dbms_output.put_line(luck);
  case luck
    when 8 then
      dbms_output.put_line('一等奖');
    when 7 then
      dbms_output.put_line('二等奖');
    when 6 then
      dbms_output.put_line('三等奖');
    else
      dbms_output.put_line('谢谢惠顾。。。');
   end case;
end;

--loop循环
declare
type a_varray is varray(4) of varchar2(50);
b a_varray:=a_varray('肉类','蔬菜','水果','玩具');
num number(1):=1;
c number(1);--接收随机数
begin
  loop --循环开始
    c:=floor(dbms_random.value(1,5));
    if num=5 then
      exit;--循环退出
    end if;
    insert into tb_shoptype values(tb_shopType_id.nextval,b(c));
    commit;--手动提交事物
    num:=num+1;--改变循环条件
  end loop;--循环结束
end;

--while循环
declare
type a_varray is varray(4) of varchar2(50);
b a_varray:=a_varray('肉类','蔬菜','水果','玩具');
num number(1):=1;
c number(1);--接收随机数
begin
  while num<5 loop --循环开始
    c:=floor(dbms_random.value(1,5));
    insert into tb_shoptype values(tb_shopType_id.nextval,b(c));
    commit;--手动提交事物
    num:=num+1;--改变循环条件
  end loop;--循环结束
end;

--for循环
declare
type a_varray is varray(4) of varchar2(50);
b a_varray:=a_varray('肉类','蔬菜','水果','玩具');
c number(1);
begin
  for i in 1..b.count loop --循环开始
    c:=floor(dbms_random.value(1,5));
    insert into tb_shoptype values(tb_shopType_id.nextval,b(c));
    commit;--手动提交事物
  end loop;--循环结束
end;


--自定义异常
declare
e exception;--定义一个异常类型
begin
  update tb_shoptype tb set tb.typename=&name where tb.id=&id;
  if sql%notfound then 
    raise e;--触发自定义异常
  else
    dbms_output.put_line('已更新...');
  end if;
  --异常部分
  exception
    when e then
      dbms_output.put_line('未查找到此商品类型...');
end;

--有错
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

--无参数无返回结果的动态sql
declare
sql_language varchar2(100);
begin
  sql_language:='update tb_shop tb set tb.price=3500 where tb.id=001';
  execute immediate sql_language;
end;

--有参数无返回结果的动态sql
declare
sql_language varchar2(100);
tb_price tb_shop.price%type;
begin
  sql_language:='update tb_shop tb set tb.price=2800 where tb.id=:aa';
  --using代表赋值
  execute immediate sql_language using 001;
end;

--无参数有返回结果的动态sql
declare
sql_language varchar2(100);
tb_price tb_shop.price%type;
begin
  sql_language:='update tb_shop tb set tb.price=1800 where tb.id=002 returning tb.price into :aa';
  --returning into代表接收返回值
  execute immediate sql_language returning into tb_price;
  dbms_output.put_line('修改后的价格：'||tb_price);
end;

--有参数有返回结果的动态sql
declare
sql_language varchar2(100);
tb_price tb_shop.price%type;
begin
  sql_language:='update tb_shop tb set tb.price=3800 where tb.id=:bb returning tb.price into :aa';
  execute immediate sql_language using 002 returning into tb_price;
  dbms_output.put_line('修改后的价格：'||tb_price);
end;

--返回多条数据的动态sql
declare
sql_language varchar2(100);
--创建table类型
type tb_shop_table is table of tb_shop.shopname%type index by binary_integer;
tb_shop_name tb_shop_table;
begin
  sql_language:='select tb.shopname from tb_shop tb';
  execute immediate sql_language bulk collect into tb_shop_name;
  --遍历集合
  for i in 1..tb_shop_name.count loop
      dbms_output.put_line('商品名：'||tb_shop_name(i));
  end loop;
end;

--存储过程
select * from tb_shop;
select * from tb_shoptype;
select * from tb_station;

--创建无参数，无返回值的存储过程
create procedure pro_test1
is
begin
  update tb_shop set price=1800 where shopid=002;
  commit;
end;

--创建有参数，无返回值的存储过程
create procedure pro_test2(tb_id tb_shop.shopid%type)
is
begin
  update tb_shop set price=3800 where shopid=tb_id;
  commit;
end;

--创建无参数，有返回值的存储过程
create procedure pro_test3(tb_price out tb_shop.price%type)
is
begin
  select tb.price into tb_price from tb_shop tb where shopid=002;
end;

--创建有参数，有返回值的存储过程
create or replace procedure pro_test4(tb_id tb_shoptype.id%type,tb_name out tb_shoptype.typename%type)
is
begin
  select tb.typename into tb_name from tb_shoptype tb where tb.id=tb_id;
end;

--创建带in out 的存储过程
create or replace procedure pro_test5(num1 number,num2 in out number)
is
begin
  num2:=num2+num1;
end;

--执行存储过程
call pro_test1();
call pro_test2('001');

declare
tb_price tb_shop.price%type;
begin
  pro_test3(tb_price);
  dbms_output.put_line('单价'||tb_price);
end;

declare
typeName tb_shoptype.typename%type;
begin
  pro_test4(1,typeName);
  dbms_output.put_line('名称'||typeName);
end;

declare
num2 number := 3;
begin
  pro_test5(5,num2);
  dbms_output.put_line('num2='||num2);
end;

--公交车站的存储过程
create or replace procedure bus_station(line_name tb_station.line_name%type,start_station_name tb_station.station_name%type,end_station_name tb_station.station_name%type)
is
type forder_table is table of tb_station.station_name%type index by binary_integer;
start_station_forder tb_station.forder%type;--起点站编号
end_station_forder tb_station.forder%type;--终点点站编号
station_names forder_table;--存放查询出来的站点名称
station_name varchar2(200);--站点名

begin
  --查询起点站所对应的站点编号
  select st.forder into start_station_forder from tb_station st where st.line_name=line_name and st.station_name=start_station_name;
  
  --查询终点站所对应的站点编号
  select st.forder into end_station_forder from tb_station st where st.line_name=line_name and st.station_name=end_station_name;
  
  --查询两个站点编号之间的站点编号(正向)
  if start_station_forder < end_station_forder then
     select st.station_name bulk collect into station_names from tb_station st where st.line_name=line_name and st.forder>=start_station_forder and st.forder<=end_station_forder order by st.forder ;
  else
     select st.station_name bulk collect into station_names from tb_station st where st.line_name=line_name and st.forder<=start_station_forder and st.forder>=end_station_forder order by st.forder desc;
  end if;
  
  --遍历集合
  for i in 1..station_names.count loop
   station_name:=station_name||station_names(i)||'==>';
  end loop;
  
  --去掉末尾的==>
  station_name:=substr(station_name,0,length(station_name)-3);

  dbms_output.put_line('您所乘坐的'||line_name||'路公交车，经过的站点：'||station_name);
  
end;

--执行公交存储过程
call bus_station('4','金九龙','郢都路口');
call bus_station('4','郢都路口','金九龙');

--无参数（不带in）函数
create or replace function function_test1
return tb_station.station_name%type--返回数据类型
as
station_name tb_station.station_name%type;
begin
  select tb.station_name into station_name from tb_station tb where tb.forder=4; 
  return station_name;
end;

--有参数（带in）函数
create or replace function function_test2(station_number tb_station.forder%type)
return tb_station.station_name%type--返回数据类型
as
station_name tb_station.station_name%type;
begin
  select tb.station_name into station_name from tb_station tb where tb.forder=station_number; 
  return station_name;
end;

--有参（带in），带out的函数
create or replace function function_test3(station_number tb_station.forder%type,station_line out tb_station.line_name%type)
return tb_station.station_name%type--返回数据类型
as
station_name tb_station.station_name%type;
begin
  select tb.station_name ,tb.line_name into station_name, station_line from tb_station tb where tb.forder=station_number; 
  return station_name;
end;

--带 in out的函数
create or replace function function_test4(num1 number,num2 in out number)
return number--返回数据类型
as
num3 number;
begin
  num3:=num1+num2;
  num2:=num2+5;
  return num3;
end;

--执行函数
declare
station_name tb_station.station_name%type;
begin
  station_name:=function_test1();
  dbms_output.put_line('站点名：'||station_name);
end;

declare
station_name tb_station.station_name%type;
begin
  station_name:=function_test2(2);
  dbms_output.put_line('站点名：'||station_name);
end;

declare
station_name tb_station.station_name%type;
station_line tb_station.line_name%type;
begin
  station_name:=function_test3(4,station_line);
  dbms_output.put_line('线路名：'||station_line);
  dbms_output.put_line('站点名：'||station_name);
end;

declare
num2 number:=4;
num3 number;
begin
  num3:=function_test4(3,num2);
  dbms_output.put_line('num2：'||num2);
  dbms_output.put_line('num3：'||num3);
end;

--触发器(达到触发条件隐式执行)
--建触发器
create or replace trigger t_test
before --before/after 触发时机
update or insert or delete on t_user --触发事件
--for each row
begin --触发操作
  dbms_output.put_line('触发器执行');
end;

create or replace trigger t_sal
before --before/after 触发时机
update of sal on t_user --触发事件
for each row --定义行触发器
  when (old.id=1) --对行进行条件限制
begin --触发操作
  if :new.sal<=:old.sal then
    raise_application_error(-20888,'坑爹，工资加错了');
  end if;
end;

select * from t_user;

insert into t_user(id,name,sal) values()

update t_user set sal = 7000 where id!=1;

--创建表
create table tb_student
(
       id number primary key,
       name varchar2(50),
       sal number
)

select * from tb_student;
drop table tb_student;
drop sequence t_user_seq;

--创建序列
create sequence t_user_seq
start with 1
increment by 1

--实现id自增的触发器
create or replace trigger t_id
before --执行时机 before/after
insert on tb_student --执行条件
for each row --指定为行触发器
begin --执行语句
  select t_user_seq.nextval into :new.id from dual;
end;


insert into tb_student(name,sal) values('jack',1000);
insert into tb_student(name,sal) values('tom',800);
insert into tb_student(name,sal) values('lily',900);


