CREATE OR REPLACE PACKAGE CPI.P_Zone_Asof AS
  PROCEDURE EXTRACT(
    p_as_of    IN DATE,
    p_bus_cd   IN NUMBER,
    p_zone     IN VARCHAR2,
 p_dsp_zone IN VARCHAR2,
 p_inc_endt  IN VARCHAR2,
    p_inc_exp   IN VARCHAR2,
 p_peril_type IN VARCHAR2,
 p_risk_cnt   IN VARCHAR2,
 p_user       IN VARCHAR2); --edgar 03/09/2015
  PROCEDURE zone_earth(
    p_as_of    IN DATE,
    p_bus_cd   IN NUMBER,
    p_zone     IN VARCHAR2,
 p_inc_endt IN VARCHAR2,
    p_inc_exp  IN VARCHAR2,
 p_risk_cnt IN VARCHAR2);
  PROCEDURE zone_flood(
    p_as_of    IN DATE,
    p_bus_cd   IN NUMBER,
    p_zone     IN VARCHAR2,
 p_inc_endt IN VARCHAR2,
    p_inc_exp  IN VARCHAR2,
 p_risk_cnt IN VARCHAR2);
  PROCEDURE zone_typhn(
    p_as_of    IN DATE,
    p_bus_cd   IN NUMBER,
    p_zone     IN VARCHAR2,
 p_inc_endt IN VARCHAR2,
    p_inc_exp  IN VARCHAR2,
 p_risk_cnt IN VARCHAR2);
  PROCEDURE zone_tf(
    p_as_of    IN DATE,
    p_bus_cd   IN NUMBER,
    p_zone     IN VARCHAR2,
 p_inc_endt IN VARCHAR2,
    p_inc_exp  IN VARCHAR2,
 p_risk_cnt IN VARCHAR2);
  FUNCTION get_eq_zone
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
     p_as_of        DATE)
  RETURN VARCHAR2;
  FUNCTION get_fd_zone
  /* created by boyet 10/23/2001
  ** this function returns the flood_zone of the latest endt_seq_no.
  ** this function is only used for the package the processes zone not null.
  */
    (p_line_cd    VARCHAR2,
     p_subline_cd VARCHAR2,
     p_iss_cd     VARCHAR2,
     p_issue_yy   NUMBER,
     p_pol_seq_no NUMBER,
  p_endt_iss_cd  VARCHAR2,
  p_endt_yy      NUMBER,
  p_endt_seq_no  NUMBER,
     p_renew_no   NUMBER,
     p_item_no    NUMBER,
     p_as_of      DATE)
  RETURN VARCHAR2;
  FUNCTION get_ty_zone
  /* created by boyet 10/23/2001
  ** this function returns the typhoon_zone of the latest endt_seq_no.
  ** this function is only used for the package the processes zone not null.
  */
    (p_line_cd    VARCHAR2,
     p_subline_cd VARCHAR2,
     p_iss_cd     VARCHAR2,
     p_issue_yy   NUMBER,
     p_pol_seq_no NUMBER,
  p_endt_iss_cd  VARCHAR2,
  p_endt_yy      NUMBER,
  p_endt_seq_no  NUMBER,
     p_renew_no   NUMBER,
     p_item_no    NUMBER,
     p_as_of      DATE)
  RETURN VARCHAR2;
  FUNCTION get_tf_zone
  /* this function returns the typhoon_zone / flood_zone of the latest endt_seq_no.
  */
    (p_line_cd    VARCHAR2,
     p_subline_cd VARCHAR2,
     p_iss_cd     VARCHAR2,
     p_issue_yy   NUMBER,
     p_pol_seq_no NUMBER,
  p_endt_iss_cd  VARCHAR2,
  p_endt_yy      NUMBER,
  p_endt_seq_no  NUMBER,
     p_renew_no   NUMBER,
     p_item_no    NUMBER,
     p_as_of      DATE)
  RETURN VARCHAR2;
  FUNCTION get_fd_tsi (
  /* created by bdarusin 01/15/2002
  ** this function returns the dist tsi amount of the policy.
  ** this function is only used for the procedures involving fire stat
  */
   p_line_cd     VARCHAR2,
   p_subline_cd  VARCHAR2,
   p_iss_cd   VARCHAR2,
   p_issue_yy   NUMBER,
   p_pol_seq_no  NUMBER,
      p_renew_no  NUMBER,
      p_item_no   NUMBER,
   p_peril_cd NUMBER,
   p_share_cd NUMBER,
   p_dist_no     NUMBER,
   p_as_of  DATE)
  RETURN NUMBER;
  FUNCTION get_ty_tsi (
  /* created by bdarusin 01/15/2002
  ** this function returns the dist tsi amount of the policy.
  ** this function is only used for the procedures involving fire stat
  */
   p_line_cd     VARCHAR2,
   p_subline_cd  VARCHAR2,
   p_iss_cd   VARCHAR2,
   p_issue_yy   NUMBER,
   p_pol_seq_no  NUMBER,
      p_renew_no  NUMBER,
      p_item_no   NUMBER,
   p_peril_cd NUMBER,
   p_share_cd NUMBER,
   p_dist_no     NUMBER,
   p_as_of  DATE)
  RETURN NUMBER;
  FUNCTION get_eq_tsi (
  /* created by bdarusin 01/15/2002
  ** this function returns the dist tsi amount of the policy.
  ** this function is only used for the procedures involving fire stat
  */
   p_line_cd     VARCHAR2,
   p_subline_cd  VARCHAR2,
   p_iss_cd   VARCHAR2,
   p_issue_yy   NUMBER,
   p_pol_seq_no  NUMBER,
      p_renew_no  NUMBER,
      p_item_no   NUMBER,
   p_peril_cd NUMBER,
   p_share_cd NUMBER,
   p_dist_no     NUMBER,
   p_as_of  DATE)
  RETURN NUMBER;
  FUNCTION get_tf_tsi (
  /* created by bdarusin 04/05/2002
  ** this function returns the dist tsi amount of the policy.
  ** this function is only used for the procedures involving fire stat
  */
   p_line_cd     VARCHAR2,
   p_subline_cd  VARCHAR2,
   p_iss_cd   VARCHAR2,
   p_issue_yy   NUMBER,
   p_pol_seq_no  NUMBER,
      p_renew_no  NUMBER,
      p_item_no   NUMBER,
   p_peril_cd NUMBER,
   p_share_cd NUMBER,
   p_dist_no     NUMBER,
   p_as_of  DATE)
  RETURN NUMBER;
  
  FUNCTION risk_count_fd(
    p_fd_zone  IN VARCHAR2,
    p_share_cd IN NUMBER,
 p_risk_cnt IN VARCHAR2)
  RETURN NUMBER;
  
  FUNCTION risk_count_ty(
    p_ty_zone  IN VARCHAR2,
    p_share_cd IN NUMBER,
 p_risk_cnt IN VARCHAR2)
  RETURN NUMBER;
  
  FUNCTION risk_count_eq(
    p_eq_zone  IN VARCHAR2,
    p_share_cd IN NUMBER,
 p_risk_cnt IN VARCHAR2)
  RETURN NUMBER;
  
  FUNCTION risk_count_tf(
    p_tf_zone  IN VARCHAR2,
    p_share_cd IN NUMBER,
 p_risk_cnt IN VARCHAR2)
  RETURN NUMBER;
  
    FUNCTION risk_count(
    p_fi_zone  IN VARCHAR2,
    p_share_cd IN NUMBER,
 p_type IN VARCHAR2,
 p_risk_cnt IN VARCHAR2,
 p_user       IN VARCHAR2) --edgar 03/09/2015
  RETURN NUMBER;

  
END;
/


