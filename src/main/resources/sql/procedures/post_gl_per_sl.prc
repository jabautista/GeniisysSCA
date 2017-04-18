CREATE OR REPLACE PROCEDURE CPI.Post_Gl_Per_Sl (
   p_tran_mm     GIAC_ACCTRANS.tran_month%TYPE,
   p_tran_year   GIAC_ACCTRANS.tran_year%TYPE)
AS
/* Modified by: Mikel10.16.2015
** Modifications: Removed tran_month and tran_year in all queries to avoid multiple records per GL. AFPGEN SR 20631  
*/
   TYPE v_gl_acct_id_tab IS TABLE OF GIAC_TB_SL_EXT.gl_acct_id%TYPE;

   TYPE v_gl_acct_category_tab IS TABLE OF GIAC_TB_SL_EXT.gl_acct_category%TYPE;

   TYPE v_gl_control_acct_tab IS TABLE OF GIAC_TB_SL_EXT.gl_control_acct%TYPE;

   TYPE v_gl_sub_acct_1_tab IS TABLE OF GIAC_TB_SL_EXT.gl_sub_acct_1%TYPE;

   TYPE v_gl_sub_acct_2_tab IS TABLE OF GIAC_TB_SL_EXT.gl_sub_acct_2%TYPE;

   TYPE v_gl_sub_acct_3_tab IS TABLE OF GIAC_TB_SL_EXT.gl_sub_acct_3%TYPE;

   TYPE v_gl_sub_acct_4_tab IS TABLE OF GIAC_TB_SL_EXT.gl_sub_acct_4%TYPE;

   TYPE v_gl_sub_acct_5_tab IS TABLE OF GIAC_TB_SL_EXT.gl_sub_acct_5%TYPE;

   TYPE v_gl_sub_acct_6_tab IS TABLE OF GIAC_TB_SL_EXT.gl_sub_acct_6%TYPE;

   TYPE v_gl_sub_acct_7_tab IS TABLE OF GIAC_TB_SL_EXT.gl_sub_acct_7%TYPE;

   TYPE v_gl_acct_name_tab IS TABLE OF GIAC_TB_SL_EXT.gl_acct_name%TYPE;

   TYPE v_gl_acct_sname_tab IS TABLE OF GIAC_TB_SL_EXT.gl_acct_sname%TYPE;

   TYPE v_sl_type_cd_tab IS TABLE OF GIAC_TB_SL_EXT.sl_type_cd%TYPE;

   TYPE v_sl_cd_tab IS TABLE OF GIAC_TB_SL_EXT.sl_cd%TYPE;

   TYPE v_sl_name_tab IS TABLE OF GIAC_TB_SL_EXT.sl_name%TYPE;

   TYPE v_tran_month_tab IS TABLE OF GIAC_TB_SL_EXT.tran_mm%TYPE;

   TYPE v_tran_year_tab IS TABLE OF GIAC_TB_SL_EXT.tran_year%TYPE;

   TYPE v_debit_amt_tab IS TABLE OF GIAC_TB_SL_EXT.month_debit%TYPE;

   TYPE v_credit_amt_tab IS TABLE OF GIAC_TB_SL_EXT.month_credit%TYPE;

   v_gl_acct_id                  v_gl_acct_id_tab;
   v_gl_acct_category            v_gl_acct_category_tab;
   v_gl_control_acct             v_gl_control_acct_tab;
   v_gl_sub_acct_1               v_gl_sub_acct_1_tab;
   v_gl_sub_acct_2               v_gl_sub_acct_2_tab;
   v_gl_sub_acct_3               v_gl_sub_acct_3_tab;
   v_gl_sub_acct_4               v_gl_sub_acct_4_tab;
   v_gl_sub_acct_5               v_gl_sub_acct_5_tab;
   v_gl_sub_acct_6               v_gl_sub_acct_6_tab;
   v_gl_sub_acct_7               v_gl_sub_acct_7_tab;
   v_gl_acct_name                v_gl_acct_name_tab;
   v_gl_acct_sname               v_gl_acct_sname_tab;
   v_sl_type_cd                  v_sl_type_cd_tab;
   v_sl_cd                       v_sl_cd_tab;
   v_sl_name                     v_sl_name_tab;
   v_tran_month                  v_tran_month_tab;
   v_tran_year                   v_tran_year_tab;
   v_debit_amt                   v_debit_amt_tab;
   v_credit_amt                  v_credit_amt_tab;
   v_dummy                       GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE;
