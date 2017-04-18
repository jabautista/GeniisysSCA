CREATE OR REPLACE PACKAGE CPI.gicl_rec_hist_pkg
AS

    TYPE gicl_rec_hist_type IS RECORD(
        recovery_id         gicl_rec_hist.recovery_id%TYPE,
        rec_hist_no         gicl_rec_hist.rec_hist_no%TYPE,
        rec_stat_cd         gicl_rec_hist.rec_stat_cd%TYPE,
        remarks             gicl_rec_hist.remarks%TYPE,
        cpi_rec_no          gicl_rec_hist.cpi_rec_no%TYPE,
        cpi_branch_cd       gicl_rec_hist.cpi_branch_cd%TYPE,
        user_id             gicl_rec_hist.user_id%TYPE,
        last_update         gicl_rec_hist.last_update%TYPE,
        dsp_rec_stat_desc   giis_recovery_status.rec_stat_desc%TYPE
        );
        
    TYPE gicl_rec_hist_tab IS TABLE OF gicl_rec_hist_type;
    
    FUNCTION get_gicl_rec_hist(
        p_recovery_id           gicl_rec_hist.recovery_id%TYPE
        )
    RETURN gicl_rec_hist_tab PIPELINED;        

    PROCEDURE del_gicl_rec_hist(
        p_recovery_id       gicl_rec_hist.recovery_id%TYPE,
        p_rec_hist_no       gicl_rec_hist.rec_hist_no%TYPE
        );
        
    PROCEDURE set_gicl_rec_hst(
        p_recovery_id         gicl_rec_hist.recovery_id%TYPE,
        p_rec_hist_no         gicl_rec_hist.rec_hist_no%TYPE,
        p_rec_stat_cd         gicl_rec_hist.rec_stat_cd%TYPE,
        p_remarks             gicl_rec_hist.remarks%TYPE,
        p_cpi_rec_no          gicl_rec_hist.cpi_rec_no%TYPE,
        p_cpi_branch_cd       gicl_rec_hist.cpi_branch_cd%TYPE,
        p_user_id             gicl_rec_hist.user_id%TYPE,
        p_last_update         gicl_rec_hist.last_update%TYPE
        );

END gicl_rec_hist_pkg;
/


