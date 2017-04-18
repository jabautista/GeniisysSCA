DROP FUNCTION CPI.GET_TAXES_PER_POLICY;

CREATE OR REPLACE FUNCTION CPI.Get_Taxes_Per_Policy (
/* rollie 21july200 @ FGIC
** return values (taxes and others) 
** according to paramater
** used in package P_UWREPORTS.tab1
*/
  p_taxes					  NUMBER,
  p_param_date				  NUMBER,
  p_acct_ent_date			  DATE,
  p_spld_acct_ent_date		  DATE,
  p_from_date				  DATE,
  p_to_date					  DATE,
  p_policy_id				  GIPI_POLBASIC.policy_id%TYPE,
  p_tsi_amt					  GIPI_POLBASIC.tsi_amt%TYPE,
  p_prem_amt				  GIPI_POLBASIC.prem_amt%TYPE) RETURN NUMBER
AS
  v_tsi_amt					  NUMBER(15);
  v_prem_amt				  NUMBER;
  v_spld_null 		          NUMBER;
  v_multiplier 			  	  NUMBER;
  v_evatprem 				  NUMBER;
  v_fst 					  NUMBER;
  v_lgt 					  NUMBER;
  v_doc_stamps				  NUMBER;
  v_other_taxes				  NUMBER;
  v_other_charges			  NUMBER;
BEGIN
  v_multiplier 			:=  1;
  v_tsi_amt	   	   	 	:= p_tsi_amt;
  v_prem_amt   	  	 	:= p_prem_amt;
  v_spld_null	        := 1;

  IF p_param_date = 4 THEN
     IF p_acct_ent_date BETWEEN p_from_date AND p_to_date
        AND p_spld_acct_ent_date BETWEEN p_from_date AND p_to_date THEN
        v_multiplier := 0;
     ELSIF p_acct_ent_date BETWEEN p_from_date AND p_to_date THEN
        v_multiplier := 1;
     ELSIF p_spld_acct_ent_date BETWEEN p_from_date AND p_to_date THEN
        v_multiplier := -1;
     END IF;
     v_tsi_amt   := p_tsi_amt  * v_multiplier;
   	 v_prem_amt  := p_prem_amt * v_multiplier;
	 v_spld_null := 2;
  END IF;

  IF p_taxes = 1 THEN
     RETURN (v_tsi_amt);
  END IF;
  IF p_taxes = 2 THEN
     RETURN (v_prem_amt);
  END IF;
  IF p_taxes = 3 THEN
     RETURN (v_spld_null);
  END IF;

  IF p_taxes = 4 THEN
	-- get defined taxes
  SELECT SUM(a.evat)
	INTO v_evatprem
	FROM (
		 SELECT DECODE(git.tax_cd,Giacp.n ('EVAT'),NVL(SUM (git.tax_amt * giv.currency_rt),0) * 1,0) +
				DECODE(git.tax_cd,Giacp.n ('5PREM_TAX'),NVL(SUM (git.tax_amt * giv.currency_rt),0) * 1,0) evat
		   FROM GIPI_INV_TAX git, GIPI_INVOICE giv
		  WHERE giv.iss_cd = git.iss_cd
			AND giv.prem_seq_no = git.prem_seq_no
			AND git.tax_cd   >= 0
			AND giv.item_grp  = git.item_grp
			AND giv.policy_id = p_policy_id
 		  GROUP BY git.tax_cd) a;
  RETURN (v_evatprem  * v_multiplier);
  END IF;

  IF p_taxes = 5 THEN
	-- get defined taxes
  SELECT SUM(a.fst)
	INTO v_fst
	FROM (
		 SELECT DECODE(git.tax_cd,Giacp.n ('FST'),NVL(SUM (git.tax_amt * giv.currency_rt),0) * 1,0) fst,
				DECODE(git.tax_cd,Giacp.n ('LGT'),NVL(SUM (git.tax_amt * giv.currency_rt),0) * 1,0) lgt,
				DECODE(git.tax_cd,Giacp.n ('DOC_STAMPS'),NVL(SUM (git.tax_amt * giv.currency_rt),0) * 1,0) doc_stamps
		   FROM GIPI_INV_TAX git, GIPI_INVOICE giv
		  WHERE giv.iss_cd = git.iss_cd
			AND giv.prem_seq_no = git.prem_seq_no
			AND git.tax_cd   >= 0
			AND giv.item_grp  = git.item_grp
			AND giv.policy_id = p_policy_id
 		  GROUP BY git.tax_cd) a;
  RETURN (v_fst * v_multiplier );
  END IF;

  IF p_taxes = 6 THEN
	-- get defined taxes
  SELECT SUM(a.lgt)
	INTO v_lgt
	FROM (
		 SELECT	DECODE(git.tax_cd,Giacp.n ('LGT'),NVL(SUM (git.tax_amt * giv.currency_rt),0) * 1,0) lgt
		   FROM GIPI_INV_TAX git, GIPI_INVOICE giv
		  WHERE giv.iss_cd = git.iss_cd
			AND giv.prem_seq_no = git.prem_seq_no
			AND git.tax_cd   >= 0
			AND giv.item_grp  = git.item_grp
			AND giv.policy_id = p_policy_id
 		  GROUP BY git.tax_cd) a;
  RETURN (v_lgt * v_multiplier );
  END IF;

  IF p_taxes = 7 THEN
	-- get defined taxes
  SELECT SUM(a.doc_stamps)
	INTO v_doc_stamps
	FROM (
		 SELECT	DECODE(git.tax_cd,Giacp.n ('DOC_STAMPS'),NVL(SUM (git.tax_amt * giv.currency_rt),0) * 1,0) doc_stamps
		   FROM GIPI_INV_TAX git, GIPI_INVOICE giv
		  WHERE giv.iss_cd = git.iss_cd
			AND giv.prem_seq_no = git.prem_seq_no
			AND git.tax_cd   >= 0
			AND giv.item_grp  = git.item_grp
			AND giv.policy_id = p_policy_id
 		  GROUP BY git.tax_cd) a;
  RETURN (v_doc_stamps * v_multiplier );
  END IF;

  IF p_taxes = 8 THEN
  -- get other taxes
  SELECT NVL(SUM (NVL (git.tax_amt, 0) * giv.currency_rt),0) * v_multiplier git_otax_amt
    INTO v_other_taxes
    FROM GIPI_INV_TAX git, GIPI_INVOICE giv
   WHERE giv.iss_cd = git.iss_cd
     AND giv.prem_seq_no = git.prem_seq_no
     AND giv.policy_id = p_policy_id
     AND NOT EXISTS ( SELECT gp.param_value_n
                        FROM GIAC_PARAMETERS gp
                       WHERE gp.param_name IN ('EVAT',
                                               '5PREM_TAX',
                                               'LGT',
                                               'DOC_STAMPS',
                                               'FST')
			             AND gp.param_value_n = git.tax_cd);
  RETURN (v_other_taxes);
  END IF;
  IF p_taxes = 9 THEN
  -- get other charges
  SELECT NVL(SUM (NVL (giv.other_charges, 0) * giv.currency_rt),0) * v_multiplier giv_otax_amt
    INTO v_other_charges
    FROM GIPI_INVOICE giv
   WHERE giv.policy_id = p_policy_id;
  RETURN (v_other_taxes);
  END IF;
  RETURN (NULL);
END;
/


