package com.geniisys.gicl.entity;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import com.geniisys.framework.util.BaseEntity;

public class GICLReserveDs extends BaseEntity{
	private Integer claimId;
	private Integer clmResHistId;
	private Integer clmDistNo;
	private Integer grpSeqNo;
	private Integer distYear;
	private Integer itemNo;
	private Integer perilCd;
	private Integer histSeqNo;
	private String lineCd;
	private String negateTag;
	private Integer acctTrtyType;
	private String shareType;
	private BigDecimal shrPct;
	private BigDecimal shrLossResAmt;
	private BigDecimal shrExpResAmt;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private Integer groupedItemNo;
	private BigDecimal xolDed;
	private String dspTrtyName;
	private String dspShrLossResAmt;
	private String dspShrExpResAmt;
	
	private String updResDist;
	private String prtfolioSw;
	private BigDecimal xolDedAmt;
	private String netRet;
	
	public Integer getClaimId() {
		return claimId;
	}
	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
	}
	public Integer getClmResHistId() {
		return clmResHistId;
	}
	public void setClmResHistId(Integer clmResHistId) {
		this.clmResHistId = clmResHistId;
	}
	public Integer getClmDistNo() {
		return clmDistNo;
	}
	public void setClmDistNo(Integer clmDistNo) {
		this.clmDistNo = clmDistNo;
	}
	public Integer getGrpSeqNo() {
		return grpSeqNo;
	}
	public void setGrpSeqNo(Integer grpSeqNo) {
		this.grpSeqNo = grpSeqNo;
	}
	public Integer getDistYear() {
		return distYear;
	}
	public void setDistYear(Integer distYear) {
		this.distYear = distYear;
	}
	public Integer getItemNo() {
		return itemNo;
	}
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}
	public Integer getPerilCd() {
		return perilCd;
	}
	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}
	public Integer getHistSeqNo() {
		return histSeqNo;
	}
	public void setHistSeqNo(Integer histSeqNo) {
		this.histSeqNo = histSeqNo;
	}
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public String getNegateTag() {
		return negateTag;
	}
	public void setNegateTag(String negateTag) {
		this.negateTag = negateTag;
	}
	public Integer getAcctTrtyType() {
		return acctTrtyType;
	}
	public void setAcctTrtyType(Integer acctTrtyType) {
		this.acctTrtyType = acctTrtyType;
	}
	public String getShareType() {
		return shareType;
	}
	public void setShareType(String shareType) {
		this.shareType = shareType;
	}
	public BigDecimal getShrPct() {
		return shrPct;
	}
	public void setShrPct(BigDecimal shrPct) {
		this.shrPct = shrPct;
	}
	public BigDecimal getShrLossResAmt() {
		return shrLossResAmt;
	}
	public void setShrLossResAmt(BigDecimal shrLossResAmt) {
		this.shrLossResAmt = shrLossResAmt;
	}
	public BigDecimal getShrExpResAmt() {
		return shrExpResAmt;
	}
	public void setShrExpResAmt(BigDecimal shrExpResAmt) {
		this.shrExpResAmt = shrExpResAmt;
	}
	public Integer getCpiRecNo() {
		return cpiRecNo;
	}
	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}
	public String getCpiBranchCd() {
		return cpiBranchCd;
	}
	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}
	public Integer getGroupedItemNo() {
		return groupedItemNo;
	}
	public void setGroupedItemNo(Integer groupedItemNo) {
		this.groupedItemNo = groupedItemNo;
	}
	public BigDecimal getXolDed() {
		return xolDed;
	}
	public void setXolDed(BigDecimal xolDed) {
		this.xolDed = xolDed;
	}
	public String getDspTrtyName() {
		return dspTrtyName;
	}
	public void setDspTrtyName(String dspTrtyName) {
		this.dspTrtyName = dspTrtyName;
	}
	public String getDspShrLossResAmt() {
		return dspShrLossResAmt;
	}
	public void setDspShrLossResAmt(String dspShrLossResAmt) {
		this.dspShrLossResAmt = dspShrLossResAmt;
	}
	public String getDspShrExpResAmt() {
		return dspShrExpResAmt;
	}
	public void setDspShrExpResAmt(String dspShrExpResAmt) {
		this.dspShrExpResAmt = dspShrExpResAmt;
	}
	
	public String getUpdResDist() {
		return updResDist;
	}
	public void setUpdResDist(String updResDist) {
		this.updResDist = updResDist;
	}
	public String getPrtfolioSw() {
		return prtfolioSw;
	}
	public void setPrtfolioSw(String prtfolioSw) {
		this.prtfolioSw = prtfolioSw;
	}
	public BigDecimal getXolDedAmt() {
		return xolDedAmt;
	}
	public void setXolDedAmt(BigDecimal xolDedAmt) {
		this.xolDedAmt = xolDedAmt;
	}
	public String getNetRet() {
		return netRet;
	}
	public void setNetRet(String netRet) {
		this.netRet = netRet;
	}
	/**
	 * Creates a Map from a reserveDs object - map will be used for saveReserveDS procedure only
	 * @param Reserve Ds
	 * @return parameter map for saveReserveDS
	 */
	public static Map<String, Object> makeSetReserveDsParameterMap(GICLReserveDs ds){
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("userId", ds.getUserId());
		params.put("claimId", ds.getClaimId());
		params.put("clmResHistId", ds.getClmResHistId());
		params.put("clmDistNo", ds.getClmDistNo());
		params.put("grpSeqNo", ds.getGrpSeqNo());
		params.put("distYear", ds.getDistYear());
		params.put("perilCd", ds.getPerilCd());
		params.put("histSeqNo", ds.getHistSeqNo());
		params.put("lineCd", ds.getLineCd());
		params.put("shareType", ds.getShareType());
		params.put("shrPct", ds.getShrPct());
		params.put("shrLossResAmt", ds.getShrLossResAmt());
		params.put("shrExpResAmt", ds.getShrExpResAmt());
		params.put("cpiRecNo", ds.getCpiRecNo());
		params.put("cpiBranchCd", ds.getCpiBranchCd());
		params.put("groupedItemNo", ds.getGroupedItemNo());
		return params;
	}
	
	public static GICLReserveDs makeReserveDs(Map<String, Object> map){
		GICLReserveDs ds = new GICLReserveDs();
		Iterator<String> iter = map.keySet().iterator();
		
		String key = "";
		while(iter.hasNext()){
			key = iter.next();
			try{
				Object prop = map.get(key);
				if(key.equals("claimId")){
					ds.setClaimId(Integer.parseInt(prop.toString()));
				}else if(key.equals("clmDistNo")){
					ds.setClmDistNo(Integer.parseInt(prop.toString()));
				}else if(key.equals("clmResHistId")){
					ds.setClmResHistId(Integer.parseInt(prop.toString()));
				}else if(key.equals("grpSeqNo")){
					ds.setGrpSeqNo(Integer.parseInt(prop.toString()));
				}else if(key.equals("distYear")){
					ds.setDistYear(Integer.parseInt(prop.toString()));
				}else if(key.equals("itemNo")){
					ds.setItemNo(Integer.parseInt(prop.toString()));
				}else if(key.equals("perilCd")){
					ds.setPerilCd(Integer.parseInt(prop.toString()));
				}else if(key.equals("histSeqNo")){
					ds.setHistSeqNo(Integer.parseInt(prop.toString()));
				}else if(key.equals("lineCd")){
					ds.setLineCd(prop.toString());
				}else if(key.equals("negateTag")){
					ds.setNegateTag(prop.toString());
				}else if(key.equals("acctTrtyType")){
					ds.setAcctTrtyType(Integer.parseInt(prop.toString()));
				}else if(key.equals("shareType")){
					ds.setShareType(prop.toString());
				}else if(key.equals("shrPct")){
					ds.setShrPct(new BigDecimal(Double.parseDouble(prop.toString())));
				}else if(key.equals("shrLossResAmt")){
					ds.setShrLossResAmt(new BigDecimal(Double.parseDouble(prop.toString())));
				}else if(key.equals("shrExpResAmt")){
					ds.setShrExpResAmt(new BigDecimal(Double.parseDouble(prop.toString())));
				}else if(key.equals("cpiRecNo")){
					ds.setCpiRecNo(Integer.parseInt(prop.toString()));
				}else if(key.equals("cpiBranchCd")){
					ds.setCpiBranchCd(prop.toString());
				}else if(key.equals("groupedItemNo")){
					ds.setGroupedItemNo(Integer.parseInt(prop.toString()));
				}else if(key.equals("xolDed")){
					ds.setXolDed(new BigDecimal(Double.parseDouble(prop.toString())));
				}else if(key.equals("dspTrtyName")){
					ds.setDspTrtyName(prop.toString());
				}else if(key.equals("dspShrLossResAmt")){
					ds.setDspShrLossResAmt(prop.toString());
				}else if(key.equals("dspShrExpResAmt")){
					ds.setDspShrExpResAmt(prop.toString());
				}
			}catch (Exception e) {
				System.out.println("ERROR Creating reserve ds: " + e.getMessage());
			}
		}
		
		return ds;
	}
}