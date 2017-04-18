/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.gipi.dao.GIPIWMcAccDAO;
import com.geniisys.gipi.entity.GIPIWMcAcc;
import com.geniisys.gipi.service.GIPIWMcAccService;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIWMcAccServiceImpl.
 */
public class GIPIWMcAccServiceImpl implements GIPIWMcAccService {

	/** The gipi w mc acc dao. */
	private GIPIWMcAccDAO gipiWMcAccDAO;

	/**
	 * Gets the gipi w mc acc dao.
	 * 
	 * @return the gipi w mc acc dao
	 */
	public GIPIWMcAccDAO getGipiWMcAccDAO() {
		return gipiWMcAccDAO;
	}
	
	/**
	 * Sets the gipi w mc acc dao.
	 * 
	 * @param gipiWMcAccDAO the new gipi w mc acc dao
	 */
	public void setGipiWMcAccDAO(GIPIWMcAccDAO gipiWMcAccDAO) {
		this.gipiWMcAccDAO = gipiWMcAccDAO;
	}


	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWMcAccService#getGipiWMcAcc(int, int)
	 */
	@Override
	public List<GIPIWMcAcc> getGipiWMcAcc(int parId,int itemNo) throws SQLException {
		return gipiWMcAccDAO.getGipiWMcAcc(parId,itemNo);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWMcAccService#saveGipiWMcAcc(java.util.Map)
	 */
	@Override
	public void saveGipiWMcAcc(Map<String, Object> params)
			throws SQLException {
		String[] accParIds = (String[]) params.get("accParIds");
		String[] accItemNos = (String[]) params.get("accItemNos");
		String[] accCds = (String[]) params.get("accCds");
		String[] accAmts = (String[]) params.get("accAmts");
		//Integer parId = (Integer) params.get("parId");
		//Integer itemNo = (Integer) params.get("itemNo");
		String userId = (String) params.get("userId");
		
		GIPIWMcAcc gipiWMcAcc = null;
		
		List<GIPIWMcAcc> accItems = new ArrayList<GIPIWMcAcc>();
		for (int i=0; i < accCds.length; i++){			
			gipiWMcAcc = new GIPIWMcAcc();
			
			gipiWMcAcc.setParId(Integer.parseInt(accParIds[i]));
			gipiWMcAcc.setItemNo(Integer.parseInt(accItemNos[i]));
			gipiWMcAcc.setUserId(userId);
			gipiWMcAcc.setAccessoryCd(accCds[i]);
			gipiWMcAcc.setAccAmt((accAmts[i] == null || accAmts[i] == "" ? null : new BigDecimal(accAmts[i].replaceAll(",", ""))));
			accItems.add(gipiWMcAcc);
			//this.gipiWMcAccDAO.saveGipiWMcAcc(gipiWMcAcc);
		}
		this.getGipiWMcAccDAO().saveGipiWMcAcc(accItems);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWMcAccService#deleteGipiWMcAcc(com.geniisys.gipi.entity.GIPIWMcAcc)
	 */
	@Override
	public void deleteGipiWMcAcc(GIPIWMcAcc gipiWMcAcc) throws SQLException {
		this.gipiWMcAccDAO.deleteGipiWMcAcc(gipiWMcAcc);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWMcAccService#getGipiWMcAccbyParId(int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWMcAcc> getGipiWMcAccbyParId(int parId) throws SQLException {		
		return (List<GIPIWMcAcc>) StringFormatter.escapeHTMLJavascriptInList(this.getGipiWMcAccDAO().getGipiWMcAccbyParId(parId));
	}
	@Override
	public void deleteGipiWMcAcc(Map<String, Object> params)
			throws SQLException {
		String[] delAccItemNos = (String[]) params.get("delAccItemNos");
		String[] delAccAccCds = (String[]) params.get("delAccAccCds");
		int parId = (Integer) params.get("parId");
		String userId = (String) params.get("userId");
		
		List<GIPIWMcAcc> accItems = new ArrayList<GIPIWMcAcc>();
		
		for(int i=0; i < delAccItemNos.length; i++){
			GIPIWMcAcc a = new GIPIWMcAcc();
			a.setParId(parId);
			a.setItemNo(Integer.parseInt(delAccItemNos[i]));
			a.setAccessoryCd(delAccAccCds[i]);
			a.setAccAmt(null);
			a.setUserId(userId);
			accItems.add(a);
		}
		this.getGipiWMcAccDAO().deleteGipiWMcAcc(accItems);		
	}

	@Override
	public List<Map<String, Object>> prepareGIPIWMcAccForDelete(
			JSONArray delRows) throws JSONException {
		List<Map<String, Object>> accessories = new ArrayList<Map<String, Object>>();
		Map<String, Object> acc = null;
		JSONObject objAcc = null;
		
		for(int i=0, length=delRows.length(); i < length; i++){
			acc = new HashMap<String, Object>();
			objAcc = delRows.getJSONObject(i);
			
			acc.put("parId", objAcc.isNull("parId") ? null : objAcc.getInt("parId"));
			acc.put("itemNo", objAcc.isNull("itemNo") ? null : objAcc.getInt("itemNo"));
			acc.put("accessoryCd", objAcc.isNull("accessoryCd") ? null : objAcc.getString("accessoryCd"));
			
			accessories.add(acc);
			acc = null;		
		}
		
		return accessories;
	}

	@Override
	public List<GIPIWMcAcc> prepareGIPIWMcAccForInsert(JSONArray setRows)
			throws JSONException {
		List<GIPIWMcAcc> accessories = new ArrayList<GIPIWMcAcc>();
		GIPIWMcAcc acc = null;
		JSONObject objAcc = null;
		
		for(int i=0, length=setRows.length(); i < length; i++){
			acc = new GIPIWMcAcc();
			objAcc = setRows.getJSONObject(i);
			
			acc.setParId(objAcc.isNull("parId") ? null : objAcc.getInt("parId"));
			acc.setItemNo(objAcc.isNull("itemNo") ? null : objAcc.getInt("itemNo"));
			acc.setAccessoryCd(objAcc.isNull("accessoryCd") ? null : objAcc.getString("accessoryCd"));
			acc.setAccAmt(objAcc.isNull("accAmt") ? null : new BigDecimal(objAcc.getString("accAmt")));
			acc.setUserId(objAcc.isNull("userId") ? null : objAcc.getString("userId"));
			
			accessories.add(acc);
			acc = null;			
		}
		
		return accessories;
	}
}