/*
used in checking transactions for the month
for error checking when output is not equal to giac_monthly_totals
--selects the problem gl_acct
SELECT x.gl_acct_id, x.dr, x.cr, y.dr, y.cr
  FROM (SELECT   gl_acct_id, SUM (month_debit) dr, SUM (month_credit) cr
            FROM giac_tb_sl_ext
           WHERE tran_mm = 3 AND tran_year = 2001
        GROUP BY gl_acct_id) x,
       (SELECT   a.gl_acct_id, SUM (a.total_debit_amt) dr,
                 SUM (a.total_credit_amt) cr
            FROM giac_monthly_totals a
           WHERE a.tran_mm = 3 AND a.tran_year = 2001
        GROUP BY gl_acct_id) y
 WHERE x.gl_acct_id = y.gl_acct_id AND (   x.dr <> y.dr
                                        OR x.cr <> y.cr)
--given the problem gl_acct, check by sl_cd
SELECT x.sl_cd, x.dr, x.cr, y.dr, y.cr
  FROM (SELECT sl_cd, month_debit dr, month_credit cr
          FROM giac_tb_sl_ext a
         WHERE gl_acct_id = 621) x,
       (SELECT   b.sl_cd, SUM (b.debit_amt) dr, SUM (b.credit_amt) cr
            FROM giac_acctrans a, giac_acct_entries b
           WHERE TO_NUMBER (TO_CHAR (a.posting_date, 'YYYY')) * 100
                 + TO_NUMBER (TO_CHAR (a.posting_date, 'MM')) = 200101
             AND a.tran_id = b.gacc_tran_id
             AND gl_acct_id = 621
        GROUP BY sl_cd) y
 WHERE NVL (x.sl_cd, 1) = NVL (y.sl_cd, 1)
   AND (   x.dr <> y.dr
        OR x.cr <> y.cr)


--entries in acc_entries
SELECT *
  FROM giac_acct_entries a, giac_acctrans b
 WHERE gl_acct_id = 1458
   AND a.gacc_tran_id = b.tran_id
   AND TO_NUMBER (TO_CHAR (b.posting_date, 'YYYY')) * 100
       + TO_NUMBER (TO_CHAR (b.posting_date, 'MM')) = 200101

--to check ending balance
SELECT x.gl_acct_id, x.cr, y.cr
  FROM (SELECT   a.gl_acct_id, SUM (a.end_debit_amt) - SUM (a.end_credit_amt) cr
            FROM giac_finance_yr a
           WHERE a.tran_mm = 11 AND a.tran_year = 2000
        GROUP BY gl_acct_id) x,
       (SELECT   b.gl_acct_id, SUM (b.end_debit) - SUM (b.end_credit) cr
            FROM giac_tb_sl_ext b
           WHERE tran_mm = 11 AND tran_year = 2000
        GROUP BY gl_acct_id) y
 WHERE x.gl_acct_id = y.gl_acct_id AND (x.cr <> y.cr)
*/

BEGIN

