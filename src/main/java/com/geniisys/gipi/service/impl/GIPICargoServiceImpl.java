package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.gipi.dao.GIPICargoDAO;
import com.geniisys.gipi.entity.GIPICargo;
import com.geniisys.gipi.service.GIPICargoService;
import com.seer.framework.util.StringFormatter;

public class GIPICargoServiceImpl implements GIPICargoService{
	
	private GIPICargoDAO gipiCargoDAO;

	public GIPICargoDAO getGipiCargoDAO() {
		return gipiCargoDAO;
	}

	public void setGipiCargoDAO(GIPICargoDAO gipiCargoDAO) {
		this.gipiCargoDAO = gipiCargoDAO;
	}

	@Override
	public void getCargoInfo(HashMap<String, Object> params,HttpServletRequest request)throws SQLException, JSONException {
		GIPICargo cargoItemInfo	= getGipiCargoDAO().getCargoInfo(params);
		if(cargoItemInfo != null){
			DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
			JSONObject jsonCargoItemInfo = new JSONObject(StringFormatter.escapeHTMLInObject(cargoItemInfo));
			if(cargoItemInfo.getEta() != null)					
				jsonCargoItemInfo.put("stringEta", df.format(cargoItemInfo.getEta()));
			//added by MarkS 5.11.2016 SR-22217
			if(cargoItemInfo.getEtd() != null)
				jsonCargoItemInfo.put("stringEtd", df.format(cargoItemInfo.getEtd()));
			//end SR-22217
			request.setAttribute("cargoItemInfo", jsonCargoItemInfo);
		}else{
			cargoItemInfo = new GIPICargo();
			request.setAttribute("cargoItemInfo", new JSONObject(cargoItemInfo));
		}
		 
	}
	
	
	
}
