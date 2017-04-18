CREATE OR REPLACE PACKAGE BODY CPI.giex_itmperil_pkg
AS

    /*
    **  Created by       : Robert John Virrey
    **  Date Created     : 02.20.2012
    **  Reference By     : (GIEXS007- Edit Peril Information)
    **  Description      : update_witem program unit
    */
    PROCEDURE update_witem_giexs007(
        p_policy_id       IN    giex_itmperil.policy_id%TYPE,
        p_item_no         IN    giex_itmperil.item_no%TYPE,
        p_recompute_tax   IN    VARCHAR2,
        p_tax_sw          IN    VARCHAR2,
        p_create_peril    IN    VARCHAR2,   --added by joanne 06.03.14
        p_summary_sw      IN    VARCHAR2,   --added by joanne 06.03.14
        p_nbt_prem_amt   OUT    giex_itmperil.prem_amt%TYPE,
        p_ann_prem_amt   OUT    giex_itmperil.ann_prem_amt%TYPE,
        p_nbt_tsi_amt    OUT    giex_itmperil.tsi_amt%TYPE,
        p_ann_tsi_amt    OUT    giex_itmperil.ann_tsi_amt%TYPE
    ) 
    IS
      CURSOR d1 IS --added by bdarusin, 12052002, copied from create_winvoice
        SELECT param_value_n
          FROM giac_parameters
         WHERE param_name = 'DOC_STAMPS';

      CURSOR e1 IS
        SELECT param_value_v
          FROM giis_parameters
         WHERE param_name = 'COMPUTE_OLD_DOC_STAMPS';
        
       CURSOR f1 IS --added by roset, 9/30/2010
        SELECT param_value_v
          FROM giis_parameters
         WHERE param_name = 'COMPUTE_PA_DOC_STAMPS';
         
      v_menu_line               giis_line.menu_line_cd%TYPE;      --roset, 9/30/2010         
      v_param_pa_doc            giis_parameters.param_value_v%TYPE; --added by roset, 9/30/2010   
      v_doc_stamps              giis_tax_charges.tax_cd%TYPE:=0;
      v_param_old_doc           giis_parameters.param_value_v%TYPE:=0;
      v_tax_amount2             giex_new_group_tax.tax_amt%TYPE := 0; --end of added codes, bdarusin, 12052002
      v_tax_amount              giex_new_group_tax.tax_amt%TYPE := 0;
      v_sum_tax_amt             giex_expiry.tax_amt%TYPE := 0;
      v_prem_amt                giex_itmperil.prem_amt%TYPE :=0;
      v_tsi_amt                 giex_itmperil.tsi_amt%TYPE :=0;
      v_exist                   VARCHAR2(1):='N';
      v_peril_sw                giis_tax_peril.peril_sw%TYPE;
      v_peril_prem              giex_itmperil.prem_amt%TYPE :=0;
      v_line_cd                 gipi_polbasic.line_cd%TYPE;
      v_lgt_exist               VARCHAR2(1):='N';
      v_currency_prem_amt       giex_expiry.currency_prem_amt%TYPE:=0;
      v_currency_tax_amt        giex_expiry.tax_amt%TYPE:=0; --giex_expiry.currency_prem_amt%TYPE:=0;
      v_currency_tax_amount     giex_expiry.tax_amt%TYPE:=0; --giex_expiry.currency_prem_amt%TYPE:=0;
      v_currency_peril_prem     giex_expiry.currency_prem_amt%TYPE:=0;
      v_currency_tax_amount2    giex_expiry.tax_amt%TYPE:=0; --giex_expiry.currency_prem_amt%TYPE:=0;
      v_currency_rt             giex_itmperil.currency_rt%TYPE:=1; --joanne 043014 
      v_not_endt                 VARCHAR2(1):='N';   --joanne 060314 
      v_evat_cd                 NUMBER := Giacp.n('EVAT');    --added by Gzelle 01212015 SR3695
      v_vat_tag                 giis_assured.vat_tag%TYPE; --added by Gzelle 01232015 SR3695
      v_pol_vat_amt             gipi_invoice.tax_amt%TYPE;  --added by Gzelle 01262015 SR3695
    BEGIN
      OPEN d1; --added by bdarusin, copied from create_winvoice
      FETCH d1
       INTO v_doc_stamps;
      CLOSE d1;
      
      OPEN e1;
      FETCH e1
       INTO v_param_old_doc;
      CLOSE e1; --end of added codes, bdarusin, 12052002
      
      OPEN f1; --added by roset, 9/30/2010
      FETCH f1
       INTO v_param_pa_doc;
      CLOSE f1;
      
      IF p_recompute_tax = 'N' THEN
          FOR A IN (SELECT  sum(NVL(prem_amt,0)) prem,
                            sum(NVL(ann_prem_amt,0)) ann_prem
                      FROM  giex_itmperil
                     WHERE  policy_id   = p_policy_id
                       AND  item_no     = p_item_no) 
          LOOP
                 p_nbt_prem_amt     :=  A.prem;
                 p_ann_prem_amt     :=  A.ann_prem;
          END LOOP;
      
          FOR B IN (SELECT  sum(NVL(a.tsi_amt,0)) tsi,                        
                            sum(NVL(a.ann_tsi_amt,0)) ann_tsi              
                      FROM  giex_itmperil a,giis_peril b
                     WHERE  a.line_cd    =  b.line_cd
                       AND  a.peril_cd   =  b.peril_cd
                       AND  b.peril_type =  'B'
                       AND  a.policy_id  =  p_policy_id
                       AND  item_no      =  p_item_no ) 
          LOOP
                 p_nbt_tsi_amt     :=  B.tsi;
                 p_ann_tsi_amt     :=  B.ann_tsi;             
          END LOOP;
        /*beth 09112000 insert records in table giex_new_group_peril */
          --DELETE giex_new_group_peril
           --WHERE policy_id = p_policy_id;
          --CLEAR_MESSAGE;
      END IF;
      FOR C IN (SELECT sum(nvl(a.prem_amt,0)) currency_prem_amt,
                       sum(nvl(a.prem_amt,0) * nvl(a.currency_rt,0)) prem_amt,
                       sum(nvl(a.tsi_amt,0) * nvl(a.currency_rt,0)) tsi_amt,                   
                       a.line_cd, a.peril_cd
                  FROM giex_itmperil a, giis_peril b
                 WHERE policy_id    = p_policy_id
                   AND a.peril_cd   = b.peril_cd
                   AND a.line_cd    = b.line_cd               
              GROUP BY a.line_cd, a.peril_cd)
      LOOP      
        v_prem_amt := v_prem_amt + c.prem_amt;
        v_tsi_amt  := v_tsi_amt + c.tsi_amt;
        v_currency_prem_amt := v_currency_prem_amt + c.currency_prem_amt;
        /* Comment by Joanne, insert in this table should be in another proc
        IF p_recompute_tax = 'N' THEN
              INSERT INTO giex_new_group_peril
                         (  policy_id,      line_cd,      peril_cd,     prem_amt,    tsi_amt,   currency_prem_amt)
                   VALUES(p_policy_id,    c.line_cd,    c.peril_cd,   c.prem_amt,  c.tsi_amt, c.currency_prem_amt);
        END IF; */        
      END LOOP;                         
      
      /*UPDATE giex_expiry
         SET ren_tsi_amt  = v_tsi_amt,
             ren_prem_amt = v_prem_amt
       WHERE policy_id = :b240.policy_id;*/

     FOR curr IN (SELECT DISTINCT currency_rt
         FROM giex_itmperil
        WHERE  policy_id   = p_policy_id
        AND  item_no     = NVL(p_item_no, item_no)
     )LOOP
          v_currency_rt := curr.currency_rt;
     END LOOP;   
 
    /*richelle 12062000 insert records in table giex_new_group_tax */

      FOR E IN (SELECT '1' 
                  FROM giex_new_group_tax
                 WHERE policy_id=p_policy_id) 
      LOOP
         v_exist := 'Y';
      END LOOP;
      IF v_exist = 'N' OR p_tax_sw = 'N' THEN
        IF NVL(p_create_peril,'N') = 'Y' THEN --added by joanne, 060314
             DELETE giex_new_group_tax
              WHERE policy_id = p_policy_id;
        END IF; 
           --CLEAR_MESSAGE;
           FOR D IN (SELECT DISTINCT a.line_cd, a.iss_cd, a.tax_cd, a.tax_id, a.tax_desc,--added DISTINCT by Edison05.04.2012
       								/*Modified by Edison04.25.2012, to get the rate of the tax in giis_tax_issue_place
       								**if the policy has an issue place 
       								**NVL (b.rate, 0) rate,*/
       								DECODE (c.place_cd, NULL, b.rate, 
                   				    DECODE( a.line_cd||'-'||a.iss_cd||'-'||a.tax_cd||'-'||a.tax_id||'-'||c.place_cd,
                   							d.line_cd||'-'||d.iss_cd||'-'||d.tax_cd||'-'||d.tax_id||'-'||d.place_cd, d.rate, b.rate ))rate,
       								--end of modification                      
       								a.tax_amt, NVL (b.peril_sw, 'N') peril_sw,
       								a.currency_tax_amt,
                                    b.tax_type, b.tax_amount fixed_amt-- added by joanne 020414, for fixed amount taxes
  							   FROM giex_old_group_tax a, giis_tax_charges b,
  							 		gipi_polbasic c, giis_tax_issue_place d --added by Edison04.25.2012
 							  WHERE a.line_cd = b.line_cd
   								AND a.iss_cd = b.iss_cd
   								AND a.tax_cd = b.tax_cd
   								AND a.tax_id = b.tax_id       --uncommented by gmi to resolve error of PCIC
   								--modified condition by Edison 05.14.2012
   								AND (a.line_cd = d.line_cd (+)                                  
                  		 AND a.iss_cd = d.iss_cd (+)) 
   								AND DECODE(c.place_Cd,NULL,'1',a.iss_cd) = DECODE(c.place_cd,NULL,'1',d.iss_cd)
                  AND DECODE(c.place_Cd,NULL,'1',a.line_cd) = DECODE(c.place_cd,NULL,'1',d.line_cd)
                  AND DECODE(c.place_Cd,NULL,'1',c.place_cd) = DECODE(c.place_cd,NULL,'1',d.place_cd)
                  AND a.policy_id = c.policy_id 
   								--end of modified condition 05.14.2012 
   								AND NVL (b.expired_sw, 'N') != 'Y'
   								AND b.pol_endt_sw IN ('B', 'P')
   								AND (   (    b.eff_start_date <=
                        				(SELECT ADD_MONTHS (NVL (eff_date, incept_date), 12)
                           				 FROM gipi_polbasic
                          			  WHERE policy_id = p_policy_id)
            			AND NVL (b.issue_date_tag, 'N') = 'N')
       					  /*AND b.eff_end_date >= (select ADD_MONTHS(nvl(eff_date,incept_date),12)
                                                                    from gipi_polbasic
                                                           where policy_id = :policy_id)
                                                                and NVL(b.issue_date_tag,'N') = 'N') */
        										OR (    b.eff_start_date <= (SELECT ADD_MONTHS (issue_date, 12)
                                       										 FROM gipi_polbasic
                                      									  WHERE policy_id = p_policy_id)
            									AND NVL (b.issue_date_tag, 'N') = 'Y')
       						/*AND b.eff_end_date >= (select ADD_MONTHS(issue_date,12)
                                             from gipi_polbasic
                                            where policy_id = :policy_id)
                                              and nvl(b.issue_date_tag,'N') = 'Y')*/
       						)
   								AND a.policy_id = p_policy_id)
            loop
              v_peril_sw := D.peril_sw;       
                        /*added by roset menu line cd 9/30/2010*/
            SELECT menu_line_cd
              INTO v_menu_line
              FROM giis_line
             WHERE line_cd = d.line_cd; 

                IF d.tax_type ='A' THEN -- added by joanne, 02.04.14, for fixed amount taxes
                    v_tax_amount        :=  d.fixed_amt;
                    v_currency_tax_amt := d.currency_tax_amt;  --added by joanne 03.27.14, to correct currency_tax     
                ELSE
                    IF v_peril_sw = 'N' THEN                
                       --v_tax_amount              := v_prem_amt * d.rate / 100;
                       v_currency_tax_amt        := v_currency_prem_amt * d.rate / 100; 
                       v_tax_amount              := v_currency_tax_amt * v_currency_rt; --joanne 043014     
                       --raise_application_error(-20000, 'v_currency_prem_amt:::: '||v_currency_prem_amt||
                       --                                 'v_currency_tax_amount::: '||v_currency_tax_amt);         
                       IF d.tax_cd = v_doc_stamps AND v_param_old_doc  = 'Y' THEN --added by bdarusin, copied from create_winvoice
                          IF v_menu_line = 'AC' AND v_param_pa_doc = 2 THEN --added by roset, 9/30/2010
                             --v_tax_amount        := CEIL(v_prem_amt / 200) * (0.5);
                             v_currency_tax_amt  := CEIL((v_currency_prem_amt / 200) * (0.5));
                             v_tax_amount        := v_currency_tax_amt * v_currency_rt; --joanne 043014  
                          ELSE 
                              --v_tax_amount       := CEIL(v_prem_amt / 4) * (0.5);
                              v_currency_tax_amt := CEIL((v_currency_prem_amt / 4) * (0.5));
                              v_tax_amount       := v_currency_tax_amt * v_currency_rt; --joanne 043014  
                          END IF;     
                       END IF;                                                                                                         --end of added codes, bdarusin, 12052002
                    ELSE
                       FOR E IN ( SELECT SUM(NVL(A.prem_amt,0)) prem_amt,
                                         SUM(NVL(A.currency_prem_amt,0)) currency_prem_amt
                                FROM giex_new_group_peril A
                                WHERE A.peril_cd IN (SELECT peril_cd
                                                       FROM giis_tax_peril
                                                      WHERE line_cd = D.line_cd
                                                        AND iss_cd  = D.iss_cd
                                                        AND tax_cd  = D.tax_cd)
                                AND A.policy_id   = p_policy_id
                        GROUP BY A.peril_cd)  
                        LOOP
                             v_peril_prem := v_peril_prem + e.prem_amt;
                             v_currency_peril_prem := v_currency_peril_prem + e.currency_prem_amt;
                        END LOOP;
                        --v_tax_amount        := v_peril_prem * d.rate / 100;
                        v_currency_tax_amt        := v_currency_peril_prem * d.rate / 100;
                        v_tax_amount              := v_currency_tax_amt * v_currency_rt; --joanne 043014  
                          IF d.tax_cd = v_doc_stamps AND v_param_old_doc  = 'Y' THEN --added by bdarusin, copied from create_winvoice
                             IF v_menu_line = 'AC' AND v_param_pa_doc = 2 THEN --added by roset, 9/30/2010
                               --v_tax_amount := CEIL(v_peril_prem / 200) * (0.5);
                               v_currency_tax_amt := CEIL((v_currency_peril_prem / 200) * (0.5));
                               v_tax_amount       := v_currency_tax_amt * v_currency_rt; --joanne 043014  
                             ELSE
                                 --v_tax_amount := CEIL(v_peril_prem / 4) * (0.5);
                                 v_currency_tax_amt := CEIL((v_currency_peril_prem / 4) * (0.5));
                                 v_tax_amount       := v_currency_tax_amt * v_currency_rt; --joanne 043014  
                             END IF;
                          END IF;                                                                                                         --end of added codes, bdarusin, 12052002
                         
                     END IF;
                END IF;   
                
                --added by joanne 06.03.14, to determine taxes added in endt
                FOR x IN(SELECT '1'
                          FROM gipi_polbasic gp, gipi_invoice gi, gipi_inv_tax gt
                         WHERE gp.policy_id = p_policy_id
                           AND gp.policy_id = gi.policy_id
                           AND gi.iss_cd = gt.iss_cd
                           AND gi.prem_seq_no = gt.prem_seq_no
                           AND gt.tax_cd = d.tax_cd)
                           
                LOOP
                    v_not_endt := 'Y';
                END LOOP;
                
                --added by Gzelle 01212015
                FOR v1 IN (SELECT NVL(vat_tag,3) vat_tag
                             FROM giis_assured b,
                                  gipi_polbasic a
                            WHERE b.assd_no = a.assd_no
                              AND a.policy_id = p_policy_id)
                LOOP
                    v_vat_tag := v1.vat_tag;
                END LOOP;
                
                IF d.tax_cd = v_evat_cd
                THEN
                    FOR v2 IN (SELECT gt.tax_cd,gt.tax_id, gt.tax_amt
                                 FROM gipi_polbasic gp, gipi_invoice gi, gipi_inv_tax gt
                                WHERE gp.policy_id = p_policy_id
                                  AND gp.policy_id = gi.policy_id
                                  AND gi.iss_cd = gt.iss_cd
                                  AND gi.prem_seq_no = gt.prem_seq_no
                                  AND gt.tax_cd = d.tax_cd)
                    LOOP
                        v_pol_vat_amt   := v2.tax_amt; 
                    END LOOP;                  
                END IF;              
                --end 01212015
                           
                IF d.rate = 0 THEN
                    IF d.tax_type ='A' THEN -- added by joanne, 02.04.14, for fixed amount taxes
                        v_tax_amount        :=  d.fixed_amt; 
                        v_currency_tax_amount2 := d.currency_tax_amt;  --added by joanne 03.27.14, to correct currency_tax  
                    ELSE
                        v_tax_amount2 := d.tax_amt;
                        v_currency_tax_amount2 := d.currency_tax_amt;
                        IF d.tax_cd = v_doc_stamps AND v_param_old_doc  = 'Y' THEN --added by bdarusin, copied from create_winvoice
                            IF v_menu_line = 'AC' AND v_param_pa_doc = 2 THEN --added by roset, 9/30/2010
                             --v_tax_amount2 := CEIL(v_prem_amt / 200) * (0.5);
                             v_currency_tax_amount2 := CEIL((v_currency_peril_prem / 200) * (0.5));
                             v_tax_amount2          := v_currency_tax_amount2 * v_currency_rt; --joanne 043014  
                            ELSE
                             --v_tax_amount2 := CEIL(v_prem_amt / 4) * (0.5);
                             v_currency_tax_amount2 := CEIL((v_currency_prem_amt / 4) * (0.5));
                             v_tax_amount2          := v_currency_tax_amount2 * v_currency_rt; --joanne 043014  
                            END IF;     
                        END IF;                                                                                                         --end of added codes, bdarusin, 12052002
                    END IF; 
                    
                   --added by joanne 060314, consider summary_sw 
                    IF (p_summary_sw ='N' AND  v_not_endt = 'Y') OR p_summary_sw ='Y' THEN                             
                       
                        --added by Gzelle 01212015 - to consider vat_tag
                        IF d.tax_cd = v_evat_cd 
                        THEN
                           --IF NVL(p_create_peril,'N') = 'N'  --benjo 12.19.2016 SR-5621 comment out
                           --THEN
                                IF v_vat_tag IN (1,2) 
                                THEN
                                    v_tax_amount2 := 0;
                                    v_currency_tax_amount2 := 0;
                                END IF;
                            --ELSE                             --benjo 12.19.2016 SR-5621 comment out
                                --v_tax_amount2 := v_pol_vat_amt;
                                --v_currency_tax_amount2 := v_pol_vat_amt;
                            --END IF; 
                        END IF; 
                        --end 01212015
                        
                        IF v_vat_tag = 1 AND d.tax_cd = v_evat_cd AND NVL(p_create_peril,'N') = 'N'   --condition added by Gzelle 01232015
                        THEN
                            DELETE giex_new_group_tax
                             WHERE policy_id = p_policy_id
                               AND tax_cd = d.tax_cd
                               AND line_cd = d.line_cd
                               AND iss_cd = d.iss_cd
                               AND tax_id = d.tax_id;
                        ELSE             
                            --added by joanne 060314, consider if taxes are for newly created peril OR for modified/deleted/added perils
                            IF NVL(p_create_peril,'N') = 'Y' THEN                                   
                                INSERT INTO giex_new_group_tax
                                            (policy_id, line_cd, iss_cd, tax_cd, tax_id,
                                             tax_desc, tax_amt, rate, currency_tax_amt
                                            )
                                     VALUES (p_policy_id, d.line_cd, d.iss_cd, d.tax_cd, d.tax_id,
                                             d.tax_desc, v_tax_amount2, d.rate, v_currency_tax_amount2
                                            ); --v_tax_amt2 was previously d.tax_amt, bdarusin, 12052002
                            ELSE
                                UPDATE giex_new_group_tax
                                   SET tax_amt = v_tax_amount2,
                                       currency_tax_amt = v_currency_tax_amount2
                                 WHERE policy_id = p_policy_id
                                   AND line_cd = d.line_cd
                                   AND iss_cd = d.iss_cd
                                   AND tax_cd = d.tax_cd;           
                            END IF;
                        END IF;
                    END IF;  
                ELSE 
                    --added by joanne 060314, consider summary_sw 
                    IF (p_summary_sw ='N' AND  v_not_endt = 'Y') OR p_summary_sw ='Y' THEN                       
                       
                        --added by Gzelle 01212015 - to consider vat_tag
                        IF d.tax_cd = v_evat_cd --IF d.tax_cd = 3 --kenneth 06.23.2015 SR 19458
                        THEN
                            --IF NVL(p_create_peril,'N') = 'N'  --benjo 12.19.2016 SR-5621 comment out
                            --THEN
                                IF v_vat_tag IN (1,2) 
                                THEN
                                    v_tax_amount := 0;
                                    v_currency_tax_amt := 0;
                                END IF;
                            --ELSE                              --benjo 12.19.2016 SR-5621 comment out
                                --v_tax_amount := v_pol_vat_amt;
                                --v_currency_tax_amt := v_pol_vat_amt;
                            --END IF; 
                        END IF;  
                        --end 01212015
                        
                        IF v_vat_tag = 1 AND d.tax_cd = v_evat_cd AND p_create_peril <> 'Y'  --condition added by Gzelle 01232015
                        THEN 
                            DELETE giex_new_group_tax
                             WHERE policy_id = p_policy_id
                               AND tax_cd = d.tax_cd
                               AND line_cd = d.line_cd
                               AND iss_cd = d.iss_cd
                               AND tax_id = d.tax_id;
                        ELSE                                  
                            --added by joanne 060314, consider if taxes are for newly created peril OR for modified/deleted/added perils
                            IF NVL(p_create_peril,'N') = 'Y' THEN                      
                                INSERT INTO giex_new_group_tax
                                            (policy_id, line_cd, iss_cd, tax_cd, tax_id,
                                             tax_desc, tax_amt, rate, currency_tax_amt
                                            )
                                     VALUES (p_policy_id, d.line_cd, d.iss_cd, d.tax_cd, d.tax_id,
                                             d.tax_desc, v_tax_amount, d.rate, v_currency_tax_amt
                                            );
                            ELSE
                                UPDATE giex_new_group_tax
                                   SET tax_amt = v_tax_amount,
                                       currency_tax_amt = v_currency_tax_amt
                                 WHERE policy_id = p_policy_id
                                   AND line_cd = d.line_cd
                                   AND iss_cd = d.iss_cd
                                   AND tax_cd = d.tax_cd;           
                            END IF;
                        END IF;                           
                    END IF;  
                END IF;
              V_LINE_CD := D.LINE_CD;
              v_not_endt := 'N'; --joanne 06.03.14
            END LOOP;
            
            IF NVL(p_create_peril,'N') = 'N' THEN
                giex_itmperil_pkg.compute_tax(p_policy_id);
            END IF;
        -- TEMPORARY SOLUTION FOR LGT...
        /*    FOR F IN (SELECT '1'
                                    FROM giex_new_group_tax
                                 WHERE tax_cd = 9
                                   AND policy_id = :b240.policy_id) LOOP
                  v_lgt_exist := 'Y'; 
            EXIT;
            END LOOP;
                                 
        --        IF V_LINE_CD = 'MC' THEN
            IF v_lgt_exist = 'N' THEN
                     V_TAX_AMOUNT := V_PREM_AMT * .0075;
                   INSERT INTO giex_new_group_tax
                         (policy_id,                     line_cd,                 iss_cd,         tax_cd,            tax_id,            
                        tax_desc,                      tax_amt,                rate)
                   VALUES
                     (:b240.policy_id,       v_line_cd,             'HO',         9,                     2, 
                           'LOCAL GOVT TAX',   v_tax_amount,        .75);
                END IF;*/
      END IF;                       
    END;
    
    /*
    **  Created by       : Joanne
    **  Date Created     : 05.02.2014
    **  Description      : insert into table giex_new_group_peril
    */
     PROCEDURE insert_group_peril(
        p_policy_id       IN    giex_itmperil.policy_id%TYPE
    ) 
    IS              
    BEGIN
      DELETE  FROM giex_new_group_peril
        WHERE policy_id= p_policy_id;
        
      FOR C IN (SELECT sum(nvl(a.prem_amt,0)) currency_prem_amt,
                       sum(nvl(a.prem_amt,0) * nvl(a.currency_rt,0)) prem_amt,
                       sum(nvl(a.tsi_amt,0) * nvl(a.currency_rt,0)) tsi_amt,                   
                       a.line_cd, a.peril_cd
                  FROM giex_itmperil a, giis_peril b
                 WHERE policy_id    = p_policy_id
                   AND a.peril_cd   = b.peril_cd
                   AND a.line_cd    = b.line_cd               
              GROUP BY a.line_cd, a.peril_cd)
      LOOP      
          --raise_Application_error(-20001, 'joanne:::: '||p_policy_id);
          INSERT INTO giex_new_group_peril
                     (  policy_id,      line_cd,      peril_cd,     prem_amt,    tsi_amt,   currency_prem_amt)
               VALUES(p_policy_id,    c.line_cd,    c.peril_cd,   c.prem_amt,  c.tsi_amt, c.currency_prem_amt);        
      END LOOP;
    END;
    
    /*
    **  Created by       : Robert John Virrey
    **  Date Created     : 02.20.2012
    **  Reference By     : (GIEXS007- Edit Peril Information)
    **  Description      : get_latest_item_title program unit
    */
    FUNCTION GET_LATEST_ITEM_TITLE(
        p_line_cd 	 IN gipi_polbasic.line_cd%TYPE,
        p_subline_cd IN gipi_polbasic.subline_cd%TYPE,
        p_iss_cd 	 IN gipi_polbasic.iss_cd%TYPE,
        p_issue_yy 	 IN gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no IN gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no 	 IN gipi_polbasic.renew_no%TYPE,
        p_item_no    IN gipi_item.item_no%TYPE
    ) 
    RETURN VARCHAR2 
    IS
        latest_title gipi_item.item_title%TYPE;
    BEGIN
      FOR get IN (SELECT b.item_title item_title
                    FROM gipi_polbasic a, gipi_item b
                   WHERE 1 = 1
                     AND a.policy_id = b.policy_id						     
                     AND b.item_no   = p_item_no
                     AND a.line_cd = p_line_cd
                     AND a.subline_cd = p_subline_Cd
                     AND a.iss_cd = p_iss_cd
                     AND a.issue_yy = p_issue_yy
                     AND a.pol_seq_no = p_pol_seq_no
                     AND a.renew_no = p_renew_no
                   ORDER BY a.endt_seq_no DESC)
        LOOP		
              latest_title := get.item_title;
              EXIT;
        END LOOP;						     
      RETURN latest_title;   
    END;
    
