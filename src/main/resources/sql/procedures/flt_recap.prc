DROP PROCEDURE CPI.FLT_RECAP;

CREATE OR REPLACE PROCEDURE CPI.flt_recap (p_fm_date  DATE,
                                   p_to_date  DATE)
AS
-- EXEC recap(TO_DATE('1/1/2002','mm/dd/yyyy'),TO_DATE('1/31/2002','mm/dd/yyyy'));
/*
** Modified by: Michaell 030112003
** Remarks    : Taken from the procedure created by Boyet on the 815 database.
**              This was modified so as to be used in 734 database
**
*/
  v_iss_cd              giac_recap_dtl_ext.iss_cd%TYPE;
  v_line_cd             giac_recap_dtl_ext.line_cd%TYPE;
  v_subline_cd          giac_recap_dtl_ext.subline_cd%TYPE;
  v_policy_id           giac_recap_dtl_ext.policy_id%TYPE;
  v_peril_cd            giac_recap_dtl_ext.peril_cd%TYPE;
  v_tariff_cd           giac_recap_dtl_ext.tariff_cd%TYPE;
  v_subline_type_cd     giac_recap_dtl_ext.subline_type_cd%TYPE;
  v_bond_class_subline  giac_recap_dtl_ext.bond_class_subline%TYPE;
  v_premium_amt         giac_recap_dtl_ext.premium_amt%TYPE;
  v_commission_amt      giac_recap_dtl_ext.commission_amt%TYPE;
  v_tsi_amt             giac_recap_dtl_ext.tsi_amt%TYPE;
  v_ri_cd               giac_recap_dtl_ext.ri_cd%TYPE;
  v_local_foreign_sw    giac_recap_dtl_ext.local_foreign_sw%TYPE;
  v_treaty_prem         giac_recap_dtl_ext.treaty_prem%TYPE;
  v_treaty_tsi          giac_recap_dtl_ext.treaty_tsi%TYPE;
  v_treaty_comm         giac_recap_dtl_ext.treaty_comm%TYPE;
  v_facul_prem          giac_recap_dtl_ext.facul_prem%TYPE;
  v_facul_tsi           giac_recap_dtl_ext.facul_tsi%TYPE;
  v_facul_comm          giac_recap_dtl_ext.facul_comm%TYPE;
  v_inw_ri_comm         giac_recap_dtl_ext.inw_ri_comm%TYPE;
  v_item_no             gipi_fireitem.item_no%TYPE;
  v_fm_treaty_year             giac_treaty_cessions.cession_year%TYPE;
  v_fm_treaty_mm               giac_treaty_cessions.cession_mm%TYPE;
  v_to_treaty_year             giac_treaty_cessions.cession_year%TYPE;
  v_to_treaty_mm               giac_treaty_cessions.cession_mm%TYPE;
  v_sdate                      VARCHAR2(4);
  v_ndate                      NUMBER(4);
  v_cnt                        NUMBER(12);
  v_acct_ent_date              gipi_polbasic.acct_ent_date%TYPE;
  v_fi_line_cd                 gipi_polbasic.line_cd%TYPE;
  v_fi_li_cd_exs               BOOLEAN := FALSE;
  v_mc_li_cd_exs               BOOLEAN := FALSE;
  v_mc_line_cd                 gipi_polbasic.line_cd%TYPE;
  v_currency_rt                gipi_item.currency_rt%TYPE;
  v_acc_rev_date               giri_binder.acc_rev_date%TYPE;
  v_sum_comm_amt         giac_recap_dtl_flt_ext.commission_amt%TYPE;
  v_premprl              giac_recap_dtl_flt_ext.premium_amt%type;
  v_premitm              giac_recap_dtl_flt_ext.premium_amt%type;
  v_comm_pip             giac_recap_dtl_flt_ext.commission_amt%type;
  v_prev_polid           giac_recap_dtl_flt_ext.policy_id%type;
