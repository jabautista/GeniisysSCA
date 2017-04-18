package com.geniisys.gixx.service.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gixx.dao.GIXXVehicleDAO;
import com.geniisys.gixx.entity.GIXXVehicle;
import com.geniisys.gixx.service.GIXXVehicleService;

public class GIXXVehicleServiceImpl implements GIXXVehicleService{
	
	private GIXXVehicleDAO gixxVehicleDAO;

	public GIXXVehicleDAO getGixxVehicleDAO() {
		return gixxVehicleDAO;
	}

	public void setGixxVehicleDAO(GIXXVehicleDAO gixxVehicleDAO) {
		this.gixxVehicleDAO = gixxVehicleDAO;
	}

	/*@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getGIXXCargoCarrierTG(Map<String, Object> params) throws SQLException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIXXVehicle> cargoCarrierList = this.getGixxVehicleDAO().getGIXXCargoCarrierTG(params);
		params.put("rows", new JSONArray((List<GIXXVehicle>) StringFormatter.escapeHTMLInList(cargoCarrierList)));
		grid.setNoOfPages(cargoCarrierList);
		params.put("total", grid.getNoOfRows());
		params.put("pages", grid.getNoOfPages());
		
		return params;
	}*/

	@Override
	public GIXXVehicle getGIXXVehicleInfo(Map<String, Object> params) throws SQLException {
		return this.getGixxVehicleDAO().getGIXXVehicleInfo(params);
	}
	

}
