CREATE OR REPLACE PACKAGE CPI.GIRI_WDISTFRPS_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.17.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_giri_wdistfrps(p_dist_no	GIRI_WDISTFRPS.dist_no%TYPE);
    
    PROCEDURE del_giri_wdistfrps1(p_frps_seq_no IN GIRI_WDISTFRPS.frps_seq_no%TYPE,
                                  p_frps_yy     IN GIRI_WDISTFRPS.frps_yy%TYPE);
                                  
    PROCEDURE CREATE_RI_NEW_WDISTFRPS(p_dist_no         IN giuw_wpolicyds_dtl.dist_no%TYPE,
                                      p_dist_seq_no     IN giuw_wpolicyds_dtl.dist_seq_no%TYPE,
                                      p_new_tsi_amt     IN giuw_wpolicyds.tsi_amt%TYPE,
                                      p_new_prem_amt    IN giuw_wpolicyds.prem_amt%TYPE, 
                                      p_new_dist_tsi    IN giuw_wpolicyds_dtl.dist_tsi%TYPE, 
                                      p_new_dist_prem   IN giuw_wpolicyds_dtl.dist_prem%TYPE,
                                      p_new_dist_spct   IN giuw_wpolicyds_dtl.dist_spct%TYPE,
                                      p_new_currency_cd IN gipi_winvoice.currency_cd%TYPE,
                                      p_new_currency_rt IN gipi_winvoice.currency_rt%TYPE,
                                      p_new_user_id     IN giuw_pol_dist.user_id%TYPE,
                                      p_par_id          IN gipi_parlist.par_id%TYPE,
                                      p_line_cd         IN gipi_wpolbas.line_cd%TYPE,
                                      p_subline_cd      IN gipi_wpolbas.subline_cd%TYPE,
                                      p_new_dist_spct1  IN giuw_wpolicyds_dtl.dist_spct%TYPE);
                                      
    PROCEDURE UPDATE_RI_WDISTFRPS(p_dist_no         IN giuw_wpolicyds_dtl.dist_no%TYPE,
                                  p_dist_seq_no     IN giuw_wpolicyds_dtl.dist_seq_no%TYPE,
                                  p_new_tsi_amt     IN giuw_wpolicyds.tsi_amt%TYPE,
                                  p_new_prem_amt    IN giuw_wpolicyds.prem_amt%TYPE,
                                  p_new_dist_tsi    IN giuw_wpolicyds_dtl.dist_tsi%TYPE,
                                  p_new_dist_prem   IN giuw_wpolicyds_dtl.dist_prem%TYPE, 
                                  p_new_dist_spct   IN giuw_wpolicyds_dtl.dist_spct%TYPE,
                                  p_new_currency_cd IN gipi_winvoice.currency_cd%TYPE,
                                  p_new_currency_rt IN gipi_winvoice.currency_rt%TYPE,
                                  p_new_user_id     IN giuw_pol_dist.user_id%TYPE,
                                  p_new_dist_spct1   IN giuw_wpolicyds_dtl.dist_spct1%TYPE);
	
	PROCEDURE CREATE_NEW_WDISTFRPS_GIUWS013(
			  				   p_dist_no         IN giuw_wpolicyds_dtl.dist_no%TYPE,
							   p_dist_seq_no     IN giuw_wpolicyds_dtl.dist_seq_no%TYPE,
                               p_new_tsi_amt     IN giuw_wpolicyds.tsi_amt%TYPE,
                               p_new_prem_amt    IN giuw_wpolicyds.prem_amt%TYPE, 
                               p_new_dist_tsi    IN giuw_wpolicyds_dtl.dist_tsi%TYPE, 
                               p_new_dist_prem   IN giuw_wpolicyds_dtl.dist_prem%TYPE,
                               p_new_dist_spct   IN giuw_wpolicyds_dtl.dist_spct%TYPE,
                               p_new_currency_cd IN gipi_invoice.currency_cd%TYPE,
                               p_new_currency_rt IN gipi_invoice.currency_rt%TYPE,
                               p_new_user_id     IN giuw_pol_dist.user_id%TYPE,
							   p_line_cd         IN gipi_wpolbas.line_cd%TYPE,
                               p_subline_cd      IN gipi_wpolbas.subline_cd%TYPE,
							   p_policy_id 		 IN giuw_pol_dist.policy_id%TYPE);		
	PROCEDURE UPDATE_WDISTFRPS_GIUWS013(
		  				   p_dist_no         IN giuw_wpolicyds_dtl.dist_no%TYPE,
		  				   p_dist_seq_no     IN giuw_wpolicyds_dtl.dist_seq_no%TYPE,
                           p_new_tsi_amt     IN giuw_wpolicyds.tsi_amt%TYPE,
                           p_new_prem_amt    IN giuw_wpolicyds.prem_amt%TYPE,
                           p_new_dist_tsi    IN giuw_wpolicyds_dtl.dist_tsi%TYPE,
                           p_new_dist_prem   IN giuw_wpolicyds_dtl.dist_prem%TYPE, 
                           p_new_dist_spct   IN giuw_wpolicyds_dtl.dist_spct%TYPE,
                           p_new_currency_cd IN gipi_invoice.currency_cd%TYPE,
                           p_new_currency_rt IN gipi_invoice.currency_rt%TYPE,
                           p_new_user_id     IN giuw_pol_dist.user_id%TYPE);	
	PROCEDURE CREATE_WDISTFRPS_GIUWS013(
		  				   p_dist_no         IN giuw_wpolicyds_dtl.dist_no%TYPE,
		  				   p_old_dist_no     IN giuw_wpolicyds.dist_no%TYPE,
                           p_dist_seq_no     IN giuw_wpolicyds_dtl.dist_seq_no%TYPE,
                           p_new_tsi_amt     IN giuw_wpolicyds.tsi_amt%TYPE,
                           p_new_prem_amt    IN giuw_wpolicyds.prem_amt%TYPE,
                           p_new_dist_tsi    IN giuw_wpolicyds_dtl.dist_tsi%TYPE,
                           p_new_dist_prem   IN giuw_wpolicyds_dtl.dist_prem%TYPE, 
                           p_new_dist_spct   IN giuw_wpolicyds_dtl.dist_spct%TYPE, 
                           p_new_currency_cd IN gipi_invoice.currency_cd%TYPE,
                           p_new_currency_rt IN gipi_invoice.currency_rt%TYPE,
                           p_new_user_id     IN giuw_pol_dist.user_id%TYPE,
						   p_line_cd         IN gipi_wpolbas.line_cd%TYPE)	;
                           
    PROCEDURE UPDATE_WDISTFRPS_GIUWS016
                           (p_dist_no         IN  GIUW_POL_DIST.dist_no%TYPE,
                            p_dist_seq_no     IN  GIUW_WPOLICYDS_DTL.dist_seq_no%TYPE,
                            p_new_tsi_amt     IN  GIUW_WPOLICYDS.tsi_amt%TYPE,
                            p_new_prem_amt    IN  GIUW_WPOLICYDS.prem_amt%TYPE,
                            p_new_dist_tsi    IN  GIUW_WPOLICYDS_DTL.dist_tsi%TYPE,
                            p_new_dist_prem   IN  GIUW_WPOLICYDS_DTL.dist_prem%TYPE, 
                            p_new_dist_spct   IN  GIUW_WPOLICYDS_DTL.dist_spct%TYPE,
                            p_new_dist_spct1  IN  GIUW_WPOLICYDS_DTL.dist_spct1%TYPE,
                            p_new_currency_cd IN  GIPI_INVOICE.currency_cd%TYPE,
                            p_new_currency_rt IN  GIPI_INVOICE.currency_rt%TYPE,
                            p_new_user_id     IN  GIUW_POL_DIST.user_id%TYPE);
                            
    PROCEDURE CREATE_WDISTFRPS_GIUWS016
                           (p_dist_no         IN  GIUW_WPOLICYDS_DTL.dist_no%TYPE,
                            p_line_cd         IN  GIPI_WPOLBAS.line_cd%TYPE,
                            p_old_dist_no     IN  GIUW_WPOLICYDS.dist_no%TYPE,
                            p_dist_seq_no     IN  GIUW_WPOLICYDS_DTL.dist_seq_no%TYPE,
                            p_new_tsi_amt     IN  GIUW_WPOLICYDS.tsi_amt%TYPE,
                            p_new_prem_amt    IN  GIUW_WPOLICYDS.prem_amt%TYPE,
                            p_new_dist_tsi    IN  GIUW_WPOLICYDS_DTL.dist_tsi%TYPE,
                            p_new_dist_prem   IN  GIUW_WPOLICYDS_DTL.dist_prem%TYPE, 
                            p_new_dist_spct   IN  GIUW_WPOLICYDS_DTL.dist_spct%TYPE, 
                            p_new_dist_spct1  IN  GIUW_WPOLICYDS_DTL.dist_spct1%TYPE, 
                            p_new_currency_cd IN  GIPI_INVOICE.currency_cd%TYPE,
                            p_new_currency_rt IN  GIPI_INVOICE.currency_rt%TYPE,
                            p_new_user_id     IN  GIUW_POL_DIST.user_id%TYPE);
    PROCEDURE CREATE_RI_NEW_WDISTFRPS_016
                           (p_policy_id       IN  GIUW_POL_DIST.policy_id%TYPE,
                            p_dist_no         IN  GIUW_WPOLICYDS_DTL.dist_no%TYPE,
                            p_dist_seq_no     IN  GIUW_WPOLICYDS_DTL.dist_seq_no%TYPE,
                            p_new_tsi_amt     IN  GIUW_WPOLICYDS.tsi_amt%TYPE,
                            p_new_prem_amt    IN  GIUW_WPOLICYDS.prem_amt%TYPE, 
                            p_new_dist_tsi    IN  GIUW_WPOLICYDS_DTL.dist_tsi%TYPE, 
                            p_new_dist_prem   IN  GIUW_WPOLICYDS_DTL.dist_prem%TYPE,
                            p_new_dist_spct   IN  GIUW_WPOLICYDS_DTL.dist_spct%TYPE,
                            p_new_currency_cd IN  GIPI_WINVOICE.currency_cd%TYPE,
                            p_new_currency_rt IN  GIPI_WINVOICE.currency_rt%TYPE,
                            p_new_user_id     IN  GIUW_POL_DIST.user_id%TYPE,
                            p_par_id          IN  GIPI_PARLIST.par_id%TYPE,
                            p_line_cd         IN  GIPI_WPOLBAS.line_cd%TYPE,
                            p_subline_cd      IN  GIPI_WPOLBAS.subline_cd%TYPE);
                            
    PROCEDURE CREATE_NEW_WDISTFRPS_GIUWS016
                           (p_dist_no         IN  GIUW_WPOLICYDS_DTL.dist_no%TYPE,
                            p_dist_seq_no     IN  GIUW_WPOLICYDS_DTL.dist_seq_no%TYPE,
                            p_new_tsi_amt     IN  GIUW_WPOLICYDS.tsi_amt%TYPE,
                            p_new_prem_amt    IN  GIUW_WPOLICYDS.prem_amt%TYPE, 
                            p_new_dist_tsi    IN  GIUW_WPOLICYDS_DTL.dist_tsi%TYPE, 
                            p_new_dist_prem   IN  GIUW_WPOLICYDS_DTL.dist_prem%TYPE,
                            p_new_dist_spct   IN  GIUW_WPOLICYDS_DTL.dist_spct%TYPE,
                            p_new_dist_spct1  IN  GIUW_WPOLICYDS_DTL.dist_spct1%TYPE,
                            p_new_currency_cd IN  GIPI_INVOICE.currency_cd%TYPE,
                            p_new_currency_rt IN  GIPI_INVOICE.currency_rt%TYPE,
                            p_new_user_id     IN  GIUW_POL_DIST.user_id%TYPE,
                            p_line_cd         IN  GIPI_WPOLBAS.line_cd%TYPE,
                            p_subline_cd      IN  GIPI_WPOLBAS.subline_cd%TYPE,
                            p_policy_id       IN  GIUW_POL_DIST.policy_id%TYPE);
                            
    PROCEDURE PROCESS_DISTFRPS_GIUTS021(p_policy_id         IN     GIPI_POLBASIC_POL_DIST_V1.policy_id%TYPE,
                                       p_dist_no           IN     GIUW_POL_DIST.dist_no%TYPE,
                                       p_line_cd           IN     GIPI_POLBASIC_POL_DIST_V1.line_cd%TYPE,
                                       p_subline_cd        IN     GIPI_POLBASIC_POL_DIST_V1.subline_cd%TYPE,
                                       p_var_v_neg_distno  IN     GIUW_POL_DIST.dist_no%TYPE);
                                       
    PROCEDURE PROCESS_RI_GIUTS021(p_dist_no          IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                 p_v_post_flag      IN     VARCHAR2,
                                 p_var_v_neg_distno IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                 p_renew_flag       IN     GIPI_POLBASIC.renew_flag%TYPE,
                                 p_ratio            IN OUT NUMBER);
                                 
    FUNCTION CHECK_IF_FRPS_EXIST (p_dist_no     IN GIUW_WPOLICYDS.dist_no%TYPE,
                                  p_dist_seq_no IN GIUW_WPOLICYDS.dist_seq_no%TYPE) 
         RETURN VARCHAR2;
         
    PROCEDURE CREATE_WDISTFRPS_GIUWS015(p_dist_no       IN  GIUW_WPOLICYDS.dist_no%TYPE,
                                        p_policy_id     IN  GIUW_POL_DIST.policy_id%TYPE,
                                        p_user_id       IN  GIIS_USERS.user_id%TYPE);				   					   					  

END GIRI_WDISTFRPS_PKG;
/


