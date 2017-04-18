CREATE OR REPLACE PACKAGE CPI.GIRI_WBINDER_PKG
AS	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.17.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/

	PROCEDURE del_giri_wbinder(p_pre_binder_id	GIRI_WBINDER.pre_binder_id%TYPE);
    
    PROCEDURE create_wbinder_giris002 (
         p_line_cd         IN     giri_wfrps_ri.line_cd%TYPE,
      p_frps_yy         IN     giri_wfrps_ri.frps_yy%TYPE,
      p_frps_seq_no     IN     giri_wfrps_ri.frps_seq_no%TYPE,
      p_user_id         IN     giis_users.user_id%TYPE,
      p_ri_prem_vat_o      OUT VARCHAR2,
      p_subline_cd      IN    varchar2,
      p_iss_cd          IN   varchar2,
      p_par_yy          IN    number,
      p_par_seq_no      IN    number,
      p_pol_seq_no      IN     number,
      p_renew_no        IN     number,
      p_issue_yy        IN     number,
      P_ri_PREM_VAT_NEW    IN     NUMBER, status varchar2
    );
    
    FUNCTION check_giri_wbinder_exist(p_pre_binder_id     giri_wbinder.pre_binder_id%TYPE)
    RETURN NUMBER;
    
    PROCEDURE copy_binder(
        p_line_cd       IN giri_frps_ri.line_cd%TYPE,
        p_frps_yy       IN giri_frps_ri.frps_yy%TYPE,
        p_frps_seq_no   IN giri_frps_ri.frps_seq_no%TYPE,
        p_fnl_binder_id IN giri_frps_ri.fnl_binder_id%TYPE,
        p_dist_no       IN giuw_pol_dist.dist_no%TYPE
    );
     
END GIRI_WBINDER_PKG;
/


