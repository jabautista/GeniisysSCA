CREATE OR REPLACE PACKAGE BODY CPI.GIISS203_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   11.07.2013
     ** Referenced By:  GIISS203 - Intermediary Listing Maintenance
     **/
     
   FUNCTION get_rec_list (
      p_intm_no           GIIS_INTERMEDIARY.INTM_NO%type,
      p_intm_name         GIIS_INTERMEDIARY.INTM_NAME%type,
      --p_ref_intm_cd       GIIS_INTERMEDIARY.REF_INTM_CD%type,
      p_active_tag        GIIS_INTERMEDIARY.ACTIVE_TAG%type,
      p_intm_type         GIIS_INTERMEDIARY.INTM_TYPE%type
   ) RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM GIIS_INTERMEDIARY a
                 WHERE a.INTM_NO = NVL(p_intm_no, a.INTM_NO)
                   AND UPPER (a.intm_name) LIKE UPPER (NVL (p_intm_name, '%'))
                   --AND UPPER (a.ref_intm_cd) LIKE UPPER (NVL (p_ref_intm_cd, '%'))
                   AND UPPER (DECODE(a.active_tag, 'I', 'N', 'Y')) LIKE UPPER (NVL(p_active_tag, '%'))
                   AND UPPER (a.intm_type) LIKE UPPER (NVL (p_intm_type, '%'))
                 ORDER BY intm_no, intm_name)                   
      LOOP
         v_rec.intm_no          := LPAD(i.intm_no, 12, '0');
         v_rec.intm_name        := i.intm_name;
         v_rec.ref_intm_cd      := i.ref_intm_cd;
         v_rec.active_tag       := i.active_tag;
         v_rec.parent_intm_no   := i.parent_intm_no;
         v_rec.parent_intm_name := NULL;
         v_rec.intm_type        := i.intm_type;
         v_rec.intm_type_desc   := NULL;
         
         FOR k IN (SELECT INTM_NAME 
                     FROM GIIS_INTERMEDIARY
                    WHERE INTM_NO = i.PARENT_INTM_NO) LOOP
        	     
             v_rec.PARENT_INTM_NAME := k.INTM_NAME;
             EXIT;
        END LOOP;
        
        FOR J IN (SELECT INTM_DESC 
                    FROM GIIS_INTM_TYPE
                   WHERE INTM_TYPE = i.INTM_TYPE) LOOP
             v_rec.INTM_TYPE_DESC := J.INTM_DESC;
             EXIT;
        END LOOP; 
         
         v_rec.remarks          := i.remarks;
         v_rec.user_id          := i.user_id;
         v_rec.last_update      := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec GIIS_INTERMEDIARY%ROWTYPE)
   IS
   BEGIN
      MERGE INTO GIIS_INTERMEDIARY
         USING DUAL
         ON (intm_no = p_rec.intm_no)
         /*WHEN NOT MATCHED THEN
            INSERT (takeup_term, takeup_term_desc, no_of_takeup, yearly_tag, remarks, user_id, last_update)
            VALUES (p_rec.takeup_term, p_rec.takeup_term_desc, p_rec.no_of_takeup, p_rec.yearly_tag, p_rec.remarks, p_rec.user_id, SYSDATE)*/
         WHEN MATCHED THEN
            UPDATE
               SET intm_name = p_rec.intm_name,
                   ref_intm_cd = p_rec.ref_intm_cd,
                   active_tag = p_rec.active_tag, 
                   remarks = p_rec.remarks, 
				   user_id = p_rec.user_id, 
				   last_update = SYSDATE
            ;
            NULL;
   END;

   /*PROCEDURE del_rec (p_intm_no GIIS_INTERMEDIARY.INTM_NO%type)
   AS
   BEGIN
      DELETE FROM GIIS_INTERMEDIARY
            WHERE intm_no = p_intm_no;
   END;*/

   PROCEDURE val_del_rec (
        p_intm_no   IN  GIIS_INTERMEDIARY.INTM_NO%type,
        p_msg       OUT VARCHAR2,
        p_ctrl_sw1  OUT NUMBER
   )
   AS
      CURSOR W IS
        SELECT '1'
            FROM GIPI_WCOMM_INVOICES
             WHERE INTRMDRY_INTM_NO = P_INTM_NO;
         		 
      CURSOR C IS
        SELECT '1'
            FROM GIPI_COMM_INVOICE
             WHERE INTRMDRY_INTM_NO = P_INTM_NO;  

      CURSOR S IS
        SELECT '1'
          FROM GIIS_SPL_OVERRIDE_RT
         WHERE INTM_NO = P_INTM_NO;
             
      V_WEXIST 	    BOOLEAN := FALSE;
      V_EXIST		BOOLEAN := FALSE;
      V_SPL_EXIST   BOOLEAN := FALSE;
   BEGIN
        FOR A IN W LOOP
            V_WEXIST := TRUE;
            EXIT;
	    END LOOP;
	
        FOR B IN C LOOP
		    V_EXIST := TRUE;
		    EXIT;
        END LOOP;
      
        FOR K IN S LOOP
            V_SPL_EXIST := TRUE;
            EXIT;
        END LOOP;
        
        /*IF V_WEXIST = TRUE AND V_EXIST = TRUE THEN
            p_msg := 'Cannot delete this record.  Intermediary is being used in another transaction.';
        ELS*/IF V_WEXIST = TRUE /*AND V_EXIST = FALSE */THEN
            --p_msg := 'Cannot delete this record.  Intermediary is being used in another transaction.';
            p_msg := 'Cannot delete record from GIIS_INTERMEDIARY while dependent record(s) in GIPI_WCOMM_INVOICES exists.';
        ELSIF /*V_WEXIST = FALSE AND*/  V_EXIST = TRUE THEN
            --p_msg := 'Cannot delete this record.  Intermediary is being used in another transaction.';
            p_msg := 'Cannot delete record from GIIS_INTERMEDIARY while dependent record(s) in GIPI_COMM_INVOICE exists.';
        ELSIF V_SPL_EXIST THEN
  	        --MSG_ALERT('Cannot delete this record.  Intermediary is being used in another transaction.','I', TRUE);   
            --p_msg := 'Cannot delete this record.  Intermediary is being used in another transaction.';
            p_msg := 'Cannot delete record from GIIS_INTERMEDIARY while dependent record(s) in GIIS_SPL_OVERRIDE_RT exists';   	
        ELSIF V_WEXIST = FALSE AND V_EXIST = FALSE THEN
            --MSG_ALERT('Deletions can only be done on the Intermediaries Maintenance Module.','I',FALSE);
            p_msg := 'Deletions can only be done on the Intermediaries Maintenance Module.';
            p_ctrl_sw1 := 1;
 	        --form076;
        END IF;
   END;

   /*PROCEDURE val_add_rec(p_intm_no   IN  GIIS_INTERMEDIARY.INTM_NO%type)
   AS
        v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM GIIS_INTERMEDIARY a
                 WHERE a.intm_no = p_intm_no)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same Intm No.'
                                 );
      END IF;
   END val_add_rec;*/
   
END GIISS203_PKG;
/


