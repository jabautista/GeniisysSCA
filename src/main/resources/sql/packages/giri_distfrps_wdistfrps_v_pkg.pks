CREATE OR REPLACE PACKAGE CPI.giri_distfrps_wdistfrps_v_pkg
AS
   TYPE giri_distfrps_wdistfrps_v_type IS RECORD (
      par_policy_id   giri_distfrps_wdistfrps_v.par_policy_id%TYPE,
      par_id          giri_distfrps_wdistfrps_v.par_id%TYPE,
      line_cd         giri_distfrps_wdistfrps_v.line_cd%TYPE,
      frps_yy         giri_distfrps_wdistfrps_v.frps_yy%TYPE,
      frps_seq_no     giri_distfrps_wdistfrps_v.frps_seq_no%TYPE,
      iss_cd          giri_distfrps_wdistfrps_v.iss_cd%TYPE,
      par_yy          giri_distfrps_wdistfrps_v.par_yy%TYPE,
      par_seq_no      giri_distfrps_wdistfrps_v.par_seq_no%TYPE,
      quote_seq_no    giri_distfrps_wdistfrps_v.quote_seq_no%TYPE,
      subline_cd      giri_distfrps_wdistfrps_v.subline_cd%TYPE,
      issue_yy        giri_distfrps_wdistfrps_v.issue_yy%TYPE,
      pol_seq_no      giri_distfrps_wdistfrps_v.pol_seq_no%TYPE,
      renew_no        giri_distfrps_wdistfrps_v.renew_no%TYPE,
      endt_iss_cd     giri_distfrps_wdistfrps_v.endt_iss_cd%TYPE,
      endt_yy         giri_distfrps_wdistfrps_v.endt_yy%TYPE,
      endt_seq_no     giri_distfrps_wdistfrps_v.endt_seq_no%TYPE,
      assd_name       giri_distfrps_wdistfrps_v.assd_name%TYPE,
      eff_date        giri_distfrps_wdistfrps_v.eff_date%TYPE,
      expiry_date     giri_distfrps_wdistfrps_v.expiry_date%TYPE,
      dist_no         giri_distfrps_wdistfrps_v.dist_no%TYPE,
      dist_seq_no     giri_distfrps_wdistfrps_v.dist_seq_no%TYPE,
      tot_fac_spct    giri_distfrps_wdistfrps_v.tot_fac_spct%TYPE,
      tsi_amt         giri_distfrps_wdistfrps_v.tsi_amt%TYPE,
      tot_fac_tsi     giri_distfrps_wdistfrps_v.tot_fac_tsi%TYPE,
      prem_amt        giri_distfrps_wdistfrps_v.prem_amt%TYPE,
      tot_fac_prem    giri_distfrps_wdistfrps_v.tot_fac_prem%TYPE,
      currency_desc   giri_distfrps_wdistfrps_v.currency_desc%TYPE,
      dist_flag       giri_distfrps_wdistfrps_v.dist_flag%TYPE,
      prem_warr_sw    giri_distfrps_wdistfrps_v.prem_warr_sw%TYPE,
      endt_type       giri_distfrps_wdistfrps_v.endt_type%TYPE,
      ri_flag         giri_distfrps_wdistfrps_v.ri_flag%TYPE,
      incept_date     giri_distfrps_wdistfrps_v.incept_date%TYPE,
      op_group_no     giri_distfrps_wdistfrps_v.op_group_no%TYPE,
      tot_fac_spct2   giri_distfrps_wdistfrps_v.tot_fac_spct2%TYPE,
      create_date     giri_distfrps_wdistfrps_v.create_date%TYPE
      --binder_yy       giri_distfrps_wdistfrps_v.binder_yy%TYPE,
      --binder_seq_no   giri_distfrps_wdistfrps_v.binder_seq_no%TYPE,
      --fnl_binder_id   giri_distfrps_wdistfrps_v.fnl_binder_id%TYPE
   );

   TYPE giri_distfrps_wdistfrps_v_tab IS TABLE OF giri_distfrps_wdistfrps_v_type;
   
   FUNCTION  get_wdistfrps_v_dtls (
   	    p_line_cd GIRI_DISTFRPS_WDISTFRPS_V.line_cd%TYPE,
   		p_frps_yy GIRI_DISTFRPS_WDISTFRPS_V.frps_yy%TYPE,
	    p_frps_seq_no GIRI_DISTFRPS_WDISTFRPS_V.frps_seq_no%TYPE
   ) RETURN giri_distfrps_wdistfrps_v_tab PIPELINED;
   
    TYPE giri_distfrps_wdistfrps_v_typ2 IS RECORD(
         par_policy_id              gipi_wpolbas.par_id%TYPE, 
         par_id                     gipi_wpolbas.par_id%TYPE, 
         line_cd                    giri_wdistfrps.line_cd%TYPE, 
         frps_yy                    giri_wdistfrps.frps_yy%TYPE,
         frps_seq_no                giri_wdistfrps.frps_seq_no%TYPE, 
         iss_cd                     gipi_parlist.iss_cd%TYPE, 
         par_yy                     gipi_parlist.par_yy%TYPE, 
         par_seq_no                 gipi_parlist.par_seq_no%TYPE, 
         quote_seq_no               gipi_parlist.quote_seq_no%TYPE,
         subline_cd                 gipi_wpolbas.subline_cd%TYPE, 
         issue_yy                   gipi_wpolbas.issue_yy%TYPE, 
         pol_seq_no                 gipi_wpolbas.pol_seq_no%TYPE, 
         renew_no                   gipi_wpolbas.renew_no%TYPE, 
         endt_iss_cd                gipi_wpolbas.endt_iss_cd%TYPE, 
         endt_yy                    gipi_wpolbas.endt_yy%TYPE,
         endt_seq_no                gipi_wpolbas.endt_seq_no%TYPE, 
         assd_name                  giis_assured.assd_name%TYPE, 
         eff_date                   giuw_pol_dist.eff_date%TYPE, 
         expiry_date                giuw_pol_dist.expiry_date%TYPE, 
         dist_no                    giri_wdistfrps.dist_no%TYPE,
         dist_seq_no                giri_wdistfrps.dist_seq_no%TYPE, 
         tot_fac_spct               giri_wdistfrps.tot_fac_spct%TYPE, 
         tsi_amt                    giri_wdistfrps.tsi_amt%TYPE, 
         tot_fac_tsi                giri_wdistfrps.tot_fac_tsi%TYPE, 
         prem_amt                   giri_wdistfrps.prem_amt%TYPE,
         tot_fac_prem               giri_wdistfrps.tot_fac_prem%TYPE, 
         currency_desc              giis_currency.currency_desc%TYPE, 
         dist_flag                  giuw_pol_dist.dist_flag%TYPE, 
         prem_warr_sw               giri_wdistfrps.prem_warr_sw%TYPE,
         create_date                giri_wdistfrps.create_date%TYPE, 
         user_id                    giri_wdistfrps.user_id%TYPE, 
         endt_type                  giuw_pol_dist.endt_type%TYPE, 
         ri_flag                    giri_wdistfrps.ri_flag%TYPE, 
         incept_date                gipi_wpolbas.incept_date%TYPE,
         op_group_no                giri_wdistfrps.op_group_no%TYPE, 
         tot_fac_spct2              giri_wdistfrps.tot_fac_spct2%TYPE,
         giri_wfrps_ri_count        NUMBER,
         ri_btn                     VARCHAR2(1),
         dist_by_tsi_prem           VARCHAR2(1)
        );
        
    TYPE giri_distfrps_wdistfrps_v_tab2 IS TABLE OF giri_distfrps_wdistfrps_v_typ2;                                                                                          
    
    FUNCTION get_giri_distfrps_wdistfrps_v(
        p_line_cd           giri_wdistfrps.line_cd%TYPE,
        p_frps_yy           giri_wdistfrps.frps_yy%TYPE,
        p_frps_seq_no       giri_wdistfrps.frps_seq_no%TYPE,
        p_module            VARCHAR2,
        p_user_id           giis_users.user_id%TYPE
        )
    RETURN giri_distfrps_wdistfrps_v_tab2 PIPELINED;
       
END giri_distfrps_wdistfrps_v_pkg;
/


