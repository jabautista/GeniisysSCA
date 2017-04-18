package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISLineFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.entity.GICLClaims;
import com.geniisys.gicl.service.GICLPrelimLossReportService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GICLReserveSetupController", urlPatterns={"/GICLReserveSetupController"})
public class GICLReserveSetupController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 3502360347178257154L;
	private static Logger log = Logger.getLogger(GICLReserveSetupController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("do processing");
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GICLPrelimLossReportService giclPrelimLossReportService = (GICLPrelimLossReportService) APPLICATION_CONTEXT.getBean("giclPrelimLossReportService");
		
		try{
			Integer claimId = Integer.parseInt(request.getParameter("claimId") == null || "".equals(request.getParameter("claimId")) ? "0" : request.getParameter("claimId"));
			Integer adviceId = Integer.parseInt(request.getParameter("adviceId") == null || "".equals(request.getParameter("adviceId")) ? "0" : request.getParameter("adviceId"));
			String lineCd = request.getParameter("lineCd");
			String prelim = request.getParameter("prelim");
			request.setAttribute("claimId", claimId == 0 ? "" : claimId);
			GICLClaims prelimLossInfo = null;
			GICLClaims finalLossInfo = null;
			
			if("getItemInformation".equals(ACTION)){
				String menuLineCd = request.getParameter("menuLineCd");				
				request.setAttribute("lineCd", lineCd);
				request.setAttribute("prelim", prelim);
				
				if(menuLineCd.equals("") || menuLineCd == null){ //marco - 09.13.2013 - added retrieval of menuLineCd if not from claim line listing
					GIISLineFacadeService giisLineService = (GIISLineFacadeService) APPLICATION_CONTEXT.getBean("giisLineFacadeService");
					menuLineCd = giisLineService.getMenuLineCd(lineCd);
				}
				
				log.info("Line Code: " + lineCd);
				log.info("Menu Line Code: " + menuLineCd);
				
				if(prelim.equals("Y") && request.getParameter("refresh") == null){
					prelimLossInfo = claimId == 0 ? null : giclPrelimLossReportService.getPrelimLossInfo(claimId);
					request.setAttribute("agentList", claimId == 0 ? null : giclPrelimLossReportService.getAgentList(claimId)); 		//marco - 04.12.2013 - added for agent drop down list
					request.setAttribute("mortgageeList", claimId == 0 ? null : giclPrelimLossReportService.getMortgageeList(claimId)); // and for mortgagee drop down list
					request.setAttribute("prelimLossInfoJSON", new JSONObject (prelimLossInfo != null ? StringFormatter.escapeHTMLInObject(prelimLossInfo) : new GICLClaims()));
				}else if(prelim.equals("N") && request.getParameter("refresh") == null){
					finalLossInfo = claimId == 0 ? null : giclPrelimLossReportService.getFinalLossInfo(claimId);
					request.setAttribute("finalLossInfoJSON", new JSONObject (finalLossInfo != null ? StringFormatter.escapeHTMLInObject(finalLossInfo) : new GICLClaims()));
				}
				
				if("FI".equals(lineCd) || "FI".equals(menuLineCd)) {
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("ACTION", "getFireItemInformation");
					params.put("claimId", claimId);
					Map<String, Object> fireInfoTableGrid = TableGridUtil.getTableGrid(request, params);
					JSONObject json = new JSONObject(fireInfoTableGrid);
					if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
						message = json.toString();
						PAGE = "/pages/genericMessage.jsp";
					} else {
						request.setAttribute("fireInfoTableGrid", json);
						PAGE = "/pages/claims/reserveSetup/preliminaryLossReport/firePrelimLossReport.jsp";
					}
				}else if("AV".equals(lineCd) || "AV".equals(menuLineCd)) {
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("ACTION", "getAviationItemInformation");
					params.put("claimId", claimId);
					Map<String, Object> aviationInfoTableGrid = TableGridUtil.getTableGrid(request, params);
					JSONObject json = new JSONObject(aviationInfoTableGrid);
					if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
						message = json.toString();
						PAGE = "/pages/genericMessage.jsp";
					} else {
						request.setAttribute("aviationInfoTableGrid", json);
						PAGE = "/pages/claims/reserveSetup/preliminaryLossReport/aviationPrelimLossReport.jsp";
					}
				}else if("CA".equals(lineCd) || "CA".equals(menuLineCd)) {
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("ACTION", "getCasualtyItemInformation");
					params.put("claimId", claimId);
					Map<String, Object> casualtyInfoTableGrid = TableGridUtil.getTableGrid(request, params);
					JSONObject json = new JSONObject(casualtyInfoTableGrid);
					if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
						message = json.toString();
						PAGE = "/pages/genericMessage.jsp";
					} else {
						request.setAttribute("casualtyInfoTableGrid", json);
						PAGE = "/pages/claims/reserveSetup/preliminaryLossReport/casualtyPrelimLossReport.jsp";
					}
				}else if("MC".equals(lineCd) || "MC".equals(menuLineCd)) {
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("ACTION", "getMCItemInformation");
					params.put("claimId", claimId);
					Map<String, Object> mcInfoTableGrid = TableGridUtil.getTableGrid(request, params);
					JSONObject json = new JSONObject(mcInfoTableGrid);
					if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
						message = json.toString();
						PAGE = "/pages/genericMessage.jsp";
					} else {
						request.setAttribute("mcInfoTableGrid", json);
						PAGE = "/pages/claims/reserveSetup/preliminaryLossReport/motorCarPrelimLossReport.jsp";
					}
				}else if("MN".equals(lineCd) || "MN".equals(menuLineCd)) {
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("ACTION", "getMNItemInformation");
					params.put("claimId", claimId);
					Map<String, Object> mnInfoTableGrid = TableGridUtil.getTableGrid(request, params);
					JSONObject json = new JSONObject(mnInfoTableGrid);
					if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
						message = json.toString();
						PAGE = "/pages/genericMessage.jsp";
					} else {
						request.setAttribute("mnInfoTableGrid", json);
						PAGE = "/pages/claims/reserveSetup/preliminaryLossReport/marinePrelimLossReport.jsp";
					}
				}else if("MH".equals(lineCd) || "MH".equals(menuLineCd)) {
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("ACTION", "getMHItemInformation");
					params.put("claimId", claimId);
					Map<String, Object> mhInfoTableGrid = TableGridUtil.getTableGrid(request, params);
					JSONObject json = new JSONObject(mhInfoTableGrid);
					if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
						message = json.toString();
						PAGE = "/pages/genericMessage.jsp";
					} else {
						request.setAttribute("mhInfoTableGrid", json);
						PAGE = "/pages/claims/reserveSetup/preliminaryLossReport/hullPrelimLossReport.jsp";
					}
				}else if("PA".equals(lineCd) || "AC".equals(menuLineCd)) {
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("ACTION", "getAccidentItemInformation");
					params.put("claimId", claimId);
					Map<String, Object> accidentInfoTableGrid = TableGridUtil.getTableGrid(request, params);
					JSONObject json = new JSONObject(accidentInfoTableGrid);
					if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
						message = json.toString();
						PAGE = "/pages/genericMessage.jsp";
					} else {
						request.setAttribute("accidentInfoTableGrid", json);
						PAGE = "/pages/claims/reserveSetup/preliminaryLossReport/accidentPrelimLossReport.jsp";
					}
				}else if("EN".equals(lineCd) || "EN".equals(menuLineCd)) {
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("ACTION", "getEngItemInformation");
					params.put("claimId", claimId);
					Map<String, Object> engInfoTableGrid = TableGridUtil.getTableGrid(request, params);
					JSONObject json = new JSONObject(engInfoTableGrid);
					if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
						message = json.toString();
						PAGE = "/pages/genericMessage.jsp";
					} else {
						request.setAttribute("engInfoTableGrid", json);
						PAGE = "/pages/claims/reserveSetup/preliminaryLossReport/engineeringPrelimLossReport.jsp";
					}
				}else if("SU".equals(lineCd) || "SU".equals(menuLineCd)) {
					PAGE = "/pages/claims/reserveSetup/preliminaryLossReport/suretyPrelimLossReport.jsp";
				}else{
					PAGE = "/pages/claims/reserveSetup/preliminaryLossReport/prelimLossReport.jsp";
				}
			} else if("getPremPayment".equals(ACTION)) {
				request.setAttribute("lineCd", lineCd);
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("claimId", claimId);
				Map<String, Object> premPaymentInfoTG = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(premPaymentInfoTG);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("premPaymentInfoTG", json);
					PAGE = "/pages/claims/reserveSetup/preliminaryLossReport/subPages/premiumPayment.jsp";
				}
			}else if("getDocsOnFile".equals(ACTION)) {
				request.setAttribute("lineCd", lineCd);
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("claimId", claimId);
				Map<String, Object> reqdDocsTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(reqdDocsTableGrid);
				System.out.println("json: " + json);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("reqdDocsTableGrid", json);
					PAGE = "/pages/claims/reserveSetup/preliminaryLossReport/subPages/documentsOnFile.jsp";
				}
			}else if("showPreLossRepPrintDialog".equals(ACTION)) {
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);	
				request.setAttribute("lineCd", lineCd);
				request.setAttribute("reportId", request.getParameter("reportId"));
				PAGE = "/pages/claims/reserveSetup/preliminaryLossReport/subPages/preLossRepPrintDialog.jsp";
			}else if("getPerilInformation".equals(ACTION)){
				request.setAttribute("lineCd", lineCd);
				request.setAttribute("prelim", prelim);
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("claimId", claimId);
				params.put("lineCd", lineCd);
				Map<String, Object> perilInfoTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(perilInfoTableGrid);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("perilInfoTableGrid", json);
					PAGE = "/pages/claims/reserveSetup/preliminaryLossReport/subPages/perilInformation.jsp";
				}
			}else if("getReinsurance".equals(ACTION)){
				int shareCd = Integer.parseInt(request.getParameter("shareCd"));
				Integer perilCd = request.getParameter("perilCd") == "" || request.getParameter("perilCd") == null ? null : Integer.parseInt(request.getParameter("perilCd"));//added by Lara - 10-01-2013 
				request.setAttribute("perilCd", perilCd);
				
				request.setAttribute("shareCd", shareCd);
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("claimId", claimId);
				params.put("shareCd", shareCd);
				params.put("perilCd", perilCd);

				Map<String, Object> reinsuranceTG = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(reinsuranceTG);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("reinsuranceTG", json);
					PAGE = "/pages/claims/reserveSetup/preliminaryLossReport/subPages/reinsurer.jsp";
				}
			}else if("getReserveRi".equals(ACTION)){
				Integer perilCd = request.getParameter("perilCd") == "" || request.getParameter("perilCd") == null ? null : Integer.parseInt(request.getParameter("perilCd")); // added by Lara - 10-01-2013
				request.setAttribute("perilCd", perilCd);
				request.setAttribute("shareCd", Integer.parseInt(request.getParameter("shareCd")));
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("claimId", claimId);
				params.put("shareCd", Integer.parseInt(request.getParameter("shareCd")));
				params.put("perilCd", perilCd);
				Map<String, Object> riResTG = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(riResTG);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("riResTG", json);
					PAGE = "/pages/claims/reserveSetup/preliminaryLossReport/subPages/reserveReinsurer.jsp";
				}
			}else if("getFinalReserveRi".equals(ACTION)){
				Integer shareCd = request.getParameter("shareCd") == "" || request.getParameter("shareCd") == null ? null : Integer.parseInt(request.getParameter("shareCd")); // added by Lara - 10-04-2013
				Integer perilCd = request.getParameter("perilCd") == "" || request.getParameter("perilCd") == null ? null : Integer.parseInt(request.getParameter("perilCd"));  
				request.setAttribute("perilCd", perilCd);
				request.setAttribute("shareCd", shareCd);
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("claimId", claimId);
				params.put("adviceId", Integer.parseInt(request.getParameter("adviceId")));
				params.put("shareCd", shareCd); 
				params.put("perilCd", perilCd); 
				Map<String, Object> riResTG = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(riResTG);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("prelim", request.getParameter("prelim"));
					request.setAttribute("riResTG", json);
					PAGE = "/pages/claims/reserveSetup/preliminaryLossReport/subPages/reserveReinsurer.jsp";
				}
			}else if("showFinalLossReport".equals(ACTION)){
				PAGE = "/pages/claims/generateAdvice/finalLossReport/finalLossRepClaimInfo.jsp";
			}else if("getPayeeDetails".equals(ACTION)){
				request.setAttribute("adviceId", adviceId);
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("claimId", claimId);
				params.put("adviceId", adviceId);
				Map<String, Object> payeeDtlsTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(payeeDtlsTableGrid);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("payeeDtlsTableGrid", json);
					PAGE = "/pages/claims/generateAdvice/finalLossReport/subpages/finalLossRepPayeeDtls.jsp";
				}
			}else if("getFinalPerilInformation".equals(ACTION)){
				request.setAttribute("lineCd", lineCd);
				request.setAttribute("adviceId", adviceId);
				request.setAttribute("prelim", prelim);
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("claimId", claimId);
				params.put("lineCd", lineCd);
				params.put("adviceId", adviceId);
				Map<String, Object> perilInfoTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(perilInfoTableGrid);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("perilInfoTableGrid", json);
					PAGE = "/pages/claims/reserveSetup/preliminaryLossReport/subPages/perilInformation.jsp";
				}
			}else if("showFinalLossReportPrintDialog".equals(ACTION)) {
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);	
				PAGE = "/pages/claims/generateAdvice/finalLossReport/subpages/finalLossReportPrintDialog.jsp";
			}
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
	
}
