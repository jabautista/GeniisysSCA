CREATE OR REPLACE PACKAGE BODY CPI.Giis_Peril_Pkg AS

/********************************** FUNCTION 1 ************************************/

  FUNCTION get_peril_list (p_line_cd   GIIS_LINE.line_cd%TYPE)
    RETURN peril_list_tab PIPELINED  IS

    v_peril      peril_list_type;

  BEGIN
    FOR i IN (
      SELECT peril_cd, peril_name, peril_type, default_rate, default_tsi
        FROM GIIS_PERIL
       WHERE line_cd = p_line_cd)
    LOOP
       v_peril.peril_cd     := i.peril_cd;
       v_peril.peril_name   := i.peril_name;
       v_peril.peril_type   := i.peril_type || '%' || i.default_rate || '%' || i.default_tsi;
       v_peril.default_rate := i.default_rate;
       v_peril.default_tsi  := i.default_tsi;
      PIPE ROW (v_peril);
    END LOOP;

    RETURN;
  END get_peril_list;


/********************************** FUNCTION 2 ************************************
  MODULE: GIPIS012
  RECORD GROUP NAME: CGFK$CV001_DSP_PERIL_NAME
***********************************************************************************/

  FUNCTION get_peril_name_list (p_line_cd        GIIS_PERIL.line_cd%TYPE,
                                     p_subline_cd  GIIS_SUBLINE.subline_cd%TYPE)
  RETURN peril_name_list_tab PIPELINED  IS

    v_peril      peril_name_list_type;

  BEGIN
    FOR i IN (
        SELECT a.peril_name, a.peril_sname, a.peril_type, a.ri_comm_rt, a.basc_perl_cd,
               b.peril_sname basic_peril, a.intm_comm_rt, a.prt_flag, a.line_cd, a.peril_cd
          FROM GIIS_PERIL a, GIIS_PERIL b
         WHERE a.line_cd = p_line_cd
           AND (a.subline_cd IS NULL OR a.subline_cd = p_subline_cd)
           AND (b.peril_cd (+)= a.basc_perl_cd)
           AND (b.line_cd (+)= a.line_cd)
         ORDER BY a.peril_name)
    LOOP
          v_peril.peril_name      := i.peril_name;
        v_peril.peril_sname      := i.peril_sname;
        v_peril.peril_type       := i.peril_type;
        v_peril.ri_comm_rt         := i.ri_comm_rt;
        v_peril.basc_perl_cd     := i.basc_perl_cd;
        v_peril.basic_peril      := i.basic_peril;
        v_peril.intm_comm_rt     := i.intm_comm_rt;
        v_peril.prt_flag         := i.prt_flag;
        v_peril.line_cd            := i.line_cd;
        v_peril.peril_cd         := i.peril_cd;
      PIPE ROW(v_peril);
    END LOOP;

    RETURN;
  END get_peril_name_list;

/********************************** FUNCTION ************************************
  MODULE: GIPIS012
  RECORD GROUP NAME:
  DESCRIPTION: to check if Peril has an attached warranties and clauses
***********************************************************************************/

  FUNCTION get_peril_name_list2 (p_par_id       GIPI_PARLIST.par_id%TYPE,
                                      p_line_cd     GIIS_PERIL.line_cd%TYPE,
                                      p_subline_cd  GIIS_SUBLINE.subline_cd%TYPE)
    RETURN peril_name_list_tab PIPELINED  IS

    v_peril      peril_name_list_type;

  BEGIN
    FOR i IN (
        SELECT a.peril_name, a.peril_sname, a.peril_type, a.ri_comm_rt, a.basc_perl_cd,
               b.peril_sname basic_peril, a.intm_comm_rt, a.prt_flag, a.line_cd, a.peril_cd
          FROM GIIS_PERIL a, GIIS_PERIL b
         WHERE a.line_cd = p_line_cd
           AND (a.subline_cd IS NULL OR a.subline_cd = p_subline_cd)
           AND (b.peril_cd (+)= a.basc_perl_cd)
           AND (b.line_cd (+)= a.line_cd)
         ORDER BY a.peril_name)
    LOOP
          v_peril.peril_name      := i.peril_name;
        v_peril.peril_sname      := i.peril_sname;
        v_peril.peril_type       := i.peril_type;
        v_peril.ri_comm_rt         := i.ri_comm_rt;
        v_peril.basc_perl_cd     := i.basc_perl_cd;
        v_peril.basic_peril      := i.basic_peril;
        v_peril.intm_comm_rt     := i.intm_comm_rt;
        v_peril.prt_flag         := i.prt_flag;
        v_peril.line_cd            := i.line_cd;
        v_peril.peril_cd         := i.peril_cd;

        FOR A IN (SELECT '1'
               FROM giis_peril_clauses a
              WHERE a.line_cd  = p_line_cd
                AND a.peril_cd = i.peril_cd
                AND NOT EXISTS (SELECT '1'
                                  FROM gipi_wpolwc b
                                 WHERE par_id = p_par_id
                                   AND b.line_cd = a.line_cd
                                   AND b.wc_cd   = a.main_wc_cd))
        LOOP
          v_peril.wc_sw := 'Y';
          EXIT;
        END LOOP;

      PIPE ROW(v_peril);
    END LOOP;

    RETURN;
  END get_peril_name_list2;

/********************************** FUNCTION 3 ************************************
  MODULE: GIPIS012
  RECORD GROUP NAME: CGFK$CV001_DSP_PERIL_NAME2
***********************************************************************************/

  FUNCTION get_basic_peril_list (p_line_cd        GIIS_PERIL.line_cd%TYPE,
                                       p_subline_cd  GIIS_SUBLINE.subline_cd%TYPE)
  RETURN peril_name_list_tab PIPELINED  IS

    v_peril      peril_name_list_type;

  BEGIN
    FOR i IN (
        SELECT a.peril_name, a.peril_sname, a.peril_type, a.ri_comm_rt, a.basc_perl_cd,
               b.peril_sname basic_peril, a.intm_comm_rt, a.prt_flag, a.line_cd, a.peril_cd
          FROM GIIS_PERIL a, GIIS_PERIL b
         WHERE a.line_cd = p_line_cd
           AND (a.subline_cd IS NULL OR a.subline_cd = p_subline_cd)
           AND a.peril_type = 'B'
           AND (b.peril_cd (+)= a.basc_perl_cd)
           AND (b.line_cd (+)= a.line_cd)
         ORDER BY a.peril_name)
    LOOP
          v_peril.peril_name      := i.peril_name;
        v_peril.peril_sname     := i.peril_sname;
        v_peril.peril_type       := i.peril_type;
        v_peril.ri_comm_rt         := i.ri_comm_rt;
        v_peril.basc_perl_cd     := i.basc_perl_cd;
        v_peril.basic_peril      := i.basic_peril;
        v_peril.intm_comm_rt     := i.intm_comm_rt;
        v_peril.prt_flag         := i.prt_flag;
        v_peril.line_cd            := i.line_cd;
        v_peril.peril_cd         := i.peril_cd;
      PIPE ROW (v_peril);
    END LOOP;

    RETURN;
  END get_basic_peril_list;


/********************************** FUNCTION 4 ************************************
  MODULE: GIPIS012
  RECORD GROUP NAME: PACK_BEN_CD
***********************************************************************************/

  FUNCTION get_grouped_peril_list (p_line_cd              GIIS_LINE.line_cd%TYPE,
                                        p_item_no              GIPI_WITMPERL_GROUPED.item_no%TYPE,
                                   p_par_id                GIPI_WITMPERL_GROUPED.par_id%TYPE,
                                   p_grouped_item_no    GIPI_WITMPERL_GROUPED.grouped_item_no%TYPE)
    RETURN peril_list_tab PIPELINED IS

    v_peril      peril_list_type;

  BEGIN
    FOR i IN (
        SELECT peril_name, peril_cd
          FROM GIIS_PERIL
         WHERE line_cd = p_line_cd
           AND peril_cd NOT IN (SELECT a.peril_cd
                                          FROM GIIS_PERIL a, GIPI_WITMPERL_GROUPED b
                                 WHERE a.peril_cd = b.peril_cd
                                   AND b.item_no = p_item_no
                                     AND b.par_id = p_par_id
                                     AND a.line_cd = b.line_cd
                                     AND b.grouped_item_no = p_grouped_item_no))
    LOOP
          v_peril.peril_name      := i.peril_name;
        v_peril.peril_cd        := i.peril_cd;
      PIPE ROW(v_peril);
    END LOOP;

    RETURN;
  END get_grouped_peril_list;

/********************************** FUNCTION 5 ************************************/

  FUNCTION get_item_peril_list (p_par_id    GIPI_WITMPERL.par_id%TYPE,
                                     p_line_cd      GIPI_WITMPERL.line_cd%TYPE,
                                   p_item_no      GIPI_WITMPERL.item_no%TYPE)
    RETURN peril_list_tab PIPELINED IS

    v_peril      peril_list_type;

  BEGIN
    FOR i IN (
        SELECT DISTINCT b.peril_name, b.peril_cd
          FROM GIPI_WITMPERL a, GIIS_PERIL b
         WHERE a.line_cd = b.line_cd
           AND a.peril_cd = b.peril_cd
             AND a.par_id = p_par_id
           AND a.item_no = p_item_no
             AND a.line_cd = p_line_cd
           AND a.prem_amt > 0
         ORDER BY 1, 2)
    LOOP
          v_peril.peril_name   := i.peril_name;
        v_peril.peril_cd     := i.peril_cd;
      PIPE ROW(v_peril);
    END LOOP;

    RETURN;
  END get_item_peril_list;


