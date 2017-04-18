CREATE OR REPLACE PACKAGE CPI.Block_Accum
/*Modified    : Iris Bordey
**Date        : 07.23.2002
**MOdification:1. The whole package was optimized exclusively for the "original" version only.
**             2. Added a new procedure "latest_assured" to get the current assured.
*/
/* Author     : BoYeT
** Desciption : This package will hold all the procedures and functions that will
**              handle the Extraction for Block Accumulation of Gipis110 module.
**
*/
AS
  -- Extraction of data will start and end in this procedure. This will function as the
  -- main module for the entire extraction for block accumulation.
  PROCEDURE EXTRACT(p_province_cd   GIIS_BLOCK.province_cd%TYPE,
                    p_city_cd       GIIS_BLOCK.city_cd%TYPE,
					p_district_no   GIIS_BLOCK.district_no%TYPE,
					p_block_no      GIIS_BLOCK.block_no%TYPE,
					p_bus_type		NUMBER);

  FUNCTION Get_Cancel_Effectivity
   (p_line_cd     GIPI_POLBASIC.line_cd%TYPE,
	p_subline_cd  GIPI_POLBASIC.subline_cd%TYPE,
	p_iss_cd      GIPI_POLBASIC.iss_cd%TYPE,
	p_issue_yy    GIPI_POLBASIC.issue_yy%TYPE,
	p_pol_seq_no  GIPI_POLBASIC.pol_seq_no%TYPE,
	p_renew_no    GIPI_POLBASIC.renew_no%TYPE)
  RETURN VARCHAR2;

  
  -- procedure returns the latest tarf_cd
  PROCEDURE Latest_Tarf_Cd (p_line_cd     IN GIPI_POLBASIC.line_cd%TYPE,
                            p_subline_cd  IN GIPI_POLBASIC.line_cd%TYPE,
                            p_iss_cd      IN GIPI_POLBASIC.iss_cd%TYPE,
                            p_issue_yy    IN GIPI_POLBASIC.issue_yy%TYPE,
                            p_pol_seq_no  IN GIPI_POLBASIC.pol_seq_no%TYPE,
                            p_renew_no    IN GIPI_POLBASIC.renew_no%TYPE,
                            p_item_no     IN GIPI_FIREITEM.item_no%TYPE,
                            p_tarf_cd    OUT GIPI_FIREITEM.tarf_cd%TYPE);
  
  -- procedure returns the latest contruction_cd
  PROCEDURE Latest_Construct_Cd (p_line_cd    IN GIPI_POLBASIC.line_cd%TYPE,
                                 p_subline_cd IN GIPI_POLBASIC.line_cd%TYPE,
                                 p_iss_cd     IN GIPI_POLBASIC.iss_cd%TYPE,
                                 p_issue_yy   IN GIPI_POLBASIC.issue_yy%TYPE,
                                 p_pol_seq_no IN GIPI_POLBASIC.pol_seq_no%TYPE,
                                 p_renew_no   IN GIPI_POLBASIC.renew_no%TYPE,
                                 p_item_no    IN GIPI_FIREITEM.item_no%TYPE,
                                 p_constrc_cd OUT  GIPI_FIREITEM.tarf_cd%TYPE);
  -- procedure returns the latest loc_risk
  PROCEDURE Latest_Loc_Risk (p_line_cd     IN GIPI_POLBASIC.line_cd%TYPE,
                             p_subline_cd  IN GIPI_POLBASIC.line_cd%TYPE,
                             p_iss_cd      IN GIPI_POLBASIC.iss_cd%TYPE,
                             p_issue_yy    IN GIPI_POLBASIC.issue_yy%TYPE,
                             p_pol_seq_no  IN GIPI_POLBASIC.pol_seq_no%TYPE,
                             p_renew_no    IN GIPI_POLBASIC.renew_no%TYPE,
                             p_item_no     IN GIPI_FIREITEM.item_no%TYPE,
                             p_loc_risk   OUT VARCHAR2);
  -- the procedure computes the ann_tsi_amt per policy_no, item_no,
  PROCEDURE Compute_Ann_Tsi (p_line_cd      IN GIPI_POLBASIC.line_cd%TYPE,
                             p_subline_cd   IN GIPI_POLBASIC.line_cd%TYPE,
                             p_iss_cd       IN GIPI_POLBASIC.iss_cd%TYPE,
                             p_issue_yy     IN GIPI_POLBASIC.issue_yy%TYPE,
                             p_pol_seq_no   IN GIPI_POLBASIC.pol_seq_no%TYPE,
                             p_renew_no     IN GIPI_POLBASIC.renew_no%TYPE,
                             p_item_no      IN GIPI_FIREITEM.item_no%TYPE,
                             p_peril_cd     IN GIPI_ITMPERIL.peril_cd%TYPE,
                             v_ann_tsi_amt  OUT GIPI_POLBASIC.ann_tsi_amt%TYPE);
