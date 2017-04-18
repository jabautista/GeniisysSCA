DROP PROCEDURE CPI.GIPIS031_VALIDATE_INCEPTDATE01;

CREATE OR REPLACE PROCEDURE CPI.GIPIS031_VALIDATE_INCEPTDATE01 (
	p_line_cd IN gipi_wpolbas.line_cd%TYPE,
	p_subline_cd IN gipi_wpolbas.subline_cd%TYPE,
	p_message OUT VARCHAR2,
	p_message_type OUT VARCHAR2,
	p_incept_date IN OUT gipi_wpolbas.incept_date%TYPE)
AS
	/*	Date        Author			Description
    **	==========	===============	============================    
    **	01.17.2012	mark jm			Validate incept date
    **								Add a message asking the user  to change 
    **								the due dates of previous endt/policy.    
    **								Part 1. See GIPIS031_VALIDATE_INCEPTDATE02 for next part
    **								Reference By : (GIPIS031 - Endt. Basic Information)
    */
	v_add_time NUMBER;
BEGIN
	v_add_time := 0;
    get_addtl_time_gipis002(p_line_cd, p_subline_cd, v_add_time);  -- get the cut-off time for records subline 
    
    p_message := 'Please change due dates of the previous endorsement/policy.';
    p_message_type := 'INFO';
    
    IF TO_CHAR(p_incept_date, 'HH:MI:SS AM') = '12:00:00 AM' THEN
        p_incept_date := p_incept_date + v_add_time / 86400;
    END IF;
END GIPIS031_VALIDATE_INCEPTDATE01;
/


