DROP PROCEDURE CPI.UPDATE_GCI;

CREATE OR REPLACE PROCEDURE CPI.update_gci (
   p_iss_cd        IN   gipi_comm_invoice.iss_cd%TYPE,
   p_prem_seq_no   IN   gipi_comm_invoice.prem_seq_no%TYPE
)
IS
/***********************************************************************************************
*  Created by: Albertcute 11/12/2015                                                           *
*   To update related commission tables with different amounts due to Modify Commission module *
*   based on total commission amount in gipi_comm_inv_peril and giac_new_comm_inv_peril        *
***********************************************************************************************/
BEGIN
   --update records in gipi_comm_inv_peril based on records in giac_new_comm_inv_peril
   FOR a IN (SELECT comm_rec_id, intm_no, iss_cd, prem_seq_no, peril_cd,
                    commission_amt, commission_rt, wholding_tax
               FROM giac_new_comm_inv_peril a
              WHERE iss_cd = p_iss_cd
                AND prem_seq_no = p_prem_seq_no
                AND comm_rec_id =
                       (SELECT MAX (comm_rec_id)
                          FROM giac_new_comm_inv
                         WHERE iss_cd = a.iss_cd
                           AND prem_seq_no = a.prem_seq_no))
   LOOP
      UPDATE gipi_comm_inv_peril
         SET commission_amt = a.commission_amt,
             commission_rt = a.commission_rt,
             wholding_tax = a.wholding_tax
       WHERE intrmdry_intm_no = a.intm_no
         AND iss_cd = a.iss_cd
         AND prem_seq_no = a.prem_seq_no
         AND peril_cd = a.peril_cd;
   END LOOP;

   COMMIT;

   --end update gipi_comm_inv_peril

   --update commission_amt in giac_new_comm_inv based on total commission in giac_new_comm_inv_peril
   FOR b IN (SELECT   comm_rec_id, iss_cd, prem_seq_no, intm_no,
                      SUM (commission_amt) commission_amt,
                      SUM (wholding_tax) wholding_tax
                 FROM giac_new_comm_inv_peril a
                WHERE iss_cd = p_iss_cd
                  AND prem_seq_no = p_prem_seq_no
                  AND comm_rec_id =
                         (SELECT MAX (comm_rec_id)
                            FROM giac_new_comm_inv
                           WHERE iss_cd = a.iss_cd
                             AND prem_seq_no = a.prem_seq_no)
             GROUP BY comm_rec_id, iss_cd, prem_seq_no, intm_no)
   LOOP
      UPDATE giac_new_comm_inv
         SET commission_amt = b.commission_amt,
             wholding_tax = b.wholding_tax
       WHERE comm_rec_id = b.comm_rec_id
         AND iss_cd = b.iss_cd
         AND prem_seq_no = b.prem_seq_no
         AND intm_no = b.intm_no;
   END LOOP;

   COMMIT;

   --end update giac_new_comm_inv

   --update commission_amt in gipi_comm_invoice based on total commission in gipi_comm_inv_peril
   FOR c IN (SELECT   iss_cd, prem_seq_no, intrmdry_intm_no,
                      SUM (commission_amt) commission_amt,
                      SUM (wholding_tax) wholding_tax
                 FROM gipi_comm_inv_peril
                WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no
             GROUP BY iss_cd, prem_seq_no, intrmdry_intm_no)
   LOOP
      UPDATE gipi_comm_invoice
         SET commission_amt = c.commission_amt,
             wholding_tax = c.wholding_tax
       WHERE iss_cd = c.iss_cd
         AND prem_seq_no = c.prem_seq_no
         AND intrmdry_intm_no = c.intrmdry_intm_no;
   END LOOP;

   COMMIT;
--end update gipi_comm_invoice
END;
/


