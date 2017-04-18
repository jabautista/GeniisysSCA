CREATE OR REPLACE PACKAGE BODY CPI.GIUW_DIST_BATCH_PKG IS

/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 15, 2011
**  Reference By : GIUWS015 - Batch Distribution
**  Description  : Retrieves details from table GIUW_DIST_BATCH with the given batch_id
*/

FUNCTION get_giuw_dist_batch(p_batch_id    IN   GIUW_DIST_BATCH.batch_id%TYPE,
                             p_line_cd     IN   GIUW_POL_DIST_POLBASIC_V.line_cd%TYPE)
RETURN giuw_dist_batch_tab PIPELINED IS

v_batch         giuw_dist_batch_type;

BEGIN
    FOR i IN (SELECT a.batch_id,  TO_CHAR(a.batch_date, 'MM-DD-YYYY') batch_date,
                     a.batch_flag, a.batch_qty, a.cpi_rec_no,
                     a.cpi_branch_cd, a.arc_ext_data
              FROM GIUW_DIST_BATCH a
              WHERE a.batch_id = p_batch_id)
    LOOP
        v_batch.batch_id        := i.batch_id;
        v_batch.batch_date      := i.batch_date;
        v_batch.batch_flag      := i.batch_flag;
        v_batch.batch_qty       := i.batch_qty;
        v_batch.cpi_rec_no      := i.cpi_rec_no;
        v_batch.cpi_branch_cd   := i.cpi_branch_cd;
        v_batch.arc_ext_data    := i.arc_ext_data;
        v_batch.line_cd         := p_line_cd;
        PIPE ROW(v_batch);
        RETURN;
    END LOOP;
END;

/*
**  Created by   : Veronica V. Raymundo
**  Date Created : August 19, 2011
**  Reference By : GIUWS015 - Batch Distribution
**  Description  : Inserts record to GIUW_DIST_BATCH table
*/

PROCEDURE insert_giuw_dist_batch (p_batch_id    IN      GIUW_DIST_BATCH.batch_id%TYPE,
                                  p_batch_flag  IN      GIUW_DIST_BATCH.batch_flag%TYPE,
                                  p_batch_qty   IN      GIUW_DIST_BATCH.batch_qty%TYPE)

IS

BEGIN
    INSERT INTO GIUW_DIST_BATCH
        (batch_id, batch_date, batch_flag, batch_qty)
    VALUES
        (p_batch_id, SYSDATE, p_batch_flag, p_batch_qty);

END insert_giuw_dist_batch;

/*
**  Created by   : Veronica V. Raymundo
**  Date Created : September 1, 2011
**  Reference By : GIUWS015 - Batch Distribution
**  Description  : Updates/Inserts record on GIUW_DIST_BATCH table
*/

PROCEDURE set_giuw_dist_batch (p_batch_id    IN      GIUW_DIST_BATCH.batch_id%TYPE,
                               p_batch_flag  IN      GIUW_DIST_BATCH.batch_flag%TYPE,
                               p_batch_qty   IN      GIUW_DIST_BATCH.batch_qty%TYPE)

IS

BEGIN
    MERGE INTO GIUW_DIST_BATCH
    USING DUAL ON (batch_id = p_batch_id)

    WHEN NOT MATCHED THEN
        INSERT
            (batch_id, batch_date, batch_flag, batch_qty)
        VALUES
            (p_batch_id, SYSDATE, p_batch_flag, p_batch_qty)
    WHEN MATCHED THEN
        UPDATE
        SET batch_flag = p_batch_flag,
            batch_qty = p_batch_qty,
            batch_date = SYSDATE
    ;

END set_giuw_dist_batch;

END GIUW_DIST_BATCH_PKG;
/


