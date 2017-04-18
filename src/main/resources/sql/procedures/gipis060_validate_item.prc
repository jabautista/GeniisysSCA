DROP PROCEDURE CPI.GIPIS060_VALIDATE_ITEM;

CREATE OR REPLACE PROCEDURE CPI.gipis060_validate_item (
   p_par_id                    gipi_wpolbas.par_id%TYPE,
   p_item_no                   gipi_witem.item_no%TYPE,
   p_back_endt                 VARCHAR2,
   p_endt_item_details   OUT   gipis039_ref_cursor_pkg.rc_endt_mc_item,
   p_message             OUT   VARCHAR2
)
AS
   v_line_cd                  gipi_wpolbas.line_cd%TYPE;
   v_subline_cd               gipi_wpolbas.subline_cd%TYPE;
   v_iss_cd                   gipi_wpolbas.iss_cd%TYPE;
   v_issue_yy                 gipi_wpolbas.issue_yy%TYPE;
   v_pol_seq_no               gipi_wpolbas.pol_seq_no%TYPE;
   v_renew_no                 gipi_wpolbas.renew_no%TYPE;
   v_eff_date                 gipi_wpolbas.eff_date%TYPE;
   v_expiry_date              gipi_wpolbas.expiry_date%TYPE;
   v_expiry_date1             gipi_wpolbas.expiry_date%TYPE
                                                 := extract_expiry (p_par_id);
   v_pack_line_cd             gipi_pack_line_subline.pack_line_cd%TYPE;
   v_pack_subline_cd          gipi_pack_line_subline.pack_subline_cd%TYPE;
   --
   b480ann_tsi_amt            gipi_witem.ann_tsi_amt%TYPE;
   b480ann_prem_amt           gipi_witem.ann_prem_amt%TYPE;
   b480currency_cd            gipi_witem.currency_cd%TYPE;
   b480currency_rt            gipi_witem.currency_rt%TYPE;
   b480item_title             gipi_witem.item_title%TYPE;
   b480coverage_cd            gipi_witem.coverage_cd%TYPE;
   b480group_cd               gipi_witem.group_cd%TYPE;
   b480dsp_group_desc         giis_group.group_desc%TYPE;
   b480dsp_currency_desc      giis_currency.currency_desc%TYPE;
   b480dsp_short_name         giis_currency.short_name%TYPE;
   b480dsp_coverage_desc      giis_coverage.coverage_desc%TYPE;
   b480rec_flag               gipi_witem.rec_flag%TYPE;
   b480region_cd              gipi_witem.region_cd%TYPE;
   b480dsp_region_desc        giis_region.region_desc%TYPE;
   --
   b580_subline_cd            gipi_wvehicle.subline_cd%TYPE;
   b580_motor_coverage        gipi_wvehicle.motor_coverage%TYPE;
   b580_motor_coverage_desc   cg_ref_codes.rv_meaning%TYPE;
   b580_assignee              gipi_wvehicle.assignee%TYPE;
   b580_origin                gipi_wvehicle.origin%TYPE;
   b580_plate_no              gipi_wvehicle.plate_no%TYPE;
   b580_mv_file_no            gipi_wvehicle.mv_file_no%TYPE;
   b580_basic_color_cd        gipi_wvehicle.basic_color_cd%TYPE;
   b580_mot_type              gipi_wvehicle.mot_type%TYPE;
   b580_motor_type_desc       giis_motortype.motor_type_desc%TYPE;
   b580_serial_no             gipi_wvehicle.serial_no%TYPE;
   b580_coc_type              gipi_wvehicle.coc_type%TYPE;
   b580_coc_yy                gipi_wvehicle.coc_yy%TYPE;
   b580_coc_serial_no         gipi_wvehicle.coc_serial_no%TYPE;
   b580_acquired_from         gipi_wvehicle.acquired_from%TYPE;
   b580_destination           gipi_wvehicle.destination%TYPE;
   b580_model_year            gipi_wvehicle.model_year%TYPE;
   b580_no_of_pass            gipi_wvehicle.no_of_pass%TYPE;
   b580_color_cd              gipi_wvehicle.color_cd%TYPE;
   b580_color                 gipi_wvehicle.color%TYPE;
   b580_unladen_wt            gipi_wvehicle.unladen_wt%TYPE;
   b580_subline_type_cd       giis_mc_subline_type.subline_type_cd%TYPE;
   b580_subline_type_desc     giis_mc_subline_type.subline_type_desc%TYPE;
   b580_motor_no              gipi_wvehicle.motor_no%TYPE;
   b580_type_of_body_cd       gipi_wvehicle.type_of_body_cd%TYPE;
   b580_car_company_cd        gipi_wvehicle.car_company_cd%TYPE;
   b580_car_company           giis_mc_car_company.car_company%TYPE;
   b580_make                  gipi_wvehicle.make%TYPE;
   b580_make_cd               gipi_wvehicle.make_cd%TYPE;
   b580_series_cd             gipi_wvehicle.series_cd%TYPE;
   b580_towing                gipi_wvehicle.towing%TYPE;
   b580_repair_lim            gipi_wvehicle.repair_lim%TYPE;
   --
   b540nbt_policy_id          gipi_polbasic.policy_id%TYPE;
   b240nbt_subline_cd         giis_parameters.param_value_v%TYPE;
   b580towing                 gipi_wvehicle.towing%TYPE;
   b580repair_lim             gipi_wvehicle.repair_lim%TYPE;
