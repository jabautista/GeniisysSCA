/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.controllers;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.report.ReportGenerator;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ConnectionUtil;
import com.geniisys.framework.util.LOVHelper;
import com.seer.framework.util.ApplicationContextReader;


/**
 * The Class PrintController.
 */
public class PrintController extends BaseController {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 3338573888827807115L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(PrintController.class);	
	
	private PrintServiceLookup printServiceLookup;

	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@Override
	@SuppressWarnings({ "unchecked", "unused", "static-access" })
	public void doProcessing(HttpServletRequest request, 
			HttpServletResponse response, 
			GIISUser USER, String ACTION, HttpSession SESSION) throws ServletException, IOException { //, String env
		
		DataSourceTransactionManager client = null;
		
		try {
			/*default attributes*/
			log.info("Initializing: "+ this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			//String PAGE = "";
			Map<String, Object> RETURN_PARAMETERS;
			Map<String, Object> SESSION_PARAMETERS = (Map<String, Object>) SESSION.getAttribute("PARAMETERS");
			String GENERIC_RESPONSE = "";
			String AJAX_RESPONSE = "";
			/*end of default attributes*/

			StringBuilder output = new StringBuilder();
			String message="";
			
			//log.info("Environment:"); // +env
			LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
			client = (DataSourceTransactionManager) APPLICATION_CONTEXT.getBean("transactionManager"); // +env
			
			if("print".equals(ACTION)){
				int quoteId = Integer.valueOf(request.getParameter("quoteId"));
				ReportGenerator generator = new ReportGenerator();
				Map<String, Object> params = new HashMap<String, Object>();
				
				params.put("SUBREPORT_DIR", getServletContext().getInitParameter("SUBREPORT_DIR"));		
				
				params.put("attention_to", 		request.getParameter("attentionTo")==null?"":request.getParameter("attentionTo"));
				params.put("attention_position",request.getParameter("attentionPosition")==null?"":request.getParameter("attentionPosition"));
				params.put("closing_words", 	request.getParameter("closingWords")==null?"":request.getParameter("closingWords"));
				params.put("signatory", 		request.getParameter("signatory")==null?"":request.getParameter("signatory"));
				params.put("designation", 		request.getParameter("designation")==null?"":request.getParameter("designation"));
				
				params.put("userId", USER.getUserId());
				
				Connection conn = null;
				
				conn = client.getDataSource().getConnection();
				log.info("Connection:"+ conn);
				log.info("Connection Close:"+conn.isClosed());
				params.put("connection", conn);
				
				/*if(generator.generate(quoteId, params)){
					if(null!=conn){
						conn.close();
					}
					String filePath = "c:/GENIISYS_WEB/REPORTS/sample.pdf";
					FileInputStream fis;
					byte[] pdfByte = null;

					// read file
					fis = new FileInputStream(filePath);
					pdfByte = new byte[fis.available()];
					fis.read(pdfByte);
					fis.close();
					
					// if file is not empty
					if (null==pdfByte) {
						message = "Failed to generate quotation information report...";
						request.setAttribute("message", message);
						this.doDispatch(request, response, "/pages/genericMessage.jsp");
					} else {
						if (pdfByte.length>0){
							File newFile = File.createTempFile("quotation", ".pdf");
							FileOutputStream os = new FileOutputStream(newFile);
							System.out.println("byte size:" + pdfByte.length);
							os.write(pdfByte);
							os.flush();
							os.close();
							ServletOutputStream out = response.getOutputStream();
							response.setContentType("application/pdf");
							ByteArrayInputStream bais = new ByteArrayInputStream(pdfByte);
							int i = 0;
							while ((i = bais.read()) != -1) {
								out.write(i);
							}
							out.flush();
							out.close();
						}
					}
				}*/
				this.doDispatch(request, response, PAGE);
			} else if ("showPrintOptions".equals(ACTION) || "showPolicyLostBidsReportsPrintOptions".equals(ACTION)) {
				System.out.println("----------- "+ACTION+" -----------");
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				String printerNames = "";
				for (int i = 0; i < printers.length; i++){
					printerNames = printerNames + printers[i].getName();
					if (i != (printers.length-1)){
						printerNames = printerNames + ",";
					}
				}
				//request.setAttribute("lineCd", request.getParameter("vLineCd"));
				request.setAttribute("printerNames", printerNames);
				request.setAttribute("quoteId", request.getParameter("quoteId"));		
				String page = "";
				if ("showPrintOptions".equals(ACTION)){
					request.setAttribute("isPack", request.getParameter("isPack") == null? "N" : request.getParameter("isPack"));
					PAGE = "/pages/marketing/quotation/pop-ups/printOptions.jsp";
				} else if ("showPolicyLostBidsReportsPrintOptions".equals(ACTION)){
					String[] params = {"GIIMM007", USER.getUserId()};
					request.setAttribute("lineListing", lovHelper.getList(LOVHelper.LINE_LISTING, params));
					//request.setAttribute("intmListing", lovHelper.getList(LOVHelper.INTERMEDIARY_LISTING));
					request.setAttribute("intmListing", lovHelper.getList(LOVHelper.INTM_LISTING));
					PAGE = "/pages/marketing/quotation/pop-ups/lostBidPrintOptions.jsp";
				}
				//this.doDispatch(request, response, page);
			} else if ("deletePrintedReport".equals(ACTION)){
				String realPath = request.getSession().getServletContext().getRealPath("");
				String url = request.getParameter("url");
				String fileName = url.substring(url.lastIndexOf("/")+1, url.length());
				log.info("Deleting printed report " + fileName + "...");
				(new File(realPath + "\\reports\\" + fileName)).delete();
			}
		} catch (SQLException e) {
			log.error(e.getMessage());
			log.debug(Arrays.toString(e.getStackTrace()));			
			message = "SQL Exception occured...<br />"+e.getCause();
			request.setAttribute("message", message);
			PAGE = "/pages/genericMessage.jsp";
			//this.doDispatch(request, response, PAGE);
		} catch (Exception e) {
			log.error(e.getMessage());
			log.debug(Arrays.toString(e.getStackTrace()));
			message = "Failed to generate quotation information report...";
			request.setAttribute("message", message);
			PAGE = "/pages/genericMessage.jsp";
			//this.doDispatch(request, response, PAGE);
		} finally {
			ConnectionUtil.releaseConnection(client);
			this.doDispatch(request, response, PAGE);
		}
	}
}
