DROP PROCEDURE CPI.GIPIS097_RETRIEVE_PERILS;

CREATE OR REPLACE PROCEDURE CPI.gipis097_retrieve_perils (
  p_par_id gipi_wpolbas.par_id%TYPE, 
  p_item_no gipi_witem.item_no%TYPE,
  p_item_tsi_amt OUT gipi_witem.tsi_amt%TYPE,
  p_item_ann_tsi_amt OUT gipi_witem.ann_tsi_amt%TYPE,
  p_item_prem_amt OUT gipi_witem.prem_amt%TYPE,
  p_item_ann_prem_amt OUT gipi_witem.ann_prem_amt%TYPE
  )
IS
   v_policy_id           gipi_polbasic.policy_id%TYPE;
   v_wperl_exists        BOOLEAN                            := FALSE;
   v_old_tsi             gipi_witem.tsi_amt%TYPE;
   v_old_prem            gipi_witem.prem_amt%TYPE;
   a                     NUMBER;
   b                     NUMBER;
   v_sum_prem_amt        gipi_witem.prem_amt%TYPE;
   v_sum_ann_prem_amt    gipi_witem.ann_prem_amt%TYPE;
   comp_no_of_days       NUMBER;
   v_ret_peril_exists    BOOLEAN                            := FALSE;
   v_perilgrp_exist      BOOLEAN                            := FALSE;
   v_peril_cd            gipi_itmperil.peril_cd%TYPE;                              -- aaron 070409 to correct retrieval of perils
   v_line_cd             gipi_polbasic.line_cd%TYPE;
   v_subline_cd          gipi_polbasic.subline_cd%TYPE;
   v_iss_cd              gipi_polbasic.iss_cd%TYPE;
   v_issue_yy            gipi_polbasic.issue_yy%TYPE;
   v_pol_seq_no          gipi_polbasic.pol_seq_no%TYPE;
   v_renew_no            gipi_polbasic.renew_no%TYPE;
   v_eff_date            gipi_polbasic.eff_date%TYPE;
   v_expiry_date         gipi_polbasic.expiry_date%TYPE;
   v_incept_date         gipi_polbasic.incept_date%TYPE;
   v_prov_prem_pct       gipi_polbasic.prov_prem_pct%TYPE;
   v_prov_prem_tag       gipi_polbasic.prov_prem_tag%TYPE;
   v_b480_ann_tsi_amt    NUMBER;
   v_b480_tsi_amt        NUMBER;
   v_b480_ann_prem_amt   NUMBER;
   v_b480_prem_amt       NUMBER;
   v_peril_type          giis_peril.peril_type%TYPE;
   v_changed_tag         gipi_witem.changed_tag%TYPE;
   v_to_date             gipi_witem.TO_DATE%TYPE;
   v_from_date           gipi_witem.from_date%TYPE;
   v_comp_sw             gipi_witem.comp_sw%TYPE;
--   v_message             VARCHAR2 (1000);
--   v_message_type        VARCHAR2 (10);
   v_out_tsi_amt         NUMBER;
   v_out_prem_amt        NUMBER;
   v_out_ann_tsi_amt     NUMBER;
   v_out_ann_prem_amt    NUMBER;
   v_base_ann_prem_amt    NUMBER; 
   var_expiry_date       DATE;
   --added variable to check if no peril retrieve during Peril Retrieval by MAC 05/31/2013
   v_no_peril_exist      BOOLEAN := TRUE;
