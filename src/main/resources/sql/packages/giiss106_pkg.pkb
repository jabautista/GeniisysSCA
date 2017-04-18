CREATE OR REPLACE PACKAGE BODY CPI.giiss106_pkg
AS
   /** Created By:     Shan Bati
    ** Date Created:   12.19.2013
    ** Referenced By:  GIISS106 - Maintain Default Peril Rate
    **/
   FUNCTION get_line_lov (p_user_id VARCHAR2)
      RETURN line_tab PIPELINED
   AS
      lov   line_type;
   BEGIN
      FOR i IN (SELECT line_cd, line_name
                  FROM giis_line
                 WHERE check_user_per_iss_cd2 (line_cd,
                                               NULL,
                                               'GIISS106',
                                               p_user_id
                                              ) = 1)
      LOOP
         lov.line_cd := i.line_cd;
         lov.line_name := i.line_name;
         PIPE ROW (lov);
      END LOOP;
   END get_line_lov;

   FUNCTION get_motortype_lov (p_subline_cd VARCHAR2)
      RETURN motortype_tab PIPELINED
   AS
      lov   motortype_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM giis_motortype
                 WHERE subline_cd = p_subline_cd)
      LOOP
         lov.type_cd := i.type_cd;
         lov.motor_type_desc := i.motor_type_desc;
         PIPE ROW (lov);
      END LOOP;
   END get_motortype_lov;

   FUNCTION get_tariff_hdr_list (p_module_id VARCHAR2, p_user_id VARCHAR2)
      RETURN tariff_hdr_tab PIPELINED
   AS
      rec      tariff_hdr_type;
      var_mc   VARCHAR2 (10);
      var_fi   VARCHAR2 (10);
   BEGIN
      SELECT param_value_v
        INTO var_mc
        FROM giis_parameters
       WHERE param_name = 'LINE_CODE_MC';

      SELECT param_value_v
        INTO var_fi
        FROM giis_parameters
       WHERE param_name = 'LINE_CODE_FI';

      FOR i IN (SELECT   *
                    FROM giis_tariff_rates_hdr
                   WHERE check_user_per_iss_cd2 (line_cd,
                                                 NULL,
                                                 p_module_id,
                                                 p_user_id
                                                ) = 1
                ORDER BY tariff_cd, line_cd, subline_cd, peril_cd)
      LOOP
         rec.line_cd := i.line_cd;
         rec.subline_cd := i.subline_cd;
         rec.peril_cd := i.peril_cd;
         rec.subline_type_cd := i.subline_type_cd;
         rec.motortype_cd := i.motortype_cd;
         rec.construction_cd := i.construction_cd;
         rec.coverage_cd := i.coverage_cd;
         rec.tarf_cd := i.tarf_cd;
         rec.tariff_cd := i.tariff_cd;
         rec.tariff_zone := i.tariff_zone;
         rec.default_prem_tag := i.default_prem_tag;
         rec.remarks := i.remarks;
         rec.user_id := i.user_id;
         rec.last_update := TO_CHAR (i.last_update, 'MM-DD-RRRR HH:MI:SS AM');
         rec.motor_type_desc := NULL;
         rec.subline_type_desc := NULL;
         rec.construction_desc := NULL;
         rec.tarf_desc := NULL;

         BEGIN
            SELECT line_name
              INTO rec.line_name
              FROM giis_line
             WHERE line_cd = i.line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               rec.line_name := NULL;
         END;

         BEGIN
            SELECT SUBSTR (subline_name, 1, 30)
              INTO rec.subline_name
              FROM giis_subline
             WHERE line_cd = i.line_cd AND subline_cd = i.subline_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               rec.subline_name := NULL;
         END;

         BEGIN
            SELECT peril_name
              INTO rec.peril_name
              FROM giis_peril
             WHERE line_cd = i.line_cd AND peril_cd = i.peril_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               rec.peril_name := NULL;
         END;

         BEGIN
            SELECT coverage_desc
              INTO rec.coverage_desc
              FROM giis_coverage
             WHERE coverage_cd = i.coverage_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               rec.coverage_desc := NULL;
         END;

         BEGIN
            SELECT tariff_zone_desc
              INTO rec.tariff_zone_desc
              FROM giis_tariff_zone
             WHERE tariff_zone = i.tariff_zone;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               rec.tariff_zone_desc := NULL;
         END;

         IF (i.line_cd = var_mc) AND (NVL (i.motortype_cd, 0) <> 0)
         THEN
            -- motor type cd
            BEGIN
               SELECT motor_type_desc
                 INTO rec.motor_type_desc
                 FROM giis_motortype
                WHERE subline_cd = i.subline_cd AND type_cd = i.motortype_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  rec.motor_type_desc := NULL;
            END;

            -- subline type cd
            BEGIN
               SELECT subline_type_desc
                 INTO rec.subline_type_desc
                 FROM giis_mc_subline_type
                WHERE subline_cd = i.subline_cd
                  AND (   subline_type_cd = i.subline_type_cd
                       OR (    subline_type_cd IS NULL
                           AND i.subline_type_cd IS NULL
                          )
                      );
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  rec.subline_type_desc := NULL;
            END;
         ELSIF i.line_cd = var_fi
         THEN
            -- construction cd
            BEGIN
               SELECT construction_desc
                 INTO rec.construction_desc
                 FROM giis_fire_construction
                WHERE construction_cd = i.construction_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  rec.construction_desc := NULL;
            END;

            -- tarf cd
            BEGIN
               SELECT tarf_desc
                 INTO rec.tarf_desc
                 FROM giis_tariff
                WHERE tarf_cd = i.tarf_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  rec.tarf_desc := NULL;
            END;
         END IF;

         --added by steven 07.01.2014
         rec.rec_exist := 'Y';
         rec.tariff_dtl_cd := NULL;
         rec.si_deductible := NULL;
         rec.fixed_premium := NULL;
         rec.excess_rate := NULL;
         rec.loading_rate := NULL;
         rec.discount_rate := NULL;
         rec.additional_premium := NULL;
         rec.tariff_rate := NULL;
         rec.remarks_2 := NULL;
         rec.user_id_2 := NULL;
         rec.last_update_2 := NULL;

         IF i.default_prem_tag != 1
         THEN
            FOR j IN (SELECT tariff_dtl_cd, si_deductible, fixed_premium,
                             excess_rate, loading_rate, discount_rate,
                             additional_premium, tariff_rate, remarks,
                             user_id, last_update
                        FROM giis_tariff_rates_dtl
                       WHERE tariff_cd = i.tariff_cd)
            LOOP
               rec.tariff_dtl_cd := j.tariff_dtl_cd;
               rec.si_deductible := j.si_deductible;
               rec.fixed_premium := j.fixed_premium;
               rec.excess_rate := j.excess_rate;
               rec.loading_rate := j.loading_rate;
               rec.discount_rate := j.discount_rate;
               rec.additional_premium := j.additional_premium;
               rec.tariff_rate := j.tariff_rate;
               rec.remarks_2 := j.remarks;
               rec.user_id_2 := j.user_id;
               rec.last_update_2 :=
                            TO_CHAR (j.last_update, 'MM-DD-RRRR HH:MI:SS AM');
            END LOOP;
         END IF;

         PIPE ROW (rec);
      END LOOP;
   END get_tariff_hdr_list;

   PROCEDURE val_add_rec_hdr (
      p_line_cd           giis_tariff_rates_hdr.line_cd%TYPE,
      p_subline_cd        giis_tariff_rates_hdr.subline_cd%TYPE,
      p_peril_cd          giis_tariff_rates_hdr.peril_cd%TYPE,
      p_tariff_zone       giis_tariff_rates_hdr.tariff_zone%TYPE,
      p_coverage_cd       giis_tariff_rates_hdr.coverage_cd%TYPE,
      p_subline_type_cd   giis_tariff_rates_hdr.subline_type_cd%TYPE,
      p_motortype_cd      giis_tariff_rates_hdr.motortype_cd%TYPE,
      p_tarf_cd           giis_tariff_rates_hdr.tarf_cd%TYPE,
      p_construction_cd   giis_tariff_rates_hdr.construction_cd%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
      var_mc     giis_parameters.param_value_v%TYPE;
      var_fi     giis_parameters.param_value_v%TYPE;
   BEGIN
      SELECT param_value_v
        INTO var_mc
        FROM giis_parameters
       WHERE param_name = 'LINE_CODE_MC';

      SELECT param_value_v
        INTO var_fi
        FROM giis_parameters
       WHERE param_name = 'LINE_CODE_FI';

      FOR i IN (SELECT '1'
                  FROM giis_tariff_rates_hdr
                 WHERE line_cd = p_line_cd
                   AND subline_cd = p_subline_cd
                   AND peril_cd = p_peril_cd
                   AND NVL (subline_type_cd, '{') =
                                                  NVL (p_subline_type_cd, '{')
                   AND NVL (motortype_cd, 7897) = NVL (p_motortype_cd, 7897)
                   AND NVL (tarf_cd, '{') = NVL (p_tarf_cd, '{')
                   AND NVL (construction_cd, '{') =
                                                  NVL (p_construction_cd, '{')
                   AND NVL (tariff_zone, '{') = NVL (p_tariff_zone, '{')
                   AND NVL (coverage_cd, 7897) = NVL (p_coverage_cd, 7897))
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         IF p_line_cd = var_mc
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Record already exists, i.e, line code, subline code, peril code, subline type code, 
                                                    motortype code, tariff zone, and coverage code are, in aggregate, existing.'
               );
         ELSIF p_line_cd = var_fi
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Record already exists, i.e, line code, subline code, peril code, tariff code, 
                                                    construction code, tariff zone, and coverage code are, in aggregate, existing.'
               );
         ELSE
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Record already exists, i.e, line code, subline code, peril code, tariff zone, 
                                                    and coverage code are, in aggregate, existing.'
               );
         END IF;
      END IF;
   END val_add_rec_hdr;

   PROCEDURE val_del_rec_hdr (
      p_tariff_cd   giis_tariff_rates_hdr.tariff_cd%TYPE
   )
   AS
      v_exists      VARCHAR2 (1);
      v_tag_exist   VARCHAR2 (1);
   BEGIN
      FOR h IN (SELECT default_prem_tag
                  FROM giis_tariff_rates_hdr
                 WHERE tariff_cd = p_tariff_cd AND default_prem_tag = 1)
      LOOP
         v_tag_exist := 'Y';
         EXIT;
      END LOOP;

      IF v_tag_exist = 'Y'
      THEN
         FOR i IN (SELECT '1'
                     FROM giis_tariff_rates_dtl
                    WHERE tariff_cd = p_tariff_cd)
         LOOP
            v_exists := 'Y';
            EXIT;
         END LOOP;

         IF v_exists = 'Y'
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Cannot delete record from GIIS_TARIFF_RATES_HDR while dependent record(s) in GIIS_TARIFF_RATES_DTL exists.'
               );
         END IF;
      END IF;
   END val_del_rec_hdr;

   PROCEDURE set_rec_hdr (
      p_tariff_cd            IN OUT   giis_tariff_rates_hdr.tariff_cd%TYPE,
      p_line_cd              IN       giis_tariff_rates_hdr.line_cd%TYPE,
      p_subline_cd           IN       giis_tariff_rates_hdr.subline_cd%TYPE,
      p_peril_cd             IN       giis_tariff_rates_hdr.peril_cd%TYPE,
      p_tariff_zone          IN       giis_tariff_rates_hdr.tariff_zone%TYPE,
      p_coverage_cd          IN       giis_tariff_rates_hdr.coverage_cd%TYPE,
      p_subline_type_cd      IN       giis_tariff_rates_hdr.subline_type_cd%TYPE,
      p_motortype_cd         IN       giis_tariff_rates_hdr.motortype_cd%TYPE,
      p_tarf_cd              IN       giis_tariff_rates_hdr.tarf_cd%TYPE,
      p_construction_cd      IN       giis_tariff_rates_hdr.construction_cd%TYPE,
      p_default_prem_tag     IN       giis_tariff_rates_hdr.default_prem_tag%TYPE,
      p_remarks              IN       giis_tariff_rates_hdr.remarks%TYPE,
      p_user_id              IN       giis_tariff_rates_hdr.user_id%TYPE,
      p_remarks2             IN       giis_tariff_rates_dtl.remarks%TYPE,
      p_fixed_premium        IN       giis_tariff_rates_dtl.fixed_premium%TYPE,
      p_si_deductible        IN       giis_tariff_rates_dtl.si_deductible%TYPE,
      p_excess_rate          IN       giis_tariff_rates_dtl.excess_rate%TYPE,
      p_loading_rate         IN       giis_tariff_rates_dtl.loading_rate%TYPE,
      p_discount_rate        IN       giis_tariff_rates_dtl.discount_rate%TYPE,
      p_tariff_rate          IN       giis_tariff_rates_dtl.tariff_rate%TYPE,
      p_additional_premium   IN       giis_tariff_rates_dtl.additional_premium%TYPE,
      p_tariff_dtl_cd        IN OUT   giis_tariff_rates_dtl.tariff_dtl_cd%TYPE
   )
   AS
   BEGIN
      IF p_tariff_cd IS NULL
      THEN
         FOR i IN (SELECT tariff_cd_s.NEXTVAL code
                     FROM SYS.DUAL)
         LOOP
            p_tariff_cd := i.code;
         END LOOP;
      END IF;

      MERGE INTO giis_tariff_rates_hdr
         USING DUAL
         ON (tariff_cd = p_tariff_cd)
         WHEN NOT MATCHED THEN
            INSERT (tariff_cd, line_cd, subline_cd, peril_cd, tariff_zone,
                    coverage_cd, subline_type_cd, motortype_cd, tarf_cd,
                    construction_cd, default_prem_tag, remarks, user_id,
                    last_update)
            VALUES (p_tariff_cd, p_line_cd, p_subline_cd, p_peril_cd,
                    p_tariff_zone, p_coverage_cd, p_subline_type_cd,
                    p_motortype_cd, p_tarf_cd, p_construction_cd,
                    p_default_prem_tag, p_remarks, p_user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET line_cd = p_line_cd, subline_cd = p_subline_cd,
                   peril_cd = p_peril_cd, tariff_zone = p_tariff_zone,
                   coverage_cd = p_coverage_cd,
                   subline_type_cd = p_subline_type_cd,
                   motortype_cd = p_motortype_cd, tarf_cd = p_tarf_cd,
                   construction_cd = p_construction_cd,
                   default_prem_tag = p_default_prem_tag, remarks = p_remarks,
                   user_id = p_user_id, last_update = SYSDATE
            ;

      IF    p_remarks2 IS NOT NULL
         OR p_fixed_premium IS NOT NULL
         OR p_si_deductible IS NOT NULL
         OR p_excess_rate IS NOT NULL
         OR p_loading_rate IS NOT NULL
         OR p_discount_rate IS NOT NULL
         OR p_tariff_rate IS NOT NULL
         OR p_additional_premium IS NOT NULL
         OR p_tariff_dtl_cd IS NOT NULL
      THEN
         IF p_tariff_dtl_cd IS NULL
         THEN
            FOR i IN (SELECT NVL (MAX (tariff_dtl_cd), 0) + 1 code
                        FROM giis_tariff_rates_dtl
                       WHERE tariff_cd = p_tariff_cd)
            LOOP
               p_tariff_dtl_cd := i.code;
            END LOOP;
         END IF;

         MERGE INTO giis_tariff_rates_dtl
            USING DUAL
            ON (tariff_cd = p_tariff_cd AND tariff_dtl_cd = p_tariff_dtl_cd)
            WHEN NOT MATCHED THEN
               INSERT (tariff_cd, tariff_dtl_cd, fixed_premium, si_deductible,
                       excess_rate, loading_rate, discount_rate, tariff_rate,
                       additional_premium, remarks, user_id, last_update)
               VALUES (p_tariff_cd, p_tariff_dtl_cd, p_fixed_premium,
                       p_si_deductible, p_excess_rate, p_loading_rate,
                       p_discount_rate, p_tariff_rate, p_additional_premium,
                       p_remarks2, p_user_id, SYSDATE)
            WHEN MATCHED THEN
               UPDATE
                  SET fixed_premium = p_fixed_premium,
                      si_deductible = p_si_deductible,
                      excess_rate = p_excess_rate,
                      loading_rate = p_loading_rate,
                      discount_rate = p_discount_rate,
                      tariff_rate = p_tariff_rate,
                      additional_premium = p_additional_premium,
                      remarks = p_remarks2, user_id = p_user_id,
                      last_update = SYSDATE
               ;
      END IF;
   END set_rec_hdr;

   PROCEDURE del_rec_hdr (p_tariff_cd giis_tariff_rates_hdr.tariff_cd%TYPE)
   AS
   BEGIN
      DELETE FROM giis_tariff_rates_dtl
            WHERE tariff_cd = p_tariff_cd;

      DELETE FROM giis_tariff_rates_hdr
            WHERE tariff_cd = p_tariff_cd;
   END del_rec_hdr;

   FUNCTION get_fixed_si_list (
      p_tariff_cd   giis_tariff_rates_hdr.tariff_cd%TYPE
   )
      RETURN tariff_fixed_si_tab PIPELINED
   AS
      rec   tariff_fixed_si_type;
   BEGIN
      FOR i IN (SELECT   *
                    FROM giis_tariff_rates_dtl
                   WHERE tariff_cd = p_tariff_cd
                ORDER BY fixed_si)
      LOOP
         rec.tariff_cd := i.tariff_cd;
         rec.tariff_dtl_cd := i.tariff_dtl_cd;
         rec.fixed_si := i.fixed_si;
         rec.fixed_premium := i.fixed_premium;
         rec.higher_range := i.higher_range;
         rec.lower_range := i.lower_range;
         rec.remarks := i.remarks;
         rec.user_id := i.user_id;
         rec.last_update := TO_CHAR (i.last_update, 'MM-DD-RRRR HH:MI:SS AM');
         PIPE ROW (rec);
      END LOOP;
   END get_fixed_si_list;

   FUNCTION get_with_comp_dtl (
      p_tariff_cd   giis_tariff_rates_hdr.tariff_cd%TYPE
   )
      RETURN tariff_with_comp_tab PIPELINED
   AS
      rec   tariff_with_comp_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM giis_tariff_rates_dtl
                 WHERE tariff_cd = p_tariff_cd)
      LOOP
         rec.tariff_cd := i.tariff_cd;
         rec.tariff_dtl_cd := i.tariff_dtl_cd;
         rec.fixed_premium := i.fixed_premium;
         rec.si_deductible := i.si_deductible;
         rec.excess_rate := i.excess_rate;
         rec.loading_rate := i.loading_rate;
         rec.discount_rate := i.discount_rate;
         rec.additional_premium := i.additional_premium;
         rec.tariff_rate := i.tariff_rate;
         rec.remarks := i.remarks;
         rec.user_id := i.user_id;
         rec.last_update := TO_CHAR (i.last_update, 'MM-DD-RRRR HH:MI:SS AM');
         PIPE ROW (rec);
         EXIT;
      END LOOP;
   END get_with_comp_dtl;

   PROCEDURE val_add_fixed_si_rec (
      p_tariff_cd       giis_tariff_rates_dtl.tariff_cd%TYPE,
      p_tariff_dtl_cd   giis_tariff_rates_dtl.tariff_dtl_cd%TYPE,
      p_fixed_si        giis_tariff_rates_dtl.fixed_si%TYPE
   )
   AS
      v_exist1   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_tariff_rates_dtl
                 WHERE tariff_cd = p_tariff_cd
                   AND tariff_dtl_cd = p_tariff_dtl_cd
                   AND fixed_si = p_fixed_si)
      LOOP
         v_exist1 := 'Y';
         EXIT;
      END LOOP;

      IF v_exist1 = 'Y'
      THEN
         raise_application_error
                    (-20001,
                     'Geniisys Exception#E#Fixed Sum Insured already exists.'
                    );
      END IF;
   END val_add_fixed_si_rec;

   FUNCTION get_fixed_prem_dtl (
      p_tariff_cd   giis_tariff_rates_hdr.tariff_cd%TYPE
   )
      RETURN tariff_fixed_prem_tab PIPELINED
   AS
      rec   tariff_fixed_prem_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM giis_tariff_rates_dtl
                 WHERE tariff_cd = p_tariff_cd)
      LOOP
         rec.tariff_cd := i.tariff_cd;
         rec.tariff_dtl_cd := i.tariff_dtl_cd;
         rec.fixed_premium := i.fixed_premium;
         rec.tariff_rate := i.tariff_rate;
         rec.remarks := i.remarks;
         rec.user_id := i.user_id;
         rec.last_update := TO_CHAR (i.last_update, 'MM-DD-RRRR HH:MI:SS AM');
         PIPE ROW (rec);
         EXIT;
      END LOOP;
   END get_fixed_prem_dtl;

   PROCEDURE set_rec_dtl (p_rec giis_tariff_rates_dtl%ROWTYPE)
   AS
   v_tariff_dtl_cd giis_tariff_rates_dtl.tariff_dtl_cd%TYPE := p_rec.tariff_dtl_cd;
   BEGIN
      IF p_rec.tariff_dtl_cd IS NULL
      THEN
         FOR i IN (SELECT NVL (MAX (tariff_dtl_cd), 0) + 1 code
                     FROM giis_tariff_rates_dtl
                    WHERE tariff_cd = p_rec.tariff_cd)
         LOOP
            v_tariff_dtl_cd := i.code;
         END LOOP;
      END IF;

      MERGE INTO giis_tariff_rates_dtl
         USING DUAL
         ON (    tariff_cd = p_rec.tariff_cd
             AND tariff_dtl_cd = p_rec.tariff_dtl_cd)
         WHEN NOT MATCHED THEN
            INSERT (tariff_cd, tariff_dtl_cd, fixed_premium, fixed_si,
                    higher_range, lower_range, si_deductible, excess_rate,
                    loading_rate, discount_rate, tariff_rate,
                    additional_premium, remarks, user_id, last_update)
            VALUES (p_rec.tariff_cd, v_tariff_dtl_cd, p_rec.fixed_premium,
                    p_rec.fixed_si, p_rec.higher_range, p_rec.lower_range,
                    p_rec.si_deductible, p_rec.excess_rate,
                    p_rec.loading_rate, p_rec.discount_rate,
                    p_rec.tariff_rate, p_rec.additional_premium,
                    p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET fixed_premium = p_rec.fixed_premium,
                   fixed_si = p_rec.fixed_si,
                   higher_range = p_rec.higher_range,
                   lower_range = p_rec.lower_range,
                   si_deductible = p_rec.si_deductible,
                   excess_rate = p_rec.excess_rate,
                   loading_rate = p_rec.loading_rate,
                   discount_rate = p_rec.discount_rate,
                   tariff_rate = p_rec.tariff_rate,
                   additional_premium = p_rec.additional_premium,
                   remarks = p_rec.remarks, user_id = p_rec.user_id,
                   last_update = SYSDATE
            ;
   END set_rec_dtl;

   PROCEDURE del_rec_dtl (
      p_tariff_cd       giis_tariff_rates_dtl.tariff_cd%TYPE,
      p_tariff_dtl_cd   giis_tariff_rates_dtl.tariff_dtl_cd%TYPE
   )
   AS
   BEGIN
      DELETE FROM giis_tariff_rates_dtl
            WHERE tariff_cd = p_tariff_cd AND tariff_dtl_cd = p_tariff_dtl_cd;
   END del_rec_dtl;

   PROCEDURE val_add_rec_dtl (
      p_tariff_cd            giis_tariff_rates_dtl.tariff_cd%TYPE,
      p_higher_range         giis_tariff_rates_dtl.higher_range%TYPE,
      p_lower_range          giis_tariff_rates_dtl.lower_range%TYPE,
      p_tariff_rate          giis_tariff_rates_dtl.tariff_rate%TYPE,
      p_additional_premium   giis_tariff_rates_dtl.additional_premium%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_tariff_rates_dtl
                 WHERE tariff_cd = p_tariff_cd
                   AND higher_range = p_higher_range
                   AND lower_range = p_lower_range
                   AND tariff_rate = p_tariff_rate
                   AND additional_premium = p_additional_premium)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Row already exists with same tariff_cd, tariff_rate and additional_premium.'
            );
      END IF;
   END val_add_rec_dtl;
END giiss106_pkg;
/


