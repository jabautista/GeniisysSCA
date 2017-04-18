CREATE OR REPLACE PACKAGE BODY CPI.GIPI_CASUALTY_ITEM_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 09.30.2010
	**  Reference By 	: (GIPIS061 - Endt Item Information - CA)
	**  Description 	: This procedure is used for retrieving records on GIPI_CASUALTY_ITEM table
	*/
	FUNCTION get_gipi_casualty_item (
		p_policy_id IN gipi_casualty_item.policy_id%TYPE,
		p_item_no	IN gipi_casualty_item.item_no%TYPE)
	RETURN gipi_casualty_item_tab PIPELINED
	AS
		v_casualty_item gipi_casualty_item_type;
	BEGIN
		FOR i IN (
			SELECT policy_id,	item_no,		section_line_cd,	section_subline_cd,
				   section_or_hazard_cd,		capacity_cd,		property_no_type,
				   property_no,	location,		conveyance_info,	interest_on_premises,
				   limit_of_liability,			section_or_hazard_info,
				   arc_ext_data,				location_cd
			  FROM gipi_casualty_item
			 WHERE policy_id = p_policy_id
			   AND item_no = p_item_no)
		LOOP
			v_casualty_item.policy_id				:= i.policy_id;
			v_casualty_item.item_no					:= i.item_no;
			v_casualty_item.section_line_cd			:= i.section_line_cd;
			v_casualty_item.section_subline_cd		:= i.section_subline_cd;
			v_casualty_item.section_or_hazard_cd	:= i.section_or_hazard_cd;
			v_casualty_item.capacity_cd				:= i.capacity_cd;
			v_casualty_item.property_no_type		:= i.property_no_type;
			v_casualty_item.property_no				:= i.property_no;
			v_casualty_item.location				:= i.location;
			v_casualty_item.conveyance_info			:= i.conveyance_info;
			v_casualty_item.interest_on_premises	:= i.interest_on_premises;
			v_casualty_item.limit_of_liability		:= i.limit_of_liability;
			v_casualty_item.section_or_hazard_info	:= i.section_or_hazard_info;
            v_casualty_item.arc_ext_data            := i.arc_ext_data;
            v_casualty_item.location_cd                := i.location_cd;

            PIPE ROW(v_casualty_item);
        END LOOP;

        RETURN;
    END get_gipi_casualty_item;

    /*
    **  Created by        : Moses Calma
    **  Date Created     : 06.14.2011
    **  Reference By     : (GIPIS100 - Policy Information)
    **  Description     :  Retrieves additional information of a casualty item
    */
    FUNCTION get_casualty_item_info(
       p_policy_id   gipi_casualty_item.policy_id%TYPE,
       p_item_no     gipi_casualty_item.item_no%TYPE
    )
       RETURN casualty_item_info_tab PIPELINED
    IS
       v_casualty_item_info     casualty_item_info_type;
       v_line_cd                gipi_polbasic.line_cd%TYPE;
       v_subline_cd             gipi_polbasic.subline_cd%TYPE;
       v_iss_cd                 gipi_polbasic.iss_cd%TYPE;
       v_issue_yy               gipi_polbasic.issue_yy%TYPE;
       v_pol_seq_no             gipi_polbasic.pol_seq_no%TYPE;
       v_renew_no               gipi_polbasic.renew_no%TYPE;
       v_policy_id_endt_0       gipi_polbasic.policy_id%TYPE;
       v_line_cd_endt_0         gipi_polbasic.line_cd%TYPE;
       v_line_name_endt_0       giis_line.line_name%TYPE;

    BEGIN
       FOR i IN (SELECT item_no, policy_id, LOCATION, section_line_cd, section_subline_cd,
                        section_or_hazard_cd, capacity_cd, property_no_type, property_no,
                        conveyance_info, interest_on_premises, limit_of_liability,
                        section_or_hazard_info
                   FROM gipi_casualty_item
                  WHERE policy_id = p_policy_id
                    AND item_no = p_item_no)
       LOOP

          v_casualty_item_info.policy_id              := i.policy_id;
          v_casualty_item_info.item_no                := i.item_no;
          v_casualty_item_info.location               := i.location;
          v_casualty_item_info.section_line_cd        := i.section_line_cd;
          v_casualty_item_info.section_subline_cd     := i.section_subline_cd;
          v_casualty_item_info.section_or_hazard_cd   := i.section_or_hazard_cd;
          v_casualty_item_info.capacity_cd            := i.capacity_cd;
          v_casualty_item_info.property_no_type       := i.property_no_type;
          v_casualty_item_info.property_no            := i.property_no;
          v_casualty_item_info.conveyance_info        := i.conveyance_info;
          v_casualty_item_info.interest_on_premises   := i.interest_on_premises;
          v_casualty_item_info.limit_of_liability     := i.limit_of_liability;
          v_casualty_item_info.section_or_hazard_info := i.section_or_hazard_info;

          BEGIN

             SELECT item_title
               INTO v_casualty_item_info.item_title
               FROM gipi_item
              WHERE policy_id = i.policy_id
                AND item_no = i.item_no;

          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                v_casualty_item_info.item_title    := '';
          END;

          BEGIN

            SELECT section_or_hazard_title
              INTO v_casualty_item_info.section_or_hazard_title
              FROM giis_section_or_hazard
             WHERE section_line_cd = i.section_line_cd
               AND section_subline_cd = i.section_subline_cd
               AND section_or_hazard_cd = i.section_or_hazard_cd;

          EXCEPTION
          WHEN NO_DATA_FOUND
          THEN

              v_casualty_item_info.section_or_hazard_title := '';

          END;

          BEGIN

            SELECT position
              INTO v_casualty_item_info.capacity_name
              FROM giis_position
             WHERE position_cd = i.capacity_cd;

          EXCEPTION
          WHEN NO_DATA_FOUNd
          THEN

              v_casualty_item_info.capacity_name := '';

          END;

          BEGIN

            SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
              INTO v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no
              FROM gipi_polbasic
             WHERE policy_id = i.policy_id;

          END;

          BEGIN

            SELECT a.policy_id, a.line_cd,b.line_name
              INTO v_policy_id_endt_0,v_line_cd_endt_0,v_line_name_endt_0
              FROM gipi_polbasic a, giis_line b
             WHERE a.endt_seq_no = 0
               AND a.line_cd = v_line_cd
               AND a.subline_cd = v_subline_cd
               AND a.iss_cd = v_iss_cd
               AND a.issue_yy = v_issue_yy
               AND a.pol_seq_no = v_pol_seq_no
               AND a.renew_no = v_renew_no
               AND a.line_cd = b.line_cd;
          END;

          IF v_line_name_endt_0 like '%CASUALTY%' THEN

            BEGIN
              SELECT a.location_cd, b.location_desc
                INTO v_casualty_item_info.location_cd, v_casualty_item_info.location_desc
                FROM gipi_casualty_item a, giis_ca_location b
               WHERE a.location_cd = b.location_cd
                 AND a.item_no = i.item_no
                 AND a.policy_id = v_policy_id_endt_0;

            EXCEPTION
            WHEN NO_DATA_FOUND
            THEN

               v_casualty_item_info.location_cd     := '';
               v_casualty_item_info.location_desc   := '';

            END;


          END IF;

          PIPE ROW (v_casualty_item_info);
       END LOOP;

    END get_casualty_item_info;


END GIPI_CASUALTY_ITEM_PKG;
/


