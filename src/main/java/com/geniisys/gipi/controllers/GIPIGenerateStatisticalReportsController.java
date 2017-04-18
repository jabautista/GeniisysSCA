package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.sql.SQLException;//edgar 04/27/2015 FULL WEB SR 4322
import java.util.HashMap;
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
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.service.GIPIGenerateStatisticalReportsService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter; //edgar 04/27/2015 FULL WEB SR 4322

@WebServlet (name="GIPIGenerateStatisticalReportsController", urlPatterns="/GIPIGenerateStatisticalReportsController")
public class GIPIGenerateStatisticalReportsController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		
		try{
			ApplicationContext APP_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIPIGenerateStatisticalReportsService gipiGenStatisticalReportsService = (GIPIGenerateStatisticalReportsService) APP_CONTEXT.getBean("gipiGenerateStatisticalReportsService");
			
			if ("showGIPIS901".equals(ACTION)){
				PrintService [] printers = PrintServiceLookup.lookupPrintServices(null, null);
				String tab = request.getParameter("tab");
				Map<String, Object> params = gipiGenStatisticalReportsService.getLineCds();
				System.out.println(params.toString());
				
				if ("statisticalTab".equals(tab)){
					request.setAttribute("lineCdFi", params.get("LINE_CD_FI"));
					request.setAttribute("lineCdMc", params.get("LINE_CD_MC"));
					PAGE = "/pages/underwriting/reportsPrinting/generateStatisticalReports/genStatisticalReports.jsp";	
				}else if ("riskProfileTab".equals(tab)){
					JSONObject jsonMaster = gipiGenStatisticalReportsService.getRiskProfileMaster(request, USER.getUserId());
					JSONObject jsonDetail = gipiGenStatisticalReportsService.getRiskProfileDetail(request, USER.getUserId());
					
					request.setAttribute("riskProfileMasterTG", jsonMaster);
					request.setAttribute("riskProfileDetailTG", jsonDetail);
					request.setAttribute("lineCdFi", params.get("LINE_CD_FI"));
					request.setAttribute("lineCdMc", params.get("LINE_CD_MC"));
					PAGE = "/pages/underwriting/reportsPrinting/generateStatisticalReports/tabs/riskProfile.jsp";	
				}else if ("fireStatTab".equals(tab)){
					PAGE = "/pages/underwriting/reportsPrinting/generateStatisticalReports/tabs/fireStat.jsp";	
				}else if ("motorStatTab".equals(tab)){
					PAGE = "/pages/underwriting/reportsPrinting/generateStatisticalReports/tabs/motorStat.jsp";	
				}
				
				request.setAttribute("printers", printers);
			}else if("beforePrintingStatTab".equals(ACTION)){
				message = gipiGenStatisticalReportsService.getRecCntStatTab(request, USER.getUserId()).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("extractRecordsMotorStat".equals(ACTION)){
				message = gipiGenStatisticalReportsService.extractRecordsMotorStat(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if ("chkExistingRecordMotorStat".equals(ACTION)){
				message = gipiGenStatisticalReportsService.chkExistingRecordMotorStat(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("showFirePerilDialog".equals(ACTION)){
				PAGE = "/pages/underwriting/reportsPrinting/generateStatisticalReports/popups/fireStatPeril.jsp";
			}else if("extractFireStat".equals(ACTION)){
				message = gipiGenStatisticalReportsService.extractFireStat(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("getFireTariffMaster".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getFireTariffMaster");
				params.put("userId", USER.getUserId());
				params.put("asOfSw", request.getParameter("asOfSw"));
				params.put("zoneType", request.getParameter("zoneType")); //edgar 03/20/2015
				
				Map<String, Object> fireTariffMaster = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonMaster = new JSONObject(fireTariffMaster);				
				System.out.println("===== " +jsonMaster.toString());
				
				if ("1".equals(request.getParameter("refresh"))){
					message = jsonMaster.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					JSONObject jsonDetail = gipiGenStatisticalReportsService.getFireTariffDtl(request, USER, "getFireTariffDetail");
					request.setAttribute("tariffMasterTG", jsonMaster);
					request.setAttribute("tariffDetailTG", jsonDetail);
					PAGE = "/pages/underwriting/reportsPrinting/generateStatisticalReports/popups/fireStatTariff.jsp";
				}
				
			}else if("getFireTariffDetail".equals(ACTION)){
				JSONObject json = gipiGenStatisticalReportsService.getFireTariffDtl(request, USER, ACTION);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("computeFireTariffTotals".equals(ACTION)){
				JSONObject json = gipiGenStatisticalReportsService.computeFireTariffTotals(request, USER.getUserId());
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("showGIPIS901FirePrintDialog".equals(ACTION)){
				PrintService [] printers = PrintServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/underwriting/reportsPrinting/generateStatisticalReports/popups/firePrintDialog.jsp";
			}else if("getTrtyTypeCd".equals(ACTION)){
				message = gipiGenStatisticalReportsService.getTrtyTypeCd(request.getParameter("distShare"));
				PAGE = "/pages/genericMessage.jsp";
			}else if("getFireZoneMaster".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("userId", USER.getUserId());
				params.put("asOfSw", request.getParameter("asOfSw"));
				params.put("lineCdFi", request.getParameter("lineCdFi"));
				params.put("zoneType", request.getParameter("zoneType")); // jhing 03.19.2015 
				
				Map<String, Object> fireZoneMaster = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonMaster = new JSONObject(fireZoneMaster);
				System.out.println("===== " +jsonMaster.toString());
				
				if ("1".equals(request.getParameter("refresh"))){
					message = jsonMaster.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("zoneMasterTG", jsonMaster);
					JSONObject json = gipiGenStatisticalReportsService.computeFireZoneMasterTotals(request, USER.getUserId());
					request.setAttribute("sumShareTsiAmt", json.get("sumTsiAmt"));
					request.setAttribute("sumSharePremAmt", json.get("sumPremAmt"));
					PAGE = "/pages/underwriting/reportsPrinting/generateStatisticalReports/popups/fireStatZoneMaster.jsp";
				}
				
			}else if("getFireZoneDetail".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("userId", USER.getUserId());
				params.put("asOfSw", request.getParameter("asOfSw"));
				params.put("lineCdFi", request.getParameter("lineCdFi"));
				params.put("shareCd", request.getParameter("shareCd"));
				params.put("zoneType", request.getParameter("zoneType"));//edgar 03/20/2015
				
				Map<String, Object> fireZoneDetail = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonDetail = new JSONObject(fireZoneDetail);
				
				if ("1".equals(request.getParameter("refresh"))){
					message = jsonDetail.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("zoneDetailTG", jsonDetail);
					JSONObject json = gipiGenStatisticalReportsService.computeFireZoneDetailTotals(request, USER.getUserId());
					request.setAttribute("sumShareTsiAmt", json.get("sumTsiAmt"));
					request.setAttribute("sumSharePremAmt", json.get("sumPremAmt"));					
					PAGE = "/pages/underwriting/reportsPrinting/generateStatisticalReports/popups/fireStatZoneDetail.jsp";
				}
				
			}else if("getFireCommAccumMaster".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("userId", USER.getUserId());
				params.put("asOfSw", request.getParameter("asOfSw"));//edgar 04/01/2015
				params.put("zoneType", request.getParameter("zoneType"));//edgar 04/01/2015
				
				Map<String, Object> fireCommAccumMaster = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonMaster = new JSONObject(fireCommAccumMaster);
				System.out.println(jsonMaster.toString());
				
				if ("1".equals(request.getParameter("refresh"))){
					message = jsonMaster.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					JSONObject jsonDetail = gipiGenStatisticalReportsService.getFireCommAccumDtl(request, USER, "getFireCommAccumDetail");
					request.setAttribute("commAccumDetailTG", jsonDetail);	
					request.setAttribute("commAccumMasterTG", jsonMaster);			
					PAGE = "/pages/underwriting/reportsPrinting/generateStatisticalReports/popups/fireStatCommAccum.jsp";
				}				
			}else if("getFireCommAccumDetail".equals(ACTION)){
				JSONObject json = gipiGenStatisticalReportsService.getFireCommAccumDtl(request, USER, ACTION);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("getTrtyName".equals(ACTION)){
				message = gipiGenStatisticalReportsService.getTrtyName(request.getParameter("distShare"));
				PAGE = "/pages/genericMessage.jsp";
			}else if ("computeFireCATotals".equals(ACTION)){
				JSONObject json = gipiGenStatisticalReportsService.computeFireCATotals(request, USER.getUserId());
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("countFireStatExt".equals(ACTION)){
				message = gipiGenStatisticalReportsService.countFireStatExt(request).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("getRiskProfileMaster".equals(ACTION)){
				JSONObject json = gipiGenStatisticalReportsService.getRiskProfileMaster(request, USER.getUserId());
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("getRiskProfileDetail".equals(ACTION)){
				JSONObject json = gipiGenStatisticalReportsService.getRiskProfileDetail(request, USER.getUserId());
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("chkRiskExtRecords".equals(ACTION)){
				message = gipiGenStatisticalReportsService.chkRiskExtRecords(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("getTreatyCount".equals(ACTION)){
				message = gipiGenStatisticalReportsService.getTreatyCount(request, USER.getUserId()).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("extractRiskProfile".equals(ACTION)){
				message = gipiGenStatisticalReportsService.extractRiskProfile(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("riskSave".equals(ACTION)){
				message = gipiGenStatisticalReportsService.saveRiskProfile(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkFireStat".equals(ACTION)){//edgar 03/20/2015
				message = gipiGenStatisticalReportsService.checkFireStat(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("valBeforeSave".equals(ACTION)){	//Gzelle 03262015
				message = gipiGenStatisticalReportsService.valBeforeSave(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";					
			}else if("valAddUpdRec".equals(ACTION)){	//Gzelle 04072015
				message = gipiGenStatisticalReportsService.valAddUpdRec(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";				
			}else if("validateBeforeExtract".equals(ACTION)){//edgar 04/27/2015 FULL WEB SR 4322
				Map<String, Object> paramsOut = new HashMap<String, Object>();
				Map<String, Object> params = new HashMap<String, Object>();
				params = gipiGenStatisticalReportsService.validateBeforeExtract(request, USER.getUserId());
				paramsOut.put("msgAlert", params.get("msgAlert"));
				JSONObject result = new JSONObject(StringFormatter.replaceQuotesInMap(paramsOut));
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch(SQLException e){
			//handle customized error messages : //edgar 04/27/2015 FULL WEB SR 4322
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		}catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