BEGIN
   FOR i IN (SELECT pack_line_cd, pack_subline_cd
               FROM gipi_wpack_line_subline
              WHERE par_id = p_par_id)
   LOOP
      v_pack_line_cd := i.pack_line_cd;
      v_pack_subline_cd := i.pack_subline_cd;
      EXIT;
   END LOOP;

   --extract_expiry;
   SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
          renew_no, eff_date, expiry_date
     INTO v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no,
          v_renew_no, v_eff_date, v_expiry_date
     FROM gipi_wpolbas
    WHERE par_id = p_par_id;

--ASI 071299 For Backward Endorsement and item that will be changed check first if
--           particular item had been endorsed during previous endorsement and warn
--           the user that the item will affect other posted endorsements
   IF p_back_endt = 'Y'
   THEN
      FOR pol IN (SELECT   b250.policy_id
                      FROM gipi_polbasic b250
                     WHERE b250.line_cd = v_line_cd
                       AND b250.subline_cd = v_subline_cd
                       AND b250.iss_cd = v_iss_cd
                       AND b250.issue_yy = v_issue_yy
                       AND b250.pol_seq_no = v_pol_seq_no
                       AND b250.renew_no = v_renew_no
                       AND TRUNC (b250.eff_date) > TRUNC (v_eff_date)
                       AND b250.endt_seq_no > 0
                       -- lian 111501 added pol_flag = 'X'
                       AND b250.pol_flag IN ('1', '2', '3', 'X')
                       --AND NVL(b250.endt_expiry_date,b250.expiry_date) >=  v_eff_date
                       AND TRUNC (DECODE (NVL (b250.endt_expiry_date,
                                               b250.expiry_date
                                              ),
                                          b250.expiry_date, v_expiry_date,
                                          b250.endt_expiry_date
                                         )
                                 ) >= TRUNC (v_eff_date)
                       AND EXISTS (
                              SELECT '1'
                                FROM gipi_item b340
                               WHERE b340.item_no = p_item_no
                                 AND b340.policy_id = b250.policy_id)
                  ORDER BY b250.eff_date DESC)
      LOOP
         p_message :=
               'This is a backward endorsement, any changes made in this item will affect '
            || 'all previous endorsement that has an effectivity date later than '
            || TO_CHAR (v_eff_date, 'fmMonth DD, YYYY')
            || ' .';
         EXIT;
      END LOOP;
   END IF;

