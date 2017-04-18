CREATE OR REPLACE PROCEDURE CPI.compute_depreciation_amounts (
   p_policy_id   IN       gipi_itmperil.policy_id%TYPE,
   p_item_no     IN       gipi_itmperil.item_no%TYPE,
   p_line_cd     IN       giis_line.line_cd%TYPE,
   p_peril_cd    IN       gipi_itmperil.peril_cd%TYPE,
   p_tsi_amt     IN OUT   gipi_itmperil.tsi_amt%TYPE
)
IS
/*
** Created by   : Benjo Brito
** Date Created : 11.24.2016
** Remarks      : Get amounts computed from depreciation rates
*/
   v_round_off      giis_parameters.param_value_n%TYPE;
   v_menu_line_cd   giis_line.menu_line_cd%TYPE;
   v_line_cd_mc     giis_parameters.param_value_v%TYPE := giisp.v ('LINE_CODE_MC');
   v_apply_dep      giis_parameters.param_value_v%TYPE := NVL (giisp.v ('AUTO_COMPUTE_MC_DEP'), 'N');
   v_mc_dep_pct     giis_parameters.param_value_n%TYPE := NVL (giisp.n ('MC_DEP_PCT'), 0);
   v_tsi_amt        gipi_itmperil.tsi_amt%TYPE         := NVL (p_tsi_amt, 0);
BEGIN
   BEGIN
      SELECT DECODE (param_value_n,
                     10, -1,
                     100, -2,
                     1000, -3,
                     10000, -4,
                     100000, -5,
                     1000000, -6,
                     9
                    )
        INTO v_round_off
        FROM giis_parameters
       WHERE param_name = 'ROUND_OFF_PLACE';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_round_off := 9;
   END;

   SELECT menu_line_cd
     INTO v_menu_line_cd
     FROM giis_line
    WHERE line_cd = p_line_cd;

   IF NVL (v_menu_line_cd, p_line_cd) = v_line_cd_mc
   THEN
      IF v_apply_dep = '1'
      THEN
         IF v_mc_dep_pct <> 0
         THEN
            v_tsi_amt := ROUND ((v_tsi_amt - (v_tsi_amt * (v_mc_dep_pct / 100))), v_round_off);
         END IF;
      ELSIF v_apply_dep = '2'
      THEN
         FOR i IN (SELECT NVL (rate, 0) rate
                     FROM giex_dep_perl
                    WHERE line_cd = p_line_cd AND peril_cd = p_peril_cd)
         LOOP
            IF i.rate <> 0
            THEN
               v_tsi_amt := ROUND ((v_tsi_amt - (v_tsi_amt * (i.rate / 100))), v_round_off);
            END IF;
         END LOOP;
      ELSIF v_apply_dep = '3'
      THEN
         FOR i IN (SELECT   NVL (b.rate, 0) rate
                       FROM gipi_vehicle a,
                            giis_mc_dep_rate b,
                            giis_mc_dep_peril c
                      WHERE a.policy_id = p_policy_id
                        AND a.item_no = p_item_no
                        AND a.car_company_cd = b.car_company_cd
                        AND NVL (a.make_cd, 9999) = NVL (b.make_cd, NVL (a.make_cd, 9999))
                        AND NVL (a.series_cd, 9999) = NVL (b.series_cd, NVL (a.series_cd, 9999))
                        AND NVL (a.model_year, 9999) = NVL (b.model_year, NVL (a.model_year, 9999))
                        AND NVL (a.subline_cd, '%^&') = NVL (b.subline_cd, NVL (a.subline_cd, '%^&'))
                        AND NVL (a.subline_type_cd, '%^&') = NVL (b.subline_type_cd, NVL (a.subline_type_cd, '%^&'))
                        AND NVL (b.delete_sw, 'N') <> 'Y'
                        AND b.ID = c.ID
                        AND c.line_cd = p_line_cd
                        AND c.peril_cd = p_peril_cd
                   ORDER BY b.line_cd NULLS LAST,
                            b.subline_cd NULLS LAST,
                            b.car_company_cd NULLS LAST,
                            b.make_cd NULLS LAST,
                            b.series_cd NULLS LAST,
                            b.model_year NULLS LAST,
                            b.subline_type_cd NULLS LAST)
         LOOP
            IF i.rate <> 0
            THEN
               v_tsi_amt := ROUND ((v_tsi_amt - (v_tsi_amt * (i.rate / 100))), v_round_off);
            END IF;

            EXIT;
         END LOOP;
      END IF;
   ELSE
      FOR i IN (SELECT NVL (rate, 0) rate
                  FROM giex_dep_perl
                 WHERE line_cd = p_line_cd AND peril_cd = p_peril_cd)
      LOOP
         IF i.rate <> 0
         THEN
            v_tsi_amt := ROUND ((v_tsi_amt - (v_tsi_amt * (i.rate / 100))), v_round_off);
         END IF;
      END LOOP;
   END IF;

   p_tsi_amt := v_tsi_amt;
END;
/