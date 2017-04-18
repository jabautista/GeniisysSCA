DROP PROCEDURE CPI.CHECK_MISSING_RECORDS;

CREATE OR REPLACE PROCEDURE CPI.CHECK_MISSING_RECORDS(
    p_dist_no               IN  giuw_pol_dist.dist_no%TYPE,
    p_policy_id             IN  giuw_pol_dist.policy_id%TYPE,
    p_polds_sw              OUT VARCHAR2,   --for table giuw_policyds
    p_polds_dtl_sw          OUT VARCHAR2,   --for table giuw_policyds_dtl
    p_perilds_sw            OUT VARCHAR2,   --for table giuw_perilds
    p_perilds_dtl_sw        OUT VARCHAR2,   --for table giuw_perilds_dtl
    p_itemds_sw             OUT VARCHAR2,   --for table giuw_itemds
    p_itemds_dtl_sw         OUT VARCHAR2,   --for table giuw_itemds_dtl
    p_itemperilds_sw        OUT VARCHAR2,   --for table giuw_itemperilds
    p_itemperilds_dtl_sw    OUT VARCHAR2,
    p_partial_sw            OUT VARCHAR2 
    ) IS
  /**
  **  Created by:     Niknok Orio 
  **  Date Created:   08 15, 2011
  **  Referenced by:  GIUTS999 - Create missing distribution records  
  **  Description:    
  **/  
  chk_peril       VARCHAR2(1);  --sw for checking the existance of records in giuw_perilds_dtl
  cnt_seq         NUMBER :=0;   --counter to track down no of dist_seq_no
  v_polds_sw            VARCHAR2(1);   --for table giuw_policyds
  v_polds_dtl_sw        VARCHAR2(1);   --for table giuw_policyds_dtl
  v_perilds_sw          VARCHAR2(1);   --for table giuw_perilds
  v_perilds_dtl_sw      VARCHAR2(1);     --for table giuw_perilds_dtl
  v_itemds_sw           VARCHAR2(1);   --for table giuw_itemds
  v_itemds_dtl_sw       VARCHAR2(1);   --for table giuw_itemds_dtl
  v_itemperilds_sw      VARCHAR2(1);   --for table giuw_itemperilds
  v_itemperilds_dtl_sw  VARCHAR2(1);   --for table giuw_itemperilds_dtl	  
