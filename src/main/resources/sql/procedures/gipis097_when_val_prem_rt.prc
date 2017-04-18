DROP PROCEDURE CPI.GIPIS097_WHEN_VAL_PREM_RT;

CREATE OR REPLACE PROCEDURE CPI.gipis097_when_val_prem_rt ( 
   p_par_id                    gipi_witmperl.par_id%TYPE,
   p_item_no                   gipi_witmperl.item_no%TYPE,
   p_peril_cd                  gipi_witmperl.peril_cd%TYPE,
   p_prem_rt                   gipi_witmperl.prem_rt%TYPE,
   p_tsi_amt                   gipi_witmperl.tsi_amt%TYPE,
   p_rec_flag                  gipi_witmperl.rec_flag%TYPE,
   p_coverage_cd               gipi_witem.coverage_cd%TYPE,
   p_tariff_zone               gipi_wvehicle.tariff_zone%TYPE,
   p_subline_type_cd           gipi_wvehicle.subline_type_cd%TYPE,
   p_mot_type                  gipi_wvehicle.mot_type%TYPE,
   p_construction_cd           gipi_wfireitm.construction_cd%TYPE,
   p_tarf_cd                   gipi_wfireitm.tarf_cd%TYPE,
   p_changed_tag               gipi_witem.changed_tag%TYPE,
   p_ann_tsi_amt               gipi_witmperl.ann_tsi_amt%TYPE,
   p_ann_prem_amt              gipi_witmperl.ann_prem_amt%TYPE,
   p_item_tsi_amt              gipi_witem.tsi_amt%TYPE,
   p_item_prem_amt             gipi_witem.prem_amt%TYPE,
   p_item_ann_tsi_amt          gipi_witem.ann_tsi_amt%TYPE,
   p_item_ann_prem_amt         gipi_witem.ann_prem_amt%TYPE,
   p_no_of_days                NUMBER,
   p_to_date                   VARCHAR2,--gipi_witem.TO_DATE%TYPE,
   p_from_date                 VARCHAR2,--gipi_witem.from_date%TYPE,
   p_comp_sw                   gipi_witem.comp_sw%TYPE, 
   p_out_prem_amt        OUT   NUMBER, --gipi_witmperl.prem_amt%TYPE,
   p_out_ann_prem_amt    OUT   NUMBER, --gipi_witmperl.ann_prem_amt%TYPE,
   p_base_ann_prem_amt OUT NUMBER -- gipi_witmperl.ann_prem_amt%TYPE
)
IS
   CURSOR vehicle
   IS
      (SELECT mot_type, subline_cd
         FROM gipi_wvehicle
        WHERE par_id = p_par_id AND item_no = p_item_no);

   v_prem_tag          giis_tariff_rates_hdr.default_prem_tag%TYPE;
   v_tariff_cd         giis_tariff_rates_hdr.tariff_cd%TYPE;
   v_fixed_prem        giis_tariff_rates_dtl.fixed_premium%TYPE;
   tarf_sw             VARCHAR2 (1)                                  := 'N';
   v_subline_cd        gipi_wpolbas.subline_cd%TYPE;
   v_prorate_flag      gipi_wpolbas.prorate_flag%TYPE;
   v_prov_prem_tag     gipi_wpolbas.prov_prem_tag%TYPE;
   v_line_cd           gipi_wpolbas.line_cd%TYPE;
   v_iss_cd            gipi_wpolbas.iss_cd%TYPE;
   v_tariff_sw         gipi_wpolbas.with_tariff_sw%TYPE;
   v_peril_type        giis_peril.peril_type%TYPE;
   v_out_tsi_amt       gipi_witmperl.tsi_amt%TYPE;
   v_out_ann_tsi_amt   gipi_witmperl.ann_tsi_amt%TYPE;
BEGIN 
--/*BETH 10 20 98 if changes are made in prem rate then
--**     deletion of records in bill and distribution table will be enabled
--*/
--   IF :SYSTEM.record_status NOT IN ('NEW', 'QUERY') AND :b490.nbt_prem_rt IS NOT NULL AND :b490.nbt_prem_rt != :b490.prem_rt
--   THEN
--      :parameter.commit_sw := 'Y';
--   END IF;

   --   IF :SYSTEM.record_status != 'QUERY'
