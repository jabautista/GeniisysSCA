CREATE OR REPLACE PACKAGE BODY CPI.GIACR217_pkg
AS
 /*
    **  Created by   :  Melvin John O. Ostia
    **  Date Created : 07.025.2013
    **  Reference By : GIACR217_PKG - PRODUCTION REGISTER PER INTERMEDIARY 
    */
    FUNCTION get_giacr217_record(
    p_from_acct_ent_date VARCHAR2,
    p_to_acct_ent_date   VARCHAR2,
    p_intm_no   NUMBER,
    p_intm_type VARCHAR2,
    p_iss_cred  VARCHAR2,
    p_iss_cd VARCHAR2,
    p_user_id VARCHAR2
    )
    RETURN 
        giacr217_tab PIPELINED
    AS
        v_rec giacr217_type;
        v_from DATE := TO_DATE(p_from_acct_ent_date, 'MM/DD/YYYY');
        v_to   DATE := TO_DATE(p_to_acct_ent_date, 'MM/DD/YYYY');
    BEGIN
    
    select param_value_v
    into v_rec.company_name
    from giac_parameters
    where UPPER(param_name) = 'COMPANY_NAME';
   
    select param_value_v
    into v_rec.company_address
    from giac_parameters
    where param_name = 'COMPANY_ADDRESS';
    
    FOR i IN (
    
                    SELECT   iss.iss_name branch, intr.intm_name intermediary_name,
                             intr.intm_type "INTERMEDIARY_TYPE",
                             lin.line_cd || '-' || lin.line_name line,
                             subl.subline_cd || '-' || subl.subline_name subline,
                             assr.assd_name assured_name, pol.incept_date, pol.expiry_date,
                             (com.commission_amt * invo.currency_rt) commission, pol.endt_seq_no,
                             pol.line_cd, pol.subline_cd, pol.iss_cd, pol.issue_yy,
                             pol.pol_seq_no, pol.renew_no, pol.endt_iss_cd, pol.endt_yy,
                             (pol.tsi_amt) sum_insured,
                             (invo.prem_amt * invo.currency_rt * (com.share_percentage / 100)
                             ) premium_amt,
                             (invo.tax_amt * invo.currency_rt * (com.share_percentage / 100)
                             ) tax_amount,
                             (  (invo.prem_amt * invo.currency_rt * (com.share_percentage / 100)
                                )
                              + (invo.tax_amt * invo.currency_rt * (com.share_percentage / 100))
                             ) premium_receivable,
                             pol.policy_id,
                             DECODE (p_iss_cred,
                                     'C', NVL (pol.cred_branch, pol.iss_cd),
                                     pol.iss_cd 
                                    ) iss_cd1
                        FROM gipi_polbasic pol,
                             giis_intermediary intr,
                             giis_intm_type intm,
                             giis_line lin,
                             giis_subline subl,
                             gipi_invoice invo,
                             gipi_comm_invoice com,
                             giis_issource iss,
                             giis_assured assr,
                             gipi_parlist par
                       WHERE (   pol.acct_ent_date BETWEEN v_from
                                                       AND v_to
                              OR pol.spld_acct_ent_date BETWEEN v_from
                                                            AND v_to
                             )
                         AND com.intrmdry_intm_no = NVL (p_intm_no, com.intrmdry_intm_no)
                         AND intr.intm_type = NVL (p_intm_type, intr.intm_type)
                         AND pol.policy_id = invo.policy_id
                         AND pol.line_cd = lin.line_cd
                         AND pol.iss_cd = invo.iss_cd
                         AND pol.iss_cd = iss.iss_cd
                         AND pol.iss_cd = com.iss_cd
                         AND invo.iss_cd = com.iss_cd
                         AND invo.policy_id = com.policy_id
                         AND invo.prem_seq_no = com.prem_seq_no
                         AND com.intrmdry_intm_no = intr.intm_no
                         AND intr.intm_type = intm.intm_type
                         AND lin.line_cd = subl.line_cd
                         AND pol.subline_cd = subl.subline_cd
                         AND par.assd_no = assr.assd_no
                         AND par.par_id = pol.par_id
                         AND DECODE (p_iss_cred,
                                     'C', NVL (pol.cred_branch, pol.iss_cd),
                                     pol.iss_cd
                                    ) =
                                NVL (p_iss_cd, 
                                     DECODE (p_iss_cred,
                                             'C', NVL (pol.cred_branch, pol.iss_cd),
                                             pol.iss_cd
                                            )
                                    )
                         AND check_user_per_iss_cd_acctg2(pol.line_cd, pol.iss_cd, 'GIACS153',p_user_id) = 1
--                         AND check_user_per_iss_cd2(pol.line_cd, pol.iss_cd, 'GIACS153', p_user_id) = 1
                    GROUP BY iss.iss_name,
                             intr.intm_name,
                             intr.intm_type,
                             lin.line_cd || '-' || lin.line_name,
                             subl.subline_cd || '-' || subl.subline_name,
                             assr.assd_name,
                             pol.incept_date,
                             pol.expiry_date,
                             (com.commission_amt * invo.currency_rt),
                             pol.endt_seq_no,
                             pol.line_cd,
                             pol.subline_cd,
                             pol.iss_cd,
                             pol.issue_yy,
                             pol.pol_seq_no,
                             pol.renew_no,
                             pol.endt_iss_cd,
                             pol.endt_yy,
                             (pol.tsi_amt),
                             (invo.prem_amt * invo.currency_rt * (com.share_percentage / 100)
                             ),
                             (invo.tax_amt * invo.currency_rt * (com.share_percentage / 100)),
                             (  (invo.prem_amt * invo.currency_rt * (com.share_percentage / 100)
                                )
                              + (invo.tax_amt * invo.currency_rt * (com.share_percentage / 100))
                             ),
                             pol.policy_id,
                             DECODE (p_iss_cred,
                                     'C', NVL (pol.cred_branch, pol.iss_cd),
                                     pol.iss_cd
                                    )
                      HAVING SUM (  (invo.prem_amt * invo.currency_rt)
                                  * (com.share_percentage / 100)
                                 ) <> 0
                                 
                    UNION
                    SELECT   iss.iss_name branch, intr.intm_name intermediary_name,
                             intr.intm_type "INTERMEDIARY_TYPE",
                             lin.line_cd || '-' || lin.line_name line,
                             subl.subline_cd || '-' || subl.subline_name subline,
                             assr.assd_name assured_name, pol.incept_date, pol.expiry_date,
                             (com.commission_amt * invo.currency_rt) commission, pol.endt_seq_no,
                             pol.line_cd, pol.subline_cd, pol.iss_cd, pol.issue_yy,
                             pol.pol_seq_no, pol.renew_no, pol.endt_iss_cd, pol.endt_yy,
                             (pol.tsi_amt) sum_insured,
                             (invo.prem_amt * invo.currency_rt * (com.share_percentage / 100)
                             ) premium_amt,
                             (invo.tax_amt * invo.currency_rt * (com.share_percentage / 100)
                             ) tax_amount,
                             (  (invo.prem_amt * invo.currency_rt * (com.share_percentage / 100)
                                )
                              + (invo.tax_amt * invo.currency_rt * (com.share_percentage / 100))
                             ) premium_receivable,
                             pol.policy_id,
                             DECODE (p_iss_cred,
                                     'C', NVL (pol.cred_branch, pol.iss_cd),
                                     pol.iss_cd
                                    )
                        FROM gipi_polbasic pol,
                             giis_intermediary intr,
                             giis_intm_type intm,
                             giis_line lin,
                             giis_subline subl,
                             gipi_invoice invo,
                             gipi_comm_invoice com,
                             giis_issource iss,
                             giis_assured assr,
                             gipi_parlist par
                       WHERE (   pol.acct_ent_date BETWEEN v_from
                                                       AND v_to
                              OR pol.spld_acct_ent_date BETWEEN v_from
                                                            AND v_to
                             )
                         AND com.intrmdry_intm_no = NVL (p_intm_no, com.intrmdry_intm_no)
                         AND intr.intm_type = NVL (p_intm_type, intr.intm_type)
                         AND pol.policy_id = invo.policy_id
                         AND pol.line_cd = lin.line_cd
                         AND pol.iss_cd = invo.iss_cd
                         AND pol.iss_cd = iss.iss_cd
                         AND pol.iss_cd = com.iss_cd
                         AND invo.iss_cd = com.iss_cd
                         AND invo.policy_id = com.policy_id
                         AND invo.prem_seq_no = com.prem_seq_no
                         AND com.intrmdry_intm_no = intr.intm_no
                         AND intr.intm_type = intm.intm_type
                         AND lin.line_cd = subl.line_cd
                         AND pol.subline_cd = subl.subline_cd
                         AND par.assd_no = assr.assd_no
                         AND par.par_id = pol.par_id
                         AND DECODE (p_iss_cred,
                                     'C', NVL (pol.cred_branch, pol.iss_cd),
                                     pol.iss_cd
                                    ) =
                                NVL (p_iss_cd,
                                     DECODE (p_iss_cred,
                                             'C', NVL (pol.cred_branch, pol.iss_cd),
                                             pol.iss_cd
                                            )
                                    )
                         AND check_user_per_iss_cd_acctg2 (pol.line_cd, pol.iss_cd, 'GIACS153', p_user_id) = 1
--                         AND check_user_per_iss_cd2(pol.line_cd, pol.iss_cd, 'GIACS153', p_user_id) = 1
                    GROUP BY iss.iss_name,
                             intr.intm_name,
                             intr.intm_type,
                             lin.line_cd || '-' || lin.line_name,
                             subl.subline_cd || '-' || subl.subline_name,
                             assr.assd_name,
                             pol.incept_date,
                             pol.expiry_date,
                             (com.commission_amt * invo.currency_rt),
                             pol.endt_seq_no,
                             pol.line_cd,
                             pol.subline_cd,
                             pol.iss_cd,
                             pol.issue_yy,
                             pol.pol_seq_no,
                             pol.renew_no,
                             pol.endt_iss_cd,
                             pol.endt_yy,
                             (pol.tsi_amt),
                             (invo.prem_amt * invo.currency_rt * (com.share_percentage / 100)
                             ),
                             (invo.tax_amt * invo.currency_rt * (com.share_percentage / 100)),
                             (  (invo.prem_amt * invo.currency_rt * (com.share_percentage / 100)
                                )
                              + (invo.tax_amt * invo.currency_rt * (com.share_percentage / 100))
                             ),
                             pol.policy_id,
                             DECODE (p_iss_cred,
                                     'C', NVL (pol.cred_branch, pol.iss_cd),
                                     pol.iss_cd
                                    )
                      HAVING SUM (  (invo.prem_amt * invo.currency_rt)
                                  * (com.share_percentage / 100)
                                 ) <> 0
                
    )
    LOOP
          v_rec.branch := i.branch;
          v_rec.intermediary_1 := i.intermediary_name;
          v_rec.intermediary_type := i.intermediary_type;
          v_rec.line := i.LINE;
          v_rec.subline := i.SUBLINE;
          v_rec.assured_name := i.assured_name;
          v_rec.incept_date := i.incept_date;
          v_rec.expiry_date := i.expiry_date;
          v_rec.commission := i.commission;
          v_rec.endt_seq_no := i.endt_seq_no;
          v_rec.line_cd := i.line_cd;
          v_rec.subline_cd := i.subline_cd;
          v_rec.iss_cd := i.ISS_CD;
          v_rec.issue_yy := i.issue_yy;
          v_rec.pol_seq_no := i.pol_seq_no;
          v_rec.renew_no := i.renew_no;
          v_rec.endt_iss_cd := i.endt_iss_cd;
          v_rec.endt_yy := i.endt_yy;
          v_rec.sum_insured := i.sum_insured;
          v_rec.premium_amt := i.premium_amt;
          v_rec.tax_amount := i.tax_amount;
          v_rec.premium_receivable := i.premium_receivable;
          v_rec.policy_id := i.policy_id;
          v_rec.iss_cd1 := i.iss_cd1;
          
          v_rec.as_of := 'For the Period '||to_char(v_from, 'fmMonth DD,YYYY')||' to '||to_char(v_to,'fmMonth DD,YYYY');
          v_rec.policy := get_policy_no(i.policy_id);
    PIPE ROW(v_rec);
    END LOOP;
    
    /*
    **Added by Pol cruz
    **to show the header even if there's no record to print
    **11.28.2013
    */    
    
    IF v_rec.branch IS NULL THEN
      v_rec.as_of := 'For the Period '||to_char(v_from, 'fmMonth DD,YYYY')||' to '||to_char(v_to,'fmMonth DD,YYYY');
      PIPE ROW(v_rec);
    END IF;
    
    END get_giacr217_record;

END;
/


