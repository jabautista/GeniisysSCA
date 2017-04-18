CREATE OR REPLACE PACKAGE BODY CPI.gicl_motor_car_dtl_pkg
AS
/******************************************************************************
   NAME:       GICL_MOTOR_CAR_DTL_pkg
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/23/2011  Irwin Tabisora  1. Created this package.
******************************************************************************/
   FUNCTION get_gicl_motor_car_dtl (
      p_claim_id   gicl_motor_car_dtl.claim_id%TYPE
   )
      RETURN gicl_motor_car_dtl_tab PIPELINED
   IS
      v_mc_item   gicl_motor_car_dtl_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM gicl_motor_car_dtl
                 WHERE claim_id = p_claim_id)
      LOOP
         v_mc_item.claim_id := i.claim_id;
         v_mc_item.item_no := i.item_no;
         v_mc_item.motor_no := i.motor_no;
         v_mc_item.user_id := i.user_id;
         v_mc_item.item_title := i.item_title;
         v_mc_item.model_year := i.model_year;
         v_mc_item.plate_no := i.plate_no;
         v_mc_item.drvr_occ_cd := i.drvr_occ_cd;
         v_mc_item.drvr_name := i.drvr_name;
         v_mc_item.drvr_sex := i.drvr_sex;
         v_mc_item.drvr_age := i.drvr_age;
         v_mc_item.motcar_comp_cd := i.motcar_comp_cd;
         v_mc_item.make_cd := i.make_cd;
         v_mc_item.color := i.color;
         v_mc_item.subline_type_cd := i.subline_type_cd;
         v_mc_item.basic_color_cd := i.basic_color_cd;
         v_mc_item.color_cd := i.color_cd;
         v_mc_item.serial_no := i.serial_no;
         v_mc_item.loss_date := TO_CHAR (i.loss_date, 'MM-DD-YYYY');
         v_mc_item.currency_cd := i.currency_cd;
         v_mc_item.mot_type := i.mot_type;
         v_mc_item.series_cd := i.series_cd;
         v_mc_item.currency_rate := i.currency_rate;
         v_mc_item.no_of_pass := i.no_of_pass;
         v_mc_item.towing := i.towing;
         v_mc_item.drvr_add := i.drvr_add;
         v_mc_item.other_info := i.other_info;
         v_mc_item.drvng_exp := i.drvng_exp;
         v_mc_item.nationality_cd := i.nationality_cd;
         v_mc_item.relation := i.relation;
         v_mc_item.assignee := i.assignee;
         v_mc_item.last_update := i.last_update;
         v_mc_item.mv_file_no := i.mv_file_no;
         v_mc_item.cpi_rec_no := i.cpi_rec_no;
         v_mc_item.cpi_branch_cd := i.cpi_branch_cd;

         BEGIN
            SELECT item_desc, item_desc2
              INTO v_mc_item.item_desc, v_mc_item.item_desc2
              FROM gicl_clm_item
             WHERE 1 = 1
               AND claim_id = p_claim_id
               AND item_no = v_mc_item.item_no
               AND grouped_item_no = 0;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_mc_item.item_desc := NULL;
               v_mc_item.item_desc2 := NULL;
         END;

         FOR c IN (SELECT currency_desc
                     FROM giis_currency
                    WHERE main_currency_cd = v_mc_item.currency_cd)
         LOOP
            v_mc_item.dsp_currency_desc := c.currency_desc;
         END LOOP;

         FOR a IN (SELECT car_company
                     FROM giis_mc_car_company
                    WHERE car_company_cd = v_mc_item.motcar_comp_cd)
         LOOP
            v_mc_item.motcar_comp_desc := a.car_company;
         END LOOP;

         FOR b IN (SELECT subline_type_desc
                     FROM giis_mc_subline_type
                    WHERE subline_type_cd = v_mc_item.subline_type_cd)
         LOOP
            v_mc_item.subline_type_desc := b.subline_type_desc;
         END LOOP;

