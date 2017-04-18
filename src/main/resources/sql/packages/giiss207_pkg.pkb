CREATE OR REPLACE PACKAGE BODY CPI.GIISS207_pkg
AS
   /* Modified by : J. Diago
   ** Date Modified : 05.14.2014
   ** Modifications : Added 2 kinds of user access validation.
   **                 1. Validation of users that are allowed to post policies.
   **                 2. Validation of user who is using the posting limit maintenance.
   */
   FUNCTION get_giis_users (p_user_id GIIS_USERS.user_id%TYPE,
                            p_user_id_from VARCHAR2)
      RETURN giis_user_tab PIPELINED
   IS
      v_user   giis_user_type;
   BEGIN
      FOR a IN (SELECT user_id, user_name
                  FROM GIIS_USERS 
                 WHERE active_flag = 'Y'
                   AND CHECK_USER_ACCESS2('GIPIS055', user_id) = 1 -- users allowed to post pars
                   AND CHECK_USER_ACCESS2('GIISS207', p_user_id) = 1 -- user who is setting up posting limit
                 --WHERE CHECK_USER_ACCESS2('GIISS207', user_id) = 1  --changed GIPIS055 to GIISS207 Gzelle 03.21.2014
                   --AND UPPER(user_id) LIKE UPPER(NVL(p_user_id_from,'%'))
                 ORDER BY user_id)
      LOOP
         v_user.user_id     := a.user_id;
         v_user.user_name   := a.user_name;
         PIPE ROW (v_user);
      END LOOP;

      RETURN;
   END get_giis_users;
   
   FUNCTION get_issue_sources (p_user_id GIIS_USERS.user_id%TYPE,
                               --p_iss_cd  GIIS_ISSOURCE.iss_cd%TYPE,
                               p_maintenance_user VARCHAR2)
      RETURN giis_issue_source_tab PIPELINED
   IS
      v_issue_source   giis_issue_source_type;
      p_line_cd        giis_line.line_cd%TYPE := NULL;
   BEGIN
      FOR a IN (SELECT iss_cd, iss_name
                  FROM GIIS_ISSOURCE
                 WHERE check_user_per_iss_cd2 (NULL,iss_cd,'GIPIS055',SUBSTR (p_user_id, 1, 8)) = 1 -- user allowed to post par
                   AND check_user_per_iss_cd2 (NULL,iss_cd,'GIISS207',SUBSTR (p_maintenance_user, 1, 8)) = 1 -- user who is setting up posting limit
                 --WHERE CHECK_USER_PER_ISS_CD2(p_line_cd, iss_cd, 'GIISS207', SUBSTR(p_user_id, 1, 8)) = 1   --changed GIPIS055 to GIISS207 Gzelle 03.21.2014
                   --AND UPPER(iss_cd) LIKE UPPER(NVL(p_iss_cd,'%'))
                   )
      LOOP
         v_issue_source.iss_cd   := a.iss_cd;
         v_issue_source.iss_name := a.iss_name;
         PIPE ROW (v_issue_source);
      END LOOP;

      RETURN;
   END get_issue_sources;
   
   FUNCTION get_posting_limits(p_user_id GIIS_USERS.user_id%TYPE,
                               p_iss_cd  GIIS_ISSOURCE.iss_cd%TYPE,
                               p_maintenance_user VARCHAR2
                              )
      RETURN giis_posting_limit_tab PIPELINED
   IS
      v_posting_limit   giis_posting_limit_type;
   BEGIN
      FOR i IN (SELECT a.posting_user, a.iss_cd, a.line_cd, b.line_name, 
                       a.all_amt_sw, a.post_limit, a.user_id, TO_CHAR(a.last_update, 'MM-DD-YYYY HH:MI:SS AM') last_update, 
                       a.endt_post_limit, a.endt_all_amt_sw
                  FROM giis_posting_limit a, giis_line b
                 WHERE a.line_cd      = b.line_cd
                   AND a.posting_user = p_user_id 
                   AND a.iss_cd       = p_iss_cd
                   AND check_user_per_line2 (a.line_cd, p_iss_cd, 'GIPIS055', p_user_id) = 1 -- maintained lines for the posting user.
                   AND check_user_per_line2 (a.line_cd, p_iss_cd, 'GIISS207', p_maintenance_user) = 1) -- maintained lines for the maintenance user
                   --AND CHECK_USER_PER_LINE2(a.line_cd, p_iss_cd, 'GIISS207', p_user_id) = 1)    --changed to check_user_per_line3 Gzelle 03.21.2014
      LOOP
         v_posting_limit.posting_user           := i.posting_user;
         v_posting_limit.iss_cd                 := i.iss_cd;
         v_posting_limit.line_cd                := i.line_cd;
         v_posting_limit.line_name              := i.line_name;
         v_posting_limit.all_amt_sw             := i.all_amt_sw;
         v_posting_limit.post_limit             := i.post_limit;
         v_posting_limit.user_id                := i.user_id;
         v_posting_limit.last_update            := i.last_update;
         v_posting_limit.endt_post_limit        := i.endt_post_limit;
         v_posting_limit.endt_all_amt_sw        := i.endt_all_amt_sw;
         PIPE ROW (v_posting_limit);
      END LOOP;
      
      RETURN;
   END get_posting_limits;
   
   FUNCTION get_lines(p_user_id GIIS_USERS.user_id%TYPE,
                      p_iss_cd  GIIS_ISSOURCE.iss_cd%TYPE,
                      --p_line_name GIIS_LINE.line_name%TYPE,
                      p_maintenance_user VARCHAR2)
      RETURN giis_line_tab PIPELINED
   IS
     v_line   giis_line_type;
   BEGIN
     FOR a IN (SELECT line_cd, line_name
                 FROM GIIS_LINE
                WHERE check_user_per_line2 (line_cd, p_iss_cd, 'GIPIS055', p_user_id) = 1 -- maintained lines for the posting user.
                  AND check_user_per_line2 (line_cd, p_iss_cd, 'GIISS207', p_maintenance_user) = 1 -- maintained lines for the maintenance user
                --WHERE CHECK_USER_PER_LINE(line_cd, p_iss_cd, 'GIISS207') = 1   --changed GIPIS055 to GIISS207 Gzelle 03.21.2014
                  --AND UPPER(line_name) LIKE UPPER(NVL(p_line_name, '%'))
                  AND UPPER(line_cd) NOT IN (SELECT UPPER(line_cd) 
                                        FROM giis_posting_limit 
                                       WHERE posting_user = p_user_id
                                         AND iss_cd       = p_iss_cd)
                ORDER BY line_cd)
     LOOP
        v_line.line_cd   := a.line_cd;
        v_line.line_name := a.line_name;
        PIPE ROW (v_line);
     END LOOP;
     RETURN;    
   END get_lines;
   
   PROCEDURE val_add_rec (
    p_line_cd   giis_line.line_name%TYPE,
    p_user_id   giis_users.user_id%TYPE,
    p_iss_cd    giis_issource.iss_cd%TYPE  
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_posting_limit a
                 WHERE posting_user = p_user_id
                   AND iss_cd = p_iss_cd
                   AND line_cd = p_line_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same posting_user, iss_cd and line_cd.'
                                 );
      END IF;
   END;   
   
    PROCEDURE set_posting_limits(p_post_limits giis_posting_limit%ROWTYPE)
    IS
    BEGIN
      MERGE INTO giis_posting_limit
      USING DUAL ON (posting_user = p_post_limits.posting_user AND iss_cd = p_post_limits.iss_cd AND line_cd = p_post_limits.line_cd)
      WHEN NOT MATCHED THEN
        INSERT (posting_user, iss_cd, line_cd, all_amt_sw, post_limit, endt_post_limit, endt_all_amt_sw, user_id)
        VALUES (p_post_limits.posting_user, p_post_limits.iss_cd, p_post_limits.line_cd, 
                p_post_limits.all_amt_sw, p_post_limits.post_limit, 
                p_post_limits.endt_post_limit, p_post_limits.endt_all_amt_sw, p_post_limits.user_id)
      WHEN MATCHED THEN
        UPDATE SET all_amt_sw       = p_post_limits.all_amt_sw,
                   post_limit       = p_post_limits.post_limit,
                   endt_post_limit  = p_post_limits.endt_post_limit,
                   endt_all_amt_sw  = p_post_limits.endt_all_amt_sw,
                   user_id          = p_post_limits.user_id
             WHERE posting_user     = p_post_limits.posting_user 
               AND iss_cd           = p_post_limits.iss_cd 
               AND line_cd          = p_post_limits.line_cd;
    END set_posting_limits;
   
   PROCEDURE delete_posting_limit(p_post_limits giis_posting_limit%ROWTYPE)
   IS
   BEGIN
   
     DELETE FROM giis_posting_limit
           WHERE posting_user = p_post_limits.posting_user 
             AND iss_cd       = p_post_limits.iss_cd
             AND line_cd      = p_post_limits.line_cd;
   
   END delete_posting_limit;
   
   
   FUNCTION validate_copy_user(
       p_user_id  giis_users.user_id%TYPE
   )
   RETURN VARCHAR2
   IS
      v_temp VARCHAR2(1);
       BEGIN
            SELECT(SELECT '1'
                     FROM GIIS_USERS
                    --WHERE CHECK_USER_ACCESS2 ('GIISS207', user_id) = 1  --changed GIPIS055 to GIISS207 Gzelle 03.21.2014
                    WHERE CHECK_USER_ACCESS2 ('GIPIS055', user_id) = 1 -- reverted to GIPIS055 by jdiago 05.14.2014
                      AND active_flag = 'Y'
                      AND UPPER(user_id) LIKE UPPER(NVL(p_user_id, '%')))
            INTO v_temp
            FROM DUAL;
         
         IF v_temp IS NOT NULL
         THEN
             RETURN '1';
         ELSE
             RETURN '0';
         END IF;
        
         END;


   FUNCTION validate_copy_branch(
       p_iss_cd  giis_issource.iss_cd%TYPE
   )
   RETURN VARCHAR2
   IS
      v_temp VARCHAR2(1);
       BEGIN
            SELECT(SELECT '1'
                     FROM giis_issource
                     WHERE UPPER(iss_cd) LIKE UPPER(NVL(p_iss_cd, '%')))
            INTO v_temp
            FROM DUAL;
         
         IF v_temp IS NOT NULL
         THEN
            RETURN '1';
         ELSE
            RETURN '0';
         END IF;   
         
         END;


   FUNCTION validate_line_name(
       p_line_name  giis_line.line_name%TYPE,
       p_user_id    giis_users.user_id%TYPE,
       p_iss_cd     giis_issource.iss_cd%TYPE
   )
   RETURN VARCHAR2
   IS
      v_temp_x    VARCHAR2(1);
      v_temp_y   VARCHAR2(1);
      
       BEGIN
            SELECT(SELECT 'X'
                     FROM giis_line
                    WHERE UPPER(line_name) LIKE UPPER(NVL(p_line_name, '%'))
                    --AND CHECK_USER_PER_LINE(line_cd, p_iss_cd, 'GIISS207') = 1  --changed GIPIS055 to GIISS207 Gzelle 03.21.2014
                    AND CHECK_USER_PER_LINE2(line_cd, p_iss_cd, 'GIPIS055', p_user_id) = 1 -- reverted to GIPIS055 by jdiago 05.14.2014
                  )
            INTO v_temp_x
            FROM DUAL;
            
            IF v_temp_x IS NOT NULL
            THEN
                SELECT(SELECT 'Y'
                         FROM giis_line
                        WHERE UPPER(line_name) LIKE UPPER(NVL(p_line_name, '%'))
                          --AND CHECK_USER_PER_LINE(line_cd, p_iss_cd, 'GIISS207') = 1   --changed GIPIS055 to GIISS207 Gzelle 03.21.2014
                          AND CHECK_USER_PER_LINE2(line_cd, p_iss_cd, 'GIPIS055', p_user_id) = 1 -- reverted to GIPIS055 by jdiago 05.14.2014
                          AND UPPER(line_cd) NOT IN (SELECT UPPER(line_cd) 
                                                       FROM giis_posting_limit 
                                                      WHERE posting_user = p_user_id
                                                        AND iss_cd       = p_iss_cd)
                      )
                INTO v_temp_y
                FROM DUAL;
                
                IF v_temp_y IS NOT NULL
                THEN
                    RETURN '1';
                ELSE
                    RETURN '0';
                END IF;                 
            
            ELSE
                RETURN 'X';    
            END IF;      
         
         END;
                  
  PROCEDURE set_copy_to_another_user(p_copy_to_user giis_users.user_id%TYPE,
                                      p_copy_to_branch giis_issource.iss_cd%TYPE,
                                      p_copy_from_user giis_users.user_id%TYPE,
                                      p_copy_from_branch giis_issource.iss_cd%TYPE,
                                      p_populate_all_sw VARCHAR2,
                                      p_user_id giis_users.user_id%TYPE)
    IS
        v_exists        VARCHAR2(1):='N'; 
        v_combi         VARCHAR2(30):=NULL;
    BEGIN

       IF p_populate_all_sw = 'Y' THEN
       /* Note: INSERT SA GIIS_POSTING LIMIT [1st condition]
       ** (1)kpag tagged ang populate all branches
       ** (2)Mandatory na may value ang p_copy_from_branch field
       ** (3)blank dapat ang p_copy_to_branch field
       ** meaning: ang value got from giis_posting_limit with ISS_CD = p_copy_from_branch
       **          ay populate throughout sa mga iss_cd nung p_copy_to_user        
       */
            v_combi := NULL;
            FOR a1 IN (SELECT iss_cd
                         FROM giis_issource y
                        --WHERE check_user_per_iss_cd2('', iss_cd,'GIISS207',substr(p_copy_to_user,1,8))=1
                        WHERE check_user_per_iss_cd2('', iss_cd,'GIPIS055',substr(p_copy_to_user,1,8))=1 -- reverted to GIPIS055 by jdiago 05.14.2014
                        )   --changed GIPIS055 to GIISS207 Gzelle 03.21.2014
            LOOP
                FOR a2 IN (SELECT line_cd, post_limit, user_id,
                                  last_update, all_amt_sw,
                                  endt_all_amt_sw, endt_post_limit                 
                             FROM giis_posting_limit x
                            WHERE posting_user = p_copy_from_user
                              AND iss_cd       = p_copy_from_branch
                  AND NOT EXISTS (SELECT 1
                                    FROM giis_posting_limit z
                                   WHERE posting_user = p_copy_to_user
                                     AND z.iss_cd = a1.iss_cd
                                     AND z.line_cd = x.line_cd)) 
                LOOP
                    v_exists := 'N';
                    IF v_combi IS NOT NULL THEN
                        IF v_combi = p_copy_to_user||'-'||a1.iss_cd||'-'||a2.line_cd THEN
                            v_exists := 'Y';
                        END IF;    
                    END IF;
                   
                   IF v_exists = 'N' THEN
                        INSERT INTO giis_posting_limit (posting_user,   line_cd,    post_limit,    user_id,
                                                        last_update,    iss_cd,     all_amt_sw,
                                                        endt_all_amt_sw, endt_post_limit)                        
                             VALUES (p_copy_to_user,  a2.line_cd, a2.post_limit, p_user_id, --a2.user_id, Gzelle 05.23.2013
                                     a2.last_update, a1.iss_cd,  a2.all_amt_sw,
                                     a2.endt_all_amt_sw, a2.endt_post_limit);                
                   END IF;                                  
                   
                   v_combi := p_copy_to_user||'-'||a1.iss_cd||'-'||a2.line_cd;                                
                END LOOP;    
            END LOOP;
       ELSE
            IF p_copy_from_branch IS NULL THEN
            /* Note: INSERT SA GIIS_POSTING LIMIT [2nd condition]
			** (1)kpag UNtagged ang populate all branches
			** (2)possible na walang value ang p_copy_from_branch field
			** (3)automatic, blank din ang p_copy_to_branch kung blank c p_copy_from_branch field
			** meaning: kung blank lahat, tapat-tapat lng ang pagpopulate.
			**          kung anong meron na iss_cd kay p_copy_to_user, check nia kung may makokopya kay copy_from_user,
			**          den kung meron, copy vis a vis!
			*/
                v_combi := NULL;
                FOR a1 IN (SELECT iss_cd
                             FROM giis_issource y
                            WHERE check_user_per_iss_cd2('', iss_cd,'GIPIS055',substr(p_copy_to_user,1,8))=1
                            --reverted by jdiago to GIPIS055 05.14.2014
                            )   --changed GIPIS055 to GIISS207 Gzelle 03.21.2014
                LOOP
			  	    FOR a2 IN (SELECT line_cd, post_limit, user_id,
									  last_update, all_amt_sw,
									  endt_all_amt_sw, endt_post_limit									
							     FROM giis_posting_limit x
								WHERE posting_user = p_copy_from_user
								  AND iss_cd       = a1.iss_cd
			           AND NOT EXISTS (SELECT 1
									     FROM giis_posting_limit z
									    WHERE posting_user = p_copy_to_user
										  AND x.iss_cd = z.iss_cd
										  AND x.line_cd = z.line_cd)) 
					LOOP
						v_exists := 'N';
						IF v_combi IS NOT NULL THEN
							IF v_combi = p_copy_to_user||'-'||a1.iss_cd||'-'||a2.line_cd THEN
								v_exists := 'Y';
							END IF;	
						END IF;
						
                        IF v_exists = 'N' THEN
							INSERT INTO giis_posting_limit (posting_user,   line_cd,    post_limit,    user_id,
				                                      last_update,    iss_cd,     all_amt_sw,
				                                      endt_all_amt_sw, endt_post_limit)						
				                              VALUES (p_copy_to_user,  a2.line_cd, a2.post_limit, p_user_id, --a2.user_id, Gzelle 05.23.2013
				                                      a2.last_update, a1.iss_cd,  a2.all_amt_sw,
				                                      a2.endt_all_amt_sw, a2.endt_post_limit);				
						END IF;
						v_combi := p_copy_to_user||'-'||a1.iss_cd||'-'||a2.line_cd;
					END LOOP;	
                    
			    END LOOP;
	        
            ELSE
				v_combi := NULL;
		  	    FOR a2 IN (SELECT line_cd, post_limit, user_id,
								  last_update, all_amt_sw,
								  endt_all_amt_sw, endt_post_limit					
						     FROM giis_posting_limit x
							WHERE posting_user = p_copy_from_user
							  AND iss_cd       = p_copy_from_branch
		           AND NOT EXISTS (SELECT 1
									 FROM giis_posting_limit z
								    WHERE posting_user = p_copy_to_user
									  AND z.iss_cd = NVL(p_copy_to_branch,p_copy_from_branch)
									  AND z.line_cd = x.line_cd)) 
				LOOP		  	
					IF check_user_per_iss_cd2(a2.line_cd, NVL(p_copy_to_branch,p_copy_from_branch),'GIPIS055',substr(p_copy_to_user,1,8))=1 THEN    --changed GIPIS055 to GIISS207 Gzelle 03.21.2014
						v_exists := 'N';
						IF v_combi IS NOT NULL THEN
							IF v_combi = p_copy_to_user||'-'||NVL(p_copy_to_branch,p_copy_from_branch)||'-'||a2.line_cd THEN
								v_exists := 'Y';
							END IF;	
						END IF;
                        
						IF v_exists = 'N' THEN
			  			INSERT INTO giis_posting_limit (posting_user,line_cd,post_limit,user_id,
			                                      	    last_update,iss_cd,all_amt_sw,	
			                                      	    endt_all_amt_sw,endt_post_limit)							
			                              	    VALUES (p_copy_to_user,a2.line_cd,a2.post_limit, p_user_id, --a2.user_id, Gzelle 05.23.2013
			                                	        a2.last_update,NVL(p_copy_to_branch,p_copy_from_branch),
                                                        a2.all_amt_sw,a2.endt_all_amt_sw,a2.endt_post_limit);					
						END IF;
						v_combi := p_copy_to_user||'-'||NVL(p_copy_to_branch,p_copy_from_branch)||'-'||a2.line_cd;		                                	      
					END IF;
                    
				END LOOP;
                	
		    END IF;
       
       END IF;
       
--       IF v_exists = 'Y' THEN
--	        msg_alert('This module has encountered and skipped duplicate records upon copy.','I',FALSE);
--	   END IF;
      
    END; 
      
END GIISS207_pkg;
/


