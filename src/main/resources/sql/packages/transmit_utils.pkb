CREATE OR REPLACE PACKAGE BODY CPI.transmit_utils as

/* created by ajel 043002
 * this package will aid the transmittal modules and GenIISys banner screens in ensuring that
 *  database triggers are enabled before transmitting or performing transactions
 * this package was created to avoid different version per client-branch by dynamically creating
 *  anonymous pl/sql blocks to get/update the value of enable_flag from gitr_transmit_history_<BR>
 *  where BR is the branch code for the particular client's branch
 * GET_EN_FLAG_VAL  =>  selects the value of enable_flag and pass it to package variable transmit_utils.v_enable_flag
 *                       that will be referrenced by the modules
 * GET_EN_FLAG_VAL_T  =>  selects the value of enable_flag and pass it to package variable transmit_utils.v_enable_flag
 *                       that will be referrenced by the modules
 * UPD_EN_FLAG      =>  sets the value of enable_flag in table gitr_transmit_hist_<BR> to 'Y' on GenIISys banner screens
 * UPD_EN_FLAG_N    =>  sets the value of enable_flag in table gitr_transmit_hist_<BR> to 'N' on GenIISys banner screens
 * SET_EN_FLAG_Y      =>  sets the value of enable_flag in table gitr_transmit_hist_<BR> to 'Y' on transmittal modules
 * SET_EN_FLAG_N      =>  sets the value of enable_flag in table gitr_transmit_hist_<BR> to 'N' on transmittal modules
*/

