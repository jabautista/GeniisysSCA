<div id="agingDetailsDir" style="width: 95%; margin-top: 5px;">
	<div class="sectionDiv" style="padding: 10px 0 10px 10px; height: 190px; width: 101.6%;">
		<table align="center" style="margin-left: 20px; margin-top: 40px; margin-bottom: 0px;">
			<tr>
				<td>
					<input type="radio" id="billsRG" name="dirRG" value="Bills" style="margin-left: 15px; float: left;" checked="checked"/>
					<label for="billsRG" style="margin-top: 3px;">Bills (current assured and age level)</label>
				</td>
			</tr>
			<tr>
				<td style="padding-top: 5px;">
					<input type="radio" id="ageLevelsRG" name="dirRG" value="Age Level" style="margin-left: 15px; float: left;" checked="checked"/>
					<label for="ageLevelsRG" style="margin-top: 3px;">Age Levels for this Assured</label>
				</td>
			</tr>
			<tr>
				<td style="padding-top: 5px;">
					<input type="radio" id="billAcrossRG" name="dirRG" value="Bills Across" style="margin-left: 15px; float: left;" checked="checked"/>
					<label for="billAcrossRG" style="margin-top: 3px;">Bills (current assured across all age levels)</label>
				</td>
			</tr>
		</table>
	</div>
	<center>
		<input type="button" class="button" value="Ok" id="btnOk" style="margin-top: 5px; width: 100px;" />
		<input type="button" class="button" value="Cancel" id="btnCancel" style="margin-top: 5px; width: 100px;" />
	</center>
	<div>
		<input id="fundCd"     type="hidden"  value="${fundCd}"/>
		<input id="branchCd"   type="hidden"  value="${branchCd}"/>
		<input id="agingId"    type="hidden"  value="${agingId}"/>
		<input id="assdNo"     type="hidden"  value="${assdNo}"/>
		<input id="fundDesc"   type="hidden"  value="${fundDesc}"/>
		<input id="branchName" type="hidden"  value="${branchName}"/>
	</div>
</div>
<script type="text/javascript">
try{
	$("btnOk").observe("click", function(){
		if($("billsRG").checked){
			checkUserAccess("GIACS203");
		} else if ($("ageLevelsRG").checked){
			checkUserAccess("GIACS206");
		} else if ($("billAcrossRG").checked){
			checkUserAccess("GIACS207");
		}
	});
	
	function checkUserAccess(moduleId){
		try{
			new Ajax.Request(contextPath+"/GIACAccTransController?action=checkUserAccess2", {
				method: "POST",
				parameters: {
					moduleName: moduleId
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(response.responseText == 0){
						showWaitingMessageBox('You are not allowed to access this module.', imgMessage.ERROR, 
								function(){
							overlayShowDetailsDirOverlay.close();
							delete overlayShowDetailsDirOverlay;
						});  
					} else {
						if(moduleId == "GIACS203"){
							showGIACS203("GIACS202", "", $F("fundCd"), $F("branchCd"), $F("branchCd"), $F("agingId"), $F("agingId"), $F("assdNo"), $F("fundDesc"), $F("branchName"));
							overlayShowDetailsDirOverlay.close();
							delete overlayShowDetailsDirOverlay;
						} else if(moduleId == "GIACS206"){
							showGIACS206($F("fundCd"),$F("branchCd"),$F("agingId"),$F("assdNo"), $F("fundDesc"), $F("branchName"));
							overlayShowDetailsDirOverlay.close();
							delete overlayShowDetailsDirOverlay;
						} else if(moduleId == "GIACS207"){
							showGIACS207($F("fundCd"), $F("branchCd"), $F("agingId"), $F("assdNo"), $F("fundDesc"), $F("branchName"));
							overlayShowDetailsDirOverlay.close();
							delete overlayShowDetailsDirOverlay;
						}
					}
				}
			});
		}catch(e){
			showErrorMessage('checkUserAccess', e);
		}
	}
	
	$("billsRG").checked = false;
	$("ageLevelsRG").checked = false;
	$("billAcrossRG").checked = false;
	
	
	$("btnCancel").observe("click", function(){
		overlayShowDetailsDirOverlay.close();
		delete overlayShowDetailsDirOverlay;
	});	
}catch(e){
	showErrorMessage("Page Error: ", e);
}
</script>