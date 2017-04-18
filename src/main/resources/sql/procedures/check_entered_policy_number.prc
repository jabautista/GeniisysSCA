DROP PROCEDURE CPI.CHECK_ENTERED_POLICY_NUMBER;

CREATE OR REPLACE PROCEDURE CPI.Check_Entered_Policy_Number (
	p_line_cd		IN GIPI_WPOLBAS.line_cd%TYPE,
	p_subline_cd	IN GIPI_WPOLBAS.subline_cd%TYPE,
	p_iss_cd		IN GIPI_WPOLBAS.iss_cd%TYPE,
	p_issue_yy		IN GIPI_WPOLBAS.issue_yy%TYPE,
	p_pol_seq_no	IN GIPI_WPOLBAS.pol_seq_no%TYPE,
	p_renew_no		IN GIPI_WPOLBAS.renew_no%TYPE,
	p_msg_alert		OUT VARCHAR2)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 06.24.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: This procedure is used for checking if the policy_no entered is existing
	*/
	
	/* Search the gipi_polbasic to determine if the */
	/* policy number entered exist in gipi_polbasic */        
	CURSOR A IS
		SELECT pack_pol_flag
		  FROM GIPI_POLBASIC
		 WHERE line_cd = p_line_cd
		   AND subline_cd = p_subline_cd
		   AND iss_cd = p_iss_cd
		   AND issue_yy = p_issue_yy
		   AND pol_seq_no = p_pol_seq_no
		   AND renew_no = p_renew_no
		   AND dist_flag NOT IN ('5','X');
		   
	/* Search the gipi_wpolbas table to see if another */
	/* par is endorsing the entered policy number      */
	CURSOR B IS
		SELECT user_id
		  FROM GIPI_WPOLBAS a, GIPI_PARLIST b
		 WHERE a.line_cd = p_line_cd
		   AND a.subline_cd = p_subline_cd
		   AND a.iss_cd = p_iss_cd
		   AND a.issue_yy = p_issue_yy
		   AND a.pol_seq_no = p_pol_seq_no
		   AND a.renew_no = p_renew_no
		   AND a.par_id = b.par_id
		   AND b.par_status NOT IN ('98','99');
		   
	/* Search the gipi_wpolbas table to see if another */
	/* par is endorsing the entered policy number      */
	CURSOR C IS
		SELECT pol_flag
		  FROM GIPI_POLBASIC
		 WHERE line_cd = p_line_cd
		   AND subline_cd = p_subline_cd
		   AND iss_cd = p_iss_cd
		   AND issue_yy = p_issue_yy
		   AND pol_seq_no = p_pol_seq_no
		   AND renew_no = p_renew_no;
		   
	v_userid	VARCHAR(8);
	v_rownum	NUMBER;
	v_exist1	VARCHAR2(3);
	v_exist2	NUMBER;
	v_exist3	GIPI_POLBASIC.pol_flag%TYPE;
    v_chk_pack  GIPI_POLBASIC.pack_policy_id%TYPE;
    v_pol_no    VARCHAR2(100);
BEGIN
	OPEN A;
	FETCH A INTO v_exist1;
		IF A%FOUND THEN
			p_msg_alert := NULL;
		ELSE
			p_msg_alert := 'Policy specified does not exist. Cannot endorse a non-existing policy.';
		END IF;		
	CLOSE A;
	
	IF p_msg_alert IS NOT NULL THEN				
		GOTO RAISE_FORM_TRIGGER_FAILURE;
	END IF;	
	
	OPEN B;
	FETCH B INTO v_userid;
		IF B%FOUND THEN
			IF v_userid IS NOT NULL THEN
				p_msg_alert := 'Policy is currently being endorsed by ' || v_userid || ', cannot endorse the same policy '||
				   'at the same time.';
			ELSE
				p_msg_alert := 'Policy is currently being endorsed, cannot endorse the same policy at the same time.';
			END IF;
			
			IF p_msg_alert IS NOT NULL THEN
				GOTO RAISE_FORM_TRIGGER_FAILURE;
			END IF;
		ELSE
			p_msg_alert := NULL;
		END IF;
	CLOSE B;	
    --added by d.alcantara, 10.09.2012, validation for subpolicy of package
    FOR i IN (
        SELECT pack_policy_id
		  FROM GIPI_POLBASIC
		 WHERE line_cd = p_line_cd
		   AND subline_cd = p_subline_cd
		   AND iss_cd = p_iss_cd
		   AND issue_yy = p_issue_yy
		   AND pol_seq_no = p_pol_seq_no
		   AND renew_no = p_renew_no
    ) LOOP
        v_chk_pack := i.pack_policy_id;
        EXIT;
    END LOOP;
    
    IF v_chk_pack IS NOT NULL THEN
        FOR i IN (
            SELECT line_cd||' - '||subline_cd||' - '||iss_cd||' - '||
                   TO_CHAR(issue_yy, '09')||' - '||TO_CHAR(pol_seq_no, '0000009')||
                   ' - '||TO_CHAR(renew_no, '09') policy_no
              FROM gipi_pack_polbasic
             WHERE pack_policy_id = v_chk_pack
        ) LOOP
            v_pol_no := i.policy_no;
            EXIT;
        END LOOP;
        p_msg_alert := 'This is a subpolicy of package '||v_pol_no||'. Please use the package endorsement module.';
    END IF;
	-- end pack. subpolicy validation
	OPEN C;
	FETCH C INTO v_exist3;
	CLOSE C;
	
	IF v_exist3 != 'X' AND v_exist3 != 4 THEN
		NULL;
	ELSIF v_exist3 = '4' THEN
		p_msg_alert := 'Policy specified has been cancelled. Cannot endorse a cancelled policy.';		
		GOTO RAISE_FORM_TRIGGER_FAILURE;             
	ELSIF v_exist3 = 'X' THEN
		p_msg_alert := 'Policy specified has been renewed.';
	ELSE		
		p_msg_alert := 'Policy has already expired.';		
	END IF;
	
	<<RAISE_FORM_TRIGGER_FAILURE>>
	NULL;
END Check_Entered_Policy_Number;
/


