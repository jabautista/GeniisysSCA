DROP FUNCTION CPI.VALIDATE_CO_INSURANCE_SW;

CREATE OR REPLACE FUNCTION CPI.Validate_Co_Insurance_Sw(
	   p_par_id	  		   GIPI_WPOLBAS.par_id%TYPE,
	   p_co_insurance_sw   GIPI_WPOLBAS.co_insurance_sw%TYPE) 
	RETURN VARCHAR2
	IS
  v_rec_cnt		   NUMBER := 0;
  v_count		   NUMBER;
  v_msg			   VARCHAR2(2000);
BEGIN

  /*
  **  Created by   : Jerome Orio
  **  Date Created : February 03, 2010
  **  Reference By : (GIPIS002 - Basic Information)
  **  Description  : when-radio-changed in GIPIS002 B540 co_insurance_sw
  */
  New_Co_Ins_Sw_Gipis002(p_par_id, v_rec_cnt);
  IF v_rec_cnt > 0 THEN
    FOR A1 IN (SELECT   co_insurance_sw
                 FROM   GIPI_WPOLBAS
                WHERE   par_id  =  p_par_id) 
    LOOP
       B540_Co_Ins_Sw_Wrc_Gipis002(p_PAR_ID, v_count);                      
		                        
      IF V_COUNT = 0 THEN
        FOR B IN (SELECT  1
                    FROM  GIPI_WITMPERL
                   WHERE  par_id  =  p_par_id)
        LOOP
          IF (NVL(a1.co_insurance_sw,'0')   = '2' AND
              NVL(a1.co_insurance_sw,'0')  != NVL(p_co_insurance_sw,'0') ) THEN
            v_msg := '1';
          END IF;
      
          IF (a1.co_insurance_sw != p_co_insurance_sw AND
              p_co_insurance_sw = '2') THEN
            v_msg := '2';
          END IF;
          EXIT;
        END LOOP;
      END IF;
      EXIT;
    END LOOP;
  END IF;
  RETURN v_msg;
END;
/


