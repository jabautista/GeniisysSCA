DROP FUNCTION CPI.VALIDATE_OR_FOR_PRINTING;

CREATE OR REPLACE FUNCTION CPI.VALIDATE_OR_FOR_PRINTING(
    p_gacc_tran_id  GIAC_OP_TEXT.gacc_tran_id%TYPE,
    p_branch_cd     GIAC_OR_PREF.branch_cd%TYPE,
    p_fund_cd       GIAC_OR_PREF.fund_cd%TYPE,
    p_user_id       GIIS_USERS.user_id%TYPE,
    p_or_pref       giac_doc_sequence.doc_pref_suf%TYPE,
    p_or_no         giac_doc_sequence.doc_seq_no%TYPE,
    p_print_type    VARCHAR2     --  V, N or MIS
--    p_result        OUT VARCHAR2
) RETURN VARCHAR2 IS
  CURSOR giop IS
    SELECT or_pref_suf, or_no
      FROM giac_order_of_payts
     WHERE or_no = p_or_no
       AND NVL(or_pref_suf,'-') = NVL(p_or_pref, NVL(or_pref_suf,'-'))
       AND NVL(gibr_branch_cd,gibr_branch_cd) = p_branch_cd
       AND gibr_gfun_fund_cd = p_fund_cd;

  CURSOR giso IS
    SELECT '1'
      FROM giac_spoiled_or
     WHERE or_no = p_or_no
       AND NVL(or_pref,'-') = NVL(p_or_pref, NVL(or_pref,'-'))
     and fund_cd = p_fund_cd
     and branch_cd = p_branch_cd;
     
    v_or_pref giac_doc_sequence.doc_pref_suf%TYPE;
    v_or_no   giac_doc_sequence.doc_seq_no%TYPE;
    v_exists  VARCHAR2(1);
    v_parm       giac_parameters.param_value_v%TYPE;
    v_user_cd    giac_dcb_users.cashier_cd%TYPE;
    v_min		 		 giac_doc_sequence_user.min_seq_no%TYPE;
    v_max		 		 giac_doc_sequence_user.max_seq_no%TYPE;  
    v_flag       varchar2(1);
    v_rv_meaning	VARCHAR2(15);
    v_result     VARCHAR2(50);
BEGIN
    v_result := 'Y';
    OPEN giop;
    FETCH giop INTO v_or_pref, v_or_no;
    IF giop%FOUND THEN
        --Msg_Alert('This O.R. Number already exists.', 'E', TRUE);
        v_result := 'This O.R. Number already exists.';
    ELSE
        BEGIN
            IF p_print_type = 'V' THEN
					v_rv_meaning := 'VAT';
				ELSIF p_print_type = 'N' THEN
					v_rv_meaning := 'NON VAT';
				ELSE  
					v_rv_meaning := 'MISCELLANEOUS';
				END IF;

            FOR p IN (SELECT or_pref_suf
                     FROM giac_or_pref
                    WHERE branch_cd = p_branch_cd
                      AND or_type IN (SELECT rv_low_value
                                        FROM cg_ref_codes
                                       WHERE rv_domain = 'GIAC_OR_PREF.OR_TYPE'
                                         AND upper(rv_meaning) = v_rv_meaning)
                   )
             LOOP
               v_or_pref := p.or_pref_suf;
               EXIT;
             END LOOP;
             BEGIN 
                 SELECT cashier_cd
                   INTO v_user_cd
                   FROM giac_dcb_users
                  WHERE gibr_branch_cd = p_branch_cd
                    AND dcb_user_id = nvl(p_user_id, USER);
             EXCEPTION
                 WHEN NO_DATA_FOUND then
                   v_user_cd := NULL;
                   v_result := 'You are not allowed to access this module.';
        END;
        
        BEGIN
          SELECT param_value_v
            INTO v_parm
            FROM giac_parameters
            WHERE param_name = 'OR_SEQ_PER_USER';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_parm := 'N';
        END;
        
        IF v_parm = 'Y' THEN
            BEGIN
                SELECT min_seq_no, max_seq_no
                INTO v_min, v_max
                 FROM giac_doc_sequence_user
                 WHERE doc_code = 'OR'
                 AND branch_cd = p_branch_cd
                 AND user_cd = v_user_cd
                 AND doc_pref = v_or_pref
                 AND active_tag = 'Y';
                              		    
                   v_flag := 'Y';
                          		     
            EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                   v_min := 1;
                   v_max := 1;
                   v_flag := 'N';
                  -- msg_alert('No range of O.R. Number found','E',TRUE);
                   v_result := 'No range of O.R. Number found';
        END;
        ELSE
            NULL;
        END IF;
        
        IF P_or_no > v_max and v_flag = 'Y' THEN
        	--    msg_alert('O.R. Number exceeds maximum sequence number for the booklet.','E',TRUE);  	
            v_result := 'O.R. Number exceeds maximum sequence number for the booklet.';	    
            ELSE
  		        OPEN giso;
    		        FETCH giso INTO v_exists;
      	          IF giso%FOUND THEN
        	  --        msg_alert('This O.R. Number has been spoiled.', 'E', TRUE);
                    v_result := 'This O.R. Number has been spoiled.';
      	          END IF;
          	CLOSE giso;
          END IF;    
     END;	    
    END IF;
    CLOSE giop;    
    
    RETURN v_result;
END VALIDATE_OR_FOR_PRINTING;
/


