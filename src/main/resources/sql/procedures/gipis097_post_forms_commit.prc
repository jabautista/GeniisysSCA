DROP PROCEDURE CPI.GIPIS097_POST_FORMS_COMMIT;

CREATE OR REPLACE PROCEDURE CPI.gipis097_post_forms_commit (
   p_par_id                       gipi_parlist.par_id%TYPE, 
   p_user_id                      giis_users.user_id%TYPE,
   p_item_no                      gipi_witem.item_no%TYPE,
   p_item_tsi_amt                 gipi_witem.tsi_amt%TYPE,
   p_item_ann_tsi_amt             gipi_witem.ann_tsi_amt%TYPE,
   p_item_prem_amt                gipi_witem.prem_amt%TYPE,
   p_item_ann_prem_amt            gipi_witem.prem_amt%TYPE,
   p_update_sw      IN OUT   VARCHAR2,
   p_var_deldisc_sw      IN OUT   VARCHAR2,
   p_var_negate_item     IN OUT   VARCHAR2
)
IS
BEGIN
   DECLARE
      item                  NUMBER;
      itmperl               NUMBER;
      v_count               NUMBER                                      := 1;
      v_count1              NUMBER;
      v_exist               VARCHAR2 (1)                                := 'N';
      v_exist1              VARCHAR2 (1)                                := 'N';
      p_exist               VARCHAR2 (1)                                := 'N';
      endt_tax              gipi_endttext.endt_tax%TYPE;
      v_pack_pol_flag       gipi_wpolbas.pack_pol_flag%TYPE;
      v_prov_prem_pct       gipi_wpolbas.prov_prem_pct%TYPE;
      v_prov_prem_tag       gipi_wpolbas.prov_prem_tag%TYPE;
      v_pack_par_id         gipi_wpolbas.pack_par_id%TYPE;
      v_pack_line_cd        gipi_wpack_line_subline.pack_line_cd%TYPE;
      v_line_cd             gipi_wpolbas.line_cd%TYPE;
      v_iss_cd              gipi_wpolbas.iss_cd%TYPE;
      v_item_tsi_amt        gipi_witem.tsi_amt%TYPE := 0;
      v_item_ann_tsi_amt    gipi_witem.ann_tsi_amt%TYPE := 0;
      v_item_prem_amt       gipi_witem.prem_amt%TYPE := 0; 
      v_item_ann_prem_amt   gipi_witem.prem_amt%TYPE := 0;
      p_msg_alert           VARCHAR2 (2000);
  	  v_cond			VARCHAR2 (2)								:= 'N';--added by steven 9/10/2012      
   BEGIN
      FOR i IN (SELECT pack_line_cd
                  FROM gipi_wpack_line_subline
                 WHERE par_id = p_par_id)
      LOOP
         v_pack_line_cd := i.pack_line_cd;
         EXIT;
      END LOOP;

      SELECT pack_pol_flag, prov_prem_tag, prov_prem_pct, pack_par_id, line_cd, iss_cd
        INTO v_pack_pol_flag, v_prov_prem_tag, v_prov_prem_pct, v_pack_par_id, v_line_cd, v_iss_cd
        FROM gipi_wpolbas
       WHERE par_id = p_par_id;
 
----      -- added by gmi 12/21/05
--      IF p_update_sw = 'Y'
--      THEN
--         UPDATE gipi_witem
--            SET tsi_amt = p_item_tsi_amt,
--                ann_tsi_amt = p_item_ann_tsi_amt,
--                prem_amt = p_item_prem_amt,
--                ann_prem_amt = p_item_ann_prem_amt
--          WHERE par_id = p_par_id AND item_no = p_item_no;

--          p_update_sw := 'N';
--      ELSE
--          FOR x IN(
--            SELECT item_no
--              FROM gipi_witem
--             WHERE par_id = p_par_id)
--          LOOP
--              SELECT SUM (prem_amt), SUM (ann_prem_amt)
--                INTO v_item_prem_amt, v_item_ann_prem_amt
--                FROM gipi_witmperl
--               WHERE par_id = p_par_id AND item_no = x.item_no;

--              SELECT SUM (tsi_amt), SUM (ann_tsi_amt)
--                INTO v_item_tsi_amt, v_item_ann_tsi_amt
--                FROM gipi_witmperl a, giis_peril b
--               WHERE a.par_id = p_par_id AND a.item_no = x.item_no AND b.peril_cd = a.peril_cd AND b.line_cd = v_line_cd
--                 AND b.peril_type = 'B';  

