<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="confirmationMainDiv">
	<div id="confirmationDiv" name="statusDiv" style="margin-top: 10px; height: 85px; width: 99.5%;" class="sectionDiv">
		<div style='margin-top: 5px; float: left; width: 100%'>
			<span style='float: left; padding: 5px 8px 8px 8px; width: 10%; height: 40px;'>
				<img src='${pageContext.request.contextPath}/images/message/confirm.png'>
			</span>
			<label id="lblMessage" style='width: 80%; float: left; margin-top: 5px; line-height: 17px; font-family: Verdana; font-size: 11px;'></label>
		</div>
	</div>
	<div align="center">
		<input type="button" class="button" id="btnStatLoss" value="Loss Only" style="width: 100px;margin-top: 10px; margin-bottom: 10px;">
		<input type="button" class="button" id="btnStatExpense" value="Expense Only" style="width: 100px;margin-top: 10px; margin-bottom: 10px;">
		<input type="button" class="button" id="btnStatBoth" value="Both" style="width: 100px;margin-top: 10px; margin-bottom: 10px;">		
		<input type="button" class="button" id="btnStatCancel" value="Cancel" style="width: 100px;margin-top: 10px; margin-bottom: 10px;">
	</div>
</div>
<script type="text/javascript">
	$("lblMessage").innerHTML = overlayGICLS024Confirmation.message;
	
	function getMessageStat(stat){
		var message = "";
		if(stat == "AP"){
			message = "Peril was sucessfully activated and a new distribution record has been created.";
		} else if(stat == "DN"){
			message = "Peril was sucessfully denied.";
		} else if(stat == "CP"){
			message = "Peril was sucessfully closed.";
		} else if(stat == "CP"){
			message = "Peril was sucessfully withdrawn.";
		}
		return message; 
	}
	
	$("btnStatLoss").observe("click", function(){
		var message = getMessageStat(overlayGICLS024UpdateStatus.stat);
		
		overlayGICLS024UpdateStatus.updateStatus(overlayGICLS024UpdateStatus.stat, "", message);
		overlayGICLS024Confirmation.close();
		delete overlayGICLS024Confirmation;
		overlayGICLS024UpdateStatus.close();
		delete overlayGICLS024UpdateStatus;
	});
	
	$("btnStatExpense").observe("click", function(){
		var message = getMessageStat(overlayGICLS024UpdateStatus.stat);
		
		overlayGICLS024UpdateStatus.updateStatus("", overlayGICLS024UpdateStatus.stat, message);
		overlayGICLS024Confirmation.close();
		delete overlayGICLS024Confirmation;
		overlayGICLS024UpdateStatus.close();
		delete overlayGICLS024UpdateStatus;
	});
	
	$("btnStatBoth").observe("click", function(){
		var message = getMessageStat(overlayGICLS024UpdateStatus.stat);
		
		overlayGICLS024UpdateStatus.updateStatus(overlayGICLS024UpdateStatus.stat, overlayGICLS024UpdateStatus.stat, message);
		overlayGICLS024Confirmation.close();
		delete overlayGICLS024Confirmation;
		overlayGICLS024UpdateStatus.close();
		delete overlayGICLS024UpdateStatus;
	});
	
	$("btnStatCancel").observe("click", function(){
		overlayGICLS024Confirmation.close();
		delete overlayGICLS024Confirmation;
	});
</script>