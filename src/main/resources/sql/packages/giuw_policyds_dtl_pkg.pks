CREATE OR REPLACE PACKAGE CPI.GIUW_POLICYDS_DTL_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_giuw_policyds_dtl (p_dist_no 	GIUW_POLICYDS_DTL.dist_no%TYPE);
    
    TYPE giuw_policyds_dtl_type IS RECORD(
        dist_no                 giuw_policyds_dtl.dist_no%TYPE,
        dist_seq_no             giuw_policyds_dtl.dist_seq_no%TYPE,
        line_cd                 giuw_policyds_dtl.line_cd%TYPE,
        share_cd                giuw_policyds_dtl.share_cd%TYPE,
        dist_tsi                giuw_policyds_dtl.dist_tsi%TYPE,
        dist_prem               giuw_policyds_dtl.dist_prem%TYPE,
        dist_spct               giuw_policyds_dtl.dist_spct%TYPE,
        dist_spct1              giuw_policyds_dtl.dist_spct1%TYPE,
        ann_dist_spct           giuw_policyds_dtl.ann_dist_spct%TYPE,
        ann_dist_tsi            giuw_policyds_dtl.ann_dist_tsi%TYPE,
        dist_grp                giuw_policyds_dtl.dist_grp%TYPE,
        cpi_rec_no              giuw_policyds_dtl.cpi_rec_no%TYPE,
        cpi_branch_cd           giuw_policyds_dtl.cpi_branch_cd%TYPE,
        arc_ext_data            giuw_policyds_dtl.arc_ext_data%TYPE,
        dsp_trty_cd             GIIS_DIST_SHARE.trty_cd%TYPE,
        dsp_trty_name           GIIS_DIST_SHARE.trty_name%TYPE,
        dsp_trty_sw             GIIS_DIST_SHARE.trty_sw%TYPE
        );
        
    TYPE giuw_policyds_dtl_tab IS TABLE OF giuw_policyds_dtl_type;
    
   FUNCTION get_giuw_policyds_dtl (
      p_dist_no       giuw_policyds_dtl.dist_no%TYPE,
      p_dist_seq_no   giuw_policyds_dtl.dist_seq_no%TYPE
   )
   RETURN giuw_policyds_dtl_tab PIPELINED;
      
   FUNCTION get_giuw_policyds_dtl_exist (
      p_dist_no   giuw_policyds_dtl.dist_no%TYPE
   )
   RETURN VARCHAR2;
      
END GIUW_POLICYDS_DTL_PKG;
/


