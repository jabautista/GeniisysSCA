CREATE OR REPLACE PACKAGE BODY CPI.CSV_BATCHOS_ENTRIES_GICLR207
AS
/*
**Created by : Carlo Rubenecia
**Date Created : 04/26/2016
**Description : CSV for giclr207 
*/
   FUNCTION csv_giclr207 (
      p_tran_id   VARCHAR2
   )
      RETURN giclr207_tab PIPELINED
   AS
      v_rec         giclr207_type;
      str           csv_batchos_entries_giclr207.tran_id_array;
   BEGIN
   str := csv_batchos_entries_giclr207.tran_id_to_array (p_tran_id, ',');
   FOR h IN 1 .. str.COUNT
      LOOP

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
         v_rec.gl_account := i.gl_acct;
         v_rec.gl_account_name := i.gl_acct_name;
         v_rec.debit_amount := trim(to_char(i.debit_amt, '999,999,999,990.00'));
         v_rec.credit_amount := trim(to_char(i.credit_amt, '999,999,999,990.00'));
         PIPE ROW (v_rec);
      END LOOP;
      end loop;
      
   END csv_giclr207;
   
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
END CSV_BATCHOS_ENTRIES_GICLR207;
/