--              UPDATE gipi_witem
--                 SET tsi_amt = NVL(v_item_tsi_amt, 0),                 
--                     prem_amt = NVL(v_item_prem_amt, 0),
--                     ann_tsi_amt = NVL(v_item_ann_tsi_amt, ann_tsi_amt),
--                     ann_prem_amt = NVL(v_item_ann_prem_amt, ann_prem_amt)
--               WHERE par_id = p_par_id AND item_no = x.item_no;      
--          END LOOP;      
--      END IF;          
      
      --*--
      --Added by Iris Bordey (09.03.2002)
      --Require peril before saving.
      FOR a IN (SELECT '1'
                  FROM gipi_witmperl
                 WHERE par_id = p_par_id AND item_no = p_item_no)
      --gmi 12/21/05
      LOOP
         p_exist := 'Y';
         EXIT;
      END LOOP;

      IF p_exist = 'N'
      THEN
         NULL;
      --Msg_alert('Peril entry is required.', 'I', TRUE);
      ELSE
         --reset p_exist.
         p_exist := 'N';
      END IF;

      --*--
      FOR a IN (SELECT endt_tax
                  FROM gipi_wendttext
                 WHERE par_id = p_par_id)
      LOOP
         endt_tax := a.endt_tax;
         EXIT;
      END LOOP;

      --BETH 032399
      IF p_var_deldisc_sw = 'Y'
      THEN
         --delete_other_discount (p_par_id);
         p_var_deldisc_sw := 'N';
      END IF;

      --update_gipi_wpolbas2 (p_par_id, p_var_negate_item); -- andrew - 11.22.2011 - comment out, replaced with update_gipi_wpolbas
      update_gipi_wpolbas (p_par_id, v_prov_prem_pct, v_prov_prem_tag);

      --A.R.C. 09.11.2006
      IF v_pack_par_id IS NOT NULL
      THEN
         gipis097_upd_gipi_pack_wpolbas (v_pack_par_id);
      END IF;

      delete_bill (p_par_id);
      gipis039_populate_orig_itmperl (p_par_id);

      IF v_pack_pol_flag = 'Y'
      THEN
--	  	FOR i IN (SELECT par_id		-- added by steven 9/10/2012
--		            FROM gipi_parlist
--				   WHERE pack_par_id = v_pack_par_id)
--		LOOP
--			FOR j IN (SELECT 'Y' condition
--						FROM gipi_witmperl
--					   WHERE par_id = i.par_id)
--			LOOP
--			    v_cond := j.condition;
--			END LOOP;
--	    END LOOP;
--        
--		IF v_cond = 'N' THEN
		    DELETE FROM GIPI_PACK_WINVPERL
			 WHERE pack_par_id = v_pack_par_id;
					  
			DELETE FROM GIPI_PACK_WINVOICE
			 WHERE pack_par_id = v_pack_par_id;
	    --END IF;
			
        FOR a IN (SELECT '1'
                     FROM gipi_witmperl
                    WHERE par_id = p_par_id)
        LOOP
            create_winvoice (0, 0, 0, p_par_id, v_line_cd, v_iss_cd);
            -- modified by aivhie 120301
            v_cond := 'Y';
            EXIT;
        END LOOP;
        
        IF v_cond <> 'Y' THEN
            FOR var IN (SELECT DISTINCT par.par_id, par.line_cd, par.iss_cd
                          FROM gipi_parlist par,
                               gipi_witmperl peril  
                         WHERE par.pack_par_id = 10539
                           AND par.par_id = peril.par_id)
            LOOP     
               create_winvoice (0, 0, 0, var.par_id, var.line_cd, var.iss_cd);
            END LOOP;
        END IF;
      ELSE
         FOR a IN (SELECT '1'
                     FROM gipi_witmperl
                    WHERE par_id = p_par_id)
         LOOP
            create_winvoice (0, 0, 0, p_par_id, v_line_cd, v_iss_cd);
            -- modified by aivhie 120301
            p_exist := 'Y';
            EXIT;
         END LOOP;

         IF NVL (endt_tax, 'N') = 'Y' AND p_exist = 'N'
         THEN
            NULL;
            create_winvoice1 (p_par_id, v_line_cd, v_iss_cd, p_msg_alert);
         --gipis097_create_winvoice1 (p_par_id, v_line_cd, v_iss_cd);
         END IF;
      END IF;

      cr_bill_dist.get_tsi (p_par_id);

      -- BETH 11/19/98 modified update of par status
      FOR a1 IN (SELECT b480.item_no item
                   FROM gipi_witem b480
                  WHERE b480.par_id = p_par_id AND b480.rec_flag = 'A')
      LOOP
         v_count := 1;
         v_exist := 'Y';

         FOR a2 IN (SELECT 1
                      FROM gipi_witmperl b490
                     WHERE b490.par_id = p_par_id AND b490.item_no = a1.item)
         LOOP
            v_count := 0;
            EXIT;
         END LOOP;

         IF v_count = 1
         THEN
            EXIT;
         END IF;
      END LOOP;

      IF v_exist = 'N'
      THEN
         FOR a1 IN (SELECT b480.item_no item
                      FROM gipi_witem b480
                     WHERE b480.par_id = p_par_id AND b480.rec_flag = 'C')
         LOOP
            v_exist := 'Y';

            FOR a2 IN (SELECT 1
                         FROM gipi_witmperl b490
                        WHERE b490.par_id = p_par_id AND b490.item_no = a1.item)
            LOOP
               v_count := 0;
               EXIT;
            END LOOP;
         END LOOP;
      END IF;

      insert_parhist (p_par_id, p_user_id);

      --A.R.C. 08.01.2006
      IF v_pack_par_id IS NOT NULL
      THEN
         IF NVL (v_count, 0) = 0
         THEN
            UPDATE gipi_parlist
               SET par_status = 5
             WHERE par_id = p_par_id;

            UPDATE gipi_pack_parlist
               SET par_status = 5
             WHERE pack_par_id = v_pack_par_id;
