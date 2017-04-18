DROP PROCEDURE CPI.RECAP_SUMMARY;

CREATE OR REPLACE PROCEDURE CPI.Recap_Summary AS
   TYPE tab_pol_id              IS TABLE OF GIAC_RECAP_DTL_EXT.policy_id%TYPE;
   TYPE tab_item_no             IS TABLE OF GIAC_RECAP_DTL_EXT.item_no%TYPE;
   TYPE tab_iss_cd              IS TABLE OF GIAC_RECAP_DTL_EXT.iss_cd%TYPE;
   TYPE tab_line_cd             IS TABLE OF GIAC_RECAP_DTL_EXT.line_cd%TYPE;
   TYPE tab_subline_cd          IS TABLE OF GIAC_RECAP_DTL_EXT.subline_cd%TYPE;
   TYPE tab_peril_cd            IS TABLE OF GIAC_RECAP_DTL_EXT.peril_cd%TYPE;
   TYPE tab_tariff_cd           IS TABLE OF GIAC_RECAP_DTL_EXT.tariff_cd%TYPE;
   TYPE tab_subln_tpcd          IS TABLE OF GIAC_RECAP_DTL_EXT.subline_type_cd%TYPE;
   TYPE tab_premium_amt         IS TABLE OF GIAC_RECAP_DTL_EXT.premium_amt%TYPE;
   TYPE tab_comm_amt            IS TABLE OF GIAC_RECAP_DTL_EXT.commission_amt%TYPE;
   TYPE tab_tsi_amt             IS TABLE OF GIAC_RECAP_DTL_EXT.tsi_amt%TYPE;
   TYPE tab_ri_cd               IS TABLE OF GIAC_RECAP_DTL_EXT.ri_cd%TYPE;
   TYPE tab_trty_prem           IS TABLE OF GIAC_RECAP_DTL_EXT.treaty_prem%TYPE;
   TYPE tab_trty_comm           IS TABLE OF GIAC_RECAP_DTL_EXT.treaty_comm%TYPE;
   TYPE tab_trty_tsi            IS TABLE OF GIAC_RECAP_DTL_EXT.treaty_tsi%TYPE;
   TYPE tab_facul_prem          IS TABLE OF GIAC_RECAP_DTL_EXT.facul_prem%TYPE;
   TYPE tab_facul_comm          IS TABLE OF GIAC_RECAP_DTL_EXT.facul_comm%TYPE;
   TYPE tab_facul_tsi           IS TABLE OF GIAC_RECAP_DTL_EXT.facul_tsi%TYPE;
   TYPE tab_locfor_sw           IS TABLE OF GIAC_RECAP_DTL_EXT.local_foreign_sw%TYPE;
   TYPE tab_inw_ri_comm         IS TABLE OF GIAC_RECAP_DTL_EXT.inw_ri_comm%TYPE;
   TYPE tab_cedant              IS TABLE OF GIAC_RECAP_DTL_EXT.cedant%TYPE;

   vv_pol_id           tab_pol_id;
   vv_item_no          tab_item_no;
   vv_iss_cd           tab_iss_cd;
   vv_line_cd          tab_line_cd;
   vv_subline_cd       tab_subline_cd;
   vv_peril_cd         tab_peril_cd;
   vv_tariff_cd        tab_tariff_cd;
   vv_subln_tpcd       tab_subln_tpcd;
   vv_premium_amt      tab_premium_amt;
   vv_comm_amt         tab_comm_amt;
   vv_tsi_amt          tab_tsi_amt;
   vv_ri_cd            tab_ri_cd;
   vv_trty_prem        tab_trty_prem;
   vv_trty_comm        tab_trty_comm;
   vv_trty_tsi         tab_trty_tsi;
   vv_facul_prem       tab_facul_prem;
   vv_facul_comm       tab_facul_comm;
   vv_facul_tsi        tab_facul_tsi;
   vv_locfor_sw        tab_locfor_sw;
   vv_inw_ri_comm      tab_inw_ri_comm;
   vv_cedant           tab_cedant;

   --direct premium, tsi and comm
   v_dir_prem NUMBER(16,2);
   v_dir_tsi  NUMBER(16,2);
   v_dir_comm NUMBER(16,2);
   --ceded premium, tsi and comm
   --for authorized
   v_ced_prem_auth NUMBER(16,2);
   v_ced_tsi_auth  NUMBER(16,2);
   v_ced_comm_auth NUMBER(16,2);
   --for asean
   v_ced_prem_asean NUMBER(16,2);
   v_ced_tsi_asean  NUMBER(16,2);
   v_ced_comm_asean NUMBER(16,2);
   --for others
   v_ced_prem_oth NUMBER(16,2);
   v_ced_tsi_oth  NUMBER(16,2);
   v_ced_comm_oth NUMBER(16,2);
   --Assumed(INW) premium, tsi and comm
   --for authorized
   v_inw_prem_auth NUMBER(16,2);
   v_inw_tsi_auth  NUMBER(16,2);
   v_inw_comm_auth NUMBER(16,2);
   --for asean
   v_inw_prem_asean NUMBER(16,2);
   v_inw_tsi_asean  NUMBER(16,2);
   v_inw_comm_asean NUMBER(16,2);
   --for others
   v_inw_prem_oth  NUMBER(16,2);
   v_inw_tsi_oth   NUMBER(16,2);
   v_inw_comm_oth  NUMBER(16,2);
   --Retroceded premium, tsi and comm
   --for authorized
   v_ret_prem_auth  NUMBER(16,2);
   v_ret_tsi_auth   NUMBER(16,2);
   v_ret_comm_auth  NUMBER(16,2);
   --for asean
   v_ret_prem_asean  NUMBER(16,2);
   v_ret_tsi_asean   NUMBER(16,2);
   v_ret_comm_asean  NUMBER(16,2);
   --for others
   v_ret_prem_oth  NUMBER(16,2);
   v_ret_tsi_oth   NUMBER(16,2);
   v_ret_comm_oth  NUMBER(16,2);
   --Set the other variables
   v_rowno    GIAC_RECAP_SUMM_EXT.rowno%TYPE;
   v_rowtitle GIAC_RECAP_SUMM_EXT.rowtitle%TYPE;
   v_bond_class_no GIIS_BOND_CLASS_SUBLINE.class_no%TYPE;
   --Line cd parameters
   v_line_fi  GIIS_LINE.line_cd%TYPE;
   v_line_mn  GIIS_LINE.line_cd%TYPE;
   v_line_mh  GIIS_LINE.line_cd%TYPE;
   v_line_av  GIIS_LINE.line_cd%TYPE;
   v_line_su  GIIS_LINE.line_cd%TYPE;
   v_line_mc  GIIS_LINE.line_cd%TYPE;
   v_line_ac  GIIS_LINE.line_cd%TYPE;
   v_line_en  GIIS_LINE.line_cd%TYPE;
   v_subline_lto GIIS_SUBLINE.subline_cd%TYPE;
   v_peril_type GIIS_PERIL.peril_type%TYPE;
   v_tsi_tag  GIAC_RECAP_ROW_DTL.tsi_tag%TYPE; 

   --Function to get the peril_type of each peril
   FUNCTION get_peril_type(
      p_line_cd GIIS_LINE.line_cd%TYPE,
      p_peril_cd GIIS_PERIL.peril_cd%TYPE) RETURN CHAR IS
      v_exs BOOLEAN := FALSE;
      v_peril_tp VARCHAR2(1);
   BEGIN
      FOR gp IN (SELECT peril_type
                   FROM GIIS_PERIL
                  WHERE 1=1
                    AND line_cd = p_line_cd
                    AND peril_cd = p_peril_cd)
      LOOP
         v_peril_tp := gp.peril_type;
      v_exs := TRUE;
      END LOOP;
      IF v_exs = TRUE THEN
         RETURN(v_peril_tp);
      ELSE
         RAISE_APPLICATION_ERROR(-20001,'PERIL TYPE FOR '||p_line_cd||'-'||TO_CHAR(p_peril_cd)||' DOES NOT EXIST.');
      END IF;
   END;

   --judyann 10242007
   --Function to get the TSI_TAG of each peril (TSI_TAG - indicator whether to include the TSI of certain allied perils)
   FUNCTION get_tsi_tag(
      p_peril_cd GIIS_PERIL.peril_cd%TYPE) RETURN CHAR IS
      v_exs BOOLEAN := FALSE;
      v_tag VARCHAR2(1);
   BEGIN
      FOR tsi IN (SELECT NVL(tsi_tag,'N') tag
                   FROM GIAC_RECAP_ROW_DTL
                  WHERE 1=1
                    AND peril_cd = p_peril_cd)
      LOOP
         v_tag := tsi.tag;
      v_exs := TRUE;
      END LOOP;
      IF v_exs = TRUE THEN
         RETURN(v_tag);
      ELSE
      RETURN(NULL);
      END IF;
   END;
   
   --Function to get the local_foreign_sw for the CEDANT
   FUNCTION get_ced_locfor_sw(
      p_cedant_cd GIIS_REINSURER.ri_cd%TYPE) RETURN CHAR AS
      v_exs BOOLEAN := FALSE;
      v_locfor GIIS_REINSURER.local_foreign_sw%TYPE;
   BEGIN
      FOR locfor IN (SELECT local_foreign_sw
                       FROM GIIS_REINSURER
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
         --RAISE_APPLICATION_ERROR(-20001,'Cannot find local_foreign_sw for '||to_char(p_cedant_cd));
      END IF;
   END;

   --Function to get the bond_class_no
   FUNCTION get_bond_class(
      p_line_cd GIAC_RECAP_DTL_EXT.line_cd%TYPE,
      p_subline_cd GIAC_RECAP_DTL_EXT.subline_cd%TYPE) RETURN CHAR AS
      v_exs BOOLEAN := FALSE;
      v_class_no VARCHAR2(1);
   BEGIN
      FOR bc_no IN (SELECT class_no
                      FROM GIIS_BOND_CLASS_SUBLINE
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
      p_line_cd IN GIAC_RECAP_DTL_EXT.line_cd%TYPE,
   p_peril_cd IN GIAC_RECAP_DTL_EXT.peril_cd%TYPE,
   p_tariff_cd IN GIAC_RECAP_DTL_EXT.tariff_cd%TYPE,
      p_bond_class_no IN GIIS_BOND_CLASS_SUBLINE.class_no%TYPE,
   p_rowno   OUT GIAC_RECAP_SUMM_EXT.rowno%TYPE,
   p_rowtitle  OUT GIAC_RECAP_SUMM_EXT.rowtitle%TYPE) IS
   v_exs BOOLEAN := FALSE;
   BEGIN
      --Get the rowno and rowtitle
      FOR grrd IN (SELECT a.rowno, a.rowtitle
                     FROM GIAC_RECAP_ROW_DTL b, GIAC_RECAP_ROW a
                    WHERE 1=1
                      AND a.line_cd = b.line_cd
                      AND a.rowno = b.rowno
                      AND b.line_cd = p_line_cd
                  AND DECODE(a.bond_class_sw, 'Y', NVL(b.bond_class_no,'X'),'X') =
           DECODE(a.bond_class_sw, 'Y', NVL(p_bond_class_no,'X'),'X')
                      AND DECODE(a.peril_sw, 'Y',NVL(b.peril_cd,1),1) =
           DECODE(a.peril_sw, 'Y',NVL(p_peril_cd,1),1)
                      AND DECODE(a.tariff_sw,'Y',NVL(b.tariff_cd,'X'),'X') =
                          DECODE(a.tariff_sw,'Y',NVL(p_tariff_cd,'X'),'X'))
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
      p_line_cd    IN GIAC_RECAP_SUMM_EXT.line_cd%TYPE,
      p_subline_cd IN GIAC_RECAP_DTL_EXT.subline_cd%TYPE,
      p_rowno      OUT GIAC_RECAP_SUMM_EXT.rowno%TYPE,
      p_rowtitle   OUT GIAC_RECAP_SUMM_EXT.rowtitle%TYPE) IS
   BEGIN
      FOR grro IN (SELECT rowno, rowtitle
                     FROM GIAC_RECAP_OTHER_ROWS
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
      p_line_cd IN GIAC_RECAP_DTL_EXT.line_cd%TYPE,
   p_peril_cd IN GIAC_RECAP_DTL_EXT.peril_cd%TYPE,
   p_subline_cd IN GIAC_RECAP_DTL_EXT.subline_cd%TYPE,
   p_subline_lto IN GIAC_RECAP_DTL_EXT.subline_type_cd%TYPE,
   p_subline_tpcd IN GIAC_RECAP_DTL_EXT.subline_type_cd%TYPE,
   p_rowno   OUT GIAC_RECAP_SUMM_EXT.rowno%TYPE,
   p_rowtitle  OUT GIAC_RECAP_SUMM_EXT.rowtitle%TYPE) IS
   v_exs BOOLEAN := FALSE;
   v_ctpl BOOLEAN := FALSE;
   BEGIN
      --Check if LTO or NLTO(subline other than LTO)
      IF p_subline_cd = p_subline_lto THEN
         --Get the rowno and rowtitle for LTO
         FOR grrd IN (SELECT a.rowno, a.rowtitle
                        FROM GIAC_RECAP_ROW_DTL b, GIAC_RECAP_ROW a
                       WHERE 1=1
                         AND a.line_cd = b.line_cd
                         AND a.rowno = b.rowno
                         AND b.line_cd = p_line_cd
               AND b.subline_cd = p_subline_lto
          AND DECODE(a.subline_sw, 'Y', NVL(b.subline_cd,'X'),'X') =
                    DECODE(a.subline_sw, 'Y', NVL(p_subline_cd,'X'),'X')
                       AND DECODE(a.subline_tpcd_sw, 'Y', NVL(b.subline_type_cd,'X'),'X') =
                    DECODE(a.subline_tpcd_sw, 'Y', NVL(p_subline_tpcd,'X'),'X')
                         AND DECODE(a.peril_sw, 'Y',NVL(b.peril_cd,1),1) =
                    DECODE(a.peril_sw, 'Y',NVL(p_peril_cd,1),1)        )
         LOOP
      p_rowno := grrd.rowno;
   p_rowtitle := grrd.rowtitle;
   v_exs := TRUE;
   END LOOP;
   IF v_exs = FALSE THEN
      FOR c1 IN (SELECT rowno, rowtitle
                FROM GIAC_RECAP_ROW
      WHERE rowtitle = 'OTHER THAN CTPL LTO')
      LOOP
      p_rowno := c1.rowno;
      p_rowtitle := c1.rowtitle;
   END LOOP;
      END IF;
      ELSE
      --Get the rowno and rowtitle for NLTO
      FOR grrd IN (SELECT a.rowno, a.rowtitle
                     FROM GIAC_RECAP_ROW_DTL b, GIAC_RECAP_ROW a
                    WHERE 1=1
                      AND a.line_cd = b.line_cd
                      AND a.rowno = b.rowno
                      AND b.line_cd = p_line_cd
       AND b.subline_cd != p_subline_lto
       AND DECODE(a.subline_sw, 'Y', NVL(b.subline_cd,'X'),'X') =
                 DECODE(a.subline_sw, 'Y', NVL(p_subline_cd,'X'),'X')
                    AND DECODE(a.subline_tpcd_sw, 'Y', NVL(b.subline_type_cd,'X'),'X') =
                 DECODE(a.subline_tpcd_sw, 'Y', NVL(p_subline_tpcd,'X'),'X')
                      AND DECODE(a.peril_sw, 'Y',NVL(b.peril_cd,1),1) =
                 DECODE(a.peril_sw, 'Y',NVL(p_peril_cd,1),1))
         LOOP
      p_rowno := grrd.rowno;
   p_rowtitle := grrd.rowtitle;
   v_exs   := TRUE;
      END LOOP;
   IF v_exs = FALSE THEN
      --For ctpl peril_cd's
      FOR ctplcheck IN (SELECT 'X'
                                FROM GIAC_RECAP_ROW a, GIAC_RECAP_ROW_DTL b
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
                  FROM GIAC_RECAP_OTHER_ROWS
           WHERE line_cd = p_line_cd
             AND rowtitle = p_subline_cd)
      LOOP
         p_rowno := c2.rowno;
         p_rowtitle := c2.rowtitle;
      END LOOP;
   ELSE
      --This is other than ctpl - nlto - others
      FOR octploth IN (SELECT rowno, rowtitle
                         FROM GIAC_RECAP_ROW
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
      p_line_fi IN GIIS_LINE.line_cd%TYPE,
      p_line_mn IN GIIS_LINE.line_cd%TYPE,
      p_line_mh IN GIIS_LINE.line_cd%TYPE,
      p_line_av IN GIIS_LINE.line_cd%TYPE,
      p_line_su IN GIIS_LINE.line_cd%TYPE,
      p_line_mc IN GIIS_LINE.line_cd%TYPE,
      p_line_ac IN GIIS_LINE.line_cd%TYPE,
      p_line_en IN GIIS_LINE.line_cd%TYPE) IS
      v_rowno NUMBER;
   BEGIN
      --Truncate the table
      EXECUTE IMMEDIATE 'TRUNCATE TABLE GIAC_RECAP_OTHER_ROWS';

      --Get the rowno of the rowtitle OTHER
      FOR grr IN (SELECT rowno
                    FROM GIAC_RECAP_ROW
                   WHERE rowtitle = 'OTHERS')
      LOOP
         v_rowno := grr.rowno;
      END LOOP;
      IF v_rowno IS NULL THEN
         v_rowno := 1;
      END IF;

      FOR grot IN (SELECT b.line_cd, a.subline_cd rowtitle
                     FROM GIIS_SUBLINE a, GIIS_LINE b
                    WHERE 1=1
                      AND b.line_cd = a.line_cd
                      AND b.line_cd NOT IN(p_line_fi,p_line_mn,p_line_mh,p_line_av,
                                           p_line_su,p_line_mc,p_line_ac,p_line_en)
                     ORDER BY b.line_cd, a.subline_cd)
      LOOP
         --Insert into giac_recap_other_rows
         v_rowno := v_rowno + 1;
         INSERT INTO GIAC_RECAP_OTHER_ROWS(
            rowno, line_cd, rowtitle)
         VALUES(
            v_rowno, grot.line_cd, grot.rowtitle);
      END LOOP;
      COMMIT;
   END;

   --Procdure to populate the table giac_recap_other_rows for mc subline_cds
   PROCEDURE pop_recap_other_rowsmc(
      p_line_mc GIIS_LINE.line_cd%TYPE,
      p_subline_lto GIIS_SUBLINE.subline_cd%TYPE) IS
      v_rowno NUMBER;
   BEGIN
      --Get the rowno of the CTPL NON-LTO
      FOR Nlto IN (SELECT rowno
                     FROM GIAC_RECAP_ROW
                    WHERE rowtitle = 'CTPL NON-LTO')
      LOOP
         v_rowno := Nlto.rowno;
      END LOOP;
      IF v_rowno IS NULL THEN
         v_rowno := 1;
      END IF;

      --Populate the giac_recap_other_rows
      FOR grot IN (SELECT line_cd, subline_cd rowtitle
                  FROM GIIS_SUBLINE
                 WHERE line_cd = p_line_mc
                   AND subline_cd != p_subline_lto)
      LOOP
         --Insert into giac_recap_other_rows
         v_rowno := v_rowno + 0.01;
         INSERT INTO GIAC_RECAP_OTHER_ROWS(
            rowno, line_cd, rowtitle)
         VALUES(
            v_rowno, grot.line_cd, grot.rowtitle);
      END LOOP;
      COMMIT;
   END;

