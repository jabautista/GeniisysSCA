SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   /*
   **  Created By    : Benjo Brito
   **  Date Created  : 07.09.2015
   **  Remarks       : Insert script of tariff for Philippines clients
   **                  Can maintain different values of tariff. tariff_cd = first character of Tariff Code
   **                  GENQA AFPGEN-IMPLEM SR 4577, 4268, 4264
   */
   FOR i IN (SELECT rv_low_value, rv_meaning
               FROM cpi.cg_ref_codes
              WHERE rv_domain = 'GIIS_TARIFF.TARF_CD')
   LOOP
      BEGIN
         SELECT 1
           INTO v_exist
           FROM cpi.giis_tariff_group
          WHERE tariff_cd = i.rv_low_value;

         IF v_exist = 1
         THEN
            DBMS_OUTPUT.put_line
                            (   i.rv_meaning
                             || ' tariff already existing in GIIS_TARIFF_GROUP.'
                            );
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            INSERT INTO cpi.giis_tariff_group
                        (tariff_cd, tariff_grp_desc, user_id, last_update
                        )
                 VALUES (i.rv_low_value, i.rv_meaning, USER, SYSDATE
                        );

            COMMIT;
            DBMS_OUTPUT.put_line (i.rv_meaning || ' tariff inserted.');
      END;
   END LOOP;
END;