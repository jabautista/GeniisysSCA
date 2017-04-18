DROP PROCEDURE CPI.GICL_TRIG;

CREATE OR REPLACE PROCEDURE CPI.gicl_trig
   (v_claim_id          IN    gicl_item_peril.claim_id%TYPE,
    v_item_no           IN    gicl_item_peril.item_no%TYPE,
    v_peril_cd          IN    gicl_item_peril.peril_cd%TYPE,
    v_grouped_item_no   IN    gicl_item_peril.grouped_item_no%TYPE
    )
  IS
  v_loss_date                 gicl_clm_item.loss_date%TYPE;
  v_tot_prem_amt              gipi_itmperil.prem_amt%TYPE;
  v_intm_shr_pct              gipi_comm_invoice.share_percentage%TYPE;
  v_intm_no                   giis_intermediary.intm_no%TYPE;
  v_losses_paid               gicl_clm_res_hist.losses_paid%TYPE;
  
  FUNCTION get_parent_intm
     (p_intrmdry_intm_no    IN giis_intermediary.intm_no%TYPE)
  RETURN NUMBER IS
     v_intm_no        giis_intermediary.intm_no%TYPE;
  BEGIN
    BEGIN
       SELECT NVL(a.parent_intm_no,a.intm_no)
         INTO v_intm_no
         FROM giis_intermediary a
        WHERE intm_no            = p_intrmdry_intm_no;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_intm_no  := p_intrmdry_intm_no;
      WHEN OTHERS THEN
        v_intm_no  := p_intrmdry_intm_no;
    END;
    RETURN v_intm_no;
  END get_parent_intm;

  BEGIN
  
  FOR rec IN (SELECT A2.INTRMDRY_INTM_NO,
                   A2.share_percentage,
                   AVG(A2.TOT_PREM_AMT) TOT_PREM_AMT,
                   SUM(A2.PREM_AMT) PREM_AMT  
              FROM (SELECT A1.policy_id,
                           A1.tot_prem_amt,
                           d.iss_cd,
                           d.prem_seq_no,
                           SUM(b.prem_amt) prem_amt,
                           a10.intrmdry_intm_no,
                           a10.share_percentage
                      FROM gipi_itmperil b,
                           gipi_item c,
                           gipi_comm_invoice a10,
                           gipi_invoice d,
                           (SELECT b250.policy_id     policy_id,
                                   TOT_PREM_AMT(v_claim_id, v_peril_cd, v_item_no) TOT_PREM_AMT
                              FROM gipi_polbasic B250,
                                   GICL_CLAIMS   C250,
                                   GIPI_ITMPERIL B380
                             WHERE 1=1
                               AND C250.claim_id    = v_claim_id     
                               AND b380.peril_cd    = v_peril_cd
                               AND b380.item_no     = v_item_no
                               AND B250.line_cd     = C250.line_cd    --clm_info.line_cd
                               AND B250.subline_cd  = C250.subline_cd --clm_info.subline_cd
                               AND B250.iss_cd      = C250.POL_ISS_CD --clm_info.pol_iss_cd
                               AND B250.issue_yy    = C250.ISSUE_YY   --clm_info.issue_yy
                               AND B250.pol_seq_no  = C250.POL_SEQ_NO --clm_info.pol_seq_no
                               AND B250.renew_no    = C250.renew_no   --clm_info.renew_no
                               AND B250.pol_flag   IN ('1','2','3','X' )
                               AND TRUNC(DECODE(b250.eff_date, 
                                                b250.incept_date, C250.pol_eff_date, --clm_info.pol_eff_date,
                                                b250.eff_date)) <= C250.loss_date    --clm_info.loss_date
                               AND TRUNC(DECODE(b250.expiry_date,
                                                NVL(b250.endt_expiry_date,b250.expiry_date), C250.expiry_date, --clm_info.expiry_date, 
                                                b250.endt_expiry_date)) >= TRUNC(C250.loss_date)               --clm_info.loss_date
                               AND b250.dist_flag   = '3'
                               AND b380.policy_id   = b250.policy_id
                             GROUP BY b250.policy_id) A1
                     WHERE 1=1 
                       AND c.item_no          = b.item_no
                       AND c.policy_id        = b.policy_id
                       AND c.item_grp         = d.item_grp
                       AND c.policy_id        = d.policy_id
                       AND b.peril_cd         = v_peril_cd
                       AND b.item_no          = v_item_no
                       AND c.policy_id        = A1.policy_id
                       AND a10.prem_seq_no  =  d.prem_seq_no   --invoice_rec.prem_seq_no
                       AND a10.iss_cd       =  d.iss_cd        --invoice_rec.iss_cd
                       AND a10.policy_id    =  A1.policy_id    --policies_rec.policy_id
                     GROUP BY d.item_grp,d.iss_cd,d.prem_seq_no, A1.policy_id, A1.tot_prem_amt
                             ,a10.intrmdry_intm_no, a10.share_percentage) A2
             GROUP BY A2.INTRMDRY_INTM_NO, A2.share_percentage)
