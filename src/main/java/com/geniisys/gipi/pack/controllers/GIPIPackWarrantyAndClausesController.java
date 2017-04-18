package com.geniisys.gipi.pack.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.entity.GIPIWPolicyWarrantyAndClause;
import com.geniisys.gipi.pack.entity.GIPIPackWarrantyAndClauses;
import com.geniisys.gipi.pack.service.GIPIPackWPolWCService;
import com.geniisys.gipi.service.GIPIWPolicyWarrantyAndClauseFacadeService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPIPackWarrantyAndClausesController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIPIPackWarrantyAndClausesController.class);
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIPIWPolicyWarrantyAndClauseFacadeService gipiWcService = (GIPIWPolicyWarrantyAndClauseFacadeService) APPLICATION_CONTEXT.getBean("gipiWPolicyWarrantyAndClauseFacadeService");
			GIPIPackWPolWCService gipiPackWPolWCService = (GIPIPackWPolWCService) APPLICATION_CONTEXT.getBean("gipiPackWPolWCService");
			
			String parType  = (request.getParameter("globalParType")== null ? "" : request.getParameter("globalParType"));
			Integer packParId = Integer.parseInt(request.getParameter("globalPackParId")== null ? "0" : request.getParameter("globalPackParId"));
			int assdNo 		= Integer.parseInt((request.getParameter("globalAssdNo")== null ? "0" : request.getParameter("globalAssdNo")));
			String assdName	= (request.getParameter("globalAssdName")== null ? "" : request.getParameter("globalAssdName"));
			String parNo	= (request.getParameter("globalParNo")== null ? "" : request.getParameter("globalParNo"));
			
			if("showPackClause".equals(ACTION)){
				request.setAttribute("packParType", parType);
				request.setAttribute("assdNo", assdNo);
				request.setAttribute("assdName", assdName);
				request.setAttribute("parNo", parNo);
				List<GIPIPackWarrantyAndClauses> packWC = gipiWcService.getPolicyListWC(packParId);
				List<GIPIWPolicyWarrantyAndClause> polWc = getListOfWarrantyAndClause(packWC);
				StringFormatter.replaceQuotesInList(polWc);
				request.setAttribute("warranty", new JSONArray(polWc));
				request.setAttribute("pol", packWC);
				request.setAttribute("isPack", "Y");
				request.setAttribute("pageName", "warrAndClause");
				PAGE = "/pages/underwriting/packPar/packWarrantyAndClauses/packWarrantyAndClauses.jsp";
				
			}else if("showPackWarrClaTableGrid".equals(ACTION)){ //added by steven 6.4.2012
				request.setAttribute("packParType", parType);
				request.setAttribute("assdNo", assdNo);
				request.setAttribute("assdName", assdName);
				request.setAttribute("parNo", parNo);
				request.setAttribute("isPack", "Y");
				request.setAttribute("pageName", "warrAndClause");
				
				List<GIPIPackWarrantyAndClauses> packWC = gipiWcService.getPolicyListWC(packParId);	
				JSONObject objPolWc = new JSONObject();
				request.setAttribute("objPolWc", objPolWc);
				request.setAttribute("pol", packWC);
				PAGE = "/pages/underwriting/packPar/packWarrantyAndClauses/packWarrantyAndClausesTableGrid.jsp";
			}else if("showWarrClaTableGrid".equals(ACTION)){ // added by steven 6/5/2012
				String lineCd 		= (request.getParameter("globalLineCd").equals(null) ? "" : request.getParameter("globalLineCd"));
				int parId 			= Integer.parseInt((request.getParameter("globalParId").equals(null)) ? "0" : request.getParameter("globalParId"));
				
				request.setAttribute("parType", parType);
				request.setAttribute("assdNo", assdNo);
				request.setAttribute("assdName", assdName);
				request.setAttribute("parNo", parNo);
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", lineCd);
				params.put("parId", parId);
				params.put("ACTION", "getWPolWCTableGrid");
				
				Map<String, Object> warrClauses = TableGridUtil.getTableGrid(request, params);
				JSONObject objPolWc = new JSONObject(warrClauses);
				JSONArray rows = objPolWc.getJSONArray("rows");
				for (int i = 0; i < rows.length(); i++) {
					rows.getJSONObject(i).put("tbgPrintSw", rows.getJSONObject(i).getString("printSw").equals("Y") ? true : false);
					rows.getJSONObject(i).put("tbgChangeTag", (rows.getJSONObject(i).getString("changeTag").equals("Y") ? true : false));
				}
				objPolWc.remove("rows");
				objPolWc.put("rows", rows);
				message = objPolWc.toString();
				PAGE =  "/pages/genericMessage.jsp";
				
			}else if("getWarrantyListing".equals(ACTION)){
				String lineCd = request.getParameter("lineCd");
				String[] args = {lineCd}; 
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); 
				List<LOV> wcTitles = lovHelper.getList(LOVHelper.WARRANTY_LISTING, args);
				StringFormatter.replaceQuotesInList(wcTitles);
				JSONArray wcList = new JSONArray(wcTitles);
				message = wcList.toString();
				PAGE = "/pages/genericMessage.jsp";
			
			}else if("savePackWPolWC".equals(ACTION)){
				JSONArray setRows = new JSONArray(request.getParameter("setRows"));
				JSONArray delRows = new JSONArray(request.getParameter("delRows"));
				gipiPackWPolWCService.saveGIPIPackWPolWC(setRows, delRows);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			
			}else if ("saveGIPIWPolWCTableGrid".equals(ACTION)) { //added by steven 6.5.2012
				JSONObject objParams = new JSONObject(request.getParameter("param"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("delParams", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("delPolWarrCla")), USER.getUserId(), GIPIWPolicyWarrantyAndClause.class));
				params.put("insParams", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setPolWarrCla")), USER.getUserId(), GIPIWPolicyWarrantyAndClause.class));
				gipiPackWPolWCService.saveGIPIPackWPolWC2(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				
			}else if("checkExistWPolwcPolwc".equals(ACTION)){
				Map<String, Object> params = this.prepareExistWPolwcPolwcMap(request);
				JSONObject obj = new JSONObject(gipiPackWPolWCService.checkExistWPolwcPolWc(params));
				message = obj.toString();
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
			message = "SQL Exception occured...<br/>" + e.getCause();
			PAGE = "/pages/genericMessage.jsp";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} catch (JSONException e) {
			message = "JSON Exception occured...<br/>" + e.getCause();
			PAGE = "/pages/genericMessage.jsp";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		} catch (Exception e) {
			message = "Unhandled Exception occured...<br/>" + e.getCause();
			PAGE = "/pages/genericMessage.jsp";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
	
	private List<GIPIWPolicyWarrantyAndClause> getListOfWarrantyAndClause(List<GIPIPackWarrantyAndClauses> list){
		List<GIPIWPolicyWarrantyAndClause> gipiWCs = new ArrayList<GIPIWPolicyWarrantyAndClause>();
		
		for(GIPIPackWarrantyAndClauses wc : list){
			List<GIPIWPolicyWarrantyAndClause> polWCs = new ArrayList<GIPIWPolicyWarrantyAndClause>();
			polWCs = wc.getGipiWarrantyAndClauses();
			
			for(GIPIWPolicyWarrantyAndClause gipiWc : polWCs){
				GIPIWPolicyWarrantyAndClause gWC = gipiWc;
				gipiWCs.add(gWC);
			}
		}
		return gipiWCs;
	}
	
	private Map<String, Object> prepareExistWPolwcPolwcMap(HttpServletRequest request){
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy")== null || request.getParameter("issueYy").equals("") 
							  ? 0 : Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", request.getParameter("polSeqNo")== null || request.getParameter("polSeqNo").equals("") 
				  			  ? 0 : Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("wcCd", request.getParameter("wcCd"));
		params.put("swcSeqNo", request.getParameter("swcSeqNo")== null || request.getParameter("swcSeqNo").equals("") 
				  			  ? 0 : Integer.parseInt(request.getParameter("swcSeqNo")));
		params.put("recFlag", "");
		params.put("exist", "");
		
		return params;
	}

}
