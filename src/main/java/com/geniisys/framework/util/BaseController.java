/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.framework.util;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.print.PrintException;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRParameter;
import net.sf.jasperreports.engine.JRVirtualizationHelper;
import net.sf.jasperreports.engine.JRVirtualizer;
import net.sf.jasperreports.engine.fill.JRFileVirtualizer;
import net.sf.jasperreports.engine.fill.JRSwapFileVirtualizer;
import net.sf.jasperreports.engine.util.JRSwapFile;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.springframework.context.ApplicationContext;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.report.PrintingUtil;
import com.geniisys.common.report.ReportGenerator;
import com.geniisys.csv.util.CSVUtil;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;


/**
 * The Class BaseController.
 */
public abstract class BaseController extends HttpServlet implements Servlet{

	/** The PAGE. */
	protected String PAGE = "/pages/genericMessage.jsp";
	
	/** The message. */
	protected String message = "Exception occured.";
	
	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -6973163923792331996L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(BaseController.class);
	
	private HttpSession SESSION;
	
	/**
	 * Instantiates a new base controller.
	 */
	public BaseController() {
		super();		
	}

	/* (non-Javadoc)
	 * @see javax.servlet.http.HttpServlet#doGet(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response)	throws 
	IOException, ServletException	{	
		this.doInitialize(request, response);
	}

	/* (non-Javadoc)
	 * @see javax.servlet.http.HttpServlet#doPost(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	@Override
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws 
	IOException, ServletException	{
		this.doInitialize(request, response);
	}

	/**
	 * Do initialize.
	 * 
	 * @param request the request
	 * @param response the response
	 * @throws IOException Signals that an I/O exception has occurred.
	 * @throws ServletException the servlet exception
	 */
	@SuppressWarnings("unchecked")
	public void doInitialize(HttpServletRequest request, HttpServletResponse response) throws
	IOException, ServletException {	
		
		SESSION = request.getSession();
		SESSION.setAttribute("IP ADDRESS", request.getRemoteAddr());
		
		Map<String, Object> SESSION_PARAMETERS = (Map<String, Object>) SESSION.getAttribute("PARAMETERS");
		GIISUser USER = null;
		if (null!=SESSION_PARAMETERS){
			USER = (GIISUser) SESSION_PARAMETERS.get("USER");
			USER = (GIISUser) StringFormatter.escapeHTMLInObject2(USER);
		}
		
		String ACTION = request.getParameter("action");
		String AJAX = request.getParameter("ajax");
		String AJAX_MODAL = request.getParameter("ajaxModal");
		String overlay = request.getParameter("overlay");

		log.info("ACTION: " + ACTION);		
		if ("login".equalsIgnoreCase(ACTION) 
			|| "showLogin".equalsIgnoreCase(ACTION) 
			|| "forgotPassword".equalsIgnoreCase(ACTION) 
			|| "showChangePassword".equalsIgnoreCase(ACTION) 
			|| "firstLoginChangePassword".equalsIgnoreCase(ACTION)
			|| "setNoPassword".equalsIgnoreCase(ACTION)
			|| "showAboutGeniisys".equalsIgnoreCase(ACTION)
			|| "getPasswordStrength".equals(ACTION)){
			USER = null;
			if ("login".equalsIgnoreCase(ACTION)) {
				if (null==SESSION_PARAMETERS){
					SESSION_PARAMETERS = new HashMap<String, Object>();
				}
				SESSION.setAttribute("PARAMETERS", SESSION_PARAMETERS);
			}
			this.doProcessing(request, response, USER, ACTION, SESSION);
		} else if ("logout".equalsIgnoreCase(ACTION)){
			USER = null;
			this.doProcessing(request, response, USER, ACTION, SESSION);
		} else if ("getServerDateAndTime".equals(ACTION)) {
			this.doProcessing(request, response, USER, ACTION, SESSION);
		} else {
			if(null==USER && !ACTION.equalsIgnoreCase("setLocale")){
				if("1".equals(AJAX)){
					this.doDispatch(request, response, "/pages/errorPages/sessionExpired.jsp");
				} else if ("1".equals(AJAX_MODAL))	{
					this.doDispatch(request, response, "/pages/errorPages/sessionExpiredPopup.jsp");
				} else if ("1".equals(overlay)) {
					this.doDispatch(request, response, "/pages/errorPages/sessionExpiredOverlay.jsp");
				} else {
					this.logOut(request, response);
				}
			} else	{
				this.doProcessing(request, response, USER, ACTION, SESSION);
			}
		}
	}

