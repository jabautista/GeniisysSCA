CREATE OR REPLACE PACKAGE CPI.Giis_Tax_Charges_Pkg AS

  TYPE tax_list_type IS RECORD
    (tax_cd    GIIS_TAX_CHARGES.tax_cd%TYPE, 
  line_cd   GIIS_TAX_CHARGES.line_cd%TYPE, 
  iss_cd    GIIS_TAX_CHARGES.iss_cd%TYPE, 
  tax_desc   GIIS_TAX_CHARGES.tax_desc%TYPE, 
  rate    GIIS_TAX_CHARGES.rate%TYPE, 
  peril_sw   GIIS_TAX_CHARGES.peril_sw%TYPE, 
  tax_id    GIIS_TAX_CHARGES.tax_id%TYPE, 
  allocation_tag  GIIS_TAX_CHARGES.allocation_tag%TYPE,
  primary_sw   GIIS_TAX_CHARGES.primary_sw%TYPE,
  no_rate_tag  GIIS_TAX_CHARGES.no_rate_tag%TYPE,
  peril_cd     GIIS_TAX_PERIL.peril_cd%TYPE,
  tax_amount    giis_tax_charges.tax_amount%TYPE, --added by Gzelle 10302014
  tax_type      giis_tax_charges.tax_type%TYPE, --added by Gzelle 10302014,
  takeup_alloc_tag  giis_tax_charges.takeup_alloc_tag%TYPE -- added by jhing 11.09.2014 
  );
  TYPE tax_list_tab IS TABLE OF tax_list_type;
  
  TYPE tax_cd_type IS RECORD(
    tax_cd      GIIS_TAX_CHARGES.tax_cd%TYPE
  );
  TYPE tax_cd_tab IS TABLE OF tax_cd_type;  
 
  
  FUNCTION get_tax_list (p_line_cd   GIIS_TAX_CHARGES.line_cd%TYPE,
                         p_iss_cd    GIIS_TAX_CHARGES.iss_cd%TYPE,
       p_quote_id  GIPI_QUOTE.quote_id%TYPE) 
    RETURN tax_list_tab PIPELINED;
 
  FUNCTION get_bond_tax_list (p_line_cd   GIIS_TAX_CHARGES.line_cd%TYPE,
                              p_iss_cd    GIIS_TAX_CHARGES.iss_cd%TYPE,
                              p_par_id  gipi_wpolbas.par_id%TYPE,
                              p_vat_tag   GIIS_ASSURED.vat_tag%TYPE) 
    RETURN tax_list_tab PIPELINED; 

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS026 
  RECORD GROUP NAME: PACKAGE 
***********************************************************************************/
 
  FUNCTION get_package_tax_list(p_par_id   GIPI_WITEM.par_id%TYPE,
             p_item_grp    GIPI_WITEM.item_grp%TYPE,
        p_iss_cd   GIIS_TAX_CHARGES.iss_cd%TYPE)
 RETURN tax_list_tab PIPELINED;
 

/********************************** FUNCTION 2 ************************************
  MODULE: GIPIS026 
  RECORD GROUP NAME: POLICY 
***********************************************************************************/

  FUNCTION get_policy_tax_list(p_line_cd   GIIS_TAX_CHARGES.line_cd%TYPE,
               p_iss_cd      GIIS_TAX_CHARGES.iss_cd%TYPE,
          p_par_id     GIPI_WPOLBAS.par_id%TYPE)
 RETURN tax_list_tab PIPELINED; 
 

/********************************** FUNCTION 3 ************************************
  MODULE: GIPIS026 
  RECORD GROUP NAME: TAX_ISSUE_PLACE 
***********************************************************************************/

  FUNCTION get_tax_issue_place_list(p_line_cd GIIS_TAX_CHARGES.line_cd%TYPE,
                 p_iss_cd GIIS_TAX_CHARGES.iss_cd%TYPE,
         p_place_cd  GIIS_TAX_ISSUE_PLACE.place_cd%TYPE,
         p_par_id   GIPI_WPOLBAS.par_id%TYPE)
 RETURN tax_list_tab PIPELINED;

 
