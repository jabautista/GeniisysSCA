CREATE OR REPLACE PACKAGE BODY CPI.giis_line_pkg
AS
   FUNCTION get_line_cd (p_line_name IN giis_line.line_name%TYPE)
      RETURN VARCHAR2
   IS
      v_line_cd   giis_line.line_cd%TYPE;
   BEGIN
      FOR i IN (SELECT NVL (menu_line_cd, line_cd) line_cd
                  FROM giis_line
                 WHERE line_name = p_line_name)
      LOOP
         v_line_cd := i.line_cd;
         EXIT;
      END LOOP;

      RETURN v_line_cd;
   END get_line_cd;

   /*FUNCTION get_line_name (p_line_cd IN GIIS_LINE.line_cd%TYPE)
   RETURN VARCHAR2
   IS
    v_line_name GIIS_LINE.line_name%TYPE;
   BEGIN
    FOR i IN (
     SELECT line_name
       FROM GIIS_LINE
      WHERE line_cd = p_line_cd)
    LOOP
     v_line_name := i.line_name;
     EXIT;
    END LOOP;

    RETURN v_line_name;
   END get_line_name;*/
   FUNCTION get_pack_pol_flag (p_line_cd IN giis_line.line_cd%TYPE)
      RETURN VARCHAR2
   IS
      v_pack_pol_flag   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT NVL (pack_pol_flag, 'N') pack_pol_flag
                  FROM giis_line
                 WHERE line_cd = p_line_cd)
      LOOP
         v_pack_pol_flag := i.pack_pol_flag;
         EXIT;
      END LOOP;

      -- edited by d.alcantara, 08/16/2011
      -- added condition to compare to menu_line_cd
      IF v_pack_pol_flag = NULL
      THEN
         FOR i IN (SELECT NVL (pack_pol_flag, 'N') pack_pol_flag
                     FROM giis_line
                    WHERE menu_line_cd = p_line_cd)
         LOOP
            v_pack_pol_flag := i.pack_pol_flag;
            EXIT;
         END LOOP;
      END IF;

      RETURN v_pack_pol_flag;
   END get_pack_pol_flag;

   -- moved from giis_lines_pkg

   /*
   **  Created by   :  Bryan Joseph G. Abuluyan
   **  Date Created :  January 08, 2010
   **  Reference By :  for LOVHelper
   **  Description  : This retrieves the basic information default value.
   */

   /*
   ** Modified by: Whofeih
   ** Date Modified: 02/12/2010
   */
   FUNCTION get_line_listing (p_module_id giis_modules.module_id%TYPE)
      RETURN line_listing_tab PIPELINED
   IS
      v_line   line_listing_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT b.line_cd, d.line_name, d.menu_line_cd, d.SEQUENCE
                     FROM giis_users a,
                          giis_user_grp_line b,
                          giis_user_grp_modules c,
                          giis_line d
                    WHERE a.user_grp = b.user_grp
                      AND a.user_grp = c.user_grp
                      AND b.tran_cd = c.tran_cd
                      AND b.line_cd = d.line_cd
                      AND a.user_id = USER
                      AND c.module_id = p_module_id
                      AND d.pack_pol_flag = 'N'
          UNION
          SELECT DISTINCT b.line_cd, d.line_name, d.menu_line_cd, d.SEQUENCE
                     FROM giis_users a,
                          giis_user_line b,
                          giis_user_modules c,
                          giis_line d
                    WHERE a.user_id = b.userid
                      AND a.user_id = c.userid
                      AND b.tran_cd = c.tran_cd
                      AND b.line_cd = d.line_cd
                      AND a.user_id = USER
                      AND c.module_id = p_module_id
                      AND d.pack_pol_flag = 'N'
                 --ORDER BY 2) -- andrew - 10.04.2010 - added sort
          ORDER BY        4)    -- grace 11.2.2010 - added new column sequence
      LOOP
         v_line.line_cd := i.line_cd;
         v_line.line_name := i.line_name;
         v_line.menu_line_cd := i.menu_line_cd;
         -- andrew - 10.05.2010 - added this line
         PIPE ROW (v_line);
      END LOOP;

      RETURN;
   END get_line_listing;

   FUNCTION get_pack_line_list (
      p_line_cd   giis_line_subline_coverages.line_cd%TYPE
   )
      RETURN line_listing_tab PIPELINED
   IS
      v_line   line_listing_type;
   BEGIN
      FOR i IN (SELECT DISTINCT b.pack_line_cd line_cd, a.line_name
                           FROM giis_line a, giis_line_subline_coverages b
                          WHERE b.line_cd = p_line_cd
                            AND a.line_cd = b.pack_line_cd
                       ORDER BY SEQUENCE)
      -- grace 11.2.2010 - added new column sequence
      LOOP
         v_line.line_cd := i.line_cd;
         v_line.line_name := i.line_name;
         PIPE ROW (v_line);
      END LOOP;

      RETURN;
   END get_pack_line_list;

   FUNCTION get_checked_line_list (
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_user_id     VARCHAR2,
      p_module_id   giis_user_grp_modules.module_id%TYPE
   )
      RETURN line_listing_tab PIPELINED
   IS
      v_line   line_listing_type;
   BEGIN
      FOR i IN
         (SELECT   line_cd, line_name, pack_pol_flag
              FROM giis_line
             WHERE check_user_per_line2 (line_cd,
                                         p_iss_cd,
                                         p_module_id,
                                         p_user_id
                                        ) = 1
               AND pack_pol_flag != 'Y'
          --ORDER BY line_name)
          ORDER BY SEQUENCE)    -- grace 11.2.2010 - added new column sequence
      LOOP
         v_line.line_cd := i.line_cd;
         v_line.line_name := i.line_name;
         v_line.pack_pol_flag := i.pack_pol_flag;
         PIPE ROW (v_line);
      END LOOP;

      RETURN;
   END get_checked_line_list;

   FUNCTION get_giis_line_list
      RETURN line_listing_tab PIPELINED
   IS
      v_giis_line   line_listing_type;
   BEGIN
      FOR i IN (SELECT   line_cd, line_name
                    FROM giis_line
                ORDER BY line_cd)
      LOOP
         v_giis_line.line_cd := i.line_cd;
         v_giis_line.line_name := i.line_name;
         PIPE ROW (v_giis_line);
      END LOOP;

      RETURN;
   END get_giis_line_list;

   FUNCTION get_line_name (p_line_cd IN giis_line.line_cd%TYPE)
      RETURN VARCHAR2
   IS
      v_line_name   giis_line.line_name%TYPE;
   BEGIN
      FOR i IN (SELECT line_name
                  FROM giis_line
                 WHERE line_cd = p_line_cd)
      LOOP
         v_line_name := i.line_name;
         EXIT;
      END LOOP;

      RETURN v_line_name;
   END get_line_name;

   FUNCTION get_line_code (v_line_name VARCHAR2)
      RETURN VARCHAR2
   IS
      v_line_code   giis_line.line_cd%TYPE;
   BEGIN
      FOR i IN (SELECT line_cd
                  FROM giis_line
                 WHERE line_name = v_line_name)
      LOOP
         v_line_code := i.line_cd;
         EXIT;
      END LOOP;

      RETURN v_line_code;
   END get_line_code;

   PROCEDURE get_param_line_cd (
      v_quote_fire_cd       OUT   giis_line.line_cd%TYPE,
      v_quote_motor_cd      OUT   giis_line.line_cd%TYPE,
      v_quote_accident_cd   OUT   giis_line.line_cd%TYPE,
      v_quote_hull_cd       OUT   giis_line.line_cd%TYPE,
      v_quote_cargo_cd      OUT   giis_line.line_cd%TYPE,
      v_quote_casualty_cd   OUT   giis_line.line_cd%TYPE,
      v_quote_engrng_cd     OUT   giis_line.line_cd%TYPE,
      v_quote_surety_cd     OUT   giis_line.line_cd%TYPE,
      v_quote_aviation_cd   OUT   giis_line.line_cd%TYPE
   )
   IS
      v_no_dta_found   VARCHAR2 (1);
   BEGIN
      SELECT param_value_v
        INTO v_quote_fire_cd
        FROM giis_parameters
       WHERE param_name = 'LINE_CODE_FI';

      SELECT param_value_v
        INTO v_quote_motor_cd
        FROM giis_parameters
       WHERE param_name = 'LINE_CODE_MC';

      SELECT param_value_v
        INTO v_quote_accident_cd
        FROM giis_parameters
       WHERE param_name = 'LINE_CODE_AC';

      SELECT param_value_v
        INTO v_quote_hull_cd
        FROM giis_parameters
       WHERE param_name = 'LINE_CODE_MH';

      SELECT param_value_v
        INTO v_quote_cargo_cd
        FROM giis_parameters
       WHERE param_name = 'LINE_CODE_MN';

      SELECT param_value_v
        INTO v_quote_casualty_cd
        FROM giis_parameters
       WHERE param_name = 'LINE_CODE_CA';

      SELECT param_value_v
        INTO v_quote_engrng_cd
        FROM giis_parameters
       WHERE param_name = 'LINE_CODE_EN';

      SELECT param_value_v
        INTO v_quote_surety_cd
        FROM giis_parameters
       WHERE param_name = 'LINE_CODE_SU';

      SELECT param_value_v
        INTO v_quote_aviation_cd
        FROM giis_parameters
       WHERE param_name = 'LINE_CODE_AV';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_no_dta_found := 'Y';
   /* transferred to forms
   **  MESSAGE('No parameter LINE_CD_'||LTRIM(:V1407.LINE_CD)|| ' found. Please do the necessary changes.');
      **  BELL;
      **  AISE FORM_TRIGGER_FAILURE;
   */
   END;

   FUNCTION get_pack_line_list1 (
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN line_listing_tab PIPELINED
   IS
      v_line   line_listing_type;
   BEGIN
      FOR i IN (SELECT   line_cd line_cd, line_name line_name
                    FROM giis_line
                   WHERE check_user_per_line2 (line_cd,
                                               p_iss_cd,
                                               p_module_id,
                                               p_user_id
                                              ) = 1
                     AND pack_pol_flag = 'Y'
                ORDER BY line_cd)
      LOOP
         v_line.line_cd := i.line_cd;
         v_line.line_name := i.line_name;
         PIPE ROW (v_line);
      END LOOP;

      RETURN;
   END get_pack_line_list1;

   FUNCTION get_checked_line_issource_list (
      p_user_id     VARCHAR2,
      p_module_id   giis_user_grp_modules.module_id%TYPE
   )
      RETURN line_listing_tab PIPELINED
   IS
      v_line   line_listing_type;
   BEGIN
      FOR i IN (SELECT   a.line_cd, a.line_name, b.iss_cd, b.iss_name
                    FROM giis_line a, giis_issource b
                   WHERE a.pack_pol_flag != 'Y'
                     AND check_user_per_line1 (a.line_cd,
                                               b.iss_cd,
                                               p_user_id,
                                               p_module_id
                                              ) = 1
                ORDER BY a.line_cd)
      LOOP
         v_line.line_cd := i.line_cd;
         v_line.line_name := i.line_name;
         v_line.iss_cd := i.iss_cd;
         v_line.iss_name := i.iss_name;
         PIPE ROW (v_line);
      END LOOP;

      RETURN;
   END get_checked_line_issource_list;

   FUNCTION get_menu_line_cd (p_line_cd giis_line.line_cd%TYPE)
      RETURN VARCHAR2
   IS
      v_menu_line_cd   giis_line.menu_line_cd%TYPE;
   BEGIN
      SELECT NVL (menu_line_cd, line_cd)
        INTO v_menu_line_cd
        FROM giis_line
       WHERE line_cd = p_line_cd;

      RETURN v_menu_line_cd;
   END get_menu_line_cd;

    /* Added by D. Alcantara
   * Sept. 27, 2010
   *
   */
   FUNCTION get_line_list_lostbid (
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN line_listing_tab PIPELINED
   IS
      v_linelist   line_listing_type;
   BEGIN
      FOR i IN (SELECT line_cd, line_name
                  FROM giis_line
                 WHERE line_cd =
                          DECODE (check_user_per_line2 (line_cd,
                                                        NULL,
                                                        p_module_id,
                                                        p_user_id
                                                       ),
                                  1, line_cd,
                                  NULL
                                 ))
      LOOP
         v_linelist.line_cd := i.line_cd;
         v_linelist.line_name := i.line_name;
         PIPE ROW (v_linelist);
      END LOOP;

      RETURN;
   END get_line_list_lostbid;

   /*
   **Added by angelo
   **01.11.2011
   **temp function for getting existing policy lines for an assured
   */
   FUNCTION get_pol_lines_for_assd (p_assd_no giis_assured.assd_no%TYPE)
      RETURN line_listing_tab PIPELINED
   IS
      v_linelist   line_listing_type;
   BEGIN
      FOR i IN (SELECT DISTINCT c.line_cd, c.line_name
                           FROM gipi_polbasic b, giis_assured a, giis_line c
                          WHERE a.assd_no = b.assd_no
                            AND b.line_cd = c.line_cd
                            AND a.assd_no = p_assd_no
                       ORDER BY line_name)
      LOOP
         v_linelist.line_name := i.line_name;
         PIPE ROW (v_linelist);
      END LOOP;

      RETURN;
   END get_pol_lines_for_assd;

/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : February 18, 2011
**  Reference By  : GIPIS001 - Par Listing - Policy
**                    GIPIS058 - Par Listing - Endorsement
**  Description   : Function returns user accessible line_cd for PAR
*/
   FUNCTION get_line_list (
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN line_listing_tab PIPELINED
   IS
      v_line   line_listing_type;
      v_iss_cd_ri    giis_issource.iss_cd%TYPE := NVL(GIISP.v('ISS_CD_RI'), 'RI'); --marco - 08.13.2014
   BEGIN
      FOR i IN (SELECT DISTINCT b.line_cd, d.line_name, d.menu_line_cd,
                                d.SEQUENCE
                           FROM giis_users a,
                                giis_user_grp_line b,
                                giis_user_grp_modules c,
                                giis_line d
                          WHERE a.user_grp = b.user_grp
                            AND a.user_grp = c.user_grp
                            AND b.tran_cd = c.tran_cd
                            AND b.line_cd = d.line_cd
                            AND a.user_id = p_user_id
                            AND c.module_id = p_module_id
                            --AND d.pack_pol_flag = 'N' --benjo 09.07.2016 SR-5604
                            AND DECODE(p_module_id, 'GIISS006B', d.pack_pol_flag, 'N') = d.pack_pol_flag --benjo 09.07.2016 SR-5604
                            AND DECODE(p_module_id, 'GIRIS005', b.iss_cd, v_iss_cd_ri) = v_iss_cd_ri --marco - 08.13.2014 - restrict access to RI only
                UNION
                SELECT DISTINCT b.line_cd, d.line_name, d.menu_line_cd,
                                d.SEQUENCE
                           FROM giis_users a,
                                giis_user_line b,
                                giis_user_modules c,
                                giis_line d
                          WHERE a.user_id = b.userid
                            AND a.user_id = c.userid
                            AND b.tran_cd = c.tran_cd
                            AND b.line_cd = d.line_cd
                            AND a.user_id = p_user_id
                            AND c.module_id = p_module_id
                            --AND d.pack_pol_flag = 'N' --benjo 09.07.2016 SR-5604
                            AND DECODE(p_module_id, 'GIISS006B', d.pack_pol_flag, 'N') = d.pack_pol_flag --benjo 09.07.2016 SR-5604
                            AND DECODE(p_module_id, 'GIRIS005', b.iss_cd, v_iss_cd_ri) = v_iss_cd_ri --marco - 08.13.2014 - restrict access to RI only
                       ORDER BY 4)
      LOOP
         v_line.line_cd := i.line_cd;
         v_line.line_name := i.line_name;
         v_line.menu_line_cd := i.menu_line_cd;
         PIPE ROW (v_line);
      END LOOP;

      RETURN;
   END get_line_list;

/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : February 18, 2011
**  Reference By  : GIPIS001A - Package Par Listing - Policy
**                    GIPIS058A - Package Par Listing - Endorsement
**  Description   : Function returns user accessible line_cd for package PAR
*/
   FUNCTION get_package_line_list (
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN line_listing_tab PIPELINED
   IS
      v_line   line_listing_type;
   BEGIN
      FOR i IN (SELECT DISTINCT b.line_cd, d.line_name, d.menu_line_cd,
                                d.SEQUENCE
                           FROM giis_users a,
                                giis_user_grp_line b,
                                giis_user_grp_modules c,
                                giis_line d
                          WHERE a.user_grp = b.user_grp
                            AND a.user_grp = c.user_grp
                            AND b.tran_cd = c.tran_cd
                            AND b.line_cd = d.line_cd
                            AND a.user_id = p_user_id
                            AND c.module_id = p_module_id
                            AND d.pack_pol_flag = 'Y'
                UNION
                SELECT DISTINCT b.line_cd, d.line_name, d.menu_line_cd,
                                d.SEQUENCE
                           FROM giis_users a,
                                giis_user_line b,
                                giis_user_modules c,
                                giis_line d
                          WHERE a.user_id = b.userid
                            AND a.user_id = c.userid
                            AND b.tran_cd = c.tran_cd
                            AND b.line_cd = d.line_cd
                            AND a.user_id = p_user_id
                            AND c.module_id = p_module_id
                            AND d.pack_pol_flag = 'Y'
                       ORDER BY 4)
      LOOP
         v_line.line_cd := i.line_cd;
         v_line.line_name := i.line_name;
         v_line.menu_line_cd := i.menu_line_cd;
         PIPE ROW (v_line);
      END LOOP;

      RETURN;
   END get_package_line_list;

/*
**  Created by      : Veronica V. Raymundo
**  Date Created  : February 21, 2011
**  Reference By  : (GIPIS050A- Package Par Creation), (GIPIS056A- Package Par Creation - Endt)
**  Description   : Function returns valid line_cd and issue_source listing for package par
*/
   FUNCTION get_checked_pack_line_issource (
      p_user_id     VARCHAR2,
      p_module_id   giis_user_grp_modules.module_id%TYPE
   )
      RETURN line_listing_tab PIPELINED
   IS
      v_line   line_listing_type;
   BEGIN
      FOR i IN (SELECT   a.line_cd, a.line_name, b.iss_cd, b.iss_name
                    FROM giis_line a, giis_issource b
                   WHERE a.pack_pol_flag = 'Y'
                --AND CHECK_USER_PER_LINE2(A.line_cd, b.iss_cd, p_module_id, p_user_id) = 1
                ORDER BY a.line_cd)
      LOOP
         v_line.line_cd := i.line_cd;
         v_line.line_name := i.line_name;
         v_line.iss_cd := i.iss_cd;
         v_line.iss_name := i.iss_name;
         PIPE ROW (v_line);
      END LOOP;

      RETURN;
   END get_checked_pack_line_issource;

/*
**  Created by      : Veronica V. Raymundo
**  Date Created  : February 21, 2011
**  Reference By  : (GIPIS050A- Package Par Creation), (GIPIS056A- Package Par Creation - Endt)
**  Description   : Function returns valid line listing for package par
*/
   FUNCTION get_pack_line_listing (
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN line_listing_tab PIPELINED
   IS
      v_line   line_listing_type;
   BEGIN
      FOR i IN (SELECT   line_cd line_cd, line_name line_name
                    FROM giis_line
                   WHERE check_user_per_line2 (line_cd,
                                               p_iss_cd,
                                               p_module_id,
                                               p_user_id
                                              ) = 1
                     AND pack_pol_flag = 'Y'
                ORDER BY line_cd)
      LOOP
         v_line.line_cd := i.line_cd;
         v_line.line_name := i.line_name;
         PIPE ROW (v_line);
      END LOOP;

      RETURN;
   END get_pack_line_listing;

   /*
   **  Created by    : Robert John Virrey
   **  Date Created  : September 09, 2011
   **  Reference By  : (GIEXS001- Extract Expiring Policies)
   */
   FUNCTION get_line_cd_flag (
      p_user_id     giis_users.user_id%TYPE,
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE
   )
      RETURN line_listing_tab PIPELINED
   IS
      v_line   line_listing_type;
   BEGIN
      FOR i IN (SELECT line_cd, line_name, pack_pol_flag
                  FROM giis_line
                 WHERE line_cd =
                          DECODE (check_user_per_line1 (line_cd,
                                                        p_iss_cd,
                                                        p_user_id,
                                                        p_module_id
                                                       ),
                                  1, line_cd,
                                  NULL
                                 )
                   AND NVL (non_renewal_tag, 'N') <> 'Y')
      LOOP
         v_line.line_cd := i.line_cd;
         v_line.line_name := i.line_name;
         v_line.pack_pol_flag := i.pack_pol_flag;
         PIPE ROW (v_line);
      END LOOP;

      RETURN;
   END get_line_cd_flag;

   /*
   **  Created by    : Robert John Virrey
   **  Date Created  : September 12, 2011
   **  Reference By  : (GIEXS001- Extract Expiring Policies)
   */
   PROCEDURE validate_pol_line_cd (
      p_pol_line_cd          IN       giis_line.line_cd%TYPE,
      p_pol_subline_cd       IN       giis_subline.subline_cd%TYPE,
      p_pol_iss_cd           IN       giis_user_grp_line.iss_cd%TYPE,
      p_line_cd              IN       giis_user_grp_line.line_cd%TYPE,
      p_iss_cd               IN       giis_user_grp_line.iss_cd%TYPE,
      p_user_id              IN       giis_users.user_id%TYPE,
      p_module_id            IN       giis_user_grp_modules.module_id%TYPE,
      p_line_pack_pol_flag   OUT      giis_line.pack_pol_flag%TYPE,
      p_msg                  OUT      VARCHAR2
   )
   IS
      v_line    giis_line.line_cd%TYPE   := NULL;
      v_exist   VARCHAR2 (1)             := 'N';
   BEGIN
      FOR line IN (SELECT line_name, pack_pol_flag
                     FROM giis_line
                    WHERE line_cd = p_pol_line_cd)	--Gzelle 06242015 SR3918
                      /*start - AND check_user_per_line1 (p_pol_line_cd, --marco - 08.08.2014 - changed from p_line_cd
                                                p_iss_cd,
                                                p_user_id,
                                                p_module_id
                                               ) = 1)*/	-- end commented out by Gzelle 06242015 SR3918
      LOOP
         v_exist := 'Y';
         p_line_pack_pol_flag := line.pack_pol_flag;
         EXIT;
      END LOOP;

      IF v_exist = 'N'
      THEN
         p_msg := '1';
      ELSE		--added by Gzelle 06242015 SR3918
        IF  check_user_per_line2 (p_pol_line_cd, p_iss_cd, p_module_id, p_user_id) <> 1
        THEN
            p_msg := '3'; 
        END IF;	--end
      END IF;

      IF p_pol_subline_cd IS NOT NULL
      THEN
         FOR a IN (SELECT line_cd
                     FROM giis_subline
                    WHERE subline_cd = p_pol_subline_cd
                      AND line_cd = p_pol_line_cd
                      AND check_user_per_line1 (p_pol_line_cd,
                                                p_pol_iss_cd,
                                                p_user_id,
                                                p_module_id
                                               ) = 1)
         LOOP
            v_line := a.line_cd;
            EXIT;
         END LOOP;

         p_msg := '2';
         RETURN;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_line_pack_pol_flag := 'Y';
         p_msg := '3';
      WHEN TOO_MANY_ROWS
      THEN
         p_line_pack_pol_flag := 'Y';
         p_msg := '4';
   END validate_pol_line_cd;

   FUNCTION get_all_line_list (
      p_module_id    giis_modules.module_id%TYPE,
      p_pol_iss_cd   VARCHAR2, --joanne
      p_user_id      giis_users.user_id%TYPE
   )
      RETURN line_listing_tab PIPELINED
   IS
      v_line   line_listing_type;
   BEGIN
      FOR i IN (SELECT line_cd line_cd, line_name line_name, menu_line_cd
                  FROM giis_line
                 WHERE line_cd =
                          DECODE (check_user_per_line2 (line_cd,
                                                        p_pol_iss_cd,
                                                        p_module_id,
                                                        p_user_id
                                                       ),
                                  1, line_cd,
                                  NULL
                                 )
                 ORDER BY line_cd)
      LOOP
         v_line.line_cd := i.line_cd;
         v_line.line_name := i.line_name;
         v_line.menu_line_cd := i.menu_line_cd;
         PIPE ROW (v_line);
      END LOOP;

      RETURN;
   END get_all_line_list;

   /*
   **  Created by    : Robert John Virrey
   **  Date Created  : December 14, 2011
   **  Reference By  : (GICLS026- No Claim)
   **  Description   : LINE_CD_LOV
   */
   FUNCTION get_polbasic_line_list (    -- parameters added by shan 10.14.2013
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN line_listing_tab PIPELINED
   IS
      v_line   line_listing_type;
   BEGIN
      FOR i IN (SELECT a.line_cd, a.line_name
                  FROM giis_line a
                 WHERE EXISTS (SELECT 'X'
                                 FROM gipi_polbasic b
                                WHERE b.line_cd = a.line_cd)
                   AND check_user_per_line2 (line_cd,
                                             p_iss_cd,
                                             p_module_id,
                                             p_user_id
                                            ) = 1)
      LOOP
         v_line.line_cd := i.line_cd;
         v_line.line_name := i.line_name;
         PIPE ROW (v_line);
      END LOOP;

      RETURN;
   END get_polbasic_line_list;

   PROCEDURE validate_purge_line_cd (
      p_line_cd        IN       giis_line.line_cd%TYPE,
      p_subline_cd     IN OUT   giis_subline.subline_cd%TYPE,
      p_subline_name   OUT      giis_subline.subline_name%TYPE,
      p_iss_cd         IN       giis_issource.iss_cd%TYPE,
      p_line_name      OUT      giis_line.line_name%TYPE,
      p_module_id      IN       giis_modules.module_id%TYPE,
      p_found          OUT      VARCHAR2
   )
   IS
      v_line_cd     VARCHAR2 (20);
      v_line_name   VARCHAR2 (100);
   BEGIN
      SELECT line_name
        INTO v_line_name
        FROM giis_line
       WHERE line_cd = p_line_cd
         AND line_cd =
                DECODE (check_user_per_line (line_cd, p_iss_cd, p_module_id),
                        1, line_cd,
                        NULL
                       );

      p_line_name := v_line_name;

      IF v_line_name IS NULL
      THEN
         p_found := 'N';
      ELSE
         p_found := 'Y';
      END IF;

      IF p_subline_cd IS NOT NULL
      THEN
         FOR i IN (SELECT line_cd, subline_name
                     FROM giis_subline
                    WHERE subline_cd = p_subline_cd
                      AND line_cd = p_line_cd
                      AND line_cd =
                             DECODE (check_user_per_line (line_cd,
                                                          p_iss_cd,
                                                          p_module_id
                                                         ),
                                     1, line_cd,
                                     NULL
                                    ))
         LOOP
            v_line_cd := i.line_cd;
            p_subline_name := i.subline_name;
         END LOOP;

         IF v_line_cd IS NULL
         THEN
            p_subline_cd := NULL;
         END IF;
      END IF;
   END;

   --bonok :: 04.10.2012 :: line LOV for GIEXS006
   FUNCTION get_exp_rep_line_lov (
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_module_id   giis_user_grp_modules.module_id%TYPE,
      p_user_id     GIIS_USERS.USER_ID%TYPE
   )
      RETURN line_listing_tab PIPELINED
   IS
      v_line   line_listing_type;
   BEGIN
      FOR i IN (SELECT line_cd, line_name
                  FROM giis_line
                 WHERE check_user_per_line2 (line_cd, p_iss_cd, p_module_id, p_user_id) = 1
                 ORDER BY line_name)
      LOOP
         v_line.line_cd := i.line_cd;
         v_line.line_name := i.line_name;
         PIPE ROW (v_line);
      END LOOP;
   END get_exp_rep_line_lov;

   --bonok :: 04.17.2012 :: validate line for GIEXS006
   FUNCTION validate_line_cd_giexs006 (
      p_line_cd     giis_line.line_cd%TYPE,
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_module_id   giis_user_grp_modules.module_id%TYPE
   )
      RETURN line_listing_tab PIPELINED
   IS
      v_line   line_listing_type;
   BEGIN
      FOR i IN (SELECT line_cd, line_name
                  FROM giis_line
                 WHERE line_cd = p_line_cd
                   AND check_user_per_line (line_cd, p_iss_cd, p_module_id) =
                                                                             1)
      LOOP
         v_line.line_cd := i.line_cd;
         v_line.line_name := i.line_name;
         PIPE ROW (v_line);
      END LOOP;
   END validate_line_cd_giexs006;

   -- Dwight :: 06.15.2012 :: get all records.
   FUNCTION get_giis_line_group (
      p_line_cd          giis_line.line_cd%TYPE,
      p_line_name        giis_line.line_name%TYPE,
      p_acct_line_cd     giis_line.acct_line_cd%TYPE,
      p_menu_line_cd     giis_line.menu_line_cd%TYPE,
      p_recaps_line_cd   giis_line.recaps_line_cd%TYPE,
      p_min_prem_amt     giis_line.min_prem_amt%TYPE,
      p_remarks          giis_line.remarks%TYPE
   )
      RETURN giis_line_group_tab PIPELINED
   IS
      v_report   giis_line_group_type;
   BEGIN
      FOR i IN
         (SELECT   *
              FROM giis_line
             WHERE UPPER (line_cd) LIKE UPPER (NVL (p_line_cd, line_cd))
               AND UPPER (line_name) LIKE UPPER (NVL (p_line_name, line_name))
               AND acct_line_cd = (NVL (p_acct_line_cd, acct_line_cd))
               AND UPPER (NVL (menu_line_cd, ' ')) LIKE
                      UPPER (NVL (p_menu_line_cd,
                                  DECODE (menu_line_cd,
                                          NULL, ' ',
                                          menu_line_cd
                                         )
                                 )
                            )
               AND UPPER (NVL (recaps_line_cd, ' ')) LIKE
                      UPPER (NVL (p_recaps_line_cd,
                                  DECODE (recaps_line_cd,
                                          NULL, ' ',
                                          recaps_line_cd
                                         )
                                 )
                            )
               AND NVL (min_prem_amt, 0) =
                      (NVL (p_min_prem_amt,
                            DECODE (min_prem_amt, NULL, 0, min_prem_amt)
                           )
                      )
               AND UPPER (NVL (remarks, ' ')) LIKE
                      UPPER (NVL (p_remarks,
                                  DECODE (remarks, NULL, ' ', remarks)
                                 )
                            )
          ORDER BY line_cd, line_name, acct_line_cd)
      LOOP
         v_report.pack_pol_flag := NVL(i.pack_pol_flag,'N');
         v_report.prof_comm_tag := NVL(i.prof_comm_tag,'N');
         v_report.non_renewal_tag := NVL(i.non_renewal_tag,'N');
         v_report.special_dist_sw := NVL(i.special_dist_sw,'N');
         v_report.edst_sw := NVL(i.edst_sw,'N');
         v_report.line_cd := i.line_cd;
         v_report.line_name := i.line_name;
         v_report.acct_line_cd := i.acct_line_cd;
         v_report.menu_line_cd := i.menu_line_cd;
         v_report.recaps_line_cd := i.recaps_line_cd;
         v_report.min_prem_amt := i.min_prem_amt;
         v_report.enrollee_tag := NVL(i.enrollee_tag,'N');
         v_report.remarks := i.remarks;
         v_report.user_id := i.user_id;
         v_report.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
		 v_report.other_cert_tag := NVL(i.other_cert_tag,'N'); --robert 01.06.15
         PIPE ROW (v_report);
      END LOOP;
      RETURN;
   END;
   --added by steven 12.11.2013
   PROCEDURE set_giiss001 (p_rec giis_line%ROWTYPE)
   IS
      v_not_exist   BOOLEAN := TRUE;
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_line
                 WHERE line_cd = p_rec.line_cd)
      LOOP
         v_not_exist := FALSE;
         EXIT;
      END LOOP;

      MERGE INTO giis_line
         USING DUAL
         ON (line_cd = p_rec.line_cd)
         WHEN NOT MATCHED THEN
            INSERT (line_cd, line_name, acct_line_cd, menu_line_cd,
                    recaps_line_cd, min_prem_amt, pack_pol_flag,
                    prof_comm_tag, non_renewal_tag, special_dist_sw, edst_sw,
                    remarks, user_id, last_update,enrollee_tag, other_cert_tag)
            VALUES (p_rec.line_cd, p_rec.line_name, p_rec.acct_line_cd,
                    p_rec.menu_line_cd, p_rec.recaps_line_cd,
                    p_rec.min_prem_amt, p_rec.pack_pol_flag,
                    p_rec.prof_comm_tag, p_rec.non_renewal_tag,
                    p_rec.special_dist_sw, p_rec.edst_sw, p_rec.remarks,
                    p_rec.user_id, SYSDATE,p_rec.enrollee_tag, p_rec.other_cert_tag)
         WHEN MATCHED THEN
            UPDATE
               SET line_name = p_rec.line_name,
                   acct_line_cd = p_rec.acct_line_cd,
                   menu_line_cd = p_rec.menu_line_cd,
                   recaps_line_cd = p_rec.recaps_line_cd,
                   min_prem_amt = p_rec.min_prem_amt,
                   pack_pol_flag = p_rec.pack_pol_flag,
                   prof_comm_tag = p_rec.prof_comm_tag,
                   non_renewal_tag = p_rec.non_renewal_tag,
                   special_dist_sw = p_rec.special_dist_sw,
                   edst_sw = p_rec.edst_sw,enrollee_tag = p_rec.enrollee_tag,
                   remarks = p_rec.remarks,
                   user_id = p_rec.user_id, last_update = SYSDATE,
				   other_cert_tag = p_rec.other_cert_tag
            ;

      IF v_not_exist
      THEN
         INSERT INTO giis_dist_share
                     (line_cd, share_cd,
                      trty_yy, trty_sw, eff_date,
                      expiry_date, trty_name, share_type,
                      user_id, last_update
                     )
              VALUES (p_rec.line_cd, '1',
                      TO_NUMBER (TO_CHAR (SYSDATE, 'YY')), 'N', SYSDATE,
                      ADD_MONTHS (SYSDATE, 12), 'NET RETENTION', '1',
                      p_rec.user_id, SYSDATE
                     );

         INSERT INTO giis_dist_share
                     (line_cd, share_cd,
                      trty_yy, trty_sw, eff_date,
                      expiry_date, trty_name, share_type,
                      user_id, last_update
                     )
              VALUES (p_rec.line_cd, '999',
                      TO_NUMBER (TO_CHAR (SYSDATE, 'YY')), 'N', SYSDATE,
                      ADD_MONTHS (SYSDATE, 12), 'FACULTATIVE', '3',
                      p_rec.user_id, SYSDATE
                     );
      END IF;
   END;
   
   PROCEDURE val_del_giiss001 (p_line_cd giis_line.line_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      /* Deletion of GIIS_LINE prevented if GIPI_WPOLBAS records exist */
      /* Foreign key(s): LINE_WPOLBAS_FK                               */
      FOR rec IN (SELECT '1'
                    FROM gipi_wpolbas b540
                   WHERE b540.line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIPI_WPOLBAS exists.'
            );
      END IF;

      /* Deletion of GIIS_LINE prevented if GIIS_WARRCLA records exist */
      /* Foreign key(s): LINE_WARRCLA_FK                               */
      FOR rec IN (SELECT '1'
                    FROM giis_warrcla a280
                   WHERE a280.line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIIS_WARRCLA exists.'
            );
      END IF;

      /* Deletion of GIIS_LINE prevented if GIIS_TAX_CHARGES records exi */
      /* Foreign key(s): LINE_TAX_CHARGES_FK                             */
      FOR rec IN (SELECT '1'
                    FROM giis_tax_charges a230
                   WHERE a230.line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIIS_TAX_CHARGES exists.'
            );
      END IF;

       /* Deletion of GIIS_LINE prevented if GIIS_SUBLINE records exist */
      /* Foreign key(s): LINE_SUBLINE_FK                               */
      FOR rec IN (SELECT '1'
                    FROM giis_subline a210
                   WHERE a210.line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIIS_SUBLINE exists.'
            );
      END IF;

      /* Deletion of GIIS_LINE prevented if GIPI_POLBASIC records exist */
      /* Foreign key(s): LINE_POLBASIC_FK                               */
      FOR rec IN (SELECT '1'
                    FROM gipi_polbasic b250
                   WHERE b250.line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIPI_POLBASIC exists.'
            );
      END IF;

        /* Deletion of GIIS_LINE prevented if GIIS_PERIL records exist */
      /* Foreign key(s): LINE_PERIL_FK                               */
      FOR rec IN (SELECT '1'
                    FROM giis_peril a170
                   WHERE a170.line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIIS_PERIL exists.'
            );
      END IF;

        /* Deletion of GIIS_LINE prevented if GIPI_PARLIST records exist */
      /* Foreign key(s): LINE_PARLIST_FK                               */
      FOR rec IN (SELECT '1'
                    FROM gipi_parlist b240
                   WHERE b240.line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIPI_PARLIST exists.'
            );
      END IF;

        /* Deletion of GIIS_LINE prevented if GIIS_OUTREATY records exist */
      /* Foreign key(s): LINE_OUTREATY_FK                               */
      FOR rec IN (SELECT '1'
                    FROM giis_outreaty a160
                   WHERE a160.line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIIS_OUTREATY exists.'
            );
      END IF;

       /* Deletion of GIIS_LINE prevented if GIIS_INTREATY records exist */
      /* Foreign key(s): LINE_INTREATY_FK                               */
      FOR rec IN (SELECT '1'
                    FROM giis_intreaty a590
                   WHERE a590.line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIIS_INTREATY exists.'
            );
      END IF;

        /* Deletion of GIIS_LINE prevented if GICL_CLAIMS records exist */
      /* Foreign key(s): LINE_CLAIMS_FK                               */
      FOR rec IN (SELECT '1'
                    FROM gicl_claims e030
                   WHERE e030.line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GICL_CLAIMS exists.'
            );
      END IF;

         /* Deletion of GIIS_LINE prevented if GIIS_DIST_SHARE records exist */
      /* Foreign key(s): LINE_DIST_SHARE_FK                               */
      /* Added by Loth 091399                                             */
      FOR rec IN (SELECT '1'
                    FROM giis_dist_share
                   WHERE line_cd = p_line_cd AND share_cd NOT IN ('1', '999'))
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIIS_DIST_SHARE exists.'
            );
      END IF;
      
      FOR rec IN (SELECT '1'
                    FROM GIAC_AGING_ASSD_LINE
                   WHERE a150_line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIAC_AGING_ASSD_LINE exists.'
            );
      END IF;
      
      FOR rec IN (SELECT '1'
                    FROM GIAC_AGING_LINE_TOTALS 
                   WHERE a150_line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIAC_AGING_LINE_TOTALS exists.'
            );
      END IF;
      
      FOR rec IN (SELECT '1'
                    FROM GIAC_AGING_RI_SOA_DETAILS 
                   WHERE a150_line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIAC_AGING_RI_SOA_DETAILS exists.'
            );
      END IF;
      
      FOR rec IN (SELECT '1'
                    FROM GIAC_AGING_SOA_DETAILS 
                   WHERE a150_line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIAC_AGING_SOA_DETAILS exists.'
            );
      END IF;
      
      FOR rec IN (SELECT '1'
                    FROM GIAC_INTM_PCOMM_RT 
                   WHERE line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIAC_INTM_PCOMM_RT exists.'
            );
      END IF;
      
      FOR rec IN (SELECT '1'
                    FROM GIAC_POLICY_TYPE_ENTRIES 
                   WHERE line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIAC_POLICY_TYPE_ENTRIES exists.'
            );
      END IF;
      
      FOR rec IN (SELECT '1'
                    FROM GIAC_RI_REQ_PAYT_DTL 
                   WHERE line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIAC_RI_REQ_PAYT_DTL exists.'
            );
      END IF;
      
      FOR rec IN (SELECT '1'
                    FROM GIAC_WEEK_PERF_DTL 
                   WHERE line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIAC_WEEK_PERF_DTL exists.'
            );
      END IF;
      
      FOR rec IN (SELECT '1'
                    FROM GICL_CEILING_HDR 
                   WHERE line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GICL_CEILING_HDR exists.'
            );
      END IF;
      
      FOR rec IN (SELECT '1'
                    FROM GIIN_ASSD_PROD_LINE_DTL 
                   WHERE line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIIN_ASSD_PROD_LINE_DTL exists.'
            );
      END IF;
      
      FOR rec IN (SELECT '1'
                    FROM GIIN_INTM_PROD_LINE_DTL 
                   WHERE line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIIN_INTM_PROD_LINE_DTL exists.'
            );
      END IF;
      
      FOR rec IN (SELECT '1'
                    FROM GIIS_ADJUSTER 
                   WHERE line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIIS_ADJUSTER exists.'
            );
      END IF;
      
      FOR rec IN (SELECT '1'
                    FROM GIIS_BOND_SEQ 
                   WHERE line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIIS_BOND_SEQ exists.'
            );
      END IF;
      
      FOR rec IN (SELECT '1'
                    FROM GIIS_DEFAULT_DIST 
                   WHERE line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIIS_DEFAULT_DIST exists.'
            );
      END IF;
      
      FOR rec IN (SELECT '1'
                    FROM GIIS_INTM_SPECIAL_RATE 
                   WHERE line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIIS_INTM_SPECIAL_RATE exists.'
            );
      END IF;
      
      FOR rec IN (SELECT '1'
                    FROM GIIS_OUTREATY 
                   WHERE line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIIS_OUTREATY exists.'
            );
      END IF;
      
      FOR rec IN (SELECT '1'
                    FROM GIIS_PACK_PLAN 
                   WHERE line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIIS_PACK_PLAN exists.'
            );
      END IF;
      
      FOR rec IN (SELECT '1'
                    FROM GIIS_PACK_PLAN_COVER 
                   WHERE pack_line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIIS_PACK_PLAN_COVER exists.'
            );
      END IF;
      
      FOR rec IN (SELECT '1'
                    FROM GIIS_PERIL 
                   WHERE line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIIS_PERIL exists.'
            );
      END IF;
      
      FOR rec IN (SELECT '1'
                    FROM GIIS_PERIL_CLASS 
                   WHERE line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIIS_PERIL_CLASS exists.'
            );
      END IF;
      
      FOR rec IN (SELECT '1'
                    FROM GIIS_PERIL_GROUP 
                   WHERE line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIIS_PERIL_GROUP exists.'
            );
      END IF;
      
      FOR rec IN (SELECT '1'
                    FROM GIIS_PLAN 
                   WHERE line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIIS_PLAN exists.'
            );
      END IF;
      
      FOR rec IN (SELECT '1'
                    FROM GIIS_POLICY_TYPE 
                   WHERE line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIIS_POLICY_TYPE exists.'
            );
      END IF;
      
      FOR rec IN (SELECT '1'
                    FROM GIIS_REQUIRED_DOCS 
                   WHERE line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIIS_REQUIRED_DOCS exists.'
            );
      END IF;
      
      FOR rec IN (SELECT '1'
                    FROM GIIS_TARIFF_RATES_HDR 
                   WHERE line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIIS_TARIFF_RATES_HDR exists.'
            );
      END IF;
      
      FOR rec IN (SELECT '1'
                    FROM GIIS_TARIFF_ZONE 
                   WHERE line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIIS_TARIFF_ZONE exists.'
            );
      END IF;
      
      FOR rec IN (SELECT '1'
                    FROM GIIS_TAX_CHARGES 
                   WHERE line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIIS_TAX_CHARGES exists.'
            );
      END IF;
      
      FOR rec IN (SELECT '1'
                    FROM GIIS_USER_GRP_LINE 
                   WHERE line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIIS_USER_GRP_LINE exists.'
            );
      END IF;
      
      FOR rec IN (SELECT '1'
                    FROM GIPI_BOND_SEQ_HIST 
                   WHERE line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIPI_BOND_SEQ_HIST exists.'
            );
      END IF;
      
      FOR rec IN (SELECT '1'
                    FROM GIRI_FAC_RECIPROCITY 
                   WHERE line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIRI_FAC_RECIPROCITY exists.'
            );
      END IF;
      
      FOR rec IN (SELECT '1'
                    FROM GIRI_TRTY_RECIPROCITY 
                   WHERE line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIRI_TRTY_RECIPROCITY exists.'
            );
      END IF;
      
      FOR rec IN (SELECT '1'
                    FROM GIUW_DIST_BATCH_DTL 
                   WHERE line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE while dependent record(s) in GIUW_DIST_BATCH_DTL exists.'
            );
      END IF;
   END;
   
   PROCEDURE val_add_giiss001 (p_line_cd        giis_line.line_cd%TYPE,
                               p_acct_line_cd   giis_line.acct_line_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_line
                 WHERE line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same line_cd.'
            );
      END IF;
      
      FOR i IN (SELECT '1'
                  FROM giis_line
                 WHERE acct_line_cd = p_acct_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same acct_line_cd.'
            );
      END IF;
   END;
   
   PROCEDURE val_menu_line_cd_giiss001 (p_line_cd        giis_line.line_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
       FOR a IN (SELECT par_status
                   FROM gipi_parlist
                  WHERE line_cd = p_line_cd)
       LOOP
          IF a.par_status IN (4, 5, 6, 10)
          THEN
             raise_application_error
                (-20001,
                 'Geniisys Exception#E#Menu Line Code cannot be updated while child record exist.'
                );
             EXIT;
          END IF;
       END LOOP;
   END;
   
   FUNCTION get_giiss001_menu_line_cd 
      RETURN giiss001_line_listing_tab PIPELINED
   IS
      v_rec   giiss001_line_listing_type;
   BEGIN
         /*v_rec.line_cd := 'MC';
         v_rec.line_name := 'Motor Car';
         PIPE ROW (v_rec);
         v_rec.line_cd := 'FI';
         v_rec.line_name := 'Fire';
         PIPE ROW (v_rec);
         v_rec.line_cd := 'EN';
         v_rec.line_name := 'Engineering';
         PIPE ROW (v_rec);
         v_rec.line_cd := 'MN';
         v_rec.line_name := 'Marine Cargo';
         PIPE ROW (v_rec);
         v_rec.line_cd := 'MH';
         v_rec.line_name := 'Marine Hull';
         PIPE ROW (v_rec);
         v_rec.line_cd := 'CA';
         v_rec.line_name := 'Casualty';
         PIPE ROW (v_rec);
         v_rec.line_cd := 'AC';
         v_rec.line_name := 'Accident';
         PIPE ROW (v_rec);
         v_rec.line_cd := 'AV';
         v_rec.line_name := 'Aviation';
         PIPE ROW (v_rec);*/    --commented out by Gzelle 10102014 - replaced with codes below based on UW-SPECS-2014-089
         
         FOR i IN (SELECT menu_line_cd, menu_line_desc
                     FROM giis_menu_line)
         LOOP
         
            v_rec.line_cd := i.menu_line_cd;
            v_rec.line_name := i.menu_line_desc;
            PIPE ROW (v_rec);
            
         END LOOP;

      RETURN;
   END;
   
   FUNCTION get_giiss001_recap_line_cd (p_keyword VARCHAR2)
      RETURN giiss001_line_listing_tab PIPELINED
   IS
      v_rec   giiss001_line_listing_type;
   BEGIN
      FOR i IN (SELECT DISTINCT line_cd
                           FROM giis_line
                          WHERE UPPER (line_cd) LIKE UPPER (NVL (p_keyword, line_cd)) )
      LOOP
         v_rec.line_cd := i.line_cd;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;
   
 --end steven 12.11.2013
   PROCEDURE set_giis_line_group (
      p_line_cd           giis_line.line_cd%TYPE,
      p_line_name         giis_line.line_name%TYPE,
      p_acct_line_cd      giis_line.acct_line_cd%TYPE,
      p_menu_line_cd      giis_line.menu_line_cd%TYPE,
      p_recaps_line_cd    giis_line.recaps_line_cd%TYPE,
      p_min_prem_amt      giis_line.min_prem_amt%TYPE,
      p_remarks           giis_line.remarks%TYPE,
      p_pack_pol_flag     giis_line.pack_pol_flag%TYPE,
      p_prof_comm_tag     giis_line.prof_comm_tag%TYPE,
      p_non_renewal_tag   giis_line.non_renewal_tag%TYPE
   )
   IS
   BEGIN
      MERGE INTO giis_line
         USING DUAL
         ON (line_cd = p_line_cd)
         WHEN NOT MATCHED THEN
            INSERT (line_cd, line_name, acct_line_cd, menu_line_cd,
                    recaps_line_cd, min_prem_amt, remarks, pack_pol_flag,
                    prof_comm_tag, non_renewal_tag)
            VALUES (p_line_cd, p_line_name, p_acct_line_cd, p_menu_line_cd,
                    p_recaps_line_cd, TO_NUMBER (p_min_prem_amt), p_remarks,
                    p_pack_pol_flag, p_prof_comm_tag, p_non_renewal_tag)
         WHEN MATCHED THEN
            UPDATE
               SET line_name = p_line_name, acct_line_cd = p_acct_line_cd,
                   menu_line_cd = p_menu_line_cd,
                   recaps_line_cd = p_recaps_line_cd,
                   min_prem_amt = TO_NUMBER (p_min_prem_amt),
                   remarks = p_remarks, pack_pol_flag = p_pack_pol_flag,
                   prof_comm_tag = p_prof_comm_tag,
                   non_renewal_tag = p_non_renewal_tag
            ;
   END;

   PROCEDURE delete_giis_line_group (p_line_cd giis_line.line_cd%TYPE)
   IS
   v_exist VARCHAR2(1) := 'N';
   BEGIN
       FOR exist IN (SELECT 'a'
                       FROM giis_dist_share
                      WHERE line_cd = p_line_cd
                        AND share_cd NOT IN ('1', '999'))
       LOOP
          v_exist := 'Y';
       END LOOP;

       IF v_exist = 'N'
       THEN
          DELETE      giis_dist_share
                WHERE line_cd = p_line_cd;
       END IF;
       
      DELETE FROM giis_line
            WHERE line_cd = p_line_cd;
   END;

   FUNCTION validate_line_cd (
      p_pol_iss_cd   VARCHAR2,
      p_module_id    giis_modules.module_id%TYPE,
      p_line_cd      giis_line.line_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      v_exist   VARCHAR2 (1) := 'N';
   BEGIN
      FOR i IN (SELECT line_cd line_cd, line_name line_name, menu_line_cd
                  FROM giis_line
                 WHERE line_cd =
                          DECODE (check_user_per_line (line_cd,
                                                       p_pol_iss_cd,
                                                       p_module_id
                                                      ),
                                  1, line_cd,
                                  NULL
                                 )
                   AND line_cd = p_line_cd)
      LOOP
         v_exist := 'Y';
      END LOOP;

      RETURN v_exist;
   END validate_line_cd;

   -- shan 03.15.2013
   PROCEDURE get_line_name_gicls201 (
      p_module_id   IN       giis_modules.module_id%TYPE,
      p_line_cd     IN       giis_line.line_cd%TYPE,
      p_user        IN       giis_users.user_id%TYPE,
      p_line_name   OUT      giis_line.line_name%TYPE,
      p_found       OUT      VARCHAR2
   )
   IS
      v_line_name   giis_line.line_name%TYPE;
   BEGIN
      SELECT line_name
        INTO v_line_name
        FROM giis_line
       WHERE line_cd = p_line_cd
         AND line_cd IN
                (DECODE (check_user_per_iss_cd2 (line_cd,
                                                 NULL,
                                                 p_module_id,
                                                 p_user
                                                ),
                         1, line_cd,
                         0, ''
                        )
                );

      p_line_name := v_line_name;

      IF v_line_name IS NULL
      THEN
         p_found := 'N';
      ELSE
         p_found := 'Y';
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_found := 'N';
   END get_line_name_gicls201;

   /*
   **  Created by    : Veronica V. Raymundo
   **  Date Created  : 05.04.2013
   **  Description   : Retrieve non-package lines which are accessible for the given user_id
   */
   FUNCTION get_all_non_pack_line_list (
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN line_listing_tab PIPELINED
   IS
      v_line   line_listing_type;
   BEGIN
      FOR i IN (SELECT line_cd line_cd, line_name line_name, menu_line_cd
                  FROM giis_line
                 WHERE check_user_per_line1 (line_cd,
                                             p_iss_cd,
                                             p_user_id,
                                             p_module_id
                                            ) = 1
                   AND pack_pol_flag != 'Y')
      LOOP
         v_line.line_cd := i.line_cd;
         v_line.line_name := i.line_name;
         v_line.menu_line_cd := i.menu_line_cd;
         PIPE ROW (v_line);
      END LOOP;

      RETURN;
   END get_all_non_pack_line_list;

   /** Created By:     kenneth Labrador
    ** Date Created:   04.24.2013
    ** Referenced By:  GIUTS022 - Change in Payment Term
    **Description:     Line LOV
    **/
   FUNCTION get_line_lov_giuts022 (
      p_search    VARCHAR2,
      p_user_id   giis_users.user_id%TYPE
   )
      RETURN line_listing_tab PIPELINED
   IS
      v_giis_line   line_listing_type;
   BEGIN
      FOR i IN (SELECT   line_cd, line_name
                    FROM giis_line
                   WHERE UPPER (line_cd) LIKE UPPER (NVL (p_search, '%'))
                     AND check_user_per_line1 (line_cd,
                                               NULL,
                                               p_user_id,
                                               'GIUTS022'
                                              ) = 1
                ORDER BY line_name)
      LOOP
         v_giis_line.line_cd := i.line_cd;
         v_giis_line.line_name := i.line_name;
         PIPE ROW (v_giis_line);
      END LOOP;

      RETURN;
   END get_line_lov_giuts022;

   -- shan 05.15.2013 for GIRIS051 (Expiry PPW Line LOV)
   FUNCTION get_giris051_line_ppw_lov (
      p_module_id   VARCHAR2,
      p_user        giis_users.user_id%TYPE
   )
      RETURN line_listing_tab PIPELINED
   AS
      rep   line_listing_type;
   BEGIN
      FOR i IN (SELECT line_cd, line_name
                  FROM giis_line
                 WHERE check_user_per_line2(line_cd, NULL, p_module_id, p_user) = 1
--                 WHERE line_cd =
--                          DECODE (check_user_per_line2 (line_cd,
--                                                       p_pol_iss_cd,
--                                                       p_module_id,
--                                                       p_user_id
--                                                      ),
--                                  1, line_cd,
--                                  NULL
--                                 )
                   AND pack_pol_flag = 'N')
      LOOP
         rep.line_cd := i.line_cd;
         rep.line_name := i.line_name;
         PIPE ROW (rep);
      END LOOP;
   END get_giris051_line_ppw_lov;

   FUNCTION get_line_cd_lov
      RETURN line_listing_tab PIPELINED
   IS
      v_list   line_listing_type;
   BEGIN
      FOR i IN (SELECT   line_cd, line_name
                    FROM giis_line
                ORDER BY line_name)
      LOOP
         v_list.line_cd := i.line_cd;
         v_list.line_name := i.line_name;
         PIPE ROW (v_list);
      END LOOP;
   END get_line_cd_lov;

   FUNCTION validate_line_cd2 (p_line_cd VARCHAR2)
      RETURN VARCHAR2
   IS
      v_check   VARCHAR2 (50);
   BEGIN
      BEGIN
         SELECT DISTINCT line_name
                    INTO v_check
                    FROM giis_line
                   WHERE UPPER (line_cd) = UPPER (p_line_cd);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_check := 'ERROR';
      END;

      RETURN v_check;
   END;

   --added by : Kenneth L. 07.16.2013 :for giacs286
   FUNCTION get_giacs286_line_lov (p_user_id giis_users.user_id%TYPE)
      RETURN line_listing_tab PIPELINED
   AS
      v_line   line_listing_type;
   BEGIN
      FOR i IN (SELECT   line_cd, line_name
                    FROM giis_line
--                    WHERE line_cd =
--                             DECODE (check_user_per_line1 (line_cd,
--                                                           NULL,
--                                                           p_user_id,
--                                                           'GIACS286'
--                                                          ),
--                                     1, line_cd,
--                                     NULL
--                                    )
                ORDER BY line_cd)
      LOOP
         v_line.line_cd := i.line_cd;
         v_line.line_name := i.line_name;
         PIPE ROW (v_line);
      END LOOP;
   END get_giacs286_line_lov;

    /*
   ** Created by: Marie Kris Felipe
   ** Created date: 07.30.2013
   ** Referenced by: GICLS051 (Generate PLA/FLA)
   ** Description: -
   */
   FUNCTION get_gicls051_line_lov (
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN line_listing_tab PIPELINED
   IS
      v_line   line_listing_type;
   BEGIN
      FOR rec IN
         (SELECT   line_cd, line_name
              FROM giis_line
             WHERE line_cd IN
                      (DECODE
                          (check_user_per_iss_cd2 (line_cd,
                                                   NULL,
                                                   p_module_id,
                                                   p_user_id
                                                  ),
                           1, line_cd,
                           0, ''
                          ) /* added by jay 06/24/2012 */
                      )
          ORDER BY line_cd, line_name)
      LOOP
         v_line.line_cd := rec.line_cd;
         v_line.line_name := rec.line_name;
         PIPE ROW (v_line);
      END LOOP;
   END get_gicls051_line_lov;

   /*
   ** Created by: Marco Paolo Rebong
   ** Created date: 08.06.2013
   ** Referenced by: GIACS056 (Modified Commissions)
   ** Description: -
   */
   FUNCTION get_giacs056_line_lov (p_find_text VARCHAR2)
      RETURN line_listing_tab PIPELINED
   IS
      v_row   line_listing_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM (SELECT   line_cd, line_name
                            FROM giis_line
                        UNION
                        SELECT   NULL line_cd, 'ALL LINES' line_name
                            FROM DUAL
                        ORDER BY line_name)
                 WHERE UPPER (NVL (line_cd, '*')) LIKE
                                 UPPER (NVL (p_find_text, NVL (line_cd, '*')))
                    OR UPPER (line_name) LIKE
                                          UPPER (NVL (p_find_text, line_name)))
      LOOP
         v_row.line_cd := i.line_cd;
         v_row.line_name := i.line_name;
         PIPE ROW (v_row);
      END LOOP;
   END;

   /*
   ** Created by: Marco Paolo Rebong
   ** Created date: 08.12.2013
   ** Referenced by: GIACS0102 (Undistributed Policies)
   ** Description: -
   */
   FUNCTION get_giacs102_line_lov (
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_find_text   VARCHAR2
   )
      RETURN line_listing_tab PIPELINED
   IS
      v_row   line_listing_type;
   BEGIN
      FOR i IN (SELECT   l.line_cd, l.line_name
                    FROM giis_line l
                   WHERE EXISTS (SELECT 1
                                   FROM gipi_polbasic b
                                  WHERE l.line_cd = b.line_cd)
                     AND check_user_per_line2 (l.line_cd,
                                               NULL,
                                               p_module_id,
                                               p_user_id
                                              ) = 1
                     AND (   UPPER (NVL (line_cd, '*')) LIKE
                                 UPPER (NVL (p_find_text, NVL (line_cd, '*')))
                          OR UPPER (line_name) LIKE
                                          UPPER (NVL (p_find_text, line_name))
                         )
                ORDER BY l.line_cd, l.line_name)
      LOOP
         v_row.line_cd := i.line_cd;
         v_row.line_name := i.line_name;
         PIPE ROW (v_row);
      END LOOP;
   END;

   PROCEDURE validate_giacs102_line_cd (
      p_line_cd     IN OUT   giis_line.line_cd%TYPE,
      p_line_name   IN OUT   giis_line.line_name%TYPE
   )
   IS
   BEGIN
      SELECT line_cd, line_name
        INTO p_line_cd, p_line_name
        FROM giis_line
       WHERE UPPER (line_cd) LIKE UPPER (NVL (p_line_cd, line_cd))
         AND UPPER (line_name) LIKE UPPER (NVL (p_line_name, line_name));
   EXCEPTION
      WHEN OTHERS
      THEN
         p_line_cd := NULL;
         p_line_name := NULL;
   END;

   FUNCTION get_submaintain_line_list (p_user_id giis_users.user_id%TYPE)
      RETURN line_listing_tab PIPELINED
   IS
      v_giis_line   line_listing_type;
   BEGIN
      FOR i IN (SELECT   line_cd, line_name
                    FROM giis_line
                   WHERE check_user_per_line2 (line_cd,
                                               NULL,
                                               'GIISS002',
                                               p_user_id
                                              ) = 1
                ORDER BY line_cd)
      LOOP
         v_giis_line.line_cd := i.line_cd;
         v_giis_line.line_name := i.line_name;
         PIPE ROW (v_giis_line);
      END LOOP;

      RETURN;
   END get_submaintain_line_list;

   FUNCTION get_gicls254_line_lov (p_line_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN gicls254_line_tab PIPELINED
   IS
      v_list   gicls254_line_type;
   BEGIN
      FOR i IN (SELECT   line_cd, line_name
                    FROM giis_line
                   WHERE line_cd =
                            DECODE (check_user_per_line2 (line_cd,
                                                          NULL,
                                                          'GICLS254',
                                                          p_user_id
                                                         ),
                                    1, line_cd,
                                    NULL
                                   )
                     AND line_cd LIKE NVL (UPPER(p_line_cd), line_cd)
                ORDER BY line_cd)
      LOOP
         v_list.line_cd := i.line_cd;
         v_list.line_name := i.line_name;
         PIPE ROW (v_list);
      END LOOP;
   END get_gicls254_line_lov;
   
    FUNCTION get_giiss091_line_lov (p_user_id VARCHAR2, p_keyword VARCHAR2)
       RETURN giiss091_line_tab PIPELINED
    IS
       v_list   giiss091_line_type;
    BEGIN
       FOR i IN (SELECT DISTINCT (a.line_cd) line_cd, b.line_name
                            FROM giis_user_grp_line a, giis_line b, giis_users c
                           WHERE a.line_cd = b.line_cd
                             AND a.user_grp = c.user_grp
                             AND check_user_per_line2(b.line_cd, NULL, 'GIISS091', p_user_id) = 1
                             AND UPPER (b.line_cd) LIKE
                                           '%'
                                        || UPPER (NVL (p_keyword, b.line_cd))
                                        || '%'
                                 )
       LOOP
          v_list.line_cd := i.line_cd;
          v_list.line_name := i.line_name;
          PIPE ROW (v_list);
       END LOOP;
    END get_giiss091_line_lov;
    
    FUNCTION get_giacs299_line_lov(
      p_module_id          giis_modules.module_id%TYPE,
      p_user_id            giis_users.user_id%TYPE,
      p_keyword            VARCHAR2
   ) RETURN line_listing_tab PIPELINED
   IS
      v_giis_line   line_listing_type;
   BEGIN
      FOR i IN (SELECT line_cd, line_name
                  FROM giis_line
                 WHERE (UPPER(line_cd) LIKE UPPER(NVL(p_keyword, '%'))
                        OR UPPER(line_name) LIKE UPPER(NVL(p_keyword, '%')))
                 ORDER BY line_name)
      LOOP
         v_giis_line.line_cd := i.line_cd;
         v_giis_line.line_name := i.line_name;
         
         PIPE ROW (v_giis_line);
      END LOOP;
   END;
   
   FUNCTION get_gicls104_line_lov(
        p_module_id          giis_modules.module_id%TYPE,
        p_user_id            giis_users.user_id%TYPE
   ) RETURN line_listing_tab PIPELINED
   IS
      v_giis_line   line_listing_type;
   BEGIN
      FOR i IN (SELECT line_cd, line_name, menu_line_cd
                  FROM giis_line
                 WHERE check_user_per_iss_cd2(line_cd, NULL, p_module_id, p_user_id) = 1
                 ORDER BY line_cd)
      LOOP
         v_giis_line.line_cd := i.line_cd;
         v_giis_line.line_name := i.line_name;
         v_giis_line.menu_line_cd := i.menu_line_cd;
         
         PIPE ROW (v_giis_line);
      END LOOP;
   END;
    
   FUNCTION get_giuts009_line_lov (
      p_module_id    giis_modules.module_id%TYPE,
      p_pol_iss_cd   VARCHAR2,
      p_user_id      giis_users.user_id%TYPE
   )
      RETURN line_listing_tab PIPELINED
   IS
      v_line   line_listing_type;
   BEGIN
      FOR i IN (SELECT line_cd line_cd, line_name line_name, menu_line_cd
                  FROM giis_line
                 WHERE line_cd =
                          DECODE (check_user_per_line2 (line_cd,
                                                       p_pol_iss_cd,
                                                       p_module_id,
                                                       p_user_id
                                                      ),
                                  1, line_cd,
                                  NULL
                                 )
                   AND pack_pol_flag = 'N') -- bonok :: 11.19.2013 :: SR 591 :: retrieve only non-package lines
      LOOP
         v_line.line_cd := i.line_cd;
         v_line.line_name := i.line_name;
         v_line.menu_line_cd := i.menu_line_cd;
         PIPE ROW (v_line);
      END LOOP;

      RETURN;
   END get_giuts009_line_lov;
      
   FUNCTION validate_gicls010_line(
      p_pol_iss_cd   VARCHAR2,
      p_module_id    giis_modules.module_id%TYPE,
      p_line_cd      giis_line.line_cd%TYPE,
      p_user_id      giis_users.user_id%TYPE
   )
      RETURN VARCHAR2
   IS
      v_exist        VARCHAR2 (1) := 'N';
   BEGIN
      FOR i IN(SELECT line_cd line_cd, line_name line_name, menu_line_cd
                 FROM giis_line
                WHERE line_cd = DECODE(check_user_per_line2(line_cd, p_pol_iss_cd, p_module_id, p_user_id), 1, line_cd, NULL)
                  AND line_cd = p_line_cd)
      LOOP
         v_exist := 'Y';
      END LOOP;

      RETURN v_exist;
   END;    
      
END giis_line_pkg;
/


