CREATE OR REPLACE PACKAGE CPI.gicl_clm_item_pkg
AS

    PROCEDURE upd_gicl_clm_item(
        p_item_desc             gicl_clm_item.item_desc%TYPE,
        p_item_desc2            gicl_clm_item.item_desc2%TYPE,
        p_claim_id              gicl_clm_item.claim_id%TYPE,
        p_item_no               gicl_clm_item.item_no%TYPE
        );
        
    FUNCTION get_gicl_clm_item_exist( 
        p_claim_id          gicl_clm_item.claim_id%TYPE
        ) 
    RETURN VARCHAR2;
        
    PROCEDURE clear_item_peril(
        p_claim_id          gicl_claims.claim_id%TYPE,
        p_line_cd           gicl_claims.line_cd%TYPE,
        p_dsp_loss_date     gicl_claims.dsp_loss_date%TYPE,
        p_msg_alert     OUT VARCHAR2
        );
    
    TYPE currency_type IS RECORD(
        main_currency_cd    giis_currency.main_currency_cd%TYPE,
        currency_desc       giis_currency.currency_desc%TYPE,
        currency_rt         giis_currency.currency_rt%TYPE,
        item_no             gicl_clm_item.item_no%TYPE,
        item_title          gicl_clm_item.item_title%TYPE
        );
        
    TYPE currency_tab IS TABLE OF currency_type;    
    
    FUNCTION get_currency_list(p_claim_id      gicl_clm_item.claim_id%TYPE)
    RETURN currency_tab PIPELINED;
    
    TYPE gicl_clm_item_type IS RECORD(
        claim_id        gicl_clm_item.claim_id%TYPE,
        item_no         gicl_clm_item.item_no%TYPE,
        currency_cd     gicl_clm_item.currency_cd%TYPE,
        user_id         gicl_clm_item.user_id%TYPE,
        last_update     gicl_clm_item.last_update%TYPE,
        item_title      gicl_clm_item.item_title%TYPE,
        loss_date       gicl_clm_item.loss_date%TYPE,
        cpi_rec_no      gicl_clm_item.cpi_rec_no%TYPE,
        cpi_branch_cd   gicl_clm_item.cpi_branch_cd%TYPE,
        other_info      gicl_clm_item.other_info%TYPE,
        currency_rate       gicl_clm_item.currency_rate%TYPE,
        clm_currency_cd     gicl_clm_item.clm_currency_cd%TYPE,
        clm_currency_rate   gicl_clm_item.clm_currency_rate%TYPE,
        grouped_item_no     gicl_clm_item.grouped_item_no%TYPE,
        item_desc       gicl_clm_item.item_desc%TYPE,
        item_desc2      gicl_clm_item.item_desc2%TYPE
    );
    
    TYPE gicl_clm_item_tab IS TABLE OF gicl_clm_item_type; 
    
    FUNCTION get_gicl_clm_item(
       p_claim_id      gicl_claims.claim_id%TYPE
    ) RETURN gicl_clm_item_tab PIPELINED;
    
    TYPE gicl_clm_item_gicls260_type IS RECORD(
       item_no             gicl_clm_item.item_no%TYPE,
       item_title          gicl_clm_item.item_title%TYPE,
       other_info          gicl_clm_item.other_info%TYPE,
       currency_cd         gicl_clm_item.currency_cd%TYPE,
       dsp_currency_desc   giis_currency.currency_desc%TYPE,
       currency_rate       gicl_clm_item.currency_rate%TYPE,
       loss_date           VARCHAR2(30), --gicl_clm_item.loss_date%TYPE, : shan 04.15.2014 
       gicl_item_peril_exist VARCHAR2(1)
    );
    
    TYPE gicl_clm_item_gicls260_tab IS TABLE OF gicl_clm_item_gicls260_type;
    
    FUNCTION get_gicl_clm_item_gicls260(
       p_claim_id      gicl_claims.claim_id%TYPE
    ) RETURN gicl_clm_item_gicls260_tab PIPELINED;
    
END gicl_clm_item_pkg;
/


