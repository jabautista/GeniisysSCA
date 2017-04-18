package com.geniisys.gixx.controller;

import java.io.IOException;
import java.sql.SQLException;
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
import com.geniisys.gixx.entity.GIXXPolbasic;
import com.geniisys.gixx.service.GIXXPolbasicService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GIXXPolbasicController", urlPatterns="/GIXXPolbasicController")
public class GIXXPolbasicController extends BaseController{

	/** The constant serialVersionUID.	 */
	private static final long serialVersionUID = 1L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIXXPolbasicController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try {
			log.info("Initializing " + this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			GIXXPolbasicService gixxPolbasicService = (GIXXPolbasicService) APPLICATION_CONTEXT.getBean("gixxPolbasicService");
			
			if("showPolicySummary".equals(ACTION)){
				log.info("Loading policy summary information...");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("issCd", request.getParameter("issCd"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
				params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
				params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
				params.put("refPolNo", request.getParameter("refPolNo"));
				System.out.println("PARAMS: "+params);
				request.setAttribute("moduleId", "GIPIS101");
				//Map<String, Object> policySummaryInfo = gixxPolbasicService.getPolicySummary(params);
				
				if("SU".equalsIgnoreCase(request.getParameter("lineCd"))){
					GIXXPolbasic polbasicInfo = gixxPolbasicService.getPolicySummarySu(params);
					request.setAttribute("policyBasicInfoSu", new JSONObject((GIXXPolbasic)StringFormatter.escapeHTMLInObject(polbasicInfo)));
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/policyInfoBasicSu.jsp";
				} else{
					GIXXPolbasic polbasicInfo = gixxPolbasicService.getPolicySummary(params);
					//request.setAttribute("policySummaryInfo", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));
					request.setAttribute("policyBasicInfo", new JSONObject((GIXXPolbasic)StringFormatter.escapeHTMLInObject(polbasicInfo)));
					//PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/policySummary.jsp";
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/policyInfoBasic.jsp";
				}
			} else if("showPolicyMainInfo".equals(ACTION)){
				log.info("Loading policy main information...");
				/*Integer policyId = Integer.parseInt(request.getParameter("policyId"));
				HashMap<String, Object> policyMainInfo = gipiPolbasicService.getPolicyMainInformation(policyId);
				request.setAttribute("policyMainInfo", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(policyMainInfo)));*/
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("issCd", request.getParameter("issCd"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
				params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
				params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
				params.put("refPolNo", request.getParameter("refPolNo"));
				//System.out.println("PARAMS before calling service: "+params);
				GIXXPolbasic polbasicInfo = gixxPolbasicService.getPolicySummary(params);
				System.out.println("*****RETRIEVED Policy Summary [after calling service]: " + params);
				request.setAttribute("moduleId", "GIPIS101");
				if(polbasicInfo != null){
					request.setAttribute("policyMainInfo", new JSONObject((GIXXPolbasic)StringFormatter.escapeHTMLInObject(polbasicInfo)));
				}
				//System.out.println("PARAMS: "+params);
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/policyMainInformation.jsp";				
			} else if("bondPolicyData".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("extractId", Integer.parseInt(request.getParameter("extractId")));
				params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
				
				GIXXPolbasic bondPolicyData = gixxPolbasicService.getBondPolicyData(params);
				
				if(bondPolicyData == null){
					request.setAttribute("bondPolicyData", new JSONObject());
				} else {
					request.setAttribute("bondPolicyData", new JSONObject((GIXXPolbasic)StringFormatter.replaceQuotesInObject(bondPolicyData)));
				}				
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/bondPolicyDetails.jsp";	
			} else if("getGIXXMarineDetails".equals(ACTION)){
				Map<String, Object> marineDetails = new HashMap<String, Object>();
				marineDetails.put("surveyAgentCd", request.getParameter("surveyAgentCd"));
				marineDetails.put("surveyAgent", request.getParameter("surveyAgent"));
				marineDetails.put("settlingAgentCd", request.getParameter("settlingAgentCd"));
				marineDetails.put("settlingAgent", request.getParameter("settlingAgent"));
				request.setAttribute("marineDetails", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(marineDetails)));
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/policyMarineDetails.jsp";
			} else if ("getGIXXAdditionalInfo".equals(ACTION)){
				request.setAttribute("policyAdditionalInfo", new JSONObject(request.getParameter("paramPolicyBasicInfo")));
				System.out.println("policyAdditionalInfo: " +new JSONObject(request.getParameter("paramPolicyBasicInfo")).toString());
				//added by robert SR 20307 10.27.15
				if(request.getParameter("displayPrincipal").equals("Y")){
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("ACTION", "getAddlInfoPrincipalListing");
					params.put("summarySw", request.getParameter("summarySw"));
					params.put("extractId", request.getParameter("extractId"));
					params.put("pageSize", 3);
					params.put("principalType", "P");
					Map<String, Object> principalTableGrid = TableGridUtil.getTableGrid(request, params);
					JSONObject principalTG = new JSONObject(principalTableGrid);
					request.setAttribute("principalTG", principalTG);
					params.put("principalType", "C");
					Map<String, Object> contractorTableGrid = TableGridUtil.getTableGrid(request, params);
					JSONObject contractorTG = new JSONObject(contractorTableGrid);
					request.setAttribute("contractorTG", contractorTG);
				}
				//end robert SR 20307 10.27.15
				PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/policyAdditionalInfo.jsp";
			}
			
		} catch (SQLException e){
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
