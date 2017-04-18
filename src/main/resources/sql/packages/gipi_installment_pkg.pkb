CREATE OR REPLACE PACKAGE BODY CPI.gipi_installment_pkg
AS
   FUNCTION get_date_due (
      p_inst_no       gipi_installment.prem_seq_no%TYPE,
      p_prem_seq_no   gipi_installment.prem_seq_no%TYPE,
      p_iss_cd        gipi_installment.iss_cd%TYPE,
      p_tran_date     VARCHAR2
   )
      RETURN NUMBER
   IS
      daysdue   NUMBER;
   BEGIN
      BEGIN
         SELECT TO_DATE (p_tran_date, 'mm/dd/yyyy') - due_date
           INTO daysdue
           FROM gipi_installment
          WHERE inst_no = p_inst_no
            AND prem_seq_no = p_prem_seq_no
            AND iss_cd = p_iss_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      RETURN daysdue;
   END;

   FUNCTION get_inst_no_list (
      p_iss_cd        gipi_installment.iss_cd%TYPE,
      p_prem_seq_no   gipi_installment.prem_seq_no%TYPE
   )
      RETURN gipi_installment_inst_no_tab PIPELINED
   IS
      v_inst_no_tab   gipi_installment_list_type2;
   BEGIN
      FOR i IN (SELECT iss_cd, prem_seq_no, inst_no
                  FROM gipi_installment
                 WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no)
      LOOP
         v_inst_no_tab.iss_cd := i.iss_cd;
         v_inst_no_tab.prem_seq_no := i.prem_seq_no;
         v_inst_no_tab.inst_no := i.inst_no;
         PIPE ROW (v_inst_no_tab);
      END LOOP;

      RETURN;
   END;

/**
* Rey Jadlocon
* 08.05.2011
* payment schedule
*
* nieko 10242016 SR 5463, KB 2990, added NVL for tax amounts, ri_comm_vat, ri_comm_amt
**/
	FUNCTION get_payment_schedule (
		p_policy_id gipi_polbasic.policy_id%TYPE,
		p_item_no	gipi_item.item_no%TYPE,
		p_item_grp  gipi_item.item_grp%TYPE
	)
      RETURN payment_schedule_tab PIPELINED
    IS
		v_payment_schedule   payment_schedule_type;
	BEGIN
		FOR i IN(SELECT SUM(NVL(a.share_pct, 0)) total_shr,
                        SUM(NVL(a.prem_amt, 0)) total_prem,
                        SUM(NVL(a.tax_amt, 0)) total_tax,
                        SUM(NVL(a.tax_amt, 0) + NVL (a.prem_amt, 0)) total_tax_due,
						a.inst_no, a.due_date, TO_CHAR (a.due_date, 'MM-dd-rrrr') str_due_date, 
                        a.share_pct, a.prem_amt, a.tax_amt,
						NVL (a.tax_amt, 0) + NVL (a.prem_amt, 0) - (NVL(b.ri_comm_vat, 0) + NVL(b.ri_comm_amt, 0))total_due
                   FROM gipi_installment a, gipi_invoice b, gipi_item c
                  WHERE a.iss_cd = b.iss_cd
                    AND a.prem_seq_no = b.prem_seq_no
					AND b.policy_id = c.policy_id
                    AND b.item_grp = c.item_grp
                    AND b.policy_id = p_policy_id
					AND c.item_no = p_item_no -- marco - 09.06.2012 - to limit query
					AND c.item_grp = p_item_grp
                  GROUP BY a.iss_cd,
					    a.prem_seq_no,
					    a.inst_no,
					    a.due_date,
					    a.share_pct,
					    a.prem_amt,
						a.tax_amt,
                        b.ri_comm_vat,
                        b.ri_comm_amt)
        LOOP
			v_payment_schedule.total_shr := i.total_shr;
         	v_payment_schedule.total_prem := i.total_prem;
         	v_payment_schedule.total_tax := i.total_tax;
		 	v_payment_schedule.total_tax_due := i.total_tax_due;
		 	v_payment_schedule.inst_no := i.inst_no;
		 	v_payment_schedule.due_date := i.due_date;
            v_payment_schedule.str_due_date := i.str_due_date;
		 	v_payment_schedule.share_pct := i.share_pct;
		 	v_payment_schedule.prem_amt := i.prem_amt;
		 	v_payment_schedule.total_due := i.total_due;
		 	v_payment_schedule.tax_amt := i.tax_amt;
		 	PIPE ROW (v_payment_schedule);
		END LOOP
		RETURN;
	END get_payment_schedule;

