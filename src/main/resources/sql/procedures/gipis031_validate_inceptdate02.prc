DROP PROCEDURE CPI.GIPIS031_VALIDATE_INCEPTDATE02;

CREATE OR REPLACE PROCEDURE CPI.GIPIS031_VALIDATE_INCEPTDATE02 (
	p_par_id IN gipi_wpolbas.par_id%TYPE,
	p_line_cd IN gipi_wpolbas.line_cd%TYPE,
	p_subline_cd IN gipi_wpolbas.subline_cd%TYPE,
	p_iss_cd IN gipi_wpolbas.iss_cd%TYPE,
	p_issue_yy IN gipi_wpolbas.issue_yy%TYPE,
	p_pol_seq_no IN gipi_wpolbas.pol_seq_no%TYPE,
	p_renew_no IN gipi_wpolbas.renew_no%TYPE,
	p_eff_date IN gipi_wpolbas.eff_date%TYPE,
	p_expiry_date IN gipi_wpolbas.expiry_date%TYPE,
	p_message OUT VARCHAR2,
	p_message_type OUT VARCHAR2,
    p_incept_date IN OUT gipi_wpolbas.incept_date%TYPE)
AS
    /*    Date        Author            Description
    **    ==========    ===============    ============================    
    **    01.17.2012    mark jm            Validate incept date
    **                                Add a message asking the user  to change 
    **                                the due dates of previous endt/policy.    
    **                                Part 2. See GIPIS031_VALIDATE_INCEPTDATE01 for previous part
    **                                Reference By : (GIPIS031 - Endt. Basic Information)
    */
BEGIN
    FOR C1 IN (
        SELECT eff_date, expiry_date, incept_date
          FROM gipi_wpolbas
         WHERE par_id = p_par_id
           AND line_cd = p_line_cd
           AND subline_cd = p_subline_cd
           AND iss_cd = p_iss_cd
           AND issue_yy = p_issue_yy
           AND pol_seq_no = p_pol_seq_no
           AND renew_no = p_renew_no
      ORDER BY eff_date)
    LOOP
        IF C1.eff_date IS NOT NULL THEN
            IF p_eff_date < p_incept_date THEN
                p_message := 'The new inception date should not be later than '; --|| TO_CHAR(C1.eff_date) || '.'; removed. date showed should the current endt effectivity date. -irwin 9.12.2012
                p_message_type := 'WARNING';
                p_incept_date := C1.incept_date;
            END IF;
        ELSE
            IF p_expiry_date < p_incept_date THEN
                p_message := 'The new inception date should not be later than ';-- ||O_CHAR(C1.expiry_date) || '.';
                p_message_type := 'WARNING';
                p_incept_date := C1.incept_date;
            END IF;
        END IF;
        EXIT;
    END LOOP;
    
    IF p_message IS NULL
    THEN
        IF p_eff_date < p_incept_date THEN
            p_message := 'The new inception date should not be later than ';
            p_message_type := 'WARNING';
            p_incept_date := null;
        END IF;    
    END IF;
END GIPIS031_VALIDATE_INCEPTDATE02;
/


