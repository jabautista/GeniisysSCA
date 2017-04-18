CREATE OR REPLACE PACKAGE BODY CPI.giacs302_pkg
AS
   FUNCTION get_rec_list (
      p_fund_cd     giis_funds.fund_cd%TYPE,
      p_fund_desc   giis_funds.fund_desc%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT   *
                    FROM giis_funds
                   WHERE UPPER (fund_cd) LIKE UPPER (NVL (p_fund_cd, '%'))
                     AND UPPER (fund_desc) LIKE UPPER (NVL (p_fund_desc, '%'))
                ORDER BY fund_cd)
      LOOP
         v_rec.fund_cd := i.fund_cd;
         v_rec.fund_desc := i.fund_desc;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_funds%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_funds
         USING DUAL
         ON (fund_cd = p_rec.fund_cd)
         WHEN NOT MATCHED THEN
            INSERT (fund_cd, fund_desc, remarks, user_id, last_update)
            VALUES (p_rec.fund_cd, p_rec.fund_desc, p_rec.remarks,
                    p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET fund_desc = p_rec.fund_desc, remarks = p_rec.remarks,
                   user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_fund_cd giis_funds.fund_cd%TYPE)
   AS
   BEGIN
      DELETE FROM giis_funds
            WHERE fund_cd = p_fund_cd;
   END;

   PROCEDURE val_del_rec (p_fund_cd giis_funds.fund_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR rec IN (SELECT '1'
                    FROM giac_branches
                   WHERE gfun_fund_cd = p_fund_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_FUNDS while dependent record(s) in GIAC_BRANCHES exists.'
            );
      END IF;

      FOR rec IN (SELECT '1'
                    FROM giac_acctran_seq
                   WHERE gfun_fund_cd = p_fund_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_FUNDS while dependent record(s) in GIAC_ACCTRAN_SEQ exists.'
            );
      END IF;

      FOR rec IN (SELECT '1'
                    FROM giac_acctrans
                   WHERE gfun_fund_cd = p_fund_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_FUNDS while dependent record(s) in GIAC_ACCTRANS exists.'
            );
      END IF;
      
      FOR rec IN (SELECT '1'
                    FROM giac_sl_lists
                   WHERE fund_cd = p_fund_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_FUNDS while dependent record(s) in GIAC_SL_LISTS exists.'
            );
      END IF;
   END;

   PROCEDURE val_add_rec (p_fund_cd giis_funds.fund_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_funds a
                 WHERE a.fund_cd = p_fund_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same fund_cd.'
            );
      END IF;
   END;
END;
/


