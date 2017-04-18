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
import com.geniisys.giac.dao.GIACOucsDAO;
import com.geniisys.giac.entity.GIACOucs;
import com.geniisys.giac.service.GIACOucsService;
import com.seer.framework.util.StringFormatter;

public class GIACOucsServiceImpl implements GIACOucsService {

	private GIACOucsDAO giacOucsDAO;
	
	public GIACOucsDAO getGiacOucsDAO() {
		return giacOucsDAO;
	}

	public void setGiacOucsDAO(GIACOucsDAO giacOucsDAO) {
		this.giacOucsDAO = giacOucsDAO;
	}
	
	@Override
	public JSONObject showGiacs305DepartmentList(HttpServletRequest request, String userId)
			throws SQLException, JSONException {		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs305DeptList");
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		
		Map<String, Object> giacDepartments = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(StringFormatter.escapeHTMLInMap(giacDepartments));
	}
	
	@Override
	public JSONObject showAllGiacs305(HttpServletRequest request, String userId)
			throws SQLException, JSONException {		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs305AllList");
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		
		Map<String, Object> giacDepartments = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(StringFormatter.escapeHTMLInMap(giacDepartments));
	}

	@Override
	public void saveGiacs305(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACOucs.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACOucs.class));
		params.put("appUser", userId);		
		this.giacOucsDAO.saveGiacs305(params);
	}

	@Override
	public void valDeleteOuc(HttpServletRequest request) throws SQLException {
		if(request.getParameter("oucId") != null){
			Integer oucId = Integer.parseInt(request.getParameter("oucId"));
			this.giacOucsDAO.valDeleteOuc(oucId);
		}
	}

	@Override
	public void valAddOuc(HttpServletRequest request) throws SQLException {
		if(request.getParameter("oucCd") != null){
			Integer oucCd = Integer.parseInt(request.getParameter("oucCd"));
			this.giacOucsDAO.valAddOuc(oucCd);
		}
	}

}
