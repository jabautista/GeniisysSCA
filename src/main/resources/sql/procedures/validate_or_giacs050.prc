DROP PROCEDURE CPI.VALIDATE_OR_GIACS050;

CREATE OR REPLACE PROCEDURE CPI.VALIDATE_OR_GIACS050(
        p_gacc_tran_id  IN  GIAC_ORDER_OF_PAYTS.gacc_tran_id%TYPE,
        p_or_pref       IN  giac_doc_sequence.doc_pref_suf%TYPE,
        p_or_no         IN  OUT giac_doc_sequence.doc_seq_no%TYPE,
        p_branch_cd     IN  giac_order_of_payts.gibr_branch_cd%TYPE,
        p_fund_cd       IN  giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
        p_edit_or_no    IN  VARCHAR2,
        p_or_type       IN  VARCHAR2/*,  -- > :a940.print_type
        p_user_id       IN  VARCHAR2,
        p_mesg            OUT VARCHAR2*/) IS
    
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

    v_or_pref      giac_doc_sequence.doc_pref_suf%TYPE;
    v_or_no        giac_doc_sequence.doc_seq_no%TYPE;

    v_exists       VARCHAR2(1);
    v_parm       giac_parameters.param_value_v%TYPE;
    v_user_cd    giac_dcb_users.cashier_cd%TYPE;
    v_min        giac_doc_sequence_user.min_seq_no%TYPE;
    v_max        giac_doc_sequence_user.max_seq_no%TYPE;  
    v_flag       varchar2(1);
    v_rv_meaning    VARCHAR2(15);
BEGIN
    OPEN giop;
    FETCH giop INTO v_or_pref, v_or_no;
    --[SAMPLE ]raise_application_error (-21001, 'Geniisys Exception#I#Cannot Proceed to Approval of CSR. ' || v_msg);
    IF p_edit_or_no = 'N' THEN 
      --update_giop;
        --p_or_pref := v_or_pref;
        p_or_no := v_or_no;
        --UPDATE_GIOP_GIACS050 (v_or_no, v_or_pref, p_edit_or_no, p_gacc_tran_id, p_fund_cd, p_branch_cd);
    ELSE
        IF giop%FOUND THEN
            --p_mesg := 'O.R. Number '||p_or_pref||'-'||p_or_no||' already exists.';
            raise_application_error (-20002, 'Geniisys Exception#I#O.R. Number '||p_or_pref||'-'||p_or_no||' already exists.');
        END IF;
    END IF;
    
    IF giop%NOTFOUND OR p_edit_or_no = 'N' THEN
        BEGIN     
          IF p_or_type = 'V' THEN
              v_rv_meaning := 'VAT';
            ELSIF p_or_type = 'N' THEN
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
                  AND dcb_user_id = nvl(giis_users_pkg.app_user, USER);
           EXCEPTION
               WHEN NO_DATA_FOUND then
                    v_user_cd := NULL;
                    --p_mesg := 'You are not allowed to access this module';      
                    raise_application_error (-20001, 'Geniisys Exception#I#You are not allowed to access this module.');
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
                        --p_mesg := 'No range of O.R. Number found';
                        raise_application_error (-20001, 'Geniisys Exception#I#No range of O.R. Number found');
               END;
           ELSE
               NULL;
                    
        END IF;
              
              ----
        IF p_or_no > v_max and v_flag = 'Y' THEN
            --p_mesg := 'O.R. Number exceeds maximum sequence number for the booklet.'; 
            raise_application_error (-20001, 'Geniisys Exception#I#O.R. Number exceeds maximum sequence number for the booklet.');            
        ELSE
             OPEN giso;
             FETCH giso INTO v_exists;
                 IF giso%FOUND THEN
                     --msg_alert('This O.R. Number has been spoiled.', 'E', TRUE);
                     raise_application_error (-20002, 'Geniisys Exception#I#This O.R. Number has been spoiled.');  
                        
                 END IF;
             CLOSE giso;
        END IF;
        --        END IF;
      END;        
  END IF;
  CLOSE giop;
END VALIDATE_OR_GIACS050;
/


