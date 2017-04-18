CREATE OR REPLACE PACKAGE BODY CPI.giiss218_pkg
AS

   FUNCTION get_banc_type_list(
      p_banc_type_cd             giis_banc_type.banc_type_cd%TYPE,
      p_banc_type_desc           giis_banc_type.banc_type_desc%TYPE,
      p_rate                     giis_banc_type.rate%TYPE
   )
     RETURN banc_tab PIPELINED
   IS
      v_row                      banc_type;
   BEGIN
      FOR i IN(SELECT *
                 FROM giis_banc_type
                WHERE UPPER(banc_type_cd) LIKE UPPER(NVL(p_banc_type_cd, '%'))
                  AND UPPER(banc_type_desc) LIKE UPPER(NVL(p_banc_type_desc, '%'))
                  AND rate = NVL(p_rate, rate)
                ORDER BY banc_type_cd)
      LOOP
         v_row := NULL;
         v_row.banc_type_cd := i.banc_type_cd;
         v_row.banc_type_desc := i.banc_type_desc;
         v_row.rate := i.rate;
         v_row.user_id := i.user_id;
         v_row.last_update := i.last_update;
         PIPE ROW(v_row);
      END LOOP;
   END;

   FUNCTION get_banc_type_details(
      p_banc_type_cd             giis_banc_type_dtl.banc_type_cd%TYPE,
      p_item_no                  giis_banc_type_dtl.item_no%TYPE,
      p_share_percentage         giis_banc_type_dtl.share_percentage%TYPE
   )
     RETURN giis_banc_type_dtl_tab PIPELINED
   IS
      v_row                      giis_banc_type_dtl_type;
   BEGIN
      v_row.max_item_no := giiss218_pkg.get_max_item_no(p_banc_type_cd);
      
      FOR i IN(SELECT *
                 FROM giis_banc_type_dtl
                WHERE banc_type_cd = p_banc_type_cd
                  AND item_no = NVL(p_item_no, item_no)
                  AND share_percentage = NVL(p_share_percentage, share_percentage)
                ORDER BY item_no)
      LOOP
         v_row.banc_type_cd := i.banc_type_cd;
         v_row.item_no := i.item_no;
         v_row.intm_no := i.intm_no;
         v_row.intm_type := i.intm_type;
         v_row.share_percentage := i.share_percentage;
         v_row.remarks := i.remarks;
         v_row.user_id := i.user_id;
         v_row.last_update := i.last_update;
         v_row.dsp_last_update := TO_CHAR(i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_row.fixed_tag := i.fixed_tag;
         
         v_row.intm_name := NULL;
         IF i.intm_no IS NOT NULL THEN
            SELECT UPPER(intm_name) 
              INTO v_row.intm_name
              FROM giis_intermediary
             WHERE intm_no = i.intm_no;
         END IF;

         v_row.intm_type_desc := NULL;
         IF i.intm_type IS NOT NULL THEN	
            SELECT UPPER(intm_desc) 
              INTO v_row.intm_type_desc
              FROM giis_intm_type
             WHERE intm_type = i.intm_type;
         END IF;
         
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_intm_lov(
      p_banc_type_cd             giis_banc_type.banc_type_cd%TYPE,
      p_find_text                VARCHAR2
   )
     RETURN intm_lov_tab PIPELINED
   IS
      v_row                      intm_lov_type;
   BEGIN
      FOR i IN(SELECT a.intm_no, a.intm_name, a.intm_type
                 FROM giis_intermediary a
                WHERE a.active_tag = 'A'
                  AND a.parent_intm_no IS NOT NULL
                  AND NOT EXISTS (SELECT 1
                                    FROM giis_banc_type_dtl b
                                   WHERE b.banc_type_cd = p_banc_type_cd
                                     AND a.intm_no = b.intm_no)
                  AND (TO_CHAR(a.intm_no) LIKE NVL(p_find_text, TO_CHAR(a.intm_no)) OR
                      UPPER(a.intm_name) LIKE UPPER(NVL(p_find_text, a.intm_name)))
                ORDER BY a.intm_no)
      LOOP
         v_row := NULL;
         v_row.intm_no := i.intm_no;
         v_row.intm_name := i.intm_name;
         v_row.intm_type := i.intm_type;
         
         FOR b IN(SELECT c.intm_desc, c.intm_type
                    FROM giis_intm_type c
                   WHERE c.intm_type = i.intm_type)
         LOOP
            v_row.intm_desc := b.intm_desc;
            EXIT;
         END LOOP;
         
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_intm_type_lov(
      p_find_text          VARCHAR2
   )
     RETURN intm_type_lov_tab PIPELINED
   IS
      v_row                intm_type_lov_type;
   BEGIN
      FOR i IN(SELECT a.intm_desc, a.intm_type
                 FROM giis_intm_type a
                WHERE (UPPER(intm_type) LIKE UPPER(NVL(p_find_text, intm_type)) OR
                      UPPER(intm_desc) LIKE UPPER(NVL(p_find_text, intm_desc)))
                ORDER BY intm_desc)
      LOOP
         v_row := NULL;
         v_row.intm_type := i.intm_type;
         v_row.intm_name := UPPER(i.intm_desc);
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   PROCEDURE val_add_rec(
      p_banc_type_cd             giis_banc_type.banc_type_cd%TYPE
   )
   IS
      v_exists                   VARCHAR2(1) := 'N';
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_banc_type
                 WHERE banc_type_cd = p_banc_type_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y' THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Record already exists with the same banc_type_cd.');
      END IF;
   END;
   
   PROCEDURE set_banc_type(
      p_rec                      giis_banc_type%ROWTYPE
   )
   IS
   
   BEGIN
      MERGE INTO giis_banc_type
      USING DUAL
         ON (banc_type_cd = p_rec.banc_type_cd)
       WHEN NOT MATCHED THEN
            INSERT (banc_type_cd, banc_type_desc, rate, user_id, last_update)
            VALUES (p_rec.banc_type_cd, p_rec.banc_type_desc, p_rec.rate, p_rec.user_id, SYSDATE)
       WHEN MATCHED THEN
            UPDATE SET banc_type_desc = p_rec.banc_type_desc,
                       rate = p_rec.rate,
                       user_id = p_rec.user_id,
                       last_update = SYSDATE;
   END;
   
   PROCEDURE del_banc_type(
      p_banc_type_cd             giis_banc_type.banc_type_cd%TYPE
   )
   IS
   
   BEGIN
      DELETE FROM giis_banc_type_dtl
       WHERE banc_type_cd = p_banc_type_cd;
   
      DELETE FROM giis_banc_type
       WHERE banc_type_cd = p_banc_type_cd;
   END;
   
   PROCEDURE val_add_dtl(
      p_banc_type_cd             giis_banc_type_dtl.banc_type_cd%TYPE,
      p_item_no                  giis_banc_type_dtl.item_no%TYPE
   )
   IS
      v_exists                   VARCHAR2(1) := 'N';
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_banc_type_dtl
                 WHERE banc_type_cd = p_banc_type_cd
                   AND item_no = p_item_no)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y' THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Record already exists with the same banc_type_cd and item_no.');
      END IF;
   END;
   
   PROCEDURE set_banc_type_dtl(
      p_rec                      giis_banc_type_dtl%ROWTYPE
   )
   IS
   
   BEGIN
      MERGE INTO giis_banc_type_dtl
      USING DUAL
         ON (banc_type_cd = p_rec.banc_type_cd
            AND item_no = p_rec.item_no)
       WHEN NOT MATCHED THEN
            INSERT (banc_type_cd, item_no, intm_no, intm_type, share_percentage, remarks, user_id, last_update, fixed_tag)
            VALUES (p_rec.banc_type_cd, p_rec.item_no, p_rec.intm_no, p_rec.intm_type, p_rec.share_percentage,
                    p_rec.remarks, p_rec.user_id, SYSDATE, p_rec.fixed_tag)
       WHEN MATCHED THEN
            UPDATE SET intm_no = p_rec.intm_no,
                       intm_type = p_rec.intm_type,
                       share_percentage = p_rec.share_percentage,
                       remarks = p_rec.remarks,
                       user_id = p_rec.user_id,
                       last_update = SYSDATE,
                       fixed_tag = p_rec.fixed_tag;
   END;
   
   PROCEDURE del_banc_type_dtl(
      p_banc_type_cd             giis_banc_type_dtl.banc_type_cd%TYPE,
      p_item_no                  giis_banc_type_dtl.item_no%TYPE
   )
   IS
   
   BEGIN
      DELETE giis_banc_type_dtl
       WHERE banc_type_cd = p_banc_type_cd
         AND item_no = p_item_no;
   END;
   
   FUNCTION get_max_item_no(
      p_banc_type_cd             giis_banc_type_dtl.banc_type_cd%TYPE
   )
     RETURN NUMBER
   IS
      v_item_no                  giis_banc_type_dtl.item_no%TYPE;
   BEGIN
      SELECT NVL(MAX(item_no), 0) + 1
        INTO v_item_no
        FROM giis_banc_type_dtl
       WHERE banc_type_cd = p_banc_type_cd;
       
      RETURN v_item_no;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RETURN 1;
   END;

END;
/


