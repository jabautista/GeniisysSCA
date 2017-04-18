CREATE OR REPLACE PACKAGE CPI.p_risk_loss_profile
AS
   PROCEDURE risk_profile_ext (
      v_user              gipi_risk_profile.user_id%TYPE,
      v_line_cd           gipi_risk_profile.line_cd%TYPE,
      v_subline_cd        gipi_risk_profile.subline_cd%TYPE,
      v_date_from         DATE,           --GIPI_RISK_PROFILE.date_from%TYPE,
      v_date_to           DATE,             --GIPI_RISK_PROFILE.date_to%TYPE,
      v_basis             VARCHAR2,
      v_line_tag          VARCHAR2,                                     --***
      v_cred_branch       gipi_polbasic.cred_branch%TYPE,
                                          -- mark jm additional record filter
      v_include_expired   VARCHAR2,       -- mark jm additional record filter
      v_include_endt      VARCHAR2,        -- mark jm additional record filter
      v_LOSS_DATE_FROM      date, -- Marvin 04292013 Added Claim count. UW-SPECS-2013-072 GIPIS902 GIPIR902 IE-2012-018-CIC-RISK AND LOSS PROFILE
      v_LOSS_DATE_TO        date, -- Marvin 04292013 Added Claim count. UW-SPECS-2013-072 GIPIS902 GIPIR902 IE-2012-018-CIC-RISK AND LOSS PROFILE
      v_FILE_DATE       varchar2);-- Marvin 04292013 Added Claim count. UW-SPECS-2013-072 GIPIS902 GIPIR902 IE-2012-018-CIC-RISK AND LOSS PROFILE

   PROCEDURE get_poldist_ext (
      p_line_cd           gipi_polbasic.line_cd%TYPE,
      p_subline_cd        gipi_polbasic.subline_cd%TYPE,
      p_basis             VARCHAR2,
      p_date_from         DATE,
      p_date_to           DATE,                                         --***
      p_cred_branch       gipi_polbasic.cred_branch%TYPE,
                                          -- mark jm additional record filter
      p_include_expired   VARCHAR2,       -- mark jm additional record filter
      p_include_endt      VARCHAR2
   );                                     -- mark jm additional record filter

   PROCEDURE get_share_ext;

   FUNCTION date_risk (
      p_ad         IN   DATE,
      p_ed         IN   DATE,
      p_id         IN   DATE,
      p_month      IN   VARCHAR2,
      p_year       IN   NUMBER,
      p_spld_ad    IN   DATE,
      p_pol_flag   IN   VARCHAR2,
      p_dt_type    IN   VARCHAR2,
      p_fmdate     IN   DATE,
      p_todate     IN   DATE,
      p_and        IN   DATE
   )
      RETURN NUMBER;

   FUNCTION get_ann_tsi (
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_issue_yy     NUMBER,
      p_pol_seq_no   NUMBER,
      p_renew_no     NUMBER,
      p_from         DATE,
      p_to           DATE,
      p_basis        VARCHAR2,
      p_and          DATE
   )
      RETURN NUMBER;

   PROCEDURE fire_risk_profile_ext 
                                   /*created by iris bordey 02.04.2003
                                   **this procedure will extract records for risk_profile of FIRE policies only
                                   */
   (
      p_user              gipi_risk_profile.user_id%TYPE,
      p_line_cd           gipi_risk_profile.line_cd%TYPE,
      p_subline_cd        gipi_risk_profile.subline_cd%TYPE,
      p_date_from         gipi_risk_profile.date_from%TYPE,
      p_date_to           gipi_risk_profile.date_to%TYPE,
      p_basis             VARCHAR2,
      p_line_tag          VARCHAR2,                                     --***
      p_cred_branch       gipi_polbasic.cred_branch%TYPE,
                                          -- mark jm additional record filter
      p_include_expired   VARCHAR2,       -- mark jm additional record filter
      p_include_endt      VARCHAR2,       -- mark jm additional record filter
            p_LOSS_DATE_FROM      date, -- Marvin 04292013 Added Claim count. UW-SPECS-2013-072 GIPIS902 GIPIR902 IE-2012-018-CIC-RISK AND LOSS PROFILE
      p_LOSS_DATE_TO        date, -- Marvin 04292013 Added Claim count. UW-SPECS-2013-072 GIPIS902 GIPIR902 IE-2012-018-CIC-RISK AND LOSS PROFILE
      p_FILE_DATE       varchar2  -- Marvin 04292013 Added Claim count. UW-SPECS-2013-072 GIPIS902 GIPIR902 IE-2012-018-CIC-RISK AND LOSS PROFILE
   );  

   FUNCTION get_item_ann_tsi (
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_issue_yy     NUMBER,
      p_pol_seq_no   NUMBER,
      p_renew_no     NUMBER,
      p_item_no      NUMBER,
      p_from         DATE,
      p_to           DATE,
      p_basis        VARCHAR2,
      p_and          DATE
   )
      RETURN NUMBER;

   PROCEDURE risk_profile_per_peril 
                                    /*created by iris bordey 11.27.2003
                                    **this procedure will extract records for risk_profile per peril
                                    */
   (
      p_user              gipi_risk_profile.user_id%TYPE,
      p_line_cd           gipi_risk_profile.line_cd%TYPE,
      p_subline_cd        gipi_risk_profile.subline_cd%TYPE,
      p_date_from         gipi_risk_profile.date_from%TYPE,
      p_date_to           gipi_risk_profile.date_to%TYPE,
      p_basis             VARCHAR2,
      p_line_tag          VARCHAR2,                                     --***
      p_cred_branch       gipi_polbasic.cred_branch%TYPE,
                                          -- mark jm additional record filter
      p_include_expired   VARCHAR2,       -- mark jm additional record filter
      p_include_endt      VARCHAR2,       -- mark jm additional record filter
      p_LOSS_DATE_FROM      date, -- Marvin 04292013 Added Claim count. UW-SPECS-2013-072 GIPIS902 GIPIR902 IE-2012-018-CIC-RISK AND LOSS PROFILE
      p_LOSS_DATE_TO        date, -- Marvin 04292013 Added Claim count. UW-SPECS-2013-072 GIPIS902 GIPIR902 IE-2012-018-CIC-RISK AND LOSS PROFILE
      p_FILE_DATE       varchar2  -- Marvin 04292013 Added Claim count. UW-SPECS-2013-072 GIPIS902 GIPIR902 IE-2012-018-CIC-RISK AND LOSS PROFILE
   );                                    

   PROCEDURE extract_risk_profile 
                                  /*created by iris bordey 11.27.2003
                                  **this procedure will extract records for risk_profile per peril
                                  */
   (
      p_user              gipi_risk_profile.user_id%TYPE,
      p_line_cd           gipi_risk_profile.line_cd%TYPE,
      p_subline_cd        gipi_risk_profile.subline_cd%TYPE,
      p_date_from         DATE,           --GIPI_RISK_PROFILE.date_from%TYPE,
      p_date_to           DATE,             --GIPI_RISK_PROFILE.date_to%TYPE,
      p_basis             VARCHAR2,
      p_line_tag          VARCHAR2,
      p_by_tarf           VARCHAR2,                                     --***
      p_cred_branch       gipi_polbasic.cred_branch%TYPE,
                                          -- mark jm additional record filter
      p_include_expired   VARCHAR2,       -- mark jm additional record filter
      p_include_endt      VARCHAR2,       -- mark jm additional record filter
      p_LOSS_DATE_FROM      date, -- Marvin 04292013 Added Claim count. UW-SPECS-2013-072 GIPIS902 GIPIR902 IE-2012-018-CIC-RISK AND LOSS PROFILE
      p_LOSS_DATE_TO        date, -- Marvin 04292013 Added Claim count. UW-SPECS-2013-072 GIPIS902 GIPIR902 IE-2012-018-CIC-RISK AND LOSS PROFILE
      p_FILE_DATE       varchar2  -- Marvin 04292013 Added Claim count. UW-SPECS-2013-072 GIPIS902 GIPIR902 IE-2012-018-CIC-RISK AND LOSS PROFILE
   );                                     

   FUNCTION check_date_dist_peril 
                                  /** rollie 02/18/04
                                  *** date parameter of the last endorsement of policy
                                  *** must not be within the date given, else it will
                                  *** be exluded
                                  *** NOTE: policy with pol_flag = '4' only
                                  **/
   (
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE,
      p_param_date   VARCHAR2,
      p_from_date    DATE,
      p_to_date      DATE
   )
      RETURN NUMBER;

   FUNCTION sign_tsi (
      p_from       DATE,
      p_to         DATE,
      p_and        DATE,
      p_aed        DATE,
      p_pol_flag   VARCHAR2
   )
      RETURN NUMBER;

   PROCEDURE get_loss_ext3 (
      p_loss_sw   IN   VARCHAR2,
      p_loss_fr   IN   DATE,
      p_loss_to   IN   DATE,
      p_line_cd   IN   VARCHAR2,
      p_subline   IN   VARCHAR2
   );

   PROCEDURE get_loss_ext3_peril (
      p_loss_sw   IN   VARCHAR2,
      p_loss_fr   IN   DATE,
      p_loss_to   IN   DATE,
      p_line_cd   IN   VARCHAR2,
      p_subline   IN   VARCHAR2
   );

   PROCEDURE get_loss_ext3_fire (
      p_loss_sw   IN   VARCHAR2,
      p_loss_fr   IN   DATE,
      p_loss_to   IN   DATE,
      p_line_cd   IN   VARCHAR2,
      p_subline   IN   VARCHAR2
   );

   PROCEDURE get_loss_ext3_motor (
      p_loss_sw   IN   VARCHAR2,
      p_loss_fr   IN   DATE,
      p_loss_to   IN   DATE,
      p_line_cd   IN   VARCHAR2,
      p_subline   IN   VARCHAR2
   );
END;
/


