CREATE OR REPLACE PACKAGE CPI.Gipi_Quote_Itmperil_Pkg AS

  TYPE gipi_quote_itmperil_type IS RECORD (
    quote_id                GIPI_QUOTE_ITMPERIL.quote_id%TYPE,
    item_no                 GIPI_QUOTE_ITMPERIL.item_no%TYPE,
    peril_cd                GIPI_QUOTE_ITMPERIL.peril_cd%TYPE,
    peril_name              GIIS_PERIL.peril_name%TYPE,
    prem_rt                 GIPI_QUOTE_ITMPERIL.prem_rt%TYPE,
    tsi_amt                 GIPI_QUOTE_ITMPERIL.tsi_amt%TYPE,
    prem_amt                GIPI_QUOTE_ITMPERIL.prem_amt%TYPE,
    comp_rem                GIPI_QUOTE_ITMPERIL.comp_rem%TYPE);

  TYPE gipi_quote_itmperil_tab IS TABLE OF gipi_quote_itmperil_type;
  
  TYPE item_peril_type IS RECORD (
    quote_id                GIPI_QUOTE_ITMPERIL.quote_id%TYPE,
    item_no                 GIPI_QUOTE_ITMPERIL.item_no%TYPE,
    peril_cd                GIPI_QUOTE_ITMPERIL.peril_cd%TYPE,
    peril_name              GIIS_PERIL.peril_name%TYPE,
    peril_sname             GIIS_PERIL.peril_sname%TYPE,
    prem_rt                 GIPI_QUOTE_ITMPERIL.prem_rt%TYPE,
    tsi_amt                 GIPI_QUOTE_ITMPERIL.tsi_amt%TYPE,
    prem_amt                GIPI_QUOTE_ITMPERIL.prem_amt%TYPE,
    comp_rem                GIPI_QUOTE_ITMPERIL.comp_rem%TYPE,
    peril_type              GIPI_QUOTE_ITMPERIL.peril_type%TYPE,
    basic_peril_cd          GIPI_QUOTE_ITMPERIL.basic_peril_cd%TYPE,
    prt_flag                GIPI_QUOTE_ITMPERIL.prt_flag%TYPE,
    line_cd                 GIPI_QUOTE_ITMPERIL.line_cd%TYPE,
    ded_flag                VARCHAR2(1)
  );
  TYPE item_peril_tab IS TABLE OF item_peril_type;
  
  FUNCTION get_gipi_quote_itmperil (p_quote_id                GIPI_QUOTE_ITMPERIL.quote_id%TYPE,
                                    p_item_no                 GIPI_QUOTE_ITMPERIL.item_no%TYPE)
    RETURN gipi_quote_itmperil_tab PIPELINED;

  PROCEDURE set_gipi_quote_itmperil (    
    p_quote_id              IN  GIPI_QUOTE_ITMPERIL.quote_id%TYPE,
    p_item_no               IN  GIPI_QUOTE_ITMPERIL.item_no%TYPE,
    p_peril_cd              IN  GIPI_QUOTE_ITMPERIL.peril_cd%TYPE,
    p_prem_rt               IN  GIPI_QUOTE_ITMPERIL.prem_rt%TYPE,
    p_tsi_amt               IN  GIPI_QUOTE_ITMPERIL.tsi_amt%TYPE,
    p_prem_amt              IN  GIPI_QUOTE_ITMPERIL.prem_amt%TYPE,
    p_comp_rem              IN  GIPI_QUOTE_ITMPERIL.comp_rem%TYPE);
    
  PROCEDURE del_gipi_quote_itmperil (
    p_quote_id              IN  GIPI_QUOTE_ITMPERIL.quote_id%TYPE,
    p_item_no               IN  GIPI_QUOTE_ITMPERIL.item_no%TYPE,
    p_peril_cd              IN  GIPI_QUOTE_ITMPERIL.peril_cd%TYPE);
    
  FUNCTION get_item_peril_listing(
    p_quote_id              IN  GIPI_QUOTE_ITMPERIL.quote_id%TYPE,
    p_item_no               IN  GIPI_QUOTE_ITMPERIL.item_no%TYPE,
    p_line_cd               IN  GIPI_QUOTE_ITMPERIL.line_cd%TYPE,
    p_pack_line_cd          IN  GIPI_QUOTE_ITEM.pack_line_cd%TYPE,
    p_peril_name            IN  GIIS_PERIL.peril_name%TYPE,
    p_rate                  IN  GIPI_QUOTE_ITMPERIL.prem_rt%TYPE,
    p_tsi_amt               IN  GIPI_QUOTE_ITMPERIL.tsi_amt%TYPE,
    p_prem_amt              IN  GIPI_QUOTE_ITMPERIL.prem_amt%TYPE,
    p_remarks               IN  GIPI_QUOTE_ITMPERIL.comp_rem%TYPE
  )
    RETURN item_peril_tab PIPELINED;
    
  PROCEDURE set_giimm002_peril_info(
    p_quote_id              IN  GIPI_QUOTE_ITMPERIL.quote_id%TYPE,
    p_item_no               IN  GIPI_QUOTE_ITMPERIL.item_no%TYPE,
    p_peril_cd              IN  GIPI_QUOTE_ITMPERIL.peril_cd%TYPE,
    p_prem_rt               IN  GIPI_QUOTE_ITMPERIL.prem_rt%TYPE,
    p_tsi_amt               IN  GIPI_QUOTE_ITMPERIL.tsi_amt%TYPE,
    p_prem_amt              IN  GIPI_QUOTE_ITMPERIL.prem_amt%TYPE,
    p_comp_rem              IN  GIPI_QUOTE_ITMPERIL.comp_rem%TYPE,
    p_peril_type            IN  GIPI_QUOTE_ITMPERIL.peril_type%TYPE,
    p_basic_peril_cd        IN  GIPI_QUOTE_ITMPERIL.basic_peril_cd%TYPE,
    p_prt_flag              IN  GIPI_QUOTE_ITMPERIL.prt_flag%TYPE,
    p_line_cd               IN  GIPI_QUOTE_ITMPERIL.line_cd%TYPE
  );
  
  PROCEDURE del_giimm002_peril_info(
    p_quote_id              IN  GIPI_QUOTE_ITMPERIL.quote_id%TYPE,
    p_item_no               IN  GIPI_QUOTE_ITMPERIL.item_no%TYPE,
    p_peril_cd              IN  GIPI_QUOTE_ITMPERIL.peril_cd%TYPE
  );
  
  PROCEDURE update_quote_and_item(
    p_quote_id              IN  GIPI_QUOTE_ITMPERIL.quote_id%TYPE,
    p_item_no               IN  GIPI_QUOTE_ITMPERIL.item_no%TYPE
  );

  -- added nieko 04062016 UW-SPECS-2015-086 Quotation Deductibles
  PROCEDURE update_quote_deductibles(
    p_quote_id              IN  GIPI_QUOTE_ITMPERIL.quote_id%TYPE,
    p_item_no               IN  GIPI_QUOTE_ITMPERIL.item_no%TYPE,
    p_peril_cd              IN  GIPI_QUOTE_ITMPERIL.peril_cd%TYPE
  );
  
  -- added nieko 04062016 UW-SPECS-2015-086 Quotation Deductibles
  PROCEDURE delete_quote_deductibles(
    p_quote_id              IN  GIPI_QUOTE_ITMPERIL.quote_id%TYPE,
    p_item_no               IN  GIPI_QUOTE_ITMPERIL.item_no%TYPE,
    p_peril_cd              IN  GIPI_QUOTE_ITMPERIL.peril_cd%TYPE
  );
END Gipi_Quote_Itmperil_Pkg;
/


