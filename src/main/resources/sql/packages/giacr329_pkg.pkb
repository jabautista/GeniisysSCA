CREATE OR REPLACE PACKAGE BODY CPI.giacr329_pkg
AS
   FUNCTION get_giacr329_details (
      p_as_of_date   giac_aging_prem_rep_ext.as_of_date%TYPE, 
      p_branch_cd    giac_aging_prem_rep_ext.branch_cd%TYPE, 
      p_intm_type    giac_aging_prem_rep_ext.intm_type%TYPE,
      p_intm_no      giac_aging_prem_rep_ext.intm_no%TYPE,
      p_user_id      giac_aging_prem_rep_ext.user_id%TYPE
   )
      RETURN giacr329_tab PIPELINED
   IS
      v_giacr329    giacr329_type;
      v_query       VARCHAR2 (5000);
      v_ctr_limit   NUMBER   (1);
      v_total_cols  NUMBER   (2);
      v_orig_iss_cd VARCHAR2 (2); 

      TYPE v_type IS RECORD (
         iss_cd             VARCHAR2 (20),
         iss_name           giis_issource.iss_name%TYPE,
         agent_code         VARCHAR2 (100),
         intm_name          giac_aging_prem_rep_ext.intm_name%TYPE,
         col_header1        giac_soa_title.col_title%TYPE,
         sum_col_header1    giac_aging_prem_rep_ext.balance_amt_due%TYPE,
         col_header2        giac_soa_title.col_title%TYPE,
         sum_col_header2    giac_aging_prem_rep_ext.balance_amt_due%TYPE,
         col_header3        giac_soa_title.col_title%TYPE,
         sum_col_header3    giac_aging_prem_rep_ext.balance_amt_due%TYPE,
         col_header4        giac_soa_title.col_title%TYPE,
         sum_col_header4    giac_aging_prem_rep_ext.balance_amt_due%TYPE,
         col_header5        giac_soa_title.col_title%TYPE,
         sum_col_header5    giac_aging_prem_rep_ext.balance_amt_due%TYPE,
         col_header6        giac_soa_title.col_title%TYPE,
         sum_col_header6    giac_aging_prem_rep_ext.balance_amt_due%TYPE,
         col_header7        giac_soa_title.col_title%TYPE,
         sum_col_header7    giac_aging_prem_rep_ext.balance_amt_due%TYPE,
         col_header8        giac_soa_title.col_title%TYPE,
         sum_col_header8    giac_aging_prem_rep_ext.balance_amt_due%TYPE,
         col_header9        giac_soa_title.col_title%TYPE,
         sum_col_header9    giac_aging_prem_rep_ext.balance_amt_due%TYPE,
         col_header10       giac_soa_title.col_title%TYPE,
         sum_col_header10   giac_aging_prem_rep_ext.balance_amt_due%TYPE,
         col_header11       giac_soa_title.col_title%TYPE,
         sum_col_header11   giac_aging_prem_rep_ext.balance_amt_due%TYPE,
         col_header12       giac_soa_title.col_title%TYPE,
         sum_col_header12   giac_aging_prem_rep_ext.balance_amt_due%TYPE,
         col_header13       giac_soa_title.col_title%TYPE,
         sum_col_header13   giac_aging_prem_rep_ext.balance_amt_due%TYPE,
         col_header14       giac_soa_title.col_title%TYPE,
         sum_col_header14   giac_aging_prem_rep_ext.balance_amt_due%TYPE,
         col_header15       giac_soa_title.col_title%TYPE,
         sum_col_header15   giac_aging_prem_rep_ext.balance_amt_due%TYPE,
         col_header16       giac_soa_title.col_title%TYPE,
         sum_col_header16   giac_aging_prem_rep_ext.balance_amt_due%TYPE
      );

      TYPE v_tab IS TABLE OF v_type;

      v_list_bulk   v_tab;
   BEGIN
      
      v_query := 'SELECT DISTINCT a.iss_cd, c.iss_name , a.intm_type || ''-'' || TO_CHAR (a.intm_no) agent_code , UPPER (a.intm_name) intm_name ';
      v_ctr_limit := 0;
      v_total_cols := 0;
      
      SELECT giacr329_pkg.get_cf_company_nameformula
        INTO v_giacr329.company_name
        FROM DUAL;

      SELECT giacr329_pkg.get_cf_company_addformula
        INTO v_giacr329.company_address
        FROM DUAL;

      SELECT giacr329_pkg.get_cf_datesformula (p_user_id, p_as_of_date)
        INTO v_giacr329.date_title
        FROM DUAL;
      
      FOR col IN (SELECT col_no, col_title
                    FROM giac_soa_title
                   WHERE rep_cd = 1
                  UNION ALL
                  SELECT MAX (col_no) + 1 col_no, 'Total' AS col_title
                    FROM giac_soa_title
                   WHERE rep_cd = 1
                  UNION ALL
                  SELECT MAX (col_no) + 2 col_no, 'Afterdate Collection' AS col_title
                    FROM giac_soa_title
                   WHERE rep_cd = 1
                  UNION ALL
                 SELECT  MAX (col_no) + 3 col_no, 'Balance Due' AS col_title
                   FROM giac_soa_title
                  WHERE rep_cd = 1
                  ORDER BY col_no)
      LOOP
        v_ctr_limit := v_ctr_limit + 1;
        v_total_cols := v_total_cols + 1;
        
        v_query := v_query ||', MAX(DECODE('||col.col_no||', '||col.col_no||', '||''''||col.col_title||''''||')) col_header'||col.col_no;
        v_query := v_query ||', NVL(SUM(DECODE(a.column_no, '||col.col_no||',a.balance_amt_due'||')), 0) sum_col_header'||col.col_no;
        
        IF v_ctr_limit = 8 THEN
            v_ctr_limit := 0;
        END IF;
      END LOOP;
      
      IF v_ctr_limit > 0 THEN
        FOR i IN 1..8-v_ctr_limit
        LOOP
            v_total_cols := v_total_cols + 1;
            v_query := v_query ||', MAX(DECODE(NULL, NULL, NULL)) col_header'||v_total_cols;
            v_query := v_query ||', SUM(DECODE(NULL, NULL, NULL)) sum_col_header' ||v_total_cols; 
        END LOOP;
      END IF; 
      
      v_query := v_query ||' FROM giac_aging_prem_rep_ext a,
                                  giis_intermediary b,
                                  giis_issource c,
                                  giac_soa_title d
                            WHERE a.intm_no = b.intm_no
                              AND a.user_id = UPPER ('''||p_user_id||''''||') 
                              AND a.iss_cd = c.iss_cd
                              AND a.column_no = d.col_no(+) ';
                              IF p_intm_no IS NOT NULL
                                THEN 
                                    v_query := v_query || ' AND a.intm_no = '''||p_intm_no||''' ';
                              END IF;
                              IF p_branch_cd IS NOT NULL
                                THEN 
                                    v_query := v_query || ' AND a.iss_cd = '''||p_branch_cd||''' ';
                              END IF;
                              IF p_intm_type IS NOT NULL
                                THEN 
                                    v_query := v_query || ' AND a.intm_type = '''||p_intm_type||''' ';
                              END IF;                              
                              /*AND a.as_of_date = NVL ('''||p_as_of_date||''', a.as_of_date) 
                              AND check_user_per_iss_cd_acctg2(a.line_cd, a.iss_cd, ''GIACS329'','||''''||p_user_id||''''||') = 1 replaced by code below by pjsantos 11/21/2016, GENQA 5187*/
        v_query := v_query ||' AND EXISTS (SELECT ''X''
                                 FROM TABLE (security_access.get_branch_line (''AC'', ''GIACS329'', '''||p_user_id||'''))
                                WHERE branch_cd = a.iss_cd )  
                         GROUP BY a.iss_cd, c.iss_name, a.intm_type '||'||''-''||'||' TO_CHAR(a.intm_no), a.intm_name
                           HAVING SUM (balance_amt_due) <> 0
                            ORDER BY a.iss_cd';
                          
      EXECUTE IMMEDIATE v_query
      BULK COLLECT INTO v_list_bulk;

      IF v_list_bulk.LAST > 0
      THEN
         FOR i IN v_list_bulk.FIRST .. v_list_bulk.LAST
         LOOP
            v_orig_iss_cd := v_list_bulk (i).iss_cd;
            v_giacr329.iss_cd := v_list_bulk (i).iss_cd;
            v_giacr329.iss_name := v_list_bulk (i).iss_name;
            v_giacr329.agent_code := v_list_bulk (i).agent_code;
            v_giacr329.intm_name := v_list_bulk (i).intm_name;
            v_giacr329.afterdate_coll := get_afterdate_coll(p_as_of_date, v_orig_iss_cd, v_list_bulk (i).agent_code, p_user_id);
            v_giacr329.col_header1 := v_list_bulk (i).col_header1;
            v_giacr329.sum_col_header1 := v_list_bulk (i).sum_col_header1;
            v_giacr329.col_header2 := v_list_bulk (i).col_header2;
            v_giacr329.sum_col_header2 := v_list_bulk (i).sum_col_header2;
            v_giacr329.col_header3 := v_list_bulk (i).col_header3;
            v_giacr329.sum_col_header3 := v_list_bulk (i).sum_col_header3;
            v_giacr329.col_header4 := v_list_bulk (i).col_header4;
            v_giacr329.sum_col_header4 := v_list_bulk (i).sum_col_header4;
            v_giacr329.col_header5 := v_list_bulk (i).col_header5;
            v_giacr329.sum_col_header5 := v_list_bulk (i).sum_col_header5;
            v_giacr329.col_header6 := v_list_bulk (i).col_header6;
            v_giacr329.sum_col_header6 := v_list_bulk (i).sum_col_header6;
            v_giacr329.col_header7 := v_list_bulk (i).col_header7;
            v_giacr329.sum_col_header7 := v_list_bulk (i).sum_col_header7;
            v_giacr329.col_header8  := v_list_bulk (i).col_header8;
            v_giacr329.sum_col_header8 := v_list_bulk (i).sum_col_header8;
            PIPE ROW (v_giacr329);
            v_giacr329.iss_cd := v_list_bulk (i).iss_cd||'_1';
            v_giacr329.col_header1 := v_list_bulk (i).col_header9;
            v_giacr329.sum_col_header1 := v_list_bulk (i).sum_col_header9;
            v_giacr329.col_header2 := v_list_bulk (i).col_header10;
            v_giacr329.sum_col_header2 := v_list_bulk (i).sum_col_header10;
            v_giacr329.col_header3 := v_list_bulk (i).col_header11;
            v_giacr329.sum_col_header3 := v_list_bulk (i).sum_col_header11;
            v_giacr329.col_header4 := v_list_bulk (i).col_header12;
            v_giacr329.sum_col_header4 := v_list_bulk (i).sum_col_header12;
            v_giacr329.col_header5 := v_list_bulk (i).col_header13;
            v_giacr329.sum_col_header5 := v_list_bulk (i).sum_col_header13;
            v_giacr329.col_header6 := v_list_bulk (i).col_header14;
            IF v_list_bulk (i).col_header14 = 'Total' THEN
                v_giacr329.sum_col_header6 := v_list_bulk (i).sum_col_header1 + 
                                              v_list_bulk (i).sum_col_header2 +
                                              v_list_bulk (i).sum_col_header3 +
                                              v_list_bulk (i).sum_col_header4 +
                                              v_list_bulk (i).sum_col_header5 +
                                              v_list_bulk (i).sum_col_header6 +
                                              v_list_bulk (i).sum_col_header7 +
                                              v_list_bulk (i).sum_col_header8 +
                                              v_list_bulk (i).sum_col_header9 +
                                              v_list_bulk (i).sum_col_header10+
                                              v_list_bulk (i).sum_col_header11+
                                              v_list_bulk (i).sum_col_header12+
                                              v_list_bulk (i).sum_col_header13;
            ELSE
                v_giacr329.sum_col_header6 := v_list_bulk (i).sum_col_header14;
            END IF;
            v_giacr329.col_header7 := v_list_bulk (i).col_header15;
            IF v_list_bulk (i).col_header15 = 'Afterdate Collection' THEN
               v_giacr329.sum_col_header7 := get_afterdate_coll(p_as_of_date, 
                                                                v_orig_iss_cd, 
                                                                v_list_bulk (i).agent_code, 
                                                                p_user_id);
            ELSE
               v_giacr329.sum_col_header7 := v_list_bulk (i).sum_col_header15;     
            END IF;
            v_giacr329.col_header8 := v_list_bulk (i).col_header16;
            IF v_list_bulk (i).col_header16 = 'Balance Due' THEN
                v_giacr329.sum_col_header8 := NVL(v_giacr329.sum_col_header6 - (get_afterdate_coll(p_as_of_date, 
                                                                                                   v_orig_iss_cd, 
                                                                                                   v_list_bulk (i).agent_code, 
                                                                                                   p_user_id)), 0);
            ELSE
                v_giacr329.sum_col_header8 := v_list_bulk (i).sum_col_header16;
            END IF;
            PIPE ROW (v_giacr329);
         END LOOP;
      END IF;

      RETURN;
   END;
   
   FUNCTION get_cf_company_nameformula
      RETURN VARCHAR2
   IS
      v_company_name   giis_parameters.param_value_v%TYPE;
   BEGIN
      v_company_name := '(No company name available)';

      FOR rec IN (SELECT giacp.v ('COMPANY_NAME') v_company_name
                    FROM DUAL)
      LOOP
         v_company_name := rec.v_company_name;
      END LOOP;

      RETURN (v_company_name);
   END get_cf_company_nameformula;

   FUNCTION get_cf_company_addformula
      RETURN VARCHAR2
   IS
      v_company_address   giis_parameters.param_value_v%TYPE;
   BEGIN
      FOR rec IN (SELECT UPPER (giacp.v ('COMPANY_ADDRESS'))
                                                           v_company_address
                    FROM DUAL)
      LOOP
         v_company_address := rec.v_company_address;
      END LOOP;

      RETURN (v_company_address);
   END get_cf_company_addformula;

   FUNCTION get_cf_datesformula (
      p_user_id      giac_aging_prem_rep_ext.user_id%TYPE,
      p_as_of_date   giac_aging_prem_rep_ext.as_of_date%TYPE
   )
      RETURN VARCHAR2
   IS
      v_date   DATE;
   BEGIN
      FOR c IN (SELECT as_of_date
                  FROM giac_aging_prem_rep_ext
                 WHERE user_id = p_user_id AND ROWNUM = 1)
      LOOP
         v_date := c.as_of_date;
         EXIT;
      END LOOP;

      IF v_date IS NULL
      THEN
         v_date := SYSDATE;
      END IF;

      RETURN (   'As of '
              || TO_CHAR (p_as_of_date, 'fmMonth DD, YYYY')
              || ', Cut-off '
              || TO_CHAR (v_date, 'fmMonth DD, YYYY')
             );
   END get_cf_datesformula;
   
     
   FUNCTION get_afterdate_coll (
      p_as_of_date   giac_aging_prem_rep_ext.as_of_date%TYPE,
      p_branch_cd    giac_aging_prem_rep_ext.branch_cd%TYPE,
      p_agent_code   VARCHAR2,
      p_user_id      giac_aging_prem_rep_ext.user_id%TYPE
   )
      RETURN NUMBER
   IS
      v_afterdate_coll giac_aging_prem_rep_ext.afterdate_coll%TYPE := 0;
   BEGIN
      FOR i IN (SELECT DISTINCT c.iss_name, a.iss_cd, UPPER (a.intm_name) intm_name,
                          a.intm_no,
                          /*a.intm_type || '-'
                          || TO_CHAR (a.intm_no) agent_code,*/     --removed by pjsantos 11/21/2016, GENQA 5187                     
                          SUM (balance_amt_due) balance_amt_due,
                          SUM (afterdate_coll) afterdate_collection,
                          a.intm_type
                     FROM giac_aging_prem_rep_ext a,
                          giis_intermediary b,
                          giis_issource c
                    WHERE a.intm_no = b.intm_no
                      AND a.user_id = UPPER (p_user_id)
                      AND a.iss_cd = c.iss_cd
                      --AND a.as_of_date = NVL (p_as_of_date, a.as_of_date)  comment out by pjsantos 11/21/2016, GENQA 5187
                      AND a.iss_cd = p_branch_cd
                      AND a.intm_type||'-'||a.intm_no = p_agent_code
                 GROUP BY a.iss_cd,
                          a.intm_name,
                          a.intm_no,
                          a.intm_type,
                          --a.iss_cd,removed by pjsantos 11/21/2016, GENQA 5187
                          c.iss_name
                   HAVING SUM (balance_amt_due) <> 0
                 ORDER BY a.iss_cd)
      LOOP
        v_afterdate_coll := v_afterdate_coll + i.afterdate_collection;
      END LOOP;
      
      RETURN v_afterdate_coll;
   END;
   
   FUNCTION get_giacr329_main(
      p_user_id      giac_aging_prem_rep_ext.user_id%TYPE,
      p_as_of_date   giac_aging_prem_rep_ext.as_of_date%TYPE
   )
     RETURN main_tab PIPELINED
   IS
      v_row          main_type;
   BEGIN
      SELECT giacr329_pkg.get_cf_company_nameformula, giacr329_pkg.get_cf_company_addformula, giacr329_pkg.get_cf_datesformula (p_user_id, p_as_of_date)
        INTO v_row.company_name, v_row.company_address, v_row.date_title
        FROM DUAL;
        
      PIPE ROW(v_row);
   END;
   
   FUNCTION get_giacr329_header
     RETURN header_tab PIPELINED
   IS
      v_row          header_type;
      v_column       column_tab;
      v_index        NUMBER := 0;
      v_dummy        NUMBER := 1;
   BEGIN
      v_column := column_tab();
      FOR i IN(SELECT col_no, col_title
                 FROM giac_soa_title
                WHERE rep_cd = 1
                UNION ALL
               SELECT MAX (col_no) + 1 col_no, 'Total' AS col_title
                 FROM giac_soa_title
                WHERE rep_cd = 1
                UNION ALL
               SELECT MAX (col_no) + 2 col_no, 'Afterdate Collection' AS col_title
                 FROM giac_soa_title
                WHERE rep_cd = 1
                UNION ALL
               SELECT  MAX (col_no) + 3 col_no, 'Balance Due' AS col_title
                 FROM giac_soa_title
                WHERE rep_cd = 1
                ORDER BY col_no)
      LOOP
         v_index := v_index + 1;
         v_column.EXTEND;
         v_column(v_index).col_no := i.col_no;
         v_column(v_index).col_title := i.col_title;
      END LOOP;
      
      v_index := 1;
      LOOP
         v_row := NULL;
         v_row.dummy := v_dummy;
      
         IF v_column.EXISTS(v_index) THEN
            v_row.col_no1 := v_column(v_index).col_no;
            v_row.col_title1 := v_column(v_index).col_title;
            v_index := v_index + 1;
         END IF;
      
         IF v_column.EXISTS(v_index) THEN
            v_row.col_no2 := v_column(v_index).col_no;
            v_row.col_title2 := v_column(v_index).col_title;
            v_index := v_index + 1;
         END IF;
         
         IF v_column.EXISTS(v_index) THEN
            v_row.col_no3 := v_column(v_index).col_no;
            v_row.col_title3 := v_column(v_index).col_title;
            v_index := v_index + 1;
         END IF;
         
         IF v_column.EXISTS(v_index) THEN
            v_row.col_no4 := v_column(v_index).col_no;
            v_row.col_title4 := v_column(v_index).col_title;
            v_index := v_index + 1;
         END IF;
         
         IF v_column.EXISTS(v_index) THEN
            v_row.col_no5 := v_column(v_index).col_no;
            v_row.col_title5 := v_column(v_index).col_title;
            v_index := v_index + 1;
         END IF;
         
         IF v_column.EXISTS(v_index) THEN
            v_row.col_no6 := v_column(v_index).col_no;
            v_row.col_title6 := v_column(v_index).col_title;
            v_index := v_index + 1;
         END IF;
         
         IF v_column.EXISTS(v_index) THEN
            v_row.col_no7 := v_column(v_index).col_no;
            v_row.col_title7 := v_column(v_index).col_title;
            v_index := v_index + 1;
         END IF;
         
         IF v_column.EXISTS(v_index) THEN
            v_row.col_no8 := v_column(v_index).col_no;
            v_row.col_title8 := v_column(v_index).col_title;
            v_index := v_index + 1;
         END IF;
         
         v_dummy := v_dummy + 1;
         PIPE ROW(v_row);
      
         EXIT WHEN v_index > v_column.COUNT;
      END LOOP;
   END;
   
   FUNCTION get_giacr329_detail(
      p_dummy        NUMBER,
      p_as_of_date   giac_aging_prem_rep_ext.as_of_date%TYPE,
      p_branch_cd    giac_aging_prem_rep_ext.branch_cd%TYPE,
      p_intm_type    giac_aging_prem_rep_ext.intm_type%TYPE,
      p_intm_no      giac_aging_prem_rep_ext.intm_no%TYPE,
      p_user_id      giac_aging_prem_rep_ext.user_id%TYPE
   )
     RETURN rec_tab PIPELINED
   IS
      v_row          rec_type;
      v_col_no       giac_soa_title.col_no%TYPE;
      v_index        NUMBER := 1;
      TYPE t_tab IS TABLE OF rec_type INDEX BY PLS_INTEGER;
      v_tab          t_tab;
   BEGIN
      FOR c IN(SELECT col_no1, col_no2, col_no3, col_no4, col_no5, col_no6, col_no7, col_no8,
                      col_title1, col_title2, col_title3, col_title4, col_title5, col_title6, col_title7, col_title8
                 FROM TABLE(GIACR329_PKG.get_giacr329_header) a 
                WHERE dummy = NVL(p_dummy, a.dummy)) --Dren 05.20.2016 SR-5359
      LOOP
         FOR m IN(SELECT DISTINCT a.iss_cd, a.intm_type, a.intm_no, a.intm_name,
                         GIACR329_PKG.get_sum_balance(c.col_no1, c.col_title1, p_user_id, p_branch_cd, p_as_of_date, a.intm_no) sum_balance1,
                         GIACR329_PKG.get_sum_balance(c.col_no2, c.col_title2, p_user_id, p_branch_cd, p_as_of_date, a.intm_no) sum_balance2,
                         GIACR329_PKG.get_sum_balance(c.col_no3, c.col_title3, p_user_id, p_branch_cd, p_as_of_date, a.intm_no) sum_balance3,
                         GIACR329_PKG.get_sum_balance(c.col_no4, c.col_title4, p_user_id, p_branch_cd, p_as_of_date, a.intm_no) sum_balance4,
                         GIACR329_PKG.get_sum_balance(c.col_no5, c.col_title5, p_user_id, p_branch_cd, p_as_of_date, a.intm_no) sum_balance5,
                         GIACR329_PKG.get_sum_balance(c.col_no6, c.col_title6, p_user_id, p_branch_cd, p_as_of_date, a.intm_no) sum_balance6,
                         GIACR329_PKG.get_sum_balance(c.col_no7, c.col_title7, p_user_id, p_branch_cd, p_as_of_date, a.intm_no) sum_balance7,
                         GIACR329_PKG.get_sum_balance(c.col_no8, c.col_title8, p_user_id, p_branch_cd, p_as_of_date, a.intm_no) sum_balance8,                        
                         GIACR329_PKG.get_sum_balance(NULL, 'Total', p_user_id, p_branch_cd, p_as_of_date, a.intm_no) total
                    FROM giac_aging_prem_rep_ext a,
                         giis_intermediary b,
                         giac_soa_title d
                   WHERE a.intm_no = b.intm_no
                     AND a.user_id = UPPER(p_user_id)
                     AND a.column_no = d.col_no(+)
                     AND d.rep_cd = 1
                     AND a.intm_no = NVL(p_intm_no, a.intm_no)
                     AND a.iss_cd LIKE NVL(p_branch_cd, '%'/*a.iss_cd*/) --modified by pjsantos 11/21/2016, GENQA 5187
                     AND a.intm_type LIKE NVL(p_intm_type, '%' /*a.intm_type*/)--modified by pjsantos 11/21/2016, GENQA 5187
                     --AND a.as_of_date = NVL(p_as_of_date, a.as_of_date)  comment out by pjsantos 11/21/2016, GENQA 5187
                   GROUP BY a.iss_cd, a.intm_type, a.intm_no, a.intm_name, a.column_no)
                   --ORDER BY a.intm_name) --Dren 05.20.2016 SR-5359
         LOOP
            v_row.iss_cd := m.iss_cd;
            v_row.iss_name := get_iss_name(m.iss_cd); --Dren 05.20.2016 SR-5359
            v_row.intm_type := m.intm_type; --Dren 05.20.2016 SR-5359
            v_row.intm_no := m.intm_no; --Dren 05.20.2016 SR-5359
            v_row.agent_code := m.intm_type || '-' || m.intm_no;
            v_row.intm_name := m.intm_name;
            v_row.sum_balance1 := NVL(m.sum_balance1, 0);
            v_row.sum_balance2 := NVL(m.sum_balance2, 0);
            v_row.sum_balance3 := NVL(m.sum_balance3, 0);
            v_row.sum_balance4 := NVL(m.sum_balance4, 0);
            v_row.sum_balance5 := NVL(m.sum_balance5, 0);
            v_row.sum_balance6 := NVL(m.sum_balance6, 0);
            v_row.sum_balance7 := NVL(m.sum_balance7, 0);
            v_row.sum_balance8 := NVL(m.sum_balance8, 0);
            
            v_row.col_title1 := c.col_title1;
            v_row.col_title2 := c.col_title2;
            v_row.col_title3 := c.col_title3;
            v_row.col_title4 := c.col_title4;
            v_row.col_title5 := c.col_title5;
            v_row.col_title6 := c.col_title6;
            v_row.col_title7 := c.col_title7;
            v_row.col_title8 := c.col_title8;
            
            IF m.total != 0 THEN
               PIPE ROW(v_row);
            END IF;
         END LOOP;
      END LOOP;
   END;
   
   FUNCTION get_sum_balance(
      p_col_no       giac_soa_title.col_no%TYPE,
      p_col_title    giac_soa_title.col_title%TYPE,
      p_user_id      giac_aging_prem_rep_ext.user_id%TYPE,
      p_branch_cd    giac_aging_prem_rep_ext.branch_cd%TYPE,
      p_as_of_date   giac_aging_prem_rep_ext.as_of_date%TYPE,
      p_intm_no      giac_aging_prem_rep_ext.intm_no%TYPE 
   )
     RETURN NUMBER
   IS
      v_sum_bal      giac_aging_prem_rep_ext.balance_amt_due%TYPE;
   BEGIN
    IF p_col_title IS NOT NULL THEN
      IF p_col_title = 'Total' OR p_col_title = 'Afterdate Collection' OR p_col_title = 'Balance Due' THEN 
         SELECT DECODE(p_col_title, 'Afterdate Collection', SUM(NVL(afterdate_coll, 0)), 'Total', SUM(NVL(balance_amt_due, 0)),
                'Balance Due', SUM(NVL(balance_amt_due, 0)) - SUM(NVL(afterdate_coll, 0)) , 0)   
           INTO v_sum_bal
           FROM giac_aging_prem_rep_ext
          WHERE user_id = p_user_id
            AND branch_cd LIKE NVL(p_branch_cd, '%'/*branch_cd*/)--modified by pjsantos 11/21/2016, GENQA 5187
            --AND as_of_date = NVL(p_as_of_date, as_of_date) comment out by pjsantos 11/21/2016, GENQA 5187
            AND intm_no = NVL(p_intm_no, intm_no);
      ELSE
         SELECT SUM(NVL(balance_amt_due, 0))
           INTO v_sum_bal
           FROM giac_aging_prem_rep_ext
          WHERE user_id = p_user_id
            AND branch_cd LIKE NVL(p_branch_cd, '%'/*branch_cd*/)--modified by pjsantos 11/21/2016, GENQA 5187
            --AND as_of_date = NVL(p_as_of_date, as_of_date) comment out by pjsantos 11/21/2016, GENQA 5187
            AND column_no = p_col_no
            AND intm_no = NVL(p_intm_no, intm_no);
      END IF;
    END IF;
      
      RETURN v_sum_bal;
   EXCEPTION
      WHEN OTHERS THEN
         RETURN 0;
   END;
   
   FUNCTION get_totals(
      p_dummy        NUMBER,
      p_user_id      giac_aging_prem_rep_ext.user_id%TYPE,
      p_branch_cd    giac_aging_prem_rep_ext.branch_cd%TYPE,
      p_as_of_date   giac_aging_prem_rep_ext.as_of_date%TYPE
   )
     RETURN rec_tab PIPELINED
   IS
      v_row          rec_type;
   BEGIN
      FOR c IN(SELECT col_no1, col_no2, col_no3, col_no4, col_no5, col_no6, col_no7, col_no8,
                      col_title1, col_title2, col_title3, col_title4, col_title5, col_title6, col_title7, col_title8
                 FROM TABLE(GIACR329_PKG.get_giacr329_header)
                WHERE dummy = p_dummy)
      LOOP
         FOR m IN(SELECT DISTINCT a.iss_cd, a.intm_type, a.intm_no, a.intm_name,
                         GIACR329_PKG.get_sum_balance(c.col_no1, c.col_title1, p_user_id, p_branch_cd, p_as_of_date, NULL) sum_balance1,
                         GIACR329_PKG.get_sum_balance(c.col_no2, c.col_title2, p_user_id, p_branch_cd, p_as_of_date, NULL) sum_balance2,
                         GIACR329_PKG.get_sum_balance(c.col_no3, c.col_title3, p_user_id, p_branch_cd, p_as_of_date, NULL) sum_balance3,
                         GIACR329_PKG.get_sum_balance(c.col_no4, c.col_title4, p_user_id, p_branch_cd, p_as_of_date, NULL) sum_balance4,
                         GIACR329_PKG.get_sum_balance(c.col_no5, c.col_title5, p_user_id, p_branch_cd, p_as_of_date, NULL) sum_balance5,
                         GIACR329_PKG.get_sum_balance(c.col_no6, c.col_title6, p_user_id, p_branch_cd, p_as_of_date, NULL) sum_balance6,
                         GIACR329_PKG.get_sum_balance(c.col_no7, c.col_title7, p_user_id, p_branch_cd, p_as_of_date, NULL) sum_balance7,
                         GIACR329_PKG.get_sum_balance(c.col_no8, c.col_title8, p_user_id, p_branch_cd, p_as_of_date, NULL) sum_balance8,
                         GIACR329_PKG.get_sum_balance(NULL, 'Total', p_user_id, p_branch_cd, p_as_of_date, NULL) total
                    FROM giac_aging_prem_rep_ext a,
                         giac_soa_title d
                   WHERE  a.user_id = UPPER(p_user_id)
                     AND a.column_no = d.col_no(+)
                     AND d.rep_cd = 1
                     AND a.iss_cd = NVL(p_branch_cd, '%' /*a.iss_cd*/)--modified by pjsantos 11/21/2016, GENQA 5187
                    -- AND a.as_of_date = NVL(p_as_of_date, a.as_of_date) comment out by pjsantos 11/21/2016, GENQA 5187
                   GROUP BY a.iss_cd, a.intm_type, a.intm_no, a.intm_name, a.column_no
                   ORDER BY a.intm_name)
         LOOP
            v_row.sum_balance1 := NVL(m.sum_balance1, 0);
            v_row.sum_balance2 := NVL(m.sum_balance2, 0);
            v_row.sum_balance3 := NVL(m.sum_balance3, 0);
            v_row.sum_balance4 := NVL(m.sum_balance4, 0);
            v_row.sum_balance5 := NVL(m.sum_balance5, 0);
            v_row.sum_balance6 := NVL(m.sum_balance6, 0);
            v_row.sum_balance7 := NVL(m.sum_balance7, 0);
            v_row.sum_balance8 := NVL(m.sum_balance8, 0);
            
            v_row.col_title1 := c.col_title1;
            v_row.col_title2 := c.col_title2;
            v_row.col_title3 := c.col_title3;
            v_row.col_title4 := c.col_title4;
            v_row.col_title5 := c.col_title5;
            v_row.col_title6 := c.col_title6;
            v_row.col_title7 := c.col_title7;
            v_row.col_title8 := c.col_title8;
            
            IF m.total != 0 THEN
               PIPE ROW(v_row);
            END IF;
         END LOOP;
      END LOOP;
   END;
   
END;
/


