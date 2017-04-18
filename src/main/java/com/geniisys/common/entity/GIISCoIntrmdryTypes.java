/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;


public class GIISCoIntrmdryTypes extends BaseEntity {

	private String issCd;
	private String coIntmType;
	private String typeName;
	private String remarks;
	
	public String getIssCd() {
		return issCd;
	}
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}
	public String getCoIntmType() {
		return coIntmType;
	}
	public void setCoIntmType(String coIntmType) {
		this.coIntmType = coIntmType;
	}
	public String getTypeName() {
		return typeName;
	}
	public void setTypeName(String typeName) {
		this.typeName = typeName;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}	
}