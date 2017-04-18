SET SERVEROUTPUT ON;

DECLARE
   v_tab_name       VARCHAR2 (1000) := 'GIPI_COC_AUTH';
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
   t (0).col_name := 'POLICY_ID';				t (0).data_type := 'NUMBER(12)';   
   t (1).col_name := 'ITEM_NO';					t (1).data_type := 'NUMBER(9)';
   t (2).col_name := 'COC_NO';					t (2).data_type := 'VARCHAR2(20)';   
   t (3).col_name := 'AUTH_NO';					t (3).data_type := 'VARCHAR2(12)';  
   t (4).col_name := 'ERR_MSG';					t (4).data_type := 'VARCHAR2(2000)';
   t (5).col_name := 'REG_DATE';				t (5).data_type := 'DATE';
   t (6).col_name := 'COCAF_USER';				t (6).data_type := 'VARCHAR2(10)';
   t (7).col_name := 'LAST_USER_ID';			t (7).data_type := 'VARCHAR2(8)';
   t (8).col_name := 'LAST_UPDATE';				t (8).data_type := 'DATE';

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
      END LOOP;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         BEGIN
            EXECUTE IMMEDIATE (
            					'CREATE TABLE CPI.GIPI_COC_AUTH
								(
								  POLICY_ID     NUMBER(12)                      NOT NULL,
								  ITEM_NO       NUMBER(9)                       NOT NULL,
								  COC_NO        VARCHAR2(20 BYTE),
								  AUTH_NO       VARCHAR2(12 BYTE),
								  ERR_MSG       VARCHAR2(2000 BYTE),
								  REG_DATE      DATE                            NOT NULL,
								  COCAF_USER    VARCHAR2(8 BYTE)                NOT NULL,
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

         END;
   END;
END;