CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Aviation_Item_Pkg
AS

    /*
    **  Created by        : Andrew Robes
    **  Date Created     : 05.30.2011
    **  Reference By     : (GIPIS082- Item Information - Aviation - Endorsement)
    **  Description     : Returns record listing for AVIATION
    */
    FUNCTION get_gipi_aviation_item (
        p_policy_id     GIPI_AVIATION_ITEM.policy_id%TYPE,
        p_item_no       GIPI_AVIATION_ITEM.item_no%TYPE)
    RETURN gipi_aviation_tab PIPELINED  IS
        v_aviation    gipi_aviation_type;
    BEGIN
        FOR i IN (SELECT c.vessel_cd,            c.total_fly_time,        c.qualification,        c.purpose,
                         c.geog_limit,            c.deduct_text,            c.rec_flag rec_flag, c.fixed_wing,
                         c.rotor,                c.prev_util_hrs,        c.est_util_hrs,         c.policy_id,
                         c.item_no
                    FROM GIPI_AVIATION_ITEM c
                   WHERE c.policy_id = p_policy_id
                     AND c.item_no = p_item_no
                   ORDER BY c.item_no)
        LOOP
            v_aviation.vessel_cd         := i.vessel_cd;
            v_aviation.total_fly_time    := i.total_fly_time;
            v_aviation.qualification     := i.qualification;
            v_aviation.purpose           := i.purpose;
            v_aviation.geog_limit        := i.geog_limit;
            v_aviation.deduct_text       := i.deduct_text;
            v_aviation.rec_flag          := i.rec_flag;
            v_aviation.fixed_wing        := i.fixed_wing;
            v_aviation.rotor             := i.rotor;
            v_aviation.prev_util_hrs     := i.prev_util_hrs;
            v_aviation.est_util_hrs      := i.est_util_hrs;
            v_aviation.policy_id         := i.policy_id;
            v_aviation.item_no           := i.item_no;

                 BEGIN

              SELECT air_desc
                INTO v_aviation.air_desc
                FROM giis_air_type
               WHERE air_type_cd IN (SELECT air_type_cd
                                       FROM giis_vessel
                                      WHERE vessel_cd = i.vessel_cd);
            EXCEPTION
            WHEN NO_DATA_FOUND
            THEN

              v_aviation.air_desc := '';

            END;
        PIPE ROW (v_aviation);
        END LOOP;
        RETURN;
    END;

  /*
  **  Created by        : Moses Calma
  **  Date Created     : 06.21.2011
  **  Reference By     : (GIPIS100 - Policy Information)
  **  Description     :  Retrieves additional information of an aviation item
  */
  FUNCTION get_aviation_item_info(
     p_policy_id   gipi_aviation_item.policy_id%TYPE,
     p_item_no     gipi_aviation_item.item_no%TYPE
  )
     RETURN aviation_item_info_tab PIPELINED
  IS
     v_aviation_item_info    aviation_item_info_type;

  BEGIN
     FOR i IN (SELECT policy_id, item_no, vessel_cd, qualification, geog_limit,
                      prev_util_hrs, total_fly_time, purpose, deduct_text,est_util_hrs
                 FROM gipi_aviation_item
                WHERE policy_id = p_policy_id
                  AND item_no = p_item_no)
     LOOP

        v_aviation_item_info.policy_id          := i.policy_id;
        v_aviation_item_info.item_no            := i.item_no;
        v_aviation_item_info.vessel_cd          := i.vessel_cd;
        v_aviation_item_info.qualification      := i.qualification;
        v_aviation_item_info.geog_limit         := i.geog_limit;
        v_aviation_item_info.prev_util_hrs      := i.prev_util_hrs;
        v_aviation_item_info.total_fly_time     := i.total_fly_time;
        v_aviation_item_info.purpose            := i.purpose;
        v_aviation_item_info.deduct_text        := i.deduct_text;
        v_aviation_item_info.est_util_hrs       := i.est_util_hrs;

        BEGIN

           SELECT item_title
             INTO v_aviation_item_info.item_title
             FROM gipi_item
            WHERE policy_id = i.policy_id
              AND item_no = i.item_no;

        EXCEPTION
           WHEN NO_DATA_FOUND
           THEN
              v_aviation_item_info.item_title    := '';
        END;

        BEGIN

          SELECT vessel_name
            INTO v_aviation_item_info.vessel_name
            FROM giis_vessel
           WHERE vessel_cd = i.vessel_cd;

        EXCEPTION
        WHEN NO_DATA_FOUND
        THEN

          v_aviation_item_info.vessel_name := '';

        END;

        BEGIN

          SELECT air_desc
            INTO v_aviation_item_info.air_desc
            FROM giis_air_type
           WHERE air_type_cd IN (SELECT air_type_cd
                                   FROM giis_vessel
                                  WHERE vessel_cd = i.vessel_cd);
        EXCEPTION
        WHEN NO_DATA_FOUND
        THEN

          v_aviation_item_info.air_desc := '';

        END;

        BEGIN

          SELECT rpc_no
            INTO v_aviation_item_info.rpc_no
            FROM giis_vessel
           WHERE vessel_cd = i.vessel_cd;

        EXCEPTION
        WHEN NO_DATA_FOUND
        THEN

           v_aviation_item_info.rpc_no := '';

        END;

        PIPE ROW (v_aviation_item_info);
     END LOOP;
  END get_aviation_item_info;

END;
/


