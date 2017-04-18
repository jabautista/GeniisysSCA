CREATE OR REPLACE PACKAGE BODY CPI.giiss032_pkg
AS
   FUNCTION get_rec_list (
      p_line_cd       giis_intreaty.line_cd%TYPE,
      p_trty_seq_no   giis_intreaty.trty_seq_no%TYPE,
      p_trty_yy       giis_intreaty.trty_yy%TYPE,
      p_trty_name     giis_intreaty.trty_name%TYPE,
      p_user_id       giis_intreaty.user_id%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN
         (SELECT   *
              FROM giis_intreaty a
             WHERE UPPER (a.line_cd) LIKE UPPER (NVL (p_line_cd, '%'))
               AND UPPER (NVL (a.trty_name, '%')) LIKE
                                                UPPER (NVL (p_trty_name, '%'))
               AND a.trty_seq_no LIKE NVL (p_trty_seq_no, a.trty_seq_no)
               AND a.trty_yy LIKE NVL (p_trty_yy, a.trty_yy)
               AND check_user_per_line2 (UPPER (NVL (p_line_cd, a.line_cd)),
                                         NULL,
                                         'GIISS032',
                                         p_user_id
                                        ) = 1
          ORDER BY a.line_cd, a.trty_yy, a.trty_seq_no)
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.trty_seq_no := i.trty_seq_no;
         v_rec.trty_yy := i.trty_yy;
         v_rec.trty_name := i.trty_name;
         v_rec.uw_trty_type := i.uw_trty_type;
         v_rec.eff_date := TO_CHAR (i.eff_date, 'MM-DD-YYYY');
         v_rec.expiry_date := TO_CHAR (i.expiry_date, 'MM-DD-YYYY');
         v_rec.ri_cd := i.ri_cd;
         v_rec.ac_trty_type := i.ac_trty_type;
         v_rec.trty_limit := i.trty_limit;
         v_rec.trty_shr_pct := i.trty_shr_pct;
         v_rec.trty_shr_amt := i.trty_shr_amt;
         v_rec.est_prem_inc := i.est_prem_inc;
         v_rec.prtfolio_sw := i.prtfolio_sw;
         v_rec.no_of_lines := i.no_of_lines;
         v_rec.inxs_amt := i.inxs_amt;
         v_rec.exc_loss_rt := i.exc_loss_rt;
         v_rec.ccall_limit := i.ccall_limit;
         v_rec.dep_prem := i.dep_prem;
         v_rec.currency_cd := i.currency_cd;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MM:SS AM');

         FOR ri_sname IN (SELECT a180.ri_sname
                            FROM giis_reinsurer a180
                           WHERE a180.ri_cd = i.ri_cd)
         LOOP
            v_rec.dsp_ri_sname := ri_sname.ri_sname;
            EXIT;
         END LOOP;

         FOR c IN (SELECT currency_desc
                     FROM giis_currency t1, giis_intreaty t2
                    WHERE t2.currency_cd = t1.main_currency_cd
                      AND t2.line_cd = i.line_cd
                      AND t2.trty_yy = i.trty_yy
                      AND t2.trty_seq_no = i.trty_seq_no)
         LOOP
            v_rec.dsp_currency_name := c.currency_desc;
            EXIT;
         END LOOP;

         FOR c IN (SELECT trty_sname
                     FROM giis_ca_trty_type t1, giis_intreaty t2
                    WHERE t2.ac_trty_type = t1.ca_trty_type
                      AND t2.line_cd = t1.line_cd
                      AND t2.line_cd = i.line_cd
                      AND t2.trty_yy = i.trty_yy
                      AND t2.trty_seq_no = i.trty_seq_no)
         LOOP
            v_rec.dsp_ac_type_sname := c.trty_sname;
            EXIT;
         END LOOP;

         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_line_lov (p_user_id VARCHAR2, p_keyword VARCHAR2)
      RETURN line_lov_tab PIPELINED
   IS
      v_lov   line_lov_type;
   BEGIN
      FOR i IN
         (SELECT a150.line_cd line_cd, a150.line_name dsp_line_name
            FROM giis_line a150
           WHERE check_user_per_line2 (line_cd, NULL, 'GIISS032', p_user_id) = 1
             AND (   UPPER (a150.line_cd) LIKE
                            '%' || UPPER (NVL (p_keyword, a150.line_cd))
                            || '%'
                  OR UPPER (a150.line_name) LIKE
                          '%' || UPPER (NVL (p_keyword, a150.line_name))
                          || '%'
                 ))
      LOOP
         v_lov.line_cd := i.line_cd;
         v_lov.line_name := i.dsp_line_name;
         PIPE ROW (v_lov);
      END LOOP;
   END;

   FUNCTION get_cedant_lov (p_user_id VARCHAR2, p_keyword VARCHAR2)
      RETURN cedant_lov_tab PIPELINED
   IS
      v_lov   cedant_lov_type;
   BEGIN
      FOR i IN
         (SELECT   a180.ri_sname dsp_ri_sname, a180.ri_name ri_name,
                   a180.ri_cd ri_cd
              FROM giis_reinsurer a180
             WHERE 1 = 1
               AND (   UPPER (a180.ri_sname) LIKE
                           '%' || UPPER (NVL (p_keyword, a180.ri_sname))
                           || '%'
                    OR UPPER (a180.ri_name) LIKE
                            '%' || UPPER (NVL (p_keyword, a180.ri_name))
                            || '%'
                   )
          ORDER BY a180.ri_sname)
      LOOP
         v_lov.ri_sname := i.dsp_ri_sname;
         v_lov.ri_name := i.ri_name;
         v_lov.ri_cd := i.ri_cd;
         PIPE ROW (v_lov);
      END LOOP;
   END;

   FUNCTION get_currency_lov (p_user_id VARCHAR2, p_keyword VARCHAR2)
      RETURN currency_lov_tab PIPELINED
   IS
      v_lov   currency_lov_type;
   BEGIN
      FOR i IN (SELECT main_currency_cd, short_name, currency_desc
                  FROM giis_currency
                 WHERE 1 = 1
                   AND (   UPPER (short_name) LIKE
                              '%' || UPPER (NVL (p_keyword, short_name))
                              || '%'
                        OR UPPER (currency_desc) LIKE
                                 '%'
                              || UPPER (NVL (p_keyword, currency_desc))
                              || '%'
                       ))
      LOOP
         v_lov.short_name := i.short_name;
         v_lov.currency_desc := i.currency_desc;
         v_lov.main_currency_cd := i.main_currency_cd;
         PIPE ROW (v_lov);
      END LOOP;
   END;

   FUNCTION get_acctgtype_lov (
      p_user_id   VARCHAR2,
      p_keyword   VARCHAR2,
      p_line_cd   VARCHAR2
   )
      RETURN acctgtype_lov_tab PIPELINED
   IS
      v_lov   acctgtype_lov_type;
   BEGIN
      FOR i IN (SELECT ca_trty_type, trty_sname, trty_lname
                  FROM giis_ca_trty_type
                 WHERE line_cd = p_line_cd
                   AND (   UPPER (trty_sname) LIKE
                              '%' || UPPER (NVL (p_keyword, trty_sname))
                              || '%'
                        OR UPPER (trty_lname) LIKE
                              '%' || UPPER (NVL (p_keyword, trty_lname))
                              || '%'
                       ))
      LOOP
         v_lov.ca_trty_type := i.ca_trty_type;
         v_lov.trty_sname := i.trty_sname;
         v_lov.trty_lname := i.trty_lname;
         PIPE ROW (v_lov);
      END LOOP;
   END;

   PROCEDURE val_add_rec (
      p_line_cd       giis_intreaty.line_cd%TYPE,
      p_trty_seq_no   giis_intreaty.trty_seq_no%TYPE,
      p_trty_yy       giis_intreaty.trty_yy%TYPE,
      p_ri_cd         giis_intreaty.ri_cd%TYPE
   )
   AS
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_intreaty a
                 WHERE a.line_cd = p_line_cd
                   AND a.trty_yy = p_trty_yy
                   AND a.trty_seq_no = p_trty_seq_no
                   AND a.ri_cd = p_ri_cd)
      LOOP
         raise_application_error
                        (-20001,
                         'Geniisys Exception#E#Inward treaty must be unique.'
                        );
         EXIT;
      END LOOP;
   END;

   PROCEDURE val_delete_rec (
      p_line_cd       giis_intreaty.line_cd%TYPE,
      p_trty_seq_no   giis_intreaty.trty_seq_no%TYPE,
      p_trty_yy       giis_intreaty.trty_yy%TYPE,
      p_ri_cd         giis_intreaty.ri_cd%TYPE
   )
   AS
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giac_intreaty_qtr_soa a
                 WHERE a.a590_line_cd = p_line_cd
                   AND a.a590_trty_yy = p_trty_yy
                   AND a.a590_trty_seq_no = p_trty_seq_no
                   AND a.a590_ri_cd = p_ri_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from giis_intreaty while dependent record(s) in giac_intreaty_qtr_soa exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT '1'
                  FROM giac_inw_oblig_collns a
                 WHERE a.a590_line_cd = p_line_cd
                   AND a.a590_trty_yy = p_trty_yy
                   AND a.a590_trty_seq_no = p_trty_seq_no
                   AND a.a590_ri_cd = p_ri_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from giis_intreaty while dependent record(s) in giac_inw_oblig_collns exists.'
            );
         EXIT;
      END LOOP;
   END;

   PROCEDURE set_rec (p_rec giis_intreaty%ROWTYPE)
   IS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_intreaty
                 WHERE line_cd = p_rec.line_cd
                   AND trty_yy = p_rec.trty_yy
                   AND trty_seq_no = p_rec.trty_seq_no
                   AND ri_cd = p_rec.ri_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         UPDATE giis_intreaty
            SET uw_trty_type = p_rec.uw_trty_type,
                eff_date = p_rec.eff_date,
                expiry_date = p_rec.expiry_date,
                ac_trty_type = p_rec.ac_trty_type,
                trty_name = p_rec.trty_name,
                trty_limit = p_rec.trty_limit,
                trty_shr_pct = p_rec.trty_shr_pct,
                trty_shr_amt = p_rec.trty_shr_amt,
                est_prem_inc = p_rec.est_prem_inc,
                prtfolio_sw = p_rec.prtfolio_sw,
                no_of_lines = p_rec.no_of_lines,
                inxs_amt = p_rec.inxs_amt,
                exc_loss_rt = p_rec.exc_loss_rt,
                ccall_limit = p_rec.ccall_limit,
                dep_prem = p_rec.dep_prem,
                currency_cd = p_rec.currency_cd,
                remarks = p_rec.remarks,
                user_id = p_rec.user_id,
                last_update = SYSDATE
          WHERE line_cd = p_rec.line_cd
            AND trty_yy = p_rec.trty_yy
            AND trty_seq_no = p_rec.trty_seq_no
            AND ri_cd = p_rec.ri_cd;
      ELSE
         INSERT INTO giis_intreaty
                     (line_cd, trty_seq_no, trty_yy,
                      uw_trty_type, eff_date, expiry_date,
                      ri_cd, ac_trty_type, trty_name,
                      trty_limit, trty_shr_pct,
                      trty_shr_amt, est_prem_inc,
                      prtfolio_sw, no_of_lines, inxs_amt,
                      exc_loss_rt, ccall_limit, dep_prem,
                      currency_cd, remarks, user_id,
                      last_update
                     )
              VALUES (p_rec.line_cd, p_rec.trty_seq_no, p_rec.trty_yy,
                      p_rec.uw_trty_type, p_rec.eff_date, p_rec.expiry_date,
                      p_rec.ri_cd, p_rec.ac_trty_type, p_rec.trty_name,
                      p_rec.trty_limit, p_rec.trty_shr_pct,
                      p_rec.trty_shr_amt, p_rec.est_prem_inc,
                      p_rec.prtfolio_sw, p_rec.no_of_lines, p_rec.inxs_amt,
                      p_rec.exc_loss_rt, p_rec.ccall_limit, p_rec.dep_prem,
                      p_rec.currency_cd, p_rec.remarks, p_rec.user_id,
                      SYSDATE
                     );
      END IF;
   END;

   PROCEDURE del_rec (
      p_line_cd       giis_intreaty.line_cd%TYPE,
      p_trty_seq_no   giis_intreaty.trty_seq_no%TYPE,
      p_trty_yy       giis_intreaty.trty_yy%TYPE,
      p_ri_cd         giis_intreaty.ri_cd%TYPE
   )
   AS
   BEGIN
      DELETE FROM giis_intreaty
            WHERE line_cd = p_line_cd
              AND trty_yy = p_trty_yy
              AND trty_seq_no = p_trty_seq_no
              AND ri_cd = p_ri_cd;
   END;
END;
/


