CREATE OR REPLACE PACKAGE CPI.mc_cert_pkg
AS
   TYPE mc_cert_type IS RECORD (
      branch_add       VARCHAR2 (500),
      tel_no           VARCHAR2 (100),
      branch_fax_no    VARCHAR2 (50),
      branch_website   VARCHAR2 (500),
      logo_file        VARCHAR2 (100),
      comp_name        VARCHAR2 (500),
      sys_date         VARCHAR2 (100),
      assd_name        VARCHAR2 (500),
      assd_name2       VARCHAR2 (500),
      assd_add         VARCHAR2 (500),
      POLICY           VARCHAR2 (300),
      prin_name2       VARCHAR2 (1000),
      label_tag        VARCHAR2 (200),
      prin_name3       VARCHAR2 (1000),
      assignee         VARCHAR2 (30),
      motor_no         VARCHAR2 (20),
      engine_series    VARCHAR2 (50),
      serial_no        VARCHAR2 (25),
      plate_no         VARCHAR2 (10),
      color            VARCHAR2 (100),
      incept_date      VARCHAR2 (100),
      expiry_date      VARCHAR2 (100),
      vehicle          VARCHAR2 (1000),
      text             VARCHAR2 (1000),
      text2            VARCHAR2 (200),
      text3            VARCHAR2 (1000),
      report_id        VARCHAR2 (12),
      policy_id        NUMBER (12),
      item_no          NUMBER (9),
      mortg_name       VARCHAR2 (200),
      acct_of_cd       NUMBER (12)
   );

   TYPE mc_cert_tab IS TABLE OF mc_cert_type;

   TYPE ann_tsi_peril_name_type IS RECORD (
      peril_cd     NUMBER (5),
      peril_name   VARCHAR2 (20),
      tsi_sum      NUMBER (16, 2)
   );

   TYPE ann_tsi_peril_name_tab IS TABLE OF ann_tsi_peril_name_type;

   TYPE mc_cert_deductible_type IS RECORD (
      deductible_amt   NUMBER (16, 2)
   );

   TYPE mc_cert_deductible_tab IS TABLE OF mc_cert_deductible_type;

   TYPE mc_cert_signatory_type IS RECORD (
      signatory   VARCHAR2 (100),
      flag        VARCHAR2 (50)
   );

   TYPE mc_cert_signatory_tab IS TABLE OF mc_cert_signatory_type;

   FUNCTION get_mc_cert_record (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN mc_cert_tab PIPELINED;

   FUNCTION get_ann_tsi_peril (
      p_policy_id   gipi_polbasic.policy_id%TYPE,
      p_peril_cd    giis_peril.peril_cd%TYPE
   )
      RETURN NUMBER;

   FUNCTION get_ann_tsi_peril_name (
      p_policy_id   gipi_polbasic.policy_id%TYPE,
      p_item_no     gipi_item.item_no%TYPE
   )
      RETURN ann_tsi_peril_name_tab PIPELINED;

   FUNCTION get_mc_cert_deductible (
      p_policy_id   gipi_polbasic.policy_id%TYPE,
      p_item_no     gipi_item.item_no%TYPE
   )
      RETURN mc_cert_deductible_tab PIPELINED;

   FUNCTION get_mc_cert_signatory (p_report_id giis_signatory.report_id%TYPE)
      RETURN mc_cert_signatory_tab PIPELINED;
END;
/


