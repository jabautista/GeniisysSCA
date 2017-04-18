CREATE OR REPLACE PACKAGE BODY CPI.giacs324_pkg
AS
   FUNCTION get_rec_list (
      p_bank_cd          giac_banks.bank_cd%TYPE,
      p_bank_tran_cd     giac_bank_book_tran.bank_tran_cd%TYPE,
      p_bank_tran_desc   giac_bank_book_tran.bank_tran_desc%TYPE,
      p_book_tran_cd     giac_bank_book_tran.book_tran_cd%TYPE,
      p_book_tran_desc   giac_bank_book_tran.book_tran_desc%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN
         (SELECT a.bank_cd, a.bank_name, a.bank_sname, b.bank_tran_cd,
                 b.bank_tran_desc, b.book_tran_cd, b.book_tran_desc,
                 b.remarks, b.user_id, b.last_update
            FROM giac_banks a, giac_bank_book_tran b
           WHERE a.bank_cd = b.bank_cd
             AND a.bank_cd = p_bank_cd
             AND UPPER (b.bank_tran_cd) LIKE UPPER (NVL (p_bank_tran_cd, '%'))
             AND UPPER (NVL (b.bank_tran_desc, '%')) LIKE
                                           UPPER (NVL (p_bank_tran_desc, '%'))
             AND UPPER (NVL (b.book_tran_cd, '%')) LIKE
                                             UPPER (NVL (p_book_tran_cd, '%'))
             AND UPPER (NVL (b.book_tran_desc, '%')) LIKE
                                           UPPER (NVL (p_book_tran_desc, '%')))
      LOOP
         v_rec.bank_cd := i.bank_cd;
         v_rec.bank_name := i.bank_name;
         v_rec.bank_sname := i.bank_sname;
         v_rec.bank_tran_cd := i.bank_tran_cd;
         v_rec.bank_tran_desc := i.bank_tran_desc;
         v_rec.book_tran_cd := i.book_tran_cd;
         v_rec.book_tran_desc := i.book_tran_desc;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_bankcd_lov (p_user_id VARCHAR2, p_keyword VARCHAR2)
      RETURN bank_cd_lov_tab PIPELINED
   IS
      v_list   bank_cd_lov_type;
   BEGIN
      FOR i IN (SELECT a.bank_cd, a.bank_sname, a.bank_name
                  FROM giac_banks a
                 WHERE     1 = 1
                       AND (UPPER (a.bank_sname) LIKE
                                         UPPER (NVL (p_keyword, a.bank_sname))
                           )
                    OR UPPER (bank_name) LIKE
                                            UPPER (NVL (p_keyword, bank_name)))
      LOOP
         v_list.bank_cd := i.bank_cd;
         v_list.bank_sname := i.bank_sname;
         v_list.bank_name := i.bank_name;
         PIPE ROW (v_list);
      END LOOP;
   END;

   FUNCTION get_booktrancd_lov (p_user_id VARCHAR2, p_keyword VARCHAR2)
      RETURN booktrancd_lov_tab PIPELINED
   IS
      v_list   booktrancd_lov_type;
   BEGIN
      FOR i IN
         (SELECT   tran_code, book_transaction
              FROM (SELECT rv_low_value tran_code,
                           rv_meaning book_transaction
                      FROM cg_ref_codes
                     WHERE rv_domain LIKE 'GIAC_BANK_BOOK_TRAN.BOOK_TRAN_CD'
                    UNION
                    SELECT jv_tran_cd tran_code,
                           jv_tran_desc book_transaction
                      FROM giac_jv_trans
                     WHERE jv_tran_tag = 'C')
             WHERE 1 = 1
               AND (   UPPER (tran_code) LIKE
                                            UPPER (NVL (p_keyword, tran_code))
                    OR UPPER (book_transaction) LIKE
                                     UPPER (NVL (p_keyword, book_transaction))
                   )
          ORDER BY tran_code)
      LOOP
         v_list.tran_code := i.tran_code;
         v_list.book_transaction := i.book_transaction;
         PIPE ROW (v_list);
      END LOOP;
   END;

   PROCEDURE val_add_rec (
      p_bank_cd        giac_banks.bank_cd%TYPE,
      p_bank_tran_cd   giac_bank_book_tran.bank_tran_cd%TYPE,
      p_book_tran_cd   giac_bank_book_tran.book_tran_cd%TYPE
   )
   AS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
      FOR i IN
         (SELECT tran_code
            FROM (SELECT rv_low_value tran_code, rv_meaning book_transaction
                    FROM cg_ref_codes
                   WHERE rv_domain LIKE 'GIAC_BANK_BOOK_TRAN.BOOK_TRAN_CD'
                  UNION
                  SELECT jv_tran_cd tran_code, jv_tran_desc book_transaction
                    FROM giac_jv_trans
                   WHERE jv_tran_tag = 'C')
           WHERE tran_code = NVL (p_book_tran_cd, tran_code))
      LOOP
         v_exists := 'Y';
      END LOOP;

      IF v_exists = 'N'
      THEN
         raise_application_error
                      (-20001,
                       'Geniisys Exception#E#Invalid value for book_tran_cd.'
                      );
      END IF;

      FOR i IN (SELECT '1'
                  FROM giac_bank_book_tran a
                 WHERE a.bank_cd = p_bank_cd
                   AND a.bank_tran_cd = p_bank_tran_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same bank_cd and bank_tran_cd.'
            );
      END LOOP;
   END;

   PROCEDURE set_rec (p_rec giac_bank_book_tran%ROWTYPE)
   IS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT *
                  FROM giac_bank_book_tran
                 WHERE bank_cd = p_rec.bank_cd
                   AND bank_tran_cd = p_rec.bank_tran_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         UPDATE giac_bank_book_tran
            SET bank_tran_desc = p_rec.bank_tran_desc,
                book_tran_cd = p_rec.book_tran_cd,
                book_tran_desc = p_rec.book_tran_desc,
                remarks = p_rec.remarks,
                user_id = p_rec.user_id,
                last_update = SYSDATE
          WHERE bank_cd = p_rec.bank_cd AND bank_tran_cd = p_rec.bank_tran_cd;
      ELSE
         INSERT INTO giac_bank_book_tran
                     (bank_cd, bank_tran_cd,
                      bank_tran_desc, book_tran_cd,
                      book_tran_desc, remarks, user_id,
                      last_update
                     )
              VALUES (p_rec.bank_cd, p_rec.bank_tran_cd,
                      p_rec.bank_tran_desc, p_rec.book_tran_cd,
                      p_rec.book_tran_desc, p_rec.remarks, p_rec.user_id,
                      SYSDATE
                     );
      END IF;
   END;

   PROCEDURE del_rec (
      p_bank_cd        giac_banks.bank_cd%TYPE,
      p_bank_tran_cd   giac_bank_book_tran.bank_tran_cd%TYPE
   )
   AS
   BEGIN
      DELETE FROM giac_bank_book_tran
            WHERE bank_cd = p_bank_cd AND bank_tran_cd = p_bank_tran_cd;
   END;

   PROCEDURE val_booktrancd_rec (
      p_book_tran_cd   giac_bank_book_tran.book_tran_cd%TYPE
   )
   AS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
      FOR i IN
         (SELECT tran_code
            FROM (SELECT rv_low_value tran_code, rv_meaning book_transaction
                    FROM cg_ref_codes
                   WHERE rv_domain LIKE 'GIAC_BANK_BOOK_TRAN.BOOK_TRAN_CD'
                  UNION
                  SELECT jv_tran_cd tran_code, jv_tran_desc book_transaction
                    FROM giac_jv_trans
                   WHERE jv_tran_tag = 'C')
           WHERE tran_code = p_book_tran_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'N'
      THEN
         raise_application_error
                      (-20001,
                       'Geniisys Exception#E#Invalid value for book_tran_cd.'
                      );
      END IF;
   END;
END;
/


