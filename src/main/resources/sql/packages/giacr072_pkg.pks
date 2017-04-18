CREATE OR REPLACE PACKAGE CPI.GIACR072_PKG
AS
   TYPE giacr072_type IS RECORD (
      branch_cd         giac_cm_dm.branch_cd%TYPE,
      branch_name       giac_branches.branch_name%TYPE,
      memo_type         giac_cm_dm.memo_type%TYPE,
      memo_year         giac_cm_dm.memo_year%TYPE,
      memo_seq_no       giac_cm_dm.memo_seq_no%TYPE,
      tran_date         giac_acctrans.tran_date%TYPE,
      posting_date      giac_acctrans.posting_date%TYPE,
      recipient         giac_cm_dm.recipient%TYPE,
      particulars       giac_cm_dm.particulars%TYPE,
      local_amt         giac_cm_dm.local_amt%TYPE,
      or_pref_suf       giac_order_of_payts.or_pref_suf%TYPE,
      or_no             VARCHAR2 (500),
      or_date           giac_order_of_payts.or_date%TYPE,
      particulars2      giac_order_of_payts.particulars%TYPE,
      amount            giac_collection_dtl.amount%TYPE,
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      from_date         VARCHAR2 (100),
      to_date           VARCHAR2 (100),
      cutoff_date       VARCHAR2 (100),
      cm_no             VARCHAR2 (100), -- added by robert SR 5199 02.22.16
      memo_type_desc    cg_ref_codes.rv_meaning%TYPE -- added by robert SR 5199 02.22.16
   );
   
   TYPE giacr072_tab IS TABLE OF giacr072_type;
   
   FUNCTION generate_giacr072 (
      p_user_id     VARCHAR2,
      p_module_id   VARCHAR2,
      p_memo_type   VARCHAR2,
      p_branch_cd   VARCHAR2,
      p_date_opt    VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_cutoff_date VARCHAR2
   )
      RETURN giacr072_tab PIPELINED;
   
END;
/


