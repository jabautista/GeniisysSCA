DROP PROCEDURE CPI.CREATE_ITEMPERILDS_BY_ITEMDS;

CREATE OR REPLACE PROCEDURE CPI.CREATE_ITEMPERILDS_BY_ITEMDS(
    p_dist_no           giuw_pol_dist.dist_no%TYPE,
    p_policy_id         giuw_pol_dist.policy_id%TYPE
    ) IS
  v_dist_spct            giuw_itemds_dtl.dist_spct%TYPE;
  v_dist_tsi            giuw_itemds_dtl.dist_tsi%TYPE;
  v_dist_prem            giuw_itemds_dtl.dist_prem%TYPE;
  v_ann_dist_tsi    giuw_itemds_dtl.ann_dist_tsi%TYPE;  
BEGIN
    /**
    ** Created by:      Niknok Orio 
    ** Date Created:    08 15, 2011 
    ** Reference by:    GIUTS999 - Populate missing distribution records 
    */
    --CREATED BY BETH     March 28,2001
    --        create missing records in giuw_itemperilds and itemperilds_dtl
    --        using existing records in giuw_itemds and giuw_itemds_dtl 
    --        as basis of creation.
    
  --delete existing records in table giuw_itemperilds & 
  --giuw_itemperilds_dtl since it will be recreated
    DELETE giuw_itemperilds_dtl
     WHERE dist_no = p_dist_no; 
    DELETE giuw_itemperilds
     WHERE dist_no = p_dist_no;
    --get all combination of dist_seq_no and item_no from table giuw_itemds
  FOR A IN (SELECT c040.dist_seq_no,   c040.item_no
              FROM giuw_itemds c040
             WHERE c040.dist_no = p_dist_no)
  LOOP             
      --for every item retrieved in giuw_itemds get it's peril_cd
      --from gipi_itmperil
    FOR B IN (SELECT b380.peril_cd, b380.line_cd,    b380.tsi_amt, 
                     b380.prem_amt, b380.ann_tsi_amt
                FROM gipi_itmperil b380
               WHERE b380.policy_id = p_policy_id
                 AND b380.item_no = a.item_no)
    LOOP
        --insert records in table giuw_itemperilds for every peril
        --retrived in gipi_itmperil for each item
      INSERT INTO giuw_itemperilds
                  (dist_no,        dist_seq_no,   item_no,     
                   tsi_amt,        prem_amt,      ann_tsi_amt,
                   line_cd,        peril_cd)
           VALUES (p_dist_no, a.dist_seq_no, a.item_no,
                   b.tsi_amt,      b.prem_amt,    b.ann_tsi_amt,
                   b.line_cd,      b.peril_cd);
      --get all share and it's percentage in giuw_itemds_dtl
      --for each item             
      FOR C IN (SELECT c050.line_cd,   c050.share_cd,   c050.dist_spct
                  FROM giuw_itemds_dtl c050
                 WHERE c050.dist_no = p_dist_no 
                   AND c050.dist_seq_no = a.dist_seq_no
                   AND c050.item_no = a.item_no)
      LOOP
          --to get the distribtuion amount share per share_cd multiply
        --amount by percentage and divide it by 100
          v_dist_tsi     :=ROUND(b.tsi_amt * c.dist_spct/100,2);
           v_dist_prem    :=ROUND(b.prem_amt * c.dist_spct/100,2);
           v_ann_dist_tsi :=ROUND(b.ann_tsi_amt * c.dist_spct/100,2);
           --insert records in giuw_itemds_dtl for every combination of dist_seq_no, 
           --item_no and share_cd retrieved
           INSERT INTO giuw_itemperilds_dtl
                       (dist_no,        dist_seq_no,   line_cd,     share_cd,       item_no,
                        dist_spct,      dist_tsi,      dist_prem,   ann_dist_tsi,   dist_grp, peril_cd)
                 VALUES(p_dist_no, a.dist_seq_no, c.line_cd,   c.share_cd,     a.item_no,
                        c.dist_spct,    v_dist_tsi,    v_dist_prem, v_ann_dist_tsi, 1,        b.peril_cd);
      END LOOP;
    END LOOP;                       
  END LOOP;                                               
END;
/


