CREATE OR REPLACE PACKAGE CPI.GICLR262_PKG
IS
   TYPE giclr262_pkg_details_type IS RECORD (
      comp_name         giis_parameters.param_value_v%TYPE,
      comp_address      giis_parameters.param_value_v%TYPE,
      vessel_cd         VARCHAR2 (100),
      date_type         VARCHAR2 (100),
      exp_pd_formula    NUMBER,
      exp_res_formula   NUMBER,
      los_pd_formula    NUMBER,
      los_res_formula   NUMBER,
      vessel            VARCHAR2 (50),
      line_cd           VARCHAR2 (2),
      iss_cd            VARCHAR2 (2),
      claim_id          NUMBER (12),
      assured_name      VARCHAR2 (1001),
      loss_date         VARCHAR2 (40),
      clm_file_date     VARCHAR2 (40),
      item_no           NUMBER (9),
      item              VARCHAR2 (40),
      claim_number      VARCHAR2 (30),
      policy_number     VARCHAR2 (30)
   );

   TYPE giclr262_pkg_details_tab IS TABLE OF giclr262_pkg_details_type;

--   FUNCTION get_header (
--     p_vessel_cd    VARCHAR2,
--      p_search_by    NUMBER,
--      p_as_of_date   VARCHAR2,
--      p_from_date    VARCHAR2,
--      p_to_date      VARCHAR2
--   )
--   RETURN header_tab PIPELINED;
--
--   TYPE detail_type IS RECORD (
--      vessel VARCHAR2(50),
--      line_cd VARCHAR2(2),
--      iss_cd VARCHAR2(2),
--      claim_id NUMBER(12),
--      assured_name VARCHAR2(1001),
--      loss_date DATE,
--      clm_file_date DATE,
--      item_no NUMBER(9),
--      item VARCHAR2(40),
--      claim_number VARCHAR2(30),
--      policy_number VARCHAR2(30),
--      cf_los_res NUMBER(15,2),
--      cf_los_paid NUMBER(15,2),
--      cf_exp_res NUMBER(15,2),
--      cf_exp_paid NUMBER(15,2)
--   );
--
--   TYPE detail_tab IS TABLE OF detail_type;
   FUNCTION get_giclr262_details (
      p_vessel_cd     giis_vessel.vessel_cd%TYPE,
      p_as_of_date    VARCHAR2,
      p_from_date     VARCHAR2,
      p_to_date       VARCHAR2,
      p_as_of_ldate   VARCHAR2,
      p_from_ldate    VARCHAR2,
      p_to_ldate      VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN giclr262_pkg_details_tab PIPELINED;
END GICLR262_PKG;
/


