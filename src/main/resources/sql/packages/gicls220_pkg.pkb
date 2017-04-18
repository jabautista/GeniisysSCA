CREATE OR REPLACE PACKAGE BODY CPI.gicls220_pkg
AS
   FUNCTION get_gicls220_line_lov (
      p_module_id   VARCHAR2,
      p_branch_cd   giac_branches.branch_cd%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN line_lov_tab PIPELINED
   IS
      v_rec   line_lov_type;
   BEGIN
      FOR i IN (SELECT   line_cd, line_name
                    FROM giis_line
                   WHERE check_user_per_iss_cd2 (line_cd,
                                                 p_branch_cd,
                                                 p_module_id,
                                                 p_user_id
                                                ) = 1
                ORDER BY line_cd, line_name)
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.line_name := i.line_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_gicls220_subline_lov (p_line_cd giis_line.line_cd%TYPE)
      RETURN subline_lov_tab PIPELINED
   IS
      v_rec   subline_lov_type;
   BEGIN
      FOR i IN (SELECT   subline_cd, subline_name
                    FROM giis_subline
                   WHERE line_cd = NVL (p_line_cd, line_cd)
                ORDER BY subline_cd)
      LOOP
         v_rec.subline_cd := i.subline_cd;
         v_rec.subline_name := i.subline_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_gicls220_branch_lov (
      p_module_id   VARCHAR2,
      p_line_cd     giis_line.line_cd%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN branch_lov_tab PIPELINED
   IS
      v_rec   branch_lov_type;
   BEGIN
      FOR i IN (SELECT   iss_cd, iss_name
                    FROM giis_issource
                   WHERE check_user_per_iss_cd2 (p_line_cd,
                                                 iss_cd,
                                                 p_module_id,
                                                 p_user_id
                                                ) = 1
                ORDER BY iss_cd, iss_name)
      LOOP
         v_rec.iss_cd := i.iss_cd;
         v_rec.iss_name := i.iss_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_gicls220_intm_lov
      RETURN intm_lov_tab PIPELINED
   IS
      v_rec   intm_lov_type;
   BEGIN
      FOR i IN (SELECT   intm_no, intm_name
                    FROM giis_intermediary
                ORDER BY intm_no)
      LOOP
         v_rec.intm_no := i.intm_no;
         v_rec.intm_name := i.intm_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_gicls220_assd_lov
      RETURN assd_lov_tab PIPELINED
   IS
      v_rec   assd_lov_type;
   BEGIN
      FOR i IN (SELECT   assd_no, assd_name
                    FROM giis_assured
                ORDER BY assd_no)
      LOOP
         v_rec.assd_no := i.assd_no;
         v_rec.assd_name := i.assd_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION when_new_form_gicls220
      RETURN when_new_form_gicls220_tab PIPELINED
   IS
      v_rec   when_new_form_gicls220_type;
   BEGIN
      BEGIN
         SELECT DISTINCT param_value_v
                    INTO v_rec.ri_iss_cd
                    FROM giac_parameters
                   WHERE param_name = 'RI_ISS_CD';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_rec.ri_iss_cd := 'XX';
      END;

      PIPE ROW (v_rec);
   END;

   PROCEDURE extract_gicls220 (
      p_user_id           IN       giis_users.user_id%TYPE,
      p_exists            OUT      NUMBER,
      p_intm_no           IN       giis_intermediary.intm_no%TYPE,
      p_claim_amt_o       IN       VARCHAR2,
      p_claim_amt_r       IN       VARCHAR2,
      p_claim_amt_s       IN       VARCHAR2,
      p_loss_expense      IN       VARCHAR2,
      p_line_cd           IN       giis_line.line_cd%TYPE,
      p_subline_cd        IN       giis_subline.subline_cd%TYPE,
      p_branch_cd         IN       giac_branches.branch_cd%TYPE,
      p_branch_param      IN       VARCHAR2,
      p_ri_iss_cd         IN       VARCHAR2,
      p_assd_cedant_no    IN       VARCHAR2,
      p_claim_status_op   IN       VARCHAR2,
      p_claim_status_cl   IN       VARCHAR2,
      p_claim_status_cc   IN       VARCHAR2,
      p_claim_status_de   IN       VARCHAR2,
      p_claim_status_wd   IN       VARCHAR2,
      p_claim_date        IN       VARCHAR2,
      p_as_of_date        IN       DATE,
      p_from_date         IN       DATE,
      p_to_date           IN       DATE,
      p_extract_type      IN       VARCHAR2,
      p_biggest_claims    IN       NUMBER,
      p_loss_amt          IN       gicl_clm_summary.loss_amt%TYPE,
      p_session_id        OUT      NUMBER
   )
   IS
      v_session_id    NUMBER;
      v_column        VARCHAR2 (2000);
      v_col_ins       VARCHAR2 (2000);
      v_col_frm       VARCHAR2 (1000);
      v_grp_out       VARCHAR2 (1000);
      v_where         VARCHAR2 (2000);
      v_table         VARCHAR2 (10000);
      v_chk           VARCHAR2 (1)     := 'N';
      v_select_intm   VARCHAR2 (1000);
      v_table_intm    VARCHAR2 (1000);
      v_where_intm    VARCHAR2 (1000);
      v_insert_intm   VARCHAR2 (1000);
      v_stmt          VARCHAR2 (10000);
      v_table_tmp     VARCHAR2 (1000);
      v_where_tmp     VARCHAR2 (1000);
   BEGIN
      FOR rec IN (SELECT clm_summary_session_id_s.NEXTVAL val
                    FROM DUAL)
      LOOP
         v_session_id := rec.val;
         p_session_id := rec.val;
         EXIT;
      END LOOP;

      get_dynamic (v_column,
                   v_col_ins,
                   v_col_frm,
                   v_grp_out,
                   p_intm_no,
                   p_claim_amt_o,
                   p_claim_amt_r,
                   p_claim_amt_s,
                   p_loss_expense
                  );
      get_dynamic_where (v_where,
                         v_col_ins,
                         p_line_cd,
                         p_subline_cd,
                         p_branch_cd,
                         p_branch_param,
                         p_ri_iss_cd,
                         p_assd_cedant_no
                        );

      IF p_claim_amt_o = 'Y'
      THEN
         v_where := v_where || ' 1=1';
      ELSE
         get_dynamic_clm_stat (v_where,
                               p_claim_status_op,
                               p_claim_status_cl,
                               p_claim_status_cc,
                               p_claim_status_de,
                               p_claim_status_wd
                              );
      END IF;

      get_dynamic_table (v_where,
                         v_table,
                         v_chk,
                         p_claim_date,
                         p_as_of_date,
                         p_from_date,
                         p_to_date,
                         p_claim_amt_o,
                         p_claim_amt_r,
                         p_claim_amt_s,
                         p_loss_expense
                        );

      IF p_intm_no IS NOT NULL
      THEN
         v_select_intm := ', x.intm_no, shr_intm_pct';
         v_table_intm := ', gicl_intm_itmperil x';
         v_where_intm :=
            ' AND a.claim_id = x.claim_id' || ' AND x.intm_no = '
            || p_intm_no;
         v_insert_intm := '.intm_no';

         IF v_chk = 'O'
         THEN
            v_where_intm :=
                  v_where_intm
               || ' AND d.item_no = x.item_no'
               || ' AND d.peril_cd = x.peril_cd';
         ELSIF v_chk = 'B'
         THEN
            v_where_intm :=
                  v_where_intm
               || ' AND c.item_no = x.item_no'
               || ' AND c.peril_cd = x.peril_cd';
         ELSE
            v_where_intm :=
                  v_where_intm
               || ' AND b.item_no = x.item_no'
               || ' AND b.peril_cd = x.peril_cd';
         END IF;
      ELSE
         v_insert_intm := NULL;
      END IF;

      IF v_chk = 'O'
      THEN
         IF p_extract_type = 'N'
         THEN
            v_stmt :=
                  'SELECT claim_id, amt'
               || v_col_frm
               || ' FROM (SELECT '
               || v_column
               || ', a.claim_id'
               || v_select_intm
               || ' FROM '
               || v_table
               || ', gicl_claims c, gicl_clm_res_hist d'
               || v_table_intm
               || ' WHERE a.claim_id = b.claim_id (+)'
               || ' AND a.claim_id = d.claim_id'
               || ' AND a.claim_id = e.claim_id'
               || ' AND a.claim_id = f.claim_id (+)'
               || ' AND d.clm_res_hist_id = e.clm_res_hist_id '
               || ' AND check_user_per_iss_cd2(c.line_cd, c.iss_cd, ''GICLS220'', '''
               || p_user_id
               || ''') = 1'
               || ' AND '
               || v_where
               || ' AND a.claim_id = c.claim_id'
               || v_where_intm
               || ' AND d.clm_res_hist_id = (SELECT MAX(clm_res_hist_id)'
               || ' FROM gicl_clm_res_hist z'
               || ' WHERE z.claim_id = d.claim_id'
               || ' AND z.item_no = d.item_no'
               || ' AND z.peril_cd = d.peril_cd'
               || ' AND TO_DATE(NVL(Z.BOOKING_MONTH,TO_CHAR(c.CLM_FILE_DATE,''FMMONTH''))'
               || '||'' 01, '''
               || '||TO_CHAR(NVL(Z.BOOKING_YEAR,TO_CHAR(c.CLM_FILE_DATE,''RRRR''))),''FMMONTH DD, RRRR'')'
               || ' <= '''
               || p_as_of_date
               || ''''
               || ' AND tran_id IS NULL)'
               || ' AND (TRUNC(c.close_date) > '''
               || p_as_of_date
               || ''' OR c.close_date IS NULL)'
               || ' GROUP BY a.claim_id'
               || v_grp_out
               || v_select_intm
               || ' ORDER BY amt DESC NULLS LAST)'
               || ' WHERE rownum <= '
               || p_biggest_claims;
         ELSIF p_extract_type = 'L'
         THEN
            v_stmt :=
                  'SELECT claim_id, amt'
               || v_col_frm
               || ' FROM (SELECT '
               || v_column
               || ', a.claim_id'
               || v_select_intm
               || ' FROM '
               || v_table
               || ', gicl_claims c, gicl_clm_res_hist d'
               || v_table_intm
               || ' WHERE a.claim_id = b.claim_id (+)'
               || ' AND a.claim_id = d.claim_id'
               || ' AND a.claim_id = e.claim_id'
               || ' AND a.claim_id = f.claim_id (+)'
               || ' AND d.clm_res_hist_id = e.clm_res_hist_id '
               || ' AND check_user_per_iss_cd2(c.line_cd, c.iss_cd, ''GICLS220'', '''
               || p_user_id
               || ''') = 1'
               || ' AND '
               || v_where
               || ' AND a.claim_id = c.claim_id'
               || v_where_intm
               || ' AND d.clm_res_hist_id = (SELECT MAX(clm_res_hist_id)'
               || ' FROM gicl_clm_res_hist z'
               || ' WHERE z.claim_id = d.claim_id'
               || ' AND z.item_no = d.item_no'
               || ' AND z.peril_cd = d.peril_cd'
               || ' AND TO_DATE(NVL(Z.BOOKING_MONTH,TO_CHAR(c.CLM_FILE_DATE,''FMMONTH''))'
               || '||'' 01, '''
               || '||TO_CHAR(NVL(Z.BOOKING_YEAR,TO_CHAR(c.CLM_FILE_DATE,''RRRR''))),''FMMONTH DD, RRRR'')'
               || ' <= '''
               || p_as_of_date
               || ''''
               || ' AND tran_id IS NULL)'
               || ' AND (TRUNC(c.close_date) > '''
               || p_as_of_date
               || ''' OR c.close_date IS NULL)'
               || ' GROUP BY a.claim_id'
               || v_grp_out
               || v_select_intm
               || ' ORDER BY amt DESC NULLS LAST)'
               || ' WHERE  amt >= '
               || p_loss_amt;
         END IF;
      ELSIF v_chk = 'B'
      THEN
         IF p_extract_type = 'N'
         THEN
            v_stmt :=
                  'SELECT claim_id, amt'
               || v_col_frm
               || ' FROM (SELECT '
               || v_column
               || ', a.claim_id'
               || v_select_intm
               || ' FROM '
               || v_table
               || ', gicl_clm_res_hist c, gicl_claims d'
               || v_table_intm
               || ' WHERE a.claim_id = b.claim_id'
               || ' AND a.claim_id = e.claim_id'
               || ' AND a.claim_id = f.claim_id'
               || ' AND a.claim_id = d.claim_id'
               || ' AND check_user_per_iss_cd2(d.line_cd, d.iss_cd, ''GICLS220'', '''
               || p_user_id
               || ''') = 1'
               || ' AND '
               || v_where
               || ' AND a.claim_id = c.claim_id'
               || v_where_intm
               || ' GROUP BY a.claim_id,  b.loss_reserve,  
                                     a.losses_paid,
                                     b.expense_reserve, 
                                     a.expenses_paid,
                                     loss_reserve1,
                                     losses_paid1,
                                     loss_reserve2,
                                     losses_paid2,
                                     loss_reserve3,
                                     losses_paid3,
                                     loss_reserve4,
                                     losses_paid4,
                                     expense_reserve1,
                                     expenses_paid1,
                                     expense_reserve2,
                                     expenses_paid2,
                                     expense_reserve3,
                                     expenses_paid3,
                                     expense_reserve4,
                                     expenses_paid4'
               || v_select_intm
               || ' ORDER BY amt DESC NULLS LAST)'
               || ' WHERE rownum <= '
               || p_biggest_claims;
         ELSIF p_extract_type = 'L'
         THEN
            v_stmt :=
                  'SELECT claim_id, amt'
               || v_col_frm
               || ' FROM (SELECT '
               || v_column
               || ', a.claim_id'
               || v_select_intm
               || ' FROM '
               || v_table
               || ', gicl_clm_res_hist c, gicl_claims d'
               || v_table_intm
               || ' WHERE a.claim_id = b.claim_id'
               || ' AND a.claim_id = e.claim_id'
               || ' AND a.claim_id = f.claim_id'
               || ' AND a.claim_id = d.claim_id'
               || ' AND check_user_per_iss_cd2(d.line_cd, d.iss_cd, ''GICLS220'', '''
               || p_user_id
               || ''') = 1'
               || ' AND '
               || v_where
               || ' AND a.claim_id = c.claim_id'
               || v_where_intm
               || ' GROUP BY a.claim_id'
               || v_select_intm
               || ' ORDER BY amt DESC NULLS LAST)'
               || ' WHERE amt >= '
               || p_loss_amt;
         END IF;
      ELSE
         IF p_extract_type = 'N'
         THEN
            v_stmt :=
                  'SELECT claim_id, amt'
               || v_col_frm
               || ' FROM (SELECT '
               || v_column
               || ', a.claim_id'
               || v_select_intm
               || ' FROM '
               || v_table
               || v_table_intm
               || ' WHERE a.claim_id = b.claim_id'
               || v_where_intm
               || ' AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, ''GICLS220'', '''
               || p_user_id
               || ''') = 1'
               || ' AND '
               || v_where
               || ' GROUP BY a.claim_id'
               || v_select_intm
               || ' ORDER BY amt DESC NULLS LAST)'
               || ' WHERE rownum <= '
               || p_biggest_claims;
         ELSIF p_extract_type = 'L'
         THEN
            v_stmt :=
                  'SELECT claim_id, amt'
               || v_col_frm
               || ' FROM (SELECT '
               || v_column
               || ', a.claim_id'
               || v_select_intm
               || ' FROM '
               || v_table
               || v_table_intm
               || ' WHERE a.claim_id = b.claim_id'
               || v_where_intm
               || ' AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, ''GICLS220'', '''
               || p_user_id
               || ''') = 1'
               || ' AND '
               || v_where
               || ' GROUP BY a.claim_id'
               || v_select_intm
               || ' ORDER BY amt DESC NULLS LAST)'
               || ' WHERE amt >= '
               || p_loss_amt;
         END IF;
      END IF;

      IF p_claim_amt_o = 'Y'
      THEN
         v_table_tmp := 'd, gicl_item_peril c';
         v_where_tmp := ' AND a.claim_id = d.claim_id';

         IF v_insert_intm IS NOT NULL
         THEN
            v_insert_intm := 'd' || v_insert_intm;
         ELSE
            v_insert_intm := 'a.intm_no';
         END IF;
      ELSE
         v_table_tmp := 'c';
         v_where_tmp := '';

         IF v_insert_intm IS NOT NULL
         THEN
            v_insert_intm := 'c' || v_insert_intm;
         ELSE
            v_insert_intm := 'a.intm_no';
         END IF;
      END IF;

      v_stmt :=
            'INSERT INTO gicl_clm_summary (session_id, claim_id, line_cd, '
         || 'subline_cd, assd_no, intm_no, ri_cd, clm_stat_cd, '
         || 'user_id, extract_date, as_of_date, f_date, t_date, ploss_amt, pbiggest_claims,loss_date, clm_file_date, '
         || 'loss_amt, expense_amt, '
         || 'net_ret_loss, net_ret_exp, treaty_loss, treaty_exp, facul_loss, facul_exp, xol_loss, xol_exp, '
         || 'branch_cd, extract_type) '
         || ' SELECT DISTINCT '
         || v_session_id
         || ',a.claim_id, a.line_cd, '
         || 'a.subline_cd, a.assd_no, '
         || v_insert_intm
         || ', a.ri_cd, a.clm_stat_cd, '
         || ''''
         || UPPER (p_user_id)
         || ''', '''
         || SYSDATE
         || ''', '''
         || p_as_of_date
         || ''', '''
         || p_from_date
         || ''', '''
         || p_to_date
         || ''', '''
         || p_loss_amt
         || ''', '''
         || p_biggest_claims
         || ''', dsp_loss_date, clm_file_date,'
         || v_col_ins
         || ','''
         || p_extract_type
         || ''''
         || ' FROM gicl_claims a, gicl_clm_res_hist b, '
         || ' ('
         || v_stmt
         || ') '
         || v_table_tmp
         || ' WHERE a.claim_id = c.claim_id'
         || ' AND a.claim_id = b.claim_id'
         || v_where_tmp;

      EXECUTE IMMEDIATE (   'DELETE FROM gicl_clm_summary WHERE user_id = '''
                         || UPPER (p_user_id)
                         || ''''
                        );

      EXECUTE IMMEDIATE (v_stmt);

      FOR rec IN (SELECT COUNT (*) COUNT
                    FROM gicl_clm_summary
                   WHERE session_id = v_session_id AND user_id = p_user_id)
      LOOP
         p_exists := TO_CHAR (rec.COUNT);
      END LOOP;
   END;

   PROCEDURE get_dynamic (
      p_column         OUT      VARCHAR2,
      p_col_ins        OUT      VARCHAR2,
      p_col_frm        OUT      VARCHAR2,
      p_grp_out        OUT      VARCHAR2,
      p_intm_no        IN       giis_intermediary.intm_no%TYPE,
      p_claim_amt_o    IN       VARCHAR2,
      p_claim_amt_r    IN       VARCHAR2,
      p_claim_amt_s    IN       VARCHAR2,
      p_loss_expense   IN       VARCHAR2
   )
   IS
      v_column    VARCHAR2 (2000);
      v_col_ins   VARCHAR2 (2000);
      v_col_frm   VARCHAR2 (2000);
      v_col1      VARCHAR2 (1000);
      v_col2      VARCHAR2 (1000);
      v_col3      VARCHAR2 (1000);
      v_col4      VARCHAR2 (1000);
      v_grp_out   VARCHAR2 (1000);
      v_intm      VARCHAR2 (1000);
   BEGIN
      IF p_intm_no IS NOT NULL
      THEN
         v_intm := '*(shr_intm_pct/100)';
      END IF;

      v_col1 := 'SUM(NVL(expense_reserve,0)' || v_intm || ')';
      v_col2 := 'SUM(NVL(expenses_paid,0)' || v_intm || ')';
      v_col3 := 'SUM(NVL(loss_reserve,0)' || v_intm || ')';
      v_col4 := 'SUM(NVL(losses_paid,0)' || v_intm || ')';

      IF p_claim_amt_o = 'Y'
      THEN
         IF p_loss_expense = 'LE'
         THEN
            v_column :=
                  '(SUM(NVL(d.loss_reserve+d.expense_reserve,0))-NVL(b.losses_paid+b.expenses_paid,0)'
               || v_intm
               || ') amt, '
               || 'SUM(NVL(d.loss_reserve,0))    - NVL(b.losses_paid,0)'
               || v_intm
               || ' loss_amt, '
               || 'SUM(NVL(d.expense_reserve,0)) - NVL(b.expenses_paid,0)'
               || v_intm
               || ' exp_amt, '
               || 'SUM(NVL(e.loss_reserve1,0))   - NVL(f.losses_paid1,0)'
               || v_intm
               || ' loss_amt1, '
               || 'SUM(NVL(e.expense_reserve1,0))- NVL(f.expenses_paid1,0)'
               || v_intm
               || ' exp_amt1, '
               || 'SUM(NVL(e.loss_reserve2,0))   - NVL(f.losses_paid2,0)'
               || v_intm
               || ' loss_amt2, '
               || 'SUM(NVL(e.expense_reserve2,0))- NVL(f.expenses_paid2,0)'
               || v_intm
               || ' exp_amt2, '
               || 'SUM(NVL(e.loss_reserve3,0))   - NVL(f.losses_paid3,0)'
               || v_intm
               || ' loss_amt3, '
               || 'SUM(NVL(e.expense_reserve3,0))- NVL(f.expenses_paid3,0)'
               || v_intm
               || ' exp_amt3, '
               || 'SUM(NVL(e.loss_reserve4,0))   - NVL(f.losses_paid4,0)'
               || v_intm
               || ' loss_amt4, '
               || 'SUM(NVL(e.expense_reserve4,0))- NVL(f.expenses_paid4,0)'
               || v_intm
               || ' exp_amt4';
            v_col_ins :=
                  'loss_amt,  exp_amt, '
               || 'loss_amt1, exp_amt1,'
               || 'loss_amt2, exp_amt2,'
               || 'loss_amt3, exp_amt3,'
               || 'loss_amt4, exp_amt4';
            v_col_frm :=
                  ', loss_amt,  exp_amt, '
               || 'loss_amt1, exp_amt1,'
               || 'loss_amt2, exp_amt2,'
               || 'loss_amt3, exp_amt3,'
               || 'loss_amt4, exp_amt4';
            v_grp_out :=
                  ', b.losses_paid,  b.expenses_paid '
               || ', f.losses_paid1, f.expenses_paid1'
               || ', f.losses_paid2, f.expenses_paid2'
               || ', f.losses_paid3, f.expenses_paid3'
               || ', f.losses_paid4, f.expenses_paid4';
         ELSIF p_loss_expense = 'L'
         THEN
            v_column :=
                  '(SUM(NVL(d.loss_reserve,0))- NVL(b.losses_paid,0)'
               || v_intm
               || ') amt, '
               || '(SUM(NVL(e.loss_reserve1,0))- NVL(f.losses_paid1,0)'
               || v_intm
               || ') amt1, '
               || '(SUM(NVL(e.loss_reserve2,0))- NVL(f.losses_paid2,0)'
               || v_intm
               || ') amt2, '
               || '(SUM(NVL(e.loss_reserve3,0))- NVL(f.losses_paid3,0)'
               || v_intm
               || ') amt3, '
               || '(SUM(NVL(e.loss_reserve4,0))- NVL(f.losses_paid4,0)'
               || v_intm
               || ') amt4';
            v_col_ins :=
                   'amt, null, amt1, null, amt2, null, amt3, null, amt4, null';
            v_col_frm := ', amt1, amt2, amt3, amt4';
            v_grp_out :=
               ', b.losses_paid, f.losses_paid1, f.losses_paid2, f.losses_paid3, f.losses_paid4';
         ELSE
            v_column :=
                  '(SUM(NVL(d.expense_reserve,0))- NVL(b.expenses_paid,0)'
               || v_intm
               || ') amt, '
               || '(SUM(NVL(e.expense_reserve1,0))- NVL(f.expenses_paid1,0)'
               || v_intm
               || ') amt1, '
               || '(SUM(NVL(e.expense_reserve2,0))- NVL(f.expenses_paid2,0)'
               || v_intm
               || ') amt2, '
               || '(SUM(NVL(e.expense_reserve3,0))- NVL(f.expenses_paid3,0)'
               || v_intm
               || ') amt3, '
               || '(SUM(NVL(e.expense_reserve4,0))- NVL(f.expenses_paid4,0)'
               || v_intm
               || ') amt4';
            v_col_ins :=
                   'null, amt, null, amt1, null, amt2, null, amt3, null, amt4';
            v_col_frm := ', amt1, amt2, amt3, amt4';
            v_grp_out :=
               ', b.expenses_paid, f.expenses_paid1, f.expenses_paid2, f.expenses_paid3, f.expenses_paid4';
         END IF;
      ELSIF p_claim_amt_r = 'Y' AND p_claim_amt_s = 'Y'
      THEN
         IF p_loss_expense = 'LE'
         THEN
            v_column :=
                  '(DECODE(SIGN(SUM(NVL(b.expense_reserve,0)'
               || v_intm
               || ') - SUM(NVL(b.loss_reserve,0)'
               || v_intm
               || ')), -1,SUM(NVL(b.loss_reserve,0)'
               || v_intm
               || '), SUM(NVL(a.losses_paid,0)'
               || v_intm
               || ')) + '
               || 'DECODE(SIGN(SUM(NVL(a.expenses_paid,0)'
               || v_intm
               || ') - SUM(NVL(b.expense_reserve,0)'
               || v_intm
               || ')), -1,SUM(NVL(b.expense_reserve,0)'
               || v_intm
               || ') + SUM(NVL(a.expenses_paid,0)'
               || v_intm
               || '))) amt, '
               || 'b.loss_reserve'
               || v_intm
               || ' loss_res, 
                     a.losses_paid'
               || v_intm
               || ' loss_paid, '
               || 'b.expense_reserve'
               || v_intm
               || ' exp_res, 
                     a.expenses_paid'
               || v_intm
               || ' exp_paid, '
               || 'loss_reserve1'
               || v_intm
               || ' loss_res1, 
                     losses_paid1'
               || v_intm
               || ' loss_paid1, '
               || 'loss_reserve2'
               || v_intm
               || ' loss_res2, 
                     losses_paid2'
               || v_intm
               || ' loss_paid2, '
               || 'loss_reserve3'
               || v_intm
               || ' loss_res3, 
                     losses_paid3'
               || v_intm
               || ' loss_paid3, '
               || 'loss_reserve4'
               || v_intm
               || ' loss_res4, 
                     losses_paid4'
               || v_intm
               || ' loss_paid4, '
               || 'expense_reserve1'
               || v_intm
               || ' exp_res1, 
                     expenses_paid1'
               || v_intm
               || ' exp_paid1, '
               || 'expense_reserve2'
               || v_intm
               || ' exp_res2, 
                     expenses_paid2'
               || v_intm
               || ' exp_paid2, '
               || 'expense_reserve3'
               || v_intm
               || ' exp_res3, 
                     expenses_paid3'
               || v_intm
               || ' exp_paid3, '
               || 'expense_reserve4'
               || v_intm
               || ' exp_res4, 
                     expenses_paid4'
               || v_intm
               || ' exp_paid4';
            v_col_ins :=
                  'DECODE(a.clm_stat_cd, ''CD'',loss_paid,DECODE(SIGN(loss_paid-loss_res), -1, loss_res, loss_paid)), '
               || 'DECODE(a.clm_stat_cd, ''CD'',exp_paid,DECODE(SIGN(exp_paid-exp_res), -1, exp_res, exp_paid)), '
               || 'DECODE(a.clm_stat_cd, ''CD'',loss_paid1,DECODE(SIGN(loss_paid-loss_res), -1, loss_res1, loss_paid1)), '
               || 'DECODE(a.clm_stat_cd, ''CD'',exp_paid1,DECODE(SIGN(exp_paid-exp_res), -1, exp_res1, exp_paid1)), '
               || 'DECODE(a.clm_stat_cd, ''CD'',loss_paid2,DECODE(SIGN(loss_paid-loss_res), -1, loss_res2, loss_paid2)), '
               || 'DECODE(a.clm_stat_cd, ''CD'',exp_paid2,DECODE(SIGN(exp_paid-exp_res), -1, exp_res2, exp_paid2)), '
               || 'DECODE(a.clm_stat_cd, ''CD'',loss_paid3,DECODE(SIGN(loss_paid-loss_res), -1, loss_res3, loss_paid3)), '
               || 'DECODE(a.clm_stat_cd, ''CD'',exp_paid3,DECODE(SIGN(exp_paid-exp_res), -1, exp_res3, exp_paid3)), '
               || 'DECODE(a.clm_stat_cd, ''CD'',loss_paid4,DECODE(SIGN(loss_paid-loss_res), -1, loss_res4, loss_paid4)), '
               || 'DECODE(a.clm_stat_cd, ''CD'',exp_paid4,DECODE(SIGN(exp_paid-exp_res), -1, exp_res4, exp_paid4))';
            v_col_frm :=
                  ', loss_res, loss_paid, exp_res, exp_paid'
               || ', loss_res1, loss_paid1, exp_res1, exp_paid1'
               || ', loss_res2, loss_paid2, exp_res2, exp_paid2'
               || ', loss_res3, loss_paid3, exp_res3, exp_paid3'
               || ', loss_res4, loss_paid4, exp_res4, exp_paid4';
         ELSIF p_loss_expense = 'L'
         THEN
            v_column :=
                  'DECODE(SIGN(SUM(NVL(a.losses_paid,0)'
               || v_intm
               || ') - SUM(NVL(b.loss_reserve,0)'
               || v_intm
               || ')), -1, '
               || 'SUM(NVL(b.loss_reserve,0)'
               || v_intm
               || '), SUM(NVL(a.losses_paid,0)'
               || v_intm
               || ')) amt, '
               || 'SUM(NVL(b.loss_reserve,0)'
               || v_intm
               || ') loss_res, SUM(NVL(a.losses_paid,0)'
               || v_intm
               || ') loss_paid, '
               || 'SUM(NVL(loss_reserve1,0)'
               || v_intm
               || ') loss_res1, SUM(NVL(losses_paid1,0)'
               || v_intm
               || ') loss_paid1, '
               || 'SUM(NVL(loss_reserve2,0)'
               || v_intm
               || ') loss_res2, SUM(NVL(losses_paid2,0)'
               || v_intm
               || ') loss_paid2, '
               || 'SUM(NVL(loss_reserve3,0)'
               || v_intm
               || ') loss_res3, SUM(NVL(losses_paid3,0)'
               || v_intm
               || ') loss_paid3, '
               || 'SUM(NVL(loss_reserve4,0)'
               || v_intm
               || ') loss_res4, SUM(NVL(losses_paid4,0)'
               || v_intm
               || ') loss_paid4';
            v_col_ins :=
                  'DECODE(SIGN(loss_paid-loss_res), -1, loss_res, loss_paid), null, '
               || 'DECODE(SIGN(loss_paid-loss_res), -1, loss_res1, loss_paid1), null, '
               || 'DECODE(SIGN(loss_paid-loss_res), -1, loss_res2, loss_paid2), null, '
               || 'DECODE(SIGN(loss_paid-loss_res), -1, loss_res3, loss_paid3), null, '
               || 'DECODE(SIGN(loss_paid-loss_res), -1, loss_res4, loss_paid4), null';
            v_col_frm :=
                  ', loss_paid, loss_res'
               || ', loss_paid1, loss_res1'
               || ', loss_paid2, loss_res2'
               || ', loss_paid3, loss_res3'
               || ', loss_paid4, loss_res4';
         ELSE
            v_column :=
                  'DECODE(SIGN(SUM(NVL(a.expenses_paid,0)'
               || v_intm
               || ') - SUM(NVL(b.expense_reserve,0)'
               || v_intm
               || ')), -1, '
               || 'SUM(NVL(b.expense_reserve,0)'
               || v_intm
               || '), SUM(NVL(a.expenses_paid,0)'
               || v_intm
               || ')) amt, '
               || 'SUM(NVL(b.expense_reserve,0)'
               || v_intm
               || ') exp_res, SUM(NVL(a.expenses_paid,0)'
               || v_intm
               || ') exp_paid,'
               || 'SUM(NVL(expense_reserve1,0)'
               || v_intm
               || ') exp_res1, SUM(NVL(expenses_paid1,0)'
               || v_intm
               || ') exp_paid1,'
               || 'SUM(NVL(expense_reserve2,0)'
               || v_intm
               || ') exp_res2, SUM(NVL(expenses_paid2,0)'
               || v_intm
               || ') exp_paid2,'
               || 'SUM(NVL(expense_reserve3,0)'
               || v_intm
               || ') exp_res3, SUM(NVL(expenses_paid3,0)'
               || v_intm
               || ') exp_paid3,'
               || 'SUM(NVL(expense_reserve4,0)'
               || v_intm
               || ') exp_res4, SUM(NVL(expenses_paid4,0)'
               || v_intm
               || ') exp_paid4';
            v_col_ins :=
                  'null, DECODE(SIGN(exp_paid-exp_res), -1, exp_res, exp_paid), '
               || 'null, DECODE(SIGN(exp_paid-exp_res), -1, exp_res1, exp_paid1), '
               || 'null, DECODE(SIGN(exp_paid-exp_res), -1, exp_res2, exp_paid2), '
               || 'null, DECODE(SIGN(exp_paid-exp_res), -1, exp_res3, exp_paid3), '
               || 'null, DECODE(SIGN(exp_paid-exp_res), -1, exp_res4, exp_paid4)';
            v_col_frm :=
                  ', exp_paid, exp_res'
               || ', exp_paid1, exp_res1'
               || ', exp_paid2, exp_res2'
               || ', exp_paid3, exp_res3'
               || ', exp_paid4, exp_res4';
         END IF;
      ELSIF p_claim_amt_r = 'Y'
      THEN
         IF p_loss_expense = 'LE'
         THEN
            v_column :=
                  '('
               || v_col3
               || ' + '
               || v_col1
               || ') amt, '
               || 'SUM(NVL(loss_reserve ,0)'
               || v_intm
               || ') loss_res , '
               || 'SUM(NVL(loss_reserve1,0)'
               || v_intm
               || ') loss_res1, '
               || 'SUM(NVL(loss_reserve2,0)'
               || v_intm
               || ') loss_res2, '
               || 'SUM(NVL(loss_reserve3,0)'
               || v_intm
               || ') loss_res3, '
               || 'SUM(NVL(loss_reserve4,0)'
               || v_intm
               || ') loss_res4, '
               || 'SUM(NVL(expense_reserve ,0)'
               || v_intm
               || ') exp_res , '
               || 'SUM(NVL(expense_reserve1,0)'
               || v_intm
               || ') exp_res1, '
               || 'SUM(NVL(expense_reserve2,0)'
               || v_intm
               || ') exp_res2, '
               || 'SUM(NVL(expense_reserve3,0)'
               || v_intm
               || ') exp_res3, '
               || 'SUM(NVL(expense_reserve4,0)'
               || v_intm
               || ') exp_res4';
            v_col_ins :=
                  'loss_res, exp_res, '
               || 'loss_res1, exp_res1, '
               || 'loss_res2, exp_res2, '
               || 'loss_res3, exp_res3, '
               || 'loss_res4, exp_res4';
            v_col_frm :=
                  ', loss_res, exp_res'
               || ', loss_res1, exp_res1'
               || ', loss_res2, exp_res2'
               || ', loss_res3, exp_res3'
               || ', loss_res4, exp_res4';
         ELSIF p_loss_expense = 'L'
         THEN
            v_column :=
                  'SUM(NVL(loss_reserve ,0)'
               || v_intm
               || ') amt , '
               || 'SUM(NVL(loss_reserve1,0)'
               || v_intm
               || ') amt1, '
               || 'SUM(NVL(loss_reserve2,0)'
               || v_intm
               || ') amt2, '
               || 'SUM(NVL(loss_reserve3,0)'
               || v_intm
               || ') amt3, '
               || 'SUM(NVL(loss_reserve4,0)'
               || v_intm
               || ') amt4';
            v_col_ins :=
                   'amt, null, amt1, null, amt2, null, amt3, null, amt4, null';
            v_col_frm := ', amt1, amt2, amt3, amt4';
         ELSE
            v_column :=
                  'SUM(NVL(expense_reserve ,0)'
               || v_intm
               || ') amt , '
               || 'SUM(NVL(expense_reserve1,0)'
               || v_intm
               || ') amt1, '
               || 'SUM(NVL(expense_reserve2,0)'
               || v_intm
               || ') amt2, '
               || 'SUM(NVL(expense_reserve3,0)'
               || v_intm
               || ') amt3, '
               || 'SUM(NVL(expense_reserve4,0)'
               || v_intm
               || ') amt4';
            v_col_ins :=
                   'null, amt, null, amt1, null, amt2, null, amt3, null, amt4';
            v_col_frm := ', amt1, amt2, amt3, amt4';
         END IF;
      ELSE
         IF p_loss_expense = 'LE'
         THEN
            v_column :=
                  '('
               || v_col4
               || ' + '
               || v_col2
               || ') amt, '
               || 'SUM(NVL(losses_paid,0)'
               || v_intm
               || ') loss_paid,'
               || 'SUM(NVL(expenses_paid,0)'
               || v_intm
               || ') exp_paid,'
               || 'SUM(NVL(losses_paid1,0)'
               || v_intm
               || ') loss_paid1,'
               || 'SUM(NVL(expenses_paid1,0)'
               || v_intm
               || ') exp_paid1,'
               || 'SUM(NVL(losses_paid2,0)'
               || v_intm
               || ') loss_paid2,'
               || 'SUM(NVL(expenses_paid2,0)'
               || v_intm
               || ') exp_paid2,'
               || 'SUM(NVL(losses_paid3,0)'
               || v_intm
               || ') loss_paid3,'
               || 'SUM(NVL(expenses_paid3,0)'
               || v_intm
               || ') exp_paid3,'
               || 'SUM(NVL(losses_paid4,0)'
               || v_intm
               || ') loss_paid4,'
               || 'SUM(NVL(expenses_paid4,0)'
               || v_intm
               || ') exp_paid4';
            v_col_ins :=
                  'loss_paid, exp_paid, '
               || 'loss_paid1, exp_paid1, '
               || 'loss_paid2, exp_paid2, '
               || 'loss_paid3, exp_paid3, '
               || 'loss_paid4, exp_paid4';
            v_col_frm :=
                  ', loss_paid, exp_paid'
               || ', loss_paid1, exp_paid1'
               || ', loss_paid2, exp_paid2'
               || ', loss_paid3, exp_paid3'
               || ', loss_paid4, exp_paid4';
         ELSIF p_loss_expense = 'L'
         THEN
            v_column :=
                  'SUM(NVL(losses_paid ,0)'
               || v_intm
               || ') amt , '
               || 'SUM(NVL(losses_paid1,0)'
               || v_intm
               || ') amt1, '
               || 'SUM(NVL(losses_paid2,0)'
               || v_intm
               || ') amt2, '
               || 'SUM(NVL(losses_paid3,0)'
               || v_intm
               || ') amt3, '
               || 'SUM(NVL(losses_paid4,0)'
               || v_intm
               || ') amt4';
            v_col_ins :=
                   'amt, null, amt1, null, amt2, null, amt3, null, amt4, null';
            v_col_frm := ', amt1, amt2, amt3, amt4';
         ELSE
            v_column :=
                  'SUM(NVL(expenses_paid ,0)'
               || v_intm
               || ') amt , '
               || 'SUM(NVL(expenses_paid1,0)'
               || v_intm
               || ') amt1, '
               || 'SUM(NVL(expenses_paid2,0)'
               || v_intm
               || ') amt2, '
               || 'SUM(NVL(expenses_paid3,0)'
               || v_intm
               || ') amt3, '
               || 'SUM(NVL(expenses_paid4,0)'
               || v_intm
               || ') amt4';
            v_col_ins :=
                   'null, amt, null, amt1, null, amt2, null, amt3, null, amt4';
            v_col_frm := ', amt1, amt2, amt3, amt4';
         END IF;
      END IF;

      IF p_intm_no IS NOT NULL
      THEN
         p_col_frm := v_col_frm || ', intm_no';
      ELSE
         p_col_frm := v_col_frm;
      END IF;

      p_column := v_column;
      p_col_ins := v_col_ins;
      p_grp_out := v_grp_out;
   END;

   PROCEDURE get_dynamic_where (
      p_where            IN OUT   VARCHAR2,
      p_col_ins          IN OUT   VARCHAR2,
      p_line_cd          IN       giis_line.line_cd%TYPE,
      p_subline_cd       IN       giis_subline.subline_cd%TYPE,
      p_branch_cd        IN       giac_branches.branch_cd%TYPE,
      p_branch_param     IN       VARCHAR2,
      p_ri_iss_cd        IN       VARCHAR2,
      p_assd_cedant_no   IN       VARCHAR2
   )
   IS
   BEGIN
      IF p_line_cd IS NOT NULL
      THEN
         p_where := p_where || ' a.line_cd = ''' || p_line_cd || ''' AND';
      END IF;

      IF p_subline_cd IS NOT NULL
      THEN
         p_where := p_where || ' subline_cd = ''' || p_subline_cd || ''' AND';
      END IF;

      IF p_branch_cd IS NOT NULL
      THEN
         IF p_branch_param = 'C'
         THEN
            p_where := p_where || ' iss_cd ';
            p_col_ins := p_col_ins || ', iss_cd';
         ELSE
            p_where := p_where || ' pol_iss_cd ';
            p_col_ins := p_col_ins || ', pol_iss_cd';
         END IF;

         IF p_branch_cd = 'D'
         THEN
            p_where := p_where || '!= ''' || p_ri_iss_cd || ''' AND';
         ELSE
            p_where := p_where || '= ''' || p_branch_cd || ''' AND';
         END IF;
      ELSE
         p_col_ins := p_col_ins || ', NULL';
      END IF;

      IF p_assd_cedant_no IS NOT NULL
      THEN
         p_where := p_where || ' assd_no = ' || p_assd_cedant_no || ' AND';
      END IF;
   END;

   PROCEDURE get_dynamic_clm_stat (
      p_where             IN OUT   VARCHAR2,
      p_claim_status_op   IN       VARCHAR2,
      p_claim_status_cl   IN       VARCHAR2,
      p_claim_status_cc   IN       VARCHAR2,
      p_claim_status_de   IN       VARCHAR2,
      p_claim_status_wd   IN       VARCHAR2
   )
   IS
      v_clm_stat     VARCHAR2 (1000);
      v_dummy_stat   VARCHAR2 (4)    := '!@#$';
      v_cd           VARCHAR2 (2)    := 'CD';
      v_cc           VARCHAR2 (2)    := 'CC';
      v_dn           VARCHAR2 (2)    := 'DN';
      v_wd           VARCHAR2 (2)    := 'WD';
   BEGIN
      IF p_claim_status_op = 'OP'
      THEN
         FOR i IN (SELECT DISTINCT (clm_stat_cd) stat_cd
                              FROM gicl_claims
                             WHERE clm_stat_cd NOT IN
                                                    ('CD', 'CC', 'DN', 'WD'))
         LOOP
            v_clm_stat := v_clm_stat || '''' || i.stat_cd || '''';
            v_clm_stat := v_clm_stat || ',';
         END LOOP;
      ELSE
         v_clm_stat := v_clm_stat || '''' || v_dummy_stat || '''';
         v_clm_stat := v_clm_stat || ',';
      END IF;

      IF p_claim_status_cl = 'CL'
      THEN
         v_clm_stat := v_clm_stat || '''' || v_cd || '''';
         v_clm_stat := v_clm_stat || ',';
      ELSE
         v_clm_stat := v_clm_stat || '''' || v_dummy_stat || '''';
         v_clm_stat := v_clm_stat || ',';
      END IF;

      IF p_claim_status_cc = 'CC'
      THEN
         v_clm_stat := v_clm_stat || '''' || v_cc || '''';
         v_clm_stat := v_clm_stat || ',';
      ELSE
         v_clm_stat := v_clm_stat || '''' || v_dummy_stat || '''';
         v_clm_stat := v_clm_stat || ',';
      END IF;

      IF p_claim_status_de = 'DE'
      THEN
         v_clm_stat := v_clm_stat || '''' || v_dn || '''';
         v_clm_stat := v_clm_stat || ',';
      ELSE
         v_clm_stat := v_clm_stat || '''' || v_dummy_stat || '''';
         v_clm_stat := v_clm_stat || ',';
      END IF;

      IF p_claim_status_wd = 'WD'
      THEN
         v_clm_stat := v_clm_stat || '''' || v_wd || '''';
      ELSE
         v_clm_stat := v_clm_stat || '''' || v_dummy_stat || '''';
      END IF;

      p_where := p_where || ' clm_stat_cd  IN (' || v_clm_stat || ') ';
   END;

   PROCEDURE get_dynamic_table (
      p_where          IN OUT   VARCHAR2,
      p_table          IN OUT   VARCHAR2,
      p_chk            IN OUT   VARCHAR2,
      p_claim_date     IN       VARCHAR2,
      p_as_of_date     IN       DATE,
      p_from_date      IN       DATE,
      p_to_date        IN       DATE,
      p_claim_amt_o    IN       VARCHAR2,
      p_claim_amt_r    IN       VARCHAR2,
      p_claim_amt_s    IN       VARCHAR2,
      p_loss_expense   IN       VARCHAR2
   )
   IS
      v_date   VARCHAR2 (100);
   BEGIN
      IF p_claim_date = 'F'
      THEN
         v_date := 'clm_file_date';
      ELSIF p_claim_date = 'L'
      THEN
         v_date := 'dsp_loss_date';
      ELSE
         v_date := 'clm_setl_date';
      END IF;

      IF p_claim_amt_o = 'Y'
      THEN
         p_table :=
               '(SELECT a.claim_id, a.line_cd'
            || ' FROM gicl_claims a, gicl_clm_res_hist b, gicl_item_peril c'
            || ' WHERE a.claim_id = b.claim_id'
            || ' AND b.claim_id = c.claim_id '
            || ' AND b.item_no  = c.item_no'
            || ' AND b.peril_cd = c.peril_cd'
            || ' AND '
            || p_where
            || ' AND TO_DATE(NVL(b.booking_month,TO_CHAR(clm_file_date,''FMMONTH''))'
            || '||'' 01, '''
            || '||TO_CHAR(NVL(b.booking_year,TO_CHAR(clm_file_date,''RRRR''))),''FMMONTH DD, RRRR'')'
            || ' <= TO_DATE(TO_CHAR(TO_DATE('''
            || p_as_of_date
            || ''',''DD-MON-RR''),''FMMONTH DD, RRRR''),''FMMONTH DD, RRRR'')'
            || ' AND (TRUNC(c.close_date) > '''
            || p_as_of_date
            || ''' OR c.close_date IS NULL)'
            || ' GROUP BY a.claim_id, a.line_cd) a,'
            || ' (SELECT SUM(NVL(losses_paid,0)) losses_paid, SUM(NVL(expenses_paid,0)) expenses_paid, a.claim_id'
            || ' FROM gicl_claims a, gicl_clm_res_hist b'
            || ' WHERE a.claim_id = b.claim_id'
            || ' AND '
            || p_where
            || ' AND tran_id IS NOT NULL'
            || ' AND TRUNC(date_paid) <= '''
            || p_as_of_date
            || ''''
            || ' AND NVL(cancel_tag,''N'') = ''N'''
            || ' GROUP BY a.claim_id) b, '
            || ' (SELECT NVL(SUM(decode(share_type, 1, shr_loss_res_amt, 0)), 0) loss_reserve1, '
            || 'NVL(SUM(decode(share_type, 2, shr_loss_res_amt, 0)), 0) loss_reserve2, '
            || 'NVL(SUM(decode(share_type, 3, shr_loss_res_amt, 0)), 0) loss_reserve3, '
            || 'NVL(SUM(decode(share_type, 4, shr_loss_res_amt, 0)), 0) loss_reserve4, '
            || 'NVL(SUM(decode(share_type, 1, shr_exp_res_amt, 0)), 0) expense_reserve1, '
            || 'NVL(SUM(decode(share_type, 2, shr_exp_res_amt, 0)), 0) expense_reserve2, '
            || 'NVL(SUM(decode(share_type, 3, shr_exp_res_amt, 0)), 0) expense_reserve3, '
            || 'NVL(SUM(decode(share_type, 4, shr_exp_res_amt, 0)), 0) expense_reserve4, '
            || 'claim_id, clm_res_hist_id '
            || 'FROM gicl_reserve_ds '
            || 'GROUP BY claim_id, clm_res_hist_id) e, '
            || ' (SELECT SUM(DECODE(a.payee_type, ''L'', DECODE(b.share_type, 1, b.shr_le_net_amt, 0), 0)) losses_paid1, '
            || 'SUM(DECODE(a.payee_type, ''L'', DECODE(b.share_type, 2, b.shr_le_net_amt, 0), 0)) losses_paid2, '
            || 'SUM(DECODE(a.payee_type, ''L'', DECODE(b.share_type, 3, b.shr_le_net_amt, 0), 0)) losses_paid3, '
            || 'SUM(DECODE(a.payee_type, ''L'', DECODE(b.share_type, 4, b.shr_le_net_amt, 0), 0)) losses_paid4, '
            || 'SUM(DECODE(a.payee_type, ''E'', DECODE(b.share_type, 1, b.shr_le_net_amt, 0), 0)) expenses_paid1, '
            || 'SUM(DECODE(a.payee_type, ''E'', DECODE(b.share_type, 2, b.shr_le_net_amt, 0), 0)) expenses_paid2, '
            || 'SUM(DECODE(a.payee_type, ''E'', DECODE(b.share_type, 3, b.shr_le_net_amt, 0), 0)) expenses_paid3, '
            || 'SUM(DECODE(a.payee_type, ''E'', DECODE(b.share_type, 4, b.shr_le_net_amt, 0), 0)) expenses_paid4, '
            || 'a.claim_id '
            || 'FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b '
            || 'WHERE a.claim_id = b.claim_id '
            || 'AND a.clm_loss_id = b.clm_loss_id '
            || 'AND a.tran_id IS NOT NULL '
            || 'AND TRUNC(a.tran_date) <= '''
            || p_as_of_date
            || ''''
            || ' AND NVL(a.dist_sw, ''N'') = ''Y'''
            || ' AND NVL(b.negate_tag, ''N'') = ''N'''
            || ' GROUP BY a.claim_id) f';
         p_chk := 'O';
      ELSIF p_claim_amt_s = 'Y' AND p_claim_amt_r = 'Y'
      THEN
         IF p_where IS NULL
         THEN
            p_where := ' 1 = 1 ';
         END IF;

         p_table :=
               '(SELECT SUM(NVL(expenses_paid,0)) expenses_paid, SUM(NVL(losses_paid,0)) losses_paid, a.claim_id, a.line_cd'
            || ' FROM gicl_claims a, gicl_clm_res_hist b'
            || ' WHERE a.claim_id = b.claim_id'
            || ' AND '
            || p_where
            || 'AND tran_id IS NOT NULL'
            || ' AND NVL(cancel_tag,''N'') = ''N'''
            || ' AND '
            || v_date
            || ' >= '''
            || p_from_date
            || ''''
            || ' AND '
            || v_date
            || ' <= '''
            || p_to_date
            || ''''
            || ' GROUP BY a.claim_id, a.line_cd) a,'
            || '(SELECT SUM(NVL(expense_reserve,0)) expense_reserve, SUM(NVL(loss_reserve,0)) loss_reserve, a.claim_id'
            || ' FROM gicl_claims a, gicl_clm_res_hist b'
            || ' WHERE a.claim_id = b.claim_id'
            || ' AND NVL(dist_sw,''N'') != ''N'''
            || ' AND '
            || v_date
            || ' >= '''
            || p_from_date
            || ''''
            || ' AND '
            || v_date
            || ' <= '''
            || p_to_date
            || ''''
            || ' GROUP BY a.claim_id) b, '
            || '(SELECT NVL(SUM(DECODE(share_type, 1, shr_loss_res_amt, 0)), 0) loss_reserve1, '
            || 'NVL(SUM(DECODE(share_type, 2, shr_loss_res_amt, 0)), 0) loss_reserve2, '
            || 'NVL(SUM(DECODE(share_type, 3, shr_loss_res_amt, 0)), 0) loss_reserve3, '
            || 'NVL(SUM(DECODE(share_type, 4, shr_loss_res_amt, 0)), 0) loss_reserve4, '
            || 'NVL(SUM(DECODE(share_type, 1, shr_exp_res_amt, 0)), 0) expense_reserve1, '
            || 'NVL(SUM(DECODE(share_type, 2, shr_exp_res_amt, 0)), 0) expense_reserve2, '
            || 'NVL(SUM(DECODE(share_type, 3, shr_exp_res_amt, 0)), 0) expense_reserve3, '
            || 'NVL(SUM(DECODE(share_type, 4, shr_exp_res_amt, 0)), 0) expense_reserve4, '
            || 'a.claim_id '
            || 'FROM gicl_reserve_ds a, gicl_clm_res_hist b '
            || 'WHERE a.claim_id = b.claim_id '
            || 'AND a.clm_res_hist_id = b.clm_res_hist_id '
            || 'AND NVL (dist_sw, ''N'') != ''N'' '
            || 'GROUP by a.claim_id) e, '
            || '(SELECT SUM(DECODE(a.payee_type, ''L'', DECODE(b.share_type, 1, b.shr_le_net_amt, 0), 0)) losses_paid1, '
            || 'SUM(DECODE(a.payee_type, ''L'', DECODE(b.share_type, 2, b.shr_le_net_amt, 0), 0)) losses_paid2, '
            || 'SUM(DECODE(a.payee_type, ''L'', DECODE(b.share_type, 3, b.shr_le_net_amt, 0), 0)) losses_paid3, '
            || 'SUM(DECODE(a.payee_type, ''L'', DECODE(b.share_type, 4, b.shr_le_net_amt, 0), 0)) losses_paid4, '
            || 'SUM(DECODE(a.payee_type, ''E'', DECODE(b.share_type, 1, b.shr_le_net_amt, 0), 0)) expenses_paid1, '
            || 'SUM(DECODE(a.payee_type, ''E'', DECODE(b.share_type, 2, b.shr_le_net_amt, 0), 0)) expenses_paid2, '
            || 'SUM(DECODE(a.payee_type, ''E'', DECODE(b.share_type, 3, b.shr_le_net_amt, 0), 0)) expenses_paid3, '
            || 'SUM(DECODE(a.payee_type, ''E'', DECODE(b.share_type, 4, b.shr_le_net_amt, 0), 0)) expenses_paid4, '
            || 'a.claim_id '
            || 'FROM gicl_clm_loss_exp a, '
            || 'gicl_loss_exp_ds b '
            || 'WHERE a.claim_id = b.claim_id '
            || 'AND a.clm_loss_id = b.clm_loss_id '
            || 'AND a.tran_id IS NOT NULL '
            || 'AND NVL(a.dist_sw, ''N'') = ''Y'' '
            || 'AND NVL(b.negate_tag, ''N'') = ''N'' '
            || 'GROUP BY a.claim_id) f';
         p_chk := 'B';
      ELSIF p_claim_amt_s = 'Y'
      THEN
         p_table :=
               'gicl_claims a, gicl_clm_res_hist b, '
            || '(SELECT a.claim_id, a.clm_loss_id, '
            || 'SUM(DECODE(a.payee_type, ''L'', DECODE(b.share_type, 1, b.shr_le_net_amt, 0), 0)) losses_paid1, '
            || 'SUM(DECODE(a.payee_type, ''L'', DECODE(b.share_type, 2, b.shr_le_net_amt, 0), 0)) losses_paid2, '
            || 'SUM(DECODE(a.payee_type, ''L'', DECODE(b.share_type, 3, b.shr_le_net_amt, 0), 0)) losses_paid3, '
            || 'SUM(DECODE(a.payee_type, ''L'', DECODE(b.share_type, 4, b.shr_le_net_amt, 0), 0)) losses_paid4, '
            || 'SUM(DECODE(a.payee_type, ''E'', DECODE(b.share_type, 1, b.shr_le_net_amt, 0), 0)) expenses_paid1, '
            || 'SUM(DECODE(a.payee_type, ''E'', DECODE(b.share_type, 2, b.shr_le_net_amt, 0), 0)) expenses_paid2, '
            || 'SUM(DECODE(a.payee_type, ''E'', DECODE(b.share_type, 3, b.shr_le_net_amt, 0), 0)) expenses_paid3, '
            || 'SUM(DECODE(a.payee_type, ''E'', DECODE(b.share_type, 4, b.shr_le_net_amt, 0), 0)) expenses_paid4 '
            || 'FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b '
            || 'WHERE a.claim_id = b.claim_id '
            || 'AND a.clm_loss_id = b.clm_loss_id '
            || 'AND a.tran_id IS NOT NULL '
            || 'AND TRUNC(a.tran_date) >= '''
            || p_from_date
            || ''''
            || 'AND TRUNC(a.tran_date) <= '''
            || p_to_date
            || ''''
            || ' AND NVL(a.dist_sw, ''N'') = ''Y'''
            || ' AND NVL(b.negate_tag, ''N'') = ''N'''
            || ' GROUP BY a.claim_id, a.clm_loss_id) e';

         IF p_where IS NOT NULL
         THEN
            p_where :=
                  p_where
               || 'AND tran_id IS NOT NULL'
               || ' AND NVL(cancel_tag,''N'') = ''N'''
               || ' AND a.claim_id = e.claim_id '
               || ' AND b.clm_loss_id = e.clm_loss_id '
               || ' AND TRUNC(date_paid) >= '''
               || p_from_date
               || ''''
               || ' AND TRUNC(date_paid) <= '''
               || p_to_date
               || '''';
         ELSE
            p_where :=
                  p_where
               || 'AND tran_id IS NOT NULL'
               || ' AND NVL(cancel_tag,''N'') = ''N'''
               || ' AND a.claim_id = e.claim_id '
               || ' AND b.clm_loss_id = e.clm_loss_id '
               || ' AND TRUNC(date_paid) >= '''
               || p_from_date
               || ''''
               || ' AND TRUNC(date_paid) <= '''
               || p_to_date
               || '''';
         END IF;
      ELSIF p_claim_amt_r = 'Y'
      THEN
         p_table :=
               'gicl_claims a, gicl_clm_res_hist b, '
            || '(SELECT NVL(SUM(decode(share_type, 1, shr_loss_res_amt, 0)), 0) loss_reserve1, '
            || 'NVL(SUM(decode(share_type, 2, shr_loss_res_amt, 0)), 0) loss_reserve2, '
            || 'NVL(SUM(decode(share_type, 3, shr_loss_res_amt, 0)), 0) loss_reserve3, '
            || 'NVL(SUM(decode(share_type, 4, shr_loss_res_amt, 0)), 0) loss_reserve4, '
            || 'NVL(SUM(decode(share_type, 1, shr_exp_res_amt, 0)), 0) expense_reserve1, '
            || 'NVL(SUM(decode(share_type, 2, shr_exp_res_amt, 0)), 0) expense_reserve2, '
            || 'NVL(SUM(decode(share_type, 3, shr_exp_res_amt, 0)), 0) expense_reserve3, '
            || 'NVL(SUM(decode(share_type, 4, shr_exp_res_amt, 0)), 0) expense_reserve4, '
            || 'claim_id, clm_res_hist_id '
            || 'FROM gicl_reserve_ds '
            || 'GROUP BY claim_id, clm_res_hist_id) e';

         IF p_where IS NOT NULL
         THEN
            p_where :=
                  p_where
               || 'AND NVL(dist_sw,''N'') != ''N'''
               || ' AND a.claim_id = e.claim_id'
               || ' AND b.clm_res_hist_id = e.clm_res_hist_id'
               || ' AND '
               || v_date
               || ' >= '''
               || p_from_date
               || ''''
               || ' AND '
               || v_date
               || ' <= '''
               || p_to_date
               || '''';
         ELSE
            p_where :=
                  p_where
               || 'NVL(dist_sw,''N'') != ''N'''
               || ' AND a.claim_id = e.claim_id'
               || ' AND b.clm_res_hist_id = e.clm_res_hist_id'
               || ' AND '
               || v_date
               || ' >= '''
               || p_from_date
               || ''''
               || ' AND '
               || v_date
               || ' <= '''
               || p_to_date
               || '''';
         END IF;
      END IF;
   END;

   FUNCTION validate_date_params (
      p_user_id          VARCHAR2,
      p_extract_type     VARCHAR2,
      p_loss_amt         gicl_clm_summary.ploss_amt%TYPE,
      p_biggest_claims   gicl_clm_summary.pbiggest_claims%TYPE,
      p_f_date           VARCHAR2,
      p_t_date           VARCHAR2,
      p_as_of_date       VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_session_id   VARCHAR2 (10) := '0';
   BEGIN
      SELECT TO_CHAR (session_id)
        INTO v_session_id
        FROM gicl_clm_summary
       WHERE user_id = p_user_id
         AND extract_type = p_extract_type
         AND NVL (ploss_amt, 99999) = NVL (p_loss_amt, 99999)
         AND NVL (pbiggest_claims, 99999) = NVL (p_biggest_claims, 99999)
         AND (   (    f_date = TO_DATE (p_f_date, 'MM-DD-RRRR')
                  AND t_date = TO_DATE (p_t_date, 'MM-DD-RRRR')
                 )
              OR as_of_date = TO_DATE (p_as_of_date, 'MM-DD-RRRR')
             )
         AND ROWNUM = 1;

      RETURN v_session_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN '0';
   END;
END;
/


