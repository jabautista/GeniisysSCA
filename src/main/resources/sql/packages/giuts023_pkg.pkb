CREATE OR REPLACE PACKAGE BODY CPI.giuts023_pkg
AS
   
   FUNCTION get_policy_info_lov (
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_issue_yy     VARCHAR2,
      p_pol_seq_no   VARCHAR2,
      p_renew_no     VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN policy_info_lov_tab PIPELINED
   IS
      v_list policy_info_lov_type;
   BEGIN
      FOR i IN (SELECT a.par_id, a.assd_no, a.policy_id, a.line_cd,
                       a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no,
                       a.renew_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no
                  FROM gipi_polbasic a
                 WHERE a.line_cd = NVL(p_line_cd, a.line_cd)
                   AND a.subline_cd = NVL(p_subline_cd, a.subline_cd)
                   AND a.iss_cd = NVL(p_iss_cd, a.iss_cd)
                   AND a.issue_yy = NVL(TO_NUMBER(p_issue_yy), a.issue_yy)
                   AND a.pol_seq_no = NVL(TO_NUMBER(p_pol_seq_no), a.pol_seq_no)
                   AND a.renew_no = NVL(TO_NUMBER(p_renew_no), a.renew_no)
                   AND a.line_cd IN (SELECT line_cd
                                       FROM giis_line
                                      WHERE enrollee_tag = 'Y')
--                   AND a.line_cd IN (SELECT line_cd
--                                       FROM giis_subline
--                                      WHERE enrollee_tag = 'Y')
                   AND a.subline_cd IN (SELECT b.subline_cd
                                          FROM giis_subline b
                                         WHERE b.line_cd = a.line_cd -- apollo cruz 04.01.2015
                                           AND b.enrollee_tag = 'Y') -- changed the code above to display only records with enrollee_tag = 'Y'                   
                   AND check_user_per_iss_cd2 (a.line_cd, a.iss_cd, 'GIUTS023', p_user_id) = 1
              ORDER BY a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no) 
      LOOP
         v_list.par_id := i.par_id;
         v_list.assd_no := i.assd_no;
         v_list.policy_id := i.policy_id;
         v_list.line_cd := i.line_cd;
         v_list.subline_cd := i.subline_cd;
         v_list.iss_cd := i.iss_cd;
         v_list.issue_yy := i.issue_yy;
         v_list.pol_seq_no := i.pol_seq_no;
         v_list.renew_no := i.renew_no;
         v_list.endt_iss_cd := i.endt_iss_cd;
         v_list.endt_yy := i.endt_yy;
         v_list.endt_seq_no := i.endt_seq_no;
         v_list.policy_no := i.line_cd || '-' || i.subline_cd || '-' || i.iss_cd || '-' || LTRIM(TO_CHAR(i.issue_yy)) || '-' || LTRIM(TO_CHAR(i.pol_seq_no, '0000099')) || '-' || LTRIM(TO_CHAR(i.renew_no, '09'));
         
         BEGIN
             SELECT DISTINCT assd_name
               INTO v_list.assd_name
               FROM giis_assured
              WHERE assd_no = (SELECT DISTINCT assd_no
                                 FROM gipi_parlist
                                WHERE par_id = i.par_id);
         END;
         
         IF i.endt_seq_no != 0 THEN
            v_list.n_endt_iss_cd := i.endt_iss_cd;
            v_list.n_endt_yy := i.endt_yy;
            v_list.n_endt_seq_no := i.endt_seq_no;
            v_list.endorsement_no := i.endt_iss_cd || '-' || LTRIM(TO_CHAR(i.endt_yy)) || '-' || LTRIM(TO_CHAR(i.endt_seq_no, '000099'));
         ELSE
            v_list.endorsement_no := NULL;  --added by Gzelle 05.31.2013 
         END IF;
         
         PIPE ROW(v_list);
      END LOOP;
      RETURN;
   END get_policy_info_lov;
   
   FUNCTION get_item_info (
      p_policy_id VARCHAR2
   )
      RETURN item_info_tab PIPELINED
   IS
      v_list item_info_type;
   BEGIN
      FOR i IN (SELECT policy_id, item_no, item_title, item_desc
                  FROM gipi_item
                 WHERE policy_id = p_policy_id
              ORDER BY item_no)
      LOOP
         v_list.policy_id := i.policy_id;
         v_list.item_no := i.item_no;
         v_list.item_title := i.item_title;
         v_list.item_desc := i.item_desc;
         
         -- added by apollo cruz 04.01.2015
         -- items with records in gipi_itmperil_grouped must not be editable
         BEGIN
            SELECT 'N'
              INTO v_list.update_sw
              FROM gipi_itmperil_grouped
             WHERE policy_id = p_policy_id
               AND item_no = i.item_no
               AND ROWNUM = 1;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.update_sw := 'Y';           
         END;
         
         PIPE ROW(v_list);
      END LOOP; 
      RETURN;             
   END get_item_info;
   
   FUNCTION get_grouped_items_info (
      p_item_no gipi_grouped_items.item_no%TYPE,
      p_policy_id gipi_grouped_items.policy_id%TYPE
   )
      RETURN grouped_items_info_tab PIPELINED
   IS
      v_list grouped_items_info_type;
   BEGIN
      FOR i IN (SELECT a.grouped_item_no, a.grouped_item_title, a.sex, a.age, a.date_of_birth,
                       a.civil_status, a.amount_coverage, a.salary, a.salary_grade,
                       a.subline_cd, a.line_cd, a.include_tag, a.position_cd, a.policy_id, a.item_no, b.position
                  FROM gipi_grouped_items a, giis_position b
                 WHERE a.item_no = p_item_no
                   AND a.policy_id = p_policy_id
                   AND a.position_cd = b.position_cd(+))
      LOOP
         v_list.grouped_item_no := i.grouped_item_no;
         v_list.grouped_item_title := i.grouped_item_title;
         v_list.sex := i.sex;
         v_list.age := i.age;
         v_list.date_of_birth := i.date_of_birth;
         v_list.civil_status := i.civil_status;
         v_list.amount_coverage := i.amount_coverage;
         v_list.salary := i.salary;
         v_list.salary_grade := i.salary_grade;
         v_list.subline_cd := i.subline_cd;
         v_list.line_cd := i.line_cd;
         v_list.include_tag := i.include_tag;
         v_list.position_cd := i.position_cd;
         v_list.policy_id := i.policy_id;
         v_list.item_no := i.item_no;
         v_list.position := i.position;
         PIPE ROW(v_list);
      END LOOP;
      RETURN;
   END get_grouped_items_info;
   
   FUNCTION get_grouped_items (
      p_item_no     gipi_grouped_items.item_no%TYPE,
      p_policy_id   gipi_grouped_items.policy_id%TYPE
   )
      RETURN grouped_items_tab PIPELINED
   IS
      v_list grouped_items_type;
   BEGIN   
      FOR i IN (SELECT grouped_item_no, grouped_item_title
                 FROM gipi_grouped_items
                WHERE item_no = p_item_no
                   AND policy_id = p_policy_id)
      LOOP
         v_list.grouped_item_no := i.grouped_item_no;
         v_list.grouped_item_title := i.grouped_item_title;
         PIPE ROW(v_list);
      END LOOP;
      RETURN;             
   END get_grouped_items;
   
   FUNCTION validate_grouped_item_no (
      p_policy_id VARCHAR2,
      p_item_no VARCHAR2,
      p_grouped_item_no VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_count NUMBER(10);
      v_check VARCHAR2(100);
   BEGIN
       SELECT COUNT(*)
         INTO v_count
         FROM gipi_grouped_items
        WHERE policy_id = p_policy_id
          AND item_no = p_item_no
          AND grouped_item_no = p_grouped_item_no;
      IF v_count = 0 THEN
         v_check := 'SUCCESS';
      ELSE
         v_check := 'OUCH';   
      END IF;
      RETURN v_check;
   END validate_grouped_item_no;
   
   FUNCTION validate_beneficiary_no (
      p_policy_id         VARCHAR2,
      p_item_no           VARCHAR2,
      p_grouped_item_no   VARCHAR2,
      p_beneficiary_no    VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_count NUMBER(10);
      v_check VARCHAR2(100);
   BEGIN
      SELECT COUNT(*)
        INTO v_count
        FROM gipi_grp_items_beneficiary
       WHERE policy_id = p_policy_id
         AND item_no = p_item_no
         AND grouped_item_no = p_grouped_item_no
         AND beneficiary_no = p_beneficiary_no;
      IF v_count = 0 THEN
         v_check := 'SUCCESS';
      ELSE
         v_check := 'OUCH';   
      END IF;
      RETURN v_check;       
   END validate_beneficiary_no;      
   
   PROCEDURE save_grouped_items (
      p_grouped_item_no      gipi_grouped_items.grouped_item_no%TYPE,
      p_grouped_item_title   gipi_grouped_items.grouped_item_title%TYPE,
      p_sex                  gipi_grouped_items.sex%TYPE,
      p_age                  gipi_grouped_items.age%TYPE,
      p_date_of_birth        gipi_grouped_items.date_of_birth%TYPE,
      p_civil_status         gipi_grouped_items.civil_status%TYPE,
      p_amount_coverage      gipi_grouped_items.amount_coverage%TYPE,
      p_salary               gipi_grouped_items.salary%TYPE,
      p_salary_grade         gipi_grouped_items.salary_grade%TYPE,
      p_subline_cd           gipi_grouped_items.subline_cd%TYPE,
      p_line_cd              gipi_grouped_items.line_cd%TYPE,
      p_include_tag          gipi_grouped_items.include_tag%TYPE,
      p_position_cd          gipi_grouped_items.position_cd%TYPE,
      p_policy_id            gipi_grouped_items.policy_id%TYPE,
      p_item_no              gipi_grouped_items.item_no%TYPE
   )
   IS
   BEGIN
      MERGE INTO gipi_grouped_items
         USING DUAL
         ON (policy_id = p_policy_id
             AND item_no = p_item_no
             AND grouped_item_no = p_grouped_item_no)
         WHEN NOT MATCHED THEN
            INSERT (grouped_item_no, grouped_item_title, sex, age, date_of_birth,
                    civil_status, amount_coverage, salary, salary_grade, subline_cd,
                    line_cd, include_tag, position_cd, policy_id, item_no, last_update)
            VALUES (p_grouped_item_no, p_grouped_item_title, p_sex, p_age, p_date_of_birth,
                    p_civil_status, p_amount_coverage, p_salary, p_salary_grade, p_subline_cd,
                    p_line_cd, p_include_tag, p_position_cd, p_policy_id, p_item_no, sysdate)
         WHEN MATCHED THEN
            UPDATE
               SET grouped_item_title = p_grouped_item_title,
                   sex = p_sex,
                   age = p_age,
                   date_of_birth = p_date_of_birth,
                   civil_status = p_civil_status,
                   amount_coverage = p_amount_coverage,
                   salary = p_salary,
                   salary_grade = p_salary_grade,
                   subline_cd = p_subline_cd,
                   line_cd = p_line_cd,
                   include_tag = p_include_tag,
                   position_cd = p_position_cd,
                   last_update = sysdate;
                          
   END save_grouped_items;
   
   PROCEDURE save_beneficiary (
      p_policy_id          gipi_grp_items_beneficiary.policy_id%TYPE,
      p_item_no            gipi_grp_items_beneficiary.item_no%TYPE,
      p_grouped_item_no    gipi_grp_items_beneficiary.grouped_item_no%TYPE,
      p_beneficiary_no     gipi_grp_items_beneficiary.beneficiary_no%TYPE,
      p_beneficiary_name   gipi_grp_items_beneficiary.beneficiary_name%TYPE,
      p_relation           gipi_grp_items_beneficiary.relation%TYPE,
      p_sex                gipi_grp_items_beneficiary.sex%TYPE,
      p_civil_status       gipi_grp_items_beneficiary.civil_status%TYPE,
      p_date_of_birth      gipi_grp_items_beneficiary.date_of_birth%TYPE,
      p_age                gipi_grp_items_beneficiary.age%TYPE,
      p_beneficiary_addr   gipi_grp_items_beneficiary.beneficiary_addr%TYPE
   )
   IS
   BEGIN
      MERGE INTO gipi_grp_items_beneficiary
         USING DUAL
         ON (policy_id = p_policy_id
             AND item_no = p_item_no
             AND grouped_item_no = p_grouped_item_no
             AND beneficiary_no = p_beneficiary_no)
         WHEN NOT MATCHED THEN
            INSERT (policy_id, item_no, grouped_item_no, beneficiary_no,
                    beneficiary_name, relation, sex, civil_status, date_of_birth,
                    age, beneficiary_addr, last_update)
            VALUES (p_policy_id, p_item_no, p_grouped_item_no, p_beneficiary_no,
                    p_beneficiary_name, p_relation, p_sex, p_civil_status, p_date_of_birth,
                    p_age, p_beneficiary_addr, sysdate)
         WHEN MATCHED THEN
            UPDATE
               SET beneficiary_name = p_beneficiary_name,
               relation = p_relation,
               sex = p_sex,
               civil_status = p_civil_status,
               date_of_birth = p_date_of_birth,
               age = p_age,
               beneficiary_addr = p_beneficiary_addr,
               last_update = sysdate;
   END save_beneficiary;
   
   PROCEDURE delete_grouped_items (
      p_policy_id            gipi_grouped_items.policy_id%TYPE,
      p_item_no              gipi_grouped_items.item_no%TYPE,
      p_grouped_item_no      gipi_grouped_items.grouped_item_no%TYPE
   )
   IS
   BEGIN
      DELETE gipi_grouped_items
       WHERE policy_id = p_policy_id
         AND item_no = p_item_no
         AND grouped_item_no = p_grouped_item_no;
   
   END delete_grouped_items;
   
   PROCEDURE delete_beneficiary (
      p_policy_id         gipi_grouped_items.policy_id%TYPE,
      p_item_no           gipi_grouped_items.item_no%TYPE,
      p_grouped_item_no   gipi_grouped_items.grouped_item_no%TYPE,
      p_beneficiary_no    gipi_grp_items_beneficiary.beneficiary_no%TYPE
   )
   IS
   BEGIN
      DELETE gipi_grp_items_beneficiary
       WHERE policy_id = p_policy_id
         AND item_no = p_item_no
         AND grouped_item_no = p_grouped_item_no
         AND beneficiary_no = p_beneficiary_no;
   
   END delete_beneficiary;
   
   PROCEDURE delete_all_beneficiary (
      p_policy_id         gipi_grouped_items.policy_id%TYPE,
      p_item_no           gipi_grouped_items.item_no%TYPE,
      p_grouped_item_no   gipi_grouped_items.grouped_item_no%TYPE
   )
   IS
   BEGIN
      DELETE gipi_grp_items_beneficiary
       WHERE policy_id = p_policy_id
         AND item_no = p_item_no
         AND grouped_item_no = p_grouped_item_no;
   END delete_all_beneficiary;
   
   FUNCTION get_beneficiary (
      p_policy_id         VARCHAR2,
      p_item_no           VARCHAR2,
      p_grouped_item_no   VARCHAR2
   )
      RETURN beneficiary_tab PIPELINED
   IS
      v_list beneficiary_type;
   BEGIN
      FOR i IN (SELECT beneficiary_no, beneficiary_name, relation, sex,
                       civil_status, date_of_birth, age, beneficiary_addr,
                       policy_id, item_no, grouped_item_no
                  FROM gipi_grp_items_beneficiary 
                 WHERE policy_id = p_policy_id
                   AND item_no = p_item_no
                   AND grouped_item_no = p_grouped_item_no)
      LOOP
         v_list.beneficiary_no     := i.beneficiary_no;
         v_list.beneficiary_name   := i.beneficiary_name;
         v_list.relation           := i.relation;
         v_list.sex                := i.sex;
         v_list.civil_status       := i.civil_status;
         v_list.date_of_birth      := i.date_of_birth;
         v_list.age                := i.age;
         v_list.beneficiary_addr   := i.beneficiary_addr;
         v_list.policy_id          := i.policy_id;
         v_list.item_no            := i.item_no;
         v_list.grouped_item_no    := i.grouped_item_no;
         PIPE ROW(v_list);
      END LOOP;
      RETURN;             
   END get_beneficiary;
   
   FUNCTION get_beneficiary_nos (
      p_policy_id         VARCHAR2,
      p_item_no           VARCHAR2,
      p_grouped_item_no   VARCHAR2
   )
      RETURN beneficiary_nos_tab PIPELINED
   IS
      v_list beneficiary_nos_type;
   BEGIN
      FOR i IN (SELECT beneficiary_no
                  FROM gipi_grp_items_beneficiary 
                 WHERE policy_id = p_policy_id
                   AND item_no = p_item_no
                   AND grouped_item_no = p_grouped_item_no)
      LOOP
         v_list.beneficiary_no := i.beneficiary_no;
         PIPE ROW(v_list);
      END LOOP;
      RETURN;
   END get_beneficiary_nos;      
   
   FUNCTION show_other_cert (
      p_line_cd          	VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_show 			 VARCHAR2(1) := 'N';
      v_print_other_cert GIIS_PARAMETERS.param_value_v%TYPE := giisp.v('PRINT_OTHER_CERTIFICATE');
   BEGIN
   	   IF NVL(v_print_other_cert,'N') = 'Y' THEN
	   	SELECT NVL(other_cert_tag,'N')
		  INTO v_show
		  FROM giis_line
		 WHERE line_cd = p_line_cd;
   	   END IF;
      RETURN v_show;
   END show_other_cert;  
      
END;
/


