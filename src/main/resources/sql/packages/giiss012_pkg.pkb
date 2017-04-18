CREATE OR REPLACE PACKAGE BODY CPI.giiss012_pkg
AS
   FUNCTION get_fi_item_type
      RETURN main_tab PIPELINED
   IS
      v_list   main_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM giis_fi_item_type
              ORDER BY fr_item_type)
      LOOP
         v_list.fr_item_type := i.fr_item_type;
         v_list.fr_itm_tp_ds := i.fr_itm_tp_ds;
         v_list.main_itm_typ := i.main_itm_typ;
         v_list.remarks := i.remarks;
         v_list.user_id := i.user_id;
         v_list.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_list.fi_item_grp := i.fi_item_grp;
         v_list.cpi_rec_no := 0;
         
         BEGIN
            SELECT rv_meaning
              INTO v_list.fi_itm_grp_desc
              FROM cg_ref_codes   
             WHERE rv_low_value = i.fi_item_grp
               AND rv_domain = 'GIIS_FI_ITEM_TYPE.ITEM_GRP'
               AND ROWNUM = 1;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.fi_itm_grp_desc := NULL;      
         END;
         
         PIPE ROW (v_list);
      END LOOP;
   END get_fi_item_type;
   
   FUNCTION get_fi_item_grp_lov
      RETURN fi_item_grp_tab PIPELINED
   IS
      v_list fi_item_grp_type;
   BEGIN
      FOR i IN (SELECT rv_low_value, rv_meaning
                  FROM cg_ref_codes
                 WHERE rv_domain = 'GIIS_FI_ITEM_TYPE.ITEM_GRP')
      LOOP
         v_list.rv_low_value := i.rv_low_value;
         v_list.rv_meaning := i.rv_meaning;
         PIPE ROW(v_list);
      END LOOP;
   END get_fi_item_grp_lov;
   
   PROCEDURE val_add_rec (p_fr_item_type giis_fi_item_type.fr_item_type%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_fi_item_type a
                 WHERE a.fr_item_type = p_fr_item_type)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001, 'Geniisys Exception#E#Record already exists with the same fr_item_type.');
      END IF;
   END val_add_rec;
   
   PROCEDURE val_del_rec(p_fr_item_type giis_fi_item_type.fr_item_type%TYPE)
   IS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
   
      BEGIN
         SELECT 'Y'
           INTO v_exists
           FROM gipi_fireitem
          WHERE fr_item_type = p_fr_item_type
            AND ROWNUM = 1;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_exists := 'N';      
      END;
      
      IF v_exists = 'Y' THEN
         raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_FI_ITEM_TYPE while dependent record(s) in GIPI_FIREITEM exists.');
      END IF;
      
      v_exists := 'N';
      
      BEGIN
         SELECT 'Y'
           INTO v_exists
           FROM gipi_wfireitm
          WHERE fr_item_type = p_fr_item_type
            AND ROWNUM = 1;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_exists := 'N';      
      END;
      
      IF v_exists = 'Y' THEN
         raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_FI_ITEM_TYPE while dependent record(s) in GIPI_WFIREITM exists.');
      END IF;
   
   END val_del_rec;
   
   PROCEDURE set_rec (p_rec giis_fi_item_type%ROWTYPE)
   IS
   BEGIN  
      MERGE INTO giis_fi_item_type
         USING DUAL
         ON (fr_item_type = p_rec.fr_item_type)
         WHEN NOT MATCHED THEN
            INSERT (fr_item_type, fr_itm_tp_ds, main_itm_typ,
                    remarks, user_id, last_update, --cpi_rec_no,
                    cpi_branch_cd, fi_item_grp)
            VALUES (p_rec.fr_item_type, p_rec.fr_itm_tp_ds, p_rec.main_itm_typ,
                    p_rec.remarks, p_rec.user_id, SYSDATE, --p_rec.cpi_rec_no,
                    p_rec.cpi_branch_cd, p_rec.fi_item_grp)
         WHEN MATCHED THEN
            UPDATE
               SET fr_itm_tp_ds = p_rec.fr_itm_tp_ds,
                   main_itm_typ = p_rec.main_itm_typ,
                   remarks = p_rec.remarks,
                   user_id = p_rec.user_id,
                   last_update = SYSDATE,
                   --cpi_rec_no = p_rec.cpi_rec_no,
                   cpi_branch_cd = p_rec.cpi_branch_cd,
                   fi_item_grp = p_rec.fi_item_grp;
   END set_rec;
   
   PROCEDURE del_rec (p_fr_item_type VARCHAR2)
   AS
   BEGIN
      DELETE FROM giis_fi_item_type
            WHERE fr_item_type = p_fr_item_type;
   END;
         
END;
/


