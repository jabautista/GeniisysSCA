DROP PROCEDURE CPI.DIST_GIUW_POL_DIST_GIPIS165B;

CREATE OR REPLACE PROCEDURE CPI.dist_giuw_pol_dist_gipis165b(
                               p_par_id   GIPI_PARLIST.par_id%TYPE,
                        p_bond_tsi_amt   IN    gipi_winvoice.bond_tsi_amt%TYPE,
                        p_prem_amt       IN    gipi_winvoice.prem_amt%TYPE,
                        p_ann_tsi        IN    gipi_polbasic.ann_tsi_amt%TYPE,
                        p_bond_rate      IN    gipi_winvoice.bond_rate%TYPE,
                        p_message  OUT varchar2
                  )
 IS
  v_endt_type          gipi_polbasic.endt_type%TYPE;
  v_tsi_amt            gipi_polbasic.tsi_amt%TYPE;
  v_prem_amt          gipi_polbasic.prem_amt%TYPE;
  v_ann_tsi_amt        gipi_polbasic.ann_tsi_amt%TYPE;
  v_eff_date          gipi_polbasic.eff_date%TYPE;
  v_expiry_date        gipi_polbasic.expiry_date%TYPE;
  v_user_id            gipi_polbasic.user_id%TYPE;
  v_dist_no       giuw_pol_dist.dist_no%TYPE;
  ----------------- LONG TERM ---------------------
  v_takeup_term     gipi_wpolbas.takeup_term%TYPE;
  p_no_of_takeup  GIIS_TAKEUP_TERM.no_of_takeup%TYPE;
  p_yearly_tag    GIIS_TAKEUP_TERM.yearly_tag%TYPE;
    p_policy_id         GIPI_POLBASIC.policy_id%TYPE;                              
  v_policy_days   NUMBER:=0;
  v_no_of_payment NUMBER:=1;
  v_duration_frm  DATE;
  v_duration_to   DATE;              
  v_days_interval NUMBER:=0;
  ----------------- LT ----------------------------
BEGIN
  SELECT eff_date,expiry_date, takeup_term
    INTO v_eff_date,v_expiry_date, v_takeup_term
    FROM gipi_wpolbas
   WHERE par_id = p_par_id;
  IF TRUNC(v_expiry_date - v_eff_date) = 31 THEN
      v_policy_days      := 30;
    ELSE
      v_policy_days      := TRUNC(v_expiry_date - v_eff_date);
    END IF;
  FOR b1 IN (SELECT no_of_takeup, yearly_tag
                     FROM giis_takeup_term
                  WHERE takeup_term = v_takeup_term)
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
    IF v_no_of_payment < 1 THEN
        v_no_of_payment := 1;
    END IF;
    v_days_interval := ROUND(v_policy_days/v_no_of_payment);
    IF v_no_of_payment = 1 THEN -------------------------------------------------------- IF: Single takeup (x)
        BEGIN
        SELECT pol_dist_dist_no_s.NEXTVAL
          INTO v_dist_no 
          FROM DUAL;
      EXCEPTION
        WHEN NO_DATA_FOUND then
             p_message := 'Cannot generate new Distribution number.';
      END;
      INSERT INTO giuw_pol_dist
                  (dist_no,par_id,
                  tsi_amt,
                  prem_amt,
                  ann_tsi_amt,
                  dist_flag,
                  redist_flag,eff_date,expiry_date,create_date,user_id,
                  last_upd_date,post_flag, takeup_seq_no )  -- jhing 01.23.2015 added takeup_seq_no
           VALUES (v_dist_no,p_par_id, --change to blongterm
                  NVL(p_bond_tsi_amt,0),
                  NVL(p_prem_amt,0),
                  NVL(p_ann_tsi,0),
                  '1',1,v_eff_date,v_expiry_date,SYSDATE,USER,
                  SYSDATE,'O', 1 );   -- jhing 01.23.2015 added value for takeup_seq_no
    ELSE --------------------------------------------------------------------------------- ELSE: MULTI TAKE-UP (x)
        v_duration_frm := NULL;
        v_duration_to  := NULL;
        FOR takeup_val IN 1.. v_no_of_payment LOOP
        IF v_duration_frm IS NULL THEN
           v_duration_frm := TRUNC(v_eff_date);                                             
            ELSE
               v_duration_frm := TRUNC(v_duration_frm + v_days_interval);                           
            END IF;
            v_duration_to  := TRUNC(v_duration_frm + v_days_interval) - 1;
            BEGIN
            SELECT pol_dist_dist_no_s.NEXTVAL
              INTO v_dist_no 
              FROM DUAL;
          EXCEPTION
            WHEN NO_DATA_FOUND then
                 p_message := 'Cannot generate new Distribution number.';
          END;
            IF takeup_val = v_no_of_payment THEN --------------------------------------------- IF: last loop record (y)
                INSERT INTO giuw_pol_dist
                          (dist_no,par_id,
                          tsi_amt,
                          prem_amt,
                          ann_tsi_amt,
                          dist_flag,
                          redist_flag,eff_date,expiry_date,create_date,user_id,
                          last_upd_date,post_flag, item_grp,takeup_seq_no)
                   VALUES (v_dist_no,p_par_id,--change to blongterm
                          NVL(p_bond_tsi_amt,0) ,
                                      NVL(p_prem_amt,0) - (ROUND((NVL(p_prem_amt,0)/ v_no_of_payment),2) * (v_no_of_payment - 1)),
                                      NVL(p_ann_tsi,0) ,
                          '1',1,v_duration_frm,v_duration_to,SYSDATE,USER,
                          SYSDATE,'O',1,takeup_val);
            ELSE ----------------------------------------------------------------------------- ELSE: other loop records (y)
                INSERT INTO giuw_pol_dist
                          (dist_no,par_id,
                          tsi_amt,
                          prem_amt,
                          ann_tsi_amt,
                          dist_flag,
                          redist_flag,eff_date,expiry_date,create_date,user_id,
                          last_upd_date,post_flag,item_grp,takeup_seq_no)
                   VALUES (v_dist_no,p_par_id,
                          NVL(p_bond_tsi_amt,0),
                          NVL(p_prem_amt,0) / v_no_of_payment,
                          NVL(p_ann_tsi,0),
                          '1',1,v_duration_frm,v_duration_to,SYSDATE,USER,
                          SYSDATE,'O',1,takeup_val);
            END IF; -------------------------------------------------------------------------- END IF: loop record (y)            
        END LOOP;    
    END IF; ------------------------------------------------------------------------------ END IF TAKEUPS (x) 
END;
/


