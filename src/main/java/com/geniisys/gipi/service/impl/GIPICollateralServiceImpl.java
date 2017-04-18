package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISCollateralType;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPICollateralDAO;
import com.geniisys.gipi.entity.GIPICollateral;
import com.geniisys.gipi.entity.GIPIItemVes;
import com.geniisys.gipi.service.GIPICollateralService;
import com.seer.framework.util.StringFormatter;

public class GIPICollateralServiceImpl implements GIPICollateralService{

	private GIPICollateralDAO gipiCollateralDAO;
	
	
	public GIPICollateralDAO getGipiCollateralDAO() {
		return gipiCollateralDAO;
	}


	public void setGipiCollateralDAO(GIPICollateralDAO gipiCollateralDAO) {
		this.gipiCollateralDAO = gipiCollateralDAO;
	}


	//public void 
	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getCollateralList(HashMap<String, Object> params) throws SQLException {
		// TODO Auto-generated method stub
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),ApplicationWideParameters.PAGE_SIZE);//
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIPICollateral> collateralList = this.getGipiCollateralDAO().getCollateralList(params);
		params.put("rows", new JSONArray((List<GIPIItemVes>)StringFormatter.escapeHTMLInList(collateralList)));
		grid.setNoOfPages(collateralList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}


	@Override
	public List<GIISCollateralType> getCollType() throws SQLException {
		// TODO Auto-generated method stub
		return this.getGipiCollateralDAO().getCollType();
	}


	@Override
	public void addCollateralPar(String parameter, Integer parId) throws SQLException, JSONException {
		// TODO Auto-generated method stub
		System.out.println("service Impl here  ***");
		JSONObject added= new JSONObject(parameter); 
		JSONArray jsonA = new JSONArray(added.getString("setRows"));
		if (jsonA.length() != 0){
			for (int i = 0; i<jsonA.length(); i++){
				System.out.println("here 789");
				Integer collId = jsonA.getJSONObject(i).getInt("collId");
				String collVal = jsonA.getJSONObject(i).getString("collVal");
				String  recDate = (jsonA.getJSONObject(i).getString("revDate"));
				getGipiCollateralDAO().addCollateralPar(parId, collId, collVal, recDate);	
			}			
		};		
	}


	@Override
	public void delCollateralPar(String parameter, Integer parId)throws SQLException, JSONException {
		// TODO Auto-generated method stub
		System.out.println("delete collateral");
		JSONObject deleteRowObj= new JSONObject(parameter); 
		JSONArray jsonA = new JSONArray(deleteRowObj.getString("delRows"));
		if (jsonA.length() != 0){
			for (int i = 0; i<jsonA.length(); i++){
				Integer collId = jsonA.getJSONObject(i).getInt("collId");
				//Integer collVal = jsonA.getJSONObject(i).getInt("collVal");
				String collVal = jsonA.getJSONObject(i).getString("collVal");
				String  recDate = (jsonA.getJSONObject(i).getString("revDate"));
				getGipiCollateralDAO().delCollateralPar(parId, collId, collVal, recDate);	
			}
		}
	}


	@Override
	public void updateCollateralPar(String parameter, Integer parId)
			throws SQLException, JSONException {
		// TODO Auto-generated method stub
		JSONObject update= new JSONObject(parameter); 
		JSONArray jsonA = new JSONArray(update.getString("setModifiedRows"));
		JSONArray jsonB = new JSONArray(update.getString("setParamUpdate"));
		Integer parId2= parId;
		if (jsonA.length() != 0){
			for (int i = 0; i<jsonA.length(); i++){
				Integer collId = jsonA.getJSONObject(i).getInt("collId");
				String collVal = jsonA.getJSONObject(i).getString("collVal");
				String  recDate = (jsonA.getJSONObject(i).getString("revDate"));
				Integer collId2 = jsonB.getJSONObject(i).getInt("collId");
				String collVal2 = jsonB.getJSONObject(i).getString("collVal");
				String  recDate2 = (jsonB.getJSONObject(i).getString("revDate"));
				getGipiCollateralDAO().updateCollateralPar(parId, collId, collVal, recDate,
														parId2, collId2, collVal2, recDate2);	
			}	
		};
	}
}