CREATE OR REPLACE PACKAGE BODY CPI.giiss215_pkg
AS
   FUNCTION get_rec_list (
      p_area_cd     giis_banc_area.area_cd%TYPE,
      p_area_desc   giis_banc_area.area_desc%TYPE,
      p_eff_date    VARCHAR2
   )
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT a.area_cd, a.area_desc, a.eff_date, a.remarks, a.user_id,
                       a.last_update
                  FROM giis_banc_area a
                 WHERE a.area_cd = NVL(p_area_cd, a.area_cd)
                   AND UPPER (a.area_desc) LIKE UPPER (NVL (p_area_desc, '%'))
                   AND TRUNC(a.eff_date) = NVL(TO_DATE(p_eff_date, 'mm-dd-yyyy'), TRUNC(a.eff_date))
                 ORDER BY a.area_cd
                   )                   
      LOOP
         v_rec.area_cd := i.area_cd;
         v_rec.area_desc := i.area_desc;
         v_rec.eff_date := TRUNC(i.eff_date);
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_banc_area%ROWTYPE)
   IS
      v_area_cd   giis_banc_area.area_cd%TYPE;
   BEGIN
   
      IF p_rec.area_cd IS NULL THEN
         BEGIN
            SELECT MAX(area_cd) + 1
              INTO v_area_cd
              FROM giis_banc_area; 
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_area_cd := 1;     
         END;
      END IF;
      
      v_area_cd := NVL(v_area_cd, 1); --Apollo Cruz 11.06.2014
   
      BEGIN
         MERGE INTO giis_banc_area
         USING DUAL
         ON (area_cd = p_rec.area_cd)
         WHEN NOT MATCHED THEN
            INSERT (area_cd, area_desc, eff_date, remarks, user_id, last_update)
            VALUES (v_area_cd, p_rec.area_desc, TO_DATE(p_rec.eff_date), p_rec.remarks,
                    p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET area_desc = p_rec.area_desc,
                   eff_date = TO_DATE(p_rec.eff_date), 
                   remarks = p_rec.remarks, user_id = p_rec.user_id, last_update = SYSDATE;
      END;
   
      
   END;


   PROCEDURE val_add_rec (
      p_area_cd     giis_banc_area.area_cd%TYPE,
      p_area_desc   giis_banc_area.area_desc%TYPE
   )
   AS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
      IF p_area_cd IS NULL THEN
         BEGIN
            SELECT 'Y'
              INTO v_exists
              FROM giis_banc_area
             WHERE UPPER(area_desc) = UPPER(p_area_desc)
               AND ROWNUM = 1;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_exists := 'N';      
         END;            
      ELSE
         BEGIN
            SELECT 'Y'
              INTO v_exists
              FROM giis_banc_area
             WHERE area_cd <> p_area_cd
               AND UPPER(area_desc) = UPPER(p_area_desc)
               AND ROWNUM = 1;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_exists := 'N';       
         END;                      
      END IF;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001, 'Geniisys Exception#E#Record already exists with the same area_desc.');
      END IF;
   END val_add_rec;
   
   FUNCTION get_hist (p_area_cd VARCHAR2)
      RETURN hist_tab PIPELINED
   IS
      v_list hist_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM giis_banc_area_hist
                 WHERE area_cd = p_area_cd
              ORDER BY last_update)
      LOOP
         v_list.area_cd := i.area_cd;
         v_list.old_eff_date := i.old_eff_date;
         v_list.new_eff_date := i.new_eff_date;
--         v_list.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_list.last_update := i.last_update;
         v_list.user_id := i.user_id;
         
         PIPE ROW(v_list);
      END LOOP;
   END get_hist;   
END;
/