/*
    **  Created by       : Joanne
    **  Date Created     : 12.18.2013
    **  Reference By     : (GIEXS007- Edit Peril Information)
    **  Description      : Retrieves Package Sub Policies
    */
    FUNCTION get_pack_policy_list (
        p_pack_policy_id    GIEX_PACK_EXPIRY.pack_policy_id%TYPE,
        p_summary_sw      IN     giex_expiry.summary_sw%TYPE --added bu joanne 020314
    )
    RETURN giexs007_pack_subpolicy_tab PIPELINED
    IS
     v_packsubpol         giexs007_pack_subpolicy_type;
     v_itmperl            VARCHAR2(1); 
     v_itmperl_gpa            VARCHAR2(1); 
    BEGIN
     IF  NVL(p_summary_sw, 'Y') = 'Y' THEN  -- joanne 020314, added condition to displayed cancelled policy when not summary
         FOR pol IN (SELECT policy_id, get_policy_no(policy_id) policy_no, line_cd, subline_cd,
                        iss_cd, issue_yy, pol_seq_no, renew_no
                       FROM gipi_polbasic 
                      WHERE pack_policy_id = p_pack_policy_id
                      AND pol_flag IN ('1', '2', '3'))
         LOOP
            v_packsubpol.policy_id      :=   pol.policy_id;
            v_packsubpol.policy_no      :=   pol.policy_no;
            v_packsubpol.line_cd        :=   pol.line_cd;     
            v_packsubpol.subline_cd     :=   pol.subline_cd; 
            v_packsubpol.iss_cd         :=   pol.iss_cd;
            v_packsubpol.issue_yy       :=   pol.issue_yy;
            v_packsubpol.pol_seq_no     :=   pol.pol_seq_no;
            v_packsubpol.renew_no       :=   pol.renew_no;
            
            v_itmperl := 'N';
            v_itmperl_gpa := 'N';
            
            SELECT line_name, NVL(pack_pol_flag, 'N')
              INTO v_packsubpol.line_name, v_packsubpol.pack_pol_flag
              FROM giis_line
             WHERE line_cd = pol.line_cd;  
             
            SELECT subline_name
              INTO v_packsubpol.subline_name
              FROM giis_subline
             WHERE line_cd = pol.line_cd
             AND subline_cd=pol.subline_cd;   
             
             FOR A IN (SELECT '1'
                        FROM giex_itmperil
                       WHERE policy_id = pol.policy_id)
              LOOP
                v_itmperl := 'Y';
              END LOOP;  
              
             FOR B IN (SELECT '1'
                        FROM giex_itmperil_grouped
                       WHERE policy_id = pol.policy_id)
              LOOP
                v_itmperl_gpa := 'Y';
              END LOOP; 
              
              IF  v_itmperl = 'Y' OR v_itmperl = 'Y' THEN
                v_packsubpol.button_sw := 'Y';
              ELSE
                v_packsubpol.button_sw := 'N';  
              END IF;         
            
            PIPE ROW (v_packsubpol);
         END LOOP; 
     ELSE
         FOR pol IN (SELECT policy_id, get_policy_no(policy_id) policy_no, line_cd, subline_cd,
                iss_cd, issue_yy, pol_seq_no, renew_no
               FROM gipi_polbasic 
              WHERE pack_policy_id = p_pack_policy_id)
         LOOP
            v_packsubpol.policy_id      :=   pol.policy_id;
            v_packsubpol.policy_no      :=   pol.policy_no;
            v_packsubpol.line_cd        :=   pol.line_cd;     
            v_packsubpol.subline_cd     :=   pol.subline_cd; 
            v_packsubpol.iss_cd         :=   pol.iss_cd;
            v_packsubpol.issue_yy       :=   pol.issue_yy;
            v_packsubpol.pol_seq_no     :=   pol.pol_seq_no;
            v_packsubpol.renew_no       :=   pol.renew_no;
            
            v_itmperl := 'N';
            v_itmperl_gpa := 'N';
            
            SELECT line_name, NVL(pack_pol_flag, 'N')
              INTO v_packsubpol.line_name, v_packsubpol.pack_pol_flag
              FROM giis_line
             WHERE line_cd = pol.line_cd;  
             
            SELECT subline_name
              INTO v_packsubpol.subline_name
              FROM giis_subline
             WHERE line_cd = pol.line_cd
             AND subline_cd=pol.subline_cd;   
             
             FOR A IN (SELECT '1'
                        FROM giex_itmperil
                       WHERE policy_id = pol.policy_id)
              LOOP
                v_itmperl := 'Y';
              END LOOP;  
              
             FOR B IN (SELECT '1'
                        FROM giex_itmperil_grouped
                       WHERE policy_id = pol.policy_id)
              LOOP
                v_itmperl_gpa := 'Y';
              END LOOP; 
              
              IF  v_itmperl = 'Y' OR v_itmperl = 'Y' THEN
                v_packsubpol.button_sw := 'Y';
              ELSE
                v_packsubpol.button_sw := 'N';  
              END IF;         
            
            PIPE ROW (v_packsubpol);
         END LOOP;                  
     END IF;
    END get_pack_policy_list;    
    
    /*
    **  Created by       : Robert John Virrey
    **  Date Created     : 02.20.2012
    **  Reference By     : (GIEXS007- Edit Peril Information)
    **  Description      : Retrieves B480 data block 
    */
    FUNCTION get_giexs007_b480_info (
        p_policy_id   GIEX_ITMPERIL.policy_id%TYPE
    )
    RETURN giex_itmperil_tab PIPELINED
    IS
        v_itmperil   giex_itmperil_type;
        v_line_cd 	 gipi_polbasic.line_cd%TYPE;
        v_subline_cd gipi_polbasic.subline_cd%TYPE;
        v_iss_cd 	 gipi_polbasic.iss_cd%TYPE;
        v_issue_yy 	 gipi_polbasic.issue_yy%TYPE;
        v_pol_seq_no gipi_polbasic.pol_seq_no%TYPE;
        v_renew_no 	 gipi_polbasic.renew_no%TYPE;
    BEGIN
     SELECT line_cd,subline_cd,iss_cd,issue_yy, pol_seq_no, renew_no
       INTO v_line_cd,v_subline_cd,v_iss_cd,v_issue_yy,v_pol_seq_no,v_renew_no
       FROM gipi_polbasic 
      WHERE policy_id = p_policy_id;
      
      FOR i IN (SELECT DISTINCT LINE_CD, SUBLINE_CD, ITEM_NO, POLICY_ID, CURRENCY_RT 
                   FROM GIEX_ITMPERIL
                   WHERE policy_id = p_policy_id
                ORDER BY item_no) --Added by pol cruz 01.09.2015
        LOOP
         v_itmperil.line_cd         := i.line_cd;
         v_itmperil.subline_cd      := i.subline_cd;
         v_itmperil.item_no         := i.item_no;
         v_itmperil.policy_id       := i.policy_id;
         v_itmperil.currency_rt     := i.currency_rt;
        
         FOR A IN (SELECT  sum(NVL(prem_amt,0)) prem,
                            sum(NVL(ann_prem_amt,0)) ann_prem
                      FROM  giex_itmperil
                     WHERE  policy_id   = i.policy_id
                       AND  item_no     = i.item_no) 
          LOOP
                 v_itmperil.nbt_prem_amt     :=  A.prem;
                 v_itmperil.ann_prem_amt     :=  A.ann_prem;
          END LOOP;
      
          FOR B IN (SELECT  sum(NVL(a.tsi_amt,0)) tsi,                        
                            sum(NVL(a.ann_tsi_amt,0)) ann_tsi              
                      FROM  giex_itmperil a,giis_peril b
                     WHERE  a.line_cd    =  b.line_cd
                       AND  a.peril_cd   =  b.peril_cd
                       AND  b.peril_type =  'B'
                       AND  a.policy_id  =  i.policy_id
                       AND  item_no      =  i.item_no ) 
          LOOP
                 v_itmperil.nbt_tsi_amt     :=  B.tsi;
                 v_itmperil.ann_tsi_amt     :=  B.ann_tsi;             
          END LOOP;
          
          v_itmperil.nbt_item_title := giex_itmperil_pkg.get_latest_item_title(v_line_cd,v_subline_cd,v_iss_cd,v_issue_yy,v_pol_seq_no,v_renew_no,i.item_no);
         
         PIPE ROW (v_itmperil);
        END LOOP;
    END get_giexs007_b480_info;
    
    /*
    **  Created by       : Robert John Virrey
    **  Date Created     : 02.21.2012
    **  Reference By     : (GIEXS007- Edit Peril Information)
    **  Description      : Retrieves B490 data block 
    */
    FUNCTION get_giexs007_b490_info (
        p_policy_id   GIEX_ITMPERIL.policy_id%TYPE,
        p_item_no     GIEX_ITMPERIL.item_no%TYPE
    )
    RETURN giex_itmperil_tab PIPELINED
    IS
        v_itmperil   giex_itmperil_type;
    BEGIN
      FOR i IN (SELECT * 
                   FROM GIEX_ITMPERIL
                   WHERE policy_id = p_policy_id
                     AND item_no = p_item_no)
        LOOP
         v_itmperil.peril_cd        := i.peril_cd;
         v_itmperil.prem_rt         := i.prem_rt;
         v_itmperil.tsi_amt         := i.tsi_amt;
         v_itmperil.prem_amt        := i.prem_amt;
         v_itmperil.policy_id       := i.policy_id;
         v_itmperil.item_no         := i.item_no;
         v_itmperil.currency_rt     := i.currency_rt;
         v_itmperil.item_title      := i.item_title;
         v_itmperil.line_cd         := i.line_cd;
         v_itmperil.subline_cd      := i.subline_cd;
         v_itmperil.ann_tsi_amt     := i.ann_tsi_amt;
         v_itmperil.ann_prem_amt    := i.ann_prem_amt;
         v_itmperil.comp_rem        := i.comp_rem;
         
            DECLARE
              CURSOR A IS
                SELECT   peril_name,peril_type,basc_perl_cd
                  FROM   giis_peril
                 WHERE   line_cd   =  i.line_cd
                   AND   peril_cd  =  i.peril_cd;
               peril     A%rowtype;
            BEGIN
              /* Update specific items in each record that would be
              ** used as basis for future transactions.
              ** Created by   : Bismark
              ** Last Update  : 12 May 1998
              */
              OPEN A;
              FETCH A INTO peril;
              v_itmperil.dsp_peril_name   :=  peril.peril_name;
              v_itmperil.dsp_peril_type   :=  peril.peril_type;
              v_itmperil.dsp_basc_perl_cd :=  peril.basc_perl_cd;
              CLOSE A;
            END; 
         
         PIPE ROW (v_itmperil);
        END LOOP;
    END get_giexs007_b490_info;
    
    /*
    **  Created by       : Robert John Virrey
    **  Date Created     : 02.24.2012
    **  Reference By     : (GIEXS007- Edit Peril Information)
    **  Description      : COMPUTE_DEDUCTIBLE_AMT  
    **                     Compute deductible amount according to the record's
    **                     deductible level (policy level, item level, or peril level)
    */
    FUNCTION COMPUTE_DEDUCTIBLE_AMT (
        p_item_no           NUMBER,
        p_peril_cd          NUMBER,
        p_ded_rt            NUMBER,
        p_ded_policy_id     giex_itmperil.policy_id%TYPE,
        p_ded_deductible_cd giis_deductible_desc.deductible_cd%TYPE
    )
    RETURN NUMBER 
    IS
        --v_ded_amount giex_new_group_deductibles.deductible_amt%TYPE;
        v_ded_amount        NUMBER(16,2);
        --added by joanne 06.06.14
        v_tsi_amt           giex_itmperil.tsi_amt%TYPE;
        v_itm_tsi_amt       giex_itmperil.tsi_amt%TYPE;
        v_perl_tsi_amt      giex_itmperil.tsi_amt%TYPE;
        v_ded_amt           giex_new_group_deductibles.deductible_amt%TYPE;
        v_deductible_amt    giex_new_group_deductibles.deductible_amt%TYPE;
        v_min_amt           giis_deductible_desc.min_amt%TYPE;
        v_max_amt           giis_deductible_desc.max_amt%TYPE;
        v_range_sw          giis_deductible_desc.range_sw%TYPE;
        v_line_cd           giis_deductible_desc.line_cd%TYPE;
        v_subline_cd        giis_deductible_desc.subline_cd%TYPE;
        v_currency_rt       giex_itmperil.currency_rt%TYPE;      
    BEGIN
        SELECT line_cd, subline_cd
          INTO v_line_cd, v_subline_cd
          FROM gipi_polbasic
         WHERE policy_id = p_ded_policy_id;
        
      FOR ded IN (SELECT min_amt, max_amt, range_sw
                    FROM giis_deductible_desc 
                   WHERE line_cd = v_line_cd
                     AND subline_cd = v_subline_cd
                     AND deductible_cd = p_ded_deductible_cd)
      LOOP
        v_min_amt   := ded.min_amt;
        v_max_amt   := ded.max_amt;
        v_range_sw  := ded.range_sw;
      END LOOP;
      
     --added by joanne 06.03.14, get currency_rt
     FOR y IN (SELECT DISTINCT currency_rt 
                  FROM giex_old_group_itmperil
                 WHERE policy_id = p_ded_policy_id
                ORDER BY currency_rt DESC )
      LOOP
        v_currency_rt := y.currency_rt;
      END LOOP;  
      
        
      IF (p_item_no = 0 AND p_peril_cd = 0) THEN
           SELECT SUM (tsi_amt * currency_rt)
            INTO v_tsi_amt
            FROM giex_itmperil a,
                 giis_peril b
              WHERE a.policy_id = p_ded_policy_id
               AND a.line_cd = b.line_cd
                AND a.peril_cd = b.peril_cd
                AND b.peril_type = 'B';
                
            --added by joanne 06.06.14, added condition for range and min_amt, max_amt
            v_ded_amt := v_tsi_amt * (p_ded_rt / 100);
            IF p_ded_rt IS NOT NULL
               AND v_min_amt IS NOT NULL
               AND v_max_amt IS NOT NULL
            THEN
               IF v_range_sw = 'H'
               THEN
                  v_ded_amt := GREATEST (v_ded_amt, v_min_amt);
                  v_deductible_amt :=
                                   LEAST (v_ded_amt, v_max_amt);
               ELSIF v_range_sw = 'L'
               THEN
                  v_ded_amt := LEAST (v_ded_amt, v_min_amt);
                  v_deductible_amt :=
                                   LEAST (v_ded_amt, v_max_amt);
               ELSE
                  v_deductible_amt := v_max_amt;
               END IF;
            ELSIF     p_ded_rt IS NOT NULL
                  AND v_min_amt IS NOT NULL
            THEN
               v_deductible_amt :=
                                GREATEST (v_ded_amt, v_min_amt);
            ELSIF     p_ded_rt IS NOT NULL
                  AND v_max_amt IS NOT NULL
            THEN
               v_deductible_amt := LEAST (v_ded_amt, v_max_amt);
            ELSE
               IF p_ded_rt IS NOT NULL
               THEN
                  v_deductible_amt := v_ded_amt;
               ELSIF v_min_amt IS NOT NULL
               THEN
                  v_deductible_amt := v_min_amt;
               ELSIF v_max_amt IS NOT NULL
               THEN
                  v_deductible_amt := v_max_amt;
               END IF;
            END IF;
            /*  comment by joanne replace by code above  
            FOR tsi IN (SELECT SUM(tsi_amt) amt
                          FROM giex_itmperil a, giis_peril b
                         WHERE b.peril_type = 'B'
                           AND b.peril_cd   = a.peril_cd
                           AND b.line_cd    = a.line_cd
                           AND a.policy_id  = p_ded_policy_id
                         GROUP BY tsi_amt)
            LOOP
                v_ded_amount := p_ded_rt * (tsi.amt/100);    
            END LOOP;*/
      ELSIF (p_item_no <> 0 AND p_peril_cd = 0) THEN
            FOR item IN (SELECT   a.item_no,
                                SUM (a.tsi_amt * currency_rt) tsi_amt
                                --joanne 052914 added currency_rt
                           FROM giex_itmperil a,
                                giis_peril b
                          WHERE a.policy_id = p_ded_policy_id
                            AND a.line_cd = b.line_cd
                            AND a.peril_cd = b.peril_cd
                            AND b.peril_type = 'B'
                            AND  a.item_no = p_item_no
                       GROUP BY a.item_no
                       ORDER BY a.item_no)
          LOOP
             v_itm_tsi_amt := item.tsi_amt;      
               
                --added by joanne 06.06.14, added condition for range and min_amt, max_amt
                v_ded_amt := v_itm_tsi_amt * (p_ded_rt / 100);
                IF p_ded_rt IS NOT NULL
                   AND v_min_amt IS NOT NULL
                   AND v_max_amt IS NOT NULL
                THEN
                   IF v_range_sw = 'H'
                   THEN
                      v_ded_amt := GREATEST (v_ded_amt, v_min_amt);
                      v_deductible_amt :=
                                       LEAST (v_ded_amt, v_max_amt);
                   ELSIF v_range_sw = 'L'
                   THEN
                      v_ded_amt := LEAST (v_ded_amt, v_min_amt);
                      v_deductible_amt :=
                                       LEAST (v_ded_amt, v_max_amt);
                   ELSE
                      v_deductible_amt := v_max_amt;
                   END IF;
                ELSIF     p_ded_rt IS NOT NULL
                      AND v_min_amt IS NOT NULL
                THEN
                   v_deductible_amt :=
                                    GREATEST (v_ded_amt, v_min_amt);
                ELSIF     p_ded_rt IS NOT NULL
                      AND v_max_amt IS NOT NULL
                THEN
                   v_deductible_amt := LEAST (v_ded_amt, v_max_amt);
                ELSE
                   IF p_ded_rt IS NOT NULL
                   THEN
                      v_deductible_amt := v_ded_amt;
                   ELSIF v_min_amt IS NOT NULL
                   THEN
                      v_deductible_amt := v_min_amt;
                   ELSIF v_max_amt IS NOT NULL
                   THEN
                      v_deductible_amt := v_max_amt;
                   END IF;
                END IF;
          END LOOP;          
            /*  comment by joanne replace by code above     
            FOR tsi IN (SELECT SUM(tsi_amt) amt
                          FROM giex_itmperil a, giis_peril b
                         WHERE b.peril_type = 'B'
                           AND b.peril_cd   = a.peril_cd
                           AND b.line_cd    = a.line_cd
                           AND a.policy_id  = p_ded_policy_id
                           AND a.item_no    = p_item_no
                         GROUP BY tsi_amt)
            LOOP  
                v_ded_amount := p_ded_rt * (tsi.amt/100);  
            END LOOP;*/
      ELSIF (p_item_no <> 0 AND p_peril_cd <> 0) THEN
          FOR perl IN (SELECT   a.item_no, a.peril_cd, 
                               (a.tsi_amt * currency_rt) tsi_amt
                           FROM giex_itmperil a
                          WHERE a.policy_id = p_ded_policy_id
                          AND  a.item_no = p_item_no
                          AND  a.peril_cd = p_peril_cd
                       ORDER BY a.item_no, a.peril_cd)
          LOOP
             v_perl_tsi_amt := perl.tsi_amt;
                --added by joanne 06.06.14, added condition for range and min_amt, max_amt
                v_ded_amt := v_perl_tsi_amt * (p_ded_rt / 100);
                IF p_ded_rt IS NOT NULL
                   AND v_min_amt IS NOT NULL
                   AND v_max_amt IS NOT NULL
                THEN
                   IF v_range_sw = 'H'
                   THEN
                      v_ded_amt := GREATEST (v_ded_amt, v_min_amt);
                      v_deductible_amt :=
                                       LEAST (v_ded_amt, v_max_amt);
                   ELSIF v_range_sw = 'L'
                   THEN
                      v_ded_amt := LEAST (v_ded_amt, v_min_amt);
                      v_deductible_amt :=
                                       LEAST (v_ded_amt, v_max_amt);
                   ELSE
                      v_deductible_amt := v_max_amt;
                   END IF;
                ELSIF     p_ded_rt IS NOT NULL
                      AND v_min_amt IS NOT NULL
                THEN
                   v_deductible_amt :=
                                    GREATEST (v_ded_amt, v_min_amt);
                ELSIF     p_ded_rt IS NOT NULL
                      AND v_max_amt IS NOT NULL
                THEN
                   v_deductible_amt := LEAST (v_ded_amt, v_max_amt);
                ELSE
                   IF p_ded_rt IS NOT NULL
                   THEN
                      v_deductible_amt := v_ded_amt;
                   ELSIF v_min_amt IS NOT NULL
                   THEN
                      v_deductible_amt := v_min_amt;
                   ELSIF v_max_amt IS NOT NULL
                   THEN
                      v_deductible_amt := v_max_amt;
                   END IF;
                END IF;
          END LOOP;           
            /*  comment by joanne replace by code above       
            FOR tsi IN (SELECT SUM(tsi_amt) amt
              FROM giex_itmperil a, giis_peril b
             WHERE a.item_no    = p_item_no
               AND b.peril_cd   = a.peril_cd
               AND b.line_cd    = a.line_cd
               AND a.policy_id  = p_ded_policy_id
               AND a.peril_cd   = p_peril_cd
             GROUP BY tsi_amt)
            LOOP
                v_ded_amount := p_ded_rt * (tsi.amt/100);    
            END LOOP;*/
        END IF;
        v_ded_amount := ROUND(v_deductible_amt/v_currency_rt,2) ;
      RETURN v_ded_amount;
    END;
    
    /*Modified by: Joanne
    **Date: 01-03-14
    **Description: Recoded extraction of perils, apply changes same as GIEXS001 in computation of TSI/PREM*/
    PROCEDURE POPULATE_PERIL(
        p_line_cd         IN     gipi_polbasic.line_cd%TYPE,
        p_subline_cd      IN     gipi_polbasic.subline_cd%TYPE,
        p_iss_cd          IN     gipi_polbasic.iss_cd%TYPE,
        p_nbt_issue_yy    IN     gipi_polbasic.issue_yy%TYPE,
        p_nbt_pol_seq_no  IN     gipi_polbasic.pol_seq_no%TYPE,
        p_nbt_renew_no    IN     gipi_polbasic.renew_no%TYPE,
        p_policy_id       IN     giex_itmperil.policy_id%TYPE,
        p_pack_pol_flag   IN     giis_line.pack_pol_flag%TYPE,
        p_for_delete      IN OUT VARCHAR2  
    ) 
    IS
     /* rg_id              RECORDGROUP;
      rg_name            VARCHAR2(30) := 'GROUP_POLICY';
      rg_count           NUMBER;
      rg_count2          NUMBER;
      rg_col             VARCHAR2(50) := rg_name || '.policy_id';
      item_exist         VARCHAR2(1); 
      v_row              NUMBER;
      v_policy_id        gipi_polbasic.policy_id%TYPE;
      v_endt_id          gipi_polbasic.policy_id%TYPE;
      v_peril_cd         gipi_witmperl.peril_cd%TYPE;
      v_line_cd          gipi_witmperl.line_cd%TYPE;
      v_subline_cd       giex_expiry.subline_cd%TYPE;
      v_prem_rt          gipi_witmperl.prem_rt%TYPE;
      v_currency_rt      gipi_witem.currency_rt%TYPE;
      v_tsi_amt          gipi_witmperl.tsi_amt%TYPE;
      v_prem_amt         gipi_witmperl.prem_amt%TYPE;
      v_comp_rem         gipi_witmperl.comp_rem%TYPE;
      v_item_title       gipi_witem.item_title%TYPE;
      expire_sw          VARCHAR2(1) := 'N';*/
      --v_dep_pct          NUMBER(3,2);-- := Giisp.n('MC_DEP_PCT')/100; comment by joanne
      v_tot_ren_tsi      giex_expiry.ren_tsi_amt%TYPE:=0;
      v_tot_ren_prem     giex_expiry.ren_prem_amt%TYPE:=0;
    --  v_round_off        GIIS_PARAMETERS.PARAM_VALUE_N%TYPE;

    --joanne 010314 apply same changes in extraction regarding computation in TSI and perils
       v_round_off            giis_parameters.param_value_n%TYPE;
       v_apply_dep            VARCHAR2 (1);
       v_policy_id            giex_expiry.policy_id%TYPE;
       v_endt_id              giex_expiry.policy_id%TYPE;
       v_exists_in_prev_id    VARCHAR2 (1);
       v_cnt_rec              NUMBER;
       v_temp_tsi             giex_old_group_peril.tsi_amt%TYPE;
       v_temp_prem            giex_old_group_peril.prem_amt%TYPE;
       v_temp_currency_tsi    giex_old_group_peril.orig_tsi_amt%TYPE;
       v_temp_currency_prem   giex_old_group_peril.currency_prem_amt%TYPE;
       v_temp_prem_rt         gipi_itmperil.prem_rt%TYPE;
       v_temp_currency_rt     gipi_witem.currency_rt%TYPE;
       v_old_temp_tsi         gipi_witem.tsi_amt%TYPE;
       v_old_temp_prem        gipi_witem.prem_amt%TYPE;
       v_mark_eff_date        gipi_wpolbas.eff_date%TYPE;
       v_mark_endt_seq_no     gipi_polbasic.endt_seq_no%TYPE;
       v_currency_cd          gipi_item.currency_cd%TYPE;
       -- jhing 11.20.2014 added variables 
       v_no_of_days           NUMBER ;
       v_computed_ann_prem    gipi_itmperil.ann_prem_amt%TYPE;
       v_total_ren_tsi_amt    giex_expiry.ren_tsi_amt%TYPE;
       v_total_ren_prem_amt   giex_expiry.ren_prem_amt%TYPE;
       v_exists_gxitmperl     VARCHAR2(1);  
       --variables for outer peril loop
       v_incept_date          gipi_polbasic.incept_date%TYPE;
       v_eff_date             gipi_polbasic.eff_date%TYPE;
       v_expiry_date          gipi_polbasic.expiry_date%TYPE;
       v_endt_expiry_date     gipi_polbasic.endt_expiry_date%TYPE;
       v_comp_sw              NUMBER;
       v_prorate_flag         gipi_polbasic.prorate_flag%TYPE;  
       v_short_rt_percent     gipi_polbasic.short_rt_percent%TYPE;       
       -- variables for inner peril loop     
       v_incept_date2         gipi_polbasic.incept_date%TYPE;
       v_eff_date2            gipi_polbasic.eff_date%TYPE;
       v_expiry_date2         gipi_polbasic.expiry_date%TYPE;
       v_endt_expiry_date2    gipi_polbasic.endt_expiry_date%TYPE;
       v_comp_sw2             NUMBER;       
       v_short_rt_percent2    gipi_polbasic.short_rt_percent%TYPE;
       v_prorate_flag2        gipi_polbasic.prorate_flag%TYPE;

    BEGIN 
      --rg_id := Find_Group( 'GROUP_POLICY' ); 
      --IF NOT Id_Null(rg_id) THEN 
      --  Delete_Group( rg_id ); 
      --END IF; 
      --CHECK_POLICY_GROUP(rg_name);    
      --rg_id     := FIND_GROUP(rg_name);
      --rg_count  := GET_GROUP_ROW_COUNT(rg_id);
      --rg_count2 := rg_count;
      --FOR ROW_NO IN 1 .. rg_count  
      --joanne 010314 apply same changes in extraction regarding computation in TSI and perils
       BEGIN
          SELECT DECODE (param_value_n,
                         10, -1,
                         100, -2,
                         1000, -3,
                         10000, -4,
                         100000, -5,
                         1000000, -6,
                         9
                        )
            INTO v_round_off
            FROM giis_parameters
           WHERE param_name = 'ROUND_OFF_PLACE';
       EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
             v_round_off := 9;
       END;

       v_apply_dep := NVL (giisp.v ('AUTO_COMPUTE_MC_DEP'), 'N');
       -- get all policies and endorsements
       v_policy_id := NULL;
       v_endt_id := NULL;
       v_exists_in_prev_id := NULL;
       v_cnt_rec := 0;
       v_temp_currency_tsi := 0;
       v_temp_prem_rt := 0;
       v_temp_currency_rt := 0;
       v_temp_tsi := 0;
       v_temp_currency_prem := 0;
       v_temp_prem := 0;
       v_old_temp_tsi := 0;
       v_old_temp_prem := 0;
       v_currency_cd := NULL;
       
       -- jhing 11.20.2014 added new variables 
       v_total_ren_tsi_amt := 0 ;
       v_total_ren_prem_amt := 0 ; 

       FOR cur_policy IN (SELECT   policy_id, eff_date, endt_seq_no
                                -- jhing 11.20.2014 added fields 
                                , incept_date, expiry_date , endt_expiry_date
                                , prorate_flag, NVL(short_rt_percent,0) short_rt_percent
                                , DECODE ( NVL(comp_sw, 'N'), 'Y', 1 , 'M' , -1, 0 ) comp_sw
                              FROM gipi_polbasic
                             WHERE line_cd = p_line_cd
                               AND subline_cd = p_subline_cd
                               AND iss_cd = p_iss_cd
                               AND issue_yy = p_nbt_issue_yy
                               AND pol_seq_no = p_nbt_pol_seq_no
                               AND renew_no = p_nbt_renew_no
                               AND pol_flag IN ('1', '2', '3')
                               AND (   endt_seq_no = 0
                                    OR (    endt_seq_no > 0
                                        AND TRUNC
                                               (NVL (endt_expiry_date,
                                                     expiry_date
                                                    )
                                               ) >=
                                                   TRUNC (expiry_date)
                                       )
                                   )
                          ORDER BY eff_date, endt_seq_no )  
       LOOP
          IF v_policy_id IS NULL
          THEN
             v_policy_id := p_policy_id;
          END IF;

          v_endt_id := cur_policy.policy_id;
          v_mark_eff_date := cur_policy.eff_date;
          v_mark_endt_seq_no := cur_policy.endt_seq_no;
          
          -- jhing 11.20.2014 added fields
          v_incept_date := cur_policy.incept_date;
          v_eff_date    := cur_policy.eff_date;
          v_expiry_date := cur_policy.expiry_date;
          v_endt_expiry_date := cur_policy.endt_expiry_date;
          v_short_rt_percent := cur_policy.short_rt_percent;
          v_prorate_flag := cur_policy.prorate_flag; 
          v_comp_sw := cur_policy.comp_sw;

          -- query all the peril of the policy/endt per item
          FOR cur_itmperil IN (SELECT   a.tsi_amt, a.prem_rt,
                                        a.prem_amt, a.item_no,
                                        a.peril_cd, b.currency_rt,
                                        a.line_cd, b.currency_cd,
                                        a.comp_rem,  b.item_title , c.peril_type 
                                   FROM gipi_itmperil a, gipi_item b , giis_peril c /* jhing 11.20.2014 added connection to giis_peril */
                                  WHERE a.policy_id = v_endt_id
                                    AND a.policy_id = b.policy_id
                                    AND a.item_no = b.item_no
                                    AND a.line_cd = c.line_cd
                                    AND a.peril_cd = c.peril_cd 
                               ORDER BY a.item_no, a.peril_cd)
          LOOP
             v_exists_in_prev_id := 'N';
             -- this variable will hold info whether the item/peril existed in previous policy/endt.
             v_temp_currency_tsi := cur_itmperil.tsi_amt;
             v_temp_prem_rt := cur_itmperil.prem_rt;
             v_temp_currency_rt := NVL (cur_itmperil.currency_rt, 1);
             v_temp_tsi := cur_itmperil.tsi_amt * v_temp_currency_rt;
             /*v_temp_currency_prem := cur_itmperil.prem_amt;
             v_temp_prem :=
                           cur_itmperil.prem_amt * v_temp_currency_rt; */ -- jhing 11.20.2014 commented 
                            
             v_old_temp_tsi := cur_itmperil.tsi_amt;
             v_old_temp_prem := cur_itmperil.prem_amt;
             v_currency_cd := cur_itmperil.currency_cd;
             
             -- jhing 11.20.2014 compute annual premium
             v_computed_ann_prem := 0 ; 
             IF v_prorate_flag = 1 THEN
                v_no_of_days := ROUND ( NVL (v_endt_expiry_date, v_expiry_date) - v_eff_date) ;
                v_computed_ann_prem := (cur_itmperil.prem_amt / (v_no_of_days  + v_comp_sw))* check_duration (v_incept_date, v_expiry_date);  
             ELSIF v_prorate_flag = 3 THEN
                 v_computed_ann_prem := (cur_itmperil.prem_amt * 100 ) / v_short_rt_percent ;
             ELSE
                 v_computed_ann_prem := cur_itmperil.prem_amt; 
             END IF;
             v_temp_currency_prem := v_computed_ann_prem;
             v_temp_prem := v_computed_ann_prem * v_temp_currency_rt; 
             
             -- jhing 11.20.2014 checked if the item no and peril exists in giex_itmperil
             v_exists_gxitmperl := 'N';
             FOR existsGx in (SELECT 1 FROM 
                                GIEX_ITMPERIL 
                                WHERE policy_id = p_policy_id
                                    AND item_no = cur_itmperil.item_no
                                    AND peril_cd = cur_itmperil.peril_cd)
             LOOP
                v_exists_gxitmperl := 'Y';
                EXIT;
             END LOOP;
             
             -- jhing 11.20.2014 if nagexists n ung record sa GIEX_ITMPERIL then there is no need to execute the codes below 
             -- since nung unang nainsert pa lng ung record nacompute na ung amounts nia net of endorsement, ble magredundant processing if papasukin pa ulit 
             -- ung loops below 
             
             IF v_exists_gxitmperl = 'N' THEN 
             
                 -- query all records in the policy/endt which contains the same item_no and peril_cd
                 FOR cur_all_perils IN
                    (SELECT   a.policy_id, a.item_no, a.peril_cd,
                              a.tsi_amt, a.prem_rt, a.prem_amt,
                              b.eff_date, b.endt_seq_no , 
                              -- jhing 11.20.2014 added fields
                              b.prorate_flag, b.expiry_date ,
                              b.incept_date, b.endt_expiry_date ,
                              NVL(b.short_rt_percent,0) short_rt_percent , DECODE (NVL(comp_sw, 'N'), 'Y', 1 , 'M' , -1, 0 ) comp_sw
                         FROM gipi_itmperil a, gipi_polbasic b
                        WHERE a.policy_id = b.policy_id
                          AND b.line_cd = p_line_cd
                          AND b.subline_cd = p_subline_cd
                          AND b.iss_cd = p_iss_cd
                          AND b.issue_yy = to_char(p_nbt_issue_yy)
                          AND b.pol_seq_no = to_char(p_nbt_pol_seq_no)
                          AND b.renew_no = to_char(p_nbt_renew_no)
                          AND a.item_no = cur_itmperil.item_no
                          AND a.peril_cd = cur_itmperil.peril_cd
                          AND b.pol_flag IN ('1', '2', '3')
                          AND (   endt_seq_no = 0
                               OR (    endt_seq_no > 0
                                   AND TRUNC (NVL (endt_expiry_date,
                                                   expiry_date
                                                  )
                                             ) >= TRUNC (expiry_date)
                                  )
                              )
                          AND b.policy_id <> v_endt_id
                     ORDER BY b.eff_date, b.endt_seq_no)
                 LOOP
                    -- jhing 11.20.2014 assign values to variables from cursor 
                      v_incept_date2 := cur_all_perils.incept_date;
                      v_eff_date2    := cur_all_perils.eff_date;
                      v_expiry_date2 := cur_all_perils.expiry_date;
                      v_endt_expiry_date2 := cur_all_perils.endt_expiry_date;
                      v_short_rt_percent2 := cur_all_perils.short_rt_percent;
                      v_prorate_flag2 := cur_all_perils.prorate_flag; 
                      v_comp_sw2 := cur_all_perils.comp_sw;  
                         
                 
                    -- if mas later than ung eff_date ng current na tsek na record kesa sa unang naretrieve ng query...it means ... meron ng nadaanana
                    -- na query before
                   /* IF     v_mark_eff_date > cur_all_perils.eff_date
                       AND v_mark_endt_seq_no > cur_all_perils.endt_seq_no
                    THEN
                       v_exists_in_prev_id := 'Y';
                       EXIT;
                    ELSE */ -- commented out jhing 11.09.2014                     

                    -- jhing 11.20.2014 compute for the annual premium
                    v_computed_ann_prem := 0 ;                    
                     IF v_prorate_flag2 = 1 THEN
                        v_no_of_days := ROUND ( NVL (v_endt_expiry_date2, v_expiry_date2) - v_eff_date2) ;
                        v_computed_ann_prem := (cur_all_perils.prem_amt / (v_no_of_days  + v_comp_sw2))* check_duration (v_incept_date2, v_expiry_date2);  
                     ELSIF v_prorate_flag2 = 3 THEN
                         v_computed_ann_prem := (cur_all_perils.prem_amt * 100 ) / v_short_rt_percent2 ;
                     ELSE
                         v_computed_ann_prem := cur_all_perils.prem_amt; 
                     END IF;
 
                    v_temp_currency_prem := v_temp_currency_prem + v_computed_ann_prem;
                     v_temp_prem := v_temp_prem + (v_computed_ann_prem * v_temp_currency_rt);                  

                     
                       -- pag di equal si endt_id kay cur_all_perils then add up and kunin ung prem_rt pag non-zero si tsi and prem_rt
                       v_temp_currency_tsi :=
                             v_temp_currency_tsi + cur_all_perils.tsi_amt;
                       v_temp_tsi :=
                            v_temp_tsi
                          + (cur_all_perils.tsi_amt * v_temp_currency_rt
                            );


                      /* v_temp_currency_prem :=
                            v_temp_currency_prem + cur_all_perils.prem_amt;
                       v_temp_prem :=
                            v_temp_prem
                          + (cur_all_perils.prem_amt * v_temp_currency_rt
                            ); */ -- jhing 11.20.2014 commented out                           
 
                       IF cur_all_perils.prem_rt > 0
                       THEN
                          v_temp_prem_rt := cur_all_perils.prem_rt;
                       END IF;

                       v_old_temp_tsi :=
                                   v_old_temp_tsi + cur_all_perils.tsi_amt;
                       v_old_temp_prem :=
                                 v_old_temp_prem + cur_all_perils.prem_amt;
                   -- END IF;
                 END LOOP; -- end loop cur_all_perils

                 -- if di pa naexists/nacheck ng mga naunang queries/run ng loop....iadd/update ung giex_old_group_peril
                -- IF v_exists_in_prev_id = 'N'
                 -- THEN
                    -- if cancelled na ung peril..then don't do anything
                    IF v_temp_tsi > 0
                    THEN
                       -- if zero si prem_rt (which is most probably due to the reason n standard tariff rates applied sa knya and/or gumana sa knya ung minimum premium.
                       -- then recalculate ung prem_rt based on accumulated tsi/prem. Under GUC discussion pa ano ung final handling ng ganitong type of records.

                      /* IF v_temp_prem_rt = 0
                       THEN
                          v_temp_prem_rt :=
                                         (v_temp_prem / v_temp_tsi) * 100;
                       END IF;  */ -- jhing 11.20.2014 lagi ng irecompute si prem rate since ngkakaroon ng effect on premium ung maling ri prem rate for example ngdecrese ng premium pero di ng TSI
                       
                       v_temp_prem_rt := ROUND(( v_temp_prem / v_temp_tsi ) * 100,9) ; -- jhing 11.20.2014   
            
                      -- get the depreciation rate
                       /*IF v_apply_dep = 'Y'
                       THEN
                          FOR a IN (SELECT NVL (rate, 0) rate
                                      FROM giex_dep_perl
                                     WHERE line_cd = cur_itmperil.line_cd
                                       AND peril_cd =
                                                     cur_itmperil.peril_cd)
                          LOOP
                             IF a.rate <> 0 THEN 
                                 v_temp_tsi :=
                                    ROUND ((  v_temp_tsi
                                            - (v_temp_tsi * (a.rate / 100))
                                           ),
                                           v_round_off 
                                          );
                                 v_temp_currency_tsi :=
                                    ROUND ((  v_temp_currency_tsi
                                            - (  v_temp_currency_tsi
                                               * (a.rate / 100)
                                              )
                                           ),
                                            v_round_off 
                                          );
                                          
                                -- jhing 11.20.2014 commented out. forgot that only TSI should be rounded off. Premium is computed by multiplying
                                -- TSI with rate 
                                          
--                                v_temp_prem :=  -- jhing 11.09.2014 
--                                    ROUND ((  v_temp_prem
--                                            - (v_temp_prem * (a.rate / 100))
--                                           ),
--                                           v_round_off 
--                                          );
--                                v_temp_currency_prem :=  -- jhing 11.09.2014 
--                                    ROUND ((  v_temp_currency_prem
--                                            - (v_temp_currency_prem * (a.rate / 100))
--                                           ),
--                                           v_round_off 
--                                          );

--                                v_temp_prem_rt := ( v_temp_prem / v_temp_tsi ) * 100 ;
                            END IF; 
                          END LOOP; -- end loop a ( depreciation )
                       END IF;*/ --benjo 11.23.2016 UCPBGEN-SR-23130 comment out
                       
                       compute_depreciation_amounts (v_endt_id, cur_itmperil.item_no, cur_itmperil.line_cd, cur_itmperil.peril_cd, v_temp_currency_tsi); --benjo 11.23.2016 UCPBGEN-SR-23130 
                       compute_depreciation_amounts (v_endt_id, cur_itmperil.item_no, cur_itmperil.line_cd, cur_itmperil.peril_cd, v_temp_tsi); --benjo 11.23.2016 UCPBGEN-SR-23130 
                       
                        v_temp_currency_prem :=
                              v_temp_currency_tsi
                              * (v_temp_prem_rt / 100);
                       v_temp_prem := v_temp_tsi * (v_temp_prem_rt / 100);  -- jhing 11.14.2014    -- jhing 11.20.2014 uncommented out 
                       
                       -- jhing 11.20.2014 update giex_expiry 
                       IF cur_itmperil.peril_type = 'B' THEN
                         v_total_ren_tsi_amt := v_total_ren_tsi_amt + v_temp_tsi;
                       END IF;
                       
                       v_total_ren_prem_amt := v_total_ren_prem_amt + v_temp_prem;                    
                       
                                     
                 
                      IF p_for_delete = 'Y' THEN
                            v_tot_ren_tsi  := v_tot_ren_tsi  + v_temp_currency_tsi;
                            v_tot_ren_prem := v_tot_ren_prem + v_temp_currency_prem;
                      ELSE                            
                        INSERT INTO giex_itmperil (
                                         policy_id,         item_no,        peril_cd, 
                                         line_cd,           tsi_amt,        prem_amt,
                                         prem_rt,           ann_tsi_amt,    ann_prem_amt,
                                         comp_rem,          item_title,     subline_cd,
                                         currency_rt)
                                  VALUES(p_policy_id,           cur_itmperil.item_no,     cur_itmperil.peril_cd,
                                         p_line_cd,             v_temp_currency_tsi,      v_temp_currency_prem,
                                         v_temp_prem_rt,        v_temp_currency_tsi,      v_temp_currency_prem,
                                         cur_itmperil.comp_rem, cur_itmperil.item_title,  p_subline_cd,
                                         v_temp_currency_rt);  
                               
                              -- jhing 11.20.2014 commented out. Using merge is a temp solution to address unique constraint due to SR #    17490 (FGICGENWEB )
                              -- however there is no longer a need to use this as insert statement will only be called if there are no records in 
                              -- giex_itmperil with the same item no and peril code 
                                     
                              /* MERGE INTO giex_itmperil
                                   USING DUAL
                                   ON (    policy_id = p_policy_id
                                       AND item_no = cur_itmperil.item_no
                                       AND peril_cd = cur_itmperil.peril_cd )
                                   WHEN NOT MATCHED THEN
                                      INSERT  (
                                              policy_id,         item_no,        peril_cd, 
                                              line_cd,           tsi_amt,        prem_amt,
                                              prem_rt,           ann_tsi_amt,    ann_prem_amt,
                                              comp_rem,          item_title,     subline_cd,
                                              currency_rt)
                                       VALUES(p_policy_id,           cur_itmperil.item_no,     cur_itmperil.peril_cd,
                                              p_line_cd,             v_temp_currency_tsi,      v_temp_prem,
                                              v_temp_prem_rt,        v_temp_currency_tsi,      v_temp_prem,
                                              cur_itmperil.comp_rem, cur_itmperil.item_title,  p_subline_cd,
                                              v_temp_currency_rt)   ;   */   -- jhing 11.09.2014  temp soln to issue                                   
                                                     
                      END IF;                      

                   -- END IF;
                 END IF; 
            END IF; -- jhing 11.20.2014 
          END LOOP; -- end loop cur_itmperil 
       END LOOP; -- end loop cur_policy

       -- jhing 11.20.2014 update giex_expiry ren_tsi_amt , ren_prem_amt based on the edited records
       UPDATE giex_expiry 
        SET ren_tsi_amt = v_total_ren_tsi_amt
            , ren_prem_amt = v_total_ren_prem_amt
       WHERE policy_id = p_policy_id; 

      /*comment by joanne 010314
      FOR b IN (SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
                  FROM gipi_polbasic
                 WHERE line_cd     = p_line_cd
                   AND subline_cd  = p_subline_cd
                   AND iss_cd      = p_iss_cd
                   AND issue_yy    = to_char(p_nbt_issue_yy)
                   AND pol_seq_no  = to_char(p_nbt_pol_seq_no)
                   AND renew_no    = to_char(p_nbt_renew_no)
                   AND (endt_seq_no = 0 OR 
                       (endt_seq_no > 0 AND 
                       TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                   AND pol_flag IN ('1','2','3')      
                 ORDER BY eff_date, endt_seq_no)
      LOOP
        --v_policy_id  := GET_GROUP_NUMBER_CELL(rg_col,row_no);
        v_policy_id   := b.policy_id;
        v_row         := v_row + 1;
        FOR DATA IN (SELECT a.peril_cd,         a.ann_prem_amt prem_amt,        a.ann_tsi_amt tsi_amt,
                            a.tarf_cd,          a.prem_rt,                      a.comp_rem,
                            a.line_cd,          a.item_no,                      b.item_title,
                            b.pack_subline_cd,                                  b.currency_rt,  
                            a.ann_tsi_amt perl_tsi,      b.ann_tsi_amt itm_tsi     --joanne 010314  
                       FROM gipi_itmperil a, gipi_item b 
                      WHERE a.policy_id = b.policy_id
                        AND a.item_no   = b.item_no
                        AND a.policy_id = v_policy_id)            
        LOOP
          item_exist := 'N';
          FOR CHK_ITEM IN (SELECT '1'
                            FROM giex_itmperil
                           WHERE peril_cd = data.peril_cd
                             AND item_no  = data.item_no
                             AND Giisp.v('AUTO_COMPUTE_MC_DEP') = 'Y'
                             AND policy_id = p_policy_id)
          LOOP
            item_exist := 'Y';
            EXIT;
          END LOOP;
          IF item_exist = 'N' THEN            
             v_currency_rt      := data.currency_rt;     
             v_peril_cd         := data.peril_cd;
             v_line_cd          := data.line_cd;
             v_prem_amt         := data.prem_amt;
             v_tsi_amt          := data.tsi_amt;
             v_item_title       := data.item_title;
             v_prem_rt          := data.prem_rt;
             v_comp_rem         := data.comp_rem;
             v_itm_ann_tsi_amt  := data.itm_tsi; --joanne 010314
             v_perl_ann_tsi_amt := data.perl_tsi; --joanne 010314
             IF NVL(p_pack_pol_flag, 'N') = 'Y' THEN
                v_subline_cd :=  data.pack_subline_cd;
             ELSE
                v_subline_cd :=  p_subline_cd;
             END IF;
                 
             --FOR row_no2 IN  v_row..rg_count2 
             FOR c IN (SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
                  FROM gipi_polbasic
                 WHERE line_cd     = p_line_cd
                   AND subline_cd  = p_subline_cd
                   AND iss_cd      = p_iss_cd
                   AND issue_yy    = to_char(p_nbt_issue_yy)
                   AND pol_seq_no  = to_char(p_nbt_pol_seq_no)
                   AND renew_no    = to_char(p_nbt_renew_no)
                   AND (endt_seq_no = 0 OR 
                       (endt_seq_no > 0 AND 
                       TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                   AND pol_flag IN ('1','2','3')      
                 ORDER BY eff_date, endt_seq_no)
             LOOP
               --v_endt_id  := GET_GROUP_NUMBER_CELL(rg_col,row_no2);
               v_endt_id  := c.policy_id;
               FOR DATA2 IN (SELECT a.ann_prem_amt prem_amt,        a.ann_tsi_amt tsi_amt,
                                    a.prem_rt,         a.comp_rem,
                                    a.ri_comm_rate,    a.ri_comm_amt,
                                    b.item_title
                               FROM gipi_itmperil a, gipi_item b 
                              WHERE a.policy_id = b.policy_id
                                AND a.item_no = b.item_no
                                AND peril_cd  = v_peril_cd
                                AND a.item_no = data.item_no                         
                                AND a.policy_id = v_endt_id)
               LOOP
                 IF v_policy_id <> v_endt_id THEN    
                    v_item_title        := NVL(data2.item_title, v_item_title);
                    --v_prem_amt         := NVL(v_prem_amt,0) + NVL(data2.prem_amt,0);
                    v_prem_amt          := NVL(data2.prem_amt,0);
                    --v_tsi_amt          := NVL(v_tsi_amt,0) + NVL(data2.tsi_amt,0);
                    v_tsi_amt           := NVL(data2.tsi_amt,0);
                    IF NVL(data2.prem_rt,0) > 0 THEN
                       v_prem_rt          := data2.prem_rt;
                    END IF;   
                    v_comp_rem          := NVL(data2.comp_rem, v_comp_rem);     
                 END IF;                   
               END LOOP;
             END LOOP;            
                 
             /*JEROME.O 10102008 
               Added for rounding off/depreciate renewal tsi amount  
               */
        /*       SELECT DECODE(param_value_n,10,-1,100,-2,1000,-3,10000,-4,100000,-5,1000000,-6,9)
                 INTO v_round_off
                 FROM giis_parameters
                WHERE param_name = 'ROUND_OFF_PLACE' ;
                 
             IF NVL(v_tsi_amt,0) > 0  THEN
                --CLEAR_MESSAGE;
                --MESSAGE('Copying peril info ...',NO_ACKNOWLEDGE);
                --SYNCHRONIZE;
                --msg_alert(v_line_cd||'-'||v_peril_cd,'I',FALSE);  -- jenny vi lim 03312005
                FOR a IN (
                      SELECT rate/100  rate--joanne 112513             
                        FROM giex_dep_perl b
                       WHERE b.line_cd  = v_line_cd
                         AND b.peril_cd  = v_peril_cd
                         AND Giisp.v('AUTO_COMPUTE_MC_DEP') = 'Y')
                    LOOP
                        --v_tsi_amt  := v_tsi_amt - (v_tsi_amt*v_dep_pct);            
                      v_tsi_amt  := ROUND((v_tsi_amt - (v_tsi_amt*nvl(a.rate/*joanne v_dep_pct*/--,0))),v_round_off); --modify by JEROME.O 10-10-08
         /*             --v_prem_amt := v_prem_amt - (v_prem_amt * v_dep_pct);--v_tsi_amt * (v_prem_rt/100);--comment out by roset, 11/24/2010
                      v_prem_amt := v_tsi_amt * (v_prem_rt/100); --roset, 11/24/2010. prem amt based on the rounded off tsi..                          
                    END LOOP;    
                --    v_prem_rt := ((NVL(v_prem_amt,0) / NVL(v_tsi_amt,0)) * 100); --added by gmi 101107, made into comment by roset, 11/24/2010
                                
                  IF p_for_delete = 'Y' THEN
                        v_tot_ren_tsi  := v_tot_ren_tsi  + v_tsi_amt;
                        v_tot_ren_prem := v_tot_ren_prem + v_prem_amt;
                  ELSE                            
                                    

                    INSERT INTO giex_itmperil (
                                     policy_id,         item_no,        peril_cd, 
                                     line_cd,           tsi_amt,        prem_amt,
                                     prem_rt,           ann_tsi_amt,    ann_prem_amt,
                                     comp_rem,          item_title,     subline_cd,
                                     currency_rt)
                              VALUES(p_policy_id,       data.item_no,   v_peril_cd,
                                     v_line_cd,         v_tsi_amt,      v_prem_amt,
                                     v_prem_rt,         v_tsi_amt,      v_prem_amt,
                                     v_comp_rem,        v_item_title,   v_subline_cd,
                                     v_currency_rt);
                  END IF;                    
                 v_peril_cd         := NULL;
                 v_line_cd          := NULL;
                 v_prem_amt         := NULL;
                 v_tsi_amt          := NULL;
                 v_prem_rt          := NULL;
                 v_currency_rt      := NULL;
                 v_comp_rem         := NULL;
             END IF;  
                        
          ELSE
             NULL;         
          END IF;                        
        END LOOP;
      END LOOP;*/   
    
      p_for_delete := 'Y'; --rose 01222009 to solve ora00001 to fgic2533
      /*IF variables.for_delete = 'Y' THEN
          UPDATE giex_expiry
             SET ren_tsi_amt = v_tot_ren_tsi,
                 ren_prem_amt = v_tot_ren_prem
           WHERE policy_id = :b240.policy_id;
      END IF;     */
    END;
    
    PROCEDURE POPULATE_PERIL2(
        p_pack_pol_flag     giis_line.pack_pol_flag%TYPE,
        p_subline_cd        giex_itmperil.subline_cd%TYPE,
        p_policy_id         giex_itmperil.policy_id%TYPE,
        p_for_delete        VARCHAR2
    ) 
    IS
    --v_dep_pct         NUMBER(3,2); joanne
    v_tot_ren_tsi  giex_expiry.ren_tsi_amt%TYPE:=0;
    v_tot_ren_prem giex_expiry.ren_prem_amt%TYPE:=0;
    --added by joanne 01.18.14
    v_round_off            giis_parameters.param_value_n%TYPE;
    v_apply_dep            VARCHAR2 (1);
    v_temp_tsi             giex_old_group_peril.tsi_amt%TYPE;
    v_temp_prem            giex_old_group_peril.prem_amt%TYPE;
    v_temp_currency_tsi    giex_old_group_peril.orig_tsi_amt%TYPE;
    v_temp_currency_prem   giex_old_group_peril.currency_prem_amt%TYPE;
      
    BEGIN 
       --added by joanne 01.18.14, get value of round off parameter  
       BEGIN
          SELECT DECODE (param_value_n,
                         10, -1,
                         100, -2,
                         1000, -3,
                         10000, -4,
                         100000, -5,
                         1000000, -6,
                         9
                        )
            INTO v_round_off
            FROM giis_parameters
           WHERE param_name = 'ROUND_OFF_PLACE';
       EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
             v_round_off := 9;
       END;
       --added by joanne 01.18.14, get value of depreciation parameter
       v_apply_dep := NVL (giisp.v ('AUTO_COMPUTE_MC_DEP'), 'N');
      
      --v_dep_pct := Giisp.n('MC_DEP_PCT')/100; joanne
      FOR DATA IN (SELECT a.peril_cd,      --a.ann_prem_amt prem_amt,        a.ann_tsi_amt tsi_amt,
                          a.prem_amt,       a.tsi_amt,  --added by joanne 01.18.14, get prem and tsi not annual amts 
                          a.prem_rt,       a.comp_rem,                     b.item_title,
                          a.line_cd,       a.item_no,                      b.currency_rt,
                          NVL(a.ann_tsi_amt, a.tsi_amt) ann_tsi_amt,
                          NVL(a.ann_prem_amt,a.prem_amt) ann_prem_amt,
                          DECODE(NVL(p_pack_pol_flag, 'N'), 'N', p_subline_cd,b.pack_subline_cd) subline_cd
                     FROM gipi_itmperil a, gipi_item b
                    WHERE a.policy_id = b.policy_id
                      AND a.item_no = b.item_no
                      AND a.policy_id = p_policy_id)
      LOOP
       /*Modified by :Joanne 
       **Date:01.18.14
       **Deascription: comment codes for computation of TSI and Premium, 
       **              replace by code below to apply round off and depreciation*/
       /*FOR a IN (
       SELECT rate/100 rate --'1'     joanne            
                 FROM giex_dep_perl b
              WHERE b.line_cd  = data.line_cd
                AND b.peril_cd = data.peril_cd
                AND Giisp.v('AUTO_COMPUTE_MC_DEP') = 'Y')
        LOOP            
            data.tsi_amt      := data.tsi_amt - (data.tsi_amt*a.rate);
            data.ann_tsi_amt  := data.ann_tsi_amt - (data.ann_tsi_amt*a.rate);
            --data.prem_amt     := data.tsi_amt * (data.prem_rt/100);
            --data.ann_prem_amt := data.tsi_amt * (data.prem_rt/100);
            data.prem_amt     := data.ann_prem_amt - (data.ann_prem_amt*a.rate/);
            data.ann_prem_amt := data.ann_prem_amt - (data.ann_prem_amt*a.rate/);
        END LOOP;
        
        data.prem_rt := ((NVL(data.prem_amt,0) / NVL(data.tsi_amt,0)) * 100); --added by gmi 101107
        
        IF p_for_delete = 'Y' THEN
            v_tot_ren_tsi  := v_tot_ren_tsi + data.ann_tsi_amt;
            v_tot_ren_prem := v_tot_ren_prem + data.ann_prem_amt;
        ELSE    
            INSERT INTO giex_itmperil(
                          policy_id,         item_no,        peril_cd, 
                          line_cd,           tsi_amt,        prem_amt,
                          prem_rt,           ann_tsi_amt,    ann_prem_amt,
                          item_title,        comp_rem,       subline_cd, 
                          currency_rt)
                   VALUES(p_policy_id,       data.item_no,      data.peril_cd,
                          data.line_cd,      data.tsi_amt,      data.prem_amt,
                          data.prem_rt,      data.ann_tsi_amt,  data.ann_prem_amt,
                          data.item_title,   data.comp_rem,     data.subline_cd,
                          data.currency_rt    );
        END IF;*/
        -- codes added start here, 01.18,14
        -- if zero si prem_rt (which is most probably due to the reason n standard tariff rates applied sa knya and/or gumana sa knya ung minimum premium.
        -- then recalculate ung prem_rt based on accumulated tsi/prem. Under GUC discussion pa ano ung final handling ng ganitong type of records.
        IF data.prem_rt = 0 THEN
          data.prem_rt := (data.prem_amt / data.tsi_amt) * 100;
        END IF;
           
        v_temp_tsi :=  data.tsi_amt;
        v_temp_currency_tsi := data.tsi_amt * data.currency_rt;    
                
       -- get the depreciation rate
       /*IF v_apply_dep = 'Y' THEN
          FOR a IN (SELECT NVL (rate, 0) rate
                      FROM giex_dep_perl
                     WHERE line_cd = data.line_cd
                       AND peril_cd = data.peril_cd)
          LOOP
             IF a.rate <> 0 THEN 
                 v_temp_tsi :=
                    ROUND ((  v_temp_tsi
                            - (v_temp_tsi * (a.rate / 100))
                           ),
                           v_round_off 
                          );
                                      
                 v_temp_currency_tsi :=
                    ROUND ((  v_temp_currency_tsi
                            - (  v_temp_currency_tsi
                               * (a.rate / 100)
                              )
                           ),
                            v_round_off 
                          );
             END IF; 
          END LOOP;
       ELSE
            v_temp_tsi :=  ROUND (v_temp_tsi, v_round_off );
            v_temp_currency_tsi := ROUND (v_temp_currency_tsi, v_round_off );     
       END IF;*/ --benjo 11.23.2016 UCPBGEN-SR-23130 comment out
       
       compute_depreciation_amounts (p_policy_id, DATA.item_no, DATA.line_cd, DATA.peril_cd, v_temp_currency_tsi); --benjo 11.23.2016 UCPBGEN-SR-23130
       compute_depreciation_amounts (p_policy_id, DATA.item_no, DATA.line_cd, DATA.peril_cd, v_temp_tsi); --benjo 11.23.2016 UCPBGEN-SR-23130
            
       v_temp_currency_prem := v_temp_currency_tsi * (data.prem_rt / 100);
       v_temp_prem := v_temp_tsi * (data.prem_rt / 100);
                           
      IF p_for_delete = 'Y' THEN
            v_tot_ren_tsi  := v_tot_ren_tsi  + v_temp_currency_tsi;
            v_tot_ren_prem := v_tot_ren_prem + v_temp_currency_prem;
      ELSE                            
        INSERT INTO giex_itmperil (
                         policy_id,         item_no,        peril_cd, 
                         line_cd,           tsi_amt,        prem_amt,
                         prem_rt,           ann_tsi_amt,    ann_prem_amt,
                         comp_rem,          item_title,     subline_cd,
                         currency_rt)
                  VALUES(p_policy_id,       data.item_no,           data.peril_cd,
                         data.line_cd,      v_temp_tsi,             v_temp_prem, --v_temp_currency_tsi,    v_temp_currency_prem, joanne 02.04.14
                         data.prem_rt,      v_temp_tsi,             v_temp_prem, --v_temp_currency_tsi,    v_temp_currency_prem, joanne 02.04.14
                         data.comp_rem,      data.item_title,       data.subline_cd,
                         data.currency_rt );              
      END IF;                  
    END LOOP;
      /*IF variables.for_delete = 'Y' THEN
        UPDATE giex_expiry
           SET ren_tsi_amt = v_tot_ren_tsi,
               ren_prem_amt = v_tot_ren_prem
         WHERE policy_id = :b240.policy_id;
      END IF;*/
    END;
    
    PROCEDURE INITIAL_CREATE_PERIL(
        p_policy_id       IN     giex_expiry.policy_id%TYPE,
        p_pack_policy_id  IN     giex_expiry.pack_policy_id%TYPE,
        p_summary_sw      IN     giex_expiry.summary_sw%TYPE,
        p_line_cd         IN     gipi_polbasic.line_cd%TYPE,
        p_subline_cd      IN     gipi_polbasic.subline_cd%TYPE,
        p_iss_cd          IN     gipi_polbasic.iss_cd%TYPE,
        p_nbt_issue_yy    IN     gipi_polbasic.issue_yy%TYPE,
        p_nbt_pol_seq_no  IN     gipi_polbasic.pol_seq_no%TYPE,
        p_nbt_renew_no    IN     gipi_polbasic.renew_no%TYPE,
        p_pack_pol_flag   IN     giis_line.pack_pol_flag%TYPE,
        p_item_no         IN     giex_itmperil.item_no%TYPE,
        p_grouped_item_no IN     giex_itmperil_grouped.grouped_item_no%TYPE,
        p_recompute_tax   IN     VARCHAR2,
        p_tax_sw          IN     VARCHAR2,
        p_for_delete      IN OUT VARCHAR2,
        p_nbt_prem_amt       OUT giex_itmperil.prem_amt%TYPE,
        p_ann_prem_amt       OUT giex_itmperil.ann_prem_amt%TYPE,
        p_nbt_tsi_amt        OUT giex_itmperil.tsi_amt%TYPE,
        p_ann_tsi_amt        OUT giex_itmperil.ann_tsi_amt%TYPE
    ) 
    IS
      v_exists BOOLEAN := FALSE;
      v_is_gpa VARCHAR2(1);
    BEGIN        
        FOR i IN (SELECT DISTINCT 1
                    FROM giex_expiry a, giex_itmperil b
                   WHERE a.policy_id = b.policy_id
                     AND a.policy_id <> p_policy_id
                     AND a.pack_policy_id = p_pack_policy_id)
        LOOP        
            v_exists := TRUE;        
        END LOOP;
        --go_block('b240');
        --COMMIT;    
        IF NOT v_exists THEN
          LOOP
              --next_record;
              v_is_gpa := 'N';
              FOR a IN (SELECT 1
                          FROM gipi_itmperil_grouped
                         WHERE policy_id = p_policy_id) 
                LOOP
                    v_is_gpa := 'Y';
                END LOOP;
                IF v_is_gpa = 'N' THEN
                  IF NVL(p_summary_sw, 'N') = 'Y' THEN
                     giex_itmperil_pkg.populate_peril(p_line_cd, p_subline_cd, p_iss_cd, p_nbt_issue_yy, p_nbt_pol_seq_no, p_nbt_renew_no, p_policy_id, p_pack_pol_flag, p_for_delete);
                  ELSE
                     giex_itmperil_pkg.populate_peril2(p_pack_pol_flag, p_subline_cd, p_policy_id, p_for_delete);
                  END IF;
                  --joanne 060314, add parameters
                  giex_itmperil_pkg.update_witem_giexs007(p_policy_id, p_item_no, p_recompute_tax, p_tax_sw, 'Y', p_summary_sw, p_nbt_prem_amt, p_ann_prem_amt, p_nbt_tsi_amt, p_ann_tsi_amt);
                ELSE

                  IF NVL(p_summary_sw, 'N') = 'Y' THEN
                     giex_itmperil_grouped_pkg.populate_peril_grp(p_line_cd, p_subline_cd, p_iss_cd, p_nbt_issue_yy, p_nbt_pol_seq_no, p_nbt_renew_no, p_policy_id, p_pack_pol_flag, p_for_delete);
                  ELSE
                     giex_itmperil_grouped_pkg.populate_peril2_grp(p_pack_pol_flag, p_subline_cd, p_policy_id, p_for_delete);
                  END IF;
                  giex_itmperil_grouped_pkg.update_witem_grp(p_policy_id, p_item_no, p_grouped_item_no, p_recompute_tax, p_tax_sw, p_nbt_prem_amt, p_ann_prem_amt, p_nbt_tsi_amt, p_ann_tsi_amt);              
                END IF;
                --EXIT WHEN :system.last_record = 'TRUE';
                --go_block('b240');
                --COMMIT;
          END LOOP;
          --go_block('b240');
          --FIRST_RECORD;
           /*v_is_gpa := 'N';
           FOR a IN (SELECT 1
                        FROM gipi_itmperil_grouped
                       WHERE policy_id = p_policy_id) 
            LOOP
                variables.is_gpa := 'Y';
            END LOOP;
            IF variables.is_gpa = 'Y' THEN
               GO_BLOCK('B480_GRP');
            ELSE      
               GO_BLOCK('B480');      
            END IF;
          EXECUTE_QUERY;*/
        END IF;  
    END;
    
    PROCEDURE DELETE_EXPIRY_PERILS(
        p_policy_id       IN     giex_expiry.policy_id%TYPE
    ) IS
    
    BEGIN
    	DELETE giex_itmperil
         WHERE policy_id = p_policy_id;

	    DELETE giex_new_group_peril
	     WHERE policy_id = p_policy_id;
	
	    DELETE giex_new_group_tax
	     WHERE policy_id = p_policy_id;
        
        --added by joanne, 06092014 
        DELETE giex_new_group_deductibles
	     WHERE policy_id = p_policy_id; 
    END;
    
    PROCEDURE CREATE_PERIL(
        p_policy_id       IN     giex_expiry.policy_id%TYPE,
        p_pack_policy_id  IN     giex_expiry.pack_policy_id%TYPE,
        p_summary_sw      IN     giex_expiry.summary_sw%TYPE,
        p_line_cd         IN     gipi_polbasic.line_cd%TYPE,
        p_subline_cd      IN     gipi_polbasic.subline_cd%TYPE,
        p_iss_cd          IN     gipi_polbasic.iss_cd%TYPE,
        p_nbt_issue_yy    IN     gipi_polbasic.issue_yy%TYPE,
        p_nbt_pol_seq_no  IN     gipi_polbasic.pol_seq_no%TYPE,
        p_nbt_renew_no    IN     gipi_polbasic.renew_no%TYPE,
        p_pack_pol_flag   IN     giis_line.pack_pol_flag%TYPE,
        p_item_no         IN     giex_itmperil.item_no%TYPE,
        p_grouped_item_no IN     giex_itmperil_grouped.grouped_item_no%TYPE,
        p_recompute_tax   IN     VARCHAR2,
        p_tax_sw          IN     VARCHAR2,
        p_for_delete      IN OUT VARCHAR2,
        p_nbt_prem_amt       OUT giex_itmperil.prem_amt%TYPE,
        p_ann_prem_amt       OUT giex_itmperil.ann_prem_amt%TYPE,
        p_nbt_tsi_amt        OUT giex_itmperil.tsi_amt%TYPE,
        p_ann_tsi_amt        OUT giex_itmperil.ann_tsi_amt%TYPE
    )
    IS
    BEGIN
      /*GO_BLOCK('B490');        
      IF :b490.peril_cd IS NOT NULL THEN
         alert_id   := FIND_ALERT('DEFAULT');
         alert_but  := SHOW_ALERT(ALERT_ID);
         IF alert_but = ALERT_BUTTON1 THEN 
            variables.for_delete := 'N'; -- added by aaron 052209
            NULL;
         ELSE
            RAISE FORM_TRIGGER_FAILURE;
         END IF;
      END IF; 
      CLEAR_BLOCK(NO_VALIDATE);
      GO_BLOCK('B480');
      CLEAR_BLOCK(NO_VALIDATE);

      rg_id := Find_Group( 'EXISTING_PERILS' ); 

      IF NOT Id_Null(rg_id) THEN 
        Delete_Group( rg_id ); 
      END IF; 
      */
      /*DELETE giex_itmperil
       WHERE policy_id = p_policy_id;

      DELETE giex_new_group_peril
       WHERE policy_id = p_policy_id;

      DELETE giex_new_group_tax
       WHERE policy_id = p_policy_id;*/

      --FORMS_DDL('COMMIT');   
      IF NVL(p_summary_sw, 'N') = 'Y' THEN
           --pause; --jenny vi lim 03312005
         giex_itmperil_pkg.populate_peril(p_line_cd, p_subline_cd, p_iss_cd, p_nbt_issue_yy, p_nbt_pol_seq_no, p_nbt_renew_no, p_policy_id, p_pack_pol_flag, p_for_delete);
      ELSE
         giex_itmperil_pkg.populate_peril2(p_pack_pol_flag, p_subline_cd, p_policy_id, p_for_delete); 
      END IF;
      --giex_itmperil_pkg.update_witem_giexs007(p_policy_id, p_item_no, p_recompute_tax, p_tax_sw, p_nbt_prem_amt, p_ann_prem_amt, p_nbt_tsi_amt, p_ann_tsi_amt);
          
      --ADDED BY JOANNE 011314, populate expiry taxes
      --compute_uwtaxesexpiry.compute_new_group_tax2(p_policy_id, p_line_cd, p_subline_cd, p_iss_cd);      
      
        --DELETE FROM giex_new_group_deductibles
          --WHERE policy_id = p_policy_id; --joanne 112613
      
      --populate_expiry_deductible(p_policy_id, p_summary_sw); -- joanne 112513 --comment by joanne 04/15/14
      --FORMS_DDL('COMMIT');   
      --update_tsi_per_peril;
      --FORMS_DDL('COMMIT');   

      --GO_BLOCK('B480');
      --EXECUTE_QUERY;

      --CLEAR_MESSAGE;
     -- CHECK_FOR_EXISTING_GROUP('EXISTING_PERILS');
      --SET_ITEM_PROPERTY('CONTROL.CREATE_PERIL',LABEL,'Recreate Peril(s)');
      --SET_ITEM_PROPERTY('CONTROL.DELETE_PERIL',ENABLED, PROPERTY_TRUE);
      --SET_ITEM_PROPERTY('CONTROL.EDIT_TAX_CHARGES',ENABLED, PROPERTY_TRUE);
      --SET_ITEM_PROPERTY('CONTROL.EDIT_DEDUCTIBLES',ENABLED, PROPERTY_TRUE);
      --:B490.PREM_AMT := :B490.PREM_AMT; 
      /*giex_itmperil_pkg.initial_create_peril(p_policy_id, p_pack_policy_id, p_summary_sw, p_line_cd, p_subline_cd, p_iss_cd, p_nbt_issue_yy,
                                             p_nbt_pol_seq_no, p_nbt_renew_no, p_pack_pol_flag, p_item_no, p_grouped_item_no, p_recompute_tax,
                                             p_tax_sw, p_for_delete, p_nbt_prem_amt, p_ann_prem_amt, p_nbt_tsi_amt, p_ann_tsi_amt);*/
    END;
    
    PROCEDURE DELETE_PERIL(
        p_policy_id       IN     giex_expiry.policy_id%TYPE,
        p_summary_sw      IN     giex_expiry.summary_sw%TYPE,
        p_line_cd         IN     gipi_polbasic.line_cd%TYPE,
        p_subline_cd      IN     gipi_polbasic.subline_cd%TYPE,
        p_iss_cd          IN     gipi_polbasic.iss_cd%TYPE,
        p_nbt_issue_yy    IN     gipi_polbasic.issue_yy%TYPE,
        p_nbt_pol_seq_no  IN     gipi_polbasic.pol_seq_no%TYPE,
        p_nbt_renew_no    IN     gipi_polbasic.renew_no%TYPE,
        p_pack_pol_flag   IN     giis_line.pack_pol_flag%TYPE
    )
    IS
        v_for_delete VARCHAR2(1);
    BEGIN
      /*GO_BLOCK('B490');
      IF :b490.peril_cd IS NOT NULL THEN
         alert_id   := FIND_ALERT('DELETE');
         alert_but  := SHOW_ALERT(ALERT_ID);
         IF alert_but = ALERT_BUTTON1 THEN 
            NULL;
         ELSE
            RAISE FORM_TRIGGER_FAILURE;
         END IF;
      END IF; 
      CLEAR_BLOCK(NO_VALIDATE);
      GO_BLOCK('B480');
      CLEAR_BLOCK(NO_VALIDATE);*/
      
      DELETE giex_itmperil
       WHERE policy_id = p_policy_id;
       
      DELETE giex_new_group_peril
       WHERE policy_id = p_policy_id;
       
      DELETE giex_new_group_tax
       WHERE policy_id = p_policy_id;
       
      v_for_delete := 'Y'; 
      
      IF NVL(p_summary_sw, 'N') = 'Y' THEN
           --pause; --jenny vi lim 03312005
         giex_itmperil_pkg.populate_peril(p_line_cd, p_subline_cd, p_iss_cd, p_nbt_issue_yy, p_nbt_pol_seq_no, p_nbt_renew_no, p_policy_id, p_pack_pol_flag, v_for_delete);
      ELSE
         giex_itmperil_pkg.populate_peril2(p_pack_pol_flag, p_subline_cd, p_policy_id, v_for_delete);
      END IF;
      
      v_for_delete := 'N';
      /*GO_BLOCK('B480');
      EXECUTE_QUERY;
      CLEAR_MESSAGE;
      SET_ITEM_PROPERTY('CONTROL.CREATE_PERIL',LABEL,'Create Peril(s)');
      SET_ITEM_PROPERTY('CONTROL.DELETE_PERIL',ENABLED, PROPERTY_FALSE);
      SET_ITEM_PROPERTY('CONTROL.EDIT_TAX_CHARGES',ENABLED, PROPERTY_FALSE);
      SET_ITEM_PROPERTY('CONTROL.EDIT_DEDUCTIBLES',ENABLED, PROPERTY_FALSE);
      :B240.POLICY_ID := :B240.POLICY_ID;*/
    END;
    
    PROCEDURE set_b490_dtls (
        p_policy_id         giex_itmperil.policy_id%TYPE,
        p_item_no           giex_itmperil.item_no%TYPE,
        p_peril_cd          giex_itmperil.peril_cd%TYPE,
        p_line_cd           giex_itmperil.line_cd%TYPE,
        p_prem_rt           giex_itmperil.prem_rt%TYPE,
        p_prem_amt          giex_itmperil.prem_amt%TYPE,
        p_tsi_amt           giex_itmperil.tsi_amt%TYPE,
        p_comp_rem          giex_itmperil.comp_rem%TYPE,
        p_item_title        giex_itmperil.item_title%TYPE,
        p_ann_tsi_amt       giex_itmperil.ann_tsi_amt%TYPE,
        p_ann_prem_amt      giex_itmperil.ann_prem_amt%TYPE,
        p_subline_cd        giex_itmperil.subline_cd%TYPE,
        p_currency_rt       giex_itmperil.currency_rt%TYPE
    ) 
    IS
    BEGIN
        MERGE INTO giex_itmperil
        USING dual ON (policy_id    = p_policy_id AND
                       item_no      = p_item_no      AND
                       peril_cd     = p_peril_cd)
         WHEN NOT MATCHED THEN
            INSERT (
                line_cd,        prem_rt,        prem_amt,       tsi_amt,        comp_rem,   
                item_title,     ann_tsi_amt,    ann_prem_amt,   subline_cd,     currency_rt,
                policy_id,      item_no,        peril_cd
            )
            VALUES (
                p_line_cd,      p_prem_rt,      p_prem_amt,     p_tsi_amt,      p_comp_rem,   
                p_item_title,   p_ann_tsi_amt,  p_ann_prem_amt, p_subline_cd,   p_currency_rt,
                p_policy_id,    p_item_no,      p_peril_cd
            )
            WHEN MATCHED THEN
            UPDATE SET  line_cd         = p_line_cd,
                        prem_rt         = p_prem_rt,
                        prem_amt        = p_prem_amt,
                        tsi_amt         = p_tsi_amt,
                        comp_rem        = p_comp_rem,
                        item_title      = p_item_title,
                        ann_tsi_amt     = p_ann_tsi_amt,
                        ann_prem_amt    = p_ann_prem_amt,
                        subline_cd      = p_subline_cd,
                        currency_rt     = p_currency_rt;
    END set_b490_dtls;
    
    PROCEDURE GIEXS007_POST_FORMS_COMMIT(
        P_POLICY_ID      GIPI_POLBASIC.policy_id%TYPE,
        P_PACK_POLICY_ID GIPI_POLBASIC.pack_policy_id%TYPE
    )
    IS
        v_msg_1 giex_itmperil.prem_amt%TYPE:=NULL;
        v_msg_2 giex_itmperil.prem_amt%TYPE:=NULL;
        v_msg_3 giex_itmperil.tsi_amt%TYPE:=NULL;  
        v_msg_4 giex_itmperil.tsi_amt%TYPE:=NULL;  
        v_msg_5 giex_expiry.tax_amt%TYPE:=NULL;  --added by joanne 052014, for tax 
        v_msg_6 giex_expiry.tax_amt%TYPE:=NULL;  --added by joanne 052014, for tax
        v_msg_7 giex_expiry.tax_amt%TYPE:=NULL;  --added by joanne 052014, for currency_prem
        v_msg_8 giex_expiry.tax_amt%TYPE:=NULL;  --added by joanne 052014, for currency_prem
    BEGIN
        SELECT SUM(prem_amt)
          INTO v_msg_1
          FROM GIEX_OLD_GROUP_PERIL
         WHERE policy_id = P_POLICY_ID;
         
        SELECT SUM(prem_amt)
          INTO v_msg_2
          FROM GIEX_NEW_GROUP_PERIL
         WHERE policy_id = P_POLICY_ID;
     
         SELECT SUM(a.tsi_amt)
          INTO v_msg_3
          FROM GIEX_OLD_GROUP_PERIL a, GIIS_PERIL b
         WHERE a.policy_id = P_POLICY_ID
           AND a.line_cd = b.line_cd
           AND a.peril_cd = b.peril_cd
           AND b.peril_type = 'B';
         
         SELECT SUM(a.tsi_amt)
          INTO v_msg_4
          FROM GIEX_NEW_GROUP_PERIL a, GIIS_PERIL b
         WHERE a.policy_id = P_POLICY_ID
           AND a.line_cd = b.line_cd
           AND a.peril_cd = b.peril_cd
           AND b.peril_type = 'B';
           
        --added by joanne 052014, for tax
        SELECT SUM(tax_amt)
          INTO v_msg_5
          FROM giex_old_group_tax
         WHERE policy_id = P_POLICY_ID;
         
        SELECT SUM(tax_amt)
          INTO v_msg_6
          FROM giex_new_group_tax
         WHERE policy_id = P_POLICY_ID;   
        --end by joanne
        
        --added by joanne 052814, for currency_prem
        SELECT SUM(ren_prem_amt)
          INTO v_msg_7
          FROM giex_old_group_itmperil
         WHERE policy_id = P_POLICY_ID;
         
        SELECT SUM(prem_amt)
          INTO v_msg_8
          FROM giex_itmperil
         WHERE policy_id = P_POLICY_ID;  
        --end by joanne
        
        UPDATE giex_expiry
           SET ren_prem_amt = NVL(v_msg_2, v_msg_1),
               ren_tsi_amt = NVL(v_msg_4, v_msg_3),
               tax_amt   = NVL(v_msg_6, v_msg_5),  --added by joanne 052014, for tax  
               currency_prem_amt = NVL(v_msg_8, v_msg_7)  --added by joanne 052814, for currency_prem         
         WHERE policy_id = P_POLICY_ID;
         
        UPDATE giex_pack_expiry
           SET ren_prem_amt = (SELECT SUM(ren_prem_amt) ren_prem_amt
                                 FROM giex_expiry
                                WHERE pack_policy_id = NVL(P_PACK_POLICY_ID,0)),
               ren_tsi_amt = (SELECT SUM(ren_tsi_amt) ren_prem_amt
                                FROM giex_expiry
                               WHERE pack_policy_id = NVL(P_PACK_POLICY_ID,0)),
               --added by joanne 052014, for tax                
               tax_amt =  (SELECT SUM(tax_amt) tax_amt
                                FROM giex_expiry
                               WHERE pack_policy_id = NVL(P_PACK_POLICY_ID,0)),
               --added by joanne 052814, for currency_prem                
               currency_prem_amt =  (SELECT SUM(currency_prem_amt) currency_prem_amt
                                        FROM giex_expiry
                                       WHERE pack_policy_id = NVL(P_PACK_POLICY_ID,0))                                                 
         WHERE pack_policy_id = NVL(P_PACK_POLICY_ID,0);	
    END;

    /*Created by: Gzelle 01292015
    ** Referenced by: process_expiring_policies
    */
    PROCEDURE compute_tax (
       p_policy_id        gipi_polbasic.policy_id%TYPE
    )
    IS
       v_count                NUMBER                                      := 0;
       v_vat_tag              giis_assured.vat_tag%TYPE;
       v_place_cd             gipi_polbasic.place_cd%TYPE;
       v_depr_tax_amt         giex_new_group_tax.tax_amt%TYPE             := 0;
       v_curr_tax_amt         giex_new_group_tax.currency_tax_amt%TYPE    := 0;
       v_currency_rt          giex_old_group_itmperil.currency_rt%TYPE    := 1;
       gogi_currency_cd       giex_old_group_itmperil.currency_cd%TYPE;
       gogi_ren_tsi_amt       giex_old_group_itmperil.ren_tsi_amt%TYPE    := 0;
       gogi_ren_prem_amt      giex_old_group_itmperil.ren_prem_amt%TYPE   := 0;
       gogi_currency_rt       giex_old_group_itmperil.currency_rt%TYPE;
       --kenneth 06.23.2015 SR 19458
       gi_tsi_amt             giex_itmperil.tsi_amt%TYPE    := 0;
       gi_prem_amt            giex_itmperil.prem_amt%TYPE   := 0;
       gi_currency_rt         giex_itmperil.currency_rt%TYPE;
       --end
       v_is_new               VARCHAR2 (1);
       v_tax_type             giis_tax_charges.tax_type%TYPE;
       v_primary_sw           giis_tax_charges.primary_sw%TYPE;
       v_rate                 giis_tax_charges.rate%TYPE;
       v_endt_tax             gipi_endttext.endt_tax%TYPE;
       v_cancelled            VARCHAR2 (1);
       v_def_is_pol_summ_sw   giis_parameters.param_value_v%TYPE := giisp.v ('EXPIRY_DEFAULT_IS_POL_SUMMARY');
       v_old_doc_stamps       giis_parameters.param_value_v%TYPE := giisp.v ('COMPUTE_OLD_DOC_STAMPS');
       v_doc_stamps           giac_parameters.param_value_v%TYPE := giacp.n ('DOC_STAMPS');
       v_pa_doc_stamps        giis_parameters.param_value_v%TYPE := giisp.v ('COMPUTE_PA_DOC_STAMPS');
       v_evat                 giac_parameters.param_value_v%TYPE := giacp.n ('EVAT');
    BEGIN
       FOR a2 IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                         renew_no, auto_renew_flag, policy_id, reg_policy_sw,
                         ref_pol_no
                    FROM gipi_polbasic
                   WHERE policy_id = p_policy_id AND pack_policy_id IS NULL)
       LOOP
          SELECT NVL (a.vat_tag, '3'), b.place_cd
            INTO v_vat_tag, v_place_cd
            FROM giis_assured a, gipi_polbasic b
           WHERE a.assd_no = b.assd_no AND b.policy_id = a2.policy_id;

          FOR gogi IN (SELECT currency_cd, currency_rt, ren_tsi_amt, ren_prem_amt
                         FROM giex_old_group_itmperil
                        WHERE policy_id = a2.policy_id)
          LOOP
             gogi_currency_cd := gogi.currency_cd;
