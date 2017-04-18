DROP PROCEDURE CPI.VALIDATE_EXISTING_DIST;

CREATE OR REPLACE PROCEDURE CPI.validate_existing_dist(
    p_line_cd           GIPI_POLBASIC.line_cd%TYPE,  
    p_subline_cd        GIPI_POLBASIC.subline_cd%TYPE,
    p_pol_iss_cd        GIPI_POLBASIC.iss_cd%TYPE,
    p_issue_yy          GIPI_POLBASIC.issue_yy%TYPE,
    p_pol_seq_no        GIPI_POLBASIC.pol_seq_no%TYPE,
    p_renew_no          GIPI_POLBASIC.renew_no%TYPE,
    p_msg_alert     OUT VARCHAR2 
    ) IS
    v_dist_param  giis_parameters.param_value_v%type;
    v_hdr_sw          VARCHAR2(1);
    v_dtl_sw          VARCHAR2(1);
BEGIN
    
  IF p_renew_no IS NOT NULL THEN
    FOR rec IN
      (SELECT param_value_v
              FROM giis_parameters
        WHERE param_name = 'DISTRIBUTED')
    LOOP
      v_dist_param  := rec.param_value_v;
    EXIT; 
    END LOOP;
  END IF;
       
  FOR bert IN
      (SELECT b.dist_no dist_no, a.policy_id policy_id
          FROM    gipi_polbasic a, giuw_pol_dist b
        WHERE a.line_cd     = p_line_cd 
           AND a.subline_cd = p_subline_cd 
          AND a.iss_cd      = p_pol_iss_cd 
          AND a.issue_yy    = p_issue_yy 
          AND a.pol_seq_no  = p_pol_seq_no 
          AND a.renew_no    = p_renew_no
          AND a.policy_id   = b.policy_id 
          AND b.dist_flag   = v_dist_param
          AND b.negate_date IS NULL
          AND a.pol_flag    IN ('1','2','3', 'X')
          AND NOT EXISTS    (SELECT c.policy_id
                             FROM gipi_endttext c
                            WHERE c.endt_tax  = 'Y'
                              AND c.policy_id = a.policy_id)) -- added by Pia, 07.23.03
  LOOP    
      v_hdr_sw := 'N';
      FOR a IN
        (SELECT    c110.dist_no, c110.dist_seq_no
              FROM    giuw_policyds    c110
            WHERE    c110.dist_no = bert.dist_no)
      LOOP
          v_hdr_sw := 'Y';
          v_dtl_sw := 'N';
          FOR b IN
            (SELECT    '1'
                 FROM giuw_policyds_dtl c130
                WHERE    c130.dist_no = a.dist_no
                  AND    c130.dist_seq_no = a.dist_seq_no)
          LOOP
              v_dtl_sw := 'Y';
              EXIT;
          END LOOP;
          IF v_dtl_sw = 'N' THEN
               EXIT;
          END IF;
      END LOOP;
      IF v_hdr_sw = 'N' OR v_dtl_sw = 'N' THEN
         p_msg_alert := 'There was an error encountered in Distribution Number '||to_char(bert.dist_no)
           ||'. Records in some tables are missing.';--,'I',true);
         RETURN;  
      ELSE
           FOR item IN
             (SELECT b340.item_no
                  FROM gipi_item b340
                 WHERE b340.policy_id = bert.policy_id
                   AND EXISTS (SELECT '1'
                                       FROM    gipi_itmperil b380
                                      WHERE    b380.policy_id = b340.policy_id
                                         AND    b380.item_no   = b340.item_no))
           LOOP
               v_hdr_sw := 'N';
               FOR a IN
                 (SELECT c140.dist_no, c140.dist_seq_no
                       FROM giuw_itemds c140
                     WHERE c140.dist_no = bert.dist_no
                       AND c140.item_no = item.item_no)
               LOOP
                   v_hdr_sw := 'Y';
                   v_dtl_sw := 'N';
                   FOR b IN
                     (SELECT '1'
                          FROM giuw_itemds_dtl c050
                         WHERE c050.dist_no     = a.dist_no
                           AND c050.dist_seq_no = a.dist_seq_no
                           AND c050.item_no     = item.item_no)
                   LOOP
                       v_dtl_sw := 'Y';
                       EXIT;
                   END LOOP;
                   IF v_dtl_sw = 'N' THEN
                        EXIT;
                   END IF;
               END LOOP;
               IF v_hdr_sw = 'N' THEN
                     EXIT;
               END IF;
           END LOOP;
           IF v_hdr_sw = 'N' OR v_dtl_sw = 'N' THEN
                p_msg_alert := 'There was an error encountered in Distribution Number '||to_char(bert.dist_no)
                        ||'. Records in some tables are missing.';--,'I',true);
                RETURN;        
           ELSE
                FOR perl IN
                  (SELECT b380.item_no, b380.peril_cd
                        FROM gipi_itmperil b380
                      WHERE b380.policy_id = bert.policy_id)
                LOOP
                    v_hdr_sw := 'N';
                    FOR a IN
                      (SELECT c060.dist_no, c060.dist_seq_no, c060.item_no, c060.peril_cd
                           FROM giuw_itemperilds c060
                          WHERE c060.dist_no  = bert.dist_no
                            AND c060.item_no  = perl.item_no
                            AND c060.peril_cd = perl.peril_cd)
                    LOOP
                        v_hdr_sw := 'Y';
                        v_dtl_sw := 'N';
                        FOR b IN
                          (SELECT '1'
                               FROM giuw_itemperilds_dtl c070
                              WHERE c070.dist_no     = a.dist_no
                                AND c070.dist_seq_no = a.dist_seq_no
                                AND c070.item_no     = a.item_no
                                AND c070.peril_cd    = a.peril_cd)
                        LOOP
                            v_dtl_sw := 'Y';
                            EXIT;
                        END LOOP;
                        IF v_dtl_sw = 'N' THEN
                             EXIT;
                        END IF;
                    END LOOP;
                    IF v_hdr_sw = 'N' THEN
                          EXIT;
                    END IF;
                END LOOP;
                
                IF v_hdr_sw = 'N' OR v_dtl_sw = 'N' THEN
                    p_msg_alert := 'There was an error encountered in Distribution Number '||to_char(bert.dist_no)
                           ||'. Records in some tables are missing.';--,'I',true);
                    RETURN;       
                ELSE
                     FOR perl IN
                       (SELECT    DISTINCT c060.peril_cd peril_cd, c060.dist_seq_no
                            FROM    giuw_itemperilds c060
                           WHERE c060.dist_no = bert.dist_no) 
                     LOOP
                         v_hdr_sw := 'N';
                         FOR a IN
                           (SELECT c090.dist_no, c090.dist_seq_no, c090.peril_cd
                                FROM giuw_perilds c090
                               WHERE c090.dist_no     = bert.dist_no
                                 AND c090.dist_seq_no = perl.dist_seq_no
                                 AND c090.peril_cd    = perl.peril_cd)
                         LOOP
                             v_hdr_sw := 'Y';
                             v_dtl_sw := 'N';
                             FOR b IN
                               (SELECT '1'
                                    FROM giuw_perilds_dtl c100
                                   WHERE c100.dist_no     = a.dist_no
                                     AND c100.dist_seq_no = a.dist_seq_no
                                     AND c100.peril_cd    = a.peril_cd)
                             LOOP
                                 v_dtl_sw := 'Y';
                                 EXIT;
                             END LOOP;
                             IF v_dtl_sw = 'N' THEN
                                   EXIT;
                             END IF;
                         END LOOP;
                         IF v_hdr_sw = 'N' THEN
                              EXIT;
                         END IF;
                     END LOOP;
                     IF v_hdr_sw = 'N' OR v_dtl_sw = 'N' THEN
                         p_msg_alert := 'There was an error encountered in Distribution Number '||to_char(bert.dist_no)
                              ||'. Records in some tables are missing.';--,'I',true);
                         RETURN;     
                     END IF;
              END IF;
       END IF;
    END IF;
  END LOOP;
END;
/


