CREATE OR REPLACE PACKAGE BODY CPI.giis_city_pkg
AS
/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS003
  RECORD GROUP NAME: CITY_RG
***********************************************************************************/
   FUNCTION get_city_list
      RETURN city_list_tab PIPELINED
   IS
      v_city   city_list_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.city, a.city_cd, a.province_cd,
                                b.province_desc
                           FROM giis_city a, giis_province b
                          WHERE a.province_cd = b.province_cd(+)
                       ORDER BY city)
      LOOP
         v_city.city := i.city;
         v_city.city_cd := i.city_cd;
         v_city.province_cd := i.province_cd;
         v_city.province := i.province_desc;
         PIPE ROW (v_city);
      END LOOP;

      RETURN;
   END get_city_list;

/********************************** FUNCTION 2 ************************************
  MODULE: GIPIS003
  RECORD GROUP NAME: CITY_RG1
***********************************************************************************/
   FUNCTION get_city_by_province_list (
      p_region_cd     IN   giis_province.region_cd%TYPE,
      p_province_cd   IN   giis_province.province_cd%TYPE
   )
      RETURN city_by_province_list_tab PIPELINED
   IS
      v_city   city_by_province_list_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.city, a.city_cd, a.province_cd,
                                b.province_desc, b.region_cd
                           FROM giis_block a, giis_province b
                          WHERE a.province_cd = b.province_cd(+)
                            AND a.province_cd =
                                   DECODE (NVL (p_province_cd, '*'),
                                           '*', a.province_cd,
                                           p_province_cd
                                          )
                            AND b.region_cd =
                                   DECODE (NVL (p_region_cd, 0),
                                           0, b.region_cd,
                                           p_region_cd
                                          )
                       ORDER BY b.province_desc, a.city)
      LOOP
         v_city.city := i.city;
         v_city.city_cd := i.city_cd;
         v_city.province_cd := i.province_cd;
         v_city.province_desc := i.province_desc;
         v_city.region_cd := i.region_cd;
         PIPE ROW (v_city);
      END LOOP;

      RETURN;
   END get_city_by_province_list;

/********************************** FUNCTION 3 ************************************
  MODULE: GIIMM002
  RECORD GROUP NAME: LOV_CITY
***********************************************************************************/
   FUNCTION get_city_province_list (
      p_province_desc   giis_province.province_desc%TYPE
   )
      RETURN city_by_province_list_tab PIPELINED
   IS
      v_city   city_by_province_list_type;
   BEGIN
      FOR i IN (SELECT   a.city, b.province_desc
                    FROM giis_city a, giis_province b
                   WHERE a.province_cd = b.province_cd
                     AND province_desc = NVL (p_province_desc, province_desc)
                ORDER BY b.province_desc, a.city)
      LOOP
         v_city.city := i.city;
         v_city.province_desc := i.province_desc;
         PIPE ROW (v_city);
      END LOOP;

      RETURN;
   END get_city_province_list;

   /*
   **  Created by        : Andrew Robes
   **  Date Created     : 04.20.2011
   **  Reference By     : (GIPIS039 - Endt Fire Item Information)
   **  Description     : This procedure is used for retrieving city lov
   */
   FUNCTION get_city_listing (
      p_region_cd     giis_province.region_cd%TYPE,
      p_province_cd   giis_province.province_cd%TYPE,
      p_find_text     VARCHAR2
   )
      RETURN city_by_province_list_tab PIPELINED
   IS
      v_city   city_by_province_list_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT a.city_cd, a.city, b.province_cd, b.province_desc,
                          b.region_cd
                     FROM giis_block a, giis_province b
                    WHERE a.province_cd = b.province_cd
                      AND a.province_cd = NVL (p_province_cd, a.province_cd)
                      AND b.region_cd = NVL (p_region_cd, b.region_cd)
                      AND (   UPPER (b.province_desc) LIKE
                                               UPPER (NVL (p_find_text, '%%'))
                           OR UPPER (a.city) LIKE
                                               UPPER (NVL (p_find_text, '%%'))
                          )
                 ORDER BY a.city)
      LOOP
         v_city.city := i.city;
         v_city.city_cd := i.city_cd;
         v_city.province_cd := i.province_cd;
         v_city.province_desc := i.province_desc;
         v_city.region_cd := i.region_cd;
         PIPE ROW (v_city);
      END LOOP;

      RETURN;
   END get_city_listing;

   FUNCTION get_city_listing_gicls010 (
      p_province_cd   giis_province.province_cd%TYPE
   )
      RETURN city_list_tab PIPELINED
   IS
   v_city city_list_type;
   BEGIN
      FOR i IN (SELECT a.city, a.city_cd, b.province_cd, b.province_desc
                  FROM giis_city a, giis_province b
                 WHERE a.province_cd = NVL (p_province_cd, a.province_cd)
                    AND b.province_cd = a.province_cd
                    )
      LOOP
         v_city.city        := i.city;
         v_city.city_cd     := i.city_cd;
         v_city.province    := i.province_desc;
         v_city.province_cd := i.province_cd;
         PIPE ROW(v_city);
      END LOOP;
   END;
   
   
   /*
   **  Created by       : Marie Kris Felipe
   **  Date Created     : 09.20.2013
   **  Reference By     : (GICLS200 - Outstanding and Paid Claims per Catastrophic Event )
   **  Description      : Function for retrieving location LOV
   */
   FUNCTION get_location_lov(p_keyword VARCHAR2)
        RETURN location_tab PIPELINED
   IS
    v_location      location_type;
   BEGIN
   
        FOR rec IN (SELECT DISTINCT A.PROVINCE_CD||'-'||A.CITY_CD LOCATION_CD, 
                           C.CITY||', '||B.PROVINCE_DESC LOCATION
                      FROM GICL_CLAIMS A, GIIS_PROVINCE B, GIIS_CITY C
                     WHERE A.CATASTROPHIC_CD IS NOT NULL
                       AND A.PROVINCE_CD = B.PROVINCE_CD
                       AND B.PROVINCE_CD = C.PROVINCE_CD
                       AND A.CITY_CD = C.CITY_CD
                       AND (   UPPER (A.PROVINCE_CD||'-'||A.CITY_CD) LIKE UPPER (NVL (p_keyword, '%'))
                            OR UPPER (C.CITY||', '||B.PROVINCE_DESC) LIKE UPPER (NVL (p_keyword, '%'))
                            )
                     ORDER BY A.PROVINCE_CD||'-'||A.CITY_CD)
        LOOP
            v_location.location_cd := rec.location_cd;
            v_location.location_desc := rec.location;
            
            PIPE ROW(v_location);
        END LOOP;
        
   END get_location_lov;
   
   
   /** Created By:      Shan Bati
    ** Date Created:    09.30.2013
    ** Referenced By:   GIPIS155 - Update Policy District Etc
    **/
   FUNCTION get_city_listing_gipis155(
        p_province_cd   GIIS_CITY.PROVINCE_CD%type
    ) RETURN city_list_tab PIPELINED
    AS
        lov     city_list_type;
    BEGIN
        FOR i IN (select city, city_cd
                    from giis_city
                    where province_cd = p_province_cd  )
        LOOP
            lov.city_cd     := i.city_cd;
            lov.city        := i.city;
            
            PIPE ROW(lov);
        END LOOP;
    END get_city_listing_gipis155;  
   
END giis_city_pkg;
/


