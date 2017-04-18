CREATE OR REPLACE PACKAGE BODY CPI.GICL_LOSS_EXP_DED_DTL_PKG AS
    
   /*
   **  Created by    : Veronica V. Raymundo
   **  Date Created  : 02.14.2012
   **  Reference By  : GICLS030 - Loss/Expense History
   **  Description   : Check if record has deductible/s.
   */ 
    FUNCTION check_exist_loss_exp_ded_dtl
        (p_claim_id     IN  GICL_LOSS_EXP_DED_DTL.claim_id%TYPE,
         p_clm_loss_id  IN  GICL_LOSS_EXP_DED_DTL.clm_loss_id%TYPE,
         p_loss_exp_cd  IN  GICL_LOSS_EXP_DED_DTL.loss_exp_cd%TYPE )
    
    RETURN VARCHAR2 AS
    
    v_exist     VARCHAR2(1) := 'N';
    
    BEGIN
        FOR ded IN (SELECT 'Y' exist
                    FROM GICL_LOSS_EXP_DED_DTL
                   WHERE claim_id    = p_claim_id
                     AND clm_loss_id = p_clm_loss_id
                     AND ded_cd      = p_loss_exp_cd)
        LOOP
        v_exist := ded.exist;
        EXIT;
        END LOOP;
        
        RETURN v_exist;
        
    END check_exist_loss_exp_ded_dtl;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 02.16.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Delete records in GICL_LOSS_EXP_DED_DTL table
    */ 

    PROCEDURE delete_loss_exp_ded_dtl
        (p_claim_id     IN  GICL_CLAIMS.claim_id%TYPE,
         p_clm_loss_id  IN  GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
         p_loss_exp_cd  IN  GICL_LOSS_EXP_DED_DTL.loss_exp_cd%TYPE) AS

    BEGIN
         
      DELETE FROM GICL_LOSS_EXP_DED_DTL
       WHERE claim_id    = p_claim_id
         AND clm_loss_id = p_clm_loss_id
         AND loss_exp_cd = p_loss_exp_cd;
      
    END delete_loss_exp_ded_dtl;
    
   /*
   **  Created by    : Veronica V. Raymundo
   **  Date Created  : 03.05.2012
   **  Reference By  : GICLS030 - Loss/Expense History
   **  Description   : Gets the list of records from GICL_LOSS_EXP_DED_DTL
   **                  table with the given parameters.
   */ 
    
    FUNCTION get_gicl_loss_exp_ded_dtl_list
    (p_claim_id     IN   GICL_LOSS_EXP_DED_DTL.claim_id%TYPE,
     p_clm_loss_id  IN   GICL_LOSS_EXP_DED_DTL.clm_loss_id%TYPE,
     p_loss_exp_cd  IN   GICL_LOSS_EXP_DED_DTL.loss_exp_cd%TYPE,
     p_line_cd      IN   GICL_CLAIMS.line_cd%TYPE,
     p_subline_cd   IN   GICL_LOSS_EXP_DTL.subline_cd%TYPE,
     p_payee_type   IN   GICL_LOSS_EXP_PAYEES.payee_type%TYPE)
        
    RETURN gicl_loss_exp_ded_dtl_tab PIPELINED IS
        v_ded_dtl       gicl_loss_exp_ded_dtl_type;
    BEGIN
        FOR i IN(SELECT a.claim_id,      a.clm_loss_id,      a.line_cd,        
                        a.subline_cd,    a.loss_exp_type,    a.loss_exp_cd,   
                        a.loss_amt,      a.ded_cd,           a.ded_amt,    
                        a.ded_rate,      a.user_id,          a.last_update,  
                        a.aggregate_sw,  a.ceiling_sw,       a.min_amt,        
                        a.max_amt,       a.range_sw
                   FROM GICL_LOSS_EXP_DED_DTL a
                   WHERE a.claim_id = p_claim_id
                     AND a.clm_loss_id = p_clm_loss_id
                     AND a.loss_exp_cd = p_loss_exp_cd)
        LOOP
            v_ded_dtl.claim_id          := i.claim_id;      
            v_ded_dtl.clm_loss_id       := i.clm_loss_id;
            v_ded_dtl.line_cd           := i.line_cd;
            v_ded_dtl.subline_cd        := i.subline_cd;
            v_ded_dtl.loss_exp_type     := i.loss_exp_type;
            v_ded_dtl.loss_exp_cd       := i.loss_exp_cd;
            v_ded_dtl.dsp_exp_desc      := '';
            v_ded_dtl.loss_amt          := i.loss_amt;
            v_ded_dtl.ded_cd            := i.ded_cd;
            v_ded_dtl.dsp_ded_desc      := '';
            v_ded_dtl.ded_amt           := i.ded_amt;
            v_ded_dtl.ded_rate          := i.ded_rate;
            v_ded_dtl.user_id           := i.user_id;
            v_ded_dtl.last_update       := i.last_update;
            v_ded_dtl.aggregate_sw      := i.aggregate_sw;
            v_ded_dtl.ceiling_sw        := i.ceiling_sw;
            v_ded_dtl.min_amt           := i.min_amt;
            v_ded_dtl.max_amt           := i.max_amt;
            v_ded_dtl.range_sw          := i.range_sw;
            
            FOR expd IN
                (SELECT loss_exp_desc des
                   FROM GIIS_LOSS_EXP
                  WHERE loss_exp_type = p_payee_type
                    AND line_cd       = p_line_cd
                    AND loss_exp_cd   = p_loss_exp_cd
                    AND NVL(subline_cd, 'XXX') = NVL(p_subline_cd,'XXX'))
            LOOP
                v_ded_dtl.dsp_exp_desc := expd.des;
                EXIT;
            END LOOP;
            
            FOR le IN
                (SELECT a.loss_exp_desc des
                   FROM GIIS_LOSS_EXP a, GICL_LOSS_EXP_DED_DTL b
                  WHERE a.loss_exp_cd   = b.ded_cd
                    AND b.ded_cd        = i.ded_cd
                    AND b.claim_id      = p_claim_id
                    AND b.clm_loss_id   = p_clm_loss_id
                    AND a.line_cd       = b.line_cd
                    AND a.loss_exp_type = b.loss_exp_type
                    AND NVL(a.comp_sw, '+') = '+')
            LOOP
                v_ded_dtl.dsp_ded_desc := le.des;
            END LOOP;
            
            PIPE ROW(v_ded_dtl);
              
        END LOOP;
    END get_gicl_loss_exp_ded_dtl_list;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.07.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Delete records in GICL_LOSS_EXP_DED_DTL table
    **                  as well as the corresponding records in GICL_LOSS_EXP_DTL 
    */ 

    PROCEDURE delete_loss_exp_ded_dtl_2
     (p_claim_id     IN  GICL_CLAIMS.claim_id%TYPE,
      p_clm_loss_id  IN  GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
      p_loss_exp_cd  IN  GICL_LOSS_EXP_DED_DTL.loss_exp_cd%TYPE) AS

    v_loss_ded_cd  GICL_LOSS_EXP_DTL.loss_exp_cd%TYPE;
             
    BEGIN
        FOR ddtl IN
         (SELECT loss_exp_cd cd
            FROM GICL_LOSS_EXP_DED_DTL
           WHERE claim_id    = p_claim_id
             AND clm_loss_id = p_clm_loss_id
             AND ded_cd      = p_loss_exp_cd)
        
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
    END delete_loss_exp_ded_dtl_2;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.30.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Insert records in GICL_LOSS_EXP_DED_DTL table
    **                  for deductibles with ded_loss_exp_cd equals to '%ALL%' 
    */ 

    PROCEDURE insert_le_ded_dtl_for_all
    (p_claim_id         IN  GICL_CLAIMS.claim_id%TYPE,
     p_clm_loss_id      IN  GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
     p_line_cd          IN  GICL_CLAIMS.line_cd%TYPE,
     p_subline_cd       IN  GICL_LOSS_EXP_DTL.subline_cd%TYPE,
     p_payee_type       IN  GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
     p_loss_exp_cd      IN  GICL_LOSS_EXP_DTL.loss_exp_cd%TYPE,
     p_dtl_amt          IN  GICL_LOSS_EXP_DTL.dtl_amt%TYPE,
     p_ded_rate         IN  GICL_LOSS_EXP_DTL.ded_rate%TYPE,
     p_ded_aggregate_sw IN  GIPI_DEDUCTIBLES.aggregate_sw%TYPE,
     p_nbt_ceiling_sw   IN  GIPI_DEDUCTIBLES.ceiling_sw%TYPE,
     p_nbt_min_amt      IN  GIPI_DEDUCTIBLES.min_amt%TYPE,
     p_nbt_max_amt      IN  GIPI_DEDUCTIBLES.max_amt%TYPE,
     p_nbt_range_sw     IN  GIPI_DEDUCTIBLES.range_sw%TYPE,
     p_user_id          IN  GIIS_USERS.user_id%TYPE) AS
     
     v_le_cd           GICL_LOSS_EXP_DTL.loss_exp_cd%TYPE; 
     v_dtl_amt         GICL_LOSS_EXP_DTL.dtl_amt%TYPE := 0;
     v_tot_dtl_amt     GICL_LOSS_EXP_DTL.dtl_amt%TYPE := 0;
     v_ded_amt         GICL_LOSS_EXP_DTL.dtl_amt%TYPE := 0;


    BEGIN
        FOR tot IN (SELECT SUM(a.dtl_amt) dtl_amt
                      FROM GICL_LOSS_EXP_DTL a, 
                           GIIS_LOSS_EXP b
                     WHERE a.claim_id         = p_claim_id
                       AND a.clm_loss_id      = p_clm_loss_id
                       AND a.loss_exp_cd      = b.loss_exp_cd
                       AND a.line_cd          = b.line_cd
                       AND a.loss_exp_type    = b.loss_exp_type
                       AND NVL(b.comp_sw,'+') = '+'
                       AND a.subline_cd       IS NULL)
        LOOP
          v_tot_dtl_amt := tot.dtl_amt;
          EXIT;
        END LOOP;
          
        FOR ded IN (SELECT a.loss_exp_cd le_cd, a.dtl_amt amt
                      FROM GICL_LOSS_EXP_DTL a, 
                           GIIS_LOSS_EXP b
                     WHERE a.claim_id         = p_claim_id
                       AND a.clm_loss_id      = p_clm_loss_id
                       AND a.loss_exp_cd      = b.loss_exp_cd
                       AND a.line_cd          = b.line_cd
                       AND a.loss_exp_type    = b.loss_exp_type
                       AND NVL(b.comp_sw,'+') = '+'
                       AND a.subline_cd       IS NULL)
        LOOP
          v_le_cd       := ded.le_cd;
          v_dtl_amt     := ded.amt;
          v_ded_amt := ((v_dtl_amt/v_tot_dtl_amt) * p_dtl_amt);
                  
          INSERT INTO GICL_LOSS_EXP_DED_DTL
             (claim_id,           clm_loss_id,      line_cd,    subline_cd,
              loss_exp_type,      loss_exp_cd,      loss_amt,   ded_cd,
              ded_amt,            ded_rate,         user_id,    last_update,
              aggregate_sw,       ceiling_sw,       min_amt,    max_amt,    range_sw)
          VALUES 
             (p_claim_id,         p_clm_loss_id,    p_line_cd,  p_subline_cd,
              p_payee_type,       p_loss_exp_cd,    v_dtl_amt,  v_le_cd,
              v_ded_amt,          p_ded_rate,       p_user_id,  SYSDATE,
              p_ded_aggregate_sw, p_nbt_ceiling_sw, p_nbt_min_amt,
              p_nbt_max_amt,      p_nbt_range_sw);
              
        END LOOP;
        
    END insert_le_ded_dtl_for_all;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.30.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Insert records in GICL_LOSS_EXP_DED_DTL table
    **                  for deductibles with ded_loss_exp_cd not equal to'%ALL%' 
    */ 

    PROCEDURE insert_le_ded_dtl_not_for_all
    (p_claim_id         IN  GICL_CLAIMS.claim_id%TYPE,
     p_clm_loss_id      IN  GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
     p_line_cd          IN  GICL_CLAIMS.line_cd%TYPE,
     p_subline_cd       IN  GICL_LOSS_EXP_DTL.subline_cd%TYPE,
     p_payee_type       IN  GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
     p_loss_exp_cd      IN  GICL_LOSS_EXP_DTL.loss_exp_cd%TYPE,
     p_ded_loss_exp_cd  IN  GICL_LOSS_EXP_DTL.ded_loss_exp_cd%TYPE,
     p_dtl_amt          IN  GICL_LOSS_EXP_DTL.dtl_amt%TYPE,
     p_ded_rate         IN  GICL_LOSS_EXP_DTL.ded_rate%TYPE,
     p_ded_aggregate_sw IN  GIPI_DEDUCTIBLES.aggregate_sw%TYPE,
     p_nbt_ceiling_sw   IN  GIPI_DEDUCTIBLES.ceiling_sw%TYPE,
     p_nbt_min_amt      IN  GIPI_DEDUCTIBLES.min_amt%TYPE,
     p_nbt_max_amt      IN  GIPI_DEDUCTIBLES.max_amt%TYPE,
     p_nbt_range_sw     IN  GIPI_DEDUCTIBLES.range_sw%TYPE,
     p_user_id          IN  GIIS_USERS.user_id%TYPE) AS
     
     v_ded_amt         GICL_LOSS_EXP_DTL.dtl_amt%TYPE := 0;

    BEGIN
        FOR ded IN (SELECT a.dtl_amt amt
                      FROM GICL_LOSS_EXP_DTL a, 
                           GIIS_LOSS_EXP b
                     WHERE a.claim_id         = p_claim_id
                       AND a.clm_loss_id      = p_clm_loss_id
                       AND a.loss_exp_cd      = p_ded_loss_exp_cd
                       AND a.loss_exp_cd      = b.loss_exp_cd
                       AND a.line_cd          = b.line_cd
                       AND a.loss_exp_type    = b.loss_exp_type
                       AND NVL(b.comp_sw,'+') = '+'
                       AND a.subline_cd IS NULL)
        LOOP
          v_ded_amt := ded.amt;
          EXIT;
        END LOOP;
            
        INSERT INTO GICL_LOSS_EXP_DED_DTL
           (claim_id,           clm_loss_id,        line_cd,        subline_cd,
            loss_exp_type,      loss_exp_cd,        loss_amt,       ded_cd,
            ded_amt,            ded_rate,           user_id,        last_update,
            aggregate_sw,       ceiling_sw,         min_amt,        max_amt,        range_sw)
         VALUES 
           (p_claim_id,         p_clm_loss_id,      p_line_cd,      p_subline_cd,
            p_payee_type,       p_loss_exp_cd,      v_ded_amt,      p_ded_loss_exp_cd,
            p_dtl_amt,          p_ded_rate,         p_user_id,      SYSDATE,
            p_ded_aggregate_sw, p_nbt_ceiling_sw,   p_nbt_min_amt,  p_nbt_max_amt, p_nbt_range_sw);
        
    END insert_le_ded_dtl_not_for_all;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.30.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Compares the number of records found in GICL_LOSS_EXP_DED_DTL 
    **                  and GICL_LOSS_EXP_DTL. If not equal, excess/unmatched records
    **                  will be deleted. 
    */ 

    PROCEDURE delete_excess_loss_exp_ded_dtl
    (p_claim_id     IN   GICL_CLAIMS.claim_id%TYPE,
     p_clm_loss_id  IN   GICL_CLM_LOSS_EXP.clm_loss_id%TYPE) AS
     
    v_cnt1            NUMBER(8) := 0;
    v_cnt2            NUMBER(8) := 0;

    BEGIN
        SELECT COUNT(1)
        INTO v_cnt1
        FROM GICL_LOSS_EXP_DED_DTL
       WHERE claim_id    = p_claim_id
         AND clm_loss_id = p_clm_loss_id;
         
      SELECT COUNT(1)
        INTO v_cnt2
        FROM GICL_LOSS_EXP_DTL
       WHERE claim_id        = p_claim_id
         AND clm_loss_id     = p_clm_loss_id
         AND ded_loss_exp_cd IS NOT NULL
         AND ded_loss_exp_cd != '%ALL%';
         
      IF v_cnt1 != v_cnt2 AND (v_cnt1-v_cnt2) < 2 THEN
           FOR a IN(SELECT claim_id, clm_loss_id, loss_exp_cd, ded_cd
                      FROM GICL_LOSS_EXP_DED_DTL 
                     WHERE claim_id    = p_claim_id
                       AND clm_loss_id = p_clm_loss_id
                       AND (claim_id, clm_loss_id, loss_exp_cd, ded_cd) NOT IN(
                              SELECT claim_id, clm_loss_id, loss_exp_cd, ded_loss_exp_cd
                                FROM GICL_LOSS_EXP_DTL
                               WHERE claim_id        = p_claim_id
                                 AND clm_loss_id     = p_clm_loss_id
                                 AND ded_loss_exp_cd IS NOT NULL
                                 AND ded_loss_exp_cd != '%ALL%'))
           LOOP
           
             DELETE FROM GICL_LOSS_EXP_DED_DTL
              WHERE claim_id = a.claim_id
                AND clm_loss_id = a.clm_loss_id
                AND loss_exp_cd = a.loss_exp_cd
                AND ded_cd = a.ded_cd;
           
           END LOOP;
           
      END IF;
      
    END delete_excess_loss_exp_ded_dtl;
      
END;
/


