<div>
	<table style="margin:5px;">
		<tr>
			<td id="tdPrompTitle" class="rightAligned" style="padding-right: 5px;">prompt_title</td>
			<td colspan="4">
				<textArea id="txtContractProjBussTitle" name="txtContractProjBussTitle"cols="63" rows="1" style="resize: none; width: 400px;" readonly="readonly"/></textArea>				
			</td>
		</tr>
		<tr>
			<td id="tdPromptLoc" class="rightAligned" style="padding-right: 5px;">prompt_loc</td>
			<td colspan="4">
				<input type="text" id="txtSiteLocation" name="txtSiteLocation" style="width:400px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Construction Period</td>
			<td  class="rightAligned" style="width:50px; padding-right: 5px;">From</td>
			<td style="width:80px;">
				<input type="text" id="txtConstructionStartDate" name="txtConstructionStartDate" readonly="readonly" style="width: 120px;"/>
			</td>
			<td  class="rightAligned" style="width:85px; padding-right: 5px;">To</td>
			<td>
				<input type="text" id="txtConstructionEndDate" name="txtConstructionEndDate" readonly="readonly" style="width: 120px;"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Maintenance Period</td>
			<td class="rightAligned" style="padding-right: 5px;">From</td>
			<td>
				<input type="text" id="txtMaintenanceStartDate" name="txtMaintenanceStartDate" readonly="readonly" style="width: 120px;"/>
			</td>
			<td class="rightAligned" style="padding-right: 5px;">To</td>
			<td>
				<input type="text" id="txtMaintenanceEndDate" name="txtMaintenanceEndDate" readonly="readonly" style="width: 120px;"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">MBI Policy No</td>
			<td colspan="4">
				<input type="text" id="txtMbiPolicyNo" name="txtMbiPolicyNo" style="width:400px;" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="padding-right: 5px;">Weeks Test / Commissioning </td>
			<td colspan="2">
				<input type="text" id="txtWeeksTest" name="txtWeeksTest" style="width:150px;" readonly="readonly"/>
			</td>
			<td class="rightAligned" style="padding-right: 5px;">Time Excess</td>
			<td>
				<input type="text" id="txtTimeExcess" name="txtTimeExcess" readonly="readonly" style="width: 120px;"/>
			</td>
		</tr>
		<%-- removed by robert SR 20307 10.27.15	
		  <tr>
			  <td colspan="5">
				  <div style="text-align:center;margin:10px auto 10px auto;">
					  <!-- commented out and changed by reymon 11132013
					  <input type="button" class="button" id="btnBasicInfo" value="Item Information" style="margin:0px auto 0px auto;width:50%"/> -->
					  <input type="button" class="button" id="btnBasicInfo" value="Basic Information" style="margin:0px auto 0px auto;width:50%"/>
				  </div>
			  </td>
		  </tr> 
		--%>
	</table>
	<%-- added by robert SR 20307 10.27.15 --%>
	<div id="principalTGDiv" name="principalTGDiv" style="height: 140px; width: 98%;">
		<div id="divPrincipalTG"></div>
	</div>
	<div id="contractorTGDiv" name="contractorTGDiv" style="height: 135px; width: 98%;">
		<div id="divContractorTG"></div>
	</div>
	<div class="buttonsDiv" style="margin-bottom: 5px; margin-top: 5px;">
		<input type="button" class="button" id="btnBasicInfo" value="Basic Information" style="width:50%"  />
		<input type="hidden" id="sublineCdParam" name="sublineCdParam" />
	</div>
	<%-- end robert SR 20307 10.27.15 --%>
