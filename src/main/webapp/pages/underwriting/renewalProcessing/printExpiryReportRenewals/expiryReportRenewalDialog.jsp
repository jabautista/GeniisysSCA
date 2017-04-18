<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="renewalDialogMainDiv" style="width: 99.5%; padding-top: 5px; float: left;" align="center">
	<div class="sectionDiv" style="float: left;" id="renewalDialogFormDiv">
		<div id="renewalDialogMainDiv" width="500" style="padding: 5px;">
			<div style="margin-bottom: 15px; margin-top: 15px;"><b>Choose Reason for Renewal</b></div>
			<div style="float: left; width: 45px;">A.</div>
			<div style="width: 450px; float: left; "><label><input type="checkbox" id="withoutChanges" style="margin-right: 10px; margin-bottom: 7px; float: left;">Renew Policy without changes</label></div>
			<div style="float: left; width: 45px; margin-top: 4px;">B.</div>
			<div style="float: left; margin-top: 5px;">
				<label>
					<input type="checkbox" id="withChanges" style="margin-right: 10px; margin-bottom: 5px; float: left;">Renew Policy with changes
				</label>
			</div>
			<div style="float: left; "><input type="text" id="txtWithChanges" style="margin-left: 5px; width: 280px;"></div>
			<div style="float: left; width: 45px; margin-top: 4px;">C.</div>
			<div style="float: left; margin-top: 5px;">
				<label>
					<input type="checkbox" id="others" style="margin-right: 10px; margin-bottom: 5px; float: left;">Others
				</label>
			</div>
			<div style="float: left; "><input type="text" id="txtOthers" style="margin-left: 5px; width: 395px;"></div>
			<div style="float: left; width: 70px; margin-top: 4px; margin-left: 16px; text-align: left;">Remarks</div>
			<div style="float: left; width: 17px; margin-top: 4px; margin-left: 5px; text-align: right;">:</div>
			<div style="float: left; "><textarea style="margin-left: 5px; margin-bottom: 15px; width: 395px;"></textarea></div>
			<div id="buttonsDiv" name="buttonsDiv" style="margin-left: 3px; text-align:center; width: 500px; height: 35px;">
				<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="margin-top: 16px;"/>
				<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel"/>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
try{
	objGiexs006.dialog = "renewal";
	
	$("txtWithChanges").disable();
	$("txtOthers").disable();
	
	$("withoutChanges").observe("change", function(){
		if($("withoutChanges").checked){
			$("withChanges").checked = false;
			$("others").checked = false;
			$("withChanges").disable();
			$("others").disable();
			$("txtWithChanges").disable();
			$("txtOthers").disable();
			$("txtWithChanges").clear();
			$("txtOthers").clear();
		}else{
			$("withChanges").enable();
			$("others").enable();
		}
	});
	
	$("withChanges").observe("change", function(){
		if($("withChanges").checked){
			$("withoutChanges").checked = false;
			$("others").checked = false;
			$("withoutChanges").disable();
			$("others").disable();
			$("txtOthers").disable();
			$("txtOthers").clear();
			$("txtWithChanges").enable();
		}else{
			$("txtWithChanges").disable();
			$("withoutChanges").enable();
			$("others").enable();
		}
	});
	
	$("others").observe("change", function(){
		if($("others").checked){
			$("withoutChanges").checked = false;
			$("withChanges").checked = false;
			$("withoutChanges").disable();
			$("withChanges").disable();
			$("txtWithChanges").disable();
			$("txtWithChanges").clear();
			$("txtOthers").enable();
			$("others").enable();
		}else{
			$("others").enable();
			$("withoutChanges").enable();
			$("withChanges").enable();
			$("txtOthers").disable();
			$("txtWithChanges").disable();
		}
	});

	$("btnCancel").observe("click", function(){
		overlayExpiryReportRenewalDialog.close();
	});
	
	$("btnPrint").observe("click", function(){
		setGiexs006Params();
	});
}catch(e){
	showErrorMessage("expiryReportRenewalDialog page",e);
}
</script>