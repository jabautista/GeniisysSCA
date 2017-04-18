DROP PROCEDURE CPI.INSERT_INTO_ORDER_OF_PAYTS;

CREATE OR REPLACE PROCEDURE CPI.insert_into_order_of_payts (
   p_fund_cd          giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
   p_branch_cd        giac_order_of_payts.gibr_branch_cd%TYPE,
   p_dcb_no           giac_order_of_payts.dcb_no%TYPE,
   p_or_pref_suf      giac_order_of_payts.or_pref_suf%TYPE,
   p_or_no            giac_order_of_payts.or_no%TYPE,
   p_acc_tran_id      giac_acctrans.tran_id%TYPE,
   p_payor            giac_order_of_payts.payor%TYPE,
   p_collection_amt   giac_order_of_payts.collection_amt%TYPE,
   p_cashier_cd       giac_order_of_payts.cashier_cd%TYPE,
   p_or_tag           giac_order_of_payts.or_tag%TYPE,
   p_gross_amt        giac_order_of_payts.gross_amt%TYPE,
   p_gross_tag        giac_order_of_payts.gross_tag%TYPE
)
IS
   v_particulars   giac_order_of_payts.particulars%TYPE;
BEGIN
   v_particulars :=
         'Reversing entry for cancelled OR No.'
      || p_or_pref_suf
      || ' '
      || TO_CHAR (p_or_no)
      || '.';

   INSERT INTO giac_order_of_payts
               (gacc_tran_id, gibr_gfun_fund_cd, gibr_branch_cd, payor,
                user_id, last_update,
                collection_amt, cashier_cd, particulars, or_tag,
                or_date, dcb_no, gross_amt, gross_tag, or_cancel_tag
               )
        VALUES (p_acc_tran_id, p_fund_cd, p_branch_cd, p_payor,
                NVL (giis_users_pkg.app_user, USER), SYSDATE,
                p_collection_amt, p_cashier_cd, v_particulars, p_or_tag,
                SYSDATE, p_dcb_no, p_gross_amt, p_gross_tag, 'Y'
               );
END;
/


