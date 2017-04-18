DROP PROCEDURE CPI.DO_DDL;

CREATE OR REPLACE PROCEDURE CPI.do_ddl
   (stmt               varchar2 ) is
/* JANET ANG */
cur    integer;
stat   number;
begin
  cur  :=  dbms_sys_sql.open_cursor;
  dbms_sys_sql.parse_as_user(cur, stmt ,dbms_sql.native );
  stat :=  dbms_sql.execute(cur);
  dbms_sql.close_cursor(cur);
end;
/


