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
    WHERE owner = 'CPI' AND object_name = 'GIIS_MC_DEP_RATE';

   IF v_exist = 1
   THEN
      DBMS_OUTPUT.put_line ('GIIS_MC_DEP_RATE already exists.');
   END IF;
   
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      EXECUTE IMMEDIATE (   'CREATE TABLE CPI.GIIS_MC_DEP_RATE ( '
                         || 'ID                     NUMBER(5)           NOT NULL,'
                         || 'CAR_COMPANY_CD         NUMBER(6)           NOT NULL,'
                         || 'MAKE_CD                NUMBER(12),'
                         || 'SERIES_CD              NUMBER(12),'
                         || 'MODEL_YEAR             NUMBER(4),'
                         || 'LINE_CD                VARCHAR2(2 BYTE)    NOT NULL,'
                         || 'SUBLINE_CD             VARCHAR2(7 BYTE),'
                         || 'SUBLINE_TYPE_CD        VARCHAR2(10 BYTE),'
                         || 'RATE                   NUMBER(12,9)        NOT NULL,'
                         || 'DELETE_SW              VARCHAR2(1 BYTE),'
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
                
      EXECUTE IMMEDIATE ('CREATE OR REPLACE PUBLIC SYNONYM GIIS_MC_DEP_RATE FOR CPI.GIIS_MC_DEP_RATE');
      
      EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIIS_MC_DEP_RATE ADD (
                                CONSTRAINT MC_DEP_RATE_PK   
                                PRIMARY KEY (ID)
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

      EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIIS_MC_DEP_RATE ADD (
                                CONSTRAINT MC_COMP_FK  
                                FOREIGN KEY (CAR_COMPANY_CD) 
                                REFERENCES CPI.GIIS_MC_CAR_COMPANY (CAR_COMPANY_CD))');        
                                
      EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIIS_MC_DEP_RATE ADD (
                                CONSTRAINT MC_MAKE_FK  
                                FOREIGN KEY (CAR_COMPANY_CD, MAKE_CD) 
                                REFERENCES CPI.GIIS_MC_MAKE (CAR_COMPANY_CD, MAKE_CD))');             
                                
      EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIIS_MC_DEP_RATE ADD (
                                CONSTRAINT MC_ENG_FK  
                                FOREIGN KEY (CAR_COMPANY_CD, MAKE_CD, SERIES_CD) 
                                REFERENCES CPI.GIIS_MC_ENG_SERIES (CAR_COMPANY_CD, MAKE_CD, SERIES_CD))');                                                       

      EXECUTE IMMEDIATE ('GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE ON CPI.GIIS_MC_DEP_RATE TO PUBLIC');

      DBMS_OUTPUT.put_line ('GIIS_MC_DEP_RATE created.');
END;   