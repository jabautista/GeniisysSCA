CREATE OR REPLACE PACKAGE BODY CPI.GIIS_VESSEL_PKG AS

  FUNCTION get_marine_hull_list--(p_vessel_cd       GIIS_VESSEL.vessel_cd%TYPE)
    RETURN marine_hull_tab PIPELINED IS
    v_vessel                  marine_hull_type;
  BEGIN
    FOR i IN (SELECT a260.vessel_name, a260.vessel_flag, nvl(a260.vessel_old_name,'-') vessel_old_name,
                     a260.vestype_cd, a270.vestype_desc,
                     DECODE(a260.propel_sw,'S','SELF-PROPELLED','NON-PROPELLED') propel_sw,
                     a260.hull_type_cd, nvl(a690.hull_desc, '-')hull_desc, a260.gross_ton, a260.year_built,
                     a260.vess_class_cd, a700.vess_class_desc, a260.vessel_cd,
                     nvl(a260.reg_owner,'-')reg_owner, nvl(a260.reg_place,'-')reg_place,
      a260.no_crew, a260.net_ton, a260.deadweight, nvl(a260.crew_nat, '-')crew_nat,
      a260.vessel_breadth, a260.vessel_depth, a260.vessel_length, nvl(a260.dry_place,'-')dry_place, a260.dry_date
                FROM giis_vessel a260,
                     giis_vestype a270,
                     giis_hull_type a690,
                     giis_vess_class a700
               WHERE vessel_flag = 'V'
                 AND a270.vestype_cd = a260.vestype_cd
                 AND a690.hull_type_cd = a260.hull_type_cd
                 AND a700.vess_class_cd = a260.vess_class_cd
                 AND a260.vessel_cd <> (SELECT param_value_v
                                          FROM giis_parameters
                                         WHERE param_name = 'VESSEL_CD_MULTI')
)
    LOOP
      v_vessel.VESSEL_CD       := i.VESSEL_CD;
      v_vessel.VESSEL_NAME     := i.VESSEL_NAME;
      v_vessel.VESSEL_FLAG     := i.VESSEL_FLAG;
      v_vessel.VESSEL_OLD_NAME := i.VESSEL_OLD_NAME;
      v_vessel.VESTYPE_CD      := i.VESTYPE_CD;
      v_vessel.VESTYPE_DESC    := i.VESTYPE_DESC;
      v_vessel.PROPEL_SW       := i.propel_sw;
      v_vessel.HULL_TYPE_CD    := i.HULL_TYPE_CD;
      v_vessel.HULL_DESC       := i.hull_desc;
      v_vessel.GROSS_TON       := i.gross_ton;
      v_vessel.YEAR_BUILT      := i.year_built;
      v_vessel.VESS_CLASS_CD   := i.vess_class_cd;
      v_vessel.VESS_CLASS_DESC := i.vess_class_desc;
      v_vessel.REG_OWNER       := i.reg_owner;
      v_vessel.REG_PLACE       := i.reg_place;
   v_vessel.NO_CREW     := i.no_crew;
   v_vessel.NET_TON     := i.net_ton;
   v_vessel.DEADWEIGHT    := i.deadweight;
   v_vessel.CREW_NAT     := i.crew_nat;
   v_vessel.VESSEL_BREADTH  := i.vessel_breadth;
   v_vessel.VESSEL_DEPTH    := i.vessel_depth;
   v_vessel.VESSEL_LENGTH   := i.vessel_length;
   v_vessel.DRY_PLACE    := i.dry_place;
   v_vessel.DRY_DATE     := i.dry_date;
      PIPE ROW(v_vessel);
 END LOOP;
 RETURN;
  END get_marine_hull_list;

  /*Indicates if vessel has existing endorsement in GIPI_POLICY
   * BJGA - GIPI081
   */
  FUNCTION get_marine_hull_list2(p_line_cd       gipi_wpolbas.line_cd%TYPE,
         p_subline_cd    gipi_wpolbas.subline_cd%TYPE,
         p_iss_cd        gipi_wpolbas.iss_cd%TYPE,
         p_issue_yy      gipi_wpolbas.issue_yy%TYPE,
         p_pol_seq_no    gipi_wpolbas.pol_seq_no%TYPE,
         p_renew_no      gipi_wpolbas.renew_no%TYPE)
    RETURN marine_hull_tab PIPELINED IS
    v_vessel                  marine_hull_type;
  BEGIN
    FOR i IN (SELECT a260.vessel_name, a260.vessel_flag, nvl(a260.vessel_old_name,'-') vessel_old_name,
                     a260.vestype_cd, a270.vestype_desc,
                     DECODE(a260.propel_sw,'S','SELF-PROPELLED','NON-PROPELLED') propel_sw,
                     a260.hull_type_cd, nvl(a690.hull_desc, '-')hull_desc, a260.gross_ton, a260.year_built,
                     a260.vess_class_cd, a700.vess_class_desc, a260.vessel_cd,
                     nvl(a260.reg_owner,'-')reg_owner, nvl(a260.reg_place,'-')reg_place,
      a260.no_crew, a260.net_ton, a260.deadweight, nvl(a260.crew_nat, '-')crew_nat,
      a260.vessel_breadth, a260.vessel_depth, a260.vessel_length, nvl(a260.dry_place,'-')dry_place, a260.dry_date
                FROM giis_vessel a260,
                     giis_vestype a270,
                     giis_hull_type a690,
                     giis_vess_class a700
               WHERE vessel_flag = 'V'
                 AND a270.vestype_cd = a260.vestype_cd
                 AND a690.hull_type_cd = a260.hull_type_cd
                 AND a700.vess_class_cd = a260.vess_class_cd
                 AND a260.vessel_cd <> (SELECT param_value_v
                                          FROM giis_parameters
                                         WHERE param_name = 'VESSEL_CD_MULTI')
)
    LOOP
      v_vessel.VESSEL_CD       := i.VESSEL_CD;
      v_vessel.VESSEL_NAME     := i.VESSEL_NAME;
      v_vessel.VESSEL_FLAG     := i.VESSEL_FLAG;
      v_vessel.VESSEL_OLD_NAME := i.VESSEL_OLD_NAME;
      v_vessel.VESTYPE_CD      := i.VESTYPE_CD;
      v_vessel.VESTYPE_DESC    := i.VESTYPE_DESC;
      v_vessel.PROPEL_SW       := i.propel_sw;
      v_vessel.HULL_TYPE_CD    := i.HULL_TYPE_CD;
      v_vessel.HULL_DESC       := i.hull_desc;
      v_vessel.GROSS_TON       := i.gross_ton;
      v_vessel.YEAR_BUILT      := i.year_built;
      v_vessel.VESS_CLASS_CD   := i.vess_class_cd;
      v_vessel.VESS_CLASS_DESC := i.vess_class_desc;
      v_vessel.REG_OWNER       := i.reg_owner;
      v_vessel.REG_PLACE       := i.reg_place;
   v_vessel.NO_CREW     := i.no_crew;
   v_vessel.NET_TON     := i.net_ton;
   v_vessel.DEADWEIGHT    := i.deadweight;
   v_vessel.CREW_NAT     := i.crew_nat;
   v_vessel.VESSEL_BREADTH  := i.vessel_breadth;
   v_vessel.VESSEL_DEPTH    := i.vessel_depth;
   v_vessel.VESSEL_LENGTH   := i.vessel_length;
   v_vessel.DRY_PLACE    := i.dry_place;
   v_vessel.DRY_DATE     := i.dry_date;   v_vessel.ENDORSED_TAG    := GIIS_VESSEL_PKG.validate_vessel(p_line_cd,
                  p_subline_cd,
                  p_iss_cd,
                  p_issue_yy,
                  p_pol_seq_no,
                  p_renew_no,
                     i.vessel_name);
      PIPE ROW(v_vessel);
 END LOOP;
 RETURN;
  END get_marine_hull_list2;

  FUNCTION get_pol_doc_vessel(p_vessel_cd    GIIS_VESSEL.vessel_cd%TYPE)
    RETURN pol_doc_vessel_tab PIPELINED IS
 v_vessel      pol_doc_vessel_type;
  BEGIN
    FOR i IN (SELECT  A.VESSEL_CD    VESSEL_VESSEL_CD,
          DECODE(A.VESSEL_CD, 'MULTI', A.VESSEL_NAME,A.VESSEL_NAME || ' (' ||
           DECODE(A.VESSEL_FLAG, 'V', 'VESSEL',
           DECODE(A.VESSEL_FLAG, 'I', 'INLAND', 'AIRCRAFT')) || ')' ) VESSEL_VESSEL_NAME,
                   A.MOTOR_NO     VESSEL_MOTOR_NO,
       A.SERIAL_NO    VESSEL_SERIAL_NO,
       A.PLATE_NO     VESSEL_PLATE_NO,
       A.VESTYPE_CD   VESSEL_VESTYPE_CD
       FROM  GIIS_VESSEL A
      WHERE  A.VESSEL_CD = p_vessel_cd)
 LOOP
   v_vessel.VESSEL_VESSEL_CD   := i.VESSEL_VESSEL_CD;
   v_vessel.VESSEL_VESSEL_NAME := i.VESSEL_VESSEL_NAME;
   v_vessel.VESSEL_MOTOR_NO    := i.VESSEL_MOTOR_NO;
   v_vessel.VESSEL_SERIAL_NO   := i.VESSEL_SERIAL_NO;
   v_vessel.VESSEL_PLATE_NO    := i.VESSEL_PLATE_NO;
   v_vessel.VESSEL_VESTYPE_CD  := i.VESSEL_VESTYPE_CD;
   PIPE ROW(v_vessel);
 END LOOP;
 RETURN;
  END get_pol_doc_vessel;


