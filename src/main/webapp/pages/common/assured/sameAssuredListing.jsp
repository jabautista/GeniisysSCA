<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="sameAssuredListingMainDiv" name="sameAssuredListingMainDiv" style="float: left; width: 100%;">
<!-- 	<div id="outerDiv" name="outerDiv" style="width: 100%;">
		<div id="innerDiv" name="innerDiv">
			<label>Assured Listing</label>
		</div>
	</div> -->
	
	<div id="sameAssuredListingTable" name="sameAssuredListingTable" class="sectionDiv tableContainer" style="width: 100%; padding: 0; height: 186px;">
		<div id="sameAssuredListingTableDiv" style="margin: 5px;">
			<div class="tableHeader">
				<label style="width: 15%; text-align: right;">Assured No.</label>
				<label style="width: 20%; text-align: left; margin-left: 8px;">Assured Name</label>
				<label style="width: 15%; text-align: left;">Last Name</label>
				<label style="width: 15%; text-align: left;">First Name</label>
				<label style="width: 5%; text-align: left;">MI</label>
				<label style="width: 12%; text-align: left;">Phone No.</label>
				<label style="width: 15%; text-align: left;">Contact Person</label>
			</div>
		</div>
		<div id="sameAssuredListingContainer" name="sameAssuredListingContainer" class="tableContainer" style="font-size: 12px;">
			
		</div>
	</div>
	
	<div id="sameAssuredAddressDiv" name="sameAssuredAddressDiv" class="sectionDiv">
		<table align="center" border="0" style="margin: 10px auto;">
		<tr>
			<td class="rightAligned" style="width: 100px;">
				Mailing Address </td>
			<td class="leftAligned">
				<input type="text" id="mailAddress1" name="mailAddress1" style="width: 210px;" tabindex="20" maxlength="50" value="${assured.mailAddress1}" /></td>
			<td class="rightAligned" style="width: 100px;">
				Billing Address </td>
			<td class="leftAligned">
				<input type="text" id="billAddress1" name="billAddress1" style="width: 210px;" tabindex="24" maxlength="50" value="${assured.billingAddress1}" /></td>
		</tr>
		<tr>
			<td></td>
			<td class="leftAligned">
				<input type="text" id="mailAddress2" name="mailAddress2" style="width: 210px;" tabindex="21" maxlength="50" value="${assured.mailAddress2}" /></td>
			<td></td>
			<td class="leftAligned">
				<input type="text" id="billAddress2" name="billAddress2" style="width: 210px;" tabindex="25" maxlength="50" value="${assured.billingAddress2}" /></td>
		</tr>
		<tr>
			<td></td>
			<td class="leftAligned">
				<input type="text" id="mailAddress3" name="mailAddress3" style="width: 210px;" tabindex="22" maxlength="50" value="${assured.mailAddress3}" />
			<td></td>
			<td class="leftAligned">
				<input type="text" id="billAddress3" name="billAddress3" style="width: 210px;" tabindex="26" maxlength="50" value="${assured.billingAddress3}" /></td>
		</tr>
		<tr>
			<td></td>
		</tr>
	</table>
	</div>
	
	<!-- <div class="buttonsDiv">
		<input type="button" class="button" id="btnSameAssuredOK" name="btnSameAssuredOK" value="OK" style="width: 80px;"/>
		<input type="button" class="button" id="btnSameAssuredCancel" name="btnSameAssuredCancel" value="Cancel" />
	</div> -->
	
	<div class="buttonsDiv">
		${message}
		<!-- <strong>Assured is already existing.  Do you want to create a new record?</strong> --><br/><br/>
		<input type="button" class="button" id="btnSameAssuredYes" name="btnSameAssuredOK" value="Yes" style="width: 80px;"/>
		<input type="button" class="button" id="btnSameAssuredNo" name="btnSameAssuredCancel" value="No" style="width: 80px;"/>
	</div>
	
</div>

