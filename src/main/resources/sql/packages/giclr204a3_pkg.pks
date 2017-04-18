CREATE OR REPLACE PACKAGE CPI.giclr204a3_pkg
AS
   TYPE giclr204a3_q1_record_type IS RECORD (
      line_name        VARCHAR2 (20),
      line_cd          VARCHAR2 (2),
      assd_no          NUMBER (12),
      assd_name        VARCHAR2 (500),
      claim_id         NUMBER (12),
      sum_os_amt       NUMBER (16, 2),
      dsp_loss_date    DATE,
      clm_file_date    DATE,
      claim            VARCHAR2 (26),
      v_test           VARCHAR2 (1),
      p_session_id     NUMBER,
      p_line_cd        VARCHAR2 (2),
      p_line_name      VARCHAR2 (20),
      p_assd_no        NUMBER (12),
      p_assd_name      VARCHAR2 (500),
      cf_lineformula   VARCHAR2 (100),
      cf_assdformula   VARCHAR2 (600)
   );

   TYPE giclr204a3_q1_record_tab IS TABLE OF giclr204a3_q1_record_type;

   FUNCTION get_giclr204a3_q1_record (p_session_id NUMBER)
      RETURN giclr204a3_q1_record_tab PIPELINED;

   TYPE giclr204a3_q2_record_type IS RECORD (
      line_name        VARCHAR2 (20),
      line_cd          VARCHAR2 (2),
      assd_no          NUMBER (12),
      assd_name        VARCHAR2 (500),
      claim_id         NUMBER (12),
      sum_os_amt       NUMBER (12, 2),
      dsp_loss_date    DATE,
      clm_file_date    DATE,
      claim            VARCHAR2 (26),
      v_test           VARCHAR2 (1),
      p_session_id     NUMBER,
      p_line_cd        VARCHAR2 (2),
      p_line_name      VARCHAR2 (20),
      p_assd_no        NUMBER (12),
      p_assd_name      VARCHAR2 (500),
      cf_lineformula   VARCHAR2 (100),
      cf_assdformula   VARCHAR2 (600)
   );

   TYPE giclr204a3_q2_record_tab IS TABLE OF giclr204a3_q2_record_type;

   FUNCTION get_giclr204a3_q2_record (p_session_id NUMBER)
      RETURN giclr204a3_q2_record_tab PIPELINED;

   TYPE giclr204a3_q3_record_type IS RECORD (
      line_cd                     VARCHAR2 (2),
      assd_no                     NUMBER (12),
      policy1                     VARCHAR2 (30),
      endt_iss_cd                 VARCHAR2 (2),
      endt_yy                     NUMBER (2),
      endt_seq_no                 NUMBER (6),
      incept_date                 DATE,
      expiry_date                 DATE,
      tsi_amt                     NUMBER (16, 2),
      sum_prem_amt                NUMBER (12, 2),
      line_name                   VARCHAR2 (20),
      policy_id                   NUMBER (12),
      assd_name                   VARCHAR2 (700),
      month1                      VARCHAR2 (100),
      v_test                      VARCHAR2 (1),
      p_session_id                NUMBER,
      p_line_cd                   VARCHAR2 (2),
      p_line_name                 VARCHAR2 (20),
      p_policy_id                 NUMBER (12),
      p_endt_seq_no               NUMBER (6),
      p_policy1                   VARCHAR2 (30),
      p_endt_iss_cd               VARCHAR2 (2),
      p_endt_yy                   NUMBER (2),
      p_assd_no                   NUMBER (12),
      p_assd_name                 VARCHAR2 (500),
      p_prnt_date                 VARCHAR2 (20),
      cf_lineformula              VARCHAR2 (100),
      cf_dateformula              VARCHAR2 (20),
      cf_policyformula            VARCHAR2 (100),
      cf_assdformula              VARCHAR2 (600),
      cf_company_nameformula      VARCHAR2 (500),
      cf_company_addressformula   VARCHAR2 (500)
   );

   TYPE giclr204a3_q3_record_tab IS TABLE OF giclr204a3_q3_record_type;

   FUNCTION get_giclr204a3_q3_record (p_session_id NUMBER, p_prnt_date VARCHAR2)
      RETURN giclr204a3_q3_record_tab PIPELINED;

   TYPE giclr204a3_q4_record_type IS RECORD (
      line_cd            VARCHAR2 (2),
      assd_no            NUMBER (12),
      policy1            VARCHAR2 (30),
      endt_iss_cd        VARCHAR2 (2),
      endt_yy            NUMBER (2),
      endt_seq_no        NUMBER (6),
      incept_date        DATE,
      expiry_date        DATE,
      tsi_amt            NUMBER (16, 2),
      sum_prem_amt       NUMBER (12, 2),
      line_name          VARCHAR2 (20),
      policy_id          NUMBER (12),
      assd_name          VARCHAR2 (500),
      month1             DATE,
      v_test             VARCHAR2 (1),
      p_session_id       NUMBER,
      p_line_cd          VARCHAR2 (2),
      p_line_name        VARCHAR2 (20),
      p_policy_id        NUMBER (12),
      p_endt_seq_no      NUMBER (6),
      p_policy1          VARCHAR2 (30),
      p_endt_iss_cd      VARCHAR2 (2),
      p_endt_yy          NUMBER (2),
      p_assd_no          NUMBER (12),
      p_assd_name        VARCHAR2 (500),
      p_prnt_date        VARCHAR2 (20),
      cf_lineformula     VARCHAR2 (100),
      cf_dateformula     VARCHAR2 (20),
      cf_policyformula   VARCHAR2 (100),
      cf_assdformula     VARCHAR2 (600)
   );

   TYPE giclr204a3_q4_record_tab IS TABLE OF giclr204a3_q4_record_type;

   FUNCTION get_giclr204a3_q4_record (p_session_id NUMBER, p_prnt_date VARCHAR2)
      RETURN giclr204a3_q4_record_tab PIPELINED;

   TYPE giclr204a3_q5_record_type IS RECORD (
      line_cd          VARCHAR2 (2),
      line_name        VARCHAR2 (20),
      assd_no          NUMBER (12),
      assd_name        VARCHAR2 (500),
      claim            VARCHAR2 (26),
      dsp_loss_date    DATE,
      sum_loss_paid    NUMBER (12, 2),
      v_test           VARCHAR2 (1),
      p_session_id     NUMBER,
      p_line_cd        VARCHAR2 (2),
      p_line_name      VARCHAR2 (20),
      p_assd_no        NUMBER (12),
      p_assd_name      VARCHAR2 (500),
      cf_lineformula   VARCHAR2 (100),
      cf_assdformula   VARCHAR2 (600)
   );

   TYPE giclr204a3_q5_record_tab IS TABLE OF giclr204a3_q5_record_type;

   FUNCTION get_giclr204a3_q5_record (p_session_id NUMBER)
      RETURN giclr204a3_q5_record_tab PIPELINED;

   TYPE giclr204a3_q6_record_type IS RECORD (
      line_cd             VARCHAR2 (2),
      line_name           VARCHAR2 (20),
      assd_no             NUMBER (12),
      assd_name           VARCHAR2 (500),
      rec_type_desc       VARCHAR2 (50),
      sum_recovered_amt   NUMBER (12, 2),
      dsp_loss_date       DATE,
      recovery1           VARCHAR2 (16),
      v_test              VARCHAR2 (1),
      p_session_id        NUMBER,
      p_line_cd           VARCHAR2 (2),
      p_line_name         VARCHAR2 (20),
      p_assd_no           NUMBER (12),
      p_assd_name         VARCHAR2 (500),
      cf_lineformula      VARCHAR2 (100),
      cf_assdformula      VARCHAR2 (600)
   );

   TYPE giclr204a3_q6_record_tab IS TABLE OF giclr204a3_q6_record_type;

   FUNCTION get_giclr204a3_q6_record (p_session_id NUMBER)
      RETURN giclr204a3_q6_record_tab PIPELINED;

   TYPE giclr204a3_q7_record_type IS RECORD (
      line_cd             VARCHAR2 (2),
      line_name           VARCHAR2 (20),
      assd_no             NUMBER (12),
      assd_name           VARCHAR2 (500),
      rec_type_desc       VARCHAR2 (50),
      sum_recovered_amt   NUMBER (12, 2),
      dsp_loss_date       DATE,
      recovery1           VARCHAR2 (16),
      v_test              VARCHAR2 (1),
      p_session_id        NUMBER,
      p_line_cd           VARCHAR2 (2),
      p_line_name         VARCHAR2 (20),
      p_assd_no           NUMBER (12),
      p_assd_name         VARCHAR2 (500),
      cf_lineformula      VARCHAR2 (100),
      cf_assdformula      VARCHAR2 (600)
   );

   TYPE giclr204a3_q7_record_tab IS TABLE OF giclr204a3_q7_record_type;

   FUNCTION get_giclr204a3_q7_record (p_session_id NUMBER)
      RETURN giclr204a3_q7_record_tab PIPELINED;
END;
/


