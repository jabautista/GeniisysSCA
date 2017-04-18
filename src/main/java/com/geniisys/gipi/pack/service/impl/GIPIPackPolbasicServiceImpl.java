package com.geniisys.gipi.pack.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.pack.dao.GIPIPackPolbasicDAO;
import com.geniisys.gipi.pack.entity.GIPIPackPolbasic;
import com.geniisys.gipi.pack.service.GIPIPackPolbasicService;
import com.seer.framework.util.StringFormatter;

public class GIPIPackPolbasicServiceImpl implements GIPIPackPolbasicService {
	
	/** The GIPI Pack Polbasic DAO */
	private GIPIPackPolbasicDAO gipiPackPolbasicDAO;
	
	/** The logger */
	private static Logger log = Logger.getLogger(GIPIPackPolbasicServiceImpl.class);

	public void setGipiPackPolbasicDAO(GIPIPackPolbasicDAO gipiPackPolbasicDAO) {
		this.gipiPackPolbasicDAO = gipiPackPolbasicDAO;
	}

	public GIPIPackPolbasicDAO getGipiPackPolbasicDAO() {
		return gipiPackPolbasicDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.pack.service.GIPIPackPolbasicService#getPolicyForPackEndt(java.util.Map, int)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getPolicyForPackEndt(Map<String, Object> params,
			int pageNo) throws SQLException {
		List<GIPIPackPolbasic> packPolbasicList = this.getGipiPackPolbasicDAO().getPolicyForPackEndt(params);
		log.info("LOV Size: " + packPolbasicList.size());
		PaginatedList result = new PaginatedList(packPolbasicList, ApplicationWideParameters.PAGE_SIZE);
		result.gotoPage(pageNo);
		return result;
	}
	
	@Override
	public void getPackageBinders(HttpServletRequest request, GIISUser USER) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("endtSeqNo", request.getParameter("endtSeqNo"));
		params.put("endtIssCd", request.getParameter("endtIssCd"));
		params.put("endtYy", request.getParameter("endtYy"));
		params.put("from", "0");
		params.put("to", "1");
		GIPIPackPolbasic packBinder = this.gipiPackPolbasicDAO.getPackageBinders(params);
		if(packBinder == null){// Nica 05.21.2012 - added this condition to handle null value
			request.setAttribute("packBinder", new JSONObject());
		}else{
			request.setAttribute("packBinder", new JSONObject((GIPIPackPolbasic) StringFormatter.escapeHTMLInObject(packBinder)).toString());
		}
	}

	@Override
	public List<GIPIPackPolbasic> checkPackPolicyGiexs006(
			Map<String, Object> params) throws SQLException {
		return gipiPackPolbasicDAO.checkPackPolicyGiexs006(params);
	}

	@Override
	public Map<String, Object> copyPackPolbasicGiuts008a(Map<String, Object> params) throws SQLException {
		return this.getGipiPackPolbasicDAO().copyPackPolbasicGiuts008a(params);
	}

	@Override
	public String checkIfPackGIACS007(Map<String, Object> params)
			throws SQLException {
		return this.getGipiPackPolbasicDAO().checkIfPackGIACS007(params);
	} 

	@Override
	public String checkIfBillsSettledGIACS007(Map<String, Object> params)
			throws SQLException {
		return this.getGipiPackPolbasicDAO().checkIfBillsSettledGIACS007(params);
	}

	@Override
	public String checkIfWithMc(Integer packParId) throws SQLException {
		return this.getGipiPackPolbasicDAO().checkIfWithMc(packParId);
	}

	@Override
	public JSONObject showReinstateHistory(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "showPackageReinstateHistory");
		params.put("packPolicyId", Integer.parseInt(request.getParameter("packPolicyId")));
		Map<String, Object> giuts028AReinstateHistTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonReinstatementHistory = new JSONObject(giuts028AReinstateHistTableGrid);
		return jsonReinstatementHistory;
	}
	
}
