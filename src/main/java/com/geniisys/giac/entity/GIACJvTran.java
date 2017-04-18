/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.giac.entity;

import com.geniisys.giis.entity.BaseEntity;

/**
 * The Class GIACBank.
 */
public class GIACJvTran extends BaseEntity {
	
	private String jvTranCd;	
	private String jvTranDesc;
	private String jvTranTag;
	private String dspJvTranTag;
	private String remarks;
	
	public GIACJvTran (){
		
	}

	public String getJvTranCd() {
		return jvTranCd;
	}
	
	public void setJvTranCd(String jvTranCd) {
		this.jvTranCd = jvTranCd;
	}

	public String getJvTranDesc() {
		return jvTranDesc;
	}

	public void setJvTranDesc(String jvTranDesc) {
		this.jvTranDesc = jvTranDesc;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getJvTranTag() {
		return jvTranTag;
	}

	public void setJvTranTag(String jvTranTag) {
		this.jvTranTag = jvTranTag;
	}

	public String getDspJvTranTag() {
		if(this.jvTranTag != null) {
			if(this.jvTranTag.equals("C")){
				return "Cash";
			} else if(this.jvTranTag.equals("NC")){
				return "Non-Cash";
			} else {
				return jvTranTag;
			}
		} else {
			return jvTranTag;
		}
	}

	public void setDspJvTranTag(String dspJvTranTag){
		this.dspJvTranTag = dspJvTranTag;
	}
	
}
