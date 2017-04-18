package com.geniisys.giuts.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISISSource;
import com.geniisys.common.entity.GIISLine;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISISSourceFacadeService;
import com.geniisys.common.service.GIISLineFacadeService;
import com.geniisys.common.service.GIISUserFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.giuts.service.CopyUtilitiesService;
import com.seer.framework.util.ApplicationContextReader;

public class CopyUtilitiesController extends BaseController {

	private static final long serialVersionUID = 1L;
	
	private static Logger log = Logger.getLogger(CopyUtilitiesController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
		CopyUtilitiesService copyUtil = (CopyUtilitiesService) APPLICATION_CONTEXT.getBean("copyUtilitiesService");
		
		try {
			if("showSummarizePoltoPar".equals(ACTION)) {
				System.out.println("CopyUtilitiesController - showSummarizePoltoPar");
				PAGE = "/pages/underwriting/utilities/copyUtilities/summarizePol/summarizePoltoPar.jsp";
			}else if("showCopyPolicyEndt".equals(ACTION)){
				PAGE = "/pages/underwriting/utilities/copyPolicyEndt/copyPolicyMain.jsp";	
			}else if("checkIfPolicyExists".equals(ACTION)) {
				//CopyUtilitiesService copyUtil = (CopyUtilitiesService) APPLICATION_CONTEXT.getBean("copyUtilitiesService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				System.out.println("checkIfPolicyExists - "+params);
				copyUtil.checkIfPolicyExists(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
			else if("showCopyParToNewPar".equals(ACTION)){
				GIISISSourceFacadeService issServ = (GIISISSourceFacadeService) APPLICATION_CONTEXT.getBean("giisIssourceFacadeService");
				GIISLineFacadeService lineserv	= (GIISLineFacadeService) APPLICATION_CONTEXT.getBean("giisLineFacadeService");
				GIISUserFacadeService userserv = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService"); 
				String userId = USER.getUserId();
				
				String riSwitch = request.getParameter("riSwitch");
				Map<String, Object> parameters = new HashMap<String, Object>();
				parameters.put("userId", userId);
				parameters.put("moduleId", "GIUTS007");
				request.setAttribute("defaultIssCd", issServ.getDefaultIssCd(riSwitch, USER.getUserId()));
				request.setAttribute("checkedLineIssourceListing", lineserv.getCheckedLineIssourceList(parameters));
				request.setAttribute("userValidated", userserv.giacValidateUser(userId, "OV", "GIUTS007"));
				Calendar cal=Calendar.getInstance();
				int year = cal.get(Calendar.YEAR);
				request.setAttribute("year", year%100);
				String[] params = {"GIUTS007", USER.getUserId()};
				request.setAttribute("userId", USER.getUserId());
				request.setAttribute("lineListing", helper.getList(LOVHelper.LINE_LISTING, params));
				List<GIISLine> lineList = lineserv.getGiisLineList();
				List<GIISISSource> issList = issServ.getIssueSourceAllList();
				JSONArray jsonLineList = new JSONArray();
				JSONArray jsonIssList = new JSONArray();
				for(GIISLine x:lineList){
					jsonLineList.put(x.getLineCd());
				}
				for(GIISISSource x:issList){
					jsonIssList.put(x.getIssCd());
				}
				request.setAttribute("jsonLineList", jsonLineList);
				request.setAttribute("jsonIssList", jsonIssList);
				
				if ("Y".equals(riSwitch)) {
					log.info("riSwitch  ==="+riSwitch);
					log.info("ri-source listing "+helper.getList(LOVHelper.RI_SOURCE_LISTING));
					request.setAttribute("issourceListing", helper.getList(LOVHelper.RI_SOURCE_LISTING));
				} else {
					log.info("riSwitch  ==="+riSwitch);
					log.info("branch source listing "+helper.getList(LOVHelper.BRANCH_SOURCE_LISTING, params));
					request.setAttribute("issourceListing", helper.getList(LOVHelper.BRANCH_SOURCE_LISTING)); 	
				}
				System.out.println("CopyUtilitiesController - showCopyParToNewPar");
				PAGE = "/pages/underwriting/utilities/copyParToNewPar/subPages/copyParToPar.jsp";
			}
			else if("copyParToPar".equals(ACTION)){
				System.out.println(" *********copy par to par *************");
				GIPIPARListService gipiParListService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
				String issCd = request.getParameter("issCd");
				int parId = Integer.parseInt(request.getParameter("parId"));
				String varLineCd = request.getParameter("varLineCd");
				System.out.println("issCd =" +issCd);
				String newParNo = " ";
				String oldParNo = " ";
				Map<String, Object> params = new HashMap<String, Object>();
				
				params.put("parId", parId);
				params.put("userId", USER.getUserId());
				params.put("issCd", issCd);
				params.put("varLineCd", varLineCd);
				params.put("newParNo", newParNo);
				params.put("oldParNo", oldParNo);
				
				gipiParListService.copyParToParGiuts007(params);
				newParNo = (String) params.get("newParNo");
				oldParNo = (String) params.get("oldParNo");
				message = "<center>This PAR No.:</center> <br>"+
						  "<center><font color=\"BLUE\">"+oldParNo+"</font></center> <br>"+
						  "<center>Had Been Copied to PAR No.:</center> <br>"+
						  "<center><font color=\"RED\">"+newParNo+"</font></center>";
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkParStatus".equals(ACTION)){
				System.out.println(" *********check PAR status *************");
				GIPIPARListService gipiParListService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
				String issCd = request.getParameter("issCd");
				String lineCd = request.getParameter("lineCd");
				int quoteSeqNo = Integer.parseInt(request.getParameter("quoteSeqNo"));
				int parYr = Integer.parseInt(request.getParameter("parYr"));
				int parSeqNo = Integer.parseInt(request.getParameter("parSeqNo"));
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("issCd", issCd);
				params.put("lineCd", lineCd);
				params.put("parYr", parYr);
				params.put("parSeqNo", parSeqNo);
				params.put("userId", USER.getUserId());
				params.put("quoteSeqNo", quoteSeqNo);
				JSONArray jsonArray = new JSONArray(gipiParListService.getParStatusGiuts007(params));
				message = jsonArray.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkLinePerUser".equals(ACTION)){
				System.out.println(" *********check line per user *************");
				String issCd = request.getParameter("issCd");
				String lineCd = request.getParameter("lineCd");
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("issCd", issCd);
				params.put("lineCd", lineCd);
				params.put("moduleName", "GIUTS007");
				params.put("userId", USER.getUserId());
				GIISUserFacadeService giisFacadeService =  (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService");
				String newLineCd = giisFacadeService.checkUserPerLineGiuts007(params);
				System.out.println("status=="+newLineCd);
				message = newLineCd;
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkIssCdExistPerUser".equals(ACTION)){
				System.out.println(" *********check issCd per user *************");
				String issCd = request.getParameter("issCd");
				String lineCd = request.getParameter("lineCd");
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("issCd", issCd);
				params.put("lineCd", lineCd);
				params.put("moduleName", "GIUTS007");
				params.put("userId", USER.getUserId());
				GIISUserFacadeService giisFacadeService =  (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService");
				String exists = giisFacadeService.checkIssCdExistPerUserGiuts007(params);
				System.out.println("status=="+exists);
				message = exists;
				PAGE = "/pages/genericMessage.jsp";
			}else if("summarizePolToPar".equals(ACTION)) {
				System.out.println("*********Summarizing Policy to PAR*************");
				//CopyUtilitiesService copyUtil = (CopyUtilitiesService) APPLICATION_CONTEXT.getBean("copyUtilitiesService");
				message = copyUtil.summarizePolToPar(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("confirmPolicySummarized".equals(ACTION)) {
				request.setAttribute("policy", request.getParameter("policy"));
				request.setAttribute("par", request.getParameter("par"));
				request.setAttribute("isPack", request.getParameter("isPack"));
				PAGE = "/pages/underwriting/utilities/copyUtilities/summarizePol/subPages/summaryOverlay.jsp";
			}else if("validateSummaryLine".equals(ACTION)) {
				System.out.println("*********validateSummaryIssCd*************");
				//CopyUtilitiesService copyUtil = (CopyUtilitiesService) APPLICATION_CONTEXT.getBean("copyUtilitiesService");
				copyUtil.validateLine(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateSummaryIssCd".equals(ACTION)) {
				System.out.println("*********validateSummaryIssCd*************");
				//CopyUtilitiesService copyUtil = (CopyUtilitiesService) APPLICATION_CONTEXT.getBean("copyUtilitiesService");
				copyUtil.validateIssCd(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkPolicy".equals(ACTION)) {
				System.out.println("*********checking policy*************");
				//CopyUtilitiesService copyUtil = (CopyUtilitiesService) APPLICATION_CONTEXT.getBean("copyUtilitiesService");
				copyUtil.checkPolicy(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateLineCdGiuts008a".equals(ACTION)){
				message = copyUtil.validateLineCdGiuts008a(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateIssCdGiuts008a".equals(ACTION)){
				message = copyUtil.validateIssCdGiuts008a(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("copyPackPolicyGiuts008a".equals(ACTION)){
				message = copyUtil.copyPackPolicyGiuts008a(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateParIssCd".equals(ACTION)){
				copyUtil.validateParIssCd(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch(SQLException e){
			System.out.println(e.getErrorCode());
			if(e.getErrorCode() > 20000){
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
