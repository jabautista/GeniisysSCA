CREATE OR REPLACE PACKAGE BODY CPI.GIPIS162_PKG
AS

    FUNCTION get_booking_list
        RETURN gipis162_tab PIPELINED
    AS
        v_gipis162_tab  gipis162_type;    
    BEGIN
        FOR i IN (SELECT * 
                    FROM GIIS_BOOKING_MONTH
                   ORDER BY booking_year,to_date(booking_mth,'MONTH'))
        LOOP
            v_gipis162_tab.booking_mth      := i.booking_mth;
            v_gipis162_tab.booking_year     := i.booking_year;
            v_gipis162_tab.booked_tag       := i.booked_tag;
            v_gipis162_tab.remarks          := i.remarks;
            v_gipis162_tab.last_update      := i.last_update;
            v_gipis162_tab.user_id          := i.user_id;
            
            PIPE ROW(v_gipis162_tab);
        END LOOP;        
    END get_booking_list;
    
    
    PROCEDURE generate_booking_months(
        p_booking_year  GIIS_BOOKING_MONTH.BOOKING_YEAR%TYPE,
        p_user_id       GIIS_BOOKING_MONTH.USER_ID%TYPE
    ) 
    AS
        v_month     VARCHAR2(5) := '01';
        v_mth       NUMBER := 1;
        v_month2    VARCHAR2(15);
        v_exist    VARCHAR2(1);
    BEGIN
        WHILE v_mth < 13 LOOP
            select to_char(to_date(v_month||'-01-2008','MM-DD-RRRR'),'FmMONTH')
		      into v_month2
		      from dual;
              
            v_exist := 'N';
            
            FOR x IN (SELECT 1
		   				FROM giis_booking_month
		   			   WHERE booking_mth = RTRIM(LTRIM(v_month2)) 
		   				 AND booking_year = p_booking_year)
            LOOP
                v_exist := 'Y';
            END LOOP;  
            
            IF v_exist = 'N' THEN
                INSERT INTO GIIS_BOOKING_MONTH
                            (booking_mth, 
                             booking_year, 
                             booked_tag,
                             last_update, 
                             user_id)
                     VALUES (RTRIM(ltrim(v_month2)), 
                             p_booking_year, 
                             'N',
                             SYSDATE, 
                             p_user_id);
            END IF;
            	
            v_mth := v_mth + 1;
	        v_month := to_char(v_mth);
        END LOOP;        
    END generate_booking_months;
    
    
END GIPIS162_PKG;
/


