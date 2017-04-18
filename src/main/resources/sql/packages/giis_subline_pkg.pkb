CREATE OR REPLACE PACKAGE BODY CPI.giis_subline_pkg
AS
   FUNCTION get_subline_list (p_line_cd giis_line.line_cd%TYPE)
      RETURN subline_list_tab PIPELINED
   IS
      v_subline   subline_list_type;
   BEGIN
      FOR i IN (SELECT   subline_cd, line_cd, subline_name, open_policy_sw,
                         op_flag
                    FROM giis_subline
                   WHERE line_cd = p_line_cd
                ORDER BY UPPER (subline_cd))
      LOOP
         v_subline.subline_cd := i.subline_cd;
         v_subline.line_cd := i.line_cd;
         v_subline.subline_name := i.subline_name;
         v_subline.open_policy_sw := i.open_policy_sw;
         v_subline.op_flag := i.op_flag;
         PIPE ROW (v_subline);
      END LOOP;

      RETURN;
   END get_subline_list;

   FUNCTION get_subline_spf_list (p_line_cd giis_line.line_cd%TYPE)
      RETURN subline_list_tab PIPELINED
   IS
      v_subline   subline_list_type;
   BEGIN
      FOR i IN (SELECT   subline_cd, line_cd, subline_name, open_policy_sw,
                         op_flag
                    FROM giis_subline
                   WHERE line_cd = p_line_cd AND subline_cd != 'SPF'
                ORDER BY UPPER (subline_cd))
      LOOP
         v_subline.subline_cd := i.subline_cd;
         v_subline.line_cd := i.line_cd;
         v_subline.subline_name := i.subline_name;
         v_subline.open_policy_sw := i.open_policy_sw;
         v_subline.op_flag := i.op_flag;
         PIPE ROW (v_subline);
      END LOOP;

      RETURN;
   END get_subline_spf_list;

   FUNCTION get_subline_name (p_subline_cd IN giis_line.line_cd%TYPE)
      RETURN VARCHAR2
   IS
      v_subline_name   giis_subline.subline_name%TYPE;
   BEGIN
      FOR i IN (SELECT subline_name
                  FROM giis_subline
                 WHERE subline_cd = p_subline_cd)
      LOOP
         v_subline_name := i.subline_name;
         EXIT;
      END LOOP;

      RETURN v_subline_name;
   END get_subline_name;

   FUNCTION get_subline_name2 (
      p_line_cd           giis_line.line_cd%TYPE,
      p_subline_cd   IN   giis_line.line_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      v_subline_name   giis_subline.subline_name%TYPE;
   BEGIN
      FOR i IN (SELECT subline_name
                  FROM giis_subline
                 WHERE subline_cd = p_subline_cd AND line_cd = p_line_cd)
      LOOP
         v_subline_name := i.subline_name;
         EXIT;
      END LOOP;

      RETURN v_subline_name;
   END;

   FUNCTION get_subline_code (
      p_subline_name   IN   giis_subline.subline_name%TYPE
   )
      RETURN VARCHAR2
   IS
      v_subline_code   giis_subline.subline_cd%TYPE;
   BEGIN
      FOR i IN (SELECT subline_cd
                  FROM giis_subline
                 WHERE subline_name = p_subline_name)
      LOOP
         v_subline_code := i.subline_cd;
         EXIT;
      END LOOP;

      RETURN v_subline_code;
   END get_subline_code;

   FUNCTION get_subline_code2 (
      p_line_cd             giis_line.line_cd%TYPE,
      p_subline_name   IN   giis_subline.subline_name%TYPE
   )
      RETURN VARCHAR2
   IS
      v_subline_code   giis_subline.subline_cd%TYPE;
   BEGIN
      FOR i IN (SELECT subline_cd
                  FROM giis_subline
                 WHERE subline_name = p_subline_name AND line_cd = p_line_cd)
      LOOP
         v_subline_code := i.subline_cd;
         EXIT;
      END LOOP;

      RETURN v_subline_code;
   END get_subline_code2;

   FUNCTION get_subline_details (
      p_line_cd           giis_line.line_cd%TYPE,
      p_subline_cd   IN   giis_line.line_cd%TYPE
   )
      RETURN subline_list_tab PIPELINED
   IS
      v_subline   subline_list_type;
   BEGIN
      FOR i IN (SELECT subline_cd, line_cd, subline_name, open_policy_sw,
                       benefit_flag, op_flag
                  FROM giis_subline
                 WHERE line_cd = p_line_cd AND subline_cd = p_subline_cd)
      LOOP
         v_subline.subline_cd := i.subline_cd;
         v_subline.line_cd := i.line_cd;
         v_subline.subline_name := i.subline_name;
         v_subline.open_policy_sw := i.open_policy_sw;
         v_subline.benefit_flag := i.benefit_flag;
         v_subline.op_flag := i.op_flag;
      END LOOP;

      PIPE ROW (v_subline);
      RETURN;
   END;

   /*
   **  Created by    : Mark JM
   **  Date Created  : 05.26.2010
   **  Reference By  : (GIPIS031 - Endt. Basic Information)
   **  Description   : This functions retrieves the time_sw based on line_cd and subline_cd
   */
   FUNCTION get_subline_time_sw (
      p_line_cd      IN   giis_subline.line_cd%TYPE,
      p_subline_cd   IN   giis_subline.subline_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      v_end_of_day   VARCHAR2 (10) := 'N';
   BEGIN
      FOR t IN (SELECT NVL (time_sw, 'N') time_sw
                  FROM giis_subline
                 WHERE line_cd = p_line_cd AND subline_cd = p_subline_cd)
      LOOP
         v_end_of_day := t.time_sw;
         EXIT;
      END LOOP;

      RETURN v_end_of_day;
   END get_subline_time_sw;

   FUNCTION get_all_subline_list
      RETURN subline_list_tab PIPELINED
   IS
      v_subline   subline_list_type;
   BEGIN
      FOR i IN (SELECT   subline_cd, line_cd, subline_name, open_policy_sw,
                         op_flag
                    FROM giis_subline
                ORDER BY UPPER (subline_cd))
      LOOP
         v_subline.subline_cd := i.subline_cd;
         v_subline.line_cd := i.line_cd;
         v_subline.subline_name := i.subline_name;
         v_subline.open_policy_sw := i.open_policy_sw;
         v_subline.op_flag := i.op_flag;
         PIPE ROW (v_subline);
      END LOOP;

      RETURN;
   END get_all_subline_list;

   /*
   **  Created by    : Robert John Virrey
   **  Date Created  : September 09, 2011
   **  Reference By  : (GIEXS001- Extract Expiring Policies)
   */
   FUNCTION get_subline_cd_name (p_line_cd giis_subline.line_cd%TYPE)
      RETURN subline_list_tab PIPELINED
   IS
      v_subline   subline_list_type;
   BEGIN
      FOR i IN (SELECT subline_cd, subline_name
                  FROM giis_subline
                 WHERE line_cd = NVL (p_line_cd, line_cd)
                   AND NVL (non_renewal_tag, 'N') <> 'Y')
      LOOP
         v_subline.subline_cd := i.subline_cd;
         v_subline.subline_name := i.subline_name;
         PIPE ROW (v_subline);
      END LOOP;

      RETURN;
   END get_subline_cd_name;

   /*
    **  Created by    : Robert John Virrey
    **  Date Created  : September 14, 2011
    **  Reference By  : (GIEXS001- Extract Expiring Policies)
    */
   PROCEDURE validate_subline_cd (
      p_line_cd      IN       giis_line.line_cd%TYPE,
      p_iss_cd       IN       giis_user_grp_line.iss_cd%TYPE,
      p_subline_cd   IN       giis_subline.subline_cd%TYPE,
      p_msg          OUT      VARCHAR2
   )
   IS
      v_line   giis_line.line_cd%TYPE   := NULL;
   BEGIN
      IF p_subline_cd IS NOT NULL
      THEN
         FOR a IN (SELECT line_cd
                     FROM giis_subline
                    WHERE subline_cd = p_subline_cd
                      AND line_cd = p_line_cd
                      AND check_user_per_line (p_line_cd, p_iss_cd,
                                               'GIEXS001') = 1)
         LOOP
            v_line := a.line_cd;
            EXIT;
         END LOOP;

         IF v_line IS NULL
         THEN
            p_msg := 1;
         END IF;
      END IF;
   END validate_subline_cd;

   /*
   **  Created by    : Robert John Virrey
   **  Date Created  : December 14, 2011
   **  Reference By  : (GICLS026- No Claim)
   **  Description   : SUBLINE_CD_LOV
   */
   FUNCTION get_polbasic_subline_list (p_line_cd giis_subline.line_cd%TYPE)
      RETURN subline_list_tab PIPELINED
   IS
      v_subline   subline_list_type;
   BEGIN
      FOR i IN (SELECT a.subline_cd, a.subline_name
                  FROM giis_subline a
                 WHERE EXISTS (
                          SELECT 'X'
                            FROM gipi_polbasic b
                           WHERE b.subline_cd = a.subline_cd
                             AND b.line_cd = a.line_cd)
                   AND a.line_cd = p_line_cd)
      LOOP
         v_subline.subline_cd := i.subline_cd;
         v_subline.subline_name := i.subline_name;
         PIPE ROW (v_subline);
      END LOOP;

      RETURN;
   END get_polbasic_subline_list;
   
   /*
   **  Created by    : Marco Paolo Rebong
   **  Date Created  : March 19, 2012
   **  Reference By  : (GIEXS003- Purge Extracted Policies)
   **  Description   : subline_cd based on NVL-line_cd, no conditions
   */
   FUNCTION get_subline_lov (
     p_line_cd          GIIS_LINE.line_cd%TYPE
   )
     RETURN subline_list_tab PIPELINED
   IS
     v_subline          subline_list_type;
   BEGIN
     FOR i IN(SELECT subline_cd, subline_name
                FROM GIIS_SUBLINE
               WHERE line_cd = NVL(p_line_cd, line_cd))
     LOOP
       v_subline.subline_cd := i.subline_cd;
       v_subline.subline_name := i.subline_name;
       PIPE ROW(v_subline);
     END LOOP;
     RETURN;
   END;
   
   PROCEDURE validate_purge_subline_cd(
        p_line_cd       IN  GIIS_LINE.line_cd%TYPE,
        p_subline_cd    IN  GIIS_SUBLINE.subline_cd%TYPE,
        p_subline_name  OUT GIIS_SUBLINE.subline_name%TYPE
    )
    IS
        v_subline_name  VARCHAR2(100) := NULL;
    BEGIN
        SELECT subline_name
          INTO v_subline_name
          FROM GIIS_SUBLINE
         WHERE line_cd = NVL(p_line_cd, line_cd)
           AND subline_cd = p_subline_cd;
    
        IF v_subline_name IS NULL THEN
            p_subline_name := null;
        ELSE
            p_subline_name := v_subline_name;
        END IF;
    END;
    
    --bonok :: 04.10.2012 :: subline LOV for GIEXS006
    FUNCTION get_exp_rep_subline_lov (
        p_line_cd          giis_subline.line_cd%TYPE
    )
    RETURN subline_list_tab PIPELINED IS
    v_subline	subline_list_type;

    BEGIN
        FOR i IN(SELECT subline_cd, subline_name 
		           FROM giis_subline 
                  WHERE line_cd = NVL(p_line_cd,line_cd)
                  ORDER BY subline_name)
        LOOP
            v_subline.subline_cd   := i.subline_cd;
            v_subline.subline_name := i.subline_name;
            PIPE ROW(v_subline);
        END LOOP;
    END get_exp_rep_subline_lov;
    
    --bonok :: 04.17.2012 :: validate subline for GIEXS006
    FUNCTION validate_subline_cd_giexs006(
        p_line_cd	 giis_line.line_cd%TYPE,
        p_subline_cd giis_subline.subline_cd%TYPE
    )
    RETURN subline_list_tab PIPELINED IS
        v_subline	 subline_list_type;
    BEGIN
        FOR i IN(SELECT subline_cd, subline_name
                   FROM giis_subline
                  WHERE line_cd = NVL(p_line_cd, line_cd)
                    AND subline_cd = p_subline_cd)
        LOOP
            v_subline.subline_cd   := i.subline_cd;
            v_subline.subline_name := i.subline_name;
            PIPE ROW(v_subline);
        END LOOP;
    END validate_subline_cd_giexs006;
    
    
    /** Created By:     kenneth Labrador
     ** Date Created:   04.24.2013
     ** Referenced By:  GIUTS022 - Change in Payment Term
     **Description:     Subline LOV
     **/
    FUNCTION get_subline_lov_giuts022 (
      p_line_cd          giis_subline.line_cd%TYPE,
      p_search           VARCHAR2
   )
   RETURN subline_list_tab PIPELINED
    IS
       v_giis_subline   subline_list_type;
    BEGIN
       FOR i IN (SELECT   subline_cd, subline_name
                     FROM giis_subline
                    WHERE UPPER (subline_cd) LIKE UPPER (NVL (p_search, '%'))
                      AND line_cd = p_line_cd)
       LOOP
          v_giis_subline.subline_cd := i.subline_cd;
          v_giis_subline.subline_name := i.subline_name;
          PIPE ROW (v_giis_subline);
       END LOOP;

       RETURN;
    END get_subline_lov_giuts022;
    
    /*
   **  Created by    : Kenneth Labrador
   **  Date Created  : 05.23.2013
   **  Reference By  : (GIISS002 Subline mAintenance)
   **  Description   : for philfire-qa sr 0013165 
   */
  FUNCTION get_giis_subline_lov (
      p_line_cd          giis_subline.line_cd%TYPE
   )
   RETURN subline_details_tab PIPELINED
   IS
     v_subline          subline_details_type;
     v_recap_line       cg_ref_codes.rv_meaning%TYPE; --added by mikel 03.16.2015
   BEGIN
     FOR i IN(SELECT line_cd, subline_cd, subline_name, subline_time, acct_subline_cd, min_prem_amt,
                     remarks, open_policy_sw, op_flag, allied_prt_tag, time_sw, no_tax_sw, exclude_tag, prof_comm_tag,
                     non_renewal_tag, edst_sw, enrollee_tag, recap_line_cd, --added recap_line_cd by mikel 03.16.2015 SR 18319
                     micro_sw --apollo 05.20.2015 sr#4245
                FROM GIIS_SUBLINE
               WHERE line_cd = p_line_cd)
     LOOP
       v_subline.line_cd            := i.line_cd;
       v_subline.subline_cd         := i.subline_cd;
       v_subline.subline_name       := i.subline_name;
       v_subline.micro_sw           := i.micro_sw; --apollo 05.20.2015 sr#4245
       BEGIN
           SELECT TO_CHAR (TRUNC (SYSDATE) + NUMTODSINTERVAL (i.subline_time, 'second'), 'HH:MI:SS PM')
           INTO  v_subline.subline_time
           FROM DUAL;
       END;
       
       --added by mikel 03.16.2015
       BEGIN
            SELECT rv_meaning
              INTO v_recap_line 
              FROM TABLE (get_cg_ref_codes.display_ref_codes ('GIIS_SUBLINE',
                                                              'RECAP_LINE_CD'
                                                             )
                         )
             WHERE rv_low_value = i.recap_line_cd;
             EXCEPTION WHEN NO_DATA_FOUND THEN
                v_recap_line := NULL;
       END;
       --end mikel
       
       v_subline.acct_subline_cd    := i.acct_subline_cd;
       v_subline.min_prem_amt       := i.min_prem_amt;
       v_subline.remarks            := i.remarks;
       v_subline.open_policy_sw     := i.open_policy_sw;
       v_subline.op_flag            := i.op_flag;
       v_subline.allied_prt_tag     := i.allied_prt_tag;
       v_subline.time_sw            := i.time_sw;
       v_subline.no_tax_sw          := i.no_tax_sw;
       v_subline.exclude_tag        := i.exclude_tag;
       v_subline.prof_comm_tag      := i.prof_comm_tag;
       v_subline.non_renewal_tag    := i.non_renewal_tag;
       v_subline.edst_sw            := i.edst_sw;
       v_subline.enrollee_tag       := i.enrollee_tag;
       v_subline.recap_line         := v_recap_line; --added by mikel 03.16.2015 SR 18319
       PIPE ROW(v_subline);
     END LOOP;
     RETURN;
   END get_giis_subline_lov;
   
   PROCEDURE set_giis_subline_group (
      p_subline giis_subline%ROWTYPE,
      p_subline_time giis_subline.subline_time%TYPE
   )
   IS
   BEGIN
      UPDATE giis_subline
         SET subline_name       = p_subline.subline_name,
             subline_time       = ((TO_DATE(p_subline_time, 'HH:MI:SSPM')) - (TO_DATE('12:00:00 AM', 'HH:MI:SSPM'))) * 86400,
             acct_subline_cd    = p_subline.acct_subline_cd,
             min_prem_amt       = p_subline.min_prem_amt,
             remarks            = p_subline.remarks,
             open_policy_sw     = p_subline.open_policy_sw,
             op_flag            = p_subline.op_flag,
             allied_prt_tag     = p_subline.allied_prt_tag,
             time_sw            = p_subline.time_sw,
             no_tax_sw          = p_subline.no_tax_sw,
             exclude_tag        = p_subline.exclude_tag,
             prof_comm_tag      = p_subline.prof_comm_tag,
             non_renewal_tag    = p_subline.non_renewal_tag,
             edst_sw            = p_subline.edst_sw,
             enrollee_tag       = p_subline.enrollee_tag,
             recap_line_cd      = p_subline.recap_line_cd, --added by mikel 03.17.2015
             micro_sw           = p_subline.micro_sw --apollo 05.20.2015 sr#4245
       WHERE line_cd            = p_subline.line_cd
         AND subline_cd         = p_subline.subline_cd;
   END set_giis_subline_group;
   
   PROCEDURE add_giis_subline_group (
      p_subline giis_subline%ROWTYPE,
      p_subline_time giis_subline.subline_time%TYPE
   )
   IS
   BEGIN
      INSERT INTO giis_subline
                  (line_cd, subline_cd,
                   subline_name, subline_time,
                   acct_subline_cd, min_prem_amt,
                   remarks, open_policy_sw,
                   op_flag, allied_prt_tag,
                   micro_sw, --apollo 05.20.2015 sr#4245
                   time_sw, no_tax_sw,
                   exclude_tag, prof_comm_tag,
                  non_renewal_tag, edst_sw, enrollee_tag
                  )
           VALUES (p_subline.line_cd, p_subline.subline_cd,
                   p_subline.subline_name, ((TO_DATE(p_subline_time, 'HH:MI:SSPM')) - (TO_DATE('12:00:00 AM', 'HH:MI:SSPM'))) * 86400,
                   p_subline.acct_subline_cd, p_subline.min_prem_amt,
                   p_subline.remarks, p_subline.open_policy_sw,
                   p_subline.op_flag, p_subline.allied_prt_tag,
                   p_subline.micro_sw, --apollo 04.20.2015 sr#4245
                   p_subline.time_sw, p_subline.no_tax_sw,
                   p_subline.exclude_tag, p_subline.prof_comm_tag,
                   p_subline.non_renewal_tag, p_subline.edst_sw, p_subline.enrollee_tag
                  );
   END add_giis_subline_group;
      
   
   FUNCTION validate_subline_add (
      p_line_cd          giis_subline.line_cd%TYPE,
      p_subline_cd       giis_subline.subline_cd%TYPE
   )
   RETURN VARCHAR2
   IS
       v_subline     VARCHAR2 (1);
    BEGIN
         SELECT(  SELECT  'Y'
                  FROM    GIIS_SUBLINE
                  WHERE   LINE_CD = P_LINE_CD
                  AND     SUBLINE_CD = P_SUBLINE_CD
                )
           INTO v_subline
         FROM DUAL;

       IF v_subline IS NOT NULL
       THEN
          RETURN v_subline;
      END IF;
       
       RETURN 'N';
    END validate_subline_add;
    
    
    PROCEDURE delete_giis_subline_row (
      p_line_cd          giis_subline.line_cd%TYPE,
      p_subline_cd       giis_subline.subline_cd%TYPE
   )
   IS
   BEGIN
      DELETE giis_subline
       WHERE line_cd = p_line_cd AND subline_cd = p_subline_cd;
   END delete_giis_subline_row;
   
   FUNCTION validate_subline_del (
      p_line_cd          giis_subline.line_cd%TYPE,
      p_subline_cd       giis_subline.subline_cd%TYPE
   )
   RETURN VARCHAR2
   IS
       v_subline     VARCHAR2 (1);
    BEGIN
    
       FOR a IN (
          SELECT  'Y' validate_subline
            FROM  gipi_wpolbas
           WHERE  subline_cd =  p_subline_cd
                     AND  line_cd =  p_line_cd) 
        LOOP
        v_subline := a.validate_subline;
            IF v_subline IS NOT NULL
              THEN
                 RETURN 'Y';
              END IF;
       END LOOP;
       
       FOR b IN (
           SELECT  'Y' validate_subline
             FROM  gipi_polbasic
            WHERE  subline_cd =  p_subline_cd
                     AND  line_cd =  p_line_cd) 
            LOOP
            v_subline := b.validate_subline;
             IF v_subline IS NOT NULL
              THEN
                 RETURN 'Y';
              END IF;
       END LOOP;
       
       --added by kenneth L to handle integrity constraint in giis_deductible_desc
       FOR b IN (
           SELECT  'Y' validate_subline
             FROM  giis_deductible_desc
            WHERE  subline_cd =  p_subline_cd
                     AND  line_cd =  p_line_cd) 
            LOOP
            v_subline := b.validate_subline;
             IF v_subline IS NOT NULL
              THEN
                 RETURN 'Y';
              END IF;
       END LOOP;

       RETURN 'N';
    END validate_subline_del;
    

    FUNCTION validate_acct_subline_cd (
      p_line_cd          giis_subline.line_cd%TYPE,
      p_acct_subline_cd  giis_subline.acct_subline_cd%TYPE
   )
   RETURN VARCHAR2
   IS
       v_acct     VARCHAR2 (1);
    BEGIN
         FOR b IN ( SELECT  'Y' validate_acct_cd
                      FROM  giis_subline
                     WHERE  line_cd =  p_line_cd
                       AND  acct_subline_cd =  p_acct_subline_cd) 
       LOOP
        v_acct := b.validate_acct_cd;
        IF v_acct IS NOT NULL
        THEN
            RETURN 'Y';
        END IF;
       END LOOP;
       
       RETURN 'N';
    END validate_acct_subline_cd; 
    
    FUNCTION validate_open_sw (
      p_line_cd          giis_subline.line_cd%TYPE
   )
   RETURN VARCHAR2
   IS
       v_acct     VARCHAR2 (1);
    BEGIN
    
       FOR a IN (
          SELECT open_policy_sw
            FROM giis_subline
           WHERE line_cd = p_line_cd) 
             
        LOOP
        v_acct := a.open_policy_sw;
            IF v_acct = 'Y'
              THEN
                 RETURN '1';
                 EXIT;
            END IF;
       END LOOP;
       
       RETURN '0';
    END validate_open_sw;
    
    FUNCTION validate_op_flag (
      p_line_cd          giis_subline.line_cd%TYPE
   )
   RETURN VARCHAR2
   IS
       v_acct     VARCHAR2 (1);
    BEGIN
    
       FOR a IN (
          SELECT op_flag
            FROM giis_subline
           WHERE line_cd = p_line_cd) 
             
        LOOP
        v_acct := a.op_flag;
            IF v_acct = 'Y'
              THEN
                 RETURN '1';
                 EXIT;
            END IF;
       END LOOP;
       
       RETURN '0';
    END validate_op_flag;
    
    FUNCTION get_gicls254_subline_lov (
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN gicls254_subline_tab PIPELINED
   IS
      v_list gicls254_subline_type;
   BEGIN
      FOR i IN (SELECT subline_cd, subline_name
                  FROM giis_subline
                 WHERE line_cd = p_line_cd
                   AND check_user_per_iss_cd2 (line_cd, NULL, 'GICLS254', p_user_id) = 1
                   AND subline_cd LIKE NVL(p_subline_cd, subline_cd)
              ORDER BY subline_cd)
      LOOP
         v_list.subline_cd := i.subline_cd;
         v_list.subline_name := i.subline_name;
         
         PIPE ROW(v_list);
      END LOOP;
   END get_gicls254_subline_lov;   
    
END giis_subline_pkg;
/


