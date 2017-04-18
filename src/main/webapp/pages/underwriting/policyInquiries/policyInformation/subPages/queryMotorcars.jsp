<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div id="motorcarDetailsDiv" name="motorcarDetailsDiv" changeTagAttr="true" style="width: 98%;">
	<form id="motorcarDetailsForm" name="motorcarDetailsForm" style="margin-left: 0px; margin-top: 10px;">
		<div class="sectionDiv">
			<table align="center" style="margin: 10px 0 10px 10px;">
				<tr>
					<td class="rightAligned" style="width: 70px;">Item</td>
					<td class="leftAligned">
						<input id="txtItem" name="txtItem" type="text" style="width: 60px; text-align: right;" value="" tabindex="301" maxlength="9" title="Item"/>						
					</td>
					<td class="rightAligned" style="width: 80px;">Model Year</td>
					<td class="leftAligned">
						<input id="txtModelYear" name="txtModelYear" type="text" style="width: 42px; text-align: right;" value="" tabindex="305" maxlength="4" title="Model Year"/>						
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Motor No.</td>
					<td class="leftAligned">
						<input id="txtMotorNo" name="txtMotorNo" type="text" style="width: 120px;" value="" tabindex="302" maxlength="30" title="Motor No."/>						
					</td>
					<td class="rightAligned">COC No.</td>
					<td class="leftAligned">
						<input id="txtCocType" name="txtCocType" type="text" style="width: 42px;" value="" tabindex="306" maxlength="7" title="COC Type"/>
						<input id="txtCocSerialNo" name="txtCocSerialNo" type="text" style="width: 70px; text-align: right;" value="" tabindex="307" maxlength="7" title="COC Serial No"/>
						<input id="txtCocYy" name="txtCocYy" type="text" style="width: 25px; text-align: right;" value="" tabindex="308" maxlength="2" title="COC Year"/>						
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Plate No.</td>
					<td class="leftAligned">
						<input id="txtPlateNo" name="txtPlateNo" type="text" style="width: 120px;" value="" tabindex="303" maxlength="10" title="Plate No."/>						
					</td>
					<td class="rightAligned">Policy No.</td>
					<td class="leftAligned">
						<input id="txtPolicyNo" name="txtPolicyNo" type="text" style="width: 250px;" value="" tabindex="309" maxlength="100" title="Policy No."/>
					</td>
				</tr>	
				<tr>
					<td class="rightAligned">Serial No.</td>
					<td class="leftAligned">
						<input id="txtSerialNo" name="txtSerialNo" type="text" style="width: 120px;" value="" tabindex="304" maxlength="25" title="Serial No."/>						
					</td>
					<td class="rightAligned">Status</td>
					<td class="leftAligned">
						<input id="txtPolFlag" name="txtPolFlag" type="text" style="width: 42px;" value="" tabindex="310" maxlength="1" title="Pol Flag"/>
					</td>
				</tr>
			</table>
		</div>		
	</form>
</div>
<div class="buttonsDivPopup">
	<input type="button" class="button" id="btnClear" name="btnClear" value="Clear" style="width:100px;" tabindex="312"/>
	<input type="button" class="button" id="btnOk" name="btnOk" value="Ok" style="width:100px;" tabindex="313"/>
	<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel" style="width: 100px;" tabindex="314"/>
</div>

