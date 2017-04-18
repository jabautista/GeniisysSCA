CREATE OR REPLACE PACKAGE BODY CPI.GISM_MESSAGES_RECEIVED_PKG
AS

   FUNCTION get_messages_received(
      p_sender                GISM_MESSAGES_RECEIVED.sender%TYPE,
      p_cellphone_no          GISM_MESSAGES_RECEIVED.cellphone_no%TYPE,
      p_date_received         VARCHAR2,
      p_message               GISM_MESSAGES_RECEIVED.message%TYPE
   )
     RETURN gism_messages_received_tab PIPELINED
   IS
      v_row                   gism_messages_received_type;
   BEGIN
      FOR i IN(SELECT *
                 FROM GISM_MESSAGES_RECEIVED
                WHERE UPPER(NVL(sender, '***')) LIKE UPPER(NVL(p_sender, NVL(sender, '***')))
                  AND UPPER(NVL(cellphone_no, '***')) LIKE UPPER(NVL(p_cellphone_no, NVL(cellphone_no, '***')))
                  AND UPPER(NVL(message, '***')) LIKE UPPER(NVL(p_message, NVL(message, '***')))
                  AND NVL(TO_CHAR(date_received, 'mm-dd-yyyy'), '***') LIKE NVL(p_date_received, TO_CHAR(date_received, 'mm-dd-yyyy'))
                ORDER BY date_received DESC)
      LOOP
        v_row.sender := i.sender;
        v_row.cellphone_no := i.cellphone_no;
        v_row.date_received := i.date_received;
        v_row.message := i.message;
        v_row.error_sw := i.error_sw;
        v_row.last_update := i.last_update;
        v_row.user_id := i.user_id;
        v_row.error_msg_id := i.error_msg_id;
        v_row.dsp_date_received := TO_CHAR(i.date_received, 'mm-dd-yyyy HH:MI:SS AM');
        v_row.dsp_last_update := TO_CHAR(i.last_update, 'mm-dd-yyyy');
      
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_message_detail(
      p_message_id            GISM_MESSAGES_RECEIVED.error_msg_id%TYPE
   )
     RETURN message_detail_tab PIPELINED
   IS
      v_row                   message_detail_type;
   BEGIN
      FOR i IN(SELECT msg_id, message, message_status, set_date
                 FROM GISM_MESSAGES_SENT
                WHERE msg_id = p_message_id)
      LOOP
         v_row.msg_id := i.msg_id;
         v_row.message := i.message;
         v_row.message_status := i.message_status;
         v_row.dsp_set_date := TO_CHAR(i.set_date, 'mm-dd-yyyy HH:MI:SS AM');
         
         IF i.message_status = 'C' THEN
            v_row.dsp_message_status := 'CANCELLED';
         ELSIF i.message_status = 'E' THEN
            v_row.dsp_message_status := 'WITH ERROR';
         ELSIF i.message_status = 'Q' THEN
            v_row.dsp_message_status := 'ON QUEUE';
         ELSIF i.message_status = 'S' THEN
            v_row.dsp_message_status := 'SUCCESSFULLY SENT';
         ELSIF i.message_status = 'W' THEN
            v_row.dsp_message_status := 'SENT WITH ERROR';	
         END IF;
      
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   PROCEDURE reply_to_message(
      p_message               VARCHAR2,
      p_sender                GISM_MESSAGES_RECEIVED.sender%TYPE,
      p_cellphone_no          GISM_MESSAGES_RECEIVED.cellphone_no%TYPE,
      p_date_received         VARCHAR2
   )
   IS
      v_msg_id                GISM_MESSAGES_SENT.msg_id%TYPE;
   BEGIN
      FOR a IN (SELECT gism_messages_sent_msg_id_s.NEXTVAL seq
  	  	  	 			FROM dual)
	   LOOP
         v_msg_id := a.seq;
	   END LOOP;
	   
      UPDATE GISM_MESSAGES_RECEIVED
         SET error_msg_id = v_msg_id
       WHERE UPPER(NVL(sender, '***')) = UPPER(NVL(p_sender, '***'))
         AND cellphone_no = p_cellphone_no
         AND TO_CHAR(date_received, 'mm-dd-yyyy HH:MI:SS AM') = p_date_received;
      
	   INSERT INTO GISM_MESSAGES_SENT(msg_id, message, date_sent)
      VALUES (v_msg_id, p_message, SYSDATE);
	   
	   INSERT INTO GISM_MESSAGES_SENT_DTL(msg_id, recipient_name, cellphone_no, status_sw, last_update)
      VALUES (v_msg_id, p_sender, p_cellphone_no, 'Q', SYSDATE);		
   END;
   
   FUNCTION get_sms_error_log
      RETURN sms_error_log_tab PIPELINED
   IS
      v_list sms_error_log_type;
   BEGIN
      FOR i IN (SELECT date_received, cellphone_no, keyword, message
                  FROM gism_messages_received
                 WHERE NVL(ERROR_SW,'N') = 'Y'
                   AND UPPER(KEYWORD) LIKE 'REG')
      LOOP
         v_list.date_received := i.date_received;
         v_list.cellphone_no := i.cellphone_no;
         v_list.keyword := i.keyword;
         v_list.message := i.message;
         
         GISM_MESSAGES_RECEIVED_PKG.get_gisms008_name(i.message, v_list.name, v_list.class_cd);
         
         PIPE ROW(v_list);
      END LOOP;
   END get_sms_error_log;
   
   PROCEDURE get_gisms008_name (
      p_message   IN VARCHAR2,
      p_name      OUT VARCHAR2,
      p_class_cd  OUT VARCHAR2
   )
   IS
      v_int_ass VARCHAR2(1); --if assured or intermediary
      v_name VARCHAR2(100); --whole name, original format
      v_n1 VARCHAR2(50); --surname
      v_n2 VARCHAR2(50); --firstname
      v_n3 VARCHAR2(2); --middle initial
      ctr NUMBER;
      ctr2 VARCHAR2(3);
   BEGIN
      v_int_ass := UPPER(SUBSTR(p_message,INSTR(p_message,' ',1,1)+1,1)); --either I or A
      v_name := UPPER(SUBSTR(p_message,INSTR(p_message,' ',1,2)+1)); --name. (e.g delacruz*juan*d)
      
      ctr := 0;
      --***ctr := (num. of * + 1)***--
      LOOP
         ctr := ctr+1;
         ctr2 := instr(p_message,'*',1,ctr);
