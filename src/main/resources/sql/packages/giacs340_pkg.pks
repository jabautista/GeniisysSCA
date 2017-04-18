/* Created by   : Gzelle
 * Date Created : 10-27-2015
 * Remarks		: KB#132 - Accounting - AP/AR Enhancement
 */
CREATE OR REPLACE PACKAGE cpi.giacs340_pkg
AS
   TYPE gl_acct_type IS RECORD (
      count_        NUMBER,
      rownum_       NUMBER,
      ledger_cd     giac_gl_account_types.ledger_cd%TYPE,
      ledger_desc   giac_gl_account_types.ledger_desc%TYPE,
      active_tag    giac_gl_account_types.active_tag%TYPE,
      dsp_active_tag VARCHAR2(4),
      remarks       giac_gl_account_types.remarks%TYPE,
      user_id       giac_gl_account_types.user_id%TYPE,
      last_update   VARCHAR2 (30)
   );

   TYPE gl_acct_type_tab IS TABLE OF gl_acct_type;

   FUNCTION get_gl_acct_type (
      p_ledger_cd       giac_gl_account_types.ledger_cd%TYPE,
      p_ledger_desc     giac_gl_account_types.ledger_desc%TYPE,
      p_dsp_active_tag  giac_gl_account_types.active_tag%TYPE,
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from            NUMBER,
      p_to              NUMBER
   )
      RETURN gl_acct_type_tab PIPELINED;

   PROCEDURE set_gl_acct_type (
       p_orig_ledger_cd   giac_gl_account_types.ledger_cd%TYPE,
       p_btn_val          VARCHAR2,
       p_rec              giac_gl_account_types%ROWTYPE
   );

   PROCEDURE val_del_rec (
      p_ledger_cd   giac_gl_account_types.ledger_cd%TYPE
   );

   PROCEDURE val_add_rec (
      p_ledger_cd      giac_gl_account_types.ledger_cd%TYPE,
      p_btn_val        VARCHAR2
   );

   PROCEDURE val_upd_rec (
      p_curr_ledger_cd giac_gl_account_types.ledger_cd%TYPE
   );   

   PROCEDURE del_gl_acct_type (
      p_ledger_cd   giac_gl_account_types.ledger_cd%TYPE
   );
END;
/