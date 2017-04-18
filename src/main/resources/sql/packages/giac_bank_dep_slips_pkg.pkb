CREATE OR REPLACE PACKAGE BODY CPI.giac_bank_dep_slips_pkg
AS
   FUNCTION get_gbds_list (
      p_gacc_tran_id   giac_bank_dep_slips.gacc_tran_id%TYPE,
      p_item_no        giac_bank_dep_slips.item_no%TYPE
   )
      RETURN gbds_list_tab PIPELINED
   IS
      /*
       **  Created by   :  Emman
       **  Date Created :  03.21.2011
       **  Reference By : (GIACS035 - Close DCB)
       **  Description  : Fetches the list of Bank and Cash Deposit Slips (GBDS and gbds block) in GIACS035
       */
      v_gbds_list   gbds_list_type;
   BEGIN
      FOR i IN (SELECT gbds.dep_id, gbds.dep_no, gbds.gacc_tran_id,
                       gbds.fund_cd, gbds.branch_cd, gbds.dcb_no,
                       gbds.dcb_year, gbds.item_no, gbds.check_class,
                       gbds.validation_dt,
                       gcur.short_name currency_short_name, gbds.amount,
                       gbds.foreign_curr_amt, gbds.currency_rt,
                       gbds.currency_cd
                  FROM giac_bank_dep_slips gbds, giis_currency gcur
                 WHERE gbds.gacc_tran_id =
                                      NVL (p_gacc_tran_id, gbds.gacc_tran_id)
                   AND gbds.item_no = p_item_no
                   AND gbds.currency_cd = gcur.main_currency_cd(+))
      LOOP
         v_gbds_list.dep_id := i.dep_id;
         v_gbds_list.dep_no := i.dep_no;
         v_gbds_list.gacc_tran_id := i.gacc_tran_id;
         v_gbds_list.fund_cd := i.fund_cd;
         v_gbds_list.branch_cd := i.branch_cd;
         v_gbds_list.dcb_no := i.dcb_no;
         v_gbds_list.dcb_year := i.dcb_year;
         v_gbds_list.item_no := i.item_no;
         v_gbds_list.check_class := i.check_class;
         v_gbds_list.validation_dt := i.validation_dt;
         v_gbds_list.currency_short_name := i.currency_short_name;
         v_gbds_list.amount := i.amount;
         v_gbds_list.foreign_curr_amt := i.foreign_curr_amt;
         v_gbds_list.currency_rt := i.currency_rt;
         v_gbds_list.currency_cd := i.currency_cd;
         PIPE ROW (v_gbds_list);
      END LOOP;
   END get_gbds_list;

   PROCEDURE set_giac_bank_dep_slips (
      p_dep_id             giac_bank_dep_slips.dep_id%TYPE,
      p_dep_no             giac_bank_dep_slips.dep_no%TYPE,
      p_gacc_tran_id       giac_bank_dep_slips.gacc_tran_id%TYPE,
      p_item_no            giac_bank_dep_slips.item_no%TYPE,
      p_fund_cd            giac_bank_dep_slips.fund_cd%TYPE,
      p_branch_cd          giac_bank_dep_slips.branch_cd%TYPE,
      p_dcb_no             giac_bank_dep_slips.dcb_no%TYPE,
      p_dcb_year           giac_bank_dep_slips.dcb_year%TYPE,
      p_check_class        giac_bank_dep_slips.check_class%TYPE,
      p_validation_dt      giac_bank_dep_slips.validation_dt%TYPE,
      p_amount             giac_bank_dep_slips.amount%TYPE,
      p_foreign_curr_amt   giac_bank_dep_slips.foreign_curr_amt%TYPE,
      p_currency_rt        giac_bank_dep_slips.currency_rt%TYPE,
      p_currency_cd        giac_bank_dep_slips.currency_cd%TYPE
   )
   IS
      v_dep_id   NUMBER;
   BEGIN
      IF p_dep_id IS NULL OR p_dep_id = 0  -- added by Halley 12.17.13
      THEN
	      FOR b IN (SELECT MAX (dep_id) dep_id
	                  FROM giac_bank_dep_slips)
	      LOOP
	         v_dep_id := b.dep_id;
	         EXIT;
	      END LOOP;

	      IF v_dep_id IS NULL
	      THEN
	         v_dep_id := 1;
	      ELSE
	         v_dep_id := v_dep_id + 1;
	      END IF;
      ELSE
        v_dep_id := p_dep_id;  -- added by Halley 12.17.13
      END IF;

      MERGE INTO giac_bank_dep_slips
         USING DUAL
         ON (    dep_id = v_dep_id
             AND gacc_tran_id = p_gacc_tran_id
             AND item_no = p_item_no)
         WHEN NOT MATCHED THEN
            INSERT (dep_id, dep_no, gacc_tran_id, item_no, fund_cd, branch_cd,
                    dcb_no, dcb_year, check_class, validation_dt, amount,
                    foreign_curr_amt, currency_rt, currency_cd)
            VALUES (v_dep_id, p_dep_no, p_gacc_tran_id, p_item_no, p_fund_cd,
                    p_branch_cd, p_dcb_no, p_dcb_year, p_check_class,
                    p_validation_dt, p_amount, p_foreign_curr_amt,
                    p_currency_rt, p_currency_cd)
         WHEN MATCHED THEN
            UPDATE
               SET dep_no = p_dep_no, fund_cd = p_fund_cd,
                   branch_cd = p_branch_cd, dcb_no = p_dcb_no,
                   dcb_year = p_dcb_year, check_class = p_check_class,
                   validation_dt = p_validation_dt, amount = p_amount,
                   foreign_curr_amt = p_foreign_curr_amt,
                   currency_rt = p_currency_rt, currency_cd = p_currency_cd
            ;
   END set_giac_bank_dep_slips;

   PROCEDURE del_giac_bank_dep_slips (
      p_dep_id         giac_bank_dep_slips.dep_id%TYPE,
      p_gacc_tran_id   giac_bank_dep_slips.gacc_tran_id%TYPE,
      p_item_no        giac_bank_dep_slips.item_no%TYPE
   )
   IS
   BEGIN
      DELETE FROM giac_bank_dep_slips
            WHERE dep_id = p_dep_id
              AND gacc_tran_id = p_gacc_tran_id
              AND item_no = p_item_no;
   END del_giac_bank_dep_slips;
END giac_bank_dep_slips_pkg;
/


