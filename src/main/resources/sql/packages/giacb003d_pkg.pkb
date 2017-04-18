CREATE OR REPLACE PACKAGE BODY CPI.GIACB003D_PKG
AS
/*
   ** Created by : Kenneth Labrador
   ** Date Created : 10.16.2013
   ** Reference By : GIACB003D
   ** Description : Outward Facultative Cessions (Detail)
   */
   FUNCTION get_giacb003d_record (p_date VARCHAR2, p_user_id VARCHAR2)
      RETURN giacb003d_record_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      c          cur_typ;
      v_list     giacb003d_record_type;
      v_flag     BOOLEAN               := FALSE;
      v_select   VARCHAR2 (15000);
      v_where2   VARCHAR2 (5000);
      v_where    VARCHAR2 (5000);
      v_policy    VARCHAR2 (100);
      v_date       VARCHAR2 (50);
   BEGIN
      v_date := TO_CHAR(LAST_DAY(TO_DATE(p_date, 'MM-DD-RRRR')), 'MM-DD-RRRR');
      
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
            'SELECT   distinct g.line_cd LINE, get_policy_no (g.policy_id) POLICY_NUMBER,
            g.line_cd
         || ''-''
         || TO_CHAR (a.frps_yy)
         || ''-''
         || TO_CHAR (a.frps_seq_no)
         || ''-''
         || TO_CHAR (a.ri_seq_no) FRPS_NO,
            g.line_cd
         || ''-''
         || TO_CHAR (c.binder_yy)
         || ''-''
         || TO_CHAR (c.binder_seq_no) GROUP_NO,
         k.ri_name RI_NAME, f.dist_no DIST_NO,
         e.dist_seq_no DIST_SEQ_NO, a.ri_cd RI_CD,
         g.policy_id POLICY_ID, g.subline_cd SUBLINE_CD,
         m.assd_no assd_no
                    FROM giri_frperil a,
                         giri_frps_ri b,
                         giri_binder c,
                         giri_distfrps d,
                         giuw_policyds e,
                         giuw_pol_dist f,
                         gipi_polbasic g,
                         giis_line i,
                         giis_subline j,
                         giis_reinsurer k,
                         giis_peril l,
                         gipi_parlist m
                   WHERE a.line_cd = b.line_cd
                     AND a.line_cd = l.line_cd
                     AND a.peril_cd = l.peril_cd
                     AND g.par_id = m.par_id
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
         || ''', ''MM-DD-YYYY'') '
         || v_where2
         || ' AND g.line_cd = i.line_cd
                     AND g.line_cd = j.line_cd
                     AND g.subline_cd = j.subline_cd
                     AND g.reg_policy_sw =  ''Y''
                     AND check_user_per_iss_cd_acctg2 (NULL,
                                                       NVL (g.cred_branch,
                                                            c.iss_cd
                                                           ), ''GIARPR001'', '''
         || p_user_id
         || ''') = 1
                GROUP BY g.line_cd,
                         g.policy_id,
                         a.frps_yy,
                         a.frps_seq_no,
                         a.ri_seq_no,
                         c.binder_yy,
                         c.binder_seq_no,
                         k.ri_name,
                         f.dist_no,
                         e.dist_seq_no,
                         a.ri_cd,
                         a.peril_cd,
                         l.peril_type,
                         g.subline_cd,
                         m.assd_no,
                         l.peril_type,
                         d.currency_rt
                UNION
                SELECT   distinct g.line_cd LINE, get_policy_no (g.policy_id) POLICY_NUMBER,
            g.line_cd
         || ''-''
         || TO_CHAR (a.frps_yy)
         || ''-''
         || TO_CHAR (a.frps_seq_no)
         || ''-''
         || TO_CHAR (a.ri_seq_no) FRPS_NO,
            g.line_cd
         || ''-''
         || TO_CHAR (c.binder_yy)
         || ''-''
         || TO_CHAR (c.binder_seq_no) GROUP_NO,
         k.ri_name RI_NAME, f.dist_no DIST_NO,
         e.dist_seq_no DIST_SEQ_NO, a.ri_cd RI_CD,
         g.policy_id POLICY_ID, g.subline_cd SUBLINE_CD,
         m.assd_no assd_no
                    FROM giri_frperil a,
                         giri_frps_ri b,
                         giri_binder c,
                         giri_distfrps d,
                         giuw_policyds e,
                         giuw_pol_dist f,
                         gipi_polbasic g,
                         giis_line i,
                         giis_subline j,
                         giis_reinsurer k,
                         giis_peril l,
                         gipi_parlist m
                   WHERE a.line_cd = b.line_cd
                     AND a.line_cd = l.line_cd
                     AND a.peril_cd = l.peril_cd
                     AND g.par_id = m.par_id
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
         || ''', ''MM-DD-YYYY'') '
         || v_where
         || ' AND g.line_cd = i.line_cd
                     AND g.line_cd = j.line_cd
                     AND g.subline_cd = j.subline_cd
                     AND g.reg_policy_sw = ''Y''
                     AND check_user_per_iss_cd_acctg2 (NULL,
                                                       NVL (g.cred_branch,
                                                            c.iss_cd
                                                           ),
                                                       ''GIARPR001'','''
         || p_user_id
         || ''') = 1
                GROUP BY g.line_cd,
                         g.policy_id,
                         a.frps_yy,
                         a.frps_seq_no,
                         a.ri_seq_no,
                         c.binder_yy,
                         c.binder_seq_no,
                         k.ri_name,
                         f.dist_no,
                         e.dist_seq_no,
                         a.ri_cd,
                         a.peril_cd,
                         l.peril_type,
                         g.subline_cd,
                         m.assd_no,
                         l.peril_type,
                         d.currency_rt';

      OPEN c FOR v_select;

      LOOP
         FETCH c
          INTO v_list.line_cd, v_list.policy_number, v_list.frps_no,
               v_list.group_no, v_list.ri_name, v_list.dist_no,
               v_list.dist_seq_no, v_list.ri_cd, v_list.policy_id,
               v_list.subline_cd, v_list.assd_no;

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
               v_list.line_name := 'XXXXXX';
         END;

         BEGIN
            SELECT subline_name
              INTO v_list.subline_name
              FROM giis_subline
             WHERE line_cd = v_list.line_cd AND subline_cd = v_list.subline_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.subline_name := 'XXXXXX';
         END;

         BEGIN
            SELECT assd_name
              INTO v_list.assured
              FROM giis_assured
             WHERE assd_no = v_list.assd_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.assured := 'XXXXXX X. XXXXXXXXX';
         END;
         
         if v_list.policy_id = v_policy
         then
            v_list.assured := '';
         end if;
         
        v_policy := v_list.policy_id;
      
      
         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_list);
      END LOOP;

      IF v_flag = FALSE
      THEN
         PIPE ROW (v_list);
      END IF;
   END get_giacb003d_record;
   
    FUNCTION get_giacb003d_peril (p_date VARCHAR2, p_user_id VARCHAR2)
      RETURN giacb003d_record_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      c          cur_typ;
      v_list     giacb003d_record_type;
      v_flag     BOOLEAN               := FALSE;
      v_select   VARCHAR2 (15000);
      v_where2   VARCHAR2 (5000);
      v_where    VARCHAR2 (5000);
       v_date    VARCHAR2 (50);
   BEGIN
   
   v_date := TO_CHAR(LAST_DAY(TO_DATE(p_date, 'MM-DD-RRRR')), 'MM-DD-RRRR');
   
   
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
            'SELECT   g.line_cd LINE,
                         get_policy_no (g.policy_id) POLICY_NUMBER,
                            g.line_cd
                         || ''-''
                         || TO_CHAR (a.frps_yy)
                         || ''-''
                         || TO_CHAR (a.frps_seq_no)
                         || ''-''
                         || TO_CHAR (a.ri_seq_no) FRPS_NO,
                            g.line_cd
                         || ''-''
                         || TO_CHAR (c.binder_yy)
                         || ''-''
                         || TO_CHAR (c.binder_seq_no) GROUP_NO,
                         k.ri_name RI_NAME, f.dist_no DIST_NO,
                         e.dist_seq_no DIST_SEQ_NO, a.ri_cd RI_CD,
                         a.peril_cd PERIL_CD,
                         SUM (a.ri_prem_amt * d.currency_rt) PREM_AMT,
                         SUM (a.ri_comm_amt * d.currency_rt) COMM_AMT,
                         SUM (a.ri_tsi_amt)
                         * NVL (d.currency_rt, 0) TSI_AMT,
                         (  SUM (DECODE (l.peril_type, ''B'', a.ri_tsi_amt, 0))
                          * NVL (d.currency_rt, 1)
                         ) BASICTSI_AMT,
                         (  (  SUM (a.ri_prem_amt * d.currency_rt)
                             + SUM (NVL (a.ri_prem_vat, 0) * d.currency_rt)
                            )
                          - (  SUM (NVL (a.ri_comm_amt, 0) * d.currency_rt)
                             + SUM (NVL (a.ri_comm_vat, 0) * d.currency_rt)
                             - SUM (NVL (a.ri_wholding_vat, 0) * d.currency_rt)
                            )
                         ) NET_AMT,
                         g.policy_id POLICY_ID, g.subline_cd SUBLINE_CD,
                         m.assd_no assd_no, l.peril_type,
                         SUM (NVL (a.ri_prem_vat, 0) * d.currency_rt
                             ) ri_prem_vat,
                         SUM (NVL (a.ri_comm_vat, 0) * d.currency_rt
                             ) ri_comm_vat,
                         SUM (NVL (a.ri_wholding_vat, 0) * d.currency_rt
                             ) ri_wholding_vat
                    FROM giri_frperil a,
                         giri_frps_ri b,
                         giri_binder c,
                         giri_distfrps d,
                         giuw_policyds e,
                         giuw_pol_dist f,
                         gipi_polbasic g,
                         giis_line i,
                         giis_subline j,
                         giis_reinsurer k,
                         giis_peril l,
                         gipi_parlist m
                   WHERE a.line_cd = b.line_cd
                     AND a.line_cd = l.line_cd
                     AND a.peril_cd = l.peril_cd
                     AND g.par_id = m.par_id
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
         || ''', ''MM-DD-YYYY'') '
         || v_where2
         || ' AND g.line_cd = i.line_cd
                     AND g.line_cd = j.line_cd
                     AND g.subline_cd = j.subline_cd
                     AND g.reg_policy_sw =  ''Y''
                     AND check_user_per_iss_cd_acctg2 (NULL,
                                                       NVL (g.cred_branch,
                                                            c.iss_cd
                                                           ), ''GIARPR001'', '''
         || p_user_id
         || ''') = 1
                GROUP BY g.line_cd,
                         g.policy_id,
                         a.frps_yy,
                         a.frps_seq_no,
                         a.ri_seq_no,
                         c.binder_yy,
                         c.binder_seq_no,
                         k.ri_name,
                         f.dist_no,
                         e.dist_seq_no,
                         a.ri_cd,
                         a.peril_cd,
                         l.peril_type,
                         g.subline_cd,
                         m.assd_no,
                         l.peril_type,
                         d.currency_rt
                UNION
                SELECT   g.line_cd LINE,
                         get_policy_no (g.policy_id) POLICY_NUMBER,
                            g.line_cd
                         || ''-''
                         || TO_CHAR (a.frps_yy)
                         || ''-''
                         || TO_CHAR (a.frps_seq_no)
                         || ''-''
                         || TO_CHAR (a.ri_seq_no) FRPS_NO,
                            g.line_cd
                         || ''-''
                         || TO_CHAR (c.binder_yy)
                         || ''-''
                         || TO_CHAR (c.binder_seq_no) GROUP_NO,
                         k.ri_name RI_NAME, f.dist_no DIST_NO,
                         e.dist_seq_no DIST_SEQ_NO, a.ri_cd RI_CD,
                         a.peril_cd PERIL_CD,
                           SUM (a.ri_prem_amt * d.currency_rt)
                         * (-1) PREM_AMT,
                           SUM (a.ri_comm_amt * d.currency_rt)
                         * (-1) COMM_AMT,
                           SUM (a.ri_tsi_amt)
                         * NVL (d.currency_rt, 0)
                         * (-1) TSI_AMT,
                           (  SUM (DECODE (l.peril_type,
                                           ''B'', a.ri_tsi_amt,
                                           0
                                          ))
                            * NVL (d.currency_rt, 1)
                           )
                         * (-1) BASICTSI_AMT,
                           (  (  SUM (a.ri_prem_amt * d.currency_rt)
                               + SUM (NVL (a.ri_prem_vat, 0) * d.currency_rt)
                              )
                            - (  SUM (NVL (a.ri_comm_amt, 0) * d.currency_rt)
                               + SUM (NVL (a.ri_comm_vat, 0) * d.currency_rt)
                               - SUM (  NVL (a.ri_wholding_vat, 0)
                                      * d.currency_rt
                                     )
                              )
                           )
                         * (-1) NET_AMT,
                         g.policy_id POLICY_ID, g.subline_cd SUBLINE_CD,
                         m.assd_no assd_no, l.peril_type,
                           SUM (NVL (a.ri_prem_vat, 0) * d.currency_rt
                               )
                         * (-1) ri_prem_vat,
                           SUM (NVL (a.ri_comm_vat, 0) * d.currency_rt
                               )
                         * (-1) ri_comm_vat,
                           SUM (NVL (a.ri_wholding_vat, 0) * d.currency_rt
                               )
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
                         giis_reinsurer k,
                         giis_peril l,
                         gipi_parlist m
                   WHERE a.line_cd = b.line_cd
                     AND a.line_cd = l.line_cd
                     AND a.peril_cd = l.peril_cd
                     AND g.par_id = m.par_id
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
         || ''', ''MM-DD-YYYY'') '
         || v_where
         || ' AND g.line_cd = i.line_cd
                     AND g.line_cd = j.line_cd
                     AND g.subline_cd = j.subline_cd
                     AND g.reg_policy_sw = ''Y''
                     AND check_user_per_iss_cd_acctg2 (NULL,
                                                       NVL (g.cred_branch,
                                                            c.iss_cd
                                                           ),
                                                       ''GIARPR001'','''
         || p_user_id
         || ''') = 1
                GROUP BY g.line_cd,
                         g.policy_id,
                         a.frps_yy,
                         a.frps_seq_no,
                         a.ri_seq_no,
                         c.binder_yy,
                         c.binder_seq_no,
                         k.ri_name,
                         f.dist_no,
                         e.dist_seq_no,
                         a.ri_cd,
                         a.peril_cd,
                         l.peril_type,
                         g.subline_cd,
                         m.assd_no,
                         l.peril_type,
                         d.currency_rt';

      OPEN c FOR v_select;

      LOOP
         FETCH c
          INTO v_list.line_cd, v_list.policy_number, v_list.frps_no,
               v_list.group_no, v_list.ri_name, v_list.dist_no,
               v_list.dist_seq_no, v_list.ri_cd, v_list.peril_cd,
               v_list.prem_amt, v_list.comm_amt, v_list.tsi_amt,
               v_list.basictsi_amt, v_list.net_amt, v_list.policy_id,
               v_list.subline_cd, v_list.assd_no, v_list.peril_type,
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
               v_list.line_name := 'XXXXXX';
         END;

         BEGIN
            SELECT subline_name
              INTO v_list.subline_name
              FROM giis_subline
             WHERE line_cd = v_list.line_cd AND subline_cd = v_list.subline_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.subline_name := 'XXXXXX';
         END;

         BEGIN
            SELECT assd_name
              INTO v_list.assured
              FROM giis_assured
             WHERE assd_no = v_list.assd_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.assured := 'XXXXXX X. XXXXXXXXX';
         END;

         BEGIN
            BEGIN
               SELECT DECODE (peril_type, 'B', peril_name || '*', peril_name)
                 INTO v_list.peril_name
                 FROM giis_peril
                WHERE peril_cd = v_list.peril_cd AND line_cd = v_list.line_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_list.peril_name := '***';
            END;
         END;

         
         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_list);
      END LOOP;

      IF v_flag = FALSE
      THEN
         PIPE ROW (v_list);
      END IF;
   END get_giacb003d_peril;
END GIACB003D_PKG;
/