/* Created by     :      ORACLE                     */
/* CGUV$CHK_KEYS_ON_VAL_FLD                         */
/* Check item value against unique or primary key   */
/* Updated by     : Daphne                          */
/* Update date    : 07/03/97                        */
/* Updated by     : Vida                            */
/* Added for validation of existing or non-existing */
/* items in the original policy.                    */
   DECLARE
      p_eff_date           gipi_polbasic.eff_date%TYPE;
      v_max_endt_seq_no    gipi_polbasic.endt_seq_no%TYPE;
      v_max_endt_seq_no1   gipi_polbasic.endt_seq_no%TYPE;

      CURSOR a
      IS
         SELECT   a.policy_id policy_id, a.eff_date eff_date
             FROM gipi_polbasic a
            WHERE a.line_cd = v_line_cd
              AND a.iss_cd = v_iss_cd
              AND a.subline_cd = v_subline_cd
              AND a.issue_yy = v_issue_yy
              AND a.pol_seq_no = v_pol_seq_no
              AND a.renew_no = v_renew_no
              -- lian 111501 added pol_flag = 'X'
              AND a.pol_flag IN ('1', '2', '3', 'X')
              AND TRUNC (NVL (a.endt_expiry_date, a.expiry_date)) >=
                                                            TRUNC (v_eff_date)
              --ASI 081299 add this validation so that data that will be retrieved
              --           is only those from endorsement prior to the current endorsement
              --           this was consider because of the backward endorsement
              AND TRUNC (a.eff_date) <=
                     DECODE (NVL (a.endt_seq_no, 0),
                             0, TRUNC (a.eff_date),
                             TRUNC (v_eff_date)
                            )
              AND EXISTS (
                     SELECT '1'
                       FROM gipi_item b
                      WHERE b.item_no = p_item_no
                            AND b.policy_id = a.policy_id)
         ORDER BY eff_date DESC;

      CURSOR b (p_policy_id gipi_item.policy_id%TYPE)
      IS
         SELECT currency_cd, currency_rt, item_title, ann_tsi_amt,
                ann_prem_amt, coverage_cd, group_cd
           FROM gipi_item
          WHERE policy_id = p_policy_id AND item_no = p_item_no;

      CURSOR c (p_currency_cd giis_currency.main_currency_cd%TYPE)
      IS
         SELECT currency_desc, currency_rt, short_name
           FROM giis_currency
          WHERE main_currency_cd = p_currency_cd;

      CURSOR d
      IS
         SELECT   a.policy_id policy_id, a.eff_date eff_date
             FROM gipi_polbasic a
            WHERE a.line_cd = v_line_cd
              AND a.iss_cd = v_iss_cd
              AND a.subline_cd = v_subline_cd
              AND a.issue_yy = v_issue_yy
              AND a.pol_seq_no = v_pol_seq_no
              AND a.renew_no = v_renew_no
              -- lian 111501 added pol_flag = 'X'
              AND a.pol_flag IN ('1', '2', '3', 'X')
              --ASI 081299 add this validation so that data that will be retrieved
              --           is only those from endorsement prior to the current endorsement
              --           this was consider because of the backward endorsement
              AND TRUNC (a.eff_date) <=
                     DECODE (NVL (a.endt_seq_no, 0),
                             0, TRUNC (a.eff_date),
                             TRUNC (v_eff_date)
                            )
              --AND    NVL(a.endt_expiry_date,a.expiry_date) >=  v_eff_date
              AND TRUNC (DECODE (NVL (a.endt_expiry_date, a.expiry_date),
                                 a.expiry_date, v_expiry_date,
                                 a.endt_expiry_date
                                )
                        ) >= TRUNC (v_eff_date)
              AND NVL (a.back_stat, 5) = 2
              AND EXISTS (
                     SELECT '1'
                       FROM gipi_item b
                      WHERE b.item_no = p_item_no
                            AND a.policy_id = b.policy_id)
              AND a.endt_seq_no =
                     (SELECT MAX (endt_seq_no)
                        FROM gipi_polbasic c
                       WHERE line_cd = v_line_cd
                         AND iss_cd = v_iss_cd
                         AND subline_cd = v_subline_cd
                         AND issue_yy = v_issue_yy
                         AND pol_seq_no = v_pol_seq_no
                         AND renew_no = v_renew_no
                         -- lian 111501 added pol_flag = 'X'
                         AND pol_flag IN ('1', '2', '3', 'X')
                         AND TRUNC (eff_date) <=
                                DECODE (NVL (c.endt_seq_no, 0),
                                        0, TRUNC (c.eff_date),
                                        TRUNC (v_eff_date)
                                       )
                         --AND NVL(endt_expiry_date,expiry_date) >=  v_eff_date
                         AND TRUNC (DECODE (NVL (c.endt_expiry_date,
                                                 c.expiry_date
                                                ),
                                            c.expiry_date, v_expiry_date,
                                            c.endt_expiry_date
                                           )
                                   ) >= TRUNC (v_eff_date)
                         AND NVL (c.back_stat, 5) = 2
                         AND EXISTS (
                                SELECT '1'
                                  FROM gipi_item d
                                 WHERE d.item_no = p_item_no
                                   AND c.policy_id = d.policy_id))
         ORDER BY eff_date DESC;

      v_new_item           VARCHAR2 (1)                     := 'Y';
      expired_sw           VARCHAR2 (1)                     := 'N';
      amt_sw               VARCHAR2 (1)                     := 'N';
   BEGIN