--for GL accts with sl but sl source cd <> 2
--GL accts with sl source cd = 2 selects from giis_payees instead of giac_sl_lists

   DELETE FROM GIAC_TB_SL_EXT
         WHERE tran_mm = p_tran_mm AND tran_year = p_tran_year;

   COMMIT;

   SELECT   c.gl_acct_id, c.gl_acct_category, c.gl_control_acct,
            c.gl_sub_acct_1, c.gl_sub_acct_2, c.gl_sub_acct_3,
            c.gl_sub_acct_4, c.gl_sub_acct_5, c.gl_sub_acct_6,
            c.gl_sub_acct_7, a.gl_acct_name, a.gl_acct_sname,
            NVL (c.sl_type_cd, a.gslt_sl_type_cd), c.sl_cd, d.sl_name,
            /*b.tran_month, b.tran_year,*/ SUM (NVL (c.debit_amt, 0)),
            SUM (NVL (c.credit_amt, 0))
       BULK COLLECT INTO v_gl_acct_id, v_gl_acct_category, v_gl_control_acct,
                         v_gl_sub_acct_1, v_gl_sub_acct_2, v_gl_sub_acct_3,
                         v_gl_sub_acct_4, v_gl_sub_acct_5, v_gl_sub_acct_6,
                         v_gl_sub_acct_7, v_gl_acct_name, v_gl_acct_sname,
                         v_sl_type_cd, v_sl_cd, v_sl_name,
                         /*v_tran_month, v_tran_year,*/ v_debit_amt,
                         v_credit_amt
       FROM GIAC_ACCTRANS b,
            GIAC_ACCT_ENTRIES c,
            GIAC_CHART_OF_ACCTS a,
            GIAC_SL_LISTS d
      WHERE a.gl_acct_id = c.gl_acct_id
        AND tran_id >= 0
        AND b.tran_id = c.gacc_tran_id
        AND c.sl_cd IS NOT NULL
        AND TO_NUMBER (TO_CHAR (b.posting_date, 'YYYYMM')) =
                              p_tran_year * 100 + p_tran_mm
        AND NVL (c.sl_type_cd, a.gslt_sl_type_cd) = d.sl_type_cd
        AND c.sl_cd = d.sl_cd
        AND NVL (c.sl_source_cd, 1) <> 2
	AND B.TRAN_FLAG = 'P'
   GROUP BY c.gl_acct_id,
            c.gl_acct_category,
            c.gl_control_acct,
            c.gl_sub_acct_1,
            c.gl_sub_acct_2,
            c.gl_sub_acct_3,
            c.gl_sub_acct_4,
            c.gl_sub_acct_5,
            c.gl_sub_acct_6,
            c.gl_sub_acct_7,
            a.gl_acct_name,
            a.gl_acct_sname,
            NVL (c.sl_type_cd, a.gslt_sl_type_cd),
            c.sl_cd,
            d.sl_name/*,
            b.tran_month,
            b.tran_year*/;

   IF SQL%FOUND THEN
      FORALL cnt IN v_gl_acct_id.FIRST .. v_gl_acct_id.LAST
         INSERT INTO GIAC_TB_SL_EXT
                     (gl_acct_id,
                      gl_acct_name,
                      gl_acct_sname,
                      gl_acct_category,
                      gl_control_acct,
                      gl_sub_acct_1,
                      gl_sub_acct_2,
                      gl_sub_acct_3,
                      gl_sub_acct_4,
                      gl_sub_acct_5,
                      gl_sub_acct_6,
                      gl_sub_acct_7,
                      sl_cd,
                      sl_type_cd,
                      sl_name,
                      beg_debit,
                      beg_credit,
                      month_debit,
                      month_credit,
                      end_debit,
                      end_credit,
                      tran_mm,
                      tran_year)
              VALUES (v_gl_acct_id (cnt),
                      v_gl_acct_name (cnt),
                      v_gl_acct_sname (cnt),
                      v_gl_acct_category (cnt),
                      v_gl_control_acct (cnt),
                      v_gl_sub_acct_1 (cnt),
                      v_gl_sub_acct_2 (cnt),
                      v_gl_sub_acct_3 (cnt),
                      v_gl_sub_acct_4 (cnt),
                      v_gl_sub_acct_5 (cnt),
                      v_gl_sub_acct_6 (cnt),
                      v_gl_sub_acct_7 (cnt),
                      v_sl_cd (cnt),
                      v_sl_type_cd (cnt),
                      v_sl_name (cnt),
                      0, --V_BEG_DEBIT,
                      0, --V_BEG_CREDIT,
                      v_debit_amt (cnt),
                      v_credit_amt (cnt),
                      v_debit_amt (cnt), --V_BEG_DEBIT + V_MONTH_DEBIT,     --these figures are updated
                      v_credit_amt (cnt), --V_BEG_CREDIT + V_MONTH_CREDIT,  --in the for loop below
                      p_tran_mm,
                      p_tran_year);
   END IF; --IF SQL%FOUND THEN

   IF SQL%FOUND THEN
      v_gl_acct_id.DELETE;
      v_gl_acct_name.DELETE;
      v_gl_acct_sname.DELETE;
      v_gl_acct_category.DELETE;
      v_gl_control_acct.DELETE;
      v_gl_sub_acct_1.DELETE;
      v_gl_sub_acct_2.DELETE;
      v_gl_sub_acct_3.DELETE;
      v_gl_sub_acct_4.DELETE;
      v_gl_sub_acct_5.DELETE;
      v_gl_sub_acct_6.DELETE;
      v_gl_sub_acct_7.DELETE;
      v_sl_cd.DELETE;
      v_sl_type_cd.DELETE;
      v_sl_name.DELETE;
      v_debit_amt.DELETE;
      v_credit_amt.DELETE;
   END IF; --IF SQL%FOUND THEN


