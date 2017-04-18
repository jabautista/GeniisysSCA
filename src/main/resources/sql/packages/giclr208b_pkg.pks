CREATE OR REPLACE PACKAGE CPI.giclr208b_pkg
AS
   TYPE giclr208b_type IS RECORD (
      intm_no            VARCHAR2 (10),
      intm_name          VARCHAR2 (200),
      iss_cd             VARCHAR2 (10),
      iss_name           VARCHAR2 (200),
      line_cd            VARCHAR2 (10),
      line_name          VARCHAR2 (100),
      claim_id           NUMBER (20),
      claim_no           VARCHAR2 (100),
      policy_no          VARCHAR2 (100),
      clm_file_date      DATE,
      loss_date          DATE,
      eff_date           DATE,
      assd_no            NUMBER,
      assd_name          VARCHAR2 (500),
      loss_cat_cd        VARCHAR2 (100),
      loss_cat_des       VARCHAR2 (200),
      outstanding_loss   NUMBER (16, 2),
      net_loss           NUMBER (16, 2),
      pt_loss            NUMBER (16, 2),
      fac_loss           NUMBER (16, 2),
      npt_loss           NUMBER (16, 2),
      session_id         NUMBER (10),
      company_name       VARCHAR2 (200),
      company_address    VARCHAR2 (200),
      date_as_of         VARCHAR2 (100),
      date_from          VARCHAR2 (100),
      date_to            VARCHAR2 (100)
   );

   TYPE giclr208b_tab IS TABLE OF giclr208b_type;

   FUNCTION get_giclr208b_report (
      p_session_id   NUMBER,
      p_claim_id     NUMBER,
      p_intm_break   NUMBER,
      p_date_as_of   VARCHAR2,
      p_date_from    VARCHAR2,
      p_date_to      VARCHAR2
   )
      RETURN giclr208b_tab PIPELINED;
END;
/