--      CLEAR_MESSAGE;
--      MESSAGE ('Searching..', no_acknowledge);
--      SYNCHRONIZE;
      FOR z IN (SELECT MAX (endt_seq_no) endt_seq_no
                  FROM gipi_polbasic a
                 WHERE line_cd = v_line_cd
                   AND iss_cd = v_iss_cd
                   AND subline_cd = v_subline_cd
                   AND issue_yy = v_issue_yy
                   AND pol_seq_no = v_pol_seq_no
                   AND renew_no = v_renew_no
                   -- lian 111501 added pol_flag = 'X'
                   AND pol_flag IN ('1', '2', '3', 'X')
                   AND TRUNC (eff_date) <=
                          DECODE (NVL (a.endt_seq_no, 0),
                                  0, TRUNC (a.eff_date),
                                  TRUNC (v_eff_date)
                                 )
                   -- AND NVL(endt_expiry_date,expiry_date) >=  v_eff_date
                   AND TRUNC (DECODE (NVL (a.endt_expiry_date, a.expiry_date),
                                      a.expiry_date, v_expiry_date,
                                      a.endt_expiry_date
                                     )
                             ) >= TRUNC (v_eff_date)
                   AND EXISTS (
                          SELECT '1'
                            FROM gipi_item b
                           WHERE b.item_no = p_item_no
                             AND a.policy_id = b.policy_id))
      LOOP
         v_max_endt_seq_no := z.endt_seq_no;
         EXIT;
      END LOOP;

      FOR x IN (SELECT MAX (endt_seq_no) endt_seq_no
                  FROM gipi_polbasic a
                 WHERE line_cd = v_line_cd
                   AND iss_cd = v_iss_cd
                   AND subline_cd = v_subline_cd
                   AND issue_yy = v_issue_yy
                   AND pol_seq_no = v_pol_seq_no
                   AND renew_no = v_renew_no
                   -- lian 111501 added pol_flag = 'X'
                   AND pol_flag IN ('1', '2', '3', 'X')
                   AND TRUNC (eff_date) <= TRUNC (v_eff_date)
                   --AND NVL(endt_expiry_date,expiry_date) >=  v_eff_date
                   AND TRUNC (DECODE (NVL (a.endt_expiry_date, a.expiry_date),
                                      a.expiry_date, v_expiry_date,
                                      a.endt_expiry_date
                                     )
                             ) >= TRUNC (v_eff_date)
                   AND NVL (a.back_stat, 5) = 2
                   AND EXISTS (
                          SELECT '1'
                            FROM gipi_item b
                           WHERE b.item_no = p_item_no
                             AND a.policy_id = b.policy_id))
      LOOP
         v_max_endt_seq_no1 := x.endt_seq_no;
         EXIT;
      END LOOP;

      --BETH 02192001 latest amount for item should be retrieved from the latest endt record
      --     (depending on PAR eff_date).For policy w/out endt. yet then amounts will be the
      --     amount of policy. For policy with short term endt. amount should be recomputed by
      --     adding all amounts of policy and endt. that is not yet reversed
      expired_sw := 'N';

      -- check for the existance of short-term endt
      FOR sw IN (SELECT   '1'
                     FROM gipi_itmperil a, gipi_polbasic b
                    WHERE b.line_cd = v_line_cd
                      AND b.subline_cd = v_subline_cd
                      AND b.iss_cd = v_iss_cd
                      AND b.issue_yy = v_issue_yy
                      AND b.pol_seq_no = v_pol_seq_no
                      AND b.renew_no = v_renew_no
                      AND b.policy_id = a.policy_id
                      -- lian 111501 added pol_flag = 'X'
                      AND b.pol_flag IN ('1', '2', '3', 'X')
                      AND (a.prem_amt <> 0 OR a.tsi_amt <> 0)
                      AND a.item_no = p_item_no
                      AND TRUNC (b.eff_date) <=
                             DECODE (NVL (b.endt_seq_no, 0),
                                     0, TRUNC (b.eff_date),
                                     TRUNC (v_eff_date)
                                    )
                      --AND TRUNC(NVL(B.endt_expiry_date,B.expiry_date)) < TRUNC(v_eff_date)
                      --AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date),
                      --      b.expiry_date,:b540.expiry_date,b.endt_expiry_date))
                      --      < TRUNC(v_eff_date)
                      AND TRUNC (DECODE (NVL (b.endt_expiry_date,
                                              b.expiry_date
                                             ),
                                         b.expiry_date, v_expiry_date1,
                                         b.expiry_date, b.endt_expiry_date
                                        )
                                ) < TRUNC (v_eff_date)
                 ORDER BY b.eff_date DESC)
      LOOP
         expired_sw := 'Y';
         EXIT;
      END LOOP;

      amt_sw := 'N';

      IF expired_sw = 'N'
      THEN
         --get amount from the latest endt
         FOR endt IN (SELECT   a.ann_tsi_amt, a.ann_prem_amt
                          FROM gipi_item a, gipi_polbasic b
                         WHERE b.line_cd = v_line_cd
                           AND b.subline_cd = v_subline_cd
                           AND b.iss_cd = v_iss_cd
                           AND b.issue_yy = v_issue_yy
                           AND b.pol_seq_no = v_pol_seq_no
                           AND b.renew_no = v_renew_no
                           AND b.policy_id = a.policy_id
                           -- lian 111501 added pol_flag = 'X'
                           AND b.pol_flag IN ('1', '2', '3', 'X')
                           AND a.item_no = p_item_no
                           AND TRUNC (b.eff_date) <= TRUNC (v_eff_date)
                           --AND NVL(B.endt_expiry_date,B.expiry_date) >= v_eff_date
                           --AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date),
                           --      b.expiry_date,:b540.expiry_date,b.endt_expiry_date))
                           --     >= v_eff_date
                           AND TRUNC (DECODE (NVL (b.endt_expiry_date,
                                                   b.expiry_date
                                                  ),
                                              b.expiry_date, v_expiry_date1,
                                              b.expiry_date, b.endt_expiry_date
                                             )
                                     ) >= v_eff_date
                           AND NVL (b.endt_seq_no, 0) > 0
                      -- to query records from endt. only
                      ORDER BY b.eff_date DESC)
         LOOP
            b480ann_tsi_amt := endt.ann_tsi_amt;
            b480ann_prem_amt := endt.ann_prem_amt;
            amt_sw := 'Y';
            EXIT;
         END LOOP;

         --no endt. records found, retrieved amounts from the policy
         IF amt_sw = 'N'
         THEN
            FOR pol IN (SELECT a.ann_tsi_amt, a.ann_prem_amt
                          FROM gipi_item a, gipi_polbasic b
                         WHERE b.line_cd = v_line_cd
                           AND b.subline_cd = v_subline_cd
                           AND b.iss_cd = v_iss_cd
                           AND b.issue_yy = v_issue_yy
                           AND b.pol_seq_no = v_pol_seq_no
                           AND b.renew_no = v_renew_no
                           AND b.policy_id = a.policy_id
                           -- lian 111501 added pol_flag = 'X'
                           AND b.pol_flag IN ('1', '2', '3', 'X')
                           AND a.item_no = p_item_no
                           AND NVL (b.endt_seq_no, 0) = 0)
            LOOP
               b480ann_tsi_amt := pol.ann_tsi_amt;
               b480ann_prem_amt := pol.ann_prem_amt;
               EXIT;
            END LOOP;
         END IF;
      ELSE
         extract_ann_amt2 (v_line_cd,
                           v_subline_cd,
                           v_iss_cd,
                           v_issue_yy,
                           v_pol_seq_no,
                           v_renew_no,
                           v_eff_date,
                           p_item_no,
                           b480ann_prem_amt,
                           b480ann_tsi_amt
                          );
