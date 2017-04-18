CREATE OR REPLACE PACKAGE BODY CPI.GIPI_WITMPERL_GROUPED_PKG
AS

    /*
    **  Created by        : Jerome Orio
    **  Date Created     : 05.24.2010
    **  Reference By     : (GIPIS012- Item Information - Accident - Grouped Items - Coverage)
    **  Description     :Get PAR record listing for GIPI_WITMPERL_GROUPED per item no
    */
  FUNCTION get_gipi_witmperl_grouped(p_par_id    GIPI_WITMPERL_GROUPED.par_id%TYPE,
                                          p_item_no     GIPI_WITMPERL_GROUPED.item_no%TYPE)
    RETURN gipi_witmperl_grouped_tab PIPELINED IS
    v_cov    gipi_witmperl_grouped_type;
  BEGIN
    FOR i IN (SELECT a.par_id,         a.item_no,                a.grouped_item_no,
                        a.line_cd,           a.peril_cd,                 a.rec_flag,
                     a.no_of_days,       a.prem_rt,                a.tsi_amt,
                     a.prem_amt,       a.ann_tsi_amt,            a.ann_prem_amt,
                     a.aggregate_sw,   a.base_amt,                a.ri_comm_rate,
                     a.ri_comm_amt,
                        b.grouped_item_title,
                     c.peril_name,        c.peril_type
                  FROM GIPI_WITMPERL_GROUPED a,
                     GIPI_WGROUPED_ITEMS b,
                     GIIS_PERIL c
               WHERE a.par_id = p_par_id
                    AND a.item_no = p_item_no
                 AND a.par_id = b.par_id
                 AND a.item_no = b.item_no
                 AND a.grouped_item_no = b.grouped_item_no
                 AND a.peril_cd = c.peril_cd(+)
                 AND a.line_cd = c.line_cd(+)
                 ORDER BY par_id,item_no,grouped_item_no)
    LOOP
      v_cov.par_id                      := i.par_id;
      v_cov.item_no                 := i.item_no;
      v_cov.grouped_item_no         := i.grouped_item_no;
      v_cov.line_cd                      := i.line_cd;
      v_cov.peril_cd                  := i.peril_cd;
      v_cov.rec_flag                 := i.rec_flag;
      v_cov.no_of_days                := i.no_of_days;
      v_cov.prem_rt                     := i.prem_rt;
      v_cov.tsi_amt                    := i.tsi_amt;
      v_cov.prem_amt                := i.prem_amt;
      v_cov.ann_tsi_amt                  := i.ann_tsi_amt;
      v_cov.ann_prem_amt            := i.ann_prem_amt;
      v_cov.aggregate_sw              := i.aggregate_sw;
      v_cov.base_amt                   := i.base_amt;
      v_cov.ri_comm_rate             := i.ri_comm_rate;
      v_cov.ri_comm_amt                  := i.ri_comm_amt;
      v_cov.peril_name                 := i.peril_name;
      v_cov.grouped_item_title         := i.grouped_item_title;
      v_cov.peril_type                := i.peril_type;

      PIPE ROW(v_cov);
    END LOOP;
    RETURN;
  END;

     /*
    **  Created by        : Jerome Orio
    **  Date Created     : 05.27.2010
    **  Reference By     : (GIPIS012- Item Information - Accident - Grouped Items - Coverage)
    **  Description     : Get PAR record listing for GIPI_WITMPERL_GROUPED per item no
    */
  PROCEDURE set_gipi_witmperl_grouped(
              p_par_id                  GIPI_WITMPERL_GROUPED.par_id%TYPE,
                 p_item_no                   GIPI_WITMPERL_GROUPED.item_no%TYPE,
            p_grouped_item_no          GIPI_WITMPERL_GROUPED.grouped_item_no%TYPE,
            p_line_cd                  GIPI_WITMPERL_GROUPED.line_cd%TYPE,
            p_peril_cd                  GIPI_WITMPERL_GROUPED.peril_cd%TYPE,
            p_rec_flag                  GIPI_WITMPERL_GROUPED.rec_flag%TYPE,
            p_no_of_days              GIPI_WITMPERL_GROUPED.no_of_days%TYPE,
            p_prem_rt                  GIPI_WITMPERL_GROUPED.prem_rt%TYPE,
            p_tsi_amt                  GIPI_WITMPERL_GROUPED.tsi_amt%TYPE,
            p_prem_amt                  GIPI_WITMPERL_GROUPED.prem_amt%TYPE,
            p_ann_tsi_amt              GIPI_WITMPERL_GROUPED.ann_tsi_amt%TYPE,
            p_ann_prem_amt              GIPI_WITMPERL_GROUPED.ann_prem_amt%TYPE,
            p_aggregate_sw              GIPI_WITMPERL_GROUPED.aggregate_sw%TYPE,
            p_base_amt                  GIPI_WITMPERL_GROUPED.base_amt%TYPE,
            p_ri_comm_rate              GIPI_WITMPERL_GROUPED.ri_comm_rate%TYPE,
            p_ri_comm_amt              GIPI_WITMPERL_GROUPED.ri_comm_amt%TYPE
              )
        IS
  BEGIN
       MERGE INTO GIPI_WITMPERL_GROUPED
        USING dual ON (par_id       = p_par_id
                    AND item_no   = p_item_no
                    AND grouped_item_no = p_grouped_item_no
                    AND peril_cd  = p_peril_cd)
        WHEN NOT MATCHED THEN
            INSERT (par_id,                       item_no,                grouped_item_no,
                    line_cd,                peril_cd,                rec_flag,
                       no_of_days,                prem_rt,                tsi_amt,
                    prem_amt,                ann_tsi_amt,            ann_prem_amt,
                    aggregate_sw,            base_amt,                ri_comm_rate,
                    ri_comm_amt
                   )
            VALUES (p_par_id,                   p_item_no,                p_grouped_item_no,
                       p_line_cd,                p_peril_cd,                p_rec_flag,
                    p_no_of_days,            p_prem_rt,                p_tsi_amt,
                    p_prem_amt,                p_ann_tsi_amt,            p_ann_prem_amt,
                    p_aggregate_sw,            p_base_amt,                p_ri_comm_rate,
                    p_ri_comm_amt
                    )
        WHEN MATCHED THEN
            UPDATE SET
                    line_cd             = p_line_cd,
                    rec_flag             = p_rec_flag,
                    no_of_days             = p_no_of_days,
                    prem_rt             = p_prem_rt,
                    tsi_amt             = p_tsi_amt,
                    prem_amt             = p_prem_amt,
                    ann_tsi_amt         = p_ann_tsi_amt,
                    ann_prem_amt         = p_ann_prem_amt,
                    aggregate_sw         = p_aggregate_sw,
                    base_amt             = p_base_amt,
                    ri_comm_rate         = p_ri_comm_rate,
                    ri_comm_amt            = p_ri_comm_amt;
  END;

     /*
    **  Created by        : Jerome Orio
    **  Date Created     : 05.27.2010
    **  Reference By     : (GIPIS012- Item Information - Accident - Grouped Items - Coverage)
    **  Description     : Get PAR record listing for GIPI_WITMPERL_GROUPED per item no
    */
  PROCEDURE del_gipi_witmperl_grouped(p_par_id    GIPI_WITMPERL_GROUPED.par_id%TYPE,
                                           p_item_no      GIPI_WITMPERL_GROUPED.item_no%TYPE)
                IS
  BEGIN
    DELETE GIPI_WITMPERL_GROUPED
     WHERE PAR_ID  =  p_par_id
       AND ITEM_NO =  p_item_no;
  END;

     /*
    **  Created by        : Jerome Orio
    **  Date Created     : 05.27.2010
    **  Reference By     : (GIPIS012- Item Information - Accident - Grouped Items - Coverage)
    **  Description     : Get PAR record listing for GIPI_WITMPERL_GROUPED per item no
    */
  PROCEDURE del_gipi_witmperl_grouped2(p_par_id           GIPI_WITMPERL_GROUPED.par_id%TYPE,
                                            p_item_no          GIPI_WITMPERL_GROUPED.item_no%TYPE,
                                       p_grouped_item_no  GIPI_WITMPERL_GROUPED.grouped_item_no%TYPE)
                IS
  BEGIN
    DELETE GIPI_WITMPERL_GROUPED
     WHERE PAR_ID  =  p_par_id
       AND ITEM_NO =  p_item_no
       AND GROUPED_ITEM_NO  =  p_grouped_item_no;
  END;

     /*
    **  Created by        : Jerome Orio
    **  Date Created     : 05.27.2010
    **  Reference By     : (GIPIS012- Item Information - Accident - Grouped Items - Coverage)
    **  Description     : Get PAR record listing for GIPI_WITMPERL_GROUPED per item no
    */
  PROCEDURE del_gipi_witmperl_grouped3(p_par_id           GIPI_WITMPERL_GROUPED.par_id%TYPE,
                                            p_item_no          GIPI_WITMPERL_GROUPED.item_no%TYPE,
                                       p_grouped_item_no  GIPI_WITMPERL_GROUPED.grouped_item_no%TYPE,
                                       p_peril_cd          GIPI_WITMPERL_GROUPED.peril_cd%TYPE)
                IS
  BEGIN
    DELETE GIPI_WITMPERL_GROUPED
     WHERE PAR_ID  =  p_par_id
       AND ITEM_NO =  p_item_no
       AND GROUPED_ITEM_NO  =  p_grouped_item_no
       AND PERIL_CD            =  p_peril_cd;
  END;
  
  PROCEDURE del_gipi_witmperl_grouped4(
    p_par_id           GIPI_WITMPERL_GROUPED.par_id%TYPE,
    p_item_no          GIPI_WITMPERL_GROUPED.item_no%TYPE,
    p_grouped_item_no  GIPI_WITMPERL_GROUPED.grouped_item_no%TYPE
  )
  IS
  BEGIN
    DELETE GIPI_WITMPERL_GROUPED
     WHERE par_id = p_par_id
       AND item_no = p_item_no
       AND grouped_item_no = p_grouped_item_no;
       
    UPDATE GIPI_WGROUPED_ITEMS
       SET delete_sw = 'N'
     WHERE par_id = p_par_id
       AND item_no = p_item_no
       AND grouped_item_no = p_grouped_item_no;
  END;

  /*
  **  Created by   :  Jerome Orio
  **  Date Created :  05.28.2010
  **  Reference By : (GIPIS012- Item Information - Accident - Grouped Items - Coverage)
  **  Description  : This returns if par_id and item_no is existing in GIPI_WITMPERL_GROUPED
  */
  FUNCTION gipi_witmperl_grouped_exist (p_par_id          GIPI_WITMPERL_GROUPED.par_id%TYPE,
                                             p_item_no        GIPI_WITMPERL_GROUPED.item_no%TYPE)
    RETURN VARCHAR2 IS
    v_exist     VARCHAR2(1) := 'N';
  BEGIN
    FOR a IN (SELECT 1
                FROM GIPI_WITMPERL_GROUPED
               WHERE par_id = p_par_id
                 AND item_no = p_item_no)
    LOOP
      v_exist := 'Y';
    END LOOP;
    RETURN v_exist;
  END;

  PROCEDURE pre_commit_gipis012(p_par_id           GIPI_WITMPERL_GROUPED.par_id%TYPE,
                                  p_line_cd           GIPI_WITMPERL_GROUPED.line_cd%TYPE,
                                p_peril_cd            GIPI_WITMPERL_GROUPED.peril_cd%TYPE)
                IS
  BEGIN
     FOR A1 IN (SELECT  a.line_cd, a.main_wc_cd
                  FROM giis_peril_clauses a
                 WHERE a.line_cd  = p_line_cd
                   AND a.peril_cd = p_peril_cd
                   AND NOT EXISTS (SELECT '1'
                                     FROM gipi_wpolwc b
                                    WHERE b.par_id = p_par_id
                                      AND b.line_cd = a.line_cd
                                      AND b.wc_cd   = a.main_wc_cd))
     LOOP
       FOR B IN (SELECT line_cd, main_wc_cd, print_sw,wc_title
                      FROM giis_warrcla
                     WHERE line_cd = a1.line_cd
                       AND main_wc_cd = a1.main_wc_cd)
       LOOP
         INSERT INTO gipi_wpolwc
                     (par_id,       line_cd,    wc_cd,        swc_seq_no,    print_seq_no,
                      wc_title,     rec_flag,   print_sw,     change_tag)
                   VALUES(p_par_id, b.line_cd,  b.main_wc_cd, 0,  1,
                          b.wc_title,   'A',        b.print_sw,   'N');
          END LOOP;
     END LOOP;
  END;

  /*
  **Created by  : Angelo Pagaduan
  **Date Created   : 10.21.2010
  **Reference By  : (GIPIS065 - Grouped Items - Retrieve Grp Items)
  **Description      : gets gipi_witmperl_grouped of retrieved items
  */

  FUNCTION rgitm_gipi_witmperl_grouped(p_par_id                 GIPI_WGROUPED_ITEMS.par_id%TYPE,
                                             p_policy_id                 GIPI_GROUPED_ITEMS.policy_id%TYPE,
                                        p_item_no                 GIPI_GROUPED_ITEMS.item_no%TYPE,
                                        p_grouped_item_no         GIPI_GROUPED_ITEMS.grouped_item_no%TYPE
                                               )

    RETURN gipi_witmperl_grouped_tab PIPELINED IS
    v_row gipi_witmperl_grouped_type;

  BEGIN

    FOR gipi_witmperl_grouped_item IN (SELECT p_par_id PAR_ID,ITEM_NO, GROUPED_ITEM_NO, LINE_CD, PERIL_CD, REC_FLAG, PREM_RT, /*TSI_AMT, --A.R.C. 08.22.2006
                                                                       PREM_AMT,*/ ANN_TSI_AMT, ANN_PREM_AMT, AGGREGATE_SW, BASE_AMT, RI_COMM_RATE,
                                                                          RI_COMM_AMT, NO_OF_DAYS
                                                                  FROM gipi_itmperil_grouped
                                                                    WHERE policy_id = p_policy_id
                                                                      AND item_no         = p_item_no
                                                                     AND grouped_item_no = p_grouped_item_no
                                         ) LOOP
        v_row.par_id := gipi_witmperl_grouped_item.par_id;
        v_row.item_no := gipi_witmperl_grouped_item.item_no;
        v_row.grouped_item_no := gipi_witmperl_grouped_item.grouped_item_no;
        v_row.line_cd := gipi_witmperl_grouped_item.line_cd;
        v_row.peril_cd := gipi_witmperl_grouped_item.peril_cd;
        v_row.rec_flag := gipi_witmperl_grouped_item.rec_flag;
        v_row.prem_rt := gipi_witmperl_grouped_item.prem_rt;
        v_row.ann_tsi_amt := gipi_witmperl_grouped_item.ann_tsi_amt;
        v_row.ann_prem_amt := gipi_witmperl_grouped_item.ann_prem_amt;
        v_row.aggregate_sw := gipi_witmperl_grouped_item.aggregate_sw;
        v_row.base_amt := gipi_witmperl_grouped_item.base_amt;
        v_row.ri_comm_rate := gipi_witmperl_grouped_item.ri_comm_rate;
        v_row.ri_comm_amt := gipi_witmperl_grouped_item.ri_comm_amt;
        v_row.no_of_days := gipi_witmperl_grouped_item.no_of_days;
        PIPE ROW(v_row);
        END LOOP;
        RETURN;

  END;

  /*
    **  Created by        : Angelo Pagaduan
    **  Date Created     : 11.25.2010
    **  Reference By     : (GIPIS065 - Accident Endt Item Information)
    **  Description     :Get PAR record listing for GIPI_WITMPERL_GROUPED
    */

    FUNCTION get_gipi_witmperl_grouped2(p_par_id    GIPI_WITMPERL_GROUPED.par_id%TYPE)
    RETURN gipi_witmperl_grouped_tab PIPELINED IS
    v_cov    gipi_witmperl_grouped_type;
  BEGIN
    FOR i IN (SELECT a.par_id,         a.item_no,                a.grouped_item_no,
                        a.line_cd,           a.peril_cd,                 a.rec_flag,
                     a.no_of_days,       a.prem_rt,                a.tsi_amt,
                     a.prem_amt,       a.ann_tsi_amt,            a.ann_prem_amt,
                     a.aggregate_sw,   a.base_amt,                a.ri_comm_rate,
                     a.ri_comm_amt,
                        b.grouped_item_title,
                     c.peril_name,        c.peril_type
                  FROM GIPI_WITMPERL_GROUPED a,
                     GIPI_WGROUPED_ITEMS b,
                     GIIS_PERIL c
               WHERE a.par_id = p_par_id
                 AND a.par_id = b.par_id
                 AND a.item_no = b.item_no
                 AND a.grouped_item_no = b.grouped_item_no
                 AND a.peril_cd = c.peril_cd(+)
                 AND a.line_cd = c.line_cd(+)
                 ORDER BY par_id,item_no,grouped_item_no)
    LOOP
      v_cov.par_id                      := i.par_id;
      v_cov.item_no                 := i.item_no;
      v_cov.grouped_item_no         := i.grouped_item_no;
      v_cov.line_cd                      := i.line_cd;
      v_cov.peril_cd                  := i.peril_cd;
      v_cov.rec_flag                 := i.rec_flag;
      v_cov.no_of_days                := i.no_of_days;
      v_cov.prem_rt                     := i.prem_rt;
      v_cov.tsi_amt                    := i.tsi_amt;
      v_cov.prem_amt                := i.prem_amt;
      v_cov.ann_tsi_amt                  := i.ann_tsi_amt;
      v_cov.ann_prem_amt            := i.ann_prem_amt;
      v_cov.aggregate_sw              := i.aggregate_sw;
      v_cov.base_amt                   := i.base_amt;
      v_cov.ri_comm_rate             := i.ri_comm_rate;
      v_cov.ri_comm_amt                  := i.ri_comm_amt;
      v_cov.peril_name                 := i.peril_name;
      v_cov.grouped_item_title         := i.grouped_item_title;
      v_cov.peril_type                := i.peril_type;

      PIPE ROW(v_cov);
    END LOOP;
    RETURN;
  END;
    
    /*
    **  Created by        : mark jm
    **  Date Created     : 06.06.2011
    **  Reference By     : (GIPIS065- Endt Item Information - Accident - Grouped Items - Coverage)
    **  Description     : Get PAR record listing for GIPI_WITMPERL_GROUPED per item no
    */
    FUNCTION get_gipi_witmperl_grouped3(
        p_par_id IN gipi_witmperl_grouped.par_id%TYPE,
        p_item_no IN gipi_witmperl_grouped.item_no%TYPE,
        p_grouped_item_no IN gipi_witmperl_grouped.grouped_item_no%TYPE)
    RETURN gipi_witmperl_grouped_tab PIPELINED
    IS
        v_cov    gipi_witmperl_grouped_type;
    BEGIN
        FOR i IN (
            SELECT a.par_id,        a.item_no,        a.grouped_item_no,
                    a.line_cd,        a.peril_cd,        a.rec_flag,
                    a.no_of_days,    a.prem_rt,        a.tsi_amt,
                    a.prem_amt,        a.ann_tsi_amt,    a.ann_prem_amt,
                    a.aggregate_sw,    a.base_amt,        a.ri_comm_rate,
                    a.ri_comm_amt,
                    b.grouped_item_title,
                    c.peril_name,        c.peril_type
              FROM gipi_witmperl_grouped a,
                   gipi_wgrouped_items b,
                   giis_peril c
             WHERE a.par_id = p_par_id
               AND a.item_no = p_item_no
               AND a.grouped_item_no = p_grouped_item_no
               AND a.par_id = b.par_id
               AND a.item_no = b.item_no
               AND a.grouped_item_no = b.grouped_item_no
               AND a.peril_cd = c.peril_cd(+)
               AND a.line_cd = c.line_cd(+)
          ORDER BY par_id,item_no,grouped_item_no)
        LOOP
            v_cov.par_id                := i.par_id;
            v_cov.item_no                := i.item_no;
            v_cov.grouped_item_no        := i.grouped_item_no;
            v_cov.line_cd                := i.line_cd;
            v_cov.peril_cd                := i.peril_cd;
            v_cov.rec_flag                := i.rec_flag;
            v_cov.no_of_days            := i.no_of_days;
            v_cov.prem_rt                := i.prem_rt;
            v_cov.tsi_amt                := i.tsi_amt;
            v_cov.prem_amt                := i.prem_amt;
            v_cov.ann_tsi_amt            := i.ann_tsi_amt;
            v_cov.ann_prem_amt            := i.ann_prem_amt;
            v_cov.aggregate_sw              := i.aggregate_sw;
            v_cov.base_amt                   := i.base_amt;
            v_cov.ri_comm_rate             := i.ri_comm_rate;
            v_cov.ri_comm_amt            := i.ri_comm_amt;
            v_cov.peril_name            := i.peril_name;
            v_cov.grouped_item_title    := i.grouped_item_title;
            v_cov.peril_type            := i.peril_type;

            PIPE ROW(v_cov);
        END LOOP;
        RETURN;
    END get_gipi_witmperl_grouped3;
    
    /*    Date        Author            Description
    **    ==========    ===============    ============================
    **    10.05.2011    mark jm            retrieve records on gipi_witmperl_grouped based on given parameters (tablegrid varsion)      
    */
    FUNCTION get_gipi_witmperl_grouped_tg(
        p_par_id IN gipi_witmperl_grouped.par_id%TYPE,
        p_item_no IN gipi_witmperl_grouped.item_no%TYPE,
        p_grouped_item_no IN gipi_witmperl_grouped.grouped_item_no%TYPE,
        p_grouped_item_title IN VARCHAR2,
        p_peril_name IN VARCHAR2)
    RETURN gipi_witmperl_grouped_tab PIPELINED
    IS
    v_cov    gipi_witmperl_grouped_type;
    BEGIN
        FOR i IN (
            SELECT a.par_id,            a.item_no,        a.grouped_item_no,
                   a.line_cd,            a.peril_cd,        a.rec_flag,
                   a.no_of_days,        a.prem_rt,        a.tsi_amt,
                   a.prem_amt,            a.ann_tsi_amt,    a.ann_prem_amt,
                   a.aggregate_sw,        a.base_amt,        a.ri_comm_rate,
                   a.ri_comm_amt,
                   b.grouped_item_title,c.peril_name,    c.peril_type, c.basc_perl_cd
              FROM gipi_witmperl_grouped a,
                   gipi_wgrouped_items b,
                   giis_peril c
             WHERE a.par_id = p_par_id
               AND a.item_no = p_item_no
               AND a.grouped_item_no = p_grouped_item_no
               AND a.par_id = b.par_id
               AND a.item_no = b.item_no
               AND a.grouped_item_no = b.grouped_item_no
               AND a.peril_cd = c.peril_cd(+)
               AND a.line_cd = c.line_cd(+)
               AND UPPER(c.peril_name) LIKE UPPER(NVL(p_peril_name, '%%'))
               AND UPPER(NVL(b.grouped_item_title, '***')) LIKE UPPER(NVL(p_grouped_item_title, '%%'))
          ORDER BY par_id,item_no,grouped_item_no)
        LOOP
            v_cov.par_id                := i.par_id;
            v_cov.item_no                := i.item_no;
            v_cov.grouped_item_no        := i.grouped_item_no;
            v_cov.line_cd                := i.line_cd;
            v_cov.peril_cd                := i.peril_cd;
            v_cov.rec_flag                := i.rec_flag;
            v_cov.no_of_days            := i.no_of_days;
            v_cov.prem_rt                := i.prem_rt;
            v_cov.tsi_amt                := i.tsi_amt;
            v_cov.prem_amt                := i.prem_amt;
            v_cov.ann_tsi_amt            := i.ann_tsi_amt;
            v_cov.ann_prem_amt            := i.ann_prem_amt;
            v_cov.aggregate_sw            := i.aggregate_sw;
            v_cov.base_amt                := i.base_amt;
            v_cov.ri_comm_rate            := i.ri_comm_rate;
            v_cov.ri_comm_amt            := i.ri_comm_amt;
            v_cov.peril_name            := i.peril_name;
            v_cov.grouped_item_title    := i.grouped_item_title;
            v_cov.peril_type            := i.peril_type;
			  v_cov.basc_perl_cd            := i.basc_perl_cd;

            PIPE ROW(v_cov);
        END LOOP;
        RETURN;
    END get_gipi_witmperl_grouped_tg;
    
    PROCEDURE populate_benefits(
        p_line_cd           IN  GIPI_WPOLBAS.line_cd%TYPE,
        p_iss_cd            IN  GIPI_WPOLBAS.iss_cd%TYPE,
        p_subline_cd        IN  GIPI_WPOLBAS.subline_cd%TYPE,
        p_issue_yy          IN  GIPI_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no        IN  GIPI_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no          IN  GIPI_WPOLBAS.renew_no%TYPE,
        p_par_id            IN  GIPI_WITMPERL_GROUPED.par_id%TYPE,
        p_item_no           IN  GIPI_WITMPERL_GROUPED.item_no%TYPE,
        p_grouped_item_no   IN  GIPI_WITMPERL_GROUPED.grouped_item_no%TYPE,
        p_pack_ben_cd       IN  GIPI_WGROUPED_ITEMS.pack_ben_cd%TYPE
    )
    IS
        v_year              NUMBER := 0;
        v_no_of_days    	NUMBER := 0;
        v_no_of_days_comp   NUMBER := 0;
        v_tsi_amt           NUMBER := 0;
        v_prem_amt          NUMBER := 0;
        v_prem_amt2         NUMBER := 0;
        v_ann_prem_amt      NUMBER := 0;
        v_ann_prem_amt2     NUMBER := 0;
        v_ann_tsi_amt       NUMBER := 0;
        v_type				VARCHAR2(1) := '';
        
        v_from_date         GIPI_WITEM.from_date%TYPE;
        v_to_date           GIPI_WITEM.to_date%TYPE;
        v_incept_date       GIPI_POLBASIC.incept_date%TYPE;
        v_expiry_date       GIPI_POLBASIC.expiry_date%TYPE;
        v_prem_rt           GIIS_PACKAGE_BENEFIT_DTL.prem_pct%TYPE;
        v_prorate_flag      GIPI_WPOLBAS.prorate_flag%TYPE;
    BEGIN
        BEGIN
            SELECT extract_incept(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no),
                   extract_expiry(p_par_id)
              INTO v_incept_date,
                   v_expiry_date
              FROM DUAL;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_incept_date := NULL;
                v_expiry_date := NULL;
        END;
    
        BEGIN
            SELECT prorate_flag
              INTO v_prorate_flag
              FROM GIPI_WPOLBAS
             WHERE par_id = p_par_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_prorate_flag := NULL;
        END;
    
        BEGIN
            SELECT from_date, to_date
              INTO v_from_date, v_to_date
              FROM GIPI_WITEM
             WHERE par_id = p_par_id
               AND item_no = p_item_no;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_from_date := NULL;
                v_to_date := NULL;
        END;
    
        v_no_of_days_comp := NVL(TRUNC(v_to_date),TRUNC(v_expiry_date)) - NVL(TRUNC(v_from_date),trunc(v_incept_date)); 
    
        SELECT TO_NUMBER(TO_CHAR(TO_DATE('12/31/'||TO_CHAR(SYSDATE,'YYYY'),'MM/DD/YYYY'),'DDD'))
	      INTO v_year
		  FROM DUAL;
        
        DELETE
          FROM GIPI_WITMPERL_GROUPED
         WHERE par_id = p_par_id
           AND item_no = p_item_no
           AND grouped_item_no = p_grouped_item_no;
           
        FOR pack_dtl IN (SELECT peril_cd, benefit, prem_pct, no_of_days, aggregate_sw, prem_amt
                           FROM GIIS_PACKAGE_BENEFIT_DTL
                          WHERE pack_ben_cd = p_pack_ben_cd)
        LOOP
            v_no_of_days := NVL(pack_dtl.no_of_days, 0);										
			v_tsi_amt := NVL(pack_dtl.no_of_days, 1) * NVL(pack_dtl.benefit, 0);
            
            IF pack_dtl.prem_amt IS NULL THEN
                IF v_prorate_flag = 2 THEN
                    v_prem_amt := ROUND((NVL(pack_dtl.prem_pct,0)/100) * NVL(v_tsi_amt, 0), 2);
                ELSE
                    v_prem_amt := ROUND((NVL(pack_dtl.prem_pct,0)/100) * NVL(v_tsi_amt, 0) * NVL(v_no_of_days_comp,1), 2);
                END IF;
            ELSE
                --IF v_tsi_amt = 0 THEN                 -- marco - 02.27.2013 - comment out block
                --    v_prem_amt := 0;                  -- see SR 12221 
                --ELSE                                  -- to retrieve prem amount even if there is no TSI
                    v_prem_amt := pack_dtl.prem_amt;
                --END IF;
            END IF;
            
            IF v_tsi_amt != 0 THEN
                v_prem_rt := NVL(pack_dtl.prem_pct, ROUND((v_prem_amt/v_tsi_amt)*100,9));
            ELSE
                v_prem_rt := NVL(pack_dtl.prem_pct, 0);
            END IF;
            
            -- marco - 12.03.2012 - modified for SR 11576
			--v_ann_prem_amt := NVL(pack_dtl.prem_amt, ROUND((((NVL(pack_dtl.prem_pct,0))/100) * NVL(v_tsi_amt,0) * NVL(v_no_of_days_comp,1))/v_year,2));
			--v_prem_rt := ROUND((v_ann_prem_amt/v_tsi_amt)*100,9);
			--v_prem_amt := NVL(ROUND(((pack_dtl.prem_pct)/100)* v_tsi_amt,2),ROUND(NVL(v_tsi_amt,0)*(v_prem_rt/100)*NVL(v_no_of_days_comp,1)/v_year,2));
            
            INSERT
              INTO GIPI_WITMPERL_GROUPED(par_id, item_no, grouped_item_no, 
                                         line_cd, peril_cd, rec_flag, 
                                         prem_rt, base_amt, no_of_days,
                                         tsi_amt, prem_amt, ann_prem_amt, aggregate_sw,
                                         ann_tsi_amt)
			VALUES (p_par_id, p_item_no, p_grouped_item_no,
                    p_line_cd, pack_dtl.peril_cd, 'C',
                    NVL(pack_dtl.prem_pct,v_prem_rt), pack_dtl.benefit, NVL(pack_dtl.no_of_days,v_no_of_days),
                    --v_tsi_amt, v_prem_amt, v_ann_prem_amt, pack_dtl.aggregate_sw, --- marco - 12.03.2012 - modified for SR 11576 
                    v_tsi_amt, v_prem_amt, v_prem_amt, pack_dtl.aggregate_sw,
                    v_tsi_amt);
                    
            BEGIN                    
                SELECT a.peril_type
                  INTO v_type
                  FROM GIIS_PERIL a
                 WHERE a.peril_cd = pack_dtl.peril_cd 
                   AND a.line_cd = p_line_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_type := NULL;
            END;
            
            IF v_type = 'B' THEN
                v_ann_tsi_amt := ROUND((v_ann_tsi_amt + v_tsi_amt),2);
            END IF;
            
            v_prem_amt2 := ROUND((v_prem_amt2 + v_prem_amt),2);
			--v_ann_prem_amt2 := ROUND((v_ann_prem_amt2 + v_ann_prem_amt),2); -- marco - 12.03.2012 - modified for SR 11576
            v_ann_prem_amt2 := ROUND((v_ann_prem_amt2 + v_prem_amt),2);
            
            FOR a1 IN (SELECT a.line_cd, a.main_wc_cd
		                 FROM GIIS_PERIL_CLAUSES a
		                WHERE a.line_cd = p_line_cd
		                  AND a.peril_cd = pack_dtl.peril_cd 
		                  AND NOT EXISTS(SELECT '1'
		                                   FROM GIPI_WPOLWC b
		                                  WHERE b.par_id = p_par_id
		                                    AND b.line_cd = a.line_cd
		                                    AND b.wc_cd = a.main_wc_cd))                                    
            LOOP
                FOR b IN (SELECT line_cd, main_wc_cd, print_sw, wc_title
		   	                FROM GIIS_WARRCLA
		   	               WHERE line_cd = a1.line_cd
		   	                 AND main_wc_cd = a1.main_wc_cd)
		    	LOOP
                    INSERT
                      INTO GIPI_WPOLWC
                           (par_id, line_cd, wc_cd, swc_seq_no, print_seq_no,
		    	 	        wc_title, rec_flag, print_sw, change_tag)
		   	  	    VALUES (p_par_id, b.line_cd, b.main_wc_cd, 0, 1,
		   	  	            b.wc_title, 'A', b.print_sw, 'N');
                END LOOP;
            END LOOP;
        END LOOP;
        
        UPDATE GIPI_WGROUPED_ITEMS
		   SET ann_tsi_amt = v_ann_tsi_amt,		   
		       tsi_amt = v_ann_tsi_amt,		   		 
		   	   ann_prem_amt = v_ann_prem_amt2,
			   prem_amt = v_prem_amt2,
			   amount_covered = v_ann_tsi_amt,
               pack_ben_cd = p_pack_ben_cd
		 WHERE par_id = p_par_id
		   AND item_no = p_item_no
		   AND grouped_item_no = p_grouped_item_no;
        
        v_ann_tsi_amt := 0;
        v_ann_prem_amt2 := 0;  
        v_prem_amt2 := 0;
    END;
    
    FUNCTION get_enrollee_coverage_listing(
        p_par_id                GIPI_WITMPERL_GROUPED.par_id%TYPE,
        p_item_no               GIPI_WITMPERL_GROUPED.item_no%TYPE,
        p_grouped_item_no       GIPI_WITMPERL_GROUPED.grouped_item_no%TYPE,
        p_prem_rt               GIPI_WITMPERL_GROUPED.prem_rt%TYPE,
        p_tsi_amt               GIPI_WITMPERL_GROUPED.tsi_amt%TYPE,
        p_ann_tsi_amt           GIPI_WITMPERL_GROUPED.ann_tsi_amt%TYPE,
        p_prem_amt              GIPI_WITMPERL_GROUPED.prem_amt%TYPE,
        p_ann_prem_amt          GIPI_WITMPERL_GROUPED.ann_prem_amt%TYPE,
        p_peril_name            GIIS_PERIL.peril_name%TYPE
    )
      RETURN gipi_witmperl_grouped_tab2 PIPELINED IS
        v_enrollee              gipi_witmperl_grouped_type2;
        v_expiry_date           DATE; --benjo 12.16.2015 UCPBGEN-SR-20835
        v_exists                VARCHAR2(1); --benjo 12.16.2015 UCPBGEN-SR-20835
    BEGIN
        v_expiry_date := extract_expiry(p_par_id); --benjo 12.16.2015 UCPBGEN-SR-20835
    
        FOR i IN(SELECT a.*,
                        b.grouped_item_title,
                        c.peril_name, c.peril_type, c.basc_perl_cd,
                        d.line_cd v_line_cd, d.subline_cd v_subline_cd, d.iss_cd v_iss_cd, d.issue_yy v_issue_yy, --benjo 12.16.2015 UCPBGEN-SR-20835
                        d.pol_seq_no v_pol_seq_no, d.renew_no v_renew_no, d.eff_date v_eff_date, d.expiry_date v_expiry_date --benjo 12.16.2015 UCPBGEN-SR-20835
                   FROM GIPI_WITMPERL_GROUPED a,
                        GIPI_WGROUPED_ITEMS b,
                        GIIS_PERIL c,
                        GIPI_WPOLBAS d --benjo 12.16.2015 UCPBGEN-SR-20835
                  WHERE a.par_id = p_par_id
                    AND a.par_id = d.par_id --benjo 12.16.2015 UCPBGEN-SR-20835
                    AND a.item_no = p_item_no
                    AND a.grouped_item_no = p_grouped_item_no
                    AND a.par_id = b.par_id
                    AND a.item_no = b.item_no
                    AND a.grouped_item_no = b.grouped_item_no
                    AND a.line_cd = c.line_cd
                    AND a.peril_cd = c.peril_cd
                    AND UPPER(c.peril_name) LIKE UPPER(NVL(p_peril_name, c.peril_name))
                    AND NVL(a.prem_rt, 0) = DECODE(p_prem_rt, NULL, NVL(a.prem_rt, 0), p_prem_rt)
                    AND NVL(a.tsi_amt, 0) = DECODE(p_tsi_amt, NULL, NVL(a.tsi_amt, 0), p_tsi_amt)
                    AND NVL(a.prem_amt, 0) = DECODE(p_prem_amt, NULL, NVL(a.prem_amt, 0), p_prem_amt)
                    AND NVL(a.ann_tsi_amt, 0) = DECODE(p_ann_tsi_amt, NULL, NVL(a.ann_tsi_amt, 0), p_ann_tsi_amt)
                    AND NVL(a.ann_prem_amt, 0) = DECODE(p_ann_prem_amt, NULL, NVL(a.ann_prem_amt, 0), p_ann_prem_amt))
        LOOP
            /* benjo 12.16.2015 UCPBGEN-SR-20835 to get orig_ann_prem_amt */
            v_exists := 'N';
            
            FOR a1 IN (SELECT a.ann_prem_amt
                         FROM gipi_itmperil_grouped a, gipi_polbasic b
                        WHERE b.line_cd = i.v_line_cd
                          AND b.subline_cd = i.v_subline_cd
                          AND b.iss_cd = i.v_iss_cd
                          AND b.issue_yy = i.v_issue_yy
                          AND b.pol_seq_no = i.v_pol_seq_no
                          AND b.renew_no = i.v_renew_no
                          AND b.policy_id = a.policy_id
                          AND a.item_no = i.item_no
                          AND a.grouped_item_no = i.grouped_item_no
                          AND a.peril_cd = i.peril_cd
                          AND b.pol_flag IN ('1', '2', '3', 'X')
                          AND TRUNC (b.eff_date) <= TRUNC (i.v_eff_date)
                          AND TRUNC (DECODE (NVL (b.endt_expiry_date, b.expiry_date),
                                             b.expiry_date, i.v_expiry_date,
                                             b.endt_expiry_date, b.endt_expiry_date
                                            )
                                    ) >= TRUNC (i.v_eff_date)
                          AND NVL (b.endt_seq_no, 0) > 0
                     ORDER BY b.eff_date DESC)
            LOOP 
               v_enrollee.orig_ann_prem_amt := a1.ann_prem_amt;
               v_exists := 'Y';
               EXIT;
            END LOOP;
            
            IF v_exists = 'N' THEN
               FOR a2 IN (SELECT   a.ann_prem_amt
                              FROM gipi_itmperil_grouped a, gipi_polbasic b
                             WHERE b.line_cd = i.v_line_cd
                               AND b.subline_cd = i.v_subline_cd
                               AND b.iss_cd = i.v_iss_cd
                               AND b.issue_yy = i.v_issue_yy
                               AND b.pol_seq_no = i.v_pol_seq_no
                               AND b.renew_no = i.v_renew_no
                               AND b.policy_id = a.policy_id
                               AND a.item_no = i.item_no
                               AND a.grouped_item_no = i.grouped_item_no
                               AND a.peril_cd = i.peril_cd
                               AND b.pol_flag IN ('1', '2', '3', 'X')
                          ORDER BY b.eff_date DESC)
               LOOP
                  v_enrollee.orig_ann_prem_amt := a2.ann_prem_amt;
                  EXIT;
               END LOOP;
            END IF;
            /* benjo end */
        
            v_enrollee.par_id := i.par_id;
            v_enrollee.item_no := i.item_no;
            v_enrollee.grouped_item_no := i.grouped_item_no;
            v_enrollee.line_cd := i.line_cd;
            v_enrollee.peril_cd := i.peril_cd;
            v_enrollee.rec_flag := i.rec_flag;
            v_enrollee.no_of_days := i.no_of_days;
            v_enrollee.prem_rt := NVL(i.prem_rt, 0);
            v_enrollee.tsi_amt := NVL(i.tsi_amt, 0);
            v_enrollee.prem_amt := NVL(i.prem_amt, 0);
            v_enrollee.ann_tsi_amt := NVL(i.ann_tsi_amt, 0);
            v_enrollee.ann_prem_amt := NVL(i.ann_prem_amt, 0);
            v_enrollee.aggregate_sw := i.aggregate_sw;
            v_enrollee.base_amt := i.base_amt;
            v_enrollee.ri_comm_rate := i.ri_comm_rate;
            v_enrollee.ri_comm_amt := i.ri_comm_amt;
            v_enrollee.grouped_item_title := i.grouped_item_title;
            v_enrollee.peril_name := i.peril_name;
            v_enrollee.peril_type := i.peril_type;
            v_enrollee.basc_perl_cd := i.basc_perl_cd;
            PIPE ROW(v_enrollee);
        END LOOP;
        RETURN;
    END;
    
    FUNCTION get_enrollee_coverage_vars(
        p_par_id                GIPI_WITMPERL_GROUPED.par_id%TYPE,
        p_item_no               GIPI_WITMPERL_GROUPED.item_no%TYPE,
        p_grouped_item_no       GIPI_WITMPERL_GROUPED.grouped_item_no%TYPE,
        p_line_cd               GIPI_WPOLBAS.line_cd%TYPE,
        p_iss_cd                GIPI_WPOLBAS.iss_cd%TYPE,
        p_subline_cd            GIPI_WPOLBAS.subline_cd%TYPE,
        p_issue_yy              GIPI_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no            GIPI_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no              GIPI_WPOLBAS.renew_no%TYPE
    )
      RETURN coverage_vars_tab PIPELINED IS
        v_vars                  coverage_vars_type;
        v_tsi_amt               GIPI_WITMPERL_GROUPED.tsi_amt%TYPE;
        v_prem_amt              GIPI_WITMPERL_GROUPED.prem_amt%TYPE;
        v_ann_tsi_amt           GIPI_WITMPERL_GROUPED.ann_tsi_amt%TYPE;
        v_ann_prem_amt          GIPI_WITMPERL_GROUPED.ann_prem_amt%TYPE;
        CURSOR A IS
            SELECT b340.ann_tsi_amt,
				   b340.ann_prem_amt						      										      						      				
			  FROM GIPI_POLBASIC b250,
                   GIPI_GROUPED_ITEMS b340
             WHERE b250.line_cd = p_line_cd
               AND b250.subline_cd = p_subline_cd
               AND b250.iss_cd = p_iss_cd
               AND b250.issue_yy = p_issue_yy
               AND b250.pol_seq_no = p_pol_seq_no
               AND b250.renew_no = p_renew_no
               AND b250.pol_flag IN ('1','2','3','X')
               AND b340.item_no = p_item_no
               AND b340.policy_id = b250.policy_id
               AND b340.grouped_item_no = p_grouped_item_no
			   AND NOT EXISTS (SELECT 1
								 FROM GIPI_WITMPERL_GROUPED
                                WHERE par_id = p_par_id
                                  AND item_no = p_item_no
                                  AND grouped_item_no = p_grouped_item_no)
			   AND b250.endt_seq_no IN (SELECT MAX(endt_seq_no)
	                                       FROM GIPI_GROUPED_ITEMS y,
	                                            GIPI_POLBASIC x 
	                                      WHERE x.line_cd = p_line_cd
	                                        AND x.subline_cd = p_subline_cd
	                                        AND x.iss_cd = p_iss_cd
	                                        AND x.issue_yy = p_issue_yy
	                                        AND x.pol_seq_no = p_pol_seq_no
	                                        AND x.renew_no = p_renew_no
	                                        AND x.pol_flag IN ('1','2','3','X')
	                                        AND y.policy_id = x.policy_id
	                                        AND y.item_no = p_item_no
	                                        AND y.grouped_item_no = p_grouped_item_no);
        item                    A%ROWTYPE;
    BEGIN
        OPEN A;
        FETCH A INTO item;
        
        v_tsi_amt := 0;
        v_prem_amt := 0;
        v_ann_tsi_amt := NVL(item.ann_tsi_amt,0);
        v_ann_prem_amt := NVL(item.ann_prem_amt,0);
        
        /* IF A%NOTFOUND THEN        
            FOR i IN(SELECT tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt
					   FROM GIPI_WGROUPED_ITEMS
					  WHERE par_id = p_par_id
                        AND item_no = p_item_no
                        AND grouped_item_no = p_grouped_item_no)
            LOOP
                v_ann_tsi_amt := NVL(i.ann_tsi_amt, 0);
                v_ann_prem_amt := NVL(i.ann_prem_amt, 0);					
                v_tsi_amt := NVL(i.tsi_amt, 0);
                v_prem_amt := NVL(i.prem_amt, 0);
            END LOOP;
        END IF; */
        
        -- marco - 02.21.2013 - modified block
        IF A%NOTFOUND THEN
            BEGIN
                SELECT NVL(tsi_amt, 0), NVL(prem_amt, 0), NVL(ann_tsi_amt, 0), NVL(ann_prem_amt, 0)
                  INTO v_tsi_amt, v_prem_amt, v_ann_tsi_amt, v_ann_prem_amt
                  FROM GIPI_WGROUPED_ITEMS
                 WHERE par_id = p_par_id
                   AND item_no = p_item_no
                   AND grouped_item_no = p_grouped_item_no;
            END;
            
            IF v_tsi_amt = 0 AND v_prem_amt = 0 AND v_ann_tsi_amt = 0 AND v_ann_prem_amt = 0 THEN
                FOR w IN(SELECT NVL(a.tsi_amt, 0) tsi_amt,
                                NVL(a.prem_amt, 0) prem_amt,
                                NVL(a.ann_tsi_amt, 0) ann_tsi_amt,
                                NVL(a.ann_prem_amt, 0) ann_prem_amt,
                                b.peril_type
                           FROM GIPI_WITMPERL_GROUPED a,
                                GIIS_PERIL b
                          WHERE par_id = p_par_id
                            AND item_no = p_item_no
                            AND grouped_item_no = p_grouped_item_no
                            AND a.peril_cd = b.peril_cd
                            AND a.line_cd = b.line_cd)
                LOOP
                    IF w.peril_type = 'B' THEN
                        v_tsi_amt := v_tsi_amt + w.tsi_amt;
                        v_ann_tsi_amt := v_ann_tsi_amt + w.ann_tsi_amt;
                    END IF;
                    
                    v_prem_amt := v_prem_amt + w.prem_amt;
                    v_ann_prem_amt := v_ann_prem_amt + w.ann_prem_amt;
                END LOOP;
            END IF;
        END IF;
        
        v_vars.tsi_amt := v_tsi_amt;
        v_vars.prem_amt := v_prem_amt;
        v_vars.ann_tsi_amt := v_ann_tsi_amt;
        v_vars.ann_prem_amt := v_ann_prem_amt;
        PIPE ROW(v_vars);
        
        CLOSE A;
        RETURN;
    END;
    
    PROCEDURE delete_itmperl(
        p_peril_cd              GIPI_WITMPERL_GROUPED.peril_cd%TYPE,
        p_peril_type            GIIS_PERIL.peril_type%TYPE,
        p_line_cd           GIPI_WITMPERL_GROUPED.line_cd%TYPE,
        p_item_no               GIPI_WITMPERL_GROUPED.item_no%TYPE,
        p_grouped_item_no       GIPI_WITMPERL_GROUPED.grouped_item_no%TYPE,
        p_basic1          GIIS_PERIL.basc_perl_cd%TYPE,
        
        p_rec_flag      GIPI_WITMPERL_GROUPED.rec_flag%TYPE,
        p_subline_cd    GIPI_WPOLBAS.subline_cd%TYPE,
        p_iss_cd                GIPI_WPOLBAS.iss_cd%TYPE,
        p_issue_yy              GIPI_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no            GIPI_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no              GIPI_WPOLBAS.renew_no%TYPE,
        
        p_eff_date          VARCHAR2,
        p_expiry_date       VARCHAR2,
        
        p_peril_list        VARCHAR2,
        p_peril_count       NUMBER,
        
        p_message       OUT        VARCHAR2
    )
    IS
        v_eff_date DATE := TO_DATE(p_eff_date, 'mm-dd-yyyy');
        v_expiry_date DATE := TO_DATE(p_expiry_date, 'mm-dd-yyyy');
    
        cnt            NUMBER;
        cnt2           NUMBER;
        cnt_basic      NUMBER  := 0;
        max_peril      gipi_witmperl_grouped.peril_cd%TYPE;
        max_tsi        NUMBER;
        p_exist        VARCHAR2(1) := 'N';
        p_cnt          NUMBER;
        p_allied       VARCHAR2(1) := 'N';
        peril_line     VARCHAR2(2);
        peril_peril    NUMBER;
        p_allied_peril NUMBER;
        v_counter      NUMBER:=0;
                  
        cnt_b0         NUMBER :=0;
        cnt_b1         NUMBER :=0;
        exist          VARCHAR2(1) := 'N';
    BEGIN
        p_message := 'SUCCESS';
        IF p_peril_type = 'B' THEN
            FOR i IN(SELECT *
                       FROM TABLE(GIPI_WITMPERL_GROUPED_PKG.prepare_peril_rg(p_peril_list, p_peril_count)))
            LOOP
                IF i.peril_cd=p_peril_cd THEN
                    p_exist     := 'Y';
                    peril_peril := i.peril_cd;
                END IF;
                IF i.peril_type = 'A' and NVL(i.basc_perl_cd, 0) = 0  AND nvl(i.tsi_amt,0) > 0 THEN
                    p_allied_peril  :=  i.peril_cd;
                END IF;
                IF i.peril_type = 'A' and nvl(i.tsi_amt,0) > 0 AND  NVL(max_tsi,0) < i.tsi_amt THEN
              	 	  max_tsi   :=  i.tsi_amt;
              	 	  max_peril :=  i.peril_cd;
                END IF;
                IF ((i.peril_type='A') AND (i.basc_perl_cd=p_peril_cd)) and nvl(i.tsi_amt, 0) > 0 THEN
                    FOR A IN (SELECT peril_name
                                FROM giis_peril
                               WHERE line_cd  =  p_line_cd
                                 AND peril_cd =  i.peril_cd)
                    LOOP
                        p_message := 'The peril '''||A.peril_name||''' must be deleted first.';
                        p_allied    :=  'Y';
                        RETURN;
                    END LOOP;
                END IF;
            END LOOP;
            IF p_allied_peril is not null THEN
                FOR i IN(SELECT *
                           FROM TABLE(GIPI_WITMPERL_GROUPED_PKG.prepare_peril_rg(p_peril_list, p_peril_count)))
                LOOP
                    IF i.peril_type = 'B' AND i.peril_cd != P_PERIL_CD AND NVL(i.tsi_amt,0) >= NVL(MAX_TSI,0) THEN
                        cnt_basic := cnt_basic  + 1;
                    END IF;
                END LOOP;
                IF cnt_basic = 0 then
                    FOR A IN (SELECT peril_name
                                FROM giis_peril
                               WHERE line_cd  =  p_line_CD
                                 AND peril_cd =  max_peril)
                    LOOP
                        p_message := 'The peril '''||A.peril_name||''' must be deleted first.';
                        p_allied    :=  'Y';
                        RETURN;
                    END LOOP;
                END IF;
            END IF;
        ELSIF p_peril_type = 'A'  AND p_rec_flag  != 'A' THEN
            IF P_BASIC1 IS NULL  THEN
                BEGIN
                    FOR i IN(SELECT *
                               FROM TABLE(GIPI_WITMPERL_GROUPED_PKG.prepare_peril_rg(p_peril_list, p_peril_count)))
                    LOOP
                        exist := 'N';
                        IF i.peril_type = 'B' THEN
                            IF NVL(i.tsi_amt,0) = 0 THEN
                                cnt_b0 := NVL(cnt_b0,0) + 1 ;
                            ELSE
                                cnt_b1 := NVL(cnt_b1,0) + 1 ;
                            END IF;
                        END IF;
                    END LOOP;
                    FOR BASIC1 IN (SELECT distinct b380.peril_cd
                                     FROM giis_peril    a170,
                                          gipi_itmperil_grouped b380,
                                          gipi_polbasic b250
                                    WHERE b250.line_cd      =  p_line_cd
                                      AND b250.subline_cd   =  p_subline_cd
                                      AND b250.iss_cd       =  p_iss_cd
                                      AND b250.issue_yy     =  p_issue_yy
                                      AND b250.pol_seq_no   =  p_pol_seq_no
                                      AND b250.renew_no     =  p_renew_no
                                      AND b250.policy_id    =  b380.policy_id
                                      AND b380.peril_cd     =  a170.peril_cd
                                      AND b380.line_cd      =  a170.line_cd
                                      AND b380.item_no      =  p_item_no
                                      AND b380.grouped_item_no = p_grouped_item_no
                                      AND a170.peril_type   = 'B'
                                      AND NVL(a170.subline_cd,b250.subline_cd)= p_subline_cd)
                    LOOP
                        exist := 'N';
                        FOR i IN(SELECT *
                                   FROM TABLE(GIPI_WITMPERL_GROUPED_PKG.prepare_peril_rg(p_peril_list, p_peril_count)))
                        LOOP
                            IF i.peril_cd   = BASIC1.peril_cd THEN
                                exist := 'Y';
                                EXIT;
                            END IF;
                        END LOOP;
                        IF exist = 'N' THEN
                            FOR C1 IN (SELECT A.ann_tsi_amt     ann_tsi_amt
                                         FROM gipi_itmperil_grouped A,
                                              gipi_polbasic B 
                                        WHERE B.line_cd      =  p_line_cd
                                          AND B.subline_cd   =  p_subline_cd
                                          AND B.iss_cd       =  p_iss_cd
                                          AND B.issue_yy     =  p_issue_yy
                                          AND B.pol_seq_no   =  p_pol_seq_no
                                          AND B.renew_no     =  p_renew_no
                                          AND B.policy_id    =  A.policy_id
                                          AND A.item_no      =  p_item_no
                                          AND A.grouped_item_no =  p_grouped_item_no
                                          AND A.peril_cd     =  BASIC1.peril_cd
                                          AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
                                              v_expiry_date, b.endt_expiry_date,b.endt_expiry_date)) >= v_eff_date
                                        ORDER BY B.eff_date  DESC)
                            LOOP
                                IF c1.ann_tsi_amt > 0 THEN
                                    cnt_b1 := cnt_b1 +1;
                                END IF;
                            END LOOP;
                        END IF;
                    END LOOP;
                    IF NVL(cnt_b1,0) = 0 AND NVL(cnt_b0,0) > 0 THEN
                        p_message := 'This peril cannot be deleted because the corresponding basic peril had been zeroed out';
                        RETURN;
                    END IF;
                END;
            ELSIF p_BASIC1 IS NOT NULL  THEN
                FOR i IN(SELECT *
                           FROM TABLE(GIPI_WITMPERL_GROUPED_PKG.prepare_peril_rg(p_peril_list, p_peril_count)))
                LOOP
                    IF i.peril_cd   = p_basic1 THEN
                        IF nvl(i.tsi_amt,0) = 0 THEN
                            p_message := 'This peril cannot be deleted because the corresponding basic peril had been zeroed out.';
                            RETURN;
                        END IF;
                        EXIT;
                    END IF;
                END LOOP;
            END IF;
        END IF; -- peril_type
    END;
    
    FUNCTION check_open_allied_peril(
        p_par_id                GIPI_WITMPERL_GROUPED.par_id%TYPE,
        p_line_cd               GIPI_WPOLBAS.line_cd%TYPE,
        p_subline_cd            GIPI_WPOLBAS.subline_cd%TYPE,
        p_iss_cd                GIPI_WPOLBAS.iss_cd%TYPE,
        p_issue_yy              GIPI_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no            GIPI_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no              GIPI_WPOLBAS.renew_no%TYPE,
        p_item_no               GIPI_WITMPERL_GROUPED.item_no%TYPE,
        p_grouped_item_no       GIPI_WITMPERL_GROUPED.grouped_item_no%TYPE,
        p_eff_date              VARCHAR2,
        p_peril_cd              GIPI_WITMPERL_GROUPED.peril_cd%TYPE,
        p_count1                NUMBER,
        p_count0                NUMBER
    )
      RETURN VARCHAR2 IS
        v_exist                 VARCHAR2(1) := 'N';
        v_expiry_date           GIPI_POLBASIC.expiry_date%TYPE;
        v_count1                NUMBER := p_count1;
    BEGIN
        v_expiry_date := extract_expiry2(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
    
        FOR basic1 IN (SELECT DISTINCT b380.peril_cd
                         FROM GIIS_PERIL a170,
                              GIPI_ITMPERIL_GROUPED b380,
                              GIPI_POLBASIC b250
                      WHERE b250.line_cd = p_line_cd
                        AND b250.subline_cd = p_subline_cd
                        AND b250.iss_cd = p_iss_cd
                        AND b250.issue_yy = p_issue_yy
                        AND b250.pol_seq_no = p_pol_seq_no
                        AND b250.renew_no = p_renew_no
                        AND b250.policy_id = b380.policy_id
                        AND b380.peril_cd = a170.peril_cd
                        AND b380.line_cd = a170.line_cd
                        AND b380.item_no = p_item_no
                        AND b380.grouped_item_no = p_grouped_item_no
                        AND a170.peril_type = 'B'
                        AND NVL(a170.subline_cd,b250.subline_cd)= p_subline_cd)
        LOOP
            v_exist := 'N';
            FOR i IN(SELECT 1
                       FROM GIPI_WITMPERL_GROUPED
                      WHERE peril_cd = basic1.peril_cd
                        AND line_cd = p_line_cd
                        AND item_no = p_item_no
                        AND grouped_item_no = p_grouped_item_no)
            LOOP
                v_exist := 'Y';
            END LOOP;
            
            IF v_exist = 'N' THEN
                FOR c1 IN (SELECT A.ann_tsi_amt ann_tsi_amt
                             FROM GIPI_ITMPERIL_GROUPED A,
                                  GIPI_POLBASIC B 
                            WHERE b.line_cd = p_line_cd
                              AND b.subline_cd = p_subline_cd
                              AND b.iss_cd = p_iss_cd
                              AND b.issue_yy = p_issue_yy
                              AND b.pol_seq_no = p_pol_seq_no
                              AND b.renew_no = p_renew_no
                              AND b.policy_id =  a.policy_id
                              AND a.item_no = p_item_no
                              AND a.grouped_item_no = p_grouped_item_no
                              AND a.peril_cd = basic1.peril_cd
                              AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
                                  v_expiry_date, b.endt_expiry_date,b.endt_expiry_date)) >= TO_DATE(p_eff_date, 'mm-dd-yyyy')
                            ORDER BY b.eff_date  DESC)
                LOOP
                    IF c1.ann_tsi_amt > 0 THEN
                        v_count1 := v_count1 +1;
                    END IF;
                END LOOP;
            END IF;
        END LOOP;
        
        IF NVL(v_count1, 0) = 0 AND NVL(p_count0, 0) > 0 THEN
            RETURN 'This peril cannot be deleted because the corresponding basic peril had been zeroed out.';
        ELSE
            RETURN 'SUCCESS';
        END IF;
    END;
    
    PROCEDURE validate_allied(
        p_line_cd                   GIPI_QUOTE.line_cd%TYPE,
        p_peril_cd                  GIPI_WITMPERL_GROUPED.peril_cd%TYPE,
        p_peril_type                GIIS_PERIL.peril_type%TYPE,
        p_basc_perl_cd              GIIS_PERIL.basc_perl_cd%TYPE,
        p_tsi_amt                   GIPI_WITMPERL_GROUPED.tsi_amt%TYPE,
        p_prem_amt                  GIPI_WITMPERL_GROUPED.prem_amt%TYPE,
        
        p_par_id        GIPI_WPOLBAS.par_id%TYPE,
        p_subline_cd    GIPI_WPOLBAS.subline_cd%TYPE,
        p_iss_cd        GIPI_WPOLBAS.iss_cd%TYPE,
        p_issue_yy      GIPI_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no    GIPI_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no      GIPI_WPOLBAS.renew_no%TYPE,
        
        p_post_sw                   VARCHAR2, -- y pag galing compute tsi, base_amt, no_of_days
        p_tsi_limit_sw              VARCHAR2, -- N pag galing peril name, Y pag may changes sa tsi = tsi_amt, base_amt, no_of_days
        
        p_ann_tsi_amt               GIPI_WITMPERL_GROUPED.ann_tsi_amt%TYPE,               
        p_old_tsi_amt               GIPI_WITMPERL_GROUPED.tsi_amt%TYPE,
        p_item_no                   GIPI_WITMPERL_GROUPED.item_no%TYPE,
        p_grouped_item_no           GIPI_WITMPERL_GROUPED.grouped_item_no%TYPE,
        
        p_eff_date      VARCHAR2,
        p_expiry_date   VARCHAR2,
        
        p_peril_list                VARCHAR,
        p_peril_count               NUMBER,
        
        p_back_endt     VARCHAR2,
        
        p_message       OUT VARCHAR2
    )
    IS
        v_eff_date          GIPI_WPOLBAS.eff_date%TYPE := TO_DATE(p_eff_date, 'mm-dd-yyyy');
        v_expiry_date       GIPI_WPOLBAS.expiry_date%TYPE := TO_DATE(p_expiry_date, 'mm-dd-yyyy');
    
        cnt_basic      			 NUMBER := 0;
        cnt_basic2				     NUMBER := 0;
        cnt_basic3      			 NUMBER := 0;
        cnt_allied            NUMBER := 0;
        attach_exist          VARCHAR2(1) := 'N';
        allied_exist          VARCHAR2(1) := 'N';
        allied_rg             VARCHAR2(1) := 'N';
        cnt                   NUMBER;
        cnt2                  NUMBER;
        cnt3                  NUMBER := 0;
        b_type                VARCHAR2(1);
        b_peril               NUMBER;
        b_item                NUMBER;
        b_grouped_item                NUMBER;
        b_tsi                 NUMBER;
        b_line                VARCHAR2(5);
        p_peril               NUMBER;
        p_item         			 NUMBER;     
        p_grouped_item         			 NUMBER;
        p_tsi       				   NUMBER;
        p_line         			 VARCHAR2(5);
        b3_peril       			 NUMBER;
        b3_item        			 NUMBER;
        b3_grouped_item        			 NUMBER;
        b3_tsi        				 NUMBER;
        b3_line        			 VARCHAR2(5);
        dum_tsi       				 NUMBER  := NULL;
        rg_tsi        				 NUMBER  := NULL;
        sel_tsi       				 NUMBER  := NULL;
        prem_tsi      				 NUMBER  := NULL;
        fin_tsi       				 NUMBER  := 0;
        basc_tsi      				 NUMBER  := NULL;
        exist_sw      				 VARCHAR2(1);
        comp_tsi      				 NUMBER ;
        v_withbasic      		 NUMBER:=0;
        v_basic_ann_tsi       NUMBER:=0;
    BEGIN
        IF p_post_sw = 'Y' THEN
            comp_tsi := (NVL(p_ann_tsi_amt,0) + NVL(p_tsi_amt,0)- NVL(p_old_tsi_amt,0)  );
        ELSE
            comp_tsi := NVL(p_ann_tsi_amt,0);
        END IF;
        
        IF p_peril_type = 'B'  THEN
            SELECT count(*)
              INTO cnt_allied  
              FROM GIIS_PERIL a170
             WHERE a170.line_cd        = p_line_cd
               AND a170.peril_type     = 'A'
               AND a170.basc_perl_cd   = p_peril_cd;
               
            IF cnt_allied > 0 THEN
                FOR ALLIED1 IN (SELECT a170.peril_cd 
                                  FROM giis_peril a170
                                 WHERE a170.line_cd        = p_line_cd
                                   AND a170.peril_type     = 'A'
                                   AND (a170.basc_perl_cd   = p_peril_cd
                                    OR a170.basc_perl_cd IS NULL))
                LOOP
                    prem_tsi  := null;
                    rg_tsi    := null;
                    FOR i IN(SELECT *
                               FROM TABLE(GIPI_WITMPERL_GROUPED_PKG.prepare_peril_rg(p_peril_list, p_peril_count)))
                    LOOP
                        IF i.peril_cd = ALLIED1.peril_cd THEN
                          rg_tsi    := i.tsi_amt;
                          IF nvl(rg_tsi ,0) > 0 THEN
                             allied_exist := 'Y' ;
                          END IF;
                          EXIT;
                        END IF;
                    END LOOP;
                    
                    IF rg_tsi is null then
                        prem_tsi := null; 
                        sel_tsi := null;
                        FOR C1 IN (SELECT a.ann_tsi_amt     ann_tsi_amt                 
                                     FROM gipi_itmperil_grouped a,
                                          gipi_polbasic b
                                    WHERE b.line_cd      =  p_line_cd
                                      AND b.subline_cd   =  p_subline_cd
                                      AND b.iss_cd       =  p_iss_cd
                                      AND b.issue_yy     =  p_issue_yy
                                      AND b.pol_seq_no   =  p_pol_seq_no
                                      AND b.renew_no     =  p_renew_no
                                      AND b.policy_id    =  a.policy_id
                                      AND a.item_no      =  p_item_no
                                      AND a.grouped_item_no = p_grouped_item_no
                                      AND a.peril_cd     =  ALLIED1.peril_cd
                                      AND b.pol_flag     in('1','2','3','X') 
                                      AND b.eff_date      <= v_eff_date	 
                                      AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
                                                 v_expiry_date, b.endt_expiry_date,b.endt_expiry_date)) >= v_eff_date
                                    ORDER BY b.eff_date DESC)
                        LOOP
                            sel_tsi := c1.ann_tsi_amt;
                            IF nvl(sel_tsi ,0) > 0 THEN
                                allied_exist := 'Y' ;
                            END IF;
                            EXIT;
                        END LOOP;
                        prem_tsi := sel_tsi;
                    ELSE 
                        prem_tsi := rg_tsi;
                    END IF;
                    IF fin_tsi < prem_tsi THEN
                        fin_tsi := prem_tsi;
                    END IF;
                END LOOP;
                
                IF allied_exist = 'Y' THEN
                    FOR CHK_BASIC IN(SELECT a170.peril_cd 
                                       FROM giis_peril a170
                                      WHERE a170.line_cd        = p_line_cd
                                        AND a170.peril_type     = 'B')
                    LOOP
                        allied_rg := 'N';
                        FOR i IN(SELECT *
                                   FROM TABLE(GIPI_WITMPERL_GROUPED_PKG.prepare_peril_rg(p_peril_list, p_peril_count)))
                        LOOP
                            IF i.peril_cd   = CHK_BASIC.peril_cd THEN
                                allied_rg := 'Y';
                                IF NVL(i.tsi_amt, 0) = 0 THEN 
                                    exit;
                                ELSIF NVL(i.tsi_amt,0) >= NVL(fin_tsi,0) THEN
                                    cnt_basic3 := nvl(cnt_basic3,0) + 1;
                                    exit;
                                END IF;
                            END IF;
                        END LOOP;
                        
                        IF allied_rg = 'N' then
                            FOR C3 IN (SELECT a.ann_tsi_amt     ann_tsi_amt                 
                                         FROM gipi_itmperil_grouped a,
                                              gipi_polbasic b
                                        WHERE b.line_cd      =  p_line_cd
                                          AND b.subline_cd   =  p_subline_cd
                                          AND b.iss_cd       =  p_iss_cd
                                          AND b.issue_yy     =  p_issue_yy
                                          AND b.pol_seq_no   =  p_pol_seq_no
                                          AND b.renew_no     =  p_renew_no
                                          AND b.policy_id    =  a.policy_id
                                          AND a.item_no      =  p_item_no
                                          AND a.grouped_item_no      =  p_grouped_item_no
                                          AND a.peril_cd     =  CHK_BASIC.peril_cd
                                          AND b.eff_date      <= v_eff_date	 
                                          AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
                                              v_expiry_date, b.endt_expiry_date,b.endt_expiry_date)) >= TRUNC(v_eff_date)
                                          AND b.pol_flag     in('1','2','3','X') 
                                        ORDER BY b.eff_date DESC)
                            LOOP
                                IF NVL(c3.ann_tsi_amt,0) >= NVL(fin_tsi,0) THEN  
                                    cnt_basic3 := nvl(cnt_basic3,0) + 1;
                                    exit; 
                                END IF;
                            END LOOP;
                        END IF;
                    END LOOP;
                    
                    FOR ALLIED_CHK IN (SELECT a170.peril_cd peril_cd
                                         FROM giis_peril a170
                                        WHERE a170.line_cd        = p_line_cd
                                          AND a170.peril_type     = 'A'
                                          AND a170.basc_perl_cd   = p_peril_cd)
                    LOOP
                        allied_rg := 'N';
                        FOR i IN(SELECT *
                                   FROM TABLE(GIPI_WITMPERL_GROUPED_PKG.prepare_peril_rg(p_peril_list, p_peril_count)))
                        LOOP
                           IF i.peril_cd   = ALLIED_CHK.peril_cd THEN
                                allied_rg := 'Y';
                                IF NVL(i.tsi_amt, 0) = 0 THEN 
                                    exit;
                                ELSE
                                    attach_exist := 'Y';
                                    exit;
                                END IF;
                            END IF;
                        END LOOP;
                        
                        IF allied_rg = 'N' then
                            FOR C3 IN (SELECT a.ann_tsi_amt     ann_tsi_amt                 
                                         FROM gipi_itmperil_grouped a,
                                              gipi_polbasic b
                                        WHERE b.line_cd      =  p_line_cd
                                          AND b.subline_cd   =  p_subline_cd
                                          AND b.iss_cd       =  p_iss_cd
                                          AND b.issue_yy     =  p_issue_yy
                                          AND b.pol_seq_no   =  p_pol_seq_no
                                          AND b.renew_no     =  p_renew_no
                                          AND b.policy_id    =  a.policy_id
                                          AND a.item_no      =  p_item_no
                                          AND a.grouped_item_no      =  p_grouped_item_no
                                          AND a.peril_cd     =  ALLIED_CHK.peril_cd
                                          AND b.pol_flag     in('1','2','3','X') 
                                          AND b.eff_date      <= v_eff_date	 
                                          AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
                                              v_expiry_date, b.endt_expiry_date,b.endt_expiry_date)) >= v_eff_date
                                        ORDER BY b.eff_date DESC)
                            LOOP
                                IF NVL(c3.ann_tsi_amt,0) = 0 THEN
                                    EXIT;
                                ELSE 
                                    attach_exist := 'Y';
                                    exit; 
                                END IF;
                            END LOOP;
                        END IF;
                    END LOOP;
                END IF;
                
                IF p_tsi_limit_sw = 'Y'  THEN
                    IF comp_tsi != 0  THEN    
                        IF comp_tsi < fin_tsi AND NVL(cnt_basic3,0) <= 0 THEN  
                            p_message := 'Ann TSI amount must be greater than or equal to '||LTRIM(to_char(fin_tsi,'99,999,999,999,990.90'))||'.';
                            RETURN;
                        END IF;
                    ELSIF NVL(comp_tsi,0) = 0 AND NVL(cnt_basic3,0) <= 1 AND allied_exist = 'Y' THEN
                        p_message := 'A basic peril cannot be zero out if there is an existing allied peril.';
                        RETURN;
                    ELSIF NVL(comp_tsi,0) = 0 AND NVL(cnt_basic3,0) > 1  AND allied_exist = 'Y' and ATTACH_EXIST = 'Y' THEN
                        p_message := 'A basic peril cannot be zero out if there is an existing allied peril that is attached to it.';
                        RETURN;
                    END IF;
                END IF; 
            ELSE
                FOR ALLIED2 IN (SELECT a170.peril_cd  peril_cd
                                  FROM giis_peril a170
                                 WHERE a170.line_cd        = p_line_cd
                                   AND a170.peril_type     = 'A'
                                   AND a170.basc_perl_cd   IS NULL)
                LOOP
                    prem_tsi  := null;
                    rg_tsi    := null;
                    FOR i IN(SELECT *
                               FROM TABLE(GIPI_WITMPERL_GROUPED_PKG.prepare_peril_rg(p_peril_list, p_peril_count)))
                    LOOP
                        IF i.peril_cd   = ALLIED2.peril_cd THEN
                          rg_tsi    := i.tsi_amt;
                          IF NVL(rg_tsi,0) = 0 THEN
                             exit;
                          ELSE
                             allied_exist := 'Y';
                             EXIT;
                          END IF;
                       END IF;
                    END LOOP;
                    
                    IF rg_tsi is NULL then
                        prem_tsi := null; 
                        sel_tsi := null;
                        FOR C1 IN (SELECT a.ann_tsi_amt     ann_tsi_amt                 
                                     FROM gipi_itmperil_grouped a,
                                          gipi_polbasic b
                                    WHERE b.line_cd      =  p_line_cd
                                      AND b.subline_cd   =  p_subline_cd
                                      AND b.iss_cd       =  p_iss_cd
                                      AND b.issue_yy     =  p_issue_yy
                                      AND b.pol_seq_no   =  p_pol_seq_no
                                      AND b.renew_no     =  p_renew_no
                                      AND b.policy_id    =  a.policy_id
                                      AND a.item_no      =  p_item_no
                                      AND a.grouped_item_no      =  p_grouped_item_no
                                      AND a.peril_cd     =  allied2.peril_cd
                                      AND b.eff_date      <= v_eff_date
                                      AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
                                          v_expiry_date, b.endt_expiry_date,b.endt_expiry_date)) >= v_eff_date
                                      AND b.pol_flag     in('1','2','3','X') 
                                    ORDER BY b.eff_date DESC)
                        LOOP
                            sel_tsi := c1.ann_tsi_amt;
                            IF NVL(sel_tsi,0) = 0 THEN
                                EXIT;
                            ELSE
                                allied_exist := 'Y';                  
                                EXIT;
                            END IF;
                        END LOOP;
                        prem_tsi := sel_tsi;
                    ELSE 
                        prem_tsi := rg_tsi;
                    END IF;
                    IF NVL(fin_tsi,0) < prem_tsi THEN
                        fin_tsi := prem_tsi;
                    END IF;
                END LOOP;
                IF allied_exist = 'Y' THEN
                    FOR CHK_BASIC IN(SELECT a170.peril_cd 
                                       FROM giis_peril a170
                                      WHERE a170.line_cd        = p_line_cd
                                        AND a170.peril_type     = 'B')
                    LOOP
                        allied_rg := 'N';
                        FOR i IN(SELECT *
                                   FROM TABLE(GIPI_WITMPERL_GROUPED_PKG.prepare_peril_rg(p_peril_list, p_peril_count)))
                        LOOP
                            IF i.peril_cd   = CHK_BASIC.peril_cd THEN
                                allied_rg := 'Y';
                                IF NVL(b3_tsi, 0) = 0 THEN 
                                    exit;
                                ELSIF NVL(b3_tsi, 0) <> 0 THEN 
                                    cnt_basic3 := nvl(cnt_basic3,0) + 1;
                                    exit;
                                END IF;
                            END IF;
                        END LOOP;
                        
                        IF allied_rg = 'N' then
                            FOR C3 IN (SELECT a.ann_tsi_amt     ann_tsi_amt                 
                                         FROM gipi_itmperil_grouped a,
                                              gipi_polbasic b
                                        WHERE b.line_cd      =  p_line_cd
                                          AND b.subline_cd   =  p_subline_cd
                                          AND b.iss_cd       =  p_iss_cd
                                          AND b.issue_yy     =  p_issue_yy
                                          AND b.pol_seq_no   =  p_pol_seq_no
                                          AND b.renew_no     =  p_renew_no
                                          AND b.policy_id    =  a.policy_id
                                          AND a.item_no      =  p_item_no
                                          AND a.grouped_item_no      =  p_grouped_item_no
                                          AND a.peril_cd     =  CHK_BASIC.peril_cd
                                          AND b.eff_date      <= v_eff_date	 
                                          AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
                                              v_expiry_date, b.endt_expiry_date,b.endt_expiry_date)) >= v_eff_date
                                          AND b.pol_flag     in('1','2','3','X') 
                                        ORDER BY b.eff_date DESC)
                            LOOP
                                IF NVL(c3.ann_tsi_amt,0) = 0 THEN
                                   EXIT;
                                ELSIF NVL(c3.ann_tsi_amt,0) >= NVL(fin_tsi,0) THEN
                                    cnt_basic3 := nvl(cnt_basic3,0) + 1;
                                    exit; 
                                END IF;
                            END LOOP;
                        END IF;
                    END LOOP;
                END IF;
                
                IF p_tsi_limit_sw = 'Y' THEN
                    IF comp_tsi != 0 THEN        	
                        IF comp_tsi < fin_tsi AND NVL(cnt_basic3,0) <= 0  THEN  
                            p_message := 'Ann TSI amount must be greater than or equal to '||LTRIM(to_char(fin_tsi,'99,999,999,999,990.90'))||'.';
                            RETURN;
                        END IF;
                    ELSIF NVL(comp_tsi,0) = 0 AND NVL(cnt_basic3,0) <= 1 AND allied_exist = 'Y' THEN
                        p_message := 'A basic peril cannot be zero out if there is an existing allied peril.';
                        RETURN;
                    END IF;
                END IF;                       
            END IF;
        ELSIF p_peril_type = 'A'  THEN
            IF p_basc_perl_cd IS NULL  THEN
                BEGIN
                    FOR i IN(SELECT *
                               FROM TABLE(GIPI_WITMPERL_GROUPED_PKG.prepare_peril_rg(p_peril_list, p_peril_count)))
                    LOOP
                        exist_sw := 'N';

                        SELECT a170.peril_type
                          INTO b_type
                          FROM giis_peril a170
                         WHERE a170.line_cd        = p_line_cd
                           AND a170.peril_cd       = i.peril_cd;

                        FOR a2 in (SELECT 1
                                     FROM gipi_itmperil_grouped b380,
                                          gipi_polbasic b250
                                    WHERE b250.line_cd      =  p_line_cd
                                      AND b250.subline_cd   =  p_subline_cd
                                      AND b250.iss_cd       =  p_iss_cd
                                      AND b250.issue_yy     =  p_issue_yy
                                      AND b250.pol_seq_no   =  p_pol_seq_no
                                      AND b250.renew_no     =  p_renew_no
                                      AND b250.policy_id    =  b380.policy_id
                                      AND b380.item_no      =  p_item_no
                                      AND b380.grouped_item_no      =  p_grouped_item_no
                                      AND b250.pol_flag     in('1','2','3','X') 
                                      AND b250.eff_date      <= v_eff_date	 
                                      AND TRUNC(DECODE(NVL(b250.endt_expiry_date, b250.expiry_date), b250.expiry_date,
                                          v_expiry_date, b250.endt_expiry_date,b250.endt_expiry_date)) >= v_eff_date
                                      AND b380.peril_cd     =  i.peril_cd)
                        LOOP
                            exist_sw := 'Y';
                            EXIT;
                        END LOOP;
                        
                        IF b_type = 'B' AND exist_sw = 'N' THEN
                            rg_tsi    := i.tsi_amt; 
                            IF NVL(rg_tsi,0) >0 THEN
                                cnt_basic := NVL(cnt_basic,0) + 1 ;
                            END IF;
                            IF dum_tsi IS NULL AND
                                rg_tsi > 0 THEN
                                dum_tsi := rg_tsi;
                            END IF;
                            IF rg_tsi > nvl(dum_tsi,0) AND nvl(dum_tsi,0) > 0 AND NVL(rg_tsi,0)> 0  THEN
                                dum_tsi := rg_tsi;
                            END IF;
                        END IF;
                    END LOOP;
                END;
                FOR BASIC1 IN (SELECT distinct b380.peril_cd
                                 FROM giis_peril    a170,
                                      gipi_itmperil_grouped b380,
                                      gipi_polbasic b250
                                WHERE b250.line_cd      =  p_line_cd
                                  AND b250.subline_cd   =  p_subline_cd
                                  AND b250.iss_cd       =  p_iss_cd
                                  AND b250.issue_yy     =  p_issue_yy
                                  AND b250.pol_seq_no   =  p_pol_seq_no
                                  AND b250.renew_no     =  p_renew_no
                                  AND b250.policy_id    =  b380.policy_id
                                  AND b380.line_cd      =  a170.line_cd
                                  AND b380.peril_cd     =  a170.peril_cd
                                  AND b380.item_no      =  p_item_no
                                  AND b380.grouped_item_no      =  p_grouped_item_no
                                  AND a170.peril_type   = 'B'
                                  AND b250.pol_flag     in('1','2','3','X')                   
                                  AND b250.eff_date      <= v_eff_date	 
                                  AND TRUNC(DECODE(NVL(b250.endt_expiry_date, b250.expiry_date), b250.expiry_date,
                                      v_expiry_date, b250.endt_expiry_date,b250.endt_expiry_date)) >= v_eff_date
                                  AND NVL(a170.subline_cd,b250.subline_cd)= p_subline_cd) 
                LOOP
                    prem_tsi  := null;
                    rg_tsi    := null;
                    FOR i IN(SELECT *
                               FROM TABLE(GIPI_WITMPERL_GROUPED_PKG.prepare_peril_rg(p_peril_list, p_peril_count)))
                    LOOP
                        IF i.peril_cd   = BASIC1.peril_cd THEN
                          rg_tsi    := nvl(i.tsi_amt,0);
                          IF NVL(rg_tsi,0) > 0 THEN
                             cnt_basic := NVL(cnt_basic,0) + 1 ;
                          END IF;
                          exit;
                       END IF;
                    END LOOP;
                    IF rg_tsi is null then
                        prem_tsi := null; 
                        sel_tsi := null;
                        FOR C1 IN (SELECT A.ann_tsi_amt     ann_tsi_amt
                                     FROM gipi_itmperil_grouped A,
                                          GIPI_POLBASIC B 
                                    WHERE      B.line_cd      =  p_line_cd
                                      AND      B.subline_cd   =  p_subline_cd
                                      AND      B.iss_cd       =  p_iss_cd
                                      AND      B.issue_yy     =  p_issue_yy
                                      AND      B.pol_seq_no   =  p_pol_seq_no
                                      AND      B.renew_no     =  p_renew_no
                                      AND      B.policy_id    =  A.policy_id
                                      AND      A.item_no      =  p_item_no
                                      AND      A.grouped_item_no      =  p_grouped_item_no
                                      AND      A.peril_cd     =  BASIC1.peril_cd
                                      AND      b.eff_date      <= v_eff_date	 
                                      AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
                                          v_expiry_date, b.endt_expiry_date,b.endt_expiry_date)) >= v_eff_date
                                      AND      B.pol_flag     in('1','2','3','X') 
                                    ORDER BY      B.eff_date  DESC)
                        LOOP
                            sel_tsi := c1.ann_tsi_amt;
                            IF nvl(sel_tsi,0) > 0 THEN
                                cnt_basic := NVL(cnt_basic, 0) + 1;
                            END IF;   
                            EXIT;
                        END LOOP;
                        prem_tsi := sel_tsi;
                    ELSE 
                        prem_tsi := rg_tsi;
                    END IF;
                    IF NVL(fin_tsi,0) = 0  AND NVL(prem_tsi,0) > 0 THEN
                        fin_tsi := prem_tsi;
                    END IF;
                    IF nvl(fin_tsi,0) < prem_tsi AND NVL(fin_tsi,0) > 0 and NVL(prem_tsi,0) > 0 THEN
                        fin_tsi := prem_tsi;
                    END IF;
                END LOOP;
                IF NVL(dum_tsi,0) >  NVL(fin_tsi,0) AND nvl(dum_tsi,0) > 0 THEN
                    fin_tsi := dum_tsi;
                ELSIF nvl(fin_tsi,0) = 0 AND NVL(dum_tsi,0) > 0 THEN
                    fin_tsi := dum_tsi;
                END IF;
                IF nvl(cnt_basic ,0) = 0 THEN
                    SELECT COUNT(*), SUM(ann_tsi_amt)
        	          INTO v_withbasic, v_basic_ann_tsi
        	          FROM giis_peril a, 
        	               gipi_witmperl_grouped b
                     WHERE b.par_id = p_par_id
                       AND b.item_no = p_item_no
                       AND b.grouped_item_no = p_grouped_item_no
                       AND a.line_cd      =  b.line_cd
                       AND a.peril_cd     =  b.peril_cd
                       AND a.peril_type = 'B';
                    IF v_withbasic = 0 THEN
                        p_message := 'A basic peril must be added first';
                        RETURN;
                    END IF;
                END IF;
                IF (COMP_TSI > fin_tsi AND p_tsi_limit_sw = 'Y') AND (COMP_TSI > v_basic_ann_tsi) THEN  
                    p_message := 'Ann TSI amount of this peril should be less than or equal to '||LTRIM(to_char(fin_tsi,'99,999,999,999,990.90'))||'.';
                    RETURN;
                END IF;
            ELSE
                prem_tsi  := null;
                rg_tsi    := null;
                FOR i IN(SELECT *
                           FROM TABLE(GIPI_WITMPERL_GROUPED_PKG.prepare_peril_rg(p_peril_list, p_peril_count)))
                LOOP
                    IF i.peril_cd   = p_basc_perl_cd THEN --x
                        rg_tsi    := i.tsi_amt;
                        IF nvl(rg_tsi,0) > 0 THEN
                            cnt_basic := cnt_basic + 1 ;
                        END IF;
                        exit;
                    END IF;  
                END LOOP;
                IF rg_tsi is null then
                    prem_tsi := null; 
                    sel_tsi := null;
                    FOR C1 IN (SELECT A.ann_tsi_amt     ann_tsi_amt
                                 FROM gipi_itmperil_grouped A,
                                      GIPI_POLBASIC B 
                                WHERE      B.line_cd      =  p_line_cd
                                  AND      B.subline_cd   =  p_subline_cd
                                  AND      B.iss_cd       =  p_iss_cd
                                  AND      B.issue_yy     =  p_issue_yy
                                  AND      B.pol_seq_no   =  p_pol_seq_no
                                  AND      B.renew_no     =  p_renew_no
                                  AND      B.policy_id    =  A.policy_id
                                  AND      A.item_no      =  p_item_no
                                  AND      A.grouped_item_no      =  p_grouped_item_no
                                  AND      A.peril_cd     =  p_basc_perl_cd --x
                                  AND      B.pol_flag     in('1','2','3','X') 
                                  AND      b.eff_date      <= v_eff_date	 
                                  AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
                                      v_expiry_date, b.endt_expiry_date,b.endt_expiry_date)) >= v_eff_date
                                ORDER BY      B.eff_date  DESC)
                    LOOP
                        sel_tsi := c1.ann_tsi_amt;
                        EXIT;                  
                    END LOOP;
                    prem_tsi := sel_tsi;
                ELSE 
                    prem_tsi := rg_tsi;
                END IF;
                IF fin_tsi < prem_tsi THEN
                    fin_tsi := prem_tsi;
                END IF;
                IF NVL(cnt_basic,0)= 0 THEN
                    FOR perl IN (SELECT    peril_name
                                   FROM    giis_peril
                                  WHERE    line_cd   =  p_line_cd
                                    AND    peril_cd  =  p_basc_perl_cd)
                    LOOP
                        p_message := 'Basic peril '||perl.peril_name||' must be added first before this peril.';
                        RETURN;
                    END LOOP;
                END IF;
                IF COMP_TSI > FIN_TSI AND p_tsi_limit_sw = 'Y' THEN  
                    p_message := 'Ann TSI amount of this peril should be less than or equal to '||LTRIM(to_char(fin_tsi,'99,999,999,999,990.90'))||'.';
                    RETURN;
                END IF;
            END IF;
        END IF;
        p_message := 'SUCCESS';
        IF p_back_endt = 'Y' THEN
            VALIDATE_BACK_ALLIED(p_line_cd, p_peril_cd, p_peril_type, p_basc_perl_cd, p_tsi_amt, p_prem_amt,
                                 p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no,
                                 p_item_no, p_grouped_item_no, p_eff_date, p_expiry_date, p_tsi_limit_sw,
                                 p_peril_list, p_peril_count, p_message);
        END IF;
        
        /* IF :GLOBAL.CG$BACK_ENDT = 'Y' THEN --x
            VALIDATE_BACK_ALLIED(p_line_cd      ,   p_peril_cd   ,   p_peril_type ,p_basc_perl_cd ,   p_tsi_amt    ,   p_prem_amt );
        END IF; */ 
    END;
    
    PROCEDURE compute_premium(
        px_prem_amt     IN NUMBER,     -- cv001.prem_amt
         p_tsi_amt       IN NUMBER,     -- cv001.tsi_amt
         p_ann_prem_amt  IN OUT NUMBER,     -- cv001.ann_prem_amt
         i_prem_amt      IN OUT NUMBER,     -- gipi_wgr_i.prem_amt
         i_ann_prem_amt  IN OUT NUMBER,
         p_prov_prem_pct IN NUMBER,
         p_prov_prem_tag IN VARCHAR2,
         
         p_ann_tsi_amt IN NUMBER, -- cv1 tsi
         
         p_old_prem_amt     GIPI_ITMPERIL_GROUPED.prem_amt%TYPE,
         p_prem_rt      IN OUT GIPI_ITMPERIL_GROUPED.prem_rt%TYPE,
         p_changed_tag      GIPI_WITEM.changed_tag%TYPE,
         p_prorate_flag     GIPI_WITEM.prorate_flag%TYPE,
         p_from_date        VARCHAR2,
         p_to_date          VARCHAR2,
         p_eff_date          IN     VARCHAR2,
        p_endt_expiry_date  IN     VARCHAR2,
        p_incept_date       IN     VARCHAR2,
        p_expiry_date       IN     VARCHAR2,
         p_comp_sw           IN     GIPI_WPOLBAS.comp_sw%TYPE,
         p_short_rt_percent  GIPI_WITEM.short_rt_percent%TYPE,
         p_par_id            GIPI_WITMPERL_GROUPED.par_id%TYPE,
         p_item_no          GIPI_WITMPERL_GROUPED.item_no%TYPE,
         
         p_line_cd      GIPI_WPOLBAS.line_cd%TYPE,
         p_subline_cd   GIPI_WPOLBAS.subline_cd%TYPE,
         p_iss_cd       GIPI_WPOLBAS.iss_cd%TYPE,
         p_issue_yy     GIPI_WPOLBAS.issue_yy%TYPE,
         p_pol_seq_no       GIPI_WPOLBAS.pol_seq_no%TYPE,
         p_renew_no     GIPI_WPOLBAS.renew_no%TYPE,
         p_peril_cd     GIPI_WITMPERL_GROUPED.peril_cd%TYPE,
         
         p_message      OUT    VARCHAR2
    )
    IS
        p_prem_amt        NUMBER(15,5) := px_prem_amt;--GIPI_WITMPERl.prem_amt%TYPE   :=  px_prem_amt;
      --p_prem_rt         GIPI_WITMPERL.prem_rt%TYPE;        -- supposed value of cv001.prem_rt

      p2_ann_tsi_amt    GIPI_WITMPERL.ann_tsi_amt%TYPE;    -- supposed value of cv001.ann_tsi_amt
      p2_ann_prem_amt   GIPI_WITMPERL.ann_prem_amt%TYPE;   -- supposed value of cv001.ann_prem_amt

      po_tsi_amt        GIPI_WITMPERL.tsi_amt%TYPE;--   := p_tsi_amt; --benjo 12.16.2015 UCBGEN-SR-20835
      po_prem_amt       NUMBER(15,5); --:= p_old_prem_amt; --GIPI_WITMPERL.prem_amt%TYPE  :=  :cv001.nbt_prem_amt; --benjo 12.16.2015 UCBGEN-SR-20835
      po_prem_rt        GIPI_WITMPERL.prem_rt%TYPE;--   := p_prem_rt; --benjo 12.16.2015 UCBGEN-SR-20835

      i2_tsi_amt        GIPI_WITEM.tsi_amt%TYPE;            -- supposed value of b480.tsi_amt
      i2_prem_amt       NUMBER(15,5);--GIPI_WITEM.prem_amt%TYPE;           -- supposed value of b480.prem_amt
      i2_ann_tsi_amt    GIPI_WITEM.ann_tsi_amt%TYPE;        -- supposed value of b480.ann_tsi_amt
      i2_ann_prem_amt   GIPI_WITEM.ann_prem_amt%TYPE;       -- supposed value of b480.ann_prem_amt

      v_prorate         NUMBER;
      v_prem_amt        NUMBER(15,5);--GIPI_WITMPERL.prem_amt%TYPE;
      vo_prem_amt       NUMBER(15,5);--GIPI_WITMPERL.prem_amt%TYPE;

      p_prov_prem       NUMBER(15,5);--GIPI_WITMPERL.prem_amt%TYPE;
      po_prov_prem      NUMBER(15,5);--GIPI_WITMPERL.prem_amt%TYPE;

      prov_discount     NUMBER(12,9)  :=  NVL(p_prov_prem_pct/100,1);
       
      --bdarusin, 02202002
      v_prorate_prem    NUMBER(15,5);--GIPI_WITMPERL.prem_amt%TYPE;  --variable for computed negated premium
      v_no_of_days      NUMBER;											 --
      v_days_of_policy  NUMBER;
      
      v_from_date       GIPI_WITEM.from_date%TYPE;
      v_to_date       GIPI_WITEM.to_date%TYPE;
      pv_from_date            DATE := TO_DATE(p_from_date, 'mm-dd-yyyy');
        pv_to_date              DATE := TO_DATE(p_to_date, 'mm-dd-yyyy');
        pv_eff_date             DATE := TO_DATE(p_eff_date, 'mm-dd-yyyy');
        pv_endt_expiry_date     DATE := TO_DATE(p_endt_expiry_date, 'mm-dd-yyyy');
        pv_incept_date          DATE := TO_DATE(p_incept_date, 'mm-dd-yyyy');
        pv_expiry_date			DATE := TO_DATE(p_expiry_date, 'mm-dd-yyyy');
        v_short_rt_percent      gipi_wpolbas.short_rt_percent%TYPE; --benjo 12.16.2015 UCBGEN-SR-20835
    BEGIN
        p_prem_rt := NULL; --benjo 12.16.2015 UCPBGEN-SR-20835
        
        /*benjo 12.16.2015 UCBGEN-SR-20835*/
        SELECT short_rt_percent
          INTO v_short_rt_percent
          FROM gipi_wpolbas
         WHERE par_id = p_par_id;
        
        p_message := 'SUCCESS';
        FOR i IN(SELECT from_date, to_date
                   FROM GIPI_WITEM
                  WHERE par_id = p_par_id
                    AND item_no = p_item_no)
        LOOP
            v_from_date := i.from_date;
            v_to_date := i.to_date;
        END LOOP;
    
        p_prov_prem        := NVL(px_prem_amt,0);
        po_prov_prem       := NVL(po_prem_amt,0);
        IF NVL(p_prov_prem_tag,'N') != 'Y' THEN
            prov_discount       :=  1;
        END IF;
      
        IF NVL(p_changed_tag,'N')  = 'Y' THEN
            IF p_prorate_flag = 1 THEN
	            IF NVL(pv_to_date,v_to_date) <= NVL(pv_from_date,v_from_date) THEN
	                p_message := 'Your item TO DATE is equal to or less than your FROM DATE. Restricted condition.' ;
                    RETURN;
	            ELSE
                    IF p_comp_sw = 'Y' THEN
                        v_prorate  :=  ((TRUNC(NVL(pv_to_date,v_to_date)) - TRUNC(NVL(pv_from_date,v_from_date ))) + 1 )/
                                         CPI.check_duration(TRUNC(NVL(pv_from_date,v_from_date)),TRUNC(NVL(pv_to_date,v_to_date)));
                    ELSIF p_comp_sw = 'M' THEN
                        v_prorate  :=  ((TRUNC(NVL(pv_to_date,v_to_date)) - TRUNC(pv_eff_date )) - 1 )/
                                         CPI.check_duration(TRUNC(NVL(pv_from_date,v_from_date)),TRUNC(NVL(pv_to_date,v_to_date)));
                    ELSE
                        v_prorate  :=  (TRUNC(NVL(pv_to_date,v_to_date)) - TRUNC(pv_eff_date ))/
                                         CPI.check_duration(TRUNC(NVL(pv_from_date,v_from_date)),TRUNC(NVL(pv_to_date,v_to_date)));
                    END IF;
	            END IF;
                
                -- Solve for the prorate period
	     --*RESOLVE CONDITION IF TSI AND PREMIUM RATE IS ZERO (DAPHNE)*--
                IF ((NVL(p_tsi_amt,0) = 0) AND (NVL(p_prem_rt,0) = 0)) THEN
	                v_prem_amt :=  (NVL(p_prem_amt,0) / v_prorate);
                    IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
                        vo_prem_amt:=  (NVL(po_prem_amt,0)/ v_prorate);
                    ELSE
                        vo_prem_amt:=  (NVL(po_tsi_amt,0) * NVL(po_prem_rt,0) / 100) * prov_discount;
                    END IF;
                ELSIF (NVL(p_tsi_amt,0) != 0) THEN
                    p_prem_rt  :=  ((NVL(p_prem_amt,0) / NVL(p_tsi_amt,0)) * 100) / (v_prorate * prov_discount);
	                v_prem_amt :=  (NVL(p_tsi_amt,0) * NVL(p_prem_rt,0) / 100 ) * prov_discount;
                    IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
                        vo_prem_amt:=  (NVL(po_prem_amt,0)/ v_prorate);
                    ELSE
                        vo_prem_amt:=  (NVL(po_tsi_amt,0) * NVL(po_prem_rt,0) / 100) * prov_discount;
                    END IF;
                END IF;
                
                p2_ann_prem_amt := (NVL(p_ann_prem_amt,0) + NVL(v_prem_amt,0) - NVL(vo_prem_amt,0));  
	            i2_prem_amt := (NVL(i_prem_amt,0) + NVL(px_prem_amt,0)) - NVL(po_prem_amt,0);
                i2_ann_prem_amt := (NVL(i_ann_prem_amt,0) + NVL(v_prem_amt,0) - NVL(vo_prem_amt,0));
            ELSIF p_prorate_flag = 2 THEN
                IF ((NVL(p_tsi_amt,0) = 0) AND (NVL(p_prem_rt,0) = 0)) THEN
	                v_prem_amt :=  (NVL(p_prem_amt,0));
	                IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
	                    vo_prem_amt:=  NVL(po_prem_amt,0);
	                ELSE
	                    vo_prem_amt:=  NVL(po_tsi_amt,0) * NVL(po_prem_rt,0) / 100  * prov_discount;
	                END IF;
                ELSIF (NVL(p_tsi_amt,0) != 0)  THEN
                    p_prem_rt  :=  ((NVL(p_prem_amt,0) / NVL(p_tsi_amt,0)) * 100) / prov_discount;
	                v_prem_amt :=  (NVL(p_tsi_amt,0) * NVL(p_prem_rt,0) / 100 )  * prov_discount;
                    IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
                        vo_prem_amt:=  (NVL(po_prem_amt,0));
	                ELSE
	                    vo_prem_amt:=  (NVL(po_tsi_amt,0) * NVL(po_prem_rt,0) / 100) * prov_discount;
	                END IF;
                END IF;
                p2_ann_prem_amt := (NVL(p_ann_prem_amt,0) + NVL(v_prem_amt,0) - NVL(vo_prem_amt,0)); 
                i2_prem_amt := (NVL(i_prem_amt,0) + NVL(px_prem_amt,0)) - NVL(po_prem_amt,0);
                i2_ann_prem_amt := (NVL(i_ann_prem_amt,0) + NVL(v_prem_amt,0) - NVL(vo_prem_amt,0));
            ELSE
                IF ((NVL(p_tsi_amt,0) = 0) AND (NVL(p_prem_rt,0) = 0)) THEN
	                v_prem_amt :=  (NVL(p_prem_amt,0) / (NVL(v_short_rt_percent/*p_short_rt_percent*/,1)/100)); --benjo 12.16.2015 UCPBGEN-SR-20835
	                IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
	                    vo_prem_amt:= NVL(po_prem_amt,0)/ (NVL(v_short_rt_percent/*p_short_rt_percent*/,1)/100); --benjo 12.16.2015 UCPBGEN-SR-20835
	                ELSE
	                    vo_prem_amt:=  (NVL(po_tsi_amt,0) * NVL(po_prem_rt,0) / 100) * prov_discount;
	                END IF;
                ELSIF (NVL(p_tsi_amt,0) != 0) THEN
                    p_prem_rt  :=  ((NVL(p_prem_amt,0) * 10000) / (NVL(p_tsi_amt,1) * NVL(v_short_rt_percent/*p_short_rt_percent*/,1) * prov_discount)); --benjo 12.16.2015 UCPBGEN-SR-20835
	                v_prem_amt :=  (NVL(p_tsi_amt,0) * NVL(p_prem_rt,0) / 100 ) * prov_discount;    
                    IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
	                    vo_prem_amt:=  (NVL(po_prem_amt,0)/ (NVL(v_short_rt_percent/*p_short_rt_percent*/,1)/100)); --benjo 12.16.2015 UCPBGEN-SR-20835
	                ELSE
	                    vo_prem_amt:=  (NVL(po_tsi_amt,0) * NVL(po_prem_rt,0) / 100) * prov_discount;
	                END IF;
                END IF;
                p2_ann_prem_amt := (NVL(p_ann_prem_amt,0) + NVL(v_prem_amt,0) - NVL(vo_prem_amt,0)); 
	            i2_prem_amt := (NVL(i_prem_amt,0) + NVL(px_prem_amt,0)) - NVL(po_prem_amt,0);
	            i2_ann_prem_amt := (NVL(i_ann_prem_amt,0) + NVL(v_prem_amt,0) - NVL(vo_prem_amt,0));
            END IF;
        ELSE -- changed tag = N       
            IF p_prorate_flag = 1 THEN
                IF pv_endt_expiry_date <= pv_eff_date THEN
	                p_message := 'Your endorsement expiry date is equal to or less than your effectivity date. Restricted condition.';
                    RETURN;
	            ELSE
                    IF NVL(p_changed_tag,'N') = 'Y' THEN
                        v_prorate := (TRUNC(NVL(pv_to_date,v_to_date)) - TRUNC(NVL(pv_from_date,v_from_date))) / 
                                      CPI.check_duration(pv_incept_date,pv_expiry_date);
                    ELSE	 		          
                        IF p_comp_sw = 'Y' THEN
                            v_prorate  :=  ((TRUNC(pv_endt_expiry_date) - TRUNC(pv_eff_date )) + 1 )/
                                            CPI.check_duration(pv_incept_date,pv_expiry_date);
                        ELSIF p_comp_sw = 'M' THEN
                            v_prorate  :=  ((TRUNC(pv_endt_expiry_date) - TRUNC(pv_eff_date )) - 1 )/
                                             CPI.check_duration(pv_incept_date,pv_expiry_date);
                        ELSE
                            v_prorate  :=  (TRUNC(pv_endt_expiry_date) - TRUNC(pv_eff_date ))/
                                             CPI.check_duration(pv_incept_date,pv_expiry_date);
                        END IF;
                    END IF;
	            END IF;
                
                IF ((NVL(p_tsi_amt,0) = 0) AND (NVL(p_prem_rt,0) = 0)) THEN
                    v_prem_amt :=  (NVL(p_prem_amt,0) / v_prorate);
                    
	                IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
                        vo_prem_amt:=  (NVL(po_prem_amt,0)/ v_prorate);
	                ELSE
	                    vo_prem_amt:=  (NVL(po_tsi_amt,0) * NVL(po_prem_rt,0) / 100) * prov_discount;
	                END IF;
                ELSIF (NVL(p_tsi_amt,0) != 0) THEN
                    p_prem_rt  :=  ((NVL(p_prem_amt,0) / NVL(p_tsi_amt,0)) * 100) / (v_prorate * prov_discount);
	                v_prem_amt :=  (NVL(p_tsi_amt,0) * NVL(p_prem_rt,0) / 100 ) * prov_discount;
	                IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
	                    vo_prem_amt:=  (NVL(po_prem_amt,0)/ v_prorate);
	                ELSE
	                    vo_prem_amt:=  (NVL(po_tsi_amt,0) * NVL(po_prem_rt,0) / 100) * prov_discount;
	                END IF;
                END IF;
                p2_ann_prem_amt := (NVL(p_ann_prem_amt,0) + NVL(v_prem_amt,0) - NVL(vo_prem_amt,0)); 
                i2_prem_amt := (NVL(i_prem_amt,0) + NVL(px_prem_amt,0)) - NVL(po_prem_amt,0);
                i2_ann_prem_amt := (NVL(i_ann_prem_amt,0) + NVL(v_prem_amt,0) - NVL(vo_prem_amt,0));
                
                FOR A2 IN ( SELECT b380.peril_cd peril,    b380.prem_amt prem,    b380.tsi_amt tsi, 
	                        b380.ri_comm_amt comm,  b380.prem_rt rate,     nvl(b250.endt_expiry_date, b250.expiry_date) expiry_date,
	                        b250.eff_date,          b250.prorate_flag,     DECODE(nvl(comp_sw,'N'),'Y',1,'M',-1,0) comp_sw    
	                   FROM gipi_polbasic b250, gipi_itmperil b380
	                  WHERE b250.line_cd    = p_line_cd
	                    AND b250.subline_cd = p_subline_cd
	                    AND b250.iss_cd     = p_iss_cd
	                    AND b250.issue_yy   = p_issue_yy
	                    AND b250.pol_seq_no = p_pol_seq_no
	                    AND b250.renew_no   = p_renew_no
	                    AND TRUNC(DECODE(NVL(b250.endt_expiry_date, b250.expiry_date), b250.expiry_date,
                         pv_expiry_date, b250.endt_expiry_date,b250.endt_expiry_date)) >= pv_eff_date
	                    AND b250.pol_flag   IN ('1','2','3','X') 
	                    AND b250.policy_id  = b380.policy_id
	                    AND b380.item_no    = p_item_no
	                    AND B380.peril_cd   = p_peril_cd) 
	            LOOP
                    v_no_of_days     := NULL;
                    v_days_of_policy := NULL;
                    v_prorate_prem   := 0;
                    v_days_of_policy := TRUNC(a2.expiry_date) - TRUNC(a2.eff_date);
                    
                    IF p_prorate_flag = 1 THEN
                        v_days_of_policy := v_days_of_policy + a2.comp_sw;	
                    END IF;
                    
                    IF p_comp_sw = 'Y' THEN
	                    v_no_of_days  :=  (TRUNC(a2.expiry_date) - TRUNC(pv_eff_date))+ 1;             
	                ELSIF p_comp_sw = 'M' THEN
	                    v_no_of_days  :=  (TRUNC(a2.expiry_date) - TRUNC(pv_eff_date)) - 1;             
	                ELSE
	                    v_no_of_days  :=  TRUNC(a2.expiry_date) - TRUNC(pv_eff_date);
	                END IF;
                    
                    IF NVL(v_no_of_days,0)> NVL(v_days_of_policy,0) THEN
	                    v_no_of_days := v_days_of_policy;
	                END IF;	  
                    
                    IF NVL(a2.prem,0) <> 0 THEN
	                    v_prorate_prem := v_prorate_prem + (-(a2.prem /v_days_of_policy)*(v_no_of_days));
	                END IF;
                END LOOP;
            ELSIF p_prorate_flag = 2 THEN            
                IF ((NVL(p_tsi_amt,0) = 0) AND (NVL(p_prem_rt,0) = 0)) THEN
	                v_prem_amt :=  (NVL(p_prem_amt,0));
	                IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
	                    vo_prem_amt:=  NVL(po_prem_amt,0);
	                ELSE
	                    vo_prem_amt:=  NVL(po_tsi_amt,0) * NVL(po_prem_rt,0) / 100  * prov_discount;
	                END IF;
                ELSIF (NVL(p_tsi_amt,0) != 0)  THEN
                    p_prem_rt  :=  ((NVL(p_prem_amt,0) / NVL(p_tsi_amt,0)) * 100) / prov_discount;
	                v_prem_amt :=  (NVL(p_tsi_amt,0) * NVL(p_prem_rt,0) / 100 )  * prov_discount;
	                IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
	                    vo_prem_amt:=  (NVL(po_prem_amt,0));
	                ELSE
	                    vo_prem_amt:=  (NVL(po_tsi_amt,0) * NVL(po_prem_rt,0) / 100) * prov_discount;
	                END IF;
                END IF;
                p2_ann_prem_amt := (NVL(p_ann_prem_amt,0) + NVL(v_prem_amt,0) - NVL(vo_prem_amt,0));
	            i2_prem_amt := (NVL(i_prem_amt,0) + NVL(px_prem_amt,0)) - NVL(po_prem_amt,0);
	            i2_ann_prem_amt := (NVL(i_ann_prem_amt,0) + NVL(v_prem_amt,0) - NVL(vo_prem_amt,0));
            ELSE
                IF ((NVL(p_tsi_amt,0) = 0) AND (NVL(p_prem_rt,0) = 0)) THEN
	                v_prem_amt :=  (NVL(p_prem_amt,0) / (NVL(v_short_rt_percent/*p_short_rt_percent*/,1)/100)); --benjo 12.16.2015 UCPBGEN-SR-20835
	                IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
	                    vo_prem_amt:= NVL(po_prem_amt,0)/ (NVL(v_short_rt_percent/*p_short_rt_percent*/,1)/100); --benjo 12.16.2015 UCPBGEN-SR-20835
	                ELSE
	                    vo_prem_amt:=  (NVL(po_tsi_amt,0) * NVL(po_prem_rt,0) / 100) * prov_discount;
	                END IF;
                ELSIF (NVL(p_tsi_amt,0) != 0) THEN
                    p_prem_rt  :=  ((NVL(p_prem_amt,0) * 10000) / (NVL(p_tsi_amt,1) * NVL(v_short_rt_percent/*p_short_rt_percent*/,1) * prov_discount)); --benjo 12.16.2015 UCPBGEN-SR-20835
	                v_prem_amt :=  (NVL(p_tsi_amt,0) * NVL(p_prem_rt,0) / 100 ) * prov_discount;
                    IF ((NVL(po_tsi_amt,0) = 0) AND (NVL(po_prem_rt,0) = 0)) THEN
                       vo_prem_amt:=  (NVL(po_prem_amt,0)/ (NVL(v_short_rt_percent/*p_short_rt_percent*/,1)/100)); --benjo 12.16.2015 UCPBGEN-SR-20835
                    ELSE
                       vo_prem_amt:=  (NVL(po_tsi_amt,0) * NVL(po_prem_rt,0) / 100) * prov_discount;
                    END IF;
                END IF;
                p2_ann_prem_amt := (NVL(p_ann_prem_amt,0) + NVL(v_prem_amt,0) - NVL(vo_prem_amt,0)); 
                i2_prem_amt := (NVL(i_prem_amt,0) + NVL(px_prem_amt,0)) - NVL(po_prem_amt,0);
                i2_ann_prem_amt := (NVL(i_ann_prem_amt,0) + NVL(v_prem_amt,0) - NVL(vo_prem_amt,0));
            END IF; -- prorate
        END IF; -- changed tag
        
        IF p2_ann_prem_amt < 0 THEN
            p_message := 'Ann Premium Amount Cannot be less than 0.';
            RETURN;
        END IF;
        
        IF (NVL(p_tsi_amt,0) != 0) THEN
            p_prem_rt :=  NVL(p_prem_rt,0);
        END IF;
  
        p_ann_prem_amt     :=  NVL(p2_ann_prem_amt,0);
        i_prem_amt         :=  NVL(i2_prem_amt,0);
        i_ann_prem_amt     :=  NVL(i2_ann_prem_amt,0);
  
        IF (p_ann_prem_amt BETWEEN 0 AND .02) AND (p_ann_tsi_amt = 0) THEN                            
   	        p_ann_prem_amt := 0;
        END IF;
    END;
    
    PROCEDURE   compute_tsi2(p_tsi_amt      IN NUMBER,     -- cv001.tsi_amt
                        p_prem_rt      IN NUMBER,     -- cv001.prem_rt
                        p_ann_tsi_amt  IN OUT NUMBER,     -- cv001.ann_tsi_amt
                        p_ann_prem_amt IN OUT NUMBER,     -- cv001.ann_prem_amt
                        i_tsi_amt      IN OUT NUMBER,     -- :gipi_wgr_i.tsi_amt
                        i_prem_amt     IN OUT NUMBER,     -- :gipi_wgr_i.prem_amt
                        i_ann_tsi_amt  IN OUT NUMBER,     -- :gipi_wgr_i.ann_tsi_amt
                        i_ann_prem_amt IN OUT NUMBER,     -- :gipi_wgr_i.ann_prem_amt
                        p_prov_prem_pct IN NUMBER,
                        p_prov_prem_tag IN VARCHAR2,
                        
                        p_prem_amt      IN OUT NUMBER,
                        p_old_tsi       IN NUMBER,
                        p_old_prem_amt  IN NUMBER,
                        p_old_prem_rt   IN NUMBER,
                        
                        p_changed_tag      GIPI_WITEM.changed_tag%TYPE,    
                        p_peril_type    IN VARCHAR,
                        p_prorate_flag  IN NUMBER,
                        p_comp_sw       IN GIPI_WPOLBAS.comp_sw%TYPE,
                        p_short_rt_percent  GIPI_WITEM.short_rt_percent%TYPE,
                        
                        p_par_id            GIPI_WITMPERL_GROUPED.par_id%TYPE,
                        p_item_no          GIPI_WITMPERL_GROUPED.item_no%TYPE,
                        p_peril_cd          GIPI_WITMPERL_GROUPED.peril_cd%TYPE,
                        
                        p_to_date       IN VARCHAR2,
                        p_from_date     IN VARCHAR2,
                        p_eff_date          IN     VARCHAR2,
                        p_endt_expiry_date  IN     VARCHAR2,
                        p_incept_date       IN     VARCHAR2,
                        p_expiry_date       IN     VARCHAR2,
                        
                        p_line_cd           IN     GIPI_WPOLBAS.line_cd%TYPE,
        p_subline_cd        IN     GIPI_WPOLBAS.subline_cd%TYPE,
        p_iss_cd            IN     GIPI_WPOLBAS.iss_cd%TYPE,
        p_issue_yy          IN     GIPI_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no        IN     GIPI_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no          IN     GIPI_WPOLBAS.renew_no%TYPE,
                        
                        p_message       OUT VARCHAR2
                        
    )
    IS
        prov_discount     NUMBER(12,9)        :=  NVL(p_prov_prem_pct/100,1);

      --p_prem_amt        GIPI_WITMPERL.prem_amt%TYPE;       -- supposed value of cv001.prem_amt

      p2_ann_tsi_amt    GIPI_WITMPERL.ann_tsi_amt%TYPE;    -- supposed value of cv001.ann_tsi_amt
      p2_ann_prem_amt   GIPI_WITMPERL.ann_prem_amt%TYPE;   -- supposed value of cv001.ann_prem_amt

      po_tsi_amt        GIPI_WITMPERL.tsi_amt%TYPE   :=  nvl(p_old_tsi,0);
      po_prem_amt       GIPI_WITMPERL.prem_amt%TYPE  :=  nvl(p_old_prem_amt,0);
      po_prem_rt        GIPI_WITMPERL.prem_rt%TYPE   :=  nvl(p_old_prem_rt,0);

      i2_tsi_amt        GIPI_WITEM.tsi_amt%TYPE;            -- supposed value of b480.tsi_amt
      i2_prem_amt       GIPI_WITEM.prem_amt%TYPE;           -- supposed value of b480.prem_amt
      i2_ann_tsi_amt    GIPI_WITEM.ann_tsi_amt%TYPE;        -- supposed value of b480.ann_tsi_amt
      i2_ann_prem_amt   GIPI_WITEM.ann_prem_amt%TYPE;       -- supposed value of b480.ann_prem_amt

      v_prorate         NUMBER;
      v_prem_amt        GIPI_WITMPERL.prem_amt%TYPE;
      vo_prem_amt       GIPI_WITMPERL.prem_amt%TYPE;

      p_prov_tag        GIPI_WPOLBAS.prov_prem_tag%TYPE;    -- variable to determine if tag is 'Y'
      po_prov_prem      GIPI_WITMPERL.prem_amt%TYPE;
      v_prov_prem       GIPI_WITMPERL.prem_amt%TYPE;
      p_prov_prem       GIPI_WITMPERL.prem_amt%TYPE;        -- variable that would be used if
                                                             -- the basic info holds the
                                                             -- provisional switch equal to yes
      --bdarusin, 03012002
      v_prorate_prem    NUMBER(15,5);--GIPI_WITMPERL.prem_amt%TYPE;  --variable for computed negated premium
      v_no_of_days      NUMBER;											 --
      v_days_of_policy  NUMBER;				
      --A.R.C. 08.17.2006							 --
      v_adj_ann_tsi           gipi_witmperl_grouped.ann_tsi_amt%TYPE;
      v_adj_ann_prem          gipi_witmperl_grouped.ann_prem_amt%TYPE;
      v_peril_adj_ann_tsi     gipi_witmperl_grouped.ann_tsi_amt%TYPE;  
      
      v_from_date       GIPI_WITEM.from_date%TYPE;
      v_to_date       GIPI_WITEM.to_date%TYPE;
      pv_from_date            DATE := TO_DATE(p_from_date, 'mm-dd-yyyy');
        pv_to_date              DATE := TO_DATE(p_to_date, 'mm-dd-yyyy');
        pv_eff_date             DATE := TO_DATE(p_eff_date, 'mm-dd-yyyy');
        pv_endt_expiry_date     DATE := TO_DATE(p_endt_expiry_date, 'mm-dd-yyyy');
        pv_incept_date          DATE := TO_DATE(p_incept_date, 'mm-dd-yyyy');
        pv_expiry_date			DATE := TO_DATE(p_expiry_date, 'mm-dd-yyyy');
        
        v_item_prorate_flag     GIPI_WITEM.prorate_flag%TYPE;
        v_short_rt_percent      gipi_wpolbas.short_rt_percent%TYPE; --benjo 12.16.2015 UCPBGEN-SR-20835
    BEGIN
        /*benjo 12.16.2015 UCPBGEN-SR-20835*/
        SELECT short_rt_percent
          INTO v_short_rt_percent
          FROM gipi_wpolbas
         WHERE par_id = p_par_id;
    
        p_message := 'SUCCESS';
        FOR i IN(SELECT from_date, to_date, prorate_flag
                   FROM GIPI_WITEM
                  WHERE par_id = p_par_id
                    AND item_no = p_item_no)
        LOOP
            v_from_date := i.from_date;
            v_to_date := i.to_date;
            v_item_prorate_flag := i.prorate_flag; -- marco - 02.19.2013 - added prorate_flag for item
        END LOOP;
    
        IF NVL(p_prov_prem_tag,'N') != 'Y' THEN
            prov_discount  :=  1;
        END IF;
        
        IF NVL(p_changed_tag,'N') = 'Y' THEN
            IF v_item_prorate_flag = 1 THEN -- marco - 02.19.2013 - modified condition from gipi_wpolbas prorate_flag to gipi_witem prorate_flag
                IF v_to_date <= v_from_date THEN
	                p_message := 'Your item TO DATE is equal to or less than your FROM DATE. Restricted condition.';
                    RETURN;
	            ELSE
                    IF p_comp_sw = 'Y' THEN
                        v_prorate  :=  ((TRUNC(NVL(pv_to_date,v_to_date)) - TRUNC(NVL(pv_from_date,v_from_date ))) + 1 )/
                                       CPI.check_duration(TRUNC(NVL(pv_from_date,v_from_date)),TRUNC(NVL(pv_to_date,v_to_date)));
                    ELSIF p_comp_sw = 'M' THEN
                        v_prorate  :=  ((TRUNC( NVL(pv_to_date,v_to_date)) - TRUNC(NVL(pv_from_date,v_from_date ))) - 1 )/
                                       CPI.check_duration(TRUNC(NVL(pv_from_date,v_from_date)),TRUNC(NVL(pv_to_date,v_to_date)));
                    ELSE
                        v_prorate  :=  (TRUNC( NVL(pv_to_date,v_to_date)) - TRUNC(NVL(pv_from_date,v_from_date )))/
                                       CPI.check_duration(TRUNC(NVL(pv_from_date,v_from_date)),TRUNC(NVL(pv_to_date,v_to_date)));
                    END IF;
                END IF;
            
                v_prem_amt :=  (NVL(p_tsi_amt,0) * NVL(p_prem_rt,0) / 100 ) * prov_discount;
                
                IF NVL(po_tsi_amt,0) = 0 THEN	
                     vo_prem_amt :=   (NVL(po_prem_amt,0)/ v_prorate);
                ELSE
                     vo_prem_amt :=  (NVL(po_tsi_amt,0) * NVL(po_prem_rt,0)/100 ) * prov_discount;
                END IF;
                
                p_prem_amt :=  (NVL(p_tsi_amt,0) * NVL(p_prem_rt,0) / 100 ) *  v_prorate * prov_discount;				        
	                      
	            p2_ann_tsi_amt := (NVL(p_ann_tsi_amt,0) + NVL(p_tsi_amt,0)  - NVL(po_tsi_amt,0));
	                      
                p2_ann_prem_amt := (NVL(p_ann_prem_amt,0) + NVL(v_prem_amt,0) - NVL(vo_prem_amt,0)); 
        	                      
                i2_prem_amt := (NVL(i_prem_amt,0) + NVL(p_prem_amt,0)) - NVL(po_prem_amt,0);
        	                      
                i2_ann_prem_amt := (NVL(i_ann_prem_amt,0) + NVL(v_prem_amt,0) - NVL(vo_prem_amt,0));
          
                IF p_peril_type = 'B' THEN 
                    i2_tsi_amt := (NVL(i_tsi_amt,0) + NVL(p_tsi_amt,0)) - NVL(po_tsi_amt,0);
                    i2_ann_tsi_amt := (NVL(i_ann_tsi_amt,0) + NVL(p_tsi_amt,0)) - NVL(po_tsi_amt,0);
                END IF;
            ELSIF v_item_prorate_flag = 2 THEN -- marco - 02.19.2013 - modified condition from gipi_wpolbas prorate_flag to gipi_witem prorate_flag
                v_prem_amt :=  (NVL(p_tsi_amt,0) * NVL(p_prem_rt,0) / 100 ) * prov_discount;
                
                IF NVL(po_tsi_amt,0) = 0 THEN	
                    vo_prem_amt:=  (NVL(po_prem_amt,0));
                ELSE
                    vo_prem_amt:=  (NVL(po_tsi_amt,0) * NVL(po_prem_rt,0) / 100) * prov_discount;
                END IF;
                
                p_prem_amt :=  (NVL(p_tsi_amt,0) * NVL(p_prem_rt,0) / 100 ) * prov_discount;
	                  
	            p2_ann_tsi_amt := (NVL(p_ann_tsi_amt,0) + NVL(p_tsi_amt,0)  - NVL(po_tsi_amt,0));
	     
                p2_ann_prem_amt := (NVL(p_ann_prem_amt,0) + NVL(v_prem_amt,0) - NVL(vo_prem_amt,0)); 
	
	            i2_prem_amt := (NVL(i_prem_amt,0) + NVL(p_prem_amt,0)) - NVL(po_prem_amt,0);
	            
                i2_ann_prem_amt := (NVL(i_ann_prem_amt,0) + NVL(v_prem_amt,0) - NVL(vo_prem_amt,0));
                
                IF p_peril_type  = 'B' THEN
	                i2_tsi_amt := (NVL(i_tsi_amt,0) + NVL(p_tsi_amt,0)) - NVL(po_tsi_amt,0);
	                  
	                i2_ann_tsi_amt := (NVL(i_ann_tsi_amt,0) + NVL(p_tsi_amt,0)) - NVL(po_tsi_amt,0);
	            END IF;
            ELSE -- prorate = 3
                v_prem_amt :=  (NVL(p_tsi_amt,0) * NVL(p_prem_rt,0) / 100 ) * prov_discount;
                
                IF NVL(po_tsi_amt,0) = 0 THEN
                    vo_prem_amt:=  (NVL(po_prem_amt,0)/ (NVL(v_short_rt_percent/*p_short_rt_percent*/,1)/100)); --benjo 12.16.2015 UCPBGEN-SR-20835
                ELSE
                    vo_prem_amt:=  (NVL(po_tsi_amt,0) * NVL(po_prem_rt,0)/100 ) * prov_discount;
                END IF;
                
                p_prem_amt := (((NVL(p_prem_rt,0) * NVL(p_tsi_amt,0) * NVL(v_short_rt_percent/*p_short_rt_percent*/,0))) / 10000) * prov_discount; --benjo 12.16.2015 UCPBGEN-SR-20835

        	    p2_ann_tsi_amt := (NVL(p_ann_tsi_amt,0) + NVL(p_tsi_amt,0)  - NVL(po_tsi_amt,0));
	                     
	            p2_ann_prem_amt := (NVL(p_ann_prem_amt,0) + NVL(v_prem_amt,0) - NVL(vo_prem_amt,0)); 
	                     
                i2_prem_amt := (NVL(i_prem_amt,0) + NVL(p_prem_amt,0)) - NVL(po_prem_amt,0);
                                
                i2_ann_prem_amt := (NVL(i_ann_prem_amt,0) + NVL(v_prem_amt,0) - NVL(vo_prem_amt,0));
                
                IF p_peril_type  =  'B' THEN --added condition by gmi
	                i2_tsi_amt := (NVL(i_tsi_amt,0) + NVL(p_tsi_amt,0)) - NVL(po_tsi_amt,0);
	                i2_ann_tsi_amt := (NVL(i_ann_tsi_amt,0) + NVL(p_tsi_amt,0)) - NVL(po_tsi_amt,0);
	            END IF;
            END IF; -- end prorate
        ELSE -- changed_tag = N
            IF p_prorate_flag = 1 THEN
	            IF pv_endt_expiry_date <= pv_eff_date THEN
	                p_message:= 'Your endorsement expiry date is equal to or less than your effectivity date. Restricted condition.';
                ELSE
                    IF NVL(p_changed_tag,'N') = 'Y' THEN
	          	        v_prorate := (TRUNC(NVL(pv_to_date,v_to_date)) - TRUNC(NVL(pv_from_date,v_from_date))) / 
	          	 		          CPI.check_duration(pv_incept_date,pv_expiry_date);
	          	 		          
	                ELSE	 	
			            IF p_comp_sw = 'Y' THEN
			                v_prorate  :=  ((TRUNC( NVL(NVL(pv_to_date,v_to_date),pv_endt_expiry_date)) - TRUNC(NVL(NVL(pv_from_date,v_from_date),pv_eff_date) )) + 1 )/
			                           CPI.check_duration(pv_incept_date,pv_expiry_date);       
			            ELSIF p_comp_sw = 'M' THEN
			                v_prorate  :=  ((TRUNC( NVL(NVL(pv_to_date,v_to_date),pv_endt_expiry_date)) - TRUNC(NVL(NVL(pv_from_date,v_from_date),pv_eff_date) )) - 1 )/
			                           CPI.check_duration(pv_incept_date,pv_expiry_date);       
			            ELSE
			                v_prorate  :=  (TRUNC( NVL(NVL(pv_to_date,v_to_date),pv_endt_expiry_date)) - TRUNC(NVL(NVL(pv_from_date,v_from_date),pv_eff_date) ))/
			                           CPI.check_duration(pv_incept_date,pv_expiry_date);
                                       
                            -- marco - 02.21.2013 - added to prevent 'divisor is equal to 0'
                            IF TRUNC(NVL(pv_to_date,v_to_date)) = TRUNC(NVL(pv_from_date,v_from_date)) THEN
                                v_prorate := 1;
                            END IF;
			            END IF;
                    END IF;
                END IF;
            
                v_prem_amt :=  (NVL(p_tsi_amt,0) * NVL(p_prem_rt,0) / 100 ) * prov_discount;
                
                IF NVL(po_tsi_amt,0) = 0 THEN
                    vo_prem_amt :=   (NVL(po_prem_amt,0)/ v_prorate);
                ELSE
                    vo_prem_amt :=  (NVL(po_tsi_amt,0) * NVL(po_prem_rt,0)/100 ) * prov_discount;
                END IF;
                
                p_prem_amt :=  (NVL(p_tsi_amt,0) * NVL(p_prem_rt,0) / 100 ) *  v_prorate * prov_discount;
                
                FOR A2 IN( SELECT b380.peril_cd peril,   b380.prem_amt prem, b380.tsi_amt tsi, 
	                       b380.ri_comm_amt comm, b380.prem_rt rate,  nvl(b250.endt_expiry_date, b250.expiry_date) expiry_date,
	                       b250.eff_date,         b250.prorate_flag,  DECODE(nvl(comp_sw,'N'),'Y',1,'M',-1,0) comp_sw    
	                  FROM gipi_polbasic b250, gipi_itmperil_grouped b380
	                 WHERE b250.line_cd    = p_line_cd
	                   AND b250.subline_cd = p_subline_cd
	                   AND b250.iss_cd     = p_iss_cd
	                   AND b250.issue_yy   = p_issue_yy
	                   AND b250.pol_seq_no = p_pol_seq_no
	                   AND b250.renew_no    = p_renew_no
	                   AND TRUNC(DECODE(NVL(b250.endt_expiry_date, b250.expiry_date), b250.expiry_date,
                           pv_expiry_date, b250.endt_expiry_date,b250.endt_expiry_date)) >= pv_eff_date
	                   AND b250.pol_flag   IN ('1','2','3','X') 
	                   AND b250.policy_id  = b380.policy_id
	                   AND b380.item_no    = b380.item_no
	                   AND b380.grouped_item_no = b380.grouped_item_no
	                   AND B380.peril_cd   = p_peril_cd) 
	            LOOP
                    v_no_of_days     := NULL;
                    v_days_of_policy := NULL;
                    v_prorate_prem := 0;
	     	 
	     	        v_days_of_policy := TRUNC(a2.expiry_date) - TRUNC(a2.eff_date);	
	     	        IF p_prorate_flag = 1 THEN
	                    v_days_of_policy := v_days_of_policy + a2.comp_sw;	
	                END IF;
                    
                    IF p_comp_sw = 'Y' THEN
	                    v_no_of_days  :=  (TRUNC(a2.expiry_date) - TRUNC(pv_eff_date))+ 1;             
	                ELSIF p_comp_sw = 'M' THEN
	                    v_no_of_days  :=  (TRUNC(a2.expiry_date) - TRUNC(pv_eff_date)) - 1;             
	                ELSE
	                    v_no_of_days  :=  TRUNC(a2.expiry_date) - TRUNC(pv_eff_date);
	                END IF;
                    
                    IF NVL(v_no_of_days,0)> NVL(v_days_of_policy,0) THEN
	       	            v_no_of_days := v_days_of_policy;
	                END IF;	  
           
                    IF NVL(a2.prem,0) <> 0 THEN
                        v_prorate_prem := v_prorate_prem + (-(a2.prem /v_days_of_policy)*(v_no_of_days));
                    END IF;
                END LOOP;
                
                p2_ann_tsi_amt := (NVL(p_ann_tsi_amt,0) + NVL(p_tsi_amt,0)  - NVL(po_tsi_amt,0));
	                     
                p2_ann_prem_amt := (NVL(p_ann_prem_amt,0) + NVL(v_prem_amt,0) - NVL(vo_prem_amt,0)); 
        	                     
                i2_prem_amt := (NVL(i_prem_amt,0) + NVL(p_prem_amt,0)) - NVL(po_prem_amt,0);
        	                     
                i2_ann_prem_amt := (NVL(i_ann_prem_amt,0) + NVL(v_prem_amt,0) - NVL(vo_prem_amt,0));
                
                IF p_peril_type = 'B' THEN --gmi 12/21/05
	                i2_tsi_amt := (NVL(i_tsi_amt,0) + NVL(p_tsi_amt,0)) - NVL(po_tsi_amt,0);
	                i2_ann_tsi_amt := (NVL(i_ann_tsi_amt,0) + NVL(p_tsi_amt,0)) - NVL(po_tsi_amt,0);
	            END IF;
            ELSIF p_prorate_flag = 2 THEN
                v_prem_amt :=  (NVL(p_tsi_amt,0) * NVL(p_prem_rt,0) / 100 ) * prov_discount;
                
                IF NVL(po_tsi_amt,0) = 0 THEN	
                    vo_prem_amt:=  (NVL(po_prem_amt,0));
                ELSE
                    vo_prem_amt:=  (NVL(po_tsi_amt,0) * NVL(po_prem_rt,0) / 100) * prov_discount;
                END IF;
                
                p_prem_amt :=  (NVL(p_tsi_amt,0) * NVL(p_prem_rt,0) / 100 ) * prov_discount;
                
                p2_ann_tsi_amt := (NVL(p_ann_tsi_amt,0) + NVL(p_tsi_amt,0)  - NVL(po_tsi_amt,0));
	            
                p2_ann_prem_amt := (NVL(p_ann_prem_amt,0) + NVL(v_prem_amt,0) - NVL(vo_prem_amt,0)); 
	
	            i2_prem_amt := (NVL(i_prem_amt,0) + NVL(p_prem_amt,0)) - NVL(po_prem_amt,0);
                
	            i2_ann_prem_amt := (NVL(i_ann_prem_amt,0) + NVL(v_prem_amt,0) - NVL(vo_prem_amt,0));
                      
                IF p_peril_type  = 'B' THEN --added condition by gmi
	                i2_tsi_amt := (NVL(i_tsi_amt,0) + NVL(p_tsi_amt,0)) - NVL(po_tsi_amt,0);
	                  
	                i2_ann_tsi_amt := (NVL(i_ann_tsi_amt,0) + NVL(p_tsi_amt,0)) - NVL(po_tsi_amt,0);
	            END IF;
            ELSE --prorate - 3
                v_prem_amt :=  (NVL(p_tsi_amt,0) * NVL(p_prem_rt,0) / 100 ) * prov_discount;
                
                IF NVL(po_tsi_amt,0) = 0 THEN
	                vo_prem_amt:=  (NVL(po_prem_amt,0)/ (NVL(v_short_rt_percent/*p_short_rt_percent*/,1)/100)); --benjo 12.16.2015 UCPBGEN-SR-20835
	            ELSE
	                vo_prem_amt:=  (NVL(po_tsi_amt,0) * NVL(po_prem_rt,0)/100 ) * prov_discount;
	            END IF;
                
                p_prem_amt := (((NVL(p_prem_rt,0) * NVL(p_tsi_amt,0) * NVL(v_short_rt_percent/*p_short_rt_percent*/,0))) / 10000) * prov_discount; --benjo 12.16.2015 UCPBGEN-SR-20835
                
	            p2_ann_tsi_amt := (NVL(p_ann_tsi_amt,0) + NVL(p_tsi_amt,0)  - NVL(po_tsi_amt,0));
	                     
	            p2_ann_prem_amt := (NVL(p_ann_prem_amt,0) + NVL(v_prem_amt,0) - NVL(vo_prem_amt,0)); 
	            
                i2_prem_amt := (NVL(i_prem_amt,0) + NVL(p_prem_amt,0)) - NVL(po_prem_amt,0);
	            
                i2_ann_prem_amt := (NVL(i_ann_prem_amt,0) + NVL(v_prem_amt,0) - NVL(vo_prem_amt,0));
            
                IF p_peril_type  =  'B' THEN --added condition by gmi
	                i2_tsi_amt := (NVL(i_tsi_amt,0) + NVL(p_tsi_amt,0)) - NVL(po_tsi_amt,0);
	                i2_ann_tsi_amt := (NVL(i_ann_tsi_amt,0) + NVL(p_tsi_amt,0)) - NVL(po_tsi_amt,0);	                     
	            END IF;
            END IF; -- end prorate
        END IF; -- end changed_tag
        
        IF p2_ann_tsi_amt < 0 THEN
             p_message := 'Ann TSI Amount cannot be less than 0.';
             RETURN;
        END IF;
        
        IF p2_ann_prem_amt < 0 THEN
             p_message := 'The program automatically compute prem. (rate * TSI), ' ||
               'due to previous affecting endts. made on this policy '||
               'computed prem. exceeds the allowed prem. '||
               'To correct this error enter 0 TSI or 0 prem rate.';
        END IF;
    
        IF p_peril_type = 'B' THEN
  	        v_adj_ann_tsi := i2_ann_tsi_amt - i_ann_tsi_amt;
            i_tsi_amt      :=  i2_tsi_amt;
            i_ann_tsi_amt  :=  i2_ann_tsi_amt;
        END IF;
    
        v_adj_ann_prem := i2_ann_prem_amt- i_ann_prem_amt;
        IF p_peril_type = 'A' THEN
            v_peril_adj_ann_tsi := p2_ann_tsi_amt - p_ann_tsi_amt;
        END IF; 
        
        p_prem_amt     :=  p_prem_amt;
        p_ann_prem_amt :=  p2_ann_prem_amt;
        p_ann_tsi_amt  :=  p2_ann_tsi_amt;  
        i_prem_amt     :=  i2_prem_amt;
        i_ann_prem_amt :=  i2_ann_prem_amt;
 
        IF (p_ann_prem_amt BETWEEN 0 AND .02) AND (p_ann_tsi_amt = 0) THEN                            
   	        p_ann_prem_amt := 0;
        END IF;	  
    END;
    
    PROCEDURE insert_recgrp_witem(
        p_line_cd           IN      GIPI_WPOLBAS.line_cd%TYPE,
        p_subline_cd        IN      GIPI_WPOLBAS.subline_cd%TYPE,
        p_iss_cd            IN      GIPI_WPOLBAS.iss_cd%TYPE,
        p_issue_yy          IN      GIPI_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no        IN      GIPI_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no          IN      GIPI_WPOLBAS.renew_no%TYPE,
        p_eff_date          IN      VARCHAR2,
        p_par_id            IN      GIPI_WITMPERL_GROUPED.par_id%TYPE,
        p_item_no           IN      GIPI_WITMPERL_GROUPED.item_no%TYPE
    )
    IS
        v_exists	NUMBER																				:=0;
        v_exists2	NUMBER																				:=0;
        v_exists3	NUMBER																				:=0; --for deleting purposes
        v_tsi_amt gipi_witmperl.tsi_amt%TYPE										:=0;
        v_prem_amt gipi_witmperl.prem_amt%TYPE									:=0;
        v_ann_tsi_amt gipi_witmperl.ann_tsi_amt%TYPE						:=0; --A.R.C. 08.17.2006
        v_ann_prem_amt gipi_witmperl.ann_prem_amt%TYPE					:=0; --A.R.C. 08.17.2006
        v_item_ann_tsi_amt gipi_witmperl.ann_tsi_amt%TYPE				:=0; --A.R.C. 08.17.2006
        v_item_ann_prem_amt gipi_witmperl.ann_prem_amt%TYPE			:=0; --A.R.C. 08.17.2006
        v2_ann_tsi_amt gipi_witmperl.ann_tsi_amt%TYPE						:=0; --gmi
        v2_ann_prem_amt gipi_witmperl.ann_prem_amt%TYPE					:=0; --gmi
        vg2_ann_tsi_amt gipi_witmperl.ann_tsi_amt%TYPE					:=0; --gmi
        vg2_ann_prem_amt gipi_witmperl.ann_prem_amt%TYPE				:=0; --gmi
        vg1_ann_tsi_amt gipi_witmperl.ann_tsi_amt%TYPE					:=0; --gmi
        vg1_ann_prem_amt gipi_witmperl.ann_prem_amt%TYPE				:=0; --gmi
        vtot_ann_tsi_amt gipi_witmperl.ann_tsi_amt%TYPE; 				 		 --gmi
        vtot_ann_prem_amt gipi_witmperl.ann_prem_amt%TYPE; 				 	 --gmi
        vtot_item_ann_tsi_amt gipi_witmperl.ann_tsi_amt%TYPE		:=0; --gmi
        vtot_item_ann_prem_amt gipi_witmperl.ann_prem_amt%TYPE	:=0; --gmi
        v_counter  NUMBER;
        v_policy_id gipi_polbasic.policy_id%TYPE;
    
        v_eff_date                  GIPI_WPOLBAS.eff_date%TYPE := TO_DATE(p_eff_date, 'mm-dd-yyyy');
    BEGIN
        --IF p_itmperil_exist = 'N' THEN
            FOR j IN (SELECT a.policy_id policy_id, ann_tsi_amt, ann_prem_amt
						   FROM gipi_polbasic a
						  WHERE a.line_cd     =  p_line_cd
						    AND a.iss_cd      =  p_iss_cd
						    AND a.subline_cd  =  p_subline_cd
						    AND a.issue_yy    =  p_issue_yy
						    AND a.pol_seq_no  =  p_pol_seq_no
						    AND a.renew_no    =  p_renew_no
						    AND a.pol_flag    IN ('1','2','3','X')
						    AND TRUNC(a.eff_date) <= TRUNC(v_eff_date)
						    AND NVL(a.endt_expiry_date,a.expiry_date) >= v_eff_date
						  ORDER BY endt_seq_no DESC)
            LOOP
                v_policy_id := j.policy_id;
		        EXIT;
		    END LOOP;
            
            
            FOR x IN (SELECT peril_cd
                        FROM gipi_witmperl
                       WHERE par_id  = p_par_id
                         AND item_no = p_item_no)
            LOOP
		        v_exists3 := 1;
			    FOR y IN (SELECT peril_cd
                            FROM gipi_witmperl_grouped
                           WHERE par_id 	= p_par_id
                             AND item_no  = p_item_no
                             AND peril_cd = x.peril_cd)
                LOOP
				    v_exists3 := 0;
			    END LOOP;
                
                IF v_exists3 = 1 THEN
                    DELETE FROM gipi_witmperl
                     WHERE par_id   = p_par_id
                       AND item_no  = p_item_no
                       AND peril_cd = x.peril_cd;
                END IF;
		    END LOOP;
            
            FOR j IN (SELECT SUM(tsi_amt) tsi_amt,SUM(prem_amt) prem_amt,a.peril_cd, item_no, b.peril_type peril_type
                        FROM gipi_witmperl_grouped a, GIIS_PERIL b
                       WHERE par_id = p_par_id
                         AND item_no = p_item_no
                         AND a.peril_cd = b.peril_cd
                         AND a.line_cd = b.line_cd
                       GROUP BY a.peril_cd, a.item_no,b.peril_type)
            LOOP
                vtot_ann_tsi_amt  := NULL;
				vtot_ann_prem_amt := NULL;
				vg1_ann_tsi_amt   := 0;
				vg1_ann_prem_amt  := 0;
				v2_ann_tsi_amt    := 0;
				v2_ann_prem_amt   := 0;				
				v_exists2 			  := 1;
			    v_ann_tsi_amt 		:= 0;
			    v_ann_prem_amt 		:= 0;
                
                FOR exsts IN (SELECT 1
                                FROM gipi_witmperl
                               WHERE par_id   = p_par_id
                                 AND item_no  = p_item_no
                                 AND peril_cd = j.peril_cd)
                LOOP			 	           
                    v_exists := 1;
                    EXIT;
			 	END LOOP;
                
                FOR g1 IN (SELECT NVL(ann_tsi_amt,0) ann_tsi_amt, NVL(ann_prem_amt,0) ann_prem_amt, grouped_item_no
					 				   FROM gipi_witmperl_grouped
					 				  WHERE par_id   = p_par_id
					 				    AND item_no  = p_item_no
					 				    AND peril_cd = j.peril_cd)
                LOOP
                    vg1_ann_tsi_amt  := vg1_ann_tsi_amt + g1.ann_tsi_amt;
					vg1_ann_prem_amt := vg1_ann_prem_amt + g1.ann_prem_amt;
			 		FOR g2 IN (SELECT NVL(ann_tsi_amt,0) ann_tsi_amt, NVL(ann_prem_amt,0) ann_prem_amt
						 				   FROM gipi_itmperil_grouped
						 				  WHERE policy_id       = v_policy_id
						 				    AND item_no         = p_item_no
						 				    AND grouped_item_no = g1.grouped_item_no
						 				    AND peril_cd        = j.peril_cd)
                    LOOP						 				    	
						vg1_ann_tsi_amt   := g1.ann_tsi_amt - g2.ann_tsi_amt;
						vg1_ann_prem_amt  := g1.ann_prem_amt - g2.ann_prem_amt;						
						vtot_ann_tsi_amt  := NVL(vtot_ann_tsi_amt,0) + vg1_ann_tsi_amt;
						vtot_ann_prem_amt := NVL(vtot_ann_prem_amt,0) + vg1_ann_prem_amt;
					END LOOP; 				    
			 	END LOOP;
                
                FOR g IN (SELECT NVL(ann_tsi_amt,0) ann_tsi_amt, NVL(ann_prem_amt,0) ann_prem_amt
                            FROM gipi_itmperil
                           WHERE policy_id = v_policy_id
                             AND item_no   = p_item_no
                             AND peril_cd  = j.peril_cd)
                LOOP
                    v2_ann_tsi_amt  := g.ann_tsi_amt;
                    v2_ann_prem_amt := g.ann_prem_amt;
			 	END LOOP;
                
                v_ann_tsi_amt  := v2_ann_tsi_amt + NVL(vtot_ann_tsi_amt,vg1_ann_tsi_amt);
				v_ann_prem_amt := v2_ann_prem_amt + NVL(vtot_ann_prem_amt,vg1_ann_prem_amt);
                
                IF v_exists = 1 THEN					
					UPDATE gipi_witmperl
					   SET tsi_amt  = NVL(j.tsi_amt,0),
					   	   prem_amt = NVL(j.prem_amt,0),
					   	   ann_tsi_amt  = NVL(v_ann_tsi_amt,0),
					   	   ann_prem_amt = NVL(v_ann_prem_amt,0)
					 WHERE par_id   = p_par_id
					   AND item_no  = p_item_no
					   AND line_cd  = p_line_cd
					   AND peril_cd = j.peril_cd;
					 v_exists := 0;
				ELSE
                    INSERT INTO gipi_witmperl(PAR_ID, ITEM_NO, LINE_CD, PERIL_CD,
                                             TSI_AMT, PREM_AMT, ANN_TSI_AMT, ANN_PREM_AMT)
                    VALUES (p_par_id, p_item_no, p_line_cd, j.peril_cd,
                           NVL(j.TSI_AMT,0), NVL(j.prem_amt,0), NVL(v_ann_tsi_amt,0), NVL(v_ann_prem_amt,0));
				END IF;
                
                IF j.peril_type = 'B' THEN
					v_tsi_amt 					  := NVL(j.tsi_amt,0) + v_tsi_amt;
					vtot_item_ann_tsi_amt := vtot_item_ann_tsi_amt + NVL(vtot_ann_tsi_amt,vg1_ann_tsi_amt); -- gmi 09/22/06
				END IF;
                
                v_prem_amt 						 := NVL(j.prem_amt,0) + v_prem_amt;
				vtot_item_ann_prem_amt := vtot_item_ann_prem_amt + NVL(vtot_ann_prem_amt,vg1_ann_prem_amt); -- gmi 09/22/06
            END LOOP;
            
            IF v_exists2 = 1 THEN
                v_item_ann_tsi_amt  := 0;
                v_item_ann_prem_amt := 0;
                
                FOR g IN (SELECT ann_tsi_amt, ann_prem_amt
                            FROM gipi_item
                           WHERE policy_id = v_policy_id
                             AND item_no   = p_item_no)
                LOOP
                    v_item_ann_tsi_amt  := g.ann_tsi_amt;
			 		v_item_ann_prem_amt := g.ann_prem_amt;
			 	END LOOP;
                
                /* :b480.tsi_amt 		 := v_tsi_amt;
                :b480.prem_amt 		 := v_prem_amt;
                :b480.ann_tsi_amt  := v_item_ann_tsi_amt + vtot_item_ann_tsi_amt;
                :b480.ann_prem_amt := v_item_ann_prem_amt + vtot_item_ann_prem_amt; */
                UPDATE GIPI_WITEM
                   SET tsi_amt = v_tsi_amt,
                       ann_tsi_amt = v_item_ann_tsi_amt + vtot_item_ann_tsi_amt,
                       prem_amt = v_prem_amt,
                       ann_prem_amt = v_item_ann_prem_amt + vtot_item_ann_prem_amt
                 WHERE par_id = p_par_id
                   AND item_no = p_item_no;
                    
                IF NVL(v_tsi_amt,0) <> 0 THEN
			        cr_bill_dist.get_tsi(p_par_id);
			    END IF;
            ELSE
                UPDATE GIPI_WITEM
                   SET tsi_amt = 0,
                       ann_tsi_amt = 0,
                       prem_amt = 0,
                       ann_prem_amt = 0
                 WHERE par_id = p_par_id
                   AND item_no = p_item_no;
                   
                IF NVL(v_tsi_amt,0) <> 0 THEN
			        cr_bill_dist.get_tsi(p_par_id);
			    END IF;
            END IF; 
        --END IF; -- p_itmperil_exist
    END;
    
    FUNCTION prepare_peril_rg(
        p_peril_list                VARCHAR2,
        p_peril_count               NUMBER
    )
      RETURN peril_rg_tab PIPELINED IS
        v_peril                     peril_rg_type;
        i NUMBER := 1;
    BEGIN
        WHILE i <= p_peril_count
        LOOP
            v_peril.peril_cd := SUBSTR(p_peril_list, INSTR(p_peril_list, ',', 1, i)+1, (INSTR(p_peril_list, ',', 1, i+1) - INSTR(p_peril_list, ',', 1, i))-1);
            v_peril.tsi_amt := SUBSTR(p_peril_list, INSTR(p_peril_list, ',', 1, i+1)+1, (INSTR(p_peril_list, ',', 1, i+2) - INSTR(p_peril_list, ',', 1, i+1))-1);
            v_peril.peril_type := SUBSTR(p_peril_list, INSTR(p_peril_list, ',', 1, i+2)+1, (INSTR(p_peril_list, ',', 1, i+3) - INSTR(p_peril_list, ',', 1, i+2))-1);
            v_peril.basc_perl_cd := SUBSTR(p_peril_list, INSTR(p_peril_list, ',', 1, i+3)+1, (INSTR(p_peril_list, ',', 1, i+4) - INSTR(p_peril_list, ',', 1, i+3))-1);
            v_peril.tsi_amt1 := SUBSTR(p_peril_list, INSTR(p_peril_list, ',', 1, i+4)+1, (INSTR(p_peril_list, ',', 1, i+5) - INSTR(p_peril_list, ',', 1, i+4))-1);
            PIPE ROW(v_peril);
            i := i + 5;
        END LOOP;
    END;
    
	/**
		added 10.4.2012
		Checks leap year every year
		- irwin
	**/
	function check_duration(p_date1 date, p_date2 date) return number
	
	is
		 v_no_of_days  NUmBER := 0;
		
	begin
			FOR x IN to_number(to_char(p_date1,'YYYY'))..to_number(to_char(p_date2,'YYYY'))
	LOOP
		IF TO_NUMBER(to_char(LAST_DAY(to_date('01-FEB-'||to_char(x),'DD-MON-RRRR')),'DD'))= 29 
        AND p_date1 <= LAST_DAY(to_date('01-FEB-'||to_char(x),'DD-MON-RRRR'))
      AND p_date2 >= LAST_DAY(to_date('01-FEB-'||to_char(x),'DD-MON-RRRR')) THEN
     RETURN(366);
        ELSE
             v_no_of_days := 365;
        END IF;
    END LOOP;
    RETURN(v_no_of_days);
        
    end;
    
END;
/


