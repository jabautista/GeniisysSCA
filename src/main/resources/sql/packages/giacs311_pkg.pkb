CREATE OR REPLACE PACKAGE BODY CPI.giacs311_pkg
AS
   FUNCTION check_user_function(
      p_user_id         giis_users.user_id%TYPE 
   )
      RETURN VARCHAR2
   IS
      v_user    VARCHAR2(8);
   BEGIN
      SELECT 'Y'
        INTO v_user
        FROM giac_modules a,
             giac_functions b,
             giac_user_functions c
       WHERE a.module_id = b.module_id
         AND b.module_id = c.module_id
         AND b.function_code = c.function_code
         AND a.module_name LIKE 'GIACS311'
         AND b.function_code = 'CA'	
         AND c.user_id = p_user_id;
      RETURN v_user;         
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_user := 'N';
      RETURN v_user;
   END;

   FUNCTION get_rec_list(
      p_query_level     VARCHAR2
   )
      RETURN rec_tab PIPELINED
   IS 
      TYPE cur_typ IS REF CURSOR;
      c         cur_typ;
      v_rec     rec_type;
      v_select  VARCHAR2 (5000);
      v_where   VARCHAR2 (5000);   
   BEGIN
      IF p_query_level = 'GLAC' THEN
        v_where := 'WHERE a.gl_control_acct  = 0
                      AND a.gl_sub_acct_1    = 0
                      AND a.gl_sub_acct_2    = 0
                      AND a.gl_sub_acct_3    = 0
                      AND a.gl_sub_acct_4    = 0
                      AND a.gl_sub_acct_5    = 0
                      AND a.gl_sub_acct_6    = 0
                      AND a.gl_sub_acct_7    = 0';
      ELSIF p_query_level = 'GLCA' THEN
        v_where := 'WHERE a.gl_control_acct <> 0
                      AND a.gl_sub_acct_1    = 0
                      AND a.gl_sub_acct_2    = 0
                      AND a.gl_sub_acct_3    = 0
                      AND a.gl_sub_acct_4    = 0
                      AND a.gl_sub_acct_5    = 0
                      AND a.gl_sub_acct_6    = 0
                      AND a.gl_sub_acct_7    = 0';   
      ELSIF p_query_level = 'GSA1' THEN
        v_where := 'WHERE a.gl_sub_acct_1   <> 0
                      AND a.gl_sub_acct_2    = 0
                      AND a.gl_sub_acct_3    = 0
                      AND a.gl_sub_acct_4    = 0
                      AND a.gl_sub_acct_5    = 0
                      AND a.gl_sub_acct_6    = 0
                      AND a.gl_sub_acct_7    = 0';  
      ELSIF p_query_level = 'GSA2' THEN
        v_where := 'WHERE a.gl_sub_acct_2   <> 0
                      AND a.gl_sub_acct_3    = 0
                      AND a.gl_sub_acct_4    = 0
                      AND a.gl_sub_acct_5    = 0
                      AND a.gl_sub_acct_6    = 0
                      AND a.gl_sub_acct_7    = 0';  
      ELSIF p_query_level = 'GSA3' THEN
        v_where := 'WHERE a.gl_sub_acct_3   <> 0
                      AND a.gl_sub_acct_4    = 0
                      AND a.gl_sub_acct_5    = 0
                      AND a.gl_sub_acct_6    = 0
                      AND a.gl_sub_acct_7    = 0';     
      ELSIF p_query_level = 'GSA4' THEN
        v_where := 'WHERE a.gl_sub_acct_4   <> 0
                      AND a.gl_sub_acct_5    = 0
                      AND a.gl_sub_acct_6    = 0
                      AND a.gl_sub_acct_7    = 0';  
      ELSIF p_query_level = 'GSA5' THEN
        v_where := 'WHERE a.gl_sub_acct_5   <> 0
                      AND a.gl_sub_acct_6    = 0
                      AND a.gl_sub_acct_7    = 0'; 
      ELSIF p_query_level = 'GSA6' THEN
        v_where := 'WHERE a.gl_sub_acct_6   <> 0
                      AND a.gl_sub_acct_7    = 0'; 
      ELSIF p_query_level = 'GSA7' THEN
        v_where := 'WHERE a.gl_sub_acct_7   <> 0';                                                                                                                                                 
      END IF;   
      
      v_select := 'SELECT a.gl_acct_id, a.gl_acct_category, a.gl_control_acct, a.gl_sub_acct_1, a.gl_sub_acct_2,
                          a.gl_sub_acct_3, a.gl_sub_acct_4, a.gl_sub_acct_5, a.gl_sub_acct_6, a.gl_sub_acct_7,
                          a.gl_acct_name, a.gl_acct_sname, a.leaf_tag, a.gslt_sl_type_cd,
                          a.dr_cr_tag, a.acct_type, a.ref_acct_cd, a.user_id, TO_CHAR (a.last_update, ''MM-DD-YYYY HH:MI:SS AM'')
                     FROM giac_chart_of_accts a '
                 || v_where ||
                ' ORDER BY gl_acct_category, gl_control_acct, gl_sub_acct_1, gl_sub_acct_2,
                          gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6,
                          gl_sub_acct_7';
                          
                          
      OPEN c FOR v_select;

      LOOP
         FETCH c
          INTO v_rec.gl_acct_id,
               v_rec.gl_acct_category,
               v_rec.gl_control_acct,
               v_rec.gl_sub_acct_1,
               v_rec.gl_sub_acct_2,
               v_rec.gl_sub_acct_3,
               v_rec.gl_sub_acct_4,
               v_rec.gl_sub_acct_5,
               v_rec.gl_sub_acct_6,
               v_rec.gl_sub_acct_7,
               v_rec.gl_acct_name,
               v_rec.gl_acct_sname,
               v_rec.leaf_tag,
               v_rec.gslt_sl_type_cd,
               v_rec.dr_cr_tag,
               v_rec.acct_type,
               v_rec.ref_acct_cd,
               v_rec.user_id,
               v_rec.last_update;

         IF v_rec.gslt_sl_type_cd IS NOT NULL
         THEN
             SELECT gslt.sl_type_name
               INTO v_rec.dsp_sl_type_name
               FROM giac_sl_types gslt
              WHERE gslt.sl_type_cd = v_rec.gslt_sl_type_cd;
         ELSE
            v_rec.dsp_sl_type_name := NULL;
         END IF; 

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_rec);
      END LOOP;

      CLOSE c;
   END;
   
   FUNCTION get_sl_type_rec_list
      RETURN sl_tab PIPELINED
   IS 
      v_rec   sl_type;   
   BEGIN
      FOR i IN(SELECT gslt.sl_type_cd  gslt_sl_type_cd, gslt.sl_type_name  dsp_sl_type_name
                 FROM giac_sl_types gslt)
      LOOP
        v_rec.gslt_sl_type_cd := i.gslt_sl_type_cd;
        v_rec.dsp_sl_type_name := i.dsp_sl_type_name;
      
        PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_acct_type_rec_list(
      p_acct_type      cg_ref_codes.rv_low_value%TYPE
   )
      RETURN acct_tab PIPELINED
   IS
      v_rec     acct_type;
   BEGIN
      FOR i IN(SELECT RTRIM (SUBSTR (rv_low_value, 1, 3)) rv_low_value, RTRIM (SUBSTR (rv_meaning, 1, 40)) rv_meaning
                 FROM cg_ref_codes
                WHERE rv_domain = 'GIAC_CHART_OF_ACCTS.ACCT_TYPE'
                  AND UPPER(RTRIM (SUBSTR (rv_low_value, 1, 3))) LIKE UPPER(NVL(RTRIM (SUBSTR (rv_low_value, 1, 3)),'%')))
      LOOP
        v_rec.rv_low_value := i.rv_low_value;
        v_rec.rv_meaning   := i.rv_meaning;
        PIPE ROW(v_rec);
      END LOOP;
   END;
   
   FUNCTION get_gl_mother_acct(
      p_gl_acct_id      giac_chart_of_accts.gl_acct_id%TYPE,
      p_level           VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_gl_acct_category  giac_chart_of_accts.gl_acct_category%TYPE;
      v_gl_control_acct   giac_chart_of_accts.gl_control_acct%TYPE;
      v_gl_sub_acct_1     giac_chart_of_accts.gl_sub_acct_1%TYPE;
      v_gl_sub_acct_2     giac_chart_of_accts.gl_sub_acct_2%TYPE;
      v_gl_sub_acct_3     giac_chart_of_accts.gl_sub_acct_3%TYPE;
      v_gl_sub_acct_4     giac_chart_of_accts.gl_sub_acct_4%TYPE;
      v_gl_sub_acct_5     giac_chart_of_accts.gl_sub_acct_5%TYPE;
      v_gl_sub_acct_6     giac_chart_of_accts.gl_sub_acct_6%TYPE;
      v_gl_sub_acct_7     giac_chart_of_accts.gl_sub_acct_7%TYPE;
      v_gl_acct           VARCHAR2(300);
   BEGIN
      BEGIN
        SELECT gl_acct_category, gl_control_acct, gl_sub_acct_1   , gl_sub_acct_2  ,
               gl_sub_acct_3   , gl_sub_acct_4  , gl_sub_acct_5   , gl_sub_acct_6  ,
               gl_sub_acct_7   
          INTO v_gl_acct_category, v_gl_control_acct, v_gl_sub_acct_1, v_gl_sub_acct_2,
               v_gl_sub_acct_3, v_gl_sub_acct_4, v_gl_sub_acct_5, v_gl_sub_acct_6, v_gl_sub_acct_7
          FROM giac_chart_of_accts a
         WHERE a.gl_acct_id = p_gl_acct_id;
      END;
      
      IF p_level = 'same'
      THEN
          FOR i IN(SELECT gl_acct_category, gl_control_acct, gl_sub_acct_1   , gl_sub_acct_2  ,
                          gl_sub_acct_3   , gl_sub_acct_4  , gl_sub_acct_5   , gl_sub_acct_6  ,
                          gl_sub_acct_7, gl_acct_name   , rowid, gl_acct_id,
                          gl_acct_category
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
                            || LTRIM (TO_CHAR (gl_sub_acct_7, '09')) gl_acct
                     FROM giac_chart_of_accts
                    WHERE gl_sub_acct_7 = DECODE(v_gl_sub_acct_7, 0, v_gl_sub_acct_7, gl_sub_acct_7)
                      AND gl_sub_acct_6 = DECODE(v_gl_sub_acct_7, 0,
                                            DECODE(v_gl_sub_acct_6, 0, v_gl_sub_acct_6, gl_sub_acct_6),
                                          v_gl_sub_acct_6)
                      AND gl_sub_acct_5 = DECODE(v_gl_sub_acct_7, 0,
                                            DECODE(v_gl_sub_acct_6, 0,
                                              DECODE(v_gl_sub_acct_5, 0, v_gl_sub_acct_5, gl_sub_acct_5),
                                            v_gl_sub_acct_5),
                                          v_gl_sub_acct_5)
                      AND gl_sub_acct_4 = DECODE(v_gl_sub_acct_7, 0,
                                            DECODE(v_gl_sub_acct_6, 0,
                                              DECODE(v_gl_sub_acct_5, 0,
                                                DECODE(v_gl_sub_acct_4, 0, v_gl_sub_acct_4, gl_sub_acct_4),
                                              v_gl_sub_acct_4),
                                            v_gl_sub_acct_4),
                                          v_gl_sub_acct_4)
                      AND gl_sub_acct_3 = DECODE(v_gl_sub_acct_7, 0,
                                            DECODE(v_gl_sub_acct_6, 0,
                                              DECODE(v_gl_sub_acct_5, 0,
                                                DECODE(v_gl_sub_acct_4, 0,
                                                  DECODE(v_gl_sub_acct_3, 0, v_gl_sub_acct_3, gl_sub_acct_3),
                                                v_gl_sub_acct_3),
                                              v_gl_sub_acct_3),
                                            v_gl_sub_acct_3),
                                          v_gl_sub_acct_3)
                      AND gl_sub_acct_2 = DECODE(v_gl_sub_acct_7, 0,
                                            DECODE(v_gl_sub_acct_6, 0,
                                              DECODE(v_gl_sub_acct_5, 0,
                                                DECODE(v_gl_sub_acct_4, 0,
                                                  DECODE(v_gl_sub_acct_3, 0,
                                                    DECODE(v_gl_sub_acct_2, 0, v_gl_sub_acct_2, gl_sub_acct_2),
                                                  v_gl_sub_acct_2),
                                                v_gl_sub_acct_2),
                                              v_gl_sub_acct_2),
                                            v_gl_sub_acct_2),
                                          v_gl_sub_acct_2)
                      AND gl_sub_acct_1 = DECODE(v_gl_sub_acct_7, 0,
                                            DECODE(v_gl_sub_acct_6, 0,
                                              DECODE(v_gl_sub_acct_5, 0,
                                                DECODE(v_gl_sub_acct_4, 0,
                                                  DECODE(v_gl_sub_acct_3, 0,
                                                    DECODE(v_gl_sub_acct_2, 0,
                                                      DECODE(v_gl_sub_acct_1, 0, v_gl_sub_acct_1, gl_sub_acct_1),
                                                    v_gl_sub_acct_1),
                                                  v_gl_sub_acct_1),
                                                v_gl_sub_acct_1),
                                              v_gl_sub_acct_1),
                                            v_gl_sub_acct_1),
                                          v_gl_sub_acct_1)
                     AND gl_control_acct = DECODE(v_gl_sub_acct_7, 0,
                                             DECODE(v_gl_sub_acct_6, 0,
                                               DECODE(v_gl_sub_acct_5, 0,
                                                 DECODE(v_gl_sub_acct_4, 0,
                                                   DECODE(v_gl_sub_acct_3, 0,
                                                     DECODE(v_gl_sub_acct_2, 0,
                                                       DECODE(v_gl_sub_acct_1, 0,
                                                         DECODE(v_gl_control_acct, 0, v_gl_control_acct, gl_control_acct),
                                                       v_gl_control_acct),
                                                     v_gl_control_acct),
                                                   v_gl_control_acct),
                                                 v_gl_control_acct),
                                               v_gl_control_acct),
                                             v_gl_control_acct),
                                           v_gl_control_acct)
                    AND gl_acct_category = DECODE(v_gl_sub_acct_7, 0,
                                             DECODE(v_gl_sub_acct_6, 0,
                                               DECODE(v_gl_sub_acct_5, 0,
                                                 DECODE(v_gl_sub_acct_4, 0,
                                                   DECODE(v_gl_sub_acct_3, 0,
                                                     DECODE(v_gl_sub_acct_2, 0,
                                                       DECODE(v_gl_sub_acct_1, 0,
                                                         DECODE(v_gl_control_acct, 0,
                                                           DECODE(v_gl_acct_category, 0, v_gl_acct_category, gl_acct_category),
                                                        v_gl_acct_category),
                                                      v_gl_acct_category),
                                                    v_gl_acct_category),
                                                  v_gl_acct_category),
                                                v_gl_acct_category),
                                              v_gl_acct_category),
                                            v_gl_acct_category),
                                          v_gl_acct_category)
                    AND rownum = 1
                    ORDER by 1, 2, 3, 4, 5, 6, 7, 8, 9)
          LOOP
            v_gl_acct   := i.gl_acct_id||'-#-'||i.gl_acct||'-#-'||i.gl_acct_name;
          END LOOP;  
      ELSE
          FOR i IN(SELECT gl_acct_category, gl_control_acct, gl_sub_acct_1   , gl_sub_acct_2  ,
                          gl_sub_acct_3   , gl_sub_acct_4  , gl_sub_acct_5   , gl_sub_acct_6  ,
                          gl_sub_acct_7, gl_acct_name  , rowid, gl_acct_id, 
                          gl_acct_category
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
                            || LTRIM (TO_CHAR (gl_sub_acct_7, '09')) gl_acct
                     FROM giac_chart_of_accts
                    WHERE gl_sub_acct_7    = DECODE(v_gl_control_acct, 0, 0,
                                               DECODE(v_gl_sub_acct_1, 0, 0,
                                                 DECODE(v_gl_sub_acct_2, 0, 0,
                                                   DECODE(v_gl_sub_acct_3, 0, 0,
                                                     DECODE(v_gl_sub_acct_4, 0, 0,
                                                       DECODE(v_gl_sub_acct_5, 0, 0,
                                                         DECODE(v_gl_sub_acct_6, 0, 0,
                                                           DECODE(v_gl_sub_acct_7, 0, gl_sub_acct_7, v_gl_sub_acct_7))))))))
                      AND gl_sub_acct_6    = DECODE(v_gl_control_acct, 0, 0,
                                               DECODE(v_gl_sub_acct_1, 0, 0,
                                                 DECODE(v_gl_sub_acct_2, 0, 0,
                                                   DECODE(v_gl_sub_acct_3, 0, 0,
                                                     DECODE(v_gl_sub_acct_4, 0, 0,
                                                       DECODE(v_gl_sub_acct_5, 0, 0,
                                                         DECODE(v_gl_sub_acct_6, 0, v_gl_sub_acct_6, gl_sub_acct_6)))))))
                      AND gl_sub_acct_5    = DECODE(v_gl_control_acct, 0, 0,
                                               DECODE(v_gl_sub_acct_1, 0, 0,
                                                 DECODE(v_gl_sub_acct_2, 0, 0,
                                                   DECODE(v_gl_sub_acct_3, 0, 0,
                                                     DECODE(v_gl_sub_acct_4, 0, 0,
                                                       DECODE(v_gl_sub_acct_5, 0, gl_sub_acct_5, v_gl_sub_acct_5))))))
                      AND gl_sub_acct_4    = DECODE(v_gl_control_acct, 0, 0,
                                               DECODE(v_gl_sub_acct_1, 0, 0,
                                                 DECODE(v_gl_sub_acct_2, 0, 0,
                                                   DECODE(v_gl_sub_acct_3, 0, 0,
                                                     DECODE(v_gl_sub_acct_4, 0, gl_sub_acct_4, v_gl_sub_acct_4)))))
                      AND gl_sub_acct_3    = DECODE(v_gl_control_acct, 0, 0,
                                               DECODE(v_gl_sub_acct_1, 0, 0,
                                                 DECODE(v_gl_sub_acct_2, 0, 0,
                                                   DECODE(v_gl_sub_acct_3, 0, gl_sub_acct_3, v_gl_sub_acct_3))))
                      AND gl_sub_acct_2    = DECODE(v_gl_control_acct, 0, 0,
                                               DECODE(v_gl_sub_acct_1, 0, 0,
                                                 DECODE(v_gl_sub_acct_2, 0, gl_sub_acct_2, v_gl_sub_acct_2)))
                      AND gl_sub_acct_1    = DECODE(v_gl_control_acct, 0, 0,
                                               DECODE(v_gl_sub_acct_1, 0, gl_sub_acct_1, v_gl_sub_acct_1))
                      AND gl_control_acct  = DECODE(v_gl_control_acct, 0, gl_control_acct, v_gl_control_acct)
                      AND gl_acct_category = v_gl_acct_category
                      AND ROWNUM = 1
                 ORDER BY 1, 2, 3, 4, 5, 6, 7, 8, 9)
          LOOP
            v_gl_acct   := i.gl_acct_id||'-#-'||i.gl_acct||'-#-'||i.gl_acct_name;
          END LOOP;         
      END IF;
      RETURN v_gl_acct;     
   END;   

   FUNCTION get_child_rec_list(
      p_gl_acct_id        giac_chart_of_accts.gl_acct_id%TYPE,
      p_mother_gl_acct_id giac_chart_of_accts.gl_acct_id%TYPE,
      p_level             VARCHAR2
   )
      RETURN child_tab PIPELINED
   IS
      v_gl_acct_category  giac_chart_of_accts.gl_acct_category%TYPE;
      v_gl_control_acct   giac_chart_of_accts.gl_control_acct%TYPE;
      v_gl_sub_acct_1     giac_chart_of_accts.gl_sub_acct_1%TYPE;
      v_gl_sub_acct_2     giac_chart_of_accts.gl_sub_acct_2%TYPE;
      v_gl_sub_acct_3     giac_chart_of_accts.gl_sub_acct_3%TYPE;
      v_gl_sub_acct_4     giac_chart_of_accts.gl_sub_acct_4%TYPE;
      v_gl_sub_acct_5     giac_chart_of_accts.gl_sub_acct_5%TYPE;
      v_gl_sub_acct_6     giac_chart_of_accts.gl_sub_acct_6%TYPE;
      v_gl_sub_acct_7     giac_chart_of_accts.gl_sub_acct_7%TYPE;
      v_rec               child_type;
   BEGIN
      BEGIN
        SELECT gl_acct_category, gl_control_acct, gl_sub_acct_1   , gl_sub_acct_2  ,
               gl_sub_acct_3   , gl_sub_acct_4  , gl_sub_acct_5   , gl_sub_acct_6  ,
               gl_sub_acct_7   
          INTO v_gl_acct_category, v_gl_control_acct, v_gl_sub_acct_1, v_gl_sub_acct_2,
               v_gl_sub_acct_3, v_gl_sub_acct_4, v_gl_sub_acct_5, v_gl_sub_acct_6, v_gl_sub_acct_7
          FROM giac_chart_of_accts a
         WHERE a.gl_acct_id = p_gl_acct_id;
      END;
      
      IF p_level = 'next'
      THEN
          FOR i IN(SELECT gl_acct_category, gl_control_acct,
                          gl_sub_acct_1   , gl_sub_acct_2  ,
                          gl_sub_acct_3   , gl_sub_acct_4  ,
                          gl_sub_acct_5   , gl_sub_acct_6  ,
                          gl_sub_acct_7   , gl_acct_sname  , gl_acct_name,
                          gl_acct_id, leaf_tag, gslt_sl_type_cd,
                          dr_cr_tag, acct_type, ref_acct_cd, user_id, last_update
                     FROM giac_chart_of_accts
                    WHERE gl_sub_acct_7    = DECODE(v_gl_control_acct, 0, 0,
                                               DECODE(v_gl_sub_acct_1, 0, 0,
                                                 DECODE(v_gl_sub_acct_2, 0, 0,
                                                   DECODE(v_gl_sub_acct_3, 0, 0,
                                                     DECODE(v_gl_sub_acct_4, 0, 0,
                                                       DECODE(v_gl_sub_acct_5, 0, 0,
                                                         DECODE(v_gl_sub_acct_6, 0, 0,
                                                           DECODE(v_gl_sub_acct_7, 0, gl_sub_acct_7, v_gl_sub_acct_7))))))))
                      AND gl_sub_acct_6    = DECODE(v_gl_control_acct, 0, 0,
                                               DECODE(v_gl_sub_acct_1, 0, 0,
                                                 DECODE(v_gl_sub_acct_2, 0, 0,
                                                   DECODE(v_gl_sub_acct_3, 0, 0,
                                                     DECODE(v_gl_sub_acct_4, 0, 0,
                                                       DECODE(v_gl_sub_acct_5, 0, 0,
                                                         DECODE(v_gl_sub_acct_6, 0, v_gl_sub_acct_6, gl_sub_acct_6)))))))
                      AND gl_sub_acct_5    = DECODE(v_gl_control_acct, 0, 0,
                                               DECODE(v_gl_sub_acct_1, 0, 0,
                                                 DECODE(v_gl_sub_acct_2, 0, 0,
                                                   DECODE(v_gl_sub_acct_3, 0, 0,
                                                     DECODE(v_gl_sub_acct_4, 0, 0,
                                                       DECODE(v_gl_sub_acct_5, 0, gl_sub_acct_5, v_gl_sub_acct_5))))))
                      AND gl_sub_acct_4    = DECODE(v_gl_control_acct, 0, 0,
                                                DECODE(v_gl_sub_acct_1, 0, 0,
                                                  DECODE(v_gl_sub_acct_2, 0, 0,
                                                    DECODE(v_gl_sub_acct_3, 0, 0,
                                                      DECODE(v_gl_sub_acct_4, 0, gl_sub_acct_4, v_gl_sub_acct_4)))))
                       AND gl_sub_acct_3    = DECODE(v_gl_control_acct, 0, 0,
                                                DECODE(v_gl_sub_acct_1, 0, 0,
                                                  DECODE(v_gl_sub_acct_2, 0, 0,
                                                    DECODE(v_gl_sub_acct_3, 0, gl_sub_acct_3, v_gl_sub_acct_3))))
                       AND gl_sub_acct_2    = DECODE(v_gl_control_acct, 0, 0,
                                                DECODE(v_gl_sub_acct_1, 0, 0,
                                                  DECODE(v_gl_sub_acct_2, 0, gl_sub_acct_2, v_gl_sub_acct_2)))
                       AND gl_sub_acct_1    = DECODE(v_gl_control_acct, 0, 0,
                                                DECODE(v_gl_sub_acct_1, 0, gl_sub_acct_1, v_gl_sub_acct_1))
                       AND gl_control_acct  = DECODE(v_gl_control_acct, 0, gl_control_acct, v_gl_control_acct)
                       AND gl_acct_category = v_gl_acct_category
                       AND gl_acct_id <> p_mother_gl_acct_id
                     ORDER by 1, 2, 3, 4, 5, 6, 7, 8, 9)
          LOOP
             v_rec.gl_acct_id        := i.gl_acct_id;
             v_rec.gl_acct_category  := i.gl_acct_category;
             v_rec.gl_control_acct   := i.gl_control_acct;
             v_rec.gl_sub_acct_1     := i.gl_sub_acct_1;
             v_rec.gl_sub_acct_2     := i.gl_sub_acct_2;
             v_rec.gl_sub_acct_3     := i.gl_sub_acct_3;
             v_rec.gl_sub_acct_4     := i.gl_sub_acct_4;
             v_rec.gl_sub_acct_5     := i.gl_sub_acct_5;
             v_rec.gl_sub_acct_6     := i.gl_sub_acct_6;
             v_rec.gl_sub_acct_7     := i.gl_sub_acct_7;
             v_rec.gl_acct_name      := i.gl_acct_name;
             v_rec.gl_acct_sname     := i.gl_acct_sname;  
             v_rec.leaf_tag          := i.leaf_tag;
             v_rec.gslt_sl_type_cd   := i.gslt_sl_type_cd;
             v_rec.dr_cr_tag         := i.dr_cr_tag;
             v_rec.acct_type         := i.acct_type;
             v_rec.ref_acct_cd       := i.ref_acct_cd;
             v_rec.user_id           := i.user_id;
             v_rec.last_update       := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');   
             
             IF i.gslt_sl_type_cd IS NOT NULL
             THEN
                 SELECT gslt.sl_type_name
                   INTO v_rec.dsp_sl_type_name
                   FROM giac_sl_types gslt
                  WHERE gslt.sl_type_cd = i.gslt_sl_type_cd;
             END IF;                         
             
             PIPE ROW(v_rec);         
          END LOOP;         
      ELSE
          FOR i IN(SELECT gl_acct_category, gl_control_acct,
                          gl_sub_acct_1   , gl_sub_acct_2  ,
                          gl_sub_acct_3   , gl_sub_acct_4  ,
                          gl_sub_acct_5   , gl_sub_acct_6  ,
                          gl_sub_acct_7   , gl_acct_sname  , gl_acct_name,
                          gl_acct_id, leaf_tag, gslt_sl_type_cd,
                          dr_cr_tag, acct_type, ref_acct_cd, user_id, last_update
                  FROM giac_chart_of_accts
                 WHERE gl_sub_acct_7 = DECODE(v_gl_sub_acct_7, 0, v_gl_sub_acct_7, gl_sub_acct_7)
                   AND gl_sub_acct_6 = DECODE(v_gl_sub_acct_7, 0,
                                         DECODE(v_gl_sub_acct_6, 0, v_gl_sub_acct_6, gl_sub_acct_6),
                                       v_gl_sub_acct_6)
                   AND gl_sub_acct_5 = DECODE(v_gl_sub_acct_7, 0,
                                         DECODE(v_gl_sub_acct_6, 0,
                                           DECODE(v_gl_sub_acct_5, 0, v_gl_sub_acct_5, gl_sub_acct_5),
                                         v_gl_sub_acct_5),
                                       v_gl_sub_acct_5)
                   AND gl_sub_acct_4 = DECODE(v_gl_sub_acct_7, 0,
                                         DECODE(v_gl_sub_acct_6, 0,
                                           DECODE(v_gl_sub_acct_5, 0,
                                             DECODE(v_gl_sub_acct_4, 0, v_gl_sub_acct_4, gl_sub_acct_4),
                                           v_gl_sub_acct_4),
                                         v_gl_sub_acct_4),
                                       v_gl_sub_acct_4)
                   AND gl_sub_acct_3 = DECODE(v_gl_sub_acct_7, 0,
                                         DECODE(v_gl_sub_acct_6, 0,
                                           DECODE(v_gl_sub_acct_5, 0,
                                             DECODE(v_gl_sub_acct_4, 0,
                                               DECODE(v_gl_sub_acct_3, 0, v_gl_sub_acct_3, gl_sub_acct_3),
                                             v_gl_sub_acct_3),
                                           v_gl_sub_acct_3),
                                         v_gl_sub_acct_3),
                                       v_gl_sub_acct_3)
                   AND gl_sub_acct_2 = DECODE(v_gl_sub_acct_7, 0,
                                         DECODE(v_gl_sub_acct_6, 0,
                                           DECODE(v_gl_sub_acct_5, 0,
                                             DECODE(v_gl_sub_acct_4, 0,
                                               DECODE(v_gl_sub_acct_3, 0,
                                                 DECODE(v_gl_sub_acct_2, 0, v_gl_sub_acct_2, gl_sub_acct_2),
                                               v_gl_sub_acct_2),
                                             v_gl_sub_acct_2),
                                           v_gl_sub_acct_2),
                                         v_gl_sub_acct_2),
                                       v_gl_sub_acct_2)
                   AND gl_sub_acct_1 = DECODE(v_gl_sub_acct_7, 0,
                                         DECODE(v_gl_sub_acct_6, 0,
                                           DECODE(v_gl_sub_acct_5, 0,
                                             DECODE(v_gl_sub_acct_4, 0,
                                               DECODE(v_gl_sub_acct_3, 0,
                                                 DECODE(v_gl_sub_acct_2, 0,
                                                   DECODE(v_gl_sub_acct_1, 0, v_gl_sub_acct_1, gl_sub_acct_1),
                                                 v_gl_sub_acct_1),
                                               v_gl_sub_acct_1),
                                             v_gl_sub_acct_1),
                                           v_gl_sub_acct_1),
                                         v_gl_sub_acct_1),
                                        v_gl_sub_acct_1)
                   AND gl_control_acct = DECODE(v_gl_sub_acct_7, 0,
                                           DECODE(v_gl_sub_acct_6, 0,
                                             DECODE(v_gl_sub_acct_5, 0,
                                               DECODE(v_gl_sub_acct_4, 0,
                                                 DECODE(v_gl_sub_acct_3, 0,
                                                   DECODE(v_gl_sub_acct_2, 0,
                                                     DECODE(v_gl_sub_acct_1, 0,
                                                       DECODE(v_gl_control_acct, 0, v_gl_control_acct, gl_control_acct),
                                                     v_gl_control_acct),
                                                   v_gl_control_acct),
                                                 v_gl_control_acct),
                                               v_gl_control_acct),
                                             v_gl_control_acct),
                                           v_gl_control_acct),
                                         v_gl_control_acct)
                   AND gl_acct_category = DECODE(v_gl_sub_acct_7, 0,
                                            DECODE(v_gl_sub_acct_6, 0,
                                              DECODE(v_gl_sub_acct_5, 0,
                                                DECODE(v_gl_sub_acct_4, 0,
                                                  DECODE(v_gl_sub_acct_3, 0,
                                                    DECODE(v_gl_sub_acct_2, 0,
                                                      DECODE(v_gl_sub_acct_1, 0,
                                                        DECODE(v_gl_control_acct, 0,
                                                          DECODE(v_gl_acct_category, 0, v_gl_acct_category, gl_acct_category),
                                                        v_gl_acct_category),
                                                      v_gl_acct_category),
                                                    v_gl_acct_category),
                                                  v_gl_acct_category),
                                                v_gl_acct_category),
                                              v_gl_acct_category),
                                            v_gl_acct_category),
                                         v_gl_acct_category)
                      AND gl_acct_id <> p_mother_gl_acct_id
                 ORDER by 1, 2, 3, 4, 5, 6, 7, 8, 9)
          LOOP
             v_rec.gl_acct_id        := i.gl_acct_id;
             v_rec.gl_acct_category  := i.gl_acct_category;
             v_rec.gl_control_acct   := i.gl_control_acct;
             v_rec.gl_sub_acct_1     := i.gl_sub_acct_1;
             v_rec.gl_sub_acct_2     := i.gl_sub_acct_2;
             v_rec.gl_sub_acct_3     := i.gl_sub_acct_3;
             v_rec.gl_sub_acct_4     := i.gl_sub_acct_4;
             v_rec.gl_sub_acct_5     := i.gl_sub_acct_5;
             v_rec.gl_sub_acct_6     := i.gl_sub_acct_6;
             v_rec.gl_sub_acct_7     := i.gl_sub_acct_7;
             v_rec.gl_acct_name      := i.gl_acct_name;
             v_rec.gl_acct_sname     := i.gl_acct_sname;
             v_rec.leaf_tag          := i.leaf_tag;
             v_rec.gslt_sl_type_cd   := i.gslt_sl_type_cd;
             v_rec.dr_cr_tag         := i.dr_cr_tag;
             v_rec.acct_type         := i.acct_type;
             v_rec.ref_acct_cd       := i.ref_acct_cd;
             v_rec.user_id           := i.user_id;
             v_rec.last_update       := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM'); 

             IF i.gslt_sl_type_cd IS NOT NULL
             THEN
                 SELECT gslt.sl_type_name
                   INTO v_rec.dsp_sl_type_name
                   FROM giac_sl_types gslt
                  WHERE gslt.sl_type_cd = i.gslt_sl_type_cd;
             END IF; 
                                  
             PIPE ROW(v_rec);         
          END LOOP;  
      END IF;   
   END;     

    FUNCTION get_incremented_level (p_gl_acct_id giac_chart_of_accts.gl_acct_id%TYPE, p_level VARCHAR2)
       RETURN VARCHAR2
    IS
       v_gl_acct_category   giac_chart_of_accts.gl_acct_category%TYPE;
       v_gl_control_acct    giac_chart_of_accts.gl_control_acct%TYPE;
       v_gl_sub_acct_1      giac_chart_of_accts.gl_sub_acct_1%TYPE;
       v_gl_sub_acct_2      giac_chart_of_accts.gl_sub_acct_2%TYPE;
       v_gl_sub_acct_3      giac_chart_of_accts.gl_sub_acct_3%TYPE;
       v_gl_sub_acct_4      giac_chart_of_accts.gl_sub_acct_4%TYPE;
       v_gl_sub_acct_5      giac_chart_of_accts.gl_sub_acct_5%TYPE;
       v_gl_sub_acct_6      giac_chart_of_accts.gl_sub_acct_6%TYPE;
       v_gl_sub_acct_7      giac_chart_of_accts.gl_sub_acct_7%TYPE;
       v_rec                VARCHAR2 (100);
    BEGIN
       BEGIN
          SELECT gl_acct_category, gl_control_acct, gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7
            INTO v_gl_acct_category, v_gl_control_acct, v_gl_sub_acct_1, v_gl_sub_acct_2, v_gl_sub_acct_3, v_gl_sub_acct_4, v_gl_sub_acct_5, v_gl_sub_acct_6, v_gl_sub_acct_7
            FROM giac_chart_of_accts
           WHERE gl_acct_id = p_gl_acct_id;
       END;

       IF p_level = 'next' THEN
          IF v_gl_sub_acct_7 = 0 THEN                                                                                                                                                                   --7
             IF v_gl_sub_acct_6 = 0 THEN                                                                                                                                                                --6
                IF v_gl_sub_acct_5 = 0 THEN                                                                                                                                                             --5
                   IF v_gl_sub_acct_4 = 0 THEN                                                                                                                                                          --4
                      IF v_gl_sub_acct_3 = 0 THEN                                                                                                                                                       --3
                         IF v_gl_sub_acct_2 = 0 THEN                                                                                                                                                    --2
                            IF v_gl_sub_acct_1 = 0 THEN                                                                                                                                                 --1
                               IF v_gl_control_acct = 0 THEN                                                                                                                                            --b
                                  IF v_gl_acct_category > 0 THEN                                                                                                                                        --a
                                     BEGIN
                                        SELECT MAX (DISTINCT gl_control_acct) + 1 || '-#-GlControlAcct'
                                          INTO v_rec
                                          FROM giac_chart_of_accts
                                         WHERE gl_acct_category = v_gl_acct_category;
                                     EXCEPTION
                                        WHEN NO_DATA_FOUND THEN
                                           NULL;
                                     END;
                                  END IF;                                                                                                                                                           -- END a
                               ELSE                                                                                                                                                                      --b
                                  BEGIN
                                     SELECT MAX (DISTINCT gl_sub_acct_1) + 1 || '-#-GlSubAcct1'
                                       INTO v_rec
                                       FROM giac_chart_of_accts
                                      WHERE gl_acct_category = v_gl_acct_category 
                                        AND gl_control_acct = v_gl_control_acct;
                                  EXCEPTION
                                     WHEN NO_DATA_FOUND THEN
                                        NULL;
                                  END;
                               END IF;                                                                                                                                                               --END b
                            ELSE                                                                                                                                                                         --1
                               BEGIN
                                  SELECT MAX (DISTINCT gl_sub_acct_2) + 1 || '-#-GlSubAcct2'
                                    INTO v_rec
                                    FROM giac_chart_of_accts
                                   WHERE gl_acct_category = v_gl_acct_category 
                                     AND gl_control_acct = v_gl_control_acct 
                                     AND gl_sub_acct_1 = v_gl_sub_acct_1;
                               EXCEPTION
                                  WHEN NO_DATA_FOUND THEN
                                     NULL;
                               END;
                            END IF;                                                                                                                                                                  --END 1
                         ELSE                                                                                                                                                                            --2
                            BEGIN
                               SELECT MAX (DISTINCT gl_sub_acct_3) + 1 || '-#-GlSubAcct3'
                                 INTO v_rec
                                 FROM giac_chart_of_accts
                                WHERE gl_acct_category = v_gl_acct_category 
                                  AND gl_control_acct = v_gl_control_acct 
                                  AND gl_sub_acct_1 = v_gl_sub_acct_1 
                                  AND gl_sub_acct_2 = v_gl_sub_acct_2;
                            EXCEPTION
                               WHEN NO_DATA_FOUND THEN
                                  NULL;
                            END;
                         END IF;                                                                                                                                                                     --END 2
                      ELSE                                                                                                                                                                               --3
                         BEGIN
                            SELECT MAX (DISTINCT gl_sub_acct_4) + 1 || '-#-GlSubAcct4'
                              INTO v_rec
                              FROM giac_chart_of_accts
                             WHERE gl_acct_category = v_gl_acct_category
                               AND gl_control_acct = v_gl_control_acct
                               AND gl_sub_acct_1 = v_gl_sub_acct_1
                               AND gl_sub_acct_2 = v_gl_sub_acct_2
                               AND gl_sub_acct_3 = v_gl_sub_acct_3;
                         EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                               NULL;
                         END;
                      END IF;                                                                                                                                                                        --END 3
                   ELSE                                                                                                                                                                                  --4
                      BEGIN
                         SELECT MAX (DISTINCT gl_sub_acct_5) + 1 || '-#-GlSubAcct5'
                           INTO v_rec
                           FROM giac_chart_of_accts
                          WHERE gl_acct_category = v_gl_acct_category
                            AND gl_control_acct = v_gl_control_acct
                            AND gl_sub_acct_1 = v_gl_sub_acct_1
                            AND gl_sub_acct_2 = v_gl_sub_acct_2
                            AND gl_sub_acct_3 = v_gl_sub_acct_3
                            AND gl_sub_acct_4 = v_gl_sub_acct_4;
                      EXCEPTION
                         WHEN NO_DATA_FOUND THEN
                            NULL;
                      END;
                   END IF;                                                                                                                                                                           --END 4
                ELSE                                                                                                                                                                                     --5
                   BEGIN
                      SELECT MAX (DISTINCT gl_sub_acct_6) + 1 || '-#-GlSubAcct6'
                        INTO v_rec
                        FROM giac_chart_of_accts
                       WHERE gl_acct_category = v_gl_acct_category
                         AND gl_control_acct = v_gl_control_acct
                         AND gl_sub_acct_1 = v_gl_sub_acct_1
                         AND gl_sub_acct_2 = v_gl_sub_acct_2
                         AND gl_sub_acct_3 = v_gl_sub_acct_3
                         AND gl_sub_acct_4 = v_gl_sub_acct_4
                         AND gl_sub_acct_5 = v_gl_sub_acct_5;
                   EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                         NULL;
                   END;
                END IF;                                                                                                                                                                              --END 5
             ELSE                                                                                                                                                                                        --6
                BEGIN
                   SELECT MAX (DISTINCT gl_sub_acct_7) + 1 || '-#-GlSubAcct7'
                     INTO v_rec
                     FROM giac_chart_of_accts
                    WHERE gl_acct_category = v_gl_acct_category
                      AND gl_control_acct = v_gl_control_acct
                      AND gl_sub_acct_1 = v_gl_sub_acct_1
                      AND gl_sub_acct_2 = v_gl_sub_acct_2
                      AND gl_sub_acct_3 = v_gl_sub_acct_3
                      AND gl_sub_acct_4 = v_gl_sub_acct_4
                      AND gl_sub_acct_5 = v_gl_sub_acct_5
                      AND gl_sub_acct_6 = v_gl_sub_acct_6;
                EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                      NULL;
                END;
             END IF;                                                                                                                                                                                 --END 6
          END IF;                                                                                                                                                                                    --END 7
       ELSE
          IF v_gl_sub_acct_7 = 0 THEN
             IF v_gl_sub_acct_6 = 0 THEN
                IF v_gl_sub_acct_5 = 0 THEN
                   IF v_gl_sub_acct_4 = 0 THEN
                      IF v_gl_sub_acct_3 = 0 THEN
                         IF v_gl_sub_acct_2 = 0 THEN
                            IF v_gl_sub_acct_1 = 0 THEN
                               IF v_gl_control_acct = 0 THEN
                                  IF v_gl_acct_category > 0 THEN
                                     BEGIN
                                        SELECT MAX (DISTINCT gl_acct_category) + 1 || '-#-GlAcctCategory'
                                          INTO v_rec
                                          FROM giac_chart_of_accts;
                                     EXCEPTION
                                        WHEN NO_DATA_FOUND THEN
                                           NULL;
                                     END;
                                  END IF;
                               ELSE
                                  BEGIN
                                     SELECT MAX (DISTINCT gl_control_acct) + 1 || '-#-GlControlAcct'
                                       INTO v_rec
                                       FROM giac_chart_of_accts
                                      WHERE gl_acct_category = v_gl_acct_category;
                                  EXCEPTION
                                     WHEN NO_DATA_FOUND THEN
                                        NULL;
                                  END;
                               END IF;
                            ELSE
                               BEGIN
                                  SELECT MAX (DISTINCT gl_sub_acct_1) + 1 || '-#-GlSubAcct1'
                                    INTO v_rec
                                    FROM giac_chart_of_accts
                                   WHERE gl_acct_category = v_gl_acct_category 
                                     AND gl_control_acct = v_gl_control_acct;
                               EXCEPTION
                                  WHEN NO_DATA_FOUND THEN
                                     NULL;
                               END;
                            END IF;
                         ELSE
                            BEGIN
                               SELECT MAX (DISTINCT gl_sub_acct_2) + 1 || '-#-GlSubAcct2'
                                 INTO v_rec
                                 FROM giac_chart_of_accts
                                WHERE gl_acct_category = v_gl_acct_category 
                                  AND gl_control_acct = v_gl_control_acct 
                                  AND gl_sub_acct_1 = v_gl_sub_acct_1;
                            EXCEPTION
                               WHEN NO_DATA_FOUND THEN
                                  NULL;
                            END;
                         END IF;
                      ELSE
                         BEGIN
                            SELECT MAX (DISTINCT gl_sub_acct_3) + 1 || '-#-GlSubAcct3'
                              INTO v_rec
                              FROM giac_chart_of_accts
                             WHERE gl_acct_category = v_gl_acct_category 
                               AND gl_control_acct = v_gl_control_acct 
                               AND gl_sub_acct_1 = v_gl_sub_acct_1 
                               AND gl_sub_acct_2 = v_gl_sub_acct_2;
                         EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                               NULL;
                         END;
                      END IF;
                   ELSE
                      BEGIN
                         SELECT MAX (DISTINCT gl_sub_acct_4) + 1 || '-#-GlSubAcct4'
                           INTO v_rec
                           FROM giac_chart_of_accts
                          WHERE gl_acct_category = v_gl_acct_category
                            AND gl_control_acct = v_gl_control_acct
                            AND gl_sub_acct_1 = v_gl_sub_acct_1
                            AND gl_sub_acct_2 = v_gl_sub_acct_2
                            AND gl_sub_acct_3 = v_gl_sub_acct_3;
                      EXCEPTION
                         WHEN NO_DATA_FOUND THEN
                            NULL;
                      END;
                   END IF;
                ELSE
                   BEGIN
                      SELECT MAX (DISTINCT gl_sub_acct_5) + 1 || '-#-GlSubAcct5'
                        INTO v_rec
                        FROM giac_chart_of_accts
                       WHERE gl_acct_category = v_gl_acct_category
                         AND gl_control_acct = v_gl_control_acct
                         AND gl_sub_acct_1 = v_gl_sub_acct_1
                         AND gl_sub_acct_2 = v_gl_sub_acct_2
                         AND gl_sub_acct_3 = v_gl_sub_acct_3
                         AND gl_sub_acct_4 = v_gl_sub_acct_4;
                   EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                         NULL;
                   END;
                END IF;
             ELSE
                BEGIN
                   SELECT MAX (DISTINCT gl_sub_acct_6) + 1 || '-#-GlSubAcct6'
                     INTO v_rec
                     FROM giac_chart_of_accts
                    WHERE gl_acct_category = v_gl_acct_category
                      AND gl_control_acct = v_gl_control_acct
                      AND gl_sub_acct_1 = v_gl_sub_acct_1
                      AND gl_sub_acct_2 = v_gl_sub_acct_2
                      AND gl_sub_acct_3 = v_gl_sub_acct_3
                      AND gl_sub_acct_4 = v_gl_sub_acct_4
                      AND gl_sub_acct_5 = v_gl_sub_acct_5;
                EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                      NULL;
                END;
             END IF;
          ELSE
             BEGIN
                SELECT MAX (DISTINCT gl_sub_acct_7) + 1
                  INTO v_rec
                  FROM giac_chart_of_accts
                 WHERE gl_acct_category = v_gl_acct_category
                   AND gl_control_acct = v_gl_control_acct
                   AND gl_sub_acct_1 = v_gl_sub_acct_1
                   AND gl_sub_acct_2 = v_gl_sub_acct_2
                   AND gl_sub_acct_3 = v_gl_sub_acct_3
                   AND gl_sub_acct_4 = v_gl_sub_acct_4
                   AND gl_sub_acct_5 = v_gl_sub_acct_5
                   AND gl_sub_acct_6 = v_gl_sub_acct_6;
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   NULL;
             END;
             v_rec := v_rec + 1 || '-#-GlSubAcct7';
          END IF;
       END IF;
       RETURN (v_rec);
    END;    
            
   PROCEDURE set_rec (p_rec giac_chart_of_accts%ROWTYPE)
   IS
      v_gl_acct_id  giac_chart_of_accts.gl_acct_id%TYPE;
      v_temp        giac_chart_of_accts.gl_acct_id%TYPE;    
   BEGIN
      BEGIN 
        SELECT gl_acct_id
          INTO v_temp
          FROM giac_chart_of_accts
         WHERE gl_acct_id = p_rec.gl_acct_id;
      EXCEPTION 
        WHEN NO_DATA_FOUND THEN
          BEGIN
            SELECT MAX(gl_acct_id) + 1
              INTO v_gl_acct_id
              FROM giac_chart_of_accts;
          END;
      END;
   
      MERGE INTO giac_chart_of_accts
         USING DUAL
         ON (gl_acct_id = p_rec.gl_acct_id)
         WHEN NOT MATCHED THEN
            INSERT (gl_acct_id, 
                    gl_acct_category, gl_control_acct, gl_sub_acct_1,
                    gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4,
                    gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7,
                    sub_acct_2_tag, sub_acct_3_tag, sub_acct_4_tag,
                    sub_acct_5_tag, sub_acct_6_tag, sub_acct_7_tag,
                    gl_acct_name, gl_acct_sname, leaf_tag,
                    dr_cr_tag, acct_type, ref_acct_cd, 
                    gslt_sl_type_cd, user_id, last_update)
            VALUES (v_gl_acct_id, 
                    p_rec.gl_acct_category, p_rec.gl_control_acct, p_rec.gl_sub_acct_1,
                    p_rec.gl_sub_acct_2, p_rec.gl_sub_acct_3, p_rec.gl_sub_acct_4, 
                    p_rec.gl_sub_acct_5, p_rec.gl_sub_acct_6, p_rec.gl_sub_acct_7,
                    'N'                , 'N'                , 'N',
                    'N'                , 'N'                , 'N',
                    p_rec.gl_acct_name, p_rec.gl_acct_sname, p_rec.leaf_tag,
                    p_rec.dr_cr_tag, p_rec.acct_type, p_rec.ref_acct_cd,
                    p_rec.gslt_sl_type_cd, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET gl_acct_category = p_rec.gl_acct_category,
                   gl_control_acct  = p_rec.gl_control_acct,
                   gl_sub_acct_1    = p_rec.gl_sub_acct_1,
                   gl_sub_acct_2    = p_rec.gl_sub_acct_2,
                   gl_sub_acct_3    = p_rec.gl_sub_acct_3,
                   gl_sub_acct_4    = p_rec.gl_sub_acct_4,
                   gl_sub_acct_5    = p_rec.gl_sub_acct_5,
                   gl_sub_acct_6    = p_rec.gl_sub_acct_6,
                   gl_sub_acct_7    = p_rec.gl_sub_acct_7,
                   gl_acct_name     = p_rec.gl_acct_name,
                   gl_acct_sname    = p_rec.gl_acct_sname,
                   leaf_tag         = p_rec.leaf_tag,
                   gslt_sl_type_cd  = p_rec.gslt_sl_type_cd,
                   dr_cr_tag        = p_rec.dr_cr_tag,
                   acct_type        = p_rec.acct_type,
                   ref_acct_cd      = p_rec.ref_acct_cd,
                   user_id          = p_rec.user_id, 
                   last_update      = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_gl_acct_id giac_chart_of_accts.gl_acct_id%TYPE)
   AS
   BEGIN
      DELETE FROM giac_chart_of_accts
            WHERE gl_acct_id = p_gl_acct_id;
   END;

   PROCEDURE val_del_rec (p_gl_acct_id giac_chart_of_accts.gl_acct_id%TYPE)
   AS
      v_exists            VARCHAR2 (1);      
      v_gl_acct_category  giac_chart_of_accts.gl_acct_category%TYPE;
      v_gl_control_acct   giac_chart_of_accts.gl_control_acct%TYPE;
      v_gl_sub_acct_1     giac_chart_of_accts.gl_sub_acct_1%TYPE;
      v_gl_sub_acct_2     giac_chart_of_accts.gl_sub_acct_2%TYPE;
      v_gl_sub_acct_3     giac_chart_of_accts.gl_sub_acct_3%TYPE;
      v_gl_sub_acct_4     giac_chart_of_accts.gl_sub_acct_4%TYPE;
      v_gl_sub_acct_5     giac_chart_of_accts.gl_sub_acct_5%TYPE;
      v_gl_sub_acct_6     giac_chart_of_accts.gl_sub_acct_6%TYPE;
      v_gl_sub_acct_7     giac_chart_of_accts.gl_sub_acct_7%TYPE;
      v_select            VARCHAR2 (500);
      v_out               VARCHAR2 (50);
   BEGIN
        BEGIN
            SELECT gl_acct_category, gl_control_acct, gl_sub_acct_1   , gl_sub_acct_2  ,
                   gl_sub_acct_3   , gl_sub_acct_4  , gl_sub_acct_5   , gl_sub_acct_6  ,
                   gl_sub_acct_7   
              INTO v_gl_acct_category, v_gl_control_acct, v_gl_sub_acct_1, v_gl_sub_acct_2,
                   v_gl_sub_acct_3, v_gl_sub_acct_4, v_gl_sub_acct_5, v_gl_sub_acct_6, v_gl_sub_acct_7
              FROM giac_chart_of_accts a
             WHERE a.gl_acct_id = p_gl_acct_id;
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
            NULL;     
        END; 
          
        FOR i IN (SELECT 'Y'
                  FROM giac_policy_type_entries
                 WHERE gl_sub_acct_1 = v_gl_sub_acct_1
                   AND gl_sub_acct_2 = v_gl_sub_acct_2
                   AND gl_sub_acct_3 = v_gl_sub_acct_3
                   AND gl_sub_acct_4 = v_gl_sub_acct_4
                   AND gl_sub_acct_5 = v_gl_sub_acct_5
                   AND gl_sub_acct_6 = v_gl_sub_acct_6
                   AND gl_sub_acct_7 = v_gl_sub_acct_7
                   AND rownum = 1)
        LOOP
            v_exists := 'Y';
            EXIT;
        END LOOP; 
                                  
        IF v_exists = 'Y'
        THEN
            raise_application_error (-20001,
                                      'Geniisys Exception#E#Cannot delete record from GIAC_CHART_OF_ACCTS while dependent record(s) in GIAC_POLICY_TYPE_ENTRIES exists.'
                                    );       
        ELSE
            FOR i IN (SELECT table_name
                       FROM all_constraints
                      WHERE r_constraint_name IN (SELECT constraint_name
                                                    FROM all_constraints
                                                   WHERE table_name = 'GIAC_CHART_OF_ACCTS'))
            LOOP
                v_select := 'SELECT DISTINCT '''
                            || i.table_name
                            || ''' FROM '
                            || i.table_name
                            || ' WHERE gl_acct_id = '
                            || p_gl_acct_id
                            || '';

                BEGIN
                    EXECUTE IMMEDIATE v_select INTO v_out;
                EXIT;
                EXCEPTION
                    WHEN NO_DATA_FOUND
                    THEN
                        v_out := '';
                END;
            END LOOP;

            IF v_out IS NOT NULL
            THEN
              raise_application_error (-20001,
                                        'Geniisys Exception#E#Cannot delete record from GIAC_CHART_OF_ACCTS while dependent record(s) in '
                                        || UPPER(v_out)
                                        || ' exists.'
                                      );
            END IF;                                                
        END IF;  
   END;

   PROCEDURE val_update_rec (p_gl_acct_id giac_chart_of_accts.gl_acct_id%TYPE)
   AS
      v_exists   VARCHAR2 (1);      
   BEGIN
      FOR i IN (SELECT gl_acct_id
                  FROM giac_acct_entries
                 WHERE gl_acct_id = p_gl_acct_id)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;      

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#SL Type cannot be changed. GL Account has transactions.'
                                 );
      END IF;
   END;
   
   PROCEDURE val_add_rec (
      p_tran              VARCHAR2,
      p_gl_acct_category  giac_chart_of_accts.gl_acct_category%TYPE,
      p_gl_control_acct   giac_chart_of_accts.gl_control_acct%TYPE,
      p_gl_sub_acct_1     giac_chart_of_accts.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2     giac_chart_of_accts.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3     giac_chart_of_accts.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4     giac_chart_of_accts.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5     giac_chart_of_accts.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6     giac_chart_of_accts.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7     giac_chart_of_accts.gl_sub_acct_7%TYPE,
      p_gl_acct_id        giac_chart_of_accts.gl_acct_id%TYPE
   )
   AS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
      IF p_tran = 'ADD'
      THEN
          FOR i IN (SELECT '1'
                      FROM giac_chart_of_accts a
                     WHERE a.gl_acct_category = p_gl_acct_category
                       AND a.gl_control_acct = p_gl_control_acct
                       AND a.gl_sub_acct_1 = p_gl_sub_acct_1
                       AND a.gl_sub_acct_2 = p_gl_sub_acct_2
                       AND a.gl_sub_acct_3 = p_gl_sub_acct_3
                       AND a.gl_sub_acct_4 = p_gl_sub_acct_4
                       AND a.gl_sub_acct_5 = p_gl_sub_acct_5
                       AND a.gl_sub_acct_6 = p_gl_sub_acct_6
                       AND a.gl_sub_acct_7 = p_gl_sub_acct_7
                       AND rownum = 1)
          LOOP
             v_exists := 'Y';
             EXIT;
          END LOOP;      

          IF v_exists = 'Y'
          THEN
             raise_application_error (-20001,
                                      'Geniisys Exception#E#Record already exists with the same gl_acct_category, gl_control_acct, gl_sub_acct_1, '||
                                      'gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6 and gl_sub_acct_7.'
                                     );
          END IF;           
      END IF;
   END;
END;
/


