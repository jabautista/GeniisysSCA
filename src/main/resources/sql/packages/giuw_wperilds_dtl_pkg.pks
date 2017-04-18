CREATE OR REPLACE PACKAGE CPI.GIUW_WPERILDS_DTL_PKG
AS
    TYPE giuw_wperilds_dtl_type IS RECORD (
        dist_no            giuw_wperilds_dtl.dist_no%TYPE,
        dist_seq_no        giuw_wperilds_dtl.dist_seq_no%TYPE,
        line_cd            giuw_wperilds_dtl.line_cd%TYPE,
        peril_cd        giuw_wperilds_dtl.peril_cd%TYPE,
        share_cd        giuw_wperilds_dtl.share_cd%TYPE,
        dist_spct        giuw_wperilds_dtl.dist_spct%TYPE,
        dist_tsi        giuw_wperilds_dtl.dist_tsi%TYPE,
        dist_prem        giuw_wperilds_dtl.dist_prem%TYPE,
        ann_dist_spct    giuw_wperilds_dtl.ann_dist_spct%TYPE,
        ann_dist_tsi    giuw_wperilds_dtl.ann_dist_tsi%TYPE,
        dist_grp        giuw_wperilds_dtl.dist_grp%TYPE,
        dist_spct1        giuw_wperilds_dtl.dist_spct1%TYPE,
        arc_ext_data    giuw_wperilds_dtl.arc_ext_data%TYPE,
        trty_name        giis_dist_share.trty_name%TYPE);
        
    TYPE giuw_wperilds_dtl_tab IS TABLE OF giuw_wperilds_dtl_type;
    
    PROCEDURE del_giuw_wperilds_dtl (p_dist_no     GIUW_WPERILDS_DTL.dist_no%TYPE);
    
    FUNCTION get_giuw_wperilds_dtl (
        p_dist_no IN giuw_wperilds_dtl.dist_no%TYPE,
        p_dist_seq_no IN giuw_wperilds_dtl.dist_seq_no%TYPE,
        p_line_cd IN giuw_wperilds_dtl.line_cd%TYPE,
        p_peril_cd IN giuw_wperilds_dtl.peril_cd%TYPE)
    RETURN giuw_wperilds_dtl_tab PIPELINED;
	
	PROCEDURE set_giuw_wperilds_dtl(
		p_dist_no				giuw_wperilds_dtl.dist_no%TYPE,
		p_dist_seq_no			giuw_wperilds_dtl.dist_seq_no%TYPE,
		p_line_cd				giuw_wperilds_dtl.line_cd%TYPE,
		p_peril_cd				giuw_wperilds_dtl.peril_cd%TYPE,
		p_share_cd				giuw_wperilds_dtl.share_cd%TYPE,
		p_dist_spct				giuw_wperilds_dtl.dist_spct%TYPE,
		p_dist_tsi				giuw_wperilds_dtl.dist_tsi%TYPE,
		p_dist_prem				giuw_wperilds_dtl.dist_prem%TYPE,
		p_ann_dist_spct			giuw_wperilds_dtl.ann_dist_spct%TYPE,
		p_ann_dist_tsi			giuw_wperilds_dtl.ann_dist_tsi%TYPE,
		p_dist_grp				giuw_wperilds_dtl.dist_grp%TYPE,
		p_dist_spct1			giuw_wperilds_dtl.dist_spct1%TYPE,
		p_arc_ext_data			giuw_wperilds_dtl.arc_ext_data%TYPE);
		
	PROCEDURE del_giuw_wperilds_dtl2(p_dist_no     GIUW_WPERILDS_DTL.dist_no%TYPE,
			  						 p_dist_seq_no GIUW_WPERILDS.dist_seq_no%TYPE,
									 p_line_cd	   GIUW_WPERILDS.line_cd%TYPE,
									 p_peril_cd	   GIUW_WPERILDS.peril_cd%TYPE,
									 p_share_cd	   GIUW_WPERILDS_DTL.share_cd%TYPE);	
									 
	PROCEDURE post_wperilds_dtl (
	   p_dist_no             giuw_pol_dist.dist_no%TYPE
	);			
    
    FUNCTION get_giuw_wperilds_dtl_exist (
      p_dist_no   giuw_wperilds_dtl.dist_no%TYPE)
    RETURN VARCHAR2;
    
    PROCEDURE post_wperilds_dtl_giuws016 (p_dist_no      IN       giuw_pol_dist.dist_no%TYPE);
    
    PROCEDURE neg_perilds_dtl (
        p_dist_no     IN  giuw_perilds_dtl.dist_no%TYPE,
        p_temp_distno IN  giuw_perilds_dtl.dist_no%TYPE
    ) ;
    
    PROCEDURE NEG_PERILDS_DTL_GIUTS021(p_dist_no          IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                      p_temp_distno      IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                      p_var_v_neg_distno IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                      p_v_ratio          IN OUT NUMBER);
                                      
    PROCEDURE POST_WPERILDS_DTL_GIUWS015 (p_batch_id    GIUW_POL_DIST.batch_id%TYPE,
                                          p_dist_no     GIUW_POL_DIST.dist_no%TYPE); 
      					 
END GIUW_WPERILDS_DTL_PKG;
/


