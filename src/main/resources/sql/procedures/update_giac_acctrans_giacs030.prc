DROP PROCEDURE CPI.UPDATE_GIAC_ACCTRANS_GIACS030;

CREATE OR REPLACE PROCEDURE CPI.UPDATE_GIAC_ACCTRANS_GIACS030(
    p_gacc_tran_id GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
    p_msg_alert        OUT      VARCHAR2,
    p_workflow_msg     OUT      VARCHAR2,
    p_user_id                   VARCHAR2) IS

BEGIN
    /*
    **  Created by        : D.Alcantara
    **  Date Created     : 12.13.2010
    **  Reference By     : (GIACS030 - Accounting Entries)
	**  Description 	: Updates giac_acctrans when transactions are closed
	*/
    UPDATE  giac_acctrans
     SET  tran_flag   = 'C'
   WHERE  tran_id     = p_gacc_tran_id;
 
   delete_workflow_rec('RECEIPTS - CLOSE ACCOUNTING ENTRIES','GIACS030',NVL(giis_users_pkg.app_user, USER), p_gacc_tran_id);
   delete_workflow_rec('JV - CLOSE ACCOUNTING ENTRIES','GIACS030',NVL(giis_users_pkg.app_user, USER),p_gacc_tran_id);
   delete_workflow_rec('CM/DM - CLOSE ACCOUNTING ENTRIES','GIACS030',NVL(giis_users_pkg.app_user, USER),p_gacc_tran_id);
   
   FOR c1 IN (SELECT claim_id
                FROM giac_direct_claim_payts a
               WHERE 1=1
                 AND a.gacc_tran_id = p_gacc_tran_id)
   LOOP    
         FOR c2 IN (SELECT b.userid, d.event_desc  
                      FROM giis_events_column c, giis_event_mod_users b, giis_event_modules a, giis_events d
			           WHERE 1=1
		               AND c.event_cd = a.event_cd
		               AND c.event_mod_cd = a.event_mod_cd
		               AND b.event_mod_cd = a.event_mod_cd
		               AND b.passing_userid = NVL(giis_users_pkg.app_user, USER)
		               AND a.module_id = 'GIACS030'
		               AND a.event_cd = d.event_cd
		               AND UPPER(d.event_desc) = 'CLAIM PAYMENTS')
		 LOOP
		   CREATE_TRANSFER_WORKFLOW_REC('CLAIM PAYMENTS', 'GIACS030', 
                                c2.userid, c1.claim_id, c2.event_desc||' '||get_clm_no(c1.claim_id), 
                                p_msg_alert, p_workflow_msg, p_user_id);
		 END LOOP;     	
   END LOOP;
   
      
   IF p_msg_alert = null THEN
    p_msg_alert := 'SUCCESS';
   END IF;
  
/*  EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;*/
END UPDATE_GIAC_ACCTRANS_GIACS030;
/


