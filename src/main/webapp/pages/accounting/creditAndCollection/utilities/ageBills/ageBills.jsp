<div id="ageBillsMainDiv" class="sectionDiv" style="height: 375px;">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Age Bills</label>
			<span class="refreshers" style="margin-top: 0;">
		 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div class="sectionDiv" style="width: 350px; height: 170px; margin-left: 285px; margin-top: 50px;">
		<div class="sectionDiv" style="width: 344px; height: 110px; margin-left: 2px; margin-top: 2px; margin-bottom: 15px;">
			<div style="float: left; margin-top: 20px;">
				<input type="checkbox" id="chkDirect" style="float: left; margin-left: 38px;" tabindex="15001"/>
				<label for="chkDirect">Direct Business</label>
				<input type="checkbox" id="chkReinsurance" style="float: left; margin-left: 75px;" tabindex="15002"/>
				<label for="chkReinsurance">Reinsurance</label>
			</div>
			<div style="float: left; margin-left: 50px; margin-top: 20px;">
				<label style="margin-top: 6px;">Cut-off Date</label>
				<div id="cutOffDateDiv" style="float: left; border: solid 1px gray; width: 160px; height: 20px; margin-left: 5px; margin-top: 2px;">
					<input type="text" id="txtCutOffDate" style="float: left; margin-top: 0px; margin-right: 3px; height: 14px; width: 132px; border: none;" name="txtCutOffDate" tabindex="15003"/>
					<img id="imgCutOffDate" alt="imgCutOffDate" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" tabindex="15004"/>
				</div>
			</div>
		</div>
		<div style="text-align: center;">
			<input type="button" class="button" id="btnAgeBills" value="Age Bills" style="width: 150px;">
		</div>
	</div>
</div>
<script>
try{
	setModuleId("GIACS150");
	setDocumentTitle("Age Bills");
	
	$("txtCutOffDate").value = new Date().toString('MM-dd-yyyy');
	
	$("btnAgeBills").observe("click", function(){
		if($F("txtCutOffDate") == ""){
			customShowMessageBox("Please enter Cut-off date before proceeding.", "E", "txtCutOffDate");
			return false;
		}
		if(!$("chkDirect").checked && !$("chkReinsurance").checked){
			customShowMessageBox("Please choose a business type to be processed.", "E", "chkDirect");
			return false;
		}
		ageBills();
	});
	
	function ageBills(){
		new Ajax.Request(contextPath+"/GIACCreditAndCollectionUtilitiesController?action=ageBills",{
			parameters: {
				cutOffDate : $F("txtCutOffDate"),
				direct : $("chkDirect").checked ? "Y" : "N",
				reinsurance : $("chkReinsurance").checked ? "Y" : "N",
			},
			onCreate: showNotice("Processing Record...Please wait..."),
			onComplete : function(response){
				hideNotice("");
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					if(response.responseText = "SUCCESS"){
						showMessageBox("Bills processed successfully.", "I");
						/* if($("chkReinsurance").checked){
							showMessageBox("Bills processed successfully.", "I");
						}else{
							showMessageBox("Done.", "I");
						} */
					}else{
						if($("chkReinsurance").checked){
							showMessageBox("Unable to update Reinsurance Bills...", "I");
						}else{
							showMessageBox("Unable to update Foreign Currency Bills...", "I");
						}
					}
				}
			}
		});
	}
	
	var prevDate = "";
	$("txtCutOffDate").observe("focus", function(){
		prevDate = $F("txtCutOffDate");
	});
	$("txtCutOffDate").observe("change", function(){
		if($F("txtCutOffDate") != ""){
			if(!checkDate3($F("txtCutOffDate"), "txtCutOffDate")){
				$("txtCutOffDate").value = prevDate;
			}
		}
	});
	
	$("imgCutOffDate").observe("click", function(){
		scwShow($("txtCutOffDate"),this, null);
	});
	
	observeReloadForm("reloadForm", showGIACS150);
}catch(e){
	showErrorMessage("ageBills.jsp", e);
}
</script>