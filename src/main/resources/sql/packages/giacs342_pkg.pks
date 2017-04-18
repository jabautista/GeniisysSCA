CREATE OR REPLACE PACKAGE cpi.giacs342_pkg
AS
   TYPE gl_account_type IS RECORD (
      count_        NUMBER,
      rownum_       NUMBER,
      ledger_cd     giac_gl_account_types.ledger_cd%TYPE,
      ledger_desc   giac_gl_account_types.ledger_desc%TYPE
   );

   TYPE gl_account_type_tab IS TABLE OF gl_account_type;

   TYPE gl_subacct_type IS RECORD (
      count_           NUMBER,
      rownum_          NUMBER,
      subledger_cd     giac_gl_subaccount_types.subledger_cd%TYPE,
      subledger_desc   giac_gl_subaccount_types.subledger_desc%TYPE
   );

   TYPE gl_subacct_type_tab IS TABLE OF gl_subacct_type;

   TYPE gl_transaction_type IS RECORD (
      count_             NUMBER,
      rownum_            NUMBER,
      transaction_cd     giac_gl_transaction_types.transaction_cd%TYPE,
      transaction_desc   giac_gl_transaction_types.transaction_desc%TYPE
   );

   TYPE gl_transaction_type_tab IS TABLE OF gl_transaction_type;

   TYPE sl_name IS RECORD (
      count_    NUMBER,
      rownum_   NUMBER,
      sl_cd     giac_sl_lists.sl_cd%TYPE,
      sl_name   giac_sl_lists.sl_name%TYPE
   );

   TYPE sl_name_tab IS TABLE OF sl_name;

   FUNCTION get_gl_account_type (
      p_find_text       VARCHAR2,
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from            NUMBER,
      p_to              NUMBER
   )
      RETURN gl_account_type_tab PIPELINED;

   FUNCTION get_gl_subacct_type (
      p_find_text       VARCHAR2,
      p_ledger_cd       giac_gl_subaccount_types.ledger_cd%TYPE,
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from            NUMBER,
      p_to              NUMBER
   )
      RETURN gl_subacct_type_tab PIPELINED;

   FUNCTION get_gl_trans_type (
      p_find_text       VARCHAR2,
      p_ledger_cd       giac_gl_transaction_types.ledger_cd%TYPE,
      p_subledger_cd    giac_gl_transaction_types.subledger_cd%TYPE,
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from            NUMBER,
      p_to              NUMBER
   )
      RETURN gl_transaction_type_tab PIPELINED;

   FUNCTION get_sl_name (
      p_find_text       VARCHAR2,
      p_ledger_cd       giac_gl_account_types.ledger_cd%TYPE,
      p_subledger_cd    giac_gl_subaccount_types.subledger_cd%TYPE,
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from            NUMBER,
      p_to              NUMBER
   )
      RETURN sl_name_tab PIPELINED;
END;
/