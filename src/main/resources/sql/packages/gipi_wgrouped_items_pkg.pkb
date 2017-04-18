CREATE OR REPLACE PACKAGE BODY CPI.gipi_wgrouped_items_pkg
AS   
    /*    Date        Author            Description
    **    ==========    ===============    ============================
    **    05.04.2010    Jerome Orio        Get PAR record listing for GROUPED ITEMS
    **                                Reference By : (GIPIS011- Item Information - Casualty - Grouped Items)
    **    12.14.2011    mark jm            added ESCAPE_VALUE_CLOB
    */
   FUNCTION get_gipi_wgrouped_items (
      p_par_id   gipi_wgrouped_items.par_id%TYPE
   )
      RETURN gipi_wgrouped_items_tab PIPELINED
   IS
      v_grp   gipi_wgrouped_items_type;
   BEGIN
      FOR i IN (SELECT   a.par_id, a.item_no, a.grouped_item_no,
                         a.include_tag, a.grouped_item_title, a.sex,
                         a.position_cd, a.civil_status, a.date_of_birth,
                         a.age, a.salary, a.salary_grade, a.amount_covered,
                         a.remarks, a.line_cd, a.subline_cd, a.delete_sw,
                         a.group_cd, a.from_date, a.TO_DATE, a.payt_terms,
                         a.pack_ben_cd, a.ann_tsi_amt, a.ann_prem_amt,
                         a.control_cd, a.control_type_cd, a.tsi_amt,
                         a.prem_amt, a.principal_cd, b.group_desc
                    FROM gipi_wgrouped_items a, giis_group b
                   WHERE par_id = p_par_id AND a.group_cd = b.group_cd(+)
                ORDER BY par_id, item_no, grouped_item_no)
      LOOP
         v_grp.par_id                 := i.par_id;
         v_grp.item_no                 := i.item_no;
         v_grp.grouped_item_no         := i.grouped_item_no;
         v_grp.include_tag             := i.include_tag;
         v_grp.grouped_item_title     := i.grouped_item_title;
         v_grp.sex                     := i.sex;
         v_grp.position_cd             := i.position_cd;
         v_grp.civil_status         := i.civil_status;
         v_grp.date_of_birth         := i.date_of_birth;
         v_grp.age                     := i.age;
         v_grp.salary                 := i.salary;
         v_grp.salary_grade         := i.salary_grade;
         v_grp.amount_covered         := i.amount_covered;
         v_grp.remarks                 := i.remarks; -- ESCAPE_VALUE_CLOB(i.remarks); changed by robert 09262013
         v_grp.line_cd                 := i.line_cd;
         v_grp.subline_cd             := i.subline_cd;
         v_grp.delete_sw             := i.delete_sw;
         v_grp.group_cd             := i.group_cd;
         v_grp.from_date             := i.from_date;
         v_grp.TO_DATE                 := i.TO_DATE;
         v_grp.payt_terms             := i.payt_terms;
         v_grp.pack_ben_cd             := i.pack_ben_cd;
         v_grp.ann_tsi_amt             := i.ann_tsi_amt;
         v_grp.ann_prem_amt         := i.ann_prem_amt;
         v_grp.control_cd             := i.control_cd;
         v_grp.control_type_cd         := i.control_type_cd;
         v_grp.tsi_amt                 := i.tsi_amt;
         v_grp.prem_amt             := i.prem_amt;
         v_grp.principal_cd         := i.principal_cd;
         v_grp.group_desc             := i.group_desc;
         PIPE ROW (v_grp);
      END LOOP;

      RETURN;
   END;

   /*
     **  Created by        : Jerome Orio
     **  Date Created     : 05.20.2010
     **  Reference By     : (GIPIS011- Item Information - Casualty - Grouped Items)
     **  Description     :Get PAR record listing for GROUPED ITEMS per item no
     */
   FUNCTION get_gipi_wgrouped_items2 (
      p_par_id    gipi_wgrouped_items.par_id%TYPE,
      p_item_no   gipi_wgrouped_items.item_no%TYPE
   )
      RETURN gipi_wgrouped_items_tab PIPELINED
   IS
      v_grp   gipi_wgrouped_items_type;
   BEGIN
      FOR i IN (SELECT   a.par_id, a.item_no, a.grouped_item_no,
                         a.include_tag, a.grouped_item_title, a.sex,
                         a.position_cd, a.civil_status, a.date_of_birth,
                         a.age, a.salary, a.salary_grade, a.amount_covered,
                         a.remarks, a.line_cd, a.subline_cd, a.delete_sw,
                         a.group_cd, a.from_date, a.TO_DATE, a.payt_terms,
                         a.pack_ben_cd, a.ann_tsi_amt, a.ann_prem_amt,
                         a.control_cd, a.control_type_cd, a.tsi_amt,
                         a.prem_amt, a.principal_cd, b.group_desc,
                         c.package_cd, d.payt_terms_desc
                    FROM gipi_wgrouped_items a,
                         giis_group b,
                         giis_package_benefit c,
                         giis_payterm d
                   WHERE a.par_id = p_par_id
                     AND a.item_no = p_item_no
                     AND a.group_cd = b.group_cd(+)
                     AND a.pack_ben_cd = c.pack_ben_cd(+)
                     AND a.payt_terms = d.payt_terms(+)
                ORDER BY par_id, item_no, grouped_item_no)
      LOOP
         v_grp.par_id := i.par_id;
         v_grp.item_no := i.item_no;
         v_grp.grouped_item_no := i.grouped_item_no;
         v_grp.include_tag := i.include_tag;
         v_grp.grouped_item_title := i.grouped_item_title;
         v_grp.sex := i.sex;
         v_grp.position_cd := i.position_cd;
         v_grp.civil_status := i.civil_status;
         v_grp.date_of_birth := i.date_of_birth;
         v_grp.age := i.age;
         v_grp.salary := i.salary;
         v_grp.salary_grade := i.salary_grade;
         v_grp.amount_covered := i.amount_covered;
         v_grp.remarks := i.remarks;
         v_grp.line_cd := i.line_cd;
         v_grp.subline_cd := i.subline_cd;
         v_grp.delete_sw := i.delete_sw;
         v_grp.group_cd := i.group_cd;
         v_grp.from_date := i.from_date;
         v_grp.TO_DATE := i.TO_DATE;
         v_grp.payt_terms := i.payt_terms;
         v_grp.pack_ben_cd := i.pack_ben_cd;
         v_grp.ann_tsi_amt := i.ann_tsi_amt;
         v_grp.ann_prem_amt := i.ann_prem_amt;
         v_grp.control_cd := i.control_cd;
         v_grp.control_type_cd := i.control_type_cd;
         v_grp.tsi_amt := i.tsi_amt;
         v_grp.prem_amt := i.prem_amt;
         v_grp.principal_cd := i.principal_cd;
         v_grp.group_desc := i.group_desc;
         v_grp.package_cd := i.package_cd;
         v_grp.payt_terms_desc := i.payt_terms_desc;
         PIPE ROW (v_grp);
      END LOOP;

      RETURN;
   END;

   /*
   **  Created by        : Jerome Orio
   **  Date Created     : 05.05.2010
   **  Reference By     : (GIPIS011- Item Information - Casualty - Grouped Items)
   **  Description     : Insert PAR record listing for GROUPED ITEMS
   */
   PROCEDURE set_gipi_wgrouped_items (
      p_par_id               gipi_wgrouped_items.par_id%TYPE,
      p_item_no              gipi_wgrouped_items.item_no%TYPE,
      p_grouped_item_no      gipi_wgrouped_items.grouped_item_no%TYPE,
      p_include_tag          gipi_wgrouped_items.include_tag%TYPE,
      p_grouped_item_title   gipi_wgrouped_items.grouped_item_title%TYPE,
      p_group_cd             gipi_wgrouped_items.group_cd%TYPE,
      p_amount_covered       gipi_wgrouped_items.amount_covered%TYPE,
      p_remarks              gipi_wgrouped_items.remarks%TYPE,
      p_line_cd              gipi_wgrouped_items.line_cd%TYPE,
      p_subline_cd           gipi_wgrouped_items.subline_cd%TYPE
   )
   IS
   BEGIN
      MERGE INTO gipi_wgrouped_items
         USING DUAL
         ON (    par_id = p_par_id
             AND item_no = p_item_no
             AND grouped_item_no = p_grouped_item_no)
         WHEN NOT MATCHED THEN
            INSERT (par_id, item_no, grouped_item_no, include_tag,
                    grouped_item_title, group_cd, amount_covered, remarks,
                    line_cd, subline_cd)
            VALUES (p_par_id, p_item_no, p_grouped_item_no, p_include_tag,
                    p_grouped_item_title, p_group_cd, p_amount_covered,
                    p_remarks, p_line_cd, p_subline_cd)
         WHEN MATCHED THEN
            UPDATE
               SET include_tag = p_include_tag,
                   grouped_item_title = p_grouped_item_title,
                   group_cd = p_group_cd, amount_covered = p_amount_covered,
                   remarks = p_remarks, line_cd = p_line_cd,
                   subline_cd = p_subline_cd
            ;
   END;

   /*
   **  Created by        : Jerome Orio
   **  Date Created     : 05.27.2010
   **  Reference By     : (GIPIS012- Item Information - Accident - Grouped Items)
   **  Description     : Insert PAR record listing for GROUPED ITEMS
   */
   PROCEDURE set_gipi_wgrouped_items2 (
      p_par_id               gipi_wgrouped_items.par_id%TYPE,
      p_item_no              gipi_wgrouped_items.item_no%TYPE,
      p_grouped_item_no      gipi_wgrouped_items.grouped_item_no%TYPE,
      p_include_tag          gipi_wgrouped_items.include_tag%TYPE,
      p_grouped_item_title   gipi_wgrouped_items.grouped_item_title%TYPE,
      p_group_cd             gipi_wgrouped_items.group_cd%TYPE,
      p_amount_covered       gipi_wgrouped_items.amount_covered%TYPE,
      p_remarks              gipi_wgrouped_items.remarks%TYPE,
      p_line_cd              gipi_wgrouped_items.line_cd%TYPE,
      p_subline_cd           gipi_wgrouped_items.subline_cd%TYPE,
      p_sex                  gipi_wgrouped_items.sex%TYPE,
      p_position_cd          gipi_wgrouped_items.position_cd%TYPE,
      p_civil_status         gipi_wgrouped_items.civil_status%TYPE,
      p_date_of_birth        gipi_wgrouped_items.date_of_birth%TYPE,
      p_age                  gipi_wgrouped_items.age%TYPE,
      p_salary               gipi_wgrouped_items.salary%TYPE,
      p_salary_grade         gipi_wgrouped_items.salary_grade%TYPE,
      p_delete_sw            gipi_wgrouped_items.delete_sw%TYPE,
      p_from_date            gipi_wgrouped_items.from_date%TYPE,
      p_to_date              gipi_wgrouped_items.TO_DATE%TYPE,
      p_payt_terms           gipi_wgrouped_items.payt_terms%TYPE,
      p_pack_ben_cd          gipi_wgrouped_items.pack_ben_cd%TYPE,
      p_ann_tsi_amt          gipi_wgrouped_items.ann_tsi_amt%TYPE,
      p_ann_prem_amt         gipi_wgrouped_items.ann_prem_amt%TYPE,
      p_tsi_amt              gipi_wgrouped_items.tsi_amt%TYPE,
      p_prem_amt             gipi_wgrouped_items.prem_amt%TYPE,
      p_control_cd           gipi_wgrouped_items.control_cd%TYPE,
      p_control_type_cd      gipi_wgrouped_items.control_type_cd%TYPE,
      p_principal_cd         gipi_wgrouped_items.principal_cd%TYPE
   )
   IS
   BEGIN
      MERGE INTO gipi_wgrouped_items
         USING DUAL
         ON (    par_id = p_par_id
             AND item_no = p_item_no
             AND grouped_item_no = p_grouped_item_no)
         WHEN NOT MATCHED THEN
            INSERT (par_id, item_no, grouped_item_no, include_tag,
                    grouped_item_title, group_cd, amount_covered, remarks,
                    line_cd, subline_cd, sex, position_cd, civil_status,
                    date_of_birth, age, salary, salary_grade, delete_sw,
                    from_date, TO_DATE, payt_terms, pack_ben_cd, ann_tsi_amt,
                    ann_prem_amt, tsi_amt, prem_amt, control_cd,
                    control_type_cd, principal_cd)
            VALUES (p_par_id, p_item_no, p_grouped_item_no, p_include_tag,
                    p_grouped_item_title, p_group_cd, p_amount_covered,
                    p_remarks, p_line_cd, p_subline_cd, p_sex, p_position_cd,
                    p_civil_status, p_date_of_birth, p_age, p_salary,
                    p_salary_grade, p_delete_sw, p_from_date, p_to_date,
                    p_payt_terms, p_pack_ben_cd, p_ann_tsi_amt,
                    p_ann_prem_amt, p_tsi_amt, p_prem_amt, p_control_cd,
                    p_control_type_cd, p_principal_cd)
         WHEN MATCHED THEN
            UPDATE
               SET include_tag = p_include_tag,
                   grouped_item_title = p_grouped_item_title,
                   group_cd = p_group_cd, amount_covered = p_amount_covered,
                   remarks = p_remarks, line_cd = p_line_cd,
                   subline_cd = p_subline_cd, sex = p_sex,
                   position_cd = p_position_cd, civil_status = p_civil_status,
                   date_of_birth = p_date_of_birth, age = p_age,
                   salary = p_salary, salary_grade = p_salary_grade,
                   delete_sw = p_delete_sw, from_date = p_from_date,
                   TO_DATE = p_to_date, payt_terms = p_payt_terms,
                   pack_ben_cd = p_pack_ben_cd, ann_tsi_amt = p_ann_tsi_amt,
                   ann_prem_amt = p_ann_prem_amt, tsi_amt = p_tsi_amt,
                   prem_amt = p_prem_amt, control_cd = p_control_cd,
                   control_type_cd = p_control_type_cd,
                   principal_cd = p_principal_cd
            ;
   END;

   /*
   **  Created by        : Jerome Orio
   **  Date Created     : 05.05.2010
   **  Reference By     : (GIPIS011- Item Information - Casualty - Grouped Items)
   **  Description     : Delete per item no PAR record listing for GROUPED ITEMS
   */
   PROCEDURE del_gipi_wgrouped_items (
      p_par_id    gipi_wgrouped_items.par_id%TYPE,
      p_item_no   gipi_wgrouped_items.item_no%TYPE
   )
   IS
   BEGIN
      DELETE      gipi_wgrouped_items
            WHERE par_id = p_par_id AND item_no = p_item_no;
   END;

   /*
   **  Created by        : Jerome Orio
   **  Date Created     : 05.05.2010
   **  Reference By     : (GIPIS011- Item Information - Casualty - Grouped Items)
   **  Description     : Delete per item no and grouped item no PAR record listing for GROUPED ITEMS
   */
   PROCEDURE del_gipi_wgrouped_items2 (
      p_par_id            gipi_wgrouped_items.par_id%TYPE,
      p_item_no           gipi_wgrouped_items.item_no%TYPE,
      p_grouped_item_no   gipi_wgrouped_items.grouped_item_no%TYPE
   )
   IS
   BEGIN
      DELETE      gipi_wgrouped_items
            WHERE par_id = p_par_id
              AND item_no = p_item_no
              AND grouped_item_no = p_grouped_item_no;
   END;

     /*
   **  Created by        : Jerome Orio
   **  Date Created     : 05.28.2010
   **  Reference By     : (GIPIS012- Item Information - Accident - Grouped Items)
   **  Description     : program unit insert_recgrp_witem
   */
   PROCEDURE insert_recgrp_witem (
      p_par_id            gipi_waccident_item.par_id%TYPE,
      p_item_no           gipi_waccident_item.item_no%TYPE,
      p_line_cd           gipi_wpolbas.line_cd%TYPE,
      p_grouped_item_no   gipi_wgrouped_items.grouped_item_no%TYPE,
      p_no_of_person      NUMBER
   )
   IS
      v_exists           NUMBER                                 := 0;
      v_exists2          NUMBER                                 := 0;
      v_exists3          NUMBER                                 := 0;
                                                      --for deleting purposes
      v_exists4          NUMBER                                 := 0;  --issa
      v_tsi_amt          gipi_witmperl.tsi_amt%TYPE             := 0;
      v_prem_amt         gipi_witmperl.prem_amt%TYPE            := 0;
      v_ann_prem_amt     gipi_witmperl.ann_prem_amt%TYPE        := 0;
                                      --issa@fpac09.18.2006, for ann_prem_amt
      v_ann_prem_amt4    gipi_grouped_items.ann_prem_amt%TYPE   := 0;
                                      --issa@fpac09.18.2006, for ann_prem_amt
      v_tsi_amt4         gipi_grouped_items.tsi_amt%TYPE        := 0;
      v_itmperil_exist   BOOLEAN                                := FALSE;
   BEGIN
      UPDATE gipi_waccident_item
         SET no_of_persons = p_no_of_person
       WHERE par_id = p_par_id AND item_no = p_item_no;

      FOR a IN (SELECT '1'
                  FROM gipi_wgrouped_items
                 WHERE par_id = p_par_id
                   AND item_no = p_item_no
                   AND group_cd IS NOT NULL)
      LOOP
         UPDATE gipi_witem
            SET group_cd = NULL
          WHERE par_id = p_par_id AND item_no = p_item_no;

         EXIT;
      END LOOP;

      FOR a IN (SELECT 1
                  FROM gipi_witmperl
                 WHERE par_id = p_par_id AND item_no = p_item_no)
      LOOP
         v_itmperil_exist := TRUE;
         EXIT;
      END LOOP;

      FOR b IN (SELECT 2
                  FROM gipi_witmperl_grouped
                 WHERE par_id = p_par_id AND item_no = p_item_no)
      LOOP
         v_itmperil_exist := FALSE;
         EXIT;
      END LOOP;

      IF NOT v_itmperil_exist
      THEN
         --added by gmi 04/04/06 deletion of perils in witmperl if peril doesnt exist ng grouped item peril
         FOR x IN (SELECT peril_cd
                     FROM gipi_witmperl
                    WHERE par_id = p_par_id AND item_no = p_item_no)
         LOOP
            v_exists3 := 1;

            FOR y IN (SELECT peril_cd
                        FROM gipi_witmperl_grouped
                       WHERE par_id = p_par_id
                         AND item_no = p_item_no
                         AND peril_cd = x.peril_cd)
            LOOP
               v_exists3 := 0;
            END LOOP;

            IF v_exists3 = 1
            THEN
               DELETE FROM gipi_witmperl
                     WHERE par_id = p_par_id
                       AND item_no = p_item_no
                       AND peril_cd = x.peril_cd;
            END IF;
         END LOOP;

         /* gmi */
         --issa@fpac09.18.2006, added SUM(ann_prem_amt) ann_prem_amt
         FOR j IN (SELECT   SUM (tsi_amt) tsi_amt, SUM (prem_amt) prem_amt,
                            SUM (ann_prem_amt) ann_prem_amt, a.peril_cd,
                            item_no, b.peril_type
                       FROM gipi_witmperl_grouped a, giis_peril b
                      WHERE par_id = p_par_id
                        AND item_no = p_item_no
                        AND a.peril_cd = b.peril_cd
                        AND a.line_cd = b.line_cd
                   GROUP BY a.peril_cd, a.item_no, b.peril_type)
         LOOP
            v_exists2 := 1;

            FOR g IN (SELECT 1
                        FROM gipi_witmperl
                       WHERE par_id = p_par_id
                         AND item_no = p_item_no
                         AND peril_cd = j.peril_cd)
            LOOP
               v_exists := 1;
            END LOOP;

            IF v_exists = 1
            THEN
               UPDATE gipi_witmperl
                  SET tsi_amt = j.tsi_amt,
                      prem_amt = j.prem_amt,
                      ann_tsi_amt = j.tsi_amt,
                      ann_prem_amt =
                         j.ann_prem_amt
                                       --issa@fpac09.18.2006, for ann_prem_amt
                WHERE par_id = p_par_id
                  AND item_no = p_item_no
                  AND line_cd = p_line_cd
                  AND peril_cd = j.peril_cd;

               v_exists := 0;
            ELSE
               INSERT INTO gipi_witmperl
                           (par_id, item_no, line_cd, peril_cd,
                            tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt
                           )           --issa@fpac09.18.2006, for ann_prem_amt
                    VALUES (p_par_id, p_item_no, p_line_cd, j.peril_cd,
                            j.tsi_amt, j.prem_amt, j.tsi_amt, j.ann_prem_amt
                           );
            END IF;

            IF j.peril_type = 'B'
            THEN
               v_tsi_amt := NVL (j.tsi_amt, 0) + v_tsi_amt;
            END IF;

            v_prem_amt := NVL (j.prem_amt, 0) + v_prem_amt;
            v_ann_prem_amt := NVL (j.ann_prem_amt, 0) + v_ann_prem_amt;
                                       --issa@fpac09.18.2006, for ann_prem_amt
         END LOOP;

         --issa@fpac09.19.2006, to correct amounts for ann_prem_amt in gipi_witmperl_grouped
         FOR i IN (SELECT   SUM (a.ann_prem_amt) ann_prem_amt,
                            SUM (a.tsi_amt) tsi_amt, b.peril_type
                       FROM gipi_witmperl_grouped a, giis_peril b
                      WHERE a.par_id = p_par_id
                        AND a.item_no = p_item_no
                        AND a.grouped_item_no = p_grouped_item_no
                        AND a.peril_cd = b.peril_cd
                        AND a.line_cd = b.line_cd
                   GROUP BY b.peril_type)
         LOOP
            v_exists4 := 1;

            IF i.peril_type = 'B'
            THEN
               v_tsi_amt4 := NVL (i.tsi_amt, 0) + v_tsi_amt4;
            END IF;

            v_ann_prem_amt4 := NVL (i.ann_prem_amt, 0) + v_ann_prem_amt4;
                                       --issa@fpac09.18.2006, for ann_prem_amt
         --message('ann_prem'||v_ann_prem_amt4);
         --message('tsi'||v_tsi_amt4);
         END LOOP;

         --i--
         IF v_exists2 = 1
         THEN
            UPDATE gipi_witem
               SET tsi_amt = v_tsi_amt,
                   prem_amt = v_prem_amt,
                   ann_tsi_amt = v_tsi_amt,
                   ann_prem_amt =
                         v_ann_prem_amt
                                       --issa@fpac09.18.2006, for ann_prem_amt
             WHERE par_id = p_par_id AND item_no = p_item_no;

            cr_bill_dist.get_tsi (p_par_id);
         ELSE
            UPDATE gipi_witem
               SET tsi_amt = 0,
                   prem_amt = 0,
                   ann_tsi_amt = 0,
                   ann_prem_amt = 0
             WHERE par_id = p_par_id AND item_no = p_item_no;

            cr_bill_dist.get_tsi (p_par_id);
         END IF;

         --issa@fpac09.18.2006--
         IF v_exists4 = 1
         THEN
            UPDATE gipi_wgrouped_items
               SET ann_prem_amt = v_ann_prem_amt4,
                   tsi_amt = v_tsi_amt4,
                   ann_tsi_amt = v_tsi_amt4
             WHERE par_id = p_par_id
               AND item_no = p_item_no
               AND grouped_item_no = p_grouped_item_no;
         ELSE
            UPDATE gipi_wgrouped_items
               SET ann_prem_amt = 0,
                   tsi_amt = 0,
                   ann_tsi_amt = 0
             WHERE par_id = p_par_id
               AND item_no = p_item_no
               AND grouped_item_no = p_grouped_item_no;
         END IF;
      --i--
      /* -- */
      END IF;
   END;

    /*
   **  Created by        : Jerome Orio
   **  Date Created     : 05.28.2010
   **  Reference By     : (GIPIS012- Item Information - Accident - Grouped Items)
   **  Description     : to delete corresponding tables when no. of persons changed
   */
   PROCEDURE del_grouped_items_per_item (
      p_par_id    gipi_wgrouped_items.par_id%TYPE,
      p_item_no   gipi_wgrouped_items.item_no%TYPE
   )
   IS
      v_itmperil_exist   BOOLEAN := FALSE;
   BEGIN
      FOR a IN (SELECT 1
                  FROM gipi_witmperl
                 WHERE par_id = p_par_id AND item_no = p_item_no)
      LOOP
         v_itmperil_exist := TRUE;
         EXIT;
      END LOOP;

      FOR b IN (SELECT 2
                  FROM gipi_witmperl_grouped
                 WHERE par_id = p_par_id AND item_no = p_item_no)
      LOOP
         v_itmperil_exist := FALSE;
         EXIT;
      END LOOP;

      IF NOT v_itmperil_exist
      THEN
         FOR a IN (SELECT 1
                     FROM gipi_witmperl_grouped
                    WHERE par_id = p_par_id AND item_no = p_item_no)
         LOOP
            DELETE FROM gipi_witmperl
                  WHERE par_id = p_par_id AND item_no = p_item_no;

            EXIT;
         END LOOP;
      END IF;

      gipi_witmperl_beneficiary_pkg.del_gipi_witmperl_benificiary (p_par_id,
                                                                   p_item_no
                                                                  );
      gipi_wgrp_item_beneficiary_pkg.del_gipi_wgrp_item_benificiary (p_par_id,
                                                                     p_item_no
                                                                    );
      gipi_witmperl_grouped_pkg.del_gipi_witmperl_grouped (p_par_id,
                                                           p_item_no);
      gipi_wgrouped_items_pkg.del_gipi_wgrouped_items (p_par_id, p_item_no);

      UPDATE gipi_parlist
         SET upload_no = NULL
       WHERE par_id = p_par_id;

      UPDATE gipi_load_hist
         SET par_id = NULL
       WHERE par_id = p_par_id;
   END;

   /*
   **  Created by        : Mark JM
   **  Date Created     : 06.01.2010
   **  Reference By     : (GIPIS031 - Endt Basic Information)
   **  Description     : This procedure deletes record based on the given par_id
   */
   PROCEDURE del_gipi_wgrouped_items (
      p_par_id   IN   gipi_wgrouped_items.par_id%TYPE
   )
   IS
   BEGIN
      DELETE FROM gipi_wgrouped_items
            WHERE par_id = p_par_id;
   END del_gipi_wgrouped_items;

   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  05.28.2010
   **  Reference By : (GIPIS012- Item Information - Accident - Grouped Items)
   **  Description  : populate_benefits program unit alert button 2
   */
   PROCEDURE populate_benefits (
      p_par_id            gipi_waccident_item.par_id%TYPE,
      p_item_no           gipi_waccident_item.item_no%TYPE,
      p_grouped_item_no   gipi_wgrouped_items.grouped_item_no%TYPE,
      p_pack_ben_cd       gipi_wgrouped_items.pack_ben_cd%TYPE,
      p_line_cd           gipi_wgrouped_items.line_cd%TYPE
   )
   IS
      v_no_of_days        NUMBER                                   := 0;
      v_tsi_amt           NUMBER                                   := 0;
      v_prem_amt          NUMBER                                   := 0;
      v_item_to_date      DATE;
      v_item_from_date    DATE;
      v_expiry_date       DATE;
      v_incept_date       DATE;
      v_no_of_days_comp   NUMBER                                   := 0;
      v_year              NUMBER                                   := 0;
      v_prem_rt           giis_package_benefit_dtl.prem_pct%TYPE;
      v_prem_amt2         NUMBER                                   := 0;
      v_ann_prem_amt      NUMBER                                   := 0;
      v_ann_prem_amt2     NUMBER                                   := 0;
      v_type              VARCHAR2 (1)                             := '';
      v_ann_tsi_amt       NUMBER                                   := 0;
   BEGIN
      SELECT TO_NUMBER (TO_CHAR (TO_DATE ('12/31/'
                                          || TO_CHAR (SYSDATE, 'YYYY'),
                                          'MM/DD/YYYY'
                                         ),
                                 'DDD'
                                )
                       )
        INTO v_year
        FROM DUAL;

      FOR item IN (SELECT TO_DATE, from_date
                     FROM gipi_witem
                    WHERE par_id = p_par_id AND item_no = p_item_no)
      LOOP
         v_item_to_date := item.TO_DATE;
         v_item_from_date := item.from_date;
      END LOOP;

      FOR polbas IN (SELECT expiry_date, incept_date
                       FROM gipi_wpolbas
                      WHERE par_id = p_par_id)
      LOOP
         v_expiry_date := polbas.expiry_date;
         v_incept_date := polbas.incept_date;
      END LOOP;

      v_no_of_days_comp :=
           NVL (TRUNC (v_item_to_date), TRUNC (v_expiry_date))
         - NVL (TRUNC (v_item_from_date), TRUNC (v_incept_date));

      DELETE FROM gipi_witmperl_grouped
            WHERE par_id = p_par_id
              AND item_no = p_item_no
              AND grouped_item_no = p_grouped_item_no;

      FOR pack_dtl IN (SELECT peril_cd, benefit, prem_pct, no_of_days,
                              aggregate_sw, prem_amt
                         FROM giis_package_benefit_dtl
                        WHERE pack_ben_cd = p_pack_ben_cd)
      LOOP
         v_no_of_days := NVL (pack_dtl.no_of_days, 0);            --issa@fpac
         v_tsi_amt := NVL (pack_dtl.no_of_days, 1)
                      * NVL (pack_dtl.benefit, 0);                     --issa
         v_prem_amt :=
            NVL (pack_dtl.prem_amt,
                 ROUND (  (  ((NVL (pack_dtl.prem_pct, 0)) / 100)
                           * NVL (v_tsi_amt, 0)
                           * NVL (v_no_of_days_comp, 1)
                          )
                        / v_year,
                        2
                       )
                );                                                 --issa@fpac

         /*    v_prem_rt                := ROUND((v_prem_amt/(v_tsi_amt*nvl(v_no_of_days_comp,1)/v_year))*100,9); --issa@fpac*/
         IF NVL (pack_dtl.prem_pct, 0) > 0
         THEN                                   -->added by alfie 12.04.2008:)
            v_prem_rt := NVL (pack_dtl.prem_pct, 0) / 100;
         ELSE
            IF v_tsi_amt > 0
            THEN
               v_prem_rt :=
                  ROUND (  (  v_prem_amt
                            / (v_tsi_amt * NVL (v_no_of_days_comp, 1) / v_year
                              )
                           )
                         * 100,
                         9
                        );                                         --issa@fpac
            END IF;
         END IF;                                                         -->:)

         v_ann_prem_amt :=
            NVL (ROUND (((pack_dtl.prem_pct) / 100) * v_tsi_amt, 2),
                 ROUND ((NVL (v_tsi_amt, 0) * (v_prem_rt / 100)), 2)
                );                                       --issa@fpac09.19.2006

         --issa--v_ann_prem_amt     := nvl(ROUND(((nvl(pack_dtl.prem_pct,0))/100) * nvl(v_tsi_amt,0),2),ROUND((nvl(v_tsi_amt,0)*v_prem_rt),2));    --issa@fpac
         --issa--v_tsi_amt       := nvl(v_no_of_days,0) * nvl(pack_dtl.benefit,0);
         --issa--v_prem_amt      := ROUND((((nvl(pack_dtl.prem_pct,0))/100) * nvl(v_tsi_amt,0) * nvl(v_no_of_days,0))/v_year,2);
         --issa--v_ann_prem_amt     := ROUND(((nvl(pack_dtl.prem_pct,0))/100) * nvl(v_tsi_amt,0),2);
         INSERT INTO gipi_witmperl_grouped
                     (par_id, item_no, grouped_item_no, line_cd,
                      peril_cd, rec_flag,
                      prem_rt,
                      base_amt,
                      no_of_days, tsi_amt,
                      prem_amt, ann_prem_amt, aggregate_sw,
                      ann_tsi_amt
                     )
