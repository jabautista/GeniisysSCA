DROP PROCEDURE CPI.CREATE_NEGATED_REC_PRORATE2;

CREATE OR REPLACE PROCEDURE CPI.CREATE_NEGATED_REC_PRORATE2(
    p_pack_par_id        IN GIPI_PACK_WPOLBAS.pack_par_id%TYPE,
    p_line_cd            IN GIPI_PACK_WPOLBAS.line_cd%TYPE,
    p_subline_cd         IN GIPI_PACK_WPOLBAS.subline_cd%TYPE,
    p_iss_cd             IN GIPI_PACK_WPOLBAS.iss_cd%TYPE,
    p_issue_yy           IN GIPI_PACK_WPOLBAS.issue_yy%TYPE,
    p_pol_seq_no         IN GIPI_PACK_WPOLBAS.pol_seq_no%TYPE,
    p_renew_no           IN GIPI_PACK_WPOLBAS.renew_no%TYPE,
    p_co_insurance_sw    IN GIPI_PACK_WPOLBAS.co_insurance_sw%TYPE,
    p_pack_pol_flag      IN VARCHAR2,
    p_prorate_flag       IN GIPI_PACK_WPOLBAS.prorate_flag%TYPE,
    p_comp_sw            IN GIPI_PACK_WPOLBAS.comp_sw%TYPE,
    p_nbt_short_rt_pct   IN GIPI_PACK_WPOLBAS.short_rt_percent%TYPE,
    p_in_eff_date        IN GIPI_PACK_WPOLBAS.eff_date%TYPE,    
    p_v_expiry_date      OUT VARCHAR2,
    p_v_incept_date      OUT VARCHAR2,
    p_incept_date        OUT VARCHAR2,
    p_expiry_date        OUT VARCHAR2,
    p_endt_expiry_date   OUT VARCHAR2,
    p_tsi_amt            OUT GIPI_PACK_WPOLBAS.tsi_amt%TYPE,
    p_prem_amt           OUT GIPI_PACK_WPOLBAS.prem_amt%TYPE,
    p_ann_tsi_amt        OUT GIPI_PACK_WPOLBAS.ann_tsi_amt%TYPE,
    p_ann_prem_amt       OUT GIPI_PACK_WPOLBAS.ann_prem_amt%TYPE,
    p_msg_alert          OUT VARCHAR2) 

IS
   /*
	**  Created by		: Veronica V. Raymundo
	**  Date Created 	: 11.16.2011
	**  Reference By 	: (GIPIS031A - Package Endt Basic Information)
	**  Description 	:  This procedure create records in gipi_witem and
    **                     gipi_witmperl which will negate all the policy's 
    **                     peril and tsi
	*/

   v_max_eff_date1           GIPI_WPOLBAS.eff_date%TYPE;
   v_max_eff_date2           GIPI_WPOLBAS.eff_date%TYPE;
   v_max_eff_date            GIPI_WPOLBAS.eff_date%TYPE;
   p_eff_date                GIPI_WPOLBAS.eff_date%TYPE;
   v_max_endt_seq_no         GIPI_WPOLBAS.endt_seq_no%TYPE;
   v_max_endt_seq_no1        GIPI_WPOLBAS.endt_seq_no%TYPE;
   v_no_of_days              NUMBER;
   v_days_of_policy          NUMBER;
   v_prorate_prem            GIPI_ITMPERIL.prem_amt%TYPE;
   v_prorate_tsi             GIPI_ITMPERIL.tsi_amt%TYPE;
   v_peril                   GIPI_WITMPERL.peril_cd%TYPE;
   v_comm_amt                GIPI_WITMPERL.ri_comm_amt%TYPE;
   
   v_policy_id            GIPI_POLBASIC.policy_id%TYPE;
   v_v_expiry_date        DATE;
   v_v_incept_date        DATE;

