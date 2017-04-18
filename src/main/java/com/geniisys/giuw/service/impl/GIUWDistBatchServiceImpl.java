package com.geniisys.giuw.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.giuw.dao.GIUWDistBatchDAO;
import com.geniisys.giuw.entity.GIUWDistBatch;
import com.geniisys.giuw.entity.GIUWDistBatchDtl;
import com.geniisys.giuw.entity.GIUWPolDist;
import com.geniisys.giuw.entity.GIUWPolDistPolbasicV;
import com.geniisys.giuw.entity.GIUWWpolicyds;
import com.geniisys.giuw.entity.GIUWWpolicydsDtl;
import com.geniisys.giuw.service.GIUWDistBatchService;
import com.seer.framework.util.StringFormatter;

public class GIUWDistBatchServiceImpl implements GIUWDistBatchService{
	
	private GIUWDistBatchDAO giuwDistBatchDAO;
	
	public void setGiuwDistBatchDAO(GIUWDistBatchDAO giuwDistBatchDAO) {
		this.giuwDistBatchDAO = giuwDistBatchDAO;
	}


	public GIUWDistBatchDAO getGiuwDistBatchDAO() {
		return giuwDistBatchDAO;
	}


	@Override
	public GIUWDistBatch getGIUWDistBatch(Map<String, Object> params)
			throws SQLException {
		return this.getGiuwDistBatchDAO().getGIUWDistBatch(params);
	}
	