/***********************************************
  start of PROCEDURE get_en_flag_val
***********************************************/

  PROCEDURE get_en_flag_val(v_en1 out varchar2) IS
   v_col1  VARCHAR2(50);
  begin
    begin
      select param_value_v
       into v_col1
        from giis_parameters
       where param_name = 'GITR_TRANSMIT_ISS_CD';
    exception
       when no_data_found then
       RAISE_APPLICATION_ERROR(-20020, 'No param_name GITR_TRANSMIT_ISS_CD in giis_parameters. Please add it to giis_parameters with vlues corresponding to your iss_cd',TRUE);
    end;
     execute immediate('declare
                         v_en2 varchar2(2);
                        begin
                         select nvl(enable_flag,''S'')
                           into v_en2
                           from gitr_transmit_hist_'||v_Col1||'
                          where load_start_dt = (select max(load_start_dt)
                                                 from                                               gitr_transmit_hist_'||v_Col1||')
                            and load_ext_sw = ''L'';
                         transmit_utils.v_enable_flag := v_en2;
                        EXCEPTION
                        when no_data_found then
                         transmit_utils.v_enable_flag := ''S'';
                        end;');
  v_en1 := transmit_utils.v_enable_flag;
  END get_en_flag_val;

/***********************************************
  end of PROCEDURE get_en_flag_val
***********************************************/

/***********************************************
  start of PROCEDURE get_en_flag_val_t
***********************************************/

  PROCEDURE get_en_flag_val_t(v_hist_id  number , v_en1 out varchar2) IS
   v_col1  VARCHAR2(50);
  begin
   transmit_utils.v_hist_id := v_hist_id;
    begin
      select param_value_v
       into v_col1
        from giis_parameters
       where param_name = 'GITR_TRANSMIT_ISS_CD';
    exception
       when no_data_found then
       RAISE_APPLICATION_ERROR(-20020, 'No param_name GITR_TRANSMIT_ISS_CD in giis_parameters. Please add it to giis_parameters with vlues corresponding to your iss_cd',TRUE);
    end;
     execute immediate('declare
                         v_en2 varchar2(2);
                        begin
                         select nvl(enable_flag,''S'')
                           into v_en2
                           from gitr_transmit_hist_'||v_Col1||'
                          where load_start_dt = (select max(load_start_dt)
                                                   from gitr_transmit_hist_'||v_Col1||'
                                                  where hist_id != transmit_utils.v_hist_id)
                            and load_ext_sw = ''L'';
                         transmit_utils.v_enable_flag := v_en2;
                        end;');
  v_en1 := transmit_utils.v_enable_flag;
  END get_en_flag_val_t;

/***********************************************
  end of PROCEDURE get_en_flag_val_t
***********************************************/

/***********************************************
  start of PROCEDURE upd_en_flag
***********************************************/

  PROCEDURE upd_en_flag IS
   v_col1  VARCHAR2(50);
  begin
    begin
      select param_value_v
       into v_col1
        from giis_parameters
       where param_name = 'GITR_TRANSMIT_ISS_CD';
    exception
       when no_data_found then
       RAISE_APPLICATION_ERROR(-20020, 'No param_name GITR_TRANSMIT_ISS_CD in giis_parameters. Please add it to giis_parameters with vlues corresponding to your iss_cd',TRUE);
    end;
     execute immediate('update gitr_transmit_hist_'||v_col1||'
                           set enable_flag = ''Y''
                         where load_start_dt = (select max(load_start_dt)
                                                from gitr_transmit_hist_'||v_col1||')
                           and load_ext_sw = ''L''');
  COMMIT;
  END upd_en_flag;
/***********************************************
  end of PROCEDURE upd_en_flag
***********************************************/

/***********************************************
  start of PROCEDURE upd_en_flag_n
***********************************************/

  PROCEDURE upd_en_flag_n IS
   v_col1  VARCHAR2(50);
  begin
    begin
      select param_value_v
       into v_col1
        from giis_parameters
       where param_name = 'GITR_TRANSMIT_ISS_CD';
    exception
       when no_data_found then
       RAISE_APPLICATION_ERROR(-20020, 'No param_name GITR_TRANSMIT_ISS_CD in giis_parameters. Please add it to giis_parameters with vlues corresponding to your iss_cd',TRUE);
    end;
     execute immediate('update gitr_transmit_hist_'||v_col1||'
                           set enable_flag = ''N''
                         where load_start_dt = (select max(load_start_dt)
                                                from gitr_transmit_hist_'||v_col1||')
                           and load_ext_sw = ''L''');
  COMMIT;
  END upd_en_flag_n;
/***********************************************
  end of PROCEDURE upd_en_flag_n
***********************************************/

/***********************************************
  start of PROCEDURE set_en_flag_y
***********************************************/

  PROCEDURE set_en_flag_y IS
   v_col1  VARCHAR2(50);
  begin
    begin
      select param_value_v
       into v_col1
        from giis_parameters
       where param_name = 'GITR_TRANSMIT_ISS_CD';
    exception
       when no_data_found then
       RAISE_APPLICATION_ERROR(-20020, 'No param_name GITR_TRANSMIT_ISS_CD in giis_parameters. Please add it to giis_parameters with vlues corresponding to your iss_cd',TRUE);
    end;
     execute immediate('update gitr_transmit_hist_'||v_col1||'
                           set enable_flag = ''Y''
                         where load_start_dt = (select max(load_start_dt)    --sysdate
                                                  from gitr_transmit_hist_'||v_col1||')
                           and load_ext_sw = ''L''
                      ');
    commit;
  END set_en_flag_y;
/***********************************************
  end of PROCEDURE set_en_flag_y
***********************************************/

/***********************************************
  start of PROCEDURE set_en_flag_n
***********************************************/

  PROCEDURE set_en_flag_n IS
   v_col1  VARCHAR2(50);
  begin
    begin
      select param_value_v
       into v_col1
        from giis_parameters
       where param_name = 'GITR_TRANSMIT_ISS_CD';
    exception
       when no_data_found then
       RAISE_APPLICATION_ERROR(-20020, 'No param_name GITR_TRANSMIT_ISS_CD in giis_parameters. Please add it to giis_parameters with vlues corresponding to your iss_cd',TRUE);
    end;
     execute immediate('update gitr_transmit_hist_'||v_col1||'
                           set enable_flag = ''N''
                         where load_start_dt = (select max(load_start_dt)    --sysdate
                                                  from gitr_transmit_hist_'||v_col1||')
                           and load_ext_sw = ''L''
                       ');
    commit;
  END set_en_flag_n;
/***********************************************
  end of PROCEDURE set_en_flag_n
***********************************************/

END;
/

DROP PACKAGE BODY CPI.TRANSMIT_UTILS;

