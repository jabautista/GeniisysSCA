CREATE OR REPLACE PACKAGE BODY CPI.giiss217_pkg
AS
   FUNCTION get_rec_list (
      p_location_cd     giis_ca_location.location_cd%TYPE,
      p_location_desc   giis_ca_location.location_desc%TYPE,
      p_loc_addr        VARCHAR2
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN
         (SELECT   a.location_cd, a.location_desc,
                   a.loc_addr1 ||' '|| a.loc_addr2 ||' '||a.loc_addr3 loc_addr,
                   a.loc_addr1, a.loc_addr2, a.loc_addr3, a.treaty_limit,
                   a.ret_limit, a.ret_beg_bal, a.treaty_beg_bal,
                   a.fac_beg_bal, a.from_date, a.TO_DATE, a.remarks,
                   a.user_id, a.last_update
              FROM giis_ca_location a
             WHERE a.location_cd = NVL (p_location_cd, a.location_cd)
               AND UPPER (a.location_desc) LIKE
                                            UPPER (NVL (p_location_desc, '%'))
               AND UPPER (a.loc_addr1 || a.loc_addr2 || a.loc_addr3) LIKE
                                                 UPPER (NVL (p_loc_addr, '%'))
          ORDER BY a.location_cd)
      LOOP
         v_rec.location_cd := i.location_cd;
         v_rec.location_desc := i.location_desc;
         v_rec.loc_addr := i.loc_addr;
         v_rec.loc_addr1 := i.loc_addr1;
         v_rec.loc_addr2 := i.loc_addr2;
         v_rec.loc_addr3 := i.loc_addr3;
         v_rec.treaty_limit := i.treaty_limit;
         v_rec.ret_limit := i.ret_limit;
         v_rec.ret_beg_bal := i.ret_beg_bal;
         v_rec.treaty_beg_bal := i.treaty_beg_bal;
         v_rec.fac_beg_bal := i.fac_beg_bal;
         v_rec.from_date := TO_CHAR (i.from_date, 'MM-DD-YYYY');
         v_rec.TO_DATE := TO_CHAR (i.TO_DATE, 'MM-DD-YYYY');
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_ca_location%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_ca_location
         USING DUAL
         ON (location_cd = p_rec.location_cd)
         WHEN NOT MATCHED THEN
            INSERT (location_desc, loc_addr1, loc_addr2, loc_addr3,
                    from_date, TO_DATE, treaty_limit, ret_limit,
                    treaty_beg_bal, ret_beg_bal, fac_beg_bal, remarks,
                    user_id, last_update)
            VALUES (p_rec.location_desc, p_rec.loc_addr1, p_rec.loc_addr2,
                    p_rec.loc_addr3, p_rec.from_date, p_rec.TO_DATE,
                    p_rec.treaty_limit, p_rec.ret_limit,
                    p_rec.treaty_beg_bal, p_rec.ret_beg_bal,
                    p_rec.fac_beg_bal, p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET location_desc = p_rec.location_desc,
                   loc_addr1 = p_rec.loc_addr1, loc_addr2 = p_rec.loc_addr2,
                   loc_addr3 = p_rec.loc_addr3, from_date = p_rec.from_date,
                   TO_DATE = p_rec.TO_DATE,
                   treaty_limit = p_rec.treaty_limit,
                   ret_limit = p_rec.ret_limit,
                   treaty_beg_bal = p_rec.treaty_beg_bal,
                   ret_beg_bal = p_rec.ret_beg_bal,
                   fac_beg_bal = p_rec.fac_beg_bal, remarks = p_rec.remarks,
                   user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_location_cd giis_ca_location.location_cd%TYPE)
   AS
   BEGIN
      DELETE FROM giis_ca_location
            WHERE location_cd = p_location_cd;
   END;
END;
/


