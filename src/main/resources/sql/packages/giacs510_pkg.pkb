CREATE OR REPLACE PACKAGE BODY CPI.giacs510_pkg
AS
   FUNCTION get_budget_year_list (p_year giac_budget.YEAR%TYPE)
      RETURN giacs510_year_list_tab PIPELINED
   IS
      v_rec   giacs510_list;
   BEGIN
      FOR i IN (SELECT DISTINCT YEAR
                           FROM giac_budget
                          WHERE YEAR = NVL (p_year, YEAR)
                       ORDER BY YEAR)
      LOOP
         v_rec.YEAR := i.YEAR;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_budget_year_list;

   FUNCTION get_budget_peryear_list (
      p_year            giac_budget.YEAR%TYPE,
      p_gl_account_no   VARCHAR2,
      p_gl_acct_name    giac_chart_of_accts.gl_acct_name%TYPE,
      p_budget          giac_budget.budget%TYPE
   )
      RETURN giacs510_year_list_tab PIPELINED
   IS
      v_rec   giacs510_list;
   BEGIN
      FOR i IN (SELECT *
                  FROM giac_budget
                 WHERE YEAR LIKE p_year)
      LOOP
         v_rec.budget := i.budget;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                          TO_CHAR (i.last_update, 'mm-dd-yyyy HH12:MI:SS AM');
         v_rec.YEAR := i.YEAR;
         v_rec.gl_acct_id := i.gl_acct_id;

         BEGIN
            FOR j IN
               (SELECT    LTRIM (TO_CHAR (gl_acct_category))
                       || '-'
                       || LTRIM (TO_CHAR (gl_control_acct, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (gl_sub_acct_1, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (gl_sub_acct_2, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (gl_sub_acct_3, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (gl_sub_acct_4, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (gl_sub_acct_5, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (gl_sub_acct_6, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (gl_sub_acct_7, '09'))
                                                             "GL_ACCOUNT_NO",
                       gl_acct_category, gl_control_acct, gl_sub_acct_1,
                       gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4,
                       gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7,
                       gl_acct_name
                  FROM giac_chart_of_accts
                 WHERE gl_acct_id = i.gl_acct_id
                   AND    LTRIM (TO_CHAR (gl_acct_category))
                       || '-'
                       || LTRIM (TO_CHAR (gl_control_acct, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (gl_sub_acct_1, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (gl_sub_acct_2, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (gl_sub_acct_3, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (gl_sub_acct_4, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (gl_sub_acct_5, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (gl_sub_acct_6, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (gl_sub_acct_7, '09')) LIKE
                          NVL (p_gl_account_no || '%',
                                  LTRIM (TO_CHAR (gl_acct_category))
                               || '-'
                               || LTRIM (TO_CHAR (gl_control_acct, '09'))
                               || '-'
                               || LTRIM (TO_CHAR (gl_sub_acct_1, '09'))
                               || '-'
                               || LTRIM (TO_CHAR (gl_sub_acct_2, '09'))
                               || '-'
                               || LTRIM (TO_CHAR (gl_sub_acct_3, '09'))
                               || '-'
                               || LTRIM (TO_CHAR (gl_sub_acct_4, '09'))
                               || '-'
                               || LTRIM (TO_CHAR (gl_sub_acct_5, '09'))
                               || '-'
                               || LTRIM (TO_CHAR (gl_sub_acct_6, '09'))
                               || '-'
                               || LTRIM (TO_CHAR (gl_sub_acct_7, '09'))
                              )
                   AND UPPER (gl_acct_name) LIKE
                             UPPER (NVL (p_gl_acct_name || '%', gl_acct_name)))
            LOOP
               v_rec.gl_account_no := j.gl_account_no;
               v_rec.gl_acct_name := j.gl_acct_name;
               v_rec.gl_acct_category := j.gl_acct_category;
               v_rec.gl_control_acct := j.gl_control_acct;
               v_rec.gl_sub_acct_1 := j.gl_sub_acct_1;
               v_rec.gl_sub_acct_2 := j.gl_sub_acct_2;
               v_rec.gl_sub_acct_3 := j.gl_sub_acct_3;
               v_rec.gl_sub_acct_4 := j.gl_sub_acct_4;
               v_rec.gl_sub_acct_5 := j.gl_sub_acct_5;
               v_rec.gl_sub_acct_6 := j.gl_sub_acct_6;
               v_rec.gl_sub_acct_7 := j.gl_sub_acct_7;
               PIPE ROW (v_rec);
            END LOOP;
         END;
      END LOOP;

      RETURN;
   END get_budget_peryear_list;

   PROCEDURE val_add_budgetyear (p_year giac_budget.YEAR%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT 1
                  FROM giac_budget
                 WHERE YEAR = p_year)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
               (-20001,
                'Geniisys Exception#E#Sorry you can''t add an existing year.'
               );
      END IF;
   END val_add_budgetyear;

   FUNCTION get_budgetyear_lov
      RETURN year_list_lov_tab PIPELINED
   IS
      v_rec   year_list_lov;
   BEGIN
      FOR i IN (SELECT DISTINCT YEAR
                           FROM giac_budget
                       ORDER BY YEAR DESC)
      LOOP
         v_rec.YEAR := i.YEAR;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_budgetyear_lov;

   PROCEDURE copy_budget (
      p_year          VARCHAR2,
      p_copied_year   VARCHAR2,
      p_user_id       VARCHAR2
   )
   IS
   BEGIN
      FOR i IN (SELECT gl_acct_id
                  FROM giac_budget
                 WHERE YEAR = p_copied_year)
      LOOP
         INSERT INTO giac_budget
                     (YEAR, gl_acct_id, user_id, last_update
                     )
              VALUES (p_year, i.gl_acct_id, p_user_id, SYSDATE
                     );

         FOR k IN (SELECT dtl_acct_id
                     FROM giac_budget_dtl
                    WHERE YEAR = p_copied_year AND gl_acct_id = i.gl_acct_id)
         LOOP
            INSERT INTO giac_budget_dtl
                        (YEAR, gl_acct_id, dtl_acct_id
                        )
                 VALUES (p_year, i.gl_acct_id, k.dtl_acct_id
                        );
         END LOOP;
      END LOOP;
   END;

   FUNCTION get_glacct_lov (
      p_table              VARCHAR2,
      p_year               VARCHAR2,
      p_gl_account_no      VARCHAR2,
      p_gl_acct_name       VARCHAR2,
      p_gl_acct_category   giac_chart_of_accts.gl_acct_category%TYPE,
      p_gl_control_acct    giac_chart_of_accts.gl_control_acct%TYPE,
      p_gl_sub_acct_1      giac_chart_of_accts.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2      giac_chart_of_accts.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3      giac_chart_of_accts.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4      giac_chart_of_accts.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5      giac_chart_of_accts.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6      giac_chart_of_accts.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7      giac_chart_of_accts.gl_sub_acct_7%TYPE
   )
      RETURN gl_acctno_lov_tab PIPELINED
   IS
      v_rec         gl_acctno_lov;
      v_where       VARCHAR2 (32000) := NULL;

      TYPE v_type IS RECORD (
         gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
         gl_account_no      VARCHAR2 (100),
         gl_acct_name       giac_chart_of_accts.gl_acct_name%TYPE,
         gl_acct_category   giac_chart_of_accts.gl_acct_category%TYPE,
         gl_control_acct    giac_chart_of_accts.gl_control_acct%TYPE,
         gl_sub_acct_1      giac_chart_of_accts.gl_sub_acct_1%TYPE,
         gl_sub_acct_2      giac_chart_of_accts.gl_sub_acct_2%TYPE,
         gl_sub_acct_3      giac_chart_of_accts.gl_sub_acct_3%TYPE,
         gl_sub_acct_4      giac_chart_of_accts.gl_sub_acct_4%TYPE,
         gl_sub_acct_5      giac_chart_of_accts.gl_sub_acct_5%TYPE,
         gl_sub_acct_6      giac_chart_of_accts.gl_sub_acct_6%TYPE,
         gl_sub_acct_7      giac_chart_of_accts.gl_sub_acct_7%TYPE
      );

      TYPE v_tab IS TABLE OF v_type;

      v_list_bulk   v_tab;
   BEGIN
      BEGIN
         IF p_table = 'GIAC_BUDGET'
         THEN
            v_where :=
                  ' gl_acct_category = NVL('''
               || p_gl_acct_category
               || ''', gl_acct_category) '
               || ' AND gl_control_acct = NVL('''
               || p_gl_control_acct
               || ''', gl_control_acct) '
               || ' AND gl_sub_acct_1 = NVL('''
               || p_gl_sub_acct_1
               || ''', gl_sub_acct_1) '
               || ' AND gl_sub_acct_2 = NVL('''
               || p_gl_sub_acct_2
               || ''', gl_sub_acct_2) '
               || ' AND gl_sub_acct_3 = NVL('''
               || p_gl_sub_acct_3
               || ''', gl_sub_acct_3) '
               || ' AND gl_sub_acct_4 = NVL('''
               || p_gl_sub_acct_4
               || ''', gl_sub_acct_4) '
               || ' AND gl_sub_acct_5 = NVL('''
               || p_gl_sub_acct_5
               || ''', gl_sub_acct_5) '
               || ' AND gl_sub_acct_6 = NVL('''
               || p_gl_sub_acct_6
               || ''', gl_sub_acct_6) '
               || ' AND gl_sub_acct_7 = NVL('''
               || p_gl_sub_acct_7
               || ''', gl_sub_acct_7) '
               || ' AND leaf_tag  = ''N'' '
               || ' AND NOT EXISTS (SELECT 1 '
               || ' FROM giac_budget x'
               || ' WHERE x.gl_acct_id = giac_chart_of_accts.gl_acct_id '
               || ' AND x.YEAR = '
               || p_year
               || ') '
               || ' AND EXISTS  (SELECT 1 '
               || ' FROM giac_chart_of_accts y'
               || ' WHERE y.leaf_tag  = ''Y'' '
               || ' AND y.gl_acct_category = giac_chart_of_accts.gl_acct_category '
               || ' AND y.gl_control_acct = giac_chart_of_accts.gl_control_acct '
               || ' AND y.gl_sub_acct_1 = DECODE(giac_chart_of_accts.gl_sub_acct_1,0,y.gl_sub_acct_1,giac_chart_of_accts.gl_sub_acct_1) '
               || ' AND y.gl_sub_acct_2 = DECODE(giac_chart_of_accts.gl_sub_acct_2,0,y.gl_sub_acct_2,giac_chart_of_accts.gl_sub_acct_2) '
               || ' AND y.gl_sub_acct_3 = DECODE(giac_chart_of_accts.gl_sub_acct_3,0,y.gl_sub_acct_3,giac_chart_of_accts.gl_sub_acct_3) '
               || ' AND y.gl_sub_acct_4 = DECODE(giac_chart_of_accts.gl_sub_acct_4,0,y.gl_sub_acct_4,giac_chart_of_accts.gl_sub_acct_4) '
               || ' AND y.gl_sub_acct_5 = DECODE(giac_chart_of_accts.gl_sub_acct_5,0,y.gl_sub_acct_5,giac_chart_of_accts.gl_sub_acct_5) '
               || ' AND y.gl_sub_acct_6 = DECODE(giac_chart_of_accts.gl_sub_acct_6,0,y.gl_sub_acct_6,giac_chart_of_accts.gl_sub_acct_6) '
               || ' AND y.gl_sub_acct_7	= DECODE(giac_chart_of_accts.gl_sub_acct_7,0,y.gl_sub_acct_7,giac_chart_of_accts.gl_sub_acct_7) '
               || ' AND NOT EXISTS (SELECT 1 '
               || ' FROM giac_budget_dtl z'
               || ' WHERE z.dtl_acct_id = y.gl_acct_id '
               || ' AND z.YEAR = '
               || p_year
               || ')) ';
         ELSE
            v_where :=
                  ' leaf_tag  = ''Y'' '
               || ' AND NOT EXISTS (SELECT 1 '
               || ' FROM giac_budget_dtl '
               || ' WHERE dtl_acct_id = giac_chart_of_accts.gl_acct_id '
               || ' AND YEAR = '
               || p_year
               || ') '
               || ' AND gl_acct_category = '
               || p_gl_acct_category
               || ' AND gl_control_acct = '
               || p_gl_control_acct
               || ' AND gl_sub_acct_1 = DECODE('
               || p_gl_sub_acct_1
               || ',0,gl_sub_acct_1,'
               || p_gl_sub_acct_1
               || ') '
               || ' AND gl_sub_acct_2 = DECODE('
               || p_gl_sub_acct_2
               || ',0,gl_sub_acct_2,'
               || p_gl_sub_acct_2
               || ') '
               || ' AND gl_sub_acct_3 = DECODE('
               || p_gl_sub_acct_3
               || ',0,gl_sub_acct_3,'
               || p_gl_sub_acct_3
               || ') '
               || ' AND gl_sub_acct_4 = DECODE('
               || p_gl_sub_acct_4
               || ',0,gl_sub_acct_4,'
               || p_gl_sub_acct_4
               || ') '
               || ' AND gl_sub_acct_5 = DECODE('
               || p_gl_sub_acct_5
               || ',0,gl_sub_acct_5,'
               || p_gl_sub_acct_5
               || ') '
               || ' AND gl_sub_acct_6 = DECODE('
               || p_gl_sub_acct_6
               || ',0,gl_sub_acct_6,'
               || p_gl_sub_acct_6
               || ') '
               || ' AND gl_sub_acct_7	= DECODE('
               || p_gl_sub_acct_7
               || ',0,gl_sub_acct_7,'
               || p_gl_sub_acct_7
               || ') ';
         END IF;
      END;

      EXECUTE IMMEDIATE    'SELECT gl_acct_id,
          LTRIM (TO_CHAR (gl_acct_category))
       || ''-''
       || LTRIM (TO_CHAR (gl_control_acct, ''09''))
       || ''-''
       || LTRIM (TO_CHAR (gl_sub_acct_1, ''09''))
       || ''-''
       || LTRIM (TO_CHAR (gl_sub_acct_2, ''09''))
       || ''-''
       || LTRIM (TO_CHAR (gl_sub_acct_3, ''09''))
       || ''-''
       || LTRIM (TO_CHAR (gl_sub_acct_4, ''09''))
       || ''-''
       || LTRIM (TO_CHAR (gl_sub_acct_5, ''09''))
       || ''-''
       || LTRIM (TO_CHAR (gl_sub_acct_6, ''09''))
       || ''-''
       || LTRIM (TO_CHAR (gl_sub_acct_7, ''09'')) "GL_ACCOUNT_NO",
       gl_acct_name, gl_acct_category, gl_control_acct, gl_sub_acct_1,
       gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5,
       gl_sub_acct_6, gl_sub_acct_7
  FROM giac_chart_of_accts
 WHERE 1 = 1
   AND '
                        || v_where
      BULK COLLECT INTO v_list_bulk;

      IF v_list_bulk.LAST > 0
      THEN
         FOR i IN v_list_bulk.FIRST .. v_list_bulk.LAST
         LOOP
            v_rec.gl_acct_id := v_list_bulk (i).gl_acct_id;
            v_rec.gl_account_no := v_list_bulk (i).gl_account_no;
            v_rec.gl_acct_name := v_list_bulk (i).gl_acct_name;
            v_rec.gl_acct_category := v_list_bulk (i).gl_acct_category;
            v_rec.gl_control_acct := v_list_bulk (i).gl_control_acct;
            v_rec.gl_sub_acct_1 := v_list_bulk (i).gl_sub_acct_1;
            v_rec.gl_sub_acct_2 := v_list_bulk (i).gl_sub_acct_2;
            v_rec.gl_sub_acct_3 := v_list_bulk (i).gl_sub_acct_3;
            v_rec.gl_sub_acct_4 := v_list_bulk (i).gl_sub_acct_4;
            v_rec.gl_sub_acct_5 := v_list_bulk (i).gl_sub_acct_5;
            v_rec.gl_sub_acct_6 := v_list_bulk (i).gl_sub_acct_6;
            v_rec.gl_sub_acct_7 := v_list_bulk (i).gl_sub_acct_7;
            PIPE ROW (v_rec);
         END LOOP;
      END IF;

      RETURN;
   END get_glacct_lov;

   PROCEDURE delete_budget (
      p_year         giac_budget.YEAR%TYPE,
      p_gl_acct_id   giac_chart_of_accts.gl_acct_id%TYPE
   )
   IS
   BEGIN
      DELETE FROM giac_budget
            WHERE YEAR = p_year AND gl_acct_id = p_gl_acct_id;
   END delete_budget;

   PROCEDURE val_delete_budget_peryear (
      p_gl_acct_id   giac_chart_of_accts.gl_acct_id%TYPE,
      p_year         giac_budget.year%TYPE
   )
   IS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT 1
                  FROM giac_budget_dtl
                 WHERE gl_acct_id = p_gl_acct_id
                   AND year = p_year)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete GIAC_BUDGET while dependent GIAC_BUDGET_DTL exists.'
            );
      END IF;
   END;

   PROCEDURE set_budget_peryear (
      p_year         giac_budget.YEAR%TYPE,
      p_gl_acct_id   giac_chart_of_accts.gl_acct_id%TYPE,
      p_budget       giac_budget.budget%TYPE,
      p_remarks      giis_cargo_type.remarks%TYPE,
      p_user_id      giis_users.user_id%TYPE
   )
   IS
   BEGIN
      BEGIN
         MERGE INTO giac_budget
            USING DUAL
            ON (YEAR = p_year AND gl_acct_id = p_gl_acct_id)
            WHEN NOT MATCHED THEN
               INSERT (YEAR, gl_acct_id, budget, remarks, user_id,
                       last_update)
               VALUES (p_year, p_gl_acct_id, p_budget, p_remarks, p_user_id,
                       SYSDATE)
            WHEN MATCHED THEN
               UPDATE
                  SET budget = p_budget, remarks = p_remarks,
                      user_id = p_user_id, last_update = SYSDATE
               ;
      END set_budget_peryear;
   END;

   FUNCTION validate_glacctno (
      p_year               giac_budget.YEAR%TYPE,
      p_table              VARCHAR2,
      p_gl_acct_category   giac_chart_of_accts.gl_acct_category%TYPE,
      p_gl_control_acct    giac_chart_of_accts.gl_control_acct%TYPE,
      p_gl_sub_acct_1      giac_chart_of_accts.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2      giac_chart_of_accts.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3      giac_chart_of_accts.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4      giac_chart_of_accts.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5      giac_chart_of_accts.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6      giac_chart_of_accts.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7      giac_chart_of_accts.gl_sub_acct_7%TYPE
   )
      RETURN validate_glacctno_tab PIPELINED
   IS
      v_rec   validate_glacctno_type;
   BEGIN
      IF p_table = 'GIAC_BUDGET'
      THEN
         BEGIN
            SELECT gl_acct_id, gl_acct_name, 'Y'
              INTO v_rec.gl_acct_id, v_rec.gl_acct_name, v_rec.exist
              FROM giac_chart_of_accts
             WHERE leaf_tag = 'N'
               AND NOT EXISTS (
                      SELECT 1
                        FROM giac_budget
                       WHERE gl_acct_id = giac_chart_of_accts.gl_acct_id
                         AND YEAR = p_year)
               AND EXISTS (
                      SELECT 1
                        FROM giac_chart_of_accts y
                       WHERE y.leaf_tag = 'Y'
                         AND y.gl_acct_category =
                                          giac_chart_of_accts.gl_acct_category
                         AND y.gl_control_acct =
                                           giac_chart_of_accts.gl_control_acct
                         AND y.gl_sub_acct_1 =
                                DECODE (giac_chart_of_accts.gl_sub_acct_1,
                                        0, y.gl_sub_acct_1,
                                        giac_chart_of_accts.gl_sub_acct_1
                                       )
                         AND y.gl_sub_acct_2 =
                                DECODE (giac_chart_of_accts.gl_sub_acct_2,
                                        0, y.gl_sub_acct_2,
                                        giac_chart_of_accts.gl_sub_acct_2
                                       )
                         AND y.gl_sub_acct_3 =
                                DECODE (giac_chart_of_accts.gl_sub_acct_3,
                                        0, y.gl_sub_acct_3,
                                        giac_chart_of_accts.gl_sub_acct_3
                                       )
                         AND y.gl_sub_acct_4 =
                                DECODE (giac_chart_of_accts.gl_sub_acct_4,
                                        0, y.gl_sub_acct_4,
                                        giac_chart_of_accts.gl_sub_acct_4
                                       )
                         AND y.gl_sub_acct_5 =
                                DECODE (giac_chart_of_accts.gl_sub_acct_5,
                                        0, y.gl_sub_acct_5,
                                        giac_chart_of_accts.gl_sub_acct_5
                                       )
                         AND y.gl_sub_acct_6 =
                                DECODE (giac_chart_of_accts.gl_sub_acct_6,
                                        0, y.gl_sub_acct_6,
                                        giac_chart_of_accts.gl_sub_acct_6
                                       )
                         AND y.gl_sub_acct_7 =
                                DECODE (giac_chart_of_accts.gl_sub_acct_7,
                                        0, y.gl_sub_acct_7,
                                        giac_chart_of_accts.gl_sub_acct_7
                                       )
                         AND NOT EXISTS (
                                SELECT 1
                                  FROM giac_budget_dtl z
                                 WHERE z.dtl_acct_id = y.gl_acct_id
                                   AND z.YEAR = p_year))
               AND gl_acct_category = p_gl_acct_category
               AND gl_control_acct = p_gl_control_acct
               AND gl_sub_acct_1 = p_gl_sub_acct_1
               AND gl_sub_acct_2 = p_gl_sub_acct_2
               AND gl_sub_acct_3 = p_gl_sub_acct_3
               AND gl_sub_acct_4 = p_gl_sub_acct_4
               AND gl_sub_acct_5 = p_gl_sub_acct_5
               AND gl_sub_acct_6 = p_gl_sub_acct_6
               AND gl_sub_acct_7 = p_gl_sub_acct_7;

            PIPE ROW (v_rec);
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.gl_acct_id := NULL;
               v_rec.gl_acct_name := NULL;
               v_rec.exist := 'N';
               PIPE ROW (v_rec);
               RETURN;
         END;
      ELSE
         BEGIN
            SELECT gl_acct_id, gl_acct_name, 'Y'
              INTO v_rec.gl_acct_id, v_rec.gl_acct_name, v_rec.exist
              FROM giac_chart_of_accts
             WHERE leaf_tag = 'Y'
               AND NOT EXISTS (
                      SELECT 1
                        FROM giac_budget_dtl
                       WHERE dtl_acct_id = giac_chart_of_accts.gl_acct_id
                         AND YEAR = p_year)
               AND gl_acct_category = p_gl_acct_category
               AND gl_control_acct = p_gl_control_acct
               AND gl_sub_acct_1 = p_gl_sub_acct_1
               AND gl_sub_acct_2 = p_gl_sub_acct_2
               AND gl_sub_acct_3 = p_gl_sub_acct_3
               AND gl_sub_acct_4 = p_gl_sub_acct_4
               AND gl_sub_acct_5 = p_gl_sub_acct_5
               AND gl_sub_acct_6 = p_gl_sub_acct_6
               AND gl_sub_acct_7 = p_gl_sub_acct_7;

            PIPE ROW (v_rec);
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.gl_acct_id := NULL;
               v_rec.gl_acct_name := NULL;
               v_rec.exist := 'N';
               PIPE ROW (v_rec);
               RETURN;
         END;
      END IF;
   END validate_glacctno;

   FUNCTION get_budgetdtl_peryear_list (
      p_year            giac_budget.YEAR%TYPE,
      p_gl_acct_id      giac_budget.gl_acct_id%TYPE,
      p_gl_account_no   VARCHAR2,
      p_gl_acct_name    giac_chart_of_accts.gl_acct_name%TYPE
   )
      RETURN giacs510__dtl_list_tab PIPELINED
   IS
      v_rec   giacs510__dtl_list;
   BEGIN
      FOR i IN (SELECT *
                  FROM giac_budget
                 WHERE YEAR LIKE p_year AND gl_acct_id = p_gl_acct_id)
      LOOP
         v_rec.YEAR := i.YEAR;
         v_rec.gl_acct_id := i.gl_acct_id;

         BEGIN
            FOR k IN (SELECT *
                        FROM giac_budget_dtl
                       WHERE YEAR = i.YEAR AND gl_acct_id = i.gl_acct_id)
            LOOP
               v_rec.dtl_acct_id := k.dtl_acct_id;

               FOR j IN
                  (SELECT    LTRIM (TO_CHAR (gl_acct_category)
                                   )
                          || '-'
                          || LTRIM (TO_CHAR (gl_control_acct, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (gl_sub_acct_1, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (gl_sub_acct_2, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (gl_sub_acct_3, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (gl_sub_acct_4, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (gl_sub_acct_5, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (gl_sub_acct_6, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (gl_sub_acct_7, '09'))
                                                             "GL_ACCOUNT_NO",
                          gl_acct_category, gl_control_acct, gl_sub_acct_1,
                          gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4,
                          gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7,
                          gl_acct_name
                     FROM giac_chart_of_accts
                    WHERE gl_acct_id = k.dtl_acct_id
                      AND    LTRIM (TO_CHAR (gl_acct_category))
                          || '-'
                          || LTRIM (TO_CHAR (gl_control_acct, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (gl_sub_acct_1, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (gl_sub_acct_2, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (gl_sub_acct_3, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (gl_sub_acct_4, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (gl_sub_acct_5, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (gl_sub_acct_6, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (gl_sub_acct_7, '09')) LIKE
                             NVL (p_gl_account_no || '%',
                                     LTRIM (TO_CHAR (gl_acct_category))
                                  || '-'
                                  || LTRIM (TO_CHAR (gl_control_acct, '09'))
                                  || '-'
                                  || LTRIM (TO_CHAR (gl_sub_acct_1, '09'))
                                  || '-'
                                  || LTRIM (TO_CHAR (gl_sub_acct_2, '09'))
                                  || '-'
                                  || LTRIM (TO_CHAR (gl_sub_acct_3, '09'))
                                  || '-'
                                  || LTRIM (TO_CHAR (gl_sub_acct_4, '09'))
                                  || '-'
                                  || LTRIM (TO_CHAR (gl_sub_acct_5, '09'))
                                  || '-'
                                  || LTRIM (TO_CHAR (gl_sub_acct_6, '09'))
                                  || '-'
                                  || LTRIM (TO_CHAR (gl_sub_acct_7, '09'))
                                 )
                      AND UPPER (gl_acct_name) LIKE
                             UPPER (NVL (p_gl_acct_name || '%', gl_acct_name)))
               LOOP
                  v_rec.gl_account_no := j.gl_account_no;
                  v_rec.gl_acct_name := j.gl_acct_name;
                  v_rec.gl_acct_category := j.gl_acct_category;
                  v_rec.gl_control_acct := j.gl_control_acct;
                  v_rec.gl_sub_acct_1 := j.gl_sub_acct_1;
                  v_rec.gl_sub_acct_2 := j.gl_sub_acct_2;
                  v_rec.gl_sub_acct_3 := j.gl_sub_acct_3;
                  v_rec.gl_sub_acct_4 := j.gl_sub_acct_4;
                  v_rec.gl_sub_acct_5 := j.gl_sub_acct_5;
                  v_rec.gl_sub_acct_6 := j.gl_sub_acct_6;
                  v_rec.gl_sub_acct_7 := j.gl_sub_acct_7;
                  PIPE ROW (v_rec);
               END LOOP;
            END LOOP;
         END;
      END LOOP;

      RETURN;
   END get_budgetdtl_peryear_list;

   PROCEDURE set_budgetdtl_peryear (
      p_year          giac_budget.YEAR%TYPE,
      p_gl_acct_id    giac_chart_of_accts.gl_acct_id%TYPE,
      p_dtl_acct_id   giac_budget_dtl.dtl_acct_id%TYPE,
      p_user_id       giis_users.user_id%TYPE
   )
   IS
   BEGIN
      MERGE INTO giac_budget_dtl
         USING DUAL
         ON (    YEAR = p_year
             AND gl_acct_id = p_gl_acct_id
             AND dtl_acct_id = p_dtl_acct_id)
         WHEN NOT MATCHED THEN
            INSERT (YEAR, gl_acct_id, dtl_acct_id, user_id, last_update)
            VALUES (p_year, p_gl_acct_id, p_dtl_acct_id, p_user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET user_id = p_user_id, last_update = SYSDATE
            ;
   END set_budgetdtl_peryear;

   PROCEDURE delete_budgetdtl (
      p_year          giac_budget.YEAR%TYPE,
      p_gl_acct_id    giac_chart_of_accts.gl_acct_id%TYPE,
      p_dtl_acct_id   giac_budget_dtl.dtl_acct_id%TYPE
   )
   IS
   BEGIN
      DELETE FROM giac_budget_dtl
            WHERE YEAR = p_year
              AND gl_acct_id = p_gl_acct_id
              AND dtl_acct_id = p_dtl_acct_id;
   END delete_budgetdtl;

   FUNCTION check_exist_giacs510 (p_year giac_budget.YEAR%TYPE)
      RETURN check_exists_tab PIPELINED
   IS
      v_rec   check_exists_type;
   BEGIN
      v_rec.exist := 'N';

      FOR c1 IN (SELECT gl_acct_category, gl_control_acct, gl_sub_acct_1,
                        gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4,
                        gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7,
                        gl_acct_name
                   FROM giac_chart_of_accts a, giac_budget b
                  WHERE a.gl_acct_id = b.gl_acct_id
                    AND b.YEAR = p_year
                    AND a.acct_type = 'E'
                    AND NOT EXISTS (
                           SELECT 1
                             FROM giac_budget_dtl z
                            WHERE z.gl_acct_id = b.gl_acct_id
                              AND z.YEAR = p_year))
      LOOP
         v_rec.exist := 'Y';
         EXIT;
      END LOOP;

      PIPE ROW (v_rec);
      RETURN;
   END check_exist_giacs510;

   PROCEDURE extract_giacs510 (
      p_year         IN       VARCHAR,
      p_date_basis   IN       VARCHAR,
      p_tran_flag    IN       VARCHAR,
      p_user_id      IN       VARCHAR,
      p_exists       OUT      NUMBER
   )
   IS
      v_row_counter   NUMBER         := 0;
      v_curr_debit    NUMBER (12, 2) := 0;
      v_curr_credit   NUMBER (12, 2) := 0;
      v_prev_debit    NUMBER (12, 2) := 0;
      v_prev_credit   NUMBER (12, 2) := 0;
      v_curr_exp      NUMBER (12, 2) := 0;
      v_prev_exp      NUMBER (12, 2) := 0;
   BEGIN
      p_exists := '0';

      DELETE FROM giac_comp_expense_ext
            WHERE user_id = p_user_id;

      FOR exp_ext IN (SELECT   SUM (a.debit_amt) debit_amt,
                               SUM (a.credit_amt) credit_amt, c.gl_acct_id
                          FROM giac_acct_entries a,
                               giac_chart_of_accts e,
                               giac_acctrans b,
                               giac_budget_dtl d,
                               giac_budget c
                         WHERE 1 = 1
                           AND a.gl_acct_id = e.gl_acct_id
                           AND e.acct_type = 'E'
                           AND a.gacc_tran_id = b.tran_id
                           AND (    b.tran_flag <> 'D'
                                AND b.tran_flag <> p_tran_flag
                               )
                           AND DECODE (p_date_basis,
                                       '2', TO_CHAR (b.posting_date, 'YYYY'),
                                       TO_CHAR (b.tran_date, 'YYYY')
                                      ) = p_year
                           AND a.gl_acct_id = d.dtl_acct_id
                           AND d.gl_acct_id = c.gl_acct_id
                           AND d.YEAR = c.YEAR
                           AND c.YEAR = p_year
                      GROUP BY c.gl_acct_id)
      LOOP
         BEGIN
            SELECT NVL (SUM (NVL (debit_amt, 0)), 0),
                   NVL (SUM (NVL (credit_amt, 0)), 0)
              INTO v_prev_debit,
                   v_prev_credit
              FROM giac_acct_entries a,
                   giac_chart_of_accts e,
                   giac_acctrans b,
                   giac_budget_dtl d,
                   giac_budget c
             WHERE 1 = 1
               AND a.gl_acct_id = e.gl_acct_id
               AND e.acct_type = 'E'
               AND a.gacc_tran_id = b.tran_id
               AND (b.tran_flag <> 'D' AND b.tran_flag <> p_tran_flag)
               AND DECODE (p_date_basis,
                           '2', TO_CHAR (b.posting_date, 'YYYY'),
                           TO_CHAR (b.tran_date, 'YYYY')
                          ) = p_year - 1
               AND a.gl_acct_id = d.dtl_acct_id
               AND d.gl_acct_id = c.gl_acct_id
               AND d.YEAR = c.YEAR
               AND c.YEAR = p_year
               AND c.gl_acct_id = exp_ext.gl_acct_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_prev_debit := 0;
               v_prev_credit := 0;
         END;

         v_curr_debit := exp_ext.debit_amt;
         v_curr_credit := exp_ext.credit_amt;
         v_curr_exp := v_curr_debit - v_curr_credit;
         v_prev_exp := v_prev_debit - v_prev_credit;
         v_row_counter := v_row_counter + 1;
         p_exists := TO_CHAR (v_row_counter);

         INSERT INTO giac_comp_expense_ext
                     (gl_acct_id, curr_exp, prev_exp, user_id,
                      last_update
                     )
              VALUES (exp_ext.gl_acct_id, v_curr_exp, v_prev_exp, p_user_id,
                      SYSDATE
                     );
      END LOOP;
   END extract_giacs510;

   FUNCTION get_gl_nodtl (
      p_year            giac_budget.YEAR%TYPE,
      p_gl_account_no   VARCHAR2,
      p_gl_acct_name    giac_chart_of_accts.gl_acct_name%TYPE
   )
      RETURN gl_nodtl_tab PIPELINED
   IS
      v_rec   gl_nodtl_type;
   BEGIN
      FOR i IN
         (SELECT b.YEAR, b.gl_acct_id, gl_acct_category, gl_control_acct,
                 gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4,
                 gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7, gl_acct_name,
                    LTRIM (TO_CHAR (gl_acct_category))
                 || '-'
                 || LTRIM (TO_CHAR (gl_control_acct, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (gl_sub_acct_1, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (gl_sub_acct_2, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (gl_sub_acct_3, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (gl_sub_acct_4, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (gl_sub_acct_5, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (gl_sub_acct_6, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (gl_sub_acct_7, '09')) "GL_ACCOUNT_NO"
            FROM giac_chart_of_accts a, giac_budget b
           WHERE a.gl_acct_id = b.gl_acct_id
             AND a.acct_type = 'E'
             AND YEAR = p_year
             AND NOT EXISTS (
                         SELECT 1
                           FROM giac_budget_dtl z
                          WHERE z.gl_acct_id = b.gl_acct_id
                                AND z.YEAR = p_year)
             AND    LTRIM (TO_CHAR (gl_acct_category))
                 || '-'
                 || LTRIM (TO_CHAR (gl_control_acct, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (gl_sub_acct_1, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (gl_sub_acct_2, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (gl_sub_acct_3, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (gl_sub_acct_4, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (gl_sub_acct_5, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (gl_sub_acct_6, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (gl_sub_acct_7, '09')) LIKE
                    NVL (p_gl_account_no || '%',
                            LTRIM (TO_CHAR (gl_acct_category))
                         || '-'
                         || LTRIM (TO_CHAR (gl_control_acct, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (gl_sub_acct_1, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (gl_sub_acct_2, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (gl_sub_acct_3, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (gl_sub_acct_4, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (gl_sub_acct_5, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (gl_sub_acct_6, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (gl_sub_acct_7, '09'))
                        )
             AND UPPER (gl_acct_name) LIKE
                             UPPER (NVL (p_gl_acct_name || '%', gl_acct_name)))
      LOOP
         v_rec.gl_account_no := i.gl_account_no;
         v_rec.gl_acct_name := i.gl_acct_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_gl_nodtl;
END;
/


