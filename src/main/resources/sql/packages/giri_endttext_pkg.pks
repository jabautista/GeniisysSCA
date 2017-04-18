CREATE OR REPLACE PACKAGE CPI.giri_endttext_pkg
AS
    TYPE giri_endttext_type IS RECORD (
        policy_id           giri_endttext.policy_id%TYPE,
        ri_cd               giri_endttext.ri_cd%TYPE,
        fnl_binder_id       giri_endttext.fnl_binder_id%TYPE,
        remarks             giri_endttext.remarks%TYPE,
        user_id             giri_endttext.user_id%TYPE,
        last_update         giri_endttext.last_update%TYPE,
        arc_ext_data        giri_endttext.arc_ext_data%TYPE,
        dsp_ri_name         giis_reinsurer.ri_name%TYPE,
        dsp_endt_text       giri_binder.endt_text%TYPE,
        dsp_binder_date     giri_binder.binder_date%TYPE,
        dsp_binder_no       VARCHAR2(50)
    );
    
    TYPE giri_endttext_tab IS TABLE OF giri_endttext_type;
        
    FUNCTION get_reinsurance_details(
        p_policy_id   giri_endttext.policy_id%TYPE
    )
    RETURN giri_endttext_tab PIPELINED;
    
    PROCEDURE update_create_endttext_binder(
        p_policy_id        giri_endttext.policy_id%TYPE,
        p_ri_cd            giri_endttext.ri_cd%TYPE,
        p_dsp_endttext     giri_binder.endt_text%TYPE,
        p_fnl_binder_id    giri_endttext.fnl_binder_id%TYPE,
        p_remarks          giri_endttext.remarks%TYPE,
        p_line_cd          giis_fbndr_seq.line_cd%TYPE,
        p_user_id          giis_fbndr_seq.user_id%TYPE,
        p_eff_date         giri_binder.eff_date%TYPE,
        p_expiry_date      giri_binder.expiry_date%TYPE,         
        p_dsp_binder_date  giri_binder.binder_date%TYPE,
        p_iss_cd           giri_binder.iss_cd%TYPE
    );
    
END giri_endttext_pkg;
/


