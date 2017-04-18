/* Formatted on 2015/05/22 11:31 (Formatter Plus v4.8.8) */
/*
Created by apollo cruz
05.22.2015
*/
SET SERVEROUTPUT ON;

DECLARE
   v_tab_name     VARCHAR2 (1000) := 'GIPI_UWREPORTS_DIST_PERIL_EXT';
   v_tab_exists   NUMBER          := 0;
   v_col_exists   NUMBER          := 0;

   TYPE t_type IS RECORD (
      col_name    VARCHAR2 (1000),
      data_type   VARCHAR2 (1000)
   );

   TYPE t_tab IS TABLE OF t_type
      INDEX BY BINARY_INTEGER;

   t              t_tab;
BEGIN
   /*declaration of columns and its corresponding datatype*/
   t (1).col_name := 'POLICY_ID';
   t (1).data_type := 'NUMBER(12)';
   t (2).col_name := 'LINE_CD';
   t (2).data_type := 'VARCHAR2(2)';
   t (3).col_name := 'SUBLINE_CD';
   t (3).data_type := 'VARCHAR2(7)';
   t (4).col_name := 'DIST_NO';
   t (4).data_type := 'NUMBER(8)';
   t (5).col_name := 'DIST_SEQ_NO';
   t (5).data_type := 'NUMBER(5)';
   t (6).col_name := 'SHARE_TYPE';
   t (6).data_type := 'VARCHAR2(1)';
   t (7).col_name := 'TRTY_NAME';
   t (7).data_type := 'VARCHAR2(30)';
   t (8).col_name := 'TRTY_YY';
   t (8).data_type := 'NUMBER(2)';
   t (9).col_name := 'NR_DIST_TSI';
   t (9).data_type := 'NUMBER(16,2)';
   t (10).col_name := 'NR_DIST_PREM';
   t (10).data_type := 'NUMBER(16,2)';
   t (11).col_name := 'NR_DIST_SPCT';
   t (11).data_type := 'NUMBER(12,9)';
   t (12).col_name := 'TR_DIST_TSI';
   t (12).data_type := 'NUMBER(16,2)';
   t (13).col_name := 'TR_DIST_PREM';
   t (13).data_type := 'NUMBER(16,2)';
   t (14).col_name := 'TR_DIST_SPCT';
   t (14).data_type := 'NUMBER(12,9)';
   t (15).col_name := 'FA_DIST_TSI';
   t (15).data_type := 'NUMBER(16,2)';
   t (16).col_name := 'FA_DIST_PREM';
   t (16).data_type := 'NUMBER(16,2)';
   t (17).col_name := 'FA_DIST_SPCT';
   t (17).data_type := 'NUMBER(12,9)';
   t (18).col_name := 'CURRENCY_RT';
   t (18).data_type := 'NUMBER(12,9)';
   t (19).col_name := 'PERIL_CD';
   t (19).data_type := 'NUMBER(5)';
   t (20).col_name := 'PERIL_TYPE';
   t (20).data_type := 'VARCHAR2(1)';
   t (21).col_name := 'POLICY_NO';
   t (21).data_type := 'VARCHAR2(100)';
   t (22).col_name := 'SHARE_CD';
   t (22).data_type := 'NUMBER(3)';
   t (23).col_name := 'ITEM_NO';
   t (23).data_type := 'NUMBER(9)';
   t (24).col_name := 'ISS_CD';
   t (24).data_type := 'VARCHAR2(2)';
   t (25).col_name := 'ISSUE_YY';
   t (25).data_type := 'NUMBER(2)';
   t (26).col_name := 'POL_SEQ_NO';
   t (26).data_type := 'NUMBER(7)';
   t (27).col_name := 'RENEW_NO';
   t (27).data_type := 'NUMBER(2)';
   t (28).col_name := 'ENDT_ISS_CD';
   t (28).data_type := 'VARCHAR2(2)';
   t (29).col_name := 'ENDT_YY';
   t (29).data_type := 'NUMBER(2)';
   t (30).col_name := 'ENDT_SEQ_NO';
   t (30).data_type := 'NUMBER(6)';
   t (31).col_name := 'FROM_DATE1';
   t (31).data_type := 'DATE';
   t (32).col_name := 'TO_DATE1';
   t (32).data_type := 'DATE';
   t (33).col_name := 'USER_ID';
   t (33).data_type := 'VARCHAR2(8)';
   t (34).col_name := 'SCOPE';
   t (34).data_type := 'NUMBER(1)';
   t (35).col_name := 'PARAM_DATE';
   t (35).data_type := 'NUMBER(1)';
   t (36).col_name := 'CRED_BRANCH';
   t (36).data_type := 'VARCHAR2(2)';
   t (37).col_name := 'CRED_BRANCH_PARAM';
   t (37).data_type := 'NUMBER(1)';
   t (38).col_name := 'SPECIAL_POL_PARAM';
   t (38).data_type := 'VARCHAR2(1)';
   t (39).col_name := 'TAB1_SCOPE';
   t (39).data_type := 'NUMBER(1)';

   BEGIN
      SELECT 1
        INTO v_tab_exists
        FROM all_tables
       WHERE table_name = v_tab_name AND owner = 'CPI';

      FOR i IN 1 .. t.LAST
      LOOP
         BEGIN
            SELECT 1
              INTO v_col_exists
              FROM all_tab_cols
             WHERE owner = 'CPI'
               AND table_name = v_tab_name
               AND column_name = t (i).col_name;

            EXECUTE IMMEDIATE (   'ALTER TABLE ' 
                               || 'CPI.' || v_tab_name
                               || ' MODIFY '
                               || '"'
                               || t (i).col_name
                               || '"'
                               || ' '
                               || t (i).data_type
                              );

            DBMS_OUTPUT.put_line (   'Column '
                                  || '"'
                                  || t (i).col_name
                                  || '"'
                                  || ' has been modified to '
                                  || t (i).data_type
                                 );
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               EXECUTE IMMEDIATE (   'ALTER TABLE '
                                  || 'CPI.' || v_tab_name
                                  || ' ADD '
                                  || '"'
                                  || t (i).col_name
                                  || '"'
                                  || ' '
                                  || t (i).data_type
                                 );

               DBMS_OUTPUT.put_line (   'Column '
                                     || '"'
                                     || t (i).col_name
                                     || '"'
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
            EXECUTE IMMEDIATE ('CREATE TABLE CPI.GIPI_UWREPORTS_DIST_PERIL_EXT
(
  POLICY_ID          NUMBER(12)                 NOT NULL,
  LINE_CD            VARCHAR2(2 BYTE)           NOT NULL,
  SUBLINE_CD         VARCHAR2(7 BYTE)           NOT NULL,
  DIST_NO            NUMBER(8)                  NOT NULL,
  DIST_SEQ_NO        NUMBER(5),
  SHARE_TYPE         VARCHAR2(1 BYTE)           NOT NULL,
  TRTY_NAME          VARCHAR2(30 BYTE)          NOT NULL,
  TRTY_YY            NUMBER(2)                  NOT NULL,
  NR_DIST_TSI        NUMBER(16,2),
  NR_DIST_PREM       NUMBER(16,2),
  NR_DIST_SPCT       NUMBER(12,9),
  TR_DIST_TSI        NUMBER(16,2),
  TR_DIST_PREM       NUMBER(16,2),
  TR_DIST_SPCT       NUMBER(12,9),
  FA_DIST_TSI        NUMBER(16,2),
  FA_DIST_PREM       NUMBER(16,2),
  FA_DIST_SPCT       NUMBER(12,9),
  CURRENCY_RT        NUMBER(12,9),
  PERIL_CD           NUMBER(5)                  NOT NULL,
  PERIL_TYPE         VARCHAR2(1 BYTE)           NOT NULL,
  POLICY_NO          VARCHAR2(100 BYTE),
  SHARE_CD           NUMBER(3)                  NOT NULL,
  ITEM_NO            NUMBER(9),
  ISS_CD             VARCHAR2(2 BYTE),
  ISSUE_YY           NUMBER(2),
  POL_SEQ_NO         NUMBER(7),
  RENEW_NO           NUMBER(2),
  ENDT_ISS_CD        VARCHAR2(2 BYTE),
  ENDT_YY            NUMBER(2),
  ENDT_SEQ_NO        NUMBER(6),
  FROM_DATE1         DATE,
  TO_DATE1           DATE,
  USER_ID            VARCHAR2(8 BYTE),
  SCOPE              NUMBER(1),
  PARAM_DATE         NUMBER(1),
  CRED_BRANCH        VARCHAR2(2 BYTE),
  CRED_BRANCH_PARAM  NUMBER(1),
  SPECIAL_POL_PARAM  VARCHAR2(1 BYTE),
  TAB1_SCOPE         NUMBER(1)
)
TABLESPACE MAIN_DATA_MED
PCTUSED    0
PCTFREE    20
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          146688K
            NEXT             256K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING'                   );

            

            EXECUTE IMMEDIATE ('CREATE OR REPLACE PUBLIC SYNONYM GIPI_UWREPORTS_DIST_PERIL_EXT FOR CPI.GIPI_UWREPORTS_DIST_PERIL_EXT');

            EXECUTE IMMEDIATE ('GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON CPI.GIPI_UWREPORTS_DIST_PERIL_EXT TO PUBLIC');
         END;
   END;

   DECLARE
      v_index_exists   NUMBER;
   BEGIN
      BEGIN
         SELECT 1
           INTO v_index_exists
           FROM all_indexes
          WHERE owner = 'CPI' AND index_name = 'UWREPORTS_DIST_PERIL_EXT_IDX1';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            EXECUTE IMMEDIATE ('CREATE INDEX CPI.UWREPORTS_DIST_PERIL_EXT_IDX1 ON CPI.GIPI_UWREPORTS_DIST_PERIL_EXT (LINE_CD)');

            DBMS_STATS.gather_index_stats ('CPI',
                                           'UWREPORTS_DIST_PERIL_EXT_IDX1'
                                          );
      END;

      BEGIN
         SELECT 1
           INTO v_index_exists
           FROM all_indexes
          WHERE owner = 'CPI' AND index_name = 'UWREPORTS_DIST_PERIL_EXT_IDX2';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            EXECUTE IMMEDIATE ('CREATE INDEX CPI.UWREPORTS_DIST_PERIL_EXT_IDX2 ON CPI.GIPI_UWREPORTS_DIST_PERIL_EXT (USER_ID)');

            DBMS_STATS.gather_index_stats ('CPI',
                                           'UWREPORTS_DIST_PERIL_EXT_IDX2'
                                          );
      END;
   END;
END;