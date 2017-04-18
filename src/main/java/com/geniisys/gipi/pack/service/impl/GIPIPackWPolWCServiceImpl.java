package com.geniisys.gipi.pack.service.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringEscapeUtils;
import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIWPolicyWarrantyAndClause;
import com.geniisys.gipi.pack.dao.GIPIPackWPolWCDAO;
import com.geniisys.gipi.pack.service.GIPIPackWPolWCService;

public class GIPIPackWPolWCServiceImpl implements GIPIPackWPolWCService{
	
	private GIPIPackWPolWCDAO gipiPackWPolWCDAO;

	public void setGipiPackWPolWCDAO(GIPIPackWPolWCDAO gipiPackWPolWCDAO) {
		this.gipiPackWPolWCDAO = gipiPackWPolWCDAO;
	}

	public GIPIPackWPolWCDAO getGipiPackWPolWCDAO() {
		return gipiPackWPolWCDAO;
	}

	@Override
	public void saveGIPIPackWPolWC(JSONArray setRows, JSONArray delRows) 
									throws SQLException, JSONException, Exception {
		System.out.println("Saving...");
		List<GIPIWPolicyWarrantyAndClause> setWCList = this.prepareWCListForInsert(setRows);
		List<GIPIWPolicyWarrantyAndClause> delWCList = this.prepareWCListForDelete(delRows);
		
		this.getGipiPackWPolWCDAO().saveGIPIPackWPolWC(setWCList, delWCList);
				
	}
	
	@Override
	public Map<String, Object> checkExistWPolwcPolWc(Map<String, Object> params)
			throws SQLException {
		return this.gipiPackWPolWCDAO.checkExistWPolwcPolWc(params);
	}
	
	private List<GIPIWPolicyWarrantyAndClause> prepareWCListForInsert(JSONArray setRows) throws JSONException{
		List<GIPIWPolicyWarrantyAndClause> setWCRowList = new ArrayList<GIPIWPolicyWarrantyAndClause>();
		GIPIWPolicyWarrantyAndClause wc;
		
		for(int index=0; index<setRows.length(); index++){
			wc = new GIPIWPolicyWarrantyAndClause();
			
			wc.setPackParId(setRows.getJSONObject(index).isNull("packParId") ? null : setRows.getJSONObject(index).getInt("packParId"));
			wc.setParId(setRows.getJSONObject(index).isNull("parId") ? null : setRows.getJSONObject(index).getInt("parId"));
			wc.setLineCd(setRows.getJSONObject(index).isNull("lineCd") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("lineCd")));
			wc.setWcCd(setRows.getJSONObject(index).isNull("wcCd") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcCd")));
			wc.setSwcSeqNo(setRows.getJSONObject(index).isNull("swcSeqNo") ? 0 : setRows.getJSONObject(index).getInt("swcSeqNo"));
			wc.setPrintSeqNo(setRows.getJSONObject(index).isNull("printSeqNo") ? null : setRows.getJSONObject(index).getInt("printSeqNo"));
			wc.setWcTitle(setRows.getJSONObject(index).isNull("wcTitle") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcTitle")));
			wc.setWcTitle2(setRows.getJSONObject(index).isNull("wcTitle2") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcTitle2")));
			wc.setRecFlag(setRows.getJSONObject(index).isNull("recFlag") ? null : setRows.getJSONObject(index).getString("recFlag"));
			wc.setWcRemarks(setRows.getJSONObject(index).isNull("wcRemarks") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcRemarks")));
			wc.setPrintSw(setRows.getJSONObject(index).isNull("printSw") ? null : setRows.getJSONObject(index).getString("printSw"));
			wc.setChangeTag(setRows.getJSONObject(index).isNull("changeTag") ? null : setRows.getJSONObject(index).getString("changeTag"));
			
			if((wc.getChangeTag()).equals("Y")){
				wc.setWcText1(setRows.getJSONObject(index).isNull("wcText1") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText1")));
				wc.setWcText2(setRows.getJSONObject(index).isNull("wcText2") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText2")));
				wc.setWcText3(setRows.getJSONObject(index).isNull("wcText3") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText3")));
				wc.setWcText4(setRows.getJSONObject(index).isNull("wcText4") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText4")));
				wc.setWcText5(setRows.getJSONObject(index).isNull("wcText5") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText5")));
				wc.setWcText6(setRows.getJSONObject(index).isNull("wcText6") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText6")));
				wc.setWcText7(setRows.getJSONObject(index).isNull("wcText7") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText7")));
				wc.setWcText8(setRows.getJSONObject(index).isNull("wcText8") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText8")));
				wc.setWcText9(setRows.getJSONObject(index).isNull("wcText9") ? null : StringEscapeUtils.unescapeHtml(setRows.getJSONObject(index).getString("wcText9")));
			}
			
			setWCRowList.add(wc);
		}
		return setWCRowList;
	}
	
	private List<GIPIWPolicyWarrantyAndClause> prepareWCListForDelete(JSONArray delRows) throws JSONException{
		List<GIPIWPolicyWarrantyAndClause> delWCRowList = new ArrayList<GIPIWPolicyWarrantyAndClause>();
		GIPIWPolicyWarrantyAndClause wc;
		for(int index=0; index<delRows.length(); index++){
			wc = new GIPIWPolicyWarrantyAndClause();
			
			wc.setPackParId(delRows.getJSONObject(index).isNull("packParId") ? null : delRows.getJSONObject(index).getInt("packParId"));
			wc.setParId(delRows.getJSONObject(index).isNull("parId") ? null : delRows.getJSONObject(index).getInt("parId"));
			wc.setLineCd(delRows.getJSONObject(index).isNull("lineCd") ? null : StringEscapeUtils.unescapeHtml(delRows.getJSONObject(index).getString("lineCd")));
			wc.setWcCd(delRows.getJSONObject(index).isNull("wcCd") ? null : StringEscapeUtils.unescapeHtml(delRows.getJSONObject(index).getString("wcCd")));
			
			delWCRowList.add(wc);
		}
		return delWCRowList;
	}

	@Override
	public boolean saveGIPIPackWPolWC2(Map<String, Object> parameters)
			throws Exception {
		System.out.println("Saving GIPIPackWPolWC...");
		this.getGipiPackWPolWCDAO().saveGIPIPackWPolWC2(parameters);
		return true;
	}

	/*@Override
	public void copyPackPolWCGiuts008a(Map<String, Object> params) throws SQLException {
		this.getGipiPackWPolWCDAO().copyPackPolWCGiuts008a(params);
	}*/
}
