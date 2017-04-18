<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-Control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
		<label id="lblPkgParListSubPage">Package PAR Policy</label>
		<span class="refreshers" style="margin-top: 0;">
			<label id="packParPolicy" name="gro" style="margin-left: 5px;">Hide</label>
		</span>
	</div>
</div>
<div class="sectionDiv" id="packageParPolicyDiv">
	<div id="packageParPolicy" name="packageParPolicy" style="width : 100%;">
		<div style="margin : 10px;" id="packageParPolicyTable" name="packageParPolicyTable">
			<div class="tableHeader">
				<label style="width: 330px; text-align: left; margin-left: 5px;">PAR No.</label>
				<label style="width: 200px; text-align: left;">Line Name</label>
				<label style="width: 330px; text-align: left;">Subline Name</label>			
			</div>
			<div id="packageParPolicyTableContainer" class="tableContainer">			
			</div>
		</div>
	</div>
</div>
