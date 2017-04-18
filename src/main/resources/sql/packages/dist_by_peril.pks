CREATE OR REPLACE PACKAGE CPI.dist_by_peril AS
/* Author: Udel
** UW-SPECS-2011-00040
** (Special Distribution)
*/
v_dist_no       giuw_pol_dist.dist_no%TYPE;
v_line_cd       giis_line.line_cd%TYPE;
PROCEDURE create_wdist(p_line_cd        IN  VARCHAR2,
                       p_dist_no        IN  VARCHAR2);
PROCEDURE upd_witemperilds_dtl;
PROCEDURE upd_witemds_dtl;
PROCEDURE upd_wpolicyds_dtl;
PROCEDURE recompute_tsi(p_dist_no NUMBER);
END dist_by_peril;
/


