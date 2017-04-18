DROP PROCEDURE CPI.CREATE_POLDS_BY_ITEMDS;

CREATE OR REPLACE PROCEDURE CPI.CREATE_POLDS_BY_ITEMDS(p_dist_no           giuw_pol_dist.dist_no%TYPE) IS
  v_dist_spct            giuw_policyds_dtl.dist_spct%TYPE;
BEGIN
    /**
    ** Created by:      Niknok Orio 
    ** Date Created:    08 15, 2011 
    ** Reference by:    GIUTS999 - Populate missing distribution records 
    */
    --CREATED BY BETH     March 28,2001
    --        create missing records in giuw_polds and giuw_polds_dtl
    --        using existing records in giuw_itemds and giuw_itemds_dtl 
    --        as basis of creation.

    --delete existing records in table giuw_policyds &
    --giuw_policyds_dtl since it will be recreated
    DELETE giuw_policyds_dtl
     WHERE dist_no = p_dist_no; 
    --get all dist_seq_no  from table giuw_itemperilds 
    --summarized amounts of TSI, premium and ann_tsi 
  FOR A IN (SELECT c040.dist_seq_no,      SUM(c040.ann_tsi_amt) ann_tsi, 
                   SUM(c040.tsi_amt) tsi, SUM(c040.prem_amt) prem
              FROM giuw_itemds c040
             WHERE c040.dist_no = p_dist_no
          GROUP BY c040.dist_seq_no)
  LOOP   
      --get all combination of share_cd and it's amount from giuw_itemds_dtl
      --for each dist_seq_no
    FOR B IN (SELECT c050.line_cd,   c050.share_cd,
                     SUM(c050.dist_tsi) tsi, SUM(c050.dist_prem) prem,
                     SUM(c050.ann_dist_tsi) ann_tsi 
                FROM giuw_itemds_dtl c050
               WHERE c050.dist_no = p_dist_no 
                 AND c050.dist_seq_no = a.dist_seq_no
           GROUP BY c050.line_cd,   c050.share_cd)
    LOOP
        --to get dist_spct divide amount per share_cd by total_amount 
        --by dist_seq_no and multiply it by 100
      IF NVL(a.tsi,0) <> 0 AND NVL(b.tsi,0) <> 0 THEN 
         v_dist_spct    := (b.tsi/a.tsi) * 100;
      ELSIF NVL(a.prem,0) <> 0 AND NVL(b.prem,0) <> 0 THEN 
         v_dist_spct    := (b.prem/a.prem) * 100;   
      ELSE
           v_dist_spct    := 0;
      END IF;      
      --insert records in giuw_policyds_dtl for every combination of 
      --dist_seq_no and share_cd retrieved
      INSERT INTO giuw_policyds_dtl
                  (dist_no,        dist_seq_no,   line_cd,     share_cd,
                      dist_spct,       dist_tsi,      dist_prem,   ann_dist_tsi,   dist_grp)
               VALUES(p_dist_no, a.dist_seq_no, b.line_cd,   b.share_cd,
                      v_dist_spct,    b.tsi,         b.prem,      b.ann_tsi,      1);      
    END LOOP;                       
  END LOOP;                                               
END;
/


