CREATE OR REPLACE PACKAGE BODY CPI.gipis132_pkg
AS 
   FUNCTION get_policy_status(
      p_user_id       VARCHAR2,
      p_pol_flag      VARCHAR2,
      p_dist_flag     VARCHAR2,
      p_date_type     VARCHAR2,
      p_as_of_date    VARCHAR2,
      p_from_date     VARCHAR2,
      p_to_date       VARCHAR2,
      p_line_cd       VARCHAR2,
      p_subline_cd    VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_issue_yy      NUMBER,
      p_pol_seq_no    NUMBER,
      p_renew_no      NUMBER,
      p_endt_iss_cd   VARCHAR2,
      p_endt_yy       NUMBER,
      p_endt_seq_no   NUMBER,
      p_assd_name     VARCHAR2,
      p_user_id2      VARCHAR2,
      p_cred_branch   VARCHAR2
   )
      RETURN gipis132_tab PIPELINED
   IS
      v_list gipis132_type;
      v_where VARCHAR2(32767);
      v_user_access VARCHAR2(32767);
      v_date_filter VARCHAR2(32767);
      TYPE v_type IS RECORD (
          policy_id          gipi_polbasic.policy_id%TYPE,
          par_id             gipi_polbasic.par_id%TYPE,
          line_cd         gipi_polbasic.line_cd%TYPE,
          subline_cd      gipi_polbasic.subline_cd%TYPE,
          iss_cd          gipi_polbasic.iss_cd%TYPE,
          issue_yy        gipi_polbasic.issue_yy%TYPE,
          pol_seq_no      gipi_polbasic.pol_seq_no%TYPE,
          renew_no        gipi_polbasic.renew_no%TYPE,
          endt_iss_cd     gipi_polbasic.endt_iss_cd%TYPE,
          endt_yy         gipi_polbasic.endt_yy%TYPE,
          endt_seq_no     gipi_polbasic.endt_seq_no%TYPE,
          user_id         gipi_polbasic.user_id%TYPE,
          pol_flag        gipi_polbasic.pol_flag%TYPE,
          cred_branch     gipi_polbasic.cred_branch%TYPE,
         -- cred_branch_name giis_issource.iss_name%TYPE,
          incept_date        gipi_polbasic.incept_date%TYPE,
          expiry_date        gipi_polbasic.expiry_date%TYPE,
          eff_date           gipi_polbasic.eff_date%TYPE,
          issue_date         gipi_polbasic.issue_date%TYPE,
          assd_no       gipi_polbasic.assd_no%TYPE,
          assured_name     VARCHAR2(10000),
          iss_name  giis_issource.iss_name%TYPE,
          spld_flag         gipi_polbasic.spld_flag%TYPE --added by reymon 05072013
          
       );
       TYPE v_tab IS TABLE OF v_type;
       v_list2 v_tab;
   BEGIN
      
   --changed manual checking of user access to check_user_per_iss_cd2
   --pol cruz
   --9.17.2013
   