--VJ 07.01.08 added annual tsi amount, to prevent null values then later on cause problem on endorsement
              VALUES (p_par_id, p_item_no, p_grouped_item_no, p_line_cd,
                      pack_dtl.peril_cd, 'C',
                      NVL (pack_dtl.prem_pct, v_prem_rt) /*--issa--pack_dtl.prem_pct*/,
                      pack_dtl.benefit,
                      NVL (pack_dtl.no_of_days, v_no_of_days), v_tsi_amt,
                      v_prem_amt, v_ann_prem_amt, pack_dtl.aggregate_sw,
                      v_tsi_amt
                     );

         SELECT a.peril_type
           INTO v_type
           FROM giis_peril a
          WHERE a.peril_cd = pack_dtl.peril_cd AND a.line_cd = p_line_cd;

         IF v_type = 'B'
         THEN
            v_ann_tsi_amt := ROUND ((v_ann_tsi_amt + v_tsi_amt), 2);
         END IF;

         v_prem_amt2 := ROUND ((v_prem_amt2 + v_prem_amt), 2);
         v_ann_prem_amt2 := ROUND ((v_ann_prem_amt2 + v_ann_prem_amt), 2);

---------------------------------------------------------------
--A.R.C. 06.12.2007
--to populate gipi_wpolwc
         FOR a1 IN (SELECT a.line_cd, a.main_wc_cd
                      FROM giis_peril_clauses a
                     WHERE a.line_cd = p_line_cd
                       AND a.peril_cd = pack_dtl.peril_cd
                       AND NOT EXISTS (
                              SELECT '1'
                                FROM gipi_wpolwc b
                               WHERE b.par_id = p_par_id
                                 AND b.line_cd = a.line_cd
                                 AND b.wc_cd = a.main_wc_cd))
         LOOP
            FOR b IN (SELECT line_cd, main_wc_cd, print_sw, wc_title
                        FROM giis_warrcla
                       WHERE line_cd = a1.line_cd
                         AND main_wc_cd = a1.main_wc_cd)
            LOOP
               INSERT INTO gipi_wpolwc
                           (par_id, line_cd, wc_cd, swc_seq_no,
                            print_seq_no, wc_title, rec_flag, print_sw,
                            change_tag
                           )
                    VALUES (p_par_id, b.line_cd, b.main_wc_cd, 0,
                            1, b.wc_title, 'A', b.print_sw,
                            'N'
                           );
            END LOOP;
         END LOOP;
---------------------------------------------------------------
      END LOOP;

      UPDATE gipi_wgrouped_items
         SET ann_tsi_amt = v_ann_tsi_amt,
             tsi_amt = v_ann_tsi_amt,
             ann_prem_amt = v_ann_prem_amt2,
             prem_amt = v_prem_amt2,
             amount_covered = v_ann_tsi_amt
       WHERE par_id = p_par_id
         AND item_no = p_item_no
         AND grouped_item_no = p_grouped_item_no;

      v_ann_tsi_amt := 0;
      v_ann_prem_amt2 := 0;
      v_prem_amt2 := 0;
   END;

   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  05.28.2010
   **  Reference By : (GIPIS012- Item Information - Accident - Grouped Items)
   **  Description  : populate_benefits program unit alert button 1
   */
   PROCEDURE populate_benefits2 (
      p_par_id    gipi_waccident_item.par_id%TYPE,
      p_item_no   gipi_waccident_item.item_no%TYPE
   )
   IS
      v_no_of_days        NUMBER                                   := 0;
      v_tsi_amt           NUMBER                                   := 0;
      v_prem_amt          NUMBER                                   := 0;
      v_item_to_date      DATE;
      v_item_from_date    DATE;
      v_expiry_date       DATE;
      v_incept_date       DATE;
      v_no_of_days_comp   NUMBER                                   := 0;
      v_year              NUMBER                                   := 0;
      v_prem_rt           giis_package_benefit_dtl.prem_pct%TYPE;
      v_prem_amt2         NUMBER                                   := 0;
      v_ann_prem_amt      NUMBER                                   := 0;
      v_ann_prem_amt2     NUMBER                                   := 0;
      v_type              VARCHAR2 (1)                             := '';
      v_ann_tsi_amt       NUMBER                                   := 0;
      v_pack_ben_cd       gipi_wgrouped_items.pack_ben_cd%TYPE;
      v_line_cd           gipi_wpolbas.line_cd%TYPE;
   BEGIN
      SELECT TO_NUMBER (TO_CHAR (TO_DATE ('12/31/'
                                          || TO_CHAR (SYSDATE, 'YYYY'),
                                          'MM/DD/YYYY'
                                         ),
                                 'DDD'
                                )
                       )
        INTO v_year
        FROM DUAL;

      FOR item IN (SELECT TO_DATE, from_date, pack_ben_cd
                     FROM gipi_witem
                    WHERE par_id = p_par_id AND item_no = p_item_no)
      LOOP
         v_item_to_date := item.TO_DATE;
         v_item_from_date := item.from_date;
         v_pack_ben_cd := item.pack_ben_cd;
      END LOOP;

      FOR polbas IN (SELECT expiry_date, incept_date, line_cd
                       FROM gipi_wpolbas
                      WHERE par_id = p_par_id)
      LOOP
         v_expiry_date := polbas.expiry_date;
         v_incept_date := polbas.incept_date;
         v_line_cd := polbas.line_cd;
      END LOOP;

      v_no_of_days_comp :=
           NVL (TRUNC (v_item_to_date), TRUNC (v_expiry_date))
         - NVL (TRUNC (v_item_from_date), TRUNC (v_incept_date));

      --grace 03.15.2006
      DELETE FROM gipi_witmperl_grouped
            WHERE par_id = p_par_id AND item_no = p_item_no;

      FOR grp_itmno IN (SELECT grouped_item_no
                          FROM gipi_wgrouped_items
                         WHERE par_id = p_par_id AND item_no = p_item_no)
      LOOP
         FOR pack_dtl IN (SELECT peril_cd, benefit, prem_pct, no_of_days,
                                 aggregate_sw, prem_amt
                            FROM giis_package_benefit_dtl
                           WHERE pack_ben_cd = v_pack_ben_cd)
         LOOP
            v_no_of_days := NVL (pack_dtl.no_of_days, 0);         --issa@fpac
            v_tsi_amt :=
                      NVL (pack_dtl.no_of_days, 1)
                      * NVL (pack_dtl.benefit, 0);                --issa@fpac
            v_prem_amt :=
               NVL (pack_dtl.prem_amt,
                    ROUND (  (  ((NVL (pack_dtl.prem_pct, 0)) / 100)
                              * NVL (v_tsi_amt, 0)
                              * NVL (v_no_of_days_comp, 1)
                             )
                           / v_year,
                           2
                          )
                   );                                              --issa@fpac

            /*    v_prem_rt                := ROUND((v_prem_amt/(v_tsi_amt*nvl(v_no_of_days_comp,1)/v_year))*100,9); --issa@fpac*/
            IF NVL (pack_dtl.prem_pct, 0) > 0
            THEN                                -->added by alfie 12.04.2008:)
               v_prem_rt := NVL (pack_dtl.prem_pct, 0) / 100;
            ELSE
               IF v_tsi_amt > 0
               THEN
                  v_prem_rt :=
                     ROUND (  (  v_prem_amt
                               / (  v_tsi_amt
                                  * NVL (v_no_of_days_comp, 1)
                                  / v_year
                                 )
                              )
                            * 100,
                            9
                           );                                      --issa@fpac
               END IF;
            END IF;                                                      -->:)

            v_ann_prem_amt :=
               NVL (ROUND (((pack_dtl.prem_pct) / 100) * v_tsi_amt, 2),
                    ROUND ((NVL (v_tsi_amt, 0) * (v_prem_rt / 100)), 2)
                   );                                    --issa@fpac09.19.2006

            --issa--v_ann_prem_amt     := nvl(ROUND(((nvl(pack_dtl.prem_pct,0))/100) * nvl(v_tsi_amt,0),2),ROUND((nvl(v_tsi_amt,0)*v_prem_rt),2));    --issa@fpac
            --issa--v_tsi_amt       := nvl(v_no_of_days,0) * nvl(pack_dtl.benefit,0);
            --issa--v_prem_amt      := ROUND((((nvl(pack_dtl.prem_pct,0))/100) * nvl(v_tsi_amt,0) * nvl(v_no_of_days,0))/v_year,2);
            --iss--v_ann_prem_amt     := ROUND(((nvl(pack_dtl.prem_pct,0))/100) * nvl(v_tsi_amt,0),2);
            INSERT INTO gipi_witmperl_grouped
                        (par_id, item_no, grouped_item_no,
                         line_cd, peril_cd, rec_flag,
                         prem_rt,
                         base_amt,
                         no_of_days, tsi_amt,
                         ann_tsi_amt, prem_amt, ann_prem_amt,
                         aggregate_sw
                        )
                 VALUES (p_par_id, p_item_no, grp_itmno.grouped_item_no,
                         v_line_cd, pack_dtl.peril_cd, 'C',
                         NVL (pack_dtl.prem_pct, v_prem_rt) /*--issa--pack_dtl.prem_pct*/,
                         pack_dtl.benefit,
                         NVL (pack_dtl.no_of_days, v_no_of_days), v_tsi_amt,
                         v_tsi_amt, v_prem_amt, v_ann_prem_amt,
                         pack_dtl.aggregate_sw
                        );

            SELECT a.peril_type
              INTO v_type
              FROM giis_peril a
             WHERE a.peril_cd = pack_dtl.peril_cd AND a.line_cd = v_line_cd;

            IF v_type = 'B'
            THEN
               v_ann_tsi_amt := ROUND ((v_ann_tsi_amt + v_tsi_amt), 2);
            END IF;

            v_prem_amt2 := ROUND ((v_prem_amt2 + v_prem_amt), 2);
            v_ann_prem_amt2 := ROUND ((v_ann_prem_amt2 + v_ann_prem_amt), 2);

---------------------------------------------------------------
--A.R.C. 06.12.2007
--to populate gipi_wpolwc
            FOR a1 IN (SELECT a.line_cd, a.main_wc_cd
                         FROM giis_peril_clauses a
                        WHERE a.line_cd = v_line_cd
                          AND a.peril_cd = pack_dtl.peril_cd
                          AND NOT EXISTS (
                                 SELECT '1'
                                   FROM gipi_wpolwc b
                                  WHERE b.par_id = p_par_id
                                    AND b.line_cd = a.line_cd
                                    AND b.wc_cd = a.main_wc_cd))
            LOOP
               FOR b IN (SELECT line_cd, main_wc_cd, print_sw, wc_title
                           FROM giis_warrcla
                          WHERE line_cd = a1.line_cd
                            AND main_wc_cd = a1.main_wc_cd)
               LOOP
                  INSERT INTO gipi_wpolwc
                              (par_id, line_cd, wc_cd, swc_seq_no,
                               print_seq_no, wc_title, rec_flag, print_sw,
                               change_tag
                              )
                       VALUES (p_par_id, b.line_cd, b.main_wc_cd, 0,
                               1, b.wc_title, 'A', b.print_sw,
                               'N'
                              );
               END LOOP;
            END LOOP;
