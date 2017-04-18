/* Created by   : Dren Niebres
 * Date Created : 08.01.2016
 * Remarks      : SR-5278
 */
SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM all_objects
    WHERE owner = 'CPI' AND object_name = 'GIIS_MC_DEP_PERIL';

   IF v_exist = 1
   THEN
      DBMS_OUTPUT.put_line ('GIIS_MC_DEP_PERIL already exists.');
   END IF;
   
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      EXECUTE IMMEDIATE (   'CREATE TABLE CPI.GIIS_MC_DEP_PERIL ( '
                         || 'ID                     NUMBER(5)           NOT NULL,'
                         || 'LINE_CD                VARCHAR2(2 BYTE)    NOT NULL,'
                         || 'PERIL_CD               NUMBER(5)           NOT NULL,' 
                         || 'USER_ID                VARCHAR2(8 BYTE)    NOT NULL,'
                         || 'LAST_UPDATE            DATE                NOT NULL)' 
                         || 'TABLESPACE MAIN_DATA '
                         || 'PCTUSED    0 '
                         || 'PCTFREE    10 '
                         || 'INITRANS   1 '
                         || 'MAXTRANS   255 '
                         || 'STORAGE    ( '
                         || 'INITIAL          131712K '
                         || 'NEXT             128K '
                         || 'MINEXTENTS       1 '
                         || 'MAXEXTENTS       UNLIMITED '
                         || 'PCTINCREASE      0 '
                         || 'BUFFER_POOL      DEFAULT) '
                         || 'LOGGING '
                         || 'NOCOMPRESS '
                         || 'NOCACHE '
                         || 'NOPARALLEL '
                         || 'MONITORING'
                        );
                
      EXECUTE IMMEDIATE ('CREATE OR REPLACE PUBLIC SYNONYM GIIS_MC_DEP_PERIL FOR CPI.GIIS_MC_DEP_PERIL');
      
      EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIIS_MC_DEP_PERIL ADD (
                                CONSTRAINT MC_DEP_PERIL_PK   
                                PRIMARY KEY (ID, LINE_CD, PERIL_CD)
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
                                           ))');                                                    

      EXECUTE IMMEDIATE ('GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON CPI.GIIS_MC_DEP_PERIL TO PUBLIC');

      DBMS_OUTPUT.put_line ('GIIS_MC_DEP_PERIL created.');
END;   