/********************************** FUNCTION 6 *************************************
  MODULE: GIPIS038
  RECORD GROUP NAME: CGFK$B490_DSP_PERIL_NAME
***********************************************************************************/

  FUNCTION get_peril_name1_list (p_pack_line_cd        GIIS_PERIL.line_cd%TYPE,
                                      p_line_cd          GIIS_PERIL.line_cd%TYPE,
                                    p_pack_subline_cd     GIIS_PERIL.subline_cd%TYPE,
                                 p_subline_cd         GIIS_PERIL.subline_cd%TYPE,
                                 p_par_id            GIPI_PARLIST.par_id%TYPE)
    RETURN peril_name1_list_tab PIPELINED IS

    v_peril      peril_name1_list_type;
    v_tarf_cd     giis_peril_tariff.TARF_CD%TYPE;
    v_default_rate    giis_peril.default_rate%TYPE;


  BEGIN
    FOR i IN (
        SELECT a.peril_name, a.peril_sname, a.peril_type, a.basc_perl_cd,
               b.peril_sname basic_peril, a.prt_flag, a.line_cd, a.peril_cd,
               a.dflt_tsi, a.ri_comm_rt, a.default_rate, a.default_tag, a.default_tsi
          FROM GIIS_PERIL a, GIIS_PERIL b
         WHERE a.line_cd = NVL(p_pack_line_cd, p_line_cd)
           AND (a.subline_cd IS NULL OR a.subline_cd = NVL(p_pack_subline_cd,p_subline_cd))
             AND (b.peril_cd (+)= a.basc_perl_cd)
             AND (b.line_cd (+)= a.line_cd)
         ORDER BY a.peril_name)
    LOOP
      v_peril.wc_sw                   := 'N';
      FOR A IN (SELECT '1'
                   FROM giis_peril_clauses a
                  WHERE a.line_cd  = i.line_cd
                    AND a.peril_cd = i.peril_cd
                    AND NOT EXISTS (SELECT '1'
                                      FROM gipi_wpolwc b
                                     WHERE par_id = p_par_id
                                       AND b.line_cd = a.line_cd
                                       AND b.wc_cd   = a.main_wc_cd))
       LOOP
         v_peril.wc_sw                   := 'Y';
         EXIT;
       END LOOP;

       --tarf_cd
       BEGIN
         SELECT tarf_cd
           INTO v_peril.tarf_cd
           FROM giis_peril_tariff
          WHERE line_cd = i.line_cd
            AND peril_cd = i.peril_cd
            AND ROWNUM = 1
          ORDER BY tarf_cd;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN NULL;
       END;

       --default tag
       IF (NVL(i.default_tag, 'N') = 'Y') THEN
         v_default_rate := i.default_rate;
       ELSE
         v_default_rate := null;
       END IF;

          v_peril.peril_name      := i.peril_name;
        v_peril.peril_sname      := i.peril_sname;
        v_peril.peril_type       := i.peril_type;
        v_peril.basc_perl_cd     := i.basc_perl_cd;
        v_peril.basic_peril      := i.basic_peril;
        v_peril.prt_flag         := i.prt_flag;
        v_peril.line_cd          := i.line_cd;
        v_peril.peril_cd         := i.peril_cd;
        v_peril.ri_comm_rt       := i.ri_comm_rt;
        v_peril.default_rate     := v_default_rate;
        v_peril.default_tsi      := i.default_tsi;
         PIPE ROW (v_peril);
    END LOOP;

    RETURN;
  END get_peril_name1_list;


/********************************** FUNCTION 7 *************************************
  MODULE: GIPIS038
  RECORD GROUP NAME: ORIG_REC_GRP
***********************************************************************************/

  FUNCTION get_peril_name2_list (p_pack_line_cd        GIIS_PERIL.line_cd%TYPE,
                                      p_line_cd          GIIS_PERIL.line_cd%TYPE,
                                    p_pack_subline_cd     GIIS_PERIL.subline_cd%TYPE,
                                 p_subline_cd         GIIS_PERIL.subline_cd%TYPE,
                                 p_par_id            GIPI_WITMPERL.par_id%TYPE,
                                 p_item_no            GIPI_WITMPERL.item_no%TYPE)
    RETURN peril_name1_list_tab PIPELINED IS

    v_peril      peril_name1_list_type;

  BEGIN
    FOR i IN (
        SELECT a.peril_name, a.peril_sname, a.peril_type, a.basc_perl_cd, b.peril_sname basic_peril, a.prt_flag, a.line_cd, a.peril_cd
          FROM GIIS_PERIL a, GIIS_PERIL b
         WHERE a.line_cd = NVL(p_pack_line_cd,p_line_cd)
           AND (a.subline_cd IS NULL OR a.subline_cd = NVL(p_pack_subline_cd,p_subline_cd))
              AND (b.peril_cd (+)= a.basc_perl_cd)
             AND (b.line_cd (+)= a.line_cd)
             AND a.peril_cd NOT IN (SELECT peril_cd
                                            FROM GIPI_WITMPERL
                                    WHERE par_id = p_par_id
                                      AND item_no = p_item_no)
         ORDER BY a.peril_name)
    LOOP
          v_peril.peril_name      := i.peril_name;
        v_peril.peril_sname      := i.peril_sname;
        v_peril.peril_type       := i.peril_type;
        v_peril.basc_perl_cd     := i.basc_perl_cd;
        v_peril.basic_peril      := i.basic_peril;
        v_peril.prt_flag         := i.prt_flag;
        v_peril.line_cd            := i.line_cd;
        v_peril.peril_cd         := i.peril_cd;
      PIPE ROW (v_peril);
    END LOOP;

    RETURN;
  END get_peril_name2_list;


/********************************** FUNCTION 8 *************************************
  MODULE: GIPIS038
  RECORD GROUP NAME: CGFK$B490_DSP_PERIL_NAME2
***********************************************************************************/

  FUNCTION get_peril_name3_list (p_pack_line_cd        GIIS_PERIL.line_cd%TYPE,
                                      p_line_cd          GIIS_PERIL.line_cd%TYPE,
                                    p_pack_subline_cd     GIIS_PERIL.subline_cd%TYPE,
                                 p_subline_cd         GIIS_PERIL.subline_cd%TYPE)
    RETURN peril_name1_list_tab PIPELINED IS

    v_peril      peril_name1_list_type;

  BEGIN
    FOR i IN (
        SELECT a.peril_name, a.peril_sname, a.peril_type, a.basc_perl_cd, b.peril_sname basic_peril, a.prt_flag, a.line_cd, a.peril_cd
          FROM GIIS_PERIL a, GIIS_PERIL b
         WHERE a.line_cd = NVL(p_pack_line_cd,p_line_cd)
           AND (a.subline_cd IS NULL OR a.subline_cd = NVL(p_pack_subline_cd, p_subline_cd))
             AND a.peril_type = 'B'
             AND (b.peril_cd (+)= a.basc_perl_cd)
           AND (b.line_cd (+)= a.line_cd)
         ORDER BY a.peril_name)
    LOOP
          v_peril.peril_name      := i.peril_name;
        v_peril.peril_sname      := i.peril_sname;
        v_peril.peril_type       := i.peril_type;
        v_peril.basc_perl_cd     := i.basc_perl_cd;
        v_peril.basic_peril      := i.basic_peril;
        v_peril.prt_flag         := i.prt_flag;
        v_peril.line_cd            := i.line_cd;
        v_peril.peril_cd         := i.peril_cd;
      PIPE ROW (v_peril);
    END LOOP;

    RETURN;
  END get_peril_name3_list;


/********************************** FUNCTION 9 *************************************
  MODULE: GIIMM002
  RECORD GROUP NAME: RG_PERIL
***********************************************************************************/

  FUNCTION get_peril_name4_list (p_line_cd          GIIS_PERIL.line_cd%TYPE,
                                 p_subline_cd         GIIS_PERIL.subline_cd%TYPE)
    RETURN peril_name1_list_tab PIPELINED IS

    v_peril      peril_name1_list_type;

  BEGIN
    FOR i IN (
        SELECT peril_name, peril_sname, peril_type, basc_perl_cd,
               prt_flag, line_cd, peril_cd
          FROM GIIS_PERIL
         WHERE line_cd = p_line_cd
           AND subline_cd = p_subline_cd)
    LOOP
          v_peril.peril_name      := i.peril_name;
        v_peril.peril_sname      := i.peril_sname;
        v_peril.peril_type       := i.peril_type;
        v_peril.basc_perl_cd     := i.basc_perl_cd;
        v_peril.prt_flag         := i.prt_flag;
        v_peril.line_cd            := i.line_cd;
        v_peril.peril_cd         := i.peril_cd;
      PIPE ROW (v_peril);
    END LOOP;

    RETURN;
  END get_peril_name4_list;


/********************************** FUNCTION 10 ************************************/

  FUNCTION get_quote_peril_list (p_quote_id  GIPI_QUOTE_ITMPERIL.quote_id%TYPE,
                                 p_item_no   GIPI_QUOTE_ITMPERIL.item_no%TYPE)
    RETURN quote_peril_list_tab PIPELINED IS

    v_peril      quote_peril_list;

  BEGIN
    FOR i IN (
      SELECT a.peril_cd, b.peril_name
        FROM GIPI_QUOTE_ITMPERIL a,
             GIIS_PERIL b
       WHERE a.line_cd  = b.line_cd
         AND a.peril_cd = b.peril_cd
         AND a.quote_id = p_quote_id
         AND a.item_no  = p_item_no)
    LOOP
       v_peril.peril_cd     := i.peril_cd;
       v_peril.peril_name   := i.peril_name;
       PIPE ROW (v_peril);
    END LOOP;

    RETURN;
  END get_quote_peril_list;


