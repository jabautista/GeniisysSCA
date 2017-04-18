<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="jvPaytDtlDiv" >
	<div class="sectionDiv" id="jvDtlDiv" changeTagAttr="true" style="margin-top: 5px; width: 740px;">
		<table border="0" align="left" style="margin: 10px 0 10px 15px;">
			<tr>
				<td class="rightAligned" style="padding-right: 4px;">Branch</td>
				<td class="leftAligned">					
					<div id="lovBranchCdDiv" style="width: 51px; height: 21px; float: left; margin-left: 0px;" class="required withIconDiv">
						<input style="width: 25px;" id="txtBranchCd" name="txtBranchCd" type="text" value="" class="required withIcon" tabindex="101" />
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovBranchCd" name="lovBranchCd" alt="Go" />
					</div>
					<input style="width: 225px;" id="txtNbtBranchName" name="txtNbtBranchName" type="text" value="" readOnly="readOnly" class="required" />
				</td>
				<td colspan="2" style="padding-left: 90px;">
					<input type="hidden" id="txtJVTranTag"/>
					<input type="radio" name="rdoTranTag" id="rdoCash" title="Cash" value="C" style="float: left; margin-right: 6px" tabIndex = "102"/>
					<label for="rdoCash" style="float: left; height: 20px; padding-top: 4px; margin-right: 25px;">Cash</label>
					<input type="radio" name="rdoTranTag" id="rdoNonCash" title="Non Cash" value="NC" style="float: left; margin-right: 6px;" tabIndex = "103"/>
					<label for="rdoNonCash" style="float: left; height: 20px; padding-top: 4px;">Non Cash</label>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 4px;">Date</td>
				<td class="leftAligned">
					<div style="width: 287px; height: 21px;" class="required withIconDiv">
			    		<input style="width: 262px;" type="text" id="txtTranDate" name="txtTranDate" readOnly="readOnly" maxlength="10" class="required withIcon" triggerChange = "Y"/>
			    		<img class="disabled" id="hrefTranDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Tran Date" onClick="scwShow($('txtRequestDate'),this, null);" tabIndex = "104"/>
			    	</div>	
				</td>
				<td class="rightAligned" style="padding: 0 4px 0 35px;" >Tran No.</td>
				<td class="leftAligned">
					<input class="rightAligned integerNoNegativeUnformattedNoComma" type="text" id="txtTranYear" name="txtTranYr" maxlength="4" readOnly="readOnly" style="width: 59px;" tabIndex = "105"/>
					<input class="rightAligned integerNoNegativeUnformattedNoComma" type="text" id="txtTranMonth" name=txtTranMonth maxlength="2" readOnly="readOnly" style="width: 39px;" tabIndex = "106"/>
					<input class="rightAligned integerNoNegativeUnformattedNoComma" type="text" id="txtTranSeqNo" name="txtTranSeqNo" maxlength="5" readOnly="readOnly" style= "width: 69px;" tabIndex = "107"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 4px;">JV Tran Type/Mo/Yr</td>
				<td class="leftAligned">
					<div style="float: left; padding-top: 2px;">
						<span class="required lovSpan" style="width: 140px; height: 21px;">
							<input type="hidden" id="txtJVTranType" name="txtJVTranType"/>
							<input type="text" id="txtNbtTranDesc" name="txtNbtTranDesc" style="width: 115px; float: left; border: none; height: 14px; margin: 0;" class="required disableDelKey" tabIndex = "108"></input>								
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovNbtTranDesc" name="lovNbtTranDesc" alt="Go" style="float: right;" tabIndex = "109"/>
						</span>
					</div>
					<div style="padding-left: 4px; padding-top: 2px; float: left;">
						<select class="required" id="txtJVTranMm" name="txtJVTranMm" style="width: 80px; height: 23px;" tabIndex = "110"></select>
					</div>
					<div style="padding-left: 4px; float: left;">
						<input class="required integerNoNegativeUnformattedNoComma" class="rightAligned" type="text" id="txtJVTranYy" name="txtJVTranYy" maxlength="4" style="width: 51px;" tabIndex = "111"/>
					</div>
				</td>
				<td class="rightAligned" style="padding-right: 4px;">JV No.</td>
				<td class="leftAligned">
					<input type="text" id="txtJVPrefSuff" name="txtJVPrefSuff" style="width: 40px;" readonly="readonly" tabIndex = "112"/>
					<input class="rightAligned" type="text" id="txtJVNo" name="txtJVNo" style="width: 139px;" readonly="readonly" tabIndex = "113"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 4px;">Particulars</td>
				<td class="leftAligned" colspan="3">
					<div style="float: left; width: 590px;" class="withIconDiv required">
						<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" id="txtParticulars" name="txtParticulars" style="width: 563px; resize:none;" class="withIcon required" tabIndex = "114"> </textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editParticulars" tabIndex = "115" />
					</div>
				</td>
			</tr>
		</table>
	</div>
	
	<div class="buttonsDiv" style="margin: 10px 0 0 0;">
		<input type="button" id="btnDelete" class="button" value="Delete" style="width: 90px;" tabIndex = "116"/>
	</div>	
	<div class="buttonsDiv" style="margin: 10px 0 0 0;">
		<input type="button" id="btnSave" class="button" value="Save" style="width: 90px;" tabIndex = "117"/>
		<input type="button" id="btnReturn" class="button" value="Return" style="width: 90px;" tabIndex = "118"/>
	</div>
