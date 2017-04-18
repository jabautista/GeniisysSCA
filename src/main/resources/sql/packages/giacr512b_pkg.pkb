CREATE OR REPLACE PACKAGE BODY CPI.GIACR512B_PKG
AS
 /*
    **  Created by   :  Melvin John O. Ostia
    **  Date Created : 07.03.2013
    **  Reference By : GIACR512B_PKG - LOSSES PAID
    */
    FUNCTION get_giacr512b_recordperil(
    P_BRANCH_CD     VARCHAR2,
    P_TRAN_YEAR     VARCHAR2,
    P_INTM_NO       NUMBER,
    P_USER_ID       giis_users.user_id%TYPE
    )  
    RETURN giacr512b_record_tab PIPELINED
    IS
        v_list giacr512b_record_type;
    BEGIN
    FOR i IN (
                SELECT NVL(a.parent_intm_no,a.intm_no) intermediary_no, a.line_cd, a.peril_cd, SUM(NVL(paid_amt,0)) paid_amt_sum, SUM(NVL(facul_shr,0)) facul_shr_sum
                FROM giac_cpc_clm_paid_dtl a, gicl_claims b, giac_chk_disbursement c
                WHERE tran_year = p_tran_year
                AND a.claim_id = b.claim_id
                AND a.tran_id = c.gacc_tran_id
                AND a.user_id = p_user_id 
                AND a.intm_no = p_intm_no
                GROUP BY NVL(a.parent_intm_no,a.intm_no), a.line_cd, a.peril_cd
                ORDER BY NVL(a.parent_intm_no,a.intm_no), a.line_cd, a.peril_cd    
             )
             
    LOOP
        v_list.peril_intermediary_no := i.intermediary_no;
        v_list.peril_line_cd := i.line_cd;
        v_list.peril_peril_cd := i.peril_cd;
        v_list.peril_paid_amt_sum := i.paid_amt_sum;
        v_list.peril_facul_shr_sum := i.facul_shr_sum;
        
        FOR a IN (SELECT peril_name
                        FROM giis_peril
                        WHERE line_cd = i.line_cd
                        AND peril_cd = i.peril_cd) 
        LOOP
           v_list.peril_peril_name := a.peril_name;
        END LOOP;	 
        
        PIPE ROW(v_list);
    END LOOP;
    
    END get_giacr512b_recordperil;
    FUNCTION get_giacr512b_recordSUB(
    P_BRANCH_CD     VARCHAR2,
    P_TRAN_YEAR     VARCHAR2,
    P_INTM_NO       NUMBER,
    P_USER_ID       giis_users.user_id%TYPE
    )
    RETURN giacr512b_record_tab PIPELINED
    IS
        v_list giacr512b_record_type;
    BEGIN
    FOR i IN (
                SELECT a.parent_intm_no,
                           a.intm_no,
                           b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||ltrim(to_char(b.clm_yy,'09'))||'-'||ltrim(to_char(b.clm_seq_no,'099999')) claim_no, 
                           b.line_cd||'-'||b.subline_cd||'-'||b.pol_iss_cd||'-'||ltrim(to_char(b.issue_yy,'09'))||'-'||ltrim(to_char(b.pol_seq_no,'099999'))||'-'||ltrim(to_char(b.renew_no,'09')) policy_no,
                           b.clm_file_date,
                           b.pol_eff_date,
                           b.dsp_loss_date,
                           b.assd_no,
                           b.loss_cat_cd,
                           paid_amt,
                           a.line_cd, peril_cd, facul_shr,
                           nvl(c.check_pref_suf,'-----')||'-'||nvl(to_char(c.check_no),'-----') check_no,
                           nvl(to_char(c.check_date,'MM-DD-RRRR'),'-------------') check_date
                FROM giac_cpc_clm_paid_dtl a, gicl_claims b, giac_chk_disbursement c
                WHERE a.claim_id = b.claim_id
                   AND a.parent_intm_no != a.intm_no
                   AND a.tran_id = c.gacc_tran_id
                   AND a.user_id = p_user_id
               ORDER BY b.line_cd, claim_no   
             )
    LOOP
        v_list.sub_parent_intm_no := i.parent_intm_no;
        v_list.sub_intm_no := i.intm_no;
        v_list.sub_claim_no := i.claim_no;
        v_list.sub_policy_no := i.policy_no;
        v_list.sub_clm_file_date := i.clm_file_date;
        v_list.sub_pol_eff_date := i.pol_eff_date;
        v_list.sub_dsp_loss_date := i.dsp_loss_date;
        v_list.sub_assd_no := i.assd_no;
        v_list.sub_loss_cat_cd := i.loss_cat_cd;
        v_list.sub_paid_amt := i.paid_amt;
        v_list.sub_line_cd := i.line_cd;
        v_list.sub_peril_cd := i.peril_cd;
        v_list.sub_facul_shr := i.facul_shr;
        v_list.sub_check_no := i.check_no;
        v_list.sub_check_date := i.check_date;
    
    
          FOR a IN(SELECT intm_name 
  					 FROM giis_intermediary
  					WHERE i.intm_no = intm_no)
          LOOP
            v_list.sub_intm_name := a.intm_name;
          END LOOP;
          
          FOR a IN(SELECT assd_name 
  					 FROM giis_assured
  					WHERE i.assd_no = assd_no)
          LOOP
            v_list.sub_assd_name := a.assd_name;
          END LOOP;
          
          FOR a IN(SELECT loss_cat_des 
  					 FROM giis_loss_ctgry
  					WHERE i.loss_cat_cd = loss_cat_cd)
          LOOP
            v_list.sub_net_loss := a.loss_cat_des;
          END LOOP;    
          
          FOR a IN (SELECT peril_name
                       FROM giis_peril
                      WHERE line_cd = i.line_cd
                        AND peril_cd = i.peril_cd) 
          LOOP
            v_list.sub_peril_name := a.peril_name;
          END LOOP;	 
          
          v_list.sub_net_paid_amt := nvl(i.paid_amt,0.00) - nvl(i.facul_shr,0.00);
          
    PIPE ROW(v_list);
    END LOOP;
    END get_giacr512b_recordSUB;
    
    FUNCTION get_giacr512b_record(
    P_BRANCH_CD     VARCHAR2,
    P_TRAN_YEAR     VARCHAR2,
    P_INTM_NO       NUMBER,
    P_USER_ID       giis_users.user_id%TYPE
    )
    
    RETURN giacr512b_record_tab PIPELINED
    IS
        v_list giacr512b_record_type;
    BEGIN
    FOR i IN (
                SELECT a.parent_intm_no,
                           a.intm_no,
                           b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||ltrim(to_char(b.clm_yy,'09'))||'-'||ltrim(to_char(b.clm_seq_no,'0999999')) claim_no, 
                           b.line_cd||'-'||b.subline_cd||'-'||b.pol_iss_cd||'-'||ltrim(to_char(b.issue_yy,'09'))||'-'||ltrim(to_char(b.pol_seq_no,'0999999'))||'-'||ltrim(to_char(b.renew_no,'09')) policy_no,
                           b.clm_file_date,
                           b.pol_eff_date,
                           b.dsp_loss_date,
                           b.assd_no,
                           b.loss_cat_cd,
                           paid_amt,
                           a.line_cd, 
                           a.peril_cd, a.facul_shr,
                           nvl(c.check_pref_suf,'-----')||'-'||nvl(to_char(c.check_no),'-----') check_no,
                           nvl(to_char(c.check_date,'MM-DD-RRRR'),'-------------') check_date
               FROM giac_cpc_clm_paid_dtl a, gicl_claims b, giac_chk_disbursement c
               WHERE tran_year = p_tran_year
                           and a.claim_id = b.claim_id
                           and a.parent_intm_no = a.intm_no
                           and a.tran_id = c.gacc_tran_id
                           and a.parent_intm_no = NVL(p_intm_no,a.parent_intm_no)
                           and a.user_id = p_user_id
               ORDER BY b.line_cd, claim_no 
             )
    LOOP 
        v_list.parent_intm_no := i.parent_intm_no;
        v_list.intm_no := i.intm_no;
        v_list.claim_no := i.claim_no;
        v_list.policy_no := i.policy_no;
        v_list.clm_file_date := i.clm_file_date;
        v_list.pol_eff_date := i.pol_eff_date;
        v_list.dsp_loss_date := i.dsp_loss_date;
        v_list.assd_no := i.assd_no;
        v_list.loss_cat_cd := i.loss_cat_cd;
        v_list.paid_amt := i.paid_amt;
        v_list.line_cd := i.line_cd;
        v_list.peril_cd := i.peril_cd;
        v_list.facul_shr := i.facul_shr;
        v_list.check_no := i.check_no;
        v_list.check_date := i.check_date;
        
        	FOR a IN (SELECT giacp.v('COMPANY_NAME') v_company_name
  						FROM dual)
            LOOP
              v_list.company_name := a.v_company_name;
            END LOOP;
            
            FOR a IN (SELECT giacp.v('COMPANY_ADDRESS') v_company_name
  						FROM dual)
            LOOP
              v_list.company_add := a.v_company_name;
            END LOOP;
            
            FOR a IN(SELECT intm_name 
  					 FROM giis_intermediary
  					WHERE i.parent_intm_no = intm_no)
            LOOP
              v_list.intm_name := nvl(a.intm_name,'none');
            END LOOP;
            
            FOR a IN(SELECT assd_name 
  					 FROM giis_assured 
  					WHERE i.assd_no = assd_no)
            LOOP
              v_list.assd_name := a.assd_name;
            END LOOP;
            
            FOR a IN(SELECT loss_cat_des 
  					 FROM giis_loss_ctgry
  					WHERE i.loss_cat_cd = loss_cat_cd
  					  AND i.line_cd = line_cd)
            LOOP
                v_list.nature_of_loss := a.loss_cat_des;
            END LOOP;
            
            FOR a IN (SELECT peril_name
                       FROM giis_peril
                      WHERE line_cd = i.line_cd
                        AND peril_cd = i.peril_cd) 
            LOOP
              v_list.peril_name := a.peril_name;
            END LOOP;	 
            
            v_list.net_paid_amt := nvl(i.paid_amt,0.00) - nvl(i.facul_shr,0.00);
            
    PIPE ROW(v_list);
    END LOOP;
    
    END get_giacr512b_record;
    
END;
/


