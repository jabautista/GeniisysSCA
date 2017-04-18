DROP PROCEDURE CPI.POSTING_PROCESS_E;

CREATE OR REPLACE PROCEDURE CPI.posting_process_e(
	   	  		  p_par_id	       IN  GIPI_PARLIST.par_id%TYPE,
				  p_user_id		   IN  VARCHAR2,
				  p_msg_alert	   OUT VARCHAR2,
				  p_workflow_msgr  OUT VARCHAR2,
                  p_module_id      GIIS_MODULES.module_id%TYPE DEFAULT NULL
	   	  		  )
		IS
  v_msg_alert   VARCHAR2(2000);		
  v_workflow_msgr VARCHAR2(32000);
BEGIN
  /*
  **  Created by   : Jerome Orio 
  **  Date Created : April 06, 2010 
  **  Reference By : (GIPIS055 - POST PAR) 
  **  Description  : a part of Posting_process program unit 
  */
    /*
    **  Modified by  : Gzelle
    **  Date Created : 09.04.2013
    **  Modification : Added p_module_id parameter to determine if procedure is called from Batch Posting.
    **              If called from Batch Posting, insert error to giis_post_error_log
    */     
  FOR a1 IN (SELECT policy_id
               FROM giuw_pol_dist
              WHERE dist_flag = '1'
                AND par_id = p_par_id )
  LOOP
     FOR c1 IN (SELECT b.userid, d.event_desc  
                    FROM giis_events_column c, giis_event_mod_users b, giis_event_modules a, giis_events d
                   WHERE 1=1
                   AND c.event_cd = a.event_cd
                   AND c.event_mod_cd = a.event_mod_cd
                   AND b.event_mod_cd = a.event_mod_cd
                   --AND b.userid <> USER  --A.R.C. 01.24.2006
                   AND b.passing_userid = p_user_id  --A.R.C. 01.24.2006
                   AND a.module_id = 'GIPIS055'
                   AND a.event_cd = d.event_cd
                   AND d.event_desc = 'Final Distribution')
     LOOP
          FOR c2 IN (SELECT line_cd||'-'|| subline_cd|| '-'|| iss_cd|| '-'|| LTRIM (TO_CHAR (issue_yy, '09'))|| '-'|| LTRIM (TO_CHAR (pol_seq_no, '0999999'))|| '-'|| LTRIM (TO_CHAR (renew_no, '09')) policy_no
                       FROM gipi_polbasic
                      WHERE policy_id = a1.policy_id)
        LOOP
         IF p_module_id = 'GIPIS207' THEN
            CREATE_TRANSFER_WORKFLOW_REC(c1.event_desc,'GIPIS207', c1.userid, a1.policy_id, c1.event_desc||' '||c2.policy_no,v_msg_alert,v_workflow_msgr,p_user_id);
         ELSE
            CREATE_TRANSFER_WORKFLOW_REC(c1.event_desc,'GIPIS055', c1.userid, a1.policy_id, c1.event_desc||' '||c2.policy_no,v_msg_alert,v_workflow_msgr,p_user_id);
         END IF;
       END LOOP;
     END LOOP;    
  END LOOP;
    /* A.R.C. 02.03.2006
  ** to create workflow records of Endt of policy w/ on going claims */        
  FOR b1 IN (SELECT DISTINCT claim_id
               FROM gicl_claims b,
                    gipi_polbasic a
              WHERE b.line_cd = a.line_cd
                AND b.subline_cd = a.subline_cd
                AND b.iss_cd = a.iss_cd                     
                AND b.issue_yy = a.issue_yy 
                AND b.pol_seq_no = a.pol_seq_no
                AND b.renew_no = a.renew_no
                AND b.clm_stat_cd NOT IN ('CC','WD','DN')
                AND a.par_id = p_par_id)
  LOOP    
   FOR c1 IN (SELECT b.userid, d.event_desc  
                FROM giis_events_column c, giis_event_mod_users b, giis_event_modules a, giis_events d
               WHERE 1=1
                 AND c.event_cd = a.event_cd
                 AND c.event_mod_cd = a.event_mod_cd
                 AND b.event_mod_cd = a.event_mod_cd
                 AND b.passing_userid = p_user_id
                 AND a.module_id = 'GIPIS055'
                 AND a.event_cd = d.event_cd
                 AND d.event_desc = 'Endt of policy w/ on going claims')
   LOOP
     IF v_msg_alert IS NULL THEN
        IF p_module_id = 'GIPIS207' THEN
            CREATE_TRANSFER_WORKFLOW_REC(c1.event_desc,'GIPIS207', c1.userid, b1.claim_id, c1.event_desc||' '||Gicl_Claims_Pkg.get_clm_no(b1.claim_id),v_msg_alert,v_workflow_msgr,p_user_id);
        ELSE
            CREATE_TRANSFER_WORKFLOW_REC(c1.event_desc,'GIPIS055', c1.userid, b1.claim_id, c1.event_desc||' '||Gicl_Claims_Pkg.get_clm_no(b1.claim_id),v_msg_alert,v_workflow_msgr,p_user_id);
        END IF;
     END IF;
   END LOOP; 
  END LOOP;
  
  --gipis207_pkg.pre_post_error2(p_par_id, v_msg_alert,p_module_id);
  --p_msg_alert := NVL(v_msg_alert,p_msg_alert);
  IF p_module_id = 'GIPIS207'
  THEN
    gipis207_pkg.pre_post_error2(p_par_id, v_msg_alert,p_module_id);    
    p_msg_alert := NVL(v_msg_alert,p_msg_alert); 
  ELSE
    p_msg_alert := NVL(v_msg_alert,p_msg_alert);
  END IF;
  p_workflow_msgr := NVL(v_workflow_msgr,p_workflow_msgr);
END;
/


