CREATE OR REPLACE PACKAGE BODY CPI.GIPIS171_PKG
/* Package Created by Edison
** This is for module GIPIS171 - Update/Add Warranties and Clauses Utility*/
AS
FUNCTION GET_GIPIS171_POLICIES (
     /* Created function by Edison
     ** Get all the policies to change its warranties and clauses. */
     p_user_id      giis_users.user_id%TYPE,
     p_line_cd      gipi_polbasic.line_cd%TYPE,
     p_subline_cd   gipi_polbasic.subline_cd%TYPE,
     p_iss_cd       gipi_polbasic.iss_cd%TYPE,
     p_issue_yy     gipi_polbasic.issue_yy%TYPE,
     p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
     p_renew_no     gipi_polbasic.renew_no%TYPE,
     p_par_line_cd  gipi_parlist.line_cd%TYPE,
     p_par_issue_cd gipi_parlist.iss_cd%TYPE,
     p_par_yy       gipi_parlist.par_yy%TYPE,
     p_par_seq_no   gipi_parlist.par_seq_no%TYPE,
     p_par_quote_seq_no  gipi_parlist.quote_seq_no%TYPE,
     --Added by MarkS SR5769 10.18.2016 OPTIMIZATION
     p_policy_no        VARCHAR2,
     p_endt_no          VARCHAR2,
     p_par_no           VARCHAR2,
     p_order_by          VARCHAR2,
     p_asc_desc_flag    VARCHAR2,
     p_from              NUMBER,
     p_to                NUMBER
     --END
   )
   RETURN gipi_polbasic_tab PIPELINED
   IS
      v_polbasic   gipi_polbasic_type;
      TYPE cur_type IS REF CURSOR;
      c        cur_type;
      v_rec   gipi_polbasic_type;
      v_sql   VARCHAR2(32767);
   BEGIN
      v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (';
                              
                     
                  v_sql := v_sql ||     'SELECT a.policy_id, a.assd_no, a.eff_date, a.expiry_date, a.par_id, 
                                           a.line_cd, a.subline_cd, a.issue_yy, a.pol_seq_no, a.renew_no,
                                           a.endt_iss_cd, a.endt_yy, a.endt_seq_no, a.iss_cd,
                                           b.line_cd par_line_cd, b.iss_cd par_issue_cd, b.par_yy par_yy,
                                           TO_CHAR(b.par_seq_no,''099999'') par_seq_no, TO_CHAR(b.quote_seq_no,''09'') quote_seq_no,
                                           b.line_cd || ''-'' || b.iss_cd || ''-'' ||      
                                                LTRIM(TO_CHAR(b.par_yy,''09'')) || ''-'' ||   
                                                LTRIM(TO_CHAR(b.par_seq_no,''099999'')) || ''-'' ||
                                                LTRIM(TO_CHAR(b.quote_seq_no,''09'')) par_no,
                                           a.line_cd || ''-''
                                                   || a.subline_cd
                                                   || ''-''
                                                   || a.iss_cd
                                                   || ''-''
                                                   || LTRIM (TO_CHAR (a.issue_yy, ''09''))
                                                   || ''-''
                                                   || LTRIM (TO_CHAR (a.pol_seq_no, ''0999999''))
                                                   || ''-''
                                                   || LTRIM (TO_CHAR (a.renew_no, ''09''))
                                                   || DECODE (
                                                         NVL (a.endt_seq_no, 0),
                                                         0, '''',
                                                            '' / ''
                                                         || a.endt_iss_cd
                                                         || ''-''
                                                         || LTRIM (TO_CHAR (a.endt_yy, ''09''))
                                                         || ''-''
                                                         || LTRIM (TO_CHAR (a.endt_seq_no, ''0999999''))
                                                      ) policy_no,
                                                      DECODE(a.endt_seq_no,0,NULL,a.endt_iss_cd|| '' - ''|| TO_CHAR (a.endt_yy, ''09'')|| '' - ''|| TO_CHAR (a.endt_seq_no, ''099999'')) endt_no,
                                                      (SELECT assd_name
                                                       FROM giis_assured ga, gipi_parlist gp
                                                      WHERE ga.assd_no = gp.assd_no AND gp.par_id = a.par_id) assd_name
                                        FROM gipi_polbasic a, gipi_parlist b
                                        WHERE a.par_id = b.par_id ';
                   IF p_line_cd IS NOT NULL THEN
                   v_sql := v_sql ||     'AND UPPER (a.line_cd)    LIKE UPPER (NVL ('''||p_line_cd||''', ''%'')) ';
                   END IF ;
                   
                   IF p_subline_cd IS NOT NULL THEN
                   v_sql := v_sql ||     'AND UPPER (a.subline_cd) LIKE UPPER (NVL ('''||p_subline_cd||''', ''%'')) ';
                   END IF ;
                   
                   IF p_iss_cd IS NOT NULL THEN
                   v_sql := v_sql ||     'AND UPPER (a.iss_cd)     LIKE UPPER (NVL ('''||p_iss_cd||''', ''%'')) ';
                   END IF ;
                   
                   IF p_issue_yy IS NOT NULL THEN
                   v_sql := v_sql ||     'AND a.issue_yy           = NVL ('''||p_issue_yy||''', a.issue_yy) ';
                   END IF ;
                   
                   IF p_pol_seq_no IS NOT NULL THEN
                   v_sql := v_sql ||     'AND a.pol_seq_no         = NVL ('''||p_pol_seq_no||''', a.pol_seq_no) ';
                   END IF ;
                   
                   IF p_renew_no IS NOT NULL THEN
                   v_sql := v_sql ||     'AND a.renew_no           = NVL ('''||p_renew_no||''', a.renew_no) ';
                   END IF ;
                   
                   IF p_par_line_cd IS NOT NULL THEN
                   v_sql := v_sql ||     'AND UPPER (b.line_cd)    LIKE UPPER (NVL ('''||p_par_line_cd||''', ''%'')) ';
                   END IF ;
                   
                   IF p_par_issue_cd IS NOT NULL THEN
                   v_sql := v_sql ||     'AND UPPER (b.iss_cd)     LIKE UPPER (NVL ('''||p_par_issue_cd||''', ''%'')) ';
                   END IF ;
                   
                   IF p_par_yy IS NOT NULL THEN
                   v_sql := v_sql ||     'AND b.par_yy             = NVL ('''||p_par_yy||''', b.par_yy) ';
                   END IF ;
                   
                   IF p_par_seq_no IS NOT NULL THEN
                   v_sql := v_sql ||     'AND b.par_seq_no         = NVL ('''||p_par_seq_no||''', b.par_seq_no) ';
                   END IF ;
                   
                   IF p_par_quote_seq_no IS NOT NULL THEN
                   v_sql := v_sql ||     'AND b.quote_seq_no       = NVL ('''||p_par_quote_seq_no||''', b.quote_seq_no) ';
                   END IF ;              
                       v_sql := v_sql ||     'AND EXISTS (SELECT ''X'' FROM TABLE (security_access.get_branch_line (''UW'', ''GIPIS171'', :p_user_id)) WHERE branch_cd = a.iss_cd AND line_cd=a.line_cd)';
      IF p_policy_no IS NOT NULL
        OR p_endt_no IS NOT NULL
        OR p_par_no IS NOT NULL
      THEN
                    v_sql := v_sql || ' AND (a.policy_no LIKE UPPER('''||p_policy_no||''')
                                             OR a.endt_no LIKE UPPER('''||p_endt_no||''')
                                             OR a.par_no LIKE UPPER('''||p_par_no||'''))';
      END IF;  
       IF p_order_by IS NOT NULL
      THEN
        IF p_order_by = 'policyNo'
        THEN        
          v_sql := v_sql || ' ORDER BY policy_no ';
        ELSIF p_order_by = 'endtNo'
        THEN
          v_sql := v_sql || ' ORDER BY endt_no ';
        ELSIF p_order_by = 'parNo'
        THEN
          v_sql := v_sql || ' ORDER BY par_no ';
        ELSIF p_order_by = 'assdName'
        THEN
          v_sql := v_sql || ' ORDER BY assd_name ';                                          
        END IF;        
        
        IF p_asc_desc_flag IS NOT NULL
        THEN
           v_sql := v_sql || p_asc_desc_flag;
        ELSE
           v_sql := v_sql || ' ASC';
        END IF; 
      END IF;      
        v_sql := v_sql || ') innersql ';
     
                                       
      v_sql := v_sql || '
                            ) outersql
                         ) mainsql
                    WHERE rownum_ BETWEEN '|| p_from ||' AND ' || p_to;
                    
OPEN c FOR v_sql USING  p_user_id;
      LOOP
         FETCH c INTO   v_rec.count_, 
                        v_rec.rownum_, 
                        v_rec.policy_id, 
                        v_rec.assd_no, 
                        v_rec.eff_date, 
                        v_rec.expiry_date, 
                        v_rec.par_id, 
                        v_rec.line_cd, 
                        v_rec.subline_cd, 
                        v_rec.issue_yy, 
                        v_rec.pol_seq_no, 
                        v_rec.renew_no,                                       
                        v_rec.endt_iss_cd, 
                        v_rec.endt_yy, 
                        v_rec.endt_seq_no, 
                        v_rec.iss_cd,
                        v_rec.par_line_cd, 
                        v_rec.par_issue_cd,
                        v_rec.par_yy,
                        v_rec.par_seq_no,
                        v_rec.quote_seq_no,
                        v_rec.par_no,
                        v_rec.policy_no,
                        v_rec.endt_no,
                        v_rec.assd_name;
         IF v_rec.endt_seq_no = 0
         THEN
            v_rec.endt_no      := NULL;
            v_rec.endt_iss_cd  := NULL;
            v_rec.endt_yy      := NULL;
            v_rec.endt_seq_no  := NULL;
         ELSE
            v_rec.endt_iss_cd  := v_rec.endt_iss_cd;
            v_rec.endt_yy      := TO_CHAR (v_rec.endt_yy, '09');
            v_rec.endt_seq_no  := TO_CHAR (v_rec.endt_seq_no, '099999');
         END IF;                                          
         EXIT WHEN c%NOTFOUND;                    
         PIPE ROW (v_rec);
      END LOOP;
      
      CLOSE c;
       RETURN;             
        
--    commented out for optimization SR5769                                           
--      FOR i IN (SELECT a.policy_id, a.assd_no, a.eff_date, a.expiry_date, a.par_id, 
--                       a.line_cd, a.subline_cd, a.issue_yy, a.pol_seq_no, a.renew_no,
--                       a.endt_iss_cd, a.endt_yy, a.endt_seq_no, a.iss_cd, 
--                       b.line_cd par_line_cd, b.iss_cd par_issue_cd, b.par_yy par_yy, TO_CHAR(b.par_seq_no,'099999') par_seq_no, TO_CHAR(b.quote_seq_no,'09') quote_seq_no
--                       
--                  FROM gipi_polbasic a, gipi_parlist b
--                 WHERE UPPER (a.line_cd)    LIKE UPPER (NVL (p_line_cd, '%'))
--                   AND UPPER (a.subline_cd) LIKE UPPER (NVL (p_subline_cd, '%'))
--                   AND UPPER (a.iss_cd)     LIKE UPPER (NVL (p_iss_cd, '%'))
--                   AND a.issue_yy           = NVL (p_issue_yy, a.issue_yy)
--                   AND a.pol_seq_no         = NVL (p_pol_seq_no, a.pol_seq_no)
--                   AND a.renew_no           = NVL (p_renew_no, a.renew_no)
--                   AND a.par_id             = b.par_id
--                   AND UPPER (b.line_cd)    LIKE UPPER (NVL (p_par_line_cd, '%'))
--                   AND UPPER (b.iss_cd)     LIKE UPPER (NVL (p_par_issue_cd, '%'))
--                   AND b.par_yy             = NVL (p_par_yy, b.par_yy)
--                   AND b.par_seq_no         = NVL (p_par_seq_no, par_seq_no)
--                   AND b.quote_seq_no       = NVL (p_par_quote_seq_no, quote_seq_no)
--                   AND EXISTS (SELECT 'X'
--                                 FROM TABLE (security_access.get_branch_line ('UW', 'GIPIS171', p_user_id))
--                                WHERE branch_cd = a.iss_cd AND line_cd=a.line_cd)-- Added by  MarkS 10.18.2016 SR5769 OPTIMIZATION
--                   --AND check_user_per_line2(a.line_cd, a.iss_cd,'GIPIS171',p_user_id) = 1 --added by jeffdojello 05.07.2013 -- commented out MarkS 10.18.2016 SR5769 OPTIMIZATION
--                 ORDER BY a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,  a.pol_seq_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no)
--      LOOP
--         v_polbasic.policy_id   := i.policy_id;
--         --v_polbasic.policy_no   := gipi_polbasic_pkg.get_policy_no (i.policy_id) -- commented out MarkS 10.18.2016 SR5769 OPTIMIZATION
--         v_polbasic.policy_no   := i.line_cd
--                                    || '-'
--                                    || i.subline_cd
--                                    || '-'
--                                    || i.iss_cd
--                                    || '-'
--                                    || LTRIM (TO_CHAR (i.issue_yy, '09'))
--                                    || '-'
--                                    || LTRIM (TO_CHAR (i.pol_seq_no, '0999999'))
--                                    || '-'
--                                    || LTRIM (TO_CHAR (i.renew_no, '09')); -- Added by  MarkS 10.18.2016 SR5769 OPTIMIZATION;
--         v_polbasic.assd_no     := i.assd_no;
--         v_polbasic.eff_date    := i.eff_date;
--         v_polbasic.expiry_date := i.expiry_date;
--         v_polbasic.par_id      := i.par_id;
--         v_polbasic.line_cd     := i.line_cd;
--         v_polbasic.subline_cd  := i.subline_cd;
--         v_polbasic.iss_cd      := i.iss_cd;
--         v_polbasic.issue_yy    := i.issue_yy;
--         v_polbasic.pol_seq_no  := i.pol_seq_no;
--         v_polbasic.renew_no    := i.renew_no;
--         v_polbasic.par_line_cd := i.par_line_cd;
--         v_polbasic.par_issue_cd:= i.par_issue_cd;
--         v_polbasic.par_yy      := i.par_yy;
--         v_polbasic.par_seq_no  := i.par_seq_no;
--         v_polbasic.quote_seq_no:= i.quote_seq_no;
--         
--         SELECT line_cd || '-' || iss_cd || '-' ||      
--                LTRIM(TO_CHAR(par_yy,'09')) || '-' ||   --modified by gzelle 12.17.2012, number format
--                LTRIM(TO_CHAR(par_seq_no,'099999')) || '-' ||
--                LTRIM(TO_CHAR(quote_seq_no,'09'))
--           INTO v_polbasic.par_no
--           FROM gipi_parlist
--          WHERE par_id = i.par_id;
--         
--         IF i.endt_seq_no = 0
--         THEN
--            v_polbasic.endt_no      := NULL;
--            v_polbasic.endt_iss_cd  := NULL;
--            v_polbasic.endt_yy      := NULL;
--            v_polbasic.endt_seq_no  := NULL;
--         ELSE
--            v_polbasic.endt_no      := i.endt_iss_cd|| ' - '|| TO_CHAR (i.endt_yy, '09')|| ' - '|| TO_CHAR (i.endt_seq_no, '099999');
--            v_polbasic.endt_iss_cd  := i.endt_iss_cd;
--            v_polbasic.endt_yy      := TO_CHAR (i.endt_yy, '09');
--            v_polbasic.endt_seq_no  := TO_CHAR (i.endt_seq_no, '099999');
--         END IF;
--         
--         BEGIN
--            FOR assd IN (SELECT assd_name
--                           FROM giis_assured a, gipi_parlist b
--                          WHERE a.assd_no = b.assd_no AND b.par_id = i.par_id)
--            LOOP
--               v_polbasic.assd_name := assd.assd_name;
--            END LOOP;
--         END;

--         PIPE ROW (v_polbasic);
--      END LOOP;

--      RETURN;
--    end out for optimization SR5769     
   END;
   
   FUNCTION GET_GIPIS171_WARRCLA (
     /* Created function by Edison
     ** To get the warranties and clauses of the selected policy. */
     p_policy_id    gipi_polbasic.policy_id%TYPE,
     p_print_seq_no gipi_polwc.print_seq_no%TYPE,
     p_warr_title   gipi_polwc.wc_title%TYPE
   )
   RETURN gipi_polwc_tab PIPELINED
   IS
      v_polwc   gipi_polwc_type;
   BEGIN
      FOR i IN (SELECT a.policy_id, a.line_cd, a.wc_cd, a.print_seq_no, a.wc_title,
                       a.wc_text01, a.wc_text02, a.wc_text03, a.wc_text04, a.wc_text05,
                       a.wc_text06, a.wc_text07, a.wc_text08, a.wc_text09, a.wc_text10, 
                       a.wc_text11, a.wc_text12, a.wc_text13, a.wc_text14, a.wc_text15,
                       a.wc_text16, a.wc_text17, a.wc_remarks, a.print_sw, a.change_tag,
                       a.wc_title2, DECODE(b.wc_sw, 'C', 'Clauses', 'Warranty') wc_sw
                  FROM gipi_polwc a, giis_warrcla b
                 WHERE a.policy_id = p_policy_id
                   AND a.wc_cd = b.main_wc_cd
                   AND a.line_cd = b.line_cd
                   AND a.print_seq_no = NVL(p_print_seq_no, a.print_seq_no)
                   AND UPPER(a.wc_title) LIKE UPPER(NVL(p_warr_title, '%'))
                   ORDER BY a.print_seq_no    --added by gzelle 12.17.2012 arrange records accdg. to print_seq_no
              )
      LOOP
         v_polwc.policy_id   := i.policy_id;
         v_polwc.line_cd     := i.line_cd;
         v_polwc.wc_cd       := i.wc_cd;
         v_polwc.print_seq_no:= i.print_seq_no;
         v_polwc.wc_title    := i.wc_title;
         v_polwc.wc_remarks  := i.wc_remarks;
         v_polwc.print_sw    := i.print_sw;
         v_polwc.change_tag  := i.change_tag;
         v_polwc.wc_title2   := i.wc_title2;
         v_polwc.wc_sw       := i.wc_sw;
         
         IF NVL(i.change_tag,'N') = 'Y' THEN         
            v_polwc.wc_text01     := i.wc_text01;
            v_polwc.wc_text02     := i.wc_text02;
            v_polwc.wc_text03     := i.wc_text03;
            v_polwc.wc_text04     := i.wc_text04;
            v_polwc.wc_text05     := i.wc_text05;
            v_polwc.wc_text06     := i.wc_text06;
            v_polwc.wc_text07     := i.wc_text07;
            v_polwc.wc_text08     := i.wc_text08;
            v_polwc.wc_text09     := i.wc_text09;
            v_polwc.wc_text10     := i.wc_text10;
            v_polwc.wc_text11     := i.wc_text11;
            v_polwc.wc_text12     := i.wc_text12;
            v_polwc.wc_text13     := i.wc_text13;
            v_polwc.wc_text14     := i.wc_text14;
            v_polwc.wc_text15     := i.wc_text15;
            v_polwc.wc_text16     := i.wc_text16;
            v_polwc.wc_text17     := i.wc_text17;            
        ELSE 
            SELECT wc_text01,wc_text02,
                   wc_text03,wc_text04,
                   wc_text05,wc_text06,
                   wc_text07,wc_text08,
                   wc_text09,wc_text10,
                   wc_text11,wc_text12,
                   wc_text13,wc_text14,
                   wc_text15,wc_text16,
                   wc_text17
              INTO v_polwc.wc_text01,
                   v_polwc.wc_text02,
                   v_polwc.wc_text03,
                   v_polwc.wc_text04,
                   v_polwc.wc_text05,
                   v_polwc.wc_text06,
                   v_polwc.wc_text07,
                   v_polwc.wc_text08,
                   v_polwc.wc_text09,
                   v_polwc.wc_text10,
                   v_polwc.wc_text11,
                   v_polwc.wc_text12,
                   v_polwc.wc_text13,
                   v_polwc.wc_text14,
                   v_polwc.wc_text15,
                   v_polwc.wc_text16,
                   v_polwc.wc_text17
              FROM GIIS_WARRCLA
             WHERE line_cd    = i.line_cd
               AND main_wc_cd = i.wc_cd;
            
        END IF;
      
         PIPE ROW (v_polwc);
      END LOOP;

      RETURN;
   END GET_GIPIS171_WARRCLA;
  PROCEDURE del_gipi_polwc (p_line_cd   GIPI_POLWC.line_cd%TYPE,
                            p_policy_id GIPI_POLWC.policy_id%TYPE,
                            p_wc_cd     GIPI_POLWC.wc_cd%TYPE)
  /* Procedure created by Edison
  ** To delete warranties or clauses of the selected policy. */
  IS
  BEGIN
      
    DELETE FROM GIPI_POLWC
     WHERE line_cd = p_line_cd
       AND policy_id  = p_policy_id
       AND wc_cd   = p_wc_cd;
    
  END del_gipi_polwc; 
  
  Procedure set_gipi_polwc (p_polwc GIPI_POLWC%ROWTYPE)
  /* Procedure created by Edison
  ** To add or update the warraties or clauses of the selected policy. */
  IS     
  BEGIN
     MERGE INTO GIPI_POLWC
     USING DUAL ON (line_cd   = p_polwc.line_cd
                AND policy_id = p_polwc.policy_id
                AND wc_cd     = p_polwc.wc_cd)
       WHEN NOT MATCHED THEN
               INSERT ( policy_id, line_cd, wc_cd, print_seq_no, wc_title, wc_text01, wc_text02,
                        wc_text03, wc_text04, wc_text05, wc_text06, wc_text07, wc_text08,
                        wc_text09, wc_text10, wc_text11, wc_text12, wc_text13, wc_text14,
                        wc_text15, wc_text16, wc_text17, wc_remarks, print_sw, change_tag,
                        wc_title2, swc_seq_no
                        )
            VALUES ( p_polwc.policy_id, p_polwc.line_cd, p_polwc.wc_cd,p_polwc.print_seq_no, 
                     p_polwc.wc_title, p_polwc.wc_text01, p_polwc.wc_text02, p_polwc.wc_text03,
                     p_polwc.wc_text04, p_polwc.wc_text05, p_polwc.wc_text06, p_polwc.wc_text07,
                     p_polwc.wc_text08, p_polwc.wc_text09, p_polwc.wc_text10, p_polwc.wc_text11,
                     p_polwc.wc_text12, p_polwc.wc_text13, p_polwc.wc_text14, p_polwc.wc_text15,
                     p_polwc.wc_text16, p_polwc.wc_text17, p_polwc.wc_remarks, p_polwc.print_sw,
                     p_polwc.change_tag, p_polwc.wc_title2, p_polwc.swc_seq_no
                     )
       WHEN MATCHED THEN
               UPDATE SET wc_title          = p_polwc.wc_title,
                          wc_title2         = p_polwc.wc_title2,
                          wc_text01         = p_polwc.wc_text01, 
                          wc_text02         = p_polwc.wc_text02, 
                          wc_text03         = p_polwc.wc_text03, 
                          wc_text04         = p_polwc.wc_text04, 
                          wc_text05         = p_polwc.wc_text05, 
                          wc_text06         = p_polwc.wc_text06, 
                          wc_text07         = p_polwc.wc_text07, 
                          wc_text08         = p_polwc.wc_text08, 
                          wc_text09         = p_polwc.wc_text09, 
                          wc_text10         = p_polwc.wc_text10, 
                          wc_text11         = p_polwc.wc_text11, 
                          wc_text12         = p_polwc.wc_text12, 
                          wc_text13         = p_polwc.wc_text13, 
                          wc_text14         = p_polwc.wc_text14, 
                          wc_text15         = p_polwc.wc_text15, 
                          wc_text16         = p_polwc.wc_text16, 
                          wc_text17         = p_polwc.wc_text17, 
                          change_tag        = p_polwc.change_tag,
                          wc_remarks        = p_polwc.wc_remarks,
                          print_sw          = p_polwc.print_sw,
                          swc_seq_no        = p_polwc.swc_seq_no,
                          print_seq_no      = p_polwc.print_seq_no;
             
  END set_gipi_polwc;
  
  /*
**  Created by   :  Maria Gzelle Ison
**  Date Created :  December 26, 2012
**  Reference By : (GIPIS171 - Utilities - Update/Add Warranties and Clauses)
**  Description  : retrieves warranties and clauese of the given line_cd. (for new lov version)
*/
   FUNCTION get_warrcla_list_lov (p_line_cd GIIS_WARRCLA.line_cd%TYPE,
                                  p_wc_title GIIS_WARRCLA.wc_title%TYPE)
    RETURN warrcla_with_text_tab PIPELINED IS

    v_warrcla    warrcla_with_text;

  BEGIN
    FOR i IN (
        SELECT main_wc_cd, line_cd, print_sw, wc_title,
               wc_text01, wc_text02, wc_text03, wc_text04, wc_text05, wc_text06, wc_text07, wc_text08, wc_text09, wc_text10,
               wc_text11, wc_text12, wc_text13, wc_text14, wc_text15, wc_text16, wc_text17,
               text_update_sw, DECODE(NVL(wc_sw,'W'),'W','Warranty','Clause') wc_sw,
               remarks
          FROM GIIS_WARRCLA
         WHERE line_cd = p_line_cd
          /* AND main_wc_cd NOT IN (SELECT wc_cd
                                    FROM GIPI_POLWC
                                   WHERE line_cd = p_line_cd) */ -- commented out by Kris 05.20.2013 PF SR_13004
           AND UPPER(wc_title) LIKE UPPER(NVL(p_wc_title, '%'))
           AND active_tag = 'A' --added by carlo SR 5915 01-25-2017
         ORDER BY UPPER(wc_title))
    LOOP
        v_warrcla.line_cd         := i.line_cd;
        v_warrcla.main_wc_cd      := i.main_wc_cd;
        v_warrcla.wc_title        := i.wc_title;
        v_warrcla.print_sw        := i.print_sw;
        v_warrcla.wc_text01       := i.wc_text01;
        v_warrcla.wc_text02       := i.wc_text02;
        v_warrcla.wc_text03       := i.wc_text03;
        v_warrcla.wc_text04       := i.wc_text04;
        v_warrcla.wc_text05       := i.wc_text05;
        v_warrcla.wc_text06       := i.wc_text06;
        v_warrcla.wc_text07       := i.wc_text07;
        v_warrcla.wc_text08       := i.wc_text08;
        v_warrcla.wc_text09       := i.wc_text09;
        v_warrcla.wc_text10       := i.wc_text10;
        v_warrcla.wc_text11       := i.wc_text11;
        v_warrcla.wc_text12       := i.wc_text12;
        v_warrcla.wc_text13       := i.wc_text13;
        v_warrcla.wc_text14       := i.wc_text14;
        v_warrcla.wc_text15       := i.wc_text15;
        v_warrcla.wc_text16       := i.wc_text16;
        v_warrcla.wc_text17       := i.wc_text17;
        v_warrcla.text_update_sw  := i.text_update_sw;
        v_warrcla.wc_sw           := i.wc_sw;
        v_warrcla.remarks         := i.remarks;
      PIPE ROW(v_warrcla);
    END LOOP;

    RETURN;
  END get_warrcla_list_lov;


   FUNCTION validate_warrcla (p_wc_title GIIS_WARRCLA.wc_title%TYPE)
    RETURN VARCHAR2
   IS
      v_temp VARCHAR2(1);
       BEGIN
            SELECT(SELECT '1'
                     FROM GIIS_WARRCLA
                     WHERE UPPER(wc_title) LIKE UPPER(NVL(p_wc_title, '%')))
            INTO v_temp
            FROM DUAL;
         
         IF v_temp IS NOT NULL
         THEN
            RETURN '1';
         ELSE
            RETURN '0';
         END IF;   
         
         END;  
END;
/
