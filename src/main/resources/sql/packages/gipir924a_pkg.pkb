CREATE OR REPLACE PACKAGE BODY CPI.GIPIR924A_PKG
AS
	/*
   **  Created by   :  Steven Ramirez
   **  Date Created : 05.09.2012
   **  Reference By : GIPIR924A - Underwriting Production Report(Detailed)
   **  Description  :
   */
	
	FUNCTION get_header_gipr924A (
      p_scope     gipi_uwreports_ext.SCOPE%TYPE,
      p_user_id   gipi_uwreports_ext.user_id%TYPE
   )
      RETURN header_tab PIPELINED
   AS
      rep   header_type;
   BEGIN
      rep.cf_company := gipir924A_pkg.cf_companyformula;
      rep.cf_company_address := gipir924A_pkg.cf_company_addressformula;
      rep.cf_heading3 := gipir924A_pkg.cf_heading3formula (p_user_id);
      rep.cf_based_on := gipir924A_pkg.cf_based_onformula (p_user_id, p_scope);
      PIPE ROW (rep);
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
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END;
   
   FUNCTION cf_heading3formula (p_user_id gipi_uwreports_ext.user_id%TYPE)
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
                  'For the Period of '
               || TO_CHAR (v_from_date, 'fmMonth dd, yyyy')
               || ' to '
               || TO_CHAR (v_to_date, 'fmMonth dd, yyyy');
         END IF;
      ELSE
         IF TO_CHAR (v_from_date, 'MMYYYY') = TO_CHAR (v_to_date, 'MMYYYY')
         THEN
            heading3 :=
                'For the Month of ' || TO_CHAR (v_from_date, 'fmMonth, yyyy');
         ELSE
            heading3 :=
                  'For the Period of '
               || TO_CHAR (v_from_date, 'fmMonth dd, yyyy')
               || ' to '
               || TO_CHAR (v_to_date, 'fmMonth dd, yyyy');
         END IF;
      END IF;

      RETURN (heading3);
   END;
   
   FUNCTION cf_based_onformula (
      p_user_id   gipi_uwreports_ext.user_id%TYPE,
      p_scope     gipi_uwreports_ext.SCOPE%TYPE
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
   
 FUNCTION populate_gipir924A(
      p_iss_param    GIPI_UWREPORTS_INTM_EXT.iss_cd%TYPE,
      p_iss_cd       GIPI_UWREPORTS_INTM_EXT.iss_cd%TYPE,
      p_scope        GIPI_UWREPORTS_INTM_EXT.SCOPE%TYPE,
      p_line_cd      GIPI_UWREPORTS_INTM_EXT.line_cd%TYPE,
      p_subline_cd   GIPI_UWREPORTS_INTM_EXT.subline_cd%TYPE,
	  p_assd_no		 GIPI_UWREPORTS_INTM_EXT.assd_no%TYPE,
	  p_intm_no		 GIPI_UWREPORTS_INTM_EXT.intm_no%TYPE,
      p_user_id      GIPI_UWREPORTS_INTM_EXT.user_id%TYPE
   )
      RETURN report_tab PIPELINED
   AS
      rep            report_type;
   BEGIN
      FOR i IN
         (
         -- jhing 08.13.2015 FGICWEB 17728 modified query based on changes on extraction and to be able to display correct
         -- amounts when the policy has multiple bill/invoices.
         /*SELECT 	assd_name, 
					line_cd,  
					line_name, 
					--subline_cd, 
					subline_name, 
					decode(p_iss_param,1,cred_branch,iss_cd) iss_cd, 
					SUM(NVL(total_tsi,0)) total_tsi,
              		SUM(NVL(total_prem,0)) total_prem, 
					SUM(NVL(evatprem,0)) evatprem, 
					SUM(NVL(fst,0)) fst,  
					SUM(NVL(lgt,0)) lgt,  
					SUM(NVL(doc_stamps,0)) doc_stamps,   
					SUM(NVL(other_taxes,0)) other_taxes,
              		SUM(NVL(other_charges,0)) other_charges, 
					param_date, 
					from_date, 
					to_date, 
					scope, 
					user_id, 
					count(policy_id) pol_count,
					SUM(NVL(TOTAL_PREM,0))+SUM(NVL(EVATPREM,0))+SUM(NVL(FST,0))+SUM(NVL(LGT,0))+SUM(NVL(DOC_STAMPS,0))+SUM(NVL(OTHER_TAXES,0))+SUM(NVL(OTHER_CHARGES,0)) total_charges
   		FROM  GIPI_UWREPORTS_INTM_EXT
			WHERE user_id = p_user_id -- marco - 01.30.2013 
			--AND iss_cd =NVL( :p_iss_cd, iss_cd)
				AND DECODE(p_iss_param,1,cred_branch,iss_cd) = NVL( p_iss_cd, DECODE(p_iss_param,1,cred_branch,iss_cd))
				AND line_cd =NVL( p_line_cd, line_cd)
				AND subline_cd =NVL( p_subline_cd, subline_cd)
				AND assd_no = NVL(p_assd_no, assd_no)
				AND intm_no = NVL(p_intm_no, intm_no)
				AND ((p_scope=3 AND endt_seq_no=endt_seq_no)
					OR  (p_scope=1 AND endt_seq_no=0)
					OR  (p_scope=2 AND endt_seq_no>0))
			    /* added security rights control by robert 01.02.14*/
			/*    AND check_user_per_iss_cd2 (line_cd,DECODE (p_iss_param,1, cred_branch,iss_cd),'GIPIS901A', p_user_id) =1
			    AND check_user_per_line2 (line_cd,DECODE (p_iss_param,1, cred_branch,iss_cd),'GIPIS901A', p_user_id) = 1
			    /* robert 01.02.14 end of added code */
			/*	GROUP BY assd_name, line_cd,  line_name, subline_cd, subline_name,decode(p_iss_param,1,cred_branch,iss_cd), param_date, from_date, to_date, scope, user_id*/
            -- jhing 08.13.2015 new query
             SELECT ab.assd_no,
                     ab.assd_name,
                     ab.line_name,
                     ab.subline_name,
                     ab.line_cd,
                     ab.subline_cd,
                     ab.iss_cd,
                     ab.endt_seq_no endt_seq_no_ab,rownum,ab.issue_yy,ab.pol_seq_no,ab.renew_no,ab.policy_id, --added by MarkS SR-21060 6.22.2016
                     COUNT (DISTINCT ab.policy_id) pol_count,
                     SUM (NVL (ab.total_tsi, 0)) total_tsi,
                     SUM (NVL (ab.total_prem, 0)) total_prem,
                     SUM (NVL (ab.evatprem, 0)) evatprem,
                     SUM (NVL (ab.fst, 0)) fst,
                     SUM (NVL (ab.lgt, 0)) lgt,
                     SUM (NVL (ab.doc_stamps, 0)) doc_stamps,
                     SUM (NVL (ab.other_taxes, 0)) other_taxes,
                     SUM (NVL (ab.total_charges, 0)) total_charges,
                     SUM (NVL (ab.other_charges, 0)) other_charges
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
                                total_charges,
                                NVL(x.other_charges,0) other_charges,
                             x.rec_type,
                             x.endt_seq_no endt_seq_no_x, --added by MarkS SR-21060 6.22.2016
                             1 pol_cnt
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
                     ab.line_cd,
                     ab.subline_cd,
                     ab.iss_cd,
                     ab.endt_seq_no,rownum,ab.issue_yy,ab.pol_seq_no,ab.renew_no,ab.policy_id --added by MarkS SR-21060 6.22.2016
                     )   
         LOOP
		 	rep.assd_name :=  i.assd_no || ' - ' || i.assd_name  ; -- jhing 08.13.2015 assd_name will be contenation of assd_no and assd_name  AFPGEN 19428 / FGIC 17728
            -- jhing 08.13.2015
            rep.assd_no := i.assd_no;
            rep.main_assd_name := i.assd_name; 
            -- end of added code  jhing 08.13.2015
            rep.line_cd := i.line_cd;
			rep.line_name := i.line_name;
            rep.subline_cd:= i.subline_cd;
			rep.subline_name:= i.subline_name;
            rep.iss_cd:= i.iss_cd;
            rep.total_tsi:= i.total_tsi;
            rep.total_prem:= i.total_prem;
            rep.evatprem:= i.evatprem;
            rep.fst:= i.fst;
            rep.lgt:= i.lgt;
            rep.doc_stamps:= i.doc_stamps;
            rep.other_taxes:= i.other_taxes;
            rep.other_charges:= i.other_charges;
            rep.total_charges:= i.total_charges;
			rep. cf_iss_header := gipir924A_pkg.cf_iss_headerformula(p_iss_param);      
			rep.cf_iss_name := gipir924A_pkg.cf_iss_nameformula(i.iss_cd);    
            
            IF NVL(GIISP.V('PRD_POL_CNT'), 1) = 1 THEN
                rep.pol_count:= i.pol_count;
            ELSIF NVL(GIISP.V('PRD_POL_CNT'), 1) = 2 THEN
                --edited by MarkS 6.22.2016 SR-21060
                IF i.endt_seq_no_ab != 0 THEN
                    rep.pol_count := 0;
                ELSE 
                    rep.pol_count := 1;
                END IF;
--               BEGIN
--                    SELECT COUNT (DISTINCT policy_id)
--                      INTO rep.pol_count
--                      FROM gipi_uwreports_intm_ext
--                     WHERE user_id = p_user_id
--                       AND DECODE (p_iss_param, 1, NVL (cred_branch, iss_cd), iss_cd) =
--                              NVL (p_iss_cd,
--                                   DECODE (p_iss_param, 1, NVL (cred_branch, iss_cd), iss_cd)
--                                  )
--                       AND line_cd = NVL (p_line_cd, line_cd)
--                       AND subline_cd = NVL (p_subline_cd, subline_cd)
--                       AND assd_no = NVL (p_assd_no, assd_no)
--                       AND intm_no = NVL (p_intm_no, intm_no)
--                       AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
--                            OR (p_scope = 1 AND endt_seq_no = 0)
--                            OR (p_scope = 2 AND endt_seq_no > 0))
--                       AND endt_seq_no = 0;
--                END;
                --END SR-21060    
            ELSIF NVL(GIISP.V('PRD_POL_CNT'), 1) = 3 THEN
                --Edited by MarkS 7.1.2016
                 rep.pol_count := 1;
                FOR j IN (
                SELECT ab.assd_no,
                     ab.assd_name,
                     ab.line_name,
                     ab.subline_name,
                     ab.line_cd,
                     ab.subline_cd,
                     ab.iss_cd,
                     ab.endt_seq_no endt_seq_no_ab,rownum,ab.issue_yy,ab.pol_seq_no,ab.renew_no,ab.policy_id, --added by MarkS SR-21060 6.22.2016
                     SUM (NVL (ab.total_tsi, 0)) total_tsi,
                     SUM (NVL (ab.total_prem, 0)) total_prem,
                     SUM (NVL (ab.evatprem, 0)) evatprem,
                     SUM (NVL (ab.fst, 0)) fst,
                     SUM (NVL (ab.lgt, 0)) lgt,
                     SUM (NVL (ab.doc_stamps, 0)) doc_stamps,
                     SUM (NVL (ab.other_taxes, 0)) other_taxes,
                     SUM (NVL (ab.total_charges, 0)) total_charges,
                     SUM (NVL (ab.other_charges, 0)) other_charges
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
                                total_charges,
                                NVL(x.other_charges,0) other_charges,
                             x.rec_type,
                             x.endt_seq_no endt_seq_no_x, --added by MarkS SR-21060 6.22.2016
                             1 pol_cnt
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
                     ab.line_cd,
                     ab.subline_cd,
                     ab.iss_cd,
                     ab.endt_seq_no,rownum,ab.issue_yy,ab.pol_seq_no,ab.renew_no,ab.policy_id --added by MarkS SR-21060 6.22.2016
                )
                LOOP
                    IF I.ROWNUM > J.ROWNUM THEN
                        IF i.line_cd =  j.line_cd AND
                           i.subline_cd = j.subline_cd AND
                           i.issue_yy = j.issue_yy AND
                           i.pol_seq_no = j.pol_seq_no AND
                           i.renew_no = j.renew_no AND
                           i.endt_seq_no_ab = j.endt_seq_no_ab AND
                           i.iss_cd = j.iss_cd  AND 
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
                --END sr-21060
