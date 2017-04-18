CREATE OR REPLACE PACKAGE CPI.GIXX_CO_INSURER_PKG AS     
    
    TYPE pol_doc_co_insurance_type IS RECORD (
         extract_id15          GIXX_CO_INSURER.extract_id%TYPE,
         coinsurer_ri_tsi_amt  VARCHAR2(20),
         reinsurer_ri_name     GIIS_REINSURER.ri_name%TYPE
         );
        
    TYPE pol_doc_co_insurance_tab IS TABLE OF pol_doc_co_insurance_type;
    
    FUNCTION get_pol_doc_co_insurance RETURN pol_doc_co_insurance_tab PIPELINED;
    
    
    -- added by Kris 03.12.2013 for GIPIS101
    TYPE co_ins_type IS RECORD (
        extract_id          gixx_co_insurer.extract_id%TYPE,
        co_ri_cd            gixx_co_insurer.co_ri_cd%TYPE,
        co_ri_shr_pct       gixx_co_insurer.co_ri_shr_pct%TYPE,
        co_ri_prem_amt      gixx_co_insurer.co_ri_prem_amt%TYPE,  
        co_ri_tsi_amt       gixx_co_insurer.co_ri_tsi_amt%TYPE,
        
        ri_sname            giis_reinsurer.ri_sname%TYPE
    );
    
    TYPE co_ins_tab IS TABLE OF co_ins_type;
    
    FUNCTION get_co_ins_list(
        p_extract_id    gixx_co_insurer.extract_id%TYPE
    ) RETURN co_ins_tab PIPELINED;
    -- end 03.12.2013: for GIPIS101

END GIXX_CO_INSURER_PKG;
/


