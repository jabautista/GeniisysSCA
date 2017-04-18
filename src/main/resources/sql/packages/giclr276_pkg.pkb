CREATE OR REPLACE PACKAGE BODY CPI.GICLR276_PKG
AS
    /*
    **  Created by    : Paul Joseph Diaz
    **  Date Created  : May 07, 2013
    **  Reference By  : GICLR276 - Claim Listing Per Lawyer
    */
    FUNCTION populate_giclr276 (
         p_rec_type_cd     VARCHAR2,
         p_search_by       NUMBER,
         p_as_of_date      VARCHAR2,
         p_from_date       VARCHAR2,
         p_to_date         VARCHAR2,
         p_lawyer_cd       NUMBER,
         p_lawyer_class_cd VARCHAR2,
         p_user_id         VARCHAR2
    )
    RETURN giclr276_report_tab PIPELINED
    AS
    v_report      giclr276_report_type;
    v_date_title  VARCHAR2(100); 
    BEGIN
        FOR i IN (SELECT DISTINCT b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LPAD(b.clm_yy,2,'0')||'-'||LPAD(clm_seq_no,7,'0') claim_no,
                         b.line_cd||'-'||b.subline_cd||'-'||b.pol_iss_cd||'-'||LPAD(b.issue_yy,2,'0')||'-'||LPAD(pol_seq_no,7,'0')||'-'||LPAD(renew_no,2,'0') policy_no,
                         b.assured_name,       
                         b.dsp_loss_date,
                         b.clm_file_date, 
                         c.line_cd||'-'||c.iss_cd||'-'||c.rec_year||'-'||LPAD(c.rec_seq_no,3,'0') rec_no,
                         c.recoverable_amt,
                         c.recovered_amt,
                         a.recovered_amt payr_rec_amt,
                         (c.lawyer_cd||' - '||e.payee_first_name||' '||e.payee_middle_name ||' '||e.payee_last_name) lawyer,
                         a.payor_cd, a.payor_class_cd,
                         c.case_no,
                         c.court,
                         DECODE (c.cancel_tag, 'CD', 'CLOSED', 'CC', 'CANCELLED', 'WO', 'WRITTEN OFF', 'IN PROGRESS') rec_status
                    FROM gicl_recovery_payor a, gicl_claims b, gicl_clm_recovery c, giis_recovery_type d, giis_payees e
                   WHERE c.lawyer_cd = p_lawyer_cd
                     AND UPPER(c.lawyer_class_cd) = UPPER(p_lawyer_class_cd)
                     AND b.claim_id  = c.claim_id  
                     AND b.claim_id=  a.claim_id
                     AND c.lawyer_cd= e.payee_no
                     AND c.lawyer_class_cd = e.payee_class_cd
                     AND a.recovery_id = c.recovery_id
                     AND check_user_per_line2(b.line_cd,b.iss_cd,'GICLS276',p_user_id)=1
                     AND b.claim_id IN (SELECT DECODE(p_search_by, 1, (SELECT gc1.claim_id
                                                                         FROM gicl_claims gc1
                                                                        WHERE gc1.claim_id = gc.claim_id
                                                                          AND TRUNC(gc1.clm_file_date) <= TO_DATE(p_as_of_date,'MM-DD-YYYY')),
                                                                   2, (SELECT gc1.claim_id
                                                                         FROM gicl_claims gc1
                                                                        WHERE gc1.claim_id = gc.claim_id
                                                                          AND TRUNC(gc1.clm_file_date) BETWEEN TO_DATE(p_from_date,'MM-DD-YYYY') 
                                                                                                           AND TO_DATE(p_to_date,'MM-DD-YYYY')),
                                                                   3, (SELECT gc1.claim_id
                                                                         FROM gicl_claims gc1
                                                                        WHERE gc1.claim_id = gc.claim_id
                                                                          AND TRUNC(gc1.dsp_loss_date) <= TO_DATE(p_as_of_date,'MM-DD-YYYY')),
                                                                   6, (SELECT gc1.claim_id
                                                                         FROM gicl_claims gc1
                                                                        WHERE gc1.claim_id = gc.claim_id
                                                                          AND TRUNC(gc1.dsp_loss_date) BETWEEN TO_DATE(p_from_date,'MM-DD-YYYY') 
                                                                                                           AND TO_DATE (p_to_date,'MM-DD-YYYY')))
                                                                         FROM gicl_claims gc)
                    ORDER BY claim_no)
        LOOP
            v_report.lawyer          := i.lawyer;
            v_report.claim_no        := i.claim_no;
            v_report.policy_no       := i.policy_no;
            v_report.assured_name    := i.assured_name;
            v_report.dsp_loss_date   := i.dsp_loss_date;
            v_report.clm_file_date   := i.clm_file_date;
            v_report.rec_no          := i.rec_no;
            v_report.case_no         := i.case_no;
            v_report.court           := i.court;
            v_report.rec_status      := i.rec_status;
            v_report.recoverable_amt := i.recoverable_amt;
            v_report.recovered_amt   := i.payr_rec_amt;
            v_report.company_name    := giisp.v ('COMPANY_NAME');
            v_report.company_address := giisp.v ('COMPANY_ADDRESS');
            v_report.report_title    := 'CLAIM LISTING PER LAWYER';
         
           BEGIN
                IF p_search_by IN (1,3) THEN
                    IF p_search_by IN (1) THEN
                        v_report.date_title :='Claim File Date As of '||TO_CHAR(TO_DATE(p_as_of_date,'MM-DD-YYYY'),'fmMonth DD, RRRR');
                    ELSE 
                        v_report.date_title :='Loss Date As of '||TO_CHAR(TO_DATE(p_as_of_date,'MM-DD-YYYY'),'fmMonth DD, RRRR');
                    END IF;
                  ELSIF p_search_by IN (2,6) THEN
                    IF  p_search_by IN (2) THEN	
                        v_report.date_title :=' Claim File Date From '||TO_CHAR(TO_DATE(p_from_date,'MM-DD-YYYY'),'fmMonth DD, RRRR')
                                ||' to '||TO_CHAR(TO_DATE(p_to_date,'MM-DD-YYYY'),'fmMonth DD, RRRR');
                    ELSE
                        v_report.date_title :=' Loss Date From '||TO_CHAR(TO_DATE(p_from_date,'MM-DD-YYYY'),'fmMonth DD, RRRR')
                                ||' to '||TO_CHAR(TO_DATE(p_to_date,'MM-DD-YYYY'),'fmMonth DD, RRRR');
                    END IF;
                  END IF;
           END;
           PIPE ROW(v_report); 
        END LOOP;
        RETURN;
    END;
END giclr276_pkg;
/


