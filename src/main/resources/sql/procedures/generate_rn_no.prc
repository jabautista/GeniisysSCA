DROP PROCEDURE CPI.GENERATE_RN_NO;

CREATE OR REPLACE PROCEDURE CPI.generate_rn_no (
   p_line_cd       gipi_polbasic.line_cd%TYPE,
   p_subline_cd    gipi_polbasic.subline_cd%TYPE,
   p_iss_cd        gipi_polbasic.iss_cd%TYPE,
   p_intm_no       giex_expiry.intm_no%TYPE,
   p_line_cd2      gipi_polbasic.line_cd%TYPE,
   p_subline_cd2   gipi_polbasic.subline_cd%TYPE,
   p_iss_cd2       gipi_polbasic.iss_cd%TYPE,
   p_issue_yy      gipi_polbasic.issue_yy%TYPE,
   p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
   p_renew_no      gipi_polbasic.renew_no%TYPE,
   p_fr_date       DATE,
   p_to_date       DATE
)
IS
   p_exist            VARCHAR2 (1)                 := 'N';
   p_rn_seq_no        NUMBER                       := 9999999;
   v_rn_seq_no        giex_rn_no.rn_seq_no%TYPE;
   v_last_rn_seq_no   giex_rn_no.rn_seq_no%TYPE;
   v_line_cd          gipi_polbasic.line_cd%TYPE;
   v_iss_cd           gipi_polbasic.iss_cd%TYPE;
   v_rn_yy            giex_rn_no.rn_yy%TYPE;
   v_rowid            VARCHAR2 (100)               := 'x';
   v_prev_rowid       VARCHAR2 (100);
   v_count            NUMBER                       := 0;
   v_insert           VARCHAR2 (1)                 := 'N';

   TYPE number_varray IS TABLE OF NUMBER
      INDEX BY BINARY_INTEGER;

   TYPE string_varray IS TABLE OF VARCHAR2 (100)
      INDEX BY BINARY_INTEGER;

   t_policy_id        number_varray;
   t_line_cd          string_varray;
   t_iss_cd           string_varray;
   t_rn_yy            number_varray;
   t_rn_seq_no        number_varray;

   CURSOR exp_pol
   IS
        SELECT a.policy_id, a.line_cd, a.iss_cd,
               TO_NUMBER (TO_CHAR (a.extract_date, 'YY')) rn_yy
          FROM giex_expiry a
         WHERE NOT EXISTS (SELECT '1'
                             FROM giex_rn_no b
                            WHERE b.policy_id = a.policy_id)
           AND a.line_cd = NVL (p_line_cd, NVL (p_line_cd2, a.line_cd))
           AND a.subline_cd = NVL (p_subline_cd, NVL (p_subline_cd2, a.subline_cd))
           AND a.iss_cd = NVL (p_iss_cd, NVL (p_iss_cd2, a.iss_cd))
           AND a.issue_yy = NVL (p_issue_yy, a.issue_yy)
           AND a.pol_seq_no = NVL (p_pol_seq_no, a.pol_seq_no)
           AND a.renew_no = NVL (p_renew_no, a.renew_no)
           AND NVL (a.intm_no, 0) = NVL (p_intm_no, NVL (a.intm_no, 0))
           AND TRUNC (a.expiry_date) >= NVL (p_fr_date, TRUNC (a.expiry_date))
           AND TRUNC (a.expiry_date) <= NVL (p_to_date, TRUNC (a.expiry_date))
           AND a.renew_flag = '2'
           AND NVL (a.pack_policy_id, 0) = 0                    --added by gmi
      ORDER BY a.line_cd,
               a.subline_cd,
               a.iss_cd,
               a.issue_yy,
               a.pol_seq_no,
               a.renew_no;
