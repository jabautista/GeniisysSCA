DROP PROCEDURE CPI.WHEN_NEWFORM_INST_C_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.When_Newform_Inst_C_Gipis002
   (variables_v_clm_stat_cancel OUT VARCHAR2) IS    
BEGIN
  FOR STAT IN 
        ( SELECT param_value_v  cd
            FROM GIIS_PARAMETERS
           WHERE param_name = 'GICL_CLAIMS_CLM_STAT_CD_CANCELLED'
        ) LOOP
        variables_v_clm_stat_cancel := stat.cd;
        EXIT;
   END LOOP;
END;
/


