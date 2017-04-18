CREATE OR REPLACE PACKAGE CPI.giis_banc_branch_pkg
AS

    TYPE giis_banc_branch_type IS RECORD(
        branch_cd           giis_banc_branch.branch_cd%TYPE,
        branch_desc         giis_banc_branch.branch_desc%TYPE,
        area_cd             giis_banc_branch.area_cd%TYPE,
        eff_date            giis_banc_branch.eff_date%TYPE,
        remarks             giis_banc_branch.remarks%TYPE,
        user_id             giis_banc_branch.user_id%TYPE,
        last_update         giis_banc_branch.last_update%TYPE,
        manager_cd          giis_banc_branch.manager_cd%TYPE,
        bank_acct_cd        giis_banc_branch.bank_acct_cd%TYPE,
        mgr_eff_date        giis_banc_branch.mgr_eff_date%TYPE,
        dsp_manager_name    VARCHAR2(32000)
        );
        
    TYPE giis_banc_branch_tab IS TABLE OF giis_banc_branch_type;    
    
    TYPE giuts035_banc_branch_type IS RECORD(
        branch_cd           giis_banc_branch.branch_cd%TYPE,
        branch_desc         giis_banc_branch.branch_desc%TYPE,
        area_desc           giis_banc_area.area_desc%TYPE
    );
    TYPE giuts035_banc_branch_tab IS TABLE OF giuts035_banc_branch_type;

    FUNCTION get_giis_banc_branch_list
    RETURN giis_banc_branch_tab PIPELINED;
    
    FUNCTION get_giuts035_banc_branch_list
      RETURN giuts035_banc_branch_tab PIPELINED;

END;
/


