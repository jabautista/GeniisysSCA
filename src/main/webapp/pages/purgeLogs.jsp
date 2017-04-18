<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="purgeLogsMainDiv" style="margin-bottom: 50px; float: left; width: 100%;">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Purge Logs</label>
	   		<span class="refreshers" style="margin-top: 0;">
	   			<label id="lblShowPurgeLogs" name="gro" style="margin-left: 5px;">Hide</label>
	   			<label id="reloadForm" name="reloadForm">Reload Form</label>
	   		</span>
	   	</div>
	</div>
	<div id="purgeLogsDiv" class="sectionDiv" align="center">
		<div id="purgeLogsOptionDiv" style="margin: 50px 0 30px 20px; width: 600px; border: 1px solid #E0E0E0; -webkit-border-radius: 5px;	-moz-border-radius: 5px; border-radius: 5px;">		
			<table style="margin: 20px 20px 30px 20px;">
				<tr>
					<td colspan="4">
						<label style="margin-top: 5px; margin-left: 0; margin-bottom: 20px;"><input type="radio" id="rdoPurge" name="purgeOption" checked="checked">Purge</label>
						<label style="margin-top: 5px; margin-left: 30px; margin-bottom: 20px;"><input type="radio" id="rdoMove" name="purgeOption">Move</label>
						<label style="margin-top: 5px; margin-left: 30px; margin-bottom: 20px;"><input type="radio" id="rdoMovePurge" name="purgeOption">Move/Purge</label>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">From</td>
					<td class="leftAligned">
						<div style="float: left; margin-top: 2px; width: 204px; height: 19px; margin-right:3px; border: 1px solid gray;" class="required">
					    	<input style="margin-top: 0; width: 179px; border: none; float: left; height: 11px;" id="fromDate" name="fromDate" type="text" value="${from}" readonly="readonly" tabindex="" class="required"/>
					    	<img name="imgFromDate" id="imgFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('fromDate'),this, null);" alt="From" />
						</div>
					</td>
					<td class="rightAligned" width="50px">To</td>
					<td class="leftAligned">
						<div style="float: left; margin-top: 2px; width: 204px; height: 19px; margin-right:3px; border: 1px solid gray;" class="required">
					    	<input style="margin-top: 0; width: 179px; border: none; float: left; height: 11px;" id="toDate" name="toDate" type="text" value="${to}" readonly="readonly" tabindex="" class="required"/>
					    	<img name="imgToDate" id="imgToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('toDate'),this, null);" alt="To" />
						</div>				
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Destination</td>
					<td class="leftAligned" colspan="3">
						<input type="text" style="width: 398px;" class="required">
						<input type="button" value="Browse">
					</td>				
				</tr>				
			</table>
		</div>
		<div align="center" style="margin-bottom: 30px;">
			<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel">
			<input type="button" class="button" id="btnExecute" name="btnExecute" value="Execute" style="width: 80px;">		
		</div>
	</div>	
</div>

<script type="text/javascript">
	setDocumentTitle("Purge Logs");
	initializeAccordion();
</script>