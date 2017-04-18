<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="signorsMainDiv" name="signorsMainDiv" class="sectionDiv" style="">
	
	<div id="coSignorsListingDiv" name="coSignorsListingDiv" style="margin: 10px; margin-bottom: 0px;">
		<div class="tableHeader">
					<label style="width: 50%; text-align: left; margin-left: 5px;">Co-Signatory</label>
					<label style="width: 15%; text-align: center">Bonds</label>
					<label style="width: 15%; text-align: center">Indemnity</label>
					<label style="width: 15%; text-align: center">RI Agreement</label>
		</div>
		<div id="searchResultSignors" align="center">
			<div style="width: 100%; margin-bottom: 0px;" id="signorsTable" name="signorsTable">
				<div id="signorsListDiv" name="signorsListDiv" class="tableContainer">
					
				</div>
			</div>
		</div>
	</div>

	<div changeTagAttr="true" id="addSignorDiv" name="addSignorDiv" align="center" style="margin-bottom: 5px;">
		<table align="center" border="0" style="margin-top: 10px; width: 99%;">
			<tr style="width: 88%;">
				<td class="leftAligned" style="width: 44%;">
					<select id="selDspPrinSignor" name="selDspPrinSignor" style="width: 98%">
						<option value="" designation="" cosignName=""></option>
						<c:forEach var="cs" items="${cosignNames}" varStatus="ctr">
							<option value="${cs.cosignId}" designation="${cs.designation}" cosignName="${cs.cosignName}" assdNo="${cs.assdNo}">${fn:escapeXml(cs.cosignName)}</option>
						</c:forEach>
					</select>
				</td>
				<td style="width: 15%; text-align: center;  padding-left: 3px;">
					<input type="checkbox" id="bondsFlag" name="bondsFlag" style="margin-left: 3px;" title="Bonds" value="Y" checked="checked"/>
				</td>
				<td style="width: 15%; padding-left: 50px;">
					<input type="checkbox" id="indemFlag" name="indemFlag" style="margin-left: 3px;" title="Indemnity" value="Y" checked="checked"/>
				</td>
				<td style="width: 15%; padding-left: 35px;">
					<input type="checkbox" id="bondsRiFlag" name="bondsRiFlag" style="margin-left: 3px;" title="RI Agreement" value="Y" checked="checked"/>
				</td>
			</tr>
			<tr>
				<td style="text-align: center; width: 100%;" colspan="4">	<!-- colspan="2" -->
					<input type="button" id="btnAdd" name="btnAdd" class="button noChangeTagAttr" value="Add" />
					<input type="button" id="btnDelete" name="btnDelete" class="button noChangeTagAttr" value="Delete"/>
				</td>
			</tr>
		</table>
	</div>
