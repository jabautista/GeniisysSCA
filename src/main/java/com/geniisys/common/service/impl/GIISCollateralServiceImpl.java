package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISCollateralDAO;
import com.geniisys.common.entity.GIISCollateral;
import com.geniisys.common.entity.GIISCollateralType;
import com.geniisys.common.service.GIISCollateralService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.entity.GIPIItemVes;
import com.seer.framework.util.StringFormatter;

public class GIISCollateralServiceImpl implements GIISCollateralService{

	private GIISCollateralDAO giisCollateralDAO;
	
	
	public GIISCollateralDAO getGiisCollateralDAO() {
		return giisCollateralDAO;
	}


	public void setGiisCollateralDAO(GIISCollateralDAO giisCollateralDAO) {
		this.giisCollateralDAO = giisCollateralDAO;
	}


	//public void 
	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getCollateralList(HashMap<String, Object> params) throws SQLException {
		// TODO Auto-generated method stub
		//System.out.println(parId);
		/*HashMap<String, Object> collTran = new HashMap<String, Object>();
		List<GIISCollateral> list = getGiisCollateralDAO().getCollateralList(parId);	
		for(GIISCollateral giisColl:list){	
			collTran.put("collType", giisColl.collType);
			collTran.put("collDesc", giisColl.collDesc);
			collTran.put("collVal", giisColl.collVal);
			collTran.put("dateSubmitted", giisColl.lastUpdate);
		};
		System.out.println("serviceimpl1.3 = " + list.size());
		collTran.put("rows", new JSONArray((List<GIPIQuote>)StringFormatter.escapeHTMLInList(list)));  
		return collTran;*/
		
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),ApplicationWideParameters.PAGE_SIZE);//
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIISCollateral> collateralList = this.getGiisCollateralDAO().getCollateralList(params);
		params.put("rows", new JSONArray((List<GIPIItemVes>)StringFormatter.escapeHTMLInList(collateralList)));
		grid.setNoOfPages(collateralList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}


	@Override
	public List<GIISCollateralType> getCollType() throws SQLException {
		// TODO Auto-generated method stub
		return this.getGiisCollateralDAO().getCollType();
	}


	@Override
	public void addCollateralPar(String parameter, Integer parId) throws SQLException, JSONException {
		// TODO Auto-generated method stub
		System.out.println("service Impl here  ***");
		
		JSONObject added= new JSONObject(parameter); 
		JSONArray jsonA = new JSONArray(added.getString("setRows"));
		System.out.println("here hjdj");
		System.out.println(jsonA.length()+"json length");
		if (jsonA.length() != 0){
			System.out.println(jsonA.length()+"json length");
			for (int i = 0; i<jsonA.length(); i++){
				System.out.println("here 789");
				Integer collId = jsonA.getJSONObject(i).getInt("collId");
				Integer collVal = jsonA.getJSONObject(i).getInt("collVal");
				String  recDate = (jsonA.getJSONObject(i).getString("revDate"));
				System.out.println(collId);
				System.out.println(parId);
				System.out.println(collVal);
				System.out.println(recDate);
				getGiisCollateralDAO().addCollateralPar(parId, collId, collVal, recDate);	
			}
			
		};
		
	}


	@Override
	public void delCollateralPar(String parameter, Integer parId)throws SQLException, JSONException {
		// TODO Auto-generated method stub
		System.out.println("delete collateral");
		JSONObject deleteRowObj= new JSONObject(parameter); 
		JSONArray jsonA = new JSONArray(deleteRowObj.getString("delRows"));
		System.out.println(jsonA.length()+"json length");
		if (jsonA.length() != 0){
			System.out.println(jsonA.length()+"json length");
			for (int i = 0; i<jsonA.length(); i++){
				Integer collId = jsonA.getJSONObject(i).getInt("collId");
				Integer collVal = jsonA.getJSONObject(i).getInt("collVal");
				String  recDate = (jsonA.getJSONObject(i).getString("revDate"));
				System.out.println(collId);
				System.out.println(parId);
				System.out.println(collVal);
				System.out.println(recDate+"rec date");
				getGiisCollateralDAO().delCollateralPar(parId, collId, collVal, recDate);	
			}
		}
	}



}
