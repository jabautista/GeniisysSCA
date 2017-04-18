CREATE OR REPLACE PACKAGE BODY CPI.GIACS335_PKG
AS
   FUNCTION get_rec_list
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (
      SELECT a.rep_cd, a.col_no, a.col_title, a.remarks, a.user_id,
                       a.last_update
                  FROM giac_soa_title a
                 ORDER BY a.rep_cd, a.col_no
                   )                   
      LOOP
         v_rec.rep_cd        := i.rep_cd; 
         v_rec.col_no        := i.col_no; 
         v_rec.col_title     := i.col_title;
         v_rec.remarks       := i.remarks;
         v_rec.user_id       := i.user_id;
         v_rec.last_update   := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giac_soa_title%ROWTYPE)
   IS
   BEGIN
      MERGE INTO GIAC_SOA_TITLE
         USING DUAL
         ON (rep_cd = p_rec.rep_cd
         and col_no = p_rec.col_no) 
         WHEN NOT MATCHED THEN
            INSERT (rep_cd, col_no,col_title, remarks, user_id, last_update)
            VALUES (p_rec.rep_cd, p_rec.col_no, p_rec.col_title, p_rec.remarks,
                    p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET col_title = p_rec.col_title,
                   remarks = p_rec.remarks, user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_rep_cd giac_soa_title.rep_cd%TYPE, p_col_no giac_soa_title.col_no%TYPE)
   AS
   BEGIN
      DELETE FROM GIAC_SOA_TITLE
            WHERE rep_cd = p_rep_cd
              AND col_no = p_col_no;
   END;

   FUNCTION val_del_rec (p_rep_cd giac_soa_title.rep_cd%TYPE)
    RETURN VARCHAR2
   AS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
        /*FOR a IN (
              SELECT 1
                FROM gicl_clm_loss_exp
               WHERE item_stat_cd = p_le_stat_cd
        )
        LOOP
            v_exists := 'Y';
            EXIT;
        END LOOP;
        RETURN (v_exists);*/
        RETURN NULL;
   END;

   FUNCTION val_add_rec (p_rep_cd giac_soa_title.rep_cd%TYPE, p_col_no giac_soa_title.col_no%TYPE)
   RETURN VARCHAR2
   IS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM GIAC_SOA_TITLE
                 WHERE rep_cd = p_rep_cd
                   AND col_no = p_col_no  
               )
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      /*IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same Code.'
                                 );
      END IF;*/
      
      RETURN (v_exists);
   END;
   
   FUNCTION get_giacs335_lov
    RETURN giacs335_lov_tab PIPELINED
   IS
        v_list giacs335_lov_type;
   BEGIN
        FOR i IN (
            SELECT rv_low_value, rv_meaning
              FROM cg_ref_codes
             WHERE rv_domain = 'GIAC_SOA_TITLE.REP_CD'
        )
        LOOP
            v_list.rv_low_value := i.rv_low_value;
            v_list.rv_meaning   := i.rv_meaning;
            
            PIPE ROW(v_list); 
        END LOOP;
        
        RETURN;
   END;
   
   
   PROCEDURE validate_rep_cd(
        p_rep_cd   IN OUT VARCHAR2
    )
    IS
    BEGIN
        SELECT rv_low_value
          INTO p_rep_cd
          FROM cg_ref_codes
         WHERE rv_domain = 'GIAC_SOA_TITLE.REP_CD'
           AND rv_low_value = p_rep_cd;
    EXCEPTION
        WHEN OTHERS THEN
            p_rep_cd := NULL;
    END;
    
END;
/


