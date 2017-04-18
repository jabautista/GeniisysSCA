CREATE OR REPLACE PACKAGE CPI.giimm014_pkg
AS
   TYPE get_pack_quote_lov_type IS RECORD (
      line_cd           gipi_pack_quote.line_cd%TYPE,
      subline_cd        gipi_pack_quote.subline_cd%TYPE,
      iss_cd            gipi_pack_quote.iss_cd%TYPE,
      quotation_yy      gipi_pack_quote.quotation_yy%TYPE,
      quotation_no      gipi_pack_quote.quotation_no%TYPE,
      proposal_no       gipi_pack_quote.proposal_no%TYPE,
      dsp_mean_status   cg_ref_codes.rv_meaning%TYPE,
      status            gipi_pack_quote.status%TYPE,
      client            gipi_pack_quote.assd_name%TYPE,
      incept_date       VARCHAR2 (100),
      expiry_date       VARCHAR2 (100),
      accept_date       VARCHAR2 (100),
      days              VARCHAR2 (100),
      pack_quote_id     GIPI_PACK_QUOTE.PACK_QUOTE_ID%TYPE,
      pack_quotation    VARCHAR2 (150),
      assd_name         GIPI_PACK_QUOTE.ASSD_NAME%TYPE
   );

   TYPE get_pack_quote_lov_tab IS TABLE OF get_pack_quote_lov_type;

   FUNCTION get_pack_quote_lov(
      p_line_cd         gipi_pack_quote.line_cd%TYPE,
      p_subline_cd      gipi_pack_quote.subline_cd%TYPE,
      p_iss_cd          gipi_pack_quote.iss_cd%TYPE,
      p_quotation_yy    gipi_pack_quote.quotation_yy%TYPE,
      p_quotation_no    gipi_pack_quote.quotation_no%TYPE,
      p_proposal_no     gipi_pack_quote.proposal_no%TYPE,
      p_assd_name       gipi_pack_quote.assd_name%TYPE,
      p_user_id        giis_users.user_id%TYPE
   )
      RETURN get_pack_quote_lov_tab PIPELINED;

   TYPE get_quotation_no_type IS RECORD (
      dv_quote   VARCHAR2 (300),
      quote_id   gipi_quote.quote_id%TYPE,   --marco - 07.07.2014
      line_cd    gipi_quote.line_cd%TYPE     --
   );

   TYPE get_quotation_no_tab IS TABLE OF get_quotation_no_type;

   FUNCTION get_giimm014_quotation_no (
      p_pack_quote_id   VARCHAR2
   )
      RETURN get_quotation_no_tab PIPELINED;
      
END;
/