--         extract_ann_amt2 (p_item_no,
--                           b480ann_prem_amt,
--                           b480ann_tsi_amt
--                          );
      END IF;

      IF v_max_endt_seq_no = v_max_endt_seq_no1
      THEN
         FOR d1 IN d
         LOOP
            b540nbt_policy_id := d1.policy_id;

            /* To store the policy id of the policy */
            FOR b1 IN b (d1.policy_id)
            LOOP
               IF p_eff_date IS NULL
               THEN
                  p_eff_date := d1.eff_date;
                  b480currency_cd := b1.currency_cd;
                  b480currency_rt := b1.currency_rt;
                  b480item_title := b1.item_title;
                  b480coverage_cd := b1.coverage_cd;
                  b480group_cd := b1.group_cd;
                  v_new_item := 'N';
                  gipis060_get_wvehicle_info (b540nbt_policy_id,
                                              p_item_no,
                                              b580_subline_cd,
                                              b580_motor_coverage,
                                              b580_motor_coverage_desc,
                                              b580_assignee,
                                              b580_origin,
                                              b580_plate_no,
                                              b580_mv_file_no,
                                              b580_basic_color_cd,
                                              b580_mot_type,
                                              b580_motor_type_desc,
                                              b580_serial_no,
                                              b580_coc_type,
                                              b580_coc_yy,
                                              b580_coc_serial_no,
                                              b580_acquired_from,
                                              b580_destination,
                                              b580_model_year,
                                              b580_no_of_pass,
                                              b580_color_cd,
                                              b580_color,
                                              b580_unladen_wt,
                                              b580_subline_type_cd,
                                              b580_subline_type_desc,
                                              b580_motor_no,
                                              b580_type_of_body_cd,
                                              b580_car_company_cd,
                                              b580_car_company,
                                              b580_make,
                                              b580_make_cd,
                                              b580_series_cd,
                                              b580_towing,
                                              b580_repair_lim
                                             );
               -- get_gipi_wvehicle_info;
               END IF;

               IF d1.eff_date > p_eff_date
               THEN
                  p_eff_date := d1.eff_date;
                  b480currency_cd := b1.currency_cd;
                  b480currency_rt := b1.currency_rt;
                  b480item_title := b1.item_title;
                  b480coverage_cd := b1.coverage_cd;
                  v_new_item := 'N';
                  gipis060_get_wvehicle_info (b540nbt_policy_id,
                                              p_item_no,
                                              b580_subline_cd,
                                              b580_motor_coverage,
                                              b580_motor_coverage_desc,
                                              b580_assignee,
                                              b580_origin,
                                              b580_plate_no,
                                              b580_mv_file_no,
                                              b580_basic_color_cd,
                                              b580_mot_type,
                                              b580_motor_type_desc,
                                              b580_serial_no,
                                              b580_coc_type,
                                              b580_coc_yy,
                                              b580_coc_serial_no,
                                              b580_acquired_from,
                                              b580_destination,
                                              b580_model_year,
                                              b580_no_of_pass,
                                              b580_color_cd,
                                              b580_color,
                                              b580_unladen_wt,
                                              b580_subline_type_cd,
                                              b580_subline_type_desc,
                                              b580_motor_no,
                                              b580_type_of_body_cd,
                                              b580_car_company_cd,
                                              b580_car_company,
                                              b580_make,
                                              b580_make_cd,
                                              b580_series_cd,
                                              b580_towing,
                                              b580_repair_lim
                                             );
               --get_gipi_wvehicle_info;
               END IF;
            END LOOP;

            FOR c1 IN c (b480currency_cd)
            LOOP
               b480dsp_currency_desc := c1.currency_desc;
               b480currency_rt := c1.currency_rt;
               b480dsp_short_name := c1.short_name;
            END LOOP;

            EXIT;
         END LOOP;
      ELSE
         FOR a1 IN a
         LOOP
            b540nbt_policy_id := a1.policy_id;

            /* To store the policy id of the policy */
            FOR b1 IN b (a1.policy_id)
            LOOP
               IF p_eff_date IS NULL
               THEN
                  p_eff_date := a1.eff_date;
                  b480currency_cd := b1.currency_cd;
                  b480currency_rt := b1.currency_rt;
                  b480item_title := b1.item_title;
                  b480coverage_cd := b1.coverage_cd;
                  b480group_cd := b1.group_cd;
                  v_new_item := 'N';
                  gipis060_get_wvehicle_info (b540nbt_policy_id,
                                              p_item_no,
                                              b580_subline_cd,
                                              b580_motor_coverage,
                                              b580_motor_coverage_desc,
                                              b580_assignee,
                                              b580_origin,
                                              b580_plate_no,
                                              b580_mv_file_no,
                                              b580_basic_color_cd,
                                              b580_mot_type,
                                              b580_motor_type_desc,
                                              b580_serial_no,
                                              b580_coc_type,
                                              b580_coc_yy,
                                              b580_coc_serial_no,
                                              b580_acquired_from,
                                              b580_destination,
                                              b580_model_year,
                                              b580_no_of_pass,
                                              b580_color_cd,
                                              b580_color,
                                              b580_unladen_wt,
                                              b580_subline_type_cd,
                                              b580_subline_type_desc,
                                              b580_motor_no,
                                              b580_type_of_body_cd,
                                              b580_car_company_cd,
                                              b580_car_company,
                                              b580_make,
                                              b580_make_cd,
                                              b580_series_cd,
                                              b580_towing,
                                              b580_repair_lim
                                             );
               --get_gipi_wvehicle_info;
               END IF;

               IF a1.eff_date > p_eff_date
               THEN
                  p_eff_date := a1.eff_date;
                  b480currency_cd := b1.currency_cd;
                  b480currency_rt := b1.currency_rt;
                  b480item_title := b1.item_title;
                  b480coverage_cd := b1.coverage_cd;
                  v_new_item := 'N';
                  gipis060_get_wvehicle_info (b540nbt_policy_id,
                                              p_item_no,
                                              b580_subline_cd,
                                              b580_motor_coverage,
                                              b580_motor_coverage_desc,
                                              b580_assignee,
                                              b580_origin,
                                              b580_plate_no,
                                              b580_mv_file_no,
                                              b580_basic_color_cd,
                                              b580_mot_type,
                                              b580_motor_type_desc,
                                              b580_serial_no,
                                              b580_coc_type,
                                              b580_coc_yy,
                                              b580_coc_serial_no,
                                              b580_acquired_from,
                                              b580_destination,
                                              b580_model_year,
                                              b580_no_of_pass,
                                              b580_color_cd,
                                              b580_color,
                                              b580_unladen_wt,
                                              b580_subline_type_cd,
                                              b580_subline_type_desc,
                                              b580_motor_no,
                                              b580_type_of_body_cd,
                                              b580_car_company_cd,
                                              b580_car_company,
                                              b580_make,
                                              b580_make_cd,
                                              b580_series_cd,
                                              b580_towing,
                                              b580_repair_lim
                                             );
               --get_gipi_wvehicle_info;
               END IF;
            END LOOP;

            FOR c1 IN c (b480currency_cd)
            LOOP
               b480dsp_currency_desc := c1.currency_desc;
               b480currency_rt := c1.currency_rt;
               b480dsp_short_name := c1.short_name;
            END LOOP;

            EXIT;
         END LOOP;
      END IF;

      --CLEAR_MESSAGE;
      IF v_new_item = 'Y'
      THEN
         FOR a1 IN (SELECT main_currency_cd, currency_desc, currency_rt
                      FROM giis_currency
                     WHERE currency_rt = 1)
         LOOP
            b480item_title := NULL;
            b480currency_cd := a1.main_currency_cd;
            b480dsp_currency_desc := a1.currency_desc;
            b480currency_rt := a1.currency_rt;
            EXIT;
         END LOOP;

         --BETH 121699 initialize default coverage
         FOR cov IN (SELECT coverage_cd, coverage_desc
                       FROM giis_coverage
                      WHERE coverage_cd =
                                   (SELECT param_value_n dflt_coverage
                                      FROM giis_parameters
                                     WHERE param_name = 'DEFAULT_COVERAGE_CD'))
         LOOP
            b480coverage_cd := cov.coverage_cd;
            b480dsp_coverage_desc := cov.coverage_desc;
         END LOOP;