/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  April 29, 2010
**  Reference By :  (GIPIS007 - Carrier Information)
**  Description  : Function to get vessel list used in carrier information module.
*/
  FUNCTION get_vessel_list
    RETURN vessel_list_tab PIPELINED IS
 
 v_vessel vessel_list_type;

  BEGIN
    FOR i IN (
  SELECT vessel_name,
      DECODE(vessel_flag, 'V', 'Vessel',
                DECODE(vessel_flag, 'I', 'Inland',
             DECODE(vessel_flag, 'A', 'Aircraft', ' '))) vessel_type,
         vessel_flag, vessel_cd, plate_no, motor_no, serial_no
    FROM GIIS_VESSEL
   ORDER BY vessel_name)
 LOOP
  v_vessel.vessel_name  := i.vessel_name;
   v_vessel.vessel_type  := i.vessel_type;
   v_vessel.vessel_flag  := i.vessel_flag;
  v_vessel.vessel_cd     := i.vessel_cd;
   PIPE ROW(v_vessel);
 END LOOP;

    RETURN;
  END get_vessel_list;

  FUNCTION get_vessel_list2(p_par_id    gipi_wves_air.par_id%TYPE,
               p_geog_cd      giis_geog_class.geog_cd%TYPE)
    RETURN giis_vessel_tab PIPELINED IS
 v_vessel  giis_vessel_type;
  BEGIN
    FOR i IN (SELECT a260.vessel_name dsp_vessel_name ,a260.vessel_flag dsp_vessel_flag ,a260.vessel_cd vessel_cd
             FROM giis_vessel a260
      WHERE vessel_flag IN (SELECT class_type
                 FROM giis_geog_class
               WHERE geog_cd = nvl(p_geog_cd, geog_cd) )
     AND vessel_cd IN (SELECT vessel_cd
               FROM gipi_wves_air
              WHERE par_id = p_par_id)
      ORDER BY upper(dsp_vessel_name))
 LOOP
   v_vessel.vessel_cd    := i.vessel_cd;
   v_vessel.vessel_name  := i.dsp_vessel_name;
   v_vessel.vessel_flag  := i.dsp_vessel_flag;
 PIPE ROW(v_vessel);
 END LOOP;
 RETURN;
  END get_vessel_list2;

  FUNCTION get_vessel_carrier_list(p_par_id    gipi_wves_air.par_id%TYPE)
    RETURN giis_vessel_tab PIPELINED IS
 v_vessel  giis_vessel_type;
  BEGIN
    FOR i IN (SELECT a260.vessel_name dsp_vessel_name, a260.vessel_flag dsp_vessel_flag ,
            a260.vessel_cd vessel_cd, a260.plate_no plate_no ,a260.motor_no motor_no ,a260.serial_no serial_no
       FROM giis_vessel a260
      WHERE vessel_cd IN (SELECT vessel_cd
                        FROM gipi_wves_air
           WHERE par_id = p_par_id
             AND vessel_cd != 'MULTI')
    ORDER BY upper(dsp_vessel_name))
 LOOP
   v_vessel.vessel_cd         := i.vessel_cd;
   v_vessel.vessel_name    := i.dsp_vessel_name;
   v_vessel.vessel_flag    := i.dsp_vessel_flag;
   v_vessel.vessel_plate_no  := i.plate_no;
   v_vessel.vessel_motor_no  := i.motor_no;
   v_vessel.vessel_serial_no  := i.serial_no;
 PIPE ROW(v_vessel);
 END LOOP;
 RETURN;
  END get_vessel_carrier_list;

  FUNCTION get_vessel_list3(p_par_id    gipi_waviation_item.par_id%TYPE)
    RETURN giis_vessel_tab PIPELINED IS
    v_vessel  giis_vessel_type;
  BEGIN
    FOR i IN (SELECT distinct(a260.vessel_cd) vessel_cd, a260.vessel_name dsp_vessel_name,
            a260.vessel_old_name dsp_vessel_old_name, a260.vessel_flag dsp_vessel_flag,
         a260.rpc_no dsp_rpc_no, a260.air_type_cd dsp_air_type_cd, a680.air_desc dsp_air_desc,
         a260.no_pass dsp_no_pass--, a950.par_id
      FROM giis_vessel a260, giis_air_type a680, gipi_waviation_item a950
       WHERE vessel_flag = 'A'
                 AND a680.air_type_cd = a260.air_type_cd
        AND a950.par_id = p_par_id
        AND a260.vessel_cd <> a950.vessel_cd
             MINUS
              SELECT distinct(a260.vessel_cd) vessel_cd, a260.vessel_name dsp_vessel_name,
           a260.vessel_old_name dsp_vessel_old_name, a260.vessel_flag dsp_vessel_flag,
         a260.rpc_no dsp_rpc_no, a260.air_type_cd dsp_air_type_cd, a680.air_desc dsp_air_desc,
         a260.no_pass dsp_no_pass--, a950.par_id
                FROM giis_vessel a260, giis_air_type a680, gipi_waviation_item a950
               WHERE vessel_flag = 'A'
                 AND a680.air_type_cd = a260.air_type_cd
      AND a950.par_id = p_par_id
      AND a260.vessel_cd = a950.vessel_cd)
 LOOP
   v_vessel.vessel_cd           := i.vessel_cd;
   v_vessel.vessel_name      := i.dsp_vessel_name;
   v_vessel.vessel_flag      := i.dsp_vessel_flag;
   v_vessel.vessel_old_name    := i.dsp_vessel_old_name;
   v_vessel.vessel_rpc_no    := i.dsp_rpc_no;
   v_vessel.vessel_air_type_cd  := i.dsp_air_type_cd;
   v_vessel.vessel_air_desc    := i.dsp_air_desc;
   v_vessel.vessel_no_pass    := i.dsp_no_pass;
      PIPE ROW(v_vessel);
 END LOOP;
 RETURN;
  END get_vessel_list3;

  FUNCTION get_vessel_list4
    RETURN giis_vessel_tab PIPELINED IS
    v_vessel  giis_vessel_type;
  BEGIN
    FOR i IN (SELECT a260.vessel_cd vessel_cd, a260.vessel_name dsp_vessel_name /* cg$fk */ ,
            a260.vessel_old_name dsp_vessel_old_name ,a260.vessel_flag dsp_vessel_flag ,
         a260.rpc_no dsp_rpc_no ,a260.air_type_cd dsp_air_type_cd ,a680.air_desc dsp_air_desc ,
         a260.no_pass dsp_no_pass
      FROM giis_vessel a260 ,giis_air_type a680
       WHERE vessel_flag = 'A'
           AND a680.air_type_cd = a260.air_type_cd
      ORDER BY upper(dsp_vessel_name))
 LOOP
   v_vessel.vessel_cd           := i.vessel_cd;
   v_vessel.vessel_name      := i.dsp_vessel_name;
   v_vessel.vessel_flag      := i.dsp_vessel_flag;
   v_vessel.vessel_old_name    := i.dsp_vessel_old_name;
   v_vessel.vessel_rpc_no    := i.dsp_rpc_no;
   v_vessel.vessel_air_type_cd  := i.dsp_air_type_cd;
   v_vessel.vessel_air_desc    := i.dsp_air_desc;
   v_vessel.vessel_no_pass    := i.dsp_no_pass;
      PIPE ROW(v_vessel);
 END LOOP;
 RETURN;
  END get_vessel_list4;

  FUNCTION get_air_vessel_list
    RETURN air_vessel_list_tab PIPELINED IS
 v_air_vessel     air_vessel_list_type;
  BEGIN
    FOR i IN (SELECT a.no_pass, a.vessel_cd, a.vessel_old_name ,a.vessel_name, a.rpc_no, a.vessel_flag, b.air_desc, b.air_type_cd
         FROM giis_vessel a, giis_air_type b
       WHERE a.air_type_cd = b.air_type_cd
      ORDER BY upper(vessel_name))
 LOOP
  v_air_vessel.vessel_cd    := i.vessel_cd;
  v_air_vessel.vessel_name   := i.vessel_name;
  v_air_vessel.rpc_no     := i.rpc_no;
  v_air_vessel.vessel_flag   := i.vessel_flag;
  v_air_vessel.air_desc    := i.air_desc;
  v_air_vessel.vessel_old_name  := i.vessel_old_name;
  v_air_vessel.air_type_cd   := i.air_type_cd;
  v_air_vessel.no_pass    := i.no_pass;
  PIPE ROW(v_air_vessel);
 END LOOP;

  END get_air_vessel_list;

  FUNCTION get_quote_vessel_list(p_quote_id GIPI_QUOTE.quote_id%TYPE)
    RETURN giis_vessel_tab/*vessel_list_tab*/ PIPELINED IS
    v_vessel_list giis_vessel_type;
  BEGIN
    FOR i IN (SELECT gv.vessel_name, gv.vessel_cd
            FROM gipi_quote_ves_air gqva, giis_vessel gv
          WHERE 1=1
                 AND gv.vessel_cd  = gqva.vessel_cd
                 AND gqva.quote_id = p_quote_id)
 LOOP
   v_vessel_list.vessel_name := i.vessel_name;
   v_vessel_list.vessel_cd := i.vessel_cd;
   PIPE ROW(v_vessel_list);
 END LOOP;
  END get_quote_vessel_list;
