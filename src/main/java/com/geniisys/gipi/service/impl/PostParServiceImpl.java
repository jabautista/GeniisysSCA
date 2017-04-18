package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gipi.dao.PostParDAO;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.exceptions.PostingParException;
import com.geniisys.gipi.pack.entity.GIPIPackPARList;
import com.geniisys.gipi.pack.entity.GIPIPackWPolBas;
import com.geniisys.gipi.pack.service.GIPIPackPARListService;
import com.geniisys.gipi.pack.service.GIPIPackWPolBasService;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.PostParService;
import com.seer.framework.util.StringFormatter;

public class PostParServiceImpl implements PostParService{
	
	private PostParDAO postParDAO;

	public void setPostParDAO(PostParDAO postParDAO) {
		this.postParDAO = postParDAO;
	}

	public PostParDAO getPostParDAO() {
		return postParDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.PostParService#postPar(java.util.Map)
	 */
	@Override
	public String postPar(Map<String, Object> params)
			throws SQLException, PostingParException, Exception {
		return this.postParDAO.postPar(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.PostParService#checkBackEndt(java.lang.Integer)
	 */
	@Override
	public Map<String, String> checkBackEndt(Integer parId) throws SQLException {
		return this.postParDAO.checkBackEndt(parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.PostParService#validateMC(javax.servlet.http.HttpServletRequest)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void validateMC(HttpServletRequest request) throws SQLException {
		Map<String, Object> sessionParameters = (Map<String, Object>) request.getSession().getAttribute("PARAMETERS");
		GIISUser USER = null;
		if (null != sessionParameters){
			USER = (GIISUser) sessionParameters.get("USER");
		}
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", request.getParameter("parId"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("userId",USER.getUserId());
		params = this.postParDAO.validateMC(params);
		request.setAttribute("object", new JSONObject((Map<String, Object>) StringFormatter.escapeHTMLInMap(params)));
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.PostParService#postFrps(java.util.Map)
	 */
	@Override
	public String postFrps(Map<String, Object> params) throws SQLException {
		return this.postParDAO.postFrps(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.PostParService#postpackPar(java.util.Map)
	 */
	@Override
	public String postpackPar(Map<String, Object> params) throws SQLException, Exception {
		return this.postParDAO.postpackPar(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.PostParService#checkBackEndtPack(java.lang.Integer)
	 */
	@Override
	public String checkBackEndtPack(Integer packParId) throws SQLException {
		return this.postParDAO.checkBackEndtPack(packParId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.PostParService#doPostPar(javax.servlet.http.HttpServletRequest, org.springframework.context.ApplicationContext)
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	public void doPostPar(HttpServletRequest request,
			ApplicationContext APPLICATION_CONTEXT) throws SQLException, JSONException {
		GIPIPARListService gipiParService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");//+env);
		GIPIPARList gipiParList = null;
		int parId = Integer.parseInt("".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId"));
		gipiParList = gipiParService.getGIPIPARDetails(parId);
		
		Map<String, Object> sessionParameters = (Map<String, Object>) request.getSession().getAttribute("PARAMETERS");
		GIISUser USER = null;
		if (null != sessionParameters){
			USER = (GIISUser) sessionParameters.get("USER");
		}
		
		Map isBackEndt = new HashMap();
		isBackEndt = this.checkBackEndt(parId);
		String backEndt = (String) isBackEndt.get("backEndt");
		String authenticateCOC = this.checkCOCAuthentication(parId, USER.getUserId());
		
		request.setAttribute("backEndt", backEndt);
		request.setAttribute("gipiParlist", gipiParList);
		request.setAttribute("cancellationMsg", this.getParCancellationMsg(request));
		request.setAttribute("authenticateCOC", authenticateCOC);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.PostParService#getParCancellationMsg(javax.servlet.http.HttpServletRequest)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public String getParCancellationMsg(HttpServletRequest request) throws SQLException,
			JSONException {
		int parId = Integer.parseInt("".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId"));
		return new JSONArray((List<Map<String, Object>>) StringFormatter.escapeHTMLInListOfMap(this.postParDAO.getParCancellationMsg(parId))).toString();
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.PostParService#doPostPackPar(javax.servlet.http.HttpServletRequest, org.springframework.context.ApplicationContext)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void doPostPackPar(HttpServletRequest request,
			ApplicationContext APPLICATION_CONTEXT) throws SQLException,
			JSONException {
		GIPIPARListService gipiParService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");//+env);
		GIPIPackPARListService gipiPackParService = (GIPIPackPARListService) APPLICATION_CONTEXT.getBean("gipiPackPARListService");//+env);
		GIPIPackWPolBasService gipiPackWPolBasService = (GIPIPackWPolBasService) APPLICATION_CONTEXT.getBean("gipiPackWPolBasService");
		
		int packParId = Integer.parseInt("".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId"));
		
		List<GIPIPARList> gipiParList = gipiParService.getPackPolicyList(packParId);
		GIPIPackPARList gipiPackParList = gipiPackParService.getGIPIPackParDetails(packParId);
		GIPIPackWPolBas gipiPackWPolBas = gipiPackWPolBasService.getGIPIPackWPolBas(packParId);
		if ("E".equals(gipiPackParList.getParType())){
			request.setAttribute("backEndt", this.checkBackEndtPack(packParId));
		}else{
			request.setAttribute("backEndt", "N");
		}
		request.setAttribute("gipiParlistJSON", new JSONArray((List<GIPIPARList>) StringFormatter.escapeHTMLInList(gipiParList)));
		request.setAttribute("gipiPackParList", gipiPackParList);
		request.setAttribute("gipiPackWPolBas", gipiPackWPolBas);
		request.setAttribute("cancellationMsg", new JSONArray((List<Map<String, Object>>) StringFormatter.escapeHTMLInListOfMap(this.postParDAO.getParCancellationMsg2(packParId))).toString());
		
		Map<String, Object> sessionParameters = (Map<String, Object>) request.getSession().getAttribute("PARAMETERS");
		GIISUser USER = null;
		if (null != sessionParameters){
			USER = (GIISUser) sessionParameters.get("USER");
		}
		request.setAttribute("authenticateCOC", this.checkPackCOCAuthentication(packParId, USER.getUserId()));

	} 
	
	@Override
	public String checkCOCAuthentication(Integer parId, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("userId", userId);
		return this.postParDAO.checkCOCAuthentication(params);
	}

	@Override
	public String checkPackCOCAuthentication(Integer packParId, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("packParId", packParId);
		params.put("userId", userId);
		return this.postParDAO.checkPackCOCAuthentication(params);
	} 
}
