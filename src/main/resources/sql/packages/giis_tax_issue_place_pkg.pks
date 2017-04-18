CREATE OR REPLACE PACKAGE CPI.giis_tax_issue_place_pkg
AS
   /********************************** FUNCTION 1 ************************************
     MODULE: GIPIS026
     RECORD GROUP NAME: TAX_ISSUE_PLACE
   ***********************************************************************************/
   TYPE tax_list_type IS RECORD (
      tax_cd           giis_tax_charges.tax_cd%TYPE,
      line_cd          giis_tax_charges.line_cd%TYPE,
      iss_cd           giis_tax_charges.iss_cd%TYPE,
      tax_desc         giis_tax_charges.tax_desc%TYPE,
      rate             giis_tax_charges.rate%TYPE,
      peril_sw         giis_tax_charges.peril_sw%TYPE,
      tax_id           giis_tax_charges.tax_id%TYPE,
      allocation_tag   giis_tax_charges.allocation_tag%TYPE,
      primary_sw       giis_tax_charges.primary_sw%TYPE,
      no_rate_tag      giis_tax_charges.no_rate_tag%TYPE,
      temp_tax_amt     giis_tax_charges.tax_amount%TYPE,
                                                   --added by irwin 7.27.2012
      tax_type         giis_tax_charges.tax_type%TYPE,
      takeup_alloc_tag giis_tax_charges.takeup_alloc_tag%TYPE /* added by jhing 11.09.2014 */
   );

   TYPE tax_list_tab IS TABLE OF tax_list_type;

   FUNCTION get_tax_issue_place_list (
      p_line_cd    giis_tax_charges.line_cd%TYPE,
      p_iss_cd     giis_tax_charges.iss_cd%TYPE,
      p_par_id     gipi_wpolbas.par_id%TYPE,
      p_item_grp   gipi_witem.item_grp%TYPE,
      p_takeup_seq_no gipi_winv_tax.takeup_seq_no%TYPE /* added by jhing 11.09.2014 */
   )
      RETURN tax_list_tab PIPELINED;
END giis_tax_issue_place_pkg;
/


