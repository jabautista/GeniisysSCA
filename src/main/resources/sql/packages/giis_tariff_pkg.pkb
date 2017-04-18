CREATE OR REPLACE PACKAGE BODY CPI.Giis_Tariff_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS003
  RECORD GROUP NAME: CGFK$GIPI_WFIREITM6_TARF_CD
***********************************************************************************/
    /*    Date        Author            Description
    **    ==========    ===============    ============================
    **    12.09.2011    mark jm            added tariff_zone and occupancy_cd
    */

    FUNCTION get_tariff_list
    RETURN tariff_list_tab PIPELINED IS
        v_tariff    tariff_list_type;

    BEGIN
        FOR i IN (
            SELECT tarf_cd, tarf_desc, tarf_rate, occupancy_cd, tariff_zone
              FROM GIIS_TARIFF
             ORDER BY UPPER(tarf_desc))
        LOOP
            v_tariff.tarf_cd        := i.tarf_cd;
            v_tariff.tarf_desc        := i.tarf_desc;
            v_tariff.tarf_rate        := i.tarf_rate;
            v_tariff.tariff_zone    := i.tariff_zone;
            v_tariff.occupancy_cd    := i.occupancy_cd;

            PIPE ROW(v_tariff);
        END LOOP;

        RETURN;
    END get_tariff_list;


/********************************** FUNCTION 2 ************************************
  MODULE: GIPIS038
  RECORD GROUP NAME: TARIFF_RG
***********************************************************************************/

  FUNCTION get_peril_tariff_list(p_line_cd    GIIS_PERIL_TARIFF.line_cd%TYPE,
                                      p_peril_cd    GIIS_PERIL_TARIFF.peril_cd%TYPE)
    RETURN peril_tariff_list_tab PIPELINED IS

    v_tariff    peril_tariff_list_type;

  BEGIN
      FOR i IN (
        SELECT a.tarf_cd, b.tarf_desc, b.tarf_rate
          FROM GIIS_PERIL_TARIFF a, GIIS_TARIFF b
         WHERE a.tarf_cd = b.tarf_cd
           AND a.line_cd = p_line_cd
           AND a.peril_cd = p_peril_cd
         ORDER BY a.tarf_cd)
    LOOP
        v_tariff.tarf_cd      := i.tarf_cd;
        v_tariff.tarf_desc      := i.tarf_desc;
        v_tariff.tarf_rate      := i.tarf_rate;
      PIPE ROW(v_tariff);
    END LOOP;

    RETURN;
  END get_peril_tariff_list;

    /*
    **  Created by        : Mark JM
    **  Date Created     : 08.01.2011
    **  Reference By     : (GIPIS038 - Item Peril Information)
    **  Description     : Returns list of values of tariff used in item peril screen
    */
    FUNCTION get_peril_tariff_list1(
        p_line_cd IN giis_peril_tariff.line_cd%TYPE,
          p_peril_cd IN giis_peril_tariff.peril_cd%TYPE,
        p_find_text IN VARCHAR2)
    RETURN peril_tariff_list_tab PIPELINED
    IS
        v_tariff peril_tariff_list_type;
    BEGIN
        FOR i IN (
            SELECT a.tarf_cd, b.tarf_desc, b.tarf_rate
              FROM GIIS_PERIL_TARIFF a, GIIS_TARIFF b
             WHERE a.tarf_cd = b.tarf_cd
               AND a.line_cd = p_line_cd
               AND a.peril_cd = p_peril_cd
               AND UPPER(b.tarf_desc) LIKE UPPER(NVL(p_find_text, '%%'))
            ORDER BY a.tarf_cd)
        LOOP
            v_tariff.tarf_cd      := i.tarf_cd;
            v_tariff.tarf_desc      := i.tarf_desc;
            v_tariff.tarf_rate      := i.tarf_rate;
            PIPE ROW(v_tariff);
        END LOOP;

        RETURN;
    END get_peril_tariff_list1;

END Giis_Tariff_Pkg;
/


