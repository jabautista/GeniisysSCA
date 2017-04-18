DROP PROCEDURE CPI.CREATE_DISTRIBUTION_GIPIS172;

CREATE OR REPLACE PROCEDURE CPI.CREATE_DISTRIBUTION_GIPIS172(b_par_id  IN NUMBER,
                                                             p_dist_no IN NUMBER) 
/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  March 23, 2010
**  Reference By : (GIPIS172 - Limits of Liability)
**  Description  : Procedure to create distribution.
*/                              
IS                                                       
  TYPE NUMBER_VARRAY IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
  vv_tsi_amt     NUMBER_VARRAY;
  vv_ann_tsi_amt NUMBER_VARRAY;
  vv_prem_amt    NUMBER_VARRAY;
  vv_item_grp    NUMBER_VARRAY;
  varray_cnt     NUMBER:=0;
  b_exist        NUMBER;
  p_exist        NUMBER;
  pi_dist_no     giuw_pol_dist.dist_no%TYPE;
  p_frps_yy      giri_wdistfrps.frps_yy%TYPE;
  p_frps_seq_no  giri_wdistfrps.frps_seq_no%TYPE;
  p2_dist_no     giuw_pol_dist.dist_no%TYPE;
  p_eff_date     gipi_polbasic.eff_date%TYPE;
  p_expiry_date  gipi_polbasic.expiry_date%TYPE;
  p_endt_type    gipi_polbasic.endt_type%TYPE;
  p_policy_id    gipi_polbasic.policy_id%TYPE;
  p_tsi_amt      gipi_witem.tsi_amt%TYPE;
  p_ann_tsi_amt  gipi_witem.ann_tsi_amt%TYPE;
  p_prem_amt     gipi_witem.prem_amt%TYPE;
  v_tsi_amt      gipi_witem.tsi_amt%TYPE      := 0;
  v_ann_tsi_amt  gipi_witem.ann_tsi_amt%TYPE  := 0;
  v_prem_amt     gipi_witem.prem_amt%TYPE     := 0;
  x_but          NUMBER;
  dist_cnt       NUMBER:=0;
  dist_max       giuw_pol_dist.dist_no%TYPE;
  dist_min       giuw_pol_dist.dist_no%TYPE;
  v_dist_exist   VARCHAR2(1) := 'N';
  p_message      VARCHAR2(300);
    
  CURSOR  C1 IS
      SELECT distinct frps_yy,
                      frps_seq_no
        FROM giri_wdistfrps
       WHERE dist_no = p_dist_no;
       
  CURSOR  C2 IS
      SELECT distinct frps_yy,
                      frps_seq_no
        FROM giri_distfrps
       WHERE dist_no = p_dist_no;

