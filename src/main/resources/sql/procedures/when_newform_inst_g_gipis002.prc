DROP PROCEDURE CPI.WHEN_NEWFORM_INST_G_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.When_Newform_Inst_G_Gipis002
   (var_mandatory_cred_branch OUT VARCHAR2,
    var_def_cred_branch OUT VARCHAR2) IS    
BEGIN
  FOR A IN ( SELECT A.param_value_v ap,
          b.param_value_v bp
              FROM GIIS_PARAMETERS A, 
                   GIIS_PARAMETERS b
             WHERE A.param_name = 'MANDATORY_CRED_BRANCH'
                  AND b.param_name = 'DEFAULT_CRED_BRANCH')
 LOOP
  var_mandatory_cred_branch := A.ap;
  var_def_cred_branch := A.bp;
  EXIT;
 END LOOP;
END;
/