/* Default DEDUCTIBLE AMOUNT, TOWING LIMIT, LOADING FACTOR   */
/* DEDUCTIBLE DISCOUNT, COMPREHENSIVE DISCOUNT, PLATE NUMBER */
/* from those specified in the giis_parameters table         */
         DECLARE
            CURSOR b
            IS
               SELECT param_name, param_value_n
                 FROM giis_parameters
                WHERE param_name LIKE 'TOWING%';

            CURSOR f
            IS
               SELECT param_name, param_value_v
                 FROM giis_parameters
                WHERE param_name LIKE 'PLATE NUMBER%';

            p_var_line_cd              giis_parameters.param_value_v%TYPE;
            p_var_subline_motorcycle   giis_parameters.param_value_v%TYPE;
            p_var_subline_commercial   giis_parameters.param_value_v%TYPE;
            p_var_subline_private      giis_parameters.param_value_v%TYPE;
            p_var_subline_lto          giis_parameters.param_value_v%TYPE;
            p_var_coc_nlto             giis_parameters.param_value_v%TYPE;
            p_var_coc_lto              giis_parameters.param_value_v%TYPE;
         BEGIN
            gipis060_get_value (p_var_line_cd,
                                p_var_subline_motorcycle,
                                p_var_subline_commercial,
                                p_var_subline_private,
                                p_var_subline_lto,
                                p_var_coc_nlto,
                                p_var_coc_lto
                               );

            FOR b_rec IN b
            LOOP                                              /* For Towing */
               IF     b_rec.param_name = 'TOWING LIMIT - CV'
                  AND b240nbt_subline_cd = p_var_subline_commercial
               THEN
                  b580towing := b_rec.param_value_n;
               ELSIF     b_rec.param_name = 'TOWING LIMIT - LTO'
                     AND b240nbt_subline_cd = p_var_subline_lto
               THEN
                  b580towing := b_rec.param_value_n;
               ELSIF     b_rec.param_name = 'TOWING LIMIT - MCL'
                     AND b240nbt_subline_cd = p_var_subline_motorcycle
               THEN
                  b580towing := b_rec.param_value_n;
               ELSIF     b_rec.param_name = 'TOWING LIMIT - PC'
                     AND b240nbt_subline_cd = p_var_subline_private
               THEN
                  b580towing := b_rec.param_value_n;
               /* Created by: Charie
                              Aug. 18, 1998
                  the default value for towing limit for package policy
               */
               ELSIF    b_rec.param_name = 'TOWING LIMIT - CV'
                     OR b_rec.param_name = 'TOWING LIMIT - LTO'
                     OR b_rec.param_name = 'TOWING LIMIT - MCL'
                     OR     b_rec.param_name = 'TOWING LIMIT - PC'
                        AND v_pack_line_cd IS NOT NULL
                        AND v_pack_subline_cd IS NOT NULL
               THEN
                  b580towing := b_rec.param_value_n;
               END IF;
            END LOOP;
         END;

         b580repair_lim := NVL (b580towing, 0);
         b480rec_flag := 'A';
         b480ann_tsi_amt := NULL;
         b480ann_prem_amt := NULL;
         b580_subline_cd := NULL;
         b580_motor_no := NULL;
         b580_serial_no := NULL;
         b580_plate_no := NULL;
         b480group_cd := NULL;
         b480dsp_group_desc := NULL;
         b480coverage_cd := NULL;
         b480dsp_coverage_desc := NULL;
