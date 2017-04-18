CREATE OR REPLACE PACKAGE CPI.GIXX_ORIG_ITMPERIL_PKG 
AS
  -- added by Kris 03.13.2013 for GIPIS101
  TYPE orig_itmperil_type IS RECORD (
    extract_id          gixx_orig_itmperil.extract_id%TYPE,
    item_no             gixx_orig_itmperil.item_no%TYPE,
    ann_tsi_amt         gixx_orig_itmperil.ann_tsi_amt%TYPE,
    ann_prem_amt        gixx_orig_itmperil.ann_prem_amt%TYPE,
    comp_rem            gixx_orig_itmperil.comp_rem%TYPE,
    ri_comm_amt         gixx_orig_itmperil.ri_comm_amt%TYPE,
    ri_comm_rate        gixx_orig_itmperil.ri_comm_rate%TYPE,
    line_cd             gixx_orig_itmperil.line_cd%TYPE,
    rec_flag            gixx_orig_itmperil.rec_flag%TYPE,
    
    your_peril_cd            gixx_orig_itmperil.peril_cd%TYPE,
    your_tsi_amt             gixx_orig_itmperil.tsi_amt%TYPE,
    your_prem_amt            gixx_orig_itmperil.prem_amt%TYPE,
    your_prem_rt             gixx_orig_itmperil.prem_rt%TYPE,
    your_discount_sw         gixx_orig_itmperil.discount_sw%TYPE,
    
    full_peril_cd            gixx_orig_itmperil.peril_cd%TYPE,
    full_prem_rt             gixx_orig_itmperil.prem_rt%TYPE,
    full_prem_amt           gixx_orig_itmperil.prem_amt%TYPE,
    full_tsi_amt            gixx_orig_itmperil.tsi_amt%TYPE,
    full_discount_sw        gixx_orig_itmperil.discount_sw%TYPE,
    
    total_full_prem_amt   NUMBER(16,2),
    total_full_tsi_amt    NUMBER(16,2),
    
    peril_desc          giis_peril.peril_name%TYPE
--    currency_cd         gixx_orig_itmperil.currency_cd%TYPE,
--    currency_desc       giis_currency.currency_desc%TYPE,
--    item_grp            gixx_orig_itmperil.item
--    item_desc
--    item_title          gixx_item.item_title%TYPE
  );
  
  TYPE orig_itmperil_tab IS TABLE OF orig_itmperil_type;
  
  FUNCTION get_orig_itmperil(
    p_extract_id    gixx_orig_itmperil.extract_id%TYPE,
    p_item_no       gixx_orig_itmperil.item_no%TYPE
  ) RETURN orig_itmperil_tab PIPELINED;
  -- end 03.13.2013: for GIPIS101
    

END GIXX_ORIG_ITMPERIL_PKG;
/


