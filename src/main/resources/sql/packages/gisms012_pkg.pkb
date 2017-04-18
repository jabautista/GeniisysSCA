CREATE OR REPLACE PACKAGE BODY CPI.GISMS012_PKG
AS
     PROCEDURE populate_sms_report(
        p_from_date    IN  VARCHAR2,
        p_to_date      IN  VARCHAR2,
        p_as_of_date   IN  VARCHAR2,
        p_user         IN  VARCHAR2,
        p_rec_globe    OUT NUMBER,
        p_rec_smart    OUT NUMBER,
        p_rec_sun      OUT NUMBER,
        p_sent_globe   OUT NUMBER,
        p_sent_smart   OUT NUMBER,
        p_sent_sun     OUT NUMBER,
        p_total_rec    OUT NUMBER,
        p_total_sent   OUT NUMBER
    )
    IS
    BEGIN
           BEGIN --GLOBE
              SELECT COUNT (*)
                INTO p_rec_globe
                FROM giis_parameters, gism_messages_received
               WHERE param_name LIKE 'GLOBE_NUMBER'
                 AND (date_received BETWEEN TO_DATE(p_from_date,'MM-DD-YYYY')-1 AND TO_DATE(p_to_date,'MM-DD-YYYY')+1
                        OR date_received <= TO_DATE(p_as_of_date,'MM-DD-YYYY')+1
                      )
                 AND (  INSTR (param_value_v,
                               SUBSTR (cellphone_no, (LENGTH (cellphone_no) - 9), 3),
                               1,
                               1
                              )
                      - 1
                     ) >= 0; --RCD
           EXCEPTION
              WHEN NO_DATA_FOUND
              THEN
                 p_rec_globe := 0;
           END;
           
           BEGIN -- SMART
              SELECT COUNT (*)
                INTO p_rec_smart
                FROM giis_parameters, gism_messages_received
               WHERE param_name LIKE 'SMART_NUMBER'
                 AND (date_received BETWEEN TO_DATE(p_from_date,'MM-DD-YYYY')-1 AND TO_DATE(p_to_date,'MM-DD-YYYY')+1
                        OR date_received <= TO_DATE(p_as_of_date,'MM-DD-YYYY')+1
                      )
                 AND (  INSTR (param_value_v,
                               SUBSTR (cellphone_no, (LENGTH (cellphone_no) - 9), 3),
                               1,
                               1
                              )
                      - 1
                     ) >= 0;--RCD
           EXCEPTION
              WHEN NO_DATA_FOUND
              THEN
                 p_rec_smart := 0;
           END;

           BEGIN --SUN
              SELECT COUNT (*)
                INTO p_rec_sun
                FROM giis_parameters, gism_messages_received
               WHERE param_name LIKE 'SUN_NUMBER'
                 AND (date_received BETWEEN TO_DATE(p_from_date,'MM-DD-YYYY')-1 AND TO_DATE(p_to_date,'MM-DD-YYYY')+1
                        OR date_received <= TO_DATE(p_as_of_date,'MM-DD-YYYY')+1
                      )
                 AND (  INSTR (param_value_v,
                               SUBSTR (cellphone_no, (LENGTH (cellphone_no) - 9), 3),
                               1,
                               1
                              )
                      - 1
                     ) >= 0;--RCD
           EXCEPTION
              WHEN NO_DATA_FOUND
              THEN
                 p_rec_sun := 0;
           END;
           
           --IF :GLOBAL.v_id_flag > 0 THEN
           BEGIN     --GLOBE
                 SELECT COUNT (msg_id)
                   INTO p_sent_globe
                   FROM gism_messages_sent
                  WHERE msg_id IN (
                           SELECT msg_id
                             FROM giis_parameters, gism_messages_sent_dtl
                            WHERE param_name LIKE 'GLOBE_NUMBER'
                              AND (  INSTR (param_value_v,
                                            SUBSTR (cellphone_no,
                                                    (LENGTH (cellphone_no) - 9
                                                    ),
                                                    3
                                                   ),
                                            1,
                                            1
                                           )
                                   - 1
                                  ) >= 0 --RCD
                              AND status_sw LIKE 'S')
                    AND user_id = NVL(p_user, user_id)
                    AND (date_sent BETWEEN TO_DATE(p_from_date,'MM-DD-YYYY')-1 AND TO_DATE(p_to_date,'MM-DD-YYYY')+1
                        OR date_sent <= TO_DATE(p_as_of_date,'MM-DD-YYYY')+1
                      );
           EXCEPTION
                 WHEN NO_DATA_FOUND
                 THEN
                    p_sent_globe := 0;
           END;

           BEGIN                                                           -- SMART
                 SELECT COUNT (msg_id)
                   INTO p_sent_smart
                   FROM gism_messages_sent
                  WHERE msg_id IN (
                           SELECT msg_id
                             FROM giis_parameters, gism_messages_sent_dtl
                            WHERE param_name LIKE 'SMART_NUMBER'
                              AND (  INSTR (param_value_v,
                                            SUBSTR (cellphone_no,
                                                    (LENGTH (cellphone_no) - 9
                                                    ),
                                                    3
                                                   ),
                                            1,
                                            1
                                           )
                                   - 1
                                  ) >= 0--RCD
                              AND status_sw LIKE 'S')
                    AND user_id = NVL(p_user, user_id)
                    AND (date_sent BETWEEN TO_DATE(p_from_date,'MM-DD-YYYY')-1 AND TO_DATE(p_to_date,'MM-DD-YYYY')+1
                        OR date_sent <= TO_DATE(p_as_of_date,'MM-DD-YYYY')+1
                      );
              EXCEPTION
                 WHEN NO_DATA_FOUND
                 THEN
                    p_sent_smart := 0;
           END;

           BEGIN                                                              --SUN
                 SELECT COUNT (msg_id)
                   INTO p_sent_sun 
                   FROM gism_messages_sent
                  WHERE msg_id IN (
                           SELECT msg_id
                             FROM giis_parameters, gism_messages_sent_dtl
                            WHERE param_name LIKE 'SUN_NUMBER'
                              AND (  INSTR (param_value_v,
                                            SUBSTR (cellphone_no,
                                                    (LENGTH (cellphone_no) - 9
                                                    ),
                                                    3
                                                   ),
                                            1,
                                            1
                                           )
                                   - 1
                                  ) >= 0 --RCD
                              AND status_sw LIKE 'S')
                    AND user_id = NVL(p_user, user_id)          
                    AND (date_sent BETWEEN TO_DATE(p_from_date,'MM-DD-YYYY')-1 AND TO_DATE(p_to_date,'MM-DD-YYYY')+1
                        OR date_sent <= TO_DATE(p_as_of_date,'MM-DD-YYYY')+1
                      );
           EXCEPTION
                 WHEN NO_DATA_FOUND
                 THEN
                    p_sent_sun := 0;
           END;
           
           p_total_rec := p_rec_globe + p_rec_smart + p_rec_sun;   
           p_total_sent := p_sent_globe + p_sent_smart + p_sent_sun;
    END;
    
    PROCEDURE validate_gisms012_user(
        p_user_id      IN OUT VARCHAR2,
        p_user_name    OUT    VARCHAR2
    )
    IS
    BEGIN
        SELECT user_id, user_name
          INTO p_user_id, p_user_name 
          FROM giis_users
         WHERE user_id LIKE NVL(p_user_id, user_id);
         
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_user_id := 'NO DATA';
        WHEN TOO_MANY_ROWS THEN
            p_user_id := 'MANY';
    END;
    
    FUNCTION get_user_list_lov(
        p_user_id   VARCHAR2
    )
            RETURN user_list_lov_tab PIPELINED
    IS
        v_list user_list_lov_type;
    BEGIN
        FOR i IN(  
                  SELECT user_id, user_name
                    FROM giis_users
                   WHERE user_id LIKE NVL(p_user_id,'%')
                ORDER BY user_id ASC
        )
        LOOP
            v_list.user_id    := i.user_id; 
            v_list.user_name  := i.user_name;
            
            PIPE ROW(v_list);
        END LOOP;
        
        RETURN;
     
    END get_user_list_lov;
END;
/


