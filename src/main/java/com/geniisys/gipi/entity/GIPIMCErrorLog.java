/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.entity;

/**
 * The Class GIPIMCErrorLog.
 */
public class GIPIMCErrorLog extends GIPIMCUpload {
	private String remarks;
	private String dspLastUpdate;

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getDspLastUpdate() {
		return dspLastUpdate;
	}

	public void setDspLastUpdate(String dspLastUpdate) {
		this.dspLastUpdate = dspLastUpdate;
	}
	
}
