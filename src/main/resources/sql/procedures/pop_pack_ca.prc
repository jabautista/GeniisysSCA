DROP PROCEDURE CPI.POP_PACK_CA;

CREATE OR REPLACE PROCEDURE CPI.POP_PACK_CA (p_par_id       IN  GIPI_WITEM.par_id%TYPE,
                                         p_item_no      IN  GIPI_WITEM.item_no%TYPE,
                                         p_line_cd      IN  GIPI_POLBASIC.line_cd%TYPE,
                                         p_subline_cd   IN  GIPI_POLBASIC.subline_cd%TYPE,
                                         p_iss_cd       IN  GIPI_POLBASIC.iss_cd%TYPE,
                                         p_issue_yy     IN  GIPI_POLBASIC.issue_yy%TYPE,
                                         p_pol_seq_no   IN  GIPI_POLBASIC.pol_seq_no%TYPE,
                                         p_renew_no     IN  GIPI_POLBASIC.renew_no%TYPE,
                                         p_eff_date     IN  GIPI_POLBASIC.eff_date%TYPE,
                                         p_expiry_date  IN  GIPI_POLBASIC.expiry_date%TYPE) 
IS

/*
**  Created by   : Veronica V. Raymundo
**  Date Created : July 21, 2011
**  Reference By : (GIPIS096 - Package Endt PAR Policy Items)
**  Description  : Equivalent to the Program Unit POP_PACK_CA in GIPIS096 module
*/
                                             
       v_eff_date           GIPI_POLBASIC.eff_date%TYPE;
       v_new_item           VARCHAR2(1) := 'Y'; 
       expired_sw           VARCHAR2(1) := 'N';
       amt_sw               VARCHAR2(1) := 'N';
       v_expiry_date        DATE;
       v_max_endt_seq_no    GIPI_POLBASIC.endt_seq_no%TYPE;
       v_max_endt_seq_no1   GIPI_POLBASIC.endt_seq_no%TYPE;
       b480                 GIPI_WITEM%ROWTYPE;
       
       CURSOR A IS
          SELECT      a.policy_id policy_id, a.eff_date eff_date
            FROM      GIPI_POLBASIC a
           WHERE      a.line_cd                 =  p_line_cd
             AND      a.iss_cd                  =  p_iss_cd
             AND      a.subline_cd              =  p_subline_cd
             AND      a.issue_yy                =  p_issue_yy
             AND      a.pol_seq_no              =  p_pol_seq_no
             AND      a.renew_no = p_renew_no
             -- lian 111501 added pol_flag = 'X'
             AND      a.pol_flag                IN ('1','2','3','X')
             AND      TRUNC(DECODE(NVL(a.endt_expiry_date, a.expiry_date),
                        a.expiry_date,p_expiry_date,a.endt_expiry_date)) 
                        >= TRUNC(p_eff_date)
             --ASI 081299 add this validation so that data that will be retrieved
              --           is only those from endorsement prior to the current endorsement
              --           this was consider because of the backward endorsement
             AND      TRUNC(a.eff_date) <= DECODE(nvl(a.endt_seq_no,0),0,TRUNC(a.eff_date), TRUNC(p_eff_date))
             AND      EXISTS (SELECT '1'
                               FROM GIPI_ITEM b
                              WHERE b.item_no = p_item_no
                                AND b.policy_id = a.policy_id)      
        ORDER BY     eff_date DESC;
       
       CURSOR B(p_policy_id  GIPI_ITEM.policy_id%TYPE) IS
          SELECT      item_title,
                      currency_cd,
                      currency_rt,
                      ann_tsi_amt,
                      ann_prem_amt,
                      from_date,
                      to_date,
                      pack_line_cd,
                      pack_subline_cd,
                      group_cd
            FROM      GIPI_ITEM
           WHERE      policy_id   =  p_policy_id
             AND      item_no     =  p_item_no;
        
        CURSOR C(p_currency_cd GIIS_CURRENCY.main_currency_cd%TYPE) IS
           SELECT    currency_desc, short_name
             FROM    GIIS_CURRENCY
            WHERE    main_currency_cd  =  p_currency_cd;
            
        CURSOR D IS
           SELECT    a.policy_id policy_id, a.eff_date eff_date
             FROM    GIPI_POLBASIC a
            WHERE    a.line_cd     =  p_line_cd
              AND    a.iss_cd      =  p_iss_cd
              AND    a.subline_cd  =  p_subline_cd
              AND    a.issue_yy    =  p_issue_yy
              AND    a.pol_seq_no  =  p_pol_seq_no
              AND    a.renew_no    =  p_renew_no
              -- lian 111501 added pol_flag = 'X'
              AND    a.pol_flag    IN( '1','2','3','X')
              AND    TRUNC(a.eff_date) <= DECODE(nvl(a.endt_seq_no,0),0,TRUNC(a.eff_date), TRUNC(p_eff_date))
              AND    TRUNC(DECODE(NVL(a.endt_expiry_date, a.expiry_date),
                        a.expiry_date,p_expiry_date,a.endt_expiry_date)) 
                        >= TRUNC(p_eff_date)
              AND    NVL(a.back_stat,5) = 2
              AND    EXISTS (SELECT '1'
                               FROM GIPI_ITEM b
                              WHERE b.item_no = p_item_no
                                AND a.policy_id = b.policy_id)      
              AND    a.endt_seq_no = (SELECT MAX(endt_seq_no)
                                        FROM GIPI_POLBASIC c
                                       WHERE line_cd     =  p_line_cd
                                         AND iss_cd      =  p_iss_cd
                                         AND subline_cd  =  p_subline_cd
                                         AND issue_yy    =  p_issue_yy
                                         AND pol_seq_no  =  p_pol_seq_no
                                         AND renew_no    =  p_renew_no
                                         -- lian 111501 added pol_flag = 'X'
                                         AND pol_flag  IN( '1','2','3','X')
                                         AND TRUNC(eff_date) <= TRUNC(p_eff_date)
                                         AND TRUNC(DECODE(NVL(c.endt_expiry_date, c.expiry_date),
                                               c.expiry_date,p_expiry_date,c.endt_expiry_date)) 
                                               >= TRUNC(p_eff_date)
                                         AND NVL(c.back_stat,5) = 2
                                         AND EXISTS (SELECT '1'
                                                       FROM GIPI_ITEM d
                                                      WHERE d.item_no = p_item_no
                                                        AND c.policy_id = d.policy_id))                        
         ORDER BY   eff_date DESC;
        