--         SET_ITEM_PROPERTY ('B580.DSP_MOTOR_TYPE_DESC',
--                            required,
--                            property_true
--                           );
--         SET_ITEM_PROPERTY ('B580.DSP_SUBLINE_TYPE_DESC',
--                            required,
--                            property_true
--                           );
      ELSE
--         SET_ITEM_PROPERTY ('B580.DSP_MOTOR_TYPE_DESC',
--                            required,
--                            property_false
--                           );
--         SET_ITEM_PROPERTY ('B580.DSP_SUBLINE_TYPE_DESC',
--                            required,
--                            property_false
--                           );
         b480rec_flag := 'C';
      END IF;

      FOR a1 IN (SELECT coverage_desc
                   FROM giis_coverage
                  WHERE coverage_cd = b480coverage_cd)
      LOOP
         b480dsp_coverage_desc := a1.coverage_desc;
      END LOOP;

      FOR a2 IN (SELECT group_desc
                   FROM giis_group
                  WHERE group_cd = b480group_cd)
      LOOP
         b480dsp_group_desc := a2.group_desc;
      END LOOP;

      --set_item_details;
      IF NVL (b480currency_cd, 0) = 0
      THEN
         raise_application_error
            ('00000',
                'Philippine Peso not found in the maintenance table of currency. '
             || 'Please contact your database administrator.'
            );
      END IF;
   END;

