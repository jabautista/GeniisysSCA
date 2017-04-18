CREATE OR REPLACE PACKAGE CPI.GIXX_BENEFICIARY_PKG AS

    TYPE pol_doc_beneficiary_type IS RECORD(
      extract_id        GIXX_BENEFICIARY.extract_id%TYPE,
      item_no           GIXX_BENEFICIARY.item_no%TYPE,
      beneficiary_no    GIXX_BENEFICIARY.beneficiary_no%TYPE,
      beneficiary_name  GIXX_BENEFICIARY.beneficiary_name%TYPE,
      beneficiary_addr  GIXX_BENEFICIARY.beneficiary_addr%TYPE,
      relation          GIXX_BENEFICIARY.relation%TYPE
      );
      
    TYPE pol_doc_beneficiary_tab IS TABLE OF pol_doc_beneficiary_type;
    
    FUNCTION get_pol_doc_beneficiary(p_extract_id IN GIXX_BENEFICIARY.extract_id%TYPE,
                                     p_item_no    IN GIXX_BENEFICIARY.item_no%TYPE) 
      RETURN pol_doc_beneficiary_tab PIPELINED;
      
      
    -- added by Kris 03.01.2013 for GIPIS101
    TYPE beneficiary_type IS RECORD (
      extract_id          gixx_beneficiary.extract_id%TYPE,
      policy_id           gixx_beneficiary.policy_id%TYPE,
      item_no             gixx_beneficiary.item_no%TYPE,
      age                 gixx_beneficiary.age%TYPE,
      sex                 gixx_beneficiary.sex%TYPE,
      relation            gixx_beneficiary.relation%TYPE,
      adult_sw            gixx_beneficiary.adult_sw%TYPE,
      delete_sw           gixx_beneficiary.delete_sw%TYPE,
      position_cd         gixx_beneficiary.position_cd%TYPE,
      civil_status        gixx_beneficiary.civil_status%TYPE,
      date_of_birth       gixx_beneficiary.date_of_birth%TYPE,
      beneficiary_no      gixx_beneficiary.beneficiary_no%TYPE,
      beneficiary_name    gixx_beneficiary.beneficiary_name%TYPE,
      beneficiary_addr    gixx_beneficiary.beneficiary_addr%TYPE,
      cpi_branch_cd       gixx_beneficiary.cpi_branch_cd%TYPE,
      cpi_rec_no          gixx_beneficiary.cpi_rec_no%TYPE,
      remarks             gixx_beneficiary.remarks%TYPE,
      
      position            giis_position.POSITION%TYPE,
      mean_sex            cg_ref_codes.RV_MEANING%TYPE,
      mean_civil_status   cg_ref_codes.RV_MEANING%TYPE
    );
    
    TYPE beneficiary_tab IS TABLE OF beneficiary_type;
    
    FUNCTION get_beneficiaries (
        p_extract_id    gixx_beneficiary.extract_id%TYPE,
        p_item_no       gixx_beneficiary.item_no%TYPE
    ) RETURN beneficiary_tab PIPELINED;
    -- end 03.01.2013 for GIPIS101

END GIXX_BENEFICIARY_PKG;
/