</div>

<script type="text/javascript">
try{
	var objGUJV = JSON.parse('${jsonGUJV}');

	var deleteSw = false;
	var editSw = false;
	
	var month = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec",""];

	function initAll(){		
		if (deleteSw || (objGUJV.sourceCd == undefined && objGUJV.fileNo == undefined)){
			$("txtBranchCd").value = unescapeHTML2(parameters.branchCd);
			$("txtNbtBranchName").value = unescapeHTML2(parameters.branchName);
			$("txtTranDate").value = dateFormat(new Date(), "mm-dd-yyyy");
			$("txtJVTranType").value = unescapeHTML2(parameters.jvTranType);
			$("txtNbtTranDesc").value = unescapeHTML2(parameters.jvTranDesc);
			$("txtJVTranMm").value = "";
			$("rdoNonCash").checked = true;
			disableButton("btnDelete");
		}else{
			$("txtBranchCd").value = unescapeHTML2(objGUJV.branchCd);
			$("txtBranchCd").setAttribute("lastValidValue",unescapeHTML2(objGUJV.branchCd));
			$("txtNbtBranchName").value = unescapeHTML2(objGUJV.nbtBranchName);
			$("txtJVTranTag").value = objGUJV.jvTranTag;
			objGUJV.jvTranTag == "NC" ? $("rdoNonCash").checked = true : $("rdoCash").checked = true;
			$("txtTranDate").value = dateFormat(objGUJV.tranDate, "mm-dd-yyyy");
			$("txtTranMonth").value = objGUJV.tranMonth;
			$("txtTranYear").value = objGUJV.tranYear;
			$("txtTranSeqNo").value = objGUJV.tranSeqNo;
			$("txtJVTranType").value = unescapeHTML2(objGUJV.jvTranType);
			$("txtNbtTranDesc").value = unescapeHTML2(objGUJV.nbtJvTranDesc);
			$("txtNbtTranDesc").setAttribute("lastValidValue",unescapeHTML2(objGUJV.nbtJvTranDesc));
			$("txtJVTranMm").value = objGUJV.jvTranMm == null ? "" : objGUJV.jvTranMm;
			$("txtJVTranYy").value = objGUJV.jvTranYy;
			$("txtJVPrefSuff").value = unescapeHTML2(objGUJV.jvPrefSuff);
			$("txtJVNo").value = objGUJV.jvNo;
			$("txtParticulars").value = unescapeHTML2(objGUJV.particulars);		
			enableButton("btnDelete");	
		}
		
		if ($("rdoCash").checked) {
			$("txtJVTranMm").addClassName("required");
			$("txtJVTranYy").addClassName("required");
		} else {
			$("txtJVTranMm").removeClassName("required");
			$("txtJVTranYy").removeClassName("required");
		}		
		
		if (guf.tranClass == "" || guf.tranClass == null){
			initializeChangeTagBehavior(saveGiacs607JVPaytDtl);
		}else{			
			$$("div#jvPaytDtlDiv input[type='text'], div#jvPaytDtlDiv textarea").each(function (o) {
				$(o).readOnly = true;
			});
			
			$("rdoCash").disabled = true;
			$("rdoNonCash").disabled = true;
			disableSearch($("lovBranchCd"));
			disableSearch($("lovNbtTranDesc"));
			disableDate("hrefTranDate");
			$("txtJVTranMm").disabled = true;
			
			disableButton("btnDelete");
			disableButton("btnSave");
		}
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
	
	function showBranchCdLOV(isIconClicked){
		try{
			var searchString = isIconClicked? "%" : ($F("txtBranchCd").trim() == "" ? "%" : $F("txtBranchCd"));	
			
			LOV.show({
				controller : "ACUploadingLOVController",
				urlParameters : {
					action : "getGIACS607JVBranchCdLOV",
					searchString: searchString,
					page : 1
				},
				title : "List of Branch Codes",
				width : 380,
				height : 400,
				columnModel : [ 
					{
						id : "branchCd",
						title : "Branch Cd",
						width : '80px',
						renderer: function(value){
							return unescapeHTML2(value);
						}
					}, 
					{
						id : "branchName",
						title : "Branch Name",
						width : '280px',
						renderer: function(value){
							return unescapeHTML2(value);
						}
					}
				],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("txtBranchCd").value = unescapeHTML2(row.branchCd);
						$("txtBranchCd").setAttribute("lastValidValue", unescapeHTML2(row.branchCd));
						$("txtNbtBranchName").value = unescapeHTML2(row.branchName);
						
						changeTag = 1;
						editSw = true;
						changeTagFunc = saveGiacs607JVPaytDtl;
					}
				},
				onCancel: function(){
					$("txtBranchCd").focus();
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranchCd");
				} 
			});
		}catch(e){
			showErrorMessage("showBranchCdLOV", e);
		}
	}
	
	function showJVTranTypeLOV(isIconClicked){
		try{
			var searchString = isIconClicked? "%" : ($F("txtNbtTranDesc").trim() == "" ? "%" : $F("txtNbtTranDesc"));	
			
			LOV.show({
				controller : "ACUploadingLOVController",
				urlParameters : {
					action : "getGIACS607JVTranTypeLOV",
					jvTranTag: $("rdoCash").checked ? 'C':'NC',
					searchString: searchString,
					page : 1
				},
				title : "List of JV Tran Types",
				width : 380,
				height : 400,
				columnModel : [ 
					{
						id : "jvTranType",
						title : "Tran Cd",
						width : '80px',
						renderer: function(value){
							return unescapeHTML2(value);
						}
					}, 
					{
						id : "jvTranDesc",
						title : "Description",
						width : '280px',
						renderer: function(value){
							return unescapeHTML2(value);
						}
					}
				],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("txtJVTranType").value = unescapeHTML2(row.jvTranType);
						$("txtNbtTranDesc").value = unescapeHTML2(row.jvTranDesc);
						$("txtNbtTranDesc").setAttribute("lastValidValue", unescapeHTML2(row.jvTranDesc));
						
						changeTag = 1;
						editSw = true;
						changeTagFunc = saveGiacs607JVPaytDtl;
					}
				},
				onCancel: function(){
					$("txtNbtTranDesc").focus();
					$("txtNbtTranDesc").value = $("txtNbtTranDesc").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtNbtTranDesc").value = $("txtNbtTranDesc").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtNbtTranDesc");
				} 
			});
		}catch(e){
			showErrorMessage("showJVTranTypeLOV", e);
		}
	}
	

	function setObj(){	
		var obj = new Object();
		
		obj.sourceCd = guf.sourceCd;
		obj.fileNo = guf.fileNo;
		obj.branchCd = escapeHTML2($F("txtBranchCd"));
		obj.branchName = escapeHTML2($F("txtNbtBranchName"));
		obj.jvTranTag = $("rdoCash").checked ? "C" : "NC";
		obj.tranDate = dateFormat($F("txtTranDate"), "mm-dd-yyyy");
		obj.tranMonth = $F("txtTranMonth") == "" ? dateFormat($F("txtTranDate"), "m") : $F("txtTranMonth");
		obj.tranYear = $F("txtTranYear") == "" ? dateFormat($F("txtTranDate"), "yyyy") : $F("txtTranYear");
		obj.tranSeqNo = $F("txtTranSeqNo");
		obj.jvTranType = escapeHTML2($F("txtJVTranType"));
		obj.nbtTranDesc = escapeHTML2($F("txtNbtTranDesc"));
		obj.jvTranMm = $F("txtJVTranMm");
		obj.jvTranYy = $F("txtJVTranYy");
		obj.jvPrefSuff = escapeHTML2(nvl($F("txtJVPrefSuff"), "JV"));
		obj.jvNo = $F("txtJVNo");
		obj.particulars = escapeHTML2($F("txtParticulars"));
		
		return obj;
	}
	
	function saveGiacs607JVPaytDtl(closeOverlay){
		try{			
			if ((changeTag == 1 && editSw && checkAllRequiredFieldsInDiv('jvPaytDtlDiv')) ||
					(changeTag == 1 && !editSw)){
				
				if (changeTag == 1 && editSw){
					if (($F("txtJVTranMm") != "" && $F("txtJVTranYy") == "") || ($F("txtJVTranMm") == "" && $F("txtJVTranYy") != "")){
						var msg = $F("txtJVTranYy") == "" ? "Year." : "Month.";
						var field = $F("txtJVTranYy") == "" ? "txtJVTranYy" : "txtJVTranMm";
						
						showWaitingMessageBox("Please enter value for JV Tran " + msg, "I", function(){
							$(field).focus();
							$("txtTranMonth").value = dateFormat($F("txtTranDate"), "mm");
							$("txtTranYear").value = dateFormat($F("txtTranDate"), "yyyy");
							$("txtJVPrefSuff").value = "JV";
						});
						return false;
					}
				}
				
				var setRec = new Array();
				var delRec = new Array();
				
				if (deleteSw){
					var obj = new Object();
					obj.sourceCd = guf.sourceCd;
					obj.fileNo = guf.fileNo;
					delRec.push(obj);
				}
				
				if (editSw){
					var obj = setObj();
					setRec.push(obj);
				}
				
				new Ajax.Request(contextPath + "/GIACUploadingController",{
					method: "POST",
					parameters:{
						action:		"saveGIACS607JVPaytDtl",
						delRec:		prepareJsonAsParameter(delRec),
						setRec:		prepareJsonAsParameter(setRec),
						sourceCd:	guf.sourceCd,
						fileNo:		guf.fileNo
					},
					onCreate: showNotice("Saving JV Payment Details, please wait..."),
					onComplete: function(response){
						hideNotice();
						
						if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
							changeTagFunc = "";
							changeTag = 0;
							deleteSw = false;
							editSw = false;
							objGUJV = JSON.parse(response.responseText);
							showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
								if (closeOverlay){
									overlayJVPaytDtl.close();
								}else{
									initAll();
								}
							});
						}
					}
				});
			}
		}catch(e){
			showErrorMessage("saveGiacs607JVPaytDtl", e);
		}
	}
	$("lovBranchCd").observe("click", function(){
		showBranchCdLOV(true);
	});
	
	$("txtBranchCd").observe("change", function(){
		if (this.value != ""){
			showBranchCdLOV(false);
		}else{
			$("txtBranchCd").setAttribute("lastValidValue", "");
			$("txtNbtBranchName").clear();
		}
	});
	
	$("hrefTranDate").observe("click", function() {
		scwNextAction = function(){
							$("txtTranMonth").value = dateFormat($F("txtTranDate"), "mm");
							$("txtTranYear").value = dateFormat($F("txtTranDate"), "yyyy");
							$("txtJVPrefSuff").value = "JV";
							editSw = true;
							changeTag = 1;
							changeTagFunc = saveGiacs607JVPaytDtl;
						}.runsAfterSCW(this, null);
		
		scwShow($("txtTranDate"),this, null);
	});
	
	$("lovNbtTranDesc").observe("click", function(){
		showJVTranTypeLOV(true);
	});
	
	$("txtNbtTranDesc").observe("change", function(){
		if (this.value != ""){
			showJVTranTypeLOV(false);
		}else{
			$("txtNbtTranDesc").setAttribute("lastValidValue", "");
			$("txtJVTranType").clear();
		}
	});

	
	$$("input[name='rdoTranTag']").each(function(rb){
		$(rb).observe("click", function(){
			if ($("rdoCash").checked) {
				$("txtJVTranMm").value = dateFormat(new Date(), "m");
				$("txtJVTranYy").value = dateFormat(new Date(), "yyyy");
				$("txtJVTranMm").addClassName("required");
				$("txtJVTranYy").addClassName("required");
			} else {
				$("txtJVTranMm").removeClassName("required");
				$("txtJVTranYy").removeClassName("required");
			}
			
			$("txtJVTranTag").value = rb.value;
			
			new Ajax.Request(contextPath+"/ACUploadingLOVController?action=getGIACS607JVTranTypeLOV",{
				method: "POST",
				asynchronous: false,
				evalScripts: true,
				parameters:{
					jvTranTag: $("rdoCash").checked ? 'C':'NC',
					rowNum:		1,
					page:		1
				},
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						
						$("txtJVTranType").value = obj.rows[0].jvTranType;
						$("txtNbtTranDesc").value = obj.rows[0].jvTranDesc;
					}	
				}
			});

			editSw = true;
			changeTag = 1;
			changeTagFunc = saveGiacs607JVPaytDtl;
		});		
	});
	
	$("txtJVTranMm").observe("change", function(){
		if ($F("txtJVTranTag") == "C" && this.value == ""){
			showMessageBox("Please enter value for JV tran month.", "I");
		}
	});
	
	$("txtJVTranYy").observe("change", function(){
		if (($F("txtJVTranTag") == "C" || $F("txtJVTranMm") != "") && this.value == ""){
			showMessageBox("Please enter value for JV tran year.", "I");
		}
	});
	
	$("editParticulars").observe("click", function(){
		showOverlayEditor("txtParticulars", 2000, $("txtParticulars").hasAttribute("readonly"), function(){
			changeTag = 1;
			editSw = true;
		});
	});
	
	
	$("btnDelete").observe("click", function(){
		deleteSw = true;
		editSw = false;
		changeTag = 1;
		changeTagFunc = saveGiacs607JVPaytDtl;
			
		$$("div#jvPaytDtlDiv input[type='text'], div#jvPaytDtlDiv textarea").each(function (o) {
			$(o).clear();
		});
		
		initAll();
	});
	
	
	$("btnReturn").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveGiacs607JVPaytDtl(true);
					}, 
					function(){
						overlayJVPaytDtl.close();
						changeTag = 0;
					}, "");
		} else {
			overlayJVPaytDtl.close();
		}
		
	});
	
	observeSaveForm("btnSave", saveGiacs607JVPaytDtl);
	
	$$("div#jvPaytDtlDiv input[type='text'], div#jvPaytDtlDiv textarea").each(function (o) {
		$(o).observe("change", function(){
			editSw = true;
			changeTag = 1;
			changeTagFunc = saveGiacs607JVPaytDtl;
		});
	});

	addMonth(month);
	initAll();
}catch(e){
	showErrorMessage("Page Error", e);
}
</script>