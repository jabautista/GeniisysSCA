/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.exceptions;


/**
 * The Class UploadSizeLimitExceededException.
 */
public class UploadSizeLimitExceededException extends Exception {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -3651254676683160955L;

	/**
	 * Instantiates a new upload size limit exceeded exception.
	 * 
	 * @param message the message
	 */
	public UploadSizeLimitExceededException(String message) {
		super(message);
	}
	
}
