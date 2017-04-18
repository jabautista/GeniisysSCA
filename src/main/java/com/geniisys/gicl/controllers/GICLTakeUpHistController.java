package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.framework.util.QueryParamGenerator;
import com.geniisys.gicl.service.GICLTakeUpHistService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GICLTakeUpHistController", urlPatterns={"/GICLTakeUpHistController"})
public class GICLTakeUpHistController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(GICLTakeUpHistController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			log.info("Initializing :"+this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GICLTakeUpHistService giclTakeUpHistService = (GICLTakeUpHistService) APPLICATION_CONTEXT.getBean("giclTakeUpHistService");

			if ("showBatchOsLoss".equals(ACTION)) {
				Date maxAcctDate = giclTakeUpHistService.getMaxAcctDate();
				request.setAttribute("maxAcctDate", maxAcctDate);
				PAGE = "/pages/claims/batchOsLoss/batchOsLoss.jsp";
			}else if("validateTranDate".equals(ACTION)){
				DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				Date tranDate = request.getParameter("tranDate").equals("") ? null : df.parse(request.getParameter("tranDate"));
				params.put("tranDate", tranDate);
				params = giclTakeUpHistService.validateTranDate(params);
				message = QueryParamGenerator.generateQueryParams(params);
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("bookOsGICLB001".equals(ACTION)){
				DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				Date dspDate = request.getParameter("dspDate").equals("") ? null : df.parse(request.getParameter("dspDate"));
				params.put("dspDate", dspDate);
				params.put("userId", USER.getUserId());
				log.info(params);
				params = giclTakeUpHistService.bookOsGICLB001(params);
				message = QueryParamGenerator.generateQueryParams(params);
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("showPrintBatchOS".equals(ACTION)) {
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				String printerNames = "";
				for (int i = 0; i < printers.length; i++){
					printerNames = printerNames + printers[i].getName();
					if (i != printers.length - 1){
						printerNames = printerNames + ",";
					}
				}
				request.setAttribute("printerNames", printerNames);
				PAGE = "/pages/claims/batchOsLoss/subPages/printBatchOsAcctngEntries.jsp";
			}
			
		} catch(SQLException e) {
			int code = e.getErrorCode();
			if(code > 20000){
				String cause = e.getCause().toString();
				String[] causeLines = cause.split("ORA");
				message = "ERROR:" + causeLines[1].substring(causeLines[1].indexOf(" "), causeLines[1].length());
			} else {
				message = ExceptionHandler.handleException(e, USER);			
			}	
			PAGE = "/pages/genericMessage.jsp";	
		} catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}
	
	

}
