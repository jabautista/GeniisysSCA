CREATE OR REPLACE PACKAGE CPI.gipi_winv_tax_pkg
AS
   TYPE gipi_winv_tax_type IS RECORD (
      tax_id                 gipi_winv_tax.tax_id%TYPE,
      tax_cd                 gipi_winv_tax.tax_cd%TYPE,
      tax_desc               giis_tax_charges.tax_desc%TYPE,
      tax_amt                gipi_winv_tax.tax_amt%TYPE,
      par_id                 gipi_winv_tax.par_id%TYPE,
      line_cd                gipi_winv_tax.line_cd%TYPE,
      iss_cd                 gipi_winv_tax.iss_cd%TYPE,
      item_grp               gipi_winv_tax.item_grp%TYPE,
      takeup_seq_no          gipi_winv_tax.takeup_seq_no%TYPE,
      rate                   gipi_winv_tax.rate%TYPE,
      peril_sw               giis_tax_charges.peril_sw%TYPE,
      tax_allocation         gipi_winv_tax.tax_allocation%TYPE,
      fixed_tax_allocation   gipi_winv_tax.fixed_tax_allocation%TYPE,
      sum_tax_amt            NUMBER (12, 2),
      primary_sw             giis_tax_charges.primary_sw%TYPE,
   no_rate_tag    giis_tax_charges.no_rate_tag%TYPE
                                                 
   );

   TYPE gipi_winv_tax_tab IS TABLE OF gipi_winv_tax_type;

   FUNCTION get_gipi_winv_tax (
      p_par_id     gipi_winv_tax.par_id%TYPE,
      p_item_grp   gipi_winv_tax.item_grp%TYPE
   )
      --   p_takeup_seq_no GIPI_WINV_TAX.takeup_seq_no%TYPE) comment by cris 02/5/10
   RETURN gipi_winv_tax_tab PIPELINED;

   FUNCTION get_gipi_winv_tax2 (
      p_par_id          gipi_winv_tax.par_id%TYPE,
      p_item_grp        gipi_winv_tax.item_grp%TYPE,
      p_takeup_seq_no   gipi_winv_tax.takeup_seq_no%TYPE
   )
      RETURN gipi_winv_tax_tab PIPELINED;

   FUNCTION get_gipi_winv_tax3 (p_par_id gipi_winv_tax.par_id%TYPE)
      RETURN gipi_winv_tax_tab PIPELINED;

   PROCEDURE set_gipi_winv_tax (p_winvtax gipi_winv_tax%ROWTYPE);

   PROCEDURE del_gipi_winv_tax (
      p_par_id     gipi_winv_tax.par_id%TYPE,
      p_item_grp   gipi_winv_tax.item_grp%TYPE,
      p_tax_cd     gipi_winv_tax.tax_cd%TYPE,
      p_line_cd    gipi_winv_tax.line_cd%TYPE,
      p_iss_cd     gipi_winv_tax.iss_cd%TYPE
   );

   PROCEDURE del_all_gipi_winv_tax (p_par_id gipi_winv_tax.par_id%TYPE);

   --  p_item_grp GIPI_WINV_TAX.item_grp%TYPE); --added by cris 01/19/2010
   PROCEDURE get_gipi_winv_tax_exist (
      p_par_id   IN       gipi_winv_tax.par_id%TYPE,
      p_exist    OUT      NUMBER
   );

   PROCEDURE del_gipi_winv_tax_1 (p_par_id IN gipi_winv_tax.par_id%TYPE);
   
    PROCEDURE del_sel_gipi_winv_tax (
      p_par_id     gipi_winv_tax.par_id%TYPE,
      p_item_grp   gipi_winv_tax.item_grp%TYPE,
      p_tax_cd     gipi_winv_tax.tax_cd%TYPE,
   p_takeup_seq_no gipi_winv_tax.takeup_seq_no%TYPE
   );
   
   FUNCTION get_gipi_winv_tax_amt(
      p_par_id          gipi_winv_tax.par_id%TYPE,
      p_item_grp        gipi_winv_tax.item_grp%TYPE,
      p_tax_cd          gipi_winv_tax.tax_cd%TYPE
   )
   RETURN NUMBER;
   
   FUNCTION get_inv_tax_for_insert (
        p_par_id gipi_winv_tax.par_id%TYPE)
   RETURN gipi_winv_tax_tab PIPELINED;
END gipi_winv_tax_pkg;
/