--         raise_application_error(-20001, ctr2);
         EXIT WHEN ctr2 = 0;
      END LOOP;
      
      IF v_int_ass = 'I' THEN
         p_class_cd := v_int_ass;
         IF ctr = 2 THEN
            v_n1 := UPPER(SUBSTR(v_name,1,INSTR(v_name,'*',1,1)-1)); -- start ->  b4 1st *
            v_n2 := UPPER(SUBSTR(v_name,INSTR(v_name,'*',1,1)+1));   -- after * upto the end 
            v_n3 := null; 
            --***display***--
            SELECT REPLACE(REPLACE(REPLACE(param_value_v,'<LN>',v_n1),'<FN>,',v_n2),'<MI>',v_n3)
            INTO p_name     
            FROM giac_parameters
            WHERE param_name LIKE 'INTM_NAME_FORMAT';
            --  	 	  p_name := v_n2||' '||v_n1; --***display***--
              	 	  
         ELSIF ctr = 3 THEN
            v_n1 := UPPER(SUBSTR(v_name,1,INSTR(v_name,'*',1,1)-1)); -- start -> b4 1st * (surname)
            v_name := UPPER(SUBSTR(v_name,INSTR(v_name,'*',1,1)+1)); -- get the remaining strings
            v_n2 := UPPER(SUBSTR(v_name,1,INSTR(v_name,'*',1,1)-1)); -- start -> b4 2nd * (firstname)
            v_name := UPPER(SUBSTR(v_name,INSTR(v_name,'*',1,1)+1)); -- get the remaining strings 
            v_n3 := v_name; -- remaining string (middle initial)
            --***display***--
            SELECT REPLACE(REPLACE(REPLACE(param_value_v,'<LN>',v_n1),'<FN>',v_n2),'<MI>',v_n3||'.')
            INTO p_name     
            FROM giac_parameters
            WHERE param_name LIKE 'INTM_NAME_FORMAT';
            --p_name := v_n2||' '||v_n3||'. '||v_n1; --***display***--
              	 	  
         ELSIF ctr = 1 THEN
            p_name := v_name;
         END IF;
      ELSIF v_int_ass = 'A' THEN
