/* Created by   : Gzelle
 * Date Created : 10-29-2015
 * Remarks		: KB#132 - Accounting - AP/AR Enhancement
 */
CREATE OR REPLACE PACKAGE cpi.giacs341_pkg
AS
   TYPE gl_subacct_type IS RECORD (
      count_             NUMBER,
      rownum_            NUMBER,
      ledger_cd          giac_gl_subaccount_types.ledger_cd%TYPE,
      subledger_cd       giac_gl_subaccount_types.subledger_cd%TYPE,
      subledger_desc     giac_gl_subaccount_types.subledger_desc%TYPE,
      gl_acct_id         giac_gl_subaccount_types.gl_acct_id%TYPE,
      gl_acct_category   giac_gl_subaccount_types.gl_acct_category%TYPE,
      gl_control_acct    giac_gl_subaccount_types.gl_control_acct%TYPE,
      gl_sub_acct_1      giac_gl_subaccount_types.gl_sub_acct_1%TYPE,
      gl_sub_acct_2      giac_gl_subaccount_types.gl_sub_acct_2%TYPE,
      gl_sub_acct_3      giac_gl_subaccount_types.gl_sub_acct_3%TYPE,
      gl_sub_acct_4      giac_gl_subaccount_types.gl_sub_acct_4%TYPE,
      gl_sub_acct_5      giac_gl_subaccount_types.gl_sub_acct_5%TYPE,
      gl_sub_acct_6      giac_gl_subaccount_types.gl_sub_acct_6%TYPE,
      gl_sub_acct_7      giac_gl_subaccount_types.gl_sub_acct_7%TYPE,
      gl_acct_name       giac_gl_subaccount_types.gl_acct_name%TYPE,
      active_tag         giac_gl_subaccount_types.active_tag%TYPE,
      remarks            giac_gl_subaccount_types.remarks%TYPE,
      user_id            giac_gl_subaccount_types.user_id%TYPE,
      last_update        VARCHAR2 (30)
   );

   TYPE gl_subacct_type_tab IS TABLE OF gl_subacct_type;
   
   TYPE gl_acct_code_type IS RECORD (
      count_             NUMBER,
      rownum_            NUMBER,
      gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
      gl_acct_category   giac_chart_of_accts.gl_acct_category%TYPE,
      gl_control_acct    giac_chart_of_accts.gl_control_acct%TYPE,
      gl_sub_acct_1      giac_chart_of_accts.gl_sub_acct_1%TYPE,
      gl_sub_acct_2      giac_chart_of_accts.gl_sub_acct_2%TYPE,
      gl_sub_acct_3      giac_chart_of_accts.gl_sub_acct_3%TYPE,
      gl_sub_acct_4      giac_chart_of_accts.gl_sub_acct_4%TYPE,
      gl_sub_acct_5      giac_chart_of_accts.gl_sub_acct_5%TYPE,
      gl_sub_acct_6      giac_chart_of_accts.gl_sub_acct_6%TYPE,
      gl_sub_acct_7      giac_chart_of_accts.gl_sub_acct_7%TYPE,
      gl_acct_name       giac_chart_of_accts.gl_acct_name%TYPE
   );

   TYPE gl_acct_code_tab IS TABLE OF gl_acct_code_type; 

   TYPE gl_acct_id_type IS RECORD (
      gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE
   );

   TYPE gl_acct_id_tab IS TABLE OF gl_acct_id_type;    

   TYPE gl_transaction_type IS RECORD (
      count_             NUMBER,
      rownum_            NUMBER,
      ledger_cd          giac_gl_transaction_types.ledger_cd%TYPE,
      subledger_cd       giac_gl_transaction_types.subledger_cd%TYPE,
      transaction_cd     giac_gl_transaction_types.transaction_cd%TYPE,
      transaction_desc   giac_gl_transaction_types.transaction_desc%TYPE,
      active_tag         giac_gl_transaction_types.active_tag%TYPE,
      dsp_active_tag     VARCHAR2(4),
      remarks            giac_gl_transaction_types.remarks%TYPE,
      user_id            giac_gl_transaction_types.user_id%TYPE,
      last_update        VARCHAR2 (30)
   );

   TYPE gl_transaction_type_tab IS TABLE OF gl_transaction_type;     

   FUNCTION get_gl_subacct_type (
      p_ledger_cd          giac_gl_subaccount_types.ledger_cd%TYPE,
      p_subledger_cd       giac_gl_subaccount_types.subledger_cd%TYPE,
      p_subledger_desc     giac_gl_subaccount_types.subledger_desc%TYPE,
      p_gl_acct_category   giac_gl_subaccount_types.gl_acct_category%TYPE,
      p_gl_control_acct    giac_gl_subaccount_types.gl_control_acct%TYPE,
      p_gl_sub_acct_1      giac_gl_subaccount_types.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2      giac_gl_subaccount_types.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3      giac_gl_subaccount_types.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4      giac_gl_subaccount_types.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5      giac_gl_subaccount_types.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6      giac_gl_subaccount_types.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7      giac_gl_subaccount_types.gl_sub_acct_7%TYPE,
      p_gl_acct_name       giac_gl_subaccount_types.gl_acct_name%TYPE,
      p_order_by           VARCHAR2,
      p_asc_desc_flag      VARCHAR2,
      p_from               NUMBER,
      p_to                 NUMBER
   )
      RETURN gl_subacct_type_tab PIPELINED;

   PROCEDURE set_gl_subacct_type (
      p_orig_subledger_cd   giac_gl_subaccount_types.subledger_cd%TYPE,
      p_btn_val             VARCHAR2,
      p_rec                 giac_gl_subaccount_types%ROWTYPE
   );

   PROCEDURE val_del_rec (
      p_ledger_cd      giac_gl_subaccount_types.ledger_cd%TYPE,
      p_subledger_cd   giac_gl_subaccount_types.subledger_cd%TYPE
   );

   PROCEDURE val_add_rec (
      p_ledger_cd      giac_gl_subaccount_types.ledger_cd%TYPE,
      p_subledger_cd   giac_gl_subaccount_types.subledger_cd%TYPE,
      p_btn_val        VARCHAR2
   );
   
   PROCEDURE val_upd_rec (
      p_ledger_cd        giac_gl_subaccount_types.ledger_cd%TYPE,
      p_new_subledger_cd giac_gl_subaccount_types.subledger_cd%TYPE
   );

   PROCEDURE del_gl_subacct_type (
      p_ledger_cd      giac_gl_subaccount_types.ledger_cd%TYPE,
      p_subledger_cd   giac_gl_subaccount_types.subledger_cd%TYPE
   );
   
   FUNCTION get_giacs341_gl_acct_code(
      p_not_in1           VARCHAR2,            
      p_not_in2           VARCHAR2,
      p_not_in3           VARCHAR2,
      p_find_text         VARCHAR2,
      p_order_by          VARCHAR2,
      p_asc_desc_flag     VARCHAR2,
      p_from              NUMBER,
      p_to                NUMBER
   )
      RETURN gl_acct_code_tab PIPELINED;
    
   FUNCTION get_all_gl_acct_code
    RETURN gl_acct_id_tab PIPELINED;     

   /*giac_gl_transaction_types*/
   FUNCTION get_gl_transaction_type (
      p_ledger_cd          giac_gl_transaction_types.ledger_cd%TYPE,
      p_subledger_cd       giac_gl_transaction_types.subledger_cd%TYPE,
      p_transaction_cd     giac_gl_transaction_types.transaction_cd%TYPE,
      p_transaction_desc   giac_gl_transaction_types.transaction_desc%TYPE,
      p_active_tag         giac_gl_transaction_types.active_tag%TYPE,
      p_order_by           VARCHAR2,
      p_asc_desc_flag      VARCHAR2,
      p_from               NUMBER,
      p_to                 NUMBER
   )
      RETURN gl_transaction_type_tab PIPELINED;  
      
   PROCEDURE set_gl_transaction_type (
      p_orig_transaction_cd giac_gl_transaction_types.subledger_cd%TYPE,
      p_btn_val             VARCHAR2,
      p_rec                 giac_gl_transaction_types%ROWTYPE
   );

   PROCEDURE val_del_rec (
      p_ledger_cd      giac_gl_transaction_types.ledger_cd%TYPE,
      p_subledger_cd   giac_gl_transaction_types.subledger_cd%TYPE,
      p_transaction_cd giac_gl_transaction_types.transaction_cd%TYPE
   );

   PROCEDURE val_add_rec (
      p_ledger_cd      giac_gl_transaction_types.ledger_cd%TYPE,
      p_subledger_cd   giac_gl_transaction_types.subledger_cd%TYPE,
      p_transaction_cd giac_gl_transaction_types.transaction_cd%TYPE,
      p_btn_val        VARCHAR2
   );
   
   PROCEDURE val_upd_tran_rec (
      p_ledger_cd           giac_gl_transaction_types.ledger_cd%TYPE,
      p_subledger_cd        giac_gl_transaction_types.subledger_cd%TYPE,
      p_new_transaction_cd  giac_gl_transaction_types.transaction_cd%TYPE
   );

   PROCEDURE del_gl_transaction_type (
      p_ledger_cd      giac_gl_transaction_types.ledger_cd%TYPE,
      p_subledger_cd   giac_gl_transaction_types.subledger_cd%TYPE,
      p_transaction_cd giac_gl_transaction_types.transaction_cd%TYPE
   );   
     
END;
/