--             gogi_ren_tsi_amt := gogi_ren_tsi_amt + gogi.ren_tsi_amt; --replaced by kenneth 06.23.2015 SR 19458
--             gogi_ren_prem_amt := gogi_ren_prem_amt + gogi.ren_prem_amt;
--             gogi_currency_rt := gogi.currency_rt;
          END LOOP;
          
          --added to retrieve latest amounts kenneth 06.23.2015 SR 19458
          FOR gi IN (SELECT currency_rt, tsi_amt, prem_amt
                         FROM giex_itmperil
                        WHERE policy_id = a2.policy_id)
          LOOP
             gi_tsi_amt := gi_tsi_amt + gi.tsi_amt;
             gi_prem_amt := gi_prem_amt + gi.prem_amt;
             gi_currency_rt := gi.currency_rt;
          END LOOP;
          --end

          FOR endt IN (SELECT endt_tax
                         FROM gipi_endttext
                        WHERE policy_id IN (
                                 SELECT policy_id
                                   FROM gipi_polbasic f
                                  WHERE f.line_cd = a2.line_cd
                                    AND f.subline_cd = a2.subline_cd
                                    AND f.iss_cd = a2.iss_cd
                                    AND f.issue_yy = a2.issue_yy
                                    AND f.pol_seq_no = a2.pol_seq_no
                                    AND f.renew_no = a2.renew_no))
          LOOP
             IF endt.endt_tax = 'Y'
             THEN
                v_endt_tax := endt.endt_tax;
                EXIT;
             END IF;
          END LOOP;

          FOR gpol IN (SELECT   b.currency_cd, c.line_cd, c.tax_cd, d.tax_id,
                                c.iss_cd, e.menu_line_cd, f.expiry_date,
                                d.tax_desc, d.rate rate, d.peril_sw, tax_type,
                                tax_amount, d.expired_sw, 'N' is_new
                           FROM gipi_polbasic f,
                                gipi_invoice b,
                                gipi_inv_tax c,
                                giis_tax_charges d,
                                giis_line e
                          WHERE f.line_cd = a2.line_cd
                            AND f.subline_cd = a2.subline_cd
                            AND f.iss_cd = a2.iss_cd
                            AND f.issue_yy = a2.issue_yy
                            AND f.pol_seq_no = a2.pol_seq_no
                            AND f.renew_no = a2.renew_no
                            AND b.policy_id = f.policy_id
                            AND b.iss_cd = c.iss_cd
                            AND b.prem_seq_no = c.prem_seq_no
                            AND c.tax_cd = d.tax_cd
                            AND c.iss_cd = d.iss_cd
                            AND c.line_cd = d.line_cd
                            AND f.line_cd = e.line_cd
                            AND (   NVL (d.expired_sw, 'N') = 'N'
                                 OR (    EXISTS (
                                            SELECT '1'
                                              FROM giis_tax_charges z
                                             WHERE c.line_cd = z.line_cd
                                               AND c.iss_cd = z.iss_cd
                                               AND c.tax_cd = z.tax_cd
                                               AND c.tax_id < z.tax_id
                                               AND NVL (z.expired_sw, 'N') = 'N')
                                     AND NVL (d.expired_sw, 'N') = 'Y'
                                    )
                                )
                            AND f.expiry_date BETWEEN eff_start_date AND eff_end_date
                            AND (   pol_flag =
                                       DECODE (v_def_is_pol_summ_sw,
                                               'Y', '1',
                                               pol_flag
                                              )
                                 OR pol_flag =
                                       DECODE (v_def_is_pol_summ_sw,
                                               'Y', '2',
                                               pol_flag
                                              )
                                 OR pol_flag =
                                       DECODE (v_def_is_pol_summ_sw,
                                               'Y', '3',
                                               pol_flag
                                              )
                                )
                            AND endt_seq_no =
                                   DECODE (v_def_is_pol_summ_sw,
                                           'N', 0,
                                           endt_seq_no
                                          )
                            AND f.pack_policy_id IS NULL
                            AND (   f.endt_seq_no = 0
                                 OR (    f.endt_seq_no > 0
                                     AND TRUNC (f.endt_expiry_date) >=
                                                             TRUNC (f.expiry_date)
                                    )
                                )
                            AND b.currency_cd = gogi_currency_cd
                       GROUP BY b.currency_cd,
                                c.line_cd,
                                c.tax_cd,
                                d.tax_id,
                                c.iss_cd,
                                d.tax_desc,
                                d.rate,
                                d.peril_sw,
                                e.menu_line_cd,
                                tax_type,
                                tax_amount,
                                f.expiry_date,
                                d.expired_sw
                       UNION
                       SELECT   b.currency_cd, f.line_cd, d.tax_cd, d.tax_id,
                                d.iss_cd, e.menu_line_cd, f.expiry_date,
                                d.tax_desc, d.rate rate, d.peril_sw, tax_type,
                                tax_amount, d.expired_sw, 'Y' is_new
                           FROM gipi_polbasic f,
                                gipi_invoice b,
                                giis_tax_charges d,
                                giis_line e
                          WHERE f.line_cd = a2.line_cd
                            AND f.subline_cd = a2.subline_cd
                            AND f.iss_cd = a2.iss_cd
                            AND f.issue_yy = a2.issue_yy
                            AND f.pol_seq_no = a2.pol_seq_no
                            AND f.renew_no = a2.renew_no
                            AND f.policy_id = b.policy_id
                            AND f.line_cd = d.line_cd
                            AND f.line_cd = e.line_cd
                            AND f.iss_cd = d.iss_cd
                            AND NVL (d.expired_sw, 'N') = 'N'
                            AND d.primary_sw = 'Y'
                            AND f.expiry_date BETWEEN eff_start_date AND eff_end_date
                            AND (   pol_flag =
                                       DECODE (v_def_is_pol_summ_sw,
                                               'Y', '1',
                                               pol_flag
                                              )
                                 OR pol_flag =
                                       DECODE (v_def_is_pol_summ_sw,
                                               'Y', '2',
                                               pol_flag
                                              )
                                 OR pol_flag =
                                       DECODE (v_def_is_pol_summ_sw,
                                               'Y', '3',
                                               pol_flag
                                              )
                                )
                            AND endt_seq_no =
                                   DECODE (v_def_is_pol_summ_sw,
                                           'N', 0,
                                           endt_seq_no
                                          )
                            AND f.pack_policy_id IS NULL
                            AND (   f.endt_seq_no = 0
                                 OR (    f.endt_seq_no > 0
                                     AND TRUNC (f.endt_expiry_date) >=
                                                             TRUNC (f.expiry_date)
                                    )
                                )
                            AND b.currency_cd = gogi_currency_cd
                       GROUP BY b.currency_cd,
                                f.line_cd,
                                d.tax_cd,
                                d.tax_id,
                                d.iss_cd,
                                d.tax_desc,
                                d.rate,
                                d.peril_sw,
                                e.menu_line_cd,
                                tax_type,
                                tax_amount,
                                f.expiry_date,
                                d.expired_sw)
          LOOP
             v_currency_rt := gi_currency_rt; --kenneth 06.23.2015 SR 19458
             v_is_new := gpol.is_new;

             IF gpol.expired_sw = 'Y'
             THEN
                FOR k IN (SELECT tax_id
                            FROM giis_tax_charges
                           WHERE line_cd = gpol.line_cd
                             AND iss_cd = gpol.iss_cd
                             AND tax_cd = gpol.tax_cd
                             AND NVL (expired_sw, 'N') = 'N'
                             AND gpol.expiry_date BETWEEN eff_start_date
                                                      AND eff_end_date)
                LOOP
                   gpol.tax_id := k.tax_id;
                END LOOP;
             END IF;

             FOR tax IN (SELECT DISTINCT b.tax_cd tax_cd,
                                         NVL (NVL (c.rate, b.rate), 0) rate,
                                         b.tax_id tax_id, b.tax_type tax_type,
                                         b.tax_amount tax_amount,
                                         b.peril_sw peril_sw, b.tax_desc tax_desc,
                                         b.no_rate_tag, b.primary_sw
                                    FROM giis_tax_peril a,
                                         giis_tax_charges b,
                                         giis_tax_issue_place c
                                   WHERE b.line_cd = gpol.line_cd
                                     AND b.iss_cd(+) = gpol.iss_cd
                                     AND b.tax_cd = gpol.tax_cd
                                     AND b.tax_id = gpol.tax_id
                                     AND b.iss_cd = c.iss_cd(+)
                                     AND b.line_cd = c.line_cd(+)
                                     AND b.tax_cd = c.tax_cd(+)
                                     AND c.place_cd(+) = v_place_cd
                                     AND (   (    gpol.expiry_date
                                                     BETWEEN b.eff_start_date
                                                         AND b.eff_end_date
                                              AND NVL (b.issue_date_tag, 'N') =
                                                                               'N'
                                             )
                                          OR (    gpol.expiry_date
                                                     BETWEEN b.eff_start_date
                                                         AND b.eff_end_date
                                              AND NVL (b.issue_date_tag, 'N') =
                                                                               'Y'
                                             )
                                         ))
             LOOP
                v_tax_type := tax.tax_type;
                v_rate := tax.rate;
                v_primary_sw := tax.primary_sw;
                v_cancelled := '';

                IF v_endt_tax = 'Y'
                THEN
                   FOR cancl IN (SELECT SUM (b.tax_amt) tax_amt
                                   FROM gipi_invoice a,
                                        gipi_inv_tax b,
                                        gipi_polbasic c
                                  WHERE a.iss_cd = b.iss_cd
                                    AND a.prem_seq_no = b.prem_seq_no
                                    AND a.policy_id = c.policy_id
                                    AND c.line_cd = a2.line_cd
                                    AND c.subline_cd = a2.subline_cd
                                    AND c.iss_cd = a2.iss_cd
                                    AND c.issue_yy = a2.issue_yy
                                    AND c.pol_seq_no = a2.pol_seq_no
                                    AND c.renew_no = a2.renew_no
                                    AND b.tax_cd = tax.tax_cd
                                    AND (   c.endt_seq_no = 0
                                         OR (    c.endt_seq_no > 0
                                             AND TRUNC (c.endt_expiry_date) >=
                                                             TRUNC (c.expiry_date)
                                            )
                                        ))
                   LOOP
                      IF cancl.tax_amt = 0
                      THEN
                         v_cancelled := 'Y';
                      END IF;
                   END LOOP;
                END IF;

                IF tax.tax_cd = v_doc_stamps
                THEN                                        --docstamp computation
                   IF     tax.tax_type = 'N'
                      AND (gpol.menu_line_cd = 'AC' OR gpol.line_cd = 'AC')
                      AND v_pa_doc_stamps = '3'
                   THEN
                      FOR gtr IN (SELECT tax_amount
                                    FROM giis_tax_range
                                   WHERE line_cd = gpol.line_cd
                                     AND iss_cd = gpol.iss_cd
                                     AND tax_cd = tax.tax_cd
                                     AND tax_id = tax.tax_id
                                     AND (gi_tsi_amt * v_currency_rt) --kenneth 06.23.2015 SR 19458
                                            BETWEEN min_value
                                                AND max_value)
                      LOOP
                         v_depr_tax_amt := gtr.tax_amount;
                         v_curr_tax_amt := gtr.tax_amount / v_currency_rt;
                      END LOOP;
                   ELSE
                      IF (gpol.menu_line_cd = 'AC' OR gpol.line_cd = 'AC')
                      THEN
                         IF v_pa_doc_stamps = '2'
                         THEN
                            v_depr_tax_amt :=
                                 CEIL ((gi_prem_amt) / 200) * 0.5	--kenneth 06.23.2015 SR 19458
                               * gi_currency_rt;
                            v_curr_tax_amt :=
                                          CEIL (gi_prem_amt / 200) * 0.5;
                         ELSE
                            IF v_old_doc_stamps = 'Y'
                            THEN
                               v_depr_tax_amt :=
                                    CEIL ((gi_prem_amt) / 200) * 0.5	--kenneth 06.23.2015 SR 19458
                                  * gi_currency_rt;
                               v_curr_tax_amt :=
                                          CEIL ((gi_prem_amt) / 200) * 0.5;
                            ELSE
                               IF tax.peril_sw = 'Y'
                               THEN
                                  FOR perl IN
                                     (SELECT SUM (a.prem_amt) prem_amt	--kenneth 06.23.2015 SR 19458
                                        FROM giex_itmperil a,
                                             giis_tax_peril b
                                       WHERE a.line_cd = b.line_cd
                                         AND a.peril_cd = b.peril_cd
                                         AND a.policy_id = a2.policy_id
                                         AND b.tax_cd = tax.tax_cd
                                         AND b.line_cd = gpol.line_cd
                                         AND b.iss_cd = gpol.iss_cd
                                         AND b.tax_id = tax.tax_id)
                                  LOOP
                                     v_depr_tax_amt :=
                                          ((perl.prem_amt) * (tax.rate / 100)	--kenneth 06.23.2015 SR 19458
                                          )
                                        * gi_currency_rt;
                                     v_curr_tax_amt :=
                                              perl.prem_amt
                                              * (tax.rate / 100);
                                  END LOOP;
                               ELSE
                                  v_depr_tax_amt :=
                                       ((gi_prem_amt) * (tax.rate / 100)	--kenneth 06.23.2015 SR 19458
                                       )
                                     * gi_currency_rt;
                                  v_curr_tax_amt :=
                                              gi_prem_amt
                                              * (tax.rate / 100);
                               END IF;
                            END IF;
                         END IF;
                      ELSE                       --Non-PA computation of docstamps
                         IF v_old_doc_stamps = 'Y'
                         THEN
                            v_depr_tax_amt :=
                                 CEIL ((gi_prem_amt) / 4) * 0.5	--kenneth 06.23.2015 SR 19458
                               * gi_currency_rt;
                            v_curr_tax_amt :=
                                            CEIL (gi_prem_amt / 4) * 0.5;
                         ELSE
                            IF tax.peril_sw = 'Y'
                            THEN
                               FOR perl IN
                                  (SELECT SUM (a.prem_amt) prem_amt	--kenneth 06.23.2015 SR 19458
                                     FROM giex_itmperil a,
                                          giis_tax_peril b
                                    WHERE a.line_cd = b.line_cd
                                      AND a.peril_cd = b.peril_cd
                                      AND a.policy_id = a2.policy_id
                                      AND b.tax_cd = tax.tax_cd
                                      AND b.line_cd = gpol.line_cd
                                      AND b.iss_cd = gpol.iss_cd
                                      AND b.tax_id = tax.tax_id)
                               LOOP
                                  v_depr_tax_amt :=
                                       ((perl.prem_amt) * (tax.rate / 100)	--kenneth 06.23.2015 SR 19458
                                       )
                                     * gi_currency_rt;
                                  v_curr_tax_amt :=
                                              perl.prem_amt
                                              * (tax.rate / 100);
                               END LOOP;
                            ELSE
                               v_depr_tax_amt :=
                                    ((gi_prem_amt) * (tax.rate / 100)	--kenneth 06.23.2015 SR 19458
                                    )
                                  * gi_currency_rt;
                               v_curr_tax_amt :=
                                              gi_prem_amt
                                              * (tax.rate / 100);
                            END IF;
                         END IF;
                      END IF;
                   END IF;
                ELSIF tax.tax_cd = v_evat
                THEN                                            --EVAT computation
                   IF v_vat_tag IN ('1', '2')
                   THEN
                      v_depr_tax_amt := 0;
                      v_curr_tax_amt := 0;
                   ELSE
                      IF tax.peril_sw = 'Y'
                      THEN
                         FOR perl IN (SELECT SUM (a.prem_amt) prem_amt	--kenneth 06.23.2015 SR 19458
                                        FROM giex_itmperil a,
                                             giis_tax_peril b
                                       WHERE a.line_cd = b.line_cd
                                         AND a.peril_cd = b.peril_cd
                                         AND a.policy_id = a2.policy_id
                                         AND b.tax_cd = tax.tax_cd
                                         AND b.line_cd = gpol.line_cd
                                         AND b.iss_cd = gpol.iss_cd
                                         AND b.tax_id = tax.tax_id)
                         LOOP
                            v_depr_tax_amt :=
                                 ((perl.prem_amt) * (tax.rate / 100)	--kenneth 06.23.2015 SR 19458
                                 )
                               * gi_currency_rt;
                            v_curr_tax_amt := perl.prem_amt
                                              * (tax.rate / 100);
                         END LOOP;
                      ELSE
                         v_depr_tax_amt :=
                              ((gi_prem_amt) * (tax.rate / 100)	--kenneth 06.23.2015 SR 19458
                              )
                            * gi_currency_rt;
                         v_curr_tax_amt := gi_prem_amt * (tax.rate / 100);
                      END IF;
                   END IF;
                ELSE                                      --other tax computations
                   IF tax.tax_type = 'A'
                   THEN
                      v_depr_tax_amt := tax.tax_amount;
                      v_curr_tax_amt := tax.tax_amount / v_currency_rt;
                   ELSIF tax.tax_type = 'N'
                   THEN
                      v_depr_tax_amt := 0;
                      v_curr_tax_amt := 0;

                      IF (gpol.menu_line_cd = 'AC' OR gpol.line_cd = 'AC')
                      THEN
                         FOR gtr IN (SELECT tax_amount
                                       FROM giis_tax_range
                                      WHERE line_cd = gpol.line_cd
                                        AND iss_cd = gpol.iss_cd
                                        AND tax_cd = tax.tax_cd
                                        AND tax_id = tax.tax_id
                                        AND (gi_tsi_amt * v_currency_rt)	--kenneth 06.23.2015 SR 19458
                                               BETWEEN min_value
                                                   AND max_value)
                         LOOP
                            v_depr_tax_amt := gtr.tax_amount;
                            v_curr_tax_amt := gtr.tax_amount / v_currency_rt;
                         END LOOP;
                      ELSE
                         FOR gtr IN
                            (SELECT tax_amount
                               FROM giis_tax_range
                              WHERE line_cd = gpol.line_cd
                                AND iss_cd = gpol.iss_cd
                                AND tax_cd = tax.tax_cd
                                AND tax_id = tax.tax_id
                                AND (gi_prem_amt * v_currency_rt)	--kenneth 06.23.2015 SR 19458
                                       BETWEEN min_value
                                           AND max_value)
                         LOOP
                            v_depr_tax_amt := gtr.tax_amount;
                            v_curr_tax_amt := gtr.tax_amount / v_currency_rt;
                         END LOOP;
                      END IF;
                   ELSE
                      IF tax.peril_sw = 'Y'
                      THEN
                         FOR perl IN (SELECT SUM (a.prem_amt) prem_amt	--kenneth 06.23.2015 SR 19458
                                        FROM giex_itmperil a,
                                             giis_tax_peril b
                                       WHERE a.line_cd = b.line_cd
                                         AND a.peril_cd = b.peril_cd
                                         AND a.policy_id = a2.policy_id
                                         AND b.tax_cd = tax.tax_cd
                                         AND b.line_cd = gpol.line_cd
                                         AND b.iss_cd = gpol.iss_cd
                                         AND b.tax_id = tax.tax_id)
                         LOOP
                            IF     tax.tax_type = 'R'
                               AND tax.rate = 0
                               AND tax.no_rate_tag = 'Y'
                            THEN
                               FOR t IN (SELECT SUM (b.tax_amt) tax_amt
                                           FROM gipi_invoice a,
                                                gipi_inv_tax b,
                                                gipi_polbasic c
                                          WHERE a.iss_cd = b.iss_cd
                                            AND a.prem_seq_no = b.prem_seq_no
                                            AND a.policy_id = c.policy_id
                                            AND c.line_cd = a2.line_cd
                                            AND c.subline_cd = a2.subline_cd
                                            AND c.iss_cd = a2.iss_cd
                                            AND c.issue_yy = a2.issue_yy
                                            AND c.pol_seq_no = a2.pol_seq_no
                                            AND c.renew_no = a2.renew_no
                                            AND b.tax_cd = tax.tax_cd
                                            AND (   c.endt_seq_no = 0
                                                 OR (    c.endt_seq_no > 0
                                                     AND TRUNC (c.endt_expiry_date) >=
                                                             TRUNC (c.expiry_date)
                                                    )
                                                ))
                               LOOP
                                  v_depr_tax_amt := t.tax_amt * gi_currency_rt;	--kenneth 06.23.2015 SR 19458
                                  v_curr_tax_amt := t.tax_amt;
                               END LOOP;
                            ELSE
                               v_depr_tax_amt :=
                                    ((perl.prem_amt) * (tax.rate / 100)	--kenneth 06.23.2015 SR 19458
                                    )
                                  * gi_currency_rt;
                               v_curr_tax_amt :=
                                              perl.prem_amt
                                              * (tax.rate / 100);
                            END IF;
                         END LOOP;
                      ELSE
                         IF     tax.tax_type = 'R'
                            AND tax.rate = 0
                            AND tax.no_rate_tag = 'Y'
                         THEN
                            FOR t IN (SELECT SUM (b.tax_amt) tax_amt
                                        FROM gipi_invoice a,
                                             gipi_inv_tax b,
                                             gipi_polbasic c
                                       WHERE a.iss_cd = b.iss_cd
                                         AND a.prem_seq_no = b.prem_seq_no
                                         AND a.policy_id = c.policy_id
                                         AND c.line_cd = a2.line_cd
                                         AND c.subline_cd = a2.subline_cd
                                         AND c.iss_cd = a2.iss_cd
                                         AND c.issue_yy = a2.issue_yy
                                         AND c.pol_seq_no = a2.pol_seq_no
                                         AND c.renew_no = a2.renew_no
                                         AND b.tax_cd = tax.tax_cd
                                         AND (   c.endt_seq_no = 0
                                              OR (    c.endt_seq_no > 0
                                                  AND TRUNC (c.endt_expiry_date) >=
                                                             TRUNC (c.expiry_date)
                                                 )
                                             ))
                            LOOP
                               v_depr_tax_amt := t.tax_amt * gi_currency_rt;	--kenneth 06.23.2015 SR 19458
                               v_curr_tax_amt := t.tax_amt;
                            END LOOP;
                         ELSE
                            v_depr_tax_amt :=
                                 ((gi_prem_amt) * (tax.rate / 100)
                                 )
                               * gi_currency_rt;
                            v_curr_tax_amt := gi_prem_amt
                                              * (tax.rate / 100);
                         END IF;
                      END IF;
                   END IF;
                END IF;

                --inserting and updating
                BEGIN
                   SELECT COUNT (*)
                     INTO v_count
                     FROM giex_new_group_tax
                    WHERE policy_id = a2.policy_id
                      AND line_cd = gpol.line_cd
                      AND iss_cd = gpol.iss_cd
                      AND tax_cd = tax.tax_cd
                      AND tax_id = tax.tax_id;
                END;

                IF v_count = 0
                THEN
                   IF (tax.tax_cd = v_evat AND v_vat_tag = 1)
                   THEN
                      NULL;
                   ELSE
                      IF     (   v_depr_tax_amt > 0
                              OR v_curr_tax_amt > 0
                              OR (tax.tax_cd = v_evat AND v_vat_tag = 2
                                 )
                              OR (    v_tax_type = 'R'
                                  AND v_rate = 0
                                  AND v_primary_sw = 'Y'
                                  AND v_is_new = 'Y'
                                 )
                             )
                         AND NVL (v_cancelled, 'N') = 'N'
                      THEN
                         INSERT INTO giex_new_group_tax
                                     (policy_id, line_cd, iss_cd,
                                      tax_cd, tax_id, tax_desc,
                                      tax_amt, rate, currency_tax_amt
                                     )
                              VALUES (a2.policy_id, gpol.line_cd, gpol.iss_cd,
                                      tax.tax_cd, tax.tax_id, tax.tax_desc,
                                      v_depr_tax_amt, tax.rate, v_curr_tax_amt
                                     );
                      END IF;
                   END IF;
                ELSE
                   IF (tax.tax_cd = v_evat AND v_vat_tag = 1)
                   THEN
                      NULL;
                   ELSE
                      UPDATE giex_new_group_tax
                         SET tax_amt = v_depr_tax_amt,
                             currency_tax_amt = v_curr_tax_amt
                       WHERE policy_id = a2.policy_id
                         AND line_cd = gpol.line_cd
                         AND iss_cd = gpol.iss_cd
                         AND tax_cd = tax.tax_cd
                         AND tax_id = tax.tax_id;
                   END IF;
                END IF;

                v_depr_tax_amt := 0;
                v_curr_tax_amt := 0;
             END LOOP;
          END LOOP;
       END LOOP;
    END;
END giex_itmperil_pkg;
/
