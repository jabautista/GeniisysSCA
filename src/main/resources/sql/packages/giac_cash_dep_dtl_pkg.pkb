CREATE OR REPLACE PACKAGE BODY CPI.giac_cash_dep_dtl_pkg
AS
   FUNCTION get_gcdd_list (
      p_gacc_tran_id   giac_cash_dep_dtl.gacc_tran_id%TYPE,
      p_item_no        giac_cash_dep_dtl.item_no%TYPE
   )
      RETURN gcdd_list_tab PIPELINED
   IS
      v_gcdd_list   gcdd_list_type;
   BEGIN
      FOR i IN (SELECT gcdd.gacc_tran_id, gcdd.fund_cd, gcdd.branch_cd,
                       gcdd.dcb_year, gcdd.dcb_no, gcdd.item_no,
                       gcdd.currency_cd, gcdd.amount,
                       gcur.short_name currency_short_name,
                       gcdd.foreign_curr_amt, gcdd.currency_rt,
                       gcdd.net_deposit, gcdd.short_over, gcdd.remarks,
                       gcdd.book_tag, gcdd.user_id, gcdd.last_update
                  FROM giac_cash_dep_dtl gcdd, giis_currency gcur
                 WHERE gcdd.gacc_tran_id = p_gacc_tran_id
                   AND gcdd.item_no = p_item_no
                   AND gcdd.currency_cd = gcur.main_currency_cd(+))
      LOOP
         v_gcdd_list.gacc_tran_id := i.gacc_tran_id;
         v_gcdd_list.fund_cd := i.fund_cd;
         v_gcdd_list.branch_cd := i.branch_cd;
         v_gcdd_list.dcb_year := i.dcb_year;
         v_gcdd_list.dcb_no := i.dcb_no;
         v_gcdd_list.item_no := i.item_no;
         v_gcdd_list.currency_cd := i.currency_cd;
         v_gcdd_list.amount := i.amount;
         v_gcdd_list.currency_short_name := i.currency_short_name;
         v_gcdd_list.foreign_curr_amt := i.foreign_curr_amt;
         v_gcdd_list.currency_rt := i.currency_rt;
         v_gcdd_list.net_deposit := i.net_deposit;
         v_gcdd_list.short_over := i.short_over;
         v_gcdd_list.remarks := i.remarks;
         v_gcdd_list.book_tag := i.book_tag;
         v_gcdd_list.remarks := i.remarks;
         v_gcdd_list.user_id := i.user_id;
         v_gcdd_list.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY');
         PIPE ROW (v_gcdd_list);
      END LOOP;
   END get_gcdd_list;

   /*
   **  Created by   :  Emman
   **  Date Created :  04.14.2011
   **  Reference By : (GIACS035 - Close DCB)
   **  Description  : Gets the collection and deposit to be used in CASH_DEPOSITS return button when-button-pressed trigger
   */
   PROCEDURE get_col_and_dep (
      p_gacc_tran_id   IN       giac_cash_dep_dtl.gacc_tran_id%TYPE,
      p_fund_cd        IN       giac_cash_dep_dtl.fund_cd%TYPE,
      p_branch_cd      IN       giac_cash_dep_dtl.branch_cd%TYPE,
      p_dcb_year       IN       giac_cash_dep_dtl.dcb_year%TYPE,
      p_dcb_no         IN       giac_cash_dep_dtl.dcb_no%TYPE,
      p_item_no        IN       giac_cash_dep_dtl.item_no%TYPE,
      p_deposit_dtl    OUT      NUMBER,
      p_collection     OUT      NUMBER
   )
   IS
   BEGIN
      FOR i IN (SELECT SUM (amount) collection, SUM (net_deposit) deposit
                  FROM giac_cash_dep_dtl
                 WHERE gacc_tran_id = p_gacc_tran_id
                   AND fund_cd = p_fund_cd
                   AND branch_cd = p_branch_cd
                   AND dcb_year = p_dcb_year
                   AND dcb_no = p_dcb_no
                   AND item_no = p_item_no)
      LOOP
         p_deposit_dtl := i.deposit;
         p_collection := i.collection;
      END LOOP;
   END get_col_and_dep;

   PROCEDURE set_giac_cash_dep_dtl (
      p_gacc_tran_id       giac_cash_dep_dtl.gacc_tran_id%TYPE,
      p_fund_cd            giac_cash_dep_dtl.fund_cd%TYPE,
      p_branch_cd          giac_cash_dep_dtl.branch_cd%TYPE,
      p_dcb_year           giac_cash_dep_dtl.dcb_year%TYPE,
      p_dcb_no             giac_cash_dep_dtl.dcb_no%TYPE,
      p_item_no            giac_cash_dep_dtl.item_no%TYPE,
      p_currency_cd        giac_cash_dep_dtl.currency_cd%TYPE,
      p_amount             giac_cash_dep_dtl.amount%TYPE,
      p_foreign_curr_amt   giac_cash_dep_dtl.foreign_curr_amt%TYPE,
      p_currency_rt        giac_cash_dep_dtl.currency_rt%TYPE,
      p_net_deposit        giac_cash_dep_dtl.net_deposit%TYPE,
      p_short_over         giac_cash_dep_dtl.short_over%TYPE,
      p_remarks            giac_cash_dep_dtl.remarks%TYPE,
      p_book_tag           giac_cash_dep_dtl.book_tag%TYPE,
      p_user_id            giac_cash_dep_dtl.user_id%TYPE,
      p_last_update        giac_cash_dep_dtl.last_update%TYPE
   )
   IS
   BEGIN
      MERGE INTO giac_cash_dep_dtl
         USING DUAL
         ON (    gacc_tran_id = p_gacc_tran_id
             AND fund_cd = p_fund_cd
             AND branch_cd = p_branch_cd
             AND dcb_year = p_dcb_year
             AND dcb_no = p_dcb_no
             AND item_no = p_item_no)
         WHEN NOT MATCHED THEN
            INSERT (gacc_tran_id, fund_cd, branch_cd, dcb_year, dcb_no,
                    item_no, currency_cd, amount, foreign_curr_amt,
                    currency_rt, net_deposit, short_over, remarks, book_tag,
                    user_id, last_update)
            VALUES (p_gacc_tran_id, p_fund_cd, p_branch_cd, p_dcb_year,
                    p_dcb_no, p_item_no, p_currency_cd, p_amount,
                    p_foreign_curr_amt, p_currency_rt, p_net_deposit,
                    p_short_over, p_remarks, p_book_tag, p_user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET currency_cd = p_currency_cd, amount = p_amount,
                   foreign_curr_amt = p_foreign_curr_amt,
                   currency_rt = p_currency_rt, net_deposit = p_net_deposit,
                   short_over = p_short_over, remarks = p_remarks,
                   book_tag = p_book_tag, user_id = p_user_id,
                   last_update = SYSDATE
            ;
   END set_giac_cash_dep_dtl;

   PROCEDURE del_giac_cash_dep_dtl (
      p_gacc_tran_id   giac_cash_dep_dtl.gacc_tran_id%TYPE,
      p_fund_cd        giac_cash_dep_dtl.fund_cd%TYPE,
      p_branch_cd      giac_cash_dep_dtl.branch_cd%TYPE,
      p_dcb_year       giac_cash_dep_dtl.dcb_year%TYPE,
      p_dcb_no         giac_cash_dep_dtl.dcb_no%TYPE,
      p_item_no        giac_cash_dep_dtl.item_no%TYPE
   )
   IS
   BEGIN
      DELETE      giac_cash_dep_dtl
            WHERE gacc_tran_id = p_gacc_tran_id
              AND fund_cd = p_fund_cd
              AND branch_cd = p_branch_cd
              AND dcb_year = p_dcb_year
              AND dcb_no = p_dcb_no
              AND item_no = p_item_no;
   END del_giac_cash_dep_dtl;

   PROCEDURE del_giac_cash_dep_dtl (
      p_gacc_tran_id   giac_cash_dep_dtl.gacc_tran_id%TYPE,
      p_item_no        giac_cash_dep_dtl.item_no%TYPE
   )
   IS
   BEGIN
      DELETE FROM giac_cash_dep_dtl
            WHERE gacc_tran_id = p_gacc_tran_id AND item_no = p_item_no;
   END del_giac_cash_dep_dtl;
END giac_cash_dep_dtl_pkg;
/


