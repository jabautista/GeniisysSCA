DROP FUNCTION CPI.VALIDATE_VESSEL1;

CREATE OR REPLACE FUNCTION CPI.validate_vessel1 (
   p_line_cd      gipi_wpolbas.line_cd%TYPE,
   p_subline_cd   gipi_wpolbas.subline_cd%TYPE,
   p_iss_cd       gipi_wpolbas.iss_cd%TYPE,
   p_issue_yy     gipi_wpolbas.issue_yy%TYPE,
   p_pol_seq_no   gipi_wpolbas.pol_seq_no%TYPE,
   p_renew_no     gipi_wpolbas.renew_no%TYPE,
   p_vessel_name  giis_vessel.vessel_name%TYPE
)
   RETURN VARCHAR2
IS
   v_vessel_cd   gipi_witem_ves.vessel_cd%TYPE;
   v_validated   VARCHAR2 (1) := 'Y';
BEGIN
   FOR item IN (SELECT DISTINCT item_no item
                           FROM gipi_item
                          WHERE policy_id IN (
                                   SELECT policy_id
                                     FROM gipi_polbasic
                                    WHERE line_cd = p_line_cd
                                      AND subline_cd = p_subline_cd
                                      AND iss_cd = p_iss_cd
                                      AND issue_yy = p_issue_yy
                                      AND pol_seq_no = p_pol_seq_no
                                      AND renew_no = p_renew_no
                                      AND pol_flag IN ('1', '2', '3', 'X')))
   LOOP
      FOR vessel IN (SELECT a.vessel_cd
                       FROM gipi_item_ves a, gipi_polbasic b
                      WHERE a.policy_id = b.policy_id
                        AND b.line_cd = p_line_cd
                        AND b.subline_cd = p_subline_cd
                        AND b.iss_cd = p_iss_cd
                        AND b.issue_yy = p_issue_yy
                        AND b.pol_seq_no = p_pol_seq_no
                        AND b.renew_no = p_renew_no
                        AND b.eff_date =
                               (SELECT MAX (eff_date)
                                  FROM gipi_item_ves d, gipi_polbasic c
                                 WHERE d.policy_id = c.policy_id
                                   AND c.line_cd = p_line_cd
                                   AND c.subline_cd = p_subline_cd
                                   AND c.iss_cd = p_iss_cd
                                   AND c.issue_yy = p_issue_yy
                                   AND c.pol_seq_no = p_pol_seq_no
                                   AND c.renew_no = p_renew_no
                                   AND c.pol_flag IN ('1', '2', '3', 'X')
                                   AND d.item_no = item.item)
                        AND a.item_no = item.item)
      LOOP
         FOR chk IN (SELECT a.rec_flag flag
                       FROM gipi_item a, gipi_polbasic b
                      WHERE a.policy_id = b.policy_id
                        AND b.line_cd = p_line_cd
                        AND b.subline_cd = p_subline_cd
                        AND b.iss_cd = p_iss_cd
                        AND b.issue_yy = p_issue_yy
                        AND b.pol_seq_no = p_pol_seq_no
                        AND b.renew_no = p_renew_no
                        AND b.eff_date =
                               (SELECT MAX (eff_date)
                                  FROM gipi_item d, gipi_polbasic c
                                 WHERE d.policy_id = c.policy_id
                                   AND c.line_cd = p_line_cd
                                   AND c.subline_cd = p_subline_cd
                                   AND c.iss_cd = p_iss_cd
                                   AND c.issue_yy = p_issue_yy
                                   AND c.pol_seq_no = p_pol_seq_no
                                   AND c.renew_no = p_renew_no
                                   AND c.pol_flag IN ('1', '2', '3', 'X')
                                   AND d.item_no = item.item)
                        AND a.item_no = item.item)
         LOOP
            IF chk.flag <> 'D'
            THEN
               FOR NAME IN (SELECT vessel_name
                              FROM giis_vessel
                             WHERE vessel_cd = vessel.vessel_cd)
               LOOP
                  IF RTRIM(LTRIM(NAME.vessel_name)) = RTRIM(LTRIM(p_vessel_name))
                  THEN
                     /*msg_alert
                        ('Vessel has already been covered by a previous policy.  Vessel should be unique.',
                         'I',
                         TRUE
                        );*/
					 v_validated := 'N';
                  END IF;
               END LOOP;
            END IF;
         END LOOP;
      END LOOP;
   END LOOP;

   RETURN v_validated;
END validate_vessel1;
/


