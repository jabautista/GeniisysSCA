CREATE OR REPLACE PACKAGE BODY CPI.gipis130_pkg
AS
   FUNCTION get_giuw_pol_dist_polbasic (
      p_branch_cd    giac_branches.branch_cd%TYPE,
      p_line_cd      giis_line.line_cd%TYPE,
      p_dist_tag     giuw_pol_dist_polbasic_v.dist_flag%TYPE,
      p_as_of_date   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_date_opt     VARCHAR2,
      p_user_id      giis_users.user_id%TYPE,
      p_policy_id    giuw_pol_dist_polbasic_v.policy_id%TYPE,
      --added by shan 06.06.2014
      p_subline_cd   giuw_pol_dist_polbasic_v.SUBLINE_CD%type,
      p_iss_cd       giuw_pol_dist_polbasic_v.ISS_CD%type,
      p_issue_yy     giuw_pol_dist_polbasic_v.ISSUE_YY%type,
      p_pol_seq_no   giuw_pol_dist_polbasic_v.POL_SEQ_NO%type,
      p_renew_no     giuw_pol_dist_polbasic_v.RENEW_NO%type,
	  --added by robert 20756 01.27.16
      p_dist_no      giuw_pol_dist_polbasic_v.DIST_NO%type,
      p_endt_iss_cd  giuw_pol_dist_polbasic_v.ENDT_ISS_CD%type,
      p_endt_yy      giuw_pol_dist_polbasic_v.ENDT_YY%type,
      p_endt_seq_no  giuw_pol_dist_polbasic_v.ENDT_SEQ_NO%type
   )
      RETURN giuw_pol_dist_polbasic_tab PIPELINED
   IS
      v_list          giuw_pol_dist_polbasic_type;
      v_where         VARCHAR2 (32767);
      v_date_filter   VARCHAR2 (32767);
      v_branch_cd     giac_branches.branch_name%type := p_branch_cd;

      TYPE v_type IS RECORD (
         policy_no             VARCHAR2 (100),
         endt_no               VARCHAR2 (100),
         dist_no               giuw_pol_dist_polbasic_v.dist_no%TYPE,
         dist_flag             giuw_pol_dist_polbasic_v.dist_flag%TYPE,
         line_cd               giuw_pol_dist_polbasic_v.line_cd%TYPE,
         policy_id             giuw_pol_dist_polbasic_v.policy_id%TYPE,
         assd_no               giuw_pol_dist_polbasic_v.assd_no%TYPE,
         p_user_id             giuw_pol_dist_polbasic_v.user_id%TYPE,
         incept_date           giuw_pol_dist_polbasic_v.incept_date%TYPE,
         expiry_date_polbas    giuw_pol_dist_polbasic_v.expiry_date_polbas%TYPE,
         pol_flag              giuw_pol_dist_polbasic_v.pol_flag%TYPE,
         acct_ent_date         giuw_pol_dist_polbasic_v.acct_ent_date%TYPE,
         acct_neg_date         giuw_pol_dist_polbasic_v.acct_neg_date%TYPE,
         issue_date            giuw_pol_dist_polbasic_v.issue_date%TYPE,
         eff_date              giuw_pol_dist_polbasic_v.eff_date%TYPE,
         expiry_date_poldist   giuw_pol_dist_polbasic_v.expiry_date_poldist%TYPE,
         negate_date           giuw_pol_dist_polbasic_v.negate_date%TYPE,
         last_upd_date         giuw_pol_dist_polbasic_v.last_upd_date%TYPE,
         user_id2              giuw_pol_dist_polbasic_v.user_id2%TYPE,
         subline_cd            giuw_pol_dist_polbasic_v.subline_cd%TYPE,
         iss_cd                giuw_pol_dist_polbasic_v.iss_cd%TYPE,
         issue_yy              giuw_pol_dist_polbasic_v.issue_yy%TYPE,
         pol_seq_no            giuw_pol_dist_polbasic_v.pol_seq_no%TYPE,
         renew_no              giuw_pol_dist_polbasic_v.renew_no%TYPE,
         par_id                giuw_pol_dist_polbasic_v.par_id%TYPE
      );

      TYPE v_tab IS TABLE OF v_type;

      v_list_bulk     v_tab;
      
      v_line_cd         gipi_polbasic.line_cd%TYPE;
      v_subline_cd      gipi_polbasic.subline_cd%TYPE;
      v_iss_cd          gipi_polbasic.iss_cd%TYPE;
      v_issue_yy        gipi_polbasic.issue_yy%TYPE;
      v_pol_seq_no      gipi_polbasic.pol_seq_no%TYPE;
      v_renew_no        gipi_polbasic.renew_no%TYPE;
      v_endt_iss_cd     gipi_polbasic.endt_iss_cd%TYPE;
      v_endt_yy         gipi_polbasic.endt_yy%TYPE;
      v_endt_seq_no     gipi_polbasic.endt_seq_no%TYPE;
      
      v_query VARCHAR2(30000);
      v_line_cd2        gipi_polbasic.line_cd%TYPE;
   BEGIN
      IF p_line_cd IS NOT NULL OR p_dist_no IS NOT NULL OR p_policy_id IS NOT NULL THEN --added by robert 20756 01.27.16
      v_line_cd2 := p_line_cd;
      BEGIN
         IF p_date_opt = 'inceptDate'
         THEN
            v_date_filter :=
                  '(TRUNC(incept_date) >= TO_DATE('''
               || p_from_date
               || ''', ''mm-dd-yyyy'')
                            AND TRUNC(incept_date) <= TO_DATE('''
               || p_to_date
               || ''', ''mm-dd-yyyy'')
                             OR TRUNC(incept_date) <=  TO_DATE('''
               || p_as_of_date
               || ''', ''mm-dd-yyyy'')) AND ';
         ELSIF p_date_opt = 'issueDate'
         THEN
            v_date_filter :=
                  '(TRUNC(issue_date) >= TO_DATE('''
               || p_from_date
               || ''', ''mm-dd-yyyy'')
                             AND TRUNC(issue_date) <= TO_DATE('''
               || p_to_date
               || ''', ''mm-dd-yyyy'')
                             OR TRUNC(issue_date) <=  TO_DATE('''
               || p_as_of_date
               || ''', ''mm-dd-yyyy'')) AND ';
         ELSIF p_date_opt = 'effDate'
         THEN
            v_date_filter :=
                  '(TRUNC(eff_date) >= TO_DATE('''
               || p_from_date
               || ''', ''mm-dd-yyyy'')
                             AND TRUNC(eff_date) <= TO_DATE('''
               || p_to_date
               || ''', ''mm-dd-yyyy'')
                             OR TRUNC(eff_date) <=  TO_DATE('''
               || p_as_of_date
               || ''', ''mm-dd-yyyy'')) AND ';
         END IF;
      END;

      BEGIN
         IF p_dist_tag = '1'
         THEN
            v_where := 'dist_flag = ''1''';
         ELSIF p_dist_tag = '2'
         THEN
            v_where := 'dist_flag = ''2''';
         ELSIF p_dist_tag = '6'
         THEN
            v_where := '(dist_flag = ''1'' OR dist_flag = ''2'')';
         ELSIF p_dist_tag = '7'
         THEN
            v_where :=
               'dist_flag = ''3'' AND dist_no NOT IN (SELECT dist_no FROM GIRI_DISTFRPS)';
         ELSIF p_dist_tag = '8'
         THEN
            v_where :=
               'dist_flag = ''3'' AND dist_no IN (SELECT dist_no FROM GIRI_DISTFRPS)';
         ELSIF p_dist_tag = '3'
         THEN
            v_where := 'dist_flag = ''3''';
         ELSIF p_dist_tag = '4'
         THEN
            v_where := 'dist_flag = ''4''';
         ELSIF p_dist_tag = '5'
         THEN
            v_where := 'dist_flag = ''5''';
         ELSE
            v_where := 'dist_flag = dist_flag';
         END IF;

         v_where := v_date_filter || v_where;
      END;

      IF p_policy_id IS NOT NULL AND p_policy_id <> 0 THEN
        SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, endt_iss_cd, endt_yy, endt_seq_no
          INTO v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no, v_endt_iss_cd, v_endt_yy, v_endt_seq_no
          FROM gipi_polbasic
         WHERE policy_id = p_policy_id;                 
         
         v_line_cd2 := v_line_cd;
         
         v_where := v_where || ' AND a.line_cd = ''' || v_line_cd || ''' AND a.subline_cd = ''' || v_subline_cd || ''' AND a.iss_cd = ''' || v_iss_cd 
                            || ''' AND a.issue_yy = ' || v_issue_yy || ' AND a.pol_seq_no = ' || v_pol_seq_no || ' AND a.renew_no = ' || v_renew_no
                            || ' AND a.endt_iss_cd = ''' || v_endt_iss_cd || ''' AND a.endt_yy = ' || v_endt_yy || ' AND a.endt_seq_no = ' || v_endt_seq_no;
                            
      END IF;
      --added by robert 20756 01.27.16
      IF p_branch_cd IS NOT NULL THEN
         v_where := v_where ||' AND a.policy_id IN (SELECT c.policy_id
                                FROM gipi_polbasic c, giuw_pol_dist_polbasic_v d 
                               WHERE c.policy_id=d.policy_id AND c.cred_branch = ''' || p_branch_cd || ''')';
      END IF;
      --end of codes by robert 20756 01.27.16
      IF p_iss_cd IS NOT NULL THEN
            v_branch_cd := p_iss_cd;
      END IF;
      
      -- AND check_user_per_iss_cd2 (a.line_cd, a.iss_cd, ''GIPIS130'','''||p_user_id||''') = 1 previously part of v_query, removed by jdiago 08.14.2014.
      -- placed in .xml for optimization.
      v_query :=    ' SELECT LTRIM(a.line_cd) || ''-'' || LTRIM  (a.subline_cd) || ''-''|| LTRIM (a.iss_cd) || ''-'' || 
                                 LTRIM (TO_CHAR (a.issue_yy, ''99'')) || ''-''|| 
                                 LPAD (LTRIM (TO_CHAR (a.pol_seq_no, ''9999999'')),7,''0'')|| ''-''|| 
                                 LPAD (LTRIM (TO_CHAR (a.renew_no, ''99'')), 2, ''0'') policy_no, 
                                 DECODE(a.endt_seq_no, 0, NULL, 
                                 LTRIM(a.line_cd) || ''-'' || LTRIM (a.subline_cd) || ''-'' || LTRIM (a.endt_iss_cd) || ''-'' || 
                                 LTRIM (TO_CHAR (a.endt_yy, ''99'')) || ''-'' || 
                                 LPAD (LTRIM (TO_CHAR (a.endt_seq_no, ''9999999'')),6,''0'')) endt_no, 
                                 a.dist_no, a.dist_flag, a.line_cd, a.policy_id, a.assd_no, a.user_id as p_user_id, a.incept_date, a.expiry_date_polbas,
                                 a.pol_flag, a.acct_ent_date, a.acct_neg_date, a.issue_date, a.eff_date, a.expiry_date_poldist, a.negate_date, 
                                 a.last_upd_date, a.user_id2, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no, a.par_id
                            FROM giuw_pol_dist_polbasic_v a, giis_issource b
                           WHERE 1 = 1
                             AND a.iss_cd = b.iss_cd(+)
                             AND a.line_cd = NVL(''' --added nvl by robert 20756 01.27.16
                        || v_line_cd2
                        || ''', a.line_cd) AND (a.iss_cd = NVL(''' --added by robert 20756 01.27.16
                        || v_branch_cd /*p_branch_cd*/
                        || ''', a.iss_cd) OR b.iss_name = NVL('''
                        || v_branch_cd /*p_branch_cd*/
                        || ''', b.iss_name))
                             AND '
                        || v_where
                        -- added by shan 06.06.2014
                        || ' AND a.subline_cd LIKE NVL(''' || UPPER(p_subline_cd) || ''', ''%'')'
                        || ' AND a.issue_yy = NVL(''' || p_issue_yy || ''', a.issue_yy)'
                        || ' AND a.pol_seq_no = NVL(''' || p_pol_seq_no || ''', a.pol_seq_no)'
                        || ' AND a.renew_no = NVL(''' || p_renew_no || ''', a.renew_no)'
                        || ' AND a.dist_no = NVL(''' || p_dist_no || ''', a.dist_no)'
                        || ' AND a.endt_iss_cd LIKE NVL(''' || UPPER(p_endt_iss_cd) || ''', ''%'')'
                        || ' AND a.endt_yy = NVL(''' || p_endt_yy || ''', a.endt_yy)'
                        || ' AND a.endt_seq_no = NVL(''' || p_endt_seq_no || ''', a.endt_seq_no)'; ----added by robert 20756 01.27.16
                        
      EXECUTE IMMEDIATE v_query         
                        
      BULK COLLECT INTO v_list_bulk;

      IF v_list_bulk.LAST > 0
      THEN
         FOR i IN v_list_bulk.FIRST .. v_list_bulk.LAST
         LOOP
            v_list.policy_no := v_list_bulk (i).policy_no;
            v_list.endt_no := v_list_bulk (i).endt_no;
            v_list.dist_no := v_list_bulk (i).dist_no;
            v_list.dist_flag := v_list_bulk (i).dist_flag;
            v_list.p_user_id := v_list_bulk (i).p_user_id;
            v_list.incept_date := v_list_bulk (i).incept_date;
            v_list.expiry_date_polbas := v_list_bulk (i).expiry_date_polbas;
            v_list.acct_ent_date := v_list_bulk (i).acct_ent_date;
            v_list.acct_neg_date := v_list_bulk (i).acct_neg_date;
            v_list.issue_date := v_list_bulk (i).issue_date;
            v_list.eff_date := v_list_bulk (i).eff_date;
            v_list.expiry_date_poldist := v_list_bulk (i).expiry_date_poldist;
            v_list.negate_date := v_list_bulk (i).negate_date;
            v_list.last_upd_date := v_list_bulk (i).last_upd_date;
            v_list.user_id2 := v_list_bulk (i).user_id2;
            v_list.line_cd := v_list_bulk (i).line_cd;
            v_list.subline_cd := v_list_bulk (i).subline_cd;
            v_list.iss_cd := v_list_bulk (i).iss_cd;
            v_list.issue_yy := v_list_bulk (i).issue_yy;
            v_list.pol_seq_no := v_list_bulk (i).pol_seq_no;
            v_list.renew_no := v_list_bulk (i).renew_no;
            v_list.par_id := v_list_bulk (i).par_id;
            v_list.policy_id := v_list_bulk (i).policy_id;

            BEGIN
               FOR assd_name IN (SELECT assd_name
                                   FROM giis_assured
                                  WHERE assd_no = v_list_bulk (i).assd_no)
               LOOP
                  v_list.assd_name := assd_name.assd_name;
               END LOOP;

               FOR pol_status IN (SELECT rv_meaning
                                    FROM cg_ref_codes
                                   WHERE rv_domain = 'GIPI_POLBASIC.POL_FLAG'
                                     AND rv_low_value =
                                                      v_list_bulk (i).pol_flag)
               LOOP
                  v_list.policy_status := pol_status.rv_meaning;
               END LOOP;

               FOR iss_name IN (SELECT iss_name
                                  FROM giis_issource
                                 WHERE iss_cd = v_list_bulk (i).iss_cd)
               LOOP
                  v_list.iss_name := iss_name.iss_name;
               END LOOP;
            END;

            DECLARE
               v_switch   VARCHAR2 (1) := 'N';
            BEGIN
               IF v_list_bulk (i).dist_flag = '1'
               THEN
                  v_list.status := 'U w/o Facultative';
               ELSIF v_list_bulk (i).dist_flag = '2'
               THEN
                  v_list.status := 'U w/ Facultative';
               ELSIF v_list_bulk (i).dist_flag = '3'
               THEN
                  FOR a IN (SELECT DISTINCT share_cd
                                       FROM giuw_policyds_dtl
                                      WHERE line_cd = v_list_bulk (i).line_cd
                                        AND dist_no = v_list_bulk (i).dist_no
                                   ORDER BY share_cd ASC)
                  LOOP
                     IF a.share_cd = 999
                     THEN
                        v_list.status := 'D w/ Facultative';
                     ELSE
                        v_list.status := 'D w/o Facultative';
                     END IF;

                     v_switch := 'Y';
                  END LOOP;

                  IF v_switch = 'N'
                  THEN
                     FOR endt IN (SELECT endt_tax
                                    FROM gipi_endttext
                                   WHERE policy_id =
                                                    v_list_bulk (i).policy_id)
                     LOOP
                        IF endt.endt_tax = 'Y'
                        THEN
                           v_list.status := 'U w/o Facultative';
                        END IF;
                     END LOOP;
                  END IF;
               ELSIF v_list_bulk (i).dist_flag = '4'
               THEN
                  v_list.status := 'Negated';
               ELSE
                  v_list.status := 'Redistributed';
               END IF;
            END;
			--added by robert SR 4887 10.05.15
			BEGIN
              SELECT post_flag
                INTO v_list.post_flag
                FROM giuw_pol_dist
               WHERE dist_no = v_list_bulk (i).dist_no AND par_id = v_list_bulk (i).par_id;
            END;
			--end robert SR 4887 10.05.15
            PIPE ROW (v_list);
         END LOOP;
      END IF;
      END IF; --added by robert 20756 01.27.16

      RETURN;
   END get_giuw_pol_dist_polbasic;

   FUNCTION get_par_history (p_par_id gipi_parhist.par_id%TYPE)
      RETURN par_history_tab PIPELINED
   IS
      v_list   par_history_type;
   BEGIN
      FOR i IN (SELECT   parstat_date, parstat_cd, user_id
                    FROM gipi_parhist
                   WHERE par_id = p_par_id
                ORDER BY parstat_date)
      LOOP
         v_list.par_stat := derive_policy_status (i.parstat_cd);
         v_list.parstat_date :=
                           TO_CHAR (i.parstat_date, 'mm-dd-yyyy HH:MI:ss AM');
         v_list.user_id := i.user_id;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_par_history;

   FUNCTION get_policy_ds (
      p_par_id          gipi_parhist.par_id%TYPE,
      p_dist_no         giuw_wpolicyds_policyds_v.dist_no%TYPE,
      p_dist_flag       giuw_pol_dist_polbasic_v.dist_flag%TYPE,
      p_policy_no       VARCHAR2,
      p_policy_status   VARCHAR2,
	  p_item_sw         VARCHAR2 --added by robert SR 4887 10.05.15
   )
      RETURN policy_ds_tab PIPELINED
   IS
      v_list        policy_ds_type;
      v_post_flag   VARCHAR2 (1);
      v_posted      VARCHAR2 (1)   := 'N';
   BEGIN
      SELECT post_flag
        INTO v_post_flag
        FROM giuw_pol_dist
       WHERE dist_no = p_dist_no AND par_id = p_par_id;

      FOR posted IN (SELECT 1
                       FROM giuw_policyds
                      WHERE dist_no = p_dist_no)
      LOOP
         v_posted := 'Y';
         EXIT;
      END LOOP;

      IF v_post_flag = 'O'
      THEN
         IF p_dist_flag = '3' OR p_dist_flag = '4' OR v_posted = 'Y'
         THEN
            v_list.policy_no := p_policy_no;
            v_list.dist_flag := p_dist_flag;
            v_list.status := p_policy_status;
            v_list.dist_no := p_dist_no;
            v_list.post_flag := v_post_flag;
            v_list.placement_source := 'POSTEDTABLE';
         ELSE
            v_list.policy_no := p_policy_no;
            v_list.dist_flag := p_dist_flag;
            v_list.status := p_policy_status;
            v_list.dist_no := p_dist_no;
            v_list.post_flag := v_post_flag;
            v_list.placement_source := 'WORKINGTABLE';
         END IF;

         FOR i IN (SELECT dist_seq_no, NVL (tsi_amt, 0) tsi_amt,
                          NVL (prem_amt, 0) prem_amt
                     FROM giuw_wpolicyds_policyds_v
                    WHERE dist_no = p_dist_no)
         LOOP
            v_list.dist_seq_no := i.dist_seq_no;
            v_list.tsi_amt := i.tsi_amt;
            v_list.prem_amt := i.prem_amt;
            PIPE ROW (v_list);
         END LOOP;
      ELSE
         IF p_dist_flag = '3' OR p_dist_flag = '4' OR v_posted = 'Y'
         THEN
            v_list.policy_no := p_policy_no;
            v_list.dist_flag := p_dist_flag;
            v_list.status := p_policy_status;
            v_list.dist_no := p_dist_no;
            v_list.post_flag := v_post_flag;
            v_list.placement_source := 'POSTEDTABLE';
         ELSE
            v_list.policy_no := p_policy_no;
            v_list.dist_flag := p_dist_flag;
            v_list.status := p_policy_status;
            v_list.dist_no := p_dist_no;
            v_list.post_flag := v_post_flag;
            v_list.placement_source := 'WORKINGTABLE';
         END IF;
		 --modified query and added condition by robert SR 4887 10.05.15
         IF NVL(p_item_sw,'N') = 'N' THEN
                  FOR i IN (SELECT   dist_seq_no, NVL (tsi_amt, 0) tsi_amt,
                                NVL (prem_amt, 0) prem_amt, peril_cd, line_cd
                           FROM giuw_wperilds_perilds_v
                          WHERE dist_no = p_dist_no
                       GROUP BY dist_seq_no, tsi_amt, prem_amt, peril_cd, line_cd
                       ORDER BY dist_seq_no, peril_cd) 
             LOOP
                v_list.dist_seq_no := i.dist_seq_no;
                v_list.tsi_amt := i.tsi_amt;
                v_list.prem_amt := i.prem_amt;
                v_list.peril_cd := i.peril_cd;
                v_list.line_cd := i.line_cd;

                BEGIN
                   SELECT peril_name
                     INTO v_list.peril_name
                     FROM giis_peril
                    WHERE peril_cd = i.peril_cd AND line_cd = i.line_cd;
                END;

                PIPE ROW (v_list);
             END LOOP;
         ELSE
             FOR i IN (SELECT   dist_seq_no, SUM(NVL (dist_tsi, 0)) tsi_amt,
                                SUM(NVL (dist_prem, 0)) prem_amt, peril_cd, line_cd, item_no
                         FROM giuw_witmprlds_itmprlds_dtl_v
                        WHERE dist_no = p_dist_no
                        GROUP BY dist_seq_no, peril_cd, line_cd, item_no
                        ORDER BY dist_seq_no, item_no, peril_cd) 
             LOOP
                v_list.dist_seq_no := i.dist_seq_no;
                v_list.tsi_amt := i.tsi_amt;
                v_list.prem_amt := i.prem_amt;
                v_list.peril_cd := i.peril_cd;
                v_list.line_cd := i.line_cd;
                v_list.item_no := i.item_no;

                BEGIN
                   SELECT peril_name
                     INTO v_list.peril_name
                     FROM giis_peril
                    WHERE peril_cd = i.peril_cd AND line_cd = i.line_cd;
                END;

                PIPE ROW (v_list);
             END LOOP;
         END IF;
		 --end robert SR 4887 10.05.15
      END IF;

      RETURN;
   END get_policy_ds;

   FUNCTION get_policy_ds_dtl (
      p_dist_no       giuw_wpolicyds_policyds_v.dist_no%TYPE,
      p_dist_seq_no   giuw_wpolicyds_policyds_v.dist_seq_no%TYPE
   )
      RETURN policy_ds_tab PIPELINED
   IS
      v_list   policy_ds_type;
   BEGIN
      FOR j IN (SELECT NVL (dist_spct, 0) dist_spct,
                       NVL (dist_tsi, 0) dist_tsi,
                       dist_spct1, --NVL (dist_spct1, 0) dist_spct1, removed NVL by robert SR 4887 10.05.15
                       NVL (dist_prem, 0) dist_prem, line_cd, share_cd,
                       dist_seq_no
                  FROM giuw_wpolicyds_policyds_dtl_v
                 WHERE dist_no = p_dist_no AND dist_seq_no = p_dist_seq_no)
      LOOP
         v_list.dist_spct := NULL;
         v_list.dist_tsi := NULL;
         v_list.dist_spct1 := NULL;
         v_list.dist_prem := NULL;
         v_list.trty_name := NULL;
         v_list.dist_spct := j.dist_spct;
         v_list.dist_tsi := j.dist_tsi;
         v_list.dist_spct1 := j.dist_spct1;
         v_list.dist_prem := j.dist_prem;

         BEGIN
            SELECT trty_name
              INTO v_list.trty_name
              FROM giis_dist_share
             WHERE line_cd = j.line_cd AND share_cd = j.share_cd;
         END;

         BEGIN
            SELECT SUM (NVL (dist_spct, 0)), SUM (NVL (dist_spct1, 0)),
                   SUM (NVL (dist_tsi, 0)), SUM (NVL (dist_prem, 0))
              INTO v_list.s_dist_spct, v_list.s_dist_spct1,
                   v_list.s_dist_tsi, v_list.s_dist_prem
              FROM giuw_wpolicyds_policyds_dtl_v
             WHERE dist_no = p_dist_no
               AND dist_seq_no = p_dist_seq_no
               AND line_cd = j.line_cd;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_policy_ds_dtl;

   FUNCTION get_policy_ds_dtl2 (
      p_dist_no       giuw_wpolicyds_policyds_v.dist_no%TYPE,
      p_dist_seq_no   giuw_wpolicyds_policyds_v.dist_seq_no%TYPE,
      p_line_cd       giis_peril.line_cd%TYPE,
      p_peril_cd      giis_peril.peril_cd%TYPE,
      p_post_flag     VARCHAR2,
	  p_item_no       giuw_witmprlds_itmprlds_dtl_v.item_no%TYPE --added by robert SR 4887 10.05.15
   )
      RETURN policy_ds_tab PIPELINED
   IS
      v_list   policy_ds_type;
   BEGIN
      --modified query and added condition by robert SR 4887 10.05.15
      IF p_item_no is null then
          FOR j IN (SELECT NVL (dist_spct, 0) dist_spct,
                           NVL (dist_tsi, 0) dist_tsi,
                           NVL (dist_spct1, 0) dist_spct1,
                           NVL (dist_prem, 0) dist_prem, line_cd, share_cd,
                           dist_seq_no
                      FROM giuw_wperilds_perilds_dtl_v
                     WHERE dist_no = p_dist_no
                       AND dist_seq_no = p_dist_seq_no
                       AND line_cd = p_line_cd
                       AND peril_cd = p_peril_cd)
          LOOP
             v_list.dist_spct := NULL;
             v_list.dist_tsi := NULL;
             v_list.dist_spct1 := NULL;
             v_list.dist_prem := NULL;
             v_list.trty_name := NULL;
             v_list.dist_spct := j.dist_spct;
             v_list.dist_tsi := j.dist_tsi;
             v_list.dist_spct1 := j.dist_spct1;
             v_list.dist_prem := j.dist_prem;

             BEGIN
                SELECT trty_name
                  INTO v_list.trty_name
                  FROM giis_dist_share
                 WHERE line_cd = j.line_cd AND share_cd = j.share_cd;
             END;

             BEGIN
                SELECT SUM (NVL (dist_spct, 0)), SUM (NVL (dist_spct1, 0)),
                       SUM (NVL (dist_tsi, 0)), SUM (NVL (dist_prem, 0))
                  INTO v_list.s_dist_spct, v_list.s_dist_spct1,
                       v_list.s_dist_tsi, v_list.s_dist_prem
                  FROM giuw_wperilds_perilds_dtl_v
                 WHERE dist_no = p_dist_no
                   AND dist_seq_no = p_dist_seq_no
                   AND line_cd = p_line_cd
                   AND peril_cd = p_peril_cd;
             END;

             PIPE ROW (v_list);
          END LOOP;
      ELSE
            FOR j IN (SELECT NVL (dist_spct, 0) dist_spct,
                           NVL (dist_tsi, 0) dist_tsi,
                           NVL (dist_spct1, 0) dist_spct1,
                           NVL (dist_prem, 0) dist_prem, line_cd, share_cd,
                           dist_seq_no
                      FROM giuw_witmprlds_itmprlds_dtl_v 
                     WHERE dist_no = p_dist_no
                       AND dist_seq_no = p_dist_seq_no
                       AND line_cd = p_line_cd
                       AND peril_cd = p_peril_cd
                       AND item_no = p_item_no)
          LOOP
             v_list.dist_spct := NULL;
             v_list.dist_tsi := NULL;
             v_list.dist_spct1 := NULL;
             v_list.dist_prem := NULL;
             v_list.trty_name := NULL;
             v_list.dist_spct := j.dist_spct;
             v_list.dist_tsi := j.dist_tsi;
             v_list.dist_spct1 := j.dist_spct1;
             v_list.dist_prem := j.dist_prem;

             BEGIN
                SELECT trty_name
                  INTO v_list.trty_name
                  FROM giis_dist_share
                 WHERE line_cd = j.line_cd AND share_cd = j.share_cd;
             END;

             BEGIN
                SELECT SUM (NVL (dist_spct, 0)), SUM (NVL (dist_spct1, 0)),
                       SUM (NVL (dist_tsi, 0)), SUM (NVL (dist_prem, 0))
                  INTO v_list.s_dist_spct, v_list.s_dist_spct1,
                       v_list.s_dist_tsi, v_list.s_dist_prem
                  FROM giuw_witmprlds_itmprlds_dtl_v
                 WHERE dist_no = p_dist_no
                   AND dist_seq_no = p_dist_seq_no
                   AND line_cd = p_line_cd
                   AND peril_cd = p_peril_cd
                   AND item_no = p_item_no;
             END;

             PIPE ROW (v_list);
          END LOOP;
      END IF;
      --end robert SR 4887 10.05.15
      RETURN;
   END get_policy_ds_dtl2;

   FUNCTION get_ri_placement (
      p_dist_no            giuw_wpolicyds_policyds_v.dist_no%TYPE,
      p_dist_seq_no        giuw_wpolicyds_policyds_v.dist_seq_no%TYPE,
      p_placement_source   VARCHAR2
   )
      RETURN policy_ds_tab PIPELINED
   IS
      v_list   policy_ds_type;
   BEGIN
      IF p_placement_source = 'POSTEDTABLE'
      THEN
         FOR i IN (SELECT line_cd, frps_yy, frps_seq_no
                     FROM giri_distfrps
                    WHERE dist_no = p_dist_no AND dist_seq_no = p_dist_seq_no)
         LOOP
            FOR j IN (SELECT fnl_binder_id, line_cd, ri_cd,
                             NVL (ri_shr_pct, 0) ri_shr_pct,
                             NVL (ri_tsi_amt, 0) ri_tsi_amt,
                             NVL (ri_prem_amt, 0) ri_prem_amt
                        FROM giri_frps_ri
                       WHERE line_cd = i.line_cd
                         AND frps_yy = i.frps_yy
                         AND frps_seq_no = i.frps_seq_no
                         AND reverse_sw <> 'Y')
            LOOP
               BEGIN
                  SELECT SUM (NVL (ri_shr_pct, 0)),
                         SUM (NVL (ri_tsi_amt, 0)),
                         SUM (NVL (ri_prem_amt, 0))
                    INTO v_list.sum_ri_shr_pct,
                         v_list.sum_ri_tsi_amt,
                         v_list.sum_ri_prem_amt
                    FROM giri_frps_ri
                   WHERE line_cd = i.line_cd
                     AND frps_yy = i.frps_yy
                     AND frps_seq_no = i.frps_seq_no
                     AND reverse_sw <> 'Y';
               END;

               v_list.ri_shr_pct := j.ri_shr_pct;
               v_list.ri_tsi_amt := j.ri_tsi_amt;
               v_list.ri_prem_amt := j.ri_prem_amt;
               v_list.binder_no := NULL;
               v_list.ri_sname := NULL;

               SELECT    line_cd
                      || '-'
                      || TO_CHAR (binder_yy, '99')
                      || '-'
                      || TO_CHAR (binder_seq_no, '00009') binder_no
                 INTO v_list.binder_no
                 FROM giri_binder
                WHERE fnl_binder_id = j.fnl_binder_id
                  AND line_cd = j.line_cd
                  AND ri_cd = j.ri_cd;

               SELECT ri_sname
                 INTO v_list.ri_sname
                 FROM giis_reinsurer
                WHERE ri_cd = j.ri_cd;

               PIPE ROW (v_list);
            END LOOP;
         END LOOP;
      ELSIF p_placement_source = 'WORKINGTABLE'
      THEN
         FOR i IN (SELECT line_cd, frps_yy, frps_seq_no
                     FROM giri_wdistfrps
                    WHERE dist_no = p_dist_no AND dist_seq_no = p_dist_seq_no)
         LOOP
            FOR j IN (SELECT pre_binder_id, line_cd, ri_cd,
                             NVL (ri_shr_pct, 0) ri_shr_pct,
                             NVL (ri_tsi_amt, 0) ri_tsi_amt,
                             NVL (ri_prem_amt, 0) ri_prem_amt
                        FROM giri_wfrps_ri
                       WHERE line_cd = i.line_cd
                         AND frps_yy = i.frps_yy
                         AND frps_seq_no = i.frps_seq_no
                         AND reverse_sw <> 'Y')
            LOOP
               BEGIN
                  SELECT SUM (NVL (ri_shr_pct, 0)),
                         SUM (NVL (ri_tsi_amt, 0)),
                         SUM (NVL (ri_prem_amt, 0))
                    INTO v_list.sum_ri_shr_pct,
                         v_list.sum_ri_tsi_amt,
                         v_list.sum_ri_prem_amt
                    FROM giri_frps_ri
                   WHERE line_cd = i.line_cd
                     AND frps_yy = i.frps_yy
                     AND frps_seq_no = i.frps_seq_no
                     AND reverse_sw <> 'Y';
               END;

               v_list.ri_shr_pct := j.ri_shr_pct;
               v_list.ri_tsi_amt := j.ri_tsi_amt;
               v_list.ri_prem_amt := j.ri_prem_amt;
               v_list.binder_no := NULL;
               v_list.ri_sname := NULL;

               SELECT    line_cd
                      || '-'
                      || TO_CHAR (binder_yy, '99')
                      || '-'
                      || TO_CHAR (binder_seq_no, '00009') binder_no
                 INTO v_list.binder_no
                 FROM giri_wbinder
                WHERE pre_binder_id = j.pre_binder_id
                  AND line_cd = j.line_cd
                  AND ri_cd = j.ri_cd;

               SELECT ri_sname
                 INTO v_list.ri_sname
                 FROM giis_reinsurer
                WHERE ri_cd = j.ri_cd;

               PIPE ROW (v_list);
            END LOOP;
         END LOOP;
      END IF;

      RETURN;
   END get_ri_placement;

   FUNCTION get_summarized_dist (
      p_line_cd      giuw_policyds_ext.line_cd%TYPE,
      p_subline_cd   giuw_policyds_ext.subline_cd%TYPE,
      p_iss_cd       giuw_policyds_ext.iss_cd%TYPE,
      p_issue_yy     giuw_policyds_ext.issue_yy%TYPE,
      p_pol_seq_no   giuw_policyds_ext.pol_seq_no%TYPE,
      p_renew_no     giuw_policyds_ext.renew_no%TYPE
   )
      RETURN summarized_dist_tab PIPELINED
   IS
      res   summarized_dist_type;
   BEGIN
      FOR i IN (SELECT trty_name, tsi_spct, dist_tsi, prem_spct, dist_prem
                  FROM giuw_policyds_ext
                 WHERE line_cd = p_line_cd
                   AND subline_cd = p_subline_cd
                   AND iss_cd = p_iss_cd
                   AND issue_yy = p_issue_yy
                   AND pol_seq_no = p_pol_seq_no
                   AND renew_no = p_renew_no)
      LOOP
         res.trty_name := i.trty_name;
         res.tsi_spct := i.tsi_spct;
         res.dist_tsi := i.dist_tsi;
         res.prem_spct := i.prem_spct;
         res.dist_prem := i.dist_prem;

         FOR j IN (SELECT SUM (tsi_spct) tot_tsi_spct,
                          SUM (dist_tsi) tot_dist_tsi,
                          SUM (prem_spct) tot_prem_spct,
                          SUM (dist_prem) tot_dist_prem
                     FROM giuw_policyds_ext
                    WHERE line_cd = p_line_cd
                      AND subline_cd = p_subline_cd
                      AND iss_cd = p_iss_cd
                      AND issue_yy = p_issue_yy
                      AND pol_seq_no = p_pol_seq_no
                      AND renew_no = p_renew_no)
         LOOP
            res.tot_tsi_spct := j.tot_tsi_spct;
            res.tot_dist_tsi := j.tot_dist_tsi;
            res.tot_prem_spct := j.tot_prem_spct;
            res.tot_dist_prem := j.tot_dist_prem;
         END LOOP;

         PIPE ROW (res);
      END LOOP;
   END;

   PROCEDURE call_extract_dist_gipis130 (
      p_line_cd        IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd     IN       gipi_polbasic.subline_cd%TYPE,
      p_iss_cd         IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       IN       gipi_polbasic.renew_no%TYPE,
      p_extract_date   IN       giuw_pol_dist.eff_date%TYPE,
      p_message        OUT      VARCHAR2
   )
   IS
      v_exist       VARCHAR2 (1) := 'N';
      v_ext_exist   VARCHAR2 (1) := 'N';
   BEGIN
      p_message := 'SUCCESS';

      FOR chk IN (SELECT dst.dist_no
                    FROM gipi_polbasic pol, giuw_pol_dist dst
                   WHERE 1 = 1
                     --link polbasic and giuw_pol_dist
                     AND dst.policy_id = pol.policy_id
                     --filter gipi_polbasic
                     AND pol.line_cd = p_line_cd
                     AND pol.subline_cd = p_subline_cd
                     AND pol.iss_cd = p_iss_cd
                     AND pol.issue_yy = p_issue_yy
                     AND pol.pol_seq_no = p_pol_seq_no
                     AND pol.renew_no = p_renew_no
                     AND pol.pol_flag IN ('1', '2', '3', '4', 'X')
                     --filter giuw_pol_dist
                     AND dst.dist_flag = '3'
                     AND TRUNC (dst.eff_date) <= TRUNC (p_extract_date)
                     AND TRUNC (dst.expiry_date) >= TRUNC (p_extract_date))
      LOOP
         v_exist := 'Y';
         EXIT;
      END LOOP;

      IF v_exist = 'Y'
      THEN
         FOR ext IN (SELECT DISTINCT shr.share_cd, shr.trty_name
                                FROM gipi_polbasic pol,
                                     giuw_pol_dist dst,
                                     giuw_policyds_dtl pdtl,
                                     giis_dist_share shr
                               WHERE 1 = 1
                                 --link polbasic and giuw_pol_dist
                                 AND pol.policy_id = dst.policy_id
                                 --link giuw_pol_dist and giuw_policyds_dtl
                                 AND pdtl.dist_no = dst.dist_no
                                 AND pdtl.line_cd = p_line_cd
                                 --link giuw_policyds_dtl and giis_dist_share
                                 AND pdtl.line_cd = shr.line_cd
                                 AND pdtl.share_cd = shr.share_cd
                                 --filter gipi_polbasic
                                 AND pol.line_cd = p_line_cd
                                 AND pol.subline_cd = p_subline_cd
                                 AND pol.iss_cd = p_iss_cd
                                 AND pol.issue_yy = p_issue_yy
                                 AND pol.pol_seq_no = p_pol_seq_no
                                 AND pol.renew_no = p_renew_no
                                 AND pol.pol_flag IN
                                                    ('1', '2', '3', '4', 'X')
                                 --filter giuw_pol_dist
                                 AND dst.dist_flag = '3'
                                 AND TRUNC (dst.eff_date) <=
                                                        TRUNC (p_extract_date)
                                 AND TRUNC (dst.expiry_date) >=
                                                        TRUNC (p_extract_date))
         LOOP
            v_ext_exist := 'Y';
            EXIT;
         END LOOP;

         IF v_ext_exist = 'Y'
         THEN
            summarize_distribution.summarize_eff_distribution (p_line_cd,
                                                               p_subline_cd,
                                                               p_iss_cd,
                                                               p_issue_yy,
                                                               p_pol_seq_no,
                                                               p_renew_no,
                                                               p_extract_date
                                                              );
         ELSE
            p_message := 'No records extracted.';
            RETURN;
         END IF;
      ELSIF v_exist = 'N'
      THEN
         FOR ext IN (SELECT DISTINCT shr.share_cd, shr.trty_name
                                FROM gipi_polbasic pol,
                                     giuw_pol_dist dst,
                                     giuw_policyds_dtl pdtl,
                                     giis_dist_share shr
                               WHERE 1 = 1
                                 --link polbasic and giuw_pol_dist
                                 AND pol.policy_id = dst.policy_id
                                 --link giuw_pol_dist and giuw_policyds_dtl
                                 AND pdtl.dist_no = dst.dist_no
                                 AND pdtl.line_cd = p_line_cd
                                 --link giuw_policyds_dtl and giis_dist_share
                                 AND pdtl.line_cd = shr.line_cd
                                 AND pdtl.share_cd = shr.share_cd
                                 --filter gipi_polbasic
                                 AND pol.line_cd = p_line_cd
                                 AND pol.subline_cd = p_subline_cd
                                 AND pol.iss_cd = p_iss_cd
                                 AND pol.issue_yy = p_issue_yy
                                 AND pol.pol_seq_no = p_pol_seq_no
                                 AND pol.renew_no = p_renew_no
                                 AND pol.pol_flag IN
                                                    ('1', '2', '3', '4', 'X')
                                 --filter giuw_pol_dist
                                 AND dst.dist_flag = '3')
         LOOP
            v_ext_exist := 'Y';
            EXIT;
         END LOOP;

         IF v_ext_exist = 'Y'
         THEN
            summarize_distribution.summarize_all_distribution (p_line_cd,
                                                               p_subline_cd,
                                                               p_iss_cd,
                                                               p_issue_yy,
                                                               p_pol_seq_no,
                                                               p_renew_no
                                                              );
         ELSE
            p_message := 'No records extracted.';
            RETURN;
         END IF;
      END IF;
   END;

   FUNCTION on_load_summarized_dist (
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_exist   VARCHAR2 (1) := 'N';
   BEGIN
      FOR x IN (SELECT '1'
                  FROM giuw_policyds_ext
                 WHERE line_cd = p_line_cd
                   AND subline_cd = p_subline_cd
                   AND iss_cd = p_iss_cd
                   AND issue_yy = p_issue_yy
                   AND pol_seq_no = p_pol_seq_no
                   AND renew_no = p_renew_no
                   AND share_cd = (SELECT param_value_n
                                     FROM giis_parameters
                                    WHERE param_name = 'FACULTATIVE'))
      LOOP
         v_exist := 'Y';
         EXIT;
      END LOOP;

      RETURN v_exist;
   END;

   FUNCTION get_ri_placement_tg (
      p_line_cd      giri_distfrps_ext.line_cd%TYPE,
      p_subline_cd   giri_distfrps_ext.subline_cd%TYPE,
      p_iss_cd       giri_distfrps_ext.iss_cd%TYPE,
      p_issue_yy     giri_distfrps_ext.issue_yy%TYPE,
      p_pol_seq_no   giri_distfrps_ext.pol_seq_no%TYPE,
      p_renew_no     giri_distfrps_ext.renew_no%TYPE
   )
      RETURN ri_placement_tab PIPELINED
   IS
      res   ri_placement_type;
   BEGIN
      FOR i IN (SELECT ri_cd, ri_sname, ri_shr_pct, ri_tsi_amt, ri_prem_amt
                  FROM giri_distfrps_ext
                 WHERE line_cd = p_line_cd
                   AND subline_cd = p_subline_cd
                   AND iss_cd = p_iss_cd
                   AND issue_yy = p_issue_yy
                   AND pol_seq_no = p_pol_seq_no
                   AND renew_no = p_renew_no)
      LOOP
         res.ri_cd := i.ri_cd;
         res.ri_sname := i.ri_sname;
         res.ri_shr_pct := i.ri_shr_pct;
         res.ri_tsi_amt := i.ri_tsi_amt;
         res.ri_prem_amt := i.ri_prem_amt;

         FOR j IN (SELECT SUM (ri_shr_pct) tot_ri_shr_pct,
                          SUM (ri_tsi_amt) tot_ri_tsi_amt,
                          SUM (ri_prem_amt) tot_ri_prem_amt
                     FROM giri_distfrps_ext
                    WHERE line_cd = p_line_cd
                      AND subline_cd = p_subline_cd
                      AND iss_cd = p_iss_cd
                      AND issue_yy = p_issue_yy
                      AND pol_seq_no = p_pol_seq_no
                      AND renew_no = p_renew_no)
         LOOP
            res.tot_ri_shr_pct := j.tot_ri_shr_pct;
            res.tot_ri_tsi_amt := j.tot_ri_tsi_amt;
            res.tot_ri_prem_amt := j.tot_ri_prem_amt;
         END LOOP;

         PIPE ROW (res);
      END LOOP;
   END;

   FUNCTION get_binders_tg (
      p_ri_cd        giis_reinsurer.ri_cd%TYPE,
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE
   )
      RETURN binders_tab PIPELINED
   IS
      res   binders_type;
   BEGIN
      FOR i IN (SELECT pol.line_cd, pol.subline_cd, pol.iss_cd, pol.issue_yy,
                       pol.pol_seq_no, pol.renew_no, frps.ri_cd, ri.ri_name,
                          bndr.line_cd
                       || '-'
                       || LTRIM (TO_CHAR (bndr.binder_yy, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (bndr.binder_seq_no, '09999'))
                                                                   binder_no,
                       frps.ri_shr_pct, frps.ri_tsi_amt, frps.ri_prem_amt
                  FROM gipi_polbasic pol,
                       giuw_pol_dist dst,
                       giri_distfrps dfr,
                       giri_frps_ri frps,
                       giri_binder bndr,
                       giis_reinsurer ri
                 WHERE 1 = 1
                   AND pol.pol_flag IN ('1', '2', '3', 'X')
                   AND dst.policy_id = pol.policy_id
                   AND dst.dist_flag = '3'
                   AND dst.dist_no = dfr.dist_no
                   AND dfr.line_cd = pol.line_cd
                   AND dfr.line_cd = frps.line_cd
                   AND dfr.frps_yy = frps.frps_yy
                   AND dfr.frps_seq_no = frps.frps_seq_no
                   AND frps.ri_cd = ri.ri_cd
                   AND frps.fnl_binder_id = bndr.fnl_binder_id
                   AND NVL (frps.reverse_sw, 'N') <> 'Y'
                   AND ri.ri_cd = p_ri_cd
                   AND pol.line_cd = p_line_cd
                   AND pol.subline_cd = p_subline_cd
                   AND pol.iss_cd = p_iss_cd
                   AND pol.issue_yy = p_issue_yy
                   AND pol.pol_seq_no = p_pol_seq_no
                   AND pol.renew_no = p_renew_no)
      LOOP
         res.binder_no := i.binder_no;
         res.ri_name := i.ri_name;
         res.ri_shr_pct := i.ri_shr_pct;
         res.ri_tsi_amt := i.ri_tsi_amt;
         res.ri_prem_amt := i.ri_prem_amt;

         FOR j IN (SELECT SUM (frps.ri_shr_pct) tot_ri_shr_pct,
                          SUM (frps.ri_tsi_amt) tot_ri_tsi_amt,
                          SUM (frps.ri_prem_amt) tot_ri_prem_amt
                     FROM gipi_polbasic pol,
                          giuw_pol_dist dst,
                          giri_distfrps dfr,
                          giri_frps_ri frps,
                          giri_binder bndr,
                          giis_reinsurer ri
                    WHERE 1 = 1
                      AND pol.pol_flag IN ('1', '2', '3', 'X')
                      AND dst.policy_id = pol.policy_id
                      AND dst.dist_flag = '3'
                      AND dst.dist_no = dfr.dist_no
                      AND dfr.line_cd = pol.line_cd
                      AND dfr.line_cd = frps.line_cd
                      AND dfr.frps_yy = frps.frps_yy
                      AND dfr.frps_seq_no = frps.frps_seq_no
                      AND frps.ri_cd = ri.ri_cd
                      AND frps.fnl_binder_id = bndr.fnl_binder_id
                      AND NVL (frps.reverse_sw, 'N') <> 'Y'
                      AND ri.ri_cd = p_ri_cd
                      AND pol.line_cd = p_line_cd
                      AND pol.subline_cd = p_subline_cd
                      AND pol.iss_cd = p_iss_cd
                      AND pol.issue_yy = p_issue_yy
                      AND pol.pol_seq_no = p_pol_seq_no
                      AND pol.renew_no = p_renew_no)
         LOOP
            res.tot_ri_shr_pct := j.tot_ri_shr_pct;
            res.tot_ri_tsi_amt := j.tot_ri_tsi_amt;
            res.tot_ri_prem_amt := j.tot_ri_prem_amt;
         END LOOP;

         PIPE ROW (res);
      END LOOP;
   END;

   FUNCTION get_dist_item_tg (
      p_line_cd      giuw_itemds_ext.line_cd%TYPE,
      p_subline_cd   giuw_itemds_ext.subline_cd%TYPE,
      p_iss_cd       giuw_itemds_ext.iss_cd%TYPE,
      p_issue_yy     giuw_itemds_ext.issue_yy%TYPE,
      p_pol_seq_no   giuw_itemds_ext.pol_seq_no%TYPE,
      p_renew_no     giuw_itemds_ext.renew_no%TYPE
   )
      RETURN dist_item_tab PIPELINED
   IS
      res   dist_item_type;
   BEGIN
      FOR i IN (SELECT DISTINCT    line_cd
                                || '-'
                                || subline_cd
                                || '-'
                                || iss_cd
                                || '-'
                                || LTRIM (TO_CHAR (issue_yy, '09'))
                                || '-'
                                || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
                                || '-'
                                || LTRIM (TO_CHAR (renew_no, '09'))
                                                                   policy_no,
                                item_no
                           FROM giuw_itemds_ext
                          WHERE line_cd = p_line_cd
                            AND subline_cd = p_subline_cd
                            AND iss_cd = p_iss_cd
                            AND issue_yy = p_issue_yy
                            AND pol_seq_no = p_pol_seq_no
                            AND renew_no = p_renew_no)
      LOOP
         res.policy_no := i.policy_no;
         res.item_no := i.item_no;
         PIPE ROW (res);
      END LOOP;
   END;

   FUNCTION get_dist_per_item_tg (
      p_line_cd      giuw_itemds_ext.line_cd%TYPE,
      p_subline_cd   giuw_itemds_ext.subline_cd%TYPE,
      p_iss_cd       giuw_itemds_ext.iss_cd%TYPE,
      p_issue_yy     giuw_itemds_ext.issue_yy%TYPE,
      p_pol_seq_no   giuw_itemds_ext.pol_seq_no%TYPE,
      p_renew_no     giuw_itemds_ext.renew_no%TYPE,
      p_item_no      giuw_itemds_ext.item_no%TYPE
   )
      RETURN dist_per_item_tab PIPELINED
   IS
      res   dist_per_item_type;
   BEGIN
      FOR i IN (SELECT    line_cd
                       || '-'
                       || subline_cd
                       || '-'
                       || iss_cd
                       || '-'
                       || LTRIM (TO_CHAR (issue_yy, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
                       || '-'
                       || LTRIM (TO_CHAR (renew_no, '09')) policy_no,
                       item_no, trty_name, tsi_spct, dist_tsi, prem_spct,
                       dist_prem
                  FROM giuw_itemds_ext
                 WHERE line_cd = p_line_cd
                   AND subline_cd = p_subline_cd
                   AND iss_cd = p_iss_cd
                   AND issue_yy = p_issue_yy
                   AND pol_seq_no = p_pol_seq_no
                   AND renew_no = p_renew_no
                   AND item_no = p_item_no)
      LOOP
         res.policy_no := i.policy_no;
         res.item_no := i.item_no;
         res.trty_name := i.trty_name;
         res.tsi_spct := i.tsi_spct;
         res.dist_tsi := i.dist_tsi;
         res.prem_spct := i.prem_spct;
         res.dist_prem := i.dist_prem;

         FOR j IN (SELECT SUM (tsi_spct) tot_tsi_spct,
                          SUM (dist_tsi) tot_dist_tsi,
                          SUM (prem_spct) tot_prem_spct,
                          SUM (dist_prem) tot_dist_prem
                     FROM giuw_itemds_ext
                    WHERE line_cd = p_line_cd
                      AND subline_cd = p_subline_cd
                      AND iss_cd = p_iss_cd
                      AND issue_yy = p_issue_yy
                      AND pol_seq_no = p_pol_seq_no
                      AND renew_no = p_renew_no
                      AND item_no = p_item_no)
         LOOP
            res.tot_tsi_spct := j.tot_tsi_spct;
            res.tot_dist_tsi := j.tot_dist_tsi;
            res.tot_prem_spct := j.tot_prem_spct;
            res.tot_dist_prem := j.tot_dist_prem;
         END LOOP;

         PIPE ROW (res);
      END LOOP;
   END;

   FUNCTION get_dist_peril_tg (
      p_line_cd      giuw_itemperilds_ext.line_cd%TYPE,
      p_subline_cd   giuw_itemperilds_ext.subline_cd%TYPE,
      p_iss_cd       giuw_itemperilds_ext.iss_cd%TYPE,
      p_issue_yy     giuw_itemperilds_ext.issue_yy%TYPE,
      p_pol_seq_no   giuw_itemperilds_ext.pol_seq_no%TYPE,
      p_renew_no     giuw_itemperilds_ext.renew_no%TYPE
   )
      RETURN dist_peril_tab PIPELINED
   IS
      res   dist_peril_type;
   BEGIN
      FOR i IN (SELECT DISTINCT    line_cd
                                || '-'
                                || subline_cd
                                || '-'
                                || iss_cd
                                || '-'
                                || LTRIM (TO_CHAR (issue_yy, '09'))
                                || '-'
                                || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
                                || '-'
                                || LTRIM (TO_CHAR (renew_no, '09'))
                                                                   policy_no,
                                peril_name, peril_cd
                           FROM giuw_itemperilds_ext
                          WHERE line_cd = p_line_cd
                            AND subline_cd = p_subline_cd
                            AND iss_cd = p_iss_cd
                            AND issue_yy = p_issue_yy
                            AND pol_seq_no = p_pol_seq_no
                            AND renew_no = p_renew_no)
      LOOP
         res.policy_no := i.policy_no;
         res.peril_name := i.peril_name;
         res.peril_cd := i.peril_cd;

         FOR j IN (SELECT SUM (dist_tsi) tot_dist_tsi,
                          SUM (dist_prem) tot_dist_prem
                     FROM giuw_itemperilds_ext
                    WHERE line_cd = p_line_cd
                      AND subline_cd = p_subline_cd
                      AND iss_cd = p_iss_cd
                      AND issue_yy = p_issue_yy
                      AND pol_seq_no = p_pol_seq_no
                      AND renew_no = p_renew_no)
         LOOP
            res.tot_dist_tsi := j.tot_dist_tsi;
            res.tot_dist_prem := j.tot_dist_prem;
         END LOOP;

         PIPE ROW (res);
      END LOOP;
   END;

   FUNCTION get_dist_per_peril_tg (
      p_line_cd      giuw_itemperilds_ext.line_cd%TYPE,
      p_subline_cd   giuw_itemperilds_ext.subline_cd%TYPE,
      p_iss_cd       giuw_itemperilds_ext.iss_cd%TYPE,
      p_issue_yy     giuw_itemperilds_ext.issue_yy%TYPE,
      p_pol_seq_no   giuw_itemperilds_ext.pol_seq_no%TYPE,
      p_renew_no     giuw_itemperilds_ext.renew_no%TYPE,
      p_peril_cd     giuw_itemperilds_ext.peril_cd%TYPE
   )
      RETURN dist_per_peril_tab PIPELINED
   IS
      res   dist_per_peril_type;
   BEGIN
      FOR i IN (SELECT    line_cd
                       || '-'
                       || subline_cd
                       || '-'
                       || iss_cd
                       || '-'
                       || LTRIM (TO_CHAR (issue_yy, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
                       || '-'
                       || LTRIM (TO_CHAR (renew_no, '09')) policy_no,
                       peril_name, trty_name, tsi_spct, dist_tsi, prem_spct,
                       dist_prem
                  FROM giuw_itemperilds_ext
                 WHERE line_cd = p_line_cd
                   AND subline_cd = p_subline_cd
                   AND iss_cd = p_iss_cd
                   AND issue_yy = p_issue_yy
                   AND pol_seq_no = p_pol_seq_no
                   AND renew_no = p_renew_no
                   AND peril_cd = p_peril_cd)
      LOOP
         res.policy_no := i.policy_no;
         res.peril_name := i.peril_name;
         res.trty_name := i.trty_name;
         res.tsi_spct := i.tsi_spct;
         res.dist_tsi := i.dist_tsi;
         res.prem_spct := i.prem_spct;
         res.dist_prem := i.dist_prem;

         FOR j IN (SELECT SUM (tsi_spct) tot_tsi_spct,
                          SUM (dist_tsi) tot_dist_tsi,
                          SUM (prem_spct) tot_prem_spct,
                          SUM (dist_prem) tot_dist_prem
                     FROM giuw_itemperilds_ext
                    WHERE line_cd = p_line_cd
                      AND subline_cd = p_subline_cd
                      AND iss_cd = p_iss_cd
                      AND issue_yy = p_issue_yy
                      AND pol_seq_no = p_pol_seq_no
                      AND renew_no = p_renew_no
                      AND peril_cd = p_peril_cd)
         LOOP
            res.tot_tsi_spct := j.tot_tsi_spct;
            res.tot_dist_tsi := j.tot_dist_tsi;
            res.tot_prem_spct := j.tot_prem_spct;
            res.tot_dist_prem := j.tot_dist_prem;
         END LOOP;

         PIPE ROW (res);
      END LOOP;
   END;

   PROCEDURE insert_to_policyds_dtl (
      p_share_cd      NUMBER,
      p_dist_spct     NUMBER,
      p_dist_spct1    NUMBER,
      p_dist_no       giuw_wpolicyds_dtl.dist_no%TYPE,
      p_dist_seq_no   giuw_wpolicyds_dtl.dist_seq_no%TYPE,
      p_line_cd       giuw_policyds_ext.line_cd%TYPE
   )
   IS
   BEGIN
      FOR pol IN (SELECT tsi_amt, ann_tsi_amt, prem_amt, item_grp
                    FROM giuw_wpolicyds
                   WHERE dist_no = p_dist_no AND dist_seq_no = p_dist_seq_no)
      LOOP
         INSERT INTO giuw_wpolicyds_dtl
                     (dist_no, dist_seq_no, line_cd, share_cd,
                      dist_spct, dist_tsi,
                      dist_prem,
                      ann_dist_spct, ann_dist_tsi,
                      dist_grp, dist_spct1
                     )
              VALUES (p_dist_no, p_dist_seq_no, p_line_cd, p_share_cd,
                      p_dist_spct, p_dist_spct / 100 * pol.tsi_amt,
                      NVL (p_dist_spct1, p_dist_spct) / 100 * pol.prem_amt,
                      p_dist_spct, p_dist_spct / 100 * pol.ann_tsi_amt,
                      pol.item_grp, p_dist_spct1
                     );
      END LOOP;
   END;

   PROCEDURE insert_to_itemds_dtl (
      p_share_cd      NUMBER,
      p_dist_spct     NUMBER,
      p_dist_spct1    NUMBER,
      p_dist_no       giuw_wpolicyds_dtl.dist_no%TYPE,
      p_dist_seq_no   giuw_wpolicyds_dtl.dist_seq_no%TYPE,
      p_line_cd       giuw_policyds_ext.line_cd%TYPE
   )
   IS
   BEGIN
      FOR itm IN (SELECT tsi_amt, ann_tsi_amt, prem_amt, item_no
                    FROM giuw_witemds
                   WHERE dist_no = p_dist_no AND dist_seq_no = p_dist_seq_no)
      LOOP
         INSERT INTO giuw_witemds_dtl
                     (dist_no, dist_seq_no, item_no, line_cd,
                      share_cd, dist_spct,
                      dist_tsi,
                      dist_prem,
                      ann_dist_spct, ann_dist_tsi, dist_grp,
                      dist_spct1
                     )
              VALUES (p_dist_no, p_dist_seq_no, itm.item_no, p_line_cd,
                      p_share_cd, p_dist_spct,
                      p_dist_spct / 100 * itm.tsi_amt,
                      NVL (p_dist_spct1, p_dist_spct) / 100 * itm.prem_amt,
                      p_dist_spct, p_dist_spct / 100 * itm.ann_tsi_amt, 1,
                      p_dist_spct1
                     );
      END LOOP;
   END;

   PROCEDURE insert_to_itemperilds_dtl (
      p_share_cd      NUMBER,
      p_dist_spct     NUMBER,
      p_dist_spct1    NUMBER,
      p_dist_no       giuw_wpolicyds_dtl.dist_no%TYPE,
      p_dist_seq_no   giuw_wpolicyds_dtl.dist_seq_no%TYPE
   )
   IS
   BEGIN
      FOR prl IN (SELECT line_cd, tsi_amt, prem_amt, ann_tsi_amt, item_no,
                         peril_cd
                    FROM giuw_witemperilds
                   WHERE dist_no = p_dist_no AND dist_seq_no = p_dist_seq_no)
      LOOP
         INSERT INTO giuw_witemperilds_dtl
                     (dist_no, dist_seq_no, item_no, line_cd,
                      peril_cd, share_cd, dist_spct,
                      dist_tsi,
                      dist_prem,
                      ann_dist_spct, ann_dist_tsi, dist_grp,
                      dist_spct1
                     )
              VALUES (p_dist_no, p_dist_seq_no, prl.item_no, prl.line_cd,
                      prl.peril_cd, p_share_cd, p_dist_spct,
                      p_dist_spct / 100 * prl.tsi_amt,
                      NVL (p_dist_spct1, p_dist_spct) / 100 * prl.prem_amt,
                      p_dist_spct, p_dist_spct / 100 * prl.ann_tsi_amt, 1,
                      p_dist_spct1
                     );
      END LOOP;
   END;

   PROCEDURE insert_to_wperilds_dtl (
      p_share_cd      NUMBER,
      p_dist_spct     NUMBER,
      p_dist_spct1    NUMBER,
      p_dist_no       giuw_wpolicyds_dtl.dist_no%TYPE,
      p_dist_seq_no   giuw_wpolicyds_dtl.dist_seq_no%TYPE
   )
   IS
   BEGIN
      FOR prl IN (SELECT peril_cd, line_cd, tsi_amt, prem_amt, ann_tsi_amt
                    FROM giuw_wperilds
                   WHERE dist_no = p_dist_no AND dist_seq_no = p_dist_seq_no)
      LOOP
         INSERT INTO giuw_wperilds_dtl
                     (dist_no, dist_seq_no, line_cd, peril_cd,
                      share_cd, dist_spct,
                      dist_tsi,
                      dist_prem,
                      ann_dist_spct, ann_dist_tsi, dist_grp,
                      dist_spct1
                     )
              VALUES (p_dist_no, p_dist_seq_no, prl.line_cd, prl.peril_cd,
                      p_share_cd, p_dist_spct,
                      p_dist_spct / 100 * prl.tsi_amt,
                      NVL (p_dist_spct1, p_dist_spct) / 100 * prl.prem_amt,
                      p_dist_spct, p_dist_spct / 100 * prl.ann_tsi_amt, 1,
                      p_dist_spct1
                     );
      END LOOP;
   END;

   PROCEDURE insert_summ_dist (
      p_line_cd       IN       giuw_policyds_ext.line_cd%TYPE,
      p_subline_cd    IN       giuw_policyds_ext.subline_cd%TYPE,
      p_iss_cd        IN       giuw_policyds_ext.iss_cd%TYPE,
      p_issue_yy      IN       giuw_policyds_ext.issue_yy%TYPE,
      p_pol_seq_no    IN       giuw_policyds_ext.pol_seq_no%TYPE,
      p_renew_no      IN       giuw_policyds_ext.renew_no%TYPE,
      p_dist_no       IN       giuw_wpolicyds_dtl.dist_no%TYPE,
      p_dist_seq_no   IN       giuw_wpolicyds_dtl.dist_seq_no%TYPE,
      p_message       OUT      VARCHAR2
   )
   IS
   v_cnt number := 0;
   BEGIN
      DELETE FROM giuw_wpolicyds_dtl
            WHERE dist_no = p_dist_no AND dist_seq_no = p_dist_seq_no;

      DELETE FROM giuw_witemds_dtl
            WHERE dist_no = p_dist_no AND dist_seq_no = p_dist_seq_no;

      DELETE FROM giuw_witemperilds_dtl
            WHERE dist_no = p_dist_no AND dist_seq_no = p_dist_seq_no;

      DELETE FROM giuw_wperilds_dtl
            WHERE dist_no = p_dist_no AND dist_seq_no = p_dist_seq_no;
--            raise_application_error (-20001,' p_line_cd='||p_line_cd||
--                                            ' p_subline_cd='||p_subline_cd||
--                                            ' p_iss_cd='||p_iss_cd||
--                                            ' p_issue_yy='||p_issue_yy||
--                                            ' p_pol_seq_no='||p_pol_seq_no||
--                                            ' p_renew_no='||p_renew_no||
--                                            ' p_dist_no='||p_dist_no||
--                                            ' p_dist_seq_no='||p_dist_seq_no);

      FOR ext IN (SELECT share_cd, tsi_spct dist_spct,
                         NVL (prem_spct, tsi_spct) dist_spct1
                    FROM giuw_policyds_ext
                   WHERE line_cd = p_line_cd
                     AND subline_cd = p_subline_cd
                     AND iss_cd = p_iss_cd
                     AND issue_yy = p_issue_yy
                     AND pol_seq_no = p_pol_seq_no
                     AND renew_no = p_renew_no)
      LOOP
      v_cnt := v_cnt+1;
         gipis130_pkg.insert_to_policyds_dtl (ext.share_cd,
                                 ext.dist_spct,
                                 ext.dist_spct1,
                                 p_dist_no,
                                 p_dist_seq_no,
                                 p_line_cd
                                );
         gipis130_pkg.insert_to_itemds_dtl (ext.share_cd,
                               ext.dist_spct,
                               ext.dist_spct1,
                               p_dist_no,
                               p_dist_seq_no,
                               p_line_cd
                              );
         gipis130_pkg.insert_to_itemperilds_dtl (ext.share_cd,
                                    ext.dist_spct,
                                    ext.dist_spct1,
                                    p_dist_no,
                                    p_dist_seq_no
                                   );
         gipis130_pkg.insert_to_wperilds_dtl (ext.share_cd,
                                 ext.dist_spct,
                                 ext.dist_spct1,
                                 p_dist_no,
                                 p_dist_seq_no
                                );
      END LOOP;
       --raise_application_error (-20001,'v_cnt='||v_cnt);
      p_message := 'SUCCESS';
   END;

   FUNCTION get_linecd_lov (
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_keyword     VARCHAR2
   )
      RETURN line_cd_lov_tab PIPELINED
   IS
      v_rec   line_cd_lov_type;
   BEGIN
      FOR i IN (SELECT   line_cd line_cd, line_name line_name
                    FROM giis_line
                   WHERE line_cd =
                            DECODE (check_user_per_line2 (line_cd,
                                                          NULL,
                                                          p_module_id,
                                                          p_user_id
                                                         ),
                                    1, line_cd,
                                    NULL
                                   )
                     AND (   UPPER (line_cd) LIKE
                                 '%' || UPPER (NVL (p_keyword, line_cd))
                                 || '%'
                          OR UPPER (line_name) LIKE
                                '%' || UPPER (NVL (p_keyword, line_name))
                                || '%'
                         )
                ORDER BY 1)
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.line_name := i.line_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_linecd_lov;
END;
/


