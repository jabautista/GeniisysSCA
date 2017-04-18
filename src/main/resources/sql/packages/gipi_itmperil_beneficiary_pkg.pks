CREATE OR REPLACE PACKAGE CPI.gipi_itmperil_beneficiary_pkg AS

  TYPE itmperil_beneficiary_type IS RECORD (
  
    
    policy_id           gipi_itmperil_beneficiary.policy_id%TYPE,
    item_no             gipi_itmperil_beneficiary.item_no%TYPE,
    grouped_item_no     gipi_itmperil_beneficiary.grouped_item_no%TYPE,
    line_cd             gipi_itmperil_beneficiary.line_cd%TYPE,
    peril_cd            gipi_itmperil_beneficiary.peril_cd%TYPE,
    tsi_amt             gipi_itmperil_beneficiary.tsi_amt%TYPE,
    peril_name          giis_peril.peril_name%TYPE

  );

  TYPE itmperil_beneficiary_tab IS TABLE OF itmperil_beneficiary_type;
  
    FUNCTION get_itmperil_beneficiaries (
       p_policy_id         gipi_itmperil_beneficiary.policy_id%TYPE,
       p_item_no           gipi_itmperil_beneficiary.item_no%TYPE,
       p_grouped_item_no   gipi_itmperil_beneficiary.grouped_item_no%TYPE
    )
       RETURN itmperil_beneficiary_tab PIPELINED;
       
END gipi_itmperil_beneficiary_pkg;
/


