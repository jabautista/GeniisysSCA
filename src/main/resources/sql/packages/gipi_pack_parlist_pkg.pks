CREATE OR REPLACE PACKAGE CPI.Gipi_Pack_Parlist_Pkg AS

  TYPE gipis031A_pack_parlist_type IS RECORD (
  	   pack_par_id				   GIPI_PACK_PARLIST.pack_par_id%TYPE,
	   assd_no					   GIPI_PACK_PARLIST.assd_no%TYPE,
	   par_type					   GIPI_PACK_PARLIST.par_type%TYPE,
	   line_cd					   GIPI_PACK_PARLIST.line_cd%TYPE,
	   par_yy					   GIPI_PACK_PARLIST.par_yy%TYPE,
	   iss_cd					   GIPI_PACK_PARLIST.iss_cd%TYPE,
	   par_seq_no				   GIPI_PACK_PARLIST.par_seq_no%TYPE,
	   quote_seq_no				   GIPI_PACK_PARLIST.quote_seq_no%TYPE,
	   address1					   GIPI_PACK_PARLIST.address1%TYPE,
	   address2					   GIPI_PACK_PARLIST.address2%TYPE,
	   address3					   GIPI_PACK_PARLIST.address3%TYPE,
	   par_status				   GIPI_PACK_PARLIST.par_status%TYPE,
	   drv_par_seq_no			   VARCHAR2(20),
	   assd_name	  			   GIIS_ASSURED.assd_name%TYPE
  );
  
  TYPE rc_gipi_pack_parlist_cur IS REF CURSOR RETURN gipis031A_pack_parlist_type;

  TYPE gipi_pack_parlist_type IS RECORD (
    pack_par_id 	  GIPI_PACK_PARLIST.pack_par_id%TYPE,
	line_cd			  GIPI_PACK_PARLIST.line_cd%TYPE,
	subline_cd		  GIPI_PACK_WPOLBAS.subline_cd%TYPE,
	iss_cd			  GIPI_PACK_PARLIST.iss_cd%TYPE,
	issue_yy		  GIPI_PACK_WPOLBAS.issue_yy%TYPE,
	pol_seq_no		  GIPI_PACK_WPOLBAS.pol_seq_no%TYPE,
	renew_no		  GIPI_PACK_WPOLBAS.renew_no%TYPE,
	par_yy			  GIPI_PACK_PARLIST.par_yy%TYPE,
	par_seq_no		  GIPI_PACK_PARLIST.par_seq_no%TYPE,
	pack_par_no		  VARCHAR2(30), --added by cris 05/19/2010
	quote_seq_no	  GIPI_PACK_PARLIST.quote_seq_no%TYPE,
	assd_no			  GIPI_PACK_PARLIST.assd_no%TYPE,
	assd_name		  GIIS_ASSURED.assd_name%TYPE,
	par_status		  GIPI_PACK_PARLIST.par_status%TYPE,
    status			  CG_REF_CODES.rv_meaning%TYPE, -- added by: nica 11.03.2010
    par_type          GIPI_PACK_PARLIST.par_type%TYPE,
    line_name		  GIIS_LINE.line_name%TYPE,
    quote_id		  GIPI_PACK_PARLIST.quote_id%TYPE,
	remarks  		  VARCHAR2 (32767),--GIPI_PACK_PARLIST.remarks%TYPE, -- replaced by: Nica 02.06.2012
	underwriter		  GIPI_PACK_PARLIST.underwriter%TYPE,
	assign_sw		  GIPI_PACK_PARLIST.assign_sw%TYPE,
    bank_ref_no       GIPI_PACK_WPOLBAS.bank_ref_no%TYPE);
	
 
  TYPE gipi_pack_parlist_tab IS TABLE OF gipi_pack_parlist_type;
  
  FUNCTION get_gipi_pack_parlist (p_pack_par_id			GIPI_PACK_PARLIST.pack_par_id%TYPE)
    RETURN gipi_pack_parlist_tab PIPELINED;	

  FUNCTION get_gipi_pack_parlist (p_line_cd			GIPI_PACK_PARLIST.line_cd%TYPE,
                                  p_iss_cd			GIPI_PACK_PARLIST.iss_cd%TYPE,
								  p_par_yy			GIPI_PACK_PARLIST.par_yy%TYPE,
								  p_par_seq_no		GIPI_PACK_PARLIST.par_seq_no%TYPE,
								  p_quote_seq_no	GIPI_PACK_PARLIST.quote_seq_no%TYPE,
								  p_assd_no			GIPI_PACK_PARLIST.assd_no%TYPE,
								  p_underwriter		GIPI_PACK_PARLIST.underwriter%TYPE,
								  p_line_cd_ndb		GIPI_PACK_PARLIST.line_cd%TYPE, --container for :GIPI_PARLIST.line_cd in GIRIS005A
								  p_iss_cd_ndb		GIPI_PACK_PARLIST.iss_cd%TYPE, --container for :GIPI_PARLIST.iss_cd in GIRIS005A
								  p_module			VARCHAR2,
                                  p_user_id         giis_users.user_id%TYPE)
    RETURN gipi_pack_parlist_tab PIPELINED;
	
	
  FUNCTION get_gipi_pack_parlist (p_line_cd			GIPI_PACK_PARLIST.line_cd%TYPE,
                                  p_iss_cd			GIPI_PACK_PARLIST.iss_cd%TYPE,
								  p_par_yy			GIPI_PACK_PARLIST.par_yy%TYPE,
								  p_par_seq_no		GIPI_PACK_PARLIST.par_seq_no%TYPE,
								  p_quote_seq_no	GIPI_PACK_PARLIST.quote_seq_no%TYPE,
								  p_assd_no			GIPI_PACK_PARLIST.assd_no%TYPE,
								  p_underwriter		GIPI_PACK_PARLIST.underwriter%TYPE)
    RETURN gipi_pack_parlist_tab PIPELINED;

  FUNCTION get_gipi_pack_parlist (p_line_cd		    GIPI_PACK_PARLIST.line_cd%TYPE,
                                  p_iss_cd			GIPI_PACK_PARLIST.iss_cd%TYPE,
								  p_par_yy			GIPI_PACK_PARLIST.par_yy%TYPE,
								  p_par_seq_no		GIPI_PACK_PARLIST.par_seq_no%TYPE,
								  p_quote_seq_no	GIPI_PACK_PARLIST.quote_seq_no%TYPE,
								  p_underwriter		GIPI_PACK_PARLIST.underwriter%TYPE)
    RETURN gipi_pack_parlist_tab PIPELINED;
	
  PROCEDURE del_gipi_pack_parlist (p_par_id		GIPI_PACK_PARLIST.pack_par_id%TYPE);
  
  PROCEDURE set_gipi_pack_parlist ( 
   								  p_line_cd			GIPI_PACK_PARLIST.line_cd%TYPE,
                                  p_iss_cd			GIPI_PACK_PARLIST.iss_cd%TYPE,
								  p_par_yy			GIPI_PACK_PARLIST.par_yy%TYPE,
								  p_par_seq_no		GIPI_PACK_PARLIST.par_seq_no%TYPE,
								  p_quote_seq_no	GIPI_PACK_PARLIST.quote_seq_no%TYPE,
								  p_assd_no			GIPI_PACK_PARLIST.assd_no%TYPE,
								  p_remarks			GIPI_PACK_PARLIST.remarks%TYPE,
								  p_underwriter		GIPI_PACK_PARLIST.underwriter%TYPE);

  PROCEDURE set_gipi_pack_parlist ( 
   								  p_line_cd			GIPI_PACK_PARLIST.line_cd%TYPE,
                                  p_iss_cd			GIPI_PACK_PARLIST.iss_cd%TYPE,
								  p_par_yy			GIPI_PACK_PARLIST.par_yy%TYPE,
								  p_par_seq_no		GIPI_PACK_PARLIST.par_seq_no%TYPE,
								  p_quote_seq_no	GIPI_PACK_PARLIST.quote_seq_no%TYPE,
								  p_remarks			GIPI_PACK_PARLIST.remarks%TYPE);
								  
  PROCEDURE save_pack_par(p_gipi_pack_par IN GIPI_PACK_PARLIST%ROWTYPE);	
	
  PROCEDURE save_pack_parlist(p_gipi_pack_par IN GIPI_PACK_PARLIST%ROWTYPE);
  
  PROCEDURE save_pack_parlist_from_endt (
		p_par_id 		IN GIPI_PACK_PARLIST.pack_par_id%TYPE,
		p_par_type		IN GIPI_PACK_PARLIST.par_type%TYPE,
		p_par_status	IN GIPI_PACK_PARLIST.par_status%TYPE,
		p_line_cd		IN GIPI_PACK_PARLIST.line_cd%TYPE,
		p_iss_cd		IN GIPI_PACK_PARLIST.iss_cd%TYPE,
		p_par_yy		IN GIPI_PACK_PARLIST.par_yy%TYPE,
		p_par_seq_no	IN GIPI_PACK_PARLIST.par_seq_no%TYPE,
		p_quote_seq_no	IN GIPI_PACK_PARLIST.quote_seq_no%TYPE,
		p_assd_no		IN GIPI_PACK_PARLIST.assd_no%TYPE,
		p_address1		IN GIPI_PACK_PARLIST.address1%TYPE,
		p_address2		IN GIPI_PACK_PARLIST.address2%TYPE,
		p_address3		IN GIPI_PACK_PARLIST.address3%TYPE);
  
  PROCEDURE update_status_from_quote(p_quote_id   	GIPI_PACK_PARLIST.quote_id%TYPE
  								    ,p_par_status	GIPI_PACK_PARLIST.par_status%TYPE);
									
  FUNCTION check_par_quote(p_pack_par_id			 GIPI_PACK_PARLIST.pack_par_id%TYPE)
    RETURN VARCHAR2;


