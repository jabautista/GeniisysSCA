DROP PROCEDURE CPI.POST_FORMS_COMMIT_GIPIS026;

CREATE OR REPLACE PROCEDURE CPI.post_forms_commit_gipis026 (
   p_par_id               gipi_parlist.par_id%TYPE,
   p_pack_par_id          gipi_parlist.pack_par_id%TYPE,
   p_global_pack_par_id   gipi_parlist.pack_par_id%TYPE,
   p_iss_cd               gipi_parlist.iss_cd%TYPE,
   p_item_grp             gipi_winvoice.item_grp%TYPE,
   p_takeup_seq_no        gipi_winvoice.takeup_seq_no%TYPE,
   p_ri_comm_vat          gipi_winvoice.ri_comm_vat%TYPE
)
IS
/*
BEGIN
   IF variables.commit_sw = 'N' AND variables.changed = 'N' THEN
     RETURN;
  END IF;
END;*/
   p_exist       NUMBER                               := 0;
   v_iss_cd      gipi_wpolbas.iss_cd%TYPE;
   v_co_ins_sw   gipi_wpolbas.co_insurance_sw%TYPE;
   v_cnt         NUMBER;
   v_cnt1        NUMBER;
   v_cnt2        NUMBER;
   v_cnt3        NUMBER;
   v_type        gipi_parlist.par_type%TYPE;
   v_param       giis_parameters.param_value_n%TYPE;        ---tonio 10/06/08

   CURSOR a
   IS
      SELECT property
        FROM gipi_winvoice
       WHERE par_id = p_par_id
         AND item_grp = p_item_grp
         AND takeup_seq_no = p_takeup_seq_no;
BEGIN
   FOR a1 IN a
   LOOP
      IF a1.property IS NULL
      THEN
         p_exist := 1;
      ELSE
         NULL;
      END IF;
   END LOOP;

   IF p_exist = 1
   THEN
      UPDATE gipi_parlist
         SET par_status = 5
       WHERE par_id = p_par_id;

      IF p_global_pack_par_id IS NOT NULL
      THEN
         UPDATE gipi_pack_parlist
            SET par_status = 5
          WHERE pack_par_id = p_pack_par_id;
      END IF;
   ELSE
      UPDATE gipi_parlist
         SET par_status = 6
       WHERE par_id = p_par_id;

      IF p_global_pack_par_id IS NOT NULL
      THEN
         UPDATE gipi_pack_parlist
            SET par_status = 6
          WHERE pack_par_id = p_pack_par_id;
      END IF;

      FOR tp IN (SELECT par_type
                   FROM gipi_parlist
                  WHERE par_id = p_par_id)
      LOOP
         v_type := tp.par_type;
      END LOOP;

      IF v_type = 'P'
      THEN
         FOR ins IN (SELECT co_insurance_sw
                       FROM gipi_wpolbas
                      WHERE par_id = p_par_id)
         LOOP
            v_co_ins_sw := ins.co_insurance_sw;
         END LOOP;
      ELSE
         FOR ins IN (SELECT a.co_insurance_sw
                       FROM gipi_polbasic a, gipi_wpolbas b
                      WHERE a.line_cd = b.line_cd
                        AND a.subline_cd = b.subline_cd
                        AND a.iss_cd = b.iss_cd
                        AND a.issue_yy = b.issue_yy
                        AND a.pol_seq_no = b.pol_seq_no
                        AND a.renew_no = b.renew_no
                        AND a.endt_seq_no = 0
                        AND b.par_id = p_par_id)
         LOOP
            v_co_ins_sw := ins.co_insurance_sw;
         END LOOP;
      END IF;

      IF v_co_ins_sw = '2'
      THEN
         pop_main_inv_tax_gipis026 (p_par_id);
      END IF;

      SELECT COUNT (*) cnt
        INTO v_cnt
        FROM gipi_wcomm_invoices
       WHERE par_id = p_par_id;

      SELECT COUNT (*) cnt
        INTO v_cnt1
        FROM gipi_orig_comm_invoice
       WHERE par_id = p_par_id;

      SELECT COUNT (*)
        INTO v_cnt3
        FROM gipi_witem
       WHERE par_id = p_par_id AND rec_flag = 'A';

      FOR pol IN (SELECT param_value_v
                    FROM giis_parameters
                   WHERE param_name = 'REINSURANCE')
      LOOP
         v_iss_cd := pol.param_value_v;
         EXIT;
      END LOOP;
   /*
    IF v_iss_cd = p_iss_cd THEN
       SET_MENU_ITEM_PROPERTY('EDIT_PAR_MENU.POST_PAR',ENABLED,PROPERTY_TRUE);
    ELSE
       IF v_co_ins_sw = '2' THEN
          IF v_cnt1 != 0 THEN
             SET_MENU_ITEM_PROPERTY('EDIT_PAR_MENU.POST_PAR',ENABLED,PROPERTY_TRUE);
          ELSE
             SET_MENU_ITEM_PROPERTY('EDIT_PAR_MENU.POST_PAR',ENABLED,PROPERTY_FALSE);
             SET_MENU_ITEM_PROPERTY('BILL_INFO_MENU.ENTER_COMM_INV',ENABLED,PROPERTY_TRUE);
          END IF;
       ELSE
          IF nvl(variables.v_endt_tax_sw,'N') != 'Y' THEN
             IF v_cnt != 0 THEN
                SET_MENU_ITEM_PROPERTY('EDIT_PAR_MENU.POST_PAR',ENABLED,PROPERTY_TRUE);
             ELSE
                SET_MENU_ITEM_PROPERTY('EDIT_PAR_MENU.POST_PAR',ENABLED,PROPERTY_FALSE);
                SET_MENU_ITEM_PROPERTY('BILL_INFO_MENU.ENTER_COMM_INV',ENABLED,PROPERTY_TRUE);
             END IF;
          ELSE
             IF v_cnt != 0 AND v_cnt3 = 0 THEN
                SET_MENU_ITEM_PROPERTY('EDIT_PAR_MENU.POST_PAR',ENABLED,PROPERTY_TRUE);
             ELSIF v_cnt = 0 AND v_cnt3 != 0 THEN
                SET_MENU_ITEM_PROPERTY('EDIT_PAR_MENU.POST_PAR',ENABLED,PROPERTY_FALSE);
                SET_MENU_ITEM_PROPERTY('BILL_INFO_MENU.ENTER_COMM_INV',ENABLED,PROPERTY_TRUE);
             ELSE
               SET_MENU_ITEM_PROPERTY('EDIT_PAR_MENU.POST_PAR',ENABLED,PROPERTY_TRUE);
                SET_MENU_ITEM_PROPERTY('BILL_INFO_MENU.ENTER_COMM_INV',ENABLED,PROPERTY_TRUE);
             END IF;
          END IF;
       END IF;
    END IF;*/
   END IF;

