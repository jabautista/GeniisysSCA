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
				<td style="padding-right: 5px;"><label for="txtAreaCd" style="float: right;">Area</label></td>
				<td>
					<span class="lovSpan" style="width: 65px; margin-bottom: 0;">
						<input type="text" id="txtAreaCd" style="width: 40px; float: left;" class="withIcon integerNoNegative" />  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgArea" alt="Go" style="float: right;" />
					</span>
				</td>
				<td>
					<input type="text" id="txtAreaDesc" style="width: 250px; height: 14px;" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td style="padding-right: 5px;"><label for="txtBranchCd" style="float: right;">Branch</label></td>
				<td>
					<span class="lovSpan" style="width: 65px; margin-bottom: 0;">
						<input type="text" id="txtBranchCd" style="width: 40px; float: left;" class="withIcon integerNoNegative" />  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgBancBranch" alt="Go" style="float: right;" />
					</span>
				</td>
				<td>
					<input type="text" id="txtBranchDesc" style="width: 250px; height: 14px;" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td style="padding-right: 5px;"><label for="txtManagerCd" style="float: right;">Manager</label></td>
				<td>
					<input type="text" id="txtManagerCd" style="width: 59px; height: 14px;" readonly="readonly"/>
				</td>
				<td>
					<input type="text" id="txtManagerName" style="width: 250px; height: 14px;" readonly="readonly"/>
				</td>
			</tr>
		</table>
	</div>
	<div style="float : none; text-align: center;">
		<input type="button" class="button" id="btnOk" value="Ok" style="width: 100px; margin-top: 20px; margin-right: -50px;"/>
		<img src="${pageContext.request.contextPath}/images/misc/history.PNG" id="imgBancassuranceHistory" alt="Go" style="float: right; height: 40px; width: 40px; margin-top: 10px; margin-right: 10px;" />
	</div>
