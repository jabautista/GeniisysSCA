CREATE OR REPLACE PACKAGE BODY CPI.gipir923a_pkg
AS
   /*
   **  Created by   :  Robert Virrey
   **  Date Created : 05.04.2012
   **  Reference By : GIPIR923A - Production Report(Summary)
   **  Description  :
   */
   FUNCTION get_header_gipr923a (
      p_scope     gipi_uwreports_intm_ext.SCOPE%TYPE,
      p_user_id   gipi_uwreports_intm_ext.user_id%TYPE 
   )
      RETURN header_tab PIPELINED
   AS
      rep   header_type;
   BEGIN
      rep.cf_company := gipir923a_pkg.cf_companyformula;
      rep.cf_company_address := gipir923a_pkg.cf_company_addressformula;
      rep.cf_heading3 := gipir923a_pkg.cf_heading3formula (p_user_id);
      rep.cf_based_on :=
                        gipir923a_pkg.cf_based_onformula (p_user_id, p_scope);
      PIPE ROW (rep);
   END;

   FUNCTION populate_gipir923a (
      p_iss_param    gipi_uwreports_intm_ext.iss_cd%TYPE,
      p_user_id      gipi_uwreports_intm_ext.user_id%TYPE,
      p_iss_cd       gipi_uwreports_intm_ext.iss_cd%TYPE,
      p_line_cd      gipi_uwreports_intm_ext.line_cd%TYPE,
      p_subline_cd   gipi_uwreports_intm_ext.subline_cd%TYPE,
      p_assd_no      gipi_uwreports_intm_ext.assd_no%TYPE,
      p_intm_no      gipi_uwreports_intm_ext.intm_no%TYPE,
      p_scope        gipi_uwreports_intm_ext.SCOPE%TYPE
   )
      RETURN report_tab PIPELINED
   AS
   /* Modified By :      Jhing Factor FGICWEB 17728
       Date Modified:   08.13.2015
      Purpose / Reason: Extraction of TAB5 has been modified to handle modified commission. To be able to display the amounts per invoice 
                                   without a need to requery data in gipi tables, invoice no. is stored in the extract table using the new extract hence 
                                   query of the report should be modified to handle this scenario. 
   */    
      rep   report_type;
      v_count   NUMBER;
   BEGIN
      FOR i IN ( -- jhing 08.13.2015 replaced query based on changes on the extraction. AFPGEN 19428 / FGIC 17728
                      /* SELECT DISTINCT assd_name, line_name, subline_name,
                                issue_date, incept_date, expiry_date,
                                total_tsi, total_prem, evatprem, fst, lgt,
                                doc_stamps, other_taxes, line_cd, subline_cd,
                                DECODE (p_iss_param,
                                        1, cred_branch,
                                        iss_cd
                                       ) iss_cd,
                                issue_yy, pol_seq_no, renew_no, endt_seq_no,
                                endt_iss_cd, endt_yy, policy_id,
                                get_policy_no (policy_id) policy_no,
                                  NVL (total_prem, 0)
                                + NVL (evatprem, 0)
                                + NVL (fst, 0)
                                + NVL (lgt, 0)
                                + NVL (doc_stamps, 0)
                                + NVL (other_taxes, 0) total_charges
                           FROM gipi_uwreports_intm_ext
                          WHERE user_id = p_user_id
                            AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                                   NVL (p_iss_cd,
                                        DECODE (p_iss_param,
                                                1, cred_branch,
                                                iss_cd
                                               )
                                       )
                            AND line_cd = NVL (p_line_cd, line_cd)
                            AND subline_cd = NVL (p_subline_cd, subline_cd)
                            AND assd_no = NVL (p_assd_no, assd_no)
                            AND intm_no = NVL (p_intm_no, intm_no)
                            AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no
                                    )
                                 OR (p_scope = 1 AND endt_seq_no = 0)
                                 OR (p_scope = 2 AND endt_seq_no > 0)
                                )
                            /* added security rights control by robert 01.02.14*/
                        /*    AND check_user_per_iss_cd2 (line_cd,DECODE (p_iss_param,1, cred_branch,iss_cd),'GIPIS901A', p_user_id) =1
                            AND check_user_per_line2 (line_cd,DECODE (p_iss_param,1, cred_branch,iss_cd),'GIPIS901A', p_user_id) = 1
                            /* robert 01.02.14 end of added code */
                      /* ORDER BY assd_name,
                                line_cd,
                                subline_cd,
                                iss_cd,
                                issue_yy,
                                pol_seq_no,
                                renew_no,
                                endt_seq_no */  
                                -- new query jhing 08.13.2015
                                 SELECT ab.assd_no,
                                         ab.assd_name,
                                         ab.line_name,
                                         ab.subline_name,
                                         ab.issue_date,
                                         ab.incept_date,
                                         ab.expiry_date,
                                         ab.line_cd,
                                         ab.subline_cd,
                                         ab.iss_cd,
                                         ab.actual_iss_cd,
                                         ab.issue_yy,
                                         ab.pol_seq_no,
                                         ab.renew_no,
                                         ab.endt_seq_no,
                                         ab.endt_iss_cd,
                                         ab.endt_yy,
                                         ab.policy_id,
                                         ab.policy_no,
                                         rownum, --added by MarkS 7.4.2016 SR-21060
                                         SUM (NVL (ab.total_tsi, 0)) total_tsi,
                                         SUM (NVL (ab.total_prem, 0)) total_prem,
                                         SUM (NVL (ab.evatprem, 0)) evatprem,
                                         SUM (NVL (ab.fst, 0)) fst,
                                         SUM (NVL (ab.lgt, 0)) lgt,
                                         SUM (NVL (ab.doc_stamps, 0)) doc_stamps,
                                         SUM (NVL (ab.other_taxes, 0)) other_taxes,
                                         SUM (NVL (ab.total_charges, 0)) total_charges,
                                         ab.rec_type 
                                    FROM (SELECT DISTINCT
                                                 x.assd_no,
                                                 TRIM (x.assd_name) assd_name,
                                                 x.line_name,
                                                 x.subline_name,
                                                 x.issue_date,
                                                 x.incept_date,
                                                 x.expiry_date,
                                                 x.total_tsi,
                                                 x.total_prem,
                                                 x.evatprem,
                                                 x.fst,
                                                 x.lgt,
                                                 x.doc_stamps,
                                                 x.other_taxes,
                                                 x.line_cd,
                                                 x.subline_cd,
                                                 DECODE (p_iss_param,
                                                         1, NVL (x.cred_branch, x.iss_cd),
                                                         x.iss_cd)
                                                    iss_cd,
                                                 x.iss_cd actual_iss_cd,
                                                 x.issue_yy,
                                                 x.pol_seq_no,
                                                 x.renew_no,
                                                 x.endt_seq_no,
                                                 x.endt_iss_cd,
                                                 x.endt_yy,
                                                 x.policy_id,
                                                 x.prem_seq_no,
                                                 get_policy_no (x.policy_id) policy_no,
                                                   NVL (x.total_prem, 0)
                                                 + NVL (x.evatprem, 0)
                                                 + NVL (x.fst, 0)
                                                 + NVL (x.lgt, 0)
                                                 + NVL (x.doc_stamps, 0)
                                                 + NVL (x.other_taxes, 0)
                                                    total_charges, x.rec_type 
                                            FROM gipi_uwreports_intm_ext x
                                           WHERE     x.user_id = p_user_id
                                                 AND DECODE (p_iss_param,
                                                             1, NVL (x.cred_branch, x.iss_cd),
                                                             x.iss_cd) =
                                                        NVL (p_iss_cd,
                                                             DECODE (p_iss_param, 1, NVL(cred_branch, iss_cd), iss_cd)) --benjo 10.28.2015 added nvl in cred_branch
                                                 AND line_cd = NVL (p_line_cd, line_cd)
                                                 AND subline_cd = NVL (p_subline_cd, subline_cd)
                                                 AND assd_no = NVL (p_assd_no, assd_no)
                                                 AND intm_no = NVL (p_intm_no, intm_no)
                                                 AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                                                      OR (p_scope = 1 AND endt_seq_no = 0)
                                                      OR (p_scope = 2 AND endt_seq_no > 0))) ab
                                GROUP BY ab.assd_no,
                                         ab.assd_name,
                                         ab.line_name,
                                         ab.subline_name,
                                         ab.issue_date,
                                         ab.incept_date,
                                         ab.expiry_date,
                                         ab.line_cd,
                                         ab.subline_cd,
                                         ab.iss_cd,
                                         ab.actual_iss_cd,
                                         ab.issue_yy,
                                         ab.pol_seq_no,
                                         ab.renew_no,
                                         ab.endt_seq_no,
                                         ab.endt_iss_cd,
                                         ab.endt_yy,
                                         ab.policy_id,
                                         ab.policy_no,
                                         ab.rec_type,
                                         rownum --added by MarkS 7.4.2016 SR-21060 
                                ORDER BY ab.assd_name,
                                        ab.assd_no,
                                         ab.iss_cd,
                                         ab.line_cd,
                                         ab.subline_cd,                                       
                                         ab.actual_iss_cd,
                                         ab.issue_yy,
                                         ab.pol_seq_no,
                                         ab.renew_no,
                                         ab.endt_seq_no,
                                         ab.rec_type
                                )
      LOOP
         rep.assd_name := /*i.assd_name*/ i.assd_no || ' - ' || i.assd_name  ; -- jhing 08.13.2015 assd_name will be contenation of assd_no and assd_name  AFPGEN 19428 / FGIC 17728
         rep.doc_stamps := i.doc_stamps;
         rep.endt_iss_cd := i.endt_iss_cd;
         rep.endt_seq_no := i.endt_seq_no;
         rep.endt_yy := i.endt_yy;
         rep.evatprem := i.evatprem;
         rep.expiry_date := i.expiry_date;
         rep.fst := i.fst;
         rep.incept_date := i.incept_date;
         rep.iss_cd := i.iss_cd;
         rep.issue_date := i.issue_date;
         rep.issue_yy := i.issue_yy;
         rep.lgt := i.lgt;
         rep.line_cd := i.line_cd;
         rep.line_name := i.line_name;
         rep.other_taxes := i.other_taxes;
         rep.pol_seq_no := i.pol_seq_no;
         rep.policy_id := i.policy_id;
         rep.policy_no := i.policy_no;
         rep.renew_no := i.renew_no;
         rep.subline_cd := i.subline_cd;
         rep.subline_name := i.subline_name;
         rep.total_charges := i.total_charges;
         rep.total_prem := i.total_prem;
         rep.total_tsi := i.total_tsi;
         rep.cf_iss_name := gipir923a_pkg.cf_iss_nameformula (i.iss_cd);
         rep.cf_iss_header := gipir923a_pkg.cf_iss_headerformula (p_iss_param);
         
         IF GIISP.V('PRD_POL_CNT') = 1 THEN
            rep.pol_count := 1;
         ELSIF GIISP.V('PRD_POL_CNT') = 2 THEN 
            IF i.endt_seq_no = 0 THEN
                rep.pol_count := 1;
            ELSE 
                rep.pol_count := 0;
            END IF;
         ELSIF NVL(GIISP.V('PRD_POL_CNT'), 1) = 3 THEN
            --edited MarkS 7.4.2016 sr-21060
             rep.pol_count := 1;
            FOR j IN (
                SELECT ab.assd_no,
                                         ab.assd_name,
                                         ab.line_name,
                                         ab.subline_name,
                                         ab.issue_date,
                                         ab.incept_date,
                                         ab.expiry_date,
                                         ab.line_cd,
                                         ab.subline_cd,
                                         ab.iss_cd,
                                         ab.actual_iss_cd,
                                         ab.issue_yy,
                                         ab.pol_seq_no,
                                         ab.renew_no,
                                         ab.endt_seq_no,
                                         ab.endt_iss_cd,
                                         ab.endt_yy,
                                         ab.policy_id,
                                         ab.policy_no,
                                         rownum, --added by MarkS 7.4.2016 SR-21060
                                         SUM (NVL (ab.total_tsi, 0)) total_tsi,
                                         SUM (NVL (ab.total_prem, 0)) total_prem,
                                         SUM (NVL (ab.evatprem, 0)) evatprem,
                                         SUM (NVL (ab.fst, 0)) fst,
                                         SUM (NVL (ab.lgt, 0)) lgt,
                                         SUM (NVL (ab.doc_stamps, 0)) doc_stamps,
                                         SUM (NVL (ab.other_taxes, 0)) other_taxes,
                                         SUM (NVL (ab.total_charges, 0)) total_charges,
                                         ab.rec_type 
                                    FROM (SELECT DISTINCT
                                                 x.assd_no,
                                                 TRIM (x.assd_name) assd_name,
                                                 x.line_name,
                                                 x.subline_name,
                                                 x.issue_date,
                                                 x.incept_date,
                                                 x.expiry_date,
                                                 x.total_tsi,
                                                 x.total_prem,
                                                 x.evatprem,
                                                 x.fst,
                                                 x.lgt,
                                                 x.doc_stamps,
                                                 x.other_taxes,
                                                 x.line_cd,
                                                 x.subline_cd,
                                                 DECODE (p_iss_param,
                                                         1, NVL (x.cred_branch, x.iss_cd),
                                                         x.iss_cd)
                                                    iss_cd,
                                                 x.iss_cd actual_iss_cd,
                                                 x.issue_yy,
                                                 x.pol_seq_no,
                                                 x.renew_no,
                                                 x.endt_seq_no,
                                                 x.endt_iss_cd,
                                                 x.endt_yy,
                                                 x.policy_id,
                                                 x.prem_seq_no,
                                                 get_policy_no (x.policy_id) policy_no,
                                                   NVL (x.total_prem, 0)
                                                 + NVL (x.evatprem, 0)
                                                 + NVL (x.fst, 0)
                                                 + NVL (x.lgt, 0)
                                                 + NVL (x.doc_stamps, 0)
                                                 + NVL (x.other_taxes, 0)
                                                    total_charges, x.rec_type 
                                            FROM gipi_uwreports_intm_ext x
                                           WHERE     x.user_id = p_user_id
                                                 AND DECODE (p_iss_param,
                                                             1, NVL (x.cred_branch, x.iss_cd),
                                                             x.iss_cd) =
                                                        NVL (p_iss_cd,
                                                             DECODE (p_iss_param, 1, NVL(cred_branch, iss_cd), iss_cd)) --benjo 10.28.2015 added nvl in cred_branch
                                                 AND line_cd = NVL (p_line_cd, line_cd)
                                                 AND subline_cd = NVL (p_subline_cd, subline_cd)
                                                 AND assd_no = NVL (p_assd_no, assd_no)
                                                 AND intm_no = NVL (p_intm_no, intm_no)
                                                 AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                                                      OR (p_scope = 1 AND endt_seq_no = 0)
                                                      OR (p_scope = 2 AND endt_seq_no > 0))) ab
                                GROUP BY ab.assd_no,
                                         ab.assd_name,
                                         ab.line_name,
                                         ab.subline_name,
                                         ab.issue_date,
                                         ab.incept_date,
                                         ab.expiry_date,
                                         ab.line_cd,
                                         ab.subline_cd,
                                         ab.iss_cd,
                                         ab.actual_iss_cd,
                                         ab.issue_yy,
                                         ab.pol_seq_no,
                                         ab.renew_no,
                                         ab.endt_seq_no,
                                         ab.endt_iss_cd,
                                         ab.endt_yy,
                                         ab.policy_id,
                                         ab.policy_no,
                                         ab.rec_type,
                                         rownum --added by MarkS 7.4.2016 SR-21060 
                                ORDER BY ab.assd_name,
                                        ab.assd_no,
                                         ab.iss_cd,
                                         ab.line_cd,
                                         ab.subline_cd,                                       
                                         ab.actual_iss_cd,
                                         ab.issue_yy,
                                         ab.pol_seq_no,
                                         ab.renew_no,
                                         ab.endt_seq_no,
                                         ab.rec_type 
            )
            LOOP
                IF I.ROWNUM > J.ROWNUM THEN
                    IF i.line_cd =  j.line_cd AND
                       i.subline_cd = j.subline_cd AND
                       i.issue_yy = j.issue_yy AND
                       i.pol_seq_no = j.pol_seq_no AND
                       i.renew_no = j.renew_no AND
                       i.endt_seq_no = j.endt_seq_no AND
                       i.iss_cd = j.iss_cd AND
                       check_unique_policy(i.policy_id,j.policy_id) = 'T' THEN
                       rep.pol_count := 0;
                    ELSE
                       rep.pol_count := 1;
                    END IF;
                ELSE
                    EXIT;
                END IF;
            END LOOP;                            
        ELSE
            rep.pol_count := 1;
            -- end sr-21060