--/* These are the lines that ORACLE generated  */
--   BEGIN
--      cguv$chk_witem_pk
--                (p_item_no  /* IN : Item value                              */
--                          ,
--                 p_par_id   /* IN : Item value                              */
--                         ,
--                 TRUE
--                );          /* IN : Is the trigger item level?              */
----      msg_alert
----         (   'You are attempting to create a record with an existing item number '
----          || 'or with a deleted item but had not yet been committed, please do the '
----          || 'necessary actions. ',
----          'I',
----          TRUE
----         );
--   EXCEPTION
--      WHEN NO_DATA_FOUND
--      THEN
--         NULL;
--      WHEN OTHERS
--      THEN
--         NULL;
--   --cgte$other_exceptions;
--   END;
   FOR n IN (SELECT   a.region_cd region_cd, b.region_desc region_desc
                 FROM gipi_item a, giis_region b, gipi_polbasic c
                WHERE 1 = 1
                  --LINK GIPI_ITEM AND GIPI_POLBASIC
                  AND a.policy_id = c.policy_id
                  --FILTER POLBASIC
                  AND c.line_cd = v_line_cd
                  AND c.subline_cd = v_subline_cd
                  AND NVL (c.iss_cd, c.iss_cd) = v_iss_cd
                  AND c.issue_yy = v_issue_yy
                  AND c.pol_seq_no = v_pol_seq_no
                  AND c.renew_no = v_renew_no
                  AND a.item_no = p_item_no
                  AND c.pol_flag IN ('1', '2', '3', 'X')
                  --LINK GIIS_REGION AND GIPI_ITEM
                  AND a.region_cd = b.region_cd
                  AND a.region_cd IS NOT NULL
                  --FILTER OF GIPI_ITEM
                  AND NOT EXISTS (
                         SELECT a.region_cd region_cd
                           FROM gipi_item e, gipi_polbasic d
                          WHERE d.line_cd = v_line_cd
                            AND d.subline_cd = v_subline_cd
                            AND NVL (d.iss_cd, d.iss_cd) = v_iss_cd
                            AND d.issue_yy = v_issue_yy
                            AND d.pol_seq_no = v_pol_seq_no
                            AND d.renew_no = v_renew_no
                            AND e.item_no = p_item_no
                            AND e.policy_id = d.policy_id
                            AND e.region_cd IS NOT NULL
                            AND d.pol_flag IN ('1', '2', '3', 'X')
                            AND NVL (d.back_stat, 5) = 2
                            AND d.endt_seq_no > c.endt_seq_no)
             ORDER BY c.eff_date DESC)
   LOOP
      --IF n.region_cd IS NOT NULL THEN
      b480region_cd := n.region_cd;
      b480dsp_region_desc := n.region_desc;
      EXIT;
   --END IF;
   END LOOP;

   OPEN p_endt_item_details FOR
      SELECT p_item_no item_no, b480item_title item_title,
             b480ann_tsi_amt ann_tsi_amt, b480ann_prem_amt ann_prem_amt,
             b480rec_flag rec_flag, b480currency_rt currency_rt,
             b480coverage_cd coverage_cd, b480dsp_coverage_desc coverage_desc,
             b480group_cd group_cd, b480dsp_group_desc group_desc,
             b480currency_cd currency_cd, b480dsp_currency_desc currency_desc,
             b480dsp_short_name short_name, b480region_cd region_cd,
             b480dsp_region_desc region_desc,
                                             --
                                             b580_subline_cd subline_cd,
             b580_motor_coverage motor_coverage,
             b580_motor_coverage_desc motor_coverage_desc,
             b580_assignee assignee, b580_origin origin,
             b580_plate_no plate_no, b580_mv_file_no mv_file_no,
             b580_basic_color_cd basic_color_cd, b580_mot_type mot_type,
             b580_motor_type_desc motor_type_desc, b580_serial_no serial_no,
             b580_coc_type coc_type, b580_coc_yy coc_yy,
             --b580_coc_serial_no coc_serial_no,
             b580_acquired_from acquired_from, b580_destination destination,
             b580_model_year model_year, b580_no_of_pass no_of_pass,
             b580_color_cd color_cd, b580_color color,
             b580_unladen_wt unladen_wt, b580_subline_type_cd subline_type_cd,
             b580_subline_type_desc subline_type_desc, b580_motor_no motor_no,
             b580_type_of_body_cd type_of_body_cd,
             b580_car_company_cd car_company_cd, b580_car_company car_company,
             b580_make make, b580_make_cd make_cd, b580_series_cd series_cd,
             b580_towing towing, b580_repair_lim repair_lim
        FROM DUAL;
END gipis060_validate_item;
/