/********************************** FUNCTION 4 ************************************
  MODULE: GIIMM002 
  RECORD GROUP NAME: RG_TAX_CHARGES 
***********************************************************************************/
 
  FUNCTION get_tax_charges_list (p_line_cd      GIIS_TAX_CHARGES.line_cd%TYPE,
                            p_iss_cd       GIIS_TAX_CHARGES.iss_cd%TYPE,
          p_incept_date  GIIS_TAX_CHARGES.eff_start_date%TYPE) 
    RETURN tax_list_tab PIPELINED;
    
  FUNCTION get_quote_tax_charges_list (p_line_cd   	GIIS_TAX_CHARGES.line_cd%TYPE,
									   p_iss_cd    	GIIS_TAX_CHARGES.iss_cd%TYPE,
									   p_quote_id  	GIPI_QUOTE.quote_id%TYPE,
									   p_find_text	VARCHAR2) 
    RETURN tax_list_tab PIPELINED; 
    
    FUNCTION get_tax_list2 (
        p_line_cd   	GIIS_TAX_CHARGES.line_cd%TYPE,
        p_iss_cd    	GIIS_TAX_CHARGES.iss_cd%TYPE,
        p_policy_id  	gipi_polbasic.policy_id%TYPE
    ) 
    RETURN tax_list_tab PIPELINED;
    
    TYPE tax_list_type2 IS RECORD(
        tax_cd              GIIS_TAX_CHARGES.tax_cd%TYPE, 
        line_cd             GIIS_TAX_CHARGES.line_cd%TYPE, 
        iss_cd              GIIS_TAX_CHARGES.iss_cd%TYPE, 
        tax_desc            GIIS_TAX_CHARGES.tax_desc%TYPE, 
        rate                GIIS_TAX_CHARGES.rate%TYPE, 
        peril_sw            GIIS_TAX_CHARGES.peril_sw%TYPE, 
        tax_id              GIIS_TAX_CHARGES.tax_id%TYPE, 
        allocation_tag      GIIS_TAX_CHARGES.allocation_tag%TYPE,
        primary_sw          GIIS_TAX_CHARGES.primary_sw%TYPE,
        no_rate_tag         GIIS_TAX_CHARGES.no_rate_tag%TYPE,
        peril_cd            GIIS_TAX_PERIL.peril_cd%TYPE,
        tax_amt             GIIS_TAX_CHARGES.tax_amount%TYPE
  );
  TYPE tax_list_tab2 IS TABLE OF tax_list_type2;
    
    FUNCTION get_tax_charges_lov(
        p_line_cd           GIIS_TAX_CHARGES.line_cd%TYPE,
        p_iss_cd            GIIS_TAX_CHARGES.iss_cd%TYPE,
        p_quote_id          GIPI_QUOTE.quote_id%TYPE,
        p_prem_amt          GIPI_QUOTE_ITMPERIL.prem_amt%TYPE,
        p_currency_rate     GIPI_QUOTE_ITEM.currency_rate%TYPE,
         /*p_tax_cd_list       VARCHAR2,
        p_tax_cd_count      NUMBER, remove by steven 12/06/2012*/
        p_keyword           VARCHAR2
    ) 
    RETURN tax_list_tab2 PIPELINED;
    
    FUNCTION get_tax_cd_list(
        p_tax_cd_list       VARCHAR2,
        p_tax_cd_count      NUMBER
    )
    RETURN tax_cd_tab PIPELINED;

    TYPE tax_list_type3 IS RECORD(
        tax_id              giis_tax_charges.tax_id%TYPE, 
        tax_cd              giis_tax_charges.tax_cd%TYPE, 
        tax_desc            giis_tax_charges.tax_desc%TYPE,
        tax_type            giis_tax_charges.tax_type%TYPE,
        no_rate_tag         giis_tax_charges.no_rate_tag%TYPE
  );
  TYPE tax_list_tab3 IS TABLE OF tax_list_type3;
    
   FUNCTION get_giis_tax_charges (
      p_line_cd   giis_tax_charges.line_cd%TYPE,
      p_iss_cd    giis_tax_charges.iss_cd%TYPE
   ) 
      RETURN tax_list_tab3 PIPELINED;
    
END Giis_Tax_Charges_Pkg;
/


