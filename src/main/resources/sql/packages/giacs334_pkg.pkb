CREATE OR REPLACE PACKAGE BODY CPI.giacs334_pkg
AS
   FUNCTION get_rec_list (
      p_intm_no          giac_intm_pcomm_rt.intm_no%TYPE,
      p_line_cd          giac_intm_pcomm_rt.line_cd%TYPE,
      p_mgt_exp_rt       giac_intm_pcomm_rt.mgt_exp_rt%TYPE,
      p_prem_res_rt      giac_intm_pcomm_rt.prem_res_rt%TYPE,
      p_ln_comm_rt       giac_intm_pcomm_rt.ln_comm_rt%TYPE,
      p_profit_comm_rt   giac_intm_pcomm_rt.profit_comm_rt%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM giac_intm_pcomm_rt a
                 WHERE intm_no = p_intm_no
                   AND UPPER (a.line_cd) LIKE UPPER (NVL (p_line_cd, '%'))
                   AND NVL(mgt_exp_rt, 0) = NVL(p_mgt_exp_rt,NVL(mgt_exp_rt,0))
                   AND NVL(prem_res_rt, 0) = NVL(p_prem_res_rt,NVL(prem_res_rt,0))
                   AND NVL(ln_comm_rt, 0) = NVL(p_ln_comm_rt,NVL(ln_comm_rt,0))
                   AND NVL(profit_comm_rt, 0) = NVL(p_profit_comm_rt,NVL(profit_comm_rt,0))
               )
      LOOP
         v_rec.intm_no := i.intm_no;
         v_rec.line_cd := i.line_cd;
         v_rec.mgt_exp_rt := i.mgt_exp_rt;
         v_rec.prem_res_rt := i.prem_res_rt;
         v_rec.ln_comm_rt := i.ln_comm_rt;
         v_rec.profit_comm_rt := i.profit_comm_rt;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');

         FOR j IN (SELECT line_name
                     FROM giis_line
                    WHERE line_cd = i.line_cd)
         LOOP
            v_rec.line_name := j.line_name;
         END LOOP;

         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_intm_lov (p_user_id VARCHAR2, p_keyword VARCHAR2)
      RETURN intm_lov_tab PIPELINED
   IS
      v_list   intm_lov_type;
   BEGIN
      FOR i IN (SELECT intm_no, intm_name
                  FROM giis_intermediary
                 WHERE lic_tag = 'Y'
                   AND ( TO_CHAR(intm_no) LIKE NVL(p_keyword, intm_no)
                         OR
                         UPPER(intm_name) LIKE UPPER(NVL(p_keyword, intm_name))
                       ) 
               )
      LOOP
         v_list.intm_no := i.intm_no;
         v_list.intm_name := i.intm_name;
         PIPE ROW (v_list);
      END LOOP;
   END;

   FUNCTION get_line_lov (p_user_id VARCHAR2, p_keyword VARCHAR2)
      RETURN line_lov_tab PIPELINED
   IS
      v_list   line_lov_type;
   BEGIN
      FOR i IN (SELECT line_cd, line_name
                  FROM giis_line
                 WHERE prof_comm_tag = 'Y'
                   AND ( UPPER(line_cd) LIKE UPPER(NVL(p_keyword, line_cd))
                         OR
                         UPPER(line_name) LIKE UPPER(NVL(p_keyword, line_name))
                       ) 
               )
      LOOP
         v_list.line_cd := i.line_cd;
         v_list.line_name := i.line_name;
         PIPE ROW (v_list);
      END LOOP;
   END;

   PROCEDURE val_add_rec (
      p_intm_no   giac_intm_pcomm_rt.intm_no%TYPE,
      p_line_cd   giac_intm_pcomm_rt.line_cd%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giac_intm_pcomm_rt a
                 WHERE a.intm_no = p_intm_no AND a.line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same intm_no and line_cd.'
            );
      END IF;
   END;

   PROCEDURE set_rec (p_rec giac_intm_pcomm_rt%ROWTYPE)
   IS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT *
                  FROM giac_intm_pcomm_rt
                 WHERE intm_no = p_rec.intm_no AND line_cd = p_rec.line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         UPDATE giac_intm_pcomm_rt
            SET mgt_exp_rt = p_rec.mgt_exp_rt,
                prem_res_rt = p_rec.prem_res_rt,
                ln_comm_rt = p_rec.ln_comm_rt,
                profit_comm_rt = p_rec.profit_comm_rt,
                remarks = p_rec.remarks,
                user_id = p_rec.user_id,
                last_update = SYSDATE
          WHERE intm_no = p_rec.intm_no AND line_cd = p_rec.line_cd;
      ELSE
         INSERT INTO giac_intm_pcomm_rt
                     (intm_no, line_cd, mgt_exp_rt,
                      prem_res_rt, ln_comm_rt,
                      profit_comm_rt, remarks, user_id,
                      last_update
                     )
              VALUES (p_rec.intm_no, p_rec.line_cd, p_rec.mgt_exp_rt,
                      p_rec.prem_res_rt, p_rec.ln_comm_rt,
                      p_rec.profit_comm_rt, p_rec.remarks, p_rec.user_id,
                      SYSDATE
                     );
      END IF;
   END;

   PROCEDURE del_rec (
      p_intm_no   giac_intm_pcomm_rt.intm_no%TYPE,
      p_line_cd   giac_intm_pcomm_rt.line_cd%TYPE
   )
   AS
   BEGIN
      DELETE FROM giac_intm_pcomm_rt
            WHERE intm_no = p_intm_no AND line_cd = p_line_cd;
   END;
END;
/


