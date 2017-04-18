package com.geniisys.gipi.pack.entity;

import java.util.List;

import com.geniisys.framework.util.BaseEntity;
import com.geniisys.gipi.entity.GIPIParMortgagee;

public class GIPIPackMortgagee extends BaseEntity{
	
	private Integer parId;
	
	private String parNo;
	
	private List<GIPIParMortgagee> gipiParMortgagees;

	public Integer getParId() {
		return parId;
	}

	public void setParId(Integer parId) {
		this.parId = parId;
	}

	public String getParNo() {
		return parNo;
	}

	public void setParNo(String parNo) {
		this.parNo = parNo;
	}

	public void setGipiParMortgagees(List<GIPIParMortgagee> gipiParMortgagees) {
		this.gipiParMortgagees = gipiParMortgagees;
	}

	public List<GIPIParMortgagee> getGipiParMortgagees() {
		return gipiParMortgagees;
	}

}
