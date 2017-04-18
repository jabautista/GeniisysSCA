CREATE OR REPLACE PACKAGE CPI.block_accum_bak
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
  PROCEDURE EXTRACT(p_province_cd   giis_block.province_cd%TYPE,
                    p_city_cd       giis_block.city_cd%TYPE,
					p_district_no   giis_block.district_no%TYPE,
					p_block_no      giis_block.block_no%TYPE);
  -- procedure returns the latest province_cd, city, district_no, block_no and block_id
  PROCEDURE Latest_Block(p_line_cd     IN gipi_polbasic.line_cd%TYPE,
                         p_subline_cd  IN gipi_polbasic.line_cd%TYPE,
                         p_iss_cd      IN gipi_polbasic.iss_cd%TYPE,
                         p_issue_yy    IN gipi_polbasic.issue_yy%TYPE,
                         p_pol_seq_no  IN gipi_polbasic.pol_seq_no%TYPE,
                         p_renew_no    IN gipi_polbasic.renew_no%TYPE,
                         p_item_no     IN gipi_fireitem.item_no%TYPE,
                         v_block_no    OUT gipi_fireitem.block_no%TYPE,
                         v_district_no OUT gipi_fireitem.district_no%TYPE,
                         v_province_cd OUT giis_block.province_cd%TYPE,
                         v_city        OUT giis_block.city%TYPE,
                         v_block_id    OUT giis_block.block_id%TYPE);
  -- procedure returns the latest tarf_cd
  PROCEDURE Latest_Tarf_Cd (p_line_cd     IN gipi_polbasic.line_cd%TYPE,
                            p_subline_cd  IN gipi_polbasic.line_cd%TYPE,
                            p_iss_cd      IN gipi_polbasic.iss_cd%TYPE,
                            p_issue_yy    IN gipi_polbasic.issue_yy%TYPE,
                            p_pol_seq_no  IN gipi_polbasic.pol_seq_no%TYPE,
                            p_renew_no    IN gipi_polbasic.renew_no%TYPE,
                            p_item_no     IN gipi_fireitem.item_no%TYPE,
                            p_tarf_cd    OUT gipi_fireitem.tarf_cd%TYPE);
  -- procedure returns the latest contruction_cd
  PROCEDURE Latest_Construct_Cd (p_line_cd    IN gipi_polbasic.line_cd%TYPE,
                                 p_subline_cd IN gipi_polbasic.line_cd%TYPE,
                                 p_iss_cd     IN gipi_polbasic.iss_cd%TYPE,
                                 p_issue_yy   IN gipi_polbasic.issue_yy%TYPE,
                                 p_pol_seq_no IN gipi_polbasic.pol_seq_no%TYPE,
                                 p_renew_no   IN gipi_polbasic.renew_no%TYPE,
                                 p_item_no    IN gipi_fireitem.item_no%TYPE,
                                 p_constrc_cd OUT  gipi_fireitem.tarf_cd%TYPE);
  -- procedure returns the latest loc_risk
  PROCEDURE Latest_Loc_Risk (p_line_cd     IN gipi_polbasic.line_cd%TYPE,
                             p_subline_cd  IN gipi_polbasic.line_cd%TYPE,
                             p_iss_cd      IN gipi_polbasic.iss_cd%TYPE,
                             p_issue_yy    IN gipi_polbasic.issue_yy%TYPE,
                             p_pol_seq_no  IN gipi_polbasic.pol_seq_no%TYPE,
                             p_renew_no    IN gipi_polbasic.renew_no%TYPE,
                             p_item_no     IN gipi_fireitem.item_no%TYPE,
                             p_loc_risk   OUT VARCHAR2);
  -- the procedure computes the ann_tsi_amt per policy_no, item_no,
  PROCEDURE Compute_Ann_Tsi (p_line_cd      IN gipi_polbasic.line_cd%TYPE,
                             p_subline_cd   IN gipi_polbasic.line_cd%TYPE,
                             p_iss_cd       IN gipi_polbasic.iss_cd%TYPE,
                             p_issue_yy     IN gipi_polbasic.issue_yy%TYPE,
                             p_pol_seq_no   IN gipi_polbasic.pol_seq_no%TYPE,
                             p_renew_no     IN gipi_polbasic.renew_no%TYPE,
                             p_item_no      IN gipi_fireitem.item_no%TYPE,
                             p_peril_cd     IN gipi_itmperil.peril_cd%TYPE,
                             v_ann_tsi_amt  OUT gipi_polbasic.ann_tsi_amt%TYPE);
--the procedure returns the latest premium rate
  PROCEDURE Latest_Prem_Rt(p_line_cd      IN gipi_polbasic.line_cd%TYPE,
                           p_subline_cd   IN gipi_polbasic.line_cd%TYPE,
                           p_iss_cd       IN gipi_polbasic.iss_cd%TYPE,
                           p_issue_yy     IN gipi_polbasic.issue_yy%TYPE,
                           p_pol_seq_no   IN gipi_polbasic.pol_seq_no%TYPE,
                           p_renew_no     IN gipi_polbasic.renew_no%TYPE,
                           p_item_no      IN gipi_fireitem.item_no%TYPE,
						   p_peril_cd     IN gipi_itmperil.peril_cd%TYPE,
   			               v_prem_rt     OUT gipi_itmperil.prem_rt%TYPE);
  --the procedure returns the latest FR_ITEM_TYPE
  PROCEDURE Latest_Fr_Item_Type(p_line_cd      IN gipi_polbasic.line_cd%TYPE,
                                p_subline_cd   IN gipi_polbasic.line_cd%TYPE,
                                p_iss_cd       IN gipi_polbasic.iss_cd%TYPE,
                                p_issue_yy     IN gipi_polbasic.issue_yy%TYPE,
                                p_pol_seq_no   IN gipi_polbasic.pol_seq_no%TYPE,
                                p_renew_no     IN gipi_polbasic.renew_no%TYPE,
                                p_item_no      IN gipi_fireitem.item_no%TYPE,
   			                    p_fr_item_type OUT gipi_fireitem.fr_item_type%TYPE);
  --the procedure returns from the latest assured..
  PROCEDURE latest_assured(p_line_cd      IN gipi_polbasic.line_cd%TYPE,
                           p_subline_cd   IN gipi_polbasic.line_cd%TYPE,
                           p_iss_cd       IN gipi_polbasic.iss_cd%TYPE,
                           p_issue_yy     IN gipi_polbasic.issue_yy%TYPE,
                           p_pol_seq_no   IN gipi_polbasic.pol_seq_no%TYPE,
                           p_renew_no     IN gipi_polbasic.renew_no%TYPE,
                           p_assd_no     OUT giis_assured.assd_no%TYPE,
						   p_assd_name   OUT giis_assured.assd_name%TYPE);

END Block_Accum_bak;
/

DROP PACKAGE CPI.BLOCK_ACCUM_BAK;