/********************************** FUNCTION 11 ************************************
  MODULE: GIPIS012
  RECORD GROUP NAME: CG$DSP_PERIL_CD
***********************************************************************************/

  FUNCTION get_peril_name5_list (p_line_cd        GIIS_PERIL.line_cd%TYPE,
                                      p_subline_cd     GIIS_PERIL.subline_cd%TYPE)
  RETURN peril_name_list_tab PIPELINED  IS

    v_peril      peril_name_list_type;

  BEGIN
    FOR i IN (
        SELECT a.peril_name,   a.peril_sname,             a.peril_type,   a.ri_comm_rt,
                  a.basc_perl_cd, b.peril_sname basic_peril, a.intm_comm_rt, a.prt_flag,
                  a.line_cd,      a.peril_cd
          FROM GIIS_PERIL a
                  ,GIIS_PERIL b
         WHERE a.line_cd              = b.line_cd (+)
           AND a.basc_perl_cd           = b.peril_cd (+)
           AND a.line_cd               = p_line_cd
           AND NVL(a.subline_cd,'-') != p_subline_cd
         ORDER BY a.peril_name)
    LOOP
          v_peril.peril_name      := i.peril_name;
        v_peril.peril_sname      := i.peril_sname;
        v_peril.peril_type       := i.peril_type;
        v_peril.ri_comm_rt         := i.ri_comm_rt;
        v_peril.basc_perl_cd     := i.basc_perl_cd;
        v_peril.basic_peril      := i.basic_peril;
        v_peril.intm_comm_rt     := i.intm_comm_rt;
        v_peril.prt_flag         := i.prt_flag;
        v_peril.line_cd            := i.line_cd;
        v_peril.peril_cd         := i.peril_cd;
      PIPE ROW(v_peril);
    END LOOP;

    RETURN;
  END get_peril_name5_list;

  FUNCTION get_peril_name6_list (p_pack_line_cd        GIIS_PERIL.line_cd%TYPE,
                                      p_line_cd          GIIS_PERIL.line_cd%TYPE,
                                    p_pack_subline_cd     GIIS_PERIL.subline_cd%TYPE,
                                 p_subline_cd         GIIS_PERIL.subline_cd%TYPE)
    RETURN peril_name1_list_tab PIPELINED IS

    v_peril      peril_name1_list_type;

  BEGIN
    FOR i IN (
        SELECT a.peril_name, a.peril_sname, a.peril_type, a.basc_perl_cd,
               b.peril_sname basic_peril, a.prt_flag, a.line_cd, a.peril_cd,
               a.ri_comm_rt
          FROM GIIS_PERIL a, GIIS_PERIL b
         WHERE a.line_cd = NVL(p_pack_line_cd, p_line_cd)
           AND (a.subline_cd IS NULL OR a.subline_cd = NVL(p_pack_subline_cd,p_subline_cd))
             AND (b.peril_cd (+)= a.basc_perl_cd)
             AND (b.line_cd (+)= a.line_cd)
         ORDER BY a.peril_name)
    LOOP
          v_peril.peril_name      := i.peril_name;
        v_peril.peril_sname      := i.peril_sname;
        v_peril.peril_type       := i.peril_type;
        v_peril.basc_perl_cd     := i.basc_perl_cd;
        v_peril.basic_peril      := i.basic_peril;
        v_peril.prt_flag         := i.prt_flag;
        v_peril.line_cd            := i.line_cd;
        v_peril.peril_cd         := i.peril_cd;
        v_peril.ri_comm_rt        := i.ri_comm_rt;
      PIPE ROW (v_peril);
    END LOOP;

    RETURN;
  END get_peril_name6_list;


/********************************** FUNCTION 11 *************************************
  NOTE: Peril Deductible module uses this function - 01/25/2010 - mgcrobes
***********************************************************************************/

  FUNCTION get_witmperl_list (p_par_id        GIPI_WITMPERL.par_id%TYPE,
                                   p_line_cd      GIPI_WITMPERL.line_cd%TYPE)
    RETURN peril_list_tab PIPELINED IS

    v_peril      peril_list_type;

  BEGIN
    FOR i IN (
        SELECT DISTINCT b.peril_name, b.peril_cd, a.item_no
          FROM GIPI_WITMPERL a, GIIS_PERIL b
         WHERE a.line_cd    = b.line_cd
           AND a.peril_cd   = b.peril_cd
             AND a.par_id     = p_par_id
             AND a.line_cd    = p_line_cd
           AND a.prem_amt > 0
         ORDER BY 1, 2)
    LOOP
          v_peril.peril_name   := i.peril_name;
        v_peril.peril_cd     := i.peril_cd;
        v_peril.item_no      := i.item_no;
      PIPE ROW(v_peril);
    END LOOP;

    RETURN;
  END get_witmperl_list;

/********************************** FUNCTION 12 *************************************
  NOTE: Selects the default perils for specific line_cd and subline_cd- 02/25/2010 - bjgabuluyan
***********************************************************************************/
  FUNCTION get_default_perils(p_line_cd            GIIS_PERIL.line_cd%TYPE,
                                   p_pack_line_cd    GIIS_PERIL.line_cd%TYPE,
                              p_nbt_subline_cd    GIIS_PERIL.subline_cd%TYPE,
                              p_pack_subline_cd GIIS_PERIL.subline_cd%TYPE)
    RETURN default_peril_list_tab PIPELINED IS

    v_peril        default_peril_list_type;

  BEGIN
    FOR i IN (SELECT peril_cd,           peril_name,             line_cd,
                     default_tsi,       default_rate,            peril_type,
                     ri_comm_rt
                FROM giis_peril
               WHERE default_tag = 'Y'
                 AND NVL(subline_cd, nvl(p_pack_subline_cd,p_nbt_subline_cd)) = nvl(p_pack_subline_cd,p_nbt_subline_cd)
                 AND line_cd = nvl(p_pack_line_cd,p_line_cd)
               ORDER BY peril_type desc)
    LOOP
      v_peril.peril_cd               := i.peril_cd;
      v_peril.peril_name           := i.peril_name;
      v_peril.line_cd               := i.line_cd;
      v_peril.default_tsi           := i.default_tsi;
      v_peril.default_rate          := i.default_rate;
      v_peril.peril_type            := i.peril_type;
      v_peril.ri_comm_rt            := i.ri_comm_rt;
      PIPE ROW(v_peril);
    END LOOP;
    RETURN;
  END get_default_perils;

  FUNCTION check_default_peril_exists(p_subline_cd     GIIS_PERIL.subline_cd%TYPE,
                                           p_line_cd         GIIS_PERIL.line_cd%TYPE)
    RETURN VARCHAR2 IS
    v_exist            VARCHAR2(1);
  BEGIN
    FOR i IN (SELECT DISTINCT('Y') v_exist
                    FROM giis_peril
               WHERE default_tag = 'Y'
                 AND NVL(subline_cd, p_subline_cd) = p_subline_cd
                 AND line_cd = p_line_cd)
    LOOP
      v_exist          := i.v_exist;
    END LOOP;
    RETURN v_exist;
  END check_default_peril_exists;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  April 27, 2010
**  Reference By : (GIPIS097 - Endorsement Peril Information)
**  Description  : Function to get peril list used in endorsement peril information module.
*/
  FUNCTION get_peril_name7_list(p_line_cd            GIIS_PERIL.line_cd%TYPE,
                                p_subline_cd        GIIS_PERIL.subline_cd%TYPE)
    RETURN peril_name_list_tab PIPELINED IS

    v_peril    peril_name_list_type;

  BEGIN
    FOR i IN (
        SELECT peril.peril_name, peril.peril_sname, peril.peril_type, peril.basc_perl_cd,
               basic_peril.peril_sname basic_peril, peril.prt_flag,   peril.line_cd,
               peril.peril_cd,   peril.dflt_tsi,    peril.default_tag,   peril.default_rate
          FROM giis_peril peril
              ,giis_peril basic_peril
         WHERE peril.line_cd = p_line_cd
           AND (peril.subline_cd IS NULL OR peril.subline_cd = p_subline_cd)
           AND (basic_peril.peril_cd(+) = peril.basc_perl_cd)
           AND (basic_peril.line_cd(+)  = peril.line_cd)
      ORDER BY UPPER(peril_name))
    LOOP
          v_peril.peril_name      := i.peril_name;
        v_peril.peril_sname      := i.peril_sname;
        v_peril.peril_type       := i.peril_type;
        v_peril.basc_perl_cd     := i.basc_perl_cd;
        v_peril.basic_peril      := i.basic_peril;
        v_peril.prt_flag         := i.prt_flag;
        v_peril.line_cd            := i.line_cd;
        v_peril.peril_cd         := i.peril_cd;
        v_peril.dflt_tsi         := i.dflt_tsi;
        v_peril.default_tag        := i.default_tag;
        v_peril.default_rate       := i.default_rate;
      PIPE ROW(v_peril);
    END LOOP;
    RETURN;
  END get_peril_name7_list;

    /*
    **  Created by   :  D.Alcantara
    **  Date Created :  Dec 22, 2010
    **  Reference By : (GIIMM002 - Quotation Information)
    **  Description  : New peril LOV list used in the quotation information page
    */
    FUNCTION get_peril_list2 (p_line_cd  GIIS_LINE.line_cd%TYPE, p_subline_cd GIIS_SUBLINE.subline_cd%TYPE, p_quote_id GIPI_QUOTE.quote_id%TYPE)
    RETURN peril_list_tab PIPELINED
    IS
        v_peril      peril_list_type;
    BEGIN
        FOR i IN (
            SELECT peril_cd, peril_name, peril_type, default_rate, default_tsi
                FROM GIIS_PERIL
            WHERE line_cd = p_line_cd
                  AND (subline_cd IS NULL OR subline_cd = p_subline_cd))
    LOOP
       v_peril.peril_cd     := i.peril_cd;
       v_peril.peril_name   := i.peril_name;
       v_peril.peril_type   := i.peril_type || '%' || i.default_rate || '%' || i.default_tsi;
       v_peril.default_rate := i.default_rate;
       v_peril.default_tsi  := i.default_tsi;
       v_peril.wc_exists    := CHECK_PERIL_WC(i.peril_cd, p_line_cd, p_quote_id);
      PIPE ROW (v_peril);
    END LOOP;

    RETURN;
    END  get_peril_list2;