--         raise_application_error(-20001, ctr);
         p_class_cd := v_int_ass;
         IF ctr = 2 THEN
            v_n1 := UPPER(SUBSTR(v_name,1,INSTR(v_name,'*',1,1)-1)); -- start ->  b4 1st *
            v_n2 := UPPER(SUBSTR(v_name,INSTR(v_name,'*',1,1)+1));   -- after * upto the end
            v_n3 := null;
            --***display***--
            SELECT REPLACE(REPLACE(REPLACE(param_value_v,'<LN>',v_n1),'<FN>,',v_n2),'<MI>',v_n3)
            INTO p_name       
            FROM giac_parameters
            WHERE param_name LIKE 'ASSD_NAME_FORMAT'; 	
            -- p_name := v_n1||' '||v_n2; --***display***--
              	 	  
         ELSIF ctr = 3 THEN
            v_n1 := UPPER(SUBSTR(v_name,1,INSTR(v_name,'*',1,1)-1)); -- start -> b4 1st * --surname
            v_name := UPPER(SUBSTR(v_name,INSTR(v_name,'*',1,1)+1)); -- get the remaining strings
            v_n2 := UPPER(SUBSTR(v_name,1,INSTR(v_name,'*',1,1)-1)); -- start -> b4 2nd * --firstname
            v_name := UPPER(SUBSTR(v_name,INSTR(v_name,'*',1,1)+1)); -- get the remaining strings
            v_n3 := v_name; -- remaining string --middle initial
            --***display***--
            SELECT REPLACE(REPLACE(REPLACE(param_value_v,'<LN>',v_n1),'<FN>',v_n2),'<MI>',v_n3||'.')
            INTO p_name       
            FROM giac_parameters
            WHERE param_name LIKE 'ASSD_NAME_FORMAT'; 	
            --p_name := v_n1 ||' '||v_n2||' '||v_n3||'.'; --***display***--
              	    
         ELSIF ctr = 1 THEN
            p_name := v_name;
         END IF;	
      ELSE
         p_name := v_name;
      END IF;
      
   END get_gisms008_name;
   
   
   PROCEDURE get_cell_type (
      cel_no   IN VARCHAR2,
      cel_type IN VARCHAR2,
      v_flag   IN OUT boolean
   )
   IS
      v_prefix       VARCHAR2(50) := SUBSTR(cel_no,INSTR(cel_no,'9',1,1),3); 
      v_valid_prefix VARCHAR2(50);
      v_length       NUMBER := validate_mobile_prefix(cel_no);
   BEGIN
      IF LENGTH(cel_no) < NVL(v_length,length(cel_no)+1) THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Invalid mobile number.');
	   ELSE
		   SELECT param_value_v 
  	        INTO v_valid_prefix
	        FROM GIIS_PARAMETERS
	       WHERE param_name LIKE cel_type;
  
         LOOP
            IF NOT (v_prefix = substr(v_valid_prefix,1,3)) THEN
               v_flag := FALSE;
            ELSIF v_prefix = substr(v_valid_prefix,1,3) THEN
               v_flag := TRUE;
            END IF;

            v_valid_prefix:= substr(v_valid_prefix,5,LENGTH(v_valid_prefix));
            EXIT WHEN v_valid_prefix IS NULL or v_flag = TRUE;
            
         END LOOP; 
	   END IF;
   END get_cell_type;
   
   PROCEDURE gisms008_assign(
      p_no           VARCHAR2,
      p_cellphone_no VARCHAR2,
      p_keyword      VARCHAR2,
      p_message      VARCHAR2,
      p_class_cd     VARCHAR2
   )
   IS
      v_length       NUMBER := validate_mobile_prefix(p_cellphone_no);
      v_stat         BOOLEAN := FALSE;
      v_cell_type    VARCHAR2(50);
      v_cell_type2   VARCHAR2(50);
      v_cell_no      giis_assured.cp_no%TYPE;
   BEGIN
      IF LENGTH(p_cellphone_no) < NVL(v_length, LENGTH(p_cellphone_no) + 1) OR
         LENGTH(p_cellphone_no) > NVL(v_length, LENGTH(p_cellphone_no) + 1) THEN
  	         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Invalid Cellphone Number.');
      ELSE
         GISM_MESSAGES_RECEIVED_PKG.get_cell_type(p_cellphone_no, 'SMART_NUMBER', v_stat);
         IF v_stat = FALSE THEN
            GISM_MESSAGES_RECEIVED_PKG.get_cell_type(p_cellphone_no,'SUN_NUMBER',v_stat);
            IF v_stat = FALSE THEN
               GISM_MESSAGES_RECEIVED_PKG.get_cell_type(p_cellphone_no,'GLOBE_NUMBER',v_stat);
               IF v_stat = FALSE THEN
                  RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Invalid Cellphone Number.');
			 	   ELSIF v_stat = TRUE THEN
                  v_cell_type := 'GLOBE_NUMBER';
               END IF;
            ELSIF v_stat = TRUE THEN
			      v_cell_type := 'SUN_NUMBER';
			   END IF;
			ELSIF v_stat = TRUE THEN
			   v_cell_type := 'SMART_NUMBER';
			END IF;                 
      END IF;
      
      IF p_class_cd = 'A' THEN
         BEGIN
            SELECT cp_no
              INTO v_cell_no
              FROM giis_assured
             WHERE assd_no = p_no;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_cell_no := NULL;    
         END;
      ELSE
         BEGIN
            SELECT cp_no
              INTO v_cell_no
              FROM giis_intermediary
             WHERE intm_no = p_no;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_cell_no := NULL;    
         END;   
      END IF;
      
      GISM_MESSAGES_RECEIVED_PKG.get_cell_type(v_cell_no, 'SMART_NUMBER', v_stat);
      IF v_stat = FALSE THEN
         GISM_MESSAGES_RECEIVED_PKG.get_cell_type(v_cell_no,'SUN_NUMBER',v_stat);
         IF v_stat = FALSE THEN
            GISM_MESSAGES_RECEIVED_PKG.get_cell_type(v_cell_no,'GLOBE_NUMBER',v_stat);
            IF v_stat = FALSE THEN
               RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Invalid Cellphone Number.');
            ELSIF v_stat = TRUE THEN
               v_cell_type2 := 'GLOBE_NUMBER';
            END IF;
         ELSIF v_stat = TRUE THEN
            v_cell_type2 := 'SUN_NUMBER';
         END IF;
      ELSIF v_stat = TRUE THEN
         v_cell_type2 := 'SMART_NUMBER';
      END IF;
      
      IF v_cell_type = v_cell_type2 THEN
         IF p_class_cd = 'A' THEN
            UPDATE giis_assured
               SET cp_no = p_cellphone_no
             WHERE assd_no = p_no;
         ELSE
            UPDATE giis_intermediary
               SET cp_no = p_cellphone_no
             WHERE intm_no = p_no;
         END IF;
      END IF;
      
      UPDATE gism_messages_received
         SET error_sw = 'Y'
       WHERE UPPER(keyword) = UPPER(p_keyword)
         AND UPPER(message) = UPPER(p_message)
         AND cellphone_no = p_cellphone_no;
      
   END gisms008_assign;
   
   PROCEDURE gisms008_purge(
      p_cellphone_no VARCHAR2,
      p_keyword      VARCHAR2,
      p_message      VARCHAR2
   )
   IS
      v_length number := validate_mobile_prefix(p_cellphone_no);
   BEGIN
      IF LENGTH(p_cellphone_no) < NVL(v_length,length(p_cellphone_no)+1) OR
		   LENGTH(p_cellphone_no) > NVL(v_length,length(p_cellphone_no)+1) THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Invalid Cellphone Number.');
		ELSE         		 	  		
         UPDATE gism_messages_received
            SET ERROR_SW = 'Y'
          WHERE UPPER(keyword) = UPPER(p_keyword)
            AND UPPER(message) = UPPER(p_message)
            AND cellphone_no = p_cellphone_no;
      END IF;
   END gisms008_purge;

END;
/


