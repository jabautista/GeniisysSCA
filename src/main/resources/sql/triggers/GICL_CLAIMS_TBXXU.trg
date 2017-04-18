CREATE OR REPLACE TRIGGER CPI.GICL_CLAIMS_TBXXU
before INSERT OR UPDATE  OR UPDATE OF clm_stat_cd 
ON CPI.GICL_CLAIMS FOR EACH ROW
BEGIN


 IF ((NVL(:old.clm_stat_cd,'*#') IN  ('CC', 'WD','CD','DN')) AND (NVL(:new.clm_stat_cd,'$%') IN  ('CC', 'WD','CD','DN'))) THEN
 
      FOR y IN (SELECT   *
                    FROM gicl_clm_stat_hist
                   WHERE claim_id = :new.claim_id
                     AND clm_stat_cd NOT IN ('CD', 'DN', 'WD', 'CC')
                ORDER BY clm_stat_dt DESC)
      LOOP
         
         :new.old_stat_cd := y.clm_stat_cd;
         EXIT;
      END LOOP;
     
 END IF;
END;
/