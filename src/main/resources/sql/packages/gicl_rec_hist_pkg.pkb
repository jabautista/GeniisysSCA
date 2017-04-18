CREATE OR REPLACE PACKAGE BODY CPI.gicl_rec_hist_pkg
AS
    /*
    **  Created by   :  Niknok Orio 
    **  Date Created :  12.13.2010 
    **  Reference By : GICLS250 - Claims Listing Per Policy
    **  Description :  getting recovery history details 
    */
    FUNCTION get_gicl_rec_hist(
        p_recovery_id           gicl_rec_hist.recovery_id%TYPE
        )
    RETURN gicl_rec_hist_tab PIPELINED IS
      v_list        gicl_rec_hist_type;
    BEGIN       
        FOR i IN (SELECT a.recovery_id, a.rec_hist_no, a.rec_stat_cd,
                         a.remarks, a.cpi_rec_no, a.cpi_branch_cd, 
                         a.user_id, a.last_update, nvl(b.rec_stat_desc,DECODE(a.rec_stat_cd,'CC','CANCELED','CD','CLOSED','WO','WRITTEN OFF','IN PROGRESS')) rec_stat_desc
                    FROM gicl_rec_hist a, giis_recovery_status b
                   WHERE a.rec_stat_cd = b.rec_stat_cd(+) 
                     AND a.recovery_id = p_recovery_id)
        LOOP
            v_list.recovery_id          := i.recovery_id;
            v_list.rec_hist_no          := i.rec_hist_no;
            v_list.rec_stat_cd          := i.rec_stat_cd;
            v_list.remarks              := i.remarks;
            v_list.cpi_rec_no           := i.cpi_rec_no;
            v_list.cpi_branch_cd        := i.cpi_branch_cd;
            v_list.user_id              := i.user_id;
            v_list.last_update          := i.last_update;
            v_list.dsp_rec_stat_desc    := i.rec_stat_desc;
            PIPE ROW(v_list);
        END LOOP;
      RETURN;
    END;
    
    /*
    **  Created by   :  Niknok Orio 
    **  Date Created :  03.29.2012 
    **  Reference By : GICLS025 - Recovery Information 
    **  Description :  delete records  
    */    
    PROCEDURE del_gicl_rec_hist(
        p_recovery_id       gicl_rec_hist.recovery_id%TYPE,
        p_rec_hist_no       gicl_rec_hist.rec_hist_no%TYPE
        ) IS
    BEGIN
        DELETE FROM gicl_rec_hist
              WHERE recovery_id = p_recovery_id
                AND rec_hist_no = p_rec_hist_no;
    END;    
    
    /*
    **  Created by   :  Niknok Orio 
    **  Date Created :  03.29.2012 
    **  Reference By : GICLS025 - Recovery Information 
    **  Description :  insert/update records  
    */  
    PROCEDURE set_gicl_rec_hst(
        p_recovery_id         gicl_rec_hist.recovery_id%TYPE,
        p_rec_hist_no         gicl_rec_hist.rec_hist_no%TYPE,
        p_rec_stat_cd         gicl_rec_hist.rec_stat_cd%TYPE,
        p_remarks             gicl_rec_hist.remarks%TYPE,
        p_cpi_rec_no          gicl_rec_hist.cpi_rec_no%TYPE,
        p_cpi_branch_cd       gicl_rec_hist.cpi_branch_cd%TYPE,
        p_user_id             gicl_rec_hist.user_id%TYPE,
        p_last_update         gicl_rec_hist.last_update%TYPE
        )
    IS
        v_rec_hist_no gicl_rec_hist.rec_hist_no%TYPE;
    BEGIN
    
        IF p_rec_hist_no IS NULL THEN
            SELECT NVL(MAX (rec_hist_no) + 1, 1)
              INTO v_rec_hist_no
              FROM gicl_rec_hist
             WHERE recovery_id = p_recovery_id;
        ELSE
           v_rec_hist_no := p_rec_hist_no;     
        END IF;
    
    
        MERGE INTO gicl_rec_hist
             USING dual
                ON (recovery_id = p_recovery_id
                AND rec_hist_no = v_rec_hist_no)
        WHEN NOT MATCHED THEN
            INSERT (recovery_id, rec_hist_no, rec_stat_cd,
                    remarks, cpi_rec_no, cpi_branch_cd, 
                    user_id, last_update)
            VALUES (p_recovery_id, v_rec_hist_no, p_rec_stat_cd,
                    p_remarks, p_cpi_rec_no, p_cpi_branch_cd, 
                    giis_users_pkg.app_user, SYSDATE)
        WHEN MATCHED THEN
            UPDATE SET  
                rec_stat_cd         = p_rec_stat_cd,
                remarks             = p_remarks,
                cpi_rec_no          = p_cpi_rec_no,
                cpi_branch_cd       = p_cpi_branch_cd,
                user_id             = giis_users_pkg.app_user,
                last_update         = SYSDATE; 
    END;    
    
END gicl_rec_hist_pkg;
/


