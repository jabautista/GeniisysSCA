DROP PROCEDURE CPI.GIPIS039_B540VALIDATE_ITEM;

CREATE OR REPLACE PROCEDURE CPI.GIPIS039_B540VALIDATE_ITEM (p_par_id GIPI_WPOLBAS.par_id%TYPE,
                                                            p_item_no GIPI_WITEM.item_no%TYPE,
                                                            p_back_endt VARCHAR2,
                                                            p_endt_item_details OUT gipis039_ref_cursor_pkg.rc_endt_fi_item,
                                                            p_message OUT VARCHAR2)
AS  
  v_line_cd GIPI_WPOLBAS.line_cd%TYPE;
  v_subline_cd GIPI_WPOLBAS.subline_cd%TYPE;
  v_iss_cd GIPI_WPOLBAS.iss_cd%TYPE;
  v_issue_yy GIPI_WPOLBAS.issue_yy%TYPE;
  v_pol_seq_no GIPI_WPOLBAS.pol_seq_no%TYPE;
  v_renew_no GIPI_WPOLBAS.renew_no%TYPE;
  v_eff_date GIPI_WPOLBAS.eff_date%TYPE;
  v_expiry_date GIPI_WPOLBAS.expiry_date%TYPE;
  v_expiry_date1 gipi_wpolbas.expiry_date%TYPE := extract_expiry(p_par_id);
  
  -- original variables
  v_new_item           VARCHAR2(1) := 'Y';
  expired_sw           VARCHAR2(1) := 'N';
  amt_sw               VARCHAR2(1) := 'N';
  v_max_endt_seq_no    gipi_polbasic.endt_seq_no%TYPE; 
  v_max_endt_seq_no1   gipi_polbasic.endt_seq_no%TYPE;   
    
  b240assd_no      gipi_parlist.assd_no%TYPE;
  b480ann_tsi_amt  GIPI_WITEM.ann_tsi_amt%TYPE;
  b480ann_prem_amt GIPI_WITEM.ann_prem_amt%TYPE;
  b480rec_flag     GIPI_WITEM.rec_flag%TYPE;
  b480item_title   GIPI_WITEM.item_title%TYPE;
  b480currency_cd  GIPI_WITEM.currency_cd%TYPE;
  b480currency_rt  GIPI_WITEM.currency_rt%TYPE;
  b480coverage_cd  GIPI_WITEM.coverage_cd%TYPE;
  b480group_cd     GIPI_WITEM.group_cd%TYPE;
  b480risk_no      GIPI_WITEM.risk_no%TYPE;
  b480risk_item_no GIPI_WITEM.risk_item_no%TYPE;  
  b480dsp_coverage_desc GIIS_COVERAGE.coverage_desc%TYPE;
  b480dsp_group_desc    GIIS_GROUP.group_desc%TYPE;
  b480dsp_currency_desc GIIS_CURRENCY.currency_desc%TYPE;
  b480region_cd     GIPI_WITEM.region_cd%TYPE;
  b480dsp_region_desc GIIS_REGION.region_desc%TYPE;
  b480item_desc     GIPI_WITEM.item_desc%TYPE;
  b480other_info    GIPI_WITEM.other_info%TYPE;
  
  b370item_no           GIPI_WFIREITM.item_no%TYPE;
  b370block_no          GIPI_WFIREITM.block_no%TYPE;
  b370district_no       GIPI_WFIREITM.district_no%TYPE;
  b370block_id          GIPI_WFIREITM.block_id%TYPE;
  b370risk_cd           GIPI_WFIREITM.risk_cd%TYPE;
  b370nbt_risk_desc     giis_risks.risk_desc%TYPE;
  b370province_cd       GIIS_PROVINCE.province_cd%TYPE;
  b370dsp_province      GIIS_PROVINCE.province_desc%TYPE;
  b370city_cd           giis_block.city_cd%TYPE;
  b370dsp_city          giis_block.city%TYPE;
  b370eq_zone           GIIS_EQZONE.EQ_ZONE%TYPE;
  b370dsp_eq_desc       GIIS_EQZONE.EQ_DESC%TYPE;
  b370flood_zone        GIIS_FLOOD_ZONE.FLOOD_ZONE%TYPE;
  b370dsp_flood_zone_desc GIIS_FLOOD_ZONE.FLOOD_ZONE_DESC%TYPE;
  b370typhoon_zone      GIIS_TYPHOON_ZONE.TYPHOON_ZONE%TYPE;
  b370dsp_typhoon_zone_desc GIIS_TYPHOON_ZONE.TYPHOON_ZONE_DESC%TYPE;
  b370tariff_zone       GIIS_TARIFF_ZONE.TARIFF_ZONE%TYPE;
  b370dsp_tariff_zone_desc GIIS_TARIFF_ZONE.TARIFF_ZONE_DESC%TYPE;
  b370tarf_cd           GIPI_WFIREITM.TARF_CD%TYPE;  
  b370nbt_from_date     GIPI_WITEM.from_date%TYPE;
  b370nbt_to_date       GIPI_WITEM.TO_DATE%TYPE;
  b370assignee          GIPI_WFIREITM.assignee%TYPE;
  b370fr_item_type       giis_fi_item_type.fr_item_type%TYPE;
  b370dsp_fr_itm_tp_ds  giis_fi_item_type.fr_itm_tp_ds%TYPE;
  b370construction_cd   giis_fire_construction.construction_cd%TYPE;
  b370dsp_construction_desc giis_fire_construction.construction_desc%TYPE;
  b370construction_remarks gipi_fireitem.construction_remarks%TYPE;
  b370loc_risk1         GIPI_WFIREITM.loc_risk1%TYPE;
  b370loc_risk2         GIPI_WFIREITM.loc_risk2%TYPE;
  b370loc_risk3         GIPI_WFIREITM.loc_risk3%TYPE;
  b370front             GIPI_WFIREITM.front%TYPE;
  b370rear              GIPI_WFIREITM.rear%TYPE;
  b370left              GIPI_WFIREITM.LEFT%TYPE;
  b370right             GIPI_WFIREITM.RIGHT%TYPE;
  b370occupancy_cd      giis_fire_occupancy.occupancy_cd%TYPE;
  b370dsp_occupancy_desc giis_fire_occupancy.occupancy_desc%TYPE;
  b370occupancy_remarks GIPI_WFIREITM.occupancy_remarks%TYPE;
  
