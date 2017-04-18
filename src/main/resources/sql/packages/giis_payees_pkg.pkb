CREATE OR REPLACE PACKAGE BODY CPI.giis_payees_pkg
AS
   FUNCTION get_payee_details (p_extract_id gixx_polbasic.extract_id%TYPE)
      RETURN giis_payees_tab PIPELINED
   IS
      v_payee   giis_payees_type;
   BEGIN
      FOR i IN (SELECT a.extract_id, a.survey_agent_cd, b.survey_agent,
                       b.survey_addr, b.survey_phone, b.survey_fax,
                       c.settling_agent, c.settling_addr, c.settling_phone,
                       c.settling_fax
                  FROM gixx_polbasic a,
                       (SELECT payee_no, payee_last_name survey_agent,
                               DECODE (LENGTH (mail_addr1),
                                       1, NULL,
                                          mail_addr1
                                       || ' '
                                       || mail_addr2
                                       || ' '
                                       || mail_addr3
                                      ) survey_addr,
                               phone_no survey_phone, fax_no survey_fax
                          FROM giis_payees
                         WHERE payee_class_cd = giisp.v ('SURVEY_PAYEE_CLASS')) b,
                       (SELECT payee_no, payee_last_name settling_agent,
                               DECODE (LENGTH (mail_addr1),
                                       1, NULL,
                                          mail_addr1
                                       || ' '
                                       || mail_addr2
                                       || ' '
                                       || mail_addr3
                                      ) settling_addr,
                               phone_no settling_phone, fax_no settling_fax
                          FROM giis_payees
                         WHERE payee_class_cd =
                                              giisp.v ('SETTLING_PAYEE_CLASS')) c
                 WHERE a.survey_agent_cd = b.payee_no
                   AND a.settling_agent_cd = c.payee_no
                   AND a.extract_id = p_extract_id)
      LOOP
         v_payee.extract_id := i.extract_id;
         v_payee.survey_agent_cd := i.survey_agent_cd;
         v_payee.survey_agent := i.survey_agent;
         v_payee.survey_addr := i.survey_addr;
         v_payee.survey_phone := i.survey_phone;
         v_payee.survey_fax := i.survey_fax;
         v_payee.settling_agent := i.settling_agent;
         v_payee.settling_addr := i.settling_addr;
         v_payee.settling_phone := i.settling_phone;
         v_payee.settling_fax := i.settling_fax;
         PIPE ROW (v_payee);
      END LOOP;

      RETURN;
   END get_payee_details;

   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  09.21.2010
   **  Reference By : (GIACS039 - Direct Trans- Input Vat)
   **  Description  : CGFK$GVAT_PAYEE_CLASS_CD record group
   */
   FUNCTION get_payees_list
      RETURN payees_list_tab PIPELINED
   IS
      v_list   payees_list_type;
   BEGIN
      FOR a IN (SELECT   a1280.payee_class_cd payee_class_cd /* cg$fk */,
                         a1280.payee_no payee_no,
                         a1280.payee_first_name dsp_payee_first_name,
                         a1280.payee_middle_name dsp_payee_middle_name,
                         a1280.payee_last_name dsp_payee_last_name
                    FROM giis_payees a1280
                ORDER BY payee_class_cd,
                         dsp_payee_first_name,
                         dsp_payee_middle_name,
                         dsp_payee_last_name)
      --WHERE a1280.payee_class_cd = :gvat.payee_class_cd
      LOOP
         v_list.payee_class_cd := a.payee_class_cd;
         v_list.payee_no := a.payee_no;
         v_list.payee_first_name := a.dsp_payee_first_name;
         v_list.payee_middle_name := a.dsp_payee_middle_name;
         v_list.payee_last_name := a.dsp_payee_last_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  09.21.2010
   **  Reference By : (GIACS039 - Direct Trans- Input Vat)
   **  Description  : CGFK$GVAT_PAYEE_CLASS_CD record group
   */
   FUNCTION get_payees_list (
      p_payee_class_cd   giis_payees.payee_class_cd%TYPE,
      p_payee_name       VARCHAR2
   )
      RETURN payees_list_tab PIPELINED
   IS
      v_list   payees_list_type;
   BEGIN
      FOR a IN
         (SELECT   a1280.payee_class_cd payee_class_cd /* cg$fk */,
                   a1280.payee_no payee_no,
                   a1280.payee_first_name dsp_payee_first_name,
                   a1280.payee_middle_name dsp_payee_middle_name,
                   a1280.payee_last_name dsp_payee_last_name
              FROM giis_payees a1280
             WHERE (   UPPER (a1280.payee_first_name) LIKE
                                            UPPER ('%' || p_payee_name || '%')
                    OR UPPER (a1280.payee_middle_name) LIKE
                                            UPPER ('%' || p_payee_name || '%')
                    OR UPPER (a1280.payee_last_name) LIKE
                                            UPPER ('%' || p_payee_name || '%')
                   )
               AND a1280.payee_class_cd = p_payee_class_cd
          ORDER BY dsp_payee_first_name,
                   dsp_payee_middle_name,
                   dsp_payee_last_name)
      LOOP
         v_list.payee_class_cd := a.payee_class_cd;
         v_list.payee_no := a.payee_no;
         v_list.payee_first_name := a.dsp_payee_first_name;
         v_list.payee_middle_name := a.dsp_payee_middle_name;
         v_list.payee_last_name := a.dsp_payee_last_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   /*
   **  Created by   :  Emman
   **  Date Created :  12.01.2010
   **  Reference By : (GIACS022 - Other Trans- Wholding Tax)
   **  Description  : CGFK$GTWH_PAYEE__CD record group
   */
   FUNCTION get_payees_list (p_payee_class_cd giis_payees.payee_class_cd%TYPE)
      RETURN payees_list_tab PIPELINED
   IS
      v_list   payees_list_type;
   BEGIN
      FOR a IN (SELECT   a1280.payee_class_cd payee_class_cd /* cg$fk */,
                         a1280.payee_no payee_no,
                         a1280.payee_first_name dsp_payee_first_name,
                         a1280.payee_middle_name dsp_payee_middle_name,
                         a1280.payee_last_name dsp_payee_last_name
                    FROM giis_payees a1280
                   WHERE a1280.payee_class_cd = p_payee_class_cd
                ORDER BY dsp_payee_first_name,
                         dsp_payee_middle_name,
                         dsp_payee_last_name)
      LOOP
         v_list.payee_class_cd := a.payee_class_cd;
         v_list.payee_no := a.payee_no;
         v_list.payee_first_name := a.dsp_payee_first_name;
         v_list.payee_middle_name := a.dsp_payee_middle_name;
         v_list.payee_last_name := a.dsp_payee_last_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  11.09.2010
   **  Reference By : (GIPIS002 - Basic Information)
   **  Description  : SURVEY record group
   */
   FUNCTION get_survey_list
      RETURN survey_list_tab PIPELINED
   IS
      v_list   survey_list_type;
   BEGIN
      FOR a IN (SELECT   payee_no,
                            DECODE (payee_first_name,
                                    NULL, NULL,
                                    payee_first_name || ' '
                                   )
                         || DECODE (payee_middle_name,
                                    NULL, NULL,
                                    payee_middle_name || ' '
                                   )
                         || payee_last_name payee_name
                    FROM giis_payees
                   WHERE payee_class_cd =
                                   (SELECT param_value_v
                                      FROM giis_parameters
                                     WHERE param_name = 'SURVEY_PAYEE_CLASS')
                ORDER BY UPPER (payee_first_name),
                         UPPER (payee_middle_name),
                         UPPER (payee_last_name))
      LOOP
         v_list.payee_no := a.payee_no;
         v_list.nbt_payee_name := a.payee_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  11.09.2010
   **  Reference By : (GIPIS002 - Basic Information)
   **  Description  : SETTLING record group
   */
   FUNCTION get_settling_list
      RETURN survey_list_tab PIPELINED
   IS
      v_list   survey_list_type;
   BEGIN
      FOR a IN (SELECT   payee_no,
                            DECODE (payee_first_name,
                                    NULL, NULL,
                                    payee_first_name || ' '
                                   )
                         || DECODE (payee_middle_name,
                                    NULL, NULL,
                                    payee_middle_name || ' '
                                   )
                         || payee_last_name payee_name
                    FROM giis_payees
                   WHERE payee_class_cd =
                                 (SELECT param_value_v
                                    FROM giis_parameters
                                   WHERE param_name = 'SETTLING_PAYEE_CLASS')
                ORDER BY UPPER (payee_first_name),
                         UPPER (payee_middle_name),
                         UPPER (payee_last_name))
      LOOP
         v_list.payee_no := a.payee_no;
         v_list.nbt_payee_name := a.payee_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  11.11.2010
   **  Reference By : (GIPIS002 - Basic Information)
   **  Description  : COMPANY_RG record group
   */
   FUNCTION get_company_list
      RETURN survey_list_tab PIPELINED
   IS
      v_list   survey_list_type;
   BEGIN
      FOR a IN (SELECT   payee_no company_cd,
                            payee_last_name
                         || DECODE (payee_first_name,
                                    NULL, NULL,
                                       ', '
                                    || payee_first_name
                                    || ' '
                                    || payee_middle_name
                                   ) company_desc
                    FROM giis_payees
                   WHERE payee_class_cd =
                                     (SELECT param_value_v
                                        FROM giac_parameters
                                       WHERE param_name = 'COMPANY_CLASS_CD')
                ORDER BY 2)
      LOOP
         v_list.payee_no := a.company_cd;
         v_list.nbt_payee_name := a.company_desc;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  11.11.2010
   **  Reference By : (GIPIS002 - Basic Information)
   **  Description  : EMP_RG record group
   */
   FUNCTION get_employee_list (p_company_cd giis_payees.master_payee_no%TYPE)
      RETURN employee_list_tab PIPELINED
   IS
      v_list   employee_list_type;
   BEGIN
      FOR a IN (SELECT   ref_payee_cd employee_cd,
                            payee_last_name
                         || DECODE (payee_first_name,
                                    NULL, NULL,
                                       ', '
                                    || payee_first_name
                                    || ' '
                                    || payee_middle_name
                                   ) emp_name,
                         payee_no emp_no, master_payee_no master_emp_no
                    FROM giis_payees
                   WHERE payee_class_cd =
                                         (SELECT param_value_v
                                            FROM giac_parameters
                                           WHERE param_name = 'EMP_CLASS_CD')
                     AND master_payee_no = NVL (p_company_cd, master_payee_no)
                     AND ref_payee_cd IS NOT NULL
                ORDER BY 2)
      LOOP
         v_list.employee_cd := a.employee_cd;
         v_list.emp_name := a.emp_name;
         v_list.emp_no := a.emp_no;
         v_list.master_emp_no := a.master_emp_no;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   /*
   **  Created by   :  Emman
   **  Date Created :  11.30.2010
   **  Reference By : (GIACS02 - Other Trans- Wholding Tax)
   **  Description  : Gets the Payee first name, middle name, and last name with specified payee_class_cd and payee_no
   */
   PROCEDURE get_payee_name (
      p_payee_class_cd      IN       giis_payees.payee_class_cd%TYPE,
      p_payee_no            IN       giis_payees.payee_no%TYPE,
      p_payee_first_name    OUT      giis_payees.payee_first_name%TYPE,
      p_payee_middle_name   OUT      giis_payees.payee_middle_name%TYPE,
      p_payee_last_name     OUT      giis_payees.payee_last_name%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT payee_first_name, payee_middle_name, payee_last_name
                  FROM giis_payees
                 WHERE payee_class_cd = p_payee_class_cd
                   AND payee_no = p_payee_no)
      LOOP
         p_payee_first_name := i.payee_first_name;
         p_payee_middle_name := i.payee_middle_name;
         p_payee_last_name := i.payee_last_name;
      END LOOP;
   END;

	/* Edited by	 : niknok 
	** Date Modified : 06.04.2012
	** Reference By : (GIACS016 - Disbursement)
	** Description   : uncomment payee_class_cd
	*/
   FUNCTION get_all_payees
      RETURN all_payees_tab PIPELINED
   IS
      v_payee   all_payees_type;
   BEGIN
      FOR a IN (SELECT DISTINCT a.class_desc , a.payee_class_cd
                           FROM giis_payee_class a, giis_payees b
                          WHERE a.payee_class_cd = b.payee_class_cd
                       ORDER BY a.class_desc)
      LOOP
         v_payee.class_desc := a.class_desc;
         v_payee.payee_class_cd := a.payee_class_cd;
         PIPE ROW (v_payee);
      END LOOP;
   END;

   FUNCTION get_payee_class
      RETURN all_payees_tab PIPELINED
   IS
      v_payee_class   all_payees_type;
   BEGIN
      FOR a IN (SELECT payee_class_cd, class_desc
                  FROM giis_payee_class)
      LOOP
         v_payee_class.payee_class_cd := a.payee_class_cd;
         v_payee_class.class_desc := a.class_desc;
         PIPE ROW (v_payee_class);
      END LOOP;
   END;
   
   --added by MarkS SR-5862 12.12.2016 optimization
   FUNCTION get_payee_class_giacs240_LOV(
      p_find_text       VARCHAR2,
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from            NUMBER,
      p_to              NUMBER,
      p_search_string   VARCHAR2
      )
      RETURN all_payees_tab_giacs240_LOV PIPELINED
   IS
      v_payee_class   all_payees_type_giacs240_LOV;
      TYPE cur_type IS REF CURSOR;
      c                 cur_type;
      v_rec             all_payees_type_giacs240_LOV;
      v_sql             VARCHAR2(32767);
   BEGIN
      --added by MarkS SR-5862 12.12.2016 optimization
       v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (SELECT payee_class_cd, class_desc
                            FROM giis_payee_class
                            WHERE 1=1 ';
      IF p_find_text IS NOT NULL
      THEN
        v_sql := v_sql || ' AND(UPPER(payee_class_cd) LIKE UPPER('''|| p_find_text ||''') 
								 OR UPPER(class_desc) LIKE UPPER('''|| p_find_text ||''')) ';
      ELSE
        v_sql := v_sql || ' AND(UPPER(payee_class_cd) LIKE UPPER('''|| p_search_string ||''') 
								 OR UPPER(class_desc) LIKE UPPER('''|| p_search_string ||''')) ';                                 
      END IF;
      
      IF p_order_by IS NOT NULL
        THEN

        IF p_order_by = 'payeeClassCd'
        THEN        
            v_sql := v_sql || ' ORDER BY payee_class_cd ';
        ELSIF p_order_by = 'classDesc'
        THEN
            v_sql := v_sql || ' ORDER BY class_desc ';          
        END IF;        
        
        IF p_asc_desc_flag IS NOT NULL
        THEN
           v_sql := v_sql || p_asc_desc_flag;
        ELSE
           v_sql := v_sql || ' ASC';
        END IF; 
      END IF;
      v_sql := v_sql ||      ') innersql';            
      v_sql := v_sql || '
                            ) outersql
                         ) mainsql
                    WHERE rownum_ BETWEEN '|| p_from ||' AND ' || p_to;                           
       
      OPEN c FOR v_sql;
      LOOP
         FETCH c INTO v_rec.count_, 
                      v_rec.rownum_, 
                      v_rec.payee_class_cd,
                      v_rec.class_desc;                            
         EXIT WHEN c%NOTFOUND;     
         PIPE ROW (v_rec);
      END LOOP;
      
      CLOSE c;                                     
      -------------------------
      -------------------------  
--    commented out By markS 12.12.2016 SR5862 optimization                    
--      FOR a IN (SELECT payee_class_cd, class_desc
--                  FROM giis_payee_class)
--      LOOP
--         v_payee_class.payee_class_cd := a.payee_class_cd;
--         v_payee_class.class_desc := a.class_desc;
--         PIPE ROW (v_payee_class);
--      END LOOP;
   END;

   FUNCTION get_payees_by_item_no_class_cd (
      p_payee_class_cd   giis_payee_class.payee_class_cd%TYPE,
      p_claim_id         gicl_claims.claim_id%TYPE,
      p_item_no          NUMBER
   )
      RETURN payee_names_by_class_cd_tab PIPELINED
   IS
      v_payees   payee_names_by_class_cd_type;
   BEGIN
      FOR i IN (SELECT a.payee_no, payee_last_name
                   || DECODE (payee_first_name,
                              NULL, NULL,
                              ',' || payee_first_name
                             )
                   || DECODE (payee_middle_name,
                              NULL, NULL,
                              '' || payee_middle_name || '.'
                             ) payee_name,
                       (a.mail_addr1 || ' ' || a.mail_addr2 || ' '
                        || a.mail_addr3
                       ) address
                  FROM giis_payees a
                 WHERE payee_class_cd = p_payee_class_cd
                   AND payee_no NOT IN (
                          SELECT payee_no
                            FROM gicl_mc_tp_dtl
                           WHERE claim_id = p_claim_id
                             AND item_no = p_item_no
                             AND payee_class_cd = p_payee_class_cd))
      LOOP
         v_payees.payee_name := i.payee_name;
         v_payees.payee_no := i.payee_no;
         v_payees.address := i.address;
         pipe row(v_payees);
      END LOOP;
   END;

   FUNCTION get_payee_names_by_class_desc (p_send_to_cd VARCHAR2)
      RETURN payee_names_by_class_tab PIPELINED
   IS
      v_payee   payee_names_by_class_type;
   BEGIN
      FOR i IN (SELECT   a.payee_last_name,
                         (   a.mail_addr1
                          || ' '
                          || a.mail_addr2
                          || ' '
                          || a.mail_addr3
                         ) address,
                         a.contact_pers attention
                    FROM giis_payees a, giis_payee_class b
                   WHERE a.payee_class_cd = b.payee_class_cd
                     AND b.class_desc = UPPER (p_send_to_cd)
                ORDER BY payee_last_name)
      LOOP
         v_payee.payee_last_name := i.payee_last_name;
         v_payee.address := i.address;
         v_payee.attention := i.attention;
         PIPE ROW (v_payee);
      END LOOP;
   END;

   FUNCTION get_payee_by_adjuster_listing
      RETURN survey_list_tab PIPELINED
   IS
      v_payee   survey_list_type;
   BEGIN
      FOR i IN (SELECT DISTINCT (a.payee_no),
                                   a.payee_last_name
                                || DECODE (a.payee_first_name,
                                           NULL, NULL,
                                           ', ' || a.payee_first_name
                                          )
                                || DECODE (a.payee_middle_name,
                                           NULL, NULL,
                                           '-' || a.payee_middle_name
                                          ) payee_name
                           FROM giis_payees a, giis_adjuster c
                          WHERE a.payee_class_cd = giacp.v ('ADJP_CLASS_CD')
                            AND a.payee_no = c.adj_company_cd(+))
      LOOP
         v_payee.payee_no := i.payee_no;
         v_payee.nbt_payee_name := i.payee_name;
         PIPE ROW (v_payee);
      END LOOP;
   END;
 
   /*
   **  Created by   : Gzelle
   **  Date Created : 02.20.2013
   **  Description  : LOV for GICLS257 with search field
   */   
   FUNCTION get_payee_by_adj_lov(p_payee GIIS_ADJUSTER.payee_name%TYPE)
      RETURN survey_list_tab PIPELINED
   IS
      v_payee   survey_list_type;
   BEGIN
      FOR i IN (SELECT DISTINCT (a.payee_no),
                                   a.payee_last_name
                                || DECODE (a.payee_first_name,
                                           NULL, NULL,
                                           ', ' || a.payee_first_name
                                          )
                                || DECODE (a.payee_middle_name,
                                           NULL, NULL,
                                           '-' || a.payee_middle_name
                                          ) payee_name
                           FROM giis_payees a, giis_adjuster c
                          WHERE a.payee_class_cd = giacp.v ('ADJP_CLASS_CD')
                            AND a.payee_no = c.adj_company_cd(+)
                            AND ((a.payee_last_name || DECODE (a.payee_first_name,NULL, NULL, ', ' || a.payee_first_name)
                                   || DECODE (a.payee_middle_name, NULL, NULL, '-' || a.payee_middle_name )) LIKE UPPER(NVL(p_payee, '%'))
                                 OR UPPER(a.payee_no) LIKE UPPER(NVL(p_payee, '%'))
                                )
               )
      LOOP
         v_payee.payee_no := i.payee_no;
         v_payee.nbt_payee_name := i.payee_name;
         PIPE ROW (v_payee);
      END LOOP;
   END;   

   FUNCTION get_payee_by_adjuster_listing2 (
      p_adj_company_cd   giis_adjuster.adj_company_cd%TYPE,
      p_claim_id         gicl_claims.claim_id%TYPE
   )
      RETURN payee_adj_list_tab PIPELINED
   IS
      v_payee   payee_adj_list_type;
   BEGIN
      FOR i IN (SELECT a.priv_adj_cd, a.payee_name
                  FROM giis_adjuster a
                 WHERE a.adj_company_cd = p_adj_company_cd
                   AND NOT EXISTS (
                          SELECT '1'
                            FROM gicl_clm_adjuster b
                           WHERE b.adj_company_cd = a.adj_company_cd
                             AND b.priv_adj_cd = a.priv_adj_cd
                             AND NVL (b.cancel_tag, 'N') = 'N'
                             AND NVL (b.delete_tag, 'N') = 'N'
                             AND b.claim_id = p_claim_id))
      LOOP
         v_payee.priv_adj_cd := i.priv_adj_cd;
         v_payee.payee_name := i.payee_name;
         PIPE ROW (v_payee);
      END LOOP;
   END;
   
   /*
   **  Created by   : Belle Bebing
   **  Date Created : 10.20.2011
   **  Reference By : (GICLS041 - Print Documents)
   **  Description  : Signatory_Grp - when-radio-changed, TP_LOV record group
   */ 
    FUNCTION get_tpclaimant_lov (
        p_claim_id     GICL_CLAIMS.claim_id%TYPE,
        p_signatory    VARCHAR2
    )
        RETURN payees_list_tab PIPELINED
    IS
        v_list  payees_list_type;
        v_check NUMBER :=0;
    BEGIN 
        BEGIN
            SELECT 1
             INTO v_check
             FROM (SELECT DISTINCT payee_last_name||DECODE(payee_first_name,NULL,NULL,','||payee_first_name)||DECODE(payee_middle_name,NULL,NULL,' '||payee_middle_name||'.') payee_name, 1
                     FROM giis_payees a,
                          GICL_MC_TP_DTL b 
                    WHERE a.payee_class_cd = b.payee_class_cd
                      AND a.payee_no = b.payee_no
                      AND claim_id = p_claim_id) A
            WHERE a.payee_name = p_signatory;
                                
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
            v_check :=0;
        END;         
                
        IF v_check = 0 THEN
            FOR i IN (SELECT DISTINCT payee_last_name||DECODE(payee_first_name,NULL,NULL,','||payee_first_name)||DECODE(payee_middle_name,NULL,NULL,'     '||payee_middle_name||'.') payee_name
                        FROM giis_payees a,
                             gicl_mc_tp_dtl b 
                       WHERE a.payee_class_cd = b.payee_class_cd
                         AND a.payee_no = b.payee_no
                         AND claim_id = p_claim_id)
            LOOP
                v_list.payee_last_name := i.payee_name;
                PIPE ROW (v_list);
            END LOOP;
        END IF;    
    END;
    
    /*
   **  Created by   :  Veronica V. Raymundo
   **  Date Created : 12.09.2011
   **  Reference By : (GICLS043 - Batch Claim Settlement Request)
   **  Description  : Retrieves records from giis_payees with the same payee_class_cd
   **                 Or retrieves all records when parameter is null
   */ 
    FUNCTION get_giis_payees_list (
      p_payee_class_cd   giis_payees.payee_class_cd%TYPE,
      p_payee_name       VARCHAR2
   )
   RETURN giis_payees_list_tab PIPELINED AS
      
    v_list   giis_payees_list_type;
    
   BEGIN
      FOR a IN
         (  SELECT payee_no, payee_class_cd, designation, 
                   payee_last_name, payee_first_name, payee_middle_name,
                   payee_last_name || DECODE(SIGN(NVL(LENGTH(payee_first_name),0)+ NVL(LENGTH(payee_middle_name),0)-1),-1,' ',',') || 
                   payee_first_name || ' ' || payee_middle_name payee_name, 
                   mail_addr1 || ' ' || mail_addr2 || ' ' || mail_addr3 mail_addr,
                   phone_no, contact_pers 
            FROM GIIS_PAYEES 
            WHERE UPPER(payee_class_cd) = UPPER(NVL(p_payee_class_cd, payee_class_cd))
            AND ( UPPER (payee_first_name) LIKE
                                       UPPER ('%' || p_payee_name || '%')
                  OR UPPER (payee_middle_name) LIKE
                                       UPPER ('%' || p_payee_name || '%')
                  OR UPPER (payee_last_name) LIKE
                                       UPPER ('%' || p_payee_name || '%')
                   ) 
            ORDER BY payee_no)
      LOOP
          v_list.payee_class_cd      :=  a.payee_class_cd; 
          v_list.payee_no            :=  a.payee_no;
          v_list.payee_first_name    :=  a.payee_first_name;
          v_list.payee_middle_name   :=  a.payee_middle_name;
          v_list.payee_last_name     :=  a.payee_last_name;
          v_list.nbt_payee_name      :=  a.payee_name;
          v_list.designation         :=  a.designation;
          v_list.mail_addr           :=  a.mail_addr;
          v_list.phone_no            :=  a.phone_no;
          v_list.contact_pers        :=  a.contact_pers;
         
          PIPE ROW (v_list);
         
      END LOOP;

      
   END;
   
   /*
   **  Created by   :  D.Alcantara
   **  Date Created : 12.14.2011
   **  Reference By : (GICLS055 - Generate Recovery Attg. Entries)
   **  Description  : Retrieves the payor name for the selected record from gicl_recovery_payt
   */ 
   FUNCTION get_payee_whole_name (
        p_payee_class_cd       giis_payees.payee_class_cd%TYPE,
        p_payee_no             giis_payees.payee_no%TYPE
   ) RETURN VARCHAR2 IS
        v_payor     VARCHAR2(600); -- changed by robert from 300 to 600 11.15.2013
   BEGIN
        FOR p IN
            (SELECT payee_last_name||decode(payee_first_name,NULL,NULL,
                    ', '||payee_first_name)||decode(payee_middle_name,NULL,NULL,
                    ' '||substr(payee_middle_name,1,1)||'.') payor
               FROM giis_payees
              WHERE payee_class_cd = p_payee_class_cd
                AND payee_no       = p_payee_no)
        LOOP 
            v_payor := p.payor; 
        END LOOP;
        RETURN v_payor;
   END get_payee_whole_name;
   
   /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 02.22.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Gets list of payees for Loss/Expense History 
    */

    FUNCTION get_loss_exp_payees_list (
     p_payee_class_cd   GIIS_PAYEES.payee_class_cd%TYPE,
     p_assd_no          GIIS_PAYEES.payee_no%TYPE,
     p_claim_id         GICL_CLAIMS.claim_id%TYPE,
     p_item_no          GICL_ITEM_PERIL.item_no%TYPE,
     p_peril_cd         GICL_ITEM_PERIL.peril_cd%TYPE,
     p_payee_type       GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
     p_find_text       	VARCHAR2 --editted by steven 11/19/2012
    )

    RETURN giis_payees_list_tab PIPELINED AS
          
    v_list   giis_payees_list_type;
    v_intm_class  giac_parameters.param_value_v%TYPE;

    BEGIN
       BEGIN
          SELECT param_value_v
            INTO v_intm_class
            FROM giac_parameters
           WHERE param_name = 'INTM_CLASS_CD';
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             v_intm_class := NULL;
       END;
      
       IF v_intm_class = p_payee_class_cd
       THEN
        FOR i IN (SELECT a.payee_no, a.payee_class_cd, a.payee_last_name
                    FROM giis_payees a, giis_intermediary b
                   WHERE a.allow_tag = 'Y'
                     AND a.payee_no = b.intm_no
                     AND a.payee_class_cd = p_payee_class_cd
                     AND (b.intm_no IN (
                             SELECT c.intrmdry_intm_no
                               FROM gipi_comm_invoice c, gicl_claims d, gipi_polbasic e
                              WHERE c.policy_id = e.policy_id
                                AND d.line_cd = e.line_cd
                                AND d.subline_cd = e.subline_cd
                                AND d.iss_cd = e.iss_cd
                                AND d.issue_yy = e.issue_yy
                                AND d.pol_seq_no = e.pol_seq_no
                                AND d.renew_no = e.renew_no
                                AND d.claim_id = p_claim_id)
                         )
                     AND NOT EXISTS (
                            SELECT '1'
                              FROM gicl_loss_exp_payees f
                             WHERE f.claim_id = p_claim_id 
                               AND f.payee_type = p_payee_type 
                               AND f.item_no = p_item_no 
                               AND f.peril_cd = p_peril_cd 
                               AND f.payee_cd = a.payee_no
                               AND f.payee_class_cd = a.payee_class_cd)
                     AND ( UPPER (a.payee_first_name) LIKE UPPER ('%' || p_find_text || '%')
                        OR UPPER (a.payee_middle_name) LIKE UPPER ('%' || p_find_text || '%')
                        OR UPPER (a.payee_last_name) LIKE UPPER ('%' || p_find_text || '%')
						OR a.payee_no  LIKE '%' || p_find_text || '%')  --added by steven 11/19/2012
                ORDER BY payee_no)
        
        LOOP
            v_list.payee_class_cd      :=  i.payee_class_cd; 
            v_list.payee_no            :=  i.payee_no;
            v_list.nbt_payee_name      :=  i.payee_last_name;
            PIPE ROW (v_list);
        END LOOP;
       ELSE
        FOR i IN (SELECT a.payee_no, b.payee_class_cd, a.payee_first_name,
                         a.payee_last_name, a.payee_middle_name,
                         DECODE(a.payee_first_name,NULL,a.payee_last_name, 
                             a.payee_last_name||', '||a.payee_first_name 
                             ||' '||a.payee_middle_name) payee
                 FROM GIIS_PAYEES a,GIIS_PAYEE_CLASS b  
                WHERE a.payee_class_cd = b.payee_class_cd
                  AND a.allow_tag = 'Y'
                  AND a.payee_class_cd = p_payee_class_cd
                  AND DECODE(p_payee_class_cd, GIACP.n('ASSURED_PAYEE_CLASS'), p_assd_no, a.payee_no) = a.payee_no
                  AND NOT EXISTS (SELECT '1'
                                    FROM GICL_LOSS_EXP_PAYEES c
                                   WHERE c.claim_id = p_claim_id
                                     AND c.payee_type = p_payee_type
                                     AND c.payee_class_cd = p_payee_class_cd
                                     AND c.item_no = p_item_no
                                     AND c.peril_cd = p_peril_cd
                                     AND c.payee_cd =  a.payee_no
                                     AND c.payee_class_cd = a.payee_class_cd)
                  AND ( UPPER (a.payee_first_name) LIKE UPPER ('%' || p_find_text || '%')
                        OR UPPER (a.payee_middle_name) LIKE UPPER ('%' || p_find_text || '%')
                        OR UPPER (a.payee_last_name) LIKE UPPER ('%' || p_find_text || '%')
						OR a.payee_no  LIKE '%' || p_find_text || '%')  --added by steven 11/19/2012
                  ORDER BY payee_no)
        
        LOOP
            v_list.payee_class_cd      :=  i.payee_class_cd; 
            v_list.payee_no            :=  i.payee_no;
            v_list.payee_first_name    :=  i.payee_first_name;
            v_list.payee_middle_name   :=  i.payee_middle_name;
            v_list.payee_last_name     :=  i.payee_last_name;
            v_list.nbt_payee_name      :=  i.payee;
            
            PIPE ROW (v_list);
            
        END LOOP;
       END IF;          

    END get_loss_exp_payees_list;
    
    FUNCTION get_all_loss_exp_payees_list (
     p_payee_class_cd   GIIS_PAYEES.payee_class_cd%TYPE,
     p_assd_no          GIIS_PAYEES.payee_no%TYPE,
     p_claim_id         GICL_CLAIMS.claim_id%TYPE,
     p_item_no          GICL_ITEM_PERIL.item_no%TYPE,
     p_peril_cd         GICL_ITEM_PERIL.peril_cd%TYPE,
     p_payee_type       GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
     p_find_text       	VARCHAR2 
    )

    RETURN giis_payees_list_tab PIPELINED AS
          
    v_list   giis_payees_list_type;

    BEGIN
        FOR i IN (SELECT a.payee_no, b.payee_class_cd, a.payee_first_name,
                         a.payee_last_name, a.payee_middle_name,
                         DECODE(a.payee_first_name,NULL,a.payee_last_name, 
                             a.payee_last_name||', '||a.payee_first_name 
                             ||' '||a.payee_middle_name) payee
                 FROM GIIS_PAYEES a,GIIS_PAYEE_CLASS b  
                WHERE a.payee_class_cd = b.payee_class_cd
                  AND a.allow_tag = 'Y'
                  AND a.payee_class_cd = p_payee_class_cd
                  AND DECODE(p_payee_class_cd, GIACP.n('ASSURED_PAYEE_CLASS'), p_assd_no, a.payee_no) = a.payee_no
                  AND ( UPPER (a.payee_first_name) LIKE UPPER ('%' || p_find_text || '%')
                        OR UPPER (a.payee_middle_name) LIKE UPPER ('%' || p_find_text || '%')
                        OR UPPER (a.payee_last_name) LIKE UPPER ('%' || p_find_text || '%')
						OR a.payee_no  LIKE '%' || p_find_text || '%')
                  ORDER BY payee_no)
        
        LOOP
            v_list.payee_class_cd      :=  i.payee_class_cd; 
            v_list.payee_no            :=  i.payee_no;
            v_list.payee_first_name    :=  i.payee_first_name;
            v_list.payee_middle_name   :=  i.payee_middle_name;
            v_list.payee_last_name     :=  i.payee_last_name;
            v_list.nbt_payee_name      :=  i.payee;
            
            PIPE ROW (v_list);
            
        END LOOP;          

    END get_all_loss_exp_payees_list;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 02.22.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Gets list of mortgagees for Loss/Expense History 
    */

    FUNCTION get_loss_exp_mortg_list (
     p_payee_class_cd   GIIS_PAYEES.payee_class_cd%TYPE,
     p_claim_id         GICL_CLAIMS.claim_id%TYPE,
     p_item_no          GICL_ITEM_PERIL.item_no%TYPE,
     p_peril_cd         GICL_ITEM_PERIL.peril_cd%TYPE,
     p_payee_type       GICL_LOSS_EXP_PAYEES.payee_type%TYPE
    )

    RETURN giis_payees_list_tab PIPELINED AS
          
    v_list   giis_payees_list_type;

    BEGIN
        FOR i IN (SELECT DISTINCT a.payee_class_cd, 
                                  a.payee_no,  a.payee_last_name
                      FROM GIIS_PAYEES a,
                           GIIS_MORTGAGEE b,
                           GICL_MORTGAGEE c
                     WHERE b.mortg_cd = c.mortg_cd
                       AND a.allow_tag = 'Y'
                       AND b.iss_cd = c.iss_cd
                       AND a.payee_no = b.mortgagee_id
                       AND a.payee_class_cd = p_payee_class_cd
                       AND c.claim_id = p_claim_id
                       AND (c.item_no = 0 OR c.item_no = NVL(p_item_no,item_no))
                       AND NOT EXISTS (SELECT '1'
                                         FROM GICL_LOSS_EXP_PAYEES d
                                        WHERE d.claim_id = p_claim_id
                                          AND d.payee_type = p_payee_type
                                          AND d.item_no = p_item_no
                                          AND d.peril_cd = p_peril_cd
                                          AND d.payee_cd =  a.payee_no
                                          AND d.payee_class_cd = a.payee_class_cd)
                  ORDER BY payee_no)
        LOOP
            v_list.payee_class_cd      :=  i.payee_class_cd; 
            v_list.payee_no            :=  i.payee_no;
            v_list.payee_last_name     :=  i.payee_last_name;
            
            PIPE ROW (v_list);
            
        END LOOP;
        
    END get_loss_exp_mortg_list;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 02.22.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Gets list of adjusters for Loss/Expense History 
    */

    FUNCTION get_loss_exp_adjuster_list (
     p_payee_class_cd   GIIS_PAYEES.payee_class_cd%TYPE,
     p_claim_id         GICL_CLAIMS.claim_id%TYPE,
     p_item_no          GICL_ITEM_PERIL.item_no%TYPE,
     p_peril_cd         GICL_ITEM_PERIL.peril_cd%TYPE,
     p_payee_type       GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
     p_payee_name       VARCHAR2
    )

    RETURN payee_adjuster_list_tab PIPELINED AS
          
    v_payee   payee_adjuster_list_type;

    BEGIN
        FOR i IN (SELECT DISTINCT(a.adj_company_cd) adj_company_cd, b.payee_last_name||
                         DECODE(b.payee_first_name, NULL, NULL, ','||b.payee_first_name)||
                         DECODE(b.payee_middle_name, NULL, NULL, '-'|| b.payee_middle_name) adj_co_name,
                         c.priv_adj_cd, c.payee_name, b.payee_last_name, b.payee_first_name, b.payee_middle_name
                  FROM GICL_CLM_ADJUSTER a, 
                       GIIS_PAYEES b, 
                       GIIS_ADJUSTER c
                 WHERE a.claim_id             = p_claim_id
                   AND b.allow_tag = 'Y'
                   AND NVL(a.delete_tag, 'N') = 'N'
                   AND NVL(a.cancel_tag, 'N') = 'N'
                   AND b.payee_class_cd       = GIACP.v('ADJP_CLASS_CD')
                   AND a.adj_company_cd       = b.payee_no
                   AND a.priv_adj_cd          = c.priv_adj_cd (+)
                   AND a.adj_company_cd       = c.adj_company_cd (+)
                   AND NOT EXISTS (SELECT '1'
                                     FROM GICL_LOSS_EXP_PAYEES d
                                    WHERE d.claim_id = p_claim_id
                                      AND d.payee_type = p_payee_type
                                      AND d.payee_class_cd = p_payee_class_cd
                                      AND d.item_no = p_item_no
                                      AND d.peril_cd = p_peril_cd
                                      AND d.payee_cd = a.adj_company_cd
                                      AND d.payee_class_cd = b.payee_class_cd)
                AND ( UPPER (b.payee_first_name) LIKE UPPER ('%' || p_payee_name || '%')
                    OR UPPER (b.payee_middle_name) LIKE UPPER ('%' || p_payee_name || '%')
                    OR UPPER (b.payee_last_name) LIKE UPPER ('%' || p_payee_name || '%'))
                ORDER BY adj_company_cd)
                                      
        LOOP
           v_payee.adj_company_cd   := i.adj_company_cd;
           v_payee.adj_co_name      := i.adj_co_name;
           v_payee.priv_adj_cd      := i.priv_adj_cd;
           v_payee.payee_name       := i.payee_name;
           
           PIPE ROW (v_payee);
           
        END LOOP;  
    END get_loss_exp_adjuster_list;
    
    /*
    **  Created by    : Niknok Orio  
    **  Date Created  : 03.14.2012
    **  Reference By  : GICLS025 - Recovery Information 
    **  Description   : Gets list of Lawyer  
    */    
    FUNCTION get_lawyer_list (
       p_lawyer VARCHAR2
    )
    RETURN lawyer_tab PIPELINED IS
      v_list    lawyer_type;
    BEGIN
        FOR i IN (SELECT a.payee_no lawyer_cd, a.payee_class_cd lawyer_class_cd,
                         UPPER(a.payee_first_name||' '|| a.payee_middle_name ||' '||a.payee_last_name) lawyer_name
                    FROM giis_payees a
                   WHERE a.payee_class_cd IN (SELECT param_value_v  
                                                FROM giac_parameters
                                               WHERE param_name = 'LAWYER_CLASS_CD')
                    --editted: John Dolon 6/26/2013
                    AND (UPPER(regexp_replace(a.payee_first_name||' '|| a.payee_middle_name ||' '||a.payee_last_name, '[[:space:]]', '')) LIKE NVL(UPPER(regexp_replace(p_lawyer, '[[:space:]]', '')),'%')
                         OR a.payee_no LIKE NVL(p_lawyer,'%')) 
                    --end
                ORDER BY a.payee_first_name||' '|| a.payee_middle_name ||' '||a.payee_last_name)
        LOOP
          v_list.lawyer_cd           := i.lawyer_cd;
          v_list.lawyer_class_cd     := i.lawyer_class_cd;
          v_list.lawyer_name         := i.lawyer_name;
          PIPE ROW(v_list);
        END LOOP;
      RETURN;   
    END;
      
    /*
    **  Created by    : Niknok Orio  
    **  Date Created  : 03.22.2012
    **  Reference By  : GICLS025 - Recovery Information 
    **  Description   : Gets list of Payor   
    */    
    FUNCTION get_giis_payee_list(p_payor_class_cd       giis_payees.payee_class_cd%TYPE)
    RETURN giis_payees_full_tab PIPELINED IS
      v_list    giis_payees_full_type;
    BEGIN
        FOR i IN (SELECT   payee_class_cd payor_class_cd, payee_no payor_cd,
                            payee_last_name
                         || ' '
                         || payee_first_name
                         || ' '
                         || payee_middle_name payor_name,
                         mail_addr1 address1, mail_addr2 address2, mail_addr3 address3
                    FROM giis_payees
                   WHERE payee_class_cd = p_payor_class_cd
                ORDER BY payee_last_name || ' ' || payee_first_name || ' '
                         || payee_middle_name)
        LOOP
          v_list.payee_class_cd     := i.payor_class_cd;
          v_list.payee_no           := i.payor_cd;
          v_list.dsp_payee_name     := i.payor_name;
          v_list.mail_addr1         := i.address1;
          v_list.mail_addr2         := i.address2;
          v_list.mail_addr3         := i.address3;
          PIPE ROW(v_list);
        END LOOP;
      RETURN;   
    END;

    /*
    **  Created by    : Niknok Orio  
    **  Date Created  : 06.04.2012
    **  Reference By  : GIACS016 - Disbursement 
    **  Description   : Gets list of Payee   
    */ 
	FUNCTION get_giis_payee_list2(p_payee_class_cd       giis_payees.payee_class_cd%TYPE)
    RETURN giis_payees_list_tab PIPELINED IS
      v_list    giis_payees_list_type;
    BEGIN
        FOR i IN (SELECT DISTINCT a1280.payee_no payee_cd,
								  a1280.payee_last_name dsp_payee_last_name,
								  a1280.payee_first_name dsp_payee_first_name,
								  a1280.payee_middle_name dsp_payee_middle_name,
								  DECODE (a1280.payee_first_name,
										   NULL, a1280.payee_last_name,
											  RTRIM (a1280.payee_first_name)
										   || ' '
										   || RTRIM (a1280.payee_middle_name)
										   || ' '
										   || RTRIM (a1280.payee_last_name)
										  ) nbt_payee_name
				    FROM giis_payees a1280,
					     giis_payee_class a1290 
				   WHERE a1280.payee_class_cd = a1290.payee_class_cd
				     AND a1280.allow_tag = 'Y' 
				     AND a1280.payee_class_cd = p_payee_class_cd 
				   ORDER BY a1280.payee_no)
        LOOP 
          v_list.payee_no           := i.payee_cd;
          v_list.payee_first_name   := i.dsp_payee_first_name;
          v_list.payee_middle_name  := i.dsp_payee_middle_name;
          v_list.payee_last_name    := i.dsp_payee_last_name;
		  v_list.nbt_payee_name		:= i.nbt_payee_name;
          PIPE ROW(v_list);
        END LOOP;
      RETURN;   
    END;
	
   /*
   **  Created by   :  Steven Ramirez
   **  Date Created : 03.02.2013
   **  Reference By : (GICLS259 - Claim Listing Per Payee
   **  Description  : Retrieves records from giis_payees with the same payee_class_cd
   */ 
    FUNCTION get_gicls259_giis_payees_list (
      p_payee_class_cd   giis_payees.payee_class_cd%TYPE,
      p_find_text        VARCHAR2
   )
   RETURN giis_payees_list_tab PIPELINED AS
      
    v_list   giis_payees_list_type;
    
   BEGIN
      FOR a IN
         (SELECT   b.payee_no,
            DECODE (b.payee_first_name,
                 ' - ', b.payee_last_name,
                    DECODE (b.payee_first_name,
                            NULL, '',
                            b.payee_first_name || ' '
                           )
                 || DECODE (b.payee_middle_name,
                            NULL, '',
                            b.payee_middle_name || ' '
                           )
                 || b.payee_last_name
                ) payee_name
            FROM giis_payees b
            WHERE UPPER(b.payee_class_cd) = UPPER(NVL(p_payee_class_cd, b.payee_class_cd))
			  AND ( UPPER (b.payee_first_name) LIKE
									   UPPER (NVL(p_find_text,b.payee_first_name))
				  OR UPPER (b.payee_middle_name) LIKE
									   UPPER (NVL(p_find_text,b.payee_middle_name))
				  OR UPPER (b.payee_last_name) LIKE
									   UPPER (NVL(p_find_text,b.payee_last_name))
				  OR b.payee_no LIKE NVL(p_find_text,b.payee_no)
				  )  
            ORDER BY payee_no)
      LOOP
          v_list.payee_no            :=  a.payee_no;
          v_list.nbt_payee_name      :=  a.payee_name;
          PIPE ROW (v_list);
      END LOOP;
   END;
   
   
   /*
   **  Created by   :  Dwight See
   **  Date Created :  05.20.2013
   **  Description  : 
   */
   FUNCTION get_motshop_list(
      p_payee_last_name     VARCHAR2
   )
   RETURN survey_list_tab PIPELINED
   IS
      v_list   survey_list_type;
   BEGIN
      FOR a IN (SELECT DISTINCT payee_no,
                    DECODE (c.payee_first_name,NULL,c.payee_last_name,'-',c.payee_last_name,c.payee_last_name||', '||c.payee_first_name||' '|| c.payee_middle_name) payee_name
                  FROM gicl_loss_exp_payees a,
                       gicl_motshop_listing_v b,
                       giis_payees c
                 WHERE a.payee_cd = b.payee_cd
                   AND a.claim_id = b.claim_id
                   AND a.payee_class_cd = c.payee_class_cd
                   AND b.payee_cd = c.payee_no
                   AND a.payee_class_cd IN (SELECT param_value_v
                                              FROM giac_parameters
                                             WHERE param_name = 'MC_PAYEE_CLASS')
                   AND check_user_per_line (b.line_cd, b.iss_cd, 'GICLS253') = 1
                   AND UPPER(payee_last_name) LIKE UPPER(NVL(p_payee_last_name,'%')))
      LOOP
         v_list.payee_no := a.payee_no;
         v_list.nbt_payee_name := a.payee_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;
   
   FUNCTION fetch_payee_name_lov(
      P_PAYEE_CLASS_CD      VARCHAR2
   )
    RETURN payee_name_lov_desc_tab PIPELINED
   IS
    ntt     payee_name_lov_desc_type;
   BEGIN
   
        FOR x IN (
            SELECT  payee_last_name||' '||
                    payee_first_name||' '||
                    payee_middle_name payee,
                    payee_no
              FROM giis_payees
             WHERE UPPER(payee_class_cd) = UPPER(NVL(P_PAYEE_CLASS_CD,'%'))
           )
        LOOP
            ntt.payee_name  := x.payee;
            ntt.payee_no    := x.payee_no;
        PIPE ROW(ntt);
        END LOOP;
        RETURN;
   END fetch_payee_name_lov;
   
   -- for GICLS210 - Private Adjuster Maintenance
   FUNCTION get_gicls210_payee_lov
        RETURN payees_list_tab PIPELINED
   IS
        v_list      payees_list_type;
   BEGIN
        FOR rec IN (SELECT payee_no, payee_last_name, payee_class_cd
                      FROM giis_payees
                     WHERE payee_class_cd = ( SELECT param_value_v
                                                FROM giac_parameters
                                               WHERE param_name = 'ADJP_CLASS_CD'))
        LOOP
            v_list.payee_no := rec.payee_no;
            v_list.payee_last_name := rec.payee_last_name;
            v_list.payee_class_cd := rec.payee_class_cd;
            PIPE ROW(v_list);
        END LOOP;
   
   END get_gicls210_payee_lov;

   FUNCTION get_all_loss_exp_adjuster_list (
     p_payee_class_cd   GIIS_PAYEES.payee_class_cd%TYPE,
     p_claim_id         GICL_CLAIMS.claim_id%TYPE,
     p_item_no          GICL_ITEM_PERIL.item_no%TYPE,
     p_peril_cd         GICL_ITEM_PERIL.peril_cd%TYPE,
     p_payee_type       GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
     p_payee_name       VARCHAR2
    )

    RETURN payee_adjuster_list_tab PIPELINED AS
          
    v_payee   payee_adjuster_list_type;

    BEGIN
        FOR i IN (SELECT DISTINCT(a.adj_company_cd) adj_company_cd, b.payee_last_name||
                         DECODE(b.payee_first_name, NULL, NULL, ','||b.payee_first_name)||
                         DECODE(b.payee_middle_name, NULL, NULL, '-'|| b.payee_middle_name) adj_co_name,
                         c.priv_adj_cd, c.payee_name, b.payee_last_name, b.payee_first_name, b.payee_middle_name
                  FROM GICL_CLM_ADJUSTER a, 
                       GIIS_PAYEES b, 
                       GIIS_ADJUSTER c
                 WHERE a.claim_id             = p_claim_id
                   AND b.allow_tag = 'Y'
                   AND NVL(a.delete_tag, 'N') = 'N'
                   AND NVL(a.cancel_tag, 'N') = 'N'
                   AND b.payee_class_cd       = GIACP.v('ADJP_CLASS_CD')
                   AND a.adj_company_cd       = b.payee_no
                   AND a.priv_adj_cd          = c.priv_adj_cd (+)
                   AND a.adj_company_cd       = c.adj_company_cd (+)
                AND ( UPPER (b.payee_first_name) LIKE UPPER ('%' || p_payee_name || '%')
                    OR UPPER (b.payee_middle_name) LIKE UPPER ('%' || p_payee_name || '%')
                    OR UPPER (b.payee_last_name) LIKE UPPER ('%' || p_payee_name || '%'))
                ORDER BY adj_company_cd)
                                      
        LOOP
           v_payee.adj_company_cd   := i.adj_company_cd;
           v_payee.adj_co_name      := i.adj_co_name;
           v_payee.priv_adj_cd      := i.priv_adj_cd;
           v_payee.payee_name       := i.payee_name;
           
           PIPE ROW (v_payee);
           
        END LOOP;  
    END get_all_loss_exp_adjuster_list;

END giis_payees_pkg;
/