BEGIN
   
   var_expiry_date := extract_expiry5 (p_par_id); --changed to extract_expiry5 from extract_expiry by carlo 12/15/2016 SR 23330

   SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, eff_date, expiry_date, incept_date,
          prov_prem_pct, prov_prem_tag
     INTO v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no, v_eff_date, v_expiry_date, v_incept_date,
          v_prov_prem_pct, v_prov_prem_tag
     FROM gipi_wpolbas
    WHERE par_id = p_par_id;

   FOR a IN (SELECT 1
               FROM gipi_witmperl_grouped
              WHERE par_id = p_par_id AND item_no = p_item_no AND grouped_item_no <> 0)
   LOOP
      v_perilgrp_exist := TRUE; 
      EXIT;
   END LOOP;

   FOR j IN (SELECT DISTINCT a.policy_id policy_id, TRUNC (a.incept_date) incept_date, TRUNC (a.expiry_date) expiry_date,
                             a.endt_seq_no
                        FROM gipi_polbasic a
                       WHERE a.line_cd = v_line_cd
                         AND a.subline_cd = v_subline_cd
                         AND a.iss_cd = v_iss_cd
                         AND a.issue_yy = v_issue_yy
                         AND a.pol_seq_no = v_pol_seq_no
                         AND a.renew_no = v_renew_no
                         AND a.pol_flag NOT IN ('4', '5')
                    ORDER BY a.endt_seq_no DESC)
   LOOP
      comp_no_of_days := TRUNC (v_expiry_date - v_incept_date) - TRUNC (j.expiry_date - j.incept_date);
      EXIT;
   END LOOP;

   IF v_perilgrp_exist
   THEN
      raise_application_error
         ('-20001',
          'Geniisys Exception#I#You cannot insert item perils because there are existing grouped item perils for this item. Please check the records in the item information module'
         );
   ELSE
      FOR checkn IN (SELECT 1
                       FROM gipi_witmperl
                      WHERE par_id = p_par_id AND item_no = p_item_no)
      LOOP
         v_wperl_exists := TRUE;
         EXIT;
      END LOOP;

      SELECT SUM (tsi_amt)
        INTO v_old_tsi
        FROM gipi_witmperl a, giis_peril b
       WHERE par_id = p_par_id AND item_no = p_item_no AND a.peril_cd = b.peril_cd AND a.line_cd = b.line_cd
             AND b.peril_type = 'B';

      SELECT SUM (ann_prem_amt)
        INTO v_old_prem
        FROM gipi_witmperl
       WHERE par_id = p_par_id AND item_no = p_item_no;

      DELETE FROM gipi_witmperl
            WHERE par_id = p_par_id AND item_no = p_item_no;

      --DELETE_GROUP_ROW ('EXISTING_PERILS', all_rows);
      v_wperl_exists := FALSE;
      a := v_b480_ann_tsi_amt - NVL (v_old_tsi, 0);
      b := v_b480_ann_prem_amt - NVL (v_old_prem, 0);
      v_b480_ann_tsi_amt := a;
      v_b480_tsi_amt := 0;
      v_b480_ann_prem_amt := b;
      v_b480_prem_amt := 0;

      UPDATE gipi_witem
         SET ann_tsi_amt = a,
             tsi_amt = 0,
             ann_prem_amt = b,
             prem_amt = 0
       WHERE par_id = p_par_id AND item_no = p_item_no;       
                 
      --FORMS_DDL ('COMMIT');
      IF NOT v_wperl_exists
      THEN
         FOR x IN (SELECT DISTINCT peril_cd perl
                              FROM gipi_polbasic a, gipi_item b, gipi_itmperil c
                             WHERE a.line_cd = v_line_cd
                               AND a.subline_cd = v_subline_cd
                               AND a.iss_cd = v_iss_cd
                               AND a.issue_yy = v_issue_yy
                               AND a.pol_seq_no = v_pol_seq_no
                               AND a.renew_no = v_renew_no
                               AND b.item_no = p_item_no
                               AND a.pol_flag NOT IN ('4', '5')
                               AND a.policy_id = b.policy_id
                               AND b.policy_id = c.policy_id
                               AND b.item_no = c.item_no
                               AND TRUNC (eff_date) <= DECODE (NVL (endt_seq_no, 0),
                                                                    0, TRUNC (eff_date),
                                                                    TRUNC (v_eff_date))
                               AND TRUNC (DECODE (NVL (endt_expiry_date, expiry_date),
                                           expiry_date, var_expiry_date,
                                           endt_expiry_date)) >= TRUNC (v_eff_date))
                               --AND TRUNC (v_eff_date) BETWEEN TRUNC(NVL(from_date,eff_date)) --commented out by Gzelle 11202014
                                                          --AND --NVL(to_date,NVL(endt_expiry_date,expiry_date)))--commented by cherrie | 08062012
												         /* added by cherrie | 08062012
												          * get the latest expiry date of the policy
												          */
													 	  --TRUNC(DECODE(NVL(endt_expiry_date, expiry_date), expiry_date,
                                				--var_expiry_date, endt_expiry_date,endt_expiry_date)))                                                          
         LOOP
            FOR y IN (SELECT   a.policy_id, a.eff_date
                          FROM gipi_polbasic a, gipi_item b, gipi_itmperil c
                         WHERE a.line_cd = v_line_cd
                           AND a.subline_cd = v_subline_cd
                           AND a.iss_cd = v_iss_cd
                           AND a.issue_yy = v_issue_yy
                           AND a.pol_seq_no = v_pol_seq_no
                           AND a.renew_no = v_renew_no
                           AND b.item_no = p_item_no
                           AND a.pol_flag NOT IN ('4', '5')
                           AND a.policy_id = b.policy_id 
                           AND b.policy_id = c.policy_id
                           AND b.item_no = c.item_no
                           AND c.peril_cd = x.perl
                           AND TRUNC (eff_date) <= DECODE (NVL (endt_seq_no, 0),
                                                            0, TRUNC (eff_date),
                                                            TRUNC (v_eff_date))
                           AND TRUNC (DECODE (NVL (endt_expiry_date, expiry_date),
                                               expiry_date, var_expiry_date,
                                               endt_expiry_date)) >= TRUNC (v_eff_date)
                           --AND TRUNC (v_eff_date) BETWEEN TRUNC(NVL(from_date,eff_date))	--commented out by Gzelle 11202014
													 	    --AND --NVL(to_date,NVL(endt_expiry_date,expiry_date))--commented by cherrie | 08062012
													 	        /* added by cherrie | 08062012
												             * get the latest expiry date of the policy
												             */
                                                            --TRUNC(DECODE(NVL(endt_expiry_date, expiry_date), expiry_date, var_expiry_date, 
                                                                              --endt_expiry_date, endt_expiry_date))                                              
                      ORDER BY eff_date DESC)
            LOOP
               v_policy_id := y.policy_id;
               v_peril_cd := x.perl;
               EXIT;
            END LOOP;
                                                      
            IF NVL (v_policy_id, 0) <> 0
            THEN
               FOR a IN (SELECT item_no, line_cd, peril_cd, tarf_cd, prem_rt, tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt,
                                comp_rem, discount_sw, prt_flag, ri_comm_rate, ri_comm_amt, as_charge_sw, surcharge_sw,
                                no_of_days, base_amt, aggregate_sw
                           FROM gipi_itmperil
                          WHERE policy_id = v_policy_id
                            AND item_no = p_item_no
                            AND peril_cd = v_peril_cd                                                                     -- aaron
                            AND NVL (ann_tsi_amt, 0) != 0)
               LOOP
                  v_ret_peril_exists := TRUE;

                  /* modified codes by gmi 03/29/07
                  ** reason: to handle prorate computation of premium amounts
                  */
                  SELECT peril_type
                    INTO v_peril_type
                    FROM giis_peril
                   WHERE line_cd = a.line_cd AND peril_cd = a.peril_cd;

                  SELECT changed_tag, TO_DATE, from_date, comp_sw
                    INTO v_changed_tag, v_to_date, v_from_date, v_comp_sw
                    FROM gipi_witem
                   WHERE par_id = p_par_id AND item_no = p_item_no;

                  gipis097_compute_tsi (p_par_id,
                                        a.peril_cd,
                                        v_peril_type,
                                        v_changed_tag,
                                        a.ann_tsi_amt,
                                        a.prem_rt,
                                        a.ann_tsi_amt,
                                        a.ann_prem_amt,
                                        v_b480_tsi_amt,
                                        v_b480_prem_amt,
                                        v_b480_ann_tsi_amt,
                                        v_b480_ann_prem_amt,                                         /*variables.comp_no_of_days*/
                                        a.no_of_days,
                                        v_to_date,
                                        v_from_date,
                                        v_comp_sw,
                                        'X',
--                                        v_message,
--                                        v_message_type,
                                        v_out_tsi_amt,
                                        v_out_prem_amt,
                                        v_out_ann_tsi_amt,
                                        v_out_ann_prem_amt,
                                        v_base_ann_prem_amt
                                       );
                  
