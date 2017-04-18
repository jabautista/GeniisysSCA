CREATE OR REPLACE PACKAGE CPI.GIIS_PERIL_TARIFF_PKG AS

  TYPE peril_tariff_type IS RECORD (
    line_cd       GIIS_PERIL_TARIFF.line_cd%TYPE,
    peril_cd       GIIS_PERIL_TARIFF.peril_cd%TYPE,
    tarf_cd       GIIS_PERIL_TARIFF.tarf_cd%TYPE,
    tarf_desc     GIIS_TARIFF.tarf_desc%TYPE,
    tarf_rate     GIIS_TARIFF.tarf_rate%TYPE);
    
  TYPE peril_tariff_tab IS TABLE OF peril_tariff_type;
  
  FUNCTION get_giis_peril_tariff(p_line_cd  GIIS_PERIL_TARIFF.line_cd%TYPE)
    RETURN peril_tariff_tab PIPELINED;    

END GIIS_PERIL_TARIFF_PKG;
/


