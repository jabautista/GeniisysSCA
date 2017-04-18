DROP PROCEDURE CPI.BAE_INSERT_BATCH_ENTRIES;

CREATE OR REPLACE PROCEDURE CPI.BAE_INSERT_BATCH_ENTRIES
(  trty_yy              giis_dist_share.trty_yy%type,
  module_id            giac_module_entries.module_id%type,
  item_no              giac_module_entries.item_no%type,
  p_gl_acct_category   giac_module_entries.gl_acct_category%type,
  p_gl_control_acct    giac_module_entries.gl_control_acct%type,
  p_gl_sub_acct_1      giac_module_entries.gl_sub_acct_1%type,
  p_gl_sub_acct_2      giac_module_entries.gl_sub_acct_2%type,
  p_gl_sub_acct_3      giac_module_entries.gl_sub_acct_3%type,
  p_gl_sub_acct_4      giac_module_entries.gl_sub_acct_4%type,
  p_gl_sub_acct_5      giac_module_entries.gl_sub_acct_5%type,
  p_gl_sub_acct_6      giac_module_entries.gl_sub_acct_6%type,
  p_gl_sub_acct_7      giac_module_entries.gl_sub_acct_7%type,
  p_line_dependency    giac_module_entries.line_dependency_level%type,
  p_intm_type_level    giac_module_entries.intm_type_level%type,
  p_ca_treaty_type     giac_module_entries.ca_treaty_type_level%type,
  p_ext_table          all_tables.table_name%type    ) AS
/* JANET ANG */
  var  		varchar2(50);
  uno  		varchar2(50);
  dos  		varchar2(50);
  tres 		varchar2(50);
  uno_column    varchar2(100);
  dos_column    varchar2(100);
  tres_column   varchar2(100);
  uno_table     varchar2(100);
  dos_table     varchar2(100);
  tres_table    varchar2(100);
begin
  var := to_char(p_line_dependency,'fm00') || 'LIN' || to_char(p_intm_type_level , 'fm00') || 'INT' || to_char(p_ca_treaty_type, 'fm00') || 'CAT';
--  dbms_output.put_line( 'var value is :  '|| var);
  select least( substr(var,1,5), substr(var,6,5), substr(var,11,5)) into uno from dual;
--  dbms_output.put_line ( 'least is :  '|| uno);
  select replace ( var, uno ,'') into var from dual;
--  dbms_output.put_line( 'result of replace is :  '|| var);
  select least( substr(var,1,5), substr(var,6,5)) into dos from dual;
--  dbms_output.put_line( 'next in size is:  '|| dos);
  select replace ( var, dos, '') into tres from dual;
--  dbms_output.put_line( 'greatest is :  '|| tres);
  select
         decode( substr(uno,3,3),'LIN' ,'GIIS_LINE where acct_line_cd is not null',
           'INT', 'GIIS_INTM_TYPE where acct_intm_cd is not null' ,
           'CAT','GIIS_DIST_SHARE WHERE SHARE_TYPE = ''2'' AND TRTY_YY = '|| TO_CHAR(TRTY_YY)|| ' and acct_trty_type is not null') ,
         decode( substr(uno,3,3),'LIN' ,'ACCT_LINE_CD', 'INT', 'ACCT_INTM_CD', 'CAT', 'ACCT_TRTY_TYPE') ,
         decode( substr(DOS,3,3),'LIN' ,'GIIS_LINE where acct_line_cd is not null',
           'INT', 'GIIS_INTM_TYPE where acct_intm_cd is not null',
           'CAT','GIIS_DIST_SHARE WHERE SHRE_TYPE = ''2'' AND TRTY_YY = '|| TO_CHAR(TRTY_YY)|| ' and acct_trty_type is not null' ) ,
         decode( substr(DOS,3,3),'LIN' ,'ACCT_LINE_CD', 'INT', 'ACCT_INTM_CD', 'CAT', 'ACCT_TRTY_TYPE') ,
         decode( substr(TRES,3,3),'LIN' ,'GIIS_LINE where acct_line_cd is not null',
           'INT', 'GIIS_INTM_TYPE where acct_intm_cd is not null',
           'CAT','GIIS_DIST_SHARE WHERE SHARE_TYPE = ''2'' AND TRTY_YY = '|| TO_CHAR(TRTY_YY)|| ' and acct_trty_type is not null' ) ,
         decode( substr(TRES,3,3),'LIN' ,'ACCT_LINE_CD', 'INT', 'ACCT_INTM_CD', 'CAT', 'ACCT_TRTY_TYPE')
  into uno_table, uno_column, dos_table, dos_column, tres_table, tres_column
  from dual;
  select substr( uno,1,2) into uno from dual;
  select substr( dos,1,2) into dos from dual;
  select substr( tres,1,2) into tres from dual;
  if p_ext_table is not null then
    uno_table  := p_ext_table;
    dos_table  := p_ext_table;
    tres_table := p_ext_table;
  end if;
  if tres = 0 then  -- there is no level
     insert into giac_batch_entries(gl_acct_category, gl_control_acct,
         gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5,
         gl_sub_acct_6, gl_sub_acct_7, item_no      , module_id)
     values ( p_gl_acct_category ,  p_gl_control_acct ,
         p_gl_sub_acct_1 , p_gl_sub_acct_2 , p_gl_sub_acct_3 ,
         p_gl_sub_acct_4 , p_gl_sub_acct_5 , p_gl_sub_acct_6 ,
         p_gl_sub_acct_7 , item_no         , module_id  );
