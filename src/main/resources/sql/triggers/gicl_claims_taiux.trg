DROP TRIGGER CPI.GICL_CLAIMS_TAIUX;

CREATE OR REPLACE TRIGGER CPI.GICL_CLAIMS_TAIUX
/* Hardy 02/27/03
** - insert record in table gicl_processor_hist when in_hou_adj column in gicl_claims is updated/insert
** - insert record in table gicl_clm_stat_hist when clm_stat_cd column in gicl_claims is updated/insert
*/
AFTER INSERT  OR UPDATE OF clm_stat_cd, in_hou_adj ON CPI.GICL_CLAIMS FOR EACH ROW
BEGIN
     IF NVL(:old.clm_stat_cd,'*#') != NVL(:new.clm_stat_cd,'$%') THEN
        INSERT INTO gicl_clm_stat_hist(claim_id, clm_stat_cd, clm_stat_dt,
                                       cpi_rec_no, cpi_branch_cd, remarks,
                                       user_id)
        VALUES (:new.claim_id, :new.clm_stat_cd, sysdate,
                :new.cpi_rec_no, :new.cpi_branch_cd, :new.remarks, NVL (giis_users_pkg.app_user, USER));
     END IF;
     IF NVL(:old.in_hou_adj,'*#&@^$(%') != NVL(:new.in_hou_adj,'$(@&$*$!') THEN
        INSERT INTO GICL_PROCESSOR_HIST(claim_id, in_hou_adj, user_id, last_update)
        VALUES (:new.claim_id, :new.in_hou_adj, NVL (giis_users_pkg.app_user, USER), sysdate);
     END IF;
END;
/


