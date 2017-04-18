CREATE OR REPLACE PACKAGE BODY CPI.giiss219_pkg
AS
--Good code is its own best documentation. 
   FUNCTION get_giis_line_list (
      p_user_id   giis_users.user_id%TYPE,
      p_keyword   VARCHAR2
   )
      RETURN line_listing_tab PIPELINED
   IS
      v_rec   line_listing_type;
   BEGIN
      FOR i IN (SELECT   line_cd, line_name
                    FROM giis_line
                   WHERE pack_pol_flag <> 'Y'
                     AND check_user_per_line2 (line_cd,
                                               NULL,
                                               'GIISS219',
                                               p_user_id
                                              ) = 1
                     AND (   UPPER (line_cd) LIKE UPPER (NVL (p_keyword, line_cd))
                          OR UPPER (line_name) LIKE UPPER (NVL (p_keyword, line_name))
                         )
                ORDER BY 1)
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.line_name := i.line_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_giis_subline_list (
      p_line_cd   giis_line.line_cd%TYPE,
      p_keyword   VARCHAR2
   )
      RETURN subline_listing_tab PIPELINED
   IS
      v_rec   subline_listing_type;
   BEGIN
      FOR i IN (SELECT   subline_cd, subline_name
                    FROM giis_line a, giis_subline b
                   WHERE a.line_cd = b.line_cd
                     AND pack_pol_flag <> 'Y'
                     AND a.line_cd = p_line_cd
                     AND (   UPPER (subline_cd) LIKE UPPER (NVL (p_keyword, subline_cd))
                          OR UPPER (subline_name) LIKE UPPER (NVL (p_keyword, subline_name))
                         )
                ORDER BY 2)
      LOOP
         v_rec.subline_cd := i.subline_cd;
         v_rec.subline_name := i.subline_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_giis_peril_list (
      p_line_cd      giis_line.line_cd%TYPE,
      p_subline_cd   giis_subline.subline_cd%TYPE,
      p_keyword      VARCHAR2
   )
      RETURN peril_listing_tab PIPELINED
   IS
      v_rec   peril_listing_type;
   BEGIN
      FOR i IN (SELECT   line_cd, peril_cd, peril_name, peril_type
                    FROM giis_peril
                   WHERE line_cd = p_line_cd
                     AND (subline_cd IS NULL OR subline_cd = p_subline_cd)
                     AND (   UPPER (peril_name) LIKE UPPER (NVL (p_keyword, peril_name))
                          OR peril_cd LIKE NVL (p_keyword, peril_cd)
                         )
                ORDER BY 3)
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.peril_type := i.peril_type;
         v_rec.peril_name := i.peril_name;
         v_rec.peril_cd := i.peril_cd;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_giis_line_pack_list (
      p_user_id   giis_users.user_id%TYPE,
      p_keyword   VARCHAR2
   )
      RETURN line_listing_tab PIPELINED
   IS
      v_rec   line_listing_type;
   BEGIN
      FOR i IN (SELECT   line_cd, line_name
                    FROM giis_line
                   WHERE pack_pol_flag = 'Y'
                     AND check_user_per_line2 (line_cd,
                                               NULL,
                                               'GIISS219',
                                               p_user_id
                                              ) = 1
                     AND (   UPPER (line_cd) LIKE UPPER (NVL (p_keyword, line_cd))
                          OR UPPER (line_name) LIKE UPPER (NVL (p_keyword, line_name))
                         )
                ORDER BY 1)
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.line_name := i.line_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_giis_subline_pack_list (
      p_line_cd   giis_line.line_cd%TYPE,
      p_keyword   VARCHAR2
   )
      RETURN subline_listing_tab PIPELINED
   IS
      v_rec   subline_listing_type;
   BEGIN
      FOR i IN (SELECT   subline_cd, subline_name
                    FROM giis_line a, giis_subline b
                   WHERE a.line_cd = b.line_cd
                     AND pack_pol_flag = 'Y'
                     AND a.line_cd = p_line_cd
                     AND (   UPPER (subline_cd) LIKE UPPER (NVL (p_keyword, subline_cd))
                          OR UPPER (subline_name) LIKE UPPER (NVL (p_keyword, subline_name))
                         )
                ORDER BY 2)
      LOOP
         v_rec.subline_cd := i.subline_cd;
         v_rec.subline_name := i.subline_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_giis_pack_line_list (
      p_line_cd   giis_line.line_cd%TYPE,
      p_user_id   giis_users.user_id%TYPE,
      p_keyword   VARCHAR2
   )
      RETURN line_listing_tab PIPELINED
   IS
      v_rec   line_listing_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT pack_line_cd, line_name
                     FROM giis_line a, giis_line_subline_coverages b
                    WHERE a.line_cd = pack_line_cd
                      AND b.line_cd = p_line_cd
                      AND check_user_per_line2 (pack_line_cd,
                                               NULL,
                                               'GIISS219',
                                               p_user_id
                                              ) = 1
                      AND (   UPPER (pack_line_cd) LIKE UPPER (NVL (p_keyword, pack_line_cd))
                           OR UPPER (line_name) LIKE UPPER (NVL (p_keyword, line_name))
                          ))
      LOOP
         v_rec.pack_line_cd := i.pack_line_cd;
         v_rec.line_name := i.line_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_giis_pack_subline_list (
      p_line_cd        giis_line.line_cd%TYPE,
      p_pack_line_cd   giis_line_subline_coverages.pack_line_cd%TYPE,
      p_keyword        VARCHAR2
   )
      RETURN subline_listing_tab PIPELINED
   IS
      v_rec   subline_listing_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT pack_subline_cd, subline_name
                     FROM giis_subline a, giis_line_subline_coverages b
                    WHERE a.subline_cd = pack_subline_cd
                      AND b.pack_line_cd = p_pack_line_cd
                      AND b.line_cd = p_line_cd
                      AND (   UPPER (pack_subline_cd) LIKE UPPER (NVL (p_keyword, pack_subline_cd))
                           OR UPPER (subline_name) LIKE UPPER (NVL (p_keyword, subline_name))
                          )
                 ORDER BY 2)
      LOOP
         v_rec.pack_subline_cd := i.pack_subline_cd;
         v_rec.subline_name := i.subline_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_giis_pack_peril_list (
      p_pack_line_cd      giis_line.line_cd%TYPE,
      p_pack_subline_cd   giis_subline.subline_cd%TYPE,
      p_keyword           VARCHAR2
   )
      RETURN peril_listing_tab PIPELINED
   IS
      v_rec   peril_listing_type;
   BEGIN
      FOR i IN (SELECT   a.line_cd, b.subline_cd, peril_cd, peril_name, peril_type
                    FROM giis_peril a, giis_subline b
                   WHERE a.line_cd = b.line_cd
                     AND a.line_cd = p_pack_line_cd
                     AND b.subline_cd = p_pack_subline_cd
                     AND (   UPPER (peril_name) LIKE UPPER (NVL (p_keyword, peril_name))
                          OR peril_cd LIKE NVL (p_keyword, peril_cd)
                         )
                ORDER BY 4)
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.subline_cd := i.subline_cd;
         v_rec.peril_type := i.peril_type;
         v_rec.peril_name := i.peril_name;
         v_rec.peril_cd := i.peril_cd;

         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_rec_list_regular (
      p_user_id        giis_users.user_id%TYPE,
      p_plan_cd        giis_plan.plan_cd%TYPE,
      p_plan_desc      giis_plan.plan_desc%TYPE,
      p_line_name      giis_line.line_name%TYPE,
      p_subline_name   giis_subline.subline_name%TYPE,
      p_peril_name     giis_peril.peril_name%TYPE,
      p_mode           VARCHAR2
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      IF p_mode = 'giisPlan'
      THEN
         FOR i IN
            (SELECT   a.*, b.line_name, c.subline_name
                 FROM giis_plan a, giis_line b, giis_subline c
                WHERE a.line_cd = b.line_cd
                  AND c.line_cd = b.line_cd
                  AND a.subline_cd = c.subline_cd
                  AND check_user_per_iss_cd2 (a.line_cd,
                                              NULL,
                                              'GIISS219',
                                              p_user_id
                                             ) = 1
                  AND a.plan_cd = NVL (p_plan_cd, a.plan_cd)
                  AND UPPER (a.plan_desc) LIKE UPPER (NVL (p_plan_desc, '%'))
                  AND UPPER (b.line_name) LIKE UPPER (NVL (p_line_name, '%'))
                  AND UPPER (c.subline_name) LIKE
                                             UPPER (NVL (p_subline_name, '%'))
             ORDER BY plan_cd)
         LOOP
            v_rec.plan_cd := i.plan_cd;
            v_rec.plan_desc := i.plan_desc;
            v_rec.line_cd := i.line_cd;
            v_rec.subline_cd := i.subline_cd;
            v_rec.line_name := i.line_name;
            v_rec.subline_name := i.subline_name;
            v_rec.remarks := i.remarks;
            v_rec.user_id := i.user_id;
            v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
            PIPE ROW (v_rec);
         END LOOP;
      ELSIF p_mode = 'giisPlanDtl'
      THEN
         FOR i IN (SELECT b.peril_name, b.peril_type, a.*
                     FROM giis_plan_dtl a, giis_peril b
                    WHERE b.peril_cd = a.peril_cd
                      AND b.line_cd = a.line_cd
                      AND a.plan_cd = p_plan_cd
                      AND UPPER (b.peril_name) LIKE
                                               UPPER (NVL (p_peril_name, '%')))
         LOOP
            v_rec.plan_cd := i.plan_cd;
            v_rec.peril_name := i.peril_name;
            v_rec.peril_cd := i.peril_cd;
            v_rec.peril_type := i.peril_type;
            v_rec.prem_rt := i.prem_rt;
            v_rec.prem_amt := i.prem_amt;
            v_rec.no_of_days := i.no_of_days;
            v_rec.base_amt := i.base_amt;
            v_rec.tsi_amt := i.tsi_amt;
            v_rec.aggregate_sw := NVL(i.aggregate_sw,'N');
            v_rec.user_id := i.user_id;
            v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');

            BEGIN
               SELECT SUM (a.tsi_amt)
                 INTO v_rec.total_tsi
                 FROM giis_plan_dtl a, giis_peril b
                WHERE plan_cd = p_plan_cd
                  AND a.peril_cd = b.peril_cd
                  AND a.line_cd = b.line_cd
                  AND b.peril_type = 'B';
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_rec.total_tsi := 0;
            END;

            PIPE ROW (v_rec);
         END LOOP;
      END IF;

      RETURN;
   END;

   FUNCTION get_rec_list_package (
      p_user_id           giis_users.user_id%TYPE,
      p_plan_cd           giis_pack_plan.plan_cd%TYPE,
      p_plan_desc         giis_pack_plan.plan_desc%TYPE,
      p_pack_line_cd      giis_pack_plan_cover.pack_line_cd%TYPE,
      p_pack_subline_cd   giis_pack_plan_cover.pack_subline_cd%TYPE,
      p_line_name         giis_line.line_name%TYPE,
      p_subline_name      giis_subline.subline_name%TYPE,
      p_peril_name        giis_peril.peril_name%TYPE,
      p_mode              VARCHAR2
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      IF p_mode = 'giisPackPlan'
      THEN
         FOR i IN
            (SELECT   a.*, b.line_name, c.subline_name
                 FROM giis_pack_plan a, giis_line b, giis_subline c
                WHERE a.line_cd = b.line_cd
                  AND c.line_cd = b.line_cd
                  AND a.subline_cd = c.subline_cd
                  AND check_user_per_iss_cd2 (a.line_cd,
                                              NULL,
                                              'GIISS219',
                                              p_user_id
                                             ) = 1
                  AND a.plan_cd = NVL (p_plan_cd, a.plan_cd)
                  AND UPPER (a.plan_desc) LIKE UPPER (NVL (p_plan_desc, '%'))
                  AND UPPER (b.line_name) LIKE UPPER (NVL (p_line_name, '%'))
                  AND UPPER (c.subline_name) LIKE
                                             UPPER (NVL (p_subline_name, '%'))
             ORDER BY plan_cd)
         LOOP
            v_rec.plan_cd := i.plan_cd;
            v_rec.plan_desc := i.plan_desc;
            v_rec.pack_line_cd := i.line_cd;
            v_rec.pack_subline_cd := i.subline_cd;
            v_rec.line_name := i.line_name;
            v_rec.subline_name := i.subline_name;
            v_rec.remarks := i.remarks;
            v_rec.user_id := i.user_id;
            v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
            PIPE ROW (v_rec);
         END LOOP;
      ELSIF p_mode = 'giisPackPlanCover'
      THEN
         FOR i IN
            (SELECT a.*, b.line_name, c.subline_name
               FROM giis_pack_plan_cover a, giis_line b, giis_subline c
              WHERE a.plan_cd = p_plan_cd
                AND a.pack_line_cd = b.line_cd
                AND c.line_cd = b.line_cd
                AND a.pack_subline_cd = c.subline_cd
                AND check_user_per_iss_cd2 (a.pack_line_cd,
                                              NULL,
                                              'GIISS219',
                                              p_user_id
                                             ) = 1
                AND UPPER (a.pack_line_cd) LIKE
                                             UPPER (NVL (p_pack_line_cd, '%'))
                AND UPPER (a.pack_subline_cd) LIKE
                                          UPPER (NVL (p_pack_subline_cd, '%'))
                AND UPPER (b.line_name) LIKE UPPER (NVL (p_line_name, '%'))
                AND UPPER (c.subline_name) LIKE
                                             UPPER (NVL (p_subline_name, '%')))
         LOOP
            v_rec.plan_cd := i.plan_cd;
            v_rec.pack_line_cd := i.pack_line_cd;
            v_rec.pack_subline_cd := i.pack_subline_cd;
            v_rec.line_name := i.line_name;
            v_rec.subline_name := i.subline_name;
            v_rec.remarks := i.remarks;
            v_rec.user_id := i.user_id;
            v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
            PIPE ROW (v_rec);
         END LOOP;
      ELSIF p_mode = 'giisPackPlanCoverDtl'
      THEN
         FOR i IN (SELECT b.peril_name, b.peril_type, a.*
                     FROM giis_pack_plan_cover_dtl a, giis_peril b
                    WHERE a.plan_cd = p_plan_cd
                      AND a.pack_line_cd = p_pack_line_cd
                      AND a.pack_subline_cd = p_pack_subline_cd
                      AND b.peril_cd = a.peril_cd
                      AND b.line_cd = a.pack_line_cd
                      AND UPPER (b.peril_name) LIKE
                                               UPPER (NVL (p_peril_name, '%')))
         LOOP
            v_rec.plan_cd := i.plan_cd;
            v_rec.pack_line_cd := i.pack_line_cd;
            v_rec.pack_subline_cd := i.pack_subline_cd;
            v_rec.peril_name := i.peril_name;
            v_rec.peril_cd := i.peril_cd;
            v_rec.peril_type := i.peril_type;
            v_rec.prem_rt := i.prem_rt;
            v_rec.prem_amt := i.prem_amt;
            v_rec.no_of_days := i.no_of_days;
            v_rec.base_amt := i.base_amt;
            v_rec.tsi_amt := i.tsi_amt;
            v_rec.aggregate_sw := NVL(i.aggregate_sw,'N');
            v_rec.user_id := i.user_id;
            v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');

            BEGIN
               SELECT SUM (c.tsi_amt)
                 INTO v_rec.total_tsi
                 FROM giis_peril a,
                      giis_pack_plan_cover_dtl c,
                      giis_pack_plan_cover d
                WHERE 1 = 1
                  AND c.pack_line_cd = p_pack_line_cd
                  AND c.pack_subline_cd = p_pack_subline_cd
                  AND c.plan_cd = p_plan_cd
                  AND a.peril_cd = c.peril_cd
                  AND a.line_cd = c.pack_line_cd
                  AND a.peril_type = 'B'
                  AND c.plan_cd = d.plan_cd
                  AND c.pack_line_cd = d.pack_line_cd
                  AND c.pack_subline_cd = d.pack_subline_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_rec.total_tsi := 0;
            END;

            PIPE ROW (v_rec);
         END LOOP;
      END IF;

      RETURN;
   END;

   PROCEDURE set_giis_plan (
      p_plan_cd      IN OUT   giis_plan.plan_cd%TYPE,
      p_plan_desc    IN       giis_plan.plan_desc%TYPE,
      p_line_cd      IN       giis_plan.line_cd%TYPE,
      p_subline_cd   IN       giis_plan.subline_cd%TYPE,
      p_remarks      IN       giis_plan.remarks%TYPE,
      p_user_id      IN       giis_plan.user_id%TYPE
   )
   IS
      v_plan_cd   giis_plan.plan_cd%TYPE;
   BEGIN
      SELECT MAX (plan_cd)
        INTO v_plan_cd
        FROM giis_plan;

      v_plan_cd := NVL (v_plan_cd, 0) + 1;
      MERGE INTO giis_plan
         USING DUAL
         ON (plan_cd = p_plan_cd)
         WHEN NOT MATCHED THEN
            INSERT (plan_cd, plan_desc, line_cd, subline_cd, remarks, user_id,
                    last_update)
            VALUES (v_plan_cd, p_plan_desc, p_line_cd, p_subline_cd,
                    p_remarks, p_user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET plan_desc = p_plan_desc, subline_cd = p_subline_cd,
                   remarks = p_remarks, user_id = p_user_id,
                   last_update = SYSDATE
            ;

      IF p_plan_cd IS NULL
      THEN
         p_plan_cd := v_plan_cd;
      END IF;
   END;

   PROCEDURE set_giis_plan_dtl (p_rec giis_plan_dtl%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_plan_dtl
         USING DUAL
         ON (plan_cd = p_rec.plan_cd AND peril_cd = p_rec.peril_cd)
         WHEN NOT MATCHED THEN
            INSERT (plan_cd, peril_cd, line_cd, prem_rt, prem_amt, tsi_amt,
                    aggregate_sw, no_of_days, base_amt, user_id, last_update)
            VALUES (p_rec.plan_cd, p_rec.peril_cd, p_rec.line_cd,
                    p_rec.prem_rt, p_rec.prem_amt, p_rec.tsi_amt,
                    p_rec.aggregate_sw, p_rec.no_of_days, p_rec.base_amt,
                    p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET prem_rt = p_rec.prem_rt, prem_amt = p_rec.prem_amt,
                   tsi_amt = p_rec.tsi_amt,
                   aggregate_sw = p_rec.aggregate_sw,
                   no_of_days = p_rec.no_of_days, base_amt = p_rec.base_amt,
                   user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE set_giis_pack_plan (
      p_plan_cd      IN OUT   giis_plan.plan_cd%TYPE,
      p_plan_desc    IN       giis_plan.plan_desc%TYPE,
      p_line_cd      IN       giis_plan.line_cd%TYPE,
      p_subline_cd   IN       giis_plan.subline_cd%TYPE,
      p_remarks      IN       giis_plan.remarks%TYPE,
      p_user_id      IN       giis_plan.user_id%TYPE
   )
   IS
      v_plan_cd   giis_pack_plan.plan_cd%TYPE;
   BEGIN
      SELECT MAX (plan_cd)
        INTO v_plan_cd
        FROM giis_pack_plan;

      v_plan_cd := NVL (v_plan_cd, 0) + 1;
      MERGE INTO giis_pack_plan
         USING DUAL
         ON (plan_cd = p_plan_cd)
         WHEN NOT MATCHED THEN
            INSERT (plan_cd, plan_desc, line_cd, subline_cd, remarks, user_id,
                    last_update)
            VALUES (v_plan_cd, p_plan_desc, p_line_cd, p_subline_cd,
                    p_remarks, p_user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET plan_desc = p_plan_desc, line_cd = p_line_cd,
                   subline_cd = p_subline_cd, remarks = p_remarks,
                   user_id = p_user_id, last_update = SYSDATE
            ;

      IF p_plan_cd IS NULL
      THEN
         p_plan_cd := v_plan_cd;
      END IF;
   END;

   PROCEDURE set_giis_pack_plan_cover (p_rec giis_pack_plan_cover%ROWTYPE)
   IS
   BEGIN
      INSERT INTO giis_pack_plan_cover
                  (plan_cd, pack_line_cd, pack_subline_cd,
                   user_id, last_update
                  )
           VALUES (p_rec.plan_cd, p_rec.pack_line_cd, p_rec.pack_subline_cd,
                   p_rec.user_id, SYSDATE
                  );
   END;

   PROCEDURE set_giis_pack_plan_cover_dtl (
      p_rec   giis_pack_plan_cover_dtl%ROWTYPE
   )
   IS
   BEGIN
      MERGE INTO giis_pack_plan_cover_dtl
         USING DUAL
         ON (    plan_cd = p_rec.plan_cd
             AND peril_cd = p_rec.peril_cd
             AND pack_line_cd = p_rec.pack_line_cd
             AND pack_subline_cd = p_rec.pack_subline_cd)
         WHEN NOT MATCHED THEN
            INSERT (plan_cd, pack_line_cd, pack_subline_cd, peril_cd, prem_rt,
                    prem_amt, tsi_amt, aggregate_sw, no_of_days, base_amt,
                    user_id, last_update)
            VALUES (p_rec.plan_cd, p_rec.pack_line_cd, p_rec.pack_subline_cd,
                    p_rec.peril_cd, p_rec.prem_rt, p_rec.prem_amt,
                    p_rec.tsi_amt, p_rec.aggregate_sw, p_rec.no_of_days,
                    p_rec.base_amt, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET prem_rt = p_rec.prem_rt, prem_amt = p_rec.prem_amt,
                   tsi_amt = p_rec.tsi_amt, aggregate_sw = p_rec.aggregate_sw,
                   no_of_days = p_rec.no_of_days, base_amt = p_rec.base_amt,
                   user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_giis_plan (p_plan_cd giis_plan.plan_cd%TYPE)
   AS
   BEGIN
      DELETE FROM giis_plan_dtl
            WHERE plan_cd = p_plan_cd;

      DELETE FROM giis_plan
            WHERE plan_cd = p_plan_cd;
   END;

   PROCEDURE del_giis_plan_dtl (
      p_peril_cd   giis_plan_dtl.peril_cd%TYPE,
      p_plan_cd    giis_plan_dtl.plan_cd%TYPE
   )
   AS
   BEGIN
      DELETE FROM giis_plan_dtl
            WHERE peril_cd = p_peril_cd AND plan_cd = p_plan_cd;
   END;

   PROCEDURE del_giis_pack_plan (p_plan_cd giis_pack_plan.plan_cd%TYPE)
   AS
   BEGIN
      DELETE FROM giis_pack_plan_cover_dtl
            WHERE plan_cd = p_plan_cd;

      DELETE FROM giis_pack_plan_cover
            WHERE plan_cd = p_plan_cd;

      DELETE FROM giis_pack_plan
            WHERE plan_cd = p_plan_cd;
   END;

   PROCEDURE del_giis_pack_plan_cover (
      p_plan_cd           giis_pack_plan_cover.plan_cd%TYPE,
      p_pack_line_cd      giis_pack_plan_cover.pack_line_cd%TYPE,
      p_pack_subline_cd   giis_pack_plan_cover.pack_subline_cd%TYPE
   )
   AS
   BEGIN
      DELETE FROM giis_pack_plan_cover
            WHERE plan_cd = p_plan_cd
              AND pack_line_cd = p_pack_line_cd
              AND pack_subline_cd = p_pack_subline_cd;
   END;

   PROCEDURE del_giis_pack_plan_cover_dtl (
      p_peril_cd          giis_pack_plan_cover_dtl.peril_cd%TYPE,
      p_plan_cd           giis_pack_plan_cover_dtl.plan_cd%TYPE,
      p_pack_line_cd      giis_pack_plan_cover_dtl.pack_line_cd%TYPE,
      p_pack_subline_cd   giis_pack_plan_cover_dtl.pack_subline_cd%TYPE
   )
   AS
   BEGIN
      DELETE FROM giis_pack_plan_cover_dtl
            WHERE peril_cd = p_peril_cd
              AND plan_cd = p_plan_cd
              AND pack_line_cd = p_pack_line_cd
              AND pack_subline_cd = p_pack_subline_cd;
   END;

   PROCEDURE val_del_rec (
      p_pack_line_cd      giis_line.line_cd%TYPE,
      p_pack_subline_cd   giis_subline.subline_cd%TYPE,
      p_rec_cd            VARCHAR2
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR rec IN (SELECT 1
                    FROM giis_pack_plan_cover_dtl g
                   WHERE g.plan_cd = p_rec_cd
                     AND g.pack_line_cd = p_pack_line_cd
                     AND g.pack_subline_cd = p_pack_subline_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_PACK_PLAN_COVER while dependent record(s) in GIIS_PACK_PLAN_COVER_DTL exists.'
            );
      END IF;
   END;

   PROCEDURE val_add_rec (
      p_pack_line_cd      giis_line.line_cd%TYPE,
      p_pack_subline_cd   giis_subline.subline_cd%TYPE,
      p_rec_cd            VARCHAR2,
      p_rec_cd2           VARCHAR2,
      p_mode              VARCHAR2
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      IF p_mode = 'giisPlanDtl'
      THEN
         FOR i IN (SELECT '1'
                     FROM giis_plan_dtl
                    WHERE peril_cd = p_rec_cd AND plan_cd = p_rec_cd2)
         LOOP
            v_exists := 'Y';
            EXIT;
         END LOOP;

         IF v_exists = 'Y'
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Record already exists with the same peril_cd.'
               );
         END IF;
      ELSIF p_mode = 'giisPackPlanCoverDtl'
      THEN
         FOR i IN (SELECT '1'
                     FROM giis_pack_plan_cover_dtl
                    WHERE peril_cd = p_rec_cd
                      AND plan_cd = p_rec_cd2
                      AND pack_line_cd = p_pack_line_cd
                      AND pack_subline_cd = p_pack_subline_cd)
         LOOP
            v_exists := 'Y';
            EXIT;
         END LOOP;

         IF v_exists = 'Y'
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Record already exists with the same peril_cd.'
               );
         END IF;
      ELSIF p_mode = 'giisPackPlanCover'
      THEN
         FOR i IN (SELECT '1'
                     FROM giis_pack_plan_cover
                    WHERE plan_cd = p_rec_cd2
                      AND pack_line_cd = p_pack_line_cd
                      AND pack_subline_cd = p_pack_subline_cd)
         LOOP
            v_exists := 'Y';
            EXIT;
         END LOOP;

         IF v_exists = 'Y'
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Record already exists with the same pack_line_cd and pack_subline_cd.'
               );
         END IF;
      END IF;
   END;
END;
/


