CREATE OR REPLACE PACKAGE BODY CPI.gicl_recovery_payor_pkg
AS   
    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  10-07-2010 
    **  Reference By : (GIACS010 - Direct Trans - Loss Recoveries)  
    **  Description  :  PAYOR_RG record group 
    */ 
    FUNCTION get_recovery_payor_list
    RETURN recovery_payor_list_tab PIPELINED IS
        v_list recovery_payor_list_type;
    BEGIN
        FOR rec IN (SELECT a.payor_class_cd, b.class_desc, a.payor_cd,
                           DECODE (c.payee_first_name,
                                   NULL, c.payee_last_name,
                                      c.payee_last_name
                                   || ', '
                                   || c.payee_first_name
                                   || ' '
                                   || c.payee_middle_name
                                  ) payor_name,
                           a.claim_id, a.recovery_id      
                      FROM gicl_recovery_payor a, giis_payee_class b, giis_payees c
                     WHERE a.payor_class_cd = b.payee_class_cd
                       AND a.payor_cd = c.payee_no
                       AND a.payor_class_cd = c.payee_class_cd
                       AND b.payee_class_cd = c.payee_class_cd)
        LOOP
            v_list.payor_class_cd   := rec.payor_class_cd;
            v_list.class_desc       := rec.class_desc;
            v_list.payor_cd         := rec.payor_cd;
            v_list.payor_name       := rec.payor_name;
            v_list.claim_id         := rec.claim_id;
            v_list.recovery_id      := rec.recovery_id;
        PIPE ROW(v_list);
        END LOOP;
    RETURN;
    END;    

    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  12-13-2011 
    **  Reference By : (GICLS250 - Claims Listing Per Policy)  
    **                 (GICLS025 - Recovery Information)  
    **  Description  :  get recovery payor 
    */ 
    FUNCTION get_gicl_recovery_payor(
        p_claim_id          gicl_recovery_payor.claim_id%TYPE,
        p_recovery_id       gicl_recovery_payor.recovery_id%TYPE
        )
    RETURN recovery_payor_list_tab PIPELINED IS
        v_list recovery_payor_list_type;
    BEGIN
        FOR rec IN (SELECT a.payor_class_cd, b.class_desc, a.payor_cd,
                           DECODE (c.payee_first_name,
                                   NULL, c.payee_last_name,
                                      c.payee_last_name
                                   || ', '
                                   || c.payee_first_name
                                   || ' '
                                   || c.payee_middle_name
                                  ) payor_name,
                           a.claim_id, a.recovery_id, a.recovered_amt  
                      FROM gicl_recovery_payor a, giis_payee_class b, giis_payees c
                     WHERE a.payor_class_cd = b.payee_class_cd
                       AND a.payor_cd = c.payee_no
                       AND a.payor_class_cd = c.payee_class_cd
                       AND b.payee_class_cd = c.payee_class_cd
                       AND a.claim_id = p_claim_id
                       AND a.recovery_id = p_recovery_id)
        LOOP
            v_list.payor_class_cd   := rec.payor_class_cd;
            v_list.class_desc       := rec.class_desc;
            v_list.payor_cd         := rec.payor_cd;
            v_list.payor_name       := rec.payor_name;
            v_list.claim_id         := rec.claim_id;
            v_list.recovery_id      := rec.recovery_id;
            v_list.recovered_amt    := rec.recovered_amt;
        PIPE ROW(v_list);
        END LOOP;
    RETURN;
    END;

    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  03.26.2012 
    **  Reference By :  (GICLS025 - Recovery Information)  
    **  Description  :  delete recovery payor 
    */ 
    PROCEDURE del_gicl_recovery_payor(
        p_recovery_id           gicl_recovery_payor.recovery_id%TYPE,
        p_claim_id              gicl_recovery_payor.claim_id%TYPE,
        p_payor_class_cd        gicl_recovery_payor.payor_class_cd%TYPE,   
        p_payor_cd              gicl_recovery_payor.payor_cd%TYPE
        ) IS
    BEGIN
        DELETE FROM gicl_recovery_payor
              WHERE recovery_id = p_recovery_id
                AND claim_id = p_claim_id
                AND payor_class_cd = p_payor_class_cd
                AND payor_cd = p_payor_cd;
    END;    

    /*
    **  Created by   :  Jerome Orio 
    **  Date Created :  03.26.2012 
    **  Reference By :  (GICLS025 - Recovery Information)  
    **  Description  :  delete recovery payor 
    */ 
    PROCEDURE set_gicl_recovery_payor(
        p_recovery_id         gicl_recovery_payor.recovery_id%TYPE,
        p_claim_id            gicl_recovery_payor.claim_id%TYPE,
        p_payor_class_cd      gicl_recovery_payor.payor_class_cd%TYPE, 
        p_payor_cd            gicl_recovery_payor.payor_cd%TYPE, 
        p_recovered_amt       gicl_recovery_payor.recovered_amt%TYPE,
        p_cpi_rec_no          gicl_recovery_payor.cpi_rec_no%TYPE,
        p_cpi_branch_cd       gicl_recovery_payor.cpi_branch_cd%TYPE,    
        p_user_id             gicl_recovery_payor.user_id%TYPE,
        p_last_update         gicl_recovery_payor.last_update%TYPE
        ) IS
    BEGIN
        MERGE INTO gicl_recovery_payor
             USING dual
                ON (recovery_id = p_recovery_id
                AND claim_id = p_claim_id
                AND payor_class_cd = p_payor_class_cd
                AND payor_cd = p_payor_cd)
        WHEN NOT MATCHED THEN
            INSERT (recovery_id, claim_id, payor_class_cd,
                    payor_cd, recovered_amt, cpi_rec_no,    
                    cpi_branch_cd, user_id, last_update)
            VALUES (p_recovery_id, p_claim_id, p_payor_class_cd,
                    p_payor_cd, p_recovered_amt, p_cpi_rec_no,    
                    p_cpi_branch_cd, giis_users_pkg.app_user, SYSDATE)
        WHEN MATCHED THEN
            UPDATE SET
                recovered_amt   = p_recovered_amt,
                cpi_rec_no      = p_cpi_rec_no,
                cpi_branch_cd   = p_cpi_branch_cd,    
                user_id         = giis_users_pkg.app_user,
                last_update     = SYSDATE;                    
    END;    
    
END;
/


