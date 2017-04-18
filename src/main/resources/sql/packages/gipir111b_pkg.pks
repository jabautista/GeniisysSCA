CREATE OR REPLACE PACKAGE CPI.gipir111b_pkg
AS
   TYPE gipir111b_type IS RECORD (
      company_name       VARCHAR2 (100),
      company_add        giac_parameters.param_value_v%TYPE,
      exist              VARCHAR2 (1),
      location_cd        giis_ca_location.location_cd%TYPE,
      location_desc      VARCHAR2 (500),
      policy_id          gipi_polbasic.policy_id%TYPE,
      ret_limit          giis_ca_location.ret_limit%TYPE,
      treaty_limit       giis_ca_location.treaty_limit%TYPE,
      assured            gixx_ca_accum_dist.assd_name%TYPE,
      LOCATION           gipi_casualty_item.LOCATION%TYPE,
      incept_date        VARCHAR2 (50),
      expiry_date        VARCHAR2 (50),
      total              NUMBER (20, 2),
      RETENTION          NUMBER (20, 2),
      treaty             NUMBER (20, 2),
      facultative        NUMBER (20, 2),
      claim_no           VARCHAR2 (50),
      policy_no          VARCHAR2 (50),
      loss_date          VARCHAR2 (50),
      location_of_loss   VARCHAR2 (1000),
      loss_res_amt       NUMBER (20, 2),
      exp_res_amt        NUMBER (20, 2),
      loss_pd_amt        NUMBER (20, 2),
      exp_pd_amt         NUMBER (20, 2)
   );

   TYPE gipir111b_tab IS TABLE OF gipir111b_type;

   FUNCTION populate_gipir111b (
      p_location_cd   VARCHAR2,
      p_eff_tag       VARCHAR2,
      p_expiry_tag    VARCHAR2
   )
      RETURN gipir111b_tab PIPELINED;
END gipir111b_pkg;
/


