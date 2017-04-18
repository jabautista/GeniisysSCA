<div id="applyBankDiv" class="sectionDiv" style="padding-top:20px; padding-bottom: 20px; width: 250px; margin-top: 10px;">
	<table align="center" style="width: 150px;">
		<tr>
			<td class="rightAligned"><label style="width: 60px;">DCB Date</td>
			<td class="leftAligned">
				<div id="startDateDiv" class="required" style="float: left; border: 1px solid gray; width: 155px; height: 20px;">
					<input id="txtDCBDate" name="DCB Date." readonly="readonly" type="text" class=" required date " maxlength="10" style="border: none; float: left; width: 130px; height: 13px; margin: 0px;" value="" tabindex="101"/>
					<img id="imgDCBDate" alt="imgDCBDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtDCBDate'),this, null);" />
				</div>
			</td>
		</tr>
	</table>
</div>
<div align="center">
	<input type="button" class="button" value="Ok" id="btnOk" style="margin-top: 10px; width: 100px;" />
	<input type="button" class="button" value="Cancel" id="btnCancel" style="margin-top: 10px; width: 100px;" />
</div>
<script type="text/javascript">
	var object = JSON.parse('${object}');
	var dcbNo = "";
	
	function closeOverlay(){
		overlayForDeposit.close();
		delete overlayForDeposit;
	}
	
	$("btnCancel").observe("click", function(){
		closeOverlay();
	});
	
	$("btnOk").observe("click", function(){
		new Ajax.Request(contextPath+"/GIACPdcChecksController", {
			method: "POST",
			parameters : {
						action : "saveForDeposit",
						itemId: object.itemId,
						dcbNo: dcbNo,
						dcbDate: $F("txtDCBDate"),
						gaccTranId: object.gaccTranId,
						itemNo: object.itemNo
						},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
					tbgPostDatedChecks._refreshList();
					closeOverlay();
				});
			}
		});
	});
	
	$("txtDCBDate").observe("focus", function(){
		if($F("txtDCBDate") != ""){
			new Ajax.Request(contextPath+"/GIACPdcChecksController", {
				method: "POST",
				parameters : {
								action : "checkDateForDeposit",
								fundCd: object.fundCd,
								branchCd: object.branchCd,
								dcbDate: $F("txtDCBDate") 
							},
				onCreate : showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					var obj = JSON.parse(response.responseText);
					if(obj.dcbflag == "T" || obj.dcbflag == "C"){
						showWaitingMessageBox("DCB for " + dateFormat(obj.tranDate,"mmmm d, yyyy") + " has already been closed." , imgMessage.INFO, function(){
							$("txtDCBDate").value = "";
						});
					} else if (obj.dcbNo == null && obj.dcbflag == null && obj.tranDate == null) {
						showWaitingMessageBox("There is no open DCB for " + dateFormat($F("txtDCBDate") ,"mmmm d, yyyy") + "." , imgMessage.INFO, function(){
							$("txtDCBDate").value = "";
							return false;
						});
					} else if (Date.parse($F("txtDCBDate")) < Date.parse(object.checkDate)){
						showWaitingMessageBox("DCB Date should be equal or later than check date." , imgMessage.INFO, function(){
							$("txtDCBDate").value = "";
							return false;
						});
					} else {
						dcbNo = obj.dcbNo;
					}
				}
			});
		}
	});
	
</script>