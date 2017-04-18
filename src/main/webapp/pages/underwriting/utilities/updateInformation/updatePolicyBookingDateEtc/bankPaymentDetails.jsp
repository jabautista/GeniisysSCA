<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div style="width: 99.5%; margin-top: 5px;">
	<div class="sectionDiv">
		<table align="center" style="margin: 15px auto;">
			<tr>
				<td style="padding-right: 5px;"><label for="txtNbtAcctIssCd">Bank Reference No.</label></td>
				<td>
					<input type="text" id="txtNbtAcctIssCd" style="width: 65px; float: left; text-align: right;" readonly="readonly"/>
				</td>
				<td>
					<input type="text" id="txtNbtBranchCd" style="width: 65px; float: left; text-align: right;" readonly="readonly"/>
				</td>
				<td><input type="text" id="txtDspRefNo" style="width: 100px; text-align: right;" readonly="readonly"/></td>
				<td><input type="text" id="txtDspModNo" style="width: 60px; text-align: right;" readonly="readonly"/></td>
			</tr>
		</table>
	</div>
	<div style="float : none; text-align: center;">
		<input type="button" class="button" id="btnOk" value="Ok" style="width: 100px; margin-top: 10px;"/>
	</div>
</div>
<script>
	try {
		
		$("txtNbtAcctIssCd").value = objGIPIS156.nbtAcctIssCd;
		$("txtNbtBranchCd").value = objGIPIS156.nbtBranchCd;
		$("txtDspRefNo").value = objGIPIS156.dspRefNo;
		$("txtDspModNo").value = objGIPIS156.dspModNo;
		
		/* function getGIPIS156AcctIssCdLov(){
			onLOV = true;
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGIPIS156AcctIssCdLov",
					//searchString : $("txtFreeText").value,
					page : 1
				},
				title : "Issue Sources",
				width : 480,
				height : 386,
				columnModel : [
				    {
						id : "issCd",
						title : "Issue Code",
						width : '100px'
					},
					{
						id : "acctIssCd",
						title : "Acct. Issue Code",
						width : '100px',
						align : 'right',
						titleAlign: 'right'
					},
					{
						id : "issName",
						title : "Issue Name",
						width : '263px'
					} 
				],
				draggable : true,
				autoSelectOneRecord: true,
				//filterText:  $("txtFreeText").value,
				onSelect : function(row) {
					$("txtBookingYrMnth").value = row.bookingYear + " - " + row.bookingMth;
					onLOV = false;
					objGIPIS156.changeTag = true;
				},
				onCancel : function () {
					onLOV = false;
					$("txtBookingYrMnth").focus();
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtBookingYrMnth");
					onLOV = false;
				}
			});
		} */
		
		$("btnOk").observe("click", function(){
			overlayBankPaymentDetails.close();
			delete overlayBankPaymentDetails;
		});
		
	} catch (e) {
		showMessageBox("Error in Bank Payment Details " + e, imgMessage.ERROR);
	}
</script>