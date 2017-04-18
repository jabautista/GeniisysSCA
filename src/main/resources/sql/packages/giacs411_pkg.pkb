CREATE OR REPLACE PACKAGE BODY CPI.GIACS411_PKG
AS
   FUNCTION get_tran_year_lov
      RETURN tran_year_lov_tab PIPELINED
   AS
      v_rec   tran_year_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.tran_year
                           FROM giac_monthly_totals a,
                                giac_yearend_proc_ctr b
                          WHERE a.tran_year = b.tran_year(+)
                            AND a.tran_mm = b.tran_mm(+)
                            AND (   (a.post_tag = '3' AND a.close_tag IS NULL
                                    )
                                 OR (    a.post_tag = '3'
                                     AND b.process_no IS NOT NULL
                                     AND b.process_no < 6
                                    )
                                ))
      LOOP
         v_rec.tran_year := i.tran_year;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_tran_mm_lov (p_tran_year giac_monthly_totals.tran_year%TYPE)
      RETURN tran_mm_lov_tab PIPELINED
   AS
      v_rec   tran_mm_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.tran_mm, a.tran_year
                           FROM giac_monthly_totals a,
                                giac_yearend_proc_ctr b
                          WHERE a.tran_year = p_tran_year
                            AND a.tran_year = b.tran_year(+)
                            AND a.tran_mm = b.tran_mm(+)
                            AND (   (a.post_tag = '3' AND a.close_tag IS NULL
                                    )
                                 OR (    a.post_tag = '3'
                                     AND b.process_no IS NOT NULL
                                     AND b.process_no < 6
                                    )
                                ))
      LOOP
         v_rec.tran_year := i.tran_year;
         v_rec.tran_mm := i.tran_mm;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_gl_no
      RETURN VARCHAR2
   IS
      v_gl_no   VARCHAR2 (100);
   BEGIN
      SELECT TO_CHAR (param_value_n)
        INTO v_gl_no
        FROM giac_parameters
       WHERE UPPER (param_name) = UPPER ('GL_NO');

      IF v_gl_no NOT IN (1, 2)
      THEN
         v_gl_no :=
                 'Geniisys Exception#E#Parameter gl_no has an invalid value.';
      END IF;

      RETURN (v_gl_no);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_gl_no :=
                 'Geniisys Exception#E#Parameter gl_no has an invalid value.';
         RETURN v_gl_no;
   END;

   FUNCTION get_finance_end
      RETURN VARCHAR2
   IS
      v_finance_end   VARCHAR2 (100);
   BEGIN
      SELECT TO_CHAR (param_value_n)
        INTO v_finance_end
        FROM giac_parameters
       WHERE UPPER (param_name) = UPPER ('FINANCE_END');

      RETURN v_finance_end;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_finance_end :=
            'Geniisys Exception#E#Parameter finance_end not found in giac_parameters.';
         RETURN v_finance_end;
   END;

   FUNCTION get_fiscal_end
      RETURN VARCHAR2
   IS
      v_fiscal_end   VARCHAR2 (100);
   BEGIN
      SELECT TO_CHAR (param_value_n)
        INTO v_fiscal_end
        FROM giac_parameters
       WHERE UPPER (param_name) = UPPER ('FISCAL_END');

      RETURN v_fiscal_end;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_fiscal_end :=
            'Geniisys Exception#E#Parameter fiscal_end not found in giac_parameters.';
         RETURN v_fiscal_end;
   END;

   FUNCTION cye_get_module_id
      RETURN module_id_tab PIPELINED
   AS
      v_rec   module_id_type;
   BEGIN
      SELECT module_id, generation_type
        INTO v_rec.module_id, v_rec.gen_type
        FROM giac_modules
       WHERE module_name = 'GIACS411';                     --vars.module_name;

      PIPE ROW (v_rec);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_rec.msg := 'No data found in giac_modules.';
         PIPE ROW (v_rec);
   END;

   PROCEDURE close_mm_yr (
      p_tran_year     IN     giac_monthly_totals.tran_year%TYPE,
      p_tran_mm       IN     giac_monthly_totals.tran_mm%TYPE,
      p_gl_no         IN     NUMBER,
      p_finance_end   IN     NUMBER,
      p_fiscal_end    IN     NUMBER,
      p_msg           IN OUT VARCHAR2
   )
   IS
      v_gl   VARCHAR2 (15);
   BEGIN
      IF p_gl_no = 1
      THEN
         IF p_tran_mm = p_finance_end
         THEN
            raise_application_error
                  (-20001,
                   'Geniisys Confirmation#Confirmation#Close Financial Year?'
                  );
         ELSE
            close_normal_month (p_tran_year, p_tran_mm, p_gl_no);
         END IF;
      ELSIF p_gl_no = 2
      THEN
         IF p_fiscal_end = p_finance_end
         THEN
            raise_application_error
                (-20001,
                 'Geniisys Exception#I#Parameter gl_no has an invalid value.'
                );
         END IF;

         IF (p_tran_mm = p_fiscal_end) OR (p_tran_mm = p_finance_end)
         THEN
            IF p_tran_mm = p_fiscal_end
            THEN
               v_gl := 'Fiscal';
            ELSIF p_tran_mm = p_finance_end
            THEN
               v_gl := 'Financial';
            END IF;

            raise_application_error
                               (-20001,
                                   'Geniisys Confirmation#Confirmation#Close '
                                || v_gl
                                || ' Year?'
                               );
         ELSE
            close_normal_month (p_tran_year, p_tran_mm, p_gl_no);
         END IF;
      END IF;
      
      p_msg := p_msg ||'#success';
   END;
   
   PROCEDURE confirm_close_mm_yr (
      p_tran_year     IN giac_monthly_totals.tran_year%TYPE,
      p_tran_mm       IN giac_monthly_totals.tran_mm%TYPE,
      p_gl_no         IN NUMBER,
      p_finance_end   IN NUMBER,
      p_fiscal_end    IN NUMBER,
      p_gen_type      IN GIAC_MODULES.generation_type%TYPE,
      p_module_id     IN GIAC_MODULES.module_id%TYPE,
      p_user_id       IN GIIS_USERS.user_id%TYPE,
      p_msg       IN OUT VARCHAR2
   )
   IS
      v_gl   VARCHAR2 (15);
   BEGIN
      IF p_gl_no = 1
      THEN
         IF p_tran_mm = p_finance_end
         THEN
            close_normal_month (p_tran_year, p_tran_mm, p_gl_no);
            cye_close_yearend (p_tran_year,
                               p_tran_mm,
                               p_gl_no,
                               p_finance_end,
                               p_fiscal_end,
                               p_gen_type,
                               p_module_id,
                               p_user_id,
                               p_msg);
         END IF;
      ELSIF p_gl_no = 2
      THEN
         IF (p_tran_mm = p_fiscal_end) OR (p_tran_mm = p_finance_end)
         THEN
            close_normal_month (p_tran_year, p_tran_mm, p_gl_no);
            cye_close_yearend (p_tran_year,
                               p_tran_mm,
                               p_gl_no,
                               p_finance_end,
                               p_fiscal_end,
                               p_gen_type,
                               p_module_id,
                               p_user_id,
                               p_msg);
         END IF;
      END IF;
      
      p_msg := p_msg ||'#success';
   END;

   PROCEDURE close_normal_month (
      p_tran_year   IN   NUMBER,
      p_tran_mm     IN   NUMBER,
      p_gl_no            NUMBER
   )
   IS
      v_post_tag   giac_monthly_totals.post_tag%TYPE;
      msg_txt      VARCHAR2 (150);
   BEGIN
      FOR a IN (SELECT post_tag
                  FROM giac_monthly_totals
                 WHERE tran_year = p_tran_year AND tran_mm = p_tran_mm)
      LOOP
         v_post_tag := a.post_tag;
         EXIT;
      END LOOP;

      IF NVL (v_post_tag, '-') <> '3'
      THEN
         IF p_gl_no = 1
         THEN
            msg_txt :=
                  'Cannot close the General Ledger. Post '
               || 'the transactions first.';
         ELSIF p_gl_no = 2
         THEN
            IF NVL (v_post_tag, '-') = '1'
            THEN
               msg_txt :=
                     'Cannot close the General Ledger. Post '
                  || 'the transactions to the Financial '
                  || 'GL first.';
            ELSIF NVL (v_post_tag, '-') = '2'
            THEN
               msg_txt :=
                     'Cannot close the General Ledger. Post '
                  || 'the transactions to the Fiscal '
                  || 'GL first.';
            ELSIF v_post_tag IS NULL
            THEN
               msg_txt :=
                     'Cannot close the General Ledger. Post '
                  || 'the transactions to the Fiscal and '
                  || 'Financial GLs first.';
            END IF;
         END IF;

         raise_application_error (-20001, 'Geniisys Exception#I#' || msg_txt);
      ELSE
         UPDATE giac_fiscal_yr
            SET close_tag = 'Y'
          WHERE tran_year = p_tran_year AND tran_mm = p_tran_mm;

         IF SQL%NOTFOUND
         THEN
            raise_application_error
                     (-20001,
                      'Geniisys Exception#E#Unable to update giac_fiscal_yr.'
                     );
         END IF;

         UPDATE giac_finance_yr
            SET close_tag = 'Y'
          WHERE tran_year = p_tran_year AND tran_mm = p_tran_mm;

         IF SQL%NOTFOUND
         THEN
            raise_application_error
                    (-20001,
                     'Geniisys Exception#E#Unable to update giac_finance_yr.'
                    );
         END IF;

         UPDATE giac_monthly_totals
            SET close_tag = 'Y'
          WHERE tran_year = p_tran_year AND tran_mm = p_tran_mm;

         IF SQL%NOTFOUND
         THEN
            raise_application_error
                (-20001,
                 'Geniisys Exception#E#Unable to update giac_monthly_totals.'
                );
         END IF;

         --Added by Joy 03/01/2001
         UPDATE giac_tran_mm
            SET closed_tag = 'Y'
          WHERE tran_yr = p_tran_year AND tran_mm = p_tran_mm;

         IF SQL%NOTFOUND
         THEN
            raise_application_error
                       (-20001,
                        'Geniisys Exception#E#Unable to update giac_tran_mm.'
                       );
         END IF;
      END IF;
   END;

   PROCEDURE cye_close_yearend (
      p_tran_year     IN        NUMBER,
      p_tran_mm       IN        NUMBER,
      p_gl_no         IN        NUMBER,
      p_finance_end   IN        NUMBER,
      p_fiscal_end    IN        NUMBER,
      p_gen_type      IN        GIAC_MODULES.generation_type%TYPE,
      p_module_id     IN        giac_modules.module_id%TYPE,
      p_user_id       IN        GIIS_USERS.user_id%TYPE,
      p_msg           IN OUT    VARCHAR2
   )
   IS
      v_process_no   giac_yearend_proc_ctr.process_no%TYPE   := NULL;
   BEGIN
      giacs411_pkg.cye_get_process_no (p_tran_year, p_tran_mm, v_process_no);

      IF v_process_no = 0
      THEN
         giacs411_pkg.cye_delete_temp_tables (p_tran_year, p_tran_mm, p_msg);-- process 1.
         giacs411_pkg.cye_extract_ie_entries (p_tran_year, p_tran_mm);-- process 2.
         giacs411_pkg.cye_create_rev_entries (p_tran_year, p_tran_mm, p_gl_no, p_finance_end, p_fiscal_end, p_gen_type, p_user_id);-- process 3.
         giacs411_pkg.cye_sum_post_rev_entries (p_tran_year, p_tran_mm, p_gl_no, p_finance_end, p_fiscal_end, p_gen_type, p_user_id, p_module_id);-- process 4.
         giacs411_pkg.cye_update_giac_finance_yr (p_tran_year, p_tran_mm, p_gl_no, p_finance_end, p_fiscal_end, p_gen_type, p_module_id);--process 4
         giacs411_pkg.cye_insert_acct_entries (p_tran_year, p_tran_mm);-- process 5.
         giacs411_pkg.cye_delete_temp_tables (p_tran_year, p_tran_mm, p_msg);-- process 6.
      ELSIF v_process_no = 1
      THEN
         giacs411_pkg.cye_extract_ie_entries (p_tran_year, p_tran_mm);-- process 2.
         giacs411_pkg.cye_create_rev_entries (p_tran_year, p_tran_mm, p_gl_no, p_finance_end, p_fiscal_end, p_gen_type, p_user_id);-- process 3.
         giacs411_pkg.cye_sum_post_rev_entries (p_tran_year, p_tran_mm, p_gl_no, p_finance_end, p_fiscal_end, p_gen_type, p_user_id, p_module_id);-- process 4.
         giacs411_pkg.cye_update_giac_finance_yr (p_tran_year, p_tran_mm, p_gl_no, p_finance_end, p_fiscal_end, p_gen_type, p_module_id);--process 4
         giacs411_pkg.cye_insert_acct_entries (p_tran_year, p_tran_mm);-- process 5.
         giacs411_pkg.cye_delete_temp_tables (p_tran_year, p_tran_mm, p_msg);-- process 6.
      ELSIF v_process_no = 2
      THEN
         giacs411_pkg.cye_create_rev_entries (p_tran_year, p_tran_mm, p_gl_no, p_finance_end, p_fiscal_end, p_gen_type, p_user_id);-- process 3.
         giacs411_pkg.cye_sum_post_rev_entries (p_tran_year, p_tran_mm, p_gl_no, p_finance_end, p_fiscal_end, p_gen_type, p_user_id, p_module_id);-- process 4.
         giacs411_pkg.cye_update_giac_finance_yr (p_tran_year, p_tran_mm, p_gl_no, p_finance_end, p_fiscal_end, p_gen_type, p_module_id);--process 4
         giacs411_pkg.cye_insert_acct_entries (p_tran_year, p_tran_mm);-- process 5.
         giacs411_pkg.cye_delete_temp_tables (p_tran_year, p_tran_mm, p_msg);-- process 6.
      ELSIF v_process_no = 3
      THEN
         giacs411_pkg.cye_sum_post_rev_entries (p_tran_year, p_tran_mm, p_gl_no, p_finance_end, p_fiscal_end, p_gen_type, p_user_id, p_module_id);-- process 4.
         giacs411_pkg.cye_update_giac_finance_yr (p_tran_year, p_tran_mm, p_gl_no, p_finance_end, p_fiscal_end, p_gen_type, p_module_id);--process 4
         giacs411_pkg.cye_insert_acct_entries (p_tran_year, p_tran_mm);-- process 5.
         giacs411_pkg.cye_delete_temp_tables (p_tran_year, p_tran_mm, p_msg);-- process 6.
      ELSIF v_process_no = 4
      THEN
         giacs411_pkg.cye_insert_acct_entries (p_tran_year, p_tran_mm);-- process 5.
         giacs411_pkg.cye_delete_temp_tables (p_tran_year, p_tran_mm, p_msg);-- process 6.
      ELSIF v_process_no = 5
      THEN
         giacs411_pkg.cye_delete_temp_tables (p_tran_year, p_tran_mm, p_msg);-- process 6.
      ELSIF v_process_no = 6
      THEN
         raise_application_error
               (-20001,
                'Geniisys Exception#E#Closing of yearend has been completed.'
               );
      END IF;
   END;

   PROCEDURE cye_get_process_no (
      p_tran_year             NUMBER,
      p_tran_mm               NUMBER,
      p_process_no   IN OUT   NUMBER
   )
   IS
   BEGIN
      FOR a IN (SELECT process_no
                  FROM giac_yearend_proc_ctr
                 WHERE tran_year = p_tran_year AND tran_mm = p_tran_mm)
      LOOP
         p_process_no := a.process_no;
         EXIT;
      END LOOP;

      IF p_process_no IS NULL
      THEN
         p_process_no := 0;
      END IF;
   END;

   PROCEDURE cye_delete_temp_tables (
      p_tran_year   IN       NUMBER,
      p_tran_mm     IN       NUMBER,
      p_msg         IN OUT   VARCHAR2
   )
   IS
      v_exists      VARCHAR2 (1);
      v_processed   VARCHAR2 (1);
   BEGIN
      FOR a IN (SELECT '1' wan
                  FROM giac_close_acct_entries_ext)
      LOOP
         v_exists := a.wan;
         EXIT;
      END LOOP;

      IF v_exists IS NOT NULL
      THEN
         --FORMS_DDL('truncate table giac_close_acct_entries_ext'); --commented by alfie
         DELETE      giac_close_acct_entries_ext;            --alfie 07232009

         IF SQL%NOTFOUND
         THEN
            p_msg :=
                  p_msg
               || '#Unable to delete old data in giac_close_acct_entries_ext.';
         END IF;
      END IF;

      FOR b IN (SELECT '1' wan
                  FROM giac_close_rev_entries_ext)
      LOOP
         v_exists := b.wan;
         EXIT;
      END LOOP;

      IF v_exists IS NOT NULL
      THEN
         --  FORMS_DDL('truncate table giac_close_rev_entries_ext');  --commented by alfie
         DELETE      giac_close_rev_entries_ext;            --alfie 072232009

         IF SQL%NOTFOUND
         THEN
            p_msg :=
                  p_msg
               || '#Unable to delete old data in giac_close_rev_entries_ext.';
         END IF;
      END IF;

      FOR c IN (SELECT '1' wan
                  FROM giac_yearend_proc_ctr
                 WHERE tran_year = p_tran_year AND tran_mm = p_tran_mm)
      LOOP
         v_processed := c.wan;
         EXIT;
      END LOOP;

      IF v_processed IS NULL
      THEN
         INSERT INTO giac_yearend_proc_ctr
                     (tran_year, tran_mm, process_no
                     )
              VALUES (p_tran_year, p_tran_mm, 1
                     );

         IF SQL%NOTFOUND
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Unable to insert process 1 into giac_yearend_proc_ctr.'
               );
         END IF;
      ELSE
         UPDATE giac_yearend_proc_ctr
            SET process_no = 6
          WHERE tran_year = p_tran_year AND tran_mm = p_tran_mm;

         IF SQL%NOTFOUND
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Unable to update giac_yearend_proc_ctr to process 6.'
               );
         END IF;
      END IF;
   END;
   
   PROCEDURE cye_extract_ie_entries (
       p_tran_year  IN NUMBER, 
       p_tran_mm    IN NUMBER
   )
   IS
   BEGIN
       INSERT INTO giac_close_acct_entries_ext
                   (gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd,
                    acct_entry_id, gl_acct_id, gl_acct_category, gl_control_acct,
                    gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4,
                    gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7, sl_cd,
                    debit_amt, credit_amt, sl_type_cd, sl_source_cd)
          (SELECT giae.gacc_tran_id, gacc.gfun_fund_cd, gacc.gibr_branch_cd,
                  giae.acct_entry_id, giae.gl_acct_id, giae.gl_acct_category,
                  giae.gl_control_acct, giae.gl_sub_acct_1, giae.gl_sub_acct_2,
                  giae.gl_sub_acct_3, giae.gl_sub_acct_4, giae.gl_sub_acct_5,
                  giae.gl_sub_acct_6, giae.gl_sub_acct_7, giae.sl_cd,
                  NVL (giae.debit_amt, 0),                   --alfie 05272009 nvl
                                          NVL (giae.credit_amt, 0),
                  giae.sl_type_cd, giae.sl_source_cd
             FROM giac_chart_of_accts gcoa,
                  giac_acctrans gacc,
                  giac_acct_entries giae
            WHERE giae.gacc_tran_id = gacc.tran_id
              AND TO_DATE (TO_CHAR (gacc.posting_date, 'MMYYYY'), 'MMYYYY')
                     BETWEEN TO_DATE
                               ((TO_CHAR
                                    (ADD_MONTHS (TO_DATE (   TO_CHAR (p_tran_mm,
                                                                      'fm09'
                                                                     )
                                                          || TO_CHAR (p_tran_year),
                                                          'MMYYYY'
                                                         ),
                                                 -11
                                                ),
                                     'MMYYYY'
                                    )
                                ),
                                'MMYYYY'
                               )
                         AND TO_DATE (TO_CHAR (TO_DATE (   TO_CHAR (p_tran_mm,
                                                                    'fm09'
                                                                   )
                                                        || TO_CHAR (p_tran_year),
                                                        'MMYYYY'
                                                       ),
                                               'MMYYYY'
                                              ),
                                      'MMYYYY'
                                     )
              AND gacc.tran_flag = 'P'
              AND gacc.tran_class NOT IN ('EOF', 'EOY')
              AND giae.gl_acct_id = gcoa.gl_acct_id
              AND gcoa.acct_type IN ('I', 'E'));

       IF SQL%NOTFOUND
       THEN
          --msg_alert('Error inserting into giac_close_acct_entries_ext.',
            --        'E', TRUE);
          NULL;
       END IF;

       UPDATE giac_yearend_proc_ctr
          SET process_no = 2
        WHERE tran_year = p_tran_year AND tran_mm = p_tran_mm;

       IF SQL%NOTFOUND
       THEN
          raise_application_error
               (-20001,
                'Geniisys Exception#E#Unable to update giac_yearend_proc_ctr to process 2.'
               );
       END IF;
   END;
   
   -- porcess 3.
   -- create reversing acctg entries for all income  accts.
   PROCEDURE cye_create_rev_entries (
       p_tran_year     IN   NUMBER,
       p_tran_mm       IN   NUMBER,
       p_gl_no         IN   NUMBER,
       p_finance_end   IN   NUMBER,
       p_fiscal_end    IN   NUMBER,
       p_gen_type      IN   GIAC_MODULES.generation_type%TYPE,
       p_user_id       IN   GIIS_USERS.user_id%TYPE
   )
   IS
       /*CURSOR a IS
         SELECT DISTINCT gacc_gfun_fund_cd, gacc_gibr_branch_cd,sl_source_cd,sl_type_cd
           FROM giac_close_acct_entries_ext;*/ --commented by alfie 06152009
       CURSOR b
            /*(p_fund_cd   IN giac_close_acct_entries_ext.gacc_gfun_fund_cd%TYPE,
            p_branch_cd IN giac_close_acct_entries_ext.gacc_gibr_branch_cd%TYPE,
            p_sl_source_cd IN giac_close_acct_entries_ext.sl_source_cd%TYPE,
            p_sl_type_cd   IN giac_close_acct_entries_ext.sl_type_cd%TYPE)*/
       IS
          SELECT   gacc_gfun_fund_cd,                            --Alfie 06152009
                                     gacc_gibr_branch_cd,                    --:)
                                                         gl_acct_id,
                   gl_acct_category, gl_control_acct, gl_sub_acct_1,
                   gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5,
                   gl_sub_acct_6, gl_sub_acct_7, sl_cd, debit_amt, credit_amt,
                   sl_type_cd, sl_source_cd
              FROM giac_close_acct_entries_ext
          /* WHERE gacc_gfun_fund_cd = p_fund_cd
           AND gacc_gibr_branch_cd = p_branch_cd
           AND nvl(sl_source_cd,'-') = nvl(p_sl_source_cd,'-')
           AND nvl(sl_type_cd,'-') = nvl(p_sl_type_cd,'-')*/
          ORDER BY gacc_gfun_fund_cd,
                   gacc_gibr_branch_cd,
                   sl_source_cd,
                   sl_type_cd,
                   sl_cd,
                   gl_acct_id;

       v_tran_class          giac_acctrans.tran_class%TYPE;
       --v_exists            VARCHAR2(1) := 'N'; --commented by alfie 06152009
       v_current_record      VARCHAR2 (1000)                         := '2';
       v_new_record          VARCHAR2 (1000)                         := '1';
       v_particulars         giac_acctrans.particulars%TYPE;
       v_tran_id             giac_acctrans.tran_id%TYPE;
       v_last_update         giac_acctrans.last_update%TYPE;
       v_item_no             giac_module_entries.item_no%TYPE        := 1;
       v_acct_entry_id       giac_acct_entries.acct_entry_id%TYPE;
       v_debit_amt           giac_acct_entries.debit_amt%TYPE;
       v_credit_amt          giac_acct_entries.credit_amt%TYPE;
       v_remarks             giac_acct_entries.remarks%TYPE;
       v_finance_gl_exists   VARCHAR2 (1);
       v_fiscal_gl_exists    VARCHAR2 (1);
       v_trans_debit_bal     giac_finance_yr.trans_debit_bal%TYPE;
       v_trans_credit_bal    giac_finance_yr.trans_credit_bal%TYPE;
       v_trans_balance       giac_finance_yr.trans_balance%TYPE;
       v_finance_record      VARCHAR2 (1000)                         := '1';
       v_new_record2         VARCHAR2 (1000)                         := '2';
       --added by alfie 06152009
       v_new_record3         VARCHAR2 (1000)                         := '1';     --
       v_fiscal_record       VARCHAR2 (1000)                         := '2';     --
       v_total_recordc       NUMBER                                  := 0;       --
    --   v_counter             NUMBER                                  := 0;  -- ;-)
   BEGIN
   
       IF p_gl_no = 1
       THEN
          IF p_tran_mm = p_finance_end
          THEN
             v_tran_class := 'EOY';
          END IF;
       ELSIF p_gl_no = 2
       THEN
          IF p_tran_mm = p_fiscal_end
          THEN
             v_tran_class := 'EOF';
          ELSIF p_tran_mm = p_finance_end
          THEN
             v_tran_class := 'EOY';
          END IF;
       END IF;

       v_particulars :=
             'Reversing '
          || v_tran_class
          || ' entry for '
          || TO_CHAR (p_tran_mm)
          || '-'
          || TO_CHAR (p_tran_year)
          || '.';
       v_remarks :=
          v_tran_class || ' ' || TO_CHAR (p_tran_mm) || '-'
          || TO_CHAR (p_tran_year);

       SELECT COUNT (*)
         INTO v_total_recordc
         FROM giac_close_acct_entries_ext;                        --alfie 06152009

       --FOR a_rec IN a LOOP
       FOR b_rec IN b
       LOOP
          /*v_counter := v_counter + 1;
          MESSAGE (   'Reversing '
                   || v_counter
                   || ' of '
                   || v_total_recordc
                   || ' entries...',
                   no_acknowledge
                  );*/
          v_new_record :=
                b_rec.gacc_gfun_fund_cd
             || b_rec.gacc_gibr_branch_cd
             || b_rec.sl_source_cd
             || b_rec.sl_type_cd;

          IF v_new_record <> v_current_record
          THEN
             GIACS411_PKG.cye_create_acctrans_record (p_tran_year,
                                         p_tran_mm,
                                         b_rec.gacc_gfun_fund_cd,          
                                         b_rec.gacc_gibr_branch_cd,         
                                         v_particulars,
                                         v_tran_class,
                                         v_tran_id,
                                         p_user_id
                                        );
             v_current_record := v_new_record;
          END IF;

          /*FOR b_rec IN b(a_rec.gacc_gfun_fund_cd,
                         a_rec.gacc_gibr_branch_cd,
                         a_rec.sl_source_cd,
                         a_rec.sl_type_cd) LOOP*/ --commented by alfie 06152009
          v_debit_amt := NVL (b_rec.credit_amt, 0);
          v_credit_amt := NVL (b_rec.debit_amt, 0);

          BEGIN
             SELECT NVL (MAX (a.acct_entry_id), 0) acct_entry_id
               INTO v_acct_entry_id
               FROM giac_close_rev_entries_ext a
              WHERE a.gacc_tran_id = v_tran_id
                --AND A.gacc_gibr_branch_cd = a_rec.gacc_gibr_branch_cd --alfie 06152009
                AND a.gacc_gibr_branch_cd = b_rec.gacc_gibr_branch_cd            --
                --AND A.gacc_gfun_fund_cd = a_rec.gacc_gfun_fund_cd --
                AND a.gacc_gfun_fund_cd = b_rec.gacc_gfun_fund_cd                --
                -- AND NVL(A.sl_cd, 0) = NVL(b_rec.sl_cd, NVL(A.sl_cd, 0))
                AND NVL (a.sl_cd, 0) = NVL (b_rec.sl_cd, 0)                      --
                -- AND NVL(A.sl_type_cd, '-') = NVL(b_rec.sl_type_cd, NVL(A.sl_type_cd, '-')) --
                AND NVL (a.sl_type_cd, '-') = NVL (b_rec.sl_type_cd, '-')        --
                -- AND NVL(A.sl_source_cd, '-') = NVL(b_rec.sl_source_cd, NVL(A.sl_source_cd, '-')) --
                AND NVL (a.sl_source_cd, '-') = NVL (b_rec.sl_source_cd, '-')
                -- :)
                AND a.generation_type = p_gen_type
                AND a.gl_acct_id = b_rec.gl_acct_id;

             IF NVL (v_acct_entry_id, 0) = 0
             THEN
                BEGIN
                   SELECT NVL (MAX (a.acct_entry_id), 0) acct_entry_id
                     INTO v_acct_entry_id
                     FROM giac_close_rev_entries_ext a
                    WHERE a.gacc_tran_id = v_tran_id;
                END;

                v_acct_entry_id := NVL (v_acct_entry_id, 0) + 1;

                INSERT INTO giac_close_rev_entries_ext
                            (gacc_tran_id, gacc_gfun_fund_cd,
                             gacc_gibr_branch_cd, acct_entry_id,
                             gl_acct_id, gl_acct_category,
                             gl_control_acct, gl_sub_acct_1,
                             gl_sub_acct_2, gl_sub_acct_3,
                             gl_sub_acct_4, gl_sub_acct_5,
                             gl_sub_acct_6, gl_sub_acct_7,
                             sl_cd, debit_amt, credit_amt,
                             generation_type, user_id, last_update, remarks,
                             sl_type_cd, sl_source_cd
                            )
                     VALUES (v_tran_id, b_rec.gacc_gfun_fund_cd,        --06152009
                             --v_tran_id, a_rec.gacc_gfun_fund_cd,--
                             b_rec.gacc_gibr_branch_cd, v_acct_entry_id,         --
                             --a_rec.gacc_gibr_branch_cd, v_acct_entry_id, --
                             b_rec.gl_acct_id, b_rec.gl_acct_category,
                             b_rec.gl_control_acct, b_rec.gl_sub_acct_1,
                             b_rec.gl_sub_acct_2, b_rec.gl_sub_acct_3,
                             b_rec.gl_sub_acct_4, b_rec.gl_sub_acct_5,
                             b_rec.gl_sub_acct_6, b_rec.gl_sub_acct_7,
                             b_rec.sl_cd, v_debit_amt, v_credit_amt,
                             p_gen_type, p_user_id, SYSDATE, v_remarks,
                             b_rec.sl_type_cd, b_rec.sl_source_cd
                            );
             ELSE
                UPDATE giac_close_rev_entries_ext a
                   SET debit_amt = debit_amt + v_debit_amt,
                       credit_amt = credit_amt + v_credit_amt
                 WHERE a.gacc_tran_id = v_tran_id
                   --AND A.gacc_gibr_branch_cd = a_rec.gacc_gibr_branch_cd -- alfie 06152009
                   AND a.gacc_gibr_branch_cd = b_rec.gacc_gibr_branch_cd         --
                   --AND A.gacc_gfun_fund_cd = a_rec.gacc_gfun_fund_cd --
                   AND a.gacc_gfun_fund_cd = b_rec.gacc_gfun_fund_cd             --
                   -- AND NVL(A.sl_cd, 0) = NVL(b_rec.sl_cd, NVL(A.sl_cd, 0)) --
                   AND NVL (a.sl_cd, 0) = NVL (b_rec.sl_cd, 0)                   --
                   -- AND NVL(A.sl_type_cd, '-') = NVL(b_rec.sl_type_cd, NVL(A.sl_type_cd, '-')) --
                   AND NVL (a.sl_type_cd, '-') = NVL (b_rec.sl_type_cd, '-')     --
                   -- AND NVL(A.sl_source_cd, '-') = NVL(b_rec.sl_source_cd, NVL(A.sl_source_cd, '-')) --
                   AND NVL (a.sl_source_cd, '-') = NVL (b_rec.sl_source_cd, '-')
                   -- :)
                   AND a.generation_type = p_gen_type
                   AND a.gl_acct_id = b_rec.gl_acct_id;
             END IF;
          END;

          v_trans_balance := NVL (v_debit_amt, 0) - NVL (v_credit_amt, 0);

          IF v_trans_balance < 0
          THEN
             v_trans_debit_bal := 0;
             v_trans_credit_bal := ABS (NVL (v_trans_balance, 0));
          ELSIF v_trans_balance > 0
          THEN
             v_trans_debit_bal := ABS (NVL (v_trans_balance, 0));
             v_trans_credit_bal := 0;
          ELSIF v_trans_balance = 0
          THEN
             v_trans_debit_bal := 0;
             v_trans_credit_bal := 0;
          END IF;

          IF p_gl_no IN (1, 2)
          THEN
             IF p_tran_mm = p_finance_end
             THEN
                v_new_record2 :=
                      b_rec.gl_acct_id
                   || b_rec.gacc_gfun_fund_cd
                   || b_rec.gacc_gibr_branch_cd
                   || p_tran_year
                   || p_tran_mm;

                IF v_new_record2 <> v_finance_record
                THEN
                   --FOR e IN (
                   BEGIN
                      SELECT '1' wan
                        INTO v_finance_gl_exists
                        FROM giac_finance_yr
                       WHERE gl_acct_id = b_rec.gl_acct_id
                         --AND fund_cd = a_rec.gacc_gfun_fund_cd --commented by alfie
                         AND fund_cd = b_rec.gacc_gfun_fund_cd    --added by alfie
                         --AND branch_cd = a_rec.gacc_gibr_branch_cd --
                         AND branch_cd = b_rec.gacc_gibr_branch_cd               --
                         AND tran_year = p_tran_year
                         AND tran_mm = p_tran_mm;                         --) LOOP
                   --   v_finance_gl_exists := e.wan;
                   --   EXIT;
                   -- END LOOP; -- ;-)
                   EXCEPTION
                      WHEN NO_DATA_FOUND
                      THEN
                         v_finance_gl_exists := NULL;
                   END;

                   v_finance_record := v_new_record2;
                END IF;

                IF v_finance_gl_exists IS NOT NULL
                THEN
                   UPDATE giac_finance_yr
                      SET trans_debit_bal =
                              NVL (trans_debit_bal, 0)
                              + NVL (v_trans_debit_bal, 0),
                          trans_credit_bal =
                               NVL (trans_credit_bal, 0)
                             + NVL (v_trans_credit_bal, 0),
                          end_debit_amt =
                                NVL (end_debit_amt, 0)
                                + NVL (v_trans_debit_bal, 0),
                          end_credit_amt =
                              NVL (end_credit_amt, 0)
                              + NVL (v_trans_credit_bal, 0),
                          trans_balance =
                               (NVL (end_debit_amt, 0)
                                + NVL (v_trans_debit_bal, 0)
                               )
                             - (  NVL (end_credit_amt, 0)
                                + NVL (v_trans_credit_bal, 0)
                               )
                    WHERE gl_acct_id = b_rec.gl_acct_id
                      AND fund_cd = b_rec.gacc_gfun_fund_cd       --added by alfie
                      --AND fund_cd = a_rec.gacc_gfun_fund_cd --commented by alfie 06152009
                      AND branch_cd = b_rec.gacc_gibr_branch_cd                  --
                      --AND branch_cd = a_rec.gacc_gibr_branch_cd -- :)
                      AND tran_year = p_tran_year
                      AND tran_mm = p_tran_mm;
                ELSE
                   raise_application_error
                       (-20001,
                        'Geniisys Exception#E#This reversing gl not found in giac_finance_yr.'
                       );
                END IF;
             END IF;
          END IF;

          IF    (p_gl_no = 1 AND p_tran_mm = p_finance_end)
             OR (p_gl_no = 2 AND p_tran_mm = p_fiscal_end)
          THEN
             v_new_record3 :=
                   b_rec.gl_acct_id
                || b_rec.gacc_gfun_fund_cd
                || b_rec.gacc_gibr_branch_cd
                || p_tran_year
                || p_tran_mm;

             IF v_new_record3 <> v_fiscal_record
             THEN
                --FOR f IN ( --commented by alfie 06152009
                BEGIN
                   SELECT '1' wan
                     INTO v_fiscal_gl_exists
                     FROM giac_fiscal_yr
                    WHERE gl_acct_id = b_rec.gl_acct_id
                      --AND fund_cd = a_rec.gacc_gfun_fund_cd --
                      AND fund_cd = b_rec.gacc_gfun_fund_cd       --added by alfie
                      --AND branch_cd = a_rec.gacc_gibr_branch_cd --
                      AND branch_cd = b_rec.gacc_gibr_branch_cd                  --
                      AND tran_year = p_tran_year
                      AND tran_mm = p_tran_mm;                            --) LOOP
                -- v_fiscal_gl_exists := f.wan;
                -- EXIT;
                --END LOOP; -- :)
                EXCEPTION
                   WHEN NO_DATA_FOUND
                   THEN
                      v_fiscal_gl_exists := NULL;
                END;

                v_fiscal_record := v_new_record3;
             END IF;

             IF v_fiscal_gl_exists IS NOT NULL
             THEN
                UPDATE giac_fiscal_yr
                   SET trans_debit_bal =
                              NVL (trans_debit_bal, 0)
                              + NVL (v_trans_debit_bal, 0),
                       trans_credit_bal =
                            NVL (trans_credit_bal, 0)
                            + NVL (v_trans_credit_bal, 0),
                       end_debit_amt =
                                NVL (end_debit_amt, 0)
                                + NVL (v_trans_debit_bal, 0),
                       end_credit_amt =
                              NVL (end_credit_amt, 0)
                              + NVL (v_trans_credit_bal, 0),
                       trans_balance =
                            (NVL (end_debit_amt, 0) + NVL (v_trans_debit_bal, 0)
                            )
                          - (NVL (end_credit_amt, 0) + NVL (v_trans_credit_bal, 0)
                            )
                 WHERE gl_acct_id = b_rec.gl_acct_id
                   AND fund_cd = b_rec.gacc_gfun_fund_cd         -- added by alfie
                   --AND fund_cd = a_rec.gacc_gfun_fund_cd --commented by alfie
                   --AND branch_cd = a_rec.gacc_gibr_branch_cd
                   AND branch_cd = b_rec.gacc_gibr_branch_cd                 -- :)
                   AND tran_year = p_tran_year
                   AND tran_mm = p_tran_mm;
             ELSE
                raise_application_error
                   (-20001,
                    'Geniisys Exception#E#This reversing gl not found in giac_fiscal_yr.'
                   );
             END IF;
          --  v_finance_gl_exists := NULL; --commented by alfie 06152009
          --   v_fiscal_gl_exists := NULL; --
          --    v_trans_debit_bal := NULL; --
          --   v_trans_credit_bal := NULL; --
          --v_trans_balance := NULL;       -- ;-)
          END IF;

          v_trans_debit_bal := 0;                                 --alfie 06152009
          v_trans_credit_bal := 0;
          v_trans_balance := 0;
       --  v_debit_amt := 0;
       --   v_credit_amt := 0; ;-)
       END LOOP;

       --END LOOP;
       UPDATE giac_yearend_proc_ctr
          SET process_no = 3
        WHERE tran_year = p_tran_year AND tran_mm = p_tran_mm;

       IF SQL%NOTFOUND
       THEN
          raise_application_error
               (-20001,
                'Geniisys Exception#E#Unable to update giac_yearend_proc_ctr to process 3.'
               );
       END IF;

   END;
   
   PROCEDURE cye_update_giac_finance_yr (
       p_tran_year     IN   NUMBER,
       p_tran_mm       IN   NUMBER,
       p_gl_no         IN   NUMBER,
       p_finance_end   IN   NUMBER,
       p_fiscal_end    IN   NUMBER,
       p_gen_type      IN   giac_modules.generation_type%TYPE,
       p_module_id     IN   giac_modules.module_id%TYPE
   )
   IS
       v_gl_acct_id               giac_acct_entries.gl_acct_id%TYPE;
       v_gl_acct_category         giac_acct_entries.gl_acct_category%TYPE;
       v_gl_control_acct          giac_acct_entries.gl_control_acct%TYPE;
       v_gl_sub_acct_1            giac_acct_entries.gl_sub_acct_1%TYPE;
       v_gl_sub_acct_2            giac_acct_entries.gl_sub_acct_2%TYPE;
       v_gl_sub_acct_3            giac_acct_entries.gl_sub_acct_3%TYPE;
       v_gl_sub_acct_4            giac_acct_entries.gl_sub_acct_4%TYPE;
       v_gl_sub_acct_5            giac_acct_entries.gl_sub_acct_5%TYPE;
       v_gl_sub_acct_6            giac_acct_entries.gl_sub_acct_6%TYPE;
       v_gl_sub_acct_7            giac_acct_entries.gl_sub_acct_7%TYPE;
       v_debit_amt                giac_close_rev_entries_ext.debit_amt%TYPE;
       v_credit_amt               giac_close_rev_entries_ext.credit_amt%TYPE;
       v_bal_finance_exists       VARCHAR2 (1);
       v_bal_fiscal_exists        VARCHAR2 (1);
       v_finance_beg_debit_amt    giac_finance_yr.beg_debit_amt%TYPE;
       v_finance_beg_credit_amt   giac_finance_yr.beg_credit_amt%TYPE;
       v_finance_end_debit_amt    giac_finance_yr.end_debit_amt%TYPE;
       v_finance_end_credit_amt   giac_finance_yr.end_credit_amt%TYPE;
       v_finance_trans_balance    giac_finance_yr.trans_balance%TYPE;
       v_fiscal_beg_debit_amt     giac_fiscal_yr.beg_debit_amt%TYPE;
       v_fiscal_beg_credit_amt    giac_fiscal_yr.beg_credit_amt%TYPE;
       v_fiscal_end_debit_amt     giac_fiscal_yr.end_debit_amt%TYPE;
       v_fiscal_end_credit_amt    giac_fiscal_yr.end_credit_amt%TYPE;
       v_fiscal_trans_balance     giac_fiscal_yr.trans_balance%TYPE;
       v_acct_type                giac_chart_of_accts.acct_type%TYPE;

       CURSOR c_acct_type
       IS
          SELECT acct_type
            FROM giac_chart_of_accts
           WHERE gl_acct_id = v_gl_acct_id;
   BEGIN
       GIACS411_PKG.cye_get_eoy_gl_acct_code (p_tran_mm,
                                 v_gl_acct_id,
                                 v_gl_acct_category,
                                 v_gl_control_acct,
                                 v_gl_sub_acct_1,
                                 v_gl_sub_acct_2,
                                 v_gl_sub_acct_3,
                                 v_gl_sub_acct_4,
                                 v_gl_sub_acct_5,
                                 v_gl_sub_acct_6,
                                 v_gl_sub_acct_7,
                                 p_gl_no,
                                 p_finance_end,
                                 p_fiscal_end,
                                 p_gen_type,
                                 p_module_id
                                );

       FOR a IN (SELECT   gacc_gfun_fund_cd, gacc_gibr_branch_cd, gl_acct_id,
                          SUM (debit_amt) debit_amt, SUM (credit_amt) credit_amt
                     FROM giac_close_rev_entries_ext
                    WHERE gl_acct_id = v_gl_acct_id
                 GROUP BY gacc_gfun_fund_cd, gacc_gibr_branch_cd, gl_acct_id)
       LOOP
          v_debit_amt := a.debit_amt;
          v_credit_amt := a.credit_amt;

          IF p_gl_no IN (1, 2)
          THEN
             IF p_tran_mm = p_finance_end
             THEN
                FOR c IN (SELECT end_debit_amt, end_credit_amt, '1' wan
                            FROM giac_finance_yr
                           WHERE gl_acct_id = v_gl_acct_id
                             AND fund_cd = a.gacc_gfun_fund_cd
                             AND branch_cd = a.gacc_gibr_branch_cd
                             AND tran_year = p_tran_year
                             AND tran_mm = p_tran_mm)
                LOOP
                   v_bal_finance_exists := c.wan;
                   v_finance_beg_debit_amt := NVL (c.end_debit_amt, 0);
                   v_finance_beg_credit_amt := NVL (c.end_credit_amt, 0);
                END LOOP;

                IF v_bal_finance_exists IS NULL
                THEN
                   v_finance_beg_debit_amt := 0;
                   v_finance_beg_credit_amt := 0;
                END IF;

                v_finance_end_debit_amt :=
                            NVL (v_finance_beg_debit_amt, 0)
                            + NVL (v_debit_amt, 0);
                v_finance_end_credit_amt :=
                          NVL (v_finance_beg_credit_amt, 0)
                          + NVL (v_credit_amt, 0);
                v_finance_trans_balance :=
                                v_finance_end_debit_amt - v_finance_end_credit_amt;

                IF v_bal_finance_exists IS NULL
                THEN
                   INSERT INTO giac_finance_yr
                               (gl_acct_id, fund_cd,
                                branch_cd, tran_year, tran_mm,
                                beg_debit_amt,
                                beg_credit_amt, trans_debit_bal,
                                trans_credit_bal, end_debit_amt,
                                end_credit_amt,
                                trans_balance, close_tag, eoy_tag
                               )
                        VALUES (v_gl_acct_id, a.gacc_gfun_fund_cd,
                                a.gacc_gibr_branch_cd, p_tran_year, p_tran_mm,
                                v_finance_beg_debit_amt,
                                v_finance_beg_credit_amt, v_debit_amt,
                                v_credit_amt, v_finance_end_debit_amt,
                                v_finance_end_credit_amt,
                                v_finance_trans_balance, 'Y', 'Y'
                               );
                ELSE
                   --LINA 08292007
                   --select the acct type of the gl_account
                   --if the acct type = 'C' then the trans-bal_amt should be the old tran_BAL_AMT + new trans_bal_amt
                   --else it should be the new trans_bal_amt
                   OPEN c_acct_type;

                   FETCH c_acct_type
                    INTO v_acct_type;

                   IF v_acct_type = 'C'
                   THEN
                      UPDATE giac_finance_yr
                         SET         ----beg_debit_amt = v_finance_beg_debit_amt,
                            ---beg_credit_amt = v_finance_beg_credit_amt,
                            trans_debit_bal =
                                             NVL (trans_debit_bal, 0)
                                             + v_debit_amt,
                            --added the trans_debit_bal lina 08282007
                            trans_credit_bal =
                                           NVL (trans_credit_bal, 0)
                                           + v_credit_amt,
                            --added the trans_credit_bal lina 08282007
                            end_debit_amt = v_finance_end_debit_amt,
                            end_credit_amt = v_finance_end_credit_amt,
                            trans_balance = v_finance_trans_balance,
                            close_tag = 'Y',
                            eoy_tag = 'Y'
                       WHERE gl_acct_id = v_gl_acct_id
                         AND fund_cd = a.gacc_gfun_fund_cd
                         AND branch_cd = a.gacc_gibr_branch_cd
                         AND tran_year = p_tran_year
                         AND tran_mm = p_tran_mm;
                   ELSE
                      UPDATE giac_finance_yr
                         SET        ----beg_debit_amt = v_finance_beg_debit_amt,
                                    ---beg_credit_amt = v_finance_beg_credit_amt,
                            trans_debit_bal = v_debit_amt,
                            trans_credit_bal = v_credit_amt,
                            end_debit_amt = v_finance_end_debit_amt,
                            end_credit_amt = v_finance_end_credit_amt,
                            trans_balance = v_finance_trans_balance,
                            close_tag = 'Y',
                            eoy_tag = 'Y'
                       WHERE gl_acct_id = v_gl_acct_id
                         AND fund_cd = a.gacc_gfun_fund_cd
                         AND branch_cd = a.gacc_gibr_branch_cd
                         AND tran_year = p_tran_year
                         AND tran_mm = p_tran_mm;
                   END IF;

                   CLOSE c_acct_type;
                END IF;

                IF SQL%NOTFOUND
                THEN
                   raise_application_error
                       (-20001,
                        'Geniisys Exception#E#Error inserting into giac_finance_yr.'
                       );
                END IF;
             END IF;
          END IF;

          IF    (p_gl_no = 1 AND p_tran_mm = p_finance_end)
             OR (p_gl_no = 2 AND p_tran_mm = p_fiscal_end)
          THEN
             FOR d IN (SELECT end_debit_amt, end_credit_amt, '1' wan
                         FROM giac_fiscal_yr
                        WHERE gl_acct_id = v_gl_acct_id
                          AND fund_cd = a.gacc_gfun_fund_cd
                          AND branch_cd = a.gacc_gibr_branch_cd
                          AND tran_year = p_tran_year
                          AND tran_mm = p_tran_mm)
             LOOP
                v_bal_fiscal_exists := d.wan;
                v_fiscal_beg_debit_amt := d.end_debit_amt;
                v_fiscal_beg_credit_amt := d.end_credit_amt;
             END LOOP;

             IF v_bal_fiscal_exists IS NULL
             THEN
                v_fiscal_beg_debit_amt := 0;
                v_fiscal_beg_credit_amt := 0;
             END IF;

             v_fiscal_end_debit_amt :=
                             NVL (v_fiscal_beg_debit_amt, 0)
                             + NVL (v_debit_amt, 0);
             v_fiscal_end_credit_amt :=
                           NVL (v_fiscal_beg_credit_amt, 0)
                           + NVL (v_credit_amt, 0);
             v_fiscal_trans_balance :=
                                  v_fiscal_end_debit_amt - v_fiscal_end_credit_amt;

             IF v_bal_fiscal_exists IS NULL
             THEN
                INSERT INTO giac_fiscal_yr
                            (gl_acct_id, fund_cd,
                             branch_cd, tran_year, tran_mm,
                             beg_debit_amt, beg_credit_amt,
                             trans_debit_bal, trans_credit_bal, end_debit_amt,
                             end_credit_amt, trans_balance,
                             close_tag, eof_tag
                            )
                     VALUES (v_gl_acct_id, a.gacc_gfun_fund_cd,
                             a.gacc_gibr_branch_cd, p_tran_year, p_tran_mm,
                             v_fiscal_beg_debit_amt, v_fiscal_beg_credit_amt,
                             v_debit_amt, v_credit_amt, v_fiscal_end_debit_amt,
                             v_fiscal_end_credit_amt, v_fiscal_trans_balance,
                             'Y', 'Y'
                            );
             ELSE
                --lina
                --select the acct type of the gl_account
                --if the acct type = 'C' then the trans-bal_amt should be the old tran_BAL_AMT + new trans_bal_amt
                --else it should be the new trans_bal_amt
                OPEN c_acct_type;

                FETCH c_acct_type
                 INTO v_acct_type;

                IF v_acct_type = 'C'
                THEN
                   UPDATE giac_fiscal_yr
                      SET             --beg_debit_amt = v_fiscal_beg_debit_amt,
                                      --beg_credit_amt = v_fiscal_beg_credit_amt,
                         trans_debit_bal = NVL (trans_debit_bal, 0) + v_debit_amt,
                         --added the trans_debit_bal lina
                         trans_credit_bal =
                                           NVL (trans_credit_bal, 0)
                                           + v_credit_amt,
                         --added the trans_debit_bal lina
                         end_debit_amt = v_fiscal_end_debit_amt,
                         end_credit_amt = v_fiscal_end_credit_amt,
                         trans_balance = v_fiscal_trans_balance,
                         close_tag = 'Y',
                         eof_tag = 'Y'
                    WHERE gl_acct_id = v_gl_acct_id
                      AND fund_cd = a.gacc_gfun_fund_cd
                      AND branch_cd = a.gacc_gibr_branch_cd
                      AND tran_year = p_tran_year
                      AND tran_mm = p_tran_mm;
                ELSE
                   UPDATE giac_fiscal_yr
                      SET             --beg_debit_amt = v_fiscal_beg_debit_amt,
                                      --beg_credit_amt = v_fiscal_beg_credit_amt,
                         trans_debit_bal = v_debit_amt,
                         trans_credit_bal = v_credit_amt,
                         end_debit_amt = v_fiscal_end_debit_amt,
                         end_credit_amt = v_fiscal_end_credit_amt,
                         trans_balance = v_fiscal_trans_balance,
                         close_tag = 'Y',
                         eof_tag = 'Y'
                    WHERE gl_acct_id = v_gl_acct_id
                      AND fund_cd = a.gacc_gfun_fund_cd
                      AND branch_cd = a.gacc_gibr_branch_cd
                      AND tran_year = p_tran_year
                      AND tran_mm = p_tran_mm;
                END IF;

                CLOSE c_acct_type;
             END IF;

             IF SQL%NOTFOUND
             THEN
                raise_application_error
                       (-20001,
                        'Geniisys Exception#E#Error inserting into giac_fiscal_yr.'
                       );
             END IF;
          END IF;

          v_bal_finance_exists := NULL;
          v_bal_fiscal_exists := NULL;
          v_finance_beg_debit_amt := NULL;
          v_finance_beg_credit_amt := NULL;
          v_finance_end_debit_amt := NULL;
          v_finance_end_credit_amt := NULL;
          v_finance_trans_balance := NULL;
          v_fiscal_beg_debit_amt := NULL;
          v_fiscal_beg_credit_amt := NULL;
          v_fiscal_end_debit_amt := NULL;
          v_fiscal_end_credit_amt := NULL;
          v_fiscal_trans_balance := NULL;
       END LOOP;

       UPDATE giac_yearend_proc_ctr
          SET process_no = 4
        WHERE tran_year = p_tran_year AND tran_mm = p_tran_mm;

       IF SQL%NOTFOUND
       THEN
          raise_application_error
               (-20001,
                'Geniisys Exception#E#Unable to update giac_yearend_proc_ctr to process 4.'
               );
       END IF;
   END;
   
   PROCEDURE cye_sum_post_rev_entries (
       p_tran_year     IN   NUMBER,
       p_tran_mm       IN   NUMBER,
       p_gl_no         IN   NUMBER,
       p_finance_end   IN   NUMBER,
       p_fiscal_end    IN   NUMBER,
       p_gen_type      IN   giac_modules.generation_type%TYPE,
       p_user_id       IN   giis_users.user_id%TYPE,
       p_module_id          IN       giac_modules.module_id%TYPE
    )
    IS
       CURSOR a
       IS
          SELECT   gacc_gfun_fund_cd, gacc_gibr_branch_cd, gacc_tran_id,
                   NVL (SUM (debit_amt), 0) - NVL (SUM (credit_amt), 0) net_amt
              FROM giac_close_rev_entries_ext
          GROUP BY gacc_gfun_fund_cd, gacc_gibr_branch_cd, gacc_tran_id;

       v_gl_acct_id               giac_acct_entries.gl_acct_id%TYPE;
       v_gl_acct_category         giac_acct_entries.gl_acct_category%TYPE;
       v_gl_control_acct          giac_acct_entries.gl_control_acct%TYPE;
       v_gl_sub_acct_1            giac_acct_entries.gl_sub_acct_1%TYPE;
       v_gl_sub_acct_2            giac_acct_entries.gl_sub_acct_2%TYPE;
       v_gl_sub_acct_3            giac_acct_entries.gl_sub_acct_3%TYPE;
       v_gl_sub_acct_4            giac_acct_entries.gl_sub_acct_4%TYPE;
       v_gl_sub_acct_5            giac_acct_entries.gl_sub_acct_5%TYPE;
       v_gl_sub_acct_6            giac_acct_entries.gl_sub_acct_6%TYPE;
       v_gl_sub_acct_7            giac_acct_entries.gl_sub_acct_7%TYPE;
       v_tran_class               giac_acctrans.tran_class%TYPE;
       v_particulars              giac_acctrans.particulars%TYPE;
       v_tran_id                  giac_acctrans.tran_id%TYPE;
       v_debit_amt                giac_close_rev_entries_ext.debit_amt%TYPE;
       v_credit_amt               giac_close_rev_entries_ext.credit_amt%TYPE;
       v_acct_entry_id            giac_acct_entries.acct_entry_id%TYPE;
       v_remarks                  giac_acct_entries.remarks%TYPE;
       v_bal_finance_exists       VARCHAR2 (1);
       v_bal_fiscal_exists        VARCHAR2 (1);
       v_finance_beg_debit_amt    giac_finance_yr.beg_debit_amt%TYPE;
       v_finance_beg_credit_amt   giac_finance_yr.beg_credit_amt%TYPE;
       v_finance_end_debit_amt    giac_finance_yr.end_debit_amt%TYPE;
       v_finance_end_credit_amt   giac_finance_yr.end_credit_amt%TYPE;
       v_finance_trans_balance    giac_finance_yr.trans_balance%TYPE;
       v_fiscal_beg_debit_amt     giac_fiscal_yr.beg_debit_amt%TYPE;
       v_fiscal_beg_credit_amt    giac_fiscal_yr.beg_credit_amt%TYPE;
       v_fiscal_end_debit_amt     giac_fiscal_yr.end_debit_amt%TYPE;
       v_fiscal_end_credit_amt    giac_fiscal_yr.end_credit_amt%TYPE;
       v_fiscal_trans_balance     giac_fiscal_yr.trans_balance%TYPE;
    BEGIN
       GIACS411_PKG.cye_get_eoy_gl_acct_code (p_tran_mm,
                                 v_gl_acct_id,
                                 v_gl_acct_category,
                                 v_gl_control_acct,
                                 v_gl_sub_acct_1,
                                 v_gl_sub_acct_2,
                                 v_gl_sub_acct_3,
                                 v_gl_sub_acct_4,
                                 v_gl_sub_acct_5,
                                 v_gl_sub_acct_6,
                                 v_gl_sub_acct_7,
                                 p_gl_no,
                                 p_finance_end,
                                 p_fiscal_end,
                                 p_gen_type,
                                 p_module_id
                                );

       IF p_gl_no = 1
       THEN
          IF p_tran_mm = p_finance_end
          THEN
             v_tran_class := 'EOY';
          END IF;
       END IF;

       v_particulars :=
             'Balancing '
          || v_tran_class
          || ' entry for '
          || TO_CHAR (p_tran_mm)
          || '-'
          || TO_CHAR (p_tran_year)
          || '.';
       v_remarks :=
             'Balancing '
          || v_tran_class
          || ' for '
          || TO_CHAR (p_tran_mm)
          || '-'
          || TO_CHAR (p_tran_year)
          || '.';

       FOR a_rec IN a
       LOOP
          -- balancing entry so debit becomes credit  versa.
          IF SIGN (NVL (a_rec.net_amt, 0)) = 1
          THEN
             v_debit_amt := 0;
             v_credit_amt := a_rec.net_amt;
          ELSIF SIGN (NVL (a_rec.net_amt, 0)) = -1
          THEN
             v_debit_amt := ABS (a_rec.net_amt);
             v_credit_amt := 0;
          ELSIF SIGN (NVL (a_rec.net_amt, 0)) = 0
          THEN
             v_debit_amt := 0;
             v_credit_amt := 0;
          END IF;

          BEGIN
             SELECT NVL (MAX (a.acct_entry_id), 0) acct_entry_id
               INTO v_acct_entry_id
               FROM giac_close_rev_entries_ext a
              WHERE a.gacc_tran_id = a_rec.gacc_tran_id
                AND a.gacc_gibr_branch_cd = a_rec.gacc_gibr_branch_cd
                AND a.gacc_gfun_fund_cd = a_rec.gacc_gfun_fund_cd
                AND a.generation_type = p_gen_type
                AND a.gl_acct_id = v_gl_acct_id;

             IF NVL (v_acct_entry_id, 0) = 0
             THEN
                BEGIN
                   SELECT NVL (MAX (a.acct_entry_id), 0) acct_entry_id
                     INTO v_acct_entry_id
                     FROM giac_close_rev_entries_ext a
                    WHERE a.gacc_tran_id = a_rec.gacc_tran_id;
                END;

                v_acct_entry_id := NVL (v_acct_entry_id, 0) + 1;

                INSERT INTO giac_close_rev_entries_ext
                            (gacc_tran_id, gacc_gfun_fund_cd,
                             gacc_gibr_branch_cd, acct_entry_id,
                             gl_acct_id, gl_acct_category, gl_control_acct,
                             gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3,
                             gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6,
                             gl_sub_acct_7, debit_amt, credit_amt,
                             generation_type, user_id, last_update, remarks
                            )
                     VALUES (a_rec.gacc_tran_id, a_rec.gacc_gfun_fund_cd,
                             a_rec.gacc_gibr_branch_cd, v_acct_entry_id,
                             v_gl_acct_id, v_gl_acct_category, v_gl_control_acct,
                             v_gl_sub_acct_1, v_gl_sub_acct_2, v_gl_sub_acct_3,
                             v_gl_sub_acct_4, v_gl_sub_acct_5, v_gl_sub_acct_6,
                             v_gl_sub_acct_7, v_debit_amt, v_credit_amt,
                             p_gen_type, p_user_id, SYSDATE, v_remarks
                            );
             ELSE
                UPDATE giac_close_rev_entries_ext a
                   SET debit_amt = debit_amt + v_debit_amt,
                       credit_amt = credit_amt + v_credit_amt
                 WHERE a.gacc_tran_id = a_rec.gacc_tran_id
                   AND a.gacc_gibr_branch_cd = a_rec.gacc_gibr_branch_cd
                   AND a.gacc_gfun_fund_cd = a_rec.gacc_gfun_fund_cd
                   AND a.generation_type = p_gen_type
                   AND a.gl_acct_id = v_gl_acct_id;
             END IF;
          END;
       END LOOP;
    END;
    
    -- process 5.
    PROCEDURE cye_insert_acct_entries (
        p_tran_year IN NUMBER, 
        p_tran_mm   IN NUMBER
        )
    IS
       CURSOR a
       IS
          SELECT DISTINCT gacc_tran_id, generation_type
                     FROM giac_close_rev_entries_ext;

       v_exists   VARCHAR2 (1);

       CURSOR c
       IS
          SELECT gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd,
                 acct_entry_id, gl_acct_id, gl_acct_category, gl_control_acct,
                 gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4,
                 gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7, user_id,
                 last_update, sl_cd, debit_amt, credit_amt, generation_type,
                 remarks, sl_type_cd, sl_source_cd
            FROM giac_close_rev_entries_ext;
    BEGIN
       /*FOR a_rec IN a LOOP
         FOR b IN (SELECT '1' wan
                     FROM giac_acct_entries
                     WHERE gacc_tran_id = a_rec.gacc_tran_id
                     AND generation_type = a_rec.generation_type) LOOP
           v_exists := b.wan;
           EXIT;
         END LOOP;

         IF v_exists IS NOT NULL THEN
           msg_alert('Data with the same gacc_tran_id and ' ||
                     'generation_type exists in giac_acct_entries.',
                     'E', TRUE);
         END IF;
       END LOOP;*/
       FOR c_rec IN c
       LOOP
          INSERT INTO giac_acct_entries
                      (gacc_tran_id, gacc_gfun_fund_cd,
                       gacc_gibr_branch_cd, acct_entry_id,
                       gl_acct_id, gl_acct_category,
                       gl_control_acct, gl_sub_acct_1,
                       gl_sub_acct_2, gl_sub_acct_3,
                       gl_sub_acct_4, gl_sub_acct_5,
                       gl_sub_acct_6, gl_sub_acct_7, user_id,
                       last_update, sl_cd, debit_amt,
                       credit_amt, generation_type, remarks,
                       sl_type_cd, sl_source_cd
                      )
               VALUES (c_rec.gacc_tran_id, c_rec.gacc_gfun_fund_cd,
                       c_rec.gacc_gibr_branch_cd, c_rec.acct_entry_id,
                       c_rec.gl_acct_id, c_rec.gl_acct_category,
                       c_rec.gl_control_acct, c_rec.gl_sub_acct_1,
                       c_rec.gl_sub_acct_2, c_rec.gl_sub_acct_3,
                       c_rec.gl_sub_acct_4, c_rec.gl_sub_acct_5,
                       c_rec.gl_sub_acct_6, c_rec.gl_sub_acct_7, c_rec.user_id,
                       c_rec.last_update, c_rec.sl_cd, c_rec.debit_amt,
                       c_rec.credit_amt, c_rec.generation_type, c_rec.remarks,
                       c_rec.sl_type_cd, c_rec.sl_source_cd
                      );
       END LOOP;

       UPDATE giac_yearend_proc_ctr
          SET process_no = 5
        WHERE tran_year = p_tran_year AND tran_mm = p_tran_mm;

       IF SQL%NOTFOUND
       THEN
          raise_application_error
             (-20001,
              'Geniisys Exception#E#Unable to update giac_yearend_proc_ctr to process 5.'
             );
       END IF;
    END;
    
    PROCEDURE cye_create_acctrans_record (
       p_tran_year     IN       NUMBER,
       p_tran_mm       IN       NUMBER,
       p_fund_cd       IN       giac_close_acct_entries_ext.gacc_gfun_fund_cd%TYPE,
       p_branch_cd     IN       giac_close_acct_entries_ext.gacc_gibr_branch_cd%TYPE,
       p_particulars   IN       giac_acctrans.particulars%TYPE,
       p_tran_class    IN       giac_acctrans.tran_class%TYPE,
       p_tran_id       OUT      giac_acctrans.tran_id%TYPE,
       p_user_id       IN       GIIS_USERS.user_id%TYPE
    )
    IS
       v_tran_date       giac_acctrans.tran_date%TYPE;
       v_tran_seq_no     giac_acctrans.tran_seq_no%TYPE;
       v_tran_class_no   giac_acctrans.tran_class_no%TYPE;
       v_particulars     giac_acctrans.particulars%TYPE;
    BEGIN
       BEGIN
          SELECT acctran_tran_id_s.NEXTVAL
            INTO p_tran_id
            FROM DUAL;
       EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
             raise_application_error
                      (-20001,
                       'Geniisys Exception#E#ACCTRAN_TRAN_ID sequence not found.'
                      );
       END;

       v_tran_date :=
          LAST_DAY (TO_DATE (TO_CHAR (p_tran_mm, 'fm09') || TO_CHAR (p_tran_year),
                             'MMYYYY'
                            )
                   );
       v_tran_seq_no :=
          giac_sequence_generation (p_fund_cd,
                                    p_branch_cd,
                                    'ACCTRAN_TRAN_SEQ_NO',
                                    p_tran_year,
                                    p_tran_mm
                                   );
       v_tran_class_no :=
          giac_sequence_generation (p_fund_cd,
                                    p_branch_cd,
                                    p_tran_class,
                                    p_tran_year,
                                    p_tran_mm
                                   );

       INSERT INTO giac_acctrans
                   (tran_id, gfun_fund_cd, gibr_branch_cd, tran_date, tran_flag,
                    user_id, last_update, tran_year, tran_month, tran_seq_no,
                    tran_class, tran_class_no, particulars, posting_date
                   )
            VALUES (p_tran_id, p_fund_cd, p_branch_cd, v_tran_date, 'P',
                    p_user_id, SYSDATE, p_tran_year, p_tran_mm, v_tran_seq_no,
                    p_tran_class, v_tran_class_no, p_particulars, v_tran_date
                   );

       IF SQL%NOTFOUND
       THEN
          raise_application_error
                          (-20001,
                           'Geniisys Exception#E#Unable to insert into acctrans.'
                          );
       END IF;
    END;
    
    PROCEDURE cye_get_eoy_gl_acct_code (
       p_tran_mm            IN       NUMBER,
       p_gl_acct_id         OUT      giac_acct_entries.gl_acct_id%TYPE,
       p_gl_acct_category   OUT      giac_acct_entries.gl_acct_category%TYPE,
       p_gl_control_acct    OUT      giac_acct_entries.gl_control_acct%TYPE,
       p_gl_sub_acct_1      OUT      giac_acct_entries.gl_sub_acct_1%TYPE,
       p_gl_sub_acct_2      OUT      giac_acct_entries.gl_sub_acct_2%TYPE,
       p_gl_sub_acct_3      OUT      giac_acct_entries.gl_sub_acct_3%TYPE,
       p_gl_sub_acct_4      OUT      giac_acct_entries.gl_sub_acct_4%TYPE,
       p_gl_sub_acct_5      OUT      giac_acct_entries.gl_sub_acct_5%TYPE,
       p_gl_sub_acct_6      OUT      giac_acct_entries.gl_sub_acct_6%TYPE,
       p_gl_sub_acct_7      OUT      giac_acct_entries.gl_sub_acct_7%TYPE,
       p_gl_no              IN       NUMBER,
       p_finance_end        IN       NUMBER,
       p_fiscal_end         IN       NUMBER,
       p_gen_type           IN       giac_modules.generation_type%TYPE,
       p_module_id          IN       giac_modules.module_id%TYPE
    )
    IS
       v_item_no   giac_module_entries.item_no%TYPE;
    BEGIN
       IF p_gl_no = 1
       THEN
          v_item_no := 2;
       ELSIF p_gl_no = 2
       THEN
          IF p_tran_mm = p_fiscal_end
          THEN
             v_item_no := 1;
          ELSIF p_tran_mm = p_finance_end
          THEN
             v_item_no := 2;
          END IF;
       END IF;

       BEGIN
          SELECT gl_acct_category, gl_control_acct, gl_sub_acct_1,
                 gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4,
                 gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7
            INTO p_gl_acct_category, p_gl_control_acct, p_gl_sub_acct_1,
                 p_gl_sub_acct_2, p_gl_sub_acct_3, p_gl_sub_acct_4,
                 p_gl_sub_acct_5, p_gl_sub_acct_6, p_gl_sub_acct_7
            FROM giac_module_entries
           WHERE module_id = p_module_id AND item_no = v_item_no;
       EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
             raise_application_error
                    (-20001,
                     'Geniisys Exception#E#No data found in giac_module_entries.'
                    );
       END;

       BEGIN
          SELECT DISTINCT gl_acct_id
                     INTO p_gl_acct_id
                     FROM giac_chart_of_accts
                    WHERE gl_acct_category = p_gl_acct_category
                      AND gl_control_acct = p_gl_control_acct
                      AND gl_sub_acct_1 = p_gl_sub_acct_1
                      AND gl_sub_acct_2 = p_gl_sub_acct_2
                      AND gl_sub_acct_3 = p_gl_sub_acct_3
                      AND gl_sub_acct_4 = p_gl_sub_acct_4
                      AND gl_sub_acct_5 = p_gl_sub_acct_5
                      AND gl_sub_acct_6 = p_gl_sub_acct_6
                      AND gl_sub_acct_7 = p_gl_sub_acct_7
                      AND leaf_tag = 'Y';
       EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
             BEGIN
                raise_application_error
                                      (-20001,
                                          'Geniisys Exception#E#GL account code '
                                       || TO_CHAR (p_gl_acct_category)
                                       || '-'
                                       || TO_CHAR (p_gl_control_acct, '09')
                                       || '-'
                                       || TO_CHAR (p_gl_sub_acct_1, '09')
                                       || '-'
                                       || TO_CHAR (p_gl_sub_acct_2, '09')
                                       || '-'
                                       || TO_CHAR (p_gl_sub_acct_3, '09')
                                       || '-'
                                       || TO_CHAR (p_gl_sub_acct_4, '09')
                                       || '-'
                                       || TO_CHAR (p_gl_sub_acct_5, '09')
                                       || '-'
                                       || TO_CHAR (p_gl_sub_acct_6, '09')
                                       || '-'
                                       || TO_CHAR (p_gl_sub_acct_7, '09')
                                       || ' does not exist in giac_chart_of_accts.'
                                      );
             END;
       END;
    END;
END;
/


