CREATE OR REPLACE PACKAGE BODY CPI.gipis131_pkg
AS
   FUNCTION get_count_parhist
      RETURN NUMBER
   IS
      v_output   NUMBER;
   BEGIN 
      SELECT COUNT (*) INTO v_output FROM GIPI_PARHIST;

      RETURN v_output;
   END;

   FUNCTION get_count_user_grp_modules
      RETURN NUMBER
   IS
      v_output   NUMBER;
   BEGIN
      SELECT COUNT (*) INTO v_output FROM GIIS_USER_GRP_MODULES;

      RETURN v_output;
   END;

   FUNCTION get_count_user_modules
      RETURN NUMBER
   IS
      v_output   NUMBER;
   BEGIN
      SELECT COUNT (*) INTO v_output FROM GIIS_USER_MODULES;

      RETURN v_output;
   END;

   FUNCTION get_par_status (p_user_id             VARCHAR2,
                            p_search_by_opt       VARCHAR2,
                            p_date_as_of          VARCHAR2,
                            p_date_from           VARCHAR2,
                            p_date_to             VARCHAR2,
                            p_par_stat            VARCHAR2,
                            p_plist_line_cd       VARCHAR2,
                            p_plist_iss_cd        VARCHAR2,
                            p_par_yy              NUMBER,
                            p_par_seq_no          NUMBER,
                            p_quote_seq_no        NUMBER,
                            p_assd_name           VARCHAR2,
                            p_cred_branch         VARCHAR2,
                            p_par_type            VARCHAR2,
                            p_underwriter         VARCHAR2,
                            p_drv_par_status      VARCHAR2,
                            p_from_row            NUMBER DEFAULT 1,
                            p_to_row              NUMBER DEFAULT 10,
                            p_col_order           VARCHAR2 DEFAULT 'plist_line_cd',
                            p_col_order_format    VARCHAR2 DEFAULT 'ASC',
                            p_cache               NUMBER DEFAULT 0)
      RETURN gipis131_tab
      PIPELINED
   IS
      v_cursor     SYS_REFCURSOR;
      v_list       gipis131_type;
      v_cred_branch_cond    VARCHAR2(1000) := ' ';
      v_sql        VARCHAR2 (32767);
      
      v_iterator   NUMBER := 0;
      v_idx        NUMBER;
      v_valid2     valid_tab;
      v_valid1     valid_tab;
      v_cache      NUMBER;
      
      v_col_order           VARCHAR2(1000);       
      v_col_order_format    VARCHAR2(1000);
      v_date_as_of          VARCHAR2(20);
      v_being_updated_cond  VARCHAR2(5000) := ''; --added by carloR 07.26.2016
      v_being_updated_status VARCHAR2(5000) := ''; --added by CarloR 07.26.2016
      TYPE par_rec IS RECORD (count_           NUMBER,
      rownum_          NUMBER,
      par_id           gipi_parlist_polbasic_v.par_id%TYPE,
      plist_line_cd    gipi_parlist_polbasic_v.plist_line_cd%TYPE,
      plist_iss_cd     gipi_parlist_polbasic_v.plist_iss_cd%TYPE,
      par_yy           gipi_parlist_polbasic_v.par_yy%TYPE,
      par_seq_no       gipi_parlist_polbasic_v.par_seq_no%TYPE,
      quote_seq_no     gipi_parlist_polbasic_v.quote_seq_no%TYPE,
      par_type         gipi_parlist_polbasic_v.par_type%TYPE,
      pbasic_line_cd   gipi_parlist_polbasic_v.pbasic_line_cd%TYPE,
      subline_cd       gipi_parlist_polbasic_v.subline_cd%TYPE,
      pbasic_iss_cd    gipi_parlist_polbasic_v.pbasic_iss_cd%TYPE,
      issue_yy         gipi_parlist_polbasic_v.issue_yy%TYPE,
      pol_seq_no       gipi_parlist_polbasic_v.pol_seq_no%TYPE,
      user_id          gipi_parlist_polbasic_v.user_id%TYPE,
      underwriter      gipi_parlist_polbasic_v.underwriter%TYPE,
      renew_no         gipi_parlist_polbasic_v.renew_no%TYPE,
      incept_date      gipi_parlist_polbasic_v.incept_date%TYPE,
      expiry_date      gipi_parlist_polbasic_v.expiry_date%TYPE,
      eff_date         gipi_parlist_polbasic_v.eff_date%TYPE,
      issue_date       gipi_parlist_polbasic_v.issue_date%TYPE,
      assd_name        giis_assured.assd_name%TYPE,
      drv_par_status   drv_par_status_type,
      cred_branch      gipi_parlist_polbasic_v.cred_branch%TYPE,
      endt_iss_cd      gipi_parlist_polbasic_v.endt_iss_cd%TYPE, 
      endt_yy          gipi_parlist_polbasic_v.endt_yy%TYPE,     
      endt_no          VARCHAR2(50),  
      policy_no        VARCHAR2(50));
      TYPE par_tbl IS TABLE OF  par_rec;
      par_status_list  par_tbl;
      
      PROCEDURE cache_param
      IS
      BEGIN
         v_cache_search_by_opt := p_search_by_opt;
         v_cache_date_as_of := p_date_as_of;
         v_cache_date_from := p_date_from;
         v_cache_date_to := p_date_to;
         v_cache_par_stat := p_par_stat;
         v_cache_plist_line_cd := p_plist_line_cd;
         v_cache_plist_iss_cd := p_plist_iss_cd;
         v_cache_par_yy := p_par_yy;
         v_cache_par_seq_no := p_par_seq_no;
         v_cache_quote_seq_no := p_quote_seq_no;
         v_cache_assd_name := p_assd_name;
         v_cache_par_type := p_par_type;
         v_cache_underwriter := p_underwriter;
         v_cache_drv_par_status := p_drv_par_status;
         v_cache_user_grp_mod := get_count_user_grp_modules;
         v_cache_user_mod := get_count_user_modules;
         v_cache_parhist := get_count_parhist;
      END;

      FUNCTION compare (p1 VARCHAR2, p2 VARCHAR2)
         RETURN NUMBER
      IS
         v_output   NUMBER := 0;
      BEGIN
         IF NVL (p1, 1) = NVL (p2, 1)
         THEN
            v_output := 1;
         END IF;

         RETURN v_output;
      END;

      PROCEDURE poplist (p1 NUMBER)
      IS
      BEGIN
         v_list.count_ := v_count;
         v_list.rownum_ := p1;
         v_list.par_id := v_gipisfetch_tab_cache (p1).par_id;
         v_list.plist_line_cd := v_gipisfetch_tab_cache (p1).plist_line_cd;
         v_list.plist_iss_cd := v_gipisfetch_tab_cache (p1).plist_iss_cd;
         v_list.par_yy := v_gipisfetch_tab_cache (p1).par_yy;
         v_list.par_seq_no := v_gipisfetch_tab_cache (p1).par_seq_no;
         v_list.quote_seq_no := v_gipisfetch_tab_cache (p1).quote_seq_no;
         v_list.par_type := v_gipisfetch_tab_cache (p1).par_type;
         v_list.underwriter := v_gipisfetch_tab_cache (p1).underwriter;
         v_list.drv_par_status := v_gipisfetch_tab_cache (p1).drv_par_status;
         v_list.assd_name := v_gipisfetch_tab_cache (p1).assd_name;
         v_list.policy_no :=
            LTRIM (
                  v_gipisfetch_tab_cache (p1).pbasic_line_cd
               || '-'
               || v_gipisfetch_tab_cache (p1).subline_cd
               || '-'
               || v_gipisfetch_tab_cache (p1).pbasic_iss_cd
               || '-'
               || LTRIM (
                     TO_CHAR (v_gipisfetch_tab_cache (p1).issue_yy, '09'))
               || '-'
               || LTRIM (
                     TO_CHAR (v_gipisfetch_tab_cache (p1).pol_seq_no,
                              '0999999')));

         IF v_list.policy_no = '----'
         THEN
            v_list.policy_no := '';
         END IF;
         
         IF NVL(v_gipisfetch_tab_cache (p1).endt_seq_no,0) = 0 THEN
            v_list.endt_no := '';
         ELSE
            v_list.endt_no := 
            LTRIM (
                  v_gipisfetch_tab_cache (p1).endt_iss_cd
               || '-'
               || LTRIM (
                     TO_CHAR (v_gipisfetch_tab_cache (p1).endt_yy, '09'))
               || '-'
               || LTRIM (
                     TO_CHAR (v_gipisfetch_tab_cache (p1).endt_seq_no,
                              '0999999')));
         END IF;
         

         v_list.renew_no :=
            LTRIM (TO_CHAR (v_gipisfetch_tab_cache (p1).renew_no, '09'));
         v_list.incept_date := v_gipisfetch_tab_cache (p1).incept_date;
         v_list.expiry_date := v_gipisfetch_tab_cache (p1).expiry_date;
         v_list.eff_date := v_gipisfetch_tab_cache (p1).eff_date;
         v_list.issue_date := v_gipisfetch_tab_cache (p1).issue_date;
         v_list.cred_branch := v_gipisfetch_tab_cache (p1).cred_branch;
      END;

      FUNCTION VALIDATE
         RETURN NUMBER
      IS
         v_output   NUMBER;
      BEGIN
         IF v_valid2.EXISTS (
                  v_gipisfetch_rec.plist_line_cd
               || '-'
               || v_gipisfetch_rec.plist_iss_cd) = FALSE
         THEN
            v_valid2 (
                  v_gipisfetch_rec.plist_line_cd
               || '-'
               || v_gipisfetch_rec.plist_iss_cd) :=
               check_user_per_iss_cd2 (v_gipisfetch_rec.plist_line_cd,
                                       v_gipisfetch_rec.plist_iss_cd,
                                       'GIPIS131',
                                       p_user_id);
         END IF;

         IF v_valid2 (
                  v_gipisfetch_rec.plist_line_cd
               || '-'
               || v_gipisfetch_rec.plist_iss_cd) = 1
         THEN
            v_output := 1;
         END IF;

         RETURN v_output;
      END;

   BEGIN
      --added by john dolon 8.20.2015 --FOR SORTING
     IF p_col_order IS NULL THEN
        v_order_col_order_format := p_col_order_format;
        v_order_col_order := p_col_order;
      ELSE
        IF p_col_order = 'plistLineCd plistIssCd parYy parSeqNo quoteSeqNo' THEN
         IF NVL(p_col_order_format, 'ASC') = 'ASC'
          THEN
          v_col_order := 'plist_line_cd ASC, plist_iss_cd ASC, par_yy ASC, par_seq_no ASC, quote_seq_no ';
         ELSE
          v_col_order := 'plist_line_cd DESC, plist_iss_cd DESC, par_yy DESC, par_seq_no DESC, quote_seq_no ';
         END IF;
        ELSIF p_col_order = 'assdName' THEN
          v_col_order := 'assd_name';
        ELSIF p_col_order = 'parType' THEN
          v_col_order := 'par_type';
        ELSIF p_col_order = 'underwriter' THEN
          v_col_order := 'underwriter';
        ELSIF p_col_order = 'drvParStatus' THEN
          v_col_order := 'drv_par_status';
        ELSIF p_col_order = 'credBranch' THEN 
          v_col_order := 'cred_branch';
        END IF;
      END IF;
      
      v_order_col_order_format := p_col_order_format;
      v_order_col_order := v_col_order;
   /*Modified by pjsantos 11/09/2016, for optimization GENQA 5803*/
      --added by john for filtering cred_branch
     /* IF p_cred_branch = '' OR p_cred_branch IS NULL THEN
        v_cred_branch_cond := ' ';
      
      ELSE  p_cred_branch IS NOT NULL THEN
        v_cred_branch_cond := ' AND a.cred_branch LIKE ''' || UPPER(p_cred_branch) || '''';
      END IF;*/
      
      IF (p_date_as_of IS NULL OR p_date_as_of = '') AND (p_date_from IS NULL OR p_date_from = '') AND (p_date_to IS NULL OR p_date_to = '') THEN
        v_date_as_of := TO_CHAR(SYSDATE, 'fmMM-DD-YYYY');
      ELSE
        v_date_as_of := '';
      END IF;
      
         --added by carloR 07.26.2016 to check the Par status START
      IF p_par_stat = 'being_updated' THEN
        v_being_updated_cond := 
            ' AND DECODE (a.par_status,
                           1, ''new'',
                           2, ''new'',
                           3, ''being_updated'',
                           4, ''being_updated'',
                           5, ''being_updated'',
                           6, ''being_updated'',
                           7, ''being_updated'',
                           8, ''being_updated'',
                           9, ''being_updated'',
                           10, ''posted'',
                           98, ''cancelled'',
                           99, ''deleted'',
                           ''No Status Code'') =
                      NVL ('''
                         ||p_par_stat||''',
                         DECODE (a.par_status,
                                 1, ''new'',
                                 2, ''new'',
                                 3, ''being_updated'',
                                 4, ''being_updated'',
                                 5, ''being_updated'',
                                 6, ''being_updated'',
                                 7, ''being_updated'',
                                 8, ''being_updated'',
                                 9, ''being_updated'',
                                 10, ''posted'',
                                 98, ''cancelled'',
                                 99, ''deleted'',
                                 ''No Status Code'')) ';
                                 
        v_being_updated_status := '  
                               3, ''Being Updated'',
                               4, ''Being Updated'',
                               5, ''Being Updated'',
                               6, ''Being Updated'', ';
      ELSE 
        v_being_updated_cond :=
            ' AND DECODE (a.par_status,
                           1, ''new'',
                           2, ''new'',
                           3, ''with_basic'', 
                           4, ''with_item'',
                           5, ''with_peril'',
                           6, ''with_bill'',
                           7, ''being_updated'',
                           8, ''being_updated'',
                           9, ''being_updated'',
                           10, ''posted'',
                           98, ''cancelled'',
                           99, ''deleted'',
                           ''No Status Code'') =
                      NVL ('''||
                         p_par_stat||''',
                         DECODE (a.par_status,
                                 1, ''new'',
                                 2, ''new'',
                                 3, ''with_basic'',
                                 4, ''with_item'',
                                 5, ''with_peril'',
                                 6, ''with_bill'',
                                 7, ''being_updated'',
                                 8, ''being_updated'',
                                 9, ''being_updated'',
                                 10, ''posted'',
                                 98, ''cancelled'',
                                 99, ''deleted'',
                                 ''No Status Code'')) ';
                                 
                                 
                                 
                                                
        v_being_updated_status := ' 
                               3, ''With Basic Information'',
                               4, ''With Item Information'',
                               5, ''With Peril Information'',
                               6, ''With Bill'', ';
      END IF; --END
      
      
      
      
      
      v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (SELECT a.par_id, a.plist_line_cd, a.plist_iss_cd, a.par_yy, a.par_seq_no,
                       a.quote_seq_no, a.par_type, a.pbasic_line_cd, a.subline_cd,
                       a.pbasic_iss_cd, a.issue_yy, a.pol_seq_no, a.user_id, a.underwriter,
                       LTRIM (TO_CHAR (renew_no, ''09'')) renew_no, a.incept_date, a.expiry_date, a.eff_date,
                       a.issue_date, b.assd_name  ,
                       DECODE (a.par_status,
                               1, ''Newly Created'',
                               2, ''Just Assigned'','
                               || v_being_updated_status || '
                               6, ''Being Updated'',
                               7, ''Being Updated'',
                               8, ''Being Updated'',
                               9, ''Being Updated'',
                               10, ''Posted'',
                               98, ''Cancelled'',
                               99, ''Deleted'',
                               98, ''Cancelled'',
                               ''No Status Code'') drv_par_status ,
                               cred_branch, endt_iss_cd, endt_yy, DECODE(NVL(endt_seq_no,0),0,'''', LTRIM (
                                                                            endt_iss_cd
                                                                            || ''-''
                                                                            || LTRIM (
                                                                                  TO_CHAR (endt_yy, ''09''))
                                                                            || ''-''
                                                                            || LTRIM (
                                                                                  TO_CHAR (endt_seq_no, ''0999999'')))) endt_no,
                               DECODE (a.pbasic_line_cd, NULL ,'''',LTRIM (
                                      a.pbasic_line_cd
                                   || ''-''
                                   || a.subline_cd
                                   || ''-''
                                   || a.pbasic_iss_cd
                                   || ''-''
                                   || LTRIM (
                                      a.issue_yy, ''09''))
                                   || ''-''
                                   || LTRIM (a.pol_seq_no,
                                                  ''0999999'')) policy_no
                  FROM gipi_parlist_polbasic_v a,  giis_assured b
                 WHERE a.assd_no = b.assd_no (+) 
                   AND NVL(a.pack_par_id ,0)=0 
                   AND EXISTS (SELECT ''X''
                                 FROM TABLE (security_access.get_branch_line (''UW'', ''GIPIS131'', :p_user_id))
                                WHERE branch_cd = a.plist_iss_cd AND line_cd = a.plist_line_cd)
                   AND UPPER(a.plist_line_cd) LIKE UPPER(NVL(:p_plist_line_cd, ''%''))
                   AND UPPER(a.plist_iss_cd) LIKE UPPER(NVL(:p_plist_iss_cd, ''%''))       
                   AND a.quote_seq_no = NVL('''||p_quote_seq_no||''', a.quote_seq_no)
                   AND UPPER(NVL(b.assd_name, ''%'')) LIKE UPPER(NVL('''|| REPLACE(p_assd_name,'''','''''')||''', NVL(b.assd_name, ''%''))) '
                   || v_being_updated_cond || 
                   'AND (((TRUNC(DECODE(NVL('''|| p_search_by_opt||''', ''inceptDate''), ''inceptDate'', a.incept_date,
                                                                  ''effDate'', a.eff_date,
                                                                  ''issueDate'', a.issue_date)) >= TO_DATE('''||P_date_from||''', ''mm-dd-yyyy'')
                            AND TRUNC(DECODE(NVL('''||p_search_by_opt||''', ''inceptDate''), ''inceptDate'', a.incept_date,
                                                                  ''effDate'', a.eff_date,
                                                                  ''issueDate'', a.issue_date)) <= TO_DATE('''|| P_date_to ||''', ''mm-dd-yyyy''))
                            OR TRUNC(DECODE(NVL('''||p_search_by_opt||''', ''inceptDate''), ''inceptDate'', a.incept_date,
                                                                  ''effDate'', a.eff_date,
                                                                  ''issueDate'', a.issue_date)) <= TO_DATE(NVL('''|| P_date_as_of||''', '''|| v_date_as_of ||'''), ''mm-dd-yyyy'')
                            AND issue_date is not null AND eff_date is not null and incept_date is not null)
                            OR ( A.PAR_STATUS = 99
                                    AND NVL ('''||P_par_stat||''', '''') = ''deleted''
                                    AND a.issue_date IS NULL
                                    AND a.eff_date IS NULL
                                    AND a.incept_date IS NULL) ) '; 
      IF  p_cred_branch IS NOT NULL 
        THEN
        v_sql := v_sql || ' AND a.cred_branch LIKE ''' || UPPER(p_cred_branch) || '''';
      END IF;    
                                    
     IF p_par_yy IS NOT NULL
      THEN
       v_sql := v_sql ||' AND a.par_yy = '''||p_par_yy||''' ';  
     END IF;
      IF p_par_seq_no IS NOT NULL
      THEN
       v_sql := v_sql ||' AND a.par_seq_no = '''||p_par_seq_no||''' ';  
     END IF;
     IF p_par_type IS NOT NULL
      THEN
       v_sql := v_sql ||' AND UPPER(a.par_type) LIKE UPPER('''||p_par_type||''') ';
     END IF;
     IF p_underwriter IS NOT NULL
      THEN
       v_sql := v_sql ||' AND UPPER(a.underwriter) LIKE UPPER('''|| p_underwriter||''')  ';
     END IF;

       

     IF   v_order_col_order IS NOT NULL OR v_order_col_order_format IS NOT NULL
        THEN
         IF p_col_order = 'assdName' OR p_col_order = 'credBranch'
          THEN
            v_sql := v_sql || '  ORDER BY '||v_order_col_order || ' '|| v_order_col_order_format ||' NULLS LAST ) innersql) outersql) mainsql WHERE rownum_ BETWEEN '|| p_from_row ||' AND ' || p_to_row;
         ELSE
            v_sql := v_sql || '  ORDER BY '||v_order_col_order || ' '|| v_order_col_order_format ||' ) innersql) outersql) mainsql WHERE rownum_ BETWEEN '|| p_from_row ||' AND ' || p_to_row;
         END IF;
     ELSE
        v_sql := v_sql || '  ORDER BY plist_line_cd ASC, plist_iss_cd ASC, par_yy ASC, par_seq_no ASC, quote_seq_no ASC ) innersql ) outersql ) mainsql  WHERE rownum_ BETWEEN '|| p_from_row ||' AND ' || p_to_row;
     END IF;
 OPEN v_cursor FOR v_sql USING p_user_id, p_plist_line_cd, p_plist_iss_cd;
        
 FETCH v_cursor BULK COLLECT INTO par_status_list;  
   IF par_status_list.count !=0  
    THEN 
    FOR I IN par_status_list.FIRST..par_status_list.LAST
      LOOP      
         v_list.count_ := par_status_list(i).count_;
         v_list.rownum_:= par_status_list(i).rownum_;
         v_list.par_id:= par_status_list(i).par_id;
         v_list.plist_line_cd:= par_status_list(i).plist_line_cd;
         v_list.plist_iss_cd:= par_status_list(i).plist_iss_cd;
         v_list.par_yy:= par_status_list(i).par_yy;
         v_list.par_seq_no:= par_status_list(i).par_seq_no;
         v_list.quote_seq_no:= par_status_list(i).quote_seq_no;
         v_list.par_type:= par_status_list(i).par_type;
         v_list.underwriter:= par_status_list(i).underwriter;
         v_list.drv_par_status:= par_status_list(i).drv_par_status;
         v_list.assd_name:= par_status_list(i).assd_name;
         v_list.policy_no := par_status_list(i).policy_no;
            

        /* IF v_list.policy_no = '----'
         THEN
            v_list.policy_no := '';
         END IF;
         
         IF NVL(par_status_list(i).endt_seq_no,0) = 0 THEN
            v_list.endt_no := '';
         ELSE
            v_list.endt_no := 
            LTRIM (
                  par_status_list(i).endt_iss_cd
               || '-'
               || LTRIM (
                     TO_CHAR (par_status_list(i).endt_yy, '09'))
               || '-'
               || LTRIM (
                     TO_CHAR (par_status_list(i).endt_seq_no,
                              '0999999')));
         END IF;*/
         
         v_list.endt_no := par_status_list(i).endt_no;
         v_list.renew_no := par_status_list(i).renew_no;
         v_list.incept_date := par_status_list(i).incept_date;
         v_list.expiry_date := par_status_list(i).expiry_date;
         v_list.eff_date := par_status_list(i).eff_date;
         v_list.issue_date := par_status_list(i).issue_date;
         v_list.cred_branch :=par_status_list(i).cred_branch;
       PIPE ROW (v_list);       
      END LOOP;
    END IF;
    
    /* FETCH v_cursor INTO v_gipisfetch_rec;   
     EXIT WHEN v_cursor%NOTFOUND;
         v_list.count_ := v_gipisfetch_rec.count_;
         v_list.rownum_:= v_gipisfetch_rec.rownum_;
         v_list.par_id:= v_gipisfetch_rec.par_id;
         v_list.plist_line_cd:= v_gipisfetch_rec.plist_line_cd;
         v_list.plist_iss_cd:= v_gipisfetch_rec.plist_iss_cd;
         v_list.par_yy:= v_gipisfetch_rec.par_yy;
         v_list.par_seq_no:= v_gipisfetch_rec.par_seq_no;
         v_list.quote_seq_no:= v_gipisfetch_rec.quote_seq_no;
         v_list.par_type:= v_gipisfetch_rec.par_type;
         v_list.underwriter:= v_gipisfetch_rec.underwriter;
         v_list.drv_par_status:= v_gipisfetch_rec.drv_par_status;
         v_list.assd_name:= v_gipisfetch_rec.assd_name;
         v_list.policy_no := v_gipisfetch_rec.policy_no;
            

         IF v_list.policy_no = '----'
         THEN
            v_list.policy_no := '';
         END IF;
         
         IF NVL(v_gipisfetch_rec.endt_seq_no,0) = 0 THEN
            v_list.endt_no := '';
         ELSE
            v_list.endt_no := 
            LTRIM (
                  v_gipisfetch_rec.endt_iss_cd
               || '-'
               || LTRIM (
                     TO_CHAR (v_gipisfetch_rec.endt_yy, '09'))
               || '-'
               || LTRIM (
                     TO_CHAR (v_gipisfetch_rec.endt_seq_no,
                              '0999999')));
         END IF;
         

         v_list.renew_no :=
            LTRIM (TO_CHAR (v_gipisfetch_rec.renew_no, '09'));
         v_list.incept_date := v_gipisfetch_rec.incept_date;
         v_list.expiry_date := v_gipisfetch_rec.expiry_date;
         v_list.eff_date := v_gipisfetch_rec.eff_date;
         v_list.issue_date := v_gipisfetch_rec.issue_date;
         v_list.cred_branch :=v_gipisfetch_rec.cred_branch;
                 
         PIPE ROW (v_list);
   END LOOP;      
   CLOSE v_cursor;     
   /*   IF     p_cache = 1
         AND v_gipisfetch_tab_cache IS NOT NULL
         AND (NVL (v_order_col_order_format, 1) = NVL (p_col_order_format, 1))
         AND (NVL (v_order_col_order, 1) = NVL (p_col_order, 1))
         AND NVL (p_to_row, v_count) <= v_gipisfetch_tab_cache.COUNT
         AND p_from_row >= v_gipisfetch_tab_cache.FIRST
         AND compare (v_cache_search_by_opt, p_search_by_opt) = 1
         AND compare (v_cache_date_as_of, p_date_as_of) = 1
         AND compare (v_cache_date_from, p_date_from) = 1
         AND compare (v_cache_date_to, p_date_to) = 1
         AND compare (v_cache_par_stat, p_par_stat) = 1
         AND compare (v_cache_plist_line_cd, p_plist_line_cd) = 1
         AND compare (v_cache_plist_iss_cd, p_plist_iss_cd) = 1
         AND compare (v_cache_par_yy, p_par_yy) = 1
         AND compare (v_cache_par_seq_no, p_par_seq_no) = 1
         AND compare (v_cache_quote_seq_no, p_quote_seq_no) = 1
         AND compare (v_cache_assd_name, p_assd_name) = 1
         AND compare (v_cache_par_type, p_par_type) = 1
         AND compare (v_cache_underwriter, p_underwriter) = 1
         AND compare (v_cache_user_mod, get_count_user_modules) = 1
         AND compare (v_cache_parhist, get_count_parhist) = 1
         AND compare (v_cache_user_grp_mod, get_count_user_grp_modules) = 1
      THEN
         v_cache := 1;
      ELSE
         -----------------------------------------------------------------------------
         v_gipisfetch_tab_cache.DELETE;*/

        /* IF p_col_order IS NOT NULL
         THEN
            v_order_col_order_format := p_col_order_format;
            v_order_col_order := v_col_order;

            OPEN v_cursor FOR
                  v_sql
               || ' ORDER BY '
               || v_col_order
               || ' '
               || p_col_order_format
               USING p_plist_line_cd,
                     p_plist_iss_cd,
                     p_par_yy,
                     p_par_seq_no,
                     p_quote_seq_no,
                     p_assd_name,
                     p_par_type,
                     p_underwriter,
                     p_par_stat,
                     p_search_by_opt,
                     p_date_from,
                     p_search_by_opt,
                     p_date_to,
                     p_search_by_opt,
                     p_date_as_of,
                     p_par_stat;
         ELSE
            v_order_col_order_format := p_col_order_format;
            v_order_col_order := p_col_order;

            OPEN v_cursor FOR v_sql
               USING p_plist_line_cd,
                     p_plist_iss_cd,
                     p_par_yy,
                     p_par_seq_no,
                     p_quote_seq_no,
                     p_assd_name,
                     p_par_type,
                     p_underwriter,
                     p_par_stat,
                     p_search_by_opt,
                     p_date_from,
                     p_search_by_opt,
                     p_date_to,
                     p_search_by_opt,
                     p_date_as_of,
                     p_par_stat;
         END IF;

         -----------------------------------------------------------------------------
         LOOP
          FETCH v_cursor INTO v_gipisfetch_rec;

            DBMS_OUTPUT.PUT_LINE (v_cursor%ROWCOUNT || 'X');
            EXIT WHEN v_cursor%NOTFOUND;

            IF VALIDATE = 1
            THEN
               v_iterator := v_iterator + 1;

               IF v_iterator BETWEEN (p_from_row - v_per_cache_def)
                                 AND (p_to_row + v_per_cache_def)
               THEN
                  v_gipisfetch_tab_cache (v_iterator) := v_gipisfetch_rec;
               ELSIF v_iterator >= p_from_row AND p_to_row IS NULL
               THEN
                  v_gipisfetch_tab_cache (v_iterator) := v_gipisfetch_rec;
               END IF;
            END IF;
         END LOOP;

         CLOSE v_cursor;

         v_count := v_iterator;
     END IF;

      FOR I IN p_from_row .. NVL (p_to_row, v_count)
      LOOP
         poplist (I);
         PIPE ROW (v_list);
      END LOOP;

      IF NVL (p_to_row, v_count) - p_from_row > v_limit
      THEN
         v_gipisfetch_tab_cache := v_gipisfetch_tab_empty;
      END IF;

      IF p_cache != 1
      THEN
         v_gipisfetch_tab_cache.DELETE;
      END IF;

      cache_param;*/
     --pjsantos end GENQA 5803 
      RETURN;      
   END get_par_status;

   FUNCTION get_par_history (p_par_id gipi_parhist.par_id%TYPE)
      RETURN par_history_tab
      PIPELINED
   IS
      v_list   par_history_type;
   BEGIN
      FOR i IN (  SELECT parstat_date, parstat_cd, user_id
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
END;
/