BEGIN
      SELECT assd_no
        INTO b240assd_no 
        FROM gipi_parlist
       WHERE par_id = p_par_id;    

      SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, eff_date, expiry_date
        INTO v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no, v_eff_date, v_expiry_date
        FROM gipi_wpolbas
       WHERE par_id = p_par_id;

    --ASI 071299 For Backward Endorsement and item that will be changed check first if
    --           particular item had been endorsed during previous endorsement and warn
    --           the user that the item will affect other posted endorsements
    IF p_back_endt = 'Y' THEN        
       FOR pol IN
          (SELECT b250.policy_id
             FROM gipi_polbasic b250
            WHERE b250.line_cd = v_line_cd
              AND b250.subline_cd = v_subline_cd
              AND b250.iss_cd = v_iss_cd
              AND b250.issue_yy = v_issue_yy
              AND b250.pol_seq_no = v_pol_seq_no
              AND b250.renew_no = v_renew_no
              AND TRUNC(b250.eff_date) > TRUNC(v_eff_date)
              AND b250.endt_seq_no > 0     
              AND b250.pol_flag     in('1','2','3','X')
              AND TRUNC(DECODE(NVL(b250.endt_expiry_date, b250.expiry_date),
                    b250.expiry_date,v_expiry_date,b250.endt_expiry_date)) 
                      >= v_eff_date
              AND EXISTS (SELECT '1'
                            FROM gipi_item b340
                           WHERE b340.item_no = p_item_no
                             AND b340.policy_id = b250.policy_id)
           ORDER BY   B250.eff_date desc
      )LOOP

           p_message := 'This is a backward endorsement, any changes made in this item will affect '||
                        'all previous endorsement that has an effectivity date later than ' || to_char(v_eff_date,'fmMonth DD, YYYY');
           EXIT;
      END LOOP; 
    END IF;

    DECLARE
    /*  Added for validation of existing or non-existing items */
    /*  in the original policy.                                */
       CURSOR A IS
           SELECT    a.policy_id
             FROM    gipi_polbasic a
            WHERE    a.line_cd     =  v_line_cd
              AND    a.iss_cd      =  v_iss_cd
              AND    a.subline_cd  =  v_subline_cd
              AND    a.issue_yy    =  v_issue_yy
              AND    a.pol_seq_no  =  v_pol_seq_no
              AND    a.renew_no    =  v_renew_no
              AND    a.pol_flag    IN( '1','2','3','X')
              AND    TRUNC(a.eff_date)   <= DECODE(nvl(a.endt_seq_no,0),0,TRUNC(a.eff_date), TRUNC(v_eff_date))
              AND    TRUNC(DECODE(NVL(a.endt_expiry_date, a.expiry_date),
                        a.expiry_date,v_expiry_date,a.endt_expiry_date)) 
                        >= TRUNC(v_eff_date)
              AND    EXISTS (SELECT '1'
                               FROM gipi_item b
                              WHERE b.item_no = p_item_no
                                AND a.policy_id = b.policy_id)      
         ORDER BY   eff_date DESC;

        CURSOR B(p_policy_id  gipi_item.policy_id%TYPE) IS
           SELECT    currency_cd,
                     currency_rt,
                     item_title,
                     ann_tsi_amt,
                     ann_prem_amt,
                     coverage_cd,
                     group_cd,
                     risk_no, --issa@fpac 05.31.2006
                     risk_item_no, --issa@fpac 05.31.2006
                     policy_id --issa@fpac 05.31.2006
             FROM    gipi_item
            WHERE    item_no   =    p_item_no
              AND    policy_id =    p_policy_id;

        CURSOR C(p_currency_cd giis_currency.main_currency_cd%TYPE) IS
           SELECT    currency_desc
             FROM    giis_currency
            WHERE    main_currency_cd  =  p_currency_cd;

    /* August 26, 1998           */
    /* Added by Marivic          */
    /* Cursor D is used to retrieve all information of the policy     */
    /* upon entering the item number                                */
        CURSOR D(p_policy_id gipi_polbasic.policy_id%TYPE) IS
           SELECT item_no,district_no,eq_zone,tarf_cd,block_no,block_id,fr_item_type
               ,loc_risk1,loc_risk2,loc_risk3,tariff_zone,typhoon_zone,construction_cd
               ,construction_remarks,front,right,left,rear,occupancy_cd,occupancy_remarks
               ,flood_zone,risk_cd
             FROM gipi_fireitem
            WHERE policy_id = p_policy_id
              AND item_no = p_item_no;
       
         CURSOR E IS
           SELECT    a.policy_id
             FROM    gipi_polbasic a
            WHERE    a.line_cd     =  v_line_cd
              AND    a.iss_cd      =  v_iss_cd
              AND    a.subline_cd  =  v_subline_cd
              AND    a.issue_yy    =  v_issue_yy
              AND    a.pol_seq_no  =  v_pol_seq_no
              AND    a.renew_no    =  v_renew_no
              AND    a.pol_flag    IN( '1','2','3','X')
              AND    TRUNC(a.eff_date) <= DECODE(nvl(a.endt_seq_no,0),0,TRUNC(a.eff_date), TRUNC(v_eff_date))
              AND    TRUNC(DECODE(NVL(a.endt_expiry_date, a.expiry_date),
                        a.expiry_date,v_expiry_date,a.endt_expiry_date)) 
                        >= TRUNC(v_eff_date)
              AND    NVL(a.back_stat,5) = 2
              AND    EXISTS (SELECT '1'
                               FROM gipi_item b
                              WHERE b.item_no = p_item_no
                                AND a.policy_id = b.policy_id)      
              AND    a.endt_seq_no = (SELECT MAX(endt_seq_no)
                                        FROM gipi_polbasic c
                                       WHERE line_cd     =  v_line_cd
                                         AND iss_cd      =  v_iss_cd
                                         AND subline_cd  =  v_subline_cd
                                         AND issue_yy    =  v_issue_yy
                                         AND pol_seq_no  =  v_pol_seq_no
                                         AND renew_no    =  v_renew_no
                                         AND pol_flag  IN( '1','2','3','X')
                                         AND TRUNC(eff_date) <= DECODE(nvl(c.endt_seq_no,0),0,TRUNC(c.eff_date), TRUNC(v_eff_date))
                                         AND TRUNC(DECODE(NVL(c.endt_expiry_date, c.expiry_date),
                                              c.expiry_date,v_expiry_date,c.endt_expiry_date)) 
                                              >= TRUNC(v_eff_date)
                                         AND NVL(c.back_stat,5) = 2
                                         AND EXISTS (SELECT '1'
                                                       FROM gipi_item d
                                                      WHERE d.item_no = p_item_no
                                                        AND c.policy_id = d.policy_id))                        
         ORDER BY   eff_date desc;
     
    BEGIN
        FOR Z IN (SELECT MAX(endt_seq_no) endt_seq_no
                  FROM gipi_polbasic a
                 WHERE line_cd     =  v_line_cd
                   AND iss_cd      =  v_iss_cd
                   AND subline_cd  =  v_subline_cd
                   AND issue_yy    =  v_issue_yy
                   AND pol_seq_no  =  v_pol_seq_no
                   AND renew_no    =  v_renew_no
                   AND pol_flag  IN( '1','2','3','X')
                   AND TRUNC(eff_date) <= DECODE(nvl(a.endt_seq_no,0),0,TRUNC(a.eff_date), TRUNC(v_eff_date))
                   AND TRUNC(DECODE(NVL(a.endt_expiry_date, a.expiry_date),
                        a.expiry_date,v_expiry_date,a.endt_expiry_date)) 
                        >= TRUNC(v_eff_date)
                   AND EXISTS (SELECT '1'
                                 FROM gipi_item b
                                WHERE b.item_no = p_item_no
                                  AND a.policy_id = b.policy_id)) LOOP
          v_max_endt_seq_no := z.endt_seq_no;
          EXIT;
      END LOOP;                                
      FOR X IN (SELECT MAX(endt_seq_no) endt_seq_no
                  FROM gipi_polbasic a
                 WHERE line_cd     =  v_line_cd
                   AND iss_cd      =  v_iss_cd
                   AND subline_cd  =  v_subline_cd
                   AND issue_yy    =  v_issue_yy
                   AND pol_seq_no  =  v_pol_seq_no
                   AND renew_no    =  v_renew_no
                   AND pol_flag  IN( '1','2','3','X')
                   AND TRUNC(eff_date) <= TRUNC(v_eff_date)
                   AND TRUNC(DECODE(NVL(a.endt_expiry_date, a.expiry_date),
                        a.expiry_date,v_expiry_date,a.endt_expiry_date)) 
                        >= TRUNC(v_eff_date)
                   AND NVL(a.back_stat,5) = 2
                   AND EXISTS (SELECT '1'
                                 FROM gipi_item b
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
                   WHERE B.line_cd      =  v_line_cd
                     AND B.subline_cd   =  v_subline_cd
                     AND B.iss_cd       =  v_iss_cd
                     AND B.issue_yy     =  v_issue_yy
                     AND B.pol_seq_no   =  v_pol_seq_no
                     AND B.renew_no     =  v_renew_no
                     AND B.policy_id    =  A.policy_id
                     AND B.pol_flag     in('1','2','3','X')
                     AND (A.prem_amt <> 0 OR  A.tsi_amt <> 0) 
                     AND A.item_no = p_item_no
                     AND TRUNC(B.eff_date) <= DECODE(nvl(b.endt_seq_no,0),0,TRUNC(b.eff_date), TRUNC(v_eff_date))
                     AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
                        v_expiry_date1, b.expiry_date, b.endt_expiry_date)) >= TRUNC(v_eff_date)
                ORDER BY B.eff_date DESC)
      LOOP
        expired_sw := 'Y';
        EXIT;
      END LOOP;
      amt_sw := 'N';
      IF expired_sw = 'N' THEN
           --get amount from the latest endt
           FOR ENDT IN (SELECT a.ann_tsi_amt, a.ann_prem_amt
                        FROM gipi_item a,
                             gipi_polbasic b
                       WHERE B.line_cd      =  v_line_cd
                         AND B.subline_cd   =  v_subline_cd
                         AND B.iss_cd       =  v_iss_cd
                         AND B.issue_yy     =  v_issue_yy
                         AND B.pol_seq_no   =  v_pol_seq_no
                         AND B.renew_no     =  v_renew_no
                         AND B.policy_id    =  A.policy_id
                         AND B.pol_flag     in('1','2','3','X')                      
                         AND A.item_no = p_item_no
                         AND TRUNC(B.eff_date)    <=  TRUNC(v_eff_date)
                         AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
                             v_expiry_date1, b.expiry_date,b.endt_expiry_date)) >= TRUNC(v_eff_date)
                         AND NVL(b.endt_seq_no, 0) > 0  -- to query records from endt. only
                    ORDER BY B.eff_date DESC)
         LOOP
           b480ann_tsi_amt := endt.ann_tsi_amt;
           b480ann_prem_amt:= endt.ann_prem_amt; 
           amt_sw := 'Y';
           EXIT;
         END LOOP;
         --no endt. records found, retrieved amounts from the policy
         IF amt_sw = 'N' THEN
               FOR POL IN (SELECT a.ann_tsi_amt, a.ann_prem_amt
                        FROM gipi_item a,
                             gipi_polbasic b
                       WHERE B.line_cd      =  v_line_cd
                         AND B.subline_cd   =  v_subline_cd
                         AND B.iss_cd       =  v_iss_cd
                         AND B.issue_yy     =  v_issue_yy
                         AND B.pol_seq_no   =  v_pol_seq_no
                         AND B.renew_no     =  v_renew_no
                         AND B.policy_id    =  A.policy_id
                         AND B.pol_flag     in('1','2','3','X')                      
                         AND A.item_no = p_item_no
                         AND NVL(b.endt_seq_no, 0) = 0)
            LOOP
              b480ann_tsi_amt := pol.ann_tsi_amt;
              b480ann_prem_amt:= pol.ann_prem_amt; 
              EXIT;
            END LOOP;
         END IF;   
      ELSE   
         EXTRACT_ANN_AMT2(v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no, v_eff_date, p_item_no, b480ann_prem_amt,  b480ann_tsi_amt);
      END IF;
      
      IF v_max_endt_seq_no = v_max_endt_seq_no1 THEN                                      
         FOR E1 IN E LOOP
           FOR B1 IN B(E1.policy_id) LOOP
               b480rec_flag        := 'C';
               b480item_title      := B1.item_title;
               b480currency_cd     := B1.currency_cd;
               b480currency_rt     := B1.currency_rt;
               b480coverage_cd     := B1.coverage_cd;
               b480group_cd        := B1.group_cd;
               b480risk_no         := b1.risk_no; --issa@fpac 05.31.2006
               b480risk_item_no    := b1.risk_item_no; --issa@fpac 05.31.2006
               FOR A1 IN ( SELECT coverage_desc 
                             FROM giis_coverage
                            WHERE coverage_cd = b480coverage_cd)
               LOOP
                 b480dsp_coverage_desc := a1.coverage_desc;
               END LOOP;  
               --beth 06152000 derive value for group_desc
               FOR A2 IN ( SELECT group_desc 
                             FROM giis_group
                            WHERE group_cd = b480group_cd)
               LOOP
                 b480dsp_group_desc := a2.group_desc;
               END LOOP;  

               FOR C1 IN C(b480currency_cd) LOOP
                 b480dsp_currency_desc  :=  C1.currency_desc;
               END LOOP;
               v_new_item := 'N';
           END LOOP;
           
           IF v_new_item = 'N' then
              FOR D1 IN D(E1.policy_id) LOOP
                 b370item_no := D1.item_no;
                 b370block_no := D1.block_no;
                 b370district_no := D1.district_no;
                 b370block_id := D1.block_id;
                 --added b iris bordey 11.04.2003
                 --to populate risk_cd and risk_desc from previuos records
                 b370risk_cd  := D1.risk_cd;
                 FOR risks IN (SELECT risk_desc
                                 FROM giis_risks
                                WHERE block_id = b370block_id
                                  AND risk_cd  = b370risk_cd)LOOP
                      b370nbt_risk_desc := risks.risk_desc;
                      EXIT;
                 END LOOP;
                 FOR A IN (SELECT a.province_cd, b.province_desc province, a.city_cd, a.city
                             FROM giis_block a, giis_province b
                            WHERE a.province_cd = b.province_cd
                             AND a.block_id = b370block_id) LOOP
                     b370province_cd := a.province_cd;
                     b370dsp_province := a.province;
                     b370city_cd := a.city_cd;
                     b370dsp_city := a.city;             
                     EXIT;
                 END LOOP;    
                             
                 IF D1.EQ_ZONE IS NOT NULL THEN
                     FOR Q IN (SELECT eq_zone, eq_desc
                              FROM GIIS_EQZONE
                            WHERE EQ_ZONE = D1.EQ_ZONE)
                     LOOP
                       b370eq_zone := q.eq_zone;                           
                       B370DSP_EQ_DESC := Q.EQ_DESC;
                     END LOOP;                   
                 END IF; 
                 IF  D1.FLOOD_ZONE IS NOT NULL THEN
                     FOR Q IN (SELECT flood_zone, flood_zone_desc
                              FROM GIIS_FLOOD_ZONE
                            WHERE FLOOD_ZONE = D1.FLOOD_ZONE)
                     LOOP                           
                         b370flood_zone := q.flood_zone;
                         b370dsp_flood_zone_desc := q.flood_zone_desc;
                     END LOOP;                           
                 END IF;
                 IF  D1.TYPHOON_ZONE IS NOT NULL THEN
                     FOR Q IN (SELECT typhoon_zone, typhoon_zone_desc
                              FROM GIIS_TYPHOON_ZONE
                            WHERE TYPHOON_ZONE = D1.TYPHOON_ZONE)
                     LOOP
                        b370typhoon_zone := q.typhoon_zone;                           
                        b370dsp_typhoon_zone_desc := q.typhoon_zone_desc;
                     END LOOP;                           
                 END IF;      
                 IF  D1.TARIFF_ZONE IS NOT NULL THEN
                     FOR Q IN (SELECT tariff_zone, tariff_zone_desc
                              FROM GIIS_TARIFF_ZONE
                            WHERE TARIFF_ZONE = D1.TARIFF_ZONE)
                     LOOP
                         b370tariff_zone := q.tariff_zone;                           
                         b370dsp_tariff_zone_desc := q.tariff_zone_desc;
                     END LOOP;                           
                 END IF;      
                 IF  D1.TARF_CD IS NOT NULL THEN
                         B370TARF_CD := D1.TARF_CD;
                 END IF;      
              END LOOP;
           END IF;
           EXIT;
         END LOOP;
      ELSE   
         FOR A1 IN A LOOP
           FOR B1 IN B(A1.policy_id) LOOP
               b480rec_flag    := 'C';
               b480item_title  := B1.item_title;
               b480currency_cd := B1.currency_cd;
               b480currency_rt := B1.currency_rt;
               b480coverage_cd := B1.coverage_cd;
               b480group_cd    := B1.group_cd;
               b480risk_no             := b1.risk_no; --issa@fpac 05.31.2006
               b480risk_item_no    := b1.risk_item_no; --issa@fpac 05.31.2006
               FOR A1 IN ( SELECT coverage_desc 
                             FROM giis_coverage
                            WHERE coverage_cd = b480coverage_cd)
               LOOP
                 b480dsp_coverage_desc := a1.coverage_desc;
               END LOOP;  
               --beth 06152000 derive value for group_desc
               FOR A2 IN ( SELECT group_desc 
                             FROM giis_group
                            WHERE group_cd = b480group_cd)
               LOOP
                 b480dsp_group_desc := a2.group_desc;
               END LOOP;  

               FOR C1 IN C(b480currency_cd) LOOP
                 b480dsp_currency_desc  :=  C1.currency_desc;
               END LOOP;
               v_new_item := 'N';
           END LOOP;
           
           IF v_new_item = 'N' then
                
              FOR D1 IN D(A1.policy_id) LOOP
                 b370item_no := D1.item_no;
                 b370block_no := D1.block_no;
                 b370district_no := D1.district_no;
                 b370block_id := D1.block_id;
                 b370eq_zone := d1.eq_zone;
                 --added b iris bordey 11.04.2003
                 --to populate risk_cd and risk_desc from previuos records
                 b370risk_cd  := D1.risk_cd;
                 FOR risks IN (SELECT risk_desc
                                 FROM giis_risks
                                WHERE block_id = b370block_id
                                  AND risk_cd  = b370risk_cd)LOOP
                      b370nbt_risk_desc := risks.risk_desc;
                      EXIT;
                 END LOOP;
                 FOR A IN (SELECT a.province_cd, b.province_desc province, a.city_cd, a.city
                             FROM giis_block a, giis_province b
                            WHERE a.province_cd = b.province_cd
                             AND a.block_id = b370block_id) LOOP
                     b370province_cd := a.province_cd;
                     b370dsp_province := a.province;
                     b370city_cd := a.city_cd;
                     b370dsp_city := a.city;             
                     EXIT;
                 END LOOP;    
                                
                 IF D1.EQ_ZONE IS NOT NULL THEN
                     FOR Q IN (SELECT eq_zone, EQ_DESC
                              FROM GIIS_EQZONE
                            WHERE EQ_ZONE = D1.EQ_ZONE)
                     LOOP
                        b370eq_zone := q.eq_zone;                           
                        b370dsp_eq_desc := q.eq_desc;
                     END LOOP;                   
                 END IF; 
                 IF  D1.FLOOD_ZONE IS NOT NULL THEN
                     FOR Q IN (SELECT flood_zone, flood_zone_desc
                              FROM GIIS_FLOOD_ZONE
                            WHERE FLOOD_ZONE = D1.FLOOD_ZONE)
                     LOOP                           
                        b370flood_zone := q.flood_zone;
                        b370dsp_flood_zone_desc := q.flood_zone_desc;
                     END LOOP;                           
                 END IF;
                 IF  D1.TYPHOON_ZONE IS NOT NULL THEN
                        FOR Q IN (SELECT typhoon_zone, typhoon_zone_desc
                              FROM GIIS_TYPHOON_ZONE
                            WHERE TYPHOON_ZONE = D1.TYPHOON_ZONE)
                     LOOP
                        b370typhoon_zone := q.typhoon_zone;                           
                        b370dsp_typhoon_zone_desc := q.typhoon_zone_desc;
                     END LOOP;                           
                 END IF;   
                 IF  D1.TARIFF_ZONE IS NOT NULL THEN
                     FOR Q IN (SELECT tariff_zone, tariff_zone_desc
                              FROM GIIS_TARIFF_ZONE
                            WHERE TARIFF_ZONE = D1.TARIFF_ZONE)
                     LOOP                           
                        b370tariff_zone := q.tariff_zone;
                        b370dsp_tariff_zone_desc := q.tariff_zone_desc;
                     END LOOP;                           
                 END IF;      
                 IF  D1.TARF_CD IS NOT NULL THEN
                         B370TARF_CD := D1.TARF_CD;
                 END IF;      
                 
              END LOOP;
           END IF;
           EXIT;
         END LOOP;
      END IF;  
      
        IF v_new_item = 'Y' THEN
           b480rec_flag                 := 'A';
           b480item_title               := NULL;
           b480ann_tsi_amt              := NULL;
           b480ann_prem_amt             := NULL;
           b370block_no                 := NULL;
           b370district_no              := NULL;
           b370block_id                 := NULL;
           b370province_cd              := NULL;
           b370dsp_province             := NULL;
           b370city_cd                  := NULL;
           b370dsp_city                 := NULL;
           b480coverage_cd              := NULL;
           b480dsp_coverage_desc        := NULL;
           b370risk_cd                  := NULL;
           b370nbt_risk_desc            := NULL;
           b480group_cd                 := NULL;
           b480dsp_group_desc           := NULL;
           b480risk_no                  := 1; --issa@fpac 05.31.2006
           b480risk_item_no             := p_item_no; --issa@fpac 05.31.2006
           --beth 11282000 get latest address
           --     for default in location risk
           FOR A IN (SELECT address1, address2, address3
                      FROM gipi_wpolbas
                     WHERE par_id = p_par_id)
           LOOP
               IF a.address1 IS NULL AND a.address2 IS NULL AND a.address3 IS NULL THEN
                   IF v_max_endt_seq_no = v_max_endt_seq_no1 THEN                             
                       FOR B IN (SELECT address1, address2, address3
                                   FROM gipi_polbasic a
                                  WHERE a.line_cd     =  v_line_cd
                                    AND a.iss_cd      =  v_iss_cd
                                    AND a.subline_cd  =  v_subline_cd
                                    AND a.issue_yy    =  v_issue_yy
                                    AND a.pol_seq_no  =  v_pol_seq_no
                                    AND a.renew_no    =  v_renew_no
                                    AND a.pol_flag    IN( '1','2','3','X')
                                    AND TRUNC(a.eff_date) <= DECODE(nvl(a.endt_seq_no,0),0,TRUNC(a.eff_date), TRUNC(v_eff_date))
                                    AND TRUNC(DECODE(NVL(a.endt_expiry_date, a.expiry_date),
                                         a.expiry_date,v_expiry_date,a.endt_expiry_date)) 
                                         >= TRUNC(v_eff_date)
                                    AND NVL(a.back_stat,5) = 2
                                    AND a.endt_seq_no = v_max_endt_seq_no1 
                               ORDER BY   eff_date desc)
                      LOOP         
                         b370loc_risk1 := b.address1;
                         b370loc_risk2 := b.address2;
                         b370loc_risk3 := b.address3;
                        EXIT;
                      END LOOP;
                   END IF;
                   
                   IF b370loc_risk1 IS NULL AND b370loc_risk2 IS NULL AND b370loc_risk3 IS NULL THEN 
                       FOR C IN (SELECT address1, address2, address3
                                  FROM gipi_polbasic a
                                 WHERE line_cd     =  v_line_cd
                                   AND iss_cd      =  v_iss_cd
                                   AND subline_cd  =  v_subline_cd
                                   AND issue_yy    =  v_issue_yy
                                   AND pol_seq_no  =  v_pol_seq_no
                                   AND renew_no    =  v_renew_no
                                   AND pol_flag  IN( '1','2','3','X')
                                   AND TRUNC(eff_date) <= DECODE(nvl(a.endt_seq_no,0),0,TRUNC(a.eff_date), TRUNC(v_eff_date))
                                   AND TRUNC(DECODE(NVL(a.endt_expiry_date, a.expiry_date),
                                         a.expiry_date,v_expiry_date,a.endt_expiry_date)) 
                                         >= TRUNC(v_eff_date)
                                   AND (address1 IS NOT NULL OR 
                                        address2 IS NOT NULL OR
                                        address3 IS NOT NULL)
                              ORDER BY eff_date desc)
                       LOOP           
                         b370loc_risk1 := c.address1;
                         b370loc_risk2 := c.address2;
                         b370loc_risk3 := c.address3;           
                         EXIT;
                       END LOOP;
                   END IF;
               ELSE      
                b370loc_risk1 := a.address1;
                b370loc_risk2 := a.address2;
                b370loc_risk3 := a.address3;           
               END IF;                
               
               IF b370loc_risk1 IS NULL AND b370loc_risk2 IS NULL AND b370loc_risk3 IS NULL THEN 
                    FOR D IN (SELECT mail_addr1, mail_addr2, mail_addr3
                                FROM giis_assured
                               WHERE assd_no = b240assd_no)
                    LOOP
                        b370loc_risk1 := d.mail_addr1;
                        b370loc_risk2 := d.mail_addr2;
                        b370loc_risk3 := d.mail_addr3;           
                        EXIT;
                    END LOOP;
               END IF;                                  
           END LOOP;       
        END IF;
        --SET_ITEM_DETAILS;      
    END;

    /*Optimized select by Ms. Iris Bordey 08.08.2003*/
    /*This is to display the region_cd and region_desc based on the latest region_cd saved in the policy.
    /*created by: jeanette tan
    /*date created: 01.02.2003
    */

    DECLARE
       dtl_sw   VARCHAR2 (1) := 'N';                             
    BEGIN
       FOR n IN
          (SELECT   a.region_cd region_cd, b.region_desc region_desc,
                    a.item_desc, a.other_info, a.from_date, a.TO_DATE,
                    d.assignee, g.fr_item_type, g.fr_itm_tp_ds,
                    f.construction_cd, f.construction_desc,
                    d.construction_remarks, d.loc_risk1, d.loc_risk2,
                    d.loc_risk3,
    -- added columns to retrieve all the item details for all the items that will be endorsed.
                    d.front, d.rear, d.LEFT, d.RIGHT,
                    e.occupancy_cd, e.occupancy_desc, d.occupancy_remarks
               FROM gipi_item a,
                    giis_region b,
                    gipi_polbasic c,
                    gipi_fireitem d,
                    giis_fire_occupancy e,
                    giis_fire_construction f,
                    giis_fi_item_type g            
              WHERE 1 = 1
                --LINK GIPI_ITEM AND GIPI_POLBASIC
                AND a.policy_id = c.policy_id
                --connect gipi_item and gipi_fireitem vin 06.08.2010
                AND a.policy_id = d.policy_id
                AND a.item_no = d.item_no
                -- connect gipi_fireitem to giis_fire_occupancy, giis_fire_construction and giis_fi_item_type
                AND d.occupancy_cd = e.occupancy_cd
                AND d.construction_cd = f.construction_cd
                AND d.fr_item_type = g.fr_item_type
                --FILTER POLBASIC
                AND c.line_cd = v_line_cd
                AND c.subline_cd = v_subline_cd
                AND NVL (c.iss_cd, c.iss_cd) = v_iss_cd
                AND c.issue_yy = v_issue_yy
                AND c.pol_seq_no = v_pol_seq_no
                AND c.renew_no = v_renew_no
                AND a.item_no = p_item_no
                AND d.item_no = p_item_no                       --vin 6.8.2010
                AND c.pol_flag IN ('1', '2', '3', 'X')
                --LINK GIIS_REGION AND GIPI_ITEM
                AND a.region_cd = b.region_cd
                AND a.region_cd IS NOT NULL
                -- for latest effective endorsement
                AND TRUNC (c.eff_date) <= TRUNC (v_eff_date)
                AND TRUNC (DECODE (NVL (c.endt_expiry_date, c.expiry_date),
                                   c.expiry_date, v_expiry_date1,
                                   c.expiry_date, c.endt_expiry_date
                                  )
                          ) >= TRUNC (v_eff_date)
                AND NVL (c.endt_seq_no, 0) > 0
                --FILTER OF GIPI_ITEM
                AND NOT EXISTS (
                       SELECT a.region_cd region_cd
                         FROM gipi_item e, gipi_polbasic d
                        WHERE d.line_cd = v_line_cd
                          AND d.subline_cd = v_subline_cd
                          AND NVL (d.iss_cd, d.iss_cd) = v_iss_cd
                          AND d.issue_yy = v_issue_yy
                          AND d.pol_seq_no = v_pol_seq_no
                          AND d.renew_no = v_renew_no
                          AND e.item_no = p_item_no
                          AND e.policy_id = d.policy_id
                          AND e.region_cd IS NOT NULL
                          AND d.pol_flag IN ('1', '2', '3', 'X')
                          AND NVL (d.back_stat, 5) = 2
                          AND d.endt_seq_no > c.endt_seq_no)
           ORDER BY c.eff_date DESC)
       LOOP
          b480region_cd := n.region_cd;
          b480dsp_region_desc := n.region_desc;
          b480item_desc := n.item_desc;
          b480other_info := n.other_info;
          b370nbt_from_date := n.from_date;
          b370nbt_to_date := n.TO_DATE;
          b370assignee := n.assignee;
          b370fr_item_type := n.fr_item_type;
          b370dsp_fr_itm_tp_ds := n.fr_itm_tp_ds;
          b370construction_cd := n.construction_cd;
          b370dsp_construction_desc := n.construction_desc;
          b370construction_remarks := n.construction_remarks;
          b370loc_risk1 := n.loc_risk1;
          b370loc_risk2 := n.loc_risk2;
          b370loc_risk3 := n.loc_risk3;
          b370front := n.front;
          b370rear := n.rear;
          b370LEFT := n.LEFT;
          b370RIGHT := n.RIGHT;
          b370occupancy_cd := n.occupancy_cd;
          b370dsp_occupancy_desc := n.occupancy_desc;
          b370occupancy_remarks := n.occupancy_remarks;
          dtl_sw := 'Y';
          -- added columns to retrieve all the item details for all the items that will be endorsed.
          EXIT;
       --END IF;
       END LOOP;

       -- If no endt. records found, retrieved records from the policy
       IF dtl_sw = 'N'
       THEN
          FOR n IN
             (SELECT   a.region_cd region_cd, b.region_desc region_desc,
                       a.item_desc, a.other_info, a.from_date, a.TO_DATE,
                       d.assignee, g.fr_item_type, g.fr_itm_tp_ds,
                       f.construction_cd, f.construction_desc,
                       d.construction_remarks, d.loc_risk1, d.loc_risk2,
                       d.loc_risk3,
    -- added columns to retrieve all the item details for all the items that will be endorsed.
                       d.front, d.rear, d.LEFT, d.RIGHT,
                       e.occupancy_cd, e.occupancy_desc, d.occupancy_remarks
                                      -- Start from latest effective endorsement.
                  FROM gipi_item a,
                       giis_region b,
                       gipi_polbasic c,
                       gipi_fireitem d,
                       giis_fire_occupancy e,
                       giis_fire_construction f,
                       giis_fi_item_type g            -- added tables vin 6.8.2010
                 WHERE 1 = 1
                   --LINK GIPI_ITEM AND GIPI_POLBASIC
                   AND a.policy_id = c.policy_id
                   --connect gipi_item and gipi_fireitem vin 06.08.2010
                   AND a.policy_id = d.policy_id
                   AND a.item_no = d.item_no
                   -- connect gipi_fireitem to giis_fire_occupancy, giis_fire_construction and giis_fi_item_type
                   AND d.occupancy_cd = e.occupancy_cd
                   AND d.construction_cd = f.construction_cd
                   AND d.fr_item_type = g.fr_item_type
                   --FILTER POLBASIC
                   AND c.line_cd = v_line_cd
                   AND c.subline_cd = v_subline_cd
                   AND NVL (c.iss_cd, c.iss_cd) = v_iss_cd
                   AND c.issue_yy = v_issue_yy
                   AND c.pol_seq_no = v_pol_seq_no
                   AND c.renew_no = v_renew_no
                   AND a.item_no = p_item_no
                   AND d.item_no = p_item_no                    --vin 6.8.2010
                   AND c.pol_flag IN ('1', '2', '3', 'X')
                   --LINK GIIS_REGION AND GIPI_ITEM
                   AND a.region_cd = b.region_cd
                   AND a.region_cd IS NOT NULL
                   -- vin 6.8.2010
                   AND NVL (c.endt_seq_no, 0) = 0
                   --FILTER OF GIPI_ITEM
                   AND NOT EXISTS (
                          SELECT a.region_cd region_cd
                            FROM gipi_item e, gipi_polbasic d
                           WHERE d.line_cd = v_line_cd
                             AND d.subline_cd = v_subline_cd
                             AND NVL (d.iss_cd, d.iss_cd) = v_iss_cd
                             AND d.issue_yy = v_issue_yy
                             AND d.pol_seq_no = v_pol_seq_no
                             AND d.renew_no = v_renew_no
                             AND e.item_no = p_item_no
                             AND e.policy_id = d.policy_id
                             AND e.region_cd IS NOT NULL
                             AND d.pol_flag IN ('1', '2', '3', 'X')
                             AND NVL (d.back_stat, 5) = 2
                             AND d.endt_seq_no > c.endt_seq_no)
              ORDER BY c.eff_date DESC)
          LOOP
             b480region_cd := n.region_cd;
             b480dsp_region_desc := n.region_desc;
             b480item_desc := n.item_desc;
             b480other_info := n.other_info;
             b370nbt_from_date := n.from_date;
             b370nbt_to_date := n.TO_DATE;
             b370assignee := n.assignee;
             b370fr_item_type := n.fr_item_type;
             b370dsp_fr_itm_tp_ds := n.fr_itm_tp_ds;
             b370construction_cd := n.construction_cd;
             b370dsp_construction_desc := n.construction_desc;
             b370construction_remarks := n.construction_remarks;
             b370loc_risk1 := n.loc_risk1;
             b370loc_risk2 := n.loc_risk2;
             b370loc_risk3 := n.loc_risk3;
             b370front := n.front;
             b370rear := n.rear;
             b370LEFT := n.LEFT;
             b370RIGHT := n.RIGHT;
             b370occupancy_cd := n.occupancy_cd;
             b370dsp_occupancy_desc := n.occupancy_desc;
             b370occupancy_remarks := n.occupancy_remarks;
             dtl_sw := 'Y';
             -- added columns to retrieve all the item details for all the items that will be endorsed.
             EXIT;
          END LOOP;
       END IF;
    END;
    
    OPEN p_endt_item_details FOR
      SELECT p_item_no item_no,             b480item_title item_title,              b480item_desc item_desc,       
             b480other_info other_info,     b480region_cd region_cd,                b480dsp_region_desc region_desc,
             b480ann_tsi_amt ann_tsi_amt,   b480ann_prem_amt ann_prem_amt,          b480rec_flag rec_flag,                       
             b480currency_cd currency_cd,   b480dsp_currency_desc currency_desc,    b480currency_rt currency_rt,   
             b480coverage_cd coverage_cd,   b480group_cd group_cd,                  b480dsp_group_desc group_desc,  
             b480risk_no risk_no,           b480risk_item_no risk_item_no,          b480dsp_coverage_desc coverage_desc,             
             b370assignee assignee,         b370fr_item_type fr_item_type,        b370dsp_fr_itm_tp_ds fr_itm_tp_ds,      
             b370province_cd province_cd,   b370dsp_province province_desc,         b370city_cd city_cd,
             b370dsp_city city,             b370district_no district_no,            b370block_id block_id,             
             b370block_no block_no,         b370risk_cd risk_cd,                    b370nbt_risk_desc risk_desc,                         
             b370eq_zone eq_zone,           b370dsp_eq_desc eq_desc,                b370typhoon_zone typhoon_zone,
             b370dsp_typhoon_zone_desc typhoon_zone_desc, b370flood_zone flood_zone, b370dsp_flood_zone_desc flood_zone_desc,
             b370tariff_zone tariff_zone,   b370dsp_tariff_zone_desc tariff_zone_desc,  b370tarf_cd tarf_cd,                           
             b370nbt_from_date from_date,   b370nbt_to_date to_date,                b370construction_cd construction_cd,                                       
             b370dsp_construction_desc construction_desc,   b370construction_remarks construction_remarks, 
             b370occupancy_cd occupancy_cd, b370dsp_occupancy_desc occupancy_desc,  b370occupancy_remarks occupancy_remarks,
             b370loc_risk1 loc_risk1,       b370loc_risk2 loc_risk2,                b370loc_risk3 loc_risk3, 
             b370front front,               b370rear rear,                          b370LEFT left, 
             b370RIGHT right               
      FROM DUAL;
      
END GIPIS039_B540VALIDATE_ITEM;
/


