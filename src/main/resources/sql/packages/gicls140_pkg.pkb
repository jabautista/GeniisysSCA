CREATE OR REPLACE PACKAGE BODY CPI.gicls140_pkg
AS
   FUNCTION get_rec_list (
      p_payee_class_cd     giis_payee_class.payee_class_cd%TYPE,
      p_class_desc   giis_payee_class.class_desc%TYPE
   )
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT a.eval_sw, a.loa_sw, a.payee_class_cd, a.class_desc, a.payee_class_tag, 
                       a.master_payee_class_cd, a.sl_type_tag, a.sl_type_cd, a.clm_vat_cd,
                       DECODE(a.payee_class_tag,'S','System Generated','Manual') dsp_pc_tag_desc,
                       a.remarks, a.user_id, a.last_update
                  FROM giis_payee_class a
                 WHERE UPPER (a.payee_class_cd) LIKE UPPER (NVL (p_payee_class_cd, '%'))
                   AND UPPER (a.class_desc) LIKE UPPER (NVL (p_class_desc, '%'))
                 ORDER BY a.payee_class_cd
                   )                   
      LOOP
         v_rec.eval_sw               := NVL(i.eval_sw,'N');
         v_rec.loa_sw                := NVL(i.loa_sw,'N');
         v_rec.payee_class_cd        := i.payee_class_cd;
         v_rec.class_desc            := i.class_desc;
         v_rec.payee_class_tag       := i.payee_class_tag;
         v_rec.dsp_pc_tag_desc       := i.dsp_pc_tag_desc;
         v_rec.master_payee_class_cd := i.master_payee_class_cd;
         v_rec.sl_type_tag           := NVL(i.sl_type_tag,'N');
         v_rec.sl_type_cd            := i.sl_type_cd;
         v_rec.clm_vat_cd            := i.clm_vat_cd;
         v_rec.remarks               := i.remarks;
         v_rec.user_id               := i.user_id;
         v_rec.last_update           := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_payee_class%ROWTYPE)
   IS
      v_sl_type_count  NUMBER;
      v_sl_type_max    NUMBER;
      v_count          NUMBER;
      v_remarks_sysgen giac_sl_types.remarks%TYPE :='This is System Generated from GIIS_PAYEE_CLASS';
      v_sl_tag	       giac_sl_types.sl_tag%TYPE := 'S';
      v_os_flag	       giac_sl_types.os_flag%TYPE := 'Y';
      v_param_value_v  giac_parameters.param_value_v%TYPE;
      v_remarks        giac_sl_types.remarks%TYPE;
      v_class_desc     giis_payee_class.class_desc%TYPE;
      v_sl_type_cd     giis_payee_class.sl_type_cd%TYPE;
   BEGIN
        BEGIN
            SELECT COUNT(*), remarks, class_desc 
              INTO v_count, v_remarks, v_class_desc
              FROM giis_payee_class
             WHERE payee_class_cd = p_rec.payee_class_cd
          GROUP BY remarks, class_desc;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_count := 0; v_remarks := ''; v_class_desc := '';
        END; 
        SELECT COUNT(*) 
          INTO v_sl_type_count
          FROM giac_sl_types
         WHERE giac_sl_types.sl_type_cd = p_rec.payee_class_cd;
               
        SELECT param_value_v
          INTO v_param_value_v
          FROM giac_parameters
	     WHERE param_name = 'FUND_CD';                
        
        IF v_count = 0
        THEN
            IF p_rec.sl_type_tag = 'Y'
            THEN
                IF v_sl_type_count = 0 
                THEN
                    INSERT INTO giac_sl_types
                                (sl_type_cd, sl_type_name, user_id, last_update, remarks, sl_tag, os_flag)
                         VALUES (p_rec.payee_class_cd, p_rec.class_desc, p_rec.user_id, SYSDATE,'This is System Generated from GIIS_PAYEE_CLASS','S','Y');
                    v_sl_type_cd := p_rec.payee_class_cd;
                ELSE
                
                    SELECT MAX(TO_NUMBER(sl_type_cd))
                      INTO v_sl_type_max
                      FROM giac_sl_types;    
                                  
                    INSERT INTO giac_sl_types
                                (sl_type_cd, sl_type_name, user_id, last_update, remarks, sl_tag, os_flag)
                         VALUES (v_sl_type_max+1, p_rec.class_desc, p_rec.user_id, SYSDATE, 'This is System Generated from GIIS_PAYEE_CLASS','S','Y');  
                    v_sl_type_cd := v_sl_type_max+1;              
                END IF;
            ELSE
                v_sl_type_cd := p_rec.sl_type_cd;    
            END IF;          
            INSERT INTO giis_payee_class 
                        (eval_sw, loa_sw, payee_class_cd, class_desc, payee_class_tag, 
                         master_payee_class_cd, sl_type_tag, sl_type_cd, clm_vat_cd,
                         remarks, user_id, last_update)
                 VALUES (p_rec.eval_sw, p_rec.loa_sw, p_rec.payee_class_cd, p_rec.class_desc, p_rec.payee_class_tag, 
                         p_rec.master_payee_class_cd, p_rec.sl_type_tag, v_sl_type_cd, p_rec.clm_vat_cd,
                         p_rec.remarks, p_rec.user_id, SYSDATE);
        ELSE
            IF p_rec.sl_type_tag = 'Y'
            THEN
                IF v_class_desc = p_rec.class_desc AND v_remarks = p_rec.remarks
                THEN
                    IF v_sl_type_count = 0
                    THEN
                        INSERT INTO giac_sl_types
                                    (sl_type_cd,sl_type_name,user_id,last_update,remarks,sl_tag,os_flag)
                             VALUES (p_rec.payee_class_cd, p_rec.class_desc, p_rec.user_id, SYSDATE, v_remarks_sysgen, v_sl_tag, v_os_flag);
                        v_sl_type_cd := p_rec.payee_class_cd; 
                        FOR x IN(SELECT payee_class_cd, payee_last_name, payee_first_name, payee_middle_name, payee_no 		                
                                   FROM giis_payees WHERE payee_class_cd =  p_rec.payee_class_cd)
                        LOOP
                            INSERT INTO giac_sl_lists
                                        (fund_cd, sl_type_cd, sl_cd, sl_name, remarks, user_id, last_update)
      		                     VALUES (v_param_value_v, x.payee_class_cd, x.payee_no, x.payee_first_name||' '||x.payee_middle_name||' '||x.payee_last_name,
             		                     'This is System Generated from GIIS_PAYEES', p_rec.user_id, SYSDATE);     
                        END LOOP; 
                    ELSE
                        SELECT MAX(TO_NUMBER(sl_type_cd))
                          INTO v_sl_type_max
                          FROM giac_sl_types;
                          
                        INSERT INTO giac_sl_types
                                   (sl_type_cd, sl_type_name, user_id, last_update, remarks, sl_tag, os_flag)
                            VALUES (v_sl_type_max + 1, p_rec.class_desc, p_rec.user_id, SYSDATE, v_remarks_sysgen, v_sl_tag, v_os_flag);
                        v_sl_type_cd := v_sl_type_max+1;  
                        FOR x IN(SELECT payee_class_cd, payee_last_name, payee_first_name, payee_middle_name, payee_no 		                
                                   FROM giis_payees WHERE payee_class_cd =  p_rec.payee_class_cd)
                        LOOP
                          INSERT INTO giac_sl_lists
                                      (fund_cd, sl_type_cd, sl_cd, sl_name, remarks, user_id, last_update)
                               VALUES (v_param_value_v, v_sl_type_max + 1, x.payee_no, x.payee_first_name || ' ' || x.payee_middle_name || ' ' || x.payee_last_name, 
                                       'This is System Generated from GIIS_PAYEES', p_rec.user_id, SYSDATE);
                        END LOOP;                                 	
                    END IF;
                ELSE
                    IF p_rec.sl_type_cd IS NULL 
                    THEN
                        IF v_sl_type_count = 0 
                        THEN
                            INSERT INTO giac_sl_types
                                        (sl_type_cd, sl_type_name, user_id, last_update, remarks, sl_tag, os_flag)
                                 VALUES (p_rec.payee_class_cd, p_rec.class_desc, p_rec.user_id, SYSDATE, v_remarks_sysgen, v_sl_tag, v_os_flag);
                            v_sl_type_cd := p_rec.payee_class_cd; 
                            FOR x IN(SELECT payee_class_cd, payee_last_name, payee_first_name, payee_middle_name, payee_no 		                
                                       FROM giis_payees WHERE payee_class_cd =  p_rec.payee_class_cd)
                            LOOP
                                SELECT param_value_v
                                  INTO v_param_value_v
                                  FROM giac_parameters
                                 WHERE param_name = 'FUND_CD';
                                
                                INSERT INTO giac_sl_lists
                                            (fund_cd, sl_type_cd, sl_cd, sl_name, remarks, user_id, last_update)
                                     VALUES (v_param_value_v, x.payee_class_cd, x.payee_no, x.payee_first_name || ' ' || x.payee_middle_name || ' ' || x.payee_last_name,
                                            'This is System Generated from GIIS_PAYEES', p_rec.user_id, SYSDATE);
                            END LOOP;
                        ELSE
                            SELECT MAX(TO_NUMBER(sl_type_cd))
                              INTO v_sl_type_max
                              FROM giac_sl_types;    
                              
                            INSERT INTO giac_sl_types
                                        (sl_type_cd, sl_type_name, user_id, last_update, remarks, sl_tag, os_flag)
                                 VALUES (v_sl_type_max + 1, p_rec.class_desc, p_rec.user_id, SYSDATE, v_remarks_sysgen, v_sl_tag, v_os_flag);
                            v_sl_type_cd := v_sl_type_max+1;  
                            FOR x IN(SELECT payee_class_cd, payee_last_name, payee_first_name, payee_middle_name, payee_no 		                
                                       FROM giis_payees WHERE payee_class_cd =  p_rec.payee_class_cd)
                            LOOP
                                INSERT INTO giac_sl_lists
                                            (fund_cd, sl_type_cd, sl_cd, sl_name, remarks, user_id, last_update)
                                     VALUES (v_param_value_v, v_sl_type_max + 1, x.payee_no, x.payee_first_name || ' ' || x.payee_middle_name || ' ' || x.payee_last_name,
                                            'This is System Generated from GIIS_PAYEES', p_rec.user_id, SYSDATE);
                            END LOOP;
                        END IF;
                    ELSIF p_rec.payee_class_cd <> p_rec.sl_type_cd 
                    THEN
                        UPDATE giac_sl_types
                           SET sl_type_name = p_rec.class_desc,
                               user_id      = p_rec.user_id,
                               last_update  = SYSDATE,
                               remarks      = v_remarks_sysgen
                         WHERE sl_type_cd   = p_rec.sl_type_cd;
                        v_sl_type_cd := p_rec.sl_type_cd;                          
                    ELSE
                        UPDATE giac_sl_types
                           SET sl_type_name = p_rec.class_desc,
                               user_id      = p_rec.user_id,
                               last_update  = SYSDATE,
                               remarks      = v_remarks_sysgen
                         WHERE sl_type_cd   = p_rec.payee_class_cd;
                         v_sl_type_cd := p_rec.sl_type_cd; 
                    END IF;                
                END IF;
            ELSE
                v_sl_type_cd := p_rec.sl_type_cd;                 
            END IF;   
                
            UPDATE giis_payee_class
               SET eval_sw               = p_rec.eval_sw, 
                   loa_sw                = p_rec.loa_sw, 
                   class_desc            = p_rec.class_desc, 
                   payee_class_tag       = p_rec.payee_class_tag,
                   master_payee_class_cd = p_rec.master_payee_class_cd, 
                   sl_type_tag           = p_rec.sl_type_tag, 
                   sl_type_cd            = v_sl_type_cd,
                   clm_vat_cd            = p_rec.clm_vat_cd, 
                   remarks               = p_rec.remarks, 
                   user_id               = p_rec.user_id, 
                   last_update           = SYSDATE
             WHERE payee_class_cd = p_rec.payee_class_cd;                                
        END IF;
   END;

   PROCEDURE del_rec (p_payee_class_cd giis_payee_class.payee_class_cd%TYPE)
   AS
   BEGIN
      DELETE FROM giis_payee_class
            WHERE payee_class_cd = p_payee_class_cd;
   END;

   PROCEDURE val_del_rec (p_payee_class_cd giis_payee_class.payee_class_cd%TYPE)
   AS
      v_exists_sl         VARCHAR2 (1);
      v_exists_payees     VARCHAR2 (1);
      v_exists_claim_loss VARCHAR2 (1);
      v_exists_claimant   VARCHAR2 (1);
   BEGIN
      BEGIN 
          SELECT '1'
            INTO v_exists_payees
            FROM DUAL
           WHERE EXISTS (SELECT '1'
                           FROM giis_payees
                          WHERE UPPER (payee_class_cd) = p_payee_class_cd);
      EXCEPTION WHEN NO_DATA_FOUND 
        THEN
            v_exists_payees := '0';
      END;
      IF v_exists_payees = '1'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Cannot delete record from GIIS_PAYEE_CLASS while dependent record(s) in GIIS_PAYEES exists.'
                                 );
      ELSE
          BEGIN
              SELECT '1'
                INTO v_exists_sl
                FROM DUAL
               WHERE EXISTS (SELECT '1'
                               FROM giac_sl_lists gsl
                              WHERE gsl.sl_type_cd = p_payee_class_cd) ; 
          EXCEPTION WHEN NO_DATA_FOUND 
            THEN
                v_exists_sl := '0';
          END;
          IF v_exists_sl = '1'
            THEN
                raise_application_error (-20001,
                                         'Geniisys Exception#E#Cannot delete record from GIIS_PAYEE_CLASS while dependent record(s) in GIAC_SL_LISTS exists.'
                                        );
          ELSE
              BEGIN
                  SELECT '1'
                    INTO v_exists_claim_loss
                    FROM DUAL
                   WHERE EXISTS (SELECT '1'
                                   FROM gicl_clm_loss gcl
                                  WHERE gcl.payee_class_cd = p_payee_class_cd) ; 
              EXCEPTION WHEN NO_DATA_FOUND 
                THEN
                    v_exists_claim_loss := '0';
              END;
              IF v_exists_claim_loss = '1'
                THEN
                    raise_application_error (-20001,
                                             'Geniisys Exception#E#Cannot delete record from GIIS_PAYEE_CLASS while dependent record(s) in GICL_CLM_LOSS exists.'
                                            ); 
              ELSE
                  BEGIN
                      SELECT '1'
                        INTO v_exists_claimant
                        FROM DUAL
                       WHERE EXISTS (SELECT '1'
                                       FROM gicl_clm_claimant gcc
                                      WHERE gcc.payee_class_cd = p_payee_class_cd) ; 
                  EXCEPTION WHEN NO_DATA_FOUND 
                    THEN
                        v_exists_claimant := '0';
                  END;
                  IF v_exists_claimant = '1'
                    THEN
                        raise_application_error (-20001,
                                                 'Geniisys Exception#E#Cannot delete record from GIIS_PAYEE_CLASS while dependent record(s) in GICL_CLM_CLAIMANT exists.'
                                                );         
                  END IF;                        
              END IF;                                               
          END IF;                                                                 
      END IF;
   END;
   
   PROCEDURE val_add_rec (p_payee_class_cd giis_payee_class.payee_class_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_payee_class a
                 WHERE a.payee_class_cd = p_payee_class_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same payee_class_cd.'
                                 );
      END IF;
   END;
END;
/


