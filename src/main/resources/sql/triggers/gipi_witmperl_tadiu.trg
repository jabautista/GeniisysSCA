DROP TRIGGER CPI.GIPI_WITMPERL_TADIU;

CREATE OR REPLACE TRIGGER CPI.GIPI_WITMPERL_TADIU
    AFTER DELETE OR INSERT OR UPDATE ON CPI.GIPI_WITMPERL     FOR EACH ROW
BEGIN

    UPDATE giuw_pol_dist
       SET post_flag = 'O', auto_dist = 'N'
     WHERE EXISTS (SELECT 1
                     FROM giuw_pol_dist 
                    WHERE par_id = :NEW.par_id)
       AND par_id = (SELECT par_id
                       FROM gipi_parlist
                      WHERE par_id = :NEW.par_id
                        AND par_status NOT IN (10, 98, 99));
END;
/


