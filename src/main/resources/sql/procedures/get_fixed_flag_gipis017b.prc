DROP PROCEDURE CPI.GET_FIXED_FLAG_GIPIS017B;

CREATE OR REPLACE PROCEDURE CPI.GET_FIXED_FLAG_GIPIS017B (
   p_par_id        IN       gipi_wpolbas.par_id%TYPE,
   p_subline_cd    OUT      gipi_wpolbas.subline_cd%TYPE,
   p_clause_type   OUT      gipi_wbond_basic.clause_type%TYPE,
   p_class_no      OUT      giis_bond_class_subline.class_no%TYPE,
   p_fixed_flag    OUT      giis_bond_class.fixed_flag%TYPE,
   p_prem_amt      IN OUT   gipi_wpolbas.prem_amt%TYPE,
   p_bond_rate     IN OUT   gipi_winvoice.bond_rate%TYPE,
   p_bond_amt      IN       gipi_wpolbas.prem_amt%TYPE,
   p_message       OUT      VARCHAR2
)
IS
   v_line_cd    gipi_wpolbas.line_cd%TYPE;
   v_prem_amt   NUMBER;
BEGIN
   BEGIN
      SELECT subline_cd, line_cd
        INTO p_subline_cd, v_line_cd
        FROM gipi_wpolbas
       WHERE par_id = p_par_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END;

   DBMS_OUTPUT.put_line ('subline: ' || p_subline_cd);

   BEGIN
       SELECT clause_type
         INTO p_clause_type
         FROM gipi_wbond_basic
        WHERE par_id = p_par_id;
   EXCEPTION
       WHEN NO_DATA_FOUND
       THEN
          NULL;
   END;
   
   FOR c1_rec IN (SELECT class_no
                    FROM giis_bond_class_subline
                   WHERE line_cd = v_line_cd
                     AND subline_cd = p_subline_cd
                     AND clause_type = p_clause_type)
   LOOP
      p_class_no := c1_rec.class_no;
   END LOOP;

   IF p_class_no IS NULL
   THEN
      p_message :=
               'This policy has no Bond Class yet. Please create Bond Class.';
      v_prem_amt := 0;
   ELSE
      v_prem_amt := 0;

      BEGIN
         FOR c2_rec IN (SELECT fixed_flag
                          FROM giis_bond_class
                         WHERE class_no = p_class_no)
         LOOP
            p_fixed_flag := c2_rec.fixed_flag;
         END LOOP;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;
   END IF;

   IF p_fixed_flag = 'A'
   THEN
      BEGIN
         FOR a IN (SELECT fixed_amt
                     FROM giis_bond_class
                    WHERE class_no = p_class_no)
         LOOP
            p_prem_amt := a.fixed_amt;
            EXIT;
         END LOOP;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      p_bond_rate := 0;
   ELSIF p_fixed_flag = 'R'
   THEN
      BEGIN
         FOR e IN (SELECT fixed_rt
                     FROM giis_bond_class
                    WHERE class_no = p_class_no)
         LOOP
            p_bond_rate := e.fixed_rt;
            EXIT;
         END LOOP;
      END;

      p_prem_amt := p_bond_rate / 100 * p_bond_amt;

      IF p_bond_rate IS NULL
      THEN
         p_message := 'Bond Amount is beyond range in Bond Class';
      END IF;
   ELSIF p_fixed_flag = 'C'
   THEN
      DECLARE
         v_min_amt      giis_bond_class.min_amt%TYPE;
         v_fixed_amt    giis_bond_class.fixed_amt%TYPE;
         v_range_high   giis_bond_class_rt.range_high%TYPE;
         v_fixed_rt     giis_bond_class.fixed_rt%TYPE;
         v_switch       VARCHAR2 (1)                         := 'N';
      BEGIN
         BEGIN
            FOR a IN (SELECT default_rt
                        FROM giis_bond_class_rt
                       WHERE class_no = p_class_no
                         AND p_bond_amt BETWEEN range_low AND range_high)
            LOOP
               p_bond_rate := a.default_rt;
               v_switch := 'Y';
               EXIT;
            END LOOP;

            IF v_switch = 'N'
            THEN
               FOR b IN (SELECT NVL (MAX (range_high), 0) range_high
                           FROM giis_bond_class_rt
                          WHERE class_no = p_class_no)
               LOOP
                  v_range_high := b.range_high;
                  EXIT;
               END LOOP;
            END IF;
         END;

         IF p_bond_rate IS NOT NULL
         THEN
            p_prem_amt := p_bond_amt * NVL (p_bond_rate, 0) / 100;
         ELSE
            BEGIN
               FOR c IN (SELECT fixed_rt, fixed_amt, min_amt
                           FROM giis_bond_class
                          WHERE class_no = p_class_no)
               LOOP
                  p_bond_rate := c.fixed_rt;
                  v_fixed_amt := c.fixed_amt;
                  v_min_amt := c.min_amt;
                  EXIT;
               END LOOP;
            END;

            p_prem_amt :=
                 (  (NVL (p_bond_amt, 0) - NVL (v_range_high, 0))
                  * NVL (p_bond_rate, 0)
                  / 100
                 )
               + NVL (v_fixed_amt, 0);
         END IF;

         IF p_bond_amt > v_range_high
         THEN
            BEGIN
               FOR d IN (SELECT fixed_rt, fixed_amt, min_amt
                           FROM giis_bond_class
                          WHERE class_no = p_class_no)
               LOOP
                  p_bond_rate := d.fixed_rt;
                  v_fixed_amt := d.fixed_amt;
                  v_min_amt := d.min_amt;
                  EXIT;
               END LOOP;
            END;

            p_prem_amt :=
                 (  (NVL (p_bond_amt, 0) - NVL (v_range_high, 0))
                  * NVL (p_bond_rate, 0)
                  / 100
                 )
               + NVL (v_fixed_amt, 0);
         END IF;
      END;
   END IF;
END GET_FIXED_FLAG_GIPIS017B;
/


