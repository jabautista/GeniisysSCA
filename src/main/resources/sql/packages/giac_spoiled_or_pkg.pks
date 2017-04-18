CREATE OR REPLACE PACKAGE CPI.giac_spoiled_or_pkg
AS
   TYPE giac_spoiled_or_type IS RECORD (
      or_pref          giac_spoiled_or.or_pref%TYPE,
      or_no            giac_spoiled_or.or_no%TYPE,
      or_pref_no       VARCHAR2 (20),
      fund_cd          giac_spoiled_or.fund_cd%TYPE,
      branch_cd        giac_spoiled_or.branch_cd%TYPE,
      spoil_date       giac_spoiled_or.spoil_date%TYPE,
      spoil_tag        giac_spoiled_or.spoil_tag%TYPE,
      tran_id          giac_spoiled_or.tran_id%TYPE,
      or_date          giac_spoiled_or.or_date%TYPE,
      remarks          giac_spoiled_or.remarks%TYPE,
      spoil_tag_desc   cg_ref_codes.rv_meaning%TYPE,
      orig_or_pref     giac_spoiled_or.or_pref%TYPE,
      orig_or_no       giac_spoiled_or.or_no%TYPE
   );

   TYPE giac_spoiled_or_tab IS TABLE OF giac_spoiled_or_type;

   FUNCTION get_giac_spoiled_or_listing (
      p_fund_cd     giac_spoiled_or.fund_cd%TYPE,
      p_branch_cd   giac_spoiled_or.fund_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_or_pref     giac_spoiled_or.or_pref%TYPE,
      p_or_no       giac_spoiled_or.or_no%TYPE,
      p_or_date     giac_spoiled_or.or_date%TYPE
   )
      RETURN giac_spoiled_or_tab PIPELINED;

   PROCEDURE save_spoiled_or_dtls (
      p_or_pref       giac_spoiled_or.or_pref%TYPE,
      p_or_no         giac_spoiled_or.or_no%TYPE,
      p_old_or_pref   giac_spoiled_or.or_pref%TYPE,
      p_old_or_no     giac_spoiled_or.or_no%TYPE,
      p_fund_cd       giac_spoiled_or.fund_cd%TYPE,
      p_branch_cd     giac_spoiled_or.branch_cd%TYPE,
      p_spoil_date    giac_spoiled_or.spoil_date%TYPE,
      p_spoil_tag     giac_spoiled_or.spoil_tag%TYPE,
      p_or_date       giac_spoiled_or.or_date%TYPE
   );

   FUNCTION validate_or_no (
      p_or_pref     giac_spoiled_or.or_pref%TYPE,
      p_or_no       giac_spoiled_or.or_no%TYPE,
      p_fund_cd     giac_spoiled_or.fund_cd%TYPE,
      p_branch_cd   giac_spoiled_or.branch_cd%TYPE
   )
      RETURN VARCHAR2;
END giac_spoiled_or_pkg;
/


