CREATE OR REPLACE PACKAGE BODY CPI.gipir208_pkg
AS
/*
    **  Created by   :  Ildefonso Ellarina Jr
    **  Date Created : 06.16.2014
    **  Reference By : GIPIR208 -  NOTES REGISTER
    */
   FUNCTION get_details (
      p_date_opt     VARCHAR2,
      p_as_of_date   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_note_type    VARCHAR2,
      p_alarm_flag   VARCHAR2,
      p_par_id       VARCHAR2
   )
      RETURN get_details_tab PIPELINED
   IS
      v_list    get_details_type;
      v_count   NUMBER           := 0;
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_list.cf_company
           FROM giis_parameters
          WHERE param_name = 'COMPANY_NAME';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.cf_company := NULL;
      END;

      BEGIN
         SELECT param_value_v
           INTO v_list.cf_com_address
           FROM giac_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.cf_com_address := NULL;
      END;

      BEGIN
         IF p_as_of_date IS NOT NULL
         THEN
            v_list.cf_date :=
                  'As of '
               || TO_CHAR (TO_DATE (p_as_of_date, 'MM-DD-YYYY'),
                           'fmMonth DD, RRRR'
                          );
         END IF;

         IF p_from_date IS NOT NULL
         THEN
            v_list.cf_date :=
                  'From '
               || TO_CHAR (TO_DATE (p_from_date, 'MM-DD-YYYY'),
                           'fmMonth DD, RRRR'
                          )
               || ' to '
               || TO_CHAR (TO_DATE (p_to_date, 'MM-DD-YYYY'),
                           'fmMonth DD, RRRR'
                          );
         END IF;
      END;

      FOR i IN (SELECT   a.par_id, a.note_type, a.note_subject, a.note_text,
                         a.alarm_flag, a.alarm_date, a.alarm_user,
                         a.policy_id, a.claim_id,
                         DECODE (a.claim_id, NULL, ' ', '*') claim_flag,
                         DECODE (a.renew_flag, 'Y', '*', ' ') renew_flag,
                         REPLACE (   b.line_cd
                                  || ' - '
                                  || b.iss_cd
                                  || ' -'
                                  || TO_CHAR (b.par_yy, '00')
                                  || ' -'
                                  || TO_CHAR (b.par_seq_no, '000000')
                                  || ' -'
                                  || TO_CHAR (b.quote_seq_no, '00'),
                                  ' ',
                                  NULL
                                 ) par_no,
                         REPLACE (   c.line_cd
                                  || '-'
                                  || c.subline_cd
                                  || '-'
                                  || c.iss_cd
                                  || '-'
                                  || TO_CHAR (c.issue_yy, '00')
                                  || '-'
                                  || TO_CHAR (c.pol_seq_no, '000000')
                                  || '-'
                                  || TO_CHAR (c.renew_no, '00'),
                                  ' ',
                                  NULL
                                 ) policy_no,
                         REPLACE (   d.line_cd
                                  || '-'
                                  || d.subline_cd
                                  || '-'
                                  || d.iss_cd
                                  || '-'
                                  || TO_CHAR (d.clm_yy, '00')
                                  || '-'
                                  || TO_CHAR (d.clm_seq_no, '000000'),
                                  ' ',
                                  NULL
                                 ) claim_no
                    FROM gipi_reminder a,
                         gipi_parlist b,
                         gipi_polbasic c,
                         gicl_claims d
                   WHERE c.policy_id(+) = a.policy_id
                     AND b.par_id(+) = a.par_id
                     AND d.claim_id(+) = a.claim_id
                     AND (   (    DECODE (p_date_opt,
                                          'dateCreated', TRUNC (a.date_created),
                                          'dateAcknowledged', TRUNC
                                                                   (a.ack_date),
                                          'alarmDate', TRUNC (a.alarm_date)
                                         ) >=
                                           TO_DATE (p_from_date, 'MM-DD-YYYY')
                              AND (DECODE (p_date_opt,
                                           'dateCreated', TRUNC
                                                               (a.date_created),
                                           'dateAcknowledged', TRUNC
                                                                   (a.ack_date),
                                           'alarmDate', TRUNC (a.alarm_date)
                                          ) <=
                                             TO_DATE (p_to_date, 'MM-DD-YYYY')
                                  )
                             )
                          OR (DECODE (p_date_opt,
                                      'dateCreated', TRUNC (a.date_created),
                                      'dateAcknowledged', TRUNC (a.ack_date),
                                      'alarmDate', TRUNC (a.alarm_date)
                                     ) <= TO_DATE (p_as_of_date, 'MM-DD-YYYY')
                             )
                         )
                     AND a.note_type LIKE NVL (p_note_type, '%')
                     AND a.alarm_flag LIKE NVL (p_alarm_flag, '%')
                     AND a.par_id = NVL (p_par_id, a.par_id)
                ORDER BY a.last_update DESC)
      LOOP
         v_count := 1;
         v_list.par_id := i.par_id;
         v_list.note_type := i.note_type;
         v_list.note_subject := i.note_subject;
         v_list.note_text := i.note_text;
         v_list.alarm_flag := i.alarm_flag;
         v_list.alarm_date := i.alarm_date;
         v_list.alarm_user := i.alarm_user;
         v_list.policy_id := i.policy_id;
         v_list.claim_id := i.claim_id;
         v_list.claim_flag := i.claim_flag;
         v_list.renew_flag := i.renew_flag;
         v_list.par_no := i.par_no;
         v_list.policy_no := i.policy_no;
         v_list.claim_no := i.claim_no;
         PIPE ROW (v_list);
      END LOOP;

      IF v_count = 0
      THEN
         PIPE ROW (v_list);
      END IF;

      RETURN;
   END get_details;
END gipir208_pkg;
/


