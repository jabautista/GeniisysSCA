DROP PROCEDURE CPI.GIISS006B_VAL_DEL_GROUP_INFO;

CREATE OR REPLACE PROCEDURE CPI.giiss006b_val_del_group_info (
   p_assd_no    giis_assured_group.assd_no%TYPE,
   p_group_cd   giis_assured_group.group_cd%TYPE
)
IS
-- RBD-06/29/2000 to validate existence of record in
--                transaction tables both main and working
--                (GIPI_WITEM/GIPI_WPOLBAS)
--                (GIPI_ITEM/GIPI_POLBASIC)
BEGIN
   FOR a IN (SELECT DISTINCT par_id
                        FROM gipi_witem
                       WHERE group_cd = p_group_cd)
   LOOP
      FOR b IN (SELECT 'a'
                  FROM gipi_parlist
                 WHERE par_id = a.par_id AND assd_no = p_assd_no)
      LOOP
         raise_application_error
                            (-20001,
                             'Geniisys Exception#I#Cannot delete record. Transaction records with this group already exists.'
                            );
      END LOOP;
   END LOOP;

   FOR a IN (SELECT DISTINCT b.par_id
                        FROM gipi_item a, gipi_polbasic b
                       WHERE a.policy_id = b.policy_id AND group_cd = p_group_cd)
   LOOP
      FOR b IN (SELECT 'a'
                  FROM gipi_parlist
                 WHERE par_id = a.par_id AND assd_no = p_assd_no)
      LOOP
         raise_application_error
                            (-20001,
                             'Geniisys Exception#I#Cannot delete record. Transaction records with this group already exists.'
                            );
      END LOOP;
   END LOOP;
END;
/