BEGIN
  --Set the treaty year and treaty month (from to)
  v_fm_treaty_year := TO_NUMBER(TO_CHAR(p_fm_date,'yyyy'));
  v_fm_treaty_mm   := TO_NUMBER(TO_CHAR(p_fm_date,'mm'));
  v_to_treaty_year := TO_NUMBER(TO_CHAR(p_to_date,'yyyy'));
  v_to_treaty_mm   := TO_NUMBER(TO_CHAR(p_to_date,'mm'));

  --Get the line_cd for FIRE
  FOR lcfi IN (SELECT substr(param_value_v,1,2) li_cd
                 FROM giis_parameters
                WHERE param_name = 'LINE_CODE_FI')
  LOOP
     v_fi_line_cd := lcfi.li_cd;
     v_fi_li_cd_exs := TRUE;
     EXIT;
  END LOOP;
  --Check existence
  IF v_fi_li_cd_exs = FALSE THEN
     RAISE_APPLICATION_ERROR(-20101,'Line code for fire is not found in giis_parameters.');
  END IF;

  --Get the line_cd for MOTORCAR
  FOR lcmc IN (SELECT substr(param_value_v,1,2) li_cd
                 FROM giis_parameters
                WHERE param_name = 'LINE_CODE_MC')
  LOOP
     v_mc_line_cd := lcmc.li_cd;
     v_mc_li_cd_exs := TRUE;
     EXIT;
  END LOOP;
  --Check existence
  IF v_mc_li_cd_exs = FALSE THEN
     RAISE_APPLICATION_ERROR(-20101,'Line code for motorcar is not found in giis_parameters.');
  END IF;

  --Main Loop for direct
  FOR drct IN (  SELECT pol.iss_cd,
                        pol.line_cd,
                        pol.subline_cd,
                        pol.policy_id,
                        ipr.peril_cd,
                        NULL tariff_cd,
                        NULL subline_type_cd,
                        NULL comm_amt,
                        DECODE((SIGN(p_fm_date - pol.acct_ent_date) * 4)
                               + SIGN(NVL(pol.spld_acct_ent_date, p_to_date+60) - p_to_date),
			       1, 1,
			      -3, 1,
			       3,-1,
			       4,-1, 0) * (ipr.prem_amt * itm.currency_rt) premium_amt,
		        DECODE( (SIGN(p_fm_date - pol.acct_ent_date) * 4)
                               + SIGN(NVL(pol.spld_acct_ent_date, p_to_date+60) - p_to_date),
			       1, 1,
			      -3, 1,
			       3,-1,
			       4,-1, 0) * (ipr.tsi_amt  * itm.currency_rt) tsi_amt,
                        ipr.ri_comm_amt,
                        ipr.item_no
                   FROM gipi_item       itm,
                        gipi_itmperil   ipr,
                        gipi_polbasic   pol
                  WHERE 1=1
                    AND (   (    TRUNC(pol.acct_ent_date) >= p_fm_date
                             AND TRUNC(pol.acct_ent_date) <= p_to_date)
                     OR (    TRUNC(NVL(pol.spld_acct_ent_date,pol.acct_ent_date)) >= p_fm_date
                             AND TRUNC(NVL(pol.spld_acct_ent_date,pol.acct_ent_date)) <= p_to_date))
                    AND pol.policy_id = itm.policy_id
                    AND itm.policy_id = ipr.policy_id
                    AND itm.item_no   = ipr.item_no)
                    --AND pol.policy_id = 19926)
  LOOP
    --Pass the parameters
    v_iss_cd          := drct.iss_cd;
    v_line_cd         := drct.line_cd;
    v_subline_cd      := drct.subline_cd;
    v_policy_id       := drct.policy_id;
    v_peril_cd        := drct.peril_cd;
    v_tariff_cd       := NULL;
    v_subline_type_cd := NULL;
    v_commission_amt  := NULL;
    v_premium_amt     := drct.premium_amt;
    v_tsi_amt         := drct.tsi_amt;
    v_inw_ri_comm     := drct.ri_comm_amt;
    v_item_no         := drct.item_no;

    --Initialize the amounts for deriving comm_amt_prl
    v_premprl      := 0;
    v_sum_comm_amt := 0;


    --Tariff code if line is FIRE
     IF v_line_cd = v_fi_line_cd THEN
        BEGIN
          SELECT tarf_cd
            INTO v_tariff_cd
            FROM gipi_fireitem
           WHERE policy_id = v_policy_id
             AND item_no   = v_item_no;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              NULL;
        END;
     END IF;

   --Subline_type_cd if line is MOTORCAR
     IF v_line_cd = v_mc_line_cd THEN
        BEGIN
          SELECT subline_type_cd
            INTO v_subline_type_cd
            FROM gipi_vehicle
           WHERE policy_id = v_policy_id
             AND item_no   = v_item_no;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              NULL;
        END;
     END IF;

    --Get the commission amt for that policy-peril
    FOR comprl IN (SELECT NVL(SUM(commission_amt),0) com_amt
                     FROM gipi_comm_inv_peril
	            WHERE peril_cd  = v_peril_cd
	              AND policy_id = v_policy_id)
    LOOP
       	v_sum_comm_amt := comprl.com_amt;