</div>
<script>
	try {
		
		$("txtAreaCd").value = objGIPIS156.areaCd;
		$("txtAreaDesc").value = unescapeHTML2(objGIPIS156.areaDesc);
		$("txtBranchCd").value = objGIPIS156.branchCd;
		$("txtBranchDesc").value = unescapeHTML2(objGIPIS156.branchDesc);
		$("txtManagerCd").value = objGIPIS156.managerCd;
		$("txtManagerName").value = unescapeHTML2(objGIPIS156.managerName);
		
		function showBancassuranceHistory () {
			try {
				overBancassuranceHistory = 
					Overlay.show(contextPath+"/UpdateUtilitiesController", {
						urlContent: true,
						urlParameters: {action : "showBancassuranceHistory",																
										ajax : "1",
										policyId : objGIPIS156.policyId
										
						},
					    title: "Bancassurance History",
					    height: 370,
					    width: 700,
					    draggable: true
					});
				} catch (e) {
					showErrorMessage("Overlay error: " , e);
				}
		}
		
		function getGIPIS156BancAreaLOV(){
			onLOV = true;
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGIPIS156BancAreaLOV",
					//searchString : $("txtFreeText").value,
					page : 1
				},
				title : "Bancassurance Area",
				width : 480,
				height : 386,
				columnModel : [
				    {
						id : "areaCd",
						title : "Area Code",
						width : '150px'
					},
					{
						id : "areaDesc",
						title : "Area Description",
						width : '315px'
					} 
				],
				draggable : true,
				autoSelectOneRecord: true,
				//filterText:  $("txtFreeText").value,
				onSelect : function(row) {
					objGIPIS156.areaCd = row.areaCd;
					objGIPIS156.areaDesc = row.areaDesc;
					$("txtAreaCd").value = objGIPIS156.areaCd;
					$("txtAreaDesc").value = unescapeHTML2(objGIPIS156.areaDesc);
					
					objGIPIS156.branchCd = null;
					objGIPIS156.branchDesc = null; 
					objGIPIS156.managerCd = null;
					objGIPIS156.managerName = null;
					$("txtBranchCd").clear();
					$("txtBranchDesc").clear();
					$("txtManagerCd").clear();
					$("txtManagerName").clear();
					
					onLOV = false;
					objGIPIS156.changeTag = true;
				},
				onCancel : function () {
					onLOV = false;
					//$("txtFreeText").focus();
				},
				onUndefinedRow : function(){
					//customShowMessageBox("No record selected.", imgMessage.INFO, "txtFreeText");
					onLOV = false;
				}
			});
		}
		
		function getGIPIS156BancBranchLOV(){
			onLOV = true;
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGIPIS156BancBranchLOV",
					areaCd : $F("txtAreaCd"),
					//searchString : $("txtFreeText").value,
					page : 1
				},
				title : "Bancassurance Branch",
				width : 480,
				height : 386,
				columnModel : [
				    {
						id : "branchCd",
						title : "Branch Code",
						width : '150px'
					},
					{
						id : "branchDesc",
						title : "Branch Description",
						width : '315px'
					} 
				],
				draggable : true,
				autoSelectOneRecord: true,
				//filterText:  $("txtFreeText").value,
				onSelect : function(row) {
					objGIPIS156.branchCd = row.branchCd;
					objGIPIS156.branchDesc = row.branchDesc; 
					objGIPIS156.managerCd = row.managerCd;
					objGIPIS156.managerName = row.managerName;
					$("txtBranchCd").value = objGIPIS156.branchCd;
					$("txtBranchDesc").value = unescapeHTML2(objGIPIS156.branchDesc);
					$("txtManagerCd").value = objGIPIS156.managerCd;
					$("txtManagerName").value = unescapeHTML2(objGIPIS156.managerName);
					onLOV = false;
					objGIPIS156.changeTag = true;
				},
				onCancel : function () {
					onLOV = false;
					//$("txtFreeText").focus();
				},
				onUndefinedRow : function(){
					//customShowMessageBox("No record selected.", imgMessage.INFO, "txtFreeText");
					onLOV = false;
				}
			});
		}
		
		$("txtAreaCd").observe("keypress", function(event){
			if(event.keyCode == 0 || event.keyCode == 46 || event.keyCode == 8){
				objGIPIS156.changeTag = true;
				objGIPIS156.branchCd = null;
				objGIPIS156.branchDesc = null; 
				objGIPIS156.managerCd = null;
				objGIPIS156.managerName = null;
				objGIPIS156.areaCd = null;
				objGIPIS156.areaDesc = null;
				$("txtAreaDesc").clear();
				$("txtBranchCd").clear();
				$("txtBranchDesc").clear();
				$("txtManagerCd").clear();
				$("txtManagerName").clear();
			}
		});
		
		$("txtBranchCd").observe("keypress", function(event){
			if(event.keyCode == 0 || event.keyCode == 46 || event.keyCode == 8){
				objGIPIS156.changeTag = true;
				objGIPIS156.branchCd = null;
				objGIPIS156.branchDesc = null; 
				objGIPIS156.managerCd = null;
				objGIPIS156.managerName = null;
				//$("txtBranchCd").clear();
				$("txtBranchDesc").clear();
				$("txtManagerCd").clear();
				$("txtManagerName").clear();
			}
		});
		
		$("txtAreaCd").observe("change", function(){
			if(this.value == "")
				return;
			
			new Ajax.Request(contextPath+"/UpdateUtilitiesController",{
				method: "POST",
				parameters: {
						     action : "validateGIPIS156AreaCd",
						     areaCd : $F("txtAreaCd")
						     
				},
				asynchronous: false,
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						if(trim(response.responseText) == "NO DATA"){
							$("txtAreaCd").clear();
							getGIPIS156BancAreaLOV();
						} else {
							objGIPIS156.areaCd = $F("txtAreaCd");
							objGIPIS156.areaDesc = trim(response.responseText);
							$("txtAreaCd").value = objGIPIS156.areaCd;
							$("txtAreaDesc").value = unescapeHTML2(objGIPIS156.areaDesc);
							objGIPIS156.branchCd = null;
							objGIPIS156.branchDesc = null; 
							objGIPIS156.managerCd = null;
							objGIPIS156.managerName = null;
							$("txtBranchCd").clear();
							$("txtBranchDesc").clear();
							$("txtManagerCd").clear();
							$("txtManagerName").clear();
						}
					}
				}
			});
		});
		
		$("txtBranchCd").observe("change", function(){
			if(this.value == "")
				return;
			
			new Ajax.Request(contextPath+"/UpdateUtilitiesController",{
				method: "POST",
				parameters: {
						     action : "validateGIPIS156BancBranchCd",
						     areaCd : $F("txtAreaCd"),
						     branchCd : $F("txtBranchCd")
						     
				},
				asynchronous: false,
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						var res = JSON.parse(response.responseText);
						if(trim(res.branchDesc) == "NO DATA"){
							objGIPIS156.branchCd = null;
							objGIPIS156.branchDesc = null; 
							objGIPIS156.managerCd = null;
							objGIPIS156.managerName = null;
							$("txtBranchCd").clear();
							$("txtBranchDesc").clear();
							$("txtManagerCd").clear();
							$("txtManagerName").clear();
							getGIPIS156BancBranchLOV();
						} else {
							objGIPIS156.branchCd = res.branchCd;
							objGIPIS156.branchDesc = res.branchDesc; 
							objGIPIS156.managerCd = res.managerCd;
							objGIPIS156.managerName = res.managerName;
							$("txtBranchCd").value = objGIPIS156.branchCd;
							$("txtBranchDesc").value = unescapeHTML2(objGIPIS156.branchDesc);
							$("txtManagerCd").value = objGIPIS156.managerCd;
							$("txtManagerName").value = unescapeHTML2(objGIPIS156.managerName);
							objGIPIS156.changeTag = true;
						}
					}
				}
			});
		});
		
		$("imgArea").observe("click", getGIPIS156BancAreaLOV);
		$("imgBancBranch").observe("click", getGIPIS156BancBranchLOV);
		$("imgBancassuranceHistory").observe("click", showBancassuranceHistory);
		$("btnOk").observe("click", function(){
			overBancassuranceDetails.close();
			delete overBancassuranceDetails;
		});
		
		initializeAll();
		
	} catch (e) {
		showMessageBox("Error in Bancassurance Details " + e, imgMessage.ERROR);
	}
</script>