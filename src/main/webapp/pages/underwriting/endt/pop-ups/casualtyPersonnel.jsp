<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<jsp:include page="/pages/underwriting/endt/casualty/subPages/casualtyPersonnel/casualtyPersonnelInformationListing.jsp"></jsp:include>
<table align="center" width="520px;" border="0">
	<tr>
		<td class="rightAligned" style="width: 150px;">Personnel No.</td>
		<td class="leftAligned">
			<input id="txtPersonnelNo" name="txtPersonnelNo" type="text" style="width: 357px;" maxlength="5" class="required integerUnformattedOnBlur" errorMsg="Invalid Personnel No. Value should be from -9999 to 9999." min="-9999" max="9999" />
		</td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 150px;">Personnel Name </td>
		<td class="leftAligned" >			
			<input id="txtPersonnelName" name="txtPersonnelName" type="text" style="width: 357px;" maxlength="50" class="required"/>
		</td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 150px;">Amount Covered </td>
		<td class="leftAligned" >
			<input id="txtAmountCoveredP" name="txtAmountCoveredP" type="text" style="width: 357px;" maxlength="18" class="money2" errorMsg="Invalid Amount Covered. Value should be from -99,999,999,999,999.99 to 99,999,999,999,999.99." min="-99999999999999.99" max="99999999999999.99" />
		</td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 150px;">Capacity</td>
		<td class="leftAligned">
			<select id="selCapacityCdP" name="selCapacityCdP" style="width: 365px;" >
				<option value=""></option>
				<c:forEach var="capacity" items="${capacityListing}">
					<option value="${capacity.positionCd}">${capacity.position}</option>				
				</c:forEach>
			</select>
		</td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 150px;">Remarks </td>
		<td class="leftAligned" >
			<div style="border: 1px solid gray; height: 20px; width: 364px;">
				<textarea onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);" id="txtRemarksP" name="txtRemarksP" style="width: 90%; border: none; height : 13px;"></textarea>
				<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="edit" id="editRemarksP">
			</div>			
		</td>
	</tr>	
	<tr>
		<td>
			<input id="hidIncludeTagP" name="hidIncludeTagP" type="hidden" style="width: 220px;" value="Y" maxlength="1" readonly="readonly"/>
			<input id="hidNextItemNoP" name="hidNextItemNoP" type="hidden" style="width: 220px;" value="" readonly="readonly"/>
		</td>
	</tr>
</table>
<table align="center">
	<tr>
		<td class="rightAligned" style="text-align: left; padding-left: 5px;">
			<input type="button" class="button" 		id="btnAddPersonnel" 		name="btnAddPersonnel" 		value="Add" 		style="width: 60px;" />
			<input type="button" class="disabledButton" id="btnDeletePersonnel" 	name="btnDeletePersonnel" 	value="Delete" 		style="width: 60px;" />
		</td>
	</tr>
</table>

