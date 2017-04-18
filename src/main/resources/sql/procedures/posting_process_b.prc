DROP PROCEDURE CPI.POSTING_PROCESS_B;

CREATE OR REPLACE PROCEDURE CPI.Posting_Process_B(
	   	  		  p_par_id				IN  GIPI_PARLIST.par_id%TYPE,
				  p_user_id				IN  VARCHAR2,
	   	  		  p_msg_alert			OUT VARCHAR2,	  
	   	  		  p_module_id           GIIS_MODULES.module_id%TYPE DEFAULT NULL
                  )
	   IS
  GLOBAL_CG$BACK_ENDT   VARCHAR2(200);
  v_par_type			GIPI_PARLIST.par_type%TYPE;
  v_msg_alert			VARCHAR2(2000);
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 31, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : a part of Posting_process program unit
  */
    /*
    **  Modified by  : Gzelle
    **  Date Created : 09.04.2013
    **  Modification : Added p_module_id parameter to determine if procedure is called from Batch Posting.
    **              If called from Batch Posting, insert error to giis_post_error_log
    */   
  FOR a IN (SELECT par_type
              FROM GIPI_PARLIST
			 WHERE par_id = p_par_id)
  LOOP
    v_par_type := a.par_type;
  END LOOP;
  
  IF v_par_type = 'E' THEN
    --FOR LOOP from when-new-block-instance in post_button block trigger 
	--jerome orio /inadd ko ito kasi di ko alam san galing ung global variable..di ko kc makita, nasa ibang form ata..lol
    FOR pol IN (SELECT '1'
                  FROM GIPI_POLBASIC b250, GIPI_WPOLBAS b540
                 WHERE b250.line_cd = b540.line_cd
                   AND b250.subline_cd = b540.subline_cd
                   AND b250.iss_cd = b540.iss_cd
                   AND b250.issue_yy = b540.issue_yy
                   AND b250.pol_seq_no = b540.pol_seq_no
                   AND b250.renew_no = b540.renew_no
                   AND TRUNC(b250.eff_date) > TRUNC(b540.eff_date)
                   AND b250.pol_flag     IN('1','2','3')
                   AND NVL(b250.endt_expiry_date,b250.expiry_date) >=  b540.eff_date
                   AND B540.par_id = p_par_id                
                   AND b540.pol_flag IN ('1','2','3')
              ORDER BY B250.eff_date DESC)
    LOOP
             GLOBAL_CG$BACK_ENDT := 'Y';
             EXIT;
    END LOOP; 
    IF  GLOBAL_CG$BACK_ENDT = 'Y' THEN 
      upd_back_endt(p_par_id,v_msg_alert);
    END IF;
  END IF;
  insert_parhist_gipis055(p_par_id,p_user_id);
  Update_Par_Status_gipis055(p_par_id);
  --gipis207_pkg.pre_post_error2(p_par_id, v_msg_alert,p_module_id);
  --p_msg_alert := NVL(v_msg_alert,p_msg_alert);
  IF p_module_id = 'GIPIS207'
  THEN
     gipis207_pkg.pre_post_error2(p_par_id, v_msg_alert,p_module_id);  
     p_msg_alert := NVL(v_msg_alert,p_msg_alert);   
  ELSE
     p_msg_alert := NVL(v_msg_alert,p_msg_alert);
  END IF;
END;
/


