CREATE OR REPLACE PACKAGE CPI.P_Zone_Fromto_Dtl AS
  /*
  ** Modified by :  Aaron
  ** Modified on :  October 23, 2008 
  ** Remarks     :  Modified to correct the amounts extracted.
  **                Added the following parameters: 
  **           i.  p_inc_endt   --> parameter to determine whether to include endorsements
  **                    beyond the given date of extraction
  **          ii.  p_inc_exp    --> parameter to determine whether to include expired policies or not
  **         iii.  p_peril_type --> parameter to determine the type of peril to be included;
  **                A (allied only) B (basic only ) AB (both)            
  **         iv.   p_risk_cnt  ---> parameter to determine whether count will be per risk ('R') or per policy ('P')          
  */
  
  PROCEDURE EXTRACT(
    p_from       IN DATE,
    p_to         IN DATE,
    p_dt_type    IN VARCHAR2,
    p_bus_cd     IN NUMBER,
    P_Zone       IN VARCHAR2,
    p_type       IN VARCHAR2,
    p_inc_endt   IN VARCHAR2,
    p_inc_exp    IN VARCHAR2,
    p_peril_type IN VARCHAR2, -- aaron 
    p_user       IN VARCHAR2); --edgar 03/09/2015
  FUNCTION date_ok
    (p_ad        IN DATE,
     p_ed        IN DATE,
     p_id        IN DATE,
     p_mth       IN VARCHAR2,
     p_year      IN NUMBER,
     p_spld_ad   IN DATE,
     p_pol_flag  IN VARCHAR2,
     p_dt_type   IN VARCHAR2,
     p_fmdate    IN DATE,
     p_todate    IN DATE)
  RETURN NUMBER;
  
  FUNCTION get_zone
  /* created by boyet 10/23/2001
  ** this function returns the eq_zone of the latest endt_seq_no. this function is only used
  ** for the package the processes zone not null.
  */
    (p_line_cd      VARCHAR2,
     p_subline_cd   VARCHAR2,
     p_iss_cd       VARCHAR2,
     p_issue_yy     NUMBER,
     p_pol_seq_no   NUMBER,
     p_endt_iss_cd  VARCHAR2,
     p_endt_yy      NUMBER,
     p_endt_seq_no  NUMBER,
     p_renew_no     NUMBER,
     p_item_no      NUMBER,
     p_dt_type      VARCHAR2,
     p_from         DATE,
     p_to           DATE,
     p_inc_endt     VARCHAR2,
     p_type         VARCHAR2)
--  RETURN NUMBER;
  RETURN VARCHAR2;--vj 031907
  
  
  FUNCTION get_prem_tsi (
  /* created by bdarusin 01/15/2002
  ** this function returns the dist tsi amount of the policy.
  ** this function is only used for the procedures involving fire stat
  */
     p_line_cd     VARCHAR2,
     p_subline_cd  VARCHAR2,
     p_iss_cd      VARCHAR2,
     p_issue_yy    NUMBER,
     p_pol_seq_no  NUMBER,
     p_renew_no    NUMBER,
     p_item_no     NUMBER,
     p_peril_cd    NUMBER,
     p_share_cd    NUMBER,
     p_dist_no     NUMBER,
     p_from        DATE,
     p_to          DATE,
     p_dt_type     VARCHAR2,
     p_inc_endt    VARCHAR2,
     p_prem_tsi    VARCHAR2)
  RETURN NUMBER;
  /*FUNCTION get_fd_tsi_old (*/
  /* created by bdarusin 01/15/2002
  ** this function returns the dist tsi amount of the policy.
  ** this function is only used for the procedures involving fire stat
  */
   /*p_line_cd     VARCHAR2,
   p_subline_cd  VARCHAR2,
   p_iss_cd   VARCHAR2,
   p_issue_yy   NUMBER,
   p_pol_seq_no  NUMBER,
      p_renew_no  NUMBER,
      p_item_no   NUMBER,
   p_peril_cd NUMBER,
   p_share_cd NUMBER,
   p_dist_no     NUMBER,
      p_from        DATE,
      p_to          DATE,
   p_dt_type     VARCHAR2)
  RETURN NUMBER;*/
  
    
  FUNCTION Get_FI_Item_Grp (
  p_line_cd    VARCHAR2,
  p_subline_cd VARCHAR2,
  p_iss_cd    VARCHAR2,
  p_issue_yy   NUMBER,
  p_pol_seq_no NUMBER,
  p_renew_no   NUMBER,
  p_item_no    NUMBER)
  RETURN VARCHAR2;
  
  FUNCTION get_occupancy
  /* created by boyet 10/23/2001
  ** this function returns the eq_zone of the latest endt_seq_no. this function is only used
  ** for the package the processes zone not null.
  */
    (p_line_cd      VARCHAR2,
     p_subline_cd   VARCHAR2,
     p_iss_cd       VARCHAR2,
     p_issue_yy     NUMBER,
     p_pol_seq_no   NUMBER,
     p_endt_iss_cd  VARCHAR2,
     p_endt_yy      NUMBER,
     p_endt_seq_no  NUMBER,
     p_renew_no     NUMBER,
     p_item_no      NUMBER,
     p_dt_type      VARCHAR2,
     p_from         DATE,
     p_to           DATE,
     p_inc_endt     VARCHAR2,
     p_type         VARCHAR2)
