CREATE OR REPLACE PACKAGE BODY CPI.gipi_deductibles_pkg
AS
   
   /*
   **  Created by   : Moses Calma
   **  Date Created : May 12, 2011
   **  Reference By : (GIPIS100 - View Policy Information)
   **  Description  : Retrieves policy deductibles 
   */
          
   FUNCTION get_deductibles (p_policy_id gipi_ves_air.policy_id%TYPE)
      RETURN deductibles_tab PIPELINED
   IS
      v_deductibles   deductibles_type;
   BEGIN
      FOR i IN (SELECT policy_id, aggregate_sw, ceiling_sw, ded_line_cd,
                       ded_subline_cd, ded_deductible_cd, deductible_rt,
                       deductible_amt, deductible_text
                  FROM gipi_deductibles
                 WHERE item_no = 0
                   AND policy_id = NVL (p_policy_id, policy_id))
      LOOP
         v_deductibles.aggregate_sw := i.aggregate_sw;
         v_deductibles.ceiling_sw := i.ceiling_sw;
         v_deductibles.deductible_rt := i.deductible_rt;
         v_deductibles.deductible_amt := i.deductible_amt;
         v_deductibles.deductible_text := i.deductible_text;
         v_deductibles.ded_deductible_cd := i.ded_deductible_cd;

         SELECT deductible_title
           INTO v_deductibles.deductible_title
           FROM giis_deductible_desc
          WHERE line_cd = i.ded_line_cd
            AND subline_cd = i.ded_subline_cd
            AND deductible_cd = i.ded_deductible_cd;

         SELECT SUM (deductible_amt)
           INTO v_deductibles.total_deductible_amt
           FROM gipi_deductibles
          WHERE policy_id = i.policy_id AND item_no = 0;

         PIPE ROW (v_deductibles);
      END LOOP;
   END get_deductibles;
   
   /*
   **  Created by   : Moses Calma
   **  Date Created : June 6, 2011
   **  Reference By : (GIPIS100 - Policy Information Basic/Item Info)
   **  Description  : Retrieves deductibles of an item
   */       
   FUNCTION get_item_deductibles (
      p_policy_id   gipi_deductibles.policy_id%TYPE,
      p_item_no     gipi_deductibles.item_no%TYPE
   )
      RETURN item_deductible_tab PIPELINED
   IS
      v_item_deductible   item_deductible_type;
   BEGIN
      FOR i IN (SELECT policy_id, item_no, ded_deductible_cd, aggregate_sw,
                       ceiling_sw, deductible_rt, deductible_amt,
                       deductible_text, ded_line_cd, ded_subline_cd
                  FROM gipi_deductibles
                 WHERE policy_id = p_policy_id AND item_no = p_item_no)
      LOOP
      
         v_item_deductible.policy_id         := i.policy_id;
         v_item_deductible.item_no           := i.item_no;
         v_item_deductible.ceiling_sw        := i.ceiling_sw;
         v_item_deductible.ded_line_cd       := i.ded_line_cd;
         v_item_deductible.aggregate_sw      := i.aggregate_sw;
         v_item_deductible.deductible_rt     := i.deductible_rt;
         v_item_deductible.deductible_text   := i.deductible_text;
         v_item_deductible.ded_subline_cd    := i.ded_subline_cd;
         v_item_deductible.deductible_amt    := i.deductible_amt;
         v_item_deductible.ded_deductible_cd := i.ded_deductible_cd;
         
         BEGIN
        
           SELECT item_title 
             INTO v_item_deductible.item_title 
             FROM gipi_item
            WHERE policy_id = i.policy_id 
              AND item_no = i.item_no;
              
         EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
             v_item_deductible.item_title    := '';
         END;
         
         BEGIN
            SELECT deductible_title
              INTO v_item_deductible.deductible_name
              FROM giis_deductible_desc
             WHERE line_cd = i.ded_line_cd
               AND subline_cd = i.ded_subline_cd
               AND deductible_cd = i.ded_deductible_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_item_deductible.deductible_name := '';
         END;

         SELECT SUM (deductible_amt) amt
           INTO v_item_deductible.total_deductible_amt
           FROM gipi_deductibles
          WHERE policy_id = i.policy_id AND item_no = i.item_no;

         PIPE ROW (v_item_deductible);
      END LOOP;
   END get_item_deductibles;
   
   FUNCTION get_gipis100_deductibles (
      p_policy_id   gipi_deductibles.policy_id%TYPE
   ) RETURN item_deductible_tab PIPELINED IS
      v_item_deductible       item_deductible_type;
      v_total_deductible_amt  gipi_deductibles.deductible_amt%TYPE := 0;
   BEGIN
      SELECT SUM(b.deductible_amt)
        INTO v_total_deductible_amt
        FROM gipi_polbasic a, gipi_deductibles b
       WHERE a.policy_id = b.policy_id
         AND item_no = 0
         AND a.policy_id = p_policy_id;
   
      FOR i IN (SELECT a.policy_id, b.item_no, b.ceiling_sw, b.ded_line_cd, b.aggregate_sw,
                       b.deductible_rt, b.deductible_text, b.ded_subline_cd, b.deductible_amt, b.ded_deductible_cd
                  FROM gipi_polbasic a, gipi_deductibles b
                 WHERE a.policy_id = b.policy_id
                   AND item_no = 0
                   AND a.policy_id = p_policy_id)
      LOOP
         v_item_deductible.policy_id         := i.policy_id;
         v_item_deductible.item_no           := i.item_no;
         v_item_deductible.ceiling_sw        := i.ceiling_sw;
         v_item_deductible.ded_line_cd       := i.ded_line_cd;
         v_item_deductible.aggregate_sw      := i.aggregate_sw;
         v_item_deductible.deductible_rt     := i.deductible_rt;
         v_item_deductible.deductible_text   := i.deductible_text;
         v_item_deductible.ded_subline_cd    := i.ded_subline_cd;
         v_item_deductible.deductible_amt    := NVL(i.deductible_amt, 0);
         v_item_deductible.ded_deductible_cd := i.ded_deductible_cd;
         
         BEGIN
        
           SELECT item_title 
             INTO v_item_deductible.item_title 
             FROM gipi_item
            WHERE policy_id = i.policy_id 
              AND item_no = i.item_no;
              
         EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
             v_item_deductible.item_title    := '';
         END;
         
         BEGIN
            SELECT deductible_title
              INTO v_item_deductible.deductible_name
              FROM giis_deductible_desc
             WHERE line_cd = i.ded_line_cd
               AND subline_cd = i.ded_subline_cd
               AND deductible_cd = i.ded_deductible_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_item_deductible.deductible_name := '';
         END;

         v_item_deductible.total_deductible_amt := NVL(v_total_deductible_amt, 0);

         PIPE ROW (v_item_deductible);
      END LOOP;
   END;
   
END gipi_deductibles_pkg;
/