BEGIN
  --initialize variables
  p_polds_sw            := 'N';
  p_polds_dtl_sw        := 'Y';
  p_perilds_sw          := 'N';
  p_perilds_dtl_sw      := 'Y';
  p_itemds_sw           := 'Y';
  p_itemds_dtl_sw       := 'Y';
  p_itemperilds_sw      := 'Y';
  p_itemperilds_dtl_sw  := 'Y';
  --check for the correct records inserted in giuw_policyds
  FOR A IN (SELECT b340.item_grp,         SUM(b340.prem_amt) prem, 
                   SUM(b340.tsi_amt) tsi, SUM(b340.ann_tsi_amt) ann_tsi
              FROM gipi_item b340
             WHERE b340.policy_id = p_policy_id
          GROUP BY b340.item_grp)
  LOOP
      p_polds_sw := 'N';
      FOR B IN (SELECT SUM(c110.prem_amt) prem, SUM(c110.tsi_amt) tsi,
                     SUM(c110.ann_tsi_amt) ann_tsi
                FROM giuw_policyds c110
               WHERE dist_no = p_dist_no
                 AND item_grp = a.item_grp)
    LOOP
        IF  NVL(a.prem,0) = NVL(b.prem,0) AND 
              NVL(a.tsi,0) = NVL(b.tsi,0) AND
              NVL(a.ann_tsi,0) = NVL(b.ann_tsi,0) THEN
              p_polds_sw := 'Y';
        END IF;      
    END LOOP;    
    IF p_polds_sw = 'N' THEN
         EXIT;
    END IF;
  END LOOP;
  --if records in giuw_policyds exists then check for the existance of records 
  --on other distribution tables     
  IF p_polds_sw = 'Y' THEN  
       --get all existing dist_seq_no  from giuw_policyds
     FOR SEQ IN (SELECT c110.dist_seq_no, c110.tsi_amt,
                        c110.ann_tsi_amt, c110.prem_amt
                   FROM giuw_policyds c110
                  WHERE c110.dist_no = p_dist_no)
     LOOP     
          cnt_seq := cnt_seq + 1;
         IF p_polds_dtl_sw = 'Y' THEN
            p_polds_dtl_sw := 'N';
            --check if there are corresponding records in giuw_policyds_dtl        
            -- for every record in giuw_policyds    
            FOR B IN (SELECT SUM(NVL(dist_tsi,0))  dist_tsi,
                             SUM(NVL(dist_prem,0)) dist_prem,
                             SUM(NVL(ann_dist_tsi,0)) ann_dist_tsi
                        FROM giuw_policyds_dtl c130
                       WHERE c130.dist_no = p_dist_no
                         AND c130.dist_seq_no = seq.dist_seq_no)
            LOOP            
                IF NVL(seq.tsi_amt,0) = NVL(b.dist_tsi,0) AND 
                     NVL(seq.ann_tsi_amt,0) = NVL(b.ann_dist_tsi,0) AND
                     NVL(seq.prem_amt,0) = NVL(b.dist_prem,0) THEN
                   p_polds_dtl_sw := 'Y';          
                   EXIT;
               END IF; 
            END LOOP;     
         END IF;   
       IF p_itemds_sw = 'Y' THEN  
          p_itemds_sw := 'N'; 
          --get all item_no from giuw_itemds for the dist_seq_no retrieved from giuw_policyds
          FOR ITEM IN (SELECT item_no
                         FROM giuw_itemds c040
                        WHERE c040.dist_no = p_dist_no
                          AND c040.dist_seq_no = seq.dist_seq_no)
          LOOP     
            p_itemds_sw := 'Y';
            --if discrepancy in giuw_itemds_dtl is not yet detected
            --then check for records in giuw_itemds_dtl for each item_no in giuw_itemds    
           IF p_itemds_dtl_sw = 'Y' THEN
               p_itemds_dtl_sw := 'N';
               --check if there are records corresponding records in giuw_itemds_dtl        
               -- for every record in giuw_itemds        
              FOR B IN (SELECT '1'
                          FROM giuw_itemds_dtl c050
                         WHERE c050.dist_no = p_dist_no
                           AND c050.dist_seq_no = seq.dist_seq_no
                           AND c050.item_no = item.item_no)
               LOOP            
                     p_itemds_dtl_sw := 'Y';
                     EXIT;
               END LOOP;     
              END IF;    
            --if discrepancy in giuw_itemperilds is not yet detected
            --then check for records in giuw_itemperilds for each item_no in giuw_itemds    
            IF p_itemperilds_sw = 'Y' THEN
                  --get all peril_cd from table gipi_itmperil for 
                  --each item_no retrieved in giuw_itemds               
                  FOR PERL IN (SELECT peril_cd
                              FROM gipi_itmperil    b380
                             WHERE policy_id = p_policy_id                           
                               AND item_no   = item.item_no)
               LOOP                
                   --check if there are records in giuw_itemperilds for 
                 --every record in gipi_itmperil                    
                 p_itemperilds_sw := 'N';
                 FOR A IN (SELECT '1'
                             FROM giuw_itemperilds c060
                            WHERE c060.dist_no = p_dist_no
                              AND c060.dist_seq_no = seq.dist_seq_no
                              AND c060.item_no    = item.item_no
                              AND c060.peril_cd   = perl.peril_cd)
                 LOOP     
                     p_itemperilds_sw := 'Y';
                     IF p_itemperilds_dtl_sw = 'Y' THEN
                        p_itemperilds_dtl_sw := 'N';
                        --check if there are records corresponding records in giuw_itemperilds_dtl        
                        -- for every record in giuw_itemperilds    
                        FOR B IN (SELECT '1'
                                    FROM giuw_itemperilds_dtl c070
                                   WHERE c070.dist_no = p_dist_no
                                     AND c070.dist_seq_no = seq.dist_seq_no
                                     AND c070.item_no = item.item_no
                                     AND c070.peril_cd = perl.peril_cd)
                        LOOP            
                            p_itemperilds_dtl_sw := 'Y';
                            EXIT;
                        END LOOP;     
                     END IF;   
                 END LOOP;
                 IF p_itemperilds_sw = 'N' THEN
                       EXIT;
                 END IF;      
               END LOOP;
            END IF;
            IF p_itemds_sw = 'N' THEN
               EXIT;
            END IF;
          END LOOP;
       END IF;       
     END LOOP;
     IF p_itemds_sw = 'Y' AND p_itemperilds_sw = 'Y' THEN
        --get all combination of dist_no, dist_seq_no and peril_cd from giuw_witemperilds
        FOR perl IN(SELECT DISTINCT c060.peril_cd peril_cd, c060.dist_seq_no
                      FROM giuw_itemperilds c060
                     WHERE c060.dist_no = p_dist_no)
        LOOP
             p_perilds_sw := 'N';     
          --check if there are records in giuw_perilds for every combination
          --of peril, dist_no and dist_seq_no    
          FOR A IN (SELECT c090.dist_no, c090.dist_seq_no, c090.peril_cd
                      FROM giuw_perilds c090
                     WHERE c090.dist_no     = p_dist_no
                       AND c090.dist_seq_no = perl.dist_seq_no
                       AND c090.peril_cd     = perl.peril_cd)
          LOOP     
              p_perilds_sw := 'Y';
              p_perilds_dtl_sw := 'N';
              --check if there are records corresponding records in giuw_perilds_dtl        
              -- for every record in giuw_perilds    
              FOR B IN (SELECT '1'
                          FROM giuw_perilds_dtl c100
                         WHERE c100.dist_no = a.dist_no
                           AND c100.dist_seq_no = a.dist_seq_no
                           AND c100.peril_cd = a.peril_cd)
              LOOP            
                  p_perilds_dtl_sw := 'Y';
                  EXIT;
              END LOOP;     
              IF p_perilds_dtl_sw = 'N' THEN
                 EXIT;
              END IF;
          END LOOP;
          IF p_perilds_sw = 'N' THEN
               EXIT;
          END IF;
        END LOOP;  
     END IF;
  END IF;     
  --For policy that has existing records in 1 or more distribution table
  --check first if missing distribution records can be created based on
  --the existing distribution record.
  --Creation of missing records based on existing distribution records 
  --is possible only if :
  --  *existing record is in table giuw_itemperilds_dtl or giuw_itemds_dtl
  --  *if existing records is in giuw_policyds_dtl or giuw_perilds_dtl and 
  --     there is only 1 dist_seq_no for the distribution          
  --If the above conditions are met then toggle sw VARIABLES.PARTIAL_SW to 'Y'
  --which will allow creation of missing dist.records based on existing records.
  IF p_polds_sw = 'N' THEN
     p_partial_sw := 'N';
  ELSIF p_itemds_dtl_sw = 'Y' OR 
     p_itemperilds_dtl_sw = 'Y' OR
     p_polds_dtl_sw = 'Y' THEN      
     p_partial_sw := 'Y';     
  ELSIF p_perilds_dtl_sw = 'Y' AND 
       cnt_seq = 1 THEN
       --check if amounts in policy tables tallies 
       --with the amounts in distribution tables       
       FOR c1 IN (  SELECT SUM(b380.tsi_amt)     tsi      ,
                         SUM(b380.prem_amt)    prem  ,
                         SUM(b380.ann_tsi_amt) ann_tsi  ,
                         b380.peril_cd
                    FROM gipi_itmperil b380
                   WHERE b380.policy_id = p_policy_id
                GROUP BY b380.peril_cd)
     LOOP
       chk_peril := 'N';      
          FOR C2 IN (SELECT '1'
                      FROM giuw_perilds_dtl c100
                     WHERE c100.dist_no = p_dist_no
                       AND peril_cd = c1.peril_cd  
                       AND NVL(c100.dist_tsi,0) = c1.tsi
                       AND NVL(c100.dist_prem,0) = c1.prem
                       AND NVL(c100.ann_dist_tsi,0) = c1.ann_tsi)
         LOOP              
           chk_peril := 'Y';
           EXIT;
         END LOOP;
       IF chk_peril = 'N' THEN
          EXIT;
       END IF;   
     END LOOP;    
     IF chk_peril = 'Y' THEN
        p_partial_sw := 'Y';          
     END IF;   
  ELSE   
     p_partial_sw := 'N';
  END IF;   
  IF p_partial_sw = 'Y' THEN
       IF p_itemds_sw = 'N' THEN
             p_itemds_dtl_sw := 'N';
             p_itemperilds_sw := 'N'; 
             p_itemperilds_dtl_sw := 'N';
       ELSIF p_itemperilds_sw = 'N' THEN
             p_itemperilds_dtl_sw := 'N';
       END IF;      
     IF p_perilds_sw = 'N' THEN
             p_perilds_dtl_sw := 'N';
     END IF;             
  END IF;   
END;
/


