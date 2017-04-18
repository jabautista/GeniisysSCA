CREATE OR REPLACE PACKAGE CPI.Geniisysweb AS
 FUNCTION Extract_Incept_Date (p_line_cd     IN GIPI_POLBASIC.line_cd%TYPE,
                               p_subline_cd  IN GIPI_POLBASIC.line_cd%TYPE,
                               p_iss_cd      IN GIPI_POLBASIC.iss_cd%TYPE,
                               p_issue_yy    IN GIPI_POLBASIC.issue_yy%TYPE,
                               p_pol_seq_no  IN GIPI_POLBASIC.pol_seq_no%TYPE,
                               p_renew_no    IN GIPI_POLBASIC.renew_no%TYPE,
          p_loss_date   IN GICL_CLAIMS.loss_date%TYPE) RETURN DATE;
 FUNCTION extract_expiry_date (p_line_cd     IN GIPI_POLBASIC.line_cd%TYPE,
                            p_subline_cd  IN GIPI_POLBASIC.line_cd%TYPE,
                            p_iss_cd      IN GIPI_POLBASIC.iss_cd%TYPE,
                            p_issue_yy    IN GIPI_POLBASIC.issue_yy%TYPE,
                            p_pol_seq_no  IN GIPI_POLBASIC.pol_seq_no%TYPE,
                            p_renew_no    IN GIPI_POLBASIC.renew_no%TYPE,
          p_loss_date   IN GICL_CLAIMS.loss_date%TYPE) RETURN DATE;
 FUNCTION get_dsp_loss_date   (p_line_cd     IN GIPI_POLBASIC.line_cd%TYPE,
                            p_subline_cd  IN GIPI_POLBASIC.line_cd%TYPE,
                            p_iss_cd      IN GIPI_POLBASIC.iss_cd%TYPE,
                            p_issue_yy    IN GIPI_POLBASIC.issue_yy%TYPE,
                            p_pol_seq_no  IN GIPI_POLBASIC.pol_seq_no%TYPE,
                            p_renew_no    IN GIPI_POLBASIC.renew_no%TYPE,
          p_loss_date   IN VARCHAR2) RETURN VARCHAR2;

 FUNCTION Check_Total_Loss (p_line_cd     IN GIPI_POLBASIC.line_cd%TYPE,
                            p_subline_cd  IN GIPI_POLBASIC.line_cd%TYPE,
                            p_iss_cd      IN GIPI_POLBASIC.iss_cd%TYPE,
                            p_issue_yy    IN GIPI_POLBASIC.issue_yy%TYPE,
                            p_pol_seq_no  IN GIPI_POLBASIC.pol_seq_no%TYPE,
                            p_renew_no    IN GIPI_POLBASIC.renew_no%TYPE) RETURN VARCHAR2;          

 FUNCTION Check_Policy_No (p_line_cd     IN GIPI_POLBASIC.line_cd%TYPE,
                           p_subline_cd  IN GIPI_POLBASIC.line_cd%TYPE,
                           p_iss_cd      IN GIPI_POLBASIC.iss_cd%TYPE,
                           p_issue_yy    IN GIPI_POLBASIC.issue_yy%TYPE,
                           p_pol_seq_no  IN GIPI_POLBASIC.pol_seq_no%TYPE,
                           p_renew_no    IN GIPI_POLBASIC.renew_no%TYPE) RETURN VARCHAR2;

 FUNCTION Check_Loss_Date_Term (p_line_cd     IN GIPI_POLBASIC.line_cd%TYPE,
                                p_subline_cd  IN GIPI_POLBASIC.line_cd%TYPE,
                                p_iss_cd      IN GIPI_POLBASIC.iss_cd%TYPE,
                                p_issue_yy    IN GIPI_POLBASIC.issue_yy%TYPE,
                                p_pol_seq_no  IN GIPI_POLBASIC.pol_seq_no%TYPE,
                                p_renew_no    IN GIPI_POLBASIC.renew_no%TYPE,
           p_loss_date   VARCHAR2) RETURN VARCHAR2;

 FUNCTION Check_Loss_Date_Plate (p_line_cd     IN GIPI_POLBASIC.line_cd%TYPE,
                                 p_subline_cd  IN GIPI_POLBASIC.line_cd%TYPE,
                                 p_iss_cd      IN GIPI_POLBASIC.iss_cd%TYPE,
                                 p_issue_yy    IN GIPI_POLBASIC.issue_yy%TYPE,
                                 p_pol_seq_no  IN GIPI_POLBASIC.pol_seq_no%TYPE,
                                 p_renew_no    IN GIPI_POLBASIC.renew_no%TYPE,
                                 p_loss_date   IN VARCHAR2,
                                 p_plate_no    IN GICL_CLAIMS.plate_no%TYPE) RETURN VARCHAR2;

 FUNCTION Check_Duplicate_Claim (p_line_cd     IN GIPI_POLBASIC.line_cd%TYPE,
                                 p_subline_cd  IN GIPI_POLBASIC.line_cd%TYPE,
                                 p_iss_cd      IN GIPI_POLBASIC.iss_cd%TYPE,
                                 p_issue_yy    IN GIPI_POLBASIC.issue_yy%TYPE,
                                 p_pol_seq_no  IN GIPI_POLBASIC.pol_seq_no%TYPE,
                                 p_renew_no    IN GIPI_POLBASIC.renew_no%TYPE,
                                 p_loss_date   IN VARCHAR2,
                                 p_plate_no    IN GICL_CLAIMS.plate_no%TYPE) RETURN VARCHAR2;
        
 FUNCTION Check_Loss_Date_Issue_Date (p_line_cd     IN GIPI_POLBASIC.line_cd%TYPE,
                                      p_subline_cd  IN GIPI_POLBASIC.line_cd%TYPE,
                                      p_iss_cd      IN GIPI_POLBASIC.iss_cd%TYPE,
                                      p_issue_yy    IN GIPI_POLBASIC.issue_yy%TYPE,
                                      p_pol_seq_no  IN GIPI_POLBASIC.pol_seq_no%TYPE,
                                      p_renew_no    IN GIPI_POLBASIC.renew_no%TYPE,
                 p_loss_date   VARCHAR2) RETURN VARCHAR2;

 FUNCTION Check_Unpaid_Prem (p_line_cd     IN GIPI_POLBASIC.line_cd%TYPE,
                             p_subline_cd  IN GIPI_POLBASIC.line_cd%TYPE,
                             p_iss_cd      IN GIPI_POLBASIC.iss_cd%TYPE,
                             p_issue_yy    IN GIPI_POLBASIC.issue_yy%TYPE,
                             p_pol_seq_no  IN GIPI_POLBASIC.pol_seq_no%TYPE,
                             p_renew_no    IN GIPI_POLBASIC.renew_no%TYPE) RETURN VARCHAR2;
           
 FUNCTION Check_Plate_No (p_line_cd     IN GIPI_POLBASIC.line_cd%TYPE,
                          p_subline_cd  IN GIPI_POLBASIC.line_cd%TYPE,
                          p_iss_cd      IN GIPI_POLBASIC.iss_cd%TYPE,
                          p_issue_yy    IN GIPI_POLBASIC.issue_yy%TYPE,
                          p_pol_seq_no  IN GIPI_POLBASIC.pol_seq_no%TYPE,
                          p_renew_no    IN GIPI_POLBASIC.renew_no%TYPE,
        p_plate_no    IN GICL_CLAIMS.plate_no%TYPE) RETURN VARCHAR2;
 --Added by Jeff 12/04/2008      
 FUNCTION Check_Assured (p_assd_no     IN GIIS_ASSURED.assd_no%TYPE,
                           p_assd_name   IN GIIS_ASSURED.assd_name%TYPE) RETURN VARCHAR2;       
      

END;
/


DROP PACKAGE CPI.GENIISYSWEB;