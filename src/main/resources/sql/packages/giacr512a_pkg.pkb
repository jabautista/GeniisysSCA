CREATE OR REPLACE PACKAGE BODY CPI.GIACR512A_PKG
AS
/*
    **  Created by   :  Melvin John O. Ostia
    **  Date Created : 07.02.2013
    **  Reference By : GIACR512A_PKG - OUTSTANDING LOSS
    */
    FUNCTION cf_company_addformula
       RETURN CHAR
    IS
       v_company_name   giis_parameters.param_value_v%TYPE;
    BEGIN
       FOR rec IN (SELECT giacp.v ('COMPANY_ADDRESS') v_company_name
                     FROM DUAL)
       LOOP
          v_company_name := rec.v_company_name;
       END LOOP;

       RETURN (v_company_name);
    END;
    FUNCTION cf_company_nameformula
       RETURN CHAR
    IS
       v_company_name   giis_parameters.param_value_v%TYPE;
    BEGIN
       FOR rec IN (SELECT giacp.v ('COMPANY_NAME') v_company_name
                     FROM DUAL)
       LOOP
          v_company_name := rec.v_company_name;
       END LOOP;

       RETURN (v_company_name);
    END;
    FUNCTION giacr512A_subagent(
    P_BRANCH_CD     VARCHAR2,
    P_TRAN_YEAR     VARCHAR2,
    P_INTM_NO       NUMBER,
    P_USER_ID       giis_users.user_id%TYPE
    )
    RETURN giacr512A_record_tab PIPELINED
    IS
        v_list giacr512A_record_type;
    BEGIN
    FOR i IN (
                    SELECT a.parent_intm_no,
                           a.intm_no, 
                           b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||ltrim(to_char(b.clm_yy,'09'))||'-'||ltrim(to_char(b.clm_seq_no,'099999')) claim_no, 
                           b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||ltrim(to_char(b.issue_yy,'09'))||'-'||ltrim(to_char(b.pol_seq_no,'099999'))||'-'||ltrim(to_char(b.renew_no,'09')) policy_no,
                           b.clm_file_date,
                           b.pol_eff_date,
                           b.dsp_loss_date,
                           b.assd_no,
                           b.loss_cat_cd,
                           c.peril_name,
                    SUM(os_amt) os_amt, a.peril_cd, a.line_cd, sum(facul_shr) facul_shr
                    FROM giac_cpc_os_dtl a, gicl_claims b, giis_peril c
                         WHERE a.claim_id = b.claim_id
                         AND a.parent_intm_no != a.intm_no
                         AND a.tran_year = p_tran_year
                         AND a.line_cd = c.line_cd
                         AND a.peril_cd = c.peril_cd
                         AND a.parent_intm_no = nvl(p_intm_no, a.parent_intm_no) 
                         and check_user_per_iss_cd_acctg2(b.line_cd, b.iss_cd, 'GIACS512',p_user_id)=1 
                    GROUP BY a.parent_intm_no,
                           a.intm_no, 
                           b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||ltrim(to_char(b.clm_yy,'09'))||'-'||ltrim(to_char(b.clm_seq_no,'099999')), 
                           b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||ltrim(to_char(b.issue_yy,'09'))||'-'||ltrim(to_char(b.pol_seq_no,'099999'))||'-'||ltrim(to_char(b.renew_no,'09')),
                           b.clm_file_date,
                           b.pol_eff_date,
                           b.dsp_loss_date,
                           b.assd_no,
                           b.loss_cat_cd, 
                           c.peril_name, 
                            a.peril_cd, 
                           a.line_cd 
                    ORDER BY 3,  a.line_cd
    
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
        v_list.sub_peril_name := i.peril_name;
        v_list.sub_os_amt := i.os_amt;
        v_list.sub_facul_shr := i.facul_shr;
        v_list.sub_peril_cd := i.peril_cd;
        v_list.sub_line_cd := i.line_cd;
        
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
            v_list.sub_nature_of_loss := a.loss_cat_des;
          END LOOP;
          
          FOR a IN(SELECT peril_name 
  					 FROM giis_peril
  					WHERE line_cd = i.line_cd 
  					AND  peril_cd = i.peril_cd )
          LOOP
            v_list.sub_peril_name_main := a.peril_name;
          END LOOP;
          
          v_list.sub_net_loss := i.os_amt - i.facul_shr;
          
        PIPE ROW(v_list);
    END LOOP;
    END giacr512A_subagent;
    FUNCTION giacr512A_perilbreakdown(
    P_BRANCH_CD     VARCHAR2,
    P_TRAN_YEAR     VARCHAR2,
    P_INTM_NO       NUMBER,
    P_USER_ID       giis_users.user_id%TYPE
    )
    RETURN giacr512a_record_tab PIPELINED
    IS 
        v_list giacr512A_record_type;
    BEGIN
    FOR i IN (
            SELECT a.parent_intm_no,
                   c.peril_name, a.peril_cd,
                   sum(os_amt) os_amt, 
                   sum(facul_shr) facul_shr
                FROM giac_cpc_os_dtl a, gicl_claims b, giis_peril c
                WHERE tran_year = p_tran_year
                    and b.claim_id = a.claim_id
                    and a.line_cd = c.line_cd
                    and a.peril_cd = c.peril_cd
                     AND a.parent_intm_no = nvl(p_intm_no, a.parent_intm_no) 
                     AND check_user_per_iss_cd_acctg2(b.line_cd, b.iss_cd, 'GIACS512',p_user_id)=1
            GROUP BY a.parent_intm_no,
                 c.peril_name, 
                  a.peril_cd)
    LOOP
        v_list.pb_parent_intm_no := i.parent_intm_no;
        v_list.pb_peril_name := i.peril_name;
        v_list.pb_peril_cd := i.peril_cd;
        v_list.pb_os_amt := i.os_amt;
        v_list.pb_facul_shr := i.facul_shr;
        

          
        PIPE ROW(v_list);
    END LOOP;
    END giacr512A_perilbreakdown;
    FUNCTION get_giacr512A_record(
    P_BRANCH_CD     VARCHAR2,
    P_TRAN_YEAR     VARCHAR2,
    P_INTM_NO       NUMBER,
    P_USER_ID       giis_users.user_id%TYPE
    )
    RETURN giacr512A_record_tab PIPELINED
    IS
        v_list  giacr512A_record_type;
    BEGIN   
        FOR i IN (  SELECT a.parent_intm_no,
                           a.intm_no,
                           b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||ltrim(to_char(b.clm_yy,'09'))||'-'||ltrim(to_char(b.clm_seq_no,'099999')) claim_no, 
                           b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||ltrim(to_char(b.issue_yy,'09'))||'-'||ltrim(to_char(b.pol_seq_no,'099999'))||'-'||ltrim(to_char(b.renew_no,'09')) policy_no,
                           b.clm_file_date,
                           b.pol_eff_date,
                           b.dsp_loss_date,
                           b.assd_no,
                           b.loss_cat_cd,
                           c.peril_name,
                           sum(os_amt) os_amt, 
                           sum(facul_shr) facul_shr, 
                           a.peril_cd, 
                           a.line_cd
                      FROM giac_cpc_os_dtl a, gicl_claims b, giis_peril c
                     WHERE tran_year = p_tran_year
                       AND a.claim_id = b.claim_id
                       AND a.parent_intm_no = a.intm_no
                       AND a.parent_intm_no = nvl(p_intm_no, a.parent_intm_no)
                       AND a.line_cd = c.line_cd
                       AND a.peril_cd = c.peril_cd 
                       AND check_user_per_iss_cd_acctg2(b.line_cd, b.iss_cd, 'GIACS512',p_user_id)=1 --added by Jongs 03.20.2013                                         
                     GROUP BY a.parent_intm_no,
                           a.intm_no, 
                           b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||ltrim(to_char(b.clm_yy,'09'))||'-'||ltrim(to_char(b.clm_seq_no,'099999')), 
                           b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||ltrim(to_char(b.issue_yy,'09'))||'-'||ltrim(to_char(b.pol_seq_no,'099999'))||'-'||ltrim(to_char(b.renew_no,'09')),
                           b.clm_file_date,
                           b.pol_eff_date,
                           b.dsp_loss_date,
                           b.assd_no,
                           b.loss_cat_cd, 
                           c.peril_name, 
                           a.peril_cd, 
                           a.line_cd 
                     ORDER BY 3, a.line_cd )
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
            v_list.peril_name := i.peril_name;
            v_list.os_amt := i.os_amt;
            v_list.facul_shr := i.facul_shr;
            v_list.peril_cd := i.peril_cd;
            v_list.line_cd := i.line_cd;
            v_list.company_name := cf_company_nameformula;
            v_list.company_add  := cf_company_addformula;
           -- v_list.assd_name := cf_assd_nameformula;
            
             FOR a IN(SELECT intm_name 
                         FROM giis_intermediary
                        WHERE i.parent_intm_no = intm_no)
             LOOP
                v_list.intm_name := a.intm_name;
             END LOOP;
            
             FOR a IN(SELECT loss_cat_des 
                        FROM giis_loss_ctgry
                       WHERE i.loss_cat_cd = loss_cat_cd
                         AND i.line_cd = line_cd)
      					 
             LOOP
               v_list.nature_of_loss := a.loss_cat_des;
             END LOOP;
             
             FOR a IN(SELECT peril_name 
                        FROM giis_peril
                       WHERE i.line_cd = line_cd
                         AND i.peril_cd = peril_cd)
      		 LOOP
                 v_list.peril_name_main := a.peril_name;
             END LOOP;
             
             v_list.net_loss := i.os_amt - i.facul_shr;
             
             FOR a IN(SELECT intm_name 
                        FROM giis_intermediary
                       WHERE i.parent_intm_no = intm_no)
             LOOP
                v_list.parent_intm := a.intm_name;
             END LOOP;
            
             FOR a IN(SELECT assd_name
                        FROM giis_assured
                       WHERE i.assd_no = assd_no)
             LOOP
                v_list.assd_name := a.assd_name;
             END LOOP; 
        
             PIPE ROW(v_list);
        END LOOP;
         
    END get_giacr512A_record;
END;
/


