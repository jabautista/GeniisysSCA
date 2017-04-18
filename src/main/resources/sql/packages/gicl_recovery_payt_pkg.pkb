CREATE OR REPLACE PACKAGE BODY CPI.GICL_RECOVERY_PAYT_PKG AS

    /*
   **  Created by   :  D.Alcantara
   **  Date Created : 12.14.2011
   **  Reference By : (GICLS055 - Generate Recovery Attg. Entries)
   **  Description  : Retrieves the payor name for the selected record from gicl_recovery_payt
   */ 
    FUNCTION get_gicl_recovery_payt_list ( 
        p_claim_id              GICL_CLAIMS.claim_id%TYPE,
        p_recovery_acct_id      GICL_RECOVERY_PAYT.recovery_acct_id%TYPE,
        p_module_id             VARCHAR2,
        p_user_id               GIIS_USERS.user_id%TYPE --marco - 08.07.2014
    ) RETURN gicl_recovery_payt_tab PIPELINED IS
        v_rec_payt      gicl_recovery_payt_type;
    BEGIN
        IF p_recovery_acct_id IS NULL THEN
            FOR i IN (
             /*   SELECT * FROM GICL_RECOVERY_PAYT
                 WHERE recovery_acct_id IS NULL
                   AND claim_id = NVL(p_claim_id, claim_id)
                   AND claim_id IN (SELECT claim_id
                                      FROM gicl_claims
                                     WHERE check_user_per_line(line_cd,ISS_CD,p_module_id)=1*/
                   SELECT * FROM GICL_RECOVERY_PAYT
                    WHERE recovery_acct_id IS NULL
                      AND NVL(cancel_tag,'N') = 'N'
                      AND claim_id = NVL(p_claim_id, claim_id)
                      AND claim_id IN (SELECT claim_id
                                         FROM gicl_claims
                                        WHERE check_user_per_line2(line_cd,ISS_CD,p_module_id,p_user_id)=1)
            ) LOOP
                v_rec_payt.recovery_id             := i.recovery_id;
                v_rec_payt.recovery_payt_id        := i.recovery_payt_id;
                v_rec_payt.claim_id                := i.claim_id;
                v_rec_payt.payor_class_cd          := i.payor_class_cd;
                v_rec_payt.payor_cd                := i.payor_cd;
                v_rec_payt.recovered_amt           := i.recovered_amt;
                v_rec_payt.acct_tran_id            := i.acct_tran_id;
                v_rec_payt.tran_date               := i.tran_date;
                v_rec_payt.cancel_tag              := i.cancel_tag;
                v_rec_payt.cancel_date             := i.cancel_date;
                v_rec_payt.entry_tag               := i.entry_tag;
                v_rec_payt.dist_sw                 := i.dist_sw;
                v_rec_payt.acct_tran_id2           := i.acct_tran_id2;
                v_rec_payt.tran_date2              := i.tran_date2;
                v_rec_payt.recovery_acct_id        := i.recovery_acct_id;
                v_rec_payt.stat_sw                 := i.stat_sw;
                v_rec_payt.dsp_payor_name          := GIIS_PAYEES_PKG.get_payee_whole_name(i.payor_class_cd, i.payor_cd);
                
                GET_GICL055_REC_PAYT_INFO(i.claim_id, i.acct_tran_id, i.recovery_id, --
                    v_rec_payt.dsp_line_cd, v_rec_payt.dsp_iss_cd, v_rec_payt.dsp_rec_year,
                    v_rec_payt.dsp_rec_seq_no, v_rec_payt.dsp_line_cd2, v_rec_payt.dsp_subline_cd1,    
                    v_rec_payt.dsp_iss_cd1, v_rec_payt.dsp_clm_yy, v_rec_payt.dsp_clm_seq_no,
                    v_rec_payt.dsp_pol_iss_cd, v_rec_payt.dsp_issue_yy, --
                    v_rec_payt.dsp_pol_seq_no, v_rec_payt.dsp_renew_no,  
                    v_rec_payt.dsp_assured_name, v_rec_payt.dsp_recovery_no, v_rec_payt.dsp_ref_no, 
                    v_rec_payt.dsp_claim_no, v_rec_payt.dsp_policy_no, v_rec_payt.dsp_loss_date, 
                    v_rec_payt.dsp_loss_ctgry, v_rec_payt.dsp_clm_stat_cd, v_rec_payt.dsp_in_hou_adj);
        
                v_rec_payt.acct_exists := '0';
                
                PIPE ROW(v_rec_payt);
            END LOOP;
        ELSE
            FOR j IN (
                SELECT * FROM GICL_RECOVERY_PAYT
                 WHERE recovery_acct_id IS NOT NULL
                   AND claim_id = NVL(p_claim_id, claim_id)
                   AND claim_id IN (SELECT claim_id
                                      FROM gicl_claims
                                     WHERE check_user_per_line2(line_cd,ISS_CD,p_module_id,p_user_id)=1)
            ) LOOP
                v_rec_payt.recovery_id             := j.recovery_id;
                v_rec_payt.recovery_payt_id        := j.recovery_payt_id;
                v_rec_payt.claim_id                := j.claim_id;
                v_rec_payt.payor_class_cd          := j.payor_class_cd;
                v_rec_payt.payor_cd                := j.payor_cd;
                v_rec_payt.recovered_amt           := j.recovered_amt;
                v_rec_payt.acct_tran_id            := j.acct_tran_id;
                v_rec_payt.tran_date               := j.tran_date;
                v_rec_payt.cancel_tag              := j.cancel_tag;
                v_rec_payt.cancel_date             := j.cancel_date;
                v_rec_payt.entry_tag               := j.entry_tag;
                v_rec_payt.dist_sw                 := j.dist_sw;
                v_rec_payt.acct_tran_id2           := j.acct_tran_id2;
                v_rec_payt.tran_date2              := j.tran_date2;
                v_rec_payt.recovery_acct_id        := j.recovery_acct_id;
                v_rec_payt.stat_sw                 := j.stat_sw;
                v_rec_payt.dsp_payor_name          := GIIS_PAYEES_PKG.get_payee_whole_name(j.payor_class_cd, j.payor_cd);
                
                GET_GICL055_REC_PAYT_INFO(j.claim_id, j.acct_tran_id, j.recovery_id, --
                    v_rec_payt.dsp_line_cd, v_rec_payt.dsp_iss_cd, v_rec_payt.dsp_rec_year,
                    v_rec_payt.dsp_rec_seq_no, v_rec_payt.dsp_line_cd2, v_rec_payt.dsp_subline_cd1,    
                    v_rec_payt.dsp_iss_cd1, v_rec_payt.dsp_clm_yy, v_rec_payt.dsp_clm_seq_no,
                    v_rec_payt.dsp_pol_iss_cd, v_rec_payt.dsp_issue_yy, --
                    v_rec_payt.dsp_pol_seq_no, v_rec_payt.dsp_renew_no,  
                    v_rec_payt.dsp_assured_name, v_rec_payt.dsp_recovery_no, v_rec_payt.dsp_ref_no, 
                    v_rec_payt.dsp_claim_no, v_rec_payt.dsp_policy_no, v_rec_payt.dsp_loss_date, 
                    v_rec_payt.dsp_loss_ctgry, v_rec_payt.dsp_clm_stat_cd, v_rec_payt.dsp_in_hou_adj);
        
                v_rec_payt.acct_exists := '0';
                FOR l IN (
                    SELECT 1   
                     FROM gicl_recovery_acct a, giac_acctrans b
                    WHERE a.acct_tran_id = b.tran_id
                      AND a.recovery_acct_id = p_recovery_acct_id
                      AND b.tran_flag <> 'D'
                ) LOOP
                    v_rec_payt.acct_exists := '1';
                    exit;
                END LOOP;
                
                FOR k IN (
                   SELECT tran_flag
                      FROM giac_acctrans
                     WHERE tran_id = j.acct_tran_id
                ) LOOP
                    v_rec_payt.tran_flag := k.tran_flag;
                    exit;
                END LOOP;
                
                PIPE ROW(v_rec_payt);
            END LOOP;
        END IF;
       
    END get_gicl_recovery_payt_list;
    
