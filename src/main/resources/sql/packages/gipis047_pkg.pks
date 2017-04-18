CREATE OR REPLACE PACKAGE cpi.gipis047_pkg
AS
   TYPE bond_lov_type IS RECORD (
      policy_id           gipi_polbasic.policy_id%TYPE,
      line_cd             gipi_polbasic.line_cd%TYPE,
      subline_cd          gipi_polbasic.subline_cd%TYPE,
      iss_cd              gipi_polbasic.iss_cd%TYPE,
      issue_yy            gipi_polbasic.issue_yy%TYPE,
      pol_seq_no          gipi_polbasic.pol_seq_no%TYPE,
      renew_no            gipi_polbasic.renew_no%TYPE,
      endt_iss_cd         gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy             gipi_polbasic.endt_yy%TYPE,
      endt_seq_no         gipi_polbasic.endt_seq_no%TYPE,
      assd_no             gipi_polbasic.assd_no%TYPE,
      eff_date            gipi_polbasic.eff_date%TYPE,
      dsp_eff_date        VARCHAR2 (50),
      policy_no           VARCHAR2 (50),
      endt_no             VARCHAR2 (50),
      endt_expiry_date    gipi_polbasic.endt_expiry_date%TYPE,
      expiry_date         gipi_polbasic.expiry_date%TYPE,
      incept_date         gipi_polbasic.incept_date%TYPE,
      issue_date          gipi_polbasic.issue_date%TYPE,
      assd_name           giis_assured.assd_name%TYPE,
      updt_eff_dt         VARCHAR2 (1),
      --dsp_or_no           giac_order_of_payts.or_no%TYPE,
      dsp_or_no           VARCHAR2(15), -- replaced by Mark C. 05072015
      dsp_amt_paid        NUMBER (16, 2),
      dsp_obligee_name    giis_obligee.obligee_name%TYPE,
      obligee_no          gipi_bond_basic.obligee_no%TYPE,
      np_name             giis_notary_public.np_name%TYPE,
      np_no               gipi_bond_basic.np_no%TYPE,
      coll_flag           gipi_bond_basic.coll_flag%TYPE,
      waiver_limit        gipi_bond_basic.waiver_limit%TYPE,
      waiver_limit_cond   NUMBER (16, 2),
      eff_date_cond       DATE
   );

   TYPE bond_lov_tab IS TABLE OF bond_lov_type;

   TYPE notary_lov_type IS RECORD (
      np_name   giis_notary_public.np_name%TYPE,
      np_no     giis_notary_public.np_no%TYPE
   );

   TYPE notary_lov_tab IS TABLE OF notary_lov_type;

   FUNCTION get_bond_lov (
      p_iss_cd      gipi_polbasic.iss_cd%TYPE,
      p_line_cd     gipi_polbasic.line_cd%TYPE,
      p_module_id   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN bond_lov_tab PIPELINED;

   FUNCTION get_notary_lov
      RETURN notary_lov_tab PIPELINED;

   PROCEDURE set_gipi_bond_basic (p_bond_basic gipi_bond_basic%ROWTYPE);
END;
/