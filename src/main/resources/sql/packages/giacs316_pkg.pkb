CREATE OR REPLACE PACKAGE BODY CPI.giacs316_pkg
AS
   FUNCTION get_rec_list (
      p_doc_code           giac_doc_sequence_user.doc_code%TYPE,
      p_branch_cd          giac_doc_sequence_user.branch_cd%TYPE,
      p_user_cd            giac_doc_sequence_user.user_cd%TYPE,
      p_user_name          VARCHAR2,
      p_doc_pref           giac_doc_sequence_user.doc_pref%TYPE,
      p_min_seq_no         giac_doc_sequence_user.min_seq_no%TYPE,
      p_max_seq_no         giac_doc_sequence_user.max_seq_no%TYPE,
      p_active_tag         VARCHAR2
   )
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
        
      FOR i IN (SELECT a.doc_code, a.branch_cd, a.user_cd, a.doc_pref,
                       a.min_seq_no, a.max_seq_no, a.active_tag,
                       a.remarks, a.user_id, a.last_update,
                       b.dcb_user_id nm
                  FROM giac_doc_sequence_user a, giac_dcb_users b
                 WHERE UPPER(a.doc_code) = UPPER(p_doc_code) 
                   AND UPPER(a.branch_cd) = UPPER(p_branch_cd)
                   AND a.user_cd = NVL(p_user_cd, a.user_cd)
                   AND UPPER(NVL(a.doc_pref, '%')) LIKE UPPER (NVL (p_doc_pref, '%'))
                   AND a.min_seq_no = NVL(p_min_seq_no, a.min_seq_no)
                   AND a.max_seq_no = NVL(p_max_seq_no, a.max_seq_no)
                   AND ( DECODE(a.active_tag, 'Y', 'YES', 'N', 'NO', '%') LIKE UPPER(NVL(p_active_tag, '%'))
                          OR  UPPER(a.active_tag) LIKE UPPER(NVL(p_active_tag, '%')) )
                   AND UPPER(b.dcb_user_id) LIKE UPPER(NVL(p_user_name, '%'))
                   AND UPPER(b.gibr_branch_cd) LIKE UPPER(NVL(p_branch_cd, '%'))
                   AND b.cashier_cd = a.user_cd
                 --ORDER BY a.doc_code, a.branch_cd, a.user_cd 
                   )                   
      LOOP
         v_rec.doc_code := i.doc_code;
         v_rec.branch_cd := i.branch_cd;
         v_rec.user_cd := i.user_cd;
         v_rec.doc_pref := i.doc_pref;
         v_rec.old_doc_pref := i.doc_pref;
         v_rec.min_seq_no := i.min_seq_no;
         v_rec.old_min_seq_no := i.min_seq_no;
         v_rec.max_seq_no := i.max_seq_no;
         v_rec.old_max_seq_no := i.max_seq_no;
         v_rec.active_tag := i.active_tag;
         v_rec.old_active_tag := i.active_tag;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         
         v_rec.user_name := i.nm;
         