/*main*/
BEGIN
  BEGIN--1--
    FOR array_loop IN (SELECT sum(tsi_amt     * currency_rt) tsi_amt,
                              sum(ann_tsi_amt * currency_rt) ann_tsi_amt,
                              sum(prem_amt    * currency_rt) prem_amt,
                              item_grp
                         FROM gipi_witem
                        WHERE par_id = b_par_id
                        GROUP BY item_grp)
    LOOP
      IF ((array_loop.tsi_amt IS NULL) OR (array_loop.ann_tsi_amt IS NULL)
         OR (array_loop.prem_amt IS NULL)) THEN          
         p_message := 'Insufficient information on the TSI amount, annual TSI amount '||
                       'and premium amount for this ITEM.';
      END IF;
        
      varray_cnt                 := varray_cnt + 1;
      vv_tsi_amt(varray_cnt)     := array_loop.tsi_amt;
      vv_ann_tsi_amt(varray_cnt) := array_loop.ann_tsi_amt;
      vv_prem_amt(varray_cnt)    := array_loop.prem_amt;
      vv_item_grp(varray_cnt)    := array_loop.item_grp;
    END LOOP;    
        
    IF varray_cnt = 0 THEN       
       p_message := 'Pls. be adviced that there are no items for this PAR.';
    END IF;
  END;--1--
  
  /*SELECT distinct dist_no
    INTO pi_dist_no
    FROM giuw_pol_dist
   WHERE par_id = b_par_id;*/
  FOR x IN (SELECT dist_no
              FROM giuw_pol_dist
             WHERE par_id = b_par_id)
  LOOP
    pi_dist_no   := x.dist_no;
    v_dist_exist := 'Y';
      
    BEGIN--2--
      SELECT distinct 1
        INTO b_exist
        FROM giuw_policyds
       WHERE dist_no = pi_dist_no;
        
      IF sql%FOUND THEN
        p_message := 'This PAR has an existing records in the posted POLICY table. Could not proceed.';
      ELSE
        RAISE NO_DATA_FOUND;
      END IF;
    EXCEPTION--2--
      WHEN NO_DATA_FOUND THEN
        NULL;
    END;--2--
      
    BEGIN--3--
      SELECT distinct 1
        INTO p_exist
        FROM giuw_wpolicyds
       WHERE dist_no = pi_dist_no;    
    EXCEPTION--3--
      WHEN NO_DATA_FOUND THEN
        p_exist := 1;
    END;--3--

    IF p_exist = 1 THEN
      FOR C1_rec IN C1 LOOP
        DELETE giri_wfrperil
         WHERE frps_yy     = C1_rec.frps_yy
           AND frps_seq_no = C1_rec.frps_seq_no;
           
        DELETE giri_wfrps_ri
         WHERE frps_yy     = C1_rec.frps_yy
           AND frps_seq_no = C1_rec.frps_seq_no;
           
        DELETE giri_wdistfrps
         WHERE dist_no = pi_dist_no;  
      END LOOP;
        
      FOR C2_rec IN C2 LOOP
        p_message := 'This PAR has corresponding records in the posted tables for RI.Could not proceed.';
      END LOOP;
          
      DELETE giuw_wperilds_dtl
       WHERE dist_no = pi_dist_no;
         
      DELETE giuw_witemds_dtl
       WHERE dist_no = pi_dist_no;
         
      DELETE giuw_wpolicyds_dtl
       WHERE dist_no = pi_dist_no;
         
      DELETE giuw_wperilds
       WHERE dist_no = pi_dist_no;
        
      DELETE giuw_witemds
       WHERE dist_no = pi_dist_no;
         
      DELETE giuw_wpolicyds
       WHERE dist_no = pi_dist_no;
        
      IF vv_item_grp.exists(1) THEN
        FOR cnt IN vv_item_grp.FIRST.. vv_item_grp.LAST LOOP                         
          BEGIN--4--
            SELECT count(dist_no), max(dist_no), min(dist_no)   
              INTO dist_cnt, dist_max, dist_min
              FROM giuw_pol_dist
             WHERE par_id = b_par_id
               AND NVL(item_grp, vv_item_grp(cnt)) = vv_item_grp(cnt);
          END;--4--
                    
          IF dist_cnt = 1 THEN
             v_tsi_amt     := v_tsi_amt + vv_tsi_amt(cnt);
             v_ann_tsi_amt := v_ann_tsi_amt + vv_ann_tsi_amt(cnt);
             v_prem_amt    := v_prem_amt + vv_prem_amt(cnt);
          ELSIF pi_dist_no BETWEEN dist_min AND dist_max THEN
             v_tsi_amt     := vv_tsi_amt(cnt);
             v_ann_tsi_amt := vv_ann_tsi_amt(cnt);
             v_prem_amt    := vv_prem_amt(cnt);                          
             EXIT;               
          END IF;              
        END LOOP;
      END IF;

      IF pi_dist_no = dist_max THEN 
         UPDATE giuw_pol_dist
            SET tsi_amt       = NVL(v_tsi_amt,0) - (ROUND((NVL(v_tsi_amt,0)/dist_cnt),2) * (dist_cnt - 1)), 
                prem_amt      = NVL(v_prem_amt,0) - (ROUND((NVL(v_prem_amt,0)/dist_cnt),2) * (dist_cnt - 1)),
                ann_tsi_amt   = NVL(v_ann_tsi_amt,0) - (ROUND((NVL(v_ann_tsi_amt,0)/dist_cnt),2) * (dist_cnt - 1)),
                last_upd_date = sysdate,
                user_id       = user
            WHERE par_id  = b_par_id
              AND dist_no = pi_dist_no;                     
      ELSE
         UPDATE giuw_pol_dist
            SET tsi_amt       = NVL(v_tsi_amt,0)     / dist_cnt, 
                prem_amt      = NVL(v_prem_amt,0)    / dist_cnt,
                ann_tsi_amt   = NVL(v_ann_tsi_amt,0) / dist_cnt,
                last_upd_date = sysdate,
                user_id       = user
          WHERE par_id  = b_par_id
            AND dist_no = pi_dist_no;
      END IF;
    END IF;
  END LOOP;
  
  IF v_dist_exist = 'N' THEN   
    DECLARE                  
      p_no_of_takeup  GIIS_TAKEUP_TERM.no_of_takeup%TYPE;
      p_yearly_tag    GIIS_TAKEUP_TERM.yearly_tag%TYPE;
      p_takeup_term   GIPI_WPOLBAS.takeup_term%TYPE;                              
      v_policy_days   NUMBER:=0;
      v_no_of_payment NUMBER:=1;
      v_duration_frm  DATE;
      v_duration_to   DATE;    
      v_days_interval NUMBER:=0;

    BEGIN--5--
      SELECT eff_date,
             expiry_date, 
             endt_type,
             takeup_term
        INTO p_eff_date,
             p_expiry_date,
             p_endt_type,
             p_takeup_term
        FROM gipi_wpolbas
       WHERE par_id  =  b_par_id;
              
      IF ((p_eff_date IS NULL ) OR (p_expiry_date IS NULL)) THEN
        p_message := 'Could not proceed. The effectivity date or expiry date had not been updated.';
      END IF;
              
      IF TRUNC(p_expiry_date - p_eff_date) = 31 THEN
        v_policy_days := 30;
      ELSE
        v_policy_days := TRUNC(p_expiry_date - p_eff_date);
      END IF;
                
      FOR b1 IN (SELECT no_of_takeup, yearly_tag
                   FROM giis_takeup_term
                  WHERE takeup_term = p_takeup_term)
      LOOP
        p_no_of_takeup := b1.no_of_takeup;
        p_yearly_tag   := b1.yearly_tag;
      END LOOP;
                                
      IF p_yearly_tag = 'Y' THEN
         IF TRUNC((v_policy_days)/365,2) * p_no_of_takeup >
            TRUNC(TRUNC((v_policy_days)/365,2) * p_no_of_takeup) THEN
            v_no_of_payment   := TRUNC(TRUNC((v_policy_days)/365,2) * p_no_of_takeup) + 1;
         ELSE
            v_no_of_payment   := TRUNC(TRUNC((v_policy_days)/365,2) * p_no_of_takeup);
         END IF;
      ELSE
         IF v_policy_days < p_no_of_takeup THEN
            v_no_of_payment := v_policy_days;
         ELSE
            v_no_of_payment := p_no_of_takeup;
         END IF;
      END IF;
            
      IF NVL(v_no_of_payment, 0) < 1 THEN
         v_no_of_payment := 1;
      END IF;
            
      v_days_interval := ROUND(v_policy_days/v_no_of_payment);
      p_policy_id := NULL;
                         
      IF v_no_of_payment = 1 THEN -------------------------------------------------------- IF: Single takeup (x)                            
        DECLARE
         CURSOR C IS
           SELECT POL_DIST_DIST_NO_S.NEXTVAL
            FROM SYS.DUAL;
        BEGIN--6--
          OPEN C;
          FETCH C
           INTO p2_dist_no;

          IF C%NOTFOUND THEN
            p_message := 'No row in table SYS.DUAL';
          END IF;
          CLOSE C;
        EXCEPTION--6--
          WHEN OTHERS THEN
            NULL;
        END;--6--
         
        INSERT INTO giuw_pol_dist
                        (dist_no,    par_id,         policy_id,      endt_type,      tsi_amt,
                         prem_amt,   ann_tsi_amt,    dist_flag,      redist_flag,
                         eff_date,   expiry_date,    create_date,    user_id,
                         last_upd_date)
                 VALUES (p2_dist_no, b_par_id,       p_policy_id,    p_endt_type,    NVL(v_tsi_amt,0),
                         NVL(v_prem_amt,0), NVL(v_ann_tsi_amt,0),    1,  1, 
                         p_eff_date, p_expiry_date,  sysdate,        user,
                         sysdate);
      ELSE --------------------------------------------------------------------------------- ELSE: MULTI TAKE-UP (x)
           --------------------------------------------------------------------------------- LONG TERM LOOP start
         v_duration_frm := NULL;
         v_duration_to  := NULL;                                    
                
        FOR takeup_val IN 1.. v_no_of_payment LOOP 
          IF v_duration_frm IS NULL THEN
             v_duration_frm := TRUNC(p_eff_date);                                             
          ELSE
             v_duration_frm := TRUNC(v_duration_frm + v_days_interval);                           
          END IF;
             v_duration_to  := TRUNC(v_duration_frm + v_days_interval) - 1;
                                        
          DECLARE
            CURSOR C IS
              SELECT POL_DIST_DIST_NO_S.NEXTVAL
                FROM SYS.DUAL;
          BEGIN--7--
            OPEN C;
            FETCH C
             INTO p2_dist_no;
               IF C%NOTFOUND THEN
                 p_message := 'No row in table SYS.DUAL';
               END IF;
            CLOSE C;
          EXCEPTION--7--
            WHEN OTHERS THEN
              NULL;
          END;--7--
                        
          IF takeup_val = v_no_of_payment THEN --------------------------------------------- IF: last loop record (y)
             INSERT INTO giuw_pol_dist
                           (dist_no, par_id, policy_id, endt_type, 
                            dist_flag, redist_flag, eff_date, expiry_date, create_date, user_id,
                            last_upd_date, post_flag, auto_dist,
                            tsi_amt, 
                            prem_amt, 
                            ann_tsi_amt)
                    VALUES (p2_dist_no,b_par_id,p_policy_id,p_endt_type,                                                            
                            1,1,v_duration_frm,v_duration_to,sysdate,user,
                            sysdate, 'O', 'N',
                            NVL(v_tsi_amt,0) - (ROUND((NVL(v_tsi_amt,0)/ v_no_of_payment),2) * (v_no_of_payment - 1)),
                            NVL(v_prem_amt,0) - (ROUND((NVL(v_prem_amt,0)/ v_no_of_payment),2) * (v_no_of_payment - 1)),
                            NVL(v_ann_tsi_amt,0) - (ROUND((NVL(v_ann_tsi_amt,0)/ v_no_of_payment),2) * (v_no_of_payment - 1)));
          ELSE ----------------------------------------------------------------------------- ELSE: other loop records (y)
             INSERT INTO giuw_pol_dist
                           (dist_no, par_id, policy_id, endt_type, 
                            dist_flag, redist_flag, eff_date, expiry_date, create_date, user_id,
                            last_upd_date, post_flag, auto_dist,
                            tsi_amt, 
                            prem_amt, 
                            ann_tsi_amt)
                    VALUES (p2_dist_no,b_par_id,p_policy_id,p_endt_type,                                                            
                            1,1,v_duration_frm,v_duration_to,sysdate,user,
                            sysdate, 'O', 'N',
                            (NVL(v_tsi_amt,0)/ v_no_of_payment),
                            (NVL(v_prem_amt,0)/ v_no_of_payment),
                            (NVL(v_ann_tsi_amt,0)/ v_no_of_payment));
          END IF; -------------------------------------------------------------------------- END IF: loop record (y)
        END LOOP;
                ------------------------------------------------------------------------------------ LONG TERM LOOP end        
      END IF; ------------------------------------------------------------------------------ END IF TAKEUPS (x)    
    
    EXCEPTION--5--                   
      WHEN NO_DATA_FOUND THEN
        p_message := 'You had committed an illegal transaction. No records were retrieved in GIPI_WPOLBAS.';
      WHEN TOO_MANY_ROWS THEN        
        p_message := 'Multiple rows were found to exist in GIPI_WPOLBAS. Please call your administrator '||
                     'to rectify the matter. Check record with par_id = '||to_char(b_par_id);
    END;--5--
    
    DELETE FROM giuw_pol_dist a
          WHERE par_id  = b_par_id
            AND dist_no = pi_dist_no
            AND NOT EXISTS (SELECT 1 
                              FROM gipi_witem b
                             WHERE b.item_grp = NVL(a.item_grp,b.item_grp)
                               AND b.par_id = a.par_id);                          
  END IF;
END;
/


