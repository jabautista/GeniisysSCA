CREATE OR REPLACE PACKAGE CPI.Gipi_Quote_Inv_Pkg AS
/******************************************************************************
   NAME:       GIPI_QUOTE_INV_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
    1                                         Created Module
    2          09/03/2010   rencela           Changed the parameters in 
    3          06/16/2011   rencela           added get_gipi_quote_invseq    
******************************************************************************/

  TYPE gipi_quote_inv_type IS RECORD
    (quote_id           GIPI_QUOTE_INVOICE.quote_id%TYPE,
     quote_inv_no       GIPI_QUOTE_INVOICE.quote_inv_no%TYPE,
     inv_no                VARCHAR2(15),
     currency_cd        GIPI_QUOTE_INVOICE.currency_cd%TYPE,
     currency_desc      GIIS_CURRENCY.currency_desc%TYPE,
     currency_rt        GIPI_QUOTE_INVOICE.currency_rt%TYPE,
     prem_amt            GIPI_QUOTE_INVOICE.prem_amt%TYPE,
     intm_no            GIPI_QUOTE_INVOICE.intm_no%TYPE,
     intm_name            GIIS_INTERMEDIARY.intm_name%TYPE,
     tot_tax_amt        NUMBER,
      tax_cd             GIPI_QUOTE_INVTAX.tax_cd%TYPE,
     tax_desc            GIIS_TAX_CHARGES.tax_desc%TYPE,
     tax_amt            GIPI_QUOTE_INVTAX.tax_amt%TYPE,
     amount_due            NUMBER,
     tax_id                GIPI_QUOTE_INVTAX.tax_id%TYPE,
     rate                GIPI_QUOTE_INVTAX.rate%TYPE,
     iss_cd                 GIIS_ISSOURCE.iss_cd%TYPE
  );

  TYPE gipi_quote_inv_tab IS TABLE OF gipi_quote_inv_type;
  
  /***************************************************
        QUOTE INVOICE TYPE - without their invtaxes 
       Created by: rencela
  ****************************************************/
  TYPE gipi_quote_invoice_type IS RECORD
  (  quote_id           GIPI_QUOTE_INVOICE.quote_id%TYPE,
     quote_inv_no       GIPI_QUOTE_INVOICE.quote_inv_no%TYPE,
iss_cd            GIPI_QUOTE_INVOICE.iss_cd%TYPE,     
     currency_cd        GIPI_QUOTE_INVOICE.currency_cd%TYPE,
     currency_desc      GIIS_CURRENCY.currency_desc%TYPE,
     currency_rt        GIPI_QUOTE_INVOICE.currency_rt%TYPE,
     tax_amt            GIPI_QUOTE_INVOICE.tax_amt%TYPE,
     prem_amt            GIPI_QUOTE_INVOICE.prem_amt%TYPE,
     intm_no            GIPI_QUOTE_INVOICE.intm_no%TYPE
     --,amount_due            NUMBER
  ); 
  
  TYPE gipi_quote_invoice_tab IS TABLE OF gipi_quote_invoice_type;
  
  /*********************************************************************
      RETRIEVE GIPI_QUOTE_INVOICE - without their invtaxes
    Created by: rencela
  **********************************************************************/
  FUNCTION get_gipi_quote_invoice(  p_quote_id     GIPI_QUOTE.quote_id%TYPE,
                                         p_iss_cd         GIIS_ISSOURCE.iss_cd%TYPE)
    RETURN gipi_quote_invoice_tab PIPELINED; 
        
  FUNCTION get_gipi_quote_inv (v_quote_id   GIPI_QUOTE.quote_id%TYPE)
    RETURN gipi_quote_inv_tab PIPELINED; 
    
  PROCEDURE Set_Gipi_Quote_Inv (p_gipi_quote_inv  IN  gipi_quote_inv_type,
                                p_iss_cd          IN  GIIS_ISSOURCE.iss_cd%TYPE );                                

  PROCEDURE Set_Gipi_Quote_Inv2 (p_quote_id          IN GIPI_QUOTE_INVOICE.quote_id%TYPE,
                                p_quote_inv_no      IN OUT GIPI_QUOTE_INVOICE.quote_inv_no%TYPE,
                                p_currency_cd       IN GIPI_QUOTE_INVOICE.currency_cd%TYPE,
                                p_currency_rt       IN GIPI_QUOTE_INVOICE.currency_rt%TYPE,
                                p_prem_amt            IN GIPI_QUOTE_INVOICE.prem_amt%TYPE,
                                p_intm_no             IN GIPI_QUOTE_INVOICE.intm_no%TYPE,
                                p_tax_amt             IN GIPI_QUOTE_INVTAX.tax_amt%TYPE,
                                p_iss_cd          IN GIIS_ISSOURCE.iss_cd%TYPE);                                    

  PROCEDURE Set_Gipi_Quote_Invtax (p_gipi_quote_invtax    IN   GIPI_QUOTE_INVTAX%ROWTYPE );                                

  PROCEDURE Del_Gipi_Quote_Inv (p_quote_id       GIPI_QUOTE_INVOICE.quote_id%TYPE,
                                p_quote_inv_no   GIPI_QUOTE_INVOICE.quote_inv_no%TYPE);

