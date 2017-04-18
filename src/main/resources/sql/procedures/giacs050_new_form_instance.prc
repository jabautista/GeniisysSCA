DROP PROCEDURE CPI.GIACS050_NEW_FORM_INSTANCE;

CREATE OR REPLACE PROCEDURE CPI.GIACS050_NEW_FORM_INSTANCE(
    p_gacc_tran_id  IN GIAC_OP_TEXT.gacc_tran_id%TYPE,
    p_branch_cd     IN GIAC_OR_PREF.branch_cd%TYPE,
    p_fund_cd       IN GIAC_OR_PREF.fund_cd%TYPE,
    p_user          IN GIIS_USERS.user_id%TYPE,
    p_or_type       IN VARCHAR2,
    p_print_tag     OUT VARCHAR2,
    p_edit_or_no    OUT VARCHAR2,
    p_or_pref       OUT VARCHAR2,
    p_cashier_cd    OUT GIAC_DCB_USERS.cashier_cd%TYPE,
    p_or_no         OUT NUMBER,
    p_or_seq        OUT GIAC_DOC_SEQUENCE.doc_seq_no%TYPE,
    p_mesg          OUT VARCHAR2,
    p_dsp_or_types  OUT VARCHAR2,
    p_vat_nonvat_series  OUT VARCHAR2,
    p_issue_nonvat_oar   OUT VARCHAR2,
    p_prem_inc_related   OUT VARCHAR2,
	p_enable_print  OUT VARCHAR2  --added based on AC-SPECS-2012-28
     
) AS
    v_or_type    VARCHAR2(15);
    v_parm       GIAC_PARAMETERS.param_value_v%TYPE;
    v_min         giac_doc_sequence_user.min_seq_no%TYPE;
    v_max         giac_doc_sequence_user.max_seq_no%TYPE;
    v_flag       char(1);
    v_doc_name   VARCHAR2(20);
    v_tran_id    giac_or_rel.tran_id%TYPE; --Added by Jerome Bautista 11.26.2015 SR 20817
    
    cursor chk_spoil (v_spoil number) is
        SELECT or_no
             FROM giac_spoiled_or
            WHERE or_no >= v_spoil
             AND NVL(or_pref,'-') = NVL(p_or_pref, NVL(or_pref,'-'))
            AND fund_cd = p_fund_cd                 
            AND branch_cd = p_branch_cd
            ORDER BY or_no;
    
	v_or_pref_suf   GIAC_ORDER_OF_PAYTS.or_pref_suf%TYPE;
    v_or_no         GIAC_ORDER_OF_PAYTS.or_no%TYPE;  
	
