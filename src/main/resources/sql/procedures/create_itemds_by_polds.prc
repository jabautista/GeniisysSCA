DROP PROCEDURE CPI.CREATE_ITEMDS_BY_POLDS;

CREATE OR REPLACE PROCEDURE CPI.CREATE_ITEMDS_BY_POLDS(
    p_dist_no           giuw_pol_dist.dist_no%TYPE,
    p_policy_id         giuw_pol_dist.policy_id%TYPE,
    p_itemds_sw         VARCHAR2
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
    --        create missing records in giuw_itemds and itemds_dtl
    --        using existing records in giuw_policyds and giuw_policyds_dtl 
    --        as basis of creation.

    --delete existing records in table giuw_itemds and giuw_itemds_dtl
    -- since it will be recreated
    DELETE giuw_itemds_dtl
     WHERE dist_no = p_dist_no; 
    IF p_itemds_sw = 'N' THEN 
       DELETE giuw_itemds
       WHERE dist_no = p_dist_no;     
    END IF;   
    --select all dist_seq_no from giuw_policyds for insert in giuw_itemds
  FOR A IN (SELECT c110.dist_seq_no, item_grp 
              FROM giuw_policyds c110
             WHERE c110.dist_no = p_dist_no)
  LOOP             
      --get all item and it's amounts from table gipi_item that has peril(s)
    FOR B IN (SELECT b340.item_no,  b340.tsi_amt,
                     b340.prem_amt, b340.ann_tsi_amt
                FROM gipi_item b340
               WHERE b340.policy_id = p_policy_id
                 AND EXISTS(SELECT '1'
                              FROM gipi_itmperil b380
                             WHERE b380.policy_id = b340.policy_id
                               AND b380.item_no = b340.item_no)
                 AND b340.item_grp = a.item_grp)
    LOOP
      --insert records in table giuw_itemds for every item_no retrieved 
      IF p_itemds_sw = 'N' THEN 
         INSERT INTO giuw_itemds
                     (dist_no,        dist_seq_no,   item_no,     
                      tsi_amt,        prem_amt,      ann_tsi_amt)
              VALUES (p_dist_no, a.dist_seq_no, b.item_no,
                      b.tsi_amt,      b.prem_amt/*b.ann_tsi_amt*/, b.ann_tsi_amt); -- aaron 121707 corrected value inserted into prem_amt
      END IF;                
      --get share_cd and it's distribution percentage for every dist_no 
      --and dist_seq_no combination            
      FOR C IN (SELECT c130.line_cd,   c130.share_cd,   c130.dist_spct
                  FROM giuw_policyds_dtl c130
                 WHERE c130.dist_no = p_dist_no 
                   AND c130.dist_seq_no = a.dist_seq_no)
      LOOP
          --to get the distribtuion amount share per share_cd multiply
           --amount by percentage and divide it by 100
           v_dist_tsi     :=ROUND(b.tsi_amt * c.dist_spct/100,2);     --get distribution TSI
           v_dist_prem    :=ROUND(b.prem_amt * c.dist_spct/100,2);    --get distribution premium
           v_ann_dist_tsi :=ROUND(b.ann_tsi_amt * c.dist_spct/100,2); --get distribution ann_tsi
           --insert records in giuw_itemds_dtl for every combination of dist_seq_no, 
           --item_no and share_cd retrieved
           INSERT INTO giuw_itemds_dtl
                       (dist_no,        dist_seq_no,   line_cd,     share_cd,       item_no,
                        dist_spct,      dist_tsi,      dist_prem,   ann_dist_tsi,   dist_grp)
                 VALUES(p_dist_no, a.dist_seq_no, c.line_cd,   c.share_cd,    b.item_no,
                        c.dist_spct,    v_dist_tsi,    v_dist_prem, v_ann_dist_tsi, 1);
      END LOOP;
    END LOOP;                       
  END LOOP;                                               
END;
/


