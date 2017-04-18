CREATE OR REPLACE PACKAGE BODY CPI.giis_block_pkg
AS
   /********************************** FUNCTION 1 ************************************
     MODULE: GIPIS003
     RECORD GROUP NAME: BLOCK_NO
   ***********************************************************************************/
   /*
   **  Modified by      : Mark JM
   **  Date Created  : 03.03.2010
   **  Reference By  : (GIPIS003 - Item Information)
   **  Description   : Add DECODE for all parameters used in order to return records
   **             : even parameters are null
    */
   FUNCTION get_block_list (
      p_region_cd     IN   giis_province.region_cd%TYPE,
      p_province_cd   IN   giis_block.province_cd%TYPE,
      p_city_cd       IN   giis_block.city_cd%TYPE,
      p_district_no   IN   giis_block.district_no%TYPE
   )
      RETURN block_list_tab PIPELINED
   IS
      v_block   block_list_type;
   BEGIN
      FOR i IN (SELECT   a.block_no, a.block_id, a.district_no,
                         a.district_desc, a.block_desc, a.province_cd,
                         a.city_cd, b.province_desc, a.city, a.eq_zone,
                         a.typhoon_zone, a.flood_zone, c.eq_desc,
                         d.typhoon_zone_desc, e.flood_zone_desc, b.region_cd
                    FROM giis_block a,
                         giis_province b,
                         giis_eqzone c,
                         giis_typhoon_zone d,
                         giis_flood_zone e
                   WHERE a.eq_zone = c.eq_zone(+)
                     AND a.flood_zone = e.flood_zone(+)
                     AND a.typhoon_zone = d.typhoon_zone(+)
                     AND a.province_cd = b.province_cd(+)
                     AND b.region_cd =
                            DECODE (NVL (p_region_cd, 0),
                                    0, b.region_cd,
                                    p_region_cd
                                   )
                     AND b.province_cd =
                            DECODE (NVL (p_province_cd, '*'),
                                    '*', b.province_cd,
                                    p_province_cd
                                   )
                     AND a.city_cd =
                            DECODE (NVL (p_city_cd, '*'),
                                    '*', a.city_cd,
                                    p_city_cd
                                   )
                     AND a.district_no =
                            DECODE (NVL (p_district_no, '*'),
                                    '*', a.district_no,
                                    p_district_no
                                   )
                ORDER BY b.province_desc, a.city, a.district_no, a.block_no)
      LOOP
         v_block.block_no := i.block_no;
         v_block.block_id := i.block_id;
         v_block.district_no := i.district_no;
         v_block.district_desc := i.district_desc;
         v_block.block_desc := i.block_desc;
         v_block.region_cd := i.region_cd;
         v_block.province_cd := i.province_cd;
         v_block.province_desc := i.province_desc;
         v_block.city_cd := i.city_cd;
         v_block.city := i.city;
         v_block.eq_zone := i.eq_zone;
         v_block.typhoon_zone := i.typhoon_zone;
         v_block.flood_zone := i.flood_zone;
         v_block.eq_desc := i.eq_desc;
         v_block.typhoon_zone_desc := i.typhoon_zone_desc;
         v_block.flood_zone_desc := i.flood_zone_desc;
         PIPE ROW (v_block);
      END LOOP;

      RETURN;
   END get_block_list;

   FUNCTION get_all_block_list
      RETURN all_block_list_tab PIPELINED
   IS
      v_block   all_block_list_type;
   BEGIN
      FOR i IN (SELECT   /*+ NO_CPU_COSTING */
                         a.block_no, a.block_id, a.district_no,
                         a.district_desc, a.block_desc, a.province_cd,
                         a.city_cd, c.eq_desc, d.typhoon_zone_desc,
                         e.flood_zone_desc, a.eq_zone, a.typhoon_zone,
                         a.flood_zone
                    FROM giis_block a,
                         giis_province b,
                         giis_eqzone c,
                         giis_typhoon_zone d,
                         giis_flood_zone e
                   WHERE a.eq_zone = c.eq_zone(+)
                     AND a.flood_zone = e.flood_zone(+)
                     AND a.typhoon_zone = d.typhoon_zone(+)
                     AND a.province_cd = b.province_cd(+)
                /* AND b.province_desc = DECODE(p_province_desc, '*', b.province_desc, p_province_desc)
                 AND a.city          = DECODE(p_city, '*', a.city, p_city)
                 AND a.district_no   = DECODE(p_district_no, '*', a.district_no, p_district_no)*/
                ORDER BY a.block_no)
      LOOP
         v_block.block_no := i.block_no;
         v_block.block_id := i.block_id;
         v_block.block_desc := i.block_desc;
         v_block.city_cd := i.city_cd;
         v_block.district_no := i.district_no;
         v_block.district_desc := i.district_desc;
         v_block.eq_zone := i.eq_zone;
         v_block.flood_zone := i.flood_zone;
         v_block.typhoon_zone := i.typhoon_zone;
         v_block.province_cd := i.province_cd;
         PIPE ROW (v_block);
      END LOOP;

      RETURN;
   END get_all_block_list;

   FUNCTION get_block_id (
      p_province_cd   giis_block.province_cd%TYPE,
      p_city_cd       giis_block.city_cd%TYPE,
      p_district_no   giis_block.district_no%TYPE,
      p_block_no      giis_block.block_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_block_id   VARCHAR2 (12);
   BEGIN
      SELECT block_id
        INTO v_block_id
        FROM giis_block
       WHERE province_cd = p_province_cd
         AND city_cd = p_city_cd
         AND district_no = p_district_no
         AND block_no = p_block_no;

      RETURN v_block_id;
   END get_block_id;

   FUNCTION get_dtls_from_district (
      p_province_cd   giis_block.city_cd%TYPE,
      p_city_cd       giis_block.province_cd%TYPE
   )
      RETURN giis_block_district_tab PIPELINED
   IS
      v_district   giis_block_district_type;
   BEGIN
      FOR i IN (SELECT DISTINCT district_desc, district_no
                           FROM giis_block
                          WHERE province_cd =
                                             NVL (p_province_cd, province_cd)
                            AND city_cd = NVL (p_city_cd, city_cd))
      LOOP
         FOR j IN (SELECT DISTINCT a.province_cd, b.province_desc, a.city_cd,
                                   a.city
                              FROM giis_block a, giis_province b
                             WHERE district_no = i.district_no
                               AND a.province_cd = b.province_cd)
         LOOP
            v_district.province_cd := j.province_cd;
            v_district.province := j.province_desc;
            v_district.city_cd := j.city_cd;
            v_district.city := j.city;
            EXIT;
         END LOOP;

         v_district.district_no := i.district_no;
         v_district.district_desc := i.district_desc;
         PIPE ROW (v_district);
      END LOOP;
   END;

   FUNCTION get_dtls_from_block (
      p_province_cd   giis_block.city_cd%TYPE,
      p_city_cd       giis_block.province_cd%TYPE,
      p_district_no   giis_block.district_no%TYPE
   )
      RETURN giis_block_district_tab PIPELINED
   IS
      v_district   giis_block_district_type;
   BEGIN
      FOR i IN (SELECT block_desc, block_no, block_id, province_cd,
                       (SELECT b.province_desc
                          FROM giis_province b
                         WHERE b.province_cd = a.province_cd AND rownum = 1) province_desc,
                       city_cd, city, district_no, district_desc
                  FROM giis_block a
                 WHERE province_cd = NVL (p_province_cd, province_cd)
                   AND city_cd = NVL (p_city_cd, city_cd)
                   AND district_no = NVL (p_district_no, district_no))
      LOOP
         v_district.block_desc := i.block_desc;
         v_district.block_no := i.block_no;
         v_district.block_id := i.block_id;
         v_district.province_cd := i.province_cd;
         v_district.province := i.province_desc;
         v_district.city_cd := i.city_cd;
         v_district.city := i.city;
         v_district.district_no := i.district_no;
         v_district.district_desc := i.district_desc;
         PIPE ROW (v_district);
      END LOOP;
   END get_dtls_from_block;
    
    /*
    **  Created by        : Mark JM
    **  Date Created    : 03.03.2010
    **  Reference By    : (GIPIS003 - Item Information)
    **  Description        : Retrieves records for block and district lov
    */
    FUNCTION get_block_list_tg (
        p_region_cd IN giis_province.region_cd%TYPE,
        p_province_cd IN giis_block.province_cd%TYPE,
        p_city_cd IN giis_block.city_cd%TYPE,
        p_district_no IN giis_block.district_no%TYPE,
        p_find_text IN VARCHAR2)
    RETURN block_list_tab PIPELINED
    IS
        v_block   block_list_type;
    BEGIN
        FOR i IN (
            SELECT   a.block_no, a.block_id, a.district_no,
                     a.district_desc, a.block_desc, a.province_cd,
                     a.city_cd, b.province_desc, a.city, a.eq_zone,
                     a.typhoon_zone, a.flood_zone, c.eq_desc,
                     d.typhoon_zone_desc, e.flood_zone_desc, b.region_cd
                FROM giis_block a,
                     giis_province b,
                     giis_eqzone c,
                     giis_typhoon_zone d,
                     giis_flood_zone e
               WHERE a.eq_zone = c.eq_zone(+)
                 AND a.flood_zone = e.flood_zone(+)
                 AND a.typhoon_zone = d.typhoon_zone(+)
                 AND a.province_cd = b.province_cd(+)
                 AND b.region_cd = DECODE (NVL(p_region_cd, 0), 0, b.region_cd, p_region_cd)
                 AND b.province_cd = DECODE (NVL(p_province_cd, '*'), '*', b.province_cd, p_province_cd)
                 AND a.city_cd = DECODE (NVL(p_city_cd, '*'), '*', a.city_cd, p_city_cd)
                 AND a.district_no = DECODE (NVL(p_district_no, '*'), '*', a.district_no, p_district_no)
                 AND a.active_tag = 'Y' -- added by Kris 06.27.2013 for UW-SPECS-2013-00067
                 AND (UPPER(a.district_desc) LIKE (NVL(UPPER(p_find_text), '%%')) OR UPPER(a.block_desc) LIKE (NVL(UPPER(p_find_text), '%%'))
                      OR UPPER(a.block_no) LIKE (NVL(UPPER(p_find_text), '%%')) OR UPPER(a.district_no) LIKE (NVL(UPPER(p_find_text), '%%'))) --added by steven 12.11.2012
           
            ORDER BY b.province_desc, a.city, a.district_no, a.block_no)
      LOOP
         v_block.block_no             := i.block_no;
         v_block.block_id             := i.block_id;
         v_block.district_no         := i.district_no;
         v_block.district_desc         := i.district_desc;
         v_block.block_desc         := i.block_desc;
         v_block.region_cd             := i.region_cd;
         v_block.province_cd         := i.province_cd;
         v_block.province_desc         := i.province_desc;
         v_block.city_cd             := i.city_cd;
         v_block.city                 := i.city;
         v_block.eq_zone             := i.eq_zone;
         v_block.typhoon_zone         := i.typhoon_zone;
         v_block.flood_zone         := i.flood_zone;
         v_block.eq_desc             := i.eq_desc;
         v_block.typhoon_zone_desc     := i.typhoon_zone_desc;
         v_block.flood_zone_desc     := i.flood_zone_desc;
         PIPE ROW (v_block);
      END LOOP;

      RETURN;
   END get_block_list_tg;
    
   
    /*
    **  Created by:     Shan Bati
    **  Date Created:   09.30.2013
    **  Reference By:   GIPIS155 - Update Policy District Etc
    */
    FUNCTION get_district_listing_gipis155(
        p_province_cd       giis_block.PROVINCE_CD%type,
        p_city_cd           giis_block.CITY_CD%type
    ) RETURN gipis155_district_tab PIPELINED
    AS
        lov     gipis155_district_type;
    BEGIN
        FOR i IN (select distinct district_desc, district_no
                    from giis_block
                   where UPPER(province_cd) = UPPER(p_province_cd)
                     and UPPER(city_cd) = UPPER(p_city_cd))
        LOOP
            lov.district_no     := i.district_no;
            lov.district_desc   := i.district_desc;
            
            PIPE ROW(lov);
        END LOOP;       
    END  get_district_listing_gipis155;
    
    
     /*
    **  Created by:     Shan Bati
    **  Date Created:   09.30.2013
    **  Reference By:   GIPIS155 - Update Policy District Etc
    */
    FUNCTION get_block_listing_gipis155(
        p_province_cd       giis_block.PROVINCE_CD%type,
        p_city_cd           giis_block.CITY_CD%type,
        p_district_no       giis_block.DISTRICT_NO%type
    ) RETURN gipis155_block_tab PIPELINED
    AS
        lov     gipis155_block_type;
    BEGIN
        FOR i IN (select distinct block_desc, block_no
                    from giis_block
                   where UPPER(province_cd) = UPPER(p_province_cd)
                     and UPPER(city_cd) = UPPER(p_city_cd)
                     and UPPER(district_no) = UPPER(p_district_no))
        LOOP
            lov.block_no     := i.block_no;
            lov.block_desc   := i.block_desc;
            
            PIPE ROW(lov);
        END LOOP;       
    END get_block_listing_gipis155;
    
    
END giis_block_pkg;
/


