DROP PROCEDURE CPI.WHEN_NEWFORM_INST_F_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.When_Newform_Inst_F_Gipis002
   (v_require IN OUT VARCHAR2) IS    
BEGIN
  FOR A IN ( SELECT param_value_v
              FROM GIIS_PARAMETERS
             WHERE param_name = 'REQUIRE_REF_POL_NO')
 LOOP
  v_require := A.param_value_v;
  EXIT;
 END LOOP;
END;
/


