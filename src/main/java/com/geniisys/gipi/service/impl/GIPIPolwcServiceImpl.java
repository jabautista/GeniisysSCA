package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONArray;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIPolwcDAO;
import com.geniisys.gipi.entity.GIPIPolwc;
import com.geniisys.gipi.service.GIPIPolwcService;
import com.seer.framework.util.StringFormatter;

public class GIPIPolwcServiceImpl implements GIPIPolwcService{
	
	private GIPIPolwcDAO gipiPolwcDAO;
	
	public GIPIPolwcDAO getGipiPolwcDAO() {
		return gipiPolwcDAO;
	}
	
	public void setGipiPolwcDAO(GIPIPolwcDAO gipiPolwcDAO) {
		this.gipiPolwcDAO = gipiPolwcDAO;
	}
	
	private static Logger log = Logger.getLogger(GIPIPolwcService.class);
	
	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getRelatedWcInfo(HashMap<String, Object> params) throws SQLException {
		
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIPIPolwc>	wcList = this.getGipiPolwcDAO().getRelatedWcInfo(params);
		for(GIPIPolwc gipiPolwc:wcList){
			gipiPolwc.setWcText(
					gipiPolwc.getWcText01()+
					gipiPolwc.getWcText02()+
					gipiPolwc.getWcText03()+
					gipiPolwc.getWcText04()+
					gipiPolwc.getWcText05()+
					gipiPolwc.getWcText06()+
					gipiPolwc.getWcText07()+
					gipiPolwc.getWcText08()+
					gipiPolwc.getWcText09()+
					gipiPolwc.getWcText10()+
					gipiPolwc.getWcText11()+
					gipiPolwc.getWcText12()+
					gipiPolwc.getWcText13()+
					gipiPolwc.getWcText14()+
					gipiPolwc.getWcText15()+
					gipiPolwc.getWcText16()+
					gipiPolwc.getWcText17());
		}
		params.put("rows", new JSONArray((List<GIPIPolwc>)StringFormatter.escapeHTMLInList(wcList)));
		grid.setNoOfPages(wcList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	@Override
	public String validateWarrCla(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "validateWarrCla");
		params.put("wcTitle", request.getParameter("wcTitle"));
		return this.gipiPolwcDAO.validateWarrCla(params);
	}
	
	public void saveGIPIPolWCTableGrid(HttpServletRequest request, String userId) throws Exception {
		log.info("Saving GIPIPolWC...");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setWarrCla", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIPIPolwc.class));
		params.put("delWarrCla", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIPIPolwc.class));
		this.getGipiPolwcDAO().saveGIPIPolWCTableGrid(params);
		log.info("GIPIPolWC Saved.");
	}
}
