CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Wdeductibles_Pkg AS

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 03, 2010
**  Reference By : (GIPIS002 - Policy Deductible)
**  Description  : This retrieves the policy level deductible records of the given par_id.
*/
  FUNCTION get_gipi_wdeductibles_policy (p_par_id     GIPI_WDEDUCTIBLES.par_id%TYPE)  --par_id of the records to be retrieved.
    RETURN gipi_wdeductibles_tab PIPELINED IS

    v_wdeductibles   gipi_wdeductibles_type;

  BEGIN
    FOR i IN (
        SELECT a.par_id,            a.item_no,           a.peril_cd,         a.ded_line_cd,
               a.ded_subline_cd,    a.aggregate_sw,      DECODE(a.ceiling_sw, NULL, 'N', a.ceiling_sw) ceiling_sw,
               b.deductible_title,  a.deductible_rt,     REPLACE(a.ded_deductible_cd, '/', 'slash') ded_deductible_cd,
               a.deductible_amt,    a.deductible_text,   a.min_amt,          a.max_amt,
               a.range_sw,          b.ded_type
          FROM GIPI_WDEDUCTIBLES    a
              ,GIIS_DEDUCTIBLE_DESC b
              ,GIPI_WPOLBAS         c
         WHERE a.par_id             = p_par_id
           AND a.ded_line_cd        = b.line_cd
           AND a.ded_subline_cd     = b.subline_cd
           AND a.ded_deductible_cd  = b.deductible_cd
           AND a.par_id             = c.par_id
           AND a.item_no            = 0
           AND a.peril_cd           = 0
         ORDER BY a.item_no, a.peril_cd, b.deductible_title)
    LOOP
        v_wdeductibles.par_id             := i.par_id;
        v_wdeductibles.item_no            := i.item_no;
        v_wdeductibles.peril_cd           := i.peril_cd;
        v_wdeductibles.ded_line_cd        := i.ded_line_cd;
        v_wdeductibles.ded_subline_cd     := i.ded_subline_cd;
        v_wdeductibles.aggregate_sw       := i.aggregate_sw;
        v_wdeductibles.ceiling_sw         := i.ceiling_sw;
        v_wdeductibles.ded_deductible_cd  := i.ded_deductible_cd;
        v_wdeductibles.deductible_title   := i.deductible_title;
        v_wdeductibles.deductible_rt      := i.deductible_rt;
        v_wdeductibles.deductible_amt     := i.deductible_amt;
        v_wdeductibles.deductible_text    := i.deductible_text;
        v_wdeductibles.min_amt            := i.min_amt;
        v_wdeductibles.max_amt            := i.max_amt;
        v_wdeductibles.range_sw           := i.range_sw;
        v_wdeductibles.ded_type           := i.ded_type;
      PIPE ROW(v_wdeductibles);
    END LOOP;
    RETURN;
  END get_gipi_wdeductibles_policy;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 03, 2010
**  Reference By : (GIPIS169 - Deductible)
**  Description  : This retrieves the item level deductible records of the given par_id.
*/
  FUNCTION get_gipi_wdeductibles_item (p_par_id     GIPI_WDEDUCTIBLES.par_id%TYPE) --par_id of the records to be retrieved.
    RETURN gipi_wdeductibles_tab PIPELINED IS

  v_wdeductibles   gipi_wdeductibles_type;

  BEGIN
    FOR i IN (
        SELECT a.par_id,            a.item_no,           d.item_title,     a.peril_cd,
               a.ded_line_cd,       a.ded_subline_cd,    a.aggregate_sw,   DECODE(a.ceiling_sw, NULL, 'N', a.ceiling_sw) ceiling_sw,
               b.deductible_title,  a.deductible_rt,     a.deductible_amt, REPLACE(a.ded_deductible_cd, '/', 'slash') ded_deductible_cd,
               a.deductible_text,   a.min_amt,           a.max_amt,        a.range_sw, b.ded_type
          FROM GIPI_WDEDUCTIBLES    a
              ,GIIS_DEDUCTIBLE_DESC b
              ,GIPI_WPOLBAS         c
              ,GIPI_WITEM           d
         WHERE a.par_id             = p_par_id
           AND a.ded_line_cd        = b.line_cd
           AND a.ded_subline_cd     = b.subline_cd
           AND a.ded_deductible_cd  = b.deductible_cd
           AND a.par_id             = c.par_id
           AND (c.par_id            = d.par_id
           AND a.item_no            = d.item_no)
           AND a.peril_cd           = 0
         ORDER BY a.item_no, a.peril_cd, b.deductible_title)
    LOOP
        v_wdeductibles.par_id             := i.par_id;
        v_wdeductibles.item_no            := i.item_no;
        v_wdeductibles.item_title         := i.item_title;
        v_wdeductibles.peril_cd           := i.peril_cd;
        v_wdeductibles.ded_line_cd        := i.ded_line_cd;
        v_wdeductibles.ded_subline_cd     := i.ded_subline_cd;
        v_wdeductibles.aggregate_sw       := i.aggregate_sw;
        v_wdeductibles.ceiling_sw         := i.ceiling_sw;
        v_wdeductibles.ded_deductible_cd  := i.ded_deductible_cd;
        v_wdeductibles.deductible_title   := i.deductible_title;
        v_wdeductibles.deductible_rt      := i.deductible_rt;
        v_wdeductibles.deductible_amt     := i.deductible_amt;
        v_wdeductibles.deductible_text    := i.deductible_text;
        v_wdeductibles.min_amt            := i.min_amt;
        v_wdeductibles.max_amt            := i.max_amt;
        v_wdeductibles.range_sw           := i.range_sw;
        v_wdeductibles.ded_type           := i.ded_type;
      PIPE ROW(v_wdeductibles);
    END LOOP;
    RETURN;
  END get_gipi_wdeductibles_item;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 03, 2010
