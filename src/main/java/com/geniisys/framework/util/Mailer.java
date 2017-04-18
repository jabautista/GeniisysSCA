package com.geniisys.framework.util;

import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.mail.Address;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import org.apache.log4j.Logger;

public class Mailer {

	private Logger logger = Logger.getLogger(Mailer.class);
	private String hostName;
	private String authUser;
	private String authPassword;
	private String auth;
	private String port;
	private String timeout;
	private String emailMsgText;
	private String emailSubjectText;
	private String emailFromAddress;
	private List<String> attachments;
	private List<String> recepientList;
	
	/**
	 * Send mail.
	 * 
	 * @param recipients the recipients
	 * @throws MessagingException the messaging exception
	 */
	public void sendMail(String recipients[]) throws MessagingException {
		boolean debug = false;

		// Set the host smtp address
		Properties props = new Properties();
		props.put("mail.smtp.host", getHostName());
		props.put("mail.smtp.user", getAuthUser());
		props.put("mail.smtp.password", Decoder.decode(getAuthPassword()));
		props.put("mail.smtp.auth", getAuth());
		props.put("mail.smtp.port", getPort());
		props.put("mail.smtp.socketFactory.port", getPort());
		props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
		props.put("mail.smtp.socketFactory.fallback", "false");
		props.put("mail.smtp.connectiontimeout", getTimeout());
		props.put("mail.smtp.timeout", getTimeout());
		props.put("mail.smtp.writetimeout", getTimeout());
		props.put("mail.smtp.starttls.enable", "false");

		Authenticator auth = new SMTPAuthenticator();
		Session session = Session.getDefaultInstance(props, auth);
/*		Session session = Session.getDefaultInstance(props, new Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication(){
				return new PasswordAuthentication(getAuthUser(), Decoder.decode(getAuthPassword()));
			}
		});
*/
		session.setDebug(debug);

		// create a message
		Message msg = new MimeMessage(session);
		
		try {
			// set the from and to address
			InternetAddress addressFrom = new InternetAddress(getEmailFromAddress());
			msg.setFrom(addressFrom);
	
			logger.info("Email address: " + recipients[0]);
			InternetAddress[] addressTo = new InternetAddress[recipients.length];
			for (int i = 0; i < recipients.length; i++) {
				addressTo[i] = new InternetAddress(recipients[i]);
			}
			msg.setRecipients(Message.RecipientType.TO, addressTo);
	
			// Setting the Subject and Content Type
			msg.setSubject(getEmailSubjectText());
			msg.setContent(getEmailMsgText(), "text/plain");
			Transport.send(msg);
		} catch(MessagingException e){
			throw e;
		}
	}

	/**
	 * Send email with attachments
	 * @author andrew robes
	 * @date 08.23.2011
	 * @param recipients
	 * @throws MessagingException
	 */
	public void sendMailWithAttachments() throws MessagingException {
		Properties props = new Properties();
		props.put("mail.smtp.host", getHostName());
		props.put("mail.smtp.user", getAuthUser());
		props.put("mail.smtp.password", Decoder.decode(getAuthPassword()));
		props.put("mail.smtp.auth", getAuth());
		props.put("mail.smtp.port", getPort());
		props.put("mail.smtp.socketFactory.port", getPort());
		props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
		props.put("mail.smtp.socketFactory.fallback", "false");
		props.put("mail.smtp.connectiontimeout", getTimeout());
		props.put("mail.smtp.timeout", getTimeout());
		props.put("mail.smtp.writetimeout", getTimeout());
		props.put("mail.smtp.starttls.enable", "false");
		
		Authenticator auth = new SMTPAuthenticator();
        Session session = Session.getDefaultInstance(props, auth);
        
        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(getEmailFromAddress()));
            List<String> recipients = getRecepientList();
    		logger.info("Email address: " + recipients);
    		Address[] addressTo = new InternetAddress[recipients.size()];
    		for (int i = 0; i < recipients.size(); i++) {
    			addressTo[i] = new InternetAddress(recipients.get(i));
    		}
            message.setRecipients(Message.RecipientType.TO, addressTo);
            message.setSubject(getEmailSubjectText());
            message.setSentDate(new Date());
            
            // Set the email message text.
            MimeBodyPart messagePart = new MimeBodyPart();
            messagePart.setText(getEmailMsgText());
            
            Multipart multipart = new MimeMultipart();            
            multipart.addBodyPart(messagePart);

            // Set the email attachment file
            MimeBodyPart attachmentPart = null;
            
