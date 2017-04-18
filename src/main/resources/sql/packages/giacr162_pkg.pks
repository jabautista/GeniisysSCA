CREATE OR REPLACE PACKAGE CPI.giacr162_pkg
AS
   TYPE report_type IS RECORD (
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      title_date        VARCHAR2 (150),
      intrmdry          VARCHAR2 (200),
      cv_choice         VARCHAR2 (20),
      cv_date           VARCHAR2 (100),
      cv_no             VARCHAR2 (100),
      tran_date         giac_parent_comm_voucher.tran_date%TYPE,
      policy_no         giac_parent_comm_voucher.policy_no%TYPE,
      bill_no           VARCHAR2 (200),
      inst_no           giac_parent_comm_voucher.inst_no%TYPE,
      cf_assd           VARCHAR2 (500),
      tran_class        giac_parent_comm_voucher.tran_class%TYPE,
      ref_no            giac_parent_comm_voucher.ref_no%TYPE,
      prem_amt          giac_parent_comm_voucher.premium_amt%TYPE,
      comm_amt          giac_parent_comm_voucher.commission_due%TYPE,
      tax               giac_parent_comm_voucher.withholding_tax%TYPE,
      adv               giac_parent_comm_voucher.advances%TYPE,
      vat               giac_parent_comm_voucher.input_vat%TYPE,
      cf_net_amt        NUMBER (16, 2),
      intm_no           giac_parent_comm_voucher.intm_no%TYPE,
      print_details     VARCHAR2(1)
   );

   TYPE report_tab IS TABLE OF report_type;

   FUNCTION get_giacr_162_report (
      p_from_dt   VARCHAR2,
      p_to_dt     VARCHAR2,
      p_choice    VARCHAR2,
      p_intm_no   NUMBER,
      p_user_id   VARCHAR2
   )
      RETURN report_tab PIPELINED;

   FUNCTION get_giacr_162_details (
      p_from_dt     VARCHAR2,
      p_to_dt       VARCHAR2,
      p_choice      VARCHAR2,
      p_intm_no     NUMBER,
      p_cv_choice   VARCHAR2,
      p_cv_date     VARCHAR2,
      p_cv_no       VARCHAR2,
      p_tran_date   DATE,
      p_user_id   VARCHAR2
   )
      RETURN report_tab PIPELINED;
END;
/


