/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;




/**
 * The Class GIISPolicyType.
 */
public class GIISPolicyType extends BaseEntity{

	/** The type desc. */
	private String typeDesc;
	
	/** The type cd. */
	private String typeCd;
	
	private String lineCd;
	private String remarks;
	private String dummyLineCd;
	
	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public GIISPolicyType(){
		
	}
	
	public String getLineCd() {
		return lineCd;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	/**
	 * Gets the type desc.
	 * 
	 * @return the type desc
	 */
	public String getTypeDesc() {
		return typeDesc;
	}
	
	/**
	 * Sets the type desc.
	 * 
	 * @param typeDesc the new type desc
	 */
	public void setTypeDesc(String typeDesc) {
		this.typeDesc = typeDesc;
	}
	
	/**
	 * Gets the type cd.
	 * 
	 * @return the type cd
	 */
	public String getTypeCd() {
		return typeCd;
	}
	
	/**
	 * Sets the type cd.
	 * 
	 * @param typeCd the new type cd
	 */
	public void setTypeCd(String typeCd) {
		this.typeCd = typeCd;
	}

	public String getDummyLineCd() {
		return dummyLineCd;
	}

	public void setDummyLineCd(String dummyLineCd) {
		this.dummyLineCd = dummyLineCd;
	}

}
