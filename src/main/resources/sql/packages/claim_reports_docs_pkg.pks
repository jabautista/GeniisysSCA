CREATE OR REPLACE PACKAGE CPI.claim_reports_docs_pkg
AS
/******************************************************************************
   NAME:       CLAIM_REPORTS_DOCS_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/18/2011             1. Created this package.
******************************************************************************/
   TYPE acknow_call_letter_type IS RECORD (
      assured_name   gicl_claims.assured_name%TYPE,
      send_to        VARCHAR2 (32767),
      intm           VARCHAR2 (32767),
      des            VARCHAR2 (32767),
      make           giis_mc_make.make%TYPE,
      closing        giac_rep_signatory.label%TYPE,
      signatory      giis_signatory_names.signatory%TYPE,
      designation    giis_signatory_names.designation%TYPE,
      lbl            VARCHAR2 (32767),
      val            VARCHAR2 (32767),
      item_title     VARCHAR2 (32767),
      plate_no       gicl_motor_car_dtl.plate_no%TYPE,
      c              VARCHAR2 (20),
      body_text      VARCHAR2 (32767),
	  loss_date		 VARCHAR2(100) -- added by: Nica 10.29.2012
   );

   TYPE acknow_call_letter_tab IS TABLE OF acknow_call_letter_type;

   FUNCTION get_claim_doc_details (
      p_claim_id         gicl_claims.claim_id%TYPE,
      p_attention        VARCHAR2,
      p_line_cd          gicl_claims.line_cd%TYPE,
      p_iss_cd           gicl_claims.iss_cd%TYPE,
      p_call_out         VARCHAR2,
      p_beginning_text   VARCHAR2,
      p_ending_text      VARCHAR2
   )
      RETURN acknow_call_letter_tab PIPELINED;
END claim_reports_docs_pkg;
/


