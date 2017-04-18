CREATE OR REPLACE PACKAGE CPI.gipi_cosigntry_pkg
AS
    TYPE gipi_cosigntry_type IS RECORD(
        policy_id           gipi_cosigntry.policy_id%TYPE,
        cosign_id           gipi_cosigntry.cosign_id%TYPE,
        assd_no             gipi_cosigntry.assd_no%TYPE,
        indem_flag          gipi_cosigntry.indem_flag%TYPE,
        bonds_flag          gipi_cosigntry.bonds_flag%TYPE,
        bonds_ri_flag       gipi_cosigntry.bonds_ri_flag%TYPE,
        cpi_rec_no          gipi_cosigntry.cpi_rec_no%TYPE,
        cpi_branch_cd       gipi_cosigntry.cpi_branch_cd%TYPE,
        arc_ext_data        gipi_cosigntry.arc_ext_data%TYPE,
        dsp_cosign_name     giis_cosignor_res.cosign_name%TYPE
        );
        
    TYPE gipi_cosigntry_tab IS TABLE OF gipi_cosigntry_type;
    
    FUNCTION get_gipi_cosigntry(p_policy_id     gipi_cosigntry.policy_id%TYPE)
    RETURN gipi_cosigntry_tab PIPELINED;
        
END gipi_cosigntry_pkg;
/