BEGIN
    v_expiry_date := GIPIS096_EXTRACT_EXPIRY(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
         
    BEGIN
        FOR Z IN (SELECT MAX(endt_seq_no) endt_seq_no
                  FROM GIPI_POLBASIC a
                 WHERE line_cd     =  p_line_cd
                   AND iss_cd      =  p_iss_cd
                   AND subline_cd  =  p_subline_cd
                   AND issue_yy    =  p_issue_yy
                   AND pol_seq_no  =  p_pol_seq_no
                   AND renew_no    =  p_renew_no
                   -- lian 111501 added pol_flag = 'X'
                   AND pol_flag  IN( '1','2','3','X')
                   AND TRUNC(eff_date) <= DECODE(nvl(a.endt_seq_no,0),0,TRUNC(a.eff_date), TRUNC(p_eff_date))
                   AND TRUNC(DECODE(NVL(a.endt_expiry_date, a.expiry_date),
                        a.expiry_date,p_expiry_date,a.endt_expiry_date)) 
                        >= TRUNC(p_eff_date)
                   AND EXISTS (SELECT '1'
                                 FROM GIPI_ITEM b
                                WHERE b.item_no = p_item_no
                                  AND a.policy_id = b.policy_id)) LOOP
          v_max_endt_seq_no := z.endt_seq_no;
          EXIT;
      END LOOP;                                
      
      FOR X IN (SELECT MAX(endt_seq_no) endt_seq_no
                  FROM GIPI_POLBASIC a
                 WHERE line_cd     =  p_line_cd
                   AND iss_cd      =  p_iss_cd
                   AND subline_cd  =  p_subline_cd
                   AND issue_yy    =  p_issue_yy
                   AND pol_seq_no  =  p_pol_seq_no
                   AND renew_no    =  p_renew_no
                   -- lian 111501 added pol_flag = 'X'
                   AND pol_flag  IN( '1','2','3','X')
                   AND TRUNC(eff_date) <= TRUNC(p_eff_date)
                   AND TRUNC(DECODE(NVL(a.endt_expiry_date, a.expiry_date),
                        a.expiry_date,p_expiry_date,a.endt_expiry_date)) 
                        >= TRUNC(p_eff_date)
                   AND NVL(a.back_stat,5) = 2
                   AND EXISTS (SELECT '1'
                                 FROM GIPI_ITEM b
                                WHERE b.item_no = p_item_no
                                  AND a.policy_id = b.policy_id)) LOOP
          v_max_endt_seq_no1 := x.endt_seq_no;
          EXIT;
      END LOOP;                                
      --BETH 02192001 latest amount for item should be retrieved from the latest endt record
      --     (depending on PAR eff_date).For policy w/out endt. yet then amounts will be the 
      --     amount of policy. For policy with short term endt. amount should be recomputed by 
      --     adding all amounts of policy and endt. that is not yet reversed
      
      expired_sw := 'N';
      
      -- check for the existance of short-term endt
      FOR SW IN ( SELECT '1'
                    FROM GIPI_ITMPERIL A,
                         GIPI_POLBASIC B
                   WHERE B.line_cd      =  p_line_cd
                     AND B.subline_cd   =  p_subline_cd
                     AND B.iss_cd       =  p_iss_cd
                     AND B.issue_yy     =  p_issue_yy
                     AND B.pol_seq_no   =  p_pol_seq_no
                     AND B.renew_no     =  p_renew_no
                     AND B.policy_id    =  A.policy_id
                     -- lian 111501 added pol_flag = 'X'
                     AND B.pol_flag     in('1','2','3','X')
                     AND (A.prem_amt <> 0 OR  A.tsi_amt <> 0) 
                     AND A.item_no = p_item_no
                     AND TRUNC(B.eff_date) <= DECODE(nvl(b.endt_seq_no,0),0,TRUNC(b.eff_date), TRUNC(p_eff_date))
                     AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
                         v_expiry_date, b.expiry_date,b.endt_expiry_date)) < TRUNC(p_eff_date)
                ORDER BY B.eff_date DESC)
      LOOP
        expired_sw := 'Y';
        EXIT;
      END LOOP;
      
      amt_sw := 'N';
      
      IF expired_sw = 'N' THEN
           --get amount from the latest endt
           FOR ENDT IN (SELECT a.ann_tsi_amt, a.ann_prem_amt
                        FROM GIPI_ITEM a,
                             GIPI_POLBASIC b
                       WHERE B.line_cd      =  p_line_cd
                         AND B.subline_cd   =  p_subline_cd
                         AND B.iss_cd       =  p_iss_cd
                         AND B.issue_yy     =  p_issue_yy
                         AND B.pol_seq_no   =  p_pol_seq_no
                         AND B.renew_no     =  p_renew_no
                         AND B.policy_id    =  A.policy_id
                         -- lian 111501 added pol_flag = 'X'
                         AND B.pol_flag     in('1','2','3','X')                      
                         AND A.item_no = p_item_no
                         AND TRUNC(B.eff_date)    <=  TRUNC(p_eff_date)
                         AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
                             v_expiry_date, b.expiry_date,b.endt_expiry_date)) < TRUNC(p_eff_date)
                         AND NVL(b.endt_seq_no, 0) > 0  -- to query records from endt. only
                    ORDER BY B.eff_date DESC)
         LOOP
              b480.ann_tsi_amt := endt.ann_tsi_amt;
              b480.ann_prem_amt:= endt.ann_prem_amt; 
              amt_sw := 'Y';
           EXIT;
         END LOOP;
         --no endt. records found, retrieved amounts from the policy
         IF amt_sw = 'N' THEN
               FOR POL IN (SELECT a.ann_tsi_amt, a.ann_prem_amt
                        FROM GIPI_ITEM a,
                             GIPI_POLBASIC b
                       WHERE B.line_cd      =  p_line_cd
                         AND B.subline_cd   =  p_subline_cd
                         AND B.iss_cd       =  p_iss_cd
                         AND B.issue_yy     =  p_issue_yy
                         AND B.pol_seq_no   =  p_pol_seq_no
                         AND B.renew_no     =  p_renew_no
                         AND B.policy_id    =  A.policy_id
                         -- lian 111501 added pol_flag = 'X'
                         AND B.pol_flag     in('1','2','3','X')                      
                         AND A.item_no = p_item_no
                         AND NVL(b.endt_seq_no, 0) = 0)
            LOOP
                 b480.ann_tsi_amt := pol.ann_tsi_amt;
                 b480.ann_prem_amt:= pol.ann_prem_amt; 
              EXIT;
            END LOOP;
         END IF;   
      ELSE   
          EXTRACT_ANN_AMT2(p_line_cd, p_subline_cd, p_iss_cd,  p_issue_yy, p_pol_seq_no, 
                           p_renew_no, p_eff_date,  p_item_no, b480.ann_prem_amt,  b480.ann_tsi_amt);
      END IF;  
      IF v_max_endt_seq_no = v_max_endt_seq_no1 THEN                                     
       FOR D1 IN D LOOP
         FOR B1 IN B(D1.policy_id) LOOP
               
           IF v_eff_date  IS NULL THEN
             v_eff_date  :=  D1.eff_date;
             b480.group_cd        :=  B1.group_cd;
             b480.from_date       :=  B1.from_date;
             b480.to_date         :=  B1.to_date;
             v_new_item           := 'N';
           END IF;
           IF D1.eff_date > v_eff_date THEN
             v_eff_date  :=  D1.eff_date;
             b480.group_cd     :=  B1.group_cd;             
             b480.from_date    :=  B1.from_date;
             b480.to_date      :=  B1.to_date;
             v_new_item        := 'N';
           END IF;
         END LOOP;
         EXIT;
       END LOOP;     
     ELSE
       FOR A1 IN A LOOP
         FOR B1 IN B(A1.policy_id) LOOP
               
           IF v_eff_date  IS NULL THEN
             v_eff_date  :=  A1.eff_date;
             b480.group_cd        :=  B1.group_cd;
             b480.from_date       :=  B1.from_date;
             b480.to_date         :=  B1.to_date;
             v_new_item           := 'N';
           END IF;
           IF A1.eff_date > v_eff_date THEN
             v_eff_date  :=  A1.eff_date;
             b480.group_cd     :=  B1.group_cd;
             b480.from_date    :=  B1.from_date;
             b480.to_date      :=  B1.to_date;
             v_new_item        := 'N';
           END IF;
         END LOOP;
         EXIT;
        END LOOP;     
       END IF;   

       IF v_new_item = 'Y' THEN
          b480.rec_flag       := 'A';
          b480.ann_tsi_amt    := NULL;
          b480.ann_prem_amt   := NULL;
          b480.group_cd       := NULL;
       ELSE
          b480.rec_flag   := 'C';
       END IF;
    END;
    
    /*Optimized by Ms. Iris Bordey 08.08.2003*/
    /*This is to display the region_cd and region_desc based on the latest region_cd saved in the policy.
    /*created by: jeanette tan
    /*date created: 01.02.2003
    */
    FOR N IN(SELECT a.region_cd region_cd,b.region_desc region_desc
               FROM GIPI_ITEM a,GIIS_REGION b, GIPI_POLBASIC c
              WHERE 1=1
                --LINK GIPI_ITEM AND GIPI_POLBASIC
                AND a.policy_id            = c.policy_id  
                      --FILTER POLBASIC          
                AND c.line_cd              = p_line_cd
                AND c.subline_cd           = p_subline_cd
                AND NVL(c.iss_cd,c.iss_cd) = p_iss_cd
                AND c.issue_yy             = p_issue_yy
                AND c.pol_seq_no           = p_pol_seq_no
                AND c.renew_no             = p_renew_no             
                AND a.item_no              = p_item_no                 
                AND c.pol_flag IN ('1', '2', '3', 'X')                          
                      --LINK GIIS_REGION AND GIPI_ITEM                  
                AND a.region_cd            = b.region_cd                          
                AND a.region_cd IS NOT NULL             
                      --FILTER OF GIPI_ITEM
                AND NOT EXISTS (SELECT a.region_cd region_cd
                                  FROM GIPI_ITEM E, GIPI_POLBASIC d
                                 WHERE d.line_cd        = p_line_cd
                                   AND d.subline_cd     = p_subline_cd
                                   AND NVL(d.iss_cd,d.iss_cd) = p_iss_cd
                                   AND d.issue_yy             = p_issue_yy
                                   AND d.pol_seq_no           = p_pol_seq_no
                                   AND d.renew_no             = p_renew_no
                                   AND E.item_no              = p_item_no 
                                   AND e.policy_id            = d.policy_id
                                   AND E.region_cd IS NOT NULL
                                   AND d.pol_flag IN ('1', '2', '3', 'X')                                
                                   AND NVL(d.back_stat,5)     = 2                                                    
                                   AND D.endt_seq_no > C.endt_seq_no)                  
                      ORDER BY c.eff_date DESC)
    LOOP
           b480.region_cd := n.region_cd;
           EXIT;
    END LOOP;      
    --to add the other info in gipi_witem
    UPDATE GIPI_WITEM
       SET rec_flag     = b480.rec_flag,
           ann_tsi_amt  = b480.ann_tsi_amt,
           ann_prem_amt = b480.ann_prem_amt,
           from_date    = b480.from_date,
           to_date      = b480.to_date,
           group_cd     = b480.group_cd,                   
           region_cd    = b480.region_cd
     WHERE par_id = p_par_id
       AND item_no = p_item_no;                                         
            
END;
/


