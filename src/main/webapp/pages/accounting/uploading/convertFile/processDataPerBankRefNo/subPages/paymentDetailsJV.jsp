<div id="paymentDetailsJVDiv" style="width: 99%; margin-top: 5px;">
	<div class="sectionDiv">
		<table align="center" style="margin-top: 20px; margin-bottom: 20px;">
			<tr>
				<td>
					<label for="txtBranchCd">Branch</label>
				</td>
				<td>
					<span class="lovSpan required" style="width: 70px; margin-bottom: 0;" id="branchCdSpan"> <!-- Deo [10.06.2016]: added id -->
						<input type="text" id="txtBranchCd" ignoreDelKey="true" name="txtBranchCd" style="width: 40px; float: left;" class="withIcon allCaps required"  maxlength="4"  tabindex="1001"/>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="btnBranchCd" alt="Go" style="float: right;" />
					</span>
				</td>
				<td>
					<input type="text" id="txtBranchName" ignoreDelKey="true" name="txtBranchName" style="width: 175px; float: left; height: 14px;" readonly="readonly" tabindex="1002"/>
				</td>
				<td colspan="2" style="padding-left: 60px" hidden="hidden">
					<input type="radio" name="byCash" id="rdoCash" title="Cash" style="float: left; margin-right: 6px" tabIndex = "1003"/>
					<label for="rdoCash" style="float: left; height: 20px; padding-top: 4px; margin-right: 25px;">Cash</label>
					<input type="radio" name="byCash" id="rdoNonCash" title="Non Cash" style="float: left; margin-right: 6px;" tabIndex = "1004" checked="checked"/>
					<label for="rdoNonCash" style="float: left; height: 20px; padding-top: 4px;">Non Cash</label>
				</td>
			</tr>
			<tr>
				<td>
					<label for="txtTranDate">Tran Date</label>
				</td>
				<td colspan="2">
					<div style="float: left; width: 256px;" class="withIconDiv required"; id="tranDateDiv"> <!-- Deo [10.06.2016]: added id -->
						<input type="text" id="txtTranDate" name="txtTranDate" class="withIcon date required" readonly="readonly" style="width: 231px;" tabindex="1005"/>
						<img id="btnTranDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Tran Date" tabindex="107"/>
					</div>
				</td>
				<td class="rightAligned" style="padding-left: 20px">Tran No</td>
				<td class="leftAligned">
					<input class="rightAligned required integerNoNegativeUnformattedNoComma" type="text" id="txtTranYy" name="txtTranYr" maxlength="4" style="width: 79px;" tabIndex = "1006" readonly="readonly"/>
					<input class="rightAligned required integerNoNegativeUnformattedNoComma" type="text" id="txtTranMm" name=txtTranMm maxlength="2" style="width: 69px;" tabIndex = "1007" readonly="readonly"/>
					<input class="rightAligned integerNoNegativeUnformattedNoComma" type="text" id="txtTranSeqNo" name="txtTranSeqNo" maxlength="5" style= "width: 78px;" tabIndex = "1008" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td valign="top" style="padding-top: 5px;"> <!-- Deo [10.06.2016]: add valign and style -->
					<label for="txtParticulars">Particulars</label>
				</td>
				<td colspan="5">
					<div id="particularsDiv" name="particularsDiv" style="float: left; width: 592px; border: 1px solid gray; height: 66px;" class="required">
						<textarea class="required" style="float: left; height: 60px; width: 562px; margin-top: 0; border: none;" id="txtParticulars" name="txtParticulars" maxlength="2000"  onkeyup="limitText(this,2000);" tabindex="1014"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editParticulars"/>
					</div>
				</td>
			</tr>
			
		</table>
	</div>
	<center>
		<input type="button" class="button" value="Return" id="btnReturn" style="margin-top: 5px; width: 100px;" tabindex="1015" />
		<input type="button" class="button" value="Save" id="btnSave" style="margin-top: 5px; width: 100px;" tabindex="1016"/>
		<input type="button" class="button" value="Delete" id="btnDelete" style="margin-top: 5px; width: 100px;" tabindex="1017"/>
		<input type="hidden" id="tranDateHid" name="tranDateHid" style="width: 231px;"/> <!-- Deo [10.06.2016] -->
	</center>
