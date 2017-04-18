CREATE OR REPLACE PACKAGE CPI.Uw_Prod_Excel IS

PROCEDURE excel_gipir924_mx(p_scope           NUMBER,
                            p_line_cd         VARCHAR2,
                            p_subline_cd      VARCHAR2,
                            p_iss_cd          VARCHAR2,
                            p_iss_param       VARCHAR2,
                            p_file_name      VARCHAR2);

PROCEDURE excel_gipir923_mx(p_scope           NUMBER,
             		        p_line_cd         VARCHAR2,
                            p_subline_cd      VARCHAR2,
                            p_iss_cd          VARCHAR2,
                            p_iss_param       VARCHAR2,
					        p_file_name       VARCHAR2);

PROCEDURE excel_gipir924J_mx(p_scope           NUMBER,
             	             p_line_cd         VARCHAR2,
                             p_subline_cd      VARCHAR2,
                             p_iss_cd          VARCHAR2,
                             p_iss_param       VARCHAR2,
							 p_file_name       VARCHAR2);
							 
PROCEDURE excel_gipir923J_mx(p_scope           NUMBER,
                             p_line_cd         VARCHAR2,
                             p_subline_cd      VARCHAR2,
                             p_iss_cd          VARCHAR2,
                             p_iss_param       VARCHAR2,
						     p_file_name       VARCHAR2);

PROCEDURE excel_gipir929A_mx(p_scope           NUMBER,
             		         p_line_cd         VARCHAR2,
                             p_subline_cd      VARCHAR2,
                             p_iss_cd          VARCHAR2,
                             p_iss_param       VARCHAR2,
                             p_intm_no         NUMBER,
                             p_assd_no         NUMBER,
                             p_ri_cd           VARCHAR2,
							 p_file_name       VARCHAR2);
							 
PROCEDURE excel_gipir929B_mx(p_scope           NUMBER,
                             p_line_cd         VARCHAR2,
                             p_subline_cd      VARCHAR2,
                             p_iss_cd          VARCHAR2,
                             p_iss_param       VARCHAR2,
                             p_intm_no         NUMBER,
                             p_assd_no         NUMBER,
                             p_ri_cd           VARCHAR2,
							 p_file_name       VARCHAR2);
							 
PROCEDURE excel_gipir923B_mx(p_scope          NUMBER,
             			    p_line_cd         VARCHAR2,
                            p_subline_cd      VARCHAR2,
                            p_iss_cd          VARCHAR2,
                            p_iss_param       VARCHAR2,
                            p_intm_no         NUMBER,
                            p_assd_no         NUMBER,
                            p_intm_type       VARCHAR2,
	   					    p_file_name       VARCHAR2);

PROCEDURE excel_gipir924B_mx(p_scope           NUMBER,
                             p_line_cd         VARCHAR2,
                             p_subline_cd      VARCHAR2,
                             p_iss_cd          VARCHAR2,
                             p_iss_param       VARCHAR2,
                             p_intm_no         NUMBER,
                             p_assd_no         NUMBER,
                             p_intm_type       VARCHAR2,
							 p_file_name       VARCHAR2);
							 
PROCEDURE excel_gipir924E_mx(p_line_cd         VARCHAR2,
                             p_subline_cd      VARCHAR2,
                             p_iss_cd          VARCHAR2,
                             p_iss_param       VARCHAR2,
							 p_file_name	   VARCHAR2);							 
							 
	

END;
/


