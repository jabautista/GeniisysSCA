CREATE OR REPLACE PACKAGE BODY CPI.giacr212_pkg
AS
   FUNCTION get_giacr212_record (
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_date_type   VARCHAR2,
      p_sl_type     VARCHAR2,
      p_user_id     VARCHAR2,
      p_branch_cd   VARCHAR2
   )
      RETURN giacr212_record_tab PIPELINED
   IS
      v_rec         giacr212_record_type;
      v_not_exist   BOOLEAN              := TRUE;
      v_from_date   DATE               := TO_DATE (p_from_date, 'MM-DD-YYYY');
      v_to_date     DATE                 := TO_DATE (p_to_date, 'MM-DD-YYYY');
   BEGIN
      v_rec.company_name := giisp.v ('COMPANY_NAME');
      v_rec.company_add := giacp.v ('COMPANY_ADDRESS');
      v_rec.date_range :=
            'From '
         || ' '
         || (   TO_CHAR (v_from_date, 'fmMonth DD, YYYY')
             || ' to '
             || TO_CHAR (v_to_date, 'fmMonth DD, YYYY')
            );

      IF p_date_type = 'P'
      THEN
         FOR i IN
            (SELECT   a.sl_cd, c.sl_name,
                         TO_CHAR (d.gl_acct_category)
                      || '-'
                      || TO_CHAR (d.gl_control_acct)
                      || '-'
                      || TO_CHAR (d.gl_sub_acct_1)
                      || '-'
                      || TO_CHAR (d.gl_sub_acct_2)
                      || '-'
                      || TO_CHAR (d.gl_sub_acct_3)
                      || '-'
                      || TO_CHAR (d.gl_sub_acct_4)
                      || '-'
                      || TO_CHAR (d.gl_sub_acct_5)
                      || '-'
                      || TO_CHAR (d.gl_sub_acct_6)
                      || '-'
                      || TO_CHAR (d.gl_sub_acct_7) gl_acct_id,
                      d.gl_acct_sname,
                      e.gibr_branch_cd || '-' || f.branch_name branch_name,
                      SUM (a.debit_amt) debit_sum,
                      SUM (a.credit_amt) credit_sum
                 FROM giac_acct_entries a,
                      giac_sl_lists c,
                      giac_chart_of_accts d,
                      giac_acctrans e,
                      giac_branches f
                WHERE a.sl_cd = c.sl_cd
                  AND c.sl_type_cd = p_sl_type
                  AND a.gl_acct_id IN (SELECT b.gl_acct_id
                                         FROM giac_eom_rep_dtl b
                                        WHERE b.rep_cd = 'GIACS190')
                  AND a.gl_acct_id = d.gl_acct_id
                  AND e.gibr_branch_cd = NVL (p_branch_cd, e.gibr_branch_cd)
                  AND check_user_per_iss_cd_acctg2 (NULL,
                                                    e.gibr_branch_cd,
                                                    'GIACS190',
                                                    p_user_id
                                                   ) = 1
                  --added by reymon 05252012
                  AND e.gfun_fund_cd = f.gfun_fund_cd
                  AND e.gibr_branch_cd = f.branch_cd
                  AND e.tran_flag = 'P'
                  AND a.gacc_tran_id = e.tran_id
                  AND TRUNC (e.posting_date) BETWEEN v_from_date AND v_to_date
             GROUP BY a.sl_cd,
                      e.gibr_branch_cd || '-' || f.branch_name,
                      c.sl_name,
                      d.gl_acct_sname,
                         TO_CHAR (d.gl_acct_category)
                      || '-'
                      || TO_CHAR (d.gl_control_acct)
                      || '-'
                      || TO_CHAR (d.gl_sub_acct_1)
                      || '-'
                      || TO_CHAR (d.gl_sub_acct_2)
                      || '-'
                      || TO_CHAR (d.gl_sub_acct_3)
                      || '-'
                      || TO_CHAR (d.gl_sub_acct_4)
                      || '-'
                      || TO_CHAR (d.gl_sub_acct_5)
                      || '-'
                      || TO_CHAR (d.gl_sub_acct_6)
                      || '-'
                      || TO_CHAR (d.gl_sub_acct_7)
             ORDER BY a.sl_cd)
         LOOP
            v_not_exist := FALSE;
            v_rec.sl_cd := i.sl_cd;
            v_rec.sl_name := i.sl_name;
            v_rec.gl_acct_id := i.gl_acct_id;
            v_rec.gl_acct_sname := i.gl_acct_sname;
            v_rec.branch_name := i.branch_name;
            v_rec.debit_sum := i.debit_sum;
            v_rec.credit_sum := i.credit_sum;
            PIPE ROW (v_rec);
         END LOOP;
      ELSIF p_date_type = 'T'
      THEN
         FOR i IN
            (SELECT   a.sl_cd, c.sl_name,
                         TO_CHAR (d.gl_acct_category)
                      || '-'
                      || TO_CHAR (d.gl_control_acct)
                      || '-'
                      || TO_CHAR (d.gl_sub_acct_1)
                      || '-'
                      || TO_CHAR (d.gl_sub_acct_2)
                      || '-'
                      || TO_CHAR (d.gl_sub_acct_3)
                      || '-'
                      || TO_CHAR (d.gl_sub_acct_4)
                      || '-'
                      || TO_CHAR (d.gl_sub_acct_5)
                      || '-'
                      || TO_CHAR (d.gl_sub_acct_6)
                      || '-'
                      || TO_CHAR (d.gl_sub_acct_7) gl_acct_id,
                      d.gl_acct_sname,
                      e.gibr_branch_cd || '-' || f.branch_name branch_name,
                      SUM (a.debit_amt) debit_sum,
                      SUM (a.credit_amt) credit_sum
                 FROM giac_acct_entries a,
                      giac_sl_lists c,
                      giac_chart_of_accts d,
                      giac_acctrans e,
                      giac_branches f
                WHERE a.sl_cd = c.sl_cd
                  AND c.sl_type_cd = p_sl_type
                  AND a.gl_acct_id IN (SELECT b.gl_acct_id
                                         FROM giac_eom_rep_dtl b
                                        WHERE b.rep_cd = 'GIACS190')
                  AND a.gl_acct_id = d.gl_acct_id
                  AND e.gibr_branch_cd = NVL (p_branch_cd, e.gibr_branch_cd)
                  AND check_user_per_iss_cd_acctg2 (NULL,
                                                    e.gibr_branch_cd,
                                                    'GIACS190',
                                                    p_user_id
                                                   ) = 1
                  --added by reymon 05252012
                  AND e.gibr_branch_cd = f.branch_cd
                  AND e.gfun_fund_cd = f.gfun_fund_cd
                  AND e.tran_flag NOT IN ('D', 'O')
                  AND a.gacc_tran_id = e.tran_id
                  AND TRUNC (e.tran_date) BETWEEN v_from_date AND v_to_date
             GROUP BY a.sl_cd,
                      e.gibr_branch_cd || '-' || f.branch_name,
                      c.sl_name,
                      d.gl_acct_sname,
                         TO_CHAR (d.gl_acct_category)
                      || '-'
                      || TO_CHAR (d.gl_control_acct)
                      || '-'
                      || TO_CHAR (d.gl_sub_acct_1)
                      || '-'
                      || TO_CHAR (d.gl_sub_acct_2)
                      || '-'
                      || TO_CHAR (d.gl_sub_acct_3)
                      || '-'
                      || TO_CHAR (d.gl_sub_acct_4)
                      || '-'
                      || TO_CHAR (d.gl_sub_acct_5)
                      || '-'
                      || TO_CHAR (d.gl_sub_acct_6)
                      || '-'
                      || TO_CHAR (d.gl_sub_acct_7)
             ORDER BY a.sl_cd)
         LOOP
            v_not_exist := FALSE;
            v_rec.sl_cd := i.sl_cd;
            v_rec.sl_name := i.sl_name;
            v_rec.gl_acct_id := i.gl_acct_id;
            v_rec.gl_acct_sname := i.gl_acct_sname;
            v_rec.branch_name := i.branch_name;
            v_rec.debit_sum := i.debit_sum;
            v_rec.credit_sum := i.credit_sum;
            PIPE ROW (v_rec);
         END LOOP;
      END IF;

      IF v_not_exist
      THEN
         v_rec.is_exists := 'N';
         PIPE ROW (v_rec);
      END IF;
   END;
END;
/


