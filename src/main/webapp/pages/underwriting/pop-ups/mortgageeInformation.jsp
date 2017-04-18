<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c"  uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<!-- <div id="spinLoadingDiv"></div> -->
<!-- 
<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
   		<label>Mortgagee Information</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" style="margin-left: 5px;">Hide</label>
   		</span>
   	</div>
</div>
-->
<!-- <div id="mortgageeContainerDiv" class="sectionDiv" >  -->
	<!-- <form id="mortgageeForm" name="mortgageeForm"> -->
		<input id="parId" 					name="parId" 				type="hidden" 	value="${parId}" />
		<input id="itemNoTemp" 				name="itemNoTemp" 			type="hidden" 	value="${itemNo}" />		
		
		<jsp:include page="/pages/underwriting/subPages/mortgageeTable.jsp"></jsp:include>	
		
		<!-- <div id="sectionDiv"> -->			
			
			<table align="center" id="maintainMortgageeForm" border="0">
				<tr>
					<td class="rightAligned" style="width: 120px;">Mortgagee Name </td>
					<td class="leftAligned">
						<input type="text" id="txtMortgageeName" name="txtMortgageeName" class="required" readonly="readonly" style="width: 356px; height: 13px;" />					
						<select id="mortgageeName" name="mortgageeName" style="width: 365px;" class="required">
							<option value=""></option>
							<c:forEach var="mortgageeListing" items="${mortgageeListing}">
								<option value="${fn:replace(mortgageeListing.mortgCd, ' ', '_')}" deleteSw="${mortgageeListing.deleteSw}">${mortgageeListing.mortgName}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Amount </td>
					<td class="leftAligned"><input id="mortgageeAmount" type="text" class="money" maxlength="17" style="width: 356px;" min="0.00" max="99999999999999.99" errorMsg="Invalid Mortgagee amount. Value should be from 0.00 to 99,999,999,999,999.99" /></td>
				</tr>
				<!-- 
				<tr>
					<td class="rightAligned">Item No. </td>
					<td style=""><input id="mortgageeItemNo" type="text" readonly="readonly" value="" style="float: left; width: 125px;" class="required" /></td>
				</tr>
				-->
				<tr>
				<!-- added deleteSw kenneth SR 5483 05.26.2016 -->
				<td></td>
					<td>
						<div style="margin-left: 4px;">
							<input tabindex="4004" id="chkDeleteSw" name="chkDeleteSw" type="checkbox" style=" float: left; width: 13px; height: 13px; overflow: hidden;"/>
							<label tabindex="4005" id="lblDeleteSw" for="chkDeleteSw" style="margin-left: 5px;">Delete Switch</label>
						</div>
					</td>
				</tr>
				<tr align="center">					
					<td colspan="2" style="text-align: center;">
						<input id="btnAddMortgagee" name="btnAddMortgagee" type="button" class="button" value="Add" style="width: 60px;  margin-top: 10px;" />
						<input id="btnDeleteMortgagee" name="btnDeleteMortgagee" type="button" class="disabledButton" value="Delete" style="width: 60px; margin-bottom: 10px;" />						
					</td>
				</tr>
			</table>
		<!-- </div> -->		
	<!-- </form> -->
<!-- </div> -->
<!-- <div class="buttonsDivPopup">
	<input type="button" class="button" style="width: 130px;" id="btnMaintainMortgagee" name="btnMaintainMortgagee" value="Maintain Mortgagee" />
	<input type="button" class="button" style="width: 60px;" id="btnCancel" name="btnCancel" value="Cancel" />
	<input type="button" class="button" style="width: 60px;" id="btnSave" name="btnSave" value="Save" />
</div> -->

