CREATE OR REPLACE PACKAGE CPI.GIUW_DIST_BATCH_PKG AS

    TYPE giuw_dist_batch_type IS RECORD(
        batch_id            GIUW_DIST_BATCH.batch_id%TYPE,
        batch_date          VARCHAR2(20),
        batch_flag          GIUW_DIST_BATCH.batch_flag%TYPE,
        batch_qty           GIUW_DIST_BATCH.batch_qty%TYPE,
        cpi_rec_no          GIUW_DIST_BATCH.cpi_rec_no%TYPE,
        cpi_branch_cd       GIUW_DIST_BATCH.cpi_branch_cd%TYPE,
        arc_ext_data        GIUW_DIST_BATCH.arc_ext_data%TYPE,
        line_cd             GIUW_POL_DIST_POLBASIC_V.line_cd%TYPE
    );
    
    TYPE giuw_dist_batch_tab IS TABLE OF giuw_dist_batch_type;
    
    FUNCTION get_giuw_dist_batch(p_batch_id   IN   GIUW_DIST_BATCH.batch_id%TYPE,
                                 p_line_cd    IN   GIUW_POL_DIST_POLBASIC_V.line_cd%TYPE)
    RETURN giuw_dist_batch_tab PIPELINED;
    
    PROCEDURE insert_giuw_dist_batch (p_batch_id    IN      GIUW_DIST_BATCH.batch_id%TYPE,
                                      p_batch_flag  IN      GIUW_DIST_BATCH.batch_flag%TYPE,
                                      p_batch_qty   IN      GIUW_DIST_BATCH.batch_qty%TYPE);
                                   
    PROCEDURE set_giuw_dist_batch (p_batch_id    IN      GIUW_DIST_BATCH.batch_id%TYPE,
                                   p_batch_flag  IN      GIUW_DIST_BATCH.batch_flag%TYPE,
                                   p_batch_qty   IN      GIUW_DIST_BATCH.batch_qty%TYPE);
     
END GIUW_DIST_BATCH_PKG;
/


