CREATE OR REPLACE PACKAGE CPI.GIPI_WGRP_ITEM_BENEFICIARY_PKG 
AS
    /*    Date        Author            Description
    **    ==========    ===============    ============================
    **    xx.xx.xxxx    xxxxxxx            created this package
    **    10.04.2011    mark jm            added civil_status_desc in gipi_wgrp_items_ben_type
    */
    TYPE gipi_wgrp_items_ben_type IS RECORD(
        par_id                 gipi_wgrp_items_beneficiary.par_id%TYPE,
        item_no             gipi_wgrp_items_beneficiary.item_no%TYPE,
        grouped_item_no     gipi_wgrp_items_beneficiary.grouped_item_no%TYPE,
        beneficiary_no         gipi_wgrp_items_beneficiary.beneficiary_no%TYPE,
        beneficiary_name     gipi_wgrp_items_beneficiary.beneficiary_name%TYPE,
        beneficiary_addr     gipi_wgrp_items_beneficiary.beneficiary_addr%TYPE,
        relation             gipi_wgrp_items_beneficiary.relation%TYPE,
        date_of_birth         gipi_wgrp_items_beneficiary.date_of_birth%TYPE,
        age                 gipi_wgrp_items_beneficiary.age%TYPE,
        civil_status         gipi_wgrp_items_beneficiary.civil_status%TYPE,
        sex                 gipi_wgrp_items_beneficiary.sex%TYPE,
        civil_status_desc    cg_ref_codes.rv_meaning%TYPE);
  
    TYPE gipi_wgrp_items_ben_tab IS TABLE OF gipi_wgrp_items_ben_type;    
  
  FUNCTION get_gipi_wgrp_item_benificiary(p_par_id    GIPI_WGRP_ITEMS_BENEFICIARY.par_id%TYPE,
                                                p_item_no   GIPI_WGRP_ITEMS_BENEFICIARY.item_no%TYPE)
    RETURN gipi_wgrp_items_ben_tab PIPELINED;        
    
  PROCEDURE set_gipi_wgrp_item_benificiary(
              p_par_id                  GIPI_WGRP_ITEMS_BENEFICIARY.par_id%TYPE,
                 p_item_no                   GIPI_WGRP_ITEMS_BENEFICIARY.item_no%TYPE,
            p_grouped_item_no          GIPI_WGRP_ITEMS_BENEFICIARY.grouped_item_no%TYPE,                         
            p_beneficiary_no          GIPI_WGRP_ITEMS_BENEFICIARY.beneficiary_no%TYPE,        
            p_beneficiary_name          GIPI_WGRP_ITEMS_BENEFICIARY.beneficiary_name%TYPE,        
            p_beneficiary_addr          GIPI_WGRP_ITEMS_BENEFICIARY.beneficiary_addr%TYPE,        
            p_relation                  GIPI_WGRP_ITEMS_BENEFICIARY.relation%TYPE,        
            p_date_of_birth              GIPI_WGRP_ITEMS_BENEFICIARY.date_of_birth%TYPE,        
            p_age                      GIPI_WGRP_ITEMS_BENEFICIARY.age%TYPE,        
            p_civil_status              GIPI_WGRP_ITEMS_BENEFICIARY.civil_status%TYPE,        
            p_sex                      GIPI_WGRP_ITEMS_BENEFICIARY.sex%TYPE
              );    

  PROCEDURE del_gipi_wgrp_item_benificiary(p_par_id    GIPI_WGRP_ITEMS_BENEFICIARY.par_id%TYPE,
                                             p_item_no   GIPI_WGRP_ITEMS_BENEFICIARY.item_no%TYPE);            
    
  PROCEDURE del_gipi_wgrp_item_ben2(p_par_id             GIPI_WGRP_ITEMS_BENEFICIARY.par_id%TYPE,
                                      p_item_no         GIPI_WGRP_ITEMS_BENEFICIARY.item_no%TYPE,
                                    p_grouped_item_no GIPI_WGRP_ITEMS_BENEFICIARY.grouped_item_no%TYPE);    
                                                
  PROCEDURE del_gipi_wgrp_item_ben3(p_par_id          GIPI_WGRP_ITEMS_BENEFICIARY.par_id%TYPE,
                                      p_item_no         GIPI_WGRP_ITEMS_BENEFICIARY.item_no%TYPE,
                                    p_grouped_item_no GIPI_WGRP_ITEMS_BENEFICIARY.grouped_item_no%TYPE,
                                    p_beneficiary_no  GIPI_WGRP_ITEMS_BENEFICIARY.beneficiary_no%TYPE);
                                    
  FUNCTION get_gipi_wgrp_itm_benificiary2(p_par_id    GIPI_WGRP_ITEMS_BENEFICIARY.par_id%TYPE)
    RETURN gipi_wgrp_items_ben_tab PIPELINED;        
    
  FUNCTION rgitm_gipi_wgrpitem_ben(p_par_id                 GIPI_WGROUPED_ITEMS.par_id%TYPE,
                                             p_policy_id                 GIPI_GROUPED_ITEMS.policy_id%TYPE,
                                        p_item_no                 GIPI_GROUPED_ITEMS.item_no%TYPE,
                                        p_grouped_item_no         GIPI_GROUPED_ITEMS.grouped_item_no%TYPE
                                               )                                      
      RETURN gipi_wgrp_items_ben_tab PIPELINED;

    FUNCTION get_gipi_wgrp_item_ben_tg (
        p_par_id IN gipi_wgrp_items_beneficiary.par_id%TYPE,
        p_item_no IN gipi_wgrp_items_beneficiary.item_no%TYPE,
        p_grouped_item_no IN gipi_wgrp_items_beneficiary.grouped_item_no%TYPE,
        p_beneficiary_name IN gipi_wgrp_items_beneficiary.beneficiary_name%TYPE)
    RETURN gipi_wgrp_items_ben_tab PIPELINED;
    
    FUNCTION get_group_beneficiary_listing(
        p_par_id            GIPI_WGRP_ITEMS_BENEFICIARY.par_id%TYPE,
        p_item_no           GIPI_WGRP_ITEMS_BENEFICIARY.item_no%TYPE,
        p_grouped_item_no   GIPI_WGRP_ITEMS_BENEFICIARY.grouped_item_no%TYPE,
        p_beneficiary_no    GIPI_WGRP_ITEMS_BENEFICIARY.beneficiary_no%TYPE,
        p_beneficiary_name  GIPI_WGRP_ITEMS_BENEFICIARY.beneficiary_name%TYPE,
        p_sex               GIPI_WGRP_ITEMS_BENEFICIARY.sex%TYPE,
        p_relation          GIPI_WGRP_ITEMS_BENEFICIARY.relation%TYPE,
        p_civil_status      GIPI_WGRP_ITEMS_BENEFICIARY.civil_status%TYPE,
        p_date_of_birth     VARCHAR2,
        p_age               GIPI_WGRP_ITEMS_BENEFICIARY.age%TYPE,
        p_beneficiary_addr  GIPI_WGRP_ITEMS_BENEFICIARY.beneficiary_addr%TYPE
    )
      RETURN gipi_wgrp_items_ben_tab PIPELINED;
      
    PROCEDURE validate_ben_no(
        p_par_id            IN  GIPI_WGRP_ITEMS_BENEFICIARY.par_id%TYPE,
        p_item_no           IN  GIPI_WGRP_ITEMS_BENEFICIARY.item_no%TYPE,
        p_grouped_item_no   IN  GIPI_WGRP_ITEMS_BENEFICIARY.grouped_item_no%TYPE,
        p_ben_no            IN  GIPI_WGRP_ITEMS_BENEFICIARY.beneficiary_no%TYPE,
        p_message           OUT VARCHAR2
    );
   --added by MarkS SR21720 10.5.2016 to handle checking of unique beneficiary no. from all item_no(enrollee) not by grouped_item_no(per enrollee)
   PROCEDURE validate_ben_no2(
        p_par_id            IN  GIPI_WGRP_ITEMS_BENEFICIARY.par_id%TYPE,
        p_item_no           IN  GIPI_WGRP_ITEMS_BENEFICIARY.item_no%TYPE,
        p_grouped_item_no   IN  GIPI_WGRP_ITEMS_BENEFICIARY.grouped_item_no%TYPE,
        p_ben_no            IN  GIPI_WGRP_ITEMS_BENEFICIARY.beneficiary_no%TYPE,
        p_message           OUT VARCHAR2
    );
    --END SR21720
    
END;
/


