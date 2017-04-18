DROP PROCEDURE CPI.UPDATE_GIRI_BINDER;

CREATE OR REPLACE PROCEDURE CPI.Update_Giri_Binder(prod_cut_off_date DATE, cut_off_date DATE) IS
  v_dummy        NUMBER:=0;
  var_count_row  NUMBER:= 0;
BEGIN
  /* janet ang  february, 2000 */
  /* specs -- binders to be taken up
  ** 1.  positively take up binders whose policy has been taken up = gipi_polbasic.acct_ent_date <= cut_off_date
  ** 2.  positively take up binders whose distribution has been taken up = giuw_pol_dist.acct_ent_date <= cut_off_date
  ** 3.  negatively take up the binders which were reversed = giri_frps_ri.reverse_sw = 'Y' and acc_rev_date is null
  **     and acc_ent_date is not null
  ** 4.  negatively take up binders whose giuw_pol_dist.dist_flag = '5' = redistributed and giri_binder.acct_ent_date is not null
  ** 5.  negatively take up binders whose policy has been spoiled = gipi_polbasic.spld_acct_ent_date <= cut_off_date
  ** 6.  negatively take up binders whose giri_binder.replaced_flag = 'Y' and giri_binder.acct_ent_date is not null
  **     and giri_frps_ri.reverse_sw != 'Y'
  */
  var_count_row := 0;
  FOR ja1 IN (
    SELECT c.fnl_binder_id, c.acc_ent_date, c.acc_rev_date, c.replaced_flag,
          b.reverse_sw, f.acct_ent_date, f.acct_neg_date, f.dist_flag, g.spld_acct_ent_date
    FROM GIRI_FRPERIL a,
         GIRI_FRPS_RI b,
         GIRI_BINDER c,
         GIRI_DISTFRPS d,
         GIUW_POLICYDS e,
         GIUW_POL_DIST f,
         GIPI_POLBASIC g,
         GIPI_COMM_INVOICE h
    WHERE 1=1
      AND a.line_cd       = b.line_cd
      AND a.frps_yy       = b.frps_yy
      AND a.frps_seq_no   = b.frps_seq_no
      AND a.ri_seq_no     = b.ri_seq_no
      AND b.fnl_binder_id = c.fnl_binder_id
      AND b.line_cd       = d.line_cd
      AND b.frps_yy       = d.frps_yy
      AND b.frps_seq_no   = d.frps_seq_no
      AND d.dist_no       = e.dist_no
      AND d.dist_seq_no   = e.dist_seq_no
      AND e.dist_no       = f.dist_no
      AND f.policy_id     = g.policy_id
      AND g.policy_id     = h.policy_id(+)
      AND g.policy_id = 12245
      AND f.acct_ent_date IS NOT NULL				/* this will fetch taken up distributions */
      AND f.acct_ent_date <= prod_cut_off_date 		/* this will fetch taken up distributions */
      AND g.acct_ent_date IS NOT NULL				/* this will fetch taken up policies */
      AND g.acct_ent_date <= prod_cut_off_date 		/* this will fetch taken up policies */
      AND EXISTS (SELECT 'x'
	                FROM GIUW_POL_DIST gpd
				   WHERE gpd.dist_no      = d.dist_no
                     AND gpd.acct_ent_date IS NOT NULL)
      AND c.acc_rev_date IS NULL                              ) LOOP
--    group by c.acc_ent_date, c.acc_rev_date, b.reverse_sw, g.iss_Cd, g.line_cd,
--        g.subline_cd, a.peril_cd) loop
    var_count_row := var_count_row + 1;
    dbms_output.put_line('Working. Please wait. Currently reading '|| TO_CHAR(var_count_row) ||' records.');
    IF ja1.acc_ent_date IS NULL
       AND ja1.acc_rev_date IS NULL
       AND (NVL(ja1.reverse_sw,'N') != 'Y' OR NVL(ja1.replaced_flag,'N') != 'Y')
       AND ja1.acct_ent_date IS NOT NULL THEN
       UPDATE GIRI_BINDER
       SET acc_ent_date = cut_off_date
       WHERE fnl_binder_id = ja1.fnl_binder_id;
    ELSIF ja1.acc_ent_date IS NOT NULL
       AND ja1.acc_rev_date IS NULL
       AND ja1.reverse_sw = 'Y'
       AND ja1.acct_ent_date IS NOT NULL THEN
       IF TRUNC(ja1.acc_ent_date)  < TRUNC(prod_cut_off_date) THEN
         /* to disallow reversal of binders whose acc_ent_date > reversal date */
         UPDATE GIRI_BINDER
         SET acc_rev_date = cut_off_date
         WHERE fnl_binder_id = ja1.fnl_binder_id;
       END IF;
    ELSIF ja1.acc_ent_date IS NOT NULL
       AND ja1.acc_rev_date IS NULL
       AND ja1.reverse_sw != 'Y'
       AND ja1.dist_flag = '5' THEN
       /* to take up binders of part of the redistributed distributions */
           UPDATE GIRI_BINDER
           SET acc_rev_date = cut_off_date
           WHERE fnl_binder_id = ja1.fnl_binder_id;
    ELSIF ja1.acc_ent_date IS NOT NULL
       AND ja1.acc_rev_date IS NULL
       AND ja1.reverse_sw != 'Y'
       AND ja1.spld_acct_ent_date IS NOT NULL THEN
       /* to take up binders of spoiled policies */
         IF TRUNC(ja1.spld_acct_ent_date) <= TRUNC(prod_cut_off_date) THEN
           UPDATE GIRI_BINDER
           SET acc_rev_date = cut_off_date
           WHERE fnl_binder_id = ja1.fnl_binder_id;
         END IF;
    ELSIF ja1.acc_ent_date IS NOT NULL
       AND ja1.acc_rev_date IS NULL
       AND ja1.reverse_sw != 'Y'
       AND ja1.replaced_flag = 'Y' THEN
         UPDATE GIRI_BINDER
         SET acc_rev_date = cut_off_date
         WHERE fnl_binder_id = ja1.fnl_binder_id;
    END IF;
  --  message('Working. Please wait. Currently reading '|| to_char(variables.var_count_row) ||' records.',no_acknowledge);
  END LOOP;
  var_count_row := 0;
END;
/


