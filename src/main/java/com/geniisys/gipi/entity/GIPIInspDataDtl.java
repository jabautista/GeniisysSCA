package com.geniisys.gipi.entity;

import com.geniisys.framework.util.BaseEntity;

public class GIPIInspDataDtl extends BaseEntity{

	private int inspNo;
	private String fiProRemarks;
	private String fiStationRemarks;
	private String secSysRemarks;
	private String genSurrRemarks;
	private String maintDtlRemarks;
	private String elecInstRemarks;
	private String hkRemarks;
	
	public GIPIInspDataDtl() {
		
	}

	public GIPIInspDataDtl(int inspNo, String fiProRemarks,
			String fiStationRemarks, String secSysRemarks,
			String genSurrRemarks, String maintDtlRemarks,
			String elecInstRemarks, String hkRemarks) {
		this.inspNo = inspNo;
		this.fiProRemarks = fiProRemarks;
		this.fiStationRemarks = fiStationRemarks;
		this.secSysRemarks = secSysRemarks;
		this.genSurrRemarks = genSurrRemarks;
		this.maintDtlRemarks = maintDtlRemarks;
		this.elecInstRemarks = elecInstRemarks;
		this.hkRemarks = hkRemarks;
	}

	public int getInspNo() {
		return inspNo;
	}

	public void setInspNo(int inspNo) {
		this.inspNo = inspNo;
	}

	public String getFiProRemarks() {
		return fiProRemarks;
	}

	public void setFiProRemarks(String fiProRemarks) {
		this.fiProRemarks = fiProRemarks;
	}

	public String getFiStationRemarks() {
		return fiStationRemarks;
	}

	public void setFiStationRemarks(String fiStationRemarks) {
		this.fiStationRemarks = fiStationRemarks;
	}

	public String getSecSysRemarks() {
		return secSysRemarks;
	}

	public void setSecSysRemarks(String secSysRemarks) {
		this.secSysRemarks = secSysRemarks;
	}

	public String getGenSurrRemarks() {
		return genSurrRemarks;
	}

	public void setGenSurrRemarks(String genSurrRemarks) {
		this.genSurrRemarks = genSurrRemarks;
	}

	public String getMaintDtlRemarks() {
		return maintDtlRemarks;
	}

	public void setMaintDtlRemarks(String maintDtlRemarks) {
		this.maintDtlRemarks = maintDtlRemarks;
	}

	public String getElecInstRemarks() {
		return elecInstRemarks;
	}

	public void setElecInstRemarks(String elecInstRemarks) {
		this.elecInstRemarks = elecInstRemarks;
	}

	public String getHkRemarks() {
		return hkRemarks;
	}

	public void setHkRemarks(String hkRemarks) {
		this.hkRemarks = hkRemarks;
	}
	
}
