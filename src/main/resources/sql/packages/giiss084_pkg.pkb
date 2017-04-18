CREATE OR REPLACE PACKAGE BODY CPI.giiss084_pkg
AS
   FUNCTION get_rec_list (
      p_iss_cd           giis_intm_type_comrt.iss_cd%TYPE,
      p_co_intm_type     giis_intm_type_comrt.co_intm_type%TYPE,
      p_line_cd          giis_intm_type_comrt.line_cd%TYPE,
      p_subline_cd       giis_intm_type_comrt.subline_cd%TYPE,
      p_dsp_peril_name   giis_peril.peril_name%TYPE,
      p_comm_rate        giis_intm_type_comrt.comm_rate%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN
         (SELECT   a.*, get_peril_name (a.line_cd, a.peril_cd)
                                                              dsp_peril_name
              FROM giis_intm_type_comrt a
             WHERE 1 = 1
               AND a.iss_cd = p_iss_cd
               AND a.co_intm_type = p_co_intm_type
               AND a.line_cd = p_line_cd
               AND a.subline_cd = p_subline_cd
               AND UPPER (get_peril_name (a.line_cd, a.peril_cd)) LIKE
                                           UPPER (NVL (p_dsp_peril_name, '%'))
               AND a.comm_rate = NVL(p_comm_rate, comm_rate)
          ORDER BY dsp_peril_name)
      LOOP
         v_rec.iss_cd := i.iss_cd;
         v_rec.co_intm_type := i.co_intm_type;
         v_rec.line_cd := i.line_cd;
         v_rec.peril_cd := i.peril_cd;
         v_rec.comm_rate := i.comm_rate;
         v_rec.subline_cd := i.subline_cd;
         v_rec.dsp_peril_name := i.dsp_peril_name;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_rec_list;

   FUNCTION get_iss_lov (
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_keyword     VARCHAR2
   )
      RETURN iss_lov_tab PIPELINED
   IS
      v_rec   iss_lov_type;
   BEGIN
      FOR i IN (SELECT   iss_cd, iss_name
                    FROM giis_issource
                   WHERE check_user_per_iss_cd2 (NULL,
                                                       iss_cd,
                                                       p_module_id,
                                                       p_user_id
                                                      ) = 1
                     AND (   UPPER (iss_cd) LIKE UPPER (NVL (p_keyword, '%'))
                          OR UPPER (iss_name) LIKE UPPER (NVL (p_keyword, '%')))
                ORDER BY 1)
      LOOP
         v_rec.iss_cd := i.iss_cd;
         v_rec.iss_name := i.iss_name;
         PIPE ROW (v_rec);
      END LOOP;
   END get_iss_lov;

   FUNCTION get_cointmtype_lov (
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_keyword     VARCHAR2
   )
      RETURN cointmtype_lov_tab PIPELINED
   IS
      v_rec   cointmtype_lov_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT co_intm_type, type_name
                     FROM giis_co_intrmdry_types
                    WHERE iss_cd = p_iss_cd
                      AND (   UPPER (co_intm_type) LIKE UPPER (NVL (p_keyword, co_intm_type))
                           OR UPPER (type_name) LIKE UPPER (NVL (p_keyword, type_name)))
                 ORDER BY co_intm_type)
      LOOP
         v_rec.co_intm_type := i.co_intm_type;
         v_rec.type_name := i.type_name;
         PIPE ROW (v_rec);
      END LOOP;
   END get_cointmtype_lov;

   FUNCTION get_line_lov (
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_keyword     VARCHAR2
   )
      RETURN line_lov_tab PIPELINED
   IS
      v_rec   line_lov_type;
   BEGIN
      FOR i IN (SELECT   line_cd, line_name
                    FROM giis_line
                   WHERE check_user_per_line2 (line_cd,
                                               p_iss_cd,
                                               p_module_id,
                                               p_user_id
                                              ) = 1
                     AND (   UPPER (line_cd) LIKE UPPER (NVL (p_keyword, line_cd))
                          OR UPPER (line_name) LIKE UPPER (NVL (p_keyword, line_name)))
                ORDER BY line_cd)
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.line_name := i.line_name;
         PIPE ROW (v_rec);
      END LOOP;
   END get_line_lov;

   FUNCTION get_subline_lov (
      p_line_cd     giis_line.line_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_keyword     VARCHAR2
   )
      RETURN subline_lov_tab PIPELINED
   IS
      v_rec   subline_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT subline_cd, subline_name
                           FROM giis_subline
                          WHERE line_cd = p_line_cd
                            AND (   UPPER (subline_cd) LIKE UPPER (NVL (p_keyword, subline_cd))
                                 OR UPPER (subline_name) LIKE UPPER (NVL (p_keyword, subline_name)))
                       ORDER BY subline_cd)
      LOOP
         v_rec.subline_cd := i.subline_cd;
         v_rec.subline_name := i.subline_name;
         PIPE ROW (v_rec);
      END LOOP;
   END get_subline_lov;

   FUNCTION get_peril_lov (
      p_line_cd     giis_line.line_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_keyword     VARCHAR2
   )
      RETURN peril_lov_tab PIPELINED
   IS
      v_rec   peril_lov_type;
   BEGIN
      FOR i IN
         (SELECT   a.peril_name, a.peril_cd,
                   SUBSTR (b.rv_low_value, 1, 2) peril_type,
                   SUBSTR (b.rv_meaning, 1, 20) peril_type_desc
              FROM giis_peril a, cg_ref_codes b
             WHERE line_cd = NVL (p_line_cd, line_cd)
               AND b.rv_domain = 'GIIS_PERIL.PERIL_TYPE'
               AND SUBSTR (b.rv_low_value, 1, 2) = a.peril_type
               AND (   UPPER (peril_name) LIKE UPPER (NVL (p_keyword, peril_name))                              
                    OR UPPER (SUBSTR (b.rv_meaning, 1, 20)) LIKE UPPER (NVL (p_keyword,SUBSTR (b.rv_meaning, 1, 20))))
          ORDER BY a.peril_name)
      LOOP
         v_rec.peril_cd := i.peril_cd;
         v_rec.peril_name := i.peril_name;
         v_rec.peril_type := i.peril_type;
         v_rec.peril_type_desc := i.peril_type_desc;
         PIPE ROW (v_rec);
      END LOOP;
   END get_peril_lov;

   PROCEDURE set_rec (
      p_rec              giis_intm_type_comrt%ROWTYPE
   )
   IS
      v_exists          VARCHAR2 (1);
      v_hist_exists     VARCHAR2 (1);
      v_old_comm_rate   giis_intm_type_comrt_hist.new_comm_rate%TYPE;
      v_comm_rt_changed VARCHAR2(1) := 'N'; -- shan 07.10.2014
   BEGIN
      FOR i IN (SELECT *
                  FROM giis_intm_type_comrt
                 WHERE line_cd = p_rec.line_cd
                   AND co_intm_type = p_rec.co_intm_type
                   AND iss_cd = p_rec.iss_cd
                   AND subline_cd = p_rec.subline_cd
                   AND peril_cd = p_rec.peril_cd)
      LOOP
         v_exists := 'Y';
         
         IF i.comm_rate != p_rec.comm_rate THEN -- shan 07.10.2014
            v_comm_rt_changed := 'Y';   
         END IF;
         EXIT;
      END LOOP;

      FOR i IN (SELECT *
                  FROM giis_intm_type_comrt_hist
                 WHERE line_cd = p_rec.line_cd
                   AND co_intm_type = p_rec.co_intm_type
                   AND iss_cd = p_rec.iss_cd
                   AND subline_cd = p_rec.subline_cd
                   AND peril_cd = p_rec.peril_cd
                   AND expiry_date IS NULL)
      LOOP
         v_hist_exists := 'Y';
         v_old_comm_rate := i.new_comm_rate;
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         UPDATE giis_intm_type_comrt
            SET comm_rate = p_rec.comm_rate,
                remarks = p_rec.remarks,
                user_id = p_rec.user_id,
                last_update = SYSDATE
          WHERE line_cd = p_rec.line_cd
            AND co_intm_type = p_rec.co_intm_type
            AND iss_cd = p_rec.iss_cd
            AND subline_cd = p_rec.subline_cd
            AND peril_cd = p_rec.peril_cd;
      ELSE
         INSERT INTO giis_intm_type_comrt
                     (iss_cd, co_intm_type, line_cd,
                      subline_cd, peril_cd, comm_rate,
                      remarks, user_id, last_update
                     )
              VALUES (p_rec.iss_cd, p_rec.co_intm_type, p_rec.line_cd,
                      p_rec.subline_cd, p_rec.peril_cd, p_rec.comm_rate,
                      p_rec.remarks, p_rec.user_id, SYSDATE
                     );
      END IF;

      IF v_hist_exists = 'Y'
      THEN
        IF v_comm_rt_changed = 'Y' THEN -- to alter history record only when comm_rate is changed : shan 07.10.2014
         UPDATE giis_intm_type_comrt_hist
            SET expiry_date = SYSDATE
          WHERE line_cd = p_rec.line_cd
            AND co_intm_type = p_rec.co_intm_type
            AND iss_cd = p_rec.iss_cd
            AND subline_cd = p_rec.subline_cd
            AND peril_cd = p_rec.peril_cd
            AND expiry_date IS NULL;

         INSERT INTO giis_intm_type_comrt_hist
                     (iss_cd, co_intm_type, line_cd,
                      subline_cd, peril_cd, old_comm_rate,
                      new_comm_rate, eff_date, expiry_date
                     )
              VALUES (p_rec.iss_cd, p_rec.co_intm_type, p_rec.line_cd,
                      p_rec.subline_cd, p_rec.peril_cd, v_old_comm_rate,
                      p_rec.comm_rate, SYSDATE, NULL
                     );
        END IF;
      ELSE
         INSERT INTO giis_intm_type_comrt_hist
                     (iss_cd, co_intm_type, line_cd,
                      subline_cd, peril_cd, old_comm_rate,
                      new_comm_rate, eff_date, expiry_date
                     )
              VALUES (p_rec.iss_cd, p_rec.co_intm_type, p_rec.line_cd,
                      p_rec.subline_cd, p_rec.peril_cd, p_rec.comm_rate,
                      p_rec.comm_rate, SYSDATE, NULL
                     );
      END IF;
   END set_rec;

   PROCEDURE del_rec (
      p_iss_cd           giis_intm_type_comrt.iss_cd%TYPE,
      p_co_intm_type     giis_intm_type_comrt.co_intm_type%TYPE,
      p_line_cd          giis_intm_type_comrt.line_cd%TYPE,
      p_subline_cd       giis_intm_type_comrt.subline_cd%TYPE,
      p_peril_cd         giis_intm_type_comrt.peril_cd%TYPE
   )
   IS
   BEGIN
      DELETE FROM giis_intm_type_comrt_hist
            WHERE line_cd = p_line_cd
              AND co_intm_type = p_co_intm_type
              AND iss_cd = p_iss_cd
              AND subline_cd = p_subline_cd
              AND peril_cd = p_peril_cd;

      DELETE FROM giis_intm_type_comrt
            WHERE line_cd = p_line_cd
              AND co_intm_type = p_co_intm_type
              AND iss_cd = p_iss_cd
              AND subline_cd = p_subline_cd
              AND peril_cd = p_peril_cd;
   END del_rec;

   FUNCTION get_histrec_list (
      p_iss_cd           giis_intm_type_comrt.iss_cd%TYPE,
      p_co_intm_type     giis_intm_type_comrt.co_intm_type%TYPE,
      p_line_cd          giis_intm_type_comrt.line_cd%TYPE,
      p_subline_cd       giis_intm_type_comrt.subline_cd%TYPE,
      p_eff_date         VARCHAR2,
      p_expiry_date      VARCHAR2
   )
      RETURN histrec_tab PIPELINED
   IS
      v_rec   histrec_type;
   BEGIN
      FOR i IN
         (SELECT   a.*, get_peril_name (a.line_cd, a.peril_cd)
                                                              dsp_peril_name
              FROM giis_intm_type_comrt_hist a
             WHERE 1 = 1
               AND a.iss_cd = p_iss_cd
               AND a.co_intm_type = p_co_intm_type
               AND a.line_cd = p_line_cd
               AND a.subline_cd = p_subline_cd
               AND TRUNC(a.eff_date) = NVL(TO_DATE(p_eff_date, 'mm-dd-yyyy'), TRUNC(a.eff_date))
               AND ((TRUNC(a.expiry_date) = NVL(TO_DATE(p_expiry_date, 'mm-dd-yyyy'), TRUNC(a.expiry_date)))
                OR (p_expiry_date IS NULL AND a.expiry_date IS NULL))
          ORDER BY dsp_peril_name)
      LOOP
         v_rec.iss_cd := i.iss_cd;
         v_rec.co_intm_type := i.co_intm_type;
         v_rec.line_cd := i.line_cd;
         v_rec.peril_cd := i.peril_cd;
         v_rec.new_comm_rate := i.new_comm_rate;
         v_rec.old_comm_rate := i.old_comm_rate;
         v_rec.subline_cd := i.subline_cd;
         v_rec.dsp_peril_name := i.dsp_peril_name;
         v_rec.eff_date := TO_CHAR (i.eff_date, 'MM-DD-YYYY');
         v_rec.expiry_date := TO_CHAR (i.expiry_date, 'MM-DD-YYYY');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_histrec_list;
   
   PROCEDURE val_add_rec(
      p_iss_cd           giis_intm_type_comrt.iss_cd%TYPE,
      p_co_intm_type     giis_intm_type_comrt.co_intm_type%TYPE,
      p_line_cd          giis_intm_type_comrt.line_cd%TYPE,
      p_subline_cd       giis_intm_type_comrt.subline_cd%TYPE,
      p_peril_cd         giis_peril.peril_cd%TYPE
   )
   IS
   BEGIN
      FOR i IN(SELECT 1
                 FROM giis_intm_type_comrt
                WHERE UPPER(iss_cd) = UPPER(p_iss_cd)
                  AND UPPER(co_intm_type) = UPPER(p_co_intm_type)
                  AND UPPER(line_cd) = UPPER(p_line_cd)
                  AND UPPER(subline_cd) = UPPER(p_subline_cd)
                  AND peril_cd = p_peril_cd)
      LOOP
         raise_application_error(-20001, 'Geniisys Exception#E#Record already exists with the same iss_cd, co_intm_type, line_cd, subline_cd and peril_cd.');
      END LOOP;
   END;
   
END;
/


