CREATE OR REPLACE PACKAGE BODY CPI.GIISS180_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   12.11.2013
     ** Referenced By:  GIISS180 - Initial/General Information Maintenance
     **/
    
    FUNCTION get_rec_list
        RETURN rec_tab PIPELINED
    AS
        rec         rec_type;
    BEGIN
        FOR i IN (SELECT *
                    FROM GIIS_GENIN_INFO)        
        LOOP
            rec.genin_info_cd       := i.genin_info_cd;
            rec.genin_info_title    := i.genin_info_title;
            rec.gen_info01          := i.gen_info01;
            rec.gen_info02          := i.gen_info02;
            rec.gen_info03          := i.gen_info03;
            rec.gen_info04          := i.gen_info04;
            rec.gen_info05          := i.gen_info05;
            rec.gen_info06          := i.gen_info06;
            rec.gen_info07          := i.gen_info07;
            rec.gen_info08          := i.gen_info08;
            rec.gen_info09          := i.gen_info09;
            rec.gen_info10          := i.gen_info10;
            rec.gen_info11          := i.gen_info11;
            rec.gen_info12          := i.gen_info12;
            rec.gen_info13          := i.gen_info13;
            rec.gen_info14          := i.gen_info14;
            rec.gen_info15          := i.gen_info15;
            rec.gen_info16          := i.gen_info16;
            rec.gen_info17          := i.gen_info17;
            rec.initial_info01      := i.initial_info01;
            rec.initial_info02      := i.initial_info02;
            rec.initial_info03      := i.initial_info03;
            rec.initial_info04      := i.initial_info04;
            rec.initial_info05      := i.initial_info05;
            rec.initial_info06      := i.initial_info06;
            rec.initial_info07      := i.initial_info07;
            rec.initial_info08      := i.initial_info08;
            rec.initial_info09      := i.initial_info09;
            rec.initial_info10      := i.initial_info10;
            rec.initial_info11      := i.initial_info11;
            rec.initial_info12      := i.initial_info12;
            rec.initial_info13      := i.initial_info13;
            rec.initial_info14      := i.initial_info14;
            rec.initial_info15      := i.initial_info15;
            rec.initial_info16      := i.initial_info16;
            rec.initial_info17      := i.initial_info17;
            rec.remarks             := i.remarks;
            rec.user_id             := i.user_id;
            rec.last_update         := TO_CHAR(i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
            rec.active_tag          := i.active_tag; --carlo 01-26-2016 SR 5915
            
            rec.nbt_info                := NULL;
            rec.nbt_initial_gen_info    := NULL;
            
            IF i.initial_info01 IS NOT NULL THEN
                rec.nbt_info    := 'I';
                rec.nbt_initial_gen_info := i.initial_info01 ||''||i.initial_info02||''||i.initial_info03||''||i.initial_info04||''||i.initial_info05||''||
                                            i.initial_info06 ||''||i.initial_info07||''||i.initial_info08||''||i.initial_info09||''||i.initial_info10||''||
                                            i.initial_info11 ||''||i.initial_info12||''||i.initial_info13||''||i.initial_info14||''||i.initial_info15||''||
                                            i.initial_info16 ||''||i.initial_info17;
            ELSIF i.gen_info01 IS NOT NULL THEN
                rec.nbt_info    := 'G';
                rec.nbt_initial_gen_info := i.gen_info01 ||''||i.gen_info02||''||i.gen_info03||''||i.gen_info04||''||i.gen_info05||''||
                                            i.gen_info06 ||''||i.gen_info07||''||i.gen_info08||''||i.gen_info09||''||i.gen_info10||''||
                                            i.gen_info11 ||''||i.gen_info12||''||i.gen_info13||''||i.gen_info14||''||i.gen_info15||''||
                                            i.gen_info16 ||''||i.gen_info17;	

            END IF;
        
            PIPE ROW(rec);
        END LOOP;
        
        RETURN;
    END get_rec_list;
    
    
    FUNCTION allow_update(
        p_genin_info_cd     GIIS_GENIN_INFO.GENIN_INFO_CD%type
    ) RETURN VARCHAR2
    AS
	    v_cdp       VARCHAR2(5);
	    v_cdw       VARCHAR2(5); 
        v_allow     VARCHAR2(1) := 'N';   
    BEGIN
        FOR a IN(SELECT genin_info_cd 
                   FROM gipi_polgenin 
                  WHERE genin_info_cd = p_genin_info_cd)          
        LOOP 
            v_cdp := a.genin_info_cd;  
        END LOOP;

        FOR b IN (SELECT genin_info_cd 
                    FROM gipi_wpolgenin 
                   WHERE genin_info_cd = p_genin_info_cd)
        LOOP                         			
            v_cdw := b.genin_info_cd;                          		
        END LOOP;
            
        IF v_cdp = p_genin_info_cd OR v_cdw = p_genin_info_cd THEN
            v_allow := 'N';
        ELSE
            v_allow := 'Y';
        END IF;
            
        RETURN (v_allow);
    END allow_update;

    
    PROCEDURE set_rec (p_rec  GIIS_GENIN_INFO%ROWTYPE)
    AS
    BEGIN
        -- added to assign the correct USER to user_id
        /****************************************
        ** Modified by MJ Fabroa 2014-10-29
        ** Commented-out to use the correct trigger
        
        EXECUTE IMMEDIATE 'ALTER TRIGGER CPI."BIN$j5HZv9K+QnK1rW8ErhSMaA==$0" DISABLE';
        EXECUTE IMMEDIATE 'ALTER TRIGGER CPI."BIN$QKEOJlpfTne5S1oAng5Iig==$0" DISABLE';
        ****************************************/
        EXECUTE IMMEDIATE 'ALTER TRIGGER CPI.GIIS_GENIN_INFO_TBXIU DISABLE'; --MJ Fabroa 2014-10-29: Correct trigger

        MERGE INTO GIIS_GENIN_INFO
         USING DUAL
         ON (genin_info_cd = p_rec.genin_info_cd)
         WHEN NOT MATCHED THEN
            INSERT (genin_info_cd, genin_info_title, gen_info01, gen_info02, gen_info03, gen_info04, gen_info05, gen_info06,
                    gen_info07, gen_info08, gen_info09, gen_info10, gen_info11, gen_info12, gen_info13, gen_info14, gen_info15,
                    gen_info16, gen_info17, initial_info01, initial_info02, initial_info03, initial_info04, initial_info05,
                    initial_info06, initial_info07, initial_info08, initial_info09, initial_info10, initial_info11, initial_info12,
                    initial_info13, initial_info14, initial_info15, initial_info16, initial_info17, remarks, user_id, last_update, active_tag) --carlo 01-26-2016 SR 5915
            VALUES (p_rec.genin_info_cd, p_rec.genin_info_title, p_rec.gen_info01, p_rec.gen_info02, p_rec.gen_info03, p_rec.gen_info04, 
                    p_rec.gen_info05, p_rec.gen_info06, p_rec.gen_info07, p_rec.gen_info08, p_rec.gen_info09, p_rec.gen_info10, p_rec.gen_info11, 
                    p_rec.gen_info12, p_rec.gen_info13, p_rec.gen_info14, p_rec.gen_info15, p_rec.gen_info16, p_rec.gen_info17, 
                    p_rec.initial_info01, p_rec.initial_info02, p_rec.initial_info03, p_rec.initial_info04, p_rec.initial_info05,
                    p_rec.initial_info06, p_rec.initial_info07, p_rec.initial_info08, p_rec.initial_info09, p_rec.initial_info10, p_rec.initial_info11, 
                    p_rec.initial_info12, p_rec.initial_info13, p_rec.initial_info14, p_rec.initial_info15, p_rec.initial_info16, p_rec.initial_info17, 
                    p_rec.remarks, p_rec.user_id, SYSDATE, p_rec.active_tag)
         WHEN MATCHED THEN
            UPDATE
               SET  genin_info_title    = p_rec.genin_info_title,
                    gen_info01          = p_rec.gen_info01,
                    gen_info02          = p_rec.gen_info02,
                    gen_info03          = p_rec.gen_info03,
                    gen_info04          = p_rec.gen_info04,
                    gen_info05          = p_rec.gen_info05,
                    gen_info06          = p_rec.gen_info06,
                    gen_info07          = p_rec.gen_info07,
                    gen_info08          = p_rec.gen_info08,
                    gen_info09          = p_rec.gen_info09,
                    gen_info10          = p_rec.gen_info10,
                    gen_info11          = p_rec.gen_info11,
                    gen_info12          = p_rec.gen_info12,
                    gen_info13          = p_rec.gen_info13,
                    gen_info14          = p_rec.gen_info14,
                    gen_info15          = p_rec.gen_info15,
                    gen_info16          = p_rec.gen_info16,
                    gen_info17          = p_rec.gen_info17,
                    initial_info01      = p_rec.initial_info01,
                    initial_info02      = p_rec.initial_info02,
                    initial_info03      = p_rec.initial_info03,
                    initial_info04      = p_rec.initial_info04,
                    initial_info05      = p_rec.initial_info05,
                    initial_info06      = p_rec.initial_info06,
                    initial_info07      = p_rec.initial_info07,
                    initial_info08      = p_rec.initial_info08,
                    initial_info09      = p_rec.initial_info09,
                    initial_info10      = p_rec.initial_info10,
                    initial_info11      = p_rec.initial_info11,
                    initial_info12      = p_rec.initial_info12,
                    initial_info13      = p_rec.initial_info13,
                    initial_info14      = p_rec.initial_info14,
                    initial_info15      = p_rec.initial_info15,
                    initial_info16      = p_rec.initial_info16,
                    initial_info17      = p_rec.initial_info17,
                    remarks             = p_rec.remarks, 
                    user_id             = p_rec.user_id, 
                    last_update         = SYSDATE,
                    active_tag          = p_rec.active_tag --carlo 01-26-2016 SR 5915
        ;
        /****************************************
        ** Modified by MJ Fabroa 2014-10-29
        ** Commented-out to use the correct trigger        
        EXECUTE IMMEDIATE 'ALTER TRIGGER CPI."BIN$j5HZv9K+QnK1rW8ErhSMaA==$0" ENABLE';
        EXECUTE IMMEDIATE 'ALTER TRIGGER CPI."BIN$QKEOJlpfTne5S1oAng5Iig==$0" ENABLE';
        ****************************************/
        
        EXECUTE IMMEDIATE 'ALTER TRIGGER CPI.GIIS_GENIN_INFO_TBXIU ENABLE'; --MJ Fabroa 2014-10-29: Correct trigger
        
    END set_rec;
    

    PROCEDURE del_rec (p_genin_info_cd  GIIS_GENIN_INFO.GENIN_INFO_CD%type)
    AS
    BEGIN
        DELETE FROM GIIS_GENIN_INFO
         WHERE genin_info_cd = p_genin_info_cd;
    END del_rec;
    

    PROCEDURE val_del_rec (p_genin_info_cd  GIIS_GENIN_INFO.GENIN_INFO_CD%type)
    AS
        /*v_cdp       VARCHAR2(5);
	    v_cdw       VARCHAR2(5); */
        v_exists    VARCHAR2(1);
    BEGIN
        FOR a IN(SELECT genin_info_cd 
                   FROM gipi_polgenin
                  WHERE genin_info_cd = p_genin_info_cd)          
        LOOP 		
            --v_cdp := a.genin_info_cd; 
            v_exists := 'Y';
            EXIT;
        END LOOP;
            	
        IF v_exists = 'Y' THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Cannot delete record record from GIIS_GENIN_INFO while dependent record(s) in GIPI_POLGENIN exists.');       
        END IF;
        
        FOR b IN (SELECT genin_info_cd 
                    FROM gipi_wpolgenin 
                   WHERE genin_info_cd = p_genin_info_cd)          
        LOOP       			
            --v_cdw := b.genin_info_cd;
            v_exists := 'Y';
            EXIT;
        END LOOP;
        
         IF v_exists = 'Y' THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Cannot delete record record from GIIS_GENIN_INFO while dependent record(s) in GIPI_WPOLGENIN exists.');       
        END IF;
   
        /*IF v_cdp = p_genin_info_cd OR v_cdw = p_genin_info_cd THEN
            --msg_alert('Cannot delete record. Detailed record already exists in transaction tables.', 'E', TRUE);
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Cannot delete record. Detailed record already exists in transaction tables.');       
        END IF;*/
    END val_del_rec;
    
   
    PROCEDURE val_add_rec(p_genin_info_cd  GIIS_GENIN_INFO.GENIN_INFO_CD%type)
    AS
         v_exists   VARCHAR2 (1);
    BEGIN
        FOR i IN (SELECT '1'
                    FROM GIIS_GENIN_INFO a
                   WHERE a.genin_info_cd = p_genin_info_cd)
        LOOP
            v_exists := 'Y';
            EXIT;
        END LOOP;

        IF v_exists = 'Y' THEN
            raise_application_error (-20001,
                                     'Geniisys Exception#E#Record already exists with the same genin_info_cd.'
                                     );
        END IF;
    END val_add_rec;
END GIISS180_PKG;
/


