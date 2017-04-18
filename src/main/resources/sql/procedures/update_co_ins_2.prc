DROP PROCEDURE CPI.UPDATE_CO_INS_2;

CREATE OR REPLACE PROCEDURE CPI.UPDATE_CO_INS_2(
    p_new_par_id    gipi_main_co_ins.par_id%TYPE,
    p_new_policy_id gipi_main_co_ins.policy_id%TYPE,
    p_old_pol_id    gipi_main_co_ins.policy_id%TYPE
) 
IS
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-13-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : UPDATE_CO_INS program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Co-Insurance  info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;    
  
  INSERT INTO gipi_main_co_ins
             (par_id,        prem_amt,       tsi_amt, 
              last_update,   user_id,        policy_id)
      SELECT  p_new_par_id, prem_amt, tsi_amt, 
              sysdate,              user,     p_new_policy_id
        FROM  gipi_main_co_ins
       WHERE  policy_id = p_old_pol_id;

  INSERT INTO gipi_co_insurer
             (par_id,        co_ri_prem_amt,    co_ri_tsi_amt, 
              co_ri_shr_pct, last_update,       user_id,        policy_id)
      SELECT  p_new_par_id, co_ri_prem_amt,  co_ri_tsi_amt, 
              co_ri_shr_pct,        sysdate,    user,           p_new_policy_id
        FROM  gipi_co_insurer
       WHERE  policy_id = p_old_pol_id;

  INSERT INTO gipi_orig_itmperil
             (par_id,        item_no,      prem_amt,       tsi_amt, 
              line_cd,               policy_id,
              peril_cd,      rec_flag,     ann_prem_amt,   ann_tsi_amt,
              comp_rem,      discount_sw,  ri_comm_rate,   ri_comm_amt)
      SELECT  p_new_par_id,  item_no,  prem_amt,   tsi_amt, 
              line_cd,             p_new_policy_id,
              peril_cd,      rec_flag,     ann_prem_amt,   ann_tsi_amt,
              comp_rem,      discount_sw,  ri_comm_rate,   ri_comm_amt
        FROM  gipi_orig_itmperil
       WHERE  policy_id = p_old_pol_id;
 
  INSERT INTO gipi_orig_invoice
              (par_id,               item_grp,    iss_cd,      policy_id,
               prem_amt,    tax_amt,     other_charges,
               ref_inv_no,           property,    insured,     policy_currency,
               ri_comm_amt,          currency_cd, currency_rt, remarks)
        SELECT p_new_par_id, item_grp,    iss_cd,      p_new_policy_id,
                prem_amt,    tax_amt,     other_charges,
                 ref_inv_no,           property,    insured,     policy_currency,
                 ri_comm_amt,          currency_cd, currency_rt, remarks
            FROM gipi_orig_invoice
           WHERE policy_id = p_old_pol_id;

     INSERT INTO gipi_orig_inv_tax
                (par_id,               item_grp,    iss_cd,      policy_id,
                 tax_id,               tax_amt,     tax_cd,      fixed_tax_allocation,
                 tax_allocation,       line_cd,      rate)
          SELECT p_new_par_id, item_grp,    iss_cd,      p_new_policy_id,
                 tax_id,               tax_amt,     tax_cd,      fixed_tax_allocation,
                 tax_allocation,       line_cd,    rate
            FROM gipi_orig_inv_tax
           WHERE policy_id = p_old_pol_id;

     INSERT INTO gipi_orig_invperl
                (par_id,               item_grp,    peril_cd,    policy_id,
                 prem_amt,             tsi_amt,     ri_comm_amt, ri_comm_rt)
          SELECT p_new_par_id, item_grp,    peril_cd,    p_new_policy_id,
                 prem_amt,             tsi_amt,     ri_comm_amt, ri_comm_rt
            FROM gipi_orig_invperl
           WHERE policy_id = p_old_pol_id;

     INSERT INTO gipi_orig_comm_invoice
                (par_id,               item_grp,    iss_cd,       policy_id,
                 premium_amt,          wholding_tax, commission_amt,
                 intrmdry_intm_no,     share_percentage)
          SELECT p_new_par_id, item_grp,    iss_cd,       p_new_policy_id,
                 premium_amt, wholding_tax, commission_amt,
                 intrmdry_intm_no,     share_percentage
            FROM gipi_orig_comm_invoice
           WHERE policy_id = p_old_pol_id;

     INSERT INTO gipi_orig_comm_inv_peril
                (par_id,               item_grp,    iss_cd,        policy_id,
                 premium_amt, wholding_tax,  commission_amt,
                 intrmdry_intm_no,     peril_cd,    commission_rt)
          SELECT p_new_par_id, item_grp,    iss_cd,        p_new_policy_id,
                 premium_amt, wholding_tax,  commission_amt,
                 intrmdry_intm_no,     peril_cd,    commission_rt
            FROM gipi_orig_comm_inv_peril
           WHERE policy_id = p_old_pol_id;

    FOR A IN (SELECT prem_seq_no, item_grp
               FROM gipi_invoice
              WHERE policy_id = p_new_policy_id)
    LOOP
      UPDATE gipi_orig_invoice
         SET prem_seq_no = a.prem_seq_no
       WHERE policy_id = p_new_policy_id
         AND item_grp = a.item_grp;
      UPDATE gipi_orig_comm_invoice
         SET prem_seq_no = a.prem_seq_no
       WHERE policy_id = p_new_policy_id
         AND item_grp = a.item_grp;
      UPDATE gipi_orig_comm_inv_peril
         SET prem_seq_no = a.prem_seq_no
       WHERE policy_id = p_new_policy_id
         AND item_grp = a.item_grp;
    END LOOP;

END;
/


