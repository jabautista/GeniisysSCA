CREATE OR REPLACE FUNCTION CPI.get_loc_inv_tax_sum (
   p_iss_cd        gipi_invoice.iss_cd%TYPE,
   p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE
)
   RETURN NUMBER
AS
   v_loc_tax         NUMBER;
   v_other_charges   NUMBER;
   v_chk             VARCHAR (1) := 'N';
/* Created By   : Vincent
** Date Created : 02072006
** Description  : Returns the sum of the rounded off converted (into local currency)
**                values of the taxes in gipi_inv_tax
*/
BEGIN
/*rochelle,03252008 added checking of param OTHER_CHARGES_CODE
  to exclude Other_Charges in total tax_amt      */
   FOR chk IN (SELECT 1
                 FROM giis_parameters
                WHERE param_name LIKE UPPER ('%OTHER_CHARGES_CODE%'))
   LOOP
      v_chk := 'Y';
   END LOOP;

   IF v_chk = 'Y'
   THEN
      --rochelle, 03252008 added link to tbl: GIIS_TAX_CHARGES for validation
--      SELECT NVL (SUM (ROUND ((git.tax_amt * ginv.currency_rt), 2)), 0) loc_tax --RCDatu 11.19.2013
      SELECT NVL (ROUND (SUM (git.tax_amt * ginv.currency_rt), 2), 0) loc_tax
        INTO v_loc_tax
        FROM gipi_inv_tax git, gipi_invoice ginv, giis_tax_charges gtc
       WHERE 1 = 1
         AND git.prem_seq_no = ginv.prem_seq_no
         AND git.iss_cd = ginv.iss_cd
         AND gtc.tax_cd = git.tax_cd
         AND gtc.iss_cd = git.iss_cd
         AND gtc.line_cd = git.line_cd
         AND gtc.tax_id = git.tax_id                       -- belle 08.10.2012
         AND ginv.iss_cd = p_iss_cd
         AND ginv.prem_seq_no = p_prem_seq_no
         AND gtc.tax_desc NOT LIKE UPPER ('%OTHER CHARGES%');
   ELSE
--      SELECT NVL (SUM (ROUND ((git.tax_amt * ginv.currency_rt), 2)), 0) loc_tax --RCDatu 11.19.2013
      SELECT NVL (ROUND (SUM (git.tax_amt * ginv.currency_rt), 2), 0) loc_tax
        INTO v_loc_tax
        FROM gipi_inv_tax git, gipi_invoice ginv
       WHERE 1 = 1
         AND git.prem_seq_no = ginv.prem_seq_no
         AND git.iss_cd = ginv.iss_cd
         AND ginv.iss_cd = p_iss_cd
         AND ginv.prem_seq_no = p_prem_seq_no;
   END IF;

   RETURN (v_loc_tax);
END;
/

