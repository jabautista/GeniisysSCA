CREATE OR REPLACE PACKAGE BODY CPI.giiss043_pkg
AS
   FUNCTION get_bond_class
      RETURN bond_class_tab PIPELINED
   IS
      v_list bond_class_type;
   BEGIN 
      FOR i IN (SELECT *
                  FROM giis_bond_class
              ORDER BY class_no)
      LOOP
         v_list.class_no := i.class_no;
         v_list.fixed_flag := i.fixed_flag;
         v_list.fixed_amt := i.fixed_amt;
         v_list.fixed_rt := i.fixed_rt;
         v_list.min_amt := i.min_amt;
         v_list.user_id := i.user_id;
         v_list.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_list.remarks := i.remarks;
         PIPE ROW(v_list);
      END LOOP;
   END get_bond_class;
   
   PROCEDURE save_bond_class (p_rec giis_bond_class%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_bond_class
         USING DUAL
         ON (class_no = p_rec.class_no)
         WHEN NOT MATCHED THEN
            INSERT (class_no, fixed_flag, fixed_amt,
                    fixed_rt, min_amt, 
                    remarks, user_id, last_update)
            VALUES (p_rec.class_no, p_rec.fixed_flag, p_rec.fixed_amt,
                    p_rec.fixed_rt, p_rec.min_amt, 
                    p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET fixed_flag = p_rec.fixed_flag,
                   fixed_amt = p_rec.fixed_amt,
                   fixed_rt = p_rec.fixed_rt,
                   min_amt = p_rec.min_amt, 
                   remarks = p_rec.remarks,
                   user_id = p_rec.user_id,
                   last_update = SYSDATE;
   END save_bond_class;
   
   PROCEDURE val_add_bond_class (p_class_no  VARCHAR2)
   IS
      v_exists VARCHAR2(1) := 'N';
   BEGIN
   
      BEGIN
         SELECT 'Y'
           INTO v_exists
           FROM giis_bond_class
          WHERE class_no = p_class_no;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_exists := 'N';     
      END;
      
      IF v_exists = 'Y' THEN
         raise_application_error (-20001, 'Geniisys Exception#E#Record already exists with the same class_no.');
      END IF;
      
   END val_add_bond_class;
   
   PROCEDURE del_bond_class (p_class_no VARCHAR2)
   IS
   BEGIN
      --raise_application_error (-20001, 'Geniisys Exception#E#' || p_class_no); 
      DELETE 
        FROM giis_bond_class_rt
       WHERE class_no = p_class_no;
       
      DELETE
        FROM giis_bond_class_subline
       WHERE class_no = p_class_no;
       
     DELETE
       FROM giis_bond_class
      WHERE class_no = p_class_no;
      
   END del_bond_class;
   
   PROCEDURE val_del_bond_class (p_class_no  VARCHAR2)
   IS
      v_exists NUMBER(10) :=  0;
      v_pol    NUMBER(10) :=  0;
   BEGIN
      FOR i IN (SELECT line_cd,subline_cd,clause_type
                  FROM giis_bond_class_subline
                 WHERE class_no = p_class_no)
      LOOP
         FOR j IN (SELECT a.par_id
                     FROM gipi_wpolbas a, gipi_wbond_basic b
                    WHERE a.par_id = b.par_id
                      AND a.subline_cd =  i.subline_cd
                      AND a.line_cd = i.line_cd
                      AND b.clause_type = i.clause_type)
         LOOP
            v_exists :=  j.par_id;
            IF (v_exists != 0) THEN 
               raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_BOND_CLASS_SUBLINE while dependent record(s) in GIPI_WPOLBAS and GIPI_WBOND_BASIC exists.');
            END IF;
         END LOOP;
         
         IF v_exists = 0 THEN
            FOR j IN (select a.policy_id
                        from gipi_polbasic a, gipi_bond_basic B
                       where a.policy_id = b.policy_id
                         and a.subline_cd =  i.subline_cd
                         and a.line_cd = i.line_cd
                         and b.clause_type = i.clause_type)
            LOOP
               IF (v_pol != 0) THEN
                  raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_BOND_CLASS_SUBLINE while dependent record(s) in GIPI_POLBASIC and GIPI_BOND_BASIC exists.');
               END IF;
            END LOOP;
         END IF;
         
      END LOOP;
   END val_del_bond_class;
   
   FUNCTION get_bond_class_subline (
      p_class_no VARCHAR2
   )
      RETURN bond_class_subline_tab PIPELINED
   IS
      v_list bond_class_subline_type;
   BEGIN
      --raise_application_error(-20001, 'Geniisys Exception#E#' || p_class_no);
      FOR i IN (SELECT *
                  FROM giis_bond_class_subline
                 WHERE class_no = p_class_no
              ORDER BY subline_cd, clause_type)
      LOOP
         v_list.class_no := i.class_no;
         v_list.line_cd := i.line_cd;
         v_list.subline_cd := i.subline_cd;
         v_list.clause_type := i.clause_type;
         v_list.waiver_limit := i.waiver_limit;
         v_list.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_list.remarks := i.remarks;   
         v_list.user_id := i.user_id;      
         
         BEGIN
            SELECT subline_name
              INTO v_list.subline_name
              FROM giis_subline
             WHERE line_cd = i.line_cd
               AND subline_cd = i.subline_cd;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.subline_name := NULL;      
         END;
         
         BEGIN
            SELECT clause_desc
              INTO v_list.clause_desc
              FROM giis_bond_class_clause
             WHERE clause_type = i.clause_type;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.clause_type := NULL;    
         END;
         
         PIPE ROW(v_list);
      END LOOP;
   END get_bond_class_subline;
   
   FUNCTION get_subline_lov
      RETURN subline_lov_tab PIPELINED
   IS
      v_list        subline_lov_type;
      v_su_line_cd  giis_line.line_cd%type := giisp.v ('LINE_CODE_SU'); --benjo 12.07.2016 SR-5882
   BEGIN
      FOR i IN (SELECT a.subline_name, a.subline_cd
                  FROM giis_subline a, giis_line b
                 WHERE a.line_cd = b.line_cd
                   AND NVL(b.menu_line_cd, b.line_cd) = v_su_line_cd)/*b.menu_line_cd = 'SU'*/ --benjo 12.07.2016 SR-5882
      LOOP
         v_list.subline_cd := i.subline_cd;
         v_list.subline_name := i.subline_name;
         PIPE ROW(v_list);
      END LOOP;
   END get_subline_lov;
   
   FUNCTION get_clause_lov
      RETURN clause_lov_tab PIPELINED
   IS
      v_list clause_lov_type;
   BEGIN
      FOR i IN (SELECT clause_type, clause_desc
                  FROM giis_bond_class_clause)
      LOOP
         v_list.clause_type := i.clause_type;
         v_list.clause_desc := i.clause_desc;
         PIPE ROW(v_list);
      END LOOP;
   END get_clause_lov;
   
   PROCEDURE val_add_bond_class_subline (
      p_class_no      VARCHAR2,
      p_subline_cd    VARCHAR2,
      p_clause_type   VARCHAR2
   )
   IS
      v_exists VARCHAR2(1) := 'N';
   BEGIN
      DECLARE
         v_line_cd giis_line.line_cd%TYPE;
      BEGIN
         SELECT line_cd
           INTO v_line_cd
           FROM giis_line
          WHERE menu_line_cd = 'SU';       
      
         SELECT 'Y'
           INTO v_exists
           FROM giis_subline a,
                giis_bond_class_subline c
          WHERE c.subline_cd = p_subline_cd
            AND c.clause_type = p_clause_type
            AND c.class_no = p_class_no
            AND c.line_cd = v_line_cd
            AND ROWNUM = 1;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_exists := 'N';            
      END;
      
      IF v_exists = 'Y' THEN
         raise_application_error (-20001, 'Geniisys Exception#E#Record already exists with the same class_no, line_cd, subline_cd, and clause_type.');   
      END IF;
      
   END val_add_bond_class_subline;
   
   PROCEDURE val_del_bond_class_subline (
      p_subline_cd    VARCHAR2,
      p_clause_type   VARCHAR2
   )
   IS
      v_line_cd giis_line.line_cd%TYPE;
   BEGIN
   
      SELECT line_cd
        INTO v_line_cd
        FROM giis_line
       WHERE menu_line_cd = 'SU'; 
   
      FOR i IN (SELECT a.par_id par_id
                  FROM gipi_wpolbas A, gipi_wbond_basic B
                 WHERE a.par_id = b.par_id
                   AND a.subline_cd =  p_subline_cd
                   AND a.line_cd = v_line_cd
                   AND b.clause_type = p_clause_type)
      LOOP
         IF i.par_id != 0 THEN
            raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_BOND_CLASS while dependent record(s) in GIPI_WPOLBAS and GIPI_WBOND_BASIC exists.');
         END IF; 
      END LOOP;
      
      FOR k IN (SELECT a.policy_id policy_id
                  FROM gipi_polbasic A, gipi_bond_basic B
                 WHERE a.policy_id = b.policy_id
                   AND a.subline_cd =  p_subline_cd
                   AND a.line_cd = v_line_cd
                   AND b.clause_type = p_clause_type)
      LOOP
         IF k.policy_id != 0 THEN
            raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_BOND_CLASS while dependent record(s) in GIPI_POLBASIC and GIPI_BOND_BASIC exists.');
         END IF; 
      END LOOP;      
   END val_del_bond_class_subline;
   
   PROCEDURE save_bond_class_subline (p_rec giis_bond_class_subline%ROWTYPE)
   IS
      v_line_cd giis_line.line_cd%TYPE;
   BEGIN
      
      BEGIN
         SELECT line_cd
           INTO v_line_cd
           FROM giis_line
          WHERE menu_line_cd = p_rec.line_cd;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_line_cd := p_rec.line_cd;    
      END;     
   
      MERGE INTO giis_bond_class_subline
         USING DUAL
         ON (class_no = p_rec.class_no
             AND line_cd = v_line_cd
             AND subline_cd = p_rec.subline_cd
             AND clause_type = p_rec.clause_type)
         WHEN NOT MATCHED THEN
            INSERT (class_no, line_cd, subline_cd,
                    clause_type, waiver_limit,
                    remarks, user_id, last_update)
            VALUES (p_rec.class_no, v_line_cd, p_rec.subline_cd,
                    p_rec.clause_type, p_rec.waiver_limit,
                    p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET waiver_limit = p_rec.waiver_limit,
                   remarks = p_rec.remarks,
                   user_id = p_rec.user_id,
                   last_update = SYSDATE;
   END save_bond_class_subline;
   
   PROCEDURE del_bond_class_subline (
      p_class_no      VARCHAR2,
      p_subline_cd    VARCHAR2,
      p_clause_type   VARCHAR2
   )
   IS
      v_line_cd giis_line.line_cd%TYPE;
   BEGIN
   
      SELECT line_cd
        INTO v_line_cd
        FROM giis_line
       WHERE menu_line_cd = 'SU'; 
   
      DELETE
        FROM giis_bond_class_subline
       WHERE class_no = p_class_no
         AND subline_cd = p_subline_cd
         AND clause_type = p_clause_type
         AND line_cd = v_line_cd; 
   END del_bond_class_subline;
   
   FUNCTION get_bond_class_rt (p_class_no VARCHAR2)
      RETURN bond_class_rt_tab PIPELINED
   IS
      v_list bond_class_rt_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM giis_bond_class_rt
                 WHERE class_no = p_class_no)
      LOOP
         v_list.class_no := i.class_no;
         v_list.range_low := i.range_low;
         v_list.range_high := i.range_high;
         v_list.default_rt := i.default_rt;
         v_list.user_id := i.user_id;
         v_list.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_list.remarks := i.remarks;
         PIPE ROW(v_list);
      END LOOP;
   END get_bond_class_rt;
   
   PROCEDURE val_add_bond_class_rt (
      p_range_low    VARCHAR2,
      p_range_high   VARCHAR2,
      p_class_no     VARCHAR2
   )
   IS
      v_exists VARCHAR2(1) := 'N';
   BEGIN  
   
      BEGIN
         SELECT 'Y'
           INTO v_exists
           FROM giis_bond_class_rt
          WHERE (range_low = p_range_low
             OR range_high = p_range_high)
            AND ROWNUM = 1;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_exists := 'N';      
      END;
      
      IF v_exists = 'Y' THEN
         raise_application_error(-20001, 'Geniisys Exception#E#Range must be unique.');
      END IF;
      
      
      BEGIN
         SELECT 'Y'
           INTO v_exists
           FROM giis_bond_class_rt
          WHERE range_low = p_range_low
            AND range_high = p_range_high
            AND class_no = p_class_no
            AND ROWNUM = 1;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_exists := 'N';      
      END;
      
      IF v_exists = 'Y' THEN
         raise_application_error (-20001, 'Geniisys Exception#E#Record already exists with the same class_no, range_low and range_high.');
      END IF;
      
   END val_add_bond_class_rt;
   
   PROCEDURE save_bond_class_rt (p_rec giis_bond_class_rt%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_bond_class_rt
         USING DUAL
         ON (class_no = p_rec.class_no
             AND range_low = p_rec.range_low
             AND range_high = p_rec.range_high)
         WHEN NOT MATCHED THEN
            INSERT (class_no, range_low, range_high,
                    default_rt, 
                    remarks, user_id, last_update)
            VALUES (p_rec.class_no, p_rec.range_low, p_rec.range_high,
                    p_rec.default_rt, 
                    p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET default_rt = p_rec.default_rt,
                   remarks = p_rec.remarks,
                   user_id = p_rec.user_id,
                   last_update = SYSDATE;  
   END save_bond_class_rt;
   
   PROCEDURE del_bond_class_rt (
      p_range_low    VARCHAR2,
      p_range_high   VARCHAR2,
      p_class_no     VARCHAR2
   )
   IS
   BEGIN
      DELETE
        FROM giis_bond_class_rt
       WHERE class_no = p_class_no
         AND range_low = p_range_low
         AND range_high = p_range_high; 
   END del_bond_class_rt;      
   
END;
/