--      BEGIN
--        SELECT ' AND ' || GIPIS132_PKG.get_user_access(p_line_cd, p_iss_cd, p_cred_branch, p_user_id)
--          INTO v_user_access FROM dual;
--      END;
      
      --v_user_access := ' AND check_user_per_iss_cd2(a.line_cd, a.iss_cd, ''GIPIS132'', ''' || p_user_id || ''') = 1'; removed by CarloR 07.27.2016
      
      v_user_access := ' AND check_user_per_iss_cd2(''' || p_line_cd || ''', ''' || p_iss_cd || ''', ''GIPIS132'', ''' || p_user_id || ''') = 1';  --CarloR 07.27.2016 for faster retrieval of records
   
      IF p_date_type = 'inceptDate' THEN
         v_date_filter := '(a.incept_date BETWEEN TRUNC (TO_DATE (''' || p_from_date || ''', ''mm-dd-yyyy''))
                                              AND   TRUNC (TO_DATE (''' || p_to_date || ''', ''mm-dd-yyyy'')) + .99999
                            OR a.incept_date <= TRUNC (TO_DATE (''' || p_as_of_date || ''', ''mm-dd-yyyy'')) + .99999) AND ';
      ELSIF p_date_type = 'issueDate' THEN      
         v_date_filter := '(a.issue_date BETWEEN TRUNC (TO_DATE (''' || p_from_date || ''', ''mm-dd-yyyy''))
                                             AND   TRUNC (TO_DATE (''' || p_to_date || ''', ''mm-dd-yyyy'')) + .99999
                            OR a.issue_date <= TRUNC (TO_DATE (''' || p_as_of_date || ''', ''mm-dd-yyyy'')) + .99999) AND ';
      ELSIF p_date_type = 'effDate' THEN
         v_date_filter := '(a.eff_date BETWEEN TRUNC (TO_DATE (''' || p_from_date || ''', ''mm-dd-yyyy''))
                                           AND   TRUNC (TO_DATE (''' || p_to_date || ''', ''mm-dd-yyyy'')) + .99999
                            OR a.eff_date <= TRUNC (TO_DATE (''' || p_as_of_date || ''', ''mm-dd-yyyy'')) + .99999) AND ';                                
      END IF;
      
      
      IF p_pol_flag = '8' THEN
         IF p_dist_flag = '1' THEN
            v_where := v_date_filter || '(a.dist_flag = ''1'' or a.dist_flag = ''2'' or a.dist_flag = ''4'' or a.dist_flag = ''5'') 
                                        and a.line_cd != ''BB''' || v_user_access;
         ELSIF p_dist_flag = '3' THEN
            v_where := v_date_filter || 'a.dist_flag = ''3'' ' || v_user_access || ' AND a.line_cd != ''BB''';
         ELSE
--            v_where := v_date_filter || 'a.line_cd != ''BB'' '||v_user_access||''; 
            v_where := v_date_filter || '(a.dist_flag = ''1'' or a.dist_flag = ''2'' or a.dist_flag = ''4'' or a.dist_flag = ''5'' or a.dist_flag = ''3'') 
                                        and a.line_cd != ''BB''' || v_user_access;                          
         END IF;
         
      ELSIF p_pol_flag = '7' THEN  
         IF p_dist_flag = '1' THEN
            v_where := v_date_filter || 'a.dist_flag = ''1'' ' || v_user_access ||
                                        ' AND (a.dist_flag = ''2'' OR a.dist_flag = ''4'' OR a.dist_flag = ''5'')
                                          AND a.spld_flag = ''2'' AND a.line_cd != ''BB''';
         ELSIF p_dist_flag = '3' THEN
            v_where := v_date_filter || 'a.dist_flag = ''3'' ' || v_user_access ||
                                        ' AND a.spld_flag = ''2'' 
                                          AND a.line_cd != ''BB''';
         ELSE
            v_where := v_date_filter || 'a.line_cd != ''BB'' ' || v_user_access ||
                                        ' AND a.spld_flag = ''2''';                      
         END IF;
       
      ELSIF p_pol_flag = '5' THEN
         v_where := v_date_filter||'a.pol_flag = ''5'' '||v_user_access||'
                    AND spld_flag != ''2''
                    AND line_cd != ''BB''';  
      
      ELSE
         IF p_dist_flag = '1' THEN
             v_where := v_date_filter||'pol_flag = '''|| p_pol_flag ||''' '||v_user_access||' 
                        AND line_cd != ''BB'' 
                        AND spld_flag != ''2'' 
                        AND (dist_flag = ''1'' OR dist_flag = ''2'' OR dist_flag = ''4'' OR dist_flag = ''5'')';
          ELSIF p_dist_flag = '3' THEN
             v_where := v_date_filter||'pol_flag = '''|| p_pol_flag ||''' '||v_user_access||'
                        AND line_cd != ''BB'' and spld_flag != ''2''
                        AND dist_flag = ''3''';
          ELSE
             v_where := v_date_filter || 'pol_flag = '''|| p_pol_flag ||''' ' ||v_user_access||'
                        AND spld_flag != ''2''
                        AND line_cd != ''BB''';                      
          END IF;        
         
      END IF;
      
      IF p_endt_iss_cd IS NOT NULL OR p_endt_yy IS NOT NULL THEN
         v_where := v_where || ' AND a.endt_seq_no > 0 ';
      END IF;
      