--  RETURN NUMBER;
RETURN VARCHAR2;

   /* ----------------------------------------------------------------------------------------
   ** jhing 03.17.2015 revised extraction for fire statistical reports. Changes were done not
   ** only on the queries but on the database structure and on the process.
   ** ----------------------------------------------------------------------------------------*/
   FUNCTION get_redist_date (
      p_policy_id       gipi_polbasic.policy_id%TYPE,
      p_item_grp        gipi_invoice.item_grp%TYPE,
      p_takeup_seq_no   gipi_invoice.takeup_seq_no%TYPE
   )
      RETURN DATE;

   FUNCTION get_max_redist_dist_no (
      p_policy_id       gipi_polbasic.policy_id%TYPE,
      p_item_grp        gipi_invoice.item_grp%TYPE,
      p_takeup_seq_no   gipi_invoice.takeup_seq_no%TYPE,
      p_dt_type         VARCHAR2,
      p_from            DATE,
      p_to              DATE
   )
      RETURN NUMBER;

   FUNCTION get_latest_eff_per_field (
      p_line_cd           gipi_polbasic.line_cd%TYPE,
      p_subline_cd        gipi_polbasic.subline_cd%TYPE,
      p_iss_cd            gipi_polbasic.iss_cd%TYPE,
      p_issue_yy          gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no        gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no          gipi_polbasic.renew_no%TYPE,
      p_item_no           gipi_itmperil.item_no%TYPE,
      p_from         IN   DATE,
      p_to           IN   DATE,
      p_date_type    IN   VARCHAR2,
      p_inc_exp      IN   VARCHAR2,
      p_inc_endt     IN   VARCHAR2,
      p_field_name   IN   VARCHAR2
   )
      RETURN NUMBER;

   FUNCTION get_latest_eff_polendt (
      p_line_cd           gipi_polbasic.line_cd%TYPE,
      p_subline_cd        gipi_polbasic.subline_cd%TYPE,
      p_iss_cd            gipi_polbasic.iss_cd%TYPE,
      p_issue_yy          gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no        gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no          gipi_polbasic.renew_no%TYPE,
      p_from         IN   DATE,
      p_to           IN   DATE,
      p_date_type    IN   VARCHAR2,
      p_inc_exp      IN   VARCHAR2,
      p_inc_endt     IN   VARCHAR2
   )
      RETURN NUMBER;

   FUNCTION get_block_id (
      p_policy_id   gipi_polbasic.policy_id%TYPE,
      p_item_no     gipi_item.item_no%TYPE
   )
      RETURN NUMBER;

   FUNCTION get_risk_cd (
      p_policy_id   gipi_polbasic.policy_id%TYPE,
      p_item_no     gipi_item.item_no%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_fr_item_type (
      p_policy_id   IN   gipi_polbasic.policy_id%TYPE,
      p_item_no     IN   gipi_item.item_no%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_occupancy_cd (
      p_policy_id   gipi_polbasic.policy_id%TYPE,
      p_item_no     gipi_item.item_no%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_tarf_cd (
      p_policy_id   gipi_polbasic.policy_id%TYPE,
      p_item_no     gipi_item.item_no%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_eq_zone (
      p_policy_id   gipi_polbasic.policy_id%TYPE,
      p_item_no     gipi_item.item_no%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_flood_zone (
      p_policy_id   gipi_polbasic.policy_id%TYPE,
      p_item_no     gipi_item.item_no%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_typhoon_zone (
      p_policy_id   gipi_polbasic.policy_id%TYPE,
      p_item_no     gipi_item.item_no%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_assd_no (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN NUMBER;

   PROCEDURE update_non_affecting_info (
      p_from         IN   DATE,
      p_to           IN   DATE,
      p_dt_type      IN   VARCHAR2,
      p_bus_cd       IN   NUMBER,
      p_zone         IN   VARCHAR2,
      p_type         IN   VARCHAR2,
      p_inc_endt     IN   VARCHAR2,
      p_inc_exp      IN   VARCHAR2,
      p_peril_type   IN   VARCHAR2,
      p_user_id      IN   giis_users.user_id%TYPE
   );

   PROCEDURE extract2 (
      p_from         IN   DATE,
      p_to           IN   DATE,
      p_dt_type      IN   VARCHAR2,
      p_bus_cd       IN   NUMBER,
      p_zone         IN   VARCHAR2,
      p_type         IN   VARCHAR2,
      p_inc_endt     IN   VARCHAR2,
      p_inc_exp      IN   VARCHAR2,
      p_peril_type   IN   VARCHAR2,
      p_user_id      IN   giis_users.user_id%TYPE
   );
END;
/


