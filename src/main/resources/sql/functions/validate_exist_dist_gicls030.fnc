DROP FUNCTION CPI.VALIDATE_EXIST_DIST_GICLS030;

CREATE OR REPLACE FUNCTION CPI.VALIDATE_EXIST_DIST_GICLS030
(p_line_cd           GIPI_POLBASIC.line_cd%TYPE,  
 p_subline_cd        GIPI_POLBASIC.subline_cd%TYPE,
 p_pol_iss_cd        GIPI_POLBASIC.iss_cd%TYPE,
 p_issue_yy          GIPI_POLBASIC.issue_yy%TYPE,
 p_pol_seq_no        GIPI_POLBASIC.pol_seq_no%TYPE,
 p_renew_no          GIPI_POLBASIC.renew_no%TYPE,
 p_max_endt_seq_no   GICL_CLAIMS.max_endt_seq_no%TYPE) 
 
 RETURN VARCHAR2 IS
 
 /*
 **  Created by    : Veronica V. Raymundo
 **  Date Created  : 02.27.2012
 **  Reference By  : GICLS030 - Loss/Expense History
 **  Description   : Executes VALIDATE_EXISTING_DIST Program unit in GICLS030
 **                  
 */
 
  v_dist_param    GIIS_PARAMETERS.param_value_v%TYPE;
  v_hdr_sw        VARCHAR2(1);
  v_dtl_sw        VARCHAR2(1);
  v_msg_alert     VARCHAR2(500);

