CREATE OR REPLACE PACKAGE BODY CPI.csv_brdrx_dynamic
AS
   FUNCTION csv_giclr206le_dynsql (
      p_session_id   VARCHAR2, 
      p_claim_id     VARCHAR2, 
      p_intm_break   NUMBER, 
      p_paid_date    VARCHAR2, 
      p_from_date    VARCHAR2, 
      p_to_date      VARCHAR2
   )
      RETURN csv_dynamicsql_tab PIPELINED
   IS
      v_query       LONG             := '';
      v_query1      VARCHAR2 (4000);
      v_query2      VARCHAR2 (4000);
      v_query3      VARCHAR2 (4000);
      v_query4      VARCHAR2 (4000);
      v_query5      VARCHAR2 (4000);
      v_query6      VARCHAR2 (4000);
      v_query7      VARCHAR2 (4000);
      v_query8      VARCHAR2 (4000);
      v_dyn_query   csv_dynamicsql;
      v_line        VARCHAR2 (32000);
      v_line2       VARCHAR2 (32000);
   BEGIN
      FOR a IN (SELECT DISTINCT a.share_cd, a.trty_name
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no 
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id 
                            --AND NVL (b.losses_paid, 0) > 0  --Dren 11.24.2015 SR-0020508 : Discrepancy in Losses Paid in Brdx Report. 
                            AND a.share_cd IN (1, 999)
                       ORDER BY a.share_cd)
      LOOP
         v_line := v_line || ', SUM(DECODE(grp_seq_no, ' || a.share_cd || ', ds_loss, 0)) "' || a.trty_name || '"';
      END LOOP;

      FOR b IN (SELECT DISTINCT a.share_cd, NVL (a.trty_name, '        ') trty_name, a.line_cd
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no 
                            AND a.line_cd = b.line_cd 
                            AND b.session_id = p_session_id 
                            --AND NVL (b.losses_paid, 0) > 0  --Dren 11.24.2015 SR-0020508 : Discrepancy in Losses Paid in Brdx Report.
                            AND a.share_cd NOT IN (1, 999)
                       ORDER BY a.share_cd)
      LOOP
         v_line := v_line || ', SUM(DECODE(grp_seq_no||''-''||line_cd, ''' || b.share_cd || '-' || b.line_cd || ''', ds_loss, 0)) "' || b.trty_name || '"';
      END LOOP;

      FOR c IN (SELECT DISTINCT a.share_cd, a.trty_name
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no 
                            AND a.line_cd = b.line_cd 
                            AND b.session_id = p_session_id 
                            --AND NVL (b.expenses_paid, 0) > 0  --Dren 11.24.2015 SR-0020508 : Discrepancy in Losses Paid in Brdx Report.
                            AND a.share_cd IN (1, 999)
                       ORDER BY a.share_cd)
      LOOP
         v_line2 := v_line2 || ', SUM(DECODE(grp_seq_no, ' || c.share_cd || ', ds_expense, 0)) "' || c.trty_name || '"';
      END LOOP;

      FOR d IN (SELECT DISTINCT a.share_cd, NVL (a.trty_name, '        ') trty_name, a.line_cd
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no 
                            AND a.line_cd = b.line_cd 
                            AND b.session_id = p_session_id 
                            --AND NVL (b.expenses_paid, 0) > 0  --Dren 11.24.2015 SR-0020508 : Discrepancy in Losses Paid in Brdx Report.
                            AND a.share_cd NOT IN (1, 999) 
                       ORDER BY a.share_cd)
      LOOP
         v_line2 := v_line2 || ', SUM(DECODE(grp_seq_no||''-''||line_cd, ''' || d.share_cd || '-' || d.line_cd || ''', ds_expense, 0)) "' || d.trty_name || '"';
      END LOOP;

      v_query :=
            'SELECT buss_source_name "BUSINESS SOURCE", source_name "SOURCE NAME", iss_name "ISSUE SOURCE", line_name "LINE", 
             subline_name "SUBLINE", loss_year "LOSS YEAR", claim_no "CLAIM NUMBER", policy_no "POLICY NUMBER", 
             assd_name "ASSURED", incept_date "INCEPT DATE", expiry_date "EXPIRY DATE", loss_date "DATE OF LOSS", 
             item_title "ITEM", tsi_amt "TOTAL SUM INSURED", peril_name "PERIL", loss_cat_des "LOSS CATEGORY", intermediary "INTERMEDIARY", 
             voucher_no_check_no_loss "VOUCHER NUMBER" , SUM(DS_LOSS) "LOSSES PAID" ' --Dren 11.23.2015 SR-0020508 : Discrepancy in Losses Paid in Brdx Report. - Start 
             --voucher_no_check_no_loss "VOUCHER NUMBER" , SUM(losses_paid) "LOSSES PAID" ' 
         || v_line
         || ', 
             voucher_no_check_no_exp "VOUCHER NUMBER" , SUM(DS_EXPENSE) "EXPENSES PAID"'
             --voucher_no_check_no_exp "VOUCHER NUMBER" , SUM(expenses_paid) "EXPENSES PAID"'  --Dren 11.23.2015 SR-0020508 : Discrepancy in Losses Paid in Brdx Report. - End
         || v_line2
         ||                                                                                                                          
            ' FROM TABLE(CSV_BRDRX.CSV_GICLR206LE('''
         || p_session_id
         || ''','''
         || p_claim_id
         || ''','''
         || p_intm_break
         || ''','''
         || p_paid_date
         || ''','''
         || p_from_date
         || ''','''
         || p_to_date
         || '''))
     GROUP BY buss_source_name, source_name, iss_name, line_name, subline_name, loss_year,
              claim_no, policy_no, assd_name, incept_date, expiry_date, loss_date, item_title,
              tsi_amt, peril_name, loss_cat_des, intermediary, item_no, peril_cd, claim_id, voucher_no_check_no_loss, voucher_no_check_no_exp ORDER BY claim_no';
      v_dyn_query.query1 := SUBSTR (v_query, 1, 4000); --koks 9.18.15 change values to 4000
      v_dyn_query.query2 := SUBSTR (v_query, 4001, 4000);
      v_dyn_query.query3 := SUBSTR (v_query, 8001, 4000);
      v_dyn_query.query4 := SUBSTR (v_query, 12001, 4000);
      v_dyn_query.query5 := SUBSTR (v_query, 16001, 4000);
      v_dyn_query.query6 := SUBSTR (v_query, 20001, 4000);
      v_dyn_query.query7 := SUBSTR (v_query, 24001, 4000);
      v_dyn_query.query8 := SUBSTR (v_query, 28001, 4000);
      PIPE ROW (v_dyn_query);
      RETURN;
   END csv_giclr206le_dynsql;
   
   FUNCTION csv_giclr205le_dynsql (p_session_id VARCHAR2, p_claim_id VARCHAR2, p_intm_break NUMBER)
      RETURN csv_dynamicsql_tab PIPELINED
   IS
      v_query       LONG             := '';
      v_query1      VARCHAR2 (4000);
      v_query2      VARCHAR2 (4000);
      v_query3      VARCHAR2 (4000);
      v_query4      VARCHAR2 (4000);
      v_query5      VARCHAR2 (4000);
      v_query6      VARCHAR2 (4000);
      v_query7      VARCHAR2 (4000);
      v_query8      VARCHAR2 (4000);
      v_dyn_query   csv_dynamicsql;
      v_line        VARCHAR2 (32000);
      v_line2       VARCHAR2 (32000);
   BEGIN
      FOR a IN (SELECT DISTINCT a.share_cd, a.trty_name
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no 
                            AND a.line_cd = b.line_cd 
                            AND b.session_id = p_session_id 
                            AND (NVL (b.loss_reserve, 0) - NVL (b.losses_paid, 0)) > 0 
                            AND a.share_cd IN (1, 999)
                       ORDER BY a.share_cd)
      LOOP
         v_line := v_line || ', SUM(DECODE(grp_seq_no, ' || a.share_cd || ', ds_loss, 0)) "' || a.trty_name || '"';
      END LOOP;

      FOR b IN (SELECT DISTINCT a.share_cd, NVL (a.trty_name, '        ') trty_name, a.line_cd
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no 
                            AND a.line_cd = b.line_cd 
                            AND b.session_id = p_session_id 
                            AND (NVL (b.loss_reserve, 0) - NVL (b.losses_paid, 0)) > 0
                            AND a.share_cd NOT IN (1, 999)
                       ORDER BY a.share_cd)
      LOOP
         v_line := v_line || ', SUM(DECODE(grp_seq_no||''-''||line_cd, ''' || b.share_cd || '-' || b.line_cd || ''', ds_loss, 0)) "' || b.trty_name || '"';
      END LOOP;

      FOR c IN (SELECT DISTINCT a.share_cd, a.trty_name
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no 
                            AND a.line_cd = b.line_cd 
                            AND b.session_id = p_session_id 
                            AND (NVL (b.expense_reserve, 0) - NVL (b.expenses_paid, 0)) > 0
                            AND a.share_cd IN (1, 999)
                       ORDER BY a.share_cd)
      LOOP
         v_line2 := v_line2 || ', SUM(DECODE(grp_seq_no, ' || c.share_cd || ', ds_expense, 0)) "' || c.trty_name || '"';
      END LOOP;

      FOR d IN (SELECT DISTINCT a.share_cd, NVL (a.trty_name, '        ') trty_name, a.line_cd
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND (NVL (b.expense_reserve, 0) - NVL (b.expenses_paid, 0)) > 0
                            AND a.share_cd NOT IN (1, 999)
                       ORDER BY a.share_cd)
      LOOP
         v_line2 := v_line2 || ', SUM(DECODE(grp_seq_no||''-''||line_cd, ''' || d.share_cd || '-' || d.line_cd || ''', ds_expense, 0)) "' || d.trty_name || '"';
      END LOOP;

      v_query :=
            'SELECT buss_source_name "BUSINESS SOURCE", source_name "SOURCE NAME", iss_name "ISSUE SOURCE", 
                            line_name "LINE", subline_name "SUBLINE", loss_year "LOSS YEAR", claim_no "CLAIM NUMBER", 
                            policy_no "POLICY NUMBER", assd_name "ASSURED", incept_date "INCEPT DATE", 
                            expiry_date "EXPIRY DATE", loss_date "DATE OF LOSS", item_title "ITEM",
                            tsi_amt "TOTAL SUM INSURED", peril_name "PERIL", loss_cat_des "LOSS CATEGORY",
                                                                 intermediary "INTERMEDIARY", 
                            SUM(outstanding_loss) "OUTSTANDING LOSS"'
         || v_line
         || ', SUM(outstanding_expense) "OUTSTANDING EXPENSE"'
         || v_line2
         || ' FROM TABLE(CSV_BRDRX.CSV_GICLR205LE('''
         || p_session_id
         || ''','''
         || p_claim_id
         || ''','''
         || p_intm_break
         || '''))
                     GROUP BY buss_source_name, source_name, iss_name, line_name, subline_name, loss_year,
                              claim_no, policy_no, assd_name, incept_date, expiry_date, loss_date, item_title,
                              tsi_amt, peril_name, loss_cat_des, intermediary, item_no, peril_cd, claim_id ORDER BY claim_no';
      v_dyn_query.query1 := SUBSTR (v_query, 1, 4000); --koks 9.18.15 change values to 4000
      v_dyn_query.query2 := SUBSTR (v_query, 4001, 4000);
      v_dyn_query.query3 := SUBSTR (v_query, 8001, 4000);
      v_dyn_query.query4 := SUBSTR (v_query, 12001, 4000);
      v_dyn_query.query5 := SUBSTR (v_query, 16001, 4000);
      v_dyn_query.query6 := SUBSTR (v_query, 20001, 4000);
      v_dyn_query.query7 := SUBSTR (v_query, 24001, 4000);
      v_dyn_query.query8 := SUBSTR (v_query, 28001, 4000);
      PIPE ROW (v_dyn_query);
      RETURN;
   END csv_giclr205le_dynsql;
   
   FUNCTION csv_giclr222l_dynsql (
      p_session_id    GICL_RES_BRDRX_DS_EXTR.SESSION_ID%type,
      p_claim_id      VARCHAR2,
      p_paid_date     NUMBER,
      p_from_date     DATE,
      p_to_date       DATE
   )
      RETURN csv_dynamicsql_tab PIPELINED
   IS
      v_query       LONG             := '';
      v_query1      VARCHAR2 (4000);
      v_query2      VARCHAR2 (4000);
      v_query3      VARCHAR2 (4000);
      v_query4      VARCHAR2 (4000);
      v_query5      VARCHAR2 (4000);
      v_query6      VARCHAR2 (4000);
      v_query7      VARCHAR2 (4000);
      v_query8      VARCHAR2 (4000);
      v_dyn_query   csv_dynamicsql;
      v_line        VARCHAR2 (32000);
      amount_format VARCHAR2 (20) := '999,999,999,999.99';
   BEGIN
      FOR c IN (SELECT DISTINCT a.share_cd, a.trty_name
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no 
                            AND a.line_cd = b.line_cd 
                            AND b.session_id = p_session_id
                            AND a.share_cd IN (1, 999)
                       ORDER BY a.share_cd)
      LOOP
         v_line := v_line || ', TO_CHAR(SUM(DECODE(grp_seq_no, ' || c.share_cd || ', ds_loss, 0)),'''||amount_format||''') "' || c.trty_name || '"';
      END LOOP;

      FOR d IN (SELECT DISTINCT a.share_cd, NVL (a.trty_name, '        ') trty_name, a.line_cd
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND a.share_cd NOT IN (1, 999)
                       ORDER BY a.share_cd)
      LOOP
         v_line := v_line || ', TO_CHAR(SUM(DECODE(grp_seq_no||''-''||line_cd, ''' || d.share_cd || '-' || d.line_cd || ''', ds_loss, 0)),'''||amount_format||''') "' || d.trty_name || '"';
      END LOOP;
      
      v_query := 'SELECT policy_no " POLICY", assd_name "ASSURED", term, claim_no "CLAIM NO", TO_CHAR(loss_date,''MM-DD-YYYY'') "LOSS DATE", item_title "ITEM", 
                         TO_CHAR(tsi_amt,'''||amount_format||''') "TOTAL SUM INSURED", peril_name "LOSS CATEGORY",
                         intermediary "INTERMEDIARY / CEDANT", voucher_no_check_no "VOUCHER NO / CHECK NO",
                         TO_CHAR(SUM(losses_paid),'''||amount_format||''') "LOSSES PAID"' 
                         || v_line
                         || ' FROM TABLE(CSV_BRDRX.CSV_GICLR222L('''
                         || p_session_id
                         || ''','''
                         || p_claim_id
                         || ''','''
                         || p_paid_date
                         || ''','''
                         || p_from_date
                         || ''','''
                         || p_to_date
                         || '''))
                         GROUP BY policy_no, assd_name, term, claim_no, loss_date, item_title, tsi_amt, peril_name, intermediary, voucher_no_check_no, item_no     
                         ORDER BY policy_no, claim_no, item_no';
      v_dyn_query.query1 := SUBSTR (v_query, 1, 4000);
      v_dyn_query.query2 := SUBSTR (v_query, 4001, 4000);
      v_dyn_query.query3 := SUBSTR (v_query, 8001, 4000);
      v_dyn_query.query4 := SUBSTR (v_query, 12001, 4000);
      v_dyn_query.query5 := SUBSTR (v_query, 16001, 4000);
      v_dyn_query.query6 := SUBSTR (v_query, 20001, 4000);
      v_dyn_query.query7 := SUBSTR (v_query, 24001, 4000);
      v_dyn_query.query8 := SUBSTR (v_query, 28001, 4000);
      PIPE ROW (v_dyn_query);
      RETURN;
   END csv_giclr222l_dynsql;

   FUNCTION csv_giclr221le(
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_paid_date    VARCHAR2,
      p_from_date2   VARCHAR2,
      p_to_date2     VARCHAR2
   ) RETURN csv_dynamicsql_tab PIPELINED
   IS
      v_query       LONG             := '';
      v_dyn_query   csv_dynamicsql;
      v_line        VARCHAR2 (32000);
      v_line2       VARCHAR2 (32000);
      amount_format VARCHAR2 (20) := '999,999,999,999.99';
   BEGIN
      FOR a IN (SELECT DISTINCT a.share_cd, a.trty_name
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no 
                            AND a.line_cd = b.line_cd 
                            AND b.session_id = p_session_id 
                            AND a.share_cd IN (1, 999)
                       ORDER BY a.share_cd)
      LOOP
         v_line := v_line || ', TO_CHAR(SUM(DECODE(grp_seq_no, ' || a.share_cd || ', ds_loss, 0)),'''||amount_format||''') "' || a.trty_name || '"';
      END LOOP;

      FOR b IN (SELECT DISTINCT a.share_cd, NVL (a.trty_name, '        ') trty_name, a.line_cd
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no 
                            AND a.line_cd = b.line_cd 
                            AND b.session_id = p_session_id 
                            AND a.share_cd NOT IN (1, 999)
                       ORDER BY a.share_cd)
      LOOP
         v_line := v_line || ', TO_CHAR(SUM(DECODE(grp_seq_no||''-''||line_cd, ''' || b.share_cd || '-' || b.line_cd || ''', ds_loss, 0)),'''||amount_format||''') "' || b.trty_name || '"';
      END LOOP;

      FOR c IN (SELECT DISTINCT a.share_cd, a.trty_name
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no 
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id 
                            AND a.share_cd IN (1, 999)
                       ORDER BY a.share_cd)
      LOOP
         v_line2 := v_line2 || ', TO_CHAR(SUM(DECODE(grp_seq_no, ' || c.share_cd || ', ds_expense, 0)),'''||amount_format||''') "' || c.trty_name || '"';
      END LOOP;

      FOR d IN (SELECT DISTINCT a.share_cd, NVL (a.trty_name, '        ') trty_name, a.line_cd
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND a.share_cd NOT IN (1, 999)
                       ORDER BY a.share_cd)
      LOOP
         v_line2 := v_line2 || ', TO_CHAR(SUM(DECODE(grp_seq_no||''-''||line_cd, ''' || d.share_cd || '-' || d.line_cd || ''', ds_expense, 0)),'''||amount_format||''') "' || d.trty_name || '"';
      END LOOP;
      
      v_query := 'SELECT enrollee, claim_no "CLAIM NO", policy_no "POLICY NUMBER", assd_name "ASSURED", term, TO_CHAR(loss_date,''MM-DD-YYYY'') "LOSS DATE", item_title "ITEM", 
                            TO_CHAR(tsi_amt,'''||amount_format||''') "TOTAL SUM INSURED", loss_cat_des "LOSS CATEGORY", intermediary "INTERMEDIARY / CEDANT", 
                            voucher_no_check_no_le "VOUCHER NO / CHECK NO", TO_CHAR(SUM(losses_paid),'''||amount_format||''') "PAID LOSS" '
         || v_line
         || ', TO_CHAR(SUM(expenses_paid),'''||amount_format||''') "PAID EXPENSE" '
         || v_line2
         || ' FROM TABLE(CSV_BRDRX.CSV_GICLR221LE('''
         || p_session_id
         || ''','''
         || p_claim_id
         || ''','''
         || p_paid_date
         || ''','''
         || p_from_date2
         || ''','''
         || p_to_date2
         || ''')) 
            GROUP BY enrollee, claim_no, policy_no, assd_name, term, loss_date, item_title, tsi_amt, loss_cat_des, intermediary,
                     voucher_no_check_no_le ORDER BY enrollee, claim_no, item_title, TO_CHAR(SUM(expenses_paid),'''||amount_format||'''), 
                     TO_CHAR(SUM(losses_paid),'''||amount_format||''')';
      v_dyn_query.query1 := SUBSTR (v_query, 1, 4000);
      v_dyn_query.query2 := SUBSTR (v_query, 4001, 4000);
      v_dyn_query.query3 := SUBSTR (v_query, 8001, 4000);
      v_dyn_query.query4 := SUBSTR (v_query, 12001, 4000);
      v_dyn_query.query5 := SUBSTR (v_query, 16001, 4000);
      v_dyn_query.query6 := SUBSTR (v_query, 20001, 4000);
      v_dyn_query.query7 := SUBSTR (v_query, 24001, 4000);
      v_dyn_query.query8 := SUBSTR (v_query, 28001, 4000);
      PIPE ROW (v_dyn_query);
      RETURN;
   END csv_giclr221le;
   
   FUNCTION csv_giclr221l_dynsql (
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_paid_date    VARCHAR2,
      p_from_date2   VARCHAR2,
      p_to_date2     VARCHAR2
   )
      RETURN csv_dynamicsql_tab PIPELINED
   IS
      v_query       LONG             := '';
      v_query1      VARCHAR2 (4000);
      v_query2      VARCHAR2 (4000);
      v_query3      VARCHAR2 (4000);
      v_query4      VARCHAR2 (4000);
      v_query5      VARCHAR2 (4000);
      v_query6      VARCHAR2 (4000);
      v_query7      VARCHAR2 (4000);
      v_query8      VARCHAR2 (4000);
      v_dyn_query   csv_dynamicsql;
      v_line        VARCHAR2 (32000);
      v_line2       VARCHAR2 (32000);
   BEGIN
      FOR a IN (SELECT DISTINCT a.share_cd, a.trty_name
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no 
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id 
                            --AND NVL (b.losses_paid, 0) > 0  --Dren 11.24.2015 SR-0020508 : Discrepancy in Losses Paid in Brdx Report. 
                            AND a.share_cd IN (1, 999)
                       ORDER BY a.share_cd)
      LOOP
         v_line := v_line || ', TO_CHAR(SUM(DECODE(grp_seq_no, ' || a.share_cd || ', ds_loss, 0)), ''9,999,999,999.99'') "' || a.trty_name || '"';
      END LOOP;

      FOR b IN (SELECT DISTINCT a.share_cd, NVL (a.trty_name, '        ') trty_name, a.line_cd
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no 
                            AND a.line_cd = b.line_cd 
                            AND b.session_id = p_session_id 
                            --AND NVL (b.losses_paid, 0) > 0  --Dren 11.24.2015 SR-0020508 : Discrepancy in Losses Paid in Brdx Report.
                            AND a.share_cd NOT IN (1, 999)
                       ORDER BY a.share_cd)
      LOOP
         v_line := v_line || ', TO_CHAR(SUM(DECODE(grp_seq_no||''-''||line_cd, ''' || b.share_cd || '-' || b.line_cd || ''', ds_loss, 0)), ''9,999,999,999.99'') "' || b.trty_name || '"';
      END LOOP;
      
      v_query :=
            'SELECT enrollee "ENROLLEE", claim_no "CLAIM NO", policy_no "POLICY NO", assd_name "ASSURED", term_of_policy "TERM_OF_POLICY",
                    TO_CHAR(loss_date, ''MM-DD-YYYY'') "LOSS DATE", item_title "ITEM", TO_CHAR(tsi_amt, ''9,999,999,999.99'') "TOTAL_SUM_INSURED", loss_cat_des "LOSS CATEGORY", intermediary "INTERMEDIARY/CEDANT", voucher_no_check_no "VOUCHER_NO_CHECK_NO",
                    TO_CHAR(SUM(losses_paid),''9,999,999,999.99'') "PAID LOSS" '
         || v_line
         || ' FROM TABLE(CSV_BRDRX.CSV_GICLR221L('''
         || p_session_id
         || ''','''
         || p_claim_id
         || ''','''
         || p_paid_date
         || ''','''
         || p_from_date2
         || ''','''
         || p_to_date2
         || '''))
         GROUP BY enrollee, claim_no, policy_no, assd_name, term_of_policy, loss_date, 
                  item_title, tsi_amt, loss_cat_des, intermediary, voucher_no_check_no
         ORDER BY enrollee';
      v_dyn_query.query1 := SUBSTR (v_query, 1, 4000); --koks 9.18.15 change values to 4000
      v_dyn_query.query2 := SUBSTR (v_query, 4001, 4000);
      v_dyn_query.query3 := SUBSTR (v_query, 8001, 4000);
      v_dyn_query.query4 := SUBSTR (v_query, 12001, 4000);
      v_dyn_query.query5 := SUBSTR (v_query, 16001, 4000);
      v_dyn_query.query6 := SUBSTR (v_query, 20001, 4000);
      v_dyn_query.query7 := SUBSTR (v_query, 24001, 4000);
      v_dyn_query.query8 := SUBSTR (v_query, 28001, 4000);
      PIPE ROW (v_dyn_query);
      RETURN;
   END csv_giclr221l_dynsql;
   
    --Added by Carlo Rubenecia 05.17.2016 SR - 5368 START
    FUNCTION csv_giclr222le_dynsql (
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_paid_date    VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2
   )
      RETURN csv_dynamicsql_tab PIPELINED
   IS
      v_query       LONG             := '';
      v_query1      VARCHAR2 (4000);
      v_query2      VARCHAR2 (4000);
      v_query3      VARCHAR2 (4000);
      v_query4      VARCHAR2 (4000);
      v_query5      VARCHAR2 (4000);
      v_query6      VARCHAR2 (4000);
      v_query7      VARCHAR2 (4000);
      v_query8      VARCHAR2 (4000);
      v_dyn_query   csv_dynamicsql;
      v_line        VARCHAR2 (32000);
      v_line2       VARCHAR2 (32000);
   BEGIN
      FOR a IN (SELECT DISTINCT a.share_cd, a.trty_name
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no 
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id 
                            AND a.share_cd IN (1, 999)
                       ORDER BY a.share_cd)
      LOOP
         v_line := v_line || ', TRIM(TO_CHAR(SUM(DECODE(grp_seq_no, ' || a.share_cd || ', ds_loss, 0)), ''999,999,999,999,990.00'')) "' || a.trty_name || '"';
      END LOOP;

      FOR b IN (SELECT DISTINCT a.share_cd, NVL (a.trty_name, '        ') trty_name, a.line_cd
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no 
                            AND a.line_cd = b.line_cd 
                            AND b.session_id = p_session_id 
                            AND a.share_cd NOT IN (1, 999)
                       ORDER BY a.share_cd)
                       
      LOOP
         v_line := v_line || ', TRIM(TO_CHAR(SUM(DECODE(grp_seq_no||''-''||line_cd, ''' || b.share_cd || '-' || b.line_cd || ''', ds_loss, 0)), ''999,999,999,999,990.00'')) "' || b.trty_name || '"';
      END LOOP;

      FOR c IN (SELECT DISTINCT a.share_cd, a.trty_name
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no 
                            AND a.line_cd = b.line_cd 
                            AND b.session_id = p_session_id 
                            AND a.share_cd IN (1, 999)
                       ORDER BY a.share_cd)
      LOOP
         v_line2 := v_line2 || ', TRIM(TO_CHAR(SUM(DECODE(grp_seq_no, ' || c.share_cd || ', ds_expense, 0)), ''999,999,999,999,990.00'')) "' || c.trty_name || '"';
      END LOOP;

      FOR d IN (SELECT DISTINCT a.share_cd, NVL (a.trty_name, '        ') trty_name, a.line_cd
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no 
                            AND a.line_cd = b.line_cd 
                            AND b.session_id = p_session_id 
                            AND a.share_cd NOT IN (1, 999) 
                       ORDER BY a.share_cd)
      LOOP
         v_line2 := v_line2 || ', TRIM(TO_CHAR(SUM(DECODE(grp_seq_no||''-''||line_cd, ''' || d.share_cd || '-' || d.line_cd || ''', ds_expense, 0)), ''999,999,999,999,990.00'')) "' || d.trty_name || '"';
      END LOOP;

      v_query :=
            'SELECT policy_no " POLICY ", assd_name "ASSURED", TO_CHAR(incept_date, ''MM-dd-yyyy'') ||'' - '' || TO_CHAR(expiry_date, ''MM-dd-yyyy'') "TERM" , claim_no "CLAIM_NO", 
             TO_CHAR(loss_date, ''MM-dd-yyyy'') "LOSS_DATE", item_title "ITEM", TRIM(TO_CHAR(tsi_amt, ''999,999,999,999,999,999,990.00'')) "TOTAL SUM INSURED", loss_cat_des "LOSS CATEGORY",  intermediary "INTERMEDIARY",  
             voucher_no_check_no_loss "VOUCHER NUMBER" , TRIM(TO_CHAR(SUM(DS_LOSS),''999,999,999,999,999,999,990.00'')) "LOSSES PAID"  ' 
         || v_line
         || ', 
             voucher_no_check_no_exp "VOUCHER NUMBER" , TRIM(TO_CHAR(SUM(DS_EXPENSE),''999,999,999,999,999,999,990.00''))"EXPENSES PAID"' 
         || v_line2
         ||                                                                                                                          
            ' FROM TABLE(CSV_BRDRX.CSV_GICLR222LE('''
         || p_session_id
         || ''','''
         || p_claim_id
         || ''','''
         || p_paid_date
         || ''','''
         || p_from_date
         || ''','''
         || p_to_date
         || '''))
     GROUP BY policy_no, assd_name, incept_date, expiry_date, claim_no,
              loss_date, item_title,intermediary, loss_cat_des,
              tsi_amt, item_no, peril_cd, claim_id, voucher_no_check_no_loss, voucher_no_check_no_exp ORDER BY policy_no';
      v_dyn_query.query1 := SUBSTR (v_query, 1, 4000); 
      v_dyn_query.query2 := SUBSTR (v_query, 4001, 4000);
      v_dyn_query.query3 := SUBSTR (v_query, 8001, 4000);
      v_dyn_query.query4 := SUBSTR (v_query, 12001, 4000);
      v_dyn_query.query5 := SUBSTR (v_query, 16001, 4000);
      v_dyn_query.query6 := SUBSTR (v_query, 20001, 4000);
      v_dyn_query.query7 := SUBSTR (v_query, 24001, 4000);
      v_dyn_query.query8 := SUBSTR (v_query, 28001, 4000);
      PIPE ROW (v_dyn_query);
      RETURN;
   END csv_giclr222le_dynsql;
   --Added by Carlo Rubenecia 05.17.2016 SR -5368 END
   
       --Added by Carlo Rubenecia 05.16.2016 SR - 5367 START
    FUNCTION csv_giclr222e_dynsql (
      p_session_id   VARCHAR2, 
      p_claim_id     VARCHAR2, 
      p_paid_date    VARCHAR2, 
      p_from_date    VARCHAR2, 
      p_to_date      VARCHAR2
   )
      RETURN csv_dynamicsql_tab PIPELINED
   IS
      v_query       LONG             := '';
      v_query1      VARCHAR2 (4000);
      v_query2      VARCHAR2 (4000);
      v_query3      VARCHAR2 (4000);
      v_query4      VARCHAR2 (4000);
      v_query5      VARCHAR2 (4000);
      v_query6      VARCHAR2 (4000);
      v_query7      VARCHAR2 (4000);
      v_query8      VARCHAR2 (4000);
      v_dyn_query   csv_dynamicsql;
      v_line        VARCHAR2 (32000);
   BEGIN
      FOR a IN (SELECT DISTINCT a.share_cd, a.trty_name
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no 
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id 
                            AND a.share_cd IN (1, 999)
                       ORDER BY a.share_cd)
      LOOP
         v_line := v_line || ', TRIM(TO_CHAR(SUM(DECODE(grp_seq_no, ' || a.share_cd || ', ds_loss, 0)), ''999,999,999,999,999,990.00'')) "' || a.trty_name || '"';
      END LOOP;

      FOR b IN (SELECT DISTINCT a.share_cd, NVL (a.trty_name, '        ') trty_name, a.line_cd
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no 
                            AND a.line_cd = b.line_cd 
                            AND b.session_id = p_session_id 
                            AND a.share_cd NOT IN (1, 999)
                       ORDER BY a.share_cd)
      LOOP
         v_line := v_line || ', TRIM(TO_CHAR(SUM(DECODE(grp_seq_no||''-''||line_cd, ''' || b.share_cd || '-' || b.line_cd || ''', ds_loss, 0)), ''999,999,999,999,999,990.00'')) "' || b.trty_name || '"';
      END LOOP;

      v_query :=
            'SELECT policy_no " POLICY ", assd_name "ASSURED", TO_CHAR(incept_date, ''MM-dd-yyyy'') ||'' - '' || TO_CHAR(expiry_date, ''MM-dd-yyyy'') "TERM" , claim_no "CLAIM_NO", 
             TO_CHAR(loss_date, ''MM-dd-yyyy'') "LOSS_DATE", item_title "ITEM", TRIM(TO_CHAR(tsi_amt, ''999,999,999,999,999,999,990.00'')) "TOTAL SUM INSURED", loss_cat_des "LOSS CATEGORY",  intermediary "INTERMEDIARY",  
             voucher_no_check_no "VOUCHER NUMBER" , TRIM(TO_CHAR(SUM(DS_LOSS),''999,999,999,999,999,999,990.00'')) "LOSSES PAID" '  
         || v_line
         ||                                                                                                                          
            ' FROM TABLE(CSV_BRDRX.CSV_GICLR222E('''
         || p_session_id
         || ''','''
         || p_claim_id
         || ''','''
         || p_paid_date
         || ''','''
         || p_from_date
         || ''','''
         || p_to_date
         || '''))
            WHERE DS_LOSS >0 
            GROUP BY policy_no, assd_name, incept_date, expiry_date, claim_no,
              loss_date, item_title,intermediary, loss_cat_des,
              tsi_amt, voucher_no_check_no ORDER BY policy_no';
      v_dyn_query.query1 := SUBSTR (v_query, 1, 4000); 
      v_dyn_query.query2 := SUBSTR (v_query, 4001, 4000);
      v_dyn_query.query3 := SUBSTR (v_query, 8001, 4000);
      v_dyn_query.query4 := SUBSTR (v_query, 12001, 4000);
      v_dyn_query.query5 := SUBSTR (v_query, 16001, 4000);
      v_dyn_query.query6 := SUBSTR (v_query, 20001, 4000);
      v_dyn_query.query7 := SUBSTR (v_query, 24001, 4000);
      v_dyn_query.query8 := SUBSTR (v_query, 28001, 4000);
      PIPE ROW (v_dyn_query);
      RETURN;
   END csv_giclr222e_dynsql;
    --Added by Carlo Rubenecia 05.16.2016 SR5367 END
    --SR-5364
       FUNCTION csv_giclr221e_dynsql (
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_paid_date    VARCHAR2,
      p_from_date2   VARCHAR2,
      p_to_date2     VARCHAR2
   )
      RETURN csv_dynamicsql_tab PIPELINED
   IS
      v_query       LONG             := '';
      v_query1      VARCHAR2 (4000);
      v_query2      VARCHAR2 (4000);
      v_query3      VARCHAR2 (4000);
      v_query4      VARCHAR2 (4000);
      v_query5      VARCHAR2 (4000);
      v_query6      VARCHAR2 (4000);
      v_query7      VARCHAR2 (4000);
      v_query8      VARCHAR2 (4000);
      v_dyn_query   csv_dynamicsql;
      v_line        VARCHAR2 (32000);
      v_line2       VARCHAR2 (32000);
   BEGIN
      FOR a IN (SELECT DISTINCT a.share_cd, a.trty_name
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no 
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id 
                            --AND NVL (b.losses_paid, 0) > 0  --Dren 11.24.2015 SR-0020508 : Discrepancy in Losses Paid in Brdx Report. 
                            AND a.share_cd IN (1, 999)
                       ORDER BY a.share_cd)
      LOOP
         v_line := v_line || ', TO_CHAR(SUM(DECODE(grp_seq_no, ' || a.share_cd || ', ds_loss, 0)), ''9,999,999,999.99'') "' || a.trty_name || '"';
      END LOOP;

      FOR b IN (SELECT DISTINCT a.share_cd, NVL (a.trty_name, '        ') trty_name, a.line_cd
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no 
                            AND a.line_cd = b.line_cd 
                            AND b.session_id = p_session_id 
                            --AND NVL (b.losses_paid, 0) > 0  --Dren 11.24.2015 SR-0020508 : Discrepancy in Losses Paid in Brdx Report.
                            AND a.share_cd NOT IN (1, 999)
                       ORDER BY a.share_cd)
      LOOP
         v_line := v_line || ', TO_CHAR(SUM(DECODE(grp_seq_no||''-''||line_cd, ''' || b.share_cd || '-' || b.line_cd || ''', ds_loss, 0)), ''9,999,999,999.99'') "' || b.trty_name || '"';
      END LOOP;
      
      v_query :=
            'SELECT enrollee "ENROLLEE", claim_no "CLAIM NO", policy_no "POLICY NO", assd_name "ASSURED", term_of_policy "TERM_OF_POLICY",
                    TO_CHAR(loss_date, ''MM-DD-YYYY'') "LOSS DATE", item_title "ITEM", TO_CHAR(tsi_amt, ''9,999,999,999.99'') "TOTAL_SUM_INSURED", loss_cat_des "LOSS CATEGORY", intermediary "INTERMEDIARY/CEDANT", voucher_no_check_no "VOUCHER_NO_CHECK_NO",
                    TO_CHAR(SUM(losses_paid),''9,999,999,999.99'') "PAID LOSS" '
         || v_line
         || ' FROM TABLE(CSV_BRDRX.CSV_GICLR221E('''
         || p_session_id
         || ''','''
         || p_claim_id
         || ''','''
         || p_paid_date
         || ''','''
         || p_from_date2
         || ''','''
         || p_to_date2
         || '''))
         GROUP BY enrollee, claim_no, policy_no, assd_name, term_of_policy, loss_date, 
                  item_title, tsi_amt, loss_cat_des, intermediary, voucher_no_check_no
         ORDER BY enrollee';
      v_dyn_query.query1 := SUBSTR (v_query, 1, 4000); --koks 9.18.15 change values to 4000
      v_dyn_query.query2 := SUBSTR (v_query, 4001, 4000);
      v_dyn_query.query3 := SUBSTR (v_query, 8001, 4000);
      v_dyn_query.query4 := SUBSTR (v_query, 12001, 4000);
      v_dyn_query.query5 := SUBSTR (v_query, 16001, 4000);
      v_dyn_query.query6 := SUBSTR (v_query, 20001, 4000);
      v_dyn_query.query7 := SUBSTR (v_query, 24001, 4000);
      v_dyn_query.query8 := SUBSTR (v_query, 28001, 4000);
      PIPE ROW (v_dyn_query);
      RETURN;
   END csv_giclr221e_dynsql;
    --END
END;
/

