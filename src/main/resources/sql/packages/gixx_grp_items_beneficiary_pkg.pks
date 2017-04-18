CREATE OR REPLACE PACKAGE CPI.GIXX_GRP_ITEMS_BENEFICIARY_PKG AS

    TYPE pol_doc_ah_grp_items_ben_type IS RECORD(
      extract_id        GIXX_GRP_ITEMS_BENEFICIARY.extract_id%TYPE,
      item_no           GIXX_GRP_ITEMS_BENEFICIARY.item_no%TYPE,
      grouped_item_no   GIXX_GRP_ITEMS_BENEFICIARY.grouped_item_no%TYPE,
      beneficiary_no    GIXX_GRP_ITEMS_BENEFICIARY.beneficiary_no%TYPE,
      beneficiary_name  GIXX_GRP_ITEMS_BENEFICIARY.beneficiary_name%TYPE,
      beneficiary_addr  GIXX_GRP_ITEMS_BENEFICIARY.beneficiary_addr%TYPE,
      relation          GIXX_GRP_ITEMS_BENEFICIARY.relation%TYPE,
      age               GIXX_GRP_ITEMS_BENEFICIARY.age%TYPE,
      sex               GIXX_GRP_ITEMS_BENEFICIARY.sex%TYPE,
      date_of_birth     GIXX_GRP_ITEMS_BENEFICIARY.date_of_birth%TYPE
      );
      
    TYPE pol_doc_ah_grp_items_ben_tab IS TABLE OF pol_doc_ah_grp_items_ben_type;
    
    FUNCTION get_pol_doc_ah_grp_items_ben(p_extract_id      IN GIXX_GRP_ITEMS_BENEFICIARY.extract_id%TYPE,
                                          p_item_no         IN GIXX_GRP_ITEMS_BENEFICIARY.item_no%TYPE,
                                          p_grouped_item_no IN GIXX_GRP_ITEMS_BENEFICIARY.grouped_item_no%TYPE) 
      RETURN pol_doc_ah_grp_items_ben_tab PIPELINED;
      
      
    -- added by Kris 02.28.2013 for GIPIS101
    TYPE grp_items_beneficiary_type IS RECORD (
        age                 gixx_grp_items_beneficiary.age%TYPE,
        sex                 gixx_grp_items_beneficiary.sex%TYPE,
        item_no             gixx_grp_items_beneficiary.item_no%TYPE,
        relation            gixx_grp_items_beneficiary.relation%TYPE,
        policy_id           gixx_grp_items_beneficiary.policy_id%TYPE,
        civil_status        gixx_grp_items_beneficiary.civil_status%TYPE,
        date_of_birth       gixx_grp_items_beneficiary.date_of_birth%TYPE,
        beneficiary_no      gixx_grp_items_beneficiary.beneficiary_no%TYPE,
        grouped_item_no     gixx_grp_items_beneficiary.grouped_item_no%TYPE,
        beneficiary_name    gixx_grp_items_beneficiary.beneficiary_name%TYPE,
        beneficiary_addr    gixx_grp_items_beneficiary.beneficiary_addr%TYPE
    );
    
    TYPE grp_items_beneficiary_tab IS TABLE OF grp_items_beneficiary_type;
    
    FUNCTION get_grp_items_beneficiaries(
       p_extract_id          gixx_grp_items_beneficiary.extract_id%TYPE,
       p_item_no            gixx_grp_items_beneficiary.item_no%TYPE,
       p_grouped_item_no    gixx_grp_items_beneficiary.grouped_item_no%TYPE
    ) RETURN grp_items_beneficiary_tab PIPELINED;
    -- end 02.28.2013 for GIPIS101

END GIXX_GRP_ITEMS_BENEFICIARY_PKG;
/


