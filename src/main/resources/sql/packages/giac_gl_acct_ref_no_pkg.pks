/* Created by   : Gzelle
 * Date Created : 11-06-2015
 * Remarks		: KB#132 - Accounting - AP/AR Enhancement
 */

CREATE OR REPLACE PACKAGE cpi.giac_gl_acct_ref_no_pkg
AS
   TYPE gl_acct_ref_no_type IS RECORD (
      gacc_tran_id     giac_gl_acct_ref_no.gacc_tran_id%TYPE,
      gl_acct_id       giac_gl_acct_ref_no.gl_acct_id%TYPE,
      ledger_cd        giac_gl_acct_ref_no.ledger_cd%TYPE,
      subledger_cd     giac_gl_acct_ref_no.subledger_cd%TYPE,
      transaction_cd   giac_gl_acct_ref_no.transaction_cd%TYPE,
      sl_cd            giac_gl_acct_ref_no.sl_cd%TYPE,
      acct_seq_no      giac_gl_acct_ref_no.acct_seq_no%TYPE
   );

   TYPE gl_acct_ref_no_tab IS TABLE OF gl_acct_ref_no_type;

   TYPE val_gl_type IS RECORD (
      ledger_cd         giac_gl_subaccount_types.ledger_cd%TYPE,
      subledger_cd      giac_gl_subaccount_types.subledger_cd%TYPE,
      dsp_is_existing   VARCHAR2 (1),
      dr_cr_tag         giac_chart_of_accts.dr_cr_tag%TYPE,
      dsp_sl_existing   VARCHAR2 (1)
   );

   TYPE val_gl_tab IS TABLE OF val_gl_type;

   TYPE gl_tran_type_type IS RECORD (
      count_             NUMBER,
      rownum_            NUMBER,
      transaction_cd     giac_gl_transaction_types.transaction_cd%TYPE,
      transaction_desc   giac_gl_transaction_types.transaction_desc%TYPE
   );

   TYPE gl_tran_type_tab IS TABLE OF gl_tran_type_type;

   TYPE tran_type_k_type IS RECORD (
      count_             NUMBER,
      rownum_            NUMBER,
      gl_acct_id         giac_gl_acct_ref_no.gl_acct_id%TYPE,
      gacc_tran_id       giac_gl_acct_ref_no.gacc_tran_id%TYPE,
      ledger_cd          giac_gl_subaccount_types.ledger_cd%TYPE,
      subledger_cd       giac_gl_subaccount_types.subledger_cd%TYPE,
      dr_cr_tag          giac_chart_of_accts.dr_cr_tag%TYPE,
      acct_seq_no        giac_gl_acct_ref_no.acct_seq_no%TYPE,            
      acct_ref_no        giac_acct_entries.acct_ref_no%TYPE,
      transaction_cd     giac_gl_transaction_types.transaction_cd%TYPE,
      transaction_desc   giac_gl_transaction_types.transaction_desc%TYPE,
      particulars        giac_acctrans.particulars%TYPE,
      ref_no             VARCHAR2 (24),
      outstanding_bal    NUMBER
   );

   TYPE tran_type_k_tab IS TABLE OF tran_type_k_type;
   
   TYPE val_rem_type IS RECORD(
       remaining_bal    giac_acct_entries.debit_amt%TYPE,
       dsp_rec_existing    VARCHAR2 (1)
   );
   
   TYPE val_rem_tab IS TABLE OF val_rem_type;

   FUNCTION val_gl_acct_id (
      p_gl_acct_id   giac_gl_subaccount_types.gl_acct_id%TYPE
   )
      RETURN val_gl_tab PIPELINED;

   FUNCTION get_gl_tran_type_lov (
      p_ledger_cd       giac_gl_subaccount_types.ledger_cd%TYPE,
      p_subledger_cd    giac_gl_subaccount_types.subledger_cd%TYPE,
      p_find_text       VARCHAR2,
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from            NUMBER,
      p_to              NUMBER
   )
      RETURN gl_tran_type_tab PIPELINED;

    PROCEDURE val_add_gl (
        p_gacc_tran_id   giac_gl_acct_ref_no.gacc_tran_id%TYPE,
        p_gl_acct_id     giac_gl_acct_ref_no.gl_acct_id%TYPE,
        p_ledger_cd      giac_gl_acct_ref_no.ledger_cd%TYPE,
        p_subledger_cd   giac_gl_acct_ref_no.subledger_cd%TYPE,
        p_transaction_cd giac_gl_acct_ref_no.transaction_cd%TYPE,
        p_sl_cd          giac_gl_acct_ref_no.sl_cd%TYPE,
        p_acct_seq_no    giac_gl_acct_ref_no.acct_seq_no%TYPE,
        p_acct_tran_type giac_gl_acct_ref_no.acct_tran_type%TYPE
    );      

   PROCEDURE set_gl_acct_ref_no (p_rec giac_gl_acct_ref_no%ROWTYPE);
   
   PROCEDURE del_gl_acct_ref_no (
      p_rec giac_gl_acct_ref_no%ROWTYPE
   );

   PROCEDURE upd_acct_seq_no (
      p_gacc_tran_id   giac_gl_acct_ref_no.gacc_tran_id%TYPE
   );

   FUNCTION get_remaining_balance(
      p_gl_acct_id      giac_gl_acct_ref_no.gl_acct_id%TYPE,
      p_sl_cd           giac_gl_acct_ref_no.sl_cd%TYPE,
      p_acct_ref_no     giac_acct_entries.acct_ref_no%TYPE
   )
      RETURN VARCHAR2;     
      
   FUNCTION val_remaining_balance(
       p_gacc_tran_id  giac_gl_acct_ref_no.gacc_tran_id%TYPE,
       p_gl_acct_id    giac_gl_acct_ref_no.gl_acct_id%TYPE,
       p_sl_cd         giac_gl_acct_ref_no.sl_cd%TYPE,
       p_acct_tran_type giac_gl_acct_ref_no.acct_tran_type%TYPE,   
       p_acct_ref_no     giac_acct_entries.acct_ref_no%TYPE,
       p_transaction_cd        giac_gl_acct_ref_no.transaction_cd%TYPE,
       p_acct_seq_no      giac_gl_acct_ref_no.acct_seq_no%TYPE
   )
        RETURN val_rem_tab PIPELINED;

   FUNCTION get_rec_to_knock_off (
      p_gl_acct_id            giac_gl_subaccount_types.gl_acct_id%TYPE,
      p_sl_cd                 giac_gl_acct_ref_no.sl_cd%TYPE,
      p_transaction_cd        giac_gl_acct_ref_no.transaction_cd%TYPE,
      p_acct_ref_no           VARCHAR2,
      p_tran_cd               VARCHAR2,
      p_tran_desc             VARCHAR2,
      p_particulars           VARCHAR2,
      p_ref_no                VARCHAR2,
      p_outstanding_balance   VARCHAR2,
      p_order_by              VARCHAR2,
      p_asc_desc_flag         VARCHAR2,
      p_from                  NUMBER,
      p_to                    NUMBER,
      p_added_acct_ref_no1    VARCHAR2,
      p_added_acct_ref_no2    VARCHAR2,
      p_added_acct_ref_no3    VARCHAR2,
      p_gacc_tran_id          giac_gl_acct_ref_no.gacc_tran_id%TYPE
   )
      RETURN tran_type_k_tab PIPELINED;
              
END;
/