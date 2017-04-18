package com.geniisys.giac.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACCommSlipDAO;
import com.geniisys.giac.entity.GIACCommSlipExt;
import com.geniisys.giac.service.GIACCommSlipService;

public class GIACCommSlipServiceImpl implements GIACCommSlipService{
	
	public GIACCommSlipDAO giacCommSlipDAO;
	

	public GIACCommSlipDAO getGiacCommSlipDAO() {
		return giacCommSlipDAO;
	}

	public void setGiacCommSlipDAO(GIACCommSlipDAO giacCommSlipDAO) {
		this.giacCommSlipDAO = giacCommSlipDAO;
	}

	@Override
	public Map<String, Object> getCommSlip(Map<String, Object> params)
			throws SQLException {
		params = this.getGiacCommSlipDAO().extractCommSlip(params);
		
		Integer gaccTranId = (Integer) params.get("gaccTranId");
		List<GIACCommSlipExt> commSlip = this.getGiacCommSlipDAO().getCommSlip(gaccTranId);

		TableGridUtil grid = new TableGridUtil(1, commSlip.size());
		params.put("from", grid.getStartRow());
		params.put("to", grid.getStartRow());
		
		params.put("rows", commSlip);
		//grid.setNoOfPages(commSlip);
		System.out.println("getCommSlip Service<Test> : Size=" +commSlip.size()+" ");
		return params;
	}

	@Override
	public Map<String, Object> preparePrintParam(String param, String userId, int tranId, String vpdc)
			throws SQLException, JSONException {
		JSONArray setRows = param.isEmpty() ? null : new JSONArray(param);
		List<GIACCommSlipExt> commSlip = this.prepareCommSlipForPrint(setRows, tranId);
		Map<String, Object> params = new HashMap<String, Object>();
		String mesg = "";
		
		int vFlagCount = 0;
		int vSlipCount = 0;
		int vIntmCount = 0;
		String commSlipPref = "";
		String commSlipNo = "";
		int intmNo = 0;
		Date commSlipDate = new Date();
		String allowed = "N";
		
		System.out.println("Test params value: tran id - "+tranId+", userId - "+userId+", vpdc - "+vpdc);
		
		params.put("gaccTranId", tranId);
		params.put("userId", userId);
		params.put("vpdc", ((vpdc=="" || vpdc==null) ? "N" : vpdc));
		params.put("commSlipPref", commSlipPref);
		params.put("commSlipNo", commSlipNo);
		
		if(commSlip.size() > 0) {
			Set<String> flagSet = new HashSet<String>();
			Set<Integer> intmSet = new HashSet<Integer>();
			Set<String> slipSet = new HashSet<String>();
			for(GIACCommSlipExt cs: commSlip) {
				flagSet.add(cs.getCommSlipFlag());
				intmSet.add(cs.getIntmNo());
				String x = cs.getCommSlipPref() == null ? 
						(cs.getCommSlipNo() == null ? "X" : cs.getCommSlipNo().toString()) : cs.getCommSlipPref();
				slipSet.add(x);
			}
			vFlagCount = flagSet.size();
			vSlipCount = slipSet.size();
			vIntmCount = intmSet.size();
		}
		System.out.println("Test set size, vFlagCount: "+vFlagCount+", vSlipCount: "+
				vSlipCount+", vIntmCount: "+vIntmCount);
		
		if(vFlagCount > 1) {
			mesg = "Cannot combine unprinted records with printed records.";
			// update slip tag to N
			//params.put("commSlipPref", commSlipPref);
			//params.put("commSlipNo", commSlipNo);
			params.put("mesg", mesg);
		} else if(vSlipCount > 1) {
			mesg = "Cannot combine records with different comm slip numbers.";
			// update slip tag to N
			params.put("mesg", mesg);
		} else if(vIntmCount > 1) {
			mesg = "Cannot combine records with different intermediaries.";
			// update slip tag to N
			params.put("mesg", mesg);
		} else {
			String vFlag = "";
			int vTaggedCount = 0;
			int vActualCnt = 0;
			
			Set<String> flagSet = new HashSet<String>();
			Set<String> prefSet = new HashSet<String>();
						
			for(GIACCommSlipExt cs : commSlip) {
				flagSet.add((cs.getCommSlipFlag() == null ? "N" : cs.getCommSlipFlag()));
				prefSet.add(cs.getCommSlipPref());
				vFlag = cs.getCommSlipFlag();
				if(cs.getCommSlipTag().equals("Y")) {
					vTaggedCount++;	
				}
				if(vActualCnt == 0) {
					vActualCnt++;
				} else if(commSlipPref.equals(cs.getCommSlipPref()) && commSlipNo.equals(cs.getCommSlipNo())) { //edited by MarkS 7.29.2016 SR21987
					vActualCnt++;
				}
				commSlipPref = cs.getCommSlipPref();	//add to map
				commSlipNo = cs.getCommSlipNo() == null ? "" : cs.getCommSlipNo();
				intmNo = cs.getIntmNo() == null ? 0 : cs.getIntmNo();
				commSlipDate = cs.getCommSlipDate() == null ? new Date() : cs.getCommSlipDate();
			}
			if(flagSet.size() != 1) {
				vFlag = "";
			}
			System.out.println("V FLag value - "+flagSet.size()+", vActual - "+vActualCnt+", vTagged - "+vTaggedCount);
			if(vFlag.equals("P")) {
				if(prefSet.size() != 1) {
					commSlipPref = null;
					commSlipNo = null;
				} else {
					if(vTaggedCount != vActualCnt) {
						mesg = "Please select all records having the same comm slip number.";
						params.put("mesg", mesg);
					} else {
						params.put("commSlipPref", commSlipPref);
						params.put("commSlipNo", commSlipNo);
						params.put("mesg", mesg);
						allowed = "Y";
					}
				}
			} else {
				commSlipPref = null;
				commSlipNo = null;
				params = this.getGiacCommSlipDAO().getCommSlipPrintParams(params);
				allowed = "Y";
			}
		}
		
		if("Y".equals(allowed)) {
			this.getGiacCommSlipDAO().updateCommSlipTag(commSlip);
		}
		
		params.put("commSlipDate", commSlipDate);
		params.put("intmNo", intmNo);
		System.out.println("Prepare comm slip results : message - " +mesg+
				", pref - "+params.get("commSlipPref")+", no - "+params.get("commSlipNo"));
		return params;
	}	
	
