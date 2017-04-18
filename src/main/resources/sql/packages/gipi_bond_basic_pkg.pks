CREATE OR REPLACE PACKAGE CPI.gipi_bond_basic_pkg
AS

    TYPE gipi_bond_basic_type IS RECORD(
        policy_id               gipi_bond_basic.policy_id%TYPE,
        coll_flag               gipi_bond_basic.coll_flag%TYPE,
        clause_type             gipi_bond_basic.clause_type%TYPE,
        obligee_no              gipi_bond_basic.obligee_no%TYPE,
        prin_id                 gipi_bond_basic.prin_id%TYPE,
        val_period_unit         gipi_bond_basic.val_period_unit%TYPE,
        val_period              gipi_bond_basic.val_period%TYPE,
        np_no                   gipi_bond_basic.np_no%TYPE,
        contract_dtl            gipi_bond_basic.contract_dtl%TYPE,
        contract_date           gipi_bond_basic.contract_date%TYPE,
        co_prin_sw              gipi_bond_basic.co_prin_sw%TYPE,
        waiver_limit            gipi_bond_basic.waiver_limit%TYPE,
        indemnity_text          gipi_bond_basic.indemnity_text%TYPE,
        bond_dtl                gipi_bond_basic.bond_dtl%TYPE,
        endt_eff_date           gipi_bond_basic.endt_eff_date%TYPE,
        witness_ri              gipi_bond_basic.witness_ri%TYPE,
        witness_bond            gipi_bond_basic.witness_bond%TYPE,
        witness_ind             gipi_bond_basic.witness_ind%TYPE,
        remarks                 gipi_bond_basic.remarks%TYPE,
        cpi_rec_no              gipi_bond_basic.cpi_rec_no%TYPE,
        cpi_branch_cd           gipi_bond_basic.cpi_branch_cd%TYPE,
        arc_ext_data            gipi_bond_basic.arc_ext_data%TYPE,     
        nbt_obligee_name        giis_obligee.OBLIGEE_NAME%TYPE,
        nbt_prin_signor         giis_prin_signtry.PRIN_SIGNOR%TYPE,
        nbt_designation         giis_prin_signtry.DESIGNATION%TYPE,
        nbt_np_name             giis_notary_public.NP_NAME%TYPE,
        nbt_clause_desc         giis_bond_class_clause.CLAUSE_DESC%TYPE,
        nbt_bond_under          VARCHAR2(32000),
        nbt_bond_amt            gipi_itmperil.tsi_amt%TYPE
        );
        
    TYPE gipi_bond_basic_tab IS TABLE OF gipi_bond_basic_type;    

    FUNCTION get_gipi_bond_basic( 
        p_line_cd                    IN     GIPI_POLBASIC.line_cd%TYPE,  
        p_subline_cd                 IN     GIPI_POLBASIC.subline_cd%TYPE,
        p_pol_iss_cd                 IN     GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy                   IN     GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no                 IN     GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no                   IN     GIPI_POLBASIC.renew_no%TYPE,
        p_loss_date                  IN     GICL_CLAIMS.dsp_loss_date%TYPE,
        p_expiry_date                IN     GIPI_POLBASIC.expiry_date%TYPE,
        p_pol_eff_date               IN     GICL_CLAIMS.pol_eff_date%TYPE) 
    RETURN gipi_bond_basic_tab PIPELINED;
    
END gipi_bond_basic_pkg;
/


