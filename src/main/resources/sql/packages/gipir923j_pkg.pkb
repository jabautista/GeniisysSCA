CREATE OR REPLACE PACKAGE BODY CPI.GIPIR923J_PKG 
AS
   /*
   **  Created by   :  PJ DIAZ
   ** Date Created : 05.17.2012
   */
   
    FUNCTION get_header_gipir923j (
        p_line_cd      gipi_uwreports_ext.line_cd%TYPE,
        p_subline_cd   gipi_uwreports_ext.subline_cd%TYPE,
        p_iss_cd       gipi_uwreports_ext.iss_cd%TYPE,
        p_iss_param    gipi_uwreports_ext.iss_cd%TYPE,    
        p_scope        gipi_uwreports_ext.SCOPE%TYPE,
        p_user_id      gipi_uwreports_ext.user_id%TYPE -- marco - 02.05.2013 - added parameter
        --p_from_date    DATE,         
        --p_to_date      DATE
    )
      RETURN header_tab PIPELINED AS
        rep   header_type;
    BEGIN
        rep.cf_company             := gipir923j_pkg.cf_companyformula;
        rep.cf_company_address     := gipir923j_pkg.cf_company_addressformula;
        rep.cf_based_on            := gipir923j_pkg.cf_based_onformula(p_scope, p_user_id);
        rep.cf_heading3            := gipir923j_pkg.cf_heading3Formula(p_user_id);
        rep.cf_spoiled             := gipir923j_pkg.cf_spoiledformula;
        rep.cf_1                   := gipir923j_pkg.cf_1formula;
        rep.cf_count_undistributed := gipir923j_pkg.cf_count_undistributedformula(p_line_cd,
                                                                                 p_subline_cd,
                                                                                 p_iss_cd,
                                                                                 p_iss_param,
                                                                                 p_scope,
                                                                                 p_user_id);
        rep.cf_total_undistributed :=  gipir923j_pkg.cf_undistributed_totalformula(p_line_cd,
                                                                                 p_subline_cd,
                                                                                 p_iss_cd,
                                                                                 p_iss_param,
                                                                                 p_scope,
                                                                                 p_user_id);
        rep.cf_count_distributed   := gipir923j_pkg.cf_count_distributedformula(p_line_cd,
                                                                                 p_subline_cd,
                                                                                 p_iss_cd,
                                                                                 p_iss_param,
                                                                                 p_scope,
                                                                                 p_user_id);
                                                                                --p_from_date,
                                                                                 --p_to_date);
        rep.cf_total_distributed   := gipir923j_pkg.cf_distributed_totalformula (p_line_cd,
                                                                                 p_subline_cd,
                                                                                 p_iss_cd,
                                                                                 p_iss_param,
                                                                                 p_scope,
                                                                                 p_user_id);
        PIPE ROW (rep);
    END;
    FUNCTION populate_gipir923j (
             p_line_cd        gipi_uwreports_ext.line_cd%TYPE,
             p_scope          gipi_uwreports_ext.scope%TYPE,
             p_iss_cd         gipi_uwreports_ext.iss_cd%TYPE,
             p_subline_cd     gipi_uwreports_ext.subline_cd%TYPE,
            --p_from_date      gipi_uwreports_ext.from_date%TYPE,
            --p_to_date        gipi_uwreports_ext.to_date%TYPE,
             p_iss_param      gipi_uwreports_ext.iss_cd%TYPE,
             p_user_id        gipi_uwreports_ext.user_id%TYPE -- marco - 02.05.2013 - added parameter
        )
         RETURN gipir923j_tab PIPELINED
    IS 
         v_gipir923j        gipir923j_type;
    BEGIN
       FOR i IN (--This is to select all column names  from table gipi_uwreports_ext.
                 --03/13/02  Jeanette Tan
                 --spld date is set to null if extract is based on acct ent date.
                 --if extract is not based on acct ent date, all amounts are set to 0 
                 --terrence 10/02/2002

                SELECT DECODE(spld_date,NULL,DECODE(dist_flag,3, 'D', 'U'),'S') "DIST_FLAG",  
                       line_cd, subline_cd, iss_cd,decode(p_iss_param,1,gp.cred_branch,gp.iss_cd) iss_cd_header,
                       issue_yy, pol_seq_no, renew_no,
                       endt_iss_cd, endt_yy, endt_seq_no,
                       issue_date, incept_date, expiry_date, 
                       DECODE(spld_date,NULL,total_tsi, 0) total_tsi,
                       DECODE(spld_date,NULL,total_prem, 0) total_prem, 
                       DECODE(spld_date,NULL,evatprem, 0) evatprem,
                       DECODE(spld_date,NULL,lgt, 0) lgt, 
                       DECODE(spld_date,NULL,doc_stamps, 0) doc_stamps, 
                       DECODE(spld_date,NULL,fst, 0) fst, 
                       DECODE(spld_date,NULL,other_taxes, 0) other_taxes, 
                       DECODE(spld_date,NULL,(total_prem + evatprem + lgt + doc_stamps + fst + other_taxes), 0)total_charges,
                       DECODE(spld_date,NULL,( evatprem + lgt + doc_stamps + fst + other_taxes), 0) total_taxes,
                    --DECODE(dist_flag, 3, total_prem, 0) Distributed,
                   --DECODE(dist_flag, 3, 0, total_prem) Undistributed,
                       param_date, from_date, TO_DATE, SCOPE, 
                       user_id, policy_id,assd_no, DECODE(spld_date,NULL,NULL,' S   P  O  I  L  E  D       /       '||TO_CHAR(spld_date,'MM-DD-YYYY')) spld_date,
                       DECODE(spld_date,NULL,1,0) pol_count
                FROM  gipi_uwreports_ext gp
                WHERE user_id = p_user_id
                   AND decode(p_iss_param,1,gp.cred_branch,gp.iss_cd) = NVL( p_iss_cd, decode(p_iss_param,1,gp.cred_branch,gp.iss_cd))
                   AND line_cd =NVL( p_line_cd, line_cd)
                   AND subline_cd =NVL( p_subline_cd, subline_cd)
                   AND p_scope=3 AND pol_flag='4'
                       /*AND endt_seq_no = (SELECT MAX(endt_seq_no)  --- done already with package p_uwreports ----rollie 03162004
                         FROM gipi_uwreports_ext a
                         WHERE 1=1
                         AND a.line_cd    = gp.line_cd
                         AND a.subline_cd = gp.subline_cd
                        AND a.iss_cd     = gp.iss_cd
                        AND issue_yy     = gp.issue_yy
                        AND pol_seq_no   = gp.pol_seq_no
                       AND a.renew_no   = gp.renew_no
                       AND pol_flag     ='4'
                     )*/
                ORDER BY line_cd, 
                         subline_cd, 
                         iss_cd,
                         issue_yy, 
                         pol_seq_no, 
                         renew_no,
                         endt_iss_cd, 
                         endt_yy, 
                         endt_seq_no )
               
          LOOP
 
             v_gipir923j.dist_flag      :=   i.dist_flag ;
             v_gipir923j.line_cd        :=   i.line_cd;
             v_gipir923j.subline_cd     :=   i.subline_cd;
             v_gipir923j.iss_cd        :=   i.iss_cd;
             v_gipir923j.iss_cd_header  :=   i.iss_cd_header;
             v_gipir923j.issue_yy       :=   i.issue_yy;
             v_gipir923j.pol_seq_no     :=   i.pol_seq_no;
             v_gipir923j.renew_no       :=   i.renew_no;
             v_gipir923j.endt_iss_cd    :=   i.endt_iss_cd;
             v_gipir923j.endt_yy        :=   i.endt_yy; 
             v_gipir923j.endt_seq_no    :=   i.endt_seq_no; 
             v_gipir923j.issue_date     :=   i.issue_date;
             v_gipir923j.incept_date    :=   i.incept_date;           
             v_gipir923j.expiry_date    :=   i.expiry_date ;
             v_gipir923j.total_tsi      :=   i.total_tsi;
             v_gipir923j.total_prem     :=   i.total_prem;
             v_gipir923j.evatprem       :=   i.evatprem;
             v_gipir923j.lgt            :=   i.lgt;
             v_gipir923j.doc_stamps     :=   i.doc_stamps;
             v_gipir923j.fst            :=   i.fst;
             v_gipir923j.other_taxes    :=   i.other_taxes;
             v_gipir923j.total_charges  :=   i.total_charges;
             v_gipir923j.evatprem       :=   i.evatprem;
             v_gipir923j.param_date     :=   i.param_date;
             v_gipir923j.from_date      :=   i.from_date;
             v_gipir923j.to_date        :=   i.to_date;
             v_gipir923j.scope          :=   i.scope;
             v_gipir923j.user_id        :=   i.user_id;
             v_gipir923j.policy_id      :=   i.policy_id;
             v_gipir923j.assd_no        :=   i.assd_no;
             v_gipir923j.spld_date      :=   i.spld_date;
             v_gipir923j.cf_iss_title    :=   gipir923j_pkg.cf_iss_titleformula (p_iss_param);
             v_gipir923j.cf_iss_name     :=   gipir923j_pkg.cf_iss_nameformula (i.iss_cd_header);
             v_gipir923j.cf_line_name    :=   gipir923j_pkg.cf_line_nameformula (i.line_cd );
             v_gipir923j.cf_subline_name :=   gipir923j_pkg.cf_subline_nameformula (i.subline_cd, i.line_cd);
             v_gipir923j.cf_assd_name    :=   gipir923j_pkg.cf_assd_nameformula (i.assd_no);
             v_gipir923j.cf_policy_no    :=   gipir923j_pkg.cf_policy_noformula (i.line_cd,
                                                                          i.subline_cd,
                                                                          i.iss_cd,
                                                                          i.issue_yy,
                                                                          i.pol_seq_no,
                                                                          i.renew_no,
                                                                          i.endt_seq_no,
                                                                          i.endt_iss_cd,
                                                                          i.endt_yy,
                                                                          i.policy_id);
                                                    
                                                

          PIPE ROW (v_gipir923j);
          END LOOP;
            
  RETURN;    
