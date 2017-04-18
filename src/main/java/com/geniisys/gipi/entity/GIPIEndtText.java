package com.geniisys.gipi.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIPIEndtText extends BaseEntity{
	
	private Integer policyId;
	private String endtText;
	private String endtText01;
	private String endtText02;
	private String endtText03;
	private String endtText04;
	private String endtText05;
	private String endtText06;
	private String endtText07;
	private String endtText08;
	private String endtText09;
	private String endtText10;
	private String endtText11;
	private String endtText12;
	private String endtText13;
	private String endtText14;
	private String endtText15;
	private String endtText16;
	private String endtText17;
	private String userId;
	private String lastUpdate;
	
	public GIPIEndtText(){
		super();
	}
	
	public GIPIEndtText(Integer policyId, String endtText, String userId, String lastUpdate){
		super();
		this.policyId = policyId;
		this.endtText = endtText;
		this.userId = userId;
		this.lastUpdate = lastUpdate;
	}


	public Integer getPolicyId() {
		return policyId;
	}

	public void setPolicyId(Integer policyId) {
		this.policyId = policyId;
	}

	public String getEndtText() {
		endtText =
				 (this.getEndtText01() != null ? this.getEndtText01() : "") +
				 (this.getEndtText02() != null ? this.getEndtText02() : "") +
				 (this.getEndtText03() != null ? this.getEndtText03() : "") +
				 (this.getEndtText04() != null ? this.getEndtText04() : "") +
				 (this.getEndtText05() != null ? this.getEndtText05() : "") +
				 (this.getEndtText06() != null ? this.getEndtText06() : "") +
				 (this.getEndtText07() != null ? this.getEndtText07() : "") +
				 (this.getEndtText08() != null ? this.getEndtText08() : "") +
				 (this.getEndtText09() != null ? this.getEndtText09() : "") +
				 (this.getEndtText10() != null ? this.getEndtText10() : "") +
				 (this.getEndtText11() != null ? this.getEndtText11() : "") +
				 (this.getEndtText12() != null ? this.getEndtText12() : "") +
				 (this.getEndtText13() != null ? this.getEndtText13() : "") +
				 (this.getEndtText14() != null ? this.getEndtText14() : "") +
				 (this.getEndtText15() != null ? this.getEndtText15() : "") +
				 (this.getEndtText16() != null ? this.getEndtText16() : "") +
				 (this.getEndtText17() != null ? this.getEndtText17() : "");
		return endtText;
	}

	public void setEndtText(String endtText) {
		this.endtText = endtText;
	}

	public String getEndtText01() {
		return endtText01;
	}

	public void setEndtText01(String endtText01) {
		this.endtText01 = endtText01;
	}

	public String getEndtText02() {
		return endtText02;
	}

	public void setEndtText02(String endtText02) {
		this.endtText02 = endtText02;
	}

	public String getEndtText03() {
		return endtText03;
	}

	public void setEndtText03(String endtText03) {
		this.endtText03 = endtText03;
	}

	public String getEndtText04() {
		return endtText04;
	}

	public void setEndtText04(String endtText04) {
		this.endtText04 = endtText04;
	}

	public String getEndtText05() {
		return endtText05;
	}

	public void setEndtText05(String endtText05) {
		this.endtText05 = endtText05;
	}

	public String getEndtText06() {
		return endtText06;
	}

	public void setEndtText06(String endtText06) {
		this.endtText06 = endtText06;
	}

	public String getEndtText07() {
		return endtText07;
	}

	public void setEndtText07(String endtText07) {
		this.endtText07 = endtText07;
	}

	public String getEndtText08() {
		return endtText08;
	}

	public void setEndtText08(String endtText08) {
		this.endtText08 = endtText08;
	}

	public String getEndtText09() {
		return endtText09;
	}

	public void setEndtText09(String endtText09) {
		this.endtText09 = endtText09;
	}

	public String getEndtText10() {
		return endtText10;
	}

	public void setEndtText10(String endtText10) {
		this.endtText10 = endtText10;
	}

	public String getEndtText11() {
		return endtText11;
	}

	public void setEndtText11(String endtText11) {
		this.endtText11 = endtText11;
	}

	public String getEndtText12() {
		return endtText12;
	}

	public void setEndtText12(String endtText12) {
		this.endtText12 = endtText12;
	}

	public String getEndtText13() {
		return endtText13;
	}

	public void setEndtText13(String endtText13) {
		this.endtText13 = endtText13;
	}

	public String getEndtText14() {
		return endtText14;
	}

	public void setEndtText14(String endtText14) {
		this.endtText14 = endtText14;
	}

	public String getEndtText15() {
		return endtText15;
	}

	public void setEndtText15(String endtText15) {
		this.endtText15 = endtText15;
	}

	public String getEndtText16() {
		return endtText16;
	}

	public void setEndtText16(String endtText16) {
		this.endtText16 = endtText16;
	}

	public String getEndtText17() {
		return endtText17;
	}

	public void setEndtText17(String endtText17) {
		this.endtText17 = endtText17;
	}
	
	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getLastUpdate() {
		return lastUpdate;
	}

	public void setLastUpdate(String lastUpdate) {
		this.lastUpdate = lastUpdate;
	}
	
}
