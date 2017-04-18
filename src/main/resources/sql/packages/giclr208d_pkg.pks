CREATE OR REPLACE PACKAGE CPI.giclr208d_pkg
AS
   TYPE giclr208d_type IS RECORD (
      session_id        NUMBER (10),
      intm_no           VARCHAR2 (10),
      intm_name         VARCHAR2 (200),
      iss_cd            VARCHAR2 (10),
      iss_name          VARCHAR2 (200),
      line_cd           VARCHAR2 (10),
      line_name         VARCHAR2 (200),
      claim_id          NUMBER (10),
      claim_no          VARCHAR2 (100),
      policy_no         VARCHAR2 (100),
      clm_file_date     DATE,
      loss_date         DATE,
      eff_date          DATE,
      assd_name         VARCHAR2 (500),
      loss_cat_cd       VARCHAR2 (10),
      loss_cat_des      VARCHAR2 (200),
      brdrx_record_id   NUMBER (10),
      no_of_days        NUMBER (10),
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      date_as_of        VARCHAR2 (100),
      date_from         VARCHAR2 (100),
      date_to           VARCHAR2 (100),
      exist             VARCHAR2(1)
   );

   TYPE giclr208d_tab IS TABLE OF giclr208d_type;

   FUNCTION get_giclr208d_report (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_intm_break     NUMBER,
      p_cut_off_date   VARCHAR,
      p_aging_date     NUMBER,
      p_date_as_of      VARCHAR2,
      p_date_from       VARCHAR2,
      p_date_to         VARCHAR2
   )
      RETURN giclr208d_tab PIPELINED;

   TYPE column_title_type IS RECORD (
      column_title   VARCHAR2 (100),
      column_no      NUMBER (10)
   );

   TYPE column_title_tab IS TABLE OF column_title_type;

   FUNCTION get_column_title
      RETURN column_title_tab PIPELINED;

   TYPE giclr208d_colums_type IS RECORD (
      column_no          NUMBER (10),
      outstanding_loss   NUMBER (16, 2)
   );

   TYPE giclr208d_colums_tab IS TABLE OF giclr208d_colums_type;

   FUNCTION get_giclr208d_columns (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_brdrx_rec_id   NUMBER,
      p_no_of_days     NUMBER
   )
      RETURN giclr208d_colums_tab PIPELINED;

   FUNCTION get_giclr208d_line_tot (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_line_cd        VARCHAR2,
      p_cut_off_date   VARCHAR2,
      p_aging_date     NUMBER,
      p_intm_no        VARCHAR2,
      p_iss_cd         VARCHAR2
   )
      RETURN giclr208d_colums_tab PIPELINED;

   FUNCTION get_giclr208d_branch_tot (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_cut_off_date   VARCHAR,
      p_aging_date     NUMBER,
      p_iss_cd         VARCHAR2
   )
      RETURN giclr208d_colums_tab PIPELINED;

   FUNCTION get_giclr208d_intm_tot (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_cut_off_date   VARCHAR,
      p_aging_date     NUMBER,
      p_intm_no        VARCHAR2
   )
      RETURN giclr208d_colums_tab PIPELINED;

   FUNCTION get_giclr208d_grand_tot (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_cut_off_date   VARCHAR,
      p_aging_date     NUMBER
   )
      RETURN giclr208d_colums_tab PIPELINED;
END;
/


