package com.geniisys.gipi.pack.controllers;

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
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.gipi.pack.entity.GIPIPackPolbasic;
import com.geniisys.gipi.pack.service.GIPIPackPolbasicService;
import com.seer.framework.util.ApplicationContextReader;

public class GIPIPackPolbasicController extends BaseController {

	private static final long serialVersionUID = 1L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIPackPolbasicController.class);

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			GIPIPackPolbasicService gipiPackPolbasicService = (GIPIPackPolbasicService) APPLICATION_CONTEXT.getBean("gipiPackPolbasicService");
			
			if("getPolicyNoForPackEndt".equals(ACTION)) {
				log.info("Getting list of Policies for Endorsement...");
				String lineCd = request.getParameter("lineCd");
				String issCd = request.getParameter("issCd");
				String sublineCd = request.getParameter("sublineCd");
			
				int pageNo = Integer.parseInt((request.getParameter("polPageNo") == "" || request.getParameter("polPageNo") == null) ? "1" : request.getParameter("polPageNo"));
				System.out.println("Page obtained: " + pageNo);
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", (lineCd == null) ? "" : lineCd);
				params.put("issCd", (issCd == null) ? "" : issCd);
				params.put("sublineCd", (sublineCd == null) ? "" : sublineCd);
				params.put("keyword", "");
				
				log.info("Get POlicy No For Pack Endt:");
				log.info("Line Cd: " + params.get("lineCd"));
				log.info("Iss Cd: " + params.get("issCd"));
				log.info("Subline Cd: " + params.get("sublineCd"));
				
				PaginatedList policies = gipiPackPolbasicService.getPolicyForPackEndt(params, 1);
				
				policies.gotoPage(pageNo-1);
				//System.out.println("attrib2: " + lineCd + "+" + issCd + "+" + sublineCd + "totalpageNo: " + policies.getNoOfPages() + " - " + pageNo);
				
				request.setAttribute("curLine", lineCd);
				request.setAttribute("curIss", issCd);
				request.setAttribute("curSubline", sublineCd);
				
				request.setAttribute("polPageNo", pageNo);
				request.setAttribute("policies", policies);
				request.setAttribute("noOfPolPages", policies.getNoOfPages());
				request.setAttribute("isPack", "Y");
				PAGE = "/pages/underwriting/endt/basicInfo/subPages/policyNoForEndtSubPages/selectPolicyNo.jsp";
			} else if("filterPolicyForPackEndt".equals(ACTION)) {
				log.info("Filtering list of Policies...");
				String lineCd = request.getParameter("curLine");
				String issCd = request.getParameter("curIss");
				String sublineCd = request.getParameter("curSubline");
				String keyword = request.getParameter("keywordPol");
				
				int pageNo = Integer.parseInt(request.getParameter("polPageNo"));
				System.out.println("pageNumber: " + pageNo);
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", lineCd);
				params.put("issCd", issCd);
				params.put("sublineCd", sublineCd);
				params.put("keyword", keyword);
				
				PaginatedList policies = gipiPackPolbasicService.getPolicyForPackEndt(params, pageNo);
				policies.gotoPage(pageNo-1);
				System.out.println("filterPolicyForEndt: " + lineCd + "+" + issCd + "+" + sublineCd + "totalpageNo: " + policies.getNoOfPages() + " - " + pageNo);
				request.setAttribute("polPageNo", pageNo);
				request.setAttribute("policies", policies);
				request.setAttribute("noOfPolPages", policies.getNoOfPages());
				PAGE = "/pages/underwriting/endt/basicInfo/subPages/policyNoForEndtSubPages/selectPolicyNoTable.jsp";
			} else if("showGeneratePackageBinders".equals(ACTION)){
				//gipiPackPolbasicService.getPackageBinders(request, USER);
				PAGE = "/pages/underwriting/reInsurance/packageBinders/packageBinders.jsp";
			} else if("checkPackPolicyGiexs006".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
				params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
				params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
				Debug.print("checkPackPolicyGiexs006 params:" + params);
				
				List<GIPIPackPolbasic> resultParams = gipiPackPolbasicService.checkPackPolicyGiexs006(params);
				Debug.print("getPackPolicyId resultParams:" + resultParams);
				
				message = new JSONArray(resultParams).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("checkIfPackGIACS007".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
				params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
				params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
				message = gipiPackPolbasicService.checkIfPackGIACS007(params);
				System.out.println("checkIfPackGIACS007:::::::"+message);
				PAGE = "/pages/genericMessage.jsp";
			/*} else if("checkIfPackGIACS007".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
				params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
				params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
				message = gipiPackPolbasicService.checkIfPackGIACS007(params);
				System.out.println("checkIfPackGIACS007:::::::"+message);
				PAGE = "/pages/genericMessage.jsp";*/
			} else if("checkIfBillsSettledGIACS007".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("nbtDue", request.getParameter("nbtDue"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
				params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
				params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
				message = gipiPackPolbasicService.checkIfBillsSettledGIACS007(params);
				System.out.println("checkIfPackGIACS007:::::::"+message);
				PAGE = "/pages/genericMessage.jsp";
			} else if("showReinstateHistory".equals(ACTION)) { // jomsdiago 07.29.2013 for GIUTS028A
				JSONObject jsonReinstatementHistory = gipiPackPolbasicService.showReinstateHistory(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonReinstatementHistory.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonReinstatementHistory", jsonReinstatementHistory);
					request.setAttribute("packPolicyId", request.getParameter("packPolicyId"));
					PAGE = "/pages/underwriting/utilities/spoilageReinstatement/packageReinstatement/packageReinstatementHistory.jsp";				
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = "SQL Exception occured...<br />"+e.getCause();
			PAGE = "/pages/genericMessage.jsp";	
		} catch (NullPointerException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			PAGE = "/pages/genericMessage.jsp";
			message = "Null Pointer Exception occured...<br />"+e.getCause();
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = "Unhandled exception occured...<br />"+e.getCause();
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);			
			this.doDispatch(request, response, PAGE);
		}
	}

}
