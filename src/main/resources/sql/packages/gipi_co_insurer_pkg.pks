CREATE OR REPLACE PACKAGE CPI.Gipi_Co_Insurer_Pkg
AS
    TYPE gipi_co_insurer_type IS RECORD (
        par_id          GIPI_CO_INSURER.par_id%TYPE,
        co_ri_cd        GIPI_CO_INSURER.co_ri_cd%TYPE,
        co_ri_shr_pct   GIPI_CO_INSURER.co_ri_shr_pct%TYPE,
        co_ri_prem_amt  GIPI_CO_INSURER.co_ri_prem_amt%TYPE,
        co_ri_tsi_amt   GIPI_CO_INSURER.co_ri_tsi_amt%TYPE,
        policy_id       GIPI_CO_INSURER.policy_id%TYPE,
        ri_sname        GIIS_REINSURER.ri_sname%TYPE,
        ri_name         GIIS_REINSURER.ri_name%TYPE,
        is_default      VARCHAR2(1)
    );
    
    TYPE gipi_co_insurer_tab IS TABLE OF gipi_co_insurer_type;
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.10.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains insert / update / delete procedure of table GIPI_CO_INSURER_PKG
	*/
	PROCEDURE del_gipi_co_insurer (p_par_id		GIPI_CO_INSURER.par_id%TYPE);
    
    FUNCTION get_gipi_co_insurer (p_par_id  GIPI_CO_INSURER.par_id%TYPE)
        RETURN gipi_co_insurer_tab PIPELINED;
    
    PROCEDURE get_co_ins_shr_pct(p_par_id	IN	GIPI_CO_INSURER.par_id%TYPE,
							     p_sve_rate OUT	GIPI_CO_INSURER.co_ri_shr_pct%TYPE,
							     p_rate	 	OUT	VARCHAR2);
                                
    FUNCTION get_default_co_insurers(p_policy_id GIPI_CO_INSURER.policy_id%TYPE)
        RETURN gipi_co_insurer_tab PIPELINED;
        
    PROCEDURE del_gipi_co_insurer1(
        p_par_id    GIPI_CO_INSURER.par_id%TYPE,
        p_co_ri_cd  GIPI_CO_INSURER.co_ri_cd%TYPE
    );
    
    PROCEDURE set_gipi_co_insurer (
        p_par_id    GIPI_CO_INSURER.par_id%TYPE,
        p_co_ri_cd  GIPI_CO_INSURER.co_ri_cd%TYPE,
        p_co_ri_prem_amt    GIPI_CO_INSURER.co_ri_prem_amt%TYPE,
        p_co_ri_tsi_amt     GIPI_CO_INSURER.co_ri_tsi_amt%TYPE,
        p_co_ri_shr_pct     GIPI_CO_INSURER.co_ri_shr_pct%TYPE,
        p_user_id           GIPI_CO_INSURER.user_id%TYPE
    );
    
    
    TYPE co_insurer_type IS RECORD (
        
        policy_id       gipi_co_insurer.policy_id%TYPE,
        par_id          gipi_co_insurer.par_id%TYPE,
        co_ri_cd        gipi_co_insurer.co_ri_cd%TYPE,
        co_ri_shr_pct   gipi_co_insurer.co_ri_shr_pct%TYPE,
        co_ri_prem_amt  gipi_co_insurer.co_ri_prem_amt%TYPE,
        co_ri_tsi_amt   gipi_co_insurer.co_ri_tsi_amt%TYPE,
        ri_sname        giis_reinsurer.ri_sname%TYPE
    );
    
    TYPE co_insurer_tab IS TABLE OF co_insurer_type;
    
   FUNCTION get_co_insurers (p_policy_id		gipi_co_insurer.policy_id%TYPE)
        RETURN co_insurer_tab PIPELINED;  
        
   FUNCTION limit_entry(
        p_par_id        IN  gipi_co_insurer.par_id%TYPE
   ) RETURN VARCHAR2;
   
   PROCEDURE post_forms_commit_gipis153(
        p_par_id        IN  gipi_co_insurer.par_id%TYPE,
        p_tsi_amt       IN  gipi_main_co_ins.tsi_amt%TYPE,
        p_prem_amt      IN  gipi_main_co_ins.prem_amt%TYPE,
        p_co_ins_sw     OUT gipi_wpolbas.co_insurance_sw%TYPE
   );
   
   PROCEDURE populate_itmperil_gipis153(
        p_par_id        IN  gipi_co_insurer.par_id%TYPE
   );
   
   PROCEDURE populate_orig_tab (
        p_par_id        IN  gipi_co_insurer.par_id%TYPE 
   );
   
   PROCEDURE process_default_insurer (
        p_par_id        IN  gipi_co_insurer.par_id%TYPE 
   );
   
   PROCEDURE process_default_lead (
        p_par_id        IN  gipi_co_insurer.par_id%TYPE 
   );
   
   PROCEDURE del_all_related_co_ins_recs(
      p_par_id gipi_co_insurer.par_id%TYPE
   );
END Gipi_Co_Insurer_Pkg;
/