--dbms_output.put_line('sum_comm: '||v_sum_comm_amt);
    END LOOP;

    --Get the prem item total per tariff of the policy
    FOR premprl IN (SELECT NVl(SUM(prem_amt) ,0) premprl_amt
                      FROM gipi_itmperil
                     WHERE 1=1
                       AND policy_id = v_policy_id
                       AND item_no = v_item_no
                       AND (DECODE(tarf_cd,NULL,'X',tarf_cd)) = (DECODE(tarf_cd,NULL,'X',tarf_cd)))
    LOOP
       v_premprl := premprl.premprl_amt;
--dbms_output.put_line('premprl: '||v_premprl);
    END LOOP;

    --Get the total in the item_level
    FOR premitm IN (SELECT NVl(SUM(prem_amt) ,0) premitm_amt
                      FROM gipi_item
                     WHERE 1=1
                       AND policy_id = v_policy_id)
    LOOP
       v_premitm := premitm.premitm_amt;
--dbms_output.put_line('premimt: '||v_premitm);
    END LOOP;

    --Compute the comm_amt per policy/item/peril
    FOR vir IN (SELECT round(((v_premprl/decode(v_premitm,0,1,v_premitm)) * v_sum_comm_amt),2) pip
                  FROM DUAL)
    LOOP
       v_comm_pip := vir.pip;
