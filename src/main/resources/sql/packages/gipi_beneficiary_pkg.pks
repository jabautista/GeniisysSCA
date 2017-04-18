CREATE OR REPLACE PACKAGE CPI.gipi_beneficiary_pkg
AS
   TYPE gipi_beneficiary_type IS RECORD (
      policy_id           gipi_beneficiary.policy_id%TYPE,
      item_no             gipi_beneficiary.item_no%TYPE,
      age                 gipi_beneficiary.age%TYPE,
      sex                 gipi_beneficiary.sex%TYPE,
      relation            gipi_beneficiary.relation%TYPE,
      adult_sw            gipi_beneficiary.adult_sw%TYPE,
      delete_sw           gipi_beneficiary.delete_sw%TYPE,
      position_cd         gipi_beneficiary.position_cd%TYPE,
      civil_status        gipi_beneficiary.civil_status%TYPE,
      date_of_birth       gipi_beneficiary.date_of_birth%TYPE,
      beneficiary_no      gipi_beneficiary.beneficiary_no%TYPE,
      beneficiary_name    gipi_beneficiary.beneficiary_name%TYPE,
      beneficiary_addr    gipi_beneficiary.beneficiary_addr%TYPE,
      cpi_branch_cd       gipi_beneficiary.cpi_branch_cd%TYPE,
      arc_ext_data        gipi_beneficiary.arc_ext_data%TYPE,
      cpi_rec_no          gipi_beneficiary.cpi_rec_no%TYPE,
      remarks             gipi_beneficiary.remarks%TYPE,
      
      position            giis_position.POSITION%TYPE,
      mean_sex            cg_ref_codes.RV_MEANING%TYPE,
      mean_civil_status   cg_ref_codes.RV_MEANING%TYPE
      
   );

   TYPE gipi_beneficiary_tab IS TABLE OF gipi_beneficiary_type;

   FUNCTION get_gipi_beneficiaries (
      p_policy_id   gipi_beneficiary.policy_id%TYPE,
      p_item_no     gipi_beneficiary.item_no%TYPE
   )
      RETURN gipi_beneficiary_tab PIPELINED;
      
    FUNCTION get_gipi_beneficiary (
        p_par_id IN gipi_parlist.par_id%TYPE,
        p_item_no IN gipi_beneficiary.item_no%TYPE,
        p_ben_no IN gipi_beneficiary.beneficiary_no%TYPE)
    RETURN gipi_beneficiary_tab PIPELINED;
END gipi_beneficiary_pkg;
/


