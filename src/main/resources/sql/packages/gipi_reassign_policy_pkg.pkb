CREATE OR REPLACE PACKAGE BODY CPI.GIPI_REASSIGN_POLICY_PKG
AS
	/*
   **  Created by   :  Steven Ramirez
   **  Date Created : 06.13.2012
   **  Reference By : GIPIS051 - Re-assign Par Policy to a new User
   **  Description  : Great ability develops and reveals itself increasingly with every new assignment. :)
   */
   FUNCTION get_reassign_par_policy(p_user_id   GIIS_USERS.user_id%TYPE)
      RETURN gipi_reassign_policy_tab PIPELINED
   AS
      v_reassign          gipi_reassign_policy_type;
      v_all_user		  VARCHAR2(1) := 'N';
   BEGIN
     FOR ALL_USER IN ( SELECT '1'
						 FROM giis_users
						WHERE user_id = p_user_id
						  AND NVL(all_user_sw,'N') ='Y') 
     LOOP 
        v_all_user := 'Y';
     END LOOP;
     
     IF v_all_user = 'Y' THEN
        FOR i IN(SELECT a.PAR_ID,a.pack_par_id,a.LINE_CD,a.ISS_CD,a.PAR_YY,a.PAR_SEQ_NO,a.QUOTE_SEQ_NO,a.ASSD_NO,a.ASSIGN_SW,a.UNDERWRITER,a.REMARKS,a.PAR_STATUS,a.PAR_TYPE,
                       b.assd_name,
                       c.pack_pol_flag
                      FROM GIPI_PARLIST a, GIIS_ASSURED b, GIIS_LINE c
                        WHERE a.PAR_STATUS <= 7 AND a.PAR_TYPE = 'P' 
                            AND a.PACK_PAR_ID IS NULL 
                            AND check_user_per_line2(a.line_cd, a.ISS_CD,'GIPIS051',p_user_id) = 1 
                            AND check_user_per_iss_cd2 (a.line_cd, a.ISS_CD,'GIPIS051',p_user_id) = 1  
                            AND  a.assd_no = b.assd_no(+)
                            AND a.line_cd = c.line_cd(+)
                            UNION ALL SELECT a.PACK_PAR_ID,a.pack_par_id,a.LINE_CD,a.ISS_CD,a.PAR_YY,a.PAR_SEQ_NO,a.QUOTE_SEQ_NO,a.ASSD_NO,a.ASSIGN_SW,a.UNDERWRITER,a.REMARKS,a.PAR_STATUS,a.PAR_TYPE, 
                               b.assd_name,
                               c.pack_pol_flag
                                FROM GIPI_PACK_PARLIST a,GIIS_ASSURED b, GIIS_LINE c
                                    WHERE a.PAR_STATUS <= 7 
                                        AND a.PAR_TYPE = 'P' 
                                        AND check_user_per_line2(a.line_cd, a.ISS_CD,'GIPIS051',p_user_id) = 1 
                                        AND check_user_per_iss_cd2 (a.line_cd, a.ISS_CD,'GIPIS051',p_user_id) = 1 
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
           v_reassign.parstat_date		:= GIPI_REASSIGN_POLICY_PKG.get_parstat_date(i.par_id);
           PIPE ROW (v_reassign);
        END LOOP;
     ELSE
        FOR i IN(SELECT a.PAR_ID,a.pack_par_id,a.LINE_CD,a.ISS_CD,a.PAR_YY,a.PAR_SEQ_NO,a.QUOTE_SEQ_NO,a.ASSD_NO,a.ASSIGN_SW,a.UNDERWRITER,a.REMARKS,a.PAR_STATUS,a.PAR_TYPE,
                       b.assd_name,
                       c.pack_pol_flag
                      FROM GIPI_PARLIST a, GIIS_ASSURED b, GIIS_LINE c
                        WHERE a.PAR_STATUS <= 7 AND a.PAR_TYPE = 'P' 
                            AND a.PACK_PAR_ID IS NULL 
                            AND check_user_per_line2(a.line_cd, a.ISS_CD,'GIPIS051',p_user_id) = 1 
                            AND check_user_per_iss_cd2 (a.line_cd, a.ISS_CD,'GIPIS051',p_user_id) = 1  
                            AND a.underwriter = p_user_id
                            AND  a.assd_no = b.assd_no(+)
                            AND a.line_cd = c.line_cd(+)
                            UNION ALL SELECT a.PACK_PAR_ID,a.pack_par_id,a.LINE_CD,a.ISS_CD,a.PAR_YY,a.PAR_SEQ_NO,a.QUOTE_SEQ_NO,a.ASSD_NO,a.ASSIGN_SW,a.UNDERWRITER,a.REMARKS,a.PAR_STATUS,a.PAR_TYPE, 
                               b.assd_name,
                               c.pack_pol_flag
                                FROM GIPI_PACK_PARLIST a,GIIS_ASSURED b, GIIS_LINE c
                                    WHERE a.PAR_STATUS <= 7 
                                        AND a.PAR_TYPE = 'P' 
                                        AND check_user_per_line2(a.line_cd, a.ISS_CD,'GIPIS051',p_user_id) = 1 
                                        AND check_user_per_iss_cd2 (a.line_cd, a.ISS_CD,'GIPIS051',p_user_id) = 1 
                                        AND  a.assd_no = b.assd_no(+)
                                        AND a.line_cd = c.line_cd(+)
                                        AND a.underwriter = p_user_id
                        ORDER BY LINE_CD,ISS_CD,PAR_YY,PAR_SEQ_NO,QUOTE_SEQ_NO)
        LOOP
           v_reassign.par_id            := i.par_id;
           v_reassign.pack_par_id       := i.pack_par_id;     
           v_reassign.line_cd           := i.line_cd;
           v_reassign.iss_cd            := i.iss_cd;    
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
           v_reassign.parstat_date		:= GIPI_REASSIGN_POLICY_PKG.get_parstat_date(i.par_id);
           PIPE ROW (v_reassign);
        END LOOP;
     END IF;

   END;
	
	FUNCTION get_parstat_date(p_par_id GIPI_PARLIST.par_id%TYPE)
	RETURN DATE
	IS
		v_parstat_date	DATE;
	BEGIN
		    SELECT TO_DATE(TO_CHAR(min(parstat_date), 'MM-DD-YYYY'),'MM-DD-YYYY')
    		INTO v_parstat_date
    		FROM GIPI_PARHIST a
				WHERE a.par_id       = p_par_id
					AND a.parstat_cd   =  '1';
				
		RETURN v_parstat_date;
		EXCEPTION
			WHEN NO_DATA_FOUND THEN 
			RETURN '';
	END;

	PROCEDURE set_gipis_reassign_parlist(p_underwriter       	GIPI_PARLIST.underwriter%TYPE,
        									p_remarks           GIPI_PARLIST.remarks%TYPE,
											p_par_id			GIPI_PARLIST.par_id%TYPE,
											p_par_status		GIPI_PARLIST.par_status%TYPE,
											p_line_cd			GIPI_PARLIST.line_cd%TYPE,
											p_cond				VARCHAR2)
	IS
	  v_exist               NUMBER;
	  v_parstat_date		DATE;
	  v_user_id				GIPI_PARHIST.user_id%TYPE;
	  v_entry_source		GIPI_PARHIST.entry_source%TYPE;
	  v_parstat_cd			GIPI_PARHIST.parstat_cd%TYPE;
	  v_pack_line			GIIS_LINE.line_cd%TYPE;
	BEGIN
        --marco - 04.29.2013 - moved update statements below
		/* UPDATE GIPI_PARLIST
		SET underwriter = p_underwriter, 
			remarks = p_remarks
		WHERE par_id = p_par_id;
		
		UPDATE GIPI_PACK_PARLIST
		SET underwriter = p_underwriter, 
			remarks = p_remarks
		WHERE PACK_PAR_ID = p_par_id; */
        
        BEGIN
            SELECT GIISP.v('LINE_CODE_PK')
              INTO v_pack_line
              FROM DUAL;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN 
                v_pack_line := '';
        END;
	
		--IF p_cond = '1' THEN
			--to add GIPI_PARHIST
            IF p_line_cd <> v_pack_line THEN
                FOR A IN (SELECT par_status
                            FROM gipi_parlist
                           WHERE par_id = p_par_id) 
                LOOP
                    UPDATE GIPI_PARLIST
                       SET underwriter = p_underwriter, 
                           remarks = p_remarks
                     WHERE par_id = p_par_id;
                
                    INSERT INTO gipi_parhist(par_id,user_id,parstat_date,
                                             entry_source,parstat_cd)
                    VALUES (p_par_id,p_underwriter,SYSDATE,'DB',a.par_status);
                    v_exist  :=  1;    
                    EXIT;
                END LOOP;
            ELSE
            --IF v_exist IS NULL THEN
                UPDATE GIPI_PACK_PARLIST
		           SET underwriter = p_underwriter, 
			           remarks = p_remarks
		         WHERE pack_par_id = p_par_id;
                 
                UPDATE GIPI_PARLIST
		           SET underwriter = p_underwriter, 
			           remarks = p_remarks
		         WHERE pack_par_id = p_par_id;
            
                INSERT INTO gipi_pack_parhist(pack_par_id,user_id,parstat_date,
                                              entry_source,parstat_cd)
                VALUES (p_par_id,p_underwriter,SYSDATE,'DB','2');
            END IF;
				
            -- marco - 04.29.2013 - comment out
            --to add either GIPI_PARHIST or GIPI_PACK_PARHIST 
            /* FOR pac IN (SELECT line_cd   -- so that package line is not hardcoded
                          FROM GIIS_LINE 
                         WHERE menu_line_cd LIKE 'PK')
            LOOP
                v_pack_line := pac.line_cd;
                EXIT;             	
            END LOOP;
            
            IF v_pack_line IS NULL THEN -- to handle clients without package line
                v_pack_line := '@!';
            END IF;
            				
            IF p_line_cd <> v_pack_line THEN	
                INSERT INTO GIPI_PARHIST(PAR_ID,USER_ID,PARSTAT_DATE,PARSTAT_CD)
                VALUES(p_par_id,p_underwriter,SYSDATE,p_par_status);		  
            ELSE
                INSERT INTO GIPI_PACK_PARHIST(PACK_PAR_ID,USER_ID,PARSTAT_DATE,PARSTAT_CD)
                VALUES(p_par_id,p_underwriter,SYSDATE,p_par_status);	
            				
                UPDATE GIPI_PACK_PARLIST
                SET UNDERWRITER = p_underwriter
                WHERE PACK_PAR_ID = p_par_id; 
            				  
                UPDATE GIPI_PARLIST
                SET underwriter = p_underwriter
                WHERE PACK_PAR_ID = p_par_id;
            END IF; */
		--END IF;	
	END;
	
  	FUNCTION get_reassign_par_policy_LOV(p_line_cd	GIPI_PARLIST.line_cd%TYPE,
									 p_iss_cd	GIPI_PARLIST.iss_cd%TYPE)
  	RETURN gipi_underwriter_tab PIPELINED
   	AS
      v_underwriter          gipi_underwriter_type;
	BEGIN
		FOR i IN(SELECT DISTINCT A520.USER_ID UNDERWRITER ,A520.USER_GRP DSP_USER_GRP ,A520.USER_NAME DSP_USER_NAME
            FROM GIIS_USERS A520, GIIS_TRANSACTION A521, GIIS_USER_TRAN A522, GIIS_USER_GRP_TRAN A523
                WHERE A520.ACTIVE_FLAG = 'Y'
                    AND ((A520.USER_ID = A522.USERID AND A522.TRAN_CD IN (1, 26))
                    OR (A520.USER_GRP = A523.USER_GRP AND A523.TRAN_CD IN (1, 26)))
                    AND A521.TRAN_CD IN (1, 26)
                    AND (A521.TRAN_CD=A522.TRAN_CD
                        OR A521.TRAN_CD=A523.TRAN_CD)
                    AND A523.USER_GRP=A520.USER_GRP
                    AND (A520.USER_ID IN
                        (SELECT DISTINCT X.USER_ID
                            FROM GIIS_USER_GRP_LINE Z, GIIS_USERS X
                                WHERE z.TRAN_CD IN (1, 26)
                                AND Z.LINE_CD LIKE p_line_cd
                                AND Z.ISS_CD LIKE p_iss_cd
                                AND Z.USER_GRP=X.USER_GRP)
                        OR A520.USER_ID IN
                        (SELECT DISTINCT Y.USERID FROM GIIS_USER_LINE Y
                            WHERE y.TRAN_CD IN (1, 26)
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
    
    
    FUNCTION get_user_sw(p_user_id   GIIS_USERS.user_id%TYPE)
      RETURN get_user_sw_tab PIPELINED
   AS
      v_rec        get_user_sw_type;
   BEGIN
     FOR i IN ( SELECT *
						 FROM giis_users
						WHERE user_id = p_user_id) 
     LOOP 
        v_rec.mgr_sw := i.mgr_sw;
        v_rec.mis_sw := i.mis_sw;
        v_rec.all_user_sw := i.all_user_sw;
        PIPE ROW(v_rec);
     END LOOP;
   END;
	
END GIPI_REASSIGN_POLICY_PKG;
/


