CREATE OR REPLACE PACKAGE CPI.giri_wfrps_ri_pkg
AS
   TYPE giri_wfrps_ri_type IS RECORD (
      line_cd            giri_wfrps_ri.line_cd%TYPE,
      frps_yy            giri_wfrps_ri.frps_yy%TYPE,
      frps_seq_no        giri_wfrps_ri.frps_seq_no%TYPE,
      ri_seq_no          giri_wfrps_ri.ri_seq_no%TYPE,
      ri_cd              giri_wfrps_ri.ri_cd%TYPE,
      pre_binder_id      giri_wfrps_ri.pre_binder_id%TYPE,
      ri_shr_pct         giri_wfrps_ri.ri_shr_pct%TYPE,
      ri_tsi_amt         giri_wfrps_ri.ri_tsi_amt%TYPE,
      ri_prem_amt        giri_wfrps_ri.ri_prem_amt%TYPE,
      ann_ri_s_amt       giri_wfrps_ri.ann_ri_s_amt%TYPE,
      ann_ri_pct         giri_wfrps_ri.ann_ri_pct%TYPE,
      ri_comm_rt         giri_wfrps_ri.ri_comm_rt%TYPE,
      ri_comm_amt        giri_wfrps_ri.ri_comm_amt%TYPE,
      prem_tax           giri_wfrps_ri.prem_tax%TYPE,
      other_charges      giri_wfrps_ri.other_charges%TYPE,
      renew_sw           giri_wfrps_ri.renew_sw%TYPE,
      reverse_sw         giri_wfrps_ri.reverse_sw%TYPE,
      facoblig_sw        giri_wfrps_ri.facoblig_sw%TYPE,
      bndr_remarks1      giri_wfrps_ri.bndr_remarks1%TYPE,
      bndr_remarks2      giri_wfrps_ri.bndr_remarks2%TYPE,
      bndr_remarks3      giri_wfrps_ri.bndr_remarks3%TYPE,
      delete_sw          giri_wfrps_ri.delete_sw%TYPE,
      remarks            giri_wfrps_ri.remarks%TYPE,
      last_update        giri_wfrps_ri.last_update%TYPE,
      ri_as_no           giri_wfrps_ri.ri_as_no%TYPE,
      ri_accept_by       giri_wfrps_ri.ri_accept_by%TYPE,
      ri_accept_date     giri_wfrps_ri.ri_accept_date%TYPE,
      ri_shr_pct2        giri_wfrps_ri.ri_shr_pct2%TYPE,
      ri_prem_vat        giri_wfrps_ri.ri_prem_vat%TYPE,
      ri_comm_vat        giri_wfrps_ri.ri_comm_vat%TYPE, 
      address1           giri_wfrps_ri.address1%TYPE,
      address2           giri_wfrps_ri.address2%TYPE,
      address3           giri_wfrps_ri.address3%TYPE,
      prem_warr_days     giri_wfrps_ri.prem_warr_days%TYPE,
      prem_warr_tag      giri_wfrps_ri.prem_warr_tag%TYPE,
      arc_ext_data       giri_wfrps_ri.arc_ext_data%TYPE,
      ri_sname           giis_reinsurer.ri_sname%TYPE,
      ri_name            giis_reinsurer.ri_name%TYPE,
      local_foreign_sw   giis_reinsurer.local_foreign_sw%TYPE,
      giri_frps_ri_ctr   NUMBER,
      net_due            NUMBER,
      dsp_fnl_binder_id  giri_frps_ri.fnl_binder_id%TYPE,
      total_ri_shr_pct   NUMBER,
      total_ri_tsi_amt   NUMBER,
      total_ri_shr_pct2  NUMBER,
      total_ri_prem_amt  NUMBER   
   );

   TYPE giri_wfrps_ri_tab IS TABLE OF giri_wfrps_ri_type;

    /*
   **  Created by    : Mark JM
   **  Date Created  : 02.17.2010
   **  Reference By  : (GIPIS010 - Item Information)
   **  Description   : Contains the Insert / Update / Delete procedure of the table
   */
   PROCEDURE del_giri_wfrps_ri (
      p_line_cd       giri_wfrps_ri.line_cd%TYPE,
      p_frps_yy       giri_wfrps_ri.frps_yy%TYPE,
      p_frps_seq_no   giri_wfrps_ri.frps_seq_no%TYPE
   );

   PROCEDURE del_giri_wfrps_ri_1 (
      p_frps_yy       giri_wfrps_ri.frps_yy%TYPE,
      p_frps_seq_no   giri_wfrps_ri.frps_seq_no%TYPE
   );

   PROCEDURE del_giri_wfrps_ri_2 (
        p_line_cd       giri_wfrps_ri.line_cd%TYPE,
        p_frps_yy       giri_wfrps_ri.frps_yy%TYPE,
        p_frps_seq_no   giri_wfrps_ri.frps_seq_no%TYPE,
        p_ri_seq_no     giri_wfrps_ri.ri_seq_no%TYPE
        );

   FUNCTION count_giri_wfrps_ri (
      p_line_cd       giri_wfrps_ri.line_cd%TYPE,
      p_frps_yy       giri_wfrps_ri.frps_yy%TYPE,
      p_frps_seq_no   giri_wfrps_ri.frps_seq_no%TYPE
   )
      RETURN NUMBER;

   FUNCTION get_giri_wfrps_ri (
      p_line_cd       giri_wfrps_ri.line_cd%TYPE,
      p_frps_yy       giri_wfrps_ri.frps_yy%TYPE,
      p_frps_seq_no   giri_wfrps_ri.frps_seq_no%TYPE
   )
      RETURN giri_wfrps_ri_tab PIPELINED;

   FUNCTION get_giri_wfrps_ri2 (
      p_line_cd       giri_wfrps_ri.line_cd%TYPE,
      p_frps_yy       giri_wfrps_ri.frps_yy%TYPE,
      p_frps_seq_no   giri_wfrps_ri.frps_seq_no%TYPE
   )
      RETURN giri_wfrps_ri_tab PIPELINED;
	  
    PROCEDURE get_giri_wfrps_ri2_totals(
      p_line_cd       giri_wfrps_ri.line_cd%TYPE,
      p_frps_yy       giri_wfrps_ri.frps_yy%TYPE,
      p_frps_seq_no   giri_wfrps_ri.frps_seq_no%TYPE,
      p_total_ri_shr_pct  OUT NUMBER,
      p_total_ri_tsi_amt  OUT NUMBER,
      p_total_ri_shr_pct2    OUT NUMBER,
      p_total_ri_prem_amt OUT NUMBER
    );     
      
   PROCEDURE delete_records_giris026 (
      p_line_cd       giri_distfrps_wdistfrps_v.line_cd%TYPE,
      p_frps_yy       giri_distfrps_wdistfrps_v.frps_yy%TYPE,
      p_frps_seq_no   giri_distfrps_wdistfrps_v.frps_seq_no%TYPE,
      p_dist_no       giri_distfrps_wdistfrps_v.dist_no%TYPE,
      p_dist_seq_no   giri_distfrps_wdistfrps_v.dist_seq_no%TYPE
   );
   
   PROCEDURE get_warr_days(
        p_line_cd           IN  giri_wfrps_ri.line_cd%TYPE,
        p_frps_yy           IN  giri_wfrps_ri.frps_yy%TYPE,
        p_frps_seq_no       IN  giri_wfrps_ri.frps_seq_no%TYPE,
        p_prem_warr_tag		OUT gipi_polbasic.prem_warr_tag%type,
	    p_prem_warr_days	OUT gipi_polbasic.prem_warr_days%type
        );
        
   PROCEDURE update_wfrps_ri (
      p_line_cd            giri_wfrps_ri.line_cd%TYPE,
      p_frps_yy            giri_wfrps_ri.frps_yy%TYPE,
      p_frps_seq_no        giri_wfrps_ri.frps_seq_no%TYPE,
      p_ri_seq_no          giri_wfrps_ri.ri_seq_no%TYPE,
      p_ri_cd              giri_wfrps_ri.ri_cd%TYPE,
      p_address1           giri_wfrps_ri.address1%TYPE,
      p_address2           giri_wfrps_ri.address2%TYPE,
      p_address3           giri_wfrps_ri.address3%TYPE,
      p_remarks            giri_wfrps_ri.remarks%TYPE,
      p_bndr_remarks1      giri_wfrps_ri.bndr_remarks1%TYPE,
      p_bndr_remarks2      giri_wfrps_ri.bndr_remarks2%TYPE,
      p_bndr_remarks3      giri_wfrps_ri.bndr_remarks3%TYPE,
      p_ri_accept_by       giri_wfrps_ri.ri_accept_by%TYPE,
      p_ri_as_no           giri_wfrps_ri.ri_as_no%TYPE,
      p_ri_accept_date     giri_wfrps_ri.ri_accept_date%TYPE,
      p_ri_shr_pct         giri_wfrps_ri.ri_shr_pct%TYPE,
      p_ri_prem_amt        giri_wfrps_ri.ri_prem_amt%TYPE, 
      p_ri_tsi_amt         giri_wfrps_ri.ri_tsi_amt%TYPE,
      p_ri_comm_amt        giri_wfrps_ri.ri_comm_amt%TYPE,
      p_ri_comm_rt         giri_wfrps_ri.ri_comm_rt%TYPE,
      p_ri_prem_vat        giri_wfrps_ri.ri_prem_vat%TYPE,
      p_ri_comm_vat        giri_wfrps_ri.ri_comm_vat%TYPE,
      p_prem_tax           giri_wfrps_ri.prem_tax%TYPE
   );
           
   PROCEDURE ADJUST_PREM_VAT(
        p_prem_vat          IN OUT NUMBER,
        p_ri_cd             IN NUMBER,
        p_line_cd           IN gipi_parlist.line_cd%TYPE,
        p_iss_cd            IN gipi_parlist.iss_cd%TYPE,
        p_par_yy            IN gipi_parlist.par_yy%TYPE,
        p_par_seq_no        IN gipi_parlist.par_seq_no%TYPE,
        p_subline_cd        IN VARCHAR2,
        p_issue_yy          IN VARCHAR2,
        p_pol_seq_no        IN VARCHAR2,
        p_renew_no          IN VARCHAR2
        );
        
    PROCEDURE COMPUTE_RI_PREM_AMT(
        p_ri_prem_vat       IN OUT NUMBER,
        p_ri_cd             IN NUMBER,
        p_line_cd           IN gipi_parlist.line_cd%TYPE,
        p_iss_cd            IN gipi_parlist.iss_cd%TYPE,
        p_par_yy            IN gipi_parlist.par_yy%TYPE,
        p_par_seq_no        IN gipi_parlist.par_seq_no%TYPE,
        p_subline_cd   IN VARCHAR2,
        p_issue_yy     IN VARCHAR2,
        p_pol_seq_no   IN VARCHAR2,
        p_renew_no     IN VARCHAR2,
        p_ri_shr_pct        IN NUMBER,
        p_ri_shr_pct2       IN OUT NUMBER,
        p_tot_fac_spct2     IN NUMBER,
        p_tot_fac_prem      IN  NUMBER,
        p_ri_prem_amt       OUT NUMBER
        );
           
    PROCEDURE compute_ri_prem_vat1(
        p_ri_prem_vat       IN OUT NUMBER,
        p_ri_cd             IN NUMBER,
        p_line_cd           IN gipi_parlist.line_cd%TYPE,
        p_iss_cd            IN gipi_parlist.iss_cd%TYPE,
        p_par_yy            IN gipi_parlist.par_yy%TYPE,
        p_par_seq_no        IN gipi_parlist.par_seq_no%TYPE,
        p_subline_cd        IN VARCHAR2,
        p_issue_yy          IN VARCHAR2,
        p_pol_seq_no        IN VARCHAR2,
        p_renew_no          IN VARCHAR2,
        p_var2_prem         IN NUMBER
        );
             
