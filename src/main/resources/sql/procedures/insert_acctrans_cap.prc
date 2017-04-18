DROP PROCEDURE CPI.INSERT_ACCTRANS_CAP;

CREATE OR REPLACE PROCEDURE CPI.insert_acctrans_cap (
   p_gibr_gfun_fund_cd            giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
   p_gibr_branch_cd               giac_order_of_payts.gibr_branch_cd%TYPE,
   p_rev_tran_date                giac_acctrans.tran_date%TYPE,
   p_rev_tran_class_no            giac_acctrans.tran_class_no%TYPE,
   p_or_pref_suf         IN OUT   giac_order_of_payts.or_pref_suf%TYPE,
   p_or_no               IN OUT   giac_order_of_payts.or_no%TYPE,
   p_tran_id             IN OUT   giac_acctrans.tran_id%TYPE,
   p_message             OUT      VARCHAR2
)
IS
   CURSOR c1
   IS
      SELECT '1'
        FROM giis_funds
       WHERE fund_cd = p_gibr_gfun_fund_cd;

   CURSOR c2
   IS
      SELECT '2'
        FROM giac_branches
       WHERE branch_cd = p_gibr_branch_cd
         AND gfun_fund_cd = p_gibr_gfun_fund_cd;

   v_c1              VARCHAR2 (1);
   v_c2              VARCHAR2 (1);
   v_tran_id         giac_acctrans.tran_id%TYPE;
   v_last_update     giac_acctrans.last_update%TYPE;
   v_user_id         giac_acctrans.user_id%TYPE;
   v_closed_tag      giac_tran_mm.closed_tag%TYPE;
--  v_booked_tag     giis_booking_month.booked_tag%TYPE;
   v_tran_flag       giac_acctrans.tran_flag%TYPE;
   v_tran_class_no   giac_acctrans.tran_class_no%TYPE;
   v_particulars     giac_acctrans.particulars%TYPE;
   v_tran_date       giac_acctrans.tran_date%TYPE;
   v_tran_year       giac_acctrans.tran_year%TYPE;
   v_tran_month      giac_acctrans.tran_month%TYPE;
   v_tran_seq_no     giac_acctrans.tran_seq_no%TYPE;
BEGIN
   OPEN c1;

   FETCH c1
    INTO v_c1;

   IF c1%NOTFOUND
   THEN
      p_message := 'Invalid company code.';
   ELSE
      OPEN c2;

      FETCH c2
       INTO v_c2;

      IF c2%NOTFOUND
      THEN
         p_message := 'Invalid branch code.';
      END IF;

      CLOSE c2;
   END IF;

   CLOSE c1;

   -- If called by another form, display the corresponding OP
   -- record of the current tran_id when the button OP Info is
   -- pressed.
   BEGIN
      SELECT acctran_tran_id_s.NEXTVAL
        INTO p_tran_id
        FROM DUAL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_message := 'ACCTRAN_TRAN_ID sequence not found.';
   END;

   v_user_id := USER;
   v_tran_date := p_rev_tran_date;
   v_tran_class_no := p_rev_tran_class_no;
   v_tran_flag := 'C';
   v_particulars :=
         'To reverse entry for cancelled O.R. No.'
      || p_or_pref_suf
      || ' '
      || TO_CHAR (p_or_no)
      || '.';
   v_user_id := USER;
   v_tran_year := TO_NUMBER (TO_CHAR (v_tran_date, 'YYYY'));
   v_tran_month := TO_NUMBER (TO_CHAR (v_tran_date, 'MM'));
   v_tran_seq_no :=
      giac_sequence_generation (p_gibr_gfun_fund_cd,
                                p_gibr_branch_cd,
                                'ACCTRAN_TRAN_SEQ_NO',
                                v_tran_year,
                                v_tran_month
                               );

   INSERT INTO giac_acctrans
               (tran_id, gfun_fund_cd, gibr_branch_cd,
                tran_date, tran_flag, tran_class, tran_class_no,
                particulars, tran_year, tran_month, tran_seq_no,
                user_id, last_update
               )
        VALUES (p_tran_id, p_gibr_gfun_fund_cd, p_gibr_branch_cd,
                v_tran_date, v_tran_flag, 'CAP', v_tran_class_no,
                v_particulars, v_tran_year, v_tran_month, v_tran_seq_no,
                v_user_id, v_last_update
               );
--FORMS_DDL('COMMIT');
EXCEPTION
   WHEN OTHERS
   THEN
      NULL;
--CGTE$OTHER_EXCEPTIONS;
END insert_acctrans_cap;
/