--    null;
  elsif dos = 0 then -- there is only one level
    do_ddl('
    declare
      p_item_no            giac_module_entries.item_no%type         := ' || item_no ||';
      p_module_id          giac_module_entries.module_id%type       := ' || module_id ||';
      p_gl_acct_category   giac_module_entries.gl_acct_category%type:= ' || p_gl_acct_category ||';
      p_gl_control_acct    giac_module_entries.gl_control_acct%type := ' || p_gl_control_acct ||';
      p_gl_sub_acct_1      giac_module_entries.gl_sub_acct_1%type   := ' || p_gl_sub_acct_1 ||';
      p_gl_sub_acct_2      giac_module_entries.gl_sub_acct_2%type   := ' || p_gl_sub_acct_2 ||';
      p_gl_sub_acct_3      giac_module_entries.gl_sub_acct_3%type   := ' || p_gl_sub_acct_3 ||';
      p_gl_sub_acct_4      giac_module_entries.gl_sub_acct_4%type   := ' || p_gl_sub_acct_4 ||';
      p_gl_sub_acct_5      giac_module_entries.gl_sub_acct_5%type   := ' || p_gl_sub_acct_5 ||';
      p_gl_sub_acct_6      giac_module_entries.gl_sub_acct_6%type   := ' || p_gl_sub_acct_6 ||';
      p_gl_sub_acct_7      giac_module_entries.gl_sub_acct_7%type   := ' || p_gl_sub_acct_7 ||';
    begin
     for ja1 in (select distinct ' || tres_column ||' from '|| tres_table||' ) loop
       bae_check_level( ' || tres  || ', ja1.'|| tres_column ||',
                             p_gl_sub_acct_1 , p_gl_sub_acct_2 , p_gl_sub_acct_3 , p_gl_sub_acct_4 ,
                             p_gl_sub_acct_5 , p_gl_sub_acct_6 , p_gl_sub_acct_7 );
           insert into giac_batch_entries(gl_acct_category, gl_control_acct,
             gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5,
             gl_sub_acct_6, gl_sub_acct_7, item_no      , module_id)
           values ( '|| p_gl_acct_category ||','||  p_gl_control_acct ||',
                    p_gl_sub_acct_1 , p_gl_sub_acct_2 , p_gl_sub_acct_3 ,
                    p_gl_sub_acct_4 , p_gl_sub_acct_5 , p_gl_sub_acct_6 ,
                    p_gl_sub_acct_7 , p_item_no       , p_module_id  );
     end loop;
    end;
    ');
  elsif uno = 0 then -- there are 2 levels
    do_ddl('
    declare
      p_item_no            giac_module_entries.item_no%type         := ' || item_no ||';
      p_module_id          giac_module_entries.module_id%type       := ' || module_Id ||';
      p_gl_acct_category   giac_module_entries.gl_acct_category%type:= ' || p_gl_acct_category ||';
      p_gl_control_acct    giac_module_entries.gl_control_acct%type := ' || p_gl_control_acct ||';
      p_gl_sub_acct_1      giac_module_entries.gl_sub_acct_1%type   := ' || p_gl_sub_acct_1 ||';
      p_gl_sub_acct_2      giac_module_entries.gl_sub_acct_2%type   := ' || p_gl_sub_acct_2 ||';
      p_gl_sub_acct_3      giac_module_entries.gl_sub_acct_3%type   := ' || p_gl_sub_acct_3 ||';
      p_gl_sub_acct_4      giac_module_entries.gl_sub_acct_4%type   := ' || p_gl_sub_acct_4 ||';
      p_gl_sub_acct_5      giac_module_entries.gl_sub_acct_5%type   := ' || p_gl_sub_acct_5 ||';
      p_gl_sub_acct_6      giac_module_entries.gl_sub_acct_6%type   := ' || p_gl_sub_acct_6 ||';
      p_gl_sub_acct_7      giac_module_entries.gl_sub_acct_7%type   := ' || p_gl_sub_acct_7 ||';
    begin
     for ja1 in (select distinct ' || dos_column ||' from '|| dos_table|| ') loop
       bae_check_level( ' || dos  || ', ja1.'|| dos_column ||',
           p_gl_sub_acct_1 , p_gl_sub_acct_2 , p_gl_sub_acct_3 , p_gl_sub_acct_4 ,
           p_gl_sub_acct_5 , p_gl_sub_acct_6 , p_gl_sub_acct_7 );
       for ja2 in (select distinct '|| tres_column ||' from '|| tres_table ||' ) loop
         bae_check_level( ' || tres || ', ja2.'|| tres_column||',
              p_gl_sub_acct_1 , p_gl_sub_acct_2 , p_gl_sub_acct_3 , p_gl_sub_acct_4 ,
              p_gl_sub_acct_5 , p_gl_sub_acct_6 , p_gl_sub_acct_7 );
           insert into giac_batch_entries(gl_acct_category, gl_control_acct,
             gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5,
             gl_sub_acct_6, gl_sub_acct_7, item_no      , module_id )
           values ( '|| p_gl_acct_category ||','||  p_gl_control_acct ||',
                    p_gl_sub_acct_1 , p_gl_sub_acct_2 , p_gl_sub_acct_3 ,
                    p_gl_sub_acct_4 , p_gl_sub_acct_5 , p_gl_sub_acct_6 ,
                    p_gl_sub_acct_7 , p_item_no       , p_module_id);
       end loop;
     end loop;
    end;
    ');
  else               -- there are 3 levels
    do_ddl('
    declare
      p_item_no            giac_module_entries.item_no%type         := ' || item_no ||';
      p_module_id          giac_module_entries.module_id%type       := ' || module_id ||';
      p_gl_acct_category   giac_module_entries.gl_acct_category%type:= ' || p_gl_acct_category ||';
      p_gl_control_acct    giac_module_entries.gl_control_acct%type := ' || p_gl_control_acct ||';
      p_gl_sub_acct_1      giac_module_entries.gl_sub_acct_1%type   := ' || p_gl_sub_acct_1 ||';
      p_gl_sub_acct_2      giac_module_entries.gl_sub_acct_2%type   := ' || p_gl_sub_acct_2 ||';
      p_gl_sub_acct_3      giac_module_entries.gl_sub_acct_3%type   := ' || p_gl_sub_acct_3 ||';
      p_gl_sub_acct_4      giac_module_entries.gl_sub_acct_4%type   := ' || p_gl_sub_acct_4 ||';
      p_gl_sub_acct_5      giac_module_entries.gl_sub_acct_5%type   := ' || p_gl_sub_acct_5 ||';
      p_gl_sub_acct_6      giac_module_entries.gl_sub_acct_6%type   := ' || p_gl_sub_acct_6 ||';
      p_gl_sub_acct_7      giac_module_entries.gl_sub_acct_7%type   := ' || p_gl_sub_acct_7 ||';
    begin
     for ja1 in (select distinct ' || uno_column ||' from '|| uno_table||' ) loop
       bae_check_level( ' || uno  || ', ja1.'|| uno_column ||',
              p_gl_sub_acct_1 , p_gl_sub_acct_2 , p_gl_sub_acct_3 , p_gl_sub_acct_4 ,
              p_gl_sub_acct_5 , p_gl_sub_acct_6 , p_gl_sub_acct_7 );
       for ja2 in (select distinct '|| dos_column ||' from '|| dos_table ||' ) loop
         bae_check_level( ' || dos || ', ja2.'||dos_column||',
              p_gl_sub_acct_1 , p_gl_sub_acct_2 , p_gl_sub_acct_3 , p_gl_sub_acct_4 ,
              p_gl_sub_acct_5 , p_gl_sub_acct_6 , p_gl_sub_acct_7 );
         for ja3 in (select distinct '|| tres_column ||' from '|| tres_table ||' ) loop
           bae_check_level( ' || tres ||', ja3.'|| tres_column ||',
              p_gl_sub_acct_1 , p_gl_sub_acct_2 , p_gl_sub_acct_3 , p_gl_sub_acct_4 ,
              p_gl_sub_acct_5 , p_gl_sub_acct_6 , p_gl_sub_acct_7 );
           insert into giac_batch_entries(gl_acct_category, gl_control_acct,
             gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5,
             gl_sub_acct_6, gl_sub_acct_7, item_no      , module_id )
           values ( '|| p_gl_acct_category ||','||  p_gl_control_acct ||',
                    p_gl_sub_acct_1 , p_gl_sub_acct_2 , p_gl_sub_acct_3 ,
                    p_gl_sub_acct_4 , p_gl_sub_acct_5 , p_gl_sub_acct_6 ,
                    p_gl_sub_acct_7 , p_item_no       , p_module_id );
         end loop;
       end loop;
     end loop;
    end;
    ');
  end if;
end;
/


