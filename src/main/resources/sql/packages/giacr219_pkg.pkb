CREATE OR REPLACE PACKAGE BODY CPI.GIACR219_pkg
AS
 /*
    **  Created by   :  Melvin John O. Ostia
    **  Date Created : 07.025.2013
    **  Reference By : GIACR219_PKG - PRODUCTION REGISTER PER INTERMEDIARY (SUMMARY)
    */
    FUNCTION get_giacr219_record(
    p_from_acct_ent_date VARCHAR2,
    p_to_acct_ent_date   VARCHAR2,
    p_intm_no   NUMBER,
    p_intm_type VARCHAR2,
    p_iss_cred  VARCHAR2,
    p_iss_cd VARCHAR2,
    p_user_id VARCHAR2
    )
    RETURN 
        giacr219_tab PIPELINED
    AS
        v_rec giacr219_type;
        v_from DATE := TO_DATE(p_from_acct_ent_date, 'MM/DD/RRRR');
        v_to   DATE := TO_DATE(p_to_acct_ent_date, 'MM/DD/RRRR');
    BEGIN
      select 	param_value_v
      into		v_rec.cname
      from		giis_parameters
      where		param_name = 'COMPANY_NAME';
      
     select	param_value_v
      into		v_rec.cadd
      from		giis_parameters
      where		param_name = 'COMPANY_ADDRESS';
      
    FOR i IN (
                SELECT   intm.intm_desc "C_IN_TYPE",
                         iss.iss_name "C_ISS_NAME", INITCAP (intr.intm_name) "C_INTM_NAME",
                         intr.intm_type "INTERMEDIARY_TYPE",
                         lin.line_cd || '-' || lin.line_name "C_LINE",
                         subl.subline_cd || '-' || subl.subline_name "C_SUBLINE",
                         assr.assd_name assured_name, pol.acct_ent_date "C_DATE", pol.spld_acct_ent_date "C_SDATE",
                         SUM(com.commission_amt *invo.currency_rt) "C_COMM", pol.endt_seq_no,
                         pol.line_cd, pol.subline_cd, pol.iss_cd "C_ISS_CD", pol.issue_yy,
                         pol.pol_seq_no, pol.renew_no, pol.endt_iss_cd, pol.endt_yy,
                         SUM (pol.tsi_amt) "C_TOTAL_INS",
                         SUM((invo.prem_amt * invo.currency_rt) *   (com.share_percentage/100)) "C_PREM",
                         SUM(invo.tax_amt * invo.currency_rt *   (com.share_percentage/100)) "C_TAX",
                         SUM (  (invo.prem_amt * invo.currency_rt * (com.share_percentage / 100)
                            )
                          + (invo.tax_amt * invo.currency_rt * (com.share_percentage / 100))
                         ) premium_receivable,
                         pol.policy_id,
                         DECODE (p_iss_cred,
                                 'C', NVL (pol.cred_branch, pol.iss_cd),
                                 pol.iss_cd
                                ) iss_cd
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
                     --AND check_user_per_iss_cd_acctg2 (pol.line_cd, pol.iss_cd, 'GIACS153', p_user_id) = 1    -- replace by code below : shan 09.03.2014
                     AND ((SELECT access_tag
                             FROM giis_user_modules
                            WHERE userid = NVL (p_user_id, USER)
                              AND module_id = 'GIACS153'
                              AND tran_cd IN (SELECT b.tran_cd 
                                                FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                               WHERE a.user_id = b.userid
                                                 AND a.user_id = NVL (p_user_id, USER)
                                                 AND b.iss_cd = pol.iss_cd
                                                 AND b.tran_cd = c.tran_cd
                                                 AND c.module_id = 'GIACS153')) = 1
                            OR 
                            (SELECT access_tag
                               FROM giis_user_grp_modules
                              WHERE module_id = 'GIACS153'
                                AND (user_grp, tran_cd) IN ( SELECT a.user_grp, b.tran_cd
                                                               FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                                              WHERE a.user_grp = b.user_grp
                                                                AND a.user_id = NVL (p_user_id, USER)
                                                                AND b.iss_cd = pol.iss_cd
                                                                AND b.tran_cd = c.tran_cd
                                                                AND c.module_id = 'GIACS153')) = 1)
                GROUP BY intm.intm_desc,
                         iss.iss_name, INITCAP (intr.intm_name),
                         intr.intm_type,
                         lin.line_cd || '-' || lin.line_name,
                         subl.subline_cd || '-' || subl.subline_name,
                         assr.assd_name, pol.acct_ent_date, pol.spld_acct_ent_date,
                         (com.commission_amt * invo.currency_rt), pol.endt_seq_no,
                         pol.line_cd, pol.subline_cd, pol.iss_cd, pol.issue_yy,
                         pol.pol_seq_no, pol.renew_no, pol.endt_iss_cd, pol.endt_yy,
                         (pol.tsi_amt),
                         (invo.prem_amt * invo.currency_rt * (com.share_percentage / 100)
                         ),
                         (invo.tax_amt * invo.currency_rt * (com.share_percentage / 100)
                         ),
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
                             order by c_date,INTERMEDIARY_TYPE
                            
    )
    LOOP
          v_rec.c_in_type := i.C_IN_TYPE;
          v_rec.c_iss_name := i.C_ISS_NAME;
          v_rec.c_intm_name := i.C_INTM_NAME;
          v_rec.intermediary_type := i.INTERMEDIARY_TYPE;
          v_rec.c_line := i.C_LINE;
          v_rec.c_subline := i.C_SUBLINE;
          v_rec.assured_name := i.assured_name;
          v_rec.c_date := i.c_date;
          v_rec.c_sdate := i.c_sdate;
          v_rec.c_comm := i.c_comm;
          v_rec.endt_seq_no := i.endt_seq_no;
          v_rec.line_cd := i.line_cd;
          v_rec.subline_cd := i.subline_cd;
          v_rec.c_iss_cd := i.C_ISS_CD;
          v_rec.issue_yy := i.issue_yy;
          v_rec.pol_seq_no := i.pol_seq_no;
          v_rec.renew_no := i.renew_no;
          v_rec.endt_iss_cd := i.endt_iss_cd;
          v_rec.endt_yy := i.endt_yy;
          v_rec.c_total_ins := i.C_TOTAL_INS;
          v_rec.c_prem := i.C_PREM;
          v_rec.c_tax := i.C_TAX;
          v_rec.premium_receivable := i.premium_receivable;
          v_rec.policy_id := i.policy_id;
          v_rec.iss_cd := i.iss_cd;
                           
          
            if i.C_sdate BETWEEN v_from AND v_to then 
                v_rec.ret_num := (i.C_Total_Ins) * -1;
              else
                v_rec.ret_num := i.c_total_ins;
              end if;     
              
            if i.c_sdate BETWEEN v_from AND v_to then
            v_rec.prems := (nvl(i.C_PREM,0) + nvl(i.C_TAX,0)) * -1;
            else
            v_rec.prems := nvl(i.C_PREM,0) + nvl(i.C_TAX,0);
            end if;
            
      	    if i.c_sdate BETWEEN v_from AND v_to then
            v_rec.prem_amt := i.c_prem * -1;
            else
            v_rec.prem_amt := i.c_prem;
            end if;  
            
     	    if i.c_sdate BETWEEN v_from AND v_to then
            v_rec.tax := i.c_tax * -1;
            else
            v_rec.tax := i.c_tax;
            end if;      
          
            if i.c_sdate BETWEEN v_from AND v_to then
            v_rec.comm := i.c_comm * -1;
            else
            v_rec.comm := i.c_comm;
            end if;
            
            v_rec.final_date := 'For the Period '||to_char(v_from, 'fmMonth DD, YYYY')||' to '||
                                     to_char(v_to, 'fmMonth DD, YYYY');
    PIPE ROW(v_rec);
    END LOOP;
    
    /*
    **Added by Pol cruz
    **to show the header even if there's no record to print
    **11.28.2013
    */    
    
    IF v_rec.c_in_type IS NULL THEN
      v_rec.final_date := 'For the Period '||to_char(v_from, 'fmMonth DD, YYYY')||' to '||
                                     to_char(v_to, 'fmMonth DD, YYYY');
      PIPE ROW(v_rec);
    END IF;
    
    
    END get_giacr219_record;
END;
/


