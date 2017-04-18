/* Formatted on 2016/11/24 13:29 (Formatter Plus v4.8.8) */
CREATE OR REPLACE PACKAGE BODY cpi.giacs609_pkg
AS
   PROCEDURE get_parameters (
      p_user_id                 IN       VARCHAR2,
      p_branch_cd               OUT      giis_user_grp_hdr.grp_iss_cd%TYPE,
      p_branch_name             OUT      giac_branches.branch_name%TYPE,
      p_document_cd             OUT      giac_parameters.param_value_v%TYPE,
      p_jv_tran_type            OUT      giac_jv_trans.jv_tran_cd%TYPE,
      p_jv_tran_desc            OUT      giac_jv_trans.jv_tran_desc%TYPE,
      p_stale_check             OUT      giac_parameters.param_value_n%TYPE,
      p_stale_days              OUT      giac_parameters.param_value_n%TYPE,
      p_stale_mgr_chk           OUT      giac_parameters.param_value_n%TYPE,
      p_dflt_dcb_bank_cd        OUT      giac_dcb_users.bank_cd%TYPE,
      p_dflt_dcb_bank_name      OUT      giac_banks.bank_name%TYPE,
      p_dflt_dcb_bank_acct_cd   OUT      giac_dcb_users.bank_acct_cd%TYPE,
      p_dflt_dcb_bank_acct_no   OUT      giac_bank_accounts.bank_acct_no%TYPE,
      p_line_cd_tag             OUT      giac_payt_req_docs.line_cd_tag%TYPE,
      p_yy_tag                  OUT      giac_payt_req_docs.yy_tag%TYPE,
      p_mm_tag                  OUT      giac_payt_req_docs.mm_tag%TYPE,
      p_dflt_currency_cd        OUT      giac_parameters.param_value_n%TYPE,
      p_dflt_currency_sname     OUT      giis_currency.short_name%TYPE,
      p_dflt_currency_rt        OUT      giis_currency.currency_rt%TYPE
   )
   AS
   BEGIN
      p_document_cd := giacp.v ('FACUL_RI_PREM_PAYT_DOC');
      p_stale_check := giacp.n ('STALE_CHECK');
      p_stale_days := giacp.n ('STALE_DAYS');
      p_stale_mgr_chk := giacp.n ('STALE_MGR_CHK');
      p_dflt_currency_cd := NVL (giacp.n ('CURRENCY_CD'), 1);

      BEGIN
         SELECT a.grp_iss_cd
           INTO p_branch_cd
           FROM giis_user_grp_hdr a, giis_users b
          WHERE a.user_grp = b.user_grp AND b.user_id = p_user_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_branch_cd := NULL;
      END;

      BEGIN
         SELECT branch_name
           INTO p_branch_name
           FROM giac_branches
          WHERE gfun_fund_cd = variables_fund_cd AND branch_cd = p_branch_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_branch_name := NULL;
      END;

      FOR a IN (SELECT bank_cd, bank_acct_cd
                  FROM giac_dcb_users
                 WHERE gibr_fund_cd = variables_fund_cd
                   AND gibr_branch_cd = p_branch_cd
                   AND dcb_user_id = p_user_id)
      LOOP
         p_dflt_dcb_bank_cd := a.bank_cd;
         p_dflt_dcb_bank_acct_cd := a.bank_acct_cd;

         IF a.bank_cd IS NULL
         THEN
            FOR b IN (SELECT bank_cd, bank_acct_cd
                        FROM giac_branches
                       WHERE gfun_fund_cd = variables_fund_cd
                         AND branch_cd = p_branch_cd)
            LOOP
               p_dflt_dcb_bank_cd := b.bank_cd;
               p_dflt_dcb_bank_acct_cd := b.bank_acct_cd;
            END LOOP;
         END IF;
      END LOOP;

      IF p_dflt_dcb_bank_cd IS NOT NULL
      THEN
         FOR rec1 IN (SELECT bank_name
                        FROM giac_banks
                       WHERE bank_cd = p_dflt_dcb_bank_cd)
         LOOP
            p_dflt_dcb_bank_name := rec1.bank_name;
         END LOOP;

         FOR rec2 IN (SELECT bank_acct_no
                        FROM giac_bank_accounts
                       WHERE bank_cd = p_dflt_dcb_bank_cd
                         AND bank_acct_cd = p_dflt_dcb_bank_acct_cd)
         LOOP
            p_dflt_dcb_bank_acct_no := rec2.bank_acct_no;
         END LOOP;
      END IF;

      FOR c IN (SELECT jv_tran_cd, jv_tran_desc
                  FROM giac_jv_trans
                 WHERE jv_tran_tag = 'NC')
      LOOP
         p_jv_tran_type := c.jv_tran_cd;
         p_jv_tran_desc := c.jv_tran_desc;
         EXIT;
      END LOOP;

      BEGIN
         SELECT line_cd_tag, yy_tag, mm_tag
           INTO p_line_cd_tag, p_yy_tag, p_mm_tag
           FROM giac_payt_req_docs
          WHERE gibr_gfun_fund_cd = variables_fund_cd
            AND gibr_branch_cd = p_branch_cd
            AND document_cd = p_document_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_line_cd_tag := NULL;
            p_yy_tag := NULL;
            p_mm_tag := NULL;
      END;

      BEGIN
         SELECT short_name, currency_rt
           INTO p_dflt_currency_sname, p_dflt_currency_rt
           FROM giis_currency
          WHERE main_currency_cd = p_dflt_currency_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_dflt_currency_sname := NULL;
            p_dflt_currency_rt := NULL;
      END;
   END get_parameters;

   FUNCTION get_giacs609_header (
      p_source_cd   giac_upload_file.source_cd%TYPE,
      p_file_no     giac_upload_file.file_no%TYPE
   )
      RETURN get_giacs609_header_tab PIPELINED
   IS
      v_list   get_giacs609_header_type;
   BEGIN
      FOR i IN (SELECT source_cd, file_no, file_name, convert_date,
                       upload_date, file_status, no_of_records, tran_class,
                       tran_id, tran_date, remarks, ri_cd
                  FROM giac_upload_file
                 WHERE transaction_type = '4'
                   AND source_cd = NVL (p_source_cd, source_cd)
                   AND file_no = NVL (p_file_no, file_no))
      LOOP
         v_list.source_cd := i.source_cd;
         v_list.file_no := i.file_no;
         v_list.file_name := i.file_name;
         v_list.convert_date := i.convert_date;
         v_list.upload_date := i.upload_date;
         v_list.file_status := i.file_status;
         v_list.no_of_records := i.no_of_records;
         v_list.tran_class := i.tran_class;
         v_list.tran_id := i.tran_id;
         v_list.tran_date := i.tran_date;
         v_list.remarks := i.remarks;
         v_list.ri_cd := i.ri_cd;
         v_list.dsp_or_reg_jv := get_ref_no (i.tran_id);

         BEGIN
            SELECT source_name
              INTO v_list.dsp_source
              FROM giac_file_source
             WHERE source_cd = p_source_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.dsp_source := NULL;
         END;

         BEGIN
            SELECT ri_name
              INTO v_list.dsp_ri
              FROM giis_reinsurer
             WHERE ri_cd = i.ri_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.dsp_ri := NULL;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_giacs609_header;

   FUNCTION get_legend
      RETURN VARCHAR2
   AS
      v_legend   VARCHAR2 (32767);
   BEGIN
      FOR i IN (SELECT rv_low_value || ' - ' || rv_meaning legend
                  FROM cg_ref_codes
                 WHERE rv_domain = 'GIAC_UPLOAD_OUTFACUL_PREM.PREM_CHK_FLAG')
      LOOP
         IF v_legend IS NULL
         THEN
            v_legend := i.legend;
         ELSE
            v_legend := v_legend || CHR (10) || i.legend;
         END IF;
      END LOOP;

      RETURN v_legend;
   END get_legend;

   FUNCTION get_giacs609_records (
      p_source_cd       giac_upload_outfacul_prem.source_cd%TYPE,
      p_file_no         giac_upload_outfacul_prem.file_no%TYPE,
      p_binder_no       VARCHAR2,
      p_lprem_amt       giac_upload_outfacul_prem.lprem_amt%TYPE,
      p_lprem_vat       giac_upload_outfacul_prem.lprem_vat%TYPE,
      p_lcomm_amt       giac_upload_outfacul_prem.lcomm_amt%TYPE,
      p_lcomm_vat       giac_upload_outfacul_prem.lcomm_vat%TYPE,
      p_lwholding_vat   giac_upload_outfacul_prem.lwholding_vat%TYPE,
      p_ldisb_amt       giac_upload_outfacul_prem.ldisb_amt%TYPE,
      p_dsp_prem_diff   NUMBER,
      p_dsp_pvat_diff   NUMBER,
      p_dsp_camt_diff   NUMBER,
      p_dsp_cvat_diff   NUMBER,
      p_dsp_wvat_diff   NUMBER,
      p_prem_chk_flag   giac_upload_outfacul_prem.prem_chk_flag%TYPE,
      p_chk_remarks     giac_upload_outfacul_prem.chk_remarks%TYPE,
      p_from            NUMBER,
      p_to              NUMBER,
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2
   )
      RETURN giacs609_rec_tab PIPELINED
   IS
      TYPE cur_type IS REF CURSOR;

      c                cur_type;
      v_rec            giacs609_rec_type;
      v_sql            VARCHAR2 (9000);
      v_local_sw       giis_reinsurer.local_foreign_sw%TYPE;
      v_rate           giri_distfrps.currency_rt%TYPE;
      v_ri_cd          giac_upload_file.ri_cd%TYPE;
      v_tot_prem_due   NUMBER (16, 2);
      v_tot_pvat_due   NUMBER (16, 2);
      v_tot_camt_due   NUMBER (16, 2);
      v_tot_cvat_due   NUMBER (16, 2);
      v_tot_wvat_due   NUMBER (16, 2);
      v_count          NUMBER                                 := 0;
   BEGIN
      v_sql :=
         'SELECT mainsql.*
  FROM (SELECT COUNT (1) OVER () count_, outersql.*
          FROM (SELECT ROWNUM rownum_, innersql.*
                  FROM (SELECT line_cd, binder_yy, binder_seq_no,
                               line_cd || ''-'' || binder_yy || ''-'' || 
                               LTRIM (TO_CHAR (binder_seq_no, ''00000''))
                                                                    binder_no,
                               ldisb_amt, lprem_amt, lprem_vat, lcomm_amt,
                               lcomm_vat, lwholding_vat, prem_chk_flag,
                               chk_remarks,
                               DECODE (chk_remarks,
                                       NULL, NULL,
                                       NVL (prem_amt_due, 0) - NVL (lprem_amt, 0)
                                      ) dsp_prem_diff,
                               DECODE (chk_remarks,
                                       NULL, NULL,
                                       NVL (prem_vat_due, 0) - NVL (lprem_vat, 0)
                                      ) dsp_pvat_diff,
                               DECODE (chk_remarks,
                                       NULL, NULL,
                                       NVL (comm_amt_due, 0) - NVL (lcomm_amt, 0)
                                      ) dsp_camt_diff,
                               DECODE (chk_remarks,
                                       NULL, NULL,
                                       NVL (comm_vat_due, 0) - NVL (lcomm_vat, 0)
                                      ) dsp_cvat_diff,
                               DECODE (chk_remarks,
                                       NULL, NULL,
                                         NVL (wholding_vat_due, 0)
                                       - NVL (lwholding_vat, 0)
                                      ) dsp_wvat_diff, tran_date, fdisb_amt,
                               fprem_amt, fprem_vat, fcomm_amt, fcomm_vat,
                               fwholding_vat, currency_cd, convert_rate,
                               prem_amt_due, prem_vat_due, comm_amt_due,
                               comm_vat_due, wholding_vat_due
                          FROM giac_upload_outfacul_prem a
                         WHERE source_cd = :p_source_cd
                           AND file_no = :p_file_no) innersql
                 WHERE 1 = 1';

      IF p_binder_no IS NOT NULL
      THEN
         v_sql :=
             v_sql || ' AND binder_no LIKE UPPER (''' || p_binder_no || ''')';
      END IF;

      IF p_lprem_amt IS NOT NULL
      THEN
         v_sql := v_sql || ' AND lprem_amt = (''' || p_lprem_amt || ''')';
      END IF;

      IF p_lprem_vat IS NOT NULL
      THEN
         v_sql := v_sql || ' AND lprem_vat = (''' || p_lprem_vat || ''')';
      END IF;

      IF p_lcomm_amt IS NOT NULL
      THEN
         v_sql := v_sql || ' AND lcomm_amt = (''' || p_lcomm_amt || ''')';
      END IF;

      IF p_lcomm_vat IS NOT NULL
      THEN
         v_sql := v_sql || ' AND lcomm_vat = (''' || p_lcomm_vat || ''')';
      END IF;

      IF p_lwholding_vat IS NOT NULL
      THEN
         v_sql :=
              v_sql || ' AND lwholding_vat = (''' || p_lwholding_vat || ''')';
      END IF;

      IF p_ldisb_amt IS NOT NULL
      THEN
         v_sql := v_sql || ' AND ldisb_amt = (''' || p_ldisb_amt || ''')';
      END IF;

      IF p_dsp_prem_diff IS NOT NULL
      THEN
         v_sql :=
              v_sql || ' AND dsp_prem_diff = (''' || p_dsp_prem_diff || ''')';
      END IF;

      IF p_dsp_pvat_diff IS NOT NULL
      THEN
         v_sql :=
              v_sql || ' AND dsp_pvat_diff = (''' || p_dsp_pvat_diff || ''')';
      END IF;

      IF p_dsp_camt_diff IS NOT NULL
      THEN
         v_sql :=
              v_sql || ' AND dsp_camt_diff = (''' || p_dsp_camt_diff || ''')';
      END IF;

      IF p_dsp_cvat_diff IS NOT NULL
      THEN
         v_sql :=
              v_sql || ' AND dsp_cvat_diff = (''' || p_dsp_cvat_diff || ''')';
      END IF;

      IF p_dsp_wvat_diff IS NOT NULL
      THEN
         v_sql :=
              v_sql || ' AND dsp_wvat_diff = (''' || p_dsp_wvat_diff || ''')';
      END IF;

      IF p_prem_chk_flag IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' AND UPPER (prem_chk_flag) LIKE UPPER ('''
            || p_prem_chk_flag
            || ''')';
      END IF;

      IF p_chk_remarks IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' AND UPPER (chk_remarks) LIKE UPPER ('''
            || p_chk_remarks
            || ''')';
      END IF;

      IF p_order_by IS NOT NULL
      THEN
         IF p_order_by = 'binderNo'
         THEN
            v_sql := v_sql || ' ORDER BY binder_no ';
         ELSIF p_order_by = 'lpremAmt'
         THEN
            v_sql := v_sql || ' ORDER BY lprem_amt ';
         ELSIF p_order_by = 'lpremVat'
         THEN
            v_sql := v_sql || ' ORDER BY lprem_vat ';
         ELSIF p_order_by = 'lcommAmt'
         THEN
            v_sql := v_sql || ' ORDER BY lcomm_amt ';
         ELSIF p_order_by = 'lcommVat'
         THEN
            v_sql := v_sql || ' ORDER BY lcomm_vat ';
         ELSIF p_order_by = 'lwholdingVat'
         THEN
            v_sql := v_sql || ' ORDER BY lwholding_vat ';
         ELSIF p_order_by = 'ldisbAmt'
         THEN
            v_sql := v_sql || ' ORDER BY ldisb_amt ';
         ELSIF p_order_by = 'dspPremDiff'
         THEN
            v_sql := v_sql || ' ORDER BY dsp_prem_diff ';
         ELSIF p_order_by = 'dspPvatDiff'
         THEN
            v_sql := v_sql || ' ORDER BY dsp_pvat_diff ';
         ELSIF p_order_by = 'dspCamtDiff'
         THEN
            v_sql := v_sql || ' ORDER BY dsp_camt_diff ';
         ELSIF p_order_by = 'dspCvatDiff'
         THEN
            v_sql := v_sql || ' ORDER BY dsp_cvat_diff ';
         ELSIF p_order_by = 'dspWvatDiff'
         THEN
            v_sql := v_sql || ' ORDER BY dsp_wvat_diff ';
         ELSIF p_order_by = 'premChkFlag'
         THEN
            v_sql := v_sql || ' ORDER BY prem_chk_flag ';
         END IF;

         IF p_asc_desc_flag IS NOT NULL
         THEN
            v_sql := v_sql || p_asc_desc_flag;
         ELSE
            v_sql := v_sql || ' ASC';
         END IF;
      END IF;

      v_sql :=
            v_sql
         || ' ) outersql) mainsql WHERE rownum_ BETWEEN '
         || p_from
         || ' AND '
         || p_to;

      OPEN c FOR v_sql USING p_source_cd, p_file_no;

      LOOP
         FETCH c
          INTO v_rec.count_, v_rec.rownum_, v_rec.line_cd, v_rec.binder_yy,
               v_rec.binder_seq_no, v_rec.binder_no, v_rec.ldisb_amt,
               v_rec.lprem_amt, v_rec.lprem_vat, v_rec.lcomm_amt,
               v_rec.lcomm_vat, v_rec.lwholding_vat, v_rec.prem_chk_flag,
               v_rec.chk_remarks, v_rec.dsp_prem_diff, v_rec.dsp_pvat_diff,
               v_rec.dsp_camt_diff, v_rec.dsp_cvat_diff, v_rec.dsp_wvat_diff,
               v_rec.tran_date, v_rec.fdisb_amt, v_rec.fprem_amt,
               v_rec.fprem_vat, v_rec.fcomm_amt, v_rec.fcomm_vat,
               v_rec.fwholding_vat, v_rec.currency_cd, v_rec.convert_rate,
               v_rec.prem_amt_due, v_rec.prem_vat_due, v_rec.comm_amt_due,
               v_rec.comm_vat_due, v_rec.wholding_vat_due;

         v_count := v_count + 1;

         IF v_count = 1
         THEN
            BEGIN
               SELECT SUM (NVL (lprem_amt, 0)), SUM (NVL (lprem_vat, 0)),
                      SUM (NVL (lcomm_amt, 0)), SUM (NVL (lcomm_vat, 0)),
                      SUM (NVL (lwholding_vat, 0)),
                      SUM (NVL (ldisb_amt, 0)), SUM (NVL (prem_amt_due, 0)),
                      SUM (NVL (prem_vat_due, 0)),
                      SUM (NVL (comm_amt_due, 0)),
                      SUM (NVL (comm_vat_due, 0)),
                      SUM (NVL (wholding_vat_due, 0))
                 INTO v_rec.dsp_tot_prem, v_rec.dsp_tot_pvat,
                      v_rec.dsp_tot_comm, v_rec.dsp_tot_cvat,
                      v_rec.dsp_tot_wvat,
                      v_rec.dsp_tot_disb, v_tot_prem_due,
                      v_tot_pvat_due,
                      v_tot_camt_due,
                      v_tot_cvat_due,
                      v_tot_wvat_due
                 FROM giac_upload_outfacul_prem
                WHERE source_cd = p_source_cd
                  AND file_no = p_file_no
                  AND    line_cd
                      || '-'
                      || binder_yy
                      || '-'
                      || LTRIM (TO_CHAR (binder_seq_no, '00000')) LIKE
                                                NVL (UPPER (p_binder_no), '%')
                  AND lprem_amt = NVL (p_lprem_amt, lprem_amt)
                  AND lprem_vat = NVL (p_lprem_vat, lprem_vat)
                  AND lcomm_amt = NVL (p_lcomm_amt, lcomm_amt)
                  AND lcomm_vat = NVL (p_lcomm_vat, lcomm_vat)
                  AND lwholding_vat = NVL (p_lwholding_vat, lwholding_vat)
                  AND ldisb_amt = NVL (p_ldisb_amt, ldisb_amt)
                  AND DECODE (p_dsp_prem_diff,
                              NULL, 0,
                              DECODE (chk_remarks,
                                      NULL, 0,
                                        NVL (prem_amt_due, 0)
                                      - NVL (lprem_amt, 0)
                                     )
                             ) = NVL (p_dsp_prem_diff, 0)
                  AND DECODE (p_dsp_pvat_diff,
                              NULL, 0,
                              DECODE (chk_remarks,
                                      NULL, 0,
                                        NVL (prem_vat_due, 0)
                                      - NVL (lprem_vat, 0)
                                     )
                             ) = NVL (p_dsp_pvat_diff, 0)
                  AND DECODE (p_dsp_camt_diff,
                              NULL, 0,
                              DECODE (chk_remarks,
                                      NULL, 0,
                                        NVL (comm_amt_due, 0)
                                      - NVL (lcomm_amt, 0)
                                     )
                             ) = NVL (p_dsp_camt_diff, 0)
                  AND DECODE (p_dsp_cvat_diff,
                              NULL, 0,
                              DECODE (chk_remarks,
                                      NULL, 0,
                                        NVL (comm_vat_due, 0)
                                      - NVL (lcomm_vat, 0)
                                     )
                             ) = NVL (p_dsp_cvat_diff, 0)
                  AND DECODE (p_dsp_wvat_diff,
                              NULL, 0,
                              DECODE (chk_remarks,
                                      NULL, 0,
                                        NVL (wholding_vat_due, 0)
                                      - NVL (lwholding_vat, 0)
                                     )
                             ) = NVL (p_dsp_wvat_diff, 0)
                  AND UPPER (NVL (prem_chk_flag, '%')) LIKE
                                         (NVL (UPPER (p_prem_chk_flag), '%')
                                         )
                  AND UPPER (NVL (chk_remarks, '%')) LIKE
                                           (NVL (UPPER (p_chk_remarks), '%')
                                           );
            END;

            IF v_rec.chk_remarks IS NOT NULL
            THEN
               v_rec.dsp_tot_pdiff :=
                         NVL (v_tot_prem_due, 0)
                         - NVL (v_rec.dsp_tot_prem, 0);
               v_rec.dsp_tot_pvdiff :=
                         NVL (v_tot_pvat_due, 0)
                         - NVL (v_rec.dsp_tot_pvat, 0);
               v_rec.dsp_tot_cdiff :=
                         NVL (v_tot_camt_due, 0)
                         - NVL (v_rec.dsp_tot_comm, 0);
               v_rec.dsp_tot_cvdiff :=
                         NVL (v_tot_cvat_due, 0)
                         - NVL (v_rec.dsp_tot_cvat, 0);
               v_rec.dsp_tot_wvdiff :=
                         NVL (v_tot_wvat_due, 0)
                         - NVL (v_rec.dsp_tot_wvat, 0);
            END IF;

            BEGIN
               SELECT short_name, currency_desc
                 INTO v_rec.currency_sname, v_rec.currency_desc
                 FROM giis_currency
                WHERE main_currency_cd = v_rec.currency_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_rec.currency_sname := NULL;
                  v_rec.currency_desc := NULL;
            END;

            BEGIN
               SELECT local_foreign_sw, b.ri_cd
                 INTO v_local_sw, v_ri_cd
                 FROM giis_reinsurer a, giac_upload_file b
                WHERE b.source_cd = p_source_cd
                  AND b.file_no = p_file_no
                  AND a.ri_cd(+) = b.ri_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_local_sw := NULL;
            END;
         END IF;

         FOR rate IN (SELECT c.currency_rt
                        FROM giri_binder a,
                             giri_frps_ri b,
                             giri_distfrps c,
                             giuw_policyds d,
                             giuw_pol_dist e,
                             gipi_polbasic f
                       WHERE e.policy_id = f.policy_id
                         AND d.dist_no = e.dist_no
                         AND c.dist_no = d.dist_no
                         AND c.dist_seq_no = d.dist_seq_no
                         AND b.line_cd = c.line_cd
                         AND b.frps_yy = c.frps_yy
                         AND b.frps_seq_no = c.frps_seq_no
                         AND a.fnl_binder_id = b.fnl_binder_id
                         AND a.ri_cd = v_ri_cd
                         AND a.line_cd = v_rec.line_cd
                         AND a.binder_yy = v_rec.binder_yy
                         AND a.binder_seq_no = v_rec.binder_seq_no)
         LOOP
            v_rate := rate.currency_rt;
         END LOOP;

         IF v_rec.chk_remarks IS NOT NULL
         THEN
            v_rec.dsp_fprem_diff :=
                 (NVL (v_rec.prem_amt_due, 0) - v_rec.lprem_amt
                 )
               / v_rec.convert_rate;
            v_rec.dsp_fpvat_diff :=
                 (NVL (v_rec.prem_vat_due, 0) - v_rec.lprem_vat
                 )
               / v_rec.convert_rate;
            v_rec.dsp_fcamt_diff :=
                 (NVL (v_rec.comm_amt_due, 0) - v_rec.lcomm_amt
                 )
               / v_rec.convert_rate;
            v_rec.dsp_fcvat_diff :=
                 (NVL (v_rec.comm_vat_due, 0) - v_rec.lcomm_vat
                 )
               / v_rec.convert_rate;
            v_rec.dsp_fwvat_diff :=
                 (NVL (v_rec.wholding_vat_due, 0) - v_rec.lwholding_vat
                 )
               / v_rec.convert_rate;

            IF v_local_sw = 'L'
            THEN
               v_rec.dsp_fdisb_diff :=
                    (  (  (v_rec.dsp_fprem_diff + v_rec.dsp_fpvat_diff)
                        - (v_rec.dsp_fcamt_diff + v_rec.dsp_fcvat_diff)
                       )
                     * NVL (v_rate, 0)
                    )
                  - v_rec.fprem_amt;
            ELSE
               v_rec.dsp_fdisb_diff :=
                    (v_rec.dsp_fprem_diff + v_rec.dsp_fpvat_diff
                    )
                  - (  v_rec.dsp_fcamt_diff
                     + v_rec.dsp_fcvat_diff
                     + v_rec.dsp_fwvat_diff
                    );
            END IF;
         END IF;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_rec);
      END LOOP;
   END get_giacs609_records;

   FUNCTION get_colln_dtls (
      p_source_cd          giac_upload_colln_dtl.source_cd%TYPE,
      p_file_no            giac_upload_colln_dtl.file_no%TYPE,
      p_item_no            giac_upload_colln_dtl.item_no%TYPE,
      p_pay_mode           giac_upload_colln_dtl.pay_mode%TYPE,
      p_dsp_bank_sname     giac_banks.bank_sname%TYPE,
      p_dsp_class_mean     cg_ref_codes.rv_meaning%TYPE,
      p_check_no           giac_upload_colln_dtl.check_no%TYPE,
      p_check_date         VARCHAR2,
      p_amount             giac_upload_colln_dtl.amount%TYPE,
      p_fc_net             giac_upload_colln_dtl.fc_gross_amt%TYPE,
      p_dsp_short_name     giis_currency.short_name%TYPE,
      p_dcb_bank_cd        giac_upload_colln_dtl.dcb_bank_cd%TYPE,
      p_dcb_bank_acct_cd   giac_upload_colln_dtl.dcb_bank_acct_cd%TYPE,
      p_particulars        giac_upload_colln_dtl.particulars%TYPE,
      p_order_by           VARCHAR2,
      p_asc_desc_flag      VARCHAR2,
      p_from               NUMBER,
      p_to                 NUMBER
   )
      RETURN gucd_rec_tab PIPELINED
   AS
      TYPE cur_type IS REF CURSOR;

      c         cur_type;
      v_rec     gucd_rec_type;
      v_sql     VARCHAR2 (9000);
      v_count   NUMBER          := 0;
   BEGIN
      v_sql :=
         'SELECT mainsql.*
         FROM (SELECT COUNT (1) OVER () count_, outersql.*
                 FROM (SELECT ROWNUM rownum_, innersql.*
                         FROM (SELECT source_cd, file_no, item_no, pay_mode, amount,
                                      gross_amt, commission_amt, vat_amt, check_class,
                                      TO_CHAR (check_date, ''MM-DD-YYYY''), check_no,
                                      particulars, a.bank_cd, a.currency_cd,
                                      a.currency_rt, dcb_bank_cd, dcb_bank_acct_cd,
                                      fc_comm_amt, fc_vat_amt, fc_gross_amt, tran_id,
                                      b.bank_sname, c.short_name, d.rv_meaning,
                                      NVL (fc_gross_amt, 0) - NVL (fc_comm_amt, 0)
                                      - NVL (fc_vat_amt, 0) fc_net, c.currency_desc,
                                      b.bank_name
                                 FROM giac_upload_colln_dtl a,
                                      giac_banks b,
                                      giis_currency c,
                                      cg_ref_codes d
                                WHERE source_cd = :p_source_cd
                                  AND file_no = :p_file_no
                                  AND a.bank_cd = b.bank_cd(+)
                                  AND a.currency_cd = c.main_currency_cd
                                  AND d.rv_domain(+) = ''GIAC_COLLECTION_DTL.CHECK_CLASS''
                                  AND a.check_class = d.rv_low_value(+)';

      IF p_item_no IS NOT NULL
      THEN
         v_sql := v_sql || ' AND item_no = (''' || p_item_no || ''')';
      END IF;

      IF p_pay_mode IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' AND UPPER (pay_mode) LIKE UPPER ('''
            || p_pay_mode
            || ''')';
      END IF;

      IF p_dsp_bank_sname IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' AND UPPER (bank_sname) LIKE UPPER ('''
            || p_dsp_bank_sname
            || ''')';
      END IF;

      IF p_dsp_class_mean IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' AND UPPER (rv_meaning) LIKE UPPER ('''
            || p_dsp_class_mean
            || ''')';
      END IF;

      IF p_check_no IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' AND UPPER (check_no) LIKE UPPER ('''
            || p_check_no
            || ''')';
      END IF;

      IF p_check_date IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' AND TO_CHAR (check_date, ''MM-DD-YYYY'') LIKE UPPER ('''
            || p_check_date
            || ''')';
      END IF;

      IF p_amount IS NOT NULL
      THEN
         v_sql := v_sql || ' AND amount = (''' || p_amount || ''')';
      END IF;

      IF p_fc_net IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' AND NVL (fc_gross_amt, 0) - NVL (fc_comm_amt, 0)
                                      - NVL (fc_vat_amt, 0) = ('''
            || p_fc_net
            || ''')';
      END IF;

      IF p_dsp_short_name IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' AND UPPER (short_name) LIKE UPPER ('''
            || p_dsp_short_name
            || ''')';
      END IF;

      IF p_dcb_bank_cd IS NOT NULL
      THEN
         v_sql := v_sql || ' AND dcb_bank_cd = (''' || p_dcb_bank_cd || ''')';
      END IF;

      IF p_dcb_bank_acct_cd IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' AND dcb_bank_acct_cd = ('''
            || p_dcb_bank_acct_cd
            || ''')';
      END IF;

      IF p_particulars IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' AND UPPER (particulars) LIKE UPPER ('''
            || p_particulars
            || ''')';
      END IF;

      IF p_order_by IS NOT NULL
      THEN
         IF p_order_by = 'itemNo'
         THEN
            v_sql := v_sql || ' ORDER BY item_no ';
         ELSIF p_order_by = 'payMode'
         THEN
            v_sql := v_sql || ' ORDER BY pay_mode ';
         ELSIF p_order_by = 'dspBankSname'
         THEN
            v_sql := v_sql || ' ORDER BY bank_sname ';
         ELSIF p_order_by = 'dspClassMean'
         THEN
            v_sql := v_sql || ' ORDER BY rv_meaning ';
         ELSIF p_order_by = 'checkNo'
         THEN
            v_sql := v_sql || ' ORDER BY check_no ';
         ELSIF p_order_by = 'checkDate'
         THEN
            v_sql := v_sql || ' ORDER BY a.check_date ';
         ELSIF p_order_by = 'dspAmount'
         THEN
            v_sql := v_sql || ' ORDER BY amount ';
         ELSIF p_order_by = 'dspShortName'
         THEN
            v_sql := v_sql || ' ORDER BY short_name ';
         ELSIF p_order_by = 'dcbBankCd dcbBankAcctCd'
         THEN
            v_sql :=
                v_sql || ' ORDER BY dcb_bank_cd ||''-'' || dcb_bank_acct_cd ';
         END IF;

         IF p_asc_desc_flag IS NOT NULL
         THEN
            v_sql := v_sql || p_asc_desc_flag;
         ELSE
            v_sql := v_sql || ' ASC';
         END IF;
      END IF;

      v_sql := v_sql || ' )innersql  ) outersql) mainsql';

      IF p_from IS NOT NULL
      THEN
         v_sql :=
              v_sql || ' WHERE rownum_ BETWEEN ' || p_from || ' AND ' || p_to;
      END IF;

      OPEN c FOR v_sql USING p_source_cd, p_file_no;

      LOOP
         FETCH c
          INTO v_rec.count_, v_rec.rownum_, v_rec.source_cd, v_rec.file_no,
               v_rec.item_no, v_rec.pay_mode, v_rec.amount, v_rec.gross_amt,
               v_rec.commission_amt, v_rec.vat_amt, v_rec.check_class,
               v_rec.check_date, v_rec.check_no, v_rec.particulars,
               v_rec.bank_cd, v_rec.currency_cd, v_rec.currency_rt,
               v_rec.dcb_bank_cd, v_rec.dcb_bank_acct_cd, v_rec.fc_comm_amt,
               v_rec.fc_vat_amt, v_rec.fc_gross_amt, v_rec.tran_id,
               v_rec.dsp_bank_sname, v_rec.dsp_short_name,
               v_rec.dsp_class_mean, v_rec.dsp_fc_net, v_rec.dsp_ccy_desc,
               v_rec.dsp_bank_name;

         v_count := v_count + 1;

         BEGIN
            SELECT bank_name
              INTO v_rec.dsp_dcb_bank_name
              FROM giac_banks
             WHERE bank_cd = v_rec.dcb_bank_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.dsp_dcb_bank_name := NULL;
         END;

         BEGIN
            SELECT bank_acct_no
              INTO v_rec.dsp_dcb_bank_acct_no
              FROM giac_bank_accounts
             WHERE bank_cd = v_rec.dcb_bank_cd
               AND bank_acct_cd = v_rec.dcb_bank_acct_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.dsp_dcb_bank_acct_no := NULL;
         END;

         IF v_count = 1
         THEN
            BEGIN
               SELECT SUM (NVL (amount, 0)),
                      SUM (  NVL (fc_gross_amt, 0)
                           - NVL (fc_comm_amt, 0)
                           - NVL (fc_vat_amt, 0)
                          )
                 INTO v_rec.dsp_tot_loc,
                      v_rec.dsp_tot_fc
                 FROM giac_upload_colln_dtl
                WHERE source_cd = p_source_cd AND file_no = p_file_no;
            END;

            BEGIN
               SELECT MAX (item_no) + 1
                 INTO v_rec.next_item_no
                 FROM giac_upload_colln_dtl
                WHERE source_cd = p_source_cd AND file_no = p_file_no;
            END;
         END IF;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_rec);
      END LOOP;

      CLOSE c;
   END get_colln_dtls;

   PROCEDURE set_colln_dtls (p_rec giac_upload_colln_dtl%ROWTYPE)
   AS
   BEGIN
      MERGE INTO giac_upload_colln_dtl
         USING DUAL
         ON (    source_cd = p_rec.source_cd
             AND file_no = p_rec.file_no
             AND item_no = p_rec.item_no)
         WHEN NOT MATCHED THEN
            INSERT (source_cd, file_no, item_no, pay_mode, amount, gross_amt,
                    commission_amt, vat_amt, check_class, check_date,
                    check_no, particulars, bank_cd, currency_cd, currency_rt,
                    dcb_bank_cd, dcb_bank_acct_cd, fc_comm_amt, fc_vat_amt,
                    fc_gross_amt, tran_id)
            VALUES (p_rec.source_cd, p_rec.file_no, p_rec.item_no,
                    p_rec.pay_mode, p_rec.amount, p_rec.gross_amt,
                    p_rec.commission_amt, p_rec.vat_amt, p_rec.check_class,
                    p_rec.check_date, p_rec.check_no, p_rec.particulars,
                    p_rec.bank_cd, p_rec.currency_cd, p_rec.currency_rt,
                    p_rec.dcb_bank_cd, p_rec.dcb_bank_acct_cd,
                    p_rec.fc_comm_amt, p_rec.fc_vat_amt, p_rec.fc_gross_amt,
                    p_rec.tran_id)
         WHEN MATCHED THEN
            UPDATE
               SET pay_mode = p_rec.pay_mode, amount = p_rec.amount,
                   gross_amt = p_rec.gross_amt,
                   commission_amt = p_rec.commission_amt,
                   vat_amt = p_rec.vat_amt, check_class = p_rec.check_class,
                   check_date = p_rec.check_date, check_no = p_rec.check_no,
                   particulars = p_rec.particulars, bank_cd = p_rec.bank_cd,
                   currency_cd = p_rec.currency_cd,
                   currency_rt = p_rec.currency_rt,
                   dcb_bank_cd = p_rec.dcb_bank_cd,
                   dcb_bank_acct_cd = p_rec.dcb_bank_acct_cd,
                   fc_comm_amt = p_rec.fc_comm_amt,
                   fc_vat_amt = p_rec.fc_vat_amt,
                   fc_gross_amt = p_rec.fc_gross_amt, tran_id = p_rec.tran_id
            ;
   END set_colln_dtls;

   PROCEDURE del_colln_dtls (
      p_source_cd   IN   giac_upload_colln_dtl.source_cd%TYPE,
      p_file_no     IN   giac_upload_colln_dtl.file_no%TYPE,
      p_item_no     IN   giac_upload_colln_dtl.item_no%TYPE
   )
   AS
   BEGIN
      DELETE FROM giac_upload_colln_dtl
            WHERE source_cd = p_source_cd
              AND file_no = p_file_no
              AND item_no = NVL (p_item_no, item_no);
   END del_colln_dtls;

   FUNCTION get_tot_ldisb (
      p_source_cd   IN   giac_upload_colln_dtl.source_cd%TYPE,
      p_file_no     IN   giac_upload_colln_dtl.file_no%TYPE
   )
      RETURN NUMBER
   AS
      v_tot_ldisb   NUMBER (16, 2);
   BEGIN
      SELECT NVL (SUM (ldisb_amt), 0)
        INTO v_tot_ldisb
        FROM giac_upload_outfacul_prem
       WHERE source_cd = p_source_cd AND file_no = p_file_no;

      RETURN v_tot_ldisb;
   END get_tot_ldisb;

   FUNCTION get_bank_lov (p_keyword VARCHAR2)
      RETURN bank_lov_tab PIPELINED
   AS
      rec   bank_lov_type;
   BEGIN
      FOR i IN (SELECT   bank_cd, bank_name, bank_sname
                    FROM giac_banks
                   WHERE (   UPPER (bank_cd) LIKE NVL (UPPER (p_keyword), '%')
                          OR UPPER (bank_name) LIKE
                                                  NVL (UPPER (p_keyword), '%')
                          OR UPPER (bank_sname) LIKE
                                                  NVL (UPPER (p_keyword), '%')
                         )
                ORDER BY bank_sname)
      LOOP
         rec.bank_cd := i.bank_cd;
         rec.bank_name := i.bank_name;
         rec.bank_sname := i.bank_sname;
         PIPE ROW (rec);
      END LOOP;
   END get_bank_lov;

   FUNCTION get_dcb_bank_lov (p_keyword VARCHAR2)
      RETURN bank_lov_tab PIPELINED
   AS
      rec   bank_lov_type;
   BEGIN
      FOR i IN (SELECT   a.bank_cd, a.bank_name
                    FROM giac_banks a
                   WHERE EXISTS (
                            SELECT 1
                              FROM giac_bank_accounts b
                             WHERE b.bank_cd = a.bank_cd
                               AND b.opening_date < SYSDATE
                               AND NVL (b.closing_date, SYSDATE + 1) > SYSDATE)
                     AND (   UPPER (a.bank_cd) LIKE
                                                  NVL (UPPER (p_keyword), '%')
                          OR UPPER (a.bank_name) LIKE
                                                  NVL (UPPER (p_keyword), '%')
                         )
                ORDER BY a.bank_name)
      LOOP
         rec.bank_name := i.bank_name;
         rec.bank_cd := i.bank_cd;
         PIPE ROW (rec);
      END LOOP;
   END get_dcb_bank_lov;

   FUNCTION get_dcb_bank_acct_lov (
      p_dcb_bank_cd   giac_bank_accounts.bank_cd%TYPE,
      p_keyword       VARCHAR2
   )
      RETURN dcb_bank_acct_lov_tab PIPELINED
   AS
      rec   dcb_bank_acct_lov_type;
   BEGIN
      FOR i IN (SELECT bank_acct_cd, bank_acct_no
                  FROM giac_bank_accounts
                 WHERE bank_account_flag = 'A'
                   AND bank_cd = p_dcb_bank_cd
                   AND opening_date < SYSDATE
                   AND NVL (closing_date, SYSDATE + 1) > SYSDATE
                   AND (   UPPER (bank_acct_cd) LIKE
                                                  NVL (UPPER (p_keyword), '%')
                        OR UPPER (bank_acct_no) LIKE
                                                  NVL (UPPER (p_keyword), '%')
                       ))
      LOOP
         rec.bank_acct_cd := i.bank_acct_cd;
         rec.bank_acct_no := i.bank_acct_no;
         PIPE ROW (rec);
      END LOOP;
   END get_dcb_bank_acct_lov;

   FUNCTION get_or_lov (
      p_or_date         VARCHAR2,
      p_user_id         VARCHAR2,
      p_keyword         VARCHAR2,
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from            NUMBER,
      p_to              NUMBER
   )
      RETURN goop_lov_tab PIPELINED
   AS
      TYPE cur_type IS REF CURSOR;

      c        cur_type;
      v_list   goop_lov_type;
      v_sql    VARCHAR2 (9000);
   BEGIN
      v_sql :=
         'SELECT mainsql.*
         FROM (SELECT COUNT (1) OVER () count_, outersql.*
             FROM (SELECT ROWNUM rownum_, innersql.*
                 FROM (SELECT /*+ FIRST_ROWS(10) */
                       b.tran_id, a.gibr_branch_cd, a.dcb_no, a.particulars,
                       TO_CHAR (a.or_date, ''MM-DD-YYYY''),
                       DECODE (a.or_no, NULL, '''', a.or_pref_suf || ''-'' ||
                       LTRIM (TO_CHAR (a.or_no, ''0000000000'')))
                  FROM giac_order_of_payts a, giac_acctrans b
                 WHERE a.gibr_gfun_fund_cd = :p_fund_cd
                   AND TO_CHAR (a.or_date, ''MM-DD-YYYY'') = :p_or_date
                   AND a.gacc_tran_id = b.tran_id
                   AND b.tran_flag = ''O''
                   AND EXISTS (
                          SELECT 1
                            FROM giis_users c, giis_user_grp_hdr d
                           WHERE c.user_id = :p_user_id
                             AND c.user_grp = d.user_grp
                             AND a.gibr_branch_cd = d.grp_iss_cd)
                   AND (   UPPER (a.gibr_branch_cd) LIKE NVL (UPPER (:p_keyword), ''%'')
                        OR UPPER (TO_CHAR (a.or_date, ''MM-DD-YYYY'')) LIKE
                                                         NVL (UPPER (:p_keyword), ''%'')
                        OR UPPER (a.dcb_no) LIKE NVL (UPPER (:p_keyword), ''%'')
                        OR UPPER (a.particulars) LIKE NVL (UPPER (:p_keyword), ''%'')
                        OR UPPER (b.tran_id) LIKE NVL (UPPER (:p_keyword), ''%'')
                        OR UPPER (a.or_pref_suf) LIKE NVL (UPPER (:p_keyword), ''%'')
                        OR UPPER (a.or_no) LIKE NVL (UPPER (TRIM (LEADING 0 FROM :p_keyword)),
                                                 ''%'')
                        OR UPPER (a.or_pref_suf || ''-'' || a.or_no) LIKE
                                                         NVL (UPPER (:p_keyword), ''%'')
                        OR UPPER (a.or_pref_suf || ''-''
                                      || LTRIM (TO_CHAR (a.or_no, ''0000000000''))
                                     ) LIKE NVL (UPPER (:p_keyword), ''%'')
                       )';

      IF p_order_by IS NOT NULL
      THEN
         IF p_order_by = 'branchCd'
         THEN
            v_sql := v_sql || ' ORDER BY gibr_branch_cd ';
         ELSIF p_order_by = 'dcbNo'
         THEN
            v_sql := v_sql || ' ORDER BY dcb_no ';
         ELSIF p_order_by = 'particulars'
         THEN
            v_sql := v_sql || ' ORDER BY particulars ';
         ELSIF p_order_by = 'orDate'
         THEN
            v_sql := v_sql || ' ORDER BY a.or_date ';
         ELSIF p_order_by = 'orNo'
         THEN
            v_sql := v_sql || ' ORDER BY 6 ';
         END IF;

         IF p_asc_desc_flag IS NOT NULL
         THEN
            v_sql := v_sql || p_asc_desc_flag;
         ELSE
            v_sql := v_sql || ' ASC';
         END IF;
      END IF;

      v_sql :=
            v_sql
         || ' )innersql  ) outersql) mainsql WHERE rownum_ BETWEEN '
         || p_from
         || ' AND '
         || p_to;

      OPEN c FOR v_sql
      USING variables_fund_cd,
            p_or_date,
            p_user_id,
            p_keyword,
            p_keyword,
            p_keyword,
            p_keyword,
            p_keyword,
            p_keyword,
            p_keyword,
            p_keyword,
            p_keyword;

      LOOP
         FETCH c
          INTO v_list.count_, v_list.rownum_, v_list.tran_id,
               v_list.branch_cd, v_list.dcb_no, v_list.particulars,
               v_list.or_date, v_list.or_no;

         BEGIN
            SELECT 'Y'
              INTO v_list.has_colln_dtl
              FROM giac_collection_dtl
             WHERE gacc_tran_id = v_list.tran_id AND ROWNUM = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.has_colln_dtl := 'N';
         END;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_list);
      END LOOP;

      CLOSE c;
   END get_or_lov;

   FUNCTION get_or_colln_dtls (
      p_source_cd   giac_upload_colln_dtl.source_cd%TYPE,
      p_file_no     giac_upload_colln_dtl.file_no%TYPE,
      p_tran_id     giac_upload_colln_dtl.tran_id%TYPE
   )
      RETURN gucd_rec_tab PIPELINED
   IS
      v_rec   gucd_rec_type;
   BEGIN
      FOR i IN (SELECT   *
                    FROM giac_collection_dtl
                   WHERE gacc_tran_id = p_tran_id
                ORDER BY item_no)
      LOOP
         v_rec.source_cd := p_source_cd;
         v_rec.file_no := p_file_no;
         v_rec.item_no := i.item_no;
         v_rec.pay_mode := i.pay_mode;
         v_rec.amount := i.amount;
         v_rec.gross_amt := i.gross_amt;
         v_rec.commission_amt := i.commission_amt;
         v_rec.vat_amt := i.vat_amt;
         v_rec.check_class := i.check_class;
         v_rec.check_date := TO_CHAR (i.check_date, 'MM-DD-YYYY');
         v_rec.check_no := i.check_no;
         v_rec.bank_cd := i.bank_cd;
         v_rec.currency_cd := i.currency_cd;
         v_rec.currency_rt := i.currency_rt;
         v_rec.dcb_bank_cd := i.dcb_bank_cd;
         v_rec.dcb_bank_acct_cd := i.dcb_bank_acct_cd;
         v_rec.fc_comm_amt := i.fc_comm_amt;
         v_rec.fc_vat_amt := i.fc_tax_amt;
         v_rec.fc_gross_amt := i.fc_gross_amt;
         v_rec.dsp_fc_net := i.fcurrency_amt;
         v_rec.tran_id := i.gacc_tran_id;

         BEGIN
            SELECT bank_sname, bank_name
              INTO v_rec.dsp_bank_sname, v_rec.dsp_bank_name
              FROM giac_banks
             WHERE bank_cd = i.bank_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.dsp_bank_name := NULL;
               v_rec.dsp_bank_sname := NULL;
         END;

         BEGIN
            SELECT bank_name
              INTO v_rec.dsp_dcb_bank_name
              FROM giac_banks
             WHERE bank_cd = i.dcb_bank_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.dsp_dcb_bank_name := NULL;
         END;

         BEGIN
            SELECT bank_acct_no
              INTO v_rec.dsp_dcb_bank_acct_no
              FROM giac_bank_accounts
             WHERE bank_cd = i.dcb_bank_cd
               AND bank_acct_cd = i.dcb_bank_acct_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.dsp_dcb_bank_acct_no := NULL;
         END;

         BEGIN
            SELECT short_name, currency_desc
              INTO v_rec.dsp_short_name, v_rec.dsp_ccy_desc
              FROM giis_currency
             WHERE main_currency_cd = i.currency_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.dsp_short_name := NULL;
         END;

         BEGIN
            SELECT rv_meaning
              INTO v_rec.dsp_class_mean
              FROM cg_ref_codes
             WHERE rv_domain = 'GIAC_COLLECTION_DTL.CHECK_CLASS'
               AND rv_low_value = i.check_class;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.dsp_class_mean := NULL;
         END;

         v_rec.rownum_ := NVL (v_rec.rownum_, 0) + 1;

         IF v_rec.rownum_ = 1
         THEN
            BEGIN
               SELECT particulars
                 INTO v_rec.particulars
                 FROM giac_order_of_payts
                WHERE gacc_tran_id = p_tran_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_rec.particulars := NULL;
            END;
         END IF;

         v_rec.dsp_tot_loc :=
                             NVL (v_rec.dsp_tot_loc, 0)
                             + NVL (v_rec.amount, 0);
         v_rec.dsp_tot_fc :=
                          NVL (v_rec.dsp_tot_fc, 0)
                          + NVL (v_rec.dsp_fc_net, 0);
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_or_colln_dtls;

   PROCEDURE validate_colln_amt (
      p_source_cd   IN   giac_upload_colln_dtl.source_cd%TYPE,
      p_file_no     IN   giac_upload_colln_dtl.file_no%TYPE
   )
   AS
      v_tot_amount      NUMBER (16, 2);
   BEGIN
      SELECT NVL (SUM (amount), 0)
        INTO v_tot_amount
        FROM giac_upload_colln_dtl
       WHERE source_cd = p_source_cd AND file_no = p_file_no;

      IF v_tot_amount != 0
      THEN
         IF v_tot_amount != get_tot_ldisb (p_source_cd, p_file_no)
         THEN
            raise_application_error
               (-20001,
                   'Geniisys Exception#I#Local Currency Amount should be equal '
                || 'to the Total Collection Amount.'
               );
         END IF;
      END IF;
   END validate_colln_amt;

   FUNCTION get_dv_dtls (
      p_source_cd   giac_upload_file.source_cd%TYPE,
      p_file_no     giac_upload_file.file_no%TYPE,
      p_user_id     VARCHAR2
   )
      RETURN gudpd_rec_tab PIPELINED
   IS
      v_list   gudpd_rec_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM giac_upload_dv_payt_dtl
                 WHERE source_cd = p_source_cd AND file_no = p_file_no)
      LOOP
         v_list.file_no := i.file_no;
         v_list.source_cd := i.source_cd;
         v_list.document_cd := i.document_cd;
         v_list.branch_cd := i.branch_cd;
         v_list.line_cd := i.line_cd;
         v_list.doc_year := i.doc_year;
         v_list.doc_mm := i.doc_mm;
         v_list.doc_seq_no := i.doc_seq_no;
         v_list.dept_id := i.gouc_ouc_id;
         v_list.request_date := TO_CHAR (i.request_date, 'MM-DD-YYYY');
         v_list.payee_class_cd := i.payee_class_cd;
         v_list.payee_cd := i.payee_cd;
         v_list.payee := i.payee;
         v_list.particulars := i.particulars;
         v_list.dv_fcurrency_amt := i.dv_fcurrency_amt;
         v_list.currency_rt := i.currency_rt;
         v_list.payt_amt := i.payt_amt;
         v_list.currency_cd := i.currency_cd;
         v_list.tran_id := i.tran_id;
         v_list.dsp_dept_cd := NULL;
         v_list.dsp_dept_name := NULL;

         BEGIN
            SELECT ouc_cd, ouc_name
              INTO v_list.dsp_dept_cd, v_list.dsp_dept_name
              FROM giac_oucs
             WHERE ouc_id = i.gouc_ouc_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.dsp_dept_cd := NULL;
               v_list.dsp_dept_name := NULL;
         END;

         BEGIN
            SELECT short_name
              INTO v_list.dsp_fshort_name
              FROM giis_currency
             WHERE main_currency_cd = i.currency_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.dsp_fshort_name := NULL;
         END;

         BEGIN
            SELECT gprd.line_cd_tag, gprd.yy_tag, gprd.mm_tag
              INTO v_list.line_cd_tag, v_list.yy_tag, v_list.mm_tag
              FROM giac_payt_req_docs gprd
             WHERE gprd.gibr_gfun_fund_cd = variables_fund_cd
               AND gprd.gibr_branch_cd = i.branch_cd
               AND gprd.document_cd = i.document_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.line_cd_tag := NULL;
               v_list.yy_tag := NULL;
               v_list.mm_tag := NULL;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_dv_dtls;

   PROCEDURE set_dv_dtls (p_rec giac_upload_dv_payt_dtl%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giac_upload_dv_payt_dtl
         USING DUAL
         ON (source_cd = p_rec.source_cd AND file_no = p_rec.file_no)
         WHEN NOT MATCHED THEN
            INSERT (source_cd, file_no, document_cd, branch_cd, line_cd,
                    doc_year, doc_mm, doc_seq_no, gouc_ouc_id, request_date,
                    payee_class_cd, payee_cd, payee, particulars,
                    dv_fcurrency_amt, currency_rt, payt_amt, currency_cd,
                    tran_id)
            VALUES (p_rec.source_cd, p_rec.file_no, p_rec.document_cd,
                    p_rec.branch_cd, p_rec.line_cd, p_rec.doc_year,
                    p_rec.doc_mm, p_rec.doc_seq_no, p_rec.gouc_ouc_id,
                    p_rec.request_date, p_rec.payee_class_cd, p_rec.payee_cd,
                    p_rec.payee, p_rec.particulars, p_rec.dv_fcurrency_amt,
                    p_rec.currency_rt, p_rec.payt_amt, p_rec.currency_cd,
                    p_rec.tran_id)
         WHEN MATCHED THEN
            UPDATE
               SET document_cd = p_rec.document_cd,
                   branch_cd = p_rec.branch_cd, line_cd = p_rec.line_cd,
                   doc_year = p_rec.doc_year, doc_mm = p_rec.doc_mm,
                   doc_seq_no = p_rec.doc_seq_no,
                   gouc_ouc_id = p_rec.gouc_ouc_id,
                   request_date = p_rec.request_date,
                   payee_class_cd = p_rec.payee_class_cd,
                   payee_cd = p_rec.payee_cd, payee = p_rec.payee,
                   particulars = p_rec.particulars,
                   dv_fcurrency_amt = p_rec.dv_fcurrency_amt,
                   currency_rt = p_rec.currency_rt,
                   payt_amt = p_rec.payt_amt,
                   currency_cd = p_rec.currency_cd, tran_id = p_rec.tran_id
            ;
   END set_dv_dtls;

   PROCEDURE del_dv_dtls (p_source_cd VARCHAR2, p_file_no VARCHAR2)
   IS
   BEGIN
      DELETE FROM giac_upload_dv_payt_dtl
            WHERE source_cd = p_source_cd AND file_no = p_file_no;
   END del_dv_dtls;

   FUNCTION get_payt_rqst_lov (
      p_document_cd     VARCHAR2,
      p_user_id         VARCHAR2,
      p_keyword         VARCHAR2,
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from            NUMBER,
      p_to              NUMBER
   )
      RETURN gudpd_rec_tab PIPELINED
   AS
      TYPE cur_type IS REF CURSOR;

      c        cur_type;
      v_list   gudpd_rec_type;
      v_sql    VARCHAR2 (9000);
   BEGIN
      v_sql :=
         'SELECT mainsql.*
         FROM (SELECT COUNT (1) OVER () count_, outersql.*
             FROM (SELECT ROWNUM rownum_, innersql.*
                 FROM (SELECT /*+ INDEX(a gprq_pk) */
                       a.document_cd, a.branch_cd, a.line_cd, a.doc_year, a.doc_mm,
                       a.doc_seq_no, TO_CHAR (a.request_date, ''MM-DD-YYYY'') request_date,
                       c.ouc_id, c.ouc_cd, c.ouc_name, b.payee_class_cd, b.payee_cd, b.payee,
                       b.particulars, b.currency_cd, d.short_name, b.currency_rt,
                       b.dv_fcurrency_amt, b.payt_amt, b.tran_id
                  FROM giac_payt_requests a,
                       giac_payt_requests_dtl b,
                       giac_oucs c,
                       giis_currency d
                 WHERE a.ref_id = b.gprq_ref_id
                   AND a.gouc_ouc_id = c.ouc_id
                   AND b.currency_cd = d.main_currency_cd
                   AND a.fund_cd = :p_fund_cd
                   AND b.payt_req_flag = ''N''
                   AND a.document_cd = NVL (:p_document_cd, a.document_cd)
                   AND a.branch_cd =
                          DECODE (check_user_per_iss_cd_acctg2 (NULL,
                                                                a.branch_cd,
                                                                ''GIACS008'',
                                                                :p_user_id
                                                               ),
                                  1, a.branch_cd,
                                  NULL
                                 )
                   AND document_cd NOT IN (
                          SELECT param_value_v
                            FROM giac_parameters
                           WHERE param_name IN
                                       (''CLM_PAYT_REQ_DOC'', ''COMM_PAYT_DOC'', ''BATCH_CSR_DOC'')
                             AND param_value_v = a.document_cd)
                   AND (   UPPER (a.document_cd) LIKE NVL (UPPER (:p_keyword), ''%'')
                        OR UPPER (a.branch_cd) LIKE NVL (UPPER (:p_keyword), ''%'')
                        OR UPPER (a.line_cd) LIKE NVL (UPPER (:p_keyword), ''%'')
                        OR UPPER (a.doc_year) LIKE
                                            NVL (UPPER (TRIM (LEADING 0 FROM :p_keyword)),
                                                 ''%'')
                        OR UPPER (a.doc_mm) LIKE
                                            NVL (UPPER (TRIM (LEADING 0 FROM :p_keyword)),
                                                 ''%'')
                        OR UPPER (a.doc_seq_no) LIKE
                                            NVL (UPPER (TRIM (LEADING 0 FROM :p_keyword)),
                                                 ''%'')
                        OR UPPER (TO_CHAR (a.request_date, ''MM-DD-YYYY'')) LIKE
                                                                 NVL (UPPER (:p_keyword), ''%'')
                        OR UPPER (c.ouc_cd) LIKE NVL (UPPER (:p_keyword), ''%'')
                        OR UPPER (c.ouc_name) LIKE NVL (UPPER (:p_keyword), ''%'')
                        OR UPPER (b.payee_class_cd) LIKE NVL (UPPER (:p_keyword), ''%'')
                        OR UPPER (b.payee_cd) LIKE NVL (UPPER (:p_keyword), ''%'')
                        OR UPPER (b.payee) LIKE NVL (UPPER (:p_keyword), ''%'')
                        OR UPPER (b.particulars) LIKE NVL (UPPER (:p_keyword), ''%'')
                        OR UPPER (d.short_name) LIKE NVL (UPPER (:p_keyword), ''%'')
                        OR UPPER (b.currency_rt) LIKE
                                           NVL (UPPER (TRIM (TRAILING 0 FROM :p_keyword)),
                                                ''%'')
                        OR UPPER (b.dv_fcurrency_amt) LIKE NVL (UPPER (:p_keyword), ''%'')
                       )';

      IF p_order_by IS NOT NULL
      THEN
         IF p_order_by = 'documentCd'
         THEN
            v_sql := v_sql || ' ORDER BY document_cd ';
         ELSIF p_order_by = 'branchCd'
         THEN
            v_sql := v_sql || ' ORDER BY branch_cd ';
         ELSIF p_order_by = 'lineCd'
         THEN
            v_sql := v_sql || ' ORDER BY line_cd ';
         ELSIF p_order_by = 'docYear'
         THEN
            v_sql := v_sql || ' ORDER BY doc_year ';
         ELSIF p_order_by = 'docMm'
         THEN
            v_sql := v_sql || ' ORDER BY doc_mm ';
         ELSIF p_order_by = 'docSeqNo'
         THEN
            v_sql := v_sql || ' ORDER BY doc_seq_no ';
         ELSIF p_order_by = 'requestDate'
         THEN
            v_sql := v_sql || ' ORDER BY a.request_date ';
         ELSIF p_order_by = 'dspDeptCd'
         THEN
            v_sql := v_sql || ' ORDER BY ouc_cd ';
         ELSIF p_order_by = 'dspDeptName'
         THEN
            v_sql := v_sql || ' ORDER BY ouc_name ';
         ELSIF p_order_by = 'payeeClassCd'
         THEN
            v_sql := v_sql || ' ORDER BY payee_class_cd ';
         ELSIF p_order_by = 'payeeCd'
         THEN
            v_sql := v_sql || ' ORDER BY payee_cd ';
         ELSIF p_order_by = 'payee'
         THEN
            v_sql := v_sql || ' ORDER BY payee ';
         ELSIF p_order_by = 'particulars'
         THEN
            v_sql := v_sql || ' ORDER BY particulars ';
         ELSIF p_order_by = 'dspFshortName'
         THEN
            v_sql := v_sql || ' ORDER BY short_name ';
         ELSIF p_order_by = 'currencyRt'
         THEN
            v_sql := v_sql || ' ORDER BY currency_rt ';
         ELSIF p_order_by = 'dvFcurrencyAmt'
         THEN
            v_sql := v_sql || ' ORDER BY dv_fcurrency_amt ';
         END IF;

         IF p_asc_desc_flag IS NOT NULL
         THEN
            v_sql := v_sql || p_asc_desc_flag;
         ELSE
            v_sql := v_sql || ' ASC';
         END IF;
      END IF;

      v_sql :=
            v_sql
         || ' )innersql  ) outersql) mainsql WHERE rownum_ BETWEEN '
         || p_from
         || ' AND '
         || p_to;

      OPEN c FOR v_sql
      USING variables_fund_cd,
            p_document_cd,
            p_user_id,
            p_keyword,
            p_keyword,
            p_keyword,
            p_keyword,
            p_keyword,
            p_keyword,
            p_keyword,
            p_keyword,
            p_keyword,
            p_keyword,
            p_keyword,
            p_keyword,
            p_keyword,
            p_keyword,
            p_keyword,
            p_keyword;

      LOOP
         FETCH c
          INTO v_list.count_, v_list.rownum_, v_list.document_cd,
               v_list.branch_cd, v_list.line_cd, v_list.doc_year,
               v_list.doc_mm, v_list.doc_seq_no, v_list.request_date,
               v_list.dept_id, v_list.dsp_dept_cd, v_list.dsp_dept_name,
               v_list.payee_class_cd, v_list.payee_cd, v_list.payee,
               v_list.particulars, v_list.currency_cd,
               v_list.dsp_fshort_name, v_list.currency_rt,
               v_list.dv_fcurrency_amt, v_list.payt_amt, v_list.tran_id;

         BEGIN
            SELECT line_cd_tag, yy_tag, mm_tag
              INTO v_list.line_cd_tag, v_list.yy_tag, v_list.mm_tag
              FROM giac_payt_req_docs
             WHERE gibr_gfun_fund_cd = variables_fund_cd
               AND gibr_branch_cd = v_list.branch_cd
               AND document_cd = v_list.document_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.line_cd_tag := NULL;
               v_list.yy_tag := NULL;
               v_list.mm_tag := NULL;
         END;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_list);
      END LOOP;

      CLOSE c;
   END get_payt_rqst_lov;

   FUNCTION get_document_lov (
      p_branch_cd   giac_payt_req_docs.gibr_branch_cd%TYPE,
      p_keyword     VARCHAR2
   )
      RETURN document_lov_tab PIPELINED
   AS
      rec   document_lov_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT document_cd, document_name, line_cd_tag, yy_tag,
                          mm_tag
                     FROM giac_payt_req_docs a
                    WHERE gibr_gfun_fund_cd = variables_fund_cd
                      AND NOT EXISTS (
                             SELECT 1
                               FROM giac_parameters
                              WHERE param_name IN
                                       ('CLM_PAYT_REQ_DOC', 'COMM_PAYT_DOC',
                                        'BATCH_CSR_DOC')
                                AND param_value_v = a.document_cd)
                      AND gibr_branch_cd = NVL (p_branch_cd, gibr_branch_cd)
                      AND (   UPPER (document_cd) LIKE
                                                  NVL (UPPER (p_keyword), '%')
                           OR UPPER (document_name) LIKE
                                                  NVL (UPPER (p_keyword), '%')
                          )
                 ORDER BY document_cd)
      LOOP
         rec.document_cd := i.document_cd;
         rec.document_name := i.document_name;
         rec.line_cd_tag := i.line_cd_tag;
         rec.yy_tag := i.yy_tag;
         rec.mm_tag := i.mm_tag;
         PIPE ROW (rec);
      END LOOP;
   END get_document_lov;

   FUNCTION get_line_lov (p_keyword VARCHAR2)
      RETURN line_lov_tab PIPELINED
   AS
      rec   line_lov_type;
   BEGIN
      FOR i IN (SELECT   line_cd, line_name
                    FROM giis_line
                   WHERE (   UPPER (line_cd) LIKE NVL (UPPER (p_keyword), '%')
                          OR UPPER (line_name) LIKE
                                                  NVL (UPPER (p_keyword), '%')
                         )
                ORDER BY line_cd)
      LOOP
         rec.line_cd := i.line_cd;
         rec.line_name := i.line_name;
         PIPE ROW (rec);
      END LOOP;
   END get_line_lov;

   FUNCTION get_dept_lov (p_branch_cd VARCHAR2, p_keyword VARCHAR2)
      RETURN dept_lov_tab PIPELINED
   IS
      rec   dept_lov_type;
   BEGIN
      FOR i IN (SELECT   ouc_id, ouc_cd, ouc_name
                    FROM giac_oucs
                   WHERE gibr_gfun_fund_cd = variables_fund_cd
                     AND gibr_branch_cd = p_branch_cd
                     AND (   UPPER (ouc_cd) LIKE NVL (UPPER (p_keyword), '%')
                          OR UPPER (ouc_name) LIKE
                                                  NVL (UPPER (p_keyword), '%')
                         )
                ORDER BY ouc_cd)
      LOOP
         rec.dept_id := i.ouc_id;
         rec.dept_cd := i.ouc_cd;
         rec.dept_name := i.ouc_name;
         PIPE ROW (rec);
      END LOOP;

      RETURN;
   END get_dept_lov;

   FUNCTION get_payee_class_lov (p_keyword VARCHAR2)
      RETURN payee_class_lov_tab PIPELINED
   AS
      rec   payee_class_lov_type;
   BEGIN
      FOR i IN (SELECT   a.payee_class_cd, a.class_desc
                    FROM giis_payee_class a
                   WHERE payee_class_cd IN (SELECT b.payee_class_cd
                                              FROM giis_payees b)
                     AND (   UPPER (a.payee_class_cd) LIKE
                                                  NVL (UPPER (p_keyword), '%')
                          OR UPPER (a.class_desc) LIKE
                                                  NVL (UPPER (p_keyword), '%')
                         )
                ORDER BY a.payee_class_cd)
      LOOP
         rec.payee_class_cd := i.payee_class_cd;
         rec.class_desc := i.class_desc;
         PIPE ROW (rec);
      END LOOP;
   END get_payee_class_lov;

   FUNCTION get_payee_lov (
      p_payee_class_cd   giis_payees.payee_class_cd%TYPE,
      p_keyword          VARCHAR2
   )
      RETURN payee_lov_tab PIPELINED
   AS
      rec   payee_lov_type;
   BEGIN
      FOR i IN
         (SELECT   a.payee_no, a.payee_last_name, a.payee_first_name,
                   a.payee_middle_name
              FROM giis_payees a
             WHERE a.payee_class_cd = p_payee_class_cd
               AND (   UPPER (a.payee_no) LIKE NVL (UPPER (p_keyword), '%')
                    OR UPPER (a.payee_last_name) LIKE
                                                  NVL (UPPER (p_keyword), '%')
                    OR UPPER (a.payee_first_name) LIKE
                                                  NVL (UPPER (p_keyword), '%')
                    OR UPPER (a.payee_middle_name) LIKE
                                                  NVL (UPPER (p_keyword), '%')
                   )
          ORDER BY a.payee_class_cd)
      LOOP
         rec.payee_no := i.payee_no;
         rec.payee_first_name := i.payee_first_name;
         rec.payee_middle_name := i.payee_middle_name;
         rec.payee_last_name := i.payee_last_name;

         IF i.payee_first_name IS NOT NULL
         THEN
            rec.dsp_payee :=
               REGEXP_REPLACE (   i.payee_first_name
                               || ' '
                               || i.payee_middle_name
                               || ' '
                               || i.payee_last_name,
                               '( ){2,}',
                               ' '
                              );
         ELSE
            rec.dsp_payee := i.payee_last_name;
         END IF;

         PIPE ROW (rec);
      END LOOP;
   END get_payee_lov;

   FUNCTION get_jv_dtls (
      p_source_cd   giac_upload_jv_payt_dtl.source_cd%TYPE,
      p_file_no     giac_upload_jv_payt_dtl.file_no%TYPE,
      p_user_id     VARCHAR2
   )
      RETURN gujpd_rec_tab PIPELINED
   IS
      v_list   gujpd_rec_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM giac_upload_jv_payt_dtl
                 WHERE source_cd = p_source_cd AND file_no = p_file_no)
      LOOP
         v_list.source_cd := i.source_cd;
         v_list.file_no := i.file_no;
         v_list.branch_cd := i.branch_cd;
         v_list.tran_date := TO_CHAR (i.tran_date, 'MM-DD-YYYY');
         v_list.jv_tran_tag := i.jv_tran_tag;
         v_list.jv_tran_type := i.jv_tran_type;
         v_list.jv_tran_mm := i.jv_tran_mm;
         v_list.jv_tran_yy := i.jv_tran_yy;
         v_list.tran_year := i.tran_year;
         v_list.tran_month := i.tran_month;
         v_list.tran_seq_no := i.tran_seq_no;
         v_list.jv_pref_suff := i.jv_pref_suff;
         v_list.jv_no := i.jv_no;
         v_list.particulars := i.particulars;
         v_list.tran_id := i.tran_id;

         BEGIN
            SELECT branch_name
              INTO v_list.dsp_branch_name
              FROM giac_branches
             WHERE gfun_fund_cd = variables_fund_cd
                   AND branch_cd = i.branch_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.dsp_branch_name := NULL;
         END;

         BEGIN
            SELECT jv_tran_desc
              INTO v_list.dsp_jv_tran_desc
              FROM giac_jv_trans
             WHERE jv_tran_cd = i.jv_tran_type;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.dsp_jv_tran_desc := NULL;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_jv_dtls;

   PROCEDURE set_jv_dtls (p_rec giac_upload_jv_payt_dtl%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giac_upload_jv_payt_dtl
         USING DUAL
         ON (source_cd = p_rec.source_cd AND file_no = p_rec.file_no)
         WHEN NOT MATCHED THEN
            INSERT (source_cd, file_no, branch_cd, tran_date, jv_tran_tag,
                    jv_tran_type, jv_tran_mm, jv_tran_yy, tran_year,
                    tran_month, tran_seq_no, jv_pref_suff, jv_no,
                    particulars, tran_id)
            VALUES (p_rec.source_cd, p_rec.file_no, p_rec.branch_cd,
                    p_rec.tran_date, p_rec.jv_tran_tag, p_rec.jv_tran_type,
                    p_rec.jv_tran_mm, p_rec.jv_tran_yy, p_rec.tran_year,
                    p_rec.tran_month, p_rec.tran_seq_no, p_rec.jv_pref_suff,
                    p_rec.jv_no, p_rec.particulars, p_rec.tran_id)
         WHEN MATCHED THEN
            UPDATE
               SET branch_cd = p_rec.branch_cd, tran_date = p_rec.tran_date,
                   jv_tran_tag = p_rec.jv_tran_tag,
                   jv_tran_type = p_rec.jv_tran_type,
                   jv_tran_mm = p_rec.jv_tran_mm,
                   jv_tran_yy = p_rec.jv_tran_yy,
                   tran_year = p_rec.tran_year,
                   tran_month = p_rec.tran_month,
                   tran_seq_no = p_rec.tran_seq_no,
                   jv_pref_suff = p_rec.jv_pref_suff, jv_no = p_rec.jv_no,
                   particulars = p_rec.particulars, tran_id = p_rec.tran_id
            ;
   END set_jv_dtls;

   PROCEDURE del_jv_dtls (
      p_source_cd   giac_upload_jv_payt_dtl.source_cd%TYPE,
      p_file_no     giac_upload_jv_payt_dtl.file_no%TYPE
   )
   IS
   BEGIN
      DELETE FROM giac_upload_jv_payt_dtl
            WHERE source_cd = p_source_cd AND file_no = p_file_no;
   END del_jv_dtls;

   FUNCTION get_jv_tran_type_lov (
      p_jv_tran_tag   giac_jv_trans.jv_tran_tag%TYPE,
      p_keyword       VARCHAR2,
      p_row_num       NUMBER
   )
      RETURN jv_tran_type_tab PIPELINED
   AS
      rec   jv_tran_type_type;
   BEGIN
      FOR i IN (SELECT jv_tran_cd, jv_tran_desc
                  FROM giac_jv_trans
                 WHERE jv_tran_tag = p_jv_tran_tag
                   AND (   UPPER (jv_tran_cd) LIKE
                                                  NVL (UPPER (p_keyword), '%')
                        OR UPPER (jv_tran_desc) LIKE
                                                  NVL (UPPER (p_keyword), '%')
                       )
                   AND ROWNUM <= DECODE (p_row_num, NULL, ROWNUM, p_row_num))
      LOOP
         rec.jv_tran_type := i.jv_tran_cd;
         rec.jv_tran_desc := i.jv_tran_desc;
         PIPE ROW (rec);
      END LOOP;
   END get_jv_tran_type_lov;

   FUNCTION get_jv_lov (
      p_tran_date       VARCHAR2,
      p_user_id         VARCHAR2,
      p_keyword         VARCHAR2,
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from            NUMBER,
      p_to              NUMBER
   )
      RETURN gujpd_rec_tab PIPELINED
   AS
      TYPE cur_type IS REF CURSOR;

      c        cur_type;
      v_list   gujpd_rec_type;
      v_sql    VARCHAR2 (9000);
   BEGIN
      v_sql :=
         'SELECT mainsql.*
         FROM (SELECT COUNT (1) OVER () count_, outersql.*
             FROM (SELECT ROWNUM rownum_, innersql.*
                 FROM (SELECT gibr_branch_cd, TO_CHAR (tran_date, ''MM-DD-YYYY'') tran_date,
                          jv_tran_tag, jv_tran_type, jv_tran_mm, jv_tran_yy, tran_year,
                          tran_month, tran_seq_no, jv_pref_suff, jv_no, particulars, tran_id
                     FROM giac_acctrans a
                    WHERE gfun_fund_cd = :p_fund_cd
                      AND tran_class = ''JV''
                      AND tran_flag = ''O''
                      AND DECODE (:p_tran_date, NULL, ''%'', TO_CHAR (tran_date, ''MM-DD-YYYY'')) =
                                                       NVL (:p_tran_date, ''%'')
                      AND gibr_branch_cd =
                             DECODE (check_user_per_iss_cd_acctg2 (NULL,
                                                                   gibr_branch_cd,
                                                                   ''GIACS003'',
                                                                   :p_user_id
                                                                  ),
                                     1, gibr_branch_cd, NULL)
                      AND (   UPPER (gibr_branch_cd) LIKE NVL (UPPER (:p_keyword), ''%'')
                           OR UPPER (TO_CHAR (tran_date, ''MM-DD-YYYY'')) LIKE NVL (UPPER (:p_keyword), ''%'')
                           OR UPPER (jv_tran_tag) LIKE NVL (UPPER (:p_keyword), ''%'')
                           OR UPPER (jv_tran_type) LIKE NVL (UPPER (:p_keyword), ''%'')
                           OR UPPER (jv_tran_mm) LIKE NVL (UPPER (TRIM (LEADING 0 FROM :p_keyword)), ''%'')
                           OR UPPER (jv_tran_yy) LIKE NVL (UPPER (:p_keyword), ''%'')
                           OR UPPER (tran_year) LIKE NVL (UPPER (:p_keyword), ''%'')
                           OR UPPER (tran_month) LIKE NVL (UPPER (TRIM (LEADING 0 FROM :p_keyword)), ''%'')
                           OR UPPER (tran_seq_no) LIKE NVL (UPPER (TRIM (LEADING 0 FROM :p_keyword)), ''%'')
                           OR UPPER (jv_pref_suff) LIKE NVL (UPPER (:p_keyword), ''%'')
                           OR UPPER (jv_no) LIKE NVL (UPPER (TRIM (LEADING 0 FROM :p_keyword)), ''%'')
                           OR UPPER (particulars) LIKE NVL (UPPER (:p_keyword), ''%'')
                          )';

      IF p_order_by IS NOT NULL
      THEN
         IF p_order_by = 'branchCd'
         THEN
            v_sql := v_sql || ' ORDER BY gibr_branch_cd ';
         ELSIF p_order_by = 'tranDate'
         THEN
            v_sql := v_sql || ' ORDER BY a.tran_date ';
         ELSIF p_order_by = 'jvTranTag'
         THEN
            v_sql := v_sql || ' ORDER BY jv_tran_tag ';
         ELSIF p_order_by = 'jvTranType'
         THEN
            v_sql := v_sql || ' ORDER BY jv_tran_type ';
         ELSIF p_order_by = 'jvTranMm'
         THEN
            v_sql := v_sql || ' ORDER BY jv_tran_mm ';
         ELSIF p_order_by = 'jvTranYy'
         THEN
            v_sql := v_sql || ' ORDER BY jv_tran_yy ';
         ELSIF p_order_by = 'tranYear'
         THEN
            v_sql := v_sql || ' ORDER BY tran_year ';
         ELSIF p_order_by = 'tranMonth'
         THEN
            v_sql := v_sql || ' ORDER BY tran_month ';
         ELSIF p_order_by = 'tranSeqNo'
         THEN
            v_sql := v_sql || ' ORDER BY tran_seq_no ';
         ELSIF p_order_by = 'jvPrefSuff'
         THEN
            v_sql := v_sql || ' ORDER BY jv_pref_suff ';
         ELSIF p_order_by = 'jvNo'
         THEN
            v_sql := v_sql || ' ORDER BY jv_no ';
         ELSIF p_order_by = 'particulars'
         THEN
            v_sql := v_sql || ' ORDER BY particulars ';
         END IF;

         IF p_asc_desc_flag IS NOT NULL
         THEN
            v_sql := v_sql || p_asc_desc_flag;
         ELSE
            v_sql := v_sql || ' ASC';
         END IF;
      END IF;

      v_sql :=
            v_sql
         || ' )innersql  ) outersql) mainsql WHERE rownum_ BETWEEN '
         || p_from
         || ' AND '
         || p_to;

      OPEN c FOR v_sql
      USING variables_fund_cd,
            p_tran_date,
            p_tran_date,
            p_user_id,
            p_keyword,
            p_keyword,
            p_keyword,
            p_keyword,
            p_keyword,
            p_keyword,
            p_keyword,
            p_keyword,
            p_keyword,
            p_keyword,
            p_keyword,
            p_keyword;

      LOOP
         FETCH c
          INTO v_list.count_, v_list.rownum_, v_list.branch_cd,
               v_list.tran_date, v_list.jv_tran_tag, v_list.jv_tran_type,
               v_list.jv_tran_mm, v_list.jv_tran_yy, v_list.tran_year,
               v_list.tran_month, v_list.tran_seq_no, v_list.jv_pref_suff,
               v_list.jv_no, v_list.particulars, v_list.tran_id;

         BEGIN
            SELECT branch_name
              INTO v_list.dsp_branch_name
              FROM giac_branches
             WHERE gfun_fund_cd = variables_fund_cd
               AND branch_cd = v_list.branch_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.dsp_branch_name := NULL;
         END;

         BEGIN
            SELECT jv_tran_desc
              INTO v_list.dsp_jv_tran_desc
              FROM giac_jv_trans
             WHERE jv_tran_cd = v_list.jv_tran_type;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.dsp_jv_tran_desc := NULL;
         END;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_list);
      END LOOP;

      CLOSE c;
   END get_jv_lov;

   FUNCTION get_currency_lov (p_keyword VARCHAR2)
      RETURN currency_lov_tab PIPELINED
   AS
      rec   currency_lov_type;
   BEGIN
      FOR i IN (SELECT   short_name, currency_desc, main_currency_cd,
                         currency_rt
                    FROM giis_currency
                   WHERE (   UPPER (main_currency_cd) LIKE
                                                  NVL (UPPER (p_keyword), '%')
                          OR UPPER (short_name) LIKE
                                                  NVL (UPPER (p_keyword), '%')
                          OR UPPER (currency_desc) LIKE
                                                  NVL (UPPER (p_keyword), '%')
                         )
                ORDER BY main_currency_cd)
      LOOP
         rec.short_name := i.short_name;
         rec.currency_desc := i.currency_desc;
         rec.main_currency_cd := i.main_currency_cd;
         rec.currency_rt := i.currency_rt;
         PIPE ROW (rec);
      END LOOP;
   END get_currency_lov;

   FUNCTION get_branch_lov (
      p_module_id   VARCHAR2,
      p_user_id     VARCHAR2,
      p_keyword     VARCHAR2,
      p_doc_cd      VARCHAR2,
      p_dept_id     VARCHAR2
   )
      RETURN branch_lov_tab PIPELINED
   AS
      rec   branch_lov_type;
   BEGIN
      FOR i IN
         (SELECT   branch_cd, branch_name
              FROM giac_branches
             WHERE gfun_fund_cd = variables_fund_cd
               AND branch_cd =
                      DECODE (check_user_per_iss_cd_acctg2 (NULL,
                                                            branch_cd,
                                                            p_module_id,
                                                            p_user_id
                                                           ),
                              1, branch_cd,
                              NULL
                             )
               AND (   UPPER (branch_cd) LIKE NVL (UPPER (p_keyword), '%')
                    OR UPPER (branch_name) LIKE NVL (UPPER (p_keyword), '%')
                   )
          ORDER BY branch_cd)
      LOOP
         rec.branch_cd := i.branch_cd;
         rec.branch_name := i.branch_name;

         IF p_module_id = 'GIACS008'
         THEN
            BEGIN
               SELECT 'Y', line_cd_tag, yy_tag,
                      mm_tag
                 INTO rec.doc_cd_exists, rec.line_cd_tag, rec.yy_tag,
                      rec.mm_tag
                 FROM giac_payt_req_docs gprd
                WHERE gprd.gibr_gfun_fund_cd = variables_fund_cd
                  AND gprd.gibr_branch_cd = i.branch_cd
                  AND gprd.document_cd = p_doc_cd
                  AND NOT EXISTS (
                         SELECT 1
                           FROM giac_parameters
                          WHERE param_name IN
                                   ('CLM_PAYT_REQ_DOC', 'COMM_PAYT_DOC',
                                    'BATCH_CSR_DOC')
                            AND param_value_v = gprd.document_cd);
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  rec.doc_cd_exists := 'N';
                  rec.line_cd_tag := NULL;
                  rec.yy_tag := NULL;
                  rec.mm_tag := NULL;
            END;

            BEGIN
               SELECT 'Y'
                 INTO rec.dept_id_exists
                 FROM giac_oucs gouc
                WHERE gouc.gibr_gfun_fund_cd = variables_fund_cd
                  AND gouc.gibr_branch_cd = i.branch_cd
                  AND gouc.ouc_id = p_dept_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  rec.dept_id_exists := 'N';
            END;
         END IF;

         PIPE ROW (rec);
      END LOOP;
   END get_branch_lov;

   PROCEDURE check_data (
      p_source_cd   giac_upload_file.source_cd%TYPE,
      p_file_no     giac_upload_file.file_no%TYPE,
      p_override    VARCHAR2
   )
   IS
      v_prem_chk_flag      giac_upload_outfacul_prem.prem_chk_flag%TYPE;
      v_chk_remarks        giac_upload_outfacul_prem.chk_remarks%TYPE;
      v_ri_name            giis_reinsurer.ri_name%TYPE;
      v_prem_amt           NUMBER;
      v_prem_vat           NUMBER;
      v_comm_amt           NUMBER;
      v_comm_vat           NUMBER;
      v_wholding           NUMBER;
      v_binder_prem_amt    NUMBER;
      v_binder_prem_vat    NUMBER;
      v_binder_comm_amt    NUMBER;
      v_binder_comm_vat    NUMBER;
      v_binder_wholding    NUMBER;
      v_payt_prem_amt      NUMBER;
      v_payt_prem_vat      NUMBER;
      v_payt_comm_amt      NUMBER;
      v_payt_comm_vat      NUMBER;
      v_payt_wholding      NUMBER;
      v_payt_disb          NUMBER;
      v_payt_exist         VARCHAR2 (1);
      v_binder_disb        NUMBER;
      v_disbursement       NUMBER;
      v_ri_prem_amt        giri_binder.ri_prem_amt%TYPE;
      v_out_prem           giac_outfacul_prem_payts.prem_amt%TYPE;
      v_total_payable      giri_binder.ri_prem_amt%TYPE;
      v_total_receivable   gipi_invoice.prem_amt%TYPE;
      v_direct_prem        giac_direct_prem_collns.premium_amt%TYPE;
      v_actual_payments    giac_outfacul_prem_payts.disbursement_amt%TYPE;
      v_percent_pay        NUMBER;
      v_remaining_amt      NUMBER;
      v_allowable          NUMBER;
      v_binder_id          giri_binder.fnl_binder_id%TYPE;
      v_reverse_date       giri_binder.reverse_date%TYPE;
      v_tran_type          giac_outfacul_prem_payts.transaction_type%TYPE;
   BEGIN
      FOR rec IN (SELECT a.line_cd, a.binder_yy, a.binder_seq_no, b.ri_cd,
                         a.ldisb_amt, a.convert_rate
                    FROM giac_upload_outfacul_prem a, giac_upload_file b
                   WHERE a.source_cd = p_source_cd
                     AND a.file_no = p_file_no
                     AND a.source_cd = b.source_cd
                     AND a.file_no = b.file_no)
      LOOP
         v_prem_chk_flag := NULL;
         v_chk_remarks := NULL;
         v_binder_id := NULL;
         v_binder_prem_amt := 0;
         v_binder_prem_vat := 0;
         v_binder_comm_amt := 0;
         v_binder_comm_vat := 0;
         v_payt_prem_amt := 0;
         v_payt_prem_vat := 0;
         v_payt_comm_amt := 0;
         v_payt_comm_vat := 0;
         v_payt_wholding := 0;
         v_payt_exist := 'N';
         v_total_receivable := 0;
         v_direct_prem := 0;
         v_actual_payments := 0;

         BEGIN
            SELECT DISTINCT b.ri_name, a.reverse_date
                       INTO v_ri_name, v_reverse_date
                       FROM giri_binder a, giis_reinsurer b
                      WHERE a.ri_cd = b.ri_cd
                        AND a.line_cd = rec.line_cd
                        AND a.binder_yy = rec.binder_yy
                        AND a.binder_seq_no = rec.binder_seq_no
                        AND a.ri_cd = rec.ri_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_ri_name := NULL;
               v_reverse_date := NULL;
         END;

         IF v_ri_name IS NULL
         THEN
            v_prem_chk_flag := 'IB';
            v_chk_remarks := 'This binder is not a policy of this reinsurer.';
            GOTO update_table;
         ELSIF v_reverse_date IS NOT NULL
         THEN
            v_prem_chk_flag := 'RB';
            v_chk_remarks := 'This binder is reversed.';
            GOTO update_table;
         ELSE
            v_prem_chk_flag := 'OK';
            v_chk_remarks := 'This binder is valid for uploading.';
         END IF;

         FOR binder IN (SELECT a.ri_prem_amt, a.ri_prem_vat, a.ri_comm_amt,
                               a.ri_comm_vat, a.ri_wholding_vat,
                               a.fnl_binder_id
                          FROM giri_binder a
                         WHERE a.line_cd = rec.line_cd
                           AND a.binder_yy = rec.binder_yy
                           AND a.binder_seq_no = rec.binder_seq_no
                           AND a.ri_cd = rec.ri_cd)
         LOOP
            v_binder_prem_amt := NVL (binder.ri_prem_amt, 0);
            v_binder_prem_vat := NVL (binder.ri_prem_vat, 0);
            v_binder_comm_amt := NVL (binder.ri_comm_amt, 0);
            v_binder_comm_vat := NVL (binder.ri_comm_vat, 0);
            v_binder_wholding := NVL (binder.ri_wholding_vat, 0);
            v_binder_id := binder.fnl_binder_id;
         END LOOP;

         FOR payt IN (SELECT b.prem_amt, b.prem_vat, b.comm_amt, b.comm_vat,
                             b.wholding_vat
                        FROM giac_acctrans c, giac_outfacul_prem_payts b
                       WHERE c.tran_flag != 'D'
                         AND b.d010_fnl_binder_id = v_binder_id
                         AND b.gacc_tran_id = c.tran_id
                         AND NOT EXISTS (
                                SELECT x.tran_id
                                  FROM giac_acctrans x, giac_reversals y
                                 WHERE x.tran_id = y.reversing_tran_id
                                   AND y.gacc_tran_id = b.gacc_tran_id
                                   AND x.tran_flag != 'D'))
         LOOP
            v_payt_prem_amt := v_payt_prem_amt + NVL (payt.prem_amt, 0);
            v_payt_prem_vat := v_payt_prem_vat + NVL (payt.prem_vat, 0);
            v_payt_comm_amt := v_payt_comm_amt + NVL (payt.comm_amt, 0);
            v_payt_comm_vat := v_payt_comm_vat + NVL (payt.comm_vat, 0);
            v_payt_wholding := v_payt_wholding + NVL (payt.wholding_vat, 0);
            v_payt_exist := 'Y';
         END LOOP;

         v_prem_amt := v_binder_prem_amt - v_payt_prem_amt;
         v_prem_vat := v_binder_prem_vat - v_payt_prem_vat;
         v_comm_amt := v_binder_comm_amt - v_payt_comm_amt;
         v_comm_vat := v_binder_comm_vat - v_payt_comm_vat;
         v_wholding := v_binder_wholding - v_payt_wholding;
         v_binder_disb :=
              (v_binder_prem_amt + v_binder_prem_vat)
            - (v_binder_comm_amt + v_binder_comm_vat + v_binder_wholding);
         v_payt_disb :=
              (v_payt_prem_amt + v_payt_prem_vat)
            - (v_payt_comm_amt + v_payt_comm_vat + v_payt_wholding);
         v_disbursement := v_binder_disb - v_payt_disb;
         v_total_payable := v_binder_disb * NVL (rec.convert_rate, 1);

         IF v_disbursement > 0
         THEN
            v_tran_type := 1;
         ELSE
            v_tran_type := 3;
         END IF;

         get_disbursement_amt (v_binder_id,
                               rec.ri_cd,
                               v_tran_type,
                               v_binder_prem_amt,
                               v_payt_prem_amt,
                               v_total_receivable,
                               v_direct_prem,
                               v_actual_payments
                              );

         IF v_binder_prem_amt = v_payt_prem_amt
         THEN
            v_prem_chk_flag := 'FP';
            v_chk_remarks := 'This binder is already fully paid.';
            GOTO update_table;
         END IF;

         v_percent_pay := NVL (v_direct_prem, 0) / v_total_receivable;

         IF v_payt_prem_amt <> 0
         THEN
            v_remaining_amt := NVL (v_total_payable, 0) - v_payt_prem_amt;
         ELSE
            v_remaining_amt := v_total_payable;
         END IF;

         IF rec.ldisb_amt < v_remaining_amt AND v_payt_exist = 'Y'
         THEN
            v_prem_chk_flag := 'PT';
            v_chk_remarks :=
                  'This is a partial payment. The total balance amount due is '
               || LTRIM (TO_CHAR (v_remaining_amt, '999,999,999,990.90'))
               || '.';
            GOTO update_table;
         ELSE
            IF p_override = 'N'
            THEN
               IF rec.ldisb_amt > v_remaining_amt
               THEN
                  v_prem_chk_flag := 'OP';
                  v_chk_remarks :=
                        'This binder has a total balance amount due of '
                     || LTRIM (TO_CHAR (v_remaining_amt, '999,999,999,990.90'))
                     || '.';
               ELSIF rec.ldisb_amt < v_remaining_amt
               THEN
                  v_prem_chk_flag := 'PT';
                  v_chk_remarks :=
                        'This is a partial payment. The total balance amount due is '
                     || LTRIM (TO_CHAR (v_remaining_amt, '999,999,999,990.90'))
                     || '.';
               END IF;
            ELSE
               v_allowable := v_remaining_amt * v_percent_pay;

               IF rec.ldisb_amt > v_allowable
               THEN
                  IF rec.ldisb_amt <= v_remaining_amt
                  THEN
                     v_prem_chk_flag := 'OD';
                     v_chk_remarks :=
                           'This is a partial payment but has an over '
                        || 'outward facultative payment.';
                  ELSIF rec.ldisb_amt > v_remaining_amt
                  THEN
                     v_prem_chk_flag := 'OO';
                     v_chk_remarks :=
                                  'This is an over payment but was override.';
                  END IF;
               ELSE
                  v_prem_chk_flag := 'PO';
                  v_chk_remarks := 'This is an override partial payment.';
               END IF;
            END IF;
         END IF;

         <<update_table>>
         UPDATE giac_upload_outfacul_prem
            SET prem_chk_flag = v_prem_chk_flag,
                chk_remarks = v_chk_remarks,
                prem_amt_due = v_prem_amt,
                prem_vat_due = v_prem_vat,
                comm_amt_due = v_comm_amt,
                comm_vat_due = v_comm_vat,
                wholding_vat_due = v_wholding,
                ri_premium = v_binder_prem_amt,
                outfacul_premium = v_payt_prem_amt,
                total_payable = v_total_payable,
                total_receivable = NVL (v_total_receivable, 0),
                direct_premium = NVL (v_direct_prem, 0),
                actual_payment = NVL (v_actual_payments, 0)
          WHERE source_cd = p_source_cd
            AND file_no = p_file_no
            AND line_cd = rec.line_cd
            AND binder_yy = rec.binder_yy
            AND binder_seq_no = rec.binder_seq_no;
      END LOOP;
   END check_data;

   PROCEDURE get_disbursement_amt (
      p_binder_id           giri_binder.fnl_binder_id%TYPE,
      p_ri_cd               giac_upload_file.ri_cd%TYPE,
      p_tran_type           giac_outfacul_prem_payts.transaction_type%TYPE,
      p_ri_prem             giri_binder.ri_prem_amt%TYPE,
      p_out_prem            giac_outfacul_prem_payts.prem_amt%TYPE,
      p_tot_rec       OUT   gipi_invoice.prem_amt%TYPE,
      p_direct_prem   OUT   giac_direct_prem_collns.premium_amt%TYPE,
      p_actual_pay    OUT   giac_outfacul_prem_payts.disbursement_amt%TYPE
   )
   IS
      v_policy_id        gipi_polbasic.policy_id%TYPE;
      v_iss_cd           gipi_invoice.iss_cd%TYPE;
      v_prem_seq_no      gipi_invoice.prem_seq_no%TYPE;
      v_payable_exists   giri_binder.ri_prem_amt%TYPE    := 0;
      v_exist            VARCHAR2 (1)                    := 'N';
   BEGIN
      BEGIN
         SELECT a.policy_id
           INTO v_policy_id
           FROM gipi_polbasic a,
                giuw_pol_dist b,
                giri_frps_ri c,
                giri_distfrps d,
                giri_binder e
          WHERE c.line_cd = d.line_cd
            AND c.frps_yy = d.frps_yy
            AND c.frps_seq_no = d.frps_seq_no
            AND d.dist_no = b.dist_no
            AND a.policy_id = b.policy_id
            AND c.fnl_binder_id = e.fnl_binder_id
            AND e.ri_cd = p_ri_cd
            AND e.fnl_binder_id = p_binder_id
            AND b.dist_flag NOT IN (4, 5);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_policy_id := NULL;
      END;

      FOR bill IN (SELECT g.iss_cd, g.prem_seq_no
                     FROM giri_binder a,
                          giri_frps_ri b,
                          giri_distfrps c,
                          giuw_policyds d,
                          giuw_pol_dist e,
                          gipi_polbasic f,
                          gipi_invoice g
                    WHERE f.policy_id = g.policy_id
                      AND e.policy_id = f.policy_id
                      AND d.dist_no = e.dist_no
                      AND c.dist_no = d.dist_no
                      AND c.dist_seq_no = d.dist_seq_no
                      AND b.line_cd = c.line_cd
                      AND b.frps_yy = c.frps_yy
                      AND b.frps_seq_no = c.frps_seq_no
                      AND a.fnl_binder_id = b.fnl_binder_id
                      AND a.ri_cd = p_ri_cd
                      AND a.fnl_binder_id = p_binder_id)
      LOOP
         v_iss_cd := bill.iss_cd;
         v_prem_seq_no := bill.prem_seq_no;
         EXIT;
      END LOOP;

      FOR prem_rec IN (SELECT   NVL (prem_amt, 0)
                              * NVL (currency_rt, 1) tot_receivable
                         FROM gipi_invoice
                        WHERE iss_cd = v_iss_cd
                              AND prem_seq_no = v_prem_seq_no)
      LOOP
         p_tot_rec := prem_rec.tot_receivable;
      END LOOP;

      BEGIN
         SELECT 'Y'
           INTO v_exist
           FROM gipi_polbasic a, giri_inpolbas b
          WHERE a.policy_id = b.policy_id AND a.policy_id = v_policy_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_exist := 'N';
         WHEN TOO_MANY_ROWS
         THEN
            v_exist := 'Y';
      END;

      IF v_exist = 'Y'
      THEN
         FOR act_prem IN
            (SELECT NVL (SUM (premium_amt), 0) actual_prem_coll
               FROM giac_inwfacul_prem_collns gipc, giac_acctrans gacc
              WHERE gipc.gacc_tran_id = gacc.tran_id
                AND gacc.tran_flag != 'D'
                AND NOT EXISTS (
                       SELECT '1'
                         FROM giac_acctrans c, giac_reversals d
                        WHERE c.tran_flag != 'D'
                          AND c.tran_id = d.reversing_tran_id
                          AND d.gacc_tran_id = gacc.tran_id)
                AND gipc.b140_iss_cd = v_iss_cd
                AND gipc.b140_prem_seq_no = v_prem_seq_no)
         LOOP
            p_direct_prem := act_prem.actual_prem_coll;
         END LOOP;
      ELSE
         FOR act_prem IN
            (SELECT NVL (SUM (premium_amt), 0) actual_prem_coll
               FROM giac_direct_prem_collns gdpc, giac_acctrans gacc
              WHERE gdpc.gacc_tran_id = gacc.tran_id
                AND gacc.tran_flag != 'D'
                AND NOT EXISTS (
                       SELECT '1'
                         FROM giac_acctrans c, giac_reversals d
                        WHERE c.tran_flag != 'D'
                          AND c.tran_id = d.reversing_tran_id
                          AND d.gacc_tran_id = gacc.tran_id)
                AND gdpc.b140_iss_cd = v_iss_cd
                AND gdpc.b140_prem_seq_no = v_prem_seq_no)
         LOOP
            p_direct_prem := act_prem.actual_prem_coll;
         END LOOP;
      END IF;

      v_payable_exists := p_ri_prem - p_out_prem;

      IF v_payable_exists >= 0
      THEN
         IF p_tran_type = 1
         THEN
            FOR act_payt IN
               (SELECT NVL (SUM (gfpp.disbursement_amt), 0) actual_payments
                  FROM giac_outfacul_prem_payts gfpp, giac_acctrans gacc
                 WHERE gfpp.gacc_tran_id = gacc.tran_id
                   AND gacc.tran_flag != 'D'
                   AND NOT EXISTS (
                          SELECT '1'
                            FROM giac_acctrans c, giac_reversals d
                           WHERE c.tran_flag != 'D'
                             AND c.tran_id = d.reversing_tran_id
                             AND d.gacc_tran_id = gacc.tran_id)
                   AND gfpp.d010_fnl_binder_id = p_binder_id
                   AND gfpp.a180_ri_cd = p_ri_cd
                   AND gfpp.transaction_type IN (1, 2))
            LOOP
               p_actual_pay := act_payt.actual_payments;
            END LOOP;
         END IF;
      ELSIF v_payable_exists < 0
      THEN
         IF p_tran_type = 3
         THEN
            FOR act_payt IN
               (SELECT NVL (SUM (gfpp.disbursement_amt), 0) actual_payments
                  FROM giac_outfacul_prem_payts gfpp, giac_acctrans gacc
                 WHERE gfpp.gacc_tran_id = gacc.tran_id
                   AND gacc.tran_flag != 'D'
                   AND NOT EXISTS (
                          SELECT '1'
                            FROM giac_acctrans c, giac_reversals d
                           WHERE c.tran_flag != 'D'
                             AND c.tran_id = d.reversing_tran_id
                             AND d.gacc_tran_id = gacc.tran_id)
                   AND gfpp.d010_fnl_binder_id = p_binder_id
                   AND gfpp.a180_ri_cd = p_ri_cd
                   AND gfpp.transaction_type IN (3, 4))
            LOOP
               p_actual_pay := act_payt.actual_payments;
            END LOOP;
         END IF;
      END IF;
   END get_disbursement_amt;

   PROCEDURE validate_print (
      p_source_cd     IN       giac_upload_file.source_cd%TYPE,
      p_file_no       IN       giac_upload_file.file_no%TYPE,
      p_user_id       IN       giac_upload_file.user_id%TYPE,
      p_tran_class    IN       giac_upload_file.tran_class%TYPE,
      p_tran_id       IN       giac_acctrans.tran_id%TYPE,
      p_fund_cd       OUT      giac_parameters.param_value_v%TYPE,
      p_fund_desc     OUT      giis_funds.fund_cd%TYPE,
      p_branch_cd     OUT      giac_upload_dv_payt_dtl.branch_cd%TYPE,
      p_branch_name   OUT      giac_branches.branch_name%TYPE,
      p_document_cd   OUT      giac_upload_dv_payt_dtl.document_cd%TYPE,
      p_gprq_ref_id   OUT      giac_payt_requests_dtl.gprq_ref_id%TYPE
   )
   AS
   BEGIN
      IF p_tran_class = 'COL'
      THEN
         BEGIN
            SELECT gibr_branch_cd
              INTO p_branch_cd
              FROM giac_order_of_payts
             WHERE gacc_tran_id = p_tran_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error
                  (-20001,
                   'Geniisys Exception#E#O.R. does not exist in table: giac_order_of_payts.'
                  );
         END;
      ELSIF p_tran_class = 'DV'
      THEN
         FOR gudpd IN (SELECT document_cd, branch_cd
                         FROM giac_upload_dv_payt_dtl
                        WHERE source_cd = p_source_cd AND file_no = p_file_no)
         LOOP
            IF check_user_per_iss_cd_acctg2 (NULL,
                                             gudpd.branch_cd,
                                             'GIACS016',
                                             p_user_id
                                            ) = 0
            THEN
               raise_application_error
                  (-20001,
                      'Geniisys Exception#E#You are not allowed to access disbursement requests for '
                   || gudpd.branch_cd
                   || ' branch.'
                  );
            END IF;

            BEGIN
               SELECT gprq_ref_id
                 INTO p_gprq_ref_id
                 FROM giac_payt_requests_dtl
                WHERE tran_id = p_tran_id AND ROWNUM = 1;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  raise_application_error
                     (-20001,
                      'Geniisys Exception#E#Request does not exist in table: giac_payt_requests.'
                     );
            END;

            p_document_cd := gudpd.document_cd;
            p_branch_cd := gudpd.branch_cd;
         END LOOP;
      ELSIF p_tran_class = 'JV'
      THEN
         FOR gujpd IN (SELECT branch_cd
                         FROM giac_upload_jv_payt_dtl
                        WHERE source_cd = p_source_cd AND file_no = p_file_no)
         LOOP
            p_branch_cd := gujpd.branch_cd;
         END LOOP;
      END IF;

      p_fund_cd := variables_fund_cd;

      BEGIN
         SELECT fund_desc
           INTO p_fund_desc
           FROM giis_funds
          WHERE fund_cd = p_fund_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_fund_desc := NULL;
      END;

      BEGIN
         SELECT branch_name
           INTO p_branch_name
           FROM giac_branches
          WHERE gfun_fund_cd = variables_fund_cd AND branch_cd = p_branch_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_branch_name := NULL;
      END;
   END validate_print;

   PROCEDURE upload_begin (
      p_source_cd    IN       giac_upload_file.source_cd%TYPE,
      p_file_no      IN       giac_upload_file.file_no%TYPE,
      p_tran_class   IN       giac_upload_file.tran_class%TYPE,
      p_user_id      IN       VARCHAR2,
      p_tran_date    IN OUT   VARCHAR2,
      p_branch_cd    OUT      VARCHAR2,
      p_message      OUT      VARCHAR2
   )
   IS
      v_disb_amt   NUMBER (16, 2);
      v_tran_id    giac_acctrans.tran_id%TYPE;
      v_valid_sw   VARCHAR2 (1)                 := 'Y';
   BEGIN
      IF variables_fund_cd IS NULL
      THEN
         raise_application_error
                 (-20001,
                     'Geniisys Exception#E#Parameter FUND_CD is not defined '
                  || 'in table GIAC_PARAMETERS.'
                 );
      END IF;

      v_disb_amt := get_tot_ldisb (p_source_cd, p_file_no);

      IF v_disb_amt <= 0
      THEN
         raise_application_error
                   (-20001,
                       'Geniisys Exception#E#Total Disbursement Amount must '
                    || 'be greater than zero.'
                   );
      END IF;

      IF p_tran_class = 'COL'
      THEN
         BEGIN
            SELECT tran_id
              INTO v_tran_id
              FROM giac_upload_colln_dtl
             WHERE source_cd = p_source_cd
               AND file_no = p_file_no
               AND ROWNUM = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error
                  (-20001,
                   'Geniisys Exception#E#Please enter payment details first.'
                  );
         END;

         get_user_grp_iss_cd (p_user_id);
         p_branch_cd := variables_branch_cd;

         IF v_tran_id IS NULL
         THEN
            p_message :=
                  'An O.R. transaction will be created for '
               || p_branch_cd
               || ' branch. The indicated O.R. Date will be used for the '
               || 'transaction. Do you wish to proceed?';
         END IF;
      ELSIF p_tran_class = 'DV'
      THEN
         BEGIN
            SELECT tran_id, branch_cd, TO_CHAR (request_date, 'MM-DD-YYYY')
              INTO v_tran_id, p_branch_cd, p_tran_date
              FROM giac_upload_dv_payt_dtl
             WHERE source_cd = p_source_cd AND file_no = p_file_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error
                  (-20001,
                   'Geniisys Exception#E#Please enter payment details first.'
                  );
         END;

         IF check_user_per_iss_cd_acctg2 (NULL,
                                          p_branch_cd,
                                          'GIACS016',
                                          p_user_id
                                         ) = 0
         THEN
            raise_application_error
                    (-20001,
                        'Geniisys Exception#E#You are not allowed to create '
                     || 'a Disbursement Request for '
                     || p_branch_cd
                     || ' branch.'
                    );
         END IF;

         IF v_tran_id IS NULL
         THEN
            p_message :=
                  'A Disbursement Request will be created for '
               || p_branch_cd
               || ' branch. The indicated date in the Payment Request '
               || 'Details will be used for the transaction. '
               || 'Do you wish to proceed?';
         END IF;
      ELSIF p_tran_class = 'JV'
      THEN
         BEGIN
            SELECT tran_id, branch_cd, TO_CHAR (tran_date, 'MM-DD-YYYY')
              INTO v_tran_id, p_branch_cd, p_tran_date
              FROM giac_upload_jv_payt_dtl
             WHERE source_cd = p_source_cd AND file_no = p_file_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error
                  (-20001,
                   'Geniisys Exception#E#Please enter payment details first.'
                  );
         END;

         IF check_user_per_iss_cd_acctg2 (NULL,
                                          p_branch_cd,
                                          'GIACS003',
                                          p_user_id
                                         ) = 0
         THEN
            raise_application_error
                    (-20001,
                        'Geniisys Exception#E#You are not allowed to create '
                     || 'a JV transaction for '
                     || p_branch_cd
                     || ' branch.'
                    );
         END IF;

         IF v_tran_id IS NULL
         THEN
            p_message :=
                  'A JV transaction will be created for '
               || p_branch_cd
               || ' branch. The indicated date in the JV Details will be '
               || 'used for the transaction. Do you wish to proceed?';
         END IF;
      END IF;

      IF v_tran_id IS NOT NULL
      THEN
         check_upload_all (p_source_cd,
                           p_file_no,
                           p_tran_class,
                           p_tran_date,
                           p_user_id,
                           v_valid_sw
                          );

         IF v_valid_sw = 'N'
         THEN
            p_message := 'hasInvalid';
         END IF;
      END IF;
   END upload_begin;

   PROCEDURE validate_tran_date (
      p_source_cd    IN       giac_upload_file.source_cd%TYPE,
      p_file_no      IN       giac_upload_file.file_no%TYPE,
      p_tran_class   IN       giac_upload_file.tran_class%TYPE,
      p_branch_cd    IN       VARCHAR2,
      p_tran_date    IN       VARCHAR2,
      p_user_id      IN       VARCHAR2,
      p_message      OUT      VARCHAR2
   )
   IS
      v_tran_date   DATE               := TO_DATE (p_tran_date, 'MM-DD-YYYY');
      v_dcb_no      giac_colln_batch.dcb_no%TYPE;
      v_exist       VARCHAR2 (1)                   := 'N';
      v_valid_sw    VARCHAR2 (1)                   := 'Y';
   BEGIN
      variables_branch_cd := p_branch_cd;
      check_tran_mm (v_tran_date);

      IF p_tran_class = 'COL'
      THEN
         upload_dpc_web.set_fixed_variables (variables_fund_cd,
                                             variables_branch_cd,
                                             NULL
                                            );
         upload_dpc_web.check_dcb_user (v_tran_date, p_user_id);
         upload_dpc_web.get_dcb_no2 (v_tran_date, v_dcb_no, v_exist);

         IF v_exist = 'N'
         THEN
            p_message :=
                  'There is no open DCB No. dated '
               || TO_CHAR (v_tran_date, 'fmMonth DD, YYYY')
               || ' for this company/branch ('
               || variables_fund_cd
               || '/'
               || variables_branch_cd
               || ').';
         END IF;
      END IF;

      IF p_message IS NULL
      THEN
         check_upload_all (p_source_cd,
                           p_file_no,
                           p_tran_class,
                           p_tran_date,
                           p_user_id,
                           v_valid_sw
                          );

         IF v_valid_sw = 'N'
         THEN
            p_message := 'hasInvalid';
         END IF;
      END IF;
   END validate_tran_date;

   PROCEDURE check_tran_mm (p_date giac_acctrans.tran_date%TYPE)
   IS
      v_allow_closed   giac_parameters.param_value_v%TYPE
                        := NVL (giacp.v ('ALLOW_TRAN_FOR_CLOSED_MONTH'), 'N');
   BEGIN
      FOR a1 IN (SELECT closed_tag
                   FROM giac_tran_mm
                  WHERE fund_cd = variables_fund_cd
                    AND branch_cd = variables_branch_cd
                    AND tran_yr = TO_NUMBER (TO_CHAR (p_date, 'YYYY'))
                    AND tran_mm = TO_NUMBER (TO_CHAR (p_date, 'MM')))
      LOOP
         IF a1.closed_tag = 'T'
         THEN
            raise_application_error
                     (-20001,
                         'Geniisys Exception#I#You are no longer allowed to '
                      || 'create a transaction for '
                      || TO_CHAR (p_date, 'fmMonth')
                      || ' '
                      || TO_CHAR (p_date, 'RRRR')
                      || '. This transaction month is temporarily closed.'
                     );
         ELSIF a1.closed_tag = 'Y' AND v_allow_closed = 'N'
         THEN
            raise_application_error
                     (-20001,
                         'Geniisys Exception#I#You are no longer allowed to '
                      || 'create a transaction for '
                      || TO_CHAR (p_date, 'fmMonth')
                      || ' '
                      || TO_CHAR (p_date, 'RRRR')
                      || '. This transaction month is already closed.'
                     );
         END IF;
      END LOOP;
   END check_tran_mm;

   PROCEDURE check_upload_all (
      p_source_cd    IN       giac_upload_file.source_cd%TYPE,
      p_file_no      IN       giac_upload_file.file_no%TYPE,
      p_tran_class   IN       giac_upload_file.tran_class%TYPE,
      p_tran_date    IN       VARCHAR2,
      p_user_id      IN       VARCHAR2,
      p_valid_sw     OUT      VARCHAR2
   )
   IS
   BEGIN
      p_valid_sw := 'Y';

      BEGIN
         SELECT 'N'
           INTO p_valid_sw
           FROM giac_upload_outfacul_prem
          WHERE source_cd = p_source_cd
            AND file_no = p_file_no
            AND prem_chk_flag != 'OK'
            AND ROWNUM = 1;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_valid_sw := 'Y';
      END;

      IF p_valid_sw = 'N'
      THEN
         IF giac_validate_user_fn (p_user_id, 'UA', 'GIACS609') = 'TRUE'
         THEN
            p_valid_sw := 'Y';
         END IF;
      END IF;

      IF p_valid_sw = 'Y'
      THEN
         upload_payments (p_source_cd,
                          p_file_no,
                          p_tran_class,
                          p_tran_date,
                          p_user_id
                         );
      END IF;
   END check_upload_all;

   PROCEDURE upload_payments (
      p_source_cd    giac_upload_file.source_cd%TYPE,
      p_file_no      giac_upload_file.file_no%TYPE,
      p_tran_class   giac_upload_file.tran_class%TYPE,
      p_tran_date    VARCHAR2,
      p_user_id      VARCHAR2
   )
   IS
   BEGIN
      variables_source_cd := p_source_cd;
      variables_file_no := p_file_no;
      variables_user_id := p_user_id;

      BEGIN
         SELECT ri_cd
           INTO variables_ri_cd
           FROM giac_upload_file
          WHERE source_cd = variables_source_cd
                AND file_no = variables_file_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            variables_ri_cd := NULL;
      END;

      IF p_tran_class = 'COL'
      THEN
         generate_or (p_tran_date);
      ELSIF p_tran_class = 'DV'
      THEN
         generate_dv;
      ELSIF p_tran_class = 'JV'
      THEN
         generate_jv;
      END IF;
   END upload_payments;

   PROCEDURE generate_or (p_or_date VARCHAR2)
   IS
      v_tran_year     giac_acctrans.tran_year%TYPE;
      v_tran_month    giac_acctrans.tran_month%TYPE;
      v_tran_seq_no   giac_acctrans.tran_seq_no%TYPE;
      v_tin           giis_reinsurer.ri_tin%TYPE;
      v_add1          giis_reinsurer.mail_address1%TYPE;
      v_add2          giis_reinsurer.mail_address2%TYPE;
      v_add3          giis_reinsurer.mail_address3%TYPE;
      v_cashier       giac_dcb_users.cashier_cd%TYPE;
      v_particulars   giac_order_of_payts.particulars%TYPE;
      v_fcurrency     giac_collection_dtl.fcurrency_amt%TYPE;
      v_tran_date     DATE;
      v_dcb_no        giac_colln_batch.dcb_no%TYPE;
      v_reinsurer     giis_reinsurer.ri_name%TYPE;
      v_tot_disb      NUMBER (16, 2);
      v_currency_cd   giac_upload_outfacul_prem.currency_cd%TYPE;
      v_exist         VARCHAR2 (1)                                 := 'N';
   BEGIN
      BEGIN
         SELECT tran_id
           INTO variables_tran_id
           FROM giac_upload_colln_dtl
          WHERE ROWNUM = 1;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error
                  (-20001,
                   'Geniisys Exception#E#Please enter payment details first.'
                  );
      END;

      IF variables_tran_id IS NOT NULL
      THEN
         BEGIN
            SELECT due_dcb_date
              INTO v_tran_date
              FROM giac_collection_dtl
             WHERE gacc_tran_id = variables_tran_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_tran_date := NULL;
         END;

         UPDATE giac_order_of_payts
            SET upload_tag = 'Y',
                user_id = variables_user_id,
                last_update = SYSDATE
          WHERE gacc_tran_id = variables_tran_id;
      ELSE
         get_user_grp_iss_cd (variables_user_id);

         SELECT acctran_tran_id_s.NEXTVAL
           INTO variables_tran_id
           FROM SYS.DUAL;

         BEGIN
            SELECT ri_tin, mail_address1, mail_address2, mail_address3,
                   ri_name
              INTO v_tin, v_add1, v_add2, v_add3,
                   v_reinsurer
              FROM giis_reinsurer
             WHERE ri_cd = variables_ri_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         BEGIN
            SELECT cashier_cd
              INTO v_cashier
              FROM giac_dcb_users
             WHERE dcb_user_id = variables_user_id
               AND gibr_fund_cd = variables_fund_cd
               AND gibr_branch_cd = variables_branch_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         v_particulars :=
             'Representing payment of premium and taxes for various policies.';
         v_tran_date :=
            TO_DATE (p_or_date || ' ' || TO_CHAR (SYSDATE, 'HH:MI:SS AM'),
                     'MM-DD-YYYY HH:MI:SS AM'
                    );
         v_tran_month := TO_NUMBER (TO_CHAR (v_tran_date, 'MM'));
         v_tran_year := TO_NUMBER (TO_CHAR (v_tran_date, 'YYYY'));
         v_tran_seq_no :=
            giac_sequence_generation (variables_fund_cd,
                                      variables_branch_cd,
                                      'ACCTRAN_TRAN_SEQ_NO',
                                      v_tran_year,
                                      v_tran_month
                                     );
         v_tot_disb := get_tot_ldisb (variables_source_cd, variables_file_no);
         upload_dpc_web.get_dcb_no2 (v_tran_date, v_dcb_no, v_exist);

         IF v_exist = 'N'
         THEN
            FOR dcb IN (SELECT (NVL (MAX (dcb_no), 0) + 1) new_dcb_no
                          FROM giac_colln_batch
                         WHERE fund_cd = variables_fund_cd
                           AND branch_cd = variables_branch_cd
                           AND dcb_year =
                                     TO_NUMBER (TO_CHAR (v_tran_date, 'YYYY')))
            LOOP
               v_dcb_no := dcb.new_dcb_no;
               EXIT;
            END LOOP;

            upload_dpc_web.create_dcb_no (v_dcb_no,
                                          v_tran_date,
                                          variables_fund_cd,
                                          variables_branch_cd,
                                          variables_user_id
                                         );
         END IF;

         BEGIN
            SELECT currency_cd
              INTO v_currency_cd
              FROM giac_upload_outfacul_prem
             WHERE source_cd = variables_source_cd
               AND file_no = variables_file_no
               AND ROWNUM = 1;
         END;

         INSERT INTO giac_acctrans
                     (tran_id, gfun_fund_cd,
                      gibr_branch_cd, tran_date, tran_flag, tran_class,
                      tran_class_no, particulars, tran_year, tran_month,
                      tran_seq_no, user_id, last_update
                     )
              VALUES (variables_tran_id, variables_fund_cd,
                      variables_branch_cd, v_tran_date, 'O', 'COL',
                      v_dcb_no, NULL, v_tran_year, v_tran_month,
                      v_tran_seq_no, variables_user_id, SYSDATE
                     );

         INSERT INTO giac_order_of_payts
                     (gacc_tran_id, gibr_gfun_fund_cd,
                      gibr_branch_cd, payor, collection_amt,
                      cashier_cd, address_1, address_2, address_3,
                      particulars, or_flag, dcb_no, gross_amt,
                      currency_cd, gross_tag, user_id, last_update, tin,
                      upload_tag, or_date
                     )
              VALUES (variables_tran_id, variables_fund_cd,
                      variables_branch_cd, v_reinsurer, v_tot_disb,
                      v_cashier, v_add1, v_add2, v_add3,
                      v_particulars, 'N', v_dcb_no, v_tot_disb,
                      v_currency_cd, 'Y', variables_user_id, SYSDATE, v_tin,
                      'Y', v_tran_date
                     );

         FOR rec IN (SELECT item_no, pay_mode, amount, gross_amt,
                            commission_amt, vat_amt, check_class, check_date,
                            check_no, particulars, bank_cd, currency_cd,
                            currency_rt, fc_gross_amt, dcb_bank_cd,
                            dcb_bank_acct_cd
                       FROM giac_upload_colln_dtl
                      WHERE source_cd = variables_source_cd
                        AND file_no = variables_file_no)
         LOOP
            v_fcurrency := ROUND (rec.amount / rec.currency_rt, 2);

            INSERT INTO giac_collection_dtl
                        (gacc_tran_id, item_no, currency_cd,
                         currency_rt, pay_mode, amount,
                         check_date, check_no, particulars,
                         bank_cd, check_class, fcurrency_amt,
                         gross_amt, commission_amt, vat_amt,
                         fc_gross_amt, user_id, last_update,
                         due_dcb_no, due_dcb_date, dcb_bank_cd,
                         dcb_bank_acct_cd
                        )
                 VALUES (variables_tran_id, rec.item_no, rec.currency_cd,
                         rec.currency_rt, rec.pay_mode, rec.amount,
                         rec.check_date, rec.check_no, rec.particulars,
                         rec.bank_cd, rec.check_class, v_fcurrency,
                         rec.gross_amt, rec.commission_amt, rec.vat_amt,
                         rec.fc_gross_amt, variables_user_id, SYSDATE,
                         v_dcb_no, TRUNC (v_tran_date), rec.dcb_bank_cd,
                         rec.dcb_bank_acct_cd
                        );
         END LOOP;

         upload_dpc_web.aeg_parameters (variables_tran_id,
                                        variables_branch_cd,
                                        variables_fund_cd,
                                        'GIACS001',
                                        variables_user_id
                                       );
      END IF;

      process_payments;

      UPDATE giac_upload_outfacul_prem
         SET tran_id = variables_tran_id,
             tran_date = v_tran_date
       WHERE source_cd = variables_source_cd AND file_no = variables_file_no;

      DELETE FROM giac_upload_dv_payt_dtl
            WHERE source_cd = variables_source_cd
              AND file_no = variables_file_no;

      DELETE FROM giac_upload_jv_payt_dtl
            WHERE source_cd = variables_source_cd
              AND file_no = variables_file_no;

      UPDATE giac_upload_file
         SET upload_date = SYSDATE,
             file_status = '2',
             tran_class = 'COL',
             tran_id = variables_tran_id,
             tran_date = TRUNC (v_tran_date)
       WHERE source_cd = variables_source_cd AND file_no = variables_file_no;
   END generate_or;

   PROCEDURE generate_dv
   IS
      v_doc_seq_no   giac_payt_requests.doc_seq_no%TYPE;
      v_ref_id       NUMBER;
   BEGIN
      FOR i IN (SELECT *
                  FROM giac_upload_dv_payt_dtl
                 WHERE source_cd = variables_source_cd
                   AND file_no = variables_file_no)
      LOOP
         IF i.tran_id IS NOT NULL
         THEN
            variables_tran_id := i.tran_id;
         ELSE
            SELECT acctran_tran_id_s.NEXTVAL
              INTO variables_tran_id
              FROM SYS.DUAL;

            INSERT INTO giac_acctrans
                        (tran_id, gfun_fund_cd, gibr_branch_cd,
                         tran_flag, tran_date, tran_class, user_id,
                         last_update
                        )
                 VALUES (variables_tran_id, variables_fund_cd, i.branch_cd,
                         'O', i.request_date, 'DV', variables_user_id,
                         SYSDATE
                        );

            SELECT gprq_ref_id_s.NEXTVAL
              INTO v_ref_id
              FROM SYS.DUAL;

            INSERT INTO giac_payt_requests
                        (gouc_ouc_id, ref_id, fund_cd,
                         branch_cd, document_cd, request_date,
                         line_cd, doc_year, doc_mm, user_id,
                         last_update, with_dv, upload_tag, create_by
                        )
                 VALUES (i.gouc_ouc_id, v_ref_id, variables_fund_cd,
                         i.branch_cd, i.document_cd, i.request_date,
                         i.line_cd, i.doc_year, i.doc_mm, variables_user_id,
                         SYSDATE, 'N', 'Y', variables_user_id
                        );

            INSERT INTO giac_payt_requests_dtl
                        (req_dtl_no, gprq_ref_id, payee_class_cd,
                         payt_req_flag, payee_cd, payee, currency_cd,
                         payt_amt, tran_id, particulars,
                         user_id, last_update, dv_fcurrency_amt,
                         currency_rt
                        )
                 VALUES (1, v_ref_id, i.payee_class_cd,
                         'N', i.payee_cd, i.payee, i.currency_cd,
                         i.payt_amt, variables_tran_id, i.particulars,
                         variables_user_id, SYSDATE, i.dv_fcurrency_amt,
                         i.currency_rt
                        );

            BEGIN
               SELECT doc_seq_no
                 INTO v_doc_seq_no
                 FROM giac_payt_requests
                WHERE ref_id = v_ref_id;
            EXCEPTION
               WHEN OTHERS
               THEN
                  raise_application_error
                         (-20001,
                          'Geniisys Exception#E#Error retrieving DOC_SEQ_NO.'
                         );
            END;
         END IF;

         upload_dpc_web.set_fixed_variables (variables_fund_cd,
                                             i.branch_cd,
                                             NULL
                                            );
         process_payments;

         IF i.tran_id IS NULL
         THEN
            UPDATE giac_upload_dv_payt_dtl
               SET doc_seq_no = v_doc_seq_no,
                   tran_id = variables_tran_id
             WHERE source_cd = variables_source_cd
               AND file_no = variables_file_no;
         END IF;

         DELETE FROM giac_upload_jv_payt_dtl
               WHERE source_cd = variables_source_cd
                 AND file_no = variables_file_no;

         DELETE FROM giac_upload_colln_dtl
               WHERE source_cd = variables_source_cd
                 AND file_no = variables_file_no;

         UPDATE giac_upload_outfacul_prem
            SET tran_id = variables_tran_id,
                tran_date = i.request_date
          WHERE source_cd = variables_source_cd
                AND file_no = variables_file_no;

         UPDATE giac_upload_file
            SET upload_date = SYSDATE,
                file_status = '2',
                tran_id = variables_tran_id,
                tran_class = 'DV',
                tran_date = TRUNC (i.request_date)
          WHERE source_cd = variables_source_cd
                AND file_no = variables_file_no;
      END LOOP;
   END generate_dv;

   PROCEDURE generate_jv
   IS
      v_tran_class_no   giac_acctrans.tran_class_no%TYPE;
   BEGIN
      FOR i IN (SELECT *
                  FROM giac_upload_jv_payt_dtl
                 WHERE source_cd = variables_source_cd
                   AND file_no = variables_file_no)
      LOOP
         IF i.tran_id IS NOT NULL
         THEN
            variables_tran_id := i.tran_id;
         ELSE
            SELECT acctran_tran_id_s.NEXTVAL
              INTO variables_tran_id
              FROM SYS.DUAL;

            v_tran_class_no :=
               giac_sequence_generation (variables_fund_cd,
                                         i.branch_cd,
                                         'JV',
                                         i.tran_year,
                                         i.tran_month
                                        );

            INSERT INTO giac_acctrans
                        (tran_id, gfun_fund_cd, gibr_branch_cd,
                         tran_flag, tran_date, tran_year, tran_month,
                         tran_class, tran_class_no, jv_pref_suff,
                         jv_no, particulars, jv_tran_tag,
                         jv_tran_type, jv_tran_mm, jv_tran_yy, ae_tag,
                         upload_tag, user_id, last_update
                        )
                 VALUES (variables_tran_id, variables_fund_cd, i.branch_cd,
                         'O', i.tran_date, i.tran_year, i.tran_month,
                         'JV', v_tran_class_no, i.jv_pref_suff,
                         v_tran_class_no, i.particulars, i.jv_tran_tag,
                         i.jv_tran_type, i.jv_tran_mm, i.jv_tran_yy, 'N',
                         'Y', variables_user_id, SYSDATE
                        );
         END IF;

         upload_dpc_web.set_fixed_variables (variables_fund_cd,
                                             i.branch_cd,
                                             NULL
                                            );
         process_payments;

         IF i.tran_id IS NULL
         THEN
            UPDATE giac_upload_jv_payt_dtl
               SET jv_no = v_tran_class_no,
                   tran_id = variables_tran_id
             WHERE source_cd = variables_source_cd
               AND file_no = variables_file_no;
         END IF;

         DELETE FROM giac_upload_dv_payt_dtl
               WHERE source_cd = variables_source_cd
                 AND file_no = variables_file_no;

         DELETE FROM giac_upload_colln_dtl
               WHERE source_cd = variables_source_cd
                 AND file_no = variables_file_no;

         UPDATE giac_upload_outfacul_prem
            SET tran_id = variables_tran_id,
                tran_date = i.tran_date
          WHERE source_cd = variables_source_cd
                AND file_no = variables_file_no;

         UPDATE giac_upload_file
            SET upload_date = SYSDATE,
                file_status = '2',
                tran_class = 'JV',
                tran_id = variables_tran_id,
                tran_date = TRUNC (i.tran_date)
          WHERE source_cd = variables_source_cd
                AND file_no = variables_file_no;
      END LOOP;
   END generate_jv;

   PROCEDURE get_user_grp_iss_cd (p_user_id VARCHAR2)
   IS
   BEGIN
      SELECT a.grp_iss_cd
        INTO variables_branch_cd
        FROM giis_user_grp_hdr a, giis_users b
       WHERE a.user_grp = b.user_grp AND b.user_id = p_user_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error
             (-20001,
              'Geniisys Exception#E#Group branch code of user was not found!'
             );
   END get_user_grp_iss_cd;

   FUNCTION get_reinsurer (
      p_line_cd         giri_binder.line_cd%TYPE,
      p_binder_yy       giri_binder.binder_yy%TYPE,
      p_binder_seq_no   giri_binder.binder_seq_no%TYPE
   )
      RETURN NUMBER
   IS
      v_ri_cd   giri_binder.ri_cd%TYPE;
   BEGIN
      FOR reinsurer IN (SELECT ri_cd
                          FROM giri_binder
                         WHERE line_cd = p_line_cd
                           AND binder_yy = p_binder_yy
                           AND binder_seq_no = p_binder_seq_no)
      LOOP
         v_ri_cd := reinsurer.ri_cd;
      END LOOP;

      RETURN (v_ri_cd);
   END get_reinsurer;

   PROCEDURE process_payments
   IS
      v_percent_pay         NUMBER;
      v_acct_payable_min    NUMBER  := NVL (giacp.n ('ACCTS_PAYABLE_MIN'), 0);
      v_premcol_exp_max     NUMBER    := NVL (giacp.n ('PREMCOL_EXP_MAX'), 0);
      v_sl_cd               giac_acct_entries.sl_cd%TYPE;
      v_aeg_item_no         giac_module_entries.item_no%TYPE;
      v_acct_payable_amt    giac_upload_outfacul_prem.ldisb_amt%TYPE;
      v_other_income_amt    giac_upload_outfacul_prem.ldisb_amt%TYPE;
      v_dummy_expense_amt   giac_upload_outfacul_prem.ldisb_amt%TYPE;
      v_other_expense_amt   giac_upload_outfacul_prem.ldisb_amt%TYPE;
      v_prem_colln          NUMBER                                     := 0;
   BEGIN
      FOR i IN (SELECT line_cd, binder_yy, binder_seq_no, prem_chk_flag,
                       ldisb_amt, lprem_amt, lprem_vat, lcomm_amt, lcomm_vat,
                       lwholding_vat, ri_premium, outfacul_premium,
                       total_payable, actual_payment, currency_cd,
                       convert_rate, fdisb_amt
                  FROM giac_upload_outfacul_prem
                 WHERE source_cd = variables_source_cd
                   AND file_no = variables_file_no)
      LOOP
         IF i.prem_chk_flag NOT IN ('IB', 'RB')
         THEN
            IF i.total_payable < 0 AND i.prem_chk_flag IN ('OP')
            THEN
               IF i.ldisb_amt >= v_acct_payable_min
               THEN
                  v_sl_cd :=
                      get_reinsurer (i.line_cd, i.binder_yy, i.binder_seq_no);
                  v_aeg_item_no := 10;
                  v_acct_payable_amt :=
                                     NVL (v_acct_payable_amt, 0)
                                     + i.ldisb_amt;
               ELSE
                  v_sl_cd := giacp.n ('OTHER_INCOME_SL');
                  v_aeg_item_no := 11;
                  v_other_income_amt :=
                                     NVL (v_other_income_amt, 0)
                                     + i.ldisb_amt;
               END IF;

               upload_dpc_web.aeg_parameters_misc (variables_tran_id,
                                                   'GIACS609',
                                                   v_aeg_item_no,
                                                   i.ldisb_amt,
                                                   v_sl_cd,
                                                   variables_user_id
                                                  );
            ELSIF i.prem_chk_flag IN ('OK', 'PT', 'OP', 'OD', 'OO', 'PO')
            THEN
               v_dummy_expense_amt := 0;

               IF     i.prem_chk_flag IN ('PT', 'PO')
                  AND (i.total_payable - i.ldisb_amt <= v_premcol_exp_max)
               THEN
                  v_dummy_expense_amt := i.total_payable - i.ldisb_amt;
                  v_sl_cd :=
                      get_reinsurer (i.line_cd, i.binder_yy, i.binder_seq_no);
                  v_aeg_item_no := 12;
                  upload_dpc_web.aeg_parameters_misc (variables_tran_id,
                                                      'GIACS609',
                                                      v_aeg_item_no,
                                                      v_dummy_expense_amt,
                                                      v_sl_cd,
                                                      variables_user_id
                                                     );
                  v_other_expense_amt :=
                                     v_other_expense_amt + v_dummy_expense_amt;
               END IF;

               variables_currency_cd := i.currency_cd;
               variables_convert_rate := i.convert_rate;
               insert_into_outfacul_prem_payt (i.line_cd,
                                               i.binder_yy,
                                               i.binder_seq_no,
                                               i.prem_chk_flag,
                                               i.ldisb_amt,
                                               i.fdisb_amt,
                                               v_prem_colln
                                              );

               IF i.prem_chk_flag IN ('OP', 'OO') AND v_prem_colln <> 0
               THEN
                  IF v_prem_colln >= v_acct_payable_min
                  THEN
                     v_sl_cd :=
                        get_reinsurer (i.line_cd,
                                       i.binder_yy,
                                       i.binder_seq_no
                                      );
                     v_aeg_item_no := 10;
                     v_acct_payable_amt := v_acct_payable_amt + v_prem_colln;
                  ELSE
                     v_sl_cd := giacp.n ('OTHER_INCOME_SL');
                     v_aeg_item_no := 11;
                     v_other_income_amt := v_other_income_amt + v_prem_colln;
                  END IF;

                  upload_dpc_web.aeg_parameters_misc (variables_tran_id,
                                                      'GIACS609',
                                                      v_aeg_item_no,
                                                      v_prem_colln,
                                                      v_sl_cd,
                                                      variables_user_id
                                                     );
               END IF;
            ELSE
               IF i.prem_chk_flag = 'FP'
               THEN
                  v_sl_cd :=
                      get_reinsurer (i.line_cd, i.binder_yy, i.binder_seq_no);
                  v_aeg_item_no := 15;
                  upload_dpc_web.aeg_parameters_misc (variables_tran_id,
                                                      'GIACS609',
                                                      v_aeg_item_no,
                                                      i.ldisb_amt,
                                                      v_sl_cd,
                                                      variables_user_id
                                                     );
               END IF;
            END IF;
         ELSE
            IF i.prem_chk_flag = 'IB'
            THEN
               v_sl_cd :=
                      get_reinsurer (i.line_cd, i.binder_yy, i.binder_seq_no);
               v_aeg_item_no := 1;
               upload_dpc_web.aeg_parameters_misc (variables_tran_id,
                                                   'GIACS609',
                                                   v_aeg_item_no,
                                                   i.ldisb_amt,
                                                   v_sl_cd,
                                                   variables_user_id
                                                  );
            END IF;
         END IF;
      END LOOP;

      upload_dpc_web.aeg_parameters_outfacul (variables_tran_id,
                                              'GIACS609',
                                              variables_user_id
                                             );
      generate_op_text;

      IF v_acct_payable_amt <> 0
      THEN
         generate_misc_op_text ('ACCOUNTS PAYABLE', v_acct_payable_amt);
      END IF;

      IF v_other_income_amt <> 0
      THEN
         generate_misc_op_text ('OTHER INCOME', v_other_income_amt);
      END IF;

      IF v_other_expense_amt <> 0
      THEN
         generate_misc_op_text ('OTHER EXPENSE', v_other_expense_amt * -1);
      END IF;
   END process_payments;

   PROCEDURE insert_into_outfacul_prem_payt (
      p_line_cd               giac_upload_outfacul_prem.line_cd%TYPE,
      p_binder_yy             giac_upload_outfacul_prem.binder_yy%TYPE,
      p_binder_seq_no         giac_upload_outfacul_prem.binder_seq_no%TYPE,
      p_prem_chk_flag         giac_upload_outfacul_prem.prem_chk_flag%TYPE,
      p_ldisb_amt             giac_upload_outfacul_prem.ldisb_amt%TYPE,
      p_fdisb_amt             giac_upload_outfacul_prem.fdisb_amt%TYPE,
      p_prem_colln      OUT   giac_upload_outfacul_prem.ldisb_amt%TYPE
   )
   IS
      v_ldisb_amt       NUMBER                                           := 0;
      v_tran_type       giac_outfacul_prem_payts.transaction_type%TYPE;
      v_disbursement    giac_outfacul_prem_payts.disbursement_amt%TYPE;
      v_disb_rt         NUMBER                                           := 0;
      v_total_payable   NUMBER                                           := 0;
      v_prem_amt        NUMBER                                           := 0;
      v_prem_vat        NUMBER                                           := 0;
      v_comm_amt        NUMBER                                           := 0;
      v_comm_vat        NUMBER                                           := 0;
      v_wholding        NUMBER                                           := 0;
      v_colln_amt       NUMBER                                           := 0;
      v_ins_colln_amt   NUMBER                                           := 0;
   BEGIN
      v_ldisb_amt := p_ldisb_amt;

      FOR prem_pay IN (SELECT   NVL (a.ri_prem_amt, 0)
                              * c.currency_rt ri_prem_amt,
                                NVL (a.ri_prem_vat, 0)
                              * c.currency_rt ri_prem_vat,
                                NVL (a.ri_comm_amt, 0)
                              * c.currency_rt ri_comm_amt,
                                NVL (a.ri_comm_vat, 0)
                              * c.currency_rt ri_comm_vat,
                                NVL (a.ri_wholding_vat, 0)
                              * c.currency_rt ri_wholding_vat,
                              a.fnl_binder_id
                         FROM giri_frps_ri b,
                              giuw_pol_dist d,
                              giri_distfrps c,
                              giri_binder a
                        WHERE a.fnl_binder_id = b.fnl_binder_id
                          AND b.line_cd = c.line_cd
                          AND b.frps_yy = c.frps_yy
                          AND b.frps_seq_no = c.frps_seq_no
                          AND d.dist_no = c.dist_no
                          AND d.dist_flag NOT IN (4, 5)
                          AND a.binder_yy = p_binder_yy
                          AND a.line_cd = p_line_cd
                          AND a.binder_seq_no = p_binder_seq_no
                          AND a.ri_cd = variables_ri_cd)
      LOOP
         v_total_payable :=
            (  (prem_pay.ri_prem_amt + prem_pay.ri_prem_vat)
             - (  prem_pay.ri_comm_amt
                + prem_pay.ri_comm_vat
                + prem_pay.ri_wholding_vat
               )
            );

         IF p_prem_chk_flag IN ('OK', 'OO', 'OP')
         THEN
            v_colln_amt := v_total_payable;
         ELSE
            IF NVL (v_ldisb_amt, 0) < v_total_payable
            THEN
               v_colln_amt := v_ldisb_amt;
            ELSE
               v_colln_amt := v_total_payable;
            END IF;
         END IF;

         IF v_colln_amt > 0
         THEN
            v_tran_type := 1;
         ELSE
            v_tran_type := 3;
         END IF;

         v_disb_rt := v_ldisb_amt / v_total_payable;
         v_prem_amt := prem_pay.ri_prem_amt * v_disb_rt;
         v_prem_vat := prem_pay.ri_prem_vat * v_disb_rt;
         v_comm_amt := prem_pay.ri_comm_amt * v_disb_rt;
         v_comm_vat := prem_pay.ri_comm_vat * v_disb_rt;
         v_wholding := prem_pay.ri_wholding_vat * v_disb_rt;
         v_disbursement :=
              v_ldisb_amt
            - (  (v_prem_amt + v_prem_vat)
               - (v_comm_amt + v_comm_vat + v_wholding)
              );

         IF SIGN (v_disbursement) IN (1, -1)
         THEN
            IF v_prem_vat <> 0
            THEN
               v_prem_vat := v_prem_vat + v_disbursement;
            ELSE
               IF SIGN (v_prem_vat + v_disbursement) <> SIGN (v_prem_amt)
               THEN
                  v_comm_amt := v_comm_amt - v_disbursement;
               ELSE
                  v_prem_vat := v_prem_vat + v_disbursement;
               END IF;
            END IF;
         END IF;

         INSERT INTO giac_outfacul_prem_payts
                     (gacc_tran_id, a180_ri_cd, transaction_type,
                      d010_fnl_binder_id, disbursement_amt,
                      currency_cd, convert_rate,
                      foreign_curr_amt, or_print_tag, user_id, last_update,
                      prem_amt, prem_vat, comm_amt, comm_vat,
                      wholding_vat, record_no
                     )
              VALUES (variables_tran_id, variables_ri_cd, v_tran_type,
                      prem_pay.fnl_binder_id, v_colln_amt,
                      variables_currency_cd, variables_convert_rate,
                      p_fdisb_amt, 'N', variables_user_id, SYSDATE,
                      v_prem_amt, v_prem_vat, v_comm_amt, v_comm_vat,
                      v_wholding, 0
                     );

         IF p_prem_chk_flag IN ('OK', 'OP', 'OO')
         THEN
            v_ins_colln_amt := v_ins_colln_amt + v_colln_amt;
         ELSE
            v_ldisb_amt := v_ldisb_amt - v_colln_amt;
         END IF;
      END LOOP;

      IF p_prem_chk_flag IN ('OK', 'OP', 'OO')
      THEN
         p_prem_colln := v_ldisb_amt - v_ins_colln_amt;
      ELSE
         p_prem_colln := v_ldisb_amt;
      END IF;
   END insert_into_outfacul_prem_payt;

   PROCEDURE generate_op_text
   IS
      CURSOR c
      IS
         SELECT DISTINCT gfpp.gacc_tran_id,
                         (-1 * gfpp.disbursement_amt) item_amt,
                         (   b.line_cd
                          || '-'
                          || LTRIM (TO_CHAR (b.binder_yy, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (b.binder_seq_no, '09999'))
                          || ' / '
                          || TO_CHAR (b.binder_date, 'DD-MON-YYYY')
                         ) item_text,
                         gfpp.user_id, gfpp.last_update, b.line_cd,
                         gfpp.currency_cd,
                         -1 * (gfpp.foreign_curr_amt) for_curr_amt
                    FROM giac_outfacul_prem_payts gfpp, giri_binder b
                   WHERE gfpp.gacc_tran_id = variables_tran_id
                     AND gfpp.d010_fnl_binder_id = b.fnl_binder_id
                     AND gfpp.a180_ri_cd = b.ri_cd;

      ws_seq_no     giac_op_text.item_seq_no%TYPE   := 1;
      ws_gen_type   VARCHAR2 (1)                    := 'M';
   BEGIN
      DELETE FROM giac_op_text
            WHERE gacc_tran_id = variables_tran_id
              AND item_gen_type = ws_gen_type;

      FOR c_rec IN c
      LOOP
         INSERT INTO giac_op_text
                     (gacc_tran_id, item_seq_no, print_seq_no,
                      item_amt, item_gen_type, item_text,
                      user_id, last_update, line,
                      currency_cd, foreign_curr_amt
                     )
              VALUES (c_rec.gacc_tran_id, ws_seq_no, ws_seq_no,
                      c_rec.item_amt, ws_gen_type, c_rec.item_text,
                      c_rec.user_id, c_rec.last_update, c_rec.line_cd,
                      c_rec.currency_cd, c_rec.for_curr_amt
                     );

         ws_seq_no := ws_seq_no + 1;
      END LOOP;
   END generate_op_text;

   PROCEDURE generate_misc_op_text (
      p_item_text   giac_op_text.item_text%TYPE,
      p_item_amt    giac_op_text.item_amt%TYPE
   )
   IS
      v_gen_type   giac_modules.generation_type%TYPE;
      v_seq_no     giac_op_text.item_seq_no%TYPE;
   BEGIN
      BEGIN
         SELECT generation_type
           INTO v_gen_type
           FROM giac_modules
          WHERE module_name = 'GIACS609';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#I#This module does not exist in giac_modules.'
               );
      END;

      SELECT NVL (MAX (item_seq_no), 0) + 1
        INTO v_seq_no
        FROM giac_op_text
       WHERE gacc_tran_id = variables_tran_id AND item_gen_type = v_gen_type;

      INSERT INTO giac_op_text
                  (gacc_tran_id, item_seq_no, print_seq_no, item_amt,
                   item_gen_type, item_text, currency_cd, foreign_curr_amt,
                   user_id, last_update
                  )
           VALUES (variables_tran_id, v_seq_no, v_seq_no, p_item_amt,
                   v_gen_type, p_item_text, 1, p_item_amt,
                   variables_user_id, SYSDATE
                  );
   END generate_misc_op_text;

   PROCEDURE cancel_file (
      p_source_cd   giac_upload_file.source_cd%TYPE,
      p_file_no     giac_upload_file.file_no%TYPE,
      p_user_id     giac_upload_file.user_id%TYPE
   )
   IS
   BEGIN
      UPDATE giac_upload_file
         SET file_status = 'C',
             cancel_date = SYSDATE,
             user_id = p_user_id
       WHERE source_cd = p_source_cd AND file_no = p_file_no;
   END cancel_file;
END giacs609_pkg;
/