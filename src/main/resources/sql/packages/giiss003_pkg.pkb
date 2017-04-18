CREATE OR REPLACE PACKAGE BODY CPI.giiss003_pkg
AS
    /*
   **  Created by   : Cherrie
   **  Date Created : 10.17.2012
   **  Reference By : (GIISS003 - Peril Maintenance)
   **  Description  : query perils by line
   **  Modified By  :  Kenneth L. (Changed name from giiss003_peril_maintenance to giiss003_pkg and added additional functions and procedures)
   */
   FUNCTION get_peril_listgiiss003 (p_line_cd IN giis_line.line_cd%TYPE)
      RETURN peril_list_tab PIPELINED
   IS
      v_peril   peril_list_type;
   BEGIN
      FOR i IN (SELECT line_cd, peril_cd, SEQUENCE, peril_sname, prt_flag,
                       peril_name, peril_type, subline_cd, ri_comm_rt, basc_perl_cd, prof_comm_tag,
                       peril_lname, remarks, zone_type, eval_sw, default_tag,
                       default_rate, default_tsi, user_id,
                       TO_CHAR (last_update,
                                'MM-DD-YYYY HH:MI:SS AM'
                               ) last_update
                       , eq_zone_type --edgar 03/10/2015
                  FROM giis_peril
                 WHERE line_cd = p_line_cd
                 ORDER BY peril_cd)
      LOOP
         v_peril.line_cd := i.line_cd;
         v_peril.peril_cd := i.peril_cd;
         v_peril.SEQUENCE := i.SEQUENCE;
         v_peril.peril_sname := i.peril_sname;
         v_peril.prt_flag := i.prt_flag;
         v_peril.prof_comm_tag := i.prof_comm_tag;
         v_peril.peril_name := i.peril_name;
         v_peril.peril_type := i.peril_type;
         v_peril.subline_cd := i.subline_cd;
         v_peril.ri_comm_rt := i.ri_comm_rt;
         v_peril.basc_perl_cd := i.basc_perl_cd;
         v_peril.prof_comm_tag := i.prof_comm_tag;
         v_peril.peril_lname := i.peril_lname;
         v_peril.remarks := i.remarks;
         v_peril.zone_type := i.zone_type;
         v_peril.eval_sw := i.eval_sw;
         v_peril.default_tag := i.default_tag;
         v_peril.default_rate := i.default_rate;
         v_peril.default_tsi := i.default_tsi;
         v_peril.user_id := i.user_id;
         v_peril.last_update := i.last_update;
         v_peril.eq_zone_type := i.eq_zone_type; --edgar 03/10/2015
         PIPE ROW (v_peril);
      END LOOP;

      RETURN;
   END get_peril_listgiiss003;
   
   /*
   **  Created by   : Cherrie
   **  Date Created : 10.17.2012
   **  Reference By : (GIISS003 - Peril Maintenance)
   **  Description  : Add/update peril in GIIS_PERIL TABLE
   */
   PROCEDURE insert_update_peril (p_peril giis_peril%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_peril
         USING DUAL
         ON (line_cd = p_peril.line_cd AND peril_cd = p_peril.peril_cd)
         WHEN NOT MATCHED THEN
            INSERT (line_cd, peril_cd, SEQUENCE, peril_sname,
                      peril_name, peril_type, subline_cd,
                      ri_comm_rt, basc_line_cd,basc_perl_cd,
                      prof_comm_tag, peril_lname, remarks, prt_flag,
                      zone_type, eval_sw, default_tag, default_rate,
                        default_tsi, user_id, last_update, eq_zone_type --added eq_zone_type : edgar 03/10/2015
                     )
             VALUES (p_peril.line_cd, p_peril.peril_cd, p_peril.sequence, p_peril.peril_sname,
                      p_peril.peril_name, p_peril.peril_type, p_peril.subline_cd,
                      p_peril.ri_comm_rt, p_peril.basc_line_cd,p_peril.basc_perl_cd,
                      p_peril.prof_comm_tag, p_peril.peril_lname, p_peril.remarks, p_peril.prt_flag,
                      p_peril.zone_type, p_peril.eval_sw, p_peril.default_tag, p_peril.default_rate,
                      p_peril.default_tsi, p_peril.user_id, p_peril.last_update, p_peril.eq_zone_type --added eq_zone_type : edgar 03/10/2015
                     )
         WHEN MATCHED THEN
            UPDATE
               SET SEQUENCE = p_peril.sequence,
                peril_sname = p_peril.peril_sname,
                peril_name = p_peril.peril_name,
                peril_type = p_peril.peril_type,
                subline_cd = p_peril.subline_cd,
                ri_comm_rt = p_peril.ri_comm_rt,
                basc_line_cd = p_peril.basc_line_cd,
                basc_perl_cd = p_peril.basc_perl_cd,
                prof_comm_tag = p_peril.prof_comm_tag,
                peril_lname = p_peril.peril_lname,
                remarks = p_peril.remarks,
                prt_flag = p_peril.prt_flag,
                zone_type = p_peril.zone_type,
                eq_zone_type = p_peril.eq_zone_type, --added eq_zone_type: edgar 03/10/2015
                eval_sw = p_peril.eval_sw,
                default_tag = p_peril.default_tag,
                default_rate = p_peril.default_rate,
                default_tsi = p_peril.default_tsi,
                user_id = p_peril.user_id,
                last_update = SYSDATE;
   END insert_update_peril ;

   /*
   **  Created by   : Cherrie
   **  Date Created : 10.17.2012
   **  Reference By : (GIISS003 - Peril Maintenance)
   **  Description  : Add/update peril in GIIS_PERIL TABLE
   */
   PROCEDURE delete_peril (
      p_line_cd    giis_peril.line_cd%TYPE,
      p_peril_cd   giis_peril.peril_cd%TYPE
   )
   IS
   BEGIN
      DELETE      giis_peril
            WHERE line_cd = p_line_cd AND peril_cd = p_peril_cd;
   END delete_peril;

   /*
   **  Created by   : Cherrie
   **  Date Created : 10.18.2012
   **  Reference By : (GIISS003 - Peril Maintenance)
   **  Description  : query subline
   */
   FUNCTION get_giis_subline_list (p_line_cd giis_subline.line_cd%TYPE, p_subline_name giis_subline.subline_name%TYPE)
      RETURN giis_subline_list_tab PIPELINED
   IS
      v_giis_subline_list   giis_subline_list_type;
   BEGIN
       FOR i IN (SELECT subline_cd, subline_name
                    FROM giis_subline
                    WHERE line_cd = p_line_cd
                    AND (UPPER(subline_name) like UPPER(NVL(p_subline_name, '%'))
                            OR UPPER(subline_cd) like UPPER(NVL(p_subline_name, '%'))))

      LOOP
         v_giis_subline_list.subline_cd := i.subline_cd;
         v_giis_subline_list.subline_name := i.subline_name;
         PIPE ROW (v_giis_subline_list);
      END LOOP;
     
       
      
      RETURN;
   END get_giis_subline_list;

   /*
   **   Created by: Kenneth L.
   **   Description:Function for getting zone type for FI line
   **   Date Created: 11.22.2012
   */
   FUNCTION get_giis_zone_type_fi_list (p_zone_name cg_ref_codes.rv_meaning%TYPE)
      RETURN giis_zone_type_list_tab PIPELINED
   IS
      v_giis_zone_type_fi_list   giis_zone_type_list_type;
      
   BEGIN
   
      FOR i IN (SELECT rv_low_value,rv_meaning
                FROM cg_ref_codes
                WHERE (rv_domain = 'GIPI_FIRESTAT_EXTRACT.ZONE_TYPE'
                    /*OR rv_domain = 'GIPI_FIRESTAT_EXTRACT.EQ_ZONE_TYPE'*/)--commented out edgar 03/10/2015
                    AND UPPER(rv_meaning) like UPPER(NVL(p_zone_name, '%'))
                    ORDER BY rv_low_value)
                    
      LOOP
         v_giis_zone_type_fi_list.rv_low_value := i.rv_low_value;
         v_giis_zone_type_fi_list.rv_meaning := i.rv_meaning;
         PIPE ROW (v_giis_zone_type_fi_list);
      END LOOP;

      RETURN;
   END get_giis_zone_type_fi_list;

   /*
   **   Created by: Edgar N.
   **   Description:Function for getting earthquake zone type for FI line
   **   Date Created: 03/10/2015
   */   
   FUNCTION get_giis_eqzone_type_fi_list (p_zone_name cg_ref_codes.rv_meaning%TYPE)
      RETURN giis_eqzone_type_list_tab PIPELINED
   IS
      v_giis_eqzone_type_fi_list   giis_eqzone_type_list_type;
      
   BEGIN
   
      FOR i IN (SELECT rv_low_value,rv_meaning
                FROM cg_ref_codes
                WHERE rv_domain = 'GIPI_FIRESTAT_EXTRACT.EQ_ZONE_TYPE'
                    AND UPPER(rv_meaning) like UPPER(NVL(p_zone_name, '%'))
                    ORDER BY rv_low_value)
                    
      LOOP
         v_giis_eqzone_type_fi_list.rv_low_value := i.rv_low_value;
         v_giis_eqzone_type_fi_list.rv_meaning := i.rv_meaning;
         PIPE ROW (v_giis_eqzone_type_fi_list);
      END LOOP;

      RETURN;
   END get_giis_eqzone_type_fi_list;

   /*
   **   Created by: Kenneth L.
   **   Description:Function for getting zone type for MC line
   **   Date Created: 11.22.2012
   */   
   FUNCTION get_giis_zone_type_mc_list(p_zone_name cg_ref_codes.rv_meaning%TYPE)
      RETURN giis_zone_type_list_tab PIPELINED
   IS
    
      v_giis_zone_type_mc_list   giis_zone_type_list_type;
   BEGIN
      FOR i IN (SELECT rv_low_value,rv_meaning
                    FROM cg_ref_codes
                    WHERE rv_domain like 'GIIS_PERIL.ZONE_TYPE'
                    AND UPPER(rv_meaning) like UPPER(NVL(p_zone_name, '%'))
                    ORDER BY rv_low_value)
      LOOP
         v_giis_zone_type_mc_list.rv_low_value := i.rv_low_value;
         v_giis_zone_type_mc_list.rv_meaning := i.rv_meaning;
         PIPE ROW (v_giis_zone_type_mc_list);
      END LOOP

      RETURN;
   END get_giis_zone_type_mc_list;

   /*
   **   Created by: Kenneth L.
   **   Description:For Basic Peril Code LOV values
   **   Date Created: 11.22.2012
   */
   FUNCTION get_basic_peril_cd_list (p_line_cd giis_subline.line_cd%TYPE, p_basic_name giis_peril.peril_name%TYPE )
      RETURN peril_list_tab PIPELINED
   IS
      v_basic_peril_cd_list   peril_list_type;
   BEGIN
      FOR i IN (SELECT peril_cd, peril_name
                  FROM giis_peril
                 WHERE line_cd = p_line_cd
                 AND peril_type = 'B'
                 AND UPPER(peril_name) like UPPER(NVL(p_basic_name, '%'))
                 ORDER BY peril_cd)
      LOOP
         v_basic_peril_cd_list.peril_cd := i.peril_cd;
         v_basic_peril_cd_list.peril_name := i.peril_name;
         PIPE ROW (v_basic_peril_cd_list);
      END LOOP;

      RETURN;
   END get_basic_peril_cd_list;

   /*
   **   Created by: Kenneth L.
   **   Description:For line query
   **   Date Created: 11.22.2012
   */
     FUNCTION get_giis_line_list(
      p_user_id    giis_users.user_id%TYPE
   )
      RETURN line_listing_tab PIPELINED
   IS
      v_giis_line   line_listing_type;
   BEGIN
      FOR i IN (SELECT   line_cd, line_name, menu_line_cd
                    FROM giis_line
                   WHERE check_user_per_line1 (line_cd, null, p_user_id, 'GIISS003') = 1
                ORDER BY line_name)
      LOOP
         v_giis_line.line_cd := i.line_cd;
         v_giis_line.line_name := i.line_name;
         v_giis_line.menu_line_cd := i.menu_line_cd;
         PIPE ROW (v_giis_line);
      END LOOP;

      RETURN;
   END get_giis_line_list;

   /*
   **  Created by   : Cherrie
   **  Date Created : 10.18.2012
   **  Reference By : (GIISS003 - Peril Maintenance)
   **  Description  : check parent table before delete
   */
   FUNCTION validate_delete_peril (
      p_line_cd    giis_line.line_cd%TYPE,
      p_peril_cd   giis_peril.peril_cd%TYPE
   )
      RETURN VARCHAR
   IS
      v_peril_cd    VARCHAR2 (30);
      v_peril_cd2   VARCHAR2 (30);
      v_peril_cd3   VARCHAR2 (30);
      v_peril_cd4   VARCHAR2 (30);
   BEGIN
      SELECT (SELECT DISTINCT UPPER ('gipi_witmperl')
                         FROM gipi_witmperl w
                        WHERE LOWER (w.line_cd) LIKE LOWER (p_line_cd)
                          AND LOWER (w.peril_cd) LIKE LOWER (p_peril_cd)) a,
             (SELECT DISTINCT UPPER ('gipi_itmperil')
                         FROM gipi_itmperil i
                        WHERE LOWER (i.line_cd) LIKE LOWER (p_line_cd)
                          AND LOWER (i.peril_cd) LIKE LOWER (p_peril_cd)) b,
             (SELECT DISTINCT UPPER ('giis_peril_warrcla')
                         FROM giis_peril_clauses c
                        WHERE LOWER (c.line_cd) LIKE LOWER (p_line_cd)
                          AND LOWER (c.peril_cd) LIKE LOWER (p_peril_cd)) c,
             (SELECT DISTINCT UPPER ('giis_peril_clauses')
                         FROM giis_peril_tariff t
                        WHERE LOWER (t.line_cd) LIKE LOWER (p_line_cd)
                          AND LOWER (t.peril_cd) LIKE LOWER (p_peril_cd)) d
        INTO v_peril_cd,
             v_peril_cd2,
             v_peril_cd3,
             v_peril_cd4
        FROM DUAL;

      IF v_peril_cd IS NOT NULL
      THEN
         RETURN v_peril_cd;
      END IF;

      IF v_peril_cd2 IS NOT NULL
      THEN
         RETURN v_peril_cd2;
      END IF;
      
      IF v_peril_cd3 IS NOT NULL
      THEN
         RETURN v_peril_cd3;
      END IF;
      
      IF v_peril_cd2 IS NOT NULL
      THEN
         RETURN v_peril_cd3;
      END IF;

      RETURN '1';
   END validate_delete_peril;

   /*
    **  Created by   : Cherrie
    **  Date Created : 10.18.2012
    **  Reference By : (GIISS003 - Peril Maintenance)
    **  Description  : check peril_id if exist
  */
   FUNCTION peril_is_exist (
      p_line_cd    giis_line.line_cd%TYPE,
      p_peril_cd   giis_peril.peril_cd%TYPE
   )
      RETURN VARCHAR
   IS
      v_line_cd   VARCHAR2 (2);
   BEGIN
      SELECT (SELECT '0'
                FROM giis_peril
               WHERE UPPER (line_cd) = UPPER (p_line_cd)
                 AND peril_cd = p_peril_cd)
        INTO v_line_cd
        FROM DUAL;

      IF (v_line_cd IS NOT NULL)
      THEN
         RETURN v_line_cd;
      END IF;

      RETURN '1';
   END peril_is_exist;

   /*
  **  Created by   : Cherrie
  **  Date Created : 10.18.2012
  **  Reference By : (GIISS003 - Peril Maintenance)
  **  Description  : check peril shord name if exist
  */
   FUNCTION peril_sname_exist (
      p_line_cd       giis_line.line_cd%TYPE,
      p_peril_sname   giis_peril.peril_sname%TYPE
   )
      RETURN VARCHAR
   IS
      v_exist   VARCHAR2 (2);
   BEGIN
      SELECT (SELECT '0'
                FROM giis_peril
               WHERE UPPER (line_cd) = UPPER (p_line_cd)
                 AND UPPER (peril_sname) = UPPER (p_peril_sname))
        INTO v_exist
        FROM DUAL;

      IF (v_exist IS NOT NULL)
      THEN
         RETURN v_exist;
      END IF;

      RETURN '1';
   END peril_sname_exist;
   
   /*
   **   Created by: Kenneth L.
   **   Description:Validate if there is an existing peril name in the table
   **   Date Created: 11.22.2012
   */
    FUNCTION peril_name_exist (
      p_line_cd       giis_line.line_cd%TYPE,
      p_peril_name    giis_peril.peril_name%TYPE
   )
      RETURN VARCHAR
   IS
      v_exist   VARCHAR2 (2);
   BEGIN
      SELECT (SELECT peril_type
                FROM giis_peril
               WHERE UPPER (line_cd) = UPPER (p_line_cd)
                 AND UPPER (peril_name) = UPPER (p_peril_name))
        INTO v_exist
        FROM DUAL;

      IF (v_exist = 'A')
      THEN
         RETURN 'A';
      ELSIF (v_exist = 'B')
      THEN
         RETURN 'B';
      ELSE
         RETURN 0;
      END IF;
   END peril_name_exist;
   
   /*
   **   Created by: Kenneth L.
   **   Description:Query warranty and clause list based on given line
   **   Date Created: 11.22.2012
   */
   FUNCTION get_giis_warr_cla (
      p_line_cd    IN   giis_line.line_cd%TYPE,
      p_peril_cd   IN   giis_peril.peril_cd%TYPE
   )
      RETURN warr_cla_list_tab PIPELINED
   IS
      v_warrcla   warr_cla_list_type;
   BEGIN
      FOR i IN (SELECT b.main_wc_cd, b.wc_title, a.user_id,
                       TO_CHAR (a.last_update,
                                'MM-DD-YYYY HH:MI:SS AM'
                               ) last_update
                  FROM giis_peril_clauses a, giis_warrcla b
                  WHERE a.line_cd = b.line_cd
                  AND a.main_wc_cd = b.main_wc_cd
                  AND a.line_cd = p_line_cd
                  AND a.peril_cd = p_peril_cd
                  ORDER BY b.main_wc_cd)
      LOOP
         v_warrcla.main_wc_cd := i.main_wc_cd;
         v_warrcla.wc_title := i.wc_title;
         v_warrcla.user_id := i.user_id;
         v_warrcla.last_update := i.last_update;
         PIPE ROW (v_warrcla);
      END LOOP;

      RETURN;
   END get_giis_warr_cla;
   
   /*
   **   Created by: Kenneth L.
   **   Description:Query list of warranty code based on given line and peril from giis_peril_clauses for LOV
   **   Date Created: 11.22.2012
   */
    FUNCTION get_giis_warrcla_list(p_line_cd giis_peril.line_cd%TYPE, p_peril_cd giis_peril.peril_cd%TYPE, p_find_cd giis_warrcla.main_wc_cd%TYPE, p_find_title giis_warrcla.wc_title%TYPE)
      RETURN warr_cla_list_tab PIPELINED
   IS
      v_giis_warrcla   warr_cla_list_type;
   BEGIN
      FOR i IN (SELECT main_wc_cd, wc_title
                    FROM giis_warrcla
                    WHERE line_cd = p_line_cd
                    AND main_wc_cd NOT IN(SELECT main_wc_cd
                                            FROM giis_peril_clauses
                                            WHERE line_cd = p_line_cd
                                            AND peril_cd = p_peril_cd)
                    AND (UPPER(main_wc_cd) like UPPER(p_find_cd)
                         OR UPPER(wc_title) like UPPER(p_find_title))
                     ORDER BY main_wc_cd)
                       
      LOOP
         v_giis_warrcla.main_wc_cd := i.main_wc_cd;
         v_giis_warrcla.wc_title := i.wc_title;
         PIPE ROW (v_giis_warrcla);
      END LOOP;
      
          
      RETURN;
          
   END get_giis_warrcla_list;
   
   /*
   **   Created by: Kenneth L.
   **   Description:add a warranty row in giis_peril_clauses
   **   Date Created: 11.22.2012
   */
   PROCEDURE set_warrcla (p_peril_clauses giis_peril_clauses%ROWTYPE)
   IS
   BEGIN
        INSERT INTO giis_peril_clauses (line_cd, peril_cd, main_wc_cd, user_id, last_update)
          VALUES (p_peril_clauses.line_cd, p_peril_clauses.peril_cd, p_peril_clauses.main_wc_cd, p_peril_clauses.user_id, SYSDATE);
   END set_warrcla;
   
   /*
   **   Created by: Kenneth L.
   **   Description:delete a warranty row in giis_peril_clauses
   **   Date Created: 11.22.2012
   */
   PROCEDURE delete_warrcla (
      p_line_cd    giis_peril.line_cd%TYPE,
      p_peril_cd   giis_peril.peril_cd%TYPE,
      p_main_wc_cd  giis_peril_clauses.main_wc_cd%TYPE
   )
   IS
   BEGIN
      DELETE giis_peril_clauses
        WHERE line_cd = p_line_cd
        AND peril_cd = p_peril_cd
        AND main_wc_cd = p_main_wc_cd;
   END delete_warrcla;
   
   /*
   **  Created by   : Cherrie
   **  Date Created : 10.19.2012
   **  Reference By : (GIISS003 - Peril Maintenance)
   **  Description  : query tariff by linecd and perilcd
   */
   FUNCTION get_tariff (
      p_line_cd    IN   giis_line.line_cd%TYPE,
      p_peril_cd   IN   giis_peril.peril_cd%TYPE
   )
      RETURN tariff_list_tab PIPELINED
   IS
      v_tariff   tariff_list_type;
   BEGIN
      FOR i IN (SELECT a.tarf_cd, b.tarf_desc, a.user_id,
                       TO_CHAR (a.last_update,
                                'YYYY-MM-DD HH:MI:SS AM'
                               ) last_update
                  FROM giis_peril_tariff a, giis_tariff b
                 WHERE a.tarf_cd = b.tarf_cd
                   AND a.line_cd = p_line_cd
                   AND a.peril_cd = p_peril_cd
                   ORDER BY a.tarf_cd)
      LOOP
         v_tariff.tarf_cd := i.tarf_cd;
         v_tariff.tarf_desc := i.tarf_desc;
         v_tariff.user_id := i.user_id;
         v_tariff.last_update := i.last_update;
         PIPE ROW (v_tariff);
      END LOOP;

      RETURN;
   END get_tariff;
   
   /*
   **   Created by: Kenneth L.
   **   Description:Query list of tariff based on given line and peril from giis_peril_tariff for LOV
   **   Date Created: 11.22.2012
   */
   FUNCTION get_giis_tariff_list(p_line_cd giis_peril.line_cd%TYPE, p_peril_cd giis_peril.peril_cd%TYPE, p_find_cd giis_warrcla.main_wc_cd%TYPE, p_find_title giis_warrcla.wc_title%TYPE)
      RETURN tariff_list_tab PIPELINED
   IS
      v_giis_tariff   tariff_list_type;
      
   BEGIN
      FOR i IN (SELECT tarf_cd, tarf_desc
                    FROM giis_tariff
                    WHERE tarf_cd NOT IN (SELECT tarf_cd
                                            FROM giis_peril_tariff
                                            WHERE peril_cd = p_peril_cd
                                            AND line_cd = p_line_cd)
                    AND (UPPER(tarf_cd) like UPPER(p_find_cd)
                         OR UPPER(tarf_desc) like UPPER(p_find_title))
                    ORDER BY tarf_cd)
      LOOP
         v_giis_tariff.tarf_cd := i.tarf_cd;
         v_giis_tariff.tarf_desc := i.tarf_desc;
         PIPE ROW (v_giis_tariff);
      END LOOP;

      RETURN;
   END get_giis_tariff_list;

    /*
   **   Created by: Kenneth L.
   **   Description:add a tariff row in giis_peril_tariff
   **   Date Created: 11.22.2012
   */
   PROCEDURE set_tariff (p_peril_tariff giis_peril_tariff%ROWTYPE)
   IS
   BEGIN
        INSERT INTO giis_peril_tariff (line_cd, peril_cd, tarf_cd ,user_id, last_update)
          VALUES (p_peril_tariff.line_cd, p_peril_tariff.peril_cd, p_peril_tariff.tarf_cd, p_peril_tariff.user_id, SYSDATE);
   END set_tariff;
   
   /*
   **   Created by: Kenneth L.
   **   Description:delete a tariff row in giis_peril_tariff
   **   Date Created: 11.22.2012
   */
   PROCEDURE delete_tariff (
      p_line_cd    giis_peril.line_cd%TYPE,
      p_peril_cd   giis_peril.peril_cd%TYPE,
      p_tarf_cd    giis_tariff.tarf_cd%TYPE
   )
   IS
   BEGIN
      DELETE giis_peril_tariff
        WHERE line_cd = p_line_cd
        AND peril_cd = p_peril_cd
        AND tarf_cd = p_tarf_cd;
   END delete_tariff;

    /*
   **   Created by: Kenneth L.
   **   Description:validates tariff deletion
   **   Date Created: 11.22.2012
   */
   FUNCTION validate_delete_tariff (
      p_line_cd    giis_peril.line_cd%TYPE,
      p_peril_cd   giis_peril.peril_cd%TYPE,
      p_tarf_cd    giis_tariff.tarf_cd%TYPE
   )
      RETURN VARCHAR
   IS
      v_line_cd    VARCHAR2 (30);
      v_line_cd2   VARCHAR2 (30);
   BEGIN
      SELECT (SELECT DISTINCT UPPER ('gipi_witmperl')
                         FROM gipi_witmperl w
                        WHERE LOWER (w.line_cd) LIKE LOWER (p_line_cd)
                          AND LOWER (w.peril_cd) LIKE LOWER (p_peril_cd)
                          AND LOWER (w.tarf_cd) LIKE LOWER (p_tarf_cd)) a,
             (SELECT DISTINCT UPPER ('gipi_itmperil')
                         FROM gipi_itmperil i
                        WHERE LOWER (i.line_cd) LIKE LOWER (p_line_cd)
                          AND LOWER (i.peril_cd) LIKE LOWER (p_peril_cd)
                          AND LOWER (i.tarf_cd) LIKE LOWER (p_tarf_cd)) b
        INTO v_line_cd,
             v_line_cd2
        FROM DUAL;

      IF v_line_cd IS NOT NULL
      THEN
         RETURN v_line_cd;
      END IF;

      IF v_line_cd2 IS NOT NULL
      THEN
         RETURN v_line_cd2;
      END IF;

      RETURN '1';
   END validate_delete_tariff;
   
   
   /*
   **   Created by: Kenneth L.
   **   Description:validation  for default tsi value
   **   Date Created: 11.22.2012
   */
   FUNCTION check_default_tsi (
      p_line_cd      giis_line.line_cd%TYPE,
      p_peril_cd     giis_peril.peril_cd%TYPE,
      p_default_tsi  giis_peril.default_tsi%TYPE,
      p_basc_perl_cd            giis_peril.basc_perl_cd%TYPE
   )
      RETURN VARCHAR
   IS
      v_basc_perl_cd            giis_peril.basc_perl_cd%TYPE;
      v_basc_perl_cd_tsi        giis_peril.default_tsi%TYPE;
      v_peril_name              giis_peril.peril_name%TYPE;
      v_basc_tsi_less_allied    giis_peril.default_tsi%TYPE;
      v_basc_perl_cd_max_tsi    giis_peril.default_tsi%TYPE;
      v_allied_min_tsi          giis_peril.default_tsi%TYPE;
      v_peril_name1             giis_peril.peril_name%TYPE;
      
   BEGIN 
      BEGIN
		  SELECT (SELECT basc_perl_cd
					FROM giis_peril
				   WHERE line_cd = p_line_cd
					 AND peril_cd = p_peril_cd)
			INTO v_basc_perl_cd
			FROM DUAL;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
       NULL;
      END;
      BEGIN  
		  SELECT (SELECT default_tsi
					FROM giis_peril
				   WHERE line_cd = p_line_cd
					 AND peril_cd = NVL(p_basc_perl_cd, null))
			INTO v_basc_perl_cd_tsi
			FROM DUAL;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
      	NULL;
      END;
      BEGIN
		  SELECT (SELECT peril_name
					FROM giis_peril
				   WHERE line_cd = p_line_cd
					 AND peril_cd = NVL(p_basc_perl_cd, null))
			INTO v_peril_name
			FROM DUAL;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
      	NULL;
      END;
     BEGIN     
		 SELECT (SELECT max(default_tsi)
					FROM giis_peril
				   WHERE line_cd = p_line_cd
					 AND basc_perl_cd = NVL(p_peril_cd, null))
			INTO v_basc_tsi_less_allied
			FROM DUAL;
     EXCEPTION
      WHEN NO_DATA_FOUND THEN
      	NULL;
     END;
     BEGIN 
		 SELECT MAX(default_tsi), NVL(peril_name,'-#geniisys#-')
		   INTO v_basc_perl_cd_max_tsi, v_peril_name1
		   FROM giis_peril
		  WHERE line_cd = p_line_cd
			AND peril_type = 'B'
			AND default_tsi IS NOT NULL
			AND ROWNUM = 1
		  GROUP BY peril_name;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
      	NULL;
      END;
      BEGIN  
		  SELECT (SELECT MIN(default_tsi)
					FROM giis_peril
				   WHERE line_cd = p_line_cd
					 AND peril_type = 'A')
			INTO v_allied_min_tsi
			FROM DUAL;
        EXCEPTION
      WHEN NO_DATA_FOUND THEN
      	NULL;
      END;
        --basic peril default tsi is less than its attahed allied
      IF (NVL(p_default_tsi, 0) < v_basc_tsi_less_allied)
      THEN
         RETURN '0';
      --basic peril default tsi is less than the min tsi of all allied peril
      ELSIF (p_default_tsi < v_allied_min_tsi)
      THEN
         RETURN '1';
      --allied default tsi is greater than its basic peril
      ELSIF (NVL(p_default_tsi, 0) > v_basc_perl_cd_tsi)
      THEN
         RETURN v_peril_name;
        --allied default tsi is greater than the max tsi of all basic peril
      ELSIF (p_default_tsi > v_basc_perl_cd_max_tsi)
      THEN
         RETURN v_peril_name1;
        
      ELSE
         RETURN '2';
      END IF;
         
   END check_default_tsi;
   
   /*
   **   Created by: Kenneth L.
   **   Description:retrieve name of the subline cd
   **   Date Created: 11.22.2012
   */
   FUNCTION get_sublinecd_name (
      p_line_cd     giis_line.line_cd%TYPE,
      p_subline_cd  giis_peril.subline_cd%TYPE
   )
      RETURN VARCHAR
   IS
        v_subline_name  giis_subline.subline_name%TYPE;
        
    BEGIN 
      SELECT (SELECT subline_name
                FROM giis_subline       
               WHERE line_cd = p_line_cd
                 AND subline_cd = p_subline_cd)
        INTO v_subline_name
     FROM DUAL;
    
       IF v_subline_name IS NOT NULL
       THEN
          RETURN v_subline_name;
       ELSE
          RETURN null;
       END IF;
       
    END get_sublinecd_name;
    
    /*
   **   Created by: Kenneth L.
   **   Description:retrieve name of the basic peril code
   **   Date Created: 11.22.2012
   */
   FUNCTION get_basicperilcd_name (
      p_line_cd     giis_line.line_cd%TYPE,
      p_basic_peril_cd    giis_peril.peril_cd%TYPE
   )
      RETURN VARCHAR
   IS
        v_peril_name  giis_peril.peril_name%TYPE;
        
    BEGIN 
      SELECT (SELECT peril_name
                FROM giis_peril
               WHERE line_cd = p_line_cd
                 AND peril_cd = p_basic_peril_cd)
        INTO v_peril_name
     FROM DUAL;
    
       IF v_peril_name IS NOT NULL
       THEN
          RETURN v_peril_name;
       ELSE
          RETURN null;
       END IF;
       
    END get_basicperilcd_name;
    
    /*
   **   Created by: Kenneth L.
   **   Description:retrieve name of the FI zone type
   **   Date Created: 11.22.2012
   */
    FUNCTION get_zonenamefi_name (
      p_zone_type     giis_peril.zone_type%TYPE
   )
      RETURN VARCHAR
   IS
        v_zonefi_name  cg_ref_codes.rv_meaning%TYPE;
        
    BEGIN 
      SELECT (SELECT min(rv_meaning)
                FROM cg_ref_codes
                WHERE (rv_domain = 'GIPI_FIRESTAT_EXTRACT.ZONE_TYPE'
                        OR rv_domain = 'GIPI_FIRESTAT_EXTRACT.EQ_ZONE_TYPE')
                AND rv_low_value = p_zone_type)
        INTO v_zonefi_name
     FROM DUAL;
    
       IF v_zonefi_name IS NOT NULL
       THEN
          RETURN v_zonefi_name;
       ELSE
          RETURN null;
       END IF;
       
    END get_zonenamefi_name;
    
    /*
   **   Created by: Kenneth L.
   **   Description:retrieve name of the MC zone type
   **   Date Created: 11.22.2012
   */
    FUNCTION get_zonenamemc_name (
      p_zone_type     giis_peril.zone_type%TYPE
   )
      RETURN VARCHAR
   IS
        v_zonemc_name  cg_ref_codes.rv_meaning%TYPE;
        
    BEGIN 
      SELECT (SELECT min(rv_meaning)
                FROM cg_ref_codes
                WHERE rv_domain like 'GIIS_PERIL.ZONE_TYPE'
                AND rv_low_value = p_zone_type)
        INTO v_zonemc_name
     FROM DUAL;
    
       IF v_zonemc_name IS NOT NULL
       THEN
          RETURN v_zonemc_name;
       ELSE
          RETURN null;
       END IF;
       
    END get_zonenamemc_name;
    
    /*
   **   Created by: Kenneth L.
   **   Description:checks if there are available warranty and clause based on the given line
   **   Date Created: 11.22.2012
   */
    FUNCTION check_available_warrcla (
      p_line_cd     giis_line.line_cd%TYPE
   )
      RETURN VARCHAR
    IS
        x   VARCHAR2(1);
    BEGIN 
      SELECT (SELECT DISTINCT '*'
                FROM giis_warrcla
                WHERE line_cd = p_line_cd)
        INTO x
     FROM DUAL;
    
       IF x IS NOT NULL
       THEN
          RETURN '0';
       ELSE
          RETURN '1';
       END IF;
       
    END check_available_warrcla;
    
    PROCEDURE validate_delete_peril2 (
       p_line_cd    giis_line.line_cd%TYPE,
       p_peril_cd   giis_peril.peril_cd%TYPE
    )
    IS
       v_select   VARCHAR2 (500);
       v_out      VARCHAR2 (50);
    BEGIN
       BEGIN
        SELECT 'GIIS_PERIL'
          INTO v_out
          FROM giis_peril
         WHERE line_cd = p_line_cd
           AND basc_perl_cd = p_peril_cd;
       EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_out := null;
       END; 
       
       IF v_out IS NULL
       THEN
           BEGIN
            SELECT 'GIIS_PACK_PLAN_COVER_DTL'
              INTO v_out
              FROM giis_pack_plan_cover_dtl
             WHERE pack_line_cd = p_line_cd
               AND peril_cd = p_peril_cd;
           EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_out := null;
           END; 
           
           IF v_out IS NULL
           THEN
               FOR i IN (SELECT table_name
                           FROM all_constraints
                          WHERE r_constraint_name IN (SELECT constraint_name
                                                        FROM all_constraints
                                                       WHERE table_name = 'GIIS_PERIL')
                            AND table_name NOT IN
                                               ('GIIS_PERIL', 'GIIS_PACK_PLAN_COVER_DTL'))
               LOOP
                  v_select :=
                        'SELECT DISTINCT '''
                     || i.table_name
                     || ''' FROM '
                     || i.table_name
                     || ' WHERE LINE_CD = '''
                     || p_line_cd
                     || ''' AND PERIL_CD = '
                     || p_peril_cd
                     || '';

                  BEGIN
                     EXECUTE IMMEDIATE v_select
                                  INTO v_out;

                     EXIT;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        v_out := '';
                  END;
               END LOOP;  
               
               IF v_out IS NOT NULL
               THEN
                  raise_application_error
                     (-20001,
                         'Geniisys Exception#E#Cannot delete record from GIIS_PERIL while dependent record(s) in '
                      || UPPER(v_out)
                      || ' exists.'
                     );
               END IF;                        
           ELSE
               raise_application_error
                 (-20001,
                     'Geniisys Exception#E#Cannot delete record from GIIS_PERIL while dependent record(s) in '
                  || UPPER(v_out)
                  || ' exists.'
                 );
           END IF;
       ELSE
          raise_application_error
             (-20001,
                 'Geniisys Exception#E#Cannot delete record from GIIS_PERIL while dependent record(s) in '
              || UPPER(v_out)
              || ' exists.'
             );       
       END IF;        
    END validate_delete_peril2;
END giiss003_pkg;
/