BEGIN
   --Truncate the table
   EXECUTE IMMEDIATE 'TRUNCATE TABLE GIAC_RECAP_SUMM_EXT';

   --Get the paramet line_cd's
   v_line_fi  := Giisp.v('LINE_CODE_FI');
   v_line_mn  := Giisp.v('LINE_CODE_MN');
   v_line_mh  := Giisp.v('LINE_CODE_MH');
   v_line_av  := Giisp.v('LINE_CODE_AV');
   v_line_su  := Giisp.v('LINE_CODE_SU');
   v_line_mc  := Giisp.v('LINE_CODE_MC');
   v_line_ac  := Giisp.v('LINE_CODE_AC');
   v_line_en  := Giisp.v('LINE_CODE_EN');
   v_line_mc  := Giisp.v('LINE_CODE_MC');
   v_subline_lto := Giisp.v('MC_SUBLINE_LTO');


   --Populate the giac_recap_other_rows table
   pop_recap_other_rows(v_line_fi,v_line_mn,v_line_mh,v_line_av,
                        v_line_su,v_line_mc,v_line_ac,v_line_en);

   --Populate the giac_recap_other_rows table for MC
   pop_recap_other_rowsmc(v_line_mc,v_subline_lto);

   --Build the collection
   SELECT policy_id, item_no,
          iss_cd, line_cd, subline_cd,
          peril_cd, SUBSTR(tariff_cd,1,1) tariff_cd, subline_type_cd,
          NVL(premium_amt,0) premium_amt, NVL(commission_amt,0) commission_amt,
          NVL(tsi_amt,0) tsi_amt,
          ri_cd, NVL(treaty_prem,0) treaty_prem, NVL(treaty_comm,0) treaty_comm,
          NVL(treaty_tsi,0) treaty_tsi,
          NVL(facul_prem,0) facul_prem, NVL(facul_comm,0) facul_comm,
          NVL(facul_tsi,0) facul_tsi,
          NVL(inw_ri_comm,0) inw_ri_comm,local_foreign_sw, cedant
     BULK COLLECT INTO
          vv_pol_id, vv_item_no,
       vv_iss_cd, vv_line_cd, vv_subline_cd,
    vv_peril_cd, vv_tariff_cd, vv_subln_tpcd,
    vv_premium_amt, vv_comm_amt, vv_tsi_amt,
    vv_ri_cd, vv_trty_prem, vv_trty_comm,
    vv_trty_tsi, vv_facul_prem, vv_facul_comm,
    vv_facul_tsi, vv_inw_ri_comm, vv_locfor_sw, vv_cedant
     FROM GIAC_RECAP_DTL_EXT;
   -- WHERE line_cd NOT IN (v_line_mc);
   --(v_line_fi,v_line_mn,v_line_mh,v_line_av,v_line_ac,v_line_en,v_line_su);

   --Check if theres data
   IF SQL%FOUND THEN
      --Loop in the collection
   FOR rec IN vv_iss_cd.FIRST.. vv_iss_cd.LAST
   LOOP
      --Initialize the values for the amounts
   --direct premium, tsi and comm
   v_dir_prem := 0;
   v_dir_tsi  := 0;
   v_dir_comm := 0;
   --ceded premium, tsi and comm
   --for authorized
   v_ced_prem_auth := 0;
   v_ced_tsi_auth  := 0;
   v_ced_comm_auth := 0;
   --for asean
   v_ced_prem_asean := 0;
   v_ced_tsi_asean  := 0;
   v_ced_comm_asean := 0;
   --for others
   v_ced_prem_oth := 0;
   v_ced_tsi_oth  := 0;
   v_ced_comm_oth := 0;
   --Assumed(INW) premium, tsi and comm
   --for authorized
   v_inw_prem_auth := 0;
   v_inw_tsi_auth  := 0;
   v_inw_comm_auth := 0;
   --for asean
   v_inw_prem_asean := 0;
   v_inw_tsi_asean  := 0;
   v_inw_comm_asean := 0;
   --for others
   v_inw_prem_oth := 0;
   v_inw_tsi_oth  := 0;
   v_inw_comm_oth := 0;
   --Retroceded premium, tsi and comm
   --for authorized
   v_ret_prem_auth := 0;
   v_ret_tsi_auth  := 0;
   v_ret_comm_auth := 0;
   --for asean
   v_ret_prem_asean := 0;
   v_ret_tsi_asean  := 0;
   v_ret_comm_asean := 0;
   --for others
   v_ret_prem_oth := 0;
   v_ret_tsi_oth  := 0;
   v_ret_comm_oth := 0;
   --Set the other variables
   v_rowno    := NULL;
   v_rowtitle := NULL;
         v_peril_type := get_peril_type(vv_line_cd(rec),vv_peril_cd(rec));
   v_tsi_tag := get_tsi_tag(vv_peril_cd(rec));

             --Get the bond_class_no if the line_cd = 'SU'
             IF vv_line_cd(rec) = 'SU' THEN
                v_bond_class_no := get_bond_class(vv_line_cd(rec),vv_subline_cd(rec));
             END IF;

   --Get the rowno and the rowtitle
             --Depends on the line of the record
             IF vv_line_cd(rec) IN (v_line_fi,v_line_mn,v_line_mh,v_line_av,v_line_ac,v_line_en,v_line_su) THEN
                get_rowthings(vv_line_cd(rec),vv_peril_cd(rec),vv_tariff_cd(rec), v_bond_class_no,v_rowno,v_rowtitle);
             ELSIF vv_line_cd(rec) IN (v_line_mc) THEN
                get_rowthings_mc(vv_line_cd(rec),vv_peril_cd(rec),vv_subline_cd(rec),v_subline_lto,vv_subln_tpcd(rec),v_rowno,v_rowtitle);
             ELSE
                get_rowthings_others(vv_line_cd(rec),vv_subline_cd(rec),v_rowno,v_rowtitle);
             END IF;
   /* 
   ** judyann 10242007 
   ** added condition (v_peril_type = 'A' AND v_tsi_tag = 'Y') 
   ** to include TSI of certain allied perils  
   */   
   --Set the amounts
   --direct premium, tsi and comm
   IF vv_iss_cd(rec) != 'RI' THEN
      v_dir_prem := vv_premium_amt(rec);
            --For Basic or Allied
            IF (v_peril_type = 'B')
      OR (v_peril_type = 'A' AND v_tsi_tag = 'Y') 
      THEN
               v_dir_tsi  := vv_tsi_amt(rec);
            ELSE
               v_dir_tsi  := 0;
            END IF;
      v_dir_comm := vv_comm_amt(rec);
      END IF;
   --Set ceded premium, tsi and comm
   IF vv_iss_cd(rec) != 'RI' THEN
   --for authorized
      IF vv_locfor_sw(rec) = 'L' THEN
         v_ced_prem_auth := vv_trty_prem(rec) + vv_facul_prem(rec);
               --For Basic or Allied
               IF (v_peril_type = 'B')
      OR (v_peril_type = 'A' AND v_tsi_tag = 'Y') 
      THEN
                v_ced_tsi_auth  := vv_trty_tsi(rec) + vv_facul_tsi(rec);
               ELSE
                  v_ced_tsi_auth  := 0;
               END IF;
         v_ced_comm_auth := vv_trty_comm(rec) + vv_facul_comm(rec);
   END IF;
   --for asean
      IF vv_locfor_sw(rec) = 'A' THEN
         v_ced_prem_asean := vv_trty_prem(rec) + vv_facul_prem(rec);
               --For Basic or Allied
               IF (v_peril_type = 'B')
      OR (v_peril_type = 'A' AND v_tsi_tag = 'Y')  
      THEN
            v_ced_tsi_asean  := vv_trty_tsi(rec) + vv_facul_tsi(rec);
               ELSE
                  v_ced_tsi_asean  := 0;
               END IF;
         v_ced_comm_asean := vv_trty_comm(rec) + vv_facul_comm(rec);
   END IF;
   --for others
      IF vv_locfor_sw(rec) = 'F' THEN
         v_ced_prem_oth := vv_trty_prem(rec) + vv_facul_prem(rec);
               --For Basic or Allied
               IF (v_peril_type = 'B')
         OR (v_peril_type = 'A' AND v_tsi_tag = 'Y') 
      THEN
            v_ced_tsi_oth  := vv_trty_tsi(rec) + vv_facul_tsi(rec);
               ELSE
                  v_ced_tsi_oth  := 0;
               END IF;
         v_ced_comm_oth := vv_trty_comm(rec)+ vv_facul_comm(rec);
   END IF;
         END IF;
   --Assumed(INW) premium, tsi and comm
             --The local_foreign_sw here is the cedant
   IF vv_iss_cd(rec) = 'RI' THEN
      --for authorized
            IF get_ced_locfor_sw(vv_cedant(rec)) = 'L' THEN
         v_inw_prem_auth := vv_premium_amt(rec);
               --For Basic or Allied
               IF (v_peril_type = 'B') 
         OR (v_peril_type = 'A' AND v_tsi_tag = 'Y') 
         THEN
            v_inw_tsi_auth  := vv_tsi_amt(rec);
               ELSE
                  v_inw_tsi_auth  := 0;
               END IF;
         v_inw_comm_auth := vv_inw_ri_comm(rec);
            END IF;
         --for asean
            IF get_ced_locfor_sw(vv_cedant(rec)) = 'A' THEN
         v_inw_prem_asean := vv_premium_amt(rec);
               --For Basic or Allied
               IF (v_peril_type = 'B')
         OR (v_peril_type = 'A' AND v_tsi_tag = 'Y') THEN
            v_inw_tsi_asean  := vv_tsi_amt(rec);
               ELSE
                  v_inw_tsi_asean  := 0;
               END IF;
         v_inw_comm_asean := vv_inw_ri_comm(rec);
            END IF;
      --for others
            IF get_ced_locfor_sw(vv_cedant(rec)) = 'F' THEN
               v_inw_prem_oth := vv_premium_amt(rec);
               --For Basic or Allied
               IF (v_peril_type = 'B')
         OR (v_peril_type = 'A' AND v_tsi_tag = 'Y') THEN
            v_inw_tsi_oth  := vv_tsi_amt(rec);
               ELSE
                  v_inw_tsi_oth  := 0;
               END IF;
         v_inw_comm_oth := vv_inw_ri_comm(rec);
            END IF;
         END IF;

   --Retroceded premium, tsi and comm
   IF vv_iss_cd(rec) = 'RI' THEN
         --for authorized
      IF vv_locfor_sw(rec) = 'L' THEN
         v_ret_prem_auth := vv_trty_prem(rec) + vv_facul_prem(rec);
               --For Basic or Allied
               IF (v_peril_type = 'B') 
         OR (v_peril_type = 'A' AND v_tsi_tag = 'Y') 
      THEN
            v_ret_tsi_auth  := vv_trty_tsi(rec) + vv_facul_prem(rec);
               ELSE
                  v_ret_tsi_auth  := 0;
               END IF;
         v_ret_comm_auth := vv_trty_comm(rec) + vv_facul_comm(rec);
   END IF;
   --for asean
      IF vv_locfor_sw(rec) = 'A' THEN
         v_ret_prem_asean := vv_trty_prem(rec) + vv_facul_prem(rec);
               --For Basic or Allied
               IF (v_peril_type = 'B') 
         OR (v_peril_type = 'A' AND v_tsi_tag = 'Y') 
      THEN
            v_ret_tsi_asean  := vv_trty_tsi(rec) + vv_facul_prem(rec);
               ELSE
                  v_ret_tsi_asean  := 0;
               END IF;
         v_ret_comm_asean := vv_trty_comm(rec) + vv_facul_comm(rec);
   END IF;
   --for others
      IF vv_locfor_sw(rec) = 'F' THEN
         v_ret_prem_oth := vv_trty_prem(rec) + vv_facul_prem(rec);
               --For Basic or Allied
               IF (v_peril_type = 'B') 
         OR (v_peril_type = 'A' AND v_tsi_tag = 'Y') THEN
            v_ret_tsi_oth  := vv_trty_tsi(rec) + vv_facul_prem(rec);
               ELSE
                  v_ret_tsi_oth  := 0;
               END IF;
         v_ret_comm_oth := vv_trty_comm(rec) + vv_facul_comm(rec);
      END IF;
         END IF;

         --Insert the data into the summary table
   INSERT INTO GIAC_RECAP_SUMM_EXT(
      rowno, rowtitle,
            policy_id, item_no, peril_cd,
            iss_cd, line_cd, ri_cd,
   cedant_cd, ri_type, direct_prem, direct_comm, direct_tsi,
   inw_prem_auth, inw_comm_auth, inw_tsi_auth, inw_prem_asean, inw_comm_asean,
   inw_tsi_asean, inw_prem_oth, inw_comm_oth, inw_tsi_oth, ceded_prem_auth,
   ceded_comm_auth, ceded_tsi_auth, ceded_prem_asean, ceded_comm_asean, ceded_tsi_asean,
   ceded_prem_oth, ceded_comm_oth, ceded_tsi_oth, retceded_prem_auth, retceded_comm_auth,
   retceded_tsi_auth, retceded_prem_asean, retceded_comm_asean, retceded_tsi_asean, retceded_prem_oth,
   retceded_comm_oth, retceded_tsi_oth)
   VALUES(
      v_rowno, v_rowtitle,
            vv_pol_id(rec), vv_item_no(rec), vv_peril_cd(rec),
            vv_iss_cd(rec), vv_line_cd(rec), vv_ri_cd(rec),
   vv_cedant(rec), '?', v_dir_prem, v_dir_comm, v_dir_tsi,
   v_inw_prem_auth, v_inw_comm_auth, v_inw_tsi_auth, v_inw_prem_asean, v_inw_comm_asean,
   v_inw_tsi_asean, v_inw_prem_oth, v_inw_comm_oth, v_inw_tsi_oth, v_ced_prem_auth,
   v_ced_comm_auth, v_ced_tsi_auth, v_ced_prem_asean, v_ced_comm_asean, v_ced_tsi_asean,
   v_ced_prem_oth, v_ced_comm_oth, v_ced_tsi_oth, v_ret_prem_auth, v_ret_comm_auth,
   v_ret_tsi_auth, v_ret_prem_asean, v_ret_comm_asean, v_ret_tsi_asean, v_ret_prem_oth,
   v_ret_comm_oth, v_ret_tsi_oth);
      END LOOP;
      COMMIT;
   END IF;
END;
/


