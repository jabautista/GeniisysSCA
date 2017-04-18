CREATE OR REPLACE PACKAGE BODY CPI.GIEX_SMS_DTL_PKG
AS

   /*
   ** Created by    : Marco Paolo Rebong
   ** Referenced by : (GISMS007 - SMS Renewal)
   ** Description   : retrieves policy message details
   */
    FUNCTION get_giex_sms_dtl(
        p_policy_id             GIEX_SMS_DTL.policy_id%TYPE
    )
      RETURN giex_sms_dtl_tab PIPELINED
    IS
        v_sms                   giex_sms_dtl_type;
    BEGIN
        FOR i IN(SELECT a.*, b.message_status
                   FROM GIEX_SMS_DTL a,
                        GISM_MESSAGES_SENT b
                  WHERE policy_id = p_policy_id
                    AND a.msg_id = b.msg_id)
        LOOP
            v_sms.policy_id := i.policy_id;
            v_sms.cellphone_no := i.cellphone_no;
            v_sms.message := i.message;
            v_sms.date_received := i.date_received;
            v_sms.date_sent := i.date_sent;
            v_sms.dsp_date_created := TO_CHAR(i.date_created, 'MM-DD-YYYY HH:MI:SS AM');
            v_sms.dsp_date_sent := TO_CHAR(i.date_sent, 'MM-DD-YYYY HH:MI:SS AM');
            v_sms.dsp_date_received := TO_CHAR(i.date_received, 'MM-DD-YYYY HH:MI:SS AM');
            v_sms.user_id := i.user_id;
            v_sms.last_update := i.last_update;
            v_sms.recipient_sender := i.recipient_sender;
            v_sms.msg_id := i.msg_id;
            v_sms.dtl_id := i.dtl_id;
            v_sms.message_type := i.message_type;

            IF i.message_status = 'C' THEN
		        v_sms.message_status := 'CANCELLED';
            ELSIF i.message_status = 'E' THEN
                v_sms.message_status := 'WITH ERROR';
            ELSIF i.message_status = 'Q' THEN
                v_sms.message_status := 'ON QUEUE';
            ELSIF i.message_status = 'S' THEN
                v_sms.message_status := 'SUCCESSFULLY SENT';
            ELSIF i.message_status = 'W' THEN
                v_sms.message_status := 'SENT WITH ERROR';	
            END IF;
            
            PIPE ROW(v_sms);
        END LOOP;        
    END;
    
   /*
   ** Created by    : Marco Paolo Rebong
   ** Referenced by : (GISMS007 - SMS Renewal)
   ** Description   : retrieves policy details for sms renewal
   */
    FUNCTION get_policy_details(
        p_line_cd               GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd            GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd                GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy              GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no            GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no              GIPI_POLBASIC.renew_no%TYPE
    )
      RETURN policy_details_tab PIPELINED AS
        v_pol                   policy_details_dtls;
    BEGIN
        FOR p IN(SELECT policy_id
                   FROM GIPI_POLBASIC
                  WHERE line_cd = p_line_cd
                    AND subline_cd = p_subline_cd
                    AND iss_cd = p_iss_cd
                    AND issue_yy = p_issue_yy
                    AND pol_seq_no = p_pol_seq_no
                    AND renew_no = p_renew_no
                    AND pol_flag IN ('1','2','3')
                  ORDER BY eff_date)
        LOOP
            FOR i IN (SELECT a.iss_cd, a.prem_seq_no, a.due_date, SUM(b.balance_amt_due) balance_due
                        FROM GIPI_INVOICE a,
                             GIAC_AGING_SOA_DETAILS b
                       WHERE a.policy_id = p.policy_id
                         AND a.iss_cd = b.iss_cd
                         AND a.prem_seq_no = b.prem_seq_no
                       GROUP BY a.iss_cd, a.prem_seq_no, a.due_date)
            LOOP
                v_pol.iss_cd := i.iss_cd;
                v_pol.prem_seq_no := i.prem_seq_no;
                v_pol.balance_due := i.balance_due;
                v_pol.due_date := TO_CHAR(i.due_date, 'DD-MON-YYYY');
                v_pol.invoice_no := i.iss_cd || '-' || i.prem_seq_no;
                PIPE ROW(v_pol);
            END LOOP;
        END LOOP;
    END;
    
   /*
   ** Created by    : Marco Paolo Rebong
   ** Referenced by : (GISMS007 - SMS Renewal)
   ** Description   : retrieves claim details for sms renewal
   */
    FUNCTION get_claim_details(
        p_line_cd               GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd            GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd                GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy              GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no            GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no              GIPI_POLBASIC.renew_no%TYPE
    )
      RETURN claim_details_tab PIPELINED AS
        v_clm                   claim_details_dtls;
    BEGIN
        FOR i IN(SELECT iss_cd, clm_yy, clm_seq_no, loss_res_amt, loss_pd_amt, clm_file_date, clm_stat_cd
                   FROM GICL_CLAIMS
                  where line_cd = p_line_cd 
                    and subline_cd = p_subline_cd
                    and pol_iss_cd = p_iss_cd
                    and issue_yy = p_issue_yy
                    and pol_seq_no = p_pol_seq_no
                    and renew_no = p_renew_no
                    and clm_stat_cd NOT in ('CC','DN','WD'))
        LOOP
            BEGIN
                SELECT a.clm_stat_desc
                  INTO v_clm.clm_stat_desc
                  FROM GIIS_CLM_STAT a
                 WHERE i.clm_stat_cd = a.clm_stat_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_clm.clm_stat_desc := NULL;
            END;
            
            v_clm.iss_cd := i.iss_cd;
            v_clm.clm_yy := i.clm_yy;
            v_clm.clm_seq_no := i.clm_seq_no;
            v_clm.loss_res_amt := i.loss_res_amt;
            v_clm.loss_pd_amt := i.loss_pd_amt;
            v_clm.clm_file_date := TO_CHAR(i.clm_file_date, 'DD-MON-YYYY');
            v_clm.claim_no := i.iss_cd || '-' || i.clm_yy || '-' || i.clm_seq_no;
            PIPE ROW(v_clm);
        END LOOP;
    END;
    
   /*
   ** Created by    : Marco Paolo Rebong
   ** Referenced by : (GISMS007 - SMS Renewal)
   ** Description   : checks if sms can be sent to assured
   */
    PROCEDURE check_sms_assured(
        p_policy_id     IN      GIEX_SMS_DTL.policy_id%TYPE,
        p_assd_no       IN      GIEX_EXPIRY.assd_no%TYPE,
        p_assd_cp_no    OUT     GIIS_ASSURED.cp_no%TYPE,
        p_msg_count     OUT     NUMBER
    )
    AS
    BEGIN
        p_assd_cp_no := NULL;
        p_msg_count := 0;
    
        FOR a IN (SELECT cp_no
                    FROM GIIS_ASSURED
                   WHERE assd_no = p_assd_no)
        LOOP
            p_assd_cp_no := a.cp_no;
            EXIT;
        END LOOP;
        
        IF p_assd_cp_no IS NULL THEN
            RETURN;
        END IF;
        
        FOR a IN (SELECT count(a.msg_id) msg
                    FROM GISM_MESSAGES_SENT a,
                         GIEX_SMS_DTL b
                   WHERE a.msg_id = b.msg_id
                     AND b.policy_id = p_policy_id
                     AND (a.message_status = 'Q' OR a.message_status = 'S'))
        LOOP
            p_msg_count := a.msg;
        END LOOP;
    END;
    
   /*
   ** Created by    : Marco Paolo Rebong
   ** Referenced by : (GISMS007 - SMS Renewal)
   ** Description   : checks if sms can be sent to intermediary
   */
    PROCEDURE check_sms_intm(
        p_policy_id     IN      GIEX_SMS_DTL.policy_id%TYPE,
        p_intm_no       IN      GIEX_EXPIRY.intm_no%TYPE,
        p_intm_cp_no    OUT     GIIS_INTERMEDIARY.cp_no%TYPE,
        p_msg_count     OUT     NUMBER
    )
    IS
    BEGIN
        p_intm_cp_no := NULL;
        p_msg_count := 0;
    
        FOR a IN (SELECT cp_no
                    FROM GIIS_INTERMEDIARY
                   WHERE intm_no = p_intm_no)
        LOOP
            p_intm_cp_no := a.cp_no;
            EXIT;
        END LOOP;
        
        IF p_intm_cp_no IS NULL THEN
            RETURN;
        END IF;
        
        FOR a IN (SELECT count(a.msg_id) msg
                    FROM GISM_MESSAGES_SENT a,
                         GIEX_SMS_DTL b
                   WHERE a.msg_id = b.msg_id
                     AND b.policy_id = p_policy_id
                     AND (a.message_status = 'Q' OR a.message_status = 'S'))
        LOOP
            p_msg_count := a.msg;
        END LOOP;
    END;
    
   /*
   ** Created by    : Marco Paolo Rebong
   ** Referenced by : (GISMS007 - SMS Renewal)
   ** Description   : updates tags for sms sending
   */
    PROCEDURE update_sms_tags(
        p_policy_id             GIEX_SMS_DTL.policy_id%TYPE,
        p_assd_sms              GIEX_EXPIRY.assd_sms%TYPE,
        p_intm_sms              GIEX_EXPIRY.intm_sms%TYPE
    )
    IS
    
    BEGIN
        UPDATE GIEX_EXPIRY
           SET assd_sms = p_assd_sms,
               intm_sms = p_intm_sms
         WHERE policy_id = p_policy_id;
    END;
    
   /*
   ** Created by    : Marco Paolo Rebong
   ** Created date  : February 14, 2013
   ** Referenced by : (GISMS007 - SMS Renewal)
   ** Description   : generate sms message
   */
    PROCEDURE generate_sms(
        p_user_id               GIEX_SMS_DTL.user_id%TYPE
    )
    IS
        v_message_ren 			VARCHAR2(500);
	    v_message_non_ren		VARCHAR2(500);
        v_message   		    VARCHAR2(500);
	    v_msg_id				GISM_MESSAGES_SENT_DTL.msg_id%TYPE;
        v_group_intm			GISM_MESSAGES_SENT_DTL.group_cd%TYPE := GIACP.n('SMS_INTM_GRP');
	    v_group_assd			GISM_MESSAGES_SENT_DTL.group_cd%TYPE := GIACP.n('SMS_ASSURED_GRP');
	    v_pk_column_value		GISM_MESSAGES_SENT_DTL.pk_column_value%TYPE;
	    v_recipient_name		GISM_MESSAGES_SENT_DTL.recipient_name%TYPE;
	    v_cellphone_no			GISM_MESSAGES_SENT_DTL.cellphone_no%TYPE;
	    v_dtl_id				GISM_MESSAGES_SENT_DTL.dtl_id%TYPE;
	    v_sms_flag				GIEX_EXPIRY.sms_flag%TYPE;
    BEGIN
        FOR ren_msg IN(SELECT message 
                         FROM GISM_MESSAGE_TEMPLATE
                        WHERE message_cd = 'RENEW'
                          AND key_word = 'RENEW')
        LOOP
            v_message_ren := ren_msg.message;
            EXIT;
        END LOOP;
        
        FOR non_ren_msg IN(SELECT message 
		                     FROM GISM_MESSAGE_TEMPLATE
		                    WHERE message_cd = 'NONRENEW'
		                      AND key_word = 'RENEW')
        LOOP
  	        v_message_non_ren := non_ren_msg.message;
  	        EXIT;
        END LOOP;
        
        FOR renewal IN(SELECT renew_flag, policy_id, expiry_date, renewal_id,
                              intm_sms, assd_sms,intm_no, assd_no, 
                              line_cd||'-'||subline_cd||'-'||iss_cd||'-'||issue_yy||'-'||pol_seq_no||'-'||renew_no policy_no
                         FROM GIEX_EXPIRY
                        WHERE NVL(post_flag,'N') = 'N' 
                          AND (intm_sms = 'Y' OR assd_sms = 'Y')
                          AND check_user_per_iss_cd2(line_cd, iss_cd, 'GISMS007', p_user_id) = 1) -- marco - 05.26.2015 - GENQA SR 4485
	    LOOP
            v_message := NULL;
		    v_msg_id := 0;
            
            IF renewal.renew_flag = 2 OR renewal.renew_flag = 3 THEN
                v_message := REPLACE(REPLACE(REPLACE(v_message_ren,'<POL_NO>',renewal.policy_no),'<RENEWAL_ID>',renewal.renewal_id), '<EXPIRY_DATE>', renewal.expiry_date);
                
                FOR rec IN(SELECT gism_messages_sent_msg_id_s.NEXTVAL seq
  	  	                     FROM dual)
                LOOP
                    v_msg_id := rec.seq;
                    EXIT;
                END LOOP;
                
                INSERT INTO GISM_MESSAGES_SENT
			           (msg_id, message, sched_date, priority)
			    VALUES (v_msg_id, v_message, SYSDATE+(0.20/288), 2);	
                
                IF renewal.intm_sms = 'Y' THEN
                    v_dtl_id := 1;				
				    v_pk_column_value := NULL;
		            v_recipient_name := NULL;
		            v_cellphone_no := NULL;
                    
                    FOR a IN(SELECT intm_no, intm_name, cp_no
					           FROM GIIS_INTERMEDIARY
						      WHERE intm_no = renewal.intm_no)
				    LOOP
                        v_pk_column_value := a.intm_no;
					    v_recipient_name := a.intm_name;
					    v_cellphone_no := '+639' || SUBSTR(a.cp_no, LENGTH(a.cp_no)-8, LENGTH(a.cp_no));
				    END LOOP;
                    
                    INSERT INTO GISM_MESSAGES_SENT_DTL
				 	 	   (msg_id, group_cd, pk_column_value, recipient_name, cellphone_no, status_sw, last_update)
				 	VALUES (v_msg_id, v_group_intm, v_pk_column_value, v_recipient_name, v_cellphone_no, 'Q', SYSDATE);
                    
                    FOR A IN (SELECT MAX(dtl_id) dtl_id
						        FROM GISM_MESSAGES_SENT_DTL
						       WHERE msg_id = v_msg_id)
				    LOOP
                        v_dtl_id := a.dtl_id;
				    END LOOP;
                    
                    INSERT INTO GIEX_SMS_DTL
                           (policy_id, message, date_created, cellphone_no, message_type, msg_id, dtl_id, user_id, last_update)
                    VALUES (renewal.policy_id, v_message, SYSDATE, v_cellphone_no, 'R', v_msg_id, v_dtl_id, p_user_id, SYSDATE);
                END IF;
                
                IF renewal.assd_sms = 'Y' THEN
                    v_dtl_id := 1;				
                    v_pk_column_value := NULL;
		            v_recipient_name := NULL;
		            v_cellphone_no := NULL;
                    
                    FOR a IN(SELECT assd_no, assd_name, cp_no
					           FROM GIIS_ASSURED
						      WHERE assd_no = renewal.assd_no)
				    LOOP
                        v_pk_column_value := a.assd_no;
					    v_recipient_name := a.assd_name;
					    v_cellphone_no := '+639' || SUBSTR(a.cp_no, LENGTH(a.cp_no)-8, LENGTH(a.cp_no));
				    END LOOP;
                    
                    INSERT INTO GISM_MESSAGES_SENT_DTL
                           (msg_id, group_cd, pk_column_value, recipient_name, cellphone_no, status_sw, last_update)
                    VALUES (v_msg_id, v_group_assd, v_pk_column_value, v_recipient_name, v_cellphone_no, 'Q', SYSDATE);
                    
                    FOR A IN (SELECT MAX(dtl_id) dtl_id
						        FROM GISM_MESSAGES_SENT_DTL
						       WHERE msg_id = v_msg_id)
				    LOOP
                        v_dtl_id := a.dtl_id;
				    END LOOP;
                    
                    INSERT INTO GIEX_SMS_DTL
                           (policy_id, message, date_created, cellphone_no, message_type, msg_id, dtl_id, user_id, last_update)
                    VALUES (renewal.policy_id, v_message, SYSDATE, v_cellphone_no, 'R', v_msg_id, v_dtl_id, p_user_id, SYSDATE);
                END IF;
                
                UPDATE GIEX_EXPIRY
			       SET assd_sms = 'N',
			           intm_sms = 'N'
			     WHERE policy_id = renewal.policy_id;
            ELSE     
                v_message := REPLACE(REPLACE(v_message_non_ren,'<POL_NO>',renewal.policy_no),'<EXPIRY_DATE>', renewal.expiry_date);
                
                FOR rec IN(SELECT gism_messages_sent_msg_id_s.NEXTVAL seq
  	  	                     FROM dual)
                LOOP
                    v_msg_id := rec.seq;
                    EXIT;
                END LOOP;
                
                INSERT INTO GISM_MESSAGES_SENT
			           (msg_id, message, sched_date, priority)
			    VALUES (v_msg_id, v_message, SYSDATE+(.20/288), 2);
                
                IF renewal.intm_sms = 'Y' THEN
                    v_dtl_id := 1;				
                    v_pk_column_value := NULL;
                    v_recipient_name := NULL;
                    v_cellphone_no := NULL;
                    
                    FOR a IN(SELECT intm_no, intm_name, cp_no
					           FROM GIIS_INTERMEDIARY
						      WHERE intm_no = renewal.intm_no)
				    LOOP
                        v_pk_column_value := a.intm_no;
                        v_recipient_name  := a.intm_name;
                        v_cellphone_no := '+639' || SUBSTR(a.cp_no, LENGTH(a.cp_no)-8, LENGTH(a.cp_no));
				    END LOOP;
                    
                    INSERT INTO GISM_MESSAGES_SENT_DTL
                           (msg_id, group_cd, pk_column_value, recipient_name, cellphone_no, status_sw, last_update)
                    VALUES (v_msg_id, v_group_intm, v_pk_column_value, v_recipient_name, v_cellphone_no, 'Q', SYSDATE);
                    
                    FOR a IN(SELECT MAX(dtl_id) dtl_id
						       FROM GISM_MESSAGES_SENT_DTL
						      WHERE msg_id = v_msg_id)
				    LOOP
                        v_dtl_id:=a.dtl_id;
				    END LOOP;
                    
                    INSERT INTO GIEX_SMS_DTL
                           (policy_id, message, date_created, cellphone_no, message_type, msg_id, dtl_id, user_id, last_update)
				    VALUES (renewal.policy_id, v_message, SYSDATE, v_cellphone_no, 'N', v_msg_id, v_dtl_id, p_user_id, SYSDATE);
                END IF;
                
                IF renewal.assd_sms = 'Y' THEN
                    v_dtl_id := 1;				
                    v_pk_column_value := NULL;
                    v_recipient_name := NULL;
                    v_cellphone_no := NULL;
                    
                    FOR a IN(SELECT assd_no, assd_name, cp_no
					           FROM GIIS_ASSURED
						      WHERE assd_no = renewal.assd_no)
				    LOOP
                        v_pk_column_value := a.assd_no;
					    v_recipient_name  := a.assd_name;
					    v_cellphone_no := '+639' || SUBSTR(a.cp_no,LENGTH(a.cp_no)-8,LENGTH(a.cp_no));
				    END LOOP;
                    
                    INSERT INTO GISM_MESSAGES_SENT_DTL
                           (msg_id, group_cd, pk_column_value, recipient_name, cellphone_no, status_sw, last_update)
                    VALUES (v_msg_id, v_group_assd, v_pk_column_value, v_recipient_name, v_cellphone_no, 'Q', SYSDATE);
                    
                    FOR a IN(SELECT MAX(dtl_id) dtl_id
						       FROM GISM_MESSAGES_SENT_DTL
						      WHERE msg_id = v_msg_id)
				    LOOP
                        v_dtl_id:=a.dtl_id;
				    END LOOP;
                    
                    INSERT INTO GIEX_SMS_DTL
                           (policy_id, message, date_created, cellphone_no, message_type, msg_id, dtl_id, user_id, last_update)
                    VALUES (renewal.policy_id, v_message, SYSDATE, v_cellphone_no, 'N', v_msg_id, v_dtl_id, p_user_id, SYSDATE);
                END IF;
                
                UPDATE GIEX_EXPIRY
			       SET assd_sms = 'N',
			           intm_sms = 'N'
			     WHERE policy_id = renewal.policy_id;
            END IF;
        END LOOP;
    END;
    
   /*
   ** Created by    : Marco Paolo Rebong
   ** Referenced by : (GISMS007 - SMS Renewal)
   ** Created date  : February 14, 2013
   ** Description   : save sms renewal details
   */
    PROCEDURE save_sms_renewal(
        p_policy_id             GIEX_EXPIRY.policy_id%TYPE,
        p_renew_flag            GIEX_EXPIRY.renew_flag%TYPE,
        p_remarks               GIEX_EXPIRY.remarks%TYPE
    )
    IS
    BEGIN
        UPDATE GIEX_EXPIRY
           SET renew_flag = p_renew_flag,
               remarks = p_remarks
         WHERE policy_id = p_policy_id;
    END;

END GIEX_SMS_DTL_PKG;
/


