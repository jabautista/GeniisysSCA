CREATE OR REPLACE PACKAGE BODY CPI.gipi_quote_mort_pkg
AS
   FUNCTION get_gipi_quote_mort (p_quote_id gipi_quote.quote_id%TYPE)
      RETURN gipi_quote_mort_tab PIPELINED
   IS
      v_gipi_quote_mort   gipi_quote_mort_type;
   BEGIN
      FOR i IN (SELECT   a.quote_id, a.iss_cd, a.item_no, a.mortg_cd,
                         b.mortg_name, a.amount
                    FROM gipi_quote_mortgagee a, giis_mortgagee b
                   WHERE a.mortg_cd = b.mortg_cd
                     AND a.iss_cd = b.iss_cd
                     AND quote_id = p_quote_id
                     AND a.item_no <> 0
                ORDER BY b.mortg_name)
      LOOP
         v_gipi_quote_mort.quote_id := i.quote_id;
         v_gipi_quote_mort.iss_cd := i.iss_cd;
         v_gipi_quote_mort.item_no := i.item_no;
         v_gipi_quote_mort.mortg_cd := i.mortg_cd;
         v_gipi_quote_mort.mortg_name := i.mortg_name;
         v_gipi_quote_mort.amount := i.amount;
         PIPE ROW (v_gipi_quote_mort);
      END LOOP;

      RETURN;
   END get_gipi_quote_mort;

   FUNCTION get_gipi_quote_level_mort (p_quote_id gipi_quote.quote_id%TYPE)
      RETURN gipi_quote_mort_tab PIPELINED
   IS
      v_gipi_quote_mort   gipi_quote_mort_type;
   BEGIN
      FOR i IN (SELECT   a.quote_id, a.iss_cd, a.item_no, a.mortg_cd,
                         b.mortg_name, a.amount
                    FROM gipi_quote_mortgagee a, giis_mortgagee b
                   WHERE a.mortg_cd = b.mortg_cd
                     AND a.iss_cd = b.iss_cd
                     AND quote_id = p_quote_id
                     AND a.item_no = 0
                ORDER BY b.mortg_name)
      LOOP
         v_gipi_quote_mort.quote_id := i.quote_id;
         v_gipi_quote_mort.iss_cd := i.iss_cd;
         v_gipi_quote_mort.item_no := i.item_no;
         v_gipi_quote_mort.mortg_cd := i.mortg_cd;
         v_gipi_quote_mort.mortg_name := i.mortg_name;
         v_gipi_quote_mort.amount := i.amount;
         PIPE ROW (v_gipi_quote_mort);
      END LOOP;

      RETURN;
   END get_gipi_quote_level_mort;

   PROCEDURE set_gipi_quote_mort (
      p_gipi_quote_mort   IN   gipi_quote_mortgagee%ROWTYPE
   )
   IS
   BEGIN
      MERGE INTO gipi_quote_mortgagee
         USING DUAL
         ON (    quote_id = p_gipi_quote_mort.quote_id
             AND item_no = p_gipi_quote_mort.item_no
             AND mortg_cd = p_gipi_quote_mort.mortg_cd)
         WHEN NOT MATCHED THEN
            INSERT (quote_id, iss_cd, item_no, mortg_cd, amount, remarks,
                    last_update, user_id)
            VALUES (p_gipi_quote_mort.quote_id, p_gipi_quote_mort.iss_cd,
                    p_gipi_quote_mort.item_no, p_gipi_quote_mort.mortg_cd,
                    p_gipi_quote_mort.amount, p_gipi_quote_mort.remarks,
                    p_gipi_quote_mort.last_update, p_gipi_quote_mort.user_id)
         WHEN MATCHED THEN
            UPDATE
               SET iss_cd = p_gipi_quote_mort.iss_cd,
                   amount = p_gipi_quote_mort.amount,
                   remarks = p_gipi_quote_mort.remarks,
                   last_update = p_gipi_quote_mort.last_update,
                   user_id = p_gipi_quote_mort.user_id
            ;
   --*COMMIT;
   END set_gipi_quote_mort;

   PROCEDURE update_gipi_quote_mort (
      p_gipi_quote_mort   IN   gipi_quote_mortgagee%ROWTYPE,
      p_old_morgt_cd           gipi_quote_mortgagee.mortg_cd%TYPE
   )
   IS
   BEGIN
      UPDATE gipi_quote_mortgagee
         SET mortg_cd = p_gipi_quote_mort.mortg_cd,
             iss_cd = p_gipi_quote_mort.iss_cd,
             amount = p_gipi_quote_mort.amount,
             remarks = p_gipi_quote_mort.remarks,
             last_update = p_gipi_quote_mort.last_update,
             user_id = p_gipi_quote_mort.user_id
       WHERE mortg_cd = p_old_morgt_cd AND quote_id = p_gipi_quote_mort.quote_id;
   END;

   PROCEDURE del_gipi_quote_mort (
      p_quote_id   gipi_quote.quote_id%TYPE,
      p_iss_cd     gipi_quote_mortgagee.iss_cd%TYPE,
      p_item_no    gipi_quote_mortgagee.item_no%TYPE,
      p_mortg_cd   gipi_quote_mortgagee.mortg_cd%TYPE
   )
   IS
   BEGIN
      DELETE FROM gipi_quote_mortgagee
            WHERE quote_id = p_quote_id
              AND item_no = p_item_no
              AND iss_cd = p_iss_cd
              AND mortg_cd = p_mortg_cd;
   --*COMMIT;
   END del_gipi_quote_mort;

   PROCEDURE del_all_gipi_quote_mort (
      p_quote_id   gipi_quote.quote_id%TYPE,
      p_item_no    gipi_quote_mortgagee.item_no%TYPE
   )
   IS
   BEGIN
      DELETE FROM gipi_quote_mortgagee
            WHERE quote_id = p_quote_id AND item_no = p_item_no;
   --*COMMIT;
   END del_all_gipi_quote_mort;

   FUNCTION get_pack_quotations_mortgagee (
      p_pack_quote_id   gipi_pack_quote.pack_quote_id%TYPE
   )
      RETURN gipi_quote_mort_tab PIPELINED
   IS
      pack_quote_mort   gipi_quote_mort_type;
   BEGIN
      FOR i IN (SELECT b.pack_quote_id, a.quote_id, a.iss_cd, a.item_no,
                       a.mortg_cd, c.mortg_name, a.amount, a.remarks
                  FROM gipi_quote_mortgagee a, gipi_quote b,
                       giis_mortgagee c
                 WHERE a.quote_id = b.quote_id
                   AND b.pack_quote_id = p_pack_quote_id
                   AND a.mortg_cd = c.mortg_cd
                   AND a.iss_cd = c.iss_cd)
      LOOP
         pack_quote_mort.quote_id := i.quote_id;
         pack_quote_mort.iss_cd := i.iss_cd;
         pack_quote_mort.item_no := i.item_no;
         pack_quote_mort.mortg_cd := i.mortg_cd;
         pack_quote_mort.mortg_name := i.mortg_name;
         pack_quote_mort.amount := i.amount;
         pack_quote_mort.remarks := i.remarks;
         PIPE ROW (pack_quote_mort);
      END LOOP;

      RETURN;
   END;
END gipi_quote_mort_pkg;
/