---------------------------------------------------------------
         END LOOP;

         UPDATE gipi_wgrouped_items
            SET ann_tsi_amt = v_ann_tsi_amt,
                tsi_amt = v_ann_tsi_amt,
                ann_prem_amt = v_ann_prem_amt2,
                prem_amt = v_prem_amt2,
                pack_ben_cd = v_pack_ben_cd,
                amount_covered = v_ann_tsi_amt
          WHERE par_id = p_par_id
            AND item_no = p_item_no
            AND grouped_item_no = grp_itmno.grouped_item_no;

         v_ann_tsi_amt := 0;
         v_prem_amt2 := 0;
         v_ann_prem_amt2 := 0;
      /*UPDATE gipi_wgrouped_items
         SET pack_ben_cd = :b480.pack_ben_cd
       WHERE par_id = :b240.par_id
         AND item_no = :b480.item_no
         AND grouped_item_no = grp_itmno.grouped_item_no;*/
      END LOOP;
   END;

   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  05.28.2010
   **  Reference By : (GIPIS012- Item Information - Accident - Grouped Items)
   **  Description  : This returns if par_id and item_no is existing in GIPI_WGROUPED_ITEMS
   */
   FUNCTION gipi_wgrouped_items_exist (
      p_par_id    gipi_wgrouped_items.par_id%TYPE,
      p_item_no   gipi_wgrouped_items.item_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_exist   VARCHAR2 (1) := 'N';
   BEGIN
      FOR a IN (SELECT 1
                  FROM gipi_wgrouped_items
                 WHERE par_id = p_par_id AND item_no = p_item_no)
      LOOP
         v_exist := 'Y';
      END LOOP;

      RETURN v_exist;
   END;

    /*
   **  Created by   :  Jerome Orio
   **  Date Created :  06.04.2010
   **  Reference By : (GIPIS012- Item Information - Accident - Grouped Items)
   **  Description  : RENUMBER_GROUP program unit
   */
   PROCEDURE renumber_group (
      p_par_id    gipi_wgrouped_items.par_id%TYPE,
      p_item_no   gipi_wgrouped_items.item_no%TYPE
   )
   IS
      v_cnt_item   NUMBER                    := 0;
      v_old_no     gipi_witem.item_no%TYPE;
      exist        VARCHAR2 (1);
   BEGIN
      FOR cnt IN (SELECT COUNT (*) item
                    FROM gipi_wgrouped_items
                   WHERE par_id = p_par_id AND item_no = p_item_no)
      LOOP
         v_cnt_item := cnt.item;
         EXIT;
      END LOOP;

      IF v_cnt_item > 0
      THEN
         FOR a IN 1 .. v_cnt_item
         LOOP
            v_old_no := NULL;
            exist := 'N';

            FOR b IN (SELECT '1'
                        FROM gipi_wgrouped_items
                       WHERE par_id = p_par_id
                         AND item_no = p_item_no
                         AND grouped_item_no = a)
            LOOP
               exist := 'Y';
               EXIT;
            END LOOP;

            IF exist = 'N'
            THEN
               FOR c IN (SELECT   item_no, grouped_item_no, include_tag,
                                  grouped_item_title, sex, position_cd,
                                  civil_status, date_of_birth, age, salary,
                                  salary_grade, amount_covered, remarks,
                                  line_cd, subline_cd, delete_sw, group_cd,
                                  from_date, TO_DATE, payt_terms,
                                  pack_ben_cd, ann_tsi_amt, ann_prem_amt,
                                  control_cd, control_type_cd, tsi_amt,
                                  prem_amt
                             FROM gipi_wgrouped_items
                            WHERE par_id = p_par_id
                              AND grouped_item_no > a
                              AND item_no = p_item_no
                         ORDER BY grouped_item_no)
               LOOP
                  v_old_no := c.grouped_item_no;

                  INSERT INTO gipi_wgrouped_items
                              (item_no, grouped_item_no, include_tag,
                               grouped_item_title, sex, position_cd,
                               civil_status, date_of_birth, age,
                               salary, salary_grade, amount_covered,
                               remarks, line_cd, subline_cd,
                               delete_sw, group_cd, par_id,
                               from_date, TO_DATE, payt_terms,
                               pack_ben_cd, ann_tsi_amt, ann_prem_amt,
                               control_cd, control_type_cd, tsi_amt,
                               prem_amt
                              )
                       VALUES (c.item_no, a, c.include_tag,
                               c.grouped_item_title, c.sex, c.position_cd,
                               c.civil_status, c.date_of_birth, c.age,
                               c.salary, c.salary_grade, c.amount_covered,
                               c.remarks, c.line_cd, c.subline_cd,
                               c.delete_sw, c.group_cd, p_par_id,
                               c.from_date, c.TO_DATE, c.payt_terms,
                               c.pack_ben_cd, c.ann_tsi_amt, c.ann_prem_amt,
                               c.control_cd, c.control_type_cd, c.tsi_amt,
                               c.prem_amt
                              );

                  EXIT;
               END LOOP;

               UPDATE gipi_wgrp_items_beneficiary
                  SET grouped_item_no = a
                WHERE par_id = p_par_id
                  AND item_no = p_item_no
                  AND grouped_item_no = v_old_no;

               UPDATE gipi_witmperl_beneficiary                         -- nok
                  SET grouped_item_no = a
                WHERE par_id = p_par_id
                  AND item_no = p_item_no
                  AND grouped_item_no = v_old_no;

               UPDATE gipi_witmperl_grouped                             -- nok
                  SET grouped_item_no = a
                WHERE par_id = p_par_id
                  AND item_no = p_item_no
                  AND grouped_item_no = v_old_no;

               DELETE      gipi_wgrouped_items
                     WHERE par_id = p_par_id
                       AND item_no = p_item_no
                       AND grouped_item_no = v_old_no;
            END IF;
         END LOOP;
      END IF;
   END;

   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  06.07.2010
   **  Reference By : (GIPIS012- Item Information - Accident - Grouped Items)
   **  Description  : OK button in cg$copyben
   */
   PROCEDURE copy_benefits (
      p_par_id                 gipi_wgrouped_items.par_id%TYPE,
      p_item_no                gipi_wgrouped_items.item_no%TYPE,
      p_line_cd                gipi_wpolbas.line_cd%TYPE,
      p_grouped_item_no        gipi_wgrouped_items.grouped_item_no%TYPE,
      p_benefits_sw            VARCHAR2,
      p_orig_grouped_item_no   gipi_wgrouped_items.grouped_item_no%TYPE,
      p_pack_ben_cd            gipi_wgrouped_items.pack_ben_cd%TYPE
   )
   IS
      v_tsi_amt                  NUMBER                                  := 0;
      v_prem_amt                 NUMBER                                  := 0;
      v_prem_amt2                NUMBER                                  := 0;
      v_ann_tsi_amt              NUMBER                                  := 0;
      v_ann_prem_amt             NUMBER                                  := 0;
      v_ann_prem_amt2            NUMBER                                  := 0;
      v_year                     NUMBER                                  := 0;
      v_prem_rt                  giis_package_benefit_dtl.prem_pct%TYPE;
      v_no_of_days               NUMBER;
      v_no_of_days2              NUMBER                                  := 0;
      v_days                     NUMBER                                  := 0;
      v_grp_to_date              DATE;
      v_grp_from_date            DATE;
      v_item_to_date             DATE;
      v_item_from_date           DATE;
      v_expiry_date              DATE;
      v_incept_date              DATE;
      v_type                     VARCHAR2 (1)                           := '';
      v_witmperl_grouped_exist   VARCHAR2 (1)                          := 'N';
   BEGIN
      FOR item IN (SELECT TO_DATE, from_date
                     FROM gipi_witem
                    WHERE par_id = p_par_id AND item_no = p_item_no)
      LOOP
         v_item_to_date := item.TO_DATE;
         v_item_from_date := item.from_date;
      END LOOP;

      FOR polbas IN (SELECT expiry_date, incept_date
                       FROM gipi_wpolbas
                      WHERE par_id = p_par_id)
      LOOP
         v_expiry_date := polbas.expiry_date;
         v_incept_date := polbas.incept_date;
      END LOOP;

      FOR i IN (SELECT TO_DATE, from_date
                  FROM gipi_wgrouped_items
                 WHERE grouped_item_no = p_orig_grouped_item_no)
      LOOP
         v_grp_to_date := i.TO_DATE;
         v_grp_from_date := i.from_date;
      END LOOP;

      v_days :=
           NVL (TRUNC (v_grp_to_date),
                NVL (TRUNC (v_item_to_date), TRUNC (v_expiry_date))
               )
         - NVL (TRUNC (v_grp_from_date),
                NVL (TRUNC (v_item_from_date), TRUNC (v_incept_date))
               );

      IF p_benefits_sw = 'D'
      THEN
         DELETE FROM gipi_witmperl_grouped
               WHERE par_id = p_par_id
                 AND item_no = p_item_no
                 AND grouped_item_no = p_grouped_item_no;

         UPDATE gipi_wgrouped_items
            SET ann_tsi_amt = v_ann_tsi_amt,
                tsi_amt = v_ann_tsi_amt,
                ann_prem_amt = v_ann_prem_amt2,
                prem_amt = v_prem_amt2,
                amount_covered = v_ann_tsi_amt
          WHERE par_id = p_par_id
            AND item_no = p_item_no
            AND grouped_item_no = p_grouped_item_no;
      ELSE
          --commented Nok pag nagloop kasi nadedelete ung nainsert na if multiple ung i-copy , transfer nalang sa DAOImpl ito
         /*DELETE FROM gipi_witmperl_grouped
               WHERE par_id = p_par_id
                 AND item_no = p_item_no
                 AND grouped_item_no = p_grouped_item_no;*/
         IF p_benefits_sw = 'P'
         THEN                                                  -- if POPULATE
            FOR a IN (SELECT peril_cd, benefit base_amt, prem_pct prem_rt,
                             no_of_days, prem_amt       --issa@fpac08.24.2006
                        FROM giis_package_benefit_dtl
                       WHERE pack_ben_cd = p_pack_ben_cd)
            LOOP
               SELECT TO_NUMBER (TO_CHAR (TO_DATE (   '12/31/'
                                                   || TO_CHAR (SYSDATE,
                                                               'YYYY'),
                                                   'MM/DD/YYYY'
                                                  ),
                                          'DDD'
                                         )
                                )
                 INTO v_year
                 FROM DUAL;

               --v_no_of_days        := nvl(a.no_of_days,0); --issa@fpac
               IF a.no_of_days IS NULL AND a.base_amt IS NOT NULL
               THEN
            --issa07.09.2007 to prevent ora-01476 when computing for v_prem_rt
                  v_no_of_days := 1;
                  v_tsi_amt := a.base_amt;
               ELSE
                  v_no_of_days := a.no_of_days;
                  v_tsi_amt := v_no_of_days * NVL (a.base_amt, 0);
                                                                  --issa@fpac
               END IF;

               v_prem_amt :=
                  NVL (a.prem_amt,
                       ROUND (  (  ((NVL (a.prem_rt, 0)) / 100)
                                 * NVL (v_tsi_amt, 0)
                                 * NVL (v_days, 0)
                                )
                              / v_year,
                              2
                             )
                      );                                           --issa@fpac
               v_prem_rt :=
                  ROUND (  (v_prem_amt
                            / (v_tsi_amt * NVL (v_days, 0) / v_year)
                           )
                         * 100,
                         9
                        );                                         --issa@fpac
               v_ann_prem_amt :=
                  NVL (ROUND (((a.prem_rt) / 100) * (v_tsi_amt), 2),
                       ROUND ((NVL (v_tsi_amt, 0) * (v_prem_rt / 100)), 2)
                      );                                 --issa@fpac09.19.2006

               --issa--v_ann_prem_amt     := nvl(ROUND(((nvl(a.prem_rt,0))/100) * nvl(v_tsi_amt,0),2),round((nvl(v_tsi_amt,0)*v_prem_rt),2)); --issa@fpac
               --issa--v_tsi_amt       := nvl(v_no_of_days,0) * nvl(a.base_amt,0);
               --issa--v_prem_amt      := ROUND((((nvl(a.prem_rt,0))/100) * nvl(v_tsi_amt,0) * nvl(v_no_of_days,0))/v_year,2);
               --issa--v_ann_prem_amt     := ROUND(((nvl(a.prem_rt,0))/100) * nvl(v_tsi_amt,0),2);
               FOR asd IN (SELECT 1
                             FROM gipi_witmperl_grouped
                            WHERE par_id = p_par_id
                              AND item_no = p_item_no
                              AND grouped_item_no = p_grouped_item_no
                              AND peril_cd = a.peril_cd)
               LOOP
                  v_witmperl_grouped_exist := 'Y';
               END LOOP;

               IF v_witmperl_grouped_exist = 'Y'
               THEN
                  UPDATE gipi_witmperl_grouped
                     SET line_cd = p_line_cd,
                         rec_flag = 'C',
                         no_of_days = v_no_of_days,
                         prem_rt = NVL (a.prem_rt, v_prem_rt),
                         tsi_amt = v_tsi_amt,
                         prem_amt = v_prem_amt,
                         ann_tsi_amt = v_tsi_amt,
                         ann_prem_amt = v_ann_prem_amt,
                         aggregate_sw = 'Y',
                         base_amt = a.base_amt;
               ELSE
                  INSERT INTO gipi_witmperl_grouped
                              (par_id, item_no, grouped_item_no,
                               line_cd, peril_cd, rec_flag, no_of_days,
                               prem_rt,
                               tsi_amt, prem_amt, ann_tsi_amt,
                               ann_prem_amt, aggregate_sw, base_amt
                              )
                       VALUES (p_par_id, p_item_no, p_grouped_item_no,
                               p_line_cd, a.peril_cd, 'C', v_no_of_days,
                               NVL (a.prem_rt, v_prem_rt) /*--issa--a.prem_rt*/,
                               v_tsi_amt, v_prem_amt, v_tsi_amt,
                               v_ann_prem_amt, 'Y', a.base_amt
                              );
               END IF;

               SELECT peril_type
                 INTO v_type
                 FROM giis_peril
                WHERE peril_cd = a.peril_cd AND line_cd = p_line_cd;

               IF v_type = 'B'
               THEN
                  v_ann_tsi_amt := ROUND ((v_ann_tsi_amt + v_tsi_amt), 2);
               END IF;

               v_prem_amt2 := ROUND ((v_prem_amt2 + v_prem_amt), 2);
               v_ann_prem_amt2 :=
                                ROUND ((v_ann_prem_amt2 + v_ann_prem_amt), 2);

---------------------------------------------------------------
--A.R.C. 06.12.2007
--to populate gipi_wpolwc
               FOR a1 IN (SELECT b.line_cd, b.main_wc_cd
                            FROM giis_peril_clauses b
                           WHERE b.line_cd = p_line_cd
                             AND b.peril_cd = a.peril_cd
                             AND NOT EXISTS (
                                    SELECT '1'
                                      FROM gipi_wpolwc c
                                     WHERE c.par_id = p_par_id
                                       AND c.line_cd = b.line_cd
                                       AND c.wc_cd = b.main_wc_cd))
               LOOP
                  FOR b IN (SELECT line_cd, main_wc_cd, print_sw, wc_title
                              FROM giis_warrcla
                             WHERE line_cd = a1.line_cd
                               AND main_wc_cd = a1.main_wc_cd)
                  LOOP
                     INSERT INTO gipi_wpolwc
                                 (par_id, line_cd, wc_cd, swc_seq_no,
                                  print_seq_no, wc_title, rec_flag,
                                  print_sw, change_tag
                                 )
                          VALUES (p_par_id, b.line_cd, b.main_wc_cd, 0,
                                  1, b.wc_title, 'A',
                                  b.print_sw, 'N'
                                 );
                  END LOOP;
               END LOOP;
---------------------------------------------------------------
            END LOOP;
         ELSIF p_benefits_sw = 'C'
         THEN                                                        --if COPY
            FOR a IN (SELECT   peril_cd, base_amt, prem_rt, ann_tsi_amt,
                               no_of_days, tsi_amt, ann_prem_amt, prem_amt,
                               aggregate_sw
                          FROM gipi_witmperl_grouped
                         WHERE par_id = p_par_id
                           AND item_no = p_item_no
                           AND grouped_item_no = p_orig_grouped_item_no
                      ORDER BY grouped_item_no)
            LOOP
               v_no_of_days2 := NVL (a.no_of_days, v_no_of_days);

               FOR asd IN (SELECT 1
                             FROM gipi_witmperl_grouped
                            WHERE par_id = p_par_id
                              AND item_no = p_item_no
                              AND grouped_item_no = p_grouped_item_no
                              AND peril_cd = a.peril_cd)
               LOOP
                  v_witmperl_grouped_exist := 'Y';
               END LOOP;

               IF v_witmperl_grouped_exist = 'Y'
               THEN
                  UPDATE gipi_witmperl_grouped
                     SET line_cd = p_line_cd,
                         rec_flag = 'C',
                         no_of_days = v_no_of_days2,
                         prem_rt = NVL (a.prem_rt, v_prem_rt),
                         tsi_amt = a.tsi_amt,
                         prem_amt = a.prem_amt,
                         ann_tsi_amt = a.ann_tsi_amt,
                         ann_prem_amt = a.ann_prem_amt,
                         aggregate_sw = a.aggregate_sw,
                         base_amt = a.base_amt;
               ELSE
                  INSERT INTO gipi_witmperl_grouped
                              (par_id, item_no, grouped_item_no,
                               line_cd, peril_cd, rec_flag, no_of_days,
                               prem_rt,
                               tsi_amt, prem_amt, ann_tsi_amt,
                               ann_prem_amt, aggregate_sw, base_amt
                              )
                       VALUES (p_par_id, p_item_no, p_grouped_item_no,
                               p_line_cd, a.peril_cd, 'C', v_no_of_days2,
                               NVL (a.prem_rt, v_prem_rt) /*--issa--a.prem_rt*/,
                               a.tsi_amt, a.prem_amt, a.ann_tsi_amt,
                               a.ann_prem_amt, a.aggregate_sw, a.base_amt
                              );
               END IF;

               SELECT peril_type
                 INTO v_type
                 FROM giis_peril
                WHERE peril_cd = a.peril_cd AND line_cd = p_line_cd;

               IF v_type = 'B'
               THEN
                  v_ann_tsi_amt := ROUND ((v_ann_tsi_amt + a.tsi_amt), 2);
               END IF;

               v_prem_amt2 := ROUND ((v_prem_amt2 + a.prem_amt), 2);
               v_ann_prem_amt2 :=
                                ROUND ((v_ann_prem_amt2 + a.ann_prem_amt), 2);

---------------------------------------------------------------
--A.R.C. 06.12.2007
--to populate gipi_wpolwc
               FOR a1 IN (SELECT b.line_cd, b.main_wc_cd
                            FROM giis_peril_clauses b
                           WHERE b.line_cd = p_line_cd
                             AND b.peril_cd = a.peril_cd
                             AND NOT EXISTS (
                                    SELECT '1'
                                      FROM gipi_wpolwc c
                                     WHERE c.par_id = p_par_id
                                       AND c.line_cd = b.line_cd
                                       AND c.wc_cd = b.main_wc_cd))
               LOOP
                  FOR b IN (SELECT line_cd, main_wc_cd, print_sw, wc_title
                              FROM giis_warrcla
                             WHERE line_cd = a1.line_cd
                               AND main_wc_cd = a1.main_wc_cd)
                  LOOP
                     INSERT INTO gipi_wpolwc
                                 (par_id, line_cd, wc_cd, swc_seq_no,
                                  print_seq_no, wc_title, rec_flag,
                                  print_sw, change_tag
                                 )
                          VALUES (p_par_id, b.line_cd, b.main_wc_cd, 0,
                                  1, b.wc_title, 'A',
                                  b.print_sw, 'N'
                                 );
                  END LOOP;
               END LOOP;
---------------------------------------------------------------
            END LOOP;
         END IF;                               -- end of IF ELSE COPY/POPULATE

         UPDATE gipi_wgrouped_items
            SET ann_tsi_amt = v_ann_tsi_amt,
                tsi_amt = v_ann_tsi_amt,
                ann_prem_amt = v_ann_prem_amt2,
                prem_amt = v_prem_amt2,
                amount_covered = v_ann_tsi_amt,
                pack_ben_cd = p_pack_ben_cd            --temporary... 03/17/06
          WHERE par_id = p_par_id
            AND item_no = p_item_no
            AND grouped_item_no = p_grouped_item_no;

         v_ann_tsi_amt := 0;
         v_prem_amt2 := 0;
         v_ann_prem_amt2 := 0;
      END IF;
   END;

   /*
   **Created by    : Angelo Pagaduan
   **Date Created  : 10.12.2010
   **Reference By  : (GIPIS065 - Grouped Items - Retrieve Grp Items)
   **Description      : checks if there are grouped items to be retrieved
   */
   FUNCTION check_retrieve_grouped_items (
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE,
      p_item_no      gipi_grouped_items.item_no%TYPE,
      p_eff_date     gipi_polbasic.eff_date%TYPE
   )
      RETURN VARCHAR2
   IS
      v_message     VARCHAR2 (100)                      := 'OK';
      v_policy_id   gipi_polbasic.policy_id%TYPE;
      v_from_date   gipi_grouped_items.from_date%TYPE;
      v_to_date     gipi_grouped_items.TO_DATE%TYPE;
   BEGIN
      FOR grouped IN (SELECT DISTINCT a.policy_id policy_id, a.endt_seq_no,
                                      b.from_date from_date,
                                      b.TO_DATE TO_DATE
                                 FROM gipi_polbasic a, gipi_grouped_items b
                                WHERE a.line_cd = p_line_cd
                                  AND a.subline_cd = p_subline_cd
                                  AND a.iss_cd = p_iss_cd
                                  AND a.issue_yy = p_issue_yy
                                  AND a.pol_seq_no = p_pol_seq_no
                                  AND a.renew_no = p_renew_no
                                  AND a.pol_flag IN ('1', '2', '3', 'X')
                                  AND a.policy_id = b.policy_id
                                  AND b.item_no = p_item_no
                                  AND p_eff_date BETWEEN TRUNC
                                                              (NVL (from_date,
                                                                    eff_date
                                                                   )
                                                              )
                                                     AND NVL
                                                           (TO_DATE,
                                                            NVL
                                                               (endt_expiry_date,
                                                                expiry_date
                                                               )
                                                           )
                             ORDER BY endt_seq_no DESC)
      LOOP
         v_policy_id := grouped.policy_id;
         v_from_date := grouped.from_date;
         v_to_date := grouped.TO_DATE;
         EXIT;
      END LOOP;

      IF NVL (v_policy_id, 0) <> 0 AND v_from_date IS NULL
         AND v_to_date IS NULL
      THEN
         BEGIN
            FOR items IN (SELECT DISTINCT a.policy_id policy_id
                                     FROM gipi_polbasic a, gipi_item b
                                    WHERE a.policy_id = v_policy_id
                                      AND a.pol_flag IN ('1', '2', '3', 'X')
                                      AND a.policy_id = b.policy_id
                                      AND p_eff_date
                                             BETWEEN TRUNC (NVL (from_date,
                                                                 eff_date
                                                                )
                                                           )
                                                 AND NVL
                                                       (TO_DATE,
                                                        NVL (endt_expiry_date,
                                                             expiry_date
                                                            )
                                                       ))
            LOOP
               v_policy_id := items.policy_id;
               EXIT;
            END LOOP;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_message :=
                     'No Grouped Items to retrieve. '
                  || 'Check Endt effectivity date on Item and Grouped Item level';
         END;
      ELSIF NVL (v_policy_id, 0) = 0
      THEN
         v_message :=
               'No Grouped Items to retrieve. '
            || 'Grouped items do not exist in previous endorsements';
      END IF;

      RETURN v_message;
   END;

   /*
   **Created by  : Angelo Pagaduan
   **Date Created   : 10.13.2010
   **Reference By  : (GIPIS065 - Grouped Items - Retrieve Grp Items)
   **Description      : retrieves grouped items
   */
   FUNCTION retrieve_grouped_items (
      p_par_id       gipi_wgrouped_items.par_id%TYPE,
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE,
      p_item_no      gipi_grouped_items.item_no%TYPE,
      p_eff_date     gipi_polbasic.eff_date%TYPE
   )
      RETURN gipi_grouped_items_tab PIPELINED
   IS
      v_row   gipi_grouped_items_type;
   BEGIN
      FOR grouped_item IN
         (SELECT policy_id, grouped_item_no, grouped_item_title, item_no,
                 control_cd, control_type_cd
            FROM gipi_grouped_items
           WHERE policy_id IN (
                    SELECT policy_id
                      FROM (SELECT DISTINCT policy_id
                                       FROM gipi_grouped_items
                                      WHERE policy_id IN (
                                               SELECT DISTINCT b.policy_id
                                                          FROM gipi_polbasic a,
                                                               gipi_grouped_items b
                                                         WHERE a.line_cd =
                                                                     p_line_cd
                                                           AND a.subline_cd =
                                                                  p_subline_cd
                                                           AND a.iss_cd =
                                                                      p_iss_cd
                                                           AND a.issue_yy =
                                                                    p_issue_yy
                                                           AND a.pol_seq_no =
                                                                  p_pol_seq_no
                                                           AND a.renew_no =
                                                                    p_renew_no
                                                           AND a.pol_flag IN
                                                                  ('1', '2',
                                                                   '3', 'X')
                                                           AND a.policy_id =
                                                                   b.policy_id
                                                           AND b.item_no =
                                                                     p_item_no
                                                           AND p_eff_date
                                                                  BETWEEN TRUNC
                                                                            (NVL
                                                                                (from_date,
                                                                                 eff_date
                                                                                )
                                                                            )
                                                                      AND NVL
                                                                            (TO_DATE,
                                                                             NVL
                                                                                (endt_expiry_date,
                                                                                 expiry_date
                                                                                )
                                                                            )
                                                           AND endt_seq_no =
                                                                  (SELECT MAX
                                                                             (endt_seq_no
                                                                             )
                                                                     FROM gipi_polbasic x,
                                                                          gipi_grouped_items y
                                                                    WHERE x.line_cd =
                                                                             p_line_cd
                                                                      AND x.subline_cd =
                                                                             p_subline_cd
                                                                      AND x.iss_cd =
                                                                             p_iss_cd
                                                                      AND x.issue_yy =
                                                                             p_issue_yy
                                                                      AND x.pol_seq_no =
                                                                             p_pol_seq_no
                                                                      AND x.renew_no =
                                                                             p_renew_no
                                                                      AND x.pol_flag IN
                                                                             ('1',
                                                                              '2',
                                                                              '3',
                                                                              'X')
                                                                      AND x.policy_id =
                                                                             y.policy_id
                                                                      AND y.grouped_item_no =
                                                                             b.grouped_item_no
                                                                      AND y.item_no =
                                                                             p_item_no
                                                                      AND p_eff_date
                                                                             BETWEEN TRUNC
                                                                                       (NVL
                                                                                           (from_date,
                                                                                            eff_date
                                                                                           )
                                                                                       )
                                                                                 AND NVL
                                                                                       (TO_DATE,
                                                                                        NVL
                                                                                           (endt_expiry_date,
                                                                                            expiry_date
                                                                                           )
                                                                                       ))
                                                           AND item_no =
                                                                     p_item_no)))
             AND grouped_item_no NOT IN (SELECT grouped_item_no
                                           FROM gipi_wgrouped_items
                                          WHERE par_id = p_par_id))
      LOOP
         v_row.policy_id := grouped_item.policy_id;
         v_row.grouped_item_no := grouped_item.grouped_item_no;
         v_row.grouped_item_title := grouped_item.grouped_item_title;
         v_row.item_no := grouped_item.item_no;
         v_row.control_cd := grouped_item.control_cd;
         v_row.control_type_cd := grouped_item.control_type_cd;
         PIPE ROW (v_row);
      END LOOP;

      RETURN;
   END;

   /*
   **Created by  : Angelo Pagaduan
   **Date Created   : 10.13.2010
   **Reference By  : (GIPIS065 - Grouped Items - Retrieve Grp Items)
   **Description      : gipi_grouped_items.ok button - when_button_pressed
   */
   PROCEDURE insert_retrieved_grouped_items (
      p_par_id               gipi_wgrouped_items.par_id%TYPE,
      p_line_cd              gipi_polbasic.line_cd%TYPE,
      p_subline_cd           gipi_polbasic.subline_cd%TYPE,
      p_iss_cd               gipi_polbasic.iss_cd%TYPE,
      p_issue_yy             gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no           gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no             gipi_polbasic.renew_no%TYPE,
      p_item_no              gipi_grouped_items.item_no%TYPE,
      p_eff_date             gipi_polbasic.eff_date%TYPE,
      p_grouped_item_no      gipi_wgrouped_items.grouped_item_no%TYPE,
      p_grouped_item_title   gipi_wgrouped_items.grouped_item_title%TYPE,
      p_control_cd           gipi_wgrouped_items.control_cd%TYPE,
      p_control_type_cd      gipi_wgrouped_items.control_type_cd%TYPE
   )
   IS
      v_endt_seq_no       gipi_polbasic.endt_seq_no%TYPE;
      v_grouped_item_no   gipi_grouped_items.grouped_item_no%TYPE;
   BEGIN
      DELETE FROM gipi_wgrouped_items
            WHERE par_id = p_par_id
              AND item_no = p_item_no
              AND grouped_item_no = p_grouped_item_no;

      DELETE FROM gipi_witmperl_grouped
            WHERE par_id = p_par_id
              AND item_no = p_item_no
              AND grouped_item_no = p_grouped_item_no;

      DELETE FROM gipi_wgrp_items_beneficiary
            WHERE par_id = p_par_id
              AND item_no = p_item_no
              AND grouped_item_no = p_grouped_item_no;

      FOR c1 IN
         (SELECT MAX (endt_seq_no) endt_seq_no
                           --, grouped_item_no  --A.R.C. 06.15.2007  --comment
            FROM gipi_grouped_items y, gipi_polbasic x
           WHERE x.line_cd = p_line_cd
             AND x.subline_cd = p_subline_cd
             AND x.iss_cd = p_iss_cd
             AND x.issue_yy = p_issue_yy
             AND x.pol_seq_no = p_pol_seq_no
             AND x.renew_no = p_renew_no
             AND x.pol_flag IN ('1', '2', '3', 'X')
             AND y.policy_id = x.policy_id
             AND y.item_no = p_item_no
             AND y.grouped_item_no =
                          p_grouped_item_no
                                           --A.R.C. 06.15.2007 --add condition
             AND p_eff_date BETWEEN TRUNC (NVL (from_date, eff_date))
                                AND NVL (TO_DATE,
                                         NVL (endt_expiry_date, expiry_date)
                                        )
                                         /*GROUP BY grouped_item_no*/
         )                                       --A.R.C. 06.15.2007 --comment
      LOOP
         v_endt_seq_no := c1.endt_seq_no;
      --v_grouped_item_no := c1.grouped_item_no; --A.R.C. 06.15.2007  --comment
      END LOOP;                                     --A.R.C. 06.15.2007  --add

      FOR c2 IN
         (SELECT /*DISTINCT*/ b.policy_id,
                  b.grouped_item_no              --A.R.C. 06.15.2007 --comment
            FROM gipi_grouped_items b, gipi_polbasic a
           WHERE a.line_cd = p_line_cd
             AND a.subline_cd = p_subline_cd
             AND a.iss_cd = p_iss_cd
             AND a.issue_yy = p_issue_yy
             AND a.pol_seq_no = p_pol_seq_no
             AND a.renew_no = p_renew_no
             AND a.pol_flag IN ('1', '2', '3', 'X')
             AND b.policy_id = a.policy_id
             --AND b.grouped_item_no = v_grouped_item_no  --A.R.C. 06.15.2007  --comment
             AND b.grouped_item_no = p_grouped_item_no
             AND b.item_no = p_item_no
             AND p_eff_date BETWEEN TRUNC (NVL (from_date, eff_date))
                                AND NVL (TO_DATE,
                                         NVL (endt_expiry_date, expiry_date)
                                        )
             AND endt_seq_no = v_endt_seq_no)
      LOOP
         INSERT INTO gipi_wgrouped_items
                     (par_id, item_no, grouped_item_no, grouped_item_title,
                      include_tag, sex, position_cd, civil_status,
                      date_of_birth, age, salary, salary_grade,
                      amount_covered, remarks, line_cd, subline_cd,
                      delete_sw, group_cd, from_date, TO_DATE, payt_terms,
                      pack_ben_cd, ann_tsi_amt, ann_prem_amt, control_cd,
                      control_type_cd
                                 --, TSI_AMT, PREM_AMT)  --A.R.C. 087.22.2006
                                     ,
                      principal_cd)                         --Connie 08032007
            SELECT p_par_id, item_no, grouped_item_no, grouped_item_title,
                   include_tag, sex, position_cd, civil_status,
                   date_of_birth, age, salary, salary_grade, amount_coverage,
                   remarks, line_cd, subline_cd, delete_sw, group_cd,
                   from_date, TO_DATE, payt_terms, pack_ben_cd, ann_tsi_amt,
                   ann_prem_amt, control_cd,
                   control_type_cd  --, TSI_AMT, PREM_AMT --A.R.C. 08.22.2006
                                  ,
                   principal_cd                             --Connie 08032007
              FROM gipi_grouped_items
             WHERE policy_id = c2.policy_id
               AND item_no = p_item_no
               AND grouped_item_no = p_grouped_item_no;

         INSERT INTO gipi_witmperl_grouped
                     (par_id, item_no, grouped_item_no, line_cd, peril_cd,
                      rec_flag, prem_rt,                                                /*TSI_AMT, --A.R.C. 08.22.2006
                                         PREM_AMT,*/ ann_tsi_amt,
                      ann_prem_amt, aggregate_sw, base_amt, ri_comm_rate,
                      ri_comm_amt, no_of_days)
            SELECT p_par_id, item_no, grouped_item_no, line_cd, peril_cd,
                   rec_flag, prem_rt,                                                                            /*TSI_AMT, --A.R.C. 08.22.2006
                                      PREM_AMT,*/ ann_tsi_amt, ann_prem_amt,
                   aggregate_sw, base_amt, ri_comm_rate, ri_comm_amt,
                   no_of_days
              FROM gipi_itmperil_grouped
             WHERE policy_id = c2.policy_id
               AND item_no = p_item_no
               AND grouped_item_no = p_grouped_item_no;

         INSERT INTO gipi_wgrp_items_beneficiary
                     (par_id, item_no, grouped_item_no, beneficiary_no,
                      beneficiary_name, beneficiary_addr, relation,
                      date_of_birth, age, civil_status, sex)
            SELECT p_par_id, item_no, grouped_item_no, beneficiary_no,
                   beneficiary_name, beneficiary_addr, relation,
                   date_of_birth, age, civil_status, sex
              FROM gipi_grp_items_beneficiary
             WHERE policy_id = c2.policy_id
               AND item_no = p_item_no
               AND grouped_item_no = p_grouped_item_no;

         --issa07.09.2007 to retrieve WC from policy
         FOR i IN (SELECT DISTINCT peril_cd
                              FROM gipi_itmperil_grouped
                             WHERE policy_id = c2.policy_id)
         LOOP
            FOR a1 IN (SELECT a.line_cd, a.main_wc_cd
                         FROM giis_peril_clauses a
                        WHERE a.line_cd = p_line_cd
                          AND a.peril_cd = i.peril_cd
                          AND NOT EXISTS (
                                 SELECT '1'
                                   FROM gipi_wpolwc b
                                  WHERE b.par_id = p_par_id
                                    AND b.line_cd = a.line_cd
                                    AND b.wc_cd = a.main_wc_cd))
            LOOP
               FOR b IN (SELECT line_cd, main_wc_cd, print_sw, wc_title
                           FROM giis_warrcla
                          WHERE line_cd = a1.line_cd
                            AND main_wc_cd = a1.main_wc_cd)
               LOOP
                  INSERT INTO gipi_wpolwc
                              (par_id, line_cd, wc_cd, swc_seq_no,
                               print_seq_no, wc_title, rec_flag, print_sw,
                               change_tag
                              )
                       VALUES (p_par_id, b.line_cd, b.main_wc_cd, 0,
                               1, b.wc_title, 'A', b.print_sw,
                               'N'
                              );
               END LOOP;
            END LOOP;
         END LOOP;
      END LOOP;
   END;

   /*
   **Created by  : Angelo Pagaduan
   **Date Created   : 10.19.2010
   **Reference By  : (GIPIS065 - Grouped Items - Retrieve Grp Items)
   **Description      : retrieves gipi_wgrouped_items of retrieved grouped items
   */
   FUNCTION retgrpitms_gipi_wgrouped_items (
      p_par_id            gipi_wgrouped_items.par_id%TYPE,
      p_policy_id         gipi_grouped_items.policy_id%TYPE,
      p_item_no           gipi_grouped_items.item_no%TYPE,
      p_grouped_item_no   gipi_grouped_items.grouped_item_no%TYPE
   )
      RETURN gipi_wgrouped_items_tab PIPELINED
   IS
      v_row   gipi_wgrouped_items_type;
   BEGIN
      FOR gipi_wgrouped_item IN
         (SELECT p_par_id par_id, item_no, grouped_item_no,
                 grouped_item_title, include_tag, sex, position_cd,
                 civil_status, date_of_birth, age, salary, salary_grade,
                 amount_coverage, remarks, line_cd, subline_cd, delete_sw,
                 group_cd, from_date, TO_DATE, payt_terms, pack_ben_cd,
                 ann_tsi_amt, ann_prem_amt, control_cd,
                 control_type_cd    --, TSI_AMT, PREM_AMT --A.R.C. 08.22.2006
                                ,
                 principal_cd                               --Connie 08032007
            FROM gipi_grouped_items
           WHERE policy_id = p_policy_id
             AND item_no = p_item_no
             AND grouped_item_no = p_grouped_item_no)
      LOOP
         v_row.par_id := gipi_wgrouped_item.par_id;
         v_row.item_no := gipi_wgrouped_item.item_no;
         v_row.grouped_item_no := gipi_wgrouped_item.grouped_item_no;
         v_row.grouped_item_title := gipi_wgrouped_item.grouped_item_title;
         v_row.include_tag := gipi_wgrouped_item.include_tag;
         v_row.sex := gipi_wgrouped_item.sex;
         v_row.position_cd := gipi_wgrouped_item.position_cd;
         v_row.civil_status := gipi_wgrouped_item.civil_status;
         v_row.date_of_birth := gipi_wgrouped_item.date_of_birth;
         v_row.age := gipi_wgrouped_item.age;
         v_row.salary := gipi_wgrouped_item.salary;
         v_row.salary_grade := gipi_wgrouped_item.salary_grade;
         v_row.amount_covered := gipi_wgrouped_item.amount_coverage;
         v_row.remarks := gipi_wgrouped_item.remarks;
         v_row.line_cd := gipi_wgrouped_item.line_cd;
         v_row.subline_cd := gipi_wgrouped_item.subline_cd;
         v_row.delete_sw := gipi_wgrouped_item.delete_sw;
         v_row.group_cd := gipi_wgrouped_item.group_cd;
         v_row.from_date := gipi_wgrouped_item.from_date;
         v_row.TO_DATE := gipi_wgrouped_item.TO_DATE;
         v_row.payt_terms := gipi_wgrouped_item.payt_terms;
         v_row.pack_ben_cd := gipi_wgrouped_item.pack_ben_cd;
         v_row.ann_tsi_amt := gipi_wgrouped_item.ann_tsi_amt;
         v_row.ann_prem_amt := gipi_wgrouped_item.ann_prem_amt;
         v_row.control_cd := gipi_wgrouped_item.control_cd;
         v_row.control_type_cd := gipi_wgrouped_item.control_type_cd;
         PIPE ROW (v_row);
      END LOOP;

      RETURN;
   END;

   /*
   **Created by  : D.Alcantara
   **Date Created   : 03.02.2011
   **Reference By  : (GIPIS012 - Accident Item Info)
   **Description      : renumbers grouped items when the item info has been renumbered
   */
   PROCEDURE renumber_group2 (
      p_par_id        gipi_wgrouped_items.par_id%TYPE,
      p_old_item_no   gipi_wgrouped_items.item_no%TYPE,
      p_new_item_no   gipi_wgrouped_items.item_no%TYPE
   )
   IS
      v_grouped_item   gipi_wgrouped_items%ROWTYPE;
      v_item_exists    VARCHAR2 (3);
      v_grp_exists     VARCHAR2 (3);
   BEGIN
      FOR a IN (SELECT '1'
                  FROM gipi_wgrouped_items
                 WHERE par_id = p_par_id AND item_no = p_old_item_no)
      LOOP
         v_grp_exists := 'Y';
      END LOOP;

      /*
      FOR b IN (
          SELECT '1' FROM GIPI_WITEM
              WHERE par_id = p_par_id AND
                    item_no = p_new_item_no)
      */
      IF v_grp_exists = 'Y'
      THEN
         FOR g IN (SELECT grouped_item_no, include_tag, grouped_item_title,
                          sex, position_cd, civil_status, date_of_birth, age,
                          salary, salary_grade, amount_covered, remarks,
                          line_cd, subline_cd, delete_sw, group_cd,
                          from_date, TO_DATE, payt_terms, pack_ben_cd,
                          ann_tsi_amt, ann_prem_amt, control_cd,
                          control_type_cd, tsi_amt, prem_amt
                     FROM gipi_wgrouped_items
                    WHERE par_id = p_par_id AND item_no = p_old_item_no)
         LOOP
            INSERT INTO gipi_wgrouped_items
                        (par_id, item_no, grouped_item_no,
                         include_tag, grouped_item_title, sex,
                         position_cd, civil_status, date_of_birth,
                         age, salary, salary_grade, amount_covered,
                         remarks, line_cd, subline_cd, delete_sw,
                         group_cd, from_date, TO_DATE, payt_terms,
                         pack_ben_cd, ann_tsi_amt, ann_prem_amt,
                         control_cd, control_type_cd, tsi_amt,
                         prem_amt
                        )
                 VALUES (p_par_id, p_new_item_no, g.grouped_item_no,
                         g.include_tag, g.grouped_item_title, g.sex,
                         g.position_cd, g.civil_status, g.date_of_birth,
                         g.age, g.salary, g.salary_grade, g.amount_covered,
                         g.remarks, g.line_cd, g.subline_cd, g.delete_sw,
                         g.group_cd, g.from_date, g.TO_DATE, g.payt_terms,
                         g.pack_ben_cd, g.ann_tsi_amt, g.ann_prem_amt,
                         g.control_cd, g.control_type_cd, g.tsi_amt,
                         g.prem_amt
                        );
         END LOOP;
      END IF;

      /*    UPDATE gipi_wgrouped_items
          SET item_no = p_new_item_no
          WHERE item_no = p_old_item_no AND
                par_id = p_par_id;*/
      UPDATE gipi_wgrp_items_beneficiary
         SET item_no = p_new_item_no
       WHERE par_id = p_par_id AND item_no = p_old_item_no;

      UPDATE gipi_witmperl_beneficiary
         SET item_no = p_new_item_no
       WHERE par_id = p_par_id AND item_no = p_old_item_no;

      UPDATE gipi_witmperl_grouped
         SET item_no = p_new_item_no
       WHERE par_id = p_par_id AND item_no = p_old_item_no;
   /*    DELETE gipi_wgrouped_items
                  WHERE par_id = p_par_id
                    AND item_no = p_old_item_no;              */
   END renumber_group2;

   /*
   **  Created by        : Mark JM
   **  Date Created    : 03.21.2011
   **  Reference By    : (GIPIS095 - Package Policy Items)
   **  Description     : Retrieve rows from gipi_grouped_items based on the given parameters
   */
   FUNCTION get_gipi_wgrouped_pack_pol (
      p_par_id    IN   gipi_wgrouped_items.par_id%TYPE,
      p_item_no   IN   gipi_wgrouped_items.item_no%TYPE
   )
      RETURN gipi_wgrouped_items_tab PIPELINED
   IS
      v_grouped_items   gipi_wgrouped_items_type;
   BEGIN
      FOR i IN (SELECT par_id, item_no
                  FROM gipi_wgrouped_items
                 WHERE par_id = p_par_id AND item_no = p_item_no)
      LOOP
         v_grouped_items.par_id := i.par_id;
         v_grouped_items.item_no := i.item_no;
         PIPE ROW (v_grouped_items);
      END LOOP;

      RETURN;
   END get_gipi_wgrouped_pack_pol;

   /*    Date        Author            Description
   **    ==========    ===============    ============================
   **    09.13.2011    mark jm            retrieve records on gipi_wgrouped_items based on given parameters (tablegrid varsion)
   */
   FUNCTION get_gipi_wgrouped_items_tg (
      p_par_id       IN   gipi_wgrouped_items.par_id%TYPE,
      p_item_no      IN   gipi_wgrouped_items.item_no%TYPE,
      p_item_title   IN   VARCHAR2,
      p_remarks      IN   VARCHAR2
   )
      RETURN gipi_wgrouped_items_tab PIPELINED
   IS
      v_grp   gipi_wgrouped_items_type;
   BEGIN
      FOR i IN
         (SELECT   a.par_id, a.item_no, a.grouped_item_no, a.include_tag,
                   a.grouped_item_title, a.sex, a.position_cd,
                   a.civil_status, a.date_of_birth, a.age, a.salary,
                   a.salary_grade, a.amount_covered, a.remarks, a.line_cd,
                   a.subline_cd, a.delete_sw, a.group_cd, a.from_date,
                   a.TO_DATE, a.payt_terms, a.pack_ben_cd, a.ann_tsi_amt,
                   a.ann_prem_amt, a.control_cd, a.control_type_cd,
                   a.tsi_amt, a.prem_amt, a.principal_cd, b.group_desc,
                   c.package_cd, d.payt_terms_desc
              FROM gipi_wgrouped_items a,
                   giis_group b,
                   giis_package_benefit c,
                   giis_payterm d
             WHERE a.par_id = p_par_id
               AND a.item_no = p_item_no
               AND a.group_cd = b.group_cd(+)
               AND a.pack_ben_cd = c.pack_ben_cd(+)
               AND a.payt_terms = d.payt_terms(+)
               AND UPPER (a.grouped_item_title) LIKE NVL(UPPER (p_item_title), '%%')
               AND UPPER (NVL (a.remarks, '***')) LIKE NVL(UPPER (p_remarks), '%%')
          ORDER BY par_id, item_no, grouped_item_no)
      LOOP
         v_grp.par_id                 := i.par_id;
         v_grp.item_no                 := i.item_no;
         v_grp.grouped_item_no         := i.grouped_item_no;
         v_grp.include_tag             := i.include_tag;
         v_grp.grouped_item_title     := i.grouped_item_title;
         v_grp.sex                     := i.sex;
         v_grp.position_cd             := i.position_cd;
         v_grp.civil_status         := i.civil_status;
         v_grp.date_of_birth         := i.date_of_birth;
         v_grp.age                     := i.age;
         v_grp.salary                 := i.salary;
         v_grp.salary_grade         := i.salary_grade;
         v_grp.amount_covered         := i.amount_covered;
         v_grp.remarks                 := i.remarks; -- ESCAPE_VALUE_CLOB(i.remarks); changed by robert 09262013
         v_grp.line_cd                 := i.line_cd;
         v_grp.subline_cd             := i.subline_cd;
         v_grp.delete_sw             := i.delete_sw;
         v_grp.group_cd             := i.group_cd;
         v_grp.from_date             := i.from_date;
         v_grp.TO_DATE                 := i.TO_DATE;
         v_grp.payt_terms             := i.payt_terms;
         v_grp.pack_ben_cd             := i.pack_ben_cd;
         v_grp.ann_tsi_amt             := i.ann_tsi_amt;
         v_grp.ann_prem_amt         := i.ann_prem_amt;
         v_grp.control_cd             := i.control_cd;
         v_grp.control_type_cd         := i.control_type_cd;
         v_grp.tsi_amt                 := i.tsi_amt;
         v_grp.prem_amt             := i.prem_amt;
         v_grp.principal_cd         := i.principal_cd;
         v_grp.group_desc             := i.group_desc;
         v_grp.package_cd             := i.package_cd;
         v_grp.payt_terms_desc         := i.payt_terms_desc;
         
         PIPE ROW (v_grp);
      END LOOP;

      RETURN;
   END get_gipi_wgrouped_items_tg;

   /*    Date        Author            Description
   **    ==========    ===============    ============================
   **    10.14.2011    mark jm            inserts records from grouped tables(witemperil_grouped, wgrouped_items)
   **                                 to witemperil and witem,
   **                                 created for distribution process(GIUWS004)
   **                                (original description)
   */
   PROCEDURE insert_recgrp_witem1 (
      p_par_id            IN   gipi_waccident_item.par_id%TYPE,
      p_item_no           IN   gipi_waccident_item.item_no%TYPE,
      p_grouped_item_no   IN   gipi_wgrouped_items.grouped_item_no%TYPE,
      p_line_cd           IN   gipi_wgrouped_items.line_cd%TYPE
   )
   IS
      v_exists            NUMBER                                 := 0;
      v_exists2           NUMBER                                 := 0;
      v_exists3           NUMBER                                 := 0;
                                                      --for deleting purposes
      v_exists4           NUMBER                                 := 0; --issa
      v_tsi_amt           gipi_witmperl.tsi_amt%TYPE             := 0;
      v_prem_amt          gipi_witmperl.prem_amt%TYPE            := 0;
      v_ann_prem_amt      gipi_witmperl.ann_prem_amt%TYPE        := 0;
                                      --issa@fpac09.18.2006, for ann_prem_amt
      v_ann_prem_amt4     gipi_grouped_items.ann_prem_amt%TYPE   := 0;
                                      --issa@fpac09.18.2006, for ann_prem_amt
      v_tsi_amt4          gipi_grouped_items.tsi_amt%TYPE        := 0;
      v_itmperil_exists   BOOLEAN                                := FALSE;
   BEGIN
      /*
      FOR a IN (
          SELECT 1
            FROM gipi_witmperl
           WHERE par_id = p_par_id
             AND item_no = p_item_no)
      LOOP
          v_itmperil_exists := TRUE;
          EXIT;
      END LOOP;

      FOR b IN (
          SELECT 2
            FROM gipi_witmperl_grouped
           WHERE par_id = p_par_id
             AND item_no = p_item_no)
      LOOP
          v_itmperil_exists := FALSE;
          EXIT;
      END LOOP;
      */
      --IF NOT v_itmperil_exists THEN
      FOR x IN (SELECT peril_cd
                  FROM gipi_witmperl
                 WHERE par_id = p_par_id AND item_no = p_item_no)
      LOOP
         v_exists3 := 1;

         FOR y IN (SELECT peril_cd
                     FROM gipi_witmperl_grouped
                    WHERE par_id = p_par_id
                      AND item_no = p_item_no
                      AND peril_cd = x.peril_cd)
         LOOP
            v_exists3 := 0;
         END LOOP;

         IF v_exists3 = 1
         THEN
            DELETE FROM gipi_witmperl
                  WHERE par_id = p_par_id
                    AND item_no = p_item_no
                    AND peril_cd = x.peril_cd;
         END IF;
      END LOOP;

      FOR j IN (SELECT   SUM (tsi_amt) tsi_amt, SUM (prem_amt) prem_amt,
                         SUM (ann_prem_amt) ann_prem_amt, a.peril_cd, item_no,
                         b.peril_type
                    FROM gipi_witmperl_grouped a, giis_peril b
                   WHERE par_id = p_par_id
                     AND item_no = p_item_no
                     AND a.peril_cd = b.peril_cd
                     AND a.line_cd = b.line_cd
                GROUP BY a.peril_cd, a.item_no, b.peril_type)
      LOOP
         v_exists2 := 1;

         FOR g IN (SELECT 1
                     FROM gipi_witmperl
                    WHERE par_id = p_par_id
                      AND item_no = p_item_no
                      AND peril_cd = j.peril_cd)
         LOOP
            v_exists := 1;
         END LOOP;

         IF v_exists = 1
         THEN
            UPDATE gipi_witmperl
               SET tsi_amt = j.tsi_amt,
                   prem_amt = j.prem_amt,
                   ann_tsi_amt = j.tsi_amt,
                   ann_prem_amt =
                         j.ann_prem_amt,
                                       --issa@fpac09.18.2006, for ann_prem_amt
                   prem_rt = ROUND((j.prem_amt / j.tsi_amt) * 100, 9) --vondanix 07.11.2016 - MAC 22652
             WHERE par_id = p_par_id
               AND item_no = p_item_no
               AND line_cd = p_line_cd
               AND peril_cd = j.peril_cd;

            v_exists := 0;
         ELSE
            INSERT INTO gipi_witmperl
                        (par_id, item_no, line_cd, peril_cd,
                         tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt
                        )              --issa@fpac09.18.2006, for ann_prem_amt
                 VALUES (p_par_id, p_item_no, p_line_cd, j.peril_cd,
                         j.tsi_amt, j.prem_amt, j.tsi_amt, j.ann_prem_amt
                        );
         END IF;

         IF j.peril_type = 'B'
         THEN
            v_tsi_amt := NVL (j.tsi_amt, 0) + v_tsi_amt;
         END IF;

         v_prem_amt := NVL (j.prem_amt, 0) + v_prem_amt;
         v_ann_prem_amt := NVL (j.ann_prem_amt, 0) + v_ann_prem_amt;
                                       --issa@fpac09.18.2006, for ann_prem_amt
      END LOOP;

      FOR i IN (SELECT   SUM (a.ann_prem_amt) ann_prem_amt,
                         SUM (a.tsi_amt) tsi_amt, b.peril_type
                    FROM gipi_witmperl_grouped a, giis_peril b
                   WHERE a.par_id = p_par_id
                     AND a.item_no = p_item_no
                     AND a.grouped_item_no = p_grouped_item_no
                     AND a.peril_cd = b.peril_cd
                     AND a.line_cd = b.line_cd
                GROUP BY b.peril_type)
      LOOP
         v_exists4 := 1;

         IF i.peril_type = 'B'
         THEN
            v_tsi_amt4 := NVL (i.tsi_amt, 0) + v_tsi_amt4;
            v_ann_prem_amt4 := NVL (i.ann_prem_amt, 0) + v_ann_prem_amt4;
                                       --issa@fpac09.18.2006, for ann_prem_amt
         END IF;

         
      END LOOP;

      -- added extra if statement based on the GIPIS012.GIPI_WGR_I BLOCK.KEY-COMMIT - IRWIN. 11.29.2011
      IF v_exists2 = 1
      THEN
         UPDATE gipi_witem
            SET tsi_amt = v_tsi_amt,
                prem_amt = v_prem_amt,
                ann_tsi_amt = v_tsi_amt,
                ann_prem_amt = v_ann_prem_amt
          --issa@fpac09.18.2006, for ann_prem_amt
         WHERE  par_id = p_par_id AND item_no = p_item_no;

         cr_bill_dist.get_tsi (p_par_id);
      ELSE
         UPDATE gipi_witem
            SET tsi_amt = 0,
                prem_amt = 0,
                ann_tsi_amt = 0,
                ann_prem_amt = 0
          WHERE par_id = p_par_id AND item_no = p_item_no;

         cr_bill_dist.get_tsi (p_par_id);
      END IF;

      IF v_exists4 = 1
      THEN
         UPDATE gipi_wgrouped_items
            SET ann_prem_amt = v_ann_prem_amt4,
                tsi_amt = v_tsi_amt4,
                ann_tsi_amt = v_tsi_amt4,
                amount_covered = v_tsi_amt4,
                prem_amt = v_ann_prem_amt4
          WHERE par_id = p_par_id
            AND item_no = p_item_no
            AND grouped_item_no = p_grouped_item_no;
      ELSE
         UPDATE gipi_wgrouped_items
            SET ann_prem_amt = 0,
                tsi_amt = 0,
                ann_tsi_amt = 0,
                amount_covered = 0,
                prem_amt = 0
          WHERE par_id = p_par_id
            AND item_no = p_item_no
            AND grouped_item_no = p_grouped_item_no;
      END IF;
       /*
       UPDATE gipi_witem
          SET tsi_amt = DECODE(v_exists2, 1, v_tsi_amt, 0),
              prem_amt = DECODE(v_exists2, 1, v_prem_amt, 0),
              ann_tsi_amt = DECODE(v_exists2, 1, v_tsi_amt, 0),
              ann_prem_amt = DECODE(v_exists2, 1, v_ann_prem_amt, 0) --issa@fpac09.18.2006, for ann_prem_amt
        WHERE par_id = p_par_id
          AND item_no = p_item_no;

       cr_bill_dist.get_tsi(p_par_id);

       UPDATE gipi_wgrouped_items
          SET ann_prem_amt = DECODE(v_exists4, 1, v_ann_prem_amt4, 0),
              tsi_amt = DECODE(v_exists4, 1, v_tsi_amt4, 0),
              ann_tsi_amt = DECODE(v_exists4, 1, v_tsi_amt4, 0)
        WHERE par_id = p_par_id
          AND item_no = p_item_no;
          --AND grouped_item_no = p_grouped_item_no;*/
   --END IF;
   END insert_recgrp_witem1;

   /*    Date        Author            Description
   **    ==========    ===============    ============================
   **    10.14.2011    mark jm            populate benefits based on selected grouped items
   **    10.20.2011    mark jm            modified transaction
   */
   PROCEDURE populate_benefits_tg (
      p_par_id             IN   gipi_waccident_item.par_id%TYPE,
      p_item_no            IN   gipi_waccident_item.item_no%TYPE,
      p_grouped_item_no    IN   gipi_wgrouped_items.grouped_item_no%TYPE,
      p_orig_grp_item_no   IN   gipi_wgrouped_items.grouped_item_no%TYPE,
      p_pack_ben_cd        IN   gipi_wgrouped_items.pack_ben_cd%TYPE,
      p_line_cd            IN   gipi_wgrouped_items.line_cd%TYPE,
      p_delete_ben_sw      IN   VARCHAR2,
      p_pop_checker        IN   VARCHAR2
   )
   IS
      v_no_of_days        NUMBER                                   := 0;
      v_no_of_days2       NUMBER                                   := 0;
      v_days              NUMBER                                   := 0;
