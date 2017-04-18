CREATE OR REPLACE PACKAGE BODY CPI.gipi_mortgagee_pkg
AS
   FUNCTION get_mortgagee (p_policy_id gipi_mortgagee.policy_id%TYPE)
      RETURN mortgagee_tab PIPELINED
   IS
      v_mortgagee   mortgagee_type;
   BEGIN
      FOR i IN (SELECT mortg_cd, amount, item_no, iss_cd, remarks, delete_sw,
                       policy_id
                  FROM gipi_mortgagee
                 WHERE policy_id = NVL (p_policy_id, policy_id))
      LOOP
         v_mortgagee.mortg_cd := i.mortg_cd;
         v_mortgagee.amount := i.amount;
         v_mortgagee.item_no := i.item_no;
         v_mortgagee.iss_cd := i.iss_cd;
         v_mortgagee.remarks := i.remarks;
         v_mortgagee.delete_sw := NVL (i.delete_sw, 'N');

         SELECT mortg_name
           INTO v_mortgagee.mortg_name
           FROM giis_mortgagee
          WHERE mortg_cd = i.mortg_cd AND iss_cd = i.iss_cd;

         SELECT SUM (amount)
           INTO v_mortgagee.sum_amount
           FROM gipi_mortgagee
          WHERE policy_id = i.policy_id;

         PIPE ROW (v_mortgagee);
      END LOOP;
   END get_mortgagee;
   
   /*
   **  Created by   : Moses Calma
   **  Date Created : June 6, 2011
   **  Reference By : (GIPIS100 - Policy Information )
   **  Description  : Retrieves list of mortgagees
   */
   FUNCTION get_item_mortgagees (
      p_policy_id   gipi_mortgagee.policy_id%TYPE,
      p_item_no     gipi_mortgagee.item_no%TYPE
   )
      RETURN item_mortgagee_tab PIPELINED
   IS
      v_item_mortgagee   item_mortgagee_type;
   BEGIN
      FOR i IN (SELECT policy_id, item_no, mortg_cd, iss_cd, delete_sw,
                       amount, remarks
                  FROM gipi_mortgagee
                 WHERE policy_id = p_policy_id 
                   AND item_no = p_item_no)
      LOOP
         v_item_mortgagee.policy_id := i.policy_id;
         v_item_mortgagee.item_no := i.item_no;
         v_item_mortgagee.mortg_cd := i.mortg_cd;
         v_item_mortgagee.iss_cd := i.iss_cd;
         v_item_mortgagee.amount := i.amount;
         v_item_mortgagee.remarks := i.remarks;
         v_item_mortgagee.delete_sw := i.delete_sw;

         IF i.iss_cd IS NULL AND i.mortg_cd IS NULL
         THEN
            v_item_mortgagee.item_no_display := i.item_no;
         ELSE
            v_item_mortgagee.item_no_display := '';
         END IF;

         BEGIN
            SELECT mortg_name
              INTO v_item_mortgagee.mortg_name
              FROM giis_mortgagee
             WHERE mortg_cd = i.mortg_cd AND iss_cd = i.iss_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_item_mortgagee.mortg_name := '';
         END;

         BEGIN
            SELECT SUM (amount) amt
              INTO v_item_mortgagee.total_mortgagee_amt
              FROM gipi_mortgagee
             WHERE policy_id = i.policy_id AND item_no = i.item_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_item_mortgagee.total_mortgagee_amt := '';
         END;

         v_item_mortgagee.delete_sw_display := NVL (i.delete_sw, 'N');
         PIPE ROW (v_item_mortgagee);
      END LOOP;
   END get_item_mortgagees;
   
   FUNCTION get_gipis100_mortgagees (
      p_policy_id   gipi_mortgagee.policy_id%TYPE
   )
      RETURN item_mortgagee_tab PIPELINED
   IS
      v_item_mortgagee     item_mortgagee_type;
      v_total_amount       gipi_mortgagee.amount%TYPE := 0;
   BEGIN
      SELECT SUM(amount)
        INTO v_total_amount
        FROM gipi_polbasic a, gipi_mortgagee b
       WHERE b.policy_id = p_policy_id
         AND b.policy_id = a.policy_id;
   
      FOR i IN (SELECT a.policy_id, a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no,
                       a.renew_no, b.mortg_cd, b.amount, b.remarks, b.item_no, b.delete_sw
                  FROM gipi_polbasic a, gipi_mortgagee b
                 WHERE b.policy_id = p_policy_id
                   AND b.policy_id = a.policy_id)
      LOOP
         v_item_mortgagee.policy_id := i.policy_id;
         v_item_mortgagee.item_no := i.item_no;
         v_item_mortgagee.mortg_cd := i.mortg_cd;
         v_item_mortgagee.iss_cd := i.iss_cd;
         v_item_mortgagee.amount := i.amount;
         v_item_mortgagee.remarks := i.remarks;
         v_item_mortgagee.delete_sw := i.delete_sw;

         IF i.iss_cd IS NULL AND i.mortg_cd IS NULL
         THEN
            v_item_mortgagee.item_no_display := i.item_no;
         ELSE
            v_item_mortgagee.item_no_display := '';
         END IF;

         BEGIN
            SELECT mortg_name
              INTO v_item_mortgagee.mortg_name
              FROM giis_mortgagee
             WHERE mortg_cd = i.mortg_cd AND iss_cd = i.iss_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_item_mortgagee.mortg_name := '';
         END;

         BEGIN
            SELECT SUM (amount) amt
              INTO v_item_mortgagee.total_mortgagee_amt
              FROM gipi_mortgagee
             WHERE policy_id = i.policy_id AND item_no = i.item_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_item_mortgagee.total_mortgagee_amt := '';
         END;

         v_item_mortgagee.delete_sw_display := NVL (i.delete_sw, 'N');
         v_item_mortgagee.total_amount := v_total_amount;
         
         PIPE ROW(v_item_mortgagee);
      END LOOP;
   END;
   
   FUNCTION get_mortgagee_del_sw (p_policy_id gipi_mortgagee.policy_id%TYPE,
                                  p_mortg_cd VARCHAR2
                                 )
      RETURN mortgagee_tab PIPELINED
   IS
      v_mortgagee   mortgagee_type;
   BEGIN
      FOR i IN (SELECT mortg_cd, amount, item_no, iss_cd, remarks, delete_sw,
                       policy_id
                  FROM gipi_mortgagee
                 WHERE policy_id = p_policy_id)
      LOOP
         v_mortgagee.mortg_cd := p_mortg_cd;
         v_mortgagee.amount := i.amount;
         v_mortgagee.item_no := i.item_no;
         v_mortgagee.iss_cd := i.iss_cd;
         v_mortgagee.remarks := i.remarks;
         v_mortgagee.delete_sw := NVL (i.delete_sw, 'N');

         SELECT mortg_name
           INTO v_mortgagee.mortg_name
           FROM giis_mortgagee
          WHERE mortg_cd = p_mortg_cd AND iss_cd = i.iss_cd;

         --Edited by MarkS SR-5483,2743,3708 to get the mortgagee amount based from the policy or net of endt
         SELECT sum(amount)
           INTO v_mortgagee.sum_amount
           FROM gipi_mortgagee
           WHERE policy_id in (SELECT policy_id 
                                 FROM gipi_polbasic b, (SELECT line_cd,subline_cd,iss_cd,issue_yy,pol_seq_no,renew_no 
                                                                FROM gipi_polbasic 
                                                                WHERE policy_id=i.policy_id) a
                                 WHERE   b.line_cd    = a.line_cd AND
                                         b.subline_cd = a.subline_cd AND
                                         b.iss_cd     = a.iss_cd AND
                                         b.issue_yy   = a.issue_yy AND
                                         b.renew_no   = a.renew_no AND
                                         b.pol_seq_no = a.pol_seq_no)
               AND mortg_cd = p_mortg_cd AND iss_cd = i.iss_cd;
         --end MarkS SR-5483,2743,3708

         PIPE ROW (v_mortgagee);
      END LOOP;
   END get_mortgagee_del_sw;
   
END gipi_mortgagee_pkg;
/
