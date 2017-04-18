CREATE OR REPLACE PACKAGE CPI.giclr204b2_pkg
AS
/*
** Created by   : Paolo J. Santos
** Date Created : 08.05.2013
** Reference By : giclr204b2
** Description  : LOSS RATIO PER LINE/SUBLINE DETAIL REPORT */
   TYPE giclr204b2_record_type IS RECORD (
      subline_cd           VARCHAR2 (7 BYTE),
      assd_no              NUMBER (16),
      policy1              VARCHAR2 (50 BYTE),
      policy_id            NUMBER (12),
      endt_iss_cd          VARCHAR2 (2 BYTE),
      endt_yy              NUMBER (2),
      endt_seq_no          NUMBER (6),
      incept_date          DATE,
      expiry_date          DATE,
      tsi_amt              NUMBER (16, 2),
      sum_prem_amt         NUMBER (12,2),
      subline_name         VARCHAR2 (30 BYTE),
      assd_name            VARCHAR2 (500 BYTE),
      pjs                  VARCHAR2 (1),
      p_session_id         NUMBER (20),
      cf_subline           VARCHAR2 (100),
      cf_policy            VARCHAR2 (100),
      cf_date              VARCHAR2 (20),
      p_prnt_date          VARCHAR2 (20),
      cf_assd              VARCHAR2 (520),
      cf_company_name      VARCHAR2 (500),
      cf_company_address   VARCHAR2 (500),
      p_curr_prem          VARCHAR2 (1)
   );

   TYPE giclr204b2_record_tab IS TABLE OF giclr204b2_record_type;

   FUNCTION get_giclr204b2_record (
      p_session_id              NUMBER, 
      p_prnt_date               VARCHAR2
   ) RETURN giclr204b2_record_tab PIPELINED;

   TYPE giclr204b2_q2_record_type IS RECORD (
      subline_cd     VARCHAR2 (7 BYTE),
      subline_name   VARCHAR2 (30 BYTE),
      policy1        VARCHAR2 (50 BYTE),
      policy_id      NUMBER (12),
      assd_name      VARCHAR2 (500 BYTE),
      sum_prem_amt   NUMBER (38),
      endt_iss_cd    VARCHAR2 (2 BYTE),
      assd_no        NUMBER (16),
      endt_yy        NUMBER (2),
      endt_seq_no    NUMBER (6),
      incept_date    DATE,
      expiry_date    DATE,
      tsi_amt        NUMBER (16, 2),
      pjs2           VARCHAR2 (1),
      cf_subline1    VARCHAR2 (100),
      p_prnt_date    VARCHAR2 (20),
      p_session_id   NUMBER (20),
      cf_date1       VARCHAR2 (20),
      cf_policy2     VARCHAR2 (100),
      cf_assd3       VARCHAR2 (520),
      p_curr_prem    VARCHAR2 (1)
   );

   TYPE giclr204b2_q2_record_tab IS TABLE OF giclr204b2_q2_record_type;

   FUNCTION get_giclr204b2_q2_record (p_session_id NUMBER, p_prnt_date VARCHAR2)
      RETURN giclr204b2_q2_record_tab PIPELINED;

   TYPE giclr204b2_q3_record_type IS RECORD (
      subline_name    VARCHAR2 (30 BYTE),
      subline_cd      VARCHAR2 (7 BYTE),
      assd_no         NUMBER (16),
      assd_name       VARCHAR2 (500 BYTE),
      claim_id        NUMBER (12),
      sum_os_amt      NUMBER (16, 2),
      dsp_loss_date   DATE,
      clm_file_date   DATE,
      claim           VARCHAR2 (50),
      pjs3            VARCHAR2 (1),
      p_session_id    NUMBER,
      cf_subline2     VARCHAR2 (100),
      cf_assd1        VARCHAR2 (520)
   );

   TYPE giclr204b2_q3_record_tab IS TABLE OF giclr204b2_q3_record_type;

   FUNCTION get_giclr204b2_q3_record (p_session_id NUMBER)
      RETURN giclr204b2_q3_record_tab PIPELINED;

   TYPE giclr204b2_q4_record_type IS RECORD (
      subline_cd      VARCHAR2 (7 BYTE),
      assd_no         NUMBER (16),
      claim_id        NUMBER (12),
      sum_os_amt      NUMBER (38),
      dsp_loss_date   DATE,
      clm_file_date   DATE,
      claim           VARCHAR2 (50),
      subline_name    VARCHAR2 (50 BYTE),
      assd_name       VARCHAR2 (500 BYTE),
      pjs4            VARCHAR2 (1),
      p_session_id    NUMBER,
      cf_subline3     VARCHAR2 (100),
      cf_assd2        VARCHAR2 (520)
   );

   TYPE giclr204b2_q4_record_tab IS TABLE OF giclr204b2_q4_record_type;

   FUNCTION get_giclr204b2_q4_record (p_session_id NUMBER)
      RETURN giclr204b2_q4_record_tab PIPELINED;

   TYPE giclr204b2_q5_record_type IS RECORD (
      subline_cd      VARCHAR2 (7 BYTE),
      assd_no         NUMBER (16),
      sum_loss_pd     NUMBER (16, 2),
      dsp_loss_date   DATE,
      claim           VARCHAR2 (50),
      subline_name    VARCHAR2 (50 BYTE),
      assd_name       VARCHAR2 (500 BYTE),
      pjs5            VARCHAR2 (1),
      p_session_id    NUMBER,
      cf_subline4     VARCHAR2 (100),
      cf_assd4        VARCHAR2 (520)
   );

   TYPE giclr204b2_q5_record_tab IS TABLE OF giclr204b2_q5_record_type;

   FUNCTION get_giclr204b2_q5_record (p_session_id NUMBER)
      RETURN giclr204b2_q5_record_tab PIPELINED;

   TYPE giclr204b2_q6_record_type IS RECORD (
      subline_cd      VARCHAR2 (7 BYTE),
      assd_no         NUMBER (16),
      sum_rec_amt     NUMBER (16, 2),
      subline_name    VARCHAR2 (30 BYTE),
      assd_name       VARCHAR2 (500 BYTE),
      rec_type_desc   VARCHAR2 (50 BYTE),
      dsp_loss_date   DATE,
      recovery1       VARCHAR (50),
      pjs6            VARCHAR2 (1),
      p_session_id    NUMBER,
      cf_subline5     VARCHAR2 (100),
      cf_assd5        VARCHAR2 (520)
   );

   TYPE giclr204b2_q6_record_tab IS TABLE OF giclr204b2_q6_record_type;

   FUNCTION get_giclr204b2_q6_record (p_session_id NUMBER)
      RETURN giclr204b2_q6_record_tab PIPELINED;

   TYPE giclr204b2_q7_record_type IS RECORD (
      subline_cd      VARCHAR2 (7 BYTE),
      assd_no         NUMBER (16),
      sum_rec_amt     NUMBER (16, 2),
      subline_name    VARCHAR2 (30 BYTE),
      assd_name       VARCHAR2 (500 BYTE),
      rec_type_desc   VARCHAR2 (50 BYTE),
      dsp_loss_date   DATE,
      recovery1       VARCHAR (50),
      pjs7            VARCHAR2 (1),
      p_session_id    NUMBER,
      cf_subline6     VARCHAR2 (100),
      cf_assd6        VARCHAR2 (520)
   );

   TYPE giclr204b2_q7_record_tab IS TABLE OF giclr204b2_q7_record_type;

   FUNCTION get_giclr204b2_q7_record (p_session_id NUMBER)
      RETURN giclr204b2_q7_record_tab PIPELINED;
END;
/