BEGIN
    FOR var IN (SELECT a.par_id, b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.pol_seq_no, b.renew_no
	               FROM gipi_wpolbas b, gipi_parlist a 
	              WHERE 1=1
	                AND b.par_id = a.par_id
	                AND a.pack_par_id = p_pack_par_id
	                AND a.par_status NOT IN (98,99))
	 LOOP
        v_v_expiry_date := PACK_ENDT_EXTRACT_EXPIRY(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
        v_v_incept_date := PACK_ENDT_EXTRACT_INCEPT(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
        
        --delete existing data for this PAR
        Pack_endt_Delete_Other_Info(var.par_id);
	    Pack_Endt_Delete_Records(var.par_id, var.line_cd, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no,
	                             p_in_eff_date, p_co_insurance_sw, p_ann_tsi_amt, p_ann_prem_amt, p_msg_alert);
	    
	    IF NOT p_msg_alert IS NULL THEN
	        GOTO RAISE_FORM_TRIGGER_FAILURE;
	    END IF;
        
        FOR X IN (SELECT b2501.eff_date eff_date
                  FROM gipi_polbasic b2501
                 WHERE b2501.line_cd    = var.line_cd
                   AND b2501.subline_cd = var.subline_cd
                   AND b2501.iss_cd     = var.iss_cd
                   AND b2501.issue_yy   = var.issue_yy
                   AND b2501.pol_seq_no = var.pol_seq_no
                   AND b2501.renew_no   = var.renew_no
                   AND b2501.pol_flag   IN ('1','2','3','X')
                   AND b2501.endt_seq_no = 0) 
        LOOP
          p_eff_date := x.eff_date;
          EXIT;
        END LOOP;                 
                
        FOR W IN (SELECT MAX(endt_seq_no) endt_seq_no 
                  FROM gipi_polbasic b2501
                 WHERE b2501.line_cd    = var.line_cd
                   AND b2501.subline_cd = var.subline_cd
                   AND b2501.iss_cd     = var.iss_cd
                   AND b2501.issue_yy   = var.issue_yy
                   AND b2501.pol_seq_no = var.pol_seq_no
                   AND b2501.renew_no   = var.renew_no
                   AND b2501.pol_flag   IN ('1','2','3','X')
                   --AND b2501.eff_date <= nvl(:b540.eff_date,:b540.eff_date)
                   AND nvl(b2501.endt_expiry_date,b2501.expiry_date) >= p_in_eff_date)
        LOOP
          v_max_endt_seq_no := w.endt_seq_no;  
          EXIT;
        END LOOP;
       
       IF v_max_endt_seq_no > 0 THEN
          FOR G IN (SELECT MAX(endt_seq_no) endt_seq_no
                      FROM gipi_polbasic b250 
                     WHERE b250.line_cd    = var.line_cd
                       AND b250.subline_cd = var.subline_cd
                       AND b250.iss_cd     = var.iss_cd
                       AND b250.issue_yy   = var.issue_yy
                       AND b250.pol_seq_no = var.pol_seq_no
                       AND b250.renew_no   = var.renew_no
                       AND b250.pol_flag   IN ('1','2','3','X')
                       --AND b250.eff_date <= :b540.eff_date
                       AND NVL(b250.endt_expiry_date,b250.expiry_date) >= p_in_eff_date
                       AND NVL(b250.back_stat,5) = 2) 
          LOOP
             v_max_endt_seq_no1 := g.endt_seq_no;
             EXIT;
          END LOOP;
          
          IF v_max_endt_seq_no != NVL(v_max_endt_seq_no1,-1) THEN             
             FOR Z IN (SELECT MAX(b2501.eff_date) eff_date
                         FROM gipi_polbasic b2501
                        WHERE b2501.line_cd    = var.line_cd
                          AND b2501.subline_cd = var.subline_cd
                          AND b2501.iss_cd     = var.iss_cd
                          AND b2501.issue_yy   = var.issue_yy
                          AND b2501.pol_seq_no = var.pol_seq_no
                          AND b2501.renew_no   = var.renew_no
                          AND b2501.pol_flag   IN ('1','2','3','X')
                          --AND b2501.eff_date   <= :b540.eff_date
                          AND nvl(b2501.endt_expiry_date,b2501.expiry_date) >= p_in_eff_date
                          AND nvl(b2501.back_stat,5) = 2
                          AND b2501.endt_seq_no = v_max_endt_seq_no1) 
             LOOP
                v_max_eff_date1 := z.eff_date;
                EXIT;
             END LOOP;
                                              
             FOR Y IN (SELECT MAX(b2501.eff_date) eff_date
                       FROM gipi_polbasic b2501
                      WHERE b2501.line_cd    = var.line_cd
                        AND b2501.subline_cd = var.subline_cd
                        AND b2501.iss_cd     = var.iss_cd
                        AND b2501.issue_yy   = var.issue_yy
                        AND b2501.pol_seq_no = var.pol_seq_no
                        AND b2501.renew_no   = var.renew_no
                        AND b2501.pol_flag   IN ('1','2','3','X')
                        AND b2501.endt_seq_no != 0
                        --AND b2501.eff_date <= :b540.eff_date
                        AND NVL(b2501.endt_expiry_date,b2501.expiry_date) >= p_in_eff_date
                        AND NVL(b2501.back_stat,5)!= 2) 
             LOOP
               v_max_eff_date2 := y.eff_date;
               EXIT;
             END LOOP;               
             v_max_eff_date := NVL(v_max_eff_date2,v_max_eff_date1);                         
          ELSE
             FOR Y IN (SELECT MAX(b2501.eff_date) eff_date
                         FROM gipi_polbasic b2501 --A.R.C. 07.27.2006
                        WHERE b2501.line_cd    = var.line_cd
                          AND b2501.subline_cd = var.subline_cd
                          AND b2501.iss_cd     = var.iss_cd
                          AND b2501.issue_yy   = var.issue_yy
                          AND b2501.pol_seq_no = var.pol_seq_no
                          AND b2501.renew_no   = var.renew_no
                          AND b2501.pol_flag   IN ('1','2','3','X')
                          AND b2501.endt_seq_no != 0
                          --AND b2501.eff_date <= :b540.eff_date
                          AND nvl(b2501.endt_expiry_date,b2501.expiry_date) >= p_in_eff_date
                          AND nvl(b2501.back_stat,5) = 2
                          AND b2501.endt_seq_no = v_max_endt_seq_no1) 
             LOOP                  
                v_max_eff_date := y.eff_date;
                EXIT;
             END LOOP;    
          END IF;
        ELSE
           v_max_eff_date := p_eff_date;                
        END IF;
        -- get latest data for dates coming from latest endt. 
        -- (backward endt. is considered)
        FOR DT IN (SELECT  b250.incept_date, b250.expiry_date
                    FROM  gipi_polbasic b250 --A.R.C. 07.27.2006
                   WHERE  b250.line_cd    = var.line_cd
                     AND  b250.subline_cd = var.subline_cd
                     AND  b250.iss_cd     = var.iss_cd
                     AND  b250.issue_yy   = var.issue_yy
                     AND  b250.pol_seq_no = var.pol_seq_no
                     AND  b250.renew_no   = var.renew_no
                     AND  b250.pol_flag   IN ('1','2','3','X') 
                     AND  b250.eff_date   = v_max_eff_date 
                ORDER BY b250.endt_seq_no DESC )
        LOOP
            p_incept_date      := TO_CHAR(dt.incept_date, 'MM-DD-RRRR HH:MI:SS AM');
            p_expiry_date      := TO_CHAR(dt.expiry_date, 'MM-DD-RRRR HH:MI:SS AM');
            p_endt_expiry_date := TO_CHAR(dt.expiry_date, 'MM-DD-RRRR HH:MI:SS AM');        
            EXIT;
        END LOOP;
       
      --create negated records in table gipi_witem,gipi_witmperl
      --select first all existing item from policy and all it's endt.          
      FOR A1 IN (SELECT  distinct b340.item_no item_no
                   FROM  gipi_polbasic b250, gipi_item b340
                  WHERE  b250.line_cd    = var.line_cd
                    AND  b250.subline_cd = var.subline_cd
                    AND  b250.iss_cd     = var.iss_cd
                    AND  b250.issue_yy   = var.issue_yy
                    AND  b250.pol_seq_no = var.pol_seq_no
                    AND  b250.renew_no   = var.renew_no
                    AND  b250.policy_id = b340.policy_id
                    AND TRUNC(DECODE(NVL(b250.endt_expiry_date, b250.expiry_date), b250.expiry_date,
                                         v_v_expiry_date, b250.expiry_date,b250.endt_expiry_date)) >= TRUNC(p_in_eff_date)
                    AND  b250.pol_flag   IN ('1','2','3','X'))
      LOOP      
          --call procedure that will get latest info. for every item
          --and insert it in table gipi_witem
         Pack_Endt_Get_Neg_Item(var.par_id, a1.item_no, var.line_cd);
        --change item grouping
         Change_Item_Grp(var.par_id, p_pack_pol_flag);

        --for pro-rate cancellation every record in gipi_itmperil would be retrived
        --and computed individually
        IF p_prorate_flag = 1  then 
           v_peril          := NULL;
           v_no_of_days     := NULL;
           v_days_of_policy := NULL;
           v_prorate_prem   := 0;
           v_prorate_tsi    := 0;               
           v_comm_amt       := 0;
           
           FOR A2 IN(SELECT  b380.peril_cd peril, b380.prem_amt prem, b380.tsi_amt tsi, b380.ri_comm_amt comm,
                             b380.prem_rt rate, 
                             TRUNC(DECODE(NVL(b250.endt_expiry_date, b250.expiry_date), b250.expiry_date,
                                             v_v_expiry_date, expiry_date,b250.endt_expiry_date)) expiry_date,
                             TRUNC(DECODE(b250.incept_date, b250.incept_date,
                                             v_v_incept_date, incept_date)) eff_date, 
                             b250.prorate_flag, DECODE(nvl(comp_sw,'N'),'Y',1,'M',-1,0) comp_sw    
                       FROM  GIPI_POLBASIC b250, GIPI_ITMPERIL b380
                      WHERE  b250.line_cd    = var.line_cd
                        AND  b250.subline_cd = var.subline_cd
                        AND  b250.iss_cd     = var.iss_cd
                        AND  b250.issue_yy   = var.issue_yy
                        AND  b250.pol_seq_no = var.pol_seq_no
                        AND  b250.renew_no   = var.renew_no
                      --  AND  nvl(b250.endt_expiry_date,b250.expiry_date) >= :b540.eff_date
                        AND TRUNC(DECODE(NVL(b250.endt_expiry_date, b250.expiry_date), b250.expiry_date,
                                             v_v_expiry_date, expiry_date,b250.endt_expiry_date)) >= TRUNC(p_in_eff_date)
                        AND  b250.pol_flag   IN ('1','2','3','X') 
                        AND  b250.policy_id  = b380.policy_id
                        AND  b380.item_no    = A1.item_no
                  ORDER BY   b380.peril_cd) 
           LOOP
                v_no_of_days     := NULL;
                v_days_of_policy := NULL;
                
                IF v_peril IS NULL THEN
                v_peril := a2.peril;             
                ELSIF v_peril  <> a2.peril THEN
                      INSERT INTO gipi_witmperl
                             (par_id,        item_no,        line_cd,       peril_cd, prem_rt,
                              tsi_amt,       prem_amt,       ann_tsi_amt,   ann_prem_amt,   rec_flag,
                              ri_comm_amt,   ri_comm_rate)
                      VALUES(var.par_id,     a1.item_no,     var.line_cd,   v_peril,  0,  
                             v_prorate_tsi, v_prorate_prem, 0,             0,        'D',
                             v_comm_amt,    0);
                v_peril        := a2.peril;
                v_prorate_tsi  := 0;
                v_prorate_prem := 0;
                v_comm_amt     := 0;
                END IF;             
                -- get no of days that a particular record exists
                -- in order to get correct computation of perm. per day
                v_days_of_policy := TRUNC(a2.expiry_date) - TRUNC(a2.eff_date);    
                IF p_prorate_flag = 1 THEN
                       v_days_of_policy := v_days_of_policy + a2.comp_sw;    
                END IF;      
                --get no. of days that will be returned 
               IF p_comp_sw = 'Y' THEN
                 v_no_of_days  :=  (TRUNC(a2.expiry_date) - TRUNC(p_in_eff_date))+ 1;             
               ELSIF p_comp_sw = 'M' THEN
                 v_no_of_days  :=  (TRUNC(a2.expiry_date) - TRUNC(p_in_eff_date)) - 1;             
               ELSE
                 v_no_of_days  :=  TRUNC(a2.expiry_date) - TRUNC(p_in_eff_date);
               END IF;
             --for policy or endt with no of days less than the no. of days of cancelling
             --endt. no_of days of cancelling endt. should be equal to the no_of days
             --of policy/endt. on process
              IF NVL(v_no_of_days,0)> NVL(v_days_of_policy,0) THEN
                   v_no_of_days := v_days_of_policy;
              END IF;      
             --compute for negated premium for records with premium <> 0
             IF NVL(a2.prem,0) <> 0 THEN
                v_prorate_prem := v_prorate_prem + (-(a2.prem /v_days_of_policy)*(v_no_of_days));
             END IF;
             --compute for negated commision_amt for records with commission <> 0
             IF NVL(a2.comm,0) <> 0 THEN
                v_comm_amt := NVL(v_comm_amt,0) + (-(a2.comm /v_days_of_policy)*(v_no_of_days));
             END IF;
             --accumulate tsi amount
             IF NVL(a2.tsi,0) <> 0 THEN
                v_prorate_tsi  := v_prorate_tsi + -(a2.tsi);
             END IF;
           END LOOP;  

            INSERT INTO gipi_witmperl
                       (par_id,        item_no,        line_cd,       peril_cd, prem_rt,
                        tsi_amt,       prem_amt,       ann_tsi_amt,   ann_prem_amt,   rec_flag,
                        ri_comm_amt,   ri_comm_rate)
                 VALUES(var.par_id,    a1.item_no,     var.line_cd,   v_peril,  0,
                        v_prorate_tsi, v_prorate_prem, 0,             0,        'D',
                        v_comm_amt,   0);
        ELSE  
           --for short rate cancellation premium for each peril for a particular item
           --would be summarized and computed based on entered short rate percent
           FOR A2 IN(SELECT b380.peril_cd peril_cd, SUM(b380.prem_amt) prem, SUM(b380.tsi_amt) tsi,
                            SUM(NVL(ri_comm_amt,0)) comm
                      FROM  gipi_polbasic b250, gipi_itmperil b380
                     WHERE  b250.line_cd    = var.line_cd
                       AND  b250.subline_cd = var.subline_cd
                       AND  b250.iss_cd     = var.iss_cd
                       AND  b250.issue_yy   = var.issue_yy
                       AND  b250.pol_seq_no = var.pol_seq_no
                       AND  b250.renew_no   = var.renew_no
                       AND  b250.pol_flag   IN ('1','2','3','X') 
                       AND  b250.policy_id  = b380.policy_id
                       AND  b380.item_no    = A1.item_no
                  GROUP BY b380.peril_cd) 
           LOOP
                v_prorate_prem := nvl(a2.prem,0)*(nvl(p_nbt_short_rt_pct,1)/100);
                v_comm_amt     := nvl(a2.comm,0)*(nvl(p_nbt_short_rt_pct,1)/100);
                IF NVL(v_comm_amt,0) <> 0 THEN
                      v_comm_amt := -v_comm_amt;
                END IF;      
             INSERT INTO gipi_witmperl
                    (par_id,       item_no,        line_cd,       peril_cd,        prem_rt,
                     tsi_amt,      prem_amt,       ann_tsi_amt,   ann_prem_amt,    rec_flag,
                     ri_comm_amt,  ri_comm_rate)
             VALUES (var.par_id,   a1.item_no,     var.line_cd,   a2.peril_cd,     0,  
                     -a2.tsi,     -v_prorate_prem, 0,             0,               'D',
                     v_comm_amt,  0);
           END LOOP;
        END IF;
      END LOOP;  
      
      --update amounts of table gipi_witem, gipi_wpolbas refering to the created
      --records in table gipi_witmperl
      FOR ITEM IN(SELECT item_no
                    FROM gipi_witem
                   WHERE par_id = var.par_id)LOOP   
          
          FOR PERIL IN(SELECT sum(NVL(prem_amt,0)) prem
                         FROM gipi_witmperl
                        WHERE par_id = var.par_id 
                          AND item_no = item.item_no)LOOP
               UPDATE gipi_witem
                  SET prem_amt = peril.prem
                WHERE par_id = var.par_id 
                  AND item_no = item.item_no;
          END LOOP;
          FOR PERIL2 IN(SELECT SUM(NVL(tsi_amt,0)) tsi
                         FROM gipi_witmperl a, giis_peril b
                        WHERE a.par_id = var.par_id 
                          AND a.peril_cd = b.peril_cd
                          AND a.line_cd  = b.line_cd
                          and b.peril_type = 'B'
                          AND item_no = item.item_no)
          LOOP
               UPDATE gipi_witem
                  SET tsi_amt  = peril2.tsi
                WHERE par_id = var.par_id 
                  AND item_no = item.item_no;
          END LOOP;
      END LOOP;
      /* Update invoice records 
      */
      BEGIN
        IF p_pack_pol_flag = 'Y' THEN
           FOR PACK IN(SELECT pack_line_cd, item_no
                         FROM gipi_witem
                        WHERE par_id = var.par_id)
           LOOP
               FOR A IN (SELECT   '1'
                           FROM   gipi_witmperl
                          WHERE   par_id  = var.par_id) 
               LOOP
                    create_winvoice(0,0,0, var.par_id, var.line_cd, var.iss_cd);
                    EXIT;
               END LOOP;
           END LOOP;
        ELSE
           FOR A IN (SELECT   '1'
                       FROM   gipi_witmperl
                      WHERE   par_id  = var.par_id) 
           LOOP
               create_winvoice(0,0,0,var.par_id, var.line_cd, var.iss_cd);
               EXIT;
           END LOOP;
        END IF;
        FOR UPD_POLBAS IN(SELECT SUM(tsi_amt*currency_rt) tsi, 
                                 SUM(prem_amt*currency_rt) prem
                            FROM gipi_witem
                           WHERE par_id = var.par_id) 
        LOOP          
            UPDATE gipi_wpolbas        
               SET tsi_amt = upd_polbas.tsi,
                   prem_amt = upd_polbas.prem,
                   ann_tsi_amt = 0,
                   ann_prem_amt = 0
             WHERE par_id = var.par_id;          
        END LOOP;
        
        --A.R.C. 09.12.2006
        --to update the value of tsi and prem of gipi_pack_wpolbas
        FOR UPD_PACK_POLBAS IN(SELECT SUM(tsi_amt) tsi, 
                                 SUM(prem_amt) prem
                            FROM gipi_wpolbas
                           WHERE pack_par_id = p_pack_par_id) LOOP
            p_tsi_amt      := upd_pack_polbas.tsi;
            p_prem_amt     := upd_pack_polbas.prem;
            p_ann_tsi_amt  := 0;
            p_ann_prem_amt := 0;           
        END LOOP;     
        cr_bill_dist.get_tsi(var.par_id);
      END;
        
        p_v_expiry_date := v_v_expiry_date;    
        p_v_incept_date := v_v_incept_date;
        
     END LOOP;
    
    <<RAISE_FORM_TRIGGER_FAILURE>>
    NULL;
    
END;
/