</div>
<script>
	var moduleId = $F("hidModuleId"); //added by Kris 02.25.2013
	
	var objPolicyAdditionalInfo = JSON.parse('${policyAdditionalInfo}'.replace(/\\/g, '\\\\'));
	$("txtContractProjBussTitle").value = unescapeHTML2(objPolicyAdditionalInfo.contractProjBussTitle);
	$("txtSiteLocation").value = unescapeHTML2(objPolicyAdditionalInfo.siteLocation);
	$("txtConstructionStartDate").value = objPolicyAdditionalInfo.constructStartDate;
	$("txtConstructionEndDate").value = objPolicyAdditionalInfo.constructEndDate;
	$("txtMaintenanceStartDate").value = objPolicyAdditionalInfo.maintainStartDate;
	$("txtMaintenanceEndDate").value = objPolicyAdditionalInfo.maintainEndDate;
	$("txtMbiPolicyNo").value = unescapeHTML2(objPolicyAdditionalInfo.mbiPolicyNo);
	$("txtWeeksTest").value = objPolicyAdditionalInfo.weeksTest;
	$("txtTimeExcess").value = objPolicyAdditionalInfo.timeExcess;
	$("tdPrompTitle").innerHTML = unescapeHTML2(objPolicyAdditionalInfo.promptTitle);
	$("tdPromptLoc").innerHTML = unescapeHTML2(objPolicyAdditionalInfo.promptLocation);
	$("sublineCdParam").value = unescapeHTML2(objPolicyAdditionalInfo.sublineCdParam); //added by robert SR 20307 10.27.15
	var policyId = objPolicyAdditionalInfo.policyId; //added by robert SR 20307 10.27.15
	var extractId = nvl(objPolicyAdditionalInfo.extractId,0); //added by robert SR 20307 10.27.15
	var summarySw = moduleId == "GIPIS101" ? "Y" : "N"; //added by robert SR 20307 10.27.15
	$("btnBasicInfo").observe("click", function(){
		overlayAdditionalInfo.close();
	});
	//added by robert SR 20307 10.27.15
	if($F("sublineCdParam") == "CONTRACTOR_ALL_RISK" || $F("sublineCdParam") == "CONTRACTORS_ALL_RISK") {
		document.getElementById("tdPrompTitle").innerHTML = 'Title of Contract';
		document.getElementById("tdPromptLoc").innerHTML = 'Location of Contract Site';
		$("principalTGDiv").show();
		$("contractorTGDiv").show();
	} else if ($F("sublineCdParam") == "ERECTION_ALL_RISK") {
		document.getElementById("tdPrompTitle").innerHTML = 'Project';
		document.getElementById("tdPromptLoc").innerHTML = 'Site of Erection';
		$("principalTGDiv").show();
		$("contractorTGDiv").show();
	} else if ($F("sublineCdParam") == "MACHINERY_LOSS_OF_PROFIT") {
		document.getElementById("tdPrompTitle").innerHTML = 'Nature of Business';
		document.getElementById("tdPromptLoc").innerHTML = 'The Premises';
		$("principalTGDiv").hide();
		$("contractorTGDiv").hide();
	} else if ($F("sublineCdParam") == "MACHINERY_BREAKDOWN_INSURANCE") {
		document.getElementById("tdPrompTitle").innerHTML = 'Nature of Business';
		document.getElementById("tdPromptLoc").innerHTML = 'Work Site';
		$("principalTGDiv").hide();
		$("contractorTGDiv").hide();
	} else if ($F("sublineCdParam") == "DETERIORATION_OF_STOCKS") {
		document.getElementById("tdPrompTitle").innerHwhaTML = 'Description';
		document.getElementById("tdPromptLoc").innerHTML = 'Location of Refrigeration Plant';
		$("principalTGDiv").hide();
		$("contractorTGDiv").hide();
	} else if ($F("sublineCdParam") == "BOILER_AND_PRESSURE_VESSEL" || $F("sublineCdParam") == "ELECTRONIC_EQUIPMENT") {
		document.getElementById("tdPrompTitle").innerHTML = 'Description';
		document.getElementById("tdPromptLoc").innerHTML = 'The Premises';
		$("principalTGDiv").hide();
		$("contractorTGDiv").hide();
	} else if ($F("sublineCdParam") == "PRINCIPAL_CONTROL_POLICY") {
		document.getElementById("tdPrompTitle").innerHTML = 'Description';
		document.getElementById("tdPromptLoc").innerHTML = 'Territorial Limits';
		$("principalTGDiv").hide();
		$("contractorTGDiv").hide();
	} else {
		document.getElementById("tdPrompTitle").innerHTML = 'Title';
		document.getElementById("tdPromptLoc").innerHTML = 'Location';
		$("principalTGDiv").hide();
		$("contractorTGDiv").hide();
	}
	
	try{
		if ($F("sublineCdParam") == "ERECTION_ALL_RISK" || $F("sublineCdParam") == "CONTRACTOR_ALL_RISK" || $F("sublineCdParam") == "CONTRACTORS_ALL_RISK") {
			var jsonPrincipal = JSON.parse('${principalTG}');
			var jsonContractor = JSON.parse('${contractorTG}');
			
			var viewPrincipalTableModel = {
					id: 1,
					url: contextPath+"/GIPIPolbasicController?action=refreshEnPrincipalContractorTG&principalType=P&policyId="+policyId+"&summarySw="+summarySw+"&extractId="+extractId,
					options : {
						hideColumnChildTitle: true,
						width : '588px',
						height : '131px',
						pager : {},
						onCellFocus : function(element, value, x, y, id) {
							tbgViewPrincipal.keys.removeFocus(tbgViewPrincipal.keys._nCurrentFocus, true);
							tbgViewPrincipal.keys.releaseKeys();
						},
						onRemoveRowFocus : function(element, value, x, y, id) {
							tbgViewPrincipal.keys.removeFocus(tbgViewPrincipal.keys._nCurrentFocus, true);
							tbgViewPrincipal.keys.releaseKeys();
						}
					},
					columnModel : [ {
						id : 'recordStatus',
						title : '',
						width : '0',
						visible : false
					}, {
						id : 'divCtrId',
						width : '0',
						visible : false
					}, {
						id: 'principalCd principalName',
							title: 'Principal',
							width: '553px',
							children: [
								{	id: 'principalCd',
									title: 'Principal Code',
									width: 100,
									align: 'right',
									sortable: false
								},
								{	id: 'principalName',
									title: 'Principal Name',
									width: 453,
									sortable: false
								}
							]
					  }, {
							id: 'subconSw',
					    	title: 'S',
					    	width: '23px',
				        	align: 'center',
				        	altTitle : 'Subcon Switch',
							titleAlign: 'center',
							sortable : true,
							editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) {
									if (value) {
										return "Y";
									} else {
										return "N";
									}
								}
							})
					}],
					resetChangeTag: true,
					rows: jsonPrincipal.rows
			};
			tbgViewPrincipal = new MyTableGrid(viewPrincipalTableModel);
			tbgViewPrincipal.pager = jsonPrincipal;
			tbgViewPrincipal.mtgId = 1;
			tbgViewPrincipal.render('divPrincipalTG');
			
			var viewContractorTableModel = {
					id: 2,
					url: contextPath+"/GIPIPolbasicController?action=refreshEnPrincipalContractorTG&principalType=C&policyId="+policyId+"&summarySw="+summarySw+"&extractId="+extractId,
					options : {
						hideColumnChildTitle: true,
						width : '588px',
						height : '131px',
						pager : {},
						onCellFocus : function(element, value, x, y, id) {
							tbgViewContractor.keys.removeFocus(tbgViewContractor.keys._nCurrentFocus, true);
							tbgViewContractor.keys.releaseKeys();
						},
						onRemoveRowFocus : function(element, value, x, y, id) {
							tbgViewContractor.keys.removeFocus(tbgViewContractor.keys._nCurrentFocus, true);
							tbgViewContractor.keys.releaseKeys();
						}
					},
					columnModel : [ {
						id : 'recordStatus',
						title : '',
						width : '0',
						visible : false
					}, {
						id : 'divCtrId',
						width : '0',
						visible : false
					}, {
						id: 'principalCd principalName',
						title: 'Contractor',
						width: '553px',
						children: [
							{	id: 'principalCd',
								title: 'Principal Code',
								width: 100,
								align: 'right',
								sortable: false
							},
							{	id: 'principalName',
								title: 'Principal Name',
								width: 453,
								sortable: false
							}
						]
					  }, {
							id: 'subconSw',
					    	title: 'S',
					    	width: '23px',
				        	align: 'center',
				        	altTitle : 'Subcon Switch',
							titleAlign: 'center',
							sortable : true,
							editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) {
									if (value) {
										return "Y";
									} else {
										return "N";
									}
								}
							})
					}],
					resetChangeTag: true,
					rows: jsonContractor.rows
			};
			tbgViewContractor = new MyTableGrid(viewContractorTableModel);
			tbgViewContractor.pager = jsonContractor;
			tbgViewContractor.mtgId = 2;
			tbgViewContractor.render('divContractorTG');
		}
	}catch (e){
		showErrorMessage("Principal/Contractor Table Grid", e);
	}
	//end robert SR 20307 10.27.15
	/* if (moduleId == "GIPIS101"){
		
	} */
	
</script>