BEGIN

  IF p_renew_no IS NOT NULL THEN
     FOR rec IN
       (SELECT param_value_v
          FROM GIIS_PARAMETERS
         WHERE param_name = 'DISTRIBUTED')
     
     LOOP
       v_dist_param  := rec.param_value_v;
       EXIT; 
     END LOOP;
     
  END IF;

  FOR chk IN
    (SELECT b.dist_no dist_no, a.policy_id policy_id
       FROM GIPI_POLBASIC a, GIUW_POL_DIST b
      WHERE a.line_cd     = p_line_cd 
        AND a.subline_cd  = p_subline_cd 
        AND a.iss_cd      = p_pol_iss_cd 
        AND a.issue_yy    = p_issue_yy 
        AND a.pol_seq_no  = p_pol_seq_no 
        AND a.renew_no    = p_renew_no
        AND a.endt_seq_no = NVL(p_max_endt_seq_no, 0) -- Pia, 09.16.03
        AND a.policy_id   = b.policy_id 
        AND b.dist_flag   = v_dist_param
        AND a.pol_flag    IN ('1','2','3','X')
        AND b.negate_date IS NULL
        AND NOT EXISTS    (SELECT c.policy_id
                             FROM GIPI_ENDTTEXT c
                            WHERE c.endt_tax = 'Y'
                              AND c.policy_id = a.policy_id))
  LOOP    
    v_hdr_sw := 'N';
    FOR a IN
      (SELECT gpolds.dist_no, gpolds.dist_seq_no
         FROM GIUW_POLICYDS gpolds
        WHERE gpolds.dist_no = chk.dist_no)
    
    LOOP
      v_hdr_sw := 'Y';
      v_dtl_sw := 'N';
      
      FOR b IN
        (SELECT    '1'
           FROM GIUW_POLICYDS_DTL gpoldtl
          WHERE gpoldtl.dist_no     = a.dist_no
            AND gpoldtl.dist_seq_no = a.dist_seq_no)
      LOOP
        v_dtl_sw := 'Y';
        EXIT;
      END LOOP;
      
      IF v_dtl_sw = 'N' THEN
        EXIT;
      END IF;
      
    END LOOP;
    
    IF v_hdr_sw = 'N' OR
       v_dtl_sw = 'N' THEN
       v_msg_alert := 'There was an error encountered in Distribution Number '||
                       TO_CHAR(chk.dist_no)||'. Records in some tables are missing.';
       RETURN v_msg_alert;
        
    ELSE
       FOR item IN
         (SELECT gitm.item_no
            FROM GIPI_ITEM gitm
           WHERE gitm.policy_id = chk.policy_id
             AND EXISTS (SELECT '1'
                           FROM  GIPI_ITMPERIL gitmp
                          WHERE  gitmp.policy_id = gitm.policy_id
                            AND  gitmp.item_no   = gitm.item_no))
       LOOP
         v_hdr_sw := 'N';
         FOR a IN
           (SELECT gids.dist_no, gids.dist_seq_no
              FROM GIUW_ITEMDS gids
             WHERE gids.dist_no = chk.dist_no
               AND gids.item_no = item.item_no)
         LOOP
             v_hdr_sw := 'Y';
             v_dtl_sw := 'N';
             FOR b IN
             (SELECT '1'
                FROM giuw_itemds_dtl gidtl
               WHERE gidtl.dist_no     = a.dist_no
                 AND gidtl.dist_seq_no = a.dist_seq_no
                 AND gidtl.item_no     = item.item_no)
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
       
       IF v_hdr_sw = 'N' OR
          v_dtl_sw = 'N' THEN
          v_msg_alert := 'There was an error encountered in Distribution Number '||
                          TO_CHAR(chk.dist_no)||'. Records in some tables are missing.';
          RETURN v_msg_alert;
           
       ELSE
            FOR perl IN
                (SELECT gitmp.item_no, gitmp.peril_cd
                   FROM GIPI_ITMPERIL gitmp
                  WHERE gitmp.policy_id = chk.policy_id)
            LOOP
              v_hdr_sw := 'N';
              FOR a IN
              (SELECT gpids.dist_no, gpids.dist_seq_no, gpids.item_no,
                      gpids.peril_cd
                 FROM GIUW_ITEMPERILDS gpids
                WHERE gpids.dist_no  = chk.dist_no
                  AND gpids.item_no  = perl.item_no
                  AND gpids.peril_cd = perl.peril_cd)
              LOOP
                v_hdr_sw := 'Y';
                v_dtl_sw := 'N';
                FOR b IN
                    (SELECT '1'
                       FROM GIUW_ITEMPERILDS_DTL gipdtl    
                      WHERE gipdtl.dist_no     = a.dist_no
                        AND gipdtl.dist_seq_no = a.dist_seq_no
                        AND gipdtl.item_no     = a.item_no
                        AND gipdtl.peril_cd    = a.peril_cd)
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
               v_msg_alert := 'There was an error encountered in Distribution Number '||
                         TO_CHAR(chk.dist_no)||'. Records in some tables are missing.';
               RETURN v_msg_alert;
               
            ELSE
               FOR perl IN
                 (SELECT DISTINCT gpids.peril_cd peril_cd, gpids.dist_seq_no
                    FROM GIUW_ITEMPERILDS gpids
                   WHERE gpids.dist_no = chk.dist_no) 
               LOOP
                 v_hdr_sw := 'N';
                 FOR a IN
                     (SELECT gpds.dist_no, gpds.dist_seq_no, gpds.peril_cd
                        FROM GIUW_PERILDS gpds
                       WHERE gpds.dist_no  = chk.dist_no
                         AND gpds.dist_seq_no = perl.dist_seq_no
                         AND gpds.peril_cd = perl.peril_cd)
                 LOOP
                    v_hdr_sw := 'Y';
                    v_dtl_sw := 'N';
                    FOR b IN
                       (SELECT '1'
                          FROM GIUW_PERILDS_DTL gpd
                         WHERE gpd.dist_no     = a.dist_no
                           AND gpd.dist_seq_no = a.dist_seq_no
                           AND gpd.peril_cd    = a.peril_cd)
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
               
               IF v_hdr_sw = 'N' OR
                v_dtl_sw = 'N' THEN
                  v_msg_alert := 'There was an error encountered in Distribution Number '||
                                  TO_CHAR(chk.dist_no)||'. Records in some tables are missing.';
                  RETURN v_msg_alert;
               END IF;
               
            END IF;
       END IF;
    END IF;
  END LOOP;
  
  RETURN v_msg_alert;
  
END validate_exist_dist_gicls030;
/


