CREATE OR REPLACE PACKAGE BODY CPI.GICL_NO_CLAIM_MULTI_PKG
AS
   /**
   * Rey Jadlocon
   * 09-12-2011
   **/
   /* Formatted on 2011/12/09 11:23 (Formatter Plus v4.8.8) */
   FUNCTION get_no_clm_id
      RETURN NUMBER
   IS
      v_no_claim_id   gicl_no_claim_multi.no_claim_id%TYPE;
   BEGIN
      BEGIN
         SELECT NVL (MAX (NVL (no_claim_id, 0)), 0) + 1
           INTO v_no_claim_id
           FROM gicl_no_claim_multi;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_no_claim_id := 1;
      END;

      RETURN v_no_claim_id;
   END;

   FUNCTION get_no_claim_multi_yy(p_user_id VARCHAR2)
      RETURN get_no_claim_multi_yy_tab
      PIPELINED
   IS
      v_no_claim_multi_yy   get_no_claim_multi_yy_type;
    BEGIN
       FOR i IN
          (SELECT DISTINCT    a.nc_iss_cd
                           || ' - '
                           || a.nc_issue_yy
                           || ' - '
                           || LTRIM (RTRIM (TO_CHAR (a.nc_seq_no, '0000009')))
                                                                      no_claim_no,
                           a.nc_iss_cd, a.nc_issue_yy, a.nc_seq_no, a.assd_no,
                           a.basic_color_cd, a.cancel_tag, a.color_cd,
                           a.last_update, a.make_cd, a.model_year,
                           a.motcar_comp_cd, a.motor_no, a.nc_issue_date,
                           a.no_claim_id, a.no_issue_date, a.plate_no, a.remarks,
                           a.serial_no
                      FROM gicl_no_claim_multi a
                     WHERE 1 = 1
                       AND (SELECT COUNT (*)
                              FROM TABLE
                                      (gicl_no_claim_multi_pkg.get_claim_multi_policy_list
                                                                       (a.plate_no,
                                                                        a.serial_no,
                                                                        a.motor_no,
                                                                        p_user_id
                                                                       )
                                      )) > 1
    --                ; AND (SELECT COUNT (*)
    --                        FROM TABLE (gicl_no_claim_multi_pkg.get_plate_grp_lov (a.assd_no))) > 1
                 --OR a.nc_iss_cd LIKE NVL(p_nc_iss_cd,a.nc_iss_cd)
                 --OR a.nc_issue_yy LIKE NVL(p_nc_issue_yy,a.nc_issue_yy)
                 --OR a.nc_seq_no LIKE NVL(p_nc_seq_no,a.nc_seq_no)
           ORDER BY        no_claim_no ASC)
       LOOP
          v_no_claim_multi_yy.no_claim_no := i.no_claim_no;
          v_no_claim_multi_yy.nc_iss_cd := i.nc_iss_cd;
          v_no_claim_multi_yy.nc_issue_yy := i.nc_issue_yy;
          v_no_claim_multi_yy.nc_seq_no := i.nc_seq_no;
          v_no_claim_multi_yy.basic_color_cd := i.basic_color_cd;
          v_no_claim_multi_yy.cancel_tag := i.cancel_tag;
          v_no_claim_multi_yy.color_cd := i.color_cd;
          v_no_claim_multi_yy.last_update := i.last_update;
          v_no_claim_multi_yy.make_cd := i.make_cd;
          v_no_claim_multi_yy.model_year := i.model_year;
          v_no_claim_multi_yy.motcar_comp_cd := i.motcar_comp_cd;
          v_no_claim_multi_yy.motor_no := i.motor_no;
          v_no_claim_multi_yy.nc_issue_date := i.nc_issue_date;
          v_no_claim_multi_yy.no_claim_id := i.no_claim_id;
          v_no_claim_multi_yy.no_issue_date := i.no_issue_date;
          v_no_claim_multi_yy.plate_no := i.plate_no;
          v_no_claim_multi_yy.remarks := i.remarks;
          v_no_claim_multi_yy.serial_no := i.serial_no;
          v_no_claim_multi_yy.assd_no := i.assd_no;

          /* Replaced by Christian 12/10/2012
          FOR w IN (SELECT assd_name
                      FROM giis_assured
                     WHERE assd_no = i.assd_no --OR assd_name LIKE NVL(p_assd_name,assd_name))
                                              )
          LOOP
             v_no_claim_multi_yy.assd_name := w.assd_name;
          END LOOP; */
          BEGIN
             SELECT assd_name
               INTO v_no_claim_multi_yy.assd_name
               FROM giis_assured
              WHERE assd_no = i.assd_no;
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                v_no_claim_multi_yy.assd_name := '';
          END;

          /* Replaced by Christian 12/10/2012
          FOR l IN (SELECT DISTINCT b.basic_color
                      FROM gipi_vehicle a, giis_mc_color b
                     WHERE b.basic_color_cd = i.basic_color_cd)
          LOOP
             v_no_claim_multi_yy.basic_color := l.basic_color;
          END LOOP;
          */
          BEGIN
             SELECT basic_color, color_cd
               INTO v_no_claim_multi_yy.basic_color, v_no_claim_multi_yy.color
               FROM giis_mc_color
              WHERE color_cd = i.color_cd AND basic_color_cd = i.basic_color_cd;
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                v_no_claim_multi_yy.basic_color := '';
                v_no_claim_multi_yy.color := '';
          END;

          /*FOR d
             IN (SELECT DISTINCT b.car_company_cd car_company_cd,
                                 b.make_cd make_cd,
                                 c.car_company car_company,
                                 b.model_year model_year,
                                 b.make make,
                                 b.basic_color_cd basic_color_cd,
                                 b.color_cd color_cd,
                                 b.color color
                   FROM gipi_vehicle b, giis_mc_car_company c
                  WHERE     b.car_company_cd = c.car_company_cd
                        AND b.plate_no = i.plate_no
                        AND b.serial_no = i.serial_no
                        AND b.motor_no = i.motor_no)
          LOOP
             v_no_claim_multi_yy.make := d.make;
             v_no_claim_multi_yy.color := d.color;
          END LOOP;

          FOR k IN (SELECT DISTINCT a.car_company
                      FROM giis_mc_car_company a
                     WHERE a.car_company_cd = i.motcar_comp_cd)
          LOOP
             v_no_claim_multi_yy.car_company := k.car_company;
          END LOOP;*/ -- replaced by: Nica 04.26.2013

          --make
          BEGIN
             SELECT DECODE (i.model_year,
                            NULL, make,
                            i.model_year || ' ' || make
                           ) make
               INTO v_no_claim_multi_yy.make
               FROM giis_mc_make
              WHERE make_cd = i.make_cd AND car_company_cd = i.motcar_comp_cd;
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                v_no_claim_multi_yy.make := i.model_year;
          END;

          --car_company
          BEGIN
             SELECT a.car_company
               INTO v_no_claim_multi_yy.car_company
               FROM giis_mc_car_company a
              WHERE a.car_company_cd = i.motcar_comp_cd;
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                v_no_claim_multi_yy.car_company := NULL;
          END;

          PIPE ROW (v_no_claim_multi_yy);
       END LOOP;

       RETURN;
    END;

   /**
   * Rey Jadlocon
   * 14-12-2011
   **/
   FUNCTION get_no_claim_details_multi_yy (
	  p_no_claim_id    gicl_no_claim_multi.no_claim_id%TYPE)
      RETURN get_no_claim_multi_yy_tab
      PIPELINED
   IS
      v_no_claim_details_multi_yy   get_no_claim_multi_yy_type;
   BEGIN
      FOR i
         IN (SELECT DISTINCT
                       a.nc_iss_cd
                    || ' - '
                    || a.nc_issue_yy
                    || ' - '
                    || TO_CHAR (a.nc_seq_no, '0000009')
                       no_claim_no,
                    a.plate_no,
                    a.motor_no,
                    a.serial_no,
                    a.assd_no,
                    a.no_claim_id,
                    a.nc_iss_cd,
                    a.make_cd,
                    --b.assd_name,
                    --c.car_company, 
                    --d.make,
                    a.basic_color_cd,
                    a.color_cd,
                    a.remarks,                        --f.basic_color,f.color,
                    a.last_update,
                    a.user_id,
                    a.model_year,
                    a.cancel_tag,
                    a.motcar_comp_cd
               FROM gicl_no_claim_multi a /*,
                    giis_assured b,
                    giis_mc_car_company c,
                    gipi_vehicle d,
                    giis_mc_color f*/
              WHERE /* a.assd_no = b.assd_no(+)
                    AND a.motcar_comp_cd = c.car_company_cd(+)
                    AND a.plate_no = d.plate_no(+)
                    AND d.basic_color_cd = f.basic_color_cd(+)
                    AND d.color_cd = f.color_cd(+)
                    AND */a.no_claim_id = p_no_claim_id)
      LOOP
         v_no_claim_details_multi_yy.no_claim_no := i.no_claim_no;
         v_no_claim_details_multi_yy.plate_no := i.plate_no;
         v_no_claim_details_multi_yy.motor_no := i.motor_no;
         v_no_claim_details_multi_yy.serial_no := i.serial_no;
         v_no_claim_details_multi_yy.assd_no := i.assd_no;
         v_no_claim_details_multi_yy.no_claim_id := i.no_claim_id;
         v_no_claim_details_multi_yy.nc_iss_cd := i.nc_iss_cd;
         v_no_claim_details_multi_yy.make_cd := i.make_cd;
         --v_no_claim_details_multi_yy.assd_name := ESCAPE_VALUE_CLOB(i.assd_name);
         --v_no_claim_details_multi_yy.car_company := i.car_company;
         --v_no_claim_details_multi_yy.make                    := i.make;
         v_no_claim_details_multi_yy.basic_color_cd := i.basic_color_cd;
         v_no_claim_details_multi_yy.color_cd := i.color_cd;
         v_no_claim_details_multi_yy.remarks := i.remarks;
         --v_no_claim_details_multi_yy.basic_color             := i.basic_color;
         --v_no_claim_details_multi_yy.color                   := i.color;
         v_no_claim_details_multi_yy.user_id := i.user_id;
         v_no_claim_details_multi_yy.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_no_claim_details_multi_yy.model_year := i.model_year;
         v_no_claim_details_multi_yy.cancel_tag := i.cancel_tag;

        /* FOR d
            IN (SELECT DISTINCT b.car_company_cd car_company_cd,
                                b.make_cd make_cd,
                                c.car_company car_company,
                                b.model_year model_year,
                                b.make make,
                                b.basic_color_cd basic_color_cd,
                                b.color_cd color_cd,
                                b.color color
                  FROM gipi_vehicle b, giis_mc_car_company c
                 WHERE     b.car_company_cd = c.car_company_cd
                       AND b.plate_no = i.plate_no
                       AND b.serial_no = i.serial_no
                       AND b.motor_no = i.motor_no)
         LOOP
            v_no_claim_details_multi_yy.make := d.make;
            v_no_claim_details_multi_yy.color := d.color;
         END LOOP;

         FOR l IN (SELECT DISTINCT b.basic_color
                     FROM gipi_vehicle a, giis_mc_color b
                    WHERE b.basic_color_cd = i.basic_color_cd)
         LOOP
            v_no_claim_details_multi_yy.basic_color := l.basic_color;
         END LOOP;*/
         
          --assd_name
          BEGIN
            SELECT assd_name
              INTO v_no_claim_details_multi_yy.assd_name
              FROM giis_assured 
             WHERE assd_no = i.assd_no;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              NULL;
          END;
          
          --car_company
          BEGIN
            SELECT a.car_company--, b.make
              INTO v_no_claim_details_multi_yy.car_company--, :c038.make
              FROM giis_mc_car_company a--, giis_mc_make b 
             WHERE a.car_company_cd = i.motcar_comp_cd;
               --AND b.make_cd        = :c038.make_cd;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              NULL;
          END;

          --make
          BEGIN
            SELECT make
              INTO v_no_claim_details_multi_yy.make
              FROM giis_mc_make  
             WHERE make_cd = i.make_cd
               AND car_company_cd = i.motcar_comp_cd;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              NULL;
          END;

          --basic_color, color
          BEGIN
            SELECT c.basic_color, c.color
              INTO v_no_claim_details_multi_yy.basic_color, v_no_claim_details_multi_yy.color
              FROM giis_mc_color c 
             WHERE c.basic_color_cd = i.basic_color_cd
               AND c.color_cd       = i.color_cd;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              NULL;
          END;

         PIPE ROW (v_no_claim_details_multi_yy);
      END LOOP;

      RETURN;
   END;

   /**
   * Rey Jadlocon
   * 15-12-2011
   **/
   FUNCTION get_color_basic_color (
      p_basic_color_cd    giis_mc_color.basic_color_cd%TYPE,
      p_color_cd          giis_mc_color.color_cd%TYPE)
      RETURN get_color_basic_color_tab
      PIPELINED
   IS
      v_colors   get_color_basic_color_type;
   BEGIN
      FOR i
         IN (SELECT c.basic_color, c.color
               FROM giis_mc_color c
              WHERE     c.basic_color_cd = p_basic_color_cd
                    AND c.color_cd = p_color_cd)
      LOOP
         v_colors.basic_color := i.basic_color;
         v_colors.color := i.color;
         PIPE ROW (v_colors);
      END LOOP;

      RETURN;
   END;

   /**
   * Rey Jadlocon
   * 15-12-2011
   **/
   FUNCTION get_claim_multi_policy_list (
      p_plate_no       gicl_no_claim_multi.plate_no%TYPE,
      p_serial_no      gicl_no_claim_multi.serial_no%TYPE,
      p_motor_no       gicl_no_claim_multi.motor_no%TYPE,
      p_user_id        giis_users.user_id%TYPE)
      RETURN no_claim_policy_list_tab
      PIPELINED
   IS
      v_no_claim_policy   no_claim_policy_list_type;
   BEGIN
      FOR i
         IN (SELECT DISTINCT
                       b.line_cd
                    || '-'
                    || b.subline_cd
                    || '-'
                    || b.iss_cd
                    || '-'
                    || b.issue_yy
                    || '-'
                    || TO_CHAR (b.pol_seq_no, '0000009')
                    || '-'
                    || TO_CHAR (b.renew_no, '09')
                       policy_no,
                    a.plate_no,
                    b.line_cd,
                    b.subline_cd,
                    b.iss_cd,
                    b.issue_yy,
                    b.pol_seq_no,
                    b.renew_no,
                    b.expiry_date,
                    a.serial_no,
                    a.motor_no,
                    b.incept_date
               FROM gipi_vehicle a, gipi_polbasic b --, gicl_no_claim_multi c
              WHERE (a.plate_no = p_plate_no 
                    OR a.serial_no = p_serial_no
                    OR a.motor_no = p_motor_no)
                    AND a.policy_id = b.policy_id
                    AND NOT EXISTS
                               (SELECT '1'
                                  FROM gicl_claims c
                                 WHERE     c.line_cd = b.line_cd
                                       AND c.subline_cd = b.subline_cd
                                       AND c.pol_iss_cd = b.iss_cd
                                       AND c.issue_yy = b.issue_yy
                                       AND c.pol_seq_no = b.pol_seq_no
                                       AND c.renew_no = b.renew_no)
                    AND (   EXISTS (  --added by steven 08.20.2014; check_user_per_iss_cd2
                       SELECT c1.access_tag
                         FROM giis_users a1,
                              giis_user_grp_dtl b1,
                              giis_user_grp_modules c1
                        WHERE a1.user_grp = b1.user_grp
                          AND a1.user_grp = c1.user_grp
                          AND a1.user_id = p_user_id
                          AND b1.iss_cd = NVL (b.iss_cd, b1.iss_cd)
                          AND b1.tran_cd = c1.tran_cd
                          AND c1.module_id = 'GICLS062'
                          AND c1.access_tag = 1
                          AND EXISTS (
                                 SELECT 1
                                   FROM giis_user_grp_line
                                  WHERE user_grp = b1.user_grp
                                    AND iss_cd = b1.iss_cd
                                    AND tran_cd = c1.tran_cd
                                    AND line_cd = NVL (b.line_cd, line_cd)))
                    OR EXISTS (
                       SELECT c1.access_tag
                         FROM giis_users a1,
                              giis_user_iss_cd b1,
                              giis_user_modules c1
                        WHERE a1.user_id = b1.userid
                          AND a1.user_id = c1.userid
                          AND a1.user_id = p_user_id
                          AND b1.iss_cd = NVL (b.iss_cd, b1.iss_cd)
                          AND b1.tran_cd = c1.tran_cd
                          AND c1.module_id = 'GICLS062'
                          AND c1.access_tag = 1
                          AND EXISTS (
                                 SELECT 1
                                   FROM giis_user_line
                                  WHERE userid = b1.userid
                                    AND iss_cd = b1.iss_cd
                                    AND tran_cd = c1.tran_cd
                                    AND line_cd = NVL (b.line_cd, line_cd))))
                    --AND check_user_per_iss_cd2 (b.line_cd, b.iss_cd, 'GICLS062', p_user_id) = 1 --remove by steven 08.28.2014; mabagal.
                    --AND (a.plate_no = p_plate_no 
                    --OR a.serial_no = p_serial_no
                    --OR a.motor_no = p_motor_no)
                    )
      LOOP
         v_no_claim_policy.policy_no := i.policy_no;
         --v_no_claim_policy.policy_id := i.policy_id; -- bonok :: 03.26.2014 :: para nde madoble ang display ng Policy No. kapag meron syang endorsement
         v_no_claim_policy.plate_no := i.plate_no;
         v_no_claim_policy.line_cd := i.line_cd;
         v_no_claim_policy.subline_cd := i.subline_cd;
         v_no_claim_policy.iss_cd := i.iss_cd;
         v_no_claim_policy.issue_yy := i.issue_yy;
         v_no_claim_policy.pol_seq_no := i.pol_seq_no;
         v_no_claim_policy.renew_no := i.renew_no;
         --v_no_claim_policy.eff_date := i.eff_date; -- bonok :: 03.26.2014 :: para nde madoble ang display ng Policy No. kapag meron syang endorsement
         v_no_claim_policy.expiry_date := i.expiry_date;
         v_no_claim_policy.incept_date := i.incept_date;
         v_no_claim_policy.line_cd_mc := giisp.v ('LINE_CODE_MC');
         v_no_claim_policy.str_expiry_date :=
            TO_CHAR (i.expiry_date, 'mm-dd-yyyy');
         v_no_claim_policy.str_incept_date :=
            TO_CHAR (i.incept_date, 'mm-dd-yyyy');
         -- bonok :: 03.26.2014 :: para nde madoble ang display ng Policy No. kapag meron syang endorsement
         -- para maretrieve ulit ung mga value na tinanggal sa main query  
         FOR j IN (SELECT policy_id, eff_date
                     FROM gipi_polbasic
                    WHERE line_cd = i.line_cd
                      AND subline_cd = i.subline_cd
                      AND iss_cd = i.iss_cd
                      AND issue_yy = i.issue_yy
                      AND pol_seq_no = i.pol_seq_no
                      AND renew_no = i.renew_no)
         LOOP
            v_no_claim_policy.policy_id := j.policy_id;
            v_no_claim_policy.eff_date := j.eff_date;
         END LOOP;
                      
         PIPE ROW (v_no_claim_policy);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_claim_multi_policy_list2 (
      p_serial_no gicl_no_claim_multi.serial_no%TYPE)
      RETURN no_claim_policy_list_tab
      PIPELINED
   IS
      v_no_claim_policy   no_claim_policy_list_type;
   BEGIN
      FOR i
         IN (SELECT DISTINCT
                       b.line_cd
                    || '-'
                    || b.subline_cd
                    || '-'
                    || b.iss_cd
                    || '-'
                    || b.issue_yy
                    || '-'
                    || TO_CHAR (b.pol_seq_no, '0000009')
                    || '-'
                    || TO_CHAR (b.renew_no, '09')
                       policy_no,
                    a.policy_id,
                    a.plate_no,
                    b.line_cd,
                    b.subline_cd,
                    b.iss_cd,
                    b.issue_yy,
                    b.pol_seq_no,
                    b.renew_no,
                    b.eff_date,
                    b.expiry_date,
                    b.incept_date,
                    b.ref_pol_no,
                    c.line_cd nbt_line_cd,
                    c.iss_cd nbt_iss_cd,
                    c.par_yy,
                    c.par_seq_no,
                    c.quote_seq_no,
                    b.issue_date,
                    d.assd_name,
                    DECODE (b.pol_flag,
                            '1', 'New',
                            '2', 'Renewal',
                            '3', 'Replacement',
                            '4', 'Cancelled Endorsement',
                            '5', 'Spoiled',
                            'X', 'Expired')
                       mean_pol_flag,
                    f.line_cd line_cd_rn,
                    f.iss_cd iss_cd_rn,
                    f.rn_yy,                                    --f.rn_seq_no,
                    b.cred_branch,
                       e.line_cd
                    || ' - '
                    || e.subline_cd
                    || ' - '
                    || e.iss_cd
                    || ' - '
                    || TO_CHAR (e.issue_yy, '09')
                    || ' - '
                    || TO_CHAR (e.pol_seq_no, '099999')
                    || ' - '
                    || TO_CHAR (e.renew_no, '09')
                       pack_pol_no
               FROM gipi_vehicle a,
                    gipi_polbasic b,
                    gipi_parlist c,
                    giis_assured d,
                    giex_rn_no f,
                    gipi_pack_polbasic e
              WHERE     a.policy_id = b.policy_id
                    AND a.plate_no = p_serial_no
                    AND b.par_id = c.par_id
                    AND b.line_cd = f.line_cd
                    AND b.pack_policy_id = e.pack_policy_id(+)
                    AND b.assd_no = d.assd_no
                    AND NOT EXISTS
                               (SELECT '1'
                                  FROM gicl_claims
                                 WHERE     line_Cd = b.line_cd
                                       AND subline_Cd = b.subline_Cd
                                       AND pol_iss_cd = b.iss_Cd
                                       AND issue_yy = b.issue_yy
                                       AND pol_seq_no = b.pol_seq_no
                                       AND renew_no = b.renew_no))
      LOOP
         v_no_claim_policy.policy_no := i.policy_no;
         v_no_claim_policy.policy_id := i.policy_id;
         v_no_claim_policy.plate_no := i.plate_no;
         v_no_claim_policy.line_cd := i.line_cd;
         v_no_claim_policy.subline_cd := i.subline_cd;
         v_no_claim_policy.iss_cd := i.iss_cd;
         v_no_claim_policy.issue_yy := i.issue_yy;
         v_no_claim_policy.pol_seq_no := i.pol_seq_no;
         v_no_claim_policy.renew_no := i.renew_no;
         v_no_claim_policy.eff_date := i.eff_date;
         v_no_claim_policy.expiry_date := i.expiry_date;
         v_no_claim_policy.incept_date := i.incept_date;
         v_no_claim_policy.ref_pol_no := i.ref_pol_no;
         v_no_claim_policy.nbt_line_cd := i.nbt_line_cd;
         v_no_claim_policy.nbt_iss_cd := i.nbt_iss_cd;
         v_no_claim_policy.par_yy := i.par_yy;
         v_no_claim_policy.par_seq_no := i.par_seq_no;
         v_no_claim_policy.quote_seq_no := i.quote_seq_no;
         v_no_claim_policy.issue_date := i.issue_date;
         v_no_claim_policy.assd_name := i.assd_name;
         v_no_claim_policy.mean_pol_flag := i.mean_pol_flag;
         v_no_claim_policy.line_cd_rn := i.line_cd_rn;
         v_no_claim_policy.iss_cd_rn := i.iss_cd_rn;
         v_no_claim_policy.rn_yy := i.rn_yy;
         --v_no_claim_policy.rn_seq_no         := i.rn_seq_no;
         v_no_claim_policy.cred_branch := i.cred_branch;
         v_no_claim_policy.pack_pol_no := i.pack_pol_no;
         v_no_claim_policy.str_expiry_date :=
            TO_CHAR (i.expiry_date, 'mm-dd-yyyy');
         v_no_claim_policy.str_incept_date :=
            TO_CHAR (i.incept_date, 'mm-dd-yyyy');
         PIPE ROW (v_no_claim_policy);
      END LOOP;

      RETURN;
   END;



   FUNCTION get_claim_multi_policy_list3 (
      p_motor_no gicl_no_claim_multi.motor_no%TYPE)
      RETURN no_claim_policy_list_tab
      PIPELINED
   IS
      v_no_claim_policy   no_claim_policy_list_type;
   BEGIN
      FOR i
         IN (SELECT DISTINCT
                       b.line_cd
                    || '-'
                    || b.subline_cd
                    || '-'
                    || b.iss_cd
                    || '-'
                    || b.issue_yy
                    || '-'
                    || TO_CHAR (b.pol_seq_no, '0000009')
                    || '-'
                    || TO_CHAR (b.renew_no, '09')
                       policy_no,
                    a.policy_id,
                    a.plate_no,
                    b.line_cd,
                    b.subline_cd,
                    b.iss_cd,
                    b.issue_yy,
                    b.pol_seq_no,
                    b.renew_no,
                    b.eff_date,
                    b.expiry_date,
                    b.incept_date,
                    b.ref_pol_no,
                    c.line_cd nbt_line_cd,
                    c.iss_cd nbt_iss_cd,
                    c.par_yy,
                    c.par_seq_no,
                    c.quote_seq_no,
                    b.issue_date,
                    d.assd_name,
                    DECODE (b.pol_flag,
                            '1', 'New',
                            '2', 'Renewal',
                            '3', 'Replacement',
                            '4', 'Cancelled Endorsement',
                            '5', 'Spoiled',
                            'X', 'Expired')
                       mean_pol_flag,
                    f.line_cd line_cd_rn,
                    f.iss_cd iss_cd_rn,
                    f.rn_yy,                                    --f.rn_seq_no,
                    b.cred_branch,
                       e.line_cd
                    || ' - '
                    || e.subline_cd
                    || ' - '
                    || e.iss_cd
                    || ' - '
                    || TO_CHAR (e.issue_yy, '09')
                    || ' - '
                    || TO_CHAR (e.pol_seq_no, '099999')
                    || ' - '
                    || TO_CHAR (e.renew_no, '09')
                       pack_pol_no
               FROM gipi_vehicle a,
                    gipi_polbasic b,
                    gipi_parlist c,
                    giis_assured d,
                    giex_rn_no f,
                    gipi_pack_polbasic e
              WHERE     a.policy_id = b.policy_id
                    AND a.plate_no = p_motor_no
                    AND b.par_id = c.par_id
                    AND b.line_cd = f.line_cd
                    AND b.pack_policy_id = e.pack_policy_id(+)
                    AND b.assd_no = d.assd_no
                    AND NOT EXISTS
                               (SELECT '1'
                                  FROM gicl_claims
                                 WHERE     line_Cd = b.line_cd
                                       AND subline_Cd = b.subline_Cd
                                       AND pol_iss_cd = b.iss_Cd
                                       AND issue_yy = b.issue_yy
                                       AND pol_seq_no = b.pol_seq_no
                                       AND renew_no = b.renew_no))
      LOOP
         v_no_claim_policy.policy_no := i.policy_no;
         v_no_claim_policy.policy_id := i.policy_id;
         v_no_claim_policy.plate_no := i.plate_no;
         v_no_claim_policy.line_cd := i.line_cd;
         v_no_claim_policy.subline_cd := i.subline_cd;
         v_no_claim_policy.iss_cd := i.iss_cd;
         v_no_claim_policy.issue_yy := i.issue_yy;
         v_no_claim_policy.pol_seq_no := i.pol_seq_no;
         v_no_claim_policy.renew_no := i.renew_no;
         v_no_claim_policy.eff_date := i.eff_date;
         v_no_claim_policy.expiry_date := i.expiry_date;
         v_no_claim_policy.incept_date := i.incept_date;
         v_no_claim_policy.ref_pol_no := i.ref_pol_no;
         v_no_claim_policy.nbt_line_cd := i.nbt_line_cd;
         v_no_claim_policy.nbt_iss_cd := i.nbt_iss_cd;
         v_no_claim_policy.par_yy := i.par_yy;
         v_no_claim_policy.par_seq_no := i.par_seq_no;
         v_no_claim_policy.quote_seq_no := i.quote_seq_no;
         v_no_claim_policy.issue_date := i.issue_date;
         v_no_claim_policy.assd_name := i.assd_name;
         v_no_claim_policy.mean_pol_flag := i.mean_pol_flag;
         v_no_claim_policy.line_cd_rn := i.line_cd_rn;
         v_no_claim_policy.iss_cd_rn := i.iss_cd_rn;
         v_no_claim_policy.rn_yy := i.rn_yy;
         --v_no_claim_policy.rn_seq_no         := i.rn_seq_no;
         v_no_claim_policy.cred_branch := i.cred_branch;
         v_no_claim_policy.pack_pol_no := i.pack_pol_no;
         v_no_claim_policy.str_expiry_date :=
            TO_CHAR (i.expiry_date, 'mm-dd-yyyy');
         v_no_claim_policy.str_incept_date :=
            TO_CHAR (i.incept_date, 'mm-dd-yyyy');
         PIPE ROW (v_no_claim_policy);
      END LOOP;

      RETURN;
   END;

   /**
   * Rey Jadlocon
   * 19-12-2011
   **/

   PROCEDURE insert_in_gicl_cnc_dtl (
      p_plate_no       gipi_vehicle.plate_no%TYPE,
      p_no_claim_id    gicl_no_claim_multi.no_claim_id%TYPE)
   IS
      v_existing    NUMBER;
      v_eff_date    gicl_cnc_dtl.eff_date%TYPE;
      v_exp_date    gicl_cnc_dtl.expiry_date%TYPE;
      v_policy_id   gicl_cnc_dtl.policy_id%TYPE;
   BEGIN
      FOR c1
         IN (SELECT a.policy_id, b.eff_date, b.expiry_date
               FROM gipi_vehicle a, gipi_polbasic b
              WHERE     a.policy_id = b.policy_id
                    AND NOT EXISTS
                               (SELECT '1'
                                  FROM gicl_claims
                                 WHERE     line_cd = b.line_cd
                                       AND subline_cd = b.subline_cd
                                       AND pol_iss_cd = b.iss_cd
                                       AND issue_yy = b.issue_yy
                                       AND pol_seq_no = b.pol_seq_no
                                       AND renew_no = b.renew_no)
                    AND a.plate_no = p_plate_no)
      LOOP
         v_existing := 0;
         v_policy_id := c1.policy_id;
         v_eff_date := c1.eff_date;
         v_exp_date := c1.expiry_date;


         BEGIN
            SELECT 1
              INTO v_existing
              FROM gicl_cnc_dtl
             WHERE policy_id = v_policy_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_existing := 0;
         END;

         IF v_existing = 0 AND c1.policy_id IS NOT NULL
         THEN
            INSERT INTO gicl_cnc_dtl
                 VALUES (p_no_claim_id,
                         v_policy_id,
                         v_eff_date,
                         v_exp_date);
         END IF;
      END LOOP;
   END;


   /**
   * Rey Jadlocon
   * 20-12-2011
   **/

    FUNCTION get_assd_lov (
       p_find_text   VARCHAR2,
       p_module_id   giis_modules.module_id%TYPE,
       p_user_id     giis_users.user_name%TYPE
    )
       RETURN assd_lov_tab PIPELINED
    IS
       v_assured   assd_lov_type;
       v_pointer   NUMBER        := 0;
    BEGIN
       IF p_find_text IS NULL
       THEN
    --    FOR i
    --         IN (  SELECT DISTINCT a.assd_no, a.assd_name
    --                 FROM GIIS_ASSURED a, GIPI_POLBASIC b
    --                WHERE a.assd_no = b.assd_no
    --            AND b.line_cd = 'MC'
    --            AND NOT EXISTS
    --                   (SELECT 1
    --                      FROM GICL_CLAIMS c
    --                     WHERE     c.line_Cd = b.line_cd
    --                         AND c.subline_Cd = b.subline_Cd
    --                         AND c.pol_iss_cd = b.iss_cd
    --                         AND c.issue_yy = b.issue_yy
    --                         AND c.pol_seq_no = b.pol_seq_no
    --                         AND c.renew_no = b.renew_no)
    --           AND check_user_per_iss_cd2(b.line_cd, b.iss_cd, p_module_id, p_user_id) = 1
    --               ORDER BY a.assd_no)
    --      LOOP
    --         v_assured.assd_no := i.assd_no;
    --         v_assured.assd_name := i.assd_name;
    --         PIPE ROW (v_assured);
    --      END LOOP;

          -- bonok :: 03.26.2014 :: retrieve only records existing in gipi_vehicle and had its plate_no used in more than 1 policy
          FOR i IN (SELECT DISTINCT a.assd_no, a.assd_name
                               FROM giis_assured a,
                                    gipi_polbasic b,
                                    gipi_vehicle c
                              WHERE a.assd_no = b.assd_no
                                AND b.policy_id = c.policy_id
                                AND b.line_cd = 'MC'
								AND c.plate_no IS NOT NULL --added by steven 08.20.2014
                                AND NOT EXISTS (
                                       SELECT 1
                                         FROM gicl_claims c
                                        WHERE c.line_cd = b.line_cd
                                          AND c.subline_cd = b.subline_cd
                                          AND c.pol_iss_cd = b.iss_cd
                                          AND c.issue_yy = b.issue_yy
                                          AND c.pol_seq_no = b.pol_seq_no
                                          AND c.renew_no = b.renew_no)
                                 --AND get_policy_count (c.plate_no) > 1
                                 AND c.plate_no IN (SELECT v.plate_no --added by steven 08.20.2014; replace the code above
                                                     FROM gipi_vehicle v
                                                     GROUP BY v.plate_no
                                                     HAVING COUNT (DISTINCT policy_id) > 1) --end
                                 AND (   EXISTS (  --added by steven 08.20.2014; check_user_per_iss_cd2
                                       SELECT c1.access_tag
                                         FROM giis_users a1,
                                              giis_user_grp_dtl b1,
                                              giis_user_grp_modules c1
                                        WHERE a1.user_grp = b1.user_grp
                                          AND a1.user_grp = c1.user_grp
                                          AND a1.user_id = p_user_id
                                          AND b1.iss_cd = NVL (b.iss_cd, b1.iss_cd)
                                          AND b1.tran_cd = c1.tran_cd
                                          AND c1.module_id = p_module_id
                                          AND c1.access_tag = 1
                                          AND EXISTS (
                                                 SELECT 1
                                                   FROM giis_user_grp_line
                                                  WHERE user_grp = b1.user_grp
                                                    AND iss_cd = b1.iss_cd
                                                    AND tran_cd = c1.tran_cd
                                                    AND line_cd = NVL (b.line_cd, line_cd)))
                                 OR EXISTS (
                                       SELECT c1.access_tag
                                         FROM giis_users a1,
                                              giis_user_iss_cd b1,
                                              giis_user_modules c1
                                        WHERE a1.user_id = b1.userid
                                          AND a1.user_id = c1.userid
                                          AND a1.user_id = p_user_id
                                          AND b1.iss_cd = NVL (b.iss_cd, b1.iss_cd)
                                          AND b1.tran_cd = c1.tran_cd
                                          AND c1.module_id = p_module_id
                                          AND c1.access_tag = 1
                                          AND EXISTS (
                                                 SELECT 1
                                                   FROM giis_user_line
                                                  WHERE userid = b1.userid
                                                    AND iss_cd = b1.iss_cd
                                                    AND tran_cd = c1.tran_cd
                                                    AND line_cd = NVL (b.line_cd, line_cd))))                  
--                                AND check_user_per_iss_cd2 (b.line_cd,
--                                                            b.iss_cd,
--                                                            p_module_id,
--                                                            p_user_id
--                                                           ) = 1
                           ORDER BY a.assd_no)
          LOOP
            v_assured.assd_no := i.assd_no;
            v_assured.assd_name := i.assd_name;
            PIPE ROW (v_assured);
          END LOOP;
       ELSE
          FOR ptr IN (SELECT 1
                        FROM giis_assured
                       WHERE assd_no LIKE UPPER (p_find_text)
                          OR assd_name LIKE UPPER (p_find_text))
          LOOP
             v_pointer := 1;
          END LOOP;

          IF v_pointer = 1
          THEN
    --       FOR i
    --           IN (  SELECT DISTINCT a.assd_no, a.assd_name
    --                 FROM GIIS_ASSURED a, GIPI_POLBASIC b
    --                WHERE        a.assd_no = b.assd_no
    --                  AND b.line_cd = 'MC'
    --                          AND (a.assd_no LIKE UPPER (p_find_text)
    --                              OR assd_name LIKE UPPER (p_find_text))
    --                  AND NOT EXISTS
    --                         (SELECT 1
    --                            FROM GICL_CLAIMS c
    --                           WHERE     c.line_Cd = b.line_cd
    --                               AND c.subline_Cd = b.subline_Cd
    --                               AND c.pol_iss_cd = b.iss_cd
    --                               AND c.issue_yy = b.issue_yy
    --                               AND c.pol_seq_no = b.pol_seq_no
    --                               AND c.renew_no = b.renew_no)
    --                         AND check_user_per_iss_cd2(b.line_cd, b.iss_cd, p_module_id, p_user_id) = 1
    --                ORDER BY a.assd_no)
    --         LOOP
    --           v_assured.assd_no := i.assd_no;
    --           v_assured.assd_name := i.assd_name;
    --           PIPE ROW (v_assured);
    --         END LOOP;

             -- bonok :: 03.26.2014 :: retrieve only records existing in gipi_vehicle and had its plate_no used in more than 1 policy
             FOR i IN (SELECT DISTINCT a.assd_no, a.assd_name
                                  FROM giis_assured a,
                                       gipi_polbasic b,
                                       gipi_vehicle c
                                 WHERE a.assd_no = b.assd_no
                                   AND b.policy_id = c.policy_id
                                   AND b.line_cd = 'MC'
								   AND c.plate_no IS NOT NULL --added by steven 08.20.2014
                                   AND (   a.assd_no LIKE UPPER (p_find_text)
                                        OR assd_name LIKE UPPER (p_find_text)
                                       )
                                   AND NOT EXISTS (
                                          SELECT 1
                                            FROM gicl_claims c
                                           WHERE c.line_cd = b.line_cd
                                             AND c.subline_cd = b.subline_cd
                                             AND c.pol_iss_cd = b.iss_cd
                                             AND c.issue_yy = b.issue_yy
                                             AND c.pol_seq_no = b.pol_seq_no
                                             AND c.renew_no = b.renew_no)
                                   --AND get_policy_count (c.plate_no) > 1
                                   AND c.plate_no IN (SELECT v.plate_no --added by steven 08.20.2014; replace the code above
                                                     FROM gipi_vehicle v
                                                     GROUP BY v.plate_no
                                                     HAVING COUNT (DISTINCT policy_id) > 1) --end
                                   AND (   EXISTS (  --added by steven 08.20.2014; check_user_per_iss_cd2
                                       SELECT c1.access_tag
                                         FROM giis_users a1,
                                              giis_user_grp_dtl b1,
                                              giis_user_grp_modules c1
                                        WHERE a1.user_grp = b1.user_grp
                                          AND a1.user_grp = c1.user_grp
                                          AND a1.user_id = p_user_id
                                          AND b1.iss_cd = NVL (b.iss_cd, b1.iss_cd)
                                          AND b1.tran_cd = c1.tran_cd
                                          AND c1.module_id = p_module_id
                                          AND c1.access_tag = 1
                                          AND EXISTS (
                                                 SELECT 1
                                                   FROM giis_user_grp_line
                                                  WHERE user_grp = b1.user_grp
                                                    AND iss_cd = b1.iss_cd
                                                    AND tran_cd = c1.tran_cd
                                                    AND line_cd = NVL (b.line_cd, line_cd)))
                                 OR EXISTS (
                                       SELECT c1.access_tag
                                         FROM giis_users a1,
                                              giis_user_iss_cd b1,
                                              giis_user_modules c1
                                        WHERE a1.user_id = b1.userid
                                          AND a1.user_id = c1.userid
                                          AND a1.user_id = p_user_id
                                          AND b1.iss_cd = NVL (b.iss_cd, b1.iss_cd)
                                          AND b1.tran_cd = c1.tran_cd
                                          AND c1.module_id = p_module_id
                                          AND c1.access_tag = 1
                                          AND EXISTS (
                                                 SELECT 1
                                                   FROM giis_user_line
                                                  WHERE userid = b1.userid
                                                    AND iss_cd = b1.iss_cd
                                                    AND tran_cd = c1.tran_cd
                                                    AND line_cd = NVL (b.line_cd, line_cd))))        
--                                   AND check_user_per_iss_cd2 (b.line_cd,
--                                                               b.iss_cd,
--                                                               p_module_id,
--                                                               p_user_id
--                                                              ) = 1
                              ORDER BY a.assd_no)
             LOOP
                v_assured.assd_no := i.assd_no;
                v_assured.assd_name := i.assd_name;
                PIPE ROW (v_assured);
             END LOOP;
          ELSE
    --       FOR n
    --           IN (  SELECT DISTINCT a.assd_no, a.assd_name
    --                 FROM GIIS_ASSURED a, GIPI_POLBASIC b
    --                WHERE        a.assd_no = b.assd_no
    --                  AND b.line_cd = 'MC'
    --                  AND NOT EXISTS
    --                         (SELECT 1
    --                            FROM GICL_CLAIMS c
    --                           WHERE     c.line_Cd = b.line_cd
    --                               AND c.subline_Cd = b.subline_Cd
    --                               AND c.pol_iss_cd = b.iss_cd
    --                               AND c.issue_yy = b.issue_yy
    --                               AND c.pol_seq_no = b.pol_seq_no
    --                               AND c.renew_no = b.renew_no)
    --                         AND check_user_per_iss_cd2(b.line_cd, b.iss_cd, p_module_id, p_user_id) = 1
    --                ORDER BY a.assd_no)
    --         LOOP
    --           v_assured.assd_no := n.assd_no;
    --           v_assured.assd_name := n.assd_name;
    --           PIPE ROW (v_assured);
    --         END LOOP;

             -- bonok :: 03.26.2014 :: retrieve only records existing in gipi_vehicle and had its plate_no used in more than 1 policy
             FOR n IN (SELECT DISTINCT a.assd_no, a.assd_name
                                  FROM giis_assured a,
                                       gipi_polbasic b,
                                       gipi_vehicle c
                                 WHERE a.assd_no = b.assd_no
                                   AND b.policy_id = c.policy_id
                                   AND b.line_cd = 'MC'
								   AND c.plate_no IS NOT NULL --added by steven 08.20.2014
                                   AND NOT EXISTS (
                                          SELECT 1
                                            FROM gicl_claims c
                                           WHERE c.line_cd = b.line_cd
                                             AND c.subline_cd = b.subline_cd
                                             AND c.pol_iss_cd = b.iss_cd
                                             AND c.issue_yy = b.issue_yy
                                             AND c.pol_seq_no = b.pol_seq_no
                                             AND c.renew_no = b.renew_no)
                                   --AND get_policy_count (c.plate_no) > 1
                                   AND c.plate_no IN (SELECT v.plate_no --added by steven 08.20.2014; replace the code above
                                                     FROM gipi_vehicle v
                                                     GROUP BY v.plate_no
                                                     HAVING COUNT (DISTINCT policy_id) > 1) --end
                                   AND (   EXISTS (  --added by steven 08.20.2014; check_user_per_iss_cd2
                                       SELECT c1.access_tag
                                         FROM giis_users a1,
                                              giis_user_grp_dtl b1,
                                              giis_user_grp_modules c1
                                        WHERE a1.user_grp = b1.user_grp
                                          AND a1.user_grp = c1.user_grp
                                          AND a1.user_id = p_user_id
                                          AND b1.iss_cd = NVL (b.iss_cd, b1.iss_cd)
                                          AND b1.tran_cd = c1.tran_cd
                                          AND c1.module_id = p_module_id
                                          AND c1.access_tag = 1
                                          AND EXISTS (
                                                 SELECT 1
                                                   FROM giis_user_grp_line
                                                  WHERE user_grp = b1.user_grp
                                                    AND iss_cd = b1.iss_cd
                                                    AND tran_cd = c1.tran_cd
                                                    AND line_cd = NVL (b.line_cd, line_cd)))
                                 OR EXISTS (
                                       SELECT c1.access_tag
                                         FROM giis_users a1,
                                              giis_user_iss_cd b1,
                                              giis_user_modules c1
                                        WHERE a1.user_id = b1.userid
                                          AND a1.user_id = c1.userid
                                          AND a1.user_id = p_user_id
                                          AND b1.iss_cd = NVL (b.iss_cd, b1.iss_cd)
                                          AND b1.tran_cd = c1.tran_cd
                                          AND c1.module_id = p_module_id
                                          AND c1.access_tag = 1
                                          AND EXISTS (
                                                 SELECT 1
                                                   FROM giis_user_line
                                                  WHERE userid = b1.userid
                                                    AND iss_cd = b1.iss_cd
                                                    AND tran_cd = c1.tran_cd
                                                    AND line_cd = NVL (b.line_cd, line_cd)))) 
--                                   AND check_user_per_iss_cd2 (b.line_cd,
--                                                               b.iss_cd,
--                                                               p_module_id,
--                                                               p_user_id
--                                                              ) = 1
                              ORDER BY a.assd_no)
             LOOP
                v_assured.assd_no := n.assd_no;
                v_assured.assd_name := n.assd_name;
                PIPE ROW (v_assured);
             END LOOP;
          END IF;
       END IF;
    END;

   /**
   * Rey Jadlocon
   * 20-12-2011
   **/
   FUNCTION get_plate_grp_lov (p_assd_no giis_assured.assd_no%TYPE)
      RETURN plate_grp_lov_tab
      PIPELINED
   IS
      v_plate_grp   plate_grp_lov_type;
   BEGIN
      FOR i --modified by kenneth 11.25.2014 to remove records already in gicl_no_claim_multi 
         IN (SELECT * FROM (SELECT DISTINCT b.plate_no, b.serial_no, b.motor_no
               FROM gipi_vehicle b, gipi_polbasic a
              WHERE a.policy_id = b.policy_id AND a.assd_no = p_assd_no
   		    	AND b.motor_no NOT IN(SELECT NVL(motor_no, '*')
                            			FROM GICL_CLAIMS
                          			   WHERE assd_no = p_assd_no) 
              MINUS
             SELECT DISTINCT c.plate_no, d.serial_no, d.motor_no
               FROM gicl_claims c, gipi_vehicle d
              WHERE     c.plate_no = d.plate_no
                    AND c.assd_no = p_assd_no
                    AND c.clm_stat_cd NOT IN ('CC', 'DN', 'WD'))
              WHERE plate_no NOT IN (SELECT plate_no 
                                       FROM gicl_no_claim_multi 
                                      WHERE assd_no = p_assd_no))
      LOOP
         IF get_policy_count(i.plate_no) > 1 THEN -- bonok :: 03.26.2014 :: para ang maretrieve lang na records ay yung mga plate_no na ginamit sa more than 1 Policy
            v_plate_grp.plate_no := i.plate_no;
            v_plate_grp.serial_no := i.serial_no;
            v_plate_grp.motor_no := i.motor_no;
            PIPE ROW (v_plate_grp);
         END IF;
      END LOOP;
   END;

   /**
   * Rey Jadlocon
   * 22-12-2011
   **/
   FUNCTION get_user_last_update (
      p_no_claim_id gicl_no_claim_multi.no_claim_id%TYPE)
      RETURN get_user_last_update_tab
      PIPELINED
   IS
      v_last_update   get_user_last_update_type;
   BEGIN
      FOR i IN (SELECT user_id, last_update
                  FROM gicl_no_claim
                 WHERE no_claim_id = p_no_claim_id)
      LOOP
         v_last_update.user_id := i.user_id;
         v_last_update.last_update := i.last_update;
         PIPE ROW (v_last_update);
      END LOOP;

      RETURN;
   END;

   /**
   * Rey Jadlocon
   * 29-12-2011
   **/
   FUNCTION GEN_NC_NO (P_NC_ISS_CD      GICL_NO_CLAIM.NC_ISS_CD%TYPE,
                       P_NC_ISSUE_YY    GICL_NO_CLAIM.NC_ISSUE_YY%TYPE)
      RETURN NUMBER
   IS
      V_NC_SEQ_NO    GICL_NO_CLAIM.NC_SEQ_NO%TYPE;
      V_NCM_SEQ_NO   GICL_NO_CLAIM_MULTI.NC_SEQ_NO%TYPE;
   BEGIN
      SELECT NVL (MAX (NVL (NC_SEQ_NO, 0)), 0) + 1
        INTO V_NC_SEQ_NO
        FROM GICL_NO_CLAIM
       WHERE NC_ISS_CD = P_NC_ISS_CD AND NC_ISSUE_YY = P_NC_ISSUE_YY;

      SELECT NVL (MAX (NVL (NC_SEQ_NO, 0)), 0) + 1
        INTO V_NCM_SEQ_NO
        FROM GICL_NO_CLAIM_MULTI
       WHERE NC_ISS_CD = P_NC_ISS_CD AND NC_ISSUE_YY = P_NC_ISSUE_YY;

      IF V_NC_SEQ_NO > V_NCM_SEQ_NO
      THEN
         RETURN V_NC_SEQ_NO;
      ELSE
         RETURN V_NCM_SEQ_NO;
      END IF;
   END;

   /**
   * Rey Jadlocon
   * 01-03-2012
   *
   * Modified by Christian based on GICLS062.fmb ver 7/20/2012
   **/
   FUNCTION populate_noclmmultiyy_details (
      p_assd_no      gicl_no_claim_multi.assd_no%TYPE,
      p_plate_no     gicl_no_claim_multi.plate_no%TYPE,
      p_serial_no    gicl_no_claim_multi.serial_no%TYPE,
      p_motor_no     gicl_no_claim_multi.motor_no%TYPE)
      RETURN get_no_claim_multi_yy_tab2
      PIPELINED
   IS
      details            get_no_claim_multi_yy_type2;
      v_car_company_cd   gipi_vehicle.car_company_cd%TYPE;
      v_make_cd          gipi_vehicle.make_cd%TYPE;
      v_car_company      giis_mc_car_company.car_company%TYPE;
      v_model_year       gipi_vehicle.model_year%TYPE;
      v_make             gipi_vehicle.make%TYPE;
      v_basic_color_cd   gipi_vehicle.basic_color_cd%TYPE;
      v_color_cd         gipi_vehicle.color_cd%TYPE;
      v_color            gipi_vehicle.color%TYPE;
      v_assd_no          gicl_no_claim_multi.assd_no%TYPE;
      v_plate_no         gicl_no_claim_multi.plate_no%TYPE;
      v_serial_no        gicl_no_claim_multi.serial_no%TYPE;
      v_motor_no         gipi_vehicle.motor_no%TYPE;
      v_message          VARCHAR2 (100);
      v_basic_color      giis_mc_color.basic_color%TYPE;
      v_assd_name        giis_assured.assd_name%TYPE;
      v_exist            NUMBER := 0 ;--added by aliza 07/20/2012
   BEGIN
      IF     p_assd_no IS NOT NULL
         AND p_plate_no IS NOT NULL
         AND p_serial_no IS NOT NULL
         AND p_motor_no IS NOT NULL
      THEN
         BEGIN
            FOR i
               IN (SELECT DISTINCT b.car_company_cd,
                                   b.make_cd,
                                   c.car_company,
                                   b.model_year,
                                   b.make,
                                   b.basic_color_cd,
                                   b.color_cd,
                                   b.color
                     FROM gipi_vehicle b, giis_mc_car_company c
                    WHERE     b.car_company_cd = c.car_company_cd
                          AND b.plate_no LIKE p_plate_no
                          AND b.serial_no LIKE p_serial_no
                          AND b.motor_no LIKE p_motor_no)
            LOOP
               v_car_company_cd := i.car_company_cd;
               v_make_cd := i.make_cd;
               v_car_company := i.car_company;
               v_model_year := i.model_year;
               v_make := i.make;
               v_basic_color_cd := i.basic_color_cd;
               v_color_cd := i.color_cd;
               v_color := i.color;
            END LOOP;
         END;
      ELSIF p_plate_no IS NOT NULL
      THEN
         BEGIN
            FOR x IN(	--order by and loop added by aliza 07/20/2012
                  --SELECT DISTINCT a.assd_no, b.plate_no, b.serial_no, c.car_company, b.model_year,
                  SELECT a.assd_no, b.plate_no, b.serial_no, c.car_company, b.model_year,  
                         b.make, b.basic_color_cd, b.color_cd, b.color, b.car_company_cd, b.make_cd
                    FROM gipi_polbasic a, gipi_vehicle b, giis_mc_car_company c
                   WHERE a.policy_id = b.policy_id
                     AND b.car_company_cd = c.car_company_cd
                     AND b.plate_no LIKE p_plate_no
                   ORDER BY a.policy_id DESC)
            LOOP
                v_assd_no         := x.assd_no;
                v_plate_no        := x.plate_no;
                v_serial_no       := x.serial_no;
                v_car_company     := x.car_company;
                v_model_year      := x.model_year;
                v_make            := x.make;
                v_basic_color_cd  := x.basic_color_cd;
                v_color_cd        := x.color_cd;
                v_color           := x.color;
                --added by christian 01252013
                v_car_company_cd  := x.car_company_cd; 
                v_make_cd         := x.make_cd;
                v_exist           := 1;
                EXIT;
            END LOOP;
        	
            IF  v_exist <> 1 THEN
                v_exist := 0;                                       
                v_message := 'There is no record of this plate number.'; 
            END IF;
         END;
      ELSIF p_serial_no IS NOT NULL
      THEN
         BEGIN                   
          FOR x IN(	--order by and loop added by aliza 07/20/2012
           --SELECT DISTINCT a.assd_no, b.plate_no, b.serial_no, c.car_company, b.model_year,
          SELECT a.assd_no, b.plate_no, b.serial_no, c.car_company, b.model_year,  
                 b.make, b.basic_color_cd, b.color_cd, b.color, b.car_company_cd, b.make_cd
            FROM gipi_polbasic a, gipi_vehicle b, giis_mc_car_company c
           WHERE a.policy_id = b.policy_id
             AND b.car_company_cd = c.car_company_cd
             AND b.serial_no LIKE p_serial_no
           ORDER BY a.policy_id DESC)
           LOOP
              v_assd_no      := x.assd_no;
              v_plate_no     := x.plate_no;
              v_serial_no    := x.serial_no;
              v_car_company  := x.car_company;
              v_model_year   := x.model_year;
              v_make         := x.make;
              v_basic_color_cd :=x.basic_color_cd;
              v_color_cd     := x.color_cd;
              v_color        :=x.color;
              --added by christian 01252013
              v_car_company_cd := x.car_company_cd; 
              v_make_cd      := x.make_cd;
              v_exist        := 1;
            EXIT;
           END LOOP;
                    
           IF  v_exist <> 1 THEN     
             v_exist := 0 ;
             v_message := 'There is no record of this serial number.'; 
           END IF;
         END;
      ELSIF p_motor_no IS NOT NULL
      THEN
         BEGIN
          
             FOR x IN(	--order by and loop added by aliza
              --SELECT DISTINCT a.assd_no, b.plate_no, b.serial_no, c.car_company, b.model_year,
              SELECT a.assd_no, b.plate_no, b.serial_no, c.car_company, b.model_year,  
                     b.make, b.basic_color_cd, b.color_cd, b.color, b.car_company_cd, b.make_cd
               -- INTO :c038.assd_no,:c038.plate_no, :c038.serial_no, :c038.car_company, :c038.model_year,
               --      :c038.make, :c038.basic_color_cd, :c038.color_cd, :c038.color--, :c038.make, :c038.basic_color_cd
                FROM gipi_polbasic a, gipi_vehicle b, giis_mc_car_company c
               WHERE a.policy_id = b.policy_id
                 AND b.car_company_cd = c.car_company_cd
                 AND b.motor_no LIKE p_motor_no
               ORDER BY a.policy_id DESC)
             LOOP
                v_assd_no    := x.assd_no;
                v_plate_no   := x.plate_no;
                v_serial_no  := x.serial_no;
                v_car_company:= x.car_company;
                v_model_year := x.model_year;
                v_make       := x.make;
                v_basic_color_cd := x.basic_color_cd;
                v_color_cd   := x.color_cd;
                v_color      := x.color;
                --added by christian 01252013
                v_car_company_cd := x.car_company_cd; 
                v_make_cd    := x.make_cd;
                v_exist      := 1;
                EXIT;
             END LOOP;

             IF v_exist <> 1 THEN
                v_exist := 0 ;
                v_message := 'There is no record of this motor number.'; 
             END IF;
        END;
      ELSE
         v_message :=
            'Please enter the plate number or select it from the list of values';
      END IF;

      IF v_basic_color_cd IS NOT NULL
      THEN
        FOR x IN (
	    --SELECT DISTINCT b.basic_color
	     SELECT b.basic_color            
           --INTO v_basic_color
           FROM gipi_vehicle a, giis_mc_color b
          WHERE b.basic_color_cd LIKE v_basic_color_cd 
            AND a.basic_color_cd = b.basic_color_cd --added by aliza 07/20/2012 to resolve ORA 1422
	        AND b.color_cd = v_color_cd order by policy_id DESC) 	    
	    LOOP--added by aliza 07/20/2012 to resolve ORA 1422
     	  v_basic_color := x.basic_color;
     	  EXIT;
        END LOOP;
      END IF;

      BEGIN
         IF p_assd_no IS NOT NULL
         THEN
            SELECT assd_name
              INTO v_assd_name
              FROM giis_assured
             WHERE assd_no = p_assd_no;
         ELSE
            v_assd_name := NULL;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_message :=
               'There is no record of this assured_number in gipi_polbasic';
      END;

      details.car_company_cd := v_car_company_cd;
      details.make_cd := v_make_cd;
      details.car_company := v_car_company;
      details.model_year := v_model_year;
      details.make := v_make;
      details.basic_color_cd := v_basic_color_cd;
      details.color_cd := v_color_cd;
      details.color := v_color;
      details.assd_no := v_assd_no;
      details.serial_no := v_serial_no;
      details.motor_no := v_motor_no;
      details.MESSAGE := v_message;
      details.basic_color := v_basic_color;
      details.assd_name := v_assd_name;
      details.serial_no := p_serial_no;
      details.motor_no := p_motor_no;
      details.plate_no := p_plate_no;
      details.assd_no := p_assd_no;
      PIPE ROW (details);
      RETURN;
   END;

   /**
   * Rey Jadlocon
   * 01-03-2012
   **/

   FUNCTION get_block_gpb_details (
      p_assd_no     gicl_no_claim_multi.assd_no%TYPE,
      p_plate_no    gicl_no_claim_multi.plate_no%TYPE)
      RETURN block_gpb_details_tab
      PIPELINED
   IS
      v_block_gpb_details   block_gpb_details_type;
   BEGIN
      FOR i
         IN (SELECT a.policy_id,
                    a.plate_no,
                    b.line_cd,
                    b.subline_cd,
                    b.iss_cd,
                    b.issue_yy,
                    b.pol_seq_no,
                    b.renew_no,
                    b.eff_date,
                    b.expiry_date
               FROM gipi_vehicle a, gipi_polbasic b
              WHERE     a.policy_id = b.policy_id
                    AND NOT EXISTS
                               (SELECT '1'
                                  FROM gicl_claims
                                 WHERE     line_Cd = b.line_cd
                                       AND subline_Cd = b.subline_Cd
                                       AND pol_iss_cd = b.iss_Cd
                                       AND issue_yy = b.issue_yy
                                       AND pol_seq_no = b.pol_seq_no
                                       AND renew_no = b.renew_no)
                    AND b.assd_no = p_assd_no
                    AND a.plate_no = p_plate_no)
      LOOP
         v_block_gpb_details.policy_id := i.policy_id;
         v_block_gpb_details.plate_no := i.plate_no;
         v_block_gpb_details.line_cd := i.line_cd;
         v_block_gpb_details.subline_cd := i.subline_cd;
         v_block_gpb_details.iss_cd := i.iss_cd;
         v_block_gpb_details.issue_yy := i.issue_yy;
         v_block_gpb_details.pol_seq_no := i.pol_seq_no;
         v_block_gpb_details.renew_no := i.renew_no;
         v_block_gpb_details.eff_date := i.eff_date;
         v_block_gpb_details.expiry_date := i.expiry_date;

         PIPE ROW (v_block_gpb_details);
      END LOOP;

      RETURN;
   END;


   /**
   * Rey Jadlocon
   * 01-03-2012
   **/
   FUNCTION on_key_commit (p_assd_no      gicl_no_claim_multi.assd_no%TYPE,
                           p_plate_no     gicl_no_claim_multi.plate_no%TYPE,
                           p_serial_no    gicl_no_claim_multi.serial_no%TYPE,
                           p_motor_no     gicl_no_claim_multi.motor_no%TYPE)
      RETURN VARCHAR2
   IS
      v_existing   NUMBER;
      v_message    VARCHAR2 (100);
   BEGIN
      BEGIN
         SELECT 1
           INTO v_existing
           FROM gicl_no_claim_multi
          WHERE     assd_no = p_assd_no
                AND plate_no = p_plate_no
                AND serial_no = p_serial_no
                AND motor_no = p_motor_no;
      END;

      IF v_existing = 1
      THEN
         v_message :=
               'The assured having the plate_no: '
            || p_plate_no
            || ' is already existing in GICL_NO_CLAIM_MULTI';
      ELSE
         v_message := NULL;
      END IF;

      RETURN v_message;
   END;

   /**
   * Rey Jadlocon
   * 01-03-2012
   **/
   --FUNCTION get_populate_noclmmultiyy_dtl(p_assd_no            gicl_no_claim_multi.assd_no%TYPE,
   --                           p_plate_no           gicl_no_claim_multi.plate_no%TYPE,
   --                           p_serial_no          gicl_no_claim_multi.serial_no%TYPE,
   --                           p_motor_no           gicl_no_claim_multi.motor_no%TYPE)
   --        RETURN get_no_claim_multi_yy_tab2 PIPELINED IS
   --            details get_no_claim_multi_yy_type2;
   --        BEGIN
   --           GICL_NO_CLAIM_MULTI_PKG.populate_noclmmultiyy_details(p_assd_no,p_plate_no,p_serial_no,p_motor_no,details);
   --            PIPE ROW(details);
   --            RETURN;
   --        END;


   /**
   * Rey Jadlocon
   * 01-04-2012
   **/
   FUNCTION get_param_value
      RETURN VARCHAR2
   IS
      v_param_value   VARCHAR2 (500);
   BEGIN
      SELECT param_value_v
        INTO v_param_value
        FROM giac_parameters
       WHERE param_name = 'BRANCH_CD';
   END;

   /**
   * Rey Jadlocon
   * 01-06-2012
   **/
   FUNCTION get_additional_dtls
      RETURN add_dtls_tab
      PIPELINED
   IS
      v_add_dtls    add_dtls_type;
      v_nc_iss_cd   giac_parameters.param_value_v%TYPE;
   BEGIN
      SELECT param_value_v
        INTO v_nc_iss_cd
        FROM giac_parameters
       WHERE param_name = 'BRANCH_CD';

      v_add_dtls.nc_iss_cd := v_nc_iss_cd;
      v_add_dtls.nc_issue_date := SYSDATE;
      v_add_dtls.nc_last_update := SYSDATE;
      v_add_dtls.nc_no_claim_id := GICL_NO_CLAIM_MULTI_PKG.get_no_clm_id;
      v_add_dtls.nc_issue_yy := TO_NUMBER (TO_CHAR (SYSDATE, 'YYYY'));
      v_add_dtls.nc_seq_no :=
         GICL_NO_CLAIM_MULTI_PKG.GEN_NC_NO (
            v_nc_iss_cd,
            TO_NUMBER (TO_CHAR (SYSDATE, 'YYYY')));
      v_add_dtls.nc_no_claim_no :=
            v_nc_iss_cd
         || ' - '
         || TO_NUMBER (TO_CHAR (SYSDATE, 'YYYY'))
         || ' - '
         || TO_CHAR (
               GICL_NO_CLAIM_MULTI_PKG.GEN_NC_NO (
                  v_nc_iss_cd,
                  TO_NUMBER (TO_CHAR (SYSDATE, 'YYYY'))),
               '0000009');
      PIPE ROW (v_add_dtls);
      RETURN;
   END;


   /**
   *  Rey Jadlocon
   * 01-10-2012
   **/
   PROCEDURE set_gicl_no_claim_multi (p_no_claim_id       NUMBER,
                                      p_nc_iss_cd         VARCHAR2,
                                      p_nc_issue_yy       NUMBER,
                                      p_nc_seq_no         NUMBER,
                                      p_assd_no           NUMBER,
                                      p_no_issue_date     date,
                                      p_motor_no          VARCHAR2,
                                      p_serial_no         VARCHAR2,
                                      p_plate_no          VARCHAR2,
                                      p_model_year        VARCHAR2,
                                      p_make_cd           NUMBER,
                                      p_motcar_comp_cd    NUMBER,
                                      p_basic_color_cd    VARCHAR2,
                                      p_color_cd          NUMBER,
                                      p_cancel_tag        VARCHAR2,
                                      p_remarks           VARCHAR2,
                                      p_cpi_rec_no        NUMBER,
                                      p_cpi_branch_cd     VARCHAR2,
                                      p_user_id           VARCHAR2)
   IS
   BEGIN
      MERGE INTO gicl_no_claim_multi
           USING DUAL
              ON (no_claim_id = p_no_claim_id)
      WHEN NOT MATCHED
      THEN
         INSERT     (no_claim_id,
                     nc_iss_cd,
                     nc_issue_yy,
                     nc_seq_no,
					 assd_no,
                     no_issue_date,
                     motor_no,
                     serial_no,
                     plate_no,
                     model_year,
                     make_cd,
                     motcar_comp_cd,
                     basic_color_cd,
                     color_cd,
                     cancel_tag,
                     remarks,
                     cpi_rec_no,
                     cpi_branch_cd,
                     user_id,
                     nc_issue_date)
             VALUES (p_no_claim_id,
                     p_nc_iss_cd,
                     p_nc_issue_yy,
                     p_nc_seq_no,
					 p_assd_no,            
					 p_no_issue_date,    
					 p_motor_no,          
					 p_serial_no,        
					 p_plate_no,          
					 p_model_year,        
					 p_make_cd,            
					 p_motcar_comp_cd,
					 p_basic_color_cd,
					 p_color_cd,          
					 p_cancel_tag,        
					 p_remarks,            
					 p_cpi_rec_no,        
					 p_cpi_branch_cd,    
					 p_user_id,            
				  	  SYSDATE -- CHANGED TO SYSDATE
                         )
      WHEN MATCHED
      THEN
         UPDATE SET nc_iss_cd = p_nc_iss_cd,
                    nc_issue_yy = p_nc_issue_yy,
                    nc_seq_no = p_nc_seq_no,
                    assd_no = p_assd_no,
                    no_issue_date = p_no_issue_date,
                    motor_no = p_motor_no,
                    serial_no = p_serial_no,
                    plate_no = p_plate_no,
                    model_year = p_model_year,
                    make_cd = p_make_cd,
                    motcar_comp_cd = p_motcar_comp_cd,
                    basic_color_cd = p_basic_color_cd,
                    color_cd = p_color_cd,
                    cancel_tag = p_cancel_tag,
                    remarks = p_remarks,
                    cpi_rec_no = p_cpi_rec_no,
                    cpi_branch_cd = p_cpi_branch_cd,
                    user_id = p_user_id,
                    last_update = SYSDATE
                   -- ,nc_issue_date = p_nc_issue_date
					;
   END;

   /**
   * Rey Jadlocon
   * 05-04-2012
   **/
   FUNCTION get_update_details (p_no_claim_id NUMBER)
      RETURN update_details_tab
      PIPELINED
   IS
      update_details   update_details_type;
   BEGIN
      FOR i IN (SELECT a.no_claim_id,
                       a.nc_iss_cd,
                       a.nc_issue_yy,
                       a.nc_seq_no,
                       a.assd_no,
                       a.no_issue_date,
                       a.motor_no,
                       a.serial_no,
                       a.plate_no,
                       a.model_year,
                       a.make_cd,
                       a.motcar_comp_cd,
                       a.basic_color_cd,
                       a.color_cd,
                       a.cancel_tag,
                       a.remarks,
                       a.last_update,
                       a.nc_issue_date
                  FROM gicl_no_claim_multi a
                 WHERE no_claim_id = p_no_claim_id)
      LOOP
         update_details.no_claim_id := i.no_claim_id;
         update_details.nc_iss_cd := i.nc_iss_cd;
         update_details.nc_issue_yy := i.nc_issue_yy;
         update_details.nc_seq_no := i.nc_seq_no;
         update_details.assd_no := i.assd_no;
         update_details.no_issue_date := i.no_issue_date;
         update_details.motor_no := i.motor_no;
         update_details.serial_no := i.serial_no;
         update_details.plate_no := i.plate_no;
         update_details.model_year := i.model_year;
         update_details.make_cd := i.make_cd;
         update_details.motcar_comp_cd := i.motcar_comp_cd;
         update_details.basic_color_cd := i.basic_color_cd;
         update_details.color_cd := i.color_cd;
         update_details.cancel_tag := i.cancel_tag;
         update_details.remarks := i.remarks;
         update_details.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         update_details.nc_issue_date := i.nc_issue_date;
         update_details.nc_last_update := SYSDATE;
         PIPE ROW (update_details);
      END LOOP;

      RETURN;
   END;

   FUNCTION GET_POL_LIST_BY_PLATE_NO (
      P_PLATE_NO gicl_no_claim_multi.PLATE_NO%TYPE)
      RETURN no_claim_policy_list_tab
      PIPELINED
   IS
      v_no_claim_policy   no_claim_policy_list_tYPE;
   BEGIN
      FOR I
         IN (select * from (SELECT a.policy_id,
                    a.plate_no,
                    b.line_cd,
                    b.subline_cd,
                    b.iss_cd,
                    b.issue_yy,
                    b.pol_seq_no,
                    b.renew_no,
                    b.eff_date,
                    b.expiry_date,b.line_cd
                        || '-'
                        || b.subline_cd
                        || '-'
                        || b.iss_cd
                        || '-'
                        || b.issue_yy
                        || '-'
                        || TO_CHAR(b.pol_seq_no,'0000009')
                        || '-'
                        || TO_CHAR(b.renew_no,'09') policy_no
               FROM gipi_vehicle a, gipi_polbasic b
              WHERE     a.policy_id = b.policy_id
                   /*   AND NOT EXISTS
                             (SELECT '1'
                                  FROM gicl_claims
                                 WHERE     line_Cd = b.line_cd
                                       AND subline_Cd = b.subline_Cd
                                       AND pol_iss_cd = b.iss_Cd
                                       AND issue_yy = b.issue_yy
                                       AND pol_seq_no = b.pol_seq_no
                                       AND renew_no = b.renew_no)*/) where plate_no = p_plate_no 
                                       AND NOT EXISTS
                             (SELECT '1'
                                  FROM gicl_claims
                                 WHERE     plate_no = p_plate_no
                                      )
									   )
      LOOP
         v_no_claim_policy.policy_no := i.policy_no;
         v_no_claim_policy.policy_id := i.policy_id;
         v_no_claim_policy.plate_no := i.plate_no;
         v_no_claim_policy.line_cd := i.line_cd;
         v_no_claim_policy.subline_cd := i.subline_cd;
         v_no_claim_policy.iss_cd := i.iss_cd;
         v_no_claim_policy.issue_yy := i.issue_yy;
         v_no_claim_policy.pol_seq_no := i.pol_seq_no;
         v_no_claim_policy.renew_no := i.renew_no;
         v_no_claim_policy.eff_date := i.eff_date;
         v_no_claim_policy.expiry_date := i.expiry_date;
         v_no_claim_policy.incept_date := i.eff_date;
         v_no_claim_policy.line_cd_mc := giisp.v ('LINE_CODE_MC');
         v_no_claim_policy.str_expiry_date :=
            TO_CHAR (i.expiry_date, 'mm-dd-yyyy');
         v_no_claim_policy.str_incept_date :=
            TO_CHAR (i.eff_date, 'mm-dd-yyyy');
         PIPE ROW (v_no_claim_policy);
      END LOOP;
   END;
   
   FUNCTION get_policy_count(p_plate_no   gicl_no_claim_multi.plate_no%TYPE)
   RETURN NUMBER AS
      v_count     NUMBER;
    BEGIN
       SELECT COUNT (*)
         INTO v_count
         FROM (SELECT DISTINCT pol.line_cd, pol.subline_cd, pol.iss_cd, pol.issue_yy, pol.pol_seq_no, pol.renew_no
      FROM gipi_polbasic pol, gipi_vehicle veh
     WHERE veh.plate_no = p_plate_no
        AND pol.policy_id = veh.policy_id);

       RETURN v_count;
    END;
END GICL_NO_CLAIM_MULTI_PKG;
/


