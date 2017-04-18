CREATE OR REPLACE PACKAGE BODY CPI.gipir111a_pkg
AS
    /*
   **  Created by   : Steven Ramirez
   **  Date Created : 09.27.2013
   **  Reference By : GIPIR111A- Casualty Accumulation Report
   **  Description  :
   */
   FUNCTION populate_gipir111a (
      p_location_cd   VARCHAR2,
      p_eff_tag       VARCHAR2,
      p_expiry_tag    VARCHAR2
   )
      RETURN gipir111a_tab PIPELINED
   AS
      v_rec           gipir111a_type;
      v_currency_rt   gipi_item.currency_rt%TYPE   := 0;
      v_not_exist     BOOLEAN                      := TRUE;
   BEGIN
      v_rec.company_name := giisp.v ('COMPANY_NAME');
      v_rec.company_add := giisp.v ('COMPANY_ADDRESS');

      FOR i IN (SELECT DISTINCT a.location_cd,
                                   a.location_cd
                                || '-'
                                || b.location_desc location_desc,
                                b.ret_limit retention_limit_amt,
                                b.treaty_limit treaty_limit_amt
                           FROM gixx_ca_accum a, giis_ca_location b
                          WHERE a.location_cd = b.location_cd
                            AND a.location_cd = p_location_cd)
      LOOP
         FOR j IN
            (SELECT DISTINCT a.policy_id, a.location_cd,
                             get_policy_no (a.policy_id) policy_no,
                             a.assd_name assured, b.LOCATION,
                             DECODE
                                (c.incept_tag,
                                 'Y', 'T.B.A.',
                                 DECODE (c.endt_type,
                                         NULL, TO_CHAR (c.incept_date,
                                                        'MM-DD-RRRR'
                                                       ),
                                         TO_CHAR (c.eff_date, 'MM-DD-RRRR')
                                        )
                                ) incept_date,
                             DECODE
                                (c.expiry_tag,
                                 'Y', 'T.B.A.',
                                 DECODE (c.endt_type,
                                         NULL, TO_CHAR (c.expiry_date,
                                                        'MM-DD-RRRR'
                                                       ),
                                         TO_CHAR (c.endt_expiry_date,
                                                  'MM-DD-RRRR'
                                                 )
                                        )
                                ) expiry_date,
                             SUM (a.dist_tsi) tsi_amt, a.item_no
                        FROM gixx_ca_accum_dist a,
                             gipi_casualty_item b,
                             gipi_polbasic c
                       WHERE a.policy_id = b.policy_id
                         AND a.item_no = b.item_no
                         AND a.policy_id = c.policy_id
                         AND a.location_cd = p_location_cd
                         AND a.eff_date <=
                                  DECODE (p_eff_tag,
                                          'Y', SYSDATE,
                                          a.eff_date
                                         )
                         AND a.expiry_date >=
                                DECODE (p_expiry_tag,
                                        'Y', SYSDATE,
                                        a.expiry_date
                                       )
                    GROUP BY a.policy_id,
                             a.location_cd,
                             a.assd_name,
                             b.LOCATION,
                             c.incept_tag,
                             c.endt_type,
                             c.incept_date,
                             c.eff_date,
                             c.expiry_tag,
                             c.endt_type,
                             c.expiry_date,
                             c.endt_expiry_date,
                             a.item_no
                    ORDER BY a.policy_id, a.item_no)
         LOOP
            v_not_exist := FALSE;
            v_rec.exist := 'Y';
            v_rec.location_cd := i.location_cd;
            v_rec.location_desc := i.location_desc;
            v_rec.retention_limit_amt := i.retention_limit_amt;
            v_rec.treaty_limit_amt := i.treaty_limit_amt;
            v_rec.policy_id := j.policy_id;
            v_rec.policy_no := j.policy_no;
            v_rec.assured := j.assured;
            v_rec.LOCATION := j.LOCATION;
            v_rec.incept_date := j.incept_date;
            v_rec.expiry_date := j.expiry_date;
            v_rec.ret_tsi_amt := 0;
            v_rec.treaty_tsi_amt := 0;
            v_rec.facul_tsi_amt := 0;
            v_currency_rt := 0;

            FOR rt IN (SELECT currency_rt
                         FROM gipi_item
                        WHERE policy_id = j.policy_id AND item_no = j.item_no)
            LOOP
               v_currency_rt := rt.currency_rt;
            END LOOP;

            v_rec.tsi_amt := j.tsi_amt * v_currency_rt;

            --RETENTION
            FOR ret IN (SELECT   SUM (dist_tsi) ret_tsi_amt, policy_id,
                                 item_no
                            FROM gixx_ca_accum_dist
                           WHERE location_cd = p_location_cd
                             AND share_type = 1
                             AND policy_id = j.policy_id
                             AND item_no = j.item_no
                        GROUP BY policy_id, item_no
                        ORDER BY policy_id)
            LOOP
               v_rec.ret_tsi_amt := NVL (ret.ret_tsi_amt, 0) * v_currency_rt;
            END LOOP;

            --TREATY
            FOR treaty IN (SELECT   SUM (dist_tsi) treaty_tsi_amt, policy_id,
                                    item_no
                               FROM gixx_ca_accum_dist
                              WHERE location_cd = p_location_cd
                                AND share_type = 2
                                AND policy_id = j.policy_id
                                AND item_no = j.item_no
                           GROUP BY policy_id, item_no
                           ORDER BY policy_id)
            LOOP
               v_rec.treaty_tsi_amt :=
                                NVL (treaty.treaty_tsi_amt, 0)
                                * v_currency_rt;
            END LOOP;

            --FACULTATIVE
            FOR facul IN (SELECT   SUM (dist_tsi) facul_tsi_amt, policy_id,
                                   item_no
                              FROM gixx_ca_accum_dist
                             WHERE location_cd = p_location_cd
                               AND share_type = 3
                               AND policy_id = j.policy_id
                               AND item_no = j.item_no
                          GROUP BY policy_id, item_no
                          ORDER BY policy_id)
            LOOP
               v_rec.facul_tsi_amt := NVL(facul.facul_tsi_amt,0) * v_currency_rt;
            END LOOP;

            PIPE ROW (v_rec);
         END LOOP;
      END LOOP;

      IF v_not_exist
      THEN
         v_rec.exist := 'N';
         PIPE ROW (v_rec);
      END IF;
   END populate_gipir111a;
END gipir111a_pkg;
/


