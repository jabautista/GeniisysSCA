CREATE OR REPLACE PACKAGE BODY CPI.GIPIR924K_PKG 
AS
/*
**  Created By: Benjo Brito
**  Date Created: 06.18.2015
**  GIPIR924K - Display Records Per Bill Per Agent
**  GENQA-AFPGEN-IMPLEM-SR-4615 | UW-SPECS-2015-059-FULLWEB 
*/
    FUNCTION get_date_format (p_date DATE)
       RETURN VARCHAR2
    AS
       v_date   giis_parameters.param_value_v%TYPE;
    BEGIN
       SELECT TO_CHAR (p_date, giisp.v ('REP_DATE_FORMAT'))
         INTO v_date
         FROM DUAL;

       RETURN v_date;
    EXCEPTION
       WHEN OTHERS
       THEN
          v_date := TO_CHAR (p_date, 'MM/DD/RRRR');
          RETURN v_date;
    END;
    
    FUNCTION get_report_details (
       p_parameter    VARCHAR2,
       p_iss_cd       VARCHAR2,
       p_line_cd      VARCHAR2,
       p_subline_cd   VARCHAR2,
       p_scope        NUMBER,
       p_user_id      VARCHAR2,
       p_param_date   VARCHAR2,
       p_from_date    VARCHAR2,
       p_to_date      VARCHAR2,
       p_tab          VARCHAR2,
       p_reinstated VARCHAR2
    )
       RETURN get_details_tab PIPELINED
    IS
       v_rec           get_details_type;
       v_from_date     DATE := TO_DATE(p_from_date, 'MM/DD/RRRR');
       v_to_date       DATE := TO_DATE(p_to_date, 'MM/DD/RRRR');
       v_date_format   giis_parameters.param_value_v%TYPE;
       v_iss_cd        gipi_invoice.iss_cd%TYPE := NULL;
       v_prem_seq_no   gipi_invoice.prem_seq_no%TYPE := NULL;
       v_ri_name            giis_reinsurer.ri_name%TYPE ; 
    BEGIN
       --Moved here by pjsantos 03/14/2017, for optimization GENQA 5955
       BEGIN
             SELECT report_title
               INTO v_rec.report_title
               FROM giis_reports
              WHERE report_id = 'GIPIR924K';
          EXCEPTION
             WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
             THEN
                v_rec.report_title :=
                                  'Production Register with Distribution Details';
       END;
       v_rec.company_name := giisp.v ('COMPANY_NAME');
       v_rec.company_address := giisp.v ('COMPANY_ADDRESS');
       IF v_from_date = v_to_date
          THEN
            v_rec.report_from_to := 'For ' || TO_CHAR(v_from_date, 'fmMonth ') || TO_CHAR(v_from_date, 'DD, RRRR');
          ELSE
            v_rec.report_from_to := 'For the Period of ' || TO_CHAR(v_from_date, 'fmMonth ') || TO_CHAR(v_from_date, 'DD, RRRR') ||
                                    ' to ' || TO_CHAR(v_to_date, 'fmMonth ') || TO_CHAR(v_to_date, 'DD, RRRR');
       END IF;
       --pjsantos end
       
       FOR i IN (SELECT  a.policy_id, b.iss_cd branch_cd, a.iss_cd, b.iss_name, c.line_cd,
                         c.line_name, a.issue_date, a.prem_seq_no, a.incept_date,
                         a.expiry_date, NVL (d.assd_tin, d.no_tin_reason) assd_tin,
                         d.assd_name, a.prem_amt, a.vat, a.prem_tax, a.fst, a.lgt,
                         a.doc_stamps, a.other_taxes, a.other_charges, a.RETENTION,
                         a.facultative, a.ri_comm, a.ri_comm_vat, a.treaty, a.trty_ri_comm,
                         a.trty_ri_comm_vat, f.intm_name,
                         SUM (DECODE (a.iss_cd, giisp.v ('ISS_CD_RI'), a.comm, e.commission_amt)) commission_amt
                    FROM gipi_uwreports_dist_ext a,
                         giis_issource b,
                         giis_line c,
                         giis_assured d,
                         gipi_uwreports_comm_invperil e,
                         giis_intermediary f
                   WHERE DECODE (p_parameter, 1, NVL(a.cred_branch, a.iss_cd), a.iss_cd) = b.iss_cd
                     AND a.line_cd = c.line_cd
                     AND a.assd_no = d.assd_no
                     AND a.tab_number = p_tab
                     AND a.user_id = p_user_id
                     AND DECODE (p_parameter, 1, NVL(a.cred_branch, a.iss_cd), a.iss_cd) = 
                         NVL (p_iss_cd, DECODE (p_parameter, 1, NVL(a.cred_branch, a.iss_cd), a.iss_cd))
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
                     AND (   (p_scope = 1 AND a.endt_seq_no = 0)
                          OR (p_scope = 2 AND a.endt_seq_no <> 0)
                          OR (p_scope = 3 AND a.pol_flag = '4')
                          OR (p_scope = 4 AND a.pol_flag = '5')
                          OR (p_scope = 5 AND a.pol_flag <> '5')
                          OR p_scope = 6)--Added by pjsantos 03/14/2017, GENQA 5955
                      AND (p_scope <> 4 
                            OR NVL(p_reinstated, 'N') = 'N'
                            OR EXISTS (
                                        SELECT 1 FROM gipi_uwreports_ext t
                                            where t.user_id = p_user_id
                                            and t.tab_number = p_tab
                                            and t.policy_id = a.policy_id
                                            and NVL(t.reinstate_tag,'N') = DECODE (NVL(p_reinstated, 'N'), 'N', t.reinstate_tag , 'Y')  ))
                     AND a.user_id = e.user_id(+)
                     AND a.policy_id = e.policy_id(+)
                     AND a.prem_seq_no = e.prem_seq_no(+)
                     AND a.iss_cd = e.iss_cd(+)
                     AND a.tab_number = e.tab_number(+)
                     AND e.intm_no = f.intm_no(+)
                GROUP BY a.policy_id, b.iss_cd, a.iss_cd, b.iss_name, c.line_cd, c.line_name,
                         a.issue_date, a.prem_seq_no, a.incept_date, a.expiry_date, d.assd_tin,
                         d.no_tin_reason, d.assd_name, a.prem_amt, a.vat, a.prem_tax, a.fst,
                         a.lgt, a.doc_stamps, a.other_taxes, a.other_charges, a.RETENTION,
                         a.facultative, a.ri_comm, a.cred_branch, a.ri_comm_vat, a.treaty,
                         a.trty_ri_comm, a.trty_ri_comm_vat, f.intm_name, a.line_cd,
                         a.subline_cd, a.issue_yy, a.pol_seq_no, a.renew_no, a.endt_seq_no
                ORDER BY DECODE (p_parameter, 1, NVL (a.cred_branch, a.iss_cd), a.iss_cd),
                         a.line_cd,
                         a.subline_cd,
                         a.iss_cd,
                         a.issue_yy,
                         a.pol_seq_no,
                         a.renew_no,
                         a.endt_seq_no,
                         a.prem_seq_no,
                         f.intm_name)
       LOOP
          /*BEGIN
             SELECT report_title
               INTO v_rec.report_title
               FROM giis_reports
              WHERE report_id = 'GIPIR924K';
          EXCEPTION
             WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
             THEN
                v_rec.report_title :=
                                  'Production Register with Distribution Details';
          END;*/--Moved to top by pjsantos 03/14/2017, for optimization GENQA 5955
          
          IF v_iss_cd = i.iss_cd AND v_prem_seq_no = i.prem_seq_no THEN
             v_rec.print_tag := 'N';
          ELSE
             v_rec.print_tag := 'Y';
          END IF;
          
          /*IF v_from_date = v_to_date
          THEN
            v_rec.report_from_to := 'For ' || TO_CHAR(v_from_date, 'fmMonth ') || TO_CHAR(v_from_date, 'DD, RRRR');
          ELSE
            v_rec.report_from_to := 'For the Period of ' || TO_CHAR(v_from_date, 'fmMonth ') || TO_CHAR(v_from_date, 'DD, RRRR') ||
                                    ' to ' || TO_CHAR(v_to_date, 'fmMonth ') || TO_CHAR(v_to_date, 'DD, RRRR');
          END IF;*/ --Moved to top by pjsantos 03/14/2017, for optimization GENQA 5955
             
          v_iss_cd := i.iss_cd;
          v_prem_seq_no := i.prem_seq_no;
          
          /*v_rec.company_name := giisp.v ('COMPANY_NAME');
          v_rec.company_address := giisp.v ('COMPANY_ADDRESS');*/--Moved to top by pjsantos 03/14/2017, for optimization GENQA 5955
          v_rec.policy_id := i.policy_id;
          v_rec.prem_seq_no := i.prem_seq_no;
          v_rec.branch_cd := i.branch_cd;
          v_rec.iss_cd := i.iss_cd;
          v_rec.iss_name := i.iss_name;
          v_rec.line_cd := i.line_cd;
          v_rec.line_name := i.line_name;
          v_rec.issue_date := get_date_format (i.issue_date);
          v_rec.policy_no := get_policy_no(i.policy_id);
          v_rec.invoice_no :=
                        i.iss_cd || '-' || TO_CHAR (i.prem_seq_no, '099999999999');
          v_rec.policy_term :=
                get_date_format (i.incept_date)
             || ' - '
             || get_date_format (i.expiry_date);
          v_rec.assd_tin := i.assd_tin;
          v_rec.assd_name := SUBSTR(i.assd_name, 1, 50);
          v_rec.prem_amt := NVL (i.prem_amt, 0);
          v_rec.evatprem := NVL (i.vat, 0) + NVL (i.prem_tax, 0);
          v_rec.lgt := NVL (i.lgt, 0);
          v_rec.doc_stamps := NVL (i.doc_stamps, 0);
          v_rec.fst := NVL (i.fst, 0);
          v_rec.other_taxes := NVL (i.other_charges, 0) + NVL (i.other_taxes, 0);
          v_rec.RETENTION := NVL (i.RETENTION, 0);
          v_rec.facultative := NVL (i.facultative, 0);
          v_rec.ri_comm := NVL (i.ri_comm, 0);
          v_rec.ri_comm_vat := NVL (i.ri_comm_vat, 0);
          v_rec.treaty := NVL (i.treaty, 0);
          v_rec.trty_ri_comm := NVL (i.trty_ri_comm, 0);
          v_rec.trty_ri_comm_vat := NVL (i.trty_ri_comm_vat, 0);
          
          v_ri_name := NULL;
          
          IF i.iss_cd = giisp.v('ISS_CD_RI') THEN
            FOR tc IN ( SELECT b.ri_name
                        FROM giri_inpolbas a, giis_reinsurer b 
                          WHERE a.ri_cd = b.ri_cd 
                             AND a.policy_id = i.policy_id )
            LOOP
                v_ri_name := tc.ri_name ;
                EXIT; 
            END LOOP; 
            
             v_rec.intm_name := SUBSTR (v_ri_name, 1, 40);
          ELSE
             v_rec.intm_name := SUBSTR (i.intm_name, 1, 40);
          END IF; 
         
          v_rec.commission_amt := NVL (i.commission_amt, 0);
          PIPE ROW (v_rec);
       END LOOP;
    END get_report_details;
END GIPIR924K_PKG;
/