/* Created by   : Dren Niebres
 * Date Created : 06.08.2016
 * Remarks      : SR-5278
 */
SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM all_objects
    WHERE owner = 'CPI' AND object_name = 'GIIS_MC_FMV';

   IF v_exist = 1
   THEN
      DBMS_OUTPUT.put_line ('GIIS_MC_FMV already exists.');
   END IF;
   
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      EXECUTE IMMEDIATE (   'CREATE TABLE CPI.GIIS_MC_FMV ( '
                         || 'CAR_COMPANY_CD         NUMBER(6)           NOT NULL,'
                         || 'MAKE_CD                NUMBER(12)          NOT NULL,'
                         || 'SERIES_CD              NUMBER(12)          NOT NULL,'
                         || 'MODEL_YEAR             NUMBER(5)           NOT NULL,'
                         || 'HIST_NO                NUMBER(5)           NOT NULL,'
                         || 'EFF_DATE               DATE                NOT NULL,'
                         || 'FMV_VALUE              NUMBER(16,2)        NOT NULL,'
                         || 'FMV_VALUE_MIN          NUMBER(16,2),'
                         || 'FMV_VALUE_MAX          NUMBER(16,2),'
                         || 'DELETE_SW              VARCHAR2(1 BYTE),'
                         || 'USER_ID                VARCHAR2(8 BYTE)    NOT NULL,'
                         || 'LAST_UPDATE            DATE) ' 
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
                
      EXECUTE IMMEDIATE ('CREATE OR REPLACE PUBLIC SYNONYM GIIS_MC_FMV FOR CPI.GIIS_MC_FMV');
      
      EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIIS_MC_FMV ADD (
                                CONSTRAINT MC_FMV_PK   
                                PRIMARY KEY (CAR_COMPANY_CD, MAKE_CD, SERIES_CD, MODEL_YEAR, HIST_NO)
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

      EXECUTE IMMEDIATE ('GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON CPI.GIIS_MC_FMV TO PUBLIC');

      DBMS_OUTPUT.put_line ('GIIS_MC_FMV created.');
END;   