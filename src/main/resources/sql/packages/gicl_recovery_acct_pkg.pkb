CREATE OR REPLACE PACKAGE BODY CPI.GICL_RECOVERY_ACCT_PKG
AS
    /*
   **  Created by   :  D.Alcantara
   **  Date Created : 01.03.2012
   **  Reference By : (GICLS055 - Generate Recovery Attg. Entries)
   **  Description  :  Retrieves gicl_recovery_acct records for LOV
   */
    FUNCTION get_gicl_recovery_acct_list (
        p_claim_id             GICL_CLAIMS.claim_id%TYPE,
        p_user_id              GIIS_USERS.user_id%TYPE,
        p_module_id            VARCHAR2,
        p_recovery_acct_id     GICL_RECOVERY_ACCT.recovery_acct_id%TYPE
    ) RETURN gicl_recovery_acct_tab PIPELINED IS
        v_rec_acct              gicl_recovery_acct_type;
    BEGIN
        IF p_recovery_acct_id IS NOT NULL THEN
            FOR i IN (
                SELECT * 
                  FROM gicl_recovery_acct
                 WHERE recovery_acct_id = p_recovery_acct_id 
            ) LOOP
                v_rec_acct.recovery_acct_id         := i.recovery_acct_id;
                v_rec_acct.iss_cd                   := i.iss_cd;
                v_rec_acct.rec_acct_year            := i.rec_acct_year;
                v_rec_acct.rec_acct_seq_no          := i.rec_acct_seq_no;
                v_rec_acct.recovery_amt             := i.recovery_amt;
                v_rec_acct.recovery_acct_flag       := i.recovery_acct_flag;
                v_rec_acct.acct_tran_id             := i.acct_tran_id;
                v_rec_acct.tran_date                := i.tran_date;
                v_rec_acct.dsp_recovery_acct_no     := i.iss_cd || '-' || i.rec_acct_year || '-' || TRIM(TO_CHAR(i.rec_acct_seq_no, '099999'));
                v_rec_acct.dsp_tran_flag            := GIAC_ACCTRANS_PKG.get_tran_flag2(i.acct_tran_id);
                
                v_rec_acct.acct_exists := '0';
                FOR l IN (
                    SELECT 1   
                     FROM gicl_recovery_acct a, giac_acctrans b
                    WHERE a.acct_tran_id = b.tran_id
                      AND a.recovery_acct_id = i.recovery_acct_id
                      AND b.tran_flag <> 'D'
                ) LOOP
                    v_rec_acct.acct_exists := '1';
                    exit;
                END LOOP;
                
                FOR m IN (
                    SELECT claim_id FROM gicl_recovery_payt
                     WHERE recovery_acct_id = i.recovery_acct_id
                ) LOOP
                    v_rec_acct.nbt_claim_id := m.claim_id;
                    EXIT;
                END LOOP;
                
                PIPE ROW(v_rec_acct);
            END LOOP;
            RETURN;
        END IF;
        
        IF p_claim_id IS NOT NULL THEN
            FOR i IN (
                SELECT * 
                  FROM gicl_recovery_acct
                 WHERE recovery_acct_flag <> 'D'
                             AND recovery_acct_id IN (SELECT b.recovery_acct_id 
                                                        FROM gicl_recovery_payt b 
                                                       WHERE NVL(b.cancel_tag, 'N') = 'N' 
                                                         AND b.claim_id = p_claim_id
                                                         AND b.recovery_acct_id = recovery_acct_id) 
                             AND check_user_per_iss_cd2(NULL, iss_cd, p_module_id, p_user_id) = 1    -- kris 03.27.2014: used check_user_per_iss_cd2                         
                             /*AND check_user_per_iss_cd1(NULL, p_user_id, iss_cd, p_module_id) = 1  */       
            ) LOOP
                v_rec_acct.recovery_acct_id         := i.recovery_acct_id;
                v_rec_acct.iss_cd                   := i.iss_cd;
                v_rec_acct.rec_acct_year            := i.rec_acct_year;
                v_rec_acct.rec_acct_seq_no          := i.rec_acct_seq_no;
                v_rec_acct.recovery_amt             := i.recovery_amt;
                v_rec_acct.recovery_acct_flag       := i.recovery_acct_flag;
                v_rec_acct.acct_tran_id             := i.acct_tran_id;
                v_rec_acct.tran_date                := i.tran_date;
                v_rec_acct.dsp_recovery_acct_no     := i.iss_cd || '-' || i.rec_acct_year || '-' || TRIM(TO_CHAR(i.rec_acct_seq_no, '099999'));
                v_rec_acct.dsp_tran_flag            := GIAC_ACCTRANS_PKG.get_tran_flag2(i.acct_tran_id);
                v_rec_acct.nbt_claim_id             := p_claim_id;
                
                v_rec_acct.acct_exists := '0';
                FOR l IN (
                    SELECT 1   
                     FROM gicl_recovery_acct a, giac_acctrans b
                    WHERE a.acct_tran_id = b.tran_id
                      AND a.recovery_acct_id = i.recovery_acct_id
                      AND b.tran_flag <> 'D'
                ) LOOP
                    v_rec_acct.acct_exists := '1';
                    exit;
                END LOOP;

                PIPE ROW(v_rec_acct);
            END LOOP;      
        ELSE 
            FOR i IN(
                SELECT * 
                      FROM gicl_recovery_acct 
                     WHERE recovery_acct_flag <> 'D'
                       AND check_user_per_iss_cd2(NULL, iss_cd, p_module_id, p_user_id) = 1 -- kris 03.27.2014: used check_user_per_iss_cd2
                       /*and check_user_per_iss_cd1(null,p_user_id, iss_cd,p_module_id)=1*/
            ) LOOP
                v_rec_acct.recovery_acct_id         := i.recovery_acct_id;
                v_rec_acct.iss_cd                   := i.iss_cd;
                v_rec_acct.rec_acct_year            := i.rec_acct_year;
                v_rec_acct.rec_acct_seq_no          := i.rec_acct_seq_no;
                v_rec_acct.recovery_amt             := i.recovery_amt;
                v_rec_acct.recovery_acct_flag       := i.recovery_acct_flag;
                v_rec_acct.acct_tran_id             := i.acct_tran_id;
                v_rec_acct.tran_date                := i.tran_date;
                v_rec_acct.dsp_recovery_acct_no     := i.iss_cd || '-' || i.rec_acct_year || '-' || TRIM(TO_CHAR(i.rec_acct_seq_no, '099999'));
                v_rec_acct.dsp_tran_flag            := GIAC_ACCTRANS_PKG.get_tran_flag2(i.acct_tran_id);
                
                v_rec_acct.acct_exists := '0';
                FOR l IN (
                    SELECT 1   
                     FROM gicl_recovery_acct a, giac_acctrans b
                    WHERE a.acct_tran_id = b.tran_id
                      AND a.recovery_acct_id = i.recovery_acct_id
                      AND b.tran_flag <> 'D'
                ) LOOP
                    v_rec_acct.acct_exists := '1';
                    exit;
                END LOOP;
                
                FOR m IN (
                    SELECT claim_id FROM gicl_recovery_payt
                     WHERE recovery_acct_id = i.recovery_acct_id
                ) LOOP
                    v_rec_acct.nbt_claim_id := m.claim_id;
                    EXIT;
                END LOOP;
                
                PIPE ROW(v_rec_acct);
            END LOOP;
        END IF;      
    END get_gicl_recovery_acct_list;
 
    /*
   **  Created by   :  D.Alcantara
   **  Date Created : 02.01.2012
   **  Reference By : (GICLS055 - Generate Recovery Attg. Entries)
   **  Description  :  Retrieves and validates necessary values for generating recovery accts
   */
    PROCEDURE generate_recovery_acct_info (
        p_iss_cd            IN     GICL_RECOVERY_ACCT.iss_cd%TYPE,
        p_recovery_acct_id  OUT    GICL_RECOVERY_ACCT.recovery_acct_id%TYPE,
        p_rec_acct_year     OUT    GICL_RECOVERY_ACCT.rec_acct_year%TYPE,
        p_rec_acct_seq_no   OUT    GICL_RECOVERY_ACCT.rec_acct_seq_no%TYPE
    ) IS
        v_rec_acct  GICL_RECOVERY_PAYT.recovery_acct_id%TYPE := p_recovery_acct_id;
    BEGIN
        FOR rec IN (SELECT RECOVERY_ACCT_ID_S.nextval recovery_acct_id
                   FROM dual)  
        LOOP
            v_rec_acct := rec.recovery_acct_id;
            FOR id in (SELECT '1'
                        FROM gicl_recovery_acct
                       WHERE recovery_acct_id = v_rec_acct)
            LOOP
             v_rec_acct := null;
            END LOOP; 
            
            IF v_rec_acct IS NOT NULL THEN
              EXIT;
            END IF;

        END LOOP;
    
        IF v_rec_acct IS NULL THEN
            p_recovery_acct_id := 1;
        ELSE
            p_recovery_acct_id := v_rec_acct;
        END IF;
        
        FOR yr IN (SELECT TO_NUMBER(TO_CHAR(SYSDATE,'YYYY')) acct_year 
                 FROM dual)
        LOOP
           p_rec_acct_year := yr.acct_year;
        END LOOP; 
        
        FOR seq IN (SELECT NVL(MAX(rec_acct_seq_no)+1,1) acct_seq_no   
                 FROM gicl_recovery_acct
                WHERE iss_cd = p_iss_cd
                  AND rec_acct_year = p_rec_acct_year)
        LOOP
            p_rec_acct_seq_no := seq.acct_seq_no; 
        END LOOP;
        
    END generate_recovery_acct_info;
    
   /*
   **  Created by   :  D.Alcantara
   **  Date Created : 02.01.2012
   **  Reference By : (GICLS055 - Generate Recovery Attg. Entries)
   **  Description  :  inserts or updates records in gicl_recovery_acct upon generate recovery
   */
    PROCEDURE set_generated_rec_acct (
        p_recovery_acct_id        GICL_RECOVERY_ACCT.recovery_acct_id%TYPE,
        p_iss_cd                  GICL_RECOVERY_ACCT.iss_cd%TYPE,
        p_rec_acct_year           GICL_RECOVERY_ACCT.rec_acct_year%TYPE,
        p_rec_acct_seq_no         GICL_RECOVERY_ACCT.rec_acct_seq_no%TYPE,
        p_recovery_amt            GICL_RECOVERY_ACCT.recovery_amt%TYPE,
        p_recovery_acct_flag      GICL_RECOVERY_ACCT.recovery_acct_flag%TYPE,
        p_acct_tran_id            GICL_RECOVERY_ACCT.acct_tran_id%TYPE,
        p_tran_date               GICL_RECOVERY_ACCT.tran_date%TYPE,
        p_user_id                 GICL_RECOVERY_ACCT.user_id%TYPE
    ) IS
    BEGIN
        IF p_recovery_acct_flag = 'C' THEN --benjo 08.26.2015 UCPBGEN-SR-19654
            UPDATE gicl_recovery_acct
               SET acct_tran_id = NULL
             WHERE recovery_acct_id = p_recovery_acct_id;
        ELSE
            MERGE INTO gicl_recovery_acct
            USING DUAL ON (recovery_acct_id = p_recovery_acct_id)
                WHEN NOT MATCHED THEN
                    INSERT (
                        recovery_acct_id, iss_cd, rec_acct_year, rec_acct_seq_no, 
                        recovery_amt, recovery_acct_flag, acct_tran_id,
                        tran_date, user_id, last_update
                        )
                    VALUES (
                        p_recovery_acct_id, p_iss_cd, p_rec_acct_year, p_rec_acct_seq_no, 
                        p_recovery_amt, p_recovery_acct_flag, p_acct_tran_id,
                        p_tran_date, nvl(p_user_id, USER), SYSDATE
                        )
                WHEN MATCHED THEN
                    UPDATE SET 
                        iss_cd = p_iss_cd,
                        rec_acct_year = p_rec_acct_year,
                        rec_acct_seq_no = p_rec_acct_seq_no,
                        recovery_amt = p_recovery_amt,
                        recovery_acct_flag = p_recovery_acct_flag,
                        acct_tran_id = p_acct_tran_id,
                        tran_date = p_tran_date,
                        user_id = nvl(p_user_id, USER),
                        last_update = SYSDATE;
        END IF;
    END set_generated_rec_acct;
END GICL_RECOVERY_ACCT_PKG;
/