/*
  **  Created by   :  Tonio
  **  Date Created :  08.22.2011
  **  Reference By : GICLS010 Claims Basic Info
  */  
   PROCEDURE get_unpaid_premiums_dtls ( 
      p_line_cd               gicl_claims.line_cd%TYPE,
      p_subline_cd            gicl_claims.subline_cd%TYPE,
      p_pol_iss_cd            gicl_claims.pol_iss_cd%TYPE,
      p_issue_yy              gicl_claims.issue_yy%TYPE,
      p_pol_seq_no            gicl_claims.pol_seq_no%TYPE,
      p_renew_no              gicl_claims.renew_no%TYPE,
      p_iss_cd                gicl_claims.iss_cd%TYPE,
      p_clm_file_date         varchar2,
      p_prem_seq_no     OUT   gipi_invoice.prem_seq_no%TYPE,
      p_balance_amt_due OUT   giac_aging_soa_details.balance_amt_due%TYPE,
      p_curr_type       OUT   varchar2,
      p_validate_unpaid OUT   varchar2,
      p_message         OUT   VARCHAR2
   )
   IS
      v_param_iss_cd      giac_parameters.param_value_v%TYPE;
      v_curr_type         giis_currency.currency_desc%TYPE;
   BEGIN
      --v_validate_clm := giacp.v ('VALIDATE_CLM_UNPAID_PREM');
      p_validate_unpaid := GIACP.V('VALIDATE_CLM_UNPAID_PREM');

      --variables.v_UnpaidFlag := 'Y';
      --variables.v_checkup := 0;
       p_balance_amt_due := 0;
      BEGIN
         SELECT param_value_v
           INTO v_param_iss_cd
           FROM giac_parameters
          WHERE param_name = 'RI_ISS_CD';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_message :=
                  'Parameter ''RI_ISS_CD'' does not exist in table GIAC_PARAMETERS. '
               || '**program unit -- CHECK_UNPAID_PREMIUMS**';
      END;

      IF p_iss_cd = v_param_iss_cd
      THEN                                                         
         FOR i IN (SELECT b.prem_seq_no, d.balance_due
                     FROM giac_aging_ri_soa_details d,
                          gipi_installment a,
                          gipi_invoice b,
                          gipi_polbasic c
                    WHERE d.inst_no = a.inst_no
                      AND d.prem_seq_no = b.prem_seq_no
                      AND a.due_date <= to_date(p_clm_file_date, 'mm-dd-yyyy')
                      AND a.iss_cd = b.iss_cd
                      AND a.prem_seq_no = b.prem_seq_no
                      AND b.policy_id = c.policy_id
                      AND b.policy_id = c.policy_id
                      AND c.line_cd = p_line_cd
                      AND c.subline_cd = p_subline_cd
                      AND c.iss_cd = p_pol_iss_cd
                      AND c.issue_yy = p_issue_yy
                      AND c.pol_seq_no = p_pol_seq_no
                      AND c.renew_no = p_renew_no)
         LOOP
            p_prem_seq_no := i.prem_seq_no;
            p_balance_amt_due := p_balance_amt_due + i.balance_due;
         END LOOP;

         /*SELECT DISTINCT (short_name)
                    INTO p_curr_type
                    FROM gipi_polbasic c, gipi_invoice b, giis_currency e
                   WHERE b.policy_id = c.policy_id
                     AND c.line_cd = p_line_cd
                     AND c.subline_cd = p_subline_cd
                     AND c.iss_cd = p_pol_iss_cd
                     AND c.issue_yy = p_issue_yy
                     AND c.pol_seq_no = p_pol_seq_no
                     AND c.renew_no = p_renew_no
                     AND e.main_currency_cd = b.currency_cd;*/ -- commented out - irwin 7.2.2012
      ELSE  
         FOR i IN
            (SELECT b.prem_seq_no, d.balance_amt_due
               FROM giac_aging_soa_details d,
                    gipi_installment a,
                    gipi_invoice b,
                    gipi_polbasic c
              WHERE d.inst_no = a.inst_no
                AND d.iss_cd = b.iss_cd
                AND d.prem_seq_no = b.prem_seq_no
                AND a.due_date <= to_date(p_clm_file_date, 'mm-dd-yyyy')
                AND a.iss_cd = b.iss_cd
                AND a.prem_seq_no = b.prem_seq_no
                AND b.policy_id = c.policy_id
                AND b.policy_id =
                       c.policy_id
                AND c.line_cd = p_line_cd
                AND c.subline_cd = p_subline_cd
                AND c.iss_cd = p_pol_iss_cd
                AND c.issue_yy = p_issue_yy
                AND c.pol_seq_no = p_pol_seq_no
                AND c.renew_no = p_renew_no)
         LOOP
            p_prem_seq_no := i.prem_seq_no;
            p_balance_amt_due := p_balance_amt_due + i.balance_amt_due;
         END LOOP;

         /*SELECT DISTINCT (short_name)
                    INTO p_curr_type
                    FROM gipi_polbasic c, gipi_invoice b, giis_currency e
                   WHERE b.policy_id = c.policy_id
                     AND c.line_cd = p_line_cd
                     AND c.subline_cd = p_subline_cd
                     AND c.iss_cd = p_pol_iss_cd
                     AND c.issue_yy = p_issue_yy
                     AND c.pol_seq_no = p_pol_seq_no
                     AND c.renew_no = p_renew_no
                     AND e.main_currency_cd = b.currency_cd;*/ -- commented out - irwin 7.2.2012
      END IF;
     /* ADDED BY : Jomar Diago
  ** DATE     : 06-01-2012
  ** NOTE     : This is to always follow the parameter DEFAULT_CURRENCY on GIAC_PARAMETERS.
  */
  SELECT param_value_v
    INTO p_curr_type
    FROM giac_parameters
   WHERE param_name = 'DEFAULT_CURRENCY';
  /* End addition by Jomar Diago 
  	added revision of joms -  irwin 7.2.2012
  */ 
      FOR i IN (SELECT collection_amt
                  FROM giac_pdc_prem_colln a, giac_apdc_payt_dtl b
                 WHERE a.pdc_id = b.pdc_id
                   AND iss_cd = p_pol_iss_cd
                   AND prem_seq_no = p_prem_seq_no
                   AND b.check_flag <> 'C')
      LOOP
         p_balance_amt_due := p_balance_amt_due - i.collection_amt;
      END LOOP;
   END get_unpaid_premiums_dtls;
   
   /*
  **  Created by   :  D.Alcantara
  **  Date Created :  04.02.2012
  **  Reference By : GIACS007 - CHK_INST_NO(program unit)
  */  
   PROCEDURE chk_inst_no_giacs007 (
        p_iss_cd             IN giac_direct_prem_collns.b140_iss_cd%TYPE,
        p_prem_seq_no        IN giac_direct_prem_collns.b140_prem_seq_no%TYPE,
        p_inst_no            IN OUT giac_direct_prem_collns.inst_no%TYPE,
        p_mesg               OUT VARCHAR2
    ) IS
        CURSOR C IS
          SELECT b150.inst_no
            FROM gipi_installment b150
           WHERE b150.iss_cd      = p_iss_cd
             AND b150.prem_seq_no = p_prem_seq_no
             AND b150.inst_no     = p_inst_no;
    BEGIN
        BEGIN
            OPEN C;
            FETCH C
                INTO   p_inst_no;
            IF C%NOTFOUND THEN
              p_mesg := 'No installment number found.';
            END IF;
            CLOSE C;
        END;
    END chk_inst_no_giacs007;
    
    /*
    **  Created by   :  Marie Kris Felipe
    **  Date Created :  09.10.2013
    **  Reference By : GIPIS137 - View Invoice Information
    **  Description : Retrieves Payment Term information based on the given iss_cd, prem_seq_no, and item_grp
    */  
    FUNCTION get_invoice_payterm(
        p_iss_cd        gipi_installment.iss_cd%TYPE,
        p_prem_seq_no   gipi_installment.prem_seq_no%TYPE,
        p_item_grp      gipi_installment.item_grp%TYPE
    ) RETURN invoice_payterm_tab PIPELINED
    IS
        v_payterm   invoice_payterm_type;
    BEGIN
    
        FOR rec IN (SELECT iss_cd, prem_seq_no, item_grp, inst_no,
                           share_pct, tax_amt, prem_amt, due_date
                      FROM GIPI_INSTALLMENT
                     WHERE iss_cd       = p_iss_cd
                       AND prem_seq_no  = p_prem_seq_no
                       AND item_grp     = p_item_grp)
        LOOP
            v_payterm.iss_cd := rec.iss_cd;
            v_payterm.prem_seq_no := rec.prem_seq_no;
            v_payterm.item_grp := rec.item_grp;
            v_payterm.inst_no := rec.inst_no;
            v_payterm.share_pct := rec.share_pct;
            v_payterm.tax_amt := rec.tax_amt;
            v_payterm.prem_amt := rec.prem_amt;
            v_payterm.due_date := TO_CHAR(rec.due_date, 'mm-dd-yyyy'); --TRUNC(rec.due_date); --TO_CHAR(rec.due_date, 'mm-dd-yyyy');
                        
            PIPE ROW(v_payterm);
        END LOOP;
    END get_invoice_payterm;
    
END gipi_installment_pkg;
/


