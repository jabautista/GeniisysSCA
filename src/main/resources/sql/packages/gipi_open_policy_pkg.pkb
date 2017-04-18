CREATE OR REPLACE PACKAGE BODY CPI.gipi_open_policy_pkg
AS
   /*
   **  Created by   : Moses Calma
   **  Date Created : July 8, 2011
   **  Reference By : (GIPIS100 - View Policy Information)
   **  Description  : Retrieves Open Policy given a policy_id 
                       from a policy with an endt_seq_no = 0
   */
   FUNCTION get_endtseq0_open_policy (
      p_policy_endtseq0   gipi_polbasic.policy_id%TYPE
   )
      RETURN endtseq0_open_policy_tab PIPELINED
   IS
      v_endtseq0_open_policy   endtseq0_open_policy_type;
   BEGIN
      FOR i IN (SELECT policy_id, line_cd, op_subline_cd, op_iss_cd,
                       op_issue_yy, op_pol_seqno, op_renew_no, decltn_no,
                       eff_date
                  FROM gipi_open_policy
                 WHERE policy_id = p_policy_endtseq0)
      LOOP
      
         v_endtseq0_open_policy.policy_id          := i.policy_id;
         v_endtseq0_open_policy.line_cd            := i.line_cd;
         v_endtseq0_open_policy.op_iss_cd          := i.op_iss_cd;
         v_endtseq0_open_policy.op_issue_yy        := i.op_issue_yy;
         v_endtseq0_open_policy.op_pol_seqno       := i.op_pol_seqno;
         v_endtseq0_open_policy.op_subline_cd      := i.op_subline_cd;
         v_endtseq0_open_policy.op_renew_no        := i.op_renew_no;
         v_endtseq0_open_policy.decltn_no          := i.decltn_no;
         v_endtseq0_open_policy.eff_date           := i.eff_date;

         /* replaced by robert SR 20904 01.21.16
		 BEGIN
            SELECT DISTINCT ref_open_pol_no -- kenneth @ FGIC 10.22.2014
              INTO v_endtseq0_open_policy.ref_open_pol_no
              FROM gipi_polbasic
             WHERE line_cd = i.line_cd
               AND subline_cd = i.op_subline_cd
               AND iss_cd = i.op_iss_cd
               AND issue_yy = i.op_issue_yy
               AND pol_seq_no = i.op_pol_seqno
               AND renew_no = i.op_renew_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_endtseq0_open_policy.ref_open_pol_no := '';
         END; */
		 
         BEGIN
              FOR ref IN (
                SELECT a.ref_open_pol_no
                  FROM gipi_polbasic a
                 WHERE a.line_cd     = i.line_cd
                   AND a.subline_cd  = i.op_subline_cd
                   AND a.iss_cd      = i.op_iss_cd
                   AND a.issue_yy    = i.op_issue_yy
                   AND a.pol_seq_no  = i.op_pol_seqno
                   AND a.renew_no    = i.op_renew_no
                   AND a.pol_flag <> '5'
                   AND NOT EXISTS (
                        SELECT 'X'
                          FROM gipi_polbasic b
                         WHERE b.line_cd = a.line_cd
                           AND b.subline_cd = a.subline_cd
                           AND b.iss_cd = a.iss_cd
                           AND b.issue_yy = a.issue_yy
                           AND b.pol_seq_no = a.pol_seq_no
                           AND b.renew_no = a.renew_no
                           AND b.endt_seq_no > a.endt_seq_no
                           AND NVL (b.back_stat, 5) = 2
                           AND b.pol_flag <> '5')
                 ORDER BY a.eff_date DESC, a.endt_seq_no DESC)
            LOOP
                v_endtseq0_open_policy.ref_open_pol_no := ref.ref_open_pol_no;
                EXIT;
            END LOOP;
         END;
		 --end robert SR 20904 01.21.16

         PIPE ROW (v_endtseq0_open_policy);
      END LOOP;

      RETURN;
   END get_endtseq0_open_policy;
   
   /*
   **  Created by   : Marie Kris Felipe
   **  Date Created : October 29, 2013
   **  Reference By : (GIPIS199 - View Declaration Policy per Open Policy)
   **  Description  : Retrieves Open Policy LOV given the parameters
   */
   FUNCTION get_open_policy_lov(
        p_line_cd           gipi_open_policy.line_cd%TYPE,
        p_op_subline_cd     gipi_open_policy.op_subline_cd%TYPE,
        p_op_iss_cd         gipi_open_policy.op_iss_cd%TYPE,
        p_op_issue_yy       gipi_open_policy.op_issue_yy%TYPE,
        p_op_pol_seq_no     gipi_open_policy.op_pol_seqno%TYPE,
        p_op_renew_no       gipi_open_policy.op_renew_no%TYPE, 
        p_cred_branch       gipi_polbasic.cred_branch%TYPE,
        p_user_id           gipi_polbasic.user_id%TYPE,
        p_incept_date       VARCHAR2,
        p_expiry_date       VARCHAR2
   ) RETURN open_policy_tab PIPELINED
   IS
        v_rec           open_policy_type;
        v_policy_id     number;
        
        TYPE cur_typ IS REF CURSOR;
        custom    cur_typ;
        v_where   VARCHAR2 (10000)     := '';
        v_query   VARCHAR2 (10000);
        v_idate_cond VARCHAR2(1000)     := '';
        v_edate_cond VARCHAR2(1000)     := '';
   BEGIN
   
        IF p_cred_branch IS NOT NULL THEN
            
            IF check_user_per_line2(null, p_cred_branch, 'GIPIS199', p_user_id) = 1 THEN
                v_where :=      ' (check_user_per_line2(b.LINE_CD, cred_branch, ''GIPIS199'','''||p_user_id||''') = 1
                              AND cred_branch is not null) ';
            ELSE
                v_where := ' (check_user_per_line2(b.LINE_CD, op_iss_cd, ''GIPIS199'','''||p_user_id||''') = 1 ';
            END IF;
        
        ELSE 
           /* v_where := ' (check_user_per_line2(b.line_cd, op_iss_cd, ''GIPIS199'','''||p_user_id||''') = 1
                       OR (    check_user_per_line2(b.LINE_CD, cred_branch, ''GIPIS199'','''||p_user_id||''') = 1 
                           AND cred_branch is not null ) 
                        ) ';*/
                        
            v_where := ' check_user_per_line2(b.line_cd, op_iss_cd, ''GIPIS199'','''||p_user_id||''') = 1 ';
        
        END IF;
        
        v_query := 'SELECT DISTINCT b.line_cd, op_subline_cd, op_iss_cd, op_issue_yy,
                           op_pol_seqno, op_renew_no,
                           UPPER(b.line_cd) || ''-'' || UPPER(op_subline_cd) || ''-'' || UPPER(op_iss_cd) || ''-'' || LTRIM(LPAD(op_issue_yy,2,0))
                                    || ''-'' || LTRIM(LPAD(op_pol_seqno,7,0)) || ''-'' || LTRIM(LPAD(op_renew_no,2,0)) policy_no
                      FROM gipi_open_policy a, gipi_polbasic b
                     WHERE a.policy_id = b.policy_id
                       AND UPPER(b.line_cd) = UPPER(nvl(''' ||p_line_cd||''', b.line_cd))
                       AND UPPER(op_subline_cd) = UPPER(nvl('''||p_op_subline_cd||''', op_subline_cd))
                       AND UPPER(op_iss_cd) = UPPER(nvl('''||p_op_iss_cd||''', op_iss_cd))
                       AND op_issue_yy = nvl('''||p_op_issue_yy||''', op_issue_yy)
                       AND op_pol_seqno = nvl('''||p_op_pol_seq_no||''', op_pol_seqno)
                       AND op_renew_no = nvl('''||p_op_renew_no||''', op_renew_no) 
                       AND ' || v_where;
                       
        IF p_incept_date IS NOT NULL THEN
            v_idate_cond := 'TO_CHAR(incept_date, ''MM-DD-YYYY'') = ''' || p_incept_date || '''';
                            --TO_DATE(incept_date, ''MM-DD-YYYY'') = TO_DATE('''||p_incept_date||''', ''MM-DD-YYYY'')';
            v_query := v_query || ' AND ' || v_idate_cond;
        END IF;
        
        IF p_expiry_date IS NOT NULL THEN
            v_edate_cond := 'TO_CHAR(expiry_date, ''MM-DD-YYYY'') = ''' || p_expiry_date || '''';
                            --'TO_DATE(expiry_date, ''MM-DD-YYYY'') = TO_DATE('''||p_expiry_date||''', ''MM-DD-YYYY'')';
            v_query := v_query || ' AND ' || v_edate_cond;
        END IF;
       
        OPEN custom FOR v_query;
        
        LOOP
        
            FETCH custom
             INTO v_rec.line_cd, v_rec.op_subline_cd, v_rec.op_iss_cd, v_rec.op_issue_yy,
                  v_rec.op_pol_seq_no, v_rec.op_renew_no, v_rec.policy_no;                      
                
            FOR a IN (SELECT policy_id, incept_date, expiry_date, assd_no
                        FROM gipi_polbasic
                       WHERE line_cd    = v_rec.line_cd
                         AND subline_cd = v_rec.op_subline_cd
                         AND iss_cd     = v_rec.op_iss_cd
                         AND issue_yy   = v_rec.op_issue_yy
                         AND pol_seq_no = v_rec.op_pol_seq_no
                         AND renew_no   = v_rec.op_renew_no
                       ORDER BY policy_id) 
            LOOP
                v_rec.policy_id   := a.policy_id;
                v_rec.assd_no     := a.assd_no;
                v_rec.incept_date := to_char(a.incept_date, 'mm-dd-yyyy');
                v_rec.expiry_date := to_char(a.expiry_date, 'mm-dd-yyyy');
                EXIT;
            END LOOP;
                    
            FOR a IN ( SELECT assd_name FROM giis_assured
                     WHERE assd_no = v_rec.assd_no)
            LOOP
                v_rec.assd_name := a.assd_name;
            END LOOP;
                   
            FOR a IN ( SELECT limit_liability FROM gipi_open_liab
                     WHERE policy_id = v_rec.policy_id )
            LOOP
             v_rec.limit_liability := a.limit_liability;--v_limit:=a.limit_liability;
            END LOOP; 
            
            EXIT WHEN custom%NOTFOUND;
            PIPE ROW (v_rec);
                
        END LOOP;
        
        CLOSE custom; 
        
   END get_open_policy_lov;
   
   /*
   **  Created by   : Marie Kris Felipe
   **  Date Created : October 29, 2013
   **  Reference By : (GIPIS199 - View Declaration Policy per Open Policy)
   **  Description  : Retrieves Open Policy tablegrid given the parameters
   */
   FUNCTION get_open_policy_list(
        p_line_cd           gipi_open_policy.line_cd%TYPE,
        p_op_subline_cd     gipi_open_policy.op_subline_cd%TYPE,
        p_op_iss_cd         gipi_open_policy.op_iss_cd%TYPE,
        p_op_issue_yy       gipi_open_policy.op_issue_yy%TYPE,
        p_op_pol_seq_no     gipi_open_policy.op_pol_seqno%TYPE,
        p_op_renew_no       gipi_open_policy.op_renew_no%TYPE, 
        p_cred_branch       gipi_polbasic.cred_branch%TYPE,
        p_user_id           gipi_polbasic.user_id%TYPE
   ) RETURN open_policy_tab PIPELINED
   IS
        v_rec           open_policy_type;        
   BEGIN
   
        FOR a IN (SELECT a.policy_id, a.incept_date, a.expiry_date, a.tsi_amt, a.prem_amt, 
                         a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no,
                         a.endt_seq_no, a.endt_yy, a.endt_iss_cd, b.cred_branch 
                    FROM gipi_open_polbasic a, gipi_polbasic b
                   WHERE b.policy_id = a.policy_id
                     AND op_line_cd     = p_line_cd
                     AND op_subline_cd  = p_op_subline_cd
                     AND op_iss_cd      = p_op_iss_cd
                     AND op_issue_yy    = p_op_issue_yy
                     AND op_pol_seqno   = p_op_pol_seq_no
                     AND op_renew_no    = p_op_renew_no
                 ORDER BY policy_id) 
        LOOP
            v_rec.policy_id   := a.policy_id;
            v_rec.incept_date := TO_CHAR(a.incept_date, 'mm-dd-yyyy');
            v_rec.expiry_date := TO_CHAR(a.expiry_date, 'mm-dd-yyyy');
            v_rec.tsi_amt     := a.tsi_Amt;
            v_rec.prem_amt    := a.prem_amt;
            v_rec.cred_branch    := a.cred_branch;
                    
            FOR b IN ( SELECT aa.assd_name 
                         FROM giis_assured aa ,gipi_polbasic b
                        WHERE aa.assd_no    = b.assd_no
                          AND b.policy_id   = a.policy_id)
            LOOP
                v_rec.assd_name := b.assd_name;
                EXIT;
            END LOOP;
                    
            IF a.endt_seq_no = 0 THEN --if yes,it will retrieve and concatenate items as follows
               v_rec.policy_no := upper( (a.line_cd)||'-'|| 
                                         (a.subline_cd)||'-'||
                                         (a.iss_cd)||'-'||
                                         ltrim(to_char(a.issue_yy,'09' ))||'-'||
                                         ltrim(to_char(a.pol_seq_no,'0000009'))||'-'||
                                         ltrim(to_char(a.renew_no,'09')));
                    
            ELSE   --if its value is other than 0,it will retrive and concatenate items as follows
               v_rec.policy_no := upper( (a.line_cd)||'-'||
                                         (a.subline_cd)||'-'||
                                         (a.iss_cd)||'-'||
                                         ltrim(to_char(a.issue_yy,'09' ))||'-'||
                                         ltrim(to_char(a.pol_seq_no,'0000009'))||'-'||
                                         ltrim(to_char(a.renew_no,'09'))||'-'||
                                         (a.endt_iss_cd)||'-'||
                                         ltrim(to_char(a.endt_yy,'09'))||'-'||
                                         ltrim(to_char(a.endt_seq_no,'000009')));
                 
            END IF;
       
            PIPE ROW(v_rec);
        END LOOP;
       
   END get_open_policy_list;
   
   FUNCTION get_open_liab_fi_mn (
      p_policy_id VARCHAR2
   )
      RETURN open_liab_fi_mn_tab PIPELINED
   IS
      v_list open_liab_fi_mn_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM gipi_open_liab
                 WHERE policy_id = p_policy_id)
      LOOP
         v_list.policy_id := i.policy_id;
         v_list.geog_cd := i.geog_cd;
         v_list.currency_cd := i.currency_cd;
         v_list.limit_liability := i.limit_liability;
         v_list.currency_rt := i.currency_rt;
         v_list.voy_limit := i.voy_limit;
         v_list.with_invoice_tag := i.with_invoice_tag;
         
         BEGIN
            SELECT geog_desc
              INTO v_list.geog_desc
              FROM giis_geog_class
             WHERE geog_cd = i.geog_cd;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.geog_desc := NULL;
         END;
         
         BEGIN
            SELECT currency_desc
              INTO v_list.currency_desc
              FROM giis_currency
             WHERE main_currency_cd = i.currency_cd;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.currency_desc := NULL;
         END;
         
         PIPE ROW(v_list);
      END LOOP;
   END get_open_liab_fi_mn;
   
   FUNCTION get_open_cargos (
      p_policy_id VARCHAR2,
      p_geog_cd   VARCHAR2
   )
      RETURN open_cargo_tab PIPELINED
   IS
      v_list open_cargo_type;
   BEGIN
      FOR i IN (SELECT cargo_class_cd
                  FROM gipi_open_cargo
                 WHERE policy_id = p_policy_id
                   AND geog_cd = p_geog_cd)
      LOOP
         v_list.cargo_class_cd := i.cargo_class_cd;
         
         BEGIN
            SELECT cargo_class_desc
              INTO v_list.cargo_class_desc
              FROM giis_cargo_class
             WHERE cargo_class_cd = i.cargo_class_cd;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.cargo_class_desc := NULL;
         END;
         
         PIPE ROW(v_list);
      END LOOP;
   END get_open_cargos;
   
   FUNCTION get_open_perils (
      p_policy_id VARCHAR2,
      p_geog_cd   VARCHAR2
   )
      RETURN open_peril_tab PIPELINED
   IS
      v_list open_peril_type;
   BEGIN
      FOR i IN (SELECT peril_cd, prem_rate, remarks,
                       with_invoice_tag, line_cd
                  FROM gipi_open_peril
                 WHERE policy_id = p_policy_id
                   AND geog_cd = p_geog_cd)
      LOOP
         v_list.prem_rate := NVL(i.prem_rate, 0);
         v_list.remarks := i.remarks;
         v_list.with_invoice_tag := i.with_invoice_tag;
         
         BEGIN
            SELECT peril_name
              INTO v_list.peril_name
              FROM giis_peril
             WHERE peril_cd = i.peril_cd
               AND line_cd = i.line_cd;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.peril_name := NULL;     
         END;
         
         PIPE ROW(v_list);
      END LOOP;
   END get_open_perils; 
   
END gipi_open_policy_pkg;
/