--for GL accts with no sl
   SELECT   c.gl_acct_id, c.gl_acct_category, c.gl_control_acct,
            c.gl_sub_acct_1, c.gl_sub_acct_2, c.gl_sub_acct_3,
            c.gl_sub_acct_4, c.gl_sub_acct_5, c.gl_sub_acct_6,
            c.gl_sub_acct_7, a.gl_acct_name, a.gl_acct_sname, NULL,
            NULL, NULL, --b.tran_month, b.tran_year,
            SUM (NVL (c.debit_amt, 0)), SUM (NVL (c.credit_amt, 0))
       BULK COLLECT INTO v_gl_acct_id, v_gl_acct_category, v_gl_control_acct,
                         v_gl_sub_acct_1, v_gl_sub_acct_2, v_gl_sub_acct_3,
                         v_gl_sub_acct_4, v_gl_sub_acct_5, v_gl_sub_acct_6,
                         v_gl_sub_acct_7, v_gl_acct_name, v_gl_acct_sname, v_sl_type_cd,
                         v_sl_cd, v_sl_name, /*v_tran_month, v_tran_year,*/
                         v_debit_amt, v_credit_amt
       FROM GIAC_ACCTRANS b, GIAC_ACCT_ENTRIES c, GIAC_CHART_OF_ACCTS a
      WHERE a.gl_acct_id = c.gl_acct_id
        AND tran_id >= 0
        AND b.tran_id = c.gacc_tran_id
        AND c.sl_cd IS NULL
        AND TO_NUMBER (TO_CHAR (b.posting_date, 'YYYYMM')) =
                               p_tran_year * 100 + p_tran_mm
        AND NVL (c.sl_source_cd, 1) <> 2
        AND B.TRAN_FLAG = 'P'
   GROUP BY c.gl_acct_id,
            c.gl_acct_category,
            c.gl_control_acct,
            c.gl_sub_acct_1,
            c.gl_sub_acct_2,
            c.gl_sub_acct_3,
            c.gl_sub_acct_4,
            c.gl_sub_acct_5,
            c.gl_sub_acct_6,
            c.gl_sub_acct_7,
            a.gl_acct_name,
            a.gl_acct_sname,
            NULL,
            NULL,
            NULL/*,
            b.tran_month,
            b.tran_year*/;

   IF SQL%FOUND THEN
      FORALL cnt IN v_gl_acct_id.FIRST .. v_gl_acct_id.LAST
         INSERT INTO GIAC_TB_SL_EXT
                     (gl_acct_id,
                      gl_acct_name,
                      gl_acct_sname,
                      gl_acct_category,
                      gl_control_acct,
                      gl_sub_acct_1,
                      gl_sub_acct_2,
                      gl_sub_acct_3,
                      gl_sub_acct_4,
                      gl_sub_acct_5,
                      gl_sub_acct_6,
                      gl_sub_acct_7,
                      sl_cd,
                      sl_type_cd,
                      sl_name,
                      beg_debit,
                      beg_credit,
                      month_debit,
                      month_credit,
                      end_debit,
                      end_credit,
                      tran_mm,
                      tran_year)
              VALUES (v_gl_acct_id (cnt),
                      v_gl_acct_name (cnt),
                      v_gl_acct_sname (cnt),
                      v_gl_acct_category (cnt),
                      v_gl_control_acct (cnt),
                      v_gl_sub_acct_1 (cnt),
                      v_gl_sub_acct_2 (cnt),
                      v_gl_sub_acct_3 (cnt),
                      v_gl_sub_acct_4 (cnt),
                      v_gl_sub_acct_5 (cnt),
                      v_gl_sub_acct_6 (cnt),
                      v_gl_sub_acct_7 (cnt),
                      v_sl_cd (cnt),
                      v_sl_type_cd (cnt),
                      v_sl_name (cnt),
                      0, --V_BEG_DEBIT,
                      0, --V_BEG_CREDIT,
                      v_debit_amt (cnt),
                      v_credit_amt (cnt),
                      v_debit_amt (cnt), --V_BEG_DEBIT + V_MONTH_DEBIT,     --these figures are updated
                      v_credit_amt (cnt), --V_BEG_CREDIT + V_MONTH_CREDIT,  --in the for loop below
                      p_tran_mm,
                      p_tran_year);
   END IF; --IF SQL%FOUND THEN

   IF SQL%FOUND THEN
      v_gl_acct_id.DELETE;
      v_gl_acct_name.DELETE;
      v_gl_acct_sname.DELETE;
      v_gl_acct_category.DELETE;
      v_gl_control_acct.DELETE;
      v_gl_sub_acct_1.DELETE;
      v_gl_sub_acct_2.DELETE;
      v_gl_sub_acct_3.DELETE;
      v_gl_sub_acct_4.DELETE;
      v_gl_sub_acct_5.DELETE;
      v_gl_sub_acct_6.DELETE;
      v_gl_sub_acct_7.DELETE;
      v_sl_cd.DELETE;
      v_sl_type_cd.DELETE;
      v_sl_name.DELETE;
      v_debit_amt.DELETE;
      v_credit_amt.DELETE;
   END IF; --IF SQL%FOUND THEN


