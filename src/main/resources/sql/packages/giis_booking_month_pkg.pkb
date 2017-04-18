CREATE OR REPLACE PACKAGE BODY CPI.GIIS_BOOKING_MONTH_PKG AS

 /********************************** FUNCTION 1 ************************************
  MODULE: GIPIS026
  RECORD GROUP NAME: BOOKED 
***********************************************************************************/ 

  FUNCTION get_booked_list (p_date VARCHAR2) 
    RETURN booked_list_tab PIPELINED IS
  
    v_booked  booked_list_type;
    v_date  DATE; 
   
  BEGIN
    v_date := to_date(p_date, 'mm-dd-yyyy');
    FOR i IN (
      SELECT booking_year, booking_mth,
             TO_CHAR(TO_DATE('01-' || SUBSTR(booking_mth,1, 3) || '-' || booking_year, 'DD-MON-YYYY'), 'MM') booking_mth_num 
        FROM GIIS_BOOKING_MONTH
       WHERE NVL(booked_tag, 'N') <> 'Y'
       	 /* Deo [01.30.2017]: removed date conditions below (SR-23633)
         AND (BOOKING_YEAR > TO_NUMBER(TO_CHAR(v_date, 'YYYY'))
          OR (BOOKING_YEAR >= TO_NUMBER(TO_CHAR(v_date, 'YYYY'))
         AND TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3) || '-' || BOOKING_YEAR, 'DD-MON-YYYY'), 'MM'))>= TO_NUMBER(TO_CHAR(v_date, 'MM')))) */
       ORDER BY 1, 3)
  LOOP
    v_booked.booking_year       := i.booking_year;
    v_booked.booking_mth        := i.booking_mth;
    v_booked.booking_mth_num    := i.booking_mth_num;
    PIPE ROW(v_booked);    
  END LOOP;
  RETURN;
END get_booked_list;
  
FUNCTION get_booked_list2 (p_incept_date VARCHAR2,
                            p_issue_date VARCHAR2) 
    RETURN booked_list_tab PIPELINED IS
  
    v_booked  booked_list_type;
    v_date  DATE; 
    v_param_date VARCHAR2(20);
    v_param_value_result number;
   
  BEGIN
      BEGIN
         SELECT PARAM_VALUE_N
              INTO v_param_value_result
         FROM GIAC_PARAMETERS
          WHERE PARAM_NAME = 'PROD_TAKE_UP';
       IF v_param_value_result = 1 THEN
             v_param_date := p_issue_date;
       ELSE
             v_param_date := p_incept_date;      
       END IF;    
        
    EXCEPTION
        when no_data_found then
        null;    
    END;    
    v_date := to_date(v_param_date, 'mm-dd-yyyy');
    FOR i IN (
      SELECT booking_year, booking_mth, 
             TO_CHAR(TO_DATE('01-' || SUBSTR(booking_mth,1, 3) || '-' || booking_year, 'DD-MON-YYYY'), 'MM') booking_mth_num 
        FROM GIIS_BOOKING_MONTH
       WHERE NVL(booked_tag, 'N') <> 'Y'
         AND (BOOKING_YEAR > TO_NUMBER(TO_CHAR(v_date, 'YYYY'))
          OR (BOOKING_YEAR >= TO_NUMBER(TO_CHAR(v_date, 'YYYY'))
         AND TO_NUMBER(TO_CHAR(TO_DATE('1-'||SUBSTR(BOOKING_MTH,1, 3) || '-' || BOOKING_YEAR, 'DD-MON-YYYY'), 'MM'))>= TO_NUMBER(TO_CHAR(v_date, 'MM'))))
       ORDER BY 1, 3)
  LOOP
    v_booked.booking_year  := i.booking_year;
    v_booked.booking_mth  := i.booking_mth;
    v_booked.booking_mth_num := i.booking_mth_num;
    PIPE ROW(v_booked);    
  END LOOP;
  RETURN;
