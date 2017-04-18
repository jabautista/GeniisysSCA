DROP PROCEDURE CPI.WHEN_NEWFORM_INST_D_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.When_Newform_Inst_D_Gipis002
   (PARAMETER_UPD_ISSUE_DATE OUT VARCHAR2) IS    
BEGIN
  FOR C1 IN (
    SELECT PARAM_VALUE_V
      FROM GIIS_PARAMETERS
     WHERE PARAM_NAME = 'UPDATE_ISSUE_DATE')
  LOOP
   PARAMETER_UPD_ISSUE_DATE := C1.PARAM_VALUE_V;
  END LOOP;
END;
/

