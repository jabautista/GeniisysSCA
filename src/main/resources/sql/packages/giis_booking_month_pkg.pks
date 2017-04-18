CREATE OR REPLACE PACKAGE CPI.GIIS_BOOKING_MONTH_PKG AS

    /********************************** FUNCTION 1 ************************************
        MODULE: GIPIS026
        RECORD GROUP NAME: BOOKED 
    ***********************************************************************************/ 
    TYPE booked_list_type IS RECORD
        (booking_year     GIIS_BOOKING_MONTH.booking_year%TYPE,
        booking_mth      GIIS_BOOKING_MONTH.booking_mth%TYPE,
        booking_mth_num  VARCHAR2(2));
  
    TYPE booked_list_tab IS TABLE OF booked_list_type;


    FUNCTION get_booked_list (p_date VARCHAR2) 
    RETURN booked_list_tab PIPELINED;
	
    FUNCTION get_booked_list2 (
        p_incept_date       VARCHAR2,
  	    p_issue_date        VARCHAR2) 
    RETURN booked_list_tab PIPELINED;
 
    FUNCTION get_booked_list3
    RETURN booked_list_tab PIPELINED;
    
        
    PROCEDURE GET_BOOKING_DATE_GIPIS165 (
        p_issue_date      IN  GIPI_WPOLBAS.issue_date%TYPE,
        p_incept_date     IN  GIPI_WPOLBAS.incept_date%TYPE,
        p_booking_month   OUT VARCHAR2,
        p_booking_year    OUT VARCHAR2
    );
    
    PROCEDURE get_booking_date_gipis002 (
        p_var_iDate       IN  DATE,
        p_booking_year OUT gipi_wpolbas.booking_year%TYPE,
	    p_booking_mth OUT gipi_wpolbas.booking_mth%TYPE
    );
    
    TYPE gipis156_booked_list_type IS RECORD (
      booking_year     giis_booking_month.booking_year%TYPE,
      booking_mth      giis_booking_month.booking_mth%TYPE,
      booking_mth_num  VARCHAR2(2),
      booked_tag       giis_booking_month.booked_tag%TYPE      
    );
  
    TYPE gipis156_booked_list_tab IS TABLE OF gipis156_booked_list_type;
    
    FUNCTION get_gipis156_booked_lov (
       p_issue_date     VARCHAR2,
       p_incept_date    VARCHAR2
    )
       RETURN gipis156_booked_list_tab PIPELINED;
       
    FUNCTION get_gipis156_booked2_lov
       RETURN gipis156_booked_list_tab PIPELINED;   
       
    FUNCTION get_gipis156_bookedinvoice_lov (
       p_issue_date     VARCHAR2,
       p_incept_date    VARCHAR2
    )
       RETURN gipis156_booked_list_tab PIPELINED;   
        
END GIIS_BOOKING_MONTH_PKG;
/


