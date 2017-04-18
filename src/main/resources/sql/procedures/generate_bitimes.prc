DROP PROCEDURE CPI.GENERATE_BITIMES;

CREATE OR REPLACE PROCEDURE CPI.GENERATE_BITIMES(MINYEAR IN NUMBER,  MAXYEAR  IN NUMBER) IS

v_minyear       NUMBER:= MINYEAR;
v_maxyear       NUMBER:= MAXYEAR;
v_timekey       DATE;
v_firstday      DATE;
v_lastday       NUMBER;
v_quarter       NUMBER;   
       
    begin
    delete from GENIISYS_BITIMES;
        FOR cYear in v_minyear..v_maxyear LOOP --YEAR 
            
            FOR cMonth in 1..12 LOOP -- MONTH
                v_firstday  := TO_DATE(cMonth || '/' || 1 || '/' || cYear, 'MM/DD/YYYY'); 
                v_lastday   := TO_CHAR(LAST_DAY(v_firstday), 'DD');
                
                FOR cDay in 1..v_lastday LOOP
                    
                    v_timekey   := TO_DATE(cMonth || '/' || cDay || '/' || cYear, 'MM/DD/YYYY');
                    v_quarter   := TO_CHAR(v_timekey, 'Q');
                    
                    INSERT INTO GENIISYS_BITIMES 
                         VALUES(v_timekey,cYear, cMonth, v_quarter,  TO_CHAR(v_timekey, 'MONTH'), DECODE(v_quarter, 1, 'FIRST', 
                                                                                                                    2, 'SECOND',
                                                                                                                    3, 'THIRD',
                                                                                                                    4, 'FOURTH'));
                END LOOP;
            END LOOP;
        END LOOP;   
    end;
/

DROP PROCEDURE CPI.GENERATE_BITIMES;
