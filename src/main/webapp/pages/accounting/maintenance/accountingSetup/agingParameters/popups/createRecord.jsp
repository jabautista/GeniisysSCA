<div id="createRecordMainDiv">
	<div id="createRecordFormDiv">
		<div id="copyToDiv" class="sectionDiv" style="width: 400px; margin-top: 7px;">
			<table>
				<tr>
					<td colspan="4" style="padding: 3px 0px 3px 15px;">Copy To</td>
				</tr>
				<tr>
					<td class="rightAligned" width="100">Fund Code</td>
					<td colspan="3">
						<span class="lovSpan required" style="float: left; width: 60px; margin-right: 5px; margin-top: 2px; height: 21px;">
							<input class="required" type="text" id="txtFundCdTo" maxlength="3" style="width: 35px; float: left; border: none; height: 15px; margin: 0;" maxlength="10" tabindex="201" lastValidValue=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgFundCdTo" name="imgFundCdTo" alt="Go" style="float: right;" tabindex="202"/>
						</span>
						<input type="text" id="txtFundDescTo" style="width: 180px; height: 15px;" tabindex="203"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Branch</td>
					<td colspan="3" style="padding-bottom: 5px;">
						<span class="lovSpan required" style="float: left; width: 60px; margin-right: 5px; margin-top: 2px; height: 21px;">
							<input class="required" type="text" id="txtBranchCdTo" maxlength="2" style="width: 35px; float: left; border: none; height: 15px; margin: 0;" maxlength="10" tabindex="204" lastValidValue=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgBranchCdTo" name="imgBranchCdTo" alt="Go" style="float: right;" tabindex="205"/>
						</span>
						<input type="text" id="txtBranchNameTo" style="width: 180px; height: 15px;" tabindex="206"/>
					</td>
				</tr>
			</table>
		</div>
		<div id="copyFromDiv" class="sectionDiv" style="width: 400px; margin-bottom: 7px;">
			<table>
				<tr>
					<td colspan="4" style="padding: 3px 0px 3px 15px;">Copy From</td>
				</tr>
				<tr>
					<td class="rightAligned" width="100">Fund Code</td>
					<td colspan="3">
						<span class="lovSpan required" style="float: left; width: 60px; margin-right: 5px; margin-top: 2px; height: 21px;">
							<input class="required" type="text" id="txtFundCdFrom" maxlength="3" style="width: 35px; float: left; border: none; height: 15px; margin: 0;" maxlength="10" tabindex="208" lastValidValue=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgFundCdFrom" name="imgFundCdFrom" alt="Go" style="float: right;" tabindex="209"/>
						</span>
						<input type="text" id="txtFundDescFrom" style="width: 180px; height: 15px;" tabindex="210"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Branch</td>
					<td colspan="3" style="padding-bottom: 5px;">
						<span class="lovSpan required" style="float: left; width: 60px; margin-right: 5px; margin-top: 2px; height: 21px;">
							<input class="required" type="text" id="txtBranchCdFrom" maxlength="2" style="width: 35px; float: left; border: none; height: 15px; margin: 0;" maxlength="10" tabindex="211" lastValidValue=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgBranchCdFrom" name="imgBranchCdFrom" alt="Go" style="float: right;" tabindex="212"/>
						</span>
						<input type="text" id="txtBranchNameFrom" style="width: 180px; height: 15px;" tabindex="213"/>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div style="text-align: center;">
		<input type="button" id="btnCopy" class="button" value="Copy" tabindex="214"/>
		<input type="button" id="btnCancel" class="button" value="Cancel" tabindex="215"/>
	</div>
