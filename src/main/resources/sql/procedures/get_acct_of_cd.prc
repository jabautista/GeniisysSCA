DROP PROCEDURE CPI.GET_ACCT_OF_CD;

CREATE OR REPLACE PROCEDURE CPI.get_acct_of_cd(
        p_line_cd           VARCHAR2,
        p_subline_cd        VARCHAR2, 
        p_iss_cd            VARCHAR2, 
        p_issue_yy          NUMBER,
        p_pol_seq_no        NUMBER,
        p_renew_no          NUMBER,
        p_eff_date          VARCHAR2,
        p_modal_flag        IN OUT VARCHAR2,
        p_acct_of_cd        IN OUT gipi_wpolbas.acct_of_cd%TYPE,
        p_drv_acct_of_cd    OUT giis_assured.assd_name%TYPE,
        p_label_tag         OUT VARCHAR2,
        p_var_acct_of_cd    OUT VARCHAR2
        ) IS
BEGIN    
  IF p_modal_flag = 'N' AND p_eff_date IS NOT NULL THEN
     IF p_acct_of_cd IS NOT NULL THEN
        FOR rec1 IN (SELECT a020.assd_name assd_name
                       FROM giis_assured a020
                      WHERE a020.assd_no = p_acct_of_cd)
        LOOP
           p_drv_acct_of_cd := rec1.assd_name;  
        END LOOP;
     END IF;
  ELSE    
    p_modal_flag := 'N';
    FOR rec IN (SELECT a.acct_of_cd acct_of_cd, a.acct_of_cd_sw acct_of_cd_sw, label_tag /*gmi 050307*/
                  FROM gipi_polbasic a
                 WHERE a.line_cd     = p_line_cd
                   AND a.subline_cd  = p_subline_cd
                   AND a.iss_cd      = p_iss_cd
                   AND a.issue_yy    = p_issue_yy
                   AND a.pol_seq_no  = p_pol_seq_no
                   AND a.renew_no    = p_renew_no
                   AND a.pol_flag IN ('1','2','3','X')
                   AND NOT EXISTS      (SELECT '1'
                                          FROM gipi_polbasic
                                         WHERE line_cd                 = a.line_cd
                                           AND subline_cd              = a.subline_cd
                                           AND iss_cd                  = a.iss_cd
                                           AND issue_yy                = a.issue_yy
                                           AND pol_seq_no              = a.pol_seq_no
                                           AND renew_no                = a.renew_no
                                           AND acct_of_cd              IS NOT NULL
                                           AND pol_flag IN ('1','2','3','X')
                                           AND endt_seq_no             > a.endt_seq_no
                                                               AND NVL(back_stat, 5) = 2)
                   ORDER BY a.eff_date DESC)
    LOOP        
        FOR rec1 IN (SELECT designation, assd_name
                       FROM giis_assured
                      WHERE assd_no = rec.acct_of_cd)
        LOOP 
            IF rec.acct_of_cd_sw = 'Y' THEN
               p_drv_acct_of_cd := NULL; 
               p_acct_of_cd     := NULL;
               p_label_tag      := 'N';/*gmi 050307*/
               p_var_acct_of_cd := NULL;
            ELSE                
               p_drv_acct_of_cd := rec1.assd_name;
               p_acct_of_cd     := rec.acct_of_cd;
               p_label_tag      := rec.label_tag;/*gmi 050307*/
               p_var_acct_of_cd := rec.acct_of_cd;
            END IF;
        END LOOP;
    EXIT;
    END LOOP; 
  END IF;
END;
/


