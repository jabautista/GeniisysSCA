CREATE OR REPLACE PACKAGE BODY CPI.GIPIS170_PKG
AS
   /*
   **  Created by   :  Kenneth Mark Labrador
   **  Date Created : 08.22.2013
   **  Description  : For GIPIS170 - Batch Printing
   */
    FUNCTION populate_doc_list
       RETURN get_doc_list_tab PIPELINED
    IS
       v_doc   get_doc_list_type;
    BEGIN
    --      FOR i IN (SELECT DISTINCT doc_type, doc_type doc_type_1
    --                           FROM giis_reports
    --                          WHERE UPPER (doc_type) IN
    --                                   ('BINDER', 'BOND ENDORSEMENT',
    --                                    'BOND INVOICE', 'BOND POLICY',
    --                                    'BOND R.CERTIFICATE', 'COC(LTO)',
    --                                    'COC(NON-LTO)', 'COVER NOTE',
    --                                    'ENDORSEMENT', 'INVOICE',
    --                                    'MARKETING QUOTATION', 'POLICY',
    --                                    'RENEWAL CERTIFICATE', 'REVERSE BINDER',
    --                                    'RI INVOICE')
    --                       ORDER BY 1 ASC)
       FOR i IN (SELECT DISTINCT doc_type doc_type, doc_type doc_type1
                            FROM giis_reports
                           WHERE UPPER (doc_type) IN
                                    ('BINDER', 'BOND ENDORSEMENT',
                                     'BOND INVOICE', 'BOND POLICY',
                                     'BOND R.CERTIFICATE', 'COC(LTO)',
                                     'COC(NON-LTO)', 'COVER NOTE', 'INVOICE',
                                     'MARKETING QUOTATION',
                                     'RENEWAL CERTIFICATE', 'REVERSE BINDER',
                                     'RI INVOICE')
                 UNION ALL
                 SELECT 'POLICY' doc_type, 'POLICY' doc_type1
                   FROM DUAL
                 UNION ALL
                 SELECT 'ENDORSEMENT' doc_type, 'ENDORSEMENT' doc_type1
                   FROM DUAL)
       LOOP
          v_doc.doc_type := i.doc_type;
          v_doc.doc_type1 := i.doc_type1;
          PIPE ROW (v_doc);
       END LOOP;
    END populate_doc_list;

   FUNCTION get_gipis170_iss_lov (
      p_line_cd     giis_line.line_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN get_iss_lov_tab PIPELINED
   IS
      v_iss   get_iss_lov_type;
   BEGIN
      FOR i IN (SELECT iss_name, iss_cd
                  FROM giis_issource
                 WHERE iss_cd =
                          DECODE (check_user_per_iss_cd2 (p_line_cd,
                                                          iss_cd,
                                                          p_module_id,
                                                          p_user_id
                                                         ),
                                  1, iss_cd,
                                  NULL
                                 ))
      LOOP
         v_iss.iss_name := i.iss_name;
         v_iss.iss_cd := i.iss_cd;
         PIPE ROW (v_iss);
      END LOOP;
   END get_gipis170_iss_lov;

   FUNCTION get_gipis170_line_lov (
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN get_line_lov_tab PIPELINED
   IS
      v_linelist   get_line_lov_type;
   BEGIN
      FOR i IN (SELECT line_cd, line_name
                  FROM giis_line
                 WHERE line_cd =
                          DECODE (check_user_per_line2 (line_cd,
                                                        p_iss_cd,
                                                        p_module_id,
                                                        p_user_id
                                                       ),
                                  1, line_cd,
                                  NULL
                                 ))
      LOOP
         v_linelist.line_cd := i.line_cd;
         v_linelist.line_name := i.line_name;
         PIPE ROW (v_linelist);
      END LOOP;
   END get_gipis170_line_lov;

   FUNCTION get_gipis170_su_subline_lov
      RETURN get_subline_lov_tab PIPELINED
   IS
      v_subline   get_subline_lov_type;
   BEGIN
      FOR i IN (SELECT subline_name, subline_cd
                  FROM giis_subline
                 WHERE line_cd IN (SELECT param_value_v
                                     FROM giis_parameters
                                    WHERE param_name = 'LINE_CODE_SU'))
      LOOP
         v_subline.subline_name := i.subline_name;
         v_subline.subline_cd := i.subline_cd;
         PIPE ROW (v_subline);
      END LOOP;
   END get_gipis170_su_subline_lov;

   FUNCTION get_gipis170_mc_subline_lov
      RETURN get_subline_lov_tab PIPELINED
   IS
      v_subline   get_subline_lov_type;
   BEGIN
      FOR i IN (SELECT subline_name, subline_cd
                  FROM giis_subline
                 WHERE line_cd IN (SELECT param_value_v
                                     FROM giis_parameters
                                    WHERE param_name = 'LINE_CODE_MC'))
      LOOP
         v_subline.subline_name := i.subline_name;
         v_subline.subline_cd := i.subline_cd;
         PIPE ROW (v_subline);
      END LOOP;
   END get_gipis170_mc_subline_lov;

  /* Formatted on 2014/01/23 13:45 (Formatter Plus v4.8.8) */
   FUNCTION get_gipis170_line_filtered_lov (
      p_iss_cd      giis_line.line_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_doc_type    giis_reports.doc_type%TYPE
   )
      RETURN get_line_lov_tab PIPELINED
   IS
      v_line   get_line_lov_type;
   BEGIN
      FOR i IN (SELECT line_name, line_cd
                  FROM giis_line
                 WHERE check_user_per_line2 (line_cd,
                                             p_iss_cd,
                                             p_module_id,
                                             p_user_id
                                            ) = 1
   --                   AND line_cd IN (SELECT line_cd
   --                                     FROM giis_reports
   --                                    WHERE doc_type = p_doc_type))
                   AND line_cd IN (
                          SELECT line_cd
                            FROM giis_reports
                           WHERE doc_type = p_doc_type
                              OR report_id IN
                                    ('ACCIDENT', 'AVIATION', 'CASUALTY',
                                     'ENGINEERING', 'MEDICAL', 'FIRE',
                                     'MARINE_CARGO', 'MARINE_HULL', 'MOTOR_CAR',
                                     'PACKAGE')))
      LOOP
         v_line.line_name := i.line_name;
         v_line.line_cd := i.line_cd;
         PIPE ROW (v_line);
      END LOOP;
   END get_gipis170_line_filtered_lov;

   FUNCTION get_gipis170_line_su_lov (
      p_iss_cd      giis_line.line_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_doc_type    giis_reports.doc_type%TYPE
   )
      RETURN get_line_lov_tab PIPELINED
   IS
      v_line   get_line_lov_type;
   BEGIN
      FOR i IN (SELECT line_name, line_cd
                  FROM giis_line
                 WHERE check_user_per_line2 (line_cd,
                                             p_iss_cd,
                                             p_module_id,
                                             p_user_id
                                            ) = 1
                   AND line_cd IN (SELECT line_cd
                                     FROM giis_reports
                                    WHERE doc_type = p_doc_type)
                   AND line_cd != (SELECT param_value_v
                                     FROM giis_parameters
                                    WHERE param_name = 'LINE_CODE_SU'))
      LOOP
         v_line.line_name := i.line_name;
         v_line.line_cd := i.line_cd;
         PIPE ROW (v_line);
      END LOOP;
   END get_gipis170_line_su_lov;

   FUNCTION get_gipis170_posting_user_lov
      RETURN get_user_lov_tab PIPELINED
   IS
      v_user   get_user_lov_type;
   BEGIN
      FOR i IN (SELECT   user_id, user_name
                    FROM giis_users
                   WHERE check_user_access2 ('GIPIS055', user_id) = 1
                     AND active_flag = 'Y'
                ORDER BY user_id)
      LOOP
         v_user.user_id := i.user_id;
         v_user.user_name := i.user_name;
         PIPE ROW (v_user);
      END LOOP;
   END get_gipis170_posting_user_lov;

   PROCEDURE initialize_variables (
      p_ri       OUT   giis_parameters.param_value_v%TYPE,
      p_lc_mc    OUT   giis_parameters.param_value_v%TYPE,
      p_sc_lto   OUT   giis_parameters.param_value_v%TYPE,
      p_lc_su    OUT   giis_parameters.param_value_v%TYPE,
      p_bond     OUT   giis_line.line_name%TYPE,
      p_motor    OUT   giis_line.line_name%TYPE
   )
   IS
   BEGIN
      FOR a IN (SELECT param_value_v
                  FROM giis_parameters
                 WHERE param_name = 'REINSURANCE')
      LOOP
         p_ri := a.param_value_v;
         EXIT;
      END LOOP;

      FOR b IN (SELECT param_value_v
                  FROM giis_parameters
                 WHERE param_name = 'LINE_CODE_MC')
      LOOP
         p_lc_mc := b.param_value_v;
         EXIT;
      END LOOP;

      FOR c IN (SELECT param_value_v
                  FROM giis_parameters
                 WHERE param_name = 'COC_TYPE_LTO')
      LOOP
         p_sc_lto := c.param_value_v;
         EXIT;
      END LOOP;

      FOR d IN (SELECT param_value_v
                  FROM giis_parameters
                 WHERE param_name = 'LINE_CODE_SU')
      LOOP
         p_lc_su := d.param_value_v;
         EXIT;
      END LOOP;

      SELECT line_name
        INTO p_bond
        FROM giis_line
       WHERE line_cd = p_lc_su AND ROWNUM = 1;

      SELECT line_name
        INTO p_motor
        FROM giis_line
       WHERE line_cd = p_lc_mc AND ROWNUM = 1;
   END initialize_variables;

   FUNCTION get_policy_endt_id (
      p_print_group   VARCHAR2,
      p_doc_list      giis_reports.doc_type%TYPE,
      p_p_ri          giis_parameters.param_value_v%TYPE,
      p_assured       giis_assured.assd_name%TYPE,
      p_line          giis_line.line_name%TYPE,
      p_subline       giis_subline.subline_name%TYPE,
      p_issue         giis_issource.iss_name%TYPE,
      p_start_seq     gipi_polbasic.pol_seq_no%TYPE,
      p_end_seq       gipi_polbasic.pol_seq_no%TYPE,
      p_start_date    VARCHAR2,
      p_end_date      VARCHAR2,
      p_user          giis_users.user_id%TYPE,
      p_date_list     VARCHAR2,
      p_pol_endt      VARCHAR2,
      p_bond          VARCHAR2,
      p_lc_su         VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN get_policy_endt_id_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      c                   cur_typ;
      v_policy            get_policy_endt_id_type;
      v_start_date        VARCHAR2 (100);
      v_end_date          VARCHAR2 (100);
      v_select            VARCHAR2 (5000);
      v_select_pol_endt   VARCHAR2 (5000);
      v_select_bond       VARCHAR2 (5000);
      v_print             VARCHAR2 (200);
      v_date              VARCHAR2 (200);
      v_pol_endt          VARCHAR2 (10);
      v_subline           VARCHAR2 (500);
   BEGIN
      BEGIN
         IF UPPER (p_date_list) = 'INCEPTION DATE'
         THEN
            v_date := 'b250.incept_date';
         ELSIF UPPER (p_date_list) = 'EFFECTIVITY DATE'
         THEN
            v_date := 'b250.eff_date';
         ELSIF UPPER (p_date_list) = 'EXPIRY DATE'
         THEN
            v_date := 'b250.expiry_date';
         ELSIF UPPER (p_date_list) = 'ISSUE DATE'
         THEN
            v_date := 'b250.issue_date';
         ELSIF UPPER (p_date_list) = 'ENDT EXPIRY DATE'
         THEN
            v_date := 'b250.endt_sxpiry_date';
         END IF;
      END;

      v_subline := REPLACE(p_subline, '''','''''');
      
      BEGIN
         IF UPPER (p_print_group) = 'U'
         THEN
            v_print := 'AND b250.polendt_printed_date IS NULL';
         ELSIF UPPER (p_print_group) = 'P'
         THEN
            v_print := 'AND b250.polendt_printed_date IS NOT NULL';
         ELSIF UPPER (p_print_group) = 'B'
         THEN
            v_print := NULL;
         END IF;
      END;

      BEGIN
         IF UPPER (p_pol_endt) = 'POL'
         THEN
            v_pol_endt := '= 0 ';
         ELSIF UPPER (p_pol_endt) = 'ENDT'
         THEN
            v_pol_endt := '!= 0 ';
         END IF;
      END;

      v_start_date := TRUNC (TO_DATE (p_start_date, 'MM-DD-YYYY'));
      v_end_date := TRUNC (TO_DATE (p_end_date, 'MM-DD-YYYY'));
      v_select_pol_endt :=
            'SELECT DISTINCT policy_id, b250.line_cd
                     FROM gipi_polbasic b250,
                          gipi_parhist b240,
                          giis_assured b230,
                          giis_line b220,
                          giis_subline b210,
                          giis_issource b200
                    WHERE b250.par_id = b240.par_id
                      AND b250.iss_cd != '''
         || p_p_ri
         || '''
                      AND b250.endt_seq_no '
         || v_pol_endt
         || 'AND b250.assd_no = b230.assd_no
                      AND b250.line_cd = b220.line_cd
                      AND b250.subline_cd = b210.subline_cd
                      AND b250.iss_cd = b200.iss_cd
                        AND b250.iss_cd = DECODE (check_user_per_iss_cd2 (b250.line_cd,
                                                          b250.iss_cd,
                                                          ''GIPIS170'', '''
         || p_user_id
         || '''
                                                         ),
                                  1, b250.iss_cd,
                                  NULL
                                 )
                       AND b250.line_cd =
                          DECODE (check_user_per_line2 (b250.line_cd,
                                                        b250.iss_cd,
                                                       ''GIPIS170'', '''
         || p_user_id
         || '''
                                                       ),
                                  1, b250.line_cd,
                                  NULL
                                 )
            AND (b230.assd_name = '''
         || p_assured
         || ''' OR '''
         || p_assured
         || ''' IS NULL)'
         || ' AND (b220.line_name = '''
         || p_line
         || ''' OR '''
         || p_line
         || ''' IS NULL)'
         || ' AND (b210.subline_name = '''
         || v_subline
         || ''' OR '''
         || v_subline
         || ''' IS NULL)'
         || ' AND (b200.iss_name = '''
         || p_issue
         || ''' OR '''
         || p_issue
         || ''' IS NULL)'
         || ' AND (b250.pol_seq_no BETWEEN '''
         || p_start_seq
         || ''' AND '''
         || p_end_seq
         || ''' OR ('''
         || p_start_seq
         || ''' IS NULL AND b250.pol_seq_no < '''
         || p_end_seq
         || ''')
                             OR ('''
         || p_end_seq
         || ''' IS NULL AND b250.pol_seq_no > '''
         || p_start_seq
         || ''')
                             OR ('''
         || p_start_seq
         || ''' IS NULL AND '''
         || p_end_seq
         || ''' IS NULL))
                      AND ((TRUNC ('
         || v_date
         || ') BETWEEN '''
         || v_start_date
         || ''' AND '''
         || v_end_date
         || ''')
                             OR ('''
         || v_start_date
         || ''' IS NULL AND TRUNC ('
         || v_date
         || ') < '''
         || v_end_date
         || ''')
                             OR ('''
         || v_end_date
         || ''' IS NULL AND TRUNC ('
         || v_date
         || ') > '''
         || v_start_date
         || ''')
                             OR ('''
         || v_start_date
         || ''' IS NULL AND '''
         || v_end_date
         || ''' IS NULL)) '
         || v_print
         || ' AND b240.parstat_cd = ''10''
                      AND b240.user_id = NVL ( '''
         || p_user
         || ''', b240.user_id)
                 ORDER BY b250.policy_id';
      v_select_bond :=
            'SELECT distinct policy_id,b250.line_cd
                      FROM gipi_polbasic b250, gipi_parlist b240,
                           giis_assured b230, giis_line b220,
                           giis_subline b210, giis_issource b200
                    WHERE b250.par_id = b240.par_id
                      AND b250.iss_cd != '''
         || p_p_ri
         || '''
                      AND b250.endt_seq_no != 0
                      AND b240.assd_no = b230.assd_no
                      AND b250.line_cd = '''
         || p_lc_su
         || '''
                      AND b250.subline_cd = b210.subline_cd
                      AND b250.iss_cd = b200.iss_cd
                       AND b250.iss_cd = DECODE (check_user_per_iss_cd2 (b250.line_cd,
                                                          b250.iss_cd,
                                                          ''GIPIS170'', '''
         || p_user_id
         || '''
                                                         ),
                                  1, b250.iss_cd,
                                  NULL
                                 )
                       AND b250.line_cd =
                          DECODE (check_user_per_line2 (b250.line_cd,
                                                        b250.iss_cd,
                                                       ''GIPIS170'', '''
         || p_user_id
         || '''
                                                       ),
                                  1, b250.line_cd,
                                  NULL
                                 )
                      AND (b230.assd_name = '''
         || p_assured
         || ''' OR  '''
         || p_assured
         || ''' IS NULL) 
                      AND (b210.subline_name = '''
         || p_subline
         || '''  OR  '''
         || p_subline
         || ''' IS NULL)
                      AND (b200.iss_name = '''
         || p_issue
         || '''  OR  '''
         || p_issue
         || ''' IS NULL)
                      AND (b250.pol_seq_no BETWEEN '''
         || p_start_seq
         || ''' AND '''
         || p_end_seq
         || '''    
                       OR ('''
         || p_start_seq
         || ''' IS NULL AND b250.pol_seq_no < '''
         || p_end_seq
         || ''')
                       OR ('''
         || p_end_seq
         || ''' IS NULL AND b250.pol_seq_no > '''
         || p_start_seq
         || ''') 
                       OR ('''
         || p_start_seq
         || ''' IS NULL AND '''
         || p_end_seq
         || ''' IS NULL))
                      AND (trunc('
         || v_date
         || ') BETWEEN '''
         || v_start_date
         || ''' AND '''
         || v_end_date
         || '''      
                     OR ('''
         || v_start_date
         || ''' IS NULL AND trunc('
         || v_date
         || ') < '''
         || v_end_date
         || ''' )
                     OR ('''
         || v_end_date
         || '''  IS NULL AND trunc('
         || v_date
         || ') > '''
         || v_start_date
         || ''') 
                       OR ('''
         || v_start_date
         || '''  IS NULL AND '''
         || v_end_date
         || '''  IS NULL))'
         || v_print
         || ' ORDER BY b250.policy_id';

      IF p_bond = 'N'
      THEN
         v_select := v_select_pol_endt;
      ELSIF p_bond = 'Y'
      THEN
         v_select := v_select_bond;
      END IF;

      OPEN c FOR v_select;

      LOOP
         FETCH c
          INTO v_policy.policy_id, v_policy.line_cd;

         BEGIN
           
                IF p_bond = 'N'
              THEN
                  BEGIN
                    SELECT report_id
                      INTO v_policy.report_id
                      FROM giis_reports a
                     WHERE a.line_cd = NVL (v_policy.line_cd, a.line_cd)
                       AND report_id IN ('ACCIDENT', 'AVIATION', 'CASUALTY', 'ENGINEERING', 'MEDICAL', 'FIRE', 
                                         'MARINE_CARGO', 'MARINE_HULL', 'MOTORCAR', 'PACKAGE')
                       AND ROWNUM = 1;
                       EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        --MSG_ALERT('No data found in GIIS_REPORTS for line_cd '||v_line_cd||'.','I',TRUE);
                        raise_application_error(-20001, 'Geniisys Exception#I#No data found in GIIS_REPORTS for line_cd '|| v_policy.line_cd || '.');
                                
                    --WHEN TOO_MANY_ROWS THEN
                      --MSG_ALERT('Too many rows found in GIIS_REPORTS for line_cd '||v_line_cd||'.','I',TRUE);
                      --raise_application_error(-20001, 'Geniisys Exception#I#Too many rows found in GIIS_REPORTS for line_cd '||v_policy.line_cd || '.');
                  END;
              ELSIF p_bond = 'Y'
              THEN
                SELECT report_id
                  INTO v_policy.report_id
                  FROM giis_reports a
                 WHERE a.line_cd = NVL (v_policy.line_cd, a.line_cd)
                   AND doc_type = p_doc_list
                   AND ROWNUM = 1;
              END IF;
      
         END;

         BEGIN
            SELECT gixx_extid_seq.NEXTVAL
              INTO v_policy.extract_id
              FROM DUAL;
         END;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_policy);
      END LOOP;

      CLOSE c;
   END get_policy_endt_id;

   FUNCTION get_binder_fnl_bndr_id (
      p_print_group   VARCHAR2,
      p_doc_list      giis_reports.doc_type%TYPE,
      p_assured       giis_assured.assd_name%TYPE,
      p_line          giis_line.line_name%TYPE,
      p_subline       giis_subline.subline_name%TYPE,
      p_issue         giis_issource.iss_name%TYPE,
      p_cedant        giis_reinsurer.ri_sname%TYPE,
      p_start_seq     gipi_polbasic.pol_seq_no%TYPE,
      p_end_seq       gipi_polbasic.pol_seq_no%TYPE,
      p_start_date    VARCHAR2,
      p_end_date      VARCHAR2,
      p_date_list     VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN get_binder_fnl_bndr_id_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      c                cur_typ;
      v_binder         get_binder_fnl_bndr_id_type;
      v_start_date     VARCHAR2 (100);
      v_end_date       VARCHAR2 (100);
      v_select         VARCHAR2 (5000);
      v_print          VARCHAR2 (200);
      v_date           VARCHAR2 (200);
      v_print_column   VARCHAR2 (50);
      v_assd_no        NUMBER (12);
      v_assd_query     VARCHAR2 (200);
      v_subline        VARCHAR2 (500);
   BEGIN
      BEGIN
         IF UPPER (p_date_list) = 'BINDER DATE'
         THEN
            v_date := 'a.binder_date';
            v_print_column := ' AND a.bndr_print_date ';
         ELSIF UPPER (p_date_list) = 'REVERSE DATE'
         THEN
            v_date := 'a.reverse_date';
            v_print_column := ' AND d005.revrs_bndr_print_date ';
         END IF;
      END;
      
      v_subline := REPLACE(p_subline, '''','''''');
    
      BEGIN
         IF UPPER (p_print_group) = 'U'
         THEN
            v_print := 'IS NULL';
         ELSIF UPPER (p_print_group) = 'P'
         THEN
            v_print := 'IS NOT NULL';
         ELSIF UPPER (p_print_group) = 'B'
         THEN
            v_print := NULL;
            v_print_column := NULL;
         END IF;
      END;

      BEGIN
         v_assd_query := ' AND (b220.line_name = ''';

         FOR i IN (SELECT assd_no
                     FROM giis_assured
                    WHERE assd_name = p_assured)
         LOOP
            v_assd_no := i.assd_no;

            IF p_assured IS NOT NULL
            THEN
               v_assd_query :=
                     ' AND b230.assd_no = '
                  || v_assd_no
                  || ' AND (b220.line_name = ''';
            END IF;
         END LOOP;
      END;

      v_start_date := TRUNC (TO_DATE (p_start_date, 'MM-DD-YYYY'));
      v_end_date := TRUNC (TO_DATE (p_end_date, 'MM-DD-YYYY'));
      v_select :=
            'SELECT distinct a.fnl_binder_id, a.line_cd,
  	                     a.binder_yy, a.binder_seq_no 
  	                FROM giri_binder_polbasic_v A, giri_frps_ri d005,
  	                     giis_assured b230, giis_line b220,
  	                     giis_subline b210, giis_issource b200,
  	                     giis_reinsurer b240
  	              WHERE d005.fnl_binder_id = a.fnl_binder_id
  	                AND d005.line_cd = A.line_cd
  	                AND d005.frps_yy = A.frps_yy
  	                AND d005.frps_seq_no = A.frps_seq_no
                AND A.assd_name = b230.assd_name                    
  	                AND A.line_cd = b220.line_cd
  	                AND A.subline_cd = b210.subline_cd
  	                AND A.iss_cd = b200.iss_cd
  	                AND A.ri_sname = b240.ri_sname
                     AND A.iss_cd = DECODE (check_user_per_iss_cd2 (A.line_cd,
                                                          A.iss_cd,
                                                          ''GIPIS170'', '''
         || p_user_id
         || '''
                                                         ),
                                  1, A.iss_cd,
                                  NULL
                                 )
                       AND A.line_cd =
                          DECODE (check_user_per_line2 (A.line_cd,
                                                        A.iss_cd,
                                                       ''GIPIS170'', '''
         || p_user_id
         || '''
                                                       ),
                                  1, A.line_cd,
                                  NULL
                                 )'
         || v_assd_query
         || p_line
         || '''  OR  '''
         || p_line
         || ''' IS NULL)
  	                AND (b210.subline_name = '''
         || v_subline
         || '''  OR  '''
         || v_subline
         || ''' IS NULL)
  	                AND (b200.iss_name = '''
         || p_issue
         || '''  OR  '''
         || p_issue
         || ''' IS NULL)
  	                AND (b240.ri_name = '''
         || p_cedant
         || '''  OR  '''
         || p_cedant
         || ''' IS NULL)
                    AND ((A.binder_seq_no BETWEEN '''
         || p_start_seq
         || ''' AND '''
         || p_end_seq
         || ''' )
   	                 OR ('''
         || p_start_seq
         || ''' IS NULL AND a.binder_seq_no < '''
         || p_end_seq
         || ''' )
  	                 OR ('''
         || p_end_seq
         || ''' IS NULL AND a.binder_seq_no > '''
         || p_start_seq
         || ''') 
  	                 OR ('''
         || p_start_seq
         || ''' IS NULL OR '''
         || p_end_seq
         || ''' IS NULL))
                    AND ((trunc('
         || v_date
         || ') BETWEEN '''
         || v_start_date
         || ''' AND '''
         || v_end_date
         || ''')
                      OR ('''
         || v_start_date
         || ''' IS NULL AND trunc('
         || v_date
         || ') < '''
         || v_end_date
         || ''')
                     OR ('''
         || v_end_date
         || ''' IS NULL AND trunc('
         || v_date
         || ') > '''
         || v_start_date
         || ''')
                     OR ('''
         || v_start_date
         || ''' IS NULL OR '''
         || v_end_date
         || ''' IS NULL))'
         || v_print_column
         || v_print
         || ' ORDER BY a.fnl_binder_id';

      OPEN c FOR v_select;

      LOOP
         FETCH c
          INTO v_binder.fnl_binder_id, v_binder.line_cd, v_binder.binder_yy,
               v_binder.binder_seq_no;

         BEGIN
            SELECT report_id
              INTO v_binder.report_id
              FROM giis_reports a
             WHERE doc_type = p_doc_list AND line_cd = a.line_cd;
         EXCEPTION
            WHEN TOO_MANY_ROWS
            THEN
               SELECT report_id
                 INTO v_binder.report_id
                 FROM giis_reports a
                WHERE doc_type = p_doc_list AND line_cd = 'RI';
         END;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_binder);
      END LOOP;

      CLOSE c;
   END get_binder_fnl_bndr_id;

   FUNCTION get_marketing_quote_id (
      p_print_group   VARCHAR2,
      p_doc_list      giis_reports.doc_type%TYPE,
      p_assured       giis_assured.assd_name%TYPE,
      p_line          giis_line.line_name%TYPE,
      p_subline       giis_subline.subline_name%TYPE,
      p_issue         giis_issource.iss_name%TYPE,
      p_start_seq     gipi_polbasic.pol_seq_no%TYPE,
      p_end_seq       gipi_polbasic.pol_seq_no%TYPE,
      p_start_date    VARCHAR2,
      p_end_date      VARCHAR2
   )
      RETURN get_marketing_quote_id_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      c              cur_typ;
      v_marketing    get_marketing_quote_id_type;
      v_start_date   VARCHAR2 (100);
      v_end_date     VARCHAR2 (100);
      v_select       VARCHAR2 (5000);
      v_print        VARCHAR2 (200);
   BEGIN
      BEGIN
         IF UPPER (p_print_group) = 'U'
         THEN
            v_print := ' AND b240.print_dt IS NULL ';
         ELSIF UPPER (p_print_group) = 'P'
         THEN
            v_print := ' AND b240.print_dt IS NOT NULL ';
         ELSIF UPPER (p_print_group) = 'B'
         THEN
            v_print := NULL;
         END IF;
      END;

      v_start_date := TRUNC (TO_DATE (p_start_date, 'MM-DD-YYYY'));
      v_end_date := TRUNC (TO_DATE (p_end_date, 'MM-DD-YYYY'));
      v_select :=
            'SELECT distinct quote_id, b240.line_cd
                   FROM gipi_quote b240, giis_line b220,
                        giis_subline b210, giis_issource b200
                   WHERE b240.line_cd = b220.line_cd
                     AND b240.subline_cd = b210.subline_cd
                     AND b240.iss_cd = b200.iss_cd
                     AND (b240.assd_name = '''
         || p_assured
         || ''' OR '''
         || p_assured
         || ''' IS NULL) 
                     AND (b220.line_name = '''
         || p_line
         || ''' OR '''
         || p_line
         || ''' IS NULL)
                     AND (b210.subline_name = '''
         || p_subline
         || ''' OR '''
         || p_subline
         || ''' IS NULL)
                     AND (b200.iss_name = '''
         || p_issue
         || ''' OR '''
         || p_issue
         || ''' IS NULL)
                     AND (b240.quotation_no BETWEEN '''
         || p_start_seq
         || ''' AND '''
         || p_end_seq
         || '''     
                       OR ('''
         || p_start_seq
         || ''' IS NULL AND b240.quotation_no < '''
         || p_end_seq
         || ''' )
                       OR ('''
         || p_end_seq
         || ''' IS NULL AND b240.quotation_no > '''
         || p_start_seq
         || ''') 
                       OR ('''
         || p_start_seq
         || ''' IS NULL AND '''
         || p_end_seq
         || ''' IS NULL))
                     AND (trunc(b240.accept_dt) BETWEEN '''
         || v_start_date
         || ''' AND '''
         || v_end_date
         || '''
                       OR ('''
         || v_start_date
         || ''' IS NULL AND trunc(b240.accept_dt) < '''
         || v_end_date
         || ''')
                       OR ('''
         || v_end_date
         || ''' IS NULL AND trunc(b240.accept_dt) > '''
         || v_start_date
         || ''') 
                       OR ('''
         || v_start_date
         || ''' IS NULL AND '''
         || v_end_date
         || ''' IS NULL))'
         || v_print
         || 'ORDER BY quote_id';

      OPEN c FOR v_select;

      LOOP
         FETCH c
          INTO v_marketing.quote_id, v_marketing.line_cd;

         BEGIN
            SELECT report_id
              INTO v_marketing.report_id
              FROM giis_reports
             WHERE doc_type = p_doc_list
               AND line_cd = NVL (v_marketing.line_cd, line_cd)
               AND ROWNUM = 1;
         END;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_marketing);
      END LOOP;

      CLOSE c;
   END get_marketing_quote_id;

   FUNCTION get_quotation_quote_id (
      p_doc_list     giis_reports.doc_type%TYPE,
      p_assured      giis_assured.assd_name%TYPE,
      p_line         giis_line.line_name%TYPE,
      p_subline      giis_subline.subline_name%TYPE,
      p_issue        giis_issource.iss_name%TYPE,
      p_start_seq    gipi_polbasic.pol_seq_no%TYPE,
      p_end_seq      gipi_polbasic.pol_seq_no%TYPE,
      p_start_date   VARCHAR2,
      p_end_date     VARCHAR2
   )
      RETURN get_quotation_quote_id_tab PIPELINED
   IS
      v_quote        get_quotation_quote_id_type;
      v_start_date   VARCHAR2 (100);
      v_end_date     VARCHAR2 (100);
   BEGIN
      v_start_date := TRUNC (TO_DATE (p_start_date, 'MM-DD-YYYY'));
      v_end_date := TRUNC (TO_DATE (p_end_date, 'MM-DD-YYYY'));

      FOR i IN (SELECT DISTINCT b540.par_id, b540.line_cd
                           FROM gipi_wpolbas b540,
                                gipi_parlist b240,
                                giis_assured b230,
                                giis_line b220,
                                giis_subline b210,
                                giis_issource b200
                          WHERE b540.par_id = b240.par_id
                            AND b240.assd_no = b230.assd_no
                            AND b540.line_cd = b220.line_cd
                            AND b540.subline_cd = b210.subline_cd
                            AND b540.iss_cd = b200.iss_cd
                            AND (   b230.assd_name = p_assured
                                 OR p_assured IS NULL
                                )
                            AND (b220.line_name = p_line OR p_line IS NULL)
                            AND (   b210.subline_name = p_subline
                                 OR p_subline IS NULL
                                )
                            AND (b200.iss_name = p_issue OR p_issue IS NULL)
                            AND (   b240.par_seq_no BETWEEN p_start_seq
                                                        AND p_end_seq
                                 OR (    p_start_seq IS NULL
                                     AND b240.par_seq_no < p_end_seq
                                    )
                                 OR (    p_end_seq IS NULL
                                     AND b240.par_seq_no > p_start_seq
                                    )
                                 OR (p_start_seq IS NULL AND p_end_seq IS NULL
                                    )
                                )
                            AND (   (TRUNC (b540.incept_date)
                                        BETWEEN v_start_date
                                            AND v_end_date
                                    )
                                 OR (    v_start_date IS NULL
                                     AND TRUNC (b540.incept_date) < v_end_date
                                    )
                                 OR (    v_end_date IS NULL
                                     AND TRUNC (b540.incept_date) >
                                                                  v_start_date
                                    )
                                 OR (    v_start_date IS NULL
                                     AND v_end_date IS NULL
                                    )
                                ))
      LOOP
         v_quote.par_id := i.par_id;
         v_quote.line_cd := i.line_cd;

         BEGIN
            SELECT report_id
              INTO v_quote.report_id
              FROM giis_reports
             WHERE doc_type = p_doc_list
               AND line_cd = NVL (v_quote.line_cd, line_cd)
               AND ROWNUM = 1;
         END;

         PIPE ROW (v_quote);
      END LOOP;
   END get_quotation_quote_id;

   FUNCTION get_covernote_par_id (
      p_print_group   VARCHAR2,
      p_doc_list      giis_reports.doc_type%TYPE,
      p_assured       giis_assured.assd_name%TYPE,
      p_line          giis_line.line_name%TYPE,
      p_subline       giis_subline.subline_name%TYPE,
      p_issue         giis_issource.iss_name%TYPE,
      p_start_seq     gipi_polbasic.pol_seq_no%TYPE,
      p_end_seq       gipi_polbasic.pol_seq_no%TYPE,
      p_start_date    VARCHAR2,
      p_end_date      VARCHAR2,
      p_date_list     VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN get_covernote_par_id_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      c              cur_typ;
      v_cover        get_covernote_par_id_type;
      v_start_date   VARCHAR2 (100);
      v_end_date     VARCHAR2 (100);
      v_select       VARCHAR2 (5000);
      v_print        VARCHAR2 (200);
      v_date         VARCHAR2 (200);
      v_subline        VARCHAR2 (500);
   BEGIN
      BEGIN
         IF UPPER (p_date_list) = 'INCEPTION DATE'
         THEN
            v_date := 'b540.incept_date';
         ELSIF UPPER (p_date_list) = 'EFFECTIVITY DATE'
         THEN
            v_date := 'b540.eff_date';
         ELSIF UPPER (p_date_list) = 'EXPIRY DATE'
         THEN
            v_date := 'b540.expiry_date';
         ELSIF UPPER (p_date_list) = 'ISSUE DATE'
         THEN
            v_date := 'b540.issue_date';
         END IF;
      END;

      v_subline := REPLACE(p_subline, '''','''''');

      BEGIN
         IF UPPER (p_print_group) = 'U'
         THEN
            v_print := 'AND b540.cover_nt_printed_date IS NULL';
         ELSIF UPPER (p_print_group) = 'P'
         THEN
            v_print := 'AND b540.cover_nt_printed_date IS NOT NULL';
         ELSIF UPPER (p_print_group) = 'B'
         THEN
            v_print := NULL;
         END IF;
      END;

      v_start_date := TRUNC (TO_DATE (p_start_date, 'MM-DD-YYYY'));
      v_end_date := TRUNC (TO_DATE (p_end_date, 'MM-DD-YYYY'));
      v_select :=
            'SELECT distinct b540.par_id, b540.line_cd
                      FROM gipi_wpolbas b540, gipi_parlist b240,
                           giis_assured b230, giis_line b220,
                           giis_subline b210, giis_issource b200
                    WHERE b540.par_id = b240.par_id
                      AND b240.assd_no = b230.assd_no
                      AND b540.line_cd = b220.line_cd
                      AND b540.subline_cd = b210.subline_cd
                       AND b540.iss_cd = b200.iss_cd
                      AND b540.iss_cd = DECODE (check_user_per_iss_cd2 (b540.line_cd,
                                                          b540.iss_cd,
                                                          ''GIPIS170'', '''
         || p_user_id
         || '''
                                                         ),
                                  1, b540.iss_cd,
                                  NULL
                                 )
                       AND b540.line_cd =
                          DECODE (check_user_per_line2 (b540.line_cd,
                                                        b540.iss_cd,
                                                       ''GIPIS170'', '''
         || p_user_id
         || '''
                                                       ),
                                  1, b540.line_cd,
                                  NULL
                                 )
                      AND b540.line_cd IN (SELECT line_cd FROM giis_reports WHERE doc_type = '''
         || p_doc_list
         || ''')
                      AND (b230.assd_name = '''
         || p_assured
         || ''' OR '''
         || p_assured
         || ''' IS NULL) 
                      AND (b220.line_name = '''
         || p_line
         || ''' OR  '''
         || p_line
         || ''' IS NULL)
                      AND (b210.subline_name = '''
         || v_subline
         || '''  OR  '''
         || v_subline
         || ''' IS NULL)
                      AND (b200.iss_name = '''
         || p_issue
         || '''  OR  '''
         || p_issue
         || ''' IS NULL)
                      AND (b240.par_seq_no BETWEEN '''
         || p_start_seq
         || ''' AND '''
         || p_end_seq
         || '''    
                       OR ('''
         || p_start_seq
         || ''' IS NULL AND b240.par_seq_no < '''
         || p_end_seq
         || ''')
                       OR ('''
         || p_end_seq
         || ''' IS NULL AND b240.par_seq_no > '''
         || p_start_seq
         || ''') 
                       OR ('''
         || p_start_seq
         || ''' IS NULL AND '''
         || p_end_seq
         || ''' IS NULL))
                       AND (('
         || v_date
         || ' BETWEEN '''
         || v_start_date
         || ''' AND '''
         || v_end_date
         || ''')    
                     OR ('''
         || v_start_date
         || ''' IS NULL AND '
         || v_date
         || ' < '''
         || v_end_date
         || ''')
                     OR ('''
         || v_end_date
         || ''' IS NULL AND '
         || v_date
         || ' > '''
         || v_start_date
         || ''') 
                       OR ('''
         || v_start_date
         || ''' IS NULL AND '''
         || v_end_date
         || ''' IS NULL)) '
         || v_print
         || ' ORDER BY b540.par_id';

      OPEN c FOR v_select;

      LOOP
         FETCH c
          INTO v_cover.par_id, v_cover.line_cd;

         BEGIN
            SELECT report_id
              INTO v_cover.report_id
              FROM giis_reports
             WHERE doc_type = p_doc_list
               AND line_cd = v_cover.line_cd
               AND ROWNUM = 1;
         END;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_cover);
      END LOOP;

      CLOSE c;
   END get_covernote_par_id;

   FUNCTION get_coc_serial_no (
      p_print_group   VARCHAR2,
      p_doc_list      giis_reports.doc_type%TYPE,
      p_assured       giis_assured.assd_name%TYPE,
      p_subline       giis_subline.subline_name%TYPE,
      p_issue         giis_issource.iss_name%TYPE,
      p_start_seq     gipi_polbasic.pol_seq_no%TYPE,
      p_end_seq       gipi_polbasic.pol_seq_no%TYPE,
      p_start_date    VARCHAR2,
      p_end_date      VARCHAR2,
      p_date_list     VARCHAR2,
      p_lc_mc         VARCHAR2,
      p_sc_lto        VARCHAR2,
      p_lto           VARCHAR2,
      p_user          VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN get_coc_serial_no_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      c              cur_typ;
      v_coc          get_coc_serial_no_type;
      v_start_date   VARCHAR2 (100);
      v_end_date     VARCHAR2 (100);
      v_select       VARCHAR2 (5000);
      v_print        VARCHAR2 (200);
      v_date         VARCHAR2 (200);
      v_lto          VARCHAR2 (50);
      v_subline        VARCHAR2 (500);
      
   BEGIN
      BEGIN
         IF UPPER (p_date_list) = 'INCEPTION DATE'
         THEN
            v_date := 'b250.incept_date';
         ELSIF UPPER (p_date_list) = 'EFFECTIVITY DATE'
         THEN
            v_date := 'b250.eff_date';
         ELSIF UPPER (p_date_list) = 'EXPIRY DATE'
         THEN
            v_date := 'b250.expiry_date';
         ELSIF UPPER (p_date_list) = 'ISSUE DATE'
         THEN
            v_date := 'b250.issue_date';
         ELSIF UPPER (p_date_list) = 'COC ISSUE DATE'
         THEN
            v_date := 'b120.coc_issue_date';
         END IF;
      END;

      v_subline := REPLACE(p_subline, '''','''''');
      
      BEGIN
         IF UPPER (p_print_group) = 'U'
         THEN
            v_print := 'AND b340.mc_coc_printed_date IS NULL';
         ELSIF UPPER (p_print_group) = 'P'
         THEN
            v_print := 'AND b340.mc_coc_printed_date IS NOT NULL';
         ELSIF UPPER (p_print_group) = 'B'
         THEN
            v_print := NULL;
         END IF;
      END;

      BEGIN
         IF UPPER (p_lto) = 'LTO'
         THEN
            v_lto := '= ''' || p_sc_lto || '''';
         ELSIF UPPER (p_lto) = 'NON-LTO'
         THEN
            v_lto := '!= ''' || p_sc_lto || '''';
         END IF;
      END;

      v_start_date := TRUNC (TO_DATE (p_start_date, 'MM-DD-YYYY'));
      v_end_date := TRUNC (TO_DATE (p_end_date, 'MM-DD-YYYY'));
      v_select :=
            'SELECT distinct b120.coc_serial_no,b250.policy_id, b340.item_no
                      FROM gipi_polbasic b250, gipi_parhist b240,
                           gipi_item b340,gipi_vehicle b120,
                           giis_assured b230, giis_subline b210, 
                           giis_issource b200
                    WHERE b250.par_id = b240.par_id
                      AND b250.policy_id = b340.policy_id
                      AND b340.policy_id = b120.policy_id
                      AND b340.item_no = b120.item_no
                      AND b250.assd_no = b230.assd_no
                       AND b250.iss_cd = DECODE (check_user_per_iss_cd2 (b250.line_cd,
                                                          b250.iss_cd,
                                                          ''GIPIS170'', '''
         || p_user_id
         || '''
                                                         ),
                                  1, b250.iss_cd,
                                  NULL
                                 )
                       AND b250.line_cd =
                          DECODE (check_user_per_line2 (b250.line_cd,
                                                        b250.iss_cd,
                                                       ''GIPIS170'', '''
         || p_user_id
         || '''
                                                       ),
                                  1, b250.line_cd,
                                  NULL
                                 )
                      AND b250.line_cd = '''
         || p_lc_mc
         || ''' 
                      AND b250.subline_cd = b210.subline_cd
                      AND b250.subline_cd '
         || v_lto
         || '
                      AND b250.iss_cd = b200.iss_cd
                      AND (b230.assd_name = '''
         || p_assured
         || ''' OR  '''
         || p_assured
         || ''' IS NULL) 
                      AND (b210.subline_name = '''
         || v_subline
         || '''  OR  '''
         || v_subline
         || ''' IS NULL)
                      AND (b200.iss_name = '''
         || p_issue
         || '''  OR  '''
         || p_issue
         || ''' IS NULL)
                      AND (b120.coc_serial_no BETWEEN '''
         || p_start_seq
         || ''' AND '''
         || p_end_seq
         || '''   
                       OR ('''
         || p_start_seq
         || ''' IS NULL AND b120.coc_serial_no < '''
         || p_end_seq
         || ''' )
                       OR ('''
         || p_end_seq
         || ''' IS NULL AND b120.coc_serial_no > '''
         || p_start_seq
         || ''') 
                       OR ('''
         || p_start_seq
         || ''' IS NULL AND '''
         || p_end_seq
         || ''' IS NULL))
                      AND (trunc('
         || v_date
         || ') BETWEEN '''
         || v_start_date
         || ''' AND '''
         || v_end_date
         || '''
                     OR ('''
         || v_start_date
         || ''' IS NULL AND trunc('
         || v_date
         || ') < '''
         || v_end_date
         || ''')
                     OR ('''
         || v_end_date
         || ''' IS NULL AND trunc('
         || v_date
         || ') > '''
         || v_start_date
         || ''') 
                       OR ('''
         || v_start_date
         || ''' IS NULL AND '''
         || v_end_date
         || ''' IS NULL)) '
         || v_print
         || ' AND b240.parstat_cd = ''10''
                      AND b240.user_id = NVL ( '''
         || p_user
         || ''', b240.user_id)
                 ORDER BY b120.coc_serial_no';

      OPEN c FOR v_select;

      LOOP
         FETCH c
          INTO v_coc.coc_serial_no, v_coc.policy_id, v_coc.item_no;

         BEGIN
            SELECT report_id
              INTO v_coc.report_id
              FROM giis_reports
             WHERE doc_type = p_doc_list AND line_cd = p_lc_mc AND ROWNUM = 1;
         END;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_coc);
      END LOOP;

      CLOSE c;
   END get_coc_serial_no;

   FUNCTION get_invoice_ri_pol_id (
      p_print_group   VARCHAR2,
      p_doc_list      giis_reports.doc_type%TYPE,
      p_assured       giis_assured.assd_name%TYPE,
      p_line          giis_line.line_name%TYPE,
      p_subline       giis_subline.subline_name%TYPE,
      p_issue         giis_issource.iss_name%TYPE,
      p_user          giis_users.user_id%TYPE,
      p_start_seq     gipi_polbasic.pol_seq_no%TYPE,
      p_end_seq       gipi_polbasic.pol_seq_no%TYPE,
      p_start_date    VARCHAR2,
      p_end_date      VARCHAR2,
      p_date_list     VARCHAR2,
      p_lc_su         VARCHAR2,
      p_bond_pol      VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN get_invoice_ri_pol_id_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      c              cur_typ;
      v_ri           get_invoice_ri_pol_id_type;
      v_select       VARCHAR2 (5000);
      v_date         VARCHAR2 (200);
      v_print        VARCHAR2 (200);
      v_ri_pol       VARCHAR2 (10);
      v_start_date   VARCHAR2 (100);
      v_end_date     VARCHAR2 (100);
      v_subline      VARCHAR2 (500);
   BEGIN
      BEGIN
         IF UPPER (p_date_list) = 'INCEPTION DATE'
         THEN
            v_date := 'b250.incept_date';
         ELSIF UPPER (p_date_list) = 'EFFECTIVITY DATE'
         THEN
            v_date := 'b250.eff_date';
         ELSIF UPPER (p_date_list) = 'EXPIRY DATE'
         THEN
            v_date := 'b250.expiry_date';
         ELSIF UPPER (p_date_list) = 'ISSUE DATE'
         THEN
            v_date := 'b250.issue_date';
         END IF;
      END;

      v_subline := REPLACE(p_subline, '''','''''');

      BEGIN
         IF UPPER (p_print_group) = 'U'
         THEN
            v_print := ' AND b140.invoice_printed_date IS NULL';
         ELSIF UPPER (p_print_group) = 'P'
         THEN
            v_print := ' AND b140.invoice_printed_date IS NOT NULL';
         ELSIF UPPER (p_print_group) = 'B'
         THEN
            v_print := NULL;
         END IF;
      END;

      BEGIN
         IF UPPER (p_bond_pol) = 'BOND'
         THEN
            v_ri_pol := '= ''' || p_lc_su || '''';
         ELSIF UPPER (p_bond_pol) = 'POLICY'
         THEN
            v_ri_pol := '!= ''' || p_lc_su || '''';
         END IF;
      END;

      v_start_date := TRUNC (TO_DATE (p_start_date, 'MM-DD-YYYY'));
      v_end_date := TRUNC (TO_DATE (p_end_date, 'MM-DD-YYYY'));
      v_select :=
            'SELECT distinct b250.policy_id,b250.line_cd, b250.endt_type, b250.pack_pol_flag, b250.takeup_term
                      FROM gipi_polbasic b250, gipi_parhist b240,
                           gipi_invoice b140, giis_assured b230, 
                           giis_line b220, giis_subline b210, 
                           giis_issource b200
                    WHERE b250.policy_id = b140.policy_id
                      AND b250.par_id = b240.par_id
                      AND b250.assd_no = b230.assd_no 
                      AND b250.line_cd = b220.line_cd
                      AND b250.subline_cd = b210.subline_cd
                      AND b250.iss_cd = b200.iss_cd
                      AND b250.iss_cd = DECODE (check_user_per_iss_cd2 (b250.line_cd,
                                                          b250.iss_cd,
                                                          ''GIPIS170'', '''
         || p_user_id
         || '''
                                                         ),
                                  1, b250.iss_cd,
                                  NULL
                                 )
                       AND b250.line_cd =
                          DECODE (check_user_per_line2 (b250.line_cd,
                                                        b250.iss_cd,
                                                       ''GIPIS170'', '''
         || p_user_id
         || '''
                                                       ),
                                  1, b250.line_cd,
                                  NULL
                                 )
                      AND b250.line_cd  '
         || v_ri_pol
         || ' AND (b230.assd_name = '''
         || p_assured
         || ''' OR '''
         || p_assured
         || ''' IS NULL)'
         || ' AND (b220.line_name = '''
         || p_line
         || ''' OR '''
         || p_line
         || ''' IS NULL)'
         || ' AND (b210.subline_name = '''
         || v_subline
         || ''' OR '''
         || v_subline
         || ''' IS NULL)'
         || ' AND (b200.iss_name = '''
         || p_issue
         || ''' OR '''
         || p_issue
         || ''' IS NULL)'
         || ' AND (b140.prem_seq_no BETWEEN '''
         || p_start_seq
         || ''' AND '''
         || p_end_seq
         || ''' OR ('''
         || p_start_seq
         || ''' IS NULL AND b140.prem_seq_no < '''
         || p_end_seq
         || ''')
                             OR ('''
         || p_end_seq
         || ''' IS NULL AND b140.prem_seq_no > '''
         || p_start_seq
         || ''')
                             OR ('''
         || p_start_seq
         || ''' IS NULL AND '''
         || p_end_seq
         || ''' IS NULL))
                      AND ((TRUNC ('
         || v_date
         || ') BETWEEN '''
         || v_start_date
         || ''' AND '''
         || v_end_date
         || ''')
                             OR ('''
         || v_start_date
         || ''' IS NULL AND TRUNC ('
         || v_date
         || ') < '''
         || v_end_date
         || ''')
                             OR ('''
         || v_end_date
         || ''' IS NULL AND TRUNC ('
         || v_date
         || ') > '''
         || v_start_date
         || ''')
                             OR ('''
         || v_start_date
         || ''' IS NULL AND '''
         || v_end_date
         || ''' IS NULL)) '
         || v_print
         || ' AND b240.parstat_cd = ''10''
                      AND b240.user_id = NVL ( '''
         || p_user
         || ''', b240.user_id)
                 ORDER BY b250.policy_id';

      OPEN c FOR v_select;

      LOOP
         FETCH c
          INTO v_ri.policy_id, v_ri.line_cd, v_ri.endt_type,
               v_ri.pack_pol_flag, v_ri.takeup_term;

         BEGIN
            IF p_bond_pol = 'POLICY'
            THEN
               IF (    v_ri.endt_type IS NULL
                   AND v_ri.pack_pol_flag = 'N'
                   AND v_ri.takeup_term = 'ST'
                   AND v_ri.line_cd <> 'SU'
                  )
               THEN
                  v_ri.report_id := 'GIPIR913';
               ELSIF (    v_ri.endt_type IS NOT NULL
                      AND v_ri.pack_pol_flag = 'N'
                      AND v_ri.takeup_term = 'ST'
                      AND v_ri.line_cd <> 'SU'
                     )
               THEN
                  v_ri.report_id := 'GIPIR913A';
               ELSIF (    v_ri.pack_pol_flag = 'Y'
                      AND v_ri.takeup_term = 'ST'
                      AND v_ri.line_cd <> 'SU'
                     )
               THEN
                  v_ri.report_id := 'GIPIR913B';
               ELSIF (v_ri.takeup_term <> 'ST' AND v_ri.line_cd <> 'SU')
               THEN
                  v_ri.report_id := 'GIPIR913D';
               END IF;
            ELSIF p_bond_pol = 'BOND'
            THEN
               SELECT report_id
                 INTO v_ri.report_id
                 FROM giis_reports
                WHERE doc_type = p_doc_list AND ROWNUM = 1;
            END IF;
         END;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_ri);
      END LOOP;

      CLOSE c;
   END get_invoice_ri_pol_id;

   FUNCTION get_invoice_ri (
      p_print_group   VARCHAR2,
      p_doc_list      giis_reports.doc_type%TYPE,
      p_assured       giis_assured.assd_name%TYPE,
      p_line          giis_line.line_name%TYPE,
      p_subline       giis_subline.subline_name%TYPE,
      p_issue         giis_issource.iss_name%TYPE,
      p_cedant        giis_reinsurer.ri_sname%TYPE,
      p_start_seq     gipi_polbasic.pol_seq_no%TYPE,
      p_end_seq       gipi_polbasic.pol_seq_no%TYPE,
      p_start_date    VARCHAR2,
      p_end_date      VARCHAR2,
      p_date_list     VARCHAR2,
      p_user          giis_users.user_id%TYPE,
      p_user_id       VARCHAR2
   )
      RETURN get_invoice_ri_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      c              cur_typ;
      v_ri           get_invoice_ri_type;
      v_select       VARCHAR2 (5000);
      v_date         VARCHAR2 (200);
      v_print        VARCHAR2 (200);
      v_ri_pol       VARCHAR2 (10);
      v_start_date   VARCHAR2 (100);
      v_end_date     VARCHAR2 (100);
      v_subline      VARCHAR2 (500);
   BEGIN
      BEGIN
         IF UPPER (p_date_list) = 'INCEPTION DATE'
         THEN
            v_date := 'b250.incept_date';
         ELSIF UPPER (p_date_list) = 'EFFECTIVITY DATE'
         THEN
            v_date := 'b250.eff_date';
         ELSIF UPPER (p_date_list) = 'EXPIRY DATE'
         THEN
            v_date := 'b250.expiry_date';
         ELSIF UPPER (p_date_list) = 'ISSUE DATE'
         THEN
            v_date := 'b250.issue_date';
         END IF;
      END;

      v_subline := REPLACE(p_subline, '''','''''');

      BEGIN
         IF UPPER (p_print_group) = 'U'
         THEN
            v_print := ' AND b140.invoice_printed_date IS NULL';
         ELSIF UPPER (p_print_group) = 'P'
         THEN
            v_print := ' AND b140.invoice_printed_date IS NOT NULL';
         ELSIF UPPER (p_print_group) = 'B'
         THEN
            v_print := NULL;
         END IF;
      END;

      v_start_date := TRUNC (TO_DATE (p_start_date, 'MM-DD-YYYY'));
      v_end_date := TRUNC (TO_DATE (p_end_date, 'MM-DD-YYYY'));
      v_select :=
            'SELECT distinct b250.policy_id, b250.line_cd
                      FROM gipi_polbasic b250,gipi_parhist b240,gipi_invoice b140,
                           giri_inpolbas d070, giis_assured b230, giis_line b220, 
                           giis_subline b210, giis_issource b200,giis_reinsurer b260
                    WHERE b250.policy_id = b140.policy_id
                      AND b250.policy_id = d070.policy_id
                      AND b250.par_id = b240.par_id
                      AND b250.assd_no = b230.assd_no
                      AND d070.ri_cd   = b260.ri_cd
                      AND b250.line_cd = b220.line_cd
                      AND b250.subline_cd = b210.subline_cd
                      AND b250.iss_cd = b200.iss_cd
                      AND b250.iss_cd = DECODE (check_user_per_iss_cd2 (b250.line_cd,
                                                          b250.iss_cd,
                                                          ''GIPIS170'', '''
         || p_user_id
         || '''
                                                         ),
                                  1, b250.iss_cd,
                                  NULL
                                 )
                       AND b250.line_cd =
                          DECODE (check_user_per_line2 (b250.line_cd,
                                                        b250.iss_cd,
                                                       ''GIPIS170'', '''
         || p_user_id
         || '''
                                                       ),
                                  1, b250.line_cd,
                                  NULL
                                 )
                      AND b250.line_cd IN (SELECT distinct(line_cd) FROM giis_reports WHERE doc_type = '''
         || p_doc_list
         || ''')
                      AND (b230.assd_name = '''
         || p_assured
         || ''' OR '''
         || p_assured
         || ''' IS NULL) 
                      AND (b220.line_name = '''
         || p_line
         || ''' OR '''
         || p_line
         || ''' IS NULL)
                      AND (b260.ri_name = '''
         || p_cedant
         || ''' OR '''
         || p_cedant
         || ''' IS NULL) 
                      AND (b210.subline_name = '''
         || v_subline
         || ''' OR '''
         || v_subline
         || ''' IS NULL)
                      AND (b200.iss_name = '''
         || p_issue
         || ''' OR '''
         || p_issue
         || ''' IS NULL)
                      AND (b140.prem_seq_no BETWEEN '''
         || p_start_seq
         || ''' AND '''
         || p_end_seq
         || '''   
                       OR ('''
         || p_start_seq
         || ''' IS NULL AND b140.prem_seq_no < '''
         || p_end_seq
         || ''')
                       OR ('''
         || p_end_seq
         || ''' IS NULL AND b140.prem_seq_no > '''
         || p_start_seq
         || ''') 
                       OR ('''
         || p_start_seq
         || ''' IS NULL AND '''
         || p_end_seq
         || ''' IS NULL))
                      AND (TRUNC('
         || v_date
         || ') BETWEEN '''
         || v_start_date
         || ''' AND '''
         || v_end_date
         || '''
                     OR ('''
         || v_start_date
         || ''' IS NULL AND TRUNC('
         || v_date
         || ') < '''
         || v_end_date
         || ''')
                     OR ('''
         || v_end_date
         || ''' IS NULL AND TRUNC('
         || v_date
         || ') > '''
         || v_start_date
         || ''') 
                       OR ('''
         || v_start_date
         || ''' IS NULL AND '''
         || v_end_date
         || ''' IS NULL))'
         || v_print
         || '
                     AND b240.parstat_cd = ''10''
                     and b240.user_id = nvl('''
         || p_user
         || ''',b240.user_id)
                  ORDER BY b250.policy_id';

      OPEN c FOR v_select;

      LOOP
         FETCH c
          INTO v_ri.policy_id, v_ri.line_cd;

         BEGIN
            SELECT report_id
              INTO v_ri.report_id
              FROM giis_reports
             WHERE doc_type = p_doc_list AND ROWNUM = 1;
         END;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_ri);
      END LOOP;

      CLOSE c;
   END get_invoice_ri;

   FUNCTION get_bonds_renewal_pol_id (
      p_print_group   VARCHAR2,
      p_doc_list      giis_reports.doc_type%TYPE,
      p_assured       giis_assured.assd_name%TYPE,
      p_subline       giis_subline.subline_name%TYPE,
      p_issue         giis_issource.iss_name%TYPE,
      p_start_seq     gipi_polbasic.pol_seq_no%TYPE,
      p_end_seq       gipi_polbasic.pol_seq_no%TYPE,
      p_start_date    VARCHAR2,
      p_end_date      VARCHAR2,
      p_date_list     VARCHAR2,
      p_lc_su         VARCHAR2
   )
      RETURN get_bonds_renewal_pol_id_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      c              cur_typ;
      v_renew        get_bonds_renewal_pol_id_type;
      v_select       VARCHAR2 (5000);
      v_date         VARCHAR2 (200);
      v_print        VARCHAR2 (200);
      v_ri_pol       VARCHAR2 (10);
      v_start_date   VARCHAR2 (100);
      v_end_date     VARCHAR2 (100);
      v_subline        VARCHAR2 (500);
   BEGIN
      BEGIN
         IF UPPER (p_date_list) = 'INCEPTION DATE'
         THEN
            v_date := 'b250.incept_date';
         ELSIF UPPER (p_date_list) = 'EFFECTIVITY DATE'
         THEN
            v_date := 'b250.eff_date';
         ELSIF UPPER (p_date_list) = 'EXPIRY DATE'
         THEN
            v_date := 'b250.expiry_date';
         ELSIF UPPER (p_date_list) = 'ISSUE DATE'
         THEN
            v_date := 'b250.issue_date';
         END IF;
      END;

      v_subline := REPLACE(p_subline, '''','''''');

      BEGIN
         IF UPPER (p_print_group) = 'U'
         THEN
            v_print := ' AND b250.polendt_printed_date IS NULL';
         ELSIF UPPER (p_print_group) = 'P'
         THEN
            v_print := ' AND b250.polendt_printed_date IS NOT NULL';
         ELSIF UPPER (p_print_group) = 'B'
         THEN
            v_print := NULL;
         END IF;
      END;

      v_start_date := TRUNC (TO_DATE (p_start_date, 'MM-DD-YYYY'));
      v_end_date := TRUNC (TO_DATE (p_end_date, 'MM-DD-YYYY'));
      v_select :=
            'SELECT distinct policy_id,b250.line_cd
                    , b250.issue_yy, b250.iss_cd, b250.pol_seq_no    
                    , b250.renew_no, b250.subline_cd                
                      FROM gipi_polbasic b250, gipi_polnrep b240,
                           giis_assured b230, giis_line b220,
                           giis_subline b210, giis_issource b200
                    WHERE b250.policy_id = b240.new_policy_id 
                      AND b250.assd_no = b230.assd_no
                      AND b250.line_cd = '''
         || p_lc_su
         || '''
                      AND b250.subline_cd = b210.subline_cd
                      AND b250.iss_cd = b200.iss_cd
                      AND b250.pol_flag    = ''2''  
                      AND (b230.assd_name = '''
         || p_assured
         || '''  OR '''
         || p_assured
         || ''' IS NULL) 
                      AND (b210.subline_name = '''
         || v_subline
         || '''  OR  '''
         || v_subline
         || ''' IS NULL)
                      AND (b200.iss_name = '''
         || p_issue
         || '''  OR  '''
         || p_issue
         || ''' IS NULL)
                      AND (b250.pol_seq_no BETWEEN '''
         || p_start_seq
         || '''  AND '''
         || p_end_seq
         || '''
                       OR ('''
         || p_start_seq
         || ''' IS NULL AND b250.pol_seq_no < '''
         || p_end_seq
         || ''' )
                       OR ('''
         || p_end_seq
         || ''' IS NULL AND b250.pol_seq_no > '''
         || p_start_seq
         || ''') 
                       OR ('''
         || p_start_seq
         || ''' IS NULL AND '''
         || p_end_seq
         || ''' IS NULL))
                      AND (trunc('
         || v_date
         || ') BETWEEN '''
         || v_start_date
         || ''' AND '''
         || v_end_date
         || '''  
                     OR ('''
         || v_start_date
         || ''' IS NULL AND trunc('
         || v_date
         || ') < '''
         || v_end_date
         || ''' )
                     OR ('''
         || v_end_date
         || '''  IS NULL AND trunc('
         || v_date
         || ') > '''
         || v_start_date
         || ''') 
                       OR ('''
         || v_start_date
         || '''  IS NULL AND '''
         || v_end_date
         || '''  IS NULL))'
         || v_print
         || '  ORDER BY b250.policy_id';

      OPEN c FOR v_select;

      --update_pol_rec
      LOOP
         FETCH c
          INTO v_renew.policy_id, v_renew.line_cd, v_renew.issue_yy,
               v_renew.iss_cd, v_renew.pol_seq_no, v_renew.renew_no,
               v_renew.subline_cd;

         BEGIN
            SELECT report_id
              INTO v_renew.report_id
              FROM giis_reports
             WHERE line_cd = v_renew.line_cd
               AND doc_type = p_doc_list
               AND ROWNUM = 1;
         END;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_renew);
      END LOOP;

      CLOSE c;
   END get_bonds_renewal_pol_id;

   FUNCTION get_renewal_policy_id (
      p_print_group   VARCHAR2,
      p_doc_list      giis_reports.doc_type%TYPE,
      p_assured       giis_assured.assd_name%TYPE,
      p_line          giis_line.line_name%TYPE,
      p_subline       giis_subline.subline_name%TYPE,
      p_issue         giis_issource.iss_name%TYPE,
      p_start_seq     gipi_polbasic.pol_seq_no%TYPE,
      p_end_seq       gipi_polbasic.pol_seq_no%TYPE,
      p_start_date    VARCHAR2,
      p_end_date      VARCHAR2,
      p_date_list     VARCHAR2
   )
      RETURN get_renewal_policy_id_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      c              cur_typ;
      v_rnw_pol      get_renewal_policy_id_type;
      v_select       VARCHAR2 (5000);
      v_date         VARCHAR2 (200);
      v_print        VARCHAR2 (200);
      v_ri_pol       VARCHAR2 (10);
      v_start_date   VARCHAR2 (100);
      v_end_date     VARCHAR2 (100);
   BEGIN
      BEGIN
         IF UPPER (p_date_list) = 'INCEPTION DATE'
         THEN
            v_date := 'b250.incept_date';
         ELSIF UPPER (p_date_list) = 'EFFECTIVITY DATE'
         THEN
            v_date := 'b250.eff_date';
         ELSIF UPPER (p_date_list) = 'EXPIRY DATE'
         THEN
            v_date := 'b250.expiry_date';
         ELSIF UPPER (p_date_list) = 'ISSUE DATE'
         THEN
            v_date := 'b250.issue_date';
         END IF;
      END;

      BEGIN
         IF UPPER (p_print_group) = 'U'
         THEN
            v_print := ' AND b250.polendt_printed_date IS NULL';
         ELSIF UPPER (p_print_group) = 'P'
         THEN
            v_print := ' AND b250.polendt_printed_date IS NOT NULL';
         ELSIF UPPER (p_print_group) = 'B'
         THEN
            v_print := NULL;
         END IF;
      END;

      v_start_date := TRUNC (TO_DATE (p_start_date, 'MM-DD-YYYY'));
      v_end_date := TRUNC (TO_DATE (p_end_date, 'MM-DD-YYYY'));
      v_select :=
            'SELECT distinct policy_id, b250.line_cd, B250.ASSD_NO, b250.subline_cd, b240.par_id 
                      FROM gipi_polbasic b250, gipi_polnrep b240,
                           giis_assured b230, giis_line b220,
                           giis_subline b210, giis_issource b200
                    WHERE b250.policy_id = b240.new_policy_id
                      AND b250.assd_no = b230.assd_no
                      AND b250.line_cd = b220.line_cd
                      AND b250.subline_cd = b210.subline_cd
                      AND b250.iss_cd = b200.iss_cd
                      AND (b230.assd_name = '''
         || p_assured
         || ''' OR '''
         || p_assured
         || ''' IS NULL) 
                      AND (b220.line_name = '''
         || p_line
         || '''  OR  '''
         || p_line
         || ''' IS NULL)
                      AND (b210.subline_name = '''
         || p_subline
         || '''  OR  '''
         || p_subline
         || ''' IS NULL)
                      AND (b200.iss_name = '''
         || p_issue
         || ''' OR  '''
         || p_issue
         || ''' IS NULL)
                      AND (b250.pol_seq_no BETWEEN '''
         || p_start_seq
         || ''' AND '''
         || p_end_seq
         || '''    
                        OR ('''
         || p_start_seq
         || ''' IS NULL AND b250.pol_seq_no < '''
         || p_end_seq
         || '''    )
                        OR ('''
         || p_end_seq
         || '''    IS NULL AND b250.pol_seq_no > '''
         || p_start_seq
         || ''') 
                        OR ('''
         || p_start_seq
         || ''' IS NULL AND '''
         || p_end_seq
         || '''    IS NULL))
                      AND ((trunc('
         || v_date
         || ') BETWEEN '''
         || v_start_date
         || ''' AND '''
         || v_end_date
         || ''')                          
                      OR ('''
         || v_start_date
         || ''' IS NULL AND trunc('
         || v_date
         || ') < '''
         || v_end_date
         || ''')
                      OR ('''
         || v_end_date
         || ''' IS NULL AND trunc('
         || v_date
         || ') > '''
         || v_start_date
         || ''') 
                        OR ('''
         || v_start_date
         || ''' IS NULL AND '''
         || v_end_date
         || ''' IS NULL))'
         || v_print
         || ' ORDER BY b250.policy_id';

      OPEN c FOR v_select;

      --update_pol_rec
      LOOP
         FETCH c
          INTO v_rnw_pol.policy_id, v_rnw_pol.line_cd, v_rnw_pol.assd_no,
               v_rnw_pol.subline_cd, v_rnw_pol.par_id;

         BEGIN
            SELECT report_id
              INTO v_rnw_pol.report_id
              FROM giis_reports
             WHERE doc_type = p_doc_list AND ROWNUM = 1;
         END;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_rnw_pol);
      END LOOP;

      CLOSE c;
   END get_renewal_policy_id;

   FUNCTION get_bonds_policy_pol_id (
      p_print_group   VARCHAR2,
      p_doc_list      giis_reports.doc_type%TYPE,
      p_assured       giis_assured.assd_name%TYPE,
      p_subline       giis_subline.subline_name%TYPE,
      p_issue         giis_issource.iss_name%TYPE,
      p_start_seq     gipi_polbasic.pol_seq_no%TYPE,
      p_end_seq       gipi_polbasic.pol_seq_no%TYPE,
      p_start_date    VARCHAR2,
      p_end_date      VARCHAR2,
      p_date_list     VARCHAR2,
      p_p_ri          VARCHAR2,
      p_lc_su         VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN get_bonds_policy_pol_id_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      c              cur_typ;
      v_bond         get_bonds_policy_pol_id_type;
      v_select       VARCHAR2 (5000);
      v_date         VARCHAR2 (200);
      v_print        VARCHAR2 (200);
      v_ri_pol       VARCHAR2 (10);
      v_start_date   VARCHAR2 (100);
      v_end_date     VARCHAR2 (100);
   BEGIN
      BEGIN
         IF UPPER (p_date_list) = 'INCEPTION DATE'
         THEN
            v_date := 'b250.incept_date';
         ELSIF UPPER (p_date_list) = 'EFFECTIVITY DATE'
         THEN
            v_date := 'b250.eff_date';
         ELSIF UPPER (p_date_list) = 'EXPIRY DATE'
         THEN
            v_date := 'b250.expiry_date';
         ELSIF UPPER (p_date_list) = 'ISSUE DATE'
         THEN
            v_date := 'b250.issue_date';
         END IF;
      END;

      BEGIN
         IF UPPER (p_print_group) = 'U'
         THEN
            v_print := ' AND b250.polendt_printed_date IS NULL';
         ELSIF UPPER (p_print_group) = 'P'
         THEN
            v_print := ' AND b250.polendt_printed_date IS NOT NULL';
         ELSIF UPPER (p_print_group) = 'B'
         THEN
            v_print := NULL;
         END IF;
      END;

      v_start_date := TRUNC (TO_DATE (p_start_date, 'MM-DD-YYYY'));
      v_end_date := TRUNC (TO_DATE (p_end_date, 'MM-DD-YYYY'));
      v_select :=
            'SELECT distinct policy_id, b250.par_id, b240.par_type, b250.line_cd, b250.iss_cd, b250.subline_cd 
                      FROM gipi_polbasic b250, gipi_parlist b240,
                           giis_assured b230, giis_line b220,
                           giis_subline b210, giis_issource b200
                    WHERE b250.par_id = b240.par_id
                      AND b250.iss_cd != '''
         || p_p_ri
         || '''
                      AND b250.endt_seq_no = 0
                      AND b240.assd_no = b230.assd_no
                      AND b250.line_cd = '''
         || p_lc_su
         || '''
                      AND b250.subline_cd = b210.subline_cd
                      AND b250.iss_cd = b200.iss_cd
                       AND b250.iss_cd = DECODE (check_user_per_iss_cd2 (b250.line_cd,
                                                          b250.iss_cd,
                                                          ''GIPIS170'', '''
         || p_user_id
         || '''
                                                         ),
                                  1, b250.iss_cd,
                                  NULL
                                 )
                       AND b250.line_cd =
                          DECODE (check_user_per_line2 (b250.line_cd,
                                                        b250.iss_cd,
                                                       ''GIPIS170'', '''
         || p_user_id
         || '''
                                                       ),
                                  1, b250.line_cd,
                                  NULL
                                 )
                      AND (b230.assd_name = '''
         || p_assured
         || '''  OR '''
         || p_assured
         || ''' IS NULL) 
                      AND (b210.subline_name = '''
         || p_subline
         || '''  OR  '''
         || p_subline
         || ''' IS NULL)
                      AND (b200.iss_name = '''
         || p_issue
         || '''  OR '''
         || p_issue
         || ''' IS NULL)
                      AND (b250.pol_seq_no BETWEEN '''
         || p_start_seq
         || ''' AND '''
         || p_end_seq
         || ''' 
                       OR ('''
         || p_start_seq
         || ''' IS NULL AND b250.pol_seq_no < '''
         || p_end_seq
         || ''' )
                       OR ('''
         || p_end_seq
         || ''' IS NULL AND b250.pol_seq_no > '''
         || p_start_seq
         || ''') 
                       OR ('''
         || p_start_seq
         || ''' IS NULL AND '''
         || p_end_seq
         || ''' IS NULL))
                      AND (trunc('
         || v_date
         || ') BETWEEN '''
         || v_start_date
         || ''' AND '''
         || v_end_date
         || '''   
                     OR ('''
         || v_start_date
         || ''' IS NULL AND trunc('
         || v_date
         || ') < '''
         || v_end_date
         || ''')
                     OR ('''
         || v_end_date
         || ''' IS NULL AND trunc('
         || v_date
         || ') > '''
         || v_start_date
         || ''') 
                       OR ('''
         || v_start_date
         || ''' IS NULL AND '''
         || p_end_date
         || ''' IS NULL))'
         || v_print
         || ' ORDER BY b250.policy_id';

      OPEN c FOR v_select;

      LOOP
         FETCH c
          INTO v_bond.policy_id, v_bond.par_id, v_bond.par_type,
               v_bond.line_cd, v_bond.iss_cd, v_bond.subline_cd;

         BEGIN
            SELECT report_id
              INTO v_bond.report_id
              FROM giis_reports
             WHERE report_id = 'BONDS'
               AND line_cd = v_bond.line_cd
               AND ROWNUM = 1;
         END;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_bond);
      END LOOP;

      CLOSE c;
   END get_bonds_policy_pol_id;

   PROCEDURE delete_extract_tables (p_extract_id NUMBER)
   IS
   BEGIN
      IF p_extract_id IS NOT NULL
      THEN
         DELETE      gixx_accident_item
               WHERE extract_id = p_extract_id;

         DELETE      gixx_aviation_item
               WHERE extract_id = p_extract_id;

         DELETE      gixx_bank_schedule
               WHERE extract_id = p_extract_id;

         DELETE      gixx_beneficiary
               WHERE extract_id = p_extract_id;

         DELETE      gixx_cargo
               WHERE extract_id = p_extract_id;

         DELETE      gixx_cargo_carrier
               WHERE extract_id = p_extract_id;

         DELETE      gixx_casualty_item
               WHERE extract_id = p_extract_id;

         DELETE      gixx_casualty_personnel
               WHERE extract_id = p_extract_id;

         DELETE      gixx_comm_invoice
               WHERE extract_id = p_extract_id;

         DELETE      gixx_comm_inv_peril
               WHERE extract_id = p_extract_id;

         DELETE      gixx_cosigntry
               WHERE extract_id = p_extract_id;

         DELETE      gixx_co_insurer
               WHERE extract_id = p_extract_id;

         DELETE      gixx_deductibles
               WHERE extract_id = p_extract_id;

         DELETE      gixx_endttext
               WHERE extract_id = p_extract_id;

         DELETE      gixx_engg_basic
               WHERE extract_id = p_extract_id;

         DELETE      gixx_fireitem
               WHERE extract_id = p_extract_id;

         DELETE      gixx_grouped_items
               WHERE extract_id = p_extract_id;

         DELETE      gixx_grp_items_beneficiary
               WHERE extract_id = p_extract_id;

         DELETE      gixx_invoice
               WHERE extract_id = p_extract_id;

         DELETE      gixx_invperil
               WHERE extract_id = p_extract_id;

         DELETE      gixx_inv_tax
               WHERE extract_id = p_extract_id;

         DELETE      gixx_item_ves
               WHERE extract_id = p_extract_id;

         DELETE      gixx_itmperil
               WHERE extract_id = p_extract_id;

         DELETE      gixx_lim_liab
               WHERE extract_id = p_extract_id;

         DELETE      gixx_location
               WHERE extract_id = p_extract_id;

         DELETE      gixx_main_co_ins
               WHERE extract_id = p_extract_id;

         DELETE      gixx_mcacc
               WHERE extract_id = p_extract_id;

         DELETE      gixx_mortgagee
               WHERE extract_id = p_extract_id;

         DELETE      gixx_open_cargo
               WHERE extract_id = p_extract_id;

         DELETE      gixx_open_liab
               WHERE extract_id = p_extract_id;

         DELETE      gixx_open_peril
               WHERE extract_id = p_extract_id;

         DELETE      gixx_open_policy
               WHERE extract_id = p_extract_id;

         DELETE      gixx_orig_comm_invoice
               WHERE extract_id = p_extract_id;

         DELETE      gixx_orig_comm_inv_peril
               WHERE extract_id = p_extract_id;

         DELETE      gixx_orig_invoice
               WHERE extract_id = p_extract_id;

         DELETE      gixx_orig_invperl
               WHERE extract_id = p_extract_id;

         DELETE      gixx_orig_inv_tax
               WHERE extract_id = p_extract_id;

         DELETE      gixx_orig_itmperil
               WHERE extract_id = p_extract_id;

         DELETE      gixx_parlist
               WHERE extract_id = p_extract_id;

         DELETE      gixx_polbasic
               WHERE extract_id = p_extract_id;

         DELETE      gixx_polgenin
               WHERE extract_id = p_extract_id;

         DELETE      gixx_polnrep
               WHERE extract_id = p_extract_id;

         DELETE      gixx_polwc
               WHERE extract_id = p_extract_id;

         DELETE      gixx_principal
               WHERE extract_id = p_extract_id;

         DELETE      gixx_vehicle
               WHERE extract_id = p_extract_id;

         DELETE      gixx_ves_air
               WHERE extract_id = p_extract_id;

         DELETE      gixx_pack_invperl
               WHERE extract_id = p_extract_id;

         DELETE      gixx_pack_invoice
               WHERE extract_id = p_extract_id;

         DELETE      gixx_pack_inv_tax
               WHERE extract_id = p_extract_id;

         DELETE      gixx_pack_line_subline
               WHERE extract_id = p_extract_id;

         DELETE      gixx_pack_parhist
               WHERE extract_id = p_extract_id;

         DELETE      gixx_pack_parlist
               WHERE extract_id = p_extract_id;

         DELETE      gixx_pack_polbasic
               WHERE extract_id = p_extract_id;

         DELETE      gixx_pack_polgenin
               WHERE extract_id = p_extract_id;

         DELETE      gixx_pack_polnrep
               WHERE extract_id = p_extract_id;

         DELETE      gixx_pack_polwc
               WHERE extract_id = p_extract_id;
      END IF;
   END delete_extract_tables;

   PROCEDURE update_pol_rec (p_policy_id gipi_polbasic.policy_id%TYPE)
   IS
      v_pol_print_cnt   NUMBER;
   BEGIN
      UPDATE gipi_polbasic
         SET polendt_printed_date = SYSDATE,
             polendt_printed_cnt = NVL (polendt_printed_cnt, 0) + 1
       WHERE policy_id = p_policy_id;
   END update_pol_rec;

   PROCEDURE update_binder (p_binder_id giri_binder.fnl_binder_id%TYPE)
   AS
   BEGIN
      UPDATE giri_binder
         SET bndr_print_date = SYSDATE,
             bndr_printed_cnt = NVL (bndr_printed_cnt, 0) + 1
       WHERE fnl_binder_id = p_binder_id;
   END update_binder;

   PROCEDURE update_frps (p_binder_id giri_binder.fnl_binder_id%TYPE)
   AS
   BEGIN
      UPDATE giri_frps_ri
         SET bndr_printed_cnt = NVL (bndr_printed_cnt, 0) + 1
       WHERE fnl_binder_id = p_binder_id;
   END update_frps;

   PROCEDURE update_gipi_quote (p_quote_id gipi_quote.quote_id%TYPE)
   AS
   BEGIN
      UPDATE gipi_quote
         SET print_dt = SYSDATE,
             quotation_printed_cnt = NVL (quotation_printed_cnt, 0) + 1
       WHERE quote_id = p_quote_id;
   END update_gipi_quote;

   PROCEDURE update_wpolbas (p_par_id gipi_wpolbas.par_id%TYPE)
   AS
   BEGIN
      UPDATE gipi_wpolbas
         SET cover_nt_printed_date = SYSDATE,
             cover_nt_printed_cnt = NVL (cover_nt_printed_cnt, 0) + 1
       WHERE par_id = p_par_id;
   END update_wpolbas;

   PROCEDURE update_item (p_policy_id gipi_item.policy_id%TYPE)
   AS
   BEGIN
      UPDATE gipi_item
         SET mc_coc_printed_date = SYSDATE,
             mc_coc_printed_cnt = NVL (mc_coc_printed_cnt, 0) + 1
       WHERE policy_id = p_policy_id;
   END update_item;

   PROCEDURE update_invoice (p_policy_id gipi_invoice.policy_id%TYPE)
   AS
   BEGIN
      UPDATE gipi_invoice
         SET invoice_printed_date = SYSDATE,
             invoice_printed_cnt = NVL (invoice_printed_cnt, 0) + 1
       WHERE policy_id = p_policy_id;
   END update_invoice;
END GIPIS170_PKG;
/


