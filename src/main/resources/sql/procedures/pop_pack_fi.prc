CREATE OR REPLACE PROCEDURE CPI.POP_PACK_FI (p_pack_par_id  IN  GIPI_PACK_WPOLBAS.pack_par_id%TYPE,
                                             p_assd_no      IN  GIPI_PACK_WPOLBAS.assd_no%TYPE,
                                             p_par_id       IN  GIPI_WITEM.par_id%TYPE,
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
**  Description  : Equivalent to the Program Unit POP_PACK_FI in GIPIS096 module
*/

   v_new_item           VARCHAR2(1) := 'Y';
   expired_sw           VARCHAR2(1) := 'N';
   amt_sw               VARCHAR2(1) := 'N';
   v_max_endt_seq_no    GIPI_POLBASIC.endt_seq_no%TYPE; 
   v_max_endt_seq_no1   GIPI_POLBASIC.endt_seq_no%TYPE; 
   b480                 GIPI_WITEM%ROWTYPE;   
   b370                 GIPI_WFIREITM%ROWTYPE;
   v_expiry_date        DATE;
   
   CURSOR A IS
       SELECT    a.policy_id
         FROM    GIPI_POLBASIC a
        WHERE    a.line_cd     =  p_line_cd
          AND    a.iss_cd      =  p_iss_cd
          AND    a.subline_cd  =  p_subline_cd
          AND    a.issue_yy    =  p_issue_yy
          AND    a.pol_seq_no  =  p_pol_seq_no
          AND    a.renew_no    =  p_renew_no
          -- lian 111501 added pol_flag = 'X'
          AND    a.pol_flag    IN( '1','2','3','X')
          --ASI 081299 add this validation so that data that will be retrieved
          --           is only those from endorsement prior to the current endorsement
          --           this was consider because of the backward endorsement
          AND    TRUNC(a.eff_date)   <= DECODE(nvl(a.endt_seq_no,0),0,TRUNC(a.eff_date), TRUNC(p_eff_date))
          AND    TRUNC(DECODE(NVL(a.endt_expiry_date, a.expiry_date),
                    a.expiry_date, p_expiry_date,a.endt_expiry_date)) 
                    >= TRUNC(p_eff_date)
          AND    EXISTS (SELECT '1'
                           FROM GIPI_ITEM b
                          WHERE b.item_no = p_item_no
                            AND a.policy_id = b.policy_id)      
     ORDER BY   eff_date DESC;
    
    CURSOR B(p_policy_id  GIPI_ITEM.policy_id%TYPE) IS
       SELECT    currency_cd,
                 currency_rt,
                 item_title,
                 ann_tsi_amt,
                 ann_prem_amt,
                 coverage_cd,
                 group_cd,
                 risk_no, 
                 risk_item_no, 
                 policy_id,
                 from_date, --benjo 01.17.2017 SR-5907
                 to_date    --benjo 01.17.2017 SR-5907
         FROM    GIPI_ITEM
        WHERE    item_no   =    p_item_no
          AND    policy_id =    p_policy_id;
    
    CURSOR C(p_currency_cd GIIS_CURRENCY.main_currency_cd%TYPE) IS
       SELECT    currency_desc
         FROM    GIIS_CURRENCY
        WHERE    main_currency_cd  =  p_currency_cd;

/* August 26, 1998           */
/* Added by Marivic          */
/* Cursor D is used to retrieve all information of the policy     */
/* upon entering the item number                                */
    
    CURSOR D(p_policy_id GIPI_POLBASIC.policy_id%TYPE) IS
       SELECT item_no,      district_no, eq_zone,     tarf_cd,     block_no,     block_id,                        
              fr_item_type ,loc_risk1,   loc_risk2,   loc_risk3,   tariff_zone,  typhoon_zone, 
              construction_cd,construction_remarks,   front,       right,        left,   
              rear,         occupancy_cd, occupancy_remarks, flood_zone,risk_cd,
              assignee, latitude, longitude --benjo 01.17.2017 SR-5907
         FROM GIPI_FIREITEM
        WHERE policy_id = p_policy_id
          AND item_no = p_item_no;
   
     CURSOR E IS
       SELECT    a.policy_id
         FROM    GIPI_POLBASIC a
        WHERE    a.line_cd     =  p_line_cd
          AND    a.iss_cd      =  p_iss_cd
          AND    a.subline_cd  =  p_subline_cd
          AND    a.issue_yy    =  p_issue_yy
          AND    a.pol_seq_no  =  p_pol_seq_no
          AND    a.renew_no    =  p_renew_no
          -- lian 111501 added pol_flag = 'X'
          AND    a.pol_flag    IN( '1','2','3','X')
          --ASI 081299 add this validation so that data that will be retrieved
          --           is only those from endorsement prior to the current endorsement
          --           this was consider because of the backward endorsement
          AND    TRUNC(a.eff_date) <= DECODE(NVL(a.endt_seq_no,0),0,TRUNC(a.eff_date), TRUNC(p_eff_date))
          AND    TRUNC(DECODE(NVL(a.endt_expiry_date, a.expiry_date),
                    a.expiry_date, p_expiry_date,a.endt_expiry_date)) 
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
                                     AND TRUNC(eff_date) <= DECODE(nvl(c.endt_seq_no,0),0,TRUNC(c.eff_date), TRUNC(p_eff_date))
                                     AND TRUNC(DECODE(NVL(c.endt_expiry_date, c.expiry_date),
                                          c.expiry_date, p_expiry_date, c.endt_expiry_date)) 
                                          >= TRUNC(p_eff_date)
                                     AND NVL(c.back_stat,5) = 2
                                     AND EXISTS (SELECT '1'
                                                   FROM GIPI_ITEM d
                                                  WHERE d.item_no = p_item_no
                                                    AND c.policy_id = d.policy_id))                        
     ORDER BY   eff_date desc;
    
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
                   -- lian added pol_flag = 'X'
                   AND pol_flag  IN( '1','2','3','X')
                   AND TRUNC(eff_date) <= DECODE(nvl(a.endt_seq_no,0),0,TRUNC(a.eff_date), TRUNC(p_eff_date))
                   AND TRUNC(DECODE(NVL(a.endt_expiry_date, a.expiry_date),
                        a.expiry_date, p_expiry_date,a.endt_expiry_date)) 
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
                   -- lian added pol_flag = 'X'
                   AND pol_flag  IN( '1','2','3','X')
                   AND TRUNC(eff_date) <= TRUNC(p_eff_date)
                   AND TRUNC(DECODE(NVL(a.endt_expiry_date, a.expiry_date),
                        a.expiry_date, p_expiry_date,a.endt_expiry_date)) 
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
                     -- lian added pol_flag = 'X'
                     AND B.pol_flag     in('1','2','3','X')
                     AND (A.prem_amt <> 0 OR  A.tsi_amt <> 0) 
                     AND A.item_no = p_item_no
                     AND TRUNC(B.eff_date) <= DECODE(nvl(b.endt_seq_no,0),0,TRUNC(b.eff_date), TRUNC(p_eff_date)) --Modified by koks(07.15.13)
                     AND TRUNC(DECODE(TRUNC(NVL(b.endt_expiry_date, b.expiry_date)), b.expiry_date,
                        v_expiry_date, b.expiry_date, b.endt_expiry_date)) >= TRUNC(p_eff_date)
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
                         -- lian added pol_flag = 'X'
                         AND B.pol_flag     in('1','2','3','X')                      
                         AND A.item_no = p_item_no
                         AND TRUNC(B.eff_date)    <=  TRUNC(p_eff_date)
                         AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
                             v_expiry_date, b.expiry_date,b.endt_expiry_date)) >= TRUNC(p_eff_date)
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
                         -- lian added pol_flag = 'X'
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
         FOR E1 IN E LOOP
           FOR B1 IN B(E1.policy_id) LOOP
               b480.rec_flag        := 'C';
               b480.coverage_cd     := B1.coverage_cd;
               b480.group_cd        := B1.group_cd;
               b480.risk_no         := b1.risk_no; 
               b480.risk_item_no    := b1.risk_item_no;
               b480.from_date       := B1.from_date; --benjo 01.17.2017 SR-5907
               b480.to_date         := B1.to_date;   --benjo 01.17.2017 SR-5907
               v_new_item := 'N';
           END LOOP;
           
           IF v_new_item = 'N' then
              FOR D1 IN D(E1.policy_id) LOOP
                 b370.item_no := D1.item_no;
                 b370.block_no := D1.block_no;
                 b370.district_no := D1.district_no;
                 b370.block_id := D1.block_id;
                 --added b iris bordey 11.04.2003
                 --to populate risk_cd and risk_desc from previuos records
                 b370.risk_cd  := D1.risk_cd;
                 b370.eq_zone  := d1.eq_zone;
                 b370.flood_zone := d1.flood_zone;
                 b370.typhoon_zone := d1.typhoon_zone;
                 b370.tariff_zone := d1.tariff_zone;
                 IF  D1.TARF_CD IS NOT NULL THEN
                         b370.TARF_CD := D1.TARF_CD;
                 END IF;      
                 /* benjo 01.17.2017 SR-5907 */
                 b370.fr_item_type := D1.fr_item_type;
                 b370.construction_cd := D1.construction_cd;
                 b370.construction_remarks := D1.construction_remarks;
                 b370.front := D1.front;
                 b370.right := D1.right;
                 b370.left := D1.left;
                 b370.rear := D1.rear;
                 b370.loc_risk1 := D1.loc_risk1;
                 b370.loc_risk2 := D1.loc_risk2;
                 b370.loc_risk3 := D1.loc_risk3;
                 b370.occupancy_cd := D1.occupancy_cd;
                 b370.occupancy_remarks := D1.occupancy_remarks;
                 b370.assignee := D1.assignee;
                 b370.latitude := D1.latitude;
                 b370.longitude := D1.longitude;
                 /* end  SR-5907 */
              END LOOP;
           END IF;
           EXIT;
         END LOOP;
      ELSE   
         FOR A1 IN A LOOP
           FOR B1 IN B(A1.policy_id) LOOP
               b480.rec_flag    := 'C';
               b480.coverage_cd := B1.coverage_cd;
               b480.group_cd    := B1.group_cd;
               b480.risk_no     := b1.risk_no; 
               b480.risk_item_no:= b1.risk_item_no;
               b480.from_date   := B1.from_date; --benjo 01.17.2017 SR-5907
               b480.to_date     := B1.to_date;   --benjo 01.17.2017 SR-5907
               v_new_item := 'N';
           END LOOP;
           IF v_new_item = 'N' then
                
              FOR D1 IN D(A1.policy_id) LOOP
                 b370.item_no := D1.item_no;
                 b370.block_no := D1.block_no;
                 b370.district_no := D1.district_no;
                 b370.block_id := D1.block_id;
                 --added b iris bordey 11.04.2003
                 --to populate risk_cd and risk_desc from previuos records
                 b370.risk_cd  := D1.risk_cd;
                 b370.eq_zone  := d1.eq_zone;              
                 b370.flood_zone := d1.flood_zone;
                 b370.typhoon_zone := d1.typhoon_zone;
                 b370.tariff_zone := d1.tariff_zone;
                 IF  D1.TARF_CD IS NOT NULL THEN
                     b370.TARF_CD := D1.TARF_CD;
                 END IF;      
                 /* benjo 01.17.2017 SR-5907 */
                 b370.fr_item_type := D1.fr_item_type;
                 b370.construction_cd := D1.construction_cd;
                 b370.construction_remarks := D1.construction_remarks;
                 b370.front := D1.front;
                 b370.right := D1.right;
                 b370.left := D1.left;
                 b370.rear := D1.rear;
                 b370.loc_risk1 := D1.loc_risk1;
                 b370.loc_risk2 := D1.loc_risk2;
                 b370.loc_risk3 := D1.loc_risk3;
                 b370.occupancy_cd := D1.occupancy_cd;
                 b370.occupancy_remarks := D1.occupancy_remarks;
                 b370.assignee := D1.assignee;
                 b370.latitude := D1.latitude;
                 b370.longitude := D1.longitude;
                 /* end  SR-5907 */
              END LOOP;
           END IF;
           EXIT;
         END LOOP;
      END IF;  
         IF v_new_item = 'Y' THEN
           b480.rec_flag                 := 'A';
           b480.ann_tsi_amt              := NULL;
           b480.ann_prem_amt             := NULL;
           b480.coverage_cd              := NULL;
           b480.group_cd                 := NULL;
           b480.risk_no                  := 1; 
           b480.risk_item_no             := p_item_no;
           b370.block_no                 := NULL;
           b370.district_no              := NULL;
           b370.block_id                 := NULL;
           b370.risk_cd                  := NULL;
           /* benjo 01.17.2017 SR-5907 */
           b480.from_date                := NULL;
           b480.to_date                  := NULL;
           b370.fr_item_type             := NULL;
           b370.construction_cd          := NULL;
           b370.construction_remarks     := NULL;
           b370.front                    := NULL;
           b370.right                    := NULL;
           b370.left                     := NULL;
           b370.rear                     := NULL;
           b370.loc_risk1                := NULL;
           b370.loc_risk2                := NULL;
           b370.loc_risk3                := NULL;
           b370.occupancy_cd             := NULL;
           b370.occupancy_remarks        := NULL;
           b370.assignee                 := NULL;
           b370.latitude                 := NULL;
           b370.longitude                := NULL;
           /* end  SR-5907 */
           
           --beth 11282000 get latest address
           --     for default in location risk
           FOR A IN (SELECT address1, address2, address3
                      FROM GIPI_PACK_WPOLBAS
                     WHERE pack_par_id = p_pack_par_id)
           LOOP
               IF a.address1 IS NULL AND
                  a.address2 IS NULL AND
                  a.address3 IS NULL THEN
                    IF v_max_endt_seq_no = v_max_endt_seq_no1 THEN                             
                       FOR B IN (SELECT address1, address2, address3
                                   FROM GIPI_POLBASIC a
                              WHERE a.line_cd     =  p_line_cd
                                AND a.iss_cd      =  p_iss_cd
                                AND a.subline_cd  =  p_subline_cd
                                AND a.issue_yy    =  p_issue_yy
                                AND a.pol_seq_no  =  p_pol_seq_no
                                AND a.renew_no    =  p_renew_no
                                -- lian added pol_flag = 'X'
                                AND a.pol_flag    IN( '1','2','3','X')
                                AND TRUNC(a.eff_date) <= DECODE(nvl(a.endt_seq_no,0),0,TRUNC(a.eff_date), TRUNC(p_eff_date))
                                AND TRUNC(DECODE(NVL(a.endt_expiry_date, a.expiry_date),
                                     a.expiry_date, p_expiry_date,a.endt_expiry_date)) 
                                     >= TRUNC(p_eff_date)
                                AND NVL(a.back_stat,5) = 2
                                AND a.endt_seq_no = v_max_endt_seq_no1 
                           ORDER BY   eff_date DESC)
                       LOOP         
                         b370.loc_risk1 := b.address1;
                         b370.loc_risk2 := b.address2;
                         b370.loc_risk3 := b.address3;
                         EXIT;
                       END LOOP;
                    END IF;
                    
                    IF b370.loc_risk1 IS NULL AND 
                       b370.loc_risk2 IS NULL AND
                       b370.loc_risk3 IS NULL THEN 
                       FOR C IN (SELECT address1, address2, address3
                              FROM GIPI_POLBASIC a
                             WHERE line_cd     =  p_line_cd
                               AND iss_cd      =  p_iss_cd
                               AND subline_cd  =  p_subline_cd
                               AND issue_yy    =  p_issue_yy
                               AND pol_seq_no  =  p_pol_seq_no
                               AND renew_no    =  p_renew_no
                               -- lian added pol_flag = 'X'
                               AND pol_flag  IN( '1','2','3','X')
                               AND TRUNC(eff_date) <= DECODE(nvl(a.endt_seq_no,0),0,TRUNC(a.eff_date), TRUNC(p_eff_date))
                               AND TRUNC(DECODE(NVL(a.endt_expiry_date, a.expiry_date),
                                     a.expiry_date, p_expiry_date,a.endt_expiry_date)) 
                                     >= TRUNC(p_eff_date)
                               AND (address1 IS NOT NULL OR 
                                    address2 IS NOT NULL OR
                                    address3 IS NOT NULL)
                          ORDER BY eff_date DESC)
                   LOOP           
                     b370.loc_risk1 := c.address1;
                     b370.loc_risk2 := c.address2;
                     b370.loc_risk3 := c.address3;           
                     EXIT;
                   END LOOP;
                    END IF;
               ELSE      
                b370.loc_risk1 := a.address1;
                b370.loc_risk2 := a.address2;
                b370.loc_risk3 := a.address3;           
               END IF;                
               IF b370.loc_risk1 IS NULL AND 
                    b370.loc_risk2 IS NULL AND
                    b370.loc_risk3 IS NULL THEN 
                    FOR D IN (SELECT mail_addr1, mail_addr2, mail_addr3
                                FROM GIIS_ASSURED
                               WHERE assd_no = p_assd_no)
                  LOOP
                    b370.loc_risk1 := d.mail_addr1;
                    b370.loc_risk2 := d.mail_addr2;
                    b370.loc_risk3 := d.mail_addr3;           
                    EXIT;
                  END LOOP;
               END IF;                                  
           END LOOP;       
        END IF;
          
    END;
    
