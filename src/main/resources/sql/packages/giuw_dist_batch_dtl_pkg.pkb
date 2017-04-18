CREATE OR REPLACE PACKAGE BODY CPI.GIUW_DIST_BATCH_DTL_PKG IS

/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 15, 2011
**  Reference By : GIUWS015 - Batch Distribution
**  Description  : Retrieves details from table GIUW_DIST_BATCH_DTL
**                with the given batch_id and line_cd
*/

    FUNCTION get_giuw_dist_batch_dtl(p_batch_id  IN    GIUW_DIST_BATCH_DTL.batch_id%TYPE,
                                     p_line_cd   IN    GIUW_POL_DIST_POLBASIC_V.line_cd%TYPE)

    RETURN giuw_dist_batch_dtl_tab PIPELINED IS

    v_batch_dtl         giuw_dist_batch_dtl_type;

    BEGIN
        FOR i IN (SELECT a.batch_id,    a.line_cd,      a.share_cd,
                         a.dist_spct,   a.cpi_rec_no,   a.cpi_branch_cd,
                         a.arc_ext_data
                  FROM GIUW_DIST_BATCH_DTL a
                  WHERE a.batch_id  = p_batch_id
                    AND a.line_cd   = NVL(p_line_cd, a.line_cd))
        LOOP
            v_batch_dtl.batch_id        := i.batch_id;
            v_batch_dtl.line_cd         := i.line_cd;
            v_batch_dtl.share_cd        := i.share_cd;
            v_batch_dtl.dist_spct       := i.dist_spct;
            v_batch_dtl.cpi_rec_no      := i.cpi_rec_no;
            v_batch_dtl.cpi_branch_cd   := i.cpi_branch_cd;
            v_batch_dtl.arc_ext_data    := i.arc_ext_data;

            FOR dsp IN (SELECT a160.trty_cd, a160.trty_name, a160.trty_sw
                           FROM GIIS_DIST_SHARE a160
                        WHERE a160.line_cd = i.line_cd
                          AND a160.share_cd = i.share_cd)
            LOOP
                v_batch_dtl.dsp_trty_cd     := dsp.trty_cd;
                v_batch_dtl.dsp_trty_name   := dsp.trty_name;
                v_batch_dtl.dsp_trty_sw     := dsp.trty_sw;
            END LOOP;

            PIPE ROW(v_batch_dtl);

        END LOOP;
    END;

/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 18, 2011
**  Reference By : GIUWS015 - Batch Distribution
**  Description  : Insert/Update record  on GIUW_DIST_BATCH_DTL table
*/

    PROCEDURE set_giuw_dist_batch_dtl(p_batch_id    IN    GIUW_DIST_BATCH_DTL.batch_id%TYPE,
                                      p_line_cd     IN    GIUW_DIST_BATCH_DTL.line_cd%TYPE,
                                      p_share_cd    IN    GIUW_DIST_BATCH_DTL.share_cd%TYPE,
                                      p_dist_spct   IN    GIUW_DIST_BATCH_DTL.dist_spct%TYPE)
    AS

    BEGIN
        MERGE INTO GIUW_DIST_BATCH_DTL
        USING DUAL
        ON (batch_id = p_batch_id AND
            line_cd = p_line_cd AND
            share_cd = p_share_cd)
        WHEN NOT MATCHED THEN
            INSERT(batch_id, line_cd,
                   share_cd, dist_spct)
            VALUES(p_batch_id, p_line_cd,
                   p_share_cd, p_dist_spct)
        WHEN MATCHED THEN
            UPDATE
            SET dist_spct = p_dist_spct;

    END set_giuw_dist_batch_dtl;

/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 18, 2011
**  Reference By : GIUWS015 - Batch Distribution
**  Description  : Delete record from GIUW_DIST_BATCH_DTL table
*/

    PROCEDURE del_giuw_dist_batch_dtl(p_batch_id    IN  GIUW_DIST_BATCH_DTL.batch_id%TYPE,
                                      p_line_cd     IN  GIUW_DIST_BATCH_DTL.line_cd%TYPE,
                                      p_share_cd    IN  GIUW_DIST_BATCH_DTL.share_cd%TYPE)
    AS

    BEGIN
        DELETE FROM GIUW_DIST_BATCH_DTL
        WHERE batch_id = p_batch_id
          AND line_cd = p_line_cd
          AND share_cd = p_share_cd;
    END;

/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 24, 2011
**  Reference By : GIUWS015 - Batch Distribution
**  Description  : To know if there is facultative share given to the distribution
*/

    PROCEDURE CHECK_RI_SHARE (p_batch_id    IN      GIUW_DIST_BATCH_DTL.batch_id%TYPE,
                              p_facul_sw    IN OUT  VARCHAR2) IS

        v_facul_sw      VARCHAR2(1) := 'N';

        CURSOR RI IS  SELECT *
                        FROM GIUW_DIST_BATCH_DTL C030
                       WHERE C030.share_cd    = 999
                         AND C030.batch_id    = p_batch_id;

    BEGIN

        FOR RI_REC IN RI
        LOOP
            v_facul_sw := 'Y';
            EXIT;
        END LOOP;

        p_facul_sw := v_facul_sw;

    END;

END GIUW_DIST_BATCH_DTL_PKG;
/


