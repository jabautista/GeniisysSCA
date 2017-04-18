package com.geniisys.gicl.entity;

import java.util.Date;

import com.geniisys.giis.entity.BaseEntity;

public class GICLNoClaimMultiYy extends BaseEntity{
	
	private String noClaimNo;
	private String plateNo;
	private String motorNo;
	private String serialNo;
	private Integer assdNo;
	private Integer noClaimId;
	private String ncIssCd;
	private Integer makeCd;
	private String assdName;
	private String carCompany;
	private String make;
	private String basicColorCd;
	private Integer colorCd;
	private String remarks;
	private String basicColor;
	private String color;
	private String policyNo;
	private String policyId;
	private String lineCd;
	private String sublineCd;
	private String issCd;
	private Integer issueYy;
	private Integer polSeqNo;
	private Integer renewNo;
	private Date effDate;
	private Date expiryDate;
	private Date inceptDate;
	private String userId;
	private Integer motcarCompCd;
	private String modelYear;
	private String message;
	private Integer carCompanyCd;
	private Date ncIssueDate;
	private Date ncLastUpdate;
	private Integer ncNoClaimId;
	private Integer ncIssueYy;
	private Integer ncSeqNo;
	private String ncNoClaimNo;
	private Date noIssueDate;
	private String cancelTag;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private String refPolNo;
	private String nbtLineCd;
	private String nbtIssCd;
	private Integer parYy;
	private Integer parSeqNo;
	private Integer quoteSeqNo;
	private Date issueDate;
	private String meanPolFlag;
	private String lineCdRn;
	private String issCdRn;
	private Integer rnYy;
	private Integer rnSeqNo;
	private String credBranch;
	private String packPolNo;
	private String menuLineCd;
	private String lineCdMC;
	
	// non table properties
	private String strExpiryDate;
	private String strInceptDate;
	
