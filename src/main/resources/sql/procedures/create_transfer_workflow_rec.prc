DROP PROCEDURE CPI.CREATE_TRANSFER_WORKFLOW_REC;

CREATE OR REPLACE PROCEDURE CPI.CREATE_TRANSFER_WORKFLOW_REC(
	   	  		  					   p_event_desc IN VARCHAR2,
                                       p_module_id  IN VARCHAR2,
                                       p_user       IN VARCHAR2,
                                       p_col_value  IN VARCHAR2,
                                       p_info       IN VARCHAR2,
									   p_msg_alert     OUT VARCHAR2, --added by jerome orio 
									   p_workflow_msgr OUT VARCHAR2, --added by jerome orio 
									   p_user_id       IN VARCHAR2 --added by jerome orio 
									   ) 
			IS
  v_event_user_mod     gipi_user_events.event_user_mod%TYPE; 
  v_event_col_cd       gipi_user_events.event_col_cd%TYPE;
  v_event_user_mod_old gipi_user_events.event_user_mod%TYPE; 
  v_event_col_cd_old   gipi_user_events.event_col_cd%TYPE;
  v_tran_id            gipi_user_events.tran_id%TYPE;
  v_event_mod_cd       giis_event_modules.event_mod_cd%TYPE;
  v_count              NUMBER;
  v_counthist          NUMBER;
  v_gem_event_mod_cd   giis_event_modules.event_mod_cd%TYPE:=NULL;  --A.R.C. 01.24.2006
  v_date_received      DATE;
BEGIN
  /*
  **  Created by   : Jerome Orio 
  **  Date Created : April 06, 2010 
  **  Reference By : WORKLIB library  
  **  Description  : CREATE_TRANSFER_WORKFLOW_REC program unit 
  */ 
  
 --A.R.C. 01.24.2006	
 FOR c1 IN (SELECT b.event_mod_cd  
	            FROM giis_event_modules b, giis_events a
					   WHERE 1=1
				       AND b.module_id = p_module_id
				       AND b.event_cd = a.event_cd
				       AND a.event_desc = p_event_desc )
 LOOP
 	 v_gem_event_mod_cd := c1.event_mod_cd;
 END LOOP;		
 IF wf.check_wf_user(v_gem_event_mod_cd,p_user_id /*user*/,p_user) THEN
  BEGIN
    SELECT b.event_user_mod, c.event_col_cd  
	    INTO v_event_user_mod, v_event_col_cd
	    FROM giis_events_column c, giis_event_mod_users b, giis_event_modules a, giis_events d
	   WHERE 1=1
       AND c.event_cd = a.event_cd
       AND c.event_mod_cd = a.event_mod_cd
       AND b.event_mod_cd = a.event_mod_cd
	     --AND b.userid = p_user
	     AND b.passing_userid = p_user_id /*user*/  --A.R.C. 01.30.2006
	     AND NVL(b.userid,p_user) = p_user  --A.R.C. 01.30.2006	     
       AND a.module_id = p_module_id
       AND a.event_cd = d.event_cd
       AND d.event_desc = p_event_desc;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        p_msg_alert := 'Invalid user.';
        --RAISE FORM_TRIGGER_FAILURE;
  END;

  BEGIN
    SELECT workflow_tran_id_s.NEXTVAL
      INTO v_tran_id
 	    FROM dual;       
  END;
  BEGIN
  	SELECT COUNT(*)
  	  INTO v_count
  	  FROM gipi_user_events
  	 WHERE event_user_mod = v_event_user_mod
  	   AND event_col_cd = v_event_col_cd
  	   AND col_value = p_col_value
  	   AND rownum = 1;
  END;	
	  IF v_count = 0 THEN
  	   INSERT INTO gipi_user_events(event_user_mod, event_col_cd, tran_id, switch, col_value, user_id)
 	          VALUES(v_event_user_mod, v_event_col_cd, v_tran_id, 'N', p_col_value, p_user);


       BEGIN
         SELECT b.event_user_mod, c.event_col_cd  
	         INTO v_event_user_mod_old, v_event_col_cd_old
	    FROM giis_events_column c, giis_event_mod_users b, giis_event_modules a, giis_events d
	   WHERE 1=1
       AND c.event_cd = a.event_cd
       AND c.event_mod_cd = a.event_mod_cd
       AND b.event_mod_cd = a.event_mod_cd
	     --AND b.userid = USER  --A.R.C. 01.30.2006
	     AND b.passing_userid = p_user_id /*user*/  --A.R.C. 01.30.2006
	     AND NVL(b.userid,p_user) = p_user  --A.R.C. 01.30.2006	     
       AND a.module_id = p_module_id
       AND a.event_cd = d.event_cd
       AND d.event_desc = p_event_desc;
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
             p_msg_alert := 'Invalid user.';
             --RAISE FORM_TRIGGER_FAILURE;
       END;       
	  	 v_date_received := DELAY(v_event_user_mod_old, v_event_col_cd_old, v_tran_id); --A.R.C. 01.18.2006
       INSERT INTO gipi_user_events_hist(event_user_mod, event_col_cd, tran_id, col_value, date_received, old_userid, new_userid)
            VALUES(v_event_user_mod_old, v_event_col_cd_old, v_tran_id, p_col_value, v_date_received, p_user_id /*user*/, p_user);
       IF Giisp.v('WORKFLOW_MSGR') IS NOT NULL THEN       
 	       --HOST(WF.GET_POPUP_DIR||'realpopup.exe -send '||p_user||' "'||user||' assigned a new transaction.'||' - '||p_info||'" -noactivate');
		   p_workflow_msgr := NVL(WF.GET_POPUP_DIR||'realpopup.exe -send '||p_user||' "'||p_user_id /*user*/||' assigned a new transaction.'||' - '||p_info||'" -noactivate','');   
 	   END IF;
 	  END IF;		
 END IF;
END;
/


