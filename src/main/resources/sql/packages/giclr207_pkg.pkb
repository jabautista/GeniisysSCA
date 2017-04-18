CREATE OR REPLACE PACKAGE BODY CPI.giclr207_pkg
AS
/*
**Created by : Benedict G. Castillo
**Date Created : 07/25/2013
**Description : GIACR207 : Outsanding Loss
*/
   FUNCTION populate_giclr207 (
      p_year      VARCHAR2,
      p_month     VARCHAR2,
      p_tran_id   VARCHAR2
   )
      RETURN giclr207_tab PIPELINED
   AS
      v_rec         giclr207_type;
      v_not_exist   BOOLEAN       := TRUE;
      v_year        DATE          := TO_DATE (p_year, 'RRRR');
       str                giclr207_pkg.tran_id_array;
   BEGIN
   str := giclr207_pkg.tran_id_to_array (p_tran_id, ',');
   FOR h IN 1 .. str.COUNT
      LOOP
      v_rec.company_name := giisp.v ('COMPANY_NAME');
      v_rec.company_address := giisp.v ('COMPANY_ADDRESS');
      v_rec.as_of :=
         (   'As of '
          || TO_CHAR (TO_DATE (p_month, 'MM'), 'FMMONTH')
          || ', '
          || TO_CHAR (v_year, 'RRRR')
         );
      v_rec.title := 'OUTSTANDING LOSS ()';

      FOR a IN (SELECT iss_cd
                  FROM gicl_take_up_hist
                 WHERE acct_tran_id = str(h))
      LOOP
         v_rec.iss_cd := a.iss_cd;
         FOR b IN (SELECT iss_name
                     FROM giis_issource
                    WHERE iss_cd = a.iss_cd)
         LOOP
            v_rec.title := 'OUTSTANDING LOSS (' || b.iss_name || ')';
            EXIT;
         END LOOP;

         EXIT;
      END LOOP;

      FOR i IN (SELECT   a.gl_acct_id,
                            TRIM (TO_CHAR (a.gl_acct_category))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_control_acct, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_1, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_2, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_3, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_4, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_5, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_6, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_7, '00')) gl_acct,
                         a.gl_acct_name, NVL (SUM (d.debit_amt), 0) debit_amt,
                         NVL (SUM (d.credit_amt), 0) credit_amt, d.gacc_tran_id
                    FROM giac_chart_of_accts a, giac_acct_entries d
                   WHERE a.gl_acct_id = d.gl_acct_id
                     AND d.gacc_tran_id = str(h)
                  HAVING SUM (d.debit_amt) > 0 OR SUM (d.credit_amt) > 0
                GROUP BY d.gacc_tran_id, a.gl_acct_id,
                            TRIM (TO_CHAR (a.gl_acct_category))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_control_acct, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_1, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_2, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_3, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_4, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_5, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_6, '00'))
                         || '-'
                         || TRIM (TO_CHAR (a.gl_sub_acct_7, '00')),
                         a.gl_acct_name
                ORDER BY 2)
      LOOP
         v_not_exist := FALSE;
         v_rec.gl_acct := i.gl_acct;
         v_rec.gl_acct_name := i.gl_acct_name;
         v_rec.debit_amt := i.debit_amt;
         v_rec.credit_amt := i.credit_amt;
         v_rec.tran_id := i.gacc_tran_id;
         PIPE ROW (v_rec);
      END LOOP;

      IF v_not_exist
      THEN
         v_rec.flag := 'T';
         PIPE ROW (v_rec);
      END IF;
      end loop;
      
   END populate_giclr207;
   
   FUNCTION tran_id_to_array (p_tran_id VARCHAR2, p_ref VARCHAR2)
      RETURN tran_id_array
   IS
      i          NUMBER          := 0;
      POSITION   NUMBER          := 0;
      p_input    VARCHAR2 (5000) := p_tran_id;
      output     tran_id_array;
   BEGIN
      POSITION := INSTR (p_input, p_ref, 1, 1);

      IF POSITION = 0 THEN
         output (1) := p_input;
      END IF;

      WHILE (POSITION != 0)
      LOOP
         i := i + 1;
         output (i) := SUBSTR (p_input, 1, POSITION - 1);
         p_input := SUBSTR (p_input, POSITION + 1, LENGTH (p_input));
         POSITION := INSTR (p_input, p_ref, 1, 1);

         IF POSITION = 0 THEN
            output (i + 1) := p_input;
         END IF;
      END LOOP;

      RETURN output;
   END tran_id_to_array;
END giclr207_pkg;
/


