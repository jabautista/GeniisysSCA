DROP FUNCTION CPI.VALIDATE_NO_OF_PERSONS;

CREATE OR REPLACE FUNCTION CPI.VALIDATE_NO_OF_PERSONS(
    p_line_cd           GIPI_WPOLBAS.line_cd%TYPE,
    p_subline_cd        GIPI_WPOLBAS.subline_cd%TYPE,
    p_iss_cd            GIPI_WPOLBAS.iss_cd%TYPE,
    p_issue_yy          GIPI_WPOLBAS.issue_yy%TYPE,
    p_pol_seq_no        GIPI_WPOLBAS.pol_seq_no%TYPE,
    p_renew_no          GIPI_WPOLBAS.renew_no%TYPE,
    p_item_no           GIPI_WITEM.item_no%TYPE
)
RETURN NUMBER
AS
    counter             NUMBER := 0;
BEGIN
    FOR count IN (SELECT DISTINCT a.grouped_item_no
                    FROM GIPI_GROUPED_ITEMS a, GIPI_POLBASIC b               
                   WHERE b.line_cd = p_line_cd
                     AND b.subline_cd = p_subline_cd
                     AND b.iss_cd  = p_iss_cd
                     AND b.issue_yy = p_issue_yy
                     AND b.pol_seq_no = p_pol_seq_no
                     AND b.renew_no = p_renew_no
	                 AND a.policy_id = b.policy_id
	                 AND a.item_no = p_item_no
	                 AND nvl(a.delete_sw,'N') != 'Y')
    LOOP
        counter := counter + 1;
    END LOOP;
    RETURN counter;
END;
/