END populate_gipir923j;
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
    FUNCTION cf_based_onformula(
        p_scope         gipi_uwreports_ext.scope%type,
        p_user_id       gipi_uwreports_ext.user_id%TYPE -- marco - 02.05.2013 - added parameter
    )
      RETURN CHAR IS
        v_param_date     NUMBER (1);
        v_based_on       VARCHAR2 (100);
        v_scope          NUMBER (1);
        v_policy_label   VARCHAR2 (300);
    BEGIN
        SELECT param_date
          INTO v_param_date
          FROM gipi_uwreports_ext
         WHERE user_id = p_user_id
           AND ROWNUM = 1;

        IF v_param_date = 1 THEN
            v_based_on := 'Based on Issue Date';
        ELSIF v_param_date = 2 THEN
            v_based_on := 'Based on Inception Date';
        ELSIF v_param_date = 3 THEN
            v_based_on := 'Based on Booking month - year';
        ELSIF v_param_date = 4 THEN
            v_based_on := 'Based on Acctg Entry Date';
        END IF;

        v_scope := p_scope;

        IF v_scope = 1 THEN
            v_policy_label := v_based_on || ' / ' || 'Policies Only';
        ELSIF v_scope = 2 THEN
            v_policy_label := v_based_on || ' / ' || 'Endorsements Only';
        ELSIF v_scope = 3 THEN
            v_policy_label := v_based_on || ' / ' || 'Policies and Endorsements';
        END IF;

      RETURN (v_policy_label);
   END;
   
    FUNCTION cf_heading3Formula(
        p_user_id       gipi_uwreports_ext.user_id%TYPE -- marco - 02.05.2013 - added parameter
    )
      RETURN CHAR IS
        v_param_date    NUMBER(1);
        v_from_date     DATE;
        v_to_date       DATE;
        heading3        VARCHAR2(150);
    BEGIN
        SELECT DISTINCT param_date, from_date, to_date 
          INTO v_param_date, v_from_date, v_to_date
          FROM gipi_uwreports_ext 
         WHERE user_id = p_user_id;
          
        IF v_param_date IN (1,2,4) THEN
            IF v_from_date = v_to_date THEN
                heading3 := 'For '||TO_CHAR(v_from_date,'fmMonth dd, yyyy');
            ELSE 
                heading3 := 'For the period of '||TO_CHAR(v_from_date,'fmMonth dd, yyyy')||' to '||TO_CHAR(v_to_date,'fmMonth dd, yyyy');
            END IF;
        ELSE
            IF TO_CHAR(v_from_date,'MMYYYY') = TO_CHAR(v_to_date,'MMYYYY') THEN
                heading3 := 'For the month of '||TO_CHAR(v_from_date,'fmMonth, yyyy');
            ELSE 
                heading3 := 'For the period of '||to_char(v_from_date,'fmMonth, yyyy')||' to '||TO_CHAR(v_to_date,'fmMonth, yyyy');
            END IF;
        END IF;
        
        RETURN(heading3);
    END;
         FUNCTION cf_spoiledformula
          RETURN NUMBER
       IS
          count_spoiled   NUMBER (30) := 0;
       
          BEGIN
             /*SELECT count(policy_id)
                INTO count_spoiled
                FROM gipi_uwreports_ext
               WHERE 
                     user_id = user
                 AND iss_cd =NVL( p_iss_cd, iss_cd)
                 AND line_cd =NVL( p_line_cd, line_cd)
                 AND subline_cd =NVL( p_subline_cd, subline_cd)
                 AND ((p_scope=3 AND endt_seq_no=endt_seq_no)
                  OR  (p_scope=1 AND endt_seq_no=0)
                  OR  (p_scope=2 AND endt_seq_no>0))
                 AND from_date = NVL(p_from_date, from_date)
                 AND to_date = NVL (p_to_date, to_date)
                 AND SPLD_DATE IS not NULL;*/
                      

          RETURN (count_spoiled);
       END;
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
          RETURN CHAR
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
     FUNCTION cf_policy_noformula (
      p_line_cd       gipi_uwreports_ext.line_cd%TYPE,
      p_subline_cd    gipi_uwreports_ext.subline_cd%TYPE,
      p_iss_cd        gipi_uwreports_ext.iss_cd%TYPE,
      p_issue_yy      gipi_uwreports_ext.issue_yy%TYPE,
      p_pol_seq_no    gipi_uwreports_ext.pol_seq_no%TYPE,
      p_renew_no      gipi_uwreports_ext.renew_no%TYPE,
      p_endt_seq_no   gipi_uwreports_ext.endt_seq_no%TYPE,
      p_endt_iss_cd   gipi_uwreports_ext.endt_iss_cd%TYPE,
      p_endt_yy       gipi_uwreports_ext.endt_yy%TYPE,
      p_policy_id     gipi_uwreports_ext.policy_id%TYPE
   )
      RETURN CHAR
       IS
          v_policy_no    VARCHAR2 (100);
          v_endt_no      VARCHAR2 (30);
          v_ref_pol_no   VARCHAR2 (35)  := NULL;
       BEGIN
          v_policy_no :=
                p_line_cd
             || '-'
             || p_subline_cd
             || '-'
             || LTRIM (p_iss_cd)
             || '-'
             || LTRIM (TO_CHAR (p_issue_yy, '09'))
             || '-'
             || LTRIM (TO_CHAR (p_pol_seq_no))
             || '-'
             || LTRIM (TO_CHAR (p_renew_no, '09'));

          IF p_endt_seq_no <> 0
          THEN
             v_endt_no :=
                   p_endt_iss_cd
                || '-'
                || LTRIM (TO_CHAR (p_endt_yy, '09'))
                || '-'
                || LTRIM (TO_CHAR (p_endt_seq_no));
          END IF;

          BEGIN
             SELECT ref_pol_no
               INTO v_ref_pol_no
               FROM gipi_polbasic
              WHERE policy_id = p_policy_id;
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                v_ref_pol_no := NULL;
          END;

          IF v_ref_pol_no IS NOT NULL
          THEN
             v_ref_pol_no := '/' || v_ref_pol_no;
          END IF;

          RETURN (v_policy_no || ' ' || v_endt_no || v_ref_pol_no);
       END;
    FUNCTION cf_1Formula
      RETURN NUMBER 
    IS
    BEGIN
        RETURN(0.00);
    END;
        
    FUNCTION CF_count_undistributedFormula (
        p_line_cd               gipi_uwreports_ext.line_cd%TYPE,
        p_subline_cd            gipi_uwreports_ext.subline_cd%TYPE,
        p_iss_cd                gipi_uwreports_ext.iss_cd%TYPE,
        p_iss_param             gipi_uwreports_ext.iss_cd%TYPE,
        p_scope                 gipi_uwreports_ext.scope%TYPE,
        p_user_id               gipi_uwreports_ext.user_id%TYPE -- marco - 02.05.2013 - added parameter
      )
    RETURN NUMBER IS
        count_undistributed     NUMBER;    
    BEGIN       	
          SELECT count(dist_flag)
            INTO count_undistributed
            FROM gipi_uwreports_ext gp
           WHERE dist_flag <> 3  
             AND user_id = p_user_id
             AND decode(p_iss_param,1,gp.cred_branch,gp.iss_cd) = NVL( p_iss_cd, decode(p_iss_param,1,gp.cred_branch,gp.iss_cd))
             AND line_cd =NVL( p_line_cd, line_cd)
             AND subline_cd =NVL( p_subline_cd, subline_cd)
             AND ((p_scope=3 AND endt_seq_no=endt_seq_no)
              OR  (p_scope=1 AND endt_seq_no=0)
              OR  (p_scope=2 AND endt_seq_no>0))
             AND POL_FLAG = '4'
             AND SPLD_DATE IS NULL;
             /*AND endt_seq_no = (SELECT MAX(endt_seq_no)
                                  FROM gipi_uwreports_ext a
                                         WHERE 1=1
                                           AND a.line_cd    = gp.line_cd
                                   AND a.subline_cd = gp.subline_cd
                                   AND a.iss_cd     = gp.iss_cd
                                   AND issue_yy     = gp.issue_yy
                                             AND pol_seq_no   = gp.pol_seq_no
                                             AND a.renew_no   = gp.renew_no
                                             AND pol_flag     ='4');*/
        RETURN (count_undistributed); 
    END;
    
    FUNCTION cf_undistributed_totalFormula(
        p_line_cd       gipi_uwreports_ext.line_cd%TYPE,
        p_subline_cd    gipi_uwreports_ext.subline_cd%TYPE,
        p_iss_cd        gipi_uwreports_ext.iss_cd%TYPE,
        p_iss_param     gipi_uwreports_ext.iss_cd%TYPE,
        p_scope         gipi_uwreports_ext.scope%TYPE,
        p_user_id       gipi_uwreports_ext.user_id%TYPE -- marco - 02.05.2013
    ) 
    RETURN NUMBER IS
        v_total         NUMBER;
    BEGIN
        SELECT sum(NVL(total_prem,0))
          INTO v_total
          FROM gipi_uwreports_ext
         WHERE dist_flag <> 3
           AND user_id = p_user_id
           AND decode(p_iss_param,1,cred_branch,iss_cd) = NVL( p_iss_cd, decode(p_iss_param,1,cred_branch,iss_cd))
           AND line_cd =NVL( p_line_cd, line_cd)
           AND subline_cd =NVL( p_subline_cd, subline_cd)
           AND ((p_scope=3 AND endt_seq_no=endt_seq_no)
            OR  (p_scope=1 AND endt_seq_no=0)
            OR  (p_scope=2 AND endt_seq_no>0))
      --     AND from_date = NVL(:p_from_date, from_date)
      --     AND to_date = NVL (:p_to_date, to_date)
           AND SPLD_DATE IS NULL
           AND POL_FLAG = '4';
      --exception when no_data_found then v_total := 0;
         
        RETURN (v_total); 
    END;
      FUNCTION cf_count_distributedformula(
          p_line_cd       gipi_uwreports_ext.line_cd%TYPE,
          p_subline_cd    gipi_uwreports_ext.subline_cd%TYPE,
          p_iss_cd        gipi_uwreports_ext.iss_cd%TYPE,
          p_iss_param     gipi_uwreports_ext.iss_cd%TYPE,
          p_scope         gipi_uwreports_ext.scope%TYPE,
          p_user_id       gipi_uwreports_ext.user_id%TYPE -- marco - 02.05.2013
          --p_from_date     DATE,         
         -- p_to_date       DATE
          ) 
          RETURN NUMBER
          IS
          count_distributed			NUMBER(30);
          BEGIN
              SELECT count(dist_flag)
                INTO count_distributed
                FROM gipi_uwreports_ext gp
               WHERE dist_flag = 3
                 AND user_id = p_user_id
                 AND decode(p_iss_param,1,gp.cred_branch,gp.iss_cd) = NVL( p_iss_cd, decode(p_iss_param,1,gp.cred_branch,gp.iss_cd))
                 AND line_cd =NVL( p_line_cd, line_cd)
                 AND subline_cd =NVL( p_subline_cd, subline_cd)
                 AND ((p_scope=3 AND endt_seq_no=endt_seq_no)
                  OR  (p_scope=1 AND endt_seq_no=0)
                  OR  (p_scope=2 AND endt_seq_no>0))
                 --PJ-AND from_date = NVL(p_from_date, from_date)
                 --PJ-AND to_date = NVL (p_to_date, to_date)
                 AND SPLD_DATE IS NULL
                 AND POL_FLAG = '4';
                 /*AND endt_seq_no = (SELECT MAX(endt_seq_no)
                                      FROM gipi_uwreports_ext a
                                             WHERE 1=1
                                               AND a.line_cd    = gp.line_cd
                                       AND a.subline_cd = gp.subline_cd
                                       AND a.iss_cd     = gp.iss_cd
                                       AND issue_yy     = gp.issue_yy
                                                 AND pol_seq_no   = gp.pol_seq_no
                                                 AND a.renew_no   = gp.renew_no
                                                 AND pol_flag     ='4');*/
                 
              RETURN (count_distributed); 
            END;
            
    FUNCTION cf_distributed_totalformula (
        p_line_cd       gipi_uwreports_ext.line_cd%TYPE,
        p_subline_cd    gipi_uwreports_ext.subline_cd%TYPE,
        p_iss_cd        gipi_uwreports_ext.iss_cd%TYPE,
        p_iss_param     gipi_uwreports_ext.iss_cd%TYPE,
        p_scope         gipi_uwreports_ext.scope%TYPE,
        p_user_id       gipi_uwreports_ext.user_id%TYPE -- marco - 02.05.2013
    )   
      RETURN NUMBER IS
        v_total NUMBER;
    BEGIN
        BEGIN
            SELECT SUM(NVL(total_prem,0))
              INTO v_total
              FROM gipi_uwreports_ext
             WHERE dist_flag = 3
               AND user_id = p_user_id
               AND decode(p_iss_param,1,cred_branch,iss_cd) = NVL( p_iss_cd, decode(p_iss_param,1,cred_branch,iss_cd))
               AND line_cd =NVL( p_line_cd, line_cd)
               AND subline_cd =NVL(p_subline_cd, subline_cd)
               AND ((p_scope=3 AND endt_seq_no=endt_seq_no)
                OR  (p_scope=1 AND endt_seq_no=0)
                OR  (p_scope=2 AND endt_seq_no>0))
                -- AND from_date = NVL(:p_from_date, from_date)
                -- AND to_date = NVL (:p_to_date, to_date)
               AND SPLD_DATE IS NULL
               AND pol_flag = '4';
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                v_total := 0;
        END;
        
        RETURN (v_total); 
    END;
               
END GIPIR923J_PKG;
/


