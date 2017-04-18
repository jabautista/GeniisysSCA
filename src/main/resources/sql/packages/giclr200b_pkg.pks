CREATE OR REPLACE PACKAGE CPI.GICLR200B_PKG
AS
    TYPE giclr200b_type IS RECORD (
        catastrophic_cd     gicl_os_pd_clm_extr.catastrophic_cd%TYPE,
        catastrophic_desc   VARCHAR2(4000),
        grp_seq_no          GICL_OS_PD_CLM_DS_EXTR.GRP_SEQ_NO%TYPE,
        share_type          GICL_OS_PD_CLM_DS_EXTR.SHARE_TYPE%TYPE,
        line_cd             gicl_os_pd_clm_extr.line_cd%TYPE,
        line_name           giis_line.line_name%TYPE,
        trty_name           giis_dist_share.trty_name%TYPE,
        os_ds               NUMBER(20,2),
        pd_ds               NUMBER(20,2),
        total_ds            NUMBER(20,2),
        ri_cd               gicl_os_pd_clm_rids_extr.ri_cd%TYPE,
        ri_sname            giis_reinsurer.ri_sname%TYPE,
        shr_ri_pct          gicl_os_pd_clm_rids_extr.shr_ri_pct%TYPE,
        share_pct           VARCHAR2(20),
        os_rids             NUMBER(20,2),
        pd_rids             NUMBER(20,2),
        total_rids          NUMBER(20,2),
        company_name        giis_parameters.param_value_v%TYPE,
        company_address     giis_parameters.param_value_v%TYPE,
        cf_date             VARCHAR2(100),
        cf_title            giis_reports.report_title%TYPE
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
    
--    added by gab 12.08.2016 SR 5830
    TYPE col_type IS RECORD (
      row_count    NUMBER                           := 1,
      share_ri_pct0     VARCHAR2(20),
      ri_sname0         giis_reinsurer.ri_sname%TYPE,
      share_ri_pct1     VARCHAR2(20),
      ri_sname1         giis_reinsurer.ri_sname%TYPE,
      catastrophic_cd1     gicl_os_pd_clm_extr.catastrophic_cd%TYPE,
      ri_cd1              gicl_os_pd_clm_rids_extr.ri_cd%TYPE,
      share_ri_pct2     VARCHAR2(20),
      ri_sname2         giis_reinsurer.ri_sname%TYPE,
      catastrophic_cd2     gicl_os_pd_clm_extr.catastrophic_cd%TYPE,
      ri_cd2               gicl_os_pd_clm_rids_extr.ri_cd%TYPE,
      share_ri_pct3     VARCHAR2(20),
      ri_sname3         giis_reinsurer.ri_sname%TYPE,
      catastrophic_cd3     gicl_os_pd_clm_extr.catastrophic_cd%TYPE,
      ri_cd3               gicl_os_pd_clm_rids_extr.ri_cd%TYPE,
      share_ri_pct4     VARCHAR2(20),
      ri_sname4         giis_reinsurer.ri_sname%TYPE,
      catastrophic_cd4     gicl_os_pd_clm_extr.catastrophic_cd%TYPE,
      ri_cd4               gicl_os_pd_clm_rids_extr.ri_cd%TYPE
   );

   TYPE col_tab IS TABLE OF col_type;

   FUNCTION get_col_tab (
        p_session_id    gicl_os_pd_clm_extr.session_id%TYPE,
        p_ri_cd         gicl_os_pd_clm_rids_extr.ri_cd%TYPE,
        p_catastrophic_cd gicl_os_pd_clm_extr.catastrophic_cd%TYPE,
        p_line_cd       giis_line.line_cd%TYPE
        )
      RETURN col_tab PIPELINED;
      
   TYPE ri_type IS RECORD (
      row_count     NUMBER                            := 1,
      ri_cd         gicl_os_pd_clm_rids_extr.ri_cd%TYPE,
      catastrophic_cd     gicl_os_pd_clm_extr.catastrophic_cd%TYPE,
      grp_seq_no          GICL_OS_PD_CLM_DS_EXTR.GRP_SEQ_NO%TYPE,
      os_rids1        NUMBER(20,2),
      pd_rids1        NUMBER(20,2),
      os_rids2        NUMBER(20,2),
      pd_rids2        NUMBER(20,2),
      os_rids3        NUMBER(20,2),
      pd_rids3        NUMBER(20,2),
      os_rids4        NUMBER(20,2),
      pd_rids4        NUMBER(20,2)
   );

   TYPE ri_tab IS TABLE OF ri_type;

   FUNCTION get_giclr200b_ri (p_session_id    gicl_os_pd_clm_extr.session_id%TYPE,
        p_ri_cd         gicl_os_pd_clm_rids_extr.ri_cd%TYPE,
        p_catastrophic_cd gicl_os_pd_clm_extr.catastrophic_cd%TYPE,
        p_line_cd       giis_line.line_cd%TYPE)
      RETURN ri_tab PIPELINED;
   
   TYPE ri_total_type IS RECORD (
      row_count     NUMBER                            := 1,
      tot_os_rids1        NUMBER(20,2),
      tot_pd_rids1        NUMBER(20,2),
      tot_os_rids2        NUMBER(20,2),
      tot_pd_rids2        NUMBER(20,2),
      tot_os_rids3        NUMBER(20,2),
      tot_pd_rids3        NUMBER(20,2),
      tot_os_rids4        NUMBER(20,2),
      tot_pd_rids4        NUMBER(20,2),
      total_rids1         NUMBER(20,2),
      total_rids2         NUMBER(20,2),
      total_rids3         NUMBER(20,2),
      total_rids4         NUMBER(20,2)
   );

   TYPE ri_total_tab IS TABLE OF ri_total_type;

   FUNCTION get_giclr200b_ri_total (p_session_id    gicl_os_pd_clm_extr.session_id%TYPE,
        p_ri_cd         gicl_os_pd_clm_rids_extr.ri_cd%TYPE,
        p_catastrophic_cd gicl_os_pd_clm_extr.catastrophic_cd%TYPE,
        p_line_cd       giis_line.line_cd%TYPE)
      RETURN ri_total_tab PIPELINED;
    
   TYPE treaty_type IS RECORD (
        catastrophic_cd     gicl_os_pd_clm_extr.catastrophic_cd%TYPE,
        grp_seq_no          GICL_OS_PD_CLM_DS_EXTR.GRP_SEQ_NO%TYPE,
        share_type          GICL_OS_PD_CLM_DS_EXTR.SHARE_TYPE%TYPE,
        line_cd             gicl_os_pd_clm_extr.line_cd%TYPE,
        trty_name           giis_dist_share.trty_name%TYPE,
        os_ds               NUMBER(20,2),
        pd_ds               NUMBER(20,2),
        total_ds            NUMBER(20,2)
   );

   TYPE treaty_tab IS TABLE OF treaty_type;

   FUNCTION get_giclr200b_treaty (
        p_session_id    gicl_os_pd_clm_extr.session_id%TYPE,
        p_catastrophic_cd gicl_os_pd_clm_extr.catastrophic_cd%TYPE,
        p_line_cd       giis_line.line_cd%TYPE
        )
      RETURN treaty_tab PIPELINED;
   
   TYPE treaty_total_type IS RECORD (
        catastrophic_cd     gicl_os_pd_clm_extr.catastrophic_cd%TYPE,
        share_type          GICL_OS_PD_CLM_DS_EXTR.SHARE_TYPE%TYPE,
        line_cd             gicl_os_pd_clm_extr.line_cd%TYPE,
        tot_os_ds               NUMBER(20,2),
        tot_pd_ds               NUMBER(20,2),
        tot_total_ds            NUMBER(20,2)
   );

   TYPE treaty_total_tab IS TABLE OF treaty_total_type;

   FUNCTION get_giclr200b_treaty_total (
        p_session_id    gicl_os_pd_clm_extr.session_id%TYPE,
        p_catastrophic_cd gicl_os_pd_clm_extr.catastrophic_cd%TYPE,
        p_line_cd       giis_line.line_cd%TYPE
        )
      RETURN treaty_total_tab PIPELINED;
       
END GICLR200B_PKG;
/