**  Reference By : (GIPIS169 - Deductible)
**  Description  : This retrieves the peril level deductible records of the given par_id.
*/
  FUNCTION get_gipi_wdeductibles_peril (p_par_id     GIPI_WDEDUCTIBLES.par_id%TYPE)  --par_id of the records to be retrieved.
    RETURN gipi_wdeductibles_tab PIPELINED IS

  v_wdeductibles   gipi_wdeductibles_type;

  BEGIN
    FOR i IN (
        SELECT a.par_id,            a.item_no,           --d.item_title, -- andrew - 09.17.2010 - commencted this column
               a.peril_cd,          f.peril_name,
               a.ded_line_cd,       a.ded_subline_cd,    a.aggregate_sw,   DECODE(a.ceiling_sw, NULL, 'N', a.ceiling_sw) ceiling_sw,
               b.deductible_title,  a.deductible_rt,     a.deductible_amt, REPLACE(a.ded_deductible_cd, '/', 'slash') ded_deductible_cd,
               a.deductible_text,   a.min_amt,           a.max_amt,        a.range_sw, b.ded_type
          FROM GIPI_WDEDUCTIBLES    a
              ,GIIS_DEDUCTIBLE_DESC b
              --,GIPI_WPOLBAS         c --andrew - 09.17.2010 - commented this line
              --,GIPI_WITEM           d --andrew - 09.17.2010 - commented this line
              --,GIPI_WITMPERL        e --andrew - 09.17.2010 - commented this line
              ,GIIS_PERIL           f
         WHERE a.par_id             = p_par_id
           AND a.ded_line_cd        = b.line_cd
           AND a.ded_subline_cd     = b.subline_cd
           AND a.ded_deductible_cd  = b.deductible_cd
           --AND a.par_id             = c.par_id    --andrew - 09.17.2010 - commented this line
           --AND (c.par_id            = d.par_id    --andrew - 09.17.2010 - commented this line
           --AND a.item_no            = d.item_no)  --andrew - 09.17.2010 - commented this line
           --AND (a.par_id            = e.par_id    --andrew - 09.17.2010 - commented this line
           --AND a.item_no            = e.item_no   --andrew - 09.17.2010 - commented this line
           --AND a.peril_cd           = e.peril_cd  --andrew - 09.17.2010 - commented this line
           AND a.ded_line_cd        = f.line_cd
           AND a.peril_cd           = f.peril_cd
         ORDER BY a.item_no, a.peril_cd, b.deductible_title)

    LOOP
        v_wdeductibles.par_id            := i.par_id;
        v_wdeductibles.item_no           := i.item_no;
        v_wdeductibles.peril_cd          := i.peril_cd;
        v_wdeductibles.peril_name        := i.peril_name;
        v_wdeductibles.ded_line_cd       := i.ded_line_cd;
        v_wdeductibles.ded_subline_cd    := i.ded_subline_cd;
        v_wdeductibles.aggregate_sw      := i.aggregate_sw;
        v_wdeductibles.ceiling_sw        := i.ceiling_sw;
        v_wdeductibles.ded_deductible_cd := i.ded_deductible_cd;
        v_wdeductibles.deductible_title  := i.deductible_title;
        v_wdeductibles.deductible_rt     := i.deductible_rt;
        v_wdeductibles.deductible_amt    := i.deductible_amt;
        v_wdeductibles.deductible_text   := i.deductible_text;
        v_wdeductibles.min_amt           := i.min_amt;
        v_wdeductibles.max_amt           := i.max_amt;
        v_wdeductibles.range_sw          := i.range_sw;
        v_wdeductibles.ded_type           := i.ded_type;
      PIPE ROW(v_wdeductibles);
    END LOOP;
    RETURN;
  END get_gipi_wdeductibles_peril;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 03, 2010
**  Reference By : (GIPIS002 - Policy Deductible
                    GIPIS169 - Deductible
                    GIPIS169 - Deductible)
**  Description  : This inserts new record and updates record if existing.
                   This is used for all levels of deductible.
*/
  Procedure set_gipi_wdeductibles (p_wdeductible        IN  GIPI_WDEDUCTIBLES%ROWTYPE)
  IS
  BEGIN
      MERGE INTO GIPI_WDEDUCTIBLES
     USING DUAL ON (par_id            = p_wdeductible.par_id
                    AND item_no       = p_wdeductible.item_no
                AND peril_cd          = p_wdeductible.peril_cd
                AND ded_deductible_cd = p_wdeductible.ded_deductible_cd )
       WHEN NOT MATCHED THEN
         INSERT ( par_id,           item_no,          peril_cd,        ded_line_cd,
                  ded_subline_cd,   aggregate_sw,     ceiling_sw,      ded_deductible_cd,
                  deductible_rt,    deductible_amt,   deductible_text, min_amt,
                  max_amt,          range_sw,         create_user)
         VALUES ( p_wdeductible.par_id,         p_wdeductible.item_no,        p_wdeductible.peril_cd,        p_wdeductible.ded_line_cd,
                  p_wdeductible.ded_subline_cd, p_wdeductible.aggregate_sw,   p_wdeductible.ceiling_sw,      p_wdeductible.ded_deductible_cd,
                  p_wdeductible.deductible_rt,  p_wdeductible.deductible_amt, p_wdeductible.deductible_text, p_wdeductible.min_amt,
                  p_wdeductible.max_amt,        p_wdeductible.range_sw,       p_wdeductible.user_id)
       WHEN MATCHED THEN
         UPDATE SET ded_line_cd     = p_wdeductible.ded_line_cd,
                    ded_subline_cd  = p_wdeductible.ded_subline_cd,
                    aggregate_sw    = p_wdeductible.aggregate_sw,
                    ceiling_sw      = p_wdeductible.ceiling_sw,
                    deductible_rt   = p_wdeductible.deductible_rt,
                    deductible_amt  = p_wdeductible.deductible_amt,
                    deductible_text = p_wdeductible.deductible_text,
                    min_amt         = p_wdeductible.min_amt,
                    max_amt         = p_wdeductible.max_amt,
                    range_sw        = p_wdeductible.range_sw,
                    user_id         = p_wdeductible.user_id;

    COMMIT;
  END set_gipi_wdeductibles;


  Procedure del_gipi_wdeductibles (p_par_id    GIPI_WDEDUCTIBLES.par_id%TYPE,
                                   p_item_no   GIPI_WDEDUCTIBLES.item_no%TYPE,
                                   p_peril_cd  GIPI_WDEDUCTIBLES.peril_cd%TYPE) IS
  BEGIN
    DELETE FROM GIPI_WDEDUCTIBLES
     WHERE par_id   = p_par_id
       AND item_no  = p_item_no
       AND peril_cd = p_peril_cd;

    --COMMIT;
  END del_gipi_wdeductibles;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 03, 2010
**  Reference By : (GIPIS002 - Policy Deductible)
**  Description  : This deletes the policy level deductibles of the given par_id.
*/
  Procedure del_gipi_wdeductibles_policy (p_par_id        GIPI_WDEDUCTIBLES.par_id%TYPE)  --par_id of the records to be deleted
  IS
  BEGIN
    DELETE FROM GIPI_WDEDUCTIBLES
     WHERE par_id   = p_par_id
       AND item_no  = 0
       AND peril_cd = 0;

    COMMIT;
  END del_gipi_wdeductibles_policy;

  /*
**  Created by   :  Emman
**  Date Created :  06.02.2010
**  Reference By : GIPIS060
**  Description  : This deletes the policy level deductibles of the given par_id, line_cd, and subline_cd.
*/
  Procedure del_gipi_wdeductibles_policy_2 (p_par_id        GIPI_WDEDUCTIBLES.par_id%TYPE,
                                            p_line_cd          GIPI_WDEDUCTIBLES.ded_line_cd%TYPE,
                                          p_subline_cd          GIPI_WDEDUCTIBLES.ded_subline_cd%TYPE)
  IS
  BEGIN
     DELETE
       FROM GIPI_WDEDUCTIBLES
      WHERE (par_id,ded_deductible_cd)
         IN (SELECT par_id,ded_deductible_cd
               FROM GIPI_WDEDUCTIBLES, GIIS_DEDUCTIBLE_DESC
              WHERE ded_deductible_cd = deductible_cd
                AND ded_line_cd = line_cd
                AND ded_subline_cd = subline_cd
                AND par_id = p_par_id
                AND ded_line_cd = p_line_cd
                AND ded_subline_cd = p_subline_cd
                AND ded_type = 'T')
        AND item_no = 0;

  END del_gipi_wdeductibles_policy_2;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 03, 2010
**  Reference By : (GIPIS169 - Deductible)
**  Description  : This deletes the item level deductibles of the given par_id.
*/
  Procedure del_gipi_wdeductibles_item (p_par_id        GIPI_WDEDUCTIBLES.par_id%TYPE)  --par_id of the records to be deleted
  IS
  BEGIN
    DELETE FROM GIPI_WDEDUCTIBLES
     WHERE par_id   = p_par_id
       AND item_no <> 0
       AND peril_cd = 0;

    COMMIT;
  END del_gipi_wdeductibles_item;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 03, 2010
**  Reference By : (GIPIS169- Deductible)
**  Description  : This deletes the peril level deductibles of the given par_id.
*/
  Procedure del_gipi_wdeductibles_peril (p_par_id        GIPI_WDEDUCTIBLES.par_id%TYPE)  --par_id of the records to be deleted
  IS
  BEGIN
    DELETE FROM GIPI_WDEDUCTIBLES
     WHERE par_id   = p_par_id
       AND item_no  <> 0
       AND peril_cd <> 0;

    COMMIT;
  END del_gipi_wdeductibles_peril;

/*
**  Created by   :  Bryan Joseph G. Abuluyan
**  Date Created :  February 09, 2010
**  Reference By : (GIPIS038 - Copy Peril)
**  Description  : This retrieves the needed data for copying item peril.
*/
  FUNCTION CHECK_GIPI_WDEDUCTIBLES_ITEMS(
                                                  p_par_id              GIPI_WDEDUCTIBLES.par_id%TYPE,
                                                p_line_cd             GIPI_WDEDUCTIBLES.ded_line_cd%TYPE,
                                        p_nbt_subline_cd     GIPI_WDEDUCTIBLES.ded_subline_cd%TYPE)
  RETURN VARCHAR IS
    v_exists           VARCHAR2(1) := 'N';
  BEGIN
    FOR i IN (
        SELECT a.par_id, a.item_no, a.peril_cd
          FROM GIPI_WDEDUCTIBLES a, GIIS_DEDUCTIBLE_DESC b
         WHERE a.ded_deductible_cd       = ded_deductible_cd
           AND a.ded_line_cd           = b.line_cd
           AND a.ded_subline_cd       = b.subline_cd
           AND a.par_id               = p_par_id
           AND a.ded_line_cd           = p_line_cd
           AND a.ded_subline_cd       = p_nbt_subline_cd
           AND b.ded_type                 = 'T'
         ORDER BY 2 DESC, 3 DESC)
      LOOP
        IF i.item_no = 0 OR i.item_no IS NULL THEN
           v_exists     := 'Y';
        END IF;
      END LOOP;
    RETURN v_exists;
  END CHECK_GIPI_WDEDUCTIBLES_ITEMS;

  FUNCTION GET_GIPI_WDEDUCTIBLES_ITEMS2(
                                                  p_par_id              GIPI_WDEDUCTIBLES.par_id%TYPE,
                                                p_line_cd             GIPI_WDEDUCTIBLES.ded_line_cd%TYPE,
                                        p_nbt_subline_cd     GIPI_WDEDUCTIBLES.ded_subline_cd%TYPE)
    RETURN gipi_wdeductibles_tab PIPELINED IS
    v_ded           gipi_wdeductibles_type;
  BEGIN
    FOR i IN (
        SELECT a.par_id, a.item_no, a.peril_cd
          FROM GIPI_WDEDUCTIBLES a, GIIS_DEDUCTIBLE_DESC b
         WHERE a.ded_deductible_cd       = deductible_cd
           AND a.ded_line_cd           = b.line_cd
           AND a.ded_subline_cd       = b.subline_cd
           AND a.par_id               = p_par_id
           AND a.ded_line_cd           = p_line_cd
           AND a.ded_subline_cd       = p_nbt_subline_cd
           AND b.ded_type                 = 'T'
         ORDER BY 2 DESC, 3 DESC)
      LOOP
        v_ded.item_no := i.item_no;
        v_ded.peril_cd := i.peril_cd;
        v_ded.par_id := i.par_id;
        PIPE ROW(v_ded);
      END LOOP;
    RETURN;
  END GET_GIPI_WDEDUCTIBLES_ITEMS2;

  /*
**  Created by   :  Bryan Joseph G. Abuluyan
**  Date Created :  February 12, 2010
**  Reference By : (GIPIS038- Peril information)
**  Description  : This deletes the peril level deductibles of the given par_id.
*/
  Procedure del_gipi_wdeductibles_peril (p_par_id          GIPI_WDEDUCTIBLES.par_id%TYPE,
                                           p_line_cd          GIPI_WDEDUCTIBLES.ded_line_cd%TYPE,
                                         p_nbt_subline_cd GIPI_WDEDUCTIBLES.ded_subline_cd%TYPE)  --par_id of the records to be deleted
  IS
  BEGIN
    DELETE
      FROM GIPI_WDEDUCTIBLES
     WHERE par_id IN(SELECT par_id
                              FROM GIPI_WDEDUCTIBLES, GIIS_DEDUCTIBLE_DESC
                      WHERE ded_deductible_cd = ded_deductible_cd
                        AND ded_line_cd = line_cd
                        AND ded_subline_cd = subline_cd
                        AND par_id = p_par_id
                        AND ded_line_cd = p_line_cd
                        AND ded_subline_cd = p_nbt_subline_cd
                        AND ded_type = 'T')
                           AND ded_deductible_cd IN(SELECT deductible_cd
                                                   FROM GIPI_WDEDUCTIBLES, GIIS_DEDUCTIBLE_DESC
                                                  WHERE ded_deductible_cd = ded_deductible_cd
                                                    AND ded_line_cd = line_cd
                                                    AND ded_subline_cd = subline_cd
                                                    AND ded_line_cd = p_line_cd
                                                    AND ded_subline_cd = p_nbt_subline_cd
                                                    AND par_id = p_par_id
                                                    AND ded_type = 'T');

    COMMIT;
  END del_gipi_wdeductibles_peril;

    /*
    **  Created by        : Mark JM
    **  Date Created     : 02.25.2010
    **  Reference By     : (GIPIS010 - Item Information)
    **  Description     : Delete record on GIPI_WDEDUCTIBLES
    **                      based on the parameters (par_id, item_no, line_cd, subline_cd)
    */
    Procedure del_gipi_wdeductibles_item_1 (
        p_par_id        GIPI_WDEDUCTIBLES.par_id%TYPE,
        p_item_no        GIPI_WDEDUCTIBLES.item_no%TYPE,
        p_line_cd        GIPI_WDEDUCTIBLES.ded_line_cd%TYPE,
        p_subline_cd    GIPI_WDEDUCTIBLES.ded_subline_cd%TYPE)
    IS
    BEGIN
        DELETE
          FROM GIPI_WDEDUCTIBLES
         WHERE (par_id,ded_deductible_cd) IN
                    (SELECT par_id,ded_deductible_cd
                       FROM GIPI_WDEDUCTIBLES, GIIS_DEDUCTIBLE_DESC
                      WHERE ded_deductible_cd = deductible_cd
                        AND ded_line_cd = line_cd
                        AND ded_subline_cd = subline_cd
                        AND par_id = p_par_id
                        AND ded_line_cd = p_line_cd
                        AND ded_subline_cd = p_subline_cd
                        AND ded_type = 'T')
           AND item_no = p_item_no;
        COMMIT;
    END del_gipi_wdeductibles_item_1;

    /*
    **  Created by        : Mark JM
    **  Date Created     : 02.25.2010
    **  Reference By     : (GIPIS010 - Item Information)
    **  Description     : Contains delete procedure on GIPI_WITEM based on par_id, and item_no
    */
    Procedure del_gipi_wdeductibles_item_2 (p_par_id    GIPI_WDEDUCTIBLES.par_id%TYPE,
        p_item_no    GIPI_WDEDUCTIBLES.item_no%TYPE)
    IS
    BEGIN
        DELETE FROM GIPI_WDEDUCTIBLES
         WHERE par_id = p_par_id
           AND item_no = p_item_no;
    END del_gipi_wdeductibles_item_2;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  May 17, 2010
**  Reference By : (GIPIS097 - Endorsement Item Peril Information)
**  Description  : Returns the deductible level if existing.
*/
  FUNCTION get_deductible_level(p_par_id          GIPI_WDEDUCTIBLES.par_id%TYPE,
                                     p_line_cd         GIPI_WDEDUCTIBLES.ded_line_cd%TYPE,
                                p_subline_cd     GIPI_WDEDUCTIBLES.ded_subline_cd%TYPE,
                                p_item_no       GIPI_WDEDUCTIBLES.item_no%TYPE,
                                p_peril_cd      GIPI_WDEDUCTIBLES.peril_cd%TYPE)
  RETURN NUMBER IS
    --1 = Policy Level
    --2 = Item Level
    --3 = Peril Level
    v_result     NUMBER(1) := 0;
  BEGIN
    FOR a IN (
        SELECT a.par_id, a.item_no, a.peril_cd
          FROM GIPI_WDEDUCTIBLES a, GIIS_DEDUCTIBLE_DESC b
         WHERE a.ded_deductible_cd       = b.deductible_cd
           AND a.ded_line_cd           = b.line_cd
           AND a.ded_subline_cd       = b.subline_cd
           AND a.par_id               = p_par_id
           AND a.ded_line_cd           = p_line_cd
           AND a.ded_subline_cd       = p_subline_cd
           AND b.ded_type                 = 'T'
         ORDER BY 2 DESC, 3 DESC)
    LOOP
      IF a.item_no > 0 AND a.peril_cd > 0 AND a.item_no = p_item_no AND a.peril_cd = p_peril_cd THEN
        v_result := 3;
      ELSIF a.item_no > 0 AND a.peril_cd = 0 AND a.item_no = p_item_no AND a.peril_cd IS NOT NULL THEN
        v_result := 2;
      ELSIF a.item_no = 0 OR a.item_no IS NULL THEN
        v_result := 1;
      END IF;
    END LOOP;

    RETURN v_result;
  END get_deductible_level;

    /*
    **  Created by        : Mark JM
    **  Date Created     : 06.01.2010
    **  Reference By     : (GIPIS031 - Endt Basic Information)
    **  Description     : This procedure deletes record based on the given par_id
    */
    Procedure DEL_GIPI_WDEDUCTIBLES (p_par_id IN GIPI_WDEDUCTIBLES.par_id%TYPE)
    IS
    BEGIN
        DELETE FROM GIPI_WDEDUCTIBLES
         WHERE par_id = p_par_id;
    END DEL_GIPI_WDEDUCTIBLES;

    /*
    **  Created by        : Emman
    **  Date Created     : 06.21.2010
    **  Reference By     : (GIPIS060 - Endt Item Information)
    **  Description     : Deletes existing deductible.
    */
    Procedure del_gipi_wdeductibles_2(
                                     p_par_id              GIPI_WDEDUCTIBLES.par_id%TYPE,
                                        p_line_cd             GIPI_WDEDUCTIBLES.ded_line_cd%TYPE,
                                   p_subline_cd     GIPI_WDEDUCTIBLES.ded_subline_cd%TYPE)
    IS
    BEGIN
         DELETE
            FROM GIPI_WDEDUCTIBLES
            WHERE par_id IN(SELECT par_id
                               FROM GIPI_WDEDUCTIBLES, GIIS_DEDUCTIBLE_DESC
                               WHERE ded_deductible_cd = deductible_cd
                              AND ded_line_cd = line_cd
                              AND ded_subline_cd = subline_cd
                              AND par_id = p_par_id
                              AND ded_line_cd = p_line_cd
                              AND ded_subline_cd = p_subline_cd
                              AND ded_type = 'T')
            AND ded_deductible_cd IN(SELECT deductible_cd
                               FROM GIPI_WDEDUCTIBLES, GIIS_DEDUCTIBLE_DESC
                              WHERE ded_deductible_cd = deductible_cd
                              AND ded_line_cd = line_cd
                              AND ded_subline_cd = subline_cd
                              AND ded_line_cd = p_line_cd
                              AND ded_subline_cd = p_subline_cd
                                AND par_id = p_par_id
                                AND ded_type = 'T');
    END del_gipi_wdeductibles_2;

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  July 1, 2010
**  Reference By : (GIPIS097 - Endorsement Item Peril Information)
**  Description  : Procedure to delete deductibles of the given par_id, item_no and peril_cd
*/
  Procedure del_gipi_wdeductible_peril(p_par_id   GIPI_WDEDUCTIBLES.par_id%TYPE,
                                       p_item_no  GIPI_WDEDUCTIBLES.item_no%TYPE,
                                       p_peril_cd GIPI_WDEDUCTIBLES.peril_cd%TYPE)
  IS
  BEGIN
    DELETE FROM GIPI_WDEDUCTIBLES
     WHERE par_id   = p_par_id
       AND item_no  = p_item_no
       AND peril_cd = p_peril_cd;

  END del_gipi_wdeductible_peril;


    /*
    **  Created by        : Mark JM
    **  Date Created     : 08.06.2010
    **  Reference By     : (GIPIS031 - Endt Basic Information)
    **  Description     : This procedure deletes record based on the given parameters
    */
    Procedure del_gipi_wdeductible (
        p_par_id    IN GIPI_WDEDUCTIBLES.par_id%TYPE,
        p_item_no    IN GIPI_WDEDUCTIBLES.item_no%TYPE,
        p_ded_cd    IN GIPI_WDEDUCTIBLES.ded_deductible_cd%TYPE)
    IS
    BEGIN
        DELETE FROM GIPI_WDEDUCTIBLES
         WHERE par_id = p_par_id
           AND item_no = p_item_no
           AND ded_deductible_cd = p_ded_cd;
    END del_gipi_wdeductible;

/*
**  Created by        : Menandro G.C. Robes
**  Date Created     : September 20, 2010
**  Reference By     : (GIPIS002 - Policy Deductibles,
**                     GIPIS169 - Deductibles)
**  Description     : This procedure deletes specific deductible
*/
  PROCEDURE del_gipi_wdeductible2 (p_par_id          GIPI_WDEDUCTIBLES.par_id%TYPE,
                                   p_item_no         GIPI_WDEDUCTIBLES.item_no%TYPE,
                                   p_peril_cd        GIPI_WDEDUCTIBLES.peril_cd%TYPE,
                                   p_deductible_cd   GIPI_WDEDUCTIBLES.ded_deductible_cd%TYPE,
                                   p_line_cd         GIPI_WDEDUCTIBLES.ded_line_cd%TYPE,
                                   p_subline_cd      GIPI_WDEDUCTIBLES.ded_subline_cd%TYPE)
  IS
  BEGIN
    DELETE FROM gipi_wdeductibles
     WHERE par_id            = p_par_id
       AND item_no           = p_item_no
       AND peril_cd          = p_peril_cd
       AND ded_deductible_cd = p_deductible_cd
       AND ded_line_cd       = p_line_cd
       AND ded_subline_cd    = p_subline_cd;

  END del_gipi_wdeductible2;

    /*
    **  Created by        : Mark JM
    **  Date Created     : 03.21.2011
    **  Reference By     : (GIPIS095 - Package Policy Items)
    **  Description     : Retrieve records from gipi_wdeductible based on the given parameters
    */
    FUNCTION get_gipi_wdeductibles_pack_pol (
        p_par_id IN gipi_wdeductibles.par_id%TYPE,
        p_item_no IN gipi_wdeductibles.item_no%TYPE)
    RETURN gipi_wdeductibles_tab PIPELINED
    IS
        v_wdeductibles   gipi_wdeductibles_type;
    BEGIN
        FOR i IN (
            SELECT par_id, item_no
              FROM gipi_wdeductibles
             WHERE par_id = p_par_id
               AND item_no = p_item_no)
        LOOP
            v_wdeductibles.par_id     := i.par_id;
            v_wdeductibles.item_no    := i.item_no;

            PIPE ROW(v_wdeductibles);
        END LOOP;

        RETURN;
    END get_gipi_wdeductibles_pack_pol;

    /*
    **  Created by        : Mark JM
    **  Date Created    : 08.22.2011
    **  Reference By    : (Basic Information Module)
    **  Description     : Retrieve records from gipi_wdeductible based on the given parameters
    */
    FUNCTION get_gipi_wdeductibles_policy1 (
        p_par_id IN gipi_wdeductibles.par_id%TYPE,
        p_ded_title IN VARCHAR2,
        p_ded_text IN VARCHAR2)
    RETURN gipi_wdeductibles_tab PIPELINED
    IS
        v_wdeductibles   gipi_wdeductibles_type;
    BEGIN
        FOR i IN (
            SELECT a.par_id,            a.item_no,           a.peril_cd,         a.ded_line_cd,
                   a.ded_subline_cd,    a.aggregate_sw,      DECODE(a.ceiling_sw, NULL, 'N', a.ceiling_sw) ceiling_sw,
                   b.deductible_title,  a.deductible_rt,     REPLACE(a.ded_deductible_cd, '/', 'slash') ded_deductible_cd,
                   a.deductible_amt,    a.deductible_text,   a.min_amt,          a.max_amt,
                   a.range_sw,          b.ded_type
              FROM GIPI_WDEDUCTIBLES    a
                  ,GIIS_DEDUCTIBLE_DESC b
                  ,GIPI_WPOLBAS         c
             WHERE a.par_id             = p_par_id
               AND a.ded_line_cd        = b.line_cd
               AND a.ded_subline_cd     = b.subline_cd
               AND a.ded_deductible_cd  = b.deductible_cd
               AND a.par_id             = c.par_id
               AND a.item_no            = 0
               AND a.peril_cd           = 0
               AND UPPER(b.deductible_title) LIKE NVL(UPPER(p_ded_title), '%%')
               AND UPPER(a.deductible_text) LIKE NVL(UPPER(p_ded_text), '%%')
             ORDER BY a.item_no, a.peril_cd, b.deductible_title)
        LOOP
            v_wdeductibles.par_id             := i.par_id;
            v_wdeductibles.item_no            := i.item_no;
            v_wdeductibles.peril_cd           := i.peril_cd;
            v_wdeductibles.ded_line_cd        := i.ded_line_cd;
            v_wdeductibles.ded_subline_cd     := i.ded_subline_cd;
            v_wdeductibles.aggregate_sw       := i.aggregate_sw;
            v_wdeductibles.ceiling_sw         := i.ceiling_sw;
            v_wdeductibles.ded_deductible_cd  := i.ded_deductible_cd;
            v_wdeductibles.deductible_title   := i.deductible_title;
            v_wdeductibles.deductible_rt      := i.deductible_rt;
            v_wdeductibles.deductible_amt     := i.deductible_amt;
            v_wdeductibles.deductible_text    := i.deductible_text;
            v_wdeductibles.min_amt            := i.min_amt;
            v_wdeductibles.max_amt            := i.max_amt;
            v_wdeductibles.range_sw           := i.range_sw;
            v_wdeductibles.ded_type           := i.ded_type;
            PIPE ROW(v_wdeductibles);
        END LOOP;
        RETURN;
    END get_gipi_wdeductibles_policy1;

    /*
    **  Created by        : Mark JM
    **  Date Created    : 07.27.2011
    **  Reference By    : (Item Information Module)
    **  Description     : Retrieve records from gipi_wdeductible based on the given parameters
    */
    FUNCTION get_gipi_wdeductibles_item1 (
        p_par_id IN gipi_wdeductibles.par_id%TYPE,
        p_item_no IN gipi_wdeductibles.item_no%TYPE,
        p_ded_title IN VARCHAR2,
        p_ded_text IN VARCHAR2)
    RETURN gipi_wdeductibles_tab PIPELINED
    IS
        v_wdeductibles gipi_wdeductibles_type;
    BEGIN
        FOR i IN (
            SELECT a.par_id,            a.item_no,           d.item_title,     a.peril_cd,
                   a.ded_line_cd,       a.ded_subline_cd,    a.aggregate_sw,   DECODE(a.ceiling_sw, NULL, 'N', a.ceiling_sw) ceiling_sw,
                   b.deductible_title,  a.deductible_rt,     a.deductible_amt, REPLACE(a.ded_deductible_cd, '/', 'slash') ded_deductible_cd,
                   a.deductible_text,   a.min_amt,           a.max_amt,        a.range_sw, b.ded_type
              FROM GIPI_WDEDUCTIBLES    a
                  ,GIIS_DEDUCTIBLE_DESC b
                  ,GIPI_WPOLBAS         c
                  ,GIPI_WITEM           d
             WHERE a.par_id             = p_par_id
               AND a.ded_line_cd        = b.line_cd
               AND a.ded_subline_cd     = b.subline_cd
               AND a.ded_deductible_cd  = b.deductible_cd
               AND a.par_id             = c.par_id
               AND (c.par_id            = d.par_id
               AND a.item_no            = d.item_no)
               AND a.item_no            = p_item_no
               AND a.peril_cd           = 0
               AND UPPER(b.deductible_title) LIKE NVL(UPPER(p_ded_title), '%%')
               AND UPPER(a.deductible_text) LIKE NVL(UPPER(p_ded_text), '%%')
          ORDER BY a.item_no, a.peril_cd, b.deductible_title)
        LOOP
            v_wdeductibles.par_id             := i.par_id;
            v_wdeductibles.item_no            := i.item_no;
            v_wdeductibles.item_title         := i.item_title;
            v_wdeductibles.peril_cd           := i.peril_cd;
            v_wdeductibles.ded_line_cd        := i.ded_line_cd;
            v_wdeductibles.ded_subline_cd     := i.ded_subline_cd;
            v_wdeductibles.aggregate_sw       := i.aggregate_sw;
            v_wdeductibles.ceiling_sw         := i.ceiling_sw;
            v_wdeductibles.ded_deductible_cd  := i.ded_deductible_cd;
            v_wdeductibles.deductible_title   := i.deductible_title;
            v_wdeductibles.deductible_rt      := i.deductible_rt;
            v_wdeductibles.deductible_amt     := i.deductible_amt;
            v_wdeductibles.deductible_text    := i.deductible_text;
            v_wdeductibles.min_amt            := i.min_amt;
            v_wdeductibles.max_amt            := i.max_amt;
            v_wdeductibles.range_sw           := i.range_sw;
            v_wdeductibles.ded_type           := i.ded_type;
            PIPE ROW(v_wdeductibles);
        END LOOP;
        RETURN;
    END get_gipi_wdeductibles_item1;

    /*
    **  Created by        : Mark JM
    **  Date Created    : 08.05.2011
    **  Reference By    : (Item Information Module)
    **  Description     : Retrieve records from gipi_wdeductible based on the given parameters (item_no and peril_cd based)
    */
    FUNCTION get_gipi_wdeductibles_peril (
        p_par_id IN gipi_wdeductibles.par_id%TYPE,
        p_item_no IN gipi_wdeductibles.item_no%TYPE,
        p_peril_cd IN gipi_wdeductibles.peril_cd%TYPE,
        p_ded_title IN VARCHAR2,
        p_ded_text IN VARCHAR2)
    RETURN gipi_wdeductibles_tab PIPELINED
    IS
        v_wdeductibles gipi_wdeductibles_type;
    BEGIN
        FOR i IN (
            SELECT a.par_id,            a.item_no,           d.item_title,     a.peril_cd,
                   a.ded_line_cd,       a.ded_subline_cd,    a.aggregate_sw,   DECODE(a.ceiling_sw, NULL, 'N', a.ceiling_sw) ceiling_sw,
                   b.deductible_title,  a.deductible_rt,     a.deductible_amt, REPLACE(a.ded_deductible_cd, '/', 'slash') ded_deductible_cd,
                   a.deductible_text,   a.min_amt,           a.max_amt,        a.range_sw, b.ded_type
              FROM GIPI_WDEDUCTIBLES    a
                  ,GIIS_DEDUCTIBLE_DESC b
                  ,GIPI_WPOLBAS         c
                  ,GIPI_WITEM           d
             WHERE a.par_id             = p_par_id
               AND a.ded_line_cd        = b.line_cd
               AND a.ded_subline_cd     = b.subline_cd
               AND a.ded_deductible_cd  = b.deductible_cd
               AND a.par_id             = c.par_id
               AND (c.par_id            = d.par_id
               AND a.item_no            = d.item_no)
               AND a.item_no            = p_item_no
               AND a.peril_cd           = p_peril_cd
               AND UPPER(b.deductible_title) LIKE NVL(UPPER(p_ded_title), '%%')
               AND UPPER(a.deductible_text) LIKE NVL(UPPER(p_ded_text), '%%')
          ORDER BY a.item_no, a.peril_cd, b.deductible_title)
        LOOP
            v_wdeductibles.par_id             := i.par_id;
            v_wdeductibles.item_no            := i.item_no;
            v_wdeductibles.item_title         := i.item_title;
            v_wdeductibles.peril_cd           := i.peril_cd;
            v_wdeductibles.ded_line_cd        := i.ded_line_cd;
            v_wdeductibles.ded_subline_cd     := i.ded_subline_cd;
            v_wdeductibles.aggregate_sw       := i.aggregate_sw;
            v_wdeductibles.ceiling_sw         := i.ceiling_sw;
            v_wdeductibles.ded_deductible_cd  := i.ded_deductible_cd;
            v_wdeductibles.deductible_title   := i.deductible_title;
            v_wdeductibles.deductible_rt      := i.deductible_rt;
            v_wdeductibles.deductible_amt     := i.deductible_amt;
            v_wdeductibles.deductible_text    := i.deductible_text;
            v_wdeductibles.min_amt            := i.min_amt;
            v_wdeductibles.max_amt            := i.max_amt;
            v_wdeductibles.range_sw           := i.range_sw;
            v_wdeductibles.ded_type           := i.ded_type;
            PIPE ROW(v_wdeductibles);
        END LOOP;
        RETURN;
    END get_gipi_wdeductibles_peril;

    /*    Date        Author                  Description
    **    ==========    ====================    ===================
    **    08.08.2010  mark jm                 Retrieve all records from gipi_wdeductible
    **    09.28.2010  mark jm                 modified sql stmt to remove cartesian join
    */
    FUNCTION get_all_gipi_wdeductibles (
        p_par_id IN gipi_wdeductibles.par_id%TYPE)
    RETURN gipi_wdeductibles_tab PIPELINED
    IS
        v_wdeductibles gipi_wdeductibles_type;
    BEGIN
        FOR i IN (
            SELECT a.par_id,            a.item_no,           c.item_title,     a.peril_cd,
                   a.ded_line_cd,       a.ded_subline_cd,    a.aggregate_sw,   DECODE(a.ceiling_sw, NULL, 'N', a.ceiling_sw) ceiling_sw,
                   b.deductible_title,  a.deductible_rt,     a.deductible_amt, REPLACE(a.ded_deductible_cd, '/', 'slash') ded_deductible_cd,
                   a.deductible_text,   a.min_amt,           a.max_amt,        a.range_sw, b.ded_type
              FROM GIPI_WDEDUCTIBLES    a
                  ,GIIS_DEDUCTIBLE_DESC b
                  ,GIPI_WITEM           c
             WHERE a.par_id             = p_par_id
               AND a.ded_line_cd        = b.line_cd
               AND a.ded_subline_cd     = b.subline_cd
               AND a.ded_deductible_cd  = b.deductible_cd
               AND a.par_id             = c.par_id(+)
               AND a.item_no            = c.item_no(+)
            ORDER BY a.item_no, a.peril_cd, b.deductible_title)
        LOOP
            v_wdeductibles.par_id             := i.par_id;
            v_wdeductibles.item_no            := i.item_no;
            v_wdeductibles.item_title         := i.item_title;
            v_wdeductibles.peril_cd           := i.peril_cd;
            v_wdeductibles.ded_line_cd        := i.ded_line_cd;
            v_wdeductibles.ded_subline_cd     := i.ded_subline_cd;
            v_wdeductibles.aggregate_sw       := i.aggregate_sw;
            v_wdeductibles.ceiling_sw         := i.ceiling_sw;
            v_wdeductibles.ded_deductible_cd  := i.ded_deductible_cd;
            v_wdeductibles.deductible_title   := i.deductible_title;
            v_wdeductibles.deductible_rt      := i.deductible_rt;
            v_wdeductibles.deductible_amt     := i.deductible_amt;
            v_wdeductibles.deductible_text    := i.deductible_text;
            v_wdeductibles.min_amt            := i.min_amt;
            v_wdeductibles.max_amt            := i.max_amt;
            v_wdeductibles.range_sw           := i.range_sw;
            v_wdeductibles.ded_type           := i.ded_type;
            PIPE ROW(v_wdeductibles);
        END LOOP;
        RETURN;
    END get_all_gipi_wdeductibles;
END GIPI_WDEDUCTIBLES_PKG;
/