<script>
	fillSameAssuredInfo();

	/* $("btnSameAssuredOK").observe("click", function (){
		var id = "";
		var ctr = 0;
		$$("div[name='sameAssuredRow']").each(function (row){
			if (row.hasClassName("selectedRow")){
				id = row.id.replace("row", "");
				ctr++;
			}
		});

		if (ctr == 0){
			showMessageBox("Please select an assured.");
		} else {
			$("assuredNo").value = id;
			maintainAssured("assuredListingMainDiv", id);
			Modalbox.hide();
		}
	}); */
	
	/* $("btnSameAssuredCancel").observe("click", function (){
		Modalbox.hide();
	}); */
	
	$("btnSameAssuredYes").observe("click", function (){
		var id = "";
		var ctr = 0;
		$$("div[name='sameAssuredRow']").each(function (row){
			if (row.hasClassName("selectedRow")){
				id = row.id.replace("row", "");
				ctr++;
			}
		});
	
		if (ctr == 0){
			showMessageBox("Please select an assured.");
		} else {
			$("assuredNo").value = id;
			maintainAssured("assuredListingMainDiv", id);
			Modalbox.hide();
			showWaitingMessageBox("This assured with the same mailing address already exists.", imgMessage.INFO, makeNewAssured);
		}
	}); 
	
	$("btnSameAssuredNo").observe("click", function (){
		Modalbox.hide(); //Patrick
		$("assuredNameMaint").clear();
		$("generatedAssuredNo").clear();
		$("industry").clear();
		$("controlType").clear();
		$("referenceCode").clear();
		$("phoneNo").clear();
		$("contactPerson").clear();
		$("tinNo").clear();
		$("noTINReason").clear();
		// var id = '${firstRecord}';
		// maintainAssured("assuredListingMainDiv", id);
	});
	
	function makeNewAssured(){
		$("assuredMaintenanceForm").enable();
		$("generatedAssuredNo").clear();
		$("industry").clear();
		$("controlType").clear();
		$("referenceCode").clear();
		$("phoneNo").clear();
		$("contactPerson").clear();
		$("tinNo").clear();
		$("noTINReason").clear();
	}
	
	function fillSameAssuredInfo(){
		for (var i = 0; i < objectSameAssured.length; i++){
			var assuredDiv = new Element("div");
			assuredDiv.setAttribute("id", "row"+objectSameAssured[i].assdNo);
			assuredDiv.setAttribute("class", "tableRow");
			assuredDiv.setAttribute("name", "sameAssuredRow");

			content = '<label style="width: 15%; text-align: right;">' + objectSameAssured[i].assdNo + '</label>' +
					  '<label style="width: 20%; text-align: left; margin-left: 10px;">' + formatObjAsTableData(objectSameAssured[i].assdName, 20) + '</label>' +
					  '<label style="width: 15%; text-align: left;">' + formatObjAsTableData(objectSameAssured[i].lastName, 12)+ '</label>' +
					  '<label style="width: 15%; text-align: left;">' + formatObjAsTableData(objectSameAssured[i].firstName, 12) + '</label>' +
					  '<label style="width: 4%; text-align: left;">' + formatObjAsTableData(objectSameAssured[i].middleInitial, 3)+ '</label>' + 
					  '<label style="width: 12%; text-align: left; margin-left: 6px;">' + formatObjAsTableData(objectSameAssured[i].phoneNo, 12)+ '</label>' +
					  '<label style="width: 15%; text-align: left;">' + formatObjAsTableData(objectSameAssured[i].contactPersons, 20) + '</label>';
			assuredDiv.update(content);
			addStyleToTableRow(assuredDiv);
			$("sameAssuredListingContainer").insert({bottom :assuredDiv});
		}

	}

	function addStyleToTableRow(tableRow){
		tableRow.observe("mouseover", function (){
			tableRow.addClassName("lightblue");
		});

		tableRow.observe("mouseout", function (){
			tableRow.removeClassName("lightblue");
		});

		tableRow.observe("click", function (){
			tableRow.toggleClassName("selectedRow");
			if (tableRow.hasClassName("selectedRow")){
				$$("div[name='sameAssuredRow']").each(function (row){
					if (tableRow.id != row.id){
						row.removeClassName("selectedRow");
					}
				});
				fillAddress(tableRow.id.replace("row", ""));
			} else {
				clearAddress();
			}
		});
	}

	function fillAddress(rowId){
		try {
			for (var i = 0; i < objectSameAssured.length; i++){
				if (objectSameAssured[i].assdNo == rowId){
					$("mailAddress1").value = objectSameAssured[i].mailAddress1;
					$("mailAddress2").value = objectSameAssured[i].mailAddress2;
					$("mailAddress3").value = objectSameAssured[i].mailAddress3;
					$("billAddress1").value = objectSameAssured[i].billingAddress1;
					$("billAddress2").value = objectSameAssured[i].billingAddress2;
					$("billAddress3").value = objectSameAssured[i].billingAddress3;
				}
			}
		} catch (e){
			showErrorMessage("fillAddress(rowId)", e);
		}
	}

	function clearAddress(){
		$("mailAddress1").value = "";
		$("mailAddress2").value = "";
		$("mailAddress3").value = "";
		$("billAddress1").value = "";
		$("billAddress2").value = "";
		$("billAddress3").value = "";
	}
	
	function formatObjAsTableData(obj, length){
		var tblObj = obj;
		if (tblObj == "" || tblObj == null){
			tblObj = "---";
		} else {
			tblObj = tblObj.truncate(length, "...");
		}

		return tblObj;
	}
	
	function request(){
		new Ajax.Request(contextPath+"/GIISAssuredController", {
			method: "POST",
			parameters: {action : "checkRefCd",
								refCd : refCd},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}

	checkIfToResizeTable("sameAssuredListingContainer", "sameAssuredRow");
</script>
