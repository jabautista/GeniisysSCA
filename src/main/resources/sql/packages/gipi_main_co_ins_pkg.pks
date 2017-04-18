CREATE OR REPLACE PACKAGE CPI.Gipi_Main_Co_Ins_Pkg
AS
    TYPE gipi_main_co_ins_type IS RECORD (
        par_id          GIPI_MAIN_CO_INS.par_id%TYPE,
        prem_amt        GIPI_MAIN_CO_INS.prem_amt%TYPE,
        tsi_amt         GIPI_MAIN_CO_INS.tsi_amt%TYPE,
        policy_id       GIPI_MAIN_CO_INS.policy_id%TYPE
    );
    
    TYPE gipi_main_co_ins_tab IS TABLE OF gipi_main_co_ins_type; 
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.10.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains insert / update / delete procedure of table GIPI_MAIN_CO_INS
	*/
	PROCEDURE del_gipi_main_co_ins (p_par_id		GIPI_MAIN_CO_INS.par_id%TYPE);
    
    FUNCTION get_gipi_main_co_ins (p_par_id		GIPI_MAIN_CO_INS.par_id%TYPE)
        RETURN gipi_main_co_ins_tab PIPELINED;
        
    PROCEDURE save_gipi_main_co_ins (
        p_par_id    GIPI_MAIN_CO_INS.par_id%TYPE,
        p_prem_amt  GIPI_MAIN_CO_INS.prem_amt%TYPE,
        p_tsi_amt   GIPI_MAIN_CO_INS.tsi_amt%TYPE,
        p_user_id   GIPI_MAIN_CO_INS.user_id%TYPE
    );
    
    
    TYPE gipi_main_co_ins_type2 IS RECORD (
        par_id          GIPI_MAIN_CO_INS.par_id%TYPE,
        prem_amt        GIPI_MAIN_CO_INS.prem_amt%TYPE,
        tsi_amt         GIPI_MAIN_CO_INS.tsi_amt%TYPE,
        policy_id       GIPI_MAIN_CO_INS.policy_id%TYPE
    );
    
    TYPE gipi_main_co_ins_tab2 IS TABLE OF gipi_main_co_ins_type2;
    
    FUNCTION get_policy_main_co_ins (p_policy_id		GIPI_MAIN_CO_INS.policy_id%TYPE)
        RETURN gipi_main_co_ins_tab2 PIPELINED;
        
    
    FUNCTION limit_entry_gipis154(
        p_global_pack_par_id    GIPI_PARLIST.pack_par_id%type,
        p_par_id                gipi_main_co_ins.PAR_ID%type
    ) RETURN VARCHAR2;
    
    
END Gipi_Main_Co_Ins_Pkg;
/


