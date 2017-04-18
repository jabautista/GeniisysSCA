DROP PROCEDURE CPI.GIPIS039_CHANGES_IN_PAR_STATUS;

CREATE OR REPLACE PROCEDURE CPI.gipis039_changes_in_par_status (
   ps_par_id           IN   gipi_parlist.par_id%TYPE,
   ps_dist_no          IN   giuw_pol_dist.dist_no%TYPE,
   ps_line_cd          IN   gipi_parlist.line_cd%TYPE,
   ps_iss_cd                gipi_parlist.iss_cd%TYPE,
   ps_par_status       IN   gipi_parlist.par_status%TYPE,
   p_var_endt_tax_sw   OUT  VARCHAR2,
   p_var_negate_item   VARCHAR2,
   p_button_id1        NUMBER,
   p_button_id2        NUMBER
)
IS
   a_item   VARCHAR2 (1) := 'N';
   -- switch that will determine existance of additional item
   c_item   VARCHAR2 (1) := 'N';
   -- switch that will determine existance of endorsed item
   a_perl   VARCHAR2 (1) := 'N';
   -- switch that will determine existance of perils for additional item
   c_perl   VARCHAR2 (1) := 'N';
-- switch that will determine existance of perils for endorsed item
   p_msg_alert VARCHAR2(2000);
BEGIN
   FOR a IN (SELECT endt_tax
               FROM gipi_wendttext
              WHERE par_id = ps_par_id)
   LOOP
      p_var_endt_tax_sw := a.endt_tax;
      EXIT;
   END LOOP;

   -- for PAR that is not yet assigned or does not basic info exit form
   IF ps_par_status < 3
   THEN
      raise_application_error
           ('GENIISYS',
               'Your status does not allow you to edit this PAR. '
            || 'You will exit this form disregarding the changes you have made.'
           );
   --:GLOBAL.exit_sw := 'Y';
   END IF;

   -- check for additional item
   FOR a1 IN (SELECT b480.item_no item_no
                FROM gipi_witem b480
               WHERE b480.par_id = ps_par_id AND b480.rec_flag = 'A')
   LOOP
      a_perl := 'N';
      a_item := 'Y';

      -- toggle sw to determine that PAR has an additional item

      -- check if additinal item has peril already.
      FOR a2 IN (SELECT '1'
                   FROM gipi_witmperl b490
                  WHERE b490.par_id = ps_par_id AND b490.item_no = a1.item_no)
      LOOP
         a_perl := 'Y';
         -- toggle sw to determine that additional item has corresponding peril
         EXIT;
      END LOOP;

      IF a_perl = 'N'
      THEN         -- if any of the additional item has no peril exit the loop
         EXIT;
      END IF;
   END LOOP;

   IF a_item = 'N'
   THEN
      -- if there is no existing additional item then check for endorsed item
      FOR a1 IN (SELECT '1'
                   FROM gipi_witem b480
                  WHERE b480.par_id = ps_par_id)
      LOOP
         c_item := 'Y';

         -- toggle sw to determine that PAR has an endorsed item
         FOR a2 IN (SELECT '1'
                      FROM gipi_witmperl
                     WHERE par_id = ps_par_id)
         LOOP
            c_perl := 'Y';
            -- toggle sw to determine that perils for an endorsed item is existing
            EXIT;
         END LOOP;

         EXIT;
      END LOOP;
   END IF;

   -- call procedure that will create invoice if PAR has peril
   gipis039_create_invoice_item(ps_par_id, ps_line_cd, ps_iss_cd);
   -- call procedure that will create distribution records if PAR has peril
   gipis039_create_distribution (ps_par_id, ps_dist_no, p_button_id1, p_button_id2);

   /* for update of PAR_STATUS, following condition should be considered
   **   5  - if PAR is tagged as tax endorsement and there is no existing peril or additional item
   **      - if PAR has perils already and there is no additional item that has no peril
   **   4  - for PAR that have item(s) w/out peril
   **      - for PAR is have perils but there is an existing additional item that has no peril attached
   */
   IF a_item = 'N' AND c_perl = 'N' AND NVL (p_var_endt_tax_sw, 'N') = 'Y'
   THEN
      -- call procedure that will create invoice for PAR that has no peril but
      -- tagged as endoresemnt of tax
      /*Modified by Iris Bordey
      **            08.26.2002
      **If PAR is endorsement of tax and if there exists endorsed items then
      **par_status = 4 and disable the bill menu
      */
      IF c_item = 'Y'
      THEN
         UPDATE gipi_parlist
            SET par_status = 4
          WHERE par_id = ps_par_id;
         --par_status_4 (ps_par_id, ps_dist_no);
         p_var_endt_tax_sw := 'N';
      ELSE
         create_winvoice1 (ps_par_id, ps_line_cd, ps_iss_cd, p_msg_alert);
         --gipis039_create_winvoice1 (ps_par_id, ps_line_cd, ps_iss_cd);

         UPDATE gipi_parlist
            SET par_status = 5
          WHERE par_id = ps_par_id;
      END IF;
   ELSIF a_perl = 'Y' OR c_perl = 'Y'
   THEN
      -- update par status to 5 for PAR which have perils
      -- and all additional item has an attached perils
      UPDATE gipi_parlist
         SET par_status = 5
       WHERE par_id = ps_par_id;
   ELSIF a_item = 'Y' OR c_item = 'Y'
   THEN
      -- call procedure that will update par status of PAR to 4 and do enabling of
      -- valid menus
      --par_status_4 (ps_par_id, ps_dist_no);
      UPDATE gipi_parlist
         SET par_status = 4
       WHERE par_id = ps_par_id;
   ELSE
      -- call procedure that will update par status of PAR to 4 and do enabling of
      -- valid menus
      --par_status_3 (ps_par_id, ps_dist_no);
      UPDATE gipi_parlist
         SET par_status = 3
       WHERE par_id = ps_par_id;
   END IF;

   -- update amounts for table gipi_wpolbas depending on currenct perils
   update_gipi_wpolbas2 (ps_par_id, p_var_negate_item);
END;
/