<script>
	initializeAll();
	$("btnCancel").observe("click", function(){
		overlayQueryMotorcars.close();
	}); 
	
	makeInputFieldUpperCase();

	function populateVariables(){
		try {
			objGIPIS100.motorcars.itemNo = $F("txtItem");
			objGIPIS100.motorcars.motorNo = $F("txtMotorNo");
			objGIPIS100.motorcars.plateNo = $F("txtPlateNo");
			objGIPIS100.motorcars.serialNo = $F("txtSerialNo");
			objGIPIS100.motorcars.modelYear = $F("txtModelYear");			
			objGIPIS100.motorcars.cocType = $F("txtCocType");
			objGIPIS100.motorcars.cocSerialNo = $F("txtCocSerialNo");
			objGIPIS100.motorcars.cocYy = $F("txtCocYy");
			objGIPIS100.motorcars.policyNo = $F("txtPolicyNo");
			objGIPIS100.motorcars.polFlag = $F("txtPolFlag");
		} catch(e){
			showErrorMessage("populateVariables", e);
		}
	}
	
	function populateFields(){
		try {
			$("txtItem").value = nvl(objGIPIS100.motorcars.itemNo, "");
			$("txtMotorNo").value = nvl(objGIPIS100.motorcars.motorNo, "");
			$("txtPlateNo").value = nvl(objGIPIS100.motorcars.plateNo, "");
			$("txtSerialNo").value = nvl(objGIPIS100.motorcars.serialNo, "");
			$("txtModelYear").value = nvl(objGIPIS100.motorcars.modelYear, "");
			$("txtCocType").value = nvl(objGIPIS100.motorcars.cocType, "");
			$("txtCocSerialNo").value = nvl(objGIPIS100.motorcars.cocSerialNo, "");
			$("txtCocYy").value = nvl(objGIPIS100.motorcars.cocYy, "");
			$("txtPolicyNo").value = nvl(objGIPIS100.motorcars.policyNo, "");
			$("txtPolFlag").value = nvl(objGIPIS100.motorcars.polFlag, "");
		} catch(e){
			showErrorMessage("populateFields", e);
		}
	}
	
	function queryMotorcars(){
		try {
			overlayQueryMotorcars.close();
						
			motorCarsTableGrid.url = contextPath+"/GIPIVehicleController?action=getMotorCarsTable&refresh=1&itemNo="+objGIPIS100.motorcars.itemNo
					+"&motorNo="+encodeURIComponent(objGIPIS100.motorcars.motorNo)+"&plateNo="+encodeURIComponent(objGIPIS100.motorcars.plateNo)
					+"&serialNo="+encodeURIComponent(objGIPIS100.motorcars.serialNo)+"&modelYear="+objGIPIS100.motorcars.modelYear
					+"&cocType="+objGIPIS100.motorcars.cocType+"&cocSerialNo="+objGIPIS100.motorcars.cocSerialNo
					+"&cocYy="+objGIPIS100.motorcars.cocYy+"&policyNo="+encodeURIComponent(objGIPIS100.motorcars.policyNo)
					+"&polFlag="+objGIPIS100.motorcars.polFlag;
			
			motorCarsTableGrid._refreshList();
		} catch(e){
			showErrorMessage("queryMotorcars", e);
		}
	}
	
	$("btnClear").observe("click", function () {
		$$("form#motorcarDetailsForm input[type='text']").each(function(field){
			field.clear();
		});
		$("txtItem").focus();
	});
	
	$("btnOk").observe("click", function () {
		if($F("txtItem") == "" && $F("txtMotorNo") == ""
				&& $F("txtPlateNo") == "" && $F("txtSerialNo") == ""
				&& $F("txtModelYear") == "" && $F("txtCocType") == ""
				&& $F("txtCocSerialNo") == "" && $F("txtCocYy") == ""
				&& $F("txtPolicyNo") == "" && $F("txtPolFlag") == ""){
			showWaitingMessageBox("Please enter at least one parameter.", function(){
				$("txtItem").focus();
			});
		} else {
			populateVariables();
			objGIPIS100.motorcars.querySw = "Y";
			queryMotorcars();
		}
	});
	
	$("txtItem").observe("keyup", function(){
		if(isNaN($F("txtItem"))) {
			$("txtItem").value = "";
		}
	});
	
	$("txtModelYear").observe("keyup", function(){
		if(isNaN($F("txtModelYear"))) {
			$("txtModelYear").value = "";
		}
	});
	
	$("txtCocSerialNo").observe("change", function(){
		if($F("txtCocSerialNo") != "" && !isNaN($F("txtCocSerialNo"))) {
			$("txtCocSerialNo").value = formatNumberDigits($F("txtCocSerialNo"), 7);
		}
	});

	$("txtCocSerialNo").observe("keyup", function(){
		if(isNaN($F("txtCocSerialNo"))) {
			$("txtCocSerialNo").value = "";
		}
	});	
	
	$("txtCocYy").observe("keyup", function(){
		if(isNaN($F("txtCocYy"))) {
			$("txtCocYy").value = "";
		}
	});
	
	populateFields();	
	
	$("txtItem").focus();
</script>