</div>
<script type="text/JavaScript">	
try{
	function showGiacs310FundCdToLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "getGiacs310FundCdLOV",
							filterText : ($("txtFundCdTo").readAttribute("lastValidValue").trim() != $F("txtFundCdTo").trim() ? $F("txtFundCdTo").trim() : "%"),
							page : 1},
			title: "List of Fund Codes",
			width: 440,
			height: 386,
			columnModel : [
							{
								id : "gibrGfunFundCd",
								title: "Fund Code",
								width: '100px',
								filterOption: true
							},
							{
								id : "fundDesc",
								title: "Fund Desc",
								width: '325px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtFundCdTo").readAttribute("lastValidValue").trim() != $F("txtFundCdTo").trim() ? $F("txtFundCdTo").trim() : ""),
				onSelect: function(row) {
					$("txtFundCdTo").value = row.gibrGfunFundCd;
					$("txtFundDescTo").value = row.fundDesc;
					$("txtFundCdTo").setAttribute("lastValidValue", row.gibrGfunFundCd);	
					$("txtBranchCdTo").focus();
				},
				onCancel: function (){
					$("txtFundCdTo").value = $("txtFundCdTo").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtFundCdTo").value = $("txtFundCdTo").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
		
	$("imgFundCdTo").observe("click", showGiacs310FundCdToLOV);
	$("txtFundCdTo").observe("keyup", function(){
		$("txtFundCdTo").value = $F("txtFundCdTo").toUpperCase();
	});
	$("txtFundCdTo").observe("change", function() {
		if($F("txtFundCdTo").trim() == "") {
			$("txtFundCdTo").value = "";
			$("txtFundCdTo").setAttribute("lastValidValue", "");
			$("txtFundDescTo").value = "";
		} else {
			if($F("txtFundCdTo").trim() != "" && $F("txtFundCdTo") != $("txtFundCdTo").readAttribute("lastValidValue")) {
				showGiacs310FundCdToLOV();
			}
		}
	});
	
	function showGiacs310FundCdFromLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "getGiacs310FundCdLOV",
							filterText : ($("txtFundCdFrom").readAttribute("lastValidValue").trim() != $F("txtFundCdFrom").trim() ? $F("txtFundCdFrom").trim() : "%"),
							page : 1},
			title: "List of Fund Codes",
			width: 440,
			height: 386,
			columnModel : [
							{
								id : "gibrGfunFundCd",
								title: "Fund Code",
								width: '100px',
								filterOption: true
							},
							{
								id : "fundDesc",
								title: "Fund Desc",
								width: '325px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtFundCdFrom").readAttribute("lastValidValue").trim() != $F("txtFundCdFrom").trim() ? $F("txtFundCdFrom").trim() : ""),
				onSelect: function(row) {
					$("txtFundCdFrom").value = row.gibrGfunFundCd;
					$("txtFundDescFrom").value = row.fundDesc;
					$("txtFundCdFrom").setAttribute("lastValidValue", row.gibrGfunFundCd);	
					$("txtBranchCdFrom").focus();
				},
				onCancel: function (){
					$("txtFundCdFrom").value = $("txtFundCdFrom").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtFundCdFrom").value = $("txtFundCdFrom").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
		
	$("imgFundCdFrom").observe("click", showGiacs310FundCdFromLOV);
	$("txtFundCdFrom").observe("keyup", function(){
		$("txtFundCdFrom").value = $F("txtFundCdFrom").toUpperCase();
	});
	$("txtFundCdFrom").observe("change", function() {
		if($F("txtFundCdFrom").trim() == "") {
			$("txtFundCdFrom").value = "";
			$("txtFundCdFrom").setAttribute("lastValidValue", "");
			$("txtFundDescFrom").value = "";
		} else {
			if($F("txtFundCdFrom").trim() != "" && $F("txtFundCdFrom") != $("txtFundCdFrom").readAttribute("lastValidValue")) {
				showGiacs310FundCdFromLOV();
			}
		}
	});
	
	function showGiacs310BranchCdToLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "getGiacs310BranchCdToLOV",
							moduleId : "GIACS310",
							filterText : ($("txtBranchCdTo").readAttribute("lastValidValue").trim() != $F("txtBranchCdTo").trim() ? $F("txtBranchCdTo").trim() : "%"),
							page : 1},
			title: "List of Branch Codes",
			width: 440,
			height: 386,
			columnModel : [
							{
								id : "gibrBranchCd",
								title: "Issue Code",
								width: '100px',
								filterOption: true
							},
							{
								id : "branchName",
								title: "Issue Source Name",
								width: '325px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtBranchCdTo").readAttribute("lastValidValue").trim() != $F("txtBranchCdTo").trim() ? $F("txtBranchCdTo").trim() : ""),
				onSelect: function(row) {
					$("txtBranchCdTo").value = row.gibrBranchCd;
					$("txtBranchNameTo").value = row.branchName;
					$("txtBranchCdTo").setAttribute("lastValidValue", row.gibrBranchCd);	
				},
				onCancel: function (){
					$("txtBranchCdTo").value = $("txtBranchCdTo").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtBranchCdTo").value = $("txtBranchCdTo").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
		
	$("imgBranchCdTo").observe("click", showGiacs310BranchCdToLOV);
	$("txtBranchCdTo").observe("keyup", function(){
		$("txtBranchCdTo").value = $F("txtBranchCdTo").toUpperCase();
	});
	$("txtBranchCdTo").observe("change", function() {
		if($F("txtBranchCdTo").trim() == "") {
			$("txtBranchCdTo").value = "";
			$("txtBranchCdTo").setAttribute("lastValidValue", "");
			$("txtBranchName").value = "";
		} else {
			if($F("txtBranchCdTo").trim() != "" && $F("txtBranchCdTo") != $("txtBranchCdTo").readAttribute("lastValidValue")) {
				showGiacs310BranchCdToLOV();
			}
		}
	});
	
	function showGiacs310BranchCdFromLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "getGiacs310BranchCdFromLOV",
							moduleId : "GIACS310",
							filterText : ($("txtBranchCdFrom").readAttribute("lastValidValue").trim() != $F("txtBranchCdFrom").trim() ? $F("txtBranchCdFrom").trim() : "%"),
							page : 1},
			title: "List of Branch Codes",
			width: 440,
			height: 386,
			columnModel : [
							{
								id : "gibrBranchCd",
								title: "Issue Code",
								width: '100px',
								filterOption: true
							},
							{
								id : "branchName",
								title: "Issue Source Name",
								width: '325px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtBranchCdFrom").readAttribute("lastValidValue").trim() != $F("txtBranchCdFrom").trim() ? $F("txtBranchCdFrom").trim() : ""),
				onSelect: function(row) {
					$("txtBranchCdFrom").value = row.gibrBranchCd;
					$("txtBranchNameFrom").value = row.branchName;
					$("txtBranchCdFrom").setAttribute("lastValidValue", row.gibrBranchCd);	
				},
				onCancel: function (){
					$("txtBranchCdFrom").value = $("txtBranchCdFrom").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtBranchCdFrom").value = $("txtBranchCdFrom").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
		
	$("imgBranchCdFrom").observe("click", showGiacs310BranchCdFromLOV);
	$("txtBranchCdFrom").observe("keyup", function(){
		$("txtBranchCdFrom").value = $F("txtBranchCdFrom").toUpperCase();
	});
	$("txtBranchCdFrom").observe("change", function() {
		if($F("txtBranchCdFrom").trim() == "") {
			$("txtBranchCdFrom").value = "";
			$("txtBranchCdFrom").setAttribute("lastValidValue", "");
			$("txtBranchName").value = "";
		} else {
			if($F("txtBranchCdFrom").trim() != "" && $F("txtBranchCdFrom") != $("txtBranchCdFrom").readAttribute("lastValidValue")) {
				showGiacs310BranchCdFromLOV();
			}
		}
	});
	
	function copyRecords(){
		try{
			if(checkAllRequiredFieldsInDiv("createRecordFormDiv")){
				new Ajax.Request(contextPath+"/GIACAgingParametersController?action=copyRecords",{
					parameters:{
						fundCdFrom : $F("txtFundCdFrom"),
						branchCdFrom : $F("txtBranchCdFrom"),
						fundCdTo : $F("txtFundCdTo"),
						branchCdTo : $F("txtBranchCdTo")
					},
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Creating record..."), 
					onComplete: function(response){
						hideNotice("");
						showWaitingMessageBox("Changes have been made.", "I", function(){
							tbgAgingParameters.url = contextPath + "/GIACAgingParametersController?action=showGiacs310&refresh=1&moduleId=GIACS310";
							tbgAgingParameters._refreshList();
							createRecordsOverlay.close();
						});
					}
				});
			}
		}catch(e){
			showErrorMessage("copyRecords", e);
		}
	}
	
	$("btnCopy").observe("click", copyRecords);
	$("btnCancel").observe("click", function(){
		createRecordsOverlay.close();
	});
}catch(e){
	showErrorMessage("createRecord.jsp", e);
}
</script>