	/**
	 * Do processing.
	 * 
	 * @param request the request
	 * @param response the response
	 * @param USER the uSER
	 * @param ACTION the aCTION
	 * @param SESSION the sESSION
	 * @throws ServletException the servlet exception
	 * @throws IOException Signals that an I/O exception has occurred.
	 */
	public abstract void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION, HttpSession SESSION) throws ServletException, IOException;

	/**
	 * Do ajax response.
	 * 
	 * @param request the request
	 * @param response the response
	 * @param ajaxResponse the ajax response
	 */
	public void doAjaxResponse(HttpServletRequest request, HttpServletResponse response, String ajaxResponse)	{
		response.setContentType("text/html");
		response.setHeader("Cache-Control", "no-cache");
		PrintWriter writer=null;
		try {
			writer = response.getWriter();
		} catch (IOException e) {
			ajaxResponse = "Error writing ajax response";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
		if (null!=ajaxResponse){
			ajaxResponse = ajaxResponse.replaceAll("\n", "");
			ajaxResponse = ajaxResponse.replaceAll("\r", "");
		}
		writer.write(ajaxResponse);
		writer.close();
	}

	/**
	 * Do dispatch.
	 * 
	 * @param request the request
	 * @param response the response
	 * @param PAGE the pAGE
	 */
	public void doDispatch(HttpServletRequest request, HttpServletResponse response, String PAGE) {
		log.info("Dispatching to: " + PAGE);
		
		// Set to expire far in the past.
		response.setHeader("Expires", "Sat, 6 May 1995 12:00:00 GMT");

		// Set standard HTTP/1.1 no-cache headers.
		response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");

		// Set IE extended HTTP/1.1 no-cache headers (use addHeader).
		response.addHeader("Cache-Control", "post-check=0, pre-check=0");

		// Set standard HTTP/1.0 no-cache header.
		response.setHeader("Pragma", "no-cache");
		
		try {
			getServletContext().getRequestDispatcher(PAGE).forward(request, response);
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
	}

	/**
	 * Log out.
	 * 
	 * @param request the request
	 * @param response the response
	 */
	public void logOut(HttpServletRequest request, HttpServletResponse response){
		log.info("Logging out");
		request.getSession().invalidate();
		String PAGE = "/pages/errorPages/sessionExpired.jsp";
		this.doDispatch(request, response, PAGE);
	}

	// tweak to invalidate user session
	// solution to the problem na hindi nasa-signout si user pag nagrestart ng server.
	public void destroy() {
		System.out.println("Destroying user session...");
		SESSION.invalidate();
	}
	// Commented on 01/13/2010 by Whofeih
	/*private Map<String, String> generateDatabaseEnv(ServletContext ctx){
		PropertiesUtil util = new PropertiesUtil();
		Map<String, String> map = null;
		try {
			map = util.getDatabaseEnvironments(ctx);
		} catch (IOException e) {
			log.error("Exception caught. " + e.getMessage());
			log.debug(Arrays.toString(e.getStackTrace()));
		} 
		return map;
	}

	private String checkDatabaseEnv(String database, ServletContext ctx){
		String result = null;
		Map<String, String> env = generateDatabaseEnv(ctx);
		Iterator<String> iter = env.keySet().iterator();
		while (iter.hasNext()){
			String key = iter.next();
			if (database.equalsIgnoreCase(env.get(key))){
				result = key;
				break;
			}			
		}
		return result;
	}*/
		
	@SuppressWarnings("unchecked")
	public void doPrintReport(HttpServletRequest request, HttpServletResponse response, Map<String, Object> params, String reportDir) throws JRException, SQLException, IOException, ServletException, PrintException, ParseException, JSONException{
		ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
		DataSourceTransactionManager client = (DataSourceTransactionManager) appContext.getBean("transactionManager");
		DriverManagerDataSource dataSource = (DriverManagerDataSource) appContext.getBean("dataSource");
		// used JRSwapFileVirtualizer instead of JRFileVirtualizer so that only one file will be created : shan 09.05.2014
		JRSwapFile swapFile = new JRSwapFile(getServletContext().getInitParameter("GENERATED_REPORTS_DIR"), 2048, 1024);	
		JRVirtualizer virtualizer = new JRSwapFileVirtualizer(5, swapFile, true);	// set to true for single owner use
		JRVirtualizationHelper.setThreadVirtualizer(virtualizer);
		//JRFileVirtualizer virtualizer = new JRFileVirtualizer(1000, getServletContext().getInitParameter("GENERATED_REPORTS_DIR"));
		System.out.println("Virtualizer generated files directory : ======= " + getServletContext().getInitParameter("GENERATED_REPORTS_DIR"));
		params.put(JRParameter.REPORT_VIRTUALIZER, virtualizer); 
		params.put(JRParameter.IS_IGNORE_PAGINATION, new Boolean(false)); // set to false for virtualizer to work
		
		try {
			Map<String, Object> SESSION_PARAMETERS = (Map<String, Object>) SESSION.getAttribute("PARAMETERS");			
			GIISUser USER = null;
			if (null!=SESSION_PARAMETERS){
				USER = (GIISUser) SESSION_PARAMETERS.get("USER");
			}
			
			params.put("P_USER_ID", USER.getUserId());
			params.put("P_SUBREPORT_DIR", reportDir);
			params.put("SUBREPORT_DIR", reportDir);
			params.put("GENERATED_REPORT_DIR", getServletContext().getInitParameter("GENERATED_REPORTS_DIR"));
			params.put("CONNECTION", client.getDataSource().getConnection());
			
			if((request.getParameter("destination") != null && request.getParameter("destination").equalsIgnoreCase("local")) || (request.getParameter("destination") != null && "file".equalsIgnoreCase(request.getParameter("destination")))){
				SimpleDateFormat sdf = new SimpleDateFormat("MMddyyyHHmmss");
				StringBuilder outputFileName =  new StringBuilder(params.get("OUTPUT_REPORT_FILENAME").toString());
				outputFileName.append("_");
				outputFileName.append(sdf.format(new Date()));
				
				params.put("OUTPUT_REPORT_FILENAME", outputFileName);
			}
			
			String reportId = request.getParameter("reportId");
			if(request.getParameter("destination") != null && request.getParameter("destination").equalsIgnoreCase("local")){
				ReportGenerator.generateJRPrintFileToServer(request.getSession().getServletContext().getRealPath(""), params);
				message = request.getHeader("Referer")+"reports/"+params.get("OUTPUT_REPORT_FILENAME")+".jrprint";
				request.setAttribute("message", message.replace(" ", ""));
				PAGE = "/pages/genericMessage.jsp";
				this.doDispatch(request, response, PAGE);
			}else if(request.getParameter("destination") != null && "file".equalsIgnoreCase(request.getParameter("destination") )){
				params.put("fileType", request.getParameter("fileType"));
				System.out.println("------------------" + request.getParameter("fileType"));
				if(request.getParameter("fileType") == null || "PDF".equalsIgnoreCase(request.getParameter("fileType"))){
					System.out.println("FILE TYPE: PDF");
					ReportGenerator.generatePdfFileToServer(request.getSession().getServletContext().getRealPath(""), params);
					message = request.getHeader("Referer")+"reports/"+params.get("OUTPUT_REPORT_FILENAME")+".pdf";
				} else if("CSV".equalsIgnoreCase(request.getParameter("fileType").toString())){
					System.out.println("FILE TYPE: CSV");
					String[] databaseInfo = dataSource.getUrl().split(":");
					params.put("databaseName", databaseInfo[5]);
					params.put("ip", databaseInfo[3].replaceAll("@", ""));
					params.put("username",dataSource.getUsername());
					params.put("password",dataSource.getPassword());
					if(params.get("csvAction") == null || params.get("csvAction") == ""){
						message = reportId + "@CSV OPTION IS NOT AVAILABLE";
					} else { System.out.println("PARAMS::::::"+params);
						params.put("realPath", request.getSession().getServletContext().getRealPath(""));
						CSVUtil.createCSV(params);
						message = request.getHeader("Referer")+"csv/"+params.get("OUTPUT_REPORT_FILENAME")+".csv";
					}
					
				} else if("XLS".equalsIgnoreCase(request.getParameter("fileType").toString())){
					System.out.println("FILE TYPE: XLS");
					// add to prevent OutOfMemoryError : shan 05.13.2014; moved above : shan 09.05.2014					
					/*JRFileVirtualizer virtualizer = new JRFileVirtualizer(100, getServletContext().getInitParameter("GENERATED_REPORTS_DIR"));
					params.put(JRParameter.REPORT_VIRTUALIZER, virtualizer); 
					params.put(JRParameter.IS_IGNORE_PAGINATION, new Boolean(false)); // set to false for virtualizer to work*/
					// end shan 05.13.2014
					
					params.put("filePath", params.get("GENERATED_REPORT_DIR").toString()+reportId+".xls");
					params.put("realPath", request.getSession().getServletContext().getRealPath(""));
					ReportGenerator reportGenerator = new ReportGenerator();
					if(request.getParameter("multiSheet") != null && request.getParameter("multiSheet").equals("Y")){ //marco - 03.05.2015
						params.put(JRParameter.IS_IGNORE_PAGINATION, new Boolean(true));
						params.put("reportList", request.getParameter("reportList"));
						reportGenerator.generateMultiSheetReport(params);
					}else{
						reportGenerator.generateReport(params);
					}
					//virtualizer.cleanup();
					message = request.getHeader("Referer")+"reports/"+params.get("OUTPUT_REPORT_FILENAME")+".xls";					
				} else{ //Dren Niebres SR-5374 04.26.2016 - Start
					System.out.println("FILE TYPE: CSV2");
					
					params.put("filePath", params.get("GENERATED_REPORT_DIR").toString()+reportId+".csv");
					params.put("realPath", request.getSession().getServletContext().getRealPath(""));
					ReportGenerator reportGenerator = new ReportGenerator();
					reportGenerator.generateReport(params);

					message = request.getHeader("Referer")+"reports/"+params.get("OUTPUT_REPORT_FILENAME")+".csv";				
				} // Dren Niebres SR-5374 04.26.2016 - End
				
				System.out.println("URL RESPONSE : " + message.replace(" ", ""));
				request.setAttribute("message", message.replace(" ", ""));
				PAGE = "/pages/genericMessage.jsp";
				this.doDispatch(request, response, PAGE);
			}else{
				if("true".equals(request.getParameter("checkIfReportExists"))){
					File fileName = new File(params.get("P_SUBREPORT_DIR").toString() + params.get("MAIN_REPORT").toString());
					if(fileName.isFile()){
						message = "reportExists";
					} else {
						StringBuilder str = new StringBuilder();
						String report = params.get("reportName").toString();
						str.append("The report");
						if(!report.isEmpty()){
							str.append(" (");
							str.append(report);
							str.append(")");
						}
						str.append(" you are trying to generate does not exist.");
						message = str.toString();
					}
					
					request.setAttribute("message", message);
					PAGE = "/pages/genericMessage.jsp";
					this.doDispatch(request, response, PAGE);
				} else {
					PrintingUtil printingUtil = new PrintingUtil();
					printingUtil.startReportGeneration(params, response, request);
				}
			}
		} finally {
			ConnectionUtil.releaseConnection(client);
			swapFile.dispose();
			virtualizer.cleanup();
		}
	}
	
	public void setPrintErrorMessage(HttpServletRequest request, GIISUser USER, Exception e){
		message = ExceptionHandler.handleException(e, USER);
		PAGE = "/pages/genericMessage.jsp";
		if(request.getParameter("destination") != null 
				&& (request.getParameter("destination").equalsIgnoreCase("local") 
						|| request.getParameter("destination").equalsIgnoreCase("file"))
						|| (null != request.getParameter("printerName")  
							&& "" != request.getParameter("printerName") 
							&& !("---".equals(request.getParameter("printerName"))))) {
			request.setAttribute("message", message);
		} else if(request.getParameter("reportId") != null && !request.getParameter("reportId").isEmpty()) {
			request.setAttribute("message", message.substring(23));
		} else {
			request.setAttribute("message", message);
		}
	}
	
}