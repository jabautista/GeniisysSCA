package com.geniisys.gipi.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIPIPackPolgenin extends BaseEntity{
	
	private Integer packPolicyId;
	private String genInfo;
	private String genInfo01;
	private String genInfo02;
	private String genInfo03;
	private String genInfo04;
	private String genInfo05;
	private String genInfo06;
	private String genInfo07;
	private String genInfo08;
	private String genInfo09;
	private String genInfo10;
	private String genInfo11;
	private String genInfo12;
	private String genInfo13;
	private String genInfo14;
	private String genInfo15;
	private String genInfo16;
	private String genInfo17;
	private String initialInfo;
	private String initialInfo01;
	private String initialInfo02;
	private String initialInfo03;
	private String initialInfo04;
	private String initialInfo05;
	private String initialInfo06;
	private String initialInfo07;
	private String initialInfo08;
	private String initialInfo09;
	private String initialInfo10;
	private String initialInfo11;
	private String initialInfo12;
	private String initialInfo13;
	private String initialInfo14;
	private String initialInfo15;
	private String initialInfo16;
	private String initialInfo17;
	private String userId;
	private String lastUpdate;
	
	public GIPIPackPolgenin(){
		super();
	}
	
	public GIPIPackPolgenin(Integer packPolicyId, String genInfo, String initialInfo, String userId, String lastUpdate){
		super();
		this.packPolicyId = packPolicyId;
		this.genInfo = genInfo;
		this.initialInfo = initialInfo;
		this.userId = userId;
		this.lastUpdate = lastUpdate;
	}

	public Integer getPackPolicyId() {
		return packPolicyId;
	}

	public void setPackPolicyId(Integer packPolicyId) {
		this.packPolicyId = packPolicyId;
	}

	public String getGenInfo() {
		genInfo =
				 (this.getGenInfo01() != null ? this.getGenInfo01() : "") +
				 (this.getGenInfo02() != null ? this.getGenInfo02() : "") +
				 (this.getGenInfo03() != null ? this.getGenInfo03() : "") +
				 (this.getGenInfo04() != null ? this.getGenInfo04() : "") +
				 (this.getGenInfo05() != null ? this.getGenInfo05() : "") +
				 (this.getGenInfo06() != null ? this.getGenInfo06() : "") +
				 (this.getGenInfo07() != null ? this.getGenInfo07() : "") +
				 (this.getGenInfo08() != null ? this.getGenInfo08() : "") +
				 (this.getGenInfo09() != null ? this.getGenInfo09() : "") +
				 (this.getGenInfo10() != null ? this.getGenInfo10() : "") +
				 (this.getGenInfo11() != null ? this.getGenInfo11() : "") +
				 (this.getGenInfo12() != null ? this.getGenInfo12() : "") +
				 (this.getGenInfo13() != null ? this.getGenInfo13() : "") +
				 (this.getGenInfo14() != null ? this.getGenInfo14() : "") +
				 (this.getGenInfo15() != null ? this.getGenInfo15() : "") +
				 (this.getGenInfo16() != null ? this.getGenInfo16() : "") +
				 (this.getGenInfo17() != null ? this.getGenInfo17() : "");
		return genInfo;
	}

	public void setGenInfo(String genInfo) {
		this.genInfo = genInfo;
	}

	public String getGenInfo01() {
		return genInfo01;
	}

	public void setGenInfo01(String genInfo01) {
		this.genInfo01 = genInfo01;
	}

	public String getGenInfo02() {
		return genInfo02;
	}

	public void setGenInfo02(String genInfo02) {
		this.genInfo02 = genInfo02;
	}

	public String getGenInfo03() {
		return genInfo03;
	}

	public void setGenInfo03(String genInfo03) {
		this.genInfo03 = genInfo03;
	}

	public String getGenInfo04() {
		return genInfo04;
	}

	public void setGenInfo04(String genInfo04) {
		this.genInfo04 = genInfo04;
	}

	public String getGenInfo05() {
		return genInfo05;
	}

	public void setGenInfo05(String genInfo05) {
		this.genInfo05 = genInfo05;
	}

	public String getGenInfo06() {
		return genInfo06;
	}

	public void setGenInfo06(String genInfo06) {
		this.genInfo06 = genInfo06;
	}

	public String getGenInfo07() {
		return genInfo07;
	}

	public void setGenInfo07(String genInfo07) {
		this.genInfo07 = genInfo07;
	}

	public String getGenInfo08() {
		return genInfo08;
	}

	public void setGenInfo08(String genInfo08) {
		this.genInfo08 = genInfo08;
	}

	public String getGenInfo09() {
		return genInfo09;
	}

	public void setGenInfo09(String genInfo09) {
		this.genInfo09 = genInfo09;
	}

	public String getGenInfo10() {
		return genInfo10;
	}

	public void setGenInfo10(String genInfo10) {
		this.genInfo10 = genInfo10;
	}

	public String getGenInfo11() {
		return genInfo11;
	}

	public void setGenInfo11(String genInfo11) {
		this.genInfo11 = genInfo11;
	}

	public String getGenInfo12() {
		return genInfo12;
	}

	public void setGenInfo12(String genInfo12) {
		this.genInfo12 = genInfo12;
	}

	public String getGenInfo13() {
		return genInfo13;
	}

	public void setGenInfo13(String genInfo13) {
		this.genInfo13 = genInfo13;
	}

	public String getGenInfo14() {
		return genInfo14;
	}

	public void setGenInfo14(String genInfo14) {
		this.genInfo14 = genInfo14;
	}

	public String getGenInfo15() {
		return genInfo15;
	}

	public void setGenInfo15(String genInfo15) {
		this.genInfo15 = genInfo15;
	}

	public String getGenInfo16() {
		return genInfo16;
	}

	public void setGenInfo16(String genInfo16) {
		this.genInfo16 = genInfo16;
	}

	public String getGenInfo17() {
		return genInfo17;
	}

	public void setGenInfo17(String genInfo17) {
		this.genInfo17 = genInfo17;
	}

	public String getInitialInfo() {
		initialInfo =
				 (this.getInitialInfo01() != null ? this.getInitialInfo01() : "") +
				 (this.getInitialInfo02() != null ? this.getInitialInfo02() : "") +
				 (this.getInitialInfo03() != null ? this.getInitialInfo03() : "") +
				 (this.getInitialInfo04() != null ? this.getInitialInfo04() : "") +
				 (this.getInitialInfo05() != null ? this.getInitialInfo05() : "") +
				 (this.getInitialInfo06() != null ? this.getInitialInfo06() : "") +
				 (this.getInitialInfo07() != null ? this.getInitialInfo07() : "") +
				 (this.getInitialInfo08() != null ? this.getInitialInfo08() : "") +
				 (this.getInitialInfo09() != null ? this.getInitialInfo09() : "") +
				 (this.getInitialInfo10() != null ? this.getInitialInfo10() : "") +
				 (this.getInitialInfo11() != null ? this.getInitialInfo11() : "") +
				 (this.getInitialInfo12() != null ? this.getInitialInfo12() : "") +
				 (this.getInitialInfo13() != null ? this.getInitialInfo13() : "") +
				 (this.getInitialInfo14() != null ? this.getInitialInfo14() : "") +
				 (this.getInitialInfo15() != null ? this.getInitialInfo15() : "") +
				 (this.getInitialInfo16() != null ? this.getInitialInfo16() : "") +
				 (this.getInitialInfo17() != null ? this.getInitialInfo17() : "");
		return initialInfo;
	}

	public void setInitialInfo(String initialInfo) {
		this.initialInfo = initialInfo;
	}

	public String getInitialInfo01() {
		return initialInfo01;
	}

	public void setInitialInfo01(String initialInfo01) {
		this.initialInfo01 = initialInfo01;
	}

	public String getInitialInfo02() {
		return initialInfo02;
	}

	public void setInitialInfo02(String initialInfo02) {
		this.initialInfo02 = initialInfo02;
	}

	public String getInitialInfo03() {
		return initialInfo03;
	}

	public void setInitialInfo03(String initialInfo03) {
		this.initialInfo03 = initialInfo03;
	}

	public String getInitialInfo04() {
		return initialInfo04;
	}

	public void setInitialInfo04(String initialInfo04) {
		this.initialInfo04 = initialInfo04;
	}

	public String getInitialInfo05() {
		return initialInfo05;
	}

	public void setInitialInfo05(String initialInfo05) {
		this.initialInfo05 = initialInfo05;
	}

	public String getInitialInfo06() {
		return initialInfo06;
	}

	public void setInitialInfo06(String initialInfo06) {
		this.initialInfo06 = initialInfo06;
	}

	public String getInitialInfo07() {
		return initialInfo07;
	}

	public void setInitialInfo07(String initialInfo07) {
		this.initialInfo07 = initialInfo07;
	}

	public String getInitialInfo08() {
		return initialInfo08;
	}

	public void setInitialInfo08(String initialInfo08) {
		this.initialInfo08 = initialInfo08;
	}

	public String getInitialInfo09() {
		return initialInfo09;
	}

	public void setInitialInfo09(String initialInfo09) {
		this.initialInfo09 = initialInfo09;
	}

	public String getInitialInfo10() {
		return initialInfo10;
	}

	public void setInitialInfo10(String initialInfo10) {
		this.initialInfo10 = initialInfo10;
	}

	public String getInitialInfo11() {
		return initialInfo11;
	}

	public void setInitialInfo11(String initialInfo11) {
		this.initialInfo11 = initialInfo11;
	}

	public String getInitialInfo12() {
		return initialInfo12;
	}

	public void setInitialInfo12(String initialInfo12) {
		this.initialInfo12 = initialInfo12;
	}

	public String getInitialInfo13() {
		return initialInfo13;
	}

	public void setInitialInfo13(String initialInfo13) {
		this.initialInfo13 = initialInfo13;
	}

	public String getInitialInfo14() {
		return initialInfo14;
	}

	public void setInitialInfo14(String initialInfo14) {
		this.initialInfo14 = initialInfo14;
	}

	public String getInitialInfo15() {
		return initialInfo15;
	}

	public void setInitialInfo15(String initialInfo15) {
		this.initialInfo15 = initialInfo15;
	}

	public String getInitialInfo16() {
		return initialInfo16;
	}

	public void setInitialInfo16(String initialInfo16) {
		this.initialInfo16 = initialInfo16;
	}

	public String getInitialInfo17() {
		return initialInfo17;
	}

	public void setInitialInfo17(String initialInfo17) {
		this.initialInfo17 = initialInfo17;
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
