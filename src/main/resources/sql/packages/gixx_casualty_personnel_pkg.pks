CREATE OR REPLACE PACKAGE CPI.GIXX_CASUALTY_PERSONNEL_PKG AS

    TYPE pol_doc_ca_personnel_type IS RECORD(
      extract_id                GIXX_CASUALTY_PERSONNEL.extract_id%TYPE,
      item_no                   GIXX_CASUALTY_PERSONNEL.item_no%TYPE,
      personnel_no              GIXX_CASUALTY_PERSONNEL.personnel_no%TYPE,
      cpersonnel_name           GIXX_CASUALTY_PERSONNEL.name%TYPE,
      cpersonnel_position       GIIS_POSITION.position%TYPE,
      cpersonnel_capacity_cd    GIXX_CASUALTY_PERSONNEL.capacity_cd%TYPE,
      cpersonnel_amt_covered    GIXX_CASUALTY_PERSONNEL.amount_covered%TYPE,
      cpersonnel_remarks        GIXX_CASUALTY_PERSONNEL.remarks%TYPE
      );
      
    TYPE pol_doc_ca_personnel_tab IS TABLE OF pol_doc_ca_personnel_type;
    
    FUNCTION get_pol_doc_ca_personnel(p_extract_id IN GIXX_CASUALTY_PERSONNEL.extract_id%TYPE,
                                      p_item_no    IN GIXX_CASUALTY_PERSONNEL.item_no%TYPE) 
      RETURN pol_doc_ca_personnel_tab PIPELINED;
    
    FUNCTION get_pack_pol_doc_ca_personnel(p_extract_id IN GIXX_CASUALTY_PERSONNEL.extract_id%TYPE,
                                           p_policy_id  IN GIXX_CASUALTY_PERSONNEL.policy_id%TYPE,                  
                                           p_item_no    IN GIXX_CASUALTY_PERSONNEL.item_no%TYPE) 
      RETURN pol_doc_ca_personnel_tab PIPELINED;
      
    FUNCTION get_personnel_amt_coverage(p_extract_id   IN GIXX_CASUALTY_PERSONNEL.extract_id%TYPE,
                              	        p_amt_coverage IN GIXX_CASUALTY_PERSONNEL.amount_covered%TYPE) 
     RETURN NUMBER;
          
    -- added by Kris 03.05.2013 for GIPIS101
    TYPE gixx_casualty_personnel_type IS RECORD (
        extract_id          gixx_casualty_personnel.extract_id%TYPE,
        item_no             gixx_casualty_personnel.item_no%TYPE,
        personnel_no        gixx_casualty_personnel.personnel_no%TYPE,
        name                gixx_casualty_personnel.name%TYPE,
        capacity_cd         gixx_casualty_personnel.capacity_cd%TYPE,
        amount_covered      gixx_casualty_personnel.amount_covered%TYPE,
        policy_id           gixx_casualty_personnel.policy_id%TYPE,
        include_tag         gixx_casualty_personnel.include_tag%TYPE,
        remarks             gixx_casualty_personnel.remarks%TYPE,
        delete_sw           gixx_casualty_personnel.delete_sw%TYPE 
    );
    
    TYPE gixx_casualty_personnel_tab IS TABLE OF gixx_casualty_personnel_type;
    
    FUNCTION get_casualty_personnel_info(
        p_extract_id       gixx_casualty_personnel.extract_id%TYPE,
        p_item_no          gixx_casualty_personnel.item_no%TYPE
    ) RETURN gixx_casualty_personnel_tab PIPELINED;
    -- end 03.05.2013 for GIPIS101
    

END GIXX_CASUALTY_PERSONNEL_PKG;
/


