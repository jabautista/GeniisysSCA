CREATE OR REPLACE PACKAGE CPI.giis_recovery_status_pkg
AS

    TYPE giis_recovery_status_type IS RECORD(
        rec_stat_cd                 giis_recovery_status.rec_stat_cd%TYPE,
        rec_stat_desc               giis_recovery_status.rec_stat_desc%TYPE,
        remarks                     giis_recovery_status.remarks%TYPE,
        cpi_rec_no                  giis_recovery_status.cpi_rec_no%TYPE,
        cpi_branch_cd               giis_recovery_status.cpi_branch_cd%TYPE,
        user_id                     giis_recovery_status.user_id%TYPE,
        last_update                 giis_recovery_status.last_update%TYPE,
        rec_stat_type  			    giis_recovery_status.rec_stat_type%TYPE
        );
        
    TYPE giis_recovery_status_tab IS TABLE OF giis_recovery_status_type;
    
    FUNCTION get_recovery_status RETURN giis_recovery_status_tab PIPELINED; 

END;
/


