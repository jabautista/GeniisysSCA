CREATE OR REPLACE PACKAGE BODY CPI.giis_intermediary_pkg
AS
/********************************** FUNCTION 1 ************************************/
   FUNCTION get_intm_list
      RETURN intm_list_tab PIPELINED
   IS
      v_intm   intm_list_type;
   BEGIN
      FOR i IN (SELECT intm_no, intm_name
                  FROM giis_intermediary
                 WHERE NVL (active_tag, 'I') = 'A'
                 ORDER BY 1, 2)
      LOOP
         v_intm.intm_no := i.intm_no;
         v_intm.intm_name := i.intm_name;
         PIPE ROW (v_intm);
      END LOOP;

      RETURN;
   END get_intm_list;

   /********************************** FUNCTION 2 ************************************
     MODULE: GIPIS085
     RECORD GROUP NAME: CGFK$WCOMINV_DSP_INTM_NAME
   ***********************************************************************************/
   FUNCTION get_intm_name1_list (
      p_assd_no   giis_assured_intm.assd_no%TYPE,
      p_line_cd   giis_assured_intm.line_cd%TYPE,
      p_keyword   VARCHAR2
   )
      RETURN intm_name1_list_tab PIPELINED
   IS
      v_intm   intm_name1_list_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT a.intm_name, a.parent_intm_no, a.intm_no,
                          a.intm_type, a.ref_intm_cd, a.active_tag
                     FROM giis_intermediary a, giis_intm_type b
                    WHERE intm_no IN (
                             SELECT intm_no
                               FROM giis_assured_intm c
                              WHERE c.assd_no = p_assd_no
                                AND p_line_cd = line_cd)
                      AND a.intm_type = b.intm_type
                      AND a.active_tag = 'A'
                      AND (   UPPER (a.intm_name) LIKE
                                 UPPER
                                    (NVL (p_keyword, '%'))
             -- andrew - 2.14.2012 - modified the condition used in lov filter
                           OR TO_CHAR (a.intm_no) = REPLACE (p_keyword, '%')
                           OR UPPER (NVL (a.ref_intm_cd, '%')) LIKE
                                                  UPPER (NVL (p_keyword, '%'))
                          )
                 --       AND (UPPER(A.intm_name) LIKE '%' || UPPER(p_keyword) || '%'
                 --       OR A.intm_no   LIKE '%' || p_keyword || '%')
          ORDER BY        a.intm_name, a.intm_no)
      LOOP
         v_intm.intm_name := i.intm_name;
         v_intm.parent_intm_no := i.parent_intm_no;
         v_intm.intm_no := i.intm_no;
         v_intm.intm_type := i.intm_type;
         v_intm.ref_intm_cd := i.ref_intm_cd;
         v_intm.active_tag := i.active_tag;

         BEGIN
            SELECT lic_tag,
                   special_rate
              INTO v_intm.parent_intm_lic_tag,
                   v_intm.parent_intm_special_rate
              FROM giis_intermediary
             WHERE intm_no = i.parent_intm_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_intm.parent_intm_lic_tag := '';
               v_intm.parent_intm_special_rate := '';
         END;
         
         --Apollo Cruz 09.11.2014
         IF i.parent_intm_no IS NOT NULL THEN
            SELECT intm_name
              INTO v_intm.parent_intm_name
              FROM giis_intermediary
             WHERE intm_no = i.parent_intm_no; 
         END IF;

         PIPE ROW (v_intm);
      END LOOP;

      RETURN;
   END get_intm_name1_list;
   
   FUNCTION get_intm_name1_list_renewal(
      p_keyword VARCHAR2,
     p_par_id  GIPI_WPOLBAS.par_id%TYPE, --benjo 09.07.2016 SR-5604
     p_assd_no GIIS_ASSURED_INTM.assd_no%TYPE, --benjo 09.07.2016 SR-5604
     p_line_cd GIIS_ASSURED_INTM.line_cd%TYPE --benjo 09.07.2016 SR-5604
  )
     RETURN intm_name1_list_tab PIPELINED
  IS
     v_intm   intm_name1_list_type;
     v_pol_flag VARCHAR2(10);
  BEGIN
     FOR i IN (SELECT a.intm_name, a.parent_intm_no, a.intm_no,
                      a.intm_type, a.ref_intm_cd, a.active_tag
                 FROM giis_intermediary a, giis_intm_type b
                WHERE intm_no IN (SELECT INTRMDRY_INTM_NO
                                    FROM gipi_comm_invoice c
                                   WHERE policy_id IN (SELECT old_policy_id     --changed = to IN Gzelle 04162015
                                                        FROM gipi_wpolnrep
                                                       WHERE par_id = p_par_id)
                                  UNION ALL --benjo 09.07.2016 SR-5604
                                  SELECT intm_no
                                    FROM giis_assured_intm d
                                   WHERE d.assd_no = p_assd_no
                                     AND d.line_cd = p_line_cd)
                  AND a.intm_type = b.intm_type
                  AND a.active_tag = 'A'
                  AND (UPPER (a.intm_name) LIKE UPPER (NVL (p_keyword, '%'))
                          OR TO_CHAR (a.intm_no) = REPLACE (p_keyword, '%')
                          OR UPPER (NVL (a.ref_intm_cd, '%')) LIKE UPPER (NVL (p_keyword, '%')))
             ORDER BY a.intm_name, a.intm_no)
     LOOP
        v_intm.intm_name := i.intm_name;
        v_intm.parent_intm_no := i.parent_intm_no;
        v_intm.intm_no := i.intm_no;
        v_intm.intm_type := i.intm_type;
        v_intm.ref_intm_cd := i.ref_intm_cd;
        v_intm.active_tag := i.active_tag;

        BEGIN
           SELECT lic_tag,
                  special_rate
             INTO v_intm.parent_intm_lic_tag,
                  v_intm.parent_intm_special_rate
             FROM giis_intermediary
            WHERE intm_no = i.parent_intm_no;
        EXCEPTION
           WHEN NO_DATA_FOUND
           THEN
              v_intm.parent_intm_lic_tag := '';
              v_intm.parent_intm_special_rate := '';
        END;
        
        IF i.parent_intm_no IS NOT NULL THEN
           SELECT intm_name
             INTO v_intm.parent_intm_name
             FROM giis_intermediary
            WHERE intm_no = i.parent_intm_no; 
        END IF;

        PIPE ROW (v_intm);
     END LOOP;
       
  END;   

   /********************************** FUNCTION 3 ************************************
     MODULE: GIPIS085
     RECORD GROUP NAME: CGFK$WCOMINV_DSP_INTM_NAME3
   ***********************************************************************************/
   FUNCTION get_intm_name2_list (
      p_assd_no   giis_assured_intm.assd_no%TYPE,
      p_line_cd   giis_assured_intm.line_cd%TYPE,
      p_par_id    gipi_wpolbas.par_id%TYPE,
      p_keyword   VARCHAR2
   )
      RETURN intm_name1_list_tab PIPELINED
   IS
      v_intm   intm_name1_list_type;
      v_endt_seq_no gipi_polbasic.endt_seq_no%TYPE;
   BEGIN
      
      --Added by Apollo Cruz 12.12.2014
      --if cancellation, shows only the agents of the selected endorsement to be cancelled
      BEGIN
         SELECT a.endt_seq_no
           INTO v_endt_seq_no
           FROM gipi_polbasic a, gipi_wpolbas b
          WHERE a.policy_id = b.cancelled_endt_id
            AND b.par_id = p_par_id;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_endt_seq_no := NULL;        
      END;
   
      FOR i IN
         (SELECT DISTINCT a.intm_name, a.parent_intm_no, a.intm_no,
                          a.intm_type, a.ref_intm_cd, 'A' active_tag
                     FROM giis_intermediary a, giis_intm_type b
                    WHERE (intm_no IN (
                              SELECT a.intrmdry_intm_no
                                FROM gipi_comm_invoice a,
                                     gipi_wpolbas b,
                                     gipi_polbasic c
                               WHERE b.par_id = p_par_id
                                 AND b.line_cd = c.line_cd
                                 AND b.subline_cd = c.subline_cd
                                 AND b.iss_cd = c.iss_cd
                                 AND b.issue_yy = c.issue_yy
                                 AND b.pol_seq_no = c.pol_seq_no
                                 AND b.renew_no = c.renew_no
                                 AND c.policy_id = a.policy_id
                                 AND c.endt_seq_no = NVL(v_endt_seq_no, c.endt_seq_no)
                              UNION ALL
                              SELECT intm_no
                                FROM giis_assured_intm d
                               WHERE d.assd_no = p_assd_no
                                 AND p_line_cd = line_cd
                                 AND DECODE(v_endt_seq_no, NULL, 1, 0) = 1)
                          )
                      AND a.intm_type = b.intm_type
                      --AND a.active_tag = 'A'                    --comment out by koks 7.31.2015
                      AND (   UPPER (a.intm_name) LIKE
                                 UPPER
                                    (NVL (p_keyword, '%'))
             -- andrew - 2.14.2012 - modified the condition used in lov filter
                           OR TO_CHAR (a.intm_no) = REPLACE (p_keyword, '%')
                           OR UPPER (NVL (a.ref_intm_cd, '%')) LIKE
                                                  UPPER (NVL (p_keyword, '%'))
                          )
                 --     AND (UPPER(A.intm_name) LIKE '%' || UPPER(p_keyword) || '%'
                 --       OR A.intm_no   LIKE '%' || p_keyword || '%')
          ORDER BY        a.intm_name, a.intm_no)
      LOOP
         v_intm.intm_name := i.intm_name;
         v_intm.parent_intm_no := i.parent_intm_no;
         v_intm.intm_no := i.intm_no;
         v_intm.intm_type := i.intm_type;
         v_intm.ref_intm_cd := i.ref_intm_cd;
         v_intm.active_tag := i.active_tag;

         FOR j IN (SELECT a.intrmdry_intm_no, a.share_percentage, b.pol_flag
                     FROM gipi_comm_invoice a,
                          gipi_wpolbas b,
                          gipi_polbasic c
                    WHERE b.par_id = p_par_id
                      AND b.line_cd = c.line_cd
                      AND b.subline_cd = c.subline_cd
                      AND b.iss_cd = c.iss_cd
                      AND b.issue_yy = c.issue_yy
                      AND b.pol_seq_no = c.pol_seq_no
                      AND b.renew_no = c.renew_no
                      AND c.policy_id = a.policy_id
                      AND a.intrmdry_intm_no = i.intm_no)
         LOOP
            v_intm.share_percentage := j.share_percentage; 
         END LOOP;  
         
         BEGIN
            SELECT LIC_TAG, SPECIAL_RATE, intm_name 
              INTO v_intm.PARENT_INTM_LIC_TAG,
                   v_intm.PARENT_INTM_SPECIAL_RATE,
                   v_intm.PARENT_INTM_NAME --added by christian 03/16/2013
              FROM GIIS_INTERMEDIARY
             WHERE INTM_NO = i.parent_intm_no;

         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_intm.parent_intm_lic_tag := '';
               v_intm.parent_intm_special_rate := '';
               v_intm.PARENT_INTM_NAME := '';
         END;

         PIPE ROW (v_intm);
      END LOOP;

      RETURN;
   END get_intm_name2_list;

   /********************************** FUNCTION 4 ************************************
     MODULE: GIPIS085
     RECORD GROUP NAME: CGFK$WCOMINV_DSP_INTM_NAME5
   ***********************************************************************************/
   FUNCTION get_intm_name3_list (p_keyword VARCHAR2)
      RETURN intm_name1_list_tab PIPELINED
   IS
      v_intm   intm_name1_list_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT a.intm_name, a.parent_intm_no,
                          c.intm_name parent_intm_name,
                          c.lic_tag parent_lic_tag,
                          c.special_rate parent_special_rate, a.intm_no,
                          a.wtax_rate, a.intm_type, a.ref_intm_cd,
                          a.active_tag, a.lic_tag, a.special_rate
                     FROM giis_intermediary a,
                          giis_intm_type b,
                          giis_intermediary c
                    WHERE a.intm_type = b.intm_type
                      AND a.active_tag = 'A'
                      AND a.parent_intm_no = c.intm_no(+)
                      AND (   UPPER (a.intm_name) LIKE
                                 UPPER
                                    (NVL (p_keyword, '%'))
             -- andrew - 2.14.2012 - modified the condition used in lov filter
                           OR TO_CHAR (a.intm_no) = REPLACE (p_keyword, '%')
                           OR UPPER (NVL (a.ref_intm_cd, '%')) LIKE
                                                  UPPER (NVL (p_keyword, '%'))
                          )
                 --     AND (UPPER(A.intm_name) LIKE '%' || UPPER(p_keyword) || '%'
                 --      OR A.intm_no    LIKE '%' || p_keyword || '%')
          ORDER BY        a.intm_name, a.intm_no)
      LOOP
         v_intm.intm_name := i.intm_name;
         v_intm.parent_intm_no := i.parent_intm_no;
         v_intm.parent_intm_name := i.parent_intm_name;
         v_intm.parent_intm_lic_tag := i.parent_lic_tag;
         v_intm.parent_intm_special_rate := i.parent_special_rate;
         v_intm.intm_no := i.intm_no;
         v_intm.wtax_rate := i.wtax_rate;
         v_intm.intm_type := i.intm_type;
         v_intm.ref_intm_cd := i.ref_intm_cd;
         v_intm.active_tag := i.active_tag;
         v_intm.lic_tag := i.lic_tag;
         v_intm.special_rate := i.special_rate;
         PIPE ROW (v_intm);
      END LOOP;

      RETURN;
   END get_intm_name3_list;

   /********************************** FUNCTION 5 ************************************
     MODULE: GIIMM02
     RECORD GROUP NAME: LOV578
   ***********************************************************************************/
   FUNCTION get_intm_name4_list
      RETURN intm_list_tab PIPELINED
   IS
      v_intm   intm_list_type;
   BEGIN
      FOR i IN (SELECT   intm_no, intm_name, ref_intm_cd
                    FROM giis_intermediary
                ORDER BY intm_no)
      LOOP
         v_intm.intm_no := i.intm_no;
         v_intm.intm_name := i.intm_name;
         v_intm.ref_intm_cd := i.ref_intm_cd;
         PIPE ROW (v_intm);
      END LOOP;

      RETURN;
   END get_intm_name4_list;
   
   /********************************** FUNCTION 5 koks************************************
     MODULE: GIPIS085
     BY: KOKS
   ***********************************************************************************/
     FUNCTION get_intm_name5_list (p_assd_no   giis_assured_intm.assd_no%TYPE,
                                p_line_cd   giis_assured_intm.line_cd%TYPE,
                                p_par_id    gipi_wpolbas.par_id%TYPE,
                                p_keyword   VARCHAR2)
      RETURN intm_name1_list_tab PIPELINED
   IS
      v_intm   intm_name1_list_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT a.intm_name, a.parent_intm_no,
                 c.intm_name parent_intm_name,
                 c.lic_tag parent_lic_tag,
                 c.special_rate parent_special_rate, a.intm_no,
                 a.wtax_rate, a.intm_type, a.ref_intm_cd,
                 a.active_tag, a.lic_tag, a.special_rate
            FROM giis_intermediary a,
                 giis_intm_type b,
                 giis_intermediary c
           WHERE a.intm_type = b.intm_type
             AND a.active_tag = 'A'
             AND a.parent_intm_no = c.intm_no(+)
             AND (   UPPER (a.intm_name) LIKE
                                 UPPER
                                    (NVL (p_keyword, '%'))
                           OR TO_CHAR (a.intm_no) = REPLACE (p_keyword, '%')
                           OR UPPER (NVL (a.ref_intm_cd, '%')) LIKE
                                                  UPPER (NVL (p_keyword, '%'))
                          )    
           UNION                   
          SELECT d.intm_name, d.parent_intm_no,
                 e.intm_name parent_intm_name,
                 e.lic_tag parent_lic_tag,
                 e.special_rate parent_special_rate, d.intm_no,
                 d.wtax_rate, d.intm_type, d.ref_intm_cd,
                 'A', d.lic_tag, d.special_rate
            FROM gipi_comm_invoice a, 
                 gipi_wpolbas b, 
                 gipi_polbasic c, 
                 giis_intermediary d,
                 giis_intermediary e
           WHERE b.par_id = p_par_id 
             AND a.intrmdry_intm_no = d.intm_no
             AND c.line_cd = p_line_cd
             AND b.subline_cd = c.subline_cd 
             AND b.iss_cd = c.iss_cd 
             AND b.issue_yy = c.issue_yy 
             AND b.pol_seq_no = c.pol_seq_no
             AND b.renew_no = c.renew_no 
             AND c.policy_id = a.policy_id
             AND d.parent_intm_no = e.intm_no(+)
           ORDER BY intm_name, intm_no
          )
      LOOP
         v_intm.intm_name := i.intm_name;
         v_intm.parent_intm_no := i.parent_intm_no;
         v_intm.parent_intm_name := i.parent_intm_name;
         v_intm.parent_intm_lic_tag := i.parent_lic_tag;
         v_intm.parent_intm_special_rate := i.parent_special_rate;
         v_intm.intm_no := i.intm_no;
         v_intm.wtax_rate := i.wtax_rate;
         v_intm.intm_type := i.intm_type;
         v_intm.ref_intm_cd := i.ref_intm_cd;
         v_intm.active_tag := i.active_tag;
         v_intm.lic_tag := i.lic_tag;
         v_intm.special_rate := i.special_rate;
         PIPE ROW (v_intm);
      END LOOP;

      RETURN;
   END get_intm_name5_list;

    /********************************** FUNCTION 5************************************
     MODULE: GIAC001
     RECORD GROUP NAME: PAYOR RC
     BY: TONIO
   ***********************************************************************************/
   FUNCTION get_intm_payor_list (p_intm_name VARCHAR2)
      RETURN intm_payor_list_tab PIPELINED
   IS
      v_intm   intm_payor_list_type;
   BEGIN
      FOR i
         IN (SELECT /* commented out by reymon 04052013
                    DECODE (SIGN (LENGTH (intm_name) / 50 - 1),
                            1, SUBSTR (UPPER (intm_name), 1, 50) || '...',
                            UPPER (intm_name))*/
                     UPPER (intm_name)  NAME,
                    'INTERMEDIARY' payor_type,
                    mail_addr1,
                    mail_addr2,
                    mail_addr3,
                    tin tin,
                    intm_no payor_no
               FROM giis_intermediary
              WHERE     intm_no > 0
                    AND UPPER (intm_name) LIKE
                           UPPER ('%' || p_intm_name || '%')
             UNION ALL
             SELECT /* commented out by reymon 04052013
                    DECODE (SIGN (LENGTH (assd_name) / 50 - 1),
                            1, SUBSTR (UPPER (assd_name), 1, 50) || '...',
                            UPPER (assd_name)) */
                     UPPER (assd_name)  NAME,
                    'ASSURED' payor_type,
                    mail_addr1,
                    mail_addr2,
                    mail_addr3,
                    assd_tin tin,
                    assd_no payor_no
               FROM giis_assured
              WHERE     assd_no > 0
                    AND UPPER (assd_name) LIKE
                           UPPER ('%' || p_intm_name || '%')
             UNION ALL
             SELECT /* commented out by reymon 04052013
                    DECODE (SIGN (LENGTH (ri_name) / 50 - 1),
                            1, SUBSTR (UPPER (ri_name), 1, 50) || '...',
                            UPPER (ri_name)) */
                     UPPER (ri_name)  NAME,
                    'REINSURER' payor_type,
                    mail_address1,
                    mail_address2,
                    mail_address3,
                    ri_tin tin,
                    ri_cd payor_no
               FROM giis_reinsurer
              WHERE     ri_cd > 0
                    AND UPPER (ri_name) LIKE
                           UPPER ('%' || p_intm_name || '%')
             ORDER BY 1)
      LOOP
         v_intm.intm_name := i.NAME;
         v_intm.payor_type := i.payor_type;
         v_intm.mail_addr1 := i.mail_addr1;
         v_intm.mail_addr2 := i.mail_addr2;
         v_intm.mail_addr3 := i.mail_addr3;
         v_intm.tin := i.tin;
         v_intm.intm_no := i.payor_no;
         PIPE ROW (v_intm);
      END LOOP;

      RETURN;
   END get_intm_payor_list;
   
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 06.11.2013
    **  Reference By  : GIACS001- OR Information
    **  Description   : For AC-SPECS-2012-155
    **                  Consider ri_comm_tag in LOV for payor in GIACS001                    
    */
    
   FUNCTION get_intm_payor_list2(p_intm_name     VARCHAR2,
                                 p_ri_comm_tag   VARCHAR2)
        RETURN intm_payor_list_tab PIPELINED
   IS
      v_intm   intm_payor_list_type;
   BEGIN
   
        IF NVL(p_ri_comm_tag, 'N') = 'Y' THEN
            FOR i
             IN (SELECT UPPER (ri_name)  NAME,
                        'REINSURER' payor_type,
                        mail_address1 mail_addr1,
                        mail_address2 mail_addr2,
                        mail_address3 mail_addr3,
                        ri_tin tin,
                        ri_cd payor_no
                   FROM giis_reinsurer
                  WHERE ri_cd > 0
                    AND UPPER (ri_name) LIKE
                        UPPER ('%' || p_intm_name || '%')
                 ORDER BY 1)
           LOOP
             v_intm.intm_name := i.NAME;
             v_intm.payor_type := i.payor_type;
             v_intm.mail_addr1 := i.mail_addr1;
             v_intm.mail_addr2 := i.mail_addr2;
             v_intm.mail_addr3 := i.mail_addr3;
             v_intm.tin := i.tin;
             v_intm.intm_no := i.payor_no;
             PIPE ROW (v_intm);
           END LOOP;      
        ELSE
          FOR i
             IN (SELECT UPPER (intm_name)  NAME,
                        'INTERMEDIARY' payor_type,
                        mail_addr1,
                        mail_addr2,
                        mail_addr3,
                        tin tin,
                        intm_no payor_no
                   FROM giis_intermediary
                  WHERE     intm_no > 0
                        AND UPPER (intm_name) LIKE
                               UPPER ('%' || p_intm_name || '%')
                 UNION ALL
                 SELECT UPPER (assd_name)  NAME,
                        'ASSURED' payor_type,
                        mail_addr1,
                        mail_addr2,
                        mail_addr3,
                        assd_tin tin,
                        assd_no payor_no
                   FROM giis_assured
                  WHERE     assd_no > 0
                        AND UPPER (assd_name) LIKE
                               UPPER ('%' || p_intm_name || '%')
                 UNION ALL
                 SELECT UPPER (ri_name)  NAME,
                        'REINSURER' payor_type,
                        mail_address1,
                        mail_address2,
                        mail_address3,
                        ri_tin tin,
                        ri_cd payor_no
                   FROM giis_reinsurer
                  WHERE ri_cd > 0
                    AND UPPER (ri_name) LIKE
                        UPPER ('%' || p_intm_name || '%')
                 ORDER BY 1)
           LOOP
             v_intm.intm_name := i.NAME;
             v_intm.payor_type := i.payor_type;
             v_intm.mail_addr1 := i.mail_addr1;
             v_intm.mail_addr2 := i.mail_addr2;
             v_intm.mail_addr3 := i.mail_addr3;
             v_intm.tin := i.tin;
             v_intm.intm_no := i.payor_no;
             PIPE ROW (v_intm);
           END LOOP;
        END IF;

      RETURN;
   END get_intm_payor_list2;

    /********************************** FUNCTION 6************************************
     MODULE: GIAC001
     RECORD GROUP NAME: INTM_NO
     BY: TONIO
   ***********************************************************************************/
   FUNCTION get_all_intermediary_list
      RETURN intm_payor_list_tab PIPELINED
   IS
      v_intm   intm_payor_list_type;
   BEGIN
      FOR i IN (SELECT   intm_no intm_no, UPPER (intm_name) intm_name,
                         ref_intm_cd ref_intm_cd, iss_cd iss_cd,
                         lic_tag lic_tag
                    FROM giis_intermediary
                ORDER BY 2)
      LOOP
         v_intm.intm_name := i.intm_name;
         v_intm.intm_no := i.intm_no;
         v_intm.ref_intm_cd := i.ref_intm_cd;
         v_intm.iss_cd := i.iss_cd;
         v_intm.lic_tag := i.lic_tag;
         PIPE ROW (v_intm);
      END LOOP;

      RETURN;
   END get_all_intermediary_list;

   /*
      **  Created by   :  Andrew Robes
      **  Date Created :  08.09.2012
      **  Reference By : (GIACS090 - Acknowledgment Receipt)
      **  Description  : Get intermediary list of values
      */
   FUNCTION get_giis_intm_lov (p_keyword VARCHAR2)
      RETURN intm_payor_list_tab PIPELINED
   IS
      v_intm   intm_payor_list_type;
   BEGIN
      FOR i IN (SELECT   intm_no, intm_name, ref_intm_cd, iss_cd, lic_tag
                    FROM giis_intermediary
                   WHERE intm_no LIKE p_keyword
                      OR UPPER (intm_name) LIKE NVL (UPPER (p_keyword), '%')
                      OR UPPER (ref_intm_cd) LIKE NVL (UPPER (p_keyword), '%')
                      OR UPPER (iss_cd) LIKE NVL (UPPER (p_keyword), '%')
                      OR UPPER (lic_tag) LIKE NVL (UPPER (p_keyword), '%')
                ORDER BY 2)
      LOOP
         v_intm.intm_name := i.intm_name;
         v_intm.intm_no := i.intm_no;
         v_intm.ref_intm_cd := i.ref_intm_cd;
         v_intm.iss_cd := i.iss_cd;
         v_intm.lic_tag := i.lic_tag;
         PIPE ROW (v_intm);
      END LOOP;

      RETURN;
   END;

   /********************************** FUNCTION 6************************************
      MODULE: GIACS020
      RECORD GROUP NAME: INTM_NO
      BY: EMMAN
      ***********************************************************************************/
   FUNCTION get_comm_invoice_intm_list (
      p_tran_type     giac_comm_payts.tran_type%TYPE,
      p_iss_cd        giac_comm_payts.iss_cd%TYPE,
      p_prem_seq_no   giac_comm_payts.prem_seq_no%TYPE,
      p_intm_name     giis_intermediary.intm_name%TYPE
   )
      RETURN comm_invoice_intm_list_tab PIPELINED
   IS
      v_intm_no_list   comm_invoice_intm_list_type;
   BEGIN
      IF p_tran_type = 2
      THEN
         FOR i IN (SELECT DISTINCT a.intrmdry_intm_no, b.intm_name
                              FROM gipi_comm_invoice a,
                                   giis_intermediary b,
                                   giac_comm_payts d
                             WHERE b.intm_no = a.intrmdry_intm_no
                               AND a.intrmdry_intm_no = d.intm_no
                               AND a.iss_cd = d.iss_cd
                               AND a.prem_seq_no = d.prem_seq_no
                               AND d.iss_cd = p_iss_cd
                               AND d.prem_seq_no = p_prem_seq_no
                               AND d.tran_type = 1
                               AND UPPER (b.intm_name) LIKE
                                                     UPPER (p_intm_name)
                                                     || '%'
                          ORDER BY a.intrmdry_intm_no)
         LOOP
            v_intm_no_list.intm_no := i.intrmdry_intm_no;
            v_intm_no_list.intm_name := i.intm_name;
            PIPE ROW (v_intm_no_list);
         END LOOP;
      ELSIF p_tran_type = 4
      THEN
         FOR i IN (SELECT DISTINCT a.intrmdry_intm_no, b.intm_name
                              FROM gipi_comm_invoice a,
                                   giis_intermediary b,
                                   giac_comm_payts d
                             WHERE b.intm_no = a.intrmdry_intm_no
                               AND a.intrmdry_intm_no = d.intm_no
                               AND a.iss_cd = d.iss_cd
                               AND a.prem_seq_no = d.prem_seq_no
                               AND d.iss_cd = p_iss_cd
                               AND d.prem_seq_no = p_prem_seq_no
                               AND d.tran_type = 3
                               AND UPPER (b.intm_name) LIKE
                                                     UPPER (p_intm_name)
                                                     || '%'
                          ORDER BY a.intrmdry_intm_no)
         LOOP
            v_intm_no_list.intm_no := i.intrmdry_intm_no;
            v_intm_no_list.intm_name := i.intm_name;
            PIPE ROW (v_intm_no_list);
         END LOOP;
      ELSE
         FOR i IN (SELECT DISTINCT a.intrmdry_intm_no, b.intm_name
                              FROM gipi_comm_invoice a, giis_intermediary b
                             WHERE a.intrmdry_intm_no = b.intm_no
                               AND a.iss_cd = p_iss_cd
                               AND a.prem_seq_no = p_prem_seq_no
                               AND UPPER (b.intm_name) LIKE
                                                     UPPER (p_intm_name)
                                                     || '%'
                          ORDER BY a.intrmdry_intm_no)
         LOOP
            v_intm_no_list.intm_no := i.intrmdry_intm_no;
            v_intm_no_list.intm_name := i.intm_name;
            PIPE ROW (v_intm_no_list);
         END LOOP;
      END IF;
   END get_comm_invoice_intm_list;

   /*
      **  Created by   :  Emman
      **  Date Created :  09.21.2010
      **  Reference By : (GIACS020 - Comm Payts)
      **  Description  : Get vat rate of specified intm no
      */
   FUNCTION get_vat_rate (p_intm_no giis_intermediary.intm_no%TYPE)
      RETURN giis_intermediary.input_vat_rate%TYPE
   IS
      vat_rt   giis_intermediary.input_vat_rate%TYPE;
   BEGIN
      FOR cur IN (SELECT NVL (input_vat_rate, 0) vat_rt
                    FROM giis_intermediary
                   WHERE intm_no = p_intm_no)
      LOOP
         vat_rt := cur.vat_rt;
      END LOOP;

      RETURN vat_rt;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN NULL;
   END;

   /*
     **  Created by   :  Emman
     **  Date Created :  11.10.2010
     **  Reference By : (GIACS026 - Direct Trans Premium Deposit)
     **  Description  : Get list of intermediary
     */
   FUNCTION get_intm_list2 (p_keyword VARCHAR2)
      RETURN intm_list_tab2 PIPELINED
   IS
      v_intm   intm_list_type2;
   BEGIN
      FOR i IN (SELECT intm_no, intm_name
                  FROM giis_intermediary
                 WHERE active_tag = 'A'
                   AND (   intm_no LIKE '%' || p_keyword || '%'
                        OR intm_name LIKE '%' || p_keyword || '%'
                       ))
      LOOP
         v_intm.intm_no := i.intm_no;
         v_intm.intm_name := i.intm_name;
         PIPE ROW (v_intm);
      END LOOP;

      RETURN;
   END get_intm_list2;

   /*
     **  Created by   :  Emman
     **  Date Created :  12.21.2010
     **  Reference By : (GIPIS085 - Invoice Commission)
     **  Description  : Get list of intermediary associated with table giis_banc_type_dtl
     */
   FUNCTION get_banca_intm_list (
      p_keyword        VARCHAR2,
      p_banc_type_cd   giis_banc_type_dtl.banc_type_cd%TYPE,
      p_intm_type      giis_intermediary.intm_type%TYPE
   )
      RETURN intm_list_tab2 PIPELINED
   IS
      v_intm   intm_list_type2;
   BEGIN
      FOR i IN
         (SELECT DISTINCT a.intm_no intm_no, a.intm_name
                     FROM giis_intermediary a
                    WHERE a.intm_no NOT IN (
                             SELECT DISTINCT b.intm_no intm_no
                                        FROM giis_banc_type_dtl a,
                                             giis_intermediary b,
                                             gipi_wpolbas c
                                       WHERE a.intm_no = b.intm_no
                                         AND a.banc_type_cd = c.banc_type_cd
                                         AND a.banc_type_cd = p_banc_type_cd
                                         AND b.active_tag = 'A')
                      AND a.active_tag = 'A'
                      AND a.intm_type = p_intm_type
                      AND (   intm_no LIKE '%' || p_keyword || '%'
                           OR intm_name LIKE '%' || p_keyword || '%'
                          ))
      LOOP
         v_intm.intm_no := i.intm_no;
         v_intm.intm_name := i.intm_name;
         PIPE ROW (v_intm);
      END LOOP;

      RETURN;
   END get_banca_intm_list;

   FUNCTION get_intm_type_noformula (
      p_intm_no   giis_intermediary.parent_intm_no%TYPE
   )
      RETURN intm_type_noformula_tab PIPELINED
   IS
      v_intm_type_noformula   intm_type_noformula_type;
      v_returned_string       VARCHAR2 (200);
      v_parent_intm_no        giis_intermediary.parent_intm_no%TYPE;
      v_lic_tag               giis_intermediary.lic_tag%TYPE;
      v_type                  giis_intermediary.intm_type%TYPE;
      v_ptype                 giis_intermediary.intm_type%TYPE;
   BEGIN
      FOR i IN (SELECT intm_type, lic_tag, parent_intm_no
                  FROM giis_intermediary
                 WHERE intm_no = p_intm_no)
      LOOP
         v_type := i.intm_type;
         v_lic_tag := i.lic_tag;
         v_parent_intm_no := i.parent_intm_no;
      END LOOP;

      IF v_lic_tag = 'N' AND v_parent_intm_no IS NOT NULL
      THEN
         FOR p IN (SELECT intm_type
                     FROM giis_intermediary
                    WHERE intm_no = v_parent_intm_no)
         LOOP
            v_ptype := p.intm_type;
         END LOOP;

         v_intm_type_noformula.v_returned_string :=
            (v_ptype || '-' || v_parent_intm_no || '/' || v_type || '-'
             || p_intm_no
            );
         PIPE ROW (v_intm_type_noformula);
         RETURN;
      ELSE
         v_intm_type_noformula.v_returned_string :=
                                                (v_type || '-' || p_intm_no
                                                );
         PIPE ROW (v_intm_type_noformula);
         RETURN;
      END IF;
   END get_intm_type_noformula;

   FUNCTION get_intm_no_gipir025 (
      p_prem_seq_no   gipi_comm_invoice.prem_seq_no%TYPE,
      p_iss_cd        gipi_comm_invoice.iss_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      v_summary   VARCHAR2 (100) := NULL;
   BEGIN
      FOR i IN (SELECT    b.intm_type
                       || ' '
                       || a.intrmdry_intm_no
                       || ' / '
                       || b.ref_intm_cd intm_no
                  FROM gipi_comm_invoice a, giis_intermediary b
                 WHERE a.iss_cd = p_iss_cd
                   AND a.prem_seq_no = p_prem_seq_no
                   AND a.intrmdry_intm_no = b.intm_no)
      LOOP
         v_summary := i.intm_no;
      END LOOP;

      RETURN (v_summary);
   END get_intm_no_gipir025;

   FUNCTION get_intm_name_giacr250 (p_intm_no giis_intermediary.intm_no%TYPE)
      RETURN VARCHAR2
   IS
      v_intm_name        giis_intermediary.intm_name%TYPE;
      v_parent_intm_no   giis_intermediary.parent_intm_no%TYPE;
      v_lic_tag          giis_intermediary.lic_tag%TYPE;
   BEGIN
      SELECT lic_tag, parent_intm_no
        INTO v_lic_tag, v_parent_intm_no
        FROM giis_intermediary
       WHERE intm_no = p_intm_no;

      IF v_lic_tag = 'N' AND v_parent_intm_no IS NOT NULL
      THEN
         SELECT intm_name
           INTO v_intm_name
           FROM giis_intermediary
          WHERE intm_no = v_parent_intm_no;
      ELSE
         SELECT intm_name
           INTO v_intm_name
           FROM giis_intermediary
          WHERE intm_no = p_intm_no;
      END IF;

      RETURN (v_intm_name);
   END get_intm_name_giacr250;

   FUNCTION get_agent_cd (p_intm_no giis_intermediary.parent_intm_no%TYPE)
      RETURN VARCHAR2
   IS
      v_intm_type_noformula   intm_type_noformula_type;
      v_returned_string       VARCHAR2 (200);
      v_parent_intm_no        giis_intermediary.parent_intm_no%TYPE;
      v_lic_tag               giis_intermediary.lic_tag%TYPE;
      v_type                  giis_intermediary.intm_type%TYPE;
      v_ptype                 giis_intermediary.intm_type%TYPE;
      v_result                VARCHAR2 (2000);
   BEGIN
      FOR i IN (SELECT intm_type, lic_tag, parent_intm_no
                  FROM giis_intermediary
                 WHERE intm_no = p_intm_no)
      LOOP
         v_type := i.intm_type;
         v_lic_tag := i.lic_tag;
         v_parent_intm_no := i.parent_intm_no;
      END LOOP;

      IF v_lic_tag = 'N' AND v_parent_intm_no IS NOT NULL
      THEN
         FOR p IN (SELECT intm_type
                     FROM giis_intermediary
                    WHERE intm_no = v_parent_intm_no)
         LOOP
            v_ptype := p.intm_type;
         END LOOP;

         v_result :=
            (v_ptype || '-' || v_parent_intm_no || '/' || v_type || '-'
             || p_intm_no
            );
      ELSE
         v_result := (v_type || '-' || p_intm_no);
      END IF;

      RETURN (v_result);
   END get_agent_cd;

   /**
    **  Created by      : Niknok Orio
    **  Date Created    : 11.11.11 (*_*)
    **  Reference By    : (GICLS010 - Claims Basic Information)
    **  Description     :  Premium Warranty Letter
    **/
   PROCEDURE get_prem_warr_letter (
      p_claim_id          gicl_basic_intm_v1.claim_id%TYPE,
      p_assd_name         giis_assured.assd_name%TYPE,
      p_report_id         VARCHAR2,
      p_nbt_mail1   OUT   VARCHAR2,
      p_nbt_mail2   OUT   VARCHAR2,
      p_nbt_mail3   OUT   VARCHAR2,
      p_nbt_attn    OUT   VARCHAR2,
      p_msg_alert   OUT   VARCHAR2
   )
   IS
      ver   giis_reports.VERSION%TYPE;
      x     NUMBER;
      y     NUMBER;
   BEGIN
      SELECT giis_reports_pkg.get_report_version (p_report_id)
        INTO ver
        FROM DUAL;

      FOR rec IN
         (SELECT DISTINCT giis_intermediary.mail_addr1 m1,
                          giis_intermediary.mail_addr2 m2,
                          giis_intermediary.mail_addr3 m3,
                              --giis_intermediary.intm_name m4 --emcy:081607TE
                          DECODE (ver,
                                  'CIC', giis_intermediary.intm_name,
                                  'FPAC', 'Mr/Ms '
                                   || giis_intermediary.contact_pers
                                 ) m4,
                          giis_intermediary.intm_no
                     FROM giis_intermediary, gicl_basic_intm_v1
                    WHERE gicl_basic_intm_v1.claim_id = p_claim_id
                      AND gicl_basic_intm_v1.intrmdry_intm_no =
                                                     giis_intermediary.intm_no
                      AND ROWNUM = 1)
      LOOP
         p_nbt_mail1 := rec.m1;
         p_nbt_mail2 := rec.m2;
         p_nbt_mail3 := rec.m3;
         p_nbt_attn := rec.m4;
         y := rec.intm_no;                                   --emcyDA081707TE
      END LOOP;

      IF ver = 'CIC'
      THEN
--emcyDA081707TE: if intm is direct office, then the details of assured should be retrieved
         x := giisp.n ('DIRECT_INTM_NO');

         IF NVL (x, 0) = 0
         THEN
            p_msg_alert :=
                      'DIRECT_INTM_NO param is not found in giis_parameters.';
                                                                --,'E',TRUE);
            RETURN;
         END IF;

         IF y = x
         THEN
            FOR i IN (SELECT a.mail_addr1, a.mail_addr2, a.mail_addr3
                        FROM giis_assured a, gicl_claims b
                       WHERE a.assd_no = b.assd_no)
            LOOP
               p_nbt_mail1 := i.mail_addr1;
               p_nbt_mail2 := i.mail_addr2;
               p_nbt_mail3 := i.mail_addr3;
               p_nbt_attn := p_assd_name;
            END LOOP;
         END IF;
      END IF;
   END;

   PROCEDURE validate_purge_intm_no (
      p_intm_no     IN       giis_intermediary.intm_no%TYPE,
      p_intm_name   OUT      giis_intermediary.intm_name%TYPE
   )
   IS
      v_intm_name   giis_intermediary.intm_name%TYPE;
   BEGIN
      SELECT intm_name
        INTO v_intm_name
        FROM giis_intermediary
       WHERE intm_no = p_intm_no;

      IF v_intm_name IS NULL
      THEN
         p_intm_name := NULL;
      ELSE
         p_intm_name := v_intm_name;
      END IF;
   END;

   FUNCTION validate_intm_no_giexs006 (
      p_intm_no   giis_intermediary.intm_no%TYPE
   )
      RETURN intm_list_tab2 PIPELINED
   AS
      v_intm   intm_list_type2;
   BEGIN
      FOR i IN (SELECT intm_no, intm_name
                  FROM giis_intermediary
                 WHERE intm_no = p_intm_no)
      LOOP
         v_intm.intm_no := i.intm_no;
         v_intm.intm_name := i.intm_name;
         PIPE ROW (v_intm);
      END LOOP;
   END validate_intm_no_giexs006;
   
   /*
   ** Created By: Kris Felipe
   ** Date Created: 05.03.2013
   ** Reference By: GIACS180 - Statement of Account
   ** Description: Retrieves list of intermediaries based from LOV725
   */
   FUNCTION get_giacs180_intm_lov(
        p_intm_type     giis_intermediary.intm_type%TYPE
   ) RETURN intm_list_tab PIPELINED
   IS
        v_intm_list             intm_list_type;
   BEGIN
        FOR i IN (SELECT intm_no, INITCAP (intm_name) intm_name, ref_intm_cd
                    FROM giis_intermediary
                   WHERE intm_type = NVL (p_intm_type, intm_type)
                   ORDER BY intm_no)
        LOOP
            v_intm_list.intm_no := i.intm_no;
            v_intm_list.intm_name := i.intm_name;
            v_intm_list.ref_intm_cd := i.ref_intm_cd;
            
            PIPE ROW(v_intm_list);
        END LOOP;
   END ; 
   
   -- For GIACS512
   FUNCTION get_giacs512_intm_lov 
        RETURN intm_list_tab PIPELINED
   IS
        v_intm_list             intm_list_type;
   BEGIN
        FOR i IN (SELECT DISTINCT intm_no, intm_name
                    FROM giis_intermediary)
        LOOP
            v_intm_list.intm_no := i.intm_no;
            v_intm_list.intm_name := i.intm_name;
            
            PIPE ROW(v_intm_list);
        END LOOP;
   END get_giacs512_intm_lov; 
   
   --added by : Kenneth L. 07.16.2013 :for giacs286
   FUNCTION get_giacs286_intm_lov
     RETURN intm_payor_list_tab PIPELINED
   IS
      v_intm   intm_payor_list_type;
   BEGIN
      FOR i IN (SELECT   intm_no, ref_intm_cd, intm_name
                    FROM giis_intermediary
                ORDER BY intm_name, intm_no)
      LOOP
         v_intm.intm_name := i.intm_name;
         v_intm.intm_no := i.intm_no;
         v_intm.ref_intm_cd := i.ref_intm_cd;
         PIPE ROW (v_intm);
      END LOOP;

      RETURN;
   END get_giacs286_intm_lov;
   
   FUNCTION get_giacs153_intm_no_lov
      RETURN intm_list_tab2 PIPELINED
   IS
      v_list intm_list_type2;
   BEGIN
      FOR i IN (SELECT intm_no, UPPER(intm_name) intm_name
                  FROM giis_intermediary
              ORDER BY intm_no)
      LOOP
         v_list.intm_no := i.intm_no;
         v_list.intm_name := i.intm_name;
         PIPE ROW(v_list);
      END LOOP;
   END get_giacs153_intm_no_lov;
   
   FUNCTION get_giacs288_intm_lov(
        p_intm_type     giis_intermediary.intm_type%TYPE,
        p_module_id     giis_modules.module_id%TYPE,
        p_user_id       giis_users.user_id%TYPE,
        p_find_text     VARCHAR2
    )
     RETURN intm_payor_list_tab PIPELINED
   IS
        v_intm_list             intm_payor_list_type;   
   BEGIN
        FOR i IN (SELECT intm_no, intm_name, ref_intm_cd, iss_cd
                    FROM giis_intermediary
                   WHERE intm_type = NVL(p_intm_type, intm_type)
                     AND iss_cd IN(SELECT a.branch_cd
                                     FROM giac_branches a
                                    WHERE check_user_per_iss_cd_acctg2(NULL, a.branch_cd, p_module_id, p_user_id) = 1)
                     AND (TO_CHAR(intm_no) LIKE TO_CHAR(NVL(p_find_text, intm_no))
                      OR UPPER(intm_name) LIKE UPPER(NVL(p_find_text, intm_name))
                      OR UPPER(NVL(ref_intm_cd, '%')) LIKE UPPER(NVL(p_find_text, NVL(ref_intm_cd, '%'))))
                   ORDER BY intm_no)
        LOOP
            v_intm_list.intm_no := i.intm_no;
            v_intm_list.intm_name := i.intm_name;
            v_intm_list.ref_intm_cd := i.ref_intm_cd;
            v_intm_list.iss_cd := i.iss_cd;
            
            PIPE ROW(v_intm_list);
        END LOOP;   
   END;
   
   FUNCTION get_gisms008_intm_lov(
      p_name   VARCHAR2
   )
      RETURN intm_list_tab2 PIPELINED
   IS
      v_list intm_list_type2;
   BEGIN
      FOR i IN (SELECT intm_no, intm_name 
                  FROM giis_intermediary 
                 WHERE REPLACE(intm_name, ' ', NULL) LIKE REPLACE(p_name, ' ', NULL))
      LOOP
         v_list.intm_no := i.intm_no;
         v_list.intm_name := i.intm_name;
         PIPE ROW(v_list);
      END LOOP;
   END;
   
   FUNCTION val_comm_rate ( --Apollo Cruz 09.25.2014
      p_intm_no      VARCHAR2,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_peril_cd     VARCHAR2,
      p_comm_rate    VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_parent_intm_no giis_intermediary.parent_intm_no%TYPE;
      v_lic_tag giis_intermediary.lic_tag%TYPE;
      v_special_rate giis_intermediary.special_rate%TYPE;
      v_message VARCHAR2(500) := 'SUCCESS';
      v_intm_type giis_intermediary.intm_type%TYPE;
      
      v_override_comm_rate giis_spl_override_rt.comm_rate%TYPE;
      v_special_comm_rate giis_intm_special_rate.rate%TYPE;
      v_intm_type_comm_rate giis_intmdry_type_rt.comm_rate%TYPE;
      v_override_tag giis_intm_special_rate.override_tag%TYPE;
   BEGIN
   
      SELECT parent_intm_no, lic_tag, special_rate, intm_type
        INTO v_parent_intm_no, v_lic_tag, v_special_rate, v_intm_type
        FROM giis_intermediary
       WHERE intm_no = p_intm_no;
       
       IF v_lic_tag = 'N' THEN       
          BEGIN
             SELECT comm_rate
               INTO v_override_comm_rate
               FROM giis_spl_override_rt
              WHERE intm_no = v_parent_intm_no
                AND line_cd = p_line_cd
                AND subline_cd = p_subline_cd
                AND iss_cd = p_iss_cd
                AND peril_cd = p_peril_cd;
          EXCEPTION WHEN NO_DATA_FOUND THEN
             v_override_comm_rate := NULL;        
          END;
       END IF;       
       
       IF v_special_rate = 'Y' THEN
          BEGIN
             SELECT rate, override_tag
               INTO v_special_comm_rate, v_override_tag
               FROM giis_intm_special_rate
              WHERE intm_no = p_intm_no
                AND line_cd = p_line_cd
                AND subline_cd = p_subline_cd
                AND iss_cd = p_iss_cd
                AND peril_cd = p_peril_cd;
          EXCEPTION WHEN NO_DATA_FOUND THEN
             v_special_comm_rate := NULL;
             v_override_tag := NULL;
          END;
       END IF;    
          
       IF v_special_comm_rate IS NULL THEN
          BEGIN
             SELECT comm_rate
               INTO v_intm_type_comm_rate
               FROM giis_intmdry_type_rt
              WHERE intm_type = v_intm_type
                AND line_cd = p_line_cd
                AND subline_cd = p_subline_cd
                AND iss_cd = p_iss_cd
                AND peril_cd = p_peril_cd;
          EXCEPTION WHEN NO_DATA_FOUND THEN
             v_intm_type_comm_rate := NULL;
          END;
       END IF;
       
       IF v_lic_tag = 'Y' THEN
       
          IF v_special_rate = 'Y' AND p_comm_rate < NVL(v_special_comm_rate, v_intm_type_comm_rate) THEN
             v_message := 'Commission Rate is lower than the Computed Commission Rate of ' || NVL(v_special_comm_rate, v_intm_type_comm_rate) || '%.';
          ELSIF v_special_rate = 'N' AND p_comm_rate < v_intm_type_comm_rate THEN
             v_message := 'Commission Rate is lower than the Computed Commission Rate of ' || v_intm_type_comm_rate || '%.';
          END IF;
          
       ELSIF v_lic_tag = 'N' THEN
          
          IF v_special_rate = 'Y' and v_override_tag = 'Y' AND p_comm_rate < v_override_comm_rate THEN
             v_message := 'Error#Commission Rate is lower than the Overriding Commission Rate of ' || v_override_comm_rate || '%.';
          ELSIF v_special_rate = 'Y' AND NVL(v_override_tag, 'N') != 'Y' AND p_comm_rate < NVL(v_special_comm_rate, v_intm_type_comm_rate) THEN
             v_message := 'Commission Rate is lower than the Computed Commission Rate of ' || NVL(v_special_comm_rate, v_intm_type_comm_rate) || '%.';
          ELSIF v_special_rate = 'Y' AND v_override_tag = 'Y' AND p_comm_rate < (v_special_comm_rate + v_override_comm_rate) THEN
             v_message := 'Commission Rate is lower than the Computed Commission Rate of ' || (v_special_comm_rate + v_override_comm_rate) || '%.';
          ELSIF v_special_rate = 'N' AND p_comm_rate < v_intm_type_comm_rate THEN
             v_message := 'Commission Rate is lower than the Computed Commission Rate of ' || v_intm_type_comm_rate || '%.';
          END IF;
          
       END IF;      
      
      RETURN v_message; 
       
   END val_comm_rate;
   
   --benjo 10.29.2015 - gipis901a intm lov
   FUNCTION get_gipis901a_intm_lov(
        p_intm_type     VARCHAR2,
        p_intm_no       VARCHAR2
   ) RETURN gipis901a_intm_list_tab PIPELINED
   IS
        v_list      gipis901a_intm_list_type;
   BEGIN
        FOR i IN (SELECT a.intm_no, a.intm_name, a.intm_type, b.intm_desc
                    FROM giis_intermediary a, giis_intm_type b
                   WHERE a.intm_type = b.intm_type
                     AND NVL (a.active_tag, 'I') IN ('I','A') -- SR#22197. 05.17.16 apignas_jr.    
                     AND a.intm_type = NVL(p_intm_type, a.intm_type)
                     AND a.intm_no = NVL(TO_NUMBER(p_intm_no), a.intm_no)
                   ORDER BY a.intm_no)
        LOOP
            v_list.intm_no := i.intm_no;
            v_list.intm_name := i.intm_name;
            v_list.intm_type := i.intm_type;
            v_list.intm_desc := i.intm_desc;
            
            PIPE ROW(v_list);
        END LOOP;
   END ;
   
END giis_intermediary_pkg;
/