/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  05.02.2011
**  Reference By : (GIPIS097 - Endorsement Peril Information)
**  Description  : Function to get peril list used in endorsement peril information module.
*/
  FUNCTION get_peril_name8_list(p_line_cd           GIIS_PERIL.line_cd%TYPE,
                                p_subline_cd        GIIS_PERIL.subline_cd%TYPE,
                                p_peril_type        GIIS_PERIL.peril_type%TYPE,
                                p_find_text         VARCHAR2)
    RETURN peril_name_list_tab1 PIPELINED IS

    v_peril    peril_name_list_type1;

  BEGIN
    FOR i IN (
        SELECT peril.peril_name, peril.peril_sname, peril.peril_type, peril.basc_perl_cd,
               basic_peril.peril_sname basic_peril, basic_peril.peril_name basic_peril_name,
               peril.prt_flag,   peril.line_cd,     peril.peril_cd,   peril.dflt_tsi,
               peril.default_tag,   peril.default_rate,  peril.default_tsi
          FROM giis_peril peril
              ,giis_peril basic_peril
         WHERE peril.line_cd = p_line_cd
           AND (peril.subline_cd IS NULL OR peril.subline_cd = p_subline_cd)
           AND (basic_peril.peril_cd(+) = peril.basc_perl_cd)
           AND (basic_peril.line_cd(+)  = peril.line_cd)
           AND peril.peril_type = NVL(p_peril_type, peril.peril_type)
           AND (UPPER(peril.peril_name) LIKE (UPPER(NVL(p_find_text, '%')))
            OR UPPER(peril.peril_sname) LIKE (UPPER(NVL(p_find_text, '%')))
            OR UPPER(peril.peril_type) LIKE (UPPER(NVL(p_find_text, '%')))
            OR UPPER(peril.basc_perl_cd) LIKE (UPPER(NVL(p_find_text, '%')))
            OR UPPER(peril.peril_cd) LIKE (UPPER(NVL(p_find_text, '%')))
            )
      ORDER BY peril_name)
    LOOP
          v_peril.peril_name     := i.peril_name;
        v_peril.peril_sname      := i.peril_sname;
        v_peril.peril_type       := i.peril_type;
        v_peril.basc_perl_cd     := i.basc_perl_cd;
        v_peril.basic_peril      := i.basic_peril;
        v_peril.basic_peril_name := i.basic_peril_name;
        v_peril.prt_flag         := i.prt_flag;
        v_peril.line_cd          := i.line_cd;
        v_peril.peril_cd         := i.peril_cd;
        v_peril.dflt_tsi         := i.dflt_tsi;
        v_peril.default_tag      := i.default_tag;
        v_peril.default_rate     := i.default_rate;
        v_peril.default_tsi      := i.default_tsi;
      PIPE ROW(v_peril);
    END LOOP;
    RETURN;
  END get_peril_name8_list;

    /*
    **  Created by        : Mark JM
    **  Date Created    : 07.27.2011
    **  Reference By    : (GIPIS038 - Item Peril Module)
    **  Description     : Retrieve peril records from giis_peril based on the given parameters and condition
    */
    FUNCTION get_peril_name_by_item_list (
        p_par_id IN gipi_witmperl.par_id%TYPE,
        p_item_no IN gipi_witmperl.item_no%TYPE,
        p_line_cd IN giis_peril.line_cd%TYPE,
        p_subline_cd IN giis_peril.subline_cd%TYPE,
        p_peril_type IN giis_peril.peril_type%TYPE,
        p_find_text IN VARCHAR2)
    RETURN peril_name_list_tab1 PIPELINED
    IS
        v_peril peril_name_list_type1;
        v_tarf_cd giis_peril_tariff.tarf_cd%TYPE;
    BEGIN
        FOR i IN (
            SELECT peril.peril_name, peril.peril_sname, peril.peril_type, peril.basc_perl_cd,
                   basic_peril.peril_sname basic_peril, basic_peril.peril_name basic_peril_name,
                   peril.prt_flag,   peril.line_cd,     peril.peril_cd,   peril.dflt_tsi,
                   peril.default_tag,   peril.default_rate,  peril.default_tsi, peril.ri_comm_rt
              FROM giis_peril peril,
                   giis_peril basic_peril
             WHERE peril.line_cd = p_line_cd
               AND (peril.subline_cd IS NULL OR peril.subline_cd = p_subline_cd)
               AND (basic_peril.peril_cd(+) = peril.basc_perl_cd)
               AND (basic_peril.line_cd(+)  = peril.line_cd)
               /*AND peril.peril_cd NOT IN (SELECT peril_cd
                                            FROM gipi_witmperl
                                           WHERE par_id = p_par_id
                                             AND item_no = p_item_no) */ -- mark jm 12.15.2011 to retrieve all perils
               AND peril.peril_type = NVL(p_peril_type, peril.peril_type)
               AND (UPPER(peril.peril_name) LIKE (UPPER(NVL(p_find_text, '%%'))) OR
                    UPPER(peril.peril_sname) LIKE (UPPER(NVL(p_find_text, '%%')))) -- added by: Nica 06.18.2012
          ORDER BY peril_name)
        LOOP
            v_peril.peril_name             := i.peril_name;
            v_peril.peril_sname          := i.peril_sname;
            v_peril.peril_type           := i.peril_type;
            v_peril.basc_perl_cd         := i.basc_perl_cd;
            v_peril.basic_peril          := i.basic_peril;
            v_peril.basic_peril_name     := i.basic_peril_name;
            v_peril.prt_flag             := i.prt_flag;
            v_peril.line_cd              := i.line_cd;
            v_peril.peril_cd             := i.peril_cd;
            v_peril.dflt_tsi             := i.dflt_tsi;
            v_peril.default_tag          := i.default_tag;
            v_peril.default_rate         := i.default_rate;
            v_peril.default_tsi          := i.default_tsi;
            v_peril.ri_comm_rt            := i.ri_comm_rt;
            v_peril.wc_sw                := 'N';

            FOR A IN (
                SELECT '1'
                  FROM giis_peril_clauses a
                 WHERE a.line_cd  = i.line_cd
                   AND a.peril_cd = i.peril_cd
                   AND NOT EXISTS (SELECT '1'
                                     FROM gipi_wpolwc b
                                    WHERE par_id = p_par_id
                                      AND b.line_cd = a.line_cd
                                      AND b.wc_cd   = a.main_wc_cd))
            LOOP
                v_peril.wc_sw := 'Y';
                EXIT;
            END LOOP;

            --tarf_cd
            BEGIN
                SELECT tarf_cd
                  INTO v_peril.tarf_cd
                  FROM giis_peril_tariff
                 WHERE line_cd = i.line_cd
                   AND peril_cd = i.peril_cd
                   AND ROWNUM = 1
              ORDER BY tarf_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN NULL;
            END;

            PIPE ROW(v_peril);
        END LOOP;
        RETURN;
    END get_peril_name_by_item_list;


    /**
    * Rey Jadlocon
    * 08.04.2011
    * bill premium peril list
    **/
    FUNCTION get_peril_bill_list(p_policy_id    gipi_invoice.policy_id%TYPE,
        p_item_no       gipi_item.item_no%TYPE,
        p_item_grp       gipi_invoice.item_grp%TYPE
    )
      RETURN peril_bill_list_tab PIPELINED
    IS
        v_bill_peril peril_bill_list_type;
    BEGIN
        FOR i IN(SELECT a.peril_name,a.peril_cd,g.prem_amt,g.tsi_amt
                     FROM giis_peril a, gipi_polbasic b,giis_line c, gipi_invperil g, gipi_invoice h, gipi_item i
                  WHERE a.line_cd = c.line_cd
                    AND h.ISS_CD = g.ISS_CD
                    AND h.PREM_SEQ_NO = g.PREM_SEQ_NO
                    AND h.ITEM_GRP = g.ITEM_GRP
                    AND c.line_cd = b.line_cd
                    AND h.policy_id = b.policy_id
                    AND i.policy_id = b.policy_id
                    AND g.peril_cd = a.peril_cd
                    AND b.policy_id = p_policy_id
                    AND g.item_grp = p_item_grp -- marco - 09.06.2012 - to limit query
                    AND i.item_no = p_item_no
                  ORDER BY a.peril_cd ASC)
        LOOP
            v_bill_peril.peril_name     := i.peril_name;
            v_bill_peril.peril_cd       := i.peril_cd;
            v_bill_peril.prem_amt       := i.prem_amt;
            v_bill_peril.tsi_amt        := i.tsi_amt;
            PIPE ROW(v_bill_peril);
        END LOOP
        RETURN;
    END get_peril_bill_list;

    /*    Date        Author            Description
    **    ==========    ===============    ============================
    **    10.06.2011    mark jm            retrieve records for beneficiary perils lov based on given parameters (tablegrid varsion)
    */
    FUNCTION get_beneficiary_peril_list (
        p_line_cd IN giis_peril.line_cd%TYPE,
        p_subline_cd IN giis_peril.line_cd%TYPE,
        p_peril_name IN VARCHAR2)
    RETURN peril_name_list_tab1 PIPELINED
    IS
        v_ben_peril peril_name_list_type1;
    BEGIN
        FOR i IN (
            SELECT a.peril_name peril_name,     a.peril_sname peril_sname ,
                   a.peril_type type,             a.ri_comm_rt ri_comm_rt,
                   a.basc_perl_cd basc_perl_cd,    b.peril_sname basic_peril ,
                   a.intm_comm_rt intm_comm_rt,    a.prt_flag prt_flag ,
                   a.line_cd line_cd ,             a.peril_cd peril_cd
              FROM giis_peril a,
                   giis_peril b
             WHERE a.line_cd = b.line_cd(+)
               AND b.peril_cd(+) = a.basc_perl_cd
               AND a.line_cd = p_line_cd
               AND nvl(a.subline_cd,'-') != p_subline_cd
               AND UPPER(a.peril_name) LIKE UPPER(NVL(p_peril_name, '%%')))
        LOOP
            v_ben_peril.peril_name        := i.peril_name;
            v_ben_peril.peril_sname        := i.peril_sname;
            v_ben_peril.peril_type        := i.type;
            v_ben_peril.ri_comm_rt        := i.ri_comm_rt;
            v_ben_peril.basc_perl_cd    := i.basc_perl_cd;
            v_ben_peril.basic_peril        := i.basic_peril;
            v_ben_peril.intm_comm_rt    := i.intm_comm_rt;
            v_ben_peril.prt_flag        := i.prt_flag;
            v_ben_peril.line_cd            := i.line_cd;
            v_ben_peril.peril_cd        := i.peril_cd;

            PIPE ROW(v_ben_peril);
        END LOOP;

        RETURN;
    END get_beneficiary_peril_list;

    /*    Date        Author            Description
    **    ==========    ===============    ============================
    **    10.06.2011    mark jm            retrieve records for grouped perils lov based on given parameters (tablegrid varsion)
    */
    FUNCTION get_grouped_peril_list1 (
        p_par_id IN gipi_wpolwc.par_id%TYPE,
        p_line_cd IN giis_peril.line_cd%TYPE,
        p_subline_cd IN giis_peril.line_cd%TYPE,
        p_peril_type IN giis_peril.peril_type%TYPE,
        p_peril_name IN VARCHAR2)
    RETURN peril_name_list_tab1 PIPELINED
    IS
        v_grp_peril peril_name_list_type1;
    BEGIN
        FOR i IN (
            SELECT a.peril_name, a.peril_sname, a.peril_type, a.ri_comm_rt, a.basc_perl_cd,
                   b.peril_sname basic_peril, a.intm_comm_rt, a.prt_flag, a.line_cd, a.peril_cd,
                   b.peril_name basic_peril_name
              FROM giis_peril a,
                   giis_peril b
             WHERE a.line_cd = p_line_cd
               AND (a.subline_cd IS NULL OR a.subline_cd = p_subline_cd)
               AND (b.peril_cd (+)= a.basc_perl_cd)
               AND (b.line_cd (+)= a.line_cd)
               AND a.peril_type = NVL(p_peril_type, a.peril_type)
               AND UPPER(a.peril_name) LIKE UPPER(NVL(p_peril_name, '%%'))
          ORDER BY a.peril_name)
        LOOP
            v_grp_peril.peril_name        := i.peril_name;
            v_grp_peril.peril_sname        := i.peril_sname;
            v_grp_peril.peril_type        := i.peril_type;
            v_grp_peril.ri_comm_rt        := i.ri_comm_rt;
            v_grp_peril.basc_perl_cd    := i.basc_perl_cd;
            v_grp_peril.basic_peril        := i.basic_peril;
            v_grp_peril.intm_comm_rt    := i.intm_comm_rt;
            v_grp_peril.prt_flag        := i.prt_flag;
            v_grp_peril.line_cd            := i.line_cd;
            v_grp_peril.peril_cd        := i.peril_cd;
            v_grp_peril.basic_peril_name := i.basic_peril_name;

            FOR A IN (
                SELECT '1'
                  FROM giis_peril_clauses a
                 WHERE a.line_cd  = p_line_cd
                   AND a.peril_cd = i.peril_cd
                   AND NOT EXISTS (SELECT '1'
                                     FROM gipi_wpolwc b
                                    WHERE par_id = p_par_id
                                      AND b.line_cd = a.line_cd
                                      AND b.wc_cd   = a.main_wc_cd))
            LOOP
                v_grp_peril.wc_sw := 'Y';
                EXIT;
            END LOOP;

            PIPE ROW(v_grp_peril);
        END LOOP;

        RETURN;
    END get_grouped_peril_list1;

    /*
    **  Created by      : Robert Virrey
    **  Date Created    : 02.23.2012
    **  Reference By    : (GIEXS007 - Edit Peril Information)
    **  Description     : CGFK$B490_DSP_PERIL_NAME Record Group
    */
    FUNCTION get_peril_name9_list (
        p_line_cd       giis_peril.line_cd%TYPE,
        p_subline_cd    giis_peril.subline_cd%TYPE
    )
    RETURN peril_name_list_tab2 PIPELINED
    IS
        v_peril peril_name_list_type2;
    BEGIN
        FOR i IN (
            SELECT a170.peril_name dsp_peril_name /* cg$fk */ ,a170.peril_sname dsp_peril_sname ,
                   a170.peril_type dsp_peril_type ,a170.basc_perl_cd dsp_basc_perl_cd ,
                   a1701.peril_sname dsp_peril_sname2 ,a170.prt_flag dsp_prt_flag ,
                   a170.line_cd line_cd ,a170.peril_cd peril_cd
              FROM giis_peril a170, giis_peril a1701
             WHERE a170.line_cd = p_line_cd
               AND (a170.subline_cd is null or a170.subline_cd = p_subline_cd)
               AND (a1701.peril_cd (+)= a170.basc_perl_cd)
               AND (a1701.line_cd (+)= a170.line_cd)
             ORDER BY a170.peril_name)
        LOOP
            v_peril.dsp_peril_name          := i.dsp_peril_name;
            v_peril.dsp_peril_sname         := i.dsp_peril_sname;
            v_peril.dsp_peril_type          := i.dsp_peril_type;
            v_peril.dsp_basc_perl_cd        := i.dsp_basc_perl_cd;
            v_peril.dsp_peril_sname2        := i.dsp_peril_sname2;
            v_peril.dsp_prt_flag            := i.dsp_prt_flag;
            v_peril.line_cd                 := i.line_cd;
            v_peril.peril_cd                := i.peril_cd;

            PIPE ROW(v_peril);
        END LOOP;
        RETURN;
    END get_peril_name9_list;

    /*
    **  Created by      : Robert Virrey
    **  Date Created    : 03.15.2012
    **  Reference By    : (GIEXS007 - Edit Peril Information)
    **  Description     : lov_peril
    */
    FUNCTION get_itmperil_list (
      p_policy_id giex_itmperil.policy_id%TYPE, -- added by andrew - 1.11.2012
      p_item_no    giex_itmperil.item_no%TYPE)
    RETURN quote_peril_list_tab PIPELINED
    IS
        v_peril      quote_peril_list;
    BEGIN
        FOR i IN (
                SELECT a.peril_cd, DECODE(a.peril_cd, 0, NULL, b.peril_name) peril_name
                  FROM giex_itmperil a, giis_peril b
                 WHERE b.line_cd = a.line_cd
--                   AND (b.peril_cd = a.peril_cd or a.peril_cd = 0)  -- replaced by andrew - 1.11.2012
--                   AND a.item_no = p_item_no)
                   AND b.peril_cd = a.peril_cd
                   AND a.item_no = p_item_no
                   AND a.policy_Id = p_policy_id)
        LOOP
           v_peril.peril_cd     := i.peril_cd;
           v_peril.peril_name   := i.peril_name;
           PIPE ROW (v_peril);
        END LOOP;

        RETURN;
    END get_itmperil_list;

    FUNCTION get_item_peril_lov(
        p_quote_id              GIPI_QUOTE.quote_id%TYPE,
        p_line_cd               GIIS_PERIL.line_cd%TYPE,
        p_pack_line_cd          GIIS_PERIL.line_cd%TYPE,
        p_subline_cd            GIIS_PERIL.subline_cd%TYPE,
        p_pack_subline_cd       GIIS_PERIL.subline_cd%TYPE,
        p_peril_type            GIIS_PERIL.peril_type%TYPE,
        p_keyword               VARCHAR2
    )
      RETURN item_peril_tab PIPELINED IS
        v_peril                 item_peril_type;
        v_found                 VARCHAR2(1) := 'N';
        v_exists                VARCHAR2(1) := 'N';
    BEGIN
        FOR i IN(SELECT a170.peril_name dsp_peril_name, a170.peril_sname dsp_peril_sname,
                        a170.peril_type dsp_peril_type, a170.basc_perl_cd dsp_basc_perl_cd,
                        a1701.peril_sname dsp_peril_sname2, a170.prt_flag dsp_prt_flag,
                        a170.peril_cd peril_cd,
                        a170.default_tag, a170.default_rate, a170.default_tsi,
                        a1701.peril_name dsp_peril_name2,
                        a170.line_cd
                   FROM GIIS_PERIL a170, GIIS_PERIL a1701
                  WHERE UPPER(a170.line_cd) = UPPER(p_line_cd)
                    AND (a170.subline_cd IS NULL OR UPPER(a170.subline_cd) = UPPER(p_subline_cd))
                    AND (a1701.peril_cd (+)= a170.basc_perl_cd)
                    AND (a1701.line_cd (+)= a170.line_cd)
                    AND UPPER(a170.peril_type) LIKE UPPER(NVL(p_peril_type, a170.peril_type))
                    AND (UPPER(a170.peril_name) LIKE UPPER(NVL(p_keyword, '%')) OR
                         UPPER(a170.peril_sname) LIKE UPPER(NVL(p_keyword, '%')) OR
                         UPPER(a170.peril_type) LIKE UPPER(NVL(p_keyword, '%')) OR
                         UPPER(a1701.peril_sname) LIKE UPPER(NVL(p_keyword, '%'))
                         OR TO_CHAR(a170.peril_cd) LIKE NVL(p_keyword, '%'))
               ORDER BY a170.peril_type DESC, a170.peril_name ASC)
        LOOP
            v_peril.dsp_peril_name          := i.dsp_peril_name;
            v_peril.dsp_peril_sname         := i.dsp_peril_sname;
            v_peril.dsp_peril_type          := i.dsp_peril_type;
            v_peril.dsp_basc_perl_cd        := i.dsp_basc_perl_cd;
            v_peril.dsp_peril_name2         := i.dsp_peril_name2;
            v_peril.dsp_peril_sname2        := i.dsp_peril_sname2;
            v_peril.dsp_prt_flag            := i.dsp_prt_flag;
            v_peril.peril_cd                := i.peril_cd;
            v_peril.default_tag             := NVL(i.default_tag, 'N');
            v_peril.default_rate            := i.default_rate;
            v_peril.default_tsi             := i.default_tsi;
            v_peril.line_cd                 := i.line_cd;

            BEGIN
                SELECT 'Y'
                  INTO v_found
                  FROM GIIS_PERIL a,
                       GIIS_PERIL_CLAUSES b
                 WHERE a.line_cd = b.line_cd
                   AND a.peril_cd = b.peril_cd
                   AND a.line_cd = p_line_cd
                   AND a.peril_cd = i.peril_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_found := 'N';
                WHEN TOO_MANY_ROWS THEN
                    v_found := 'Y';
            END;

            BEGIN
                SELECT 'Y'
                  INTO v_exists
                  FROM GIIS_PERIL a,
                       GIIS_PERIL_CLAUSES b,
                       GIPI_QUOTE_WC c
                 WHERE a.line_cd = b.line_cd
                   AND a.peril_cd = b.peril_cd
                   AND b.main_wc_cd = c.wc_cd
                   AND a.line_cd = p_line_cd
                   AND a.peril_cd = i.peril_cd
                   AND quote_id = p_quote_id;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_exists := 'N';
                WHEN TOO_MANY_ROWS THEN
                    v_exists := 'Y';
            END;

            IF v_found = 'Y' AND v_exists = 'N' THEN
                v_peril.warranty_flag := 'Y';
            ELSE
                v_peril.warranty_flag := 'N';
            END IF;

            PIPE ROW(v_peril);
        END LOOP;
    END;

    FUNCTION get_peril_name_list_gipis005(
        p_line_cd               GIIS_PERIL.line_cd%TYPE,
        p_subline_cd            GIIS_PERIL.subline_cd%TYPE,
        p_peril_type            GIIS_PERIL.peril_type%TYPE,
        p_find_text             VARCHAR2
    )
      RETURN peril_name_list_tab PIPELINED AS
        v_peril                 peril_name_list_type;
    BEGIN
        FOR i IN (SELECT peril.peril_name, peril.peril_sname, peril.peril_type, peril.basc_perl_cd,
                         basic_peril.peril_sname basic_peril, peril.prt_flag,   peril.line_cd,
                         peril.peril_cd,   peril.dflt_tsi,    peril.default_tag,   peril.default_rate,
                         basic_peril.peril_name basic_peril_name
                    FROM giis_peril peril,
                         giis_peril basic_peril
                   WHERE peril.line_cd = p_line_cd
                     AND (peril.subline_cd IS NULL OR peril.subline_cd = p_subline_cd)
                     AND (basic_peril.peril_cd(+) = peril.basc_perl_cd)
                     AND (basic_peril.line_cd(+)  = peril.line_cd)
                     AND UPPER(peril.peril_type) LIKE UPPER(NVL(p_peril_type, peril.peril_type))
                     AND (UPPER(peril.peril_name) LIKE UPPER(NVL(p_find_text, '%')) OR
                         UPPER(peril.peril_sname) LIKE UPPER(NVL(p_find_text, '%')) OR
                         UPPER(peril.peril_type) LIKE UPPER(NVL(p_find_text, '%')))
                   ORDER BY UPPER(peril_name))
        LOOP
            v_peril.peril_name      := i.peril_name;
            v_peril.peril_sname      := i.peril_sname;
            v_peril.peril_type       := i.peril_type;
            v_peril.basc_perl_cd     := i.basc_perl_cd;
            v_peril.basic_peril      := i.basic_peril;
            v_peril.prt_flag         := i.prt_flag;
            v_peril.line_cd            := i.line_cd;
            v_peril.peril_cd         := i.peril_cd;
            v_peril.dflt_tsi         := i.dflt_tsi;
            v_peril.default_tag        := i.default_tag;
            v_peril.default_rate       := i.default_rate;
            v_peril.basic_peril_name := i.basic_peril_name;
            PIPE ROW(v_peril);
        END LOOP;
    END get_peril_name_list_gipis005;

    FUNCTION get_grouped_peril_list2 (
        p_par_id IN gipi_wpolwc.par_id%TYPE,
        p_line_cd IN giis_peril.line_cd%TYPE,
        p_subline_cd IN giis_peril.line_cd%TYPE,
        p_peril_type IN giis_peril.peril_type%TYPE,
        p_peril_name IN VARCHAR2)
    RETURN peril_name_list_tab1 PIPELINED
    IS
        v_grp_peril peril_name_list_type1;
    BEGIN
        FOR i IN (
            SELECT LTRIM(a.peril_name) peril_name, a.peril_sname, a.peril_type, a.ri_comm_rt, a.basc_perl_cd,
                   b.peril_sname basic_peril, a.intm_comm_rt, a.prt_flag, a.line_cd, a.peril_cd,
                   b.peril_name basic_peril_name, a.default_tag, a.default_rate
              FROM giis_peril a,
                   giis_peril b
             WHERE a.line_cd = p_line_cd
               AND (a.subline_cd IS NULL OR a.subline_cd = p_subline_cd)
               AND (b.peril_cd (+)= a.basc_perl_cd)
               AND (b.line_cd (+)= a.line_cd)
               AND a.peril_type = NVL(p_peril_type, a.peril_type)
               AND UPPER(a.peril_name) LIKE UPPER(NVL(p_peril_name, '%%'))
          ORDER BY peril_name)
        LOOP
            v_grp_peril.peril_name        := LTRIM(i.peril_name);
            v_grp_peril.peril_sname        := i.peril_sname;
            v_grp_peril.peril_type        := i.peril_type;
            v_grp_peril.ri_comm_rt        := i.ri_comm_rt;
            v_grp_peril.basc_perl_cd    := i.basc_perl_cd;
            v_grp_peril.basic_peril        := i.basic_peril;
            v_grp_peril.intm_comm_rt    := i.intm_comm_rt;
            v_grp_peril.prt_flag        := i.prt_flag;
            v_grp_peril.line_cd            := i.line_cd;
            v_grp_peril.peril_cd        := i.peril_cd;
            v_grp_peril.basic_peril_name := i.basic_peril_name;
            v_grp_peril.default_tag := NVL(i.default_tag, 'N');
            v_grp_peril.default_rate := i.default_rate;

            v_grp_peril.wc_sw := 'N';
            FOR A IN (
                SELECT '1'
                  FROM giis_peril_clauses a
                 WHERE a.line_cd  = p_line_cd
                   AND a.peril_cd = i.peril_cd
                   AND NOT EXISTS (SELECT '1'
                                     FROM gipi_wpolwc b
                                    WHERE par_id = p_par_id
                                      AND b.line_cd = a.line_cd
                                      AND b.wc_cd   = a.main_wc_cd))
            LOOP
                v_grp_peril.wc_sw := 'Y';
                EXIT;
            END LOOP;

            PIPE ROW(v_grp_peril);
        END LOOP;
    END;

    /*Created by : Gzelle
    **Date : 09092014
    **Description : Retrieve Package Plan peril details
    **Reference : When-New-Form-Instance trigger
    */
    FUNCTION get_pack_plan_perils(
        p_par_id gipi_wpolbas.par_id%TYPE
    )
        RETURN pack_plan_tab PIPELINED
    IS
        v_rec   pack_plan_type;
    BEGIN
        FOR a IN(SELECT  b.par_id, /*item_no*/ a.line_cd, a.peril_cd, c.peril_name,
                         c.peril_type,                                            /*tarf_cd,*/
                                      NVL (a.prem_rt, 0) prem_rt, NVL (a.tsi_amt, 0) tsi_amt,
                         NVL (a.prem_amt, 0) prem_amt, NVL (a.tsi_amt, 0) ann_tsi_amt, /*ann_prem_amt, rec_flag, compRem, */
                         b.discount_sw, c.prt_flag, c.ri_comm_rt, /*ri_comm_amt, as_charge_sw, */ b.surcharge_sw,
                         NVL (a.no_of_days, 0) no_of_days, NVL (a.base_amt, 0) base_amt,
                         a.aggregate_sw, c.basc_perl_cd
                    FROM giis_plan_dtl a, gipi_wpolbas b, giis_peril c
                   WHERE a.plan_cd = b.plan_cd
                     AND a.peril_cd = c.peril_cd
                     AND a.line_cd = c.line_cd
                     AND b.par_id = p_par_id
                ORDER BY c.peril_type DESC)
        LOOP
            v_rec.par_id        := a.par_id;
            v_rec.line_cd       := a.line_cd;
            v_rec.peril_cd      := a.peril_cd;
            v_rec.peril_name    := a.peril_name;
            v_rec.peril_type    := a.peril_type;
            v_rec.prem_rt       := a.prem_rt;
            v_rec.tsi_amt       := a.tsi_amt;
            v_rec.prem_amt      := a.prem_amt;
            v_rec.ann_tsi_amt     := a.ann_tsi_amt;
            v_rec.discount_sw     := a.discount_sw;
            v_rec.prt_flag         := a.prt_flag;
            v_rec.ri_comm_rt     := a.ri_comm_rt;
            v_rec.no_of_days     := a.no_of_days;
            v_rec.base_amt      := a.base_amt;
            v_rec.aggregate_sw     := a.aggregate_sw;
            v_rec.basc_perl_cd     := a.basc_perl_cd;
            v_rec.record_status := 0;
            v_rec.tarf_cd         := NULL;
            v_rec.rec_flag         := NULL;
            v_rec.comp_rem         := NULL;
            v_rec.as_charge_sw     := NULL;

            PIPE ROW(v_rec);
        END LOOP;
    END;

    /*Created by : Gzelle
    **Date : 11242014
    **Description : Retrieve default tsi and premium amts
    **Reference : BP-001-00002 Creating a MOTORCAR policy BR-010A
    */
    FUNCTION get_default_peril_amts(
        p_par_id            gipi_wpolbas.par_id%TYPE,
        p_line_cd           giis_tariff_rates_hdr.line_cd%TYPE,
        p_subline_cd        giis_tariff_rates_hdr.subline_cd%TYPE,
        p_peril_cd          giis_tariff_rates_hdr.peril_cd%TYPE,
        p_tsi_amt           giis_tariff_rates_dtl.fixed_si%TYPE,
        p_coverage_cd       giis_tariff_rates_hdr.coverage_cd%TYPE,
        p_subline_type_cd   giis_tariff_rates_hdr.subline_type_cd%TYPE,
        p_motortype_cd      giis_tariff_rates_hdr.motortype_cd%TYPE,
        p_tariff_zone       giis_tariff_rates_hdr.tariff_zone%TYPE,
        p_tarf_cd           giis_tariff_rates_hdr.tarf_cd%TYPE,
        p_construction_cd   giis_tariff_rates_hdr.construction_cd%TYPE
    )
        RETURN VARCHAR2
    IS
        v_amts    VARCHAR2(526);

      TYPE v_type IS RECORD (
         tariff_cd          giis_tariff_rates_dtl.tariff_cd%TYPE,
         default_prem_tag   giis_tariff_rates_hdr.default_prem_tag%TYPE
      );

      TYPE v_tab IS TABLE OF v_type;

      v_list_bulk           v_tab;

      v_query               VARCHAR2(30000);
      v_menu_line_cd        giis_line.line_cd%TYPE;
      v_tsi_amt             gipi_witmperl.tsi_amt%TYPE  := 0;
      v_prem_amt            gipi_witmperl.prem_amt%TYPE := 0;
      v_prem_rt             NUMBER(16,9)  := 0;
      v_prorate_flag        gipi_wpolbas.prorate_flag%TYPE;
      v_short_rt_percent    gipi_wpolbas.short_rt_percent%TYPE;
      v_no_of_days          NUMBER;
      v_chk_coverage        VARCHAR2(8) := 'O';
      v_chk_construction    VARCHAR2(8) := 'O';

   BEGIN
       BEGIN
          SELECT menu_line_cd
            INTO v_menu_line_cd
            FROM giis_line
           WHERE line_cd = p_line_cd;
       EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
             v_menu_line_cd := NULL;
          WHEN TOO_MANY_ROWS
          THEN
             v_menu_line_cd := NULL;
       END;

       BEGIN
          SELECT 'X'
            INTO v_chk_coverage
            FROM giis_tariff_rates_hdr
           WHERE line_cd = p_line_cd
             AND subline_cd = p_subline_cd
             AND peril_cd = p_peril_cd
             AND coverage_cd = p_coverage_cd
             AND ROWNUM = 1;
       EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
             v_chk_coverage := 'O';
          WHEN TOO_MANY_ROWS
          THEN
             v_chk_coverage := 'X';
       END;

       IF v_chk_coverage = 'X'
       THEN
           v_query :=
                 'SELECT tariff_cd, default_prem_tag
                      FROM giis_tariff_rates_hdr a
                     WHERE a.line_cd = '''
              || p_line_cd
              || '''
                       AND a.subline_cd = '''
              || p_subline_cd
              || '''
                       AND a.peril_cd = '
              || p_peril_cd
              || '
                       AND a.coverage_cd = '
              || p_coverage_cd;
       ELSE
           v_query :=
                 'SELECT tariff_cd, default_prem_tag
                      FROM giis_tariff_rates_hdr a
                     WHERE a.line_cd = '''
              || p_line_cd
              || '''
                       AND a.subline_cd = '''
              || p_subline_cd
              || '''
                       AND a.peril_cd = '
              || p_peril_cd
              || '
                       AND a.coverage_cd IS NULL';
       END IF;

       IF p_line_cd = 'MC' OR v_menu_line_cd = 'MC'
       THEN
          v_query :=
                v_query
             ||' AND a.subline_type_cd = '''
             || p_subline_type_cd
             || ''' AND a.motortype_cd = '
             || NVL(TO_CHAR(p_motortype_cd),'NULL');
       ELSIF p_line_cd = 'FI' OR v_menu_line_cd = 'FI'
       THEN
           IF v_chk_coverage = 'X'
           THEN
               BEGIN
                  SELECT 'X'
                    INTO v_chk_construction
                    FROM giis_tariff_rates_hdr
                   WHERE line_cd = p_line_cd
                     AND subline_cd = p_subline_cd
                     AND peril_cd = p_peril_cd
                     AND tariff_zone = p_tariff_zone
                     AND tarf_cd = p_tarf_cd
                     AND construction_cd = p_construction_cd
                     AND coverage_cd = p_coverage_cd
                     AND ROWNUM = 1;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_chk_construction := 'O';
                  WHEN TOO_MANY_ROWS
                  THEN
                     v_chk_construction := 'X';
               END;
           ELSE
               BEGIN
                  SELECT 'X'
                    INTO v_chk_construction
                    FROM giis_tariff_rates_hdr
                   WHERE line_cd = p_line_cd
                     AND subline_cd = p_subline_cd
                     AND peril_cd = p_peril_cd
                     AND tariff_zone = p_tariff_zone
                     AND tarf_cd = p_tarf_cd
                     AND construction_cd = p_construction_cd
                     AND coverage_cd IS NULL
                     AND ROWNUM = 1;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_chk_construction := 'O';
                  WHEN TOO_MANY_ROWS
                  THEN
                     v_chk_construction := 'X';
               END;
           END IF;

           IF v_chk_construction = 'X'
           THEN
              v_query :=
                    v_query
                 ||' AND a.tariff_zone = '''
                 || p_tariff_zone
                 || ''' AND a.tarf_cd = '''
                 || p_tarf_cd
                 || ''' AND a.construction_cd = '''
                 || p_construction_cd
                 || '''';
           ELSE
              v_query :=
                    v_query
                 ||' AND a.tariff_zone = '''
                 || p_tariff_zone
                 || ''' AND a.tarf_cd = '''
                 || p_tarf_cd
                 || ''' AND a.construction_cd IS NULL';
           END IF;
       END IF;

      EXECUTE IMMEDIATE v_query

      BULK COLLECT INTO v_list_bulk;

      IF v_list_bulk.LAST > 0
      THEN
         FOR i IN v_list_bulk.FIRST .. v_list_bulk.LAST
         LOOP
            BEGIN
               IF v_list_bulk (i).default_prem_tag = '1' --Fixed Sum Insured
                  THEN
                    FOR x IN (SELECT fixed_si, fixed_premium, si_deductible, excess_rate, higher_range, lower_range, additional_premium, tariff_rate, loading_rate, discount_rate
                           FROM giis_tariff_rates_dtl b
                          WHERE b.tariff_cd = v_list_bulk (i).tariff_cd
                            AND (b.fixed_si = p_tsi_amt
                             OR  (p_tsi_amt BETWEEN lower_range AND higher_range)
                                ))
                    LOOP
                        IF x.higher_range IS NULL AND x.lower_range IS NULL --Fixed Sum Insured (w/o higher and lower range)
                        THEN
                            v_tsi_amt  := p_tsi_amt;
                            v_prem_amt := x.fixed_premium;
                        ELSE                                                --Fixed Sum Insured (w/ higher and lower range)
                            v_prem_amt := x.fixed_premium;
                            v_tsi_amt  := x.fixed_si;
                        END IF;
                    END LOOP;
               ELSIF v_list_bulk (i).default_prem_tag = '3' --Fixed Premium
               THEN
                    FOR y IN (SELECT fixed_si, fixed_premium
                           FROM giis_tariff_rates_dtl b
                          WHERE b.tariff_cd = v_list_bulk (i).tariff_cd)
                    LOOP
                        v_tsi_amt  := p_tsi_amt;
                        v_prem_amt := y.fixed_premium;
                    END LOOP;
               ELSIF v_list_bulk (i).default_prem_tag = '2' --With Computation
               THEN
                    FOR z IN (SELECT fixed_si, fixed_premium, si_deductible, excess_rate, higher_range, lower_range, additional_premium, tariff_rate, loading_rate, discount_rate
                           FROM giis_tariff_rates_dtl b
                          WHERE b.tariff_cd = v_list_bulk (i).tariff_cd)
                    LOOP
                        v_tsi_amt  := p_tsi_amt;
                        v_prem_amt := ( (NVL(z.fixed_premium,0) + ((p_tsi_amt - NVL(z.si_deductible,0)) * (NVL(z.excess_rate,0)/100))) +
                                             ((NVL(z.fixed_premium,0) + ((p_tsi_amt - NVL(z.si_deductible,0)) * (NVL(z.excess_rate,0)/100))) * (NVL(z.loading_rate,0)/100))) -
                                           ( ( (NVL(z.fixed_premium,0) + ((p_tsi_amt - NVL(z.si_deductible,0)) * (NVL(z.excess_rate,0)/100))) +
                                             ((NVL(z.fixed_premium,0) + ((p_tsi_amt - NVL(z.si_deductible,0)) * (NVL(z.excess_rate,0)/100))) * (NVL(z.loading_rate,0)/100))) * (NVL(z.discount_rate,0)/100)) +
                                           NVL(z.additional_premium,0);
                    END LOOP;
               END IF;
            END;
         END LOOP;
         v_amts := v_tsi_amt || '_*_' || v_prem_amt;

          BEGIN
            SELECT prorate_flag, short_rt_percent, (TRUNC (expiry_date) - TRUNC (eff_date)) no_of_days
              INTO v_prorate_flag, v_short_rt_percent, v_no_of_days
              FROM gipi_wpolbas
             WHERE par_id = p_par_id;
          EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                v_prorate_flag     := NULL;
                v_short_rt_percent := NULL;
            WHEN TOO_MANY_ROWS
            THEN
                v_prorate_flag     := NULL;
                v_short_rt_percent := NULL;
          END;

          IF v_prem_amt <> 0
          THEN
              IF v_prem_amt <= v_tsi_amt
              THEN
                  IF v_prorate_flag = '1'       --prorated
                  THEN
                     v_prem_rt  := ((v_prem_amt*365)/(v_tsi_amt*v_no_of_days))*100;
                  ELSIF v_prorate_flag ='2'     --straight
                  THEN
                     v_prem_rt := ((v_prem_amt)/(v_tsi_amt))*100;
                  ELSIF v_prorate_flag = '3'    --short rate
                  THEN
                     v_prem_rt := ((v_prem_amt)/(v_tsi_amt*(v_short_rt_percent/100)))*100;
                  END IF;

                  IF v_prem_rt > 100
                  THEN
                      raise_application_error (-20001,
                                                'Geniisys Exception#E#Tariff setup will cause peril rate to be greater than 100%.
                                                Please contact your system administrator.'
                                              );
                  END IF;
              ELSE
                  raise_application_error (-20001,
                                            'Geniisys Exception#E#TSI amount must not be less than the maintained Premium amount.
                                            Please refer to Default Peril Rate Maintenance.'
                                          );
              END IF;
              v_amts := v_tsi_amt || '_*_' || v_prem_amt || '_*_' || v_prem_rt;
          END IF;
      END IF;
            RETURN  v_amts;
   EXCEPTION
   WHEN VALUE_ERROR
   THEN
      raise_application_error (-20001,
                                'Geniisys Exception#E#Tariff setup will cause peril rate to be greater than 100%.
                                Please contact your system administrator.'
                              );
   END;

    /*Created by : Gzelle
    **Date : 12012014
    **Description : Check if perils based on tariff exists
    **Reference : BP-001-00002 Creating a MOTORCAR policy BR-010A
    */
    FUNCTION check_tariff_peril_exists(
        p_par_id            gipi_wpolbas.par_id%TYPE,
        p_item_no           gipi_witem.item_no%TYPE,
        p_line_cd           giis_tariff_rates_hdr.line_cd%TYPE,
        p_subline_cd        giis_tariff_rates_hdr.subline_cd%TYPE
    )
        RETURN VARCHAR2
    IS
        v_exists            VARCHAR2(1000);
        v_menu_line_cd      giis_line.line_cd%TYPE;

    BEGIN
        BEGIN
            SELECT menu_line_cd
              INTO v_menu_line_cd
              FROM giis_line
             WHERE line_cd = p_line_cd;
        EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
             v_menu_line_cd := NULL;
          WHEN TOO_MANY_ROWS
          THEN
             v_menu_line_cd := NULL;
        END;

        IF p_line_cd = 'FI' OR v_menu_line_cd = 'FI'
        THEN
            FOR x IN (SELECT a.coverage_cd, b.peril_cd, a.item_no
                        FROM gipi_witmperl b, gipi_witem a
                        WHERE a.par_id = b.par_id
                        AND a.par_id = p_par_id
                        AND a.item_no = b.item_no
                        AND a.item_no = NVL(DECODE(p_item_no, 0, null, p_item_no),a.item_no))
            LOOP
                FOR y IN (SELECT tariff_zone, tarf_cd, construction_cd
                              FROM gipi_wfireitm
                             WHERE par_id = p_par_id
                               AND item_no = NVL(DECODE(p_item_no, 0, null, p_item_no),x.item_no))
                LOOP
                    FOR z IN (SELECT 'X' exist
                              FROM giis_tariff_rates_hdr
                             WHERE line_cd = NVL(v_menu_line_cd,p_line_cd)
                               AND subline_cd = p_subline_cd
                               AND peril_cd = x.peril_cd
                               AND coverage_cd = x.coverage_cd
                               AND tariff_zone = y.tariff_zone
                               AND tarf_cd = y.tarf_cd
                               AND construction_cd = y.construction_cd)
                    LOOP
                        v_exists := z.exist;
                    END LOOP;
                END LOOP;
            END LOOP;
        ELSIF p_line_cd = 'MC' OR v_menu_line_cd = 'MC'
        THEN
            FOR x IN (SELECT a.coverage_cd, b.peril_cd, a.item_no
                        FROM gipi_witmperl b, gipi_witem a
                        WHERE a.par_id = b.par_id
                        AND a.par_id = p_par_id
                        AND a.item_no = b.item_no
                        AND a.item_no = NVL(DECODE(p_item_no, 0, null, p_item_no),a.item_no))
            LOOP
                FOR y IN (SELECT subline_type_cd, mot_type
                              FROM gipi_wvehicle
                             WHERE par_id = p_par_id
                               AND item_no = NVL(DECODE(p_item_no, 0, null, p_item_no),x.item_no))
                LOOP
                    FOR z IN (SELECT 'X' exist
                              FROM giis_tariff_rates_hdr
                             WHERE line_cd = NVL(v_menu_line_cd,p_line_cd)
                               AND subline_cd = p_subline_cd
                               AND peril_cd = x.peril_cd
                               AND coverage_cd = x.coverage_cd
                               AND subline_type_cd = y.subline_type_cd
                               AND motortype_cd = y.mot_type)
                    LOOP
                        v_exists := z.exist;
                    END LOOP;
                END LOOP;
            END LOOP;
        ELSE
            FOR x IN (SELECT a.coverage_cd, b.peril_cd, a.item_no
                        FROM gipi_witmperl b, gipi_witem a
                        WHERE a.par_id = b.par_id
                        AND a.par_id = p_par_id
                        AND a.item_no = b.item_no
                        AND a.item_no = NVL(DECODE(p_item_no, 0, null, p_item_no),a.item_no))
            LOOP
                FOR z IN (SELECT 'X' exist
                          FROM giis_tariff_rates_hdr
                         WHERE line_cd = NVL(v_menu_line_cd,p_line_cd)
                           AND subline_cd = p_subline_cd
                           AND peril_cd = x.peril_cd
                           AND coverage_cd = x.coverage_cd)
                LOOP
                    v_exists := z.exist;
                END LOOP;
            END LOOP;
        END IF;

        v_exists := v_exists;

       RETURN v_exists;
    END;


    /*Created by : Gzelle
    **Date : 12022014
    **Description : Delete peril information for modified item info
    **Reference : BP-001-00002 Creating a MOTORCAR policy BR-010A
    */
   PROCEDURE del_gipi_witmperl_tariff (
      p_par_id     IN   gipi_witmperl.par_id%TYPE,
      p_item_no    IN   gipi_witmperl.item_no%TYPE,
      p_line_cd    IN   gipi_witmperl.line_cd%TYPE,
      p_subline_cd IN   giis_tariff_rates_hdr.subline_cd%TYPE
   )
   IS
      v_par_type gipi_parlist.par_type%TYPE;
      v_peril_cd gipi_witmperl.peril_cd%TYPE;
   BEGIN
      IF p_line_cd = 'FI'
      THEN
        FOR x IN (SELECT a.coverage_cd, b.peril_cd, a.item_no
                    FROM gipi_witmperl b, gipi_witem a
                    WHERE a.par_id = b.par_id
                    AND a.par_id = p_par_id
                    AND a.item_no = b.item_no
                    AND a.item_no = NVL(DECODE(p_item_no, 0, null, p_item_no),a.item_no))
        LOOP
            FOR y IN (SELECT tariff_zone, tarf_cd, construction_cd
                          FROM gipi_wfireitm
                         WHERE par_id = p_par_id
                           AND item_no = NVL(DECODE(p_item_no, 0, null, p_item_no),x.item_no))
            LOOP
                FOR z IN (SELECT 'X' exist
                          FROM giis_tariff_rates_hdr
                         WHERE line_cd = p_line_cd
                           AND subline_cd = p_subline_cd
                           AND peril_cd = x.peril_cd
                           AND coverage_cd = x.coverage_cd
                           AND tariff_zone = y.tariff_zone
                           AND tarf_cd = y.tarf_cd
                           AND construction_cd = y.construction_cd)
                LOOP
                    FOR i IN (SELECT main_wc_cd
                                FROM giis_peril_clauses
                               WHERE line_cd = p_line_cd
                                 AND peril_cd = x.peril_cd)
                    LOOP
                        DELETE FROM gipi_wpolwc
                         WHERE par_id = p_par_id
                           AND line_cd = p_line_cd
                           AND wc_cd = i.main_wc_cd;
                    END LOOP;

                    DELETE FROM gipi_witmperl
                          WHERE par_id = p_par_id
                            AND item_no = x.item_no
                            AND line_cd = p_line_cd;

                    SELECT par_type
                      INTO v_par_type
                      FROM gipi_parlist
                     WHERE par_id = p_par_id;

                    IF v_par_type <> 'E' THEN
                        gipi_witem_pkg.update_amt_details (p_par_id, x.item_no);
                    END IF;
                END LOOP;
            END LOOP;
        END LOOP;
      END IF;
   END del_gipi_witmperl_tariff;

    /*Created by : Gzelle
    **Date : 05252015
    **Description : Checks if item peril has maintained zone type
    **Reference : BP-001-00001 Creating a FIRE policy BR-010Q BP-001-00002 Endorsement of FIRE policy BR-023N [SR4347]
    */        
    FUNCTION check_peril_zone_type(
        p_par_id    gipi_witmperl.par_id%TYPE,
        p_item_no   gipi_witmperl.item_no%TYPE,
        p_line_cd   giis_peril.line_cd%TYPE,
        p_peril_cd  giis_peril.peril_cd%TYPE
    )
    	RETURN VARCHAR2
    IS
        v_x     VARCHAR2(8) := 'NO';
        v_menu_line_cd giis_line.menu_line_cd%TYPE;
    BEGIN
        BEGIN
            SELECT NVL(menu_line_cd,p_line_cd)
              INTO v_menu_line_cd
              FROM giis_line
             WHERE line_cd = p_line_cd;
        EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
             v_menu_line_cd := NULL;
          WHEN TOO_MANY_ROWS
          THEN
             v_menu_line_cd := NULL;
        END;     
        
        IF NVL(v_menu_line_cd,p_line_cd) = 'FI'
        THEN
        
            IF p_peril_cd IS NOT NULL 
            THEN
                BEGIN
                    SELECT 'YES'
                      INTO v_x
                      FROM giis_peril
                     WHERE line_cd = v_menu_line_cd
                       AND peril_cd = p_peril_cd
                       AND zone_type IS NOT NULL;
                EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_x := 'NO';
                  WHEN TOO_MANY_ROWS
                  THEN
                     v_x := 'NO';
                END;    
            ELSE
                FOR i IN (SELECT peril_cd
                            FROM gipi_witmperl
                           WHERE par_id = p_par_id
                             AND line_cd = p_line_cd
                             AND item_no = p_item_no) 
                LOOP
                    FOR x IN (SELECT 'YES' res
                                FROM giis_peril
                               WHERE line_cd = v_menu_line_cd
                                 AND peril_cd = i.peril_cd
                                 AND zone_type IS NOT NULL)     
                    LOOP
                        v_x := x.res;
                        EXIT;
                    END LOOP;             
                END LOOP;  
            END IF;
        END IF;
        RETURN v_x;   
    END;                

END Giis_Peril_Pkg;
/