	@Override
	public String saveBatchDistribution(String parameters, GIISUser USER)
			throws SQLException, JSONException, Exception {
		JSONObject objParams = new JSONObject(parameters);
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("giuwPolDistPolbasicV", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setRows")), USER.getUserId(), GIUWPolDistPolbasicV.class));
		params.put("userId", USER.getUserId());
		String message = this.getGiuwDistBatchDAO().saveBatchDistribution(params);
		return message;
	}


	@Override
	public void saveBatchDistributionShare(String parameters, GIISUser USER, Integer batchId)
			throws Exception {
		JSONObject objParams = new JSONObject(parameters);
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setDistBatchDtl", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setDistBatchDtl")), USER.getUserId(), GIUWDistBatchDtl.class));
		params.put("delDistBatchDtl", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("delDistBatchDtl")), USER.getUserId(), GIUWDistBatchDtl.class));
		params.put("batchId", batchId);	// shan 08.11.2014
		this.getGiuwDistBatchDAO().saveBatchDistributionShare(params);
	}

	public List<GIUWPolDistPolbasicV> getPoliciesByBatchId(HttpServletRequest request, String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("batchId", Integer.parseInt(request.getParameter("batchId")));
		params.put("userId", userId);
		
		return this.giuwDistBatchDAO.getPoliciesByBatchId(params);
	}
	
	public JSONObject updatePolicyDistShare(List<GIUWPolDist> polDistList, String params) throws SQLException, JSONException, ParseException{
		JSONArray distBatchShareArray = new JSONArray(new JSONObject(params).getString("giuwDistBatchDtlList"));
		System.out.println("pol dist count: " + polDistList.size() +"\n dist batch: " +distBatchShareArray.toString());
		
		JSONObject objDistBatch = null;
		Iterator<GIUWPolDist> polDistIter = polDistList.iterator();
		JSONObject objPolDist = new JSONObject();
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy" /*"EEE MMM dd HH:mm:ss zzz yyyy"*/);
		JSONObject objPol = null;		
		JSONArray giuwPolDistArray = new JSONArray();
		List<GIUWWpolicyds> giuwWpolicydsObj =  null;
		List<GIUWWpolicydsDtl> setGiuwWpolicydsDtlList = null;
		List<GIUWWpolicydsDtl> delGiuwWpolicydsDtlList = null;
		
		while(polDistIter.hasNext()){
			// Policy
			GIUWPolDist policy = polDistIter.next();
			
			objPol = new JSONObject(policy);			
			objPol.put("effDate", policy.getEffDate() == null ? null : df.format(policy.getEffDate()).toString());
			objPol.put("expiryDate", policy.getExpiryDate() == null ? null : df.format(policy.getExpiryDate()).toString());
			objPol.put("createDate", policy.getCreateDate() == null ? null : df.format(policy.getCreateDate()).toString());
			objPol.put("negateDate", policy.getNegateDate() == null ? null : df.format(policy.getNegateDate()).toString());
			objPol.put("acctEntDate", policy.getAcctEntDate() == null ? null : df.format(policy.getAcctEntDate()).toString());
			objPol.put("acctNegDate", policy.getAcctNegDate() == null ? null : df.format(policy.getAcctNegDate()).toString());
			objPol.put("lastUpdate", policy.getLastUpdate() == null ? null : df.format(policy.getLastUpdate()).toString());
			objPol.put("lastUpdDate", policy.getLastUpdDate() == null ? null : df.format(policy.getLastUpdDate()).toString());
			objPol.put("postDate", policy.getPostDate() == null ? null : df.format(policy.getPostDate()).toString());			
			objPol.put("distNo", policy.getDistNo());
			objPol.put("parId" , policy.getParId());
			objPol.put("distFlag",	"1");
			objPol.put("redistFlag", policy.getRedistFlag());
			objPol.put("postFlag", policy.getPostFlag());
			objPol.put("policyId", policy.getPolicyId());
			objPol.put("endtType", policy.getEndtType());
			objPol.put("tsiAmt", policy.getTsiAmt());
			objPol.put("premAmt", policy.getPremAmt());
			objPol.put("annTsiAmt", policy.getAnnTsiAmt());
			objPol.put("distType", policy.getDistType());
			objPol.put("itemPostedSw", policy.getItemPostedSw());
			objPol.put("exLossSw", policy.getExLossSw());
			objPol.put("batchId", policy.getBatchId());
			objPol.put("cpiRecNo", policy.getCpiRecNo());
			objPol.put("cpiBranchCd", policy.getCpiBranchCd());
			objPol.put("autoDist", policy.getAutoDist());
			objPol.put("oldDistNo", policy.getOldDistNo());
			objPol.put("takeupSeqNo", policy.getTakeupSeqNo());
			objPol.put("itemGrp", policy.getItemGrp());
			objPol.put("arcExtData", policy.getArcExtData());
			objPol.put("multiBookingMm", policy.getMultiBookingMm());
			objPol.put("multiBookingYy", policy.getMultiBookingYy());
			objPol.put("meanDistFlag", policy.getMeanDistFlag());
			objPol.put("varShare", policy.getVarShare());
			objPol.put("distPostFlag", policy.getDistPostFlag());
			objPol.put("userId", policy.getUserId());
			objPol.put("appUser", policy.getAppUser());
			
			giuwPolDistArray.put(objPol);
			
			// for Group
			giuwWpolicydsObj = new ArrayList<GIUWWpolicyds>();
			List<GIUWWpolicyds> giuwWpolicydsList = policy.getGiuwWpolicyds();
			Iterator <GIUWWpolicyds> policydsIter = giuwWpolicydsList.iterator();
			setGiuwWpolicydsDtlList = new ArrayList<GIUWWpolicydsDtl>();
			delGiuwWpolicydsDtlList = new ArrayList<GIUWWpolicydsDtl>();
			
			while(policydsIter.hasNext()){
				GIUWWpolicyds wpolicyDs = policydsIter.next();
				giuwWpolicydsObj.add(wpolicyDs);
				
				// for Share								
				for (int i=0; i < distBatchShareArray.length(); i++ ){
					objDistBatch = distBatchShareArray.getJSONObject(i);
					BigDecimal share = new BigDecimal(objDistBatch.getString("distSpct")).divide(new BigDecimal(100), 9, RoundingMode.HALF_UP);
					BigDecimal distTsi = share.multiply(wpolicyDs.getTsiAmt());
					BigDecimal distPrem = share.multiply(wpolicyDs.getPremAmt());
					BigDecimal annDistTsi = share.multiply(wpolicyDs.getAnnTsiAmt());
				
					GIUWWpolicydsDtl dtl = new GIUWWpolicydsDtl();
					dtl.setDistNo(wpolicyDs.getDistNo());
					dtl.setDistSeqNo(wpolicyDs.getDistSeqNo());
					dtl.setLineCd(wpolicyDs.getNbtLineCd());
					dtl.setShareCd(objDistBatch.getInt("shareCd"));
					dtl.setDistSpct(objDistBatch.getString("distSpct"));
					dtl.setDistTsi(distTsi);
					dtl.setDistSpct1(null);
					dtl.setDistPrem(distPrem);
					dtl.setAnnDistSpct(objDistBatch.getString("distSpct"));
					dtl.setAnnDistTsi(annDistTsi);
					dtl.setDistGrp(1);
					setGiuwWpolicydsDtlList.add(dtl);
				}
				
				List<GIUWWpolicydsDtl> giuwWpolicydsDtlList = wpolicyDs.getGiuwWpolicydsDtl();
				Iterator <GIUWWpolicydsDtl> policydsDtlIter = giuwWpolicydsDtlList.iterator();
				while(policydsDtlIter.hasNext()){
					GIUWWpolicydsDtl wpolicydsDtl = policydsDtlIter.next();
					delGiuwWpolicydsDtlList.add(wpolicydsDtl);							
				}
			}
		}
		
		objPolDist.put("giuwPolDistRows", giuwPolDistArray);
		objPolDist.put("giuwPolDistPostedRecreated", new JSONArray());
		objPolDist.put("giuwWpolicydsRows", giuwWpolicydsObj);
		objPolDist.put("giuwWpolicydsDtlSetRows", setGiuwWpolicydsDtlList);
		objPolDist.put("giuwWpolicydsDtlDelRows", delGiuwWpolicydsDtlList);
		
		return objPolDist;
	}


	@SuppressWarnings("unchecked")
	@Override
	public JSONArray getPoliciesByParam(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		if ((String) request.getParameter("filter") != null ){
			params.putAll((HashMap<String, Object>) JSONUtil.prepareMapFromJSON(new JSONObject(request.getParameter("filter"))));
		}
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", userId);
		
		List<GIUWPolDistPolbasicV> list = (List<GIUWPolDistPolbasicV>) StringFormatter.escapeHTMLInList(this.giuwDistBatchDAO.getPoliciesByParam(params));
		System.out.println("list total: "+list.size());
		JSONArray arr = new JSONArray(list);
		System.out.println("array length: "+ arr.length());
		
		return arr;
	}
}