</div>
<script type="text/javaScript">
	initializeAccordion();
	disableButton("btnDelete");
	objMKTG.cosignsJSON = JSON.parse('${cosignsJSON}'.replace(/\\/g, '\\\\')); 
	objMKTG.cosigns = {};

	function prepareCosignList(obj){
		try{
			var cosign = '<label style="width: 50%; text-align: left; margin-left: 5px;">'+nvl(changeSingleAndDoubleQuotes(obj.cosignName).truncate(50, "..."),'-')+'</label>'+
						 '<label style="width: 15%; text-align: center">'+("Y" == obj.bondsFlag ? '<img name="checkedImg" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 49%; text-align: center;" />' :'<span style="text-align:center; width: 10px; height: 10px;">-</span>')+'</label>'+
						 '<label style="width: 15%; text-align: center">'+("Y" == obj.indemFlag ? '<img name="checkedImg" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 49%; text-align: center;" />' :'<span style="text-align:center; width: 10px; height: 10px;">-</span>')+'</label>'+
						 '<label style="width: 15%; text-align: center">'+("Y" == obj.bondsRiFlag ? '<img name="checkedImg" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 49%; text-align: center;" />' :'<span style="text-align:center; width: 10px; height: 10px;">-</span>')+'</label>';
			return cosign;	
		}catch(e){
			showErrorMessage("prepareCosignList", e);
		}	
	}
	
	function showCosignList(objArray){
		try{
			var tableContainer = $("signorsListDiv");
			for(var a=0; a<objArray.length; a++){
				var content = prepareCosignList(objArray[a]);
				var newDiv = new Element("div");
				objArray[a].divCtrId = a;
				objArray[a].recordStatus = null;
				newDiv.setAttribute("id", "rowCosign"+a);
				newDiv.setAttribute("name", "rowCosign");
				newDiv.addClassName("tableRow");
				newDiv.update(content);
				tableContainer.insert({bottom : newDiv});
			}	
		}catch(e){
			showErrorMessage("showCosignList", e);
		}	
	}
	
	//to show/generate the table listing
	showCosignList(objMKTG.cosignsJSON);

	//create observe on list
	$$("div#signorsListDiv div[name=rowCosign]").each(function(row){
		row.observe("mouseover", function(){
			row.addClassName("lightblue");
		});
		row.observe("mouseout", function(){
			row.removeClassName("lightblue");
		});
		row.observe("click", function(){
			row.toggleClassName("selectedRow");
			if (row.hasClassName("selectedRow")){
				$$("div#signorsListDiv div[name=rowCosign]").each(function(r){
					if (row.getAttribute("id") != r.getAttribute("id")){
						r.removeClassName("selectedRow");
					}else{
						getDefaults();
						var id = (row.readAttribute("id")).substring(row.readAttribute("name").length);
						for(var a=0; a<objMKTG.cosignsJSON.length; a++){
							if (objMKTG.cosignsJSON[a].divCtrId == id){
								supplyCosign(objMKTG.cosignsJSON[a]);
							}
						}
					}	
				});
			}else{
				clearForm();
			}		
		});	
	});
	
	//get the default value
	function getDefaults(){
		try{
			$("btnAdd").value = "Update";
			enableButton("btnDelete");
		}catch(e){
			showErrorMessage("getDefaults", e);
		}
	}

	function supplyCosign(obj){
		try{
			$("selDspPrinSignor").value = nvl(obj.cosignId, "");
			$("bondsFlag").checked		= (obj.bondsFlag == "Y" ? true :false);
			$("indemFlag").checked		= (obj.indemFlag == "Y" ? true :false);
			$("bondsRiFlag").checked	= (obj.bondsRiFlag == "Y" ? true :false);
			objMKTG.cosigns.recordStatus		= nvl(obj.recordStatus,null);
			objMKTG.cosigns.assdNo 				= nvl(obj.assdNo,$F("assuredNo"));
			objMKTG.cosigns.quoteId				= nvl(obj.quoteId,$F("quoteId"));
			objMKTG.cosigns.cosignName			= changeSingleAndDoubleQuotes(nvl(obj.cosignName,""));
			
			filterJSONLOV("selDspPrinSignor", $("selDspPrinSignor").value, objMKTG.cosignsJSON, "cosignId");
		}catch(e){
			showErrorMessage("supplyCosign", e);
		}	
	}

	//to clear the form inputs
	function clearForm(){
		try{
			$("selDspPrinSignor").clear();
			$("bondsFlag").checked		= true;
			$("indemFlag").checked		= true;	
			$("bondsRiFlag").checked	= true;	
			objMKTG.cosigns.recordStatus 		= null;
			objMKTG.cosigns.assdNo				= null;
			objMKTG.cosigns.quoteId				= null;
			objMKTG.cosigns.cosignName			= null;
			
			deselectRows("signorsListDiv","rowCosign");	
			$("btnAdd").value = "Add";
			enableButton("btnAdd");
			disableButton("btnDelete");
		}catch(e){
			showErrorMessage("clearForm", e);
		}
	}

	//create new Object to be added on Object Array
	function setCosignObject(){
		try {
			var newObj 					= new Object();
			newObj.recordStatus			= objMKTG.cosigns.recordStatus;
			newObj.quoteId				= $F("quoteId");
			newObj.cosignId				= $F("selDspPrinSignor");
			newObj.cosignName			= changeSingleAndDoubleQuotes2(getListTextValue("selDspPrinSignor"));
			newObj.assdNo				= $F("assuredNo");
			newObj.indemFlag			= $("indemFlag").checked ? "Y" :"N";
			newObj.bondsFlag			= $("bondsFlag").checked ? "Y" :"N";
			newObj.bondsRiFlag			= $("bondsRiFlag").checked ? "Y" :"N";
			return newObj; 
		}catch(e){
			showErrorMessage("setLossesRecovObject", e);
		}
	}	
	
	//when Add/Update button click
	$("btnAdd").observe("click", function(){
		addCosign();
	});

	function deleteUpdatedCosign(){
		$$("div[name='rowCosign']").each(function(row){
			if (row.hasClassName("selectedRow")){
				var id = (row.readAttribute("id")).substring(row.readAttribute("name").length);
				for(var a=0; a<objMKTG.cosignsJSON.length; a++){
					if (objMKTG.cosignsJSON[a].divCtrId == id){
						var delObj = objMKTG.cosignsJSON[a];
						addDeletedJSONObjectAccounting(objMKTG.cosignsJSON, delObj);
					}
				}
			}
		});
	}	
	
	//function to add record
	function addCosign(){
		try{
			//check required fields first
			if ($F("selDspPrinSignor").blank()){
				customShowMessageBox("Please select a co-signatory first.", imgMessage.ERROR , "selDspPrinSignor");
				return;
			}

			var newObj  = setCosignObject();
			var content = prepareCosignList(newObj);
			if ($F("btnAdd") == "Update"){
				//on UPDATE records
				deleteUpdatedCosign(); //kunin ang record na iuupdate for deletion
				newObj.divCtrId = getSelectedRowId("rowCosign");
				$("rowCosign"+newObj.divCtrId).update(content);	
				//addModifiedJSONObjectAccounting(objMKTG.cosignsJSON, newObj);
				addNewJSONObject(objMKTG.cosignsJSON, newObj);
			}else{
				//on ADD records
				var tableContainer = $("signorsListDiv");
				var newDiv = new Element("div");
				newObj.divCtrId = generateDivCtrId(objMKTG.cosignsJSON);
				addNewJSONObject(objMKTG.cosignsJSON, newObj);
				newDiv.setAttribute("id", "rowCosign"+newObj.divCtrId);
				newDiv.setAttribute("name", "rowCosign");
				newDiv.addClassName("tableRow");
				newDiv.update(content);
				tableContainer.insert({bottom : newDiv});

				newDiv.observe("mouseover", function ()	{
					newDiv.addClassName("lightblue");
				});
				
				newDiv.observe("mouseout", function ()	{
					newDiv.removeClassName("lightblue");
				});

				newDiv.observe("click", function(){
					newDiv.toggleClassName("selectedRow");
					if (newDiv.hasClassName("selectedRow")){
						$$("div#signorsListDiv div[name=rowCosign]").each(function(r){
							if (newDiv.getAttribute("id") != r.getAttribute("id")){
								r.removeClassName("selectedRow");
							}else{
								getDefaults();
								var id = (r.readAttribute("id")).substring(r.readAttribute("name").length);
								for(var a=0; a<objMKTG.cosignsJSON.length; a++){
									if (objMKTG.cosignsJSON[a].divCtrId == id){
										supplyCosign(objMKTG.cosignsJSON[a]);
									}
								}
							}
						});
					}else{
						clearForm();
					}	
				});

				Effect.Appear(newDiv, {
					duration: .5, 
					afterFinish: function(){
						checkTableItemInfo("signorsTable","signorsListDiv","rowCosign");
					}
				});
			}	
			clearForm();
			changeCheckImageColor();
			changeTag = 1;
			filterJSONLOV("selDspPrinSignor", $("selDspPrinSignor").value, objMKTG.cosignsJSON, "cosignId");
		}catch(e){
			showErrorMessage("addCosign", e);
		}
	}

	//when DELETE button click
	$("btnDelete").observe("click",function(){
		deleteCosign();
	});

	//function to delete record
	function deleteCosign(){
		$$("div[name='rowCosign']").each(function(row){
			if (row.hasClassName("selectedRow")){
				var id = (row.readAttribute("id")).substring(row.readAttribute("name").length);
				for(var a=0; a<objMKTG.cosignsJSON.length; a++){
					if (objMKTG.cosignsJSON[a].divCtrId == id){
						var delObj = objMKTG.cosignsJSON[a];
						Effect.Fade(row,{
							duration: .5,
							afterFinish: function(){
								addDeletedJSONObjectAccounting(objMKTG.cosignsJSON, delObj);
								row.remove();
								clearForm();
								checkTableItemInfo("signorsTable","signorsListDiv","rowCosign");
								changeTag = 1;
								filterJSONLOV("selDspPrinSignor", $("selDspPrinSignor").value, objMKTG.cosignsJSON, "cosignId");
							}
						});	
					}
				}
			}
		});	
	}

	filterJSONLOV("selDspPrinSignor", $("selDspPrinSignor").value, objMKTG.cosignsJSON, "cosignId");
	
	changeCheckImageColor();
	clearForm();
	objMKTG.cosigns.clearForm = clearForm;
	$("cosignorsPageChangedSw").value = "Y";
	checkTableItemInfo("signorsTable","signorsListDiv","rowCosign");
	initializeChangeTagBehavior(changeTagFunc); 
</script>