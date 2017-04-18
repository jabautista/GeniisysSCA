CREATE OR REPLACE PACKAGE CPI.CSV_RECOVERY_REGISTER AS
TYPE giclr202_rec_type IS RECORD (claim_number      VARCHAR2(26),
                                  policy_number     VARCHAR2(30),
                                  assd_name         giis_assured.assd_name%TYPE,
                                  loss_date         gicl_claims.dsp_loss_date%TYPE,
                                  file_date         gicl_claims.clm_file_date%TYPE,
                                  recovery_number   VARCHAR2(48), 
                                  rec_type          giis_recovery_type.rec_type_desc%TYPE,
                                  rec_status        VARCHAR2(50),
                                  lawyer            VARCHAR2(850),
                                  recoverable_amt   gicl_clm_recovery.recoverable_amt%TYPE);
TYPE giclr202_type IS TABLE OF giclr202_rec_type;
--START SR5397 hdrtagudin 04052016 CSV printing
TYPE giclr201_rec_type IS RECORD (claim_number          VARCHAR2(26),
                                  policy_number         VARCHAR2(30),
                                  assured               giis_assured.assd_name%TYPE,
                                  intermediary          giis_intermediary.intm_name%TYPE,
                                  loss_date             VARCHAR2(20),
                                  file_date             VARCHAR2(20),
                                  recovery_file_date    VARCHAR2(20),
                                  recovery_number       VARCHAR2(48), 
                                  recovery_type          giis_recovery_type.rec_type_desc%TYPE,
                                  recovery_status        VARCHAR2(50),
                                  lawyer                VARCHAR2(850),
                                  recoverable_amt    VARCHAR2(50),
                                  recovered_amt      VARCHAR2(50),
                                  payee             VARCHAR2(850),
                                  recovered_amt_per_payor     VARCHAR2(50),
                                  recovery_date         VARCHAR2(20),
                                  reference_no          VARCHAR2(500));
TYPE giclr201_type IS TABLE OF giclr201_rec_type;
--END SR5397 hdrtagudin 04052016 CSV printing

 --SR5397 hdrtagudin 04052016 CSV printing
FUNCTION CSV_GICLR201(p_user_id VARCHAR2,
                      p_date_sw NUMBER,
                      p_from_date DATE, 
                      p_to_date DATE, 
                      p_line_cd gicl_claims.line_cd%type,
                      p_iss_cd gicl_claims.iss_cd%TYPE, 
                      p_rec_type_cd gicl_clm_recovery.rec_type_cd%TYPE, 
                      p_intm_no giis_intermediary.intm_no%TYPE)
                      RETURN giclr201_type PIPELINED;

--END SR5397 hdrtagudin 04052016 CSV printing

FUNCTION CSV_GICLR202(p_date DATE,
                      p_line_cd gicl_claims.line_cd%type,
                      p_iss_cd gicl_claims.iss_cd%TYPE, 
                      p_rec_type_cd gicl_clm_recovery.rec_type_cd%TYPE)
                      RETURN giclr202_type PIPELINED;
END;
/


