CREATE OR REPLACE PACKAGE CPI.GIIS_TRTY_PANEL_PKG
AS

    TYPE giis_trty_panel_type IS RECORD (
        ri_cd               giis_trty_panel.ri_cd%TYPE,
        ri_name             giis_reinsurer.ri_name%TYPE,
        ending_bal_amt      giac_treaty_qtr_summary.ending_bal_amt%TYPE,
        final_tag           giac_treaty_qtr_summary.final_tag%TYPE,
        compute_tag         giac_treaty_qtr_summary.final_tag%TYPE,
        line_cd             giis_trty_panel.line_cd%TYPE,
        trty_yy             giis_trty_panel.trty_yy%TYPE,
        trty_seq_no         giis_trty_panel.trty_seq_no%TYPE,
        user_id             giis_trty_panel.user_id%TYPE,
        ext_useR_id         giac_treaty_extract.user_id%TYPE,
        last_update         VARCHAR2(20),
        last_extract        VARCHAR2(20)
    );
    
    TYPE giis_trty_panel_tab IS TABLE OF giis_trty_panel_type;
    
     FUNCTION get_trty_panel_list(
        p_line_cd           giis_trty_panel.line_cd%TYPE,
        p_share_cd          giis_trty_panel.trty_seq_no%TYPE,
        p_trty_yy           giis_trty_panel.trty_yy%TYPE,
        p_main_proc_year    NUMBER,
        p_main_proc_qtr     NUMBER
    ) RETURN giis_trty_panel_tab PIPELINED;

END GIIS_TRTY_PANEL_PKG;
/


