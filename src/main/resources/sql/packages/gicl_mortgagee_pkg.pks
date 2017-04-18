CREATE OR REPLACE PACKAGE CPI.gicl_mortgagee_pkg
AS

    TYPE gicl_mortgagee_type IS RECORD(
        claim_id        gicl_mortgagee.claim_id%TYPE,
        item_no         gicl_mortgagee.item_no%TYPE,
        mortg_cd        gicl_mortgagee.mortg_cd%TYPE,
        amount          gicl_mortgagee.amount%TYPE,
        user_id         gicl_mortgagee.user_id%TYPE,
        last_update     gicl_mortgagee.last_update%TYPE,
        iss_cd          gicl_mortgagee.iss_cd%TYPE,
        nbt_mortg_nm    giis_mortgagee.mortg_name%TYPE
        );
        
    TYPE gicl_mortgagee_tab IS TABLE OF gicl_mortgagee_type;

    FUNCTION get_gicl_mortgagee_exist( 
        p_claim_id          gicl_mortgagee.claim_id%TYPE
        ) RETURN VARCHAR2;

    FUNCTION get_gicl_mortgagee_exist(
        p_item_no           gicl_mortgagee.item_no%TYPE,
        p_claim_id          gicl_mortgagee.claim_id%TYPE
        ) RETURN VARCHAR2;
    
    FUNCTION check_exist_gicl_mortgagee
    (p_claim_id     IN  GICL_CLAIMS.claim_id%TYPE,
     p_pol_iss_cd   IN  GICL_CLAIMS.pol_iss_cd%TYPE,
     p_item_no      IN  GICL_ITEM_PERIL.item_no%TYPE)
    RETURN VARCHAR2;    

    FUNCTION get_gicl_mortgagee(
        p_claim_id          gicl_mortgagee.claim_id%TYPE,
        p_item_no           gicl_mortgagee.item_no%TYPE
        ) 
    RETURN gicl_mortgagee_tab PIPELINED;
    
    PROCEDURE del_gicl_mortgagee(
        p_claim_id      gicl_mortgagee.claim_id%TYPE,
        p_item_no       gicl_mortgagee.item_no%TYPE
        );
            
END gicl_mortgagee_pkg;
/


