CREATE OR REPLACE PACKAGE CPI.giclr204c2_pkg
AS
   TYPE giclr204c2_record_type IS RECORD (
      flag           VARCHAR2 (50),
      company_name   VARCHAR2 (200),
      company_add    VARCHAR2 (350),
      iss_cd         VARCHAR2 (2),
      assd_no        NUMBER (12),
      POLICY         VARCHAR2 (150),
      endt_iss_cd    VARCHAR2 (2),
      endt_yy        NUMBER (2),
      endt_seq_no    NUMBER (6),
      incept_date    DATE,
      expiry_date    DATE,
      tsi_amt        NUMBER (16, 2),
      prem_amt       NUMBER (12, 2),
      iss_name       VARCHAR2 (20),
      assd_name      VARCHAR2 (500),
      --iss_cd
      policy_id      NUMBER (12),
      policy_func    VARCHAR2 (100),
      assd           VARCHAR2 (520),
      iss            VARCHAR2 (100),
      as_date        VARCHAR2 (20)
   );

   TYPE giclr204c2_record_tab IS TABLE OF giclr204c2_record_type;

   TYPE giclr204c2g7_record_type IS RECORD (
      flag           VARCHAR2 (50),
      company_name   VARCHAR2 (200),
      company_add    VARCHAR2 (350),
      iss_cd         VARCHAR2 (2),
      assd_no        NUMBER (12),
      POLICY         VARCHAR2 (150),
      endt_iss_cd    VARCHAR2 (2),
      endt_yy        NUMBER (2),
      endt_seq_no    NUMBER (6),
      incept_date    DATE,
      expiry_date    DATE,
      tsi_amt        NUMBER (16, 2),
      prem_amt       NUMBER (12, 2),
      iss_name       VARCHAR2 (20),
      assd_name      VARCHAR2 (500),
      a_iss_cd       VARCHAR2 (2),
      policy_id      NUMBER (12),
      policy_func    VARCHAR2 (100),
      assd           VARCHAR2 (520),
      iss            VARCHAR2 (100),
      as_date        VARCHAR2 (20)
   );

   TYPE giclr204c2g7_record_tab IS TABLE OF giclr204c2g7_record_type;

   TYPE giclr204c2_claim_type IS RECORD (
      iss_name        VARCHAR2 (20),
      iss_cd          VARCHAR2 (2),
      assd_no         NUMBER (12),
      assd_name       VARCHAR2 (500),
      claim_id        NUMBER (12),
      os_amt          NUMBER (16, 2),
      dsp_loss_date   DATE,
      clm_file_date   DATE,
      claim           VARCHAR2 (150),
      iss             VARCHAR2 (100),
      assd            VARCHAR2 (520),
      flag            VARCHAR2 (50)
   );

   TYPE giclr204c2_claim_tab IS TABLE OF giclr204c2_claim_type;

   TYPE giclr204c2_claimg5_type IS RECORD (
      iss_name        VARCHAR2 (20),
      iss_cd          VARCHAR2 (2),
      assd_no         NUMBER (12),
      assd_name       VARCHAR2 (500),
      claim_id        NUMBER (12),
      os_amt          NUMBER (12, 2),
      dsp_loss_date   DATE,
      clm_file_date   DATE,
      claim           VARCHAR2 (150),
      iss             VARCHAR2 (100),
      assd            VARCHAR2 (520),
      flag            VARCHAR2 (50)
   );

   TYPE giclr204c2_claimg5_tab IS TABLE OF giclr204c2_claimg5_type;

   TYPE giclr204c2_claimg9_type IS RECORD (
      iss_cd          VARCHAR2 (2),
      iss_name        VARCHAR2 (20),
      assd_no         NUMBER (12),
      assd_name       VARCHAR2 (500),
      claim           VARCHAR2 (150),
      dsp_loss_date   DATE,
      loss_paid       NUMBER (12, 2),
      iss             VARCHAR2 (100),
      assd            VARCHAR2 (520),
      flag            VARCHAR2 (50)
   );

   TYPE giclr204c2_claimg9_tab IS TABLE OF giclr204c2_claimg9_type;

   TYPE giclr204c2_recoveryg11_type IS RECORD (
      iss_cd          VARCHAR2 (2),
      iss_name        VARCHAR2 (20),
      assd_no         NUMBER (12),
      assd_name       VARCHAR2 (500),
      rec_type_desc   VARCHAR2 (50),
      recovered_amt   NUMBER (12, 2),
      dsp_loss_date   DATE,
      RECOVERY        VARCHAR2 (150),
      iss             VARCHAR2 (100),
      assd            VARCHAR2 (520),
      flag            VARCHAR2 (50)
   );

   TYPE giclr204c2_recoveryg11_tab IS TABLE OF giclr204c2_recoveryg11_type;

   TYPE giclr204c2_recoveryg13_type IS RECORD (
      iss_cd          VARCHAR2 (2),
      iss_name        VARCHAR2 (20),
      assd_no         NUMBER (12),
      assd_name       VARCHAR2 (500),
      rec_type_desc   VARCHAR2 (50),
      recovered_amt   NUMBER (12, 2),
      dsp_loss_date   DATE,
      RECOVERY        VARCHAR2 (150),
      iss             VARCHAR2 (100),
      assd            VARCHAR2 (520),
      flag            VARCHAR2 (50)
   );

   TYPE giclr204c2_recoveryg13_tab IS TABLE OF giclr204c2_recoveryg13_type;

   FUNCTION get_giclr204c2_records (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2_record_tab PIPELINED;

   FUNCTION get_giclr204c2g7_records (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2g7_record_tab PIPELINED;

   FUNCTION get_giclr204c2_claim (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2_claim_tab PIPELINED;

   FUNCTION get_giclr204c2_claimg5 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2_claimg5_tab PIPELINED;

   FUNCTION get_giclr204c2_claimg9 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2_claimg9_tab PIPELINED;

   FUNCTION get_giclr204c2_recoveryg11 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2_recoveryg11_tab PIPELINED;

   FUNCTION get_giclr204c2_recoveryg13 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2_recoveryg13_tab PIPELINED;
END;
/


