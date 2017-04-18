CREATE OR REPLACE PACKAGE BODY CPI.giiss208_pkg
AS
      /*
     **  Created by        : Christopher Jubilo
     **  Date Created     : 10.16.2012
     **  Reference By     : (GIISS208- Peril Depreciation
     **  Description     : Returns record listing for  Peril Depreciation
     **  Modified By      : Kenneth L. 11.12.2012
     */
     
     /*retrieves the line list*/
  
   FUNCTION get_giis_line_item(p_user_id VARCHAR2)
      RETURN giis_line_tab PIPELINED
   IS
      v_giis_line   giis_line_type;
   BEGIN
      FOR i IN (SELECT   line_cd, line_name
                    FROM giis_line
                    WHERE check_user_per_line2(line_cd, NULL, 'GIISS208', p_user_id) = 1
                ORDER BY line_cd)
      LOOP
         v_giis_line.line_cd := i.line_cd;
         v_giis_line.line_name := i.line_name;
         PIPE ROW (v_giis_line);
      END LOOP;

      RETURN;
   END get_giis_line_item;

    /*retrieves peril code and peril name of a given line code to be used for LOV*/
   FUNCTION get_giis_peril_list_item (p_line_cd giis_line.line_cd%TYPE, p_peril_cd VARCHAR2, p_peril_name giis_peril.peril_name%TYPE)
      RETURN giis_peril_list_tab PIPELINED
   IS
      v_giis_peril_list   giis_peril_list_type;
   BEGIN
      FOR i IN (SELECT   p.peril_cd, p.peril_name
                    FROM giis_peril p, giis_line l
                   WHERE p.line_cd = l.line_cd
                   AND l.line_cd = p_line_cd
                   AND (UPPER(p.peril_cd) like UPPER(p_peril_cd)                --added by : kenneth L.
                         OR UPPER(p.peril_name) like UPPER(p_peril_name))       --added by : kenneth L.
                ORDER BY p.peril_cd)
      LOOP
         v_giis_peril_list.peril_cd := i.peril_cd;
         v_giis_peril_list.peril_name := i.peril_name;
         PIPE ROW (v_giis_peril_list);
      END LOOP;

      RETURN;
   END get_giis_peril_list_item;

    /*retrieves peril code, peril name and rate of a given line code*/
   FUNCTION get_giis_peril_dep_item (p_line_cd giis_line.line_cd%TYPE)
      RETURN giis_peril_depreciation_tab PIPELINED
   IS
      v_peril_depreciation   giis_peril_depreciation_type;
   BEGIN
      FOR i IN (SELECT   a.line_cd, a.line_name, b.peril_cd, c.peril_name,
                         b.rate, b.user_id,
                         TO_CHAR (b.last_update,
                                  'MM-DD-YYYY HH:MI:SS AM'
                                 ) last_update, b.remarks
                    FROM giis_line a, giex_dep_perl b, giis_peril c
                   WHERE a.line_cd = b.line_cd
                     AND b.line_cd = c.line_cd
                     AND b.peril_cd = c.peril_cd
                     AND a.line_cd = p_line_cd
                ORDER BY b.peril_cd)
      LOOP
         v_peril_depreciation.line_cd := i.line_cd;
         v_peril_depreciation.line_name := i.line_name;
         v_peril_depreciation.peril_cd := i.peril_cd;
         v_peril_depreciation.peril_name := i.peril_name;
         v_peril_depreciation.rate := i.rate;
         v_peril_depreciation.user_id := i.user_id;
         v_peril_depreciation.last_update := i.last_update;
         v_peril_depreciation.remarks := i.remarks;
         PIPE ROW (v_peril_depreciation);
      END LOOP;

      RETURN;
   END get_giis_peril_dep_item;

    /*when adding this function validates if there is an existing peril code in the line chosen*/
   FUNCTION validate_add_perilcd (p_line_cd    giis_line.line_cd%TYPE,
      p_peril_cd   giis_peril.peril_cd%TYPE)
   
   RETURN VARCHAR2
   IS
       v_peril_cd     VARCHAR2 (2);
    BEGIN
         SELECT( SELECT '0'
                     FROM giex_dep_perl
                    WHERE LOWER (peril_cd) LIKE LOWER (p_peril_cd)
                    AND LOWER (line_cd) LIKE LOWER (p_line_cd)
                )
           INTO v_peril_cd
         FROM DUAL;

       IF v_peril_cd IS NOT NULL
       THEN
          RETURN v_peril_cd;
      END IF;
       
       RETURN '1';
    END validate_add_perilcd;
    
    /*used for inserting and updating a peril depreciation*/
   PROCEDURE set_giis_peril_dep_item (p_dep_perl giex_dep_perl%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giex_dep_perl
         USING DUAL
         ON (line_cd = p_dep_perl.line_cd AND peril_cd = p_dep_perl.peril_cd)
         WHEN NOT MATCHED THEN
            INSERT (line_cd, peril_cd, user_id, rate, last_update, remarks)
            VALUES (p_dep_perl.line_cd, p_dep_perl.peril_cd,
                    p_dep_perl.user_id, p_dep_perl.rate, SYSDATE, p_dep_perl.remarks)
         WHEN MATCHED THEN
            UPDATE
               SET user_id = p_dep_perl.user_id, rate = p_dep_perl.rate,
                   last_update = SYSDATE, remarks = p_dep_perl.remarks
            ;
   END set_giis_peril_dep_item;

    /*used for deleting a peril depreciation*/
   PROCEDURE del_giis_peril_dep_item (
      p_line_cd    giis_line.line_cd%TYPE,
      p_peril_cd   giis_peril.peril_cd%TYPE
   )
   IS
   BEGIN
      DELETE FROM giex_dep_perl
            WHERE line_cd = p_line_cd AND peril_cd = p_peril_cd;
   END del_giis_peril_dep_item;
END;
/


