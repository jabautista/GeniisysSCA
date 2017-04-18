CREATE OR REPLACE PACKAGE CPI.giclr208c_pkg
AS
   TYPE giclr208c_type IS RECORD (
      intm_no           VARCHAR2 (12),
      intm_name         VARCHAR2 (200),
      iss_cd            VARCHAR2 (2),
      iss_name          VARCHAR2 (200),
      line_cd           VARCHAR2 (10),
      line_name         VARCHAR2 (200),
      claim_no          VARCHAR2 (50),
      policy_no         VARCHAR2 (50),
      clm_file_date     DATE,
      pol_eff_date      DATE,
      loss_date         DATE,
      assd_name         VARCHAR2 (500),
      loss_cat_des      VARCHAR2 (500),
      no_of_days        NUMBER (10),
      claim_id          NUMBER (10),
      brdrx_record_id   gicl_res_brdrx_extr.brdrx_record_id%TYPE,
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      date_as_of        VARCHAR2 (100),
      date_from         VARCHAR2 (100),
      date_to           VARCHAR2 (100),
      exist             VARCHAR2 (1)
   );

   TYPE giclr208c_tab IS TABLE OF giclr208c_type;

   FUNCTION get_giclr208c_report (
      p_session_id      NUMBER,
      p_claim_id        NUMBER,
      p_intm_break      NUMBER,
      p_cut_off_date    VARCHAR,
      p_aging_date      NUMBER,
      p_search_by_opt   VARCHAR2,
      p_date_as_of      VARCHAR2,
      p_date_from       VARCHAR2,
      p_date_to         VARCHAR2
   )
      RETURN giclr208c_tab PIPELINED;

   TYPE giclr208c_col_title_type IS RECORD (
      column_title   VARCHAR2 (100),
      column_no      NUMBER (10)
   );

   TYPE giclr208c_col_title_tab IS TABLE OF giclr208c_col_title_type;

   FUNCTION get_giclr208c_col_title
      RETURN giclr208c_col_title_tab PIPELINED;

   TYPE giclr208c_colums_type IS RECORD (
      column_no          NUMBER (10),
      outstanding_loss   NUMBER (16, 2)
   );

   TYPE giclr208c_colums_tab IS TABLE OF giclr208c_colums_type;

   FUNCTION get_giclr208c_columns (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_brdrx_rec_id   NUMBER,
      p_no_of_days     NUMBER
   )
      RETURN giclr208c_colums_tab PIPELINED;

   FUNCTION get_giclr208c_line_tot (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_line_cd        VARCHAR2,
      p_cut_off_date   VARCHAR,
      p_aging_date     NUMBER,
      p_intm_no        VARCHAR2,
      p_iss_cd         VARCHAR2
   )
      RETURN giclr208c_colums_tab PIPELINED;

   FUNCTION get_giclr208c_branch_tot (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_cut_off_date   VARCHAR,
      p_aging_date     NUMBER,
      p_iss_cd         VARCHAR2
   )
      RETURN giclr208c_colums_tab PIPELINED;

   FUNCTION get_giclr208c_intm_tot (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_cut_off_date   VARCHAR,
      p_aging_date     NUMBER,
      p_intm_no        VARCHAR2
   )
      RETURN giclr208c_colums_tab PIPELINED;

   FUNCTION get_giclr208c_grand_tot (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_cut_off_date   VARCHAR,
      p_aging_date     NUMBER
   )
      RETURN giclr208c_colums_tab PIPELINED;
END;
/


