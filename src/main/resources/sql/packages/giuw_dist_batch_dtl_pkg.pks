CREATE OR REPLACE PACKAGE CPI.GIUW_DIST_BATCH_DTL_PKG IS

    TYPE giuw_dist_batch_dtl_type IS RECORD(
        batch_id        GIUW_DIST_BATCH_DTL.batch_id%TYPE,
        line_cd         GIUW_DIST_BATCH_DTL.line_cd%TYPE,
        share_cd        GIUW_DIST_BATCH_DTL.share_cd%TYPE,
        dist_spct       GIUW_DIST_BATCH_DTL.dist_spct%TYPE,
        cpi_rec_no      GIUW_DIST_BATCH_DTL.cpi_rec_no%TYPE,
        cpi_branch_cd   GIUW_DIST_BATCH_DTL.cpi_branch_cd%TYPE,
        arc_ext_data    GIUW_DIST_BATCH_DTL.arc_ext_data%TYPE,
        dsp_trty_cd     GIIS_DIST_SHARE.trty_cd%TYPE,
        dsp_trty_name   GIIS_DIST_SHARE.trty_name%TYPE,
        dsp_trty_sw     GIIS_DIST_SHARE.trty_sw%TYPE
    );
    
    TYPE giuw_dist_batch_dtl_tab IS TABLE OF giuw_dist_batch_dtl_type;
    
    FUNCTION get_giuw_dist_batch_dtl(p_batch_id  IN    GIUW_DIST_BATCH_DTL.batch_id%TYPE,
                                     p_line_cd   IN    GIUW_POL_DIST_POLBASIC_V.line_cd%TYPE)
    RETURN giuw_dist_batch_dtl_tab PIPELINED;
    
    PROCEDURE set_giuw_dist_batch_dtl(p_batch_id    IN    GIUW_DIST_BATCH_DTL.batch_id%TYPE,
                                      p_line_cd     IN    GIUW_DIST_BATCH_DTL.line_cd%TYPE,
                                      p_share_cd    IN    GIUW_DIST_BATCH_DTL.share_cd%TYPE,
                                      p_dist_spct   IN    GIUW_DIST_BATCH_DTL.dist_spct%TYPE);
    
    PROCEDURE del_giuw_dist_batch_dtl(p_batch_id    IN  GIUW_DIST_BATCH_DTL.batch_id%TYPE,
                                      p_line_cd     IN  GIUW_DIST_BATCH_DTL.line_cd%TYPE,
                                      p_share_cd    IN  GIUW_DIST_BATCH_DTL.share_cd%TYPE);
                                      
    PROCEDURE CHECK_RI_SHARE (p_batch_id    IN      GIUW_DIST_BATCH_DTL.batch_id%TYPE,
                              p_facul_sw    IN OUT  VARCHAR2);

END GIUW_DIST_BATCH_DTL_PKG;
/