/***************************************************************************/
/*
** Transfered by: whofeih
** Date: 06.10.2010
** for GIPIS050A
*/
  PROCEDURE create_parlist_wpack (p_pack_quote_id   NUMBER, 
                          		  p_line_cd    		giis_line.line_cd%TYPE,
						          p_pack_par_id   	NUMBER,
						          p_iss_cd          gipi_parlist.iss_cd%TYPE,
						          p_assd_no         gipi_parlist.assd_no%TYPE);
								  
  PROCEDURE create_pack_wpolbas  (p_pack_quote_id   NUMBER,
					              p_pack_par_id     NUMBER,
					              p_assd_no    		NUMBER,
					              p_line_cd         giis_line.line_cd%TYPE,
					              p_iss_cd          gipi_parlist.iss_cd%TYPE,
					              p_issue_date      gipi_wpolbas.issue_date%TYPE,
					              p_user            gipi_pack_wpolbas.user_id%TYPE,
					              p_booking_mth     gipi_wpolbas.booking_mth%TYPE,
					              p_booking_yr      gipi_wpolbas.booking_year%TYPE);
								  
  PROCEDURE create_item_info     (p_pack_par_id     NUMBER, 
  			                      p_pack_quote_id   NUMBER);
								  
  PROCEDURE create_discounts     (p_pack_par_id     NUMBER);
  PROCEDURE create_peril_wc      (p_pack_par_id     NUMBER);
  PROCEDURE create_dist_ded      (p_pack_par_id     NUMBER);
  PROCEDURE return_to_quote      (p_pack_quote_id   NUMBER,
                                  p_pack_par_id     NUMBER);
  PROCEDURE create_wmortgagee    (p_pack_quote_id   NUMBER, 
                                  p_pack_par_id     NUMBER);
  PROCEDURE update_pack_par_status(p_pack_par_id    GIPI_PACK_PARLIST.pack_par_id%TYPE,
                                   p_par_status     GIPI_PACK_PARLIST.par_status%TYPE);
                                   
  PROCEDURE UPDATE_PACK_PAR_STATUS(p_pack_par_id  GIPI_PACK_PARLIST.pack_par_id%TYPE);                                   
                                   
  FUNCTION get_gipi_pack_parlist (p_line_cd         GIPI_PACK_PARLIST.line_cd%TYPE,
                                  p_iss_cd          GIPI_PACK_PARLIST.iss_cd%TYPE,
                                  p_module_id       GIIS_USER_GRP_MODULES.module_id%TYPE,
                                  p_user_id         GIIS_USERS.user_id%TYPE,
                                  p_keyword         VARCHAR2)
  RETURN gipi_pack_parlist_tab PIPELINED;
  PROCEDURE delete_par            (p_pack_par_id    GIPI_PACK_PARLIST.pack_par_id%TYPE,
                                   p_user_id        VARCHAR2);

  PROCEDURE delete_pack_tables    (p_pack_par_id    GIPI_PACK_PARLIST.pack_par_id%TYPE,
                                   p_user_id        VARCHAR2 );
  PROCEDURE cancel_pack_par       (p_pack_par_id    GIPI_PACK_PARLIST.pack_par_id%TYPE,
                                   p_par_status     GIPI_PACK_PARLIST.par_status%TYPE,
                                   p_user_id        VARCHAR2);
  FUNCTION get_gipi_pack_endt_parlist (  p_line_cd  GIPI_PACK_PARLIST.line_cd%TYPE,
                                   p_iss_cd         GIPI_PACK_PARLIST.iss_cd%TYPE,
                                   p_module_id      GIIS_USER_GRP_MODULES.module_id%TYPE,
                                   p_user_id        GIIS_USERS.user_id%TYPE,
                                   p_keyword        VARCHAR2)
  RETURN gipi_pack_parlist_tab PIPELINED;
  
  PROCEDURE get_pack_endt_basic_info_recs (p_par_id						IN     GIPI_PACK_PARLIST.pack_par_id%TYPE,
		  								   p_gipi_pack_parlist_cur		OUT    GIPI_PACK_PARLIST_PKG.rc_gipi_pack_parlist_cur,
										   p_gipi_pack_wpolbas_cur		OUT    GIPI_PACK_WPOLBAS_PKG.rc_gipi_pack_wpolbas_cur,
										   p_gipi_pack_wendttext_cur	OUT    GIPI_PACK_WENDTTEXT_PKG.rc_gipi_pack_wendttext_cur,
										   p_gipi_pack_wpolgenin_cur	OUT    GIPI_PACK_WPOLGENIN_PKG.rc_gipi_pack_wpolgenin_cur,
										   p_gipi_wopen_policy_cur		OUT    GIPI_WOPEN_POLICY_PKG.rc_gipi_wopen_policy_cur);
                                           
  PROCEDURE update_pack_par_remarks(p_pack_par_id     GIPI_PACK_PARLIST.pack_par_id%TYPE,
                                    p_par_remarks     GIPI_PACK_PARLIST.remarks%TYPE);
                                    
  FUNCTION get_gipi_pack_parlist (p_line_cd         GIPI_PACK_PARLIST.line_cd%TYPE,
                                  p_iss_cd          GIPI_PACK_PARLIST.iss_cd%TYPE,
                                  p_module_id       GIIS_USER_GRP_MODULES.module_id%TYPE,
                                  p_user_id         GIIS_USERS.user_id%TYPE,
                                  p_par_type        GIPI_PACK_PARLIST.par_type%TYPE,
                                  p_par_yy          GIPI_PACK_PARLIST.par_yy%TYPE,
                                  p_par_seq_no      GIPI_PACK_PARLIST.par_seq_no%TYPE,
                                  p_quote_seq_no    GIPI_PACK_PARLIST.quote_seq_no%TYPE,
                                  p_assd_name       GIIS_ASSURED.assd_name%TYPE,
                                  p_underwriter     GIPI_PACK_PARLIST.underwriter%TYPE,
                                  p_status          VARCHAR2,
                                  p_bank_ref_no     GIPI_PACK_WPOLBAS.bank_ref_no%TYPE)
  
  RETURN gipi_pack_parlist_tab PIPELINED;

