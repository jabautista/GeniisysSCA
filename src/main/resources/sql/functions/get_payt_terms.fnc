DROP FUNCTION CPI.GET_PAYT_TERMS;

CREATE OR REPLACE FUNCTION CPI.get_payt_terms (
	v_iss_cd IN gipi_invoice.iss_cd%TYPE,
	v_prem_seq_no IN gipi_invoice.prem_seq_no%TYPE
) RETURN NUMBER
AS
	v_policy_id			gipi_polbasic.policy_id%TYPE;
	v_count				NUMBER; 	/* no. of take-up */
	v_variable			VARCHAR2(1) := 'N';
	v_expiry_date		gipi_polbasic.expiry_date%TYPE;
	v_incept_date		gipi_polbasic.incept_date%TYPE;
	v_old_expiry_date	gipi_polbasic.expiry_date%TYPE;
	v_old_incept_date	gipi_polbasic.incept_date%TYPE;
	v_exist				VARCHAR2(1) := 'N';
	v_is_longterm		BOOLEAN := FALSE;
	v_no_of_payment		NUMBER;
	v_no_of_days		giis_payterm.no_of_days%TYPE;
	v_no_payt_days		NUMBER;
	v_no_of_days_again	giis_payterm.no_of_days%TYPE; 	/* temporary storage of no. of days */
	var_no_of_payt		giis_payterm.no_of_payt%TYPE;
	v_policy_days		NUMBER;
	v_exact_no_of_payment	NUMBER; 	/* used for computation of intervals */
BEGIN
	BEGIN
		SELECT policy_id
		  INTO v_policy_id
		  FROM gipi_invoice
		 WHERE iss_cd = v_iss_cd
		   AND prem_seq_no = v_prem_seq_no;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			v_policy_id := 0;
	END;

	FOR x IN (SELECT MAX(takeup_seq_no) takeup_seq
		    FROM gipi_invoice
		   WHERE policy_id = v_policy_id)
	LOOP
		v_count := x.takeup_seq;
	END LOOP;

	IF v_count > 1 THEN
		v_variable := 'Y';
	END IF;

	FOR y IN (SELECT eff_date, endt_expiry_date, expiry_date
		    FROM gipi_polbasic
		   WHERE policy_id = v_policy_id)
	LOOP
		IF y.endt_expiry_date IS NULL THEN
			v_expiry_date := y.expiry_date;
			v_incept_date := y.eff_date;
			v_old_expiry_date := y.expiry_date;
			v_old_incept_date := y.eff_date;
		ELSE
			v_expiry_date := y.endt_expiry_date;
			v_incept_date := y.eff_date;
			v_old_expiry_date := y.endt_expiry_date;
			v_old_incept_date := y.eff_date;
		END IF;
		EXIT;
	END LOOP;

	FOR z IN (SELECT a.no_of_days, a.no_of_payt,
					 a.annual_sw, a.on_incept_tag, a.no_payt_days,
					 b.prem_amt, b.other_charges, b.due_date,
					 b.item_grp, b.takeup_seq_no, b.payt_terms
				FROM giis_payterm a, gipi_invoice b
			   WHERE b.policy_id = v_policy_id
				 AND a.payt_terms = b.payt_terms
			ORDER BY b.item_grp, b.takeup_seq_no)
	LOOP
		IF v_variable = 'Y' THEN
			FOR x IN (SELECT takeup_seq_no, due_date
				    FROM gipi_invoice
				   WHERE policy_id = v_policy_id
				     AND takeup_seq_no = z.takeup_seq_no + 1)
			LOOP
				v_exist := 'Y';
				v_incept_date := z.due_date;
				v_expiry_date := z.due_date;
			END LOOP;

			IF v_exist = 'N' THEN
				v_expiry_date := v_old_expiry_date;
			END IF;
		END IF;

		IF z.takeup_seq_no > 1 THEN
			v_is_longterm := TRUE;
		END IF;

		/***
		****
		***/

		v_no_of_payment := 0;
		v_no_of_days := NVL(z.no_of_days,0);

		IF NVL(z.on_incept_tag,'N') = 'N' THEN
			v_no_of_days_again := 0;
		ELSE
			v_no_of_days_again := NVL(z.no_of_days,0);
		END IF;

		var_no_of_payt := z.no_of_payt;
		v_no_payt_days := z.no_payt_days;

		IF TRUNC(v_expiry_date - v_incept_date) = 31 THEN
			v_policy_days := 30;
		ELSE
			v_policy_days := TRUNC(v_expiry_date - v_incept_date);
		END IF;

		IF NVL(z.annual_sw,'N') = 'N' THEN
			IF v_no_payt_days IS NOT NULL THEN
				IF v_no_payt_days < v_policy_days - v_no_of_days THEN
					IF v_no_payt_days < var_no_of_payt THEN
						v_no_of_payment := var_no_of_payt;
					ELSE
						v_no_of_payment := ROUND(((v_policy_days - v_no_of_days) * var_no_of_payt) / v_no_payt_days);
					END IF;
				ELSE
					IF v_policy_days - v_no_of_days < var_no_of_payt THEN
						v_no_of_payment := v_policy_days - v_no_of_days;
					ELSE
						v_no_of_payment := ROUND(((v_policy_days - v_no_of_days) * var_no_of_payt) / v_no_payt_days);
					END IF;
				END IF;
				v_exact_no_of_payment := v_no_of_payment;
			ELSE
				IF v_policy_days - v_no_of_days < var_no_of_payt THEN
					v_no_of_payment := v_policy_days - v_no_of_days;
				ELSE
					v_no_of_payment := var_no_of_payt;
				END IF;
			END IF;
		ELSE
			IF TRUNC((v_policy_days - v_no_of_days) / 365, 2) * var_no_of_payt > TRUNC(TRUNC((v_policy_days - v_no_of_days) / 365, 2) * var_no_of_payt) THEN
				v_no_of_payment := TRUNC(TRUNC((v_policy_days - v_no_of_days) / 365, 3) * var_no_of_payt) + 1;
			ELSE
				v_no_of_payment := TRUNC(TRUNC((v_policy_days - v_no_of_days) / 365, 3) * var_no_of_payt);
			END IF;
			IF TRUNC((v_policy_days - v_no_of_days) / 365, 4) * var_no_of_payt < 1 THEN
				v_exact_no_of_payment := 1;
			ELSE
				v_exact_no_of_payment := TRUNC((v_policy_days - v_no_of_days) / 365, 4) * var_no_of_payt;
			END IF;
		END IF;

		IF v_no_of_payment < 1 THEN
			v_no_of_payment := 1;
		END IF;
	END LOOP;

	RETURN v_no_of_payment;
END;


--CREATE OR REPLACE PUBLIC SYNONYM GET_PAYT_TERMS FOR CPI.GET_PAYT_TERMS;
/


