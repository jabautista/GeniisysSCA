DROP PROCEDURE CPI.GET_CASUALTY_PERSONNEL_DTL;

CREATE OR REPLACE PROCEDURE CPI.GET_CASUALTY_PERSONNEL_DTL (
	p_par_id		IN gipi_wpolbas.par_id%TYPE,	
	p_item_no		IN gipi_item.item_no%TYPE,
	p_persnl_no		IN gipi_casualty_personnel.personnel_no%TYPE,
	p_name			OUT gipi_casualty_personnel.name%TYPE,
	p_remarks		OUT gipi_casualty_personnel.remarks%TYPE,
	p_capacity_cd	OUT gipi_casualty_personnel.capacity_cd%TYPE,
	p_amt_covered	OUT gipi_casualty_personnel.amount_covered%TYPE)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 11.23.2010
	**  Reference By 	: (GIPIS061 - Endt Item Information - Casualty)
	**  Description 	: Returns record from gipi_casualty_personnel based on the given parameters
	*/
	v_line_cd		gipi_wpolbas.line_cd%TYPE;
    v_subline_cd    gipi_wpolbas.subline_cd%TYPE;
    v_iss_cd        gipi_wpolbas.iss_cd%TYPE;
    v_issue_yy        gipi_wpolbas.issue_yy%TYPE;
    v_pol_seq_no    gipi_wpolbas.pol_seq_no%TYPE;
    v_renew_no        gipi_wpolbas.renew_no%TYPE;
    v_eff_date         gipi_wpolbas.eff_date%TYPE;
BEGIN
    FOR i IN (
        SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, eff_date
          FROM gipi_wpolbas
         WHERE par_id = p_par_id)
    LOOP
        v_line_cd := i.line_cd;
        v_subline_cd := i.subline_cd;
        v_iss_cd := i.iss_cd;
        v_issue_yy := i.issue_yy;
        v_pol_seq_no := i.pol_seq_no;
        v_renew_no := i.renew_no;
        v_eff_date := i.eff_date;
    END LOOP;

    FOR info IN (
        SELECT c.name, c.remarks, c.capacity_cd, c.amount_covered,
               NVL(c.delete_sw, 'N') delete_sw, a.eff_date
          FROM gipi_item b,
               gipi_polbasic a,
               gipi_casualty_personnel c
         WHERE 1 = 1
           AND a.policy_id = b.policy_id
           AND a.policy_id = c.policy_id
           AND b.item_no = c.item_no
           AND b.item_no = p_item_no
           AND c.personnel_no = p_persnl_no
           AND a.line_cd = v_line_cd
           AND a.subline_cd = v_subline_cd
           AND a.iss_cd = v_iss_cd
           AND a.issue_yy = v_issue_yy
           AND a.pol_seq_no = v_pol_seq_no
           AND a.renew_no = v_renew_no
           AND a.pol_flag IN ('1', '2', '3', 'X')
           AND NOT EXISTS (
                SELECT 'x'
                  FROM gipi_polbasic x,
                       gipi_item y,
                       gipi_casualty_personnel z
                 WHERE 1 = 1
                   AND x.policy_id = y.policy_id
                   AND y.policy_id = z.policy_id
                   AND y.item_no = z.item_no
                   AND y.item_no = p_item_no
                   AND z.personnel_no = p_persnl_no
                   AND x.line_cd = v_line_cd
                   AND x.subline_cd = v_subline_cd
                   AND x.iss_cd = v_iss_cd
                   AND x.issue_yy = v_issue_yy
                   AND x.pol_seq_no = v_pol_seq_no
                   AND x.renew_no = v_renew_no
                   AND x.pol_flag IN ('1', '2', '3', 'X')
                   AND NVL(x.back_stat, 5) = 2)
       ORDER BY a.eff_date DESC)
    LOOP
        IF info.delete_sw = 'Y' THEN            
            IF v_eff_date >= info.eff_date THEN
                p_name := NULL;
                p_remarks := NULL;
                p_capacity_cd := NULL;
                p_amt_covered := NULL;
                EXIT;
            END IF;            
        ELSE
            p_name := info.name;
            p_remarks := info.remarks;
            p_capacity_cd := info.capacity_cd;
            p_amt_covered := info.amount_covered;
            EXIT;
        END IF;
    END LOOP;
END GET_CASUALTY_PERSONNEL_DTL;
/


