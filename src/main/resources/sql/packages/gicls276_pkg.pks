CREATE OR REPLACE PACKAGE CPI.GICLS276_PKG
AS
    TYPE clm_list_per_lawyer_type IS RECORD (
        claim_id        GICL_CLAIMS.claim_id%TYPE,
        line_cd         GICL_CLAIMS.line_cd%TYPE,
        subline_cd      GICL_CLAIMS.subline_cd%TYPE,
        iss_cd          GICL_CLAIMS.iss_cd%TYPE,
        clm_yy          GICL_CLAIMS.clm_yy%TYPE,
        clm_seq_no      GICL_CLAIMS.clm_seq_no%TYPE,
        issue_yy        GICL_CLAIMS.issue_yy%TYPE,
        pol_seq_no      GICL_CLAIMS.pol_seq_no%TYPE,
        renew_no        GICL_CLAIMS.renew_no%TYPE,
        pol_iss_cd      GICL_CLAIMS.pol_iss_cd%TYPE,
        loss_date       GICL_CLAIMS.loss_date%TYPE,
        clm_stat_cd     GICL_CLAIMS.clm_stat_cd%TYPE,
        assured_name    GICL_CLAIMS.assured_name%TYPE,
        clm_file_date   GICL_CLAIMS.clm_file_date%TYPE,
        lawyer_cd       GICL_CLM_RECOVERY.lawyer_cd%TYPE,
        lawyer_class_cd GICL_CLM_RECOVERY.lawyer_class_cd%TYPE,
        recovery_id     GICL_CLM_RECOVERY.recovery_id%TYPE,    
        rec_year        GICL_CLM_RECOVERY.rec_year%TYPE,
        rec_seq_no      GICL_CLM_RECOVERY.rec_seq_no%TYPE,
        recoverable_amt GICL_CLM_RECOVERY.recoverable_amt%TYPE,
        recovered_amt   GICL_CLM_RECOVERY.recovered_amt%TYPE,
        cancel_tag      GICL_CLM_RECOVERY.cancel_tag%TYPE,
        case_no         GICL_CLM_RECOVERY.case_no%TYPE,
        court           GICL_CLM_RECOVERY.court%TYPE,
        payor_cd        GICL_RECOVERY_PAYOR.payor_cd%TYPE,
        payor_class_cd  GICL_RECOVERY_PAYOR.payor_class_cd%TYPE,
        payee_full_name VARCHAR2(150),
        class_desc      GIIS_PAYEE_CLASS.class_desc%TYPE,
        recovery_no        VARCHAR2(150),
        claim_no        VARCHAR2(150),
        policy_no       VARCHAR2(150),
        clm_stat_desc     GIIS_CLM_STAT.clm_stat_desc%TYPE
        
    );
    TYPE clm_list_per_lawyer_tab IS TABLE OF clm_list_per_lawyer_type;
    
    TYPE lawyer_list_lov_type IS RECORD (
        lawyer_cd   GICL_CLM_RECOVERY.lawyer_cd%TYPE,
        lawyer_name VARCHAR2(150)
    );
    TYPE lawyer_list_lov_tab IS TABLE OF lawyer_list_lov_type;
    
    FUNCTION get_lawyer_list_lov
            RETURN lawyer_list_lov_tab PIPELINED;
    

    FUNCTION get_clm_list_per_lawyer ( 
            p_user_id                 GIIS_USERS.user_id%TYPE,
            p_lawyer_cd               GICL_CLM_RECOVERY.lawyer_cd%TYPE,
            p_search_by               VARCHAR2,
            p_as_of_date              VARCHAR2,
            p_from_date               VARCHAR2,   
            p_to_date                 VARCHAR2
       )
            RETURN clm_list_per_lawyer_tab PIPELINED;
            
    FUNCTION validate_lawyer(
        p_lawyer    VARCHAR2
    )
        RETURN VARCHAR2;
            
    
    TYPE per_lawyer_type IS RECORD (
        lawyer_cd           NUMBER(12),
        claim_id            NUMBER(12),
        recovery_id         NUMBER(12),
        recovery_no         VARCHAR2(100),
        case_no             VARCHAR2(100),
        class_desc          VARCHAR2(30),
        payee_name          VARCHAR2(1000),
        rec_stat_desc       VARCHAR2(30),
        recoverable_amt     NUMBER(16,2),
        recovered_amt       NUMBER(16,2),    
        claim_no            VARCHAR2(100),  
        policy_no           VARCHAR2(100),  
        court               VARCHAR2(200),
        assd_name           VARCHAR2(500),
        clm_stat_desc       VARCHAR2(30),
        clm_file_date       DATE,
        loss_date           DATE
    );
    TYPE per_lawyer_tab IS TABLE OF per_lawyer_type;
    
    FUNCTION get_per_lawyer( 
                p_user_id                 VARCHAR2,
                p_lawyer_cd               VARCHAR2,
                p_search_by               VARCHAR2,
                p_as_of_date              VARCHAR2,
                p_from_date               VARCHAR2,   
                p_to_date                 VARCHAR2
           )
        RETURN per_lawyer_tab PIPELINED;
        
   TYPE recovery_details_type IS RECORD (
      recovery_id       gicl_clm_recovery.recovery_id%TYPE,
      recovery_no       VARCHAR2 (50),
      recoverable_amt   gicl_clm_recovery.recoverable_amt%TYPE,
      recovered_amt     gicl_clm_recovery.recovered_amt%TYPE,
      lawyer            VARCHAR2 (255),
      plate_no          gicl_clm_recovery.plate_no%TYPE,
      status            VARCHAR2 (50),
      tp_item_desc      gicl_clm_recovery.tp_item_desc%TYPE
   );

   TYPE recovery_details_tab IS TABLE OF recovery_details_type;

   FUNCTION get_recovery_details (p_claim_id gicl_clm_recovery.claim_id%TYPE, p_recovery_id gicl_clm_recovery.recovery_id%TYPE)
      RETURN recovery_details_tab PIPELINED;
END;
/


