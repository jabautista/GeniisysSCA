package com.geniisys.giri.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giri.service.GIRIBinderService;
import com.geniisys.giri.service.GIRIFrpsRiService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.Debug;
import com.seer.framework.util.StringFormatter;

public class GIRIFrpsRiController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(GIRIWFrpsRiController.class);
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("doProcessing");
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIRIFrpsRiService giriFrpsRiService = (GIRIFrpsRiService) APPLICATION_CONTEXT.getBean("giriFrpsRiService");
		GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
		PAGE = "/pages/genericMessage.jsp";
		
		try{
			
			if ("showModifyPostedDtls".equals(ACTION)){
				GIRIBinderService giriBinderService = (GIRIBinderService) APPLICATION_CONTEXT.getBean("giriBinderService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("frpsYy", request.getParameter("frpsYy"));
				params.put("frpsSeqNo", request.getParameter("frpsSeqNo"));
				
				Debug.print("showModifyPostedDtls Params: " + params);
				
				Map<String, Object> tableGridParams = new HashMap<String, Object>();
				tableGridParams.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				tableGridParams.put("user_id", USER.getUserId());
				tableGridParams.put("filter", params);
				tableGridParams = giriBinderService.getPostedDtls(tableGridParams);
				request.setAttribute("binderListTableGrid", new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(tableGridParams)));
				
				PAGE = "/pages/underwriting/reInsurance/postFrps/subPages/showPostedTableGridDtls.jsp";
			} else if ("refreshBinderListTableGrid".equals(ACTION)){
				GIRIBinderService giriBinderService = (GIRIBinderService) APPLICATION_CONTEXT.getBean("giriBinderService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("frpsYy", request.getParameter("frpsYy"));
				params.put("frpsSeqNo", request.getParameter("frpsSeqNo"));
				
				Debug.print("showModifyPostedDtls Params: " + params);
				
				Map<String, Object> tableGridParams = new HashMap<String, Object>();
				tableGridParams.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				tableGridParams.put("user_id", USER.getUserId());
				tableGridParams.put("filter", params);
				tableGridParams = giriBinderService.getPostedDtls(tableGridParams);
				
				message = new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(tableGridParams)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("showReverseBinderPage".equals(ACTION)){
				log.info("Loading Reverse Binder Page...");
			    String loadFromMenu = request.getParameter("loadFromUWMenu");
					
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("user", USER.getUserId());
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("frpsYy", request.getParameter("frpsYy"));
				params.put("frpsSeqNo", request.getParameter("frpsSeqNo"));
				params = giriFrpsRiService.getFrpsRiParams(params);
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				request.setAttribute("frpsRiGrid", new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)));
				log.info("FrpsRiGrid ::: " + params);
				request.setAttribute("fromUWMenu", loadFromMenu);
				PAGE = "/pages/underwriting/reInsurance/reverseBinder/reverseBinder.jsp";
			}else if ("refreshFrpsRiGrid".equals(ACTION)) {
				log.info("Refresh Binder Listing tablegrid...");
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("user", USER.getUserId());
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("frpsYy", request.getParameter("frpsYy"));
				params.put("frpsSeqNo", request.getParameter("frpsSeqNo"));
				params = giriFrpsRiService.getFrpsRiParams(params);
				JSONObject json = new JSONObject(params);
				message = StringFormatter.replaceTildes(json.toString());
				PAGE = "/pages/genericMessage.jsp";
			}else if("showReverseBinderTableGrid".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("user", USER.getUserId());
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("frpsYy", request.getParameter("frpsYy"));
				params.put("frpsSeqNo", request.getParameter("frpsSeqNo"));
				params.put("ACTION", "getGIRIFrpsRi");
				log.info("Reverse Binder Parameters: "+params);
				Map<String, Object> frpsRiGrid = TableGridUtil.getTableGrid(request, params);
				request.setAttribute("restrictBndrWFacPayt", giisParametersService.getParamValueV2("RESTRICT_NEG_OF_BNDR_WFACPAYT")); //added by christian 12/13/2012
				request.setAttribute("restrictBndrWClaim", giisParametersService.getParamValueV2("RESTRICT_NEG_OF_BNDR_WCLAIM"));
				JSONObject json = new JSONObject(frpsRiGrid);
				if("1".equals(request.getParameter("refresh"))){
					System.out.println("refresh");
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					System.out.println("Info");
					request.setAttribute("frpsRiGrid", json);
					request.setAttribute("fromUWMenu", request.getParameter("loadFromUWMenu"));
					PAGE = "/pages/underwriting/reInsurance/reverseBinder/reverseBinder.jsp";
				}
			}else if ("performReversalGiuts004".equals(ACTION)) {
				log.info("Performing Reversal of Binder...");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("reverseSw", request.getParameter("reverseSw"));
				params.put("fnlBinderId", request.getParameter("fnlBinderId"));
				params.put("frpsYy", request.getParameter("frpsYy"));
				params.put("frpsSeqNo", request.getParameter("frpsSeqNo"));
				params.put("distNo", request.getParameter("distNo"));
				params.put("userId", USER.getUserId());
				params.put("workflowMsgr", "");
				params.put("msg", "");
				params = giriFrpsRiService.performReversalGiuts004(params);
				String msg = (String) (params.get("msg") == null ? "" : params.get("msg"));
				String workflowMsgr = (String) (params.get("workflowMsgr") == null ? "" : params.get("workflowMsgr"));
				message = workflowMsgr +","+msg ;
				PAGE = "/pages/genericMessage.jsp";
			}else if ("checkBinderGiuts004".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("riCd", request.getParameter("riCd") == null ? "" : request.getParameter("riCd"));
				params.put("fnlBinderId", request.getParameter("fnlBinderId") == null ? "" : request.getParameter("fnlBinderId"));
				params.put("msg", "");
				params = giriFrpsRiService.checkBinderGiuts004(params);
				String msg = (String) (params.get("msg") == null ? "" : params.get("msg"));
				message = msg;
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getOutFaculTotAmtGIUTS004".equals(ACTION)) { //ENHANCEMENT - Christian 12132012
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("riCd", Integer.parseInt(request.getParameter("riCd")));
				params.put("fnlBinderId", Integer.parseInt(request.getParameter("fnlBinderId")));
				params.put("frpsYy", Integer.parseInt(request.getParameter("frpsYy")));
				params.put("frpsSeqNo", Integer.parseInt(request.getParameter("frpsSeqNo")));
				String outFaculTotAmt = giriFrpsRiService.getOutFaculTotAmtGIUTS004(params).toString();
				System.out.println("outFaculTotAmt " + outFaculTotAmt);
				message = outFaculTotAmt;
				PAGE = "/pages/genericMessage.jsp";
			}else if ("checkBinderWithClaimsGIUTS004".equals(ACTION)) { //ENHANCEMENT - Christian 12142012
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("fnlBinderId", Integer.parseInt(request.getParameter("fnlBinderId")));
				params.put("frpsYy", Integer.parseInt(request.getParameter("frpsYy")));
				params.put("frpsSeqNo", Integer.parseInt(request.getParameter("frpsSeqNo")));
				params.put("distNo", Integer.parseInt(request.getParameter("distNo")));
				System.out.println("checkBinderWithClaimsGIUTS004 p: " + params);
				String isBinderWithClaims = giriFrpsRiService.checkBinderWithClaimsGIUTS004(params);
				message = isBinderWithClaims;
				PAGE = "/pages/genericMessage.jsp";
			}else if ("showBinderListing".equals(ACTION)){
				log.info("Loading Binder Table Grid...");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGIRIBinderTableGridMap");
				params.put("moduleId", request.getParameter("moduleId") == null ? "GIRIS053" : request.getParameter("moduleId"));
				params.put("policyId", request.getParameter("policyId") == null ? "" : request.getParameter("policyId"));
				Map<String, Object> binderTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(binderTableGrid);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("binderTableGridListing", json);
					request.setAttribute("policyId", request.getParameter("policyId"));
					PAGE = "/pages/underwriting/reInsurance/groupBinders/groupBindersMain.jsp";
				}
			}else if("getPackageBinderList".equals(ACTION)){
				giriFrpsRiService.getGiriFrpsRiGrid3(request, USER);
				PAGE = "1".equals(request.getParameter("refresh")) ? "/pages/genericObject.jsp" :"/pages/underwriting/reInsurance/packageBinders/packageBinderList.jsp";

			}else if("reversePackageBinder".equals(ACTION)){
				message = giriFrpsRiService.reversePackageBinder(request, USER);
			}else if("generatePackageBinder".equals(ACTION)){
				message = giriFrpsRiService.generatePackageBinder(request, USER);
			}else if("groupBinders".equals(ACTION)){
				giriFrpsRiService.groupBinders(request, USER);
				message="SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("ungroupBinders".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("user", USER.getUserId());
				params.put("masterBndrId",request.getParameter("masterBndrId") == null ? "" : request.getParameter("masterBndrId"));
				giriFrpsRiService.ungroupBinders(request, USER);
				message="SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
		}catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
			System.out.println("SUCCESS");
		}
	}

}