--dbms_output.put_line('comm_pip: '||v_comm_pip);
       EXIT;
    END LOOP;

   --Insert the data in the table
       INSERT INTO giac_recap_dtl_flt_ext
         (iss_cd,                line_cd,           subline_cd,
          policy_id,             peril_cd,          tariff_cd,
          subline_type_cd,       premium_amt,       commission_amt,
	  tsi_amt,               inw_ri_comm)
       VALUES
         (v_iss_cd,          v_line_cd,     v_subline_cd,
          v_policy_id,       v_peril_cd,    v_tariff_cd,
          v_subline_type_cd, v_premium_amt, v_comm_pip,
 	  v_tsi_amt,         v_inw_ri_comm);
   END LOOP; --End of drtct loop
   --End of main loop for direct

   --Flush the variables to be used again below
    v_iss_cd          := NULL;
    v_line_cd         := NULL;
    v_subline_cd      := NULL;
    v_policy_id       := NULL;
    v_peril_cd        := NULL;
    v_tariff_cd       := NULL;
    v_subline_type_cd := NULL;
    v_commission_amt  := NULL;
    v_treaty_prem     := NULL;
    v_tsi_amt         := NULL;
    v_inw_ri_comm     := NULL;
    v_item_no         := NULL;

   --Main loop for treaty
  FOR trty IN (SELECT pol.iss_cd           AS iss_cd,
                      pol.subline_cd       AS subline_cd,
                      gtc.line_cd          AS line_cd,
		      gtc.policy_id        AS policy_id,
		      gdl.peril_cd         AS peril_cd,
                      NULL                 AS tariff_cd,
                      NULL                 AS subline_type_cd,
		      gdl.premium_amt      AS premium_amt,
 		      ROUND(DECODE( (SIGN(p_fm_date - dis.acct_ent_date) * 4)
                       + SIGN(NVL(dis.acct_neg_date, p_to_date+60) - p_to_date),
 			  1, 1,
 			 -3, 1,
 			  3,-1,
 			  4,-1, 0) * ids.dist_tsi * (typ.trty_shr_pct/100),2) AS dist_tsi,
		     gdl.commission_amt           AS commission_amt,
		     gri.ri_cd                    AS ri_cd,
		     gri.local_foreign_sw         AS local_foreign_sw,
                     ipr.item_no                  AS item_no
                FROM giuw_itemperilds_dtl     ids,
                     giuw_pol_dist            dis,
	             giis_trty_panel          typ,
                     giis_dist_share          shr,
                     gipi_polbasic            pol,
                     giis_reinsurer           gri,
                     gipi_itmperil            ipr,
                     giac_treaty_cession_dtl  gdl,
                     giac_treaty_cessions     gtc
               WHERE gtc.cession_id     = gdl.cession_id
                 AND gtc.acct_ent_date  >= p_fm_date
	         AND gtc.acct_ent_date  <= p_to_date
                 AND gtc.policy_id      = ipr.policy_id
                 AND gtc.item_no        = ipr.item_no
                 AND gtc.line_cd        = ipr.line_cd
                 AND gdl.peril_cd       = ipr.peril_cd
                 AND gtc.ri_cd          = gri.ri_cd
                 AND gtc.policy_id      = pol.policy_id
                 AND gtc.line_cd        = shr.line_cd
                 AND gtc.share_cd       = shr.share_cd
                 AND shr.share_type     = 2
	         AND shr.line_cd        = typ.line_cd
	         AND shr.trty_yy        = typ.trty_yy
	         AND shr.share_cd       = typ.trty_seq_no
	         AND gtc.ri_cd          = typ.ri_cd
	         AND gtc.dist_no        = dis.dist_no
                 AND gtc.dist_no        = ids.dist_no
                 AND gtc.item_no        = ids.item_no
                 AND ipr.peril_cd       = ids.peril_cd
                 AND gtc.line_cd        = ids.line_cd||NULL  -- optimization purposes
                 AND gtc.share_cd       = ids.share_cd)
   LOOP
      v_iss_cd          := trty.iss_cd;
      v_line_cd         := trty.line_cd;
      v_subline_cd      := trty.subline_cd;
      v_policy_id       := trty.policy_id;
      v_peril_cd        := trty.peril_cd;
      v_tariff_cd       := NULL;
      v_subline_type_cd := NULL;
      v_treaty_prem     := trty.premium_amt;
      v_treaty_tsi      := trty.dist_tsi;
      v_treaty_comm     := trty.commission_amt;
      v_ri_cd           := trty.ri_cd;
      v_item_no         := trty.item_no;
      v_local_foreign_sw:= trty.local_foreign_sw;

    --Tariff code if line is FIRE
     IF v_line_cd = v_fi_line_cd THEN
        BEGIN
          SELECT tarf_cd
            INTO v_tariff_cd
            FROM gipi_fireitem
           WHERE policy_id = v_policy_id
             AND item_no   = v_item_no;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              NULL;
        END;
     END IF;

   --Subline_type_cd if line is MOTORCAR
     IF v_line_cd = v_mc_line_cd THEN
        BEGIN
          SELECT subline_type_cd
            INTO v_subline_type_cd
            FROM gipi_vehicle
           WHERE policy_id = v_policy_id
             AND item_no   = v_item_no;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              NULL;
        END;
     END IF;

     --Insert into the table

       INSERT INTO giac_recap_dtl_flt_ext
         (iss_cd,                line_cd,            subline_cd,
          policy_id,             peril_cd,           tariff_cd,
          subline_type_cd,       treaty_prem,        treaty_tsi,
          treaty_comm,           ri_cd,              local_foreign_sw)
       VALUES
         (v_iss_cd,          v_line_cd,      v_subline_cd,
          v_policy_id,       v_peril_cd,     v_tariff_cd,
          v_subline_type_cd, v_treaty_prem,  v_treaty_tsi,
          v_treaty_comm,     v_ri_cd,        v_local_foreign_sw);
   END LOOP; --End of trty loop
   --End of MAIN trty
   COMMIT;

   --Flush the variables to be used again below
    v_iss_cd          := NULL;
    v_line_cd         := NULL;
    v_subline_cd      := NULL;
    v_policy_id       := NULL;
    v_peril_cd        := NULL;
    v_tariff_cd       := NULL;
    v_subline_type_cd := NULL;
    v_commission_amt  := NULL;
    v_premium_amt     := NULL;
    v_tsi_amt         := NULL;
    v_inw_ri_comm     := NULL;
    v_item_no         := NULL;

   --For FACUL
    FOR perl IN (SELECT distfr.dist_no          AS dist_no,
	                distfr.dist_seq_no      AS dist_seq_no,
			poldst.policy_id        AS policy_id,
                        bndr.acc_rev_date       AS acc_rev_date,
			bndr.acc_ent_date       AS acc_ent_date,
			(frperl.ri_comm_rt/100) AS comm_rt,
			frperl.ri_shr_pct       AS shr_pct,
                        frperl.ri_cd            AS ri_cd,
			reinsr.local_foreign_sw AS local_foreign_sw,
			frperl.peril_cd         AS peril_cd
	           FROM giis_reinsurer reinsr,
	                giuw_pol_dist  poldst,
			giri_distfrps  distfr,
			giri_frperil   frperl,
			giri_frps_ri   frpsri,
			giri_binder    bndr
                  WHERE 1=1
                    AND (   (    TRUNC(bndr.acc_ent_date) >= p_fm_date
                        AND TRUNC(bndr.acc_ent_date) <= p_to_date)
                     OR (    TRUNC(bndr.acc_rev_date) >= p_fm_date
                        AND TRUNC(bndr.acc_rev_date) <= p_to_date))
                    AND bndr.fnl_binder_id = frpsri.fnl_binder_id
                    AND frpsri.frps_yy       = distfr.frps_yy
                    AND frpsri.frps_seq_no   = distfr.frps_seq_no
                    AND frpsri.line_cd       = distfr.line_cd
 		    AND frpsri.ri_seq_no     = frperl.ri_seq_no
                    AND distfr.line_cd       = frperl.line_cd
                    AND distfr.frps_yy       = frperl.frps_yy
                    AND distfr.frps_seq_no   = frperl.frps_seq_no
		    AND frperl.ri_cd         = bndr.ri_cd
                    AND frperl.ri_cd         = reinsr.ri_cd
                    AND distfr.dist_no       = poldst.dist_no)
    LOOP
       BEGIN
          SELECT line_cd,   subline_cd,   iss_cd,   TRUNC(acct_ent_date)
            INTO v_line_cd, v_subline_cd, v_iss_cd, v_acct_ent_date
            FROM gipi_polbasic
           WHERE policy_id = perl.policy_id;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR(20103,'Policy_id '|| perl.policy_id ||' does not exist in gipi_polbasic');
       END;
       FOR item IN
           (SELECT itmprl.dist_spct spct, itmprl.dist_prem prem, itmprl.line_cd,
                   itmprl.item_no,        itmprl.dist_tsi tsi
              FROM giuw_itemperilds_dtl itmprl
             WHERE itmprl.dist_no     = perl.dist_no
               AND itmprl.dist_seq_no = perl.dist_seq_no
               AND itmprl.peril_cd    = perl.peril_cd
               AND itmprl.line_cd     = v_line_cd
               AND itmprl.share_cd    = 999)
       LOOP
         BEGIN
            SELECT currency_rt
              INTO v_currency_rt
              FROM gipi_item
             WHERE policy_id = perl.policy_id
               AND item_no   = item.item_no;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR(20104,'The record with policy_id='
                                          || TO_CHAR(perl.policy_id)||' and item_no='
                                          || TO_CHAR(item.item_no)
                                          || ' does not exists in gipi_item.');
         END;
         --Pass the values that are needed
         v_policy_id        := perl.policy_id;
         v_peril_cd         := perl.peril_cd;
         v_tariff_cd        := NULL;
         v_ri_cd            := perl.ri_cd;
         v_local_foreign_sw := perl.local_foreign_sw;
         v_facul_prem       := (perl.shr_pct/item.spct) * item.prem * v_currency_rt;
         v_facul_tsi        := ((perl.shr_pct/item.spct) * item.tsi) * v_currency_rt;
         v_facul_comm       := ROUND(perl.comm_rt * ((perl.shr_pct/item.spct) * item.prem),2) * v_currency_rt;


      v_acc_rev_date := NVL(TRUNC(perl.acc_rev_date), p_to_date + 60.0);
      IF perl.acc_ent_date >= p_fm_date AND
         v_acc_rev_date    <= p_to_date THEN
         v_facul_prem := v_facul_prem * 0.0;
         v_facul_tsi  := v_facul_tsi  * 0.0;
         v_facul_comm := v_facul_comm * 0.0;
      ELSIF perl.acc_ent_date < p_fm_date AND
            v_acc_rev_date <= p_to_date THEN
         v_facul_prem := v_facul_prem * -1.0;
         v_facul_tsi  := v_facul_tsi  * -1.0;
         v_facul_comm := v_facul_comm * -1.0;
      END IF;

      IF v_line_cd = v_fi_line_cd THEN
         BEGIN -- to get tariff_cd
           SELECT tarf_cd
             INTO v_tariff_cd
             FROM gipi_fireitem
            WHERE policy_id = v_policy_id
              AND item_no   = item.item_no;
           EXCEPTION
             WHEN NO_DATA_FOUND THEN
               NULL;
         END;
      END IF;

      IF v_line_cd = v_mc_line_cd THEN
         BEGIN -- to get subline_type_cd
           SELECT subline_type_cd
             INTO v_subline_type_cd
             FROM gipi_vehicle
            WHERE policy_id = v_policy_id
              AND item_no   = item.item_no;
           EXCEPTION
             WHEN NO_DATA_FOUND THEN
               NULL;
         END;
      END IF;
      --Insert the date
       INSERT INTO giac_recap_dtl_flt_ext
         (iss_cd,                 line_cd,            subline_cd,
          policy_id,              peril_cd,           tariff_cd,
          subline_type_cd,        facul_prem,         facul_comm,
          ri_cd,                  local_foreign_sw,   facul_tsi)
       VALUES
         (v_iss_cd,            v_line_cd,     v_subline_cd,
          v_policy_id,         v_peril_cd,    v_tariff_cd,
          v_subline_type_cd,   v_facul_prem,  v_facul_comm,
          v_ri_cd,             v_local_foreign_sw,  v_facul_tsi);
     END LOOP; -- item
   END LOOP; -- end of perl
  --END OF PERL
  COMMIT;
END;
/


