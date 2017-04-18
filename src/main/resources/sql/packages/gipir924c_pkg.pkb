CREATE OR REPLACE PACKAGE BODY CPI.GIPIR924C_PKG
AS
    
    /*
   **  Created by   :  Katrina May R. Verzosa
   **  Date Created : 05.09.2012
   **  Reference By : GIPIR924C - Underwriting Production Report
   **  Description  :
   */
    
     FUNCTION get_header_GIPIR924C (
          p_user_id   gipi_polbasic.user_id%TYPE
     )
        RETURN header_tab PIPELINED
      
     AS  rep      header_type;
   
     BEGIN
           rep.cf_company       :=      GIPIR924C_PKG.cf_co_nameFormula;       
           rep.cf_company_addrs :=      GIPIR924C_PKG.cf_co_addFormula;
           rep.cf_run_date      :=      GIPIR924C_PKG.cf_run_dateFormula;
                     
          PIPE ROW (rep); 
     RETURN;
     END;
      
          
     FUNCTION populate_GIPIR924C(
          p_direct       NUMBER,
          p_ri           NUMBER,
          p_iss_param    GIPI_POLBASIC.iss_cd%TYPE,
          p_iss_cd       GIPI_POLBASIC.iss_cd%TYPE,
          p_line_cd      GIPI_POLBASIC.line_cd%TYPE,
          p_user_id      GIIS_USERS.user_id%TYPE --marco - added parameter - 11.18.2013
    )
        RETURN report_tab PIPELINED
        
    AS  rep      report_type;
        
    BEGIN
                            
        FOR i IN
           (SELECT   c.dist_flag, 
                     r.rv_meaning, 
                     l.line_name, 
                     s.subline_name,
                     DECODE (
                        b.endt_seq_no,
                        0, b.line_cd || '-' || b.subline_cd || '-' || b.iss_cd || '-'
                           || LTRIM (TO_CHAR (b.issue_yy, '09')) || '-'
                           || LTRIM (TO_CHAR (b.pol_seq_no, '0999999')) || '-'
                           || LTRIM (TO_CHAR (b.renew_no, '09')),
                        b.line_cd || '-' || b.subline_cd || '-' || b.iss_cd || '-'
                        || LTRIM (TO_CHAR (b.issue_yy, '09')) || '-'
                        || LTRIM (TO_CHAR (b.pol_seq_no, '0999999')) || '-'
                        || LTRIM (TO_CHAR (b.renew_no, '09')) || '/' || b.endt_iss_cd || '-'
                        || LTRIM (TO_CHAR (b.endt_yy, '09')) || '-'
                        || LTRIM (TO_CHAR (b.endt_seq_no, '099999'))) pol_endrsmnt,
                     b.issue_date, 
                     b.incept_date, 
                     a.assd_name, 
                     b.tsi_amt, 
                     b.prem_amt,
                     b.policy_id
                     
           FROM      cg_ref_codes r,
                     giis_line l,
                     gipi_polbasic b,
                     giuw_pol_dist c,
                     giis_subline s,
                     giis_assured a,
                     gipi_parlist p
                 
           WHERE r.rv_low_value = b.dist_flag
             AND r.rv_low_value IN ('1', '2')
             AND c.dist_flag    IN ('1', '2')
             AND r.rv_domain    = 'GIPI_POLBASIC.DIST_FLAG'
        --    AND B.ISS_CD != 'RI'
             AND b.iss_cd IN (SELECT iss_cd
                                FROM giis_issource
                               WHERE (   (    iss_cd   = giacp.v ('REINSURER')
                                          AND p_direct <> 1
                                          AND p_ri     = 1)
                                      OR (    iss_cd   <> giacp.v ('REINSURER')
                                          AND p_direct = 1
                                          AND p_ri     <> 1)
                                      OR (1 = 1 AND p_direct = 1 AND p_ri = 1)))
             AND l.line_cd    = b.line_cd
             AND b.policy_id  = c.policy_id
             AND s.subline_cd = b.subline_cd
             AND DECODE (p_iss_param,1,b.cred_branch,b.iss_cd) = 
                          NVL (p_iss_cd, DECODE (p_iss_param,1,b.cred_branch,b.iss_cd))
             AND s.line_cd    = l.line_cd
             AND a.assd_no    = b.assd_no
             AND p.par_id     = b.par_id
             AND b.pol_flag   <> '5'
             AND NVL (b.endt_type, 0) <> 'N'
        --    AND b.subline_cd <> 'MOP'
             AND s.op_flag    <>'Y'
        --    AND b.acct_ent_date IS NULL
             AND p.line_cd    = NVL (p_line_cd, p.line_cd)
             AND b.policy_id  > 0
             AND check_user_per_iss_cd2(b.line_cd, DECODE(p_iss_param,1,b.cred_branch, b.iss_cd), 'GIPIS901A', p_user_id) = 1 --marco - added security - 11.18.2013
             AND check_user_per_line2(b.line_cd, DECODE(p_iss_param,1, b.cred_branch, b.iss_cd), 'GIPIS901A', p_user_id) = 1  --
           ORDER BY b.iss_cd, 
                    b.issue_yy, 
                    b.pol_seq_no, 
                    b.renew_no
           )

                LOOP
                    rep.dist_flag       :=       i.dist_flag;
                    rep.rv_meaning      :=       i.rv_meaning;
                    rep.line_name       :=       i.line_name;
                    rep.subline_name    :=       i.subline_name;
                    rep.pol_endrsmnt    :=       i.pol_endrsmnt;              
                    rep.issue_date      :=       i.issue_date;
                    rep.incept_date     :=       i.incept_date;
                    rep.assd_name       :=       i.assd_name;
                    rep.tsi_amt         :=       i.tsi_amt;
                    rep.prem_amt        :=       i.prem_amt;
                    rep.policy_id       :=       i.policy_id;
                    rep.existing        :=       GIPIR924C_PKG.exist(rep.policy_id);
                    
                    
                PIPE ROW (rep);
                END LOOP;

    RETURN;
    END populate_GIPIR924C;

    
    FUNCTION cf_co_nameFormula
       RETURN CHAR
    IS  
       v_comp_name   GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;   
    
    BEGIN
        FOR CF_CO_NAME IN (SELECT PARAM_VALUE_V
                            FROM GIIS_PARAMETERS
                             WHERE PARAM_NAME = 'COMPANY_NAME') 
              
            LOOP
              v_comp_name    :=     CF_CO_NAME.PARAM_VALUE_V;
            END LOOP;
  
    RETURN(v_comp_name);
    END cf_co_nameFormula;


    FUNCTION cf_co_addFormula
       RETURN CHAR
    IS
       v_comp_add    VARCHAR2(200);
    
    BEGIN
        FOR CF_CO_ADD IN (SELECT PARAM_VALUE_V
                           FROM GIAC_PARAMETERS
                            WHERE PARAM_NAME = 'COMPANY_ADDRESS') 
           LOOP
              v_comp_add    :=      CF_CO_ADD.PARAM_VALUE_V;
           END LOOP;
  
    
        RETURN (v_comp_add);
    END cf_co_addFormula;
    
          
    FUNCTION cf_run_dateFormula
        RETURN CHAR
    IS
    BEGIN
        RETURN ('As of '||TO_CHAR(SYSDATE, 'fmMONTH DD, YYYY')); 
    END cf_run_dateFormula;
    
    
    --evaluate if policy has a collection
    FUNCTION exist(p_policy_id  GIPI_POLBASIC.policy_id%TYPE)
        RETURN VARCHAR2
    IS
        v_exists   VARCHAR2(1) := 'N';
    BEGIN
        FOR a IN (
          SELECT '1'
          FROM giac_direct_prem_collns a,
               giac_acctrans b,
               gipi_invoice c
          WHERE a.gacc_tran_id    = b.tran_id
           AND b.tran_flag        <> 'D'
           AND a.b140_prem_seq_no = c.prem_seq_no
           AND a.b140_iss_cd      = c.iss_cd
           AND c.policy_id        = p_policy_id
           AND NOT EXISTS (SELECT '2'
                             FROM giac_reversals x,
                                      giac_acctrans y
                              WHERE x.reversing_tran_id =   y.tran_id
                                AND y.tran_flag         <> 'D'
                                AND x.gacc_tran_id      =   a.gacc_tran_id))

                LOOP
                    v_exists := 'Y';
                END LOOP;
    RETURN (v_exists);
	END exist;

END GIPIR924C_PKG;
/


