CREATE OR REPLACE PACKAGE CPI.Vessel_Accum_bak
/* author     : grace
** desciption : this package will hold all the procedures and functions that will
**              handle the extraction for vessel accumulation of gipis109 module.
*/
AS
  -- extraction of data will start and end in this procedure. this will function as the
  -- main module for the entire extraction for vessel accumulation.
  PROCEDURE EXTRACT(p_vessel_cd       GIIS_VESSEL.vessel_cd%TYPE);
  -- PROCEDURE RETURNS THE LATEST BL_AWB
  PROCEDURE latest_bl_awb  (p_line_cd     IN GIPI_POLBASIC.line_cd%TYPE,
                            p_subline_cd  IN GIPI_POLBASIC.line_cd%TYPE,
                            p_iss_cd      IN GIPI_POLBASIC.iss_cd%TYPE,
                            p_issue_yy    IN GIPI_POLBASIC.issue_yy%TYPE,
                            p_pol_seq_no  IN GIPI_POLBASIC.pol_seq_no%TYPE,
                            p_renew_no    IN GIPI_POLBASIC.renew_no%TYPE,
                            p_item_no     IN GIPI_CARGO.item_no%TYPE,
                            p_bl_awb     OUT GIPI_CARGO.bl_awb%TYPE);
  -- PROCEDURE RETURNS THE LATEST ETA
  PROCEDURE latest_eta  (p_line_cd     IN GIPI_POLBASIC.line_cd%TYPE,
                         p_subline_cd  IN GIPI_POLBASIC.line_cd%TYPE,
                         p_iss_cd      IN GIPI_POLBASIC.iss_cd%TYPE,
                         p_issue_yy    IN GIPI_POLBASIC.issue_yy%TYPE,
                         p_pol_seq_no  IN GIPI_POLBASIC.pol_seq_no%TYPE,
                         p_renew_no    IN GIPI_POLBASIC.renew_no%TYPE,
                         p_item_no     IN GIPI_CARGO.item_no%TYPE,
                         p_eta        OUT VARCHAR2);
  -- PROCEDURE RETURNS THE LATEST ETD
  PROCEDURE latest_etd  (p_line_cd     IN GIPI_POLBASIC.line_cd%TYPE,
                         p_subline_cd  IN GIPI_POLBASIC.line_cd%TYPE,
                         p_iss_cd      IN GIPI_POLBASIC.iss_cd%TYPE,
                         p_issue_yy    IN GIPI_POLBASIC.issue_yy%TYPE,
                         p_pol_seq_no  IN GIPI_POLBASIC.pol_seq_no%TYPE,
                         p_renew_no    IN GIPI_POLBASIC.renew_no%TYPE,
                         p_item_no     IN GIPI_CARGO.item_no%TYPE,
                         p_etd        OUT VARCHAR2);
  --PROCEUDRE RETURNS THE LATEST CARGO_CLASS_CD, CARGO_CLASS_DESC
  PROCEDURE latest_cargo_class  (p_line_cd         IN GIPI_POLBASIC.line_cd%TYPE,
                                 p_subline_cd        IN GIPI_POLBASIC.line_cd%TYPE,
                                 p_iss_cd            IN GIPI_POLBASIC.iss_cd%TYPE,
                                 p_issue_yy          IN GIPI_POLBASIC.issue_yy%TYPE,
                                 p_pol_seq_no        IN GIPI_POLBASIC.pol_seq_no%TYPE,
                                 p_renew_no          IN GIPI_POLBASIC.renew_no%TYPE,
                                 p_item_no           IN GIPI_CARGO.item_no%TYPE,
                                 p_cargo_class_cd   OUT GIPI_CARGO.cargo_class_cd%TYPE,
				 p_cargo_class_desc OUT GIIS_CARGO_CLASS.cargo_class_desc%TYPE);
  -- PROCEDURE RETURNS THE LATEST CARGO_TYPE
  PROCEDURE latest_cargo_type (p_line_cd     IN GIPI_POLBASIC.line_cd%TYPE,
                               p_subline_cd  IN GIPI_POLBASIC.line_cd%TYPE,
                               p_iss_cd      IN GIPI_POLBASIC.iss_cd%TYPE,
                               p_issue_yy    IN GIPI_POLBASIC.issue_yy%TYPE,
                               p_pol_seq_no  IN GIPI_POLBASIC.pol_seq_no%TYPE,
                               p_renew_no    IN GIPI_POLBASIC.renew_no%TYPE,
                               p_item_no     IN GIPI_FIREITEM.item_no%TYPE,
                               p_cargo_type      OUT GIPI_CARGO.cargo_type%TYPE,
			       p_cargo_type_desc OUT GIIS_CARGO_TYPE.cargo_type_desc%TYPE);
  -- THE PROCEDURE COMPUTES THE ANN_TSI_AMT PER POLICY_NO, ITEM_NO,
  PROCEDURE Compute_Ann_Tsi (p_line_cd      IN GIPI_POLBASIC.line_cd%TYPE,
                             p_subline_cd   IN GIPI_POLBASIC.line_cd%TYPE,
                             p_iss_cd       IN GIPI_POLBASIC.iss_cd%TYPE,
                             p_issue_yy     IN GIPI_POLBASIC.issue_yy%TYPE,
                             p_pol_seq_no   IN GIPI_POLBASIC.pol_seq_no%TYPE,
                             p_renew_no     IN GIPI_POLBASIC.renew_no%TYPE,
                             p_item_no      IN GIPI_FIREITEM.item_no%TYPE,
                             p_peril_cd     IN GIPI_ITMPERIL.peril_cd%TYPE,
	 		     v_ann_tsi_amt  OUT GIPI_POLBASIC.ann_tsi_amt%TYPE);
  --THE PROCEDURE RETURNS THE LATEST PREMIUM RATE
  PROCEDURE Latest_Prem_Rt(p_line_cd      IN GIPI_POLBASIC.line_cd%TYPE,
                           p_subline_cd   IN GIPI_POLBASIC.line_cd%TYPE,
                           p_iss_cd       IN GIPI_POLBASIC.iss_cd%TYPE,
                           p_issue_yy     IN GIPI_POLBASIC.issue_yy%TYPE,
                           p_pol_seq_no   IN GIPI_POLBASIC.pol_seq_no%TYPE,
                           p_renew_no     IN GIPI_POLBASIC.renew_no%TYPE,
                           p_item_no      IN GIPI_FIREITEM.item_no%TYPE,
		           p_peril_cd     IN GIPI_ITMPERIL.peril_cd%TYPE,
   			   v_prem_rt     OUT GIPI_ITMPERIL.prem_rt%TYPE);
  --the procedure returns from the latest assured..
  PROCEDURE latest_assured(p_line_cd      IN GIPI_POLBASIC.line_cd%TYPE,
                           p_subline_cd   IN GIPI_POLBASIC.line_cd%TYPE,
                           p_iss_cd       IN GIPI_POLBASIC.iss_cd%TYPE,
                           p_issue_yy     IN GIPI_POLBASIC.issue_yy%TYPE,
                           p_pol_seq_no   IN GIPI_POLBASIC.pol_seq_no%TYPE,
                           p_renew_no     IN GIPI_POLBASIC.renew_no%TYPE,
                           p_assd_no     OUT GIIS_ASSURED.assd_no%TYPE,
			   p_assd_name   OUT GIIS_ASSURED.assd_name%TYPE);
END Vessel_Accum_bak;
/


