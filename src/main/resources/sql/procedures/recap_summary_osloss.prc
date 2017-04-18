DROP PROCEDURE CPI.RECAP_SUMMARY_OSLOSS;

CREATE OR REPLACE PROCEDURE CPI.recap_summary_osloss AS
   TYPE tab_iss_cd              IS TABLE OF giac_recap_osloss_ext.iss_cd%TYPE;
   TYPE tab_line_cd             IS TABLE OF giac_recap_osloss_ext.line_cd%TYPE;
   TYPE tab_subline_cd          IS TABLE OF giac_recap_osloss_ext.subline_cd%TYPE;
   TYPE tab_claim_id            IS TABLE OF giac_recap_osloss_ext.claim_id%TYPE;
   TYPE tab_polseq_no           IS TABLE OF giac_recap_osloss_ext.pol_seq_no%TYPE;
   TYPE tab_renew_no            IS TABLE OF giac_recap_osloss_ext.renew_no%TYPE;
   TYPE tab_item_no             IS TABLE OF giac_recap_osloss_ext.item_no%TYPE;
   TYPE tab_peril_cd            IS TABLE OF giac_recap_osloss_ext.peril_cd%TYPE;
   TYPE tab_peril_tp            IS TABLE OF giac_recap_osloss_ext.peril_type%TYPE;
   TYPE tab_tariff_cd           IS TABLE OF giac_recap_osloss_ext.tariff_cd%TYPE;
   TYPE tab_subln_tpcd          IS TABLE OF giac_recap_osloss_ext.subline_type_cd%TYPE;
   TYPE tab_nr_loss             IS TABLE OF giac_recap_osloss_ext.nr_loss%TYPE;
   TYPE tab_nr_exp              IS TABLE OF giac_recap_osloss_ext.nr_exp%TYPE;
   TYPE tab_ri_cd               IS TABLE OF giac_recap_osloss_ext.ri_cd%TYPE;
   TYPE tab_locfor_sw           IS TABLE OF giac_recap_osloss_ext.local_foreign_sw%TYPE;
   TYPE tab_treaty_loss         IS TABLE OF giac_recap_osloss_ext.treaty_loss%TYPE;
   TYPE tab_treaty_exp          IS TABLE OF giac_recap_osloss_ext.treaty_exp%TYPE;
   TYPE tab_facul_loss          IS TABLE OF giac_recap_osloss_ext.facul_loss%TYPE;
   TYPE tab_facul_exp           IS TABLE OF giac_recap_osloss_ext.facul_exp%TYPE;
   TYPE tab_cedant              IS TABLE OF giac_recap_osloss_ext.cedant%TYPE;

   vv_iss_cd        tab_iss_cd;
   vv_line_cd       tab_line_cd;
   vv_subline_cd    tab_subline_cd;
   vv_claim_id      tab_claim_id;
   vv_polseq_no     tab_polseq_no;
   vv_renew_no      tab_renew_no;
   vv_item_no       tab_item_no;
   vv_peril_cd      tab_peril_cd;
   vv_peril_tp      tab_peril_tp;
   vv_tariff_cd     tab_tariff_cd;
   vv_subln_tpcd    tab_subln_tpcd;
   vv_nr_loss       tab_nr_loss;
   vv_nr_exp        tab_nr_exp;
   vv_ri_cd         tab_ri_cd;
   vv_locfor_sw     tab_locfor_sw;
   vv_treaty_loss   tab_treaty_loss;
   vv_treaty_exp    tab_treaty_exp;
   vv_facul_loss    tab_facul_loss;
   vv_facul_exp     tab_facul_exp;
   vv_cedant        tab_cedant;

   --Set the variables
   v_gross_loss NUMBER (16,2); --(nr_loss+trty_loss+facul_loss)
   v_gross_exp  NUMBER (16,2); --(nr_exp+trty_exp+facul_exp)
   v_inw_grs_loss_auth NUMBER (16,2);
   v_inw_grs_exp_auth NUMBER (16,2);
   v_inw_grs_loss_asean NUMBER (16,2);
   v_inw_grs_exp_asean NUMBER (16,2);
   v_inw_grs_loss_oth NUMBER (16,2);
   v_inw_grs_exp_oth NUMBER (16,2);
   v_loss_auth NUMBER (16,2);
   v_exp_auth NUMBER (16,2);
   v_loss_asean NUMBER (16,2);
   v_exp_asean NUMBER (16,2);
   v_loss_oth NUMBER (16,2);
   v_exp_oth NUMBER (16,2);
   v_ret_loss_auth NUMBER (16,2);
   v_ret_exp_auth NUMBER (16,2);
   v_ret_loss_asean NUMBER (16,2);
   v_ret_exp_asean NUMBER (16,2);
   v_ret_loss_oth NUMBER (16,2);
   v_ret_exp_oth NUMBER (16,2);

   v_rowno    giac_recap_osloss_summ_ext.rowno%TYPE;
   v_rowtitle giac_recap_osloss_summ_ext.rowtitle%TYPE;
   v_bond_class_no giis_bond_class_subline.class_no%TYPE;
   --Line cd parameters
   v_line_fi  giis_line.line_cd%TYPE;
   v_line_mn  giis_line.line_cd%TYPE;
   v_line_mh  giis_line.line_cd%TYPE;
   v_line_av  giis_line.line_cd%TYPE;
   v_line_su  giis_line.line_cd%TYPE;
   v_line_mc  giis_line.line_cd%TYPE;
   v_line_ac  giis_line.line_cd%TYPE;
   v_line_en  giis_line.line_cd%TYPE;
   v_subline_lto giis_subline.subline_cd%TYPE;

   --Function to get the local_foreign_sw for the CEDANT
   Function get_ced_locfor_sw(
      p_cedant_cd giis_reinsurer.ri_cd%TYPE) RETURN CHAR AS
      v_exs BOOLEAN := FALSE;
      v_locfor giis_reinsurer.local_foreign_sw%TYPE;
   BEGIN
      FOR locfor IN (SELECT local_foreign_sw
                       FROM giis_reinsurer
                      WHERE ri_cd = p_cedant_cd)
      LOOP
         v_locfor := locfor.local_foreign_sw;
         v_exs := TRUE;
         EXIT;
      END LOOP;
      IF v_exs = TRUE THEN
         RETURN(v_locfor);
      ELSE
         RETURN(NULL);
      END IF;
   END;

   --Function to get the bond_class_no
   FUNCTION get_bond_class(
      p_line_cd giac_recap_dtl_ext.line_cd%TYPE,
      p_subline_cd giac_recap_dtl_ext.subline_cd%TYPE) RETURN CHAR AS
      v_exs BOOLEAN := FALSE;
      v_class_no VARCHAR2(1);
   BEGIN
      FOR bc_no IN (SELECT class_no
                      FROM giis_bond_class_subline
                     WHERE line_cd = p_line_cd
                       AND subline_cd = p_subline_cd)
      LOOP
         v_class_no := bc_no.class_no;
         v_exs := TRUE;
         EXIT;
      END LOOP;
      IF v_exs = TRUE THEN
         RETURN(v_class_no);
      ELSE
         RETURN(NULL);
      END IF;
   END;

   --Procedure to get the rowno and rowtitle
   --For line's in report list
   PROCEDURE get_rowthings(
      p_line_cd IN giac_recap_dtl_ext.line_cd%TYPE,
	  p_peril_cd IN giac_recap_dtl_ext.peril_cd%TYPE,
	  p_tariff_cd IN giac_recap_dtl_ext.tariff_cd%TYPE,
        p_bond_class_no IN giis_bond_class_subline.class_no%TYPE,
	  p_rowno   OUT giac_recap_osloss_summ_ext.rowno%TYPE,
	  p_rowtitle  OUT giac_recap_osloss_summ_ext.rowtitle%TYPE) IS
	  v_exs BOOLEAN := FALSE;
   BEGIN
      --Get the rowno and rowtitle
      FOR grrd IN (SELECT a.rowno, a.rowtitle
                     FROM giac_recap_row_dtl b, giac_recap_row a
                    WHERE 1=1
                      AND a.line_cd = b.line_cd
                      AND a.rowno = b.rowno
                      AND b.line_cd = p_line_cd
 	                AND DECODE(a.bond_class_sw, 'Y', NVL(b.bond_class_no,'x'),'x') =
			        DECODE(a.bond_class_sw, 'Y', NVL(p_bond_class_no,'x'),'x')
                      AND DECODE(a.peril_sw, 'Y',NVL(b.peril_cd,1),1) =
			        DECODE(a.peril_sw, 'Y',NVL(p_peril_cd,1),1)
                      AND DECODE(a.tariff_sw,'Y',NVL(b.tariff_cd,'x'),'x') =
                          DECODE(a.tariff_sw,'Y',NVL(p_tariff_cd,'x'),'x'))
      LOOP
	     p_rowno    := grrd.rowno;
		 p_rowtitle := grrd.rowtitle;
		 v_exs := TRUE;
		 EXIT;
      END LOOP;
	  --check for existence
	  IF v_exs = FALSE THEN
	     p_rowno    := 8;
		 p_rowtitle := 'EXTENDED COVERAGE';
	  END IF;
   END;

   --For other lines
   PROCEDURE get_rowthings_others(
      p_line_cd    IN giac_recap_osloss_summ_ext.line_cd%TYPE,
      p_subline_cd IN giac_recap_dtl_ext.subline_cd%TYPE,
      p_rowno      OUT giac_recap_osloss_summ_ext.rowno%TYPE,
      p_rowtitle   OUT giac_recap_osloss_summ_ext.rowtitle%TYPE) IS
   BEGIN
      FOR grro IN (SELECT rowno, rowtitle
                     FROM giac_recap_other_rows
                    WHERE line_cd = p_line_cd
                      AND rowtitle = p_subline_cd)
      LOOP
         p_rowno    := grro.rowno;
         p_rowtitle := grro.rowtitle;
         EXIT;
      END LOOP;
   END;

   --To get the rowthings of line_cd MC
   PROCEDURE get_rowthings_mc(
      p_line_cd IN giac_recap_dtl_ext.line_cd%TYPE,
	  p_peril_cd IN giac_recap_dtl_ext.peril_cd%TYPE,
	  p_subline_cd IN giac_recap_dtl_ext.subline_cd%TYPE,
	  p_subline_lto IN giac_recap_dtl_ext.subline_type_cd%TYPE,
	  p_subline_tpcd IN giac_recap_dtl_ext.subline_type_cd%TYPE,
	  p_rowno   OUT giac_recap_osloss_summ_ext.rowno%TYPE,
	  p_rowtitle  OUT giac_recap_osloss_summ_ext.rowtitle%TYPE) IS
	  v_exs BOOLEAN := FALSE;
	  v_ctpl BOOLEAN := FALSE;
   BEGIN
      --Check if LTO or NLTO(subline other than LTO)
      IF p_subline_cd = p_subline_lto THEN
         --Get the rowno and rowtitle for LTO
         FOR grrd IN (SELECT a.rowno, a.rowtitle
                        FROM giac_recap_row_dtl b, giac_recap_row a
                       WHERE 1=1
                         AND a.line_cd = b.line_cd
                         AND a.rowno = b.rowno
                         AND b.line_cd = p_line_cd
		 	 	         AND b.subline_cd = p_subline_lto
					     AND DECODE(a.subline_sw, 'Y', NVL(b.subline_cd,'x'),'x') =
			                 DECODE(a.subline_sw, 'Y', NVL(p_subline_cd,'x'),'x')
 	                     AND DECODE(a.subline_tpcd_sw, 'Y', NVL(b.subline_type_cd,'x'),'x') =
			                 DECODE(a.subline_tpcd_sw, 'Y', NVL(p_subline_tpcd,'x'),'x')
                         AND DECODE(a.peril_sw, 'Y',NVL(b.peril_cd,1),1) =
			                 DECODE(a.peril_sw, 'Y',NVL(p_peril_cd,1),1)							 )
         LOOP
		    p_rowno := grrd.rowno;
			p_rowtitle := grrd.rowtitle;
			v_exs := TRUE;
		 END LOOP;
		 IF v_exs = FALSE THEN
		    FOR c1 IN (SELECT rowno, rowtitle
			             FROM giac_recap_row
						WHERE rowtitle = 'OTHER THAN CTPL LTO')
		    LOOP
			   p_rowno := c1.rowno;
			   p_rowtitle := c1.rowtitle;
			END LOOP;
	     END IF;
      ELSE
      --Get the rowno and rowtitle for NLTO
      FOR grrd IN (SELECT a.rowno, a.rowtitle
                     FROM giac_recap_row_dtl b, giac_recap_row a
                    WHERE 1=1
                      AND a.line_cd = b.line_cd
                      AND a.rowno = b.rowno
                      AND b.line_cd = p_line_cd
					  AND b.subline_cd != p_subline_lto
					  AND DECODE(a.subline_sw, 'Y', NVL(b.subline_cd,'x'),'x') =
			              DECODE(a.subline_sw, 'Y', NVL(p_subline_cd,'x'),'x')
 	                  AND DECODE(a.subline_tpcd_sw, 'Y', NVL(b.subline_type_cd,'x'),'x') =
			              DECODE(a.subline_tpcd_sw, 'Y', NVL(p_subline_tpcd,'x'),'x')
                      AND DECODE(a.peril_sw, 'Y',NVL(b.peril_cd,1),1) =
			              DECODE(a.peril_sw, 'Y',NVL(p_peril_cd,1),1))
         LOOP
		    p_rowno := grrd.rowno;
			p_rowtitle := grrd.rowtitle;
			v_exs   := TRUE;
	     END LOOP;
		 IF v_exs = FALSE THEN
		    --For ctpl peril_cd's
		    FOR ctplcheck IN (SELECT 'x'
                                FROM giac_recap_row a, giac_recap_row_dtl b
                               WHERE 1=1
                                 AND a.line_cd = b.line_cd
                                 AND a.rowno = b.rowno
                                 AND rowtitle LIKE '%CTPL - LTO%'
							     AND b.peril_cd = p_peril_cd)
		    LOOP
		       v_ctpl := TRUE;
		    END LOOP;
			IF v_ctpl = TRUE THEN
			   --This is CTPL - NLTO by subline
		       FOR c2 IN (SELECT rowno, rowtitle
			               FROM giac_recap_other_rows
					      WHERE line_cd = p_line_cd
					        AND rowtitle = p_subline_cd)
			   LOOP
			      p_rowno := c2.rowno;
			      p_rowtitle := c2.rowtitle;
			   END LOOP;
			ELSE
			   --This is other than ctpl - nlto - others
			   FOR octploth IN (SELECT rowno, rowtitle
			                      FROM giac_recap_row
								 WHERE rowtitle LIKE '%NLTO - OTHER PERILS%')
			   LOOP
			      p_rowno := octploth.rowno;
				  p_rowtitle := octploth.rowtitle;
			   END LOOP;
			END IF;
	     END IF;
      END IF;
   END;

   --Procdure to populate the table giac_recap_other_rows
   PROCEDURE pop_recap_other_rows(
      p_line_fi IN giis_line.line_cd%TYPE,
      p_line_mn IN giis_line.line_cd%TYPE,
      p_line_mh IN giis_line.line_cd%TYPE,
      p_line_av IN giis_line.line_cd%TYPE,
      p_line_su IN giis_line.line_cd%TYPE,
      p_line_mc IN giis_line.line_cd%TYPE,
      p_line_ac IN giis_line.line_cd%TYPE,
      p_line_en IN giis_line.line_cd%TYPE) is
      v_rowno NUMBER;
   BEGIN
      --Truncate the table
      EXECUTE IMMEDIATE 'TRUNCATE TABLE giac_recap_other_rows';

      --Get the rowno of the rowtitle OTHER
      FOR grr IN (SELECT rowno
                    FROM giac_recap_row
                   WHERE rowtitle = 'OTHERS')
      LOOP
         v_rowno := grr.rowno;
      END LOOP;
      IF v_rowno IS NULL THEN
         v_rowno := 1;
      END IF;

      FOR grot IN (SELECT b.line_cd, a.subline_cd rowtitle
                     FROM giis_subline a, giis_line b
                    WHERE 1=1
                      AND b.line_cd = a.line_cd
                      AND b.line_cd NOT IN(p_line_fi,p_line_mn,p_line_mh,p_line_av,
                                           p_line_su,p_line_mc,p_line_ac,p_line_en)
                     ORDER BY b.line_cd, a.subline_cd)
      LOOP
         --Insert into giac_recap_other_rows
         v_rowno := v_rowno + 1;
         INSERT INTO giac_recap_other_rows(
            rowno, line_cd, rowtitle)
         VALUES(
            v_rowno, grot.line_cd, grot.rowtitle);
      END LOOP;
      COMMIT;
   END;

   --Procdure to populate the table giac_recap_other_rows for mc subline_cds
   PROCEDURE pop_recap_other_rowsmc(
      p_line_mc giis_line.line_cd%TYPE,
      p_subline_lto giis_subline.subline_cd%TYPE) IS
      v_rowno NUMBER;
   BEGIN
      --Get the rowno of the CTPL NON-LTO
      FOR nlto IN (SELECT rowno
                     FROM giac_recap_row
                    WHERE rowtitle = 'CTPL NON-LTO')
      LOOP
         v_rowno := nlto.rowno;
      END LOOP;
      IF v_rowno IS NULL THEN
         v_rowno := 1;
      END IF;

      --Populate the giac_recap_other_rows
      FOR grot IN (SELECT line_cd, subline_cd rowtitle
                  FROM giis_subline
                 WHERE line_cd = p_line_mc
                   AND subline_cd != p_subline_lto)
      LOOP
         --Insert into giac_recap_other_rows
         v_rowno := v_rowno + 0.01;
         INSERT INTO giac_recap_other_rows(
            rowno, line_cd, rowtitle)
         VALUES(
            v_rowno, grot.line_cd, grot.rowtitle);
      END LOOP;
      COMMIT;
   END;

