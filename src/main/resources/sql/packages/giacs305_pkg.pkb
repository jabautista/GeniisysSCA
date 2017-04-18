CREATE OR REPLACE PACKAGE BODY CPI.giacs305_pkg
AS
   FUNCTION get_dept_list (
      p_fund_cd     giac_oucs.gibr_gfun_fund_cd%TYPE,
      p_branch_cd   giac_oucs.gibr_branch_cd%TYPE,
      p_claim_tag   giac_oucs.claim_tag%TYPE,
      p_ouc_cd      giac_oucs.ouc_cd%TYPE,
      p_ouc_name    giac_oucs.ouc_name%TYPE
   )
      RETURN dept_tab PIPELINED
   IS 
      v_rec   dept_type;
   BEGIN
      FOR i IN (SELECT ouc_id, gibr_gfun_fund_cd, gibr_branch_cd, ouc_cd, ouc_name, remarks,
                       claim_tag, user_id, last_update
                  FROM giac_oucs
                 WHERE gibr_gfun_fund_cd = p_fund_cd 
                   AND gibr_branch_cd = p_branch_cd
                   AND ouc_cd = NVL(p_ouc_cd, ouc_cd)
                   AND UPPER(ouc_name) LIKE UPPER(NVL(p_ouc_name, '%'))
                   AND UPPER(NVL(claim_tag, 'N')) = UPPER(NVL(p_claim_tag, NVL(claim_tag, 'N')))
               )
      LOOP
         v_rec.ouc_id := i.ouc_id;
         v_rec.gibr_gfun_fund_cd := i.gibr_gfun_fund_cd;
         v_rec.gibr_branch_cd := i.gibr_branch_cd;
         v_rec.ouc_cd := i.ouc_cd;
         v_rec.ouc_name := i.ouc_name;
         v_rec.remarks := i.remarks;
         v_rec.claim_tag := i.claim_tag;
         v_rec.user_id := i.user_id;
         v_rec.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MM:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_oucs (p_rec giac_oucs%ROWTYPE)
   IS
      v_ouc_id   giac_oucs.ouc_id%TYPE;
   BEGIN
      IF p_rec.ouc_id IS NULL
      THEN
         SELECT gouc_ouc_id_s.NEXTVAL
           INTO v_ouc_id
           FROM SYS.DUAL;
      END IF;

      MERGE INTO giac_oucs
         USING DUAL
         ON (ouc_id = p_rec.ouc_id)
         WHEN NOT MATCHED THEN
            INSERT (ouc_id, gibr_gfun_fund_cd, gibr_branch_cd, ouc_cd, ouc_name, user_id,
                    last_update, claim_tag, remarks)
            VALUES (v_ouc_id, p_rec.gibr_gfun_fund_cd, p_rec.gibr_branch_cd, p_rec.ouc_cd,
                    p_rec.ouc_name, p_rec.user_id, SYSDATE, p_rec.claim_tag, p_rec.remarks)
         WHEN MATCHED THEN
            UPDATE
               SET ouc_cd = p_rec.ouc_cd, ouc_name = p_rec.ouc_name, user_id = p_rec.user_id,
                   last_update = SYSDATE, claim_tag = p_rec.claim_tag, remarks = p_rec.remarks
            ;
   END;

   PROCEDURE del_ouc (p_ouc_id giac_oucs.ouc_id%TYPE)
   AS
   BEGIN
      DELETE FROM giac_oucs
            WHERE ouc_id = p_ouc_id;
   END;

   PROCEDURE val_delete_ouc (p_ouc_id giac_oucs.ouc_id%TYPE)
   AS
      v_exists   VARCHAR2 (1) := 'N'; -- jhing 01.26.2015 added default value N
      v_table    VARCHAR2 (50);
      v_dept_sl_type_cd giac_parameters.param_value_v%TYPE ;  -- jhing 01.26.2015 
   BEGIN
   
      -- jhing 01.26.2015 added retrieval of value of the parameter for sl_type_cd of department 
      BEGIN
        SELECT param_value_v GIAC_OUCS
          INTO v_dept_sl_type_cd
          FROM giac_parameters
         WHERE param_name = 'GOUC_DEPT_CD'; 
      EXCEPTION
        WHEN NO_DATA_FOUND THEN 
           raise_application_error
                 (-20001, 'Geniisys Exception#E#No records in parameter table.' );            
      END ;
      -- end jhing 01.26.2015 
      
   
      FOR i IN (SELECT 1
                      FROM giac_disb_vouchers gidv
                     WHERE gidv.gouc_ouc_id = p_ouc_id)
      LOOP
          v_exists := 'Y';
          v_table  := 'GIAC_DISB_VOUCHERS';
          EXIT;
      END LOOP;

      
      IF v_exists = 'N' THEN   -- jhing 01.26.2015 added checking on v_exists to prevent execution when violation is already encountered
          FOR i IN (SELECT 1
                      FROM giac_payt_requests gipr
                     WHERE gipr.gouc_ouc_id = p_ouc_id)
          LOOP
             v_exists := 'Y';
             v_table  := 'GIAC_PAYT_REQUESTS';
             EXIT;
          END LOOP;
      END IF; 
      
      -- jhing 01.26.2015 added checking in giac_acct_entries
      IF v_exists = 'N' THEN  
          FOR i IN (SELECT 1
                      FROM giac_acct_entries gacc
                     WHERE gacc.sl_type_cd = v_dept_sl_type_cd
                        AND gacc.sl_cd = p_ouc_id  )
          LOOP
             v_exists := 'Y';
             v_table  := 'GIAC_ACCT_ENTRIES';
             EXIT;
          END LOOP; 
      END IF;     

      IF v_exists = 'Y'
      THEN
         raise_application_error
                 (-20001,
                  --'Geniisys Exception#E#Delete not allowed. This Department has already been used.'
                  'Geniisys Exception#E#Cannot delete record from GIAC_OUCS while dependent record(s) in ' || v_table || ' exists.'
                 );
      END IF;
   END;
END;
/


