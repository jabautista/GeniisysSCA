/**************************************************/
/**
 Project: Geniisys
 Package: com.geniisys.giis.entity;
 File Name: GIISPerilClass.java
 Author: Computer Professional Inc
 Created By: Ronnie
 Created Date: 10.16.2012
 */

package com.geniisys.giis.entity;

import java.text.SimpleDateFormat;

import com.geniisys.framework.util.BaseEntity;

public class GIISPerilClass extends BaseEntity {
	private String classCd;
	private String classDesc;
	private String remarks;
	private String cpiRecNo;
	private String cpiBranchCd;
	private String lineName;
	private String perilSname;
	private String perilName;
	private String lineCd;
	private String perilCd;
	@SuppressWarnings("unused")
	private String sdfLastUpdate;

	public GIISPerilClass() {
		super();
	}

	public GIISPerilClass(String classCd, String classDesc, String remarks,
			String cpiRecNo, String cpiBranchCd, String lineName,
			String perilSname, String perilName, String lineCd, String perilCd) {
		super();
		this.classCd = classCd;
		this.classDesc = classDesc;
		this.remarks = remarks;
		this.cpiRecNo = cpiRecNo;
		this.cpiBranchCd = cpiBranchCd;
		this.lineName = lineName;
		this.perilSname = perilSname;
		this.perilName = perilName;
		this.lineCd = lineCd;
		this.perilCd = perilCd;
	}

	public String getClassCd() {
		return classCd;
	}

	public void setClassCd(String classCd) {
		this.classCd = classCd;
	}

	public String getClassDesc() {
		return classDesc;
	}

	public void setClassDesc(String classDesc) {
		this.classDesc = classDesc;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getCpiRecNo() {
		return cpiRecNo;
	}

	public void setCpiRecNo(String cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}

	public String getCpiBranchCd() {
		return cpiBranchCd;
	}

	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}

	public String getLineName() {
		return lineName;
	}

	public void setLineName(String lineName) {
		this.lineName = lineName;
	}

	public String getPerilSname() {
		return perilSname;
	}

	public void setPerilSname(String perilSname) {
		this.perilSname = perilSname;
	}

	public String getPerilName() {
		return perilName;
	}

	public void setPerilName(String perilName) {
		this.perilName = perilName;
	}

	public String getLineCd() {
		return lineCd;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	public String getPerilCd() {
		return perilCd;
	}

	public void setPerilCd(String perilCd) {
		this.perilCd = perilCd;
	}

	/**
	 * @return the sdfLastUpdate
	 */
	public String getSdfLastUpdate() {
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss aa");
		if(this.getLastUpdate() != null){
			return sdf.format(this.getLastUpdate()).toString();
		} else {
			return null;
		}
	}

	/**
	 * @param sdfLastUpdate the sdfLastUpdate to set
	 */
	public void setSdfLastUpdate(String sdfLastUpdate) {
		this.sdfLastUpdate = sdfLastUpdate;
	}
}
