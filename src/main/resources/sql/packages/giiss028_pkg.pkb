CREATE OR REPLACE PACKAGE BODY CPI.GIISS028_PKG
AS
   FUNCTION get_iss_list (
      p_user_id     giis_users.user_id%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_line_cd     giis_line.line_cd%TYPE
   )
      RETURN iss_tab PIPELINED
   IS
      v_rec   iss_type;
   BEGIN
      FOR i IN (SELECT   iss_cd, iss_name
                    FROM giis_issource
                   WHERE check_user_per_iss_cd2 (NULL,
                                                 iss_cd,
                                                 p_module_id,
                                                 p_user_id
                                                ) = 1
                ORDER BY iss_cd ASC)
      LOOP
         v_rec.iss_cd := i.iss_cd;
         v_rec.iss_name := i.iss_name;

         BEGIN
            SELECT param_value_v fund_cd
              INTO v_rec.fund_cd
              FROM giac_parameters
             WHERE param_name = 'FUND_CD';
         END;

         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_iss_list;

   FUNCTION get_line_list (
      p_user_id     giis_users.user_id%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_iss_cd      giis_issource.iss_cd%TYPE
   )
      RETURN line_tab PIPELINED
   IS
      v_rec   line_type;
   BEGIN
      FOR i IN (SELECT   a.line_cd, a.line_name, b.iss_cd, b.iss_name
                    FROM giis_issource b, giis_line a
                   WHERE check_user_per_line2 (a.line_cd,
                                               p_iss_cd,
                                               p_module_id,
                                               p_user_id
                                              ) = 1
                     AND b.iss_cd = p_iss_cd
                ORDER BY line_cd)
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.line_name := i.line_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_line_list;

   FUNCTION get_tax_list (p_fund_cd VARCHAR2)
      RETURN tax_tab PIPELINED
   IS
      v_rec   tax_type;
   BEGIN
      FOR i IN (SELECT tax_cd, tax_name, tax_type
                  FROM giac_taxes
                 WHERE fund_cd = p_fund_cd
                   AND NVL(intrty_sw, 'N') != 'Y') --benjo 08.03.2016 SR-5512
      LOOP
         v_rec.tax_cd := i.tax_cd;
         v_rec.tax_name := i.tax_name;
         v_rec.tax_type := i.tax_type;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_tax_list;

   FUNCTION get_peril_list (
      p_iss_cd    giis_issource.iss_cd%TYPE,
      p_line_cd   giis_line.line_cd%TYPE,
      p_tax_cd    giis_tax_peril.tax_cd%TYPE,
      p_tax_id    giis_tax_peril.tax_id%TYPE
   )
      RETURN peril_tab PIPELINED
   IS
      v_rec   peril_type;
   BEGIN
      FOR i IN (SELECT   peril_cd, peril_name, line_cd, subline_cd
                    FROM giis_peril
                   WHERE line_cd = p_line_cd
--                     AND peril_cd NOT IN (
--                            SELECT peril_cd
--                              FROM giis_tax_peril
--                             WHERE iss_cd = p_iss_cd
--                               AND line_cd = p_line_cd
--                               AND tax_cd = p_tax_cd
--                               AND tax_id = p_tax_id)
                ORDER BY peril_cd)
      LOOP
         v_rec.peril_cd := i.peril_cd;
         v_rec.peril_name := i.peril_name;
         v_rec.line_cd := i.line_cd;
         v_rec.subline_cd := i.subline_cd;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_peril_list;

   FUNCTION get_place_list (
      p_iss_cd    giis_issource.iss_cd%TYPE,
      p_line_cd   giis_line.line_cd%TYPE,
      p_tax_cd    giis_tax_peril.tax_cd%TYPE,
      p_tax_id    giis_tax_peril.tax_id%TYPE
   )
      RETURN place_tab PIPELINED
   IS
      v_rec   place_type;
   BEGIN
      FOR i IN (SELECT place_cd, place
                  FROM giis_issource_place
                 WHERE iss_cd = p_iss_cd
--                   AND place_cd NOT IN (
--                          SELECT place_cd
--                            FROM giis_tax_issue_place
--                           WHERE iss_cd = p_iss_cd
--                             AND line_cd = p_line_cd
--                             AND tax_cd = p_tax_cd
--                             AND tax_id = p_tax_id)
                             )
      LOOP
         v_rec.place_cd := i.place_cd;
         v_rec.place := i.place;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_place_list;

   FUNCTION get_tax_charges_list (
      p_iss_cd    giis_issource.iss_cd%TYPE,
      p_line_cd   giis_line.line_cd%TYPE
   )
      RETURN tax_charges_tab PIPELINED
   IS
      v_rec   tax_charges_type;
   BEGIN
      FOR i IN (SELECT   iss_cd, line_cd, tax_cd, tax_desc, function_name,
                         SEQUENCE, rate, tax_amount, eff_start_date,
                         eff_end_date, dr_gl_cd, cr_gl_cd, dr_sub1, cr_sub1,
                         tax_type, no_rate_tag, include_tag, incept_sw,
                         primary_sw, expired_sw, peril_sw, pol_endt_sw,
                         takeup_alloc_tag, tax_id, allocation_tag, remarks,
                         user_id, last_update, issue_date_tag, coc_charge, refund_sw --added by robert GENQA 4844 08.10.15
                    FROM giis_tax_charges
                   WHERE iss_cd = p_iss_cd AND line_cd = p_line_cd
                ORDER BY tax_cd)
      LOOP
         v_rec.iss_cd := i.iss_cd;
         v_rec.line_cd := i.line_cd;
         v_rec.tax_cd := i.tax_cd;
         v_rec.tax_desc := i.tax_desc;
         v_rec.function_name := i.function_name;
         v_rec.SEQUENCE := i.SEQUENCE;
         v_rec.rate := i.rate;
         v_rec.tax_amount := i.tax_amount;
         v_rec.eff_start_date := TO_CHAR (i.eff_start_date, 'MM-DD-YYYY');
         v_rec.eff_end_date := TO_CHAR (i.eff_end_date, 'MM-DD-YYYY');
         v_rec.dr_gl_cd := i.dr_gl_cd;
         v_rec.cr_gl_cd := i.cr_gl_cd;
         v_rec.dr_sub1 := i.dr_sub1;
         v_rec.cr_sub1 := i.cr_sub1;
         v_rec.tax_type := i.tax_type;
         v_rec.no_rate_tag := i.no_rate_tag;
         v_rec.include_tag := i.include_tag;
         v_rec.incept_sw := i.incept_sw;
         v_rec.primary_sw := i.primary_sw;
         v_rec.expired_sw := i.expired_sw;
         v_rec.peril_sw := i.peril_sw;
         v_rec.pol_endt_sw := i.pol_endt_sw;
         v_rec.takeup_alloc_tag := i.takeup_alloc_tag;
         v_rec.tax_id := i.tax_id;
         v_rec.allocation_tag := i.allocation_tag;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_rec.issue_date_tag := i.issue_date_tag;
         v_rec.coc_charge := i.coc_charge;
		 v_rec.refund_sw := i.refund_sw; --added by robert GENQA 4844 08.10.15
          BEGIN
            SELECT MAX (c.SEQUENCE) + 1 SEQUENCE
              INTO v_rec.max_sequence
              FROM giis_tax_charges c
             WHERE c.line_cd = p_line_cd AND c.iss_cd = p_iss_cd;
          EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                v_rec.max_sequence := 1;
          END;         

         BEGIN
            SELECT 'Y'
              INTO v_rec.v_exists
              FROM gipi_inv_tax
             WHERE iss_cd = p_iss_cd
               AND line_cd = p_line_cd
               AND tax_cd = v_rec.tax_cd
               AND tax_id = v_rec.tax_id
               AND ROWNUM = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.v_exists := 'N';
         END;

         BEGIN
            SELECT 'Y'
              INTO v_rec.v_exists
              FROM gipi_winv_tax
             WHERE iss_cd = p_iss_cd
               AND line_cd = p_line_cd
               AND tax_cd = v_rec.tax_cd
               AND tax_id = v_rec.tax_id
               AND ROWNUM = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.v_exists := 'N';
         END;

         BEGIN
            SELECT 'Y'
              INTO v_rec.v_exists
              FROM gipi_quote_invtax
             WHERE iss_cd = p_iss_cd
               AND line_cd = p_line_cd
               AND tax_cd = v_rec.tax_cd
               AND tax_id = v_rec.tax_id
               AND ROWNUM = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.v_exists := 'N';
         END;

         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_tax_charges_list;

   FUNCTION get_tax_peril_list (
      p_iss_cd    giis_issource.iss_cd%TYPE,
      p_line_cd   giis_line.line_cd%TYPE,
      p_tax_cd    giis_tax_peril.tax_cd%TYPE,
      p_tax_id    giis_tax_peril.tax_id%TYPE
   )
      RETURN tax_peril_tab PIPELINED
   IS
      v_rec   tax_peril_type;
      v_not_in  VARCHAR2(2000);
   BEGIN
      FOR x IN (SELECT peril_cd
                  FROM giis_tax_peril
                 WHERE iss_cd = p_iss_cd 
                   AND line_cd = p_line_cd 
                   AND tax_cd = p_tax_cd 
                   AND tax_id = p_tax_id)
      LOOP
         IF v_not_in IS NOT NULL
         THEN
            v_not_in := v_not_in || ',';
         END IF;

         v_not_in := v_not_in || x.peril_cd;
      END LOOP;
      
      FOR i IN (SELECT *
                  FROM giis_tax_peril
                 WHERE iss_cd = p_iss_cd
                   AND line_cd = p_line_cd
                   AND tax_cd = p_tax_cd
                   AND tax_id = p_tax_id)
      LOOP
         v_rec.not_in := v_not_in;
         v_rec.iss_cd := i.iss_cd;
         v_rec.line_cd := i.line_cd;
         v_rec.tax_cd := i.tax_cd;
         v_rec.tax_id := i.tax_id;
         v_rec.peril_sw := i.peril_sw;
         v_rec.peril_cd := i.peril_cd;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');

         FOR perl IN (SELECT peril_name
                        FROM giis_peril
                       WHERE peril_cd = i.peril_cd 
                         AND line_cd = p_line_cd
                    ORDER BY peril_name)
         LOOP
            v_rec.peril_name := perl.peril_name;
         END LOOP;

         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_tax_peril_list;

   FUNCTION get_tax_issue_place_list (
      p_iss_cd    giis_issource.iss_cd%TYPE,
      p_line_cd   giis_line.line_cd%TYPE,
      p_tax_cd    giis_tax_peril.tax_cd%TYPE,
      p_tax_id    giis_tax_peril.tax_id%TYPE
   )
      RETURN tax_issue_place_tab PIPELINED
   IS
      v_rec     tax_issue_place_type;
      v_not_in  VARCHAR2(2000);
   BEGIN
      FOR x IN (SELECT place
                  FROM giis_issource_place
                 WHERE (place_cd, iss_cd) IN (SELECT place_cd, iss_cd
                                                FROM giis_tax_issue_place
                                               WHERE iss_cd = p_iss_cd 
                                                 AND line_cd = p_line_cd 
                                                 AND tax_cd = p_tax_cd 
                                                 AND tax_id = p_tax_id))
      LOOP
         IF v_not_in IS NOT NULL
         THEN
            v_not_in := v_not_in || ',';
         END IF;

         v_not_in := v_not_in || '''' || x.place || '''';
      END LOOP;
         
      FOR i IN (SELECT *
                  FROM giis_tax_issue_place
                 WHERE iss_cd = p_iss_cd
                   AND line_cd = p_line_cd
                   AND tax_cd = p_tax_cd
                   AND tax_id = p_tax_id)
      LOOP
         v_rec.not_in := v_not_in;
         v_rec.iss_cd := i.iss_cd;
         v_rec.line_cd := i.line_cd;
         v_rec.tax_cd := i.tax_cd;
         v_rec.tax_id := i.tax_id;
         v_rec.place_cd := i.place_cd;
         v_rec.rate := i.rate;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');

         SELECT place
           INTO v_rec.place
           FROM giis_issource_place
          WHERE place_cd = i.place_cd AND iss_cd = i.iss_cd;
        
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_tax_issue_place_list;

   FUNCTION get_tax_range_list (
      p_iss_cd    giis_issource.iss_cd%TYPE,
      p_line_cd   giis_line.line_cd%TYPE,
      p_tax_cd    giis_tax_peril.tax_cd%TYPE,
      p_tax_id    giis_tax_peril.tax_id%TYPE
   )
      RETURN tax_range_tab PIPELINED
   IS
      v_rec   tax_range_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM giis_tax_range
                 WHERE iss_cd = p_iss_cd
                   AND line_cd = p_line_cd
                   AND tax_cd = p_tax_cd
                   AND tax_id = p_tax_id)
      LOOP
         BEGIN
            SELECT COUNT (iss_cd) rec_count, MIN (min_value), MAX (max_value)
              INTO v_rec.rec_count, v_rec.min_min_value, v_rec.max_max_value
              FROM giis_tax_range
             WHERE iss_cd = p_iss_cd
               AND line_cd = p_line_cd
               AND tax_cd = p_tax_cd
               AND tax_id = p_tax_id;
         END;

         v_rec.iss_cd := i.iss_cd;
         v_rec.line_cd := i.line_cd;
         v_rec.tax_cd := i.tax_cd;
         v_rec.tax_id := i.tax_id;
         v_rec.min_value := i.min_value;
         v_rec.max_value := i.max_value;
         v_rec.tax_amount := i.tax_amount;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                             TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_tax_range_list;

   PROCEDURE set_rec (p_rec giis_tax_charges%ROWTYPE)
   IS
      v_tax_id   NUMBER (7);
   BEGIN
      BEGIN
         SELECT MAX (c.tax_id) + 1 tax_id
           INTO v_tax_id
           FROM giis_tax_charges c
          WHERE iss_cd = p_rec.iss_cd
            AND line_cd = p_rec.line_cd
            AND tax_cd = p_rec.tax_cd;
      END;

      MERGE INTO giis_tax_charges
         USING DUAL
         ON (    iss_cd = p_rec.iss_cd
             AND line_cd = p_rec.line_cd
             AND tax_cd = p_rec.tax_cd
             AND tax_id = p_rec.tax_id)
         WHEN NOT MATCHED THEN
            INSERT (iss_cd, line_cd, tax_cd, tax_desc, function_name,
                    SEQUENCE, rate, tax_amount, eff_start_date, eff_end_date,
                    dr_gl_cd, cr_gl_cd, dr_sub1, cr_sub1, tax_type,
                    no_rate_tag, include_tag, incept_sw, primary_sw,
                    expired_sw, peril_sw, pol_endt_sw, takeup_alloc_tag,
                    tax_id, allocation_tag, remarks, user_id, last_update,
                    issue_date_tag, coc_charge, refund_sw) --added by robert GENQA 4844 08.10.15
            VALUES (p_rec.iss_cd, p_rec.line_cd, p_rec.tax_cd, p_rec.tax_desc,
                    p_rec.function_name, p_rec.SEQUENCE, p_rec.rate,
                    p_rec.tax_amount, p_rec.eff_start_date,
                    p_rec.eff_end_date, p_rec.dr_gl_cd, p_rec.cr_gl_cd,
                    p_rec.dr_sub1, p_rec.cr_sub1, p_rec.tax_type,
                    p_rec.no_rate_tag, p_rec.include_tag, p_rec.incept_sw,
                    p_rec.primary_sw, p_rec.expired_sw, p_rec.peril_sw,
                    p_rec.pol_endt_sw, p_rec.takeup_alloc_tag,
                    NVL (v_tax_id, 1), p_rec.allocation_tag, p_rec.remarks,
                    p_rec.user_id, SYSDATE, p_rec.issue_date_tag,
                    p_rec.coc_charge, p_rec.refund_sw) --added by robert GENQA 4844 08.10.15
         WHEN MATCHED THEN
            UPDATE
               SET function_name = p_rec.function_name,
                   SEQUENCE = p_rec.SEQUENCE, rate = p_rec.rate,
                   tax_amount = p_rec.tax_amount,
                   eff_start_date = p_rec.eff_start_date,
                   eff_end_date = p_rec.eff_end_date,
                   dr_gl_cd = p_rec.dr_gl_cd, cr_gl_cd = p_rec.cr_gl_cd,
                   dr_sub1 = p_rec.dr_sub1, cr_sub1 = p_rec.cr_sub1,
                   tax_type = p_rec.tax_type, no_rate_tag = p_rec.no_rate_tag,
                   include_tag = p_rec.include_tag,
                   incept_sw = p_rec.incept_sw, primary_sw = p_rec.primary_sw,
                   expired_sw = p_rec.expired_sw, peril_sw = p_rec.peril_sw,
                   pol_endt_sw = p_rec.pol_endt_sw,
                   takeup_alloc_tag = p_rec.takeup_alloc_tag,
                   allocation_tag = p_rec.allocation_tag,
                   remarks = p_rec.remarks, user_id = p_rec.user_id,
                   last_update = SYSDATE,
                   issue_date_tag = p_rec.issue_date_tag,
                   coc_charge = p_rec.coc_charge,
				   refund_sw = p_rec.refund_sw --added by robert GENQA 4844 08.10.15
            ;
   END;

   PROCEDURE del_rec (
      p_iss_cd    giis_issource.iss_cd%TYPE,
      p_line_cd   giis_line.line_cd%TYPE,
      p_tax_cd    giis_tax_peril.tax_cd%TYPE,
      p_tax_id    giis_tax_peril.tax_id%TYPE
   )
   AS
   BEGIN
      DELETE FROM giis_tax_charges
            WHERE iss_cd = p_iss_cd
              AND line_cd = p_line_cd
              AND tax_cd = p_tax_cd
              AND tax_id = p_tax_id;
   END;

   PROCEDURE val_del_rec (
      p_iss_cd    giis_issource.iss_cd%TYPE,
      p_line_cd   giis_line.line_cd%TYPE,
      p_tax_cd    giis_tax_peril.tax_cd%TYPE,
      p_tax_id    giis_tax_peril.tax_id%TYPE
   )
   AS
      v_select   VARCHAR2 (500);
      v_out      VARCHAR2 (50);
   BEGIN

      FOR i IN (SELECT table_name
                  FROM all_constraints
                 WHERE r_constraint_name IN (SELECT constraint_name
                                               FROM all_constraints
                                              WHERE table_name = 'GIIS_TAX_CHARGES'))
       LOOP
          v_select :=
                'SELECT DISTINCT '''
                || i.table_name
                || ''' FROM '
                || i.table_name
                || ' WHERE ISS_CD = '''
                || p_iss_cd
                || ''' AND LINE_CD = '''
                || p_line_cd
                || ''' AND TAX_CD = '
                || p_tax_cd
                || ' AND TAX_ID = '
                || p_tax_id;

          BEGIN
             EXECUTE IMMEDIATE v_select
                          INTO v_out;

             EXIT;
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                v_out := '';
          END;
       END LOOP;  
               
       IF v_out IS NOT NULL
       THEN
          raise_application_error
             (-20001,
                 'Geniisys Exception#E#Cannot delete record from GIIS_TAX_CHARGES while dependent record(s) in '
              || UPPER(v_out)
              || ' exists.'
             );
       END IF;
   END;

   PROCEDURE set_tax_peril_rec (p_rec giis_tax_peril%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_tax_peril
         USING DUAL
         ON (    iss_cd = p_rec.iss_cd
             AND line_cd = p_rec.line_cd
             AND tax_cd = p_rec.tax_cd
             AND tax_id = p_rec.tax_id
             AND peril_cd = p_rec.peril_cd)
         WHEN NOT MATCHED THEN
            INSERT (iss_cd, line_cd, tax_cd, peril_cd, peril_sw, tax_id,
                    user_id, last_update)
            VALUES (p_rec.iss_cd, p_rec.line_cd, p_rec.tax_cd, p_rec.peril_cd,
                    'N', p_rec.tax_id, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET peril_sw = 'N', user_id = p_rec.user_id,
                   last_update = SYSDATE
            ;
   END;

   PROCEDURE del_tax_peril_rec (
      p_iss_cd     giis_issource.iss_cd%TYPE,
      p_line_cd    giis_line.line_cd%TYPE,
      p_tax_cd     giis_tax_peril.tax_cd%TYPE,
      p_tax_id     giis_tax_peril.tax_id%TYPE,
      p_peril_cd   giis_peril.peril_cd%TYPE
   )
   AS
   BEGIN
      DELETE FROM giis_tax_peril
            WHERE iss_cd = p_iss_cd
              AND line_cd = p_line_cd
              AND tax_cd = p_tax_cd
              AND tax_id = p_tax_id
              AND peril_cd = p_peril_cd;
   END;

   PROCEDURE set_tax_place_rec (p_rec giis_tax_issue_place%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_tax_issue_place
         USING DUAL
         ON (    iss_cd = p_rec.iss_cd
             AND line_cd = p_rec.line_cd
             AND tax_cd = p_rec.tax_cd
             AND tax_id = p_rec.tax_id
             AND place_cd = p_rec.place_cd)
         WHEN NOT MATCHED THEN
            INSERT (iss_cd, line_cd, tax_cd, place_cd, rate, tax_id, user_id,
                    last_update)
            VALUES (p_rec.iss_cd, p_rec.line_cd, p_rec.tax_cd, p_rec.place_cd,
                    p_rec.rate, p_rec.tax_id, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET rate = p_rec.rate, user_id = p_rec.user_id,
                   last_update = SYSDATE
            ;
   END;

   PROCEDURE del_tax_place_rec (
      p_iss_cd     giis_issource.iss_cd%TYPE,
      p_line_cd    giis_line.line_cd%TYPE,
      p_tax_cd     giis_tax_peril.tax_cd%TYPE,
      p_tax_id     giis_tax_peril.tax_id%TYPE,
      p_place_cd   giis_tax_issue_place.place_cd%TYPE
   )
   AS
   BEGIN
      DELETE FROM giis_tax_issue_place
            WHERE iss_cd = p_iss_cd
              AND line_cd = p_line_cd
              AND tax_cd = p_tax_cd
              AND tax_id = p_tax_id
              AND place_cd = p_place_cd;
   END;

   PROCEDURE val_del_place_rec (
      p_iss_cd     giis_issource.iss_cd%TYPE,
      p_line_cd    giis_line.line_cd%TYPE,
      p_place_cd   giis_tax_issue_place.place_cd%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR b IN (SELECT 1
                  FROM gipi_wpolbas
                 WHERE place_cd = p_place_cd
                   AND line_cd = p_line_cd
                   AND iss_cd = p_iss_cd)
      LOOP
         v_exists := 'Y';
      END LOOP;
      
      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_TAX_ISSUE_PLACE while dependent record(s) in GIPI_WPOLBAS exists.'
            );
      ELSE
          FOR c IN (SELECT 1
                      FROM gipi_polbasic
                     WHERE place_cd = p_place_cd
                       AND line_cd = p_line_cd
                       AND iss_cd = p_iss_cd)
          LOOP
             v_exists := 'Y';
             EXIT;
          END LOOP;

          IF v_exists = 'Y'
          THEN
             raise_application_error
                (-20001,
                 'Geniisys Exception#E#Cannot delete record from GIIS_TAX_ISSUE_PLACE while dependent record(s) in GIPI_POLBASIC exists.'
                );
          END IF;      
      END IF;
   END;

   PROCEDURE set_tax_range_rec (p_rec giis_tax_range%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_tax_range
         USING DUAL
         ON (    iss_cd = p_rec.iss_cd
             AND line_cd = p_rec.line_cd
             AND tax_cd = p_rec.tax_cd
             AND tax_id = p_rec.tax_id
             AND min_value = p_rec.min_value)
         WHEN NOT MATCHED THEN
            INSERT (iss_cd, line_cd, tax_cd, min_value, max_value, tax_amount,
                    tax_id, user_id, last_update)
            VALUES (p_rec.iss_cd, p_rec.line_cd, p_rec.tax_cd,
                    p_rec.min_value, p_rec.max_value, p_rec.tax_amount,
                    p_rec.tax_id, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET max_value = p_rec.max_value, tax_amount = p_rec.tax_amount,
                   user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_tax_range_rec (
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_line_cd     giis_line.line_cd%TYPE,
      p_tax_cd      giis_tax_peril.tax_cd%TYPE,
      p_tax_id      giis_tax_peril.tax_id%TYPE,
      p_min_value   giis_tax_range.min_value%TYPE
   )
   AS
   BEGIN
      DELETE FROM giis_tax_range
            WHERE iss_cd = p_iss_cd
              AND line_cd = p_line_cd
              AND tax_cd = p_tax_cd
              AND tax_id = p_tax_id
              AND min_value = p_min_value;
   END;

   FUNCTION val_add_tax (
      p_iss_cd    giis_issource.iss_cd%TYPE,
      p_line_cd   giis_line.line_cd%TYPE,
      p_tax_cd    giis_tax_peril.tax_cd%TYPE
   )
      RETURN VARCHAR
   IS
      v_exist   VARCHAR (1);
   BEGIN
      FOR i IN (SELECT 1
                  FROM giis_tax_charges
                 WHERE line_cd = p_line_cd
                   AND iss_cd = p_iss_cd
                   AND tax_cd = p_tax_cd
                   AND expired_sw = 'N')
      LOOP
         v_exist := 1;
         EXIT;
      END LOOP;

      RETURN v_exist;
   END val_add_tax;

    FUNCTION val_date_on_add (
        p_iss_cd      giis_issource.iss_cd%TYPE,
        p_line_cd     giis_line.line_cd%TYPE,
        p_tax_cd      giis_tax_peril.tax_cd%TYPE,
        p_start_date  VARCHAR2,
        p_end_date    VARCHAR2,
        p_tax_id      giis_tax_peril.tax_id%TYPE,
        p_tran        VARCHAR2
    )
        RETURN VARCHAR
    IS
        v_exist           VARCHAR (1);
        v_tax_desc        VARCHAR2 (50);
        v_cnt             NUMBER;
    BEGIN
        IF p_tran = 'ADD'
        THEN
            FOR i IN (SELECT *
                      FROM giis_tax_charges
                     WHERE line_cd = p_line_cd
                       AND iss_cd = p_iss_cd
                       AND tax_cd = p_tax_cd
                       AND expired_sw = 'N'
                       AND eff_start_date <= TO_DATE (p_end_date, 'MM-DD-YYYY')
                       AND eff_end_date   >= TO_DATE (p_start_date, 'MM-DD-YYYY'))
            LOOP
             v_exist := 1;
             v_tax_desc := i.tax_desc;
             EXIT;
            END LOOP;

            IF v_exist = 1
            THEN
             raise_application_error
                (-20001,
                    'Geniisys Exception#E#The effectivity of this tax falls within the current '
                 || v_tax_desc
                 || '.'
                );
            END IF; 
        ELSE
            SELECT COUNT(*)
              INTO v_cnt
              FROM giis_tax_charges
             WHERE line_cd = p_line_cd 
               AND iss_cd = p_iss_cd 
               AND tax_cd = p_tax_cd 
               AND expired_sw = 'N';
            
            IF v_cnt < 1
            THEN
                FOR i IN (SELECT *
                            FROM giis_tax_charges
                           WHERE line_cd = p_line_cd
                             AND iss_cd = p_iss_cd
                             AND tax_cd = p_tax_cd
                             AND tax_id = p_tax_id
                             AND expired_sw = 'N'
                             AND TO_DATE (p_start_date, 'MM-DD-YYYY') > TO_DATE (p_end_date, 'MM-DD-YYYY'))
                LOOP
                    v_exist := 1;
                    v_tax_desc := i.tax_desc;
                END LOOP;    
                                         
                IF v_exist = 1
                THEN
                 raise_application_error
                    (-20001,
                        'Geniisys Exception#E#The effectivity of this tax falls within the current '
                     || v_tax_desc
                     || '.'
                    );
                END IF; 
            ELSE
                FOR i IN(SELECT *
                           FROM giis_tax_charges
                          WHERE line_cd = p_line_cd
                            AND iss_cd = p_iss_cd
                            AND tax_cd = p_tax_cd
                            AND tax_id <> p_tax_id
                            AND expired_sw = 'N'
                            AND (TO_DATE (p_start_date, 'MM-DD-YYYY') BETWEEN eff_start_date AND eff_end_date
                                  OR TO_DATE (p_end_date, 'MM-DD-YYYY') BETWEEN eff_start_date AND eff_end_date))
                LOOP
                    v_exist := 1;
                    v_tax_desc := i.tax_desc;
                END LOOP;
                
                IF v_exist = 1
                THEN
                 raise_application_error
                    (-20001,
                        'Geniisys Exception#E#The effectivity of this tax falls within the current '
                     || v_tax_desc
                     || '.'
                    );
                END IF;                
            END IF;               
        END IF;
        RETURN v_exist;
    END val_date_on_add;

   PROCEDURE val_seq_on_add (
      p_iss_cd     giis_issource.iss_cd%TYPE,
      p_line_cd    giis_line.line_cd%TYPE,
      p_sequence   NUMBER
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_tax_charges
                 WHERE iss_cd = p_iss_cd
                   AND line_cd = p_line_cd
                   AND SEQUENCE = p_sequence)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
               (-20001,
                'Geniisys Exception#E#Row exists already with same sequence.'
               );
      END IF;
   END;
END GIISS028_PKG;
/


