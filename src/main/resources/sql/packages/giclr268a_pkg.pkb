CREATE OR REPLACE PACKAGE BODY CPI.GICLR268A_PKG
    /*
    **  Created by        : Steven Ramirez
    **  Date Created      : 03.12.2013
    **  Reference By      : GICLR268A - RECOVERY LISTING PER PLATE NO 
    */
AS
	FUNCTION get_giclr268A_details(
	 	p_plate_no			gicl_motor_car_dtl.plate_no%TYPE,
        p_from_date         VARCHAR2,
        p_to_date           VARCHAR2,
		p_as_of_date        VARCHAR2,
	 	p_from_ldate        VARCHAR2,
        p_to_ldate          VARCHAR2,
		p_as_of_ldate       VARCHAR2,
		p_user_id			GIIS_USERS.user_id%TYPE
    ) RETURN giclr268A_tab PIPELINED AS
        rep         giclr268A_type;
    BEGIN
        FOR i IN (SELECT  b.plate_no, 
						   a.claim_id,
						   a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||SUBSTR(TO_CHAR(a.clm_yy,'09'),2,2)||'-'||SUBSTR(TO_CHAR(a.clm_seq_no,'0000009'),2,7) claim_no,                                             
						   a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||SUBSTR(TO_CHAR(a.issue_yy,'09'),2,2)||'-'||SUBSTR(TO_CHAR(a.pol_seq_no,'0000009'),2,7)||'-'||SUBSTR(TO_CHAR(a.renew_no,'09'),2,2) policy_no,
						   a.assured_name,
						   a.loss_date,
						   c.line_cd||'-'||c.iss_cd||'-'||c.rec_year||'-'||SUBSTR(TO_CHAR(c.rec_seq_no,'009'),2,3) recovery_no,
						   i.rec_type_desc recovery_type,
						   f.rec_stat_desc recovery_status,
						   NVL(c.recoverable_amt,0) recoverable_amt,
						   NVL(c.recovered_amt,0) recovered_amt,               
						   h.payee_last_name||' '||h.payee_first_name||' '||h.payee_middle_name payor,
						   NVL(d.recovered_amt,0) recovered_payor,
						   a.clm_file_date
					FROM gicl_claims a, 
						 gicl_motor_car_dtl b, 
						 gicl_clm_recovery c, 
						 gicl_recovery_payor d, 
						 giis_recovery_status f, 
						 gicl_rec_hist g, 
						 giis_payees h, 
						 giis_recovery_type i/*,
						 gicl_clm_recovery_dtl j--added by VJ -092305*/
					 WHERE a.claim_id = b.claim_id
						AND a.claim_id = c.claim_id
						AND c.claim_id = d.claim_id
						AND c.recovery_id = d.recovery_id
						AND c.recovery_id = g.recovery_id 
						AND d.payor_class_cd = h.payee_class_cd
						AND d.payor_cd = h.payee_no
						AND f.rec_stat_cd = g.rec_stat_cd
						AND i.rec_type_cd = c.rec_type_cd 
						AND CHECK_USER_PER_LINE2(a.line_cd,a.iss_cd,'GICLS268',p_user_id)=1
					--       AND d.claim_id = j.claim_id--added by VJ -092305 
					--       AND c.recovered_amt = d.recovered_amt
						AND a.plate_no LIKE NVL(p_plate_no,a.plate_no)
						AND ((TRUNC(a.clm_file_date) >= TO_DATE(p_from_date,'mm/dd/yyyy')
						AND TRUNC(a.clm_file_date) <= TO_DATE(p_to_date,'mm/dd/yyyy')
							OR TRUNC(a.clm_file_date) <= TO_DATE(p_as_of_date,'mm/dd/yyyy'))
							OR (TRUNC(a.loss_date) >= TO_DATE(p_from_ldate,'mm/dd/yyyy')
						AND TRUNC(a.loss_date) <= TO_DATE(p_to_ldate,'mm/dd/yyyy')
							OR TRUNC(a.dsp_loss_date) <= TO_DATE(p_as_of_ldate,'mm/dd/yyyy')))
						ORDER BY b.plate_no,claim_no,policy_no,a.assured_name,a.loss_date,recovery_no,recovery_type,recovery_status,recoverable_amt,recovered_amt,payor,recovered_payor,clm_file_date)
        LOOP
        
			rep.plate_no			:= i.plate_no;
			rep.claim_id            := i.claim_id;
			rep.claim_no			:= i.claim_no;
			rep.policy_no			:= i.policy_no;
			rep.assured_name		:= i.assured_name;
			rep.loss_date			:= i.loss_date;
			rep.recovery_no			:= i.recovery_no;
			rep.recovery_type		:= i.recovery_type;
			rep.recovery_status		:= i.recovery_status;
			rep.recoverable_amt		:= i.recoverable_amt;
			rep.recovered_amt		:= i.recovered_amt;
			rep.payor				:= i.payor;
			rep.recovered_payor		:= i.recovered_payor;
			rep.clm_file_date		:= i.clm_file_date;
			rep.report_title		:= 'RECOVERY LISTING PER PLATE NO.';
		
			BEGIN
			  SELECT PARAM_VALUE_V
			  	INTO rep.company_name
			  FROM GIIS_PARAMETERS
			  	WHERE PARAM_NAME = 'COMPANY_NAME';
			  EXCEPTION
				  WHEN NO_DATA_FOUND THEN
					rep.company_name := '(NO EXISTING COMPANY_NAME IN GIIS_PARAMETERS)';
				  WHEN TOO_MANY_ROWS THEN
					rep.company_name := '(TOO MANY VALUES FOR COMPANY_NAME IN GIIS_PARAMETER)';
			END;
     
			BEGIN
			  SELECT PARAM_VALUE_V
			  	INTO rep.company_address
			  FROM GIIS_PARAMETERS
			  	WHERE PARAM_NAME = 'COMPANY_ADDRESS';
			  EXCEPTION
				  WHEN NO_DATA_FOUND THEN
					rep.company_address := '(NO EXISTING COMPANY_ADDRESS IN GIIS_PARAMETERS)';
				  WHEN TOO_MANY_ROWS THEN
					rep.company_address := '(TOO MANY VALUES FOR COMPANY_ADDRESS IN GIIS_PARAMETERS)';
			END; 
            
			IF p_as_of_date IS NOT NULL THEN
				 rep.date_type :='Claim File Date As of '||TO_CHAR(TO_DATE(p_as_of_date, 'mm/dd/yyyy'),'fmMonth DD, RRRR');
			ELSIF p_from_date IS NOT NULL AND p_to_date IS NOT NULL THEN
				 rep.date_type := 'Claim File Date From '||TO_CHAR(TO_DATE(p_from_date, 'mm/dd/yyyy'),'fmMonth DD, RRRR')||' to '||TO_CHAR(TO_DATE(p_to_date, 'mm/dd/yyyy'),'fmMonth DD, RRRR');
			ELSIF p_as_of_ldate IS NOT NULL THEN	
				rep.date_type :='Loss Date As of '||TO_CHAR(TO_DATE(p_as_of_ldate, 'mm/dd/yyyy'),'fmMonth DD, RRRR');
			ELSIF p_from_ldate IS NOT NULL AND p_to_ldate IS NOT NULL THEN
				rep.date_type :=' Loss Date From '||TO_CHAR(TO_DATE(p_from_ldate, 'mm/dd/yyyy'),'fmMonth DD, RRRR')||' to '||TO_CHAR(TO_DATE(p_to_ldate, 'mm/dd/yyyy'),'fmMonth DD, RRRR');
			END IF;
                        
            PIPE ROW(rep);
        END LOOP;
    
    END;
	
END;
/


