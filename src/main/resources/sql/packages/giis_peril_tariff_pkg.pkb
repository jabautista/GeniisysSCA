CREATE OR REPLACE PACKAGE BODY CPI.GIIS_PERIL_TARIFF_PKG AS

  FUNCTION get_giis_peril_tariff(p_line_cd  GIIS_PERIL_TARIFF.line_cd%TYPE)
    RETURN peril_tariff_tab PIPELINED IS

/*
**  Created by   : Menandro G.C. Robes
**  Date Created : June 24, 2010
**  Reference By : (GIPIS097 - Endorsement Item Peril Information)
**  Description  : Function to retrieve peril tariff records.
*/
    v_tariff     peril_tariff_type;

  BEGIN
    FOR i IN (
      SELECT a.line_cd, a.peril_cd, a.tarf_cd, b.tarf_desc, b.tarf_rate
        FROM giis_peril_tariff a
            ,giis_tariff       b
       WHERE a.tarf_cd = b.tarf_cd
         AND a.line_cd   = p_line_cd
       ORDER BY tarf_cd)
    LOOP
      v_tariff.line_cd   := i.line_cd;
      v_tariff.peril_cd  := i.peril_cd;
      v_tariff.tarf_cd   := i.tarf_cd;
      v_tariff.tarf_desc := i.tarf_desc;
      v_tariff.tarf_rate := i.tarf_rate;

      PIPE ROW(v_tariff);
    END LOOP;

    RETURN;
  END get_giis_peril_tariff;

END GIIS_PERIL_TARIFF_PKG;
/


