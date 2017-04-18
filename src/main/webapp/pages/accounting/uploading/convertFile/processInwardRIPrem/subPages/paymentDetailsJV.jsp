<div id="paymentDetailsJVDiv" style="width: 99%; margin-top: 5px;">
	<div class="sectionDiv">
		<table align="center" style="margin-top: 20px; margin-bottom: 20px;">
			<tr>
				<td>
					<label for="txtBranchCd">Branch</label>
				</td>
				<td>
					<span class="lovSpan required" style="width: 70px; margin-bottom: 0;">
						<input type="text" id="txtBranchCd" ignoreDelKey="true" name="txtBranchCd" style="width: 40px; float: left;" class="withIcon allCaps required"  maxlength="4"  tabindex="1001"/>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="btnBranchCd" alt="Go" style="float: right;" />
					</span>
				</td>
				<td>
					<input type="text" id="txtBranchName" ignoreDelKey="true" name="txtBranchName" style="width: 175px; float: left; height: 14px;" readonly="readonly" tabindex="1002"/>
				</td>
				<td colspan="2" style="padding-left: 60px">
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
					<div style="float: left; width: 256px;" class="withIconDiv required">
						<input type="text" id="txtTranDate" name="txtTranDate" class="withIcon date required" readonly="readonly" style="width: 231px;" tabindex="1005"/>
						<img id="btnTranDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Tran Date" tabindex="107"/>
					</div>
				</td>
				<td class="rightAligned" style="padding-left: 20px">Tran No.</td>
				<td class="leftAligned">
					<input class="rightAligned required integerNoNegativeUnformattedNoComma" type="text" id="txtTranYy" name="txtTranYr" maxlength="4" style="width: 79px;" tabIndex = "1006" readonly="readonly"/>
					<input class="rightAligned required integerNoNegativeUnformattedNoComma" type="text" id="txtTranMm" name=txtTranMm maxlength="2" style="width: 69px;" tabIndex = "1007" readonly="readonly"/>
					<input class="rightAligned integerNoNegativeUnformattedNoComma" type="text" id="txtTranSeqNo" name="txtTranSeqNo" maxlength="5" style= "width: 78px;" tabIndex = "1008" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">JV Tran Type/Mo/Yr</td>
				<td class="leftAligned" colspan="2">
					<div style="float: left; padding-top: 2px;">
						<span class="required lovSpan" style="width: 140px; height: 21px;">
							<input type="hidden" id="txtJVTranType" name="txtJVTranType"/>
							<input type="text" id="txtDspTranDesc" name="txtDspTranDesc" style="width: 115px; float: left; border: none; height: 14px; margin: 0;" class="required disableDelKey" tabIndex = "114"></input>								
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchTranType" name="searchTranType" alt="Go" style="float: right;" tabIndex = "115"/>
						</span>
					</div>
					<div style="padding-left: 4px; padding-top: 2px; float: left;">
						<select class="" id="txtJVTranMm" name="txtJVTranMm" style="width: 55px; height: 23px;" tabIndex = "116"></select>
					</div>
					<div style="padding-left: 4px; float: left;">
						<input class=" integerNoNegativeUnformattedNoComma" class="rightAligned" type="text" id="txtJVTranYy" name="txtJVTranYy" maxlength="4" style="width: 45px; height: 15px;" tabIndex = "117"/>
					</div>
				</td>
				<td class="rightAligned">JV No.</td>
				<td class="leftAligned">
					<input type="text" id="txtJVPrefSuff" name="txtJVPrefSuff" style="width: 40px;" readonly="readonly" tabIndex = "130"/>
					<input class="rightAligned" type="text" id="txtJVNo" name="txtJVNo" style="width: 198px;" readonly="readonly" tabIndex = "131"/>
				</td>
			</tr>
			<tr>
				<td>
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
</div>
<center>
	<input type="button" class="button" value="Return" id="btnReturn" style="margin-top: 5px; width: 100px;" />
	<input type="button" class="button" value="Save" id="btnSave" style="margin-top: 5px; width: 100px;" />
	<input type="button" class="button" value="Delete" id="btnDelete" style="margin-top: 5px; width: 100px;" />
