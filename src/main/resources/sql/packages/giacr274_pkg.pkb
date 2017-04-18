CREATE OR REPLACE PACKAGE BODY CPI.giacr274_pkg
AS
/*
** Created by : Benedict G. Castillo
** Date Created : 07.11.2013
** Description : GIACR274_PKG-LIST OF BINDERS ATTACHED TO REDISTRIBUTED RECORDS
*/
   FUNCTION populate_giacr274 (p_iss_cd VARCHAR2, p_line_cd VARCHAR2)
      RETURN giacr274_tab PIPELINED
   AS
      v_rec         giacr274_type;
      v_not_exist   BOOLEAN       := TRUE;
      counter       NUMBER        := NULL;
   BEGIN
      v_rec.company_name := giisp.v ('COMPANY_NAME');
      v_rec.company_address := giisp.v ('COMPANY_ADDRESS');

      FOR z IN (SELECT   iss_cd, line_cd, policy_id, MIN (dist_no) min_dist,
                         MAX (dist_no) max_dist,
                         COUNT (DISTINCT dist_no) counter
                    FROM giac_redist_binders_ext
                   WHERE line_cd = NVL (p_line_cd, line_cd)
                     AND iss_cd = NVL (p_iss_cd, iss_cd)
                GROUP BY iss_cd, line_cd, policy_id
                ORDER BY iss_cd, line_cd, policy_id)
      LOOP
         v_rec.dist_no1 := NULL;
         v_rec.dist_no2 := NULL;
         v_rec.dist_no3 := NULL;

         FOR i IN (SELECT   iss_cd, line_cd, policy_id, dist_no, policy_no
                       FROM giac_redist_binders_ext
                      WHERE policy_id = z.policy_id
                   ORDER BY iss_cd, line_cd, policy_id)
         LOOP
            v_not_exist := FALSE;

            IF counter < z.counter
            THEN
               v_rec.counter := z.counter;
            ELSE
               NULL;
            END IF;

            v_rec.branch := get_iss_name (i.iss_cd);
            v_rec.line_name := get_line_name (i.line_cd);

            IF z.counter = 1
            THEN
               v_rec.dist_no1 := z.min_dist;
            ELSIF z.counter = 2
            THEN
               v_rec.dist_no1 := z.min_dist;
               v_rec.dist_no2 := z.max_dist;
            ELSIF z.counter = 3
            THEN
               v_rec.dist_no1 := z.min_dist;
               v_rec.dist_no2 := i.dist_no;
               v_rec.dist_no3 := z.max_dist;
            END IF;

            v_rec.policy_id := i.policy_id;
            v_rec.policy_no := i.policy_no;
            v_rec.iss_cd := i.iss_cd;
            v_rec.line_cd := i.line_cd;
            PIPE ROW (v_rec);
         END LOOP;
      END LOOP;

      IF v_not_exist
      THEN
         v_rec.flag := 'T';
         PIPE ROW (v_rec);
      ELSE
         NULL;
      END IF;
   END populate_giacr274;

   FUNCTION populate_column_title (
      p_iss_cd    VARCHAR2,
      p_line_cd   VARCHAR2,
      p_user_id   VARCHAR2
   )
      RETURN column_tab PIPELINED
   AS
      v_recs   column_type;
   BEGIN
      FOR i IN (SELECT   MAX (COUNT (DISTINCT dist_no)) max_count
                    FROM giac_redist_binders_ext
                   WHERE line_cd = NVL (p_line_cd, line_cd)
                     AND iss_cd = NVL (p_iss_cd, iss_cd)
                     AND user_id = NVL (p_user_id, user_id)
                GROUP BY policy_id)
      LOOP
         IF i.max_count IS NOT NULL
         THEN
            FOR z IN 1 .. (i.max_count)
            LOOP
               v_recs.max_count := v_recs.max_count;
               PIPE ROW (v_recs);
            END LOOP;
         ELSE
            v_recs.flag := 'T';
            PIPE ROW (v_recs);
         END IF;
      END LOOP;
   END populate_column_title;

   FUNCTION populate_giacr274_details (
      p_iss_cd      VARCHAR2,
      p_line_cd     VARCHAR2,
      p_user_id     VARCHAR2,
      p_policy_id   NUMBER,
      p_dist_no     NUMBER
   )
      RETURN giacr274_details_tab PIPELINED
   AS
      v_rec   giacr274_details_type;
   BEGIN
      FOR i IN (SELECT iss_cd, line_cd, policy_no, policy_id, dist_no,
                       binder_no, ri_cd, prem_amt, comm_amt, paid_amt
                  FROM giac_redist_binders_ext
                 WHERE line_cd = NVL (p_line_cd, line_cd)
                   AND iss_cd = NVL (p_iss_cd, iss_cd)
                   AND policy_id = p_policy_id
                   AND dist_no = p_dist_no)
      LOOP
         v_rec.dist_no := i.dist_no;
         v_rec.binder_no := i.binder_no;
         v_rec.ri_name := get_ri_sname (i.ri_cd);
         v_rec.prem_amt := i.prem_amt;
         v_rec.comm_amt := i.comm_amt;
         v_rec.paid_amt := i.paid_amt;
         v_rec.policy_id := i.policy_id;
         PIPE ROW (v_rec);
      END LOOP;
   END populate_giacr274_details;
END giacr274_pkg;
/


