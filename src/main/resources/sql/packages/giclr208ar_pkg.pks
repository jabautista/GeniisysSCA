CREATE OR REPLACE PACKAGE CPI.giclr208ar_pkg
AS
   TYPE rep_type IS RECORD (
      session_id         gicl_res_brdrx_extr.session_id%TYPE,
      intm_no            VARCHAR2 (12),
      intm_name          giis_intermediary.intm_name%TYPE,
      iss_cd             giis_issource.iss_cd%TYPE,
      iss_name           giis_issource.iss_name%TYPE,
      line_cd            giis_line.line_cd%TYPE,
      line_name          giis_line.line_name%TYPE,
      claim_id           gicl_claims.claim_id%TYPE,
      claim_no           VARCHAR2 (200),
      policy_no          VARCHAR2 (200),
      clm_file_date      DATE,
      eff_date           DATE,
      loss_date          DATE,
      assd_name          giis_assured.assd_name%TYPE,
      loss_cat_cd        VARCHAR2 (10),
      loss_cat_des       VARCHAR2 (200),
      outstanding_loss   NUMBER (16, 2),
      net_loss           NUMBER (16, 2),
      facul              NUMBER (16, 2),
      prop_treaty        NUMBER (16, 2),
      non_prop_treaty    NUMBER (16, 2),
      company_name       VARCHAR2 (600),
      company_address    VARCHAR2 (600),
      date_as_of         VARCHAR2 (100),
      date_from          VARCHAR2 (100),
      date_to            VARCHAR2 (100),
      exist              VARCHAR2 (1)
   );

   TYPE rep_tab IS TABLE OF rep_type;

   FUNCTION get_giclr208ar_rep (
      p_session_id   VARCHAR2,
      p_claim_id     NUMBER,
      p_date_as_of   VARCHAR2,
      p_date_from    VARCHAR2,
      p_date_to      VARCHAR2
   )
      RETURN rep_tab PIPELINED;
END;
/