END get_booked_list2;  

  /*
  **  Created by   :  Jerome Orio
  **  Date Created :  04.07.2011
  **  Reference By : (GIPIS002 - Basic Information Details)
  **  Description  : BOOKED2 record group  
  */   
    FUNCTION get_booked_list3
    RETURN booked_list_tab PIPELINED IS
        v_booked  booked_list_type;
    BEGIN
      FOR i IN (SELECT BOOKING_YEAR, BOOKING_MTH, 
                       TO_CHAR(TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3)|| BOOKING_YEAR, 'DD-MON-RRRR'), 'MM') booking_mth_num
                  FROM GIIS_BOOKING_MONTH
                 WHERE NVL(BOOKED_TAG, 'N') <> 'Y'
                 ORDER BY 1, 3)
      LOOP
        v_booked.booking_year       := i.booking_year;
        v_booked.booking_mth        := i.booking_mth;
        v_booked.booking_mth_num    := i.booking_mth_num;
        PIPE ROW(v_booked);    
      END LOOP;
      RETURN;
    END get_booked_list3;     


  /*
  **  Created by   :  D.Alcantara
  **  Date Created :  09.01.2011
  **  Reference By : (GIPIS165 - Bond Endt Basic Info)
  **  Description  : retrieves default booking_date for gipis165
  */ 
  
  /**
   * Modified By :Andrew Robes
   * Date : 07.17.2012
   * Modification : added date format 'DD-MON-YYYY' in TO_DATE function to handle ORA-01858 encountered in some machines
   */
    PROCEDURE GET_BOOKING_DATE_GIPIS165 (
        p_issue_date      IN  GIPI_WPOLBAS.issue_date%TYPE,
        p_incept_date     IN  GIPI_WPOLBAS.incept_date%TYPE,
        p_booking_month   OUT VARCHAR2,
        p_booking_year    OUT VARCHAR2
    ) IS
        v_date_flag     NUMBER(1) := 0;
        v_param_vdate   GIAC_PARAMETERS.PARAM_VALUE_N%TYPE;
        v_idate         DATE;
		D1 VARCHAR2(10);
		D2 VARCHAR2(10);
    BEGIN
        v_param_vdate := giacp.n('PROD_TAKE_UP');
    
	    IF  v_param_vdate = 1 OR
                  (v_param_vdate = 3 AND p_issue_date > p_incept_date) THEN
            v_idate := p_issue_date;	
				  
            D2 := p_incept_date;
			
            FOR C IN (SELECT BOOKING_YEAR, 
                                 TO_CHAR(TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3)|| BOOKING_YEAR, 'DD-MON-YYYY'), 'MM'), 
                                 BOOKING_MTH 
                       FROM GIIS_BOOKING_MONTH
                       WHERE  (NVL(BOOKED_TAG, 'N') != 'Y')
                        AND (BOOKING_YEAR > TO_NUMBER(TO_CHAR(p_issue_date, 'YYYY'))
                       OR (BOOKING_YEAR = TO_NUMBER(TO_CHAR(p_issue_date, 'YYYY'))
                       AND TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3)|| BOOKING_YEAR, 'DD-MON-YYYY'),
                           'MM'))>= TO_NUMBER(TO_CHAR(p_issue_date, 'MM'))))
          	           
                       ORDER BY 1, 2 ) 
			LOOP
                p_booking_year := TO_NUMBER(C.BOOKING_YEAR);       
                p_booking_month  := C.BOOKING_MTH;       	   
                v_date_flag := 1;
                EXIT;
            END LOOP; 		
			
            IF v_date_flag <> 1 THEN
                p_booking_year := NULL;
                p_booking_month := NULL;
            END IF;	
            
        ELSIF v_param_vdate = 2 OR
                (v_param_vdate = 3 AND p_issue_date <= p_incept_date) THEN
                   
			v_idate := p_incept_date;
				   
            FOR C IN (SELECT BOOKING_YEAR, 
                                 TO_CHAR(TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3)|| BOOKING_YEAR, 'DD-MON-YYYY'), 'MM'), 
                                 BOOKING_MTH 
                        FROM GIIS_BOOKING_MONTH
                       WHERE ( NVL(BOOKED_TAG, 'N') <> 'Y')

                        AND (BOOKING_YEAR > TO_NUMBER(TO_CHAR(p_incept_date, 'YYYY'))
                          OR (BOOKING_YEAR = TO_NUMBER(TO_CHAR(p_incept_date, 'YYYY'))
                         AND TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3)|| BOOKING_YEAR, 'DD-MON-YYYY'), 
                             'MM'))>= TO_NUMBER(TO_CHAR(p_incept_date, 'MM'))))
                                       ORDER BY 1, 2 ) LOOP
                p_booking_year := TO_NUMBER(C.BOOKING_YEAR);       
                p_booking_month  := C.BOOKING_MTH;       	   
                v_date_flag := 1;
                EXIT;
             END LOOP; 					
             IF v_date_flag <> 1 THEN
                p_booking_year := NULL;
                p_booking_month := NULL;
             END IF;	
        END IF; 	

    END get_booking_date_gipis165; 
    
     /*
   **  Created by   :  D.Alcantara
   **  Date Created :  01.27.2012
   **  Reference By : (GIPIS002- Basic Information)
   **  Description  : retrieves default booking_date for gipis002
   */ 
    PROCEDURE get_booking_date_gipis002 (
        p_var_iDate       IN  DATE,
        p_booking_year OUT gipi_wpolbas.booking_year%TYPE,
	    p_booking_mth OUT gipi_wpolbas.booking_mth%TYPE
    ) IS 
        v_date_flag2 NUMBER := 2;
    BEGIN
        FOR C IN (SELECT BOOKING_YEAR, 
		                 TO_CHAR(TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3)|| BOOKING_YEAR, 'DD-MON-YYYY'), 'MM'), -- andrew, 07.17.2012 - added date format in TO_DATE function to handle ORA-01858 on some machines 
		                 BOOKING_MTH 
  	            FROM GIIS_BOOKING_MONTH
  	           WHERE ( NVL(BOOKED_TAG, 'N') <> 'Y')
  	            AND (BOOKING_YEAR > TO_NUMBER(TO_CHAR(p_var_iDate, 'YYYY'))
  	              OR (BOOKING_YEAR = TO_NUMBER(TO_CHAR(p_var_iDate, 'YYYY'))
  	             AND TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3)|| BOOKING_YEAR, 'DD-MON-YYYY'), 'MM'))>= TO_NUMBER(TO_CHAR(p_var_iDate, 'MM')))) -- andrew, 07.17.2012 - added date format in TO_DATE function to handle ORA-01858 on some machines
  	               	           ORDER BY 1, 2 ) 
        LOOP
            p_booking_year   := TO_NUMBER(C.BOOKING_YEAR);       
            p_booking_mth  := C.BOOKING_MTH;       	   
            v_date_flag2     := 5;
            EXIT;
        END LOOP; 					
     
        IF v_date_flag2 <> 5 THEN
            p_booking_year := NULL;
            p_booking_mth := NULL;
        END IF;	
    END get_booking_date_gipis002;
    
    FUNCTION get_gipis156_booked_lov (
       p_issue_date     VARCHAR2,
       p_incept_date    VARCHAR2
    )
       RETURN gipis156_booked_list_tab PIPELINED
    IS
       v_list gipis156_booked_list_type;
       v_vdate  NUMBER;
       v_idate DATE;
    BEGIN
    
       BEGIN
          SELECT param_value_n
            INTO v_vdate
			FROM GIAC_PARAMETERS
		   WHERE param_name = 'PROD_TAKE_UP';
       END;
       
       IF v_vdate = 1 THEN
         v_idate := TO_DATE(p_issue_date, 'yyyy-mm-dd');
       ELSIF v_vdate = 2 THEN
         v_idate := TO_DATE(p_incept_date, 'yyyy-mm-dd');
       ELSIF v_vdate = 3 THEN
         IF TO_DATE(p_issue_date, 'yyyy-mm-dd') > TO_DATE(p_incept_date, 'yyyy-mm-dd') THEN
            v_idate := TO_DATE(p_issue_date, 'yyyy-mm-dd');
         ELSE
            v_idate := TO_DATE(p_incept_date, 'yyyy-mm-dd'); 
         END IF;     
       END IF;
    
       FOR i IN (SELECT booking_year, booking_mth,
                        TO_CHAR (TO_DATE ('01-' || SUBSTR (booking_mth, 1, 3) || booking_year), 'MM')
                   FROM giis_booking_month
                  WHERE NVL (booked_tag, 'N') <> 'Y'
                    AND (booking_year > TO_NUMBER (TO_CHAR (v_idate, 'YYYY'))
                          OR (booking_year >= TO_NUMBER (TO_CHAR (v_idate, 'YYYY'))
                         AND TO_NUMBER (TO_CHAR (TO_DATE (   '01-' || SUBSTR (booking_mth, 1, 3) || booking_year), 'MM')) >= TO_NUMBER (TO_CHAR (v_idate, 'MM'))))
               ORDER BY 1, 3)
       LOOP
          v_list.booking_year := i.booking_year;
          v_list.booking_mth := i.booking_mth;
          
          BEGIN
            FOR booked IN (SELECT nvl(booked_tag, 'N') booked_tag
                             FROM giis_booking_month
                            WHERE booking_year = i.booking_year
                              AND booking_mth  = i.booking_mth)
            LOOP
              v_list.booked_tag := booked.booked_tag;
            END LOOP;
         END;
          
          PIPE ROW(v_list);
       END LOOP;
    END get_gipis156_booked_lov;
    
    FUNCTION get_gipis156_booked2_lov
       RETURN gipis156_booked_list_tab PIPELINED
    IS
      v_list gipis156_booked_list_type;
    BEGIN
      FOR i IN (SELECT BOOKING_YEAR, BOOKING_MTH, 
                       TO_CHAR(TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3)|| BOOKING_YEAR, 'DD-MON-RRRR'), 'MM') booking_mth_num
                  FROM GIIS_BOOKING_MONTH
                 WHERE NVL(BOOKED_TAG, 'N') <> 'Y'
                 ORDER BY 1, 3)
      LOOP
         v_list.booking_year       := i.booking_year;
         v_list.booking_mth        := i.booking_mth;
         v_list.booking_mth_num    := i.booking_mth_num;
         
         BEGIN
            FOR booked IN (SELECT nvl(booked_tag, 'N') booked_tag
                             FROM giis_booking_month
                            WHERE booking_year = i.booking_year
                              AND booking_mth  = i.booking_mth)
            LOOP
              v_list.booked_tag := booked.booked_tag;
            END LOOP;
         END;
         
         PIPE ROW(v_list);    
      END LOOP;
    END get_gipis156_booked2_lov;   
    
    FUNCTION get_gipis156_bookedinvoice_lov (
       p_issue_date     VARCHAR2,
       p_incept_date    VARCHAR2
    )
       RETURN gipis156_booked_list_tab PIPELINED
    IS
       v_list gipis156_booked_list_type;
       v_vdate  NUMBER;
       v_idate DATE;
    BEGIN
       BEGIN
           SELECT param_value_n
             INTO v_vdate
		  	    FROM GIAC_PARAMETERS
		      WHERE param_name = 'PROD_TAKE_UP';
       END;
       
       IF v_vdate = 1 THEN
          v_idate := TO_DATE(p_issue_date, 'yyyy-mm-dd');
       ELSIF v_vdate = 2 THEN
          v_idate := TO_DATE(p_incept_date, 'yyyy-mm-dd');
       ELSIF v_vdate = 3 THEN
          IF TO_DATE(p_issue_date, 'yyyy-mm-dd') > TO_DATE(p_incept_date, 'yyyy-mm-dd') THEN
             v_idate := TO_DATE(p_issue_date, 'yyyy-mm-dd');
          ELSE
             v_idate := TO_DATE(p_incept_date, 'yyyy-mm-dd'); 
          END IF;     
       END IF;

       BEGIN
         FOR i IN (SELECT booking_year, booking_mth,
                          --TO_CHAR (TO_DATE ('01-' || SUBSTR (booking_mth, 1, 3) || booking_year), 'MM' ) --benjo 10.07.2015 comment out
                          TO_CHAR (TO_DATE ('01-' || SUBSTR(booking_mth, 1, 3) || '-' || booking_year, 'DD-MON-YYYY'), 'MM') --benjo 10.07.2015 to avoid ORA-01858
                     FROM giis_booking_month
                    WHERE NVL (booked_tag, 'N') <> 'Y'
                      AND (booking_year > TO_NUMBER (TO_CHAR (v_idate, 'YYYY'))
                           OR (booking_year >= TO_NUMBER (TO_CHAR (v_idate, 'YYYY'))
                          --AND TO_NUMBER (TO_CHAR (TO_DATE ('01-' || SUBSTR (booking_mth, 1, 3) || booking_year), 'MM' )) >= TO_NUMBER (TO_CHAR (v_idate, 'MM')) )) --benjo 10.07.2015 comment out
                          AND TO_NUMBER (TO_CHAR (TO_DATE ('01-' || SUBSTR(booking_mth, 1, 3) || '-' || booking_year, 'DD-MON-YYYY'), 'MM')) >= TO_NUMBER (TO_CHAR (v_idate, 'MM')) )) --benjo 10.07.2015 to avoid ORA-01858
                 ORDER BY 1, 3)
         LOOP
            v_list.booking_year := i.booking_year;
            v_list.booking_mth := i.booking_mth;
            
            BEGIN
               FOR booked IN (SELECT nvl(booked_tag, 'N') booked_tag
                                FROM giis_booking_month
                               WHERE booking_year = i.booking_year
                                 AND booking_mth  = i.booking_mth)
               LOOP
                 v_list.booked_tag := booked.booked_tag;
               END LOOP;
            END;
            
            PIPE ROW(v_list);
         END LOOP;
       END;
       
    END get_gipis156_bookedinvoice_lov;   
    
END GIIS_BOOKING_MONTH_PKG;
/


