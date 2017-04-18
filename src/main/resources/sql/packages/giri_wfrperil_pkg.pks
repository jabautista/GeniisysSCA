CREATE OR REPLACE PACKAGE CPI.Giri_Wfrperil_Pkg
AS    
    TYPE giri_wfrperil_type IS RECORD (
        line_cd         GIRI_WFRPERIL.line_cd%TYPE,
        frps_yy         GIRI_WFRPERIL.frps_yy%TYPE,
        frps_seq_no     GIRI_WFRPERIL.frps_seq_no%TYPE,
        ri_seq_no       GIRI_WFRPERIL.ri_seq_no%TYPE,
        peril_cd        GIRI_WFRPERIL.peril_cd%TYPE,
        ri_cd           GIRI_WFRPERIL.ri_cd%TYPE,
        ri_shr_pct      GIRI_WFRPERIL.ri_shr_pct%TYPE,
        ri_tsi_amt      GIRI_WFRPERIL.ri_tsi_amt%TYPE,
        ri_prem_amt     GIRI_WFRPERIL.ri_prem_amt%TYPE,
        ann_ri_s_amt    GIRI_WFRPERIL.ann_ri_s_amt%TYPE,
        ann_ri_pct      GIRI_WFRPERIL.ann_ri_pct%TYPE,
        ri_comm_rt      GIRI_WFRPERIL.ri_comm_rt%TYPE,
        ri_comm_amt     GIRI_WFRPERIL.ri_comm_amt%TYPE,
        ri_prem_vat     GIRI_WFRPERIL.ri_prem_vat%TYPE,
        ri_comm_vat     GIRI_WFRPERIL.ri_comm_vat%TYPE,
        prem_tax        GIRI_WFRPERIL.prem_tax%TYPE,
        ri_comm_amt2    GIRI_WFRPERIL.ri_comm_amt2%TYPE,
        arc_ext_data    GIRI_WFRPERIL.arc_ext_data%TYPE,
        peril_sname     GIIS_PERIL.peril_sname%TYPE,
        peril_name      GIIS_PERIL.peril_name%TYPE,
        dist_prem       GIUW_PERILDS_DTL.dist_prem%TYPE,
        dist_tsi        GIUW_PERILDS_DTL.dist_tsi%TYPE,
        input_vat_rate  NUMBER,
		prem_amt      giuw_perilds_dtl.dist_prem%TYPE,
    	tsi_amt       giuw_perilds_dtl.dist_tsi%TYPE
    );
    
    TYPE giri_wfrperil_tab IS TABLE OF giri_wfrperil_type;
       
    /*
    **  Created by        : Mark JM
    **  Date Created     : 02.17.2010
    **  Reference By     : (GIPIS010 - Item Information)
    **  Description     : Contains the Insert / Update / Delete procedure of the table
    */

    PROCEDURE del_giri_wfrperil(
        p_line_cd        GIRI_WFRPERIL.line_cd%TYPE,
        p_frps_yy        GIRI_WFRPERIL.frps_yy%TYPE,
        p_frps_seq_no    GIRI_WFRPERIL.frps_seq_no%TYPE);
    PROCEDURE del_giri_wfrperil_1 (
        p_frps_yy        GIRI_WFRPERIL.frps_yy%TYPE,
        p_frps_seq_no    GIRI_WFRPERIL.frps_seq_no%TYPE);
        
    PROCEDURE del_giri_wfrperil_2(
		p_line_cd		GIRI_WFRPERIL.line_cd%TYPE,
		p_frps_yy		GIRI_WFRPERIL.frps_yy%TYPE,
		p_frps_seq_no	GIRI_WFRPERIL.frps_seq_no%TYPE,
        p_ri_cd         GIRI_WFRPERIL.ri_cd%TYPE);        
        
    FUNCTION get_giri_wfrperil (
        p_line_cd        GIRI_WFRPERIL.line_cd%TYPE,
        p_frps_yy        GIRI_WFRPERIL.frps_yy%TYPE,
        p_frps_seq_no    GIRI_WFRPERIL.frps_seq_no%TYPE,
        p_ri_seq_no      GIRI_WFRPERIL.ri_seq_no%TYPE,
        p_ri_cd          GIRI_WFRPERIL.ri_cd%TYPE,
        p_dist_no        GIRI_DISTFRPS_WDISTFRPS_V.dist_no%TYPE, 
        p_dist_seq_no    GIRI_DISTFRPS_WDISTFRPS_V.dist_seq_no%TYPE
    ) RETURN giri_wfrperil_tab PIPELINED; 
    
    PROCEDURE set_giri_wfrperil (
        p_line_cd         GIRI_WFRPERIL.line_cd%TYPE,
        p_frps_yy         GIRI_WFRPERIL.frps_yy%TYPE,
        p_frps_seq_no     GIRI_WFRPERIL.frps_seq_no%TYPE,
        p_ri_seq_no       GIRI_WFRPERIL.ri_seq_no%TYPE,
        p_ri_cd           GIRI_WFRPERIL.ri_cd%TYPE,
        p_peril_cd        GIRI_WFRPERIL.peril_cd%TYPE,
        p_ri_shr_pct      GIRI_WFRPERIL.ri_shr_pct%TYPE,
        p_ri_tsi_amt      GIRI_WFRPERIL.ri_tsi_amt%TYPE,
        p_ri_prem_amt     GIRI_WFRPERIL.ri_prem_amt%TYPE,
        p_ann_ri_s_amt    GIRI_WFRPERIL.ann_ri_s_amt%TYPE,
        p_ann_ri_pct      GIRI_WFRPERIL.ann_ri_pct%TYPE,
        p_ri_comm_rt      GIRI_WFRPERIL.ri_comm_rt%TYPE,
        p_ri_comm_amt     GIRI_WFRPERIL.ri_comm_amt%TYPE,
        p_ri_prem_vat     GIRI_WFRPERIL.ri_prem_vat%TYPE,
        p_ri_comm_vat     GIRI_WFRPERIL.ri_comm_vat%TYPE,
        p_prem_tax        GIRI_WFRPERIL.prem_tax%TYPE,
        p_ri_comm_amt2    GIRI_WFRPERIL.ri_comm_amt2%TYPE
    );
    
    PROCEDURE get_sum_frperil_amounts (
        p_line_cd           IN  GIRI_WFRPERIL.line_cd%TYPE,
        p_frps_yy           IN  GIRI_WFRPERIL.frps_yy%TYPE,
        p_frps_seq_no       IN  GIRI_WFRPERIL.frps_seq_no%TYPE,
        p_ri_seq_no         IN  GIRI_WFRPERIL.ri_seq_no%TYPE,
        p_ri_cd             IN  GIRI_WFRPERIL.ri_cd%TYPE,
        p_sum_comm_amt      OUT NUMBER,
        p_sum_prem_amt      OUT NUMBER,
        p_sum_prem_vat      OUT NUMBER,
        p_sum_tsi_amt       OUT NUMBER
    );
    
    PROCEDURE offset_process(
        p_dist_no           giuw_perilds_dtl.dist_no%TYPE,
        p_dist_seq_no       giuw_perilds_dtl.dist_seq_no%TYPE,
        p_line_cd           GIRI_WFRPS_PERIL_GRP.line_cd%TYPE,
        p_frps_yy           GIRI_WFRPS_PERIL_GRP.frps_yy%TYPE,
        p_frps_seq_no       GIRI_WFRPS_PERIL_GRP.frps_seq_no%TYPE
        );
            
    PROCEDURE FINAL_OFFSET(
        p_dist_no           giuw_perilds_dtl.dist_no%TYPE,
        p_dist_seq_no       giuw_perilds_dtl.dist_seq_no%TYPE,
        p_line_cd           GIRI_WFRPS_PERIL_GRP.line_cd%TYPE,
        p_frps_yy           GIRI_WFRPS_PERIL_GRP.frps_yy%TYPE,
        p_frps_seq_no       GIRI_WFRPS_PERIL_GRP.frps_seq_no%TYPE
        );
            
    PROCEDURE CREATE_WFRPERIL_R(
        p_dist_no           giuw_perilds_dtl.dist_no%TYPE,
        p_dist_seq_no       giuw_perilds_dtl.dist_seq_no%TYPE,
        p_line_cd           GIRI_WFRPS_PERIL_GRP.line_cd%TYPE,
        p_frps_yy           GIRI_WFRPS_PERIL_GRP.frps_yy%TYPE,
        p_frps_seq_no       GIRI_WFRPS_PERIL_GRP.frps_seq_no%TYPE,
        p_iss_cd            IN gipi_parlist.iss_cd%TYPE,
        p_par_yy            IN gipi_parlist.par_yy%TYPE,
        p_par_seq_no        IN gipi_parlist.par_seq_no%TYPE,
        p_subline_cd        IN VARCHAR2,
        p_issue_yy          IN VARCHAR2,
        p_pol_seq_no        IN VARCHAR2,
        p_renew_no          IN VARCHAR2,
        p_tot_fac_spct      IN GIRI_DISTFRPS.tot_fac_spct%TYPE
        );
        
    PROCEDURE CREATE_WFRPERIL_M(
        p_dist_no           giuw_perilds_dtl.dist_no%TYPE,
        p_dist_seq_no       giuw_perilds_dtl.dist_seq_no%TYPE,
        p_line_cd           GIRI_WFRPS_PERIL_GRP.line_cd%TYPE,
        p_frps_yy           GIRI_WFRPS_PERIL_GRP.frps_yy%TYPE,
        p_frps_seq_no       GIRI_WFRPS_PERIL_GRP.frps_seq_no%TYPE,
        p_iss_cd            IN gipi_parlist.iss_cd%TYPE,
        p_par_yy            IN gipi_parlist.par_yy%TYPE,
        p_par_seq_no        IN gipi_parlist.par_seq_no%TYPE,
        p_subline_cd        IN VARCHAR2,
        p_issue_yy          IN VARCHAR2,
        p_pol_seq_no        IN VARCHAR2,
        p_renew_no          IN VARCHAR2,
        p_tot_fac_spct      IN GIRI_DISTFRPS.tot_fac_spct%TYPE    
        );
        
    PROCEDURE copy_frperil(
        p_line_cd       IN giri_frperil.line_cd%TYPE,
        p_frps_yy       IN giri_frperil.frps_yy%TYPE,
        p_frps_seq_no   IN giri_frperil.frps_seq_no%TYPE,
        p_ri_cd         IN giri_frperil.ri_cd%TYPE,
        p_ri_seq_no     IN giri_frperil.ri_seq_no%TYPE
    );
    
    PROCEDURE CREATE_WFRPERIL_R_GIUTS021 (p_dist_no     GIUW_POL_DIST.dist_no%TYPE,
                                         v_line_cd     IN giri_distfrps.line_cd%TYPE,
                                         v_frps_yy     IN giri_distfrps.frps_yy%TYPE,
                                         v_frps_seq_no IN giri_distfrps.frps_seq_no%TYPE);
                                         
    PROCEDURE CREATE_WFRPERIL_M_GIUTS021 (p_dist_no     IN giuw_pol_dist.dist_no%TYPE,
                                         p_v_post_flag IN VARCHAR2,
                                         v_line_cd     IN giri_distfrps.line_cd%TYPE,
                                         v_frps_yy     IN giri_distfrps.frps_yy%TYPE,
                                         v_frps_seq_no IN giri_distfrps.frps_seq_no%TYPE
                                         ,p_ratio       IN NUMBER,
                                         p_neg_distno  IN giuw_pol_dist.dist_no%TYPE);--added edgar 09/29/2014
                                         
    PROCEDURE FINAL_OFFSET_GIUTS021 (p_dist_no     IN  GIUW_POL_DIST.dist_no%TYPE,
                                     v_dist_seq_no IN  giuw_policyds.dist_seq_no%TYPE,
                                     v_line_cd     IN  giri_distfrps.line_cd%TYPE,
                                     v_frps_yy     IN  giri_distfrps.frps_yy%TYPE,
                                     v_frps_seq_no IN  giri_distfrps.frps_seq_no%TYPE);
                            
    PROCEDURE OFFSET_RI(p_dist_no     IN giuw_pol_dist.dist_no%TYPE,
                        v_dist_seq_no IN giuw_policyds.dist_seq_no%TYPE,
                        v_line_cd     IN giri_distfrps.line_cd%TYPE,
                        v_frps_yy     IN giri_distfrps.frps_yy%TYPE,
                        v_frps_seq_no IN giri_distfrps.frps_seq_no%TYPE);
                        
    FUNCTION validate_binder_giris002 (
        p_line_cd           GIRI_DISTFRPS_WDISTFRPS_V.line_cd%TYPE,
        p_frps_yy           GIRI_DISTFRPS_WDISTFRPS_V.frps_yy%TYPE,
        p_frps_seq_no       GIRI_DISTFRPS_WDISTFRPS_V.frps_seq_no%TYPE,
        p_dist_no           GIRI_DISTFRPS_WDISTFRPS_V.dist_no%TYPE,
        p_dist_seq_no       GIRI_DISTFRPS_WDISTFRPS_V.dist_seq_no%TYPE
    ) RETURN VARCHAR2;    
    
   PROCEDURE create_wfrperil_r_giris001(
      p_dist_no               giuw_perilds_dtl.dist_no%TYPE,
      p_line_cd               giri_wfrps_peril_grp.line_cd%TYPE,
      p_frps_yy               giri_wfrps_peril_grp.frps_yy%TYPE,
      p_frps_seq_no           giri_wfrps_peril_grp.frps_seq_no%TYPE,
      p_iss_cd            IN  gipi_parlist.iss_cd%TYPE,
      p_tot_fac_spct      IN  giri_distfrps.tot_fac_spct%TYPE
   );
   
   PROCEDURE create_wfrperil_m_giris001(
      p_dist_no               giuw_perilds_dtl.dist_no%TYPE,
      p_line_cd               giri_wfrps_peril_grp.line_cd%TYPE,
      p_frps_yy               giri_wfrps_peril_grp.frps_yy%TYPE,
      p_frps_seq_no           giri_wfrps_peril_grp.frps_seq_no%TYPE,
      p_iss_cd            IN  gipi_parlist.iss_cd%TYPE,
      p_tot_fac_spct      IN  giri_distfrps.tot_fac_spct%TYPE
   );
                        
END Giri_Wfrperil_Pkg;
/


