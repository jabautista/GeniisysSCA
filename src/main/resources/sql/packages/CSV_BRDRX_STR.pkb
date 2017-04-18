CREATE OR REPLACE PACKAGE BODY cpi.csv_brdrx_str
AS
   FUNCTION get_source_type_desc (p_buss_source_type VARCHAR2)
      RETURN VARCHAR2
   IS
      v_source_type_desc   giis_intm_type.intm_desc%TYPE;
   BEGIN
      IF p_buss_source_type IS NULL
      THEN
         v_source_type_desc := NULL;
      ELSE
         BEGIN
            SELECT intm_desc
              INTO v_source_type_desc
              FROM giis_intm_type
             WHERE intm_type = p_buss_source_type;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_source_type_desc := 'REINSURER ';
            WHEN OTHERS
            THEN
               v_source_type_desc := NULL;
         END;
      END IF;

      RETURN v_source_type_desc;
   END get_source_type_desc;

   FUNCTION get_source_name (p_iss_type VARCHAR2, p_buss_source VARCHAR2)
      RETURN VARCHAR2
   IS
      v_source_name   giis_intermediary.intm_name%TYPE;
   BEGIN
      IF p_iss_type = 'RI'
      THEN
         BEGIN
            SELECT ri_name
              INTO v_source_name
              FROM giis_reinsurer
             WHERE ri_cd = p_buss_source;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_source_name := NULL;
         END;
      ELSE
         BEGIN
            SELECT intm_name
              INTO v_source_name
              FROM giis_intermediary
             WHERE intm_no = p_buss_source;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_source_name := NULL;
         END;
      END IF;

      RETURN v_source_name;
   END get_source_name;

   FUNCTION get_subline_name (p_line_cd VARCHAR2, p_subline_cd VARCHAR2)
      RETURN VARCHAR2
   IS
      v_subline_name   giis_subline.subline_name%TYPE;
   BEGIN
      BEGIN
         SELECT subline_name
           INTO v_subline_name
           FROM giis_subline
          WHERE subline_cd = p_subline_cd AND line_cd = p_line_cd;
      EXCEPTION
         WHEN OTHERS
         THEN
            v_subline_name := NULL;
      END;

      RETURN v_subline_name;
   END get_subline_name;

   FUNCTION get_pol_no_ref_no (p_claim_id NUMBER, p_policy_no VARCHAR2)
      RETURN VARCHAR2
   IS
      v_ref_pol_no      gipi_polbasic.ref_pol_no%TYPE;
      v_pol_no_ref_no   VARCHAR2 (70);
   BEGIN
      BEGIN
         SELECT b.ref_pol_no
           INTO v_ref_pol_no
           FROM gicl_claims a, gipi_polbasic b
          WHERE a.line_cd = b.line_cd
            AND a.subline_cd = b.subline_cd
            AND a.pol_iss_cd = b.iss_cd
            AND a.issue_yy = b.issue_yy
            AND a.pol_seq_no = b.pol_seq_no
            AND a.renew_no = b.renew_no
            AND b.endt_seq_no = 0
            AND a.claim_id = p_claim_id
            AND ref_pol_no IS NOT NULL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_ref_pol_no := NULL;
      END;

      IF v_ref_pol_no IS NOT NULL
      THEN
         v_pol_no_ref_no := p_policy_no || '/' || v_ref_pol_no;
      ELSE
         v_pol_no_ref_no := p_policy_no;
      END IF;

      RETURN v_pol_no_ref_no;
   END get_pol_no_ref_no;

   FUNCTION get_intm_ri (
      p_claim_id     NUMBER,
      p_session_id   VARCHAR2,
      p_intm_break   NUMBER,
      p_item_no      NUMBER,
      p_peril_cd     VARCHAR2,
      p_intm_no      NUMBER
   )
      RETURN VARCHAR2
   IS
      v_pol_iss_cd   gicl_claims.pol_iss_cd%TYPE;
      v_intm_ri      VARCHAR2 (4000);
   BEGIN
      BEGIN
         SELECT pol_iss_cd
           INTO v_pol_iss_cd
           FROM gicl_claims
          WHERE claim_id = p_claim_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_pol_iss_cd := NULL;
      END;

      IF v_pol_iss_cd = variables_ri_iss_cd
      THEN
         BEGIN
            FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                        FROM gicl_claims a, giis_reinsurer b
                       WHERE a.ri_cd = b.ri_cd AND a.claim_id = p_claim_id)
            LOOP
               IF v_intm_ri IS NULL
               THEN
                  v_intm_ri := TO_CHAR (r.ri_cd) || '/' || r.ri_name;
               ELSE
                  v_intm_ri :=
                        v_intm_ri
                     || CHR (10)
                     || TO_CHAR (r.ri_cd)
                     || '/'
                     || r.ri_name;
               END IF;
            END LOOP;
         END;
      ELSE
         IF p_intm_break = 1
         THEN
            BEGIN
               FOR i IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                           FROM gicl_res_brdrx_extr a, giis_intermediary b
                          WHERE a.intm_no = b.intm_no
                            AND a.session_id = p_session_id
                            AND a.claim_id = p_claim_id
                            AND a.item_no = p_item_no
                            AND a.peril_cd = p_peril_cd
                            AND a.intm_no = p_intm_no)
               LOOP
                  IF v_intm_ri IS NULL
                  THEN
                     v_intm_ri :=
                           TO_CHAR (i.intm_no)
                        || '/'
                        || i.ref_intm_cd
                        || '/'
                        || i.intm_name;
                  ELSE
                     v_intm_ri :=
                           v_intm_ri
                        || CHR (10)
                        || TO_CHAR (i.intm_no)
                        || '/'
                        || i.ref_intm_cd
                        || '/'
                        || i.intm_name;
                  END IF;
               END LOOP;
            END;
         ELSIF p_intm_break = 0
         THEN
            BEGIN
               FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                           FROM gicl_intm_itmperil a, giis_intermediary b
                          WHERE a.intm_no = b.intm_no
                            AND a.claim_id = p_claim_id
                            AND a.item_no = p_item_no
                            AND a.peril_cd = p_peril_cd)
               LOOP
                  IF v_intm_ri IS NULL
                  THEN
                     v_intm_ri :=
                           TO_CHAR (m.intm_no)
                        || '/'
                        || m.ref_intm_cd
                        || '/'
                        || m.intm_name;
                  ELSE
                     v_intm_ri :=
                           v_intm_ri
                        || CHR (10)
                        || TO_CHAR (m.intm_no)
                        || '/'
                        || m.ref_intm_cd
                        || '/'
                        || m.intm_name;
                  END IF;
               END LOOP;
            END;
         END IF;
      END IF;

      RETURN v_intm_ri;
   END get_intm_ri;

   FUNCTION escape_string (p_string VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN '"' || REPLACE (p_string, '"', '""') || '"';
   END;

   FUNCTION csv_giclr205le (
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_intm_break   NUMBER
   )
      RETURN str_csv_rec_tab PIPELINED
   IS
      v                  str_csv_rec_type;
      v_row              brdrx_rec_type;
      v_shr_query        VARCHAR2 (32000);
      v_query            VARCHAR2 (32767);
      v_col_hrd          VARCHAR2 (32767);
      v_col_val          VARCHAR2 (32767);
      v_cur_id           INTEGER;
      v_str_var          VARCHAR2 (4000);
      v_num_var          NUMBER;
      v_date_var         DATE;
      v_desc_tab         DBMS_SQL.desc_tab;
      v_col_cnt          NUMBER;
      v_cnt_loss_shr     NUMBER            := 0;
      v_cnt_exp_shr      NUMBER            := 0;
      v_loss_main_cols   NUMBER;
      v_nxt_col          NUMBER;
   BEGIN
      v_col_hrd :=
            'BUSINESS SOURCE,SOURCE NAME,ISSUE SOURCE,LINE,SUBLINE,'
         || 'LOSS YEAR,CLAIM NUMBER,POLICY NUMBER,ASSURED,INCEPT DATE,'
         || 'EXPIRY DATE,DATE OF LOSS,ITEM,TOTAL SUM INSURED,PERIL,'
         || 'LOSS CATEGORY,INTERMEDIARY,OUTSTANDING LOSS';

      FOR a IN (SELECT DISTINCT a.share_cd, a.trty_name
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND b.claim_id = NVL (p_claim_id, b.claim_id)
                            AND (  NVL (b.loss_reserve, 0)
                                 - NVL (b.losses_paid, 0)
                                ) > 0
                            AND a.share_cd IN (1, 999)
                       ORDER BY a.share_cd)
      LOOP
         v_cnt_loss_shr := v_cnt_loss_shr + 1;
         v_col_hrd := v_col_hrd || ',"' || a.trty_name || ' - LOSS"';
         v_shr_query :=
               v_shr_query
            || ', SUM (DECODE (c.grp_seq_no, '
            || a.share_cd
            || ', NVL (c.loss_reserve, 0) - NVL (c.losses_paid, 0), 0)) "'
            || a.share_cd
            || '-LOSS'
            || '"';
      END LOOP;

      FOR b IN (SELECT DISTINCT a.share_cd,
                                NVL (a.trty_name, '        ') trty_name,
                                a.line_cd
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND b.claim_id = NVL (p_claim_id, b.claim_id)
                            AND (  NVL (b.loss_reserve, 0)
                                 - NVL (b.losses_paid, 0)
                                ) > 0
                            AND a.share_cd NOT IN (1, 999)
                       ORDER BY a.line_cd, a.share_cd)
      LOOP
         v_cnt_loss_shr := v_cnt_loss_shr + 1;
         v_col_hrd :=
            v_col_hrd || ',"' || b.line_cd || ' - ' || b.trty_name
            || ' - LOSS"';
         v_shr_query :=
               v_shr_query
            || ', SUM (DECODE (c.grp_seq_no||''-''||a.line_cd, '''
            || b.share_cd
            || '-'
            || b.line_cd
            || ''', NVL (c.loss_reserve, 0) - NVL (c.losses_paid, 0), 0)) "'
            || b.share_cd
            || '-'
            || b.line_cd
            || '-LOSS'
            || '"';
      END LOOP;

      v_col_hrd := v_col_hrd || ',' || 'OUTSTANDING EXPENSE';

      FOR c IN (SELECT DISTINCT a.share_cd, a.trty_name
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND b.claim_id = NVL (p_claim_id, b.claim_id)
                            AND (  NVL (b.expense_reserve, 0)
                                 - NVL (b.expenses_paid, 0)
                                ) > 0
                            AND a.share_cd IN (1, 999)
                       ORDER BY a.share_cd)
      LOOP
         v_cnt_exp_shr := v_cnt_exp_shr + 1;
         v_col_hrd := v_col_hrd || ',"' || c.trty_name || ' - EXPENSE"';
         v_shr_query :=
               v_shr_query
            || ', SUM (DECODE (c.grp_seq_no, '
            || c.share_cd
            || ', NVL (c.expense_reserve, 0) - NVL (c.expenses_paid, 0), 0)) "'
            || c.share_cd
            || '-EXP'
            || '"';
      END LOOP;

      FOR d IN (SELECT DISTINCT a.share_cd,
                                NVL (a.trty_name, '        ') trty_name,
                                a.line_cd
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND b.claim_id = NVL (p_claim_id, b.claim_id)
                            AND (  NVL (b.expense_reserve, 0)
                                 - NVL (b.expenses_paid, 0)
                                ) > 0
                            AND a.share_cd NOT IN (1, 999)
                       ORDER BY a.line_cd, a.share_cd)
      LOOP
         v_cnt_exp_shr := v_cnt_exp_shr + 1;
         v_col_hrd :=
               v_col_hrd
            || ',"'
            || d.line_cd
            || ' - '
            || d.trty_name
            || ' - EXPENSE"';
         v_shr_query :=
               v_shr_query
            || ', SUM (DECODE (c.grp_seq_no||''-''||a.line_cd, '''
            || d.share_cd
            || '-'
            || d.line_cd
            || ''', NVL (c.expense_reserve, 0) - NVL (c.expenses_paid, 0), 0)) "'
            || d.share_cd
            || '-'
            || d.line_cd
            || '-EXP'
            || '"';
      END LOOP;

      v.rec := v_col_hrd;
      PIPE ROW (v);
      v_loss_main_cols := v_cnt_loss_shr + 22;
      v_nxt_col := v_loss_main_cols + 1;
      v_query :=
            'SELECT DISTINCT DECODE (a.iss_cd, ''RI'', ''RI'', ''DI'') iss_type,
                    DECODE (a.iss_cd, ''RI'', ''RI'', b.intm_type) buss_source_type,
                    a.iss_cd, a.buss_source, a.line_cd, a.subline_cd,
                    a.loss_year, a.claim_id, a.assd_no, a.claim_no, a.policy_no,
                    a.incept_date, a.expiry_date, a.loss_date, a.item_no,
                    a.grouped_item_no, a.peril_cd,
                    csv_brdrx.get_loss_category (a.line_cd, a.loss_cat_cd
                                                ) loss_cat_des,
                    a.tsi_amt, a.intm_no,
                      SUM (NVL (c.loss_reserve, 0)
                    - NVL (c.losses_paid, 0)) outstanding_loss,
                      SUM (NVL (c.expense_reserve, 0)
                    - NVL (c.expenses_paid, 0)) outstanding_expense'
         || v_shr_query
         || ' FROM gicl_res_brdrx_extr a,
                   giis_intermediary b,
                   gicl_res_brdrx_ds_extr c
             WHERE a.buss_source = b.intm_no(+)
               AND a.session_id = '
         || p_session_id
         || ' AND a.claim_id = '
         || NVL (p_claim_id, 'a.claim_id')
         || ' AND a.brdrx_record_id = c.brdrx_record_id
              AND a.session_id = c.session_id
          GROUP BY DECODE (a.iss_cd, ''RI'', ''RI'', ''DI''),
                   DECODE (a.iss_cd, ''RI'', ''RI'', b.intm_type), a.iss_cd,
                   a.buss_source, a.line_cd, a.subline_cd,a.loss_year,
                   a.claim_id, a.assd_no, a.claim_no, a.policy_no, a.incept_date,
                   a.expiry_date, a.loss_date, a.item_no, a.grouped_item_no,
                   a.peril_cd, csv_brdrx.get_loss_category (a.line_cd,
                                                            a.loss_cat_cd
                                                           ),
                   a.tsi_amt, a.intm_no
            HAVING SUM (NVL (c.loss_reserve, 0)
                        - NVL (c.losses_paid, 0)) > 0
                OR SUM (  NVL (c.expense_reserve, 0)
                        - NVL (c.expenses_paid, 0)
                       ) > 0
             ORDER BY a.claim_no';
      v_cur_id := DBMS_SQL.open_cursor;
      DBMS_SQL.parse (v_cur_id, v_query, DBMS_SQL.native);
      v_col_cnt := DBMS_SQL.EXECUTE (v_cur_id);
      DBMS_SQL.describe_columns (v_cur_id, v_col_cnt, v_desc_tab);

      FOR i IN 1 .. v_col_cnt
      LOOP
         IF v_desc_tab (i).col_type = 2
         THEN
            DBMS_SQL.define_column (v_cur_id, i, v_num_var);
         ELSIF v_desc_tab (i).col_type = 12
         THEN
            DBMS_SQL.define_column (v_cur_id, i, v_date_var);
         ELSE
            DBMS_SQL.define_column (v_cur_id, i, v_str_var, 4000);
         END IF;
      END LOOP;

      WHILE DBMS_SQL.fetch_rows (v_cur_id) > 0
      LOOP
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 1, v_row.iss_type);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 2, v_row.buss_source_type);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 3, v_row.iss_cd);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 4, v_row.buss_source);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 5, v_row.line_cd);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 6, v_row.subline_cd);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 7, v_row.loss_year);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 8, v_row.claim_id);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 9, v_row.assd_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 10, v_row.claim_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 11, v_row.policy_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 12, v_row.incept_date);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 13, v_row.expiry_date);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 14, v_row.loss_date);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 15, v_row.item_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 16, v_row.grouped_item_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 17, v_row.peril_cd);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 18, v_row.loss_cat_des);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 19, v_row.tsi_amt);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 20, v_row.intm_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 21, v_row.os_loss);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 22, v_row.os_expense);
         v_row.source_type_desc :=
                                get_source_type_desc (v_row.buss_source_type);
         v_row.source_name :=
                          get_source_name (v_row.iss_type, v_row.buss_source);
         v_row.iss_name := get_iss_name (v_row.iss_cd);
         v_row.line_name := get_line_name (v_row.line_cd);
         v_row.subline_name :=
                           get_subline_name (v_row.line_cd, v_row.subline_cd);
         v_row.pol_no_ref_no :=
                          get_pol_no_ref_no (v_row.claim_id, v_row.policy_no);
         v_row.assd_name := get_assd_name (v_row.assd_no);
         v_row.item_title :=
            get_gpa_item_title (v_row.claim_id,
                                v_row.line_cd,
                                v_row.item_no,
                                NVL (v_row.grouped_item_no, 0)
                               );
         v_row.peril_name := get_peril_name (v_row.line_cd, v_row.peril_cd);
         v_row.intm_ri :=
            get_intm_ri (v_row.claim_id,
                         p_session_id,
                         p_intm_break,
                         v_row.item_no,
                         v_row.peril_cd,
                         v_row.intm_no
                        );
         v_col_val :=
               escape_string (v_row.source_type_desc)
            || ','
            || escape_string (v_row.source_name)
            || ','
            || escape_string (v_row.iss_name)
            || ','
            || escape_string (v_row.line_name)
            || ','
            || escape_string (v_row.subline_name)
            || ','
            || v_row.loss_year
            || ','
            || escape_string (v_row.claim_no)
            || ','
            || escape_string (v_row.pol_no_ref_no)
            || ','
            || escape_string (v_row.assd_name)
            || ','
            || TO_CHAR (v_row.incept_date, 'mm-dd-yyyy')
            || ','
            || TO_CHAR (v_row.expiry_date, 'mm-dd-yyyy')
            || ','
            || TO_CHAR (v_row.loss_date, 'mm-dd-yyyy')
            || ','
            || escape_string (v_row.item_title)
            || ','
            || escape_string (TO_CHAR (v_row.tsi_amt, 'fm999,999,999,990.00'))
            || ','
            || escape_string (v_row.peril_name)
            || ','
            || escape_string (v_row.loss_cat_des)
            || ','
            || escape_string (v_row.intm_ri)
            || ','
            || escape_string (TO_CHAR (v_row.os_loss, 'fm999,999,999,990.00'));

         FOR i IN 23 .. v_loss_main_cols
         LOOP
            v_str_var := NULL;
            v_num_var := NULL;
            v_date_var := NULL;

            IF (v_desc_tab (i).col_type = 1)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, i, v_str_var);
               v_col_val := v_col_val || ',' || escape_string (v_str_var);
            ELSIF (v_desc_tab (i).col_type = 2)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, i, v_num_var);
               v_col_val :=
                     v_col_val
                  || ','
                  || escape_string (TO_CHAR (v_num_var,
                                             'fm999,999,999,990.00')
                                   );
            ELSIF (v_desc_tab (i).col_type = 12)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, i, v_date_var);
               v_col_val :=
                      v_col_val || ',' || TO_CHAR (v_date_var, 'mm-dd-yyyy');
            END IF;
         END LOOP;

         v_col_val :=
               v_col_val
            || ','
            || escape_string (TO_CHAR (v_row.os_expense,
                                       'fm999,999,999,990.00'
                                      )
                             );

         FOR j IN v_nxt_col .. v_col_cnt
         LOOP
            v_str_var := NULL;
            v_num_var := NULL;
            v_date_var := NULL;

            IF (v_desc_tab (j).col_type = 1)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, j, v_str_var);
               v_col_val := v_col_val || ',' || escape_string (v_str_var);
            ELSIF (v_desc_tab (j).col_type = 2)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, j, v_num_var);
               v_col_val :=
                     v_col_val
                  || ','
                  || escape_string (TO_CHAR (v_num_var,
                                             'fm999,999,999,990.00')
                                   );
            ELSIF (v_desc_tab (j).col_type = 12)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, j, v_date_var);
               v_col_val :=
                      v_col_val || ',' || TO_CHAR (v_date_var, 'mm-dd-yyyy');
            END IF;
         END LOOP;

         v.rec := v_col_val;
         PIPE ROW (v);
      END LOOP;

      DBMS_SQL.close_cursor (v_cur_id);
      RETURN;
   END csv_giclr205le;

   FUNCTION csv_giclr206le (
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_intm_break   NUMBER,
      p_paid_date    NUMBER,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2
   )
      RETURN str_csv_rec_tab PIPELINED
   IS
      v                  str_csv_rec_type;
      v_row              brdrx_rec_type;
      v_shr_query        VARCHAR2 (32000);
      v_query            VARCHAR2 (32767);
      v_col_hrd          VARCHAR2 (32767);
      v_col_val          VARCHAR2 (32767);
      v_cur_id           NUMBER;
      v_str_var          VARCHAR2 (4000);
      v_num_var          NUMBER;
      v_date_var         DATE;
      v_desc_tab         DBMS_SQL.desc_tab;
      v_col_cnt          NUMBER;
      v_cnt_loss_shr     NUMBER            := 0;
      v_cnt_exp_shr      NUMBER            := 0;
      v_loss_main_cols   NUMBER;
      v_nxt_col          NUMBER;
   BEGIN
      v_col_hrd :=
            'BUSINESS SOURCE,SOURCE NAME,ISSUE SOURCE,LINE,SUBLINE,'
         || 'LOSS YEAR,CLAIM NUMBER,POLICY NUMBER,ASSURED,INCEPT DATE,'
         || 'EXPIRY DATE,DATE OF LOSS,ITEM,TOTAL SUM INSURED,PERIL,'
         || 'LOSS CATEGORY,INTERMEDIARY,VOUCHER NUMBER - LOSS,LOSSES PAID';

      FOR a IN (SELECT DISTINCT a.share_cd, a.trty_name
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND b.claim_id = NVL (p_claim_id, b.claim_id)
                            AND a.share_cd IN (1, 999)
                            AND NVL (b.losses_paid, 0) <> 0
                       ORDER BY a.share_cd)
      LOOP
         v_cnt_loss_shr := v_cnt_loss_shr + 1;
         v_col_hrd := v_col_hrd || ',"' || a.trty_name || ' - LOSS"';
         v_shr_query :=
               v_shr_query
            || ', SUM (DECODE (c.grp_seq_no, '
            || a.share_cd
            || ', NVL (c.losses_paid, 0), 0)) "'
            || a.share_cd
            || '-LOSS'
            || '"';
      END LOOP;

      FOR b IN (SELECT DISTINCT a.share_cd,
                                NVL (a.trty_name, '        ') trty_name,
                                a.line_cd
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND b.claim_id = NVL (p_claim_id, b.claim_id)
                            AND a.share_cd NOT IN (1, 999)
                            AND NVL (b.losses_paid, 0) <> 0
                       ORDER BY a.line_cd, a.share_cd)
      LOOP
         v_cnt_loss_shr := v_cnt_loss_shr + 1;
         v_col_hrd :=
            v_col_hrd || ',"' || b.line_cd || ' - ' || b.trty_name
            || ' - LOSS"';
         v_shr_query :=
               v_shr_query
            || ', SUM (DECODE (c.grp_seq_no||''-''||a.line_cd, '''
            || b.share_cd
            || '-'
            || b.line_cd
            || ''', NVL (c.losses_paid, 0), 0)) "'
            || b.share_cd
            || '-'
            || b.line_cd
            || '-LOSS'
            || '"';
      END LOOP;

      v_col_hrd :=
                  v_col_hrd || ',' || 'VOUCHER NUMBER - EXPENSE,EXPENSES PAID';

      FOR c IN (SELECT DISTINCT a.share_cd, a.trty_name
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND b.claim_id = NVL (p_claim_id, b.claim_id)
                            AND a.share_cd IN (1, 999)
                            AND NVL (b.expenses_paid, 0) <> 0
                       ORDER BY a.share_cd)
      LOOP
         v_cnt_exp_shr := v_cnt_exp_shr + 1;
         v_col_hrd := v_col_hrd || ',"' || c.trty_name || ' - EXPENSE"';
         v_shr_query :=
               v_shr_query
            || ', SUM (DECODE (c.grp_seq_no, '
            || c.share_cd
            || ', NVL (c.expenses_paid, 0), 0)) "'
            || c.share_cd
            || '-EXP'
            || '"';
      END LOOP;

      FOR d IN (SELECT DISTINCT a.share_cd,
                                NVL (a.trty_name, '        ') trty_name,
                                a.line_cd
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND b.claim_id = NVL (p_claim_id, b.claim_id)
                            AND a.share_cd NOT IN (1, 999)
                            AND NVL (b.expenses_paid, 0) <> 0
                       ORDER BY a.line_cd, a.share_cd)
      LOOP
         v_cnt_exp_shr := v_cnt_exp_shr + 1;
         v_col_hrd :=
               v_col_hrd
            || ',"'
            || d.line_cd
            || ' - '
            || d.trty_name
            || ' - EXPENSE"';
         v_shr_query :=
               v_shr_query
            || ', SUM (DECODE (c.grp_seq_no||''-''||a.line_cd, '''
            || d.share_cd
            || '-'
            || d.line_cd
            || ''', NVL (c.expenses_paid, 0), 0)) "'
            || d.share_cd
            || '-'
            || d.line_cd
            || '-EXP'
            || '"';
      END LOOP;

      v.rec := v_col_hrd;
      PIPE ROW (v);
      v_loss_main_cols := v_cnt_loss_shr + 24;
      v_nxt_col := v_loss_main_cols + 1;
      v_query :=
            'SELECT DISTINCT DECODE (a.iss_cd, ''RI'', ''RI'', ''DI'') iss_type,
                    DECODE (a.iss_cd, ''RI'', ''RI'', b.intm_type) buss_source_type,
                    a.iss_cd, a.buss_source, a.line_cd, a.subline_cd,
                    a.loss_year, a.claim_id, a.assd_no, a.claim_no, a.policy_no,
                    a.incept_date, a.expiry_date, a.loss_date, a.item_no,
                    a.grouped_item_no, a.peril_cd,
                    csv_brdrx.get_loss_category (a.line_cd, a.loss_cat_cd
                                                ) loss_cat_des,
                    a.tsi_amt, a.intm_no, SUM (NVL (c.losses_paid, 0)) losses_paid,
                    SUM (NVL (c.expenses_paid, 0)) expenses_paid,
                    csv_brdrx.get_voucher_check_no (a.claim_id, a.item_no,
                                            a.peril_cd, a.grouped_item_no,'''
         || p_from_date
         || ''','''
         || p_to_date
         || ''','
         || p_paid_date
         || ', a.clm_res_hist_id,''L'') voucher_chk_no_loss,
                    csv_brdrx.get_voucher_check_no (a.claim_id, a.item_no,
                                            a.peril_cd, a.grouped_item_no,'''
         || p_from_date
         || ''','''
         || p_to_date
         || ''','
         || p_paid_date
         || ', a.clm_res_hist_id,''E'') voucher_chk_no_exp'
         || v_shr_query
         || ' FROM gicl_res_brdrx_extr a,
                   giis_intermediary b,
                   gicl_res_brdrx_ds_extr c
             WHERE a.buss_source = b.intm_no(+)
               AND a.session_id = '
         || p_session_id
         || ' AND a.claim_id = '
         || NVL (p_claim_id, 'a.claim_id')
         || ' AND a.brdrx_record_id = c.brdrx_record_id
              AND a.session_id = c.session_id
          GROUP BY DECODE (a.iss_cd, ''RI'', ''RI'', ''DI''),
                   DECODE (a.iss_cd, ''RI'', ''RI'', b.intm_type), a.iss_cd,
                   a.buss_source, a.line_cd, a.subline_cd,a.loss_year,
                   a.claim_id, a.assd_no, a.claim_no, a.policy_no, a.incept_date,
                   a.expiry_date, a.loss_date, a.item_no, a.grouped_item_no,
                   a.peril_cd, csv_brdrx.get_loss_category (a.line_cd,
                                                            a.loss_cat_cd
                                                           ),
                   a.tsi_amt, a.intm_no,
                   csv_brdrx.get_voucher_check_no (a.claim_id, a.item_no,
                                            a.peril_cd, a.grouped_item_no,'''
         || p_from_date
         || ''','''
         || p_to_date
         || ''','
         || p_paid_date
         || ', a.clm_res_hist_id,''L''),
                   csv_brdrx.get_voucher_check_no (a.claim_id, a.item_no,
                                            a.peril_cd, a.grouped_item_no,'''
         || p_from_date
         || ''','''
         || p_to_date
         || ''','
         || p_paid_date
         || ', a.clm_res_hist_id,''E'')
            HAVING SUM (NVL (c.losses_paid, 0)) <> 0
                OR SUM (NVL (c.expenses_paid, 0)) <> 0
             ORDER BY a.claim_no';
      v_cur_id := DBMS_SQL.open_cursor;
      DBMS_SQL.parse (v_cur_id, v_query, DBMS_SQL.native);
      v_col_cnt := DBMS_SQL.EXECUTE (v_cur_id);
      DBMS_SQL.describe_columns (v_cur_id, v_col_cnt, v_desc_tab);

      FOR i IN 1 .. v_col_cnt
      LOOP
         IF v_desc_tab (i).col_type = 2
         THEN
            DBMS_SQL.define_column (v_cur_id, i, v_num_var);
         ELSIF v_desc_tab (i).col_type = 12
         THEN
            DBMS_SQL.define_column (v_cur_id, i, v_date_var);
         ELSE
            DBMS_SQL.define_column (v_cur_id, i, v_str_var, 4000);
         END IF;
      END LOOP;

      WHILE DBMS_SQL.fetch_rows (v_cur_id) > 0
      LOOP
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 1, v_row.iss_type);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 2, v_row.buss_source_type);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 3, v_row.iss_cd);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 4, v_row.buss_source);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 5, v_row.line_cd);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 6, v_row.subline_cd);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 7, v_row.loss_year);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 8, v_row.claim_id);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 9, v_row.assd_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 10, v_row.claim_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 11, v_row.policy_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 12, v_row.incept_date);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 13, v_row.expiry_date);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 14, v_row.loss_date);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 15, v_row.item_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 16, v_row.grouped_item_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 17, v_row.peril_cd);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 18, v_row.loss_cat_des);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 19, v_row.tsi_amt);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 20, v_row.intm_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 21, v_row.losses_paid);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 22, v_row.expenses_paid);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 23, v_row.voucher_chk_no_loss);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 24, v_row.voucher_chk_no_exp);
         v_row.source_type_desc :=
                                get_source_type_desc (v_row.buss_source_type);
         v_row.source_name :=
                          get_source_name (v_row.iss_type, v_row.buss_source);
         v_row.iss_name := get_iss_name (v_row.iss_cd);
         v_row.line_name := get_line_name (v_row.line_cd);
         v_row.subline_name :=
                           get_subline_name (v_row.line_cd, v_row.subline_cd);
         v_row.pol_no_ref_no :=
                          get_pol_no_ref_no (v_row.claim_id, v_row.policy_no);
         v_row.assd_name := get_assd_name (v_row.assd_no);
         v_row.item_title :=
            get_gpa_item_title (v_row.claim_id,
                                v_row.line_cd,
                                v_row.item_no,
                                NVL (v_row.grouped_item_no, 0)
                               );
         v_row.peril_name := get_peril_name (v_row.line_cd, v_row.peril_cd);
         v_row.intm_ri :=
            get_intm_ri (v_row.claim_id,
                         p_session_id,
                         p_intm_break,
                         v_row.item_no,
                         v_row.peril_cd,
                         v_row.intm_no
                        );
         v_col_val :=
               escape_string (v_row.source_type_desc)
            || ','
            || escape_string (v_row.source_name)
            || ','
            || escape_string (v_row.iss_name)
            || ','
            || escape_string (v_row.line_name)
            || ','
            || escape_string (v_row.subline_name)
            || ','
            || v_row.loss_year
            || ','
            || escape_string (v_row.claim_no)
            || ','
            || escape_string (v_row.pol_no_ref_no)
            || ','
            || escape_string (v_row.assd_name)
            || ','
            || TO_CHAR (v_row.incept_date, 'mm-dd-yyyy')
            || ','
            || TO_CHAR (v_row.expiry_date, 'mm-dd-yyyy')
            || ','
            || TO_CHAR (v_row.loss_date, 'mm-dd-yyyy')
            || ','
            || escape_string (v_row.item_title)
            || ','
            || escape_string (TO_CHAR (v_row.tsi_amt, 'fm999,999,999,990.00'))
            || ','
            || escape_string (v_row.peril_name)
            || ','
            || escape_string (v_row.loss_cat_des)
            || ','
            || escape_string (v_row.intm_ri)
            || ','
            || escape_string (v_row.voucher_chk_no_loss)
            || ','
            || escape_string (TO_CHAR (v_row.losses_paid,
                                       'fm999,999,999,990.00'
                                      )
                             );

         FOR i IN 25 .. v_loss_main_cols
         LOOP
            v_str_var := NULL;
            v_num_var := NULL;
            v_date_var := NULL;

            IF (v_desc_tab (i).col_type = 1)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, i, v_str_var);
               v_col_val := v_col_val || ',' || escape_string (v_str_var);
            ELSIF (v_desc_tab (i).col_type = 2)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, i, v_num_var);
               v_col_val :=
                     v_col_val
                  || ','
                  || escape_string (TO_CHAR (v_num_var,
                                             'fm999,999,999,990.00')
                                   );
            ELSIF (v_desc_tab (i).col_type = 12)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, i, v_date_var);
               v_col_val :=
                      v_col_val || ',' || TO_CHAR (v_date_var, 'mm-dd-yyyy');
            END IF;
         END LOOP;

         v_col_val :=
               v_col_val
            || ','
            || escape_string (v_row.voucher_chk_no_exp)
            || ','
            || escape_string (TO_CHAR (v_row.expenses_paid,
                                       'fm999,999,999,990.00'
                                      )
                             );

         FOR j IN v_nxt_col .. v_col_cnt
         LOOP
            v_str_var := NULL;
            v_num_var := NULL;
            v_date_var := NULL;

            IF (v_desc_tab (j).col_type = 1)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, j, v_str_var);
               v_col_val := v_col_val || ',' || escape_string (v_str_var);
            ELSIF (v_desc_tab (j).col_type = 2)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, j, v_num_var);
               v_col_val :=
                     v_col_val
                  || ','
                  || escape_string (TO_CHAR (v_num_var,
                                             'fm999,999,999,990.00')
                                   );
            ELSIF (v_desc_tab (j).col_type = 12)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, j, v_date_var);
               v_col_val :=
                      v_col_val || ',' || TO_CHAR (v_date_var, 'mm-dd-yyyy');
            END IF;
         END LOOP;

         v.rec := v_col_val;
         PIPE ROW (v);
      END LOOP;

      DBMS_SQL.close_cursor (v_cur_id);
      RETURN;
   END csv_giclr206le;

   FUNCTION csv_giclr221le (
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_paid_date    NUMBER,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2
   )
      RETURN str_csv_rec_tab PIPELINED
   IS
      v                  str_csv_rec_type;
      v_row              brdrx_rec_type;
      v_shr_query        VARCHAR2 (32000);
      v_query            VARCHAR2 (32767);
      v_col_hrd          VARCHAR2 (32767);
      v_col_val          VARCHAR2 (32767);
      v_cur_id           NUMBER;
      v_str_var          VARCHAR2 (4000);
      v_num_var          NUMBER;
      v_date_var         DATE;
      v_desc_tab         DBMS_SQL.desc_tab;
      v_col_cnt          NUMBER;
      v_cnt_loss_shr     NUMBER            := 0;
      v_cnt_exp_shr      NUMBER            := 0;
      v_loss_main_cols   NUMBER;
      v_nxt_col          NUMBER;
   BEGIN
      v_col_hrd :=
            'ENROLLEE,CLAIM NO,POLICY NUMBER,ASSURED,TERM,LOSS DATE,ITEM,'
         || 'TOTAL SUM INSURED,LOSS CATEGORY,INTERMEDIARY / CEDANT,'
         || 'VOUCHER NO / CHECK NO,PAID LOSS';

      FOR a IN (SELECT DISTINCT a.share_cd, a.trty_name
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND b.claim_id = NVL (p_claim_id, b.claim_id)
                            AND a.share_cd IN (1, 999)
                            AND NVL (b.losses_paid, 0) <> 0
                       ORDER BY a.share_cd)
      LOOP
         v_cnt_loss_shr := v_cnt_loss_shr + 1;
         v_col_hrd := v_col_hrd || ',"' || a.trty_name || ' - LOSS"';
         v_shr_query :=
               v_shr_query
            || ', SUM (DECODE (c.grp_seq_no, '
            || a.share_cd
            || ', NVL (c.losses_paid, 0), 0)) "'
            || a.share_cd
            || '-LOSS'
            || '"';
      END LOOP;

      FOR b IN (SELECT DISTINCT a.share_cd,
                                NVL (a.trty_name, '        ') trty_name,
                                a.line_cd
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND b.claim_id = NVL (p_claim_id, b.claim_id)
                            AND a.share_cd NOT IN (1, 999)
                            AND NVL (b.losses_paid, 0) <> 0
                       ORDER BY a.line_cd, a.share_cd)
      LOOP
         v_cnt_loss_shr := v_cnt_loss_shr + 1;
         v_col_hrd :=
            v_col_hrd || ',"' || b.line_cd || ' - ' || b.trty_name
            || ' - LOSS"';
         v_shr_query :=
               v_shr_query
            || ', SUM (DECODE (c.grp_seq_no||''-''||a.line_cd, '''
            || b.share_cd
            || '-'
            || b.line_cd
            || ''', NVL (c.losses_paid, 0), 0)) "'
            || b.share_cd
            || '-'
            || b.line_cd
            || '-LOSS'
            || '"';
      END LOOP;

      v_col_hrd := v_col_hrd || ',' || 'PAID EXPENSE';

      FOR c IN (SELECT DISTINCT a.share_cd, a.trty_name
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND b.claim_id = NVL (p_claim_id, b.claim_id)
                            AND a.share_cd IN (1, 999)
                            AND NVL (b.expenses_paid, 0) <> 0
                       ORDER BY a.share_cd)
      LOOP
         v_cnt_exp_shr := v_cnt_exp_shr + 1;
         v_col_hrd := v_col_hrd || ',"' || c.trty_name || ' - EXPENSE"';
         v_shr_query :=
               v_shr_query
            || ', SUM (DECODE (c.grp_seq_no, '
            || c.share_cd
            || ', NVL (c.expenses_paid, 0), 0)) "'
            || c.share_cd
            || '-EXP'
            || '"';
      END LOOP;

      FOR d IN (SELECT DISTINCT a.share_cd,
                                NVL (a.trty_name, '        ') trty_name,
                                a.line_cd
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND b.claim_id = NVL (p_claim_id, b.claim_id)
                            AND a.share_cd NOT IN (1, 999)
                            AND NVL (b.expenses_paid, 0) <> 0
                       ORDER BY a.line_cd, a.share_cd)
      LOOP
         v_cnt_exp_shr := v_cnt_exp_shr + 1;
         v_col_hrd :=
               v_col_hrd
            || ',"'
            || d.line_cd
            || ' - '
            || d.trty_name
            || ' - EXPENSE"';
         v_shr_query :=
               v_shr_query
            || ', SUM (DECODE (c.grp_seq_no||''-''||a.line_cd, '''
            || d.share_cd
            || '-'
            || d.line_cd
            || ''', NVL (c.expenses_paid, 0), 0)) "'
            || d.share_cd
            || '-'
            || d.line_cd
            || '-EXP'
            || '"';
      END LOOP;

      v.rec := v_col_hrd;
      PIPE ROW (v);
      v_loss_main_cols := v_cnt_loss_shr + 21;
      v_nxt_col := v_loss_main_cols + 1;
      v_query :=
            'SELECT DISTINCT a.iss_cd, a.line_cd, a.subline_cd, a.claim_id,
                    a.enrollee, a.assd_no, a.claim_no, a.policy_no,
                    a.incept_date, a.expiry_date, a.loss_date, a.item_no,
                    a.grouped_item_no, a.peril_cd,
                    csv_brdrx.get_loss_category (a.line_cd, a.loss_cat_cd
                                                ) loss_cat_des, a.tsi_amt,
                    a.intm_no, SUM (NVL (c.losses_paid, 0)) losses_paid,
                    SUM (NVL (c.expenses_paid, 0)) expenses_paid,
                    csv_brdrx.get_voucher_check_no (a.claim_id, a.item_no,
                                            a.peril_cd, a.grouped_item_no,'''
         || p_from_date
         || ''','''
         || p_to_date
         || ''','
         || p_paid_date
         || ', a.clm_res_hist_id,''L'') voucher_chk_no_loss,
                    csv_brdrx.get_voucher_check_no (a.claim_id, a.item_no,
                                            a.peril_cd, a.grouped_item_no,'''
         || p_from_date
         || ''','''
         || p_to_date
         || ''','
         || p_paid_date
         || ', a.clm_res_hist_id,''E'') voucher_chk_no_exp'
         || v_shr_query
         || ' FROM gicl_res_brdrx_extr a,
                   giis_intermediary b,
                   gicl_res_brdrx_ds_extr c
             WHERE a.buss_source = b.intm_no(+)
               AND a.session_id = '
         || p_session_id
         || ' AND a.claim_id = '
         || NVL (p_claim_id, 'a.claim_id')
         || ' AND a.brdrx_record_id = c.brdrx_record_id
              AND a.session_id = c.session_id
          GROUP BY a.iss_cd, a.line_cd, a.subline_cd, a.claim_id, a.enrollee,
                   a.assd_no, a.claim_no, a.policy_no, a.incept_date,
                   a.expiry_date, a.loss_date, a.item_no, a.grouped_item_no,
                   a.peril_cd, csv_brdrx.get_loss_category (a.line_cd,
                                                            a.loss_cat_cd
                                                           ),
                   a.tsi_amt, a.intm_no,
                   csv_brdrx.get_voucher_check_no (a.claim_id, a.item_no,
                                            a.peril_cd, a.grouped_item_no,'''
         || p_from_date
         || ''','''
         || p_to_date
         || ''','
         || p_paid_date
         || ', a.clm_res_hist_id,''L''),
                   csv_brdrx.get_voucher_check_no (a.claim_id, a.item_no,
                                            a.peril_cd, a.grouped_item_no,'''
         || p_from_date
         || ''','''
         || p_to_date
         || ''','
         || p_paid_date
         || ', a.clm_res_hist_id,''E'')
            HAVING SUM (NVL (c.losses_paid, 0)) <> 0
                OR SUM (NVL (c.expenses_paid, 0)) <> 0
             ORDER BY a.enrollee, a.claim_no';
      v_cur_id := DBMS_SQL.open_cursor;
      DBMS_SQL.parse (v_cur_id, v_query, DBMS_SQL.native);
      v_col_cnt := DBMS_SQL.EXECUTE (v_cur_id);
      DBMS_SQL.describe_columns (v_cur_id, v_col_cnt, v_desc_tab);

      FOR i IN 1 .. v_col_cnt
      LOOP
         IF v_desc_tab (i).col_type = 2
         THEN
            DBMS_SQL.define_column (v_cur_id, i, v_num_var);
         ELSIF v_desc_tab (i).col_type = 12
         THEN
            DBMS_SQL.define_column (v_cur_id, i, v_date_var);
         ELSE
            DBMS_SQL.define_column (v_cur_id, i, v_str_var, 4000);
         END IF;
      END LOOP;

      WHILE DBMS_SQL.fetch_rows (v_cur_id) > 0
      LOOP
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 1, v_row.iss_cd);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 2, v_row.line_cd);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 3, v_row.subline_cd);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 4, v_row.claim_id);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 5, v_row.enrollee);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 6, v_row.assd_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 7, v_row.claim_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 8, v_row.policy_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 9, v_row.incept_date);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 10, v_row.expiry_date);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 11, v_row.loss_date);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 12, v_row.item_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 13, v_row.grouped_item_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 14, v_row.peril_cd);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 15, v_row.loss_cat_des);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 16, v_row.tsi_amt);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 17, v_row.intm_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 18, v_row.losses_paid);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 19, v_row.expenses_paid);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 20, v_row.voucher_chk_no_loss);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 21, v_row.voucher_chk_no_exp);
         v_row.pol_no_ref_no :=
                          get_pol_no_ref_no (v_row.claim_id, v_row.policy_no);
         v_row.assd_name := get_assd_name (v_row.assd_no);
         v_row.term :=
               TO_CHAR (v_row.incept_date, 'MM-DD-YYYY')
            || ' - '
            || TO_CHAR (v_row.expiry_date, 'MM-DD-YYYY');
         v_row.item_title :=
            get_gpa_item_title (v_row.claim_id,
                                v_row.line_cd,
                                v_row.item_no,
                                NVL (v_row.grouped_item_no, 0)
                               );
         v_row.intm_ri :=
            get_intm_ri (v_row.claim_id,
                         p_session_id,
                         0,
                         v_row.item_no,
                         v_row.peril_cd,
                         v_row.intm_no
                        );
         v_col_val :=
               escape_string (v_row.enrollee)
            || ','
            || escape_string (v_row.claim_no)
            || ','
            || escape_string (v_row.pol_no_ref_no)
            || ','
            || escape_string (v_row.assd_name)
            || ','
            || escape_string (v_row.term)
            || ','
            || TO_CHAR (v_row.loss_date, 'mm-dd-yyyy')
            || ','
            || escape_string (v_row.item_title)
            || ','
            || escape_string (TO_CHAR (v_row.tsi_amt, 'fm999,999,999,990.00'))
            || ','
            || escape_string (v_row.loss_cat_des)
            || ','
            || escape_string (v_row.intm_ri)
            || ','
            || escape_string (NVL (v_row.voucher_chk_no_loss,
                                   v_row.voucher_chk_no_exp
                                  )
                             )
            || ','
            || escape_string (TO_CHAR (v_row.losses_paid,
                                       'fm999,999,999,990.00'
                                      )
                             );

         FOR i IN 22 .. v_loss_main_cols
         LOOP
            v_str_var := NULL;
            v_num_var := NULL;
            v_date_var := NULL;

            IF (v_desc_tab (i).col_type = 1)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, i, v_str_var);
               v_col_val := v_col_val || ',' || escape_string (v_str_var);
            ELSIF (v_desc_tab (i).col_type = 2)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, i, v_num_var);
               v_col_val :=
                     v_col_val
                  || ','
                  || escape_string (TO_CHAR (v_num_var,
                                             'fm999,999,999,990.00')
                                   );
            ELSIF (v_desc_tab (i).col_type = 12)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, i, v_date_var);
               v_col_val :=
                      v_col_val || ',' || TO_CHAR (v_date_var, 'mm-dd-yyyy');
            END IF;
         END LOOP;

         v_col_val :=
               v_col_val
            || ','
            || escape_string (TO_CHAR (v_row.expenses_paid,
                                       'fm999,999,999,990.00'
                                      )
                             );

         FOR j IN v_nxt_col .. v_col_cnt
         LOOP
            v_str_var := NULL;
            v_num_var := NULL;
            v_date_var := NULL;

            IF (v_desc_tab (j).col_type = 1)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, j, v_str_var);
               v_col_val := v_col_val || ',' || escape_string (v_str_var);
            ELSIF (v_desc_tab (j).col_type = 2)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, j, v_num_var);
               v_col_val :=
                     v_col_val
                  || ','
                  || escape_string (TO_CHAR (v_num_var,
                                             'fm999,999,999,990.00')
                                   );
            ELSIF (v_desc_tab (j).col_type = 12)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, j, v_date_var);
               v_col_val :=
                      v_col_val || ',' || TO_CHAR (v_date_var, 'mm-dd-yyyy');
            END IF;
         END LOOP;

         v.rec := v_col_val;
         PIPE ROW (v);
      END LOOP;

      DBMS_SQL.close_cursor (v_cur_id);
      RETURN;
   END csv_giclr221le;

   FUNCTION csv_giclr221l (
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_paid_date    NUMBER,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2
   )
      RETURN str_csv_rec_tab PIPELINED
   IS
      v             str_csv_rec_type;
      v_row         brdrx_rec_type;
      v_shr_query   VARCHAR2 (32000);
      v_query       VARCHAR2 (32767);
      v_col_hrd     VARCHAR2 (32767);
      v_col_val     VARCHAR2 (32767);
      v_cur_id      NUMBER;
      v_str_var     VARCHAR2 (4000);
      v_num_var     NUMBER;
      v_date_var    DATE;
      v_desc_tab    DBMS_SQL.desc_tab;
      v_col_cnt     NUMBER;
   BEGIN
      v_col_hrd :=
            'ENROLLEE,CLAIM NO,POLICY NO,ASSURED,TERM OR POLICY,LOSS DATE,ITEM,'
         || 'TOTAL SUM INSURED,LOSS CATEGORY,INTERMEDIARY / CEDANT,'
         || 'VOUCHER NO / CHECK NO,PAID LOSS';

      FOR a IN (SELECT DISTINCT a.share_cd, a.trty_name
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND b.claim_id = NVL (p_claim_id, b.claim_id)
                            AND a.share_cd IN (1, 999)
                            AND NVL (b.losses_paid, 0) <> 0
                       ORDER BY a.share_cd)
      LOOP
         v_col_hrd := v_col_hrd || ',"' || a.trty_name || '"';
         v_shr_query :=
               v_shr_query
            || ', SUM (DECODE (c.grp_seq_no, '
            || a.share_cd
            || ', NVL (c.losses_paid, 0), 0)) "'
            || a.share_cd
            || '"';
      END LOOP;

      FOR b IN (SELECT DISTINCT a.share_cd,
                                NVL (a.trty_name, '        ') trty_name,
                                a.line_cd
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND b.claim_id = NVL (p_claim_id, b.claim_id)
                            AND a.share_cd NOT IN (1, 999)
                            AND NVL (b.losses_paid, 0) <> 0
                       ORDER BY a.line_cd, a.share_cd)
      LOOP
         v_col_hrd :=
                v_col_hrd || ',"' || b.line_cd || ' - ' || b.trty_name || '"';
         v_shr_query :=
               v_shr_query
            || ', SUM (DECODE (c.grp_seq_no||''-''||a.line_cd, '''
            || b.share_cd
            || '-'
            || b.line_cd
            || ''', NVL (c.losses_paid, 0), 0)) "'
            || b.share_cd
            || '-'
            || b.line_cd
            || '"';
      END LOOP;

      v.rec := v_col_hrd;
      PIPE ROW (v);
      v_query :=
            'SELECT DISTINCT a.iss_cd, a.line_cd, a.subline_cd, a.claim_id,
                    a.enrollee, a.assd_no, a.claim_no, a.policy_no,
                    a.incept_date, a.expiry_date, a.loss_date, a.item_no,
                    a.grouped_item_no, a.peril_cd,
                    csv_brdrx.get_loss_category (a.line_cd, a.loss_cat_cd
                                                ) loss_cat_des, a.tsi_amt,
                    a.intm_no, SUM (NVL (c.losses_paid, 0)) losses_paid,
                    csv_brdrx.get_voucher_check_no (a.claim_id, a.item_no,
                                            a.peril_cd, a.grouped_item_no,'''
         || p_from_date
         || ''','''
         || p_to_date
         || ''','
         || p_paid_date
         || ', a.clm_res_hist_id,''L'') voucher_chk_no_loss'
         || v_shr_query
         || ' FROM gicl_res_brdrx_extr a,
                   giis_intermediary b,
                   gicl_res_brdrx_ds_extr c
             WHERE a.buss_source = b.intm_no(+)
               AND a.session_id = '
         || p_session_id
         || ' AND a.claim_id = '
         || NVL (p_claim_id, 'a.claim_id')
         || ' AND a.brdrx_record_id = c.brdrx_record_id
              AND a.session_id = c.session_id
          GROUP BY a.iss_cd, a.line_cd, a.subline_cd, a.claim_id, a.enrollee,
                   a.assd_no, a.claim_no, a.policy_no, a.incept_date,
                   a.expiry_date, a.loss_date, a.item_no, a.grouped_item_no,
                   a.peril_cd, csv_brdrx.get_loss_category (a.line_cd,
                                                            a.loss_cat_cd
                                                           ),
                   a.tsi_amt, a.intm_no,
                   csv_brdrx.get_voucher_check_no (a.claim_id, a.item_no,
                                            a.peril_cd, a.grouped_item_no,'''
         || p_from_date
         || ''','''
         || p_to_date
         || ''','
         || p_paid_date
         || ', a.clm_res_hist_id,''L'')
            HAVING SUM (NVL (c.losses_paid, 0)) <> 0
             ORDER BY a.enrollee, a.claim_no';
      v_cur_id := DBMS_SQL.open_cursor;
      DBMS_SQL.parse (v_cur_id, v_query, DBMS_SQL.native);
      v_col_cnt := DBMS_SQL.EXECUTE (v_cur_id);
      DBMS_SQL.describe_columns (v_cur_id, v_col_cnt, v_desc_tab);

      FOR i IN 1 .. v_col_cnt
      LOOP
         IF v_desc_tab (i).col_type = 2
         THEN
            DBMS_SQL.define_column (v_cur_id, i, v_num_var);
         ELSIF v_desc_tab (i).col_type = 12
         THEN
            DBMS_SQL.define_column (v_cur_id, i, v_date_var);
         ELSE
            DBMS_SQL.define_column (v_cur_id, i, v_str_var, 4000);
         END IF;
      END LOOP;

      WHILE DBMS_SQL.fetch_rows (v_cur_id) > 0
      LOOP
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 1, v_row.iss_cd);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 2, v_row.line_cd);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 3, v_row.subline_cd);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 4, v_row.claim_id);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 5, v_row.enrollee);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 6, v_row.assd_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 7, v_row.claim_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 8, v_row.policy_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 9, v_row.incept_date);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 10, v_row.expiry_date);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 11, v_row.loss_date);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 12, v_row.item_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 13, v_row.grouped_item_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 14, v_row.peril_cd);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 15, v_row.loss_cat_des);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 16, v_row.tsi_amt);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 17, v_row.intm_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 18, v_row.losses_paid);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 19, v_row.voucher_chk_no_loss);
         v_row.pol_no_ref_no :=
                          get_pol_no_ref_no (v_row.claim_id, v_row.policy_no);
         v_row.assd_name := get_assd_name (v_row.assd_no);
         v_row.term :=
               TO_CHAR (v_row.incept_date, 'MM-DD-YYYY')
            || ' - '
            || TO_CHAR (v_row.expiry_date, 'MM-DD-YYYY');
         v_row.item_title :=
            get_gpa_item_title (v_row.claim_id,
                                v_row.line_cd,
                                v_row.item_no,
                                NVL (v_row.grouped_item_no, 0)
                               );
         v_row.intm_ri :=
            get_intm_ri (v_row.claim_id,
                         p_session_id,
                         0,
                         v_row.item_no,
                         v_row.peril_cd,
                         v_row.intm_no
                        );
         v_col_val :=
               escape_string (v_row.enrollee)
            || ','
            || escape_string (v_row.claim_no)
            || ','
            || escape_string (v_row.pol_no_ref_no)
            || ','
            || escape_string (v_row.assd_name)
            || ','
            || escape_string (v_row.term)
            || ','
            || TO_CHAR (v_row.loss_date, 'mm-dd-yyyy')
            || ','
            || escape_string (v_row.item_title)
            || ','
            || escape_string (TO_CHAR (v_row.tsi_amt, 'fm999,999,999,990.00'))
            || ','
            || escape_string (v_row.loss_cat_des)
            || ','
            || escape_string (v_row.intm_ri)
            || ','
            || escape_string (v_row.voucher_chk_no_loss)
            || ','
            || escape_string (TO_CHAR (v_row.losses_paid,
                                       'fm999,999,999,990.00'
                                      )
                             );

         FOR i IN 20 .. v_col_cnt
         LOOP
            v_str_var := NULL;
            v_num_var := NULL;
            v_date_var := NULL;

            IF (v_desc_tab (i).col_type = 1)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, i, v_str_var);
               v_col_val := v_col_val || ',' || escape_string (v_str_var);
            ELSIF (v_desc_tab (i).col_type = 2)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, i, v_num_var);
               v_col_val :=
                     v_col_val
                  || ','
                  || escape_string (TO_CHAR (v_num_var,
                                             'fm999,999,999,990.00')
                                   );
            ELSIF (v_desc_tab (i).col_type = 12)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, i, v_date_var);
               v_col_val :=
                      v_col_val || ',' || TO_CHAR (v_date_var, 'mm-dd-yyyy');
            END IF;
         END LOOP;

         v.rec := v_col_val;
         PIPE ROW (v);
      END LOOP;

      DBMS_SQL.close_cursor (v_cur_id);
      RETURN;
   END csv_giclr221l;

   FUNCTION csv_giclr221e (
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_paid_date    NUMBER,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2
   )
      RETURN str_csv_rec_tab PIPELINED
   IS
      v             str_csv_rec_type;
      v_row         brdrx_rec_type;
      v_shr_query   VARCHAR2 (32000);
      v_query       VARCHAR2 (32767);
      v_col_hrd     VARCHAR2 (32767);
      v_col_val     VARCHAR2 (32767);
      v_cur_id      NUMBER;
      v_str_var     VARCHAR2 (4000);
      v_num_var     NUMBER;
      v_date_var    DATE;
      v_desc_tab    DBMS_SQL.desc_tab;
      v_col_cnt     NUMBER;
   BEGIN
      v_col_hrd :=
            'ENROLLEE,CLAIM NO,POLICY NO,ASSURED,TERM OF POLICY,LOSS DATE,ITEM,'
         || 'TOTAL SUM INSURED,LOSS CATEGORY,INTERMEDIARY / CEDANT,'
         || 'VOUCHER NO / CHECK NO,PAID EXPENSE';

      FOR c IN (SELECT DISTINCT a.share_cd, a.trty_name
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND b.claim_id = NVL (p_claim_id, b.claim_id)
                            AND a.share_cd IN (1, 999)
                            AND NVL (b.expenses_paid, 0) <> 0
                       ORDER BY a.share_cd)
      LOOP
         v_col_hrd := v_col_hrd || ',"' || c.trty_name || '"';
         v_shr_query :=
               v_shr_query
            || ', SUM (DECODE (c.grp_seq_no, '
            || c.share_cd
            || ', NVL (c.expenses_paid, 0), 0)) "'
            || c.share_cd
            || '"';
      END LOOP;

      FOR d IN (SELECT DISTINCT a.share_cd,
                                NVL (a.trty_name, '        ') trty_name,
                                a.line_cd
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND b.claim_id = NVL (p_claim_id, b.claim_id)
                            AND a.share_cd NOT IN (1, 999)
                            AND NVL (b.expenses_paid, 0) <> 0
                       ORDER BY a.line_cd, a.share_cd)
      LOOP
         v_col_hrd :=
                v_col_hrd || ',"' || d.line_cd || ' - ' || d.trty_name || '"';
         v_shr_query :=
               v_shr_query
            || ', SUM (DECODE (c.grp_seq_no||''-''||a.line_cd, '''
            || d.share_cd
            || '-'
            || d.line_cd
            || ''', NVL (c.expenses_paid, 0), 0)) "'
            || d.share_cd
            || '-'
            || d.line_cd
            || '"';
      END LOOP;

      v.rec := v_col_hrd;
      PIPE ROW (v);
      v_query :=
            'SELECT DISTINCT a.iss_cd, a.line_cd, a.subline_cd, a.claim_id,
                    a.enrollee, a.assd_no, a.claim_no, a.policy_no,
                    a.incept_date, a.expiry_date, a.loss_date, a.item_no,
                    a.grouped_item_no, a.peril_cd,
                    csv_brdrx.get_loss_category (a.line_cd, a.loss_cat_cd
                                                ) loss_cat_des, a.tsi_amt,
                    a.intm_no, SUM (NVL (c.expenses_paid, 0)) expenses_paid,
                    csv_brdrx.get_voucher_check_no (a.claim_id, a.item_no,
                                            a.peril_cd, a.grouped_item_no,'''
         || p_from_date
         || ''','''
         || p_to_date
         || ''','
         || p_paid_date
         || ', a.clm_res_hist_id,''E'') voucher_chk_no_exp'
         || v_shr_query
         || ' FROM gicl_res_brdrx_extr a,
                   giis_intermediary b,
                   gicl_res_brdrx_ds_extr c
             WHERE a.buss_source = b.intm_no(+)
               AND a.session_id = '
         || p_session_id
         || ' AND a.claim_id = '
         || NVL (p_claim_id, 'a.claim_id')
         || ' AND a.brdrx_record_id = c.brdrx_record_id
              AND a.session_id = c.session_id
          GROUP BY a.iss_cd, a.line_cd, a.subline_cd, a.claim_id, a.enrollee,
                   a.assd_no, a.claim_no, a.policy_no, a.incept_date,
                   a.expiry_date, a.loss_date, a.item_no, a.grouped_item_no,
                   a.peril_cd, csv_brdrx.get_loss_category (a.line_cd,
                                                            a.loss_cat_cd
                                                           ),
                   a.tsi_amt, a.intm_no,
                   csv_brdrx.get_voucher_check_no (a.claim_id, a.item_no,
                                            a.peril_cd, a.grouped_item_no,'''
         || p_from_date
         || ''','''
         || p_to_date
         || ''','
         || p_paid_date
         || ', a.clm_res_hist_id,''E'')
            HAVING SUM (NVL (c.expenses_paid, 0)) <> 0
             ORDER BY a.enrollee, a.claim_no';
      v_cur_id := DBMS_SQL.open_cursor;
      DBMS_SQL.parse (v_cur_id, v_query, DBMS_SQL.native);
      v_col_cnt := DBMS_SQL.EXECUTE (v_cur_id);
      DBMS_SQL.describe_columns (v_cur_id, v_col_cnt, v_desc_tab);

      FOR i IN 1 .. v_col_cnt
      LOOP
         IF v_desc_tab (i).col_type = 2
         THEN
            DBMS_SQL.define_column (v_cur_id, i, v_num_var);
         ELSIF v_desc_tab (i).col_type = 12
         THEN
            DBMS_SQL.define_column (v_cur_id, i, v_date_var);
         ELSE
            DBMS_SQL.define_column (v_cur_id, i, v_str_var, 4000);
         END IF;
      END LOOP;

      WHILE DBMS_SQL.fetch_rows (v_cur_id) > 0
      LOOP
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 1, v_row.iss_cd);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 2, v_row.line_cd);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 3, v_row.subline_cd);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 4, v_row.claim_id);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 5, v_row.enrollee);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 6, v_row.assd_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 7, v_row.claim_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 8, v_row.policy_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 9, v_row.incept_date);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 10, v_row.expiry_date);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 11, v_row.loss_date);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 12, v_row.item_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 13, v_row.grouped_item_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 14, v_row.peril_cd);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 15, v_row.loss_cat_des);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 16, v_row.tsi_amt);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 17, v_row.intm_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 18, v_row.expenses_paid);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 19, v_row.voucher_chk_no_exp);
         v_row.pol_no_ref_no :=
                          get_pol_no_ref_no (v_row.claim_id, v_row.policy_no);
         v_row.assd_name := get_assd_name (v_row.assd_no);
         v_row.term :=
               TO_CHAR (v_row.incept_date, 'MM-DD-YYYY')
            || ' - '
            || TO_CHAR (v_row.expiry_date, 'MM-DD-YYYY');
         v_row.item_title :=
            get_gpa_item_title (v_row.claim_id,
                                v_row.line_cd,
                                v_row.item_no,
                                NVL (v_row.grouped_item_no, 0)
                               );
         v_row.intm_ri :=
            get_intm_ri (v_row.claim_id,
                         p_session_id,
                         0,
                         v_row.item_no,
                         v_row.peril_cd,
                         v_row.intm_no
                        );
         v_col_val :=
               escape_string (v_row.enrollee)
            || ','
            || escape_string (v_row.claim_no)
            || ','
            || escape_string (v_row.pol_no_ref_no)
            || ','
            || escape_string (v_row.assd_name)
            || ','
            || escape_string (v_row.term)
            || ','
            || TO_CHAR (v_row.loss_date, 'mm-dd-yyyy')
            || ','
            || escape_string (v_row.item_title)
            || ','
            || escape_string (TO_CHAR (v_row.tsi_amt, 'fm999,999,999,990.00'))
            || ','
            || escape_string (v_row.loss_cat_des)
            || ','
            || escape_string (v_row.intm_ri)
            || ','
            || escape_string (v_row.voucher_chk_no_exp)
            || ','
            || escape_string (TO_CHAR (v_row.expenses_paid,
                                       'fm999,999,999,990.00'
                                      )
                             );

         FOR i IN 20 .. v_col_cnt
         LOOP
            v_str_var := NULL;
            v_num_var := NULL;
            v_date_var := NULL;

            IF (v_desc_tab (i).col_type = 1)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, i, v_str_var);
               v_col_val := v_col_val || ',' || escape_string (v_str_var);
            ELSIF (v_desc_tab (i).col_type = 2)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, i, v_num_var);
               v_col_val :=
                     v_col_val
                  || ','
                  || escape_string (TO_CHAR (v_num_var,
                                             'fm999,999,999,990.00')
                                   );
            ELSIF (v_desc_tab (i).col_type = 12)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, i, v_date_var);
               v_col_val :=
                      v_col_val || ',' || TO_CHAR (v_date_var, 'mm-dd-yyyy');
            END IF;
         END LOOP;

         v.rec := v_col_val;
         PIPE ROW (v);
      END LOOP;

      DBMS_SQL.close_cursor (v_cur_id);
      RETURN;
   END csv_giclr221e;

   FUNCTION csv_giclr222le (
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_paid_date    NUMBER,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2
   )
      RETURN str_csv_rec_tab PIPELINED
   IS
      v                  str_csv_rec_type;
      v_row              brdrx_rec_type;
      v_shr_query        VARCHAR2 (32000);
      v_query            VARCHAR2 (32767);
      v_col_hrd          VARCHAR2 (32767);
      v_col_val          VARCHAR2 (32767);
      v_cur_id           NUMBER;
      v_str_var          VARCHAR2 (4000);
      v_num_var          NUMBER;
      v_date_var         DATE;
      v_desc_tab         DBMS_SQL.desc_tab;
      v_col_cnt          NUMBER;
      v_cnt_loss_shr     NUMBER            := 0;
      v_cnt_exp_shr      NUMBER            := 0;
      v_loss_main_cols   NUMBER;
      v_nxt_col          NUMBER;
   BEGIN
      v_col_hrd :=
            'POLICY,ASSURED,TERM,CLAIM NO,LOSS DATE,ITEM,TOTAL SUM INSURED,'
         || 'LOSS CATEGORY,INTERMEDIARY,VOUCHER NUMBER - LOSS,LOSSES PAID';

      FOR a IN (SELECT DISTINCT a.share_cd, a.trty_name
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND b.claim_id = NVL (p_claim_id, b.claim_id)
                            AND a.share_cd IN (1, 999)
                            AND NVL (b.losses_paid, 0) <> 0
                       ORDER BY a.share_cd)
      LOOP
         v_cnt_loss_shr := v_cnt_loss_shr + 1;
         v_col_hrd := v_col_hrd || ',"' || a.trty_name || ' - LOSS"';
         v_shr_query :=
               v_shr_query
            || ', SUM (DECODE (c.grp_seq_no, '
            || a.share_cd
            || ', NVL (c.losses_paid, 0), 0)) "'
            || a.share_cd
            || '-LOSS'
            || '"';
      END LOOP;

      FOR b IN (SELECT DISTINCT a.share_cd,
                                NVL (a.trty_name, '        ') trty_name,
                                a.line_cd
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND b.claim_id = NVL (p_claim_id, b.claim_id)
                            AND a.share_cd NOT IN (1, 999)
                            AND NVL (b.losses_paid, 0) <> 0
                       ORDER BY a.line_cd, a.share_cd)
      LOOP
         v_cnt_loss_shr := v_cnt_loss_shr + 1;
         v_col_hrd :=
            v_col_hrd || ',"' || b.line_cd || ' - ' || b.trty_name
            || ' - LOSS"';
         v_shr_query :=
               v_shr_query
            || ', SUM (DECODE (c.grp_seq_no||''-''||a.line_cd, '''
            || b.share_cd
            || '-'
            || b.line_cd
            || ''', NVL (c.losses_paid, 0), 0)) "'
            || b.share_cd
            || '-'
            || b.line_cd
            || '-LOSS'
            || '"';
      END LOOP;

      v_col_hrd := v_col_hrd || ',' || 'EXPENSES PAID';

      FOR c IN (SELECT DISTINCT a.share_cd, a.trty_name
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND b.claim_id = NVL (p_claim_id, b.claim_id)
                            AND a.share_cd IN (1, 999)
                            AND NVL (b.expenses_paid, 0) <> 0
                       ORDER BY a.share_cd)
      LOOP
         v_cnt_exp_shr := v_cnt_exp_shr + 1;
         v_col_hrd := v_col_hrd || ',"' || c.trty_name || ' - EXPENSE"';
         v_shr_query :=
               v_shr_query
            || ', SUM (DECODE (c.grp_seq_no, '
            || c.share_cd
            || ', NVL (c.expenses_paid, 0), 0)) "'
            || c.share_cd
            || '-EXP'
            || '"';
      END LOOP;

      FOR d IN (SELECT DISTINCT a.share_cd,
                                NVL (a.trty_name, '        ') trty_name,
                                a.line_cd
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND b.claim_id = NVL (p_claim_id, b.claim_id)
                            AND a.share_cd NOT IN (1, 999)
                            AND NVL (b.expenses_paid, 0) <> 0
                       ORDER BY a.line_cd, a.share_cd)
      LOOP
         v_cnt_exp_shr := v_cnt_exp_shr + 1;
         v_col_hrd :=
               v_col_hrd
            || ',"'
            || d.line_cd
            || ' - '
            || d.trty_name
            || ' - EXPENSE"';
         v_shr_query :=
               v_shr_query
            || ', SUM (DECODE (c.grp_seq_no||''-''||a.line_cd, '''
            || d.share_cd
            || '-'
            || d.line_cd
            || ''', NVL (c.expenses_paid, 0), 0)) "'
            || d.share_cd
            || '-'
            || d.line_cd
            || '-EXP'
            || '"';
      END LOOP;

      v.rec := v_col_hrd;
      PIPE ROW (v);
      v_loss_main_cols := v_cnt_loss_shr + 20;
      v_nxt_col := v_loss_main_cols + 1;
      v_query :=
            'SELECT DISTINCT a.iss_cd, a.line_cd, a.subline_cd,
                    a.claim_id, a.assd_no, a.claim_no, a.policy_no,
                    a.incept_date, a.expiry_date, a.loss_date, a.item_no,
                    a.grouped_item_no, a.peril_cd,
                    csv_brdrx.get_loss_category (a.line_cd, a.loss_cat_cd
                                                ) loss_cat_des, a.tsi_amt,
                    a.intm_no, SUM (NVL (c.losses_paid, 0)) losses_paid,
                    SUM (NVL (c.expenses_paid, 0)) expenses_paid,
                    csv_brdrx.get_voucher_check_no (a.claim_id, a.item_no,
                                            a.peril_cd, a.grouped_item_no,'''
         || p_from_date
         || ''','''
         || p_to_date
         || ''','
         || p_paid_date
         || ', a.clm_res_hist_id,''L'') voucher_chk_no_loss,
                    csv_brdrx.get_voucher_check_no (a.claim_id, a.item_no,
                                            a.peril_cd, a.grouped_item_no,'''
         || p_from_date
         || ''','''
         || p_to_date
         || ''','
         || p_paid_date
         || ', a.clm_res_hist_id,''E'') voucher_chk_no_exp'
         || v_shr_query
         || ' FROM gicl_res_brdrx_extr a,
                   giis_intermediary b,
                   gicl_res_brdrx_ds_extr c
             WHERE a.buss_source = b.intm_no(+)
               AND a.session_id = '
         || p_session_id
         || ' AND a.claim_id = '
         || NVL (p_claim_id, 'a.claim_id')
         || ' AND a.brdrx_record_id = c.brdrx_record_id
              AND a.session_id = c.session_id
          GROUP BY a.iss_cd, a.line_cd, a.subline_cd, a.claim_id, a.assd_no,
                   a.claim_no, a.policy_no, a.incept_date, a.expiry_date,
                   a.loss_date, a.item_no, a.grouped_item_no, a.peril_cd,
                   csv_brdrx.get_loss_category (a.line_cd, a.loss_cat_cd),
                   a.tsi_amt, a.intm_no,
                   csv_brdrx.get_voucher_check_no (a.claim_id, a.item_no,
                                            a.peril_cd, a.grouped_item_no,'''
         || p_from_date
         || ''','''
         || p_to_date
         || ''','
         || p_paid_date
         || ', a.clm_res_hist_id,''L''),
                   csv_brdrx.get_voucher_check_no (a.claim_id, a.item_no,
                                            a.peril_cd, a.grouped_item_no,'''
         || p_from_date
         || ''','''
         || p_to_date
         || ''','
         || p_paid_date
         || ', a.clm_res_hist_id,''E'')
            HAVING SUM (NVL (c.losses_paid, 0)) <> 0
                OR SUM (NVL (c.expenses_paid, 0)) <> 0
             ORDER BY a.policy_no';
      v_cur_id := DBMS_SQL.open_cursor;
      DBMS_SQL.parse (v_cur_id, v_query, DBMS_SQL.native);
      v_col_cnt := DBMS_SQL.EXECUTE (v_cur_id);
      DBMS_SQL.describe_columns (v_cur_id, v_col_cnt, v_desc_tab);

      FOR i IN 1 .. v_col_cnt
      LOOP
         IF v_desc_tab (i).col_type = 2
         THEN
            DBMS_SQL.define_column (v_cur_id, i, v_num_var);
         ELSIF v_desc_tab (i).col_type = 12
         THEN
            DBMS_SQL.define_column (v_cur_id, i, v_date_var);
         ELSE
            DBMS_SQL.define_column (v_cur_id, i, v_str_var, 4000);
         END IF;
      END LOOP;

      WHILE DBMS_SQL.fetch_rows (v_cur_id) > 0
      LOOP
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 1, v_row.iss_cd);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 2, v_row.line_cd);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 3, v_row.subline_cd);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 4, v_row.claim_id);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 5, v_row.assd_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 6, v_row.claim_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 7, v_row.policy_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 8, v_row.incept_date);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 9, v_row.expiry_date);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 10, v_row.loss_date);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 11, v_row.item_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 12, v_row.grouped_item_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 13, v_row.peril_cd);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 14, v_row.loss_cat_des);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 15, v_row.tsi_amt);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 16, v_row.intm_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 17, v_row.losses_paid);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 18, v_row.expenses_paid);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 19, v_row.voucher_chk_no_loss);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 20, v_row.voucher_chk_no_exp);
         v_row.pol_no_ref_no :=
                          get_pol_no_ref_no (v_row.claim_id, v_row.policy_no);
         v_row.assd_name := get_assd_name (v_row.assd_no);
         v_row.term :=
               TO_CHAR (v_row.incept_date, 'MM-DD-YYYY')
            || ' - '
            || TO_CHAR (v_row.expiry_date, 'MM-DD-YYYY');
         v_row.item_title :=
            get_gpa_item_title (v_row.claim_id,
                                v_row.line_cd,
                                v_row.item_no,
                                NVL (v_row.grouped_item_no, 0)
                               );
         v_row.intm_ri :=
            get_intm_ri (v_row.claim_id,
                         p_session_id,
                         0,
                         v_row.item_no,
                         v_row.peril_cd,
                         v_row.intm_no
                        );
         v_col_val :=
               escape_string (v_row.pol_no_ref_no)
            || ','
            || escape_string (v_row.assd_name)
            || ','
            || escape_string (v_row.term)
            || ','
            || escape_string (v_row.claim_no)
            || ','
            || TO_CHAR (v_row.loss_date, 'mm-dd-yyyy')
            || ','
            || escape_string (v_row.item_title)
            || ','
            || escape_string (TO_CHAR (v_row.tsi_amt, 'fm999,999,999,990.00'))
            || ','
            || escape_string (v_row.loss_cat_des)
            || ','
            || escape_string (v_row.intm_ri)
            || ','
            || escape_string (v_row.voucher_chk_no_loss)
            || ','
            || escape_string (TO_CHAR (v_row.losses_paid,
                                       'fm999,999,999,990.00'
                                      )
                             );

         FOR i IN 21 .. v_loss_main_cols
         LOOP
            v_str_var := NULL;
            v_num_var := NULL;
            v_date_var := NULL;

            IF (v_desc_tab (i).col_type = 1)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, i, v_str_var);
               v_col_val := v_col_val || ',' || escape_string (v_str_var);
            ELSIF (v_desc_tab (i).col_type = 2)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, i, v_num_var);
               v_col_val :=
                     v_col_val
                  || ','
                  || escape_string (TO_CHAR (v_num_var,
                                             'fm999,999,999,990.00')
                                   );
            ELSIF (v_desc_tab (i).col_type = 12)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, i, v_date_var);
               v_col_val :=
                      v_col_val || ',' || TO_CHAR (v_date_var, 'mm-dd-yyyy');
            END IF;
         END LOOP;

         v_col_val :=
               v_col_val
            || ','
            || escape_string (v_row.voucher_chk_no_exp)
            || ','
            || escape_string (TO_CHAR (v_row.expenses_paid,
                                       'fm999,999,999,990.00'
                                      )
                             );

         FOR j IN v_nxt_col .. v_col_cnt
         LOOP
            v_str_var := NULL;
            v_num_var := NULL;
            v_date_var := NULL;

            IF (v_desc_tab (j).col_type = 1)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, j, v_str_var);
               v_col_val := v_col_val || ',' || escape_string (v_str_var);
            ELSIF (v_desc_tab (j).col_type = 2)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, j, v_num_var);
               v_col_val :=
                     v_col_val
                  || ','
                  || escape_string (TO_CHAR (v_num_var,
                                             'fm999,999,999,990.00')
                                   );
            ELSIF (v_desc_tab (j).col_type = 12)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, j, v_date_var);
               v_col_val :=
                      v_col_val || ',' || TO_CHAR (v_date_var, 'mm-dd-yyyy');
            END IF;
         END LOOP;

         v.rec := v_col_val;
         PIPE ROW (v);
      END LOOP;

      DBMS_SQL.close_cursor (v_cur_id);
      RETURN;
   END csv_giclr222le;

   FUNCTION csv_giclr222l (
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_paid_date    NUMBER,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2
   )
      RETURN str_csv_rec_tab PIPELINED
   IS
      v             str_csv_rec_type;
      v_row         brdrx_rec_type;
      v_shr_query   VARCHAR2 (32000);
      v_query       VARCHAR2 (32767);
      v_col_hrd     VARCHAR2 (32767);
      v_col_val     VARCHAR2 (32767);
      v_cur_id      NUMBER;
      v_str_var     VARCHAR2 (4000);
      v_num_var     NUMBER;
      v_date_var    DATE;
      v_desc_tab    DBMS_SQL.desc_tab;
      v_col_cnt     NUMBER;
   BEGIN
      v_col_hrd :=
            'POLICY,ASSURED,TERM,CLAIM NO,LOSS DATE,ITEM,TOTAL SUM INSURED,'
         || 'LOSS CATEGORY,INTERMEDIARY / CEDANT,VOUCHER NO / CHECK NO,'
         || 'LOSSES PAID';

      FOR a IN (SELECT DISTINCT a.share_cd, a.trty_name
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND b.claim_id = NVL (p_claim_id, b.claim_id)
                            AND a.share_cd IN (1, 999)
                            AND NVL (b.losses_paid, 0) <> 0
                       ORDER BY a.share_cd)
      LOOP
         v_col_hrd := v_col_hrd || ',"' || a.trty_name || '"';
         v_shr_query :=
               v_shr_query
            || ', SUM (DECODE (c.grp_seq_no, '
            || a.share_cd
            || ', NVL (c.losses_paid, 0), 0)) "'
            || a.share_cd
            || '"';
      END LOOP;

      FOR b IN (SELECT DISTINCT a.share_cd,
                                NVL (a.trty_name, '        ') trty_name,
                                a.line_cd
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND b.claim_id = NVL (p_claim_id, b.claim_id)
                            AND a.share_cd NOT IN (1, 999)
                            AND NVL (b.losses_paid, 0) <> 0
                       ORDER BY a.line_cd, a.share_cd)
      LOOP
         v_col_hrd :=
                v_col_hrd || ',"' || b.line_cd || ' - ' || b.trty_name || '"';
         v_shr_query :=
               v_shr_query
            || ', SUM (DECODE (c.grp_seq_no||''-''||a.line_cd, '''
            || b.share_cd
            || '-'
            || b.line_cd
            || ''', NVL (c.losses_paid, 0), 0)) "'
            || b.share_cd
            || '-'
            || b.line_cd
            || '"';
      END LOOP;

      v.rec := v_col_hrd;
      PIPE ROW (v);
      v_query :=
            'SELECT DISTINCT a.iss_cd, a.line_cd, a.subline_cd,
                    a.claim_id, a.assd_no, a.claim_no, a.policy_no,
                    a.incept_date, a.expiry_date, a.loss_date, a.item_no,
                    a.grouped_item_no, a.peril_cd,
                    csv_brdrx.get_loss_category (a.line_cd, a.loss_cat_cd
                                                ) loss_cat_des,
                    a.tsi_amt, a.intm_no, SUM (NVL (c.losses_paid, 0)) losses_paid,
                    csv_brdrx.get_voucher_check_no (a.claim_id, a.item_no,
                                            a.peril_cd, a.grouped_item_no,'''
         || p_from_date
         || ''','''
         || p_to_date
         || ''','
         || p_paid_date
         || ', a.clm_res_hist_id,''L'') voucher_chk_no_loss'
         || v_shr_query
         || ' FROM gicl_res_brdrx_extr a,
                   giis_intermediary b,
                   gicl_res_brdrx_ds_extr c
             WHERE a.buss_source = b.intm_no(+)
               AND a.session_id = '
         || p_session_id
         || ' AND a.claim_id = '
         || NVL (p_claim_id, 'a.claim_id')
         || ' AND a.brdrx_record_id = c.brdrx_record_id
              AND a.session_id = c.session_id
          GROUP BY a.iss_cd, a.line_cd, a.subline_cd, a.claim_id, a.assd_no,
                   a.claim_no, a.policy_no, a.incept_date, a.expiry_date,
                   a.loss_date, a.item_no, a.grouped_item_no,
                   a.peril_cd, csv_brdrx.get_loss_category (a.line_cd,
                                                            a.loss_cat_cd
                                                           ),
                   a.tsi_amt, a.intm_no,
                   csv_brdrx.get_voucher_check_no (a.claim_id, a.item_no,
                                            a.peril_cd, a.grouped_item_no,'''
         || p_from_date
         || ''','''
         || p_to_date
         || ''','
         || p_paid_date
         || ', a.clm_res_hist_id,''L'')
            HAVING SUM (NVL (c.losses_paid, 0)) <> 0
             ORDER BY a.policy_no, a.claim_no, a.item_no';
      v_cur_id := DBMS_SQL.open_cursor;
      DBMS_SQL.parse (v_cur_id, v_query, DBMS_SQL.native);
      v_col_cnt := DBMS_SQL.EXECUTE (v_cur_id);
      DBMS_SQL.describe_columns (v_cur_id, v_col_cnt, v_desc_tab);

      FOR i IN 1 .. v_col_cnt
      LOOP
         IF v_desc_tab (i).col_type = 2
         THEN
            DBMS_SQL.define_column (v_cur_id, i, v_num_var);
         ELSIF v_desc_tab (i).col_type = 12
         THEN
            DBMS_SQL.define_column (v_cur_id, i, v_date_var);
         ELSE
            DBMS_SQL.define_column (v_cur_id, i, v_str_var, 4000);
         END IF;
      END LOOP;

      WHILE DBMS_SQL.fetch_rows (v_cur_id) > 0
      LOOP
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 1, v_row.iss_cd);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 2, v_row.line_cd);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 3, v_row.subline_cd);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 4, v_row.claim_id);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 5, v_row.assd_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 6, v_row.claim_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 7, v_row.policy_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 8, v_row.incept_date);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 9, v_row.expiry_date);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 10, v_row.loss_date);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 11, v_row.item_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 12, v_row.grouped_item_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 13, v_row.peril_cd);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 14, v_row.loss_cat_des);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 15, v_row.tsi_amt);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 16, v_row.intm_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 17, v_row.losses_paid);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 18, v_row.voucher_chk_no_loss);
         v_row.pol_no_ref_no :=
                          get_pol_no_ref_no (v_row.claim_id, v_row.policy_no);
         v_row.assd_name := get_assd_name (v_row.assd_no);
         v_row.term :=
               TO_CHAR (v_row.incept_date, 'MM-DD-YYYY')
            || ' - '
            || TO_CHAR (v_row.expiry_date, 'MM-DD-YYYY');
         v_row.item_title :=
            get_gpa_item_title (v_row.claim_id,
                                v_row.line_cd,
                                v_row.item_no,
                                NVL (v_row.grouped_item_no, 0)
                               );
         v_row.intm_ri :=
            get_intm_ri (v_row.claim_id,
                         p_session_id,
                         0,
                         v_row.item_no,
                         v_row.peril_cd,
                         v_row.intm_no
                        );
         v_col_val :=
               escape_string (v_row.pol_no_ref_no)
            || ','
            || escape_string (v_row.assd_name)
            || ','
            || escape_string (v_row.term)
            || ','
            || escape_string (v_row.claim_no)
            || ','
            || TO_CHAR (v_row.loss_date, 'mm-dd-yyyy')
            || ','
            || escape_string (v_row.item_title)
            || ','
            || escape_string (TO_CHAR (v_row.tsi_amt, 'fm999,999,999,990.00'))
            || ','
            || escape_string (v_row.loss_cat_des)
            || ','
            || escape_string (v_row.intm_ri)
            || ','
            || escape_string (v_row.voucher_chk_no_loss)
            || ','
            || escape_string (TO_CHAR (v_row.losses_paid,
                                       'fm999,999,999,990.00'
                                      )
                             );

         FOR i IN 19 .. v_col_cnt
         LOOP
            v_str_var := NULL;
            v_num_var := NULL;
            v_date_var := NULL;

            IF (v_desc_tab (i).col_type = 1)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, i, v_str_var);
               v_col_val := v_col_val || ',' || escape_string (v_str_var);
            ELSIF (v_desc_tab (i).col_type = 2)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, i, v_num_var);
               v_col_val :=
                     v_col_val
                  || ','
                  || escape_string (TO_CHAR (v_num_var,
                                             'fm999,999,999,990.00')
                                   );
            ELSIF (v_desc_tab (i).col_type = 12)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, i, v_date_var);
               v_col_val :=
                      v_col_val || ',' || TO_CHAR (v_date_var, 'mm-dd-yyyy');
            END IF;
         END LOOP;

         v.rec := v_col_val;
         PIPE ROW (v);
      END LOOP;

      DBMS_SQL.close_cursor (v_cur_id);
      RETURN;
   END csv_giclr222l;

   FUNCTION csv_giclr222e (
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_paid_date    NUMBER,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2
   )
      RETURN str_csv_rec_tab PIPELINED
   IS
      v             str_csv_rec_type;
      v_row         brdrx_rec_type;
      v_shr_query   VARCHAR2 (32000);
      v_query       VARCHAR2 (32767);
      v_col_hrd     VARCHAR2 (32767);
      v_col_val     VARCHAR2 (32767);
      v_cur_id      NUMBER;
      v_str_var     VARCHAR2 (4000);
      v_num_var     NUMBER;
      v_date_var    DATE;
      v_desc_tab    DBMS_SQL.desc_tab;
      v_col_cnt     NUMBER;
   BEGIN
      v_col_hrd :=
            'POLICY,ASSURED,TERM,CLAIM NO,LOSS DATE,ITEM,TOTAL SUM INSURED,'
         || 'LOSS CATEGORY,INTERMEDIARY,VOUCHER NUMBER,EXPENSES PAID';

      FOR c IN (SELECT DISTINCT a.share_cd, a.trty_name
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND b.claim_id = NVL (p_claim_id, b.claim_id)
                            AND a.share_cd IN (1, 999)
                            AND NVL (b.expenses_paid, 0) <> 0
                       ORDER BY a.share_cd)
      LOOP
         v_col_hrd := v_col_hrd || ',"' || c.trty_name || '"';
         v_shr_query :=
               v_shr_query
            || ', SUM (DECODE (c.grp_seq_no, '
            || c.share_cd
            || ', NVL (c.expenses_paid, 0), 0)) "'
            || c.share_cd
            || '"';
      END LOOP;

      FOR d IN (SELECT DISTINCT a.share_cd,
                                NVL (a.trty_name, '        ') trty_name,
                                a.line_cd
                           FROM giis_dist_share a, gicl_res_brdrx_ds_extr b
                          WHERE a.share_cd = b.grp_seq_no
                            AND a.line_cd = b.line_cd
                            AND b.session_id = p_session_id
                            AND b.claim_id = NVL (p_claim_id, b.claim_id)
                            AND a.share_cd NOT IN (1, 999)
                            AND NVL (b.expenses_paid, 0) <> 0
                       ORDER BY a.line_cd, a.share_cd)
      LOOP
         v_col_hrd :=
                v_col_hrd || ',"' || d.line_cd || ' - ' || d.trty_name || '"';
         v_shr_query :=
               v_shr_query
            || ', SUM (DECODE (c.grp_seq_no||''-''||a.line_cd, '''
            || d.share_cd
            || '-'
            || d.line_cd
            || ''', NVL (c.expenses_paid, 0), 0)) "'
            || d.share_cd
            || '-'
            || d.line_cd
            || '"';
      END LOOP;

      v.rec := v_col_hrd;
      PIPE ROW (v);
      v_query :=
            'SELECT DISTINCT a.iss_cd, a.line_cd, a.subline_cd,
                    a.claim_id, a.assd_no, a.claim_no, a.policy_no,
                    a.incept_date, a.expiry_date, a.loss_date, a.item_no,
                    a.grouped_item_no, a.peril_cd,
                    csv_brdrx.get_loss_category (a.line_cd, a.loss_cat_cd
                                                ) loss_cat_des, a.tsi_amt,
                    a.intm_no, SUM (NVL (c.expenses_paid, 0)) expenses_paid,
                    csv_brdrx.get_voucher_check_no (a.claim_id, a.item_no,
                                            a.peril_cd, a.grouped_item_no,'''
         || p_from_date
         || ''','''
         || p_to_date
         || ''','
         || p_paid_date
         || ', a.clm_res_hist_id,''E'') voucher_chk_no_exp'
         || v_shr_query
         || ' FROM gicl_res_brdrx_extr a,
                   giis_intermediary b,
                   gicl_res_brdrx_ds_extr c
             WHERE a.buss_source = b.intm_no(+)
               AND a.session_id = '
         || p_session_id
         || ' AND a.claim_id = '
         || NVL (p_claim_id, 'a.claim_id')
         || ' AND a.brdrx_record_id = c.brdrx_record_id
              AND a.session_id = c.session_id
          GROUP BY a.iss_cd, a.line_cd, a.subline_cd, a.claim_id, a.assd_no,
                   a.claim_no, a.policy_no, a.incept_date, a.expiry_date,
                   a.loss_date, a.item_no, a.grouped_item_no, a.peril_cd,
                   csv_brdrx.get_loss_category (a.line_cd, a.loss_cat_cd),
                   a.tsi_amt, a.intm_no,
                   csv_brdrx.get_voucher_check_no (a.claim_id, a.item_no,
                                            a.peril_cd, a.grouped_item_no,'''
         || p_from_date
         || ''','''
         || p_to_date
         || ''','
         || p_paid_date
         || ', a.clm_res_hist_id,''E'')
            HAVING SUM (NVL (c.expenses_paid, 0)) <> 0
             ORDER BY a.policy_no';
      v_cur_id := DBMS_SQL.open_cursor;
      DBMS_SQL.parse (v_cur_id, v_query, DBMS_SQL.native);
      v_col_cnt := DBMS_SQL.EXECUTE (v_cur_id);
      DBMS_SQL.describe_columns (v_cur_id, v_col_cnt, v_desc_tab);

      FOR i IN 1 .. v_col_cnt
      LOOP
         IF v_desc_tab (i).col_type = 2
         THEN
            DBMS_SQL.define_column (v_cur_id, i, v_num_var);
         ELSIF v_desc_tab (i).col_type = 12
         THEN
            DBMS_SQL.define_column (v_cur_id, i, v_date_var);
         ELSE
            DBMS_SQL.define_column (v_cur_id, i, v_str_var, 4000);
         END IF;
      END LOOP;

      WHILE DBMS_SQL.fetch_rows (v_cur_id) > 0
      LOOP
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 1, v_row.iss_cd);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 2, v_row.line_cd);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 3, v_row.subline_cd);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 4, v_row.claim_id);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 5, v_row.assd_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 6, v_row.claim_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 7, v_row.policy_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 8, v_row.incept_date);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 9, v_row.expiry_date);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 10, v_row.loss_date);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 11, v_row.item_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 12, v_row.grouped_item_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 13, v_row.peril_cd);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 14, v_row.loss_cat_des);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 15, v_row.tsi_amt);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 16, v_row.intm_no);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 17, v_row.expenses_paid);
         DBMS_SQL.COLUMN_VALUE (v_cur_id, 18, v_row.voucher_chk_no_exp);
         v_row.pol_no_ref_no :=
                          get_pol_no_ref_no (v_row.claim_id, v_row.policy_no);
         v_row.assd_name := get_assd_name (v_row.assd_no);
         v_row.term :=
               TO_CHAR (v_row.incept_date, 'MM-DD-YYYY')
            || ' - '
            || TO_CHAR (v_row.expiry_date, 'MM-DD-YYYY');
         v_row.item_title :=
            get_gpa_item_title (v_row.claim_id,
                                v_row.line_cd,
                                v_row.item_no,
                                NVL (v_row.grouped_item_no, 0)
                               );
         v_row.intm_ri :=
            get_intm_ri (v_row.claim_id,
                         p_session_id,
                         0,
                         v_row.item_no,
                         v_row.peril_cd,
                         v_row.intm_no
                        );
         v_col_val :=
               escape_string (v_row.pol_no_ref_no)
            || ','
            || escape_string (v_row.assd_name)
            || ','
            || escape_string (v_row.term)
            || ','
            || escape_string (v_row.claim_no)
            || ','
            || TO_CHAR (v_row.loss_date, 'mm-dd-yyyy')
            || ','
            || escape_string (v_row.item_title)
            || ','
            || escape_string (TO_CHAR (v_row.tsi_amt, 'fm999,999,999,990.00'))
            || ','
            || escape_string (v_row.loss_cat_des)
            || ','
            || escape_string (v_row.intm_ri)
            || ','
            || escape_string (v_row.voucher_chk_no_exp)
            || ','
            || escape_string (TO_CHAR (v_row.expenses_paid,
                                       'fm999,999,999,990.00'
                                      )
                             );

         FOR i IN 19 .. v_col_cnt
         LOOP
            v_str_var := NULL;
            v_num_var := NULL;
            v_date_var := NULL;

            IF (v_desc_tab (i).col_type = 1)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, i, v_str_var);
               v_col_val := v_col_val || ',' || escape_string (v_str_var);
            ELSIF (v_desc_tab (i).col_type = 2)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, i, v_num_var);
               v_col_val :=
                     v_col_val
                  || ','
                  || escape_string (TO_CHAR (v_num_var,
                                             'fm999,999,999,990.00')
                                   );
            ELSIF (v_desc_tab (i).col_type = 12)
            THEN
               DBMS_SQL.COLUMN_VALUE (v_cur_id, i, v_date_var);
               v_col_val :=
                      v_col_val || ',' || TO_CHAR (v_date_var, 'mm-dd-yyyy');
            END IF;
         END LOOP;

         v.rec := v_col_val;
         PIPE ROW (v);
      END LOOP;

      DBMS_SQL.close_cursor (v_cur_id);
      RETURN;
   END csv_giclr222e;
END;
/