/* Formatted on 2015/05/25 15:15 (Formatter Plus v4.8.8) */
/*
Created by apollo cruz
05.20.2015
*/
SET SERVEROUTPUT ON;

DECLARE
   v_tab_name       VARCHAR2 (1000) := 'GIIS_SUBLINE';
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
   t (0).col_name := 'LINE_CD';
   t (0).data_type := 'VARCHAR2(2)';
   t (1).col_name := 'SUBLINE_CD';
   t (1).data_type := 'VARCHAR2(7)';
   t (2).col_name := 'ACCT_SUBLINE_CD';
   t (2).data_type := 'NUMBER(2)';
   t (3).col_name := 'SUBLINE_NAME';
   t (3).data_type := 'VARCHAR2(30)';
   t (4).col_name := 'OPEN_POLICY_SW';
   t (4).data_type := 'VARCHAR2(1)';
   t (5).col_name := 'OP_FLAG';
   t (5).data_type := 'VARCHAR2(1)';
   t (6).col_name := 'SUBLINE_TIME';
   t (6).data_type := 'VARCHAR2(10)';
   t (7).col_name := 'SUBLINE_GRP';
   t (7).data_type := 'VARCHAR2(2)';
   t (8).col_name := 'SUBLINE_FLAG';
   t (8).data_type := 'VARCHAR2(1)';
   t (9).col_name := 'TIME_SW';
   t (9).data_type := 'VARCHAR2(1)';
   t (10).col_name := 'ALLIED_PRT_TAG';
   t (10).data_type := 'VARCHAR2(1)';
   t (11).col_name := 'EXCLUDE_TAG';
   t (11).data_type := 'VARCHAR2(1)';
   t (12).col_name := 'USER_ID';
   t (12).data_type := 'VARCHAR2(8)';
   t (13).col_name := 'LAST_UPDATE';
   t (13).data_type := 'DATE';
   t (14).col_name := 'REMARKS';
   t (14).data_type := 'VARCHAR2(4000)';
   t (15).col_name := 'NO_TAX_SW';
   t (15).data_type := 'VARCHAR2(1)';
   t (16).col_name := 'CPI_REC_NO';
   t (16).data_type := 'NUMBER(12)';
   t (17).col_name := 'CPI_BRANCH_CD';
   t (17).data_type := 'VARCHAR2(2)';
   t (18).col_name := 'BENEFIT_FLAG';
   t (18).data_type := 'VARCHAR2(1)';
   t (19).col_name := 'PROF_COMM_TAG';
   t (19).data_type := 'VARCHAR2(1)';
   t (20).col_name := 'EDST_SW';
   t (20).data_type := 'VARCHAR2(1)';
   t (21).col_name := 'ENROLLEE_TAG';
   t (21).data_type := 'VARCHAR2(1)';
   t (22).col_name := 'MIN_PREM_AMT';
   t (22).data_type := 'NUMBER(12,2)';
   t (23).col_name := 'NON_RENEWAL_TAG';
   t (23).data_type := 'VARCHAR2(1)';
   t (24).col_name := 'RECAP_LINE_CD';
   t (24).data_type := 'VARCHAR2(2)';
   t (25).col_name := 'MICRO_SW';
   t (25).data_type := 'VARCHAR2(1)';

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
         IF t (i).col_name = 'MICRO_SW'
         THEN
            EXECUTE IMMEDIATE ('UPDATE giis_subline SET micro_sw = DECODE(micro_sw, ''Y'', ''Y'', ''N'')');
            EXECUTE IMMEDIATE ('COMMIT');

            FOR j IN (SELECT nullable
                        FROM all_tab_cols
                       WHERE owner = 'CPI'
                         AND table_name = 'GIIS_SUBLINE'
                         AND column_name = 'MICRO_SW')
            LOOP
               IF j.nullable = 'Y'
               THEN
                  EXECUTE IMMEDIATE ('ALTER TABLE giis_subline MODIFY micro_sw VARCHAR2(1) NOT NULL');
               END IF;
            END LOOP;

            BEGIN
               SELECT 1
                 INTO v_const_exists
                 FROM all_constraints
                WHERE owner = 'CPI'
                  AND table_name = 'GIIS_SUBLINE'
                  AND constraint_name = 'MICRO_SW_CHK';
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIIS_SUBLINE ADD (
  CONSTRAINT MICRO_SW_CHK
 CHECK (              MICRO_SW IN (''Y'',''N'')       ))');
            END;
         END IF;
      /****************** end of additional conditions ********************/
      END LOOP;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         BEGIN
            EXECUTE IMMEDIATE ('CREATE TABLE CPI.GIIS_SUBLINE
(
  LINE_CD          VARCHAR2(2 BYTE)             NOT NULL,
  SUBLINE_CD       VARCHAR2(7 BYTE)             NOT NULL,
  ACCT_SUBLINE_CD  NUMBER(22)                   NOT NULL,
  SUBLINE_NAME     VARCHAR2(30 BYTE)            NOT NULL,
  OPEN_POLICY_SW   VARCHAR2(1 BYTE)             NOT NULL,
  OP_FLAG          VARCHAR2(1 BYTE)             NOT NULL,
  SUBLINE_TIME     VARCHAR2(10 BYTE),
  SUBLINE_GRP      VARCHAR2(2 BYTE),
  SUBLINE_FLAG     VARCHAR2(1 BYTE),
  TIME_SW          VARCHAR2(1 BYTE),
  ALLIED_PRT_TAG   VARCHAR2(1 BYTE),
  EXCLUDE_TAG      VARCHAR2(1 BYTE),
  USER_ID          VARCHAR2(8 BYTE)             NOT NULL,
  LAST_UPDATE      DATE                         NOT NULL,
  REMARKS          VARCHAR2(4000 BYTE),
  NO_TAX_SW        VARCHAR2(1 BYTE),
  CPI_REC_NO       NUMBER(22),
  CPI_BRANCH_CD    VARCHAR2(2 BYTE),
  BENEFIT_FLAG     VARCHAR2(1 BYTE),
  PROF_COMM_TAG    VARCHAR2(1 BYTE),
  EDST_SW          VARCHAR2(1 BYTE),
  ENROLLEE_TAG     VARCHAR2(1 BYTE),
  MIN_PREM_AMT     NUMBER(22),
  NON_RENEWAL_TAG  VARCHAR2(1 BYTE),
  RECAP_LINE_CD    VARCHAR2(2 BYTE),
  MICRO_SW         VARCHAR2(1 BYTE)             NOT NULL
)
TABLESPACE MAINTENANCE_DATA
PCTUSED    0
PCTFREE    5
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          128K
            NEXT             128K
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

            EXECUTE IMMEDIATE ('CREATE UNIQUE INDEX CPI.SUBLINE_PK ON CPI.GIIS_SUBLINE
(LINE_CD, SUBLINE_CD)
LOGGING
TABLESPACE INDEXES
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128K
            NEXT             128K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL'                   );

            EXECUTE IMMEDIATE ('CREATE UNIQUE INDEX CPI.SUBLINE_U1 ON CPI.GIIS_SUBLINE
(LINE_CD, ACCT_SUBLINE_CD)
LOGGING
TABLESPACE INDEXES
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128K
            NEXT             128K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL'                   );

            EXECUTE IMMEDIATE ('CREATE OR REPLACE TRIGGER CPI.TRG1_SUBLINE
BEFORE INSERT OR UPDATE
ON CPI.GIIS_SUBLINE FOR EACH ROW
DECLARE
BEGIN
  DECLARE
  BEGIN
       :NEW.user_ID    := NVL (giis_users_pkg.app_user, USER);
       :NEW.LAST_UPDATE := SYSDATE;
  END;
END;'                         );

            EXECUTE IMMEDIATE ('CREATE OR REPLACE PUBLIC SYNONYM GIIS_SUBLINE FOR CPI.GIIS_SUBLINE');

            EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIIS_SUBLINE ADD (
  CONSTRAINT MICRO_SW_CHK
 CHECK (              MICRO_SW IN (''Y'',''N'')       ),
  CONSTRAINT SUBLINE_OPEN_POLICY_SW_CHK
 CHECK (              OPEN_POLICY_SW IN (''Y'',''N'')       ),
  CONSTRAINT SUBLINE_OP_FLAG_CHK
 CHECK (              OP_FLAG IN (''Y'',''N'')       ),
  CONSTRAINT SUBLINE_OPEN_POLICY_SW_CK
 CHECK (              open_policy_sw IN (''Y'',''N'')       ),
  CONSTRAINT SUBLINE_OP_FLAG_CK
 CHECK (              op_flag IN (''Y'',''N'')       ),
  CONSTRAINT CHECK_ENROLLEE_TAG
 CHECK (ENROLLEE_TAG IN (''Y'',''N'')),
  CONSTRAINT SUBLINE_PK
 PRIMARY KEY
 (LINE_CD, SUBLINE_CD)
    USING INDEX 
    TABLESPACE INDEXES
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          128K
                NEXT             128K
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ),
  CONSTRAINT SUBLINE_U1
 UNIQUE (LINE_CD, ACCT_SUBLINE_CD)
    USING INDEX 
    TABLESPACE INDEXES
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          128K
                NEXT             128K
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                PCTINCREASE      0
               ))'            );

            EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIIS_SUBLINE ADD (
  CONSTRAINT LINE_SUBLINE_FK 
 FOREIGN KEY (LINE_CD) 
 REFERENCES CPI.GIIS_LINE (LINE_CD))');

            EXECUTE IMMEDIATE ('GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON CPI.GIIS_SUBLINE TO PUBLIC');
         END;
   END;
END;