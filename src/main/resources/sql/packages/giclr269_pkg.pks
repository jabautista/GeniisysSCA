CREATE OR REPLACE PACKAGE CPI.GICLR269_PKG AS 
    
  TYPE giclr269_type IS RECORD (
    company_name    GIIS_PARAMETERS.param_value_v%TYPE,
    company_address GIIS_PARAMETERS.param_value_v%TYPE,
    date_type       VARCHAR2 (100)
  );

  TYPE giclr269_tab IS TABLE OF giclr269_type;

     FUNCTION populate_giclr269 (
      P_FROM_DATE       VARCHAR2,
      P_TO_DATE         VARCHAR2,
      P_AS_OF_DATE      VARCHAR2,
      P_FROM_LDATE      VARCHAR2,
      P_TO_LDATE        VARCHAR2,
      P_AS_OF_LDATE     VARCHAR2
    )
       RETURN giclr269_tab PIPELINED;

  TYPE giclr269_details_type IS RECORD (
    claim_no        VARCHAR2 (30),
    pol_no          VARCHAR2 (30),
    dsp_loss_date   gicl_claims.dsp_loss_date%TYPE,
    assured_name    gicl_claims.assured_name%TYPE,
    rec_no          VARCHAR2 (30), 
    cancel_tag      VARCHAR2(20),
    rec_type_cd     giis_recovery_type.rec_type_desc%TYPE,
    recoverable_amt gicl_clm_recovery.recoverable_amt%TYPE,
    recovered_amt   gicl_clm_recovery.recovered_amt%TYPE,
    lawyer_cd       gicl_clm_recovery.lawyer_cd%TYPE,
    clm_file_date   gicl_claims.clm_file_date%TYPE,
    loss_date       gicl_claims.loss_date%TYPE,
    claim_id        gicl_clm_recovery.claim_id%TYPE,
    recovery_id     gicl_clm_recovery.recovery_id%TYPE
  );

  TYPE giclr269_details_tab IS TABLE OF giclr269_details_type;
  
  TYPE payor_type IS RECORD(
    payor_name      VARCHAR2(500),
    recovered_amt   GICL_RECOVERY_PAYOR.RECOVERED_AMT%TYPE
  );
  
  TYPE payor_tab IS TABLE OF payor_type;
  
  FUNCTION populate_giclr269_details (
       p_status        VARCHAR2,
       p_from_date     VARCHAR2,
       p_to_date       VARCHAR2,
       p_as_of_date    VARCHAR2,
       p_from_ldate    VARCHAR2,
       p_to_ldate      VARCHAR2,
       p_as_of_ldate   VARCHAR2,
       p_user_id       VARCHAR2
    )
       RETURN giclr269_details_tab PIPELINED;
       
    FUNCTION cf_payorformula(
        p_claim_id           gicl_recovery_payor.claim_id%TYPE,
        p_recovery_id        gicl_recovery_payor.recovery_id%TYPE          
    )
      RETURN payor_tab PIPELINED;
      
    function CF_rec_type_descFormula(
        p_rec_type_cd           giis_recovery_type.rec_type_cd%TYPE
    )
      return Char;

END GICLR269_PKG;
/


