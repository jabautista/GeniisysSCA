DROP PROCEDURE CPI.VALIDATE_PAR_STATUS_NEW2;

CREATE OR REPLACE PROCEDURE CPI.validate_par_status_new2(p_par_id in NUMBER) IS
  CURSOR A IS  SELECT  par_status
                 FROM  gipi_parlist
                WHERE  par_id = p_par_id;
  CURSOR B IS  SELECT  item_no
                 FROM  gipi_witem
                WHERE  par_id = p_par_id;
  CURSOR C(p_item_no  gipi_witem.item_no%TYPE) IS
               SELECT  distinct item_no
                 FROM  gipi_witem
                WHERE  par_id = p_par_id
                  AND  item_no = p_item_no;
  CURSOR D IS  SELECT  item_grp
                 FROM  gipi_witem
                WHERE  par_id = p_par_id;
  CURSOR E(p_item_grp  gipi_witem.item_grp%TYPE) IS
               SELECT  item_grp
                 FROM  gipi_witem
                WHERE  par_id = p_par_id
                  AND  item_no = p_item_grp;
  peril_menu_itm       menuitem := FIND_MENU_ITEM('EDIT_PAR_MENU.PERIL_INFO');
  bill_menu_itm        menuitem := FIND_MENU_ITEM('EDIT_PAR_MENU.BILL_INFO');
  dist_menu_itm        menuitem := FIND_MENU_ITEM('EDIT_PAR_MENU.DIST');
  post_menu_itm        menuitem := FIND_MENU_ITEM('EDIT_PAR_MENU.POST_PAR');
  v_par_status         gipi_parlist.par_status%TYPE := 0;
  v_item_item          gipi_witem.item_no%TYPE      := 0;
  v_peril_item         gipi_witmperl.item_no%TYPE   := 0;
  v_item_grp           gipi_witem.item_grp%TYPE     := 0;
  v_inv_grp            gipi_winvoice.item_grp%TYPE  := 0;
  v_no_item            VARCHAR2(1) := 'Y';
  v_no_peril           VARCHAR2(1) := 'Y';
  v_no_grp             VARCHAR2(1) := 'Y';
  v_no_invoice         VARCHAR2(1) := 'Y';
  v_count1             NUMBER      := 0;
  v_count2             NUMBER      := 0;
  v_count3             NUMBER      := 0;
  v_count4             NUMBER      := 0;
 PROCEDURE PAR_STATUS3 IS
  BEGIN
    SET_MENU_ITEM_PROPERTY(peril_menu_itm, ENABLED, PROPERTY_FALSE);
    SET_MENU_ITEM_PROPERTY(bill_menu_itm, ENABLED, PROPERTY_FALSE);
    SET_MENU_ITEM_PROPERTY(dist_menu_itm, ENABLED, PROPERTY_FALSE);
    SET_MENU_ITEM_PROPERTY(post_menu_itm, ENABLED, PROPERTY_FALSE);
  END;
  /* Enable/Disable menu items when the par status = 4 */
  PROCEDURE PAR_STATUS4 IS
  BEGIN
    SET_MENU_ITEM_PROPERTY(peril_menu_itm, ENABLED, PROPERTY_TRUE);
    SET_MENU_ITEM_PROPERTY(bill_menu_itm, ENABLED, PROPERTY_FALSE);
    SET_MENU_ITEM_PROPERTY(dist_menu_itm, ENABLED, PROPERTY_FALSE);
    SET_MENU_ITEM_PROPERTY(post_menu_itm, ENABLED, PROPERTY_FALSE);
  END;
  /* Enable/Disable menu items when the par status = 5 */
  PROCEDURE PAR_STATUS5 IS
  BEGIN
    SET_MENU_ITEM_PROPERTY(peril_menu_itm, ENABLED, PROPERTY_TRUE);
    SET_MENU_ITEM_PROPERTY(bill_menu_itm, ENABLED, PROPERTY_TRUE);
    SET_MENU_ITEM_PROPERTY(dist_menu_itm, ENABLED, PROPERTY_TRUE);
    SET_MENU_ITEM_PROPERTY(post_menu_itm, ENABLED, PROPERTY_FALSE);
  END;
  /* Enable/Disable menu items when the par status = 6 */
  PROCEDURE PAR_STATUS6 IS
  BEGIN
    SET_MENU_ITEM_PROPERTY(peril_menu_itm, ENABLED, PROPERTY_TRUE);
    SET_MENU_ITEM_PROPERTY(bill_menu_itm, ENABLED, PROPERTY_TRUE);
    SET_MENU_ITEM_PROPERTY(dist_menu_itm, ENABLED, PROPERTY_TRUE);
    SET_MENU_ITEM_PROPERTY(post_menu_itm, ENABLED, PROPERTY_TRUE);
  END;
  PROCEDURE UPDATE_PAR_STATUS(p_par_status   gipi_parlist.par_status%TYPE) IS
  BEGIN
    UPDATE  gipi_parlist
       SET  par_status = p_par_status
     WHERE  par_id     = p_par_id;
  END;
BEGIN
  /* Get the current par status of the PAR being processed */
  FOR A1 IN A LOOP
    v_par_status := a1.par_status;
  END LOOP;
  /* Check if all items has corresponding peril records */
  FOR B1 IN B LOOP
    v_no_item   := 'N';
    v_item_item := b1.item_no;
    FOR C1 IN C(b1.item_no) LOOP
      IF v_item_item != c1.item_no THEN
        v_no_peril := 'Y';
        EXIT;
      END IF;
      v_no_peril := 'N';
    END LOOP;
  END LOOP;
  /* Check if all item groups has corresponding invoice */
  FOR D1 IN D LOOP
    v_no_grp   := 'N';
    v_item_grp := d1.item_grp;
    FOR E1 IN E(d1.item_grp) LOOP
      IF v_item_grp != e1.item_grp THEN
        v_no_invoice := 'Y';
        EXIT;
      END IF;
      v_no_invoice := 'N';
    END LOOP;
  END LOOP;
  IF v_no_item = 'Y' THEN              /* PAR has no items yet */
    PAR_STATUS3;
    UPDATE_PAR_STATUS(3);
  ELSIF v_no_item = 'N' THEN           /* PAR has items        */
    IF v_no_peril = 'Y' THEN           /* PAR has no perils    */
      PAR_STATUS4;
      UPDATE_PAR_STATUS(4);
    ELSIF v_no_peril = 'N' THEN        /* PAR has perils       */
      IF v_no_invoice = 'Y' THEN       /* PAR has no invoice   */
        PAR_STATUS5;
        UPDATE_PAR_STATUS(5);
      ELSIF v_no_invoice = 'N' THEN    /* PAR has invoice      */
        PAR_STATUS6;
        UPDATE_PAR_STATUS(6);
      END IF;
    END IF;
  END IF;
END;
/


