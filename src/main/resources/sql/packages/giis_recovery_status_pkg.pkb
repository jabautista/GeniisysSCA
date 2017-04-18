CREATE OR REPLACE PACKAGE BODY CPI.giis_recovery_status_pkg
AS

    /*
    **  Created by    : Niknok Orio
    **  Date Created  : 03.29.2012
    **  Reference By  : GICLS025 - Recovery Information
    **  Description   : Gets list of Recovery status
    */
    FUNCTION get_recovery_status
      RETURN giis_recovery_status_tab PIPELINED IS
      v_list        giis_recovery_status_type;
    BEGIN
        FOR i IN (SELECT rec_stat_cd, rec_stat_desc
                    FROM giis_recovery_status
                   WHERE rec_stat_cd NOT IN (
                            SELECT param_value_v
                              FROM giis_parameters
                             WHERE param_name IN
                                      ('CLOSE_REC_STAT', 'WRITE_OFF_REC_STAT',
                                       'CANCEL_REC_STAT', 'REOPEN_REC_STAT'))
                ORDER BY rec_stat_desc)
        LOOP
          v_list.rec_stat_cd    := i.rec_stat_cd;
          v_list.rec_stat_desc  := i.rec_stat_desc;
          PIPE ROW(v_list);
        END LOOP;
      RETURN;
    END;

END;
/


