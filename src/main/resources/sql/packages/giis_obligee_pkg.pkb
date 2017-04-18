CREATE OR REPLACE PACKAGE BODY CPI.GIIS_OBLIGEE_PKG AS

  /*
  ** Modified by    : Marie Kris Felipe
  ** Date modified  : September 25, 2012
  ** Description    : Added other details of the obligee
  */
  FUNCTION get_obligee_list(
    p_obligee_no        GIIS_OBLIGEE.OBLIGEE_NO%TYPE,
    p_obligee_name      GIIS_OBLIGEE.OBLIGEE_NAME%TYPE,
    p_address           VARCHAR2,
    p_contact_person    giis_obligee.CONTACT_PERSON%TYPE,-- mkfelipe_20120925: inserted additional details of obligee to display
    p_designation       giis_obligee.DESIGNATION%TYPE,
    p_phone_no          giis_obligee.PHONE_NO%TYPE,
    p_remarks           giis_obligee.REMARKS%TYPE
  )
    RETURN giis_obligee_tab PIPELINED
	IS
	v_obligee				giis_obligee_type;
  BEGIN
    FOR i IN (SELECT obligee_name
      	  	 	   , TRIM(address1||' '||address2||' '||address3) address
                   , address1
                   , address2
                   , address3 
                   , obligee_no
                   , phone_no
                   , contact_person
                   , designation
                   , remarks
                   , cpi_rec_no
                   , cpi_branch_cd
                   , user_id
                   , last_update
				FROM giis_obligee 
               WHERE obligee_no = NVL(p_obligee_no, obligee_no)
               
                 AND UPPER(obligee_name) LIKE UPPER(NVL('%'||p_obligee_name||'%', obligee_name))
                 
                 AND UPPER(NVL(address1||' '||address2||' '||address3, ' ')) LIKE 
                        UPPER(NVL('%'||p_address||'%', 
                            DECODE(address1||' '||address2||' '||address3,
                                    NULL, ' ',
                                    address1||' '||address2||' '||address3))) 
                                    
                 AND UPPER(NVL(contact_person, ' ')) LIKE 
                        UPPER(NVL('%'||p_contact_person||'%',
                            DECODE(contact_person,
                                    NULL, ' ',
                                    contact_person))) 
                                    
                 AND UPPER(NVL(designation, ' ')) LIKE 
                        UPPER(NVL('%'||p_designation||'%',
                            DECODE(designation,
                                    NULL, ' ',
                                    designation))) 
                                    
                 AND UPPER(NVL(phone_no, ' ')) LIKE
                        UPPER(NVL('%'||p_phone_no||'%',
                            DECODE(phone_no,
                                    NULL, ' ',
                                    phone_no)))                   
                                    
                 AND UPPER(NVL(remarks, ' ')) LIKE 
                        UPPER(NVL('%'||p_remarks||'%', 
                            DECODE(remarks,
                                    NULL, ' ',
                                    remarks)))
            
			   ORDER BY obligee_name)
	LOOP
	  v_obligee.obligee_name		 := i.obligee_name;
	  v_obligee.address				 := i.address;
	  v_obligee.obligee_no			 := i.obligee_no;
      v_obligee.contact_person       := i.contact_person;
      v_obligee.designation          := i.designation;
      v_obligee.phone_no             := i.phone_no;
      v_obligee.remarks              := i.remarks;
      v_obligee.cpi_rec_no           := i.cpi_rec_no;
      v_obligee.cpi_branch_cd        := i.cpi_branch_cd;
      v_obligee.address1             := i.address1; -- marco - 05.02.2013
      v_obligee.address2             := i.address2; --
      v_obligee.address3             := i.address3; --
      v_obligee.user_id              := i.user_id;
      v_obligee.last_update_str      := TO_CHAR(i.last_update, 'mm-dd-yyyy hh12:mi:ss AM');
	  PIPE ROW(v_obligee);
	END LOOP;
	RETURN;
  END get_obligee_list;
  
  FUNCTION get_obligee_name(p_obligee_no			 GIIS_OBLIGEE.obligee_no%TYPE)
    RETURN VARCHAR2 IS
	v_obligee_name	 giis_obligee.obligee_name%TYPE;--VARCHAR2(50); modified by Gzelle 01212015
  BEGIN
	FOR i IN (SELECT obligee_name
	        	FROM giis_obligee
	           WHERE obligee_no = p_obligee_no)
	LOOP
	  v_obligee_name := i.obligee_name;
	END LOOP;
	RETURN v_obligee_name;
  END get_obligee_name;
  

  FUNCTION get_obligee_list2 (p_keyword giis_obligee.obligee_name%TYPE)
     RETURN giis_obligee_tab2 PIPELINED
  IS
     v_obligee2   giis_obligee_type2;
  BEGIN
     FOR i IN
        (SELECT DISTINCT obligee_no
                    FROM gipi_bond_basic
                   WHERE obligee_no IN (
                            SELECT obligee_no
                              FROM giis_obligee
                             WHERE (obligee_name LIKE UPPER
                                       (NVL ('%' || p_keyword || '%',
                                            obligee_name
                                           ))
                                   )))
     LOOP
     
        v_obligee2.obligee_no := i.obligee_no;
        
         SELECT obligee_name, address1||' '||address2||' '||address3, contact_person, designation, phone_no, remarks, cpi_rec_no, cpi_branch_cd
          INTO v_obligee2.obligee_name, 
               v_obligee2.address,
               v_obligee2.contact_person, -- mkfelipe_20120925: inserted additional details of obligee to display
               v_obligee2.designation,
               v_obligee2.phone_no,
               v_obligee2.remarks,
               v_obligee2.cpi_rec_no,
               v_obligee2.cpi_branch_cd 
          FROM giis_obligee
         WHERE obligee_no = i.obligee_no;
         
         PIPE ROW (v_obligee2);
         
     END LOOP;
     RETURN;
     
  END get_obligee_list2;                    --moses04282011

    /*
   **  Created by   :  Marie Kris Felipe
   **  Date Created :  September 26, 2012
   **  Description  :  Retrieves Obligee details based from given Obligee No.
   */
  FUNCTION get_obligee_details(p_obligee_no giis_obligee.obligee_no%TYPE)
    RETURN giis_obligee_type2
  IS
    v_obligee   giis_obligee_type2;
  BEGIN
    FOR obl IN (SELECT obligee_no, obligee_name, 
                       address1||' '||address2||' '||address3 address, 
                       contact_person, designation, phone_no, remarks, 
                       cpi_rec_no, cpi_branch_cd
                  FROM giis_obligee
                 WHERE obligee_no = p_obligee_no)
    LOOP
        v_obligee.obligee_no        := obl.obligee_no;
        v_obligee.obligee_name      := obl.obligee_name;
        v_obligee.address           := obl.address;
        v_obligee.contact_person    := obl.contact_person;
        v_obligee.designation       := obl.designation;
        v_obligee.phone_no          := obl.phone_no;
        v_obligee.remarks           := obl.remarks;
        v_obligee.cpi_rec_no        := obl.cpi_rec_no;
        v_obligee.cpi_branch_cd     := obl.cpi_branch_cd;
       
    END LOOP;
    RETURN v_obligee;
    
  END get_obligee_details;
  
  /*
   **  Created by    :  Marie Kris Felipe
   **  Date Created  :  October 01, 2012
   **  Reference     : GIISS017 - Obligee Maintenance
   **  Description  :  Inserts/Updates obligee details
   */
  PROCEDURE set_giis_obligee (
    p_obligee_no        IN  giis_obligee.obligee_no%TYPE,
    p_obligee_name      IN  giis_obligee.obligee_name%TYPE,
    p_address           IN  VARCHAR2,
    p_contact_person    IN  giis_obligee.contact_person%TYPE,
    p_designation       IN  giis_obligee.designation%TYPE,
    p_phone_no          IN  giis_obligee.phone_no%TYPE,
    p_remarks           IN  giis_obligee.remarks%TYPE,
    p_address1          IN  giis_obligee.address1%TYPE, --marco - 05.02.2013 -added address params
    p_address2          IN  giis_obligee.address2%TYPE,
    p_address3          IN  giis_obligee.address3%TYPE
  )
  IS
    v_next_obligee_no   giis_obligee.obligee_no%TYPE;
    v_obligee_no        giis_obligee.obligee_no%TYPE;
  BEGIN
  
    -- 1. get the nextvalue of obligee_no sequence
    IF (p_obligee_no IS NULL) THEN
        SELECT OBLIGEE_OBLIGEE_NO_S.NEXTVAL 
          INTO v_next_obligee_no
          FROM SYS.DUAL;
          
        v_obligee_no := v_next_obligee_no;
    ELSE
        v_obligee_no := p_obligee_no;
    END IF;
    
    -- 2. merge 
    MERGE INTO GIIS_OBLIGEE
    USING DUAL ON (obligee_no = v_obligee_no)
     WHEN NOT MATCHED THEN
          INSERT (obligee_no,   obligee_name,   address1, address2, address3,  contact_person,   designation,   phone_no,   remarks)
          VALUES (v_obligee_no, p_obligee_name, p_address1, p_address2, p_address3, p_contact_person, p_designation, p_phone_no, p_remarks)
     WHEN MATCHED THEN
          UPDATE SET obligee_name   = p_obligee_name,
                     --address1       = p_address,
                     contact_person = p_contact_person,
                     designation    = p_designation,
                     phone_no       = p_phone_no,
                     remarks        = p_remarks,
                     address1       = p_address1,
                     address2       = p_address2,
                     address3       = p_address3; --marco - 05.02.2013 - added address params
    --COMMIT;
  END set_giis_obligee;
  
   /*
   ** Modified by:  : Marie Kris Felipe
   ** Date modified : October 01, 2012
   ** Reference     : GIISS017 - Obligee Maintenance
   ** Description   : Validates the obligee_no to be deleted. 
   **                 If obligee_no exists in GIPI_BOND_BASIC or in GIPI_WBOND_BASIC, it returns the name of the dependent table.
   **                 Otherwise, it returns NONE and obligee_no can be deleted.
   **                 Based on the KEY_DELREC Trigger of GIISS017
   */
  FUNCTION val_obligee_no_on_delete (p_obligee_no   giis_obligee.obligee_no%TYPE)
    RETURN VARCHAR2
  IS
    v_exists    NUMBER;
    v_dependent VARCHAR2(50);
  BEGIN
    
    BEGIN
        SELECT DISTINCT 1
          INTO v_exists
          FROM gipi_bond_basic
         WHERE obligee_no = p_obligee_no;
         v_dependent := 'GIPI_BOND_BASIC';
         
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
       BEGIN
        SELECT DISTINCT 1
          INTO v_exists
          FROM gipi_wbond_basic
         WHERE obligee_no = p_obligee_no;
         v_dependent := 'GIPI_WBOND_BASIC';
         
       EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            v_dependent := 'NONE';
           -- delete_record(p_obligee_no);
       END; -- end of innermost BEGIN
    END; --end of inner BEGIN
    
    RETURN v_dependent;
    
  END val_obligee_no_on_delete;
  
  /*
  ** Created by     : Marie Kris Felipe
  ** Date Created   : October 1, 2012
  ** Description    : Deletes the obligee based on the given obligee_no
  **
  */
  PROCEDURE del_obligee (
    p_obligee_no        IN  giis_obligee.obligee_no%TYPE
  )
  IS
  BEGIN
    DELETE FROM giis_obligee
     WHERE obligee_no = p_obligee_no;
     
    --COMMIT;
  END del_obligee;
  
  
  FUNCTION get_obligee_list3(
    p_obligee_no        GIIS_OBLIGEE.OBLIGEE_NO%TYPE,
    p_obligee_name      GIIS_OBLIGEE.OBLIGEE_NAME%TYPE,
    p_address           VARCHAR2,
    p_contact_person    giis_obligee.CONTACT_PERSON%TYPE,
    p_designation       giis_obligee.DESIGNATION%TYPE,
    p_phone_no          giis_obligee.PHONE_NO%TYPE,
    p_remarks           giis_obligee.REMARKS%TYPE,
    p_user_id           giis_obligee.user_id%TYPE
  )
    RETURN giis_obligee_tab PIPELINED
	IS
	v_obligee				giis_obligee_type;
  BEGIN
    FOR i IN (SELECT a.obligee_name
      	  	 	   , TRIM(a.address1||' '||a.address2||' '||a.address3) address
                   , a.address1
                   , a.address2
                   , a.address3 
                   , a.obligee_no
                   , a.phone_no
                   , a.contact_person
                   , a.designation
                   , a.remarks
                   , a.cpi_rec_no
                   , a.cpi_branch_cd
                   , a.user_id
                   , a.last_update
				FROM giis_obligee a
               WHERE a.obligee_no = NVL(p_obligee_no, a.obligee_no)
                 AND check_useR_per_iss_cd2(null, null, 'GIISS017', p_user_id) = 1
                 AND UPPER(NVL(a.obligee_name, '%')) LIKE UPPER(NVL(p_obligee_name, '%'))
                 AND UPPER(NVL(a.contact_person, '%')) LIKE UPPER(NVL(p_contact_person, '%'))
                 AND UPPER(NVL(a.designation, '%')) LIKE UPPER(NVL(p_designation, '%'))
                 AND UPPER(NVL(a.phone_no, '%')) LIKE UPPER(NVL(p_phone_no, '%'))
                 AND UPPER(NVL(a.remarks, '%')) LIKE UPPER(NVL(p_remarks, '%'))
                AND ( UPPER(NVL(a.address1, '%')) LIKE UPPER(NVL(p_address, '%')) OR
                      UPPER(NVL(a.address2, '%')) LIKE UPPER(NVL(p_address, '%')) OR
                      UPPER(NVL(a.address3, '%')) LIKE UPPER(NVL(p_address, '%'))                        )
                 
                 /*AND UPPER(obligee_name) LIKE UPPER(NVL('%'||p_obligee_name||'%', obligee_name))
                 
                 AND UPPER(NVL(address1||' '||address2||' '||address3, ' ')) LIKE 
                        UPPER(NVL('%'||p_address||'%', 
                            DECODE(address1||' '||address2||' '||address3,
                                    NULL, ' ',
                                    address1||' '||address2||' '||address3))) 
                                    
                 AND UPPER(NVL(contact_person, ' ')) LIKE 
                        UPPER(NVL('%'||p_contact_person||'%',
                            DECODE(contact_person,
                                    NULL, ' ',
                                    contact_person))) 
                                    
                 AND UPPER(NVL(designation, ' ')) LIKE 
                        UPPER(NVL('%'||p_designation||'%',
                            DECODE(designation,
                                    NULL, ' ',
                                    designation))) 
                                    
                 AND UPPER(NVL(phone_no, ' ')) LIKE
                        UPPER(NVL('%'||p_phone_no||'%',
                            DECODE(phone_no,
                                    NULL, ' ',
                                    phone_no)))                   
                                    
                 AND UPPER(NVL(remarks, ' ')) LIKE 
                        UPPER(NVL('%'||p_remarks||'%', 
                            DECODE(remarks,
                                    NULL, ' ',
                                    remarks)))*/
            
			   ORDER BY a.obligee_no, a.obligee_name)
	LOOP
	  v_obligee.obligee_name		 := i.obligee_name;
	  v_obligee.address				 := i.address;
	  v_obligee.obligee_no			 := i.obligee_no;
      v_obligee.contact_person       := i.contact_person;
      v_obligee.designation          := i.designation;
      v_obligee.phone_no             := i.phone_no;
      v_obligee.remarks              := i.remarks;
      v_obligee.cpi_rec_no           := i.cpi_rec_no;
      v_obligee.cpi_branch_cd        := i.cpi_branch_cd;
      v_obligee.address1             := i.address1; -- marco - 05.02.2013
      v_obligee.address2             := i.address2; --
      v_obligee.address3             := i.address3; --
      v_obligee.user_id              := i.user_id;
      v_obligee.last_update_str      := TO_CHAR(i.last_update, 'mm-dd-yyyy hh12:mi:ss AM');
	  PIPE ROW(v_obligee);
	END LOOP;
	RETURN;
  END get_obligee_list3;
  
END GIIS_OBLIGEE_PKG;
/


