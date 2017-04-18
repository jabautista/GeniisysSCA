/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.gipi.entity;


/**
 * The Class GIPIPicture.
 */
public class GIPIPicture extends FileEntity{

	/** The policy id. */
	private int policyId;
	
	/** The pol file name. */
	private String polFileName;
	
	/** The arc ext data. */
	private String arcExtData;
	
	/**
	 * Instantiates a new gIPI picture.
	 */
	public GIPIPicture() {

	}

	/**
	 * Instantiates a new gIPI picture.
	 * 
	 * @param policyId the policy id
	 * @param polFileName the pol file name
	 * @param arcExtData the arc ext data
	 */
	public GIPIPicture(int policyId, String polFileName, String arcExtData) {
		super();
		this.policyId = policyId;
		this.polFileName = polFileName;
		this.arcExtData = arcExtData;
	}

	/**
	 * Gets the policy id.
	 * 
	 * @return the policy id
	 */
	public int getPolicyId() {
		return policyId;
	}

	/**
	 * Sets the policy id.
	 * 
	 * @param policyId the new policy id
	 */
	public void setPolicyId(int policyId) {
		this.policyId = policyId;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.entity.FileEntity#getPolFileName()
	 */
	@Override
	public String getPolFileName() {
		return polFileName;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.entity.FileEntity#setPolFileName(java.lang.String)
	 */
	@Override
	public void setPolFileName(String polFileName) {
		this.polFileName = polFileName;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.entity.FileEntity#getArcExtData()
	 */
	@Override
	public String getArcExtData() {
		return arcExtData;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.entity.FileEntity#setArcExtData(java.lang.String)
	 */
	@Override
	public void setArcExtData(String arcExtData) {
		this.arcExtData = arcExtData;
	}
	
}
