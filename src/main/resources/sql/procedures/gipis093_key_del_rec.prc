DROP PROCEDURE CPI.GIPIS093_KEY_DEL_REC;

CREATE OR REPLACE PROCEDURE CPI.gipis093_key_del_rec( p_par_id            gipi_wpack_line_subline.par_id%TYPE,
   p_line_cd   gipi_wpack_line_subline.line_cd%TYPE,
   p_iss_cd   varchar2,
   p_pack_line_cd      gipi_wpack_line_subline.pack_line_cd%TYPE,
   p_pack_subline_cd   gipi_wpack_line_subline.pack_subline_cd%TYPE,
   p_has_perils varchar2)
   
   IS
    v_exist   VARCHAR2(1) := 'N';   
   BEGIN
    -- forms del_addtl_tables
      gipis093_del_addtl_tables (p_par_id, p_pack_line_cd, p_pack_subline_cd);
      -- FORMS DEL_TABLEs
      gipis093_del_tables  (p_par_id, p_pack_line_cd, p_pack_subline_cd);
      
      -- delete perils if existing. 
      IF p_has_perils = 'Y'THEN
       FOR A1 IN (
          SELECT   item_no
            FROM   gipi_witem
           WHERE   par_id          = p_par_id
             AND   pack_line_cd    = p_pack_line_cd
             AND   pack_subline_cd = p_pack_subline_cd )
        LOOP    
            DELETE FROM gipi_witmperl
             WHERE par_id   =  p_par_id
               AND item_no  =  A1.item_no;
               
          v_exist := 'N'; --added by christian 12132012  
          FOR A2 IN ( SELECT 1
                        FROM gipi_witmperl
                       WHERE par_id          = p_par_id)LOOP   
            v_exist := 'Y';             
            --A.R.C. 06.06.2006    
            create_winvoice(0,0,0,p_par_id,p_line_cd,p_iss_cd);
          END LOOP;             
          IF v_exist != 'Y' THEN 
             DELETE FROM gipi_winstallment
              WHERE  par_id  =  p_par_id;
             DELETE FROM gipi_wcomm_inv_perils
              WHERE  par_id  =  p_par_id;
             DELETE FROM gipi_wcomm_invoices
              WHERE  par_id  =  p_par_id;
             DELETE FROM gipi_winvperl
              WHERE  par_id  = p_par_id;
             DELETE FROM gipi_winv_tax
              WHERE  par_id  =  p_par_id;
             DELETE FROM gipi_wpackage_inv_tax
              WHERE  par_id  =  p_par_id;
             DELETE FROM gipi_winvoice
              WHERE  par_id  =  p_par_id;
          END IF;    
        END LOOP; 
      END IF;
      
      --del_items
      DELETE  gipi_witem
       WHERE  par_id          = p_par_id
        AND   pack_line_cd    = p_pack_line_cd
        AND   pack_subline_cd = p_pack_subline_cd; 
        
        -- delete _pack
     gipis093_del_pack(p_par_id, p_iss_cd);
     
     -- updates parlist
     UPDATE gipi_parlist
         SET par_status = 99
       WHERE par_id = p_par_id; 
   
   END;
/


