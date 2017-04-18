CREATE OR REPLACE PACKAGE BODY CPI.giac_unidentified_collns_pkg
AS
   FUNCTION get_old_item_dtls (
      p_gacc_tran_id    giac_unidentified_collns.gacc_tran_id%TYPE,
      p_tran_year       giac_acctrans.tran_year%TYPE,
      p_tran_month      giac_acctrans.tran_month%TYPE,
      p_tran_seq_no     giac_acctrans.tran_seq_no%TYPE,
	  p_old_item_no		giac_unidentified_collns.gunc_item_no%TYPE,
      p_item_no         VARCHAR2)
      RETURN giac_unidentified_collns_tab
      PIPELINED
   IS
      v_unidentified_collns   giac_unidentified_collns_type;
   BEGIN
      FOR i
         IN (  SELECT gacc1.tran_year,
                      gacc1.tran_month,
                      gacc1.tran_seq_no,
                      gunc1.item_no,
                        -1
                      * (  gunc1.collection_amt
                         + SUM (NVL (gunc2.collection_amt, 0)))
                         collection_amt,
                        -1
                      * (  gunc1.collection_amt
                         + SUM (NVL (gunc2.collection_amt, 0)))
                         collection_amt2,
                      gunc1.particulars,
                      gunc1.gacc_tran_id,
                      gunc1.transaction_type,
                      gunc1.gl_acct_id,
                      gunc1.gl_acct_category,
                      gunc1.gl_control_acct,
                      gunc1.gl_sub_acct_1,
                      gunc1.gl_sub_acct_2,
                      gunc1.gl_sub_acct_3,
                      gunc1.gl_sub_acct_4,
                      gunc1.gl_sub_acct_5,
                      gunc1.gl_sub_acct_6,
                      gunc1.gl_sub_acct_7,
                      gunc1.or_print_tag,
                      gunc1.sl_cd,
                      gacc1.tran_id,
                      gunc1.gunc_item_no,
                      gaca.gl_acct_name,
                      gaca.gslt_sl_type_cd,
                      (SELECT sl_name
                         FROM giac_sl_lists
                        WHERE     sl_cd = gunc1.sl_cd
                              AND sl_type_cd = gaca.gslt_sl_type_cd)
                         sl_name
                 FROM giac_unidentified_collns gunc1,
                      giac_chart_of_accts gaca,
                      giac_acctrans gacc1,
                      (SELECT a.gacc_tran_id,
                              a.gunc_gacc_tran_id,
                              a.item_no,
                              a.gunc_item_no,
                              a.collection_amt
                         FROM giac_unidentified_collns a
                        WHERE     a.transaction_type = 2
                              AND NOT EXISTS
                                         (SELECT '1'
                                            FROM giac_acctrans gacc2
                                           WHERE     gacc2.tran_id =
                                                        a.gacc_tran_id
                                                 AND gacc2.tran_flag = 'D')) gunc2
                WHERE     gunc1.gunc_gacc_tran_id IS NULL
                      AND gacc1.tran_id = gunc1.gacc_tran_id
                      AND gunc1.gacc_tran_id = gunc2.gunc_gacc_tran_id(+)
                      AND gaca.gl_acct_id = gunc1.gl_acct_id
                      AND gunc1.item_no = gunc2.gunc_item_no(+)
                      AND gacc1.tran_year = NVL (p_tran_year, gacc1.tran_year)
                      AND gacc1.tran_month =
                             NVL (p_tran_month, gacc1.tran_month)
                      AND gacc1.tran_seq_no =
                             NVL (p_tran_seq_no, gacc1.tran_seq_no)
					  AND gunc1.item_no = NVL (p_old_item_no, gunc1.item_no)
                      AND (   gacc1.tran_year LIKE NVL (p_item_no, '%') --christian 05.03.2012
                           OR gacc1.tran_month LIKE NVL (p_item_no, '%')
                           OR gacc1.tran_seq_no LIKE NVL (p_item_no, '%')
                           OR gunc1.item_no LIKE NVL (p_item_no, '%')
                           OR gunc1.particulars LIKE NVL (p_item_no, '%'))
                      AND gunc1.collection_amt + NVL (gunc2.collection_amt, 0) >
                             0
                      AND gacc1.tran_flag <> 'D'
                      AND NOT EXISTS
                                 (SELECT '1'
                                    FROM giac_reversals grev1,
                                         giac_acctrans gacc2
                                   WHERE     gacc2.tran_id =
                                                grev1.reversing_tran_id
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
                      --gunc1.transaction_type,
                      gunc1.transaction_type,
                      gunc1.gl_acct_id,
                      gunc1.gl_acct_category,
                      gunc1.gl_control_acct,
                      gunc1.gl_sub_acct_1,
                      gunc1.gl_sub_acct_2,
                      gunc1.gl_sub_acct_3,
                      gunc1.gl_sub_acct_4,
                      gunc1.gl_sub_acct_5,
                      gunc1.gl_sub_acct_6,
                      gunc1.gl_sub_acct_7,
                      gunc1.or_print_tag,
                      gunc1.sl_cd,
                      gacc1.tran_id,
                      gunc1.gunc_item_no,
                      gaca.gl_acct_name,
                      gaca.gslt_sl_type_cd
             ORDER BY gacc1.tran_year,
                      gacc1.tran_month,
                      gacc1.tran_seq_no,
                      gunc1.item_no)
      LOOP
         v_unidentified_collns.tran_year := i.tran_year;
         v_unidentified_collns.tran_month := i.tran_month;
         v_unidentified_collns.tran_seq_no := i.tran_seq_no;
         v_unidentified_collns.item_no := i.item_no;
         v_unidentified_collns.collection_amt := i.collection_amt;
         v_unidentified_collns.collection_amt2 := i.collection_amt2;
         v_unidentified_collns.particulars := i.particulars;
         v_unidentified_collns.gacc_tran_id := i.gacc_tran_id;
         v_unidentified_collns.gl_acct_id := i.gl_acct_id;
         v_unidentified_collns.gl_acct_category := i.gl_acct_category;
         v_unidentified_collns.gl_control_acct := i.gl_control_acct;
         v_unidentified_collns.gl_sub_acct_1 := i.gl_sub_acct_1;
         v_unidentified_collns.gl_sub_acct_2 := i.gl_sub_acct_2;
         v_unidentified_collns.gl_sub_acct_3 := i.gl_sub_acct_3;
         v_unidentified_collns.gl_sub_acct_4 := i.gl_sub_acct_4;
         v_unidentified_collns.gl_sub_acct_5 := i.gl_sub_acct_5;
         v_unidentified_collns.gl_sub_acct_6 := i.gl_sub_acct_6;
         v_unidentified_collns.gl_sub_acct_7 := i.gl_sub_acct_7;
         v_unidentified_collns.or_print_tag := i.or_print_tag;
         v_unidentified_collns.sl_cd := i.sl_cd;
         v_unidentified_collns.gunc_tran_id := i.tran_id;
         v_unidentified_collns.gunc_item_no := i.gunc_item_no;
         v_unidentified_collns.gl_acct_name := i.gl_acct_name;
         v_unidentified_collns.transaction_type := i.transaction_type;
         v_unidentified_collns.sl_name := i.sl_name;
         PIPE ROW (v_unidentified_collns);
      END LOOP;
   END get_old_item_dtls;

   FUNCTION get_unidentified_colls_list (
      p_gacc_tran_id    giac_unidentified_collns.gacc_tran_id%TYPE,
      p_fund_cd         VARCHAR2)
      RETURN giac_unidentified_collns_tab2
      PIPELINED
   IS
      v_unidentified_collns   giac_unidentified_collns_type2;
   BEGIN
      FOR i
         IN (  SELECT gacc.gacc_tran_id,
                      gacc.item_no,
                      gacc.transaction_type,
                      gacc.collection_amt,
                      gacc.particulars,
                      gacc.gl_acct_id,
                      gacc.gl_acct_category,
                      gacc.gl_control_acct,
                      gacc.gl_sub_acct_1,
                      gacc.gl_sub_acct_2,
                      gacc.gl_sub_acct_3,
                      gacc.gl_sub_acct_4,
                      gacc.gl_sub_acct_5,
                      gacc.gl_sub_acct_6,
                      gacc.gl_sub_acct_7,
                      gacc.or_print_tag,
                      gacc.sl_cd,
                      gacc.gunc_gacc_tran_id,
                      gacc.gunc_item_no,
                      gaca.gl_acct_name,
                      (SELECT sl_name
                         FROM giac_sl_lists
                        WHERE     fund_cd = p_fund_cd
                              AND gaca.gslt_sl_type_cd = sl_type_cd
                              AND sl_cd = gacc.sl_cd)
                         sl_name,
                      gaca.gslt_sl_type_cd,
                      e.rv_meaning transaction_type_desc
                 FROM giac_unidentified_collns gacc,
                      giac_chart_of_accts gaca,
                      cg_ref_codes e
                WHERE     gacc.gacc_tran_id = p_gacc_tran_id
                      AND gaca.gl_acct_id = gacc.gl_acct_id
                      AND gacc.transaction_type = e.rv_low_value(+)
                      AND e.rv_domain = 'GIAC_LOSS_RI_COLLNS.TRANSACTION_TYPE'
             ORDER BY gacc.item_no)
      LOOP
         v_unidentified_collns.gacc_tran_id := i.gacc_tran_id;
         v_unidentified_collns.item_no := i.item_no;
         v_unidentified_collns.transaction_type := i.transaction_type;
         v_unidentified_collns.collection_amt := i.collection_amt;
         v_unidentified_collns.particulars := i.particulars;
         v_unidentified_collns.gl_acct_id := i.gl_acct_id;
         v_unidentified_collns.gl_acct_category := i.gl_acct_category;
         v_unidentified_collns.gl_control_acct := i.gl_control_acct;
         v_unidentified_collns.gl_sub_acct_1 := i.gl_sub_acct_1;
         v_unidentified_collns.gl_sub_acct_2 := i.gl_sub_acct_2;
         v_unidentified_collns.gl_sub_acct_3 := i.gl_sub_acct_3;
         v_unidentified_collns.gl_sub_acct_4 := i.gl_sub_acct_4;
         v_unidentified_collns.gl_sub_acct_5 := i.gl_sub_acct_5;
         v_unidentified_collns.gl_sub_acct_6 := i.gl_sub_acct_6;
         v_unidentified_collns.gl_sub_acct_7 := i.gl_sub_acct_7;
         v_unidentified_collns.or_print_tag := i.or_print_tag;
         v_unidentified_collns.gunc_gacc_tran_id := i.gunc_gacc_tran_id;
         v_unidentified_collns.gunc_item_no := i.gunc_item_no;
         v_unidentified_collns.gl_acct_name := i.gl_acct_name;
         v_unidentified_collns.sl_cd := i.sl_cd;
         v_unidentified_collns.sl_name := i.sl_name;
         v_unidentified_collns.gslt_sl_type_cd := i.gslt_sl_type_cd;
         v_unidentified_collns.transaction_type_desc := i.transaction_type || ' - ' || i.transaction_type_desc; --added by christian 05.08.2012
         v_unidentified_collns.old_tran_no2 := NULL;
         v_unidentified_collns.tran_year := NULL;
         v_unidentified_collns.tran_month := NULL;
         v_unidentified_collns.tran_seq_no := NULL;
         v_unidentified_collns.fund_cd := p_fund_cd;

         BEGIN
            SELECT DISTINCT gacc.tran_year
                   || '-'
                   || TO_CHAR (gacc.tran_month, '09')
                   || '-'
                   || TO_CHAR (gacc.tran_seq_no, '09999')
                      old_tran_no2,
                   gacc.gfun_fund_cd,
                   gacc.tran_year,
                   gacc.tran_month,
                   gacc.tran_seq_no
              INTO v_unidentified_collns.old_tran_no2,
                   v_unidentified_collns.fund_cd,
                   v_unidentified_collns.tran_year,
                   v_unidentified_collns.tran_month,
                   v_unidentified_collns.tran_seq_no
              FROM giac_unidentified_collns gunc1, giac_acctrans gacc
             WHERE gacc.tran_id = gunc1.gunc_gacc_tran_id
                   AND gacc.tran_id = i.gunc_gacc_tran_id
                   AND gunc1.gacc_tran_id = p_gacc_tran_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         PIPE ROW (v_unidentified_collns);
      END LOOP;
   END get_unidentified_colls_list;

   FUNCTION get_old_tran_nos_list (
      p_gacc_tran_id    giac_unidentified_collns.gacc_tran_id%TYPE,
      p_gunc_tran_id    giac_unidentified_collns.gunc_gacc_tran_id%TYPE)
      RETURN giac_unidentified_collns_tab
      PIPELINED
   IS
      v_unidentified_collns   giac_unidentified_collns_type;
   BEGIN
      FOR i
         IN (SELECT gunc1.particulars,
                    gunc1.collection_amt,
                    gacc.tran_year,
                    gacc.tran_month,
                    gacc.tran_seq_no,
                    gunc1.gunc_gacc_tran_id,
                    gunc1.gacc_tran_id,
                    gunc1.item_no,
                    gunc1.gunc_item_no
               FROM giac_unidentified_collns gunc1, giac_acctrans gacc
              WHERE     gunc1.gacc_tran_id = p_gacc_tran_id
                    AND gacc.tran_id = gunc1.gunc_gacc_tran_id
                    AND gacc.tran_id = p_gunc_tran_id)
      LOOP
         v_unidentified_collns.particulars := i.particulars;
         v_unidentified_collns.collection_amt := i.collection_amt;
         v_unidentified_collns.tran_year := i.tran_year;
         v_unidentified_collns.tran_month := i.tran_month;
         v_unidentified_collns.tran_seq_no := i.tran_seq_no;
         v_unidentified_collns.gunc_tran_id := i.gunc_gacc_tran_id;
         v_unidentified_collns.gacc_tran_id := i.gacc_tran_id;
         v_unidentified_collns.item_no := i.item_no;
         v_unidentified_collns.gunc_item_no := i.gunc_item_no;
         PIPE ROW (v_unidentified_collns);
      END LOOP;
   END get_old_tran_nos_list;

   PROCEDURE set_unidentified_collns_dtls (
      p_gacc_tran_id         giac_unidentified_collns.gacc_tran_id%TYPE,
      p_item_no              giac_unidentified_collns.item_no%TYPE,
      p_transaction_type     giac_unidentified_collns.transaction_type%TYPE,
      p_collection_amt       giac_unidentified_collns.collection_amt%TYPE,
      p_gl_acct_id           giac_unidentified_collns.gl_acct_id%TYPE,
      p_gl_acct_category     giac_unidentified_collns.gl_acct_category%TYPE,
      p_gl_control_acct      giac_unidentified_collns.gl_control_acct%TYPE,
      p_gl_sub_acct_1        giac_unidentified_collns.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2        giac_unidentified_collns.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3        giac_unidentified_collns.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4        giac_unidentified_collns.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5        giac_unidentified_collns.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6        giac_unidentified_collns.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7        giac_unidentified_collns.gl_sub_acct_7%TYPE,
      p_or_print_tag         giac_unidentified_collns.or_print_tag%TYPE,
      p_sl_cd                giac_unidentified_collns.sl_cd%TYPE,
      p_gunc_gacc_tran_id    giac_unidentified_collns.gunc_gacc_tran_id%TYPE,
      p_gunc_item_no         giac_unidentified_collns.gunc_item_no%TYPE,
      p_particulars          giac_unidentified_collns.particulars%TYPE)
   IS
   BEGIN
      MERGE INTO giac_unidentified_collns
           USING DUAL
              ON (gacc_tran_id = p_gacc_tran_id AND item_no = p_item_no)
      WHEN NOT MATCHED
      THEN
         INSERT     (gacc_tran_id,
                     item_no,
                     transaction_type,
                     collection_amt,
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
                     or_print_tag,
                     sl_cd,
                     gunc_gacc_tran_id,
                     gunc_item_no,
                     particulars,
                     user_id,
                     last_update)
             VALUES (p_gacc_tran_id,
                     p_item_no,
                     p_transaction_type,
                     p_collection_amt,
                     p_gl_acct_id,
                     p_gl_acct_category,
                     p_gl_control_acct,
                     p_gl_sub_acct_1,
                     p_gl_sub_acct_2,
                     p_gl_sub_acct_3,
                     p_gl_sub_acct_4,
                     p_gl_sub_acct_5,
                     p_gl_sub_acct_6,
                     p_gl_sub_acct_7,
                     p_or_print_tag,
                     p_sl_cd,
                     p_gunc_gacc_tran_id,
                     p_gunc_item_no,
                     p_particulars,
                     NVL (giis_users_pkg.app_user, USER),
                     SYSDATE)
      WHEN MATCHED
      THEN
         UPDATE SET transaction_type = p_transaction_type,
                    collection_amt = p_collection_amt,
                    gl_acct_id = p_gl_acct_id,
                    gl_acct_category = p_gl_acct_category,
                    gl_control_acct = gl_control_acct,
                    gl_sub_acct_1 = gl_sub_acct_1,
                    gl_sub_acct_2 = gl_sub_acct_2,
                    gl_sub_acct_3 = gl_sub_acct_3,
                    gl_sub_acct_4 = gl_sub_acct_4,
                    gl_sub_acct_5 = gl_sub_acct_5,
                    gl_sub_acct_6 = gl_sub_acct_6,
                    gl_sub_acct_7 = gl_sub_acct_7,
                    or_print_tag = p_or_print_tag,
                    sl_cd = p_sl_cd,
                    gunc_gacc_tran_id = p_gunc_gacc_tran_id,
                    gunc_item_no = p_gunc_item_no,
                    particulars = p_particulars;
   END set_unidentified_collns_dtls;

   PROCEDURE delete_collns_dtls (
      p_gacc_tran_id    giac_unidentified_collns.gacc_tran_id%TYPE,
      p_item_no         giac_unidentified_collns.item_no%TYPE)
   IS
   BEGIN
      DELETE FROM giac_unidentified_collns
            WHERE gacc_tran_id = p_gacc_tran_id AND item_no = p_item_no;
   END delete_collns_dtls;

   FUNCTION validate_old_tran_no (
      p_gacc_fund_cd    giac_acctrans.GFUN_FUND_CD%type,    -- added by shan 10.29.2013
      p_gibr_branch_cd  giac_acctrans.GIBR_BRANCH_CD%type,  -- added by shan 10.29.2013
      p_gacc_tran_id    giac_unidentified_collns.gacc_tran_id%TYPE,
      p_tran_year       giac_acctrans.tran_year%TYPE,
      p_tran_month      giac_acctrans.tran_month%TYPE,
      p_tran_seq_no     giac_acctrans.tran_seq_no%TYPE,
      p_item_no         giac_unidentified_collns.item_no%TYPE)
      RETURN VARCHAR2
   IS
      validOldTran   VARCHAR2 (1) := NULL;
   BEGIN
      SELECT DISTINCT 'Y'
        INTO validOldTran
        FROM GIAC_ACCTRANS A, GIAC_UNIDENTIFIED_COLLNS B
       WHERE     A.TRAN_ID = B.GACC_TRAN_ID
             --AND A.GFUN_FUND_CD = 'CPI'   -- commented out by shan 10.29.2013
             AND A.GFUN_FUND_CD   = P_GACC_FUND_CD  -- added by shan 10.29.2013
             AND A.GIBR_BRANCH_CD = P_GIBR_BRANCH_CD    -- added by shan 10.29.2013
             AND A.TRAN_YEAR = p_tran_year
             AND A.TRAN_MONTH = p_tran_month
             AND A.TRAN_SEQ_NO = p_tran_seq_no
             AND A.TRAN_FLAG <> 'D'
             AND NOT EXISTS
                        (SELECT '1'
                           FROM GIAC_ACCTRANS C, GIAC_REVERSALS D
                          WHERE     C.TRAN_ID = D.REVERSING_TRAN_ID
                                AND D.GACC_TRAN_ID = A.TRAN_ID
                                AND C.TRAN_FLAG != 'D')
             AND A.TRAN_ID <> p_gacc_tran_id
             AND B.GUNC_GACC_TRAN_ID IS NULL
             AND B.TRANSACTION_TYPE = '1';
      RETURN validOldTran;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 'N';
   END validate_old_tran_no;
   
   
  FUNCTION validate_old_item_no(
    p_gacc_tran_id    giac_unidentified_collns.gacc_tran_id%TYPE,
	p_item_no         giac_unidentified_collns.item_no%TYPE)
  RETURN VARCHAR2
    IS
   	validOldItemNo   VARCHAR2(1) := NULL;
   	
  BEGIN
    SELECT 'Y'
	  INTO validOldItemNo
      FROM GIAC_UNIDENTIFIED_COLLNS GUNC1,
	       GIAC_ACCTRANS GACC
     WHERE (GUNC1.GACC_TRAN_ID = p_gacc_tran_id OR 
           (GUNC1.GACC_TRAN_ID IS NULL AND    
           p_gacc_tran_id IS NULL ))
       AND (GUNC1.ITEM_NO = p_item_no OR 
           (GUNC1.ITEM_NO IS NULL AND p_item_no IS NULL ))
       AND gunc_gacc_tran_id is null
       AND GACC.TRAN_ID = GUNC1.GACC_TRAN_ID;
  
  RETURN validOldItemNo;
  EXCEPTION
    WHEN NO_DATA_FOUND
      THEN
        RETURN 'N';
  
  END validate_old_item_no;

   PROCEDURE post_forms_commit_giacs014 (
      p_gacc_tran_id    giac_unidentified_collns.gacc_tran_id%TYPE,
      p_fund_cd         giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_branch_cd       giac_order_of_payts.gibr_branch_cd%TYPE,
      p_user            VARCHAR2,
      p_mod_name        giac_modules.module_name%TYPE,
      p_or_flag         giac_order_of_payts.or_flag%TYPE,
      p_tran_source     VARCHAR2)
   IS
      CURSOR c
      IS
           SELECT gacc_tran_id,
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
                  sl_cd,
                  SUM (collection_amt) amt
             --,   USER_ID,        LAST_UPDATE,         transaction_type
             FROM giac_unidentified_collns
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
      amt_1         giac_unidentified_collns.collection_amt%TYPE;
      amt_2         giac_unidentified_collns.collection_amt%TYPE;
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
            giac_op_text_pkg.update_op_text_giacs014 (p_gacc_tran_id,
                                                      ws_gen_type);
         END IF;
      END IF;

      DELETE FROM giac_acct_entries
            WHERE     gacc_tran_id = p_gacc_tran_id
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

         INSERT INTO giac_acct_entries (gacc_tran_id,
                                        gacc_gfun_fund_cd,
                                        gacc_gibr_branch_cd,
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
                                        sl_cd,
                                        debit_amt,
                                        credit_amt,
                                        generation_type,
                                        user_id,
                                        last_update,
                                        sl_type_cd,
                                        sl_source_cd)
              VALUES (c_rec.gacc_tran_id,
                      p_fund_cd,
                      p_branch_cd,
                      c_rec.gl_acct_id,
                      c_rec.gl_acct_category,
                      c_rec.gl_control_acct,
                      c_rec.gl_sub_acct_1,
                      c_rec.gl_sub_acct_2,
                      c_rec.gl_sub_acct_3,
                      c_rec.gl_sub_acct_4,
                      c_rec.gl_sub_acct_5,
                      c_rec.gl_sub_acct_6,
                      c_rec.gl_sub_acct_7,
                      c_rec.sl_cd,
                      amt_1,
                      amt_2,
                      ws_gen_type,
                      --  C_REC.USER_ID,           C_REC.LAST_UPDATE
                      p_user,
                      SYSDATE,
                      v_sl_type,
                      1);
      END LOOP;
   END post_forms_commit_giacs014;

   FUNCTION search_old_item_dtls (
      p_gacc_tran_id    giac_unidentified_collns.gacc_tran_id%TYPE,
      p_keyword         VARCHAR2)
      RETURN giac_unidentified_collns_tab
      PIPELINED
   IS
      v_unidentified_collns   giac_unidentified_collns_type;
   BEGIN
      FOR i
         IN (  SELECT gacc1.tran_year,
                      gacc1.tran_month,
                      gacc1.tran_seq_no,
                      gunc1.item_no,
                        -1
                      * (  gunc1.collection_amt
                         + SUM (NVL (gunc2.collection_amt, 0)))
                         collection_amt,
                        -1
                      * (  gunc1.collection_amt
                         + SUM (NVL (gunc2.collection_amt, 0)))
                         collection_amt2,
                      gunc1.particulars,
                      gunc1.gacc_tran_id,
                      gunc1.transaction_type,
                      gunc1.gl_acct_id,
                      gunc1.gl_acct_category,
                      gunc1.gl_control_acct,
                      gunc1.gl_sub_acct_1,
                      gunc1.gl_sub_acct_2,
                      gunc1.gl_sub_acct_3,
                      gunc1.gl_sub_acct_4,
                      gunc1.gl_sub_acct_5,
                      gunc1.gl_sub_acct_6,
                      gunc1.gl_sub_acct_7,
                      gunc1.or_print_tag,
                      gunc1.sl_cd,
                      gacc1.tran_id,
                      gunc1.gunc_item_no,
                      gaca.gl_acct_name
                 FROM giac_unidentified_collns gunc1,
                      giac_chart_of_accts gaca,
                      giac_acctrans gacc1,
                      (SELECT a.gacc_tran_id,
                              a.gunc_gacc_tran_id,
                              a.item_no,
                              a.gunc_item_no,
                              a.collection_amt
                         FROM giac_unidentified_collns a
                        WHERE     a.transaction_type = 2
                              AND NOT EXISTS
                                         (SELECT '1'
                                            FROM giac_acctrans gacc2
                                           WHERE     gacc2.tran_id =
                                                        a.gacc_tran_id
                                                 AND gacc2.tran_flag = 'D')) gunc2
                WHERE     gunc1.gunc_gacc_tran_id IS NULL
                      AND gacc1.tran_id = gunc1.gacc_tran_id
                      AND gunc1.gacc_tran_id = gunc2.gunc_gacc_tran_id(+)
                      AND gaca.gl_acct_id = gunc1.gl_acct_id
                      AND gunc1.item_no = gunc2.gunc_item_no(+)
                      AND (   gacc1.tran_year LIKE '%' || p_keyword || '%' --NVL (p_tran_year, gacc1.tran_year)
                           OR gacc1.tran_month LIKE '%' || p_keyword || '%'
                           OR gacc1.tran_seq_no LIKE '%' || p_keyword || '%')
                      AND gunc1.collection_amt + NVL (gunc2.collection_amt, 0) >
                             0
                      AND gacc1.tran_flag <> 'D'
                      AND NOT EXISTS
                                 (SELECT '1'
                                    FROM giac_reversals grev1,
                                         giac_acctrans gacc2
                                   WHERE     gacc2.tran_id =
                                                grev1.reversing_tran_id
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
                      gunc1.transaction_type,
                      gunc1.gl_acct_id,
                      gunc1.gl_acct_category,
                      gunc1.gl_control_acct,
                      gunc1.gl_sub_acct_1,
                      gunc1.gl_sub_acct_2,
                      gunc1.gl_sub_acct_3,
                      gunc1.gl_sub_acct_4,
                      gunc1.gl_sub_acct_5,
                      gunc1.gl_sub_acct_6,
                      gunc1.gl_sub_acct_7,
                      gunc1.or_print_tag,
                      gunc1.sl_cd,
                      gacc1.tran_id,
                      gunc1.gunc_item_no,
                      gaca.gl_acct_name
             ORDER BY gacc1.tran_year,
                      gacc1.tran_month,
                      gacc1.tran_seq_no,
                      gunc1.item_no)
      LOOP
         v_unidentified_collns.tran_year := i.tran_year;
         v_unidentified_collns.tran_month := i.tran_month;
         v_unidentified_collns.tran_seq_no := i.tran_seq_no;
         v_unidentified_collns.item_no := i.item_no;
         v_unidentified_collns.collection_amt := i.collection_amt;
         v_unidentified_collns.collection_amt2 := i.collection_amt2;
         v_unidentified_collns.particulars := i.particulars;
         v_unidentified_collns.gacc_tran_id := i.gacc_tran_id;
         v_unidentified_collns.gl_acct_id := i.gl_acct_id;
         v_unidentified_collns.gl_acct_category := i.gl_acct_category;
         v_unidentified_collns.gl_control_acct := i.gl_control_acct;
         v_unidentified_collns.gl_sub_acct_1 := i.gl_sub_acct_1;
         v_unidentified_collns.gl_sub_acct_2 := i.gl_sub_acct_2;
         v_unidentified_collns.gl_sub_acct_3 := i.gl_sub_acct_3;
         v_unidentified_collns.gl_sub_acct_4 := i.gl_sub_acct_4;
         v_unidentified_collns.gl_sub_acct_5 := i.gl_sub_acct_5;
         v_unidentified_collns.gl_sub_acct_6 := i.gl_sub_acct_6;
         v_unidentified_collns.gl_sub_acct_7 := i.gl_sub_acct_7;
         v_unidentified_collns.or_print_tag := i.or_print_tag;
         v_unidentified_collns.sl_cd := i.sl_cd;
         v_unidentified_collns.gunc_tran_id := i.tran_id;
         v_unidentified_collns.gunc_item_no := i.gunc_item_no;
         v_unidentified_collns.gl_acct_name := i.gl_acct_name;
         PIPE ROW (v_unidentified_collns);
      END LOOP;
   END search_old_item_dtls;
   
   /* Validate that the deletion of the record is permitted    */
    /* by checking for the existence of rows in related tables. */
    /* added by shan 10.30.2013 */
    PROCEDURE validate_del_rec(
        P_GACC_TRAN_ID  IN  NUMBER,       
        P_ITEM_NO       IN  NUMBER
    )
    IS
        CG$DUMMY VARCHAR2(1);
    BEGIN
        /* Deletion of GIAC_UNIDENTIFIED_COLLNS prevented if GIAC_UNIDENTI */
        /* Foreign key(s): GUNC_GUNC_FK                                    */
        DECLARE
            CURSOR C IS
                SELECT  '1'
                  FROM    GIAC_UNIDENTIFIED_COLLNS GUNC
                 WHERE   (GUNC.GUNC_GACC_TRAN_ID = P_GACC_TRAN_ID OR 
                         (GUNC.GUNC_GACC_TRAN_ID IS NULL AND    
                          P_GACC_TRAN_ID IS NULL ))
                 AND     (GUNC.GUNC_ITEM_NO = P_ITEM_NO OR 
                         (GUNC.GUNC_ITEM_NO IS NULL AND    
                          P_ITEM_NO IS NULL ));
        BEGIN
            OPEN C;
            FETCH C
            INTO    CG$DUMMY;
            
            IF C%FOUND THEN
                --msg_alert('Cannot delete GI Unide while dependent GI Unidentified Collections exists', 'E', TRUE);
                raise_application_error(-20001, 'Geniisys Exception#E#Cannot delete GI Unide while dependent GI Unidentified Collections exists.');
            END IF;
          
            CLOSE C;
        END;
    END validate_del_rec;
    
END giac_unidentified_collns_pkg;
/


