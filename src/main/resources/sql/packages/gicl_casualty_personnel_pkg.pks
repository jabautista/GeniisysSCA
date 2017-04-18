CREATE OR REPLACE PACKAGE CPI.GICL_CASUALTY_PERSONNEL_PKG
AS
/**
* Rey Jadlocon
* 10-17-2011
**/

 PROCEDURE del_gicl_casualty_personnel(
            p_claim_id          gicl_casualty_personnel.claim_id%TYPE,
            p_item_no           gicl_casualty_personnel.item_no%TYPE
            );
/**
* Rey Jadlocon
*10-17-2011
**/

TYPE personnel_list_type IS RECORD(
        item_no                 gicl_casualty_personnel.item_no%TYPE,
        personnel_no            gicl_casualty_personnel.personnel_no%TYPE,
        name                    gicl_casualty_personnel.name%TYPE,
        include_tag             gicl_casualty_personnel.include_tag%TYPE,
        user_id                 gicl_casualty_personnel.user_id%TYPE,
        last_update             gicl_casualty_personnel.last_update%TYPE,
        capacity_cd             gicl_casualty_personnel.capacity_cd%TYPE,
        position                giis_position.position%TYPE,
        amount_covered          gicl_casualty_personnel.amount_covered%TYPE,
        remarks                 gicl_casualty_personnel.remarks%TYPE,
        claim_id                gicl_casualty_personnel.claim_id%TYPE
            );
    TYPE personnel_list_tab IS TABLE OF personnel_list_type;
    
    FUNCTION get_personnel_list(
                            p_claim_id          gicl_casualty_personnel.claim_id%TYPE,
                            p_item_no           gicl_casualty_personnel.item_no%TYPE)
       RETURN personnel_list_tab PIPELINED;
       
/**
* Rey Jadlocon
* 02-22-2012
**/
TYPE personnel_lov_type IS RECORD(
        personnel_no            gipi_casualty_personnel.personnel_no%TYPE,
        name                    gipi_casualty_personnel.name%TYPE,
        capacity_cd             number,
        amount_covered          number,
        position                varchar2(100));
   TYPE personnel_lov_tab IS TABLE OF personnel_lov_type;
   
   FUNCTION personnel_lov(p_dsp_line_cd            VARCHAR2,
                          p_subline_cd             VARCHAR2,
                          p_pol_iss_cd             VARCHAR2,
                          p_issue_yy               NUMBER,
                          p_pol_seq_no             NUMBER,
                          p_renew_no               NUMBER,
                          p_item_no                NUMBER,
                          p_claim_id               NUMBER,
                          p_personnel_no           NUMBER,
                          p_loss_date              DATE,
                          p_expiry_date            DATE)
       RETURN personnel_lov_tab PIPELINED;      
 
/**
* Rey Jadlocon
* 03-07-2012
**/
PROCEDURE insert_delete_personnel(p_claim_id                gicl_casualty_personnel.claim_id%TYPE,
                                  p_item_no                 gicl_casualty_personnel.item_no%TYPE,
                                  p_personnel_no            gicl_casualty_personnel.personnel_no%TYPE,
                                  p_name                    gicl_casualty_personnel.name%TYPE,
                                  p_include_tag             gicl_casualty_personnel.include_tag%TYPE,
                                  p_user_id                 gicl_casualty_personnel.user_id%TYPE,
                                  p_last_update             gicl_casualty_personnel.last_update%TYPE,
                                  p_capacity_cd             gicl_casualty_personnel.capacity_cd%TYPE,
                                  p_amount_covered          gicl_casualty_personnel.amount_covered%TYPE
                                  );
    
/**
* Rey Jadlocon
* 03-29-2012
**/
PROCEDURE delete_personnel(p_claim_id                gicl_casualty_personnel.claim_id%TYPE,
                           p_item_no                 gicl_casualty_personnel.item_no%TYPE,
                           p_personnel_no            gicl_casualty_personnel.personnel_no%TYPE);

PROCEDURE delete_personnel_by_item(p_claim_id                gicl_casualty_personnel.claim_id%TYPE,
                           p_item_no                 gicl_casualty_personnel.item_no%TYPE);
                           

END GICL_CASUALTY_PERSONNEL_PKG;
/