--get make
         FOR c IN (SELECT make
                     FROM giis_mc_make
                    WHERE make_cd = v_mc_item.make_cd
                      AND car_company_cd = v_mc_item.motcar_comp_cd)
         LOOP
            v_mc_item.make_desc := c.make;
         END LOOP;

         --get basic color
         FOR d IN (SELECT basic_color
                     FROM giis_mc_color
                    WHERE basic_color_cd = v_mc_item.basic_color_cd
                      AND color_cd = NVL (v_mc_item.color_cd, color_cd))
         LOOP
            v_mc_item.basic_color := d.basic_color;
         END LOOP;

         -- get mot_type desc
         FOR mot_type IN (SELECT motor_type_desc des
                            FROM giis_motortype
                           WHERE type_cd = v_mc_item.mot_type)
         LOOP
            v_mc_item.mot_type_desc := mot_type.des;
         END LOOP;

         -- get engine series
         FOR eng IN (SELECT engine_series series
                       FROM giis_mc_eng_series
                      WHERE series_cd = v_mc_item.series_cd)
         LOOP
            v_mc_item.engine_series := eng.series;
            EXIT;
         END LOOP;

         -- driver desc
         FOR d IN (SELECT occ_desc
                     FROM gicl_drvr_occptn
                    WHERE drvr_occ_cd LIKE v_mc_item.drvr_occ_cd)
         LOOP
            v_mc_item.drvr_occ_desc := d.occ_desc;
         END LOOP;

         FOR n IN (SELECT nationality_desc
                     FROM giis_nationality
                    WHERE nationality_cd LIKE v_mc_item.nationality_cd)
         LOOP
            v_mc_item.nationality_desc := n.nationality_desc;
         END LOOP;

         SELECT gicl_item_peril_pkg.get_gicl_item_peril_exist
                                                           (v_mc_item.item_no,
                                                            v_mc_item.claim_id
                                                           )
           INTO v_mc_item.gicl_item_peril_exist
           FROM DUAL;

         SELECT gicl_mortgagee_pkg.get_gicl_mortgagee_exist
                                                           (v_mc_item.item_no,
                                                            v_mc_item.claim_id
                                                           )
           INTO v_mc_item.gicl_mortgagee_exist
           FROM DUAL;

         gicl_item_peril_pkg.validate_peril_reserve
                                         (v_mc_item.item_no,
                                          v_mc_item.claim_id,
                                          0,
                                            --belle grouped item no 02.13.2012
                                          v_mc_item.gicl_item_peril_msg
                                         );
         PIPE ROW (v_mc_item);
      END LOOP;
   END;

   /*
   **  Created by   :  Irwin Tabisora
   **  Date Created :  09.202011
   **  Reference By : (GICLS014- Claims Motorcar Item Information)
   **  Description  : Validates the item_no
   */
   PROCEDURE validate_gicl_motorcar_item_no (
      p_line_cd                 gipi_polbasic.line_cd%TYPE,
      p_subline_cd              gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd              gipi_polbasic.iss_cd%TYPE,
      p_issue_yy                gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no              gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no                gipi_polbasic.renew_no%TYPE,
      p_pol_eff_date            gipi_polbasic.eff_date%TYPE,
      p_expiry_date             gipi_polbasic.expiry_date%TYPE,
      p_loss_date               gipi_polbasic.expiry_date%TYPE,
      p_incept_date             gipi_polbasic.incept_date%TYPE,
      p_item_no                 gipi_item.item_no%TYPE,
      p_claim_id                gicl_motor_car_dtl.claim_id%TYPE,
      p_from                    VARCHAR2,
      p_to                      VARCHAR2,
      c005             IN OUT   gicl_motor_car_dtl_cur,
      p_item_exist     OUT      NUMBER,
      p_override_fl    OUT      VARCHAR2,
      p_tloss_fl       OUT      VARCHAR2,
      p_item_exist2    OUT      VARCHAR2
   )
   IS
   BEGIN
      SELECT gicl_motor_car_dtl_pkg.check_motorcar_item_no (p_claim_id,
                                                            p_item_no,
                                                            p_from,
                                                            p_to
                                                           )
        INTO p_item_exist2
        FROM DUAL;

      SELECT giac_validate_user_fn (giis_users_pkg.app_user, 'TL', 'GICLS014') --kenneth SR 18895 07212015
        INTO p_override_fl
        FROM DUAL;

      SELECT gicl_motor_car_dtl_pkg.check_existing_item (p_line_cd,  --kenneth SR4855 100715
                                                p_subline_cd,
                                                p_pol_iss_cd,
                                                p_issue_yy,
                                                p_pol_seq_no,
                                                p_renew_no,
                                                p_pol_eff_date,
                                                p_expiry_date,
                                                p_loss_date,
                                                p_item_no
                                               )
        INTO p_item_exist
        FROM DUAL;

      SELECT check_total_loss_settlement2 (0,
                                           NULL,
                                           p_item_no,
                                           p_line_cd,
                                           p_subline_cd,
                                           p_pol_iss_cd,
                                           p_issue_yy,
                                           p_pol_seq_no,
                                           p_renew_no,
                                           p_loss_date,
                                           p_pol_eff_date,
                                           p_expiry_date
                                          )
        INTO p_tloss_fl
        FROM DUAL;

      OPEN c005 FOR
         SELECT *
           FROM TABLE
                   (gicl_motor_car_dtl_pkg.extract_latest_motordata
                                                              (p_line_cd,
                                                               p_subline_cd,
                                                               p_pol_iss_cd,
                                                               p_issue_yy,
                                                               p_pol_seq_no,
                                                               p_renew_no,
                                                               p_pol_eff_date,
                                                               p_expiry_date,
                                                               p_loss_date,
                                                               p_item_no
                                                              )
                   );
   END;

   FUNCTION check_motorcar_item_no (
      p_claim_id    gicl_motor_car_dtl.claim_id%TYPE,
      p_item_no     gicl_motor_car_dtl.item_no%TYPE,
      p_start_row   VARCHAR2,
      p_end_row     VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_exist   VARCHAR2 (1);
   BEGIN
      BEGIN
         SELECT 'Y'
           INTO v_exist
           FROM (SELECT ROWNUM rownum_, a.item_no item_no
                   FROM (SELECT item_no
                           FROM TABLE
                                   (gicl_motor_car_dtl_pkg.get_gicl_motor_car_dtl
                                                                   (p_claim_id)
                                   )) a)
          WHERE rownum_ NOT BETWEEN p_start_row AND p_end_row
            AND item_no = p_item_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_exist := 'N';
      END;

      RETURN v_exist;
   END;

   FUNCTION extract_latest_motordata (
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_subline_cd     gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd     gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       gipi_polbasic.renew_no%TYPE,
      p_pol_eff_date   gipi_polbasic.eff_date%TYPE,
      p_expiry_date    gipi_polbasic.expiry_date%TYPE,
      p_loss_date      gipi_polbasic.expiry_date%TYPE,
      p_item_no        gipi_item.item_no%TYPE
   )
      RETURN gicl_motor_car_dtl_tab PIPELINED
   IS
      v_motor_no          gicl_motor_car_dtl.motor_no%TYPE;
      v_item_title        gicl_motor_car_dtl.item_title%TYPE;
      v_item_desc         gipi_item.item_desc%TYPE;
      v_item_desc2        gipi_item.item_desc2%TYPE;
      v_color             gicl_motor_car_dtl.color%TYPE;
      v_color_cd          gicl_motor_car_dtl.color_cd%TYPE;
      v_basic_color_cd    gicl_motor_car_dtl.basic_color_cd%TYPE;
      v_serial_no         gipi_vehicle.serial_no%TYPE;
      v_mv_file_no        gicl_motor_car_dtl.mv_file_no%TYPE;
      v_currency_cd       gicl_motor_car_dtl.currency_cd%TYPE;
      v_currency_rate     gicl_motor_car_dtl.currency_rate%TYPE;
      v_make_cd           gicl_motor_car_dtl.make_cd%TYPE;
      v_plate_no          gicl_motor_car_dtl.plate_no%TYPE;
      v_model_year        gicl_motor_car_dtl.model_year%TYPE;
      v_motcar_comp_cd    gicl_motor_car_dtl.motcar_comp_cd%TYPE;
      v_subline_type_cd   gicl_motor_car_dtl.subline_type_cd%TYPE;
      v_max_endt_seq_no   gipi_polbasic.endt_seq_no%TYPE            := 0;
      v_mot_type          gicl_motor_car_dtl.mot_type%TYPE;
      v_series_cd         gicl_motor_car_dtl.series_cd%TYPE;
      v_towing            gicl_motor_car_dtl.towing%TYPE;
      v_no_of_pass        gicl_motor_car_dtl.no_of_pass%TYPE;
      v_assignee          gipi_vehicle.assignee%TYPE;
      v_mc_item           gicl_motor_car_dtl_type;
   BEGIN
      --first get info. from policy and all valid endt.
      FOR a1 IN (SELECT   endt_seq_no, b.item_title, c.motor_no, c.color,
                          c.color_cd, c.basic_color_cd, c.serial_no,
                          c.mv_file_no, b.currency_cd, c.make_cd, c.plate_no,
                          c.model_year, c.car_company_cd, c.subline_type_cd,
                          c.mot_type, c.series_cd,  -- added by Pia, 12.16.02
                                                  b.currency_rt, c.towing,
                          c.no_of_pass,              --added by beth 07012003
                                       b.item_desc, b.item_desc2,
                          
                          -- added by adrel 06292007
                          c.assignee               -- added by alvin 01112010
                     FROM gipi_polbasic a, gipi_item b, gipi_vehicle c
                    WHERE a.line_cd = p_line_cd
                      AND a.subline_cd = p_subline_cd
                      AND a.iss_cd = p_pol_iss_cd
                      AND a.issue_yy = p_issue_yy
                      AND a.pol_seq_no = p_pol_seq_no
                      AND a.renew_no = p_renew_no
                      AND a.pol_flag IN ('1', '2', '3', '4', 'X')    --kenneth SR 18895 07212015
                      --AND TRUNC(a.eff_date)   <= :cg$ctrl.loss_date
                      AND TRUNC (DECODE (TRUNC (a.eff_date),
                                         TRUNC (a.incept_date), p_pol_eff_date,
                                         a.eff_date
                                        )
                                ) <= TRUNC (p_loss_date)
                      AND TRUNC (DECODE (NVL (a.endt_expiry_date,
                                              a.expiry_date
                                             ),
                                         a.expiry_date, p_expiry_date,
                                         a.endt_expiry_date
                                        )
                                ) >= TRUNC (p_loss_date)
                      AND b.item_no = p_item_no
                      AND a.policy_id = b.policy_id
                      AND b.policy_id = c.policy_id
                      AND b.item_no = c.item_no
                 ORDER BY eff_date ASC)
      LOOP
         v_max_endt_seq_no := a1.endt_seq_no;
         v_item_title := NVL (a1.item_title, v_item_title);
         v_color := NVL (a1.color, v_color);
         v_color_cd := NVL (a1.color_cd, v_color_cd);
         v_basic_color_cd := NVL (a1.basic_color_cd, v_basic_color_cd);
         v_serial_no := NVL (a1.serial_no, v_serial_no);
         v_mv_file_no := NVL (a1.mv_file_no, v_mv_file_no);
         v_currency_cd := NVL (a1.currency_cd, v_currency_cd);
         v_currency_rate := NVL (a1.currency_rt, v_currency_rate);
         v_make_cd := NVL (a1.make_cd, v_make_cd);
         v_plate_no := NVL (a1.plate_no, v_plate_no);
         v_model_year := NVL (a1.model_year, v_model_year);
         v_motcar_comp_cd := NVL (a1.car_company_cd, v_motcar_comp_cd);
         v_subline_type_cd := NVL (a1.subline_type_cd, v_subline_type_cd);
         v_motor_no := NVL (a1.motor_no, v_motor_no);
         v_mot_type := NVL (a1.mot_type, v_mot_type);
         -- added by Pia, 12.16.02
         v_series_cd := NVL (a1.series_cd, v_series_cd);
                                                    -- added by Pia, 12.16.02
         --beth 07012003
         v_towing := NVL (a1.towing, v_towing);
         v_no_of_pass := NVL (a1.no_of_pass, v_no_of_pass);
         -- adrel 06292007
         v_item_desc := NVL (a1.item_desc, v_item_desc);
         v_item_desc2 := NVL (a1.item_desc2, v_item_desc2);
         v_assignee := NVL (a1.assignee, v_assignee);
      -- added by alvin 01112010
      END LOOP;

      --get info from backward endt. irwin done
      FOR a2 IN (SELECT   b.item_title, c.motor_no, c.color, c.color_cd,
                          c.basic_color_cd, c.serial_no, c.mv_file_no,
                          b.currency_cd, c.make_cd, c.plate_no, c.model_year,
                          c.car_company_cd, c.subline_type_cd, c.mot_type,
                          c.series_cd,               -- added by Pia, 12.16.02
                                      b.currency_rt, c.towing, c.no_of_pass,
                          
                          --added by beth 07012003
                          b.item_desc, b.item_desc2,
                          
                          -- added by adrel 06292007
                          c.assignee                -- added by alvin 01112010
                     FROM gipi_polbasic a, gipi_item b, gipi_vehicle c
                    WHERE a.line_cd = p_line_cd
                      AND a.subline_cd = p_subline_cd
                      AND a.iss_cd = p_pol_iss_cd
                      AND a.issue_yy = p_issue_yy
                      AND a.pol_seq_no = p_pol_seq_no
                      AND a.renew_no = p_renew_no
                      AND a.pol_flag IN ('1', '2', '3', '4', 'X')    --kenneth SR 18895 07212015
                      AND NVL (a.back_stat, 5) = 2
                      AND endt_seq_no > v_max_endt_seq_no
                      --AND TRUNC(a.eff_date)   <= :cg$ctrl.loss_date
                      AND TRUNC (DECODE (TRUNC (a.eff_date),
                                         TRUNC (a.incept_date), p_pol_eff_date,
                                         a.eff_date
                                        )
                                ) <= TRUNC (p_loss_date)
                      AND TRUNC (DECODE (NVL (a.endt_expiry_date,
                                              a.expiry_date
                                             ),
                                         a.expiry_date, p_expiry_date,
                                         a.endt_expiry_date
                                        )
                                ) >= TRUNC (p_loss_date)
                      AND b.item_no = p_item_no
                      AND a.policy_id = b.policy_id
                      AND b.policy_id = c.policy_id
                      AND b.item_no = c.item_no
                 ORDER BY endt_seq_no ASC)
      LOOP
         v_item_title := NVL (a2.item_title, v_item_title);
         v_color := NVL (a2.color, v_color);
         v_color_cd := NVL (a2.color_cd, v_color_cd);
         v_basic_color_cd := NVL (a2.basic_color_cd, v_basic_color_cd);
         v_serial_no := NVL (a2.serial_no, v_serial_no);
         v_mv_file_no := NVL (a2.mv_file_no, v_mv_file_no);
         v_currency_cd := NVL (a2.currency_cd, v_currency_cd);
         v_currency_rate := NVL (a2.currency_rt, v_currency_rate);
         v_make_cd := NVL (a2.make_cd, v_make_cd);
         v_plate_no := NVL (a2.plate_no, v_plate_no);
         v_model_year := NVL (a2.model_year, v_model_year);
         v_motcar_comp_cd := NVL (a2.car_company_cd, v_motcar_comp_cd);
         v_subline_type_cd := NVL (a2.subline_type_cd, v_subline_type_cd);
         v_motor_no := NVL (a2.motor_no, v_motor_no);
         v_mot_type := NVL (a2.mot_type, v_mot_type);
         -- added by Pia, 12.16.02
         v_series_cd := NVL (a2.series_cd, v_series_cd);
                                                    -- added by Pia, 12.16.02
         --beth 07012003
         v_towing := NVL (a2.towing, v_towing);
         v_no_of_pass := NVL (a2.no_of_pass, v_no_of_pass);
         -- adrel 06292007
         v_item_desc := NVL (a2.item_desc, v_item_desc);
         v_item_desc2 := NVL (a2.item_desc2, v_item_desc2);
         v_assignee := NVL (a2.assignee, v_assignee);
      -- added by alvin 01112010
      END LOOP;

      -- assigns to main type
      v_mc_item.item_no := p_item_no;
      v_mc_item.item_title := v_item_title;
      v_mc_item.color := v_color;
      v_mc_item.color_cd := v_color_cd;
      v_mc_item.basic_color_cd := v_basic_color_cd;
      v_mc_item.serial_no := v_serial_no;
      v_mc_item.mv_file_no := v_mv_file_no;
      v_mc_item.currency_cd := v_currency_cd;
      v_mc_item.currency_rate := v_currency_rate;
      v_mc_item.make_cd := v_make_cd;
      v_mc_item.plate_no := v_plate_no;
      v_mc_item.model_year := v_model_year;
      v_mc_item.motcar_comp_cd := v_motcar_comp_cd;
      v_mc_item.subline_type_cd := v_subline_type_cd;
      v_mc_item.motor_no := v_motor_no;
      --v_mc_item.claim_id        := :cg$ctrl.claim_id;
      v_mc_item.mot_type := v_mot_type;
      v_mc_item.series_cd := v_series_cd;
      v_mc_item.towing := v_towing;
      v_mc_item.no_of_pass := v_no_of_pass;
      v_mc_item.item_desc := v_item_desc;
      v_mc_item.item_desc2 := v_item_desc2;
      v_mc_item.assignee := v_assignee;

      --get car company desc
      FOR a IN (SELECT car_company
                  FROM giis_mc_car_company
                 WHERE car_company_cd = v_mc_item.motcar_comp_cd)
      LOOP
         v_mc_item.motcar_comp_desc := a.car_company;
         EXIT;
      END LOOP;

      --get subline type desc.
      v_mc_item.subline_type_desc := '-';

      FOR b IN (SELECT subline_type_desc
                  FROM giis_mc_subline_type
                 WHERE subline_type_cd = v_mc_item.subline_type_cd)
      LOOP
         v_mc_item.subline_type_desc := b.subline_type_desc;
         EXIT;
      END LOOP;

      --get make
      FOR c IN (SELECT make
                  FROM giis_mc_make
                 WHERE make_cd = v_mc_item.make_cd
                   AND car_company_cd = v_mc_item.motcar_comp_cd)
      LOOP
         v_mc_item.make_desc := c.make;
         EXIT;
      END LOOP;

      --get basic color
      FOR d IN (SELECT basic_color
                  FROM giis_mc_color
                 WHERE basic_color_cd = v_mc_item.basic_color_cd
                   AND color_cd = v_mc_item.color_cd)
      LOOP
         v_mc_item.basic_color := d.basic_color;
         EXIT;
      END LOOP;

      --get currency desc
      FOR e IN (SELECT currency_desc
                  FROM giis_currency
                 WHERE main_currency_cd = v_mc_item.currency_cd)
      LOOP
         v_mc_item.dsp_currency_desc := e.currency_desc;
         EXIT;
      END LOOP;

      v_mc_item.loss_date := p_loss_date;

      -- get mot_type desc,
      FOR mot_type IN (SELECT motor_type_desc des
                         FROM giis_motortype
                        WHERE type_cd = v_mc_item.mot_type)
      LOOP
         v_mc_item.mot_type_desc := mot_type.des;
         EXIT;
      END LOOP;

      -- get engine series
      IF v_mc_item.series_cd IS NOT NULL
      THEN
         FOR eng IN (SELECT engine_series series
                       FROM giis_mc_eng_series
                      WHERE series_cd = v_mc_item.series_cd)
         LOOP
            v_mc_item.engine_series := eng.series;
            EXIT;
         END LOOP;
      END IF;

      PIPE ROW (v_mc_item);
   END;

    /*
   **  Created by    : Irwin Tabisora
   **  Date Created  : 09.22.2011
   **  Reference By  : (GICLS014 - Motorcar Item Information)
   **  Description   : Deletes record in GICL_MOTOR_CAR_DTL
   */
   PROCEDURE del_gicl_motor_car_dtl (
      p_claim_id   gicl_motor_car_dtl.claim_id%TYPE,
      p_item_no    gicl_motor_car_dtl.item_no%TYPE
   )
   IS
   BEGIN
      DELETE FROM gicl_motor_car_dtl
            WHERE claim_id = p_claim_id AND item_no = p_item_no;
   END;

   PROCEDURE set_gicl_motor_car_dtl (
      p_claim_id          gicl_motor_car_dtl.claim_id%TYPE,
      p_item_no           gicl_motor_car_dtl.item_no%TYPE,
      p_motor_no          gicl_motor_car_dtl.motor_no%TYPE,
      p_item_title        gicl_motor_car_dtl.item_title%TYPE,
      p_model_year        gicl_motor_car_dtl.model_year%TYPE,
      p_plate_no          gicl_motor_car_dtl.plate_no%TYPE,
      p_drvr_occ_cd       gicl_motor_car_dtl.drvr_occ_cd%TYPE,
      p_drvr_name         gicl_motor_car_dtl.drvr_name%TYPE,
      p_drvr_sex          gicl_motor_car_dtl.drvr_sex%TYPE,
      p_drvr_age          gicl_motor_car_dtl.drvr_age%TYPE,
      p_motcar_comp_cd    gicl_motor_car_dtl.motcar_comp_cd%TYPE,
      p_make_cd           gicl_motor_car_dtl.make_cd%TYPE,
      p_color             gicl_motor_car_dtl.color%TYPE,
      p_subline_type_cd   gicl_motor_car_dtl.subline_type_cd%TYPE,
      p_basic_color_cd    gicl_motor_car_dtl.basic_color_cd%TYPE,
      p_color_cd          gicl_motor_car_dtl.color_cd%TYPE,
      p_serial_no         gicl_motor_car_dtl.serial_no%TYPE,
      p_currency_cd       gicl_motor_car_dtl.currency_cd%TYPE,
      p_mot_type          gicl_motor_car_dtl.mot_type%TYPE,
      p_series_cd         gicl_motor_car_dtl.series_cd%TYPE,
      p_currency_rate     gicl_motor_car_dtl.currency_rate%TYPE,
      p_no_of_pass        gicl_motor_car_dtl.no_of_pass%TYPE,
      p_towing            gicl_motor_car_dtl.towing%TYPE,
      p_drvr_add          gicl_motor_car_dtl.drvr_add%TYPE,
      p_other_info        gicl_motor_car_dtl.other_info%TYPE,
      p_drvng_exp         gicl_motor_car_dtl.drvng_exp%TYPE,
      p_nationality_cd    gicl_motor_car_dtl.nationality_cd%TYPE,
      p_relation          gicl_motor_car_dtl.relation%TYPE,
      p_assignee          gicl_motor_car_dtl.assignee%TYPE,
      p_item_desc         gicl_clm_item.item_desc%TYPE,
      p_item_desc2        gicl_clm_item.item_desc2%TYPE,
      p_mv_file_no        gicl_motor_car_dtl.mv_file_no%TYPE,
      p_cpi_rec_no        gicl_fire_dtl.cpi_rec_no%TYPE,
      p_cpi_branch_cd     gicl_fire_dtl.cpi_branch_cd%TYPE
   )
   IS
      v_loss_date   gicl_claims.dsp_loss_date%TYPE;
   BEGIN
      FOR date1 IN (SELECT dsp_loss_date
                      FROM gicl_claims
                     WHERE claim_id = p_claim_id)
      LOOP
         v_loss_date := date1.dsp_loss_date;
      END LOOP;

      MERGE INTO gicl_motor_car_dtl
         USING DUAL
         ON (claim_id = p_claim_id AND item_no = p_item_no)
         WHEN NOT MATCHED THEN
            INSERT (claim_id, item_no, motor_no, item_title, model_year,
                    plate_no, drvr_occ_cd, drvr_sex, drvr_age, motcar_comp_cd,
                    make_cd, color, subline_type_cd, basic_color_cd, color_cd,
                    serial_no, loss_date, currency_cd, mot_type, series_cd,
                    currency_rate, no_of_pass, towing, drvr_add, other_info,
                    drvng_exp, nationality_cd, relation, assignee, mv_file_no,
                    user_id, last_update, cpi_rec_no, cpi_branch_cd,
                    drvr_name)
            VALUES (p_claim_id, p_item_no, p_motor_no, p_item_title,
                    p_model_year, p_plate_no, p_drvr_occ_cd, p_drvr_sex,
                    p_drvr_age, p_motcar_comp_cd, p_make_cd, p_color,
                    p_subline_type_cd, p_basic_color_cd, p_color_cd,
                    p_serial_no, v_loss_date, p_currency_cd, p_mot_type,
                    p_series_cd, p_currency_rate, p_no_of_pass, p_towing,
                    p_drvr_add, p_other_info, p_drvng_exp, p_nationality_cd,
                    p_relation, p_assignee, p_mv_file_no,
                    giis_users_pkg.app_user, SYSDATE, p_cpi_rec_no,
                    p_cpi_branch_cd, p_drvr_name)
         WHEN MATCHED THEN
            UPDATE
               SET motor_no = p_motor_no, item_title = p_item_title,
                   model_year = p_model_year, plate_no = p_plate_no,
                   drvr_occ_cd = p_drvr_occ_cd, drvr_sex = p_drvr_sex,
                   drvr_age = p_drvr_age, motcar_comp_cd = p_motcar_comp_cd,
                   make_cd = p_make_cd, color = p_color,
                   subline_type_cd = p_subline_type_cd,
                   basic_color_cd = p_basic_color_cd, color_cd = p_color_cd,
                   serial_no = p_serial_no, loss_date = v_loss_date,
                   currency_cd = p_currency_cd, mot_type = p_mot_type,
                   series_cd = p_series_cd, currency_rate = p_currency_rate,
                   no_of_pass = p_no_of_pass, towing = p_towing,
                   drvr_add = p_drvr_add, other_info = p_other_info,
                   drvng_exp = p_drvng_exp, nationality_cd = p_nationality_cd,
                   relation = p_relation, assignee = p_assignee,
                   mv_file_no = p_mv_file_no,
                   user_id = giis_users_pkg.app_user, last_update = SYSDATE,
                   cpi_rec_no = p_cpi_rec_no, cpi_branch_cd = p_cpi_branch_cd,
                   drvr_name = p_drvr_name
            ;
   END;

   FUNCTION get_gicls070_vehicle_info (
      p_claim_id     gicl_motor_car_dtl.claim_id%TYPE,
      p_subline_cd   gicl_claims.subline_cd%TYPE
   )
      RETURN vehicle_info_tab PIPELINED
   IS
      v_dtl   vehicle_info_type;
   BEGIN
      FOR i IN (SELECT a.claim_id, a.item_no, a.plate_no, a.model_year,
                       a.serial_no, a.motor_no, a.mot_type, a.make_cd,
                       a.series_cd, a.basic_color_cd, a.color_cd,
                       a.drvr_occ_cd, a.drvr_name, a.drvr_age, a.drvr_sex,
                       a.other_info, a.last_update, a.drvr_add, a.drvng_exp,
                       a.nationality_cd, a.user_id
                  FROM gicl_motor_car_dtl a
                 WHERE a.claim_id = p_claim_id)
      LOOP
         v_dtl.claim_id := i.claim_id;
         v_dtl.item_no := i.item_no;
         v_dtl.plate_no := i.plate_no;
         v_dtl.model_year := i.model_year;
         v_dtl.serial_no := i.serial_no;
         v_dtl.motor_no := i.motor_no;
         v_dtl.mot_type := i.mot_type;                       --v_dtl.mot_type
         v_dtl.make_cd := i.make_cd;
         v_dtl.series_cd := i.series_cd;
         v_dtl.basic_color_cd := i.basic_color_cd;
         v_dtl.color_cd := i.color_cd;
         v_dtl.drvr_occ_cd := i.drvr_occ_cd;
         v_dtl.drvr_name := i.drvr_name;
         v_dtl.drvr_age := i.drvr_age;
         v_dtl.drvr_sex := i.drvr_sex;
         v_dtl.other_info := i.other_info;
         v_dtl.user_id := i.user_id;
         v_dtl.last_update := i.last_update;
         v_dtl.drvr_add := i.drvr_add;

         BEGIN
            SELECT a.motcar_comp_cd, b.car_company        --b.motcar_comp_desc
              INTO v_dtl.motorcar_comp_cd, v_dtl.car_com_desc
              FROM gicl_motor_car_dtl a,
                   giis_mc_car_company b                  --gicl_motcar_comp b
             WHERE 1 = 1
               AND a.motcar_comp_cd = b.car_company_cd      --b.motcar_comp_cd
               AND claim_id = p_claim_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_dtl.motorcar_comp_cd := NULL;
               v_dtl.car_com_desc := NULL;
            WHEN TOO_MANY_ROWS
            THEN
               raise_application_error ('-20001',
                                        'error in retrieving company cd'
                                       );
         END;

         --motor type
         BEGIN
            SELECT motor_type_desc
              INTO v_dtl.motor_type_desc
              FROM giis_motortype
             WHERE type_cd = i.mot_type AND subline_cd = p_subline_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_dtl.motor_type_desc := NULL;
            WHEN TOO_MANY_ROWS
            THEN
               raise_application_error ('-20001',
                                        'err in retreiving motor_type_desc'
                                       );
         END;

         --color
         BEGIN
            SELECT basic_color, color
              INTO v_dtl.basic_color_desc, v_dtl.color_desc
              FROM giis_mc_color
             WHERE basic_color_cd = i.basic_color_cd AND color_cd = i.color_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_dtl.basic_color_desc := NULL;
               v_dtl.color_desc := NULL;
            WHEN TOO_MANY_ROWS
            THEN
               raise_application_error
                                   ('-20001',
                                    'err in retrieving basic color and color'
                                   );
         END;

         --make
         BEGIN
            SELECT make
              INTO v_dtl.make_desc
              FROM giis_mc_make
             WHERE 1 = 1
               AND make_cd = i.make_cd
               AND car_company_cd = v_dtl.motorcar_comp_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_dtl.make_desc := NULL;
            WHEN TOO_MANY_ROWS
            THEN
               raise_application_error ('-20001', 'err in retrieving make');
         END;

         --series
         BEGIN
            SELECT engine_series
              INTO v_dtl.engine_series
              FROM giis_mc_eng_series
             WHERE 1 = 1
               AND make_cd = i.make_cd
               AND series_cd = i.series_cd
               AND car_company_cd = v_dtl.motorcar_comp_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_dtl.engine_series := NULL;
            WHEN TOO_MANY_ROWS
            THEN
               raise_application_error ('-20001',
                                        'err in retrieving eng series'
                                       );
         END;

         BEGIN
            SELECT occ_desc
              INTO v_dtl.drvr_occ_desc
              FROM gicl_drvr_occptn
             WHERE drvr_occ_cd = i.drvr_occ_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_dtl.drvr_occ_desc := NULL;
            WHEN TOO_MANY_ROWS
            THEN
               raise_application_error ('-20001',
                                        'err in retrieving occupation'
                                       );
         END;

         PIPE ROW (v_dtl);
      END LOOP;
   END;
   
   /*
   **  Created by    : Veronica V. Raymundo
   **  Date Created  : 04.17.2013
   **  Reference By  : GICLS260 - Claim Information
   **  Description   : Gets gicl_motor_car_dtl records of the given claim_id
   */
   FUNCTION get_gicls260_motor_car_dtl (
      p_claim_id   gicl_motor_car_dtl.claim_id%TYPE
   )
      RETURN gicl_motor_car_dtl_tab PIPELINED
   IS
      v_mc_item   gicl_motor_car_dtl_type;
   BEGIN
      FOR i IN (SELECT a.claim_id,        a.item_no,         a.motor_no,        
					   a.user_id,         a.last_update,     a.item_title,      
					   a.model_year,      a.plate_no,        a.drvr_occ_cd,     
					   a.drvr_name,       a.drvr_sex,        a.drvr_age,        
					   a.motcar_comp_cd,  a.make_cd,         a.color,           
					   a.subline_type_cd, a.cpi_rec_no,      a.cpi_branch_cd,   
					   a.basic_color_cd,  a.color_cd,        a.serial_no,       
					   a.loss_date,       a.currency_cd,     a.mv_file_no,      
					   a.mot_type,        a.series_cd,       a.currency_rate,   
					   a.no_of_pass,      a.towing,          a.drvr_add,         
					   a.other_info,      a.drvng_exp,       a.nationality_cd,  
					   a.relation,        a.assignee
				FROM GICL_MOTOR_CAR_DTL a
				WHERE claim_id = p_claim_id )
      LOOP
         v_mc_item.claim_id 		:= i.claim_id;
         v_mc_item.item_no 			:= i.item_no;
         v_mc_item.motor_no 		:= i.motor_no;
         v_mc_item.user_id 			:= i.user_id;
         v_mc_item.item_title 		:= i.item_title;
         v_mc_item.model_year 		:= i.model_year;
         v_mc_item.plate_no 		:= i.plate_no;
         v_mc_item.drvr_occ_cd 		:= i.drvr_occ_cd;
         v_mc_item.drvr_name 		:= i.drvr_name;
         v_mc_item.drvr_sex 		:= i.drvr_sex;
         v_mc_item.drvr_age 		:= i.drvr_age;
         v_mc_item.motcar_comp_cd 	:= i.motcar_comp_cd;
         v_mc_item.make_cd 			:= i.make_cd;
         v_mc_item.color 			:= i.color;
         v_mc_item.subline_type_cd 	:= i.subline_type_cd;
         v_mc_item.basic_color_cd 	:= i.basic_color_cd;
         v_mc_item.color_cd 		:= i.color_cd;
         v_mc_item.serial_no 		:= i.serial_no;
         v_mc_item.loss_date 		:= TO_CHAR (i.loss_date, 'MM-DD-YYYY');
         v_mc_item.currency_cd 		:= i.currency_cd;
         v_mc_item.mot_type 		:= i.mot_type;
         v_mc_item.series_cd 		:= i.series_cd;
         v_mc_item.currency_rate 	:= i.currency_rate;
         v_mc_item.no_of_pass 		:= i.no_of_pass;
         v_mc_item.towing 			:= i.towing;
         v_mc_item.drvr_add 		:= i.drvr_add;
         v_mc_item.other_info 		:= i.other_info;
         v_mc_item.drvng_exp 		:= i.drvng_exp;
         v_mc_item.nationality_cd 	:= i.nationality_cd;
         v_mc_item.relation 		:= i.relation;
         v_mc_item.assignee 		:= i.assignee;
         v_mc_item.last_update 		:= i.last_update;
         v_mc_item.mv_file_no 		:= i.mv_file_no;
         v_mc_item.cpi_rec_no 		:= i.cpi_rec_no;
         v_mc_item.cpi_branch_cd 	:= i.cpi_branch_cd;

         BEGIN
            SELECT item_desc, item_desc2
              INTO v_mc_item.item_desc, v_mc_item.item_desc2
              FROM gicl_clm_item
             WHERE 1 = 1
               AND claim_id = p_claim_id
               AND item_no = v_mc_item.item_no
               AND grouped_item_no = 0;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_mc_item.item_desc := NULL;
               v_mc_item.item_desc2 := NULL;
         END;

         FOR c IN (SELECT currency_desc
                     FROM giis_currency
                    WHERE main_currency_cd = v_mc_item.currency_cd)
         LOOP
            v_mc_item.dsp_currency_desc := c.currency_desc;
         END LOOP;

         FOR a IN (SELECT car_company
                     FROM giis_mc_car_company
                    WHERE car_company_cd = v_mc_item.motcar_comp_cd)
         LOOP
            v_mc_item.motcar_comp_desc := a.car_company;
         END LOOP;

         FOR b IN (SELECT subline_type_desc
                     FROM giis_mc_subline_type
                    WHERE subline_type_cd = v_mc_item.subline_type_cd)
         LOOP
            v_mc_item.subline_type_desc := b.subline_type_desc;
         END LOOP;

		 --get make
         FOR c IN (SELECT make
                     FROM giis_mc_make
                    WHERE make_cd = v_mc_item.make_cd
                      AND car_company_cd = v_mc_item.motcar_comp_cd)
         LOOP
            v_mc_item.make_desc := c.make;
         END LOOP;

         --get basic color
         FOR d IN (SELECT basic_color
                     FROM giis_mc_color
                    WHERE basic_color_cd = v_mc_item.basic_color_cd
                      AND color_cd = NVL (v_mc_item.color_cd, color_cd))
         LOOP
            v_mc_item.basic_color := d.basic_color;
         END LOOP;

         -- get mot_type desc
         FOR mot_type IN (SELECT motor_type_desc des
                            FROM giis_motortype
                           WHERE type_cd = v_mc_item.mot_type)
         LOOP
            v_mc_item.mot_type_desc := mot_type.des;
         END LOOP;

         -- get engine series
         FOR eng IN (SELECT engine_series series
                       FROM giis_mc_eng_series
                      WHERE series_cd = v_mc_item.series_cd)
         LOOP
            v_mc_item.engine_series := eng.series;
            EXIT;
         END LOOP;

         -- driver desc
         FOR d IN (SELECT occ_desc
                     FROM gicl_drvr_occptn
                    WHERE drvr_occ_cd LIKE v_mc_item.drvr_occ_cd)
         LOOP
            v_mc_item.drvr_occ_desc := d.occ_desc;
         END LOOP;

         FOR n IN (SELECT nationality_desc
                     FROM giis_nationality
                    WHERE nationality_cd LIKE v_mc_item.nationality_cd)
         LOOP
            v_mc_item.nationality_desc := n.nationality_desc;
         END LOOP;

         SELECT gicl_item_peril_pkg.get_gicl_item_peril_exist
                                                           (v_mc_item.item_no,
                                                            v_mc_item.claim_id
                                                           )
           INTO v_mc_item.gicl_item_peril_exist
           FROM DUAL;

         SELECT gicl_mortgagee_pkg.get_gicl_mortgagee_exist
                                                           (v_mc_item.item_no,
                                                            v_mc_item.claim_id
                                                           )
           INTO v_mc_item.gicl_mortgagee_exist
           FROM DUAL;

         gicl_item_peril_pkg.validate_peril_reserve
                                         (v_mc_item.item_no,
                                          v_mc_item.claim_id,
                                          0,
                                          v_mc_item.gicl_item_peril_msg
                                         );
         PIPE ROW (v_mc_item);
      END LOOP;
   END;
   
   --kenneth SR4855 10072015
   FUNCTION get_item_no_list_mc (
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_subline_cd     gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd     gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       gipi_polbasic.renew_no%TYPE,
      p_loss_date      gipi_polbasic.expiry_date%TYPE,
      p_pol_eff_date   gipi_polbasic.eff_date%TYPE,
      p_expiry_date    gipi_polbasic.expiry_date%TYPE,
      p_claim_id       gicl_claims.claim_id%TYPE,
      p_find_text      varchar2
   )
      RETURN gipi_item_tab PIPELINED
   IS
      v_list   gipi_item_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT b.item_no,
                get_latest_item_title2 (P_line_cd,
                                       P_subline_cd,
                                       P_pol_iss_cd,
                                       P_issue_yy,
                                       P_pol_seq_no,
                                       P_renew_no,
                                       item_no,
                                       P_loss_date,
                                       P_pol_eff_date,
                                       P_expiry_date
                                      ) item_title
           FROM gipi_item b
          WHERE 1 = 1
            AND EXISTS (
                   SELECT 1
                     FROM gipi_polbasic
                    WHERE line_cd = P_line_cd
                      AND subline_cd = P_subline_cd
                      AND iss_cd = P_pol_iss_cd
                      AND issue_yy = P_issue_yy
                      AND pol_seq_no = P_pol_seq_no
                      AND renew_no = P_renew_no
                      AND pol_flag IN ('1', '2', '3', '4', 'X')
                      AND TRUNC (DECODE (TRUNC (eff_date),
                                         TRUNC (incept_date), P_pol_eff_date,
                                         eff_date
                                        )
                                ) <= TRUNC (P_loss_date)
                      AND TRUNC (DECODE (NVL (endt_expiry_date, expiry_date),
                                         expiry_date, P_expiry_date,
                                         endt_expiry_date
                                        )
                                ) >= TRUNC (P_loss_date)
                      AND policy_id = b.policy_id)
            AND NOT EXISTS (
                      SELECT 1
                        FROM gicl_motor_car_dtl
                       WHERE claim_id = P_claim_id
                             AND item_no = b.item_no)
            AND EXISTS (
                   SELECT 1
                     FROM gipi_vehicle c
                    WHERE item_no = b.item_no
                      AND policy_id = b.policy_id
                      AND EXISTS (
                             SELECT 1
                               FROM gicl_claims
                              WHERE claim_id = P_claim_id
                                AND NVL (plate_no, '*^&!') =
                                       DECODE (plate_no,
                                               NULL, NVL (plate_no, '*^&!'),
                                               c.plate_no
                                              )))AND (UPPER (item_title) LIKE
                                                    NVL (UPPER (p_find_text), '%%')
                                                     OR item_no LIKE NVL(p_find_text,'%%'))
                                                )
      LOOP
         v_list.item_no := i.item_no;
         v_list.item_title := i.item_title;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;
   
   --kenneth SR4855 10072015
   FUNCTION check_existing_item (
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_subline_cd     gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd     gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       gipi_polbasic.renew_no%TYPE,
      p_pol_eff_date   gipi_polbasic.eff_date%TYPE,
      p_expiry_date    gipi_polbasic.expiry_date%TYPE,
      p_loss_date      gipi_polbasic.expiry_date%TYPE,
      p_item_no        gipi_item.item_no%TYPE
   )
      RETURN NUMBER
   IS
      v_exist   NUMBER := 0;
   BEGIN
      FOR h IN
         (SELECT c.item_no
            FROM gipi_item c, gipi_polbasic b
           WHERE                   --:control.claim_id = :global.claim_id AND
                 p_line_cd = b.line_cd
             AND p_subline_cd = b.subline_cd
             AND p_pol_iss_cd = b.iss_cd
             AND p_issue_yy = b.issue_yy
             AND p_pol_seq_no = b.pol_seq_no
             AND p_renew_no = b.renew_no
             AND b.policy_id = c.policy_id
             AND b.pol_flag IN ('1', '2', '3', '4', 'X')
             AND TRUNC (DECODE (TRUNC (b.eff_date),
                                TRUNC (b.incept_date), p_pol_eff_date,
                                b.eff_date
                               )
                       ) <= p_loss_date
             --AND TRUNC(b.eff_date) <= :control.loss_date
             AND TRUNC (DECODE (NVL (b.endt_expiry_date, b.expiry_date),
                                b.expiry_date, p_expiry_date,
                                b.endt_expiry_date
                               )
                       ) >= p_loss_date
             AND c.item_no = p_item_no)
      LOOP
         v_exist := 1;
      END LOOP;

      RETURN v_exist;
   END;
   
END gicl_motor_car_dtl_pkg;
/