<script type="text/javascript">
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();

	setTableList(objEndtCAPersonnels, "casualtyPersonnelListing", "rowCasualtyPersonnel", "casualtyPersonnelTable",
			 "itemNo personnelNo", "casualtyPersonnel");
	//checkTableItemInfoAdditional("casualtyPersonnelTable","casualtyPersonnelListing","rowCasualtyPersonnel","item",$F("itemNo"));

	truncateLongDisplayTexts2("label", "txtPersonnel", 15);

	$$("div#casualtyPersonnelTable div[name='rowCasualtyPersonnel']").each(function(row){
		loadRowObserver(row);
	});

	function loadRowObserver(row){
		try{
			loadRowMouseOverMouseOutObserver(row);
	
			row.observe("click", function(){
				row.toggleClassName("selectedRow");
				if(row.hasClassName("selectedRow")){
					var id = row.getAttribute("id");
					$$("div#casualtyPersonnelTable div[name='rowCasualtyPersonnel']").each(function(r){
						if(id != r.getAttribute("id")){
							r.removeClassName("selectedRow");
						}
					});

					loadSelectedCasualtyPersonnel("rowCasualtyPersonnel", row, id);
					setUnsetPrimaryKeyFieldsToReadOnly(true);
				}else{
					setFormValues(null);
				}
			});
		}catch(e){
			showErrorMessage("loadRowObserver", e);
			//showMessageBox("loadRowObserver : " + e.message);
		}
	}

	function setFormValues(obj){
		try{
			$("txtPersonnelNo").value		= obj == null ? null : obj.personnelNo;
			$("txtPersonnelName").value		= obj == null ? null : obj.personnelName;
			$("txtAmountCoveredP").value	= obj == null ? null : (obj.amountCovered == null ? "" : formatCurrency(obj.amountCovered));
			$("selCapacityCdP").value		= obj == null ? null : obj.capacityCd;
			$("txtRemarksP").value			= obj == null ? null : obj.remarks == null ? "" : changeSingleAndDoubleQuotes(obj.remarks);
	
			$("btnAddPersonnel").value		= obj == null ? "Add" : "Update";
			(obj == null) ? disableButton($("btnDeletePersonnel")) : enableButton($("btnDeletePersonnel"));

			setUnsetPrimaryKeyFieldsToReadOnly(obj == null ? false : true);
		}catch(e){
			showErrorMessage("setFormValues", e);
			//showMessageBox("setFormValues : " + e.message);
		}
	}

	$("editRemarksP").observe("click", function(){
		showEditor("txtRemarksP", 4000);
	});

	$("txtPersonnelNo").observe("blur", function(){
		if($("rowCasualtyPersonnel" + $F("itemNo") + "_" + $F("txtPersonnelNo")) != null && $F("btnAddPersonnel") == "Add"){
			customShowMessageBox("Personnel No. must be unique.", imgMessage.ERROR, "txtPersonnelNo");
		}
	});

	$("txtPersonnelNo").observe("change", function(){		
		if(!($F("itemNo").empty())){
			new Ajax.Request(contextPath + "/GIPIWCasualtyPersonnelController?action=getCasualtyPersonnelDetails", {
				method : "GET",
				parameters : {
					parId : $F("globalParId"),
					itemNo : $F("itemNo"),
					personnelNo : $F("txtPersonnelNo")
				},
				asynchronous : true,
				evalScripts : true,
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						
						if(obj != null){
							$("txtPersonnelName").value 	= obj.name;
							$("txtRemarksP").value			= obj.remarks;
							$("selCapacityCdP").value		= obj.capacityCd;
							$("txtAmountCoveredP").value	= obj.amountCovered;
						}
					}
				}
			});
		}		
	});

	$("btnAddPersonnel").observe("click", function(){
		if(objItemNoList[$F("itemNo")] == undefined){
			showMessageBox("Please select an item first.", imgMessage.ERROR);
		}else{
			if($F("txtPersonnelNo").empty() || $F("txtPersonnelName").empty()){
				customShowMessageBox("Please complete required fields.", imgMessage.ERROR, 
						($F("txtPersonnelNo")).empty() ? "txtPersonnelNo" : "txtPersonnelName");
			}else{
				var id = "rowCasualtyPersonnel" + $F("itemNo") + "_" + $F("txtPersonnelNo");
				if($(id) != null && $F("btnAddPersonnel") == "Add"){
					showMessageBox("Record already exists.", imgMessage.ERROR);
				}else{
					addPersonnel();
				}				
			}
		}
	});

	$("btnDeletePersonnel").observe("click", function(){
		$$("div#casualtyPersonnelTable div[name='rowCasualtyPersonnel']").each(function(row){
			if(row.hasClassName("selectedRow")){
				Effect.Fade(row, {
					duration : 0.5,
					afterFinish : function(){
						var deleteObject = setCasualtyPersonnel();						
						addDelObjByAttr(objEndtCAPersonnels, deleteObject, "personnelNo");
						row.remove();
						setFormValues(null);
						checkPopupsTableWithTotalAmountbyObject(objEndtCAPersonnels, "casualtyPersonnelTable", "casualtyPersonnelListing",
								"rowCasualtyPersonnel", "amountCovered", "casualtyPersonnelTotalAmountDiv", "casualtyPersonnelTotalAmount");
					}
				});
			}
		});
	});

	function addPersonnel(){
		try{
			var obj		= setCasualtyPersonnel();	
			var content = prepareCasualtyPersonnel(obj);
	
			if($F("btnAddPersonnel") == "Update"){
				addModedObjByAttr(objEndtCAPersonnels, obj, "personnelNo");
				$("rowCasualtyPersonnel" + obj.itemNo + "_" + obj.personnelNo).update(content);
				$("rowCasualtyPersonnel" + obj.itemNo + "_" + obj.personnelNo).removeClassName("selectedRow");
			}else{
				addNewJSONObject(objEndtCAPersonnels, obj);

				var table = $("casualtyPersonnelListing");
				var newDiv = new Element("div");
				
				newDiv.setAttribute("id", "rowCasualtyPersonnel" + obj.itemNo + "_" + obj.personnelNo);
				newDiv.setAttribute("name", "rowCasualtyPersonnel");
				newDiv.setAttribute("itemNo", obj.itemNo);
				newDiv.setAttribute("personnelNo", obj.personnelNo);		
				newDiv.addClassName("tableRow");

				newDiv.update(content);
				table.insert({bottom : newDiv});

				loadRowObserver(newDiv);				
				
				new Effect.Appear("rowCasualtyPersonnel" + obj.itemNo + "_" + obj.personnelNo, {
					duration : 0.2
				});							
			}

			//truncateLongDisplayTexts2("label", "txtPersonnel", 15);
			//checkPopupsTableWithTotalAmount("casualtyPersonnelTable", "casualtyPersonnelListing", 
			//		"rowCasualtyPersonnel", "casualtyPersonnelTotalAmountDiv",
			//		"casualtyPersonnelTotalAmount", 4);	

			checkPopupsTableWithTotalAmountbyObject(objEndtCAPersonnels, "casualtyPersonnelTable", "casualtyPersonnelListing",
					"rowCasualtyPersonnel", "amountCovered", "casualtyPersonnelTotalAmountDiv", "casualtyPersonnelTotalAmount");

			setFormValues(null);
		}catch(e){
			showErrorMessage("addPersonnel", e);
			//showMessageBox("addPersonnel : " + e.message);
		}
	}

	function setCasualtyPersonnel(){
		try{
			var newObj = new Object();
	
			newObj.parId 			= $F("globalParId");
			newObj.itemNo 			= $F("itemNo");
			newObj.personnelNo 		= $F("txtPersonnelNo");
			newObj.personnelName 	= changeSingleAndDoubleQuotes2($F("txtPersonnelName"));
			newObj.amountCovered 	= ($F("txtAmountCoveredP")).empty() ? null : formatCurrency($F("txtAmountCoveredP"));
			newObj.capacityCd 		= $F("selCapacityCdP");
			newObj.capacityDesc		= $("selCapacityCdP").options[$("selCapacityCdP").selectedIndex].text;
			newObj.remarks 			= changeSingleAndDoubleQuotes2($F("txtRemarksP"));
			newObj.includeTag 		= "Y";
			newObj.origRecord		= isOriginalRecord('${casualtyPersonnels}', newObj, "itemNo personnelNo");
			
			return newObj;
		}catch(e){
			showErrorMessage("setCasualtyPersonnel", e);
			//showMessageBox("setCasualtyPersonnel : " + e.message);
		}
	}

	function setUnsetPrimaryKeyFieldsToReadOnly(property){
		if(property){
			$("txtPersonnelNo").setAttribute("readonly", "readonly");
			//$("txtPersonnelName").setAttribute("readonly", "readonly");
		}else{
			$("txtPersonnelNo").removeAttribute("readonly");
			//$("txtPersonnelName").removeAttribute("readonly");
		}
	}
</script>