/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  August 06, 2010
**  Reference By :  (GIPIS068 - Endt Marine Cargo Item Information)
**  Description  : Function to get vessel list of previous policy/ies.
*/
  FUNCTION get_carrier_list (p_par_id  GIPI_POLBASIC.par_id%TYPE
                             --p_geog_cd GIIS_GEOG_CLASS.geog_cd%TYPE
                             )
    RETURN vessel_list_tab PIPELINED IS

    v_vessel vessel_list_type;

  BEGIN
    FOR i IN (
      SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
        FROM GIPI_WPOLBAS
       WHERE par_id = p_par_id)
    LOOP
      FOR j IN (
        SELECT a1.vessel_name, a1.vessel_flag, a1.vessel_cd
             FROM giis_vessel a1
      WHERE vessel_cd IN (SELECT vessel_cd
               FROM gipi_wves_air
              WHERE par_id = p_par_id)
        UNION ALL
        SELECT v.vessel_name, v.vessel_flag, v.vessel_cd
          FROM giis_vessel v
         WHERE vessel_cd IN (SELECT vessel_cd
                               FROM gipi_ves_air g, gipi_polbasic h
                              WHERE g.policy_id  = h.policy_id
                                AND h.line_cd    = i.line_cd
                                AND h.subline_cd = i.subline_cd
                                AND h.iss_cd     = i.iss_cd
                                AND h.issue_yy   = i.issue_yy
                                AND h.pol_seq_no = i.pol_seq_no
                                AND h.renew_no   = i.renew_no
                                AND NOT EXISTS (SELECT 'Y'
                                                  FROM gipi_cargo_carrier j, gipi_polbasic k
                                                 WHERE j.policy_id  = k.policy_id
                                                   AND g.vessel_cd  = j.vessel_cd
                                                   AND k.line_cd    = h.line_cd
                                                   AND k.subline_cd = h.subline_cd
                                                   AND k.iss_cd     = h.iss_cd
                                                   AND k.issue_yy   = h.issue_yy
                                                   AND k.pol_seq_no = h.pol_seq_no
                                                   AND k.renew_no   = h.renew_no
                                                   AND NVL (j.delete_sw, 'N') = 'Y'))
         ORDER BY 1)
      LOOP
        v_vessel.vessel_cd   := j.vessel_cd;
        v_vessel.vessel_name := j.vessel_name;
        v_vessel.vessel_flag := j.vessel_flag;
        PIPE ROW(v_vessel);
      END LOOP;

      EXIT;
    END LOOP;

    RETURN;
  END get_carrier_list;
  /* Formatted on 2010/08/27 10:37 (Formatter Plus v4.8.7) */
