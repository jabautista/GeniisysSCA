DROP PROCEDURE CPI.POST_FORMS_COMMIT_D_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.Post_Forms_Commit_D_Gipis002
  (b240_par_id IN NUMBER,
   b540_assd_no IN NUMBER) IS
BEGIN
  FOR B IN(SELECT assd_no
               FROM GIPI_PARLIST
              WHERE par_id = b240_par_id)
    LOOP
     IF b.assd_no != b540_assd_no THEN
       UPDATE GIPI_PARLIST
          SET assd_no = b540_assd_no
        WHERE par_id = b240_par_id;
        
         --added edgar to update gipi_winvoice "insured" column
         FOR assured IN (SELECT assd_name
                           FROM giis_assured
                          WHERE assd_no = b540_assd_no)
         LOOP
            UPDATE gipi_winvoice
               SET insured = SUBSTR(assured.assd_name,1,50)
             WHERE par_id = b240_par_id;
         END LOOP;       
         
         UPDATE giuw_pol_dist
            SET dist_flag = '1',
                auto_dist = 'N'
          WHERE par_id = b240_par_id;
          
         FOR dist IN (SELECT dist_no
                        FROM giuw_pol_dist
                       WHERE par_id = b240_par_id)
         LOOP
            GIUW_POL_DIST_PKG.delete_dist_master_tables(dist.dist_no);
            GIUW_POL_DIST_FINAL_PKG.DELETE_DIST_WORKING_TABLES_017(dist.dist_no);
         END LOOP;
     END IF;
    END LOOP;

END;
/