--for GL accts with sl and sl source cd = 2
--GL accts with sl source cd = 2 selects from giis_payees instead of giac_sl_lists

   SELECT   c.gl_acct_id, c.gl_acct_category, c.gl_control_acct,
            c.gl_sub_acct_1, c.gl_sub_acct_2, c.gl_sub_acct_3,
            c.gl_sub_acct_4, c.gl_sub_acct_5, c.gl_sub_acct_6,
            c.gl_sub_acct_7, a.gl_acct_name, a.gl_acct_sname, c.sl_type_cd,
            c.sl_cd,
            d.payee_first_name || ' ' || d.payee_middle_name || ' '
            || d.payee_last_name,
            /*b.tran_month, b.tran_year,*/ SUM (NVL (c.debit_amt, 0)),
            SUM (NVL (c.credit_amt, 0))
       BULK COLLECT INTO v_gl_acct_id, v_gl_acct_category, v_gl_control_acct,
                         v_gl_sub_acct_1, v_gl_sub_acct_2, v_gl_sub_acct_3,
                         v_gl_sub_acct_4, v_gl_sub_acct_5, v_gl_sub_acct_6,
                         v_gl_sub_acct_7, v_gl_acct_name, v_gl_acct_sname, v_sl_type_cd,
                         v_sl_cd,
                         v_sl_name,
                         /*v_tran_month, v_tran_year,*/ v_debit_amt,
                         v_credit_amt
       FROM GIAC_ACCTRANS b,
            GIAC_ACCT_ENTRIES c,
            GIAC_CHART_OF_ACCTS a,
            GIIS_PAYEES d
      WHERE a.gl_acct_id = c.gl_acct_id
        AND tran_id >= 0
        AND b.tran_id = c.gacc_tran_id
        AND c.sl_source_cd = 2
        AND c.sl_type_cd = d.payee_class_cd
        AND c.sl_cd = d.payee_no
        AND TO_NUMBER (TO_CHAR (b.posting_date, 'YYYYMM')) =
                               p_tran_year * 100 + p_tran_mm
        AND B.TRAN_FLAG = 'P'
   GROUP BY c.gl_acct_id,
            c.gl_acct_category,
            c.gl_control_acct,
            c.gl_sub_acct_1,
            c.gl_sub_acct_2,
            c.gl_sub_acct_3,
            c.gl_sub_acct_4,
            c.gl_sub_acct_5,
            c.gl_sub_acct_6,
            c.gl_sub_acct_7,
            a.gl_acct_name,
            a.gl_acct_sname,
            c.sl_type_cd,
            c.sl_cd,
            d.payee_first_name || ' ' || d.payee_middle_name || ' '
            || d.payee_last_name/*,
            b.tran_month,
            b.tran_year*/;

   IF SQL%FOUND THEN
      FORALL cnt IN v_gl_acct_id.FIRST .. v_gl_acct_id.LAST
         INSERT INTO GIAC_TB_SL_EXT
                     (gl_acct_id,
                      gl_acct_name,
                      gl_acct_sname,
                      gl_acct_category,
                      gl_control_acct,
                      gl_sub_acct_1,
                      gl_sub_acct_2,
                      gl_sub_acct_3,
                      gl_sub_acct_4,
                      gl_sub_acct_5,
                      gl_sub_acct_6,
                      gl_sub_acct_7,
                      sl_cd,
                      sl_type_cd,
                      sl_name,
                      beg_debit,
                      beg_credit,
                      month_debit,
                      month_credit,
                      end_debit,
                      end_credit,
                      tran_mm,
                      tran_year)
              VALUES (v_gl_acct_id (cnt),
                      v_gl_acct_name (cnt),
                      v_gl_acct_sname (cnt),
                      v_gl_acct_category (cnt),
                      v_gl_control_acct (cnt),
                      v_gl_sub_acct_1 (cnt),
                      v_gl_sub_acct_2 (cnt),
                      v_gl_sub_acct_3 (cnt),
                      v_gl_sub_acct_4 (cnt),
                      v_gl_sub_acct_5 (cnt),
                      v_gl_sub_acct_6 (cnt),
                      v_gl_sub_acct_7 (cnt),
                      v_sl_cd (cnt),
                      v_sl_type_cd (cnt),
                      v_sl_name (cnt),
                      0, --V_BEG_DEBIT,
                      0, --V_BEG_CREDIT,
                      v_debit_amt (cnt),
                      v_credit_amt (cnt),
                      v_debit_amt (cnt), --V_BEG_DEBIT + V_MONTH_DEBIT,     --these figures are updated
                      v_credit_amt (cnt), --V_BEG_CREDIT + V_MONTH_CREDIT,  --in the for loop below
                      p_tran_mm,
                      p_tran_year);
   END IF; --IF SQL%FOUND THEN

   IF SQL%FOUND THEN
      v_gl_acct_id.DELETE;
      v_gl_acct_name.DELETE;
      v_gl_acct_sname.DELETE;
      v_gl_acct_category.DELETE;
      v_gl_control_acct.DELETE;
      v_gl_sub_acct_1.DELETE;
      v_gl_sub_acct_2.DELETE;
      v_gl_sub_acct_3.DELETE;
      v_gl_sub_acct_4.DELETE;
      v_gl_sub_acct_5.DELETE;
      v_gl_sub_acct_6.DELETE;
      v_gl_sub_acct_7.DELETE;
      v_sl_cd.DELETE;
      v_sl_type_cd.DELETE;
      v_sl_name.DELETE;
      v_debit_amt.DELETE;
      v_credit_amt.DELETE;
   END IF; --IF SQL%FOUND THEN


