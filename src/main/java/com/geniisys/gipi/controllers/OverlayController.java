package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.controllers.GIISController;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.entity.GIPILoadHist;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIUploadTemp;
import com.geniisys.gipi.service.GIPILoadHistService;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.GIPIUploadTempService;
import com.geniisys.gipi.service.PostParService;
import com.geniisys.giri.entity.GIRIDistFrpsWdistFrpsV;
import com.geniisys.giri.service.GIRIDistFrpsWdistFrpsVService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter; //added by robert SR 4961 09.16.15

public class OverlayController extends BaseController{

	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIISController.class);
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("Initializing: "+ this.getClass().getSimpleName());
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		
		try {
			if("getPostPar".equals(ACTION)) {
				PostParService postParService = (PostParService) APPLICATION_CONTEXT.getBean("postParService");
				postParService.doPostPar(request, APPLICATION_CONTEXT);
				//added by robert SR 4961 09.16.15
				GIISParameterFacadeService giisParamService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService"); 
				request.setAttribute("autoPrintBinders", giisParamService.getParamValueV2("AUTO_PRINT_BINDERS"));
				request.setAttribute("girir001PrinterName", StringFormatter.escapeBackslash(giisParamService.getParamValueV2("GIRIR001_PRINTER_NAME")));
				//end robert SR 4961 09.16.15
				PAGE = "/pages/underwriting/postPar.jsp";
			} else if("getUploadEnrollees".equals(ACTION)) {
				GIPILoadHistService gipiLoadHistService = (GIPILoadHistService) APPLICATION_CONTEXT.getBean("gipiLoadHistService");
				GIPIUploadTempService gipiUploadTempService = (GIPIUploadTempService) APPLICATION_CONTEXT.getBean("gipiUploadTempService");
				GIPIPARListService gipiParService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
				GIPIPARList gipiParList = null;
				int parId = Integer.parseInt("".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId"));
				int itemNo = Integer.parseInt("".equals(request.getParameter("itemNo")) ? "0" : request.getParameter("itemNo"));
				log.info("Getting Uploading Enrollee page.");
				gipiParList = gipiParService.getGIPIPARDetails(parId);
				request.setAttribute("gipiParlist", gipiParList);
				request.setAttribute("itemNo", itemNo);
				List<GIPILoadHist> gipiLoadHist = gipiLoadHistService.getGipiLoadHist();
				List<GIPIUploadTemp> gipiUploadTemp  = gipiUploadTempService.getGipiUploadTemp();
				request.setAttribute("gipiLoadHist", gipiLoadHist);
				request.setAttribute("gipiUploadTemp", gipiUploadTemp);
				request.setAttribute("uploadEnrolleesSaved", request.getParameter("uploadEnrolleesSaved"));
				PAGE = "/pages/underwriting/overlay/uploadEnrollees.jsp";
			}else if("showUploadEnrollees".equals(ACTION)){
				GIPIPARListService gipiParService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
				GIPIPARList gipiParList = null;
				int parId = Integer.parseInt("".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId"));
				int itemNo = Integer.parseInt("".equals(request.getParameter("itemNo")) ? "0" : request.getParameter("itemNo"));
				Map<String, Object> tgLoadHist = new HashMap<String, Object>();
				System.out.println("parId: " + parId + " itemNo: " + itemNo);
				gipiParList = gipiParService.getGIPIPARDetails(parId);				
				
				tgLoadHist.put("ACTION", "getGIPILoadHistTG");				
				
				tgLoadHist = TableGridUtil.getTableGrid2(request, tgLoadHist);
				
				request.setAttribute("gipiParlist", gipiParList);
				request.setAttribute("itemNo", itemNo);
				request.setAttribute("tgLoadHist", new JSONObject(tgLoadHist));
				request.setAttribute("uploadEnrolleesSaved", request.getParameter("uploadEnrolleesSaved"));
				PAGE = "/pages/underwriting/overlay/enrollees/uploadEnrollees.jsp";
			}else if ("getPostFRPS".equals(ACTION)){
				GIRIDistFrpsWdistFrpsVService giriDistFrpsWdistFrpsVService = (GIRIDistFrpsWdistFrpsVService) APPLICATION_CONTEXT.getBean("giriDistFrpsWdistFrpsVService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("frpsYy", request.getParameter("frpsYy"));
				params.put("frpsSeqNo", request.getParameter("frpsSeqNo"));
				
				Debug.print("getPostFRPS params: " + params);
				
				GIRIDistFrpsWdistFrpsV WdistFrpsVDetails = giriDistFrpsWdistFrpsVService.getWdistFrpsVDtls(params);
				request.setAttribute("GIRIDistFrpsWdistFrpsVJSON", new JSONObject(WdistFrpsVDetails));
				//added by robert SR 4961 09.16.15
				GIISParameterFacadeService giisParamService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService"); 
				request.setAttribute("autoPrintBinders", giisParamService.getParamValueV2("AUTO_PRINT_BINDERS"));
				request.setAttribute("girir001PrinterName", StringFormatter.escapeBackslash(giisParamService.getParamValueV2("GIRIR001_PRINTER_NAME")));
				//end robert SR 4961 09.16.15
				PAGE = "/pages/underwriting/reInsurance/postFrps/postFrps.jsp";
			}else if("getPostPackPar".equals(ACTION)) {
				PostParService postParService = (PostParService) APPLICATION_CONTEXT.getBean("postParService");
				postParService.doPostPackPar(request, APPLICATION_CONTEXT);
				//added by robert SR 4961 09.16.15
				GIISParameterFacadeService giisParamService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService"); 
				request.setAttribute("autoPrintBinders", giisParamService.getParamValueV2("AUTO_PRINT_BINDERS"));
				request.setAttribute("girir001PrinterName", StringFormatter.escapeBackslash(giisParamService.getParamValueV2("GIRIR001_PRINTER_NAME")));
				//end robert SR 4961 09.16.15
				PAGE = "/pages/underwriting/postPar.jsp";
			}else if("showGenerateAE".equals(ACTION)){
				request.setAttribute("payeeClass", request.getParameter("payeeClass"));
				request.setAttribute("payee", request.getParameter("payee"));
				PAGE = "/pages/claims/specialClaimSettlementRequest/subpages/generateAE.jsp";
			}else if("showUploadFleetData".equals(ACTION)) {
				System.out.println("OverlayController - Upload Fleet Data");
				GIISParameterFacadeService giisParamService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				request.setAttribute("excelPath", giisParamService.getParamValueV2("EXCEL_PATH"));
				request.setAttribute("vCsvPath", giisParamService.getParamValueV2("CSV_PATH"));
				request.setAttribute("vCsvDirName", giisParamService.getParamValueV2("CSV_DIR_NAME"));
				request.setAttribute("userId", USER.getUserId());
				PAGE = "/pages/underwriting/overlay/fleetData/uploadFleetData.jsp";
			}else if("showUploadPropertyFloater".equals(ACTION)) {
				System.out.println("OverlayController - Upload Property Floater");
				GIISParameterFacadeService giisParamService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				request.setAttribute("excelPath", giisParamService.getParamValueV2("EXCEL_PATH"));
				request.setAttribute("vCsvPath", giisParamService.getParamValueV2("CSV_PATH"));
				request.setAttribute("vCsvDirName", giisParamService.getParamValueV2("CSV_DIR_NAME"));
				request.setAttribute("userId", USER.getUserId());
				PAGE = "/pages/underwriting/overlay/propertyFloater/uploadPropertyFloater.jsp";
			}
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (NullPointerException e) {
			message = ExceptionHandler.handleException(e, USER);
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