LOOP
   --retrieve the parent intermediary using the function
   v_intm_no    := get_parent_intm(rec.intrmdry_intm_no);
   BEGIN
      -- compute amts to get the percent of a particular intm
      -- it should the amount per invoice * the share percent of the intm.
      -- over the total premium of the item peril
      v_intm_shr_pct  := (rec.prem_amt * (rec.share_percentage)) / rec.tot_prem_amt;
         EXCEPTION
            WHEN ZERO_DIVIDE THEN
               v_intm_shr_pct  := 0;
   END;
   -- if the computed share percent per intermediary <> 0 then
   -- insert/update records in gicl_intm_itmperil using the computed share percent
   IF v_intm_shr_pct <> 0 THEN
      BEGIN
         UPDATE gicl_intm_itmperil
            SET shr_intm_pct    = shr_intm_pct + v_intm_shr_pct,
                premium_amt     = premium_amt + ((v_intm_shr_pct*rec.tot_prem_amt)/100)
          WHERE intm_no         = rec.intrmdry_intm_no
            AND grouped_item_no = v_grouped_item_no
            AND peril_cd        = v_peril_cd
            AND item_no         = v_item_no
            AND claim_id        = v_claim_id;
         IF SQL%NOTFOUND THEN
            INSERT INTO gicl_intm_itmperil(claim_id,          item_no,               peril_cd,     
                                           grouped_item_no,   intm_no,               parent_intm_no,   
                                           shr_intm_pct,      premium_amt)
                                    VALUES(v_claim_id,        v_item_no,             v_peril_cd,   
                                           v_grouped_item_no, rec.intrmdry_intm_no,  v_intm_no,        
                                           v_intm_shr_pct,    (v_intm_shr_pct*rec.tot_prem_amt)/100);
         END IF;
      END;
   ELSE
      -- if the computed share percent per intermediary = 0 then
      -- insert/update records in gicl_intm_itmperil using the share percent from gipi_comm_inv_peril
      BEGIN
         UPDATE gicl_intm_itmperil
            SET shr_intm_pct    = rec.share_percentage,
                premium_amt     = premium_amt + ((v_intm_shr_pct*rec.tot_prem_amt)/100)
          WHERE intm_no         = rec.intrmdry_intm_no
            AND grouped_item_no = v_grouped_item_no
            AND peril_cd        = v_peril_cd
            AND item_no         = v_item_no
            AND claim_id        = v_claim_id;
         IF SQL%NOTFOUND THEN
            INSERT INTO gicl_intm_itmperil(claim_id,             item_no,              peril_cd,
                                           grouped_item_no,      intm_no,              parent_intm_no,
                                           shr_intm_pct,         premium_amt)
                                    VALUES(v_claim_id,           v_item_no,            v_peril_cd,
                                           v_grouped_item_no,    rec.intrmdry_intm_no, v_intm_no,
                                           rec.share_percentage, (v_intm_shr_pct*rec.tot_prem_amt)/100);
         END IF;
      END;
   END IF;
END LOOP;
  
  END;
/