/*Optimized select by Ms. Iris Bordey 08.08.2003*/
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
                                 WHERE d.line_cd            = p_line_cd
                                   AND d.subline_cd           = p_subline_cd
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
           coverage_cd  = b480.coverage_cd,
           group_cd     = b480.group_cd,                   
           risk_no      = b480.risk_no,
           risk_item_no = b480.risk_item_no,
           region_cd    = b480.region_cd,
           from_date    = b480.from_date, --benjo 01.17.2017 SR-5907
           to_date      = b480.to_date    --benjo 01.17.2017 SR-5907
     WHERE par_id       = p_par_id
       AND item_no      = p_item_no;

    --to insert records to gipi_wfireitm   
    /* benjo 01.17.2017 SR-5907 added various columns */
    INSERT INTO GIPI_WFIREITM
    (par_id,     item_no,   block_no,   district_no,   block_id,  
     risk_cd,    tarf_cd,   eq_zone,    flood_zone,    typhoon_zone,    
     tariff_zone,loc_risk1, loc_risk2,  loc_risk3,     fr_item_type,
     construction_cd, construction_remarks, front, right, left, rear,
     occupancy_cd, occupancy_remarks,assignee, latitude, longitude)
    VALUES
    ( p_par_id, p_item_no, b370.block_no, b370.district_no, b370.block_id, 
      b370.risk_cd, b370.tarf_cd, b370.eq_zone, b370.flood_zone, b370.typhoon_zone, 
      b370.tariff_zone, b370.loc_risk1, b370.loc_risk2, b370.loc_risk3, b370.fr_item_type,
      b370.construction_cd, b370.construction_remarks, b370.front, b370.right, b370.left, b370.rear,
      b370.occupancy_cd, b370.occupancy_remarks,b370.assignee, b370.latitude, b370.longitude);                                            
END;
/


