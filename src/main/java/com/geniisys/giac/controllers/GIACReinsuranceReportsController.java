package com.geniisys.giac.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.common.service.GIISLineFacadeService;
import com.geniisys.common.service.GIISReinsurerService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.service.GIACReinsuranceReportsService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GIACReinsuranceReportsController",urlPatterns={"/GIACReinsuranceReportsController"})
public class GIACReinsuranceReportsController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = -8927466470513131046L;
	
	private PrintServiceLookup printServiceLookup;

	@Override
	@SuppressWarnings("static-access")
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIACReinsuranceReportsService giacReinsuranceReportsService = (GIACReinsuranceReportsService) APPLICATION_CONTEXT.getBean("giacReinsuranceReportsService");
			GIISLineFacadeService giisLineService = (GIISLineFacadeService) APPLICATION_CONTEXT.getBean("giisLineFacadeService");
			GIISReinsurerService giisReinsurerService = (GIISReinsurerService) APPLICATION_CONTEXT.getBean("giisReinsurerService");
			
			if ("showSchedRiFacul".equals(ACTION)) {
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/reinsurance/reports/schedDuetoRiFacultative/schedRiFacultative.jsp";
			}else if ("showInwardBusiness".equals(ACTION)) {
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/reinsurance/reports/schedDueFromRi/inwardBusiness/inwardBusiness.jsp";
			}else if ("showPremAssumedFromFaculRi".equals(ACTION)) {	// -gzelle 06.17.2013
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/reinsurance/reports/premAssumedFromFaculRi/premAssumedFromFaculRi.jsp";
			}else if ("getDates".equals(ACTION)){						// -gzelle 06.19.2013
				message = giacReinsuranceReportsService.getDates(request, USER).toString();
				PAGE = "/pages/genericMessage.jsp";	
			}else if ("extractToTable".equals(ACTION)) {				// -gzelle 06.18.2013
				message = giacReinsuranceReportsService.extractToTable(request, USER);
				//message = "Done";
				PAGE = "/pages/genericMessage.jsp";	
			}else if ("showPremCededTreaty".equals(ACTION)) {			// -gzelle 07.01.2013
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				Calendar cal=Calendar.getInstance();
				request.setAttribute("sysYear", cal.get(Calendar.YEAR));
				request.setAttribute("sysMonth", cal.get(Calendar.MONTH));
				PAGE = "/pages/accounting/reinsurance/reports/premCededTreaty/premCededTreaty.jsp";
			}else if ("validateIfExisting".equals(ACTION)) {			// -gzelle 07.01.2013
				message = giacReinsuranceReportsService.validateIfExisting(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("validateBeforeInsert".equals(ACTION)) {			// -gzelle 07.01.2013
				message = giacReinsuranceReportsService.validateBeforeInsert(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("deletePrevExtractedRecords".equals(ACTION)) {	// -gzelle 07.01.2013
				giacReinsuranceReportsService.deletePrevExtractedRecords(request, USER);
				message = "Deleted";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("extractRecordsToTable".equals(ACTION)) {			// -gzelle 07.01.2013
				message = giacReinsuranceReportsService.extractRecordsToTable(request, USER);
//				message = "Done";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getPrevParams".equals(ACTION)){						
				message = giacReinsuranceReportsService.getPrevParams(request, USER).toString();
				PAGE = "/pages/genericMessage.jsp";	
			}else if ("showLossRecovFacultative".equals(ACTION)) {
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/reinsurance/reports/schedDueFromRi/lossesRecoverable/facultative/lossRecovFacultative.jsp";
			}else if ("showpremCededToFacultativeRi".equals(ACTION)) {
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/reinsurance/reports/premCededToFacultativeRi/premCededToFacultativeRi.jsp";
			}else if ("giacs181ValidateBeforeExtract".equals(ACTION)) {
				message = giacReinsuranceReportsService.giacs181ValidateBeforeExtract(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("giacs181GetParams".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "giacs181GetParams");
				Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
				message = new JSONObject(map).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("giacs181ExtractToTable".equals(ACTION)) {
				JSONObject result = new JSONObject(giacReinsuranceReportsService.giacs181ExtractToTable(request,USER));
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("showPremDueToRIAsOf".equals(ACTION)) {
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				request.setAttribute("variables", new JSONObject(giacReinsuranceReportsService.getGIACS182Variables(USER.getUserId()))); //marco - 07.30.2014
				PAGE = "/pages/accounting/reinsurance/reports/premCededToFaculRIAsOf/premCededToFaculRIAsOf.jsp";
			}else if ("giacs182ValidateDateParams".equals(ACTION)) {
				message = giacReinsuranceReportsService.giacs182ValidateDateParams(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("extractGIACS182".equals(ACTION)){
				JSONObject result = new JSONObject(giacReinsuranceReportsService.extractGIACS182(request, USER));
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("showPremDueFromFaculRiAsOf".equals(ACTION)) {
				giacReinsuranceReportsService.showPremDueFromFaculRiAsOf(request,USER);
				PAGE = "/pages/accounting/reinsurance/reports/premDueFromFaculRiAsOf/premDueFromFaculRiAsOf.jsp";
			}else if ("giacs183ValidateBeforeExtract".equals(ACTION)) {
				message = giacReinsuranceReportsService.giacs183ValidateBeforeExtract(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("giacs183ExtractToTable".equals(ACTION)) {
				message = new JSONObject(giacReinsuranceReportsService.giacs183ExtractToTable(request, USER)).toString();
				PAGE = "/pages/genericMessage.jsp";
				
			//GIACS296
			}else if("showGIACS296Page".equals(ACTION)){
				PrintService printers[] = PrintServiceLookup.lookupPrintServices(null, null);
				// SR-3876, 3879 : shan 08.27.2015		
				Map<String, Object> dates = giacReinsuranceReportsService.getExtractDateGIACS296(USER.getUserId());
				request.setAttribute("asOfDate", dates == null ? "" : dates.get("asOfDate"));
				request.setAttribute("cutOffDate", dates == null ? "" : dates.get("cutOffDate"));
				// end SR-3876, 3879	
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/reinsurance/reports/statementOfAcctOutwardFaculRi/statementOfAcctOutwardFaculRi.jsp";
			}else if("validateGIACS296LineCd".equals(ACTION)){
				message = giisLineService.validateLineCd2(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateGIACS296RiCd".equals(ACTION)){
				message = giisReinsurerService.getReinsurerName(request.getParameter("riCd"));
				PAGE = "/pages/genericMessage.jsp";
			}else if("extractGIACS296".equals(ACTION)){
				//giacReinsuranceReportsService.extractGIACS296(request, USER.getUserId());
				message = giacReinsuranceReportsService.extractGIACS296(request, USER.getUserId()).toString(); //"SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("getExtractDateGIACS296".equals(ACTION)){	// SR-3876, 3879 : shan 08.27.2015				
				message = new JSONObject(giacReinsuranceReportsService.getExtractDateGIACS296(USER.getUserId())).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("getExtractCountGIACS296".equals(ACTION)){				
				message = giacReinsuranceReportsService.getExtractCountGIACS296(USER.getUserId()).toString();
				PAGE = "/pages/genericMessage.jsp";
			// end SR-3876, 3879 
			
			//GIACS279
			}else if("showGIACS279Page".equals(ACTION)){
				Map<String, Object> params = giacReinsuranceReportsService.getGIACS279InitialValues(USER.getUserId());
				PrintService printers[] = PrintServiceLookup.lookupPrintServices(null, null);
				
				//request.setAttribute("extractDate", params.get("extractDate"));
				request.setAttribute("asOfDate", params.get("asOfDate"));
				request.setAttribute("cutOffDate", params.get("cutOffDate"));
				request.setAttribute("riCd", params.get("riCd"));
				request.setAttribute("lineCd", params.get("lineCd"));
				request.setAttribute("clmPaytTag", params.get("clmPaytTag"));
				request.setAttribute("riName", params.get("riName"));
				request.setAttribute("lineName", params.get("lineName"));
				
				request.setAttribute("printers", printers);				
				PAGE = "/pages/accounting/reinsurance/reports/statementOfAcctLossesRecoverable/statementOfAcctLossesRecoverable.jsp";
			}else if("extractGIACS279".equals(ACTION)){
				JSONObject json = new JSONObject(giacReinsuranceReportsService.giacs279ExtractTable(request, USER.getUserId()));				
				request.setAttribute("object", json);
				PAGE = "/pages/genericObject.jsp";
			}else if("checkGIACS279Dates".equals(ACTION)){
				JSONObject json = new JSONObject(giacReinsuranceReportsService.checkGIACS279Dates(request.getParameter("btn"), USER.getUserId()));
				System.out.println(json.toString());
				request.setAttribute("object", json);
				PAGE = "/pages/genericObject.jsp";
				
			//GIACS274
			}else if("showGIACS274Page".equals(ACTION)){
				Map<String, Object> params = giacReinsuranceReportsService.checkGiacs274PrevExt(USER.getUserId());
				request.setAttribute("prevExtJSON", new JSONObject(params));
				
				PrintService printers[] = PrintServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/reinsurance/reports/listOfBindersAttachedToRedistRecords/listOfBindersAttachedToRedistRecords.jsp";
			}else if("validateGIACS274LineCd".equals(ACTION)){
				message = giisLineService.validateLineCd2(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateGIACS274BranchCd".equals(ACTION)){
				message = giacReinsuranceReportsService.validateGiacs274BranchCd(request.getParameter("branchCd"));
				PAGE = "/pages/genericMessage.jsp";
			}else if("extractGiacs274".equals(ACTION)){
				request.setAttribute("object", giacReinsuranceReportsService.extractGiacs274(request, USER.getUserId()));
				PAGE = "/pages/genericObject.jsp";
				
			}else if ("showStatementOfAcctFaculRi".equals(ACTION)) {	//Gzelle 07.19.2013
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				Map<String, Object> lastExtractSOAFaculRi = giacReinsuranceReportsService.getLastExtractSOAFaculRi(USER.getUserId());
				request.setAttribute("lastExtractSOAFaculRi", lastExtractSOAFaculRi);
				PAGE = "/pages/accounting/reinsurance/reports/statementOfAcctFaculRi/statementOfAcctFaculRi.jsp";				
			}else if ("extractSOAFaculRi".equals(ACTION)) {		
				message = giacReinsuranceReportsService.extractSOAFaculRi(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkLastExtractSOAFaculRi".equals(ACTION)){
				JSONObject lastExtract = new JSONObject (giacReinsuranceReportsService.getLastExtractSOAFaculRi(USER.getUserId()));
				message = lastExtract.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("showRiCommIncAndExp".equals(ACTION)) {	//Gzelle 07.19.2013
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				//Map<String, Object> lastExtractSOAFaculRi = giacReinsuranceReportsService.getLastExtractSOAFaculRi(USER.getUserId());
				//request.setAttribute("lastExtractSOAFaculRi", lastExtractSOAFaculRi);
				/*--start - Gzelle 09222015 SR18792--*/ 
				Map<String, Object> params = giacReinsuranceReportsService.getGiacs276InitialValues(request, USER.getUserId()); 
				request.setAttribute("fromDate", params.get("fromDate")); 
				request.setAttribute("toDate", params.get("toDate")); 
				request.setAttribute("lineCd", params.get("lineCd")); 
				request.setAttribute("lineName", params.get("lineName")); 
				/*--end - Gzelle 09222015 SR18792--*/  

				PAGE = "/pages/accounting/reinsurance/reports/riCommIncomeAndExpense/riCommIncomeAndExpense.jsp";
			}else if ("getGiacs276InitialValues".equals(ACTION)) {/*--start - Gzelle 09232015 SR18792--*/ 
				JSONObject json = new JSONObject(giacReinsuranceReportsService.getGiacs276InitialValues(request, USER.getUserId())); 
				request.setAttribute("object", json); 
				PAGE = "/pages/genericObject.jsp"; 
			}else if ("valExtractPrint".equals(ACTION)) { 
				JSONObject json = new JSONObject(giacReinsuranceReportsService.valExtractPrint(request, USER.getUserId())); 
				request.setAttribute("object", json); 
				PAGE = "/pages/genericObject.jsp";	 				/*--end - Gzelle 09232015 SR18792--*/
			}else if("extractGiacs276".equals(ACTION)){ //added by john dolon 8.28.2013
				request.setAttribute("object", giacReinsuranceReportsService.extractGiacs276(request, USER.getUserId()));
				PAGE = "/pages/genericObject.jsp";
			}else if("showGIACS299".equals(ACTION)){
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/reinsurance/reports/paidPoliciesWFacultative/paidPoliciesWFacultative.jsp";
			} else if("showQuarterlyTreatyStatement".equals(ACTION)){ // GIACS220
				JSONObject json = giacReinsuranceReportsService.getDistShareList(request, USER.getUserId());
				
				if(request.getParameter("refresh") != null && "1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("userId", USER.getUserId());
					request.setAttribute("treatyList", json);
					request.setAttribute("treatyPanelList", giacReinsuranceReportsService.getTreatyPanelList(request, USER.getUserId()));
					PAGE = "/pages/accounting/reinsurance/reports/quarterlyTreatyStatement/quarterlyTreatySummaryStatement.jsp";
				}
			} else if("getTreatyPanelList".equals(ACTION)){
				JSONObject json = giacReinsuranceReportsService.getTreatyPanelList(request, USER.getUserId());
				
				if(request.getParameter("refresh") != null && "1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if("showExtractOverlay".equals(ACTION)){
				PAGE = "/pages/accounting/reinsurance/reports/quarterlyTreatyStatement/overlay/extractOverlay.jsp";
			} else if("checkForPrevExtract".equals(ACTION)){
				Map<String, Object> params = giacReinsuranceReportsService.checkForPrevExtract(request, USER.getUserId());
				JSONObject json = new JSONObject(params);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("deleteAndExtract".equals(ACTION)){
				JSONObject json = new JSONObject(giacReinsuranceReportsService.deleteAndExtract(request, USER.getUserId()));
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("computeTaggedRecords".equals(ACTION)){
				message = giacReinsuranceReportsService.computeTaggedRecords(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			} else if("postTaggedRecords".equals(ACTION)){
				message = giacReinsuranceReportsService.postTaggedRecords(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			} else if("checkBeforeView".equals(ACTION)){
				message = giacReinsuranceReportsService.checkBeforeView(request, USER.getUserId()).toString(); 
				PAGE = "/pages/genericMessage.jsp";
			} else if("showTreatyStatementOverlay".equals(ACTION)){
				request.setAttribute("treatyQtrSummary", giacReinsuranceReportsService.getTreatyQuarterSummary(request, USER.getUserId()));
				PAGE = "/pages/accounting/reinsurance/reports/quarterlyTreatyStatement/overlay/treatyStatementOverlay.jsp";
			} else if("showAccountsOverlay".equals(ACTION)){
				request.setAttribute("treatyCashAcct", giacReinsuranceReportsService.getTreatyCashAcct(request));
				PAGE = "/pages/accounting/reinsurance/reports/quarterlyTreatyStatement/overlay/accountsOverlay.jsp";
			} else if("getPerilBreakdownList".equals(ACTION) || "getCommissionBreakdownList".equals(ACTION) || 
					"getClmLossPaidBreakdownList".equals(ACTION) || "getClmLossExpBreakdownList".equals(ACTION)){
				JSONObject json = giacReinsuranceReportsService.getSummaryBreakdownList(request);
				
				if(request.getParameter("refresh") != null && "1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("action", ACTION);
					request.setAttribute("objList", json);
					PAGE = "/pages/accounting/reinsurance/reports/quarterlyTreatyStatement/overlay/summaryBreakdownOverlay.jsp";
				}				
			} else if("getReportList".equals(ACTION)){
				LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				request.setAttribute("fromPage", request.getParameter("fromPage"));
				String[] params = {request.getParameter("fromPage")};
				List<LOV> reports = helper.getList(LOVHelper.REPORT_LISTING, params);
				request.setAttribute("reportList", reports);
				PAGE = "/pages/accounting/reinsurance/reports/quarterlyTreatyStatement/overlay/reportsOverlay.jsp";
			} else if("saveTreatyStatement".equals(ACTION)){
				message = giacReinsuranceReportsService.saveTreatyStatement(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if("saveTreatyCashAcct".equals(ACTION)){
				message = giacReinsuranceReportsService.saveTreatyCashAcct(request);
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
			if(e.getErrorCode() > 20000 && e.getCause().toString().contains("Geniisys Exception")){ 
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
			
	}

}