--           SELECT COUNT(*)
--             INTO v_count
--             FROM gipi_uwreports_intm_ext x
--            WHERE x.user_id = p_user_id
--              AND DECODE (p_iss_param, 1, NVL (x.cred_branch, x.iss_cd), x.iss_cd) =
--                     NVL (p_iss_cd,
--                          DECODE (p_iss_param, 1, NVL (cred_branch, iss_cd), iss_cd)
--                         )
--              AND line_cd = NVL (p_line_cd, line_cd)
--              AND subline_cd = NVL (p_subline_cd, subline_cd)
--              AND assd_no = NVL (p_assd_no, assd_no)
--              AND intm_no = NVL (p_intm_no, intm_no)
--              AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
--                   OR (p_scope = 1 AND endt_seq_no = 0)
--                   OR (p_scope = 2 AND endt_seq_no > 0)
--                  )
--              AND ISS_CD = i.iss_cd
--              AND ISSUE_YY = i.issue_yy
--              AND POL_SEQ_NO = i.pol_seq_no
--              AND RENEW_NO = i.renew_no;
--              
--            IF v_count > 1 THEN
--                IF i.endt_seq_no = 0 THEN
--                    rep.pol_count := 1;
--                ELSE 
--                    rep.pol_count := 0;
--                END IF;
--            ELSE
--                rep.pol_count := 1;
--            END IF;   
                  
         END IF;
         
         PIPE ROW (rep);
      END LOOP;

      RETURN;
   END populate_gipir923a;

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

   FUNCTION cf_iss_headerformula (
      p_iss_param   gipi_uwreports_intm_ext.iss_cd%TYPE
   )
      RETURN CHAR
   IS
   BEGIN
      IF p_iss_param = 1
      THEN
         RETURN ('Crediting Branch  : ');
      ELSIF p_iss_param = 2
      THEN
         RETURN ('Issue Source         : ');   -- jhing 08.13.2015 added spaces 
      ELSE
         RETURN NULL;
      END IF;
   END;

   FUNCTION cf_based_onformula (
      p_user_id   gipi_uwreports_intm_ext.user_id%TYPE,
      p_scope     gipi_uwreports_intm_ext.SCOPE%TYPE
   )
      RETURN CHAR
   IS
      v_param_date     NUMBER (1);
      v_based_on       VARCHAR2 (100);
      v_scope          NUMBER (1);
      v_policy_label   VARCHAR2 (200);
   BEGIN
      SELECT param_date
        INTO v_param_date
        FROM gipi_uwreports_intm_ext
       WHERE user_id = p_user_id AND ROWNUM = 1;

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

   FUNCTION cf_heading3formula (
      p_user_id   gipi_uwreports_intm_ext.user_id%TYPE
   )
      RETURN CHAR
   IS
      v_param_date   NUMBER (1);
      v_from_date    DATE;
      v_to_date      DATE;
      heading3       VARCHAR2 (150);
   BEGIN
      SELECT DISTINCT param_date, from_date, TO_DATE
                 INTO v_param_date, v_from_date, v_to_date
                 FROM gipi_uwreports_intm_ext
                WHERE user_id = p_user_id;

      IF v_param_date IN (1, 2, 4)
      THEN
         IF v_from_date = v_to_date
         THEN
            heading3 := 'For ' || TO_CHAR (v_from_date, 'fmMonth dd, yyyy');
         ELSE
            heading3 :=
                  'For the period of '
               || TO_CHAR (v_from_date, 'fmMonth dd, yyyy')
               || ' to '
               || TO_CHAR (v_to_date, 'fmMonth dd, yyyy');
         END IF;
      ELSE
         IF v_from_date = v_to_date
         THEN
            heading3 :=
                'For the month of ' || TO_CHAR (v_from_date, 'fmMonth, yyyy');
         ELSE
            heading3 :=
                  'For the period of '
               || TO_CHAR (v_from_date, 'fmMonth, yyyy')
               || ' to '
               || TO_CHAR (v_to_date, 'fmMonth, yyyy');
         END IF;
      END IF;

      RETURN (heading3);
   END;
   FUNCTION check_unique_policy(pol_id_i GIPI_UWREPORTS_INTM_EXT.policy_id%TYPE,pol_id_j GIPI_UWREPORTS_INTM_EXT.policy_id%TYPE) 
   RETURN CHAR 
   IS
    v_acct_ent_date_i DATE;
    v_acct_ent_date_j DATE;
    v_incept_date_i DATE;
    v_incept_date_j DATE;
    v_issue_date_i DATE;
    v_issue_date_j DATE;
    BEGIN
    
        BEGIN
            SELECT TRUNC(acct_ent_date), TRUNC(incept_date), TRUNC(issue_date)
              INTO v_acct_ent_date_i, v_incept_date_i, v_issue_date_i
              FROM gipi_polbasic
             WHERE policy_id = pol_id_i;
            EXCEPTION
               WHEN NO_DATA_FOUND or TOO_MANY_ROWS THEN
                 NULL;
          END;
        
        BEGIN
            SELECT TRUNC(acct_ent_date), TRUNC(incept_date), TRUNC(issue_date)
              INTO v_acct_ent_date_j, v_incept_date_j, v_issue_date_j
              FROM gipi_polbasic
             WHERE policy_id = pol_id_i;
            EXCEPTION
               WHEN NO_DATA_FOUND or TOO_MANY_ROWS THEN
                 NULL;
          END;
        
      IF NVL(v_acct_ent_date_i,TO_DATE('01-JAN-2000','DD-MON-YYYY')) = NVL(v_acct_ent_date_j,TO_DATE('01-JAN-2000','DD-MON-YYYY')) AND 
          NVL(v_incept_date_i,TO_DATE('01-JAN-2000','DD-MON-YYYY')) = NVL(v_incept_date_j,TO_DATE('01-JAN-2000','DD-MON-YYYY')) 
          AND NVL(v_issue_date_i,TO_DATE('01-JAN-2000','DD-MON-YYYY')) = NVL(v_issue_date_j,TO_DATE('01-JAN-2000','DD-MON-YYYY')) THEN
          RETURN('T');
      ELSE
          RETURN('F');
      END IF;   
        
    END;
END gipir923a_pkg;
/
