DROP PROCEDURE CPI.WHENNEWFORMINSTANCE_GIPIS026;

CREATE OR REPLACE PROCEDURE CPI.WHENNEWFORMINSTANCE_GIPIS026(
                P_PACK_PAR_ID   IN  NUMBER
     	       ,P_ISS_CD        IN VARCHAR2
			   ,P_PAR_ID        IN  NUMBER
       		   ,P_LINE_CD       IN OUT VARCHAR2
			   ,P_MSG           IN OUT VARCHAR2
	   		   ,P_OP_FLAG       OUT VARCHAR2
       		   ,P_OTH_CHARGES   OUT VARCHAR2
       		   ,P_LC_MN         OUT VARCHAR2
       		   ,P_EXIST         OUT VARCHAR2
       		   ,P_NO_TAX_SW     OUT VARCHAR2) IS
       
    
 BEGIN
   IF P_PACK_PAR_ID !=' ' THEN
      WHENNEWFORMINSTANCE1_GIPIS026(P_PACK_PAR_ID 
             ,P_LINE_CD
          ,P_OP_FLAG);
   ELSE
      WHENNEWFORMINSTANCE2_GIPIS026(P_PAR_ID 
                ,P_LINE_CD
             ,P_OP_FLAG);
  END IF;
  
  WHENNEWFORMINSTANCE3_GIPIS026(P_OTH_CHARGES);
  
  IF p_op_flag = 'Y' THEN
         
         BEGIN
        WHENNEWFORMINSTANCE4_GIPIS026(P_PACK_PAR_ID
             ,P_PAR_ID 
             ,P_LC_MN
             ,P_EXIST);
 
       IF p_exist = 'N' THEN
              P_MSG:= 'Open Policy without any peril rate need not have invoice information...will return to entry screen of Limits and Liabilities.';
       END IF;
    END;
  END IF;
   WHENNEWFORMINSTANCE5_GIPIS026(P_LINE_CD   
          ,P_ISS_CD
          ,P_PACK_PAR_ID
          ,P_PAR_ID
          ,P_NO_TAX_SW);
 END;
/


