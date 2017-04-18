<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c"  uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<input type="hidden" id="parId"		name="parId"	value="${parId}" />
<input type="hidden" id="userId"	name="userId" 	value="" />


<div id="mortgageeTable" name="mortgageeTable" style="width : 100%;">
	<div id="mortgageeTableGridSectionDiv" class="">
		<div id="mortgageeTableGridDiv" style="padding: 10px;">
			<div id="mortgageeTableGrid" style="height: 0px; width: 900px;"></div>
		</div>
	</div>	
</div>	
	

<!-- <div id="sectionDiv"> -->			
	
	<table align="center" id="maintainMortgageeForm" border="0">
		<tr>
			<td class="rightAligned" style="width: 120px;">Mortgagee Name </td>
			<td class="leftAligned">				
				<div style="float: left; border: solid 1px gray; width: 362px; height: 21px; margin-right: 3px;" class="required">
					<input type="hidden" id="mortgCd" name="mortgCd" />
					<input type="text" tabindex="4001"  style="float: left; margin-top: 0px; margin-right: 3px; width: 335px; border: none;" name="mortgageeName" id="mortgageeName" readonly="readonly" class="required" />
					<img id="hrefMortgagee" alt="goMortgagee" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" for="mortgageeAmount">Amount </td>
			<td class="leftAligned">
				<!-- 
				<input tabindex="4002" id="mortgageeAmount" type="text" class="money2" maxlength="17" style="width: 356px;" min="0.00" max="99999999999999.99" errorMsg="Invalid Mortgagee amount. Value should be from 0.00 to 99,999,999,999,999.99" />
				 -->
				<input tabindex="4002" id="mortgageeAmount" type="text" class="money" regExpPatt="pDeci1402" maxlength="17" style="width: 356px;" min="0.00" max="99999999999999.99" />
			</td>
		</tr>		
		<tr>
			<td class="rightAligned">Remarks </td>
			<td class="leftAligned">				
				<div style="float: left; border: solid 1px gray; width: 362px; height: 21px; margin-right: 3px;">					
					<textarea tabindex="4003"  onKeyDown="limitText(this, 4000);" onKeyUp="limitText(this, 4000);" style="width: 336px; height: 13px; float: left; border: none; resize: none;" id="mortgageeRemarks" name="mortgageeRemarks""></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: left;" alt="EditMortgageeRemarks" id="editMortgRemarks" class="hover" />						
				</div>
			</td>
			<!-- 
			<td style="leftAligned">				
				<div style="width: 362px; border: 1px solid gray; height: 20px; padding-bottom: 1px;">
					<textarea tabindex="4" onKeyDown="limitText(this, 4000);" onKeyUp="limitText(this, 4000);" style="width: 330px; height: 13px; float: left; border: none; resize: none;" id="mortgageeRemarks" name="mortgageeRemarks""></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: left;" alt="EditMortgageeRemarks" id="editMortgRemarks" class="hover" />
				</div>
			</td>
			 -->
		</tr>
		<!-- added deleteSw kenneth SR 5483 05.26.2016 -->		
		<tr>
			<td></td>
			<td>
				<div style="margin-left: 4px;">
					<input tabindex="4004" id="chkDeleteSw" name="chkDeleteSw" type="checkbox" style=" float: left; width: 13px; height: 13px; overflow: hidden;" hidden="true"/>
					<label tabindex="4005" id="lblDeleteSw" for="chkDeleteSw" style="margin-left: 5px;"  hidden="true">Delete Switch</label>
				</div>
			</td>
		</tr>
		<tr align="center">					
			<td colspan="2" style="text-align: center;">
				<input tabindex="4006" id="btnAddMortgagee" name="btnAddMortgagee" type="button" class="button" value="Add" style="width: 60px; margin-top: 10px;" />
				<input tabindex="4007" id="btnDeleteMortgagee" name="btnDeleteMortgagee" type="button" class="disabledButton" value="Delete" style="width: 60px; margin-bottom: 10px;" />						
			</td>
		</tr>
	</table>
<!-- <div class="buttonsDivPopup">
	<input type="button" class="button" style="width: 130px;" id="btnMaintainMortgagee" name="btnMaintainMortgagee" value="Maintain Mortgagee" />
	<input type="button" class="button" style="width: 60px;" id="btnCancel" name="btnCancel" value="Cancel" />
	<input type="button" class="button" style="width: 60px;" id="btnSave" name="btnSave" value="Save" />
</div> -->

