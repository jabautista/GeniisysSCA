CREATE OR REPLACE PACKAGE BODY CPI.giacr290_pkg
AS
   FUNCTION get_giacr290_rowcount_func (
      p_report_type   VARCHAR2,
      p_rowno1        NUMBER,
      p_rowtitle1     VARCHAR2
   )
      RETURN NUMBER
   IS
      v_r1_count   NUMBER;
      v_r2_count   NUMBER;
      v_r5_count   NUMBER;
   BEGIN
      FOR c IN (SELECT total, total_losspd, total_osloss
                  FROM giac_recap_count
                 WHERE rowno = p_rowno1 AND rowtitle = p_rowtitle1)
      LOOP
         v_r1_count := c.total;
         v_r2_count := c.total_losspd;
         v_r5_count := c.total_osloss;
      END LOOP;

      IF p_report_type = 'PREMIUM'
      THEN
         RETURN (v_r1_count);
      ELSIF p_report_type = 'LOSSPD'
      THEN
         RETURN (v_r2_count);
      ELSIF p_report_type = 'OSLOSS'
      THEN
         RETURN (v_r5_count);
      ELSE
         RETURN (NULL);
      END IF;

      RETURN NULL;
   END get_giacr290_rowcount_func;

   FUNCTION get_giacr290_ctpl_count_func (
      p_report_type   VARCHAR2,
      p_rowno1        NUMBER,
      p_rowtitle1     VARCHAR2
   )
      RETURN NUMBER
   IS
      v_r1_ctpl_count   NUMBER;
   BEGIN
      IF p_report_type = 'PREMIUM'
      THEN
         BEGIN
            SELECT COUNT (*)
              INTO v_r1_ctpl_count
              FROM giac_recap_summ_ext
             WHERE rowno = p_rowno1
               AND rowtitle = p_rowtitle1
               AND line_cd = 'MC'
               AND peril_cd = giisp.n ('CTPL');
         END;

         IF v_r1_ctpl_count <> 0
         THEN
            RETURN (v_r1_ctpl_count);
         ELSE
            RETURN (NULL);
         END IF;
      END IF;

      RETURN NULL;
   END get_giacr290_ctpl_count_func;

   FUNCTION get_giacr290_records (p_report_type VARCHAR2)
      RETURN giacr290_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      v_list               giacr290_type;
      v_not_exist          BOOLEAN          := TRUE;
      c                    cur_typ;
      d                    cur_typ;
      rowtitle             VARCHAR2 (50);
      rowno                NUMBER;
      v_select             VARCHAR2 (2000);
      v_inner_select       VARCHAR2 (32000);
      p_assumed_title      VARCHAR2 (500);
      p_ceded_asean        VARCHAR2 (500);
      p_ceded_auth         VARCHAR2 (500);
      p_ceded_oth          VARCHAR2 (500);
      p_cedgroup_title     VARCHAR2 (500);
      p_co_name            VARCHAR2 (500);
      p_date1              VARCHAR2 (500);
      p_date2              VARCHAR2 (500);
      p_direct             VARCHAR2 (500);
      p_direct_title       VARCHAR2 (500);
      p_dtl_table          VARCHAR2 (500);
      p_inw_asean          VARCHAR2 (500);
      p_inw_auth           VARCHAR2 (500);
      p_inw_oth            VARCHAR2 (500);
      p_netdirect_title    VARCHAR2 (500);
      p_netwritten_title   VARCHAR2 (500);
      p_rep_title          VARCHAR2 (500);
      p_retced_asean       VARCHAR2 (500);
      p_retced_auth        VARCHAR2 (500);
      p_retced_oth         VARCHAR2 (500);
      p_retroced_title     VARCHAR2 (500);
      p_subtitle           VARCHAR2 (500);
      p_where              VARCHAR2 (32000);
      p_where2             VARCHAR2 (32000);
      v_r1_count           NUMBER;
      v_r2_count           NUMBER;
      v_r3_count           NUMBER;
      
      --mikel 03.30.2016
      v_curr_year_select   VARCHAR2 (32000); 
      v_prev_year_select   VARCHAR2 (32000); 
      e                    cur_typ;
      f                    cur_typ; 
      
   BEGIN
      giacr290_pkg.pop_dynamic_obj (p_report_type,
                                     p_assumed_title,
                                     p_ceded_asean,
                                     p_ceded_auth,
                                     p_ceded_oth,
                                     p_cedgroup_title,
                                     p_co_name,
                                     p_date1,
                                     p_date2,
                                     p_direct,
                                     p_direct_title,
                                     p_dtl_table,
                                     p_inw_asean,
                                     p_inw_auth,
                                     p_inw_oth,
                                     p_netdirect_title,
                                     p_netwritten_title,
                                     p_rep_title,
                                     p_retced_asean,
                                     p_retced_auth,
                                     p_retced_oth,
                                     p_retroced_title,
                                     p_subtitle,
                                     p_where
                                    );
      p_dtl_table := NVL (p_dtl_table, 'giac_recap_summ_ext');
      p_direct := NVL (p_direct, 'direct_prem');
      p_ceded_auth := NVL (p_ceded_auth, 'ceded_prem_auth');
      p_ceded_asean := NVL (p_ceded_asean, 'ceded_prem_asean');
      p_ceded_oth := NVL (p_ceded_oth, 'ceded_prem_oth');
      p_inw_auth := NVL (p_inw_auth, 'inw_prem_auth');
      p_inw_asean := NVL (p_inw_asean, 'inw_prem_asean');
      p_inw_oth := NVL (p_inw_oth, 'inw_prem_oth');
      p_retced_auth := NVL (p_retced_auth, 'retceded_prem_auth');
      p_retced_asean := NVL (p_retced_asean, 'retceded_prem_asean');
      p_retced_oth := NVL (p_retced_oth, 'retceded_prem_oth');
      v_select :=
            'SELECT DISTINCT rowtitle, rowno
                           FROM giac_recap_row a
                UNION
                SELECT DISTINCT rowtitle, rowno
                           FROM '
         || p_dtl_table
         || ' UNION 
         --added by mikel 05.02.2013 
         SELECT DISTINCT b.rowtitle, a.rowno + b.rowno rowno 
           FROM giac_recap_row a, giac_recap_other_rows_mc b 
          WHERE a.line_cd = b.line_cd 
            AND TRUNC (a.rowno) IN (23, 28) 
            AND TRUNC (a.rowno) - a.rowno <> 0 
            AND b.peril_cd != giisp.n (''CTPL'')' --mikel 03.26.2015
         || ' ORDER BY rowno';

      --raise_application_error (-20001,'v_select='||v_select);
      OPEN c FOR v_select;

      LOOP
         FETCH c
          INTO v_list.rowtitle, v_list.rowno;

         v_not_exist := FALSE;
         p_where := NULL;
         p_where2 := NULL;
         
         --marco - added condition for inner select statement
         IF v_list.rowno IS NOT NULL THEN 
            p_where := ' WHERE rowno = ' || v_list.rowno;
         END IF;

         IF p_where = '' OR p_where IS NULL
         THEN
            p_where2 := ' WHERE rowtitle = ''' || v_list.rowtitle || '''';
         ELSE
            p_where2 := ' AND rowtitle = ''' || v_list.rowtitle || '''';
         END IF;

         v_inner_select :=
               'SELECT (rowtitle) AS rowtitle1, (rowno) AS rowno1,
               SUM('
            || p_direct
            || ') AS direct_col, 
        SUM('
            || p_ceded_auth
            || ')AS ceded_auth,
        SUM('
            || p_ceded_asean
            || ') AS ceded_asean, 
        SUM('
            || p_ceded_oth
            || ') AS ceded_oth, 
        ( SUM('
            || p_direct
            || ') - SUM('
            || p_ceded_auth
            || ')  -  SUM('
            || p_ceded_asean
            || ') -  SUM('
            || p_ceded_oth
            || ' ))AS net_direct, 
        SUM('
            || p_inw_auth
            || ') AS inw_auth, 
        SUM('
            || p_inw_asean
            || ') AS inw_asean, 
        SUM('
            || p_inw_oth
            || ') AS inw_oth, 
       	SUM('
            || p_retced_auth
            || ') AS retced_auth, 	
        SUM('
            || p_retced_asean
            || ') AS retced_asean, SUM('
            || p_retced_oth
            || ') AS retced_oth,   
         (SUM('
            || p_direct
            || ') - SUM('
            || p_ceded_auth
            || ') - SUM('
            || p_ceded_asean
            || ') - SUM('
            || p_ceded_oth
            || ') +
                      SUM('
            || p_inw_auth
            || ') + SUM('
            || p_inw_asean
            || ') + SUM('
            || p_inw_oth
            || ') - SUM('
            || p_retced_auth
            || ') - 
	      SUM('
            || p_retced_asean
            || ') - SUM('
            || p_retced_oth
            || ')) AS net_written
           FROM '
            || p_dtl_table
            || ' '
            || p_where
            || p_where2
            || ' group by rowtitle, rowno';
         v_list.rowtitle1 := NULL;
         v_list.rowno1 := NULL;
         v_list.direct_col := NULL;
         v_list.ceded_auth := NULL;
         v_list.ceded_asean := NULL;
         v_list.ceded_oth := NULL;
         v_list.net_direct := NULL;
         v_list.inw_auth := NULL;
         v_list.inw_asean := NULL;
         v_list.inw_oth := NULL;
         v_list.retced_auth := NULL;
         v_list.retced_asean := NULL;
         v_list.retced_oth := NULL;
         v_list.net_written := 0; --mikel 04.01.2016; change from NULL to zero

         OPEN d FOR v_inner_select;

         LOOP
            FETCH d
             INTO v_list.rowtitle1, v_list.rowno1, v_list.direct_col,
                  v_list.ceded_auth, v_list.ceded_asean, v_list.ceded_oth,
                  v_list.net_direct, v_list.inw_auth, v_list.inw_asean,
                  v_list.inw_oth, v_list.retced_auth, v_list.retced_asean,
                  v_list.retced_oth, v_list.net_written;

            v_list.rowcount_func :=
               get_giacr290_rowcount_func (p_report_type,
                                           v_list.rowno1,
                                           v_list.rowtitle1
                                          );
            v_list.ctpl_count_func :=
               get_giacr290_ctpl_count_func (p_report_type,
                                             v_list.rowno1,
                                             v_list.rowtitle1
                                            );
                                                    
            EXIT WHEN d%NOTFOUND;
         END LOOP;
         
        /*added by mikel 03.30.2016
        ** to select unearned premiums for previous and current year 
        */ 
        IF p_report_type = 'PREMIUM' THEN    
            v_list.curr_def_prem_amt := 0;                                          
            v_curr_year_select :=
               'SELECT 
                       SUM('
                    ||'def_prem_amt'
                    || ') AS def_prem_amt
                  FROM '
                    || 'giac_recap_curr_summ_ext'
                    || ' '
                    || p_where
                    || p_where2
                    || ' group by rowtitle, rowno';
                  
             OPEN e FOR v_curr_year_select;
             LOOP
                FETCH e
                INTO v_list.curr_def_prem_amt;     
                EXIT WHEN e%NOTFOUND;
             END LOOP;
             
            v_list.prev_def_prem_amt := 0;                                          
            v_prev_year_select :=
               'SELECT 
                       SUM('
                    ||'def_prem_amt'
                    || ') AS def_prem_amt
                  FROM '
                    || 'giac_recap_prior_summ_ext'
                    || ' '
                    || p_where
                    || p_where2
                    || ' group by rowtitle, rowno';
                  
             OPEN f FOR v_prev_year_select;
             LOOP
                FETCH f
                INTO v_list.prev_def_prem_amt;     
                EXIT WHEN f%NOTFOUND;
             END LOOP;
             
             v_list.earned_premiums := v_list.net_written + v_list.prev_def_prem_amt - v_list.curr_def_prem_amt;
        END IF;
        --end mikel 03.30.2016    

         EXIT WHEN c%NOTFOUND;
         --
         v_list.cp_ceded_auth_ft := 0;
         v_list.cp_ceded_asean_ft := 0;
         v_list.cp_ceded_oth_ft := 0;
         v_list.cp_inw_auth_ft := 0;
         v_list.cp_inw_asean_ft := 0;
         v_list.cp_inw_oth_ft := 0;
         v_list.cp_retced_auth_ft := 0;
         v_list.cp_retced_asean_ft := 0;
         v_list.cp_retced_oth_ft := 0;
         v_list.cp_direct_col_ft := 0;
         v_list.cp_net_direct_ft := 0;
         v_list.cp_net_written_ft := 0;
         v_list.cp_rowcount_ft := 0;
         v_list.cp_ctplcount_ft := 0;
         v_list.cp_ceded_auth_fp := 0;
         v_list.cp_ceded_asean_fp := 0;
         v_list.cp_ceded_oth_fp := 0;
         v_list.cp_inw_auth_fp := 0;
         v_list.cp_inw_asean_fp := 0;
         v_list.cp_inw_oth_fp := 0;
         v_list.cp_retced_auth_fp := 0;
         v_list.cp_retced_asean_fp := 0;
         v_list.cp_retced_oth_fp := 0;
         v_list.cp_direct_col_fp := 0;
         v_list.cp_net_direct_fp := 0;
         v_list.cp_net_written_fp := 0;
         v_list.cp_rowcount_fp := 0;
         v_list.cp_ctplcount_fp := 0;
         v_list.cp_ceded_auth_su := 0;
         v_list.cp_ceded_asean_su := 0;
         v_list.cp_ceded_oth_su := 0;
         v_list.cp_inw_auth_su := 0;
         v_list.cp_inw_asean_su := 0;
         v_list.cp_inw_oth_su := 0;
         v_list.cp_retced_auth_su := 0;
         v_list.cp_retced_asean_su := 0;
         v_list.cp_retced_oth_su := 0;
         v_list.cp_direct_col_su := 0;
         v_list.cp_net_direct_su := 0;
         v_list.cp_net_written_su := 0;
         v_list.cp_rowcount_su := 0;
         v_list.cp_ctplcount_su := 0;
         v_list.cp_ceded_auth_mc := 0;
         v_list.cp_ceded_asean_mc := 0;
         v_list.cp_ceded_oth_mc := 0;
         v_list.cp_inw_auth_mc := 0;
         v_list.cp_inw_asean_mc := 0;
         v_list.cp_inw_oth_mc := 0;
         v_list.cp_retced_auth_mc := 0;
         v_list.cp_retced_asean_mc := 0;
         v_list.cp_retced_oth_mc := 0;
         v_list.cp_direct_col_mc := 0;
         v_list.cp_net_direct_mc := 0;
         v_list.cp_net_written_mc := 0;
         v_list.cp_rowcount_mc := 0;
         v_list.cp_ctplcount_mc := 0;
         v_list.cp_ceded_auth_ca := 0;
         v_list.cp_ceded_auth_mn := 0;
         v_list.cp_ceded_auth_en := 0;
         v_list.cp_ceded_auth_ac := 0;
         v_list.cp_ceded_auth_av := 0;
         v_list.cp_ceded_asean_ca := 0;
         v_list.cp_ceded_asean_mn := 0;
         v_list.cp_ceded_asean_en := 0;
         v_list.cp_ceded_asean_ac := 0;
         v_list.cp_ceded_asean_av := 0;
         v_list.cp_ceded_oth_ca := 0;
         v_list.cp_ceded_oth_mn := 0;
         v_list.cp_ceded_oth_en := 0;
         v_list.cp_ceded_oth_ac := 0;
         v_list.cp_ceded_oth_av := 0;
         v_list.cp_inw_auth_ca := 0;
         v_list.cp_inw_auth_mn := 0;
         v_list.cp_inw_auth_en := 0;
         v_list.cp_inw_auth_ac := 0;
         v_list.cp_inw_auth_av := 0;
         v_list.cp_inw_asean_ca := 0;
         v_list.cp_inw_asean_mn := 0;
         v_list.cp_inw_asean_en := 0;
         v_list.cp_inw_asean_ac := 0;
         v_list.cp_inw_asean_av := 0;
         v_list.cp_inw_oth_ca := 0;
         v_list.cp_inw_oth_mn := 0;
         v_list.cp_inw_oth_en := 0;
         v_list.cp_inw_oth_ac := 0;
         v_list.cp_inw_oth_av := 0;
         v_list.cp_retced_auth_ca := 0;
         v_list.cp_retced_auth_mn := 0;
         v_list.cp_retced_auth_en := 0;
         v_list.cp_retced_auth_ac := 0;
         v_list.cp_retced_auth_av := 0;
         v_list.cp_retced_asean_ca := 0;
         v_list.cp_retced_asean_mn := 0;
         v_list.cp_retced_asean_ac := 0;
         v_list.cp_retced_asean_en := 0;
         v_list.cp_retced_asean_av := 0;
         v_list.cp_retced_oth_ca := 0;
         v_list.cp_retced_oth_mn := 0;
         v_list.cp_retced_oth_en := 0;
         v_list.cp_retced_oth_ac := 0;
         v_list.cp_retced_oth_av := 0;
         v_list.cp_direct_col_ca := 0;
         v_list.cp_direct_col_mn := 0;
         v_list.cp_direct_col_en := 0;
         v_list.cp_direct_col_av := 0;
         v_list.cp_direct_col_ac := 0;
         v_list.cp_net_direct_ca := 0;
         v_list.cp_net_direct_mn := 0;
         v_list.cp_net_direct_en := 0;
         v_list.cp_net_direct_ac := 0;
         v_list.cp_net_direct_av := 0;
         v_list.cp_net_written_ca := 0;
         v_list.cp_net_written_mn := 0;
         v_list.cp_net_written_en := 0;
         v_list.cp_net_written_ac := 0;
         v_list.cp_net_written_av := 0;
         v_list.cp_rowcount_ca := 0;
         v_list.cp_rowcount_mn := 0;
         v_list.cp_rowcount_en := 0;
         v_list.cp_rowcount_ac := 0;
         v_list.cp_rowcount_av := 0;
         v_list.cp_ctplcount_ca := 0;
         v_list.cp_ctplcount_mn := 0;
         v_list.cp_ctplcount_en := 0;
         v_list.cp_ctplcount_ac := 0;
         v_list.cp_ctplcount_av := 0;
         
         --mikel 04.06.2016
         v_list.cp_prev_prem_ft     := 0;
         v_list.cp_curr_prem_ft     := 0;
         v_list.cp_earned_prem_ft   := 0;
         v_list.cp_prev_prem_fp     := 0;
         v_list.cp_curr_prem_fp     := 0;
         v_list.cp_earned_prem_fp   := 0;
         v_list.cp_prev_prem_su     := 0;
         v_list.cp_curr_prem_su     := 0;
         v_list.cp_earned_prem_su   := 0;
         v_list.cp_prev_prem_mc     := 0;
         v_list.cp_curr_prem_mc     := 0;
         v_list.cp_earned_prem_mc   := 0;
         v_list.cp_prev_prem_ca     := 0;
         v_list.cp_curr_prem_ca     := 0;
         v_list.cp_earned_prem_ca   := 0;
         v_list.cp_prev_prem_mn     := 0;
         v_list.cp_curr_prem_mn     := 0;
         v_list.cp_earned_prem_mn   := 0;
         v_list.cp_prev_prem_en     := 0;
         v_list.cp_curr_prem_en     := 0;
         v_list.cp_earned_prem_en   := 0;
         v_list.cp_prev_prem_ac     := 0;
         v_list.cp_curr_prem_ac     := 0;
         v_list.cp_earned_prem_ac   := 0;
         v_list.cp_prev_prem_av     := 0;
         v_list.cp_curr_prem_av     := 0;
         v_list.cp_earned_prem_av   := 0;
         --end mikel 04.06.2016

         IF v_list.rowno IN (1, 2, 3, 4)
         THEN                                                    --fire tariff
            v_list.cp_ceded_auth_ft := v_list.ceded_auth;
            v_list.cp_ceded_asean_ft := v_list.ceded_asean;
            v_list.cp_ceded_oth_ft := v_list.ceded_oth;
            v_list.cp_inw_auth_ft := v_list.inw_auth;
            v_list.cp_inw_asean_ft := v_list.inw_asean;
            v_list.cp_inw_oth_ft := v_list.inw_oth;
            v_list.cp_retced_auth_ft := v_list.retced_auth;
            v_list.cp_retced_asean_ft := v_list.retced_asean;
            v_list.cp_retced_oth_ft := v_list.retced_oth;
            v_list.cp_direct_col_ft := v_list.direct_col;
            v_list.cp_net_direct_ft := v_list.net_direct;
            v_list.cp_net_written_ft := v_list.net_written;
            v_list.cp_rowcount_ft := v_list.rowcount_func;     --cf_rowcount;
            v_list.cp_ctplcount_ft := v_list.ctpl_count_func;
            
            --mikel 04.06.2016
            v_list.cp_prev_prem_ft := v_list.prev_def_prem_amt;
            v_list.cp_curr_prem_ft := v_list.curr_def_prem_amt;
            v_list.cp_earned_prem_ft := v_list.earned_premiums;
         ELSIF v_list.rowno1 IN (5, 6, 7, 8)
         THEN                                             --fire special risks
            v_list.cp_ceded_auth_fp := v_list.ceded_auth;
            v_list.cp_ceded_asean_fp := v_list.ceded_asean;
            v_list.cp_ceded_oth_fp := v_list.ceded_oth;
            v_list.cp_inw_auth_fp := v_list.inw_auth;
            v_list.cp_inw_asean_fp := v_list.inw_asean;
            v_list.cp_inw_oth_fp := v_list.inw_oth;
            v_list.cp_retced_auth_fp := v_list.retced_auth;
            v_list.cp_retced_asean_fp := v_list.retced_asean;
            v_list.cp_retced_oth_fp := v_list.retced_oth;
            v_list.cp_direct_col_fp := v_list.direct_col;
            v_list.cp_net_direct_fp := v_list.net_direct;
            v_list.cp_net_written_fp := v_list.net_written;
            v_list.cp_rowcount_fp := v_list.rowcount_func;
            v_list.cp_ctplcount_fp := v_list.ctpl_count_func;
            
            --mikel 04.06.2016
            v_list.cp_prev_prem_fp := v_list.prev_def_prem_amt;
            v_list.cp_curr_prem_fp := v_list.curr_def_prem_amt;
            v_list.cp_earned_prem_fp := v_list.earned_premiums;
         ELSIF v_list.rowno IN (9, 10)
         THEN                               -- marine      --gracey 04.01.2005
            v_list.cp_rowcount_mn := v_list.rowcount_func;
            v_list.cp_ctplcount_mn := v_list.ctpl_count_func;
            v_list.cp_direct_col_mn := v_list.direct_col;
            v_list.cp_ceded_auth_mn := v_list.ceded_auth;
            v_list.cp_ceded_asean_mn := v_list.ceded_asean;
            v_list.cp_ceded_oth_mn := v_list.ceded_oth;
            v_list.cp_inw_auth_mn := v_list.inw_auth;
            v_list.cp_inw_asean_mn := v_list.inw_asean;
            v_list.cp_inw_oth_mn := v_list.inw_oth;
            v_list.cp_retced_auth_mn := v_list.retced_auth;
            v_list.cp_retced_asean_mn := v_list.retced_asean;
            v_list.cp_retced_oth_mn := v_list.retced_oth;
            v_list.cp_net_written_mn := v_list.net_written;
            v_list.cp_net_direct_mn := v_list.net_direct;
            
            --mikel 04.06.2016
            v_list.cp_prev_prem_mn := v_list.prev_def_prem_amt;
            v_list.cp_curr_prem_mn := v_list.curr_def_prem_amt;
            v_list.cp_earned_prem_mn := v_list.earned_premiums;
         ELSIF v_list.rowno = 11
         THEN                             -- aviation      --gracey 04.01.2005
            v_list.cp_rowcount_av := v_list.rowcount_func;
            v_list.cp_ctplcount_av := v_list.ctpl_count_func;
            v_list.cp_direct_col_av := v_list.direct_col;
            v_list.cp_ceded_auth_av := v_list.ceded_auth;
            v_list.cp_ceded_asean_av := v_list.ceded_asean;
            v_list.cp_ceded_oth_av := v_list.ceded_oth;
            v_list.cp_inw_auth_av := v_list.inw_auth;
            v_list.cp_inw_asean_av := v_list.inw_asean;
            v_list.cp_inw_oth_av := v_list.inw_oth;
            v_list.cp_retced_auth_av := v_list.retced_auth;
            v_list.cp_retced_asean_av := v_list.retced_asean;
            v_list.cp_retced_oth_av := v_list.retced_oth;
            v_list.cp_net_written_av := v_list.net_written;
            v_list.cp_net_direct_av := v_list.net_direct;
            
            --mikel 04.06.2016
            v_list.cp_prev_prem_av := v_list.prev_def_prem_amt;
            v_list.cp_curr_prem_av := v_list.curr_def_prem_amt;
            v_list.cp_earned_prem_av := v_list.earned_premiums;
         ELSIF v_list.rowno IN (29, 32, 31) --mikel 02.23.2015; changed 33 to 31
         THEN                             -- accident -- jenny vi lim 04202005
            v_list.cp_rowcount_ac := v_list.rowcount_func;
            v_list.cp_ctplcount_ac := v_list.ctpl_count_func;
            v_list.cp_direct_col_ac := v_list.direct_col;
            v_list.cp_ceded_auth_ac := v_list.ceded_auth;
            v_list.cp_ceded_asean_ac := v_list.ceded_asean;
            v_list.cp_ceded_oth_ac := v_list.ceded_oth;
            v_list.cp_inw_auth_ac := v_list.inw_auth;
            v_list.cp_inw_asean_ac := v_list.inw_asean;
            v_list.cp_inw_oth_ac := v_list.inw_oth;
            v_list.cp_retced_auth_ac := v_list.retced_auth;
            v_list.cp_retced_asean_ac := v_list.retced_asean;
            v_list.cp_retced_oth_ac := v_list.retced_oth;
            v_list.cp_net_written_ac := v_list.net_written;
            v_list.cp_net_direct_ac := v_list.net_direct;
            
            --mikel 04.06.2016
            v_list.cp_prev_prem_ac := v_list.prev_def_prem_amt;
            v_list.cp_curr_prem_ac := v_list.curr_def_prem_amt;
            v_list.cp_earned_prem_ac := v_list.earned_premiums;
         ELSIF v_list.rowno = 30
         THEN                          -- engineering      --gracey 04.01.2005
            v_list.cp_rowcount_en := v_list.rowcount_func;
            v_list.cp_ctplcount_en := v_list.ctpl_count_func;
            v_list.cp_direct_col_en := v_list.direct_col;
            v_list.cp_ceded_auth_en := v_list.ceded_auth;
            v_list.cp_ceded_asean_en := v_list.ceded_asean;
            v_list.cp_ceded_oth_en := v_list.ceded_oth;
            v_list.cp_inw_auth_en := v_list.inw_auth;
            v_list.cp_inw_asean_en := v_list.inw_asean;
            v_list.cp_inw_oth_en := v_list.inw_oth;
            v_list.cp_retced_auth_en := v_list.retced_auth;
            v_list.cp_retced_asean_en := v_list.retced_asean;
            v_list.cp_retced_oth_en := v_list.retced_oth;
            v_list.cp_net_written_en := v_list.net_written;
            v_list.cp_net_direct_en := v_list.net_direct;
            
            --mikel 04.06.2016
            v_list.cp_prev_prem_en := v_list.prev_def_prem_amt;
            v_list.cp_curr_prem_en := v_list.curr_def_prem_amt;
            v_list.cp_earned_prem_en := v_list.earned_premiums;
         ELSIF v_list.rowno IN (12, 13, 14, 15, 16)
         THEN                                                  -- bond classes
            v_list.cp_ceded_auth_su := v_list.ceded_auth;
            v_list.cp_ceded_asean_su := v_list.ceded_asean;
            v_list.cp_ceded_oth_su := v_list.ceded_oth;
            v_list.cp_inw_auth_su := v_list.inw_auth;
            v_list.cp_inw_asean_su := v_list.inw_asean;
            v_list.cp_inw_oth_su := v_list.inw_oth;
            v_list.cp_retced_auth_su := v_list.retced_auth;
            v_list.cp_retced_asean_su := v_list.retced_asean;
            v_list.cp_retced_oth_su := v_list.retced_oth;
            v_list.cp_direct_col_su := v_list.direct_col;
            v_list.cp_net_direct_su := v_list.net_direct;
            v_list.cp_net_written_su := v_list.net_written;
            v_list.cp_rowcount_su := v_list.rowcount_func;
            v_list.cp_ctplcount_su := v_list.ctpl_count_func;
            
            --mikel 04.06.2016
            v_list.cp_prev_prem_su := v_list.prev_def_prem_amt;
            v_list.cp_curr_prem_su := v_list.curr_def_prem_amt;
            v_list.cp_earned_prem_su := v_list.earned_premiums;
         ELSIF v_list.rowno >= 17 AND v_list.rowno <= 28.99 --motor car perils --mikel 05.02.2013; added .99
         THEN                                               --motor car perils
            v_list.cp_ceded_auth_mc := v_list.ceded_auth;
            v_list.cp_ceded_asean_mc := v_list.ceded_asean;
            v_list.cp_ceded_oth_mc := v_list.ceded_oth;
            v_list.cp_inw_auth_mc := v_list.inw_auth;
            v_list.cp_inw_asean_mc := v_list.inw_asean;
            v_list.cp_inw_oth_mc := v_list.inw_oth;
            v_list.cp_retced_auth_mc := v_list.retced_auth;
            v_list.cp_retced_asean_mc := v_list.retced_asean;
            v_list.cp_retced_oth_mc := v_list.retced_oth;
            v_list.cp_direct_col_mc := v_list.direct_col;
            v_list.cp_net_direct_mc := v_list.net_direct;
            v_list.cp_net_written_mc := v_list.net_written;
            v_list.cp_rowcount_mc := v_list.rowcount_func;
            v_list.cp_ctplcount_mc := v_list.ctpl_count_func;
            
            --mikel 04.06.2016
            v_list.cp_prev_prem_mc := v_list.prev_def_prem_amt;
            v_list.cp_curr_prem_mc := v_list.curr_def_prem_amt;
            v_list.cp_earned_prem_mc := v_list.earned_premiums;
         ELSE
            FOR a IN (SELECT DISTINCT o.rowtitle, o.rowno, o.line_cd
                                 FROM giac_recap_other_rows o,
                                      giac_recap_summ_ext s,
                                      giis_subline sub
                                WHERE o.line_cd = giisp.v ('LINE_CODE_CA')
                                  AND o.line_cd = s.line_cd
                                  AND s.line_cd = sub.line_cd
                                  AND sub.line_cd = o.line_cd)      --!= 'CG')
            LOOP
               IF v_list.rowno = a.rowno
               THEN
                  v_list.cp_ceded_auth_ca := v_list.ceded_auth;
                  v_list.cp_ceded_asean_ca := v_list.ceded_asean;
                  v_list.cp_ceded_oth_ca := v_list.ceded_oth;
                  v_list.cp_inw_auth_ca := v_list.inw_auth;
                  v_list.cp_inw_asean_ca := v_list.inw_asean;
                  v_list.cp_inw_oth_ca := v_list.inw_oth;
                  v_list.cp_retced_auth_ca := v_list.retced_auth;
                  v_list.cp_retced_asean_ca := v_list.retced_asean;
                  v_list.cp_retced_oth_ca := v_list.retced_oth;
                  v_list.cp_direct_col_ca := v_list.direct_col;
                  v_list.cp_net_direct_ca := v_list.net_direct;
                  v_list.cp_net_written_ca := v_list.net_written;
                  v_list.cp_rowcount_ca := v_list.rowcount_func;
                  v_list.cp_ctplcount_ca := v_list.ctpl_count_func;
                  
                  --mikel 04.06.2016
                v_list.cp_prev_prem_ca := v_list.prev_def_prem_amt;
                v_list.cp_curr_prem_ca := v_list.curr_def_prem_amt;
                v_list.cp_earned_prem_ca := v_list.earned_premiums;
               END IF;
            END LOOP;
         END IF;

         PIPE ROW (v_list);
      END LOOP;
      
      --mikel 03.30.2016
      IF p_report_type = 'PREMIUM' THEN  
          CLOSE e; 
          
          CLOSE f;
      END IF;    
      
      CLOSE d;

      CLOSE c;

      IF v_list.flag = 'T'
      THEN
         PIPE ROW (v_list);
      END IF;
   END get_giacr290_records;

   PROCEDURE pop_dynamic_obj (
      p_report_type        IN       VARCHAR,
      p_assumed_title      IN OUT   VARCHAR2,
      p_ceded_asean        IN OUT   VARCHAR2,
      p_ceded_auth         IN OUT   VARCHAR2,
      p_ceded_oth          IN OUT   VARCHAR2,
      p_cedgroup_title     IN OUT   VARCHAR2,
      p_co_name            IN OUT   VARCHAR2,
      p_date1              IN OUT   VARCHAR2,
      p_date2              IN OUT   VARCHAR2,
      p_direct             IN OUT   VARCHAR2,
      p_direct_title       IN OUT   VARCHAR2,
      p_dtl_table          IN OUT   VARCHAR2,
      p_inw_asean          IN OUT   VARCHAR2,
      p_inw_auth           IN OUT   VARCHAR2,
      p_inw_oth            IN OUT   VARCHAR2,
      p_netdirect_title    IN OUT   VARCHAR2,
      p_netwritten_title   IN OUT   VARCHAR2,
      p_rep_title          IN OUT   VARCHAR2,
      p_retced_asean       IN OUT   VARCHAR2,
      p_retced_auth        IN OUT   VARCHAR2,
      p_retced_oth         IN OUT   VARCHAR2,
      p_retroced_title     IN OUT   VARCHAR2,
      p_subtitle           IN OUT   VARCHAR2,
      p_where              IN OUT   VARCHAR2
   )
   IS
   BEGIN
      IF p_report_type = 'PREMIUM'
      THEN
         --For the table
         p_dtl_table := 'giac_recap_summ_ext';
         --For the columns of the table
         p_direct := 'direct_prem';
         p_ceded_auth := 'ceded_prem_auth';
         p_ceded_asean := 'ceded_prem_asean';
         p_ceded_oth := 'ceded_prem_oth';
         p_inw_auth := 'inw_prem_auth';
         p_inw_asean := 'inw_prem_asean';
         p_inw_oth := 'inw_prem_oth';
         p_retced_auth := 'retceded_prem_auth';
         p_retced_asean := 'retceded_prem_asean';
         p_retced_oth := 'retceded_prem_oth';
         --For the labels of the report
         p_direct_title :=
               CHR (10)
            || CHR (10)
            || 'PREMIUMS ON'
            || CHR (10)
            || ' DIRECT BUSINESS';
         p_cedgroup_title := 'C  E  D  E  D    P  R  E  M  I  U  M  S';
         p_netdirect_title :=
               CHR (10)
            || 'NET PREMIUMS'
            || CHR (10)
            || 'WRITTEN ON'
            || CHR (10)
            || 'DIRECT BUSINESS';
         p_assumed_title := 'A S S U M E D  P R E M I U M S';
         p_retroced_title := 'R  E  T  R  O  C  E  D  E  D';
         p_netwritten_title :=
                  CHR (10) || CHR (10) || 'NET PREMIUMS' || CHR (10)
                  || 'WRITTEN';
         p_subtitle :=
            'RECAPITULATION I - Premiums Written and Premiums Earned (Less Returns and Cancellations)';
      ELSIF p_report_type = 'TSI'
      THEN
         --For the table
         p_dtl_table := 'giac_recap_summ_ext';
         --For the columns of the table
         p_direct := 'direct_tsi';
         p_ceded_auth := 'ceded_tsi_auth';
         p_ceded_asean := 'ceded_tsi_asean';
         p_ceded_oth := 'ceded_tsi_oth';
         p_inw_auth := 'inw_tsi_auth';
         p_inw_asean := 'inw_tsi_asean';
         p_inw_oth := 'inw_tsi_oth';
         p_retced_auth := 'retceded_tsi_auth';
         p_retced_asean := 'retceded_tsi_asean';
         p_retced_oth := 'retceded_tsi_oth';
         --For the labels of the report
         p_direct_title := CHR (10) || CHR (10) || CHR (10)
                           || 'DIRECT BUSINESS';
         p_cedgroup_title := 'R  I  S  K  S    C  E  D  E  D';
         p_netdirect_title :=
               CHR (10)
            || 'NET RISKS'
            || CHR (10)
            || 'ON DIRECT'
            || CHR (10)
            || 'BUSINESS';
         p_assumed_title := 'R  I  S  K  S    A  S  S  U  M  E  D';
         p_retroced_title := 'R  I  S  K  S    R  E  T  R  O  C  E  D  E  D';
         p_netwritten_title :=
                     CHR (10) || CHR (10) || 'NET RISKS' || CHR (10)
                     || 'WRITTEN';
         p_subtitle := 'RECAPITULATION IV - RISKS IN FORCE';
      ELSIF p_report_type = 'COMM'
      THEN
         --For the table
         p_dtl_table := 'giac_recap_summ_ext';
         --For the columns of the table
         p_direct := 'direct_comm';
         p_ceded_auth := 'ceded_comm_auth';
         p_ceded_asean := 'ceded_comm_asean';
         p_ceded_oth := 'ceded_comm_oth';
         p_inw_auth := 'inw_comm_auth';
         p_inw_asean := 'inw_comm_asean';
         p_inw_oth := 'inw_comm_oth';
         p_retced_auth := 'retceded_comm_auth';
         p_retced_asean := 'retceded_comm_asean';
         p_retced_oth := 'retceded_comm_oth';
         --For the labels of the report
         p_direct_title :=
               'COMMISSON'
            || CHR (10)
            || 'EXPENSES'
            || CHR (10)
            || 'ON DIRECT'
            || CHR (10)
            || 'BUSINESS';
         p_cedgroup_title := 'COMMISSION INCOME FROM CEDED BUSINESS';
         p_netdirect_title :=
               CHR (10)
            || 'NET COMMISSON'
            || CHR (10)
            || 'EXPENSES ON'
            || CHR (10)
            || 'DIRECT BUSINESS';
         p_assumed_title := 'COMMISSION EXPENSES ON ASSUMED BUSINESS';
         p_retroced_title := 'COMMISSION INCOME FROM RETROCEDED BUSINESS';
         p_netwritten_title :=
               CHR (10) || CHR (10) || 'NET COMMISSION' || CHR (10)
               || 'EXPENSES';
         p_subtitle := 'RECAPITULATION III - COMMISSIONS';
      ELSIF p_report_type = 'LOSSPD'
      THEN
         --For the table
         p_dtl_table := 'giac_recap_losspd_summ_ext';
         --For the columns of the table
         p_direct := 'gross_loss + gross_exp';
         p_ceded_auth := 'loss_auth + exp_auth';
         p_ceded_asean := 'loss_asean + exp_asean';
         p_ceded_oth := 'loss_oth + exp_oth';
         p_inw_auth := 'inw_grs_loss_auth + inw_grs_exp_auth';
         p_inw_asean := 'inw_grs_loss_asean + inw_grs_exp_asean';
         p_inw_oth := 'inw_grs_loss_oth + inw_grs_exp_oth';
         p_retced_auth := 'ret_loss_auth + ret_exp_auth';
         p_retced_asean := 'ret_loss_asean + ret_exp_asean';
         p_retced_oth := 'ret_loss_oth + ret_exp_oth';
         --For the labels of the report
         p_direct_title :=
               'LOSSES'
            || CHR (10)
            || 'PAID ON'
            || CHR (10)
            || 'ON DIRECT'
            || CHR (10)
            || 'BUSINESS';
         p_cedgroup_title := 'LOSS RECOVERIES ON CEDED BUSINESS';
         p_netdirect_title :=
               'NET LOSSES'
            || CHR (10)
            || 'PAID ON'
            || CHR (10)
            || 'DIRECT'
            || CHR (10)
            || 'BUSINESS';
         p_assumed_title := 'LOSSES ON ASSUMED BUSINESS';
         p_retroced_title := 'LOSS RECOVERIES ON RETROCEDED BUSINESS';
         p_netwritten_title :=
                       CHR (10) || CHR (10) || 'NET LOSSES' || CHR (10)
                       || 'PAID';
         p_subtitle := 'RECAPITULATION II - Losses Paid and Incurred';
      ELSIF p_report_type = 'OSLOSS'
      THEN
         --For the table
         p_dtl_table := 'giac_recap_osloss_summ_ext';
         --For the columns of the table
         p_direct := 'gross_loss + gross_exp';
         p_ceded_auth := 'loss_auth + exp_auth';
         p_ceded_asean := 'loss_asean + exp_asean';
         p_ceded_oth := 'loss_oth + exp_oth';
         p_inw_auth := 'inw_grs_loss_auth + inw_grs_exp_auth';
         p_inw_asean := 'inw_grs_loss_asean + inw_grs_exp_asean';
         p_inw_oth := 'inw_grs_loss_oth + inw_grs_exp_oth';
         p_retced_auth := 'ret_loss_auth + ret_exp_auth';
         p_retced_asean := 'ret_loss_asean + ret_exp_asean';
         p_retced_oth := 'ret_loss_oth + ret_exp_oth';
         --For the labels of the report
         p_direct_title :=
               'LOSSES AND'
            || CHR (10)
            || 'CLAIMS PAYABLE'
            || CHR (10)
            || 'ON DIRECT'
            || CHR (10)
            || 'BUSINESS';
         p_cedgroup_title := 'LOSSES AND CLAIMS RECOVERABLE ON CEDED BUSINESS';
         p_netdirect_title :=
               'NET LOSSES'
            || CHR (10)
            || 'PAYABALE ON'
            || CHR (10)
            || 'DIRECT'
            || CHR (10)
            || 'BUSINESS';
         p_assumed_title := 'LOSSES PAYABLE ON ASSUMED BUSINESS';
         p_retroced_title :=
                        'LOSSES AND CLAIMS RECOVERABLE ON RETROCEDED BUSINESS';
         p_netwritten_title :=
                       CHR (10) || CHR (10) || 'NET LOSSES' || CHR (10)
                       || 'PAID';
         p_subtitle := 'RECAPITULATION V - Losses and Claims Payable';
      END IF;
   END;

   FUNCTION get_giacr290_header (p_report_type VARCHAR2)
      RETURN giacr290_header_tab PIPELINED
   IS
      v_list   giacr290_header_type;
   BEGIN
      v_list.comp_name := giacp.v ('COMPANY_NAME');
      v_list.comp_add := giacp.v ('COMPANY_ADDRESS');
      v_list.rep_title :=
            'STATEMENT FROM '
         || TO_CHAR (giacp.d ('RECAP_TEMP_DATEFROM'), 'Mon DD, YYYY')
         || ' TO '
         || TO_CHAR (giacp.d ('RECAP_TEMP_DATETO'), 'Mon DD,YYYY')
         || ' OF THE '
         || v_list.comp_name;

      IF p_report_type = 'PREMIUM'
      THEN
         --For the labels of the report
         v_list.direct_title :=
               CHR (10)
            || CHR (10)
            || 'PREMIUMS ON'
            || CHR (10)
            || ' DIRECT BUSINESS';
         v_list.cedgroup_title := 'C  E  D  E  D    P  R  E  M  I  U  M  S';
         v_list.netdirect_title :=
               CHR (10)
            || 'NET PREMIUMS'
            || CHR (10)
            || 'WRITTEN ON'
            || CHR (10)
            || 'DIRECT BUSINESS';
         v_list.assumed_title := 'A S S U M E D  P R E M I U M S';
         v_list.retroced_title := 'R  E  T  R  O  C  E  D  E  D';
         v_list.netwritten_title :=
                  CHR (10) || CHR (10) || 'NET PREMIUMS' || CHR (10)
                  || 'WRITTEN';
         v_list.subtitle :=
            'RECAPITULATION I - Premiums Written and Premiums Earned (Less Returns and Cancellations)';
      ELSIF p_report_type = 'TSI'
      THEN
         --For the labels of the report
         v_list.direct_title :=
                           CHR (10) || CHR (10) || CHR (10)
                           || 'DIRECT BUSINESS';
         v_list.cedgroup_title := 'R  I  S  K  S    C  E  D  E  D';
         v_list.netdirect_title :=
               CHR (10)
            || 'NET RISKS'
            || CHR (10)
            || 'ON DIRECT'
            || CHR (10)
            || 'BUSINESS';
         v_list.assumed_title := 'R  I  S  K  S    A  S  S  U  M  E  D';
         v_list.retroced_title :=
                               'R  I  S  K  S    R  E  T  R  O  C  E  D  E  D';
         v_list.netwritten_title :=
                     CHR (10) || CHR (10) || 'NET RISKS' || CHR (10)
                     || 'WRITTEN';
         v_list.subtitle := 'RECAPITULATION IV - RISKS IN FORCE';
      ELSIF p_report_type = 'COMM'
      THEN
         --For the labels of the report
         v_list.direct_title :=
               'COMMISSON'
            || CHR (10)
            || 'EXPENSES'
            || CHR (10)
            || 'ON DIRECT'
            || CHR (10)
            || 'BUSINESS';
         v_list.cedgroup_title := 'COMMISSION INCOME FROM CEDED BUSINESS';
         v_list.netdirect_title :=
               CHR (10)
            || 'NET COMMISSON'
            || CHR (10)
            || 'EXPENSES ON'
            || CHR (10)
            || 'DIRECT BUSINESS';
         v_list.assumed_title := 'COMMISSION EXPENSES ON ASSUMED BUSINESS';
         v_list.retroced_title := 'COMMISSION INCOME FROM RETROCEDED BUSINESS';
         v_list.netwritten_title :=
               CHR (10) || CHR (10) || 'NET COMMISSION' || CHR (10)
               || 'EXPENSES';
         v_list.subtitle := 'RECAPITULATION III - COMMISSIONS';
      ELSIF p_report_type = 'LOSSPD'
      THEN
         --For the labels of the report
         v_list.direct_title :=
               'LOSSES'
            || CHR (10)
            || 'PAID ON'
            || CHR (10)
            || 'ON DIRECT'
            || CHR (10)
            || 'BUSINESS';
         v_list.cedgroup_title := 'LOSS RECOVERIES ON CEDED BUSINESS';
         v_list.netdirect_title :=
               'NET LOSSES'
            || CHR (10)
            || 'PAID ON'
            || CHR (10)
            || 'DIRECT'
            || CHR (10)
            || 'BUSINESS';
         v_list.assumed_title := 'LOSSES ON ASSUMED BUSINESS';
         v_list.retroced_title := 'LOSS RECOVERIES ON RETROCEDED BUSINESS';
         v_list.netwritten_title :=
                       CHR (10) || CHR (10) || 'NET LOSSES' || CHR (10)
                       || 'PAID';
         v_list.subtitle := 'RECAPITULATION II - Losses Paid and Incurred';
      ELSIF p_report_type = 'OSLOSS'
      THEN
         --For the labels of the report
         v_list.direct_title :=
               'LOSSES AND'
            || CHR (10)
            || 'CLAIMS PAYABLE'
            || CHR (10)
            || 'ON DIRECT'
            || CHR (10)
            || 'BUSINESS';
         v_list.cedgroup_title :=
                             'LOSSES AND CLAIMS RECOVERABLE ON CEDED BUSINESS';
         v_list.netdirect_title :=
               'NET LOSSES'
            || CHR (10)
            || 'PAYABALE ON'
            || CHR (10)
            || 'DIRECT'
            || CHR (10)
            || 'BUSINESS';
         v_list.assumed_title := 'LOSSES PAYABLE ON ASSUMED BUSINESS';
         v_list.retroced_title :=
                        'LOSSES AND CLAIMS RECOVERABLE ON RETROCEDED BUSINESS';
         v_list.netwritten_title :=
                       CHR (10) || CHR (10) || 'NET LOSSES' || CHR (10)
                       || 'PAID';
         v_list.subtitle := 'RECAPITULATION V - Losses and Claims Payable';
      END IF;

      PIPE ROW (v_list);
   END;
END;
/