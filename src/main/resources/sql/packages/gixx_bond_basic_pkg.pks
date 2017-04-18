CREATE OR REPLACE PACKAGE CPI.GIXX_BOND_BASIC_PKG 
AS    
    -- added by Kris 03.14.2013
    TYPE bond_basic_type IS RECORD(
        extract_id          gixx_bond_basic.extract_id%TYPE, --
        obligee_no          gixx_bond_basic.obligee_no%TYPE, --
        prin_id             gixx_bond_basic.prin_id%TYPE, --
        coll_flag           gixx_bond_basic.coll_flag%TYPE, --
        clause_type         gixx_bond_basic.clause_type%TYPE, --
        val_period_unit     gixx_bond_basic.val_period_unit%TYPE,
        val_period          gixx_bond_basic.val_period%TYPE,
        policy_id           gixx_bond_basic.policy_id%TYPE, --
        np_no               gixx_bond_basic.np_no%TYPE, --
        contract_dtl        gixx_bond_basic.contract_dtl%TYPE, --
        contract_date       gixx_bond_basic.contract_date%TYPE, --
        co_prin_sw          gixx_bond_basic.co_prin_sw%TYPE, -- 
        waiver_limit        gixx_bond_basic.waiver_limit%TYPE, --
        indemnity_text      gixx_bond_basic.indemnity_text%TYPE, --
        bond_dtl            gixx_bond_basic.bond_dtl%TYPE, --
        endt_eff_date       gixx_bond_basic.endt_eff_date%TYPE,
        remarks             gixx_bond_basic.remarks%TYPE,
        witness_ri          gixx_bond_basic.witness_ri%TYPE,
        witness_bond        gixx_bond_basic.witness_bond%TYPE,
        witness_ind         gixx_bond_basic.witness_ind%TYPE,
        plaintiff_dtl       gipi_bond_basic.plaintiff_dtl%TYPE,
        defendant_dtl       gipi_bond_basic.defendant_dtl%TYPE,
        civil_case_no       gipi_bond_basic.civil_case_no%TYPE,
        prin_signor         giis_prin_signtry.prin_signor%TYPE, -- 
        obligee_name        giis_obligee.obligee_name%TYPE, --
        designation         giis_prin_signtry.designation%TYPE, --
        np_name             giis_notary_public.np_name%TYPE, -- 
        clause_desc         giis_bond_class_clause.clause_desc%TYPE, -- 
        str_con_date        VARCHAR2(50),
        dsp_gen_info        VARCHAR2(2000)      
    );
    
    TYPE bond_basic_tab IS TABLE OF bond_basic_type;
    
    FUNCTION get_bond_basic(
        p_extract_id    gixx_polbasic.extract_id%TYPE,
        p_policy_id     gixx_polbasic.policy_id%TYPE
    ) RETURN bond_basic_tab PIPELINED; 
     
END GIXX_BOND_BASIC_PKG;
/