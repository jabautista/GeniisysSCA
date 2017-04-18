CREATE OR REPLACE PACKAGE CPI.Casualty_Accum
/* Created By : Ramon, 02/23/2010
** Desciption : This package will hold all the procedures and functions that will
**              handle the Extraction for Casualty Accumulation of GIPIS111 module.
**
*/
AS
  -- Extraction of data will start and end in this procedure. This will function as the
  -- main module for the entire extraction for casualty accumulation.
  PROCEDURE EXTRACT(p_location_cd   gipi_casualty_item.location_cd%TYPE,
                    p_bus_type      NUMBER);

  FUNCTION Get_Cancel_Effectivity
   (p_line_cd     gipi_polbasic.line_cd%TYPE,
    p_subline_cd  gipi_polbasic.subline_cd%TYPE,
    p_iss_cd      gipi_polbasic.iss_cd%TYPE,
    p_issue_yy    gipi_polbasic.issue_yy%TYPE,
    p_pol_seq_no  gipi_polbasic.pol_seq_no%TYPE,
    p_renew_no    gipi_polbasic.renew_no%TYPE)
  RETURN VARCHAR2;

  -- procedure returns the latest location
  PROCEDURE Latest_Location (p_line_cd         IN gipi_polbasic.line_cd%TYPE,
                             p_subline_cd      IN gipi_polbasic.line_cd%TYPE,
                             p_iss_cd          IN gipi_polbasic.iss_cd%TYPE,
                             p_issue_yy        IN gipi_polbasic.issue_yy%TYPE,
                             p_pol_seq_no      IN gipi_polbasic.pol_seq_no%TYPE,
                             p_renew_no        IN gipi_polbasic.renew_no%TYPE,
                             p_location_cd    OUT gipi_casualty_item.location_cd%TYPE);

  --the procedure returns the latest assured.
  PROCEDURE Latest_Assured (p_line_cd      IN gipi_polbasic.line_cd%TYPE,
                            p_subline_cd   IN gipi_polbasic.line_cd%TYPE,
                            p_iss_cd       IN gipi_polbasic.iss_cd%TYPE,
                            p_issue_yy     IN gipi_polbasic.issue_yy%TYPE,
                            p_pol_seq_no   IN gipi_polbasic.pol_seq_no%TYPE,
                            p_renew_no     IN gipi_polbasic.renew_no%TYPE,
                            p_assd_no     OUT giis_assured.assd_no%TYPE,
                            p_assd_name   OUT giis_assured.assd_name%TYPE);

  --the procedure returns the latest duration.
  PROCEDURE Latest_Duration (p_line_cd       IN gipi_polbasic.line_cd%TYPE,
                             p_subline_cd    IN gipi_polbasic.line_cd%TYPE,
                             p_iss_cd        IN gipi_polbasic.iss_cd%TYPE,
                             p_issue_yy      IN gipi_polbasic.issue_yy%TYPE,
                             p_pol_seq_no    IN gipi_polbasic.pol_seq_no%TYPE,
                             p_renew_no      IN gipi_polbasic.renew_no%TYPE,
                             p_incept_date  OUT gipi_polbasic.incept_date%TYPE,
                             p_expiry_date  OUT gipi_polbasic.expiry_date%TYPE);

  -- the procedure computes the ann_tsi_amt per policy_no, item_no,
  PROCEDURE Get_Ann_Tsi (p_line_cd       IN gipi_polbasic.line_cd%TYPE,
                         p_subline_cd    IN gipi_polbasic.subline_cd%TYPE,
                         p_iss_cd        IN gipi_polbasic.iss_cd%TYPE,
                         p_issue_yy      IN gipi_polbasic.issue_yy%TYPE,
                         p_pol_seq_no    IN gipi_polbasic.pol_seq_no%TYPE,
                         p_renew_no      IN gipi_polbasic.renew_no%TYPE,
                         v_ann_tsi_amt  OUT gipi_polbasic.ann_tsi_amt%TYPE);

--the procedure returns the latest premium rate
  PROCEDURE Latest_Prem_Rt (p_line_cd      IN gipi_polbasic.line_cd%TYPE,
                            p_subline_cd   IN gipi_polbasic.line_cd%TYPE,
                            p_iss_cd       IN gipi_polbasic.iss_cd%TYPE,
                            p_issue_yy     IN gipi_polbasic.issue_yy%TYPE,
                            p_pol_seq_no   IN gipi_polbasic.pol_seq_no%TYPE,
                            p_renew_no     IN gipi_polbasic.renew_no%TYPE,
                            p_item_no      IN gipi_itmperil.item_no%TYPE,
                            p_peril_cd     IN gipi_itmperil.peril_cd%TYPE,
                            p_prem_rt     OUT gipi_itmperil.prem_rt%TYPE);

END Casualty_Accum;
/


