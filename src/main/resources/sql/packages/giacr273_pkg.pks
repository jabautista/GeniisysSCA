CREATE OR REPLACE PACKAGE CPI.giacr273_pkg
AS
/*
    **  Created by   :  Melvin John O. Ostia
    **  Date Created : 06.25.2013
    **  Reference By : GIACR273_PKG - Disbursement List
    */
   TYPE giacr273_record_type IS RECORD (
      gacc_tran_id      NUMBER (12),
      dv_date           DATE,
      dv_no             NUMBER (10),
      dv_ref_no         VARCHAR2 (100),
      dv_dec_ref_no     VARCHAR2 (100),
      dv_amt            NUMBER (12, 2),
      payee             giac_disb_vouchers.PAYEE%TYPE, -- VARCHAR2 (300),
      branch_cd         VARCHAR2 (2),
      document_cd       VARCHAR2 (5),
      gl_acct           VARCHAR2 (100),
      gl_acct_sname     VARCHAR2 (35),
      debit_amt         NUMBER (12, 2),
      credit_amt        NUMBER (12, 2),
      company_fund_cd   giac_disb_vouchers.gibr_gfun_fund_cd%TYPE, --Dren Niebres 05.04.2016 SR-5225
      company_name      VARCHAR2 (500),
      address           VARCHAR2 (500),
      fdate             VARCHAR2 (100),
      gl_accnt_no       VARCHAR2 (200),
      account_name      VARCHAR2 (300),
      d_debit           NUMBER (12, 2),
      d_credit          NUMBER (12, 2),
      branch_cd_one     VARCHAR2 (100),
      document_cd_one   VARCHAR2 (100),
      branch_name       VARCHAR2 (100),
      print_details     VARCHAR2 (1),
      dv_flag           giac_disb_vouchers.DV_FLAG%TYPE,
      dv_status         cg_ref_codes.RV_MEANING%TYPE
   );

   TYPE giacr273_record_tab IS TABLE OF giacr273_record_type;

   FUNCTION get_giacr273_records (p_branch VARCHAR2, p_doc_cd VARCHAR2, p_date1 DATE, p_date2 DATE, p_trunc_date VARCHAR2, p_user_id VARCHAR2)
      RETURN giacr273_record_tab PIPELINED;

   FUNCTION get_giacr273_records_1 (p_branch VARCHAR2, p_doc_cd VARCHAR2, p_date1 DATE, p_date2 DATE, p_trunc_date VARCHAR2, p_user_id VARCHAR2)
      RETURN giacr273_record_tab PIPELINED;
END;
/
