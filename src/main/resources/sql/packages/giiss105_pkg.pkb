CREATE OR REPLACE PACKAGE BODY CPI.GIISS105_PKG
    AS
/*
**  Created by   :  Maria Gzelle Ison
**  Date Created :  November 06, 2012
**  Reference By : (GIISS105 - Maintenance - Mortgagee)
**  Description  : retrieves the source listing from giis_issource.
*/
   FUNCTION get_mortgagee_source_list(
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN mortgagee_source_list_tab PIPELINED
   IS
      v_mortg   mortgagee_source_list_type;
   BEGIN
      FOR i IN (SELECT iss_cd, iss_name
                  FROM giis_issource
                 WHERE CHECK_USER_PER_ISS_CD2(null, iss_cd, 'GIISS105', p_user_id) = 1)
      LOOP
         v_mortg.iss_cd     := i.iss_cd;
         v_mortg.iss_name   := i.iss_name;
         PIPE ROW (v_mortg);
      END LOOP;
   END get_mortgagee_source_list;

/*
**  Created by   :  Maria Gzelle Ison
**  Date Created :  November 06, 2012
**  Reference By : (GIISS105 - Maintenance - Mortgagee)
**  Description  : retrieves mortgagee listing by iss_cd.
*/
   FUNCTION get_mortgagee_list_by_iss_cd (p_iss_cd GIIS_MORTGAGEE.iss_cd%TYPE)
      RETURN mortgagee_maintenance_tab PIPELINED
   IS
      v_mortgagee   mortgagee_maintenance_type;
   BEGIN
      FOR i IN (SELECT   iss_cd, mortg_cd, mortg_name, mail_addr1,
                         mail_addr2, mail_addr3, designation, tin,
                         contact_pers, remarks, user_id,
                         TO_CHAR (last_update, 'MM-DD-YYYY HH:MI:SS AM') last_update
                    FROM GIIS_MORTGAGEE
                   WHERE iss_cd = p_iss_cd
                ORDER BY UPPER (mortg_cd))
      LOOP
         v_mortgagee.iss_cd         := i.iss_cd;
         v_mortgagee.mortg_cd       := i.mortg_cd;
         v_mortgagee.mortg_name     := i.mortg_name;
         v_mortgagee.mail_addr1     := i.mail_addr1;
         v_mortgagee.mail_addr2     := i.mail_addr2;
         v_mortgagee.mail_addr3     := i.mail_addr3;
         v_mortgagee.designation    := i.designation;
         v_mortgagee.tin            := i.tin;
         v_mortgagee.contact_pers   := i.contact_pers;
         v_mortgagee.remarks        := i.remarks;
         v_mortgagee.user_id        := i.user_id;
         v_mortgagee.last_update    := i.last_update;
         PIPE ROW (v_mortgagee);
      END LOOP;
   END get_mortgagee_list_by_iss_cd;

/*
**  Created by   :  Maria Gzelle Ison
**  Date Created :  November 07, 2012
**  Reference By : (GIISS105 - Maintenance - Mortgagee)
**  Description  : checks if mortgagee is used by gipi_wmortgagee
*/
   FUNCTION validate_delete_mortgagee (
      p_iss_cd     GIIS_MORTGAGEE.iss_cd%TYPE,
      p_mortg_cd   GIIS_MORTGAGEE.mortg_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      v_mortgagee   VARCHAR2 (30);
   BEGIN
      SELECT (SELECT DISTINCT (UPPER ('gipi_wmortgagee'))
                         FROM GIPI_WMORTGAGEE
                        WHERE LOWER (GIPI_WMORTGAGEE.iss_cd) LIKE LOWER (p_iss_cd)
                          AND LOWER (GIPI_WMORTGAGEE.mortg_cd) LIKE LOWER (p_mortg_cd))
        INTO v_mortgagee
        FROM DUAL;

      IF v_mortgagee IS NOT NULL
      THEN
         RETURN v_mortgagee;
      END IF;
      
      SELECT (SELECT DISTINCT (UPPER ('gipi_mortgagee'))
                         FROM GIPI_MORTGAGEE
                        WHERE LOWER (GIPI_MORTGAGEE.iss_cd) LIKE LOWER (p_iss_cd)
                          AND LOWER (GIPI_MORTGAGEE.mortg_cd) LIKE LOWER (p_mortg_cd))
        INTO v_mortgagee
        FROM DUAL;

      IF v_mortgagee IS NOT NULL
      THEN
           RETURN v_mortgagee;
      END IF;

      RETURN '0';
   END validate_delete_mortgagee;

/*
**  Created by   :  Maria Gzelle Ison
**  Date Created :  November 07, 2012
**  Reference By : (GIISS105 - Maintenance - Mortgagee)
**  Description  : checks that the given mortgagee code does not
**                 have a duplicate record
*/
   FUNCTION validate_add_mortgagee_cd (
      p_iss_cd      GIIS_MORTGAGEE.iss_cd%TYPE,
      p_mortg_cd    GIIS_MORTGAGEE.mortg_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      v_mortg_cd   VARCHAR2(2);
   
   BEGIN
      SELECT (SELECT DISTINCT('1')
                FROM GIIS_MORTGAGEE
               WHERE LOWER(mortg_cd) LIKE LOWER(p_mortg_cd)
               AND LOWER(iss_cd) LIKE LOWER(p_iss_cd))
        INTO v_mortg_cd
        FROM DUAL;

      IF v_mortg_cd IS NOT NULL
      THEN
        RETURN v_mortg_cd;
      END IF;
      
      RETURN '0';           
   END validate_add_mortgagee_cd;

/*
**  Created by   :  Maria Gzelle Ison
**  Date Created :  November 07, 2012
**  Reference By : (GIISS105 - Maintenance - Mortgagee)
**  Description  : checks that the given mortgagee name does not
**                 have a duplicate record
*/
   FUNCTION validate_add_mortgagee_name (
      p_iss_cd        GIIS_MORTGAGEE.iss_cd%TYPE,
      p_mortg_name    GIIS_MORTGAGEE.mortg_name%TYPE
   )
      RETURN VARCHAR2
   IS
      v_mortg_name   VARCHAR2(2);
   
   BEGIN
      SELECT (SELECT DISTINCT('1')
                FROM GIIS_MORTGAGEE
               WHERE LOWER(mortg_name) LIKE LOWER(p_mortg_name)
               AND LOWER(iss_cd) LIKE LOWER(p_iss_cd))
        INTO v_mortg_name
        FROM DUAL;

      IF v_mortg_name IS NOT NULL
      THEN
        RETURN v_mortg_name;
      END IF;
      
      RETURN '0';           
   END validate_add_mortgagee_name;     

/*
**  Created by   :  Maria Gzelle Ison
**  Date Created :  November 07, 2012
**  Reference By : (GIISS105 - Maintenance - Mortgagee)
**  Description  : delete validated mortgagee
*/
   PROCEDURE delete_giis_mortgagee ( 
      p_iss_cd       GIIS_MORTGAGEE.iss_cd%TYPE,
      p_mortg_cd	 GIIS_MORTGAGEE.mortg_cd%TYPE   
   )
   IS
   BEGIN
      DELETE FROM GIIS_MORTGAGEE 
            WHERE LOWER(iss_cd) LIKE LOWER(p_iss_cd) 
              AND LOWER(mortg_cd) LIKE LOWER(p_mortg_cd);
           
               
   END delete_giis_mortgagee;

/*
**  Created by   :  Maria Gzelle Ison
**  Date Created :  November 07, 2012
**  Reference By : (GIISS105 - Maintenance - Mortgagee)
**  Description  : insert/update giis_mortgagee
*/
   PROCEDURE set_giis_mortgagee ( 
      p_mortgagee    GIIS_MORTGAGEE%ROWTYPE
   )
   IS
      v_mortg        VARCHAR2(2);
   BEGIN
      SELECT (SELECT '1' 
			    FROM GIIS_MORTGAGEE
			   WHERE iss_cd = p_mortgagee.iss_cd
			     AND mortg_cd = p_mortgagee.mortg_cd)
      INTO v_mortg
      FROM DUAL;
	
      IF v_mortg = '1'
        THEN
	        UPDATE GIIS_MORTGAGEE
	            SET mortg_name   = p_mortgagee.mortg_name,
        	        mail_addr1   = p_mortgagee.mail_addr1,
	                mail_addr2   = p_mortgagee.mail_addr2,
		            mail_addr3   = p_mortgagee.mail_addr3,
     		        designation  = p_mortgagee.designation,
	                tin          = p_mortgagee.tin,
	       	        contact_pers = p_mortgagee.contact_pers,
       	            remarks      = p_mortgagee.remarks,
                    user_id      = p_mortgagee.user_id
              WHERE iss_cd       = p_mortgagee.iss_cd
                AND mortg_cd     = p_mortgagee.mortg_cd;
      ELSE
        INSERT INTO GIIS_MORTGAGEE
                    (iss_cd, mortg_cd, mortg_name,
                    mail_addr1, mail_addr2, mail_addr3,
               	    designation, tin, contact_pers,
               	    remarks,user_id)
       	     VALUES (p_mortgagee.iss_cd, p_mortgagee.mortg_cd, p_mortgagee.mortg_name,
                	 p_mortgagee.mail_addr1, p_mortgagee.mail_addr2, p_mortgagee.mail_addr3,
                     p_mortgagee.designation, p_mortgagee.tin, p_mortgagee.contact_pers,
                     p_mortgagee.remarks,p_mortgagee.user_id);
	  END IF;
      
   END set_giis_mortgagee;
    
END GIISS105_PKG;
/


