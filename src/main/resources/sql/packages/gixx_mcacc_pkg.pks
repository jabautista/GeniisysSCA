CREATE OR REPLACE PACKAGE CPI.GIXX_MCACC_PKG AS

    TYPE pol_doc_accessory_type IS RECORD(
         extract_id                GIXX_MCACC.extract_id%TYPE,
         mcacc_item_no             GIXX_MCACC.item_no%TYPE,
         accessory_accessory_desc  GIIS_ACCESSORY.accessory_desc%TYPE,
         mcacc_acc_amt             GIXX_MCACC.acc_amt%TYPE,
         f_acc_amt                 GIXX_MCACC.acc_amt%TYPE
         );
      
    TYPE pol_doc_accessory_tab IS TABLE OF pol_doc_accessory_type;
    
    FUNCTION get_pol_doc_accessory(p_extract_id IN GIXX_MCACC.extract_id%TYPE,
                                   p_item_no    IN GIXX_MCACC.item_no%TYPE) 
      RETURN pol_doc_accessory_tab PIPELINED;
    
    FUNCTION get_pack_pol_doc_accessory(p_extract_id IN GIXX_MCACC.extract_id%TYPE,
                                        p_policy_id  IN GIXX_MCACC.policy_id%TYPE,
                                        p_item_no    IN GIXX_MCACC.item_no%TYPE) 
      RETURN pol_doc_accessory_tab PIPELINED;
      
    -- added by Kris 03.07.2013 for GIPIS101
    TYPE mcacc_type IS RECORD (
        extract_id              gixx_mcacc.extract_id%TYPE,
        item_no                 gixx_mcacc.item_no%TYPE,
        accessory_cd            gixx_mcacc.accessory_cd%TYPE,
        acc_amt                 gixx_mcacc.acc_amt%TYPE,
        policy_id               gixx_mcacc.policy_id%TYPE,
        
        accessory_desc          giis_accessory.accessory_desc%TYPE,
        total_acc_amt           NUMBER(20,2)
    );
    
    TYPE mcacc_tab IS TABLE OF mcacc_type;
    
    FUNCTION get_mcacc_list (
        p_extract_id        GIXX_MCACC.EXTRACT_ID%TYPE,
        p_item_no           gixx_mcacc.item_no%TYPE
    ) RETURN mcacc_tab PIPELINED;
    -- end 03.07.2013 for GIPIS101

END GIXX_MCACC_PKG;
/