PROCEDURE set_giri_wfrps_ri(
        p_line_cd            giri_wfrps_ri.line_cd%TYPE,
        p_frps_yy            giri_wfrps_ri.frps_yy%TYPE,
        p_frps_seq_no        giri_wfrps_ri.frps_seq_no%TYPE,
        p_ri_seq_no          giri_wfrps_ri.ri_seq_no%TYPE,
        p_ri_cd              giri_wfrps_ri.ri_cd%TYPE,
        p_orig_ri_cd         giri_wfrps_ri.ri_cd%TYPE,
        p_pre_binder_id      giri_wfrps_ri.pre_binder_id%TYPE,
        p_ri_shr_pct         giri_wfrps_ri.ri_shr_pct%TYPE,
        p_ri_tsi_amt         giri_wfrps_ri.ri_tsi_amt%TYPE,
        p_ri_prem_amt        giri_wfrps_ri.ri_prem_amt%TYPE,
        p_ann_ri_s_amt       giri_wfrps_ri.ann_ri_s_amt%TYPE,
        p_ann_ri_pct         giri_wfrps_ri.ann_ri_pct%TYPE,
        p_ri_comm_rt         giri_wfrps_ri.ri_comm_rt%TYPE,
        p_ri_comm_amt        giri_wfrps_ri.ri_comm_amt%TYPE,
        p_prem_tax           giri_wfrps_ri.prem_tax%TYPE,
        p_other_charges      giri_wfrps_ri.other_charges%TYPE,
        p_renew_sw           giri_wfrps_ri.renew_sw%TYPE,
        p_reverse_sw         giri_wfrps_ri.reverse_sw%TYPE,
        p_facoblig_sw        giri_wfrps_ri.facoblig_sw%TYPE,
        p_bndr_remarks1      giri_wfrps_ri.bndr_remarks1%TYPE,
        p_bndr_remarks2      giri_wfrps_ri.bndr_remarks2%TYPE,
        p_bndr_remarks3      giri_wfrps_ri.bndr_remarks3%TYPE,
        p_delete_sw          giri_wfrps_ri.delete_sw%TYPE,
        p_remarks            giri_wfrps_ri.remarks%TYPE,
        p_last_update        giri_wfrps_ri.last_update%TYPE,
        p_ri_as_no           giri_wfrps_ri.ri_as_no%TYPE,
        p_ri_accept_by       giri_wfrps_ri.ri_accept_by%TYPE,
        p_ri_accept_date     giri_wfrps_ri.ri_accept_date%TYPE,
        p_ri_shr_pct2        giri_wfrps_ri.ri_shr_pct2%TYPE,
        p_ri_prem_vat        giri_wfrps_ri.ri_prem_vat%TYPE,
        p_ri_comm_vat        giri_wfrps_ri.ri_comm_vat%TYPE,
        p_address1           giri_wfrps_ri.address1%TYPE,
        p_address2           giri_wfrps_ri.address2%TYPE,
        p_address3           giri_wfrps_ri.address3%TYPE,
        p_prem_warr_days     giri_wfrps_ri.prem_warr_days%TYPE,
        p_prem_warr_tag      giri_wfrps_ri.prem_warr_tag%TYPE,
        p_arc_ext_data       giri_wfrps_ri.arc_ext_data%TYPE
        );
              
    PROCEDURE get_ri_seq_no(
        p_line_cd           IN giri_wfrps_ri.line_cd%TYPE,
        p_frps_yy           IN giri_wfrps_ri.frps_yy%TYPE,
        p_frps_seq_no       IN giri_wfrps_ri.frps_seq_no%TYPE,
        p_max_ri_seq_no     OUT NUMBER
        );
                 
    PROCEDURE UPDATE_PREM_TAX(
        p_ri_cd             IN giis_reinsurer.ri_cd%TYPE,
        p_ri_prem_amt       IN giri_wfrps_ri.ri_prem_amt%TYPE,
        p_prem_tax          OUT giri_wfrps_ri.prem_tax%TYPE
        );
              
    PROCEDURE pre_ins_giris001(
        p_line_cd           IN giri_wfrps_ri.line_cd%TYPE,
        p_frps_yy           IN giri_wfrps_ri.frps_yy%TYPE,
        p_frps_seq_no       IN giri_wfrps_ri.frps_seq_no%TYPE,
        p_dist_no           IN giuw_pol_dist.dist_no%TYPE,
        p_ri_cd             IN giis_reinsurer.ri_cd%TYPE,
        p_ri_prem_amt       IN giri_wfrps_ri.ri_prem_amt%TYPE,
        p_prem_tax          OUT giri_wfrps_ri.prem_tax%TYPE,
        p_ri_seq_no         OUT NUMBER,
        p_binder_id         IN OUT NUMBER,
        p_renew_sw          OUT VARCHAR2
        );
            
    PROCEDURE UPDATE_RI_COMM(
        p_line_cd           GIRI_WFRPS_PERIL_GRP.line_cd%TYPE,
        p_frps_yy           GIRI_WFRPS_PERIL_GRP.frps_yy%TYPE,
        p_frps_seq_no       GIRI_WFRPS_PERIL_GRP.frps_seq_no%TYPE,
        p_iss_cd            gipi_parlist.iss_cd%TYPE,
        p_ri_seq_no         GIRI_WFRPERIL.ri_seq_no%TYPE,
        p_reused_binder varchar2      
        );
        
    PROCEDURE post_form_commit_giris001(
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
        p_tot_fac_spct      IN GIRI_DISTFRPS.tot_fac_spct%TYPE,
        p_ri_flag           IN VARCHAR2
        );
        
    PROCEDURE copy_frps_ri(
        p_line_cd       IN giri_frps_ri.line_cd%TYPE,
        p_frps_yy       IN giri_frps_ri.frps_yy%TYPE,
        p_frps_seq_no   IN giri_frps_ri.frps_seq_no%TYPE,
        p_fnl_binder_id IN giri_frps_ri.fnl_binder_id%TYPE
    );
    
    PROCEDURE UPDATE_RI_COMM_GIUTS021(v_line_cd     IN giri_distfrps.line_cd%TYPE,
                         v_frps_yy     IN giri_distfrps.frps_yy%TYPE,
                         v_frps_seq_no IN giri_distfrps.frps_seq_no%TYPE); 
    	PROCEDURE get_tsi_prem_amt (
      p_dist_no             giuw_perilds_dtl.dist_no%TYPE,
      p_dist_seq_no         giuw_perilds_dtl.dist_seq_no%TYPE,
      p_peril_cd            giuw_perilds_dtl.peril_cd%TYPE,
      prem_amt        OUT   giuw_perilds_dtl.dist_prem%TYPE,
      tsi_amt         OUT   giuw_perilds_dtl.dist_tsi%TYPE
   );	                                   
END giri_wfrps_ri_pkg;
/