/*    FUNCTION get_gicl_recovery_payt_list1 ( 
        p_claim_id              GICL_CLAIMS.claim_id%TYPE,
        p_recovery_acct_id      GICL_RECOVERY_PAYT.recovery_acct_id%TYPE,
        p_module_id             VARCHAR2
    ) RETURN gicl_recovery_payt_tab PIPELINED IS
        v_rec_payt      gicl_recovery_payt_type;
        
        TYPE cur_typ IS REF CURSOR;
        v_cur         cur_typ;
        v_query_str   VARCHAR2 (30000);
    BEGIN
        
    END get_gicl_recovery_payt_list1;*/
    
     /*
   **  Created by   :  D.Alcantara
   **  Date Created : 01.05.2011
   **  Reference By : (GICLS055 - Generate Recovery Attg. Entries)
   **  Description  : Cancels the selected recovery payt
   */ 
    PROCEDURE cancel_recovery_payt (
        p_recovery_acct_id      IN GICL_RECOVERY_PAYT.recovery_acct_id%TYPE,
        p_acct_tran_id          IN VARCHAR2,
        p_user_id               IN GIIS_USERS.user_id%TYPE,
        p_message               OUT VARCHAR2
    ) IS
        v_exists                VARCHAR2(1) := '0';
    BEGIN
        giis_users_pkg.app_user := p_user_id;
        IF p_acct_tran_id IS NOT NULL OR p_acct_tran_id != '' THEN

         UPDATE gicl_recovery_payt
            SET entry_tag = 'N',
                acct_tran_id2 = NULL,
                tran_date2 = NULL,
                recovery_acct_id = NULL 
          WHERE recovery_acct_id = p_recovery_acct_id;
       --   p_message := 'p_acct_tran_id IS NOT NULL';
       ELSE
        UPDATE gicl_recovery_payt
           SET recovery_acct_id = NULL
         WHERE recovery_acct_id = p_recovery_acct_id;   
       --  p_message := 'p_acct_tran_id IS NULL';
       END IF;
       
       --aeg_delete_acct_entries
       DELETE FROM gicl_rec_acct_entries
            WHERE recovery_acct_id = p_recovery_acct_id;
       /*FOR i IN (
         SELECT '1'
           FROM gicl_rec_acct_entries
          WHERE recovery_acct_id = p_recovery_acct_id
       ) LOOP
          v_exists := '1';
          EXIT;
       END LOOP;
       
       IF v_exists = '1' THEN
       DELETE FROM gicl_rec_acct_entries
            WHERE recovery_acct_id = p_recovery_acct_id;
         v_exists := '1';   
       ELSE
         v_exists := '0';
         p_message := 'No acct entries record. ';
       END IF;*/
    END cancel_recovery_payt;
    
   /*
   **  Created by   :  D.Alcantara
   **  Date Created : 01.30.2012
   **  Reference By : (GICLS055 - Generate Recovery Attg. Entries)
   **  Description  : Updates gicl_recovery_payt records on posting
   */
    PROCEDURE update_recovery_for_post (
        p_recovery_acct_id      GICL_RECOVERY_PAYT.recovery_acct_id%TYPE,
        p_acct_tran_id          GICL_RECOVERY_PAYT.acct_tran_id%TYPE
    ) IS
    BEGIN
        UPDATE gicl_recovery_payt
           SET acct_tran_id2 = p_acct_tran_id,
               tran_date2 = SYSDATE,
               entry_tag = 'Y'   
         WHERE recovery_acct_id = p_recovery_acct_id;
    END update_recovery_for_post;
    
    
    FUNCTION get_gicl_recovery_payt_list1 ( 
        p_claim_id              GICL_CLAIMS.claim_id%TYPE,
        p_recovery_acct_id      GICL_RECOVERY_PAYT.recovery_acct_id%TYPE,
        p_module_id             VARCHAR2,
        p_user_id               GIIS_USERS.user_id%TYPE --marco - 08.07.2014
    ) RETURN gicl_recovery_payt_tab PIPELINED IS
        v_rec_payt      gicl_recovery_payt_type;
        
        v_dsp_line_cd             GICL_CLM_RECOVERY.line_cd%TYPE;
        v_dsp_iss_cd              GICL_CLM_RECOVERY.iss_cd%TYPE;
        v_dsp_rec_year            GICL_CLM_RECOVERY.rec_year%TYPE;
        v_dsp_rec_seq_no          GICL_CLM_RECOVERY.rec_seq_no%TYPE;
        v_dsp_line_cd2            GICL_CLAIMS.line_cd%TYPE;
        v_dsp_subline_cd1         GICL_CLAIMS.subline_cd%TYPE;    
        v_dsp_iss_cd1             GICL_CLAIMS.iss_cd%TYPE;
        v_dsp_clm_yy              GICL_CLAIMS.clm_yy%TYPE;
        v_dsp_clm_seq_no          GICL_CLAIMS.clm_seq_no%TYPE;
        v_dsp_pol_iss_cd          GICL_CLAIMS.pol_iss_cd%TYPE;
        v_dsp_issue_yy            GICL_CLAIMS.issue_yy%TYPE;
        v_dsp_pol_seq_no          GICL_CLAIMS.pol_seq_no%TYPE;
        v_dsp_renew_no            GICL_CLAIMS.renew_no%TYPE;
        
        v_dsp_recovery_no         VARCHAR2(50);
        v_dsp_payor_name          VARCHAR2(300);
        v_dsp_assured_name        GICL_CLAIMS.assured_name%TYPE;
        v_dsp_ref_no              VARCHAR2(50);
        v_dsp_claim_no            VARCHAR2(50);
        v_dsp_policy_no           VARCHAR2(50);
        v_dsp_loss_date           VARCHAR2(30);
        v_dsp_loss_ctgry          GIIS_LOSS_CTGRY.loss_cat_des%TYPE;
        v_dsp_clm_stat_cd         GICL_CLAIMS.clm_stat_cd%TYPE;
        v_dsp_in_hou_adj          GICL_CLAIMS.in_hou_adj%TYPE;
        v_acct_exists             VARCHAR2(2);
        v_tran_flag               GIAC_ACCTRANS.tran_flag%TYPE;
    BEGIN
        
        FOR j IN (
            SELECT * FROM GICL_RECOVERY_PAYT
             WHERE recovery_acct_id = p_recovery_acct_id
               AND claim_id = NVL(p_claim_id, claim_id)
               AND claim_id IN (SELECT claim_id
                                  FROM gicl_claims
                                 WHERE check_user_per_line2(line_cd,ISS_CD,p_module_id,p_user_id)=1)
        ) LOOP
            v_rec_payt.dsp_payor_name          := GIIS_PAYEES_PKG.get_payee_whole_name(j.payor_class_cd, j.payor_cd);
                
            GET_GICL055_REC_PAYT_INFO(j.claim_id, j.acct_tran_id, j.recovery_id, --
                v_dsp_line_cd, v_dsp_iss_cd, v_dsp_rec_year,
                v_dsp_rec_seq_no, v_dsp_line_cd2, v_dsp_subline_cd1,    
                v_dsp_iss_cd1, v_dsp_clm_yy, v_dsp_clm_seq_no,
                v_dsp_pol_iss_cd, v_dsp_issue_yy, --
                v_dsp_pol_seq_no, v_dsp_renew_no,  
                v_dsp_assured_name, v_dsp_recovery_no, v_dsp_ref_no, 
                v_dsp_claim_no, v_dsp_policy_no, v_dsp_loss_date, 
                v_dsp_loss_ctgry, v_dsp_clm_stat_cd, v_dsp_in_hou_adj);
                
            FOR j1 IN (
                SELECT * FROM GICL_RECOVERY_PAYT
                 WHERE recovery_acct_id = j.recovery_acct_id
                   AND NVL(cancel_tag,'N') = 'N'
                   AND recovery_payt_id = j.recovery_payt_id
                   AND claim_id = NVL(p_claim_id, j.claim_id)
                   AND claim_id IN (SELECT claim_id
                                     FROM gicl_claims
                                    WHERE check_user_per_line2(line_cd,ISS_CD,p_module_id,p_user_id)=1)
                   AND recovery_id IN (SELECT recovery_id 
                                         FROM gicl_clm_recovery
                                        WHERE line_cd = NVL(v_dsp_line_cd, line_cd) 
                                          AND iss_cd = NVL(v_dsp_iss_cd, iss_cd)
                                          AND rec_year = NVL(v_dsp_rec_year, rec_year)
                                          AND rec_seq_no = NVL(v_dsp_rec_seq_no, rec_seq_no))
                   AND claim_id IN (SELECT a.claim_id
                                      FROM gicl_claims a, giis_loss_ctgry b
                                     WHERE a.line_cd = NVL(v_dsp_line_cd2, a.line_cd)
                                       AND a.subline_cd = NVL(v_dsp_subline_cd1, a.subline_cd)
                                       AND a.iss_cd = NVL(v_dsp_iss_cd1, a.iss_cd)
                                       AND a.clm_yy = NVL(v_dsp_clm_yy, a.clm_yy)
                                       AND a.clm_seq_no = NVL(v_dsp_clm_seq_no, a.clm_seq_no)
                                       AND a.line_cd = NVL(v_dsp_line_cd2, a.line_cd)
                                       AND a.subline_cd = NVL(v_dsp_subline_cd1, a.subline_cd)
                                       AND a.pol_iss_cd = NVL(v_dsp_pol_iss_cd, a.pol_iss_cd)
                                       AND a.issue_yy = NVL(v_dsp_issue_yy, a.issue_yy)
                                       AND a.pol_seq_no = NVL(v_dsp_pol_seq_no, a.pol_seq_no)
                                       AND a.renew_no = NVL(v_dsp_renew_no, a.renew_no)
                                       AND TRUNC(a.dsp_loss_date) = TRUNC(NVL(TO_DATE(v_dsp_loss_date), a.dsp_loss_date))
                                       AND a.assured_name LIKE NVL(v_dsp_assured_name, a.assured_name)
                                       AND a.line_cd = b.line_cd
                                       AND a.loss_cat_cd = b.loss_cat_cd
                                       AND b.loss_cat_des like NVL(v_dsp_loss_ctgry, loss_cat_des))                      
            ) LOOP
                v_rec_payt.recovery_id             := j1.recovery_id;
                v_rec_payt.recovery_payt_id        := j1.recovery_payt_id;
                v_rec_payt.claim_id                := j1.claim_id;
                v_rec_payt.payor_class_cd          := j1.payor_class_cd;
                v_rec_payt.payor_cd                := j1.payor_cd;
                v_rec_payt.recovered_amt           := j1.recovered_amt;
                v_rec_payt.acct_tran_id            := j1.acct_tran_id;
                v_rec_payt.tran_date               := j1.tran_date;
                v_rec_payt.cancel_tag              := j1.cancel_tag;
                v_rec_payt.cancel_date             := j1.cancel_date;
                v_rec_payt.entry_tag               := j1.entry_tag;
                v_rec_payt.dist_sw                 := j1.dist_sw;
                v_rec_payt.acct_tran_id2           := j1.acct_tran_id2;
                v_rec_payt.tran_date2              := j1.tran_date2;
                v_rec_payt.recovery_acct_id        := j1.recovery_acct_id;
                v_rec_payt.stat_sw                 := j1.stat_sw;
                v_rec_payt.dsp_payor_name          := GIIS_PAYEES_PKG.get_payee_whole_name(j1.payor_class_cd, j1.payor_cd);

                GET_GICL055_REC_PAYT_INFO(j1.claim_id, j1.acct_tran_id, j1.recovery_id, --
                    v_rec_payt.dsp_line_cd, v_rec_payt.dsp_iss_cd, v_rec_payt.dsp_rec_year,
                    v_rec_payt.dsp_rec_seq_no, v_rec_payt.dsp_line_cd2, v_rec_payt.dsp_subline_cd1,    
                    v_rec_payt.dsp_iss_cd1, v_rec_payt.dsp_clm_yy, v_rec_payt.dsp_clm_seq_no,
                    v_rec_payt.dsp_pol_iss_cd, v_rec_payt.dsp_issue_yy, --
                    v_rec_payt.dsp_pol_seq_no, v_rec_payt.dsp_renew_no,  
                    v_rec_payt.dsp_assured_name, v_rec_payt.dsp_recovery_no, v_rec_payt.dsp_ref_no, 
                    v_rec_payt.dsp_claim_no, v_rec_payt.dsp_policy_no, v_rec_payt.dsp_loss_date, 
                    v_rec_payt.dsp_loss_ctgry, v_rec_payt.dsp_clm_stat_cd, v_rec_payt.dsp_in_hou_adj);
                
                v_rec_payt.acct_exists := '0';
                FOR l IN (
                    SELECT 1   
                     FROM gicl_recovery_acct a, giac_acctrans b
                    WHERE a.acct_tran_id = b.tran_id
                      AND a.recovery_acct_id = p_recovery_acct_id
                      AND b.tran_flag <> 'D'
                ) LOOP
                    v_rec_payt.acct_exists := '1';
                    exit;
                END LOOP;
                    
                FOR k IN (
                   SELECT tran_flag
                      FROM giac_acctrans
                     WHERE tran_id = (SELECT acct_tran_id FROM gicl_recovery_acct
                                       WHERE recovery_acct_id = p_recovery_acct_id)
                ) LOOP
                    v_rec_payt.tran_flag := k.tran_flag;
                    exit;
                END LOOP;
                
                PIPE ROW(v_rec_payt);
            END LOOP;        
        END LOOP;
       
    END get_gicl_recovery_payt_list1;
    
    /*
   **  Created by   :  D.Alcantara
   **  Date Created : 01.31.2012
   **  Reference By : (GICLS055 - Generate Recovery Attg. Entries)
   **  Description  :  Updates gicl_Recovery_payt on generate_recovery_Acct
   */
    PROCEDURE update_generated_rec_payt (
        p_recovery_id             GICL_RECOVERY_PAYT.recovery_id%TYPE,
        p_recovery_payt_id        GICL_RECOVERY_PAYT.recovery_payt_id%TYPE,
        p_recovery_acct_id        GICL_RECOVERY_PAYT.recovery_acct_id%TYPE
    ) IS
        v_rec_acct  GICL_RECOVERY_PAYT.recovery_acct_id%TYPE := p_recovery_acct_id;
    BEGIN
        UPDATE gicl_recovery_payt
           SET recovery_acct_id = p_recovery_acct_id   
         WHERE recovery_id = p_recovery_id
           AND recovery_payt_id = p_recovery_payt_id; 
    END update_generated_rec_payt;

    /*
   **  Created by   :  Niknok Orio 
   **  Date Created : 03.15.2012
   **  Reference By : (GICLS025 - Recovery Information)
   **  Description  : check if recovery already has valid payments
   */
    PROCEDURE check_recover_valid_payt(
        p_claim_id                  gicl_recovery_payt.claim_id%TYPE,
        p_recovery_id               gicl_recovery_payt.recovery_id%TYPE,
        p_check_valid        OUT    NUMBER,
        p_check_all          OUT    NUMBER
        ) IS
    BEGIN
        p_check_valid   := 0;
        p_check_all     := 0;
        
        -- check first if recovery already has valid payments
        FOR valid_payt IN
            (SELECT 1
              FROM gicl_recovery_payt
             WHERE claim_id = p_claim_id
               AND recovery_id = p_recovery_id
               AND NVL(cancel_tag ,'N') = 'N') 
        LOOP
            p_check_valid := 1;
            EXIT;
        END LOOP;

        -- check first if recovery already has valid payments
        FOR all_payt IN
            (SELECT 1
              FROM gicl_recovery_payt
             WHERE claim_id = p_claim_id
               AND recovery_id = p_recovery_id)
        LOOP
            p_check_all := 1;
            EXIT;
        END LOOP;
    END;    

    /*
   **  Created by   :  Niknok Orio 
   **  Date Created : 03.30.2012
   **  Reference By : (GICLS025 - Recovery Information)
   **  Description  :  
   */
    FUNCTION get_gicl_recovery_payt ( 
        p_claim_id              GICL_CLAIMS.claim_id%TYPE,
        p_recovery_id           GICL_RECOVERY_PAYT.recovery_acct_id%TYPE 
        ) 
    RETURN gicl_recovery_payt_tab2 PIPELINED IS
      v_list        gicl_recovery_payt_type2;
    BEGIN
        FOR i IN (SELECT a.recovery_id,      a.recovery_payt_id, a.claim_id,         
                         a.payor_class_cd,   a.payor_cd,         a.recovered_amt,    
                         a.acct_tran_id,     a.tran_date,        a.cancel_tag,       
                         a.cancel_date,      a.entry_tag,        a.dist_sw,          
                         a.acct_tran_id2,    a.tran_date2,       a.recovery_acct_id, 
                         a.stat_sw,          a.user_id,          a.last_update,      
                         a.cpi_rec_no,       a.cpi_branch_cd    
                    FROM gicl_recovery_payt a
                   WHERE a.claim_id = p_claim_id
                     AND a.recovery_id = p_recovery_id)
        LOOP
            v_list.recovery_id             := i.recovery_id;
            v_list.recovery_payt_id        := i.recovery_payt_id;
            v_list.claim_id                := i.claim_id;
            v_list.payor_class_cd          := i.payor_class_cd;
            v_list.payor_cd                := i.payor_cd;
            v_list.recovered_amt           := i.recovered_amt;
            v_list.acct_tran_id            := i.acct_tran_id;
            v_list.tran_date               := i.tran_date;
            v_list.cancel_tag              := i.cancel_tag;
            v_list.cancel_date             := i.cancel_date;
            v_list.entry_tag               := i.entry_tag;
            v_list.dist_sw                 := i.dist_sw;
            v_list.acct_tran_id2           := i.acct_tran_id2;
            v_list.tran_date2              := i.tran_date2;
            v_list.recovery_acct_id        := i.recovery_acct_id;
            v_list.stat_sw                 := i.stat_sw;
            v_list.user_id                 := i.user_id;
            v_list.last_update             := i.last_update;
            v_list.cpi_rec_no              := i.cpi_rec_no;
            v_list.cpi_branch_cd           := i.cpi_branch_cd;
            
            BEGIN
              SELECT payee_last_name||' '||payee_first_name||' '||
                     payee_middle_name
                INTO v_list.dsp_payor_name
                FROM giis_payees
               WHERE payee_no = i.payor_cd
                 AND payee_class_cd = i.payor_class_cd;
            EXCEPTION
              WHEN OTHERS THEN
                   v_list.dsp_payor_name := NULL;
            END;
            
            BEGIN
                FOR xx IN (SELECT tran_class, tran_class_no
                            FROM giac_acctrans
                           WHERE tran_id = i.acct_tran_id
                     AND tran_id NOT IN (SELECT e.gacc_tran_id
                                           FROM giac_reversals e, giac_acctrans f
                                          WHERE e.reversing_tran_id = f.tran_id
                                            AND f.tran_flag <> 'D')
                     AND tran_flag <> 'D') LOOP
                  IF xx.tran_class = 'COL' THEN
                    FOR c IN (SELECT or_pref_suf||'-'||TO_CHAR(or_no) or_no 
                                FROM giac_order_of_payts
                               WHERE gacc_tran_id = i.acct_tran_id)
                    LOOP
                      v_list.dsp_ref_cd := c.or_no;
                    END LOOP; 
                  ELSIF xx.tran_class = 'DV' THEN
                    FOR r IN (SELECT document_cd||'-'||branch_cd||'-'||TO_CHAR(doc_year)||'-'||TO_CHAR(doc_mm)
                                     ||'-'||TO_CHAR(doc_seq_no) request_no
                                FROM giac_payt_requests a, giac_payt_requests_dtl b
                               WHERE a.ref_id = b.gprq_ref_id
                                 AND b.tran_id = i.acct_tran_id)
                    LOOP
                      v_list.dsp_ref_cd:= r.request_no;
                      FOR d IN (   
                                SELECT dv_pref||'-'||TO_CHAR(dv_no) dv_no
                                  FROM giac_disb_vouchers
                                 WHERE gacc_tran_id = i.acct_tran_id)
                      LOOP
                        v_list.dsp_ref_cd:= d.dv_no;
                      END LOOP;
                    END LOOP; 
                  ELSIF xx.tran_class = 'JV' THEN
                    v_list.dsp_ref_cd:= xx.tran_class_no; 
                  END IF;
                END LOOP;
            END;
             
            FOR xx IN (SELECT cancel_tag, dist_sw
                        FROM gicl_recovery_payt
                       WHERE recovery_id = i.recovery_id
                         AND recovery_payt_id = i.recovery_payt_id)
            LOOP 
                IF xx.cancel_tag = 'Y' THEN
                  v_list.dsp_check_cancel := 'Y';
                ELSE 
                  v_list.dsp_check_cancel := 'N';
                END IF;
                
                IF xx.dist_sw = 'Y' THEN 
                  v_list.dsp_check_dist :='Y';
                ELSE 
                  v_list.dsp_check_dist := 'N';
                END IF;
            END LOOP;            
            
            PIPE ROW(v_list);
        END LOOP;
      RETURN;
    END;
	
	/*
   **  Created by   : Veronica V. Raymundo 
   **  Date Created : 04.10.201
   **  Reference By : (GICLS260 - Claims Information)
   **  Description  : Gets the list of GICL_RECOVERY_PAYT for GICLS260 
   */
    FUNCTION get_gicl_recovery_payt2 ( 
        p_claim_id              GICL_CLAIMS.claim_id%TYPE,
        p_recovery_id           GICL_RECOVERY_PAYT.recovery_acct_id%TYPE 
        ) 
    RETURN gicl_recovery_payt_tab2 PIPELINED IS
      v_list        gicl_recovery_payt_type2;
	  v_check		NUMBER := 0;
	  
    BEGIN
        FOR i IN (SELECT a.recovery_id,      a.recovery_payt_id, a.claim_id,         
                         a.payor_class_cd,   a.payor_cd,         a.recovered_amt,    
                         a.acct_tran_id,     a.tran_date,        a.cancel_tag,       
                         a.cancel_date,      a.entry_tag,        a.dist_sw,          
                         a.acct_tran_id2,    a.tran_date2,       a.recovery_acct_id, 
                         a.stat_sw,          a.user_id,          a.last_update,      
                         a.cpi_rec_no,       a.cpi_branch_cd    
                    FROM gicl_recovery_payt a
                   WHERE a.claim_id = p_claim_id
                     AND a.recovery_id = p_recovery_id
				   ORDER BY recovery_payt_id)
        LOOP
            v_list.recovery_id             := i.recovery_id;
            v_list.recovery_payt_id        := i.recovery_payt_id;
            v_list.claim_id                := i.claim_id;
            v_list.payor_class_cd          := i.payor_class_cd;
            v_list.payor_cd                := i.payor_cd;
            v_list.recovered_amt           := i.recovered_amt;
            v_list.acct_tran_id            := i.acct_tran_id;
            v_list.tran_date               := i.tran_date;
            v_list.cancel_tag              := NVL(i.cancel_tag, 'N');
            v_list.cancel_date             := i.cancel_date;
            v_list.entry_tag               := i.entry_tag;
            v_list.dist_sw                 := NVL(i.dist_sw, 'N');
            v_list.acct_tran_id2           := i.acct_tran_id2;
            v_list.tran_date2              := i.tran_date2;
            v_list.recovery_acct_id        := i.recovery_acct_id;
            v_list.stat_sw                 := i.stat_sw;
            v_list.user_id                 := i.user_id;
            v_list.last_update             := i.last_update;
            v_list.cpi_rec_no              := i.cpi_rec_no;
            v_list.cpi_branch_cd           := i.cpi_branch_cd;
            v_list.sdf_tran_date           := TO_CHAR(i.tran_date,'MM-DD-YYYY');
            
            BEGIN
              SELECT payee_last_name||' '||payee_first_name||' '||
                     payee_middle_name
                INTO v_list.dsp_payor_name
                FROM giis_payees
               WHERE payee_no = i.payor_cd
                 AND payee_class_cd = i.payor_class_cd;
            EXCEPTION
              WHEN OTHERS THEN
                   v_list.dsp_payor_name := NULL;
            END;
            
            BEGIN
				FOR t IN (SELECT tran_class, TO_CHAR(tran_class_no,'0999999999') tran_class_no
							FROM giac_acctrans
						   WHERE tran_id = i.acct_tran_id)
				LOOP 
				  IF t.tran_class = 'COL' THEN
					 FOR c IN (
					   SELECT or_pref_suf||'-'||TO_CHAR(or_no,'0999999999') or_no 
						 FROM giac_order_of_payts
						WHERE gacc_tran_id = i.acct_tran_id)
					 LOOP
					   v_list.dsp_ref_cd := c.or_no;
					 END LOOP; 
				  ELSIF t.tran_class = 'DV' THEN
					 FOR r IN (
					   SELECT document_cd||'-'||branch_cd||'-'||TO_CHAR(doc_year)
							  ||'-'||TO_CHAR(doc_mm)||'-'||TO_CHAR(doc_seq_no,'099999') request_no
						 FROM giac_payt_requests a, giac_payt_requests_dtl b
						WHERE a.ref_id = b.gprq_ref_id
						  AND b.tran_id = i.acct_tran_id)
					 LOOP 
					   v_list.dsp_ref_cd := r.request_no;
					   FOR d IN (   
						 SELECT dv_pref||'-'||TO_CHAR(dv_no,'0999999999') dv_no
						   FROM giac_disb_vouchers
						  WHERE gacc_tran_id = i.acct_tran_id)
					   LOOP
						 v_list.dsp_ref_cd := d.dv_no;
					   END LOOP;
					 END LOOP; 
				  ELSIF t.tran_class = 'JV' THEN
					 v_list.dsp_ref_cd := t.tran_class||'-'||t.tran_class_no; 
				  END IF;
				END LOOP;
            END;
             
            BEGIN
			  SELECT COUNT(*)
				INTO v_check
			    FROM gicl_recovery_ds a
			   WHERE a.recovery_id = i.recovery_id
			     AND a.recovery_payt_id = i.recovery_payt_id;
			   
			   IF v_check <> 0 THEN
				   v_list.dsp_check_dist := 'Y';
			   ELSE
				   v_list.dsp_check_dist := 'N';
			   END IF;	
		    END;           
            
            PIPE ROW(v_list);
        END LOOP;
      RETURN;
    END;
    
END GICL_RECOVERY_PAYT_PKG;
/


