DROP PROCEDURE CPI.CREATE_ITEMDS_BY_ITEMPERILDS;

CREATE OR REPLACE PROCEDURE CPI.CREATE_ITEMDS_BY_ITEMPERILDS(
    p_dist_no           giuw_pol_dist.dist_no%TYPE,
    p_itemds_sw         VARCHAR2
    ) IS
  v_dist_spct            giuw_itemds_dtl.dist_spct%TYPE;
BEGIN
    /**
    ** Created by:      Niknok Orio 
    ** Date Created:    08 15, 2011 
    ** Reference by:    GIUTS999 - Populate missing distribution records 
    */
    --CREATED BY BETH     March 28,2001
    --        create missing records in giuw_itemds and giuw_itemds_dtl
    --        using existing records in giuw_itemperilds and giuw_itemperilds_dtl 
    --        as basis of creation.

    --delete existing records in table giuw_itemds and giuw_itemds_dtl
    -- since it will be recreated
    DELETE giuw_itemds_dtl
     WHERE dist_no = p_dist_no; 
    IF p_itemds_sw = 'N' THEN  
       DELETE giuw_itemds
       WHERE dist_no = p_dist_no;    
    END IF;   
    --get all combination of dist_seq_no and item_no from table giuw_itemperilds 
    --summarized amounts of TSI, premium and ann_tsi
  FOR A IN (SELECT c060.dist_seq_no, c060.item_no,
                   SUM(DECODE(a170.peril_type,'B',c060.tsi_amt,0)) tsi, 
                   SUM(c060.prem_amt) prem,
                   SUM(DECODE(a170.peril_type,'B',c060.ann_tsi_amt,0)) ann_tsi 
              FROM giuw_itemperilds c060, giis_peril a170
             WHERE c060.dist_no = p_dist_no
               AND c060.line_cd = a170.line_cd
               AND c060.peril_cd = a170.peril_cd
          GROUP BY c060.dist_seq_no, c060.item_no)
  LOOP                 
      --insert records in giuw_perilds for every record combination
    --of dist_seq_no, item_no in giuw_itemperilds      
    IF p_itemds_sw = 'N' THEN 
       INSERT INTO giuw_itemds
                  (dist_no,        dist_seq_no,   item_no,
                   tsi_amt,        prem_amt,      ann_tsi_amt)
           VALUES (p_dist_no, a.dist_seq_no, a.item_no,
                   a.tsi,          a.prem,        a.ann_tsi);
    END IF;               
    --get summarized amounts for per share_cd and item_no 
    --from table giuw_itemperilds_dtl
    FOR B IN (SELECT c070.line_cd,   c070.share_cd, c070.item_no,
                     SUM(DECODE (a170.peril_type,'B',c070.dist_tsi,0) )tsi, SUM(c070.dist_prem) prem,
                     SUM(DECODE (a170.peril_type,'B',c070.ann_dist_tsi,0)) ann_tsi 
                FROM giuw_itemperilds_dtl c070, giis_peril a170
               WHERE c070.dist_no = p_dist_no 
                 AND c070.dist_seq_no = a.dist_seq_no
                 AND c070.item_no = a.item_no
                 AND c070.line_cd = a170.line_cd
                 AND c070.peril_cd = a170.peril_cd
            GROUP BY c070.line_cd,   c070.share_cd, c070.item_no)
    LOOP
        --to get dist_spct divide amount per share_cd by total_amount 
        --by item and dist_seq_no and multiply it by 100
      IF NVL(a.tsi,0) <> 0 AND NVL(b.tsi,0) <> 0 THEN 
         v_dist_spct    := (b.tsi/a.tsi) * 100;
      ELSIF NVL(a.prem,0) <> 0 AND NVL(b.prem,0) <> 0 THEN 
         v_dist_spct    := (b.prem/a.prem) * 100;   
      ELSE
           v_dist_spct    := 0;
      END IF;
      --insert records in giuw_itemds_dtl for every combination of dist_seq_no, 
      --item_no  and share_cd retrieved
      INSERT INTO giuw_itemds_dtl
                  (dist_no,        dist_seq_no,   line_cd,     share_cd,       item_no,
                      dist_spct,       dist_tsi,      dist_prem,   ann_dist_tsi,   dist_grp)
               VALUES(p_dist_no, a.dist_seq_no, b.line_cd,   b.share_cd,     b.item_no,
                      v_dist_spct,    b.tsi,         b.prem,      b.ann_tsi,      1);
    END LOOP;                       
  END LOOP;                                               
END;
/