--the procedure returns the latest premium rate
  PROCEDURE Latest_Prem_Rt(p_line_cd      IN GIPI_POLBASIC.line_cd%TYPE,
                           p_subline_cd   IN GIPI_POLBASIC.line_cd%TYPE,
                           p_iss_cd       IN GIPI_POLBASIC.iss_cd%TYPE,
                           p_issue_yy     IN GIPI_POLBASIC.issue_yy%TYPE,
                           p_pol_seq_no   IN GIPI_POLBASIC.pol_seq_no%TYPE,
                           p_renew_no     IN GIPI_POLBASIC.renew_no%TYPE,
                           p_item_no      IN GIPI_FIREITEM.item_no%TYPE,
						   p_peril_cd     IN GIPI_ITMPERIL.peril_cd%TYPE,
   			               v_prem_rt     OUT GIPI_ITMPERIL.prem_rt%TYPE);
  --the procedure returns the latest FR_ITEM_TYPE
  PROCEDURE Latest_Fr_Item_Type(p_line_cd      IN GIPI_POLBASIC.line_cd%TYPE,
                                p_subline_cd   IN GIPI_POLBASIC.line_cd%TYPE,
                                p_iss_cd       IN GIPI_POLBASIC.iss_cd%TYPE,
                                p_issue_yy     IN GIPI_POLBASIC.issue_yy%TYPE,
                                p_pol_seq_no   IN GIPI_POLBASIC.pol_seq_no%TYPE,
                                p_renew_no     IN GIPI_POLBASIC.renew_no%TYPE,
                                p_item_no      IN GIPI_FIREITEM.item_no%TYPE,
   			                    p_fr_item_type OUT GIPI_FIREITEM.fr_item_type%TYPE);
  --the procedure returns from the latest assured..
  PROCEDURE latest_assured(p_line_cd      IN GIPI_POLBASIC.line_cd%TYPE,
                           p_subline_cd   IN GIPI_POLBASIC.line_cd%TYPE,
                           p_iss_cd       IN GIPI_POLBASIC.iss_cd%TYPE,
                           p_issue_yy     IN GIPI_POLBASIC.issue_yy%TYPE,
                           p_pol_seq_no   IN GIPI_POLBASIC.pol_seq_no%TYPE,
                           p_renew_no     IN GIPI_POLBASIC.renew_no%TYPE,
                           p_assd_no     OUT GIIS_ASSURED.assd_no%TYPE,
						   p_assd_name   OUT GIIS_ASSURED.assd_name%TYPE);
						   
-- procedure returns the latest province_cd, city, district_no, block_no and block_id
PROCEDURE Latest_Block (p_line_cd     IN GIPI_POLBASIC.line_cd%TYPE,
                         p_subline_cd  IN GIPI_POLBASIC.line_cd%TYPE,
                         p_iss_cd      IN GIPI_POLBASIC.iss_cd%TYPE,
                         p_issue_yy    IN GIPI_POLBASIC.issue_yy%TYPE,
                         p_pol_seq_no  IN GIPI_POLBASIC.pol_seq_no%TYPE,
                         p_renew_no    IN GIPI_POLBASIC.renew_no%TYPE,
                         p_item_no     IN GIPI_FIREITEM.item_no%TYPE,
                         v_block_no    OUT GIPI_FIREITEM.block_no%TYPE,
                         v_district_no OUT GIPI_FIREITEM.district_no%TYPE,
                         v_province_cd OUT GIIS_BLOCK.province_cd%TYPE,
                         v_city        OUT GIIS_BLOCK.city%TYPE,
                         v_block_id    OUT GIIS_BLOCK.block_id%TYPE,
						 v_RISK_CD      OUT GIPI_FIREITEM.RISK_CD%TYPE);

--added by VJ 091707--
  PROCEDURE latest_duration(p_line_cd      IN GIPI_POLBASIC.line_cd%TYPE,
                            p_subline_cd   IN GIPI_POLBASIC.line_cd%TYPE,
                            p_iss_cd       IN GIPI_POLBASIC.iss_cd%TYPE,
                            p_issue_yy     IN GIPI_POLBASIC.issue_yy%TYPE,
                            p_pol_seq_no   IN GIPI_POLBASIC.pol_seq_no%TYPE,
                            p_renew_no     IN GIPI_POLBASIC.renew_no%TYPE,
                            p_incept      OUT GIPI_POLBASIC.incept_date%TYPE,
		   				    P_expiry	  OUT GIPI_POLBASIC.expiry_date%TYPE);

END Block_Accum;
/


