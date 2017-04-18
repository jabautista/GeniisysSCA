CREATE OR REPLACE PACKAGE BODY CPI.gicls104_pkg
AS
   FUNCTION get_rec_list (
      p_line_cd             giis_loss_exp.line_cd%TYPE,
      p_loss_exp_cd         giis_loss_exp.loss_exp_cd%TYPE,
      p_loss_exp_desc       giis_loss_exp.loss_exp_desc%TYPE,
      p_loss_exp_type       VARCHAR2,
      p_peril_cd            NUMBER,
      p_comp_sw             VARCHAR2,
      p_part_sw             VARCHAR2
   )
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
        
      FOR i IN (SELECT a.line_cd, a.loss_exp_cd, a.loss_exp_desc, a.loss_exp_type,
                       DECODE(a.loss_exp_type, 'L', 'LOSS', 'E', 'EXPENSE', null) loss_exp_type_sp,
                       a.subline_cd,
                       a.comp_sw, a.part_sw, a.lps_sw, a.peril_cd,
                       a.remarks, a.user_id, a.last_update
                  FROM giis_loss_exp a
                 WHERE UPPER(a.line_cd) = UPPER(p_line_cd) 
                   AND UPPER(a.loss_exp_cd) LIKE UPPER(NVL(p_loss_exp_cd, '%'))
                   AND UPPER(a.loss_exp_desc) LIKE UPPER(nvl(p_loss_exp_desc, '%'))
--                   AND UPPER (NVL(a.loss_exp_type, '%')) LIKE UPPER (NVL (v_loss_exp_type, '%'))
                   AND NVL(a.peril_cd, 0) = NVL(p_peril_cd, NVL(a.peril_cd, 0))
                   AND NVL(a.comp_sw, '-') LIKE NVL(p_comp_sw, NVL(a.comp_sw, '-')) --modified by Pol, to handle null comp_sw
                   AND subline_cd IS NULL
                   AND UPPER(NVL(part_sw, 'N')) = UPPER(NVL(p_part_sw, NVL(part_sw, 'N'))) --Added by Pol, for gicls171
                 ORDER BY a.line_cd, a.losS_exp_cd
                   )                   
      LOOP
         v_rec.peril_name := NULL;
         v_rec.line_cd := i.line_cd;
         v_rec.loss_exp_cd := i.loss_exp_cd;
         v_rec.loss_exp_desc := i.loss_exp_desc;
         v_rec.loss_exp_type := i.loss_exp_type;
         v_rec.old_loss_exp_type := i.loss_exp_type;
         v_rec.loss_exp_type_sp := i.loss_exp_type_sp;       
         v_rec.comp_sw := i.comp_sw;
         v_rec.part_sw := NVL(i.part_sw, 'N');
         v_rec.lps_sw := NVL(i.lps_sw, 'N');
         v_rec.peril_cd := i.peril_cd;
         v_rec.subline_cd := i.subline_cd;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         
         BEGIN
            SELECT menu_line_cd
              INTO v_rec.menu_line_cd
              FROM giis_line
             WHERE line_cd = i.line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_rec.menu_line_cd := NULL;
         END;
         
         BEGIN
            IF i.peril_cd IS NOT NULL THEN
                SELECT peril_name
                  INTO v_rec.peril_name
                  FROM giis_peril
                 WHERE peril_cd = i.peril_cd
                   AND line_cd = i.line_cd;
            END IF;
         EXCEPTION
            WHEN no_data_found THEN
                v_rec.peril_name := NULL;
         END;
         
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (
      --p_rec giis_loss_exp%ROWTYPE
      p_line_cd               giis_loss_exp.line_cd%TYPE,
      p_loss_exp_cd           giis_loss_exp.loss_exp_cd%TYPE,
      p_loss_exp_desc         giis_loss_exp.loss_exp_desc%TYPE,
      p_loss_exp_type         giis_loss_exp.loss_exp_type%TYPE,
      p_old_loss_exp_type     giis_loss_exp.loss_exp_type%TYPE,
      p_comp_sw               giis_loss_exp.comp_sw%TYPE,
      p_part_sw               giis_loss_exp.part_sw%TYPE,
      p_lps_sw                giis_loss_exp.lps_sw%TYPE,
      p_peril_cd              giis_loss_exp.peril_cd%TYPE,
      p_subline_cd            giis_loss_exp.subline_cd%TYPE,
      p_remarks               giis_loss_exp.remarks%TYPE,
      p_user_id               giis_loss_exp.user_id%TYPE
   )
   IS
        v_loss_exp_cd       giis_loss_exp.loss_exp_cd%TYPE;
        v_old_exists        NUMBER(1);
   BEGIN
   
      FOR i IN (SELECT 1
                  FROM giis_loss_exp
                 WHERE line_cd = p_line_cd
                   AND subline_cd IS NULL
                   AND loss_exp_cd = p_loss_exp_cd
                   AND loss_exp_type = p_old_loss_exp_type)
      LOOP
            v_old_exists := 1;
      END LOOP;
         
      IF v_old_exists = 1 THEN
      
            IF p_loss_exp_type = p_old_loss_exp_type THEN
               
                UPDATE giis_loss_exp
                   SET loss_exp_desc = p_loss_exp_desc,
                       --loss_exp_type = p_loss_exp_type,
                       comp_sw      = p_comp_sw,
                       part_sw      = p_part_sw,
                       lps_sw       = p_lps_sw,
                       peril_cd     = p_peril_cd,
                       remarks      = p_remarks, 
                       user_id      = p_user_id, 
                       last_update  = SYSDATE
                 WHERE line_cd = p_line_cd
                   AND loss_exp_cd = p_loss_exp_cd
                   AND loss_exp_type = p_loss_exp_type;    
            
            ELSE            
                
                UPDATE giis_loss_exp
                   SET loss_exp_desc = p_loss_exp_desc,
                       loss_exp_type = p_loss_exp_type,
                       comp_sw      = p_comp_sw,
                       part_sw      = p_part_sw,
                       lps_sw       = p_lps_sw,
                       peril_cd     = p_peril_cd,
                       remarks      = p_remarks, 
                       user_id      = p_user_id, 
                       last_update  = SYSDATE
                 WHERE line_cd = p_line_cd
                   AND loss_exp_cd = p_loss_exp_cd
                   AND loss_exp_type = p_old_loss_exp_type;
               
             END IF;
      
      ELSE
            INSERT 
              INTO giis_loss_exp
                   (line_cd,                loss_exp_cd,       loss_exp_desc, 
                    loss_exp_type,          comp_sw,           part_sw,           lps_sw,
                    peril_cd,               remarks,           user_id,           last_update)
            VALUES (p_line_cd,          p_loss_exp_cd, p_loss_exp_desc, 
                    p_loss_exp_type,    p_comp_sw,     p_part_sw,     p_lps_sw,
                    p_peril_cd,         p_remarks,     p_user_id,     SYSDATE);
                    
      END IF;   
   
      /*MERGE INTO giis_loss_exp
         USING DUAL
         ON (    line_cd = p_rec.line_cd
             AND loss_exp_cd = p_rec.loss_exp_cd
             --AND loss_exp_type = p_rec.loss_exp_type
             )
         WHEN NOT MATCHED THEN
            INSERT (line_cd,                loss_exp_cd,       loss_exp_desc, 
                    loss_exp_type,          comp_sw,           part_sw,           lps_sw,
                    peril_cd,               remarks,           user_id,           last_update)
            VALUES (p_rec.line_cd,          p_rec.loss_exp_cd, p_rec.loss_exp_desc, 
                    p_rec.loss_exp_type,    p_rec.comp_sw,     p_rec.part_sw,     p_rec.lps_sw,
                    p_rec.peril_cd,         p_rec.remarks,     p_rec.user_id,     SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET loss_exp_desc = p_rec.loss_exp_desc,
                   loss_exp_type  = p_rec.loss_exp_type,
                   comp_sw      = p_rec.comp_sw,
                   part_sw      = p_rec.part_sw,
                   lps_sw       = p_rec.lps_sw,
                   peril_cd     = p_rec.peril_cd,
                   remarks      = p_rec.remarks, 
                   user_id      = p_rec.user_id, 
                   last_update  = SYSDATE
            ;*/
   END;

   PROCEDURE del_rec (
        p_line_cd               giis_loss_exp.line_cd%TYPE,
        p_loss_exp_cd           giis_loss_exp.loss_exp_cd%TYPE,
        p_loss_exp_type         giis_loss_exp.loss_exp_type%TYPE
   )
   AS
   BEGIN
      DELETE FROM giis_loss_exp
            WHERE line_cd    = p_line_cd
              AND subline_cd IS NULL
              AND loss_exp_cd = p_loss_exp_cd
              AND loss_exp_type = p_loss_exp_type;
   END;

   PROCEDURE val_del_rec (
        p_line_cd        giis_loss_exp.line_cd%TYPE,
        p_subline_cd     giis_loss_exp.subline_cd%TYPE,
        p_loss_exp_cd    giis_loss_exp.loss_exp_cd%TYPE,
        p_loss_exp_type  giis_loss_exp.loss_exp_type%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
--      NULL;
    
        FOR a in (SELECT a.line_cd, a.subline_cd, a.loss_exp_cd, a.loss_exp_type  
                    FROM gicl_loss_exp_dtl a, giis_loss_exp b
                   WHERE a.line_cd = b.line_cd
                     AND NVL(a.subline_cd,'XX') = NVL(b.subline_cd,'XX')
                     AND a.loss_exp_type = b.loss_exp_type
                     AND a.loss_exp_cd = b.loss_exp_cd
                     AND a.line_cd = p_line_cd
                     AND NVL(a.subline_cd,'XX') = NVL(p_subline_cd,'XX')
                     AND a.loss_exp_cd = p_loss_exp_cd
                     AND a.loss_exp_type = p_loss_exp_type ) 
        LOOP
--            msg_alert('Cannot delete record. Loss/Expense code already in used.','I', TRUE);
            v_exists := 'Y';
        END LOOP;
        
        IF v_exists = 'Y' THEN
            raise_application_error (-20001,'Geniisys Exception#E#Cannot delete record from GIIS_LOSS_EXP while dependent record(s) in GICL_LOSS_EXP_DTL exists.');
        END IF;

   END;

   PROCEDURE val_add_rec(
        p_line_cd           giis_loss_exp.line_cd%TYPE,
        p_loss_exp_cd       giis_loss_exp.loss_exp_cd%TYPE,
        p_loss_exp_type     giis_loss_exp.loss_exp_type%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_loss_exp a
                 WHERE a.line_cd        = p_line_cd
                   AND a.subline_cd IS NULL
                   AND a.loss_exp_cd    = p_loss_exp_cd
                   AND a.loss_exp_type  = p_loss_exp_type)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y' THEN
         raise_application_error (-20001, 'Geniisys Exception#E#Record already exists with same line_cd, loss_exp_cd, and loss_exp_type.');
      END IF;
      
   END;
   
   PROCEDURE validate_part_sw(
        p_loss_exp_cd   IN       giis_loss_exp.loss_exp_cd%TYPE,
        p_part_var      OUT      VARCHAR2,
        p_part_exists   OUT      VARCHAR2,
        p_lps_exists    OUT      VARCHAR2
   )
   IS
        v_exists    varchar2(1) :='N';
        v_exists2   varchar2(1) :='N';
        var         varchar2(1);
        --var2        varchar2(1);
   BEGIN
        FOR chk IN(SELECT DISTINCT special_part_cd
                     FROM gicl_mc_depreciation a
                    WHERE a.special_part_cd = p_loss_exp_cd
                    UNION
                   SELECT DISTINCT a.loss_exp_cd 
                     FROM gicl_mc_part_cost a
                    WHERE a.loss_exp_cd = p_loss_exp_cd)    						
        LOOP 
            var :='X';
            v_exists := 'Y';
        END LOOP;
        
        --dannel 05/25/2006
        ---check if it already exist in gicl_mc_lps
        FOR a IN (SELECT DISTINCT loss_exp_cd 
                    FROM gicl_mc_lps 
                   WHERE loss_exp_cd = p_loss_exp_cd)							
        LOOP
            v_exists2:='Y';  
        END LOOP;
        
        p_part_var := var;
        p_part_exists := v_exists;
        p_lps_exists := v_exists2;
        
   END;
   
   FUNCTION validate_lps_sw(
        p_loss_exp_cd  giis_loss_exp.loss_exp_cd%TYPE
   ) RETURN VARCHAR2 
   IS
        v_exists VARCHAR2(1);
   BEGIN
   
    	FOR chk_dtl IN(
    	  	SELECT 	'1'
    	  	  FROM  gicl_mc_lps_hist
    	  	 where  loss_exp_cd = p_loss_exp_cd)    	  	
    	LOOP  	  
  	    v_exists :='Y';
  	    EXIT;
  	  END LOOP;  
   
      RETURN (v_exists);
   END;
   
   PROCEDURE validate_comp_sw(
        p_line_cd           IN      giis_loss_exp.line_cd%TYPE,
        p_loss_exp_cd       IN      giis_loss_exp.loss_exp_cd%TYPE,
        p_loss_exp_desc     IN      giis_loss_exp.loss_exp_desc%TYPE,
        p_loss_exp_type     IN      giis_loss_exp.loss_exp_type%TYPE,
        p_var               OUT     VARCHAR2,
        p_comp_sw           OUT     VARCHAR2
   ) IS
        var		varchar(2);
   BEGIN
   
        FOR a in (SELECT DISTINCT 'X'
                  FROM gicl_loss_exp_dtl a
                 WHERE a.line_cd = p_line_cd
                   AND a.loss_exp_type = p_loss_exp_type
                   AND a.loss_exp_cd = p_loss_exp_cd 
                   AND subline_cd IS NULL) 
        LOOP
          p_var := 'X'; 
        END LOOP;
        
        /*BEGIN
            SELECT comp_sw
              INTO p_comp_sw
              FROM giis_loss_exp
             WHERE line_cd = 'MC'
               AND loss_exp_type = p_loss_exp_type
               AND loss_exp_cd = p_loss_exp_cd
               AND loss_exp_desc = p_loss_exp_desc;
  
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_comp_sw := NULL;
            
        END;*/
            
   END;
   
   FUNCTION validate_loss_exp_type(
        p_line_cd           giis_loss_exp.line_cd%TYPE,
        p_subline_cd        giis_loss_exp.subline_cd%TYPE,
        p_loss_exp_cd       giis_loss_exp.loss_exp_cd%TYPE,
        p_loss_exp_type     giis_loss_exp.loss_exp_type%TYPE
   ) RETURN VARCHAR2
   IS
        v_exist    VARCHAR2(1) := 'N';
   BEGIN
   
        FOR a IN (SELECT a.line_cd, a.subline_cd, a.loss_exp_cd, a.loss_exp_type  
                    FROM gicl_loss_exp_dtl a, giis_loss_exp b
                   WHERE a.line_cd = b.line_cd
                     AND NVL(a.subline_cd,'XX') = NVL(b.subline_cd,'XX')
                     AND a.loss_exp_type = b.loss_exp_type
                     AND a.loss_exp_cd = b.loss_exp_cd
                     AND a.line_cd = p_line_cd
                     AND NVL(a.subline_cd,'XX') = NVL(p_subline_cd,'XX')
                     AND a.loss_exp_cd = p_loss_exp_cd
                     AND a.loss_exp_type = p_loss_exp_type)
        LOOP
            v_exist := 'Y';
        END LOOP; 
        
        RETURN (v_exist);
        	
   END;
   
   FUNCTION get_peril_lov(
        p_line_cd       giis_loss_exp.line_cd%TYPE,
        p_keyword       VARCHAR2
   ) RETURN peril_tab PIPELINED
   IS
        v_peril     peril_type;
   BEGIN
        FOR i IN (SELECT A.peril_cd, A.peril_name
                    FROM giis_peril a
                   WHERE UPPER(a.line_cd) = UPPER(p_line_cd)
                     AND ( UPPER(A.peril_name) LIKE UPPER(NVL(p_keyword, '%') )
                            OR A.peril_cd LIKE NVL(p_keyword, A.peril_cd)
                         )
                   ORDER BY 1)
        LOOP
            v_peril.peril_cd := i.peril_cd;
            v_peril.peril_name := i.peril_name;
            PIPE ROW(v_peril);
        END LOOP;
   END;
   
END;
/