--   THEN
--      IF NVL (:b490.prem_rt, 0) < 0
--      THEN
--         :b490.prem_rt := NULL;
--         msg_alert ('Rate must not be less than zero (0%).', 'E', TRUE);
--      ELSIF NVL (:b490.prem_rt, 100) > 100
--      THEN
--         :b490.prem_rt := NULL;
--         msg_alert ('Rate must not be greater than a hundred (100%).', 'E', TRUE);
--      END IF;
   SELECT subline_cd, prorate_flag, prov_prem_tag, line_cd, iss_cd, with_tariff_sw
     INTO v_subline_cd, v_prorate_flag, v_prov_prem_tag, v_line_cd, v_iss_cd, v_tariff_sw
     FROM gipi_wpolbas
    WHERE par_id = p_par_id;

   --BETH 110899 determine if peril should compute premium based on tariff
   --            only if premium_rt is 0 and computation of premium is based 
   --            on straight 1 year
   IF     NVL (p_prem_rt, 0) = 0
      AND NVL (v_tariff_sw, 'N') = 'Y'
      AND v_prorate_flag = '2'
      AND NVL (v_prov_prem_tag, 'N') = 'N'
      AND NVL (p_tsi_amt, 0) > 0
      AND NVL (p_rec_flag, 'A') = 'A'
      AND p_peril_cd != NULL
   THEN
      IF v_line_cd = giisp.v ('MOTOR CAR')
      THEN
         FOR chk1 IN (SELECT a.default_prem_tag, a.tariff_cd
                        FROM giis_tariff_rates_hdr a, gipi_wvehicle b
                       WHERE a.motortype_cd = NVL (b.mot_type, p_mot_type)
                         AND a.subline_type_cd = NVL (b.subline_type_cd, p_subline_type_cd)
                         AND NVL (a.tariff_zone, '##') = NVL (b.tariff_zone, NVL (p_tariff_zone, '##'))
                         AND a.coverage_cd = p_coverage_cd
                         AND a.line_cd = v_line_cd
                         AND a.subline_cd = v_subline_cd
                         AND a.peril_cd = p_peril_cd
                         AND b.item_no = p_item_no
                         AND b.par_id = p_par_id)
         LOOP
            v_prem_tag := chk1.default_prem_tag;
            tarf_sw := 'Y';
            v_tariff_cd := chk1.tariff_cd;
         END LOOP;
      ELSIF v_line_cd = giisp.v ('FIRE')
      THEN
         FOR chk2 IN (SELECT a.default_prem_tag, a.tariff_cd
                        FROM giis_tariff_rates_hdr a, gipi_wfireitm b
                       WHERE NVL (a.tarf_cd, '##') = NVL (b.tarf_cd, NVL (p_tarf_cd, '##'))
                         AND NVL (a.construction_cd, '##') = NVL (b.construction_cd, NVL (p_construction_cd, '##'))
                         AND NVL (a.tariff_zone, '##') = NVL (b.tariff_zone, NVL (p_tariff_zone, '##'))
                         AND a.line_cd = v_line_cd
                         AND a.subline_cd = v_subline_cd
                         AND a.peril_cd = p_peril_cd
                         AND b.par_id = p_par_id
                         AND b.item_no = p_item_no)
         LOOP
            v_prem_tag := chk2.default_prem_tag;
            tarf_sw := 'Y';
            v_tariff_cd := chk2.tariff_cd;
         END LOOP;
      END IF;

      IF v_prem_tag = '1'
      THEN
         tarf_sw := 'N';

         FOR fix IN (SELECT fixed_premium
                       FROM giis_tariff_rates_dtl
                      WHERE fixed_si = p_tsi_amt AND tariff_cd = v_tariff_cd)
         LOOP
            v_fixed_prem := NVL (fix.fixed_premium, 0);
            tarf_sw := 'Y';
         END LOOP;
      END IF;
   END IF;

   IF p_peril_cd != NULL THEN
       SELECT peril_type
         INTO v_peril_type
         FROM giis_peril
        WHERE line_cd = v_line_cd AND peril_cd = p_peril_cd;
   END IF;

   IF NVL (tarf_sw, 'N') = 'Y'
   THEN
      gipis097_compute_tarf (p_par_id,
                             p_peril_cd,
                             v_peril_type,
                             p_tsi_amt,
                             p_prem_rt,
                             p_ann_tsi_amt,
                             p_ann_prem_amt,
                             p_item_tsi_amt,
                             p_item_prem_amt,
                             p_item_ann_tsi_amt,
                             p_item_ann_prem_amt,
                             v_tariff_cd,
                             v_prem_tag,
                             v_fixed_prem,
                             p_out_prem_amt,
                             v_out_ann_tsi_amt,
                             p_out_ann_prem_amt,
                             p_base_ann_prem_amt
                            ); 
   ELSE
      gipis097_compute_tsi (p_par_id,
                            p_peril_cd,
                            v_peril_type,
                            p_changed_tag, 
                            p_tsi_amt,
                            p_prem_rt,
                            p_ann_tsi_amt,
                            p_ann_prem_amt,
                            p_item_tsi_amt,
                            p_item_prem_amt,
                            p_item_ann_tsi_amt,
                            p_item_ann_prem_amt,
                            p_no_of_days,
                            TO_DATE(p_to_date, 'MM-DD-YYYY'),
                            TO_DATE(p_from_date, 'MM-DD-YYYY'),
                            p_comp_sw,
                            NULL,
                            v_out_tsi_amt,
                            p_out_prem_amt,
                            v_out_ann_tsi_amt,
                            p_out_ann_prem_amt,
                            p_base_ann_prem_amt
                           );
   END IF;
--END IF;
--END IF;
END;
/


