CREATE OR REPLACE PACKAGE CPI.csv_loss_ratio AS
/* Author: Udel
** Date: 01122012
** CLM-SPECS-2011-024
*/
  TYPE giclr204d_rectype IS RECORD (intm_no           VARCHAR2 (30),
                                    intm_name         giis_intermediary.intm_name%TYPE,
                                    loss_paid_amt     gicl_loss_ratio_ext.loss_paid_amt%TYPE,
                                    curr_loss_res     gicl_loss_ratio_ext.curr_loss_res%TYPE,
                                    prev_loss_res     gicl_loss_ratio_ext.prev_loss_res%TYPE,
                                    curr_prem_amt     gicl_loss_ratio_ext.curr_prem_amt%TYPE,
                                    prem_res_cy       gicl_loss_ratio_ext.curr_prem_res%TYPE,
                                    prem_res_py       gicl_loss_ratio_ext.prev_prem_res%TYPE,
                                    losses_incurred   gicl_loss_ratio_ext.loss_paid_amt%TYPE,
                                    premiums_earned   gicl_loss_ratio_ext.curr_prem_amt%TYPE,
                                    loss_ratio        NUMBER (12, 9));
  TYPE giclr204d_typ IS TABLE OF giclr204d_rectype;

  TYPE giclr204c_rectype IS RECORD (issue_name      VARCHAR2(100),
                                    loss_paid_amt   gicl_loss_ratio_ext.loss_paid_amt%TYPE,
                                    curr_loss_res   gicl_loss_ratio_ext.curr_loss_res%TYPE,
                                    prev_loss_res   gicl_loss_ratio_ext.prev_loss_res%TYPE,
                                    curr_prem_amt   gicl_loss_ratio_ext.curr_prem_amt%TYPE,
                                    prem_res_cy     gicl_loss_ratio_ext.curr_prem_res%TYPE,
                                    prem_res_py     gicl_loss_ratio_ext.prev_prem_res%TYPE,
                                    losses_incurred gicl_loss_ratio_ext.loss_paid_amt%TYPE,
                                    premiums_earned gicl_loss_ratio_ext.curr_prem_amt%TYPE,
                                    ratio           gicl_loss_ratio_ext.loss_paid_amt%TYPE);
  TYPE giclr204c_typ IS TABLE OF giclr204c_rectype;
  
  TYPE giclr204d3_pw_rectype IS RECORD (intm_name       VARCHAR2(100),
                                        month24         DATE,
                                        policy_no       VARCHAR2(100),
                                        assd            VARCHAR2(520),
                                        incept_date     gipi_polbasic.incept_date%TYPE,
                                        expiry_date     gipi_polbasic.expiry_date%TYPE,
                                        date_by         VARCHAR2(20),
                                        tsi_amt         gipi_polbasic.tsi_amt%TYPE,
                                        prem_amt        gicl_lratio_curr_prem_ext.prem_amt%TYPE);
  TYPE giclr204d3_pw_typ IS TABLE OF giclr204d3_pw_rectype;
  
  TYPE giclr204d3_loss_rectype IS RECORD (intm_name       VARCHAR2(100),
                                          claim_no        VARCHAR2(26),
                                          assd_name       VARCHAR2(520),
                                          dsp_loss_date   gicl_claims.dsp_loss_date%TYPE,
                                          clm_file_date   gicl_claims.clm_file_date%TYPE,
                                          amount          gicl_lratio_curr_os_ext.os_amt%TYPE);
  TYPE giclr204d3_os_typ IS TABLE OF giclr204d3_loss_rectype;
  TYPE giclr204d3_lp_typ IS TABLE OF giclr204d3_loss_rectype;
  
  TYPE giclr204d3_lr_rectype IS RECORD (intm_name       VARCHAR2(100),
                                        recovery_no     VARCHAR2(16),
                                        assd_name       VARCHAR2(520),
                                        rec_type_desc   giis_recovery_type.rec_type_desc%TYPE,
                                        loss_date       gicl_claims.dsp_loss_date%TYPE,
                                        amount          gicl_lratio_curr_recovery_ext.recovered_amt%TYPE);
  TYPE giclr204d3_lr_typ IS TABLE OF giclr204d3_lr_rectype;
  
  TYPE giclr204c3_rectype IS RECORD (iss_cd         VARCHAR2(100),
                                     lr_month       DATE,
                                     policy_no      VARCHAR2(100),
                                     assd_name      VARCHAR2(520),
                                     incept_date    gipi_polbasic.incept_date%TYPE,
                                     expiry_date    gipi_polbasic.expiry_date%TYPE,
                                     date_by        VARCHAR2(20),
                                     tsi_amt        gipi_polbasic.tsi_amt%TYPE,
                                     prem_amt       gicl_lratio_curr_prem_ext.prem_amt%TYPE,
                                     claim_no       VARCHAR2(26),
                                     loss_date      gicl_claims.dsp_loss_date%TYPE,
                                     file_date      gicl_claims.clm_file_date%TYPE,
                                     loss_amt       gicl_lratio_curr_os_ext.os_amt%TYPE,
                                     recovery_no    VARCHAR2(16),
                                     recovery_type  giis_recovery_type.rec_type_desc%TYPE,
                                     recovery_amt   gicl_lratio_curr_recovery_ext.recovered_amt%TYPE);
  TYPE giclr204c3_typ IS TABLE OF giclr204c3_rectype;
  --Start John Michael Mabini SR-5386 04042016
   TYPE report_type IS RECORD (
      Line                 VARCHAR2 (100),
      Subline              VARCHAR2 (100),
      Losses_Paid          VARCHAR2(50),
      Outstanding_Loss_CY  VARCHAR2(50),
      Outstanding_Loss_PY  VARCHAR2(50),
      Premiums_Written      VARCHAR2(50),
      Premiums_Reserve_CY  VARCHAR2(50),
      Premiums_Reserve_PY  VARCHAR2(50),
      Losses_Incurred      VARCHAR2(50),
      Premiums_Earned      VARCHAR2(50),
      Loss_Ratio           NUMBER
   );

   TYPE report_tab IS TABLE OF report_type;

   FUNCTION csv_giclr204B (
      p_assd_no      NUMBER,
      p_date         VARCHAR2,
      p_intm_no      NUMBER,
      p_iss_cd       VARCHAR2,
      p_line_cd      VARCHAR2,
      p_session_id   NUMBER,
      p_subline_cd   VARCHAR2
   )
      RETURN report_tab PIPELINED;
   --End
  -- GICLR204F2 CSV printing --  added by carlo de guzman 3.23.2016 for SR5395
  --added by carlo rubenecia 04.14.2015 SR 5395-- START
  TYPE prem_details_type1 IS RECORD(
      peril                 VARCHAR2(100),
      policy                VARCHAR2(50),
      assured               VARCHAR2 (550 BYTE),
      incept_date           VARCHAR2(20),
      expiry_date           VARCHAR2(20),
      issue_date            VARCHAR2(20),
      tsi_amount            VARCHAR2(50),
      premium_amount        VARCHAR2(50)
   );
  TYPE prem_details_tab1 IS TABLE OF prem_details_type1;
  
  TYPE prem_details_type2 IS RECORD(
      peril                 VARCHAR2(100),
      policy                VARCHAR2(50),
      assured               VARCHAR2 (550 BYTE),
      incept_date           VARCHAR(20),
      expiry_date           VARCHAR(20),
      acct_end_date         VARCHAR(20),
      tsi_amount            VARCHAR2(50),
      premium_amount        VARCHAR2(50)   
   );
  TYPE prem_details_tab2 IS TABLE OF prem_details_type2;
 
  TYPE prem_details_type3 IS RECORD(
      peril                 VARCHAR2(100),
      policy                VARCHAR2(50),
      assured               VARCHAR2 (550 BYTE),
      incept_date           VARCHAR2(20),
      expiry_date           VARCHAR2(20),
      booking_date          VARCHAR2(20),
      tsi_amount            VARCHAR2(50),
      premium_amount        VARCHAR2(50)
   );
  TYPE prem_details_tab3 IS TABLE OF prem_details_type3;
  
  TYPE os_details_type IS RECORD(
      peril             VARCHAR2(100),
      claim_no          VARCHAR2(50),
      assured           VARCHAR2 (550 BYTE), --modified by carlo rubenecia 04.15.2016 -start
      loss_date         VARCHAR2(20),         
      file_date         VARCHAR2(20),
      loss_amount       VARCHAR2(50)        --modified by carlo rubenecia 04.15.2016 -end
   );
  TYPE os_details_tab IS TABLE OF os_details_type;
  
  TYPE loss_paid_details_type IS RECORD(
      peril                 VARCHAR2(100),
      claim_no              VARCHAR2(100),
      assured               VARCHAR2 (550 BYTE), --modified by carlo rubenecia 04.15.2016 -start
      loss_date             VARCHAR2(20),
      loss_amount           VARCHAR2(50)        --modified by carlo rubenecia 04.15.2016 -end
   );
  TYPE loss_paid_details_tab IS TABLE OF loss_paid_details_type;
  
  TYPE rec_details_type IS RECORD(
      peril                 VARCHAR2(100),
      assured               VARCHAR2(100),
      recovery_type         giis_recovery_type.rec_type_desc%TYPE,
      loss_date             VARCHAR2(20), --modified by carlo rubenecia 04.15.2016 -start
      loss_amount           VARCHAR2(50)  --modified by carlo rubenecia 04.15.2016 -start
   );
  TYPE rec_details_tab IS TABLE OF rec_details_type;
  
  FUNCTION csv_giclr204F2_pw_cy1(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN prem_details_tab1 PIPELINED;
  
  FUNCTION csv_giclr204F2_pw_cy2(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN prem_details_tab2 PIPELINED;
   
  FUNCTION csv_giclr204F2_pw_cy3(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN prem_details_tab3 PIPELINED;
   
  FUNCTION csv_giclr204F2_pw_py1(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN prem_details_tab1 PIPELINED;
  
  FUNCTION csv_giclr204F2_pw_py2(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN prem_details_tab2 PIPELINED;
   
  FUNCTION csv_giclr204F2_pw_py3(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN prem_details_tab3 PIPELINED;
   
  --added by carlo rubenecia 04.14.2015 SR 5395-- END

  FUNCTION csv_giclr204F2_os_loss_cy(
      p_session_id          gicl_lratio_curr_os_ext.session_id%TYPE
   ) RETURN os_details_tab PIPELINED;
   
  FUNCTION csv_giclr204F2_os_loss_py(
      p_session_id          gicl_lratio_prev_os_ext.session_id%TYPE
   ) RETURN os_details_tab PIPELINED;
  
  FUNCTION csv_giclr204F2_losses_paid(
      p_session_id          gicl_lratio_loss_paid_ext.session_id%TYPE
   ) RETURN loss_paid_details_tab PIPELINED;
   
  FUNCTION csv_giclr204F2_loss_reco_cy(
      p_session_id          gicl_lratio_curr_recovery_ext.session_id%TYPE
   ) RETURN rec_details_tab PIPELINED;
   
  FUNCTION csv_giclr204F2_loss_reco_py(
      p_session_id          gicl_lratio_prev_recovery_ext.session_id%TYPE
   ) RETURN rec_details_tab PIPELINED;
    -- GICLR204F2 SR 5395 CSV printing end --
    
-- Start: added by Kevin SR-5389
   TYPE giclr204c2_record_type IS RECORD (
      issuing_source   VARCHAR2 (100),
      POLICY           VARCHAR2 (150),
      assured          VARCHAR2 (520),
      incept_date      VARCHAR2 (20),
      expiry_date      VARCHAR2 (20),
      tsi_amount       VARCHAR2 (20),
      premium_amount   VARCHAR2 (20)
   );

   TYPE giclr204c2_record_tab IS TABLE OF giclr204c2_record_type;

   TYPE giclr204c2_record1_type IS RECORD (
      issuing_source   VARCHAR2 (100),
      POLICY           VARCHAR2 (150),
      assured          VARCHAR2 (520),
      incept_date      VARCHAR2 (20),
      expiry_date      VARCHAR2 (20),
      issue_date       VARCHAR2 (20),
      tsi_amount       VARCHAR2 (20),
      premium_amount   VARCHAR2 (20)
   );

   TYPE giclr204c2_record1_tab IS TABLE OF giclr204c2_record1_type;

   TYPE giclr204c2_record3_type IS RECORD (
      issuing_source   VARCHAR2 (100),
      POLICY           VARCHAR2 (150),
      assured          VARCHAR2 (520),
      incept_date      VARCHAR2 (20),
      expiry_date      VARCHAR2 (20),
      acct_ent_date    VARCHAR2 (20),
      tsi_amount       VARCHAR2 (20),
      premium_amount   VARCHAR2 (20)
   );

   TYPE giclr204c2_record3_tab IS TABLE OF giclr204c2_record3_type;

   TYPE giclr204c2_record4_type IS RECORD (
      issuing_source   VARCHAR2 (100),
      POLICY           VARCHAR2 (150),
      assured          VARCHAR2 (520),
      incept_date      VARCHAR2 (20),
      expiry_date      VARCHAR2 (20),
      booking_date     VARCHAR2 (20),
      tsi_amount       VARCHAR2 (20),
      premium_amount   VARCHAR2 (20)
   );

   TYPE giclr204c2_record4_tab IS TABLE OF giclr204c2_record4_type;

   TYPE giclr204c2g7_record_type IS RECORD (
      issuing_source   VARCHAR2 (100),
      POLICY           VARCHAR2 (150),
      assured          VARCHAR2 (520),
      incept_date      VARCHAR2 (20),
      expiry_date      VARCHAR2 (20),
      tsi_amount       VARCHAR2 (20),
      premium_amount   VARCHAR2 (20)
   );

   TYPE giclr204c2g7_record_tab IS TABLE OF giclr204c2g7_record_type;

   TYPE giclr204c2g7_record1_type IS RECORD (
      issuing_source   VARCHAR2 (100),
      POLICY           VARCHAR2 (150),
      assured          VARCHAR2 (520),
      incept_date      VARCHAR2 (20),
      expiry_date      VARCHAR2 (20),
      issue_date       VARCHAR2 (20),
      tsi_amount       VARCHAR2 (20),
      premium_amount   VARCHAR2 (20)
   );

   TYPE giclr204c2g7_record1_tab IS TABLE OF giclr204c2g7_record1_type;

   TYPE giclr204c2g7_record3_type IS RECORD (
      issuing_source   VARCHAR2 (100),
      POLICY           VARCHAR2 (150),
      assured          VARCHAR2 (520),
      incept_date      VARCHAR2 (20),
      expiry_date      VARCHAR2 (20),
      acct_ent_date    VARCHAR2 (20),
      tsi_amount       VARCHAR2 (20),
      premium_amount   VARCHAR2 (20)
   );

   TYPE giclr204c2g7_record3_tab IS TABLE OF giclr204c2g7_record3_type;

   TYPE giclr204c2g7_record4_type IS RECORD (
      issuing_source   VARCHAR2 (100),
      POLICY           VARCHAR2 (150),
      assured          VARCHAR2 (520),
      incept_date      VARCHAR2 (20),
      expiry_date      VARCHAR2 (20),
      booking_date     VARCHAR2 (20),
      tsi_amount       VARCHAR2 (20),
      premium_amount   VARCHAR2 (20)
   );

   TYPE giclr204c2g7_record4_tab IS TABLE OF giclr204c2g7_record4_type;

   TYPE giclr204c2_claim_type IS RECORD (
      issuing_source   VARCHAR2 (100),
      claim_no         VARCHAR2 (150),
      assured          VARCHAR2 (520),
      loss_date        VARCHAR2 (20),
      file_date        VARCHAR2 (20),
      loss_amount      VARCHAR2 (20)
   );

   TYPE giclr204c2_claim_tab IS TABLE OF giclr204c2_claim_type;

   TYPE giclr204c2_claimg5_type IS RECORD (
      issuing_source   VARCHAR2 (100),
      claim_no         VARCHAR2 (150),
      assured          VARCHAR2 (520),
      loss_date        VARCHAR2 (20),
      file_date        VARCHAR2 (20),
      losst_amount     VARCHAR2 (20)
   );

   TYPE giclr204c2_claimg5_tab IS TABLE OF giclr204c2_claimg5_type;

   TYPE giclr204c2_claimg9_type IS RECORD (
      issuing_source   VARCHAR2 (100),
      claim_no         VARCHAR2 (150),
      assured          VARCHAR2 (520),
      loss_date        VARCHAR2 (20),
      loss_amount      VARCHAR2 (20)
   );

   TYPE giclr204c2_claimg9_tab IS TABLE OF giclr204c2_claimg9_type;

   TYPE giclr204c2_recoveryg11_type IS RECORD (
      issuing_source     VARCHAR2 (100),
      recovery_no        VARCHAR2 (150),
      assured            VARCHAR2 (520),
      recovery_type      VARCHAR2 (50),
      loss_date          VARCHAR2 (20),
      recovered_amount   VARCHAR2 (20)
   );

   TYPE giclr204c2_recoveryg11_tab IS TABLE OF giclr204c2_recoveryg11_type;

   TYPE giclr204c2_recoveryg13_type IS RECORD (
      issuing_source     VARCHAR2 (100),
      recovery_no        VARCHAR2 (150),
      assured            VARCHAR2 (520),
      recovery_type      VARCHAR2 (50),
      loss_date          VARCHAR2 (20),
      recovered_amount   VARCHAR2 (20)
   );

   TYPE giclr204c2_recoveryg13_tab IS TABLE OF giclr204c2_recoveryg13_type;

   FUNCTION csv_giclr204c2_records (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_line_cd           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2_record_tab PIPELINED;

   FUNCTION csv_giclr204c2_records1 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_line_cd           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2_record1_tab PIPELINED;

   FUNCTION csv_giclr204c2_records3 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_line_cd           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2_record3_tab PIPELINED;

   FUNCTION csv_giclr204c2_records4 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_line_cd           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2_record4_tab PIPELINED;

   FUNCTION csv_giclr204c2g7_records (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_line_cd           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2g7_record_tab PIPELINED;

   FUNCTION csv_giclr204c2g7_records1 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_line_cd           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2g7_record1_tab PIPELINED;

   FUNCTION csv_giclr204c2g7_records3 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_line_cd           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2g7_record3_tab PIPELINED;

   FUNCTION csv_giclr204c2g7_records4 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_line_cd           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2g7_record4_tab PIPELINED;

   FUNCTION csv_giclr204c2_claim (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_line_cd           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2_claim_tab PIPELINED;

   FUNCTION csv_giclr204c2_claimg5 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_line_cd           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2_claimg5_tab PIPELINED;

   FUNCTION csv_giclr204c2_claimg9 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_line_cd           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2_claimg9_tab PIPELINED;

   FUNCTION csv_giclr204c2_recoveryg11 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_line_cd           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2_recoveryg11_tab PIPELINED;

   FUNCTION csv_giclr204c2_recoveryg13 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_line_cd           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_prnt_date         NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c2_recoveryg13_tab PIPELINED;

   FUNCTION amount_format (amount NUMBER)
      RETURN VARCHAR2;

   FUNCTION DATE_FORMAT (v_date DATE)
      RETURN VARCHAR2;
-- End: Kevin SR-5389
-- printGICLR204A2CSV added by carlo 3.16.2016 SR-5384
   TYPE giclr204a2_type IS RECORD (
      line          VARCHAR2 (100),
      POLICY        VARCHAR2 (200),
      assured       VARCHAR2 (520),
      incept_date   VARCHAR2 (20),
      expiry_date   VARCHAR2 (20),
      tsi_amt       VARCHAR2 (20),
      prem_amt      VARCHAR2 (20)
   );

   TYPE giclr204a2_tab IS TABLE OF giclr204a2_type;

   FUNCTION csv_giclr204a2_prem_writ_cy (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204a2_tab PIPELINED;

--Start: kevin 4-8-2016 SR-5384
   TYPE giclr204a2_type1 IS RECORD (
      line          VARCHAR2 (100),
      POLICY        VARCHAR2 (200),
      assured       VARCHAR2 (520),
      incept_date   VARCHAR2 (20),
      expiry_date   VARCHAR2 (20),
      issue_date    VARCHAR2 (20),
      tsi_amt       VARCHAR2 (20),
      prem_amt      VARCHAR2 (20)
   );

   TYPE giclr204a2_tab1 IS TABLE OF giclr204a2_type1;

   FUNCTION csv_giclr204a2_prem_writ_cy1 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204a2_tab1 PIPELINED;

   TYPE giclr204a2_type3 IS RECORD (
      line            VARCHAR2 (100),
      POLICY          VARCHAR2 (200),
      assured         VARCHAR2 (520),
      incept_date     VARCHAR2 (20),
      expiry_date     VARCHAR2 (20),
      acct_ent_date   VARCHAR2 (20),
      tsi_amt         VARCHAR2 (20),
      prem_amt        VARCHAR2 (20)
   );

   TYPE giclr204a2_tab3 IS TABLE OF giclr204a2_type3;

   FUNCTION csv_giclr204a2_prem_writ_cy3 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204a2_tab3 PIPELINED;

   TYPE giclr204a2_type4 IS RECORD (
      line           VARCHAR2 (100),
      POLICY         VARCHAR2 (200),
      assured        VARCHAR2 (520),
      incept_date    VARCHAR2 (20),
      expiry_date    VARCHAR2 (20),
      booking_date   VARCHAR2 (20),
      tsi_amt        VARCHAR2 (20),
      prem_amt       VARCHAR2 (20)
   );

   TYPE giclr204a2_tab4 IS TABLE OF giclr204a2_type4;

   FUNCTION csv_giclr204a2_prem_writ_cy4 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204a2_tab4 PIPELINED;

--End: Kevin SR-5384
   FUNCTION csv_giclr204a2_prem_writ_py (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204a2_tab PIPELINED;

--Start added by Kevin 4-11-2016 SR-5384
   FUNCTION csv_giclr204a2_prem_writ_py1 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204a2_tab1 PIPELINED;

   FUNCTION csv_giclr204a2_prem_writ_py3 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204a2_tab3 PIPELINED;

   FUNCTION csv_giclr204a2_prem_writ_py4 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204a2_tab4 PIPELINED;

--End: Kevin SR-5384
   TYPE giclr204a3_type IS RECORD (
      line        VARCHAR2 (100),
      claim_no    VARCHAR2 (200),
      assured     VARCHAR2 (520),
      loss_date   VARCHAR2 (20),
      file_date   VARCHAR2 (20),
      loss_amt    VARCHAR2 (20)
   );

   TYPE giclr204a3_tab IS TABLE OF giclr204a3_type;

   FUNCTION csv_giclr204a2_os_loss_cy (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204a3_tab PIPELINED;

   FUNCTION csv_giclr204a2_os_loss_py (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204a3_tab PIPELINED;

   TYPE giclr204a4_type IS RECORD (
      line        VARCHAR2 (100),
      claim_no    VARCHAR2 (200),
      assured     VARCHAR2 (520),
      loss_date   VARCHAR2 (20),
      loss_amt    VARCHAR2 (20)
   );

   TYPE giclr204a4_tab IS TABLE OF giclr204a4_type;

   FUNCTION csv_giclr204a2_losses_paid (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204a4_tab PIPELINED;

   TYPE giclr204a5_type IS RECORD (
      line        VARCHAR2 (100),
      rec_no      VARCHAR2 (200),
      assured     VARCHAR2 (520),
      rec_type    giis_recovery_type.rec_type_desc%TYPE,
      loss_date   VARCHAR2 (20),
      rec_amt     VARCHAR2 (20)
   );

   TYPE giclr204a5_tab IS TABLE OF giclr204a5_type;

   FUNCTION csv_giclr204a2_loss_reco_cy (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204a5_tab PIPELINED;

   FUNCTION csv_giclr204a2_loss_reco_py (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204a5_tab PIPELINED;

   -- END  printGICLR204A2CSV SR-5384 --

   -- printGICLR204A3_q3_CSV added by carlo de guzman 3.18.2016 SR-5385 --
   TYPE giclr204a3_q3_record_type IS RECORD (
      line               VARCHAR2 (100),
      transaction_date   VARCHAR2 (100),
      POLICY             VARCHAR2 (30),
      assured            VARCHAR2 (700),
      incept_date        VARCHAR2 (20),
      expiry_date        VARCHAR2 (20),
      acct_ent_date      VARCHAR2 (20),
      tsi_amount         VARCHAR2 (20),
      premium_amount     VARCHAR2 (20)
   );

   TYPE giclr204a3_q3_record_tab IS TABLE OF giclr204a3_q3_record_type;

   FUNCTION csv_giclr204a3_prem_written_cy (
      p_session_id   NUMBER,
      p_prnt_date    VARCHAR2
   )
      RETURN giclr204a3_q3_record_tab PIPELINED;

   -- printGICLR204A3_q3_CSV END --

   -- printGICLR204A3_q4_CSV added by carlo de guzman 3.18.2016 SR-5385--
   FUNCTION csv_giclr204a3_prem_written_py (
      p_session_id   NUMBER,
      p_prnt_date    VARCHAR2
   )
      RETURN giclr204a3_q3_record_tab PIPELINED;

   -- printGICLR204A3_q4_CSV END --
   TYPE giclr204a3_q1_record_type IS RECORD (
      line          VARCHAR2 (100),
      claim_no      VARCHAR2 (200),
      assured       VARCHAR2 (520),
      loss_date     VARCHAR2 (20),
      file_date     VARCHAR2 (20),
      loss_amount   VARCHAR2 (20)
   );

   TYPE giclr204a3_q1_record_tab IS TABLE OF giclr204a3_q1_record_type;

   FUNCTION csv_giclr204a3_os_loss_cy (p_session_id NUMBER)
      RETURN giclr204a3_q1_record_tab PIPELINED;

   FUNCTION csv_giclr204a3_os_loss_py (p_session_id NUMBER)
      RETURN giclr204a3_q1_record_tab PIPELINED;

   TYPE giclr204a3_q5_record_type IS RECORD (
      line          VARCHAR2 (100),
      claim_no      VARCHAR2 (200),
      assured       VARCHAR2 (520),
      loss_date     VARCHAR2 (20),
      loss_amount   VARCHAR2 (20)
   );

   TYPE giclr204a3_q5_record_tab IS TABLE OF giclr204a3_q5_record_type;

   FUNCTION csv_giclr204a3_losses_paid (p_session_id NUMBER)
      RETURN giclr204a3_q5_record_tab PIPELINED;

   TYPE giclr204a3_q6_record_type IS RECORD (
      line               VARCHAR2 (100),
      recovery_no        VARCHAR2 (200),
      assured            VARCHAR2 (520),
      recovery_type      giis_recovery_type.rec_type_desc%TYPE,
      loss_date          VARCHAR2 (20),
      recovered_amount   VARCHAR2 (20)
   );

   TYPE giclr204a3_q6_record_tab IS TABLE OF giclr204a3_q6_record_type;

   FUNCTION csv_giclr204a3_loss_reco_cy (p_session_id NUMBER)
      RETURN giclr204a3_q6_record_tab PIPELINED;

   FUNCTION csv_giclr204a3_loss_reco_py (p_session_id NUMBER)
      RETURN giclr204a3_q6_record_tab PIPELINED;
      
   ---- end SR-5385 -------
    
    -- printGICLR204E added by Mark Anthony Salazar  03.22.2016--
   TYPE giclr204e_record_type IS RECORD (
      assured           VARCHAR2 (500),
      losses_paid     gicl_loss_ratio_ext.loss_paid_amt%TYPE,
      outstanding_loss_current_year     gicl_loss_ratio_ext.curr_loss_res%TYPE,
      outstanding_loss_previous_year     gicl_loss_ratio_ext.prev_loss_res%TYPE,
      premiums_written     gicl_loss_ratio_ext.curr_prem_amt%TYPE,
      premiums_reserve_current_year       gicl_loss_ratio_ext.curr_prem_res%TYPE,
      premiums_reserve_previous_year       gicl_loss_ratio_ext.prev_prem_res%TYPE,
      losses_incurred   gicl_loss_ratio_ext.loss_paid_amt%TYPE,
      premiums_earned   gicl_loss_ratio_ext.curr_prem_amt%TYPE,
      loss_ratio      gicl_loss_ratio_ext.curr_prem_amt%TYPE
   );

   TYPE giclr204e_record_tab IS TABLE OF giclr204e_record_type;

   FUNCTION csv_giclr204E (
      p_assd_no      NUMBER,
      p_intm_no      NUMBER,
      p_iss_cd       VARCHAR2,
      p_line_cd      VARCHAR2,
      p_session_id   NUMBER,
      p_subline_cd   VARCHAR2,
      p_date         VARCHAR2
   )
      RETURN giclr204e_record_tab PIPELINED;
    
     -- end printGICLR204E --
    
     -- GICLR204D2 added by John Daniel Marasigan 03.22.2016
    
    TYPE csv_giclr204D2_rec_pwcy_a IS RECORD (
        Intermediary      varchar2(500),
        Policy            varchar2(40),
        Assured           giis_assured.ASSD_NAME%TYPE,
        Incept_Date       gipi_polbasic.INCEPT_DATE%TYPE,
        Expiry_Date       gipi_polbasic.EXPIRY_DATE%TYPE,
        Issue_Date        gipi_polbasic.ISSUE_DATE%TYPE,
        TSI_Amount        gipi_polbasic.TSI_AMT%TYPE,
        Premium_Amount    gipi_polbasic.PREM_AMT%TYPE
    );
    
    TYPE csv_giclr204d2_tab_pwcy_a IS TABLE OF csv_giclr204D2_rec_pwcy_a;
    
    TYPE csv_giclr204D2_rec_pwcy_b IS RECORD (
        Intermediary      varchar2(500),
        Policy            varchar2(40),
        Assured           giis_assured.ASSD_NAME%TYPE,
        Incept_Date       gipi_polbasic.INCEPT_DATE%TYPE,
        Expiry_Date       gipi_polbasic.EXPIRY_DATE%TYPE,
        Acct_Ent_Date     gipi_polbasic.ISSUE_DATE%TYPE,
        TSI_Amount        gipi_polbasic.TSI_AMT%TYPE,
        Premium_Amount    gipi_polbasic.PREM_AMT%TYPE
    );
    
    TYPE csv_giclr204d2_tab_pwcy_b IS TABLE OF csv_giclr204D2_rec_pwcy_b;
    
    TYPE csv_giclr204D2_rec_pwcy_c IS RECORD (
        Intermediary      varchar2(500),
        Policy            varchar2(40),
        Assured           giis_assured.ASSD_NAME%TYPE,
        Incept_Date       gipi_polbasic.INCEPT_DATE%TYPE,
        Expiry_Date       gipi_polbasic.EXPIRY_DATE%TYPE,
        Booking_Date        gipi_polbasic.ISSUE_DATE%TYPE,
        TSI_Amount        gipi_polbasic.TSI_AMT%TYPE,
        Premium_Amount    gipi_polbasic.PREM_AMT%TYPE
    );
    
    TYPE csv_giclr204d2_tab_pwcy_c IS TABLE OF csv_giclr204D2_rec_pwcy_c;
    
    TYPE csv_giclr204D2_rec_pwpy_a IS RECORD (
        Intermediary     varchar2(100),
        Policy           varchar2(40),
        Assured          giis_assured.ASSD_NAME%TYPE,
        Incept_Date      gipi_polbasic.INCEPT_DATE%TYPE,
        Expiry_Date      gipi_polbasic.EXPIRY_DATE%TYPE,
        Issue_Date       varchar2(40),
        TSI_Amount       gipi_polbasic.TSI_AMT%TYPE,
        Premium_Amount   gipi_polbasic.PREM_AMT%TYPE
    );

    TYPE csv_giclr204D2_tab_pwpy_a IS TABLE OF csv_giclr204D2_rec_pwpy_a;
    
    TYPE csv_giclr204D2_rec_pwpy_b IS RECORD (
        Intermediary     varchar2(100),
        Policy           varchar2(40),
        Assured          giis_assured.ASSD_NAME%TYPE,
        Incept_Date      gipi_polbasic.INCEPT_DATE%TYPE,
        Expiry_Date      gipi_polbasic.EXPIRY_DATE%TYPE,
        Acct_Ent_Date    varchar2(40),
        TSI_Amount       gipi_polbasic.TSI_AMT%TYPE,
        Premium_Amount   gipi_polbasic.PREM_AMT%TYPE
    );

    TYPE csv_giclr204D2_tab_pwpy_b IS TABLE OF csv_giclr204D2_rec_pwpy_b;
    
     TYPE csv_giclr204D2_rec_pwpy_c IS RECORD (
        Intermediary     varchar2(100),
        Policy           varchar2(40),
        Assured          giis_assured.ASSD_NAME%TYPE,
        Incept_Date      gipi_polbasic.INCEPT_DATE%TYPE,
        Expiry_Date      gipi_polbasic.EXPIRY_DATE%TYPE,
        Booking_Date     varchar2(40),
        TSI_Amount       gipi_polbasic.TSI_AMT%TYPE,
        Premium_Amount   gipi_polbasic.PREM_AMT%TYPE
    );

    TYPE csv_giclr204D2_tab_pwpy_c IS TABLE OF csv_giclr204D2_rec_pwpy_c;
    
    TYPE csv_giclr204d2_rec_lp IS RECORD (
        Intermediary     varchar2(100),
        Claim_No         varchar2(40),
        Assured          giis_assured.ASSD_NAME%TYPE,
        Loss_Date        gicl_claims.dsp_loss_date%TYPE,
        Loss_Amount      gicl_lratio_curr_os_ext.OS_AMT%TYPE         
    );
    
    TYPE csv_giclr204d2_tab_lp IS TABLE OF csv_giclr204d2_rec_lp; 
    
    TYPE csv_giclr204d2_rec_ol IS RECORD (
        Intermediary     varchar2(100),
        Claim            varchar2(40),
        Assured          giis_assured.ASSD_NAME%TYPE,
        Loss_Date        gicl_claims.dsp_loss_date%TYPE,
        File_Date        gicl_claims.clm_file_date%TYPE,
        Loss_Amount      gicl_lratio_curr_os_ext.OS_AMT%TYPE        
    );
    TYPE csv_giclr204d2_tab_ol IS TABLE OF csv_giclr204d2_rec_ol;
     
    TYPE csv_giclr204d2_rec_lrcy IS RECORD (
      Intermediary       varchar2(100),
      Recovery_No        varchar2(100),
      Assured            giis_assured.ASSD_NAME%TYPE,
      Recovery_Type      giis_recovery_type.REC_TYPE_DESC%TYPE,
      Loss_Date          gicl_claims.dsp_loss_date%type,
      Recovered_Amount   gicl_lratio_curr_recovery_ext.RECOVERED_AMT%TYPE 
    );
    TYPE csv_giclr204d2_tab_lrcy IS TABLE OF csv_giclr204d2_rec_lrcy;
    
    TYPE csv_giclr204d2_rec_lrpy IS RECORD (
      Intermediary       varchar2(100),
      Recovery_No        varchar2(100),
      Assured            giis_assured.ASSD_NAME%TYPE,
      Recovery_Type      giis_recovery_type.REC_TYPE_DESC%TYPE,
      Loss_Date          gicl_claims.dsp_loss_date%type,
      Recovered_Amount   gicl_lratio_curr_recovery_ext.RECOVERED_AMT%TYPE 
    );
    TYPE csv_giclr204d2_tab_lrpy IS TABLE OF csv_giclr204d2_rec_lrpy;
    
    FUNCTION csv_giclr204D2_pwcy_a(
        p_session_id        gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_curr_start_date   varchar2,
        p_curr_end_date     varchar2,
        p_print_date        varchar2
    )
    RETURN csv_giclr204d2_tab_pwcy_a PIPELINED;
    
    FUNCTION csv_giclr204D2_pwcy_b(
        p_session_id        gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_curr_start_date   varchar2,
        p_curr_end_date     varchar2,
        p_print_date        varchar2
    )
    RETURN csv_giclr204d2_tab_pwcy_b PIPELINED;
    
    FUNCTION csv_giclr204D2_pwcy_c(
        p_session_id        gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_curr_start_date   varchar2,
        p_curr_end_date     varchar2,
        p_print_date        varchar2
    )
    RETURN csv_giclr204d2_tab_pwcy_c PIPELINED;
    
    FUNCTION csv_giclr204D2_pwpy_a(
        p_session_id        gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_prev_year         varchar2,
        p_print_date        varchar2
    )
    RETURN csv_giclr204D2_tab_pwpy_a PIPELINED;
    
    FUNCTION csv_giclr204D2_pwpy_b(
        p_session_id        gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_prev_year         varchar2,
        p_print_date        varchar2
    )
    RETURN csv_giclr204D2_tab_pwpy_b PIPELINED;
    
    FUNCTION csv_giclr204D2_pwpy_c(
        p_session_id        gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_prev_year         varchar2,
        p_print_date        varchar2
    )
    RETURN csv_giclr204D2_tab_pwpy_c PIPELINED;
    
    FUNCTION csv_giclr204d2_lp(
        p_session_id        gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_curr_year         varchar2
    )
    RETURN csv_giclr204d2_tab_lp PIPELINED;
    
    FUNCTION csv_giclr204d2_olcy(
        p_session_id        gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_curr_end_date     varchar2
    )
    RETURN csv_giclr204d2_tab_ol PIPELINED;
    
    FUNCTION csv_giclr204d2_olpy(
        p_session_id        gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_prev_end_date     varchar2
    )
    RETURN csv_giclr204d2_tab_ol PIPELINED;
    
    FUNCTION csv_giclr204d2_lrcy(
        p_session_id        gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_curr_start_dt     varchar2,
        p_curr_end_dt       varchar2
    )
    RETURN csv_giclr204d2_tab_lrcy PIPELINED;
    
    FUNCTION csv_giclr204d2_lrpy(
        p_session_id        gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_prev_year         number
    )
    RETURN csv_giclr204d2_tab_lrpy PIPELINED;
    
    FUNCTION get_datevalue(
        p_prnt_date         varchar2,
        p_policy_id         GIPI_POLBASIC.POLICY_ID%TYPE  
    )
    RETURN varchar2;
 
 -- GICLR204D2 end
    
   -- Start: Added by Mary Cris Invento 04.04.2016 SR 5392
  TYPE giclr204e2_pwcy_issue_type IS RECORD(
      assured               VARCHAR2(500),
      policy                VARCHAR2(50),
      incept_date           VARCHAR(20),
      expiry_date           VARCHAR(20),
      issue_date            VARCHAR(20),
      tsi_amount            VARCHAR2(50),
      premium_amount        VARCHAR2(50)
  );
   
  TYPE giclr204e2_pwcy_issue_tab IS TABLE OF giclr204e2_pwcy_issue_type;
   
  TYPE giclr204e2_pwcy_acctg_type IS RECORD(
      assured               VARCHAR2(500),
      policy                VARCHAR2(50),
      incept_date           VARCHAR(20),
      expiry_date           VARCHAR(20),
      acct_ent_date         VARCHAR(20),
      tsi_amount            VARCHAR2(50),
      premium_amount        VARCHAR2(50)
  );
   
  TYPE giclr204e2_pwcy_acctg_tab IS TABLE OF giclr204e2_pwcy_acctg_type;
   
  TYPE giclr204e2_pwcy_bking_type IS RECORD(
      assured               VARCHAR2(500),
      policy                VARCHAR2(50),
      incept_date           VARCHAR(20),
      expiry_date           VARCHAR(20),
      booking_date          VARCHAR(20),
      tsi_amount            VARCHAR2(50),
      premium_amount        VARCHAR2(50)
  );
   
  TYPE giclr204e2_pwcy_bking_tab IS TABLE OF giclr204e2_pwcy_bking_type;
   
  TYPE giclr204e2_pwpy_issue_type IS RECORD(
      assured               VARCHAR2(500),
      policy                VARCHAR2(50),
      incept_date           VARCHAR(20),
      expiry_date           VARCHAR(20),
      issue_date            VARCHAR(20),
      tsi_amount            VARCHAR2(50),
      premium_amount        VARCHAR2(50)
  );
   
  TYPE giclr204e2_pwpy_issue_tab IS TABLE OF giclr204e2_pwpy_issue_type;
   
  TYPE giclr204e2_pwpy_acctg_type IS RECORD(
      assured               VARCHAR2(500),
      policy                VARCHAR2(50),
      incept_date           VARCHAR(20),
      expiry_date           VARCHAR(20),
      acct_ent_date         VARCHAR(20),
      tsi_amount            VARCHAR2(50),
      premium_amount        VARCHAR2(50)
  );
   
  TYPE giclr204e2_pwpy_acctg_tab IS TABLE OF giclr204e2_pwpy_acctg_type;
   
  TYPE giclr204e2_pwpy_bking_type IS RECORD(
      assured               VARCHAR2(500),
      policy                VARCHAR2(50),
      incept_date           VARCHAR(20),
      expiry_date           VARCHAR(20),
      booking_date          VARCHAR(20),
      tsi_amount            VARCHAR2(50),
      premium_amount        VARCHAR2(50)
  );
   
  TYPE giclr204e2_pwpy_bking_tab IS TABLE OF giclr204e2_pwpy_bking_type;
   
  TYPE os_details_type2 IS RECORD(
      assured               VARCHAR2(500),
      claim_no              VARCHAR2(50),
      loss_date             VARCHAR(20),
      file_date             VARCHAR(20),
      loss_amount           VARCHAR2(50)
  );
   
  TYPE os_details_tab2 IS TABLE OF os_details_type2;
   
  TYPE loss_paid_details_type2 IS RECORD(
      assured               VARCHAR2(500),
      claim_no              VARCHAR2(50),
      loss_date             VARCHAR(20),
      loss_amount           VARCHAR2(50)
  );
   
  TYPE loss_paid_details_tab2 IS TABLE OF loss_paid_details_type2;
  
  TYPE rec_details_type2 IS RECORD(
      assured               VARCHAR2(500),
      recovery_no           VARCHAR2(50),
      recovery_type         giis_recovery_type.rec_type_desc%TYPE,
      loss_date             VARCHAR(20),
      recovered_amount      VARCHAR2(50)
  );
   
  TYPE rec_details_tab2 IS TABLE OF rec_details_type2;
   
  FUNCTION CSV_GICLR204E2_PW_CY_ISSUE(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN giclr204e2_pwcy_issue_tab PIPELINED;

  FUNCTION CSV_GICLR204E2_PW_CY_ACCTG(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN giclr204e2_pwcy_acctg_tab PIPELINED;

  FUNCTION CSV_GICLR204E2_PW_CY_BKING(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN giclr204e2_pwcy_bking_tab PIPELINED;

  FUNCTION CSV_GICLR204E2_PW_PY_ISSUE(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN giclr204e2_pwpy_issue_tab PIPELINED;
   
  FUNCTION CSV_GICLR204E2_PW_PY_ACCTG(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN giclr204e2_pwpy_acctg_tab PIPELINED;
   
  FUNCTION CSV_GICLR204E2_PW_PY_BKING(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN giclr204e2_pwpy_bking_tab PIPELINED;
   
  FUNCTION CSV_GICLR204E2_OS_CY(
      p_session_id          gicl_lratio_curr_os_ext.session_id%TYPE
   ) RETURN os_details_tab2 PIPELINED;
   
  FUNCTION CSV_GICLR204E2_OS_PY(
      p_session_id          gicl_lratio_prev_os_ext.session_id%TYPE
   ) RETURN os_details_tab2 PIPELINED;
   
  FUNCTION CSV_GICLR204E2_LP(
      p_session_id          gicl_lratio_loss_paid_ext.session_id%TYPE
   ) RETURN loss_paid_details_tab2 PIPELINED;
   
  FUNCTION CSV_GICLR204E2_LR_CY(
      p_session_id          gicl_lratio_curr_recovery_ext.session_id%TYPE
   ) RETURN rec_details_tab2 PIPELINED;
   
  FUNCTION CSV_GICLR204E2_LR_PY(
      p_session_id          gicl_lratio_prev_recovery_ext.session_id%TYPE
   ) RETURN rec_details_tab2 PIPELINED;
   
  FUNCTION CSV_GICLR204E2_GET_CF_DATE(
        p_prnt_date         VARCHAR2,
        p_policy_id         gipi_polbasic.policy_id%TYPE  
    )
    RETURN VARCHAR2;
   -- End: Added by Mary Cris Invento 04.04.2016 SR 5392

  FUNCTION giclr204d (p_session_id NUMBER)
    RETURN giclr204d_typ PIPELINED;
  
  FUNCTION giclr204c (p_session_id NUMBER)
    RETURN giclr204c_typ PIPELINED;
    
  FUNCTION giclr204d3_pw(p_session_id   NUMBER,
                         p_date         VARCHAR2,
                         p_prnt_date    NUMBER)
    RETURN giclr204d3_pw_typ PIPELINED;

  FUNCTION giclr204d3_os(p_session_id   NUMBER,
                         p_date         VARCHAR2)
    RETURN giclr204d3_os_typ PIPELINED;
    
  FUNCTION giclr204d3_lp(p_session_id   NUMBER)
    RETURN giclr204d3_lp_typ PIPELINED;
    
  FUNCTION giclr204d3_lr(p_session_id   NUMBER,
                         p_date         VARCHAR2)
    RETURN giclr204d3_lr_typ PIPELINED;
    
  FUNCTION giclr204c3_pw(p_session_id   NUMBER,
                         p_date         VARCHAR2,
                         p_prnt_date    NUMBER)
    RETURN giclr204c3_typ PIPELINED;
    
  FUNCTION giclr204c3_os(p_session_id   NUMBER,
                         p_date         VARCHAR2)
    RETURN giclr204c3_typ PIPELINED;
    
  FUNCTION giclr204c3_lp(p_session_id   NUMBER)
    RETURN giclr204c3_typ PIPELINED;
    
  FUNCTION giclr204c3_lr(p_session_id   NUMBER,
                         p_date         VARCHAR2)
    RETURN giclr204c3_typ PIPELINED;
    
-- printGICLR204A added by carlo de guzman 3.15.2016--  
    TYPE GICLR204A_type IS RECORD(
        line                                VARCHAR2(25),
        losses_paid                         gicl_loss_ratio_ext.LOSS_PAID_AMT%TYPE,
        outstanding_loss_current_year       gicl_loss_ratio_ext.CURR_LOSS_RES%TYPE,
        outstanding_loss_previous_year      gicl_loss_ratio_ext.PREV_LOSS_RES%TYPE,        
        premiums_written                    gicl_loss_ratio_ext.CURR_PREM_AMT%TYPE,
        premiums_reserve_current_year       gicl_loss_ratio_ext.CURR_PREM_AMT%TYPE,
        premiums_reserve_previous_year      gicl_loss_ratio_ext.PREV_PREM_AMT%TYPE,        
        losses_incurred                     gicl_loss_ratio_ext.CURR_LOSS_RES%TYPE,
        premiums_earned                     gicl_loss_ratio_ext.PREV_PREM_RES%TYPE,
        loss_ratio                          NUMBER(16,4) --Dren Niebres 06.03.2016 SR-21428
    );

    TYPE GICLR204A_tab IS TABLE OF GICLR204A_type;
    FUNCTION csv_giclr204A(
        p_session_id NUMBER,
        p_date       DATE,
        p_line_cd   GIIS_LINE.LINE_CD%TYPE,
        p_subline_cd GIIS_SUBLINE.SUBLINE_CD%TYPE,
        p_intm_no GIIS_INTERMEDIARY.intm_no%TYPE,
        p_iss_cd GIIS_ISSOURCE.iss_CD%TYPE,
        p_ASSD_NO    GIIS_assured.ASSD_NO%TYPE            
    )
    RETURN GICLR204A_tab PIPELINED;
    FUNCTION get_line_name(
        p_line_cd GIIS_LINE.LINE_CD%TYPE  
    )
    RETURN VARCHAR2;
    FUNCTION get_subline_name(
        p_subline_cd GIIS_SUBLINE.SUBLINE_CD%TYPE            
    )
    RETURN VARCHAR2;
    FUNCTION get_iss_name(
        p_iss_cd GIIS_ISSOURCE.iss_CD%TYPE            
    )
    RETURN VARCHAR2;
    FUNCTION get_intm_name(
        p_intm_no GIIS_INTERMEDIARY.intm_no%TYPE            
    )
    RETURN VARCHAR2;
    FUNCTION get_assd_name(
        p_assd_no GIIS_ASSURED.ASSD_NO%TYPE            
    )
    RETURN VARCHAR2;
-- printGICLR204A END --

    --GICL204E3 added by carlo rubenecia  3.28.2016 SR 5393
  TYPE prem_writn_priod_type1 IS RECORD(
          assured               VARCHAR2(250),
          transaction_date      VARCHAR2(40),
          policy                VARCHAR2(50),
          incept_date           VARCHAR2(50),
          expiry_date           VARCHAR2(50),
          issue_date            VARCHAR2(50),
          tsi_amount            VARCHAR2(50),
          premium_amount        VARCHAR2(50)
        );

  TYPE prem_writn_priod_tab1 IS TABLE OF prem_writn_priod_type1;

  TYPE prem_writn_priod_type2 IS RECORD(
          assured               VARCHAR2(250),
          transaction_date      VARCHAR2(40),
          policy                VARCHAR2(50),
          incept_date           VARCHAR2(50),
          expiry_date           VARCHAR2(50),
          acct_end_date         VARCHAR2(50),
          tsi_amount            VARCHAR2(50),
          premium_amount        VARCHAR2(50)
        );

  TYPE prem_writn_priod_tab2 IS TABLE OF prem_writn_priod_type2;

  TYPE prem_writn_priod_type3 IS RECORD(
          assured               VARCHAR2(250),
          transaction_date      VARCHAR2(40),
          policy                VARCHAR2(50),
          incept_date           VARCHAR2(50),
          expiry_date           VARCHAR2(50),
          booking_date          VARCHAR2(50),
          tsi_amount            VARCHAR2(50),
          premium_amount        VARCHAR2(50)
        );

  TYPE prem_writn_priod_tab3 IS TABLE OF prem_writn_priod_type3;

  TYPE prem_writn_year_type1 IS RECORD(
          assured               VARCHAR2(250),
          transaction_Date      VARCHAR2(40),
          policy                VARCHAR2(50),
          incept_date           VARCHAR2(50),
          expiry_date           VARCHAR2(50),
          issue_date            VARCHAR2(50),
          tsi_amount            VARCHAR2(50),
          premium_amount        VARCHAR2(50)
        );

   TYPE prem_writn_year_tab1 IS TABLE OF prem_writn_year_type1;

   TYPE prem_writn_year_type2 IS RECORD(
          assured               VARCHAR2(250),
          transaction_Date      VARCHAR2(40),
          policy                VARCHAR2(50),
          incept_date           VARCHAR2(50),
          expiry_date           VARCHAR2(50),
          acct_end_date         VARCHAR2(50),
          tsi_amount            VARCHAR2(50),
          premium_amount        VARCHAR2(50)
        );

  TYPE prem_writn_year_tab2 IS TABLE OF prem_writn_year_type2;

  TYPE prem_writn_year_type3 IS RECORD(
          assured               VARCHAR2(250),
          transaction_Date      VARCHAR2(40),
          policy                VARCHAR2(50),
          incept_date           varchar2(50),
          expiry_date           varchar2(50),
          booking_date          VARCHAR2(50),
          tsi_amount            varchar2(50),
          premium_amount        varchar2(50)
        );

  TYPE prem_writn_year_tab3 IS TABLE OF prem_writn_year_type3;

  TYPE losses_pd_curr_year_type IS RECORD(
        assured         varchar2(200),
        claim_no        varchar2(40),
        loss_date       varchar2(50),
        loss_amount     varchar2(50)
        );
        
  TYPE losses_pd_curr_year_tab IS TABLE OF losses_pd_curr_year_type;

  TYPE outstndng_loss_as_of_type IS RECORD(
        assured         varchar2(200),
        claim           varchar2(40),
        loss_date       varchar2(50),
        file_date       varchar2(50),
        loss_amount     varchar2(50)
        );
        
  TYPE outstndng_loss_as_of_tab IS TABLE OF outstndng_loss_as_of_type;

  TYPE loss_recovery_period_type IS RECORD(
        assured         varchar2(200),    
        recovery_no     varchar2(100),
        recovery_type   giis_recovery_type.REC_TYPE_DESC%TYPE,
        loss_date       varchar2(50),
        recovered_amount   varchar2(50)
        );
        
  TYPE loss_recovery_period_tab IS TABLE OF loss_recovery_period_type;

  TYPE loss_recovery_year_type IS RECORD(
        assured         varchar2(200),  
        recovery_no     varchar2(50),   
        recovery_type   giis_recovery_type.REC_TYPE_DESC%TYPE,   
        loss_date       varchar2(50),
        recovered_amount   varchar2(50)
        );

  TYPE loss_recovery_year_tab IS TABLE OF loss_recovery_year_type;

  FUNCTION populate_prem_writn_priod1(
        p_session_id    gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_curr_start_date   varchar2,
        p_curr_end_date     varchar2,
        p_print_date        varchar2
  )
  RETURN prem_writn_priod_tab1 PIPELINED;

  FUNCTION populate_prem_writn_priod2(
        p_session_id    gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_curr_start_date   varchar2,
        p_curr_end_date     varchar2,
        p_print_date        varchar2
  )
  RETURN prem_writn_priod_tab2 PIPELINED;

  FUNCTION populate_prem_writn_priod3(
        p_session_id    gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_curr_start_date   varchar2,
        p_curr_end_date     varchar2,
        p_print_date        varchar2
  )
  RETURN prem_writn_priod_tab3 PIPELINED;

  FUNCTION populate_prem_writn_year1(
        p_session_id    gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_prev_year     varchar2,
        p_print_date    varchar2
  )
  RETURN prem_writn_year_tab1 PIPELINED;

  FUNCTION populate_prem_writn_year2(
        p_session_id    gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_prev_year     varchar2,
        p_print_date    varchar2
  )
  RETURN prem_writn_year_tab2 PIPELINED;

  FUNCTION populate_prem_writn_year3(
        p_session_id    gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_prev_year     varchar2,
        p_print_date    varchar2
  )
  RETURN prem_writn_year_tab3 PIPELINED;

  FUNCTION populate_losses_pd_curr_year(
        p_session_id    gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_curr_year      varchar
  )
  RETURN losses_pd_curr_year_tab PIPELINED;

  FUNCTION populate_outstndng_loss_as_of(
        p_session_id    gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_curr_end_date varchar2
  )
  RETURN outstndng_loss_as_of_tab PIPELINED;

  FUNCTION populate_outstndng_loss_prev(
        p_session_id    gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_prev_end_date varchar2
  )
  RETURN outstndng_loss_as_of_tab PIPELINED;

  FUNCTION populate_loss_recovery_period(
        p_session_id    gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_curr_start_date varchar2,
        p_curr_end_date varchar2
  )
  RETURN loss_recovery_period_tab PIPELINED;

  FUNCTION populate_loss_recovery_year(
        p_session_id    gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
        p_prev_year number
  )
  RETURN loss_recovery_year_tab PIPELINED;

  FUNCTION GICLR204E3_get_datevalue(
            p_prnt_date         varchar2,
            p_policy_id         GIPI_POLBASIC.POLICY_ID%TYPE  
  )
  RETURN varchar2;
  -- GICLR204E3 end

  --added by carlo de guzman 3.23.2016 SR 5394 -START
  TYPE giclr204f_type IS RECORD (
            line_name       VARCHAR2(100),
            peril_name      VARCHAR2(100),
            loss_paid_amt   VARCHAR2(50),--modified by carlo rubenecia 04.18.2016 SR-5394 -START
            curr_loss_res   VARCHAR2(50),
            prev_loss_res   VARCHAR2(50),
            curr_prem_amt   VARCHAR2(50),
            prem_res_cy     VARCHAR2(50),
            prem_res_py     VARCHAR2(50),
            losses_incurred VARCHAR2(50),
            premiums_earned VARCHAR2(50),
            loss_ratio           VARCHAR2(50) --modified by carlo rubenecia 04.18.2016 SR-5394 -END
    );
  TYPE giclr204f_tab IS TABLE OF giclr204f_type;
    
  FUNCTION csv_giclr204f(
    p_session_id NUMBER,
    p_date       VARCHAR2,
    p_line       VARCHAR2,
    p_subline_cd VARCHAR2,
    p_iss_cd     VARCHAR2,
    p_assd_no    NUMBER,
    p_intm_no    NUMBER
    
    )
    RETURN giclr204f_tab PIPELINED;  
  --added by carlo de guzman 3.23.2016 SR 5394 -END
  
   -- GICLR204F3 CSV printing  carlo de guzman 3.28.2016 for SR5396
   --added by carlo rubenecia  04.15.2016--start
   TYPE giclr204f3_details_type1 IS RECORD(
      peril                 VARCHAR2(100),
      transaction_date      VARCHAR(20),
      policy                VARCHAR2(50),
      assured               VARCHAR2 (550 BYTE),
      incept_date           VARCHAR2(20),
      expiry_date           VARCHAR2(20),
      issue_date            VARCHAR2(20),
      tsi_amount            VARCHAR2(50),
      premium_amount        VARCHAR2(50)
   );
   
  TYPE giclr204f3_details_tab1 IS TABLE OF giclr204f3_details_type1;
  
  TYPE giclr204f3_details_type2 IS RECORD(
      peril                 VARCHAR2(100),
      transaction_date      VARCHAR(20),
      policy                VARCHAR2(50),
      assured               VARCHAR2 (550 BYTE),
      incept_date           VARCHAR(20),
      expiry_date           VARCHAR(20),
      acct_end_date         VARCHAR(20),
      tsi_amount            VARCHAR2(50),
      premium_amount        VARCHAR2(50)   
   );
   
  TYPE giclr204f3_details_tab2 IS TABLE OF giclr204f3_details_type2;
 
  TYPE giclr204f3_details_type3 IS RECORD(
      peril                 VARCHAR2(100),
      transaction_date      VARCHAR(20),
      policy                VARCHAR2(50),
      assured               VARCHAR2 (550 BYTE),
      incept_date           VARCHAR2(20),
      expiry_date           VARCHAR2(20),
      booking_date          VARCHAR2(20),
      tsi_amount            VARCHAR2(50),
      premium_amount        VARCHAR2(50)
   );
   
  TYPE giclr204f3_details_tab3 IS TABLE OF giclr204f3_details_type3;
  --added by carlo rubenecia 04.15.2016 --end
  
  TYPE giclr204f3_os_type IS RECORD(
      peril             VARCHAR2(100),
      claim_no          VARCHAR2(50),
      assured           VARCHAR2 (550 BYTE), --modified by carlo rubenecia 04.15.2016 -start
      loss_date         VARCHAR2(20),         
      file_date         VARCHAR2(20),
      loss_amount       VARCHAR2(50)        --modified by carlo rubenecia 04.15.2016 -end
   );
   
  TYPE giclr204f3_os_tab IS TABLE OF giclr204f3_os_type;
  
  TYPE giclr204f3_loss_type IS RECORD(
      peril                 VARCHAR2(100),
      claim_no              VARCHAR2(100),
      assured               VARCHAR2 (550 BYTE), --modified by carlo rubenecia 04.15.2016 -start
      loss_date             VARCHAR2(20),
      loss_amount           VARCHAR2(50)        --modified by carlo rubenecia 04.15.2016 -end
   );
   
  TYPE giclr204f3_loss_tab IS TABLE OF giclr204f3_loss_type;
  
  TYPE giclr204f3_rec_type IS RECORD(
      peril                 VARCHAR2(100),
      assured               VARCHAR2(550 BYTE),
      recovery_type         giis_recovery_type.rec_type_desc%TYPE,
      loss_date             VARCHAR2(20), --modified by carlo rubenecia 04.15.2016 -start
      loss_amount           VARCHAR2(50)  --modified by carlo rubenecia 04.15.2016 -start
   );

  TYPE giclr204f3_rec_tab IS TABLE OF giclr204f3_rec_type;
  
  --added by carlo rubenecia 04.15.2016 SR 5396--start
  FUNCTION csv_giclr204F3_pw_cy1(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN giclr204f3_details_tab1 PIPELINED;
  
  FUNCTION csv_giclr204F3_pw_cy2(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN giclr204f3_details_tab2 PIPELINED;
   
  FUNCTION csv_giclr204F3_pw_cy3(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN giclr204f3_details_tab3 PIPELINED;
   
  FUNCTION csv_giclr204F3_pw_py1(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN giclr204f3_details_tab1 PIPELINED;
  
  FUNCTION csv_giclr204F3_pw_py2(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN giclr204f3_details_tab2 PIPELINED;
   
  FUNCTION csv_giclr204F3_pw_py3(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN giclr204f3_details_tab3 PIPELINED;
  --added by carlo rubenecia 04.15.2015 SR 5396-- END
  
  FUNCTION csv_giclr204F3_os_loss_cy(
      p_session_id          gicl_lratio_curr_os_ext.session_id%TYPE
   ) RETURN giclr204f3_os_tab PIPELINED;
   
  FUNCTION csv_giclr204F3_os_loss_py(
      p_session_id          gicl_lratio_prev_os_ext.session_id%TYPE
   ) RETURN giclr204f3_os_tab PIPELINED;
   
  FUNCTION csv_giclr204F3_losses_paid(
      p_session_id          gicl_lratio_loss_paid_ext.session_id%TYPE
   ) RETURN giclr204f3_loss_tab PIPELINED;
  
  FUNCTION csv_giclr204F3_loss_reco_cy(
      p_session_id          gicl_lratio_curr_recovery_ext.session_id%TYPE
   ) RETURN giclr204f3_rec_tab PIPELINED;
   
  FUNCTION csv_giclr204F3_loss_reco_py(
      p_session_id          gicl_lratio_prev_recovery_ext.session_id%TYPE
   ) RETURN giclr204f3_rec_tab PIPELINED;
   -- GICLR204F3 CSV printing END SR 5396--
    
END csv_loss_ratio;
/

