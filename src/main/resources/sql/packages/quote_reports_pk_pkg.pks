CREATE OR REPLACE PACKAGE CPI.QUOTE_REPORTS_PK_PKG AS
/******************************************************************************
   NAME:       QUOTE_REPORTS_PK_PKG
   PURPOSE:    For Package Quotes (Report)

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        4/7/2011    Windell Valle    Created this package.
******************************************************************************/

/*****************ADDED*BY*WINDELL***********04*07*2011**************UCPB***********/
/*   Added by    : Windell Valle
**   Date Created: April 07, 2011
**   Last Revised: April 12, 2011
**   Description : UCPB Package Quote
**   Client(s)   : UCPB,...
*/
   -- MAIN DETAILS -- start
   TYPE pk_quote_details_ucpb_type IS RECORD (
      line_name       giis_line.line_name%TYPE,
      quote_no        VARCHAR2 (30),
      assd            VARCHAR2 (3000),
      header          gipi_quote.header%TYPE,
      footer          gipi_quote.footer%TYPE,
      incept          VARCHAR2 (100),
      expiry          VARCHAR2 (100),
      DURATION        VARCHAR2 (200),
      valid           VARCHAR2 (30),
      acct_of_cd      gipi_quote.acct_of_cd%TYPE,
      acct_of_cd_sw   gipi_quote.acct_of_cd_sw%TYPE,
      quote_id        gipi_quote.quote_id%TYPE,
      address         VARCHAR2 (200),
      remarks         gipi_quote.remarks%TYPE,
      line_cd         giis_line.line_cd%TYPE,
      iss_cd          giis_issource.iss_cd%TYPE,
      user_name       giis_users.user_name%TYPE,
      mortgagee       giis_mortgagee.mortg_name%TYPE,
      sig_name        GIIS_SIGNATORY_NAMES.signatory%TYPE,
      sig_des          GIIS_SIGNATORY_NAMES.designation%TYPE,
      logo_file       VARCHAR2 (32767),
      bank_ref_no   gipi_quote.bank_ref_no%TYPE
   );
   TYPE quote_pk_details_ucpb_tab IS TABLE OF pk_quote_details_ucpb_type;
   FUNCTION get_quote_details_ucpb (p_quote_id NUMBER)
      RETURN quote_pk_details_ucpb_tab PIPELINED;
   -- MAIN DETAILS -- end


   -- PERIL DETAILS -- start
   TYPE pk_peril_details_ucpb_type IS RECORD (
      peril           VARCHAR2 (32767) := NULL,
      peril_remarks   VARCHAR2 (32767) := NULL
   );
   TYPE peril_pk_details_tab IS TABLE OF pk_peril_details_ucpb_type;
   FUNCTION get_peril_details_ucpb (p_quote_id NUMBER)
      RETURN peril_pk_details_tab PIPELINED;
   -- PERIL DETAILS -- end


   -- DEDUCTIBLES DETAILS -- start
   TYPE pk_deduct_details_ucpb_type IS RECORD (
      deductible_text   VARCHAR2 (32767) := NULL
   );
   TYPE deductible_pk_details_tab IS TABLE OF pk_deduct_details_ucpb_type;
   FUNCTION get_deductible_details_ucpb (p_quote_id NUMBER)
      RETURN deductible_pk_details_tab PIPELINED;
   -- DEDUCTIBLES DETAILS -- end


   -- OTHER DETAILS -- start
   TYPE pk_item_details_ucpb_type IS RECORD (
      item        VARCHAR2 (32767) := NULL,
      detail      VARCHAR2 (32767) := NULL,
      item_desc   VARCHAR2 (32767) := NULL
   );
   TYPE item_pk_details_tab IS TABLE OF pk_item_details_ucpb_type;

   FUNCTION get_item_details_ucpb (p_quote_id NUMBER)
      RETURN item_pk_details_tab PIPELINED;
   -- OTHER DETAILS -- end


   -- WARRANTY CLAUSE / INSURING CONDITIONS -- start
   TYPE pk_wc_details_ucpb_type IS RECORD (
      warrcla   VARCHAR2 (32767) := NULL
   );
   TYPE wc_pk_details_tab IS TABLE OF pk_wc_details_ucpb_type;
   FUNCTION get_wc_details_ucpb (p_quote_id NUMBER)
      RETURN wc_pk_details_tab PIPELINED;
   -- WARRANTY CLAUSE / INSURING CONDITIONS -- end


   -- PREMIUM DETAILS -- start
   TYPE pk_premium_details_ucpb_type IS RECORD (
      premium       VARCHAR2 (200),
      tax_desc   giis_tax_charges.tax_desc%TYPE,
      tax_amt    gipi_quote_invtax.tax_amt%TYPE,
      tot_amt    VARCHAR2 (32767)                 := NULL
   );
   TYPE premium_pk_details_tab IS TABLE OF pk_premium_details_ucpb_type;
   FUNCTION get_premium_details_ucpb (p_quote_id NUMBER)
      RETURN premium_pk_details_tab PIPELINED;
   -- PREMIUM DETAILS -- end

/*****************ADDED*BY*WINDELL***********04*07*2011**************UCPB***********/

END QUOTE_REPORTS_PK_PKG;
/


