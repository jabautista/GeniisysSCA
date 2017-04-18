package com.geniisys.giac.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.giis.entity.BaseEntity;

/**
 * The class GIACParameter
 *
 */
public class GIACParameter extends BaseEntity{

	private String paramType;
	
	private String paramName;
	
	private Integer paramValueN;
	
	private Date paramValueD;
	
	private String paramValueV;
	
	/*private String userId;	
								 // commented, properties included in BaseEntity : shan 11.25.2013
	private Date lastUpdate; */
	
	private String remarks;
	
	private Integer cpiRecNo;
	
	private String cpiBranchCd;
	
	//added by shan 11.25.2013
	private String meanParamType;
	private String dspParamValueD;
	private BigDecimal paramValueN2;

	public String getParamType() {
		return paramType;
	}

	public void setParamType(String paramType) {
		this.paramType = paramType;
	}

	public String getParamName() {
		return paramName;
	}

	public void setParamName(String paramName) {
		this.paramName = paramName;
	}

	public Integer getParamValueN() {
		return paramValueN;
	}

	public void setParamValueN(Integer paramValueN) {
		this.paramValueN = paramValueN;
	}

	public Date getParamValueD() {
		return paramValueD;
	}

	public void setParamValueD(Date paramValueD) {
		this.paramValueD = paramValueD;
	}

	public String getParamValueV() {
		return paramValueV;
	}

	public void setParamValueV(String paramValueV) {
		this.paramValueV = paramValueV;
	}

	/*public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public Date getLastUpdate() {
		return lastUpdate;
	}

	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
	}*/

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
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

	public String getMeanParamType() {
		return meanParamType;
	}

	public void setMeanParamType(String meanParamType) {
		this.meanParamType = meanParamType;
	}

	public String getDspParamValueD() {
		return dspParamValueD;
	}

	public void setDspParamValueD(String dspParamValueD) {
		this.dspParamValueD = dspParamValueD;
	}

	public BigDecimal getParamValueN2() {
		return paramValueN2;
	}

	public void setParamValueN2(BigDecimal paramValueN2) {
		this.paramValueN2 = paramValueN2;
	}
	
	
	
}
