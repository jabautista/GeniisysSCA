CREATE OR REPLACE PACKAGE BODY CPI.giuts028_pkg
AS
    /* Created by Joms Diago
   ** 07.25.2013
   */
   FUNCTION when_new_form_giuts028
      RETURN when_new_form_giuts028_tab PIPELINED
   IS
      v_rec   when_new_form_giuts028_type;
   BEGIN
      FOR i IN (SELECT param_value_v
                  FROM giac_parameters
                 WHERE param_name = 'ALLOW_SPOILAGE')
      LOOP
         v_rec.allow_spoilage := i.param_value_v;
         EXIT;
      END LOOP;

      v_rec.v_iss_cd_param := giacp.v ('BRANCH_CD');
      v_rec.v_ho := giisp.v ('ISS_CD_HO');
      v_rec.v_restrict := giisp.v ('RESTRICT_SPOIL_OF_REC_WACCT_ENT_DATE');
      v_rec.v_subline := giisp.v ('SUBLINE_MN_MOP');
      --v_rec.v_renew := giisp.v ('ALLOW_REINSTATEMENT_WRENEW_POL'); --benjo 09.03.2015 cpmment out
      PIPE ROW (v_rec);
   END when_new_form_giuts028;

   FUNCTION get_policy_giuts028_lov (p_user_id giis_users.user_id%TYPE,
   --added by pjsantos 10/27/2016, for optimization GENQA 5807
   p_filter_line_cd     VARCHAR2,
   p_filter_subline_cd  VARCHAR2,
   p_filter_iss_cd      VARCHAR2,
   p_filter_issue_yy    NUMBER,
   p_filter_pol_seq_no  NUMBER,
   p_filter_renew_no    NUMBER,
   p_find_text          VARCHAR2,
   p_order_by           VARCHAR2,      
   p_asc_desc_flag      VARCHAR2,      
   p_first_row          NUMBER,        
   p_last_row           NUMBER)
   --pjsantos end
      RETURN get_policy_giuts028_lov_tab PIPELINED
   AS
      res   get_policy_giuts028_lov_type;
       --added by pjsantos 10/27/2016, for optimization GENQA 5807
      TYPE cur_type IS REF CURSOR;      
      c        cur_type;                
      v_sql    VARCHAR2(32767);  
      --pjsantos end       
   BEGIN
   /*Modified by pjsantos 10/27/2016, for optimization GENQA 5807*/
     -- FOR i IN (
      v_sql :=  'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (SELECT   a.policy_id,
                            a.line_cd
                         || ''-''
                         || a.subline_cd
                         || ''-''
                         || a.iss_cd
                         || ''-''
                         || LTRIM (TO_CHAR (a.issue_yy, ''09''))
                         || ''-''
                         || LTRIM (TO_CHAR (a.pol_seq_no, ''0999999''))
                         || ''-''
                         || LTRIM (TO_CHAR (a.renew_no, ''09'')) policy_no,
                         b.assd_name, a.line_cd, a.subline_cd, a.iss_cd,
                         a.issue_yy, a.pol_seq_no, a.renew_no,
                         a.pack_policy_id, a.pol_flag, a.old_pol_flag,
                         (SELECT DECODE(z.pol_flag, ''4'', ''Y'', ''N'') is_cancelled
                        FROM gipi_polbasic z
                       WHERE z.pack_policy_id = a.pack_policy_id
                         AND ROWNUM = 1) is_cancelled,
                       (  SELECT z.line_cd
                            || ''-''
                            || z.subline_cd
                            || ''-''
                            || z.iss_cd
                            || ''-''
                            || LTRIM (TO_CHAR (z.issue_yy, ''09''))
                            || ''-''
                            || LTRIM (TO_CHAR (z.pol_seq_no, ''0999999''))
                            || ''-''
                            || LTRIM (TO_CHAR (z.renew_no, ''09'')) policy_no
                            FROM gipi_pack_polbasic z
                           WHERE z.pack_policy_id = a.pack_policy_id
                             AND ROWNUM = 1)   pack_policy_no                    
                      FROM gipi_polbasic a, giis_assured b
                   WHERE a.assd_no = b.assd_no ';
                    /* AND check_user_per_iss_cd2 (a.line_cd,
                                                 NVL (NULL, a.iss_cd),
                                                 'GIUTS028',
                                                 p_user_id
                                                ) = 1
                     AND check_user_per_line2 (a.line_cd,
                                               NVL (NULL, a.iss_cd),
                                               'GIUTS028',
                                               p_user_id
                                              ) = 1*/
                     v_sql := v_sql ||' AND EXISTS (SELECT ''X''
                                 FROM TABLE (security_access.get_branch_line (''UW'', ''GIUTS028'', :p_user_id))
                                WHERE branch_cd = a.iss_cd AND a.line_cd = line_cd)
                     AND a.endt_seq_no = 0
                     AND a.pol_flag = ''4'' ';
                
        IF p_filter_line_cd IS NOT NULL
          THEN
            v_sql := v_sql || ' AND line_cd = ''' || REPLACE(p_filter_line_cd,'''','''''') ||''' ';
        END IF;
        IF p_filter_subline_cd IS NOT NULL
          THEN
            v_sql := v_sql || ' AND subline_cd = ''' || REPLACE(p_filter_subline_cd,'''','''''')|| ''' ';
        END IF;
        IF p_filter_iss_cd IS NOT NULL
          THEN
            v_sql := v_sql || ' AND iss_cd = ''' || REPLACE(p_filter_iss_cd,'''','''''') || ''' ';
        END IF;
        IF p_filter_issue_yy IS NOT NULL
          THEN
            v_sql := v_sql || ' AND issue_yy = ' || p_filter_issue_yy || ' ';
        END IF;
        IF p_filter_pol_seq_no IS NOT NULL
          THEN
            v_sql := v_sql || ' AND pol_seq_no = ' || p_filter_pol_seq_no || ' ';
        END IF;
        IF p_filter_renew_no IS NOT NULL
          THEN
            v_sql := v_sql || '  AND renew_no = ' || p_filter_renew_no|| ' ';
        END IF;                 
                   
        IF p_find_text IS NOT NULL
          THEN
            v_sql := v_sql || ' AND (UPPER(a.line_cd|| ''-''|| a.subline_cd|| ''-''|| a.iss_cd|| ''-''|| LTRIM (TO_CHAR (a.issue_yy, ''09''))
                                            || ''-''|| LTRIM (TO_CHAR (a.pol_seq_no, ''0999999''))|| ''-''|| LTRIM (TO_CHAR (a.renew_no, ''09'')))
                                             LIKE UPPER(''' || REPLACE(p_find_text,'''','''''') || ''') 
                                     OR UPPER(assd_name) LIKE UPPER(''' || REPLACE(p_find_text,'''','''''')||''')) ';
        END IF;             
                  
              
                
    IF p_order_by IS NOT NULL
      THEN
        IF p_order_by = 'policyNo'
         THEN        
          v_sql := v_sql || ' ORDER BY policy_no ';
        ELSIF  p_order_by = 'assdName'
         THEN
          v_sql := v_sql || ' ORDER BY assd_name ';               
        END IF;
        
        IF p_asc_desc_flag IS NOT NULL
        THEN
           v_sql := v_sql || p_asc_desc_flag;
        ELSE
           v_sql := v_sql || ' ASC';
        END IF; 
    ELSE
       v_sql := v_sql || ' ORDER BY policy_no, assd_name ';
    END IF;
    
    v_sql := v_sql || ') innersql) outersql) mainsql WHERE rownum_ BETWEEN '|| p_first_row ||' AND ' || p_last_row;
    
      OPEN c FOR v_sql USING  p_user_id;
      LOOP
        FETCH c INTO 
         res.count_,
         res.rownum_,
         res.policy_id ,
         res.policy_no ,
         res.assd_name ,
         res.line_cd ,
         res.subline_cd ,
         res.iss_cd ,
         res.issue_yy ,
         res.pol_seq_no ,
         res.renew_no ,
         res.pack_policy_id ,
         res.pol_flag ,
         res.old_pol_flag,
         res.is_cancelled,
         res.pack_policy_no;
      /* comment out by pjsantos 10/27/2016, for optimization GENQA 5807
         res.policy_id := i.policy_id;
         res.policy_no := i.policy_no;
         res.assd_name := i.assd_name;
         res.line_cd := i.line_cd;
         res.subline_cd := i.subline_cd;
         res.iss_cd := i.iss_cd;
         res.issue_yy := i.issue_yy;
         res.pol_seq_no := i.pol_seq_no;
         res.renew_no := i.renew_no;
         res.pack_policy_id := i.pack_policy_id;
         res.pol_flag := i.pol_flag;
         res.old_pol_flag := i.old_pol_flag;
        
         BEGIN
            FOR j IN (SELECT pol_flag
                        FROM gipi_polbasic
                       WHERE pack_policy_id = i.pack_policy_id)
            LOOP
               IF j.pol_flag <> '4' -- Dren 09.30.2015 SR 0020496 : Fix character being compared to number.
               THEN
                  res.is_cancelled := 'N';
               ELSE
                  res.is_cancelled := 'Y';
               END IF;
            END LOOP;
         END;

         BEGIN
            SELECT    a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (a.issue_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                   || '-'
                   || LTRIM (TO_CHAR (a.renew_no, '09')) policy_no
              INTO res.pack_policy_no
              FROM gipi_pack_polbasic a
             WHERE a.pack_policy_id = i.pack_policy_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               res.pack_policy_no := '';
         END;*/

         EXIT WHEN c%NOTFOUND;              
         PIPE ROW (res);
      END LOOP;      
      CLOSE c; 
      RETURN; 
   END get_policy_giuts028_lov;

   FUNCTION get_reinstatement_hist (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN reinstatement_hist_tab PIPELINED
   IS
      v_rec   reinstatement_hist_type;
   BEGIN
      FOR i IN (SELECT hist_id, max_endt_seq_no, user_id, last_update
                  FROM gipi_reinstate_hist
                 WHERE policy_id = p_policy_id)
      LOOP
         v_rec.hist_id := i.hist_id;
         v_rec.max_endt_seq_no := i.max_endt_seq_no;
         v_rec.user_id := i.user_id;
         v_rec.last_update := i.last_update;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_reinstatement_hist;

   FUNCTION validate_giuts028_endt_rec (
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_iss_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE,
      p_policy_id    gipi_polbasic.policy_id%TYPE
   )
      RETURN validate_endt_rec_tab PIPELINED
   IS
      v_rec   validate_endt_rec_type;
   BEGIN
      FOR i IN (SELECT   policy_id, acct_ent_date, spld_flag, endt_seq_no
                    FROM gipi_polbasic a
                   WHERE line_cd = p_line_cd
                     AND subline_cd = p_subline_cd
                     AND iss_cd = p_iss_cd
                     AND issue_yy = p_iss_yy
                     AND pol_seq_no = p_pol_seq_no
                     AND renew_no = p_renew_no
                     AND pol_flag = '4'
                     AND policy_id <> p_policy_id
                ORDER BY endt_seq_no DESC)
      LOOP
         v_rec.v_cancel_policy := i.policy_id;
         v_rec.v_acct_ent_date := TO_CHAR (i.acct_ent_date, 'MM-DD-YYYY');--TO_DATE (i.acct_ent_date, 'MM-DD-RRRR');
         v_rec.v_spld_flag := i.spld_flag;
         v_rec.v_max_endt := i.endt_seq_no;

         BEGIN
            SELECT ho_tag
              INTO v_rec.v_sw
              FROM giis_issource
             WHERE iss_cd = p_iss_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.v_sw := 'X';
         END;

         PIPE ROW (v_rec);
         EXIT;
      END LOOP;

      RETURN;
   END validate_giuts028_endt_rec;

   PROCEDURE check_paid_policy (
      p_policy_id   IN       gipi_polbasic.policy_id%TYPE,
      p_iss_cd      IN       gipi_polbasic.iss_cd%TYPE,
      p_msge1       OUT      VARCHAR2,
      p_msge2       OUT      VARCHAR2,
      p_msge3       OUT      VARCHAR2
   )
   IS
      v_policy_id         gipi_invoice.policy_id%TYPE;
      v_ri                gipi_polbasic.iss_cd%TYPE  := giisp.v ('ISS_CD_RI');
      v_prem_coll         giac_inwfacul_prem_collns.collection_amt%TYPE;
      v_iss_cd            gipi_polbasic.iss_cd%TYPE               := p_iss_cd;
      v_policy_id_param   gipi_invoice.policy_id%TYPE          := p_policy_id;
   BEGIN
      IF v_iss_cd != v_ri
      THEN
         FOR a1 IN (SELECT a.policy_id policy_id
                      FROM gipi_invoice a, giac_aging_soa_details b
                     WHERE a.policy_id = v_policy_id_param
                       AND a.iss_cd = b.iss_cd
                       AND a.prem_seq_no = b.prem_seq_no
                       AND b.total_amount_due != b.balance_amt_due)
         LOOP
            v_policy_id := a1.policy_id;
            EXIT;
         END LOOP;

         IF v_policy_id IS NOT NULL
         THEN
            p_msge1 :=
               'Please reverse the payment for the policy before reinstatement.';
            p_msge2 := 'I';
            p_msge3 := 'FALSE';
         END IF;
      END IF;

      IF v_iss_cd = v_ri
      THEN
         FOR a1 IN (SELECT a.policy_id policy_id
                      FROM gipi_invoice a, giac_aging_ri_soa_details b
                     WHERE a.policy_id = v_policy_id_param
                       AND b.gagp_aging_id >= 0
                       AND a.iss_cd = v_ri
                       AND a.prem_seq_no = b.prem_seq_no
                       AND b.total_amount_due != b.balance_due)
         LOOP
            IF NVL (a1.policy_id, 0) != 0
            THEN
               p_msge1 :=
                     'Policy has collection(s) already from Cedant. '
                  || 'Reverse the collections first before reinstating the policy.';
               p_msge2 := 'I';
               p_msge3 := 'FALSE';
            END IF;

            EXIT;
         END LOOP;
      END IF;
   END check_paid_policy;

   PROCEDURE check_reinsurance_payment (
      p_policy_id   IN       gipi_polbasic.policy_id%TYPE,
      p_line_cd     IN       gipi_polbasic.line_cd%TYPE,
      p_msge1       OUT      VARCHAR2,
      p_msge2       OUT      VARCHAR2,
      p_msge3       OUT      VARCHAR2
   )
   IS
      v_param_value_n     giis_parameters.param_value_n%TYPE
                                                   := giisp.n ('FACULTATIVE');
      v_policy_id_param   gipi_invoice.policy_id%TYPE          := p_policy_id;
      v_line_cd           gipi_polbasic.line_cd%TYPE           := p_line_cd;
   BEGIN
      IF v_param_value_n IS NOT NULL
      THEN
         FOR a2 IN (SELECT a.dist_no dist_no, a.dist_seq_no dist_seq_no,
                           a.line_cd line_cd, a.share_cd share_cd
                      FROM giuw_pol_dist c,
                           giuw_policyds_dtl a,
                           giuw_policyds b
                     WHERE c.policy_id = v_policy_id_param
                       AND c.dist_no = b.dist_no
                       AND c.negate_date IS NULL
                       AND a.dist_no = b.dist_no
                       AND a.dist_seq_no = b.dist_seq_no
                       AND a.line_cd = v_line_cd
                       AND a.share_cd = v_param_value_n)
         LOOP
            FOR a3 IN (SELECT c.fnl_binder_id, b.ri_cd
                         FROM giri_distfrps a, giri_frps_ri b, giri_binder c
                        WHERE a.dist_no = a2.dist_no
                          AND a.dist_seq_no = a2.dist_seq_no
                          AND a.frps_yy = b.frps_yy
                          AND a.frps_seq_no = b.frps_seq_no
                          AND b.line_cd = a2.line_cd
                          AND b.fnl_binder_id = c.fnl_binder_id
                          AND c.reverse_date IS NULL)
            LOOP
               FOR a4 IN
                  (SELECT SUM (NVL (a.disbursement_amt, 0)) amt
                     FROM giac_outfacul_prem_payts a, giac_acctrans b
                    WHERE a.a180_ri_cd = a3.ri_cd
                      AND a.d010_fnl_binder_id = a3.fnl_binder_id
                      AND a.gacc_tran_id = b.tran_id
                      AND b.tran_flag <> 'D'
                      AND NOT EXISTS (
                             SELECT '1'
                               FROM giac_reversals c, giac_acctrans d
                              WHERE a.gacc_tran_id = c.gacc_tran_id
                                AND c.reversing_tran_id = d.tran_id
                                AND d.tran_flag <> 'D'))
               LOOP
                  IF a4.amt <> 0
                  THEN
                     p_msge1 :=
                        'This policy has collections from Facultative Reinsurers. Cannot reinstate policy.';
                     p_msge2 := 'I';
                     p_msge3 := 'FALSE';
                     EXIT;
                  END IF;
               END LOOP;
            END LOOP;
         END LOOP;
      END IF;
   END check_reinsurance_payment;

   PROCEDURE check_acct_ent_date (
      p_acct_ent_date         gipi_polbasic.acct_ent_date%TYPE,
      p_restrict              giis_parameters.param_value_v%TYPE,
      p_msge1           OUT   VARCHAR2,
      p_msge2           OUT   VARCHAR2,
      p_msge3           OUT   VARCHAR2
   )
   IS
      v_acct_ent_date   gipi_polbasic.acct_ent_date%TYPE   := p_acct_ent_date;
      v_restrict        giis_parameters.param_value_v%TYPE   := p_restrict;
   BEGIN
      IF v_acct_ent_date IS NOT NULL
      THEN
         IF v_restrict = 'Y'
         THEN
            p_msge1 :=
                  'Policy has been considered in Accounting on '
               || TO_CHAR (v_acct_ent_date, 'fmMonth DD, YYYY')
               || '. Cannot reinstate policy.';
            p_msge2 := 'I';
            p_msge3 := 'FALSE';
         ELSE
            p_msge1 :=
                  'Policy has been considered in Accounting on '
               || TO_CHAR (v_acct_ent_date, 'fmMonth DD, YYYY')
               || '. Please inform Accounting of reinstatement.';
            p_msge2 := 'I';
            p_msge3 := 'TRUE';
         END IF;
      END IF;
   END check_acct_ent_date;

   FUNCTION chk_marine (
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_iss_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE
   )
      RETURN chk_marine_rec_tab PIPELINED
   IS
      v_rec   chk_marine_rec_type;
   BEGIN

      FOR exist IN (SELECT 'a'
                      FROM gipi_wopen_policy
                     WHERE op_subline_cd = p_subline_cd
                       AND op_iss_cd = p_iss_cd
                       AND op_issue_yy = p_iss_yy
                       AND op_pol_seqno = p_pol_seq_no
                       AND op_renew_no = p_renew_no)
      LOOP
         v_rec.v_exist := 'Y';
      END LOOP;

      FOR exist1 IN (SELECT 'a'
                       FROM gipi_open_policy
                      WHERE op_subline_cd = p_subline_cd
                        AND op_iss_cd = p_iss_cd
                        AND op_issue_yy = p_iss_yy
                        AND op_pol_seqno = p_pol_seq_no
                        AND op_renew_no = p_renew_no)
      LOOP
         v_rec.v_exist := 'Y';
      END LOOP;

      FOR mop IN (SELECT subline_cd
                    FROM giis_subline
                   WHERE open_policy_sw = 'Y' AND line_cd = p_line_cd)
      LOOP
         v_rec.v_subline := mop.subline_cd;
         EXIT;
      END LOOP;

      PIPE ROW (v_rec);
      RETURN;
   END chk_marine;

   FUNCTION chk_on_going_endt (
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_iss_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE
   )
      RETURN chk_ongoing_endt_tab PIPELINED
   IS
      v_rec   chk_ongoing_endt_type;
   BEGIN
      FOR a2 IN (SELECT   eff_date, endt_type
                     FROM gipi_wpolbas
                    WHERE line_cd = p_line_cd
                      AND subline_cd = p_subline_cd
                      AND iss_cd = p_iss_cd
                      AND issue_yy = p_iss_yy
                      AND pol_seq_no = p_pol_seq_no
                      AND renew_no = p_renew_no
                 ORDER BY eff_date DESC, endt_seq_no DESC)
      LOOP
         v_rec.v_exist := 'Y';
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END chk_on_going_endt;

   PROCEDURE process_reinstate (
      p_user_id           IN   giis_users.user_id%TYPE,
      p_v_cancel_policy   IN   gipi_polbasic.policy_id%TYPE,
      p_old_pol_flag      IN   gipi_polbasic.old_pol_flag%TYPE,
      p_line_cd           IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd        IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd            IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy          IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no        IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no          IN   gipi_polbasic.renew_no%TYPE,
      p_v_max_endt        IN   gipi_polbasic.endt_seq_no%TYPE,
      p_policy_id         IN   gipi_polbasic.policy_id%TYPE
   )
   IS
   BEGIN
      FOR a2 IN (SELECT dist_no, line_cd
                   FROM giuw_pol_dist a, gipi_polbasic b
                  WHERE a.policy_id = b.policy_id
                    AND a.policy_id = p_v_cancel_policy)
      LOOP
         check_reinsurance (a2.dist_no, a2.line_cd);
      END LOOP;

      FOR a2 IN (SELECT dist_no
                   FROM giuw_pol_dist
                  WHERE policy_id = p_v_cancel_policy)
      LOOP
         UPDATE giuw_pol_dist
            SET negate_date = SYSDATE,
                dist_flag = '4'
          WHERE policy_id = p_v_cancel_policy AND dist_no = a2.dist_no;
      END LOOP;

      UPDATE gipi_polbasic
         SET spld_flag = '3',
             pol_flag = '5',
             spld_date = SYSDATE,
             spld_user_id = p_user_id,
             spld_approval = p_user_id,
             dist_flag = '4',
             user_id = p_user_id,
             last_upd_date = SYSDATE,
             reinstatement_date = SYSDATE
       WHERE policy_id = p_v_cancel_policy;

      UPDATE gipi_polbasic
         SET pol_flag = p_old_pol_flag
       WHERE line_cd = p_line_cd
         AND subline_cd = p_subline_cd
         AND iss_cd = p_iss_cd
         AND issue_yy = p_issue_yy
         AND pol_seq_no = p_pol_seq_no
         AND renew_no = p_renew_no
         AND pol_flag != '5'
         AND policy_id != p_v_cancel_policy;

      UPDATE eim_takeup_info
         SET eim_flag =
                DECODE (eim_flag,
                        NULL, '3',
                        '1', '3',
                        '2', '5',
                        '4', '5',
                        eim_flag
                       )
       WHERE policy_id = p_v_cancel_policy;

      --update_affected_endt (p_line_cd,	--commented out by John Daniel SR-21423
      --                      p_subline_cd,
      --                      p_iss_cd,
      --                      p_issue_yy,
      --                      p_pol_seq_no,
      --                      p_renew_no
      --                     );

      UPDATE gipi_polbasic
         SET eis_flag = 'N'
       WHERE policy_id = p_v_cancel_policy;

      create_history (p_policy_id, p_v_max_endt, p_user_id);

      UPDATE gipi_polbasic
         SET reinstate_tag = 'Y'
       WHERE policy_id = p_v_cancel_policy;
   END process_reinstate;

   PROCEDURE update_affected_endt (
      p_line_cd      IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN   gipi_polbasic.renew_no%TYPE
   )
   IS
      v_comp_prem          gipi_witmperl.tsi_amt%TYPE;
      v_prorate            gipi_witmperl.prem_rt%TYPE;
      v_cancel_policy      gipi_polbasic.policy_id%TYPE;
      v_prorate_flag       gipi_polbasic.prorate_flag%TYPE;
      v_endt_exp_date      gipi_polbasic.endt_expiry_date%TYPE;
      v_eff_date           gipi_polbasic.eff_date%TYPE;
      v_short_rt_percent   gipi_polbasic.short_rt_percent%TYPE;
      v_comp_sw            gipi_polbasic.comp_sw%TYPE;
   BEGIN
      FOR a IN (SELECT   policy_id, prorate_flag, endt_expiry_date, eff_date,
                         short_rt_percent, comp_sw
                    FROM gipi_polbasic
                   WHERE line_cd = p_line_cd
                     AND subline_cd = p_subline_cd
                     AND iss_cd = p_iss_cd
                     AND issue_yy = p_issue_yy
                     AND pol_seq_no = p_pol_seq_no
                     AND renew_no = p_renew_no
                ORDER BY endt_seq_no DESC)
      LOOP
         v_cancel_policy := a.policy_id;
         v_prorate_flag := a.prorate_flag;
         v_endt_exp_date := a.endt_expiry_date;
         v_eff_date := a.eff_date;
         v_short_rt_percent := a.short_rt_percent;
         v_comp_sw := a.comp_sw;
         EXIT;
      END LOOP;

      FOR itmperl IN (SELECT b480.item_no, b480.currency_rt, a170.peril_type,
                             b490.peril_cd, b490.tsi_amt, b490.prem_amt
                        FROM gipi_item b480,
                             giis_peril a170,
                             gipi_itmperil b490
                       WHERE b480.policy_id = b490.policy_id
                         AND b480.item_no = b490.item_no
                         AND b490.line_cd = a170.line_cd
                         AND b490.peril_cd = a170.peril_cd
                         AND b490.policy_id = v_cancel_policy)
      LOOP
         v_comp_prem := NULL;

         IF NVL (v_prorate_flag, 2) = 1
         THEN
            IF v_comp_sw = 'Y'
            THEN
               v_prorate :=
                    ((TRUNC (v_endt_exp_date) - TRUNC (v_eff_date)) + 1
                    )
                  / (ADD_MONTHS (v_eff_date, 12) - v_eff_date);
            ELSIF v_comp_sw = 'M'
            THEN
               v_prorate :=
                    ((TRUNC (v_endt_exp_date) - TRUNC (v_eff_date)) - 1
                    )
                  / (ADD_MONTHS (v_eff_date, 12) - v_eff_date);
            ELSE
               v_prorate :=
                    (TRUNC (v_endt_exp_date) - TRUNC (v_eff_date))
                  / (ADD_MONTHS (v_eff_date, 12) - v_eff_date);
            END IF;

            v_comp_prem := itmperl.prem_amt / v_prorate;
         ELSIF NVL (v_prorate_flag, 2) = 2
         THEN
            v_comp_prem := itmperl.prem_amt;
         ELSE
            v_comp_prem := itmperl.prem_amt / (v_short_rt_percent / 100);
         END IF;

         FOR a1 IN (SELECT policy_id
                      FROM gipi_polbasic b250
                     WHERE b250.line_cd = p_line_cd
                       AND b250.subline_cd = p_subline_cd
                       AND b250.iss_cd = p_iss_cd
                       AND b250.issue_yy = p_issue_yy
                       AND b250.pol_seq_no = p_pol_seq_no
                       AND b250.renew_no = p_renew_no
                       AND b250.eff_date > v_eff_date
                       AND b250.endt_seq_no > 0
                       AND b250.pol_flag IN ('1', '2', '3')
                       AND NVL (b250.endt_expiry_date, b250.expiry_date) >=
                                                                    v_eff_date)
         LOOP
--            FOR perl IN (SELECT '1' -- Commented out by Jerome Bautista SR 21554 02.11.2016
--                           FROM gipi_itmperil b380
--                          WHERE b380.item_no = itmperl.item_no
--                            AND b380.peril_cd = itmperl.peril_cd
--                            AND b380.policy_id = a1.policy_id)
--            LOOP
--               UPDATE gipi_itmperil
--                  SET ann_tsi_amt = ann_tsi_amt + itmperl.tsi_amt,
--                      ann_prem_amt =
--                            ann_prem_amt + NVL (v_comp_prem, itmperl.prem_amt)
--                WHERE policy_id = a1.policy_id
--                  AND item_no = itmperl.item_no
--                  AND peril_cd = itmperl.peril_cd;
--            END LOOP;

            IF itmperl.peril_type = 'B'
            THEN
               UPDATE gipi_item
                  SET ann_tsi_amt = ann_tsi_amt - itmperl.tsi_amt,
                      ann_prem_amt =
                            ann_prem_amt - NVL (v_comp_prem, itmperl.prem_amt)
                WHERE policy_id = a1.policy_id AND item_no = itmperl.item_no;

               UPDATE gipi_polbasic
                  SET ann_tsi_amt =
                           ann_tsi_amt
                         - ROUND ((  itmperl.tsi_amt
                                   * NVL (itmperl.currency_rt, 1)
                                  ),
                                  2
                                 ),
                      ann_prem_amt =
                           ann_prem_amt
                         - ROUND ((  NVL (v_comp_prem, itmperl.prem_amt)
                                   * NVL (itmperl.currency_rt, 1)
                                  ),
                                  2
                                 )
                WHERE policy_id = a1.policy_id;
            ELSE
               UPDATE gipi_item
                  SET ann_prem_amt =
                            ann_prem_amt + NVL (v_comp_prem, itmperl.prem_amt)
                WHERE policy_id = a1.policy_id AND item_no = itmperl.item_no;

               UPDATE gipi_polbasic
                  SET ann_prem_amt =
                           ann_prem_amt
                         - ROUND ((  NVL (v_comp_prem, itmperl.prem_amt)
                                   * NVL (itmperl.currency_rt, 1)
                                  ),
                                  2
                                 )
                WHERE policy_id = a1.policy_id;
            END IF;
         END LOOP;
      END LOOP;
   END update_affected_endt;

   PROCEDURE create_history (
      p_policy_id    IN   gipi_polbasic.policy_id%TYPE,
      p_v_max_endt   IN   gipi_polbasic.endt_seq_no%TYPE,
      p_user_id      IN   giis_users.user_id%TYPE
   )
   IS
   BEGIN
      INSERT INTO gipi_reinstate_hist
                  (policy_id, hist_id, max_endt_seq_no, user_id,
                   last_update
                  )
           VALUES (p_policy_id, hist_id_s.NEXTVAL, p_v_max_endt, p_user_id,
                   SYSDATE
                  );
   END create_history;

   /* benjo 09.03.2015 UW-SPECS-2015-080 */
   FUNCTION chk_orig_renew_status (
      p_policy_id    gipi_polbasic.policy_id%TYPE
   )
      RETURN chk_orig_renew_status_tab PIPELINED
   IS
      v_rec     chk_orig_renew_status_type;
   BEGIN
      FOR x IN (SELECT 1
                  FROM gipi_polbasic a, gipi_polnrep b
                 WHERE a.policy_id = b.old_policy_id
                   AND a.pol_flag IN ('4', '5')
                   AND b.ren_rep_sw = 1
                   AND b.new_policy_id = p_policy_id)
      LOOP
        v_rec.invalid_orig := 'Y';
      END LOOP;
      
      IF NVL(v_rec.invalid_orig, 'N') != 'Y' THEN
          FOR y IN (SELECT a.pol_flag
                      FROM gipi_polbasic a, gipi_polnrep b
                     WHERE a.policy_id = b.new_policy_id
                       AND b.ren_rep_sw = 1
                       AND b.old_policy_id = p_policy_id)
          LOOP
            IF y.pol_flag NOT IN ('4', '5') THEN
                v_rec.valid_renew := 'Y';
            ELSIF y.pol_flag = '4' THEN
                v_rec.cancel_renew := 'Y';
            END IF;
          END LOOP;
          
          FOR z IN (SELECT 1
                      FROM gipi_parlist a, gipi_wpolnrep b
                     WHERE a.par_id = b.par_id
                       AND a.par_status IN (98, 99)
                       AND b.old_policy_id = p_policy_id)
          LOOP
            v_rec.cancel_renew := 'Y';
          END LOOP;
      END IF;
      
      PIPE ROW (v_rec);
      RETURN;
   END chk_orig_renew_status;
END;
/


