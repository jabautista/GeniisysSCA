CREATE OR REPLACE PACKAGE BODY CPI.GIACS078_PKG
AS

    /** Created By:     Shan Bati
     ** Date Created:   06.26.2013
     ** Referenced By:  GIACS078 - Collection Analysis
     **/
     
    PROCEDURE get_initial_values(
        p_user          IN  giac_coll_analysis_ext.USER_ID%type,
        p_from_date     OUT VARCHAR2,
        p_to_date       OUT VARCHAR2,
        p_branch_cd     OUT VARCHAR2,
        p_branch_name   OUT VARCHAR2,
        p_intm_no       OUT NUMBER,
        p_intm_name     OUT VARCHAR2
    )
    AS
    BEGIN
        SELECT DISTINCT TO_CHAR(date_from, 'MM-DD-RRRR'), TO_CHAR(date_to, 'MM-DD-RRRR')z, param_iss_cd, param_intm_no
          INTO p_from_date, p_to_date, p_branch_cd, p_intm_no
          FROM giac_coll_analysis_ext
         WHERE user_id = p_user;
         
        FOR i IN (SELECT branch_name
                    FROM GIAC_BRANCHES
                   WHERE branch_cd = UPPER(p_branch_cd))
        LOOP
            p_branch_name   := i.branch_name;
            EXIT;
        END LOOP;
        
        FOR i IN (SELECT intm_name
                    FROM GIIS_INTERMEDIARY
                   WHERE intm_no = p_intm_no)
        LOOP
            p_intm_name   := i.intm_name;
            EXIT;
        END LOOP;
        
    END get_initial_values;
        
    PROCEDURE extract_records(
        p_from_date     IN  giac_order_of_payts.OR_DATE%type,
        p_to_date       IN  giac_order_of_payts.OR_DATE%type,
        p_branch_cd     IN  giac_order_of_payts.GIBR_BRANCH_CD%type,
        p_intm_no       IN  VARCHAR2,
        p_date_tag      IN  VARCHAR2,
        p_user          IN  giac_coll_analysis_ext.USER_ID%type,
        p_extracted_rec OUT NUMBER
    )
    AS
        v_iss_cd        giac_coll_analysis_ext.iss_cd%TYPE;
        v_prem_seq_no   giac_coll_analysis_ext.prem_seq_no%TYPE;
        v_intm_name     giac_coll_analysis_ext.intm_name%TYPE;
        v_policy_no     giac_coll_analysis_ext.policy_no%TYPE;
        v_policy_id     gipi_invoice.policy_id%TYPE;
        v_effect        giac_coll_analysis_ext.effect_date%TYPE;
        v_age           giac_coll_analysis_ext.age%TYPE;
        v_amount        giac_coll_analysis_ext.amount%TYPE;
        v_direct        BOOLEAN;
        v_row_counter   NUMBER:=0;
        v_tran_id       giac_acctrans.tran_id%TYPE; 
    BEGIN
        DELETE 
          FROM giac_coll_analysis_ext
         WHERE USER_ID = UPPER(P_USER);
         
        p_extracted_rec := 0;
         
        FOR a_rec IN (SELECT a.gibr_branch_cd, or_pref_suf, or_no, payor,
                             a.intm_no,SUM(c.amount) collection_amt, or_date, 
                             c.due_dcb_date, a.gacc_tran_id tran_id, b.posting_date
                        FROM giac_order_of_payts a, 
                             giac_acctrans b ,
                             giac_collection_dtl c
                       WHERE 1=1
                         AND b.tran_id        = a.gacc_tran_id
                         AND a.gacc_tran_id   = c.gacc_tran_id
                         AND b.tran_id        > 0  
                         AND b.tran_flag      <> 'D'    
                         AND a.or_flag        = 'P'
                         AND a.or_no          IS NOT NULL                   
                         --AND a.gibr_branch_cd  = NVL(p_branch_cd,a.gibr_branch_cd) commented and changed by reymon 05142012
                         AND ((p_branch_cd IS NOT NULL AND a.gibr_branch_cd = p_branch_cd)
                             OR (p_branch_cd IS NULL AND check_user_per_iss_cd_acctg2(NULL, a.gibr_branch_cd, 'GIACS078', p_user) = 1))
                         AND NVL(TO_CHAR(a.intm_no), -1)  = NVL(p_intm_no, NVL(a.intm_no, -1)) 
                         AND NOT EXISTS (SELECT x.gacc_tran_id
                                           FROM giac_reversals x,
                                                giac_acctrans y
                                          WHERE x.reversing_tran_id = y.tran_id
                                            AND y.tran_flag        <> 'D'
                                            AND x.gacc_tran_id      =  a.gacc_tran_id) 
                         AND pay_mode <> 'PDC'
                         AND ( ((TRUNC(a.or_date)      BETWEEN TRUNC(p_from_date) AND TRUNC(p_to_date)) AND (p_date_tag = 'OR'))                      
                              OR  ((TRUNC(c.due_dcb_date)  BETWEEN TRUNC(p_from_date) AND TRUNC(p_to_date)) AND (p_date_tag = 'DCB'))                      
                              OR  ((TRUNC(b.posting_date) BETWEEN TRUNC(p_from_date) AND TRUNC(p_to_date)
                              AND TRUNC(c.due_dcb_date)  BETWEEN TRUNC(p_from_date) AND TRUNC(p_to_date)) AND (p_date_tag = 'POSTING')) )
                       GROUP BY a.gibr_branch_cd, or_pref_suf, or_no, payor,
                                a.intm_no, or_date, c.due_dcb_date, 
                                a.gacc_tran_id, b.posting_date
                       UNION
                      SELECT a.gibr_branch_cd, or_pref_suf,  or_no, payor, 
                             a.intm_no, SUM(d.amount) collection_amt, or_date,          
                             c.due_dcb_date, d.gacc_tran_id_new tran_id, b.posting_date
                        FROM giac_order_of_payts a, 
                             giac_acctrans b ,
                             giac_collection_dtl c,
                             giac_pdc_checks d
                       WHERE 1=1
                         AND a.gacc_tran_id    = d.gacc_tran_id
                         AND a.gacc_tran_id    = c.gacc_tran_id 
                         AND c.gacc_tran_id    = d.gacc_tran_id
                         AND b.tran_id         = d.gacc_tran_id_new
                         AND c.bank_cd = d.bank_cd
                         AND c.check_no = d.check_no   
                         AND b.tran_id         > 0  
                         AND b.tran_flag      <> 'D'    
                         AND a.or_flag         = 'P'
                         AND a.or_no          IS NOT NULL                   
                         --AND a.gibr_branch_cd  = NVL(p_branch_cd,a.gibr_branch_cd) commented and changed by reymon 05142012
                         AND ((p_branch_cd IS NOT NULL AND a.gibr_branch_cd = p_branch_cd)
                              OR (p_branch_cd IS NULL AND check_user_per_iss_cd_acctg2(NULL, a.gibr_branch_cd, 'GIACS078', p_user) = 1))
                         AND NVL(TO_CHAR(a.intm_no), -1)  = NVL(p_intm_no, NVL(a.intm_no, -1)) 
                         AND NOT EXISTS (SELECT x.gacc_tran_id
                                           FROM giac_reversals x,
                                                giac_acctrans y
                                          WHERE x.reversing_tran_id = y.tran_id
                                            AND y.tran_flag        <> 'D'
                                            AND x.gacc_tran_id      =  d.gacc_tran_id_new) 
                         AND ( ((TRUNC(a.or_date) BETWEEN TRUNC(p_from_date) AND TRUNC(p_to_date) 
                                  AND TRUNC(c.due_dcb_date) BETWEEN TRUNC(p_from_date) AND TRUNC(p_to_date)) 
                                AND (p_date_tag = 'OR'))                      
                              OR  ((TRUNC(c.due_dcb_date)  BETWEEN TRUNC(p_from_date) AND TRUNC(p_to_date)) AND (p_date_tag = 'DCB'))                      
                              OR  ((TRUNC(b.posting_date) BETWEEN TRUNC(p_from_date) AND TRUNC(p_to_date)) AND (p_date_tag = 'POSTING')) )
                       GROUP BY a.gibr_branch_cd, or_pref_suf, or_no, payor, 
                                a.intm_no, or_date, c.due_dcb_date, 
                                d.gacc_tran_id_new, b.posting_date
                       UNION                         
                      SELECT a.gibr_branch_cd, or_pref_suf, or_no, payor,            
                             a.intm_no, SUM(c.amount) collection_amt, or_date,          
                             c.due_dcb_date, a.gacc_tran_id tran_id, b.posting_date
                        FROM giac_order_of_payts a, 
                             giac_acctrans b ,
                             giac_collection_dtl c
                       WHERE 1=1
                         AND b.tran_id         = a.gacc_tran_id
                         AND a.gacc_tran_id    = c.gacc_tran_id
                         AND b.tran_id         > 0  
                         AND b.tran_flag      <> 'D'    
                         AND a.or_flag         = 'P'
                         AND a.or_no          IS NOT NULL                   
                         --AND a.gibr_branch_cd  = NVL(p_branch_cd,a.gibr_branch_cd) commented and changed by reymon 05142012
                         AND ((p_branch_cd IS NOT NULL AND a.gibr_branch_cd = p_branch_cd)
                               OR (p_branch_cd IS NULL AND check_user_per_iss_cd_acctg2(NULL, a.gibr_branch_cd, 'GIACS078', p_user) = 1))
                         AND NVL(TO_CHAR(a.intm_no), -1)  = NVL(p_intm_no, NVL(a.intm_no, -1)) 
                         AND NOT EXISTS (SELECT x.gacc_tran_id
                                           FROM giac_reversals x,
                                                giac_acctrans y
                                          WHERE x.reversing_tran_id = y.tran_id
                                            AND y.tran_flag        <> 'D'
                         AND x.gacc_tran_id      =  a.gacc_tran_id)
                         AND NOT EXISTS (SELECT z.gacc_tran_id
                                           FROM giac_direct_prem_collns z
                                          WHERE z.gacc_tran_id      =  a.gacc_tran_id) 
                         AND pay_mode <> 'PDC'
                         AND ( ((TRUNC(a.or_date)      BETWEEN TRUNC(p_from_date) AND TRUNC(p_to_date)) AND (p_date_tag = 'OR'))					  
                              OR  ((TRUNC(c.due_dcb_date)  BETWEEN TRUNC(p_from_date) AND TRUNC(p_to_date)) AND (p_date_tag = 'DCB'))					  
                              OR  ((TRUNC(b.posting_date) BETWEEN TRUNC(p_from_date) AND TRUNC(p_to_date)) AND (p_date_tag = 'POSTING')) )
                       GROUP BY a.gibr_branch_cd, or_pref_suf,  or_no, payor, 
                                a.intm_no, or_date, c.due_dcb_date, 
                                a.gacc_tran_id, b.posting_date ) 
        LOOP /*A_REC*/
            v_intm_name := NULL;	
            
            FOR b_rec IN (SELECT intm_name
                            FROM giis_intermediary
                           WHERE intm_no = a_rec.intm_no)
            LOOP /*B_REC*/
                v_intm_name := b_rec.intm_name;
            END LOOP; /*B_REC*/
            
            v_direct := FALSE;
            
            FOR c_rec IN (SELECT b140_iss_cd, b140_prem_seq_no, collection_amt
                            FROM giac_direct_prem_collns b
                           WHERE b.gacc_tran_id = a_rec.tran_id)
            LOOP /*C_REC*/
                v_direct      := TRUE;
                v_amount      := c_rec.collection_amt; 			
                v_iss_cd      := c_rec.b140_iss_cd;
                v_prem_seq_no := c_rec.b140_prem_seq_no;
                
                FOR d_rec IN (SELECT get_policy_no(policy_id) policy_no, policy_id
                                FROM gipi_invoice
                               WHERE iss_cd      = v_iss_cd
                                AND prem_seq_no = v_prem_seq_no)
                  LOOP /*D_REC*/
                    v_policy_no := d_rec.policy_no;
                    v_policy_id := d_rec.policy_id;
                  END LOOP; /*D_REC*/
                  
                FOR e_rec IN (SELECT incept_date, eff_date, endt_seq_no
                                FROM gipi_polbasic
                               WHERE policy_id = v_policy_id)
                LOOP
                    IF e_rec.endt_seq_no = 0 THEN
                        v_effect := e_rec.incept_date;
                    ELSE                               
                        v_effect := e_rec.eff_date;
                    END IF;	
                END LOOP;
    		
                IF p_date_tag    = 'OR'      THEN
                    v_age := a_rec.or_date - v_effect; 
                ELSIF p_date_tag = 'DCB'     THEN       
                    v_age := a_rec.due_dcb_date - v_effect; 
                ELSIF p_date_tag = 'POSTING' THEN	       
                    --v_age := a_rec.posting_date - v_effect;
                    v_age := a_rec.due_dcb_date - v_effect;   --modified by judyann 11262004
                END IF;	
    		
                INSERT INTO giac_coll_analysis_ext(branch_cd,            or_pref,           or_no,    
                                                   policy_no,            iss_cd,            prem_seq_no,   
                                                   payor,                intm_no,           intm_name,     
                                                   effect_date,          age,               date_from,     
                                                   date_to,              amount,            
                                                   param_iss_cd,         param_intm_no) -- added by shan 03.10.2014
                                            VALUES(a_rec.gibr_branch_cd, a_rec.or_pref_suf, a_rec.or_no, 
                                                   v_policy_no,          v_iss_cd,          v_prem_seq_no, 
                                                   a_rec.payor,          a_rec.intm_no,     v_intm_name, 
                                                   v_effect,             v_age,             p_from_date, 
                                                   p_to_date,            v_amount,
                                                   p_branch_cd,          p_intm_no);    -- added by shan 03.10.2014
     		                                     
                v_row_counter := v_row_counter + 1;                                   
          
            END LOOP; /*B_REC*/

            IF v_direct = FALSE THEN
                INSERT INTO giac_coll_analysis_ext(branch_cd,            or_pref,             or_no, 
                                                   payor,                intm_no,             intm_name,          
                                                   date_from,            date_to,             amount,            
                                                   param_iss_cd,         param_intm_no) -- added by shan 03.10.2014
                                            VALUES(a_rec.gibr_branch_cd, a_rec.or_pref_suf,   a_rec.or_no, 
                                                   a_rec.payor,          a_rec.intm_no,       v_intm_name, 
                                                   p_from_date,          p_to_date,           a_rec.collection_amt,
                                                   p_branch_cd,          p_intm_no);    -- added by shan 03.10.2014
     		                                     
                v_row_counter := v_row_counter + 1;			
            END IF;	
    	
    	    /*IF v_row_counter <> 0 THEN     
                FORMS_DDL('COMMIT');   
                MSG_ALERT('Extraction Finished! ' || TO_CHAR(v_row_counter) || ' records extracted.','I',FALSE); 
                :PARAMETER.extracted := 'Y';
            ELSE
                MSG_ALERT('No records extracted ...','I',FALSE);        
            END IF;	*/
            
            p_extracted_rec := v_row_counter;
            
        END LOOP; /*A_REC*/
        
    END extract_records; 
    

END GIACS078_PKG;
/