--            SET_MENU_ITEM_PROPERTY ('EDIT_PAR_MENU.DIST',
--                                    enabled,
--                                    property_true
--                                   );
--            SET_MENU_ITEM_PROPERTY ('EDIT_PAR_MENU.BILL_INFO',
--                                    enabled,
--                                    property_true
--                                   );
--            SET_MENU_ITEM_PROPERTY ('BILL_INFO_MENU.ENTER_BILL_PREMIUMS',
--                                    enabled,
--                                    property_true
--                                   );
--            SET_MENU_ITEM_PROPERTY ('BILL_INFO_MENU.ENTER_COMM_INV',
--                                    enabled,
--                                    property_false
--                                   );
--            SET_MENU_ITEM_PROPERTY ('EDIT_PAR_MENU.POST_PAR',
--                                    enabled,
--                                    property_false
--                                   );
         ELSE
            FOR v IN (SELECT COUNT (*) COUNT
                        FROM gipi_witem
                       WHERE par_id = p_par_id AND rec_flag = 'A')
            LOOP
               v_count1 := v.COUNT;
               EXIT;
            END LOOP;

            FOR n IN (SELECT 1
                        FROM gipi_witmperl
                       WHERE par_id = p_par_id)
            LOOP
               v_exist1 := 'Y';
               EXIT;
            END LOOP;

            UPDATE gipi_parlist
               SET par_status = 4
             WHERE par_id = p_par_id;

            UPDATE gipi_pack_parlist
               SET par_status = 4
             WHERE pack_par_id = v_pack_par_id;
--            IF NVL (endt_tax, 'N') = 'Y' AND v_count1 = 0 AND v_exist1 = 'N'
--            THEN
--               SET_MENU_ITEM_PROPERTY ('EDIT_PAR_MENU.BILL_INFO',
--                                       enabled,
--                                       property_true
--                                      );
--            ELSE
--               SET_MENU_ITEM_PROPERTY ('EDIT_PAR_MENU.BILL_INFO',
--                                       enabled,
--                                       property_false
--                                      );
--            END IF;

         --            SET_MENU_ITEM_PROPERTY ('EDIT_PAR_MENU.DIST',
--                                    enabled,
--                                    property_false
--                                   );

         /*    BETH 120298 enable posting if items are all tagged  'C' and there are no
                           existing peril for any item
            */
--            IF v_exist = 'N' AND v_exist1 = 'N'
--            THEN
--               SET_MENU_ITEM_PROPERTY ('EDIT_PAR_MENU.POST_PAR',
--                                       enabled,
--                                       property_true
--                                      );
--            ELSE
--               SET_MENU_ITEM_PROPERTY ('EDIT_PAR_MENU.POST_PAR',
--                                       enabled,
--                                       property_false
--                                      );
--            END IF;
         END IF;
      ELSE                                                                                         --:b240.pack_par_id IS NOT NULL
         IF NVL (v_count, 0) = 0
         THEN
            UPDATE gipi_parlist
               SET par_status = 5
             WHERE par_id = p_par_id;
