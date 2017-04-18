DROP PROCEDURE CPI.GET_TABLE_TYPES;

CREATE OR REPLACE PROCEDURE CPI.get_table_types
  (stmt                    varchar2,
   t_item          in out  dbms_sql.number_table,
   t_package       in out  dbms_sql.number_table,
   t_benefit       in out  dbms_sql.varchar2_table,
   t_comm_rate     in out  dbms_sql.number_table,
   t_tsi_amt       in out  dbms_sql.number_table,
   t_prem_amt      in out  dbms_sql.number_table,
   t_comm_amt      in out  dbms_sql.number_table ) IS
   v_array         number:= 200;           -- sets the maximum numbers to be fetched
   v_cid           number;
   v_rownum        number;
BEGIN
   v_cid  := dbms_sql.open_cursor;
   dbms_sys_sql.parse_as_user(v_cid, stmt, DBMS_SQL.NATIVE);
   dbms_sql.define_array(v_cid, 1, t_item      , v_array, 1);
   dbms_sql.define_array(v_cid, 2, t_package   , v_array, 1);
   dbms_sql.define_array(v_cid, 3, t_benefit   , v_array, 1);
   dbms_sql.define_array(v_cid, 4, t_comm_rate , v_array, 1);
   dbms_sql.define_array(v_cid, 5, t_tsi_amt   , v_array, 1);
   dbms_sql.define_array(v_cid, 6, t_prem_amt  , v_array, 1);
   dbms_sql.define_array(v_cid, 7, t_comm_amt  , v_array, 1);
   v_rownum  := dbms_sql.execute(v_cid);
   --start fetch rows
   v_rownum  := v_array;
   while v_rownum = v_array loop
   	 v_rownum := dbms_sql.fetch_rows(v_cid);  -- will become 0 when no more records to fetch
   	 dbms_sql.column_value(v_cid, 1, t_item);
   	 dbms_sql.column_value(v_cid, 2, t_package);
   	 dbms_sql.column_value(v_cid, 3, t_benefit);
   	 dbms_sql.column_value(v_cid, 4, t_comm_rate);
   	 dbms_sql.column_value(v_cid, 5, t_tsi_amt);
   	 dbms_sql.column_value(v_cid, 6, t_prem_amt);
   	 dbms_sql.column_value(v_cid, 7, t_comm_amt);
   end loop;
   dbms_sql.close_cursor(v_cid);
END;
/


