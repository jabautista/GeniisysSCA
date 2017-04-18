CREATE OR REPLACE PACKAGE CPI.GIUW_WITEMDS_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_giuw_witemds (p_dist_no 	GIUW_WITEMDS.dist_no%TYPE);
    
    PROCEDURE del_giuw_witemds(
        p_dist_no 	        GIUW_WITEMDS.dist_no%TYPE,
        p_dist_seq_no       GIUW_WITEMDS.dist_seq_no%TYPE
        );
    
    -- jhing 12.01.2014 added procedure      
    PROCEDURE del_giuw_witemds(
        p_dist_no 	        GIUW_WITEMDS.dist_no%TYPE,
        p_dist_seq_no       GIUW_WITEMDS.dist_seq_no%TYPE,
        p_item_no           GIUW_WITEMDS.item_no%TYPE
        );    
        
    TYPE giuw_witemds_type IS RECORD(
        dist_no                 giuw_witemds.dist_no%TYPE,
        dist_seq_no             giuw_witemds.dist_seq_no%TYPE,
        item_no                 giuw_witemds.item_no%TYPE,
        tsi_amt                 giuw_witemds.tsi_amt%TYPE,
        prem_amt                giuw_witemds.prem_amt%TYPE,
        ann_tsi_amt             giuw_witemds.ann_tsi_amt%TYPE,
        arc_ext_data            giuw_witemds.arc_ext_data%TYPE,
        nbt_item_title          gipi_witem.item_title%TYPE,
        nbt_item_desc           gipi_witem.item_desc%TYPE,
        dsp_pack_line_cd        gipi_witem.pack_line_cd%TYPE,
        dsp_pack_subline_cd     gipi_witem.pack_subline_cd%TYPE,
        item_grp                gipi_witem.item_grp%TYPE,
        nbt_currency_cd         gipi_witem.currency_cd%TYPE,
        dsp_currency_rt         gipi_witem.currency_rt%TYPE,
        dsp_short_name          giis_currency.short_name%TYPE,
        orig_dist_seq_no        giuw_witemds.dist_seq_no%TYPE,
        max_dist_seq_no			giuw_witemds.dist_seq_no%TYPE ,-- jhing 12.01.2014
        cnt_per_dist_grp        NUMBER  -- jhing 12.01.2014 
        );
        
    TYPE giuw_witemds_tab IS TABLE OF giuw_witemds_type;
    
    FUNCTION get_giuw_witemds(
        p_par_id    gipi_wpolbas.par_id%TYPE,
        p_dist_no 	GIUW_WITEMDS.dist_no%TYPE)
    RETURN giuw_witemds_tab PIPELINED;
         
    PROCEDURE set_giuw_witemds(
        p_dist_no               giuw_witemds.dist_no%TYPE,     
        p_dist_seq_no           giuw_witemds.dist_seq_no%TYPE,
        p_item_no               giuw_witemds.item_no%TYPE,     
        p_tsi_amt               giuw_witemds.tsi_amt%TYPE,
        p_prem_amt              giuw_witemds.prem_amt%TYPE,    
        p_ann_tsi_amt           giuw_witemds.ann_tsi_amt%TYPE,
        p_arc_ext_data          giuw_witemds.arc_ext_data%TYPE,
        p_orig_dist_seq_no      giuw_witemds.dist_seq_no%TYPE,
        p_item_grp              giuw_wpolicyds.item_grp%TYPE
        );
            
    PROCEDURE pre_update_giuw_witemds(
        p_dist_no               giuw_witemds.dist_no%TYPE,     
        p_dist_seq_no           giuw_witemds.dist_seq_no%TYPE,   
        p_tsi_amt               giuw_witemds.tsi_amt%TYPE,
        p_prem_amt              giuw_witemds.prem_amt%TYPE,    
        p_ann_tsi_amt           giuw_witemds.ann_tsi_amt%TYPE,
        p_item_grp              giuw_wpolicyds.item_grp%TYPE
        );
        
    PROCEDURE post_update_giuw_witemds(
        p_dist_no               giuw_witemds.dist_no%TYPE,     
        p_orig_dist_seq_no      giuw_witemds.dist_seq_no%TYPE,   
        p_tsi_amt               giuw_witemds.tsi_amt%TYPE,
        p_prem_amt              giuw_witemds.prem_amt%TYPE,    
        p_ann_tsi_amt           giuw_witemds.ann_tsi_amt%TYPE
        );
            
    PROCEDURE DEL_AFFECTED_DIST_TABLES(p_dist_no     giuw_pol_dist.dist_no%TYPE);
        
    PROCEDURE pre_commit_giuws(
        p_dist_no     giuw_pol_dist.dist_no%TYPE
        );
        
    PROCEDURE RECREATE_GRP_DFLT_WPOLICYDS
             (p_dist_no				IN giuw_wpolicyds_dtl.dist_no%TYPE      ,
              p_dist_seq_no		    IN giuw_wpolicyds_dtl.dist_seq_no%TYPE  ,
              p_line_cd				IN giuw_wpolicyds_dtl.line_cd%TYPE      ,
              p_dist_tsi			IN giuw_wpolicyds_dtl.dist_tsi%TYPE     ,
              p_dist_prem			IN giuw_wpolicyds_dtl.dist_prem%TYPE    ,
              p_ann_dist_tsi	    IN giuw_wpolicyds_dtl.ann_dist_tsi%TYPE ,
              p_rg_count			IN OUT NUMBER                           ,
              p_default_type	    IN giis_default_dist.default_type%TYPE  ,
              p_currency_rt         IN gipi_witem.currency_rt%TYPE          ,
              p_par_id              IN gipi_parlist.par_id%TYPE             ,
              p_item_grp			IN gipi_witem.item_grp%TYPE,
              p_pol_flag            IN gipi_wpolbas.pol_flag%TYPE,
              p_par_type            IN gipi_parlist.par_type%TYPE,
              p_default_no       IN       giis_default_dist.default_no%TYPE);     -- shan 07.22.2014      
        
    PROCEDURE RECREATE_GRP_DFLT_DIST(p_dist_no        IN giuw_wpolicyds.dist_no%TYPE,
                                     p_dist_seq_no    IN giuw_wpolicyds.dist_seq_no%TYPE,
                                     p_dist_flag      IN giuw_wpolicyds.dist_flag%TYPE,
                                     p_policy_tsi     IN giuw_wpolicyds.tsi_amt%TYPE,
                                     p_policy_premium IN giuw_wpolicyds.prem_amt%TYPE,
                                     p_policy_ann_tsi IN giuw_wpolicyds.ann_tsi_amt%TYPE,
                                     p_item_grp       IN giuw_wpolicyds.item_grp%TYPE,
                                     p_line_cd        IN giis_line.line_cd%TYPE,
                                     p_rg_count       IN OUT NUMBER,
                                     p_default_type   IN giis_default_dist.default_type%TYPE,
                                     p_currency_rt    IN gipi_witem.currency_rt%TYPE,
                                     p_par_id         IN gipi_parlist.par_id%TYPE,
                                     p_c150_item_grp  IN giuw_wpolicyds.item_grp%TYPE,
                                     p_pol_flag       IN gipi_wpolbas.pol_flag%TYPE,
                                     p_par_type       IN gipi_parlist.par_type%TYPE,
                                     p_default_no	  IN giis_default_dist.default_no%TYPE);        
        
    PROCEDURE RECREATE_PERIL_DFLT_DIST
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
                       p_currency_rt     IN gipi_witem.currency_rt%TYPE,
                       p_par_id          IN gipi_parlist.par_id%TYPE,
                       p_pol_flag        IN gipi_wpolbas.pol_flag%TYPE, 
                       p_par_type        IN gipi_parlist.par_type%TYPE);        
        
    PROCEDURE CREATE_REGROUPED_DIST_RECS
             (p_dist_no       IN giuw_pol_dist.dist_no%TYPE    ,
              p_par_id        IN gipi_wpolbas.par_id%TYPE  ,
              p_line_cd       IN gipi_wpolbas.line_cd%TYPE    ,
              p_subline_cd    IN gipi_wpolbas.subline_cd%TYPE ,
              p_iss_cd        IN gipi_wpolbas.iss_cd%TYPE     ,
              p_pack_pol_flag IN gipi_wpolbas.pack_pol_flag%TYPE,
              p_c150_item_grp IN giuw_wpolicyds.item_grp%TYPE,
              p_pol_flag      IN gipi_wpolbas.pol_flag%TYPE,
              p_par_type      IN gipi_parlist.par_type%TYPE);
              
    FUNCTION get_giuw_witemds_for_distr
    (p_policy_id    GIPI_POLBASIC.policy_id%TYPE,
     p_dist_no 	    GIUW_WITEMDS.dist_no%TYPE)
    RETURN giuw_witemds_tab PIPELINED;
                 
				 
	PROCEDURE post_witemds_dtl(
	   p_dist_no             giuw_pol_dist.dist_no%TYPE
    );
    
    PROCEDURE post_witemds_dtl_giuws016(p_dist_no   IN   GIUW_POL_DIST.dist_no%TYPE);	
    
    PROCEDURE neg_itemds (
        p_dist_no     IN  giuw_itemds.dist_no%TYPE,
        p_temp_distno IN  giuw_itemds.dist_no%TYPE
    );
    
    PROCEDURE NEG_ITEMDS_GIUTS021(p_dist_no          IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                  p_temp_distno      IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                  p_var_v_neg_distno IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                  p_v_ratio          IN OUT NUMBER);
                                  
    PROCEDURE POST_WITEMDS_DTL_GIUWS015(p_batch_id  GIUW_POL_DIST.batch_id%TYPE,
                                        p_dist_no   GIUW_POL_DIST.dist_no%TYPE);
                                        
    PROCEDURE TRANSFER_WITEMDS (p_dist_no IN GIUW_POL_DIST.dist_no%TYPE);		 
                  
END GIUW_WITEMDS_PKG;
/


