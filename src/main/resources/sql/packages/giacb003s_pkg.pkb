CREATE OR REPLACE PACKAGE BODY CPI.GIACB003S_PKG
AS
/*
   ** Created by : Kenneth Labrador
   ** Date Created : 10.16.2013
   ** Reference By : GIACB003D
   ** Description : Outward Facultative Cessions (Detail)
   */
   FUNCTION get_giacb003s_record (p_date VARCHAR2, p_user_id VARCHAR2)
      RETURN giacb003s_record_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      c          cur_typ;
      v_list     giacb003s_record_type;
      v_flag     BOOLEAN               := FALSE;
      v_select   VARCHAR2 (15000);
      v_where2   VARCHAR2 (5000);
      v_where    VARCHAR2 (5000);
      v_date     VARCHAR2 (50);
   BEGIN
      v_date :=
            TO_CHAR (LAST_DAY (TO_DATE (p_date, 'MM-DD-RRRR')), 'MM-DD-RRRR');

      IF SIGN (giacp.d ('GIACB003_START_DATE')
               - TO_DATE (v_date, 'MM-DD-RRRR')
              ) = -1
      THEN
         v_where2 :=
               'AND TRUNC (f.acct_ent_date) <= TO_DATE ('''
            || v_date
            || ''', ''MM-DD-YYYY'')';
         v_where :=
               'AND (   (    f.dist_flag = ''4'''
            || 'AND LAST_DAY (TRUNC (f.acct_neg_date)) = TO_DATE ('''
            || v_date
            || ''', ''MM-DD-YYYY''))'
            || 'OR (b.reverse_sw = ''Y'')'
            || 'OR (f.dist_flag = ''5'')'
            || ')';
      ELSE
         v_where2 :=
               'AND TRUNC (f.acct_ent_date) = TO_DATE ('''
            || v_date
            || ''', ''MM-DD-YYYY'')';
         v_where :=
               'AND TRUNC (f.acct_neg_date) = TO_DATE ('''
            || v_date
            || ''', ''MM-DD-YYYY'')';
      END IF;

      v_list.cf_company_name := NVL (giisp.v ('COMPANY_NAME'), ' ');
      v_list.top_date :=
            'For the Month of '
         || TO_CHAR (TO_DATE (v_date, 'mm/dd/yyyy'), 'fmMONTH yyyy');
      v_list.cf_company_address := NVL (giisp.v ('COMPANY_ADDRESS'), ' ');
      v_list.v_flag := 'N';
      v_select :=
            'SELECT   g.line_cd, get_policy_no (g.policy_id) POLICY_NUMBER,
                                g.line_cd
                             || ''-''
                             || TO_CHAR (a.frps_yy)
                             || ''-''
                             || TO_CHAR (a.frps_seq_no)
                             || ''-''
                             || TO_CHAR (a.ri_seq_no) FRPS_NO,
                             g.subline_cd, a.peril_cd,
                             (SUM (a.ri_tsi_amt) * NVL (d.currency_rt, 0)) tsi_amt,
                             SUM (a.ri_prem_amt * d.currency_rt) prem_amt,
                             SUM (a.ri_comm_amt * d.currency_rt) comm_amt,
                             NVL (g.cred_branch, g.iss_cd) iss_cd,
                             SUM (NVL (a.ri_prem_vat, 0) * d.currency_rt) ri_prem_vat,
                             SUM (NVL (a.ri_comm_vat, 0) * d.currency_rt) ri_comm_vat,
                             SUM (NVL (a.ri_wholding_vat, 0) * d.currency_rt) ri_wholding_vat
                        FROM giri_frperil a,
                             giri_frps_ri b,
                             giri_binder c,
                             giri_distfrps d,
                             giuw_policyds e,
                             giuw_pol_dist f,
                             gipi_polbasic g,
                             giis_line i,
                             giis_subline j,
                             giis_reinsurer k
                       WHERE a.line_cd = b.line_cd
                         AND a.frps_yy = b.frps_yy
                         AND a.frps_seq_no = b.frps_seq_no
                         AND a.ri_seq_no = b.ri_seq_no
                         AND a.ri_cd = k.ri_cd
                         AND b.fnl_binder_id = c.fnl_binder_id
                         AND b.line_cd = d.line_cd
                         AND b.frps_yy = d.frps_yy
                         AND b.frps_seq_no = d.frps_seq_no
                         AND d.dist_no = e.dist_no
                         AND d.dist_seq_no = e.dist_seq_no
                         AND e.dist_no = f.dist_no
                         AND f.policy_id = g.policy_id
                         AND g.acct_ent_date IS NOT NULL
                         AND g.acct_ent_date <= TO_DATE ('''
         || v_date
         || ''', ''MM-DD-YYYY'')
                         AND LAST_DAY (TRUNC (c.acc_ent_date)) = TO_DATE ('''
         || v_date
         || ''', ''MM-DD-YYYY'')
                         '
         || v_where2
         || '
                         AND g.line_cd = i.line_cd
                         AND g.line_cd = j.line_cd
                         AND g.subline_cd = j.subline_cd
                         AND g.reg_policy_sw = ''Y''
                         AND check_user_per_iss_cd_acctg2 (NULL,
                                                           NVL (g.cred_branch, c.iss_cd),
                                                           ''GIARPR001'', '''
         || p_user_id
         || ''') = 1
                    GROUP BY NVL (g.cred_branch, g.iss_cd),
                             g.policy_id,
                             g.line_cd,
                             g.subline_cd,
                             a.peril_cd,
                             a.frps_yy,
                             a.frps_seq_no,
                             a.ri_seq_no,
                             d.currency_rt
                    UNION
                    SELECT   g.line_cd, get_policy_no (g.policy_id) POLICY_NUMBER,
                                g.line_cd
                             || ''-''
                             || TO_CHAR (a.frps_yy)
                             || ''-''
                             || TO_CHAR (a.frps_seq_no)
                             || ''-''
                             || TO_CHAR (a.ri_seq_no) FRPS_NO,
                             g.subline_cd, a.peril_cd,
                             (SUM (a.ri_tsi_amt) * NVL (d.currency_rt, 0)) * (-1) tsi_amt,
                             SUM (a.ri_prem_amt * d.currency_rt) * (-1) prem_amt,
                             SUM (a.ri_comm_amt * d.currency_rt) * (-1) comm_amt,
                             NVL (g.cred_branch, g.iss_cd) iss_cd,
                             SUM (NVL (a.ri_prem_vat, 0) * d.currency_rt) * (-1) ri_prem_vat,
                             SUM (NVL (a.ri_comm_vat, 0) * d.currency_rt) * (-1) ri_comm_vat,
                               SUM (NVL (a.ri_wholding_vat, 0) * d.currency_rt)
                             * (-1) ri_wholding_vat
                        FROM giri_frperil a,
                             giri_frps_ri b,
                             giri_binder c,
                             giri_distfrps d,
                             giuw_policyds e,
                             giuw_pol_dist f,
                             gipi_polbasic g,
                             giis_line i,
                             giis_subline j,
                             giis_reinsurer k
                       WHERE a.line_cd = b.line_cd
                         AND a.frps_yy = b.frps_yy
                         AND a.frps_seq_no = b.frps_seq_no
                         AND a.ri_seq_no = b.ri_seq_no
                         AND a.ri_cd = k.ri_cd
                         AND b.fnl_binder_id = c.fnl_binder_id
                         AND b.line_cd = d.line_cd
                         AND b.frps_yy = d.frps_yy
                         AND b.frps_seq_no = d.frps_seq_no
                         AND d.dist_no = e.dist_no
                         AND d.dist_seq_no = e.dist_seq_no
                         AND e.dist_no = f.dist_no
                         AND f.policy_id = g.policy_id
                         AND g.acct_ent_date IS NOT NULL
                         AND g.acct_ent_date <= TO_DATE ('''
         || v_date
         || ''', ''MM-DD-YYYY'')
                         AND LAST_DAY (TRUNC (c.acc_rev_date)) = TO_DATE ('''
         || v_date
         || ''', ''MM-DD-YYYY'')
                         '
         || v_where
         || '
                         AND g.line_cd = i.line_cd
                         AND g.line_cd = j.line_cd
                         AND g.subline_cd = j.subline_cd
                         AND g.reg_policy_sw = ''Y''
                         AND check_user_per_iss_cd_acctg2 (NULL,
                                                           NVL (g.cred_branch, c.iss_cd),
                                                           ''GIARPR001'', '''
         || p_user_id
         || ''') = 1
                    GROUP BY NVL (g.cred_branch, g.iss_cd),
                             g.policy_id,
                             g.line_cd,
                             g.subline_cd,
                             a.peril_cd,
                             a.frps_yy,
                             a.frps_seq_no,
                             a.ri_seq_no,
                             d.currency_rt';

      OPEN c FOR v_select;

      LOOP
         FETCH c
          INTO v_list.line_cd, v_list.policy_number, v_list.frps_no,
               v_list.subline_cd, v_list.peril_cd, v_list.tsi_amt,
               v_list.prem_amt, v_list.comm_amt, v_list.iss_cd,
               v_list.ri_prem_vat, v_list.ri_comm_vat,
               v_list.ri_wholding_vat;

         IF v_list.line_cd IS NULL
         THEN
            v_flag := FALSE;
            v_list.v_flag := 'N';
         ELSE
            v_flag := TRUE;
            v_list.v_flag := 'Y';
         END IF;

         BEGIN
            SELECT line_name
              INTO v_list.line_name
              FROM giis_line
             WHERE line_cd = v_list.line_cd;
             EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.line_name := '';
         END;

         BEGIN
            SELECT subline_name
              INTO v_list.subline_name
              FROM giis_subline
             WHERE line_cd = v_list.line_cd AND subline_cd = v_list.subline_cd;
             EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.subline_name := '';
         END;


        begin
          SELECT PERIL_NAME
           INTO v_list.PERIL_NAME
           FROM GIIS_PERIL
          WHERE line_cd = v_list.line_cd
            AND peril_cd = v_list.peril_cd;
            EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.PERIL_NAME := '';
        end;
        
        v_list.net_amt := (v_list.prem_amt + v_list.ri_prem_vat) -  (v_list.comm_amt + v_list.ri_comm_vat - v_list.ri_wholding_vat);
        
        BEGIN
           SELECT 'X'
             INTO v_list.v_subreport
             FROM TABLE (giacb003s_pkg.get_giacb003s_gl_account (p_date, p_user_id))
            WHERE ROWNUM = 1;
        EXCEPTION
           WHEN TOO_MANY_ROWS
           THEN
              v_list.v_subreport := 'X';
           WHEN NO_DATA_FOUND
           THEN
              v_list.v_subreport := '';
        END;           
                         
         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_list);
      END LOOP;
      
      IF v_flag = FALSE
      THEN
         PIPE ROW (v_list);
      END IF;
   END get_giacb003s_record;

   FUNCTION get_giacb003s_gl_account (p_date VARCHAR2, p_user_id VARCHAR2)
      RETURN giacb003s_gl_account_tab PIPELINED
   AS
      v_rec         giacb003s_gl_account_type;
      v_not_exist   BOOLEAN                   := FALSE;
      v_date        VARCHAR2 (100);
   BEGIN
   
      v_date := TO_CHAR (LAST_DAY (TO_DATE (p_date, 'MM-DD-RRRR')), 'MM-DD-RRRR');
      v_rec.cf_company_name := giisp.v ('COMPANY_NAME');
      v_rec.cf_company_address := giisp.v ('COMPANY_ADDRESS');
      v_rec.top_date :=
            'For the Month of '
         || TO_CHAR (TO_DATE (v_date, 'mm/dd/yyyy'), 'fmMONTH yyyy');
      v_rec.v_flag := 'N';

      FOR i IN (SELECT      LTRIM (TO_CHAR (b.gl_acct_category))
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
                                                                   gl_acct_no,
                         b.gl_acct_name acct_name, SUM (a.debit_amt) debit,
                         SUM (a.credit_amt) credit
                    FROM giac_acctrans c,
                         giac_chart_of_accts b,
                         giac_acct_entries a
                   WHERE c.tran_id = a.gacc_tran_id
                     AND b.gl_acct_id = a.gl_acct_id
                     AND c.tran_class = 'OF'
                     AND c.tran_flag = 'P'
                     AND check_user_per_iss_cd_acctg2 (NULL,
                                                       c.gibr_branch_cd,
                                                       'GIARPR001',
                                                       p_user_id
                                                      ) = 1
                     AND c.tran_month =
                            TO_NUMBER (TO_CHAR (TO_DATE (v_date, 'MM/DD/YYYY'),
                                                'MM'
                                               )
                                      )
                     AND c.tran_year =
                            TO_NUMBER (TO_CHAR (TO_DATE (v_date, 'MM/DD/YYYY'),
                                                'YYYY'
                                               )
                                      )
                GROUP BY b.gl_acct_name,
                            LTRIM (TO_CHAR (b.gl_acct_category))
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
                ORDER BY b.gl_acct_name)
      LOOP
         v_not_exist := TRUE;
         v_rec.v_flag := 'Y';
         v_rec.gl_acct_no := i.gl_acct_no;
         v_rec.acct_name := i.acct_name;
         v_rec.debit := i.debit;
         v_rec.credit := i.credit;
         PIPE ROW (v_rec);
      END LOOP;

--      IF v_not_exist = FALSE
--      THEN
--         PIPE ROW (v_rec);
--      END IF;
   END get_giacb003s_gl_account;
END GIACB003S_PKG;
/


