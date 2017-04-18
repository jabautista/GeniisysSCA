CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Quote_Bond_Basic_Pkg AS

  FUNCTION get_gipi_quote_bond_basic (p_quote_id   GIPI_QUOTE.quote_id%TYPE)
    RETURN gipi_quote_bond_basic_tab PIPELINED IS

	v_bond_basic 	 gipi_quote_bond_basic_type;

  BEGIN
    FOR i IN (
		SELECT a.quote_id,       a.obligee_no, 		 b.obligee_name,   a.bond_dtl,
			   a.indemnity_text, a.coll_flag, 		 a.contract_dtl,   a.prin_id,
			   c.prin_signor, 	 c.designation, 	 a.co_prin_sw, 	   a.clause_type,
			   e.clause_desc, 	 a.np_no, 			 d.np_name, 	   a.waiver_limit,
			   f.incept_date
  		  FROM GIPI_QUOTE_BOND_BASIC a,
		  	   GIIS_OBLIGEE b,
	   		   GIIS_PRIN_SIGNTRY c,
	   		   GIIS_NOTARY_PUBLIC d,
	   		   GIIS_BOND_CLASS_CLAUSE e,
			   GIPI_QUOTE f
	     WHERE a.quote_id = p_quote_id
   		   AND a.obligee_no = b.obligee_no (+)
   		   AND a.prin_id = c.prin_id (+)
   		   AND a.np_no = d.np_no (+)
   		   AND a.clause_type = e.clause_type (+)
		   AND a.quote_id = f.quote_id)
	LOOP
		v_bond_basic.quote_id                := i.quote_id;
	 	v_bond_basic.obligee_no        	  	 := i.obligee_no;
	 	v_bond_basic.obligee_name			 := i.obligee_name;
	 	v_bond_basic.bond_dtl				 := i.bond_dtl;
	 	v_bond_basic.indemnity_text			 := i.indemnity_text;
	 	v_bond_basic.coll_flag				 := i.coll_flag;
	 	v_bond_basic.contract_dtl			 := i.contract_dtl;
	 	v_bond_basic.prin_id				 := i.prin_id;
	 	v_bond_basic.prin_signor			 := i.prin_signor;
	 	v_bond_basic.designation			 := i.designation;
	 	v_bond_basic.co_prin_sw				 := i.co_prin_sw;
	 	v_bond_basic.clause_type			 := i.clause_type;
	 	v_bond_basic.clause_desc			 := i.clause_desc;
	 	v_bond_basic.np_no					 := i.np_no;
	 	v_bond_basic.np_name				 := i.np_name;
	 	v_bond_basic.waiver_limit			 := i.waiver_limit;
	 	v_bond_basic.incept_date			 := i.incept_date;
	  PIPE ROW(v_bond_basic);
	END LOOP;

    RETURN;
  END get_gipi_quote_bond_basic;


  PROCEDURE set_gipi_quote_bond_basic (
  	 v_quote_id              IN  GIPI_QUOTE_BOND_BASIC.quote_id%TYPE,
	 v_obligee_no        	 IN  GIPI_QUOTE_BOND_BASIC.obligee_no%TYPE,
	 v_bond_dtl				 IN  GIPI_QUOTE_BOND_BASIC.bond_dtl%TYPE,
	 v_indemnity_text		 IN  GIPI_QUOTE_BOND_BASIC.indemnity_text%TYPE,
	 v_coll_flag			 IN  GIPI_QUOTE_BOND_BASIC.coll_flag%TYPE,
	 v_contract_dtl			 IN  GIPI_QUOTE_BOND_BASIC.contract_dtl%TYPE,
	 v_prin_id				 IN  GIPI_QUOTE_BOND_BASIC.prin_id%TYPE,
	 v_co_prin_sw			 IN  GIPI_QUOTE_BOND_BASIC.co_prin_sw%TYPE,
	 v_clause_type			 IN  GIPI_QUOTE_BOND_BASIC.clause_type%TYPE,
	 v_np_no				 IN  GIPI_QUOTE_BOND_BASIC.np_no%TYPE,
	 v_waiver_limit			 IN  GIPI_QUOTE_BOND_BASIC.waiver_limit%TYPE,
	 v_contract_date		 IN  GIPI_QUOTE_BOND_BASIC.contract_date%TYPE)
  IS

  BEGIN

	MERGE INTO GIPI_QUOTE_BOND_BASIC
     USING dual ON (quote_id    = v_quote_id)
     WHEN NOT MATCHED THEN
         INSERT ( quote_id,         obligee_no, 	bond_dtl, 	    indemnity_text,
		 		  coll_flag, 		contract_dtl,   prin_id,  	  	co_prin_sw,
				  clause_type,  	np_no, 			waiver_limit, 	contract_date)
		 VALUES ( v_quote_id,       v_obligee_no, 	v_bond_dtl,     v_indemnity_text,
		 		  v_coll_flag, 		v_contract_dtl, v_prin_id,	    v_co_prin_sw,
				  v_clause_type,    v_np_no, 		v_waiver_limit, v_contract_date)
     WHEN MATCHED THEN
         UPDATE SET obligee_no        	 = obligee_no,
	 				bond_dtl			 = bond_dtl,
	 				indemnity_text		 = indemnity_text,
	 				coll_flag			 = coll_flag,
	 				contract_dtl		 = contract_dtl,
	 				prin_id				 = prin_id,
	 				co_prin_sw			 = co_prin_sw,
	 				clause_type			 = clause_type,
	 				np_no				 = np_no,
	 				waiver_limit		 = waiver_limit,
	 				contract_date		 = contract_date;
  END set_gipi_quote_bond_basic;


  PROCEDURE del_gipi_quote_bond_basic (p_quote_id    GIPI_QUOTE.quote_id%TYPE) IS

  BEGIN
	DELETE FROM GIPI_QUOTE_BOND_BASIC
     WHERE quote_id = p_quote_id;
  END del_gipi_quote_bond_basic;

   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  03.08.2010
   **  Reference By : (GIIMM011 - Quotation Bond Policy Data)
   **  Description  : get details for Bond Policy Data
   */
  FUNCTION get_gipi_quote_bond_basic2(p_quote_id   GIPI_QUOTE.quote_id%TYPE)
    RETURN gipi_quote_bond_basic_tab2 PIPELINED IS
	v_bond 	 gipi_quote_bond_basic_type2;
  BEGIN
    FOR a IN (
        SELECT a.quote_id,        a.obligee_no,     a.prin_id,
               a.val_period_unit, a.val_period,     a.coll_flag,
               a.clause_type,     a.np_no,          a.contract_dtl,
               a.contract_date,   a.co_prin_sw,     a.waiver_limit,
               a.indemnity_text,  a.bond_dtl,       a.endt_eff_date,
               a.remarks
          FROM GIPI_QUOTE_BOND_BASIC a
         WHERE a.quote_id = p_quote_id)
    LOOP
        v_bond.quote_id             := a.quote_id;
        v_bond.obligee_no           := a.obligee_no;
        v_bond.prin_id              := a.prin_id;
        v_bond.val_period_unit      := a.val_period_unit;
        v_bond.val_period           := a.val_period;
        v_bond.coll_flag            := a.coll_flag;
        v_bond.clause_type          := a.clause_type;
        v_bond.np_no                := a.np_no;
        v_bond.contract_dtl         := a.contract_dtl;
        v_bond.contract_date        := a.contract_date;
        v_bond.co_prin_sw           := a.co_prin_sw;
        v_bond.waiver_limit         := a.waiver_limit;
        v_bond.indemnity_text       := a.indemnity_text;
        v_bond.bond_dtl             := a.bond_dtl;
        v_bond.endt_eff_date        := a.endt_eff_date;
        v_bond.remarks              := a.remarks;
        PIPE ROW(v_bond);
	END LOOP;
    RETURN;
  END get_gipi_quote_bond_basic2;

   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  03.08.2010
   **  Reference By : (GIIMM011 - Quotation Bond Policy Data)
   **  Description  : insert records for Bond Policy Data
   */
  PROCEDURE set_gipi_quote_bond_basic2 (
  	p_quote_id                GIPI_QUOTE_BOND_BASIC.quote_id%TYPE,
    p_obligee_no              GIPI_QUOTE_BOND_BASIC.obligee_no%TYPE,
    p_prin_id                 GIPI_QUOTE_BOND_BASIC.prin_id%TYPE,
    p_val_period_unit         GIPI_QUOTE_BOND_BASIC.val_period_unit%TYPE,
    p_val_period              GIPI_QUOTE_BOND_BASIC.val_period%TYPE,
    p_coll_flag               GIPI_QUOTE_BOND_BASIC.coll_flag%TYPE,
    p_clause_type             GIPI_QUOTE_BOND_BASIC.clause_type%TYPE,
    p_np_no                   GIPI_QUOTE_BOND_BASIC.np_no%TYPE,
    p_contract_dtl            GIPI_QUOTE_BOND_BASIC.contract_dtl%TYPE,
    p_contract_date           GIPI_QUOTE_BOND_BASIC.contract_date%TYPE,
    p_co_prin_sw              GIPI_QUOTE_BOND_BASIC.co_prin_sw%TYPE,
    p_waiver_limit            GIPI_QUOTE_BOND_BASIC.waiver_limit%TYPE,
    p_indemnity_text          GIPI_QUOTE_BOND_BASIC.indemnity_text%TYPE,
    p_bond_dtl                GIPI_QUOTE_BOND_BASIC.bond_dtl%TYPE,
    p_endt_eff_date           GIPI_QUOTE_BOND_BASIC.endt_eff_date%TYPE,
    p_remarks                 GIPI_QUOTE_BOND_BASIC.remarks%TYPE
    ) IS
  BEGIN
	MERGE INTO GIPI_QUOTE_BOND_BASIC
     USING dual ON (quote_id    = p_quote_id)
     WHEN NOT MATCHED THEN
         INSERT (quote_id,        obligee_no,     prin_id,
                 val_period_unit, val_period,     coll_flag,
                 clause_type,     np_no,          contract_dtl,
                 contract_date,   co_prin_sw,     waiver_limit,
                 indemnity_text,  bond_dtl,       endt_eff_date,
                 remarks)
		 VALUES (p_quote_id,        p_obligee_no,     p_prin_id,
                 p_val_period_unit, p_val_period,     p_coll_flag,
                 p_clause_type,     p_np_no,          p_contract_dtl,
                 p_contract_date,   p_co_prin_sw,     p_waiver_limit,
                 p_indemnity_text,  p_bond_dtl,       p_endt_eff_date,
                 p_remarks)
     WHEN MATCHED THEN
         UPDATE SET obligee_no          = p_obligee_no,
                    prin_id             = p_prin_id,
                    val_period_unit     = p_val_period_unit,
                    val_period          = p_val_period,
                    coll_flag           = p_coll_flag,
                    clause_type         = p_clause_type,
                    np_no               = p_np_no,
                    contract_dtl        = p_contract_dtl,
                    contract_date       = p_contract_date,
                    co_prin_sw          = p_co_prin_sw,
                    waiver_limit        = p_waiver_limit,
                    indemnity_text      = p_indemnity_text,
                    bond_dtl            = p_bond_dtl,
                    endt_eff_date       = p_endt_eff_date,
                    remarks             = p_remarks;
  END set_gipi_quote_bond_basic2;

END Gipi_Quote_Bond_Basic_Pkg;
/