	public String getStrExpiryDate() {
		return strExpiryDate;
	}
	public void setStrExpiryDate(String strExpiryDate) {
		this.strExpiryDate = strExpiryDate;
	}
	public String getStrInceptDate() {
		return strInceptDate;
	}
	public void setStrInceptDate(String strInceptDate) {
		this.strInceptDate = strInceptDate;
	}
	public String getMenuLineCd() {
		return menuLineCd;
	}
	public void setMenuLineCd(String menuLineCd) {
		this.menuLineCd = menuLineCd;
	}
	public String getLineCdMC() {
		return lineCdMC;
	}
	public void setLineCdMC(String lineCdMC) {
		this.lineCdMC = lineCdMC;
	}
	public Date getIssueDate() {
		return issueDate;
	}
	public void setIssueDate(Date issueDate) {
		this.issueDate = issueDate;
	}
	public String getMeanPolFlag() {
		return meanPolFlag;
	}
	public void setMeanPolFlag(String meanPolFlag) {
		this.meanPolFlag = meanPolFlag;
	}
	public String getLineCdRn() {
		return lineCdRn;
	}
	public void setLineCdRn(String lineCdRn) {
		this.lineCdRn = lineCdRn;
	}
	public String getIssCdRn() {
		return issCdRn;
	}
	public void setIssCdRn(String issCdRn) {
		this.issCdRn = issCdRn;
	}
	public Integer getRnYy() {
		return rnYy;
	}
	public void setRnYy(Integer rnYy) {
		this.rnYy = rnYy;
	}
	public Integer getRnSeqNo() {
		return rnSeqNo;
	}
	public void setRnSeqNo(Integer rnSeqNo) {
		this.rnSeqNo = rnSeqNo;
	}
	public String getCredBranch() {
		return credBranch;
	}
	public void setCredBranch(String credBranch) {
		this.credBranch = credBranch;
	}
	public String getPackPolNo() {
		return packPolNo;
	}
	public void setPackPolNo(String packPolNo) {
		this.packPolNo = packPolNo;
	}
	public String getRefPolNo() {
		return refPolNo;
	}
	public void setRefPolNo(String refPolNo) {
		this.refPolNo = refPolNo;
	}
	public String getNbtLineCd() {
		return nbtLineCd;
	}
	public void setNbtLineCd(String nbtLineCd) {
		this.nbtLineCd = nbtLineCd;
	}
	public String getNbtIssCd() {
		return nbtIssCd;
	}
	public void setNbtIssCd(String nbtIssCd) {
		this.nbtIssCd = nbtIssCd;
	}
	public Integer getParYy() {
		return parYy;
	}
	public void setParYy(Integer parYy) {
		this.parYy = parYy;
	}
	public Integer getParSeqNo() {
		return parSeqNo;
	}
	public void setParSeqNo(Integer parSeqNo) {
		this.parSeqNo = parSeqNo;
	}
	public Integer getQuoteSeqNo() {
		return quoteSeqNo;
	}
	public void setQuoteSeqNo(Integer quoteSeqNo) {
		this.quoteSeqNo = quoteSeqNo;
	}
	public String getCpiBranchCd() {
		return cpiBranchCd;
	}
	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}
	public Integer getCpiRecNo() {
		return cpiRecNo;
	}
	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}
	public String getCancelTag() {
		return cancelTag;
	}
	public void setCancelTag(String cancelTag) {
		this.cancelTag = cancelTag;
	}
	public Date getNoIssueDate() {
		return noIssueDate;
	}
	public void setNoIssueDate(Date noIssueDate) {
		this.noIssueDate = noIssueDate;
	}
	public Date getNcIssueDate() {
		return ncIssueDate;
	}
	public void setNcIssueDate(Date ncIssueDate) {
		this.ncIssueDate = ncIssueDate;
	}
	public Date getNcLastUpdate() {
		return ncLastUpdate;
	}
	public void setNcLastUpdate(Date ncLastUpdate) {
		this.ncLastUpdate = ncLastUpdate;
	}
	public Integer getNcNoClaimId() {
		return ncNoClaimId;
	}
	public void setNcNoClaimId(Integer ncNoClaimId) {
		this.ncNoClaimId = ncNoClaimId;
	}
	public Integer getNcIssueYy() {
		return ncIssueYy;
	}
	public void setNcIssueYy(Integer ncIssueYy) {
		this.ncIssueYy = ncIssueYy;
	}
	public Integer getNcSeqNo() {
		return ncSeqNo;
	}
	public void setNcSeqNo(Integer ncSeqNo) {
		this.ncSeqNo = ncSeqNo;
	}
	public String getNcNoClaimNo() {
		return ncNoClaimNo;
	}
	public void setNcNoClaimNo(String ncNoClaimNo) {
		this.ncNoClaimNo = ncNoClaimNo;
	}
	public Integer getCarCompanyCd() {
		return carCompanyCd;
	}
	public void setCarCompanyCd(Integer carCompanyCd) {
		this.carCompanyCd = carCompanyCd;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public String getModelYear() {
		return modelYear;
	}
	public void setModelYear(String modelYear) {
		this.modelYear = modelYear;
	}
	public Integer getMotcarCompCd() {
		return motcarCompCd;
	}
	public void setMotcarCompCd(Integer motcarCompCd) {
		this.motcarCompCd = motcarCompCd;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getPolicyNo() {
		return policyNo;
	}
	public void setPolicyNo(String policyNo) {
		this.policyNo = policyNo;
	}
	public String getPolicyId() {
		return policyId;
	}
	public void setPolicyId(String policyId) {
		this.policyId = policyId;
	}
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public String getSublineCd() {
		return sublineCd;
	}
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}
	public String getIssCd() {
		return issCd;
	}
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}
	public Integer getIssueYy() {
		return issueYy;
	}
	public void setIssueYy(Integer issueYy) {
		this.issueYy = issueYy;
	}
	public Integer getPolSeqNo() {
		return polSeqNo;
	}
	public void setPolSeqNo(Integer polSeqNo) {
		this.polSeqNo = polSeqNo;
	}
	public Integer getRenewNo() {
		return renewNo;
	}
	public void setRenewNo(Integer renewNo) {
		this.renewNo = renewNo;
	}
	public Date getEffDate() {
		return effDate;
	}
	public void setEffDate(Date effDate) {
		this.effDate = effDate;
	}
	public Date getExpiryDate() {
		return expiryDate;
	}
	public void setExpiryDate(Date expiryDate) {
		this.expiryDate = expiryDate;
	}
	public Date getInceptDate() {
		return inceptDate;
	}
	public void setInceptDate(Date inceptDate) {
		this.inceptDate = inceptDate;
	}
	public String getBasicColor() {
		return basicColor;
	}
	public void setBasicColor(String basicColor) {
		this.basicColor = basicColor;
	}
	public String getColor() {
		return color;
	}
	public void setColor(String color) {
		this.color = color;
	}
	public String getBasicColorCd() {
		return basicColorCd;
	}
	public void setBasicColorCd(String basicColorCd) {
		this.basicColorCd = basicColorCd;
	}
	public Integer getColorCd() {
		return colorCd;
	}
	public void setColorCd(Integer colorCd) {
		this.colorCd = colorCd;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public String getNoClaimNo() {
		return noClaimNo;
	}
	public void setNoClaimNo(String noClaimNo) {
		this.noClaimNo = noClaimNo;
	}
	public String getPlateNo() {
		return plateNo;
	}
	public void setPlateNo(String plateNo) {
		this.plateNo = plateNo;
	}
	public String getMotorNo() {
		return motorNo;
	}
	public void setMotorNo(String motorNo) {
		this.motorNo = motorNo;
	}
	public String getSerialNo() {
		return serialNo;
	}
	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
	public Integer getAssdNo() {
		return assdNo;
	}
	public void setAssdNo(Integer assdNo) {
		this.assdNo = assdNo;
	}
	public Integer getNoClaimId() {
		return noClaimId;
	}
	public void setNoClaimId(Integer noClaimId) {
		this.noClaimId = noClaimId;
	}
	public String getNcIssCd() {
		return ncIssCd;
	}
	public void setNcIssCd(String ncIssCd) {
		this.ncIssCd = ncIssCd;
	}
	public Integer getMakeCd() {
		return makeCd;
	}
	public void setMakeCd(Integer makeCd) {
		this.makeCd = makeCd;
	}
	public String getAssdName() {
		return assdName;
	}
	public void setAssdName(String assdName) {
		this.assdName = assdName;
	}
	public String getCarCompany() {
		return carCompany;
	}
	public void setCarCompany(String carCompany) {
		this.carCompany = carCompany;
	}
	public String getMake() {
		return make;
	}
	public void setMake(String make) {
		this.make = make;
	}
	
	
	
	
}