BEGIN
   --Truncate the table
   EXECUTE IMMEDIATE 'TRUNCATE TABLE giac_recap_osloss_summ_ext';

   --Get the paramet line_cd's
   v_line_fi  := giisp.v('LINE_CODE_FI');
   v_line_mn  := giisp.v('LINE_CODE_MN');
   v_line_mh  := giisp.v('LINE_CODE_MH');
   v_line_av  := giisp.v('LINE_CODE_AV');
   v_line_su  := giisp.v('LINE_CODE_SU');
   v_line_mc  := giisp.v('LINE_CODE_MC');
   v_line_ac  := giisp.v('LINE_CODE_AC');
   v_line_en  := giisp.v('LINE_CODE_EN');
   v_line_mc  := giisp.v('LINE_CODE_MC');
   v_subline_lto := giisp.v('MC_SUBLINE_LTO');


   --Populate the giac_recap_other_rows table
   pop_recap_other_rows(v_line_fi,v_line_mn,v_line_mh,v_line_av,
                        v_line_su,v_line_mc,v_line_ac,v_line_en);

   --Populate the giac_recap_other_rows table for MC
   pop_recap_other_rowsmc(v_line_mc,v_subline_lto);

   --Build the collection
   SELECT iss_cd, line_cd, subline_cd, claim_id,
          pol_seq_no, renew_no, item_no, peril_cd,
		  peril_type, substr(tariff_cd,1,1), subline_type_cd,
		  NVL(nr_loss,0), NVL(nr_exp,0), ri_cd, local_foreign_sw,
		  NVL(treaty_loss,0), NVL(treaty_exp,0), NVL(facul_loss,0), NVL(facul_exp,0), cedant
     BULK COLLECT INTO vv_iss_cd,vv_line_cd,vv_subline_cd,vv_claim_id,
              vv_polseq_no,vv_renew_no,vv_item_no,vv_peril_cd,
              vv_peril_tp,vv_tariff_cd,vv_subln_tpcd,
              vv_nr_loss,vv_nr_exp,vv_ri_cd,vv_locfor_sw,
              vv_treaty_loss,vv_treaty_exp,vv_facul_loss,vv_facul_exp,vv_cedant
     FROM giac_recap_osloss_ext;
   -- WHERE line_cd NOT IN (v_line_mc);
   --(v_line_fi,v_line_mn,v_line_mh,v_line_av,v_line_ac,v_line_en,v_line_su);

   --Check if theres data
   IF SQL%FOUND THEN
      --Loop in the collection
	  FOR rec IN vv_iss_cd.first.. vv_iss_cd.last
	  LOOP
	     --Initialize the values for the amounts
           v_gross_loss         := 0;
           v_gross_exp          := 0;
           v_inw_grs_loss_auth  := 0;
           v_inw_grs_exp_auth   := 0;
           v_inw_grs_loss_asean := 0;
           v_inw_grs_exp_asean  := 0;
           v_inw_grs_loss_oth   := 0;
           v_inw_grs_exp_oth    := 0;
           v_loss_auth          := 0;
           v_exp_auth           := 0;
           v_loss_asean         := 0;
           v_exp_asean          := 0;
           v_loss_oth           := 0;
           v_exp_oth            := 0;
           v_ret_loss_auth      := 0;
           v_ret_exp_auth       := 0;
           v_ret_loss_auth      := 0;
           v_ret_exp_auth       := 0;
           v_ret_loss_asean     := 0;
           v_ret_exp_asean      := 0;
           v_ret_loss_oth       := 0;
           v_ret_exp_oth        := 0;
	     v_rowno              := NULL;
	     v_rowtitle           := NULL;

             --Get the bond_class_no if the line_cd = 'SU'
             IF vv_line_cd(rec) = 'SU' THEN
                v_bond_class_no := get_bond_class(vv_line_cd(rec),vv_subline_cd(rec));
             END IF;

		 --Get the rowno and the rowtitle
             --Depends on the line of the record
             IF vv_line_cd(rec) in (v_line_fi,v_line_mn,v_line_mh,v_line_av,v_line_ac,v_line_en,v_line_su) THEN
                get_rowthings(vv_line_cd(rec),vv_peril_cd(rec),vv_tariff_cd(rec), v_bond_class_no,v_rowno,v_rowtitle);
             ELSIF vv_line_cd(rec) in (v_line_mc) THEN
                get_rowthings_mc(vv_line_cd(rec),vv_peril_cd(rec),vv_subline_cd(rec),v_subline_lto,vv_subln_tpcd(rec),v_rowno,v_rowtitle);
             ELSE
                get_rowthings_others(vv_line_cd(rec),vv_subline_cd(rec),v_rowno,v_rowtitle);
             END IF;

		 --Set the amounts
		 --grosslosspd
		 IF vv_iss_cd(rec) != 'RI' THEN
                v_gross_loss := vv_nr_loss(rec) + vv_treaty_loss(rec) + vv_facul_loss(rec);
                v_gross_exp  := vv_nr_exp(rec) + vv_treaty_exp(rec) + vv_facul_exp(rec);
	       END IF;
		 --Set ceded premium, tsi and comm
		 IF vv_iss_cd(rec) != 'RI' THEN
		 --for authorized
		    IF vv_locfor_sw(rec) = 'L' THEN
                   v_loss_auth := vv_treaty_loss(rec) + vv_facul_loss(rec);
                   v_exp_auth  := vv_treaty_exp(rec) + vv_facul_exp(rec);
                END IF;
		 --for asean
		    IF vv_locfor_sw(rec) = 'A' THEN
                   v_loss_asean := vv_treaty_loss(rec) + vv_facul_loss(rec);
                   v_exp_asean  := vv_treaty_exp(rec) + vv_facul_exp(rec);
		    END IF;
		 --for others
		    IF vv_locfor_sw(rec) = 'F' THEN
                   v_loss_oth   := vv_treaty_loss(rec) + vv_facul_loss(rec);
                   v_exp_oth    := vv_treaty_exp(rec) + vv_facul_exp(rec);
                END IF;
             END IF;
             --Assumed(INW)
		 IF vv_iss_cd(rec) = 'RI' THEN
		    --for authorized
                IF get_ced_locfor_sw(vv_cedant(rec)) = 'L' THEN
                   v_inw_grs_loss_auth  := vv_facul_loss(rec);
                   v_inw_grs_exp_auth   := vv_facul_exp(rec);
                END IF;
		    --for asean
                IF get_ced_locfor_sw(vv_cedant(rec)) = 'A' THEN
                   v_inw_grs_loss_asean := vv_facul_loss(rec);
                   v_inw_grs_exp_asean  := vv_facul_exp(rec);
                END IF;
		    --for others
                IF get_ced_locfor_sw(vv_cedant(rec)) = 'F' THEN
                   v_inw_grs_loss_oth   := vv_facul_loss(rec);
                   v_inw_grs_exp_oth    := vv_facul_exp(rec);
                END IF;
             END IF;

		 --Retroceded premium, tsi and comm
		 IF vv_iss_cd(rec) = 'RI' THEN
              --for authorized
		    IF vv_locfor_sw(rec) = 'L' THEN
                   v_ret_loss_auth := vv_treaty_loss(rec) + vv_facul_loss(rec);
                   v_ret_exp_auth  := vv_treaty_exp(rec) + vv_facul_exp(rec);
                END IF;
		 --for asean
		    IF vv_locfor_sw(rec) = 'A' THEN
                   v_ret_loss_asean := vv_treaty_loss(rec) + vv_facul_loss(rec);
                   v_ret_exp_asean  := vv_treaty_exp(rec) + vv_facul_exp(rec);
		    END IF;
		 --for others
		    IF vv_locfor_sw(rec) = 'F' THEN
                   v_ret_loss_oth  := vv_treaty_loss(rec) + vv_facul_loss(rec);
                   v_ret_exp_oth   := vv_treaty_exp(rec) + vv_facul_exp(rec);
		    END IF;
             END IF;

         --Insert the data into the summary table
		 INSERT INTO giac_recap_osloss_summ_ext(
                rowno, rowtitle, iss_cd, line_cd, ri_cd, cedant_cd, claim_id,
                gross_loss, gross_exp, inw_grs_loss_auth, inw_grs_exp_auth,
                inw_grs_loss_asean, inw_grs_exp_asean, inw_grs_loss_oth, inw_grs_exp_oth,
                loss_auth, exp_auth, loss_asean, exp_asean, loss_oth, exp_oth,
                ret_loss_auth, ret_exp_auth, ret_loss_asean, ret_exp_asean, ret_loss_oth, ret_exp_oth)
		 VALUES(
		    v_rowno, v_rowtitle, vv_iss_cd(rec), vv_line_cd(rec), vv_ri_cd(rec),vv_cedant(rec), vv_claim_id(rec),
		    v_gross_loss, v_gross_exp, v_inw_grs_loss_auth, v_inw_grs_exp_auth,
                v_inw_grs_loss_asean, v_inw_grs_exp_asean, v_inw_grs_loss_oth, v_inw_grs_exp_oth,
                v_loss_auth, v_exp_auth, v_loss_asean, v_exp_asean, v_loss_oth, v_exp_oth,
                v_ret_loss_auth, v_ret_exp_auth, v_ret_loss_asean, v_ret_exp_asean, v_ret_loss_oth, v_ret_exp_oth);
      END LOOP;
      COMMIT;
   END IF;
END;
/