</center>
<script type="text/javascript">
	initializeAll();
	initializeAccordion();
	objectJv = JSON.parse('${showGiacUploadJvPaytDtl}'); //nieko Accounting Uploading, replace object to objectJv, to avoid conflict on previous module
	addMonth(["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec",""]);
	
	changeTag = 0;
	deleteRows = 0;
	var objCheckTags = {};
	
	objCheckTags.fileNo = objectJv.fileNo == null ? "" : unescapeHTML2(objectJv.fileNo);
	objCheckTags.sourceCd = objectJv.sourceCd == null ? "" : unescapeHTML2(objectJv.sourceCd);
	$("txtBranchCd").value = objectJv.branchCd == null ? "" : unescapeHTML2(objectJv.branchCd);
	$("txtBranchName").value = objectJv.dspBranchName == null ? "" : unescapeHTML2(objectJv.dspBranchName);
	$("txtTranDate").value = objectJv.tranDate == null ? "" : dateFormat(objectJv.tranDate, "mm-dd-yyyy");
	$("txtTranYy").value = objectJv.tranYear == null ? "" : objectJv.tranYear;
	$("txtTranMm").value = objectJv.tranMonth == null ? "" : lpad(objectJv.tranMonth,2,0);
	$("txtTranSeqNo").value = objectJv.tranSeqNo == null ? "" : lpad(objectJv.tranSeqNo,5,0);
	$("txtJVTranType").value = objectJv.jvTranType == null ? "" : unescapeHTML2(objectJv.jvTranType);
	$("txtDspTranDesc").value = objectJv.dspTranDesc == null ? "" : unescapeHTML2(objectJv.dspTranDesc);
	$("txtJVTranMm").value = objectJv.jvTranMm == null ? "" : objectJv.jvTranMm;
	$("txtJVTranYy").value = objectJv.jvTranYy == null ? "" : objectJv.jvTranYy;
	$("txtJVPrefSuff").value = objectJv.jvPrefSuff == null ? "" : unescapeHTML2(objectJv.jvPrefSuff);
	$("txtJVNo").value = objectJv.jvNo == null ? "" : lpad(objectJv.jvNo,6,0);
	$("txtParticulars").value = objectJv.particulars == null ? "" : unescapeHTML2(objectJv.particulars);
	objectJv.jvTranTag == "C" ? $("rdoCash").checked = true : $("rdoNonCash").checked = true;
	
	if($("txtDspTranDesc").value == ""){
		validateCash();
	}
	
	function addMonth(monArray) {
		for ( var i = 0; i < monArray.length; i++) {
			 var opt = document.createElement('option');
             opt.text = monArray[i];
             opt.value = i+1;
             if(opt.value == 13){
            	 opt.value = "";
             }
			 $("txtJVTranMm").options.add(opt);
		}
	}
	
	function closeOverlay(){
		overlayPaymentDetails.close();
		delete overlayPaymentDetails;
	}
	
	//nieko Accounting Uploading
	if(nvl(objectJv.vExists, "Y") == "Y"){
		 $("txtBranchCd").readOnly = true;
		 disableSearch("btnBranchCd");
		 disableButton("rdoCash");
		 disableButton("rdoNonCash");
		 disableDate("btnTranDate");
		 $("txtDspTranDesc").readOnly = true;
		 disableSearch("searchTranType");
		 $("txtJVTranMm").disable();
		 $("txtParticulars").readOnly = true;
	} else {
		 $("txtBranchCd").readOnly = false;
		 enableSearch("btnBranchCd");
		 enableButton("rdoCash");
		 enableButton("rdoNonCash");
		 enableDate("btnTranDate");
		 $("txtDspTranDesc").readOnly = false;
		 enableSearch("searchTranType");
		 $("txtJVTranMm").enable();
		 $("txtParticulars").readOnly = false;
	}
	
	if (objGIACS608.fileStatus == "C" || objGIACS608.fileStatus != 1){
		disableButton("btnSave");
		disableButton("btnDelete");
	}else{
		enableButton("btnSave");
		enableButton("btnDelete");
	}
	//nieko end
	
	$("btnReturn").observe("click", function(){
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						fireEvent($("btnSave"), "click");
					}, function() {
						closeOverlay();
					}, "");
		} else {
			closeOverlay();
		}
	});
	
	function showJVTranTypeLOV(jvTranTag,findText2){
		LOV.show({
			controller: "ACUploadingLOVController",
			urlParameters: {
				action: "getJVTranTypeLOV",
				jvTranTag: jvTranTag,
				searchString: findText2
			},
			title: "Valid Values for JV tran type",
			width: 400,
			height: 388,
			columnModel : [
			               {
			            	   id : "jvTranCd",
			            	   title: "Code",
			            	   width: '80px'
			               },
			               {
			            	   id : "jvTranDesc",
			            	   title: "Description",
			            	   width: '320px'
			               }
			              ],
			draggable: true,
			filterText: findText2,
			onSelect: function(row) {
				$("txtJVTranType").value = unescapeHTML2(row.jvTranCd);
				$("txtDspTranDesc").value = unescapeHTML2(row.jvTranDesc);
				changeTag = unescapeHTML2(objectJv.dspTranDesc) == $F("txtDspTranDesc") ? 0 : 1;
			},
	  		onCancel: function(){
  				$("txtDspTranDesc").focus();
	  		}
		});
	}
	
	$("searchTranType").observe("click", function(){
		var jvTranTag = "";
		if ($("rdoCash").checked) {
			jvTranTag = "C";
		} else {
			jvTranTag = "NC";
		}
		showJVTranTypeLOV(jvTranTag,'%');
	});
	
	$("btnBranchCd").observe("click", function(){
		showBranchCdLOV();
	});
	
	$("txtBranchCd").observe("change", function(){
		if($("txtBranchCd").value == ""){
			$("txtBranchName").value = "";
		} else {
			showBranchCdLOV();
		}
	});
	
	function showBranchCdLOV(){
		try{
			LOV.show({
				controller : "ACUploadingLOVController",
				urlParameters : {
					  action : "uploadingGetBranchCdLOV",
					  moduleId : "GIACS003",
					  filterText: nvl($F("txtBranchCd"), "%"),  
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
				filterText: nvl($F("txtBranchCd"), "%"),  
				autoSelectOneRecord : true,
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtBranchCd").value = unescapeHTML2(row.branchCd);
						$("txtBranchName").value = unescapeHTML2(row.branchName);
						changeTag = unescapeHTML2(objectJv.branchCd) == $F("txtBranchCd") ? 0 : 1;
					}
				},
				onCancel: function(){
					$("txtBranchCd").focus();
		  		},
		  		onUndefinedRow: function(){
		  			$("txtBranchCd").value = "";
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
			$("txtTranYy").value = dateFormat($F("txtTranDate"), "yyyy");
			$("txtTranMm").value = dateFormat($F("txtTranDate"), "mm");
			$("txtJVPrefSuff").value = "JV";
		} else {
			$("txtTranYy").value = "";
			$("txtTranMm").value = "";
			$("txtJVPrefSuff").value = "";
		}
		
		changeTag = 1;
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
		validateCash();
		deleteRows = 1;
		changeTag = 1;
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
			var obj = (objectJv == null ? {} : objectJv);
			obj.sourceCd		= objCheckTags.sourceCd;
			obj.fileNo			= objCheckTags.fileNo;
			obj.branchCd		= escapeHTML2($F("txtBranchCd"));
			obj.tranDate    	= $F("txtTranDate");
			obj.jvTranTag   	= $("rdoCash").checked ? "C" : "NC";
			obj.jvTranType     	= $F("txtJVTranType");
			obj.jvTranMm       	= $F("txtJVTranMm");
			obj.jvTranYy     	= $F("txtJVTranYy");
			obj.jvPrefSuff     	= $F("txtJVPrefSuff");
			obj.jvNo  			= $F("txtJVNo");
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
		});
	});
	
	$("txtParticulars").observe("change", function(){
		changeTag = unescapeHTML2(objectJv.particulars) == $F("txtParticulars") ? 0 : 1;
	});
	
	$("txtJVTranMm").observe("change", function(){
		changeTag = objectJv.jvTranMm == $F("txtJVTranMm") ? 0 : 1;
	});
	
	$("txtJVTranYy").observe("change", function(){
		changeTag = objectJv.jvTranYy == $F("txtJVTranYy") ? 0 : 1;
	});
	
	$("rdoCash").observe("click", function(){
		validateCash();
		changeTag = objectJv.jvTranTag == "C" ? 0 : 1;
	});
	
	$("rdoNonCash").observe("click", function(){
		validateCash();
		changeTag = objectJv.jvTranTag == "NC" ? 0 : 1;
	});

	$("btnSave").observe("click", function(){
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
	});
	
	function validateCash() {
		try{
			if($("rdoCash").checked){
				$("txtJVTranMm").addClassName("required");
				$("txtJVTranYy").addClassName("required");
				if ($F("txtJVTranMm") == "") {
					var mm = dateFormat(new Date,'m');
					$("txtJVTranMm").value = mm;
				}
				if ($F("txtJVTranYy").trim() == "") {
					var yy = dateFormat(new Date,'yyyy');
					$("txtJVTranYy").value = yy;
				}
			} else {
				$("txtJVTranMm").removeClassName("required");
				$("txtJVTranYy").removeClassName("required");
				$("txtJVTranMm").value = "";
				$("txtJVTranYy").value = "";
			}
			new Ajax.Request(contextPath+"/GIACJournalEntryController?action=validateCash",{
				method: "POST",
				asynchronous: false,
				evalScripts: true,
				parameters:{
					jvTranTag: $("rdoCash").checked ? 'C':'NC'
				},
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						$("txtJVTranType").value = obj.row[0].jvTranCd;
						$("txtDspTranDesc").value = obj.row[0].jvTranDesc;
					}	
				}
			});
		} catch(e){
			showErrorMessage("validateCash", e);
		}
	}
</script>