            List<String> attachments = getAttachments();
            
            if(attachments != null) {
	            for(String filename : attachments){
	            	attachmentPart = new MimeBodyPart();
		            FileDataSource fileDataSource = new FileDataSource(filename) {
		                @Override
		                public String getContentType() {
		                    return "application/octet-stream";
		                }
		            };
		            
		            attachmentPart.setDataHandler(new DataHandler(fileDataSource));
		            attachmentPart.setFileName(filename.substring(filename.lastIndexOf("/")+1, filename.length()));
		            multipart.addBodyPart(attachmentPart);
	            }
            }
	            
            message.setContent(multipart);
            
            Transport.send(message);
        } catch (MessagingException e) {
            throw e;
        }		
	}	
	
	/**
	 * SimpleAuthenticator is used to do simple authentication when the SMTP
	 * server requires it.
	 */
	private class SMTPAuthenticator extends javax.mail.Authenticator {

		/* (non-Javadoc)
		 * @see javax.mail.Authenticator#getPasswordAuthentication()
		 */
		@Override
		public PasswordAuthentication getPasswordAuthentication() {
			logger.info("AUTH USER: " + getAuthUser());
			//logger.info("AUTH PW: " + Decoder.decode(getAuthPassword()));
			return new PasswordAuthentication(getAuthUser(), Decoder.decode(getAuthPassword()));
		}
	}
	
	/**
	 * Gets the host name.
	 * 
	 * @return the host name
	 */
	public String getHostName() {
		return hostName;
	}

	/**
	 * Sets the host name.
	 * 
	 * @param hostName the new host name
	 */
	public void setHostName(String hostName) {
		this.hostName = hostName;
	}

	/**
	 * Gets the auth user.
	 * 
	 * @return the auth user
	 */
	public String getAuthUser() {
		return authUser;
	}

	/**
	 * Sets the auth user.
	 * 
	 * @param authUser the new auth user
	 */
	public void setAuthUser(String authUser) {
		this.authUser = authUser;
	}

	/**
	 * Gets the auth password.
	 * 
	 * @return the auth password
	 */
	public String getAuthPassword() {
		return authPassword;
	}

	/**
	 * Sets the auth password.
	 * 
	 * @param authPassword the new auth password
	 */
	public void setAuthPassword(String authPassword) {
		this.authPassword = authPassword;
	}

	/**
	 * Gets the email msg text.
	 * 
	 * @return the email msg text
	 */
	public String getEmailMsgText() {
		return emailMsgText;
	}

	/**
	 * Sets the email msg text.
	 * 
	 * @param emailMsgText the new email msg text
	 */
	public void setEmailMsgText(String emailMsgText) {
		this.emailMsgText = emailMsgText;
	}

	/**
	 * Gets the email subject text.
	 * 
	 * @return the email subject text
	 */
	public String getEmailSubjectText() {
		return emailSubjectText;
	}

	/**
	 * Sets the email subject text.
	 * 
	 * @param emailSubjectText the new email subject text
	 */
	public void setEmailSubjectText(String emailSubjectText) {
		this.emailSubjectText = emailSubjectText;
	}

	/**
	 * Gets the email from address.
	 * 
	 * @return the email from address
	 */
	public String getEmailFromAddress() {
		return emailFromAddress;
	}

	/**
	 * Sets the email from address.
	 * 
	 * @param emailFromAddress the new email from address
	 */
	public void setEmailFromAddress(String emailFromAddress) {
		this.emailFromAddress = emailFromAddress;
	}

	/**
	 * Gets the auth.
	 * 
	 * @return the auth
	 */
	public String getAuth() {
		return auth;
	}

	/**
	 * Sets the auth.
	 * 
	 * @param auth the new auth
	 */
	public void setAuth(String auth) {
		this.auth = auth;
	}

	public void setAttachments(List<String> attachments) {
		this.attachments = attachments;
	}

	public List<String> getAttachments() {
		return attachments;
	}

	public void setRecepientList(List<String> recepientList) {
		this.recepientList = recepientList;
	}

	public List<String> getRecepientList() {
		return recepientList;
	}

	public String getPort() {
		return port;
	}

	public void setPort(String port) {
		this.port = port;
	}

	public String getTimeout() {
		Integer t = 0;
		if(timeout != null){
			t = Integer.parseInt(timeout) * 1000;
		}
		return t.toString();
	}

	public void setTimeout(String timeout) {
		this.timeout = timeout;
	}

}