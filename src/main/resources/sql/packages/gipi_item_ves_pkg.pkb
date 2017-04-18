CREATE OR REPLACE PACKAGE BODY CPI.GIPI_ITEM_VES_PKG AS

   FUNCTION get_marine_hulls

      RETURN marine_hulls_tab PIPELINED

   IS
      v_marine_hulls   marine_hulls_type;

   BEGIN

      FOR i IN (SELECT a.vessel_cd,a.policy_id,b.line_cd||'-'
                       ||b.subline_cd||'-'
                       ||b.iss_cd||'-'
                       ||to_char(b.issue_yy,'09')||'-'
                       ||to_char(b.pol_seq_no,'0000009')||'-'
                       ||to_char(b.renew_no,'09') policy_no
                  FROM gipi_item_ves a,
                       gipi_polbasic b
                 WHERE a.policy_id = b.policy_id)
      LOOP

         v_marine_hulls.vessel_cd    := i.vessel_cd;
         v_marine_hulls.policy_id    := i.policy_id;
         v_marine_hulls.policy_no    := i.policy_no;

         SELECT vessel_name
           INTO v_marine_hulls.vessel_name
           FROM giis_vessel
          WHERE vessel_cd = i.vessel_cd;

         PIPE ROW (v_marine_hulls);

      END LOOP;

   END get_marine_hulls;                                     --MOSES 04132011


   /*
   **  Created by    : Andrew Robes
   **  Date Created  : 05.27.2011
   **  Reference By  : (GIPIS081 - Marine Hull Item Info - Endorsement)
   **  Description   : This function retrieves records fro gipi_item_ves
   **                   based on the policy_id and item_no
   */
   FUNCTION get_gipi_item_ves(p_policy_id    GIPI_ITEM.policy_id%TYPE,
                              p_item_no      GIPI_ITEM.item_no %TYPE)
   RETURN gipi_item_ves_par_tab PIPELINED
   IS
    v_ves   GIPI_ITEM_VES_PAR_TYPE;
   BEGIN

        FOR i IN (
            SELECT a.policy_id, a.item_no,
                   a.vessel_cd, b.vessel_flag,
                   b.vessel_name, b.vessel_old_name,
                   c.vestype_desc, b.propel_sw,
                   d.vess_class_desc, e.hull_desc,
                   b.reg_owner, b.reg_place,
                   b.gross_ton, b.year_built,
                   b.net_ton, b.no_crew,
                   b.deadweight, b.crew_nat,
                   b.vessel_length, b.vessel_breadth,
                   b.vessel_depth, a.dry_place,
                   TO_CHAR (a.dry_date, 'mm-dd-yyyy') dry_date, a.deduct_text,
                   a.rec_flag, a.geog_limit
            FROM gipi_item_ves a,
                   giis_vessel b,
                   giis_vestype c,
                   giis_vess_class d,
                   giis_hull_type e
             WHERE a.policy_id = p_policy_id
               AND a.item_no = p_item_no
               AND a.vessel_cd = b.vessel_cd
               AND b.vestype_cd = c.vestype_cd
               AND b.vess_class_cd = d.vess_class_cd
               AND b.hull_type_cd = e.hull_type_cd)
        LOOP
            v_ves.policy_id                := i.policy_id;
            v_ves.item_no                  := i.item_no;
            v_ves.vessel_cd                := i.vessel_cd;
            v_ves.vessel_flag              := i.vessel_flag;
            v_ves.vessel_name              := i.vessel_name;
            v_ves.vessel_old_name          := i.vessel_old_name;
            v_ves.vestype_desc             := i.vestype_desc;
            v_ves.propel_sw                := i.propel_sw;
            v_ves.vess_class_desc          := i.vess_class_desc;
            v_ves.hull_desc                := i.hull_desc;
            v_ves.reg_owner                := i.reg_owner;
            v_ves.reg_place                := i.reg_place;
            v_ves.gross_ton                := i.gross_ton;
            v_ves.year_built               := i.year_built;
            v_ves.net_ton                  := i.net_ton;
            v_ves.no_crew                  := i.no_crew;
            v_ves.deadweight               := i.deadweight;
            v_ves.crew_nat                 := i.crew_nat;
            v_ves.vessel_length            := i.vessel_length;
            v_ves.vessel_breadth           := i.vessel_breadth;
            v_ves.vessel_depth             := i.vessel_depth;
            v_ves.dry_place                := i.dry_place;
            v_ves.dry_date                 := i.dry_date;
            v_ves.rec_flag                 := i.rec_flag;
            v_ves.deduct_text              := i.deduct_text;
            v_ves.geog_limit               := i.geog_limit;

            PIPE ROW(v_ves);
        END LOOP;

        RETURN;
   END get_gipi_item_ves;

  /*
  **  Created by    : Moses Calma
  **  Date Created  : 06.10.2011
  **  Reference By  : (GIPIS100 - Policy Information - Item Additional Information)
  **  Description   : This function retrieves record of a vessel type item
  */
  FUNCTION get_item_ves_info(
     p_policy_id   gipi_item_ves.policy_id%TYPE,
     p_item_no     gipi_item_ves.item_no%TYPE
  )
     RETURN item_ves_info_tab PIPELINED
  IS
     v_item_ves_info    item_ves_info_type;
     v_vestype_cd       giis_vessel.vestype_cd%TYPE;
     v_hull_type_cd     giis_vessel.hull_type_cd%TYPE;
     v_vess_class_cd    giis_vessel.vess_class_cd%TYPE;

  BEGIN
     FOR i IN (SELECT policy_id, item_no, vessel_cd, dry_date, deduct_text, rec_flag,
                      dry_place, geog_limit
                 FROM gipi_item_ves
                WHERE policy_id = p_policy_id
                  AND item_no = p_item_no)
     LOOP

        v_item_ves_info.policy_id       := i.policy_id;
        v_item_ves_info.item_no         := i.item_no;
        v_item_ves_info.dry_date        := i.dry_date;
        v_item_ves_info.rec_flag        := i.rec_flag;
        v_item_ves_info.dry_place       := i.dry_place;
        v_item_ves_info.vessel_cd       := i.vessel_cd;
        v_item_ves_info.geog_limit      := i.geog_limit;
        v_item_ves_info.deduct_text     := i.deduct_text;

        BEGIN

           SELECT item_title
             INTO v_item_ves_info.item_title
             FROM gipi_item
            WHERE policy_id = i.policy_id
              AND item_no = i.item_no;

        EXCEPTION
           WHEN NO_DATA_FOUND
           THEN
              v_item_ves_info.item_title    := '';
        END;

        BEGIN

            SELECT vessel_name, vessel_old_name,
                   vessel_length, vessel_breadth,
                   vessel_depth, reg_owner,
                   reg_place, year_built,
                   gross_ton, net_ton,
                   crew_nat, no_crew,
                   deadweight,
                   DECODE (propel_sw, 'S', 'Self-propelled', 'N', 'Non-propelled'),
                   vestype_cd, hull_type_cd, vess_class_cd
              INTO v_item_ves_info.vessel_name, v_item_ves_info.vessel_old_name,
                   v_item_ves_info.vessel_length, v_item_ves_info.vessel_breadth,
                   v_item_ves_info.vessel_depth, v_item_ves_info.reg_owner,
                   v_item_ves_info.reg_place, v_item_ves_info.year_built,
                   v_item_ves_info.gross_ton, v_item_ves_info.net_ton,
                   v_item_ves_info.crew_nat, v_item_ves_info.no_crew,
                   v_item_ves_info.deadweight,
                   v_item_ves_info.propel_sw_desc,
                   v_vestype_cd, v_hull_type_cd, v_vess_class_cd
              FROM giis_vessel
             WHERE vessel_cd = i.vessel_cd;

        EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            v_item_ves_info.vessel_name        := '';
            v_item_ves_info.vessel_old_name    := '';
            v_item_ves_info.vessel_length      := '';
            v_item_ves_info.vessel_breadth     := '';
            v_item_ves_info.vessel_depth       := '';
            v_item_ves_info.reg_owner          := '';
            v_item_ves_info.reg_place          := '';
            v_item_ves_info.year_built         := '';
            v_item_ves_info.gross_ton          := '';
            v_item_ves_info.net_ton            := '';
            v_item_ves_info.crew_nat           := '';
            v_item_ves_info.no_crew            := '';
            v_item_ves_info.deadweight         := '';
            v_item_ves_info.propel_sw_desc     := '';
            v_vestype_cd                       := '';
            v_hull_type_cd                     := '';
            v_vess_class_cd                    := '';

        END;

        BEGIN

            SELECT vestype_desc
              INTO v_item_ves_info.vestype_desc
              FROM giis_vestype
             WHERE vestype_cd = v_vestype_cd;

        EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            v_item_ves_info.vestype_desc := '';

        END;

        BEGIN

            SELECT hull_desc
              INTO v_item_ves_info.hull_desc
              FROM giis_hull_type
             WHERE hull_type_cd = v_hull_type_cd;

        EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            v_item_ves_info.hull_desc := '';

        END;


        BEGIN
            SELECT vess_class_desc
              INTO v_item_ves_info.vess_class_desc
              FROM giis_vess_class
             WHERE vess_class_cd = v_vess_class_cd;
        EXCEPTION
        WHEN NO_DATA_FOUND
        THEN

            v_item_ves_info.vess_class_desc := '';

        END;

        PIPE ROW (v_item_ves_info);
     END LOOP;
  END get_item_ves_info;

END GIPI_ITEM_VES_PKG;
/