--to store no of days computation, stored originally to v_no_of_days, issav_tsi_amt            NUMBER:=0;
      v_tsi_amt           NUMBER                                   := 0;
      v_prem_amt          NUMBER                                   := 0;
      v_item_to_date      DATE;
      v_item_from_date    DATE;
      v_expiry_date       DATE;
      v_incept_date       DATE;
      v_no_of_days_comp   NUMBER                                   := 0;
      v_year              NUMBER                                   := 0;
      v_prem_rt           giis_package_benefit_dtl.prem_pct%TYPE;
      v_prem_amt2         NUMBER                                   := 0;
      v_ann_prem_amt      NUMBER                                   := 0;
      v_ann_prem_amt2     NUMBER                                   := 0;
      v_type              VARCHAR2 (1)                             := '';
      v_ann_tsi_amt       NUMBER                                   := 0;
   BEGIN
      SELECT TO_NUMBER (TO_CHAR (TO_DATE ('12/31/'
                                          || TO_CHAR (SYSDATE, 'YYYY'),
                                          'MM/DD/YYYY'
                                         ),
                                 'DDD'
                                )
                       )
        INTO v_year
        FROM DUAL;

      FOR item IN (SELECT TO_DATE, from_date
                     FROM gipi_witem
                    WHERE par_id = p_par_id AND item_no = p_item_no)
      LOOP
         v_item_to_date := item.TO_DATE;
         v_item_from_date := item.from_date;
      END LOOP;

      FOR polbas IN (SELECT expiry_date, incept_date
                       FROM gipi_wpolbas
                      WHERE par_id = p_par_id)
      LOOP
         v_expiry_date := polbas.expiry_date;
         v_incept_date := polbas.incept_date;
      END LOOP;

      v_no_of_days_comp :=
           NVL (TRUNC (v_item_to_date), TRUNC (v_expiry_date))
         - NVL (TRUNC (v_item_from_date), TRUNC (v_incept_date));

      IF p_delete_ben_sw = 'Y'
      THEN
         DELETE FROM gipi_witmperl_grouped
               WHERE par_id = p_par_id
                 AND item_no = p_item_no
                 AND grouped_item_no = p_grouped_item_no;

         UPDATE gipi_wgrouped_items
            SET ann_tsi_amt = v_ann_tsi_amt,
                tsi_amt = v_ann_tsi_amt,
                ann_prem_amt = v_ann_prem_amt2,
                prem_amt = v_prem_amt2,
                amount_covered = v_ann_tsi_amt
          WHERE par_id = p_par_id
            AND item_no = p_item_no
            AND grouped_item_no = p_grouped_item_no;
      ELSE
         DELETE FROM gipi_witmperl_grouped
               WHERE par_id = p_par_id
                 AND item_no = p_item_no
                 AND grouped_item_no = p_grouped_item_no;

         IF p_pop_checker = 'Y'
         THEN
            FOR a IN (SELECT peril_cd, benefit base_amt, prem_pct prem_rt,
                             no_of_days, prem_amt,       --issa@fpac08.24.2006
                             aggregate_sw   --added by john 4.15.2015
                        FROM giis_package_benefit_dtl
                       WHERE pack_ben_cd = p_pack_ben_cd)
            LOOP
               SELECT TO_NUMBER (TO_CHAR (TO_DATE (   '12/31/'
                                                   || TO_CHAR (SYSDATE,
                                                               'YYYY'),
                                                   'MM/DD/YYYY'
                                                  ),
                                          'DDD'
                                         )
                                )
                 INTO v_year
                 FROM DUAL;

               IF a.no_of_days IS NULL AND a.base_amt IS NOT NULL
               THEN
            --issa07.09.2007 to prevent ora-01476 when computing for v_prem_rt
                  v_no_of_days := NVL(a.no_of_days,0);
                  v_tsi_amt := a.base_amt;
               ELSE
                  v_no_of_days := NVL(a.no_of_days,0);
                  v_tsi_amt := v_no_of_days * NVL (a.base_amt, 0);
                                                                  --issa@fpac
               END IF;

               v_prem_amt :=
                  NVL (a.prem_amt,
                       ROUND (  (  ((NVL (a.prem_rt, 0)) / 100)
                                 * NVL (v_tsi_amt, 0)
                                 * NVL (v_no_of_days_comp /*v_days*/, 0)
                                )
                              / v_year,
                              2
                             )
                      );                                           --issa@fpac
               v_prem_rt :=
                  ROUND (  (  v_prem_amt
                            / (  v_tsi_amt
                               * NVL (v_no_of_days_comp /*v_days*/, 0)
                               / v_year
                              )
                           )
                         * 100,
                         9
                        );                                         --issa@fpac
               v_ann_prem_amt :=
                  NVL (ROUND (((a.prem_rt) / 100) * (v_tsi_amt), 2),
                       ROUND ((NVL (v_tsi_amt, 0) * (v_prem_rt / 100)), 2)
                      );                                 --issa@fpac09.19.2006

               --issa--v_ann_prem_amt     := nvl(ROUND(((nvl(a.prem_rt,0))/100) * nvl(v_tsi_amt,0),2),round((nvl(v_tsi_amt,0)*v_prem_rt),2)); --issa@fpac
               --issa--v_tsi_amt       := nvl(v_no_of_days,0) * nvl(a.base_amt,0);
               --issa--v_prem_amt      := ROUND((((nvl(a.prem_rt,0))/100) * nvl(v_tsi_amt,0) * nvl(v_no_of_days,0))/v_year,2);
               --issa--v_ann_prem_amt     := ROUND(((nvl(a.prem_rt,0))/100) * nvl(v_tsi_amt,0),2);
               INSERT INTO gipi_witmperl_grouped
                           (par_id, item_no, grouped_item_no,
                            line_cd, peril_cd, rec_flag, no_of_days,
                            prem_rt,
                            tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt,
                            aggregate_sw, base_amt
                           )
                    VALUES (p_par_id, p_item_no, p_grouped_item_no,
                            p_line_cd, a.peril_cd, 'C', v_no_of_days,
                            NVL (a.prem_rt, v_prem_rt) /*--issa--a.prem_rt*/,
                            v_tsi_amt, v_prem_amt, v_tsi_amt, v_ann_prem_amt,
                            a.aggregate_sw, a.base_amt
                           );

               SELECT peril_type
                 INTO v_type
                 FROM giis_peril
                WHERE peril_cd = a.peril_cd AND line_cd = p_line_cd;

               IF v_type = 'B'
               THEN
                  v_ann_tsi_amt := ROUND ((v_ann_tsi_amt + v_tsi_amt), 2);
               END IF;

               v_prem_amt2 := ROUND ((v_prem_amt2 + v_prem_amt), 2);
               v_ann_prem_amt2 :=
                                ROUND ((v_ann_prem_amt2 + v_ann_prem_amt), 2);

