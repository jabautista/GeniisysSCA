CREATE OR REPLACE PACKAGE CPI.CSV_GICLR200B_PKG
AS
    TYPE giclr200b_type IS RECORD (
        
        CATASTROPHIC_CD         VARCHAR2(5),
        CATASTROPHIC_EVENT_DESCRIPTION      VARCHAR2(4000), --catastrophic_desc 
        CATASTROPHIC_EVENT_TO   VARCHAR(30),
        CATASTROPHIC_EVENT_FROM VARCHAR(30),
        TREATY          giis_dist_share.trty_name%TYPE,
        PAID               VARCHAR(30), --pd_ds
        OUTSTANDING        VARCHAR(30), --os_ds
        REINSURER          giis_reinsurer.ri_sname%TYPE,
        SHARE_PCT           VARCHAR2(20),
        PAID_RI             VARCHAR(30),
        OUTSTANDING_RI      VARCHAR(30)
    );
    
    TYPE giclr200b_tab IS TABLE OF giclr200b_type;
    
    TYPE giclr200b_remittance_type IS RECORD (
        session_id          gicl_os_pd_clm_rids_extr.session_id%TYPE,
        collection_amt      giac_loss_ri_collns.collection_amt%TYPE,
        or_date             giac_order_of_payts.or_date%TYPE,
        ri_cd               giac_loss_ri_collns.A180_RI_CD%TYPE,
        tag                 VARCHAR2(1),
        pd_losses           NUMBER(20,2),
        balance             NUMBER(20,2)
    );
    
    TYPE giclr200b_remittance_tab IS TABLE OF giclr200b_remittance_type;
    
    FUNCTION get_report_details(
        p_session_id    gicl_os_pd_clm_extr.session_id%TYPE,
        p_as_of_date    DATE,
        p_ri_cd         gicl_os_pd_clm_rids_extr.ri_cd%TYPE
    ) RETURN giclr200b_tab PIPELINED;
    
    FUNCTION get_remittance(
        p_session_id        gicl_os_pd_clm_rids_extr.session_id%TYPE,
        p_ri_cd             gicl_os_pd_clm_rids_extr.ri_cd%TYPE
    ) RETURN giclr200b_remittance_tab PIPELINED;
    
    
END CSV_GICLR200B_PKG;
/
