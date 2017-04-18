CREATE OR REPLACE PACKAGE BODY CPI.GIPI_GROUPED_ITEMS_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 05.06.2011
	**  Reference By 	: (GIPIS065 - Endt Item Information - AC)
	**  Description 	: Retrieves record from gipi_grouped_items based on the given condition and parameters
	*/
	FUNCTION get_gipi_grouped_items_endt (
		p_line_cd IN gipi_polbasic.line_cd%TYPE,
		p_subline_cd IN gipi_polbasic.subline_cd%TYPE,
		p_iss_cd IN gipi_polbasic.iss_cd%TYPE,
		p_issue_yy IN gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no IN gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no IN gipi_polbasic.renew_no%TYPE,
        p_item_no IN gipi_grouped_items.item_no%TYPE,
        p_grouped_item_no IN gipi_grouped_items.grouped_item_no%TYPE)
    RETURN gipi_grouped_items_tab PIPELINED
    IS
        v_grouped_items gipi_grouped_items_type;
    BEGIN
        FOR pol IN (
            SELECT policy_id
              FROM gipi_polbasic
             WHERE line_cd = p_line_cd
               AND iss_cd = p_iss_cd
               AND subline_cd = p_subline_cd
               AND issue_yy = p_issue_yy
               AND pol_seq_no = p_pol_seq_no
               AND renew_no = p_renew_no
               AND pol_flag IN ('1','2','3','X')
          ORDER BY eff_date)
        LOOP
            FOR i IN (
                SELECT *
                  FROM gipi_grouped_items
                 WHERE grouped_item_no = p_grouped_item_no
                   AND item_no = p_item_no
                   AND NVL(delete_sw,'N')!= 'Y'
                   AND policy_id = pol.policy_id )
            LOOP
                v_grouped_items.policy_id            := i.policy_id;
                v_grouped_items.item_no                := i.item_no;
                v_grouped_items.grouped_item_no        := i.grouped_item_no;
                v_grouped_items.grouped_item_title    := i.grouped_item_title;
                v_grouped_items.include_tag            := i.include_tag;
                v_grouped_items.sex                    := i.sex;
                v_grouped_items.position_cd            := i.position_cd;
                v_grouped_items.civil_status        := i.civil_status;
                v_grouped_items.date_of_birth        := i.date_of_birth;
                v_grouped_items.age                    := i.age;
                v_grouped_items.salary                := i.salary;
                v_grouped_items.salary_grade        := i.salary_grade;
                v_grouped_items.amount_coverage        := i.amount_coverage;
                v_grouped_items.remarks                := i.remarks;
                v_grouped_items.line_cd                := i.line_cd;
                v_grouped_items.subline_cd            := i.subline_cd;
                v_grouped_items.cpi_rec_no            := i.cpi_rec_no;
                v_grouped_items.cpi_branch_cd        := i.cpi_branch_cd;
                v_grouped_items.delete_sw            := i.delete_sw;
                v_grouped_items.group_cd            := i.group_cd;
                v_grouped_items.user_id                := i.user_id;
                v_grouped_items.last_update            := i.last_update;
                v_grouped_items.pack_ben_cd            := i.pack_ben_cd;
                v_grouped_items.ann_tsi_amt            := i.ann_tsi_amt;
                v_grouped_items.ann_prem_amt        := i.ann_prem_amt;
                v_grouped_items.control_cd            := i.control_cd;
                v_grouped_items.control_type_cd        := i.control_type_cd;
                v_grouped_items.tsi_amt                := i.tsi_amt;
                v_grouped_items.prem_amt            := i.prem_amt;
                v_grouped_items.from_date            := i.from_date;
                v_grouped_items.to_date                := i.to_date;
                v_grouped_items.payt_terms            := i.payt_terms;
                v_grouped_items.principal_cd        := i.principal_cd;
                v_grouped_items.arc_ext_data        := i.arc_ext_data;
                PIPE ROW(v_grouped_items);
            END LOOP;
        END LOOP;
        RETURN;
    END get_gipi_grouped_items_endt;
    /*
    **  Created by        : Mark JM
    **  Date Created     : 05.09.2011
    **  Reference By     : (GIPIS065 - Endt Item Information - AC)
    **  Description     : Check if certain group item is zero out or negated
    */
    FUNCTION is_zero_out_or_negated (
        p_line_cd IN gipi_polbasic.line_cd%TYPE,
        p_subline_cd IN gipi_polbasic.subline_cd%TYPE,
        p_iss_cd IN gipi_polbasic.iss_cd%TYPE,
        p_issue_yy IN gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no IN gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no IN gipi_polbasic.renew_no%TYPE,
        p_eff_date IN gipi_wpolbas.eff_date%TYPE,
        p_item_no IN gipi_item.item_no%TYPE,
        p_item_from_date IN gipi_item.from_date%TYPE,
        p_grouped_item_no IN gipi_grouped_items.grouped_item_no%TYPE,
        p_grp_from_date IN gipi_grouped_items.from_date%TYPE)
    RETURN VARCHAR2
    IS
        v_message VARCHAR2(100) := NULL;
    BEGIN
        FOR A IN (
            SELECT c.ann_tsi_amt, c.ann_prem_amt
              FROM gipi_item b,gipi_polbasic a, gipi_grouped_items c
             WHERE a.line_cd = p_line_cd
               AND a.iss_cd = p_iss_cd
               AND a.subline_cd = p_subline_cd
               AND a.issue_yy = p_issue_yy
               AND a.pol_seq_no = p_pol_seq_no
               AND a.renew_no = p_renew_no
               AND a.pol_flag IN( '1','2','3','X')
               AND TRUNC(NVL(NVL(c.from_date, b.from_date),a.eff_date))
                    <= TRUNC(NVL(NVL(p_grp_from_date, p_item_from_date), p_eff_date))
               AND NVL(NVL(c.to_date, b.to_date),NVL(a.endt_expiry_date, a.expiry_date))
                    >=  NVL(NVL(p_grp_from_date, p_item_from_date), p_eff_date)
               AND a.policy_id = b.policy_id
               AND b.policy_id = c.policy_id
               AND b.item_no = c.item_no
               AND b.item_no = p_item_no
               AND c.grouped_item_no = p_grouped_item_no
          ORDER BY a.eff_date desc)
        LOOP
              IF A.ann_tsi_amt = 0 AND A.ann_prem_amt = 0 THEN
                   v_message := 'This group item had already been negated or zero out on previous endorsement.';
              END IF;
              EXIT;
        END LOOP;
        RETURN v_message;
    END is_zero_out_or_negated;

    FUNCTION check_if_principal_enrollee (
        p_line_cd IN gipi_polbasic.line_cd%TYPE,
        p_subline_cd IN gipi_polbasic.subline_cd%TYPE,
        p_iss_cd IN gipi_polbasic.iss_cd%TYPE,
        p_issue_yy IN gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no IN gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no IN gipi_polbasic.renew_no%TYPE,
        p_item_no IN gipi_grouped_items.item_no%TYPE,
        p_grouped_item_no IN gipi_grouped_items.grouped_item_no%TYPE)
    RETURN VARCHAR2
    IS
        v_message VARCHAR2(100) := NULL;
    BEGIN
        FOR pol IN (
            SELECT policy_id
              FROM gipi_polbasic
             WHERE line_cd = p_line_cd
               AND iss_cd = p_iss_cd
               AND subline_cd = p_subline_cd
               AND issue_yy = p_issue_yy
               AND pol_seq_no = p_pol_seq_no
               AND renew_no = p_renew_no
               AND pol_flag IN ('1','2','3','X')
          ORDER BY eff_date)
        LOOP
            FOR A IN (
                SELECT grouped_item_no, principal_cd
                  FROM gipi_grouped_items
                 WHERE principal_cd = p_grouped_item_no
                   AND item_no = p_item_no
                   AND policy_id = pol.policy_id )
            LOOP
                v_message := 'Cannot delete Enrollee. Currently being used as the principal of other enrollees.';
            END LOOP;
        END LOOP;

        RETURN v_message;
    END check_if_principal_enrollee;

    /*
    **  Created by        : Moses Calma
    **  Date Created      : 06.16.2011
    **  Reference By      : (GIPIS100 - Policy Information)
    **  Description       : Returns grouped items of a casualty item
    */
    FUNCTION get_casualty_grouped_items(
       p_policy_id   gipi_grouped_items.policy_id%TYPE,
       p_item_no     gipi_grouped_items.item_no%TYPE
    )
      RETURN casualty_grouped_item_tab PIPELINED
    IS
       v_casualty_grouped_item    casualty_grouped_item_type;

    BEGIN
       FOR i IN (SELECT policy_id, item_no, sex, age, salary, remarks, position_cd,
                        include_tag, salary_grade, civil_status, date_of_birth,
                        grouped_item_no, amount_coverage, grouped_item_title
                   FROM gipi_grouped_items
                  WHERE policy_id = p_policy_id
                    AND item_no = p_item_no)
      LOOP

        v_casualty_grouped_item.policy_id           := i.policy_id;
        v_casualty_grouped_item.item_no             := i.item_no;
        v_casualty_grouped_item.sex                 := i.sex;
        v_casualty_grouped_item.age                 := i.age;
        v_casualty_grouped_item.salary              := i.salary;
        v_casualty_grouped_item.remarks             := i.remarks;
        v_casualty_grouped_item.position_cd         := i.position_cd;
        v_casualty_grouped_item.include_tag         := i.include_tag;
        v_casualty_grouped_item.salary_grade        := i.salary_grade;
        v_casualty_grouped_item.civil_status        := i.civil_status;
        v_casualty_grouped_item.date_of_birth       := i.date_of_birth;
        v_casualty_grouped_item.grouped_item_no     := i.grouped_item_no;
        v_casualty_grouped_item.amount_coverage     := i.amount_coverage;
        v_casualty_grouped_item.grouped_item_title  := i.grouped_item_title;

        BEGIN

          SELECT SUM (amount_coverage)
            INTO v_casualty_grouped_item.sum_amt
            FROM gipi_grouped_items
           WHERE policy_id = i.policy_id AND item_no = i.item_no;

        EXCEPTION
        WHEN NO_DATA_FOUND
        THEN

          v_casualty_grouped_item.sum_amt := '';

        END;

        BEGIN

          SELECT rv_meaning
            INTO v_casualty_grouped_item.mean_sex
            FROM cg_ref_codes
           WHERE rv_low_value = i.sex AND rv_domain LIKE '%SEX%';

        EXCEPTION
        WHEN NO_DATA_FOUND
        THEN

          v_casualty_grouped_item.mean_sex := '';

        END;

        BEGIN

          SELECT rv_meaning
            INTO v_casualty_grouped_item.mean_civil_status
            FROM cg_ref_codes
           WHERE rv_low_value = i.civil_status AND rv_domain LIKE '%CIVIL%';

        EXCEPTION
        WHEN NO_DATA_FOUND
        THEN

          v_casualty_grouped_item.mean_civil_status := '';

        END;

        PIPE ROW (v_casualty_grouped_item);

      END LOOP;

    END get_casualty_grouped_items;

    /*
    **  Created by        : Moses Calma
    **  Date Created      : 06.27.2011
    **  Reference By      : (GIPIS100 - Policy Information)
    **  Description       : Returns grouped items of an accident item
    */
    FUNCTION get_accident_grouped_items(
       p_policy_id   gipi_grouped_items.policy_id%TYPE,
       p_item_no     gipi_grouped_items.item_no%TYPE,
       p_grouped_item_no GIPI_GROUPED_ITEMS.GROUPED_ITEM_NO%TYPE,
       p_grouped_item_title GIPI_GROUPED_ITEMS.GROUPED_ITEM_TITLE%TYPE
    )
      RETURN accident_grouped_item_tab PIPELINED
    IS
       v_accident_grouped_item    accident_grouped_item_type;

    BEGIN
       FOR i IN (SELECT grouped_item_no, grouped_item_title, principal_cd, pack_ben_cd,
                        payt_terms, from_date, to_date, date_of_birth, age, amount_coverage,
                        group_cd, control_type_cd, control_cd, salary, salary_grade,
                        position_cd, sex, policy_id, item_no, line_cd, subline_cd,
                        civil_status, include_tag, remarks
                   FROM gipi_grouped_items
                  WHERE policy_id = p_policy_id
                    AND item_no = p_item_no
                    AND grouped_item_no = NVL(p_grouped_item_no, grouped_item_no)
                    AND UPPER(grouped_item_title) LIKE UPPER(NVL(p_grouped_item_title, grouped_item_title))
                   )
      LOOP

        v_accident_grouped_item.policy_id           := i.policy_id;
        v_accident_grouped_item.item_no             := i.item_no;
        v_accident_grouped_item.remarks             := i.remarks;
        v_accident_grouped_item.salary              := i.salary;
        v_accident_grouped_item.age                 := i.age;
        v_accident_grouped_item.sex                 := i.sex;
        v_accident_grouped_item.line_cd             := i.line_cd;
        v_accident_grouped_item.to_date             := i.to_date;
        v_accident_grouped_item.group_cd            := i.group_cd;
        v_accident_grouped_item.from_date           := i.from_date;
        v_accident_grouped_item.payt_terms          := i.payt_terms;
        v_accident_grouped_item.subline_cd          := i.subline_cd;
        v_accident_grouped_item.control_cd          := i.control_cd;
        v_accident_grouped_item.pack_ben_cd         := i.pack_ben_cd;
        v_accident_grouped_item.position_cd         := i.position_cd;
        v_accident_grouped_item.include_tag         := i.include_tag;
        v_accident_grouped_item.salary_grade        := i.salary_grade;
        v_accident_grouped_item.civil_status        := i.civil_status;
        v_accident_grouped_item.principal_cd        := i.principal_cd;
        v_accident_grouped_item.date_of_birth       := i.date_of_birth;
        v_accident_grouped_item.grouped_item_no     := i.grouped_item_no;
        v_accident_grouped_item.control_type_cd     := i.control_type_cd;
        v_accident_grouped_item.amount_coverage     := i.amount_coverage;
        v_accident_grouped_item.grouped_item_title  := i.grouped_item_title;

        IF i.sex = 'F' THEN

  	        v_accident_grouped_item.mean_sex := 'Female';

        ELSIF i.sex = 'M' THEN

  	        v_accident_grouped_item.mean_sex := 'Male';

        END IF;

        IF i.civil_status = 'D' THEN

            v_accident_grouped_item.mean_civil_status := 'Divorced';

        ELSIF	i.civil_status = 'L' THEN

            v_accident_grouped_item.mean_civil_status := 'Legally Separated';

        ELSIF	i.civil_status = 'M' THEN

            v_accident_grouped_item.mean_civil_status := 'Married';

        ELSIF	i.civil_status = 'S' THEN

            v_accident_grouped_item.mean_civil_status := 'Single';

        ELSIF	i.civil_status = 'W' THEN

            v_accident_grouped_item.mean_civil_status := 'Widow(er)';

        END IF;

        BEGIN

            SELECT group_desc
              INTO v_accident_grouped_item.group_desc
              FROM giis_group
             WHERE group_cd = i.group_cd;

        EXCEPTION
        WHEN NO_DATA_FOUND
        THEN

            v_accident_grouped_item.group_desc := '';

        END;

        BEGIN

            SELECT position
              INTO v_accident_grouped_item.position
              FROM giis_position
             WHERE position_cd = i.position_cd;

        EXCEPTION
        WHEN NO_DATA_FOUND
        THEN

            v_accident_grouped_item.position := '';

        END;

        BEGIN

            SELECT package_cd
              INTO v_accident_grouped_item.package_cd
              FROM giis_package_benefit
             WHERE pack_ben_cd = i.pack_ben_cd;

        EXCEPTION
        WHEN NO_DATA_FOUND
        THEN

            v_accident_grouped_item.package_cd := '';

        END;

        BEGIN

            SELECT payt_terms_desc
              INTO v_accident_grouped_item.payt_terms_desc
              FROM giis_payterm
             WHERE payt_terms = i.payt_terms;

        EXCEPTION
        WHEN NO_DATA_FOUND
        THEN

            v_accident_grouped_item.payt_terms_desc := '';

        END;

        BEGIN

            SELECT control_type_desc
              INTO v_accident_grouped_item.control_type_desc
              FROM giis_control_type
             WHERE control_type_cd = i.control_type_cd;

        EXCEPTION
        WHEN NO_DATA_FOUND
        THEN

            v_accident_grouped_item.control_type_desc := '';

        END;




        PIPE ROW (v_accident_grouped_item);

      END LOOP;

    END get_accident_grouped_items;

END GIPI_GROUPED_ITEMS_PKG;
/


