CREATE OR REPLACE PACKAGE BODY CPI.GIPI_REASSIGN_ENDT_PKG
AS
	/*
   **  Created by   :  Steven Ramirez
   **  Date Created : 03.18.2013
   **  Reference By : GIPIS057 - Re-assign Par Endt to a new User
   **  Description  :
   */
    FUNCTION get_reassign_par_endt(p_user_id			GIIS_USERS.user_id%TYPE)
      RETURN gipi_reassign_endt_tab PIPELINED
   AS
      v_reassign        gipi_reassign_endt_type;
	  v_all_user		VARCHAR2(1) := 'N';
	BEGIN
		FOR ALL_USER IN ( SELECT '1'
							 FROM giis_users
							WHERE user_id = p_user_id
							  AND NVL(all_user_sw,'N') ='Y') 
		 LOOP 
		 	v_all_user := 'Y';
         END LOOP;
		 IF v_all_user = 'Y' THEN
				FOR i IN(SELECT a.par_id, 
								a.pack_par_id, 
								a.line_cd, 
								a.iss_cd, 
								a.par_yy, 
								a.par_seq_no, 
								a.quote_seq_no, 
								a.assign_sw, 
								a.assd_no, 
								a.underwriter, 
								a.remarks, 
								a.par_status, 
								a.par_type,
								b.assd_name,
								c.pack_pol_flag
							FROM    gipi_parlist a, 
									GIIS_ASSURED b, 
									GIIS_LINE c
							WHERE a.par_status < 7 
							AND a.par_type = 'E' 
							AND check_user_per_line2(a.line_cd,a.iss_cd,'GIPIS057',p_user_id) = 1 
						    AND check_user_per_iss_cd2 (a.line_cd, a.iss_cd,'GIPIS057',p_user_id) = 1  
							AND  a.assd_no = b.assd_no(+)
							AND a.line_cd = c.line_cd(+) 
						UNION ALL 
						SELECT  a.pack_par_id, 
								a.pack_par_id, 
								a.line_cd, 
								a.iss_cd, 
								a.par_yy, 
								a.par_seq_no, 
								a.quote_seq_no, 
								a.assign_sw,
								a.assd_no, 
								a.underwriter, 
								a.remarks, 
								a.par_status, 
								a.par_type,
								b.assd_name,
								c.pack_pol_flag 
							FROM    gipi_pack_parlist a, 
									GIIS_ASSURED b, 
									GIIS_LINE c 
							WHERE a.par_status < 7 
							AND a.par_type = 'E'
							AND check_user_per_line2(a.line_cd,a.iss_cd,'GIPIS057',p_user_id) = 1 
						    AND check_user_per_iss_cd2 (a.line_cd, a.iss_cd,'GIPIS057',p_user_id) = 1  
							AND  a.assd_no = b.assd_no(+)
							AND a.line_cd = c.line_cd(+)
							ORDER BY LINE_CD,ISS_CD,PAR_YY,PAR_SEQ_NO,QUOTE_SEQ_NO)
			LOOP
			   v_reassign.par_id            := i.par_id;
			   v_reassign.pack_par_id       := i.pack_par_id; 	
			   v_reassign.line_cd           := i.line_cd;
			   v_reassign.iss_cd        	:= i.iss_cd;	
			   v_reassign.par_yy            := i.par_yy;	
			   v_reassign.par_seq_no        := i.par_seq_no; 
			   v_reassign.quote_seq_no      := i.quote_seq_no;
			   v_reassign.assd_no           := i.assd_no;	
			   v_reassign.assign_sw         := i.assign_sw;
			   v_reassign.underwriter      	:= i.underwriter;  
			   v_reassign.remarks       	:= i.remarks;    	
			   v_reassign.par_status   		:= i.par_status;       
			   v_reassign.par_type			:= i.par_type;
			   v_reassign.assd_name 		:= i.assd_name;
			   v_reassign.pack_pol_flag		:= i.pack_pol_flag;
			   v_reassign.parstat_date		:= TRUNC(GIPI_REASSIGN_ENDT_PKG.get_parstat_date(i.par_id)); -- marco - 04.29.2013 - added trunc
			   PIPE ROW (v_reassign);
			END LOOP;
		ELSE
			FOR i IN(SELECT a.par_id, 
								a.pack_par_id, 
								a.line_cd, 
								a.iss_cd, 
								a.par_yy, 
								a.par_seq_no, 
								a.quote_seq_no, 
								a.assign_sw, 
								a.assd_no, 
								a.underwriter, 
								a.remarks, 
								a.par_status, 
								a.par_type,
								b.assd_name,
								c.pack_pol_flag
							FROM    gipi_parlist a, 
									GIIS_ASSURED b, 
									GIIS_LINE c
							WHERE a.par_status < 7 
							AND a.par_type = 'E' 
						    AND check_user_per_line2(a.line_cd,a.iss_cd,'GIPIS057',p_user_id) = 1 
						    AND check_user_per_iss_cd2 (a.line_cd, a.iss_cd,'GIPIS057',p_user_id) = 1 
							AND  a.assd_no = b.assd_no(+)
							AND a.line_cd = c.line_cd(+) 
						    AND a.underwriter = p_user_id
						UNION ALL 
						SELECT  a.pack_par_id, 
								a.pack_par_id, 
								a.line_cd, 
								a.iss_cd, 
								a.par_yy, 
								a.par_seq_no, 
								a.quote_seq_no, 
								a.assign_sw,
								a.assd_no, 
								a.underwriter, 
								a.remarks, 
								a.par_status, 
								a.par_type,
								b.assd_name,
								c.pack_pol_flag 
							FROM    gipi_pack_parlist a, 
									GIIS_ASSURED b, 
									GIIS_LINE c 
							WHERE a.par_status < 7 
							AND a.par_type = 'E'
						    AND check_user_per_line2(a.line_cd,a.iss_cd,'GIPIS057',p_user_id) = 1 
						    AND check_user_per_iss_cd2 (a.line_cd, a.iss_cd,'GIPIS057',p_user_id) = 1  
							AND  a.assd_no = b.assd_no(+)
							AND a.line_cd = c.line_cd(+)
						    AND a.underwriter = p_user_id
							ORDER BY LINE_CD,ISS_CD,PAR_YY,PAR_SEQ_NO,QUOTE_SEQ_NO)
			LOOP
			   v_reassign.par_id            := i.par_id;
			   v_reassign.pack_par_id       := i.pack_par_id; 	
			   v_reassign.line_cd           := i.line_cd;
			   v_reassign.iss_cd        	:= i.iss_cd;	
			   v_reassign.par_yy            := i.par_yy;	
			   v_reassign.par_seq_no        := i.par_seq_no; 
			   v_reassign.quote_seq_no      := i.quote_seq_no;
			   v_reassign.assd_no           := i.assd_no;	
			   v_reassign.assign_sw         := i.assign_sw;
			   v_reassign.underwriter      	:= i.underwriter;  
			   v_reassign.remarks       	:= i.remarks;    	
			   v_reassign.par_status   		:= i.par_status;       
			   v_reassign.par_type			:= i.par_type;
			   v_reassign.assd_name 		:= i.assd_name;
			   v_reassign.pack_pol_flag		:= i.pack_pol_flag;
			   v_reassign.parstat_date		:= GIPI_REASSIGN_ENDT_PKG.get_parstat_date(i.par_id);
			   PIPE ROW (v_reassign);
			END LOOP;
		 END IF;
	END;
	
	FUNCTION get_parstat_date(p_par_id GIPI_PARLIST.par_id%TYPE)
	RETURN DATE
	IS
		v_parstat_date	DATE;
	BEGIN
		FOR i IN (SELECT a.parstat_date
					   FROM gipi_parhist a
					  WHERE a.par_id       = p_par_id
        				AND a.parstat_cd   =  '1'
   						ORDER BY a.parstat_date ASC) 
				LOOP
       				v_parstat_date  :=  i.parstat_date;
					EXIT;
  				END LOOP;
		RETURN v_parstat_date;
	END;
	
	FUNCTION get_reassign_par_endt_LOV( p_line_cd	GIPI_PARLIST.line_cd%TYPE,
									 	p_iss_cd	GIPI_PARLIST.iss_cd%TYPE)
  	RETURN gipi_underwriter_tab PIPELINED
   	AS
      v_underwriter          gipi_underwriter_type;
	BEGIN
		FOR i IN(SELECT DISTINCT A520.USER_ID UNDERWRITER ,A520.USER_GRP DSP_USER_GRP ,A520.USER_NAME DSP_USER_NAME
							FROM GIIS_USERS A520, GIIS_TRANSACTION A521, GIIS_USER_TRAN A522, GIIS_USER_GRP_TRAN A523
								WHERE A520.ACTIVE_FLAG = 'Y'
								AND ((A520.USER_ID = A522.USERID AND A522.TRAN_CD IN (2, 26))
								OR (A520.USER_GRP = A523.USER_GRP AND A523.TRAN_CD IN (2, 26)))
								AND A521.TRAN_CD IN (2, 26)
								AND (A521.TRAN_CD=A522.TRAN_CD
								OR A521.TRAN_CD=A523.TRAN_CD)
								AND A523.USER_GRP=A520.USER_GRP
								AND (A520.USER_ID IN
									(SELECT DISTINCT X.USER_ID
										FROM GIIS_USER_GRP_LINE Z, GIIS_USERS X
											WHERE z.TRAN_CD IN (2, 26)
								and Z.LINE_CD LIKE p_line_cd
								AND Z.ISS_CD LIKE p_iss_cd
								AND Z.USER_GRP=X.USER_GRP)
								OR A520.USER_ID IN
								(SELECT DISTINCT Y.USERID FROM GIIS_USER_LINE Y
								WHERE y.TRAN_CD IN (2, 26)
								AND Y.LINE_CD LIKE p_line_cd
								AND Y.ISS_CD LIKE p_iss_cd)
								)
								ORDER BY UNDERWRITER)
				
				LOOP
				 	v_underwriter.user_id		:= i.UNDERWRITER;
					v_underwriter.user_grp		:= i.DSP_USER_GRP;
					v_underwriter.user_name		:= i.DSP_USER_NAME;
				PIPE ROW (v_underwriter);
			END LOOP;
	END;	
	
	FUNCTION check_user(p_user_id			GIIS_USERS.user_id%TYPE,
						p_underwriter		GIPI_PARLIST.underwriter%TYPE)
	RETURN VARCHAR2
	AS
	  v_mis_sw      VARCHAR2(1):= 'N';
	  v_all_user_sw VARCHAR2(1):= 'N';
	  v_mgr_sw      VARCHAR2(1):= 'N';
	  v_allow		VARCHAR2(1):= 'Y';	
	BEGIN
		FOR i IN (SELECT NVL(mis_sw,'N') mis_sw, 
						 NVL(all_user_sw,'N') all_user_sw, 
						 NVL(mgr_sw,'N') mgr_sw
                	FROM giis_users
               			WHERE user_id = p_user_id)
				LOOP
					v_mis_sw      := i.mis_sw;
					v_all_user_sw := i.all_user_sw;
					v_mgr_sw      := i.mgr_sw;
					EXIT;
				END LOOP;
				IF p_user_id != p_underwriter THEN
					 IF v_all_user_sw = 'Y' AND v_mis_sw   = 'N' AND v_mgr_sw = 'N' THEN
					 	v_allow := 'N';
				 	 END IF;
				END IF;
		RETURN v_allow;
	END;

	PROCEDURE set_gipis_reassign_parlist(p_underwriter       	GIPI_PARLIST.underwriter%TYPE,
        									p_remarks           GIPI_PARLIST.remarks%TYPE,
											p_par_id			GIPI_PARLIST.par_id%TYPE,
											p_par_status		GIPI_PARLIST.par_status%TYPE,
											p_line_cd			GIPI_PARLIST.line_cd%TYPE)
	IS
	  v_exist               NUMBER;
	  v_parstat_date		DATE;
	  v_user_id				GIPI_PARHIST.user_id%TYPE;
	  v_entry_source		GIPI_PARHIST.entry_source%TYPE;
	  v_parstat_cd			GIPI_PARHIST.parstat_cd%TYPE;
	  v_pack_line			GIIS_LINE.line_cd%TYPE := NULL;
	BEGIN
		/* FOR pac IN (SELECT line_cd   -- added by adrel 09232009 so that package line is not hardcoded
					  FROM GIIS_LINE 
					  WHERE menu_line_cd LIKE 'PK') 
		  	LOOP
			   v_pack_line := pac.line_cd;
			   EXIT;             	
			END LOOP;
		IF v_pack_line IS NULL THEN
			v_pack_line:='@!'; -- no package line
		END IF; */
        -- marco - 04.29.2013 - modified retrieval of package line
        BEGIN
            SELECT GIISP.v('LINE_CODE_PK')
              INTO v_pack_line
              FROM DUAL;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN 
                v_pack_line := '';
        END;
		
        -- marco - 04.29.2013 - moved UPDATE statements inside IF block
		/* UPDATE GIPI_PARLIST
		   SET underwriter = p_underwriter, 
		       remarks = p_remarks
		 WHERE par_id = p_par_id;
		
		UPDATE GIPI_PACK_PARLIST
		   SET underwriter = p_underwriter, 
		       remarks = p_remarks
		 WHERE pack_par_id = p_par_id; */
		
		IF p_line_cd <> v_pack_line THEN
			GIPI_REASSIGN_ENDT_PKG.update_parhist(p_underwriter,p_remarks,p_par_id,p_par_status,p_line_cd);
            
            UPDATE GIPI_PARLIST
               SET underwriter = p_underwriter, 
                   remarks = p_remarks
             WHERE par_id = p_par_id;
		ELSE
			INSERT INTO GIPI_PACK_PARHIST(PACK_PAR_ID,USER_ID,PARSTAT_DATE,PARSTAT_CD)
		  	VALUES (p_par_id,p_underwriter,SYSDATE,p_par_status);	
		
		  	UPDATE GIPI_PACK_PARLIST
			   SET UNDERWRITER = p_underwriter,
                   remarks = p_remarks
		  	 WHERE PACK_PAR_ID = p_par_id;
		 
		  	UPDATE GIPI_PARLIST
		  	   SET underwriter = p_underwriter,
                   remarks = p_remarks
		  	 WHERE PACK_PAR_ID = p_par_id;    
		END IF;
	END;
	
	PROCEDURE update_parhist(p_underwriter       GIPI_PARLIST.underwriter%TYPE,
								p_remarks           GIPI_PARLIST.remarks%TYPE,
								p_par_id			GIPI_PARLIST.par_id%TYPE,
								p_par_status		GIPI_PARLIST.par_status%TYPE,
								p_line_cd			GIPI_PARLIST.line_cd%TYPE) 
	IS
	  v_exist           NUMBER;
	  v_parstat_date	DATE;
	  v_user_id			gipi_parhist.user_id%TYPE;
	  v_entry_source	gipi_parhist.entry_source%TYPE;
	  v_parstat_cd		gipi_parhist.parstat_cd%TYPE;
	
	BEGIN
	  FOR A IN (SELECT par_status
				  FROM gipi_parlist
				 WHERE par_id = p_par_id) 
		 LOOP
			INSERT INTO gipi_parhist(par_id,user_id,parstat_date,
									 entry_source,parstat_cd)
			VALUES (p_par_id,p_underwriter,SYSDATE,'DB',a.par_status);
			v_exist  :=  1;    
			EXIT;
	  	END LOOP;
		
	  IF v_exist IS NULL THEN
		INSERT INTO gipi_parhist(par_id,user_id,parstat_date,
								 entry_source,parstat_cd)
		VALUES (p_par_id,p_underwriter,SYSDATE,'DB','2');
	  END IF;
	  
	  FOR A IN (SELECT '1'
				  FROM gipi_wpolbas
				 WHERE par_id = p_par_id)
		  LOOP
			UPDATE gipi_wpolbas
			   SET user_id = p_underwriter
			 WHERE par_id = p_par_id;
			EXIT;	             
		  END LOOP;  
	END;
	
	PROCEDURE CREATE_TRANSFER_WORKFLOW_REC(p_module_id  	IN VARCHAR2,
											p_underwriter 	IN VARCHAR2,
										   	p_user_id       IN VARCHAR2,
										   	p_par_id  		IN VARCHAR2,
											p_line_cd  		IN VARCHAR2,
											p_iss_cd  		IN VARCHAR2,
											p_par_yy  		IN VARCHAR2,
											p_par_seq_no	IN VARCHAR2,
											p_quote_seq_no	IN VARCHAR2,
											p_msg    		OUT VARCHAR2) IS
	  v_event_user_mod     gipi_user_events.event_user_mod%TYPE; 
	  v_event_col_cd       gipi_user_events.event_col_cd%TYPE;
	  v_event_user_mod_old gipi_user_events.event_user_mod%TYPE; 
	  v_event_col_cd_old   gipi_user_events.event_col_cd%TYPE;
	  v_tran_id            gipi_user_events.tran_id%TYPE;
	  v_event_mod_cd       giis_event_modules.event_mod_cd%TYPE;
	  v_count              NUMBER;
	  v_gem_event_mod_cd   giis_event_modules.event_mod_cd%TYPE:=NULL;  --A.R.C. 01.20.2006
	BEGIN
	 p_msg := NULL;
	 --A.R.C. 01.20.2006	
	 FOR c1 IN (SELECT b.event_mod_cd  
					FROM giis_event_modules b, giis_events a
						   WHERE 1=1
						   AND b.module_id = p_module_id
						   AND b.event_cd = a.event_cd
						   AND UPPER(a.event_desc) = UPPER(a.event_desc))
	 LOOP
		 v_gem_event_mod_cd := c1.event_mod_cd;
	 END LOOP;		
	 IF wf.check_wf_user(v_gem_event_mod_cd,p_user_id,p_underwriter) THEN	
	  BEGIN
		SELECT b.event_user_mod, c.event_col_cd  
			INTO v_event_user_mod, v_event_col_cd
			FROM giis_events_column c, giis_event_mod_users b, giis_event_modules a, giis_events d
		   WHERE 1=1
		   AND c.event_cd = a.event_cd
		   AND c.event_mod_cd = a.event_mod_cd
		   AND b.event_mod_cd = a.event_mod_cd
			 --AND b.userid = p_user  --A.R.C. 01.27.2006
			 AND b.passing_userid = p_user_id  --A.R.C. 01.27.2006
			 AND NVL(b.userid,p_underwriter) = p_underwriter  --A.R.C. 01.27.2006
		   AND a.module_id = p_module_id
		   AND a.event_cd = d.event_cd
		   AND UPPER(d.event_desc) = UPPER(d.event_desc);
		EXCEPTION
		  WHEN NO_DATA_FOUND THEN        
			 raise_application_error
                                   (-20001,
                                       'Geniisys Exception#imgMessage.ERROR#Invalid user.');
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
		   AND col_value = p_par_id
		   AND rownum = 1;
	  END;	
		  IF v_count = 0 THEN
		   INSERT INTO gipi_user_events(event_user_mod, event_col_cd, tran_id, switch, col_value, user_id)
				  VALUES(v_event_user_mod, v_event_col_cd, v_tran_id, 'N', p_par_id, p_underwriter);
	
	
		   BEGIN
			 SELECT b.event_user_mod, c.event_col_cd  
				 INTO v_event_user_mod_old, v_event_col_cd_old
			FROM giis_events_column c, giis_event_mod_users b, giis_event_modules a, giis_events d
		   WHERE 1=1
		   AND c.event_cd = a.event_cd
		   AND c.event_mod_cd = a.event_mod_cd
		   AND b.event_mod_cd = a.event_mod_cd
			 --AND b.userid = USER  --A.R.C. 01.27.2006
			 AND b.passing_userid = p_user_id  --A.R.C. 01.27.2006
			 AND NVL(b.userid,p_underwriter) = p_underwriter  --A.R.C. 01.27.2006	     
		   AND a.module_id = p_module_id
		   AND a.event_cd = d.event_cd
		   AND UPPER(d.event_desc) = UPPER(d.event_desc);
			 EXCEPTION
			   WHEN NO_DATA_FOUND THEN
				 raise_application_error
                                   (-20001,
                                       'Geniisys Exception#imgMessage.ERROR#Invalid user.');
		   END;
		   INSERT INTO gipi_user_events_hist(event_user_mod, event_col_cd, tran_id, col_value, date_received, old_userid, new_userid)
				VALUES(v_event_user_mod_old, v_event_col_cd_old, v_tran_id, p_par_id, SYSDATE, p_user_id, p_underwriter);
			 p_msg := p_user_id||' assigned a new transaction.'||' - PAR Reassignment '||p_line_cd||'-'|| p_iss_cd|| '-'|| LTRIM (TO_CHAR (p_par_yy, '09'))|| '-'|| LTRIM (TO_CHAR (p_par_seq_no, '0999999'))|| '-'|| LTRIM (TO_CHAR (p_quote_seq_no, '09'));
			 --HOST(WF.GET_POPUP_DIR||'realpopup.exe -send '||p_underwriter||' "'||p_user_id||' assigned a new transaction.'||' - PAR Reassignment '||:b240.line_cd||'-'|| :b240.iss_cd|| '-'|| LTRIM (TO_CHAR (:b240.par_yy, '09'))|| '-'|| LTRIM (TO_CHAR (:b240.par_seq_no, '0999999'))|| '-'|| LTRIM (TO_CHAR (:b240.quote_seq_no, '09'))||'" -noactivate');     
		  END IF;		
	 END IF;
	END;
END;
/


