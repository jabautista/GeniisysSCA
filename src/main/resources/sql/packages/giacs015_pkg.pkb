CREATE OR REPLACE PACKAGE BODY CPI.GIACS015_PKG
AS
/*
    **  Created by   :  Kenneth Mark Labrador
    **  Date Created : 06.06.2013
    **  Reference By : GIACS015 - Other Collections
    */
   FUNCTION get_other_payments (
      p_gacc_tran_id   giac_other_collections.gacc_tran_id%TYPE,
      p_fund_cd        giac_sl_lists.fund_cd%TYPE
   )
      RETURN other_payments_tab PIPELINED
   IS
      v_other   other_payments_type;
   BEGIN --comment by Jerome
      FOR o IN (SELECT   or_print_tag, gacc_tran_id, item_no,
                         transaction_type, collection_amt, gl_acct_category,
                         gl_control_acct, gl_sub_acct_1, gl_sub_acct_2,
                         gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5,
                         gl_sub_acct_6, gl_sub_acct_7, gl_acct_id, sl_cd,
                         gotc_item_no, particulars, gotc_gacc_tran_id,
                         user_id, last_update
                    FROM giac_other_collections
                   WHERE gacc_tran_id = p_gacc_tran_id
                ORDER BY item_no)
      LOOP
         v_other.or_print_tag := o.or_print_tag;
         v_other.gacc_tran_id := o.gacc_tran_id;
         v_other.item_no := o.item_no;
         v_other.transaction_type := o.transaction_type;
         v_other.collection_amt := o.collection_amt;
         v_other.gl_acct_category := o.gl_acct_category;
         v_other.gl_control_acct := o.gl_control_acct;
         v_other.gl_sub_acct_1 := o.gl_sub_acct_1;
         v_other.gl_sub_acct_2 := o.gl_sub_acct_2;
         v_other.gl_sub_acct_3 := o.gl_sub_acct_3;
         v_other.gl_sub_acct_4 := o.gl_sub_acct_4;
         v_other.gl_sub_acct_5 := o.gl_sub_acct_5;
         v_other.gl_sub_acct_6 := o.gl_sub_acct_6;
         v_other.gl_sub_acct_7 := o.gl_sub_acct_7;
         v_other.gl_acct_id := o.gl_acct_id;
         v_other.sl_cd := o.sl_cd;
         v_other.gotc_item_no := o.gotc_item_no;
         v_other.particulars := o.particulars;
         v_other.gotc_gacc_tran_id := o.gotc_gacc_tran_id;
         v_other.user_id := o.user_id;
         v_other.last_update := o.last_update;
         v_other.old_item_no := o.gotc_item_no;

         BEGIN
            SELECT DISTINCT gl_acct_name, gslt_sl_type_cd
                       INTO v_other.dsp_account_name, v_other.sl_type_cd
                       FROM giac_chart_of_accts
                      WHERE gl_acct_id = o.gl_acct_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_other.dsp_account_name := NULL;
               v_other.sl_type_cd := NULL;
            WHEN OTHERS
            THEN
               v_other.dsp_account_name := NULL;
               v_other.sl_type_cd := NULL;
         END;

         BEGIN
            SELECT DISTINCT sl_name
                       INTO v_other.dsp_sl_name
                       FROM giac_sl_lists
                      WHERE fund_cd = p_fund_cd
                        AND sl_type_cd IN (1, v_other.sl_type_cd)
                        --AND sl_type_cd = v_other.sl_type_cd
                        AND sl_cd = o.sl_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_other.dsp_sl_name := NULL;
            WHEN OTHERS
            THEN
               v_other.dsp_sl_name := NULL;
         END;

         BEGIN
            SELECT SUBSTR (rv_meaning, 1, 25) rv_meaning
              INTO v_other.tran_type_meaning
              FROM cg_ref_codes
             WHERE rv_domain = 'GIAC_OTHER_COLLECTIONS.TRANSACTION_TYPE'
               AND rv_low_value = o.transaction_type;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_other.tran_type_meaning := NULL;
            WHEN OTHERS
            THEN
               v_other.tran_type_meaning := NULL;
         END;

         BEGIN
            SELECT ga.tran_year, ga.tran_month,
                   ga.tran_seq_no
              INTO v_other.dsp_tran_year, v_other.dsp_tran_month,
                   v_other.dsp_tran_seq_no
              FROM giac_other_collections goc, giac_acctrans ga
             WHERE (   goc.gacc_tran_id = o.gotc_gacc_tran_id
                    OR (    goc.gacc_tran_id IS NULL
                        AND o.gotc_gacc_tran_id IS NULL
                       )
                   )
               AND (   goc.item_no = o.gotc_item_no
                    OR (goc.item_no IS NULL AND o.gotc_item_no IS NULL)
                   )
               AND gotc_gacc_tran_id IS NULL
               AND ga.tran_id = goc.gacc_tran_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_other.dsp_tran_year := NULL;
               v_other.dsp_tran_month := NULL;
               v_other.dsp_tran_seq_no := NULL;
            WHEN OTHERS
            THEN
               v_other.dsp_tran_year := NULL;
               v_other.dsp_tran_month := NULL;
               v_other.dsp_tran_seq_no := NULL;
         END;

         IF     v_other.dsp_tran_year IS NOT NULL
            AND v_other.dsp_tran_month IS NOT NULL
            AND v_other.dsp_tran_seq_no IS NOT NULL
         THEN
            v_other.old_trans_no :=
                  LTRIM (TO_CHAR (v_other.dsp_tran_year, '0999'))
               || '-'
               || LTRIM (TO_CHAR (v_other.dsp_tran_month, '09'))
               || '-'
               || LTRIM (TO_CHAR (v_other.dsp_tran_seq_no, '099999'));
         ELSE
            v_other.old_trans_no := NULL;
         END IF;

         BEGIN
            SELECT MAX (item_no)
              INTO v_other.max_item
              FROM giac_other_collections
             WHERE gacc_tran_id = p_gacc_tran_id;
         END;

         BEGIN
            SELECT SUM (collection_amt)
              INTO v_other.total_amounts
              FROM giac_other_collections
             WHERE gacc_tran_id = p_gacc_tran_id;
         END;

         v_other.tran_type_desc :=
                      o.transaction_type || ' - ' || v_other.tran_type_meaning;
         PIPE ROW (v_other);
      END LOOP;

      RETURN;
   END get_other_payments;

   FUNCTION get_gl_acct_list (
      p_gl_acct_category   giac_chart_of_accts.gl_acct_category%TYPE,
      p_gl_control_acct    giac_chart_of_accts.gl_control_acct%TYPE,
      p_gl_sub_acct_1      giac_chart_of_accts.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2      giac_chart_of_accts.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3      giac_chart_of_accts.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4      giac_chart_of_accts.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5      giac_chart_of_accts.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6      giac_chart_of_accts.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7      giac_chart_of_accts.gl_sub_acct_7%TYPE
   )
      RETURN gl_acct_list_tab PIPELINED
   IS
      v_list   gl_acct_list_type;
   BEGIN
      FOR i IN (SELECT   gicoa.gl_acct_category,
                         LPAD (gicoa.gl_control_acct, 2, '0')
                                                             gl_control_acct,
                         LPAD (gicoa.gl_sub_acct_1, 2, '0') gl_sub_acct_1,
                         LPAD (gicoa.gl_sub_acct_2, 2, '0') gl_sub_acct_2,
                         LPAD (gicoa.gl_sub_acct_3, 2, '0') gl_sub_acct_3,
                         LPAD (gicoa.gl_sub_acct_4, 2, '0') gl_sub_acct_4,
                         LPAD (gicoa.gl_sub_acct_5, 2, '0') gl_sub_acct_5,
                         LPAD (gicoa.gl_sub_acct_6, 2, '0') gl_sub_acct_6,
                         LPAD (gicoa.gl_sub_acct_7, 2, '0') gl_sub_acct_7,
                         gicoa.gl_acct_name, gicoa.gslt_sl_type_cd,
                         gicoa.gl_acct_id
                    FROM giac_chart_of_accts gicoa
                   WHERE gicoa.gl_acct_category =
                             NVL (p_gl_acct_category, gicoa.gl_acct_category)
                     AND gicoa.gl_control_acct =
                                NVL (p_gl_control_acct, gicoa.gl_control_acct)
                     AND gicoa.gl_sub_acct_1 =
                                    NVL (p_gl_sub_acct_1, gicoa.gl_sub_acct_1)
                     AND gicoa.gl_sub_acct_2 =
                                    NVL (p_gl_sub_acct_2, gicoa.gl_sub_acct_2)
                     AND gicoa.gl_sub_acct_3 =
                                    NVL (p_gl_sub_acct_3, gicoa.gl_sub_acct_3)
                     AND gicoa.gl_sub_acct_4 =
                                    NVL (p_gl_sub_acct_4, gicoa.gl_sub_acct_4)
                     AND gicoa.gl_sub_acct_5 =
                                    NVL (p_gl_sub_acct_5, gicoa.gl_sub_acct_5)
                     AND gicoa.gl_sub_acct_6 =
                                    NVL (p_gl_sub_acct_6, gicoa.gl_sub_acct_6)
                     AND gicoa.gl_sub_acct_7 =
                                    NVL (p_gl_sub_acct_7, gicoa.gl_sub_acct_7)
                     AND gicoa.leaf_tag = 'Y'
                ORDER BY gicoa.gl_acct_category,
                         gicoa.gl_control_acct,
                         gicoa.gl_sub_acct_1,
                         gicoa.gl_sub_acct_2,
                         gicoa.gl_sub_acct_3,
                         gicoa.gl_sub_acct_4,
                         gicoa.gl_sub_acct_5,
                         gicoa.gl_sub_acct_6,
                         gicoa.gl_sub_acct_7)
      LOOP
         v_list.gl_acct_category := i.gl_acct_category;
         v_list.gl_control_acct := i.gl_control_acct;
         v_list.gl_sub_acct_1 := i.gl_sub_acct_1;
         v_list.gl_sub_acct_2 := i.gl_sub_acct_2;
         v_list.gl_sub_acct_3 := i.gl_sub_acct_3;
         v_list.gl_sub_acct_4 := i.gl_sub_acct_4;
         v_list.gl_sub_acct_5 := i.gl_sub_acct_5;
         v_list.gl_sub_acct_6 := i.gl_sub_acct_6;
         v_list.gl_sub_acct_7 := i.gl_sub_acct_7;
         v_list.gl_acct_name := i.gl_acct_name;
         v_list.gl_acct_id := i.gl_acct_id;
         v_list.gslt_sl_type_cd := i.gslt_sl_type_cd;
         v_list.gl_acct_code :=
               i.gl_acct_category
            || ' - '
            || i.gl_control_acct
            || ' - '
            || i.gl_sub_acct_1
            || ' - '
            || i.gl_sub_acct_2
            || ' - '
            || i.gl_sub_acct_3
            || ' - '
            || i.gl_sub_acct_4
            || ' - '
            || i.gl_sub_acct_5
            || ' - '
            || i.gl_sub_acct_6
            || ' - '
            || i.gl_sub_acct_7;
         PIPE ROW (v_list);
      END LOOP;
   END get_gl_acct_list;

   FUNCTION get_sl_lists (
      p_fund_cd      giac_sl_lists.fund_cd%TYPE,
      p_sl_type_cd   giac_sl_lists.sl_type_cd%TYPE,
      p_sl_cd        giac_other_collections.sl_cd%TYPE
   )
      RETURN sl_lists_tab PIPELINED
   IS
      v_sl_lists   sl_lists_type;
   BEGIN
      FOR s IN (SELECT   sl_cd, sl_name
                    FROM giac_sl_lists
                   WHERE fund_cd = p_fund_cd
                     AND sl_type_cd = p_sl_type_cd
                     AND sl_cd = NVL (p_sl_cd, sl_cd)
                     AND active_tag = 'Y' --added by John Daniel SR-5056
                ORDER BY sl_name)
      LOOP
         v_sl_lists.sl_cd := s.sl_cd;
         v_sl_lists.sl_name := s.sl_name;
         PIPE ROW (v_sl_lists);
      END LOOP;

      RETURN;
   END get_sl_lists;

   FUNCTION get_transaction_type (
      p_transaction_type   giac_other_collections.transaction_type%TYPE
   )
      RETURN transaction_tab PIPELINED
   IS
      v_trans   transaction_type;
   BEGIN
      FOR tran IN (SELECT   SUBSTR (rv_low_value, 1, 1) rv_low_value,
                            SUBSTR (rv_meaning, 1, 25) rv_meaning
                       FROM cg_ref_codes
                      WHERE rv_domain =
                                    'GIAC_OTHER_COLLECTIONS.TRANSACTION_TYPE'
                        AND SUBSTR (rv_low_value, 1, 1) =
                               NVL (p_transaction_type,
                                    SUBSTR (rv_low_value, 1, 1)
                                   )
                   ORDER BY rv_low_value)
      LOOP
         v_trans.transaction_type := tran.rv_low_value;
         v_trans.tran_type_meaning := tran.rv_meaning;
         PIPE ROW (v_trans);
      END LOOP;

      RETURN;
   END get_transaction_type;

   FUNCTION get_old_tran_no (
      p_tran_year      giac_acctrans.tran_year%TYPE,
      p_tran_month     giac_acctrans.tran_month%TYPE,
      p_tran_seq_no    giac_acctrans.tran_seq_no%TYPE,
      p_gacc_tran_id   giac_other_collections.gacc_tran_id%TYPE
   )
      RETURN old_tran_no_tab PIPELINED
   IS
      v_tran   old_tran_no_type;
   BEGIN
      FOR tran IN (SELECT   gacc1.tran_year, gacc1.tran_month,
                            gacc1.tran_seq_no, gunc1.item_no,
                              -1
                            * (  gunc1.collection_amt
                               + SUM (NVL (gunc2.collection_amt, 0))
                              ) collection_amt,
                              -1
                            * (  gunc1.collection_amt
                               + SUM (NVL (gunc2.collection_amt, 0))
                              ) collection_amt2,
                            gunc1.particulars, gunc1.gacc_tran_id,
                            gunc1.transaction_type, gunc1.gl_acct_category,
                            gunc1.gl_control_acct, gunc1.gl_sub_acct_1,
                            gunc1.gl_sub_acct_2,      --Kenneth L. 10.25.2013
                                                gunc1.gl_sub_acct_3,
                            gunc1.gl_sub_acct_4, gunc1.gl_sub_acct_5,
                            gunc1.gl_sub_acct_6, gunc1.gl_sub_acct_7,
                            gunc1.gl_acct_id
                       FROM giac_other_collections gunc1,
                            giac_acctrans gacc1,
                            (SELECT a.gacc_tran_id, a.gotc_gacc_tran_id,
                                    a.item_no, a.gotc_item_no,
                                    a.collection_amt
                               FROM giac_other_collections a
                              WHERE a.transaction_type = 2
                                AND NOT EXISTS (
                                       SELECT '1'
                                         FROM giac_acctrans gacc2
                                        WHERE gacc2.tran_id = a.gacc_tran_id
                                          AND gacc2.tran_flag = 'D')) gunc2
                      WHERE gunc1.gotc_gacc_tran_id IS NULL
                        AND gacc1.tran_id = gunc1.gacc_tran_id
                        AND gunc1.gacc_tran_id = gunc2.gotc_gacc_tran_id(+)
                        AND gunc1.item_no = gunc2.gotc_item_no(+)
                        AND gacc1.tran_year =
                                            NVL (p_tran_year, gacc1.tran_year)
                        AND gacc1.tran_month =
                                          NVL (p_tran_month, gacc1.tran_month)
                        AND gacc1.tran_seq_no =
                                        NVL (p_tran_seq_no, gacc1.tran_seq_no)
                        AND   gunc1.collection_amt
                            + NVL (gunc2.collection_amt, 0) > 0
                        AND gacc1.tran_flag <> 'D'
                        AND NOT EXISTS (
                               SELECT '1'
                                 FROM giac_reversals grev1,
                                      giac_acctrans gacc2
                                WHERE gacc2.tran_id = grev1.reversing_tran_id
                                  AND grev1.gacc_tran_id = gacc1.tran_id
                                  AND gacc2.tran_flag <> 'D')
                        AND gacc1.tran_id <> p_gacc_tran_id
                     HAVING   gunc1.collection_amt
                            + SUM (NVL (gunc2.collection_amt, 0)) > 0
                   GROUP BY gacc1.tran_year,
                            gacc1.tran_month,
                            gacc1.tran_seq_no,
                            gunc1.item_no,
                            gunc1.collection_amt,
                            gunc1.particulars,
                            gunc1.gacc_tran_id,
                            gunc1.transaction_type,
                            gunc1.gl_acct_category,
                            gunc1.gl_control_acct,
                            gunc1.gl_sub_acct_1,
                            gunc1.gl_sub_acct_2,
                            gunc1.gl_sub_acct_3,
                            gunc1.gl_sub_acct_4,
                            gunc1.gl_sub_acct_5,
                            gunc1.gl_sub_acct_6,
                            gunc1.gl_sub_acct_7,
                            gunc1.gl_acct_id
                   ORDER BY gacc1.tran_year,
                            gacc1.tran_month,
                            gacc1.tran_seq_no,
                            gunc1.item_no)
      LOOP
         v_tran.tran_year := tran.tran_year;
         v_tran.tran_month := tran.tran_month;
         v_tran.tran_seq_no := tran.tran_seq_no;
         v_tran.old_item_no := tran.item_no;
         v_tran.collection_amt := tran.collection_amt;
         v_tran.collection_amt2 := tran.collection_amt2;
         v_tran.gacc_tran_id := tran.gacc_tran_id;
         v_tran.particulars := tran.particulars;
         v_tran.transaction_type := tran.transaction_type;
         v_tran.gl_acct_category := tran.gl_acct_category;
         --Kenneth L. 10.25.2013
         v_tran.gl_control_acct := tran.gl_control_acct;
         v_tran.gl_sub_acct_1 := tran.gl_sub_acct_1;
         v_tran.gl_sub_acct_2 := tran.gl_sub_acct_2;
         v_tran.gl_sub_acct_3 := tran.gl_sub_acct_3;
         v_tran.gl_sub_acct_4 := tran.gl_sub_acct_4;
         v_tran.gl_sub_acct_5 := tran.gl_sub_acct_5;
         v_tran.gl_sub_acct_6 := tran.gl_sub_acct_6;
         v_tran.gl_sub_acct_7 := tran.gl_sub_acct_7;
         v_tran.gl_acct_id := tran.gl_acct_id;

         BEGIN
            SELECT DISTINCT gl_acct_name
                       INTO v_tran.dsp_account_name
                       FROM giac_chart_of_accts
                      WHERE gl_acct_id = tran.gl_acct_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_tran.dsp_account_name := NULL;
            WHEN OTHERS
            THEN
               v_tran.dsp_account_name := NULL;
         END;

         PIPE ROW (v_tran);
      END LOOP;

      RETURN;
   END get_old_tran_no;

   PROCEDURE set_other_collns_dtls (
      p_other_collns   giac_other_collections%ROWTYPE
   )
   IS
   BEGIN
      INSERT INTO giac_other_collections
                  (gacc_tran_id, item_no,
                   transaction_type,
                   collection_amt, gl_acct_id,
                   gl_acct_category,
                   gl_control_acct,
                   gl_sub_acct_1,
                   gl_sub_acct_2,
                   gl_sub_acct_3,
                   gl_sub_acct_4,
                   gl_sub_acct_5,
                   gl_sub_acct_6,
                   gl_sub_acct_7,
                   gotc_gacc_tran_id,
                   gotc_item_no, or_print_tag,
                   sl_cd, particulars,
                   user_id, last_update
                  )
           VALUES (p_other_collns.gacc_tran_id, p_other_collns.item_no,
                   p_other_collns.transaction_type,
                   p_other_collns.collection_amt, p_other_collns.gl_acct_id,
                   p_other_collns.gl_acct_category,
                   p_other_collns.gl_control_acct,
                   p_other_collns.gl_sub_acct_1,
                   p_other_collns.gl_sub_acct_2,
                   p_other_collns.gl_sub_acct_3,
                   p_other_collns.gl_sub_acct_4,
                   p_other_collns.gl_sub_acct_5,
                   p_other_collns.gl_sub_acct_6,
                   p_other_collns.gl_sub_acct_7,
                   p_other_collns.gotc_gacc_tran_id,
                   p_other_collns.gotc_item_no, p_other_collns.or_print_tag,
                   p_other_collns.sl_cd, p_other_collns.particulars,
                   p_other_collns.user_id, SYSDATE
                  );
   END set_other_collns_dtls;

   PROCEDURE update_op_text_giacs015 (
      p_gacc_tran_id    giac_other_collections.gacc_tran_id%TYPE,
      p_item_gen_type   giac_modules.generation_type%TYPE
   )
   IS
      CURSOR c
      IS
         SELECT DISTINCT b.gacc_tran_id, b.user_id, b.last_update, b.item_no,
                         b.collection_amt item_amt,
                         (   DECODE (b.transaction_type,
                                     1, 'Collection ',
                                     2, 'Refund '
                                    )
                          || ' / '
                          || LTRIM (TO_CHAR (b.gl_acct_category, '9'))
                          || '-'
                          || LTRIM (TO_CHAR (b.gl_control_acct, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (b.gl_sub_acct_1, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (b.gl_sub_acct_2, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (b.gl_sub_acct_3, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (b.gl_sub_acct_4, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (b.gl_sub_acct_5, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (b.gl_sub_acct_6, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (b.gl_sub_acct_7, '09'))
                          || ' '
                          || c.gl_acct_sname
                         ) item_text
                    FROM giac_acctrans a,
                         giac_other_collections b,
                         giac_chart_of_accts c
                   WHERE a.tran_id = b.gacc_tran_id
                     AND b.gl_acct_category = c.gl_acct_category
                     AND b.gl_sub_acct_1 = c.gl_sub_acct_1
                     AND b.gl_sub_acct_2 = c.gl_sub_acct_2
                     AND b.gl_sub_acct_3 = c.gl_sub_acct_3
                     AND b.gl_sub_acct_4 = c.gl_sub_acct_4
                     AND b.gl_sub_acct_5 = c.gl_sub_acct_5
                     AND b.gl_sub_acct_6 = c.gl_sub_acct_6
                     AND b.gl_sub_acct_7 = c.gl_sub_acct_7
                     AND b.gl_control_acct = c.gl_control_acct
                     AND b.gacc_tran_id = p_gacc_tran_id
                     AND a.tran_flag <> 'D'
                     AND NOT EXISTS (
                            SELECT '1'
                              FROM giac_acctrans d, giac_reversals e
                             WHERE d.tran_id = e.reversing_tran_id
                               AND e.gacc_tran_id = a.tran_id
                               AND d.tran_flag <> 'D')
                ORDER BY b.item_no;

      ws_seq_no     giac_op_text.item_seq_no%TYPE   := 1;
      ws_gen_type   VARCHAR2 (1);
      curr_cd       NUMBER (2);
   BEGIN
      DELETE FROM giac_op_text
            WHERE gacc_tran_id = p_gacc_tran_id
              AND item_gen_type = p_item_gen_type;

      SELECT param_value_n
        INTO curr_cd
        FROM giac_parameters
       WHERE param_name = 'CURRENCY_CD';

      FOR c_rec IN c
      LOOP
         INSERT INTO giac_op_text
                     (gacc_tran_id, item_seq_no, print_seq_no,
                      item_amt, item_gen_type, item_text,
                      user_id, last_update, currency_cd,
                      foreign_curr_amt
                     )
              VALUES (c_rec.gacc_tran_id, ws_seq_no, ws_seq_no,
                      c_rec.item_amt, p_item_gen_type, c_rec.item_text,
                      c_rec.user_id, c_rec.last_update, curr_cd,
                      c_rec.item_amt
                     );

         ws_seq_no := ws_seq_no + 1;
      END LOOP;
   END;

   PROCEDURE post_forms_commit_giacs015 (
      p_gacc_tran_id   giac_other_collections.gacc_tran_id%TYPE,
      p_fund_cd        giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_branch_cd      giac_order_of_payts.gibr_branch_cd%TYPE,
      p_user           VARCHAR2,
      p_mod_name       giac_modules.module_name%TYPE,
      p_or_flag        giac_order_of_payts.or_flag%TYPE,
      p_tran_source    VARCHAR2
   )
   IS
      CURSOR c
      IS
         SELECT   gacc_tran_id, gl_acct_id, gl_acct_category,
                  gl_control_acct, gl_sub_acct_1, gl_sub_acct_2,
                  gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6,
                  gl_sub_acct_7, sl_cd, SUM (collection_amt) amt
             FROM giac_other_collections
            WHERE gacc_tran_id = p_gacc_tran_id
         GROUP BY gacc_tran_id,
                  gl_acct_id,
                  gl_acct_category,
                  gl_control_acct,
                  gl_sub_acct_1,
                  gl_sub_acct_2,
                  gl_sub_acct_3,
                  gl_sub_acct_4,
                  gl_sub_acct_5,
                  gl_sub_acct_6,
                  gl_sub_acct_7,
                  sl_cd;

      ws_gen_type   giac_modules.generation_type%TYPE;
      amt_1         giac_other_collections.collection_amt%TYPE;
      amt_2         giac_other_collections.collection_amt%TYPE;
      v_sl_type     giac_chart_of_accts.gslt_sl_type_cd%TYPE;
   BEGIN
      BEGIN
         SELECT generation_type
           INTO ws_gen_type
           FROM giac_modules
          WHERE module_name = p_mod_name;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      IF p_tran_source IN ('OP', 'OR')
      THEN
         IF p_or_flag = 'P'
         THEN
            NULL;
         ELSE
            giacs015_pkg.update_op_text_giacs015 (p_gacc_tran_id,
                                                  ws_gen_type);
         END IF;
      END IF;

      DELETE FROM giac_acct_entries
            WHERE gacc_tran_id = p_gacc_tran_id
              AND generation_type = ws_gen_type;

      FOR c_rec IN c
      LOOP
         BEGIN
            SELECT gslt_sl_type_cd
              INTO v_sl_type
              FROM giac_chart_of_accts
             WHERE gl_acct_id = c_rec.gl_acct_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_sl_type := NULL;
         END;

         IF c_rec.amt > 0
         THEN
            amt_1 := 0;
            amt_2 := c_rec.amt;
         ELSE
            amt_2 := 0;
            amt_1 := -1 * c_rec.amt;
         END IF;

         INSERT INTO giac_acct_entries
                     (gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd,
                      gl_acct_id, gl_acct_category,
                      gl_control_acct, gl_sub_acct_1,
                      gl_sub_acct_2, gl_sub_acct_3,
                      gl_sub_acct_4, gl_sub_acct_5,
                      gl_sub_acct_6, gl_sub_acct_7, sl_cd,
                      debit_amt, credit_amt, generation_type, user_id,
                      last_update, sl_type_cd, sl_source_cd
                     )
              VALUES (c_rec.gacc_tran_id, p_fund_cd, p_branch_cd,
                      c_rec.gl_acct_id, c_rec.gl_acct_category,
                      c_rec.gl_control_acct, c_rec.gl_sub_acct_1,
                      c_rec.gl_sub_acct_2, c_rec.gl_sub_acct_3,
                      c_rec.gl_sub_acct_4, c_rec.gl_sub_acct_5,
                      c_rec.gl_sub_acct_6, c_rec.gl_sub_acct_7, c_rec.sl_cd,
                      amt_1, amt_2, ws_gen_type, p_user,
                      SYSDATE, v_sl_type, 1
                     );
      END LOOP;
   END post_forms_commit_giacs015;

   FUNCTION validate_old_tran_no_giacs015 (
      p_gacc_tran_id   giac_other_collections.gacc_tran_id%TYPE,
      p_tran_year      giac_acctrans.tran_year%TYPE,
      p_tran_month     giac_acctrans.tran_month%TYPE,
      p_tran_seq_no    giac_acctrans.tran_seq_no%TYPE
   )
      RETURN VARCHAR2
   IS
      validoldtran   VARCHAR2 (1) := NULL;
   BEGIN
      SELECT DISTINCT 'Y'
                 INTO validoldtran
                 FROM giac_acctrans a, giac_other_collections b
                WHERE a.tran_id = b.gacc_tran_id
                  AND a.gfun_fund_cd = 'CPI'
                  AND a.tran_year = p_tran_year
                  AND a.tran_month = p_tran_month
                  AND a.tran_seq_no = p_tran_seq_no
                  AND a.tran_flag <> 'D'
                  AND NOT EXISTS (
                         SELECT '1'
                           FROM giac_acctrans c, giac_reversals d
                          WHERE c.tran_id = d.reversing_tran_id
                            AND d.gacc_tran_id = a.tran_id
                            AND c.tran_flag != 'D')
                  AND a.tran_id <> p_gacc_tran_id
                  AND b.gotc_gacc_tran_id IS NULL
                  AND b.transaction_type = '1';

      RETURN validoldtran;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 'N';
   END validate_old_tran_no_giacs015;

   FUNCTION validate_old_item_no_giacs015 (
      p_gacc_tran_id   giac_other_collections.gacc_tran_id%TYPE,
      p_item_no        giac_other_collections.item_no%TYPE
   )
      RETURN VARCHAR2
   IS
      validolditemno   VARCHAR2 (1) := NULL;
   BEGIN
      SELECT 'Y'
        INTO validolditemno
        FROM giac_other_collections gunc1, giac_acctrans gacc
       WHERE (   gunc1.gacc_tran_id = p_gacc_tran_id
              OR (gunc1.gacc_tran_id IS NULL AND p_gacc_tran_id IS NULL)
             )
         AND (   gunc1.item_no = p_item_no
              OR (gunc1.item_no IS NULL AND p_item_no IS NULL)
             )
         AND gotc_gacc_tran_id IS NULL
         AND gacc.tran_id = gunc1.gacc_tran_id;

      RETURN validolditemno;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 'N';
   END validate_old_item_no_giacs015;

   PROCEDURE delete_other_collns_dtls (
      p_gacc_tran_id   giac_other_collections.gacc_tran_id%TYPE,
      p_item_no        giac_other_collections.item_no%TYPE
   )
   IS
   BEGIN
      BEGIN
         DELETE FROM giac_other_collections
               WHERE gacc_tran_id = p_gacc_tran_id
                 AND item_no = p_item_no;
      END;
   END delete_other_collns_dtls;

   FUNCTION validate_delete_giacs015 (
      p_gacc_tran_id   giac_other_collections.gacc_tran_id%TYPE,
      p_item_no        giac_other_collections.item_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_valid   VARCHAR2 (1) := 'N';
   BEGIN
      SELECT 'Y'
        INTO v_valid
        FROM giac_other_collections gunc
       WHERE (   gunc.gotc_gacc_tran_id = p_gacc_tran_id
              OR (gunc.gotc_gacc_tran_id IS NULL AND p_gacc_tran_id IS NULL)
             )
         AND (   gunc.gotc_item_no = p_item_no
              OR (gunc.gotc_item_no IS NULL AND p_item_no IS NULL)
             );

      RETURN v_valid;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN v_valid;
   END validate_delete_giacs015;
END GIACS015_PKG;
/


