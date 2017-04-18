CREATE OR REPLACE PACKAGE BODY CPI.gicls171_pkg
AS
   FUNCTION get_rec_list (
      p_loss_exp_cd       giis_loss_exp.loss_exp_cd%TYPE,
      p_loss_exp_desc     giis_loss_exp.loss_exp_desc%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN
         (SELECT   a.loss_exp_cd, a.loss_exp_desc
              FROM giis_loss_exp a
             WHERE a.loss_exp_cd LIKE UPPER(NVL(p_loss_exp_cd, '%'))
               AND UPPER (a.loss_exp_desc) LIKE UPPER (NVL (p_loss_exp_desc, '%'))
               AND lps_sw = 'Y'
               AND line_cd = 'MC' 
               AND part_sw = 'Y' 
               AND loss_exp_type = 'L'
               AND comp_sw = '+'
          ORDER BY a.loss_exp_cd DESC)
      LOOP
         v_rec.loss_exp_cd := i.loss_exp_cd;
         v_rec.loss_exp_desc := i.loss_exp_desc;
         
         BEGIN
            SELECT tinsmith_light, tinsmith_medium,
                   tinsmith_heavy, painting, remarks,
                   user_id, TO_CHAR (last_update, 'MM-DD-YYYY HH:MI:SS AM')
              INTO v_rec.tinsmith_light, v_rec.tinsmith_medium,
                   v_rec.tinsmith_heavy, v_rec.painting,
                   v_rec.remarks, v_rec.user_id, v_rec.last_update
              FROM gicl_mc_lps
             WHERE loss_exp_cd = i.loss_exp_cd;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_rec.tinsmith_light := NULL;
            v_rec.tinsmith_medium := NULL;
            v_rec.tinsmith_heavy := NULL;
            v_rec.painting := NULL;
            v_rec.remarks := NULL;
            v_rec.user_id := NULL;
            v_rec.last_update := NULL;    
         END;
         
         BEGIN
            SELECT 'Y'
              INTO v_rec.hist_tag
              FROM gicl_mc_lps_hist
             WHERE loss_exp_cd = i.loss_exp_cd
               AND ROWNUM = 1;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_rec.hist_tag := 'N';       
         END;
         
         
         PIPE ROW (v_rec);
      END LOOP;
   END get_rec_list;
   
   PROCEDURE save_rec (
      p_rec gicl_mc_lps%ROWTYPE
   )
   IS
      v_hist_id   NUMBER;
   BEGIN
   
--      raise_application_error(-20001, 'Geniisys Exception#E#lossExpCd : ' || p_rec.loss_exp_cd); 
   
      MERGE INTO gicl_mc_lps
         USING DUAL
         ON (loss_exp_cd = p_rec.loss_exp_cd)
         WHEN NOT MATCHED THEN
            INSERT (loss_exp_cd, tinsmith_light, tinsmith_medium, tinsmith_heavy,
                    painting, remarks, user_id, last_update)
            VALUES (p_rec.loss_exp_cd, p_rec.tinsmith_light, p_rec.tinsmith_medium, p_rec.tinsmith_heavy,
                    p_rec.painting, p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET tinsmith_light = p_rec.tinsmith_light,
                   tinsmith_medium = p_rec.tinsmith_medium,
                   tinsmith_heavy = p_rec.tinsmith_heavy,
                   painting = p_rec.painting,
                   remarks = p_rec.remarks,
                   user_id = p_rec.user_id,
                   last_update = SYSDATE;
                   
      BEGIN
         SELECT NVL(MAX (history_id), 0) + 1
           INTO v_hist_id
           FROM gicl_mc_lps_hist
          WHERE loss_exp_cd = p_rec.loss_exp_cd;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_hist_id := 1;     
      END; 
      
      BEGIN
         INSERT INTO gicl_mc_lps_hist
                     (history_id, loss_exp_cd, tinsmith_light, tinsmith_medium,
                     tinsmith_heavy, painting, remarks, user_id, last_update)
            VALUES (v_hist_id, p_rec.loss_exp_cd, p_rec.tinsmith_light, p_rec.tinsmith_medium,
                     p_rec.tinsmith_heavy, p_rec.painting, p_rec.remarks, p_rec.user_id, SYSDATE);
      END;
                      
   END save_rec;
   
   FUNCTION get_lps_hist (p_loss_exp_cd VARCHAR2)
      RETURN lps_hist_tab PIPELINED
   IS
      v_list lps_hist_type;
   BEGIN
      FOR i IN (SELECT *
                 FROM gicl_mc_lps_hist
                WHERE loss_exp_cd = p_loss_exp_cd
               ORDER BY history_id)
      LOOP
         v_list.history_id := i.history_id;
         v_list.loss_exp_cd := i.loss_exp_cd;
         v_list.remarks := i.remarks;
         v_list.user_id := i.user_id;
         v_list.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_list.tinsmith_light := i.tinsmith_light;
         v_list.tinsmith_medium := i.tinsmith_medium;
         v_list.tinsmith_heavy := i.tinsmith_heavy;
         v_list.painting := i.painting;
         
         PIPE ROW(v_list);
      END LOOP;
   END get_lps_hist;   
   
END;
/