FUNCTION validate_vessel (
   p_line_cd       gipi_wpolbas.line_cd%TYPE,
   p_subline_cd    gipi_wpolbas.subline_cd%TYPE,
   p_iss_cd        gipi_wpolbas.iss_cd%TYPE,
   p_issue_yy      gipi_wpolbas.issue_yy%TYPE,
   p_pol_seq_no    gipi_wpolbas.pol_seq_no%TYPE,
   p_renew_no      gipi_wpolbas.renew_no%TYPE,
   p_vessel_name   giis_vessel.vessel_name%TYPE
)
   RETURN VARCHAR2
IS
   v_vessel_cd   gipi_witem_ves.vessel_cd%TYPE;
   v_validated   VARCHAR2 (1)                    := 'Y';
BEGIN
   FOR item IN (SELECT DISTINCT item_no item
                           FROM gipi_item
                          WHERE policy_id IN (
                                   SELECT policy_id
                                     FROM gipi_polbasic
                                    WHERE line_cd = p_line_cd
                                      AND subline_cd = p_subline_cd
                                      AND iss_cd = p_iss_cd
                                      AND issue_yy = p_issue_yy
                                      AND pol_seq_no = p_pol_seq_no
                                      AND renew_no = p_renew_no
                                      AND pol_flag IN ('1', '2', '3', 'X')))
   LOOP
      FOR vessel IN (SELECT a.vessel_cd
                       FROM gipi_item_ves a, gipi_polbasic b
                      WHERE a.policy_id = b.policy_id
                        AND b.line_cd = p_line_cd
                        AND b.subline_cd = p_subline_cd
                        AND b.iss_cd = p_iss_cd
                        AND b.issue_yy = p_issue_yy
                        AND b.pol_seq_no = p_pol_seq_no
                        AND b.renew_no = p_renew_no
                        AND b.eff_date =
                               (SELECT MAX (eff_date)
                                  FROM gipi_item_ves d, gipi_polbasic c
                                 WHERE d.policy_id = c.policy_id
                                   AND c.line_cd = p_line_cd
                                   AND c.subline_cd = p_subline_cd
                                   AND c.iss_cd = p_iss_cd
                                   AND c.issue_yy = p_issue_yy
                                   AND c.pol_seq_no = p_pol_seq_no
                                   AND c.renew_no = p_renew_no
                                   AND c.pol_flag IN ('1', '2', '3', 'X')
                                   AND d.item_no = item.item)
                        AND a.item_no = item.item)
      LOOP
         FOR chk IN (SELECT a.rec_flag flag
                       FROM gipi_item a, gipi_polbasic b
                      WHERE a.policy_id = b.policy_id
                        AND b.line_cd = p_line_cd
                        AND b.subline_cd = p_subline_cd
                        AND b.iss_cd = p_iss_cd
                        AND b.issue_yy = p_issue_yy
                        AND b.pol_seq_no = p_pol_seq_no
                        AND b.renew_no = p_renew_no
                        AND b.eff_date =
                               (SELECT MAX (eff_date)
                                  FROM gipi_item d, gipi_polbasic c
                                 WHERE d.policy_id = c.policy_id
                                   AND c.line_cd = p_line_cd
                                   AND c.subline_cd = p_subline_cd
                                   AND c.iss_cd = p_iss_cd
                                   AND c.issue_yy = p_issue_yy
                                   AND c.pol_seq_no = p_pol_seq_no
                                   AND c.renew_no = p_renew_no
  AND c.pol_flag IN ('1', '2', '3', 'X')
                                   AND d.item_no = item.item)
                        AND a.item_no = item.item)
         LOOP
            IF chk.flag <> 'D'
            THEN
               FOR NAME IN (SELECT vessel_name
                              FROM giis_vessel
                             WHERE vessel_cd = vessel.vessel_cd)
               LOOP
                  IF RTRIM (LTRIM (NAME.vessel_name)) =
                                                RTRIM (LTRIM (p_vessel_name))
                  THEN
                     /*msg_alert
                        ('Vessel has already been covered by a previous policy.  Vessel should be unique.',
                         'I',
                         TRUE
                        );*/
                     v_validated := 'N';
                  END IF;
               END LOOP;
            END IF;
         END LOOP;
      END LOOP;
   END LOOP;

   RETURN v_validated;
