CREATE OR REPLACE PACKAGE BODY CPI.giiss120_pkg
AS
   FUNCTION get_giis_line_list (
      p_keyword   VARCHAR2,
      p_user_id   giis_users.user_id%TYPE
   )
      RETURN line_listing_tab PIPELINED
   IS
      v_rec   line_listing_type;
   BEGIN
      FOR i IN (SELECT   line_cd, line_name
                    FROM giis_line
                   WHERE (   UPPER (line_cd) LIKE
                                              UPPER (NVL (p_keyword, line_cd))
                          OR UPPER (line_name) LIKE
                                            UPPER (NVL (p_keyword, line_name))
                         )
                     AND check_user_per_line2 (line_cd,
                                               NULL,
                                               'GIISS120',
                                               p_user_id
                                              ) = 1
                ORDER BY line_cd)
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
                    FROM giis_subline
                   WHERE line_cd = p_line_cd
                     AND (   UPPER (subline_cd) LIKE
                                           UPPER (NVL (p_keyword, subline_cd))
                          OR UPPER (subline_name) LIKE
                                         UPPER (NVL (p_keyword, subline_name))
                         )
                ORDER BY subline_cd)
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
      FOR i IN (SELECT   peril_name, peril_cd
                    FROM giis_peril
                   WHERE line_cd = p_line_cd
                     AND (subline_cd IS NULL OR subline_cd = p_subline_cd)
                     AND (   UPPER (peril_name) LIKE
                                           UPPER (NVL (p_keyword, peril_name))
                          OR peril_cd LIKE NVL (p_keyword, peril_cd)
                         )
                ORDER BY peril_name)
      LOOP
         v_rec.peril_name := i.peril_name;
         v_rec.peril_cd := i.peril_cd;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_rec_list (
      p_line_cd       giis_line.line_cd%TYPE,
      p_subline_cd    giis_subline.subline_cd%TYPE,
      p_package_cd    giis_package_benefit.package_cd%TYPE,
      p_pack_ben_cd   giis_package_benefit.pack_ben_cd%TYPE,
      p_peril_name    giis_peril.peril_name%TYPE,
      p_mode          VARCHAR2
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      IF p_mode = 'giisPackageBenefit'
      THEN
         FOR i IN (SELECT   *
                       FROM giis_package_benefit
                      WHERE UPPER (package_cd) LIKE
                                              UPPER (NVL (p_package_cd, '%'))
                        AND line_cd = p_line_cd
                        AND subline_cd = p_subline_cd
                   ORDER BY package_cd)
         LOOP
            v_rec.pack_ben_cd := i.pack_ben_cd;
            v_rec.package_cd := i.package_cd;
            v_rec.line_cd := i.line_cd;
            v_rec.subline_cd := i.subline_cd;
            v_rec.user_id := i.user_id;
            v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
            PIPE ROW (v_rec);
         END LOOP;
      ELSIF p_mode = 'giisPackageBenefitDtl'
      THEN
         FOR i IN (SELECT b.peril_name, a.*
                     FROM giis_package_benefit_dtl a, giis_peril b
                    WHERE b.peril_cd = a.peril_cd
                      AND b.line_cd = p_line_cd
                      AND a.pack_ben_cd = p_pack_ben_cd
                      AND UPPER (b.peril_name) LIKE
                                               UPPER (NVL (p_peril_name, '%')))
         LOOP
            v_rec.pack_ben_cd := i.pack_ben_cd;
            v_rec.peril_name := i.peril_name;
            v_rec.peril_cd := i.peril_cd;
            v_rec.prem_pct := i.prem_pct;
            v_rec.prem_amt := i.prem_amt;
            v_rec.no_of_days := i.no_of_days;
            v_rec.benefit := i.benefit;
            v_rec.aggregate_sw := NVL (i.aggregate_sw, 'N');
            v_rec.remarks := i.remarks;
            v_rec.user_id := i.user_id;
            v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
            PIPE ROW (v_rec);
         END LOOP;
      END IF;

      RETURN;
   END;

   PROCEDURE set_giis_package_benefit (
      p_pack_ben_cd   IN OUT   giis_package_benefit.pack_ben_cd%TYPE,
      p_package_cd    IN       giis_package_benefit.package_cd%TYPE,
      p_line_cd       IN       giis_package_benefit.line_cd%TYPE,
      p_subline_cd    IN       giis_package_benefit.subline_cd%TYPE,
      p_user_id       IN       giis_package_benefit.user_id%TYPE
   )
   IS
      v_pack_ben_cd   giis_package_benefit.pack_ben_cd%TYPE;
   BEGIN
      SELECT package_pack_ben_cd_seq.NEXTVAL
        INTO v_pack_ben_cd
        FROM DUAL;

      MERGE INTO giis_package_benefit
         USING DUAL
         ON (pack_ben_cd = p_pack_ben_cd)
         WHEN NOT MATCHED THEN
            INSERT (pack_ben_cd, package_cd, line_cd, subline_cd, user_id,
                    last_update)
            VALUES (v_pack_ben_cd, p_package_cd, p_line_cd, p_subline_cd,
                    p_user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET package_cd = p_package_cd, user_id = p_user_id,
                   last_update = SYSDATE
            ;
      p_pack_ben_cd := v_pack_ben_cd;
   END;

   PROCEDURE set_giis_package_benefit_dtl (
      p_rec   giis_package_benefit_dtl%ROWTYPE
   )
   IS
   BEGIN
      MERGE INTO giis_package_benefit_dtl
         USING DUAL
         ON (pack_ben_cd = p_rec.pack_ben_cd AND peril_cd = p_rec.peril_cd)
         WHEN NOT MATCHED THEN
            INSERT (pack_ben_cd, peril_cd, benefit, prem_pct, aggregate_sw,
                    no_of_days, prem_amt, remarks, user_id, last_update)
            VALUES (p_rec.pack_ben_cd, p_rec.peril_cd, p_rec.benefit,
                    p_rec.prem_pct, p_rec.aggregate_sw, p_rec.no_of_days,
                    p_rec.prem_amt, p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET benefit = p_rec.benefit, prem_pct = p_rec.prem_pct,
                   aggregate_sw = p_rec.aggregate_sw,
                   no_of_days = p_rec.no_of_days, prem_amt = p_rec.prem_amt,
                   remarks = p_rec.remarks, user_id = p_rec.user_id,
                   last_update = SYSDATE
            ;
   END;

   PROCEDURE del_giis_package_benefit (
      p_pack_ben_cd   giis_package_benefit.pack_ben_cd%TYPE
   )
   AS
   BEGIN
      DELETE FROM giis_package_benefit_dtl
            WHERE pack_ben_cd = p_pack_ben_cd;

      DELETE FROM giis_package_benefit
            WHERE pack_ben_cd = p_pack_ben_cd;
   END;

   PROCEDURE del_giis_package_benefit_dtl (
      p_peril_cd      giis_package_benefit_dtl.peril_cd%TYPE,
      p_pack_ben_cd   giis_package_benefit_dtl.pack_ben_cd%TYPE
   )
   AS
   BEGIN
      DELETE FROM giis_package_benefit_dtl
            WHERE peril_cd = p_peril_cd AND pack_ben_cd = p_pack_ben_cd;
   END;

   PROCEDURE val_add_rec (
      p_line_cd      giis_line.line_cd%TYPE,
      p_subline_cd   giis_subline.subline_cd%TYPE,
      p_rec_cd       VARCHAR2,
      p_rec_cd2      VARCHAR2,
      p_mode         VARCHAR2
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      IF p_mode = 'giisPackageBenefit'
      THEN
         FOR i IN (SELECT '1'
                     FROM giis_package_benefit
                    WHERE package_cd = p_rec_cd
                      AND line_cd = p_line_cd
                      AND subline_cd = p_subline_cd)
         LOOP
            v_exists := 'Y';
            EXIT;
         END LOOP;

         IF v_exists = 'Y'
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Record already exists with same line_cd, subline_cd and package_cd.'
               );
         END IF;
      ELSIF p_mode = 'giisPackageBenefitDtl'
      THEN
         FOR i IN (SELECT '1'
                     FROM giis_package_benefit_dtl
                    WHERE peril_cd = p_rec_cd AND pack_ben_cd = p_rec_cd2)
         LOOP
            v_exists := 'Y';
            EXIT;
         END LOOP;

         IF v_exists = 'Y'
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Record already exists with same pack_ben_cd and peril_cd.'
               );
         END IF;
      END IF;
   END;

   PROCEDURE val_del_rec (p_rec_cd VARCHAR2)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR a IN (SELECT 1
                  FROM gipi_witem
                 WHERE pack_ben_cd = p_rec_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_PACKAGE_BENEFIT while dependent record(s) in GIPI_WITEM exists.'
            );
      END IF;

      FOR a IN (SELECT 1
                  FROM gipi_item
                 WHERE pack_ben_cd = p_rec_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_PACKAGE_BENEFIT while dependent record(s) in GIPI_ITEM exists.'
            );
      END IF;

      FOR a IN (SELECT 1
                  FROM gipi_wgrouped_items
                 WHERE pack_ben_cd = p_rec_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_PACKAGE_BENEFIT while dependent record(s) in GIPI_WGROUPED_ITEMS exists.'
            );
      END IF;
   END;
END;
/


