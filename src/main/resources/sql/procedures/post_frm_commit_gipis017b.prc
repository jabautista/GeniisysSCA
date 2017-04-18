DROP PROCEDURE CPI.POST_FRM_COMMIT_GIPIS017B;

CREATE OR REPLACE PROCEDURE CPI.post_frm_commit_gipis017b (
   p_par_id                  gipi_parlist.par_id%TYPE,
   p_bond_tsi_amt   IN       gipi_winvoice.bond_tsi_amt%TYPE,
   p_prem_amt       IN       gipi_winvoice.prem_amt%TYPE,
   p_bond_rate      IN       gipi_winvoice.bond_rate%TYPE,
   p_iss_cd                  gipi_parlist.iss_cd%TYPE,
   p_message        OUT      VARCHAR2
)
IS
   v_post           NUMBER                           := 0;
   v_ann_prem_amt   gipi_wpolbas.ann_prem_amt%TYPE;
   v_ann_tsi_amt    gipi_wpolbas.ann_tsi_amt%TYPE;
   v_dist_no        giuw_pol_dist.dist_no%TYPE;
BEGIN
   FOR x IN (SELECT 1
               FROM gipi_wcomm_invoices
              WHERE par_id = p_par_id)
   LOOP
      v_post := 1;
   END LOOP;

   IF p_bond_tsi_amt != 0
   THEN
      UPDATE gipi_witem
         SET ann_tsi_amt = p_bond_tsi_amt,
             ann_prem_amt = p_prem_amt
       WHERE par_id = p_par_id AND item_no = 1;

      UPDATE gipi_witmperl
         SET ann_tsi_amt = p_bond_tsi_amt,
             ann_prem_amt = p_prem_amt
       WHERE par_id = p_par_id AND item_no = 1;

      UPDATE gipi_wpolbas
         SET ann_tsi_amt = p_bond_tsi_amt,
             ann_prem_amt = p_prem_amt
       WHERE par_id = p_par_id;
   END IF;

   IF p_iss_cd = 'RI' OR v_post = 1
   THEN
      UPDATE gipi_parlist
         SET par_status = 6
       WHERE par_id = p_par_id;
   END IF;

   FOR x IN (SELECT payt_terms
               FROM gipi_winvoice
              WHERE par_id = p_par_id)
   LOOP
      IF x.payt_terms IS NULL
      THEN
         UPDATE gipi_winvoice
            SET payt_terms = 'COD',
                bond_tsi_amt = p_bond_tsi_amt,
                bond_rate = p_bond_rate
          WHERE par_id = p_par_id;
      ELSE
         UPDATE gipi_winvoice
            SET bond_tsi_amt = p_bond_tsi_amt,
                bond_rate = p_bond_rate
          WHERE par_id = p_par_id;
      END IF;
   END LOOP;

   FOR a IN (SELECT dist_no
               FROM giuw_pol_dist
              WHERE par_id = p_par_id)
   LOOP
      v_dist_no := a.dist_no;
      EXIT;
   END LOOP;

   IF v_dist_no IS NULL
   THEN
      dist_giuw_pol_dist (p_par_id,
                          p_bond_tsi_amt,
                          p_prem_amt,
                          p_bond_rate,
                          p_message
                         );
   ELSE
      UPDATE giuw_pol_dist
         SET tsi_amt = p_bond_tsi_amt,
             prem_amt = p_prem_amt,
             ann_tsi_amt = p_bond_tsi_amt
       WHERE dist_no = v_dist_no;
   END IF;
END;
/


