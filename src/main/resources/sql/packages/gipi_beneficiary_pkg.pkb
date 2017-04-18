CREATE OR REPLACE PACKAGE BODY CPI.gipi_beneficiary_pkg
AS
   /*
   **  Created by   : Moses Calma
   **  Date Created : July 4, 2011
   **  Reference By : (GIPIS100 - View Policy Information)
   **  Description  : Retrieves records of item beneficiaries
   */
   FUNCTION get_gipi_beneficiaries (
      p_policy_id   gipi_beneficiary.policy_id%TYPE,
      p_item_no     gipi_beneficiary.item_no%TYPE
   )
      RETURN gipi_beneficiary_tab PIPELINED
   IS
      v_gipi_beneficiary   gipi_beneficiary_type;
   BEGIN
      FOR i IN (SELECT   policy_id, item_no, age, sex, relation, adult_sw,
                         delete_sw, position_cd, civil_status, date_of_birth,
                         beneficiary_no, beneficiary_name, beneficiary_addr,
                         cpi_branch_cd, arc_ext_data, cpi_rec_no, remarks
                    FROM gipi_beneficiary
                   WHERE policy_id = p_policy_id
                     AND item_no = p_item_no
                ORDER BY beneficiary_no)
      LOOP
         v_gipi_beneficiary.policy_id := i.policy_id;
         v_gipi_beneficiary.item_no := i.item_no;
         v_gipi_beneficiary.age := i.age;
         v_gipi_beneficiary.sex := i.sex;
         v_gipi_beneficiary.relation := i.relation;
         v_gipi_beneficiary.adult_sw := i.adult_sw;
         v_gipi_beneficiary.delete_sw := i.delete_sw;
         v_gipi_beneficiary.position_cd := i.position_cd;
         v_gipi_beneficiary.civil_status := i.civil_status;
         v_gipi_beneficiary.date_of_birth := i.date_of_birth;
         v_gipi_beneficiary.beneficiary_no := i.beneficiary_no;
         v_gipi_beneficiary.beneficiary_name := i.beneficiary_name;
         v_gipi_beneficiary.beneficiary_addr := i.beneficiary_addr;
         v_gipi_beneficiary.cpi_branch_cd := i.cpi_branch_cd;
         v_gipi_beneficiary.arc_ext_data := i.arc_ext_data;
         v_gipi_beneficiary.cpi_rec_no := i.cpi_rec_no;
         v_gipi_beneficiary.remarks := i.remarks;

         BEGIN
            SELECT position
              INTO v_gipi_beneficiary.position
              FROM giis_position
             WHERE position_cd = i.position_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_gipi_beneficiary.POSITION := '';
         END;

         BEGIN
            SELECT rv_meaning
              INTO v_gipi_beneficiary.mean_civil_status
              FROM cg_ref_codes
             WHERE rv_low_value = i.civil_status AND rv_domain LIKE '%CIVIL%';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_gipi_beneficiary.mean_civil_status := '';
         END;

         BEGIN

            SELECT rv_meaning
              INTO v_gipi_beneficiary.mean_sex
              FROM cg_ref_codes
             WHERE rv_low_value = i.sex
               AND rv_domain
              LIKE '%SEX%';

         EXCEPTION
         WHEN NO_DATA_FOUND
         THEN

            v_gipi_beneficiary.mean_sex := '';

         END;

         PIPE ROW (v_gipi_beneficiary);
      END LOOP;
   END get_gipi_beneficiaries;

    /*    Date        Author            Description
    **    ==========    ===============    ============================
    **    10.18.2011    mark jm            retrieve beneficiary record in gipi_beneficiary based on given parameters
    **                                Reference by : GIPIS065 - Item Information (Accident) Endt
    */
    FUNCTION get_gipi_beneficiary (
        p_par_id IN gipi_parlist.par_id%TYPE,
        p_item_no IN gipi_beneficiary.item_no%TYPE,
        p_ben_no IN gipi_beneficiary.beneficiary_no%TYPE)
    RETURN gipi_beneficiary_tab PIPELINED
    IS
        v_gipi_beneficiary   gipi_beneficiary_type;
    BEGIN
        FOR x IN (
            SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
              FROM gipi_wpolbas
             WHERE par_id = p_par_id)
        LOOP
            FOR i IN (
                SELECT a.beneficiary_no, a.beneficiary_name, a.relation, a.beneficiary_addr
                  FROM gipi_beneficiary a,gipi_polbasic b
                 WHERE b.line_cd = x.line_cd
                   AND b.iss_cd = x.iss_cd
                   AND b.subline_cd = x.subline_cd
                   AND b.issue_yy = x.issue_yy
                   AND b.pol_seq_no = x.pol_seq_no
                   AND a.beneficiary_no = p_ben_no
                   AND a.policy_id = b.policy_id
                   AND a.item_no = p_item_no
                   AND NVL(a.delete_sw,'N')!= 'Y'
                   AND b.eff_date = (SELECT MAX(eff_date)
                                       FROM gipi_polbasic a,gipi_beneficiary b
                                      WHERE a.line_cd = x.line_cd
                                        AND a.iss_cd = x.iss_cd
                                        AND a.subline_cd = x.subline_cd
                                        AND a.issue_yy = x.issue_yy
                                        AND a.pol_seq_no = x.pol_seq_no
                                        AND a.renew_no  = x.renew_no
                                        AND b.beneficiary_no = p_ben_no
                                        AND a.policy_id = b.policy_id
                                        AND b.item_no = p_item_no
                                        AND a.pol_flag IN ('1','2','3','X')))
            LOOP
                v_gipi_beneficiary.beneficiary_no     := i.beneficiary_no;
                v_gipi_beneficiary.beneficiary_name := i.beneficiary_name;
                v_gipi_beneficiary.relation         := i.relation;
                v_gipi_beneficiary.beneficiary_addr := i.beneficiary_addr;

                PIPE ROW(v_gipi_beneficiary);

                EXIT;
            END LOOP;
        END LOOP;

        RETURN;
    END get_gipi_beneficiary;
END gipi_beneficiary_pkg;
/