/*
   BEGIN
     IF :parameter.change_date = 'N' THEN
        do_payt_terms_computation;
     ELSE
        do_payt_terms_computation('2');
     END IF;
     POP_PACKAGE1;
   END;
*/
   BEGIN
      --- created by tonio 10/06/08
      FOR i IN (SELECT param_value_n
                  FROM giis_parameters
                 WHERE param_name = 'OTHER_CHARGES_CODE')
      LOOP
         v_param := i.param_value_n;
      END LOOP;

--------------------------
      FOR c IN (SELECT item_grp, takeup_seq_no
                  FROM gipi_winvoice
                 WHERE par_id = p_par_id)
      LOOP
         IF v_param IS NULL
         THEN                                               ---tonio 10/06/08
            FOR l IN (SELECT SUM (tax_amt) tax
                        FROM gipi_winv_tax
                       WHERE par_id = p_par_id
                         AND item_grp = c.item_grp
                         AND takeup_seq_no = c.takeup_seq_no)
            LOOP
               UPDATE gipi_winvoice
                  SET tax_amt = l.tax
                WHERE par_id = p_par_id
                  AND item_grp = c.item_grp
                  AND takeup_seq_no = c.takeup_seq_no;
            END LOOP;
         END IF;

         IF v_param IS NOT NULL
         THEN                                                ---tonio 10/06/08
            FOR l IN (SELECT SUM (tax_amt) tax
                        FROM gipi_winv_tax
                       WHERE par_id = p_par_id
                         AND item_grp = c.item_grp
                         AND takeup_seq_no = c.takeup_seq_no
                         AND tax_cd <> v_param)
            LOOP
               UPDATE gipi_winvoice
                  SET tax_amt = l.tax
                WHERE par_id = p_par_id
                  AND item_grp = c.item_grp
                  AND takeup_seq_no = c.takeup_seq_no;
            END LOOP;
         END IF;
      END LOOP;
   END;

   IF v_iss_cd = p_iss_cd
   THEN
      UPDATE gipi_winvoice
         SET ri_comm_vat = p_ri_comm_vat
       WHERE par_id = p_par_id;
   END IF;

   adjust_pack_winv_tax_gipis026 (p_pack_par_id);
END;
/


