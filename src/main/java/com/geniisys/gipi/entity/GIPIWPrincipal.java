package com.geniisys.gipi.entity;

import com.geniisys.framework.util.BaseEntity;

public class GIPIWPrincipal extends BaseEntity {

	private int parId;
	private int principalCd;
	private int enBasicInfoNum;
	private String subconSW;
	private String principalName;
	private String principalType;

	public int getParId() {
		return parId;
	}

	public void setParId(int parId) {
		this.parId = parId;
	}

	public int getPrincipalCd() {
		return principalCd;
	}

	public void setPrincipalCd(int principalCd) {
		this.principalCd = principalCd;
	}

	public int getEnBasicInfoNum() {
		return enBasicInfoNum;
	}

	public void setEnBasicInfoNum(int enBasicInfoNum) {
		this.enBasicInfoNum = enBasicInfoNum;
	}

	public String getSubconSW() {
		return subconSW;
	}

	public void setSubconSW(String subconSW) {
		this.subconSW = subconSW;
	}

	public void setPrincipalName(String principalName) {
		this.principalName = principalName;
	}

	public String getPrincipalName() {
		return principalName;
	}

	public void setPrincipalType(String principalType) {
		this.principalType = principalType;
	}

	public String getPrincipalType() {
		return principalType;
	}

}
