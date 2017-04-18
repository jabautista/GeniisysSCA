CREATE OR REPLACE PACKAGE BODY CPI.GISM_MESSAGES_SENT_PKG
AS

   FUNCTION get_gism_messages_sent(
      p_user_id                  GISM_MESSAGES_SENT.user_id%TYPE,
      p_status                   VARCHAR2,
      p_message_id               GISM_MESSAGES_SENT.msg_id%TYPE,
      p_priority_desc            VARCHAR2,
      p_sched_date               VARCHAR2,
      p_set_date                 VARCHAR2,
      p_message                  GISM_MESSAGES_SENT.message%TYPE,
      p_remarks                  GISM_MESSAGES_SENT.remarks%TYPE
   )
     RETURN gism_messages_sent_tab PIPELINED
   IS
      v_row                      gism_messages_sent_type;
      v_restrict_sms_user        GIIS_PARAMETERS.param_value_v%TYPE;
   BEGIN
      v_restrict_sms_user := GIISP.v('RESTRICT_SMS_USER');
   
      FOR i IN(SELECT a.*,
                      DECODE(a.priority, 3, 'LOW', DECODE(a.priority, 2, 'MEDIUM', 'HIGH')) priority_desc,
                      DECODE(a.message_status, 'C', 'CANCELLED',
                                               'E', 'WITH ERROR',
                                               'A', 'WITH ERROR',
                                               'Q', 'ON QUEUE',
                                               'S', 'SUCCESSFULLY SENT',
                                               'W', 'SENT WITH ERROR') status_desc
                 FROM GISM_MESSAGES_SENT a
                WHERE a.user_id = DECODE(v_restrict_sms_user, 'N', p_user_id, a.user_id)
                  AND a.message_status = DECODE(NVL(p_status, '1'), '1', a.message_status,
                                                                    '2', 'Q',
                                                                    '3', 'C',
                                                                    '5', 'S',
                                                                    '6', 'W',
                                                                    a.message_status)
                  AND (a.message_status = DECODE(NVL(p_status, '1'), '4', 'E', a.message_status)
                   OR a.message_status = DECODE(NVL(p_status, '1'), '4', 'A', a.message_status))
                  AND a.msg_id = NVL(p_message_id, a.msg_id)
                  AND DECODE(a.priority, 3, 'LOW', DECODE(a.priority, 2, 'MEDIUM', 'HIGH'))
                      LIKE NVL(UPPER(p_priority_desc), DECODE(a.priority, 3, 'LOW', DECODE(a.priority, 2, 'MEDIUM', 'HIGH')))
                  AND UPPER(NVL(a.message, '*')) LIKE UPPER(NVL(p_message, NVL(a.message, '*')))
                  AND UPPER(NVL(a.remarks, '*')) LIKE UPPER(NVL(p_remarks, NVL(a.remarks, '*')))
                ORDER BY set_date DESC)
      LOOP
         v_row.msg_id := i.msg_id;
         v_row.message := i.message;
         v_row.date_sent := i.date_sent;
         v_row.message_status := i.message_status;
         v_row.priority := i.priority;
         v_row.set_date := i.set_date;
         v_row.remarks := i.remarks;
         v_row.sched_date := i.sched_date;
         v_row.last_update := i.last_update;
         v_row.user_id := i.user_id;
         v_row.bday_sw := i.bday_sw;
         v_row.priority_desc := i.priority_desc;
         v_row.status_desc := i.status_desc;
         
         v_row.dsp_sched_date := TO_CHAR(i.sched_date, 'mm-dd-yyyy  HH:MI:SS AM');
         v_row.dsp_set_date := TO_CHAR(i.set_date, 'mm-dd-yyyy  HH:MI:SS AM');
         v_row.dsp_last_update := TO_CHAR(i.last_update, 'mm-dd-yyyy');
         
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_message_details(
      p_message_id               GISM_MESSAGES_SENT.msg_id%TYPE,
      p_recipient_name           GISM_MESSAGES_SENT_DTL.recipient_name%TYPE,
      p_cellphone_no             GISM_MESSAGES_SENT_DTL.cellphone_no%TYPE
   )
     RETURN gism_messages_sent_dtl_tab PIPELINED
   IS
      v_row                      gism_messages_sent_dtl_type;
   BEGIN
      FOR i IN(SELECT *
                 FROM GISM_MESSAGES_SENT_DTL
                WHERE msg_id = p_message_id
                  AND UPPER(NVL(recipient_name, '*')) LIKE UPPER(NVL(p_recipient_name, NVL(recipient_name, '*'))) 
                  AND NVL(cellphone_no, '*') LIKE NVL(p_cellphone_no, NVL(cellphone_no, '*')))
      LOOP
         v_row.recipient_name := i.recipient_name;
         v_row.cellphone_no := i.cellphone_no;
         
         FOR a IN(SELECT group_name 
                    FROM GISM_RECIPIENT_GROUP
                   WHERE group_cd = i.group_cd)
         LOOP
            v_row.user_group := a.group_name;
         END LOOP;
         
         IF i.status_sw = 'S' THEN
            v_row.status_desc := 'YES';
         ELSE
            v_row.status_desc := 'NO';
         END IF;
      
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   PROCEDURE resend_message(
      p_message_id               GISM_MESSAGES_SENT.msg_id%TYPE,
      p_user_id                  GISM_MESSAGES_SENT.user_id%TYPE
   )
   IS
   BEGIN
      UPDATE GISM_MESSAGES_SENT
         SET message_status = 'Q',
             user_id = p_user_id,
             last_update = SYSDATE
       WHERE msg_id = p_message_id;
   
      UPDATE GISM_MESSAGES_SENT_DTL
         SET status_sw = 'Q',
             last_update = SYSDATE
       WHERE msg_id = p_message_id;
   END;
   
   FUNCTION get_created_messages(
      p_user_id                  GISM_MESSAGES_SENT.user_id%TYPE,
      p_message                  GISM_MESSAGES_SENT.message%TYPE,
      p_sched_date               VARCHAR2,
      p_priority_desc            VARCHAR2
   )
     RETURN created_messages_tab PIPELINED
   IS
      v_row                      created_messages_type;
      v_restrict_sms_user        GIIS_PARAMETERS.param_value_v%TYPE;
   BEGIN
      v_restrict_sms_user := GIISP.v('RESTRICT_SMS_USER');
      
      FOR i IN(SELECT a.*,
                      DECODE(priority, 3, 'LOW', DECODE(priority, 2, 'MEDIUM', 'HIGH')) priority_desc
                 FROM GISM_MESSAGES_SENT a
                WHERE message_status = 'Q'
                  AND user_id = DECODE(v_restrict_sms_user, 'N', p_user_id, user_id)
                  AND UPPER(NVL(message, '***')) LIKE UPPER(NVL(p_message, NVL(message, '***')))
                  AND UPPER(DECODE(priority, 3, 'LOW', DECODE(priority, 2, 'MEDIUM', 'HIGH')))
                      LIKE UPPER(NVL(p_priority_desc, DECODE(priority, 3, 'LOW', DECODE(priority, 2, 'MEDIUM', 'HIGH'))))
                  AND TO_CHAR(sched_date, 'mm-dd-yyyy') = NVL(p_sched_date, TO_CHAR(sched_date, 'mm-dd-yyyy'))
                ORDER BY last_update DESC)
      LOOP
         v_row.msg_id := i.msg_id;
         v_row.dsp_set_time := TO_CHAR(i.sched_date, 'hh:mi:ss AM');
         v_row.dsp_set_date := TO_CHAR(i.sched_date, 'mm-dd-rrrr');
         v_row.message := i.message;
         v_row.sched_date := TO_CHAR(i.sched_date, 'mm-dd-rrrr hh:mi:ss AM');
         v_row.priority := i.priority;
         v_row.priority_desc := i.priority_desc;
         v_row.remarks := i.remarks;
         v_row.last_update := TO_CHAR(i.last_update, 'mm-dd-rrrr hh:mi:ss AM');
         v_row.user_id := i.user_id;
         v_row.bday_sw := i.bday_sw;
         
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_created_messages_dtl(
      p_message_id               GISM_MESSAGES_SENT.msg_id%TYPE,
      p_recipient_name           GISM_MESSAGES_SENT_DTL.recipient_name%TYPE,
      p_cellphone_no             GISM_MESSAGES_SENT_DTL.cellphone_no%TYPE
   )
     RETURN created_messages_dtl_tab PIPELINED
   IS
      v_row                      created_messages_dtl_type;
   BEGIN
      FOR i IN(SELECT *
                 FROM GISM_MESSAGES_SENT_DTL
                WHERE msg_id = p_message_id
                  AND UPPER(NVL(recipient_name, '***')) LIKE UPPER(NVL(p_recipient_name, NVL(recipient_name, '***')))
                  AND NVL(cellphone_no, '***') LIKE NVL(p_cellphone_no, NVL(cellphone_no, '***')))
      LOOP
         v_row.msg_id := i.msg_id;
         v_row.dtl_id := i.dtl_id;
         v_row.status_sw := i.status_sw;
         v_row.group_cd := i.group_cd;
         v_row.recipient_name := i.recipient_name;
         v_row.cellphone_no := i.cellphone_no;
         v_row.pk_column_value := i.pk_column_value;
         
         FOR a IN(SELECT group_name
                    FROM GISM_RECIPIENT_GROUP
                   WHERE group_cd = i.group_cd)
         LOOP
            v_row.group_name := a.group_name;
         END LOOP;
         
         PIPE ROW(v_row);
      END LOOP;
   END;
     
   PROCEDURE cancel_message(
      p_message_id               GISM_MESSAGES_SENT.msg_id%TYPE,
      p_user_id                  GISM_MESSAGES_SENT.user_id%TYPE
   )
   IS
   BEGIN
      UPDATE GISM_MESSAGES_SENT
         SET message_status = 'C',
             user_id = p_user_id,
             last_update = SYSDATE
       WHERE msg_id = p_message_id;
       
      UPDATE GISM_MESSAGES_SENT_DTL
         SET status_sw = 'C',
             last_update = SYSDATE
       WHERE msg_id = p_message_id;
   END;
   
   PROCEDURE set_message(
      p_message_id               GISM_MESSAGES_SENT.msg_id%TYPE,
      p_message                  GISM_MESSAGES_SENT.message%TYPE,
      p_priority                 GISM_MESSAGES_SENT.priority%TYPE,
      p_remarks                  GISM_MESSAGES_SENT.remarks%TYPE,
      p_sched_date               VARCHAR2,
      p_bday_sw                  GISM_MESSAGES_SENT.bday_sw%TYPE
   )
   IS
   BEGIN
      MERGE INTO GISM_MESSAGES_SENT
      USING dual ON (msg_id = p_message_id)
       WHEN NOT MATCHED THEN
            INSERT (msg_id, message, priority, remarks, sched_date, bday_sw)
            VALUES (p_message_id, p_message, p_priority, p_remarks, TO_DATE(p_sched_date, 'mm-dd-rrrr hh:mi:ss AM'), p_bday_sw)
       WHEN MATCHED THEN
            UPDATE SET 
                   message = p_message,
                   priority = p_priority,
                   remarks = p_remarks,
                   sched_date = TO_DATE(p_sched_date, 'mm-dd-rrrr hh:mi:ss AM'),
                   bday_sw = p_bday_sw;
   END;
   
   PROCEDURE delete_message(
      p_message_id               GISM_MESSAGES_SENT.msg_id%TYPE
   )
   IS
   BEGIN
      DELETE GISM_MESSAGES_SENT_DTL
       WHERE msg_id = p_message_id;
   
      DELETE GISM_MESSAGES_SENT
       WHERE msg_id = p_message_id;
   END;
   
   PROCEDURE set_detail(
      p_message_id               GISM_MESSAGES_SENT.msg_id%TYPE,
      p_detail_id                GISM_MESSAGES_SENT_DTL.dtl_id%TYPE,
      p_group_cd                 GISM_MESSAGES_SENT_DTL.group_cd%TYPE,
      p_pk_column_value          GISM_MESSAGES_SENT_DTL.pk_column_value%TYPE,
      p_recipient_name           GISM_MESSAGES_SENT_DTL.recipient_name%TYPE,
      p_cellphone_no             GISM_MESSAGES_SENT_DTL.cellphone_no%TYPE,
      p_status_sw                GISM_MESSAGES_SENT_DTL.status_sw%TYPE
   )
   IS
   BEGIN
      MERGE INTO GISM_MESSAGES_SENT_DTL
      USING dual ON (msg_id = p_message_id AND 
                     dtl_id = NVL(p_detail_id, 0))
       WHEN NOT MATCHED THEN
            INSERT (msg_id, group_cd, pk_column_value, recipient_name, cellphone_no, status_sw, last_update)
            VALUES (p_message_id, p_group_cd, p_pk_column_value, p_recipient_name, p_cellphone_no, p_status_sw, SYSDATE)
       WHEN MATCHED THEN
            UPDATE SET 
                   group_cd = p_group_cd,
                   pk_column_value = p_pk_column_value,
                   recipient_name = p_recipient_name,
                   cellphone_no = p_cellphone_no,
                   status_sw = p_status_sw,
                   last_update = SYSDATE;
   END;
   
   PROCEDURE delete_detail(
      p_message_id               GISM_MESSAGES_SENT.msg_id%TYPE,
      p_detail_id                GISM_MESSAGES_SENT_DTL.dtl_id%TYPE
   )
   IS
   BEGIN
      DELETE GISM_MESSAGES_SENT_DTL
       WHERE msg_id = p_message_id
         AND dtl_id = p_detail_id;
   END;
   
   FUNCTION validate_mobile_number(
      p_mobile_no                GISM_MESSAGES_SENT_DTL.cellphone_no%TYPE,
      p_provider                 VARCHAR2
   )
     RETURN NUMBER
   IS
      v_result                   NUMBER := 0;
      v_length                   NUMBER;
      v_prefix                   VARCHAR2(50);
      v_message                  VARCHAR2(300);
   BEGIN
      v_length := validate_mobile_prefix(p_mobile_no);
      v_prefix := (SUBSTR(p_mobile_no,NVL(INSTR(SUBSTR(p_mobile_no,1,LENGTH(p_mobile_no)-7),'9'),0),3));
      
      IF LENGTH(p_mobile_no) <> v_length THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#Invalid mobile number.');
      END IF;
      
      FOR i IN (SELECT INSTR(param_value_v,v_prefix)
                  FROM GIIS_PARAMETERS
                 WHERE param_name LIKE p_provider
                   AND INSTR(param_value_v,v_prefix) <> 0)
      LOOP
         v_result := 1;
         EXIT;
      END LOOP;
      
      RETURN v_result;
   END;

END;
/


