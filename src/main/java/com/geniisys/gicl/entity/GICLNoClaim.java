package com.geniisys.gicl.entity;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GICLNoClaim extends BaseEntity{
	private Integer noClaimId;
	private String lineCd;
	private String sublineCd;
	private String issCd;
	private Integer issueYy;
	private Integer polSeqNo;
	private Integer renewNo;
	private Integer itemNo;
	private Integer assdNo;
	private String assdName;
	private Date effDate;
	private Date expiryDate;
	private Date ncIssueDate;
	private Integer ncTypeCd;
	private String modelYear;
	private Integer makeCd;
	private String itemTitle;
	private String motorNo;
	private String serialNo;
	private String plateNo;
	private String basicColorCd;
	private Integer colorCd;
	private BigDecimal amount;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private String userId;
	private Date lastUpdate;
	private String printTag;
	private String location;
	private Date ncLossDate;
	private String cancelTag;
	private Integer ncSeqNo;
	private String ncIssCd;
	private Integer ncIssueYy;
	private String remarks;
	private Integer motcarCompCd;
	
	private String noClaimNo;
	private String policyNo;
	private String carCompany;
	private String make;
	private String basicColor;
	private String color;
	private String menuLineCd;
	private String lineCdMC;
	
	public GICLNoClaim() {
		super();
	}

	public Integer getNoClaimId() {
		return noClaimId;
	}

	public void setNoClaimId(Integer noClaimId) {
		this.noClaimId = noClaimId;
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

	public Integer getItemNo() {
		return itemNo;
	}

	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}

	public Integer getAssdNo() {
		return assdNo;
	}

	public void setAssdNo(Integer assdNo) {
		this.assdNo = assdNo;
	}

	public String getAssdName() {
		return assdName;
	}

	public void setAssdName(String assdName) {
		this.assdName = assdName;
	}
	
	public Object getStrEffDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		if (effDate != null) {
			return df.format(effDate);			
		} else {
			return null;
		}
	}

	public Date getEffDate() {
		return effDate;
	}

	public void setEffDate(Date effDate) {
		this.effDate = effDate;
	}
	
	public Object getStrExpiryDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		if (expiryDate != null) {
			return df.format(expiryDate);			
		} else {
			return null;
		}
	}
	
	public Date getExpiryDate() {
		return expiryDate;
	}

	public void setExpiryDate(Date expiryDate) {
		this.expiryDate = expiryDate;
	}
	
	public Object getStrNcIssueDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		if (ncIssueDate != null) {
			return df.format(ncIssueDate);			
		} else {
			return null;
		}
	}

	public Date getNcIssueDate() {
		return ncIssueDate;
	}

	public void setNcIssueDate(Date ncIssueDate) {
		this.ncIssueDate = ncIssueDate;
	}

	public Integer getNcTypeCd() {
		return ncTypeCd;
	}

	public void setNcTypeCd(Integer ncTypeCd) {
		this.ncTypeCd = ncTypeCd;
	}

	public String getModelYear() {
		return modelYear;
	}

	public void setModelYear(String modelYear) {
		this.modelYear = modelYear;
	}

	public Integer getMakeCd() {
		return makeCd;
	}

	public void setMakeCd(Integer makeCd) {
		this.makeCd = makeCd;
	}

	public String getItemTitle() {
		return itemTitle;
	}

	public void setItemTitle(String itemTitle) {
		this.itemTitle = itemTitle;
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

	public String getPlateNo() {
		return plateNo;
	}

	public void setPlateNo(String plateNo) {
		this.plateNo = plateNo;
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

	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
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

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	public Object getStrLastUpdate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		if (lastUpdate != null) {
			return df.format(lastUpdate);			
		} else {
			return null;
		}
	}

	public Date getLastUpdate() {
		return lastUpdate;
	}

	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
	}

	public String getPrintTag() {
		return printTag;
	}

	public void setPrintTag(String printTag) {
		this.printTag = printTag;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}
	
	public Object getStrNcLossDate() {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		if (ncLossDate != null) {
			return df.format(ncLossDate);			
		} else {
			return null;
		}
	}

	public Date getNcLossDate() {
		return ncLossDate;
	}

	public void setNcLossDate(Date ncLossDate) {
		this.ncLossDate = ncLossDate;
	}

	public String getCancelTag() {
		return cancelTag;
	}

	public void setCancelTag(String cancelTag) {
		this.cancelTag = cancelTag;
	}

	public Integer getNcSeqNo() {
		return ncSeqNo;
	}

	public void setNcSeqNo(Integer ncSeqNo) {
		this.ncSeqNo = ncSeqNo;
	}

	public String getNcIssCd() {
		return ncIssCd;
	}

	public void setNcIssCd(String ncIssCd) {
		this.ncIssCd = ncIssCd;
	}

	public Integer getNcIssueYy() {
		return ncIssueYy;
	}

	public void setNcIssueYy(Integer ncIssueYy) {
		this.ncIssueYy = ncIssueYy;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public Integer getMotcarCompCd() {
		return motcarCompCd;
	}

	public void setMotcarCompCd(Integer motcarCompCd) {
		this.motcarCompCd = motcarCompCd;
	}

	public String getNoClaimNo() {
		return noClaimNo;
	}

	public void setNoClaimNo(String noClaimNo) {
		this.noClaimNo = noClaimNo;
	}

	public String getPolicyNo() {
		return policyNo;
	}

	public void setPolicyNo(String policyNo) {
		this.policyNo = policyNo;
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
	
}
