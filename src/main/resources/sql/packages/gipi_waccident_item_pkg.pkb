CREATE OR REPLACE PACKAGE BODY CPI.gipi_waccident_item_pkg
AS
    /*
   **  Created by    : Jerome Orio
   **  Date Created  : 05.07.2010
   **  EDITED BY     : Irwin Tabisora
   **  Reference By  : (GIPIS012 Item Information - Accident)
   **  Description   : Returns PAR record listing for ACCIDENT
   */
   FUNCTION get_gipi_waccident_items (
      p_par_id   gipi_waccident_item.par_id%TYPE
   )
      RETURN gipi_waccident_item_tab PIPELINED
   IS
      v_gipi_par_ah   gipi_waccident_item_type;
   BEGIN
      FOR i IN (SELECT   a.par_id, a.item_no, a.item_title, a.item_grp,
                         a.item_desc, a.item_desc2, a.tsi_amt, a.prem_amt,
                         a.ann_prem_amt, a.ann_tsi_amt, a.rec_flag,
                         a.currency_cd, a.currency_rt, a.group_cd,
                         a.from_date, a.TO_DATE, a.pack_line_cd,
                         a.pack_subline_cd, a.discount_sw, a.coverage_cd,
                         a.other_info, a.surcharge_sw, a.region_cd,
                         a.changed_tag, a.prorate_flag, a.comp_sw,
                         a.short_rt_percent, a.pack_ben_cd, a.payt_terms,
                         a.risk_no, a.risk_item_no, b.currency_desc,
                         c.date_of_birth, c.age, c.civil_status,
                         c.position_cd, c.monthly_salary, c.salary_grade,
                         c.no_of_persons, c.destination, c.height, c.weight,
                         c.sex, c.group_print_sw, c.ac_class_cd, c.level_cd,
                         c.parent_level_cd, d.coverage_desc
                    FROM gipi_witem a,
                         giis_currency b,
                         gipi_waccident_item c,
                         giis_coverage d
                   WHERE a.par_id = p_par_id
                     AND a.currency_cd = b.main_currency_cd(+)
                     AND a.par_id = c.par_id(+)
                     AND a.item_no = c.item_no(+)
                     AND a.coverage_cd = d.coverage_cd(+)
                ORDER BY a.par_id, a.item_no)
      LOOP
         v_gipi_par_ah.par_id := i.par_id;
         v_gipi_par_ah.item_no := i.item_no;
         v_gipi_par_ah.item_title := i.item_title;
         v_gipi_par_ah.item_grp := i.item_grp;
         v_gipi_par_ah.item_desc := i.item_desc;
         v_gipi_par_ah.item_desc2 := i.item_desc2;
         v_gipi_par_ah.tsi_amt := NVL (i.tsi_amt, 0);
         v_gipi_par_ah.prem_amt := NVL (i.prem_amt, 0);
         v_gipi_par_ah.ann_prem_amt := NVL (i.ann_prem_amt, 0);
         v_gipi_par_ah.ann_tsi_amt := NVL (i.ann_tsi_amt, 0);
         v_gipi_par_ah.rec_flag := i.rec_flag;
         v_gipi_par_ah.currency_cd := i.currency_cd;
         v_gipi_par_ah.currency_rt := i.currency_rt;
         v_gipi_par_ah.group_cd := i.group_cd;
         v_gipi_par_ah.from_date := i.from_date;
         v_gipi_par_ah.TO_DATE := i.TO_DATE;
         v_gipi_par_ah.pack_line_cd := i.pack_line_cd;
         v_gipi_par_ah.pack_subline_cd := i.pack_subline_cd;
         v_gipi_par_ah.discount_sw := i.discount_sw;
         v_gipi_par_ah.coverage_cd := i.coverage_cd;
         v_gipi_par_ah.other_info := i.other_info;
         v_gipi_par_ah.surcharge_sw := i.surcharge_sw;
         v_gipi_par_ah.region_cd := i.region_cd;
         v_gipi_par_ah.changed_tag := i.changed_tag;
         v_gipi_par_ah.prorate_flag := i.prorate_flag;
         v_gipi_par_ah.comp_sw := i.comp_sw;
         v_gipi_par_ah.short_rt_percent := i.short_rt_percent;
         v_gipi_par_ah.pack_ben_cd := i.pack_ben_cd;
         v_gipi_par_ah.payt_terms := i.payt_terms;
         v_gipi_par_ah.risk_no := i.risk_no;
         v_gipi_par_ah.risk_item_no := i.risk_item_no;
         v_gipi_par_ah.date_of_birth := i.date_of_birth;
         v_gipi_par_ah.age := i.age;
         v_gipi_par_ah.civil_status := i.civil_status;
         v_gipi_par_ah.position_cd := i.position_cd;
         v_gipi_par_ah.monthly_salary := i.monthly_salary;
         v_gipi_par_ah.salary_grade := i.salary_grade;
         v_gipi_par_ah.no_of_persons := i.no_of_persons;
         v_gipi_par_ah.destination := i.destination;
         v_gipi_par_ah.height := i.height;
         v_gipi_par_ah.weight := i.weight;
         v_gipi_par_ah.sex := i.sex;
         v_gipi_par_ah.group_print_sw := i.group_print_sw;
         v_gipi_par_ah.ac_class_cd := i.ac_class_cd;
         v_gipi_par_ah.level_cd := i.level_cd;
         v_gipi_par_ah.parent_level_cd := i.parent_level_cd;
         v_gipi_par_ah.currency_desc := i.currency_desc;
         v_gipi_par_ah.coverage_desc := i.coverage_desc;
         v_gipi_par_ah.itmperl_grouped_exists :=
            gipi_witmperl_grouped_pkg.gipi_witmperl_grouped_exist (p_par_id,
                                                                   i.item_no
                                                                  );

         SELECT gipi_witmperl_grouped_pkg.gipi_witmperl_grouped_exist
                                                                    (i.par_id,
                                                                     i.item_no
                                                                    )
           INTO v_gipi_par_ah.item_witmperl_grouped_exist
           FROM DUAL;

         SELECT gipi_witmperl_pkg.get_gipi_witmperl_exist (i.par_id,
                                                           i.item_no)
           INTO v_gipi_par_ah.item_witmperl_exist
           FROM DUAL;

         SELECT gipi_wgrouped_items_pkg.gipi_wgrouped_items_exist (i.par_id,
                                                                   i.item_no
                                                                  )
           INTO v_gipi_par_ah.item_wgrouped_items_exist
           FROM DUAL;

         PIPE ROW (v_gipi_par_ah);
      END LOOP;

      RETURN;
   END;

    /*
   **  Created by    : Jerome Orio
   **  Date Created  : 05.11.2010
   **  Reference By  : (GIPIS012 Item Information - Accident)
   **  Description   : Insert PAR record listing for ACCIDENT
   */
   PROCEDURE set_gipi_waccident_items (
      p_par_id            gipi_waccident_item.par_id%TYPE,
      p_item_no           gipi_waccident_item.item_no%TYPE,
      p_no_of_persons     gipi_waccident_item.no_of_persons%TYPE,
      p_position_cd       gipi_waccident_item.position_cd%TYPE,
      p_destination       gipi_waccident_item.destination%TYPE,
      p_monthly_salary    gipi_waccident_item.monthly_salary%TYPE,
      p_salary_grade      gipi_waccident_item.salary_grade%TYPE,
      p_date_of_birth     gipi_waccident_item.date_of_birth%TYPE,
      p_age               gipi_waccident_item.age%TYPE,
      p_civil_status      gipi_waccident_item.civil_status%TYPE,
      p_height            gipi_waccident_item.height%TYPE,
      p_weight            gipi_waccident_item.weight%TYPE,
      p_sex               gipi_waccident_item.sex%TYPE,
      p_group_print_sw    gipi_waccident_item.group_print_sw%TYPE,
      p_ac_class_cd       gipi_waccident_item.ac_class_cd%TYPE,
      p_level_cd          gipi_waccident_item.level_cd%TYPE,
      p_parent_level_cd   gipi_waccident_item.parent_level_cd%TYPE
   )
   IS
   BEGIN
      MERGE INTO gipi_waccident_item
         USING DUAL
         ON (par_id = p_par_id AND item_no = p_item_no)
         WHEN NOT MATCHED THEN
            INSERT (par_id, item_no, no_of_persons, position_cd, destination,
                    monthly_salary, salary_grade, date_of_birth, age,
                    civil_status, height, weight, sex, group_print_sw,
                    ac_class_cd, level_cd, parent_level_cd)
            VALUES (p_par_id, p_item_no, p_no_of_persons, p_position_cd,
                    p_destination, p_monthly_salary, p_salary_grade,
                    p_date_of_birth, p_age, p_civil_status, p_height,
                    p_weight, p_sex, p_group_print_sw, p_ac_class_cd,
                    p_level_cd, p_parent_level_cd)
         WHEN MATCHED THEN
            UPDATE
               SET no_of_persons = p_no_of_persons,
                   position_cd = p_position_cd, destination = p_destination,
                   monthly_salary = p_monthly_salary,
                   salary_grade = p_salary_grade,
                   date_of_birth = p_date_of_birth, age = p_age,
                   civil_status = p_civil_status, height = p_height,
                   weight = p_weight, sex = p_sex,
                   group_print_sw = p_group_print_sw,
                   ac_class_cd = p_ac_class_cd, level_cd = p_level_cd,
                   parent_level_cd = p_parent_level_cd
            ;
   END;

   /*
   **  Created by    : Jerome Orio
   **  Date Created  : 05.12.2010
   **  Reference By  : (GIPIS012 Item Information - Accident)
   **  Description   : Delete PAR record listing for ACCIDENT
   */
   PROCEDURE del_gipi_waccident_item (
      p_par_id    gipi_waccident_item.par_id%TYPE,
      p_item_no   gipi_waccident_item.item_no%TYPE
   )
   IS
   BEGIN
      DELETE      gipi_waccident_item
            WHERE par_id = p_par_id AND item_no = p_item_no;
   END;

   /*
   **  Created by    : Mark JM
   **  Date Created  : 06.01.2010
   **  Reference By  : (GIPIS031 - Endt Basic Information)
   **  Description   : This procedure deletes record based on the given par_id
   */
   PROCEDURE del_gipi_waccident_item (
      p_par_id   IN   gipi_waccident_item.par_id%TYPE
   )
   IS
   BEGIN
      DELETE      gipi_waccident_item
            WHERE par_id = p_par_id;
   END del_gipi_waccident_item;

     /*
   **  Created by    : Jerome Orio
   **  Date Created  : 06.23.2010
   **  Reference By  : (GIPIS012 - Accident Item info)
   **  Description   : delete_bill program unit
   */
   PROCEDURE del_bill_gipis012 (
      p_par_id         gipi_waccident_item.par_id%TYPE,
      p_item_no        gipi_waccident_item.item_no%TYPE,
      p_prem_amt       gipi_witem.prem_amt%TYPE,
      p_ann_prem_amt   gipi_witem.ann_prem_amt%TYPE,
      p_tsi_amt        gipi_witem.tsi_amt%TYPE,
      p_ann_tsi_amt    gipi_witem.ann_tsi_amt%TYPE
   )
   IS
   BEGIN
      DELETE FROM gipi_winstallment
            WHERE par_id = p_par_id;

      DELETE FROM gipi_wcomm_inv_perils
            WHERE par_id = p_par_id;

      DELETE FROM gipi_wcomm_invoices
            WHERE par_id = p_par_id;

      DELETE FROM gipi_winvperl
            WHERE par_id = p_par_id;

      DELETE FROM gipi_winv_tax
            WHERE par_id = p_par_id;

      DELETE FROM gipi_wpackage_inv_tax
            WHERE par_id = p_par_id;

      DELETE FROM gipi_winvoice
            WHERE par_id = p_par_id;

      DELETE FROM gipi_orig_invperl
            WHERE par_id = p_par_id;

      DELETE FROM gipi_orig_inv_tax
            WHERE par_id = p_par_id;

      DELETE FROM gipi_orig_invoice
            WHERE par_id = p_par_id;

      DELETE FROM gipi_orig_itmperil
            WHERE par_id = p_par_id AND item_no = p_item_no;

      DELETE FROM gipi_co_insurer
            WHERE par_id = p_par_id;

      DELETE FROM gipi_main_co_ins
            WHERE par_id = p_par_id;

      DELETE FROM gipi_wpolbas_discount
            WHERE par_id = p_par_id;

      DELETE FROM gipi_witem_discount
            WHERE par_id = p_par_id AND item_no = p_item_no;

      DELETE FROM gipi_wperil_discount
            WHERE par_id = p_par_id AND item_no = p_item_no;

      DELETE FROM gipi_witmperl
            WHERE par_id = p_par_id AND item_no = p_item_no;

      DELETE FROM gipi_wopen_peril
            WHERE par_id = p_par_id;

      --DELETE_CO_INS(p_par_id);
      UPDATE gipi_witem
         SET prem_amt = 0,
             ann_prem_amt = 0,
             tsi_amt = 0,
             ann_tsi_amt = 0,
             discount_sw = 'N',
             surcharge_sw = 'N'
       WHERE par_id = p_par_id AND item_no = p_item_no;

      UPDATE gipi_wpolbas
         SET prem_amt = prem_amt - p_prem_amt,
             ann_prem_amt = ann_prem_amt - p_ann_prem_amt,
             tsi_amt = tsi_amt - p_tsi_amt,
             ann_tsi_amt = ann_tsi_amt - p_ann_tsi_amt,
             discount_sw = 'N',
             surcharge_sw = 'N'
       WHERE par_id = p_par_id;

      UPDATE gipi_parlist
         SET par_status = '4'
       WHERE par_id = p_par_id;
   END;

   -- added for when validate item -- irwin aug 23, 2010
   FUNCTION get_witem_acci_endt_details (
      p_line_cd        gipi_wpolbas.line_cd%TYPE,
      p_subline_cd     gipi_wpolbas.subline_cd%TYPE,
      p_iss_cd         gipi_wpolbas.iss_cd%TYPE,
      p_item_no        gipi_witem.item_no%TYPE,
      p_expiry_date    gipi_wpolbas.expiry_date%TYPE,
      p_eff_date       gipi_wpolbas.eff_date%TYPE,
      p_issue_yy       gipi_wpolbas.issue_yy%TYPE,
      p_pol_seq_no     gipi_wpolbas.pol_seq_no%TYPE,
      p_renew_no       gipi_wpolbas.renew_no%TYPE,
      p_ann_tsi_amt    gipi_witem.ann_tsi_amt%TYPE,
      p_ann_prem_amt   gipi_witem.ann_prem_amt%TYPE
   )
      RETURN gipi_waccident_item_tab PIPELINED
   IS
      v_gipi_par_ah        gipi_waccident_item_type;
      v_eff_date           gipi_polbasic.eff_date%TYPE;
      v_new_item           VARCHAR2 (1)                      := 'Y';
      expired_sw           VARCHAR2 (1)                      := 'N';
      amt_sw               VARCHAR2 (1)                      := 'N';
      v_max_endt_seq_no    gipi_polbasic.endt_seq_no%TYPE;
      v_max_endt_seq_no1   gipi_polbasic.endt_seq_no%TYPE;
      --- declarations for extract_ann_amt2 below
      v_comp_prem          gipi_witmperl.ann_prem_amt%TYPE   := 0;
      v_prorate            NUMBER;

      -----

      --first cursor
      CURSOR a
      IS
         SELECT   a.policy_id policy_id, a.eff_date eff_date
             FROM gipi_polbasic a
            WHERE a.line_cd = p_line_cd
              -- former variables, changed to parameters.
              AND a.iss_cd = p_iss_cd
              AND a.subline_cd = p_subline_cd
              AND a.issue_yy = p_issue_yy
              AND a.pol_seq_no = p_pol_seq_no
              AND a.renew_no = p_renew_no
              -- lian 111601 added pol_flag = 'X'
              AND a.pol_flag IN ('1', '2', '3', 'X')
              --ASI 081299 add this validation so that data that will be retrieved
              --           is only those from endorsement prior to the current endorsement
              --           this was consider because of the backward endorsement
              AND TRUNC (a.eff_date) <=
                     DECODE (NVL (a.endt_seq_no, 0),
                             0, TRUNC (a.eff_date),
                             TRUNC (p_eff_date)
                            )
              --AND      NVL(a.endt_expiry_date,a.expiry_date) >=  variables.v_eff_date
              AND TRUNC
                     (DECODE (NVL (a.endt_expiry_date, a.expiry_date),
                              a.expiry_date, p_expiry_date,
                              a.endt_expiry_date
                             )
                     )                          --- expiry date parameter here
                      >= TRUNC (p_eff_date)
              AND EXISTS (
                     SELECT '1'
                       FROM gipi_item b
                      WHERE b.item_no = p_item_no
                            AND b.policy_id = a.policy_id)
         ORDER BY eff_date DESC;

      -------------- second cursor
      CURSOR b (p_policy_id gipi_item.policy_id%TYPE)
      IS
         SELECT currency_cd, currency_rt, item_title, from_date, TO_DATE,
                ann_tsi_amt, ann_prem_amt, coverage_cd, group_cd, changed_tag,
                prorate_flag, comp_sw, short_rt_percent
           FROM gipi_item
          WHERE policy_id = p_policy_id AND item_no = p_item_no;

      ----------- third cursor
      CURSOR c (p_currency_cd giis_currency.main_currency_cd%TYPE)
      IS
         SELECT currency_desc, short_name, currency_rt
           FROM giis_currency
          WHERE main_currency_cd = p_currency_cd;

      ----------- fourth  cursor
      CURSOR d
      IS
         SELECT   a.policy_id policy_id, a.eff_date eff_date
             FROM gipi_polbasic a
            WHERE a.line_cd = p_line_cd
              AND a.iss_cd = p_iss_cd
              AND a.subline_cd = p_subline_cd
              AND a.issue_yy = p_issue_yy
              AND a.pol_seq_no = p_pol_seq_no
              AND a.renew_no = p_renew_no
              -- lian 111601 added pol_flag = 'X'
              AND a.pol_flag IN ('1', '2', '3', 'X')
              AND TRUNC (a.eff_date) <=
                     DECODE (NVL (a.endt_seq_no, 0),
                             0, TRUNC (a.eff_date),
                             TRUNC (p_eff_date)
                            )
              --AND    NVL(a.endt_expiry_date,a.expiry_date) >=  variables.v_eff_date
              AND TRUNC (DECODE (NVL (a.endt_expiry_date, a.expiry_date),
                                 a.expiry_date, p_expiry_date,
                                 a.endt_expiry_date
                                )
                        ) >= TRUNC (p_eff_date)
              AND NVL (a.back_stat, 5) = 2
              AND EXISTS (
                     SELECT '1'
                       FROM gipi_item b
                      WHERE b.item_no = p_item_no
                            AND a.policy_id = b.policy_id)
              AND a.endt_seq_no =
                     (SELECT MAX (endt_seq_no)
                        FROM gipi_polbasic c
                       WHERE line_cd = p_line_cd
                         AND iss_cd = p_iss_cd
                         AND subline_cd = p_subline_cd
                         AND issue_yy = p_issue_yy
                         AND pol_seq_no = p_pol_seq_no
                         AND renew_no = p_renew_no
                         -- lian 111601 added pol_flag = 'X'
                         AND pol_flag IN ('1', '2', '3', 'X')
                         AND TRUNC (eff_date) <=
                                DECODE (NVL (c.endt_seq_no, 0),
                                        0, TRUNC (c.eff_date),
                                        TRUNC (p_eff_date)
                                       )
                         --AND NVL(endt_expiry_date,expiry_date) >=  variables.v_eff_date
                         AND TRUNC (DECODE (NVL (c.endt_expiry_date,
                                                 c.expiry_date
                                                ),
                                            c.expiry_date, p_expiry_date,
                                            c.endt_expiry_date
                                           )
                                   ) >= TRUNC (p_eff_date)
                         AND NVL (c.back_stat, 5) = 2
                         AND EXISTS (
                                SELECT '1'
                                  FROM gipi_item d
                                 WHERE d.item_no = p_item_no
                                   AND c.policy_id = d.policy_id))
         ORDER BY eff_date DESC;

      CURSOR e (p_policy_id gipi_item.policy_id%TYPE)
      IS
         SELECT position_cd, monthly_salary, salary_grade, no_of_persons,
                destination
           FROM gipi_accident_item
          WHERE policy_id = p_policy_id AND item_no = p_item_no;
   BEGIN
      -- get maximum endt sequence no
      v_gipi_par_ah.restricted_condition := 'N';

      FOR z IN (SELECT MAX (endt_seq_no) endt_seq_no
                  FROM gipi_polbasic a
                 WHERE line_cd = p_line_cd
                   AND iss_cd = p_iss_cd
                   AND subline_cd = p_subline_cd
                   AND issue_yy = p_issue_yy
                   AND pol_seq_no = p_pol_seq_no
                   AND renew_no = p_renew_no
                   -- lian 111601 added pol_flag = 'X'
                   AND pol_flag IN ('1', '2', '3', 'X')
                   AND TRUNC (eff_date) <=
                          DECODE (NVL (a.endt_seq_no, 0),
                                  0, TRUNC (a.eff_date),
                                  TRUNC (p_eff_date)
                                 )
                   --AND NVL(endt_expiry_date,expiry_date) >=  variables.v_eff_date
                   AND TRUNC (DECODE (NVL (a.endt_expiry_date, a.expiry_date),
                                      a.expiry_date, p_expiry_date,
                                      a.endt_expiry_date
                                     )
                             ) >= TRUNC (p_eff_date)
                   AND EXISTS (
                          SELECT '1'
                            FROM gipi_item b
                           WHERE b.item_no = p_item_no
                             AND a.policy_id = b.policy_id))
      LOOP
         v_max_endt_seq_no := z.endt_seq_no;
         EXIT;
      END LOOP;

      ---- second loop
      FOR x IN (SELECT MAX (endt_seq_no) endt_seq_no
                  FROM gipi_polbasic a
                 WHERE line_cd = p_line_cd
                   AND iss_cd = p_iss_cd
                   AND subline_cd = p_subline_cd
                   AND issue_yy = p_issue_yy
                   AND pol_seq_no = p_pol_seq_no
                   AND renew_no = p_renew_no
                   -- lian 111601 added pol_flag = 'X'
                   AND pol_flag IN ('1', '2', '3', 'X')
                   AND TRUNC (eff_date) <= TRUNC (p_eff_date)
                   --AND NVL(endt_expiry_date,expiry_date) >=  variables.v_eff_date
                   AND TRUNC (DECODE (NVL (a.endt_expiry_date, a.expiry_date),
                                      a.expiry_date, p_expiry_date,
                                      a.endt_expiry_date
                                     )
                             ) >= TRUNC (p_eff_date)
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

      ---- 3rd loop

      -- 02192001 latest amount for item should be retrieved from the latest endt record
      --     (depending on PAR eff_date).For policy w/out endt. yet then amounts will be the
      --     amount of policy. For policy with short term endt. amount should be recomputed by
      --     adding all amounts of policy and endt. that is not yet reversed
      expired_sw := 'N';

      -- check for the existance of short-term endt
      FOR sw IN (SELECT   '1'
                     FROM gipi_itmperil a, gipi_polbasic b
                    WHERE b.line_cd = p_line_cd
                      AND b.subline_cd = p_subline_cd
                      AND b.iss_cd = p_iss_cd
                      AND b.issue_yy = p_issue_yy
                      AND b.pol_seq_no = p_pol_seq_no
                      AND b.renew_no = p_renew_no
                      AND b.policy_id = a.policy_id
                      -- lian 111601 added pol_flag = 'X'
                      AND b.pol_flag IN ('1', '2', '3', 'X')
                      AND (a.prem_amt <> 0 OR a.tsi_amt <> 0)
                      AND a.item_no = p_item_no
                      AND TRUNC (b.eff_date) <=
                             DECODE (NVL (b.endt_seq_no, 0),
                                     0, TRUNC (b.eff_date),
                                     TRUNC (p_eff_date)
                                    )
                      --AND TRUNC(NVL(B.endt_expiry_date,B.expiry_date)) < TRUNC(variables.v_eff_date)
                      --AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date),
                      --      b.expiry_date, :b5402.expiry_date, b.endt_expiry_date))
                      --      < TRUNC(variables.v_eff_date)
                      AND TRUNC (DECODE (NVL (b.endt_expiry_date,
                                              b.expiry_date
                                             ),
                                         b.expiry_date, p_expiry_date,
                                         b.expiry_date, b.endt_expiry_date
                                        )
                                ) >= TRUNC (p_eff_date)
                 --bdarusin, changed < to >=, feb202003
                 ORDER BY b.eff_date DESC)
      LOOP
         expired_sw := 'Y';
         EXIT;
      END LOOP;

      --- end of loop queries

      ---------------START OF CONDITIONAL STATEMENTS AND ASSIGNING VALUES
      amt_sw := 'N';

      IF expired_sw = 'N'
      THEN
         --get amount from the latest endt
         FOR endt IN (SELECT   a.ann_tsi_amt, a.ann_prem_amt
                          FROM gipi_item a, gipi_polbasic b
                         WHERE b.line_cd = p_line_cd
                           AND b.subline_cd = p_subline_cd
                           AND b.iss_cd = p_iss_cd
                           AND b.issue_yy = p_issue_yy
                           AND b.pol_seq_no = p_pol_seq_no
                           AND b.renew_no = p_renew_no
                           AND b.policy_id = a.policy_id
                           -- lian 111601 added pol_flag = 'X'
                           AND b.pol_flag IN ('1', '2', '3', 'X')
                           AND a.item_no = p_item_no
                           AND TRUNC (b.eff_date) <= TRUNC (p_eff_date)
                           --AND NVL(B.endt_expiry_date,B.expiry_date) >= variables.v_eff_date
                           --AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date),
                           --      b.expiry_date, :b5402.expiry_date, b.endt_expiry_date))
                           --      >= variables.v_eff_date
                           AND TRUNC (DECODE (NVL (b.endt_expiry_date,
                                                   b.expiry_date
                                                  ),
                                              b.expiry_date, p_expiry_date,
                                              b.expiry_date, b.endt_expiry_date
                                             )
                                     ) >= TRUNC (p_eff_date)
                           AND NVL (b.endt_seq_no, 0) > 0
                      -- to query records from endt. only
                      ORDER BY b.eff_date DESC)
         LOOP
            v_gipi_par_ah.ann_tsi_amt := NVL (endt.ann_tsi_amt, 0);
            v_gipi_par_ah.ann_prem_amt := NVL (endt.ann_prem_amt, 0);
            amt_sw := 'Y';
            EXIT;
         END LOOP;

         --no endt. records found, retrieved amounts from the policy
         IF amt_sw = 'N'
         THEN
            FOR pol IN (SELECT a.ann_tsi_amt, a.ann_prem_amt
                          FROM gipi_item a, gipi_polbasic b
                         WHERE b.line_cd = p_line_cd
                           AND b.subline_cd = p_subline_cd
                           AND b.iss_cd = p_iss_cd
                           AND b.issue_yy = p_issue_yy
                           AND b.pol_seq_no = p_pol_seq_no
                           AND b.renew_no = p_renew_no
                           AND b.policy_id = a.policy_id
                           -- lian 111601 added pol_flag = 'X'
                           AND b.pol_flag IN ('1', '2', '3', 'X')
                           AND a.item_no = p_item_no
                           AND NVL (b.endt_seq_no, 0) = 0)
            LOOP
               v_gipi_par_ah.ann_tsi_amt := pol.ann_tsi_amt;
               v_gipi_par_ah.ann_prem_amt := pol.ann_prem_amt;
               EXIT;
            END LOOP;
         END IF;
      ELSE
         /*ASI 102199 extract ann_tsi_amt , ann_prem_amt of item. Recomputation of annualized
          **    amounts is consider only if policy has existing expired short term endorsements
          */  --extract_ann_amt2 in module

         --v_ann_prem1 := 0;
         --v_ann_tsi1 := 0;
         FOR a2 IN
            (SELECT   a.tsi_amt tsi, a.prem_amt prem, b.eff_date,
                      b.endt_expiry_date, b.expiry_date, b.prorate_flag,
                      NVL (b.comp_sw, 'N') comp_sw,
                      b.short_rt_percent short_rt, a.peril_cd
                 FROM gipi_itmperil a, gipi_polbasic b
                WHERE b.line_cd = p_line_cd
                  AND b.subline_cd = p_subline_cd
                  AND b.iss_cd = p_iss_cd
                  AND b.issue_yy = p_issue_yy
                  AND b.pol_seq_no = p_pol_seq_no
                  AND b.renew_no = p_renew_no
                  AND b.policy_id = a.policy_id
                  AND a.item_no = p_item_no
                  AND b.pol_flag IN ('1', '2', '3', 'X')
                  --ASI 081299 add this validation so that data that will be retrieved
                  --           is only those from endorsement prior to the current endorsement
                  --           this was consider because of the backward endorsement
                        /*bdarusin, feb132003, changes were made to correct retrieved ann_tsi_amt for gipi_witem*/
                  --AND TRUNC(B.eff_date)    <=  TRUNC(variables.v_eff_date)--bdarusin,commented out, feb132003
                  AND TRUNC (NVL (b.endt_expiry_date, b.expiry_date)) >=
                                                            TRUNC (p_eff_date)
                                               --bdarusin,uncomment, feb132003
                  /* AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
                       variables.v_expiry_date, b.expiry_date,b.endt_expiry_date)) >= TRUNC(variables.v_eff_date)*/--bdarusin, commented out, feb132003
                  AND TRUNC (b.eff_date) <=
                         DECODE
                              (NVL (b.endt_seq_no, 0),
                               0, TRUNC (b.eff_date),
                               TRUNC (p_eff_date)
                              )                    --bdarusin,added, feb132003
             ORDER BY b.eff_date DESC)
         LOOP
            v_comp_prem := 0;

            IF a2.prorate_flag = 1
            THEN
               IF a2.endt_expiry_date <= a2.eff_date
               THEN
                  --MSG_ALERT('Your endorsement expiry date is equal to or less than your effectivity date.'||
                         --   ' Restricted condition.','E',TRUE);
                  v_gipi_par_ah.restricted_condition := 'Y';
                  NULL;
               ELSE
                  IF a2.comp_sw = 'Y'
                  THEN
                     v_prorate :=
                          (  (TRUNC (a2.endt_expiry_date)
                              - TRUNC (a2.eff_date)
                             )
                           + 1
                          )
                        / (ADD_MONTHS (a2.eff_date, 12) - a2.eff_date);
                  ELSIF a2.comp_sw = 'M'
                  THEN
                     v_prorate :=
                          (  (TRUNC (a2.endt_expiry_date)
                              - TRUNC (a2.eff_date)
                             )
                           - 1
                          )
                        / (ADD_MONTHS (a2.eff_date, 12) - a2.eff_date);
                  ELSE
                     v_prorate :=
                          (TRUNC (a2.endt_expiry_date) - TRUNC (a2.eff_date)
                          )
                        / (ADD_MONTHS (a2.eff_date, 12) - a2.eff_date);
                  END IF;
               END IF;

               /*modified by bdarusin, mar072003, to resolve ora01476 divisor is equal to zero*/
               IF TRUNC (a2.eff_date) = TRUNC (a2.endt_expiry_date)
               THEN
                  v_prorate := 1;
               END IF;

               v_comp_prem := a2.prem / v_prorate;
            ELSIF a2.prorate_flag = 2
            THEN
               v_comp_prem := a2.prem;
            ELSE
               v_comp_prem := a2.prem / (a2.short_rt / 100);
            END IF;

            v_gipi_par_ah.ann_prem_amt := NVL (p_ann_prem_amt, 0)
                                          + v_comp_prem;

            FOR TYPE IN (SELECT peril_type
                           FROM giis_peril
                          WHERE line_cd = p_line_cd AND peril_cd = a2.peril_cd)
            LOOP
               IF TYPE.peril_type = 'B'
               THEN
                  --v_ann_tsi1 := v_ann_tsi1 + a2.tsi;
                  v_gipi_par_ah.ann_tsi_amt := NVL (p_ann_tsi_amt, 0)
                                               + a2.tsi;
               END IF;
            END LOOP;
         END LOOP;
      --end
      END IF;

      IF v_max_endt_seq_no = v_max_endt_seq_no1
      THEN
         FOR a1 IN a
         LOOP
            --:b480.pol_exist_sw := 'Y';
            FOR b1 IN b (a1.policy_id)
            LOOP
               IF v_eff_date IS NULL
               THEN
                  v_eff_date := a1.eff_date;
                  v_gipi_par_ah.currency_cd := b1.currency_cd;
                  v_gipi_par_ah.currency_rt := b1.currency_rt;
                  v_gipi_par_ah.item_title := b1.item_title;
                  v_gipi_par_ah.group_cd := b1.group_cd;
                  v_gipi_par_ah.coverage_cd := b1.coverage_cd;
                  v_gipi_par_ah.from_date := b1.from_date;
                  v_gipi_par_ah.TO_DATE := b1.TO_DATE;             --bdarusin
                  v_gipi_par_ah.changed_tag := b1.changed_tag;     --bdarusin
                  v_gipi_par_ah.prorate_flag := b1.prorate_flag;   --bdarusin
                  v_gipi_par_ah.comp_sw := b1.comp_sw;             --bdarusin
                  v_gipi_par_ah.short_rt_percent := b1.short_rt_percent;
                  --bdarusin
                  v_new_item := 'N';
               END IF;

               IF a1.eff_date > v_eff_date
               THEN
                  v_eff_date := a1.eff_date;
                  v_gipi_par_ah.currency_cd := b1.currency_cd;
                  v_gipi_par_ah.currency_rt := b1.currency_rt;
                  v_gipi_par_ah.item_title := b1.item_title;
                  v_gipi_par_ah.group_cd := b1.group_cd;
                  v_gipi_par_ah.coverage_cd := b1.coverage_cd;
                  v_gipi_par_ah.from_date := b1.from_date;         --bdarusin
                  v_gipi_par_ah.TO_DATE := b1.TO_DATE;             --bdarusin
                  v_gipi_par_ah.changed_tag := b1.changed_tag;     --bdarusin
                  v_gipi_par_ah.prorate_flag := b1.prorate_flag;   --bdarusin
                  v_gipi_par_ah.comp_sw := b1.comp_sw;             --bdarusin
                  v_gipi_par_ah.short_rt_percent := b1.short_rt_percent;
                  --bdarusin
                  v_new_item := 'N';
               END IF;
            END LOOP;

            /*
            FOR C1 IN C(:b480.currency_cd) LOOP
                :b480.dsp_currency_desc  :=  c1.currency_desc;
                :b480.currency_rt        :=  c1.currency_rt;
                :b480.dsp_short_name     :=  c1.short_name;
            END LOOP;*/
            EXIT;
         END LOOP;
      ELSE
         FOR a1 IN a
         LOOP
            --:b480.pol_exist_sw := 'Y';
            FOR b1 IN b (a1.policy_id)
            LOOP
               IF v_eff_date IS NULL
               THEN
                  v_eff_date := a1.eff_date;
                  v_gipi_par_ah.currency_cd := b1.currency_cd;
                  v_gipi_par_ah.currency_rt := b1.currency_rt;
                  v_gipi_par_ah.item_title := b1.item_title;
                  v_gipi_par_ah.group_cd := b1.group_cd;
                  v_gipi_par_ah.coverage_cd := b1.coverage_cd;
                  v_gipi_par_ah.from_date := b1.from_date;         --bdarusin
                  v_gipi_par_ah.TO_DATE := b1.TO_DATE;             --bdarusin
                  v_gipi_par_ah.changed_tag := b1.changed_tag;     --bdarusin
                  v_gipi_par_ah.prorate_flag := b1.prorate_flag;   --bdarusin
                  v_gipi_par_ah.comp_sw := b1.comp_sw;             --bdarusin
                  v_gipi_par_ah.short_rt_percent := b1.short_rt_percent;
                  --bdarusin
                  v_new_item := 'N';
               END IF;

               IF a1.eff_date > v_eff_date
               THEN
                  v_eff_date := a1.eff_date;
                  v_gipi_par_ah.currency_cd := b1.currency_cd;
                  v_gipi_par_ah.currency_rt := b1.currency_rt;
                  v_gipi_par_ah.item_title := b1.item_title;
                  v_gipi_par_ah.group_cd := b1.group_cd;
                  v_gipi_par_ah.coverage_cd := b1.coverage_cd;
                  v_gipi_par_ah.from_date := b1.from_date;         --bdarusin
                  v_gipi_par_ah.TO_DATE := b1.TO_DATE;             --bdarusin
                  v_gipi_par_ah.changed_tag := b1.changed_tag;     --bdarusin
                  v_gipi_par_ah.prorate_flag := b1.prorate_flag;   --bdarusin
                  v_gipi_par_ah.comp_sw := b1.comp_sw;             --bdarusin
                  v_gipi_par_ah.short_rt_percent := b1.short_rt_percent;
                  --bdarusin
                  v_new_item := 'N';
               END IF;
            END LOOP;

            FOR e1 IN e (a1.policy_id)
            LOOP
               v_gipi_par_ah.position_cd := e1.position_cd;
               v_gipi_par_ah.monthly_salary := e1.monthly_salary;
               v_gipi_par_ah.salary_grade := e1.salary_grade;
               v_gipi_par_ah.no_of_persons := e1.no_of_persons;
               v_gipi_par_ah.destination := e1.destination;
            /*
              DECLARE
                   CURSOR A IS
                     SELECT    position
                       FROM    giis_position
                      WHERE    position_cd = v_gipi_par_ah.position_cd;
               BEGIN
                   OPEN   A;
                  FETCH   A
                   INTO   v_gipi_par_ah.position;
                     IF A%notfound THEN
                        v_gipi_par_ah.position := NULL;
                     END IF;
                  CLOSE   A;
               END;*/
            END LOOP;

            /*
            FOR C1 IN C(:b480.currency_cd) LOOP
                :b480.dsp_currency_desc  :=  c1.currency_desc;
                :b480.currency_rt        :=  c1.currency_rt;
                :b480.dsp_short_name     :=  c1.short_name;
            END LOOP;*/
            EXIT;
         END LOOP;
      END IF;

      IF v_new_item = 'Y'
      THEN
         FOR a1 IN (SELECT main_currency_cd, currency_desc, currency_rt
                      FROM giis_currency
                     WHERE currency_rt = 1)
         LOOP
            v_gipi_par_ah.currency_cd := a1.main_currency_cd;
            -- v_gipi_par_ah.dsp_currency_desc   := a1.currency_desc;
            v_gipi_par_ah.currency_rt := a1.currency_rt;
            EXIT;
         END LOOP;

         v_gipi_par_ah.rec_flag := 'A';
         v_gipi_par_ah.item_title := '';
         v_gipi_par_ah.ann_tsi_amt := NVL (NULL, 0);
         v_gipi_par_ah.ann_prem_amt := NVL (NULL, 0);
      ELSE
         v_gipi_par_ah.rec_flag := 'C';
      END IF;

      FOR n IN (SELECT   a.region_cd region_cd, b.region_desc region_desc
                    FROM gipi_item a, giis_region b, gipi_polbasic c
                   WHERE 1 = 1
                     --LINK GIPI_ITEM AND GIPI_POLBASIC
                     AND a.policy_id = c.policy_id
                     --FILTER POLBASIC
                     AND c.line_cd = p_line_cd
                     AND c.subline_cd = p_subline_cd
                     AND NVL (c.iss_cd, c.iss_cd) = p_iss_cd
                     AND c.issue_yy = p_issue_yy
                     AND c.pol_seq_no = p_pol_seq_no
                     AND c.renew_no = p_renew_no
                     AND a.item_no = p_item_no
                     AND c.pol_flag IN ('1', '2', '3', 'X')
                     --LINK GIIS_REGION AND GIPI_ITEM
                     AND a.region_cd = b.region_cd
                     AND a.region_cd IS NOT NULL
                     --FILTER OF GIPI_ITEM
                     AND NOT EXISTS (
                            SELECT a.region_cd region_cd
                              FROM gipi_item e, gipi_polbasic d
                             WHERE d.line_cd = p_line_cd
                               AND d.subline_cd = p_subline_cd
                               AND NVL (d.iss_cd, d.iss_cd) = p_iss_cd
                               AND d.issue_yy = p_issue_yy
                               AND d.pol_seq_no = p_pol_seq_no
                               AND d.renew_no = p_renew_no
                               AND e.item_no = p_item_no
                               AND e.policy_id = d.policy_id
                               AND e.region_cd IS NOT NULL
                               AND d.pol_flag IN ('1', '2', '3', 'X')
                               AND NVL (d.back_stat, 5) = 2
                               AND d.endt_seq_no > c.endt_seq_no)
                ORDER BY c.eff_date DESC)
      LOOP
         --IF n.region_cd IS NOT NULL THEN
         v_gipi_par_ah.region_cd := n.region_cd;
         --:b480.dsp_region_desc := n.region_desc;
         EXIT;
      --END IF;
      END LOOP;

      PIPE ROW (v_gipi_par_ah);
      RETURN;
   END;

   FUNCTION pre_insert_witem_acc (
      p_line_cd       gipi_wpolbas.line_cd%TYPE,
      p_iss_cd        gipi_wpolbas.iss_cd%TYPE,
      p_subline_cd    gipi_wpolbas.subline_cd%TYPE,
      p_issue_yy      gipi_wpolbas.issue_yy%TYPE,
      p_pol_seq_no    gipi_wpolbas.pol_seq_no%TYPE,
      p_item_no       gipi_witem.item_no%TYPE,
      p_currency_cd   gipi_witem.currency_cd%TYPE
   )
      RETURN NUMBER
   IS
      v_curr       NUMBER (2)                    := 0;
      p_eff_date   gipi_polbasic.eff_date%TYPE;
      v_eff_date   gipi_polbasic.eff_date%TYPE;

      CURSOR a (po_eff_date gipi_wpolbas.eff_date%TYPE)
      IS
         SELECT   a.policy_id policy_id, a.eff_date eff_date
             FROM gipi_polbasic a
            WHERE a.line_cd = p_line_cd
              AND a.iss_cd = p_iss_cd
              AND a.subline_cd = p_subline_cd
              AND a.issue_yy = p_issue_yy
              AND a.pol_seq_no = p_pol_seq_no
              AND a.pol_flag IN ('1', '2', '3', 'X')
              AND NVL (a.endt_expiry_date, a.expiry_date) > po_eff_date
              AND EXISTS (
                     SELECT '1'
                       FROM gipi_item b
                      WHERE b.item_no = p_item_no
                            AND b.policy_id = a.policy_id)
         ORDER BY eff_date DESC;

      CURSOR b (p_policy_id gipi_item.policy_id%TYPE)
      IS
         SELECT NVL (ann_tsi_amt, 0) ann_tsi_amt,
                NVL (ann_prem_amt, 0) ann_prem_amt, currency_cd, currency_rt
           FROM gipi_item
          WHERE policy_id = p_policy_id AND item_no = p_item_no;
   BEGIN
      FOR i IN (SELECT eff_date
                  FROM gipi_wpolbas
                 WHERE line_cd = p_line_cd
                   AND subline_cd = p_subline_cd
                   AND iss_cd = p_iss_cd
                   AND issue_yy = p_issue_yy
                   AND pol_seq_no = p_pol_seq_no)
      LOOP
         v_eff_date := i.eff_date;
      END LOOP;

      FOR a1 IN a (v_eff_date)
      LOOP
         FOR b1 IN b (a1.policy_id)
         LOOP
            IF p_eff_date IS NULL
            THEN
               p_eff_date := a1.eff_date;

               IF p_currency_cd != b1.currency_cd
               THEN
                  v_curr := b1.currency_cd;
               END IF;
            END IF;

            IF a1.eff_date > p_eff_date
            THEN
               p_eff_date := a1.eff_date;

               IF p_currency_cd != b1.currency_cd
               THEN
                  v_curr := b1.currency_cd;
               END IF;
            END IF;
         END LOOP;

         EXIT;
      END LOOP;

      RETURN v_curr;
   END pre_insert_witem_acc;

   -- added for pre insert - irwin
   FUNCTION pre_insert_witem_endt_acc (
      p_line_cd       gipi_wpolbas.line_cd%TYPE,
      p_iss_cd        gipi_wpolbas.iss_cd%TYPE,
      p_subline_cd    gipi_wpolbas.subline_cd%TYPE,
      p_issue_yy      gipi_wpolbas.issue_yy%TYPE,
      p_pol_seq_no    gipi_wpolbas.pol_seq_no%TYPE,
      p_item_no       gipi_witem.item_no%TYPE,
      p_currency_cd   gipi_witem.currency_cd%TYPE,
      p_eff_date      gipi_wpolbas.eff_date%TYPE
   )
      RETURN gipi_waccident_item_tab PIPELINED
   IS
      v_acc   gipi_waccident_item_type;
      p_eff_date2     GIPI_POLBASIC.eff_date%TYPE;

      CURSOR a
      IS
         SELECT   a.policy_id policy_id, a.eff_date eff_date
             FROM gipi_polbasic a
            WHERE a.line_cd = p_line_cd
              AND a.iss_cd = p_iss_cd
              AND a.subline_cd = p_subline_cd
              AND a.issue_yy = p_issue_yy
              AND a.pol_seq_no = p_pol_seq_no
              AND a.pol_flag IN ('1', '2', '3', 'X')
              AND NVL (a.endt_expiry_date, a.expiry_date) >= p_eff_date
              AND EXISTS (
                     SELECT '1'
                       FROM gipi_item b
                      WHERE b.item_no = p_item_no
                            AND b.policy_id = a.policy_id)
         ORDER BY eff_date DESC;

      CURSOR b (p_policy_id gipi_item.policy_id%TYPE)
      IS
         SELECT NVL (ann_tsi_amt, 0) ann_tsi_amt,
                NVL (ann_prem_amt, 0) ann_prem_amt, currency_cd, currency_rt
           FROM gipi_item
          WHERE policy_id = p_policy_id AND item_no = p_item_no;
   BEGIN
      v_acc.restricted_condition := 'N';
      v_acc.restricted_condition2 := 'N';
      FOR a1 IN a
      LOOP
         FOR b1 IN b (a1.policy_id)
         LOOP
            IF p_eff_date2 IS NULL
            THEN
               p_eff_date2 := a1.eff_date;

               --:b480.ann_tsi_amt  :=  B1.ann_tsi_amt;
               --:b480.ann_prem_amt :=  B1.ann_prem_amt;
               IF p_currency_cd != b1.currency_cd
               THEN
                 v_acc.restricted_condition := '1';
                 -- SWITCH.EXECUTE_QUERY := 'Y';
                  v_acc.currency_cd := b1.currency_cd;
                  -- :b480.currency_rt := b1.currency_rt;
               END IF;
            END IF;

            IF a1.eff_date > p_eff_date2
            THEN
               p_eff_date2 := a1.eff_date;
               v_acc.restricted_condition := '2';
               v_acc.ann_tsi_amt := b1.ann_tsi_amt;
               v_acc.ann_prem_amt := b1.ann_prem_amt;

               IF p_currency_cd != b1.currency_cd
               THEN
                  v_acc.restricted_condition := 'Y';
                  --SWITCH.EXECUTE_QUERY := 'Y';
                  v_acc.currency_cd := b1.currency_cd;
                  --v_acc.currency_rt := b1.currency_rt;
               END IF;
            END IF;
         END LOOP;

         EXIT;
      END LOOP;

      PIPE ROW (v_acc);
      RETURN;
   END;

   PROCEDURE update_wpolbas_accident (
      p_par_id             IN   gipi_witem.par_id%TYPE,
      p_negate_item        IN   VARCHAR2,
      p_prorate_flag       IN   gipi_wpolbas.prorate_flag%TYPE,
      p_comp_sw            IN   VARCHAR2,
      p_endt_expiry_date   IN   VARCHAR2,
      p_eff_date           IN   VARCHAR2,
      p_short_rt_percent   IN   gipi_wpolbas.short_rt_percent%TYPE,
      p_expiry_date        IN   VARCHAR2
   )
   IS
      v_tsi                 gipi_wpolbas.tsi_amt%TYPE            := 0;
      v_ann_tsi             gipi_wpolbas.ann_tsi_amt%TYPE        := 0;
      v_prem                gipi_wpolbas.prem_amt%TYPE           := 0;
      v_ann_prem            gipi_wpolbas.ann_prem_amt%TYPE       := 0;
      v_ann_tsi2            gipi_wpolbas.ann_tsi_amt%TYPE        := 0;
      v_ann_prem2           gipi_wpolbas.ann_prem_amt%TYPE       := 0;
      v_prorate             NUMBER (12, 9);
      v_no_of_items         NUMBER;
      v_comp_prem           gipi_wpolbas.prem_amt%TYPE           := 0;
      expired_sw            VARCHAR2 (1)                         := 'N';
      v_exist               VARCHAR2 (1);
      v_line_cd             gipi_wpolbas.line_cd%TYPE;
      v_iss_cd              gipi_wpolbas.iss_cd%TYPE;
      v_subline_cd          gipi_wpolbas.subline_cd%TYPE;
      v_issue_yy            gipi_wpolbas.issue_yy%TYPE;
      v_pol_seq_no          gipi_wpolbas.pol_seq_no%TYPE;
      v_renew_no            gipi_wpolbas.renew_no%TYPE;
      v_eff_date            gipi_wpolbas.eff_date%TYPE;
      v_line_cd2            gipi_parlist.line_cd%TYPE;
      v_endt_expiry_date2   gipi_wpolbas.endt_expiry_date%TYPE;
      v_eff_date2           gipi_wpolbas.eff_date%TYPE;
      v_expiry_date2        gipi_wpolbas.expiry_date%TYPE;
   BEGIN
      v_endt_expiry_date2 :=
         TO_DATE (NVL (p_endt_expiry_date,
                       TO_CHAR (SYSDATE, 'MM/DD/RRRR HH:MI:SS AM')
                      ),
                  'MM/DD/RRRR HH:MI:SS AM'
                 );
      v_eff_date2 :=
         TO_DATE (NVL (p_eff_date,
                       TO_CHAR (SYSDATE, 'MM/DD/RRRR HH:MI:SS AM')),
                  'MM/DD/RRRR HH:MI:SS AM'
                 );
      v_expiry_date2 :=
         TO_DATE (NVL (p_expiry_date,
                       TO_CHAR (SYSDATE, 'MM/DD/RRRR HH:MI:SS AM')
                      ),
                  'MM/DD/RRRR HH:MI:SS AM'
                 );

      SELECT line_cd, iss_cd, subline_cd, issue_yy, pol_seq_no,
             renew_no, eff_date
        INTO v_line_cd, v_iss_cd, v_subline_cd, v_issue_yy, v_pol_seq_no,
             v_renew_no, v_eff_date
        FROM gipi_wpolbas
       WHERE par_id = p_par_id;

      SELECT line_cd
        INTO v_line_cd2
        FROM gipi_parlist
       WHERE par_id = p_par_id;

      FOR a1 IN (SELECT SUM (NVL (tsi_amt, 0) * NVL (currency_rt, 1)) tsi,
                        SUM (NVL (prem_amt, 0) * NVL (currency_rt, 1)) prem,
                        COUNT (item_no) no_of_items
                   FROM gipi_witem
                  WHERE par_id = p_par_id)
      LOOP
         v_ann_tsi := v_ann_tsi + a1.tsi;
         v_tsi := v_tsi + a1.tsi;
         v_prem := v_prem + a1.prem;
         v_no_of_items := NVL (a1.no_of_items, 0);

         IF NVL (p_negate_item, 'N') = 'Y'
         THEN
            v_ann_prem := v_ann_prem + a1.prem;
         ELSE

            IF p_prorate_flag = 2
            THEN
               v_ann_prem := v_ann_prem + a1.prem;
            ELSIF p_prorate_flag = 1
            THEN
               IF p_comp_sw = 'Y'
               THEN
                  v_prorate :=
                       ((TRUNC (v_endt_expiry_date2) - TRUNC (v_eff_date2))
                        + 1
                       )
                     / (ADD_MONTHS (v_eff_date2, 12) - v_eff_date2);
               ELSIF p_comp_sw = 'M'
               THEN
                  v_prorate :=
                       ((TRUNC (v_endt_expiry_date2) - TRUNC (v_eff_date2))
                        - 1
                       )
                     / (ADD_MONTHS (v_eff_date2, 12) - v_eff_date2);
               ELSE
                  v_prorate :=
                       (TRUNC (v_endt_expiry_date2) - TRUNC (v_eff_date2)
                       )
                     / (ADD_MONTHS (v_eff_date2, 12) - v_eff_date2);
               END IF;

               IF TRUNC (v_eff_date2) = TRUNC (v_endt_expiry_date2)
               THEN
                  v_prorate := 1;
               END IF;

               v_ann_prem := v_ann_prem + (a1.prem / (v_prorate));
            ELSE
               v_ann_prem :=
                  v_ann_prem
                  + (a1.prem / (NVL (p_short_rt_percent, 1) / 100));
            END IF;
         END IF;
      END LOOP;

      expired_sw := 'N';

      FOR sw IN (SELECT   '1'
                     FROM gipi_itmperil a, gipi_polbasic b
                    WHERE b.line_cd = v_line_cd
                      AND b.subline_cd = v_subline_cd
                      AND b.iss_cd = v_iss_cd
                      AND b.issue_yy = v_issue_yy
                      AND b.pol_seq_no = v_pol_seq_no
                      AND b.renew_no = v_renew_no
                      AND b.policy_id = a.policy_id
                      AND b.pol_flag IN ('1', '2', '3', 'X')
                      AND (a.prem_amt <> 0 OR a.tsi_amt <> 0)
                      AND TRUNC (b.eff_date) <= TRUNC (v_eff_date)
                      AND TRUNC (DECODE (NVL (b.endt_expiry_date,
                                              b.expiry_date
                                             ),
                                         b.expiry_date, v_expiry_date2,
                                         b.expiry_date, b.endt_expiry_date
                                        )
                                ) < v_eff_date
                 ORDER BY b.eff_date DESC)
      LOOP
         expired_sw := 'Y';
         EXIT;
      END LOOP;

      IF NVL (expired_sw, 'N') = 'N'
      THEN
         v_exist := 'N';

         FOR a2 IN
            (SELECT   b250.ann_tsi_amt ann_tsi, b250.ann_prem_amt ann_prem
                 FROM gipi_wpolbas b, gipi_polbasic b250
                WHERE b.par_id = p_par_id
                  AND b250.line_cd = b.line_cd
                  AND b250.subline_cd = b.subline_cd
                  AND b250.iss_cd = b.iss_cd
                  AND b250.issue_yy = b.issue_yy
                  AND b250.pol_seq_no = b.pol_seq_no
                  AND b250.renew_no = b.renew_no
                  AND b250.pol_flag IN ('1', '2', '3', 'X')
                  AND TRUNC (b250.eff_date) <= TRUNC (b.eff_date)
                  AND (   TRUNC (DECODE (NVL (b250.endt_expiry_date,
                                              b250.expiry_date
                                             ),
                                         b250.expiry_date, v_expiry_date2,
                                         b250.expiry_date, b250.endt_expiry_date
                                        )
                                ) >= v_eff_date
                       OR p_negate_item = 'Y'
                      )
                  AND NVL (b250.endt_seq_no, 0) > 0
             ORDER BY b250.eff_date DESC)
         LOOP
            UPDATE gipi_wpolbas
               SET tsi_amt = NVL (v_tsi, 0),
                   prem_amt = NVL (v_prem, 0),
                   ann_tsi_amt = a2.ann_tsi + NVL (v_ann_tsi, 0),
                   ann_prem_amt = a2.ann_prem + NVL (v_ann_prem, 0),
                   no_of_items = NVL (v_no_of_items, 0)
             WHERE par_id = p_par_id;

            v_exist := 'Y';
            EXIT;
         END LOOP;

         IF v_exist = 'N'
         THEN
            FOR a2 IN (SELECT   b250.tsi_amt tsi, b250.prem_amt prem,
                                b250.ann_tsi_amt ann_tsi,
                                b250.ann_prem_amt ann_prem
                           FROM gipi_wpolbas b, gipi_polbasic b250
                          WHERE b.par_id = p_par_id
                            AND b250.line_cd = b.line_cd
                            AND b250.subline_cd = b.subline_cd
                            AND b250.iss_cd = b.iss_cd
                            AND b250.issue_yy = b.issue_yy
                            AND b250.pol_seq_no = b.pol_seq_no
                            AND b250.renew_no = b.renew_no
                            AND b250.pol_flag IN ('1', '2', '3', 'X')
                            AND NVL (b250.endt_seq_no, 0) = 0
                       ORDER BY b.eff_date DESC)
            LOOP
               UPDATE gipi_wpolbas
                  SET tsi_amt = NVL (v_tsi, 0),
                      prem_amt = NVL (v_prem, 0),
                      ann_tsi_amt = a2.ann_tsi + NVL (v_ann_tsi, 0),
                      ann_prem_amt = a2.ann_prem + NVL (v_ann_prem, 0),
                      no_of_items = NVL (v_no_of_items, 0)
                WHERE par_id = p_par_id;

               EXIT;
            END LOOP;
         END IF;
      ELSE

         FOR a2 IN (SELECT   (c.tsi_amt * a.currency_rt) tsi,
                             (c.prem_amt * a.currency_rt) prem, b.eff_date,
                             b.endt_expiry_date, b.expiry_date,
                             b.prorate_flag, NVL (b.comp_sw, 'N') comp_sw,
                             b.short_rt_percent short_rt, c.peril_cd
                        FROM gipi_item a, gipi_polbasic b, gipi_itmperil c
                       WHERE b.line_cd = v_line_cd
                         AND b.subline_cd = v_subline_cd
                         AND b.iss_cd = v_iss_cd
                         AND b.issue_yy = v_issue_yy
                         AND b.pol_seq_no = v_pol_seq_no
                         AND b.renew_no = v_renew_no
                         AND b.policy_id = a.policy_id
                         AND b.policy_id = c.policy_id
                         AND a.item_no = c.item_no
                         AND b.pol_flag IN ('1', '2', '3', 'X')
                         AND TRUNC (b.eff_date) <=
                                DECODE (NVL (b.endt_seq_no, 0),
                                        0, TRUNC (b.eff_date),
                                        TRUNC (v_eff_date)
                                       )
                         --AND TRUNC(NVL(B.endt_expiry_date,B.expiry_date)) >= TRUNC(v_eff_date)
                         AND (   TRUNC (DECODE (NVL (b.endt_expiry_date,
                                                     b.expiry_date
                                                    ),
                                                b.expiry_date, v_expiry_date2,
                                                b.expiry_date, b.endt_expiry_date
                                               )
                                       ) >= TRUNC (v_eff_date)
                              OR p_negate_item = 'Y'
                             )
                    ORDER BY b.eff_date DESC)
         LOOP
            v_comp_prem := 0;

            /** rollie 21feb2006
               disallows recomputation of prem if item_no was negated programmatically
            **/
            IF NVL (p_negate_item, 'N') = 'Y'
            THEN
               v_comp_prem := a2.prem;
            ELSE
               IF a2.prorate_flag = 1
               THEN
                  IF a2.endt_expiry_date <= a2.eff_date
                  THEN
                     --p_message :=
                           --'Your endorsement expiry date is equal to or less than your effectivity date.'
                        --|| ' Restricted condition.';
                     --RETURN;
                     NULL;
                  ELSE
                     IF a2.comp_sw = 'Y'
                     THEN
                        v_prorate :=
                             (  (  TRUNC (a2.endt_expiry_date)
                                 - TRUNC (a2.eff_date)
                                )
                              + 1
                             )
                           / (ADD_MONTHS (a2.eff_date, 12) - a2.eff_date);
                     ELSIF a2.comp_sw = 'M'
                     THEN
                        v_prorate :=
                             (  (  TRUNC (a2.endt_expiry_date)
                                 - TRUNC (a2.eff_date)
                                )
                              - 1
                             )
                           / (ADD_MONTHS (a2.eff_date, 12) - a2.eff_date);
                     ELSE
                        v_prorate :=
                             (TRUNC (a2.endt_expiry_date)
                              - TRUNC (a2.eff_date)
                             )
                           / (ADD_MONTHS (a2.eff_date, 12) - a2.eff_date);
                     END IF;
                  END IF;

                  IF TRUNC (v_eff_date2) = TRUNC (v_endt_expiry_date2)
                  THEN
                     v_prorate := 1;
                  END IF;

                  v_comp_prem := a2.prem / v_prorate;
               ELSIF a2.prorate_flag = 2
               THEN
                  v_comp_prem := a2.prem;
               ELSE
                  v_comp_prem := a2.prem / (a2.short_rt / 100);
               END IF;
            END IF;

            v_ann_prem2 := v_ann_prem2 + v_comp_prem;

            FOR TYPE IN (SELECT peril_type
                           FROM giis_peril
                          WHERE line_cd = v_line_cd2
                                AND peril_cd = a2.peril_cd)
            LOOP
               IF TYPE.peril_type = 'B'
               THEN
                  v_ann_tsi2 := v_ann_tsi2 + a2.tsi;
               END IF;
            END LOOP;
         END LOOP;

         UPDATE gipi_wpolbas
            SET tsi_amt = NVL (v_tsi, 0),
                prem_amt = NVL (v_prem, 0),
                ann_tsi_amt = NVL (v_ann_tsi, 0) + NVL (v_ann_tsi2, 0),
                ann_prem_amt = NVL (v_ann_prem, 0) + NVL (v_ann_prem2, 0),
                no_of_items = NVL (v_no_of_items, 0)
          WHERE par_id = p_par_id;
          NULL;
      END IF;
   END;

   FUNCTION check_update_wpolbas_validity (
      p_par_id             IN   gipi_witem.par_id%TYPE,
      p_negate_item        IN   VARCHAR2,
      p_prorate_flag       IN   gipi_wpolbas.prorate_flag%TYPE,
      p_comp_sw            IN   VARCHAR2,
      p_endt_expiry_date   IN   VARCHAR2,
      p_eff_date           IN   VARCHAR2,
      p_short_rt_percent   IN   gipi_wpolbas.short_rt_percent%TYPE,
      p_expiry_date        IN   VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_tsi                 gipi_wpolbas.tsi_amt%TYPE            := 0;
      v_ann_tsi             gipi_wpolbas.ann_tsi_amt%TYPE        := 0;
      v_prem                gipi_wpolbas.prem_amt%TYPE           := 0;
      v_ann_prem            gipi_wpolbas.ann_prem_amt%TYPE       := 0;
      v_ann_tsi2            gipi_wpolbas.ann_tsi_amt%TYPE        := 0;
      v_ann_prem2           gipi_wpolbas.ann_prem_amt%TYPE       := 0;
      v_prorate             NUMBER (12, 9);
      v_no_of_items         NUMBER;
      v_comp_prem           gipi_wpolbas.prem_amt%TYPE           := 0;
      expired_sw            VARCHAR2 (1)                         := 'N';
      v_exist               VARCHAR2 (1);
      v_line_cd             gipi_wpolbas.line_cd%TYPE;
      v_iss_cd              gipi_wpolbas.iss_cd%TYPE;
      v_subline_cd          gipi_wpolbas.subline_cd%TYPE;
      v_issue_yy            gipi_wpolbas.issue_yy%TYPE;
      v_pol_seq_no          gipi_wpolbas.pol_seq_no%TYPE;
      v_renew_no            gipi_wpolbas.renew_no%TYPE;
      v_eff_date            gipi_wpolbas.eff_date%TYPE;
      v_line_cd2            gipi_parlist.line_cd%TYPE;
      v_endt_expiry_date2   gipi_wpolbas.endt_expiry_date%TYPE;
      v_eff_date2           gipi_wpolbas.eff_date%TYPE;
      v_expiry_date2        gipi_wpolbas.expiry_date%TYPE;
      p_message             VARCHAR2(100) := '';
   BEGIN
      v_endt_expiry_date2 :=
         TO_DATE (NVL (p_endt_expiry_date,
                       TO_CHAR (SYSDATE, 'MM/DD/RRRR HH:MI:SS AM')
                      ),
                  'MM/DD/RRRR HH:MI:SS AM'
                 );
      v_eff_date2 :=
         TO_DATE (NVL (p_eff_date,
                       TO_CHAR (SYSDATE, 'MM/DD/RRRR HH:MI:SS AM')),
                  'MM/DD/RRRR HH:MI:SS AM'
                 );
      v_expiry_date2 :=
         TO_DATE (NVL (p_expiry_date,
                       TO_CHAR (SYSDATE, 'MM/DD/RRRR HH:MI:SS AM')
                      ),
                  'MM/DD/RRRR HH:MI:SS AM'
                 );

      SELECT line_cd, iss_cd, subline_cd, issue_yy, pol_seq_no,
             renew_no, eff_date
        INTO v_line_cd, v_iss_cd, v_subline_cd, v_issue_yy, v_pol_seq_no,
             v_renew_no, v_eff_date
        FROM gipi_wpolbas
       WHERE par_id = p_par_id;

      SELECT line_cd
        INTO v_line_cd2
        FROM gipi_parlist
       WHERE par_id = p_par_id;

      FOR a1 IN (SELECT SUM (NVL (tsi_amt, 0) * NVL (currency_rt, 1)) tsi,
                        SUM (NVL (prem_amt, 0) * NVL (currency_rt, 1)) prem,
                        COUNT (item_no) no_of_items
                   FROM gipi_witem
                  WHERE par_id = p_par_id)
      LOOP
         v_ann_tsi := v_ann_tsi + a1.tsi;
         v_tsi := v_tsi + a1.tsi;
         v_prem := v_prem + a1.prem;
         v_no_of_items := NVL (a1.no_of_items, 0);

         IF NVL (p_negate_item, 'N') = 'Y'
         THEN
            v_ann_prem := v_ann_prem + a1.prem;
         ELSE

            IF p_prorate_flag = 2
            THEN
               v_ann_prem := v_ann_prem + a1.prem;
            ELSIF p_prorate_flag = 1
            THEN
               IF p_comp_sw = 'Y'
               THEN
                  v_prorate :=
                       ((TRUNC (v_endt_expiry_date2) - TRUNC (v_eff_date2))
                        + 1
                       )
                     / (ADD_MONTHS (v_eff_date2, 12) - v_eff_date2);
               ELSIF p_comp_sw = 'M'
               THEN
                  v_prorate :=
                       ((TRUNC (v_endt_expiry_date2) - TRUNC (v_eff_date2))
                        - 1
                       )
                     / (ADD_MONTHS (v_eff_date2, 12) - v_eff_date2);
               ELSE
                  v_prorate :=
                       (TRUNC (v_endt_expiry_date2) - TRUNC (v_eff_date2)
                       )
                     / (ADD_MONTHS (v_eff_date2, 12) - v_eff_date2);
               END IF;

               IF TRUNC (v_eff_date2) = TRUNC (v_endt_expiry_date2)
               THEN
                  v_prorate := 1;
               END IF;

               v_ann_prem := v_ann_prem + (a1.prem / (v_prorate));
            ELSE
               v_ann_prem :=
                  v_ann_prem
                  + (a1.prem / (NVL (p_short_rt_percent, 1) / 100));
            END IF;
         END IF;
      END LOOP;

      expired_sw := 'N';

      FOR sw IN (SELECT   '1'
                     FROM gipi_itmperil a, gipi_polbasic b
                    WHERE b.line_cd = v_line_cd
                      AND b.subline_cd = v_subline_cd
                      AND b.iss_cd = v_iss_cd
                      AND b.issue_yy = v_issue_yy
                      AND b.pol_seq_no = v_pol_seq_no
                      AND b.renew_no = v_renew_no
                      AND b.policy_id = a.policy_id
                      AND b.pol_flag IN ('1', '2', '3', 'X')
                      AND (a.prem_amt <> 0 OR a.tsi_amt <> 0)
                      AND TRUNC (b.eff_date) <= TRUNC (v_eff_date)
                      AND TRUNC (DECODE (NVL (b.endt_expiry_date,
                                              b.expiry_date
                                             ),
                                         b.expiry_date, v_expiry_date2,
                                         b.expiry_date, b.endt_expiry_date
                                        )
                                ) < v_eff_date
                 ORDER BY b.eff_date DESC)
      LOOP
         expired_sw := 'Y';
         EXIT;
      END LOOP;

      IF NVL (expired_sw, 'N') = 'N'
      THEN
         v_exist := 'N';

         FOR a2 IN
            (SELECT   b250.ann_tsi_amt ann_tsi, b250.ann_prem_amt ann_prem
                 FROM gipi_wpolbas b, gipi_polbasic b250
                WHERE b.par_id = p_par_id
                  AND b250.line_cd = b.line_cd
                  AND b250.subline_cd = b.subline_cd
                  AND b250.iss_cd = b.iss_cd
                  AND b250.issue_yy = b.issue_yy
                  AND b250.pol_seq_no = b.pol_seq_no
                  AND b250.renew_no = b.renew_no
                  AND b250.pol_flag IN ('1', '2', '3', 'X')
                  AND TRUNC (b250.eff_date) <= TRUNC (b.eff_date)
                  AND (   TRUNC (DECODE (NVL (b250.endt_expiry_date,
                                              b250.expiry_date
                                             ),
                                         b250.expiry_date, v_expiry_date2,
                                         b250.expiry_date, b250.endt_expiry_date
                                        )
                                ) >= v_eff_date
                       OR p_negate_item = 'Y'
                      )
                  AND NVL (b250.endt_seq_no, 0) > 0
             ORDER BY b250.eff_date DESC)
         LOOP
            /*UPDATE gipi_wpolbas
               SET tsi_amt = NVL (v_tsi, 0),
                   prem_amt = NVL (v_prem, 0),
                   ann_tsi_amt = a2.ann_tsi + NVL (v_ann_tsi, 0),
                   ann_prem_amt = a2.ann_prem + NVL (v_ann_prem, 0),
                   no_of_items = NVL (v_no_of_items, 0)
             WHERE par_id = p_par_id;*/

            v_exist := 'Y';
            EXIT;
         END LOOP;

         IF v_exist = 'N'
         THEN
            FOR a2 IN (SELECT   b250.tsi_amt tsi, b250.prem_amt prem,
                                b250.ann_tsi_amt ann_tsi,
                                b250.ann_prem_amt ann_prem
                           FROM gipi_wpolbas b, gipi_polbasic b250
                          WHERE b.par_id = p_par_id
                            AND b250.line_cd = b.line_cd
                            AND b250.subline_cd = b.subline_cd
                            AND b250.iss_cd = b.iss_cd
                            AND b250.issue_yy = b.issue_yy
                            AND b250.pol_seq_no = b.pol_seq_no
                            AND b250.renew_no = b.renew_no
                            AND b250.pol_flag IN ('1', '2', '3', 'X')
                            AND NVL (b250.endt_seq_no, 0) = 0
                       ORDER BY b.eff_date DESC)
            LOOP
               /*UPDATE gipi_wpolbas
                  SET tsi_amt = NVL (v_tsi, 0),
                      prem_amt = NVL (v_prem, 0),
                      ann_tsi_amt = a2.ann_tsi + NVL (v_ann_tsi, 0),
                      ann_prem_amt = a2.ann_prem + NVL (v_ann_prem, 0),
                      no_of_items = NVL (v_no_of_items, 0)
                WHERE par_id = p_par_id;*/ NULL;

               EXIT;
            END LOOP;
         END IF;
      ELSE

         FOR a2 IN (SELECT   (c.tsi_amt * a.currency_rt) tsi,
                             (c.prem_amt * a.currency_rt) prem, b.eff_date,
                             b.endt_expiry_date, b.expiry_date,
                             b.prorate_flag, NVL (b.comp_sw, 'N') comp_sw,
                             b.short_rt_percent short_rt, c.peril_cd
                        FROM gipi_item a, gipi_polbasic b, gipi_itmperil c
                       WHERE b.line_cd = v_line_cd
                         AND b.subline_cd = v_subline_cd
                         AND b.iss_cd = v_iss_cd
                         AND b.issue_yy = v_issue_yy
                         AND b.pol_seq_no = v_pol_seq_no
                         AND b.renew_no = v_renew_no
                         AND b.policy_id = a.policy_id
                         AND b.policy_id = c.policy_id
                         AND a.item_no = c.item_no
                         AND b.pol_flag IN ('1', '2', '3', 'X')
                         AND TRUNC (b.eff_date) <=
                                DECODE (NVL (b.endt_seq_no, 0),
                                        0, TRUNC (b.eff_date),
                                        TRUNC (v_eff_date)
                                       )
                         --AND TRUNC(NVL(B.endt_expiry_date,B.expiry_date)) >= TRUNC(v_eff_date)
                         AND (   TRUNC (DECODE (NVL (b.endt_expiry_date,
                                                     b.expiry_date
                                                    ),
                                                b.expiry_date, v_expiry_date2,
                                                b.expiry_date, b.endt_expiry_date
                                               )
                                       ) >= TRUNC (v_eff_date)
                              OR p_negate_item = 'Y'
                             )
                    ORDER BY b.eff_date DESC)
         LOOP
            v_comp_prem := 0;

            /** rollie 21feb2006
               disallows recomputation of prem if item_no was negated programmatically
            **/
            IF NVL (p_negate_item, 'N') = 'Y'
            THEN
               v_comp_prem := a2.prem;
            ELSE
               IF a2.prorate_flag = 1
               THEN
                  IF a2.endt_expiry_date <= a2.eff_date
                  THEN
                     p_message :=
                           'Your endorsement expiry date is equal to or less than your effectivity date.'
                        || ' Restricted condition.';
                     --RETURN;
                  ELSE
                     IF a2.comp_sw = 'Y'
                     THEN
                        v_prorate :=
                             (  (  TRUNC (a2.endt_expiry_date)
                                 - TRUNC (a2.eff_date)
                                )
                              + 1
                             )
                           / (ADD_MONTHS (a2.eff_date, 12) - a2.eff_date);
                     ELSIF a2.comp_sw = 'M'
                     THEN
                        v_prorate :=
                             (  (  TRUNC (a2.endt_expiry_date)
                                 - TRUNC (a2.eff_date)
                                )
                              - 1
                             )
                           / (ADD_MONTHS (a2.eff_date, 12) - a2.eff_date);
                     ELSE
                        v_prorate :=
                             (TRUNC (a2.endt_expiry_date)
                              - TRUNC (a2.eff_date)
                             )
                           / (ADD_MONTHS (a2.eff_date, 12) - a2.eff_date);
                     END IF;
                  END IF;

                  IF TRUNC (v_eff_date2) = TRUNC (v_endt_expiry_date2)
                  THEN
                     v_prorate := 1;
                  END IF;

                  v_comp_prem := a2.prem / v_prorate;
               ELSIF a2.prorate_flag = 2
               THEN
                  v_comp_prem := a2.prem;
               ELSE
                  v_comp_prem := a2.prem / (a2.short_rt / 100);
               END IF;
            END IF;

            v_ann_prem2 := v_ann_prem2 + v_comp_prem;

            FOR TYPE IN (SELECT peril_type
                           FROM giis_peril
                          WHERE line_cd = v_line_cd2
                                AND peril_cd = a2.peril_cd)
            LOOP
               IF TYPE.peril_type = 'B'
               THEN
                  v_ann_tsi2 := v_ann_tsi2 + a2.tsi;
               END IF;
            END LOOP;
         END LOOP;

         /*UPDATE gipi_wpolbas
            SET tsi_amt = NVL (v_tsi, 0),
                prem_amt = NVL (v_prem, 0),
                ann_tsi_amt = NVL (v_ann_tsi, 0) + NVL (v_ann_tsi2, 0),
                ann_prem_amt = NVL (v_ann_prem, 0) + NVL (v_ann_prem2, 0),
                no_of_items = NVL (v_no_of_items, 0)
          WHERE par_id = p_par_id;*/
          NULL;
      END IF;
      RETURN p_message;
   END;

    /*
    **  Created by        : Jerome Orio
    **  Date Created     : 10.15.2010
    **  Reference By     : (GIPIS019 - Item Information)
    **  Description     :  CHECK_ADDTL_INFO program unit
    */
   PROCEDURE VALIDATE_CHECK_ADDTL_INFO_AH (
        p_par_id        IN  GIPI_PARLIST.par_id%TYPE,
        p_par_status    IN  GIPI_PARLIST.par_status%TYPE,
        p_msg_alert     OUT VARCHAR2)
    IS
       p_exist              VARCHAR2(1) := 'Y';
       no_accident_info     VARCHAR2(50):= '';
       v_pack_pol_flag        GIPI_WPOLBAS.pack_pol_flag%TYPE := NULL;
       v_result                VARCHAR2(200);
       CURSOR C IS
              SELECT  a.item_no  a_item_no,
                      nvl(b.item_no,0) b_item_no
                FROM  gipi_witem a, gipi_waccident_item b
               WHERE  a.par_id = b.par_id(+)
                 AND  a.item_no = b.item_no(+)
                 AND  upper(a.pack_line_cd) = 'AC'
                 AND  a.par_id = p_par_id;

       CURSOR D IS
              SELECT  a.item_no  a_item_no,
                      nvl(b.item_no,0) b_item_no
                FROM  gipi_witem a, gipi_waccident_item b
               WHERE  a.par_id = b.par_id(+)
                 AND  a.item_no = b.item_no(+)
                 AND  a.par_id = p_par_id;
    BEGIN
        v_pack_pol_flag := Check_Pack_Pol_Flag(p_par_id);
        IF v_pack_pol_flag = 'Y' THEN
            FOR C1 IN C LOOP
              IF c1.a_item_no != c1.b_item_no THEN
                no_accident_info := no_accident_info || TO_CHAR(c1.a_item_no) || ', ';
                p_exist := 'N';
              END IF;
            END LOOP;
        ELSE
            FOR D1 IN D LOOP
              IF d1.a_item_no != d1.b_item_no THEN
                no_accident_info := no_accident_info || TO_CHAR(d1.a_item_no) || ', ';
                p_exist := 'N';
              END IF;
            END LOOP;
        END IF;

        IF p_exist = 'Y' THEN
            no_accident_info := SUBSTR(no_accident_info, 1, NVL(LENGTH(no_accident_info), 0) - 2 );
            --p_result := 'Item No. '|| no_accident_info || ' has no corresponding additional accident information, save anyway ?';

            IF p_par_status != 3 THEN
                UPDATE gipi_parlist
                   SET par_status = 3
                 WHERE par_id = p_par_id;
            END IF;
        END IF;
    END;



    FUNCTION get_gipi_waccident_items1 (
    p_par_id  GIPI_WACCIDENT_ITEM.par_id%TYPE,
    p_item_no   GIPI_WACCIDENT_ITEM.item_no%TYPE
    ) RETURN gipi_waccident_paritem_tab PIPELINED
    IS
        v_accident      gipi_waccident_paritem_type;
    BEGIN
        FOR i IN (
            SELECT par_id, item_no, date_of_birth, age, civil_status, position_cd,
                   monthly_salary, salary_grade, no_of_persons, destination, height,
                   weight, sex, group_print_sw, ac_class_cd, level_cd, parent_level_cd
                FROM gipi_waccident_item
            WHERE par_id = p_par_id AND
                  item_no = p_item_no
            ORDER BY item_no
        )
        LOOP
            v_accident.par_id           := i.par_id;
            v_accident.item_no          := i.item_no;
            v_accident.date_of_birth    := i.date_of_birth;
            v_accident.age              := i.age;
            v_accident.civil_status     := i.civil_status;
            v_accident.position_cd      := i.position_cd;
            v_accident.monthly_salary   := i.monthly_salary;
            v_accident.salary_grade     := i.salary_grade;
            v_accident.no_of_persons    := i.no_of_persons;
            v_accident.destination      := i.destination;
            v_accident.height           := i.height;
            v_accident.weight           := i.weight;
            v_accident.sex              := i.sex;
            v_accident.group_print_sw   := i.group_print_sw;
            v_accident.ac_class_cd      := i.ac_class_cd;
            v_accident.level_cd         := i.level_cd;
            v_accident.parent_level_cd  := i.parent_level_cd;
            PIPE ROW(v_accident);
        END LOOP;

        RETURN;
    END get_gipi_waccident_items1;

    /*
    **  Created by        : Mark JM
    **  Date Created    : 03.21.2011
    **  Reference By    : (GIPIS095 - Package Policy Items)
    **  Description     : Retrieve records from gipi_waccident_item based on the given parameters
    */
    FUNCTION get_gipi_waccident_pack_pol (
        p_par_id IN gipi_waccident_item.par_id%TYPE,
        p_item_no IN gipi_waccident_item.item_no%TYPE)
    RETURN gipi_waccident_paritem_tab PIPELINED
    IS
        v_accident gipi_waccident_paritem_type;
    BEGIN
        FOR i IN (
            SELECT par_id, item_no
              FROM gipi_waccident_item
             WHERE par_id = p_par_id
               AND item_no = p_item_no)
        LOOP
            v_accident.par_id     := i.par_id;
            v_accident.item_no    := i.item_no;

            PIPE ROW(v_accident);
        END LOOP;

        RETURN;
    END get_gipi_waccident_pack_pol;

END;
/