FUNCTION get_gipi_pack_parlist_policy (p_line_cd         GIPI_PACK_PARLIST.line_cd%TYPE,
									   p_iss_cd          GIPI_PACK_PARLIST.iss_cd%TYPE,
									   p_module_id       GIIS_USER_GRP_MODULES.module_id%TYPE,
									   p_user_id         GIIS_USERS.user_id%TYPE,
									   p_all_user_sw     VARCHAR2,
									   p_par_yy          GIPI_PACK_PARLIST.par_yy%TYPE,
									   p_par_seq_no      GIPI_PACK_PARLIST.par_seq_no%TYPE,
									   p_quote_seq_no    GIPI_PACK_PARLIST.quote_seq_no%TYPE,
									   p_assd_name       GIIS_ASSURED.assd_name%TYPE,
									   p_underwriter     GIPI_PACK_PARLIST.underwriter%TYPE,
									   p_status          VARCHAR2,
									   p_bank_ref_no     GIPI_PACK_WPOLBAS.bank_ref_no%TYPE,
									   p_ri_switch		 VARCHAR2)
  
  RETURN gipi_pack_parlist_tab PIPELINED;

FUNCTION get_gipi_pack_parlist_endt  (p_line_cd         GIPI_PACK_PARLIST.line_cd%TYPE,
									  p_iss_cd          GIPI_PACK_PARLIST.iss_cd%TYPE,
									  p_module_id       GIIS_USER_GRP_MODULES.module_id%TYPE,
									  p_user_id         GIIS_USERS.user_id%TYPE,
									  p_all_user_sw     VARCHAR2,
									  p_par_yy          GIPI_PACK_PARLIST.par_yy%TYPE,
									  p_par_seq_no      GIPI_PACK_PARLIST.par_seq_no%TYPE,
									  p_quote_seq_no    GIPI_PACK_PARLIST.quote_seq_no%TYPE,
									  p_assd_name       GIIS_ASSURED.assd_name%TYPE,
									  p_underwriter     GIPI_PACK_PARLIST.underwriter%TYPE,
									  p_status          VARCHAR2,
									  p_bank_ref_no     GIPI_PACK_WPOLBAS.bank_ref_no%TYPE,
									  p_ri_switch		VARCHAR2)
  
  RETURN gipi_pack_parlist_tab PIPELINED;

