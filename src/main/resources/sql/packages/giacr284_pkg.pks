CREATE OR REPLACE PACKAGE CPI.giacr284_pkg
AS
   TYPE giacr284_prem_colln_dtl_type IS RECORD (
      company_name            giis_parameters.param_value_v%TYPE,
      company_address         giis_parameters.param_value_v%TYPE,
      from_to_date            VARCHAR2 (100),
      branch_cd               giac_order_of_payts.gibr_branch_cd%TYPE,
      branch_name             VARCHAR2 (50),
      iss_cd                  giac_direct_prem_collns.b140_iss_cd%TYPE,
      gacc_tran_id            giac_order_of_payts.gacc_tran_id%TYPE,
      or_no                   VARCHAR2 (20),
                                      --GIAC_ORDER_OF_PAYTS.OR_PREF_SUF%TYPE,
      payor                   giac_order_of_payts.payor%TYPE,
      particulars             giac_order_of_payts.particulars%TYPE,
      pay_mode                VARCHAR2 (20),
                                         --GIAC_COLLECTION_DTL.PAY_MODE%TYPE,
      check_no                VARCHAR2 (100),          --giac_collection_dtl.
      collection_amt          giac_direct_prem_collns.collection_amt%TYPE,
-- not sure which should be displayed as AMOUNT RECEIVED between this and the following collection_amt_dtl
      direct_collection_amt   giac_collection_dtl.amount%TYPE,
-- this is the amount displayed as AMOUNT RECEIVED in jasper as of 2012.10.22
      policy_no               VARCHAR2 (100),
      bill_no                 VARCHAR2 (20),
                                  --GIAC_DIRECT_PREM_COLLNS.B140_ISS_CD%TYPE,
      premium_amt             giac_direct_prem_collns.premium_amt%TYPE,
      tax_amt                 giac_direct_prem_collns.tax_amt%TYPE,
      intm_no                 giac_comm_payts.intm_no%TYPE,
      comm_amt                giac_comm_payts.comm_amt%TYPE,
      wtax_amt                giac_comm_payts.wtax_amt%TYPE,
      input_vat_amt           giac_comm_payts.input_vat_amt%TYPE,
      item_no                 VARCHAR2 (20)
                                           --GIAC_COLLECTION_DTL.ITEM_NO%TYPE
   );

   TYPE giacr284_prem_colln_dtl_tab IS TABLE OF giacr284_prem_colln_dtl_type;

   /* TYPE giacr284_prem_colln_hdr_type IS RECORD (
        company_name    giis_parameters.param_value_v%TYPE,
        company_address giis_parameters.param_value_v%TYPE,
        from_to_date    VARCHAR2 (100),
        rundate         VARCHAR2 (20),
        runtime         VARCHAR2 (20)
    );

    TYPE giacr284_prem_colln_hdr_tab IS TABLE OF giacr284_prem_colln_hdr_type;

    FUNCTION get_giacr284_header(
        p_date       NUMBER, --if 1 - tran date, else posting date =
        p_from_date  DATE,
        p_to_date    DATE,
        p_branch_cd  GIAC_ORDER_OF_PAYTS.GIBR_BRANCH_CD%TYPE
    ) RETURN giacr284_prem_colln_hdr_tab PIPELINED;*/
   FUNCTION get_giacr284_details (
      p_date        NUMBER,            --if 1 - tran date, else posting date =
      p_from_date   DATE,
      p_to_date     DATE,
      p_branch_cd   giac_order_of_payts.gibr_branch_cd%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN giacr284_prem_colln_dtl_tab PIPELINED;

   FUNCTION get_cf_company_nameformula
      RETURN VARCHAR2;

   FUNCTION get_cf_company_addformula
      RETURN VARCHAR2;

   FUNCTION get_cf_from_toformula (p_from_date DATE, p_to_date DATE)
      RETURN VARCHAR2;

   FUNCTION get_cf_branch_nameformula (
      p_branch_cd   giac_order_of_payts.gibr_branch_cd%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_cf_policy_noformula (p_bill_no VARCHAR2)
      RETURN VARCHAR2;
      
   FUNCTION get_cf_policy_noformula2 ( -- bonok :: 6.24.2015 :: SR 4719 - for optimization
      p_iss_cd       gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no  gipi_invoice.prem_seq_no%TYPE
   )
      RETURN VARCHAR2;
END giacr284_pkg;
/


