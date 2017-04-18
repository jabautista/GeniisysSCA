CREATE OR REPLACE PACKAGE BODY CPI.GIUW_PERILDS_DTL_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_giuw_perilds_dtl (p_dist_no 	GIUW_PERILDS_DTL.dist_no%TYPE)
	IS
	BEGIN
		DELETE GIUW_PERILDS_DTL
		 WHERE dist_no  =  p_dist_no;
	END del_giuw_perilds_dtl;

    FUNCTION get_giuw_perilds_dtl (
        p_dist_no       IN giuw_perilds_dtl.dist_no%TYPE,
        p_dist_seq_no   IN giuw_perilds_dtl.dist_seq_no%TYPE,
        p_line_cd       IN giuw_perilds_dtl.line_cd%TYPE,
        p_peril_cd      IN giuw_perilds_dtl.peril_cd%TYPE)
    RETURN giuw_perilds_dtl_tab PIPELINED
    IS
        v_perilds_dtl giuw_perilds_dtl_type;
    BEGIN
        FOR i IN (
            SELECT a.dist_no,           a.dist_seq_no,      a.line_cd,     a.peril_cd,
                   a.share_cd,          a.dist_spct,        a.dist_tsi,    a.dist_prem,
                   a.ann_dist_spct,     a.ann_dist_tsi,     a.dist_grp,    a.dist_spct1,
                   a.dist_comm_amt,     a.cpi_rec_no,       a.cpi_branch_cd,
                   a.arc_ext_data,      b.trty_name
              FROM giuw_perilds_dtl a,
                   giis_dist_share b
             WHERE a.dist_no = p_dist_no
               AND a.dist_seq_no = p_dist_seq_no
               AND a.line_cd = p_line_cd
               AND a.peril_cd = p_peril_cd
               AND a.line_cd = b.line_cd
               AND a.share_cd = b.share_cd(+))
        LOOP
            v_perilds_dtl.dist_no               := i.dist_no;
            v_perilds_dtl.dist_seq_no           := i.dist_seq_no;
            v_perilds_dtl.line_cd               := i.line_cd;
            v_perilds_dtl.peril_cd              := i.peril_cd;
            v_perilds_dtl.share_cd              := i.share_cd;
            v_perilds_dtl.dist_spct             := i.dist_spct;
            v_perilds_dtl.dist_tsi              := i.dist_tsi;
            v_perilds_dtl.dist_prem             := i.dist_prem;
            v_perilds_dtl.ann_dist_spct         := i.ann_dist_spct;
            v_perilds_dtl.ann_dist_tsi          := i.ann_dist_tsi;
            v_perilds_dtl.dist_grp              := i.dist_grp;
            v_perilds_dtl.dist_spct1            := i.dist_spct1;
            v_perilds_dtl.dist_comm_amt         := i.dist_comm_amt;
            v_perilds_dtl.cpi_rec_no            := i.cpi_rec_no;
            v_perilds_dtl.cpi_branch_cd         := i.cpi_branch_cd;
            v_perilds_dtl.arc_ext_data          := i.arc_ext_data;
            v_perilds_dtl.trty_name             := i.trty_name;

            PIPE ROW(v_perilds_dtl);
        END LOOP;

        RETURN;
    END get_giuw_perilds_dtl;

END GIUW_PERILDS_DTL_PKG;
/


