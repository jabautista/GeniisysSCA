package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
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
import org.json.JSONException;
import org.springframework.context.ApplicationContext;

import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.service.GICLClmRecoveryService;
import com.geniisys.gipi.util.DateFormatter;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet (name="GICLClmRecoveryController", urlPatterns="/GICLClmRecoveryController")
public class GICLClmRecoveryController extends BaseController{

	Logger log = Logger.getLogger(GICLClmRecoveryController.class);
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GICLClmRecoveryService giclClmRecoveryService = (GICLClmRecoveryService) APPLICATION_CONTEXT.getBean("giclClmRecoveryService");
			PAGE = "/pages/genericMessage.jsp";
			
			if("showClmRecoveryDetails".equals(ACTION)){
				giclClmRecoveryService.getGiclClmRecoveryGrid(request, USER);
				PAGE = "1".equals(request.getParameter("refresh")) ? "/pages/genericObject.jsp" :"/pages/claims/inquiry/claimListing/perPolicy/recoveryDetails.jsp";
			}else if("showRecoverySubDetails".equals(ACTION)){
				giclClmRecoveryService.getGiclClmRecoveryPayorGrid(request, USER);
				giclClmRecoveryService.getGiclClmRecoveryHistGrid(request, USER);
				request.setAttribute("claimId", request.getParameter("claimId"));
				request.setAttribute("recoveryId", request.getParameter("recoveryId"));
				PAGE = "1".equals(request.getParameter("refresh")) ? "/pages/genericObject.jsp" :"/pages/claims/inquiry/claimListing/perPolicy/recoverySubDetails.jsp";
			}else if("showRecoveryPayorSubDetails".equals(ACTION)){
				giclClmRecoveryService.getGiclClmRecoveryPayorGrid(request, USER);
				PAGE = "1".equals(request.getParameter("refresh")) ? "/pages/genericObject.jsp" :"/pages/claims/inquiry/claimListing/perPolicy/recoverySubDetails.jsp";
			}else if("showRecoveryHistSubDetails".equals(ACTION)){
				giclClmRecoveryService.getGiclClmRecoveryHistGrid(request, USER);
				PAGE = "1".equals(request.getParameter("refresh")) ? "/pages/genericObject.jsp" :"/pages/claims/inquiry/claimListing/perPolicy/recoverySubDetails.jsp";
			}else if("showRecoveryInformation".equals(ACTION)){
				log.info("Getting Recovery Information...");
				Integer claimId = Integer.parseInt(request.getParameter("claimId"));
				Map<String, Object> variables = StringFormatter.escapeHTMLInMap(giclClmRecoveryService.getGicls025Variables(claimId));
				request.setAttribute("variables", new JSONObject(variables)/*QueryParamGenerator.generateQueryParams(variables)*/ );
				request.setAttribute("showClaimStat", "Y");
				giclClmRecoveryService.getGiclClmRecoveryGrid2(request, USER);
				PAGE = "1".equals(request.getParameter("refresh")) ? "/pages/genericObject.jsp" :"/pages/claims/lossRecovery/recoveryInformation/recoveryInfo.jsp";	
			}else if("showRecoveryInformationSubDetails".equals(ACTION)){
				log.info("Getting Recovery Information Sub Details...");
				giclClmRecoveryService.getGiclClmRecoveryPayorGrid(request, USER);
				giclClmRecoveryService.getGiclClmRecoveryHistGrid(request, USER);
				request.setAttribute("claimId", request.getParameter("claimId"));
				request.setAttribute("recoveryId", request.getParameter("recoveryId"));
				PAGE = "1".equals(request.getParameter("refresh")) ? "/pages/genericObject.jsp" :"/pages/claims/lossRecovery/recoveryInformation/subPages/recoveryInfoSubDetails.jsp";
			}else if("saveRecoveryInfo".equals(ACTION)){
				message = giclClmRecoveryService.saveRecoveryInfo(request, USER);
			}else if("genRecHistNo".equals(ACTION)){
				message = giclClmRecoveryService.genRecHistNo(request, USER);
			}else if("checkRecoveredAmtPerRecovery".equals(ACTION)){
				log.info("Checking if the current recovery has recovered amt...");
				message = giclClmRecoveryService.checkRecoveredAmtPerRecovery(request, USER);
			}else if("writeOffRecovery".equals(ACTION)){
				log.info("Write Off recovery...");
				message = "SUCCESS";
				giclClmRecoveryService.writeOffRecovery(request, USER);
			}else if("cancelRecovery".equals(ACTION)){
				log.info("Cancel recovery...");
				message = "SUCCESS";
				giclClmRecoveryService.cancelRecovery(request, USER);
			}else if("closeRecovery".equals(ACTION)){
				log.info("Close recovery...");
				message = "SUCCESS";
				giclClmRecoveryService.closeRecovery(request, USER);
			}else if("showPrintRecoveryLetterDialog".equals(ACTION)){
				GIISReportsService reportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
				GIISParameterFacadeService parametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);	//added by steven 8/23/2012			
				request.setAttribute("printers", printers);
				request.setAttribute("reportVersion", reportsService.getReportVersion("GICLR025"));
				request.setAttribute("sysdate", parametersService.getFormattedSysdate()); 
				
