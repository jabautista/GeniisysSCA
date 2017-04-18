DROP PROCEDURE CPI.UPDATE_RI_WDISTFRPS_GIUWS005;

CREATE OR REPLACE PROCEDURE CPI.UPDATE_RI_WDISTFRPS_GIUWS005(p_dist_no         IN giuw_wpolicyds_dtl.dist_no%TYPE,
                              p_dist_seq_no     IN giuw_wpolicyds_dtl.dist_seq_no%TYPE,
                              p_new_tsi_amt     IN giuw_wpolicyds.tsi_amt%TYPE,
                              p_new_prem_amt    IN giuw_wpolicyds.prem_amt%TYPE,
                              p_new_dist_tsi    IN giuw_wpolicyds_dtl.dist_tsi%TYPE,
                              p_new_dist_prem   IN giuw_wpolicyds_dtl.dist_prem%TYPE, 
                              p_new_dist_spct   IN giuw_wpolicyds_dtl.dist_spct%TYPE,
         p_new_dist_spct1   IN giuw_wpolicyds_dtl.dist_spct1%TYPE,
                              p_new_currency_cd IN gipi_winvoice.currency_cd%TYPE,
                              p_new_currency_rt IN gipi_winvoice.currency_rt%TYPE,
                              p_new_user_id     IN giuw_pol_dist.user_id%TYPE) IS
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : April 05, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : UPDATE_RI_WDISTFRPS program unit
  */
  
  UPDATE giri_wdistfrps
     SET tsi_amt      = p_new_tsi_amt,
         prem_amt     = p_new_prem_amt,
         tot_fac_spct = p_new_dist_spct,
   tot_fac_spct2 = p_new_dist_spct1,
         tot_fac_prem = p_new_dist_prem,
         tot_fac_tsi  = p_new_dist_tsi,
         currency_cd  = p_new_currency_cd,
         currency_rt  = p_new_currency_rt,
         user_id      = p_new_user_id
   WHERE dist_seq_no  = p_dist_seq_no
     AND dist_no      = p_dist_no;
END;
/


