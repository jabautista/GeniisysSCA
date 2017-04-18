CREATE OR REPLACE PACKAGE BODY CPI.GIPIR923F_PKG 
AS
 /*
   **  Created by   :  PJ DIAZ
   ** Date Created : 05.08.2012
   */
   
   FUNCTION get_header_gipir923f (
      p_scope     gipi_uwreports_ext.SCOPE%TYPE,
      p_user_id   gipi_uwreports_ext.user_id%TYPE -- marco - 02.05.2013 - added parameter     
   )
      RETURN header_tab PIPELINED
   AS
      rep   header_type;
   BEGIN
      rep.cf_company         := gipir923f_pkg.cf_companyformula;
      rep.cf_company_address := gipir923f_pkg.cf_company_addressformula;
      rep.cf_based_on        := gipir923f_pkg.cf_based_onformula(p_scope, p_user_id);
      rep.cf_heading3        := gipir923f_pkg.cf_heading3Formula(p_user_id);
          
      PIPE ROW (rep);
   END;
    FUNCTION populate_gipir923f (
         p_line_cd        gipi_uwreports_ext.line_cd%TYPE,
         p_scope          gipi_uwreports_ext.scope%TYPE,
         p_iss_cd         gipi_uwreports_ext.iss_cd%TYPE,
         p_subline_cd     gipi_uwreports_ext.subline_cd%TYPE,
       --p_from_date      gipi_uwreports_ext.from_date%TYPE,
       --p_to_date        gipi_uwreports_ext.to_date%TYPE,
         p_iss_param      gipi_uwreports_ext.iss_cd%TYPE,
         p_user_id        gipi_uwreports_ext.user_id%TYPE -- marco - 02.05.2013 - added parameter
    )
         RETURN gipir923f_tab PIPELINED
     IS
     v_gipir923f         gipir923f_type;
     BEGIN
        FOR i IN (SELECT TO_NUMBER(NVL(TO_CHAR(acct_ent_date,'MM'),'13')) acctg_seq,
                                   NVL(to_char(acct_ent_date,'FmMonth, RRRR'),'NOT TAKEN UP') acct_ent_date,  
                                   line_cd, subline_cd, iss_cd,decode (p_iss_param,1,cred_branch,iss_cd) iss_cd_head,
                                   issue_yy, pol_seq_no, renew_no,
                                   endt_iss_cd, endt_yy, endt_seq_no,get_policy_no(policy_id) policy_no,
                                   issue_date, incept_date, expiry_date,  total_tsi,
                                   lgt, doc_stamps,            
                                   total_prem,  evatprem,
                                   fst,  other_taxes,           
                                   (total_prem + evatprem + lgt + doc_stamps + fst + other_taxes) total_charges,
                                   param_date, from_date, to_date, scope, 
                                   user_id, policy_id,assd_no, spld_date
                              FROM gipi_uwreports_ext
                             WHERE user_id = p_user_id -- marco - 02.05.2013 - changed from USER
                               AND decode (p_iss_param,1,cred_branch,iss_cd) = 
                                      NVL (p_iss_cd, 
                                          decode (p_iss_param,
                                                  1,cred_branch,
                                                  iss_cd
                                                  )
                                           )  
                               AND line_cd =NVL (p_line_cd, line_cd)
                               AND subline_cd =NVL (p_subline_cd, subline_cd)
                               AND (   (p_scope=5 AND endt_seq_no=endt_seq_no)
                                    OR (p_scope=1 AND endt_seq_no=0)
                                    OR (p_scope=2 AND endt_seq_no>0)
                                    OR (p_scope=4 AND pol_flag='5')
                                   )
           UNION
                  SELECT TO_NUMBER(NVL(to_char(spld_acct_ent_date,'MM'),'13')) acctg_seq, 
                                   NVL(to_char(spld_acct_ent_date,'FmMonth, RRRR'),'NOT TAKEN UP') acct_ent_date,  
                                   line_cd, subline_cd, iss_cd, decode (p_iss_param,1,cred_branch,iss_cd) iss_cd_head,
                                   issue_yy, pol_seq_no, renew_no,
                                   endt_iss_cd, endt_yy, endt_seq_no, get_policy_no(policy_id)||'*' policy_no,
                                   issue_date, incept_date, expiry_date, 
                                  -1*total_tsi total_tsi,
                                  -1*total_prem total_prem, 
                                  -1*evatprem evatprem,
                                  -1*lgt LGT, 
                                  -1*doc_stamps doc_stamps, 
                                  -1*fst fst, 
                                  -1*other_taxes other_taxes, 
                                  -1*(total_prem + evatprem + lgt + doc_stamps + fst + other_taxes) total_charges,
                                   param_date, from_date, to_date, scope, 
                                   user_id, policy_id,assd_no, spld_date 
                              FROM gipi_uwreports_ext
                             WHERE user_id = p_user_id -- marco - 02.05.2013 - changed from USER
                               AND decode (p_iss_param,1,cred_branch,iss_cd) = 
                                      NVL (p_iss_cd, 
                                           decode (p_iss_param,
                                                   1,cred_branch,
                                                   iss_cd
                                                  )
                                           )
                               AND line_cd =NVL(p_line_cd, line_cd)
                               AND subline_cd =NVL(p_subline_cd, subline_cd)
                               AND (    (p_scope=5 AND endt_seq_no=endt_seq_no)
                                     OR (p_scope=1 AND endt_seq_no=0)
                                     OR (p_scope=2 AND endt_seq_no>0)
                                     OR (p_scope=4 AND pol_flag='5')
                                   )
                               AND spld_acct_ent_date IS NOT NULL
                          ORDER BY iss_cd,
                                   
                                   line_cd, 
                                   subline_cd, 
                                   acctg_seq,
                                   issue_yy, 
                                   pol_seq_no, 
                                   renew_no,
                                   endt_iss_cd, 
                                   endt_yy, 
                                   endt_seq_no)
          LOOP
             v_gipir923f.acctg_seq       :=   i.acctg_seq;
             v_gipir923f.acct_ent_date   :=   i.acct_ent_date;
             v_gipir923f.line_cd         :=   i.line_cd;
             v_gipir923f.subline_cd      :=   i.subline_cd;
             v_gipir923f.iss_cd          :=   i.iss_cd;
             
             v_gipir923f.iss_cd_head     :=   i.iss_cd_head;
             v_gipir923f.issue_yy        :=   i.issue_yy;
             v_gipir923f.pol_seq_no      :=   i.pol_seq_no;
             
             v_gipir923f.renew_no        :=   i.renew_no;
             v_gipir923f.endt_iss_cd     :=   i.endt_iss_cd;
             v_gipir923f.endt_yy         :=   i.endt_yy;
             v_gipir923f.endt_seq_no     :=   i.endt_seq_no;
             v_gipir923f.policy_no       :=   i.policy_no;
             
             v_gipir923f.issue_date      :=   i.issue_date;
             v_gipir923f.incept_date     :=   i.incept_date;
             v_gipir923f.expiry_date     :=   i.expiry_date;
             v_gipir923f.total_tsi       :=   i.total_tsi;
             v_gipir923f.total_prem      :=   i.total_prem;
             
             v_gipir923f.evatprem        :=   i.evatprem;
             v_gipir923f.lgt             :=   i.lgt;
             v_gipir923f.doc_stamps      :=   i.doc_stamps;
             v_gipir923f.fst             :=   i.fst;
             v_gipir923f.other_taxes     :=   i.other_taxes;
             
             v_gipir923f.total_charges   :=   i.total_charges;
             v_gipir923f.param_date      :=   i.param_date;
             v_gipir923f.from_date       :=   i.from_date;
             v_gipir923f.to_date         :=   i.to_date;
             v_gipir923f.scope           :=   i.scope;
             
             v_gipir923f.user_id         :=   i.user_id;
             v_gipir923f.policy_id       :=   i.policy_id;
             v_gipir923f.assd_no         :=   i.assd_no;
             v_gipir923f.spld_date       :=   i.spld_date;
             v_gipir923f.cf_iss_title    :=   gipir923f_pkg.cf_iss_titleformula (p_iss_param);
             v_gipir923f.cf_iss_name     :=   gipir923f_pkg.cf_iss_nameformula (v_gipir923f.iss_cd_head);
             v_gipir923f.cf_line_name    :=   gipir923f_pkg.cf_line_nameformula (v_gipir923f.line_cd );
             v_gipir923f.cf_subline_name :=   gipir923f_pkg.cf_subline_nameformula (v_gipir923f.subline_cd, v_gipir923f.line_cd);
             v_gipir923f.cf_assd_name    :=   gipir923f_pkg.cf_assd_nameformula (v_gipir923f.assd_no);

                                 
          PIPE ROW (v_gipir923f);
          END LOOP;
          
  RETURN;    
