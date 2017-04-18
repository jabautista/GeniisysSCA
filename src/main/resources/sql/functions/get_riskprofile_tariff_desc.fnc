CREATE OR REPLACE FUNCTION cpi.get_riskprofile_tariff_desc (
   p_tarf_cd   giis_tariff_group.tariff_cd%TYPE
)
   RETURN VARCHAR2
IS
   /*
   **  Created By    : Benjo Brito
   **  Date Created  : 07.09.2015
   **  Description   : Retrieves Tariff Group Description
   **  Remarks       : Additional function for GENQA AFPGEN-IMPLEM SR 4577
   */
   v_tarf_desc   giis_tariff_group.tariff_grp_desc%TYPE;
BEGIN
   SELECT tariff_grp_desc
     INTO v_tarf_desc
     FROM cpi.giis_tariff_group
    WHERE tariff_cd = p_tarf_cd;

   RETURN (v_tarf_desc);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      v_tarf_desc := ' ';
      RETURN (v_tarf_desc);
END;