--                  IF v_message <> 'SUCCESS' THEN
--                    raise_application_error('-20001', 'Geniisys Exception#E#'|| v_message);
--                  END IF;

                  /* modified by mikel 12.13.2011
                  ** ri_comm_amt of previous policy and endorsement should not be included in retrieving perils
                  */
                  IF comp_no_of_days <= 0
                  THEN
                  
                     INSERT INTO gipi_witmperl
                                 (par_id, item_no, line_cd, peril_cd, rec_flag, tarf_cd, prem_rt, tsi_amt, prem_amt,
                                  ann_tsi_amt, ann_prem_amt, comp_rem,
                                  discount_sw, prt_flag, ri_comm_rate, ri_comm_amt, as_charge_sw, surcharge_sw, no_of_days,
                                  base_amt, aggregate_sw
                                 )
                          VALUES (p_par_id, a.item_no, a.line_cd, a.peril_cd, 'C', a.tarf_cd, a.prem_rt, 0, 0,
                                  a.ann_tsi_amt, a.ann_prem_amt/*v_out_ann_prem_amt - v_out_prem_amt*/, a.comp_rem,
                                  a.discount_sw, a.prt_flag, a.ri_comm_rate, 0, a.as_charge_sw, a.surcharge_sw, a.no_of_days,
                                  a.base_amt, a.aggregate_sw
                                 );
                  ELSE
                     INSERT INTO gipi_witmperl
                                 (par_id, item_no, line_cd, peril_cd, rec_flag, tarf_cd, prem_rt, tsi_amt,
                                  prem_amt, ann_tsi_amt, ann_prem_amt, comp_rem,
                                  discount_sw, prt_flag, ri_comm_rate, ri_comm_amt, as_charge_sw, surcharge_sw, no_of_days,
                                  base_amt, aggregate_sw
                                 )
                          VALUES (p_par_id, a.item_no, a.line_cd, a.peril_cd, 'C', a.tarf_cd, a.prem_rt, 0,
                                  v_out_prem_amt, a.ann_tsi_amt, a.ann_prem_amt/*v_out_ann_prem_amt*/, a.comp_rem,
                                  a.discount_sw, a.prt_flag, a.ri_comm_rate, 0, a.as_charge_sw, a.surcharge_sw, a.no_of_days,
                                  a.base_amt, a.aggregate_sw
                                 );
                  END IF;