END populate_gipir923F;
FUNCTION cf_companyformula
      RETURN CHAR
   IS
      v_company_name   VARCHAR2 (150);
   BEGIN
      SELECT param_value_v
        INTO v_company_name
        FROM giis_parameters
       WHERE UPPER (param_name) = 'COMPANY_NAME';

      RETURN (v_company_name);
   END;
FUNCTION cf_company_addressformula
      RETURN CHAR
   IS
      v_address   VARCHAR2 (500);
   BEGIN
      SELECT param_value_v
        INTO v_address
        FROM giis_parameters
       WHERE param_name = 'COMPANY_ADDRESS';

      RETURN (v_address);
      RETURN NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
         RETURN (v_address);
   END;
   FUNCTION cf_based_onformula (
      p_scope     gipi_uwreports_ext.SCOPE%TYPE,
      p_user_id   gipi_uwreports_ext.user_id%TYPE -- marco - 02.05.2013 - added parameter
   )
      RETURN CHAR
   IS
      v_param_date     NUMBER (1);
      v_based_on       VARCHAR2 (100);
      v_scope          NUMBER (1);
      v_policy_label   VARCHAR2 (300);
   BEGIN
      SELECT param_date
        INTO v_param_date
        FROM gipi_uwreports_ext
       WHERE user_id = p_user_id -- marco - 02.05.2013 - changed from USER
         AND ROWNUM = 1;

      IF v_param_date = 1
      THEN
         v_based_on := 'Based on Issue Date';
      ELSIF v_param_date = 2
      THEN
         v_based_on := 'Based on Inception Date';
      ELSIF v_param_date = 3
      THEN
         v_based_on := 'Based on Booking month - year';
      ELSIF v_param_date = 4
      THEN
         v_based_on := 'Based on Acctg Entry Date';
      END IF;

      v_scope := p_scope;

      IF v_scope = 1
      THEN
         v_policy_label := v_based_on || ' / ' || 'Policies Only';
      ELSIF v_scope = 2
      THEN
         v_policy_label := v_based_on || ' / ' || 'Endorsements Only';
      ELSIF v_scope = 3
      THEN
         v_policy_label := v_based_on || ' / ' || 'Policies and Endorsements';
      END IF;

      RETURN (v_policy_label);
   END;
   
    FUNCTION cf_heading3Formula(
        p_user_id   gipi_uwreports_ext.user_id%TYPE -- marco - 02.05.2013 - added parameter
    )
      RETURN CHAR IS
        v_param_date number(1);
        v_from_date date;
        v_to_date date;
        heading3 varchar2(150);
    BEGIN
        SELECT DISTINCT param_date, from_date, to_date 
          INTO v_param_date, v_from_date, v_to_date
          FROM gipi_uwreports_ext 
         WHERE user_id = p_user_id;
  
        IF v_param_date IN (1,2,4) THEN
  	if v_from_date = v_to_date then
  		heading3 := 'For '||to_char(v_from_date,'fmMonth dd, yyyy');
  	else 
  		heading3 := 'For the period of '||to_char(v_from_date,'fmMonth dd, yyyy')||' to '
  							||to_char(v_to_date,'fmMonth dd, yyyy');
  	end if;
  else
  	if TO_CHAR(v_from_date,'MMYYYY') = TO_CHAR(v_to_date,'MMYYYY') then
  		heading3 := 'For the month of '||to_char(v_from_date,'fmMonth, yyyy');
  	else 
  		heading3 := 'For the period of '||to_char(v_from_date,'fmMonth, yyyy')||' to '
  							||to_char(v_to_date,'fmMonth, yyyy');
  	end if;

  end if;
