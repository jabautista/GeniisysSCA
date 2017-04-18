package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIISPackageBenefit extends BaseEntity{

	private String packBenCd;
	private String packageCd;
	private String lineCd;
	private String sublineCd;
	
	public String getPackBenCd() {
		return packBenCd;
	}
	public void setPackBenCd(String packBenCd) {
		this.packBenCd = packBenCd;
	}
	public String getPackageCd() {
		return packageCd;
	}
	public void setPackageCd(String packageCd) {
		this.packageCd = packageCd;
	}
	/**
	 * @return the lineCd
	 */
	public String getLineCd() {
		return lineCd;
	}
	/**
	 * @param lineCd the lineCd to set
	 */
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	/**
	 * @return the sublineCd
	 */
	public String getSublineCd() {
		return sublineCd;
	}
	/**
	 * @param sublineCd the sublineCd to set
	 */
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}
	
}
