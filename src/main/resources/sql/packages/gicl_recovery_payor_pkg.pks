CREATE OR REPLACE PACKAGE CPI.gicl_recovery_payor_pkg
AS 
    TYPE recovery_payor_list_type IS RECORD(
        recovery_id         gicl_recovery_payor.recovery_id%TYPE,
        claim_id            gicl_recovery_payor.claim_id%TYPE,
        payor_class_cd      gicl_recovery_payor.payor_class_cd%TYPE, 
        payor_cd            gicl_recovery_payor.payor_cd%TYPE, 
        recovered_amt       gicl_recovery_payor.recovered_amt%TYPE,
        cpi_rec_no          gicl_recovery_payor.cpi_rec_no%TYPE,
        cpi_branch_cd       gicl_recovery_payor.cpi_branch_cd%TYPE,    
        user_id             gicl_recovery_payor.user_id%TYPE,
        last_update         gicl_recovery_payor.last_update%TYPE,
        class_desc          giis_payee_class.class_desc%TYPE,
        payor_name          VARCHAR2(32000)
        );
        
    TYPE recovery_payor_list_tab IS TABLE OF recovery_payor_list_type;    

    FUNCTION get_recovery_payor_list
    RETURN recovery_payor_list_tab PIPELINED;
    
    FUNCTION get_gicl_recovery_payor(
        p_claim_id          gicl_recovery_payor.claim_id%TYPE,
        p_recovery_id       gicl_recovery_payor.recovery_id%TYPE
        )
    RETURN recovery_payor_list_tab PIPELINED;

    PROCEDURE del_gicl_recovery_payor(
        p_recovery_id           gicl_recovery_payor.recovery_id%TYPE,
        p_claim_id              gicl_recovery_payor.claim_id%TYPE,
        p_payor_class_cd        gicl_recovery_payor.payor_class_cd%TYPE,   
        p_payor_cd              gicl_recovery_payor.payor_cd%TYPE
        );

    PROCEDURE set_gicl_recovery_payor(
        p_recovery_id         gicl_recovery_payor.recovery_id%TYPE,
        p_claim_id            gicl_recovery_payor.claim_id%TYPE,
        p_payor_class_cd      gicl_recovery_payor.payor_class_cd%TYPE, 
        p_payor_cd            gicl_recovery_payor.payor_cd%TYPE, 
        p_recovered_amt       gicl_recovery_payor.recovered_amt%TYPE,
        p_cpi_rec_no          gicl_recovery_payor.cpi_rec_no%TYPE,
        p_cpi_branch_cd       gicl_recovery_payor.cpi_branch_cd%TYPE,    
        p_user_id             gicl_recovery_payor.user_id%TYPE,
        p_last_update         gicl_recovery_payor.last_update%TYPE
        );
          
END;
/