PROCEDURE update_assd_no
(p_pack_par_id          IN      GIPI_PACK_PARLIST.pack_par_id%TYPE,
 p_assd_no              IN      GIPI_PACK_PARLIST.assd_no%TYPE);
 
FUNCTION get_pack_par_no (p_pack_par_id NUMBER)
      RETURN VARCHAR2;
               
    PROCEDURE check_package_cancellation (
        p_ann_tsi           OUT NUMBER,
        p_pack_par_id        IN gipi_parlist.pack_par_id%TYPE
        );
		
	TYPE pack_parlist_giuts008a_type IS RECORD (
		line_cd		 gipi_pack_polbasic.line_cd%TYPE,
		iss_cd		 gipi_pack_polbasic.iss_cd%TYPE,
		par_yy		 NUMBER,
		par_type	 gipi_pack_parlist.par_type%TYPE,
		assd_no		 gipi_pack_parlist.assd_no%TYPE,
		address1	 gipi_pack_parlist.address1%TYPE,
		address2	 gipi_pack_parlist.address2%TYPE,
		address3	 gipi_pack_parlist.address3%TYPE,
		pol_iss_cd   gipi_polbasic.iss_cd%TYPE
	);
	
	TYPE pack_parlist_giuts008a_tab IS TABLE OF pack_parlist_giuts008a_type;
	
	FUNCTION get_pack_parlist_giuts008a (
		p_policy_id		gipi_pack_polbasic.pack_policy_id%TYPE
	)
     	RETURN pack_parlist_giuts008a_tab PIPELINED;
		
	PROCEDURE insert_pack_parlist_giuts008a (
		p_pack_par_id	IN	gipi_pack_parlist.pack_par_id%TYPE,
		p_line_cd		IN	gipi_pack_parlist.line_cd%TYPE,
		p_iss_cd		IN	gipi_pack_parlist.iss_cd%TYPE,
		p_par_yy		IN	gipi_pack_parlist.par_yy%TYPE,
		p_par_type		IN	gipi_pack_parlist.par_type%TYPE,
		p_assd_no		IN	gipi_pack_parlist.assd_no%TYPE,
		p_underwriter	IN	gipi_pack_parlist.underwriter%TYPE,
		p_address1		IN	gipi_pack_parlist.address1%TYPE,
		p_address2		IN	gipi_pack_parlist.address2%TYPE,
		p_address3		IN	gipi_pack_parlist.address3%TYPE
	);
    
    FUNCTION check_pack_peril (
      p_item_no   gipi_witmperl.item_no%TYPE,
      p_par_id    gipi_witmperl.par_id%TYPE
   )
      RETURN NUMBER;
		                      
END Gipi_Pack_Parlist_Pkg;
/