	private List<GIACCommSlipExt> prepareCommSlipForPrint(JSONArray setRows, int tranId) 
		throws JSONException {
		List<GIACCommSlipExt> commSlip = new ArrayList<GIACCommSlipExt>();
		JSONObject objItem = null;
		GIACCommSlipExt cs = null;
		
		for(int i=0; i<setRows.length(); i++) {
			cs = new GIACCommSlipExt();
			objItem = setRows.getJSONObject(i);
			
			cs.setRecId(objItem.isNull("recId") ? null : objItem.getInt("recId"));
			cs.setGaccTranId(tranId);
			cs.setIssCd(objItem.isNull("issCd") ? null : objItem.getString("issCd"));
			cs.setPremSeqNo(objItem.isNull("premSeqNo") ? null : objItem.getInt("premSeqNo"));
			cs.setIntmNo(objItem.isNull("intmNo") ? null : objItem.getInt("intmNo"));
			cs.setCommAmt(objItem.isNull("commAmt") ? null : new BigDecimal(objItem.getString("commAmt")));
			cs.setWtaxAmt(objItem.isNull("wtaxAmt") ? null : new BigDecimal(objItem.getString("wtaxAmt")));
			cs.setInputVatAmt(objItem.isNull("inputVatAmt") ? null : new BigDecimal(objItem.getString("inputVatAmt")));
			cs.setCommSlipFlag(objItem.isNull("commSlipFlag") ? "N" : objItem.getString("commSlipFlag"));
			cs.setCommSlipPref(objItem.isNull("commSlipPref") ? "X" : objItem.getString("commSlipPref"));
			cs.setCommSlipNo(objItem.isNull("commSlipNo") ? null : objItem.getString("commSlipNo"));
			cs.setCommSlipTag(/*objItem.isNull("commSlipTag") ? "N" : objItem.getString("commSlipTag")*/ "Y");
			
			commSlip.add(cs);
		}
		return commSlip;
	}

	@Override
	public void confirmCommSlipPrinted(Map<String, Object> params)
			throws SQLException {
		this.getGiacCommSlipDAO().confirmCommSlipPrinted(params);
	}

	@Override
	public JSONObject getCommSlipJSON(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getCommSlipTG");
		params.put("gaccTranId", request.getParameter("gaccTranId"));
		params.put("userId", userId);
		
		Map<String, Object> comSlipJSON = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(comSlipJSON);
	}

}