--                BEGIN
--                    SELECT COUNT (pol_count)
--                      INTO rep.pol_count
--                      FROM (SELECT DISTINCT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
--                                            renew_no, 1 pol_count
--                                       FROM gipi_uwreports_intm_ext
--                                      WHERE user_id = p_user_id
--                                        AND DECODE (p_iss_param,
--                                                    1, NVL (cred_branch, iss_cd),
--                                                    iss_cd
--                                                   ) =
--                                               NVL (p_iss_cd,
--                                                    DECODE (p_iss_param,
--                                                            1, NVL (cred_branch, iss_cd),
--                                                            iss_cd
--                                                           )
--                                                   )
--                                        AND line_cd = NVL (p_line_cd, line_cd)
--                                        AND subline_cd = NVL (p_subline_cd, subline_cd)
--                                        AND assd_no = NVL (p_assd_no, assd_no)
--                                        AND intm_no = NVL (p_intm_no, intm_no)
--                                        AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
--                                             OR (p_scope = 1 AND endt_seq_no = 0)
--                                             OR (p_scope = 2 AND endt_seq_no > 0)
--                                            ));
--                END;     
            END IF;
            
            
         PIPE ROW (rep);
      END LOOP;

      RETURN;
   END populate_gipir924A; 
   
   FUNCTION cf_iss_headerformula(p_iss_param    GIPI_UWREPORTS_INTM_EXT.iss_cd%TYPE) 
   RETURN CHAR 
   IS
	BEGIN
	  IF p_iss_param = 1 THEN
		 RETURN ('Crediting Branch :');
	  ELSIF p_iss_param = 2 THEN
		 RETURN ('Issue Source     :');
	  ELSE 
		 RETURN NULL;
	  END IF;
	END;  
   
   FUNCTION cf_iss_nameformula(i_iss_cd		GIPI_UWREPORTS_INTM_EXT.iss_cd%TYPE) 
   RETURN CHAR 
   IS
	v_iss_name VARCHAR2(50);
	BEGIN
		BEGIN
			SELECT iss_name
			  INTO v_iss_name
			  FROM giis_issource
			 WHERE iss_cd = i_iss_cd;
			EXCEPTION
			   WHEN NO_DATA_FOUND or TOO_MANY_ROWS THEN
				 NULL;
	  	END;
	  RETURN(i_iss_cd||' - '||v_iss_name);  
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
			SELECT acct_ent_date, incept_date, issue_date
			  INTO v_acct_ent_date_i, v_incept_date_i, v_issue_date_i
			  FROM gipi_polbasic
			 WHERE policy_id = pol_id_i;
			EXCEPTION
			   WHEN NO_DATA_FOUND or TOO_MANY_ROWS THEN
				 NULL;
	  	END;
        
        BEGIN
			SELECT acct_ent_date, incept_date, issue_date
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
	
END gipir924A_pkg;
/
