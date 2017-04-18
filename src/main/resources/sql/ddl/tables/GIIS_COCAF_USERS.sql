SET SERVEROUTPUT ON;

DECLARE
   v_tab_name       VARCHAR2 (1000) := 'GIIS_COCAF_USERS';
   v_tab_exists     NUMBER          := 0;
   v_col_exists     NUMBER          := 0;
   v_const_exists   NUMBER          := 0;

   TYPE t_type IS RECORD (
      col_name    VARCHAR2 (1000),
      data_type   VARCHAR2 (1000)
   );

   TYPE t_tab IS TABLE OF t_type
      INDEX BY BINARY_INTEGER;

   t                t_tab;
BEGIN
   /*declaration of columns and its corresponding datatype*/
   t (0).col_name := 'USER_ID';					t (0).data_type := 'VARCHAR2(8)';   
   t (1).col_name := 'COCAF_USER';				t (1).data_type := 'VARCHAR2(10)';   
   t (2).col_name := 'COCAF_PWD';				t (2).data_type := 'VARCHAR2(10)';   
   t (3).col_name := 'LAST_USER_ID';			t (3).data_type := 'VARCHAR2(8)';   
   t (4).col_name := 'LAST_UPDATE';				t (4).data_type := 'DATE';

   BEGIN
      SELECT 1
        INTO v_tab_exists
        FROM all_tables
       WHERE table_name = v_tab_name AND owner = 'CPI';

      FOR i IN 0 .. t.LAST
      LOOP
         BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE owner = 'CPI'
               AND table_name = v_tab_name
               AND column_name = t (i).col_name;

            EXECUTE IMMEDIATE (   'ALTER TABLE '
                               || v_tab_name
                               || ' MODIFY '
                               || t (i).col_name
                               || ' '
                               || t (i).data_type
                              );

            DBMS_OUTPUT.put_line (   'Column '
                                  || t (i).col_name
                                  || ' has been modified to '
                                  || t (i).data_type
                                 );
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               EXECUTE IMMEDIATE (   'ALTER TABLE '
                                  || v_tab_name
                                  || ' ADD '
                                  || t (i).col_name
                                  || ' '
                                  || t (i).data_type
                                 );

               DBMS_OUTPUT.put_line (   'Column '
                                     || t (i).col_name
                                     || ' '
                                     || t (i).data_type
                                     || ' has been added.'
                                    );
         END;

         /****************** additional conditions ********************/
         IF t (i).col_name = 'USER_ID'
         THEN
            BEGIN
               SELECT 1
                 INTO v_const_exists
                 FROM all_constraints
                WHERE owner = 'CPI'
                  AND table_name = 'GIIS_COCAF_USERS'
                  AND constraint_name = 'GIIS_COCAF_USERS_PK';
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
		            EXECUTE IMMEDIATE (
		            					'ALTER TABLE CPI.GIIS_COCAF_USERS ADD (
										  CONSTRAINT GIIS_COCAF_USERS_PK
										 PRIMARY KEY
										 (USER_ID)
										    USING INDEX 
										    TABLESPACE USERS
										    PCTFREE    10
										    INITRANS   2
										    MAXTRANS   255
										    STORAGE    (
										                INITIAL          64K
										                MINEXTENTS       1
										                MAXEXTENTS       UNLIMITED
										                PCTINCREASE      0
										               ))'
		            					);
            END;
            
            BEGIN
               SELECT 1
                 INTO v_const_exists
                 FROM all_constraints
                WHERE owner = 'CPI'
                  AND table_name = 'GIIS_COCAF_USERS'
                  AND constraint_name = 'GIIS_USERS_USER_ID_FK';
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
		            EXECUTE IMMEDIATE (
		            					'ALTER TABLE CPI.GIIS_COCAF_USERS ADD (
										  FOREIGN KEY (USER_ID) 
										 REFERENCES CPI.GIIS_USERS (USER_ID))'
		            					);
            END;
         END IF;
      /****************** end of additional conditions ********************/
      END LOOP;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         BEGIN
            EXECUTE IMMEDIATE (
            					'CREATE TABLE CPI.GIIS_COCAF_USERS
								(
								  USER_ID       VARCHAR2(8 BYTE)                NOT NULL,
								  COCAF_USER    VARCHAR2(10 BYTE)               NOT NULL,
								  COCAF_PWD     VARCHAR2(10 BYTE)               NOT NULL,
								  LAST_USER_ID  VARCHAR2(8 BYTE)                NOT NULL,
								  LAST_UPDATE   DATE                            NOT NULL
								)
								TABLESPACE USERS
								PCTUSED    0
								PCTFREE    10
								INITRANS   1
								MAXTRANS   255
								STORAGE    (
								            INITIAL          64K
								            MINEXTENTS       1
								            MAXEXTENTS       UNLIMITED
								            PCTINCREASE      0
								            BUFFER_POOL      DEFAULT
								           )
								LOGGING 
								NOCOMPRESS 
								NOCACHE
								NOPARALLEL
								MONITORING');

            EXECUTE IMMEDIATE (
            					'CREATE UNIQUE INDEX CPI.GIIS_COCAF_USERS_PK ON CPI.GIIS_COCAF_USERS
								(USER_ID)
								LOGGING
								TABLESPACE USERS
								PCTFREE    10
								INITRANS   2
								MAXTRANS   255
								STORAGE    (
								            INITIAL          64K
								            MINEXTENTS       1
								            MAXEXTENTS       UNLIMITED
								            PCTINCREASE      0
								            BUFFER_POOL      DEFAULT
								           )
								NOPARALLEL'
            				 );

            EXECUTE IMMEDIATE (
            					'ALTER TABLE CPI.GIIS_COCAF_USERS ADD (
								  CONSTRAINT GIIS_COCAF_USERS_PK
								 PRIMARY KEY
								 (USER_ID)
								    USING INDEX 
								    TABLESPACE USERS
								    PCTFREE    10
								    INITRANS   2
								    MAXTRANS   255
								    STORAGE    (
								                INITIAL          64K
								                MINEXTENTS       1
								                MAXEXTENTS       UNLIMITED
								                PCTINCREASE      0
								               ))'
            					);

            EXECUTE IMMEDIATE (
            					'ALTER TABLE CPI.GIIS_COCAF_USERS ADD (
								  CONSTRAINT GIIS_USERS_USER_ID_FK 
								 FOREIGN KEY (USER_ID) 
								 REFERENCES CPI.GIIS_USERS (USER_ID))'
            					);

         END;
   END;
END;

