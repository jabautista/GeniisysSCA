package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.entity.GICLClaims;
import com.geniisys.gicl.entity.GICLRecoveryRids;
import com.geniisys.gicl.service.GICLAdviceService;
import com.geniisys.gicl.service.GICLAdvsFlaService;
import com.geniisys.gicl.service.GICLClaimsService;
import com.geniisys.gicl.service.GICLRecoveryRidsService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GICLAdvsFlaController", urlPatterns={"/GICLAdvsFlaController"})
public class GICLAdvsFlaController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GICLReserveSetupController.class);
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("do processing");
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GICLAdvsFlaService giclAdvsFlaService = (GICLAdvsFlaService)APPLICATION_CONTEXT.getBean("giclAdvsFlaService");
		GICLClaimsService giclClaimsService = (GICLClaimsService)APPLICATION_CONTEXT.getBean("giclClaimsService");
		
		try{
			Integer claimId = Integer.parseInt(request.getParameter("claimId") == null || "".equals(request.getParameter("claimId")) ? "0" : request.getParameter("claimId"));
			
			if("showGenerateFLAPage".equals(ACTION)){
				GICLClaims flaInfo = claimId == 0 ? null : giclClaimsService.getClaimsBasicInfoDtls(claimId);
				request.setAttribute("flaInfoJSON", new JSONObject(flaInfo != null ? StringFormatter.escapeHTMLInObject(flaInfo): new GICLClaims()));
				request.setAttribute("claimId", claimId);
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getFinalLossAdviceList");
				params.put("claimId", claimId);
				Map<String, Object> adviceDtlsTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(adviceDtlsTableGrid);
				
				if(request.getParameter("callingForm") != null && request.getParameter("callingForm").equals("GICLS039")){
					request.setAttribute("isCloseClaim", "Y");
				}
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("adviceDtlsTableGrid", json);
					PAGE = "/pages/claims/generateAdvice/generateFLA/fla.jsp";
				}
			}else if("getFLADistDtls".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("claimId", request.getParameter("claimId"));
				params.put("adviceId", request.getParameter("adviceId"));
				params.put("lineCd", request.getParameter("lineCd"));
				Map<String, Object> distDtlsTG = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(distDtlsTG);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("distDtlsTableGrid", json);
					PAGE = "/pages/claims/generateAdvice/generateFLA/subpages/flaDistDtls.jsp";
				}
			}else if("getFLADtls".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("claimId", request.getParameter("claimId"));
				params.put("grpSeqNo", request.getParameter("grpSeqNo"));
				params.put("shareType", request.getParameter("shareType"));
				params.put("adviceId", request.getParameter("adviceId"));
				Map<String, Object> flaDtlsTG = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(flaDtlsTG);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("flaDtlsTableGrid", json);
					PAGE = "/pages/claims/generateAdvice/generateFLA/subpages/flaDtls.jsp";
				}
			}else if("checkGeneratedFla".equals(ACTION)){
				GICLAdviceService giclAdviceService = (GICLAdviceService)APPLICATION_CONTEXT.getBean("giclAdviceService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("claimId", Integer.parseInt(request.getParameter("claimId")));
				params.put("adviceId", Integer.parseInt(request.getParameter("adviceId")));
				message = giclAdviceService.checkGeneratedFla(params);
				request.setAttribute("object",message);
				PAGE = "/pages/genericObject.jsp";
			}else if("generateFla".equals(ACTION)){
				log.info("Generating FLA...");
				message = giclAdvsFlaService.generateFLA(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if("cancelFla".equals(ACTION)){
				log.info("Cancelling FLA...");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("claimId", request.getParameter("claimId"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("laYy", request.getParameter("laYy"));
				params.put("shareType", request.getParameter("shareType"));
				params.put("advFlaId", request.getParameter("advFlaId"));
				params.put("userId", USER.getUserId());
				params = giclAdvsFlaService.cancelFla(params);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("updateFla".equals(ACTION)){
				log.info("Updating FLA...");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("claimId", request.getParameter("claimId"));
				params.put("grpSeqNo", request.getParameter("grpSeqNo"));
				params.put("shareType", request.getParameter("shareType"));
				params.put("adviceId", request.getParameter("adviceId"));
				params.put("flaSeqNo", request.getParameter("flaSeqNo"));
				params.put("flaTitle", request.getParameter("flaTitle"));
				params.put("flaHeader", request.getParameter("flaHeader"));
				params.put("flaFooter", request.getParameter("flaFooter"));
				params.put("userId", USER.getUserId());
				giclAdvsFlaService.updateFla(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("getRecovery".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("claimId", request.getParameter("claimId"));
				params.put("advFlaId", request.getParameter("advFlaId"));
				GICLRecoveryRidsService giclRecoveryRidsService = (GICLRecoveryRidsService)APPLICATION_CONTEXT.getBean("giclRecoveryRidsService");
				GICLRecoveryRids flaRecovery = giclRecoveryRidsService.getFlaRecovery(params);
				request.setAttribute("flaRecoveryJSON", new JSONObject(flaRecovery != null ? StringFormatter.escapeHTMLInObject(flaRecovery): new GICLRecoveryRids()));
				PAGE = "/pages/genericMessage.jsp";
			}else if("validatePdFla".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("userId", USER.getUserId());
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("laYy", request.getParameter("laYy"));
				params.put("flaSeqNo", request.getParameter("flaSeqNo"));
				params.put("riCd", request.getParameter("riCd"));
				params.put("override", "N");
				message = giclAdvsFlaService.validatePdFla(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("updateFlaPrintSw".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("claimId", request.getParameter("claimId"));
				params.put("shareType", request.getParameter("shareType"));
				params.put("riCd", request.getParameter("riCd"));
				params.put("flaSeqNo", request.getParameter("flaSeqNo"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("laYy", request.getParameter("laYy"));
				params.put("userId", USER.getUserId());
				giclAdvsFlaService.updateFlaPrintSw(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("showOverrideWindow".equals(ACTION)){
				PAGE = "/pages/claims/generateAdvice/generateFLA/popups/overrideFlaUser.jsp";
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