--         FOR usr IN (SELECT dcb_user_id nm
--                       FROM giac_dcb_users
--                      WHERE cashier_cd     = i.user_cd
--                        AND gibr_branch_cd = p_branch_cd)
--         LOOP
--            v_rec.user_name := usr.nm;
--         END LOOP;
         
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (
--        p_rec giac_doc_sequence_user%ROWTYPE
        p_doc_code          giac_doc_sequence_user.doc_code%TYPE,
        p_branch_cd         giac_doc_sequence_user.branch_cd%TYPE,
        p_user_cd           giac_doc_sequence_user.user_cd%TYPE,
        p_doc_pref          giac_doc_sequence_user.doc_pref%TYPE,
        p_old_doc_pref      giac_doc_sequence_user.doc_pref%TYPE,
        p_min_seq_no        giac_doc_sequence_user.min_seq_no%TYPE,
        p_old_min_seq_no    giac_doc_sequence_user.min_seq_no%TYPE,
        p_max_seq_no        giac_doc_sequence_user.max_seq_no%TYPE,
        p_old_max_seq_no    giac_doc_sequence_user.max_seq_no%TYPE,
        p_active_tag        giac_doc_sequence_user.active_tag%TYPE,
        p_old_active_tag    giac_doc_sequence_user.active_tag%TYPE,
        p_remarks           giac_doc_sequence_user.remarks%TYPE,
        p_user_id           giac_doc_sequence_user.user_id%TYPE
   )
   IS
        v_branch_cd       giac_doc_sequence_user.branch_cd%TYPE;
        v_old_exists        NUMBER(1);
   BEGIN
   
       FOR i IN (SELECT 1
                   FROM giac_doc_sequence_user
                  WHERE doc_code = p_doc_code
                    AND branch_cd = p_branch_cd
                    AND user_cd = p_user_cd
                    AND doc_pref = p_old_doc_pref
                    AND min_seq_no = p_old_min_seq_no
                    AND max_seq_no = p_old_max_seq_no
                    AND NVL(active_tag, 'N') = NVL(p_old_active_tag, 'N')
                )
       LOOP
            v_old_exists := 1;
       END LOOP;
       
       IF v_old_exists = 1 THEN
       
            UPDATE giac_doc_sequence_user
               SET doc_pref    = p_doc_pref,
                   min_seq_no  = p_min_seq_no,
                   max_seq_no  = p_max_seq_no,
                   active_tag  = p_active_tag,
                   remarks     = p_remarks,
                   user_id     = p_user_id,
                   last_update = SYSDATE
             WHERE doc_code   = p_doc_code
               AND branch_cd  = p_branch_cd
               AND user_cd    = p_user_cd
               AND doc_pref   = p_old_doc_pref
               AND min_seq_no = p_old_min_seq_no
               AND max_seq_no = p_old_max_seq_no
               AND NVL(active_tag, 'N') = NVL(p_old_active_tag, 'N');
       
       ELSE
       
            INSERT
              INTO giac_doc_sequence_user
                   (doc_code,       branch_cd,      user_cd,
                    doc_pref,       min_seq_no,     max_seq_no,
                    active_tag,     remarks,
                    user_id,        last_update)
            VALUES (p_doc_code,     p_branch_cd,    p_user_cd,
                    p_doc_pref,     p_min_seq_no,   p_max_seq_no,
                    p_active_tag,   p_remarks,
                    p_user_id,      SYSDATE);
                    
       END IF;
   
      /*MERGE INTO giac_doc_sequence_user
         USING DUAL
         ON (    doc_code = p_rec.doc_code
             AND branch_cd = p_rec.branch_cd
             AND user_cd = p_rec.user_cd
             )
         WHEN NOT MATCHED THEN
            INSERT (doc_code,          branch_cd,           user_cd, 
                    doc_pref,          min_seq_no,          max_seq_no,     active_tag,
                    remarks,           user_id,             last_update)
            VALUES (p_rec.doc_code,    p_rec.branch_cd,     p_rec.user_cd, 
                    p_rec.doc_pref,    p_rec.min_seq_no,    p_rec.max_seq_no, p_rec.active_tag,
                    p_rec.remarks,     p_rec.user_id,       SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET --user_cd = p_rec.user_cd,
                   doc_pref     = p_rec.doc_pref,
                   min_seq_no   = p_rec.min_seq_no,
                   max_seq_no   = p_rec.max_seq_no,
                   active_tag   = p_rec.active_tag,
                   remarks      = p_rec.remarks, 
                   user_id      = p_rec.user_id, 
                   last_update  = SYSDATE
            ;*/
   END;

   PROCEDURE del_rec (p_rec giac_doc_sequence_user%ROWTYPE)
   AS
   BEGIN
      DELETE FROM giac_doc_sequence_user
            WHERE doc_code   = p_rec.doc_code
              AND branch_cd  = p_rec.branch_cd
              AND user_cd    = p_rec.user_cd
              AND doc_pref   = p_rec.doc_pref
              AND min_seq_no = p_rec.min_seq_no
              AND max_seq_no = p_rec.max_seq_no;
              --AND active_tag = p_rec.active_tag;
   END;

   PROCEDURE val_del_rec (
      p_doc_code         giac_doc_sequence_user.doc_code%TYPE,
      p_branch_cd        giac_doc_sequence_user.branch_cd%TYPE,
      p_user_cd          giac_doc_sequence_user.user_cd%TYPE,
      p_doc_pref         giac_doc_sequence_user.doc_pref%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      NULL;
   END;

   PROCEDURE val_add_rec(
      p_doc_code        giac_doc_sequence_user.doc_code%TYPE,
      p_branch_cd       giac_doc_sequence_user.branch_cd%TYPE,
      p_user_cd         giac_doc_sequence_user.user_cd%TYPE,
      p_doc_pref        giac_doc_sequence_user.doc_pref%TYPE,
      p_min_seq_no      giac_doc_sequence_user.min_seq_no%TYPE,
      p_max_seq_no      giac_doc_sequence_user.max_seq_no%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN   
       NULL;      
   END;
   
   FUNCTION get_giacs316_branch_lov(
        p_doc_code       cg_ref_codes.rv_low_value%TYPE,
        p_module_id      giis_modules.module_id%TYPE,
        p_user           giis_users.user_id%TYPE
   ) RETURN giacs316_branch_tab PIPELINED
   IS
        v_branch  giacs316_branch_type;
   BEGIN
   
        FOR rec IN ( SELECT DISTINCT (b.iss_cd), b.iss_name, a.rv_low_value, a.rv_meaning
                       FROM cg_ref_codes a, giis_issource b
                      WHERE b.claim_tag != 'Y'
                        AND a.rv_domain = 'GIAC_DOC_SEQUENCE_USER.DOC_CODE'
                        AND a.rv_low_value = p_doc_code
                        AND check_user_per_iss_cd_acctg2 (NULL, b.iss_cd, p_module_id, p_user) = 1
                   ORDER BY a.rv_low_value, b.iss_cd )
        LOOP
            v_branch.iss_cd := rec.iss_cd;
            v_branch.iss_name := rec.iss_name;
            v_branch.doc_type := rec.rv_low_value;
            v_branch.doc_type_mean := rec.rv_meaning;
            PIPE ROW(v_branch);
        END LOOP;
   END; 
   
   FUNCTION get_giacs316_user_lov(
        p_iss_cd        giac_dcb_users.gibr_branch_cd%TYPE
   ) RETURN giacs316_user_tab PIPELINED
   IS
        v_user      giacs316_user_type;
   BEGIN
   
        FOR i IN (  SELECT cashier_cd, dcb_user_id
                      FROM giac_dcb_users
                     WHERE UPPER(gibr_branch_cd) LIKE UPPER(p_iss_cd)
                     order by cashier_cd, dcb_user_id)
        LOOP
            v_user.cashier_cd := i.cashier_cd;
            v_user.dcb_user_id := i.dcb_user_id;
            PIPE ROW(v_user);
        END LOOP;
   END; 
   
   PROCEDURE validate_min_seq_no(
        p_doc_code        giac_doc_sequence_user.doc_code%TYPE,
        p_branch_cd       giac_doc_sequence_user.branch_cd%TYPE,
        p_doc_pref        giac_doc_sequence_user.doc_pref%TYPE,
        p_min_seq_no      giac_doc_sequence_user.min_seq_no%TYPE,
        p_max_seq_no      giac_doc_sequence_user.max_seq_no%TYPE,
        p_old_min_seq_no  giac_doc_sequence_user.min_seq_no%TYPE
   ) IS
        v_num			NUMBER;
   BEGIN
   
        --IF p_old_min_seq_no IS NULL THEN
        
            IF p_max_seq_no IS NULL THEN
        
                 SELECT DISTINCT 1   --added DISTINCT by reymon 01212011 
                   INTO v_num
                   FROM giac_doc_sequence_user
                  WHERE doc_code  = p_doc_code
                    AND branch_cd = p_branch_cd
                    AND doc_pref  = p_doc_pref
                    AND p_min_seq_no BETWEEN min_seq_no AND max_seq_no;
                    
                raise_application_error (-20001,'Geniisys Exception#E#Sequence number is already used.');
                
            ELSE
                IF p_old_min_seq_no IS NULL THEN            
                    GIACS316_PKG.validate_max_seq_no(p_doc_code, p_branch_cd, p_doc_pref, p_min_seq_no, p_max_seq_no, NULL);
                END IF;
            END IF;
            
        IF p_old_min_seq_no IS NOT NULL THEN
        
            SELECT 1
              INTO v_num
              FROM giac_doc_sequence_user
             WHERE doc_code  = p_doc_code
               AND branch_cd = p_branch_cd
               AND doc_pref  = p_doc_pref   
               AND (      min_seq_no BETWEEN p_min_seq_no AND (p_old_min_seq_no-1)
                      OR  max_seq_no BETWEEN p_min_seq_no AND (p_old_min_seq_no-1))
               AND ROWNUM = 1;
        
            IF v_num = 1 THEN
              raise_application_error (-20001, 'Geniisys Exception#E#Sequence number is already used.');
            END IF;
        
        END IF;
   
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;
   END;
   
   PROCEDURE validate_max_seq_no(
        p_doc_code        giac_doc_sequence_user.doc_code%TYPE,
        p_branch_cd       giac_doc_sequence_user.branch_cd%TYPE,
        p_doc_pref        giac_doc_sequence_user.doc_pref%TYPE,
        p_min_seq_no      giac_doc_sequence_user.min_seq_no%TYPE,
        p_max_seq_no      giac_doc_sequence_user.max_seq_no%TYPE,
        p_old_max_seq_no  giac_doc_sequence_user.max_seq_no%TYPE
   ) IS
        v_num			NUMBER;
   BEGIN
   
        IF p_old_max_seq_no IS NULL THEN  
              
            SELECT 1
              INTO v_num
              FROM giac_doc_sequence_user
             WHERE doc_code  = p_doc_code
               AND branch_cd = p_branch_cd
               AND doc_pref  = p_doc_pref   
               AND (      min_seq_no BETWEEN p_min_seq_no AND p_max_seq_no
                      OR  max_seq_no BETWEEN p_min_seq_no AND p_max_seq_no)
    --                  AND min_seq_no <> p_min_seq_no
    --                  AND max_seq_no <> p_max_seq_no )
               AND ROWNUM = 1;
             
            IF v_num = 1 THEN
              raise_application_error (-20001, 'Geniisys Exception#E#Sequence number is already used.');
            END IF;        
        
        ELSE
        
            SELECT 1
              INTO v_num
              FROM giac_doc_sequence_user
             WHERE doc_code  = p_doc_code
               AND branch_cd = p_branch_cd
               AND doc_pref  = p_doc_pref
               AND p_max_seq_no BETWEEN min_seq_no AND max_seq_no
               AND ROWNUM = 1;
        
            IF v_num = 1 THEN
              raise_application_error (-20001, 'Geniisys Exception#E#Sequence number is already used.');
            END IF;
        
        END IF;
        
   EXCEPTION
        WHEN NO_DATA_FOUND THEN
             NULL;
   END;
   
   PROCEDURE validate_active_tag(
        p_doc_code        giac_doc_sequence_user.doc_code%TYPE,
        p_branch_cd       giac_doc_sequence_user.branch_cd%TYPE,
        p_user_cd         giac_doc_sequence_user.user_cd%TYPE,
        p_doc_pref        giac_doc_sequence_user.doc_pref%TYPE,
        p_min_seq_no      giac_doc_sequence_user.min_seq_no%TYPE,
        p_max_seq_no      giac_doc_sequence_user.max_seq_no%TYPE,
        p_opt             VARCHAR2,
        p_old_min_seq_no  giac_doc_sequence_user.min_seq_no%TYPE,
        p_old_max_seq_no  giac_doc_sequence_user.max_seq_no%TYPE
   ) IS
        v_num				NUMBER;
        v_min				NUMBER;
        v_max				NUMBER;
   BEGIN
   
      IF p_opt = '1' THEN  -- record_status = CHANGED and active_Tag = Y
        
           SELECT min_seq_no, max_seq_no
             INTO v_min, v_max
             FROM giac_doc_sequence_user
            WHERE doc_code   = p_doc_code
              AND branch_cd  = p_branch_cd
              AND user_cd    = p_user_cd
              AND doc_pref   = p_doc_pref
              AND active_tag = 'Y';
        
            IF p_old_min_seq_no IS NULL AND p_old_max_seq_no IS NULL THEN
                raise_application_error (-20001, 'Geniisys Exception#E#User still has active sequence series.');
            ELSIF p_old_min_seq_no <> v_min AND p_old_max_seq_no <> v_max THEN
            
                IF v_min <> p_min_seq_no AND v_max <> p_max_seq_no THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#User still has active sequence series.');
                END IF;
            
            END IF;
        
      ELSE -- active_tag = Y
      
            SELECT min_seq_no, max_seq_no
             INTO v_min, v_max
             FROM giac_doc_sequence_user
            WHERE doc_code   = p_doc_code
              AND branch_cd  = p_branch_cd
              AND user_cd    = p_user_cd
              AND doc_pref   = p_doc_pref
              AND active_tag = 'Y';
              
            raise_application_error (-20001, 'Geniisys Exception#E#User still has active sequence series.');
            
      END IF;
        
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
   END;
   
END;
/


