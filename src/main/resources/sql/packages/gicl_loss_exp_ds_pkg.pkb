CREATE OR REPLACE PACKAGE BODY CPI.GICL_LOSS_EXP_DS_PKG AS

   /*
   **  Created by    : Veronica V. Raymundo
   **  Date Created  : 01.19.2012
   **  Reference By  : GICLS030 - Loss/Expense History
   **  Description   : Gets the list of gicl_loss_exp_ds
   */ 
   
    FUNCTION get_gicl_loss_exp_ds(p_claim_id        GICL_LOSS_EXP_DS.claim_id%TYPE,
                                  p_clm_loss_id     GICL_LOSS_EXP_DS.clm_loss_id%TYPE)
    RETURN gicl_loss_exp_ds_tab PIPELINED AS
    
    v_gileds        gicl_loss_exp_ds_type;
    
    BEGIN
        FOR i IN (SELECT  a.claim_id,          a.clm_loss_id,        a.clm_dist_no,      
                          a.dist_year,         a.item_no,            a.peril_cd,         
                          a.payee_cd,          a.grp_seq_no,         a.line_cd,           
                          a.user_id,           a.last_update,        a.acct_trty_type,   
                          a.shr_loss_exp_pct,  a.shr_le_pd_amt,      a.shr_le_adv_amt,    
                          a.shr_le_net_amt,    a.share_type,         a.negate_tag,         
                          a.distribution_date, a.grouped_item_no,    a.xol_ded,
                          b.trty_name   
                    FROM GICL_LOSS_EXP_DS a,
                         GIIS_DIST_SHARE b
                    WHERE a.claim_id = p_claim_id
                      AND a.clm_loss_id = p_clm_loss_id
                      AND NVL(a.negate_tag, 'N') <> 'Y'
                      AND b.line_cd  = a.line_cd
                      AND b.share_cd = a.grp_seq_no
                    ORDER BY dist_year DESC, share_type)
        
        LOOP
            v_gileds.claim_id           :=  i.claim_id;                   
            v_gileds.clm_loss_id        :=  i.clm_loss_id;     
            v_gileds.clm_dist_no        :=  i.clm_dist_no;   
            v_gileds.dist_year          :=  i.dist_year;    
            v_gileds.item_no            :=  i.item_no;     
            v_gileds.peril_cd           :=  i.peril_cd;
            v_gileds.payee_cd           :=  i.payee_cd;    
            v_gileds.grp_seq_no         :=  i.grp_seq_no;    
            v_gileds.line_cd            :=  i.line_cd;    
            v_gileds.user_id            :=  i.user_id;     
            v_gileds.last_update        :=  i.last_update;    
            v_gileds.acct_trty_type     :=  i.acct_trty_type;     
            v_gileds.shr_loss_exp_pct   :=  to_char(i.shr_loss_exp_pct,'fm990.00'); --added by robert 11.25.2013     
            v_gileds.shr_le_pd_amt      :=  i.shr_le_pd_amt;    
            v_gileds.shr_le_adv_amt     :=  i.shr_le_adv_amt;     
            v_gileds.shr_le_net_amt     :=  i.shr_le_net_amt;     
            v_gileds.share_type         :=  i.share_type;     
            v_gileds.negate_tag         :=  i.negate_tag;    
            v_gileds.distribution_date  :=  i.distribution_date;     
            v_gileds.grouped_item_no    :=  i.grouped_item_no;     
            v_gileds.xol_ded            :=  i.xol_ded;     
            v_gileds.trty_name          :=  i.trty_name;
            
            PIPE ROW(v_gileds);
                           
        END LOOP;
    END;
    
   /*
   **  Created by    : Veronica V. Raymundo
   **  Date Created  : 02.08.2012
   **  Reference By  : GICLS030 - Loss/Expense History
   **  Description   : Checks if record exist in GICL_LOSS_EXP_DS 
   **                  with the given parameters.
   */ 
   
    FUNCTION check_exist_gicl_loss_exp_ds
    (p_claim_id     IN   GICL_LOSS_EXP_DS.claim_id%TYPE,
     p_clm_loss_id  IN   GICL_LOSS_EXP_DS.clm_loss_id%TYPE)
     
     RETURN VARCHAR2 AS
     
     v_exist    VARCHAR2(1) := 'N';
     
    BEGIN
        FOR i IN (SELECT 1 FROM GICL_LOSS_EXP_DS     
                   WHERE claim_id = p_claim_id 
                     AND clm_loss_id = p_clm_loss_id)
        LOOP
            v_exist := 'Y';
        END LOOP;
        
        RETURN v_exist;
    END;
    
    /*
   **  Created by    : Veronica V. Raymundo
   **  Date Created  : 02.08.2012
   **  Reference By  : GICLS030 - Loss/Expense History
   **  Description   : Checks if record exist in GICL_LOSS_EXP_DS 
   **                  with the given parameters which is not negated.
   */ 
   
    FUNCTION check_loss_exp_ds_not_negated
    (p_claim_id     IN   GICL_LOSS_EXP_DS.claim_id%TYPE,
     p_clm_loss_id  IN   GICL_LOSS_EXP_DS.clm_loss_id%TYPE)
     
     RETURN VARCHAR2 AS
     
     v_exist    VARCHAR2(1) := 'N';
     
    BEGIN
        FOR i IN (SELECT 1 FROM GICL_LOSS_EXP_DS     
                   WHERE claim_id = p_claim_id 
                     AND clm_loss_id = p_clm_loss_id
                     AND NVL(negate_tag, 'N') <>'Y')
        LOOP
            v_exist := 'Y';
        END LOOP;
        
        RETURN v_exist;
    END;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 02.28.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Gets the maximum clm_dist_no from GICL_LOSS_EXP_DS
    **                  with the given claim_id and clm_loss_id
    */ 


    FUNCTION get_max_clm_dist_no
    (p_claim_id     IN   GICL_CLM_LOSS_EXP.claim_id%TYPE,
     p_clm_loss_id  IN   GICL_CLM_LOSS_EXP.clm_loss_id%TYPE)
     
    RETURN NUMBER AS
        clm_dist_no         GICL_LOSS_EXP_DS.clm_dist_no%TYPE := 0;

    BEGIN
       
       BEGIN
          SELECT MAX (clm_dist_no)
            INTO clm_dist_no
            FROM GICL_LOSS_EXP_DS
           WHERE claim_id = p_claim_id 
             AND clm_loss_id = p_clm_loss_id;
       EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
             clm_dist_no := 0;
             RETURN clm_dist_no;
       END;
       
       RETURN clm_dist_no;
       
    END get_max_clm_dist_no; 

END GICL_LOSS_EXP_DS_PKG;
/


