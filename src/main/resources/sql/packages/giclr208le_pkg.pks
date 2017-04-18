CREATE OR REPLACE PACKAGE CPI.giclr208le_pkg
AS
   TYPE giclr208le_type IS RECORD (
      intm_no            VARCHAR2 (100),
      intm_name          VARCHAR2 (200),
      iss_cd             VARCHAR2 (100),
      iss_name           VARCHAR2 (200),
      line_cd            VARCHAR2 (100),
      line_name          VARCHAR2 (200),
      claim_id           NUMBER (10),
      claim_no           VARCHAR2 (100),
      policy_no          VARCHAR2 (100),
      assd_no            NUMBER (10),
      assd_name          VARCHAR2 (500),
      intm_ri            VARCHAR2 (1000),
      eff_date           VARCHAR2 (20),
      expiry_date        VARCHAR2 (20),
      loss_date          DATE,
      clm_file_date      DATE,
      loss_cat_des       VARCHAR2 (200),
      loc_of_risk        VARCHAR2 (1000),
      item_no            NUMBER (10),
      grouped_item_no    NUMBER (10),
      item               VARCHAR2 (500),
      peril_cd           NUMBER (5),
      peril_name         VARCHAR2 (200),
      outstanding_loss   NUMBER (16, 2),
      outstanding_exp    NUMBER (16, 2),
      tsi_amount         NUMBER (16, 2),
      clm_stat_desc      VARCHAR2 (200),
      pt_loss            NUMBER (16, 2),
      pt_exp             NUMBER (16, 2),
      net_loss           NUMBER (16, 2),
      net_exp            NUMBER (16, 2),
      fac_loss           NUMBER (16, 2),
      fac_exp            NUMBER (16, 2),
      npt_loss           NUMBER (16, 2),
      npt_exp            NUMBER (16, 2),
      rec_loss           NUMBER (16, 2),
      rec_exp            NUMBER (16, 2),
      company_name       VARCHAR2 (200),
      company_address    VARCHAR2 (200),
      date_as_of         VARCHAR2 (100),
      date_from          VARCHAR2 (100),
      date_to            VARCHAR2 (100),
      exist              VARCHAR2(1)
   
   --session_id         NUMBER(10)
   );

   TYPE giclr208le_tab IS TABLE OF giclr208le_type;

   FUNCTION get_giclr208le_report (
      p_session_id      NUMBER,
      p_claim_id        NUMBER,
      p_intm_break      NUMBER,
      p_search_by_opt   VARCHAR2,
      p_date_as_of      VARCHAR2,
      p_date_from       VARCHAR2,
      p_date_to         VARCHAR2
   )
      RETURN giclr208le_tab PIPELINED;
END;
/