--                  FORMS_DDL ('COMMIT');
--                  variables.v_490_prem_amt := 0;
--                  variables.v_490_tsi_amt := 0;
--                  variables.v_490_ann_prem_amt := 0;
--                  variables.v_dsp_peril_type := NULL;
               END LOOP;

               IF v_ret_peril_exists
               THEN

               	  SELECT SUM(a.ann_tsi_amt)
                    INTO v_b480_ann_tsi_amt
                    FROM gipi_witmperl a
                        ,giis_peril b
                   WHERE a.par_id = p_par_id 
                     AND a.item_no = p_item_no
                     AND b.line_cd = a.line_cd
                     AND b.peril_cd = a.peril_cd
                     AND b.peril_type = 'B';

                  SELECT SUM (prem_amt), SUM (ann_prem_amt)
                    INTO v_b480_prem_amt, v_b480_ann_prem_amt
                    FROM gipi_witmperl
                   WHERE par_id = p_par_id AND item_no = p_item_no;

                  UPDATE gipi_witem
                     SET prem_amt = NVL (v_b480_prem_amt, 0),
                         ann_prem_amt = NVL (v_b480_ann_prem_amt, 0),
                         ann_tsi_amt = NVL (v_b480_ann_tsi_amt, 0)
                   WHERE par_id = p_par_id AND item_no = p_item_no;
                                      
                  SELECT tsi_amt, ann_tsi_amt, prem_amt, ann_prem_amt
                    INTO p_item_tsi_amt, p_item_ann_tsi_amt, p_item_prem_amt, p_item_ann_prem_amt
                    FROM gipi_witem
                   WHERE par_id = p_par_id AND item_no = p_item_no; 
                   
                   v_no_peril_exist := FALSE; --set to true if at least one peril is retrieve by MAC 05/31/2013
               /*transferred outside the loop by MAC 05/31/2013.
               ELSE
                  raise_application_error ('-20001',
                                           'Geniisys Exception#I#No perils to retrieve. The annual tsi of Peril has no value.'
                                          );*/
               END IF;
               
               v_ret_peril_exists := FALSE; --set back to default value to be able to use by other perils by MAC 05/31/2013.
            ELSIF NVL (v_policy_id, 0) = 0
            THEN
               raise_application_error
                                     ('-20001',
                                      'Geniisys Exception#I#No perils to retrieve. Perils do not exist in previous endorsements.'
                                     );
            END IF;
         END LOOP;
         
         IF v_no_peril_exist THEN --display message if no peril is retrieve after the loop by MAC 05/31/2013.
            raise_application_error ('-20001', 'Geniisys Exception#I#No perils to retrieve. The annual tsi of Peril has no value.');  
         END IF;                                                                                             
      END IF;
   END IF;
END;
/