</div>
<script type="text/javascript">
	initializeAll();
	initializeAccordion();
	object = JSON.parse('${showGiacUploadJvPaytDtl}');
	addMonth(["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec",""]);
	
	changeTag = 0;
	deleteRows = 0;
	var objCheckTags = {};
	
	objCheckTags.fileNo = object.fileNo == null ? "" : unescapeHTML2(object.fileNo);
	objCheckTags.sourceCd = object.sourceCd == null ? "" : unescapeHTML2(object.sourceCd);
	$("txtBranchCd").value = object.branchCd == null ? "" : unescapeHTML2(object.branchCd);
	$("txtBranchCd").setAttribute("lastValidValue", $F("txtBranchCd")) //Deo [10.06.2016]
	$("txtBranchName").value = object.dspBranchName == null ? "" : unescapeHTML2(object.dspBranchName);
	$("txtTranDate").value = object.tranDate == null ? "" : dateFormat(object.tranDate, "mm-dd-yyyy");
	$("txtTranYy").value = object.tranYear == null ? "" : object.tranYear;
	$("txtTranMm").value = object.tranMonth == null ? "" : lpad(object.tranMonth,2,0);
	$("txtTranSeqNo").value = object.tranSeqNo == null ? "" : lpad(object.tranSeqNo,5,0);
	$("txtParticulars").value = object.particulars == null ? "" : unescapeHTML2(object.particulars);
	
	
	
	function addMonth(monArray) {
		for ( var i = 0; i < monArray.length; i++) {
			 var opt = document.createElement('option');
             opt.text = monArray[i];
             opt.value = i+1;
             if(opt.value == 13){
            	 opt.value = "";
             }
		}
	}
	
	function closeOverlay(){
		changeTag = 0; //Deo [10.06.2016]
		overlayPaymentDetails.close();
		delete overlayPaymentDetails;
	}
	
	$("btnReturn").observe("click", function(){
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						//fireEvent($("btnSave"), "click"); //Deo [10.06.2016]: comment out
						saveGiacs610JVPaytDtl(true); //Deo [10.06.2016]
					}, function() {
						closeOverlay();
					}, "");
		} else {
			closeOverlay();
		}
	});
	
	$("btnBranchCd").observe("click", function(){
		showBranchCdLOV(true); //Deo [10.06.2016]: add param
	});
	
	$("txtBranchCd").observe("change", function(){
		if($("txtBranchCd").value == ""){
			$("txtBranchName").value = "";
			$("txtBranchCd").setAttribute("lastValidValue", ""); //Deo [10.06.2016]
		} else {
			showBranchCdLOV();
		}
	});
	
	function showBranchCdLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("txtBranchCd").trim() == "" ? "%" : $F("txtBranchCd")); //Deo [10.06.2016]
			
			LOV.show({
				controller : "ACUploadingLOVController",
				urlParameters : {
					  action : "uploadingGetBranchCdLOV",
					  moduleId : "GIACS003",
					  filterText: searchString, //nvl($F("txtBranchCd"), "%"),  //Deo [10.06.2016]: replace source
						page : 1
				},
				title: "List of Branch Cd",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'branchCd',
						title: 'Code',
						width : '100px',
						align: 'right',
						titleAlign : 'right'
					},
					{
						id : 'branchName',
						title: 'Branch Name',
					    width: '335px',
					    align: 'left'
					}
				],
				filterText: escapeHTML2(searchString), //nvl($F("txtBranchCd"), "%"),  //Deo [10.06.2016]: replace source
				autoSelectOneRecord : true,
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtBranchCd").value = unescapeHTML2(row.branchCd);
						$("txtBranchName").value = unescapeHTML2(row.branchName);		
						
						//Deo [10.06.2016]
						$("txtBranchCd").setAttribute("lastValidValue", unescapeHTML2(row.branchCd));
						changeTag = 1;
						editSw = true;
						changeTagFunc = saveGiacs610JVPaytDtl;
						if (isIconClicked) {
							$("txtBranchCd").focus();
						}
					}
				},
				onCancel: function(){
					$("txtBranchCd").focus();
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue"); //Deo [10.06.2016]
		  		},
		  		onUndefinedRow: function(){
		  			$("txtBranchCd").value = "";
		  			$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue"); //Deo [10.06.2016]
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranchCd");
		  		}
			});
		}catch(e){
			showErrorMessage("showBranchCdLOV",e);
		}
	}
	
	$("btnTranDate").observe("click", function() { 
		scwNextAction = validateTranDate.runsAfterSCW(this, null); 
		scwShow($("txtTranDate"),this, null); 
	});
	
	function validateTranDate(){
		if($F("txtTranDate") != ""){
			/* $("txtTranYy").value = dateFormat($F("txtTranDate"), "yyyy");
			$("txtTranMm").value = dateFormat($F("txtTranDate"), "mm"); */ //Deo [10.06.2016] comment out
			//Deo [10.06.2016]: add start
			var tranDateArray = $("txtTranDate").value.split("-");
			$("txtTranYy").value = tranDateArray[2];
 			$("txtTranMm").value = tranDateArray[0];
 			//Deo [10.06.2016]: add ends
		} else {
			$("txtTranYy").value = "";
			$("txtTranMm").value = "";
		}
		
		changeTag = 1;
		editSw = true; //Deo [10.06.2016]
		changeTagFunc = saveGiacs610JVPaytDtl; //Deo [10.06.2016]
	}
	
	$("txtTranDate").observe("keyup", function(event){
		if(event.keyCode == 46){
			$("txtTranYy").value = "";
			$("txtTranMm").value = "";
		}
	});
	
	$("btnDelete").observe("click", function(){
		$$("div#paymentDetailsJVDiv input[type='text'], div#paymentDetailsJVDiv textarea, div#paymentDetailsJVDiv select").each(function(a) {
			if(a.id != "txtBranchCd" && a.id != "txtBranchName"){
				a.value = "";
			}
		}); 
		deleteRows = 1;
		changeTag = 1;
		
		//Deo [10.06.2016]
		editSw = false;
		changeTagFunc = saveGiacs610JVPaytDtl;
		$("txtTranDate").value = dateFormat(new Date(), "mm-dd-yyyy");
		validateTranDate();
		disableButton("btnDelete");
		$("txtBranchCd").focus();
	});
	
	function saveGiacs603JV(){
		var setRows = setRecordToSave();
		new Ajax.Request(contextPath+"/GIACUploadingController", {
			method: "POST",
			parameters : {action : "saveGiacs603JVPaytDtl",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  },
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						closeOverlay();
					});
					changeTag = 0;
				}
			}
		});
	}
	
	function setRecordToSave(){
		try {
			var tempObjArray = new Array();
			var obj = (object == null ? {} : object);
			obj.sourceCd		= objCheckTags.sourceCd;
			obj.fileNo			= objCheckTags.fileNo;
			obj.branchCd		= escapeHTML2($F("txtBranchCd"));
			obj.tranDate    	= $F("txtTranDate");
			obj.particulars     = escapeHTML2($F("txtParticulars"));
			obj.tranYear      	= $F("txtTranYy");
			obj.tranMonth     	= $F("txtTranMm");
			obj.tranSeqNo     	= $F("txtTranSeqNo");
			
			tempObjArray.push(obj);
			
			return tempObjArray;
		} catch(e){
			showErrorMessage("setRecordToSave", e);
		}
	}
	
	$("editParticulars").observe("click", function(){
		showOverlayEditor("txtParticulars", 2000, $("txtParticulars").hasAttribute("readonly"), function(){
			changeTag = 1;
			editSw = true; //Deo [10.06.2016]
		});
	});
	
	$("txtParticulars").observe("change", function(){
		changeTag = unescapeHTML2(object.particulars) == $F("txtParticulars") ? 0 : 1;
	});
	
	/* $("btnSave").observe("click", function(){	
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		
		if (deleteRows == 1){
			new Ajax.Request(contextPath+"/GIACUploadingController", {
				method: "POST",
				parameters : {action : "delGiacs603JVPaytDtl",
							 sourceCd : objCheckTags.sourceCd,
							 fileNo : objCheckTags.fileNo
						 	  },
				asynchronous: true,
				onCreate : showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						changeTagFunc = "";
						var isComplete = true;
						$$("div#paymentDetailsJVDiv input[type='text'].required, div#paymentDetailsJVDiv textarea.required, div#paymentDetailsJVDiv select.required, div#paymentDetailsJVDiv input[type='file'].required").each(function (o) {
							if (o.value.blank()){
								isComplete = false;
							}
						});
						
						if (isComplete){
							saveGiacs603JV();
						} else {
							showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
								overlayPaymentDetails.close();
								delete overlayPaymentDetails;
								changeTag = 0;
							});
						}
					} 
				}
			});
		} else {
			if(checkAllRequiredFieldsInDiv("paymentDetailsDVDiv")){
				saveGiacs603JV();
			}
		}
	}); */ //Deo [10.06.2016]: comment out
	
	//Deo [10.06.2016]: add start
	var editSw = false;
	
 	if ($F("txtTranDate") == ""){
 		disableButton("btnDelete");
	}
 	
 	if (guf.fileStatus == "1") {
 		var prevDate = nvl($F("txtTranDate"), "*");
 		if ($F("tranDateHid") != $F("txtTranDate")) {
 			$("txtTranDate").value = $F("tranDateHid");
 	 		validateTranDate();
 	 		if (prevDate == "*") {
 	 			changeTag = 0;
 	 		}
 		}
 		$("txtBranchCd").focus();
 	} else {
 		$("btnReturn").focus();
 	}
 	
 	if (guf.fileStatus == "C" && $F("txtTranDate") == "") {
 		$("txtBranchCd").value = "";
 		$("txtBranchName").value = "";
 	}
 	
 	$("paymentDetailsJVDiv").observe("keydown", function(event){
		var curEle = document.activeElement.id;
		if (event.keyCode == 9 && !event.shiftKey) {
			if (curEle == "btnReturn" && $("btnSave").disabled == true) {
				$("txtBranchName").focus();
				event.preventDefault();
			} else if (curEle == "btnDelete") {
				$("txtBranchCd").focus();
				event.preventDefault();
			} else if (curEle == "btnSave" && $("btnDelete").disabled == true) {
				$("txtBranchCd").focus();
				event.preventDefault();
			}
		} else if (event.keyCode == 9 && event.shiftKey) {
			if (curEle == "txtBranchName" && $("txtBranchCd").disabled == true) {
				$("btnReturn").focus();
				event.preventDefault();
			} else if (curEle == "txtBranchCd") {
				if ($("btnDelete").disabled == true) {
					if ($("btnSave").disabled == true) {
						$("btnReturn").focus();
					} else {
						$("btnSave").focus();
					}
				} else {
					$("btnDelete").focus();
				}
				event.preventDefault();
			}
		}
	});
 	
 	$$("div#paymentDetailsJVDiv input[type='text'], div#paymentDetailsJVDiv textarea").each(function(o) {
		$(o).observe("change", function() {
			editSw = true;
			changeTag = 1;
			changeTagFunc = saveGiacs610JVPaytDtl;
		});
	});
 	
 	observeSaveForm("btnSave", saveGiacs610JVPaytDtl);
 	
 	function saveGiacs610JVPaytDtl(exit) {
		try {
			if ((changeTag == 1 && editSw && checkAllRequiredFieldsInDiv('paymentDetailsJVDiv'))
					|| (changeTag == 1 && !editSw)) {
				
				new Ajax.Request(contextPath+"/GIACUploadingController", {
					method: "POST",
					parameters : {
						action : "validateUploadTranDate",
					    tranDate : $F("txtTranDate"),
					    branchCd: $F("txtBranchCd"),
					    sourceCd : objCheckTags.sourceCd,
						fileNo : objCheckTags.fileNo
					},
					onCreate : showNotice("Processing, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
							var setRec = new Array();
							var delRec = new Array();

							if (deleteRows == 1) {
								var obj = new Object();
								obj.sourceCd = guf.sourceCd;
								obj.fileNo = guf.fileNo;
								delRec.push(obj);
							}
							
							if (editSw) {
								var obj = setObj();
								setRec.push(obj);
							}

							new Ajax.Request(contextPath + "/GIACUploadingController", {
								method : "POST",
								parameters : {
									action : "saveGiacs610JVPaytDtl",
									delRec : prepareJsonAsParameter(delRec),
									setRec : prepareJsonAsParameter(setRec),
									sourceCd : guf.sourceCd,
									fileNo : guf.fileNo
								},
								onCreate : showNotice("Saving JV Payment Details, please wait..."),
								onComplete : function(response) {
									hideNotice();

									if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
										changeTagFunc = "";
										changeTag = 0;
										deleteRows = 0;
										editSw = false;
										//object = JSON.parse(response.responseText);
										showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function() {
											enableButton("btnDelete");
											$("txtTransactionDate").value = $F("txtTranDate");
											$("orDateHid").value = $F("txtTranDate");
											if (exit) {
												closeOverlay();
											}
										});
									}
								}
							});
						}
					}
				});
			}
		} catch (e) {
			showErrorMessage("saveGiacs610JVPaytDtl", e);
		}
	}
 	
 	function setObj() {
		var obj = new Object();
		
		obj.sourceCd		= objCheckTags.sourceCd;
		obj.fileNo			= objCheckTags.fileNo;
		obj.branchCd		= escapeHTML2($F("txtBranchCd"));
		obj.tranDate    	= $F("txtTranDate");
		obj.particulars     = escapeHTML2($F("txtParticulars"));
		obj.tranYear      	= $F("txtTranYy");
		obj.tranMonth     	= $F("txtTranMm");
		obj.tranSeqNo     	= $F("txtTranSeqNo");
		
		return obj;
	}
 	//Deo [10.06.2016]: add ends
</script>