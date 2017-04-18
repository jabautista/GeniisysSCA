CREATE OR REPLACE PACKAGE CPI.giacs355_pkg
AS
   TYPE rec_type IS RECORD (
      fund_cd           giac_or_pref.fund_cd%TYPE,
      branch_cd         giac_or_pref.branch_cd%TYPE,
      branch_name       giac_branches.branch_name%TYPE,
      or_pref_suf       giac_or_pref.or_pref_suf%TYPE,
      or_type           giac_or_pref.or_type%TYPE,
      or_type_mean      cg_ref_codes.rv_meaning%TYPE,
      remarks           giac_or_pref.remarks%TYPE,
      user_id           giac_or_pref.user_id%TYPE,
      last_update       VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_fund_cd         giac_or_pref.fund_cd%TYPE,
      p_branch_cd       giac_or_pref.branch_cd%TYPE,
      p_or_pref_suf     giac_or_pref.or_pref_suf%TYPE,
      p_or_type         giac_or_pref.or_type%TYPE,
      p_module_id       VARCHAR2,
      p_user_id         VARCHAR2
   ) RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giac_or_pref%ROWTYPE);

   PROCEDURE del_rec (
      p_fund_cd         giac_or_pref.fund_cd%TYPE,
      p_branch_cd       giac_or_pref.branch_cd%TYPE,
      p_or_pref_suf     giac_or_pref.or_pref_suf%TYPE
   );

   PROCEDURE val_del_rec (
      p_fund_cd         giac_or_pref.fund_cd%TYPE,
      p_branch_cd       giac_or_pref.branch_cd%TYPE,
      p_or_pref_suf     giac_or_pref.or_pref_suf%TYPE
   );

   PROCEDURE val_add_rec (
      p_fund_cd         giac_or_pref.fund_cd%TYPE,
      p_branch_cd       giac_or_pref.branch_cd%TYPE,
      p_or_pref_suf     giac_or_pref.or_pref_suf%TYPE
   );
END;
/