-- with sl_cd but not found in giac_sl_lists
   SELECT   c.gl_acct_id, c.gl_acct_category, c.gl_control_acct,
            c.gl_sub_acct_1, c.gl_sub_acct_2, c.gl_sub_acct_3,
            c.gl_sub_acct_4, c.gl_sub_acct_5, c.gl_sub_acct_6,
            c.gl_sub_acct_7, a.gl_acct_name, a.gl_acct_sname, c.sl_type_cd,
            c.sl_cd, NULL, --b.tran_month, b.tran_year,
            SUM (NVL (c.debit_amt, 0)), SUM (NVL (c.credit_amt, 0))
       BULK COLLECT INTO v_gl_acct_id, v_gl_acct_category, v_gl_control_acct,
                         v_gl_sub_acct_1, v_gl_sub_acct_2, v_gl_sub_acct_3,
                         v_gl_sub_acct_4, v_gl_sub_acct_5, v_gl_sub_acct_6,
                         v_gl_sub_acct_7, v_gl_acct_name, v_gl_acct_sname, v_sl_type_cd,
                         v_sl_cd, v_sl_name, /*v_tran_month, v_tran_year,*/
                         v_debit_amt, v_credit_amt
       FROM GIAC_ACCTRANS b, GIAC_ACCT_ENTRIES c, GIAC_CHART_OF_ACCTS a
      WHERE a.gl_acct_id = c.gl_acct_id
        AND tran_id >= 0
        AND b.tran_id = c.gacc_tran_id
        AND c.sl_cd IS NOT NULL
        AND c.sl_type_cd IS NOT NULL
        AND c.sl_source_cd <> 2
        AND TO_NUMBER (TO_CHAR (b.posting_date, 'YYYYMM')) =
                               p_tran_year * 100 + p_tran_mm
        AND c.sl_cd IS NOT NULL
        AND NOT EXISTS ( SELECT 1
                           FROM GIAC_SL_LISTS e
                          WHERE e.sl_type_cd = c.sl_type_cd
                            AND e.sl_cd = c.sl_cd)
        AND B.TRAN_FLAG = 'P'
   GROUP BY c.gl_acct_id,
            c.gl_acct_category,
            c.gl_control_acct,
            c.gl_sub_acct_1,
            c.gl_sub_acct_2,
            c.gl_sub_acct_3,
            c.gl_sub_acct_4,
            c.gl_sub_acct_5,
            c.gl_sub_acct_6,
            c.gl_sub_acct_7,
            a.gl_acct_name,
            a.gl_acct_sname,
            c.sl_type_cd,
            c.sl_cd/*,
            b.tran_month,
            b.tran_year*/;

   IF SQL%FOUND THEN
      FORALL cnt IN v_gl_acct_id.FIRST .. v_gl_acct_id.LAST
         INSERT INTO GIAC_TB_SL_EXT
                     (gl_acct_id,
                      gl_acct_name,
                      gl_acct_sname,
                      gl_acct_category,
                      gl_control_acct,
                      gl_sub_acct_1,
                      gl_sub_acct_2,
                      gl_sub_acct_3,
                      gl_sub_acct_4,
                      gl_sub_acct_5,
                      gl_sub_acct_6,
                      gl_sub_acct_7,
                      sl_cd,
                      sl_type_cd,
                      sl_name,
                      beg_debit,
                      beg_credit,
                      month_debit,
                      month_credit,
                      end_debit,
                      end_credit,
                      tran_mm,
                      tran_year)
              VALUES (v_gl_acct_id (cnt),
                      v_gl_acct_name (cnt),
                      v_gl_acct_sname (cnt),
                      v_gl_acct_category (cnt),
                      v_gl_control_acct (cnt),
                      v_gl_sub_acct_1 (cnt),
                      v_gl_sub_acct_2 (cnt),
                      v_gl_sub_acct_3 (cnt),
                      v_gl_sub_acct_4 (cnt),
                      v_gl_sub_acct_5 (cnt),
                      v_gl_sub_acct_6 (cnt),
                      v_gl_sub_acct_7 (cnt),
                      v_sl_cd (cnt),
                      v_sl_type_cd (cnt),
                      'NO SL NAME',
                      0, --V_BEG_DEBIT,
                      0, --V_BEG_CREDIT,
                      v_debit_amt (cnt),
                      v_credit_amt (cnt),
                      v_debit_amt (cnt), --V_BEG_DEBIT + V_MONTH_DEBIT,     --these figures are updated
                      v_credit_amt (cnt), --V_BEG_CREDIT + V_MONTH_CREDIT,  --in the for loop below
                      p_tran_mm,
                      p_tran_year);
   END IF; --IF SQL%FOUND THEN

   COMMIT;
   v_dummy := NULL;