<script type="text/javascript">
try{
var mortgLevel = $F("mortgageeLevel");
	var result = null; //kenneth SR 5483 05.26.2016
	//if(mortgLevel == 0){
	//	objMortgagees = null;
	//	objMortgagees = JSON.parse('${objMortgagees}');	
	//}		

	//showMortgageeList();
	//setMortgageeForm(null);	
	
	//loadMortgageeRowObserver();
	function selectMortgagee(){
		try{
			var notIn = "";
			var withPrevious = false;
			var itemNo = mortgLevel == 0 ? 0 : $F("itemNo");

			var objArrFiltered = objMortgagees.filter(function(obj){	return parseInt(obj.itemNo) == itemNo && nvl(obj.recordStatus, 0) != -1;	});

			for(var i=0, length=objArrFiltered.length; i < length; i++){			
				if(withPrevious){
					notIn += ",";
				}
				notIn += "'" + objArrFiltered[i].mortgCd + "'";
				withPrevious = true;
			}
			
			notIn = (notIn != "" ? "("+notIn+")" : "");
			
			showMortgageeLOV(objUWParList.parId, itemNo, objUWParList.issCd, notIn, getPerItemAmount, getPerItemMortgName); //kenneth SR 5483 05.26.2016
			
			
		}catch(e){
			showErrorMessage("selectMortgagee", e);
		}
	}
	
	//kenneth SR 5483 05.26.2016
	function getPerItemAmount(mortgCd) {
		var perItemAmount = 0;
		var modIdCheck = $("lblModuleId").getAttribute("moduleId") == "GIPIS031" ? true : false;
		
		new Ajax.Request(contextPath+"/GIPIMortgageeController?action=getPerItemAmount", {
			method: "GET",
			asynchronous: false,
			evalScripts: true,
			parameters: {
				policyId : objUWParList.endtPolicyId,
				itemNo : mortgLevel == 0 ? 0 : $F("itemNo"),
				mortgCd : mortgCd,
				lineCd : modIdCheck ? $F("b540LineCd") : null,
				sublineCd : modIdCheck ? $F("b540SublineCd") : null,
				issCd : modIdCheck ? $F("b540IssCd") : null,
				issueYy : modIdCheck ? $F("b540IssueYY") : null,
				polSeqNo : modIdCheck ? $F("b540PolSeqNo") : null,
				renewNo : modIdCheck ? $F("b540RenewNo") :null
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
		var perItemMortgName = "";
		var modIdCheck = $("lblModuleId").getAttribute("moduleId") == "GIPIS031" ? true : false;
		
		new Ajax.Request(contextPath+"/GIPIMortgageeController?action=getPerItemMortgName", {
			method: "GET",
			asynchronous: false,
			evalScripts: true,
			parameters: {
				policyId : objUWParList.endtPolicyId,
				itemNo : mortgLevel == 0 ? 0 : $F("itemNo"),
				mortgCd : mortgCd,
				lineCd : modIdCheck ? $F("b540LineCd") : null,
				sublineCd : modIdCheck ? $F("b540SublineCd") : null,
				issCd : modIdCheck ? $F("b540IssCd") : null,
				issueYy : modIdCheck ? $F("b540IssueYY") : null,
				polSeqNo : modIdCheck ? $F("b540PolSeqNo") : null,
				renewNo : modIdCheck ? $F("b540RenewNo") :null
			},
			onComplete: function(response) {
				if (checkErrorOnResponse) {
					if (response.responseText.blank()) {
						perItemMortgName = "";
					} else {
						perItemMortgName = response.responseText;
					}
				}
			}
		});

		return perItemMortgName;
	}
	
	$("hrefMortgagee").observe("click", function(){
		try{
			if(mortgLevel == 0){
				selectMortgagee();
			}else{
				if(objCurrItem != null){					
					selectMortgagee();
				}else{
					showMessageBox("Please select an item first.", imgMessage.INFO);
					return false;
				}
			}	
		}catch(e){
			showErrorMessage("hrefMortgagee", e);
		}			
	});
	
	$("editMortgRemarks").observe("click", function () {
		showEditor("mortgageeRemarks", 4000);
	});

	$("btnAddMortgagee").observe("click", function(){		
		if(mortgLevel == 1){
			if(objCurrItem == null){
				showMessageBox("Please select an item first.", imgMessage.ERROR);
				return false;
			}			
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
			if(objCurrItem == null){
				showMessageBox("Please select an item first.", imgMessage.ERROR);
				return false;
			}				
		}
		deleteMortgagee();
	});
	
	function deleteMortgagee(){
		try{			
			//tbgMortgagee.deleteRow(tbgMortgagee.getCurrentPosition()[1]);
			var delObj = setMortgagee();
			addDelObjByAttr(objMortgagees, delObj, "mortgCd");			
			tbgMortgagee.deleteVisibleRowOnly(tbgMortgagee.getCurrentPosition()[1]);
			setMortgageeFormTG(null);
			updateTGPager(tbgMortgagee);		
		}catch(e){
			showErrorMessage("deleteMortgagee", e);			
		}
	}	
	
	function addMortgagee(){
		try{			
			var newObj 	= setMortgagee();			
			
			if($F("btnAddMortgagee") == "Update"){									
				addModedObjByAttr(objMortgagees, newObj, "mortgCd");							
				tbgMortgagee.updateVisibleRowOnly(newObj, tbgMortgagee.getCurrentPosition()[1]);
			}else{				
				addNewJSONObject(objMortgagees, newObj);				
				tbgMortgagee.addBottomRow(newObj);													
			}			
			
			setMortgageeFormTG(null);
			($$("div#mortgageeInfo [changed=changed]")).invoke("removeAttribute", "changed");
			updateTGPager(tbgMortgagee);
			//saveMortgagee();
		}catch(e){
			showErrorMessage("addMortgagee", e);			
		}		
	}	
	
	function loadSelectedMortgagee(row){
		try{
			var currentObj = new Object();
			
			for(var i=0, length=objMortgagees.length; i < length; i++){								
				if(objMortgagees[i].itemNo == row.getAttribute("item") && objMortgagees[i].mortgCd == row.getAttribute("mortgCd")){															
					currentObj = objMortgagees[i];
					break;
				}
			}			
			
			setMortgageeFormTG(currentObj);
			delete currentObj;
		}catch(e){
			showErrorMessage("loadSelectedMortgagee", e);			
		}		
	}	
	
	function setMortgagee(){
		try{
			var newObj = new Object();
			
			newObj.parId		= (objUWGlobal.packParId != null ? objCurrPackPar.parId : $F("globalParId"));
			newObj.itemNo		= lpad(mortgLevel == 1 ? $F("itemNo") : "0", 9, "0"); //$F("mortgageeItemNo");
			//newObj.mortgCd		= ($F("mortgageeName")).replace(/ /g, "_");
			newObj.mortgCd		= $F("mortgCd");//($F("mortgageeName"));
			newObj.mortgName	= escapeHTML2($F("mortgageeName")); //($("mortgageeName").options[$("mortgageeName").selectedIndex].text); Gzelle 0203215
			newObj.amount		= $F("mortgageeAmount").empty() ? null : formatCurrency($F("mortgageeAmount").replace(/,/g, ""));
			newObj.issCd		= (objUWGlobal.packParId != null ? objCurrPackPar.issCd : $F("globalIssCd"));
			newObj.remarks		= escapeHTML2($F("mortgageeRemarks"));	// changed from changeSingleAndDoubleQuotes2 to escapeHTML2 : shan 07.01.2014
			newObj.userId		= $F("userId");			
			newObj.deleteSw		= ($("chkDeleteSw").checked ? "Y" : "N"); //kenneth SR 5483 05.26.2016
			
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

	function saveMortgagee(){
		try{
			var executeSave = false;
			var objParameters = new Object();
			
			objParameters.setMortgagees	= tbgMortgagee.getNewRowsAdded().concat(tbgMortgagee.getModifiedRows());//getAddedAndModifiedJSONObjects2(objMortgagees);
			objParameters.delMortgagees	= tbgMortgagee.getDeletedRows();//getDeletedJSONObjects(objMortgagees);

			for(attr in objParameters){
				if(objParameters[attr].length > 0){											
					executeSave = true;
					break;
				}
			}

			if(executeSave){
				new Ajax.Request(contextPath + "/GIPIParMortgageeController?action=saveMortgagee", {
				//new Ajax.Updater("mortgageeTable", contextPath + "/GIPIParMortgageeController?action=saveMortgagee", {
					method : "POST",
					parameters : {	
						parameters : JSON.stringify(objParameters),
						parId : objUWParList.parId,
						itemNo : objCurrItem.itemNo	},
					asynchronous : true,
					evalScripts : true,
					onCreate : function(){
						//showNotice("Saving, please wait...");
					},
					onComplete : function(response){
						if (checkErrorOnResponse(response)) {
							hideNotice(response.responseText);
							showMessageBox(objCommonMessage.SUCCESS, imgMessage.INFO);
							tbgMortgagee.clear();
							tbgMortgagee.refresh();
						}
					}
				});
			}else{
				showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
			}			
		}catch(e){
			showErrorMessage("saveMortgagee", e);
		}
	}

	//$("mortgageeName").observe("change", function(){
	//	$("mortgageeName").setAttribute("changed", "changed");
	//});
	
	
	$("chkDeleteSw").observe("change",function() {
		var morAmount = unformatCurrencyValue(nvl($("mortgageeAmount").value, 0));
		if ($("chkDeleteSw").checked == true){
			$("mortgageeAmount").value = (morAmount == 0 ? 0 : morAmount * -1);
			$("mortgageeAmount").setAttribute("min", '-9999999999999.99');
		}else{
			$("mortgageeAmount").value = (morAmount == 0 ? 0 : morAmount * -1); /* added by MarkS SR-5483,2743,3708 09.06.2016 */
			$("mortgageeAmount").setAttribute("min", '0');
		}
	});
	
	
	//initializeAll();
	initializeAllMoneyFields();
	addStyleToInputs();
	initializeChangeTagBehavior(changeTagFunc); 	
	
	setMortgageeFormTG(null);
}catch(e){
	showErrorMessage("Mortgagee Page", e);
}	
</script>