				request.setAttribute("demandLetterDate",  (request.getParameter("demandLetterDate").equals(null) || request.getParameter("demandLetterDate").equals("") ? "" : new SimpleDateFormat("MM-dd-yyyy").format(DateFormatter.formatDate(request.getParameter("demandLetterDate"), DateFormatter.MM_D_DD_D_YYYY, DateFormatter.MM_D_DD_D_YYYY))));		//added by steven 8/30/2012
				request.setAttribute("demandLetterDate2", (request.getParameter("demandLetterDate2").equals(null) || request.getParameter("demandLetterDate2").equals("") ? "" : new SimpleDateFormat("MM-dd-yyyy").format(DateFormatter.formatDate(request.getParameter("demandLetterDate2"), DateFormatter.MM_D_DD_D_YYYY, DateFormatter.MM_D_DD_D_YYYY))));  
				request.setAttribute("demandLetterDate3", (request.getParameter("demandLetterDate3").equals(null) || request.getParameter("demandLetterDate3").equals("") ? "" : new SimpleDateFormat("MM-dd-yyyy").format(DateFormatter.formatDate(request.getParameter("demandLetterDate3"), DateFormatter.MM_D_DD_D_YYYY, DateFormatter.MM_D_DD_D_YYYY)))); 
				
				PAGE = "/pages/claims/lossRecovery/recoveryInformation/subPages/printRecoveryLetter.jsp";
			} else if("valPrint".equals(ACTION)){
				message = giclClmRecoveryService.validatePrint(request).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("updateDemandLetterDates".equals(ACTION)){
				giclClmRecoveryService.updateDemandLetterDates(request, USER.getUserId());		
			}else if("showGICLS260LossRecovery".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGICLS260ClmRecovery");
				params.put("claimId", request.getParameter("claimId"));
				params = TableGridUtil.getTableGrid(request, params);
				String json = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
				
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("jsonGiclClmRecovery", json);
					PAGE = "/pages/claims/inquiry/claimInformation/lossRecovery/lossRecoveryMain.jsp";
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("refreshGICLS260RecoveryPayor".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGiclRecoveryPayorGrid");
				params.put("claimId", request.getParameter("claimId"));
				params.put("recoveryId", request.getParameter("recoveryId"));
				params = TableGridUtil.getTableGrid(request, params);
				message = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("refreshGICLS260GiclLRecHist".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGiclRecHistGrid");
				params.put("claimId", request.getParameter("claimId"));
				params.put("recoveryId", request.getParameter("recoveryId"));
				params = TableGridUtil.getTableGrid(request, params);
				message = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}
		}catch(SQLException e){
			message = ExceptionHandler.handleException(e, USER);
		}catch(JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
		}catch(NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
		//}catch(ParseException e) {
			//message = ExceptionHandler.handleException(e, USER);
		}catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}