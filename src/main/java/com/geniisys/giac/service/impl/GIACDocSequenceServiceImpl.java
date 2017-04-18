package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACDocSequenceDAO;
import com.geniisys.giac.entity.GIACDocSequence;
import com.geniisys.giac.service.GIACDocSequenceService;
import com.seer.framework.util.StringFormatter;

public class GIACDocSequenceServiceImpl implements GIACDocSequenceService {
	
	private GIACDocSequenceDAO giacDocSequenceDAO;
	
	@Override
	public JSONObject showGiacs322(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs322RecList");
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}

	@Override
	public String valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("repCd") != null){
			String repCd = request.getParameter("repCd");
			return this.giacDocSequenceDAO.valDeleteRec(repCd);
		} else {
			return null;
		}
		
	}

	@Override
	public void saveGiacs322(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACDocSequence.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACDocSequence.class));
		params.put("appUser", userId);
		this.giacDocSequenceDAO.saveGiacs322(params);
	}

	@Override
	public String valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("docName") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("docName", request.getParameter("docName"));
			params.put("fundCd", request.getParameter("fundCd"));
			params.put("branchCd", request.getParameter("branchCd"));
			return this.giacDocSequenceDAO.valAddRec(params);
		} else {
			return null;
		}
	}
	
	public GIACDocSequenceDAO getGiacDocSequenceDAO() {
		return giacDocSequenceDAO;
	}

	public void setGiacDocSequenceDAO(GIACDocSequenceDAO giacDocSequenceDAO) {
		this.giacDocSequenceDAO = giacDocSequenceDAO;
	}

}
