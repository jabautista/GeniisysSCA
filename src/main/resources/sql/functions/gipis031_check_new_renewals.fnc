DROP FUNCTION CPI.GIPIS031_CHECK_NEW_RENEWALS;

CREATE OR REPLACE FUNCTION CPI.GIPIS031_CHECK_NEW_RENEWALS(
	p_line_cd IN gipi_polbasic.line_cd%TYPE,
	p_subline_cd IN gipi_polbasic.subline_cd%TYPE,	
	p_iss_cd IN gipi_polbasic.iss_cd%TYPE,
	p_issue_yy IN gipi_polbasic.issue_yy%TYPE,
	p_pol_seq_no IN gipi_polbasic.pol_seq_no%TYPE,
	p_renew_no IN gipi_polbasic.renew_no%TYPE)
RETURN VARCHAR2
AS
	/*	Date        Author			Description
    **	==========	===============	============================    
    **	01.18.2012	mark jm			This function will check for replacements and/or renewals and 
	**								compare it with the current policy. Returns 'N' if there is a newer renewal or replacement 
	**								and disallow cancel, and returns 'Y' to allow cancel. (Original Description)
    **								Reference By : (GIPIS031 - Endt. Basic Information)
    */
	CURSOR c1 (p_oldpolid1 NUMBER) IS
      SELECT new_policy_id
        FROM gipi_polnrep
       WHERE old_policy_id = p_oldpolid1;

	CURSOR c2 (p_oldpolid2 NUMBER) IS
      SELECT MAX (new_policy_id)
        FROM gipi_polnrep
       WHERE old_policy_id = p_oldpolid2;

	CURSOR c3 (p_newpolid3 NUMBER) IS
      SELECT old_policy_id
        FROM gipi_polnrep
       WHERE new_policy_id = p_newpolid3;
	   
	v_policy_id gipi_polbasic.policy_id%TYPE;
	v_oldpolid1   NUMBER;
	v_oldpolid2   NUMBER;
	v_lastpolid   NUMBER;
	v_count1      NUMBER;
	v_count2      NUMBER;
	v_count3      NUMBER;
	v_cancel      VARCHAR2(1);
	exit_main     VARCHAR2(1) := 'N';
BEGIN
	FOR i IN (
		SELECT policy_id     
		  FROM gipi_polbasic
		 WHERE 1=1 
		   AND line_cd = p_line_cd 
		   AND subline_cd = p_subline_cd
		   AND iss_cd = p_iss_cd
		   AND issue_yy = p_issue_yy
		   AND pol_seq_no = p_pol_seq_no
		   AND renew_no = p_renew_no
		   AND endt_seq_no = 0)
	LOOP
		v_policy_id := i.policy_id;
		EXIT;
	END LOOP;
	
	BEGIN
		SELECT old_policy_id
          INTO v_oldpolid1
          FROM gipi_polnrep
         WHERE new_policy_id = v_policy_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_oldpolid1 := v_policy_id;
    END;
    
    LOOP -- main LOOP 1
        FOR x IN c1 (v_oldpolid1)
        LOOP
            SELECT COUNT (*)
              INTO v_count1
              FROM gipi_polnrep
             WHERE old_policy_id = x.new_policy_id;

            IF v_count1 > 0 THEN
                OPEN c2 (x.new_policy_id);
                FETCH c2 INTO v_oldpolid1;
                CLOSE c2;

                IF NVL (v_lastpolid, 0) < NVL (v_oldpolid1, x.new_policy_id) THEN
                    v_lastpolid := NVL (v_oldpolid1, x.new_policy_id);
                END IF;

                EXIT;
            ELSE
                v_lastpolid := x.new_policy_id;
                exit_main := 'Y';
            END IF;
        END LOOP; --FOR x LOOP

        SELECT COUNT (*)
          INTO v_count2
          FROM gipi_polnrep
         WHERE old_policy_id = v_oldpolid1;

        IF exit_main = 'Y' OR v_count2 = 0 THEN
            EXIT;
        END IF;
    END LOOP; -- main LOOP 1
    
    LOOP -- LOOP 2
        SELECT COUNT (*)
          INTO v_count3
          FROM gipi_polbasic
         WHERE policy_id = v_lastpolid 
           AND pol_flag IN ('1', '2', '3');

        IF v_count3 < 1 AND v_lastpolid IS NOT NULL THEN
            OPEN c3 (v_lastpolid);
            FETCH c3 INTO v_lastpolid;
            CLOSE c3;
        ELSE
            EXIT;
        END IF;
    END LOOP; -- LOOP 2
    
    IF NVL (v_lastpolid, 0) > v_policy_id THEN
        v_cancel := 'N';
    ELSE
        v_cancel := 'Y';
    END IF;

    RETURN (v_cancel);
END GIPIS031_CHECK_NEW_RENEWALS;
/


