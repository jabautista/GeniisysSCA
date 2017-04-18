DROP PROCEDURE CPI.CREATE_PERILDS_BY_ITEMPERILDS;

CREATE OR REPLACE PROCEDURE CPI.CREATE_PERILDS_BY_ITEMPERILDS(p_dist_no           giuw_pol_dist.dist_no%TYPE) IS
  v_dist_spct            giuw_itemds_dtl.dist_spct%TYPE;
BEGIN
    /**
    ** Created by:      Niknok Orio 
    ** Date Created:    08 15, 2011 
    ** Reference by:    GIUTS999 - Populate missing distribution records 
    */
    --CREATED BY BETH     March 28,2001
    --        create missing records in giuw_perilds and giuw_perilds_dtl
    --        using existing records in giuw_itemperilds and giuw_itemperilds_dtl 
    --        as basis of creation.

    --delete existing records in table giuw_perilds & 
    --giuw_perilds_dtl since it will be recreated
    DELETE giuw_perilds_dtl
     WHERE dist_no = p_dist_no; 
    DELETE giuw_perilds
     WHERE dist_no = p_dist_no;
    --get all combination of dist_seq_no and peril_cd from table giuw_itemperilds 
    --summarized amounts of TSI, premium and ann_tsi
  FOR A IN (SELECT c060.dist_seq_no, c060.peril_cd, c060.line_cd,
                   SUM(c060.tsi_amt) tsi, SUM(c060.prem_amt) prem,
                   SUM(c060.ann_tsi_amt) ann_tsi 
              FROM giuw_itemperilds c060
             WHERE c060.dist_no = p_dist_no
          GROUP BY c060.dist_seq_no, c060.peril_cd, c060.line_cd)
  LOOP                 
      --insert records in giuw_perilds for every record combination
    --of dist_seq_no, peril_cd in giuw_itemperilds      
    INSERT INTO giuw_perilds
               (dist_no,        dist_seq_no,   
                tsi_amt,        prem_amt,      ann_tsi_amt,
                line_cd,        peril_cd)
        VALUES (p_dist_no, a.dist_seq_no,
                a.tsi,          a.prem,        a.ann_tsi,
                a.line_cd,      a.peril_cd);
    --get summarized amounts for per share_cd and peril_cd 
    --from table giuw_itemperilds_dtl
    FOR B IN (SELECT c070.line_cd,   c070.share_cd, c070.peril_cd,
                     SUM(c070.dist_tsi) tsi, SUM(c070.dist_prem) prem,
                     SUM(c070.ann_dist_tsi) ann_tsi 
                FROM giuw_itemperilds_dtl c070
               WHERE c070.dist_no = p_dist_no 
                 AND c070.dist_seq_no = a.dist_seq_no
                 AND c070.line_cd = a.line_cd
                 AND c070.peril_cd = a.peril_cd
            GROUP BY c070.line_cd,   c070.share_cd, c070.peril_cd)
    LOOP
        --to get dist_spct divide amount per share_cd by total_amount 
        --by peril and dist_seq_no and multiply it by 100
      IF NVL(a.tsi,0) <> 0 AND NVL(b.tsi,0) <> 0 THEN 
         v_dist_spct    := (b.tsi/a.tsi) * 100;
      ELSIF NVL(a.prem,0) <> 0 AND NVL(b.prem,0) <> 0 THEN 
         v_dist_spct    := (b.prem/a.prem) * 100;   
      ELSE
           v_dist_spct    := 0;
      END IF;
      --insert records in giuw_perilds_dtl for every combination of dist_seq_no, 
      --peril_cd  and share_cd retrieved
      INSERT INTO giuw_perilds_dtl
                  (dist_no,        dist_seq_no,   line_cd,     share_cd,       peril_cd,
                      dist_spct,       dist_tsi,      dist_prem,   ann_dist_tsi,   dist_grp)
               VALUES(p_dist_no, a.dist_seq_no, b.line_cd,   b.share_cd,     b.peril_cd,
                      v_dist_spct,    b.tsi,         b.prem,      b.ann_tsi,      1);
    END LOOP;                       
  END LOOP;                                               
END;
/