END validate_vessel;
/**
* Rey Jadlocon
* 08.18.2011
* carrier list
**/
FUNCTION get_carrie_list(p_policy_id        gipi_cargo.policy_id%TYPE)
         RETURN  get_carrie_list_tab PIPELINED
       IS
         v_carrier_list get_carrie_list_type;
    BEGIN
     FOR i IN(SELECT a.vessel_cd,a.vessel_name
                FROM giis_vessel a,GIPI_CARGO_CARRIER b,gipi_cargo c
               WHERE a.vessel_cd = b.vessel_cd
                 AND b.policy_id = c.policy_id
                 AND b.item_no = c.item_no
                 AND c.policy_id = p_policy_id)
     LOOP
        v_carrier_list.vessel_cd        := i.vessel_cd;
        v_carrier_list.vessel_name      := i.vessel_name;
        PIPE ROW(v_carrier_list);
     END LOOP;
     
    END get_carrie_list;
    
    /*    Date        Author                    Description
    **    ==========    ====================    ===================        
    **    09.20.2011    mark jm                 created get_vessel_carrier_list_tg
    */  
    FUNCTION get_vessel_carrier_list_tg(
        p_par_id IN gipi_wves_air.par_id%TYPE,
        p_vessel_name IN giis_vessel.vessel_name%TYPE)
    RETURN giis_vessel_tab PIPELINED
    IS
        v_vessel  giis_vessel_type;
    BEGIN
        FOR i IN (
            SELECT a.vessel_name,     a.vessel_flag,     a.vessel_cd, 
                   a.plate_no,        a.motor_no,        a.serial_no
              FROM giis_vessel a
             WHERE vessel_cd IN (
                    SELECT vessel_cd
                      FROM gipi_wves_air
                     WHERE par_id = p_par_id
               AND vessel_cd != 'MULTI')
               AND UPPER(a.vessel_name) LIKE NVL(UPPER(p_vessel_name), '%%')
        ORDER BY UPPER(vessel_name))
        LOOP
            v_vessel.vessel_cd            := i.vessel_cd;
            v_vessel.vessel_name        := i.vessel_name;
            v_vessel.vessel_flag        := i.vessel_flag;
            v_vessel.vessel_plate_no    := i.plate_no;
            v_vessel.vessel_motor_no    := i.motor_no;
            v_vessel.vessel_serial_no    := i.serial_no;
            PIPE ROW(v_vessel);
        END LOOP;
        RETURN;
    END get_vessel_carrier_list_tg;
    
    /*    Date        Author                    Description
    **    ==========    ====================    ===================        
    **    11.29.2011    mark jm                 created get_marine_hull_vessel_tg (used in item info - marine hull)
    */ 
    FUNCTION get_marine_hull_vessel_tg(
        p_par_id IN gipi_witem.par_id%TYPE,
        p_item_no IN gipi_witem.item_no%TYPE,
        p_find_text IN VARCHAR2)
    RETURN marine_hull_tab PIPELINED
    IS
        v_vessel marine_hull_type;
    BEGIN
        FOR i IN (
            SELECT a.vessel_name,        a.vessel_flag,        a.vessel_old_name,    a.vestype_cd,    b.vestype_desc,
                   decode(a.propel_sw,'S','SELF-PROPELLED','NON-PROPELLED') propel_sw ,
                   a.hull_type_cd,        c.hull_desc,        a.gross_ton,        a.year_built,    a.vess_class_cd,
                   d.vess_class_desc,    a.vessel_cd,        a.reg_owner,        a.reg_place,    a.no_crew,
                   a.net_ton,            a.deadweight,        a.crew_nat,            a.dry_place,    a.dry_date,
                   a.vessel_length,        a.vessel_breadth,    a.vessel_depth
              FROM giis_vessel a,
                   giis_vestype b,
                   giis_hull_type c,
                   giis_vess_class d 
             WHERE vessel_flag = 'V' 
               AND b.vestype_cd = a.vestype_cd 
               AND c.hull_type_cd = a.hull_type_cd 
               AND d.vess_class_cd = a.vess_class_cd
               AND a.vessel_cd <> (SELECT param_value_v FROM giis_parameters WHERE param_name = 'VESSEL_CD_MULTI') 
               AND NOT EXISTS (SELECT '1' 
                                 FROM gipi_witem_ves a710 
                                WHERE a710.par_id = p_par_id 
                                  AND a710.vessel_cd = a.vessel_cd 
                                  AND a710.item_no <> p_item_no)
               AND (UPPER(a.vessel_name) LIKE UPPER(NVL(p_find_text, '%%')) OR
                    UPPER(a.vessel_old_name) LIKE UPPER(NVL(p_find_text, '%%')) OR
                    UPPER(b.vestype_desc) LIKE UPPER(NVL(p_find_text, '%%')) OR
                    UPPER(a.vessel_old_name) LIKE UPPER(NVL(p_find_text, '%%')) OR 
                    UPPER(c.hull_desc) LIKE UPPER(NVL(p_find_text, '%%')) OR
                    UPPER(a.crew_nat) LIKE UPPER(NVL(p_find_text, '%%'))))
        LOOP
            v_vessel.vessel_name         := i.vessel_name;
            v_vessel.vessel_flag         := i.vessel_flag;
            v_vessel.vessel_old_name     := i.vessel_old_name;
            v_vessel.vestype_cd          := i.vestype_cd;
            v_vessel.vestype_desc        := i.vestype_desc;
            v_vessel.propel_sw           := i.propel_sw;
            v_vessel.hull_type_cd        := i.hull_type_cd;
            v_vessel.hull_desc           := i.hull_desc;
            v_vessel.gross_ton           := i.gross_ton;
            v_vessel.year_built          := i.year_built;
            v_vessel.vess_class_cd       := i.vess_class_cd;
            v_vessel.vess_class_desc     := i.vess_class_desc;
            v_vessel.vessel_cd           := i.vessel_cd;                
            v_vessel.reg_owner           := i.reg_owner;
            v_vessel.reg_place           := i.reg_place;
            v_vessel.no_crew            := i.no_crew;
            v_vessel.net_ton            := i.net_ton;
            v_vessel.deadweight            := i.deadweight;
            v_vessel.crew_nat            := i.crew_nat;
            v_vessel.dry_place            := i.dry_place;
            v_vessel.dry_date            := i.dry_date;
            v_vessel.vessel_length        := i.vessel_length;
            v_vessel.vessel_breadth        := i.vessel_breadth;
            v_vessel.vessel_depth        := i.vessel_depth;            
            
            PIPE ROW(v_vessel);
        END LOOP;        
    END get_marine_hull_vessel_tg;
    
    /*    Date        Author                    Description
    **    ==========    ====================    ===================        
    **    11.29.2011    mark jm                 created get_aviation_vessel_tg (used in item info - aviation)
    */ 
    FUNCTION get_aviation_vessel_tg(p_find_text IN VARCHAR2)
    RETURN giis_vessel_tab PIPELINED
    IS
        v_vessel  giis_vessel_type;
    BEGIN
        FOR i IN (
            SELECT a.vessel_cd vessel_cd, a.vessel_name dsp_vessel_name,
                   a.vessel_old_name dsp_vessel_old_name, a.vessel_flag dsp_vessel_flag,
                   a.rpc_no dsp_rpc_no, a.air_type_cd dsp_air_type_cd ,b.air_desc dsp_air_desc,
                   a.no_pass dsp_no_pass
              FROM giis_vessel a,
                   giis_air_type b
             WHERE vessel_flag = 'A'
               AND b.air_type_cd = a.air_type_cd
               AND (UPPER(a.vessel_name) LIKE UPPER(NVL(p_find_text, '%%')) OR
                    UPPER(b.air_desc) LIKE UPPER(NVL(p_find_text, '%%')))
          ORDER BY UPPER(dsp_vessel_name))
        LOOP
            v_vessel.vessel_cd            := i.vessel_cd;
            v_vessel.vessel_name        := i.dsp_vessel_name;
            v_vessel.vessel_flag        := i.dsp_vessel_flag;
            v_vessel.vessel_old_name    := i.dsp_vessel_old_name;
            v_vessel.vessel_rpc_no        := i.dsp_rpc_no;
            v_vessel.vessel_air_type_cd    := i.dsp_air_type_cd;
            v_vessel.vessel_air_desc    := i.dsp_air_desc;
            v_vessel.vessel_no_pass        := i.dsp_no_pass;
      
            PIPE ROW(v_vessel);
        END LOOP;
    END get_aviation_vessel_tg;
    