BEGIN
    
    -- added by belle 11.17.2011 to display or types and default values 
    p_dsp_or_types       := giacp.v('DISPLAY_OR_TYPES');
    p_vat_nonvat_series  := NVL(giacp.v('VAT_NONVAT_SERIES'),'V');
    p_issue_nonvat_oar   := NVL(giacp.v('ISSUE_NONVAT_OAR'),'N');
    p_prem_inc_related   := 'N';
    
    BEGIN
        -- function created by Jayson 09.16.2011 --
      FOR rec1 IN (SELECT 1
                     FROM giac_direct_prem_collns
                    WHERE gacc_tran_id = p_gacc_tran_id)
      LOOP
        p_prem_inc_related := 'Y';
      END LOOP;
      
      FOR rec1 IN (SELECT 1
                     FROM giac_inwfacul_prem_collns
                    WHERE gacc_tran_id = p_gacc_tran_id)
      LOOP
        p_prem_inc_related := 'Y';
      END LOOP;
      
      FOR rec1 IN (SELECT 1
                     FROM giac_acct_entries
                    WHERE gacc_tran_id = p_gacc_tran_id
                    AND gl_acct_id   = giacp.n('OUTPUT_VAT_DIRECT_GL'))
      LOOP
        p_prem_inc_related := 'Y';
      END LOOP;
	  
	  --added by robert 03.20.2014
	  FOR rec1 IN (SELECT 1
                     FROM giac_acct_entries
                    WHERE gacc_tran_id = p_gacc_tran_id
                    AND gl_acct_id   = giacp.n('OUTPUT_VAT_RI_GL'))
      LOOP
        p_prem_inc_related := 'Y';
      END LOOP;
      --end of codes robert 
    END;
    -- belle 11.17.2011 end
    
    p_print_tag := 'Y';
    
    --  //  GET EDIT_OR_NO
    p_edit_or_no := 'N';
    FOR a IN (SELECT param_value_v
                FROM giac_parameters
              WHERE param_name = 'EDIT_OR_NO')
    LOOP
        p_edit_or_no := a.param_value_v;
    END LOOP;
    --  /   /   /
    
    -- // GET OR_PREF
    IF UPPER(p_or_type) = 'V' THEN
        v_or_type := 'VAT';
        v_doc_name := 'VAT OR';
    ELSIF UPPER(p_or_type) = 'N' THEN
        v_or_type := 'NON VAT';
        v_doc_name := 'NON VAT OR';
    ELSE 
        v_or_type := 'MISCELLANEOUS';
        v_doc_name := 'MISC_OR';
    END IF;
    
    FOR b IN (SELECT or_pref_suf
              FROM giac_or_pref
              WHERE branch_cd = p_branch_cd
               AND or_type IN (SELECT rv_low_value
                                 FROM cg_ref_codes
                                WHERE rv_domain = 'GIAC_OR_PREF.OR_TYPE'
                                  AND upper(rv_meaning) = v_or_type))
    LOOP
        p_or_pref  := b.or_pref_suf;
    END LOOP;
    --  /   /   /
    
    --  //  GET CASHIER CD
    BEGIN 
       SELECT cashier_cd
           INTO p_cashier_cd
           FROM giac_dcb_users
          WHERE gibr_branch_cd = p_branch_cd
         AND dcb_user_id = p_user;
     EXCEPTION
         WHEN NO_DATA_FOUND then
           p_cashier_cd := NULL;  
     END;
    --  /   /   /
    
    BEGIN
       SELECT param_value_v
         INTO v_parm
         FROM giac_parameters
        WHERE param_name = 'OR_SEQ_PER_USER';
    EXCEPTION
         WHEN NO_DATA_FOUND THEN
           v_parm := 'N';
     END;
    
    v_min := 1;
    v_max := 1;
    IF v_parm = 'Y' THEN
    
       BEGIN
           SELECT min_seq_no, max_seq_no
             INTO v_min, v_max
             FROM giac_doc_sequence_user
            WHERE doc_code = 'OR'
              AND branch_cd = p_branch_cd
                AND user_cd = p_cashier_cd
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
                p_mesg := 'EXCEEDS'; --'O.R. Number exceeds maximum sequence number for the booklet.';
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
         
          -- p_or_pref := v_or_pref;
           p_or_no := p_or_no + 1;
           
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
             p_or_pref := p_or_pref;
             p_or_no := 1;
        END;
            
        FOR i IN chk_spoil (p_or_no) LOOP
             IF i.or_no = p_or_no THEN
              p_or_no := p_or_no + 1;
             END IF;
        END LOOP;     
    END IF;
    p_mesg := v_parm;
	
	BEGIN
        p_enable_print := 'Y';
        SELECT or_pref_suf, or_no
          INTO v_or_pref_suf, v_or_no
          FROM giac_order_of_payts
         WHERE gacc_tran_id = p_gacc_tran_id;
         
        IF v_or_pref_suf IS NOT NULL and v_or_no IS NOT NULL THEN
            p_enable_print := 'N';
        END IF;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;        
    END;
    
    BEGIN --Added by Jerome Bautista 11.26.2015 SR 20817
      FOR a IN (SELECT tran_id
                  FROM giac_or_rel
                 WHERE tran_id = p_gacc_tran_id)
      LOOP
         v_tran_id := a.tran_id;
      END LOOP;
      
      IF v_tran_id <> NULL THEN
         UPDATE giac_or_rel
            SET new_or_pref_suf     = p_or_pref,
                new_or_no           = p_or_no
          WHERE tran_id = v_tran_id;
      END IF;
    END;
END GIACS050_NEW_FORM_INSTANCE;
/


