CREATE OR REPLACE PACKAGE BODY CPI.GIACR354_pkg
AS

   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 10.18.2013
   **  Reference By : GIACR354
   **  Remarks      : BATCH CHECKING REPORT
   */    
  
    FUNCTION get_main_report(
        p_user_id       giac_batch_check_gross_ext.user_id%TYPE
    )
        RETURN main_report_tab PIPELINED
    IS
        v_rep    main_report_type;
        v_print  BOOLEAN := TRUE;
        v_temp   VARCHAR2(300) := null; 
        v_net    BOOLEAN := FALSE;
    BEGIN
    
        v_rep.cf_company := giacp.v('COMPANY_NAME');
        v_rep.cf_address := giacp.v('COMPANY_ADDRESS');
        
        BEGIN
            SELECT report_title
              INTO v_rep.cf_title
              FROM giis_reports
             WHERE report_id = 'BATCHCHECK';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rep.cf_title := 'BATCH CHECKING SUMMARY';              
        END;

        BEGIN
            SELECT 'For the month of '||TO_CHAR(to_date,'fmMONTH')
              INTO v_rep.cf_subtitle
              FROM giac_batch_check_gross_ext
             WHERE ROWNUM = 1;   
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rep.cf_subtitle := 'No Data';   
        END;               

        FOR i IN(SELECT l.line_name, g.gl_acct_sname, g.prem_amt, g.balance,(g.prem_amt-g.balance) diff, 0 net,1 type, 'Gross Premiums' col_header
                   FROM giac_batch_check_gross_ext g, giis_line l
                  WHERE g.line_cd = l.line_cd
                    AND g.user_id = p_user_id
                 UNION
                 SELECT i.line_name, f.gl_acct_sname, f.prem_amt, f.balance,(f.prem_amt-f.balance) diff, 0 net,2 type, 'Facultative' col_header
                   FROM giac_batch_check_facul_ext f, giis_line i
                  WHERE f.line_cd = i.line_cd
                    AND f.user_id = p_user_id
                 UNION  
                 SELECT n.line_name, t.gl_acct_sname, t.prem_amt, t.balance,(t.prem_amt-t.balance) diff, 0 net,3 type, 'Treaty' col_header
                   FROM giac_batch_check_treaty_ext t, giis_line n
                  WHERE t.line_cd = n.line_cd
                    AND t.user_id = p_user_id
                 UNION
--                 SELECT a.line_cd, e.line_name, nvl(a.prem_amt,0)gross, nvl(b.prem_amt,0) facul,
--                        nvl(c.prem_amt,0) treaty,(NVL(a.prem_amt,0)-NVL(b.prem_amt,0)-NVL(c.prem_amt,0)) net,4 type, 'Net' col_header
--                   FROM giac_batch_check_gross_ext a, 
--                        giac_batch_check_facul_ext b, 
--                        giac_batch_check_treaty_ext c,
--                        giis_line e
--                  WHERE a.line_cd = b.line_cd (+)
--                    AND b.line_cd = c.line_cd(+)
--                    AND a.line_cd = e.line_cd
SELECT a.line_cd, b.line_name, SUM (DECODE (tag, 'GPW', prem, 0)) * -1 gross,
                        SUM (DECODE (tag, 'FACUL', prem, 0)) facul,
                        SUM (DECODE (tag, 'TREATY', prem, 0)) treaty, SUM (prem) * -1 net, 4 type, 'Net' col_header
                   FROM (SELECT 'GPW' tag, line_cd, SUM (prem_amt) prem
                           FROM giac_batch_check_gross_ext
                          WHERE base_amt IN ('1PREMIUM', '7RI PREMIUM')
                            AND user_id = p_user_id
                          GROUP BY line_cd
                          UNION ALL
                         SELECT 'FACUL' tag, line_cd, SUM (prem_amt) prem
                           FROM giac_batch_check_facul_ext
                          WHERE base_amt IN ('1PREMIUM', '2PREMIUM')
                            AND user_id = p_user_id
                          GROUP BY line_cd
                          UNION ALL
                         SELECT 'TREATY' tag, line_cd, SUM (prem_amt) prem
                           FROM giac_batch_check_treaty_ext
                          WHERE base_amt IN ('1PREMIUM', '2PREMIUM')
                            AND user_id = p_user_id
                          GROUP BY line_cd) a,
                                giis_line b
                          WHERE b.line_cd = a.line_cd
                          GROUP BY a.line_cd, b.line_name
               ORDER BY type)
        LOOP
            v_print             := FALSE;
            v_rep.line_name     := i.line_name;
            v_rep.gl_acct_sname := i.gl_acct_sname;
            v_rep.prem_amt      := i.prem_amt;
            v_rep.balance       := i.balance;
            v_rep.difference    := i.diff;
            v_rep.net           := i.net;
            v_rep.type          := i.type;
            v_rep.col_header    := i.col_header;
            IF i.type = 4 THEN
                v_net := TRUE;
            END IF;
            PIPE ROW(v_rep);    
        END LOOP;

        FOR l IN(SELECT line_cd
                   FROM giac_batch_check_gross_ext
                  WHERE ROWNUM = 1)
        LOOP
            v_temp  := l.line_cd;
        END LOOP;
        
        IF v_temp IS NULL THEN
            v_print             := FALSE;
            v_rep.line_name     := NULL;
            v_rep.gl_acct_sname := NULL;
            v_rep.prem_amt      := NULL;
            v_rep.balance       := NULL;
            v_rep.difference    := NULL;
            v_rep.net           := NULL;                
            v_rep.type          := 1;
            v_rep.col_header    := 'Gross Premiums';
            PIPE ROW(v_rep);
        ELSE 
            v_temp              := NULL;
        END IF; 

        FOR c IN(SELECT line_cd
                   FROM giac_batch_check_facul_ext
                  WHERE ROWNUM = 1)
        LOOP
            v_temp  := c.line_cd;
        END LOOP;
        
        IF v_temp IS NULL THEN
            v_print             := FALSE;
            v_rep.line_name     := NULL;
            v_rep.gl_acct_sname := NULL;
            v_rep.prem_amt      := NULL;
            v_rep.balance       := NULL;
            v_rep.difference    := NULL;
            v_rep.net           := NULL;                
            v_rep.type          := 2;
            v_rep.col_header    := 'Facultative';
            v_temp              := NULL;
            PIPE ROW(v_rep);
        ELSE 
            v_temp              := NULL;            
        END IF;         
                
        FOR k IN(SELECT line_cd
                   FROM giac_batch_check_treaty_ext
                  WHERE ROWNUM = 1)
        LOOP
            v_temp  := k.line_cd;
        END LOOP;     
        
        IF v_temp IS NULL THEN
            v_print             := FALSE;
            v_rep.line_name     := NULL;
            v_rep.gl_acct_sname := NULL;
            v_rep.prem_amt      := NULL;
            v_rep.balance       := NULL;
            v_rep.difference    := NULL;
            v_rep.net           := NULL;                
            v_rep.type          := 3;
            v_rep.col_header    := 'Treaty';
            v_temp              := NULL;
            PIPE ROW(v_rep);
        ELSE 
            v_temp              := NULL;            
        END IF;
        
        IF v_net <> TRUE THEN
            FOR n IN(SELECT a.line_cd
                       FROM giac_batch_check_gross_ext a, 
                            giac_batch_check_facul_ext b, 
                            giac_batch_check_treaty_ext c
                      WHERE ROWNUM = 1)
            LOOP
                v_temp  := n.line_cd;
            END LOOP;     
            
            IF v_temp IS NULL THEN
                v_print             := FALSE;
                v_rep.line_name     := NULL;
                v_rep.gl_acct_sname := NULL;
                v_rep.prem_amt      := NULL;
                v_rep.balance       := NULL;
                v_rep.difference    := NULL;
                v_rep.net           := NULL;                
                v_rep.type          := 4;
                v_rep.col_header    := 'Net';
                v_temp              := NULL;
                PIPE ROW(v_rep);
            ELSE 
                v_temp              := NULL;            
            END IF;
        END IF;        
              
        IF v_print
        THEN
            v_rep.v_print := 'TRUE';
            PIPE ROW (v_rep);
        END IF;
    END get_main_report;
    
    FUNCTION get_gross(
        p_user_id       giac_batch_check_gross_ext.user_id%TYPE
    )
      RETURN main_report_tab PIPELINED
    IS
        v_rep           main_report_type;
        v_exists        VARCHAR2(1) := 'N';
    BEGIN
        v_rep.cf_company := giacp.v('COMPANY_NAME');
        v_rep.cf_address := giacp.v('COMPANY_ADDRESS');
        
        BEGIN
            SELECT report_title
              INTO v_rep.cf_title
              FROM giis_reports
             WHERE report_id = 'BATCHCHECK';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rep.cf_title := 'BATCH CHECKING SUMMARY';              
        END;

        BEGIN
            SELECT 'For the month of '||TO_CHAR(to_date,'fmMONTH')
              INTO v_rep.cf_subtitle
              FROM giac_batch_check_gross_ext
             WHERE ROWNUM = 1;   
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rep.cf_subtitle := 'No Data';   
        END;
        
        FOR i IN(SELECT l.line_name, g.gl_acct_sname, g.prem_amt, g.balance,(g.prem_amt-g.balance) diff, 0 net, 1 type
                   FROM giac_batch_check_gross_ext g, 
                        giis_line l
                  WHERE g.line_cd = l.line_cd
                    AND g.user_id = p_user_id)
        LOOP
            v_exists := 'Y';
            v_rep.line_name     := i.line_name;
            v_rep.gl_acct_sname := i.gl_acct_sname;
            v_rep.prem_amt      := i.prem_amt;
            v_rep.balance       := i.balance;
            v_rep.difference    := i.diff;
            v_rep.net           := i.net;
            v_rep.type          := i.type;
            PIPE ROW(v_rep);
        END LOOP;
        
        IF v_exists = 'N' THEN
            PIPE ROW(v_rep);
        END IF;
    END;
    
    FUNCTION get_facultative(
        p_user_id       giac_batch_check_gross_ext.user_id%TYPE
    )
      RETURN main_report_tab PIPELINED
    IS
        v_rep           main_report_type;
        v_exists        VARCHAR2(1) := 'N';
    BEGIN
        v_rep.cf_company := giacp.v('COMPANY_NAME');
        v_rep.cf_address := giacp.v('COMPANY_ADDRESS');
        
        BEGIN
            SELECT report_title
              INTO v_rep.cf_title
              FROM giis_reports
             WHERE report_id = 'BATCHCHECK';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rep.cf_title := 'BATCH CHECKING SUMMARY';              
        END;

        BEGIN
            SELECT 'For the month of '||TO_CHAR(to_date,'fmMONTH')
              INTO v_rep.cf_subtitle
              FROM giac_batch_check_facul_ext
             WHERE ROWNUM = 1;   
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rep.cf_subtitle := 'No Data';   
        END;
        
        FOR i IN(SELECT i.line_name, f.gl_acct_sname, f.prem_amt, f.balance,(f.prem_amt-f.balance) diff, 0 net,2 type
                   FROM giac_batch_check_facul_ext f,
                        giis_line i
                  WHERE f.line_cd = i.line_cd
                    AND f.user_id = p_user_id)
        LOOP
            v_exists := 'Y';
            v_rep.line_name     := i.line_name;
            v_rep.gl_acct_sname := i.gl_acct_sname;
            v_rep.prem_amt      := i.prem_amt;
            v_rep.balance       := i.balance;
            v_rep.difference    := i.diff;
            v_rep.net           := i.net;
            v_rep.type          := i.type;
            PIPE ROW(v_rep);
        END LOOP;
        
        IF v_exists = 'N' THEN
            PIPE ROW(v_rep);
        END IF;
    END;
    
    FUNCTION get_treaty(
        p_user_id       giac_batch_check_gross_ext.user_id%TYPE
    )
      RETURN main_report_tab PIPELINED
    IS
        v_rep           main_report_type;
        v_exists        VARCHAR2(1) := 'N';
    BEGIN
        v_rep.cf_company := giacp.v('COMPANY_NAME');
        v_rep.cf_address := giacp.v('COMPANY_ADDRESS');
        
        BEGIN
            SELECT report_title
              INTO v_rep.cf_title
              FROM giis_reports
             WHERE report_id = 'BATCHCHECK';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rep.cf_title := 'BATCH CHECKING SUMMARY';              
        END;

        BEGIN
            SELECT 'For the month of '||TO_CHAR(to_date,'fmMONTH')
              INTO v_rep.cf_subtitle
              FROM giac_batch_check_facul_ext
             WHERE ROWNUM = 1;   
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rep.cf_subtitle := 'No Data';   
        END;
        
        FOR i IN(SELECT n.line_name, t.gl_acct_sname, t.prem_amt, t.balance,(t.prem_amt-t.balance) diff, 0 net,3 type
                   FROM giac_batch_check_treaty_ext t,
                        giis_line n
                  WHERE t.line_cd = n.line_cd
                    AND t.user_id = p_user_id)
        LOOP
            v_exists := 'Y';
            v_rep.line_name     := i.line_name;
            v_rep.gl_acct_sname := i.gl_acct_sname;
            v_rep.prem_amt      := i.prem_amt;
            v_rep.balance       := i.balance;
            v_rep.difference    := i.diff;
            v_rep.net           := i.net;
            v_rep.type          := i.type;
            PIPE ROW(v_rep);
        END LOOP;
        
        IF v_exists = 'N' THEN
            PIPE ROW(v_rep);
        END IF;
    END;
    
    FUNCTION get_net(
        p_user_id       giac_batch_check_gross_ext.user_id%TYPE
    )
      RETURN main_report_tab PIPELINED
    IS
        v_rep           main_report_type;
        v_exists        VARCHAR2(1) := 'N';
    BEGIN
        v_rep.cf_company := giacp.v('COMPANY_NAME');
        v_rep.cf_address := giacp.v('COMPANY_ADDRESS');
        
        BEGIN
            SELECT report_title
              INTO v_rep.cf_title
              FROM giis_reports
             WHERE report_id = 'BATCHCHECK';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rep.cf_title := 'BATCH CHECKING SUMMARY';              
        END;

        BEGIN
            SELECT 'For the month of '||TO_CHAR(to_date,'fmMONTH')
              INTO v_rep.cf_subtitle
              FROM giac_batch_check_facul_ext
             WHERE ROWNUM = 1;   
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rep.cf_subtitle := 'No Data';   
        END;
        
        FOR k IN(SELECT a.line_cd, b.line_name, SUM (DECODE (tag, 'GPW', prem, 0)) * -1 gross,
                        SUM (DECODE (tag, 'FACUL', prem, 0)) facul,
                        SUM (DECODE (tag, 'TREATY', prem, 0)) treaty, SUM (prem) * -1 net
                   FROM (SELECT 'GPW' tag, line_cd, SUM (prem_amt) prem
                           FROM giac_batch_check_gross_ext
                          WHERE base_amt IN ('1PREMIUM', '7RI PREMIUM')
                            AND user_id = p_user_id
                          GROUP BY line_cd
                          UNION ALL
                         SELECT 'FACUL' tag, line_cd, SUM (prem_amt) prem
                           FROM giac_batch_check_facul_ext
                          WHERE base_amt IN ('1PREMIUM', '2PREMIUM')
                            AND user_id = p_user_id
                          GROUP BY line_cd
                          UNION ALL
                         SELECT 'TREATY' tag, line_cd, SUM (prem_amt) prem
                           FROM giac_batch_check_treaty_ext
                          WHERE base_amt IN ('1PREMIUM', '2PREMIUM')
                            AND user_id = p_user_id
                          GROUP BY line_cd) a,
                                giis_line b
                          WHERE b.line_cd = a.line_cd
                          GROUP BY a.line_cd, b.line_name
                          ORDER BY b.line_name)
        LOOP
            v_exists := 'Y';
            v_rep.line_name := k.line_name;
            v_rep.prem_amt := k.gross;
            v_rep.balance := k.facul;
            v_rep.difference := k.treaty;
            v_rep.net := k.net;
            PIPE ROW(v_rep);
        END LOOP;
        
        IF v_exists = 'N' THEN
            PIPE ROW(v_rep);
        END IF;
    END;
    
    FUNCTION get_claim_report(
        p_user_id       giac_batch_check_os_loss_ext.user_id%TYPE
    )
      RETURN main_report_tab PIPELINED
    IS
        v_rep           main_report_type;
        v_exists        VARCHAR2(1) := 'N';
    BEGIN
        v_rep.cf_company := giacp.v('COMPANY_NAME');
        v_rep.cf_address := giacp.v('COMPANY_ADDRESS');
        
        BEGIN
            SELECT report_title
              INTO v_rep.cf_title
              FROM giis_reports
             WHERE report_id = 'BATCHCHECK';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rep.cf_title := 'BATCH CHECKING SUMMARY';              
        END;

        BEGIN
            SELECT 'For the month of '||TO_CHAR(to_date,'fmMONTH')
              INTO v_rep.cf_subtitle
              FROM giac_batch_check_os_loss_ext
             WHERE ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rep.cf_subtitle := 'No Data';   
        END;
        
        FOR i IN(SELECT *
                   FROM TABLE(giacr354_pkg.get_outstanding(p_user_id)))
        LOOP
            v_exists := 'Y';
            v_rep.line_name := i.line_name;
            v_rep.gl_acct_sname := i.gl_acct_sname;
            v_rep.prem_amt := i.prem_amt;
            v_rep.balance := i.balance;
            v_rep.difference := i.difference;
            v_rep.col_header := 'Outstanding Losses';
            v_rep.type := 1;
            PIPE ROW(v_rep);
        END LOOP;
        
        FOR i IN(SELECT *
                   FROM TABLE(giacr354_pkg.get_losses(p_user_id)))
        LOOP
            v_exists := 'Y';
            v_rep.line_name := i.line_name;
            v_rep.gl_acct_sname := i.gl_acct_sname;
            v_rep.prem_amt := i.prem_amt;
            v_rep.balance := i.balance;
            v_rep.difference := i.difference;
            v_rep.col_header := 'Losses Paid';
            v_rep.type := 2;
            PIPE ROW(v_rep);
        END LOOP;
        
        IF v_exists = 'N' THEN
            PIPE ROW(v_rep);
        END IF;
    END;
    
    FUNCTION get_outstanding(
        p_user_id       giac_batch_check_os_loss_ext.user_id%TYPE
    )
      RETURN main_report_tab PIPELINED
    IS
        v_rep           main_report_type;
        v_exists        VARCHAR2(1) := 'N';
    BEGIN
        v_rep.cf_company := giacp.v('COMPANY_NAME');
        v_rep.cf_address := giacp.v('COMPANY_ADDRESS');
        
        BEGIN
            SELECT report_title
              INTO v_rep.cf_title
              FROM giis_reports
             WHERE report_id = 'BATCHCHECK';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rep.cf_title := 'BATCH CHECKING SUMMARY';              
        END;

        BEGIN
            SELECT 'For the month of '||TO_CHAR(to_date,'fmMONTH')
              INTO v_rep.cf_subtitle
              FROM giac_batch_check_os_loss_ext
             WHERE ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rep.cf_subtitle := 'No Data';   
        END;
    
        FOR i IN(SELECT a.*, b.line_name
                   FROM giac_batch_check_os_loss_ext a,
                        giis_line b
                  WHERE a.user_id = p_user_id
                    AND a.line_cd = b.line_cd
                  ORDER BY a.base_amt, a.gl_acct_sname, a.line_cd)
        LOOP
            v_exists := 'Y';
            v_rep.line_name := i.line_name;
            v_rep.gl_acct_sname := i.gl_acct_sname;
            v_rep.prem_amt := i.brdrx_amt;
            v_rep.balance := i.balance;
            v_rep.difference := NVL(i.brdrx_amt, 0) - NVL(i.balance, 0);
            PIPE ROW(v_rep);
        END LOOP;
        
        IF v_exists = 'N' THEN
            PIPE ROW(v_rep);
        END IF;
    END;
    
    FUNCTION get_losses(
        p_user_id       giac_batch_check_loss_pd_ext.user_id%TYPE
    )
      RETURN main_report_tab PIPELINED
    IS
        v_rep           main_report_type;
        v_exists        VARCHAR2(1) := 'N'; 
    BEGIN
        v_rep.cf_company := giacp.v('COMPANY_NAME');
        v_rep.cf_address := giacp.v('COMPANY_ADDRESS');
        
        BEGIN
            SELECT report_title
              INTO v_rep.cf_title
              FROM giis_reports
             WHERE report_id = 'BATCHCHECK';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rep.cf_title := 'BATCH CHECKING SUMMARY';              
        END;

        BEGIN
            SELECT 'For the month of '||TO_CHAR(to_date,'fmMONTH')
              INTO v_rep.cf_subtitle
              FROM giac_batch_check_loss_pd_ext
             WHERE ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rep.cf_subtitle := 'No Data';   
        END;
    
        FOR i IN(SELECT a.*, b.line_name
                   FROM giac_batch_check_loss_pd_ext a,
                        giis_line b
                  WHERE a.user_id = p_user_id
                    AND a.line_cd = b.line_cd
                  ORDER BY a.base_amt, a.gl_acct_sname, a.line_cd)
        LOOP
            v_exists := 'Y';
            v_rep.line_name := i.line_name;
            v_rep.gl_acct_sname := i.gl_acct_sname;
            v_rep.prem_amt := i.brdrx_amt;
            v_rep.balance := i.balance;
            v_rep.difference := NVL(i.brdrx_amt, 0) - NVL(i.balance, 0);
            PIPE ROW(v_rep);
        END LOOP;
        
        IF v_exists = 'N' THEN
            PIPE ROW(v_rep);
        END IF;
    END;
       
   --Deo [02.02.2017]: add start (SR-5923)
   FUNCTION escape_string (p_string VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN '"' || REPLACE (p_string, '"', '""') || '"';
   END;

   FUNCTION production_csv (p_user_id VARCHAR2)
      RETURN str_csv_rec_tab PIPELINED
   IS
      v           str_csv_rec_type;
      v_col_hdr   VARCHAR2 (1000);
      v_col_val   VARCHAR2 (32767);
   BEGIN
      v_col_hdr :=
            'Transaction Class,Line Name,GL Account Sname,Report Amount,'
         || 'Accounting Entries,Difference';
      v.rec := v_col_hdr;
      PIPE ROW (v);

      FOR gp IN (SELECT   b.line_name, a.gl_acct_sname,
                          TO_CHAR (NVL (a.prem_amt, 0),
                                   'fm999,999,999,990.00'
                                  ) prem_amt,
                          TO_CHAR (NVL (a.balance, 0),
                                   'fm999,999,999,990.00'
                                  ) balance,
                          TO_CHAR (NVL (a.prem_amt, 0) - NVL (a.balance, 0),
                                   'fm999,999,999,990.00'
                                  ) difference
                     FROM giac_batch_check_gross_ext a, giis_line b
                    WHERE a.line_cd = b.line_cd AND a.user_id = p_user_id
                 ORDER BY a.base_amt, a.gl_acct_sname, a.line_cd)
      LOOP
         v_col_val :=
               'Gross Premiums'
            || ','
            || escape_string (gp.line_name)
            || ','
            || escape_string (gp.gl_acct_sname)
            || ','
            || escape_string (gp.prem_amt)
            || ','
            || escape_string (gp.balance)
            || ','
            || escape_string (gp.difference);
         v.rec := v_col_val;
         PIPE ROW (v);
      END LOOP;

      FOR fac IN (SELECT   b.line_name, a.gl_acct_sname,
                           TO_CHAR (NVL (a.prem_amt, 0),
                                    'fm999,999,999,990.00'
                                   ) prem_amt,
                           TO_CHAR (NVL (a.balance, 0),
                                    'fm999,999,999,990.00'
                                   ) balance,
                           TO_CHAR (NVL (a.prem_amt, 0) - NVL (a.balance, 0),
                                    'fm999,999,999,990.00'
                                   ) difference
                      FROM giac_batch_check_facul_ext a, giis_line b
                     WHERE a.line_cd = b.line_cd AND a.user_id = p_user_id
                  ORDER BY a.base_amt, a.gl_acct_sname, a.line_cd)
      LOOP
         v_col_val :=
               'Premiums Ceded to Facul'
            || ','
            || escape_string (fac.line_name)
            || ','
            || escape_string (fac.gl_acct_sname)
            || ','
            || escape_string (fac.prem_amt)
            || ','
            || escape_string (fac.balance)
            || ','
            || escape_string (fac.difference);
         v.rec := v_col_val;
         PIPE ROW (v);
      END LOOP;

      FOR trty IN (SELECT   b.line_name, a.gl_acct_sname,
                            TO_CHAR (NVL (a.prem_amt, 0),
                                     'fm999,999,999,990.00'
                                    ) prem_amt,
                            TO_CHAR (NVL (a.balance, 0),
                                     'fm999,999,999,990.00'
                                    ) balance,
                            TO_CHAR (NVL (a.prem_amt, 0) - NVL (a.balance, 0),
                                     'fm999,999,999,990.00'
                                    ) difference
                       FROM giac_batch_check_treaty_ext a, giis_line b
                      WHERE a.line_cd = b.line_cd AND a.user_id = p_user_id
                   ORDER BY a.base_amt, a.gl_acct_sname, a.line_cd)
      LOOP
         v_col_val :=
               'Premiums Ceded to Treaty'
            || ','
            || escape_string (trty.line_name)
            || ','
            || escape_string (trty.gl_acct_sname)
            || ','
            || escape_string (trty.prem_amt)
            || ','
            || escape_string (trty.balance)
            || ','
            || escape_string (trty.difference);
         v.rec := v_col_val;
         PIPE ROW (v);
      END LOOP;
   END production_csv;

   FUNCTION claims_csv (p_user_id VARCHAR2)
      RETURN str_csv_rec_tab PIPELINED
   IS
      v           str_csv_rec_type;
      v_col_hdr   VARCHAR2 (1000);
      v_col_val   VARCHAR2 (32767);
   BEGIN
      v_col_hdr :=
            'Transaction Class,Line Name,GL Account Sname,Report Amount,'
         || 'Accounting Entries,Difference';
      v.rec := v_col_hdr;
      PIPE ROW (v);

      FOR os IN (SELECT   b.line_name, a.gl_acct_sname,
                          TO_CHAR (NVL (a.brdrx_amt, 0),
                                   'fm999,999,999,990.00'
                                  ) brdrx_amt,
                          TO_CHAR (NVL (a.balance, 0),
                                   'fm999,999,999,990.00'
                                  ) balance,
                          TO_CHAR (NVL (a.brdrx_amt, 0) - NVL (a.balance, 0),
                                   'fm999,999,999,990.00'
                                  ) difference
                     FROM giac_batch_check_os_loss_ext a, giis_line b
                    WHERE a.line_cd = b.line_cd AND a.user_id = p_user_id
                 ORDER BY a.base_amt, a.gl_acct_sname, a.line_cd)
      LOOP
         v_col_val :=
               'Outstanding Losses'
            || ','
            || escape_string (os.line_name)
            || ','
            || escape_string (os.gl_acct_sname)
            || ','
            || escape_string (os.brdrx_amt)
            || ','
            || escape_string (os.balance)
            || ','
            || escape_string (os.difference);
         v.rec := v_col_val;
         PIPE ROW (v);
      END LOOP;

      FOR lp IN (SELECT   b.line_name, a.gl_acct_sname,
                          TO_CHAR (NVL (a.brdrx_amt, 0),
                                   'fm999,999,999,990.00'
                                  ) brdrx_amt,
                          TO_CHAR (NVL (a.balance, 0),
                                   'fm999,999,999,990.00'
                                  ) balance,
                          TO_CHAR (NVL (a.brdrx_amt, 0) - NVL (a.balance, 0),
                                   'fm999,999,999,990.00'
                                  ) difference
                     FROM giac_batch_check_loss_pd_ext a, giis_line b
                    WHERE a.line_cd = b.line_cd AND a.user_id = p_user_id
                 ORDER BY a.base_amt, a.gl_acct_sname, a.line_cd)
      LOOP
         v_col_val :=
               'Losses Paid'
            || ','
            || escape_string (lp.line_name)
            || ','
            || escape_string (lp.gl_acct_sname)
            || ','
            || escape_string (lp.brdrx_amt)
            || ','
            || escape_string (lp.balance)
            || ','
            || escape_string (lp.difference);
         v.rec := v_col_val;
         PIPE ROW (v);
      END LOOP;
   END claims_csv;
   --Deo [02.02.2017]: add ends (SR-5923)
END GIACR354_PKG;
/


