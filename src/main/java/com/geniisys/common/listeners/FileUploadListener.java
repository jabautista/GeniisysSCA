/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.listeners;

import org.apache.commons.fileupload.ProgressListener;


/**
 * The listener interface for receiving fileUpload events.
 * The class that is interested in processing a fileUpload
 * event implements this interface, and the object created
 * with that class is registered with a component using the
 * component's <code>addFileUploadListener<code> method. When
 * the fileUpload event occurs, that object's appropriate
 * method is invoked.
 * 
 * @see FileUploadEvent
 */
public class FileUploadListener implements ProgressListener {
    
	/** The bytes read. */
	private volatile long bytesRead;
    
    /** The content length. */
    private volatile long contentLength;
    
    /** The item. */
    private volatile long item;
    
    /**
     * Instantiates a new file upload listener.
     */
    public FileUploadListener() {
        bytesRead = 0;
        contentLength = 0;
        item = 0;
    }
    
    /* (non-Javadoc)
     * @see org.apache.commons.fileupload.ProgressListener#update(long, long, int)
     */
    public void update(long i_bytesRead, long i_contentLength, int i_item) {
        bytesRead = i_bytesRead;
        contentLength = i_contentLength;
        item = i_item;
    }
    
    /**
     * Gets the bytes read.
     * 
     * @return the bytes read
     */
    public long getBytesRead() {
        return bytesRead;
    }
    
    /**
     * Gets the content length.
     * 
     * @return the content length
     */
    public long getContentLength() {
        return contentLength;
    }
    
    /**
     * Gets the item.
     * 
     * @return the item
     */
    public long getItem() {
        return item;
    }
}