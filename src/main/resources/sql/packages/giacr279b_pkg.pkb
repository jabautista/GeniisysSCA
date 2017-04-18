CREATE OR REPLACE PACKAGE BODY CPI.giacr279b_pkg
AS
   FUNCTION get_giacr279b_company_name
      RETURN VARCHAR2
   IS
      v_company_name   VARCHAR2 (200);
   BEGIN
      SELECT param_value_v company_name
        INTO v_company_name
        FROM giac_parameters
       WHERE param_name = 'COMPANY_NAME';

      RETURN (v_company_name);
   END get_giacr279b_company_name;

   FUNCTION get_giacr279b_company_address
      RETURN VARCHAR2
   IS
      v_company_address   VARCHAR2 (200);
   BEGIN
      SELECT param_value_v company_address
        INTO v_company_address
        FROM giac_parameters
       WHERE param_name = 'COMPANY_ADDRESS';

      RETURN (v_company_address);
   END get_giacr279b_company_address;

   FUNCTION get_giacr279b_loss_exp (
        p_payee_type    VARCHAR2, 
        p_payee_type2   VARCHAR2
   ) RETURN CHAR
   IS
      cp_loss_exp   VARCHAR2 (50);
   BEGIN
      IF p_payee_type LIKE 'L' AND p_payee_type2 IS NULL THEN
         cp_loss_exp := '(LOSS)';
      ELSIF p_payee_type LIKE 'E' AND p_payee_type2 IS NULL THEN
         cp_loss_exp := '(EXPENSE)';
      END IF;

      RETURN (cp_loss_exp);
   END get_giacr279b_loss_exp;

   FUNCTION get_giacr279b_as_of (
        p_as_of_date DATE
   )  RETURN CHAR
   IS
      v_var   VARCHAR2 (100);
   BEGIN
      v_var := 'As of ' || TO_CHAR (p_as_of_date, 'fmMonth DD,YYYY');
      RETURN (v_var);
   END get_giacr279b_as_of;

   FUNCTION get_giacr279b_cut_off (
        p_cut_off_date DATE
   ) RETURN CHAR
   IS
      v_var   VARCHAR2 (100);
   BEGIN
      v_var := 'Cut-off ' || TO_CHAR (p_cut_off_date, 'fmMonth DD,YYYY');
      RETURN (v_var);
   END get_giacr279b_cut_off;

   FUNCTION get_giacr279b_amt_due (
        v_currency_cd       NUMBER, 
        v_amount_due        NUMBER, 
        v_orig_curr_rate    NUMBER
   ) RETURN NUMBER
   IS
      v_curr_rate   NUMBER;
   BEGIN
      IF v_currency_cd = giacp.n ('CURRENCY_CD') THEN
         v_curr_rate := v_amount_due * v_orig_curr_rate;
      ELSIF v_currency_cd <> giacp.n ('CURRENCY_CD') THEN
         v_curr_rate := v_amount_due;
      END IF;

      RETURN (v_curr_rate);
   END get_giacr279b_amt_due;

   FUNCTION get_giacr279b_records (
        p_as_of_date        VARCHAR2, 
        p_cut_off_date      VARCHAR2, 
        p_line_cd           VARCHAR2, 
        p_payee_type        VARCHAR2, 
        p_payee_type2       VARCHAR2, 
        p_ri_cd             VARCHAR2, 
        p_user_id           VARCHAR2
    ) RETURN giacr279b_record_tab PIPELINED
   IS
      v_list           giacr279b_record_type;
      v_as_of_date     DATE                  := TO_DATE (p_as_of_date, 'MM/DD/RRRR');
      v_cut_off_date   DATE                  := TO_DATE (p_cut_off_date, 'MM/DD/RRRR');
      v_no_record      BOOLEAN := TRUE;
   BEGIN
      
        v_list.company_name := get_giacr279b_company_name;
        v_list.company_address := get_giacr279b_company_address;
        v_list.loss_exp := get_giacr279b_loss_exp (p_payee_type, p_payee_type2);
        v_list.as_of := get_giacr279b_as_of (v_as_of_date);
        v_list.cut_off := get_giacr279b_cut_off (v_cut_off_date);
        v_list.print_band := 'N';
      
        FOR i IN (SELECT a.ri_cd, a.ri_name, a.line_cd, a.line_name, a.claim_no, a.fla_no, a.policy_no, a.assd_name, a.fla_date, 
                         a.as_of_date, a.cut_off_date, a.payee_type, a.amount_due, a.currency_cd, a.assd_no, --add assd_no CarloR SR-5351 06.27.2016
                         a.orig_curr_rate, a.convert_rate, b.short_name
                    FROM giac_loss_rec_soa_ext a, giis_currency b
                   WHERE 1 = 1
                     AND a.amount_due <> 0
                     AND a.orig_curr_cd = b.main_currency_cd
                     AND a.user_id = p_user_id
                     AND a.as_of_date = v_as_of_date
                     AND a.cut_off_date = v_cut_off_date
                     AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND (payee_type = p_payee_type                                                                                                                               --added by nestor2192008
                          OR payee_type = p_payee_type2))
        LOOP
             v_no_record := FALSE;
             v_list.print_band := 'Y';
             v_list.ri_cd := i.ri_cd;
             v_list.ri_name := i.ri_name;
             v_list.line_cd := i.line_cd;
             v_list.line_name := i.line_name;
             v_list.claim_no := i.claim_no;
             v_list.fla_no := i.fla_no;
             v_list.policy_no := i.policy_no;
             v_list.assd_no := i.assd_no; --CarloR SR-5351 06.27.2016
             v_list.assd_name := i.assd_name;
             v_list.fla_date := i.fla_date;
             v_list.as_of_date := i.as_of_date;
             v_list.cut_off_date := i.cut_off_date;
             v_list.payee_type := i.payee_type;
             v_list.amount_due := i.amount_due;
             v_list.currency_cd := i.currency_cd;
             v_list.orig_curr_rate := i.orig_curr_rate;
             v_list.convert_rate := i.convert_rate;
             v_list.short_name := i.short_name;
             v_list.amt_due := get_giacr279b_amt_due (i.currency_cd, i.amount_due, i.orig_curr_rate);
             PIPE ROW (v_list);
        END LOOP;
      
        IF (v_no_record) THEN
            PIPE ROW(v_list);
        END IF;
   END get_giacr279b_records;
END;
/