-- rencela start

-- GIPI_QUOTE_INVOICE_ ROW TYPE 
-- rencela 07202010
  TYPE gipi_quote_inv_typ2 IS RECORD(
         quote_id               GIPI_QUOTE_INVOICE.quote_id%TYPE,
       iss_cd               GIPI_QUOTE_INVOICE.iss_cd%TYPE,
       quote_inv_no           GIPI_QUOTE_INVOICE.quote_inv_no%TYPE,
       currency_cd           GIPI_QUOTE_INVOICE.currency_cd%TYPE,
       currency_rt           GIPI_QUOTE_INVOICE.currency_rt%TYPE,
       prem_amt               GIPI_QUOTE_INVOICE.prem_amt%TYPE,
       intm_no               GIPI_QUOTE_INVOICE.intm_no%TYPE,
       tax_amt               GIPI_QUOTE_INVOICE.tax_amt%TYPE
  );
  TYPE quote_inv_tab IS TABLE OF gipi_quote_inv_typ2;
  
-- GIPI_QUOTE_INV_TAX ROW TYPE
-- rencela 07202010
  TYPE gipi_quote_invtax_typ2 IS RECORD(
         line_cd                  GIPI_QUOTE_INVTAX.line_cd%TYPE,
         iss_cd                  GIPI_QUOTE_INVTAX.iss_cd%TYPE,
       quote_inv_no              GIPI_QUOTE_INVTAX.quote_inv_no%TYPE,
       tax_cd                  GIPI_QUOTE_INVTAX.tax_cd%TYPE,
       tax_id                  GIPI_QUOTE_INVTAX.tax_id%TYPE,
       tax_amt                 GIPI_QUOTE_INVTAX.tax_amt%TYPE,
       rate                   GIPI_QUOTE_INVTAX.rate%TYPE,
       fixed_tax_allocation      GIPI_QUOTE_INVTAX.fixed_tax_allocation%TYPE,
       item_grp                  GIPI_QUOTE_INVTAX.item_grp%TYPE,
       tax_allocation          GIPI_QUOTE_INVTAX.tax_allocation%TYPE
  );
  TYPE quote_invtax_tab IS TABLE OF gipi_quote_invtax_typ2;
  
  FUNCTION get_gipi_quote_inv_for_pack(p_pack_quote_id     GIPI_QUOTE.pack_quote_id%TYPE)
                                                                         
    RETURN gipi_quote_invoice_tab PIPELINED;
  
  FUNCTION get_gipi_quote_invseq (p_iss_cd GIPI_QUOTE.iss_cd%TYPE)
    RETURN GIIS_QUOTE_INV_SEQ.QUOTE_INV_NO%TYPE;
    
  PROCEDURE update_gipi_quote_inv (p_quote_id        GIPI_QUOTE_INVOICE.quote_id%TYPE,
                                   p_quote_inv_no    GIPI_QUOTE_INVOICE.quote_inv_no%TYPE,
                                   p_prem_amt          GIPI_QUOTE_INVOICE.prem_amt%TYPE,
                                   p_intm_no           GIPI_QUOTE_INVOICE.intm_no%TYPE,
                                   p_tax_amt           GIPI_QUOTE_INVTAX.tax_amt%TYPE,
                                   p_iss_cd         GIPI_QUOTE_INVTAX.iss_cd%TYPE);
-- rencela end  
END Gipi_Quote_Inv_Pkg;
/


