CREATE OR REPLACE PACKAGE BODY CPI.gicls058_pkg
AS
   FUNCTION get_rec_list (
      p_car_company_cd gicl_mc_part_cost.car_company_cd%TYPE,
      p_make_cd gicl_mc_part_cost.make_cd%TYPE,
      p_model_year  gicl_mc_part_cost.model_year%TYPE
   )
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT loss_exp_cd, loss_exp_desc
                  FROM giis_loss_exp
                 WHERE line_cd = 'MC' 
                   AND NVL (comp_sw, '+') = '+' 
                   AND loss_exp_type = 'L' 
                   AND part_sw = 'Y')                   
      LOOP
         v_rec.loss_exp_cd   := i.loss_exp_cd;
         v_rec.loss_exp_desc := i.loss_exp_desc;
         v_rec.part_cost_id  := null;
         v_rec.model_year    := null;
         v_rec.eff_date_org  := null;
         v_rec.orig_amt      := null;
         v_rec.eff_date_surp := null;
         v_rec.surp_amt      := null;
         v_rec.remarks       := null;
         v_rec.user_id       := null;
         v_rec.last_update   := null;
         
         FOR k IN (SELECT part_cost_id, eff_date_org, orig_amt, eff_date_surp, surp_amt, remarks, user_id, last_update, model_year
                     FROM gicl_mc_part_cost
                    WHERE car_company_cd = p_car_company_cd 
                      AND make_cd = p_make_cd 
                      AND loss_exp_cd = i.loss_exp_cd 
                      AND model_year = p_model_year)
         LOOP
             --v_rec.loss_exp_cd   := i.loss_exp_cd;
             --v_rec.loss_exp_desc := i.loss_exp_desc;
            v_rec.part_cost_id  := k.part_cost_id;
            v_rec.model_year    := k.model_year;
            v_rec.eff_date_org  := TO_CHAR(k.eff_date_org,'MM-DD-YYYY');
            v_rec.orig_amt      := k.orig_amt;
            v_rec.eff_date_surp := TO_CHAR(k.eff_date_surp,'MM-DD-YYYY');
            v_rec.surp_amt      := k.surp_amt;
            v_rec.remarks       := k.remarks;
            v_rec.user_id       := k.user_id;
            v_rec.last_update   := TO_CHAR (k.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         END LOOP;
         
         IF p_car_company_cd IS NOT NULL THEN
            PIPE ROW (v_rec);
         END IF;
      END LOOP;
      RETURN;
   END;

   PROCEDURE set_rec (p_rec gicl_mc_part_cost%ROWTYPE)
   IS
    v_pc_id    gicl_mc_part_cost.part_cost_id%TYPE;
    v_yr       VARCHAR2(1);
    v_gile     VARCHAR2(1);
    v_orig_amt gicl_mc_part_cost.orig_amt%TYPE;
    v_surp_amt gicl_mc_part_cost.surp_amt%TYPE;
    v_hist_no  gicl_mc_part_cost_hist.hist_no%TYPE;
   BEGIN
       FOR rec IN (SELECT model_year
  	                 FROM gicl_mc_part_cost
  	                WHERE car_company_cd = p_rec.car_company_cd
  	                  AND make_cd = p_rec.make_cd
                      AND model_year = p_rec.model_year)
  	   LOOP
  	       IF rec.model_year = p_rec.model_year THEN
  	           v_yr := 'Y';
  	           EXIT;
  	       END IF;
       END LOOP;
       
       BEGIN
           SELECT 'X', orig_amt, surp_amt
             INTO v_gile, v_orig_amt, v_surp_amt
             FROM gicl_mc_part_cost
            WHERE car_company_cd = p_rec.car_company_cd
              AND make_cd        = p_rec.make_cd
              AND loss_exp_cd    = p_rec.loss_exp_cd
              AND model_year     = p_rec.model_year;
       EXCEPTION
           WHEN NO_DATA_FOUND THEN 
               v_gile := NULL;
       END;    
       
       IF v_yr = 'Y' AND v_gile IS NOT NULL THEN
       
           v_pc_id := p_rec.part_cost_id;
       
           UPDATE gicl_mc_part_cost
              SET model_year     = p_rec.model_year,
                  car_company_cd = p_rec.car_company_cd,
                  make_cd        = p_rec.make_cd,
                  loss_exp_cd    = p_rec.loss_exp_cd,
                  orig_amt       = p_rec.orig_amt,
                  surp_amt       = p_rec.surp_amt,
                  eff_date_org   = TO_DATE(TO_CHAR(SYSDATE,'MM-DD-YYYY'),'MM-DD-YYYY'),
                  eff_date_surp  = TO_DATE(TO_CHAR(SYSDATE,'MM-DD-YYYY'),'MM-DD-YYYY'),
                  remarks        = p_rec.remarks,
                  user_id        = p_rec.user_id,
                  last_update    = SYSDATE
            WHERE part_cost_id   = p_rec.part_cost_id;
       ELSE
            SELECT mc_part_cost_s.NEXTVAL
              INTO v_pc_id
              FROM dual;
              
            INSERT INTO gicl_mc_part_cost
                        (part_cost_id, model_year, car_company_cd, make_cd, loss_exp_cd,
                         orig_amt, surp_amt, eff_date_org, eff_date_surp, 
                         remarks, user_id, last_update)
                 VALUES (v_pc_id, p_rec.model_year, p_rec.car_company_cd, p_rec.make_cd, p_rec.loss_exp_cd,
                         p_rec.orig_amt, p_rec.surp_amt, TO_DATE(TO_CHAR(SYSDATE,'MM-DD-YYYY'),'MM-DD-YYYY'), TO_DATE(TO_CHAR(SYSDATE,'MM-DD-YYYY'),'MM-DD-YYYY'),
                         p_rec.remarks, p_rec.user_id, SYSDATE);       
       END IF;
       
       IF NVL(v_orig_amt,0) != NVL(p_rec.orig_amt,0) OR NVL(v_surp_amt,0) != NVL(p_rec.surp_amt,0)
       THEN 
           FOR hist IN (SELECT NVL(MAX(hist_no),0) + 1  no
                        FROM gicl_mc_part_cost_hist
                       WHERE part_cost_id = p_rec.part_cost_id)
           LOOP
               v_hist_no := hist.no;       
               EXIT;
           END LOOP;
           
           INSERT INTO gicl_mc_part_cost_hist 
                       (hist_no,  part_cost_id, orig_amt, surp_amt, entry_date,   remarks,  user_id)
                VALUES (v_hist_no, v_pc_id, p_rec.orig_amt, p_rec.surp_amt, SYSDATE, p_rec.remarks,  p_rec.user_id);       
       END IF;
   END;

   PROCEDURE del_rec (p_part_cost_id gicl_mc_part_cost.part_cost_id%TYPE)
   AS
   BEGIN
      DELETE FROM gicl_mc_part_cost_hist
           WHERE part_cost_id = p_part_cost_id;
           
      DELETE FROM gicl_mc_part_cost
            WHERE part_cost_id = p_part_cost_id;
   END;
   
   PROCEDURE val_add_rec (
      p_car_company_cd gicl_mc_part_cost.car_company_cd%TYPE,
      p_make_cd        gicl_mc_part_cost.make_cd%TYPE,
      p_model_year     gicl_mc_part_cost.model_year%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT DISTINCT(model_year)
                  FROM gicl_mc_part_cost a
                 WHERE a.car_company_cd = p_car_company_cd
                 AND a.make_cd = p_make_cd
                 AND a.model_year = p_model_year)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same model_year.'
                                 );
      END IF;
   END;

   FUNCTION get_company_rec_list
      RETURN car_company_tab PIPELINED
   IS 
      v_rec   car_company_type;
   BEGIN
      FOR i IN (SELECT a.car_company_cd, a.car_company
                  FROM giis_mc_car_company a
              ORDER BY a.car_company_cd)                   
      LOOP
         v_rec.car_company_cd := i.car_company_cd;
         v_rec.car_company    := i.car_company;
         PIPE ROW (v_rec);
      END LOOP;
      RETURN;
   END;
               
   FUNCTION get_make_rec_list(
      p_car_company_cd  giis_mc_make.car_company_cd%TYPE
   )
      RETURN make_tab PIPELINED
   IS 
      v_rec   make_type;
   BEGIN
      FOR i IN (SELECT b.make_cd, b.make
                  FROM giis_mc_make b
                 WHERE b.car_company_cd = p_car_company_cd
              ORDER BY b.make_cd)                   
      LOOP
         v_rec.make_cd := i.make_cd;
         v_rec.make    := i.make;
         PIPE ROW (v_rec);
      END LOOP;
      RETURN;
   END;    

   FUNCTION check_model_year(
      p_car_company_cd  gicl_mc_part_cost.car_company_cd%TYPE,
      p_make_cd         gicl_mc_part_cost.make_cd%TYPE
   )
      RETURN VARCHAR2
   IS 
      v_rec   VARCHAR2(1) := 'N';
   BEGIN
      SELECT 'Y'
        INTO v_rec
        FROM gicl_mc_part_cost
       WHERE car_company_cd = p_car_company_cd
         AND make_cd        = p_make_cd
         AND ROWNUM = 1;                    
      RETURN v_rec;
   END;     

   FUNCTION get_model_year_rec_list (
      p_car_company_cd  gicl_mc_part_cost.car_company_cd%TYPE,
      p_make_cd         gicl_mc_part_cost.make_cd%TYPE
   )
      RETURN model_year_tab PIPELINED
   IS 
      v_rec   model_year_type;
   BEGIN
      FOR i IN (SELECT DISTINCT model_year
                  FROM gicl_mc_part_cost
                 WHERE car_company_cd = p_car_company_cd
                   AND make_cd        = p_make_cd)                   
      LOOP
         v_rec.model_year := i.model_year;
         PIPE ROW (v_rec);
      END LOOP;
      RETURN;
   END;   
   
      FUNCTION get_history_rec_list (
      p_part_cost_id  gicl_mc_part_cost.part_cost_id%TYPE
   )
      RETURN history_tab PIPELINED  
   IS 
      v_rec   history_type;
   BEGIN
      FOR i IN (SELECT part_cost_id, hist_no, orig_amt, surp_amt, TO_CHAR(entry_date,'MM-DD-YYYY') entry_date, user_id
                  FROM gicl_mc_part_cost_hist
                 WHERE part_cost_id = p_part_cost_id
              ORDER BY hist_no)                   
      LOOP
         v_rec.hist_no    := i.hist_no;
         v_rec.orig_amt   := i.orig_amt;
         v_rec.surp_amt   := i.surp_amt;
         v_rec.entry_date := i.entry_date;
         v_rec.user_id    := i.user_id;
         BEGIN
            SELECT a.loss_exp_cd,b.loss_exp_desc
              INTO v_rec.loss_exp_cd, v_rec.loss_exp_desc    
              FROM gicl_mc_part_cost a, giis_loss_exp b
             WHERE a.part_cost_id = i.part_cost_id
               AND a.loss_exp_cd  = b.loss_exp_cd
               AND loss_exp_type = 'L'
               AND ROWNUM = 1;
         END;
         PIPE ROW (v_rec);
      END LOOP;
      RETURN;
   END;          
END;
/


