CREATE OR REPLACE PACKAGE BODY CPI.GICL_LOSS_EXP_DTL_PKG AS

   /*
   **  Created by    : Veronica V. Raymundo
   **  Date Created  : 01.17.2012
   **  Reference By  : GICLS030 - Loss/Expense History
   **  Description   : Gets the list of GICL_LOSS_EXP_DTL records
   */ 
   
   FUNCTION get_gicl_loss_exp_dtl (p_claim_id      GICL_LOSS_EXP_DTL.claim_id%TYPE,
                                   p_clm_loss_id   GICL_LOSS_EXP_DTL.clm_loss_id%TYPE,
                                   p_line_cd       GICL_CLAIMS.line_cd%TYPE,
                                   p_payee_type    GICL_LOSS_EXP_PAYEES.payee_type%TYPE)
      RETURN gicl_loss_exp_dtl_tab PIPELINED AS
      
      v_loss_exp_dtl    gicl_loss_exp_dtl_type;
      v_ded_amt         GICL_LOSS_EXP_DED_DTL.ded_amt%TYPE := 0;
      
    BEGIN
        FOR i IN (SELECT c013.claim_id,       c013.clm_loss_id,   c013.loss_exp_cd,
                         c013.no_of_units,    c013.ded_base_amt,  c013.dtl_amt,
                         c013.subline_cd,     c013.original_sw,   c013.w_tax,
                         c013.user_id,        c013.last_update,   c013.loss_exp_type,
                         c013.line_cd,        c013.loss_exp_class
                    FROM GICL_LOSS_EXP_DTL c013
                    WHERE c013.loss_exp_cd IN (SELECT b.loss_exp_cd
                                                FROM GIIS_LOSS_EXP b
                                               WHERE b.loss_exp_cd = c013.loss_exp_cd
                                                 AND b.line_cd = c013.line_cd
                                                 AND b.loss_exp_type = c013.loss_exp_type
                                                 AND NVL(b.comp_sw, '+') = '+')
                    AND c013.subline_cd IS NULL
                    AND c013.claim_id = p_claim_id
                    AND c013.clm_loss_id = p_clm_loss_id)
             
        LOOP
            v_loss_exp_dtl.claim_id         :=  i.claim_id;   
            v_loss_exp_dtl.clm_loss_id      :=  i.clm_loss_id;
            v_loss_exp_dtl.loss_exp_cd      :=  i.loss_exp_cd;
            v_loss_exp_dtl.no_of_units      :=  i.no_of_units;
            v_loss_exp_dtl.nbt_no_of_units  :=  NVL(i.no_of_units, 1);
            v_loss_exp_dtl.ded_base_amt     :=  i.ded_base_amt;
            v_loss_exp_dtl.dtl_amt          :=  i.dtl_amt;
            v_loss_exp_dtl.subline_cd       :=  i.subline_cd;
            v_loss_exp_dtl.original_sw      :=  i.original_sw;
            v_loss_exp_dtl.w_tax            :=  i.w_tax;
            v_loss_exp_dtl.user_id          :=  i.user_id;
            v_loss_exp_dtl.last_update      :=  i.last_update;
            v_loss_exp_dtl.loss_exp_type    :=  i.loss_exp_type;
            v_loss_exp_dtl.line_cd          :=  i.line_cd;
            v_loss_exp_dtl.loss_exp_class   :=  i.loss_exp_class;
            
            IF i.subline_cd IS NULL THEN
                 FOR A IN
                   (SELECT loss_exp_desc, NVL(comp_sw, '+') comp_sw
                      FROM GIIS_LOSS_EXP
                     WHERE loss_exp_type = p_payee_type
                       AND line_cd       = p_line_cd
                       AND loss_exp_cd   = i.loss_exp_cd
                       AND subline_cd IS NULL)
                 LOOP
                   v_loss_exp_dtl.dsp_exp_desc := a.loss_exp_desc;
                   v_loss_exp_dtl.nbt_comp_sw  := a.comp_sw;
                 END LOOP;
            ELSE
                 FOR A IN
                   (SELECT loss_exp_desc, NVL(comp_sw, '-') comp_sw
                      FROM GIIS_LOSS_EXP
                     WHERE loss_exp_type = p_payee_type
                       AND line_cd       = p_line_cd
                       AND loss_exp_cd   = i.loss_exp_cd
                       AND subline_cd    = i.subline_cd)
                 LOOP
                   v_loss_exp_dtl.dsp_exp_desc := a.loss_exp_desc;
                   v_loss_exp_dtl.nbt_comp_sw  := a.comp_sw;
                 END LOOP;
            END IF;
              
            v_ded_amt  := 0;
            
            FOR ded IN
               (SELECT SUM(ABS(ded_amt)) amt
                  FROM GICL_LOSS_EXP_DED_DTL
                 WHERE claim_id    = i.claim_id
                   AND clm_loss_id = i.clm_loss_id
                   AND ded_cd      = i.loss_exp_cd)
             LOOP
               v_ded_amt := ded.amt*-1;
             END LOOP;
            
            v_loss_exp_dtl.nbt_net_amt := NVL(i.dtl_amt,0) + NVL(v_ded_amt,0);
            
            PIPE ROW(v_loss_exp_dtl);
            
        END LOOP;
    
    END get_gicl_loss_exp_dtl;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 01.20.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Check if records exist in GICL_LOSS_EXP_DTL
    **                  with the given parameters
    */ 

    FUNCTION check_exist_loss_exp_dtl(p_claim_id        GICL_CLM_LOSS_EXP.claim_id%TYPE,
                                      p_clm_loss_id     GICL_CLM_LOSS_EXP.clm_loss_id%TYPE)
    RETURN VARCHAR2 AS
        
        v_dtl_exist   VARCHAR2(1) := 'N';

      BEGIN
        FOR dtl IN (SELECT 'Y' exist
                      FROM GICL_LOSS_EXP_DTL
                     WHERE claim_id    = p_claim_id
                       AND clm_loss_id = p_clm_loss_id)
        LOOP
          v_dtl_exist := dtl.exist;
          EXIT;
        END LOOP;
        
        RETURN v_dtl_exist;
        
      END check_exist_loss_exp_dtl;
      
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 02.09.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Inserts or updates record on GICL_LOSS_EXP_DTL table
    */ 
        
    PROCEDURE set_gicl_loss_exp_dtl
    (p_claim_id        IN  GICL_LOSS_EXP_DTL.claim_id%TYPE,       
     p_clm_loss_id     IN  GICL_LOSS_EXP_DTL.clm_loss_id%TYPE,  
     p_loss_exp_cd     IN  GICL_LOSS_EXP_DTL.loss_exp_cd%TYPE,                 
     p_no_of_units     IN  GICL_LOSS_EXP_DTL.no_of_units%TYPE,     
     p_ded_base_amt    IN  GICL_LOSS_EXP_DTL.ded_base_amt%TYPE,
     p_dtl_amt         IN  GICL_LOSS_EXP_DTL.dtl_amt%TYPE,   
     p_line_cd         IN  GICL_LOSS_EXP_DTL.line_cd%TYPE,
     p_loss_exp_type   IN  GICL_LOSS_EXP_DTL.loss_exp_type%TYPE,
     p_loss_exp_class  IN  GICL_LOSS_EXP_DTL.loss_exp_class%TYPE,                   
     p_original_sw     IN  GICL_LOSS_EXP_DTL.original_sw%TYPE,    
     p_w_tax           IN  GICL_LOSS_EXP_DTL.w_tax%TYPE,                
     p_user_id         IN  GICL_LOSS_EXP_DTL.user_id%TYPE) AS
     
    BEGIN
        MERGE INTO GICL_LOSS_EXP_DTL
         USING DUAL ON(claim_id = p_claim_id 
                   AND clm_loss_id = p_clm_loss_id 
                   AND loss_exp_cd = p_loss_exp_cd)
                   
         WHEN NOT MATCHED THEN
                INSERT(
                    claim_id,         clm_loss_id,    loss_exp_cd,     no_of_units,
                    ded_base_amt,     dtl_amt,        line_cd,         loss_exp_type,
                    loss_exp_class,   original_sw,    w_tax,           user_id,         last_update
                )
                VALUES(
                    p_claim_id,       p_clm_loss_id,  p_loss_exp_cd,   p_no_of_units,
                    p_ded_base_amt,   p_dtl_amt,      p_line_cd,       p_loss_exp_type,        
                    p_loss_exp_class, p_original_sw,  p_w_tax,         p_user_id,       SYSDATE
                )
            WHEN MATCHED THEN 
                UPDATE SET                
                     no_of_units    = p_no_of_units,
                     ded_base_amt   = p_ded_base_amt,   
                     dtl_amt        = p_dtl_amt,        
                     original_sw    = p_original_sw,    
                     w_tax          = p_w_tax,          
                     loss_exp_type  = p_loss_exp_type,
                     loss_exp_class = p_loss_exp_class,   
                     user_id        = p_user_id,
                     last_update    = SYSDATE;
                     
    END set_gicl_loss_exp_dtl;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 02.09.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Deletes record from GICL_LOSS_EXP_DTL table
    */
     
    PROCEDURE delete_loss_exp_dtl(p_claim_id      IN   GICL_LOSS_EXP_DTL.claim_id%TYPE,
                                  p_clm_loss_id   IN   GICL_LOSS_EXP_DTL.clm_loss_id%TYPE,
                                  p_loss_exp_cd   IN   GICL_LOSS_EXP_DTL.loss_exp_cd%TYPE)
    AS

    BEGIN
        
        DELETE FROM GICL_LOSS_EXP_DTL
           WHERE claim_id = p_claim_id
           AND clm_loss_id = p_clm_loss_id
           AND loss_exp_cd = p_loss_exp_cd;
           
    END delete_loss_exp_dtl;
    
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 02.20.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Deletes record from GICL_LOSS_EXP_DTL table
    */
     
    PROCEDURE delete_loss_exp_dtl_2(p_claim_id      IN   GICL_LOSS_EXP_DTL.claim_id%TYPE,
                                    p_clm_loss_id   IN   GICL_LOSS_EXP_DTL.clm_loss_id%TYPE)
    AS

    BEGIN
        
        DELETE FROM GICL_LOSS_EXP_DTL
           WHERE claim_id = p_claim_id
           AND clm_loss_id = p_clm_loss_id;
           
    END delete_loss_exp_dtl_2;
    
   /*
   **  Created by    : Veronica V. Raymundo
   **  Date Created  : 02.29.2012
   **  Reference By  : GICLS030 - Loss/Expense History
   **  Description   : Gets the list of GICL_LOSS_EXP_DTL records
   **                  used for deductibles listing 
   */ 
    
    FUNCTION get_loss_exp_dtl_for_ded (p_claim_id    IN  GICL_LOSS_EXP_DTL.claim_id%TYPE,
                                       p_clm_loss_id IN  GICL_LOSS_EXP_DTL.clm_loss_id%TYPE,
                                       p_line_cd     IN  GICL_CLAIMS.line_cd%TYPE,
                                       p_payee_type  IN  GICL_LOSS_EXP_PAYEES.payee_type%TYPE)

      RETURN gicl_loss_exp_dtl_tab PIPELINED AS
          
      v_loss_exp_dtl    gicl_loss_exp_dtl_type;

    BEGIN
        FOR i IN(SELECT a.claim_id,        a.clm_loss_id,   a.line_cd,         a.loss_exp_cd, 
                        a.dtl_amt,         a.user_id,       a.last_update,     a.subline_cd, 
                        a.loss_exp_type,   a.ded_base_amt,  a.original_sw,     a.no_of_units,
                        a.ded_loss_exp_cd, a.ded_rate,      a.deductible_text
                   FROM GICL_LOSS_EXP_DTL a
                 WHERE EXISTS (SELECT b.loss_exp_cd
                                 FROM GIIS_LOSS_EXP b
                                WHERE b.loss_exp_cd = a.loss_exp_cd
                                  AND b.line_cd = a.line_cd
                                  AND b.loss_exp_type = a.loss_exp_type
                                  AND NVL(b.comp_sw, '+') = '-' 
                                  AND NVL(a.subline_cd, 'XXX') = NVL(b.subline_cd, 'XXX'))
                 AND a.claim_id = p_claim_id
                 AND a.clm_loss_id = p_clm_loss_id)
                 
        LOOP
            v_loss_exp_dtl.claim_id         :=  i.claim_id;   
            v_loss_exp_dtl.clm_loss_id      :=  i.clm_loss_id;
            v_loss_exp_dtl.line_cd          :=  i.line_cd;
            v_loss_exp_dtl.loss_exp_cd      :=  i.loss_exp_cd;
            v_loss_exp_dtl.dtl_amt          :=  i.dtl_amt;
            v_loss_exp_dtl.user_id          :=  i.user_id;
            v_loss_exp_dtl.last_update      :=  i.last_update;
            v_loss_exp_dtl.subline_cd       :=  i.subline_cd;
            v_loss_exp_dtl.loss_exp_type    :=  i.loss_exp_type;
            v_loss_exp_dtl.ded_base_amt     :=  i.ded_base_amt;
            v_loss_exp_dtl.original_sw      :=  i.original_sw;
            v_loss_exp_dtl.no_of_units      :=  i.no_of_units;
            v_loss_exp_dtl.nbt_no_of_units  :=  NVL(i.no_of_units, 1);
                
            v_loss_exp_dtl.ded_loss_exp_cd  :=  i.ded_loss_exp_cd;
            v_loss_exp_dtl.ded_rate         :=  i.ded_rate;
            v_loss_exp_dtl.deductible_text  :=  i.deductible_text;
                
            -- added the following lines to reset values
            v_loss_exp_dtl.dsp_exp_desc := '';
            v_loss_exp_dtl.nbt_comp_sw  := ''; 
            v_loss_exp_dtl.nbt_ded_type := '';
            v_loss_exp_dtl.dsp_ded_le_desc := '';
            v_loss_exp_dtl.nbt_deductible_type := '';
            v_loss_exp_dtl.nbt_min_amt  := NULL;
            v_loss_exp_dtl.nbt_max_amt  := NULL;
            v_loss_exp_dtl.nbt_range_sw := NULL;
            --
                    
            FOR A IN (SELECT loss_exp_desc, NVL(comp_sw, '-') comp_sw
                        FROM GIIS_LOSS_EXP
                       WHERE loss_exp_type = p_payee_type
                         AND line_cd       = p_line_cd
                         AND loss_exp_cd   = i.loss_exp_cd
                         AND NVL(subline_cd, 'XXX') = NVL(i.subline_cd,'XXX'))
            LOOP
                v_loss_exp_dtl.dsp_exp_desc := a.loss_exp_desc;
                v_loss_exp_dtl.nbt_comp_sw  := a.comp_sw;
            END LOOP;
                
            IF i.ded_loss_exp_cd != '%ALL%' THEN
                 FOR ded IN (SELECT loss_exp_desc le_desc
                               FROM GIIS_LOSS_EXP
                              WHERE line_cd       = p_line_cd
                                AND loss_exp_cd   = i.ded_loss_exp_cd
                                AND loss_exp_type = p_payee_type
                                AND subline_cd IS NULL)
                 LOOP
                   v_loss_exp_dtl.dsp_ded_le_desc := ded.le_desc;
                 END LOOP;
                     
            ELSE
                 v_loss_exp_dtl.dsp_ded_le_desc := 'ALL';
            END IF;
                
            FOR dedtype IN (SELECT rv_meaning, b.ded_type, b.min_amt, b.max_amt, b.range_sw
                              FROM GICL_CLAIMS a, GIIS_DEDUCTIBLE_DESC b, CG_REF_CODES c
                             WHERE a.claim_id = i.claim_id
                               AND b.line_cd  = i.line_cd
                               AND b.subline_cd = i.subline_cd
                               AND b.deductible_cd = i.loss_exp_cd
                               AND rv_domain = 'GIIS_DEDUCTIBLE_DESC.DED_TYPE'
                               AND rv_low_value = ded_type)
            LOOP
                v_loss_exp_dtl.nbt_ded_type := dedtype.rv_meaning;
                v_loss_exp_dtl.nbt_deductible_type := dedtype.ded_type;
                v_loss_exp_dtl.nbt_min_amt  := dedtype.min_amt;
                v_loss_exp_dtl.nbt_max_amt  := dedtype.max_amt;
                v_loss_exp_dtl.nbt_range_sw := dedtype.range_sw;
            END LOOP;
            
            PIPE ROW(v_loss_exp_dtl);
            
        END LOOP;
        
    END get_loss_exp_dtl_for_ded;
    
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.06.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Check if record has depreciation
    **                  
    */ 

    FUNCTION check_exist_depreciation(p_claim_id        GICL_CLM_LOSS_EXP.claim_id%TYPE,
                                      p_clm_loss_id     GICL_CLM_LOSS_EXP.clm_loss_id%TYPE)
    RETURN VARCHAR2 AS
        
        v_exist   VARCHAR2(1) := 'N';

    BEGIN
        FOR dtl IN (SELECT 'Y' exist
                      FROM GICL_LOSS_EXP_DTL
                     WHERE claim_id    = p_claim_id
                       AND clm_loss_id = p_clm_loss_id
                       AND loss_exp_cd = GIISP.V('MC_DEPRECIATION_CD'))
        LOOP
          v_exist := dtl.exist;
          EXIT;
        END LOOP;
            
        RETURN v_exist;
            
    END check_exist_depreciation;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.07.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Check if original part exist
    **                  
    */ 

    FUNCTION check_exist_orig_part(p_claim_id        GICL_CLM_LOSS_EXP.claim_id%TYPE,
                                   p_clm_loss_id     GICL_CLM_LOSS_EXP.clm_loss_id%TYPE)
    RETURN VARCHAR2 AS
        
        v_orig_sw   VARCHAR2(1) := 'N';

    BEGIN
        FOR chk_orig IN (SELECT '1'
                           FROM GICL_LOSS_EXP_DTL
                          WHERE claim_id          = p_claim_id  
                            AND clm_loss_id       = p_clm_loss_id
                            AND NVL(original_sw, 'N') = 'Y')
        LOOP 
         v_orig_sw := 'Y';
         EXIT;
        END LOOP;
            
        RETURN v_orig_sw;
            
    END check_exist_orig_part;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.07.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Check if records exist in GICL_LOSS_EXP_DTL
    **                  with the given parameters
    */ 

    FUNCTION check_exist_loss_exp_dtl_2(p_claim_id        GICL_CLM_LOSS_EXP.claim_id%TYPE,
                                        p_clm_loss_id     GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
                                        p_loss_exp_cd     GICL_LOSS_EXP_DTL.loss_exp_cd%TYPE)
    RETURN VARCHAR2 AS
            
        v_dtl_exist   VARCHAR2(1) := 'N';

      BEGIN
        FOR dtl IN (SELECT 'Y' exist
                      FROM GICL_LOSS_EXP_DTL
                     WHERE claim_id    = p_claim_id
                       AND clm_loss_id = p_clm_loss_id
                       AND loss_exp_cd = p_loss_exp_cd)
        LOOP
          v_dtl_exist := dtl.exist;
          EXIT;
        END LOOP;
            
        RETURN v_dtl_exist;
            
      END check_exist_loss_exp_dtl_2;
      
     /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.07.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Delete ded = '%ALL%' from GICL_LOSS_EXP_DTL and
    **                  delete details of the deductible from gicl_loss_exp_ded_dtl.
    */
         
    PROCEDURE delete_ded_equals_all(p_claim_id      IN   GICL_LOSS_EXP_DTL.claim_id%TYPE,
                                    p_clm_loss_id   IN   GICL_LOSS_EXP_DTL.clm_loss_id%TYPE)
    AS
        v_loss_ded_cd  GICL_LOSS_EXP_DTL.loss_exp_cd%TYPE;

    BEGIN
            
        FOR ddtl IN (SELECT loss_exp_cd cd
                       FROM GICL_LOSS_EXP_DTL
                      WHERE claim_id        = p_claim_id
                        AND clm_loss_id     = p_clm_loss_id
                        AND ded_loss_exp_cd = '%ALL%')
        LOOP
         
         v_loss_ded_cd := ddtl.cd;
         
         DELETE FROM GICL_LOSS_EXP_DED_DTL
               WHERE claim_id    = p_claim_id
                 AND clm_loss_id = p_clm_loss_id
                 AND loss_exp_cd = v_loss_ded_cd;
         
         DELETE FROM GICL_LOSS_EXP_DTL
               WHERE claim_id    = p_claim_id
                 AND clm_loss_id = p_clm_loss_id
                 AND loss_exp_cd = v_loss_ded_cd;
         
        END LOOP;
               
    END delete_ded_equals_all;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.13.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Gets records same with the records retrieve by
    **                  LOSS_DTL_RG_N record group in GICLS030
    */ 

    FUNCTION get_loss_dtl_rg_n
    (p_line_cd       IN      GICL_CLAIMS.line_cd%TYPE,
     p_claim_id      IN      GICL_CLAIMS.claim_id%TYPE,
     p_clm_loss_id   IN      GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
     p_payee_type    IN      GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
     p_tax_cd        IN      GICL_LOSS_EXP_TAX.tax_cd%TYPE,
     p_tax_type      IN      GICL_LOSS_EXP_TAX.tax_type%TYPE)
     
    RETURN loss_dtl_rg_tab PIPELINED AS

        loss_dtl_rg     loss_dtl_rg_type;
        
    BEGIN
        FOR i IN(SELECT a.loss_exp_cd, b.loss_exp_desc, a.dtl_amt loss_amt,
                        NULL net_of_input_tax, NVL(a.w_tax, 'N') w_tax
                  FROM GICL_LOSS_EXP_DTL a, GIIS_LOSS_EXP b
                 WHERE a.loss_exp_cd   = b.loss_exp_cd
                   AND a.line_cd       = b.line_cd
                   AND a.claim_id      = p_claim_id
                   AND a.clm_loss_id   = p_clm_loss_id
                   AND b.loss_exp_type = p_payee_type
                   AND a.loss_exp_type = b.loss_exp_type
                   AND b.subline_cd    IS NULL
                   AND a.subline_cd    IS NULL
                   AND a.loss_exp_cd   NOT IN (SELECT loss_exp_cd
                                                 FROM GICL_LOSS_EXP_TAX
                                                WHERE claim_id    = p_claim_id
                                                  AND tax_type    = p_tax_type
                                                  --AND tax_cd      = p_tax_cd --comment out kenneth 02122015
                                                  AND clm_loss_id = p_clm_loss_id
                                                  AND tax_amt     IS NOT NULL)
                   AND NVL(b.comp_sw,'+') != '-'

                UNION

                SELECT '0' loss_exp_cd, 'Total Loss Amt' loss_exp_desc, NVL(SUM(a.dtl_amt),0),
                       NULL net_of_input_tax, 'N' w_tax
                  FROM GICL_LOSS_EXP_DTL a
                 WHERE a.claim_id    = p_claim_id
                   AND a.clm_loss_id = p_clm_loss_id
                   AND 0 = (SELECT COUNT(*)             -- to exclude 'TOTAL' if specific loss/expense detail has already been added 
                              FROM GICL_LOSS_exp_TAX    -- SR-5002 : shan 09.24.2015
                             WHERE claim_id    = p_claim_id
                               AND clm_loss_id = p_clm_loss_id)

                MINUS

                SELECT '0' loss_exp_cd, 'Total Loss Amt' loss_exp_desc, NVL(SUM(a.dtl_amt),0),
                       NULL net_of_input_tax, 'N' w_tax
                  FROM GICL_LOSS_EXP_DTL a, GICL_LOSS_EXP_TAX b
                 WHERE a.claim_id    = b.claim_id
                   AND a.clm_loss_id = b.clm_loss_id
                   AND a.claim_id    = p_claim_id
                   AND a.clm_loss_id = p_clm_loss_id
                   AND b.loss_exp_cd = '0'
                   AND b.tax_type    = p_tax_type
                   --AND b.tax_cd      = p_tax_cd --comment out kenneth 02122015
                 
                UNION

                SELECT '0'||'-'||a.loss_exp_cd, a.loss_exp_desc||' MINUS Deductibles' loss_exp_desc,
                       NVL(c.dtl_amt,0) + NVL(b.dtl_amt,0) loss_amt,
                       NULL net_of_input_tax, NVL(c.w_tax, 'N') w_tax
                  FROM GIIS_LOSS_EXP a, GICL_LOSS_EXP_DTL c,
                       (SELECT SUM(NVL(ded_amt,0)) dtl_amt, ded_cd
                          FROM GICL_LOSS_EXP_DED_DTL
                         WHERE claim_id      = p_claim_id
                           AND clm_loss_id   = p_clm_loss_id
                           AND line_cd       = p_line_cd
                           AND loss_exp_type = p_payee_type
                           AND ded_amt       < 0
                        GROUP BY ded_cd ) b
                 WHERE a.line_cd          = c.line_cd
                   AND a.loss_exp_cd      = c.loss_exp_cd
                   AND c.loss_exp_cd      = b.ded_cd
                   AND a.loss_exp_type    = c.loss_exp_type
                   AND a.loss_exp_type    = p_payee_type
                   AND a.line_cd          = p_line_cd
                   AND c.claim_id         = p_claim_id
                   AND c.clm_loss_id      = p_clm_loss_id
                   AND a.subline_cd       IS NULL
                   AND c.subline_cd       IS NULL
                   AND b.dtl_amt          != 0
                   AND NVL(a.comp_sw,'+') != '-'

                MINUS

                SELECT '0'||'-'||a.loss_exp_cd, a.loss_exp_desc||' MINUS Deductibles' loss_exp_desc,
                       NVL(c.dtl_amt,0) + NVL(b.dtl_amt,0) loss_amt,
                       NULL net_of_input_tax, NVL(c.w_tax, 'N') w_tax
                  FROM GIIS_LOSS_EXP a, GICL_LOSS_EXP_DTL c,
                       (SELECT sum(NVL(ded_amt,0)) dtl_amt, ded_cd
                          FROM GICL_LOSS_EXP_DED_DTL
                         WHERE claim_id      = p_claim_id
                           AND clm_loss_id   = p_clm_loss_id
                           AND line_cd       = p_line_cd
                           AND loss_exp_type = p_payee_type
                           AND ded_amt       < 0
                        GROUP BY ded_cd ) b,
                       GICL_LOSS_EXP_TAX d
                 WHERE a.line_cd          = c.line_cd
                   AND a.loss_exp_cd      = c.loss_exp_cd
                   AND c.loss_exp_cd      = b.ded_cd
                   AND a.loss_exp_type    = c.loss_exp_type
                   AND a.loss_exp_type    = p_payee_type
                   AND a.line_cd          = p_line_cd
                   AND c.claim_id         = p_claim_id
                   AND c.clm_loss_id      = p_clm_loss_id
                   AND a.subline_cd       IS NULL
                   AND c.subline_cd       IS NULL
                   AND d.claim_id         = c.claim_id
                   AND d.clm_loss_id      = c.clm_loss_id
                   AND d.loss_exp_cd      = '0'||'-'||a.loss_exp_cd
                   AND d.tax_type         = p_tax_type
                   --AND d.tax_cd           = p_tax_cd --comment out kenneth 02122015
                   AND NVL(a.comp_sw,'+') != '-')
        
        LOOP
            
            loss_dtl_rg.loss_exp_cd       := i.loss_exp_cd;
            loss_dtl_rg.loss_exp_desc     := i.loss_exp_desc;
            loss_dtl_rg.loss_amt          := i.loss_amt;
            loss_dtl_rg.net_of_input_tax  := i.net_of_input_tax;
            loss_dtl_rg.w_tax             := i.w_tax;
            PIPE ROW(loss_dtl_rg);
        
        END LOOP;
        
    END get_loss_dtl_rg_n;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.13.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Gets records same with the records retrieve by
    **                  LOSS_DTL_RG_Y record group in GICLS030
    */ 

    FUNCTION get_loss_dtl_rg_y
    (p_line_cd       IN      GICL_CLAIMS.line_cd%TYPE,
     p_claim_id      IN      GICL_CLAIMS.claim_id%TYPE,
     p_clm_loss_id   IN      GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
     p_payee_type    IN      GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
     p_tax_cd        IN      GICL_LOSS_EXP_TAX.tax_cd%TYPE,
     p_tax_type      IN      GICL_LOSS_EXP_TAX.tax_type%TYPE)
     
    RETURN loss_dtl_rg_tab PIPELINED AS

        loss_dtl_rg     loss_dtl_rg_type;
        
    BEGIN
        FOR i IN(SELECT a.loss_exp_cd, b.loss_exp_desc, a.dtl_amt loss_amt,
                       NULL net_of_input_tax, NVL(a.w_tax, 'N') w_tax
                  FROM GICL_LOSS_EXP_DTL a, GIIS_LOSS_EXP b
                 WHERE a.loss_exp_cd   = b.loss_exp_cd
                   AND a.line_cd       = b.line_cd
                   AND a.claim_id      = p_claim_id
                   AND a.clm_loss_id   = p_clm_loss_id
                   AND b.loss_exp_type = p_payee_type
                   AND a.loss_exp_type = b.loss_exp_type
                   AND b.subline_cd    IS NULL
                   AND a.subline_cd    IS NULL
                   AND a.loss_exp_cd   NOT IN (SELECT loss_exp_cd
                                                 FROM GICL_LOSS_EXP_TAX
                                                WHERE claim_id    = p_claim_id
                                                  AND tax_type    = p_tax_type
                                                  --AND tax_cd      = p_tax_cd --comment out kenneth 02122015
                                                  AND clm_loss_id = p_clm_loss_id
                                                  AND tax_amt     IS NOT NULL)
                   AND NVL(b.comp_sw,'+') != '-'
                   
                 UNION
                 
                SELECT '0' loss_exp_cd, 'Total Loss Amt' loss_exp_desc, NVL(SUM(a.dtl_amt),0),
                       NULL net_of_input_tax, 'Y' w_tax
                  FROM GICL_LOSS_EXP_DTL a
                 WHERE a.claim_id    = p_claim_id
                   AND a.clm_loss_id = p_clm_loss_id
                   AND 0 = (SELECT COUNT(*)             -- to exclude 'TOTAL' if specific loss/expense detail has already been added 
                              FROM GICL_LOSS_exp_TAX    -- SR-5002 : shan 09.24.2015
                             WHERE claim_id    = p_claim_id
                               AND clm_loss_id = p_clm_loss_id)
                 
                 MINUS
                 
                SELECT '0' loss_exp_cd, 'Total Loss Amt' loss_exp_desc, NVL(sum(a.dtl_amt),0),
                       NULL net_of_input_tax, 'Y' w_tax
                  FROM GICL_LOSS_EXP_DTL a, GICL_LOSS_EXP_TAX b
                 WHERE a.claim_id    = b.claim_id
                   AND a.clm_loss_id = b.clm_loss_id
                   AND a.claim_id    = p_claim_id
                   AND a.clm_loss_id = p_clm_loss_id
                   AND b.loss_exp_cd = '0'
                   AND b.tax_type    = p_tax_type
                   --AND b.tax_cd      = p_tax_cd --comment out kenneth 02122015
                 
                 UNION
                 
                SELECT '0'||'-'||a.loss_exp_cd, a.loss_exp_desc||' MINUS Deductibles' loss_exp_desc,
                       NVL(c.dtl_amt,0) + NVL(b.dtl_amt,0) loss_amt,
                       NULL net_of_input_tax, NVL(c.w_tax, 'N') w_tax
                  FROM GIIS_LOSS_EXP a, GICL_LOSS_EXP_DTL c,
                       (SELECT sum(NVL(ded_amt,0)) dtl_amt, ded_cd
                          FROM GICL_LOSS_EXP_DED_DTL
                         WHERE claim_id      = p_claim_id
                           AND clm_loss_id   = p_clm_loss_id
                           AND line_cd       = p_line_cd
                           AND loss_exp_type = p_payee_type
                           AND ded_amt       < 0
                        GROUP BY ded_cd ) b
                 WHERE a.line_cd          = c.line_cd
                   AND a.loss_exp_cd      = c.loss_exp_cd
                   AND c.loss_exp_cd      = b.ded_cd
                   AND a.loss_exp_type    = c.loss_exp_type
                   AND a.loss_exp_type    = p_payee_type
                   AND a.line_cd          = p_line_cd
                   AND c.claim_id         = p_claim_id
                   AND c.clm_loss_id      = p_clm_loss_id
                   AND a.subline_cd       IS NULL
                   AND c.subline_cd       IS NULL
                   AND b.dtl_amt          != 0
                   AND NVL(a.comp_sw,'+') != '-'
                 
                 MINUS
                 
                SELECT '0'||'-'||a.loss_exp_cd, a.loss_exp_desc||' MINUS Deductibles' loss_exp_desc,
                       NVL(c.dtl_amt,0) + NVL(b.dtl_amt,0) loss_amt,
                       NULL net_of_input_tax, NVL(c.w_tax, 'N') w_tax
                  FROM GIIS_LOSS_EXP a, GICL_LOSS_EXP_DTL c,
                       (SELECT SUM(NVL(ded_amt,0)) dtl_amt, ded_cd
                          FROM GICL_LOSS_EXP_DED_DTL
                         WHERE claim_id      = p_claim_id
                           AND clm_loss_id   = p_clm_loss_id
                           AND line_cd       = p_line_cd
                           AND loss_exp_type = p_payee_type
                           AND ded_amt       < 0
                        GROUP BY ded_cd) b,
                       GICL_LOSS_EXP_TAX d
                 WHERE a.line_cd          = c.line_cd
                   AND a.loss_exp_cd      = c.loss_exp_cd
                   AND c.loss_exp_cd      = b.ded_cd
                   AND a.loss_exp_type    = c.loss_exp_type
                   AND a.loss_exp_type    = p_payee_type
                   AND a.line_cd          = p_line_cd
                   AND c.claim_id         = p_claim_id
                   AND c.clm_loss_id      = p_clm_loss_id
                   AND a.subline_cd       IS NULL
                   AND c.subline_cd       IS NULL
                   AND d.claim_id         = c.claim_id
                   AND d.clm_loss_id      = c.clm_loss_id
                   AND d.loss_exp_cd      = '0'||'-'||a.loss_exp_cd
                   AND d.tax_type         = p_tax_type
                   --AND d.tax_cd           = p_tax_cd --comment out kenneth 02122015
                   AND NVL(a.comp_sw,'+') != '-')
        
        LOOP
            
            loss_dtl_rg.loss_exp_cd      := i.loss_exp_cd;
            loss_dtl_rg.loss_exp_desc    := i.loss_exp_desc;
            loss_dtl_rg.loss_amt         := i.loss_amt;
            loss_dtl_rg.net_of_input_tax := i.net_of_input_tax;
            loss_dtl_rg.w_tax            := i.w_tax;
            PIPE ROW(loss_dtl_rg);
        
        END LOOP;
        
    END get_loss_dtl_rg_y;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.13.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Gets records same with the records retrieve by
    **                  LOSS_DTL_WON_RG record group in GICLS030
    */ 

    FUNCTION get_loss_dtl_won_rg
    (p_line_cd       IN      GICL_CLAIMS.line_cd%TYPE,
     p_claim_id      IN      GICL_CLAIMS.claim_id%TYPE,
     p_clm_loss_id   IN      GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
     p_payee_type    IN      GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
     p_tax_cd        IN      GICL_LOSS_EXP_TAX.tax_cd%TYPE,
     p_tax_type      IN      GICL_LOSS_EXP_TAX.tax_type%TYPE)
     
    RETURN loss_dtl_rg_tab PIPELINED AS

        loss_dtl_rg     loss_dtl_rg_type;
        
    BEGIN
        FOR i IN(SELECT a.loss_exp_cd, b.loss_exp_desc, a.dtl_amt loss_amt,
                       NULL net_of_input_tax, NVL(a.w_tax, 'N') w_tax
                  FROM GICL_LOSS_EXP_DTL a, GIIS_LOSS_EXP b
                 WHERE a.loss_exp_cd   = b.loss_exp_cd
                   AND a.line_cd       = b.line_cd
                   AND a.claim_id      = p_claim_id
                   AND a.clm_loss_id   = p_clm_loss_id
                   AND b.loss_exp_type = p_payee_type
                   AND a.loss_exp_type = b.loss_exp_type
                   AND b.subline_cd    IS NULL
                   AND a.subline_cd    IS NULL
                   AND a.loss_exp_cd   NOT IN (SELECT loss_exp_cd
                                                 FROM GICL_LOSS_EXP_TAX
                                                WHERE claim_id    = p_claim_id
                                                  AND tax_type    = p_tax_type
                                                  --AND tax_cd      = p_tax_cd --comment out kenneth 02122015
                                                  AND clm_loss_id = p_clm_loss_id
                                                  AND tax_amt     IS NOT NULL)
                   AND NVL(b.comp_sw,'+') != '-'
                 UNION
                 
                SELECT '0' loss_exp_cd, 'Total Loss Amt' loss_exp_desc, NVL(SUM(a.dtl_amt),0),
                       NULL net_of_input_tax, 'N' w_tax
                  FROM GICL_LOSS_EXP_DTL a
                 WHERE a.claim_id    = p_claim_id
                   AND a.clm_loss_id = p_clm_loss_id
                 
                MINUS
                 
                SELECT '0' loss_exp_cd, 'Total Loss Amt' loss_exp_desc, NVL(SUM(a.dtl_amt),0),
                       NULL net_of_input_tax, 'N' w_tax
                  FROM GICL_LOSS_EXP_DTL a, GICL_LOSS_EXP_TAX b
                 WHERE a.claim_id    = b.claim_id
                   AND a.clm_loss_id = b.clm_loss_id
                   AND a.claim_id    = p_claim_id
                   AND a.clm_loss_id = p_clm_loss_id
                   AND b.loss_exp_cd = '0'
                   AND b.tax_type    = p_tax_type
                   --AND b.tax_cd      = p_tax_cd --comment out kenneth 02122015
                 
                 UNION

                SELECT '0'||'-'||a.loss_exp_cd, a.loss_exp_desc||' MINUS Deductibles' loss_exp_desc, NVL(c.dtl_amt,0)+NVL(b.dtl_amt,0) loss_amt,
                       NULL net_of_input_tax, NVL(c.w_tax, 'N') w_tax
                  FROM GIIS_LOSS_EXP a, GICL_LOSS_EXP_DTL c,
                       (SELECT sum(NVL(ded_amt,0)) dtl_amt, ded_cd
                          FROM GICL_LOSS_EXP_DED_DTL
                         WHERE claim_id      = p_claim_id
                           AND clm_loss_id   = p_clm_loss_id
                           AND line_cd       = p_line_cd
                           AND loss_exp_type = p_payee_type
                           AND ded_amt       < 0
                        GROUP BY ded_cd ) b
                 WHERE a.line_cd          = c.line_cd
                   AND a.loss_exp_cd      = c.loss_exp_cd
                   AND c.loss_exp_cd      = b.ded_cd
                   AND a.loss_exp_type    = c.loss_exp_type
                   AND a.loss_exp_type    = p_payee_type
                   AND a.line_cd          = p_line_cd
                   AND c.claim_id         = p_claim_id
                   AND c.clm_loss_id      = p_clm_loss_id
                   AND a.subline_cd       IS NULL
                   AND c.subline_cd       IS NULL
                   AND b.dtl_amt          != 0
                   AND NVL(a.comp_sw,'+') != '-'

                MINUS

                SELECT '0'||'-'||a.loss_exp_cd, a.loss_exp_desc||' MINUS Deductibles' loss_exp_desc,
                       NVL(c.dtl_amt,0) + NVL(b.dtl_amt,0) loss_amt,
                       NULL net_of_input_tax, NVL(c.w_tax, 'N') w_tax
                  FROM GIIS_LOSS_EXP a, GICL_LOSS_EXP_DTL c,
                       (SELECT SUM(NVL(ded_amt,0)) dtl_amt, ded_cd
                          FROM GICL_LOSS_EXP_DED_DTL
                         WHERE claim_id      = p_claim_id
                           AND clm_loss_id   = p_clm_loss_id
                           AND line_cd       = p_line_cd
                           AND loss_exp_type = p_payee_type
                           AND ded_amt       < 0
                        GROUP BY ded_cd ) b,
                        GICL_LOSS_EXP_TAX d
                 WHERE a.line_cd          = c.line_cd
                   AND a.loss_exp_cd      = c.loss_exp_cd
                   AND c.loss_exp_cd      = b.ded_cd
                   AND a.loss_exp_type    = c.loss_exp_type
                   AND a.loss_exp_type    = p_payee_type
                   AND a.line_cd          = p_line_cd
                   AND c.claim_id         = p_claim_id
                   AND c.clm_loss_id      = p_clm_loss_id
                   AND a.subline_cd       IS NULL
                   AND c.subline_cd       IS NULL
                   AND d.claim_id         = c.claim_id
                   AND d.clm_loss_id      = c.clm_loss_id
                   AND d.loss_exp_cd     = '0'||'-'||a.loss_exp_cd 
                   AND d.tax_type         = p_tax_type
                   --AND d.tax_cd           = p_tax_cd --comment out kenneth 02122015
                   AND NVL(a.comp_sw,'+') != '-'
                UNION

                (SELECT a.loss_exp_cd||'-NI', b.loss_exp_desc||' Less Input VAT',
                        a.dtl_amt - c.tax_amt loss_amt, NULL net_of_input_tax,NVL(a.w_tax, 'N') w_tax
                   FROM GICL_LOSS_EXP_DTL a, GIIS_LOSS_EXP b,
                        (SELECT tax_amt, loss_exp_cd
                           FROM GICL_LOSS_EXP_TAX
                          WHERE claim_id    = p_claim_id
                            AND clm_loss_id = p_clm_loss_id
                            AND tax_type    = 'I') c
                  WHERE a.loss_exp_cd   = b.loss_exp_cd
                    AND a.line_cd       = b.line_cd
                    AND a.claim_id      = p_claim_id
                    AND a.clm_loss_id   = p_clm_loss_id
                    AND b.loss_exp_type = p_payee_type
                    AND a.loss_exp_type = b.loss_exp_type
                    AND b.subline_cd    IS NULL
                    AND a.subline_cd    IS NULL AND a.loss_exp_cd = DECODE(SUBSTR(c.loss_exp_cd,1,2),'0-',substr(c.loss_exp_cd,3),c.loss_exp_cd)
                    AND a.loss_exp_cd   NOT IN (SELECT loss_exp_cd
                                                  FROM GICL_LOSS_EXP_TAX
                                                 WHERE claim_id    = p_claim_id
                                                   AND tax_type    = p_tax_type
                                                   --AND tax_cd      = p_tax_cd --comment out kenneth 02122015
                                                   AND clm_loss_id = p_clm_loss_id
                                                   AND tax_amt     IS NOT NULL)
                    AND NVL(b.comp_sw,'+') != '-'
                  
                  UNION
                  
                 (SELECT '0-NI' loss_exp_cd, 'Total Loss Amt Less Input VAT' loss_exp_desc,
                        NVL(SUM(a.dtl_amt),0) - b.tax_amt loss_amt, NULL "net_of_input_tax", 'N' w_tax
                   FROM GICL_LOSS_EXP_DTL a,
                        (SELECT SUM(tax_amt) tax_amt
                           FROM GICL_LOSS_EXP_TAX
                          WHERE claim_id    = p_claim_id
                            AND clm_loss_id = p_clm_loss_id
                            AND tax_type    = 'I') b
                  WHERE a.claim_id    = p_claim_id 
                    AND a.clm_loss_id = p_clm_loss_id 
                    AND b.tax_amt IS NOT NULL
                  GROUP BY b.tax_amt
                  
                  MINUS
                  
                 SELECT '0-NI' loss_exp_cd, 'Total Loss Amt Less Input VAT' loss_exp_desc,
                        NVL(SUM(a.dtl_amt),0) - c.tax_amt loss_amt, NULL "net_of_input_tax", 'N' w_tax
                   FROM GICL_LOSS_EXP_DTL a, GICL_LOSS_EXP_TAX b,
                        (SELECT tax_amt FROM GICL_LOSS_EXP_TAX
                          WHERE claim_id = p_claim_id 
                         AND clm_loss_id = p_clm_loss_id 
                         AND tax_type    = 'I') c
                  WHERE a.claim_id    = b.claim_id
                    AND a.clm_loss_id = b.clm_loss_id
                    AND a.claim_id    = p_claim_id
                    AND a.clm_loss_id = p_clm_loss_id
                    AND b.loss_exp_cd = '0'
                    AND b.tax_type    = p_tax_type
                    --AND b.tax_cd      = p_tax_cd --comment out kenneth 02122015
                  GROUP BY c.tax_amt))

                UNION

                SELECT a.loss_exp_cd||'-DI', a.loss_exp_desc||' Less Deductibles, Less Input Vat' loss_exp_desc, 
                       NVL(c.dtl_amt,0) + NVL(b.dtl_amt,0)-d.tax_amt loss_amt, null net_of_input_tax, NVL(c.w_tax, 'N') w_tax 
                  FROM GIIS_LOSS_EXP a, GICL_LOSS_EXP_DTL c, 
                       (SELECT SUM(NVL(ded_amt,0)) dtl_amt, ded_cd 
                          FROM GICL_LOSS_EXP_DED_DTL 
                         WHERE claim_id      = p_claim_id 
                           AND clm_loss_id   = p_clm_loss_id 
                           AND line_cd       = p_line_cd 
                           AND loss_exp_type = p_payee_type 
                           AND ded_amt       < 0 
                        GROUP BY ded_cd ) b, 
                        (SELECT tax_amt,loss_exp_cd 
                           FROM GICL_LOSS_EXP_TAX 
                          WHERE claim_id    = p_claim_id 
                            AND clm_loss_id = p_clm_loss_id 
                            AND tax_type    = 'I') d 
                 WHERE a.line_cd          = c.line_cd 
                   AND a.loss_exp_cd      = c.loss_exp_cd 
                   AND c.loss_exp_cd      = b.ded_cd 
                   AND a.loss_exp_type    = c.loss_exp_type 
                   AND a.loss_exp_type    = p_payee_type 
                   AND a.line_cd          = p_line_cd 
                   AND c.claim_id         = p_claim_id 
                   AND c.clm_loss_id      = p_clm_loss_id 
                   AND a.subline_cd       IS NULL 
                   AND c.subline_cd       IS NULL 
                   AND b.dtl_amt          != 0 
                   AND NVL(a.comp_sw,'+') != '-' 
                   and c.loss_exp_cd = DECODE(SUBSTR(d.loss_exp_cd,1,2),'0-', SUBSTR(d.loss_exp_cd,3),d.loss_exp_cd)
                   AND a.loss_exp_cd||'-DI' NOT IN (SELECT loss_exp_cd 
                                                      FROM GICL_LOSS_EXP_TAX 
                                                     WHERE claim_id    = p_claim_id 
                                                       AND tax_type    = p_tax_type 
                                                       --AND tax_cd      = p_tax_cd --comment out kenneth 02122015
                                                       AND clm_loss_id = p_clm_loss_id 
                                                       AND tax_amt     IS NOT NULL)
                 ORDER BY loss_exp_cd, loss_exp_desc)
        
        LOOP
            
            loss_dtl_rg.loss_exp_cd        := i.loss_exp_cd;
            loss_dtl_rg.loss_exp_desc      := i.loss_exp_desc;
            loss_dtl_rg.loss_amt           := i.loss_amt;
            loss_dtl_rg.net_of_input_tax   := i.net_of_input_tax;
            loss_dtl_rg.w_tax              := i.w_tax;
            PIPE ROW(loss_dtl_rg);
        
        END LOOP;
        
    END get_loss_dtl_won_rg;
	
	/*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 12.03.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Gets records same with the records retrieve by
    **                  LOSS_DTL_WON_RG record group in GICLS030.
	**					Created new function that will retrieve correct loss amounts.
    */ 

    FUNCTION get_loss_dtl_won_rg_new
    (p_line_cd       IN      GICL_CLAIMS.line_cd%TYPE,
     p_claim_id      IN      GICL_CLAIMS.claim_id%TYPE,
     p_clm_loss_id   IN      GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
     p_payee_type    IN      GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
     p_tax_cd        IN      GICL_LOSS_EXP_TAX.tax_cd%TYPE,
     p_tax_type      IN      GICL_LOSS_EXP_TAX.tax_type%TYPE)
     
    RETURN loss_dtl_rg_tab PIPELINED AS

        loss_dtl_rg     loss_dtl_rg_type;
        
    BEGIN
        FOR i IN(SELECT a.loss_exp_cd, b.loss_exp_desc, 
                       (a.dtl_amt + NVL(c.tax_amt,0)) loss_amt,
                       NULL net_of_input_tax, NVL(a.w_tax, 'N') w_tax
                  FROM GICL_LOSS_EXP_DTL a, GIIS_LOSS_EXP b,
                       (SELECT SUM(tax_amt) tax_amt, 
                               DECODE(SUBSTR(loss_exp_cd,1,2),'0-',SUBSTR(loss_exp_cd,3), loss_exp_cd) loss_exp_cd
                          FROM GICL_LOSS_EXP_TAX
                         WHERE claim_id    = p_claim_id
                           AND clm_loss_id = p_clm_loss_id
                           AND tax_type    = 'I'
                           AND NVL(w_tax, 'N') = 'N'
                      GROUP BY loss_exp_cd) c 
                 WHERE a.loss_exp_cd   = b.loss_exp_cd
                   AND a.loss_exp_cd   = c.loss_exp_cd(+)
                   AND a.line_cd       = b.line_cd
                   AND a.claim_id      = p_claim_id
                   AND a.clm_loss_id   = p_clm_loss_id
                   AND b.loss_exp_type = p_payee_type
                   AND a.loss_exp_type = b.loss_exp_type
                   AND b.subline_cd    IS NULL
                   AND a.subline_cd    IS NULL
                   AND a.loss_exp_cd   NOT IN (SELECT loss_exp_cd
                                                 FROM GICL_LOSS_EXP_TAX
                                                WHERE claim_id    = p_claim_id
                                                  AND tax_type    = p_tax_type
                                                  AND tax_cd      = p_tax_cd
                                                  AND clm_loss_id = p_clm_loss_id
                                                  AND tax_amt     IS NOT NULL)
                   AND NVL(b.comp_sw,'+') != '-'
                 UNION
                 
                SELECT '0' loss_exp_cd, 'Total Loss Amt' loss_exp_desc,
                       NVL(SUM(a.dtl_amt),0) + NVL(b.input_tax, 0) dtl_amt,
                       NULL net_of_input_tax, 'N' w_tax
                  FROM GICL_LOSS_EXP_DTL a,
                       (SELECT SUM(tax_amt) input_tax
                          FROM GICL_LOSS_EXP_TAX
                         WHERE claim_id    = p_claim_id
                           AND clm_loss_id = p_clm_loss_id
                           AND tax_type    = 'I'
                           AND NVL(w_tax, 'N') = 'N') b 
                 WHERE a.claim_id    = p_claim_id
                   AND a.clm_loss_id = p_clm_loss_id
                 GROUP BY b.input_tax
                  
                MINUS
                 
                SELECT '0' loss_exp_cd, 'Total Loss Amt' loss_exp_desc, 
                       NVL(SUM(a.dtl_amt),0) + NVL(c.input_tax, 0) dtl_amt,
                       NULL net_of_input_tax, 'N' w_tax
                  FROM GICL_LOSS_EXP_DTL a, GICL_LOSS_EXP_TAX b,
                       (SELECT SUM(tax_amt) input_tax
                          FROM GICL_LOSS_EXP_TAX
                         WHERE claim_id    = p_claim_id
                           AND clm_loss_id = p_clm_loss_id
                           AND tax_type    = 'I'
                           AND NVL(w_tax, 'N') = 'N') c
                 WHERE a.claim_id    = b.claim_id
                   AND a.clm_loss_id = b.clm_loss_id
                   AND a.claim_id    = p_claim_id
                   AND a.clm_loss_id = p_clm_loss_id
                   AND b.loss_exp_cd = '0'
                   AND b.tax_type    = p_tax_type
                   AND b.tax_cd      = p_tax_cd
                 GROUP BY c.input_tax 
                 
                 UNION

                SELECT '0'||'-'||a.loss_exp_cd, a.loss_exp_desc||' MINUS Deductibles' loss_exp_desc, NVL(c.dtl_amt,0)+NVL(b.dtl_amt,0) loss_amt,
                       NULL net_of_input_tax, NVL(c.w_tax, 'N') w_tax
                  FROM GIIS_LOSS_EXP a, GICL_LOSS_EXP_DTL c,
                       (SELECT sum(NVL(ded_amt,0)) dtl_amt, ded_cd
                          FROM GICL_LOSS_EXP_DED_DTL
                         WHERE claim_id      = p_claim_id
                           AND clm_loss_id   = p_clm_loss_id
                           AND line_cd       = p_line_cd
                           AND loss_exp_type = p_payee_type
                           AND ded_amt       < 0
                        GROUP BY ded_cd ) b
                 WHERE a.line_cd          = c.line_cd
                   AND a.loss_exp_cd      = c.loss_exp_cd
                   AND c.loss_exp_cd      = b.ded_cd
                   AND a.loss_exp_type    = c.loss_exp_type
                   AND a.loss_exp_type    = p_payee_type
                   AND a.line_cd          = p_line_cd
                   AND c.claim_id         = p_claim_id
                   AND c.clm_loss_id      = p_clm_loss_id
                   AND a.subline_cd       IS NULL
                   AND c.subline_cd       IS NULL
                   AND b.dtl_amt          != 0
                   AND NVL(a.comp_sw,'+') != '-'

                MINUS

                SELECT '0'||'-'||a.loss_exp_cd, a.loss_exp_desc||' MINUS Deductibles' loss_exp_desc,
                       NVL(c.dtl_amt,0) + NVL(b.dtl_amt,0) loss_amt,
                       NULL net_of_input_tax, NVL(c.w_tax, 'N') w_tax
                  FROM GIIS_LOSS_EXP a, GICL_LOSS_EXP_DTL c,
                       (SELECT SUM(NVL(ded_amt,0)) dtl_amt, ded_cd
                          FROM GICL_LOSS_EXP_DED_DTL
                         WHERE claim_id      = p_claim_id
                           AND clm_loss_id   = p_clm_loss_id
                           AND line_cd       = p_line_cd
                           AND loss_exp_type = p_payee_type
                           AND ded_amt       < 0
                        GROUP BY ded_cd ) b,
                        GICL_LOSS_EXP_TAX d
                 WHERE a.line_cd          = c.line_cd
                   AND a.loss_exp_cd      = c.loss_exp_cd
                   AND c.loss_exp_cd      = b.ded_cd
                   AND a.loss_exp_type    = c.loss_exp_type
                   AND a.loss_exp_type    = p_payee_type
                   AND a.line_cd          = p_line_cd
                   AND c.claim_id         = p_claim_id
                   AND c.clm_loss_id      = p_clm_loss_id
                   AND a.subline_cd       IS NULL
                   AND c.subline_cd       IS NULL
                   AND d.claim_id         = c.claim_id
                   AND d.clm_loss_id      = c.clm_loss_id
                   AND d.loss_exp_cd     = '0'||'-'||a.loss_exp_cd 
                   AND d.tax_type         = p_tax_type
                   AND d.tax_cd           = p_tax_cd
                   AND NVL(a.comp_sw,'+') != '-'
                UNION

                (SELECT a.loss_exp_cd||'-NI', b.loss_exp_desc||' Less Input VAT',
                        (a.dtl_amt + NVL(d.tax_amt,0)) - c.tax_amt loss_amt, 
                        NULL net_of_input_tax,NVL(a.w_tax, 'N') w_tax
                   FROM GICL_LOSS_EXP_DTL a, GIIS_LOSS_EXP b,
                        (SELECT tax_amt, loss_exp_cd
                           FROM GICL_LOSS_EXP_TAX
                          WHERE claim_id    = p_claim_id
                            AND clm_loss_id = p_clm_loss_id
                            AND tax_type    = 'I') c,
                        (SELECT SUM(tax_amt) tax_amt, 
                                DECODE(SUBSTR(loss_exp_cd,1,2),'0-',SUBSTR(loss_exp_cd,3), loss_exp_cd) loss_exp_cd
                           FROM GICL_LOSS_EXP_TAX
                          WHERE claim_id    = p_claim_id
                            AND clm_loss_id = p_clm_loss_id
                            AND tax_type    = 'I'
                            AND NVL(w_tax, 'N') = 'N'
                         GROUP BY loss_exp_cd) d
                  WHERE a.loss_exp_cd   = b.loss_exp_cd
                    AND a.loss_exp_cd   = d.loss_exp_cd(+)
                    AND a.line_cd       = b.line_cd
                    AND a.claim_id      = p_claim_id
                    AND a.clm_loss_id   = p_clm_loss_id
                    AND b.loss_exp_type = p_payee_type
                    AND a.loss_exp_type = b.loss_exp_type
                    AND b.subline_cd    IS NULL
                    AND a.subline_cd    IS NULL AND a.loss_exp_cd = DECODE(SUBSTR(c.loss_exp_cd,1,2),'0-',substr(c.loss_exp_cd,3),c.loss_exp_cd)
                    AND a.loss_exp_cd   NOT IN (SELECT loss_exp_cd
                                                  FROM GICL_LOSS_EXP_TAX
                                                 WHERE claim_id    = p_claim_id
                                                   AND tax_type    = p_tax_type
                                                   AND tax_cd      = p_tax_cd
                                                   AND clm_loss_id = p_clm_loss_id
                                                   AND tax_amt     IS NOT NULL)
                    AND NVL(b.comp_sw,'+') != '-'
                  
                  UNION
                  
                 (SELECT '0-NI' loss_exp_cd, 'Total Loss Amt Less Input VAT' loss_exp_desc,
                         NVL(SUM(a.dtl_amt),0) +(NVL(c.input_tax, 0))- b.tax_amt loss_amt,
                        NULL "net_of_input_tax", 'N' w_tax
                   FROM GICL_LOSS_EXP_DTL a,
                        (SELECT SUM(tax_amt) tax_amt
                           FROM GICL_LOSS_EXP_TAX
                          WHERE claim_id    = p_claim_id
                            AND clm_loss_id = p_clm_loss_id
                            AND tax_type    = 'I') b,
                        (SELECT SUM(tax_amt) input_tax
                           FROM GICL_LOSS_EXP_TAX
                          WHERE claim_id    = p_claim_id
                            AND clm_loss_id = p_clm_loss_id
                            AND tax_type    = 'I'
                            AND NVL(w_tax, 'N') = 'N') c
                  WHERE a.claim_id    = p_claim_id 
                    AND a.clm_loss_id = p_clm_loss_id 
                    AND b.tax_amt IS NOT NULL
                  GROUP BY b.tax_amt, c.input_tax
                  
                  MINUS
                  
                 SELECT '0-NI' loss_exp_cd, 'Total Loss Amt Less Input VAT' loss_exp_desc,
                        NVL(SUM(a.dtl_amt),0) +(NVL(d.input_tax, 0)) - c.tax_amt loss_amt,
                        NULL "net_of_input_tax", 'N' w_tax
                   FROM GICL_LOSS_EXP_DTL a, GICL_LOSS_EXP_TAX b,
                        (SELECT tax_amt FROM GICL_LOSS_EXP_TAX
                          WHERE claim_id = p_claim_id 
                         AND clm_loss_id = p_clm_loss_id 
                         AND tax_type    = 'I') c,
                         (SELECT SUM(tax_amt) input_tax
                           FROM GICL_LOSS_EXP_TAX
                          WHERE claim_id    = p_claim_id
                            AND clm_loss_id = p_clm_loss_id
                            AND tax_type    = 'I'
                            AND NVL(w_tax, 'N') = 'N') d
                  WHERE a.claim_id    = b.claim_id
                    AND a.clm_loss_id = b.clm_loss_id
                    AND a.claim_id    = p_claim_id
                    AND a.clm_loss_id = p_clm_loss_id
                    AND b.loss_exp_cd = '0'
                    AND b.tax_type    = p_tax_type
                    AND b.tax_cd      = p_tax_cd
                  GROUP BY c.tax_amt, d.input_tax))

                UNION

                SELECT a.loss_exp_cd||'-DI', a.loss_exp_desc||' Less Deductibles, Less Input Vat' loss_exp_desc, 
                       NVL(c.dtl_amt,0) + NVL(b.dtl_amt,0)+ NVL(e.tax_amt,0) -d.tax_amt loss_amt,
                       NULL net_of_input_tax, NVL(c.w_tax, 'N') w_tax 
                  FROM GIIS_LOSS_EXP a, GICL_LOSS_EXP_DTL c, 
                       (SELECT SUM(NVL(ded_amt,0)) dtl_amt, ded_cd 
                          FROM GICL_LOSS_EXP_DED_DTL 
                         WHERE claim_id      = p_claim_id 
                           AND clm_loss_id   = p_clm_loss_id 
                           AND line_cd       = p_line_cd 
                           AND loss_exp_type = p_payee_type 
                           AND ded_amt       < 0 
                        GROUP BY ded_cd ) b, 
                        (SELECT tax_amt,loss_exp_cd 
                           FROM GICL_LOSS_EXP_TAX 
                          WHERE claim_id    = p_claim_id 
                            AND clm_loss_id = p_clm_loss_id 
                            AND tax_type    = 'I') d,
                        (SELECT SUM(tax_amt) tax_amt, 
                                DECODE(SUBSTR(loss_exp_cd,1,2),'0-',SUBSTR(loss_exp_cd,3), loss_exp_cd) loss_exp_cd
                           FROM GICL_LOSS_EXP_TAX
                          WHERE claim_id    = p_claim_id
                            AND clm_loss_id = p_clm_loss_id
                            AND tax_type    = 'I'
                            AND NVL(w_tax, 'N') = 'N'
                         GROUP BY loss_exp_cd) e 
                 WHERE a.line_cd          = c.line_cd 
                   AND a.loss_exp_cd      = c.loss_exp_cd 
                   AND c.loss_exp_cd      = b.ded_cd
                   AND a.loss_exp_cd      = e.loss_exp_cd(+) 
                   AND a.loss_exp_type    = c.loss_exp_type 
                   AND a.loss_exp_type    = p_payee_type 
                   AND a.line_cd          = p_line_cd 
                   AND c.claim_id         = p_claim_id 
                   AND c.clm_loss_id      = p_clm_loss_id 
                   AND a.subline_cd       IS NULL 
                   AND c.subline_cd       IS NULL 
                   AND b.dtl_amt          != 0 
                   AND NVL(a.comp_sw,'+') != '-' 
                   and c.loss_exp_cd = DECODE(SUBSTR(d.loss_exp_cd,1,2),'0-', SUBSTR(d.loss_exp_cd,3),d.loss_exp_cd)
                   AND a.loss_exp_cd||'-DI' NOT IN (SELECT loss_exp_cd 
                                                      FROM GICL_LOSS_EXP_TAX 
                                                     WHERE claim_id    = p_claim_id 
                                                       AND tax_type    = p_tax_type 
                                                       AND tax_cd      = p_tax_cd
                                                       AND clm_loss_id = p_clm_loss_id 
                                                       AND tax_amt     IS NOT NULL)
                 ORDER BY loss_exp_cd, loss_exp_desc)
        
        LOOP
            
            loss_dtl_rg.loss_exp_cd        := i.loss_exp_cd;
            loss_dtl_rg.loss_exp_desc      := i.loss_exp_desc;
            loss_dtl_rg.loss_amt           := i.loss_amt;
            loss_dtl_rg.net_of_input_tax   := i.net_of_input_tax;
            loss_dtl_rg.w_tax              := i.w_tax;
            PIPE ROW(loss_dtl_rg);
        
        END LOOP;
        
    END get_loss_dtl_won_rg_new;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.14.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Check if records exist in GICL_LOSS_EXP_DTL
    **                  with the given parameters
    */ 

    FUNCTION check_exist_loss_dtl_all_wtax
    (p_claim_id     IN    GICL_CLAIMS.claim_id%TYPE,
     p_clm_loss_id  IN    GICL_CLM_LOSS_EXP.clm_loss_id%TYPE)

    RETURN VARCHAR AS
        
      v_all_wtax  VARCHAR2(1) := 'Y';    

    BEGIN
        FOR i IN (SELECT '1'
                    FROM gicl_loss_exp_dtl
                  WHERE claim_id        = p_claim_id
                    AND clm_loss_id     = p_clm_loss_id
                    AND NVL(w_tax, 'N') = 'N'
                    AND ded_loss_exp_cd IS NULL)
        LOOP
           v_all_wtax := 'N';
           EXIT;
        END LOOP;
      
      RETURN v_all_wtax;
        
    END check_exist_loss_dtl_all_wtax;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.16.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Gets records same with the records retrieve by
    **                  LE_DED_RG record group in GICLS030
    */

    FUNCTION get_deductible_loss_exp_list
    (p_claim_id    IN   GICL_CLAIMS.claim_id%TYPE,
     p_clm_loss_id IN   GICL_CLM_LOSS_EXP.clm_loss_id%TYPE)
     
    RETURN loss_exp_dtl_ded_rg_tab PIPELINED AS

      ded_le_list     loss_exp_dtl_ded_rg_type;
      
    BEGIN
        FOR i IN (SELECT a.loss_exp_cd, b.loss_exp_desc, a.dtl_amt detail_amount 
                    FROM GICL_LOSS_EXP_DTL a, GIIS_LOSS_EXP b 
                    WHERE a.line_cd = b.line_cd 
                    AND a.loss_exp_cd = b.loss_exp_cd 
                    AND a.subline_cd IS NULL 
                    AND NVL(b.comp_sw, '+') = '+' 
                    AND a.loss_exp_type = b.loss_exp_type 
                    AND a.claim_id = p_claim_id 
                    AND a.clm_loss_id = p_clm_loss_id)
                    
        LOOP
                
            ded_le_list.loss_exp_cd     := i.loss_exp_cd;
            ded_le_list.loss_exp_desc   := i.loss_exp_desc;
            ded_le_list.dtl_amt         := i.detail_amount;
            PIPE ROW(ded_le_list);
            
        END LOOP;

    END get_deductible_loss_exp_list;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.16.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Gets records same with the records retrieve by
    **                  LE_DEDUCTIBLE_RG record group in GICLS030
    */

    FUNCTION get_deductible_loss_exp_list_2
    (p_claim_id    IN   GICL_CLAIMS.claim_id%TYPE,
     p_clm_loss_id IN   GICL_CLM_LOSS_EXP.clm_loss_id%TYPE)
     
    RETURN loss_exp_dtl_ded_rg_tab PIPELINED AS

      ded_le_list     loss_exp_dtl_ded_rg_type;
      
    BEGIN
        FOR i IN (SELECT a.loss_exp_cd, b.loss_exp_desc, a.dtl_amt detail_amount 
                    FROM GICL_LOSS_EXP_DTL a, GIIS_LOSS_EXP b 
                   WHERE a.line_cd = b.line_cd 
                     AND a.loss_exp_cd = b.loss_exp_cd 
                     AND a.subline_cd IS NULL 
                     AND NVL(b.comp_sw, '+') = '+' 
                     AND a.loss_exp_type = b.loss_exp_type 
                     AND a.claim_id = p_claim_id 
                     AND a.clm_loss_id = p_clm_loss_id 
                  UNION
                 
                 SELECT '%ALL%' loss, 'ALL' loss_desc, SUM(NVL(a.dtl_amt,0)) detail_amount 
                   FROM GICL_LOSS_EXP_DTL a, GIIS_LOSS_EXP b 
                  WHERE a.line_cd = b.line_cd 
                    AND a.loss_exp_cd = b.loss_exp_cd 
                    AND a.subline_cd IS NULL 
                    AND NVL(b.comp_sw, '+') = '+' 
                    AND a.loss_exp_type = b.loss_exp_type 
                    AND a.claim_id = p_claim_id 
                    AND a.clm_loss_id = p_clm_loss_id)
                    
        LOOP
                
            ded_le_list.loss_exp_cd     := i.loss_exp_cd;
            ded_le_list.loss_exp_desc   := i.loss_exp_desc;
            ded_le_list.dtl_amt         := i.detail_amount;
            PIPE ROW(ded_le_list);
            
        END LOOP;

    END get_deductible_loss_exp_list_2;

    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.20.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Check if previously saved loss/exp dtls have
    **                  deductible = '%ALL%'
    */     
    FUNCTION check_exist_ded_equals_all(p_claim_id      IN   GICL_LOSS_EXP_DTL.claim_id%TYPE,
                                        p_clm_loss_id   IN   GICL_LOSS_EXP_DTL.clm_loss_id%TYPE)
    RETURN VARCHAR2 AS
            
       v_dtl_exist   VARCHAR2(1) := 'N';

    BEGIN
                
        FOR ddtl IN (SELECT loss_exp_cd cd
                       FROM GICL_LOSS_EXP_DTL
                      WHERE claim_id        = p_claim_id
                        AND clm_loss_id     = p_clm_loss_id
                        AND ded_loss_exp_cd = '%ALL%')
        LOOP       
          v_dtl_exist := 'Y';
          EXIT;     
        END LOOP;
            
        RETURN v_dtl_exist;
                   
    END check_exist_ded_equals_all;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.22.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Inserts or updates record on GICL_LOSS_EXP_DTL table
    **                  (Used in Loss Expense Deductibles)
    */ 
        
    PROCEDURE set_gicl_loss_exp_dtl_2
    (p_claim_id         IN  GICL_LOSS_EXP_DTL.claim_id%TYPE,       
     p_clm_loss_id      IN  GICL_LOSS_EXP_DTL.clm_loss_id%TYPE,  
     p_loss_exp_cd      IN  GICL_LOSS_EXP_DTL.loss_exp_cd%TYPE,                 
     p_no_of_units      IN  GICL_LOSS_EXP_DTL.no_of_units%TYPE,     
     p_ded_base_amt     IN  GICL_LOSS_EXP_DTL.ded_base_amt%TYPE,
     p_dtl_amt          IN  GICL_LOSS_EXP_DTL.dtl_amt%TYPE,   
     p_line_cd          IN  GICL_LOSS_EXP_DTL.line_cd%TYPE,
     p_loss_exp_type    IN  GICL_LOSS_EXP_DTL.loss_exp_type%TYPE,                   
     p_original_sw      IN  GICL_LOSS_EXP_DTL.original_sw%TYPE,                  
     p_user_id          IN  GICL_LOSS_EXP_DTL.user_id%TYPE,
     p_subline_cd       IN  GICL_LOSS_EXP_DTL.subline_cd%TYPE,
     p_ded_loss_exp_cd  IN  GICL_LOSS_EXP_DTL.ded_loss_exp_cd%TYPE,
     p_ded_rate         IN  VARCHAR2,  --Kenneth 07102015 SR 4204
     p_deductible_text  IN  GICL_LOSS_EXP_DTL.deductible_text%TYPE ) AS
     
    BEGIN
        MERGE INTO GICL_LOSS_EXP_DTL
         USING DUAL ON(claim_id = p_claim_id 
                   AND clm_loss_id = p_clm_loss_id 
                   AND loss_exp_cd = p_loss_exp_cd)
                   
         WHEN NOT MATCHED THEN
                INSERT(
                    claim_id,          clm_loss_id,       loss_exp_cd,     no_of_units,
                    ded_base_amt,      dtl_amt,           line_cd,         loss_exp_type,
                    original_sw,       subline_cd,        user_id,         last_update,
                    ded_loss_exp_cd,   ded_rate,          deductible_text
                )
                VALUES(
                    p_claim_id,        p_clm_loss_id,     p_loss_exp_cd,   p_no_of_units,
                    p_ded_base_amt,    p_dtl_amt,         p_line_cd,       p_loss_exp_type,        
                    p_original_sw,     p_subline_cd,      p_user_id,       SYSDATE,
                    p_ded_loss_exp_cd, to_number(p_ded_rate),  p_deductible_text --Kenneth 07102015 SR 4204
                )
            WHEN MATCHED THEN 
                UPDATE SET                
                     no_of_units        = p_no_of_units,
                     ded_base_amt       = p_ded_base_amt,   
                     dtl_amt            = p_dtl_amt,        
                     original_sw        = p_original_sw,              
                     loss_exp_type      = p_loss_exp_type,    
                     user_id            = p_user_id,
                     last_update        = SYSDATE,
                     subline_cd         = p_subline_cd,        
                     ded_loss_exp_cd    = p_ded_loss_exp_cd,   
                     ded_rate           = to_number(p_ded_rate),  --Kenneth 07102015 SR 4204     
                     deductible_text    = p_deductible_text;
                     
    END set_gicl_loss_exp_dtl_2;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.26.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Gets the list of GICL_LOSS_EXP_DTL records
    **                  for LOA Printing
    */ 
       
    FUNCTION get_dtl_loa_list(p_claim_id    IN  GICL_CLAIMS.claim_id%TYPE,
                              p_clm_loss_id IN  GICL_LOSS_EXP_DTL.clm_loss_id%TYPE,
                              p_line_cd     IN  GICL_CLAIMS.line_cd%TYPE)
    RETURN dtl_loa_csl_tab PIPELINED AS

      dtl_loa     dtl_loa_csl_type;
      
    BEGIN
        FOR i IN (SELECT a.claim_id, a.clm_loss_id,    
                         a.loss_exp_cd, a.dtl_amt
                    FROM GICL_LOSS_EXP_DTL a
                   WHERE a.loss_exp_cd IN (SELECT b.loss_exp_cd
                                           FROM GIIS_LOSS_EXP b
                                          WHERE b.loss_exp_cd = a.loss_exp_cd
                                            AND b.line_cd = a.line_cd
                                            AND b.loss_exp_type = a.loss_exp_type
                                            AND NVL(b.comp_sw, '+') = '+')
                  AND a.subline_cd IS NULL
                  AND a.claim_id = p_claim_id
                  AND a.clm_loss_id = p_clm_loss_id)
        LOOP
            dtl_loa.claim_id    :=  i.claim_id;
            dtl_loa.clm_loss_id :=  i.clm_loss_id;
            dtl_loa.loss_exp_cd :=  i.loss_exp_cd;
            dtl_loa.dtl_amt     :=  i.dtl_amt;
            
            FOR A IN
               (SELECT loss_exp_desc
                  FROM GIIS_LOSS_EXP
                 WHERE line_cd  = p_line_cd
                   AND loss_exp_cd  = i.loss_exp_cd)
            LOOP
                dtl_loa.nbt_exp_desc := a.loss_exp_desc;
            END LOOP;
            
            PIPE ROW(dtl_loa);
            
        END LOOP;
        
    END get_dtl_loa_list;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.26.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Gets the list of GICL_LOSS_EXP_DTL records
    **                  for CSL Printing
    */ 
       
    FUNCTION get_dtl_csl_list(p_claim_id    IN  GICL_CLAIMS.claim_id%TYPE,
                              p_clm_loss_id IN  GICL_LOSS_EXP_DTL.clm_loss_id%TYPE,
                              p_line_cd     IN  GICL_CLAIMS.line_cd%TYPE)
    RETURN dtl_loa_csl_tab PIPELINED AS

      dtl_csl     dtl_loa_csl_type;
      
    BEGIN
        FOR i IN (SELECT a.claim_id, a.clm_loss_id,    
                         a.loss_exp_cd, a.dtl_amt
                    FROM GICL_LOSS_EXP_DTL a
                   WHERE a.loss_exp_cd IN (SELECT b.loss_exp_cd
                                           FROM GIIS_LOSS_EXP b
                                          WHERE b.loss_exp_cd = a.loss_exp_cd
                                            AND b.line_cd = a.line_cd
                                            AND b.loss_exp_type = a.loss_exp_type
                                            AND NVL(b.comp_sw, '+') = '+')
                  AND a.subline_cd IS NULL
                  AND a.claim_id = p_claim_id
                  AND a.clm_loss_id = p_clm_loss_id)
        LOOP
            dtl_csl.claim_id    :=  i.claim_id;
            dtl_csl.clm_loss_id :=  i.clm_loss_id;
            dtl_csl.loss_exp_cd :=  i.loss_exp_cd;
            dtl_csl.dtl_amt     :=  i.dtl_amt;
            
            FOR A IN
               (SELECT loss_exp_desc
                  FROM GIIS_LOSS_EXP
                 WHERE line_cd  = p_line_cd
                   AND loss_exp_cd  = i.loss_exp_cd)
            LOOP
                dtl_csl.nbt_exp_desc := a.loss_exp_desc;
            END LOOP;
            
            PIPE ROW(dtl_csl);
            
        END LOOP;
        
    END get_dtl_csl_list;
	
	/*
   **  Created by    : Veronica V. Raymundo
   **  Date Created  : 03.26.2013
   **  Reference By  : GICLS260 - Claim information
   **  Description   : Gets the list of GICL_LOSS_EXP_DTL records 
   **                  with comp_sw = + and comp_sw = -
   */ 
   
   FUNCTION get_all_gicl_loss_exp_dtl (p_claim_id      GICL_LOSS_EXP_DTL.claim_id%TYPE,
                                       p_clm_loss_id   GICL_LOSS_EXP_DTL.clm_loss_id%TYPE,
                                       p_line_cd       GICL_CLAIMS.line_cd%TYPE,
                                       p_payee_type    GICL_LOSS_EXP_PAYEES.payee_type%TYPE)
      RETURN gicl_loss_exp_dtl_tab PIPELINED AS
      
      v_loss_exp_dtl    gicl_loss_exp_dtl_type;
      v_ded_amt         GICL_LOSS_EXP_DED_DTL.ded_amt%TYPE := 0;
      
    BEGIN
        FOR i IN (SELECT c013.claim_id,       c013.clm_loss_id,   c013.loss_exp_cd,
                         c013.no_of_units,    c013.ded_base_amt,  c013.dtl_amt,
                         c013.subline_cd,     c013.original_sw,   c013.w_tax,
                         c013.user_id,        c013.last_update,   c013.loss_exp_type,
                         c013.line_cd,        c013.loss_exp_class
                    FROM GICL_LOSS_EXP_DTL c013
                    WHERE c013.claim_id = p_claim_id
                      AND c013.clm_loss_id = p_clm_loss_id)
             
        LOOP
            v_loss_exp_dtl.claim_id         :=  i.claim_id;   
            v_loss_exp_dtl.clm_loss_id      :=  i.clm_loss_id;
            v_loss_exp_dtl.loss_exp_cd      :=  i.loss_exp_cd;
            v_loss_exp_dtl.no_of_units      :=  i.no_of_units;
            v_loss_exp_dtl.nbt_no_of_units  :=  NVL(i.no_of_units, 1);
            v_loss_exp_dtl.ded_base_amt     :=  i.ded_base_amt;
            v_loss_exp_dtl.dtl_amt          :=  i.dtl_amt;
            v_loss_exp_dtl.subline_cd       :=  i.subline_cd;
            v_loss_exp_dtl.original_sw      :=  i.original_sw;
            v_loss_exp_dtl.w_tax            :=  i.w_tax;
            v_loss_exp_dtl.user_id          :=  i.user_id;
            v_loss_exp_dtl.last_update      :=  i.last_update;
            v_loss_exp_dtl.loss_exp_type    :=  i.loss_exp_type;
            v_loss_exp_dtl.line_cd          :=  i.line_cd;
            v_loss_exp_dtl.loss_exp_class   :=  i.loss_exp_class;
            
            IF i.subline_cd IS NULL THEN
                 FOR A IN
                   (SELECT loss_exp_desc, NVL(comp_sw, '+') comp_sw
                      FROM GIIS_LOSS_EXP
                     WHERE loss_exp_type = p_payee_type
                       AND line_cd       = p_line_cd
                       AND loss_exp_cd   = i.loss_exp_cd
                       AND subline_cd IS NULL)
                 LOOP
                   v_loss_exp_dtl.dsp_exp_desc := a.loss_exp_desc;
                   v_loss_exp_dtl.nbt_comp_sw  := a.comp_sw;
                 END LOOP;
            ELSE
                 FOR A IN
                   (SELECT loss_exp_desc, NVL(comp_sw, '-') comp_sw
                      FROM GIIS_LOSS_EXP
                     WHERE loss_exp_type = p_payee_type
                       AND line_cd       = p_line_cd
                       AND loss_exp_cd   = i.loss_exp_cd
                       AND subline_cd    = i.subline_cd)
                 LOOP
                   v_loss_exp_dtl.dsp_exp_desc := a.loss_exp_desc;
                   v_loss_exp_dtl.nbt_comp_sw  := a.comp_sw;
                 END LOOP;
            END IF;
              
            v_ded_amt  := 0;
            
            FOR ded IN
               (SELECT SUM(ABS(ded_amt)) amt
                  FROM GICL_LOSS_EXP_DED_DTL
                 WHERE claim_id    = i.claim_id
                   AND clm_loss_id = i.clm_loss_id
                   AND ded_cd      = i.loss_exp_cd)
             LOOP
               v_ded_amt := ded.amt*-1;
             END LOOP;
            
            v_loss_exp_dtl.nbt_net_amt := NVL(i.dtl_amt,0) + NVL(v_ded_amt,0);
            
            PIPE ROW(v_loss_exp_dtl);
            
        END LOOP;
    
    END get_all_gicl_loss_exp_dtl; 

END GICL_LOSS_EXP_DTL_PKG;
/


DROP PUBLIC SYNONYM GICL_LOSS_EXP_DTL_PKG;

CREATE PUBLIC SYNONYM GICL_LOSS_EXP_DTL_PKG FOR CPI.GICL_LOSS_EXP_DTL_PKG;


