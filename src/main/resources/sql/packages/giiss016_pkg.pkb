CREATE OR REPLACE PACKAGE BODY CPI.giiss016_pkg
AS
   FUNCTION get_rec_list
      RETURN main_tab PIPELINED
   IS
      v_list   main_type;
   BEGIN
      FOR i IN (SELECT   *
                    FROM giis_notary_public
                ORDER BY np_no)
      LOOP
         v_list.np_no := i.np_no;
         v_list.np_name := i.np_name;
         v_list.ptr_no := i.ptr_no;
         v_list.issue_date := i.issue_date;
         v_list.expiry_date := i.expiry_date;
         v_list.place_issue := i.place_issue;
         v_list.user_id := i.user_id;
         v_list.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_list.remarks := i.remarks;
         
         PIPE ROW (v_list);
      END LOOP;
   END get_rec_list;
   
   PROCEDURE set_rec (p_rec giis_notary_public%ROWTYPE)
   IS
   BEGIN      
      MERGE INTO giis_notary_public
         USING DUAL
         ON (np_no = p_rec.np_no)
         WHEN NOT MATCHED THEN
            INSERT (np_name, ptr_no, issue_date, expiry_date, place_issue, remarks, user_id, last_update)
            VALUES (p_rec.np_name, p_rec.ptr_no, p_rec.issue_date,
                    p_rec.expiry_date, p_rec.place_issue, p_rec.remarks,
                    p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET np_name = p_rec.np_name,
                   ptr_no = p_rec.ptr_no,
                   issue_date = p_rec.issue_date,
                   expiry_date = p_rec.expiry_date,
                   place_issue = p_rec.place_issue,
                   remarks = p_rec.remarks,
                   user_id = p_rec.user_id,
                   last_update = p_rec.last_update;
   END set_rec;
   
   PROCEDURE val_del_rec (p_np_no VARCHAR2)
   IS
      v_exists VARCHAR2(1) := 'N';
   BEGIN
      BEGIN
         SELECT 'Y'
           INTO v_exists
           FROM gipi_wbond_basic
          WHERE np_no = p_np_no
            AND ROWNUM = 1;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_exists := 'N';    
      END;
      
      IF v_exists = 'Y' THEN
         raise_application_error(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_NOTARY_PUBLIC while dependent record(s) in GIPI_WBOND_BASIC exists.');
      ELSE
         BEGIN
            SELECT 'Y'
              INTO v_exists
              FROM gipi_bond_basic
             WHERE np_no = p_np_no
               AND ROWNUM = 1;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_exists := 'N';
         END;         
      END IF;
      
      IF v_exists = 'Y' THEN
         raise_application_error(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_NOTARY_PUBLIC while dependent record(s) in GIPI_BOND_BASIC exists.');
      END IF;
      
   END val_del_rec;
   
   PROCEDURE del_rec (p_np_no VARCHAR2)
   IS
   BEGIN
      
      IF p_np_no IS NOT NULL AND UPPER(p_np_no) != 'NULL' THEN
         BEGIN
            DELETE
              FROM giis_notary_public
             WHERE np_no = p_np_no;   
         END;
      END IF;        
       
   END del_rec;
   
END;
/