BEGIN
   /* Modified by   : Edison
   ** Date modified : 09.21.2012
   ** Modifications : Removed the rownum based conditions below.
   **                 If the policy is queried using the cursor, it will check the ff:
   **                 If the line_cd, iss_cd and rn_yy already exist in giis_rn_seq,
   **                    it will update the rn_seq_no to the current max(rn_seq_no) + 1.
   **                 If the line_cd, iss_cd and rn_yy didn't exists in giis_rn_seq,
   **                    it will insert a record in giis_rn_seq. Line_cd, iss_cd and rn_yy
   **                    will be based from the above query and the rn_seq_no will be = to 1.
   **                 All the changes made in table giis_rn_seq will be also an update to 
   **                    table giex_rn_no. */
   FOR e IN exp_pol
   LOOP
        v_rn_seq_no := 0;
        v_count := 0; --added by robert 11.14.2013 to reset the counter in every iteration of the loop
        FOR a IN (SELECT rn_seq_no
                    FROM giis_rn_seq
                   WHERE line_cd = e.line_cd
                     AND iss_cd = e.iss_cd
                     AND rn_yy = e.rn_yy)
          /* Modified by : Dexter
          ** Date mofidifed : 02.28.2013
          ** Modifications : Replace the loop from "v_rn_seq_no := a.rn_seq_no;" to v_count := v_count + 1;
                             and if condition IF v_rn_seq_no = 0  to IF v_count = 0
                          : It will check the line_cd,iss_cd and rn_yy if existing already in table giis_rn_seq, if count is 0,
                           it will insert values on table giis_rn_seq and if not, it will only update the value of rn_seq_no.


         ------------
        LOOP
            v_rn_seq_no := a.rn_seq_no;
        END LOOP;
            IF v_rn_seq_no = 0 THEN
                INSERT INTO giis_rn_seq
                            (line_cd, iss_cd, rn_yy, rn_seq_no)
                     VALUES (e.line_cd, e.iss_cd, e.rn_yy, 1);
                 
                INSERT INTO giex_rn_no
                            (policy_id, line_cd, iss_cd, rn_yy, rn_seq_no)
                     VALUES (e.policy_id, e.line_cd, e.iss_cd, e.rn_yy, 1);
      ------------
                */
      LOOP
         v_count := v_count + 1;
      END LOOP;

      IF v_count = 0
      THEN
         INSERT INTO giis_rn_seq
                     (line_cd, iss_cd, rn_yy, rn_seq_no
                     )
              VALUES (e.line_cd, e.iss_cd, e.rn_yy, 1
                     );

         INSERT INTO giex_rn_no
                     (policy_id, line_cd, iss_cd, rn_yy, rn_seq_no
                     )
              VALUES (e.policy_id, e.line_cd, e.iss_cd, e.rn_yy, 1
                     );
            ELSE
         /* Commented out by : Dexter.
         ** Date Modified : 03.04.2013
         ** Modifications : Added begin statement to catch the value of v_rn_seq_no when no data found.
                          : Added if condition where the value of v_last_rn_seq_no will add plus 1 if
                           v_last_rn_seq_no < v_rn_seq_no + 1
                           */
                SELECT MAX(rn_seq_no) + 1
                  INTO v_last_rn_seq_no
                  FROM giis_rn_seq
          WHERE line_cd = e.line_cd AND iss_cd = e.iss_cd AND rn_yy = e.rn_yy;

         BEGIN
            SELECT MAX (rn_seq_no)
              INTO v_rn_seq_no
              FROM giex_rn_no
             WHERE line_cd = e.line_cd AND iss_cd = e.iss_cd
                   AND rn_yy = e.rn_yy;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rn_seq_no := 0;
         END;

         IF v_last_rn_seq_no < v_rn_seq_no + 1
         THEN
            v_last_rn_seq_no := v_rn_seq_no + 1;
         END IF;
                
                UPDATE giis_rn_seq
                   SET rn_seq_no = v_last_rn_seq_no
                 WHERE line_cd = e.line_cd
                   AND iss_cd = e.iss_cd
                   AND rn_yy = e.rn_yy; 
                   
                INSERT INTO giex_rn_no
                            (policy_id, line_cd, iss_cd, rn_yy, rn_seq_no)
                     VALUES (e.policy_id, e.line_cd, e.iss_cd, e.rn_yy, v_last_rn_seq_no); 
            END IF;
   END LOOP;
   
   COMMIT;
   /* Comment out by Edison
   ** Comment out date : 09.21.2012
   ** Description above after BEGIN
   FOR e IN exp_pol
   LOOP
      v_count := v_count + 1;

      FOR a1 IN (SELECT        rn_seq_no, ROWID
                          FROM giis_rn_seq
                         WHERE line_cd = e.line_cd
                           AND iss_cd = e.iss_cd
                           AND rn_yy = e.rn_yy
                 FOR UPDATE OF rn_seq_no)
      LOOP
         IF v_insert = 'Y'
         THEN
            IF v_rn_seq_no IS NOT NULL
            THEN
               UPDATE giis_rn_seq
                  SET rn_seq_no = v_last_rn_seq_no
                WHERE ROWID = v_prev_rowid;
            END IF;

            v_insert := 'N';
         END IF;

         IF a1.ROWID <> v_rowid
         THEN
            IF v_rn_seq_no IS NOT NULL
            THEN
               UPDATE giis_rn_seq
                  SET rn_seq_no = v_rn_seq_no
                WHERE ROWID = v_rowid;
            END IF;

            v_insert := 'N';
         END IF;

         IF a1.ROWID <> v_rowid
         THEN
            IF a1.rn_seq_no < p_rn_seq_no
            THEN
               v_rn_seq_no := a1.rn_seq_no;
               p_exist := 'Y';
            ELSE
               v_rn_seq_no := 0;
               p_exist := 'Y';
            END IF;
         ELSE
            p_exist := 'Y';
         END IF;

         v_rowid := a1.ROWID;
      END LOOP;

      v_prev_rowid := v_rowid;
      v_last_rn_seq_no := v_rn_seq_no;

      IF p_exist = 'N'
      THEN
         v_rn_seq_no := 0;

         INSERT INTO giis_rn_seq
                     (line_cd, iss_cd, rn_yy, rn_seq_no
                     )
              VALUES (e.line_cd, e.iss_cd, e.rn_yy, v_rn_seq_no
                     );

         FOR a2 IN (SELECT rn_seq_no, ROWID
                      FROM giis_rn_seq
                     WHERE line_cd = e.line_cd
                       AND iss_cd = e.iss_cd
                       AND rn_yy = e.rn_yy)
         LOOP
            v_rowid := a2.ROWID;
         END LOOP;

         IF v_count <> 1
         THEN
            v_insert := 'Y';
         END IF;
      END IF;

      v_rn_seq_no := v_rn_seq_no + 1;
      v_line_cd := e.line_cd;
      v_iss_cd := e.iss_cd;
      v_rn_yy := e.rn_yy;
      t_policy_id (v_count) := e.policy_id;
      t_line_cd (v_count) := v_line_cd;
      t_iss_cd (v_count) := v_iss_cd;
      t_rn_yy (v_count) := v_rn_yy;
      t_rn_seq_no (v_count) := v_rn_seq_no;
      p_exist := 'N';
   END LOOP;

   IF v_count <> 1
   THEN
      UPDATE giis_rn_seq
         SET rn_seq_no = v_last_rn_seq_no
       WHERE ROWID = v_prev_rowid;
   END IF;

IF v_count > 1
  THEN
  UPDATE giis_rn_seq
     SET rn_seq_no = v_rn_seq_no
   WHERE ROWID = v_rowid;
   
  end if; 
--
   IF t_policy_id.EXISTS (1)
   THEN
      FOR indx IN t_policy_id.FIRST .. t_policy_id.LAST
      LOOP
         INSERT INTO giex_rn_no
                     (policy_id, line_cd, iss_cd,
                      rn_yy, rn_seq_no
                     )
              VALUES (t_policy_id (indx), t_line_cd (indx), t_iss_cd (indx),
                      t_rn_yy (indx), t_rn_seq_no (indx)
                     );
      END LOOP;
   END IF;

   COMMIT;*/
END;
/