--      raise_application_error(-20001, 'GeniisysException#E#' || v_where);
        
      --added spld_flag by reymon 05072013
      EXECUTE IMMEDIATE
        '       SELECT a.policy_id, a.par_id, a.line_cd, a.subline_cd, a.iss_cd,
                       a.issue_yy, a.pol_seq_no, a.renew_no, a.endt_iss_cd,
                       a.endt_yy, a.endt_seq_no, a.user_id, a.pol_flag, a.cred_branch,
                       a.incept_date, a.expiry_date, a.eff_date, a.issue_date, a.assd_no,
                       b.designation ||'' ''|| b.assd_name assured_name, c.iss_name,
                       a.spld_flag
                  FROM gipi_polbasic a, giis_assured b, giis_issource c
                 WHERE a.assd_no = b.assd_no (+)
                   AND a.cred_branch = c.iss_cd (+)
                   AND ' || v_where || 
        '          AND a.line_cd LIKE UPPER(NVL('''|| p_line_cd ||''', a.line_cd))
                   AND a.subline_cd LIKE UPPER(NVL('''|| p_subline_cd ||''', a.subline_cd)) 
                   AND a.iss_cd LIKE UPPER(NVL('''|| p_iss_cd ||''', a.iss_cd)) 
                   AND a.issue_yy = NVL('''|| p_issue_yy ||''', a.issue_yy)
                   AND a.pol_seq_no = NVL('''|| p_pol_seq_no ||''', a.pol_seq_no)
                   AND a.renew_no = NVL('''|| p_renew_no ||''', a.renew_no)
                   AND a.endt_iss_cd LIKE UPPER(NVL('''|| p_endt_iss_cd ||''', a.endt_iss_cd))
                   AND a.endt_yy = NVL('''|| p_endt_yy ||''', a.endt_yy)
                   AND a.endt_seq_no = NVL('''|| p_endt_seq_no ||''', a.endt_seq_no)
                   AND TRIM(UPPER(b.designation ||'' ''|| b.assd_name)) LIKE TRIM(UPPER(NVL('''|| p_assd_name ||''', b.designation ||'' ''|| b.assd_name)))
                   AND UPPER(a.user_id) LIKE UPPER(NVL('''|| p_user_id2 ||''', a.user_id))
                   AND (UPPER(a.cred_branch) LIKE UPPER(NVL('''|| p_cred_branch ||''', a.cred_branch))
                        OR UPPER(c.iss_name) LIKE UPPER(NVL('''|| p_cred_branch ||''', c.iss_name)))     
              ORDER BY a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no'           
    BULK COLLECT
    INTO v_list2;
    
   IF v_list2.LAST > 0 THEN
    
        FOR i IN v_list2.FIRST..v_list2.LAST
        LOOP
            v_list.policy_id := v_list2(i).policy_id;
            v_list.par_id := v_list2(i).par_id;
            v_list.line_cd := v_list2(i).line_cd;
            v_list.subline_cd := v_list2(i).subline_cd;
            v_list.iss_cd := v_list2(i).iss_cd;
            v_list.issue_yy := v_list2(i).issue_yy;
            v_list.pol_seq_no := v_list2(i).pol_seq_no;
            v_list.renew_no := v_list2(i).renew_no;
            v_list.user_id := v_list2(i).user_id;
            v_list.cred_branch := v_list2(i).cred_branch;
            v_list.incept_date := v_list2(i).incept_date;
            v_list.expiry_date := v_list2(i).expiry_date;
            v_list.eff_date := v_list2(i).eff_date;
            v_list.issue_date := v_list2(i).issue_date;
            v_list.assd_name := v_list2(i).assured_name;
            v_list.cred_branch_name := v_list2(i).iss_name;

            IF v_list2(i).endt_seq_no > 0 THEN
                v_list.endt_iss_cd := v_list2(i).endt_iss_cd;
                v_list.endt_yy := v_list2(i).endt_yy;
                v_list.endt_seq_no := v_list2(i).endt_seq_no;
             ELSE
                v_list.endt_iss_cd := NULL;
                v_list.endt_yy := NULL;
                v_list.endt_seq_no := NULL;  
             END IF;
             
             BEGIN
                IF v_list2(i).pol_flag IS NOT NULL THEN
                   BEGIN
                    SELECT rv_meaning
                      INTO v_list.mean_pol_flag
                      FROM cg_ref_codes
                     WHERE ((rv_high_value IS NULL
                             AND v_list2(i).pol_flag IN (rv_low_value, rv_abbreviation)
                             )
                            OR (v_list2(i).pol_flag BETWEEN rv_low_value AND rv_high_value)
                           )
                       AND ROWNUM = 1
                       AND rv_domain = 'GIPI_POLBASIC.POL_FLAG';
                    EXCEPTION WHEN NO_DATA_FOUND THEN
                      v_list.mean_pol_flag := NULL;   
                   END;
                  
                END IF;
             END;
             
             --added by reymon 05072013
             BEGIN
                IF v_list2(i).spld_flag = '2' THEN
                    FOR mean IN (
                        SELECT rv_meaning
                          FROM cg_ref_codes
                         WHERE rv_domain    = 'GIPI_POLBASIC.SPLD_FLAG'
                           AND rv_low_value = v_list2(i).spld_flag)
                    LOOP
                        v_list.mean_pol_flag := mean.rv_meaning;
                    END LOOP;
                END IF;
             END; 
            PIPE ROW(v_list);
        END LOOP;        
   END IF;     
      RETURN;     
   END get_policy_status;
   
   
   FUNCTION get_user_access (
      p_line_cd       VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_cred_branch   VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN VARCHAR2
   IS
     v_where         VARCHAR2 (32767);
     v_lines_exist   BOOLEAN          := FALSE;

     CURSOR iss_cur (cp_iss_cd VARCHAR2)
     IS
       SELECT b.iss_cd
         FROM giis_users a,
              giis_user_iss_cd b,
              giis_modules_tran c,
              giis_user_line d
        WHERE a.user_id = b.userid
          AND a.user_id = p_user_id
          AND b.tran_cd = c.tran_cd
          AND c.module_id = 'GIPIS132'
          AND d.userid = b.userid
          AND d.iss_cd = b.iss_cd
          AND d.tran_cd = b.tran_cd
          --AND d.iss_cd = NVL (cp_iss_cd, d.iss_cd) commented and changed by reymon 05022013
          AND UPPER(d.iss_cd) LIKE NVL (UPPER(cp_iss_cd), d.iss_cd)
       UNION
       SELECT b.iss_cd
         FROM giis_users a,
              giis_user_grp_dtl b,
              giis_modules_tran c,
              giis_user_grp_line d
        WHERE a.user_id = p_user_id
          AND a.user_grp = b.user_grp
          AND b.tran_cd = c.tran_cd
          AND c.module_id = 'GIPIS132'
          AND d.user_grp = b.user_grp
          AND d.iss_cd = b.iss_cd
          AND d.tran_cd = b.tran_cd
          --AND d.iss_cd = NVL (cp_iss_cd, d.iss_cd) commented and changed by reymon 05022013
          AND UPPER(d.iss_cd) LIKE NVL (UPPER(cp_iss_cd), d.iss_cd);

    CURSOR line_cur (cp_iss_cd VARCHAR2, cp_line_cd VARCHAR2)
    IS
       SELECT d.line_cd
         FROM giis_users a,
              giis_user_iss_cd b,
              giis_modules_tran c,
              giis_user_line d
        WHERE a.user_id = b.userid
          AND a.user_id = p_user_id
          AND b.tran_cd = c.tran_cd
          AND c.module_id = 'GIPIS132'
          AND d.userid = b.userid
          AND d.iss_cd = b.iss_cd
          AND d.tran_cd = b.tran_cd
          --AND d.iss_cd = NVL (cp_iss_cd, d.iss_cd) commented and changed by reymon 05022013
          AND UPPER(d.iss_cd) LIKE NVL (UPPER(cp_iss_cd), d.iss_cd)
          --AND d.line_cd = NVL (cp_line_cd, d.line_cd) commented and changed by reymon 05022013
          AND UPPER(d.line_cd) LIKE NVL (UPPER(cp_line_cd), d.line_cd)
     UNION
       SELECT d.line_cd
         FROM giis_users a,
              giis_user_grp_dtl b,
              giis_modules_tran c,
              giis_user_grp_line d
        WHERE a.user_id = p_user_id
          AND a.user_grp = b.user_grp
          AND b.tran_cd = c.tran_cd
          AND c.module_id = 'GIPIS132'
          AND d.user_grp = b.user_grp
          AND d.iss_cd = b.iss_cd
          AND d.tran_cd = b.tran_cd
          --AND d.iss_cd = NVL (cp_iss_cd, d.iss_cd) commented and changed by reymon 05022013
          AND UPPER(d.iss_cd) LIKE NVL (UPPER(cp_iss_cd), d.iss_cd)
          --AND d.line_cd = NVL (cp_line_cd, d.line_cd) commented and changed by reymon 05022013
          AND UPPER(d.line_cd) LIKE NVL (UPPER(cp_line_cd), d.line_cd);
   BEGIN
     v_where := '(';

     FOR x IN iss_cur (p_iss_cd)
     LOOP
       IF v_where != '(' THEN
          v_where := v_where || ' OR ';
       END IF;

       v_where := v_where || '(';
       v_where := v_where || 'a.iss_cd = ''' || x.iss_cd || ''' AND a.line_cd IN (';

       FOR y IN line_cur (x.iss_cd, p_line_cd)
       LOOP
          v_lines_exist := TRUE;
          v_where := v_where || '''' || y.line_cd || ''',';
       END LOOP;

       v_where := RTRIM (v_where, ',');

       IF NOT v_lines_exist THEN
         v_where := v_where || '''UDEL DELA CRUZ JR.'')';
       ELSE
          v_where := v_where || ')';
       END IF;

       v_where := v_where || ')';
     END LOOP;
     
     --added condition by reymon 05022013
     IF v_where = '(' THEN
        v_where := '(1=2)';
     ELSE
        v_where := v_where || ')';
     END IF;
     RETURN v_where;
   END get_user_access;   
   
   FUNCTION get_main_policy_id (
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_issue_yy     NUMBER,
      p_pol_seq_no   NUMBER,
      p_renew_no     NUMBER
   )
      RETURN NUMBER
   IS
      v_policy_id NUMBER(12);
   BEGIN
      SELECT policy_id
        INTO v_policy_id
        FROM gipi_polbasic gpol
       WHERE gpol.line_cd = p_line_cd
         AND gpol.subline_cd = p_subline_cd
         AND gpol.iss_cd = p_iss_cd
         AND gpol.issue_yy = p_issue_yy
         AND gpol.pol_seq_no = p_pol_seq_no
         AND gpol.renew_no = p_renew_no
         and gpol.endt_seq_no = 0;
         
      RETURN v_policy_id;  
   END get_main_policy_id;        

END;
/


