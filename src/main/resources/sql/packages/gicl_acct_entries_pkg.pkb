CREATE OR REPLACE PACKAGE BODY CPI.GICL_ACCT_ENTRIES_PKG AS

   /*
   **  Created by   :  Veronica V. Raymundo
   **  Date Created :  12.19.2011
   **  Reference By : (GICLS043 - Batch Claim Settlement Request)
   **  Description  : Retrieves list of records from GICL_ACCT_ENTRIES
   **                 
   */

    FUNCTION get_gicl_acct_entries(p_advice_id          GICL_ACCT_ENTRIES.advice_id%TYPE,
                                   p_claim_id           GICL_ACCT_ENTRIES.claim_id%TYPE,
                                   p_gl_acct_category   GICL_ACCT_ENTRIES.gl_acct_category%TYPE,
                                   p_gl_control_acct    GICL_ACCT_ENTRIES.gl_control_acct%TYPE,
                                   p_gl_sub_acct_1      GICL_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
                                   p_gl_sub_acct_2      GICL_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
                                   p_gl_sub_acct_3      GICL_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
                                   p_gl_sub_acct_4      GICL_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
                                   p_gl_sub_acct_5      GICL_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
                                   p_gl_sub_acct_6      GICL_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
                                   p_gl_sub_acct_7      GICL_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
                                   p_sl_code            GICL_ACCT_ENTRIES.sl_cd%TYPE,
                                   p_debit_amt          GICL_ACCT_ENTRIES.debit_amt%TYPE,
                                   p_credit_amt         GICL_ACCT_ENTRIES.credit_amt%TYPE)
                                   
    RETURN gicl_acct_entries_tab PIPELINED AS
    
    v_list      gicl_acct_entries_type;
    
    BEGIN
        FOR i IN (SELECT a.claim_id,          a.advice_id,         a.acct_entry_id,     
                         a.clm_loss_id,       a.gl_acct_id,        a.gl_acct_category,  
                         a.gl_control_acct,   a.gl_sub_acct_1,     a.gl_sub_acct_2,    
                         a.gl_sub_acct_3,     a.gl_sub_acct_4,     a.gl_sub_acct_5,    
                         a.gl_sub_acct_6,     a.gl_sub_acct_7,     a.sl_cd,          
                         a.debit_amt,         a.credit_amt,        a.generation_type, 
                         a.sl_type_cd,        a.sl_source_cd,      a.batch_csr_id,   
                         a.remarks,           a.user_id,           a.last_update,      
                         a.payee_class_cd,    a.payee_cd,          a.batch_dv_id,
                         TO_CHAR(a.gl_acct_category)|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_control_acct,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_1,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_2,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_3,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_4,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_5,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_6,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_7,'09')) gl_acct_code
                  FROM GICL_ACCT_ENTRIES a
                  WHERE a.advice_id = p_advice_id
                    AND a.claim_id  = p_claim_id
                    AND a.gl_acct_category LIKE NVL(p_gl_acct_category, a.gl_acct_category)
                    AND a.gl_control_acct LIKE NVL(p_gl_control_acct, a.gl_control_acct)
                    AND a.gl_sub_acct_1 LIKE NVL(p_gl_sub_acct_1, a.gl_sub_acct_1)
                    AND a.gl_sub_acct_2 LIKE NVL(p_gl_sub_acct_2, a.gl_sub_acct_2)
                    AND a.gl_sub_acct_3 LIKE NVL(p_gl_sub_acct_3, a.gl_sub_acct_3)
                    AND a.gl_sub_acct_4 LIKE NVL(p_gl_sub_acct_4, a.gl_sub_acct_4)
                    AND a.gl_sub_acct_5 LIKE NVL(p_gl_sub_acct_5, a.gl_sub_acct_5)
                    AND a.gl_sub_acct_6 LIKE NVL(p_gl_sub_acct_6, a.gl_sub_acct_6)
                    AND a.gl_sub_acct_7 LIKE NVL(p_gl_sub_acct_7, a.gl_sub_acct_7)
                    AND NVL(a.sl_cd, 0) LIKE NVL(p_sl_code, NVL(a.sl_cd, 0))
                    AND NVL(a.debit_amt, 0) LIKE NVL(p_debit_amt, NVL(a.debit_amt, 0))
                    AND NVL(a.credit_amt,0) LIKE NVL(p_credit_amt, NVL(a.credit_amt,0))
                  )
        LOOP
            v_list.claim_id         :=  i.claim_id;               
            v_list.advice_id        :=  i.advice_id;  
            v_list.acct_entry_id    :=  i.acct_entry_id;  
            v_list.clm_loss_id      :=  i.clm_loss_id;   
            v_list.gl_acct_id       :=  i.gl_acct_id;   
            v_list.gl_acct_category :=  i.gl_acct_category;  
            v_list.gl_control_acct  :=  i.gl_control_acct;  
            v_list.gl_sub_acct_1    :=  i.gl_sub_acct_1;  
            v_list.gl_sub_acct_2    :=  i.gl_sub_acct_2; 
            v_list.gl_sub_acct_3    :=  i.gl_sub_acct_3; 
            v_list.gl_sub_acct_4    :=  i.gl_sub_acct_4;  
            v_list.gl_sub_acct_5    :=  i.gl_sub_acct_5;  
            v_list.gl_sub_acct_6    :=  i.gl_sub_acct_6; 
            v_list.gl_sub_acct_7    :=  i.gl_sub_acct_7; 
            v_list.sl_cd            :=  i.sl_cd;   
            v_list.debit_amt        :=  i.debit_amt;  
            v_list.credit_amt       :=  i.credit_amt;   
            v_list.generation_type  :=  i.generation_type;   
            v_list.sl_type_cd       :=  i.sl_type_cd;   
            v_list.sl_source_cd     :=  i.sl_source_cd;  
            v_list.batch_csr_id     :=  i.batch_csr_id;  
            v_list.remarks          :=  i.remarks;   
            v_list.user_id          :=  i.user_id; 
            v_list.last_update      :=  i.last_update;   
            v_list.payee_class_cd   :=  i.payee_class_cd;   
            v_list.payee_cd         :=  i.payee_cd;  
            v_list.batch_dv_id      :=  i.batch_dv_id;
            v_list.nbt_gl_acct_name :=  GET_GL_ACCT_NAME_2(i.gl_acct_category,  i.gl_control_acct,   i.gl_sub_acct_1,     
                                                           i.gl_sub_acct_2,     i.gl_sub_acct_3,     i.gl_sub_acct_4,    
                                                           i.gl_sub_acct_5,     i.gl_sub_acct_6,     i.gl_sub_acct_7,      
                                                           i.sl_type_cd,        i.sl_cd);
            v_list.nbt_gl_acct_code :=  i.gl_acct_code;
            PIPE ROW(v_list);         
        END LOOP;
    END;

   /*
   **  Created by   :  Andrew Robes
   **  Date Created :  1.13.2011
   **  Reference By : (GICLS032 - Generate Advice)
   **  Description  : Retrieves list of records from gicl_acct_entries of the given claim_id, advice_id, payee_class_cd and payee_cd 
   **                 
   */
  FUNCTION get_gicl_acct_entries_list(
    p_claim_id gicl_acct_entries.claim_id%TYPE,
    p_advice_id gicl_acct_entries.advice_id%TYPE,    
    p_payee_cd gicl_acct_entries.payee_cd%TYPE,
    p_payee_class_cd gicl_acct_entries.payee_class_cd%TYPE
  ) RETURN gicl_acct_entries_tab PIPELINED IS
    
    v_entry gicl_acct_entries_type;
  BEGIN
    FOR i IN (
        SELECT a.claim_id, a.advice_id, a.payee_cd, a.payee_class_cd, a.acct_entry_id, a.clm_loss_id,
               a.gl_acct_category || ' - ' || a.gl_control_acct || ' - ' || a.gl_sub_acct_1 || ' - ' 
               || a.gl_sub_acct_2 || ' - ' || a.gl_sub_acct_3 || ' - ' || a.gl_sub_acct_4 || ' - ' 
               || a.gl_sub_acct_5 || ' - ' || a.gl_sub_acct_6 || ' - ' || a.gl_sub_acct_7 gl_account_code, 
               a.sl_type_cd, a.sl_cd, a.debit_amt, a.credit_amt, b.gl_acct_name, c.sl_name
          FROM gicl_acct_entries a
              ,giac_chart_of_accts b
              ,giac_sl_lists c
         WHERE a.claim_id = p_claim_id
           AND a.advice_id = p_advice_id
           AND a.payee_class_cd = p_payee_class_cd   
           AND a.payee_cd = p_payee_cd
           AND c.sl_type_cd (+) = a.sl_type_cd
           AND c.sl_cd (+) = a.sl_cd
           AND b.gl_sub_acct_7    = a.gl_sub_acct_7 
           AND b.gl_sub_acct_6    = a.gl_sub_acct_6 
           AND b.gl_sub_acct_5    = a.gl_sub_acct_5 
           AND b.gl_sub_acct_4    = a.gl_sub_acct_4 
           AND b.gl_sub_acct_3    = a.gl_sub_acct_3 
           AND b.gl_sub_acct_2    = a.gl_sub_acct_2 
           AND b.gl_sub_acct_1    = a.gl_sub_acct_1 
           AND b.gl_control_acct  = a.gl_control_acct
           AND b.gl_acct_category = a.gl_acct_category
      )
    LOOP
      v_entry.claim_id := i.claim_id;
      v_entry.advice_id := i.advice_id;
      v_entry.payee_cd := i.payee_cd;
      v_entry.payee_class_cd := i.payee_class_cd;
      v_entry.acct_entry_id := i.acct_entry_id;
      v_entry.clm_loss_id := i.clm_loss_id;
      v_entry.nbt_gl_acct_code := i.gl_account_code;
      v_entry.sl_type_cd := i.sl_type_cd;
      v_entry.sl_cd := i.sl_cd;
      v_entry.debit_amt := i.debit_amt;
      v_entry.credit_amt := i.credit_amt;
      
      IF i.sl_name IS NOT NULL THEN
        v_entry.nbt_gl_acct_name := i.gl_acct_name || '  /  [SL - ' || ltrim(i.sl_name) || ' ]'; 
      ELSE
        v_entry.nbt_gl_acct_name := i.gl_acct_name;
      END IF;
          
      PIPE ROW(v_entry);
    END LOOP;
    RETURN;
  END get_gicl_acct_entries_list;

END GICL_ACCT_ENTRIES_PKG;
/