--         SET_MENU_ITEM_PROPERTY('EDIT_PAR_MENU.DIST',ENABLED,PROPERTY_TRUE);
--         SET_MENU_ITEM_PROPERTY('EDIT_PAR_MENU.BILL_INFO',ENABLED,PROPERTY_TRUE);
--         SET_MENU_ITEM_PROPERTY('BILL_INFO_MENU.ENTER_BILL_PREMIUMS',ENABLED,PROPERTY_TRUE);
--         SET_MENU_ITEM_PROPERTY('BILL_INFO_MENU.ENTER_COMM_INV',ENABLED,PROPERTY_FALSE);
--         SET_MENU_ITEM_PROPERTY('EDIT_PAR_MENU.POST_PAR',ENABLED,PROPERTY_FALSE);
         ELSE
            FOR v IN (SELECT COUNT (*) COUNT
                        FROM gipi_witem
                       WHERE par_id = p_par_id AND rec_flag = 'A')
            LOOP
               v_count1 := v.COUNT;
               EXIT;
            END LOOP;

            FOR n IN (SELECT 1
                        FROM gipi_witmperl
                       WHERE par_id = p_par_id)
            LOOP
               v_exist1 := 'Y';
               EXIT;
            END LOOP;

            UPDATE gipi_parlist
               SET par_status = 4
             WHERE par_id = p_par_id;
--            IF NVL (endt_tax, 'N') = 'Y' AND v_count1 = 0 AND v_exist1 = 'N'
--            THEN
--               SET_MENU_ITEM_PROPERTY ('EDIT_PAR_MENU.BILL_INFO',
--                                       enabled,
--                                       property_true
--                                      );
--            ELSE
--               SET_MENU_ITEM_PROPERTY ('EDIT_PAR_MENU.BILL_INFO',
--                                       enabled,
--                                       property_false
--                                      );
--            END IF;

         --            SET_MENU_ITEM_PROPERTY ('EDIT_PAR_MENU.DIST',
--                                    enabled,
--                                    property_false
--                                   );

         /*    BETH 120298 enable posting if items are all tagged  'C' and there are no
                           existing peril for any item
            */
--            IF v_exist = 'N' AND v_exist1 = 'N'
--            THEN
--               SET_MENU_ITEM_PROPERTY ('EDIT_PAR_MENU.POST_PAR',
--                                       enabled,
--                                       property_true
--                                      );
--            ELSE
--               SET_MENU_ITEM_PROPERTY ('EDIT_PAR_MENU.POST_PAR',
--                                       enabled,
--                                       property_false
--                                      );
--            END IF;
         END IF;
      END IF;
   --:b240.pack_par_id IS NOT NULL

   --      FOR a1 IN (SELECT par_id,
--                           line_cd
--                        || '-'
--                        || iss_cd
--                        || '-'
--                        || LTRIM (TO_CHAR (par_yy, '09'))
--                        || '-'
--                        || LTRIM (TO_CHAR (par_seq_no, '0999999'))
--                        || '-'
--                        || LTRIM (TO_CHAR (quote_seq_no, '09')) par_no
--                   FROM gipi_parlist
--                  WHERE par_status >= '5'
--                    AND par_status < '10'
--                    AND par_id = p_par_id
--                    AND line_cd =
--                           DECODE (check_user_per_line1 (line_cd,
--                                                         v_iss_cd,
--                                                         :control.module
--                                                       ),
--                                   1, line_cd,
--                                   NULL
--                                  )
--                    AND iss_cd =
--                           DECODE (check_user_per_iss_cd1 (v_line_cd,
--                                                          iss_cd,
--                                                          :control.module
--                                                         ),
--                                   1, iss_cd,
--                                   NULL
--                                  ))
--      LOOP
--         FOR c1 IN (SELECT b.userid, d.event_desc
--                      FROM giis_events_column c,
--                           giis_event_mod_users b,
--                           giis_event_modules a,
--                           giis_events d
--                     WHERE 1 = 1
--                       AND c.event_cd = a.event_cd
--                       AND c.event_mod_cd = a.event_mod_cd
--                       AND b.event_mod_cd = a.event_mod_cd
--                       AND b.userid <> USER
--                       AND a.module_id = 'GIPIS097'
--                       AND a.event_cd = d.event_cd)
--         LOOP
--            create_transfer_workflow_rec
--                                (NULL,
--                                 GET_APPLICATION_PROPERTY (current_form_name),
--                                 c1.userid,
--                                 a1.par_id,
--                                 c1.event_desc || ' ' || a1.par_no
--                                );
--         END LOOP;
--      END LOOP;
   END;
END;
/