--updates or inserts in the extract table for the beg_debit, beg_credit, end_debit, end_credit values
   FOR c1 IN  (SELECT gl_acct_id, gl_acct_category, gl_control_acct,
                      gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3,
                      gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6,
                      gl_sub_acct_7, gl_acct_name, gl_acct_sname, sl_type_cd,
                      sl_cd, sl_name, end_debit, end_credit
                 FROM GIAC_TB_SL_EXT
                WHERE tran_mm = DECODE (p_tran_mm, 1, 12, p_tran_mm - 1)
                  AND tran_year =
                           DECODE (p_tran_mm, 1, p_tran_year - 1, p_tran_year))
   LOOP

--         IF SQL%FOUND THEN

      BEGIN
         v_dummy := NULL;

         FOR d1 IN  (SELECT gl_acct_id
                       FROM GIAC_TB_SL_EXT
                      WHERE tran_mm = p_tran_mm
                        AND tran_year = p_tran_year
                        AND gl_acct_id = c1.gl_acct_id
                        AND NVL (sl_type_cd, 999) = NVL (c1.sl_type_cd, 999)
                        AND NVL (sl_cd, 999) = NVL (c1.sl_cd, 999)
                        AND ROWNUM = 1)
         LOOP
            v_dummy := d1.gl_acct_id;
         END LOOP;
      END;

      IF v_dummy IS NOT NULL THEN
         --BEGIN



         UPDATE GIAC_TB_SL_EXT
            SET beg_debit = c1.end_debit,
                beg_credit = c1.end_credit,
                end_debit = month_debit + c1.end_debit,
                end_credit = month_credit + c1.end_credit
          WHERE tran_mm = p_tran_mm
            AND tran_year = p_tran_year
            AND gl_acct_id = c1.gl_acct_id
            AND NVL (sl_type_cd, 999) = NVL (c1.sl_type_cd, 999)
            AND NVL (sl_cd, 999) = NVL (c1.sl_cd, 999);
      ELSE --IF v_dummy IS NOT NULL THEN
         INSERT INTO GIAC_TB_SL_EXT
                     (gl_acct_id,
                      gl_acct_name,
                      gl_acct_sname,
                      gl_acct_category,
                      gl_control_acct,
                      gl_sub_acct_1,
                      gl_sub_acct_2,
                      gl_sub_acct_3,
                      gl_sub_acct_4,
                      gl_sub_acct_5,
                      gl_sub_acct_6,
                      gl_sub_acct_7,
                      sl_cd,
                      sl_type_cd,
                      sl_name,
                      beg_debit,
                      beg_credit,
                      month_debit,
                      month_credit,
                      end_debit,
                      end_credit,
                      tran_mm,
                      tran_year)
              VALUES (c1.gl_acct_id,
                      c1.gl_acct_name,
                      c1.gl_acct_sname,
                      c1.gl_acct_category,
                      c1.gl_control_acct,
                      c1.gl_sub_acct_1,
                      c1.gl_sub_acct_2,
                      c1.gl_sub_acct_3,
                      c1.gl_sub_acct_4,
                      c1.gl_sub_acct_5,
                      c1.gl_sub_acct_6,
                      c1.gl_sub_acct_7,
                      c1.sl_cd,
                      c1.sl_type_cd,
                      c1.sl_name,
                      c1.end_debit, --V_BEG_DEBIT,
                      c1.end_credit, --V_BEG_CREDIT,
                      0, --v_debit_amt,
                      0, --v_credit_amt,
                      c1.end_debit, --V_end_DEBIT,
                      c1.end_credit, --V_end_CREDIT,
                      p_tran_mm,
                      p_tran_year);
      END IF; --     IF SQL%FOUND THEN
   END LOOP;

   COMMIT;
END;
/