<script type="text/javascript">
	var mortgLevel = $F("mortgageeLevel");
	if(mortgLevel == 0){
		objMortgagees = null;
		objMortgagees = JSON.parse('${objMortgagees}');	
	}		

	showMortgageeList();
	setMortgageeForm(null);	
	
	//loadMortgageeRowObserver();

	$("btnAddMortgagee").observe("click", function(){		
		if(mortgLevel == 1){			
			var selected = false;
			$$("div#itemTable .selectedRow").each(function(row){
				selected = true;
			});

			if(!selected){
				showMessageBox("Please select an item first.", imgMessage.INFO);	//Gzelle 02.28.2013 changed from ERROR to INFO
				return false;
			}

			//var objFilteredArr = objMortgagees.filter(function(obj){	return nvl(obj.recordStatus, 0) != -1 && obj.mortgCd == $F("mortgageeName");	});
		}

		if($F("mortgageeName").blank()){
			showMessageBox("Mortgagee name required.", imgMessage.ERROR);
			return false;
		}
		
		addMortgagee();
		($$("div#mortgageeInfo [changed=changed]")).invoke("removeAttribute", "changed");		
	});	

	$("btnDeleteMortgagee").observe("click", function(){
		if(mortgLevel == 1){			
			var selected = false;
			$$("div#itemTable .selectedRow").each(function(row){
				selected = true;
			});

			if(!selected){
				showMessageBox("Please select an item first.", imgMessage.ERROR);
				return false;
			}		
		}
		deleteMortgagee();
	});

	function deleteMortgagee(){
		try{			
			$$("div#mortgageeTable .selectedRow").each(function(row){				
				Effect.Fade(row, {
					duration : .3,
					afterFinish : function(){
						var delObj = setMortgagee();														
						addDelObjByAttr(objMortgagees, delObj, "mortgCd");							
						row.remove();
						setMortgageeForm(null);
						//filterLOV3("mortgageeName", "rowMortg", delObj.mortgCd, "item", delObj.itemNo, "mortgCd");
						filterLOV3("mortgageeName", "rowMortg", "mortgCd", "item", delObj.itemNo);
						checkPopupsTableWithTotalAmountbyObject(objMortgagees, "mortgageeTable", "mortgageeListing", "rowMortg",
								"amount", "mortgageeTotalAmountDiv", "mortgageeTotalAmount");
					}
				});				
			});
		}catch(e){
			showErrorMessage("deleteMortgagee", e);
			//showMessageBox("deleteMortgagee : " + e.message);
		}
	}	
	
	function addMortgagee(){
		try{			
			var obj 	= setMortgagee();
			var content = prepareMortgagee(obj);			
			
			if($F("btnAddMortgagee") == "Update"){				
				$("rowMortg" + obj.itemNo + "_" + obj.mortgCd).update(content);
				$("rowMortg" + obj.itemNo + "_" + obj.mortgCd).removeClassName("selectedRow");								
				addModedObjByAttr(objMortgagees, obj, "mortgCd");
			}else{				
				var table 	= $("mortgageeListing");
				var newDiv 	= new Element("div");
				
				newDiv.setAttribute("id", "rowMortg" + obj.itemNo + "_" + obj.mortgCd);
				newDiv.setAttribute("name", "rowMortg");
				newDiv.setAttribute("item", obj.itemNo);
				newDiv.setAttribute("mortgCd", obj.mortgCd);
				newDiv.addClassName("tableRow");
				
				newDiv.update(content);
				table.insert({bottom : newDiv});
				
				loadMortgageeRowObserver(newDiv);
				
				new Effect.Appear("rowMortg" + obj.itemNo + "_" + obj.mortgCd, {
					duration : 0.2
				});

				addNewJSONObject(objMortgagees, obj);
				
				//filterLOV3("mortgageeName", "rowMortg", "", "item", obj.itemNo, "mortgCd");
				//filterLOV3("mortgageeName", "rowMortg", "mortgCd", "item", obj.itemNo);
				if(mortgLevel == 0){
					filterItemLOV("mortgageeTable", "item", obj.itemNo, "mortgageeName", "mortgCd");
				}											
			}			
			
			toggleSubpagesRecord(objMortgagees, objItemNoList, (mortgLevel == 1 ? $F("itemNo") : "0"), "rowMortg", "mortgCd",
					"mortgageeTable", "mortgageeTotalAmountDiv", "mortgageeTotalAmount", "mortgageeListing", "amount", false);
			
			//resizeTableBasedOnVisibleRows("mortgageeTable", "mortgageeListing");
			//checkTableIfEmpty("rowMortg", "mortgageeListing");		
			
			setMortgageeForm(null);
		}catch(e){
			showErrorMessage("addMortgagee", e);
			//showMessageBox("addMortgagee : " + e.message);
		}		
	}	
	/*
	function loadMortgageeRowObserver(row){
		try{
			loadRowMouseOverMouseOutObserver(row);

			row.observe("click", function(){
				row.toggleClassName("selectedRow");

				if(row.hasClassName("selectedRow")){
					$$("div#mortgageeTable div[name='rowMortg']").each(function(r){
						if(row.getAttribute("id") != r.getAttribute("id")){
							r.removeClassName("selectedRow");
						}
					});

					loadSelectedMortgagee(row);
				}else{
					setMortgageeForm(null);
				}
			});
		}catch(e){
			showErrorMessage("loadMortgageeRowObserver", e);
			//showMessageBox("loadMortgageeRowObserver : " + e.message);
		}		
	}
	*/
	function loadSelectedMortgagee(row){
		try{
			var currentObj = new Object();
			
			for(var i=0, length=objMortgagees.length; i < length; i++){								
				if(objMortgagees[i].itemNo == row.getAttribute("item") && objMortgagees[i].mortgCd == row.getAttribute("mortgCd")){															
					currentObj = objMortgagees[i];
					break;
				}
			}			
			
			setMortgageeForm(currentObj);
			delete currentObj;
		}catch(e){
			showErrorMessage("loadSelectedMortgagee", e);
			//showMessageBox("loadSelectedMortgagee : " + e.message);
		}		
	}	
	
	function setMortgagee(){
		try{
			var newObj = new Object();

			newObj.parId		= (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
			newObj.itemNo		= (mortgLevel == 1 ? $F("itemNo") : "0"); //$F("mortgageeItemNo");
			newObj.mortgCd		= ($F("mortgageeName")).replace(/ /g, "_");
			newObj.mortgName	= ($("mortgageeName").options[$("mortgageeName").selectedIndex].text);
			newObj.amount		= $F("mortgageeAmount").empty() ? null : formatCurrency($F("mortgageeAmount").replace(/,/g, ""));
			newObj.issCd		= (objUWGlobal.packParId != null ? objCurrPackPar.issCd : $F("globalIssCd"));
			newObj.userId		= userId;
			newObj.deleteSw		= ($("chkDeleteSw").checked ? "Y" : "N"); //kenneth SR 5483 05.26.2016
			
			//newObj.origRecord	= isOriginalRecord('${objMortgagees}', newObj, "itemNo mortgCd");
			return newObj;
		}catch(e){
			showErrorMessage("setMortgagee", e);
		}
	}	

	/*
	$("btnSave").observe("click",
		function(){
			new Ajax.Request(contextPath + "/GIPIParMortgageeController?action=saveGipiParItemMortgagee&ajax=1", {
				method : "POST",
				postBody : Form.serialize("mortgageeForm"),
				asynchronous : true,
				evalScripts : true,
				onCreate :
					function(){
						showNotice("Saving, please wait...");
					},
				onComplete :
					function(response){
						hideNotice(response.responseText);
						if(response.responseText == "SUCCESS"){
							//Modalbox.hide();
						}
					}
			});
	});
	*/
	
	//kenneth SR 5483 05.26.2016
	function getPerItemAmount(mortgCd) {
		var perItemAmount = 0;
		new Ajax.Request(contextPath+"/GIPIMortgageeController?action=getPerItemAmount", {
			method: "GET",
			asynchronous: false,
			evalScripts: true,
			parameters: {
				policyId : objUWParList.endtPolicyId,
				itemNo : $F("itemNo"),
				mortgCd : mortgCd
			},
			onComplete: function(response) {
				if (checkErrorOnResponse) {
					if (response.responseText.blank() || !isNaN(response.responseText)) {
						perItemAmount = parseFloat(response.responseText);
					} else {
						perItemAmount = 0;
					}
				}
			}
		});

		return perItemAmount;
	}
	//MarkS SR 5483,2743,3708 09.07.2016
	function getPerItemMortgName(mortgCd) {
		var perItemMortgName = 0;
		new Ajax.Request(contextPath+"/GIPIMortgageeController?action=getPerItemMortgName", {
			method: "GET",
			asynchronous: false,
			evalScripts: true,
			parameters: {
				policyId : objUWParList.endtPolicyId,
				itemNo : $F("itemNo"),
				mortgCd : mortgCd
			},
			onComplete: function(response) {
				if (checkErrorOnResponse) {
					if (response.responseText.blank() || !isNaN(response.responseText)) {
						perItemMortgName = response.responseText;
					} else {
						perItemMortgName = "";
					}
				}
			}
		});

		return perItemMortgName;
	}
	
	//modified by kenneth SR 5483 05.26.2016
	$("mortgageeName").observe("change", function(){
		$("chkDeleteSw").checked = $("mortgageeName").options[$("mortgageeName").selectedIndex].getAttribute("deleteSw") == "Y" ? true : false;
		$("mortgageeAmount").value = formatCurrency(getPerItemAmount($F("mortgageeName"))); 
		$("mortgageeName").setAttribute("changed", "changed");
	});
	
	$("chkDeleteSw").observe("change",function() {
		var morAmount = unformatCurrencyValue(nvl($("mortgageeAmount").value, 0));
		if ($("chkDeleteSw").checked == true){
			$("mortgageeAmount").value = (morAmount == 0 ? 0 : morAmount * -1);
			$("mortgageeAmount").setAttribute("min", '-9999999999999.99');
		}else{
			$("mortgageeAmount").setAttribute("min", '0');
		}
	});
	
	initializeAll();
	initializeAllMoneyFields();
	addStyleToInputs();
	initializeChangeTagBehavior(changeTagFunc); 	
</script>