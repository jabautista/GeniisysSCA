package com.geniisys.giis.entity;

public class GIISMcDepreciationPeril extends BaseEntity {
	
	private Integer 	id;
	private String  	lineCd;
	private String  	lineName;	
	private Integer  	perilCd;	
	private String 	    perilName;		
	
	public GIISMcDepreciationPeril(){
		super();
	}

	public GIISMcDepreciationPeril(Integer id, String lineCd, String lineName,Integer perilCd, String perilName) {
		super();
		this.setId(id);
		this.setLineCd(lineCd);
		this.setLineCd(lineName);
		this.setPerilCd(perilCd);		
		this.setPerilName(perilName);		
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getLineCd() {
		return lineCd;
	}

	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	public Integer getPerilCd() {
		return perilCd;
	}

	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}

	public String getPerilName() {
		return perilName;
	}

	public void setPerilName(String perilName) {
		this.perilName = perilName;
	}

	public String getLineName() {
		return lineName;
	}

	public void setLineName(String lineName) {
		this.lineName = lineName;
	}

}
