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
 * The Class GIACModules.
 */
public class GIACModules extends BaseEntity{
	
	/** The module id. */
	private Integer moduleId;
	/** The moduleName. */
	private String moduleName;
	/** The scrnRepName. */
	private String scrnRepName;
	/** The scrnRepTag. */
	private String scrnRepTag;
	/** The genType. */
	private String genType;
	/** The remarks. */
	private String remarks;
	/** The modEntTag. */
	private String modEntTag;
	/** The funcTag. */
	private String funcTag;
	
	public GIACModules(){
		
	}

	/**
	 * @return the moduleId
	 */
	public Integer getModuleId() {
		return moduleId;
	}

	/**
	 * @param moduleId the moduleId to set
	 */
	public void setModuleId(Integer moduleId) {
		this.moduleId = moduleId;
	}

	/**
	 * @return the moduleName
	 */
	public String getModuleName() {
		return moduleName;
	}

	/**
	 * @param moduleName the moduleName to set
	 */
	public void setModuleName(String moduleName) {
		this.moduleName = moduleName;
	}

	/**
	 * @return the scrnRepName
	 */
	public String getScrnRepName() {
		return scrnRepName;
	}

	/**
	 * @param scrnRepName the scrnRepName to set
	 */
	public void setScrnRepName(String scrnRepName) {
		this.scrnRepName = scrnRepName;
	}

	/**
	 * @return the scrnRepTag
	 */
	public String getScrnRepTag() {
		return scrnRepTag;
	}

	/**
	 * @param scrnRepTag the scrnRepTag to set
	 */
	public void setScrnRepTag(String scrnRepTag) {
		this.scrnRepTag = scrnRepTag;
	}

	/**
	 * @return the genType
	 */
	public String getGenType() {
		return genType;
	}

	/**
	 * @param genType the genType to set
	 */
	public void setGenType(String genType) {
		this.genType = genType;
	}

	/**
	 * @return the remarks
	 */
	public String getRemarks() {
		return remarks;
	}

	/**
	 * @param remarks the remarks to set
	 */
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	/**
	 * @return the modEntTag
	 */
	public String getModEntTag() {
		return modEntTag;
	}

	/**
	 * @param modEntTag the modEntTag to set
	 */
	public void setModEntTag(String modEntTag) {
		this.modEntTag = modEntTag;
	}

	/**
	 * @return the funcTag
	 */
	public String getFuncTag() {
		return funcTag;
	}

	/**
	 * @param funcTag the funcTag to set
	 */
	public void setFuncTag(String funcTag) {
		this.funcTag = funcTag;
	}

}
