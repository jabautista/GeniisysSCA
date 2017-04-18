CREATE OR REPLACE PACKAGE CPI.gicl_clm_adj_hist_pkg
AS 
    TYPE gicl_clm_adj_hist_type IS RECORD(
        adj_hist_no           gicl_clm_adj_hist.adj_hist_no%TYPE,
        clm_adj_id            gicl_clm_adj_hist.clm_adj_id%TYPE,
        claim_id              gicl_clm_adj_hist.claim_id%TYPE,
        adj_company_cd        gicl_clm_adj_hist.adj_company_cd%TYPE,
        priv_adj_cd           gicl_clm_adj_hist.priv_adj_cd%TYPE,
        assign_date           gicl_clm_adj_hist.assign_date%TYPE,
        cancel_date           gicl_clm_adj_hist.cancel_date%TYPE,
        complt_date           gicl_clm_adj_hist.complt_date%TYPE,
        delete_date           gicl_clm_adj_hist.delete_date%TYPE,
        user_id         	  gicl_clm_adj_hist.user_id%TYPE,
        last_update     	  gicl_clm_adj_hist.last_update%TYPE,
        dsp_adj_co_name       VARCHAR2 (600), --VARCHAR2 (290), changed by robert from 290 to 600
        dsp_priv_adj_name     giis_adjuster.payee_name%TYPE
        );
        
    TYPE gicl_clm_adj_hist_tab IS TABLE OF gicl_clm_adj_hist_type;    

    FUNCTION get_gicl_clm_adj_hist_exist( 
        p_claim_id          gicl_clm_adj_hist.claim_id%TYPE
        ) RETURN VARCHAR2;
        
    FUNCTION get_cancel_date( 
        p_adj_company_cd          gicl_clm_adj_hist.adj_company_cd%TYPE
        ) RETURN VARCHAR2;
                
    PROCEDURE set_gicl_clm_adj_hist(
        p_adj_hist_no           gicl_clm_adj_hist.adj_hist_no%TYPE,
        p_clm_adj_id            gicl_clm_adj_hist.clm_adj_id%TYPE,
        p_claim_id              gicl_clm_adj_hist.claim_id%TYPE,
        p_adj_company_cd        gicl_clm_adj_hist.adj_company_cd%TYPE,
        p_priv_adj_cd           gicl_clm_adj_hist.priv_adj_cd%TYPE,
        p_assign_date           gicl_clm_adj_hist.assign_date%TYPE,
        p_cancel_date     	    gicl_clm_adj_hist.cancel_date%TYPE,
        p_complt_date     	    gicl_clm_adj_hist.complt_date%TYPE,
        p_delete_date     	    gicl_clm_adj_hist.delete_date%TYPE,
        p_user_id         	    gicl_clm_adj_hist.user_id%TYPE,
        p_last_update     	    gicl_clm_adj_hist.last_update%TYPE
        );
             
    FUNCTION get_gicl_clm_adj_hist(p_claim_id   gicl_clm_adj_hist.claim_id%TYPE)
    RETURN gicl_clm_adj_hist_tab PIPELINED;
           
    FUNCTION get_gicl_clm_adj_hist2(
        p_claim_id              gicl_clm_adj_hist.claim_id%TYPE,
        p_adj_company_cd        gicl_clm_adj_hist.adj_company_cd%TYPE
        )
    RETURN gicl_clm_adj_hist_tab PIPELINED;
            
END gicl_clm_adj_hist_pkg;
/


