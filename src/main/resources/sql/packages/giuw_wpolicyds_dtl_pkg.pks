CREATE OR REPLACE PACKAGE CPI.GIUW_WPOLICYDS_DTL_PKG
AS
    /*
    **  Created by        : Mark JM
    **  Date Created     : 02.18.2010
    **  Reference By     : (GIPIS010 - Item Information)
    **  Description     : Contains the Insert / Update / Delete procedure of the table
    */
    PROCEDURE del_giuw_wpolicyds_dtl (p_dist_no     GIUW_WPOLICYDS_DTL.dist_no%TYPE);
    
    TYPE giuw_wpolicyds_dtl_type IS RECORD(
        dist_no                 giuw_wpolicyds_dtl.dist_no%TYPE,
        dist_seq_no             giuw_wpolicyds_dtl.dist_seq_no%TYPE,
        line_cd                 giuw_wpolicyds_dtl.line_cd%TYPE,
        share_cd                giuw_wpolicyds_dtl.share_cd%TYPE,
        dist_spct               giuw_wpolicyds_dtl.dist_spct%TYPE,
        dist_tsi                giuw_wpolicyds_dtl.dist_tsi%TYPE,
        dist_prem               giuw_wpolicyds_dtl.dist_prem%TYPE,
        ann_dist_spct           giuw_wpolicyds_dtl.ann_dist_spct%TYPE,
        ann_dist_tsi            giuw_wpolicyds_dtl.ann_dist_tsi%TYPE,
        dist_grp                giuw_wpolicyds_dtl.dist_grp%TYPE,
        dist_spct1              giuw_wpolicyds_dtl.dist_spct1%TYPE,
        arc_ext_data            giuw_wpolicyds_dtl.arc_ext_data%TYPE,
        dsp_trty_cd             GIIS_DIST_SHARE.trty_cd%TYPE,
        dsp_trty_name           GIIS_DIST_SHARE.trty_name%TYPE,
        dsp_trty_sw             GIIS_DIST_SHARE.trty_sw%TYPE
        );
        
    TYPE giuw_wpolicyds_dtl_tab IS TABLE OF giuw_wpolicyds_dtl_type;
    
    FUNCTION get_giuw_wpolicyds_dtl(
        p_dist_no           giuw_wpolicyds_dtl.dist_no%TYPE,
        p_dist_seq_no       giuw_wpolicyds_dtl.dist_seq_no%TYPE)
    RETURN giuw_wpolicyds_dtl_tab PIPELINED;
       
   FUNCTION get_giuw_wpolicyds_dtl_exist(p_dist_no     giuw_wpolicyds_dtl.dist_no%TYPE)
   RETURN VARCHAR2;

    PROCEDURE set_giuw_wpolicyds_dtl(
        p_dist_no               giuw_wpolicyds_dtl.dist_no%TYPE,  
        p_dist_seq_no           giuw_wpolicyds_dtl.dist_seq_no%TYPE,   
        p_line_cd               giuw_wpolicyds_dtl.line_cd%TYPE,
        p_share_cd              giuw_wpolicyds_dtl.share_cd%TYPE,  
        p_dist_spct             giuw_wpolicyds_dtl.dist_spct%TYPE,    
        p_dist_tsi              giuw_wpolicyds_dtl.dist_tsi%TYPE,
        p_dist_prem             giuw_wpolicyds_dtl.dist_prem%TYPE,  
        p_ann_dist_spct         giuw_wpolicyds_dtl.ann_dist_spct%TYPE, 
        p_ann_dist_tsi          giuw_wpolicyds_dtl.ann_dist_tsi%TYPE,
        p_dist_grp              giuw_wpolicyds_dtl.dist_grp%TYPE,  
        p_dist_spct1            giuw_wpolicyds_dtl.dist_spct1%TYPE,    
        p_arc_ext_data          giuw_wpolicyds_dtl.arc_ext_data%TYPE
        );
        
    PROCEDURE del_giuw_wpolicyds_dtl (
        p_dist_no               giuw_wpolicyds_dtl.dist_no%TYPE,  
        p_dist_seq_no           giuw_wpolicyds_dtl.dist_seq_no%TYPE,   
        p_line_cd               giuw_wpolicyds_dtl.line_cd%TYPE,
        p_share_cd              giuw_wpolicyds_dtl.share_cd%TYPE
        );
        
    /*
    **  Created by        : Emman
    **  Date Created     : 06.02.2011
    **  Reference By     : (GIUWS003 - Preliminary Peril Distribution)
    **  Description     : Recreate records in table GIUW_WPOLICYDS_DTL based on
    **                       the values taken in by table GIUW_WITEMDS_DTL.
    */
    PROCEDURE POPULATE_WPOLICYDS_DTL(p_dist_no            GIUW_POL_DIST.dist_no%TYPE);
          
    PROCEDURE POPULATE_WPOLICYDS_DTL2(p_dist_no            GIUW_POL_DIST.dist_no%TYPE);
	
	TYPE giuw_facul_share_dtl_type IS RECORD(
        dist_no                 giuw_wpolicyds_dtl.dist_no%TYPE,
        dist_seq_no             giuw_wpolicyds_dtl.dist_seq_no%TYPE,
        line_cd                 giuw_wpolicyds_dtl.line_cd%TYPE,
        dist_spct               giuw_wpolicyds_dtl.dist_spct%TYPE,
        dist_tsi                giuw_wpolicyds_dtl.dist_tsi%TYPE,
        dist_prem               giuw_wpolicyds_dtl.dist_prem%TYPE,
		dist_spct1               giuw_wpolicyds_dtl.dist_spct1%TYPE,
		tsi_amt 				giuw_wpolicyds.tsi_amt%TYPE,
		prem_amt				giuw_wpolicyds.prem_amt%TYPE,
		user_id					giuw_pol_dist.user_id%TYPE,
		currency_cd				gipi_invoice.currency_cd%TYPE,
		currency_rt				gipi_invoice.currency_rt%TYPE
        );
        
    TYPE giuw_facul_share_dtl_tab IS TABLE OF giuw_facul_share_dtl_type;
	
	TYPE giuw_facul_share_dtl_cur IS REF CURSOR  RETURN giuw_facul_share_dtl_type;
	
	FUNCTION get_list_with_facul_share (
	   p_dist_no	  GIUW_POL_DIST.dist_no%TYPE
	)RETURN giuw_facul_share_dtl_tab PIPELINED;
	
	FUNCTION get_list_with_facul_share2 (p_policy_id GIUW_POL_DIST.policy_id%TYPE,
			 							p_dist_no	  GIUW_POL_DIST.dist_no%TYPE)
      RETURN giuw_facul_share_dtl_tab PIPELINED;
	  
	
	PROCEDURE populate_wpolicyds_dtl3 (p_dist_no giuw_pol_dist.dist_no%TYPE);
    
    PROCEDURE neg_policyds_dtl (
        p_dist_no     IN  giuw_policyds_dtl.dist_no%TYPE,
        p_temp_distno IN  giuw_policyds_dtl.dist_no%TYPE
    );
	
    PROCEDURE ADJUST_POLICY_LEVEL_AMTS(p_dist_no        giuw_wpolicyds.dist_no%TYPE);
    
    PROCEDURE NEG_POLICYDS_DTL_GIUTS021(p_dist_no          IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                        p_temp_distno      IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                        p_var_v_neg_distno IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                        p_v_ratio          IN OUT NUMBER);
                                        
    PROCEDURE POST_WPOLICYDS_DTL_GIUWS015 (p_batch_id    IN  GIUW_POL_DIST.batch_id%TYPE,
                                           p_dist_no     IN  GIUW_POL_DIST.dist_no%TYPE);
              
END GIUW_WPOLICYDS_DTL_PKG;
/


