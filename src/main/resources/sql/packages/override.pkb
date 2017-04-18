CREATE OR REPLACE PACKAGE BODY CPI.OVERRIDE IS
/* Created by Marlo
** 10062010
** A package used in generating override request.
** Already applied in Generate Advice module (GICLS032)
** You may use it as reference.
*/
 /* Modified by Udel
** $$date$$
** Added new procedure GENERATE_OVERRIDE_HISTORY
** CLM-SPECS-2012-002
*/
/**
 ** Modified by : Andrew Robes
 ** Date : 04.02.2012
 ** Modification : Added NVL(giis_users_pkg.app_user, USER) to handle users from geniisys web
 */

 
   FUNCTION check_request_exist(p_module_id   VARCHAR2,
                                p_function_cd VARCHAR2,
                                p_columns     VARCHAR2)
   RETURN NUMBER IS
   /* A function that will count the number of request generated for a particular record to check if a request already exists. 
   ** Returned value is the number of request for a particular record. If the returned value is negative then, 
   ** an error is encountered in the database package and it is needed to be checked and modified.
   ** Parameters:
   ** P_MODULE_ID   - GIIS_MODULES.MODULE_ID%TYPE e.g. GICLS032
   ** P_FUNCTION_CD - GIAC_FUNCTIONS.FUNCTION_CODE%TYPR e.g. AC (Approve CSR)
   ** P_COLUMNS     - Use the database function OVERRIDE.GENERATE_P_COLUMN to set this parameter.
   */
      v_input       VARCHAR2(5000); 
      v_output      NUMBER(5);
      v_val1        VARCHAR2(500);
   BEGIN
     v_input := 'SELECT count(override_id) FROM(';
     FOR i IN (SELECT fcol.function_col_cd function_col_cd
                 FROM giac_function_columns fcol, giac_modules gm
                WHERE fcol.module_id = gm.module_id
                  AND gm.module_name = p_module_id
                  AND fcol.function_cd = p_function_cd)
     LOOP
       IF INSTR(p_columns, to_char(i.function_col_cd, 'fm00000009')||'-') <> 0 THEN 
          v_val1  := SUBSTR(SUBSTR(p_columns,INSTR(p_columns,to_char(i.function_col_cd, 'fm00000009')||'-', 1, 1)),1,
                     INSTR(SUBSTR(p_columns,INSTR(p_columns,to_char(i.function_col_cd, 'fm00000009')||'-',1, 1)+1),','));
          v_input := v_input||chr(10)||
                     'SELECT fovrd.override_id
                        FROM gicl_function_override fovrd,  
                             giac_modules gm
                       WHERE fovrd.module_id = gm.module_id
                         AND gm.module_name = '''||p_module_id||
                     ''' AND fovrd.override_id IN (SELECT fdtl.override_id
                                                     FROM gicl_function_override_dtl fdtl, 
                                                          giac_function_columns fcol 
                                                    WHERE fcol.function_cd = '''||p_function_cd|| 
                                                  ''' AND fcol.function_col_cd = fdtl.function_col_cd
                                                      AND fcol.module_id = gm.module_id
                                                      AND to_char(fcol.function_col_cd, ''fm00000009'')||''-''||fdtl.function_col_val = '''||v_val1||''')
                      INTERSECT';
       END IF;
     END LOOP;
     v_input := RTRIM(v_input, 'INTERSECT')||')';
     BEGIN
       EXECUTE IMMEDIATE v_input INTO v_output;
     EXCEPTION
       WHEN others THEN
          v_output := -1;
     END;
     RETURN(v_output);
   END;
   
   PROCEDURE generate_request(p_module_id   VARCHAR2,
                              p_function_cd VARCHAR2,
                              p_line_cd     VARCHAR2,
                              p_iss_cd      VARCHAR2,
                              p_remarks     VARCHAR2,
                              p_display     VARCHAR2,
                              p_columns     VARCHAR2)
   IS
   /* The procedure that will insert records in gicl_function_override to generate a request for a particular record.
   ** Once the record is inserted, the request will be queried in Claims > Claim Transactions > Function Override
   ** Parameters:
   ** P_MODULE_ID   - GIIS_MODULES.MODULE_ID%TYPE e.g. GICLS032
   ** P_FUNCTION_CD - GIAC_FUNCTIONS.FUNCTION_CODE%TYPR e.g. AC (Approve CSR)
   ** P_LINE_CD     - GIIS_LINE.LINE_CD%TYPE e.g. FI (Fire)
   ** P_ISS_CD      - GIIS_ISSOURCE.ISS_CD%TYPE e.g. HO (Head Office)
   ** P_REMARKS     - The remarks field in the override request canvas
   ** P_DISPLAY     - Use the database function OVERRIDE.GENERATE_DISPLAY  to set this parameter.
   ** P_COLUMNS     - Use the database function OVERRIDE.GENERATE_P_COLUMN to set this parameter. 
   */
     v_ovrd_id 			NUMBER;
	 v_mod_id  			NUMBER(3);
	 v_func_cl_cd 		NUMBER(12);
     v_input            VARCHAR2(5000); 
     v_val              VARCHAR2(500);
   BEGIN
     SELECT nvl(MAX(override_id),0) + 1
  	   INTO v_ovrd_id
  	   FROM gicl_function_override;
       
     SELECT module_id
  	   INTO v_mod_id
       FROM giac_modules
      WHERE module_name = p_module_id;
      
     INSERT INTO gicl_function_override(override_id,  line_cd,       iss_cd,       
                                        module_id,    function_cd,   display, 
	                                    request_date, request_by,    remarks,      
                                        user_id,      last_update)
			                    VALUES (v_ovrd_id,    p_line_cd,     p_iss_cd,
							            v_mod_id,     p_function_cd, p_display, 
							            SYSDATE,      NVL(giis_users_pkg.app_user, USER),          p_remarks, 
							            NVL(giis_users_pkg.app_user, USER),         SYSDATE);
     FOR i in (SELECT function_col_cd, table_name, column_name
                 FROM giac_function_columns
                WHERE module_id = v_mod_id
                  AND function_cd = p_function_cd)
     LOOP
       IF INSTR(p_columns, to_char(i.function_col_cd, 'fm00000009')||'-') <> 0 THEN 
          v_val := SUBSTR(SUBSTR(p_columns,INSTR(p_columns,to_char(i.function_col_cd, 'fm00000009')||'-', 1, 1)),1,
                   INSTR(SUBSTR(p_columns,INSTR(p_columns,to_char(i.function_col_cd, 'fm00000009')||'-',1, 1)+1),','));
          v_input := 'INSERT INTO gicl_function_override_dtl(override_id, 
	                                   		                 function_col_cd, 
	                                   		                 function_col_val, 
	                                   		                 user_id, 
	                                   		                 last_update)
			                                      VALUES ('||v_ovrd_id||','|| 
	  					                                     i.function_col_cd||','||
							                                 SUBSTR(v_val, INSTR(v_val, '-') + 1)||',
							                                 USER, 
							                                 SYSDATE)';
          EXECUTE IMMEDIATE v_input;
       END IF;
     END LOOP;     
     COMMIT;
   END;
   FUNCTION  generate_display(p_module_id   VARCHAR2,
                              p_function_cd VARCHAR2,
                              p_columns     VARCHAR2)
   RETURN VARCHAR2 IS
   /* A function that will retrieve the display of the request and used in the procedure OVERRIDE.GENERATE_REQUEST.
   ** The returned value will be based on the table GIAC_COLUMN_DISPLAY_HDR and GIAC_COLUMN_DISPLAY_DTL.
   ** Parameters:
   ** P_MODULE_ID   - GIIS_MODULES.MODULE_ID%TYPE e.g. GICLS032
   ** P_FUNCTION_CD - GIAC_FUNCTIONS.FUNCTION_CODE%TYPR e.g. AC (Approve CSR)
   ** P_COLUMNS     - Use the database function OVERRIDE.GENERATE_P_COLUMN to set this parameter. 
   */
      v_input        VARCHAR2(4000);
      v_output       VARCHAR2(500);
      v_return       VARCHAR2(500);
      v_val          VARCHAR2(500);
      v_columns      VARCHAR2(500) := p_columns;
   BEGIN
     FOR i IN (SELECT a.display_col_id, b.display_function, b.display_label
                 FROM giac_function_display a, giac_column_display_hdr b
                WHERE a.module_id IN (SELECT module_id
                                        FROM giac_modules
                                       WHERE module_name = p_module_id)
                  AND a.function_cd = p_function_cd
                  AND a.display_col_id = b.display_col_id)
     LOOP
       v_input := NULL;
       FOR j IN (SELECT table_name, column_name
                   FROM giac_column_display_dtl
                  WHERE display_col_id = i.display_col_id)
       LOOP
         WHILE INSTR(v_columns, to_char(i.display_col_id, 'fm00000009')||'-') <> 0 LOOP 
          v_val := SUBSTR(SUBSTR(v_columns,INSTR(v_columns,to_char(i.display_col_id, 'fm00000009')||'-', 1, 1)),1,
                   INSTR(SUBSTR(v_columns,INSTR(v_columns,to_char(i.display_col_id, 'fm00000009')||'-',1, 1)+1),','));
          v_input := v_input||' SELECT '||i.display_function||
                                ' FROM '||j.table_name||
                               ' WHERE '||LTRIM(v_val, to_char(i.display_col_id, 'fm00000009')||'-')||
                           ' INTERSECT '; 
          v_columns := REPLACE(v_columns,  v_val||',', null); 
         END LOOP;
         v_input := RTRIM(v_input, 'INTERSECT ');
       END LOOP;
       
       EXECUTE IMMEDIATE v_input INTO v_output;
        IF v_return IS NULL THEN
           v_return := i.display_label||v_output;
        ELSE 
           v_return := v_return||chr(10)||i.display_label||v_output;
        END IF;
     END LOOP;
     RETURN(v_return);
   END;
   FUNCTION generate_p_column(p_columns      VARCHAR2,
                              p_function_col NUMBER,
                              p_function_val VARCHAR2)
   RETURN VARCHAR2 IS
   /* A function used to set the parameter p_columns used for this package in its proper format mask.
   ** If the function/procedure needs multiple validation for example claim_id and advice_id then, 
   ** create a p_column for the fisrt validation and concat it to the next validation
   ** e.g. 00000001-32650,00000002-3000 (1-function column of claim_id 2-function column of advice_id)  
   ** Parameters: 
   ** P_COLUMNS      - the existing p_column if there is any, else null.
   ** P_FUNCTION_COL: 
   ** for check_request_exist and generate_request - GIAC_FUNCTION_COLUMNS.FUNCTION_COL_CD%TYPE
   ** for generate_display - GIAC_FUNCTION_DISPLAY.DISPLAY_COL_ID%TYPE
   ** P_FUNCTION_VAL:
   ** for check_request_exist and generate_request - the value needed for the function_col_cd
   **    e.g. the function_col_cd is claim_id, the function_col_val should be the claim_id of the record.
   ** for generate_display - the validation needed of the display
   **    e.g. 'claim_id = (claim_id of the record)'
   */
      v_column VARCHAR2(500);
   BEGIN
      v_column := p_columns||TO_CHAR(p_function_col, 'fm00000009')||'-'||p_function_val||',';
      RETURN(v_column);
   END;

   PROCEDURE generate_override_history(p_module_id      VARCHAR2,
                                       p_function_cd    VARCHAR2,
                                       p_line_cd        VARCHAR2,
                                       p_iss_cd         VARCHAR2,
                                       p_remarks        VARCHAR2,
                                       p_display        VARCHAR2,
                                       p_columns        VARCHAR2,
                                       p_override_user  VARCHAR2,
                                       p_override_date  VARCHAR2)
   IS
   /* This procedure is copied from procedure GENERATE_REQUEST
   ** except this gets OVERRIDE_USER and OVERRIDE_DATE as parameters.
   */
     v_ovrd_id             NUMBER;
     v_mod_id              NUMBER(3);
     v_func_cl_cd         NUMBER(12);
     v_input            VARCHAR2(5000); 
     v_val              VARCHAR2(500);
   BEGIN
     SELECT nvl(MAX(override_id),0) + 1
         INTO v_ovrd_id
         FROM gicl_function_override;
       
     SELECT module_id
         INTO v_mod_id
       FROM giac_modules
      WHERE module_name = p_module_id;
      
     INSERT INTO gicl_function_override(override_id,  line_cd,       iss_cd,       
                                        module_id,    function_cd,   display, 
                                        request_date, request_by,    remarks,      
                                        user_id,      last_update,   override_user,
                                        override_date)
                                VALUES (v_ovrd_id,      p_line_cd,     p_iss_cd,
                                        v_mod_id,       p_function_cd, p_display, 
                                        SYSDATE,        USER,          p_remarks, 
                                        USER,           SYSDATE,       p_override_user,
                                        p_override_date);
     FOR i in (SELECT function_col_cd, table_name, column_name
                 FROM giac_function_columns
                WHERE module_id = v_mod_id
                  AND function_cd = p_function_cd)
     LOOP
       IF INSTR(p_columns, to_char(i.function_col_cd, 'fm00000009')||'-') <> 0 THEN 
          v_val := SUBSTR(SUBSTR(p_columns,INSTR(p_columns,to_char(i.function_col_cd, 'fm00000009')||'-', 1, 1)),1,
                   INSTR(SUBSTR(p_columns,INSTR(p_columns,to_char(i.function_col_cd, 'fm00000009')||'-',1, 1)+1),','));
          v_input := 'INSERT INTO gicl_function_override_dtl(override_id, 
                                                                function_col_cd, 
                                                                function_col_val, 
                                                                user_id, 
                                                                last_update)
                                                  VALUES ('||v_ovrd_id||','|| 
                                                               i.function_col_cd||','||
                                                             SUBSTR(v_val, INSTR(v_val, '-') + 1)||',
                                                             USER, 
                                                             SYSDATE)';
          EXECUTE IMMEDIATE v_input;
       END IF;
     END LOOP;     
     COMMIT;
   END;
   

END;
/


