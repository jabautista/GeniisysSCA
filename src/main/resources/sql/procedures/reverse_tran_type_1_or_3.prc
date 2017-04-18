DROP PROCEDURE CPI.REVERSE_TRAN_TYPE_1_OR_3;

CREATE OR REPLACE PROCEDURE CPI.reverse_tran_type_1_or_3 (
   p_tran_id               IN       NUMBER,
   p_rev_tran_id           IN       NUMBER,
   p_tran_type             IN       NUMBER,
   p_iss_cd                IN       VARCHAR2,
   p_prem_seq_no           IN       NUMBER,
   p_inst_no               IN       NUMBER,
   p_fund_cd               IN       VARCHAR2,
   p_collection_amt        IN       NUMBER,
   p_prem_vat_exempt       IN OUT   NUMBER,
   p_giac_tax_collns_cur   OUT      giac_tax_collns_pkg.rc_giac_tax_collns_cur
)
IS
   v_param_evat       NUMBER                              := giacp.n ('EVAT');
   v_collection_amt   giac_direct_prem_collns.collection_amt%TYPE;
BEGIN
   DELETE FROM giac_tax_collns
         WHERE gacc_tran_id = p_tran_id
           AND b160_iss_cd = p_iss_cd
           AND b160_prem_seq_no = p_prem_seq_no
           AND inst_no = p_inst_no
           AND transaction_type = p_tran_type;

   v_collection_amt := p_collection_amt;

   FOR tax IN (SELECT   b160_tax_cd, SUM (NVL (a.tax_amt, 0)) * -1 tax_amt
                   FROM giac_tax_collns a, giac_acctrans b
                  WHERE a.gacc_tran_id = b.tran_id
                    AND a.b160_iss_cd = p_iss_cd
                    AND a.b160_prem_seq_no = p_prem_seq_no
                    AND b.tran_flag != 'D'
                    AND a.gacc_tran_id = p_rev_tran_id
                    AND a.inst_no = p_inst_no
                    AND b.tran_id NOT IN (
                           SELECT aa.gacc_tran_id
                             FROM giac_reversals aa, giac_acctrans bb
                            WHERE aa.reversing_tran_id = bb.tran_id
                              AND bb.tran_flag != 'D')
               GROUP BY b160_tax_cd)
   LOOP
      v_collection_amt := v_collection_amt - tax.tax_amt;

      IF v_collection_amt <> 0
      THEN
         IF tax.b160_tax_cd = v_param_evat
         THEN
            IF SIGN (ABS (p_collection_amt) - ABS (p_prem_vat_exempt)) = -1
            THEN
               p_prem_vat_exempt := v_collection_amt;
            END IF;
         END IF;
      END IF;

      INSERT INTO giac_tax_collns
                  (gacc_tran_id, transaction_type, b160_iss_cd,
                   b160_prem_seq_no, b160_tax_cd, tax_amt, fund_cd,
                   remarks, user_id, last_update, inst_no
                  )
           VALUES (p_tran_id, p_tran_type, p_iss_cd,
                   p_prem_seq_no, tax.b160_tax_cd, tax.tax_amt, p_fund_cd,
                   NULL, NVL(giis_users_pkg.app_user, USER), SYSDATE, p_inst_no
                  );
   END LOOP tax;

   --to fetch out the selected records to webpage (JSON variable)
   OPEN p_giac_tax_collns_cur FOR
      SELECT gtc.gacc_tran_id, gtc.transaction_type, gtc.b160_iss_cd,
             gtc.b160_prem_seq_no, gtc.b160_tax_cd, gtc.inst_no, gtc.fund_cd,
             gtc.tax_amt, gt.tax_name
        FROM giac_tax_collns gtc, giac_taxes gt
       WHERE gtc.gacc_tran_id = p_tran_id
         AND gtc.b160_iss_cd = p_iss_cd
         AND gtc.b160_prem_seq_no = p_prem_seq_no
         AND gtc.inst_no = p_inst_no
         AND gt.tax_cd = gtc.b160_tax_cd;
END;
/