return(heading3);
end;

FUNCTION cf_iss_nameformula (p_iss_cd giis_issource.iss_cd%TYPE)
      RETURN CHAR
   IS
      v_iss_name   VARCHAR2 (50);
      
   BEGIN
      BEGIN
         SELECT iss_name
           INTO v_iss_name
           FROM giis_issource
          WHERE iss_cd = p_iss_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
         THEN
            NULL;
      END;

      RETURN (p_iss_cd || ' - ' || v_iss_name);
   END; 
   FUNCTION cf_iss_titleformula (
      p_iss_param   gipi_uwreports_ext.iss_cd%TYPE
   )
      RETURN CHAR
   IS
   BEGIN
      IF p_iss_param = 2
      THEN
         RETURN ('Issue Source');
      ELSE     
         RETURN ('Crediting Branch');
      
      END IF;
   END;
   FUNCTION cf_line_nameformula (p_line_cd giis_line.line_cd%TYPE)
      RETURN CHARACTER
   IS
   BEGIN
      FOR c IN (SELECT line_name
                  FROM giis_line
                 WHERE line_cd = p_line_cd)
      LOOP
         RETURN (c.line_name);
      END LOOP;
   END;
   FUNCTION cf_subline_nameformula (
      p_subline_cd   giis_subline.subline_cd%TYPE,
      p_line_cd      giis_subline.line_cd%TYPE
   )
      RETURN CHAR
   IS
   BEGIN
      FOR c IN (SELECT subline_name
                  FROM giis_subline
                 WHERE subline_cd = p_subline_cd AND line_cd = p_line_cd)
      LOOP
         RETURN (c.subline_name);
      END LOOP;
   END;
   FUNCTION cf_assd_nameformula (p_assd_no giis_assured.assd_no%TYPE)
      RETURN CHAR
   IS
   BEGIN
      FOR c IN (SELECT assd_name
                  FROM giis_assured
                 WHERE assd_no = p_assd_no)
      LOOP
         RETURN (c.assd_name);
      END LOOP;
   END;

END GIPIR923F_PKG;
/


