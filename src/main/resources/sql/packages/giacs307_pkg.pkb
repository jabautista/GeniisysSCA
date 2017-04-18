CREATE OR REPLACE PACKAGE BODY CPI.giacs307_pkg
AS
   FUNCTION get_rec_list (
      p_bank_cd      giac_banks.bank_cd%TYPE,
      p_bank_sname   giac_banks.bank_sname%TYPE,
      p_bank_name    giac_banks.bank_name%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT   a.bank_cd, a.bank_sname, a.bank_name, a.remarks,
                         a.user_id, a.last_update
                    FROM giac_banks a
                   WHERE UPPER (a.bank_cd) LIKE UPPER (NVL (p_bank_cd, '%'))
                     AND UPPER (a.bank_sname) LIKE
                                               UPPER (NVL (p_bank_sname, '%'))
                     AND UPPER (a.bank_name) LIKE
                                                UPPER (NVL (p_bank_name, '%'))
                ORDER BY TO_NUMBER (bank_cd))
      LOOP
         v_rec.bank_cd := i.bank_cd;
         v_rec.bank_sname := i.bank_sname;
         v_rec.bank_name := i.bank_name;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giac_banks%ROWTYPE)
   IS
      v_bank_cd       NUMBER (10)                     := 1;
      v_fund_cd       giac_sl_lists.fund_cd%TYPE;
      v_sl_type_cd    giac_sl_lists.sl_type_cd%TYPE;
      v_exist_banks   VARCHAR2 (1);
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_fund_cd
           FROM giac_parameters
          WHERE param_name = 'FUND_CD';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20012,
                                     'NO RECORDS IN PARAMETERS TABLE.'
                                    );
      END;

      BEGIN
         SELECT param_value_v
           INTO v_sl_type_cd
           FROM giac_parameters
          WHERE param_name = 'GIAC_BANK_SLT_CD';
      END;

      FOR i IN (SELECT MAX (TO_NUMBER (bank_cd)) + 1 max_bank_cd
                  FROM giac_banks)
      LOOP
         v_bank_cd := i.max_bank_cd;
      END LOOP;

      IF v_bank_cd > 999
      THEN
         raise_application_error
                       (-20001,
                        'Geniisys Exception#E#There is no available bank_cd.'
                       );
      END IF;

      LOOP
         v_exist_banks := NULL;

         FOR i IN (SELECT '1' exist
                     FROM giac_sl_lists
                    WHERE sl_cd = v_bank_cd
                      AND fund_cd = v_fund_cd
                      AND sl_type_cd = v_sl_type_cd)
         LOOP
            v_exist_banks := i.exist;
         END LOOP;

         IF v_exist_banks IS NOT NULL
         THEN
            DELETE      giac_sl_lists
                  WHERE sl_cd = v_bank_cd
                    AND fund_cd = v_fund_cd
                    AND sl_type_cd = v_sl_type_cd;
         ELSE
            EXIT;
         END IF;
      END LOOP;

      MERGE INTO giac_banks
         USING DUAL
         ON (bank_cd = p_rec.bank_cd)
         WHEN NOT MATCHED THEN
            INSERT (bank_cd, bank_sname, bank_name, remarks, user_id,
                    last_update)
            VALUES (v_bank_cd, p_rec.bank_sname, p_rec.bank_name,
                    p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET bank_sname = p_rec.bank_sname, bank_name = p_rec.bank_name,
                   remarks = p_rec.remarks, user_id = p_rec.user_id,
                   last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_bank_cd giac_banks.bank_cd%TYPE)
   AS
   BEGIN
      DELETE FROM giac_banks
            WHERE bank_cd = p_bank_cd;
   END;

   PROCEDURE val_del_rec (p_bank_cd giac_banks.bank_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giac_chk_disbursement gidv
                 WHERE gidv.bank_cd = p_bank_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIAC_BANKS while dependent record(s) in GIAC_CHK_DISBURSEMENT exists.'
            );
      END IF;

      FOR i IN (SELECT '1'
                  FROM giac_bank_collns gcba
                 WHERE gcba.gban_bank_cd = p_bank_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIAC_BANKS while dependent record(s) in GIAC_BANK_COLLNS exists.'
            );
      END IF;

      FOR i IN (SELECT '1'
                  FROM giac_bank_accounts gcba
                 WHERE gcba.bank_cd = p_bank_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIAC_BANKS while dependent record(s) in GIAC_BANK_ACCOUNTS exists.'
            );
      END IF;

      FOR i IN (SELECT '1'
                  FROM giac_collection_dtl gcba
                 WHERE gcba.bank_cd = p_bank_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIAC_BANKS while dependent record(s) in GIAC_COLLECTION_DTL exists.'
            );
      END IF;

      FOR i IN (SELECT '1'
                  FROM giac_sl_lists gcba
                 WHERE gcba.sl_cd = p_bank_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIAC_BANKS while dependent record(s) in GIAC_SL_LISTS exists.'
            );
      END IF;
   END;

   PROCEDURE val_add_rec (p_bank_cd giac_banks.bank_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giac_banks gcba
                 WHERE gcba.bank_cd = p_bank_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
              (-20001,
               'Geniisys Exception#E#Row exists already with same Bank Code.'
              );
      END IF;
   END;
END;
/


