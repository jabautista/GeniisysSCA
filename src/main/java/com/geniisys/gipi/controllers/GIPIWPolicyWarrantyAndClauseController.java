/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

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
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.entity.GIPIWPolicyWarrantyAndClause;
import com.geniisys.gipi.service.GIPIWPolbasService;
import com.geniisys.gipi.service.GIPIWPolicyWarrantyAndClauseFacadeService;
import com.geniisys.gipi.util.GIPIPARUtil;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIWPolicyWarrantyAndClauseController.
 */
public class GIPIWPolicyWarrantyAndClauseController extends BaseController {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1537523512157139453L;
	private static Logger log = Logger.getLogger(GIPIWPolicyWarrantyAndClauseController.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException { //, String env
		log.info("doProcessing");
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIPIWPolicyWarrantyAndClauseFacadeService gipiWcService = (GIPIWPolicyWarrantyAndClauseFacadeService) APPLICATION_CONTEXT.getBean("gipiWPolicyWarrantyAndClauseFacadeService"); // +env
			
			Map<String, Object> parInfo = GIPIPARUtil.getPARInfo(request);
			request = GIPIPARUtil.setPARInfo(request, parInfo);
			
			String parType 		= (request.getParameter("globalParType") == null ? "" : request.getParameter("globalParType")); 
			String lineCd 		= (request.getParameter("globalLineCd") == null ? "" : request.getParameter("globalLineCd"));
			int parId 			= Integer.parseInt((request.getParameter("globalParId") == null) ? "0" : request.getParameter("globalParId"));
			int assdNo			= Integer.parseInt((request.getParameter("globalAssdNo") == null) ? "0" : request.getParameter("globalAssdNo"));
			String assdName		= (request.getParameter("globalAssdName") == null ? "" : request.getParameter("globalAssdName"));
			String parNo		= (request.getParameter("globalParNo") == null ? "" : request.getParameter("globalParNo"));
			
			if ("showPCPage".equals(ACTION)) {
				GIPIWPolbasService polbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
			
				//String[] args = {lineCd}; 
				//LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // +env
				//List<LOV> wcTitles = lovHelper.getList(LOVHelper.WARRANTY_LISTING, args);
				//JSONArray objWarrClause = new JSONArray(wcTitles);
				
				String policyNo = polbasService.getPolicyNoForEndt(parId);
				request.setAttribute("parType", parType);
				//request.setAttribute("wcTitles", wcTitles);
				request.setAttribute("assdNo", assdNo);
				request.setAttribute("assdName", assdName);
				request.setAttribute("parNo", parNo);
				request.setAttribute("policyNo", policyNo);
				//request.setAttribute("objWarrClause", objWarrClause);				
				
				System.out.println("parNo: " + parNo);
				PAGE = "/pages/underwriting/policyWarrantyAndClauses.jsp";
			} else if ("goToPage".equals(ACTION))	{
				int pageNo = Integer.parseInt(request.getParameter("pageNo"));
				PAGE = "/pages/underwriting/subPages/warrantyAndClausesTable.jsp";
				request = this.getWarrantiesAndClauses(request, gipiWcService, lineCd, parId, pageNo);
			} else if ("saveWPolWC".equals(ACTION))	{
				String[] wcCds 			= request.getParameterValues("wcCd");
				String[] printSeqNos 	= request.getParameterValues("printSeqNo");
				String[] wcTitles 		= request.getParameterValues("wcTitle");
				String[] wcText1 		= request.getParameterValues("wcText1");
				String[] wcText2 		= request.getParameterValues("wcText2");
				String[] wcText3 		= (request.getParameterValues("wcText3") == null ? request.getParameterValues("wcText3") : null);
				String[] wcText4 		= (request.getParameterValues("wcText4") == null ? request.getParameterValues("wcText4") : null);
				String[] wcText5 		= (request.getParameterValues("wcText5") == null ? request.getParameterValues("wcText5") : null);
				String[] wcText6 		= (request.getParameterValues("wcText6") == null ? request.getParameterValues("wcText6") : null);
				String[] wcText7 		= (request.getParameterValues("wcText7") == null ? request.getParameterValues("wcText7") : null);
				String[] wcText8 		= (request.getParameterValues("wcText8") == null ? request.getParameterValues("wcText8") : null);
				String[] wcText9 		= (request.getParameterValues("wcText9") == null ? request.getParameterValues("wcText9") : null);
				String[] printSws 		= request.getParameterValues("printSw");
				String[] changeTags 	= request.getParameterValues("changeTag");
				String[] wcTitles2 		= request.getParameterValues("wcTitle2");
				
				//for(int i=0; i<printSeqNos.length; i++) {
				//	System.out.println("Warranties and Clauses Test :: "+printSeqNos[i]);
				//}
				
				Map<String, Object> parameters = new HashMap<String, Object>();
			/*	for(int i=0; i<wcTexts.length; i++) {
					System.out.println(wcTexts[i]);		
				}*/
				parameters.put("wcCds", wcCds);
				parameters.put("printSeqNos", printSeqNos);
				parameters.put("wcTitles", wcTitles);
				parameters.put("wcText1", wcText1);
				parameters.put("wcText2", wcText2);
				parameters.put("wcText3", wcText3);
				parameters.put("wcText4", wcText4);
				parameters.put("wcText5", wcText5);
				parameters.put("wcText6", wcText6);
				parameters.put("wcText7", wcText7);
				parameters.put("wcText8", wcText8);
				parameters.put("wcText9", wcText9);
				parameters.put("printSws", printSws);
				parameters.put("changeTags", changeTags);
				parameters.put("wcTitles2", wcTitles2);
				
				parameters.put("parId", parId);
				parameters.put("lineCd", lineCd);
				parameters.put("userId", USER.getUserId());
								
				gipiWcService.saveWPolWC(parameters);
				
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("deleteWPolWC".equals(ACTION)) {
				String wcCd = (request.getParameter("wcCd") == null) ? "" : request.getParameter("wcCd");
				gipiWcService.deleteWPolWC(lineCd, parId, wcCd);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("showWPolWarrAndClausePage".equals(ACTION)){
				GIPIWPolbasService polbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
				String policyNo = polbasService.getPolicyNoForEndt(parId);
				
				request.setAttribute("parType", parType);
				request.setAttribute("assdNo", assdNo);
				request.setAttribute("assdName", assdName);
				request.setAttribute("parNo", parNo);
				request.setAttribute("policyNo", policyNo);				
				
				List<GIPIWPolicyWarrantyAndClause> polWc = gipiWcService.getGIPIWPolicyWarrantyAndClauses(lineCd, parId);
				//StringFormatter.replaceQuotesInList(polWc);
				request.setAttribute("warrClauses", new JSONArray(polWc));
				
				PAGE = "/pages/underwriting/par/warrantyAndClauses/warrantyAndClauses.jsp";
				
			}else if("showWPolWarrAndClausePageTableGrid".equals(ACTION)){ // added by steven 4/26/2012
				GIPIWPolbasService polbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
				String policyNo = polbasService.getPolicyNoForEndt(parId);
				
				request.setAttribute("parType", parType);
				request.setAttribute("assdNo", assdNo);
				request.setAttribute("assdName", assdName);
				request.setAttribute("parNo", parNo);
				request.setAttribute("policyNo", policyNo);		
				request.setAttribute("userId", USER.getUserId());
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", lineCd);
				params.put("parId", parId);
				params.put("ACTION", "getWPolWCTableGrid");
				
				Map<String, Object> warrClauses = TableGridUtil.getTableGrid(request, params);
				JSONObject objWarrClauses = new JSONObject(warrClauses);
				JSONArray rows = objWarrClauses.getJSONArray("rows");
				for (int i = 0; i < rows.length(); i++) {
					rows.getJSONObject(i).put("tbgPrintSw", rows.getJSONObject(i).getString("printSw").equals("Y") ? true : false);
					rows.getJSONObject(i).put("tbgChangeTag", (rows.getJSONObject(i).getString("changeTag").equals("Y") ? true : false));
				}
				objWarrClauses.remove("rows");
				objWarrClauses.put("rows", rows);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("objWarrClauses", objWarrClauses);
					PAGE = "/pages/underwriting/par/warrantyAndClauses/warrantyAndClausesTableGrid.jsp";
				}else{
					message = objWarrClauses.toString();
					PAGE =  "/pages/genericMessage.jsp";
				}
			
			}else if("saveGIPIWPolWC".equals(ACTION)){
				JSONArray setRows = new JSONArray(request.getParameter("setRows"));
				JSONArray delRows = new JSONArray(request.getParameter("delRows"));
				gipiWcService.saveGIPIWPolWC(setRows, delRows);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("saveGIPIWPolWCTableGrid".equals(ACTION)) { //added by steven 4.30.2012
				JSONObject objParams = new JSONObject(request.getParameter("param"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("delParams", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("delPolWarrCla")), USER.getUserId(), GIPIWPolicyWarrantyAndClause.class));
				params.put("insParams", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setPolWarrCla")), USER.getUserId(), GIPIWPolicyWarrantyAndClause.class));
				params.put("userId", USER.getUserId());
				gipiWcService.saveGIPIWPolWCTableGrid(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("validatePrintSeqNo".equals(ACTION)) { //added by steven 4.30.2012
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId",request.getParameter("parId"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("printSeqNo", request.getParameter("printSeqNo"));
				
				message = gipiWcService.validatePrintSeqNo(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("checkExistingRecord".equals(ACTION)) { //added by steven 6.1.2012
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd",request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYY", request.getParameter("issueYY"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("wcCd", request.getParameter("wcCd"));
				params.put("swcSeqNo",request.getParameter("swcSeqNo"));
				
				message = gipiWcService.checkExistingRecord(params);
				PAGE = "/pages/genericMessage.jsp";
			}
			request.setAttribute("parId", request.getParameter("parId"));
		} catch (SQLException e) {
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
	
	/**
	 * Gets the warranties and clauses.
	 * 
	 * @param request the request
	 * @param gipiWcService the gipi wc service
	 * @param lineCd the line cd
	 * @param parId the par id
	 * @param pageNo the page no
	 * @return the warranties and clauses
	 * @throws SQLException the sQL exception
	 */
	private HttpServletRequest getWarrantiesAndClauses(HttpServletRequest request, 
			GIPIWPolicyWarrantyAndClauseFacadeService gipiWcService, String lineCd,
			int parId, int pageNo)	throws SQLException {
		List<GIPIWPolicyWarrantyAndClause> gipiWPolicyWCs = gipiWcService.getGIPIWPolicyWarrantyAndClauses(lineCd, parId);
		StringFormatter.replaceQuotesInList(gipiWPolicyWCs);
		/*
		for(GIPIWPolicyWarrantyAndClause gwc: gipiWPolicyWCs) {
			System.out.println("get Warranties and Clauses (wc_text_a) : " + gwc.getWcText1());
			System.out.println("get Warranties and Clauses (wc_text_b) : " + gwc.getWcText2());
		}
		*/
		request.setAttribute("gipiWPolicyWCs", gipiWPolicyWCs);
		return request;
	}
	
}
