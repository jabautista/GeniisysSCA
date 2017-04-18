CREATE OR REPLACE PACKAGE CPI.GICLS125_PKG
AS
    
    TYPE reopen_recovery_type IS RECORD (
        recovery_id         NUMBER(12),--
        claim_id            NUMBER(12),--
        recovery_no         VARCHAR2(100),
        claim_no            VARCHAR2(100),
        recovery_type       VARCHAR(100),
        status              VARCHAR2(100),
        policy_no           VARCHAR2(100),
        assd_name           VARCHAR2(500),
        loss_cat_desc       VARCHAR2(100),
        loss_date           DATE,
        clm_file_date       DATE,
        --details
        lawyer_cd           NUMBER(12),
        lawyer_class_cd     VARCHAR2(2),--
        lawyer_name         VARCHAR2(600),
        tp_item_desc        VARCHAR2(500),
        recoverable_amt     NUMBER(16,2),
        recovered_amt       NUMBER(16,2),
        plate_no            VARCHAR2(20),
        line_cd             giis_line.line_cd%TYPE  --Gzelle 09102015 SR3292
        
    );
    TYPE reopen_recovery_tab IS TABLE OF reopen_recovery_type;
    
    FUNCTION get_reopen_recovery(
        p_claim_id      VARCHAR2,
        p_module_id     VARCHAR2,
        p_user_id       VARCHAR2,
        p_line_cd       VARCHAR2    --Gzelle 09102015 SR3292
    )
        RETURN reopen_recovery_tab PIPELINED;
        
     PROCEDURE reopen_recovery_gicls125(
        p_claim_id          NUMBER,
        p_recovery_id       NUMBER,
        p_user_id           VARCHAR2
    );
END;
/


