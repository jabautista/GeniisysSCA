CREATE OR REPLACE PACKAGE BODY CPI.giac_prem_deposit_pkg
AS
   /*
   **  Created by   :  Emman
   **  Date Created :  07.22.2010
   **  Reference By : (GIACS026 - Premium Deposit)
   **  Description  : Gets GIAC Prem Deposit details of specified transaction Id
   */
   FUNCTION get_giac_prem_deposit (p_tran_id giac_prem_deposit.gacc_tran_id%TYPE)
      RETURN giac_prem_deposit_tab PIPELINED
   IS
      v_giac_prem_deposit   giac_prem_deposit_type;
   BEGIN
      FOR i IN (SELECT   a.or_print_tag, a.item_no, a.transaction_type, f.rv_meaning tran_type_name, a.old_item_no,
                         a.old_tran_type, a.b140_iss_cd, e.iss_name, a.b140_prem_seq_no, a.inst_no, a.collection_amt, a.dep_flag,
                         a.assd_no, b.assd_name assured_name, a.intm_no, c.intm_name, a.ri_cd, d.ri_name, a.par_seq_no,
                         a.quote_seq_no, a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no,
                         TO_DATE (TO_CHAR (a.colln_dt, 'mm-dd-yyyy'), 'mm-dd-yyyy') colln_dt, a.gacc_tran_id, a.old_tran_id,
                         a.remarks, a.user_id, a.last_update, a.currency_cd, a.convert_rate, a.foreign_curr_amt, a.or_tag,
                         a.comm_rec_no, a.b140_iss_cd || '-' || LTRIM (TO_CHAR (a.b140_prem_seq_no, '09999999')) bill_no
                    FROM giac_prem_deposit a,
                         giis_assured b,
                         giis_intermediary c,
                         giis_reinsurer d,
                         giis_issource e,
                         TABLE (cg_ref_codes_pkg.get_transaction_type_list) f
                   WHERE a.gacc_tran_id = p_tran_id
                     AND a.assd_no = b.assd_no(+)
                     AND a.intm_no = c.intm_no(+)
                     AND a.ri_cd = d.ri_cd(+)
                     AND a.b140_iss_cd = e.iss_cd(+)
                     AND a.transaction_type = f.rv_low_value(+)
                ORDER BY a.item_no)
      LOOP
         v_giac_prem_deposit.or_print_tag := i.or_print_tag;
         v_giac_prem_deposit.item_no := i.item_no;
         v_giac_prem_deposit.transaction_type := i.transaction_type;
         v_giac_prem_deposit.tran_type_name := i.tran_type_name;
         v_giac_prem_deposit.old_item_no := i.old_item_no;
         v_giac_prem_deposit.old_tran_type := i.old_tran_type;
         v_giac_prem_deposit.b140_iss_cd := i.b140_iss_cd;
         v_giac_prem_deposit.iss_name := i.iss_name;
         v_giac_prem_deposit.b140_prem_seq_no := i.b140_prem_seq_no;
         v_giac_prem_deposit.inst_no := i.inst_no;
         v_giac_prem_deposit.collection_amt := i.collection_amt;
         v_giac_prem_deposit.dep_flag := i.dep_flag;
         v_giac_prem_deposit.assd_no := i.assd_no;
         v_giac_prem_deposit.assured_name := i.assured_name;
         v_giac_prem_deposit.intm_no := i.intm_no;
         v_giac_prem_deposit.intm_name := i.intm_name;
         v_giac_prem_deposit.ri_cd := i.ri_cd;
         v_giac_prem_deposit.ri_name := i.ri_name;
         v_giac_prem_deposit.par_seq_no := i.par_seq_no;
         v_giac_prem_deposit.quote_seq_no := i.quote_seq_no;
         v_giac_prem_deposit.line_cd := i.line_cd;
         v_giac_prem_deposit.subline_cd := i.subline_cd;
         v_giac_prem_deposit.iss_cd := i.iss_cd;
         v_giac_prem_deposit.issue_yy := i.issue_yy;
         v_giac_prem_deposit.pol_seq_no := i.pol_seq_no;
         v_giac_prem_deposit.renew_no := i.renew_no;
         v_giac_prem_deposit.colln_dt := i.colln_dt;
         v_giac_prem_deposit.gacc_tran_id := i.gacc_tran_id;
         v_giac_prem_deposit.old_tran_id := i.old_tran_id;
         v_giac_prem_deposit.remarks := i.remarks;
         v_giac_prem_deposit.user_id := i.user_id;
         v_giac_prem_deposit.last_update := i.last_update;
         v_giac_prem_deposit.currency_cd := i.currency_cd;
         v_giac_prem_deposit.convert_rate := i.convert_rate;
         v_giac_prem_deposit.foreign_curr_amt := i.foreign_curr_amt;
         v_giac_prem_deposit.or_tag := i.or_tag;
         v_giac_prem_deposit.comm_rec_no := i.comm_rec_no;
         v_giac_prem_deposit.bill_no := i.bill_no;
         PIPE ROW (v_giac_prem_deposit);
      END LOOP;
   END get_giac_prem_deposit;

   /*
   **  Created by   :  Emman
   **  Date Created :  08.18.2010
   **  Reference By : (GIACS026 - Premium Deposit)
   **  Description  : Save (Insert/Update) GIAC Prem Deposit record
   */
   PROCEDURE set_giac_prem_deposit (
      p_gacc_tran_id       giac_prem_deposit.gacc_tran_id%TYPE,
      p_item_no            giac_prem_deposit.item_no%TYPE,
      p_transaction_type   giac_prem_deposit.transaction_type%TYPE,
      p_collection_amt     giac_prem_deposit.collection_amt%TYPE,
      p_dep_flag           giac_prem_deposit.dep_flag%TYPE,
      p_assd_no            giac_prem_deposit.assd_no%TYPE,
      p_ri_cd              giac_prem_deposit.ri_cd%TYPE,
      p_b140_prem_seq_no   giac_prem_deposit.b140_prem_seq_no%TYPE,
      p_inst_no            giac_prem_deposit.inst_no%TYPE,
      p_old_tran_id        giac_prem_deposit.old_tran_id%TYPE,
      p_old_item_no        giac_prem_deposit.old_item_no%TYPE,
      p_old_tran_type      giac_prem_deposit.old_tran_type%TYPE,
      p_issue_yy           giac_prem_deposit.issue_yy%TYPE,
      p_pol_seq_no         giac_prem_deposit.pol_seq_no%TYPE,
      p_renew_no           giac_prem_deposit.renew_no%TYPE,
      p_par_seq_no         giac_prem_deposit.par_seq_no%TYPE,
      p_par_yy             giac_prem_deposit.par_yy%TYPE,
      p_quote_seq_no       giac_prem_deposit.quote_seq_no%TYPE,
      p_currency_cd        giac_prem_deposit.currency_cd%TYPE,
      p_convert_rate       giac_prem_deposit.convert_rate%TYPE,
      p_foreign_curr_amt   giac_prem_deposit.foreign_curr_amt%TYPE,
      p_b140_iss_cd        giac_prem_deposit.b140_iss_cd%TYPE,
      p_line_cd            giac_prem_deposit.line_cd%TYPE,
      p_subline_cd         giac_prem_deposit.subline_cd%TYPE,
      p_iss_cd             giac_prem_deposit.iss_cd%TYPE,
      p_assured_name       giac_prem_deposit.assured_name%TYPE,
      p_remarks            giac_prem_deposit.remarks%TYPE,
      p_colln_dt           giac_prem_deposit.colln_dt%TYPE,
      p_or_print_tag       giac_prem_deposit.or_print_tag%TYPE,
      p_user_id            giac_prem_deposit.user_id%TYPE,
      p_last_update        giac_prem_deposit.last_update%TYPE,
      p_or_tag             giac_prem_deposit.or_tag%TYPE,
      p_upload_tag         giac_prem_deposit.upload_tag%TYPE,
      p_intm_no            giac_prem_deposit.intm_no%TYPE,
      p_comm_rec_no        giac_prem_deposit.comm_rec_no%TYPE,
      p_par_line_cd          GIAC_PREM_DEPOSIT.par_line_cd%TYPE,
      p_par_iss_cd           GIAC_PREM_DEPOSIT.par_iss_cd%TYPE
   )
   IS
   BEGIN
      MERGE INTO giac_prem_deposit
         USING DUAL
         ON (gacc_tran_id = p_gacc_tran_id AND item_no = p_item_no AND transaction_type = p_transaction_type)
         WHEN NOT MATCHED THEN
            INSERT (gacc_tran_id, item_no, transaction_type, collection_amt, dep_flag, assd_no, ri_cd, b140_prem_seq_no, inst_no,
                    old_tran_id, old_item_no, old_tran_type, issue_yy, pol_seq_no, renew_no, par_seq_no, par_yy, quote_seq_no,
                    currency_cd, convert_rate, foreign_curr_amt, b140_iss_cd, line_cd, subline_cd, iss_cd, assured_name, remarks,
                    colln_dt, or_print_tag, user_id, last_update, or_tag, upload_tag, intm_no, comm_rec_no, par_line_cd, par_iss_cd)
            VALUES (p_gacc_tran_id, p_item_no, p_transaction_type, p_collection_amt, p_dep_flag, p_assd_no, p_ri_cd,
                    p_b140_prem_seq_no, p_inst_no, p_old_tran_id, p_old_item_no, p_old_tran_type, p_issue_yy, p_pol_seq_no,
                    p_renew_no, p_par_seq_no, p_par_yy, p_quote_seq_no, p_currency_cd, p_convert_rate, p_foreign_curr_amt,
                    p_b140_iss_cd, p_line_cd, p_subline_cd, p_iss_cd, p_assured_name, p_remarks, p_colln_dt, p_or_print_tag,
                    p_user_id, p_last_update, p_or_tag, p_upload_tag, p_intm_no, p_comm_rec_no, p_par_line_cd, p_par_iss_cd)
         WHEN MATCHED THEN
            UPDATE
               SET collection_amt = p_collection_amt, dep_flag = p_dep_flag, assd_no = p_assd_no, ri_cd = p_ri_cd,
                   b140_prem_seq_no = p_b140_prem_seq_no, inst_no = p_inst_no, old_tran_id = p_old_tran_id,
                   old_item_no = p_old_item_no, old_tran_type = p_old_tran_type, issue_yy = p_issue_yy,
                   pol_seq_no = p_pol_seq_no, renew_no = p_renew_no, par_seq_no = p_par_seq_no, par_yy = p_par_yy,
                   quote_seq_no = p_quote_seq_no, currency_cd = p_currency_cd, convert_rate = p_convert_rate,
                   foreign_curr_amt = p_foreign_curr_amt, b140_iss_cd = p_b140_iss_cd, line_cd = p_line_cd,
                   subline_cd = p_subline_cd, iss_cd = p_iss_cd, assured_name = p_assured_name, remarks = p_remarks,
                   colln_dt = p_colln_dt, or_print_tag = p_or_print_tag, user_id = p_user_id, last_update = p_last_update,
                   or_tag = p_or_tag, upload_tag = p_upload_tag, intm_no = p_intm_no, comm_rec_no = p_comm_rec_no,
                   par_line_cd = p_par_line_cd, par_iss_cd = p_par_iss_cd
            ;
   END;

   /*
   **  Created by   :  Emman
   **  Date Created :  08.18.2010
   **  Reference By : (GIACS026 - Premium Deposit)
   **  Description  : Delete GIAC Prem Deposit record
   */
   PROCEDURE del_giac_prem_deposit (
      p_gacc_tran_id       giac_prem_deposit.gacc_tran_id%TYPE,
      p_item_no            giac_prem_deposit.item_no%TYPE,
      p_transaction_type   giac_prem_deposit.transaction_type%TYPE
   )
   IS
   BEGIN
      DELETE FROM giac_prem_deposit
            WHERE gacc_tran_id = p_gacc_tran_id AND item_no = p_item_no AND transaction_type = p_transaction_type;
   END;

   /*
   **  Created by   :  Emman
   **  Date Created :  10.08.2010
   **  Reference By : (GIACS020 - Comm Payts)
   **  Description  : Delete GIAC Prem Deposit record by record_no
   **                   Executed on GIACS020 GCOP block KEY-DELREC trigger
   */
   PROCEDURE del_giac_prem_dep_by_recno (
      p_gacc_tran_id   IN   giac_comm_payts.gacc_tran_id%TYPE,
      p_iss_cd         IN   giac_comm_payts.iss_cd%TYPE,
      p_prem_seq_no    IN   giac_comm_payts.prem_seq_no%TYPE,
      p_intm_no        IN   giac_comm_payts.intm_no%TYPE,
      p_record_no      IN   giac_comm_payts.record_no%TYPE
   )
   IS
      v_exist   VARCHAR2 (1);
   BEGIN
      FOR a IN (SELECT '1' exist
                  FROM giac_prem_deposit
                 WHERE gacc_tran_id = p_gacc_tran_id
                   AND b140_iss_cd = p_iss_cd
                   AND b140_prem_seq_no = p_prem_seq_no
                   AND intm_no = p_intm_no
                   AND comm_rec_no = p_record_no)
      LOOP
         v_exist := a.exist;
      END LOOP;

      IF v_exist IS NOT NULL
      THEN
         DELETE FROM giac_prem_deposit
               WHERE gacc_tran_id = p_gacc_tran_id AND comm_rec_no = p_record_no;
      END IF;
   END del_giac_prem_dep_by_recno;

   FUNCTION get_total_collections (p_tran_id giac_prem_deposit.gacc_tran_id%TYPE)
      RETURN NUMBER
   IS
      v_total_collns   NUMBER (12, 2);
   BEGIN
      SELECT NVL (SUM (collection_amt), 0)
        INTO v_total_collns
        FROM giac_prem_deposit
       WHERE gacc_tran_id = p_tran_id;

      RETURN v_total_collns;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 0;
   END get_total_collections;

   /*
   **  Created by   :  Emman
   **  Date Created :  07.22.2010
   **  Reference By : (GIACS026 - Premium Deposit)
   **  Description  : Gets values for LOV CGFK$GIPD_OLD_ITEM_NO with record_group CGFK$GIPD_OLD_ITEM_NO
   */
   FUNCTION get_old_item_no_list (
     p_transaction_type   giac_prem_deposit.transaction_type%TYPE,
     p_control_module     VARCHAR2,
     p_user_id            giis_users.user_id%TYPE,
     p_find_text     VARCHAR2,
     p_order_by      VARCHAR2,
     p_asc_desc_flag VARCHAR2,
     p_from          NUMBER,
     p_to            NUMBER      
   )
      RETURN old_item_no_list_tab PIPELINED
   IS
      TYPE cur_type IS REF CURSOR;
      c       cur_type;
      v_rec   old_item_no_list_type;
      v_sql   VARCHAR2(32767); --Deo [02.01.2017]: replace 9000 with 32767 to fix ORA-06502 (SR-23776)
      v_text  VARCHAR2(1000);  --Deo [02.01.2017]: SR-23776
   BEGIN
      --Deo [02.01.2017]: add start; rewrite query to enable query by amount (SR-23776)
   	  v_sql :=
         'SELECT mainsql.*
            FROM (SELECT COUNT (1) OVER () count_, outersql.* 
                    FROM (SELECT ROWNUM rownum_, innersql.*
                            FROM (SELECT gacc.gibr_branch_cd branch_cd, gipd1.item_no old_item_no,
                                         gipd1.transaction_type old_tran_type, gipd1.gacc_tran_id old_tran_id,
                                           (  gipd1.collection_amt
                                            + (SELECT NVL (SUM (a.collection_amt), 0)
                                                 FROM giac_prem_deposit a, giac_acctrans gacc2
                                                WHERE a.gacc_tran_id = gacc2.tran_id
                                                  AND gacc2.tran_flag <> ''D''
                                                  AND a.old_tran_id = gipd1.gacc_tran_id
                                                  AND a.old_item_no = gipd1.item_no
                                                  AND NOT EXISTS (
                                                         SELECT ''1''
                                                           FROM giac_reversals x, giac_acctrans y
                                                          WHERE x.reversing_tran_id = y.tran_id
                                                            AND x.gacc_tran_id = a.gacc_tran_id
                                                            AND y.tran_flag <> ''D''))
                                           )
                                         * -1 dsp_collection_amt, gacc.tran_year dsp_tran_year,
                                         gacc.tran_month dsp_tran_month, gacc.tran_seq_no dsp_tran_seq_no,
                                         gipd1.remarks dsp_particulars, gacc.tran_class dsp_tran_class,
                                         gacc.tran_class_no dsp_tran_class_no, gipd1.assd_no, gipd1.dep_flag,
                                         gipd1.ri_cd, gipd1.intm_no, gipd1.line_cd, gipd1.subline_cd, gipd1.iss_cd,
                                         gipd1.issue_yy, gipd1.pol_seq_no, gipd1.renew_no, gipd1.b140_iss_cd,
                                         gipd1.b140_prem_seq_no, gipd1.comm_rec_no, gipd1.inst_no,
                                         gacc.tran_year || ''-'' || gacc.tran_month || ''-'' || gacc.tran_seq_no dsp_old_tran_no,
                                         gipd1.line_cd || ''-'' || gipd1.subline_cd || ''-'' || gipd1.iss_cd || ''-'' || gipd1.issue_yy
                                         || ''-'' || gipd1.pol_seq_no || ''-'' || gipd1.renew_no dsp_policy_no,
                                         gipd1.par_line_cd || ''-'' || gipd1.par_iss_cd || ''-'' || LTRIM (TO_CHAR (gipd1.par_yy, ''09''))
                                         || ''-'' || LTRIM (TO_CHAR (gipd1.par_seq_no, ''099999'')) || ''-''
                                         || LTRIM (TO_CHAR (gipd1.quote_seq_no, ''09'')) par_no,
                                         gipd1.par_line_cd, gipd1.par_iss_cd, gipd1.par_yy, gipd1.par_seq_no,
                                         gipd1.quote_seq_no, gipd1.currency_cd, gipd1.convert_rate, gipd1.foreign_curr_amt
                                    FROM giac_acctrans gacc, giac_prem_deposit gipd1
                                   WHERE gacc.tran_id = gipd1.gacc_tran_id
                                     AND gipd1.transaction_type = :p_transaction_type - 1
                                     AND gacc.tran_flag <> ''D''
                                     AND (   (SELECT access_tag
                                                FROM giis_user_modules
                                               WHERE userid = :p_user_id
                                                 AND module_id = :p_control_module
                                                 AND tran_cd IN (
                                                        SELECT b.tran_cd
                                                          FROM giis_users a,
                                                               giis_user_iss_cd b,
                                                               giis_modules_tran c
                                                         WHERE a.user_id = b.userid
                                                           AND a.user_id = :p_user_id
                                                           AND b.iss_cd = gacc.gibr_branch_cd
                                                           AND b.tran_cd = c.tran_cd
                                                           AND c.module_id = :p_control_module)) = 1
                                          OR (SELECT access_tag
                                                FROM giis_user_grp_modules
                                               WHERE module_id = :p_control_module
                                                 AND (user_grp, tran_cd) IN (
                                                        SELECT a.user_grp, b.tran_cd
                                                          FROM giis_users a,
                                                               giis_user_grp_dtl b,
                                                               giis_modules_tran c
                                                         WHERE a.user_grp = b.user_grp
                                                           AND a.user_id = :p_user_id
                                                           AND b.iss_cd = gacc.gibr_branch_cd
                                                           AND b.tran_cd = c.tran_cd
                                                           AND c.module_id = :p_control_module)) = 1
                                         )
                                     AND (  gipd1.collection_amt
                                            + (SELECT NVL (SUM (a.collection_amt), 0)
                                                 FROM giac_prem_deposit a, giac_acctrans gacc2
                                                WHERE a.gacc_tran_id = gacc2.tran_id
                                                  AND gacc2.tran_flag <> ''D''
                                                  AND a.old_tran_id = gipd1.gacc_tran_id
                                                  AND a.old_item_no = gipd1.item_no
                                                  AND NOT EXISTS (
                                                         SELECT ''1''
                                                           FROM giac_reversals x, giac_acctrans y
                                                          WHERE x.reversing_tran_id = y.tran_id
                                                            AND x.gacc_tran_id = a.gacc_tran_id
                                                            AND y.tran_flag <> ''D''))
                                           ) > 0';
      --Deo [02.01.2017]: add ends (SR-23776)
                                           
      /* --Deo [02.01.2017]: comment out codes below (SR-23776)
      v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (
                                    SELECT   gacc.gibr_branch_cd branch_cd, gipd1.item_no old_item_no, gipd1.transaction_type old_tran_type,
                                             gipd1.gacc_tran_id old_tran_id,
                                             (gipd1.collection_amt + SUM (NVL (gipd2.collection_amt, 0))) * -1 dsp_collection_amt,
                                             gacc.tran_year dsp_tran_year, gacc.tran_month dsp_tran_month, gacc.tran_seq_no dsp_tran_seq_no,
                                             gipd1.remarks dsp_particulars, gacc.tran_class dsp_tran_class, gacc.tran_class_no dsp_tran_class_no,
                                             gipd1.assd_no, gipd1.dep_flag, gipd1.ri_cd, gipd1.intm_no, gipd1.line_cd, gipd1.subline_cd,
                                             gipd1.iss_cd, gipd1.issue_yy, gipd1.pol_seq_no, gipd1.renew_no, gipd1.b140_iss_cd,
                                             gipd1.b140_prem_seq_no, gipd1.comm_rec_no, gipd1.inst_no,
                                             gacc.tran_year || ''-'' || gacc.tran_month || ''-'' || gacc.tran_seq_no dsp_old_tran_no,
                                                gipd1.line_cd
                                             || ''-''
                                             || gipd1.subline_cd
                                             || ''-''
                                             || gipd1.iss_cd
                                             || ''-''
                                             || gipd1.issue_yy
                                             || ''-''
                                             || gipd1.pol_seq_no
                                             || ''-''
                                             || gipd1.renew_no dsp_policy_no, gipd1.par_line_cd
                                             || ''-''
                                             || gipd1.par_iss_cd
                                             || ''-''
                                             || LTRIM (TO_CHAR (gipd1.par_yy, ''09''))
                                             || ''-''
                                             || LTRIM (TO_CHAR (gipd1.par_seq_no, ''099999''))
                                             || ''-''
                                             || LTRIM (TO_CHAR (gipd1.quote_seq_no, ''09'')) par_no,
                                             gipd1.par_line_cd, gipd1.par_iss_cd, gipd1.par_yy, gipd1.par_seq_no, gipd1.quote_seq_no,
                                             gipd1.currency_cd, gipd1.convert_rate, gipd1.foreign_curr_amt
                                        FROM giac_acctrans gacc,
                                             giac_prem_deposit gipd1,
                                             (SELECT a.collection_amt, a.gacc_tran_id, a.item_no, a.old_tran_id, a.old_item_no
                                                FROM giac_prem_deposit a, giac_acctrans gacc2
                                               WHERE 1 = 1
                                                 AND a.gacc_tran_id = gacc2.tran_id
                                                 AND gacc2.tran_flag <> ''D''
                                                 AND NOT EXISTS (
                                                        SELECT ''1''
                                                          FROM giac_reversals x, giac_acctrans y
                                                         WHERE x.reversing_tran_id = y.tran_id
                                                           AND x.gacc_tran_id = a.gacc_tran_id
                                                           AND y.tran_flag <> ''D'')) gipd2
                                       WHERE gacc.tran_id = gipd1.gacc_tran_id
                                         AND gipd1.gacc_tran_id = gipd2.old_tran_id(+)
                                         AND gipd1.item_no = gipd2.old_item_no(+)
                                         AND gipd1.transaction_type = :p_transaction_type - 1
                                         AND gacc.tran_flag <> ''D''
                                         AND ((SELECT access_tag
                                                  FROM giis_user_modules
                                                 WHERE userid = :p_user_id   
                                                   AND module_id = :p_control_module
                                                   AND tran_cd IN (
                                                          SELECT b.tran_cd         
                                                            FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                                           WHERE a.user_id = b.userid
                                                             AND a.user_id = :p_user_id
                                                             AND b.iss_cd = gacc.gibr_branch_cd
                                                             AND b.tran_cd = c.tran_cd
                                                             AND c.module_id = :p_control_module)) = 1
                                         OR (SELECT access_tag
                                                  FROM giis_user_grp_modules
                                                 WHERE module_id = :p_control_module
                                                   AND (user_grp, tran_cd) IN (
                                                          SELECT a.user_grp, b.tran_cd
                                                            FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                                           WHERE a.user_grp = b.user_grp
                                                             AND a.user_id = :p_user_id
                                                             AND b.iss_cd = gacc.gibr_branch_cd
                                                             AND b.tran_cd = c.tran_cd
                                                             AND c.module_id = :p_control_module)) = 1
                                            )';*/
                   
      IF p_find_text IS NOT NULL
      THEN
         BEGIN --Deo [02.01.2017]: SR-23776
            IF INSTR (p_find_text, ',') > 0
            THEN
               v_text := TO_NUMBER (p_find_text, '999,999,999,999.00');
            ELSE
               v_text := TO_NUMBER (p_find_text, '999999999999.00');
            END IF;
         EXCEPTION
            WHEN VALUE_ERROR
            THEN
               v_text := p_find_text;
         END;
         
        v_sql := v_sql || ' AND (   gacc.tran_class LIKE UPPER('''||p_find_text||''')
                              OR gacc.tran_class_no LIKE UPPER('''||p_find_text||''')
                              OR gipd1.remarks LIKE UPPER('''||p_find_text||''')
                              OR gacc.gibr_branch_cd LIKE UPPER('''||p_find_text||''')
                              OR gacc.tran_year LIKE UPPER('''||p_find_text||''')
                              OR gacc.tran_month LIKE UPPER('''||p_find_text||''')
                              OR gacc.tran_seq_no LIKE UPPER('''||p_find_text||''')
                        	  ' /*Deo [02.01.2017]: add start (SR-23776)*/ || '
                         	  OR gipd1.item_no LIKE UPPER (''' || p_find_text || ''')
                              OR gacc.tran_year || ''-'' || gacc.tran_month || ''-'' || tran_seq_no LIKE UPPER (''' || p_find_text || ''')
                              OR gipd1.intm_no LIKE UPPER (''' || p_find_text || ''')
                              OR gipd1.line_cd || ''-'' || gipd1.subline_cd || ''-'' || gipd1.iss_cd || ''-'' || gipd1.issue_yy
                              || ''-'' || gipd1.pol_seq_no || ''-'' || gipd1.renew_no LIKE UPPER (''' || p_find_text || ''')
                              OR gipd1.b140_iss_cd LIKE UPPER (''' || p_find_text || ''')
                              OR gipd1.b140_prem_seq_no LIKE UPPER (''' || p_find_text || ''')
                              OR gipd1.comm_rec_no LIKE UPPER (''' || p_find_text || ''')
                              OR TO_CHAR (  (  gipd1.collection_amt
					                         + (SELECT NVL (SUM (a.collection_amt), 0)
					                              FROM giac_prem_deposit a, giac_acctrans gacc2
					                             WHERE a.gacc_tran_id = gacc2.tran_id
					                               AND gacc2.tran_flag <> ''D''
					                               AND a.old_tran_id = gipd1.gacc_tran_id
					                               AND a.old_item_no = gipd1.item_no
					                               AND NOT EXISTS (
					                                      SELECT ''1''
					                                        FROM giac_reversals x,
					                                             giac_acctrans y
					                                       WHERE x.reversing_tran_id = y.tran_id
					                                         AND x.gacc_tran_id = a.gacc_tran_id
					                                         AND y.tran_flag <> ''D''))
					                        ) * -1, ''fm999999999999.09'') LIKE UPPER (''' || v_text || ''')
					         ' /*Deo [02.01.2017]: add ends (SR-23776)*/ || '
                             )';
      END IF;
      
        v_sql := v_sql || /*' HAVING gipd1.collection_amt + SUM (NVL (gipd2.collection_amt, 0)) > 0*/ --Deo [02.01.2017]: comment out (SR-23776)
                          ' GROUP BY gacc.gibr_branch_cd,
                                     gipd1.item_no,
                                     gipd1.transaction_type,
                                     gipd1.gacc_tran_id,
                                     gipd1.collection_amt,
                                     gacc.tran_year,
                                     gacc.tran_month,
                                     gacc.tran_seq_no,
                                     gipd1.remarks,
                                     gacc.tran_class,
                                     gacc.tran_class_no,
                                     gipd1.assd_no,
                                     gipd1.dep_flag,
                                     gipd1.ri_cd,
                                     gipd1.intm_no,
                                     gipd1.line_cd,
                                     gipd1.subline_cd,
                                     gipd1.iss_cd,
                                     gipd1.issue_yy,
                                     gipd1.pol_seq_no,
                                     gipd1.renew_no,
                                     gipd1.b140_iss_cd,
                                     gipd1.b140_prem_seq_no,
                                     gipd1.comm_rec_no,
                                     gipd1.inst_no,
                                     gipd1.par_line_cd
                                             || ''-''
                                             || gipd1.par_iss_cd
                                             || ''-''
                                             || LTRIM (TO_CHAR (gipd1.par_yy, ''09''))
                                             || ''-''
                                             || LTRIM (TO_CHAR (gipd1.par_seq_no, ''099999''))
                                             || ''-''
                                             || LTRIM (TO_CHAR (gipd1.quote_seq_no, ''09'')),
                                     gipd1.par_line_cd, gipd1.par_iss_cd, gipd1.par_yy, gipd1.par_seq_no, gipd1.quote_seq_no,
                                     gipd1.currency_cd, gipd1.convert_rate, gipd1.foreign_curr_amt';
                                   
      IF p_order_by IS NOT NULL
      THEN
        IF p_order_by = 'oldItemNo'
        THEN        
          v_sql := v_sql || ' ORDER BY old_item_no ';
        ELSIF p_order_by = 'oldTranType'
        THEN
          v_sql := v_sql || ' ORDER BY old_tran_type ';
        ELSIF p_order_by = 'dspCollectionAmt'
        THEN
          v_sql := v_sql || ' ORDER BY dsp_collection_amt ';
        ELSIF p_order_by = 'dspOldTranNo'
        THEN
          v_sql := v_sql || ' ORDER BY dsp_old_tran_no ';           
        ELSIF p_order_by = 'dspParticulars'
        THEN
          v_sql := v_sql || ' ORDER BY dsp_particulars ';
        ELSIF p_order_by = 'dspTranClass'
        THEN
          v_sql := v_sql || ' ORDER BY dsp_tran_class ';
        ELSIF p_order_by = 'dspTranClassNo'
        THEN
          v_sql := v_sql || ' ORDER BY dsp_tran_class_no ';
        ELSIF p_order_by = 'branchCd'
        THEN
          v_sql := v_sql || ' ORDER BY branch_cd ';
        ELSIF p_order_by = 'intmNo'
        THEN
          v_sql := v_sql || ' ORDER BY intm_no ';
        ELSIF p_order_by = 'dspPolicyNo'
        THEN
          v_sql := v_sql || ' ORDER BY dsp_policy_no ';              
        ELSIF p_order_by = 'b140IssCd' /*'issCd'*/ --Deo [02.01.2017]: replace issCd with b140IssCd to fix ORA-0904 (SR-23776)
        THEN
          v_sql := v_sql || ' ORDER BY iss_cd ';
        ELSIF p_order_by = 'b140PremSeqNo'
        THEN
          v_sql := v_sql || ' ORDER BY b140_prem_seq_no ';
        ELSIF p_order_by = 'commRecNo'
        THEN
          v_sql := v_sql || ' ORDER BY comm_rec_no ';                                        
        END IF;  
                
        IF p_asc_desc_flag IS NOT NULL
        THEN
           v_sql := v_sql || p_asc_desc_flag;
        ELSE
           v_sql := v_sql || ' ASC';
        END IF; 
      END IF;
      
      v_sql := v_sql || '     ) innersql
                            ) outersql
                         ) mainsql
                    WHERE rownum_ BETWEEN '|| p_from ||' AND ' || p_to;
                                       
                     
      OPEN c FOR v_sql USING p_transaction_type, p_user_id, p_control_module, p_user_id, p_control_module, p_control_module, p_user_id, p_control_module;
      LOOP
         FETCH c INTO v_rec.count_, 
                      v_rec.rownum_, 
                      v_rec.branch_cd, 
                      v_rec.old_item_no, 
                      v_rec.old_tran_type,
                      v_rec.old_tran_id,
                      v_rec.dsp_collection_amt, 
                      v_rec.dsp_tran_year, 
                      v_rec.dsp_tran_month, 
                      v_rec.dsp_tran_seq_no,
                      v_rec.dsp_particulars,
                      v_rec.dsp_tran_class,
                      v_rec.dsp_tran_class_no,
                      v_rec.assd_no,
                      v_rec.dep_flag,
                      v_rec.ri_cd,
                      v_rec.intm_no,
                      v_rec.line_cd,
                      v_rec.subline_cd,
                      v_rec.iss_cd,
                      v_rec.issue_yy,
                      v_rec.pol_seq_no,
                      v_rec.renew_no,
                      v_rec.b140_iss_cd,
                      v_rec.b140_prem_seq_no,
                      v_rec.comm_rec_no,
                      v_rec.inst_no,
                      v_rec.dsp_old_tran_no,
                      v_rec.dsp_policy_no,
                      v_rec.dsp_par_no,
                      v_rec.par_line_cd, 
                      v_rec.par_iss_cd,   
                      v_rec.par_yy,       
                      v_rec.par_seq_no,   
                      v_rec.quote_seq_no,
                      v_rec.currency_cd,
                      v_rec.convert_rate,
                      v_rec.foreign_curr_amt;                           
         EXIT WHEN c%NOTFOUND;       
                        
         v_rec.old_tran_id2 :=
            giac_prem_deposit_pkg.get_old_tran_id (v_rec.dsp_tran_year,
                                                   v_rec.dsp_tran_month,
                                                   v_rec.dsp_tran_seq_no,
                                                   v_rec.iss_cd,
                                                   v_rec.dsp_tran_class_no
                                                  );
         v_rec.old_tran_id_for_1 :=
            giac_prem_deposit_pkg.get_old_tran_id_by_tran_type (1,
                                                                v_rec.dsp_tran_year,
                                                                v_rec.dsp_tran_month,
                                                                v_rec.dsp_tran_seq_no,
                                                                v_rec.old_item_no
                                                               );
         v_rec.old_tran_id_for_3 :=
            giac_prem_deposit_pkg.get_old_tran_id_by_tran_type (3,
                                                                v_rec.dsp_tran_year,
                                                                v_rec.dsp_tran_month,
                                                                v_rec.dsp_tran_seq_no,
                                                                v_rec.old_item_no
                                                               );
                                                               
         --assured name
         BEGIN
            SELECT assd_name
              INTO v_rec.dsp_assd_name
              FROM giis_assured
             WHERE assd_no = v_rec.assd_no;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rec.dsp_assd_name := '';
         END;
         
         --intermediary name
         BEGIN
            SELECT intm_name
              INTO v_rec.dsp_intm_name
              FROM GIIS_INTERMEDIARY
             WHERE intm_no = v_rec.intm_no;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rec.dsp_intm_name := '';
         END; 
         
         --reinsurer name
         BEGIN
            SELECT ri_name
              INTO v_rec.dsp_reinsurer_name
              FROM GIIS_REINSURER
             WHERE ri_cd = v_rec.ri_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rec.dsp_reinsurer_name := '';
         END; 
         
         --currency
         BEGIN
            SELECT currency_desc
              INTO v_rec.currency_desc
              FROM GIIS_CURRENCY
             WHERE main_currency_cd = v_rec.currency_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rec.currency_desc := '';
         END; 
         
         PIPE ROW (v_rec);
      END LOOP;

      CLOSE c;   
   END get_old_item_no_list;

   /*
   **  Created by   :  Emman
   **  Date Created :  08.03.2010
   **  Reference By : (GIACS026 - Premium Deposit)
   **  Description  : Gets values for LOV CGFK$GIPD_OLD_ITEM_NO with record_group CGFK$GIPD_OLD_ITEM_NO_FOR_4
   */
   FUNCTION get_old_item_no_for_4_list (
     p_find_text     VARCHAR2,
     p_order_by      VARCHAR2,
     p_asc_desc_flag VARCHAR2,
     p_from          NUMBER,
     p_to            NUMBER)
      RETURN old_item_no_list_tab PIPELINED
   IS
      TYPE cur_type IS REF CURSOR;
      c     cur_type;
      v_rec old_item_no_list_type;
      v_sql VARCHAR2(5000);
   BEGIN
      v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (
                                    SELECT gacc.gibr_branch_cd branch_cd, gipd1.item_no old_item_no, gipd1.transaction_type old_tran_type,
                                           gipd1.gacc_tran_id old_tran_id, gipd1.collection_amt * -1 dsp_collection_amt,
                                           gacc.tran_year dsp_tran_year, gacc.tran_month dsp_tran_month, gacc.tran_seq_no dsp_tran_seq_no,
                                           gipd1.remarks dsp_particulars, gacc.tran_class dsp_tran_class, gacc.tran_class_no dsp_tran_class_no,
                                           gipd1.assd_no, gipd1.dep_flag, gipd1.ri_cd, gipd1.intm_no, gipd1.line_cd, gipd1.subline_cd, gipd1.iss_cd,
                                           gipd1.issue_yy, gipd1.pol_seq_no, gipd1.renew_no, gipd1.b140_iss_cd, gipd1.b140_prem_seq_no,
                                           gipd1.comm_rec_no, gipd1.inst_no, gipd1.par_line_cd
                                             || ''-''
                                             || gipd1.par_iss_cd
                                             || ''-''
                                             || LTRIM (TO_CHAR (gipd1.par_yy, ''09''))
                                             || ''-''
                                             || LTRIM (TO_CHAR (gipd1.par_seq_no, ''099999''))
                                             || ''-''
                                             || LTRIM (TO_CHAR (gipd1.quote_seq_no, ''09'')) par_no,
                                             gipd1.par_line_cd, gipd1.par_iss_cd, gipd1.par_yy, gipd1.par_seq_no, gipd1.quote_seq_no,
                                             gipd1.currency_cd, gipd1.convert_rate, gipd1.foreign_curr_amt
                                      FROM giac_acctrans gacc, giac_prem_deposit gipd1
                                     WHERE gacc.tran_id = gipd1.gacc_tran_id
                                       AND gipd1.transaction_type = 3
                                       AND tran_flag <> ''D''
                                       AND NOT EXISTS (
                                                    SELECT ''1''
                                                      FROM giac_acctrans x, giac_reversals y
                                                     WHERE x.tran_id = y.reversing_tran_id AND y.gacc_tran_id = gipd1.gacc_tran_id
                                                           AND tran_flag <> ''D'')';
                         
      IF p_find_text IS NOT NULL
      THEN
        v_sql := v_sql || ' AND (UPPER(gacc.tran_class) LIKE UPPER('''||p_find_text||''')
                                OR UPPER(gacc.tran_class_no) LIKE UPPER('''||p_find_text||''')
                                OR UPPER(gipd1.remarks) LIKE UPPER('''||p_find_text||''')
                                OR UPPER(gacc.gibr_branch_cd) LIKE UPPER('''||p_find_text||''')
                               )';
      END IF;
      
      IF p_order_by IS NOT NULL
      THEN
        IF p_order_by = 'oldItemNo'
        THEN        
          v_sql := v_sql || ' ORDER BY gipd1.old_item_no ';
        ELSIF p_order_by = 'oldTranType'
        THEN
          v_sql := v_sql || ' ORDER BY gipd1.old_tran_type ';
        ELSIF p_order_by = 'dspCollectionAmt'
        THEN
          v_sql := v_sql || ' ORDER BY dsp_collection_amt ';
        ELSIF p_order_by = 'dspOldTranNo' -- this column is not in select statement
        THEN
          v_sql := v_sql || ' ORDER BY 1 ';           
        ELSIF p_order_by = 'dspParticulars'
        THEN
          v_sql := v_sql || ' ORDER BY dsp_particulars ';
        ELSIF p_order_by = 'dspTranClass'
        THEN
          v_sql := v_sql || ' ORDER BY dsp_tran_class ';
        ELSIF p_order_by = 'dspTranClassNo'
        THEN
          v_sql := v_sql || ' ORDER BY dsp_tran_class_no ';
        ELSIF p_order_by = 'branchCd'
        THEN
          v_sql := v_sql || ' ORDER BY branch_cd ';
        ELSIF p_order_by = 'intmNo'
        THEN
          v_sql := v_sql || ' ORDER BY gipd1.intm_no ';
        ELSIF p_order_by = 'dspPolicyNo' -- this column is not in select statement
        THEN
          v_sql := v_sql || ' ORDER BY 1 ';              
        ELSIF p_order_by = 'issCd'
        THEN
          v_sql := v_sql || ' ORDER BY gipd1.iss_cd ';
        ELSIF p_order_by = 'b140PremSeqNo'
        THEN
          v_sql := v_sql || ' ORDER BY gipd1.b140_prem_seq_no ';
        ELSIF p_order_by = 'commRecNo'
        THEN
          v_sql := v_sql || ' ORDER BY gipd1.comm_rec_no ';                                        
        END IF;        
        
        IF p_asc_desc_flag IS NOT NULL
        THEN
           v_sql := v_sql || p_asc_desc_flag;
        ELSE
           v_sql := v_sql || ' ASC';
        END IF; 
      END IF;
                                       
      v_sql := v_sql || '
                                   ) innersql
                            ) outersql
                         ) mainsql
                    WHERE rownum_ BETWEEN '|| p_from ||' AND ' || p_to;      
      
      OPEN c FOR v_sql;
      LOOP
         FETCH c INTO v_rec.count_, 
                      v_rec.rownum_, 
                      v_rec.branch_cd, 
                      v_rec.old_item_no, 
                      v_rec.old_tran_type,
                      v_rec.old_tran_id,
                      v_rec.dsp_collection_amt, 
                      v_rec.dsp_tran_year, 
                      v_rec.dsp_tran_month, 
                      v_rec.dsp_tran_seq_no,
                      v_rec.dsp_particulars,
                      v_rec.dsp_tran_class,
                      v_rec.dsp_tran_class_no,
                      v_rec.assd_no,
                      v_rec.dep_flag,
                      v_rec.ri_cd,
                      v_rec.intm_no,
                      v_rec.line_cd,
                      v_rec.subline_cd,
                      v_rec.iss_cd,
                      v_rec.issue_yy,
                      v_rec.pol_seq_no,
                      v_rec.renew_no,
                      v_rec.b140_iss_cd,
                      v_rec.b140_prem_seq_no,
                      v_rec.comm_rec_no,
                      v_rec.inst_no,
                      v_rec.dsp_par_no,
                      v_rec.par_line_cd, 
                      v_rec.par_iss_cd,   
                      v_rec.par_yy,       
                      v_rec.par_seq_no,   
                      v_rec.quote_seq_no,
                      v_rec.currency_cd,
                      v_rec.convert_rate,
                      v_rec.foreign_curr_amt;
         EXIT WHEN c%NOTFOUND;     
         
         --assured name
         BEGIN
            SELECT assd_name
              INTO v_rec.dsp_assd_name
              FROM giis_assured
             WHERE assd_no = v_rec.assd_no;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rec.dsp_assd_name := '';
         END;
         
         --intermediary name
         BEGIN
            SELECT intm_name
              INTO v_rec.dsp_intm_name
              FROM GIIS_INTERMEDIARY
             WHERE intm_no = v_rec.intm_no;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rec.dsp_intm_name := '';
         END; 
         
         --reinsurer name
         BEGIN
            SELECT ri_name
              INTO v_rec.dsp_reinsurer_name
              FROM GIIS_REINSURER
             WHERE ri_cd = v_rec.ri_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rec.dsp_reinsurer_name := '';
         END;   
         
		 --currency
         BEGIN
            SELECT currency_desc
              INTO v_rec.currency_desc
              FROM GIIS_CURRENCY
             WHERE main_currency_cd = v_rec.currency_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rec.currency_desc := '';
         END; 
                        
         v_rec.old_tran_id2 :=
            giac_prem_deposit_pkg.get_old_tran_id (v_rec.dsp_tran_year,
                                                   v_rec.dsp_tran_month,
                                                   v_rec.dsp_tran_seq_no,
                                                   v_rec.iss_cd,
                                                   v_rec.dsp_tran_class_no
                                                  );
         v_rec.old_tran_id_for_1 :=
            giac_prem_deposit_pkg.get_old_tran_id_by_tran_type (1,
                                                                v_rec.dsp_tran_year,
                                                                v_rec.dsp_tran_month,
                                                                v_rec.dsp_tran_seq_no,
                                                                v_rec.old_item_no
                                                               );
         v_rec.old_tran_id_for_3 :=
            giac_prem_deposit_pkg.get_old_tran_id_by_tran_type (3,
                                                                v_rec.dsp_tran_year,
                                                                v_rec.dsp_tran_month,
                                                                v_rec.dsp_tran_seq_no,
                                                                v_rec.old_item_no
                                                               );
         
         PIPE ROW (v_rec);
      END LOOP;
      
      CLOSE c;
   END get_old_item_no_for_4_list;

   /*
   **  Created by   :  Emman
   **  Date Created :  08.04.2010
   **  Reference By : (GIACS026 - Premium Deposit)
   **  Description  : Gets all Giac_prem_deposit records
   */
   FUNCTION get_giac_prem_deposit_list
      RETURN giac_prem_deposit_2_tab PIPELINED
   IS
      v_giac_prem_deposit_2   giac_prem_deposit_2_type;
   BEGIN
      FOR i IN (SELECT gipd1.gacc_tran_id, gipd1.item_no, gipd1.assd_no, gias.assd_name assured_name, gipd1.b140_iss_cd,
                       gipd1.b140_prem_seq_no, gipd1.inst_no, gipd1.line_cd, gipd1.subline_cd, gipd1.iss_cd, gipd1.issue_yy,
                       gipd1.pol_seq_no, gipd1.renew_no, gipd1.par_seq_no, gipd1.par_yy, gipd1.quote_seq_no, gipd1.remarks,
                       gipd1.transaction_type, gipd1.collection_amt
                  FROM giac_prem_deposit gipd1, giis_assured gias
                 WHERE gipd1.assd_no = gias.assd_no(+))
      LOOP
         v_giac_prem_deposit_2.gacc_tran_id := i.gacc_tran_id;
         v_giac_prem_deposit_2.item_no := i.item_no;
         v_giac_prem_deposit_2.assd_no := i.assd_no;
         v_giac_prem_deposit_2.assured_name := i.assured_name;
         v_giac_prem_deposit_2.b140_iss_cd := i.b140_iss_cd;
         v_giac_prem_deposit_2.b140_prem_seq_no := i.b140_prem_seq_no;
         v_giac_prem_deposit_2.inst_no := i.inst_no;
         v_giac_prem_deposit_2.line_cd := i.line_cd;
         v_giac_prem_deposit_2.subline_cd := i.subline_cd;
         v_giac_prem_deposit_2.iss_cd := i.iss_cd;
         v_giac_prem_deposit_2.issue_yy := i.issue_yy;
         v_giac_prem_deposit_2.pol_seq_no := i.pol_seq_no;
         v_giac_prem_deposit_2.renew_no := i.renew_no;
         v_giac_prem_deposit_2.par_seq_no := i.par_seq_no;
         v_giac_prem_deposit_2.par_yy := i.par_yy;
         v_giac_prem_deposit_2.quote_seq_no := i.quote_seq_no;
         v_giac_prem_deposit_2.remarks := i.remarks;
         v_giac_prem_deposit_2.transaction_type := i.transaction_type;
         v_giac_prem_deposit_2.collection_amt := i.collection_amt;
         PIPE ROW (v_giac_prem_deposit_2);
      END LOOP;

      RETURN;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
      WHEN TOO_MANY_ROWS
      THEN
         NULL;
   END get_giac_prem_deposit_list;

   /*
   **  Created by   :  Emman
   **  Date Created :  07.22.2010
   **  Reference By : (GIACS026 - Premium Deposit)
   **  Description  : Gets GIAC026 records
   */
   PROCEDURE get_giac_prem_deposit_records (
      p_tran_id                  IN       giac_prem_deposit.gacc_tran_id%TYPE,
      p_gfun_fund_cd             IN       giac_acctrans.gfun_fund_cd%TYPE,
      p_gibr_branch_cd           IN       giac_acctrans.gibr_branch_cd%TYPE,
      p_giac_prem_deposit_list   OUT      giac_prem_deposit_cur,
      p_giac_acctrans            OUT      giac_acctrans_pkg.giac_acctrans_cur,
      p_giis_currency_list       OUT      giis_currency_pkg.giis_currency_cur,
      p_generation_type          OUT      giac_modules.generation_type%TYPE
   )
   IS
   BEGIN
      OPEN p_giac_prem_deposit_list FOR
         SELECT   a.or_print_tag, a.item_no, a.transaction_type, f.rv_meaning tran_type_name, a.old_item_no, a.old_tran_type,
                  a.b140_iss_cd, e.iss_name, a.b140_prem_seq_no, a.inst_no, a.collection_amt, a.dep_flag, a.assd_no,
                  b.assd_name assured_name, a.intm_no, c.intm_name, a.ri_cd, d.ri_name, a.par_seq_no, a.quote_seq_no, a.line_cd,
                  a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no,
                  TO_DATE (TO_CHAR (a.colln_dt, 'mm-dd-yyyy'), 'mm-dd-yyyy') colln_dt, a.gacc_tran_id, a.old_tran_id, a.remarks,
                  a.user_id, a.last_update, a.currency_cd, a.convert_rate, a.foreign_curr_amt, a.or_tag, a.comm_rec_no,
                  DECODE (a.b140_iss_cd,
                          NULL, NULL,
                          DECODE (a.b140_prem_seq_no,
                                  NULL, NULL,
                                  a.b140_iss_cd || '-' || LTRIM (TO_CHAR (a.b140_prem_seq_no, '09999999'))
                                 )
                         ) bill_no,
                  a.par_yy
             FROM giac_prem_deposit a,
                  giis_assured b,
                  giis_intermediary c,
                  giis_reinsurer d,
                  giis_issource e,
                  TABLE (cg_ref_codes_pkg.get_transaction_type_list) f
            WHERE a.gacc_tran_id = p_tran_id
              AND a.assd_no = b.assd_no(+)
              AND a.intm_no = c.intm_no(+)
              AND a.ri_cd = d.ri_cd(+)
              AND a.b140_iss_cd = e.iss_cd(+)
              AND a.transaction_type = f.rv_low_value(+)
         ORDER BY a.item_no;

      OPEN p_giac_acctrans FOR
         SELECT a.tran_id, a.gfun_fund_cd, a.gibr_branch_cd, a.tran_date, a.tran_flag, a.tran_class, a.tran_class_no,
                a.particulars, a.tran_year, a.tran_month, a.tran_seq_no
           FROM giac_acctrans a
          WHERE tran_id = p_tran_id AND gfun_fund_cd = p_gfun_fund_cd AND gibr_branch_cd = p_gibr_branch_cd;

      OPEN p_giis_currency_list FOR
         SELECT main_currency_cd, currency_desc, currency_rt, short_name
           FROM giis_currency;

      BEGIN
         SELECT generation_type
           INTO p_generation_type
           FROM giac_modules
          WHERE module_name = 'GIACS026';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_generation_type := NULL;
      END;
   END get_giac_prem_deposit_records;

   /*
   **  Created by   :  Emman
   **  Date Created :  07.22.2010
   **  Reference By : (GIACS026 - Premium Deposit)
   **  Description  : Gets old_tran_id based on tran_year, tran_month, tran_seq_no, iss_cd, and tran_class_no,
   **                      Used in VALIDATE_TRAN_TYPE2 procedure
   */
   FUNCTION get_old_tran_id (
      p_dsp_tran_year       giac_acctrans.tran_year%TYPE,
      p_dsp_tran_month      giac_acctrans.tran_month%TYPE,
      p_dsp_tran_seq_no     giac_acctrans.tran_seq_no%TYPE,
      p_iss_cd              giac_acctrans.gibr_branch_cd%TYPE,
      p_dsp_tran_class_no   giac_acctrans.tran_class_no%TYPE
   )
      RETURN giac_prem_deposit.old_tran_id%TYPE
   IS
      v_old_tran_id   giac_acctrans.tran_id%TYPE;
   BEGIN
      SELECT DISTINCT tran_id
                 INTO v_old_tran_id
                 FROM giac_prem_deposit b, giac_acctrans a
                WHERE b.gacc_tran_id = a.tran_id
                  AND a.tran_year = p_dsp_tran_year
                  AND a.tran_month = p_dsp_tran_month
                  AND a.tran_seq_no = p_dsp_tran_seq_no
                  AND a.gibr_branch_cd = p_iss_cd
                  AND a.tran_class_no = p_dsp_tran_class_no;

      RETURN v_old_tran_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN NULL;
      WHEN TOO_MANY_ROWS
      THEN
         RETURN NULL;
   END get_old_tran_id;

   /*
   **  Created by   :  Emman
   **  Date Created :  07.22.2010
   **  Reference By : (GIACS026 - Premium Deposit)
   **  Description  : Gets old_tran_id based on tran_year, tran_month, tran_seq_no, old_item_no. The transaction_type is 1
   **                   Used in COLLECTION_DEFAULT_AMOUNT procedure
   */
   FUNCTION get_old_tran_id_by_tran_type (
      p_tran_type         giac_prem_deposit.transaction_type%TYPE,
      p_dsp_tran_year     giac_acctrans.tran_year%TYPE,
      p_dsp_tran_month    giac_acctrans.tran_month%TYPE,
      p_dsp_tran_seq_no   giac_acctrans.tran_seq_no%TYPE,
      p_old_item_no       giac_prem_deposit.item_no%TYPE
   )
      RETURN giac_prem_deposit.old_tran_id%TYPE
   IS
      v_old_tran_id   giac_acctrans.tran_id%TYPE;
   BEGIN
      SELECT gipd1.gacc_tran_id
        INTO v_old_tran_id
        FROM giac_acctrans gacc, giac_prem_deposit gipd1
       WHERE gacc.tran_id = gipd1.gacc_tran_id
         AND gipd1.transaction_type = p_tran_type
         AND gacc.tran_year = p_dsp_tran_year
         AND gacc.tran_month = p_dsp_tran_month
         AND gacc.tran_seq_no = p_dsp_tran_seq_no
         AND gipd1.item_no = p_old_item_no;

      RETURN v_old_tran_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN NULL;
      WHEN TOO_MANY_ROWS
      THEN
         RETURN NULL;
   END get_old_tran_id_by_tran_type;

   /*
   **  Created by   :  Emman
   **  Date Created :  08.05.2010
   **  Reference By : (GIACS026 - Premium Deposit)
   **  Description  : Gets collection_amt_sum for transaction_type 2
   **                   Used in COLLECTION_DEFAULT_AMOUNT procedure
   */
   FUNCTION get_collection_sum_list_for_2
      RETURN collection_amt_sum_tab PIPELINED
   IS
      v_collection_amt_sum   collection_amt_sum_type;
   BEGIN
      FOR i IN (SELECT   gbc.old_tran_id, gbc.old_item_no, SUM (collection_amt) collection_amt_sum
                    FROM giac_acctrans a, giac_prem_deposit gbc
                   WHERE gbc.transaction_type = 2
                     AND a.tran_id = gbc.gacc_tran_id
                     AND a.tran_flag <> 'D'
                     AND NOT EXISTS (
                            SELECT 'X'
                              FROM giac_reversals gr, giac_acctrans ga
                             WHERE gr.reversing_tran_id = ga.tran_id AND gbc.gacc_tran_id = gr.gacc_tran_id
                                   AND ga.tran_flag != 'D')
                GROUP BY gbc.old_tran_id, gbc.old_item_no)
      LOOP
         v_collection_amt_sum.gacc_tran_id := NULL;
         v_collection_amt_sum.old_tran_id := i.old_tran_id;
         v_collection_amt_sum.old_item_no := i.old_item_no;
         v_collection_amt_sum.collection_amt_sum := i.collection_amt_sum;
         PIPE ROW (v_collection_amt_sum);
      END LOOP;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END get_collection_sum_list_for_2;

   /*
   **  Created by   :  Emman
   **  Date Created :  08.06.2010
   **  Reference By : (GIACS026 - Premium Deposit)
   **  Description  : Gets collection_amt_sum for transaction_type 4
   **                   Used in COLLECTION_DEF_AMT_FOR_4 procedure
   */
   FUNCTION get_collection_sum_list_for_4
      RETURN collection_amt_sum_tab PIPELINED
   IS
      v_collection_amt_sum   collection_amt_sum_type;
   BEGIN
      FOR i IN (SELECT   gbc.gacc_tran_id, gbc.old_tran_id, gbc.old_item_no, SUM (collection_amt) collection_amt_sum
                    FROM giac_acctrans a, giac_prem_deposit gbc
                   WHERE gbc.transaction_type = 4
                     AND a.tran_id = gbc.gacc_tran_id
                     AND NOT EXISTS (
                                  SELECT 'X'
                                    FROM giac_reversals gr, giac_acctrans ga
                                   WHERE gr.reversing_tran_id = ga.tran_id AND gbc.gacc_tran_id = ga.tran_id
                                         AND ga.tran_flag = 'D')
                GROUP BY gbc.gacc_tran_id, gbc.old_tran_id, gbc.old_item_no)
      LOOP
         v_collection_amt_sum.gacc_tran_id := i.gacc_tran_id;
         v_collection_amt_sum.old_tran_id := i.old_tran_id;
         v_collection_amt_sum.old_item_no := i.old_item_no;
         v_collection_amt_sum.collection_amt_sum := i.collection_amt_sum;
         PIPE ROW (v_collection_amt_sum);
      END LOOP;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END get_collection_sum_list_for_4;

   /*
   **  Created by   :  Emman
   **  Date Created :  08.06.2010
   **  Reference By : (GIACS026 - Premium Deposit)
   **  Description  : Gets list of giac_aging_soa_details and gipi_polbasic records with the same policy_id
   */
   FUNCTION get_giac_aging_soa_policy_list
      RETURN giac_aging_soa_policy_tab PIPELINED
   IS
      v_giac_aging_soa_policy   giac_aging_soa_policy_type;
   BEGIN
      FOR i IN (SELECT b.policy_id, a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no,
                       b.iss_cd b140_iss_cd, b.prem_seq_no, b.inst_no
                  FROM gipi_polbasic a, giac_aging_soa_details b
                 WHERE a.policy_id = b.policy_id)
      LOOP
         v_giac_aging_soa_policy.policy_id := i.policy_id;
         v_giac_aging_soa_policy.line_cd := i.line_cd;
         v_giac_aging_soa_policy.subline_cd := i.subline_cd;
         v_giac_aging_soa_policy.iss_cd := i.iss_cd;
         v_giac_aging_soa_policy.issue_yy := i.issue_yy;
         v_giac_aging_soa_policy.pol_seq_no := i.pol_seq_no;
         v_giac_aging_soa_policy.renew_no := i.renew_no;
         v_giac_aging_soa_policy.b140_iss_cd := i.b140_iss_cd;
         v_giac_aging_soa_policy.prem_seq_no := i.prem_seq_no;
         v_giac_aging_soa_policy.inst_no := i.inst_no;
         PIPE ROW (v_giac_aging_soa_policy);
      END LOOP;
   END;

   /*
   **  Created by   :  Emman
   **  Date Created :  08.20.2010
   **  Reference By : (GIACS026 - Premium Deposit)
   **  Description  : Executes procedure UPDATE_GIAC_OP_TEXT or UPDATE_GIAC_DV_TEXT on GIACS026
   **                   depending on the tran_source
   */
   PROCEDURE update_giac_text (
      p_gacc_tran_id   giac_acctrans.tran_id%TYPE,
      p_gen_type       giac_modules.generation_type%TYPE,
      p_tran_source    VARCHAR2,
      p_or_flag        VARCHAR2,
	  p_user_id		   giis_users.user_id%TYPE
   )
   IS
   BEGIN
      IF p_tran_source IN ('OP', 'OR')
      THEN
         IF p_or_flag = 'P'
         THEN
            NULL;
         ELSE
            giac_op_text_pkg.update_giac_op_text (p_gacc_tran_id, p_gen_type, p_user_id);
         END IF;
      ELSIF p_tran_source = 'DV'
      THEN
         giac_dv_text_pkg.update_giac_dv_text (p_gacc_tran_id, p_gen_type);
      END IF;
   END update_giac_text;

   /*
   **  Created by   :  Emman
   **  Date Created :  11.09.2010
   **  Reference By : (GIACS026 - Premium Deposit)
   **  Description  : Executes procedure COLLECTION_DEFAULT_AMOUNT or COLLECTION_DEFAULT_AMT_FOR_4 on GIACS026
   **                   depending on the tran_type
   */
   PROCEDURE collection_default_amt (
      p_gacc_tran_id         IN       giac_prem_deposit.gacc_tran_id%TYPE,
      p_transaction_type     IN       giac_prem_deposit.transaction_type%TYPE,
      p_dsp_tran_year        IN       giac_acctrans.tran_year%TYPE,
      p_dsp_tran_month       IN       giac_acctrans.tran_month%TYPE,
      p_dsp_tran_seq_no      IN       giac_acctrans.tran_seq_no%TYPE,
      p_old_item_no          IN       giac_prem_deposit.old_item_no%TYPE,
      p_default_value        IN OUT   NUMBER,
      p_old_tran_id          IN OUT   giac_prem_deposit.old_tran_id%TYPE,
      p_var_pck_swtch        IN OUT   NUMBER,
      p_var_pck_tot_coll     IN OUT   NUMBER,
      p_var_pck_tot_coll_2   IN OUT   NUMBER,
      p_var_pck_gcba_gti     IN OUT   giac_bank_collns.gcba_gacc_tran_id%TYPE,
      p_var_pck_gcba_in      IN OUT   giac_bank_collns.gcba_item_no%TYPE,
      p_message              OUT      VARCHAR2
   )
   IS
      col_var         NUMBER;
      total_var       NUMBER;
      sub_total_var   NUMBER;
      v_count         NUMBER;
   BEGIN
      p_message := 'SUCCESS';
      p_var_pck_swtch := 2;

      IF p_old_tran_id IS NULL
      THEN
         BEGIN
            SELECT gipd1.gacc_tran_id
              INTO p_old_tran_id
              FROM giac_acctrans gacc, giac_prem_deposit gipd1
             WHERE gacc.tran_id = gipd1.gacc_tran_id
               AND gipd1.transaction_type = DECODE (p_transaction_type, 2, 1, 3)
               AND gacc.tran_year = p_dsp_tran_year
               AND gacc.tran_month = p_dsp_tran_month
               AND gacc.tran_seq_no = p_dsp_tran_seq_no
               AND gipd1.item_no = p_old_item_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               p_message := 'No Bill Existing.';
            WHEN TOO_MANY_ROWS
            THEN
               --:CONTROL2.SEARCH := ('%'||TO_CHAR(p_DSP_TRAN_YEAR)||TO_CHAR(p_DSP_TRAN_MONTH)||TO_CHAR(p_DSP_TRAN_SEQ_NO)||'%');
               --TMR_COLL_AMT_SHOW_LOV;
               NULL;
         END;
      END IF;

      p_var_pck_swtch := 1;

      SELECT collection_amt
        INTO col_var
        FROM giac_prem_deposit gbc
       WHERE gbc.gacc_tran_id = p_old_tran_id
         AND gbc.item_no = p_old_item_no
         AND gbc.transaction_type = DECODE (p_transaction_type, 2, 1, 3);

      p_var_pck_tot_coll := col_var;

      IF p_transaction_type = 2
      THEN
         SELECT SUM (collection_amt)
           INTO total_var
           FROM giac_acctrans a, giac_prem_deposit gbc
          WHERE gbc.transaction_type = p_transaction_type
            AND a.tran_id = gbc.gacc_tran_id
            AND a.tran_flag <> 'D'
            AND gbc.old_tran_id = p_old_tran_id
            AND gbc.old_item_no = p_old_item_no
            AND NOT EXISTS (
                            SELECT 'X'
                              FROM giac_reversals gr, giac_acctrans ga
                             WHERE gr.reversing_tran_id = ga.tran_id AND gbc.gacc_tran_id = gr.gacc_tran_id
                                   AND ga.tran_flag != 'D');
      ELSE
         SELECT SUM (collection_amt)
           INTO total_var
           FROM giac_acctrans a, giac_prem_deposit gbc
          WHERE gbc.transaction_type = 4
            AND a.tran_id = gbc.gacc_tran_id
            AND gbc.gacc_tran_id <> p_gacc_tran_id
            AND gbc.old_tran_id = p_old_tran_id
            AND gbc.old_item_no = p_old_item_no
            AND NOT EXISTS (SELECT 'X'
                              FROM giac_reversals gr, giac_acctrans ga
                             WHERE gr.reversing_tran_id = ga.tran_id AND gbc.gacc_tran_id = ga.tran_id AND ga.tran_flag = 'D');
      END IF;

      p_var_pck_tot_coll_2 := total_var;
      p_var_pck_gcba_gti := p_old_tran_id;
      p_var_pck_gcba_in := p_old_item_no;
      p_default_value := (NVL (col_var, 0) + NVL (total_var, 0)) * -1;

      IF p_default_value = 0
      THEN
         IF p_transaction_type = 2
         THEN
            p_message := 'Fully Recovered.';
         ELSE
            p_message := /* 'COLLECTION AMT 4 ' || */ p_message;
         END IF;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END collection_default_amt;

   /*
   **  Created by   :  Emman
   **  Date Created :  11.09.2010
   **  Reference By : (GIACS026 - Premium Deposit)
   **  Description  : Executes procedure GET_PAR_SEQ_NO
   */
   PROCEDURE get_par_seq_no (
      p_old_item_no     IN       giac_prem_deposit.old_item_no%TYPE,
      p_old_tran_type   IN       giac_prem_deposit.old_tran_type%TYPE,
      p_old_tran_id     IN       giac_prem_deposit.old_tran_id%TYPE,
      p_par_line_cd     OUT      giac_prem_deposit.line_cd%TYPE,
      p_par_iss_cd      OUT      giac_prem_deposit.iss_cd%TYPE,
      p_par_yy          OUT      giac_prem_deposit.par_yy%TYPE,
      p_par_seq_no      OUT      giac_prem_deposit.par_seq_no%TYPE,
      p_quote_seq_no    OUT      giac_prem_deposit.quote_seq_no%TYPE,
      p_remarks         OUT      giac_prem_deposit.remarks%TYPE
   )
   IS
   BEGIN
      SELECT line_cd, iss_cd, NVL (par_yy, 0), NVL (par_seq_no, 0), NVL (quote_seq_no, 0), remarks
        INTO p_par_line_cd, p_par_iss_cd, p_par_yy, p_par_seq_no, p_quote_seq_no, p_remarks
        FROM giac_prem_deposit
       WHERE item_no = p_old_item_no
         AND transaction_type = p_old_tran_type
         AND gacc_tran_id = p_old_tran_id
         AND transaction_type IN (1, 3);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END get_par_seq_no;

   /*
   **  Created by   :  Emman
   **  Date Created :  11.09.2010
   **  Reference By : (GIACS026 - Premium Deposit)
   **  Description  : Executes procedure GET_PAR_SEQ_NO2
   */
   PROCEDURE get_par_seq_no2 (
      p_line_cd        IN       giac_prem_deposit.line_cd%TYPE,
      p_subline_cd     IN       giac_prem_deposit.subline_cd%TYPE,
      p_iss_cd         IN       giac_prem_deposit.iss_cd%TYPE,
      p_issue_yy       IN       giac_prem_deposit.issue_yy%TYPE,
      p_pol_seq_no     IN       giac_prem_deposit.pol_seq_no%TYPE,
      p_b140_iss_cd    IN       gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no    IN       gipi_invoice.prem_seq_no%TYPE,
      p_assd_no        IN       giac_prem_deposit.assd_no%TYPE,
      p_par_line_cd    OUT      giac_prem_deposit.line_cd%TYPE,
      p_par_iss_cd     OUT      giac_prem_deposit.iss_cd%TYPE,
      p_par_yy         OUT      giac_prem_deposit.par_yy%TYPE,
      p_par_seq_no     OUT      giac_prem_deposit.par_seq_no%TYPE,
      p_quote_seq_no   OUT      giac_prem_deposit.quote_seq_no%TYPE
   )
   IS
      v_par_id   gipi_polbasic.par_id%TYPE;
      v_policy_id               gipi_polbasic.policy_id%TYPE;
   BEGIN
      --marco - 12.09.2014
      SELECT policy_id
        INTO v_policy_id
        FROM gipi_invoice
       WHERE iss_cd = p_b140_iss_cd
         AND prem_seq_no = p_prem_seq_no;
   
      SELECT par_id
        INTO v_par_id
        FROM gipi_polbasic
       WHERE line_cd = p_line_cd
         AND subline_cd = p_subline_cd
         AND iss_cd = p_iss_cd
         AND issue_yy = p_issue_yy
         AND pol_seq_no = p_pol_seq_no
         AND policy_id = v_policy_id;

      SELECT line_cd, iss_cd, par_yy, par_seq_no, quote_seq_no
        INTO p_par_line_cd, p_par_iss_cd, p_par_yy, p_par_seq_no, p_quote_seq_no
        FROM gipi_parlist
       WHERE par_id = v_par_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
      WHEN TOO_MANY_ROWS
      THEN
         NULL;
   END get_par_seq_no2;

   /*
   **  Created by   :  Emman
   **  Date Created :  08.10.2010
   **  Reference By : (GIACS026 - Premium Deposit)
   **  Description  : Executes the procedure VALIDATE_TRAN_TYPE1 of GIACS026 and gets the updated fields
   */
   PROCEDURE validate_tran_type1 (
      p_b140_iss_cd        IN       giac_aging_soa_details.iss_cd%TYPE,
      p_b140_prem_seq_no   IN       giac_aging_soa_details.prem_seq_no%TYPE,
      p_inst_no            IN       giac_aging_soa_details.inst_no%TYPE,
      p_assd_no            IN OUT   giis_assured.assd_no%TYPE,
      p_drv_assured_name   IN OUT   giis_assured.assd_name%TYPE,
      p_assured_name       IN OUT   giis_assured.assd_name%TYPE,
      p_dsp_a150_line_cd   IN OUT   giac_prem_deposit.line_cd%TYPE,
      p_line_cd            IN OUT   giac_prem_deposit.line_cd%TYPE,
      p_subline_cd         IN OUT   giac_prem_deposit.subline_cd%TYPE,
      p_iss_cd             IN OUT   giac_prem_deposit.iss_cd%TYPE,
      p_issue_yy           IN OUT   giac_prem_deposit.issue_yy%TYPE,
      p_pol_seq_no         IN OUT   giac_prem_deposit.pol_seq_no%TYPE,
      p_renew_no           IN OUT   giac_prem_deposit.renew_no%TYPE
   )
   IS
      v_line_cd     giac_aging_ri_soa_details.a150_line_cd%TYPE;
      v_policy_id   giac_aging_soa_details.policy_id%TYPE;
      v_assd_no     giis_assured.assd_no%TYPE;
   BEGIN
      DECLARE
         CURSOR a
         IS
            SELECT policy_id
              FROM giac_aging_soa_details gagd
             WHERE gagd.iss_cd = p_b140_iss_cd AND gagd.prem_seq_no = p_b140_prem_seq_no AND gagd.inst_no = p_inst_no;
      BEGIN
         IF p_b140_iss_cd = 'RI'
         THEN
            BEGIN
               SELECT policy_id
                 INTO v_policy_id
                 FROM gipi_invoice
                WHERE iss_cd = p_b140_iss_cd
                  AND prem_seq_no = p_b140_prem_seq_no;
            EXCEPTION
               WHEN OTHERS THEN
                  v_policy_id := NULL;
            END;
         
            SELECT a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no, a.assd_no
              INTO p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, v_assd_no
              FROM gipi_polbasic a
             WHERE a.policy_id = v_policy_id;
             
            --marco - 09.26.2014
            BEGIN
               SELECT gagd.a150_line_cd
                 INTO p_dsp_a150_line_cd
                 FROM giac_aging_ri_soa_details gagd
                WHERE gagd.prem_seq_no = p_b140_prem_seq_no AND gagd.inst_no = p_inst_no;
            EXCEPTION
               WHEN OTHERS THEN
                  p_dsp_a150_line_cd := NULL;
            END;
         ELSE
            OPEN a;
            FETCH a
             INTO v_policy_id;
            CLOSE a;
         
            SELECT a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no, a.assd_no
              INTO p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, v_assd_no
              FROM gipi_polbasic a
             WHERE a.policy_id = v_policy_id;
             
            --marco - 09.26.2014
            BEGIN
               SELECT gagd.a150_line_cd
                 INTO p_dsp_a150_line_cd
                 FROM giac_aging_soa_details gagd
                WHERE gagd.iss_cd = p_b140_iss_cd AND gagd.prem_seq_no = p_b140_prem_seq_no AND gagd.inst_no = p_inst_no;
            EXCEPTION
               WHEN OTHERS THEN
                  p_dsp_a150_line_cd := NULL;
            END;
         END IF;
         
         --marco - 09.26.2014
         BEGIN
            SELECT assd_no || ' - ' || assd_name, assd_name, assd_no
              INTO p_drv_assured_name, p_assured_name, p_assd_no
              FROM giis_assured
             WHERE assd_no = v_assd_no;
         EXCEPTION
            WHEN OTHERS THEN
               p_drv_assured_name := NULL;
               p_assured_name := NULL;
         END;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
         WHEN TOO_MANY_ROWS
         THEN
            p_line_cd := NULL;
            p_subline_cd := NULL;
            p_iss_cd := NULL;
            p_issue_yy := NULL;
            p_pol_seq_no := NULL;
            p_renew_no := NULL;
      END;
   END validate_tran_type1;

   /*
   **  Created by   :  Emman
   **  Date Created :  11.10.2010
   **  Reference By : (GIACS026 - Premium Deposit)
   **  Description  : Executes the procedure VALIDATE_TRAN_TYPE2 of GIACS026 and gets the updated fields
   */
   PROCEDURE validate_tran_type2 (
      p_transaction_type    IN OUT   giac_prem_deposit.transaction_type%TYPE,
      p_dsp_tran_year       IN OUT   giac_acctrans.tran_year%TYPE,
      p_dsp_tran_month      IN OUT   giac_acctrans.tran_month%TYPE,
      p_dsp_tran_seq_no     IN OUT   giac_acctrans.tran_seq_no%TYPE,
      p_dsp_tran_class_no   IN OUT   giac_acctrans.tran_class_no%TYPE,
      p_old_item_no         IN OUT   giac_prem_deposit.old_item_no%TYPE,
      p_old_tran_type       IN OUT   giac_prem_deposit.old_tran_type%TYPE,
      p_old_tran_id         IN OUT   giac_prem_deposit.old_tran_id%TYPE,
      p_assd_no             IN OUT   giac_prem_deposit.assd_no%TYPE,
      p_par_seq_no          IN OUT   giac_prem_deposit.par_seq_no%TYPE,
      p_par_yy              IN OUT   giac_prem_deposit.par_yy%TYPE,
      p_quote_seq_no        IN OUT   giac_prem_deposit.quote_seq_no%TYPE,
      p_line_cd             IN OUT   giac_prem_deposit.line_cd%TYPE,
      p_subline_cd          IN OUT   giac_prem_deposit.subline_cd%TYPE,
      p_iss_cd              IN OUT   giac_prem_deposit.iss_cd%TYPE,
      p_issue_yy            IN OUT   giac_prem_deposit.issue_yy%TYPE,
      p_pol_seq_no          IN OUT   giac_prem_deposit.pol_seq_no%TYPE,
      p_renew_no            IN OUT   giac_prem_deposit.renew_no%TYPE,
      p_b140_iss_cd         IN OUT   giac_prem_deposit.b140_iss_cd%TYPE,
      p_b140_prem_seq_no    IN OUT   giac_prem_deposit.b140_prem_seq_no%TYPE,
      p_inst_no             IN OUT   giac_prem_deposit.inst_no%TYPE,
      p_dsp_par_no          IN OUT   VARCHAR2,
      p_message             OUT      VARCHAR2
   )
   IS
   BEGIN
      p_message := 'SUCCESS';

      BEGIN
         SELECT DISTINCT tran_id
                    INTO p_old_tran_id
                    FROM giac_prem_deposit b, giac_acctrans a
                   WHERE b.gacc_tran_id = a.tran_id
                     AND a.tran_year = p_dsp_tran_year
                     AND a.tran_month = p_dsp_tran_month
                     AND a.tran_seq_no = p_dsp_tran_seq_no
                     AND a.gibr_branch_cd = p_iss_cd
                     AND a.tran_class_no = p_dsp_tran_class_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
         WHEN TOO_MANY_ROWS
         THEN
            p_message := 'There is an error in table GIAC_ACCTRANS, contact your DBA. 1 ';
            p_transaction_type := NULL;
            p_dsp_tran_year := NULL;
            p_dsp_tran_month := NULL;
            p_dsp_tran_seq_no := NULL;
            p_old_item_no := NULL;
            p_old_tran_type := NULL;
            p_assd_no := NULL;
            p_par_seq_no := NULL;
            p_quote_seq_no := NULL;
            p_line_cd := NULL;
            p_iss_cd := NULL;
            p_issue_yy := NULL;
            p_pol_seq_no := NULL;
            p_renew_no := NULL;
      END;

      BEGIN
         SELECT gipd1.assd_no, gipd1.b140_iss_cd, gipd1.b140_prem_seq_no, gipd1.inst_no, gipd1.line_cd, gipd1.subline_cd,
                gipd1.iss_cd, gipd1.issue_yy, gipd1.pol_seq_no, gipd1.renew_no, gipd1.par_seq_no, gipd1.par_yy,
                gipd1.quote_seq_no
           INTO p_assd_no, p_b140_iss_cd, p_b140_prem_seq_no, p_inst_no, p_line_cd, p_subline_cd,
                p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, p_par_seq_no, p_par_yy,
                p_quote_seq_no
           FROM giac_prem_deposit gipd1
          WHERE gipd1.gacc_tran_id = p_old_tran_id AND gipd1.item_no = p_old_item_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
         WHEN TOO_MANY_ROWS
         THEN
            p_message := 'There is an error in table GIAC_ACCTRANS, contact your DBA. 2 ';
            p_transaction_type := NULL;
            p_dsp_tran_year := NULL;
            p_dsp_tran_month := NULL;
            p_dsp_tran_seq_no := NULL;
            p_old_item_no := NULL;
            p_old_tran_type := NULL;
            p_assd_no := NULL;
            p_par_seq_no := NULL;
            p_quote_seq_no := NULL;
            p_line_cd := NULL;
            p_iss_cd := NULL;
            p_issue_yy := NULL;
            p_pol_seq_no := NULL;
            p_renew_no := NULL;
      END;
   END validate_tran_type2;

   FUNCTION check_gipd_gipd_fk (
      p_old_tran_id     giac_prem_deposit.gacc_tran_id%TYPE,
      p_old_item_no     giac_prem_deposit.item_no%TYPE,
      p_old_tran_type   giac_prem_deposit.transaction_type%TYPE
   )
      RETURN VARCHAR2
   IS
      v_exist   VARCHAR2 (1) := NULL;
   BEGIN
      SELECT 'Y'
        INTO v_exist
        FROM giac_prem_deposit
       WHERE gacc_tran_id = p_old_tran_id AND item_no = p_old_item_no AND transaction_type = p_old_tran_type;

      RETURN v_exist;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 'N';
   END check_gipd_gipd_fk;

   FUNCTION get_par_no_lov ( --edited by steven 12/18/2012
      /*p_par_line_cd    giac_prem_deposit.line_cd%TYPE,
      p_par_iss_cd     giac_prem_deposit.iss_cd%TYPE,
      p_par_yy         giac_prem_deposit.par_yy%TYPE,
      p_par_seq_no     giac_prem_deposit.par_seq_no%TYPE,
      p_quote_seq_no   giac_prem_deposit.quote_seq_no%TYPE,
      p_dsp_par_no     VARCHAR2,*/
	  p_assd_no 	   GIIS_ASSURED.assd_no%TYPE,
      p_user_id        VARCHAR2,
      p_find_text      VARCHAR2
   )
      RETURN par_no_list_tab PIPELINED
   IS
      v_par_no_list   par_no_list_type;
   BEGIN
      FOR i IN (SELECT b240.line_cd
                         || '-'
                         || b240.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (b240.par_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (b240.par_seq_no, '099999'))
                         || '-'
                         || LTRIM (TO_CHAR (b240.quote_seq_no, '09')) par_no,
	  			   b240.line_cd line_cd ,
				   b240.iss_cd iss_cd ,
				   b240.par_yy par_yy ,
				   b240.par_seq_no par_seq_no,
				   b240.quote_seq_no quote_seq_no ,
				   --b240.par_status dsp_par_status ,
				   --b240.par_type dsp_par_type ,
				   --b240.assd_no assd_no,
				   a250.assd_no ASSD_NO ,
				   a250.assd_name ASSD_NAME,
				   --a250.assd_name assured_name2,
				   c260.line_cd pol_line_cd,
				   c260.subline_cd pol_subline_cd,
				   c260.iss_cd pol_iss_cd,
				   c260.issue_yy pol_issue_yy,
				   c260.pol_seq_no pol_pol_seq_no,
				   c260.renew_no pol_renew_no,
				   c260.LINE_CD 
				    || '-'
				   	|| c260.SUBLINE_CD 
					|| '-' 
				    ||c260.ISS_CD  
					|| '-'
				    ||LTRIM (TO_CHAR (c260.ISSUE_YY, '09'))
					|| '-' 
				    ||LTRIM (TO_CHAR (c260.POL_SEQ_NO, '0999999'))
					|| '-' 
				    ||LTRIM (TO_CHAR (c260.RENEW_NO, '09')) POLICY_NO
			FROM gipi_parlist b240, 
				giis_assured a250, 
				gipi_polbasic c260
			WHERE  b240.assd_no = NVL(p_assd_no, b240.assd_no)
			AND a250.assd_no = b240.assd_no
			AND c260.par_id (+) = NVL(b240.par_id,NULL)
            /*AND (UPPER (b240.line_cd) LIKE UPPER (NVL (p_find_text, b240.line_cd))
                          OR UPPER (b240.iss_cd) LIKE UPPER (NVL (p_find_text, b240.iss_cd))
                          OR UPPER (b240.par_yy) LIKE UPPER (NVL (p_find_text, b240.par_yy))
                          OR UPPER (b240.par_seq_no) LIKE UPPER (NVL (p_find_text, b240.par_seq_no))
                          OR UPPER (b240.quote_seq_no) LIKE UPPER (NVL (p_find_text, b240.quote_seq_no)))*/
             AND ((SELECT access_tag
                              FROM giis_user_modules
                             WHERE userid = NVL (p_user_id, USER)   
                               AND module_id = 'GIACS026'
                               AND tran_cd IN (
                                      SELECT b.tran_cd         
                                        FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                       WHERE a.user_id = b.userid
                                         AND a.user_id = NVL (p_user_id, USER)
                                         AND b.iss_cd = C260.iss_cd
                                         AND b.tran_cd = c.tran_cd
                                         AND c.module_id = 'GIACS026')) = 1
                     OR (SELECT access_tag
                              FROM giis_user_grp_modules
                             WHERE module_id = 'GIACS026'
                               AND (user_grp, tran_cd) IN (
                                      SELECT a.user_grp, b.tran_cd
                                        FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                       WHERE a.user_grp = b.user_grp
                                         AND a.user_id = NVL (p_user_id, USER)
                                         AND b.iss_cd = C260.iss_cd
                                         AND b.tran_cd = c.tran_cd
                                         AND c.module_id = 'GIACS026')) = 1
                   )             
       )
                    /*(SELECT      line_cd
                         || '-'
                         || iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (par_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (par_seq_no, '099999'))
                         || '-'
                         || LTRIM (TO_CHAR (quote_seq_no, '09')) par_no,
                         line_cd, iss_cd, par_yy, par_seq_no, quote_seq_no
                    FROM gipi_parlist
                   WHERE (   UPPER (line_cd) LIKE UPPER (NVL (p_find_text, line_cd))
                          OR UPPER (iss_cd) LIKE UPPER (NVL (p_find_text, iss_cd))
                          OR UPPER (par_yy) LIKE UPPER (NVL (p_find_text, par_yy))
                          OR UPPER (par_seq_no) LIKE UPPER (NVL (p_find_text, par_seq_no))
                          OR UPPER (quote_seq_no) LIKE UPPER (NVL (p_find_text, quote_seq_no))
                         )
                ORDER BY par_no)*/
      LOOP
	  	 v_par_no_list.dsp_par_no 		:= i.par_no;
         v_par_no_list.par_line_cd 		:= i.line_cd;
         v_par_no_list.par_iss_cd 		:= i.iss_cd;
         v_par_no_list.par_yy 			:= i.par_yy;
         v_par_no_list.par_seq_no 		:= i.par_seq_no;
         v_par_no_list.quote_seq_no 	:= i.quote_seq_no;
		 v_par_no_list.pol_line_cd 		:= i.pol_line_cd;
	     v_par_no_list.pol_subline_cd 	:= i.pol_subline_cd;
	     v_par_no_list.pol_iss_cd 		:= i.pol_iss_cd;
	     v_par_no_list.pol_issue_yy 	:= i.pol_issue_yy;
	     v_par_no_list.pol_pol_seq_no 	:= i.pol_pol_seq_no;
	     v_par_no_list.pol_renew_no 	:= i.pol_renew_no;
		 v_par_no_list.assd_no          := i.ASSD_NO;
         v_par_no_list.assd_name        := i.ASSD_NAME;
         v_par_no_list.policy_no        := i.POLICY_NO;
         PIPE ROW (v_par_no_list);
      END LOOP;
   END;

   FUNCTION get_prem_dep_tg (
      p_tran_id          IN   giac_prem_deposit.gacc_tran_id%TYPE,
      p_gfun_fund_cd     IN   giac_acctrans.gfun_fund_cd%TYPE,
      p_gibr_branch_cd   IN   giac_acctrans.gibr_branch_cd%TYPE,
      p_item_no               giac_prem_deposit.item_no%TYPE,
      p_tran_type_name        cg_ref_codes.rv_meaning%TYPE,
      p_old_tran_id           giac_prem_deposit.old_tran_id%TYPE,
      p_iss_name              giis_issource.iss_name%TYPE,
      p_bill_no               VARCHAR2,
      p_inst_no               giac_prem_deposit.inst_no%TYPE,
      p_collection_amt        giac_prem_deposit.collection_amt%TYPE,
      p_dep_flag              giac_prem_deposit.dep_flag%TYPE
   )
      RETURN giac_prem_dep_tg_tab PIPELINED
   IS
      v_prem_dep_list   giac_prem_dep_tg_type;
   BEGIN
      FOR i IN
         (SELECT   a.or_print_tag, a.item_no, a.transaction_type, f.rv_meaning tran_type_name, a.old_item_no, a.old_tran_type,
                   a.b140_iss_cd, e.iss_name, a.b140_prem_seq_no, a.inst_no, a.collection_amt, a.dep_flag, a.assd_no,
                   b.assd_name assured_name, a.intm_no, c.intm_name, a.ri_cd, d.ri_name, a.par_seq_no, a.quote_seq_no, a.line_cd,
                   a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no,
                   TO_DATE (TO_CHAR (a.colln_dt, 'mm-dd-yyyy'), 'mm-dd-yyyy') colln_dt, a.gacc_tran_id, a.old_tran_id, a.remarks,
                   a.user_id, a.last_update, a.currency_cd, a.convert_rate, a.foreign_curr_amt, a.or_tag, a.comm_rec_no,
                   DECODE (a.b140_iss_cd,
                           NULL, NULL,
                           DECODE (a.b140_prem_seq_no,
                                   NULL, NULL,
                                   a.b140_iss_cd || '-' || LTRIM (TO_CHAR (a.b140_prem_seq_no, '09999999'))
                                  )
                          ) bill_no,
                   a.par_yy, LTRIM (TO_CHAR (par_yy, '09')) dsp_par_yy, LTRIM (TO_CHAR (par_seq_no, '099999')) dsp_par_seq_no,
                   LTRIM (TO_CHAR (quote_seq_no, '09')) dsp_quote_seq_no, g.rv_meaning dsp_dep_flag, h.currency_desc,  -- added by Kris 02.01.2013
                   a.par_line_cd || '-' || a.par_iss_cd || '-' || LTRIM (TO_CHAR (a.par_yy, '09')) || '-' || LTRIM (TO_CHAR (a.par_seq_no, '099999'))
                   || '-' || LTRIM (TO_CHAR (a.quote_seq_no, '09')) par_no
              FROM giac_prem_deposit a,
                   giis_assured b,
                   giis_intermediary c,
                   giis_reinsurer d,
                   giis_issource e,
                   TABLE (cg_ref_codes_pkg.get_transaction_type_list) f,
                   CG_REF_CODES g,
                   giis_currency h  -- added by Kris 02.01.2013
             WHERE a.gacc_tran_id = p_tran_id
               AND a.assd_no = b.assd_no(+)
               AND a.intm_no = c.intm_no(+)
               AND a.ri_cd = d.ri_cd(+)
               AND a.b140_iss_cd = e.iss_cd(+)
               AND a.transaction_type = f.rv_low_value(+)
               AND g.rv_domain = 'GIAC_PREM_DEPOSIT.DEP_FLAG' -- andrew - 08.14.2012
               AND g.rv_low_value = a.dep_flag
               AND (   a.item_no LIKE NVL (p_item_no, a.item_no)
                    OR UPPER (f.rv_meaning) LIKE UPPER (NVL (p_tran_type_name, f.rv_meaning))
                    OR a.old_tran_id LIKE (NVL (p_old_tran_id, a.old_tran_id))
                    OR UPPER (e.iss_name) LIKE UPPER (NVL (p_iss_name, e.iss_name))
                    OR a.inst_no LIKE (NVL (p_inst_no, a.inst_no))
                    OR a.collection_amt LIKE (NVL (p_collection_amt, a.collection_amt))
                    OR a.dep_flag LIKE (NVL (p_dep_flag, a.dep_flag))
                    OR DECODE (a.b140_iss_cd,
                               NULL, NULL,
                               DECODE (a.b140_prem_seq_no,
                                       NULL, NULL,
                                       a.b140_iss_cd || '-' || LTRIM (TO_CHAR (a.b140_prem_seq_no, '09999999'))
                                      )
                              ) LIKE
                          UPPER (NVL (p_bill_no,
                                      DECODE (a.b140_iss_cd,
                                              NULL, NULL,
                                              DECODE (a.b140_prem_seq_no,
                                                      NULL, NULL,
                                                      a.b140_iss_cd || '-' || LTRIM (TO_CHAR (a.b140_prem_seq_no, '09999999'))
                                                     )
                                             )
                                     )
                                )
                   )
            AND a.currency_cd = h.main_currency_cd -- added by Kris 02.01.2013 
          ORDER BY a.item_no)
      LOOP
         v_prem_dep_list.collection_amt := i.collection_amt;
         v_prem_dep_list.dep_flag := i.dep_flag;       
         v_prem_dep_list.dsp_dep_flag := Initcap(i.dsp_dep_flag); 
         v_prem_dep_list.assd_no := i.assd_no;
         v_prem_dep_list.assured_name := i.assured_name;
         v_prem_dep_list.intm_no := i.intm_no;
         v_prem_dep_list.intm_name := i.intm_name;
         v_prem_dep_list.ri_cd := i.ri_cd;
         v_prem_dep_list.ri_name := i.ri_name;
         v_prem_dep_list.par_seq_no := i.par_seq_no;
         v_prem_dep_list.quote_seq_no := i.quote_seq_no;
         v_prem_dep_list.line_cd := i.line_cd;
         v_prem_dep_list.subline_cd := i.subline_cd;
         v_prem_dep_list.iss_cd := i.iss_cd;
         v_prem_dep_list.issue_yy := i.issue_yy;
         v_prem_dep_list.pol_seq_no := i.pol_seq_no;
         v_prem_dep_list.renew_no := i.renew_no;
         v_prem_dep_list.colln_dt := i.colln_dt;
         v_prem_dep_list.gacc_tran_id := i.gacc_tran_id;
         v_prem_dep_list.old_tran_id := i.old_tran_id;
         v_prem_dep_list.remarks := i.remarks;
         v_prem_dep_list.user_id := i.user_id;
         v_prem_dep_list.last_update := i.last_update;
         v_prem_dep_list.currency_cd := i.currency_cd;
         v_prem_dep_list.currency_desc := i.currency_desc;  -- added by Kris 02.01.2013
         v_prem_dep_list.convert_rate := i.convert_rate;
         v_prem_dep_list.foreign_curr_amt := i.foreign_curr_amt;
         v_prem_dep_list.or_tag := i.or_tag;
         v_prem_dep_list.comm_rec_no := i.comm_rec_no;
         v_prem_dep_list.bill_no := i.bill_no;
         v_prem_dep_list.par_yy := i.par_yy;
         v_prem_dep_list.or_print_tag := i.or_print_tag;
         v_prem_dep_list.item_no := i.item_no;
         v_prem_dep_list.transaction_type := i.transaction_type;
         v_prem_dep_list.tran_type_name := i.tran_type_name;
         v_prem_dep_list.old_item_no := i.old_item_no;
         v_prem_dep_list.old_tran_type := i.old_tran_type;
         v_prem_dep_list.b140_iss_cd := i.b140_iss_cd;
         v_prem_dep_list.iss_name := i.iss_name;
         v_prem_dep_list.b140_prem_seq_no := i.b140_prem_seq_no;
         v_prem_dep_list.inst_no := i.inst_no;
         v_prem_dep_list.dsp_par_yy := i.dsp_par_yy;
         v_prem_dep_list.dsp_par_seq_no := i.dsp_par_seq_no;
         v_prem_dep_list.dsp_quote_seq_no := i.dsp_quote_seq_no;
         v_prem_dep_list.tran_id := i.gacc_tran_id;
         v_prem_dep_list.dsp_par_no := i.par_no;

         v_prem_dep_list.tran_year := NULL;
         v_prem_dep_list.tran_month := NULL;
         v_prem_dep_list.tran_seq_no := NULL;
         v_prem_dep_list.dsp_old_tran_no := NULL;
         FOR j IN (SELECT tran_id, gfun_fund_cd, gibr_branch_cd, tran_date, tran_flag, tran_class, tran_class_no, particulars,
                          tran_year, tran_month, tran_seq_no,
                          tran_year || '-' || tran_month || '-' || tran_seq_no dsp_old_tran_no
                     FROM giac_acctrans
                    WHERE tran_id = i.old_tran_id AND gfun_fund_cd = p_gfun_fund_cd AND gibr_branch_cd = i.b140_iss_cd)
         LOOP
            --v_prem_dep_list.tran_id := j.tran_id;
            v_prem_dep_list.gfun_fund_cd := j.gfun_fund_cd;
            v_prem_dep_list.gibr_branch_cd := j.gibr_branch_cd;
            v_prem_dep_list.tran_date := j.tran_date;
            v_prem_dep_list.tran_flag := j.tran_flag;
            v_prem_dep_list.tran_class := j.tran_class;
            v_prem_dep_list.tran_class_no := j.tran_class_no;
            v_prem_dep_list.particulars := j.particulars;
            v_prem_dep_list.tran_year := j.tran_year;
            v_prem_dep_list.tran_month := j.tran_month;
            v_prem_dep_list.tran_seq_no := j.tran_seq_no;
            v_prem_dep_list.dsp_old_tran_no := j.dsp_old_tran_no;
         END LOOP;
         
         PIPE ROW (v_prem_dep_list);
      END LOOP;
   END;

   FUNCTION get_giac_acctrans (
      p_tran_id          IN   giac_prem_deposit.gacc_tran_id%TYPE,
      p_gfun_fund_cd     IN   giac_acctrans.gfun_fund_cd%TYPE,
      p_gibr_branch_cd   IN   giac_acctrans.gibr_branch_cd%TYPE
   )
      RETURN giac_acctrans_tab PIPELINED
   IS
      v_giac_acctrans_list   giac_acctrans_type;
   BEGIN
      FOR i IN (SELECT a.tran_id, a.gfun_fund_cd, a.gibr_branch_cd, a.tran_date, a.tran_flag, a.tran_class, a.tran_class_no,
                       a.particulars, a.tran_year, a.tran_month, a.tran_seq_no
                  FROM giac_acctrans a
                 WHERE tran_id = p_tran_id AND gfun_fund_cd = p_gfun_fund_cd AND gibr_branch_cd = p_gibr_branch_cd)
      LOOP
         v_giac_acctrans_list.tran_id := i.tran_id;
         v_giac_acctrans_list.gfun_fund_cd := i.gfun_fund_cd;
         v_giac_acctrans_list.gibr_branch_cd := i.gibr_branch_cd;
         v_giac_acctrans_list.dsp_tran_date := i.tran_date;
         v_giac_acctrans_list.dsp_tran_flag := i.tran_flag;
         v_giac_acctrans_list.dsp_tran_class := i.tran_class;
         v_giac_acctrans_list.dsp_tran_class_no := i.tran_class_no;
         v_giac_acctrans_list.dsp_particulars := i.particulars;
         v_giac_acctrans_list.dsp_tran_year := i.tran_year;
         v_giac_acctrans_list.dsp_tran_month := i.tran_month;
         v_giac_acctrans_list.dsp_tran_seq_no := i.tran_seq_no;
         PIPE ROW (v_giac_acctrans_list);
      END LOOP;
   END;

   FUNCTION get_giis_currency_list
      RETURN giis_currency_list_tab PIPELINED
   IS
      v_giis_currency_list   giis_currency_list_type;
   BEGIN
      FOR i IN (SELECT main_currency_cd, currency_desc, currency_rt, short_name
                  FROM giis_currency)
      LOOP
         v_giis_currency_list.main_currency_cd := i.main_currency_cd;
         v_giis_currency_list.currency_desc := i.currency_desc;
         v_giis_currency_list.currency_rt := i.currency_rt;
         v_giis_currency_list.short_name := i.short_name;
         PIPE ROW (v_giis_currency_list);
      END LOOP;
   END;

   FUNCTION get_generation_type (p_module_name giac_modules.module_name%TYPE)
      RETURN VARCHAR2
   AS
      v_generation_type   giac_modules.generation_type%TYPE;
   BEGIN
      SELECT generation_type
        INTO v_generation_type
        FROM giac_modules
       WHERE UPPER (module_name) LIKE UPPER (p_module_name);

      RETURN v_generation_type;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN NULL;
   END;

   FUNCTION get_iss_cd_lov(
      p_module_id       GIIS_MODULES.module_id%TYPE,
      p_user_id         GIIS_USERS.user_id%TYPE,
      p_iss_cd          GIAC_AGING_SOA_DETAILS.iss_cd%TYPE,
      p_tran_type       GIAC_PREM_DEPOSIT.transaction_type%TYPE
   )
      RETURN iss_cd_list_tab PIPELINED
   IS
      v_iss_cd_list   iss_cd_list_type;
   BEGIN
      FOR i IN (SELECT x.iss_cd b140_iss_cd /* CG$FK */, x.prem_seq_no b140_prem_seq_no, x.inst_no inst_no,
                       x.a150_line_cd dsp_a150_line_cd, x.total_amount_due dsp_total_amount_due, x.total_payments dsp_total_payments,
                       x.temp_payments dsp_temp_payments, x.balance_amt_due dsp_balance_amt_due, x.a020_assd_no dsp_a020_assd_no,
                       y.assd_name
                  FROM giac_aging_soa_details x,
                       giis_assured y
                 WHERE x.a020_assd_no = y.assd_no
                   AND x.iss_cd = p_iss_cd
                   AND SIGN(x.total_amount_due) = DECODE(p_tran_type, 1, 1, -1) --marco - 01.07.2014 - display positive values for tran type 1; negative for tran type 3
                   AND (EXISTS (SELECT 1, a.user_grp, b.tran_cd --marco - 09.26.2014 - user access checking
                                 FROM giis_users a,
                                      giis_user_iss_cd b,
                                      giis_modules_tran c
                                WHERE a.user_id = b.userid
                                  AND a.user_id = p_user_id
                                  AND b.iss_cd = x.iss_cd
                                  AND b.tran_cd = c.tran_cd
                                  AND c.module_id = p_module_id
                                  AND (SELECT d.access_tag
                                         FROM GIIS_USER_MODULES d 
                                        WHERE d.userid = p_user_id
                                          AND d.tran_cd = b.tran_cd
                                          AND d.module_id = p_module_id) = 1)
                    OR EXISTS (SELECT 1, a.user_grp, b.tran_cd 
                                 FROM giis_users a,
                                      giis_user_grp_dtl b,
                                      giis_modules_tran c
                                WHERE a.user_grp = b.user_grp
                                  AND a.user_id = p_user_id
                                  AND b.iss_cd = x.iss_cd
                                  AND b.tran_cd = c.tran_cd
                                  AND c.module_id = p_module_id
                                  AND (SELECT d.access_tag
                                         FROM giis_user_grp_modules d 
                                        WHERE d.user_grp = a.user_grp
                                          AND d.tran_cd = b.tran_cd
                                          AND d.module_id = p_module_id) = 1))
                 ORDER BY x.iss_cd ASC)
      LOOP
         v_iss_cd_list.b140_iss_cd := i.b140_iss_cd;
         v_iss_cd_list.b140_prem_seq_no := i.b140_prem_seq_no;
         v_iss_cd_list.inst_no := i.inst_no;
         v_iss_cd_list.dsp_a150_line_cd := i.dsp_a150_line_cd;
         v_iss_cd_list.dsp_total_amount_due := i.dsp_total_amount_due;
         v_iss_cd_list.dsp_total_payments := i.dsp_total_payments;
         v_iss_cd_list.dsp_temp_payments := i.dsp_temp_payments;
         v_iss_cd_list.dsp_balance_amt_due := i.dsp_balance_amt_due;
         v_iss_cd_list.dsp_a020_assd_no := i.dsp_a020_assd_no;

         /* SELECT assd_name
           INTO v_iss_cd_list.assured_name
           FROM giis_assured
          WHERE assd_no = v_iss_cd_list.dsp_a020_assd_no; */

         PIPE ROW (v_iss_cd_list);
      END LOOP;
   END;

   FUNCTION get_ri_iss_cd_lov
      RETURN ri_iss_cd_list_tab PIPELINED
   IS
      v_ri_iss_cd_list   ri_iss_cd_list_type;
   BEGIN
      FOR i IN (SELECT   a180_ri_cd ri_cd, prem_seq_no b140_prem_seq_no, inst_no inst_no, a150_line_cd dsp_a150_line_cd,
                         total_amount_due dsp_total_amount_due, total_payments dsp_total_payments,
                         temp_payments dsp_temp_payments, balance_due dsp_balance_amt_due, a020_assd_no dsp_a020_assd_no
                    FROM giac_aging_ri_soa_details
                ORDER BY a180_ri_cd ASC)
      LOOP
         v_ri_iss_cd_list.ri_cd := i.ri_cd;
         v_ri_iss_cd_list.b140_prem_seq_no := i.b140_prem_seq_no;
         v_ri_iss_cd_list.inst_no := i.inst_no;
         v_ri_iss_cd_list.dsp_a150_line_cd := i.dsp_a150_line_cd;
         v_ri_iss_cd_list.dsp_total_amount_due := i.dsp_total_amount_due;
         v_ri_iss_cd_list.dsp_total_payments := i.dsp_total_payments;
         v_ri_iss_cd_list.dsp_temp_payments := i.dsp_temp_payments;
         v_ri_iss_cd_list.dsp_balance_amt_due := i.dsp_balance_amt_due;
         v_ri_iss_cd_list.dsp_a020_assd_no := i.dsp_a020_assd_no;
         v_ri_iss_cd_list.assured_name := get_assd_name(i.dsp_a020_assd_no); -- added by: Nica 1.25.2013
		 PIPE ROW (v_ri_iss_cd_list);
      END LOOP;

     /* FOR j IN (SELECT assd_name
                  FROM giis_assured
                 WHERE assd_no = v_ri_iss_cd_list.dsp_a020_assd_no)
      LOOP
         v_ri_iss_cd_list.assured_name := j.assd_name;
         PIPE ROW (v_ri_iss_cd_list);
      END LOOP;*/ -- commented by: Nica 1.25.2013
   END;

   FUNCTION get_assd_name_lov (
      p_assd_no        giis_assured.assd_no%TYPE,
      p_assured_name   giis_assured.assd_name%TYPE,
      p_find_text      VARCHAR2
   )
      RETURN assd_name_list_tab PIPELINED
   IS
      v_assd_name_list   assd_name_list_type;
   BEGIN
      FOR i IN (SELECT   assd_no, assd_name
                    FROM giis_assured
                   WHERE UPPER (assd_no) LIKE NVL (p_assd_no, assd_no)
                      --OR UPPER (assd_name) LIKE UPPER (NVL (p_find_text, assd_name))
                ORDER BY assd_name ASC)
      LOOP
         v_assd_name_list.assd_no := i.assd_no;
         v_assd_name_list.assured_name := i.assd_name;
         PIPE ROW (v_assd_name_list);
      END LOOP;
   END;

   FUNCTION get_intm_name_lov (
      p_intm_no     giis_intermediary.intm_no%TYPE,
      p_intm_name   giis_intermediary.intm_name%TYPE,
      p_find_text   VARCHAR2
   )
      RETURN intm_name_list_tab PIPELINED
   IS
      v_intm_name_list   intm_name_list_type;
   BEGIN
      FOR i IN (SELECT   intm_no, intm_name
                    FROM giis_intermediary
                   WHERE (   UPPER (intm_no) LIKE UPPER (NVL (p_find_text, intm_no))
                          OR UPPER (intm_name) LIKE UPPER (NVL (p_find_text, intm_name))
                         )
                ORDER BY intm_name ASC)
      LOOP
         v_intm_name_list.intm_no := i.intm_no;
         v_intm_name_list.intm_name := i.intm_name;
         PIPE ROW (v_intm_name_list);
      END LOOP;
   END;

   FUNCTION get_giac_pol_no_lov ( --edited by steven 12/18/2012
      /*p_policy_no     VARCHAR2,
      p_line_cd       gipi_polbasic.line_cd%TYPE,
      p_subline_cd    gipi_polbasic.subline_cd%TYPE,
      p_iss_cd        gipi_polbasic.iss_cd%TYPE,
      p_issue_yy      gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no      gipi_polbasic.renew_no%TYPE,
      p_assd_name     giis_assured.assd_name%TYPE,
      p_endt_seq_no   gipi_polbasic.endt_seq_no%TYPE,*/
	  p_assd_no		  GIIS_ASSURED.assd_no%TYPE,
      p_user_id       VARCHAR2,
      p_find_text     VARCHAR2
   )
      RETURN pol_no_list_tab PIPELINED
   IS
      v_pol_no_list   pol_no_list_type;
   BEGIN
      FOR i IN (SELECT B250.LINE_CD  LINE_CD
                  ,B250.SUBLINE_CD  SUBLINE_CD
                  ,B250.ISS_CD  ISS_CD
                  ,B250.ISSUE_YY  ISSUE_YY
                  ,B250.POL_SEQ_NO  POL_SEQ_NO
                  ,B250.RENEW_NO  RENEW_NO
                  ,B250.LINE_CD 
                    || '-'
                       || B250.SUBLINE_CD 
                    || '-' 
                    ||B250.ISS_CD  
                    || '-'
                    ||LTRIM (TO_CHAR (B250.ISSUE_YY, '09'))
                    || '-' 
                    ||LTRIM (TO_CHAR (B250.POL_SEQ_NO, '0999999'))
                    || '-' 
                    ||LTRIM (TO_CHAR (B250.RENEW_NO, '09')) POLICY_NO
                    --,get_policy_no (B250.policy_id) POLICY_NO
                  ,B250.ASSD_NO  ASSD_NO
                  ,B250.policy_id
                  --,A020.ASSD_NAME  DSP_ASSD_NAME2
                  --,A020.ASSD_NO ASSURED_NO1
                  ,A020.ASSD_NAME  
                  --,A020.ASSD_NAME  ASSURED_NAME2
                  ,B250.ENDT_SEQ_NO 
                  ,C260.line_cd par_line_cd 
                  ,C260.iss_cd par_iss_cd 
                  ,C260.par_yy par_yy
                  ,C260.par_seq_no par_seq_no 
                  ,C260.quote_seq_no quote_seq_no
                  ,C260.line_cd
                         || '-'
                         || C260.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (C260.par_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (C260.par_seq_no, '099999'))
                         || '-'
                         || LTRIM (TO_CHAR (C260.quote_seq_no, '09')) par_no
            FROM   GIPI_POLBASIC B250
                  ,GIIS_ASSURED A020
                  ,GIPI_PARLIST C260
            WHERE   B250.ENDT_SEQ_NO = 0
            AND    A020.ASSD_NO (+) = B250.ASSD_NO
            AND    A020.ASSD_NO = NVL(p_assd_no, A020.ASSD_NO)
            AND    C260.PAR_ID (+) = NVL(B250.PAR_ID,NULL)
            /*AND (   UPPER (B250.line_cd) LIKE UPPER (NVL (p_find_text, B250.line_cd))
                          OR UPPER (B250.subline_cd) LIKE UPPER (NVL (p_find_text, B250.subline_cd))
                          OR UPPER (B250.iss_cd) LIKE UPPER (NVL (p_find_text, B250.iss_cd))
                          OR B250.issue_yy LIKE NVL (p_find_text, B250.issue_yy)
                          OR B250.pol_seq_no LIKE NVL (p_find_text, B250.pol_seq_no)
                          OR B250.renew_no LIKE NVL (p_find_text, B250.renew_no)
                          OR UPPER (A020.assd_name) LIKE UPPER (NVL (p_find_text, A020.assd_name))
                          OR B250.endt_seq_no LIKE NVL (p_find_text, B250.endt_seq_no)
                         )*/ --comment out by john 10.13.2014
            AND ((SELECT access_tag
                              FROM giis_user_modules
                             WHERE userid = NVL (p_user_id, USER)   
                               AND module_id = 'GIACS026'
                               AND tran_cd IN (
                                      SELECT b.tran_cd         
                                        FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                       WHERE a.user_id = b.userid
                                         AND a.user_id = NVL (p_user_id, USER)
                                         AND b.iss_cd = C260.iss_cd
                                         AND b.tran_cd = c.tran_cd
                                         AND c.module_id = 'GIACS026')) = 1
                     OR (SELECT access_tag
                              FROM giis_user_grp_modules
                             WHERE module_id = 'GIACS026'
                               AND (user_grp, tran_cd) IN (
                                      SELECT a.user_grp, b.tran_cd
                                        FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                       WHERE a.user_grp = b.user_grp
                                         AND a.user_id = NVL (p_user_id, USER)
                                         AND b.iss_cd = C260.iss_cd
                                         AND b.tran_cd = c.tran_cd
                                         AND c.module_id = 'GIACS026')) = 1
                   )
              AND B250.POL_FLAG != (SELECT RV_LOW_VALUE
                                     FROM cg_ref_codes
                                    WHERE rv_domain = 'GIPI_POLBASIC.POL_FLAG'
                                      AND UPPER (rv_meaning) = UPPER ('Spoiled'))
            ORDER BY  B250.ASSD_NO ASC 
                  ,B250.LINE_CD ASC 
                  ,B250.SUBLINE_CD ASC 
                  ,B250.ISS_CD ASC 
                  ,B250.ISSUE_YY ASC 
                  ,B250.POL_SEQ_NO ASC 
                  ,B250.RENEW_NO ASC)
      LOOP
         v_pol_no_list.line_cd 		:= i.LINE_CD;
         v_pol_no_list.subline_cd 	:= i.SUBLINE_CD;
         v_pol_no_list.iss_cd 		:= i.ISS_CD;
         v_pol_no_list.issue_yy 	:= i.ISSUE_YY;
         v_pol_no_list.pol_seq_no 	:= i.POL_SEQ_NO;
         v_pol_no_list.renew_no 	:= i.RENEW_NO;
		 v_pol_no_list.policy_no 	:= i.POLICY_NO;
		 v_pol_no_list.assd_no 		:= i.ASSD_NO;
		 v_pol_no_list.policy_id 	:= i.POLICY_ID;
         v_pol_no_list.assd_name 	:= i.ASSD_NAME;
         v_pol_no_list.endt_seq_no 	:= i.ENDT_SEQ_NO;
		 
		 v_pol_no_list.par_line_cd  := i.par_line_cd;
		 v_pol_no_list.par_iss_cd  	:= i.par_iss_cd; 
		 v_pol_no_list.par_yy  		:= i.par_yy;
		 v_pol_no_list.par_seq_no  	:= i.par_seq_no;
		 v_pol_no_list.quote_seq_no := i.quote_seq_no;
		 v_pol_no_list.dsp_par_no 	:= i.par_no;
		 
         PIPE ROW (v_pol_no_list);
      END LOOP;
   END;
END giac_prem_deposit_pkg;
/


