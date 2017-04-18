DROP PROCEDURE CPI.GENERATE_OR_NO;

CREATE OR REPLACE PROCEDURE CPI.generate_or_no (
    p_branch_cd     IN GIAC_OR_PREF.branch_cd%TYPE,
    p_fund_cd       IN GIAC_OR_PREF.fund_cd%TYPE,
    p_or_pref       IN giac_doc_sequence.doc_pref_suf%TYPE,
    p_user          IN GIIS_USERS.user_id%TYPE,
    p_or_type       IN VARCHAR2,
    p_or_no         OUT NUMBER,
    p_mesg          OUT VARCHAR2
) IS
    v_parm       GIAC_PARAMETERS.param_value_v%TYPE;
    v_min         giac_doc_sequence_user.min_seq_no%TYPE;
    v_max         giac_doc_sequence_user.max_seq_no%TYPE;
    v_cashier_cd   GIAC_DCB_USERS.cashier_cd%TYPE;
    v_doc_name   VARCHAR2(20);
    v_flag       char(1);
    cursor chk_spoil (v_spoil number) is
        SELECT or_no
             FROM giac_spoiled_or
            WHERE or_no >= v_spoil
             AND NVL(or_pref,'-') = NVL(p_or_pref, NVL(or_pref,'-'))
            AND fund_cd = p_fund_cd                 
            AND branch_cd = p_branch_cd
            ORDER BY or_no;
BEGIN
    BEGIN 
       SELECT cashier_cd
           INTO v_cashier_cd
           FROM giac_dcb_users
          WHERE gibr_branch_cd = p_branch_cd
         AND dcb_user_id = p_user;
     EXCEPTION
         WHEN NO_DATA_FOUND then
           v_cashier_cd := NULL;  
     END;
    
    IF UPPER(p_or_type) = 'V' THEN
        v_doc_name := 'VAT OR';
    ELSIF UPPER(p_or_type) = 'N' THEN
        v_doc_name := 'NON VAT OR';
    ELSE 
        v_doc_name := 'MISC_OR';
    END IF;
    
    BEGIN
       SELECT param_value_v
         INTO v_parm
         FROM giac_parameters
        WHERE param_name = 'OR_SEQ_PER_USER';
    EXCEPTION
         WHEN NO_DATA_FOUND THEN
           v_parm := 'N';
     END;
    p_mesg := 'Y';
    v_min := 1;
    v_max := 1;
    IF v_parm = 'Y' THEN
    
       BEGIN
           SELECT min_seq_no, max_seq_no
             INTO v_min, v_max
             FROM giac_doc_sequence_user
            WHERE doc_code = 'OR'
              AND branch_cd = p_branch_cd
                AND user_cd = v_cashier_cd
                AND doc_pref = p_or_pref
                AND active_tag = 'Y';
                
            v_flag := 'Y';
           
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
           v_min := 1;
           v_max := 1;
           v_flag := 'N';
         END;
  
       --   //  GET OR NUMBER
       BEGIN
           SELECT nvl(max(or_no)+1,v_min)
             INTO p_or_no
             FROM giac_order_of_payts
            WHERE gibr_gfun_fund_cd = p_fund_cd
              AND gibr_branch_cd = p_branch_cd
                AND NVL(or_pref_suf, '-') = NVL(p_or_pref, NVL(or_pref_suf,'-'))
                AND or_no between v_min and v_max;
                         
           IF p_or_no > v_max and v_flag = 'Y' THEN
                p_mesg := 'O.R. Number exceeds maximum sequence number for the booklet.'; 
           END IF;

        EXCEPTION
           WHEN NO_DATA_FOUND THEN
             p_or_no := v_min;
       END;
       --   /   /   /
    ELSE 
        BEGIN
           SELECT doc_seq_no
             INTO p_or_no
             FROM giac_doc_sequence
            WHERE fund_cd = p_fund_cd
                AND branch_cd = p_branch_cd
                AND NVL(doc_pref_suf, '-') = NVL(p_or_pref, NVL(doc_pref_suf,'-'))
                AND doc_name = v_doc_name;
         
           p_or_no := p_or_no + 1;
           
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
             p_or_no := 1;
        END;
            
        FOR i IN chk_spoil (p_or_no) LOOP
             IF i.or_no = p_or_no THEN
              p_or_no := p_or_no + 1;
             END IF;
        END LOOP;     
    END IF;
END;
/


