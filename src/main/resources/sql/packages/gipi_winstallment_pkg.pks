CREATE OR REPLACE PACKAGE CPI.gipi_winstallment_pkg
AS
   TYPE gipi_winstallment_type IS RECORD (
      par_id             gipi_winstallment.par_id%TYPE,
      item_grp           gipi_winstallment.item_grp%TYPE,
      takeup_seq_no      gipi_winstallment.takeup_seq_no%TYPE,
      inst_no            gipi_winstallment.inst_no%TYPE,
      due_date           gipi_winstallment.due_date%TYPE,
      share_pct          gipi_winstallment.share_pct%TYPE,
      prem_amt           gipi_winstallment.prem_amt%TYPE,
      tax_amt            gipi_winstallment.tax_amt%TYPE,
      total_due          NUMBER,
      total_share_pct    NUMBER,
      total_prem_amt     NUMBER,
      total_tax_amt      NUMBER,
      total_amount_due   NUMBER
   );

   TYPE gipi_winstallment_tab IS TABLE OF gipi_winstallment_type;

   FUNCTION get_gipi_winstallment (
      p_par_id          gipi_winstallment.par_id%TYPE,
      p_item_grp        gipi_winstallment.item_grp%TYPE,
      p_takeup_seq_no   gipi_winstallment.takeup_seq_no%TYPE
   )
      RETURN gipi_winstallment_tab PIPELINED;

   PROCEDURE set_gipi_winstallment (p_winstallment gipi_winstallment%ROWTYPE);

   PROCEDURE del_gipi_winstallment (
      p_par_id     gipi_winstallment.par_id%TYPE,
      p_item_grp   gipi_winstallment.item_grp%TYPE
   );

   /*
   **  Modified by      : Mark JM
   **  Date Created  : 02.11.2010
   **  Reference By  : (GIPIS010 - Item Information)
   **  Description   : Delete record by supplying the par_id only
   */
   PROCEDURE del_gipi_winstallment_1 (p_par_id gipi_winstallment.par_id%TYPE);

   TYPE gipi_winstallment_cols IS RECORD (
      par_id          gipi_winstallment.par_id%TYPE,
      item_grp        gipi_winstallment.item_grp%TYPE,
      takeup_seq_no   gipi_winstallment.takeup_seq_no%TYPE,
      inst_no         gipi_winstallment.inst_no%TYPE,
      due_date        gipi_winstallment.due_date%TYPE,
      share_pct       gipi_winstallment.share_pct%TYPE,
      prem_amt        gipi_winstallment.prem_amt%TYPE,
      tax_amt         gipi_winstallment.tax_amt%TYPE
   );

   TYPE gipi_winstallment_cur IS REF CURSOR
      RETURN gipi_winstallment_cols;
	  
 FUNCTION get_all_gipi_winstallment (
      p_par_id          gipi_winstallment.par_id%TYPE
   )
      RETURN gipi_winstallment_tab PIPELINED;	  
	  
PROCEDURE CALC_PAYMENT_SCHED_GIPIS017B(
	   	  		  p_par_id            IN     GIPI_PARLIST.par_id%TYPE,    
                  p_payt_term        IN GIIS_PAYTERM.payt_terms%TYPE,    
                  p_prem_amt        IN GIPI_WINVOICE.prem_amt%TYPE,  
                  p_tax_amt            IN GIPI_WINVOICE.tax_amt%TYPE
				  );	  
/**
	 Created By Irwin Tabisora
       Date: 5.25.2012
       Description: removed the deletion of gipi_winstallment
*/				  
PROCEDURE CALC_PAYMENT_SCHED_GIPIS017B_2(
	   	  		  p_par_id			IN	 GIPI_PARLIST.par_id%TYPE,		
				  p_prem_amt		IN GIPI_WINVOICE.prem_amt%TYPE,  
				  p_tax_amt		    IN GIPI_WINVOICE.tax_amt%TYPE
				  );				  
END gipi_winstallment_pkg;
/