---------------------------------------------------------------
--A.R.C. 06.12.2007
--to populate gipi_wpolwc
               FOR a1 IN (SELECT b.line_cd, b.main_wc_cd
                            FROM giis_peril_clauses b
                           WHERE b.line_cd = p_line_cd
                             AND b.peril_cd = a.peril_cd
                             AND NOT EXISTS (
                                    SELECT '1'
                                      FROM gipi_wpolwc c
                                     WHERE c.par_id = p_par_id
                                       AND c.line_cd = b.line_cd
                                       AND c.wc_cd = b.main_wc_cd))
               LOOP
                  FOR b IN (SELECT line_cd, main_wc_cd, print_sw, wc_title
                              FROM giis_warrcla
                             WHERE line_cd = a1.line_cd
                               AND main_wc_cd = a1.main_wc_cd)
                  LOOP
                     INSERT INTO gipi_wpolwc
                                 (par_id, line_cd, wc_cd, swc_seq_no,
                                  print_seq_no, wc_title, rec_flag,
                                  print_sw, change_tag
                                 )
                          VALUES (p_par_id, b.line_cd, b.main_wc_cd, 0,
                                  1, b.wc_title, 'A',
                                  b.print_sw, 'N'
                                 );
                  END LOOP;
               END LOOP;
            END LOOP;
         ELSE
            FOR a IN (SELECT   peril_cd, base_amt, prem_rt, ann_tsi_amt,
                               no_of_days, tsi_amt, ann_prem_amt, prem_amt,
                               aggregate_sw
                          FROM gipi_witmperl_grouped
                         WHERE par_id = p_par_id
                           AND item_no = p_item_no
                           AND grouped_item_no = p_orig_grp_item_no
                      ORDER BY grouped_item_no)
            LOOP
               v_no_of_days2 := NVL (a.no_of_days, v_no_of_days);

               INSERT INTO gipi_witmperl_grouped
                           (par_id, item_no, grouped_item_no,
                            line_cd, peril_cd, rec_flag, no_of_days,
                            prem_rt,
                            tsi_amt, prem_amt, ann_tsi_amt,
                            ann_prem_amt, aggregate_sw, base_amt
                           )
                    VALUES (p_par_id, p_item_no, p_grouped_item_no,
                            p_line_cd, a.peril_cd, 'C', v_no_of_days2,
                            NVL (a.prem_rt, v_prem_rt) /*--issa--a.prem_rt*/,
                            a.tsi_amt, a.prem_amt, a.ann_tsi_amt,
                            a.ann_prem_amt, a.aggregate_sw, a.base_amt
                           );

               SELECT peril_type
                 INTO v_type
                 FROM giis_peril
                WHERE peril_cd = a.peril_cd AND line_cd = p_line_cd;

               IF v_type = 'B'
               THEN
                  v_ann_tsi_amt := ROUND ((v_ann_tsi_amt + a.tsi_amt), 2);
               END IF;

               v_prem_amt2 := ROUND ((v_prem_amt2 + a.prem_amt), 2);
               v_ann_prem_amt2 :=
                                ROUND ((v_ann_prem_amt2 + a.ann_prem_amt), 2);

---------------------------------------------------------------
--A.R.C. 06.12.2007
--to populate gipi_wpolwc
               FOR a1 IN (SELECT b.line_cd, b.main_wc_cd
                            FROM giis_peril_clauses b
                           WHERE b.line_cd = p_line_cd
                             AND b.peril_cd = a.peril_cd
                             AND NOT EXISTS (
                                    SELECT '1'
                                      FROM gipi_wpolwc c
                                     WHERE c.par_id = p_par_id
                                       AND c.line_cd = b.line_cd
                                       AND c.wc_cd = b.main_wc_cd))
               LOOP
                  FOR b IN (SELECT line_cd, main_wc_cd, print_sw, wc_title
                              FROM giis_warrcla
                             WHERE line_cd = a1.line_cd
                               AND main_wc_cd = a1.main_wc_cd)
                  LOOP
                     INSERT INTO gipi_wpolwc
                                 (par_id, line_cd, wc_cd, swc_seq_no,
                                  print_seq_no, wc_title, rec_flag,
                                  print_sw, change_tag
                                 )
                          VALUES (p_par_id, b.line_cd, b.main_wc_cd, 0,
                                  1, b.wc_title, 'A',
                                  b.print_sw, 'N'
                                 );
                  END LOOP;
               END LOOP;
