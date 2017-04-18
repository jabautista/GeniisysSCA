CREATE OR REPLACE PACKAGE CPI.giclr204c_pkg
AS
   TYPE giclr204c_record_type IS RECORD (
      intm_no                     NUMBER (12),
      iss_cd                      VARCHAR2 (2),
      loss_ratio_date             DATE,
      curr_prem_amt               NUMBER (16, 2),
      prem_res_cy                 NUMBER (16, 2),
      prem_res_py                 NUMBER (16, 2),
      loss_paid_amt               NUMBER (16, 2),
      curr_loss_res               NUMBER (16, 2),
      prev_loss_res               NUMBER (16, 2),
      premiums_earned             NUMBER (16, 2),
      losses_incurred             NUMBER (16, 2),
      p_assd_no                   NUMBER (12),
      p_date                      DATE,
      p_line_cd                   VARCHAR2 (2),
      p_subline_cd                VARCHAR2 (7),
      p_iss_cd                    VARCHAR2 (2),
      p_intm_no                   NUMBER (12),
      v_test                      VARCHAR2 (1),
      cf_assd_nameformula         VARCHAR2 (250),
      cf_company_nameformula      VARCHAR2 (500),
      cf_company_addressformula   VARCHAR2 (500),
      cf_line_nameformula         VARCHAR2 (30),
      cf_subline_nameformula      VARCHAR2 (30),
      cf_iss_nameformula          VARCHAR2 (30),
      cf_intm_nameformula         VARCHAR2 (240),
      cf_1formula                 VARCHAR2 (50),
      cf_issourceformula          VARCHAR2 (40),
      cf_loss_ratioformula        NUMBER (16, 2)
   );

   TYPE giclr204c_record_tab IS TABLE OF giclr204c_record_type;

   FUNCTION get_giclr204c_record (
      p_session_id   NUMBER,
      p_date         VARCHAR2,
      p_assd_no      NUMBER,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_intm_no      NUMBER
   )
      RETURN giclr204c_record_tab PIPELINED;
END;
/


