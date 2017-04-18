CREATE OR REPLACE PACKAGE BODY CPI.gicl_clm_adj_hist_pkg
AS 
        
   /*
   **  Created by    : Jerome Orio 
   **  Date Created  : 11.04.2011
   **  Reference By  : (GICLS010 - Basic Information - adjuster)
   **  Description   : check if gicl_clm_adj_hist exist 
   */        
    FUNCTION get_gicl_clm_adj_hist_exist( 
        p_claim_id          gicl_clm_adj_hist.claim_id%TYPE
        ) RETURN VARCHAR2 IS
      v_exists      varchar2(1) := 'N';
    BEGIN
      FOR h IN (SELECT DISTINCT 'X'
                  FROM gicl_clm_adj_hist
                 WHERE claim_id = p_claim_id) 
      LOOP
          v_exists := 'Y';
          EXIT;
      END LOOP;
    RETURN v_exists;
    END;    
    
   /*
   **  Created by    : Jerome Orio 
   **  Date Created  : 11.04.2011
   **  Reference By  : (GICLS010 - Basic Information - adjuster)
   **  Description   :  get cancel date 
   */        
    FUNCTION get_cancel_date( 
        p_adj_company_cd          gicl_clm_adj_hist.adj_company_cd%TYPE
        ) RETURN VARCHAR2 IS
      v_cancel_date      VARCHAR2(100) := '';
    BEGIN
      	FOR i IN(SELECT TO_CHAR(cancel_date, 'MM-DD-RRRR') cancel_date 
                   FROM gicl_clm_adj_hist 
                  WHERE last_update = (SELECT MAX(last_update)
                                         FROM gicl_clm_adj_hist
                                        WHERE cancel_date IS NOT NULL
                                          AND adj_company_cd = p_adj_company_cd))
        LOOP
          v_cancel_date := i.cancel_date;
          EXIT;
        END LOOP;                                  	
      RETURN v_cancel_date;
    END;     
        
   /*
   **  Created by    : Jerome Orio 
   **  Date Created  : 11.09.2011
   **  Reference By  : (GICLS010 - Basic Information - adjuster)
   **  Description   :  insert clm adjuster history 
   */      
    PROCEDURE set_gicl_clm_adj_hist(
        p_adj_hist_no     	gicl_clm_adj_hist.adj_hist_no%TYPE,
        p_clm_adj_id      	gicl_clm_adj_hist.clm_adj_id%TYPE,
        p_claim_id        	gicl_clm_adj_hist.claim_id%TYPE,
        p_adj_company_cd  	gicl_clm_adj_hist.adj_company_cd%TYPE,
        p_priv_adj_cd     	gicl_clm_adj_hist.priv_adj_cd%TYPE,
        p_assign_date     	gicl_clm_adj_hist.assign_date%TYPE,
        p_cancel_date     	gicl_clm_adj_hist.cancel_date%TYPE,
        p_complt_date     	gicl_clm_adj_hist.complt_date%TYPE,
        p_delete_date     	gicl_clm_adj_hist.delete_date%TYPE,
        p_user_id         	gicl_clm_adj_hist.user_id%TYPE,
        p_last_update     	gicl_clm_adj_hist.last_update%TYPE
        ) IS
      v_cancel_date     DATE;
      v_delete_date     DATE;
      v_adj_hist_no     gicl_clm_adj_hist.adj_hist_no%TYPE;
    BEGIN
        IF p_cancel_date IS NOT NULL THEN
          v_cancel_date := SYSDATE;
        END IF;
        IF p_delete_date IS NOT NULL THEN
          v_delete_date := SYSDATE;
        END IF;
        
        BEGIN
  	      SELECT NVL(MAX(adj_hist_no), 0) + 1
  	        INTO v_adj_hist_no
  	        FROM gicl_clm_adj_hist
  	       WHERE claim_id   = p_claim_id
  	         AND clm_adj_id = p_clm_adj_id;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            v_adj_hist_no := 1;
        END;
        
        INSERT INTO gicl_clm_adj_hist
                    (adj_hist_no,clm_adj_id,claim_id,
                     adj_company_cd,priv_adj_cd,assign_date,
                     cancel_date,complt_date,delete_date,
                     user_id,last_update)
             VALUES (v_adj_hist_no,p_clm_adj_id,p_claim_id,
                     p_adj_company_cd,p_priv_adj_cd,p_assign_date,
                     v_cancel_date,p_complt_date,v_delete_date,
                     p_user_id,SYSDATE);
    EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
	    null;                    
    END;
        
   /*
   **  Created by    : Jerome Orio 
   **  Date Created  : 11.09.2011
   **  Reference By  : (GICLS010 - Basic Information - adjuster history)
   **  Description   :  get records for adjuster history 
   */     
    FUNCTION get_gicl_clm_adj_hist(p_claim_id   gicl_clm_adj_hist.claim_id%TYPE)
    RETURN gicl_clm_adj_hist_tab PIPELINED IS
      v_list            gicl_clm_adj_hist_type;
    BEGIN
        FOR i IN(SELECT DISTINCT adj_company_cd, priv_adj_cd, claim_id 
                   FROM gicl_clm_adj_hist
                  WHERE claim_id = p_claim_id
                  ORDER BY adj_company_cd, priv_adj_cd) 
        LOOP
            -- get adjusting company name
            v_list.dsp_adj_co_name := '';
            FOR adj IN
            (SELECT payee_last_name||
                    DECODE(payee_first_name, NULL, NULL, ', '||payee_first_name)||
                    DECODE(payee_middle_name, NULL, NULL, ' '||payee_middle_name) NM
               FROM giis_payees
              WHERE payee_class_cd = GIACP.V('ADJP_CLASS_CD')
                AND payee_no       = i.adj_company_cd)
            LOOP
              v_list.dsp_adj_co_name := adj.nm;
            EXIT;
            END LOOP;

            -- get private adjuster name
            v_list.dsp_priv_adj_name := '';
            FOR priv IN
            (SELECT payee_name NM
               FROM giis_adjuster
              WHERE adj_company_cd = i.adj_company_cd
                AND priv_adj_cd    = i.priv_adj_cd)
            LOOP
              v_list.dsp_priv_adj_name := priv.nm;
            EXIT;
            END LOOP;
            
            v_list.adj_company_cd   := i.adj_company_cd; 
            v_list.priv_adj_cd      := i.priv_adj_cd; 
            v_list.claim_id         := i.claim_id;
            
        PIPE ROW(v_list);
        END LOOP;
    RETURN;
    END;
    
    /*
   **  Created by    : Jerome Orio 
   **  Date Created  : 11.10.2011
   **  Reference By  : (GICLS010 - Basic Information - adjuster history)
   **  Description   :  get records for adjuster history 
   */     
    FUNCTION get_gicl_clm_adj_hist2(
        p_claim_id              gicl_clm_adj_hist.claim_id%TYPE,
        p_adj_company_cd        gicl_clm_adj_hist.adj_company_cd%TYPE
        )
    RETURN gicl_clm_adj_hist_tab PIPELINED IS
      v_list            gicl_clm_adj_hist_type;
    BEGIN
        FOR i IN(SELECT adj_hist_no, clm_adj_id, claim_id,
                        adj_company_cd, priv_adj_cd, assign_date,
                        cancel_date, complt_date, delete_date,
                        user_id, last_update
                   FROM gicl_clm_adj_hist
                  WHERE claim_id = p_claim_id
                    AND adj_company_cd = p_adj_company_cd
                  ORDER BY adj_hist_no) 
        LOOP   
            v_list.adj_hist_no           := i.adj_hist_no;
            v_list.clm_adj_id            := i.clm_adj_id;
            v_list.claim_id              := i.claim_id;
            v_list.adj_company_cd        := i.adj_company_cd;
            v_list.priv_adj_cd           := i.priv_adj_cd;
            v_list.assign_date           := i.assign_date;
            v_list.cancel_date           := i.cancel_date;
            v_list.complt_date           := i.complt_date;
            v_list.delete_date           := i.delete_date;
            v_list.user_id         	     := i.user_id;
            v_list.last_update     	     := i.last_update;
        PIPE ROW(v_list);
        END LOOP;
    RETURN;
    END;    
    
END gicl_clm_adj_hist_pkg;
/


