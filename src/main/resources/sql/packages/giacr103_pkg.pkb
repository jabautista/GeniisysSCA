CREATE OR REPLACE PACKAGE BODY CPI.GIACR103_PKG AS 

/*
**Created by: Benedict G. Castillo
**Date Created: 07/25/2013
**Description: GIACR103 : LIST OF UNDISTRIBUTED POLICIES
*/

FUNCTION populate_giacr103(
    p_line_cd       VARCHAR2,
    p_user_id       VARCHAR2
)RETURN giacr103_tab PIPELINED AS

v_rec       giacr103_type;
v_not_exist BOOLEAN := TRUE;

BEGIN
    v_rec.company_name      := giisp.v('COMPANY_NAME');
    v_rec.company_address   := giacp.v('COMPANY_ADDRESS');
    v_rec.as_of             := ('As of '||TO_CHAR(SYSDATE, 'fmMONTH DD, YYYY')); 
    
    FOR i IN(SELECT b.dist_flag, 
                    r.rv_meaning,
                    l.line_name,
                    s.subline_name, 
                    DECODE (b.endt_seq_no, 0, b.line_cd || '-' || b.subline_cd || '-' || b.iss_cd || '-' 
                        || LTRIM (TO_CHAR (b.issue_yy,'09')) || '-' ||LTRIM (TO_CHAR (b.pol_seq_no, '0999999')) 
                        || '-' || LTRIM (TO_CHAR (b.renew_no, '09')),b.line_cd || '-' || b.subline_cd || '-' 
                        || b.iss_cd || '-' || LTRIM (TO_CHAR (b.issue_yy,'09')) || '-' 
                        ||LTRIM (TO_CHAR (b.pol_seq_no, '0999999')) || '-' || LTRIM (TO_CHAR (b.renew_no, '09')) 
                        || '/' ||b.endt_iss_cd || '-' || LTRIM (TO_CHAR (b.endt_yy, '09')) 
                        || '-' || LTRIM (TO_CHAR (b.endt_seq_no, '099999'))) 
                        policy_endorsement,
                    b.issue_date,
                    b.incept_date,
                    a.assd_name,
                    b.tsi_amt,
                    b.prem_amt
            FROM cg_ref_codes r,
                 giis_line l,
                 gipi_polbasic b,
                 giis_subline s,
                 giis_assured a,
                 gipi_parlist p
            WHERE r.rv_low_value = b.dist_flag
            AND r.rv_low_value in ( '1', '2', '4' )
            AND b.dist_flag in ( '1', '2', '4' )
            AND r.rv_domain = 'GIPI_POLBASIC.DIST_FLAG'    
            AND b.iss_cd = 'RI'
            AND l.line_cd = b.line_cd
            AND s.subline_cd = b.subline_cd
            AND s.line_cd = l.line_cd
            AND a.assd_no = b.assd_no
            AND p.par_id = b.par_id
            AND b.pol_flag <> '5'
            AND nvl ( b.endt_type, 0 ) <> 'N'
            AND b.acct_ent_date is null
            AND l.line_cd = nvl (p_line_cd,l.line_cd)
            /*AND check_user_per_iss_cd_acctg2(b.line_cd, b.iss_cd, 'GIACS102', p_user_id) = 1  -- marco - 09.13.2013
            AND check_user_per_line2(b.line_cd,b.iss_cd,'GIACS102',p_user_id) = 1*/--modified checking of security access by albert 10.22.2015 (GENQA SR 4461)
            AND b.iss_cd IN (SELECT branch_cd FROM TABLE(security_access.get_branch_line ('AC','GIACS102',p_user_id)))
            ORDER BY b.iss_cd, b.issue_yy, b.pol_seq_no, b.renew_no) 
    
    LOOP
        v_not_exist         := FALSE;
        v_rec.dist_flag     := i.dist_flag;
        v_rec.rv_meaning    := i.rv_meaning;
        v_rec.line_name     := ('Line '||i.line_name);
        v_rec.subline_name  := ('Subline '||i.subline_name);
        v_rec.policy_endor  := i.policy_endorsement;
        v_rec.issue_date    := i.issue_date;
        v_rec.incept_date   := i.incept_date;
        v_rec.assd_name     := i.assd_name;
        v_rec.tsi_amt       := i.tsi_amt;
        v_rec.prem_amt      := i.prem_amt;
        PIPE ROW(v_rec);
    END LOOP;

    IF v_not_exist THEN
        v_rec.flag  := 'T';
        PIPE ROW(v_rec);
    END IF; 
END populate_giacr103;
END GIACR103_PKG;
/
