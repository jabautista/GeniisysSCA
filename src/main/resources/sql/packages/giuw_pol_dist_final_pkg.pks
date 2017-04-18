CREATE OR REPLACE PACKAGE CPI.GIUW_POL_DIST_FINAL_PKG AS
    
    TYPE giuw_witemperilds_type IS RECORD (
        dist_seq_no     giuw_witemperilds.dist_seq_no%TYPE,
        peril_cd        giuw_witemperilds.peril_cd%TYPE,
        item_no         giuw_witemperilds.item_no%TYPE
    );
    
    TYPE giuw_witemperilds_type_cur IS REF CURSOR
        RETURN giuw_witemperilds_type;
        
    TYPE giuw_pol_dist_final_type IS RECORD(
        dist_no             GIUW_POL_DIST.dist_no%TYPE,        
        par_id              GIUW_POL_DIST.par_id%TYPE, 
        policy_id           GIUW_POL_DIST.policy_id%TYPE,
        tsi_amt             GIUW_POL_DIST.tsi_amt%TYPE,
        prem_amt            GIUW_POL_DIST.prem_amt%TYPE,
        batch_id            GIUW_POL_DIST.batch_id%TYPE, 
        iss_cd              GIUW_POL_DIST.iss_cd%TYPE,
        prem_seq_no         GIUW_POL_DIST.prem_seq_no%TYPE,
        item_grp            GIUW_POL_DIST.item_grp%TYPE,
        takeup_seq_no       GIUW_POL_DIST.takeup_seq_no%TYPE
    );

    TYPE giuw_pol_dist_final_tab IS TABLE OF giuw_pol_dist_final_type;
    
    TYPE giuw_witemperilds_rec_type IS RECORD (
        dist_seq_no     giuw_witemperilds.dist_seq_no%TYPE,
        peril_cd        giuw_witemperilds.peril_cd%TYPE,
        item_no         giuw_witemperilds.item_no%TYPE,
        peril_type      giis_peril.peril_type%TYPE
    );
    
    TYPE giuw_witemperilds_rec_tab IS TABLE OF giuw_witemperilds_rec_type;

    PROCEDURE COMP_GIPI_ITEM_ITMPERIL_GWS010 
     (p_policy_id         IN       GIPI_POLBASIC.policy_id%TYPE,
      p_pack_pol_flag     IN       GIPI_POLBASIC.pack_pol_flag%TYPE,
      p_line_cd           IN       GIPI_POLBASIC.line_cd%TYPE,
      p_message           OUT      VARCHAR2);
      
    PROCEDURE CRTE_GRP_DFLT_WPOLICYDS_GWS010
     (p_dist_no        IN   GIUW_WPOLICYDS_DTL.dist_no%TYPE      ,
      p_dist_seq_no    IN   GIUW_WPOLICYDS_DTL.dist_seq_no%TYPE  ,
      p_line_cd        IN   GIUW_WPOLICYDS_DTL.line_cd%TYPE      ,
      p_dist_tsi       IN   GIUW_WPOLICYDS_DTL.dist_tsi%TYPE     ,
      p_dist_prem      IN   GIUW_WPOLICYDS_DTL.dist_prem%TYPE    ,
      p_ann_dist_tsi   IN   GIUW_WPOLICYDS_DTL.ann_dist_tsi%TYPE ,
      p_rg_count       IN   OUT NUMBER                           ,
      p_default_type   IN   GIIS_DEFAULT_DIST.default_type%TYPE  ,
      p_currency_rt    IN   GIPI_ITEM.currency_rt%TYPE          ,
      p_policy_id      IN   GIPI_POLBASIC.policy_id%TYPE         ,
      p_item_grp       IN   GIPI_ITEM.item_grp%TYPE,
      p_v_default_no   IN   GIIS_DEFAULT_DIST.default_no%TYPE);
          
    PROCEDURE CRTE_PERL_DFLT_WPERILDS_GWS010
     (p_dist_no         IN  GIUW_WPERILDS_DTL.dist_no%TYPE      ,
      p_dist_seq_no     IN  GIUW_WPERILDS_DTL.dist_seq_no%TYPE  ,
      p_line_cd         IN  GIUW_WPERILDS_DTL.line_cd%TYPE      ,
      p_peril_cd        IN  GIUW_WPERILDS_DTL.peril_cd%TYPE     ,
      p_dist_tsi        IN  GIUW_WPERILDS_DTL.dist_tsi%TYPE     ,
      p_dist_prem       IN  GIUW_WPERILDS_DTL.dist_prem%TYPE    ,
      p_ann_dist_tsi    IN  GIUW_WPERILDS_DTL.ann_dist_tsi%TYPE ,
      p_currency_rt     IN  GIPI_WINVOICE.currency_rt%TYPE      ,
      p_default_no      IN  GIIS_DEFAULT_DIST.default_no%TYPE   ,
      p_default_type    IN  GIIS_DEFAULT_DIST.default_type%TYPE ,
      p_dflt_netret_pct IN  GIIS_DEFAULT_DIST.dflt_netret_pct%TYPE);
          
    PROCEDURE CRTE_RI_NEW_WDISTFRPS_GIUWS010
     (p_dist_no         IN  GIUW_WPOLICYDS_DTL.dist_no%TYPE,
      p_dist_seq_no     IN  GIUW_WPOLICYDS_DTL.dist_seq_no%TYPE,
      p_new_tsi_amt     IN  GIUW_WPOLICYDS.tsi_amt%TYPE,
      p_new_prem_amt    IN  GIUW_WPOLICYDS.prem_amt%TYPE, 
      p_new_dist_tsi    IN  GIUW_WPOLICYDS_DTL.dist_tsi%TYPE, 
      p_new_dist_prem   IN  GIUW_WPOLICYDS_DTL.dist_prem%TYPE,
      p_new_dist_spct   IN  GIUW_WPOLICYDS_DTL.dist_spct%TYPE,
      p_new_currency_cd IN  GIPI_INVOICE.currency_cd%TYPE,
      p_new_currency_rt IN  GIPI_INVOICE.currency_rt%TYPE,
      p_new_user_id     IN  GIUW_POL_DIST.user_id%TYPE,
      p_policy_id       IN  GIPI_POLBASIC.policy_id%TYPE,
      p_line_cd         IN  GIPI_POLBASIC.line_cd%TYPE,
      p_subline_cd      IN  GIPI_POLBASIC.subline_cd%TYPE);
          
    PROCEDURE DEL_AFFECTED_DIST_TABLES(v_dist_no giuw_pol_dist.dist_no%TYPE);

    PROCEDURE RECRTE_GRP_DFLT_WPOLDS_GWS010
     (p_dist_no        IN   GIUW_WPOLICYDS_DTL.dist_no%TYPE      ,
      p_dist_seq_no    IN   GIUW_WPOLICYDS_DTL.dist_seq_no%TYPE  ,
      p_line_cd        IN   GIUW_WPOLICYDS_DTL.line_cd%TYPE      ,
      p_dist_tsi       IN   GIUW_WPOLICYDS_DTL.dist_tsi%TYPE     ,
      p_dist_prem      IN   GIUW_WPOLICYDS_DTL.dist_prem%TYPE    ,
      p_ann_dist_tsi   IN   GIUW_WPOLICYDS_DTL.ann_dist_tsi%TYPE ,
      p_rg_count       IN OUT NUMBER                           ,
      p_default_type   IN   GIIS_DEFAULT_DIST.default_type%TYPE  ,
      p_currency_rt    IN   GIPI_ITEM.currency_rt%TYPE          ,
      p_policy_id      IN   GIPI_POLBASIC.policy_id%TYPE        ,
      p_item_grp       IN   GIPI_ITEM.item_grp%TYPE,
      p_v_default_no   IN   GIIS_DEFAULT_DIST.default_no%TYPE);
          
    PROCEDURE RECRTE_PERIL_DFLT_DIST_GWS010
      (p_dist_no         IN     GIUW_WPOLICYDS.dist_no%TYPE,
       p_dist_seq_no     IN     GIUW_WPOLICYDS.dist_seq_no%TYPE,
       p_dist_flag       IN     GIUW_WPOLICYDS.dist_flag%TYPE,
       p_policy_tsi      IN     GIUW_WPOLICYDS.tsi_amt%TYPE,
       p_policy_premium  IN     GIUW_WPOLICYDS.prem_amt%TYPE,
       p_policy_ann_tsi  IN     GIUW_WPOLICYDS.ann_tsi_amt%TYPE,
       p_item_grp        IN     GIUW_WPOLICYDS.item_grp%TYPE,
       p_line_cd         IN     GIIS_LINE.line_cd%TYPE,
       p_default_no      IN     GIIS_DEFAULT_DIST.default_no%TYPE,
       p_default_type    IN     GIIS_DEFAULT_DIST.default_type%TYPE,
       p_dflt_netret_pct IN     GIIS_DEFAULT_DIST.dflt_netret_pct%TYPE,
       p_currency_rt     IN     GIPI_ITEM.currency_rt%TYPE,
       p_policy_id       IN     GIPI_POLBASIC.policy_id%TYPE);
       
    PROCEDURE CREATE_GRP_DFLT_DIST_GIUWS010
       (p_dist_no        IN     GIUW_WPOLICYDS.dist_no%TYPE,
        p_dist_seq_no    IN     GIUW_WPOLICYDS.dist_seq_no%TYPE,
        p_dist_flag      IN     GIUW_WPOLICYDS.dist_flag%TYPE,
        p_policy_tsi     IN     GIUW_WPOLICYDS.tsi_amt%TYPE,
        p_policy_premium IN     GIUW_WPOLICYDS.prem_amt%TYPE,
        p_policy_ann_tsi IN     GIUW_WPOLICYDS.ann_tsi_amt%TYPE,
        p_item_grp       IN     GIUW_WPOLICYDS.item_grp%TYPE,
        p_line_cd        IN     GIIS_LINE.line_cd%TYPE,
        p_rg_count       IN     OUT NUMBER,
        p_default_type   IN     GIIS_DEFAULT_DIST.default_type%TYPE,
        p_currency_rt    IN     GIPI_ITEM.currency_rt%TYPE,
        p_policy_id      IN     GIPI_POLBASIC.policy_id%TYPE,
        p_v_default_no   IN     GIIS_DEFAULT_DIST.default_no%TYPE);
        
    PROCEDURE CREATE_RI_RECORDS_GIUWS010
        (p_dist_no    IN GIUW_POL_DIST.dist_no%TYPE,
         p_policy_id  IN GIPI_POLBASIC.policy_id%TYPE,
         p_line_cd    IN GIPI_POLBASIC.line_cd%TYPE,
         p_subline_cd IN GIPI_POLBASIC.subline_cd%TYPE);

    PROCEDURE CRTE_PERIL_DFLT_DIST_GIUWS010
        (p_dist_no         IN GIUW_WPOLICYDS.dist_no%TYPE,
         p_dist_seq_no     IN GIUW_WPOLICYDS.dist_seq_no%TYPE,
         p_dist_flag       IN GIUW_WPOLICYDS.dist_flag%TYPE,
         p_policy_tsi      IN GIUW_WPOLICYDS.tsi_amt%TYPE,
         p_policy_premium  IN GIUW_WPOLICYDS.prem_amt%TYPE,
         p_policy_ann_tsi  IN GIUW_WPOLICYDS.ann_tsi_amt%TYPE,
         p_item_grp        IN GIUW_WPOLICYDS.item_grp%TYPE, 
         p_line_cd         IN GIIS_LINE.line_cd%TYPE,
         p_default_no      IN GIIS_DEFAULT_DIST.default_no%TYPE,
         p_default_type    IN GIIS_DEFAULT_DIST.default_type%TYPE,
         p_dflt_netret_pct IN GIIS_DEFAULT_DIST.dflt_netret_pct%TYPE,
         p_currency_rt     IN GIPI_ITEM.currency_rt%TYPE,
         p_policy_id       IN GIPI_POLBASIC.policy_id%TYPE);

    PROCEDURE CRTE_POLICY_DIST_RECS_GIUWS010
      (p_dist_no       IN   GIUW_POL_DIST.dist_no%TYPE,
       p_policy_id     IN   GIPI_POLBASIC.policy_id%TYPE,
       p_line_cd       IN   GIPI_POLBASIC.line_cd%TYPE,
       p_subline_cd    IN   GIPI_POLBASIC.subline_cd%TYPE,
       p_iss_cd        IN   GIPI_POLBASIC.iss_cd%TYPE,
       p_pack_pol_flag IN   GIPI_POLBASIC.pack_pol_flag%TYPE);
       
     PROCEDURE RECRTE_GRP_DFLT_DIST_GIUWS010
        (p_dist_no        IN    GIUW_WPOLICYDS.dist_no%TYPE,
         p_dist_seq_no    IN    GIUW_WPOLICYDS.dist_seq_no%TYPE,
         p_dist_flag      IN    GIUW_WPOLICYDS.dist_flag%TYPE,
         p_policy_tsi     IN    GIUW_WPOLICYDS.tsi_amt%TYPE,
         p_policy_premium IN    GIUW_WPOLICYDS.prem_amt%TYPE,
         p_policy_ann_tsi IN    GIUW_WPOLICYDS.ann_tsi_amt%TYPE,
         p_item_grp       IN    GIUW_WPOLICYDS.item_grp%TYPE,
         p_line_cd        IN    GIIS_LINE.line_cd%TYPE,
         p_rg_count       IN OUT NUMBER,
         p_default_type   IN    GIIS_DEFAULT_DIST.default_type%TYPE,
         p_currency_rt    IN    GIPI_ITEM.currency_rt%TYPE,
         p_policy_id      IN    GIPI_POLBASIC.policy_id%TYPE,
         p_v_default_no   IN    GIIS_DEFAULT_DIST.default_no%TYPE);

    PROCEDURE CREATE_ITEMS_GIUWS010
       (p_dist_no        IN     GIUW_POL_DIST.dist_no%TYPE,
        p_policy_id      IN     GIPI_POLBASIC.policy_id%TYPE,
        p_line_cd        IN     GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd     IN     GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd         IN     GIPI_POLBASIC.iss_cd%TYPE,
        p_pack_pol_flag  IN     GIPI_POLBASIC.pack_pol_flag%TYPE);

    PROCEDURE CRTE_REGRPED_DIST_RECS_GWS010
     (p_dist_no       IN    GIUW_POL_DIST.dist_no%TYPE    ,
      p_policy_id     IN    GIPI_POLBASIC.policy_id%TYPE  ,
      p_line_cd       IN    GIPI_POLBASIC.line_cd%TYPE    ,
      p_subline_cd    IN    GIPI_POLBASIC.subline_cd%TYPE ,
      p_iss_cd        IN    GIPI_POLBASIC.iss_cd%TYPE     ,
      p_pack_pol_flag IN    GIPI_POLBASIC.pack_pol_flag%TYPE);
      
    PROCEDURE PRE_UPDATE_C150_GIUWS010
    (p_dist_no        IN    GIUW_WPOLICYDS.dist_no%TYPE,
     p_dist_seq_no    IN    GIUW_WPOLICYDS.dist_seq_no%TYPE,
     p_tsi_amt        IN    GIUW_WPOLICYDS.tsi_amt%TYPE,
     p_prem_amt       IN    GIUW_WPOLICYDS.prem_amt%TYPE,
     p_ann_tsi_amt    IN    GIUW_WPOLICYDS.ann_tsi_amt%TYPE,
     p_item_grp       IN    GIUW_WPOLICYDS.item_grp%TYPE,
     p_policy_id      IN    GIPI_POLBASIC.policy_id%TYPE);
     
     PROCEDURE POST_UPDATE_C150_GIUWS010
    (p_dist_no            IN    GIUW_WPOLICYDS.dist_no%TYPE,
     p_orig_dist_seq_no   IN    GIUW_WPOLICYDS.dist_seq_no%TYPE,
     p_tsi_amt            IN    GIUW_WPOLICYDS.tsi_amt%TYPE,
     p_prem_amt           IN    GIUW_WPOLICYDS.prem_amt%TYPE,
     p_ann_tsi_amt        IN    GIUW_WPOLICYDS.ann_tsi_amt%TYPE);
     
     PROCEDURE PRE_COMMIT_GIUWS010(p_dist_no GIUW_POL_DIST.dist_no%TYPE); 
     
     PROCEDURE CRTE_PERIL_DFLT_WITEMDS_GWS018
     (p_dist_no       IN giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no   IN giuw_wpolicyds.dist_seq_no%TYPE);
     
     PROCEDURE CRTE_PERIL_DFLT_DIST_GWS018
       (p_dist_no         IN giuw_wpolicyds.dist_no%TYPE,
        p_dist_seq_no     IN giuw_wpolicyds.dist_seq_no%TYPE,
        p_dist_flag       IN giuw_wpolicyds.dist_flag%TYPE,
        p_policy_tsi      IN giuw_wpolicyds.tsi_amt%TYPE,
        p_policy_premium  IN giuw_wpolicyds.prem_amt%TYPE,
        p_policy_ann_tsi  IN giuw_wpolicyds.ann_tsi_amt%TYPE,
        p_item_grp        IN giuw_wpolicyds.item_grp%TYPE,
        p_line_cd         IN giis_line.line_cd%TYPE,
        p_default_no      IN giis_default_dist.default_no%TYPE,
        p_default_type    IN giis_default_dist.default_type%TYPE,
        p_dflt_netret_pct IN giis_default_dist.dflt_netret_pct%TYPE,
        p_currency_rt     IN gipi_item.currency_rt%TYPE,
        p_policy_id       IN gipi_polbasic.policy_id%TYPE);
        
   PROCEDURE CRTE_GRP_DFLT_DIST_GWS018
        (p_dist_no        IN giuw_wpolicyds.dist_no%TYPE,
         p_dist_seq_no    IN giuw_wpolicyds.dist_seq_no%TYPE,
         p_dist_flag      IN giuw_wpolicyds.dist_flag%TYPE,
         p_policy_tsi     IN giuw_wpolicyds.tsi_amt%TYPE,
         p_policy_premium IN giuw_wpolicyds.prem_amt%TYPE,
         p_policy_ann_tsi IN giuw_wpolicyds.ann_tsi_amt%TYPE,
         p_item_grp       IN giuw_wpolicyds.item_grp%TYPE,
         p_line_cd        IN giis_line.line_cd%TYPE,
         p_rg_count       IN OUT NUMBER,
         p_default_type   IN giis_default_dist.default_type%TYPE,
         p_currency_rt    IN gipi_item.currency_rt%TYPE,
         p_policy_id      IN gipi_polbasic.policy_id%TYPE,
         p_default_no     in giis_default_dist.default_no%TYPE);
         
   PROCEDURE  CRTE_POLICY_DIST_RECS_GIUWS018
    (p_dist_no       IN giuw_pol_dist.dist_no%TYPE,
     p_policy_id     IN gipi_polbasic.policy_id%TYPE,
     p_line_cd       IN gipi_polbasic.line_cd%TYPE,
     p_subline_cd    IN gipi_polbasic.subline_cd%TYPE,
     p_iss_cd        IN gipi_polbasic.iss_cd%TYPE,
     p_pack_pol_flag IN gipi_polbasic.pack_pol_flag%TYPE);
   
   PROCEDURE COMP_GIPI_ITEM_ITMPERIL_GWS018 
    (p_policy_id         IN       GIPI_POLBASIC.policy_id%TYPE,
     p_pack_pol_flag     IN       GIPI_POLBASIC.pack_pol_flag%TYPE,
     p_line_cd           IN       GIPI_POLBASIC.line_cd%TYPE,
     p_message           OUT      VARCHAR2);
  
    PROCEDURE CREATE_ITEMS_GIUWS018
       (p_dist_no        IN     GIUW_POL_DIST.dist_no%TYPE,
        p_policy_id      IN     GIPI_POLBASIC.policy_id%TYPE,
        p_line_cd        IN     GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd     IN     GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd         IN     GIPI_POLBASIC.iss_cd%TYPE,
        p_pack_pol_flag  IN     GIPI_POLBASIC.pack_pol_flag%TYPE);
    
    PROCEDURE DEL_AFFECTED_DIST_TABLE_GWS018 ( v_dist_no  giuw_pol_dist.dist_no%TYPE);
    
    PROCEDURE PRE_COMMIT_GIUWS018(p_dist_no GIUW_POL_DIST.dist_no%TYPE);
    
    PROCEDURE RECRTE_GRP_DFLT_DIST_GWS018
        (p_dist_no        IN giuw_wpolicyds.dist_no%TYPE,
         p_dist_seq_no    IN giuw_wpolicyds.dist_seq_no%TYPE,
         p_dist_flag      IN giuw_wpolicyds.dist_flag%TYPE,
         p_policy_tsi     IN giuw_wpolicyds.tsi_amt%TYPE,
         p_policy_premium IN giuw_wpolicyds.prem_amt%TYPE,
         p_policy_ann_tsi IN giuw_wpolicyds.ann_tsi_amt%TYPE,
         p_item_grp       IN giuw_wpolicyds.item_grp%TYPE,
         p_line_cd        IN giis_line.line_cd%TYPE,
         p_rg_count       IN OUT NUMBER,
         p_default_type   IN giis_default_dist.default_type%TYPE,
         p_currency_rt    IN gipi_item.currency_rt%TYPE,
         p_policy_id      IN gipi_polbasic.policy_id%TYPE,
         p_default_no     IN GIIS_DEFAULT_DIST.default_no%TYPE);
         
    PROCEDURE RECRTE_PERIL_DFLT_DIST_GWS018
         (p_dist_no         IN giuw_wpolicyds.dist_no%TYPE,
          p_dist_seq_no     IN giuw_wpolicyds.dist_seq_no%TYPE,
          p_dist_flag       IN giuw_wpolicyds.dist_flag%TYPE,
          p_policy_tsi      IN giuw_wpolicyds.tsi_amt%TYPE,
          p_policy_premium  IN giuw_wpolicyds.prem_amt%TYPE,
          p_policy_ann_tsi  IN giuw_wpolicyds.ann_tsi_amt%TYPE,
          p_item_grp        IN giuw_wpolicyds.item_grp%TYPE,
          p_line_cd         IN giis_line.line_cd%TYPE,
          p_default_no      IN giis_default_dist.default_no%TYPE,
          p_default_type    IN giis_default_dist.default_type%TYPE,
          p_dflt_netret_pct IN giis_default_dist.dflt_netret_pct%TYPE,
          p_currency_rt     IN gipi_item.currency_rt%TYPE,
          p_policy_id       IN gipi_polbasic.policy_id%TYPE); 
          
     PROCEDURE CRTE_REGRPED_DIST_RECS_GWS018
         (p_dist_no       IN giuw_pol_dist.dist_no%TYPE    ,
          p_policy_id     IN gipi_polbasic.policy_id%TYPE  ,
          p_line_cd       IN gipi_polbasic.line_cd%TYPE    ,
          p_subline_cd    IN gipi_polbasic.subline_cd%TYPE ,
          p_iss_cd        IN gipi_polbasic.iss_cd%TYPE     ,
          p_pack_pol_flag IN gipi_polbasic.pack_pol_flag%TYPE,
          p_item_no       IN  VARCHAR2,
          p_dist_seq_no   IN giuw_wperilds.dist_seq_no%TYPE,
          p_peril_type    IN giis_peril.peril_type%TYPE,
          p_peril_cd      IN giuw_wperilds.peril_cd%TYPE);        
          
     PROCEDURE PRE_UPDATE_C150_GWS018
        (p_dist_no        IN    GIUW_WPOLICYDS.dist_no%TYPE,
         p_dist_seq_no    IN    GIUW_WPOLICYDS.dist_seq_no%TYPE,
         p_tsi_amt        IN    GIUW_WPOLICYDS.tsi_amt%TYPE,
         p_prem_amt       IN    GIUW_WPOLICYDS.prem_amt%TYPE,
         p_ann_tsi_amt    IN    GIUW_WPOLICYDS.ann_tsi_amt%TYPE,
         p_item_grp       IN    GIUW_WPOLICYDS.item_grp%TYPE,
         p_policy_id      IN    GIPI_POLBASIC.policy_id%TYPE,
         p_peril_type     IN    GIIS_PERIL.peril_type%TYPE);
         
     PROCEDURE POST_UPDATE_C150_GWS018
        (p_dist_no          IN    GIUW_WPOLICYDS.dist_no%TYPE,
         p_orig_dist_seq_no IN    GIUW_WPOLICYDS.dist_seq_no%TYPE,
         p_tsi_amt          IN    GIUW_WPOLICYDS.tsi_amt%TYPE,
         p_prem_amt         IN    GIUW_WPOLICYDS.prem_amt%TYPE,
         p_ann_tsi_amt      IN    GIUW_WPOLICYDS.ann_tsi_amt%TYPE,
         p_peril_type       IN    GIIS_PERIL.peril_type%TYPE);
         
     PROCEDURE ADJUST_AMTS_GIUWS016 (p_dist_no IN GIUW_POL_DIST.dist_no%TYPE);
     
     PROCEDURE ADJUST_DTL_AMTS_GIUWS016 (p_dist_no IN GIUW_POL_DIST.dist_no%TYPE);
     
     PROCEDURE ADJUST_ITM_LVL_AMTS_GIUWS016 (p_dist_no IN GIUW_POL_DIST.dist_no%TYPE);
     
     PROCEDURE ADJ_ITM_PERL_LVL_AMTS_GIUWS016 (p_dist_no IN GIUW_POL_DIST.dist_no%TYPE);
     
     PROCEDURE ADJUST_PERIL_LVL_AMTS_GIUWS016 (p_dist_no IN GIUW_POL_DIST.dist_no%TYPE);
     
     PROCEDURE ADJUST_POL_LVL_AMTS_GIUWS016(p_dist_no IN GIUW_POL_DIST.dist_no%TYPE);
     
     PROCEDURE ADJUST_WPOLICYDS_DTL_GIUWS016 ( p_dist_no      IN    GIUW_POL_DIST.dist_no%TYPE,
                                               p_dist_seq_no  IN    GIUW_WPOLICYDS.dist_seq_no%TYPE);
     
     PROCEDURE ADJ_NET_RET_IMPERFECTION_016 (p_dist_no IN GIUW_POL_DIST.dist_no%TYPE);
                                               
     PROCEDURE POP_WITEM_PERIL_DTL_GIUWS016 (p_dist_no  IN  GIUW_POL_DIST.dist_no%TYPE);
     
     PROCEDURE CREATE_RI_RECORDS_GIUWS016(p_policy_id  IN  GIUW_POL_DIST.policy_id%TYPE,
                                          p_dist_no    IN  GIUW_POL_DIST.dist_no%TYPE,
                                          p_par_id     IN  GIPI_PARLIST.par_id%TYPE,
                                          p_line_cd    IN  GIPI_WPOLBAS.line_cd%TYPE,
                                          p_subline_cd IN  GIPI_WPOLBAS.subline_cd%TYPE);
     PROCEDURE CREATE_GRP_DFLT_WPOLICYDS_016
         (p_dist_no         IN  GIUW_WPOLICYDS_DTL.dist_no%TYPE      ,
          p_dist_seq_no     IN  GIUW_WPOLICYDS_DTL.dist_seq_no%TYPE  ,
          p_line_cd         IN  GIUW_WPOLICYDS_DTL.line_cd%TYPE      ,
          p_dist_tsi        IN  GIUW_WPOLICYDS_DTL.dist_tsi%TYPE     ,
          p_dist_prem       IN  GIUW_WPOLICYDS_DTL.dist_prem%TYPE    ,
          p_ann_dist_tsi    IN  GIUW_WPOLICYDS_DTL.ann_dist_tsi%TYPE ,
          p_rg_count        IN  OUT NUMBER                           ,
          p_default_type    IN  GIIS_DEFAULT_DIST.default_type%TYPE  ,
          p_currency_rt     IN  GIPI_WITEM.currency_rt%TYPE          ,
          p_par_id          IN  GIPI_PARLIST.par_id%TYPE             ,
          p_item_grp        IN  GIPI_WITEM.item_grp%TYPE             ,
          p_policy_id       IN  GIUW_POL_DIST.policy_id%TYPE         ,
          p_pol_flag        IN  GIPI_WPOLBAS.pol_flag%TYPE           ,
          p_par_type        IN  GIPI_PARLIST.par_type%TYPE);
          
    PROCEDURE CREATE_GRP_DFLT_WPERILDS_016
         (p_dist_no        IN   GIUW_WPERILDS_DTL.dist_no%TYPE      ,
          p_dist_seq_no    IN   GIUW_WPERILDS_DTL.dist_seq_no%TYPE  ,
          p_line_cd        IN   GIUW_WPERILDS_DTL.line_cd%TYPE      ,
          p_peril_cd       IN   GIUW_WPERILDS_DTL.peril_cd%TYPE     ,
          p_dist_tsi       IN   GIUW_WPERILDS_DTL.dist_tsi%TYPE     ,
          p_dist_prem      IN   GIUW_WPERILDS_DTL.dist_prem%TYPE    ,
          p_ann_dist_tsi   IN   GIUW_WPERILDS_DTL.ann_dist_tsi%TYPE ,
          p_rg_count       IN   NUMBER                              ,
          p_par_id         IN   GIPI_PARLIST.par_id%TYPE            ,
          p_policy_id      IN   GIUW_POL_DIST.policy_id%TYPE        ,
          p_pol_flag       IN   GIPI_WPOLBAS.pol_flag%TYPE          ,
          p_par_type       IN   GIPI_PARLIST.par_type%TYPE);
          
    PROCEDURE CRTE_GRP_DFLT_WITEMPERILDS_016
         (p_dist_no            IN   GIUW_WITEMPERILDS_DTL.dist_no%TYPE      ,
          p_dist_seq_no        IN   GIUW_WITEMPERILDS_DTL.dist_seq_no%TYPE  ,
          p_item_no            IN   GIUW_WITEMPERILDS_DTL.item_no%TYPE      ,
          p_line_cd            IN   GIUW_WITEMPERILDS_DTL.line_cd%TYPE      ,
          p_peril_cd           IN   GIUW_WITEMPERILDS_DTL.peril_cd%TYPE     ,
          p_dist_tsi           IN   GIUW_WITEMPERILDS_DTL.dist_tsi%TYPE     ,
          p_dist_prem          IN   GIUW_WITEMPERILDS_DTL.dist_prem%TYPE    ,
          p_ann_dist_tsi       IN   GIUW_WITEMPERILDS_DTL.ann_dist_tsi%TYPE ,
          p_rg_count           IN   NUMBER                                  ,
          p_par_id             IN   GIPI_PARLIST.par_id%TYPE                ,
          p_policy_id          IN   GIUW_POL_DIST.policy_id%TYPE            ,
          p_pol_flag           IN   GIPI_WPOLBAS.pol_flag%TYPE              ,
          p_par_type           IN   GIPI_PARLIST.par_type%TYPE);
          
     PROCEDURE CREATE_GRP_DFLT_WITEMDS_016
         (p_dist_no            IN   GIUW_WITEMDS_DTL.dist_no%TYPE      ,
          p_dist_seq_no        IN   GIUW_WITEMDS_DTL.dist_seq_no%TYPE  ,
          p_item_no            IN   GIUW_WITEMDS_DTL.item_no%TYPE      ,
          p_line_cd            IN   GIUW_WITEMDS_DTL.line_cd%TYPE      ,
          p_dist_tsi           IN   GIUW_WITEMDS_DTL.dist_tsi%TYPE     ,
          p_dist_prem          IN   GIUW_WITEMDS_DTL.dist_prem%TYPE    ,
          p_ann_dist_tsi       IN   GIUW_WITEMDS_DTL.ann_dist_tsi%TYPE ,
          p_rg_count           IN   NUMBER                             ,
          p_par_id             IN   GIPI_PARLIST.par_id%TYPE           ,
          p_policy_id          IN   GIUW_POL_DIST.policy_id%TYPE       ,
          p_pol_flag           IN   GIPI_WPOLBAS.pol_flag%TYPE         ,
          p_par_type           IN   GIPI_PARLIST.par_type%TYPE);
          
     PROCEDURE CREATE_GRP_DFLT_DIST_GIUWS016
         (p_dist_no        IN  GIUW_WPOLICYDS.dist_no%TYPE,
          p_dist_seq_no    IN  GIUW_WPOLICYDS.dist_seq_no%TYPE,
          p_dist_flag      IN  GIUW_WPOLICYDS.dist_flag%TYPE,
          p_policy_tsi     IN  GIUW_WPOLICYDS.tsi_amt%TYPE,
          p_policy_premium IN  GIUW_WPOLICYDS.prem_amt%TYPE,
          p_policy_ann_tsi IN  GIUW_WPOLICYDS.ann_tsi_amt%TYPE,
          p_item_grp       IN  GIUW_WPOLICYDS.item_grp%TYPE,
          p_line_cd        IN  GIIS_LINE.line_cd%TYPE,
          p_rg_count       IN OUT NUMBER,
          p_default_type   IN  GIIS_DEFAULT_DIST.default_type%TYPE,
          p_currency_rt    IN  GIPI_WITEM.currency_rt%TYPE,
          p_par_id         IN  GIPI_PARLIST.par_id%TYPE,
          p_dist_exists    IN  VARCHAR2,
          p_policy_id      IN  GIUW_POL_DIST.policy_id%TYPE,
          p_pol_flag       IN  GIPI_WPOLBAS.pol_flag%TYPE,
          p_par_type       IN  GIPI_PARLIST.par_type%TYPE);
          
     PROCEDURE CREATE_PAR_DISTR_RECS_016
          (p_dist_no       IN   GIUW_POL_DIST.dist_no%TYPE,
           p_par_id        IN   GIPI_PARLIST.par_id%TYPE,
           p_line_cd       IN   GIPI_PARLIST.line_cd%TYPE,
           p_subline_cd    IN   GIPI_WPOLBAS.subline_cd%TYPE,
           p_iss_cd        IN   GIPI_WPOLBAS.iss_cd%TYPE,
           p_pack_pol_flag IN   GIPI_WPOLBAS.pack_pol_flag%TYPE,
           p_policy_id     IN   GIUW_POL_DIST.policy_id%TYPE,
           p_pol_flag      IN   GIPI_WPOLBAS.pol_flag%TYPE,
           p_par_type      IN   GIPI_PARLIST.par_type%TYPE);
           
     PROCEDURE CREATE_ITEMS_GIUWS016 
         (p_dist_no       IN   GIUW_POL_DIST.dist_no%TYPE,
          p_par_id        IN   GIPI_PARLIST.par_id%TYPE,
          p_line_cd       IN   GIPI_PARLIST.line_cd%TYPE,
          p_subline_cd    IN   GIPI_WPOLBAS.subline_cd%TYPE,
          p_iss_cd        IN   GIPI_WPOLBAS.iss_cd%TYPE,
          p_pack_pol_flag IN   GIPI_WPOLBAS.pack_pol_flag%TYPE,
          p_policy_id     IN   GIUW_POL_DIST.policy_id%TYPE,
          p_pol_flag      IN   GIPI_WPOLBAS.pol_flag%TYPE,
          p_par_type      IN   GIPI_PARLIST.par_type%TYPE);
          
    PROCEDURE POLICY_NEGATED_CHECK_GIUWS016 (p_facul_sw     IN OUT VARCHAR2,
                                             p_policy_id    IN     GIPI_POLBASIC_POL_DIST_V1.policy_id%TYPE,
                                             p_dist_no      IN     GIUW_POL_DIST.dist_no%TYPE,
                                             p_line_cd      IN     GIPI_POLBASIC_POL_DIST_V1.line_cd%TYPE,
                                             p_subline_cd   IN     GIPI_POLBASIC_POL_DIST_V1.subline_cd%TYPE);
    
    PROCEDURE POST_DIST_GIUWS016(p_policy_id         IN     GIPI_POLBASIC_POL_DIST_V1.policy_id%TYPE,
                                 p_dist_no           IN     GIUW_POL_DIST.dist_no%TYPE,
                                 p_par_id            IN     GIUW_POL_DIST.par_id%TYPE,
                                 p_line_cd           IN     GIPI_POLBASIC_POL_DIST_V1.line_cd%TYPE,
                                 p_subline_cd        IN     GIPI_POLBASIC_POL_DIST_V1.subline_cd%TYPE,
                                 p_iss_cd            IN     GIPI_POLBASIC_POL_DIST_V1.iss_cd%TYPE,
                                 p_issue_yy          IN     GIPI_POLBASIC_POL_DIST_V1.issue_yy%TYPE,
                                 p_pol_seq_no        IN     GIPI_POLBASIC_POL_DIST_V1.pol_seq_no%TYPE,
                                 p_renew_no          IN     GIPI_POLBASIC_POL_DIST_V1.renew_no%TYPE,
                                 p_par_type          IN     GIPI_POLBASIC_POL_DIST_V1.par_type%TYPE,
                                 p_pol_flag          IN     GIPI_POLBASIC_POL_DIST_V1.pol_flag%TYPE,
                                 p_eff_date          IN     GIPI_POLBASIC_POL_DIST_V1.eff_date%TYPE,
                                 p_batch_id          IN     GIUW_POL_DIST.batch_id%TYPE,
                                 p_dist_seq_no       IN     GIUW_POLICYDS_DTL.dist_seq_no%TYPE,
                                 p_message           OUT    VARCHAR2,
                                 p_workflow_msgr     OUT    VARCHAR2,
                                 p_v_facul_sw        OUT    VARCHAR2);
          
    PROCEDURE POST_FORMS_COMMIT_GIUWS016( p_dist_no      IN    GIUW_POL_DIST.dist_no%TYPE,
                                          p_policy_id    IN    GIUW_POL_DIST.policy_id%TYPE,
                                          p_batch_id     IN    GIUW_POL_DIST.batch_id%TYPE,
										  p_dist_seq_no  IN    GIUW_WPOLICYDS.dist_seq_no%TYPE
										  );
     
    PROCEDURE DELETE_DIST_WORKING_TABLES_017(p_dist_no  giuw_pol_dist.dist_no%TYPE);         
     
    PROCEDURE CREATE_GRP_DFLT_WPERILDS_017
             (p_dist_no            IN giuw_wperilds_dtl.dist_no%TYPE      ,
              p_dist_seq_no        IN giuw_wperilds_dtl.dist_seq_no%TYPE  ,
              p_line_cd            IN giuw_wperilds_dtl.line_cd%TYPE      ,
              p_peril_cd        IN giuw_wperilds_dtl.peril_cd%TYPE     ,
              p_dist_tsi        IN giuw_wperilds_dtl.dist_tsi%TYPE     ,
              p_dist_prem        IN giuw_wperilds_dtl.dist_prem%TYPE    ,
              p_ann_dist_tsi    IN giuw_wperilds_dtl.ann_dist_tsi%TYPE ,
              p_rg_count        IN NUMBER,
              p_pol_flag        IN gipi_wpolbas.pol_flag%TYPE,
              p_par_type        IN gipi_parlist.par_type%TYPE,
              p_par_id          IN gipi_wpolbas.par_id%TYPE,
              p_policy_id       IN gipi_polbasic.policy_id%TYPE
              );
                
    PROCEDURE CREATE_GRP_DFLT_WITEMDS_017
             (p_dist_no            IN giuw_witemds_dtl.dist_no%TYPE      ,
              p_dist_seq_no        IN giuw_witemds_dtl.dist_seq_no%TYPE  ,
              p_item_no            IN giuw_witemds_dtl.item_no%TYPE      ,
              p_line_cd            IN giuw_witemds_dtl.line_cd%TYPE      ,
              p_dist_tsi        IN giuw_witemds_dtl.dist_tsi%TYPE     ,
              p_dist_prem        IN giuw_witemds_dtl.dist_prem%TYPE    ,
              p_ann_dist_tsi    IN giuw_witemds_dtl.ann_dist_tsi%TYPE ,
              p_rg_count        IN NUMBER,
              p_pol_flag        IN gipi_wpolbas.pol_flag%TYPE,
              p_par_type        IN gipi_parlist.par_type%TYPE,
              p_policy_id       IN gipi_polbasic.policy_id%TYPE
              );
                   
    PROCEDURE CREATE_GRP_DFLT_WITEMPERILDS17
             (p_dist_no                IN giuw_witemperilds_dtl.dist_no%TYPE      ,
              p_dist_seq_no            IN giuw_witemperilds_dtl.dist_seq_no%TYPE  ,
              p_item_no                IN giuw_witemperilds_dtl.item_no%TYPE      ,
              p_line_cd                IN giuw_witemperilds_dtl.line_cd%TYPE      ,
              p_peril_cd            IN giuw_witemperilds_dtl.peril_cd%TYPE     ,
              p_dist_tsi            IN giuw_witemperilds_dtl.dist_tsi%TYPE     ,
              p_dist_prem            IN giuw_witemperilds_dtl.dist_prem%TYPE    ,
              p_ann_dist_tsi        IN giuw_witemperilds_dtl.ann_dist_tsi%TYPE ,
              p_rg_count            IN NUMBER,
              p_pol_flag            IN gipi_wpolbas.pol_flag%TYPE,
              p_par_type            IN gipi_parlist.par_type%TYPE,
              p_par_id              IN gipi_wpolbas.par_id%TYPE,
              p_policy_id           IN gipi_polbasic.policy_id%TYPE
              );
                         
    PROCEDURE update_witemds (
        p_dist_no         giuw_witemperilds_dtl.dist_no%type,
        p_dist_seq_no giuw_witemperilds_dtl.dist_no%type
        );
        
    PROCEDURE CREATE_GRP_DFLT_WPOLICYDS_017
             (p_dist_no                IN giuw_wpolicyds_dtl.dist_no%TYPE      ,
              p_dist_seq_no            IN giuw_wpolicyds_dtl.dist_seq_no%TYPE  ,
              p_line_cd                IN giuw_wpolicyds_dtl.line_cd%TYPE      ,
              p_dist_tsi            IN giuw_wpolicyds_dtl.dist_tsi%TYPE     ,
              p_dist_prem            IN giuw_wpolicyds_dtl.dist_prem%TYPE    ,
              p_ann_dist_tsi        IN giuw_wpolicyds_dtl.ann_dist_tsi%TYPE ,
              p_rg_count            IN OUT NUMBER                           ,
              p_default_type        IN giis_default_dist.default_type%TYPE  ,
              p_currency_rt         IN gipi_witem.currency_rt%TYPE          ,
              p_par_id              IN gipi_parlist.par_id%TYPE             ,
              p_item_grp            IN gipi_witem.item_grp%TYPE             ,
              p_pol_flag            IN gipi_wpolbas.pol_flag%TYPE           ,
              p_par_type            IN gipi_parlist.par_type%TYPE
              );
                  
    PROCEDURE inherit_dist_pct (
        p_dist_no               NUMBER,
        p_par_type              gipi_parlist.par_type%TYPE,
        p_par_id                gipi_parlist.par_id%TYPE,
        p_policy_id             gipi_polbasic.policy_id%TYPE
        );
        
    PROCEDURE CREATE_GRP_DFLT_DIST_017(
            p_dist_no              IN giuw_wpolicyds.dist_no%TYPE,
            p_dist_seq_no       IN giuw_wpolicyds.dist_seq_no%TYPE,
            p_dist_flag         IN giuw_wpolicyds.dist_flag%TYPE,
            p_policy_tsi        IN giuw_wpolicyds.tsi_amt%TYPE,
            p_policy_premium    IN giuw_wpolicyds.prem_amt%TYPE,
            p_policy_ann_tsi    IN giuw_wpolicyds.ann_tsi_amt%TYPE,
            p_item_grp          IN giuw_wpolicyds.item_grp%TYPE,
            p_line_cd           IN giis_line.line_cd%TYPE,
            p_rg_count          IN OUT NUMBER,
            p_default_type      IN giis_default_dist.default_type%TYPE,
            p_currency_rt       IN gipi_witem.currency_rt%TYPE,
            p_pol_flag          IN gipi_wpolbas.pol_flag%TYPE,
            p_par_type          IN gipi_parlist.par_type%TYPE,
            p_par_id            IN gipi_wpolbas.par_id%TYPE,
            p_policy_id         IN gipi_polbasic.policy_id%TYPE
            );
            
    PROCEDURE CHECK_AUTO_DIST1(
        p_dist_no           IN     GIUW_POL_DIST.dist_no%TYPE,
        p_par_id            IN     gipi_wpolbas.par_id%TYPE,
        p_line_cd           IN     GIPI_POLBASIC.line_cd%TYPE
        );               
                 
    PROCEDURE CREATE_ITEMS_GIUWS017(
        p_dist_no           IN      GIUW_POL_DIST.dist_no%TYPE,
        p_par_id            IN      gipi_wpolbas.par_id%TYPE,
        p_line_cd           IN      GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd        IN      GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd            IN      GIPI_POLBASIC.iss_cd%TYPE,
        p_pack_pol_flag     IN      GIPI_POLBASIC.pack_pol_flag%TYPE,
        p_pol_flag          IN      gipi_wpolbas.pol_flag%TYPE,
        p_par_type          IN      gipi_parlist.par_type%TYPE,
        p_policy_id         IN      GIPI_POLBASIC.policy_id%TYPE
        );
           
    PROCEDURE ADJUST_NET_RET_IMP_017(
        p_dist_no        giuw_wpolicyds.dist_no%TYPE
        );
    PROCEDURE pfc_giuws017_batch_id(
        p_dist_no           IN      GIUW_POL_DIST.dist_no%TYPE, 
        p_batch_id          IN OUT  giuw_pol_dist.batch_id%TYPE);
           
    PROCEDURE post_form_commit_giuws017(
        p_dist_no           IN      GIUW_POL_DIST.dist_no%TYPE, 
        --p_dist_seq_no       IN      giuw_wperilds.dist_seq_no%TYPE,
        --p_line_cd           IN      giuw_wperilds.line_cd%TYPE,
        --p_peril_cd          IN      giuw_wperilds.peril_cd%TYPE,
        p_pol_flag          IN      gipi_wpolbas.pol_flag%TYPE,
        p_par_type          IN      gipi_parlist.par_type%TYPE,
        p_policy_id         IN      GIPI_POLBASIC.policy_id%TYPE
        --p_batch_id          IN OUT  giuw_pol_dist.batch_id%TYPE
        );
          
    PROCEDURE post_dist_giuws017(
        p_dist_no           IN     GIUW_POL_DIST.dist_no%TYPE,
        p_dist_seq_no       IN     GIUW_POLICYDS_DTL.dist_seq_no%TYPE,
        p_policy_id         IN     GIPI_POLBASIC_POL_DIST_V1.policy_id%TYPE,
        p_par_id            IN     GIUW_POL_DIST.par_id%TYPE,
        p_line_cd           IN     GIPI_POLBASIC_POL_DIST_V1.line_cd%TYPE,
        p_subline_cd        IN     GIPI_POLBASIC_POL_DIST_V1.subline_cd%TYPE,
        p_iss_cd            IN     GIPI_POLBASIC_POL_DIST_V1.iss_cd%TYPE,
        p_issue_yy          IN     GIPI_POLBASIC_POL_DIST_V1.issue_yy%TYPE,
        p_pol_seq_no        IN     GIPI_POLBASIC_POL_DIST_V1.pol_seq_no%TYPE,
        p_renew_no          IN     GIPI_POLBASIC_POL_DIST_V1.renew_no%TYPE,
        p_eff_date          IN     GIPI_POLBASIC_POL_DIST_V1.eff_date%TYPE,
        p_peril_cd          IN     GIUW_WPERILDS.peril_cd%TYPE,
        p_batch_id          IN OUT GIUW_POL_DIST.batch_id%TYPE,
        p_msg_alert         OUT    VARCHAR2,
        p_workflow_msgr     OUT    VARCHAR2
        );    

    PROCEDURE CREATE_GRP_DFLT_PERILDS999
             (p_dist_no		    IN giuw_perilds_dtl.dist_no%TYPE      ,
              p_dist_seq_no		IN giuw_perilds_dtl.dist_seq_no%TYPE  ,
              p_line_cd		    IN giuw_perilds_dtl.line_cd%TYPE      ,
              p_peril_cd		IN giuw_perilds_dtl.peril_cd%TYPE     ,
              p_dist_tsi		IN giuw_perilds_dtl.dist_tsi%TYPE     ,
              p_dist_prem		IN giuw_perilds_dtl.dist_prem%TYPE    ,
              p_ann_dist_tsi	IN giuw_perilds_dtl.ann_dist_tsi%TYPE ,
              p_rg_count		IN NUMBER);

    PROCEDURE CREATE_GRP_DFLT_POLICYDS999
             (p_dist_no	   	    IN  giuw_policyds_dtl.dist_no%TYPE      ,
              p_dist_seq_no		IN  giuw_policyds_dtl.dist_seq_no%TYPE  ,
              p_line_cd		    IN  giuw_policyds_dtl.line_cd%TYPE      ,
              p_dist_tsi		IN  giuw_policyds_dtl.dist_tsi%TYPE     ,
              p_dist_prem	    IN  giuw_policyds_dtl.dist_prem%TYPE    ,
              p_ann_dist_tsi	IN  giuw_policyds_dtl.ann_dist_tsi%TYPE ,
              p_rg_count	    IN  OUT NUMBER                           ,
              p_default_type	IN  giis_default_dist.default_type%TYPE  ,
              p_currency_rt     IN  gipi_item.currency_rt%TYPE          ,
              p_policy_id       IN  gipi_polbasic.policy_id%TYPE         ,
              p_item_grp	    IN  gipi_item.item_grp%TYPE);
    
    PROCEDURE CREATE_GRP_DFLT_ITEMDS999
             (p_dist_no		    IN giuw_itemds_dtl.dist_no%TYPE      ,
              p_dist_seq_no		IN giuw_itemds_dtl.dist_seq_no%TYPE  ,
              p_item_no		    IN giuw_itemds_dtl.item_no%TYPE      ,
              p_line_cd		    IN giuw_itemds_dtl.line_cd%TYPE      ,
              p_dist_tsi		IN giuw_itemds_dtl.dist_tsi%TYPE     ,
              p_dist_prem		IN giuw_itemds_dtl.dist_prem%TYPE    ,
              p_ann_dist_tsi	IN giuw_itemds_dtl.ann_dist_tsi%TYPE ,
              p_rg_count		IN NUMBER);       

    PROCEDURE CREATE_GRP_DFLT_ITEMPERILDS999
             (p_dist_no		    IN giuw_itemperilds_dtl.dist_no%TYPE      ,
              p_dist_seq_no		IN giuw_itemperilds_dtl.dist_seq_no%TYPE  ,
              p_item_no		    IN giuw_itemperilds_dtl.item_no%TYPE      ,
              p_line_cd		    IN giuw_itemperilds_dtl.line_cd%TYPE      ,
              p_peril_cd		IN giuw_itemperilds_dtl.peril_cd%TYPE     ,
              p_dist_tsi		IN giuw_itemperilds_dtl.dist_tsi%TYPE     ,
              p_dist_prem		IN giuw_itemperilds_dtl.dist_prem%TYPE    ,
              p_ann_dist_tsi	IN giuw_itemperilds_dtl.ann_dist_tsi%TYPE ,
              p_rg_count		IN NUMBER);
              
    PROCEDURE CREATE_GRP_DFLT_DIST999(p_dist_no        IN giuw_policyds.dist_no%TYPE,
                                   p_dist_seq_no    IN giuw_policyds.dist_seq_no%TYPE,
                                   p_dist_flag      IN giuw_pol_dist.dist_flag%TYPE,
                                   p_policy_tsi     IN giuw_policyds.tsi_amt%TYPE,
                                   p_policy_premium IN giuw_policyds.prem_amt%TYPE,
                                   p_policy_ann_tsi IN giuw_policyds.ann_tsi_amt%TYPE,
                                   p_item_grp       IN giuw_policyds.item_grp%TYPE,
                                   p_line_cd        IN giis_line.line_cd%TYPE,
                                   p_rg_count       IN OUT NUMBER,
                                   p_default_type   IN giis_default_dist.default_type%TYPE,
                                   p_currency_rt    IN gipi_item.currency_rt%TYPE,
                                   p_policy_id      IN gipi_polbasic.policy_id%TYPE);              

    PROCEDURE CREATE_GRP_DFLT_PERILDS_RI999
             (p_dist_no		    IN giuw_perilds_dtl.dist_no%TYPE      ,
              p_dist_seq_no		IN giuw_perilds_dtl.dist_seq_no%TYPE  ,
              p_line_cd		    IN giuw_perilds_dtl.line_cd%TYPE      ,
              p_peril_cd		IN giuw_perilds_dtl.peril_cd%TYPE     ,
              p_dist_tsi		IN giuw_perilds_dtl.dist_tsi%TYPE     ,
              p_dist_prem		IN giuw_perilds_dtl.dist_prem%TYPE    ,
              p_ann_dist_tsi	IN giuw_perilds_dtl.ann_dist_tsi%TYPE ,
              p_rg_count		IN NUMBER,
              p_fac_spct        IN  giri_distfrps.tot_fac_spct%TYPE);
              
    PROCEDURE CREATE_GRP_DFLT_POLICYDS_RI999
             (p_dist_no	   	    IN  giuw_policyds_dtl.dist_no%TYPE      ,
              p_dist_seq_no		IN  giuw_policyds_dtl.dist_seq_no%TYPE  ,
              p_line_cd		    IN  giuw_policyds_dtl.line_cd%TYPE      ,
              p_dist_tsi		IN  giuw_policyds_dtl.dist_tsi%TYPE     ,
              p_dist_prem		IN  giuw_policyds_dtl.dist_prem%TYPE    ,
              p_ann_dist_tsi	IN  giuw_policyds_dtl.ann_dist_tsi%TYPE ,
              p_rg_count		IN  OUT NUMBER                           ,
              p_default_type	IN  giis_default_dist.default_type%TYPE  ,
              p_currency_rt     IN  gipi_item.currency_rt%TYPE          ,
              p_policy_id       IN  gipi_polbasic.policy_id%TYPE         ,
              p_item_grp		IN  gipi_item.item_grp%TYPE,
              p_fac_spct        IN  giri_distfrps.tot_fac_spct%TYPE,
              p_fac_tsi         IN  giri_distfrps.tot_fac_tsi%TYPE,
              p_fac_prem        IN  giri_distfrps.tot_fac_prem%TYPE);
              
    PROCEDURE CREATE_GRP_DFLT_ITEMDS_RI999
             (p_dist_no		    IN giuw_itemds_dtl.dist_no%TYPE      ,
              p_dist_seq_no		IN giuw_itemds_dtl.dist_seq_no%TYPE  ,
              p_item_no		    IN giuw_itemds_dtl.item_no%TYPE      ,
              p_line_cd		    IN giuw_itemds_dtl.line_cd%TYPE      ,
              p_dist_tsi		IN giuw_itemds_dtl.dist_tsi%TYPE     ,
              p_dist_prem		IN giuw_itemds_dtl.dist_prem%TYPE    ,
              p_ann_dist_tsi	IN giuw_itemds_dtl.ann_dist_tsi%TYPE ,
              p_rg_count		IN NUMBER,
              p_fac_spct        IN  giri_distfrps.tot_fac_spct%TYPE);

    PROCEDURE CREATE_GRP_DFLT_ITEMPERILDS_RI
             (p_dist_no		    IN giuw_itemperilds_dtl.dist_no%TYPE      ,
              p_dist_seq_no		IN giuw_itemperilds_dtl.dist_seq_no%TYPE  ,
              p_item_no		    IN giuw_itemperilds_dtl.item_no%TYPE      ,
              p_line_cd		    IN giuw_itemperilds_dtl.line_cd%TYPE      ,
              p_peril_cd		IN giuw_itemperilds_dtl.peril_cd%TYPE     ,
              p_dist_tsi		IN giuw_itemperilds_dtl.dist_tsi%TYPE     ,
              p_dist_prem		IN giuw_itemperilds_dtl.dist_prem%TYPE    ,
              p_ann_dist_tsi	IN giuw_itemperilds_dtl.ann_dist_tsi%TYPE ,
              p_rg_count		IN NUMBER,
              p_fac_spct        IN  giri_distfrps.tot_fac_spct%TYPE);

    PROCEDURE CREATE_GRP_DFLT_DIST_RI999(p_dist_no        IN giuw_policyds.dist_no%TYPE,
                                   p_dist_seq_no    IN giuw_policyds.dist_seq_no%TYPE,
                                   p_dist_flag      IN giuw_pol_dist.dist_flag%TYPE,
                                   p_policy_tsi     IN giuw_policyds.tsi_amt%TYPE,
                                   p_policy_premium IN giuw_policyds.prem_amt%TYPE,
                                   p_policy_ann_tsi IN giuw_policyds.ann_tsi_amt%TYPE,
                                   p_item_grp       IN giuw_policyds.item_grp%TYPE,
                                   p_line_cd        IN giis_line.line_cd%TYPE,
                                   p_rg_count       IN OUT NUMBER,
                                   p_default_type   IN giis_default_dist.default_type%TYPE,
                                   p_currency_rt    IN gipi_item.currency_rt%TYPE,
                                   p_policy_id      IN gipi_polbasic.policy_id%TYPE);

    PROCEDURE CREATE_PERIL_DFLT_ITEMPERILDS
             (p_dist_no       IN giuw_perilds_dtl.dist_no%TYPE,
              p_dist_seq_no   IN giuw_perilds_dtl.dist_seq_no%TYPE,
              p_line_cd       IN giuw_perilds_dtl.line_cd%TYPE,
              p_peril_cd      IN giuw_perilds_dtl.peril_cd%TYPE,
              p_share_cd      IN giuw_perilds_dtl.share_cd%TYPE,
              p_dist_spct     IN giuw_perilds_dtl.dist_spct%TYPE,
              p_ann_dist_spct IN giuw_perilds_dtl.ann_dist_spct%TYPE);
              
    PROCEDURE CREATE_PERIL_DFLT_PERILDS
             (p_dist_no         IN giuw_perilds_dtl.dist_no%TYPE      ,
              p_dist_seq_no     IN giuw_perilds_dtl.dist_seq_no%TYPE  ,
              p_line_cd         IN giuw_perilds_dtl.line_cd%TYPE      ,
              p_peril_cd        IN giuw_perilds_dtl.peril_cd%TYPE     ,
              p_dist_tsi        IN giuw_perilds_dtl.dist_tsi%TYPE     ,
              p_dist_prem       IN giuw_perilds_dtl.dist_prem%TYPE    ,
              p_ann_dist_tsi    IN giuw_perilds_dtl.ann_dist_tsi%TYPE ,
              p_currency_rt     IN gipi_invoice.currency_rt%TYPE      ,
              p_default_no      IN giis_default_dist.default_no%TYPE   ,
              p_default_type    IN giis_default_dist.default_type%TYPE ,
              p_dflt_netret_pct IN giis_default_dist.dflt_netret_pct%TYPE);
              
    PROCEDURE CREATE_PERIL_DFLT_PERILDS_RI
             (p_dist_no         IN giuw_perilds_dtl.dist_no%TYPE      ,
              p_dist_seq_no     IN giuw_perilds_dtl.dist_seq_no%TYPE  ,
              p_line_cd         IN giuw_perilds_dtl.line_cd%TYPE      ,
              p_peril_cd        IN giuw_perilds_dtl.peril_cd%TYPE     ,
              p_dist_tsi        IN giuw_perilds_dtl.dist_tsi%TYPE     ,
              p_dist_prem       IN giuw_perilds_dtl.dist_prem%TYPE    ,
              p_ann_dist_tsi    IN giuw_perilds_dtl.ann_dist_tsi%TYPE ,
              p_currency_rt     IN gipi_invoice.currency_rt%TYPE      ,
              p_default_no      IN giis_default_dist.default_no%TYPE   ,
              p_default_type    IN giis_default_dist.default_type%TYPE ,
              p_dflt_netret_pct IN giis_default_dist.dflt_netret_pct%TYPE,
              p_fac_spct        IN giri_distfrps.tot_fac_spct%TYPE);

    PROCEDURE CREATE_PERIL_DFLT_ITEMDS(p_dist_no     IN giuw_pol_dist.dist_no%TYPE,
                                       p_dist_seq_no IN giuw_policyds.dist_seq_no%TYPE) ;
                 
    PROCEDURE CREATE_PERIL_DFLT_POLICYDS(p_dist_no     IN giuw_pol_dist.dist_no%TYPE,
                                         p_dist_seq_no IN giuw_policyds.dist_seq_no%TYPE);
                                         
    PROCEDURE CREATE_PERIL_DFLT_DIST999(p_dist_no         IN giuw_policyds.dist_no%TYPE,
                                     p_dist_seq_no     IN giuw_policyds.dist_seq_no%TYPE,
                                     p_dist_flag       IN giuw_pol_dist.dist_flag%TYPE,
                                     p_policy_tsi      IN giuw_policyds.tsi_amt%TYPE,
                                     p_policy_premium  IN giuw_policyds.prem_amt%TYPE,
                                     p_policy_ann_tsi  IN giuw_policyds.ann_tsi_amt%TYPE,
                                     p_item_grp        IN giuw_policyds.item_grp%TYPE,
                                     p_line_cd         IN giis_line.line_cd%TYPE,
                                     p_default_no      IN giis_default_dist.default_no%TYPE,
                                     p_default_type    IN giis_default_dist.default_type%TYPE,
                                     p_dflt_netret_pct IN giis_default_dist.dflt_netret_pct%TYPE,
                                     p_currency_rt     IN gipi_item.currency_rt%TYPE,
                                     p_policy_id       IN gipi_polbasic.policy_id%TYPE,
                                     p_ri_sw           IN VARCHAR2);
                                     
    PROCEDURE ADJUST_FINAL_GIUWS015(p_dist_no IN GIUW_POL_DIST.dist_no%TYPE);
    
    PROCEDURE DELETE_DIST_TABLES_GIUWS015(p_dist_no IN GIUW_POL_DIST.dist_no%TYPE);
    
    PROCEDURE DEL_DIST_WORK_TABLES_GIUWS015 (p_dist_no IN GIUW_POL_DIST.dist_no%TYPE);
    
    PROCEDURE DELETE_RI_TABLES_GIUWS015(p_batch_id   IN   GIUW_POL_DIST.batch_id%TYPE);
    
    PROCEDURE TABLE_UPDATES_GIUWS015(p_batch_id      IN    GIUW_POL_DIST_POLBASIC_V.batch_id%TYPE,
                                     p_policy_id     IN    GIUW_POL_DIST_POLBASIC_V.policy_id%TYPE,
                                     p_dist_no       IN    GIUW_POL_DIST_POLBASIC_V.dist_no%TYPE,
                                     p_line_cd       IN    GIUW_POL_DIST_POLBASIC_V.line_cd%TYPE,
                                     p_subline_cd    IN    GIUW_POL_DIST_POLBASIC_V.subline_cd%TYPE,
                                     p_iss_cd        IN    GIUW_POL_DIST_POLBASIC_V.iss_cd%TYPE,
                                     p_issue_yy      IN    GIUW_POL_DIST_POLBASIC_V.issue_yy%TYPE,
                                     p_pol_seq_no    IN    GIUW_POL_DIST_POLBASIC_V.pol_seq_no%TYPE,
                                     p_renew_no      IN    GIUW_POL_DIST_POLBASIC_V.renew_no%TYPE,
                                     p_user_id       IN    GIUW_POL_DIST_POLBASIC_V.user_id%TYPE);
    
    FUNCTION get_pol_dist_by_batch_id(p_batch_id    IN  GIUW_POL_DIST.batch_id%TYPE)
    RETURN giuw_pol_dist_final_tab PIPELINED;
    
    PROCEDURE TABLE_UPDATES_GIUWS015_A(p_facul_sw      IN    VARCHAR2,
                                       p_policy_id     IN    GIUW_POL_DIST_POLBASIC_V.policy_id%TYPE,
                                       p_dist_no       IN    GIUW_POL_DIST_POLBASIC_V.dist_no%TYPE,
                                       p_line_cd       IN    GIUW_POL_DIST_POLBASIC_V.line_cd%TYPE,
                                       p_subline_cd    IN    GIUW_POL_DIST_POLBASIC_V.subline_cd%TYPE,
                                       p_iss_cd        IN    GIUW_POL_DIST_POLBASIC_V.iss_cd%TYPE,
                                       p_issue_yy      IN    GIUW_POL_DIST_POLBASIC_V.issue_yy%TYPE,
                                       p_pol_seq_no    IN    GIUW_POL_DIST_POLBASIC_V.pol_seq_no%TYPE,
                                       p_renew_no      IN    GIUW_POL_DIST_POLBASIC_V.renew_no%TYPE,
                                       p_user_id       IN    GIUW_POL_DIST_POLBASIC_V.user_id%TYPE);
                                       
    PROCEDURE TABLE_UPDATES_GIUWS015_B(p_facul_sw      IN    VARCHAR2,
                                       p_policy_id     IN    GIUW_POL_DIST_POLBASIC_V.policy_id%TYPE,
                                       p_dist_no       IN    GIUW_POL_DIST_POLBASIC_V.dist_no%TYPE,
                                       p_user_id       IN    GIUW_POL_DIST_POLBASIC_V.user_id%TYPE,
                                       p_message       OUT   VARCHAR2,
                                       p_workflow_msg  OUT   VARCHAR2);

    FUNCTION get_giuw_witemperilds_rec(
        p_dist_no   gipi_polbasic_pol_dist_v1.dist_no%TYPE
    )
        RETURN giuw_witemperilds_rec_tab PIPELINED;      

     PROCEDURE CRTE_REGRPED_DIST_RECS_FINAL
         (p_dist_no       IN giuw_pol_dist.dist_no%TYPE    ,
          p_policy_id     IN gipi_polbasic.policy_id%TYPE  ,
          p_line_cd       IN gipi_polbasic.line_cd%TYPE    ,
          p_subline_cd    IN gipi_polbasic.subline_cd%TYPE ,
          p_iss_cd        IN gipi_polbasic.iss_cd%TYPE     ,
          p_pack_pol_flag IN gipi_polbasic.pack_pol_flag%TYPE);                                              

    PROCEDURE validate_item_peril_amt_shr (p_dist_no       GIUW_POL_DIST_POLBASIC_V.dist_no%TYPE,
                                           p_module_id     VARCHAR2);
                         
						 
	-- shan 07.29.2014
    PROCEDURE CRT_GRP_DFLT_WITEMDS_GW18 (
          p_dist_no            IN giuw_witemds_dtl.dist_no%TYPE      ,
          p_dist_seq_no        IN giuw_witemds_dtl.dist_seq_no%TYPE  ,
          p_item_no            IN giuw_witemds_dtl.item_no%TYPE      ,
          p_line_cd            IN giuw_witemds_dtl.line_cd%TYPE      ,
          p_dist_tsi        IN giuw_witemds_dtl.dist_tsi%TYPE     ,
          p_dist_prem        IN giuw_witemds_dtl.dist_prem%TYPE    ,
          p_ann_dist_tsi    IN giuw_witemds_dtl.ann_dist_tsi%TYPE ,
          p_rg_count        IN NUMBER,
          p_v_default_no    IN giis_default_dist.default_no%TYPE
     );
     
     PROCEDURE CRT_GRP_DFLT_WITEMPERILDS_GW18(
          p_dist_no            IN giuw_witemperilds_dtl.dist_no%TYPE      ,
          p_dist_seq_no        IN giuw_witemperilds_dtl.dist_seq_no%TYPE  ,
          p_item_no            IN giuw_witemperilds_dtl.item_no%TYPE      ,
          p_line_cd            IN giuw_witemperilds_dtl.line_cd%TYPE      ,
          p_peril_cd        IN giuw_witemperilds_dtl.peril_cd%TYPE     ,
          p_dist_tsi        IN giuw_witemperilds_dtl.dist_tsi%TYPE     ,
          p_dist_prem        IN giuw_witemperilds_dtl.dist_prem%TYPE    ,
          p_ann_dist_tsi    IN giuw_witemperilds_dtl.ann_dist_tsi%TYPE ,
          p_rg_count        IN NUMBER,
          p_v_default_no    IN giis_default_dist.default_no%TYPE
      );
      
      PROCEDURE CRT_GRP_DFLT_WPERILDS_GW18(
          p_dist_no            IN giuw_wperilds_dtl.dist_no%TYPE      ,
          p_dist_seq_no        IN giuw_wperilds_dtl.dist_seq_no%TYPE  ,
          p_line_cd            IN giuw_wperilds_dtl.line_cd%TYPE      ,
          p_peril_cd        IN giuw_wperilds_dtl.peril_cd%TYPE     ,
          p_dist_tsi        IN giuw_wperilds_dtl.dist_tsi%TYPE     ,
          p_dist_prem        IN giuw_wperilds_dtl.dist_prem%TYPE    ,
          p_ann_dist_tsi    IN giuw_wperilds_dtl.ann_dist_tsi%TYPE ,
          p_rg_count        IN NUMBER,
          p_v_default_no    IN giis_default_dist.default_no%TYPE
      );
      
     --added by steven 08.05.2014
     PROCEDURE validate_before_post_giuws017 (
         p_dist_no           IN      GIUW_POL_DIST.dist_no%TYPE, 
         p_policy_id         IN      GIPI_POLBASIC.policy_id%TYPE
     );
     
     PROCEDURE check_peril_dist_per_share (
      p_dist_no     IN       giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no IN       VARCHAR2,
      p_share_cd    IN       VARCHAR2,
      p_peril_cd    IN       giis_peril.peril_cd%TYPE
     );        
     
     PROCEDURE check_posted_binder (
      p_policy_id       IN  giuw_pol_dist.par_id%TYPE,
      p_dist_no         IN  giuw_pol_dist.dist_no%TYPE,
      p_alert          OUT  VARCHAR2 
    );
    
    -- added by jhing 11.25.2014    
    PROCEDURE populate_oth_tbls_one_risk (
      p_dist_no         IN  giuw_pol_dist.dist_no%TYPE 
    ); 

    -- added by jhing 11.25.2014     
    PROCEDURE populate_oth_tbls_peril_dist (
      p_dist_no         IN  giuw_pol_dist.dist_no%TYPE 
    );   
    
    -- added by jhing 11.25.2014       
    PROCEDURE insert_setup_dflt_group_values (
      p_dist_no         IN  giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no     IN  giuw_policyds.dist_seq_no%TYPE ,
      p_rg_count        IN  NUMBER ,
      p_default_no      IN  giis_default_dist.default_no%TYPE ,
      p_default_type    IN  giis_default_dist.default_type%TYPE,
      p_line_cd         IN  giis_line.line_cd%TYPE ,
      p_tsi_amt         IN  giuw_policyds.tsi_amt%TYPE,
      p_prem_amt        IN  giuw_policyds.prem_amt%TYPE,
      p_ann_tsi_amt     IN  giuw_policyds.ann_tsi_amt%TYPE,
      p_currency_rt     IN  gipi_item.currency_rt%TYPE
    );  

    -- added by jhing 11.25.2014       
    PROCEDURE insert_setup_dflt_peril_values (
      p_dist_no         IN  giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no     IN  giuw_policyds.dist_seq_no%TYPE ,
      p_rg_count        IN  NUMBER ,
      p_default_no      IN  giis_default_dist.default_no%TYPE ,
      p_default_type    IN  giis_default_dist.default_type%TYPE,
      p_line_cd         IN  giis_line.line_cd%TYPE ,
      p_peril_cd        IN  giis_peril.peril_cd%TYPE,
      p_tsi_amt         IN  giuw_policyds.tsi_amt%TYPE,
      p_prem_amt        IN  giuw_policyds.prem_amt%TYPE,
      p_ann_tsi_amt     IN  giuw_policyds.ann_tsi_amt%TYPE,
      p_currency_rt     IN  gipi_item.currency_rt%TYPE
    );      
    
    PROCEDURE get_default_dist_params (
      p_dist_no         IN  giuw_pol_dist.dist_no%TYPE,
      p_policy_id       IN OUT giuw_pol_dist.policy_id%TYPE,
      p_post_flag       OUT giuw_pol_dist.post_flag%TYPE,
      p_line_cd         IN OUT giis_default_dist.line_cd%TYPE ,
      p_default_no      OUT giis_default_dist.default_no%TYPE , 
      p_dist_type       OUT giis_default_dist.dist_type%TYPE , 
      p_default_type    OUT giis_default_dist.default_type%TYPE,
      p_orig_dist_no    OUT giuw_pol_dist.dist_no%TYPE 
    );
    
    PROCEDURE populate_default_dist (
      p_dist_no         IN  giuw_pol_dist.dist_no%TYPE,
      p_post_flag       IN OUT giuw_pol_dist.post_flag%TYPE ,
      p_dist_type       IN OUT giuw_pol_dist.dist_type%TYPE
    );
    
    PROCEDURE update_dist_ds_prem (
      p_dist_no         IN giuw_pol_dist.dist_no%TYPE ,
      p_policy_id       IN gipi_polbasic.policy_id%TYPE
    );   
    
    PROCEDURE recrte_grp_ds_tables_giuws018 (
      p_dist_no         IN giuw_pol_dist.dist_no%TYPE ,
      p_policy_id       IN gipi_polbasic.policy_id%TYPE
    );   
    
    PROCEDURE validate_setup_dist_per_action  (
      p_dist_no         IN giuw_pol_dist.dist_no%TYPE ,
      p_policy_id       IN gipi_polbasic.policy_id%TYPE,
      p_action          IN VARCHAR2,
      p_module_id       IN giis_modules.module_id%TYPE
    );   
    
    PROCEDURE check_non_existing_basc_perl (
      p_policy_id       IN gipi_polbasic.policy_id%TYPE,
      p_result          OUT VARCHAR2
    );
    
    PROCEDURE check_missing_dist_rec_item (
      p_dist_no         IN giuw_pol_dist.dist_no%TYPE ,
      p_policy_id       IN gipi_polbasic.policy_id%TYPE,
      p_result          OUT VARCHAR2
    );    

    PROCEDURE check_missing_dist_rec_peril (
      p_dist_no         IN giuw_pol_dist.dist_no%TYPE ,
      p_policy_id       IN gipi_polbasic.policy_id%TYPE,
      p_result          OUT VARCHAR2
    );       
    PROCEDURE check_regrp_by_item (
      p_dist_no         IN giuw_pol_dist.dist_no%TYPE ,
      p_result          OUT VARCHAR2
    );     
      
    PROCEDURE check_regrp_by_peril (
      p_dist_no         IN giuw_pol_dist.dist_no%TYPE ,
      p_result          OUT VARCHAR2
    ); 
    
    PROCEDURE val_sequential_distGrp (
      p_dist_no         IN giuw_pol_dist.dist_no%TYPE ,
      p_module_id       IN giis_modules.module_id%TYPE,
      p_result          OUT VARCHAR2
    );   
        
    PROCEDURE val_multipleBillGrp_perDist (
      p_dist_no         IN giuw_pol_dist.dist_no%TYPE , 
      p_policy_id       IN gipi_polbasic.policy_id%TYPE,
      p_result          OUT VARCHAR2
    ); 
	--added by robert 10.13.15 GENQA 5053
	FUNCTION check_peril_dist (
      p_dist_no       IN   giuw_pol_dist.dist_no%TYPE,
      p_dist_seq_no   IN   VARCHAR2
    )
    RETURN BOOLEAN;
    
END GIUW_POL_DIST_FINAL_PKG;
/