---------------------------------------------------------------
            END LOOP;
         END IF;

         UPDATE gipi_wgrouped_items
            SET ann_tsi_amt = v_ann_tsi_amt,
                tsi_amt = v_ann_tsi_amt,
                ann_prem_amt = v_ann_prem_amt2,
                prem_amt = v_prem_amt2,
                amount_covered = v_ann_tsi_amt,
                pack_ben_cd = p_pack_ben_cd
          WHERE par_id = p_par_id
            AND item_no = p_item_no
            AND grouped_item_no = p_grouped_item_no;
      END IF;
   END populate_benefits_tg;
   
   FUNCTION get_wgrouped_items_listing(
        p_par_id                GIPI_WGROUPED_ITEMS.par_id%TYPE,
        p_item_no               GIPI_WGROUPED_ITEMS.item_no%TYPE,
        p_grouped_item_no       GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE,
        p_grouped_item_title    GIPI_WGROUPED_ITEMS.grouped_item_title%TYPE,
        p_principal_cd          GIPI_WGROUPED_ITEMS.principal_cd%TYPE,
        p_package_cd            GIIS_PACKAGE_BENEFIT.package_cd%TYPE,
        p_payt_terms            GIPI_WGROUPED_ITEMS.payt_terms%TYPE,
        p_from_date             VARCHAR2,
        p_to_date               VARCHAR2
    )
      RETURN gipi_wgrouped_items_tab2 PIPELINED IS
        v_grp           gipi_wgrouped_items_type2;
        v_line_cd       GIPI_PARLIST.line_cd%TYPE;
        v_iss_cd        GIPI_PARLIST.iss_cd%TYPE;
        v_subline_cd    GIPI_WPOLBAS.subline_cd%TYPE;
        v_issue_yy      GIPI_WPOLBAS.issue_yy%TYPE;
        v_pol_seq_no    GIPI_WPOLBAS.pol_seq_no%TYPE;
        v_renew_no      GIPI_WPOLBAS.renew_no%TYPE;
    BEGIN
        BEGIN
            SELECT a.line_cd, a.iss_cd,
                   b.subline_cd, b.issue_yy, b.pol_seq_no, b.renew_no
              INTO v_line_cd, v_iss_cd,
                   v_subline_cd, v_issue_yy, v_pol_seq_no, v_renew_no
              FROM GIPI_PARLIST a,
                   GIPI_WPOLBAS b
             WHERE a.par_id = b.par_id
               AND a.par_id = p_par_id;
        END;
    
        FOR i IN(SELECT *
                   FROM GIPI_WGROUPED_ITEMS
                  WHERE par_id = p_par_id
                    AND item_no = p_item_no
                    AND grouped_item_no = NVL(p_grouped_item_no, grouped_item_no)
                    AND UPPER(grouped_item_title) LIKE UPPER(NVL(p_grouped_item_title, grouped_item_title))
                    AND NVL(principal_cd, 0) = DECODE(p_principal_cd, NULL, NVL(principal_cd, 0), p_principal_cd)
                    AND UPPER(NVL(payt_terms, '%')) LIKE UPPER(DECODE(p_payt_terms, NULL, NVL(payt_terms, '%'), p_payt_terms))
                    AND TRUNC(NVL(from_date, SYSDATE)) = TRUNC(DECODE(p_from_date, NULL, NVL(from_date, SYSDATE), TO_DATE(p_from_date, 'MM-DD-YYYY')))
                    AND TRUNC(NVL(to_date, SYSDATE)) = TRUNC(DECODE(p_to_date, NULL, NVL(to_date, SYSDATE), TO_DATE(p_to_date, 'MM-DD-YYYY')))
                  ORDER BY item_no, grouped_item_no)
        LOOP        
            v_grp.par_id                 := i.par_id;
            v_grp.item_no                 := i.item_no;
            v_grp.grouped_item_no         := i.grouped_item_no;
            v_grp.include_tag             := i.include_tag;
            v_grp.grouped_item_title     := i.grouped_item_title;
            v_grp.sex                     := i.sex;
            v_grp.position_cd             := i.position_cd;
            v_grp.civil_status         := i.civil_status;
            v_grp.date_of_birth         := i.date_of_birth;
            v_grp.age                     := i.age;
            v_grp.salary                 := i.salary;
            v_grp.salary_grade         := i.salary_grade;
            v_grp.amount_covered         := i.amount_covered;
            v_grp.remarks                 := ESCAPE_VALUE_CLOB(i.remarks);
            v_grp.line_cd                 := i.line_cd;
            v_grp.subline_cd             := i.subline_cd;
            v_grp.delete_sw             := NVL(i.delete_sw, 'N');
            v_grp.group_cd             := i.group_cd;
            v_grp.from_date             := i.from_date;
            v_grp.TO_DATE                 := i.TO_DATE;
            v_grp.payt_terms             := i.payt_terms;
            v_grp.pack_ben_cd             := i.pack_ben_cd;
            v_grp.ann_tsi_amt             := i.ann_tsi_amt;
            v_grp.ann_prem_amt         := i.ann_prem_amt;
            v_grp.control_cd             := i.control_cd;
            v_grp.control_type_cd         := i.control_type_cd;
            v_grp.tsi_amt                 := i.tsi_amt;
            v_grp.prem_amt             := i.prem_amt;
            v_grp.principal_cd         := i.principal_cd;
            v_grp.civil_status_desc := CG_REF_CODES_PKG.get_rv_meaning('CIVIL STATUS', i.civil_status);
            
            BEGIN
                SELECT package_cd
                  INTO v_grp.package_cd
                  FROM GIIS_PACKAGE_BENEFIT
                 WHERE pack_ben_cd = i.pack_ben_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_grp.package_cd := NULL;
            END;
            
            BEGIN
                SELECT position
                  INTO v_grp.position_desc
                  FROM GIIS_POSITION
                 WHERE position_cd = i.position_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_grp.position_desc := NULL;
            END;
            
            BEGIN
                SELECT control_type_desc
                  INTO v_grp.control_type_desc
                  FROM GIIS_CONTROL_TYPE
                 WHERE control_type_cd = i.control_type_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_grp.control_type_desc := NULL;
            END;
            
            BEGIN
                SELECT payt_terms_desc
                  INTO v_grp.payt_terms_desc
                  FROM GIIS_PAYTERM
                 WHERE payt_terms = i.payt_terms;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_grp.payt_terms_desc := NULL;
            END;
            
            BEGIN
                SELECT group_desc
                  INTO v_grp.group_desc
                  FROM GIIS_GROUP
                 WHERE group_cd = i.group_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_grp.group_desc := NULL;
            END;
            
            PIPE ROW(v_grp);
        END LOOP;
        RETURN;
    END;
    
    FUNCTION get_wgrouped_item(
        p_par_id            GIPI_WGROUPED_ITEMS.par_id%TYPE,
        p_item_no           GIPI_WGROUPED_ITEMS.item_no%TYPE,
        p_grouped_item_no   GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE,
        p_line_cd           GIPI_WPOLBAS.line_cd%TYPE,
        p_iss_cd            GIPI_WPOLBAS.iss_cd%TYPE,
        p_subline_cd        GIPI_WPOLBAS.subline_cd%TYPE,
        p_issue_yy          GIPI_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no        GIPI_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no          GIPI_WPOLBAS.renew_no%TYPE,
        p_amount_covered     GIPI_WGROUPED_ITEMS.amount_covered%TYPE,
        p_group_cd          GIPI_WGROUPED_ITEMS.group_cd%TYPE
    )
      RETURN gipi_wgrouped_items_tab2 PIPELINED IS
        v_group             gipi_wgrouped_items_type2;
    BEGIN
        FOR pol IN(SELECT policy_id
                     FROM GIPI_POLBASIC
                    WHERE line_cd = p_line_cd 
	                  AND iss_cd = p_iss_cd
                      AND subline_cd = p_subline_cd 
                      AND issue_yy = p_issue_yy
                      AND pol_seq_no = p_pol_seq_no  
                      AND renew_no = p_renew_no
                      AND pol_flag IN ('1','2','3','X')
                    ORDER BY endt_seq_no DESC)
                    --ORDER BY eff_date)
        LOOP
            FOR a IN(SELECT grouped_item_no, grouped_item_title, sex,
                            civil_status, date_of_birth, age, salary, salary_grade,
                            amount_coverage, include_tag, position_cd, remarks,
                            group_cd, pack_ben_cd, from_date, to_date,
                            control_cd, control_type_cd, principal_cd,
                            payt_terms
                       FROM GIPI_GROUPED_ITEMS
	                  WHERE grouped_item_no = p_grouped_item_no
                        AND item_no = p_item_no 
                        --AND NVL(delete_sw,'N')!= 'Y' 
                        AND policy_id = pol.policy_id)
            LOOP
                v_group.grouped_item_no := a.grouped_item_no;
                v_group.grouped_item_title := a.grouped_item_title;
                v_group.pack_ben_cd := a.pack_ben_cd;
                v_group.from_date := a.from_date;
                v_group.to_date := a.to_date;
                v_group.control_type_cd := a.control_type_cd;
                v_group.control_cd := a.control_cd;
                v_group.sex := a.sex;
                v_group.position_cd := a.position_cd;
                v_group.civil_status := a.civil_status;
                v_group.age := a.age;
                v_group.salary := a.salary;
                v_group.salary_grade := a.salary_grade;
                --v_group.amount_covered := NVL(a.amount_coverage, 0) + NVL(p_amount_covered, 0);
                v_group.amount_covered := NVL(a.amount_coverage, 0);
                v_group.include_tag := a.include_tag;
                v_group.remarks := a.remarks;
                v_group.principal_cd := a.principal_cd;
                v_group.date_of_birth := a.date_of_birth;
                v_group.payt_terms := a.payt_terms;
                
                IF p_group_cd IS NULL THEN
                    v_group.group_cd := a.group_cd;
                ELSE
                    v_group.group_cd := p_group_cd;
                END IF;
                
                FOR c IN(SELECT control_type_desc
                           FROM GIIS_CONTROL_TYPE
                          WHERE control_type_cd = a.control_type_cd)
                LOOP
                    v_group.control_type_desc := c.control_type_desc;
                END LOOP;
                
                FOR g IN (SELECT group_desc 
                            FROM GIIS_GROUP
                           WHERE group_cd = NVL(p_group_cd, a.group_cd))
                LOOP
                    v_group.group_desc := g.group_desc;
                END LOOP;	
                
                FOR s IN(SELECT rv_meaning
                           FROM CG_REF_CODES
                          WHERE rv_domain = 'CIVIL STATUS'
                            AND rv_low_value = a.civil_status)
                LOOP
                    v_group.civil_status_desc := s.rv_meaning;
                END LOOP;
                
                FOR p IN(SELECT position
                           FROM GIIS_POSITION
                          WHERE position_cd = a.position_cd)
                LOOP
                    v_group.position_desc := p.position;
                END LOOP;
                
                FOR b IN(SELECT package_cd
                           FROM GIIS_PACKAGE_BENEFIT
                          WHERE pack_ben_cd = a.pack_ben_cd)
                LOOP
                    v_group.package_cd := b.package_cd;
                END LOOP;
                
                FOR p IN(SELECT payt_terms_desc
                           FROM GIIS_PAYTERM
                          WHERE payt_terms = a.payt_terms)
                LOOP
                    v_group.payt_terms_desc := p.payt_terms_desc;
                END LOOP;
				PIPE ROW(v_group);
				RETURN;
            END LOOP;
        END LOOP;
    END;
    
    FUNCTION neg_del_item(
        p_par_id            GIPI_WGROUPED_ITEMS.par_id%TYPE,
        p_item_no           GIPI_WGROUPED_ITEMS.item_no%TYPE
    )
      RETURN VARCHAR2 IS
        v_prorate_flag      GIPI_WPOLBAS.prorate_flag%TYPE;
        v_endt_expiry_date  GIPI_WPOLBAS.endt_expiry_date%TYPE;
        v_eff_date          GIPI_WPOLBAS.eff_date%TYPE;
    BEGIN
        BEGIN
            SELECT prorate_flag, endt_expiry_date, eff_date
              INTO v_prorate_flag, v_endt_expiry_date, v_eff_date
              FROM GIPI_WPOLBAS
             WHERE par_id = p_par_id;
        END;
        
        IF v_prorate_flag = '1' AND TRUNC(v_endt_expiry_date) <= TRUNC(v_eff_date) THEN
            RETURN '1';
        END IF;
        
        FOR chk IN (SELECT '1'
	                  FROM GIPI_WITMPERL
	                 WHERE par_id = p_par_id
	                   AND item_no = p_item_no)
        LOOP
            RETURN '2';
        END LOOP;
    END;
    
    FUNCTION set_grouped_items_vars(
        p_par_id        GIPI_WGROUPED_ITEMS.par_id%TYPE,
        p_item_no       GIPI_WGROUPED_ITEMS.item_no%TYPE
    )
      RETURN grouped_items_vars_tab PIPELINED IS
        vars            grouped_items_vars_type;
        exist           VARCHAR2(1);
    BEGIN
        FOR i IN(SELECT line_cd, iss_cd, subline_cd, issue_yy, pol_seq_no, renew_no,
                        prorate_flag, endt_expiry_date, eff_date, pack_pol_flag, pol_flag,
                        comp_sw, incept_date, expiry_date, prov_prem_pct, prov_prem_tag
                   FROM GIPI_WPOLBAS
                  WHERE par_id = p_par_id)
        LOOP
            vars.par_id := p_par_id;
            vars.item_no := p_item_no;
            vars.line_cd := i.line_cd;
            vars.iss_cd := i.iss_cd;
            vars.subline_cd := i.subline_cd;
            vars.issue_yy := i.issue_yy;
            vars.pol_seq_no := i.pol_seq_no;
            vars.renew_no := i.renew_no;
            vars.prorate_flag := i.prorate_flag;
            vars.endt_expiry_date := TRUNC(i.endt_expiry_date);
            vars.eff_date := TRUNC(i.eff_date);
            vars.pack_pol_flag := NVL(i.pack_pol_flag, 'N');
            vars.comp_sw := NVL(i.comp_sw, 'N');
            vars.incept_date := TRUNC(i.incept_date);
            vars.expiry_date := TRUNC(i.expiry_date);
            vars.prov_prem_pct := i.prov_prem_pct;
            vars.prov_prem_tag := i.prov_prem_tag;
            
            IF i.pol_flag = 4 THEN
                vars.pol_flag_sw := 'Y';
            ELSE
                vars.pol_flag_sw := 'N';
            END IF;
            
            FOR a IN (SELECT 1
	 					FROM GIPI_ITMPERIL b 
	 				   WHERE EXISTS(SELECT '1'
                                      FROM GIPI_POLBASIC a
                                     WHERE a.line_cd = i.line_cd
                                       AND a.iss_cd = i.iss_cd
                                       AND a.subline_cd = i.subline_cd
                                       AND a.issue_yy = i.issue_yy
                                       AND a.pol_seq_no = i.pol_seq_no
                                       AND a.renew_no = i.renew_no
                                       AND a.pol_flag IN ( '1','2','3','X')
                                       AND TRUNC(a.eff_date) <= TRUNC(i.eff_date)
                                       AND NVL(a.endt_expiry_date, a.expiry_date) >= i.eff_date
                                       AND a.policy_id = b.policy_id)
                         AND b.item_no = p_item_no)
            LOOP
	 	        exist := 'Y';
	 	        EXIT;
	        END LOOP;
            
	        FOR b IN(SELECT 2 
	 				   FROM GIPI_ITMPERIL_GROUPED b
	 			      WHERE EXISTS(SELECT '1'
                                     FROM GIPI_POLBASIC a
                                    WHERE a.line_cd = i.line_cd
                                      AND a.iss_cd = i.iss_cd
                                      AND a.subline_cd = i.subline_cd
                                      AND a.issue_yy = i.issue_yy
                                      AND a.pol_seq_no = i.pol_seq_no
                                      AND a.renew_no = i.renew_no
                                      AND a.pol_flag IN ('1','2','3','X')
                                      AND TRUNC(a.eff_date) <= TRUNC(i.eff_date)
                                      AND NVL(a.endt_expiry_date, a.expiry_date) >= i.eff_date
                                      AND a.policy_id = b.policy_id)
                        AND b.item_no = p_item_no)
            LOOP
	 	        exist := 'N';
	 	        EXIT;
	        END LOOP;
            vars.itmperil_exist := NVL(exist, 'N');
            
            FOR c IN(SELECT no_of_persons
                       FROM GIPI_WACCIDENT_ITEM
                      WHERE par_id = p_par_id
                        AND item_no = p_item_no)
            LOOP
                vars.no_of_persons := c.no_of_persons;
                EXIT;
            END LOOP;
            
            FOR w IN(SELECT pack_line_cd, changed_tag, short_rt_percent, rec_flag, pack_subline_cd
                       FROM GIPI_WITEM
                      WHERE par_id = p_par_id
                        AND item_no = p_item_no)
            LOOP
                vars.pack_line_cd := w.pack_line_cd;
                vars.pack_subline_cd := w.pack_subline_cd;
                vars.changed_tag := NVL(w.changed_tag, 'N');
                vars.short_rt_percent := w.short_rt_percent;
                vars.rec_flag := w.rec_flag;
                EXIT;
            END LOOP;
            
            FOR e IN(SELECT endt_tax
                       FROM GIPI_WENDTTEXT
                      WHERE par_id = p_par_id)
            LOOP
                vars.endt_tax_sw := NVL(e.endt_tax, 'N');
            END LOOP;
            
            FOR p IN(SELECT par_status
                       FROM GIPI_PARLIST
                      WHERE par_id = p_par_id)
            LOOP
                vars.par_status := p.par_status;
            END LOOP;
            
            PIPE ROW(vars);
        END LOOP;
        RETURN;
    END;
    
    FUNCTION validate_retrieve_grp_items(
        p_line_cd           GIPI_WPOLBAS.line_cd%TYPE,
        p_subline_cd        GIPI_WPOLBAS.subline_cd%TYPE,
        p_iss_cd            GIPI_WPOLBAS.iss_cd%TYPE,
        p_issue_yy          GIPI_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no        GIPI_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no          GIPI_WPOLBAS.renew_no%TYPE,
        p_eff_date          VARCHAR2,
        p_item_no           GIPI_WGROUPED_ITEMS.item_no%TYPE
    )
      RETURN VARCHAR2 IS
        v_policy_id     GIPI_POLBASIC.policy_id%TYPE;
        v_from_date     GIPI_GROUPED_ITEMS.from_date%TYPE;
        v_to_date       GIPI_GROUPED_ITEMS.to_date%TYPE;
    BEGIN
        FOR grouped IN(SELECT DISTINCT a.policy_id policy_id, a.endt_seq_no,
                                       b.from_date from_date, b.to_date to_date
						 FROM GIPI_POLBASIC a,
                              GIPI_GROUPED_ITEMS b
		                WHERE a.line_cd = p_line_cd
                          AND a.subline_cd = p_subline_cd
                          AND a.iss_cd = p_iss_cd
                          AND a.issue_yy = p_issue_yy
                          AND a.pol_seq_no = p_pol_seq_no
                          AND a.renew_no = p_renew_no
                          AND a.pol_flag IN ('1','2','3','X')			
                          AND a.policy_id = b.policy_id
                          AND b.item_no = p_item_no					 
                          AND TO_DATE(p_eff_date, 'mm-dd-yyyy') BETWEEN TRUNC(NVL(from_date, eff_date)) AND TRUNC(NVL(to_date, NVL(endt_expiry_date, expiry_date)))
                        ORDER BY endt_seq_no DESC)
        LOOP
		    v_policy_id := grouped.policy_id;
		    v_from_date := grouped.from_date;
		    v_to_date   := grouped.to_date;
		    EXIT;
		END LOOP;
        
        IF NVL(v_policy_id, 0) <> 0 AND v_from_date IS NULL AND v_to_date IS NULL THEN
			BEGIN
				SELECT DISTINCT a.policy_id policy_id
                  INTO v_policy_id
                  FROM GIPI_POLBASIC a,
                       GIPI_ITEM b
                 WHERE a.policy_id = v_policy_id
                   AND a.pol_flag IN ('1','2','3','X')			
                   AND a.policy_id = b.policy_id
                   AND TO_DATE(p_eff_date, 'mm-dd-yyyy') BETWEEN TRUNC(NVL(from_date, eff_date)) AND NVL(to_date, NVL(endt_expiry_date, expiry_date));
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RETURN 'No Grouped Items to retrieve. Check Endt effectivity date on Item and Grouped Item level.';									 			
			END;
		ELSIF NVL(v_policy_id, 0) = 0 THEN
            RETURN 'No Grouped Items to retrieve. Grouped items do not exist in previous endorsements.';											 			
		END IF;
        
        RETURN 'SUCCESS';
    END;
    
    FUNCTION pre_negate_delete(
        p_par_id            GIPI_WGROUPED_ITEMS.par_id%TYPE,
        p_item_no           GIPI_WGROUPED_ITEMS.item_no%TYPE,
        p_grouped_item_no   GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE
    )
      RETURN VARCHAR2 IS
    BEGIN
        FOR chk IN(SELECT '1'
	                 FROM GIPI_WITMPERL_GROUPED
	                WHERE par_id = p_par_id
	                  AND item_no = p_item_no
	                  AND grouped_item_no = p_grouped_item_no)
        LOOP
            RETURN 'EXIST';
        END LOOP;
        RETURN 'SUCCESS';
    END;
    
    FUNCTION check_back_endt(
        p_line_cd           GIPI_WPOLBAS.line_cd%TYPE,
        p_iss_cd            GIPI_WPOLBAS.iss_cd%TYPE,
        p_subline_cd        GIPI_WPOLBAS.subline_cd%TYPE,
        p_issue_yy          GIPI_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no        GIPI_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no          GIPI_WPOLBAS.renew_no%TYPE,
        p_eff_date          VARCHAR2,
        p_item_no           GIPI_WGROUPED_ITEMS.item_no%TYPE,
        p_grouped_item_no   GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE
    )
      RETURN VARCHAR2 IS
    BEGIN
        FOR a2 IN(SELECT policy_id, a.endt_iss_cd || '-' || TO_CHAR(a.endt_yy,'09') || TO_CHAR(a.endt_seq_no,'099999') endt_no
                    FROM GIPI_POLBASIC a
                   WHERE a.line_cd = p_line_cd
                     AND a.iss_cd = p_iss_cd
                     AND a.subline_cd = p_subline_cd
                     AND a.issue_yy = p_issue_yy
                     AND a.pol_seq_no = p_pol_seq_no
                     AND a.renew_no = p_renew_no
                     AND a.pol_flag IN ( '1','2','3','X')
                     AND a.eff_date > TO_DATE(p_eff_date, 'mm-dd-yyyy')
                     AND NVL(a.endt_expiry_date, a.expiry_date) >= TO_DATE(p_eff_date, 'mm-dd-yyyy')
                   ORDER BY eff_date)
        LOOP     
            FOR a3 IN(SELECT line_cd, peril_cd
                        FROM GIPI_ITMPERIL_GROUPED b
                       WHERE policy_id = a2.policy_id
                         AND b.item_no = p_item_no
                         AND b.grouped_item_no = p_grouped_item_no
                         AND (b.prem_amt <> 0 OR b.tsi_amt <> 0))
            LOOP
                FOR b IN(SELECT peril_name
     	                   FROM GIIS_PERIL
     	                  WHERE line_cd = a3.line_cd
     	                    AND peril_cd = a3.peril_cd)
                LOOP
                    RETURN LTRIM(RTRIM(b.peril_name)) || ' in Endt No. ' || a2.endt_no;
     	        END LOOP;
            END LOOP;
        END LOOP;
        RETURN 'SUCCESS';
    END;
    
    PROCEDURE negate_delete(
        p_line_cd           GIPI_WPOLBAS.line_cd%TYPE,
        p_iss_cd            GIPI_WPOLBAS.iss_cd%TYPE,
        p_subline_cd        GIPI_WPOLBAS.subline_cd%TYPE,
        p_issue_yy          GIPI_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no        GIPI_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no          GIPI_WPOLBAS.renew_no%TYPE,
        p_par_id            GIPI_WGROUPED_ITEMS.par_id%TYPE,
        p_item_no           GIPI_WGROUPED_ITEMS.item_no%TYPE,
        p_grouped_item_no   GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE,
        p_to_date           VARCHAR2,
        p_from_date         VARCHAR2
    )
    IS
        v_p_from_date       GIPI_WGROUPED_ITEMS.from_date%TYPE;
        v_p_to_date         GIPI_WGROUPED_ITEMS.to_date%TYPE;
    
        v_eff_date          GIPI_WPOLBAS.eff_date%TYPE;
        v_endt_expiry_date  GIPI_WPOLBAS.endt_expiry_date%TYPE;
        v_var_comp_sw       GIPI_WPOLBAS.comp_sw%TYPE;
        v_var_prorate_flag  GIPI_WPOLBAS.prorate_flag%TYPE;
        v_short_rt_percent  GIPI_WPOLBAS.short_rt_percent%TYPE;
        v_changed_tag       GIPI_WITEM.changed_tag%TYPE;
        v_prorate_flag      GIPI_WITEM.prorate_flag%TYPE;
        v_comp_sw           GIPI_WITEM.comp_sw%TYPE;
        v_to_date           GIPI_WITEM.to_date%TYPE;
        v_from_date         GIPI_WITEM.from_date%TYPE;
        v_prorate           NUMBER := 0;
        v_prem_amt          NUMBER := 0;
        
        v_grp_prem_amt      GIPI_WGROUPED_ITEMS.prem_amt%TYPE;
        v_grp_tsi_amt       GIPI_WGROUPED_ITEMS.tsi_amt%TYPE;
        v_grp_ann_prem_amt  GIPI_WGROUPED_ITEMS.ann_prem_amt%TYPE;
        v_grp_ann_tsi_amt   GIPI_WGROUPED_ITEMS.ann_tsi_amt%TYPE;
    BEGIN
        BEGIN
            SELECT TO_DATE(p_from_date, 'MM-DD-YYYY'), TO_DATE(p_to_date, 'MM-DD-YYYY')
              INTO v_p_from_date, v_p_to_date
              FROM DUAL;
        END;
    
        BEGIN
            SELECT eff_date, endt_expiry_date, NVL(comp_sw, 'N'), prorate_flag
              INTO v_eff_date, v_endt_expiry_date, v_var_comp_sw, v_var_prorate_flag
              FROM GIPI_WPOLBAS
             WHERE par_id = p_par_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_eff_date := NULL;
        END;
        
        BEGIN
            SELECT changed_tag, prorate_flag, comp_sw, to_date, from_date
              INTO v_changed_tag, v_prorate_flag, v_comp_sw, v_to_date, v_from_date
              FROM GIPI_WITEM
             WHERE par_id = p_par_id
               AND item_no = p_item_no;
        END;
    
        DELETE
          FROM GIPI_WITMPERL_GROUPED
	     WHERE par_id = p_par_id
	       AND item_no = p_item_no
	       AND grouped_item_no = p_grouped_item_no;
       
        FOR a1 IN(SELECT b.line_cd, b.peril_cd, SUM(b.tsi_amt) tsi_amt,
                         SUM(b.tsi_amt * NVL(b.prem_rt, 0)/100) prem_amt
                    FROM GIPI_ITMPERIL_GROUPED b
                   WHERE EXISTS(SELECT '1'
                                  FROM GIPI_POLBASIC a
                                 WHERE a.line_cd = p_line_cd
                                   AND a.iss_cd = p_iss_cd
                                   AND a.subline_cd = p_subline_cd
                                   AND a.issue_yy = p_issue_yy
                                   AND a.pol_seq_no = p_pol_seq_no
                                   AND a.renew_no = p_renew_no
                                   AND a.pol_flag IN ( '1','2','3','X')
                                   AND TRUNC(a.eff_date) <= TRUNC(v_eff_date)
                                   AND TRUNC(NVL(a.endt_expiry_date, a.expiry_date)) >= TRUNC(v_eff_date)
                                   AND a.policy_id = b.policy_id)
                     AND b.item_no = p_item_no
                     AND b.grouped_item_no = p_grouped_item_no
                   GROUP BY b.line_cd, b.peril_cd)
        LOOP
            IF v_changed_tag = 'Y' THEN  		
	  	        IF v_prorate_flag = '1' THEN
                    IF v_comp_sw = 'Y' THEN
		                v_prorate := ((TRUNC(NVL(v_p_to_date,NVL(v_to_date, v_endt_expiry_date))) - TRUNC(NVL(v_p_from_date,NVL(v_from_date,v_eff_date) ))) + 1 )/                        
                                        check_duration(TRUNC(NVL(v_p_from_date,NVL(v_from_date, v_eff_date))), TRUNC(NVL(v_p_to_date,NVL(v_to_date,v_endt_expiry_date))));   
		            ELSIF v_var_comp_sw = 'M' THEN
                        v_prorate := ((TRUNC(NVL(v_p_to_date,NVL(v_to_date,v_endt_expiry_date))) - TRUNC(NVL(v_p_from_date,NVL(v_from_date,v_eff_date) ))) - 1 )/
		                                check_duration(TRUNC(NVL(v_p_from_date,NVL(v_from_date, v_eff_date))), TRUNC(NVL(v_p_to_date,NVL(v_to_date,v_endt_expiry_date))));
                    ELSE
		                v_prorate := ((TRUNC(NVL(v_p_to_date,NVL(v_to_date,v_endt_expiry_date))) - TRUNC(NVL(v_p_from_date,NVL(v_from_date,v_eff_date) ))) )/
		                                check_duration(TRUNC(NVL(v_p_from_date,NVL(v_from_date, v_eff_date))), TRUNC(NVL(v_p_to_date,NVL(v_to_date,v_endt_expiry_date))));
		            END IF;
		            v_prem_amt := a1.prem_amt * v_prorate;
                ELSIF v_var_prorate_flag = 2 THEN
                    v_prem_amt := a1.prem_amt;
		        ELSE
                    v_prem_amt := (NVL(a1.prem_amt,0) * NVL(v_short_rt_percent/100,1));
		        END IF;
	        ELSE
	  	        IF v_var_prorate_flag = '1' THEN
                    IF v_comp_sw = 'Y' THEN
		                v_prorate := ((TRUNC(NVL(v_p_to_date,NVL(v_to_date,v_endt_expiry_date))) - TRUNC(NVL(v_p_from_date,NVL(v_from_date,v_eff_date) ))) + 1 )/
                                        check_duration(TRUNC(NVL(v_p_from_date,NVL(v_from_date, v_eff_date))), TRUNC(NVL(v_p_to_date,NVL(v_to_date,v_endt_expiry_date))));
		            ELSIF v_var_comp_sw = 'M' THEN
                        v_prorate := ((TRUNC(NVL(v_p_to_date,NVL(v_to_date,v_endt_expiry_date))) - TRUNC(NVL(v_p_from_date,NVL(v_from_date,v_eff_date) ))) - 1 )/
                                        check_duration(TRUNC(NVL(v_p_from_date,NVL(v_from_date, v_eff_date))), TRUNC(NVL(v_p_to_date,NVL(v_to_date,v_endt_expiry_date))));                    	                       
		            ELSE
		                v_prorate := ((TRUNC(NVL(v_p_to_date,NVL(v_to_date,v_endt_expiry_date))) - TRUNC(NVL(v_p_from_date,NVL(v_from_date,v_eff_date) ))) )/
		                                check_duration(TRUNC(NVL(v_p_from_date,NVL(v_from_date, v_eff_date))), TRUNC(NVL(v_p_to_date,NVL(v_to_date,v_endt_expiry_date))));	                       
		            END IF;
		            v_prem_amt := a1.prem_amt * v_prorate;
		        ELSIF v_var_prorate_flag = 2 THEN
                    v_prem_amt := a1.prem_amt;
		        ELSE
                    v_prem_amt := (NVL(a1.prem_amt,0) * NVL(v_short_rt_percent/100,1));
		        END IF;
		    END IF;
            
  	        IF a1.tsi_amt <> 0 OR a1.prem_amt <> 0 THEN
                INSERT
                  INTO GIPI_WITMPERL_GROUPED
  	                   (par_id, item_no, grouped_item_no, line_cd, peril_cd,
                        prem_rt, tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt, rec_flag)
                VALUES (p_par_id, p_item_no, p_grouped_item_no, a1.line_cd, a1.peril_cd,
                        0, -(a1.tsi_amt), -(v_prem_amt), 0, 0, 'D');
            END IF;
        END LOOP;
    
        FOR a IN(SELECT SUM(DECODE(b.peril_type, 'B', a.tsi_amt, 0)) tsi,
                        SUM(a.prem_amt) prem 
                   FROM GIPI_WITMPERL_GROUPED a,
                        GIIS_PERIL b
                  WHERE a.par_id = p_par_id
                    AND a.item_no = p_item_no
                    AND a.grouped_item_no = p_grouped_item_no
                    AND a.peril_cd = b.peril_cd
                    AND a.line_cd = b.line_cd)
        LOOP
            v_grp_prem_amt := a.prem;              
            v_grp_tsi_amt := a.tsi;
            v_grp_ann_prem_amt := 0;
            v_grp_ann_tsi_amt := 0;
        END LOOP;
        
        UPDATE GIPI_WGROUPED_ITEMS
           SET prem_amt = NVL(v_grp_prem_amt, 0),
               tsi_amt = NVL(v_grp_tsi_amt, 0),
               ann_prem_amt = v_grp_ann_prem_amt,
               ann_tsi_amt = v_grp_ann_tsi_amt,
               delete_sw = 'Y',
			   amount_covered = 0
         WHERE par_id = p_par_id
           AND item_no = p_item_no
           AND grouped_item_no = p_grouped_item_no;
    END;
    
    FUNCTION retrieve_grouped_items2(
        p_par_id                GIPI_WGROUPED_ITEMS.par_id%TYPE,
        p_line_cd               GIPI_WPOLBAS.line_cd%TYPE,
        p_subline_cd            GIPI_WPOLBAS.subline_cd%TYPE,
        p_iss_cd                GIPI_WPOLBAS.iss_cd%TYPE,
        p_issue_yy              GIPI_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no            GIPI_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no              GIPI_WPOLBAS.renew_no%TYPE,
        p_item_no               GIPI_WGROUPED_ITEMS.item_no%TYPE,
        p_eff_date              VARCHAR2,
        p_grouped_item_no       GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE,
        p_grouped_item_title    GIPI_WGROUPED_ITEMS.grouped_item_title%TYPE
    )
      RETURN gipi_grouped_items_tab PIPELINED IS
        v_retrieved         gipi_grouped_items_type;
    BEGIN
        FOR i IN(SELECT *
                   FROM GIPI_GROUPED_ITEMS
                  WHERE policy_id||'-'||grouped_item_no IN (SELECT DISTINCT b.policy_id||'-'||b.grouped_item_no
                                                              FROM GIPI_POLBASIC a,
                                                                   GIPI_GROUPED_ITEMS b 
                                                             WHERE a.line_cd = p_line_cd
                                                               AND a.subline_cd = p_subline_cd
                                                               AND a.iss_cd = p_iss_cd
                                                               AND a.issue_yy = p_issue_yy
                                                               AND a.pol_seq_no = p_pol_seq_no
                                                               AND a.renew_no   = p_renew_no
                                                               AND a.pol_flag IN ('1','2','3','X')			
                                                               AND a.policy_id  = b.policy_id
                                                               AND b.item_no = p_item_no				 
                                                               AND TO_DATE(p_eff_date, 'mm-dd-yyyy') BETWEEN TRUNC(NVL(from_date,eff_date)) 
                                                               AND NVL(to_date,NVL(endt_expiry_date,expiry_date))
                                                               AND endt_seq_no = (SELECT MAX(endt_seq_no)
                                                                                    FROM GIPI_POLBASIC x,
                                                                                         GIPI_GROUPED_ITEMS y
                                                                                   WHERE x.line_cd = p_line_cd
                                                                                     AND x.subline_cd = p_subline_cd
                                                                                     AND x.iss_cd = p_iss_cd
                                                                                     AND x.issue_yy = p_issue_yy
                                                                                     AND x.pol_seq_no = p_pol_seq_no
                                                                                     AND x.renew_no = p_renew_no
                                                                                     AND x.pol_flag IN ('1','2','3','X')			
                                                                                     AND x.policy_id = y.policy_id
                                                                                     AND y.grouped_item_no = b.grouped_item_no
                                                                                     AND y.item_no = p_item_no		
                                                                                     AND TO_DATE(p_eff_date, 'mm-dd-yyyy') BETWEEN TRUNC(NVL(from_date,eff_date))
                                                                                     AND NVL(to_date,NVL(endt_expiry_date,expiry_date))))
                                                                                     AND item_no = p_item_no						 														  		             
                                                                                     AND NOT EXISTS (SELECT 1
                                                                                                       FROM GIPI_WGROUPED_ITEMS z
                                                                                                      WHERE z.par_id = p_par_id
                                                                                                        AND item_no = GIPI_GROUPED_ITEMS.item_no
                                                                                                        AND grouped_item_no = GIPI_GROUPED_ITEMS.grouped_item_No)
                    AND grouped_item_no = NVL(p_grouped_item_no, grouped_item_no)
                    AND UPPER(grouped_item_title) LIKE UPPER(NVL(p_grouped_item_title, grouped_item_title))
                  ORDER BY grouped_item_no)
        LOOP
            v_retrieved.policy_id := i.policy_id;
            v_retrieved.grouped_item_no := i.grouped_item_no;
            v_retrieved.grouped_item_title := i.grouped_item_title;
            v_retrieved.item_no := i.item_no;
            v_retrieved.control_cd := i.control_cd;
            v_retrieved.control_type_cd := i.control_type_cd;
            PIPE ROW(v_retrieved);
        END LOOP;
        RETURN;
    END;
    
    PROCEDURE insert_retrieved_grp_items(
        p_par_id                GIPI_WGROUPED_ITEMS.par_id%TYPE,
        p_line_cd               GIPI_POLBASIC.line_cd%TYPE,
        p_subline_cd            GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd                GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy              GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no            GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no              GIPI_POLBASIC.renew_no%TYPE,
        p_item_no               GIPI_GROUPED_ITEMS.item_no%TYPE,
        p_eff_date              VARCHAR2,
        p_grouped_item_no       GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE,
        p_grouped_item_title    GIPI_WGROUPED_ITEMS.grouped_item_title%TYPE,
        p_control_cd            GIPI_WGROUPED_ITEMS.control_cd%TYPE,
        p_control_type_cd       GIPI_WGROUPED_ITEMS.control_type_cd%TYPE
    )
    IS
        v_endt_seq_no           GIPI_POLBASIC.endt_seq_no%TYPE;
    BEGIN
        DELETE
          FROM GIPI_WGROUPED_ITEMS
         WHERE par_id = p_par_id
           AND item_no = p_item_no
           AND grouped_item_no = p_grouped_item_no;
					
		DELETE
          FROM GIPI_WITMPERL_GROUPED
		 WHERE par_id = p_par_id
	       AND item_no = p_item_no
	       AND grouped_item_no = p_grouped_item_no;
           
        DELETE
          FROM GIPI_WGRP_ITEMS_BENEFICIARY
         WHERE par_id = p_par_id
           AND item_no = p_item_no
           AND grouped_item_no = p_grouped_item_no;
           
        FOR c1 IN (SELECT MAX(endt_seq_no) endt_seq_no
	                 FROM GIPI_GROUPED_ITEMS y,
                          GIPI_POLBASIC x 
	                WHERE x.line_cd = p_line_cd
	                  AND x.subline_cd = p_subline_cd
	                  AND x.iss_cd = p_iss_cd
	                  AND x.issue_yy = p_issue_yy
	                  AND x.pol_seq_no = p_pol_seq_no
	                  AND x.renew_no = p_renew_no
	                  AND x.pol_flag IN ('1','2','3','X')
	                  AND y.policy_id = x.policy_id
	                  AND y.item_no = p_item_no
	                  AND y.grouped_item_no = p_grouped_item_no)
	                  --AND TO_DATE(p_eff_date, 'mm-dd-yyyy') BETWEEN TRUNC(NVL(from_date, eff_date))
	                  --AND NVL(to_date, NVL(endt_expiry_date, expiry_date)))
	    LOOP
		    v_endt_seq_no := c1.endt_seq_no;
	    END LOOP;
        
        FOR c2 IN (SELECT b.policy_id, b.grouped_item_no
                     FROM GIPI_GROUPED_ITEMS b,
                          GIPI_POLBASIC a 
                    WHERE a.line_cd = p_line_cd
                      AND a.subline_cd = p_subline_cd
                      AND a.iss_cd = p_iss_cd
                      AND a.issue_yy = p_issue_yy
                      AND a.pol_seq_no = p_pol_seq_no
                      AND a.renew_no = p_renew_no
                      AND a.pol_flag IN ('1','2','3','X')
                      AND b.policy_id = a.policy_id
                      AND b.grouped_item_no = p_grouped_item_no
                      AND b.item_no = p_item_no
                      --AND TO_DATE(p_eff_date, 'mm-dd-yyyy') BETWEEN TRUNC(NVL(from_date, eff_date))
                      --AND NVL(to_date, NVL(endt_expiry_date, expiry_date))
                      AND endt_seq_no = v_endt_seq_no)
	    LOOP
            INSERT
              INTO GIPI_WGROUPED_ITEMS(par_id, item_no, grouped_item_no, grouped_item_title, include_tag, 
                                       sex, position_cd, civil_status, date_of_birth, age, salary,
                                       salary_grade, amount_covered, remarks, line_cd, subline_cd, 
                                       delete_sw, group_cd, from_date, to_date, payt_terms, pack_ben_cd, 
                                       ann_tsi_amt, ann_prem_amt, control_cd, control_type_cd, principal_cd)
            SELECT p_par_id, item_no, grouped_item_no, grouped_item_title, include_tag, 
                   sex, position_cd, civil_status, date_of_birth, age, salary, 
                   salary_grade, amount_coverage, remarks, line_cd, subline_cd, 
                   delete_sw, group_cd, from_date, to_date, payt_terms, pack_ben_cd, 
                   ann_tsi_amt, ann_prem_amt, control_cd, control_type_cd, principal_cd
              FROM GIPI_GROUPED_ITEMS
             WHERE policy_id = c2.policy_id
               AND item_no = p_item_no
               AND grouped_item_no = p_grouped_item_no;
               
            INSERT
              INTO GIPI_WITMPERL_GROUPED(par_id, item_no, grouped_item_no, line_cd, peril_cd, rec_flag, prem_rt, ann_tsi_amt,
                                         ann_prem_amt, aggregate_sw, base_amt, ri_comm_rate, ri_comm_amt, no_of_days)
            SELECT p_par_id, item_no, grouped_item_no, line_cd, peril_cd, /*rec_flag*/ 'C', -- apollo cruz 09.23.2015 sr#19914 - value of rec_flag in endorsed perils must be 'C' (Changed)
                   prem_rt, ann_tsi_amt,
                   ann_prem_amt, aggregate_sw, base_amt, ri_comm_rate, ri_comm_amt, no_of_days
              FROM GIPI_ITMPERIL_GROUPED
             WHERE policy_id = c2.policy_id
               AND item_no = p_item_no
               AND grouped_item_no = p_grouped_item_no;
               
            INSERT
              INTO GIPI_WGRP_ITEMS_BENEFICIARY(par_id,item_no, grouped_item_no, beneficiary_no, beneficiary_name, 
				 							   beneficiary_addr, relation, date_of_birth, age, civil_status, sex)
            SELECT p_par_id,item_no, grouped_item_no, beneficiary_no, beneficiary_name, 
                   beneficiary_addr, relation, date_of_birth, age, civil_status, sex
              FROM GIPI_GRP_ITEMS_BENEFICIARY
             WHERE policy_id = c2.policy_id
               AND item_no = p_item_no
               AND grouped_item_no = p_grouped_item_no;
               
            FOR i IN (SELECT DISTINCT peril_cd
				 	    FROM GIPI_ITMPERIL_GROUPED
				 	   WHERE policy_id = c2.policy_id)
            LOOP
                FOR a1 IN (SELECT a.line_cd, a.main_wc_cd
				 	         FROM GIIS_PERIL_CLAUSES a
				 	        WHERE a.line_cd  = p_line_cd
				 	          AND a.peril_cd = i.peril_cd
				              AND NOT EXISTS (SELECT '1'
				 	                            FROM GIPI_WPOLWC b
				 	                           WHERE b.par_id = p_par_id
				 	                             AND b.line_cd = a.line_cd
                                                 AND b.wc_cd = a.main_wc_cd))                                    
                LOOP
                    FOR B IN (SELECT line_cd, main_wc_cd, print_sw, wc_title
				 	            FROM GIIS_WARRCLA
				 	           WHERE line_cd = a1.line_cd
				 	             AND main_wc_cd = a1.main_wc_cd)
				 	LOOP
                        INSERT
                          INTO GIPI_WPOLWC(par_id, line_cd, wc_cd, swc_seq_no, print_seq_no, wc_title, rec_flag, print_sw, change_tag)
				 	 	VALUES (p_par_id, b.line_cd, b.main_wc_cd, 0, 1, b.wc_title, 'A', b.print_sw, 'N');
				 	END LOOP;
				END LOOP;
			END LOOP;
        END LOOP;
        
        -- check for other perils not present in any endorsement
        FOR m1 IN (SELECT b.policy_id, b.grouped_item_no
                     FROM GIPI_GROUPED_ITEMS b,
                          GIPI_POLBASIC a 
                    WHERE a.line_cd = p_line_cd
                      AND a.subline_cd = p_subline_cd
                      AND a.iss_cd = p_iss_cd
                      AND a.issue_yy = p_issue_yy
                      AND a.pol_seq_no = p_pol_seq_no
                      AND a.renew_no = p_renew_no
                      AND a.pol_flag IN ('1','2','3','X')
                      AND b.policy_id = a.policy_id
                      AND b.grouped_item_no = p_grouped_item_no
                      AND b.item_no = p_item_no)
                      --AND TO_DATE(p_eff_date, 'mm-dd-yyyy') BETWEEN TRUNC(NVL(from_date, eff_date))
                      --AND NVL(to_date, NVL(endt_expiry_date, expiry_date)))
        LOOP
            FOR m2 IN(SELECT p_par_id, item_no, grouped_item_no, line_cd, peril_cd, rec_flag, prem_rt, ann_tsi_amt,
                             ann_prem_amt, aggregate_sw, base_amt, ri_comm_rate, ri_comm_amt, no_of_days
                        FROM GIPI_ITMPERIL_GROUPED
                       WHERE policy_id = m1.policy_id
                         AND item_no = p_item_no
                         AND grouped_item_no = p_grouped_item_no
                         AND peril_cd NOT IN (SELECT peril_cd
                                                FROM GIPI_WITMPERL_GROUPED
                                               WHERE par_id = p_par_id
                                                 AND item_no = p_item_no
                                                 AND grouped_item_no = p_grouped_item_no))
            LOOP
                INSERT
                  INTO GIPI_WITMPERL_GROUPED(par_id, item_no, grouped_item_no, line_cd, peril_cd, rec_flag, prem_rt, ann_tsi_amt,
                                             ann_prem_amt, aggregate_sw, base_amt, ri_comm_rate, ri_comm_amt, no_of_days)
                VALUES (p_par_id, m2.item_no, m2.grouped_item_no, m2.line_cd, m2.peril_cd, m2.rec_flag, m2.prem_rt, m2.ann_tsi_amt,
                        m2.ann_prem_amt, m2.aggregate_sw, m2.base_amt, m2.ri_comm_rate, m2.ri_comm_amt, m2.no_of_days);
            END LOOP;
        END LOOP;  
    END;
    
    FUNCTION get_copy_benefits_listing(
        p_par_id                GIPI_WGROUPED_ITEMS.par_id%TYPE,
        p_grouped_item_no       GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE,
        p_item_no               GIPI_WGROUPED_ITEMS.item_no%TYPE
    )
      RETURN gipi_grouped_items_tab PIPELINED IS
        v_copy                  gipi_grouped_items_type;
    BEGIN
        FOR i IN(SELECT *
                   FROM GIPI_WGROUPED_ITEMS
                  WHERE par_id = p_par_id
                    AND item_no = p_item_no
                    AND grouped_item_no <> p_grouped_item_no)
        LOOP
            v_copy.grouped_item_no := i.grouped_item_no;
            v_copy.grouped_item_title := i.grouped_item_title;
            v_copy.item_no := i.item_no;
            v_copy.control_cd := i.control_cd;
            v_copy.control_type_cd := i.control_type_cd;
            PIPE ROW(v_copy);
        END LOOP;
    END;
    
    PROCEDURE copy_benefits2(
        p_par_id                GIPI_WGROUPED_ITEMS.par_id%TYPE,
        p_item_no               GIPI_WGROUPED_ITEMS.item_no%TYPE,
        p_grouped_item_no       GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE,
        p_pack_ben_cd           GIPI_WGROUPED_ITEMS.pack_ben_cd%TYPE,
        p_col1                  GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE,
        p_line_cd               GIPI_PARLIST.line_cd%TYPE
    )
    IS
        v_no_of_days            NUMBER := 0;
        v_no_of_days2           NUMBER := 0;
        v_year                  NUMBER := 0;
        v_type                  VARCHAR2(1) := '';
        
        v_tsi_amt               NUMBER := 0;
        v_prem_amt              NUMBER := 0;
        v_ann_tsi_amt           NUMBER := 0;
        v_ann_prem_amt          NUMBER := 0;
        v_prem_amt2             NUMBER := 0;
        v_ann_prem_amt2         NUMBER := 0;
        
        v_from_date             GIPI_WGROUPED_ITEMS.from_date%TYPE;
        v_to_date               GIPI_WGROUPED_ITEMS.to_date%TYPE;
        v_b480_from_date        GIPI_WITEM.from_date%TYPE;
        v_b480_to_date          GIPI_WITEM.to_date%TYPE;
        v_b5402_incept_date     GIPI_WPOLBAS.incept_date%TYPE;
        v_b5402_expiry_date     GIPI_WPOLBAS.expiry_date%TYPE;
    BEGIN
        FOR i IN(SELECT from_date, to_date
                   FROM GIPI_WGROUPED_ITEMS
                  WHERE par_id = p_par_id
                    AND item_no = p_item_no
                    AND grouped_item_no = p_grouped_item_no)
        LOOP
            v_from_date := i.from_date;
            v_to_date := i.to_date;
        END LOOP;
        
        FOR i IN(SELECT from_date, to_date
                   FROM GIPI_WITEM
                  WHERE par_id = p_par_id
                    AND item_no = p_item_no)
        LOOP
            v_b480_from_date := i.from_date;
            v_b480_to_date := i.to_date;
        END LOOP;
        
        FOR i IN(SELECT incept_date, expiry_date
                   FROM GIPI_WPOLBAS
                  WHERE par_id = p_par_id)
        LOOP
            v_b5402_incept_date := i.incept_date;
            v_b5402_expiry_date := i.expiry_date;
        END LOOP;
        
        v_no_of_days := TRUNC(NVL(v_to_date, NVL(v_b480_to_date, v_b5402_expiry_date))) - TRUNC(NVL(v_from_date, NVL(v_b480_from_date, v_b5402_incept_date)));
        
        DELETE FROM GIPI_WITMPERL_GROUPED
		 WHERE par_id = p_par_id
           AND item_no = p_item_no
           AND grouped_item_no = p_col1;
           
        -- code for variables.v_pop_checkr = 'Y'
                  
        /* FOR a IN (SELECT peril_cd, benefit base_amt, prem_pct prem_rt
                    FROM GIIS_PACKAGE_BENEFIT_DTL
                   WHERE pack_ben_cd = p_pack_ben_cd)
        LOOP
            SELECT TO_NUMBER(TO_CHAR(TO_DATE('12/31/'||TO_CHAR(SYSDATE,'YYYY'),'MM/DD/YYYY'),'DDD')) 
			  INTO v_year
			  FROM dual;
              
            v_tsi_amt := NVL(v_no_of_days, 0) * NVL(a.base_amt, 0);
            v_prem_amt := ROUND((((NVL(a.prem_rt, 0)) / 100) * NVL(v_tsi_amt, 0) * NVL(v_no_of_days, 0)) / v_year, 2);
            v_ann_prem_amt := ROUND(((NVL(a.prem_rt, 0)) / 100) * NVL(v_tsi_amt, 0), 2);
            
            INSERT
              INTO GIPI_WITMPERL_GROUPED(par_id, item_no, grouped_item_no, line_cd, 
                                         peril_cd, rec_flag, no_of_days, prem_rt, 
                                         tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt,
                                         aggregate_sw, base_amt)
            VALUES (p_par_id, p_item_no, p_col1, p_line_cd,
                    a.peril_cd, 'C', v_no_of_days, a.prem_rt, 
                    v_tsi_amt, v_prem_amt, v_tsi_amt, v_ann_prem_amt,
                    'Y', a.base_amt);
                    
            SELECT peril_type
			  INTO v_type
			  FROM GIIS_PERIL 
			 WHERE peril_cd = a.peril_cd 
			   AND line_cd = p_line_cd;
               
            IF v_type = 'B' THEN
                v_ann_tsi_amt := ROUND((v_ann_tsi_amt + v_tsi_amt), 2);
            END IF;
            v_prem_amt2 := ROUND((v_prem_amt2 + v_prem_amt), 2);
			v_ann_prem_amt2 := ROUND((v_ann_prem_amt2 + v_ann_prem_amt), 2);
        END LOOP; */
        
        -- end of variables.v_pop_checkr = 'N'
        
        FOR a IN (SELECT peril_cd, base_amt, prem_rt, ann_tsi_amt, no_of_days, tsi_amt, ann_prem_amt, prem_amt, aggregate_sw
					FROM GIPI_WITMPERL_GROUPED 
                   WHERE par_id = p_par_id
                     AND item_no = p_item_no
                     AND grouped_item_no = p_grouped_item_no
                   ORDER BY grouped_item_no)
        LOOP
            v_no_of_days2 := NVL(a.no_of_days, v_no_of_days);
            								
            INSERT
              INTO GIPI_WITMPERL_GROUPED(par_id, item_no, grouped_item_no, line_cd, 
                                         peril_cd, rec_flag, no_of_days, prem_rt, 
                                         tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt, 
                                         aggregate_sw, base_amt)
			VALUES (p_par_id, p_item_no, p_col1, p_line_cd, 
                    a.peril_cd, 'C', v_no_of_days2, a.prem_rt, 
					a.tsi_amt, a.prem_amt, a.ann_tsi_amt, a.ann_prem_amt,
					a.aggregate_sw, a.base_amt);
                    
            SELECT peril_type
              INTO v_type
              FROM giis_peril 
             WHERE peril_cd = a.peril_cd 
               AND line_cd = p_line_cd;
                           
            IF v_type = 'B' THEN
                v_ann_tsi_amt := ROUND((v_ann_tsi_amt + a.tsi_amt), 2);
            END IF;

            v_prem_amt2 := ROUND((v_prem_amt2 + a.prem_amt), 2);
            v_ann_prem_amt2 := ROUND((v_ann_prem_amt2 + a.ann_prem_amt), 2);
        END LOOP;
        
        UPDATE GIPI_WGROUPED_ITEMS
           SET ann_tsi_amt = v_ann_tsi_amt,			   		 
               tsi_amt = v_ann_tsi_amt,
               ann_prem_amt = v_ann_prem_amt2,
               prem_amt = v_prem_amt2,
               pack_ben_cd = p_pack_ben_cd,
               amount_covered = v_ann_tsi_amt
         WHERE par_id = p_par_id
           AND item_no = p_item_no
           AND grouped_item_no = p_col1;
    END;
    
    PROCEDURE insert_rec_grp_witem(
        p_par_id                GIPI_WGROUPED_ITEMS.par_id%TYPE,
        p_line_cd               GIPI_WPOLBAS.line_cd%TYPE,
        p_subline_cd            GIPI_WPOLBAS.subline_cd%TYPE,
        p_iss_cd                GIPI_WPOLBAS.iss_cd%TYPE,
        p_issue_yy              GIPI_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no            GIPI_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no              GIPI_WPOLBAS.renew_no%TYPE,
        p_eff_date              VARCHAR2,
        p_item_no               GIPI_WGROUPED_ITEMS.item_no%TYPE,
        p_no_of_persons         VARCHAR2
    )
    IS
        v_exists                NUMBER := 0;
        v_exists2               NUMBER := 0;
        v_exists3               NUMBER := 0;
    
        v_tsi_amt               GIPI_WITMPERL.tsi_amt%TYPE := 0;
        v_prem_amt              GIPI_WITMPERL.prem_amt%TYPE := 0;
        v_policy_id             GIPI_POLBASIC.policy_id%TYPE := 0;
        v_ann_tsi_amt           GIPI_WITMPERL.ann_tsi_amt%TYPE := 0;
        v_ann_prem_amt          GIPI_WITMPERL.ann_prem_amt%TYPE := 0;
        vtot_ann_tsi_amt        GIPI_WITMPERL.ann_tsi_amt%TYPE := 0;
        vtot_ann_prem_amt       GIPI_WITMPERL.ann_prem_amt%TYPE := 0;
        v_item_ann_tsi_amt      GIPI_WITMPERL.ann_tsi_amt%TYPE := 0;
        v_item_ann_prem_amt     GIPI_WITMPERL.ann_prem_amt%TYPE := 0;
        vg1_ann_tsi_amt         GIPI_WITMPERL.ann_tsi_amt%TYPE := 0;
        vg1_ann_prem_amt        GIPI_WITMPERL.ann_prem_amt%TYPE := 0;
        v2_ann_tsi_amt          GIPI_WITMPERL.ann_tsi_amt%TYPE := 0;
        v2_ann_prem_amt         GIPI_WITMPERL.ann_prem_amt%TYPE := 0;
        vtot_item_ann_tsi_amt   GIPI_WITMPERL.ann_tsi_amt%TYPE := 0;
        vtot_item_ann_prem_amt  GIPI_WITMPERL.ann_prem_amt%TYPE := 0;
        v_par_type              gipi_parlist.par_type%TYPE; -- added by apollo cruz 02.23.2015
        v_no_of_persons         NUMBER;
    BEGIN
        IF(p_no_of_persons IS NOT NULL) THEN
            UPDATE GIPI_WACCIDENT_ITEM
               SET no_of_persons = TO_NUMBER(p_no_of_persons)
             WHERE par_id = p_par_id
               AND item_no = p_item_no;
        END IF;
    
        FOR j IN (SELECT a.policy_id policy_id
					FROM GIPI_POLBASIC a
                   WHERE a.line_cd = p_line_cd
                     AND a.iss_cd = p_iss_cd
                     AND a.subline_cd = p_subline_cd
                     AND a.issue_yy = p_issue_yy
                     AND a.pol_seq_no = p_pol_seq_no
                     AND a.renew_no = p_renew_no
                     AND a.pol_flag IN ('1','2','3','X')
                     AND TRUNC(a.eff_date) <= TRUNC(TO_DATE(p_eff_date, 'mm-dd-yyyy'))
                     AND TRUNC(NVL(a.endt_expiry_date, a.expiry_date)) >=  TRUNC(TO_DATE(p_eff_date, 'mm-dd-yyyy'))
                   ORDER BY endt_seq_no DESC)
        LOOP
            v_policy_id := j.policy_id;
            EXIT;
		END LOOP;
      
       SELECT par_type
         INTO v_par_type
         FROM gipi_parlist
        WHERE par_id = p_par_id;
        
       -- added by apollo cruz 03.06.2015 - to get the correct no. of persons
       IF v_par_type = 'E' THEN
          SELECT COUNT(*) 
            INTO v_no_of_persons
            FROM (SELECT grouped_item_no
                    FROM gipi_grouped_items
                   WHERE policy_id IN (SELECT a.policy_id
                                         FROM gipi_polbasic a
                                        WHERE a.line_cd = p_line_cd
                                          AND a.iss_cd = p_iss_cd
                                          AND a.subline_cd = p_subline_cd
                                          AND a.issue_yy = p_issue_yy
                                          AND a.pol_seq_no = p_pol_seq_no
                                          AND a.renew_no = p_renew_no
                                          AND a.pol_flag IN ('1','2','3','X')
                                          AND TRUNC(a.eff_date) <= TRUNC(TO_DATE(p_eff_date, 'mm-dd-yyyy'))
                                          AND TRUNC(NVL(a.endt_expiry_date, a.expiry_date)) >= TRUNC(TO_DATE(p_eff_date, 'mm-dd-yyyy')))
                     AND item_no = p_item_no
                   UNION          
                  SELECT grouped_item_no
                    FROM gipi_wgrouped_items
                   WHERE par_id = p_par_id
                     AND item_no = p_item_no);
          
          UPDATE GIPI_WACCIDENT_ITEM
               SET no_of_persons = v_no_of_persons
             WHERE par_id = p_par_id
               AND item_no = p_item_no;
       END IF;       
        
        FOR x IN (SELECT peril_cd
		 		    FROM GIPI_WITMPERL
		 	       WHERE par_id = p_par_id
		 			 AND item_no = p_item_no)
        LOOP
		    v_exists3 := 1;
			FOR y IN (SELECT peril_cd
						FROM GIPI_WITMPERL_GROUPED
					   WHERE par_id = p_par_id
                         AND item_no = p_item_no
                         AND peril_cd = x.peril_cd)
            LOOP
				v_exists3 := 0;
			END LOOP;
            
			IF v_exists3 = 1 THEN
				DELETE
                  FROM GIPI_WITMPERL
				 WHERE par_id = p_par_id
                   AND item_no = p_item_no
                   AND peril_cd = x.peril_cd;
			END IF;
		END LOOP;
        
        FOR j IN (SELECT SUM(tsi_amt) tsi_amt, SUM(prem_amt) prem_amt, a.peril_cd, item_no, b.peril_type peril_type
                    FROM GIPI_WITMPERL_GROUPED a,
                         GIIS_PERIL b
                   WHERE par_id = p_par_id
                     AND item_no = p_item_no
                     AND a.peril_cd = b.peril_cd
                     AND a.line_cd = b.line_cd
                   GROUP BY a.peril_cd, a.item_no,b.peril_type)
        LOOP
            vtot_ann_tsi_amt := NULL;
            vtot_ann_prem_amt := NULL;
            vg1_ann_tsi_amt := 0;
            vg1_ann_prem_amt := 0;
            v2_ann_tsi_amt := 0;
            v2_ann_prem_amt := 0;				
            v_exists2 := 1;
            v_ann_tsi_amt := 0;
			v_ann_prem_amt := 0;
            
            FOR exsts IN (SELECT 1
                            FROM GIPI_WITMPERL
                           WHERE par_id = p_par_id
                             AND item_no = p_item_no
                             AND peril_cd = j.peril_cd)
            LOOP			 	           
                v_exists := 1;
                EXIT;
            END LOOP;
            
            FOR g1 IN (SELECT NVL(ann_tsi_amt,0) ann_tsi_amt, NVL(ann_prem_amt,0) ann_prem_amt, grouped_item_no
                         FROM GIPI_WITMPERL_GROUPED
                        WHERE par_id = p_par_id
                          AND item_no = p_item_no
                          AND peril_cd = j.peril_cd)
            LOOP
                vg1_ann_tsi_amt  := vg1_ann_tsi_amt + g1.ann_tsi_amt;
				vg1_ann_prem_amt := vg1_ann_prem_amt + g1.ann_prem_amt;
                
                FOR g2 IN (SELECT NVL(ann_tsi_amt,0) ann_tsi_amt, NVL(ann_prem_amt,0) ann_prem_amt
						 	 FROM GIPI_ITMPERIL_GROUPED
                            WHERE policy_id = v_policy_id
						 	  AND item_no = p_item_no
                              AND grouped_item_no = g1.grouped_item_no
                              AND peril_cd = j.peril_cd)
                LOOP						 				    	
                    vg1_ann_tsi_amt := g1.ann_tsi_amt - g2.ann_tsi_amt;
                    vg1_ann_prem_amt := g1.ann_prem_amt - g2.ann_prem_amt;						
                    vtot_ann_tsi_amt := NVL(vtot_ann_tsi_amt,0) + vg1_ann_tsi_amt;
                    vtot_ann_prem_amt := NVL(vtot_ann_prem_amt,0) + vg1_ann_prem_amt;
                END LOOP;
            END LOOP;
            
            FOR g IN (SELECT NVL(ann_tsi_amt, 0) ann_tsi_amt, NVL(ann_prem_amt, 0) ann_prem_amt
                        FROM gipi_itmperil
                       WHERE policy_id = v_policy_id
                         AND item_no = p_item_no
                         AND peril_cd = j.peril_cd)
            LOOP
                v2_ann_tsi_amt  := g.ann_tsi_amt;
                v2_ann_prem_amt := g.ann_prem_amt;
            END LOOP;
            
            v_ann_tsi_amt := v2_ann_tsi_amt + NVL(vtot_ann_tsi_amt, vg1_ann_tsi_amt);
			v_ann_prem_amt := v2_ann_prem_amt + NVL(vtot_ann_prem_amt, vg1_ann_prem_amt);
            
            IF v_exists = 1 THEN					
                UPDATE GIPI_WITMPERL
                   SET tsi_amt = NVL(j.tsi_amt, 0),
                       prem_amt = NVL(j.prem_amt, 0),
                       ann_tsi_amt  = NVL(v_ann_tsi_amt, 0),
                       ann_prem_amt = NVL(v_ann_prem_amt, 0)
                 WHERE par_id = p_par_id
                   AND item_no = p_item_no
                   AND line_cd = p_line_cd
                   AND peril_cd = j.peril_cd;
                v_exists := 0;
            ELSE
                INSERT
                  INTO GIPI_WITMPERL(par_id, item_no, line_cd, peril_cd,
                                     tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt)
                VALUES(p_par_id, p_item_no, p_line_cd, j.peril_cd,
                       NVL(j.tsi_amt, 0), NVL(j.prem_amt, 0), NVL(v_ann_tsi_amt, 0), NVL(v_ann_prem_amt, 0));
            END IF;
            
            IF j.peril_type = 'B' THEN
                v_tsi_amt := NVL(j.tsi_amt, 0) + v_tsi_amt;
                vtot_item_ann_tsi_amt := vtot_item_ann_tsi_amt + NVL(vtot_ann_tsi_amt, vg1_ann_tsi_amt);
            END IF;
            v_prem_amt := NVL(j.prem_amt, 0) + v_prem_amt;
			vtot_item_ann_prem_amt := vtot_item_ann_prem_amt + NVL(vtot_ann_prem_amt, vg1_ann_prem_amt);
        END LOOP;
        
        IF v_exists2 = 1 THEN
            v_item_ann_tsi_amt := 0;
            v_item_ann_prem_amt := 0;
        
            FOR g IN (SELECT ann_tsi_amt, ann_prem_amt
                        FROM GIPI_ITEM
                       WHERE policy_id = v_policy_id
                         AND item_no = p_item_no)
            LOOP
                v_item_ann_tsi_amt  := g.ann_tsi_amt;
                v_item_ann_prem_amt := g.ann_prem_amt;
            END LOOP;
          
            UPDATE GIPI_WITEM
               SET tsi_amt = v_tsi_amt,
                   prem_amt = v_prem_amt,
                   ann_tsi_amt = v_item_ann_tsi_amt + vtot_item_ann_tsi_amt,
                   ann_prem_amt = v_item_ann_prem_amt + vtot_item_ann_prem_amt
             WHERE par_id = p_par_id
               AND item_no = p_item_no;
          
            IF NVL(v_tsi_amt,0) <> 0 THEN
			    cr_bill_dist.get_tsi(p_par_id);
            END IF;
        ELSE
            UPDATE GIPI_WITEM
               SET tsi_amt = 0,
                   prem_amt = 0,
                   ann_tsi_amt = 0,
                   ann_prem_amt = 0
             WHERE par_id = p_par_id
               AND item_no = p_item_no;
               
            IF NVL(v_tsi_amt,0) <> 0 THEN				
			    cr_bill_dist.get_tsi(p_par_id);
			END IF;
        END IF;
    END;
    
    PROCEDURE set_amount_covered(
        p_par_id                GIPI_WGROUPED_ITEMS.par_id%TYPE,
        p_item_no               GIPI_WGROUPED_ITEMS.item_no%TYPE,
        p_grouped_item_no       GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE,
        p_tsi_amt               GIPI_WGROUPED_ITEMS.tsi_amt%TYPE,
        p_prem_amt              GIPI_WGROUPED_ITEMS.prem_amt%TYPE,
        p_ann_tsi_amt           GIPI_WGROUPED_ITEMS.ann_tsi_amt%TYPE,
        p_ann_prem_amt          GIPI_WGROUPED_ITEMS.ann_prem_amt%TYPE
    )
    IS
    BEGIN
        UPDATE GIPI_WGROUPED_ITEMS
	       SET tsi_amt = p_tsi_amt,
               prem_amt = p_prem_amt,
               ann_tsi_amt = p_ann_tsi_amt,
	           ann_prem_amt = p_ann_prem_amt,
	           amount_covered = p_ann_tsi_amt
	     WHERE par_id = p_par_id
	       AND item_no = p_item_no
	       AND grouped_item_no = p_grouped_item_no;
    END;
    
    FUNCTION check_package(
        p_par_id                GIPI_WGROUPED_ITEMS.par_id%TYPE,
        p_item_no               GIPI_WGROUPED_ITEMS.item_no%TYPE,
        p_grouped_item_no       GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE
    )
      RETURN VARCHAR2
    IS
        v_exist                 VARCHAR2(1) := 'N';
    BEGIN
        SELECT 'Y'
          INTO v_exist
          FROM GIPI_WGROUPED_ITEMS
         WHERE par_id = p_par_id
           AND item_no = p_item_no
           AND grouped_item_no = p_grouped_item_no;

    RETURN v_exist;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'N';
    END;
    
    PROCEDURE update_prem_amounts (
      p_par_id    IN gipi_waccident_item.par_id%TYPE)
   IS
      v_ann_prem_amt   gipi_wgrouped_items.ann_prem_amt%TYPE;
      v_prem_amt       gipi_wgrouped_items.prem_amt%TYPE;
   BEGIN
   	 for itm in (select item_no from gipi_witem where par_id = p_par_id)loop
      FOR g IN (SELECT GROUPed_item_no
                  FROM GIPI_WGROUPED_ITEMS
                 WHERE par_id = p_par_id AND item_no = itm.item_no)
      LOOP
         v_ann_prem_amt := 0;
         v_prem_amt := 0;

         FOR i
            IN (SELECT ANN_PREM_AMT, PREM_AMT
                  FROM GIPI_WITMPERL_GROUPED
                 WHERE     par_id = p_par_id
                       AND item_no = itm.item_no
                       AND grouped_item_no = g.grouped_item_no)
         LOOP
            v_ann_prem_amt :=v_ann_prem_amt + NVL (i.ann_prem_amt, 0);
            v_prem_amt := v_prem_amt + NVL (i.PREM_AMT, 0);
         END LOOP;
		 
		 update GIPI_WGROUPED_ITEMS set ann_prem_amt = v_ann_prem_amt, prem_amt = v_prem_amt where par_id = p_par_id and item_no = itm.item_no and grouped_item_no = g.grouped_item_no;
      END LOOP;
  end loop;
   END;
   
	/*
	**  Created by    : Veronica V. Raymundo
	**  Date Created  : 01.08.2013
	**  Reference By  : GIPIS012- Item Information (Accident - Grouped Items)
	**  Description   : Inserts records from grouped tables(witemperil_grouped, 
	**                  wgrouped_items) to witemperil and witem
	** 	
	*/
	
	PROCEDURE INSERT_RECGRP_WITEM2
	 (p_par_id            IN   GIPI_WACCIDENT_ITEM.par_id%TYPE,
	  p_item_no           IN   GIPI_WACCIDENT_ITEM.item_no%TYPE,
	  p_line_cd           IN   GIPI_WGROUPED_ITEMS.line_cd%TYPE) IS
    
    
    v_exists             NUMBER:=0;
    v_exists2            NUMBER:=0;
    v_exists3            NUMBER:=0; --for deleting purposes
    v_exists4            NUMBER:=0; --issa
    v_tsi_amt            GIPI_WITMPERL.tsi_amt%TYPE:=0;
    v_prem_amt           GIPI_WITMPERL.prem_amt%TYPE:=0;
    v_ann_prem_amt       GIPI_WITMPERL.ann_prem_amt%TYPE:=0; --issa@fpac09.18.2006, for ann_prem_amt
    v_ann_prem_amt4      GIPI_GROUPED_ITEMS.ann_prem_amt%TYPE:=0; --issa@fpac09.18.2006, for ann_prem_amt
    v_tsi_amt4           GIPI_GROUPED_ITEMS.tsi_amt%TYPE:=0;
    
    
    BEGIN
        --IF NOT variables.v_itmperil_exist THEN
            
        FOR x IN (SELECT peril_cd
                    FROM GIPI_WITMPERL
                   WHERE par_id = p_par_id
                     AND item_no = p_item_no) 
        LOOP             
            v_exists3 := 1;
                
            FOR y IN (SELECT peril_cd
                        FROM GIPI_WITMPERL_GROUPED
                       WHERE par_id = p_par_id
                         AND item_no = p_item_no                         
                         AND peril_cd = x.peril_cd) 
            LOOP
                v_exists3 := 0;
            END LOOP;                         
                
            IF v_exists3 = 1 THEN
                DELETE FROM GIPI_WITMPERL
                    WHERE par_id   = p_par_id
                      AND item_no  = p_item_no
                      AND peril_cd = x.peril_cd;
            END IF;             
        END LOOP;
                
      /* gmi */
      --issa@fpac09.18.2006, added SUM(ann_prem_amt) ann_prem_amt 
        FOR j IN (SELECT SUM(tsi_amt) tsi_amt,SUM(prem_amt) prem_amt,
                         SUM(ann_prem_amt) ann_prem_amt,a.peril_cd, 
                         item_no, b.peril_type
                    FROM GIPI_WITMPERL_GROUPED a, 
                         GIIS_PERIL b
                   WHERE par_id = p_par_id
                     AND item_no = p_item_no
                     AND a.peril_cd = b.peril_cd
                     AND a.line_cd = b.line_cd
                GROUP BY a.peril_cd, a.item_no,b.peril_type) 
        LOOP
            v_exists2 := 1;
                
            FOR g IN (SELECT 1
                        FROM GIPI_WITMPERL
                       WHERE par_id = p_par_id
                         AND item_no = p_item_no
                         AND peril_cd = j.peril_cd) 
            LOOP
                 v_exists := 1;
            END LOOP;
                    
            IF v_exists = 1 THEN
                UPDATE GIPI_WITMPERL
                   SET tsi_amt  = j.tsi_amt,
                       prem_amt = j.prem_amt,
                       ann_tsi_amt = j.tsi_amt,
                       ann_prem_amt = j.ann_prem_amt --issa@fpac09.18.2006, for ann_prem_amt
                 WHERE par_id = p_par_id
                   AND item_no = p_item_no
                   AND line_cd = p_line_cd
                   AND peril_cd = j.peril_cd;
                 v_exists := 0;
            ELSE
                INSERT INTO GIPI_WITMPERL
                    (par_id,  item_no,  line_cd,     peril_cd,
                     tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt ) --issa@fpac09.18.2006, for ann_prem_amt
                VALUES
                    (p_par_id,  p_item_no,  p_line_cd, j.peril_cd,
                     j.tsi_amt, j.prem_amt, j.tsi_amt, j.ann_prem_amt);
            END IF;
                    
            IF j.peril_type = 'B' THEN
                v_tsi_amt := NVL(j.tsi_amt,0) + v_tsi_amt;
            END IF;
                
            v_prem_amt        := NVL(j.prem_amt,0) + v_prem_amt;
            v_ann_prem_amt    := NVL(j.ann_prem_amt,0) + v_ann_prem_amt; --issa@fpac09.18.2006, for ann_prem_amt
                        
        END LOOP;
            
        IF v_exists2 = 1 THEN
            UPDATE GIPI_WITEM
               SET tsi_amt = v_tsi_amt,
                   prem_amt = v_prem_amt,
                   ann_tsi_amt = v_tsi_amt,
                   ann_prem_amt = v_ann_prem_amt --issa@fpac09.18.2006, for ann_prem_amt
             WHERE par_id = p_par_id
               AND item_no = p_item_no;
                
            CR_BILL_DIST.get_tsi(p_par_id);
                   
        ELSE
            UPDATE GIPI_WITEM
               SET tsi_amt = 0,
                   prem_amt = 0,
                   ann_tsi_amt = 0,
                   ann_prem_amt = 0
             WHERE par_id = p_par_id
               AND item_no = p_item_no;
                
            CR_BILL_DIST.get_tsi(p_par_id);
                
        END IF;    
            
        FOR grp_itmno IN (SELECT grouped_item_no
                            FROM GIPI_WGROUPED_ITEMS
                           WHERE par_id = p_par_id 
                             AND item_no = p_item_no)                 
        LOOP
            v_tsi_amt4 := 0;
            v_ann_prem_amt4 := 0;
            v_exists4 := 0;
                
            --issa@fpac09.19.2006, to correct amounts for ann_prem_amt in gipi_witmperl_grouped 
            FOR i IN (SELECT SUM (a.ann_prem_amt) ann_prem_amt, 
                             SUM(a.tsi_amt) tsi_amt, b.peril_type
                        FROM GIPI_WITMPERL_GROUPED a, 
                             GIIS_PERIL b
                       WHERE a.par_id = p_par_id
                         AND a.item_no = p_item_no
                         AND a.grouped_item_no = grp_itmno.grouped_item_no
                         AND a.peril_cd = b.peril_cd
                         AND a.line_cd = b.line_cd
                      GROUP BY b.peril_type) 
            LOOP
               v_exists4 := 1;
                                   
               IF i.peril_type = 'B' THEN
                   v_tsi_amt4 := NVL(i.tsi_amt,0) + v_tsi_amt4;
               END IF;
               v_ann_prem_amt4 := NVL(i.ann_prem_amt,0) + v_ann_prem_amt4; --issa@fpac09.18.2006, for ann_prem_amt
                   
            END LOOP;
                
            --issa@fpac09.18.2006-- 
            IF v_exists4 = 1 THEN
                UPDATE GIPI_WGROUPED_ITEMS
                   SET ann_prem_amt = v_ann_prem_amt4,
                       tsi_amt = v_tsi_amt4,
                       ann_tsi_amt = v_tsi_amt4    
                 WHERE par_id = p_par_id
                   AND item_no = p_item_no
                   AND grouped_item_no = grp_itmno.grouped_item_no;
            ELSE      
                UPDATE GIPI_WGROUPED_ITEMS
                   SET ann_prem_amt = 0,
                       tsi_amt = 0,
                       ann_tsi_amt = 0
                 WHERE par_id = p_par_id
                   AND item_no = p_item_no
                   AND grouped_item_no = grp_itmno.grouped_item_no;
            END IF;
                
        END LOOP;
            
    END INSERT_RECGRP_WITEM2;
    
   --Deo [01.26.2017]: add start (SR-23702)
   FUNCTION get_ca_grouped_items (
      p_par_id       gipi_wgrouped_items.par_id%TYPE,
      p_line_cd      gipi_wpolbas.line_cd%TYPE,
      p_subline_cd   gipi_wpolbas.subline_cd%TYPE,
      p_iss_cd       gipi_wpolbas.iss_cd%TYPE,
      p_issue_yy     gipi_wpolbas.issue_yy%TYPE,
      p_pol_seq_no   gipi_wpolbas.pol_seq_no%TYPE,
      p_renew_no     gipi_wpolbas.renew_no%TYPE,
      p_item_no      VARCHAR2,
      p_eff_date     VARCHAR2
   )
      RETURN ca_grp_itm_type_tab PIPELINED
   IS
      v_rec     ca_grp_itm_type;
      TYPE cur_type IS REF CURSOR;
      cur       cur_type;
      v_query   VARCHAR2 (30000);
      v_eff_date DATE := TO_DATE (p_eff_date, 'MM-DD-YYYY');
   BEGIN
      v_query :=
            'SELECT :p_par_id par_id, item_no, grouped_item_no, include_tag,
                   grouped_item_title, group_cd, amount_coverage, remarks,
                   line_cd, subline_cd
              FROM gipi_grouped_items c
             WHERE (policy_id, item_no, grouped_item_no) IN (
                      SELECT DISTINCT b.policy_id, b.item_no, b.grouped_item_no
                                 FROM gipi_polbasic a, gipi_grouped_items b
                                WHERE a.line_cd = :p_line_cd
                                  AND a.subline_cd = :p_subline_cd
                                  AND a.iss_cd = :p_iss_cd
                                  AND a.issue_yy = :p_issue_yy
                                  AND a.pol_seq_no = :p_pol_seq_no
                                  AND a.renew_no = :p_renew_no
                                  AND a.pol_flag IN (''1'', ''2'', ''3'', ''X'')
                                  AND a.policy_id = b.policy_id
                                  AND b.item_no IN ('
         || p_item_no
         || ')
                                  AND :v_eff_date
                                         BETWEEN TRUNC (NVL (b.from_date,
                                                             a.eff_date
                                                            )
                                                       )
                                             AND NVL (b.to_date,
                                                      NVL (a.endt_expiry_date,
                                                           a.expiry_date
                                                          )
                                                     )
                                  AND endt_seq_no =
                                         (SELECT MAX (endt_seq_no)
                                            FROM gipi_polbasic x,
                                                 gipi_grouped_items y
                                           WHERE x.line_cd = :p_line_cd
                                             AND x.subline_cd = :p_subline_cd
                                             AND x.iss_cd = :p_iss_cd
                                             AND x.issue_yy = :p_issue_yy
                                             AND x.pol_seq_no = :p_pol_seq_no
                                             AND x.renew_no = :p_renew_no
                                             AND x.pol_flag IN
                                                         (''1'', ''2'', ''3'', ''X'')
                                             AND x.policy_id = y.policy_id
                                             AND y.item_no = b.item_no
                                             AND y.grouped_item_no =
                                                             b.grouped_item_no
                                             AND :v_eff_date
                                                    BETWEEN TRUNC
                                                              (NVL
                                                                  (y.from_date,
                                                                   x.eff_date
                                                                  )
                                                              )
                                                        AND NVL
                                                              (y.to_date,
                                                               NVL
                                                                  (x.endt_expiry_date,
                                                                   x.expiry_date
                                                                  )
                                                              )))
               AND item_no IN ('
         || p_item_no
         || ')
               AND NOT EXISTS (
                      SELECT 1
                        FROM gipi_wgrouped_items z
                       WHERE z.par_id = :p_par_id
                         AND z.item_no = c.item_no
                         AND z.grouped_item_no = c.grouped_item_no)
          ORDER BY item_no, grouped_item_no';

      OPEN cur FOR v_query
      USING p_par_id, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy,
            p_pol_seq_no, p_renew_no, v_eff_date, p_line_cd, p_subline_cd,
            p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, v_eff_date,
            p_par_id;

      LOOP
         FETCH cur
          INTO v_rec;

         EXIT WHEN cur%NOTFOUND;
         PIPE ROW (v_rec);
      END LOOP;

      CLOSE cur;
   END get_ca_grouped_items;
   --Deo [01.26.2017]: add ends (SR-23702) 
END;
/


