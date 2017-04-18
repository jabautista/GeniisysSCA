CREATE OR REPLACE PACKAGE BODY CPI.GICL_LOSS_EXP_TAX_PKG AS

   FUNCTION get_loss_exp_taxes(
            p_claim_id      GICL_LOSS_EXP_TAX.claim_id%TYPE,
            p_clm_loss_id   GICL_LOSS_EXP_TAX.clm_loss_id%TYPE,
            p_tax_id        GICL_LOSS_EXP_TAX.tax_id%TYPE,
            p_tax_cd        GICL_LOSS_EXP_TAX.tax_cd%TYPE,
            p_tax_type      GICL_LOSS_EXP_TAX.tax_type%TYPE
   )RETURN loss_exp_tax_tab PIPELINED IS
       v_loss_exp_tax loss_exp_tax_type;
   BEGIN
        FOR i IN (
            SELECT  claim_id,        clm_loss_id,
                    tax_id,          tax_cd,
                    tax_type,        loss_exp_cd,
                    base_amt,        user_id,
                    last_update,     tax_amt,
                    tax_pct,         adv_tag,
                    net_tag,
                    cpi_rec_no,      cpi_branch_cd,          
                    w_tax,
                    sl_type_cd,     sl_cd
              FROM gicl_loss_exp_tax
             WHERE claim_id = p_claim_id
               AND clm_loss_id = p_clm_loss_id
               AND tax_id = p_tax_id
               AND tax_cd = p_tax_cd
               AND tax_type = p_tax_type
        )LOOP
            v_loss_exp_tax.claim_id     := i.claim_id;
            v_loss_exp_tax.clm_loss_id  := i.clm_loss_id;
            v_loss_exp_tax.tax_id       := i.tax_id;
            v_loss_exp_tax.tax_cd       := i.tax_cd;
            v_loss_exp_tax.tax_type     := i.tax_type;
            v_loss_exp_tax.loss_exp_cd  := i.loss_exp_cd;
            v_loss_exp_tax.base_amt     := i.base_amt;
            v_loss_exp_tax.user_id      := i.user_id;
            v_loss_exp_tax.last_update  := i.last_update;
            v_loss_exp_tax.tax_amt      := i.tax_amt;
            v_loss_exp_tax.tax_pct      := i.tax_pct;
            v_loss_exp_tax.adv_tag      := i.adv_tag;      
            v_loss_exp_tax.net_tag      := i.net_tag;
            v_loss_exp_tax.cpi_rec_no   := i.cpi_rec_no;
            v_loss_exp_tax.cpi_branch_cd:= i.cpi_branch_cd;
            v_loss_exp_tax.w_tax        := i.w_tax;
            v_loss_exp_tax.sl_type_cd   := i.sl_type_cd;
            v_loss_exp_tax.sl_cd        := i.sl_cd;
            
            PIPE ROW(v_loss_exp_tax);
        END LOOP;
        RETURN;
       /*SELECT *
         INTO v_loss_exp_tax
         FROM gicl_loss_exp_tax
        WHERE claim_id = p_claim_id
          AND clm_loss_id = p_clm_loss_id
          AND tax_id = p_tax_id
          AND tax_cd = p_tax_cd
          AND tax_type = p_tax_type;
       RETURN v_loss_exp_tax;*/
   END get_loss_exp_taxes;
   
      /*
       **  Created by    : Veronica V. Raymundo
       **  Date Created  : 02.08.2012
       **  Reference By  : GICLS030 - Loss/Expense History
       **  Description   : Checks if record exist in GICL_LOSS_EXP_TAX 
       **                  with the given parameters.
       */ 
       
    FUNCTION check_exist_loss_exp_tax
    (p_claim_id     IN   GICL_LOSS_EXP_TAX.claim_id%TYPE,
     p_clm_loss_id  IN   GICL_LOSS_EXP_TAX.clm_loss_id%TYPE)
     
     RETURN VARCHAR2 AS
     
     v_exist    VARCHAR2(1) := 'N';
     
    BEGIN
        FOR i IN (SELECT 1 FROM GICL_LOSS_EXP_TAX     
                   WHERE claim_id = p_claim_id 
                     AND clm_loss_id = p_clm_loss_id)
        LOOP
            v_exist := 'Y';
        END LOOP;
        
        RETURN v_exist;
    END check_exist_loss_exp_tax;
    
    /*
   **  Created by    : Veronica V. Raymundo
   **  Date Created  : 02.16.2012
   **  Reference By  : GICLS030 - Loss/Expense History
   **  Description   : Checks if record exist in GICL_LOSS_EXP_TAX 
   **                  with the given parameters.
   */ 
    
    FUNCTION check_exist_loss_exp_tax_2
    (p_claim_id     IN   GICL_LOSS_EXP_TAX.claim_id%TYPE,
     p_clm_loss_id  IN   GICL_LOSS_EXP_TAX.clm_loss_id%TYPE,
     p_loss_exp_cd  IN   GICL_LOSS_EXP_TAX.loss_exp_cd%TYPE)
     
     RETURN VARCHAR2 AS
     
     v_tax_exist    VARCHAR2(1) := 'N';
     
    BEGIN
        FOR ctax IN
          (SELECT 'Y'
        	   FROM GICL_LOSS_EXP_TAX
        	  WHERE claim_id    = p_claim_id
        	    AND clm_loss_id = p_clm_loss_id
        	    AND (loss_exp_cd = p_loss_exp_cd
        	      OR loss_exp_cd LIKE ''||'%'||p_loss_exp_cd||'%'||''
        	      OR loss_exp_cd = '0'))
        LOOP
          v_tax_exist := 'Y';
       
        END LOOP;
        
        RETURN v_tax_exist;
        
    END check_exist_loss_exp_tax_2;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 02.14.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Check if record has tax/es.
    */ 
       
    FUNCTION get_count_loss_exp_tax 
        (p_claim_id     IN   GICL_LOSS_EXP_TAX.claim_id%TYPE,
         p_clm_loss_id  IN   GICL_LOSS_EXP_TAX.clm_loss_id%TYPE)
         
    RETURN NUMBER AS
        
        v_cnt          NUMBER(5) := 0;

    BEGIN
        FOR ctax IN
            (SELECT loss_exp_cd
               FROM GICL_LOSS_EXP_DTL
              WHERE claim_id    = p_claim_id
                AND clm_loss_id = p_clm_loss_id)
         LOOP
            FOR m IN (SELECT COUNT(*) cnt
                        FROM GICL_LOSS_EXP_TAX
                       WHERE claim_id    = p_claim_id
                         AND clm_loss_id = p_clm_loss_id
                         AND (loss_exp_cd LIKE ''||'%'||ctax.loss_exp_cd||'%'||''
                           OR loss_exp_cd = '0'))
            LOOP
              v_cnt := NVL(m.cnt,0);
            END LOOP;
         END LOOP;
             
         RETURN v_cnt;
           
    END get_count_loss_exp_tax;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 02.14.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Deletes records in GICL_LOSS_EXP_TAX with the
    **                  given parameters.
    */ 
    
    PROCEDURE delete_loss_exp_tax(p_claim_id      GICL_LOSS_EXP_TAX.claim_id%TYPE,
                                  p_clm_loss_id   GICL_LOSS_EXP_TAX.clm_loss_id%TYPE)
    AS

    BEGIN
        
        DELETE FROM GICL_LOSS_EXP_TAX
        WHERE claim_id = p_claim_id 
          AND clm_loss_id = p_clm_loss_id;
          
    END delete_loss_exp_tax;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 02.16.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Deletes records in GICL_LOSS_EXP_TAX with the
    **                  given parameters.
    */ 
    
    PROCEDURE delete_loss_exp_tax_2(p_claim_id      GICL_LOSS_EXP_TAX.claim_id%TYPE,
                                    p_clm_loss_id   GICL_LOSS_EXP_TAX.clm_loss_id%TYPE,
                                    p_loss_exp_cd   GICL_LOSS_EXP_TAX.loss_exp_cd%TYPE) AS
    BEGIN
      FOR dl IN
        (SELECT loss_exp_cd tax
           FROM GICL_LOSS_EXP_TAX
          WHERE claim_id     = p_claim_id
            AND clm_loss_id  = p_clm_loss_id
            AND (loss_exp_cd = p_loss_exp_cd
              OR loss_exp_cd LIKE ''||'%'||p_loss_exp_cd||'%'||''
              OR loss_exp_cd = '0'))
      LOOP
          DELETE FROM GICL_LOSS_EXP_TAX
                WHERE claim_id    = p_claim_id
                  AND clm_loss_id = p_clm_loss_id
                  AND loss_exp_cd = dl.tax;
      END LOOP;
      
    END;
    
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.12.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Gets the list of records from GICL_LOSS_EXP_TAX 
    **                  table with the given parameters.
    */ 

    FUNCTION get_gicl_loss_exp_tax_list(p_claim_id     IN    GICL_LOSS_EXP_TAX.claim_id%TYPE,
                                        p_clm_loss_id  IN    GICL_LOSS_EXP_TAX.clm_loss_id%TYPE,
                                        p_iss_cd       IN    GICL_CLAIMS.iss_cd%TYPE )
    RETURN loss_exp_tax_tab PIPELINED IS
        
        v_tax   loss_exp_tax_type;

    BEGIN
        
        FOR i IN (SELECT a.claim_id,       a.clm_loss_id,   a.tax_id,         
                         a.tax_cd,         a.tax_type,      a.loss_exp_cd,    
                         a.base_amt,       a.user_id,       a.last_update,    
                         a.tax_amt,        a.tax_pct,       a.adv_tag,        
                         a.net_tag,        a.w_tax,         a.sl_type_cd,     
                         a.sl_cd
                  FROM GICL_LOSS_EXP_TAX a
                 WHERE a.claim_id = p_claim_id
                   AND a.clm_loss_id = p_clm_loss_id)
          
        LOOP
           v_tax.claim_id         := i.claim_id;
           v_tax.clm_loss_id      := i.clm_loss_id;
           v_tax.tax_id           := i.tax_id;
           v_tax.tax_cd           := i.tax_cd;
           v_tax.tax_type         := i.tax_type;
           v_tax.loss_exp_cd      := i.loss_exp_cd;
           v_tax.base_amt         := i.base_amt;
           v_tax.user_id          := i.user_id;
           v_tax.last_update      := i.last_update;
           v_tax.tax_amt          := i.tax_amt;
           v_tax.tax_pct          := i.tax_pct;
           v_tax.adv_tag          := i.adv_tag;
           v_tax.net_tag          := i.net_tag;
           v_tax.w_tax            := i.w_tax;
           v_tax.sl_type_cd       := i.sl_type_cd;
           v_tax.sl_cd            := i.sl_cd;
           
           FOR tax IN (SELECT tax_name
                         FROM GIIS_LOSS_TAXES
                        WHERE tax_type = i.tax_type
                         AND branch_cd = p_iss_cd
                         AND tax_cd = i.tax_cd)
           LOOP
              v_tax.tax_name  := tax.tax_name; 
           END LOOP;
           
           PIPE ROW(v_tax);
           
        END LOOP;
        
    END get_gicl_loss_exp_tax_list;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.15.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Gets the maximum tax_id from table GICL_LOSS_EXP_TAX
    **                  with the given claim_id and clm_loss_id.
    */ 

    FUNCTION get_next_tax_id(p_claim_id      IN  GICL_CLAIMS.claim_id%TYPE,
                             p_clm_loss_id   IN  GICL_CLM_LOSS_EXP.clm_loss_id%TYPE)
    RETURN NUMBER AS
        
        v_max_tax_id NUMBER(3) := 0;

    BEGIN
        FOR i IN (SELECT MAX(tax_id) max_tax_id
                    FROM GICL_LOSS_EXP_TAX
                   WHERE claim_id = p_claim_id
                     AND clm_loss_id = p_clm_loss_id)
        LOOP
            v_max_tax_id := NVL(i.max_tax_id, 0);
        END LOOP;
        
        RETURN v_max_tax_id + 1;
          
    END get_next_tax_id;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.15.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Inserts or updates record on GICL_LOSS_EXP_TAX table
    */ 

    PROCEDURE set_gicl_loss_exp_tax
    (p_claim_id     IN   GICL_CLAIMS.claim_id%TYPE,
     p_clm_loss_id  IN   GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
     p_tax_id       IN   GICL_LOSS_EXP_TAX.tax_id%TYPE,
     p_tax_cd       IN   GICL_LOSS_EXP_TAX.tax_cd%TYPE,
     p_tax_type     IN   GICL_LOSS_EXP_TAX.tax_type%TYPE,
     p_loss_exp_cd  IN   GICL_LOSS_EXP_TAX.loss_exp_cd%TYPE,
     p_base_amt     IN   GICL_LOSS_EXP_TAX.base_amt%TYPE,
     p_tax_amt      IN   GICL_LOSS_EXP_TAX.tax_amt%TYPE,
     p_tax_pct      IN   GICL_LOSS_EXP_TAX.tax_pct%TYPE,
     p_adv_tag      IN   GICL_LOSS_EXP_TAX.adv_tag%TYPE,
     p_net_tag      IN   GICL_LOSS_EXP_TAX.net_tag%TYPE,
     p_w_tax        IN   GICL_LOSS_EXP_TAX.w_tax%TYPE,
     p_sl_type_cd   IN   GICL_LOSS_EXP_TAX.sl_type_cd%TYPE,
     p_sl_cd        IN   GICL_LOSS_EXP_TAX.sl_cd%TYPE,
     p_user_id      IN   GICL_LOSS_EXP_TAX.user_id%TYPE) AS
     
    BEGIN
        MERGE INTO GICL_LOSS_EXP_TAX
          USING dual ON (claim_id = p_claim_id 
                     AND clm_loss_id = p_clm_loss_id
                     AND tax_id = p_tax_id
                     AND tax_cd = p_tax_cd
                     AND tax_type = p_tax_type)
                     
        WHEN NOT MATCHED THEN
          INSERT(claim_id,     clm_loss_id,    tax_id,       tax_cd,     tax_type,
                 loss_exp_cd,  base_amt,       tax_amt,      tax_pct,    adv_tag,
                 net_tag,      w_tax,          sl_type_cd,   sl_cd,      user_id,
                 last_update)
          VALUES(p_claim_id,    p_clm_loss_id, p_tax_id,     p_tax_cd,   p_tax_type,
                 p_loss_exp_cd, p_base_amt,    p_tax_amt,    p_tax_pct,  p_adv_tag,
                 p_net_tag,     p_w_tax,       p_sl_type_cd, p_sl_cd,    p_user_id,
                 SYSDATE)
                 
        WHEN MATCHED THEN
          UPDATE SET
              loss_exp_cd = p_loss_exp_cd,
              base_amt    = p_base_amt,       
              tax_amt     = p_tax_amt,      
              tax_pct     = p_tax_pct,    
              adv_tag     = p_adv_tag,
              net_tag     = p_net_tag,      
              w_tax       = p_w_tax,
              sl_type_cd  = p_sl_type_cd,   
              sl_cd       = p_sl_cd,
              user_id     = p_user_id,
              last_update = SYSDATE;
                       
    END set_gicl_loss_exp_tax;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.15.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Deletes records in GICL_LOSS_EXP_TAX with the
    **                  given parameters.
    */ 
        
    PROCEDURE delete_loss_exp_tax_3
    (p_claim_id    IN  GICL_LOSS_EXP_TAX.claim_id%TYPE,
     p_clm_loss_id IN  GICL_LOSS_EXP_TAX.clm_loss_id%TYPE,
     p_tax_id      IN  GICL_LOSS_EXP_TAX.tax_id%TYPE,
     p_tax_cd      IN  GICL_LOSS_EXP_TAX.tax_cd%TYPE,
     p_tax_type    IN  GICL_LOSS_EXP_TAX.tax_type%TYPE) AS

    BEGIN
            
        DELETE FROM GICL_LOSS_EXP_TAX
        WHERE claim_id = p_claim_id 
          AND clm_loss_id = p_clm_loss_id
          AND tax_id = p_tax_id
          AND tax_cd = p_tax_cd
          AND tax_type = tax_type;
              
    END delete_loss_exp_tax_3;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.15.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Update the paid_amt, net_amt, advise_amt columns 
    **                  of GICL_CLM_LOSS_EXP table. Executes KEY-COMMIT trigger
    **                  in Block C009 of GICLS030 module.
    */

    PROCEDURE gicls030_c009_key_commit
    (p_claim_id      IN     GICL_CLAIMS.claim_id%TYPE,
     p_clm_loss_id   IN     GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
     p_user_id       IN     GICL_CLM_LOSS_EXP.user_id%TYPE) AS

    v_paid_amt      GICL_CLM_LOSS_EXP.paid_amt%TYPE;
    v_net_amt       GICL_CLM_LOSS_EXP.net_amt%TYPE;
    v_advise_amt    GICL_CLM_LOSS_EXP.advise_amt%TYPE;
    v_loss_amt      GICL_CLM_LOSS_EXP.paid_amt%TYPE := 0;
    v_w_tax         GICL_LOSS_EXP_DTL.w_tax%TYPE;

    BEGIN
        
        FOR A IN (SELECT SUM(NVL(dtl_amt,0)) dtl_amt
                    FROM GICL_LOSS_EXP_DTL
                   WHERE claim_id    = p_claim_id
                     AND clm_loss_id = p_clm_loss_id)
        LOOP
           v_loss_amt := a.dtl_amt;
           EXIT;
        END LOOP;

        v_paid_amt   := v_loss_amt;
        v_net_amt    := v_loss_amt;
        v_advise_amt := v_loss_amt;
        
        FOR tax IN (SELECT a.claim_id,       a.clm_loss_id,   a.tax_id,         
                           a.tax_cd,         a.tax_type,      a.loss_exp_cd,    
                           a.base_amt,       a.user_id,       a.last_update,    
                           a.tax_amt,        a.tax_pct,       a.adv_tag,        
                           a.net_tag,        a.w_tax,         a.sl_type_cd,     
                           a.sl_cd
                     FROM GICL_LOSS_EXP_TAX a
                    WHERE a.claim_id = p_claim_id
                      AND a.clm_loss_id = p_clm_loss_id)
          
        LOOP

            FOR i IN (SELECT w_tax
                        FROM GICL_LOSS_EXP_DTL
                       WHERE claim_id = p_claim_id
                         AND clm_loss_id = p_clm_loss_id        
                         AND (loss_exp_cd = LTRIM(RTRIM(DECODE(SUBSTR(tax.loss_exp_cd,1,2), '0-',SUBSTR(tax.loss_exp_cd,3), tax.loss_exp_cd))) OR
                              loss_exp_cd = DECODE(tax.loss_exp_cd,'0',loss_exp_cd,'0')))  
            LOOP
                v_w_tax := i.w_tax;
              IF i.w_tax = 'Y' THEN
                 EXIT;
              END IF;
            END LOOP;
                          
            IF tax.tax_type = 'I' AND v_w_tax = 'Y' THEN
               v_net_amt    := NVL(v_net_amt,0) - NVL(tax.tax_amt,0);
               v_advise_amt := NVL(v_advise_amt,0) - NVL(tax.tax_amt,0);
                   
            ELSIF tax.tax_type IN ('I','O') THEN
               
               IF NVL(tax.w_tax,'N') = 'N' AND tax.tax_amt > 0 THEN
                  
                  IF NVL(tax.net_tag,'N') = 'N' THEN
                     v_paid_amt := NVL(v_paid_amt,0) + NVL(tax.tax_amt,0);
                  END IF;
                  
               ELSIF NVL(tax.w_tax,'N') = 'Y' AND tax.tax_amt > 0 THEN
                  
                  IF NVL(tax.net_tag,'N') = 'Y' THEN
                     v_net_amt := NVL(v_net_amt,0) - NVL(tax.tax_amt,0);
                  END IF;
                  
               END IF;
               
               IF tax.adv_tag = 'Y' THEN
                  v_advise_amt := NVL(v_advise_amt,0) - NVL(tax.tax_amt,0);
               END IF;
                         
            ELSIF tax.tax_type = 'W' THEN

               IF tax.net_tag = 'Y' THEN
                  v_paid_amt := NVL(v_paid_amt,0) - NVL(tax.tax_amt,0);
               END IF;
               
               IF tax.adv_tag = 'Y' THEN
                  v_advise_amt := NVL(v_advise_amt,0) - NVL(tax.tax_amt,0);
               END IF;
               
            END IF;
        
        END LOOP;
        
        GICL_CLM_LOSS_EXP_PKG.update_clm_loss_exp_amts(p_claim_id, p_clm_loss_id, v_advise_amt, v_paid_amt, v_net_amt, p_user_id);
        
    END gicls030_c009_key_commit;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.30.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Check if loss expense deductible 
    **                  record has tax/es.
    */ 
       
    FUNCTION get_count_loss_exp_tax_2 
        (p_claim_id         IN   GICL_LOSS_EXP_TAX.claim_id%TYPE,
         p_clm_loss_id      IN   GICL_LOSS_EXP_TAX.clm_loss_id%TYPE,
         p_ded_loss_exp_cd  IN   GICL_LOSS_EXP_DTL.ded_loss_exp_cd%TYPE)
         
    RETURN NUMBER AS
        
        v_cnt          NUMBER(5) := 0;

    BEGIN
        IF p_ded_loss_exp_cd = '%ALL%' THEN
             FOR ded IN
               (SELECT loss_exp_cd cd
                  FROM GICL_LOSS_EXP_DTL
                 WHERE claim_id        = p_claim_id
                   AND clm_loss_id     = p_clm_loss_id
                   AND ded_loss_exp_cd IS NULL)
             LOOP
               FOR m IN
                (SELECT COUNT(*) cnt 
                   FROM GICL_LOSS_EXP_TAX
                  WHERE claim_id     = p_claim_id
                    AND clm_loss_id  = p_clm_loss_id
                    AND (loss_exp_cd LIKE ''||'%'||ded.cd||'%'||''
                      OR loss_exp_cd = '0'))
               LOOP
                 v_cnt := v_cnt + NVL(m.cnt,0);
               END LOOP;
             END LOOP;
        ELSE
             FOR m IN
               (SELECT COUNT(*) cnt 
                  FROM GICL_LOSS_EXP_TAX
                 WHERE claim_id     = p_claim_id
                   AND clm_loss_id  = p_clm_loss_id
                   AND (loss_exp_cd LIKE ''||'%'||p_ded_loss_exp_cd||'%'||''
                     OR loss_exp_cd = '0'))
             LOOP
               v_cnt := v_cnt + NVL(m.cnt,0);
             END LOOP;
        END IF;
             
        RETURN v_cnt;
           
    END get_count_loss_exp_tax_2;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 04.02.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Delete record from gicl_loss_exp_tax 
    **                  if detail has tax/es
    */ 
           
    PROCEDURE delete_loss_exp_tax_4
    (p_claim_id         IN  GICL_LOSS_EXP_TAX.claim_id%TYPE,
     p_clm_loss_id      IN  GICL_LOSS_EXP_TAX.clm_loss_id%TYPE,
     p_ded_loss_exp_cd  IN  GICL_LOSS_EXP_DTL.ded_loss_exp_cd%TYPE) AS
     
     v_cnt          NUMBER(5);          -- determines if record has taxes
     
     BEGIN
        
        v_cnt := GICL_LOSS_EXP_TAX_PKG.get_count_loss_exp_tax_2(p_claim_id, p_clm_loss_id, p_ded_loss_exp_cd);
        
        IF v_cnt > 0 THEN
           
           IF p_ded_loss_exp_cd = '%ALL%' THEN
              FOR ded IN
                 (SELECT loss_exp_cd cd
                    FROM GICL_LOSS_EXP_DTL
                   WHERE claim_id        = p_claim_id
                     AND clm_loss_id     = p_clm_loss_id
                     AND ded_loss_exp_cd IS NULL)
              LOOP
                 DELETE FROM GICL_LOSS_EXP_TAX
                       WHERE claim_id     = p_claim_id
                         AND clm_loss_id  = p_clm_loss_id
                         AND (loss_exp_cd LIKE ''||'%'||ded.cd||'%'||''
                          OR loss_exp_cd = '0');
              END LOOP;
              
           ELSE
                 DELETE FROM GICL_LOSS_EXP_TAX
                    WHERE claim_id     = p_claim_id
                      AND clm_loss_id  = p_clm_loss_id
                      AND (loss_exp_cd LIKE ''||'%'||p_ded_loss_exp_cd||'%'||''
                       OR loss_exp_cd = '0');
           END IF;
                 
         END IF;
        
     END delete_loss_exp_tax_4;
     
     /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 04.02.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Check if loss expense deductible 
    **                  record has tax/es.
    */ 
           
    FUNCTION get_count_loss_exp_tax_3 
    (p_claim_id         IN   GICL_LOSS_EXP_TAX.claim_id%TYPE,
     p_clm_loss_id      IN   GICL_LOSS_EXP_TAX.clm_loss_id%TYPE,
     p_loss_exp_cd      IN   GICL_LOSS_EXP_DTL.loss_exp_cd%TYPE,
     p_ded_loss_exp_cd  IN   GICL_LOSS_EXP_DTL.ded_loss_exp_cd%TYPE)
             
    RETURN NUMBER AS
            
        v_cnt          NUMBER(5) := 0;

    BEGIN
        IF p_ded_loss_exp_cd = '%ALL%' THEN
              
          FOR ded IN (SELECT loss_exp_cd cd
                        FROM GICL_LOSS_EXP_DTL
                       WHERE claim_id        = p_claim_id
                         AND clm_loss_id     = p_clm_loss_id
                         AND ded_loss_exp_cd IS NULL)
          LOOP
            FOR m IN (SELECT COUNT(*) cnt 
                        FROM GICL_LOSS_EXP_TAX
                       WHERE claim_id     = p_claim_id
                         AND clm_loss_id  = p_clm_loss_id
                         AND (loss_exp_cd LIKE ''||'%'||ded.cd||'%'||''
                          OR loss_exp_cd = '0'
                          OR loss_exp_cd LIKE ''||'%'||p_loss_exp_cd||'%'||''))
            LOOP
              v_cnt := v_cnt + NVL(m.cnt,0);
            END LOOP;
          END LOOP;
       ELSE
          FOR m IN (SELECT COUNT(*) cnt 
                      FROM GICL_LOSS_EXP_TAX
                     WHERE claim_id     = p_claim_id
                       AND clm_loss_id  = p_clm_loss_id
                       AND (loss_exp_cd LIKE ''||'%'||p_ded_loss_exp_cd||'%'||''
                         OR loss_exp_cd = '0'
                         OR loss_exp_cd LIKE ''||'%'||p_loss_exp_cd||'%'||''))
          LOOP
            v_cnt := NVL(m.cnt,0);
          END LOOP;
       END IF;
                 
       RETURN v_cnt;
               
    END get_count_loss_exp_tax_3;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 04.02.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Delete record from gicl_loss_exp_tax 
    **                  if detail has tax/es
    */ 
           
    PROCEDURE delete_loss_exp_tax_5
    (p_claim_id         IN  GICL_LOSS_EXP_TAX.claim_id%TYPE,
     p_clm_loss_id      IN  GICL_LOSS_EXP_TAX.clm_loss_id%TYPE,
     p_loss_exp_cd      IN  GICL_LOSS_EXP_DTL.loss_exp_cd%TYPE,
     p_ded_loss_exp_cd  IN  GICL_LOSS_EXP_DTL.ded_loss_exp_cd%TYPE) AS
     
     v_cnt          NUMBER(5);          -- determines if record has taxes
     
     BEGIN
        
        v_cnt := GICL_LOSS_EXP_TAX_PKG.get_count_loss_exp_tax_3(p_claim_id, p_clm_loss_id, p_loss_exp_cd, p_ded_loss_exp_cd);
        
        IF v_cnt > 0 THEN
           
           IF p_ded_loss_exp_cd = '%ALL%' THEN
               FOR ded IN
                 (SELECT loss_exp_cd cd
                    FROM GICL_LOSS_EXP_DTL
                   WHERE claim_id        = p_claim_id
                     AND clm_loss_id     = p_clm_loss_id
                     AND ded_loss_exp_cd IS NULL)
               LOOP
                 DELETE FROM GICL_LOSS_EXP_TAX
                       WHERE claim_id     = p_claim_id
                         AND clm_loss_id  = p_clm_loss_id
                         AND (loss_exp_cd LIKE ''||'%'||ded.cd||'%'||''
                           OR loss_exp_cd = '0'
                           OR loss_exp_cd LIKE ''||'%'||p_loss_exp_cd||'%'||'');
               END LOOP;
           ELSE
               DELETE FROM GICL_LOSS_EXP_TAX
                     WHERE claim_id     = p_claim_id
                       AND clm_loss_id  = p_clm_loss_id
                       AND (loss_exp_cd LIKE ''||'%'||p_ded_loss_exp_cd||'%'||''
                         OR loss_exp_cd = '0'
                         OR loss_exp_cd LIKE ''||'%'||p_loss_exp_cd||'%'||'');
            END IF;
                 
         END IF;
        
     END delete_loss_exp_tax_5;
     
     FUNCTION check_loss_exp_tax_type(
      p_claim_id IN gicl_loss_exp_tax.claim_id%TYPE,
      p_clm_loss_id IN gicl_loss_exp_tax.clm_loss_id%TYPE
     )
        RETURN NUMBER
     AS
        v_cnt   NUMBER (5) := 0;
     BEGIN
        FOR tax IN (SELECT loss_exp_cd
                      FROM gicl_loss_exp_dtl
                     WHERE claim_id = p_claim_id AND clm_loss_id = p_clm_loss_id)
        LOOP
           BEGIN
              SELECT 1
                INTO v_cnt
                FROM gicl_loss_exp_tax
               WHERE claim_id = p_claim_id AND clm_loss_id = p_clm_loss_id AND (/*loss_exp_cd = tax.loss_exp_cd OR*/ loss_exp_cd = '0') AND tax_type = 'I';
           EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 v_cnt := 0;
           END;
           
           IF v_cnt = 1
           THEN
            EXIT;
           END IF;
           
        END LOOP;

        RETURN v_cnt;
     END check_loss_exp_tax_type;

END GICL_LOSS_EXP_TAX_PKG;
/


DROP PUBLIC SYNONYM GICL_LOSS_EXP_TAX_PKG;

CREATE PUBLIC SYNONYM GICL_LOSS_EXP_TAX_PKG FOR CPI.GICL_LOSS_EXP_TAX_PKG;


