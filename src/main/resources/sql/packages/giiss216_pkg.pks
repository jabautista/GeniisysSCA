CREATE OR REPLACE PACKAGE CPI.giiss216_pkg
AS
   TYPE branch_type IS RECORD (
      branch_cd      giis_banc_branch.branch_cd%TYPE,
      branch_desc    giis_banc_branch.branch_desc%TYPE,
      area_cd        giis_banc_area.area_cd%TYPE,
      area_desc      giis_banc_area.area_desc%TYPE,
      eff_date       giis_banc_branch.eff_date%TYPE,
      manager_cd     giis_banc_branch.manager_cd%TYPE,
      manager_name   VARCHAR2 (1000),
      bank_acct_cd   giis_banc_branch.bank_acct_cd%TYPE,
      mgr_eff_date   giis_banc_branch.mgr_eff_date%TYPE,
      remarks        giis_banc_branch.remarks%TYPE,
      user_id        giis_banc_branch.user_id%TYPE,
      last_update    VARCHAR2 (50)
   );

   TYPE branch_tab IS TABLE OF branch_type;

   FUNCTION get_branch
      RETURN branch_tab PIPELINED;

   TYPE manager_type IS RECORD (
      manager_cd     giis_banc_branch.manager_cd%TYPE,
      manager_name   VARCHAR2 (1000)
   );

   TYPE manager_tab IS TABLE OF manager_type;

   FUNCTION get_manager_lov
      RETURN manager_tab PIPELINED;

   PROCEDURE save_record (p_rec giis_banc_branch%ROWTYPE);

   TYPE hist_type IS RECORD (
      old_area_cd        giis_banc_area.area_cd%TYPE,
      new_area_cd        giis_banc_area.area_cd%TYPE,
      old_eff_date       DATE,
      new_eff_date       DATE,
      user_id            giis_users.user_id%TYPE,
      last_update        VARCHAR2 (50),
      old_manager_cd     giis_banc_branch.manager_cd%TYPE,
      new_manager_cd     giis_banc_branch.manager_cd%TYPE,
      old_bank_acct_cd   giis_banc_branch.bank_acct_cd%TYPE,
      new_bank_acct_cd   giis_banc_branch.bank_acct_cd%TYPE,
      old_mgr_eff_date   giis_banc_branch.mgr_eff_date%TYPE,
      new_mgr_eff_date   giis_banc_branch.mgr_eff_date%TYPE,
      branch_cd          giis_banc_branch.branch_cd%TYPE
   );

   TYPE hist_tab IS TABLE OF hist_type;

   FUNCTION get_history (p_branch_cd VARCHAR2)
      RETURN hist_tab PIPELINED;

   PROCEDURE val_add_rec (
      p_branch_cd     VARCHAR2,
      p_branch_desc   VARCHAR2,
      p_area_cd       VARCHAR2,
      p_stat          VARCHAR2
   );
END;
/


