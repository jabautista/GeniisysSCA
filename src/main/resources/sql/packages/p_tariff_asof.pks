CREATE OR REPLACE PACKAGE CPI.P_Tariff_Asof AS
  PROCEDURE EXTRACT(
    p_as_of    IN DATE,
    p_bus_cd   IN NUMBER,
    P_Zone     IN VARCHAR2,
 p_type     IN VARCHAR2,
    p_user     IN VARCHAR2); --added edgar 03/09/2015
  FUNCTION Get_Dist_Tsi (
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
   p_type        VARCHAR2,
   p_as_of  DATE)
  RETURN NUMBER;
END;
/


