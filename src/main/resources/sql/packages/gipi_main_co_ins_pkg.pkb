CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Main_Co_Ins_Pkg
AS
   
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.10.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains insert / update / delete procedure of table GIPI_MAIN_CO_INS
	*/
	PROCEDURE del_gipi_main_co_ins (p_par_id		GIPI_MAIN_CO_INS.par_id%TYPE)
	IS
	BEGIN
		DELETE 
		  FROM GIPI_MAIN_CO_INS
		 WHERE par_id = p_par_id;
	END del_gipi_main_co_ins;
	
    /*
	**  Created by		: d.alcantara
	**  Date Created 	: 04.20.2011
	**  Reference By 	: (GIPIS153 - Enter Co Insurer)
	*/
    FUNCTION get_gipi_main_co_ins (p_par_id		GIPI_MAIN_CO_INS.par_id%TYPE)
        RETURN gipi_main_co_ins_tab PIPELINED
    IS
        v_main_co       gipi_main_co_ins_type;
    BEGIN
        FOR i IN (
            SELECT par_id, prem_amt, tsi_amt
                FROM gipi_main_co_ins
            WHERE par_id = p_par_id
        ) LOOP
          v_main_co.par_id      :=  i.par_id;
          v_main_co.prem_amt    := i.prem_amt;
          v_main_co.tsi_amt     := i.tsi_amt;       
          PIPE ROW(v_main_co);
        END LOOP;
    END get_gipi_main_co_ins;
    
    /*
	**  Created by		: d.alcantara
	**  Date Created 	: 05.02.2011
	**  Reference By 	: (GIPIS153 - Enter Co Insurer)
	*/
    PROCEDURE save_gipi_main_co_ins (
        p_par_id    GIPI_MAIN_CO_INS.par_id%TYPE,
        p_prem_amt  GIPI_MAIN_CO_INS.prem_amt%TYPE,
        p_tsi_amt   GIPI_MAIN_CO_INS.tsi_amt%TYPE,
        p_user_id   GIPI_MAIN_CO_INS.user_id%TYPE
    ) IS
    BEGIN
        MERGE INTO GIPI_MAIN_CO_INS
        USING DUAL ON (par_id = p_par_id)
            WHEN NOT MATCHED THEN
                INSERT(par_id, prem_amt, tsi_amt, user_id, last_update)
                VALUES(p_par_id, p_prem_amt, p_tsi_amt, NVL(p_user_id, USER), SYSDATE)
            WHEN MATCHED THEN
                UPDATE SET prem_amt = p_prem_amt,
                           tsi_amt  = p_tsi_amt,
                           user_id  = p_user_id,
                           last_update = SYSDATE;
    END save_gipi_main_co_ins;
    
    
    
    /*
    **  Created by      :Moses Calma
    **  Date Created    :05.16.2011
    **  Reference By    :(GIPIS 100)
    */
    FUNCTION get_policy_main_co_ins (p_policy_id gipi_main_co_ins.policy_id%TYPE)
       RETURN gipi_main_co_ins_tab2 PIPELINED
    IS
       v_main_co_ins   gipi_main_co_ins_type2;
    BEGIN
       FOR i IN (SELECT policy_id, par_id, prem_amt, tsi_amt
                   FROM gipi_main_co_ins
                  WHERE policy_id = p_policy_id)
       LOOP
          
          v_main_co_ins.par_id := i.par_id;
          v_main_co_ins.prem_amt := i.prem_amt;
          v_main_co_ins.tsi_amt := i.tsi_amt;
          v_main_co_ins.policy_id := i.policy_id;

          
          PIPE ROW (v_main_co_ins);
       END LOOP;
       
    
    
    END get_policy_main_co_ins;
    
    /** Created By:     Shan Bati 
     ** Date Created:   10.21.2013 
     ** Reference By:   GIPIS154 - Lead Policy Information
     ** Description:    To limit entry  if Co-Insurer Information is missing 
     **/
     
    FUNCTION limit_entry_gipis154(
        p_global_pack_par_id    GIPI_PARLIST.pack_par_id%type,
        p_par_id                gipi_main_co_ins.PAR_ID%type
    ) RETURN VARCHAR2
    AS
        v_call_module   VARCHAR2(10);
        v_exist         varchar2(1) := 'N';
    BEGIN
        IF p_global_pack_par_id IS NOT NULL THEN
            FOR c1 IN (SELECT par_id 
                         FROM gipi_parlist
                        WHERE par_status NOT IN (98,99)
                          AND pack_par_id = p_global_pack_par_id)
            LOOP              
                --:GLOBAL.CG$B240_PAR_ID := c1.par_id;
                FOR exist IN (SELECT 'a'
                                FROM gipi_main_co_ins
                               WHERE par_id = /*:global.cg$b240_par_id*/ c1.par_id)
                LOOP
                   v_exist := 'Y';
                END LOOP;
                
                IF v_exist = 'N' THEN
                   /*MSG_ALERT('Please enter your CO-INSURER information for this PAR.','I',FALSE);
                   NEW_FORM('GIPIS153');*/
                   v_call_module := 'GIPIS153';
                   
                /*ELSIF v_exist = 'Y' THEN
                     --POPULATE_ORIG_TAB; commented and transferred to gipis153 gmi21
                     COMMIT;
                     clear_message;
                     SET_MENU_ITEM_PROPERTY('EDIT_PAR_MENU.POST_PAR', ENABLED, PROPERTY_TRUE);*/
                END IF;
            END LOOP;
        ELSE	
            FOR exist IN (SELECT 'a'
                            FROM gipi_main_co_ins
                           WHERE par_id = p_par_id)
            LOOP
               v_exist := 'Y';
            END LOOP;
            
            IF v_exist = 'N' THEN
               /*MSG_ALERT('Please enter your CO-INSURER information for this PAR.','I',FALSE);
               NEW_FORM('GIPIS153');*/
                v_call_module := 'GIPIS153';
                
            /*ELSIF v_exist = 'Y' THEN
                 --POPULATE_ORIG_TAB; commented and transferred to gipis153 gmi21
                 COMMIT;
                 clear_message;    	 
                 SET_MENU_ITEM_PROPERTY('EDIT_PAR_MENU.POST_PAR', ENABLED, PROPERTY_TRUE);*/
            END IF;
        END IF;
        
        RETURN v_call_module;
        
    END limit_entry_gipis154;
    
END Gipi_Main_Co_Ins_Pkg;
/