/**
* Patrick Cruz
* 082.24.2012
* carrier LOV list
**/
   FUNCTION get_vessel_list5(p_find_text IN VARCHAR2)
    RETURN giis_vessel_tab PIPELINED IS
 
 v_vessel giis_vessel_type;

  BEGIN
    FOR i IN (
  SELECT vessel_name,
      DECODE(vessel_flag, 'V', 'Vessel',
                DECODE(vessel_flag, 'I', 'Inland',
             DECODE(vessel_flag, 'A', 'Aircraft', ' '))) vessel_type,
         vessel_flag, vessel_cd, plate_no, motor_no, serial_no
    FROM GIIS_VESSEL
   WHERE (UPPER(vessel_name) LIKE UPPER(NVL(p_find_text, '%%')) OR 
--          UPPER(vessel_type) LIKE UPPER(NVL(p_find_text, '%%')) OR
         --added by Jeff Dojello 02/20/2013
          ('VESSEL' LIKE UPPER(NVL(p_find_text, '%%'))AND VESSEL_FLAG = 'V') OR 
          ('INLAND' LIKE UPPER(NVL(p_find_text, '%%'))AND VESSEL_FLAG = 'I') OR
          ('AIRCRAFT' LIKE UPPER(NVL(p_find_text, '%%'))AND VESSEL_FLAG = 'A') OR
          ---
          UPPER(plate_no) LIKE UPPER(NVL(p_find_text, '%%')) OR
          UPPER(motor_no) LIKE UPPER(NVL(p_find_text, '%%')))
   ORDER BY vessel_name)
    LOOP
        v_vessel.vessel_name  := i.vessel_name;
        v_vessel.vessel_type  := i.vessel_type;
        v_vessel.vessel_flag  := i.vessel_flag;
        v_vessel.vessel_cd     := i.vessel_cd;
        v_vessel.vessel_motor_no := i.motor_no;
        v_vessel.vessel_plate_no := i.plate_no;
        PIPE ROW(v_vessel);
    END LOOP;

    RETURN;
  END get_vessel_list5;
  
  /*
  **  Created by      : Robert Virrey 
  **  Date Created    : 05.16.2012
  **  Reference By    : (GIIMM002 - Enter Quotation Information)
  **  Description     :  retrieves aviation lov      
  */
  FUNCTION get_aviation_lov
     RETURN air_vessel_list_tab PIPELINED
  IS
     v_air_vessel   air_vessel_list_type;
  BEGIN
     FOR i IN (SELECT a.vessel_cd, a.vessel_name, a.rpc_no, a.vessel_flag,
                    b.air_desc
               FROM giis_vessel a, giis_air_type b
              WHERE a.air_type_cd = b.air_type_cd)
     LOOP
        v_air_vessel.vessel_cd := i.vessel_cd;
        v_air_vessel.vessel_name := i.vessel_name;
        v_air_vessel.rpc_no := i.rpc_no;
        v_air_vessel.vessel_flag := i.vessel_flag;
        v_air_vessel.air_desc := i.air_desc;
        PIPE ROW (v_air_vessel);
     END LOOP;
  END get_aviation_lov;
  
  FUNCTION get_aviation_lov2(
      p_find_text       VARCHAR2
    )
     RETURN air_vessel_list_tab PIPELINED
  IS
     v_air_vessel   air_vessel_list_type;
  BEGIN
     FOR i IN (SELECT a.vessel_cd, a.vessel_name, a.rpc_no, a.vessel_flag,
                      b.air_desc
                 FROM giis_vessel a, giis_air_type b
                WHERE a.air_type_cd = b.air_type_cd
                  AND (UPPER(a.vessel_cd) LIKE UPPER(NVL(p_find_text, '%')) OR
                      UPPER(a.vessel_name) LIKE UPPER(NVL(p_find_text, '%')) OR
                      UPPER(NVL(a.rpc_no, '%')) LIKE UPPER(NVL(p_find_text, '%')) OR
                      UPPER(a.vessel_flag) LIKE UPPER(NVL(p_find_text, '%')) OR
                      UPPER(NVL(b.air_desc, '%')) LIKE UPPER(NVL(p_find_text, '%'))))
     LOOP
        v_air_vessel.vessel_cd := i.vessel_cd;
        v_air_vessel.vessel_name := i.vessel_name;
        v_air_vessel.rpc_no := i.rpc_no;
        v_air_vessel.vessel_flag := i.vessel_flag;
        v_air_vessel.air_desc := i.air_desc;
        PIPE ROW (v_air_vessel);
     END LOOP;
  END get_aviation_lov2;
  
  /*
  **  Created by      : Robert Virrey 
  **  Date Created    : 05.17.2012
  **  Reference By    : (GIIMM002 - Enter Quotation Information)
  **  Description     :  retrieves marine_hull lov      
  */
    FUNCTION get_marine_hull_lov
       RETURN marine_hull_tab PIPELINED
    IS
       v_vessel   marine_hull_type;
    BEGIN
       FOR i IN (SELECT a260.vessel_name, a260.vessel_flag, a260.vessel_old_name,
                        a260.vestype_cd, a270.vestype_desc,
                        DECODE (a260.propel_sw,
                                'S', 'SELF-PROPELLED',
                                'NON-PROPELLED'
                               ) propel_sw,
                        a260.hull_type_cd, a690.hull_desc, a260.gross_ton,
                        a260.year_built, a260.vess_class_cd,
                        a700.vess_class_desc, a260.vessel_cd, a260.reg_owner,
                        a260.reg_place, a260.no_crew, a260.net_ton,
                        a260.deadweight, a260.crew_nat, a260.dry_place,
                        a260.dry_date, a260.vessel_length, a260.vessel_breadth,
                        a260.vessel_depth
                   FROM giis_vessel a260,
                        giis_vestype a270,
                        giis_hull_type a690,
                        giis_vess_class a700
                  WHERE vessel_flag = 'V'
                    AND a270.vestype_cd = a260.vestype_cd
                    AND a690.hull_type_cd = a260.hull_type_cd
                    AND a700.vess_class_cd = a260.vess_class_cd
                    AND a260.vessel_cd <> (SELECT param_value_v
                                             FROM giis_parameters
                                            WHERE param_name = 'VESSEL_CD_MULTI'))
       LOOP
          v_vessel.vessel_name := i.vessel_name;
          v_vessel.vessel_flag := i.vessel_flag;
          v_vessel.vessel_old_name := i.vessel_old_name;
          v_vessel.vestype_cd := i.vestype_cd;
          v_vessel.vestype_desc := i.vestype_desc;
          v_vessel.propel_sw := i.propel_sw;
          v_vessel.hull_type_cd := i.hull_type_cd;
          v_vessel.hull_desc := i.hull_desc;
          v_vessel.gross_ton := i.gross_ton;
          v_vessel.year_built := i.year_built;
          v_vessel.vess_class_cd := i.vess_class_cd;
          v_vessel.vess_class_desc := i.vess_class_desc;
          v_vessel.vessel_cd := i.vessel_cd;
          v_vessel.reg_owner := i.reg_owner;
          v_vessel.reg_place := i.reg_place;
          v_vessel.no_crew := i.no_crew;
          v_vessel.net_ton := i.net_ton;
          v_vessel.deadweight := i.deadweight;
          v_vessel.crew_nat := i.crew_nat;
          v_vessel.dry_place := i.dry_place;
          v_vessel.dry_date := i.dry_date;
          v_vessel.vessel_length := i.vessel_length;
          v_vessel.vessel_breadth := i.vessel_breadth;
          v_vessel.vessel_depth := i.vessel_depth;
          PIPE ROW (v_vessel);
       END LOOP;

       RETURN;
    END get_marine_hull_lov;
  
END GIIS_VESSEL_PKG;
/


