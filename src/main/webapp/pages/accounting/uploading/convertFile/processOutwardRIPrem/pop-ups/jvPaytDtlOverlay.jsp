<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="jvPaytDtlDiv">
	<div class="sectionDiv" id="jvDtlDiv" changeTagAttr="true" style="margin-top: 5px; width: 740px;">
		<table border="0" align="left" style="margin: 10px 0 10px 15px;">
			<tr>
				<td class="rightAligned" style="padding-right: 4px;">Branch</td>
				<td class="leftAligned" id="test1">					
					<div id="lovBranchCdDiv" style="width: 51px; height: 21px; float: left; margin-left: 0px;" class="required withIconDiv">
						<input style="width: 25px; height: 15px;" id="txtBranchCd" name="txtBranchCd" type="text" value="" class="required withIcon" maxLength="50" tabindex="401" />
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovBranchCd" name="lovBranchCd" alt="Go" />
					</div>
					<input style="width: 225px;" id="txtDspBranchName" name="txtDspBranchName" type="text" value="" readOnly="readOnly" tabindex="402" />
				</td>
				<td colspan="2" style="padding-left: 90px;">
					<input type="hidden" id="txtJVTranTag"/>
					<input type="radio" name="rdoTranTag" id="rdoCash" title="Cash" value="C" style="float: left; margin-right: 6px" tabindex="403"/>
					<label for="rdoCash" style="float: left; height: 20px; padding-top: 4px; margin-right: 25px;">Cash</label>
					<input type="radio" name="rdoTranTag" id="rdoNonCash" title="Non Cash" value="NC" style="float: left; margin-right: 6px;" tabindex="404"/>
					<label for="rdoNonCash" style="float: left; height: 20px; padding-top: 4px;">Non Cash</label>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 4px;">Tran Date</td>
				<td class="leftAligned">
					<div style="width: 287px; height: 21px;" class="required withIconDiv" id="tranDateDiv">
			    		<input style="width: 262px; height: 15px;" type="text" id="txtTranDate" name="txtTranDate" readOnly="readOnly" class="required date withIcon" triggerChange = "Y" tabindex="405"/>
			    		<img id="btnTranDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Tran Date"/>
			    	</div>
				</td>
				<td class="rightAligned" style="padding: 0 4px 0 35px;" >Tran No.</td>
				<td class="leftAligned">
					<input class="rightAligned integerNoNegativeUnformattedNoComma" type="text" id="txtTranYear" name="txtTranYr" maxlength="4" readOnly="readOnly" style="width: 59px;" tabindex="407"/>
					<input class="rightAligned integerNoNegativeUnformattedNoComma" type="text" id="txtTranMonth" name=txtTranMonth maxlength="2" readOnly="readOnly" style="width: 39px;" tabindex="408"/>
					<input class="rightAligned integerNoNegativeUnformattedNoComma" type="text" id="txtTranSeqNo" name="txtTranSeqNo" maxlength="6" readOnly="readOnly" style= "width: 72px;" tabindex="409"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 4px;">JV Tran Type/Mo/Yr</td>
				<td class="leftAligned">
					<div style="float: left; padding-top: 2px;">
						<div id="lovTranTypeDiv" class="required withIconDiv" style="width: 140px; height: 21px;">
							<input type="hidden" id="txtJVTranType" name="txtJVTranType"/>
							<input type="text" id="txtDspTranDesc" name="txtDspTranDesc" style="width: 115px; float: left; border: none; height: 15px; margin: 0;" class="required disableDelKey" maxLength="40" tabindex="410"></input>								
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovNbtTranDesc" name="lovNbtTranDesc" alt="Go" style="float: right;"/>
						</div>
					</div>
					<div style="padding-left: 4px; padding-top: 2px; float: left;">
						<select class="required" id="txtJVTranMm" name="txtJVTranMmYy" style="width: 80px; height: 23px;" tabindex="411"></select>
					</div>
					<div style="padding-left: 4px; float: left;">
						<input class="required integerNoNegativeUnformattedNoComma rightAligned" type="text" id="txtJVTranYy" name="txtJVTranMmYy" maxlength="4" style="width: 51px;" tabindex="412"/>
					</div>
				</td>
				<td class="rightAligned" style="padding-right: 4px;">JV No.</td>
				<td class="leftAligned">
					<input type="text" id="txtJVPrefSuff" name="txtJVPrefSuff" style="width: 40px; float: left;" readonly="readonly" tabindex="413"/>
					<div style="width: 148px; height: 21px; margin-left: 4px;" class="withIconDiv" id="jvNoDiv">
						<input class="rightAligned withIcon" type="text" id="txtJVNo" name="txtJVNo" style="width: 120px;" readonly="readonly" tabindex="414"/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovJV" name="lovJV" alt="Go" style="float: right;"/>
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 4px; padding-top: 5px;" valign="top">Particulars</td>
				<td class="leftAligned" colspan="3">
					<div style="float: left; width: 585px; height: 66px;" class="withIconDiv required">
						<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" id="txtParticulars" name="txtParticulars" style="width: 558px; resize:none; height: 60px;" class="withIcon required" tabindex="415"> </textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editParticulars" />
					</div>
				</td>
			</tr>
		</table>
	</div>
	
	<div class="buttonsDiv" style="margin: 10px 0 0 0;">
		<input type="button" id="btnReturn" class="button" value="Return" style="width: 90px;" tabindex="417"/>
		<input type="button" id="btnSave" class="button" value="Save" style="width: 90px;" tabindex="418"/>
		<input type="button" id="btnDelete" class="button" value="Delete" style="width: 90px;" tabindex="419"/>
		<input type="hidden" id="hidTranId" name="hidTranId"/>
	</div>
</div>

<script type="text/javascript">
	try {
		/* variables */
		var objGUJV = JSON.parse('${gujpd}');
		var deleteSw = false;
		var editSw = false;
		var month = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", "" ];
		
		/* observe elements */
		$("txtBranchCd").observe("change", function() {
			if (this.value != "") {
				showBranchLOV(false);
			} else {
				$("txtBranchCd").setAttribute("lastValidValue", "");
				$("txtDspBranchName").clear();
			}
		});
		
		$("lovBranchCd").observe("click", function() {
			showBranchLOV(true);
		});

		$("btnTranDate").observe("click", function() {
			scwNextAction = function() {
				if($F("txtTranDate") != ""){
					var tranDateArray = $("txtTranDate").value.split("-");
					$("txtTranYear").value = tranDateArray[2];
		 			$("txtTranMonth").value = tranDateArray[0];
				} else {
					$("txtTranYear").value = "";
					$("txtTranMonth").value = "";
				}
				$("txtJVPrefSuff").value = "JV";
				if ($F("txtTranDate") == $("txtTranDate").readAttribute("lastValidValue")) {
					editSw = true;
					changeTag = 1;
					changeTagFunc = saveGiacs609JVPaytDtl;
				}
			}.runsAfterSCW(this, null);

			scwShow($("txtTranDate"), this, null);
		});
		
		$("txtTranDate").observe("keyup", function(event){
			if(event.keyCode == 46){
				$("txtTranDate").value = "";
				$("txtTranYear").value = "";
				$("txtTranMonth").value = "";
			}
		});
		
		$("lovJV").observe("click", function() {
			showJVLOV();
		});
		
		$("lovNbtTranDesc").observe("click", function() {
			showJVTranTypeLOV(true);
		});

		$("txtDspTranDesc").observe("change", function() {
			if (this.value != "") {
				showJVTranTypeLOV(false);
			} else {
				$("txtDspTranDesc").setAttribute("lastValidValue", "");
				$("txtJVTranType").clear();
			}
		});
		
		$("txtJVTranMm").observe("change", function() {
			if (guf.fileStatus != "1") {
				$("txtJVTranMm").value = $("txtJVTranMm").readAttribute("lastValidValue");
			} else if ($F("txtJVTranTag") == "C" && this.value == "") {
				showMessageBox("Please enter value for JV tran month.", imgMessage.INFO);
			}
		});

		$("txtJVTranYy").observe("change", function() {
			if ((($F("txtJVTranTag") == "C" || $F("txtJVTranMm") != "") && this.value == "")
				|| (parseInt(this.value) < 1000 && !this.value == "")) {
					showMessageBox("Please enter a valid JV tran year.", imgMessage.INFO);
					this.clear();
			}
		});

		$("editParticulars").observe("click", function() {
			showOverlayEditor("txtParticulars", 2000, $("txtParticulars").hasAttribute("readonly"),
				function() {
					changeTag = 1;
					editSw = true;
				});
		});
		
		$("btnReturn").observe("click", function() {
			if (changeTag == 1) {
				showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No",
					"Cancel", function() {
						saveGiacs609JVPaytDtl(true);
					}, function() {
						overlayJVPaytDtl.close();
						changeTag = 0;
					}, "");
			} else {
				overlayJVPaytDtl.close();
			}
		});
		
		observeSaveForm("btnSave", saveGiacs609JVPaytDtl);
		
		$("btnDelete").observe("click", function() {
			deleteSw = true;
			editSw = false;
			changeTag = 1;
			changeTagFunc = saveGiacs609JVPaytDtl;

			$$("div#jvPaytDtlDiv input[type='text'], div#jvPaytDtlDiv textarea").each(function(o) {
				$(o).clear();
			});

			initAll();
		});
		
		$("jvPaytDtlDiv").observe("keydown", function(event){
			var curEle = document.activeElement.id;
			if (event.keyCode == 9 && !event.shiftKey) {
				if (curEle == "btnReturn" && $("btnSave").disabled == true) {
					$("txtDspBranchName").focus();
					event.preventDefault();
				} else if (curEle == "btnDelete") {
					$("txtBranchCd").focus();
					event.preventDefault();
				} else if (curEle == "btnSave" && $("btnDelete").disabled == true) {
					$("txtBranchCd").focus();
					event.preventDefault();
				}
			} else if (event.keyCode == 9 && event.shiftKey) {
				if (curEle == "txtDspBranchName" && $("txtBranchCd").disabled == true) {
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

		$$("div#jvPaytDtlDiv input[type='text'], div#jvPaytDtlDiv textarea").each(function(o) {
			$(o).observe("change", function() {
				editSw = true;
				changeTag = 1;
				changeTagFunc = saveGiacs609JVPaytDtl;
			});
		});
		
		$$("input[name='rdoTranTag']").each(function(rb) {
			$(rb).observe("click", function() {
				if ($("rdoCash").checked) {
					if ($F("txtTranDate") != ""){
						var tranDateArray = $("txtTranDate").value.split("-");
						$("txtJVTranMm").value = parseInt(tranDateArray[0]);
						$("txtJVTranMm").setAttribute("lastValidValue", parseInt(tranDateArray[0]));
			 			$("txtJVTranYy").value = tranDateArray[2];
					} else {
						$("txtJVTranMm").value = dateFormat(new Date(), "m");
						$("txtJVTranMm").setAttribute("lastValidValue", dateFormat(new Date(), "m"));
						$("txtJVTranYy").value = dateFormat(new Date(), "yyyy");
					}
				}

				$("txtJVTranTag").value = rb.value;
				toggleTranMmYy();

				new Ajax.Request(contextPath + "/ACUploadingLOVController?action=getGiacs609JVTranTypeLOV", {
					method : "POST",
					asynchronous : false,
					evalScripts : true,
					parameters : {
						jvTranTag : $("rdoCash").checked ? 'C' : 'NC',
						rowNum : 1,
						page : 1
					},
					onComplete : function(response) {
						if (checkErrorOnResponse(response)) {
							var obj = JSON.parse(response.responseText);

							$("txtJVTranType").value = obj.rows[0].jvTranType;
							$("txtDspTranDesc").value = obj.rows[0].jvTranDesc;
							$("txtDspTranDesc").setAttribute("lastValidValue", obj.rows[0].jvTranDesc);
						}
					}
				});

				editSw = true;
				changeTag = 1;
				changeTagFunc = saveGiacs609JVPaytDtl;
			});
		});

		/* functions: LOV */
		function showBranchLOV(isIconClicked) {
			try {
				var searchString = isIconClicked ? "%" : ($F("txtBranchCd").trim() == "" ? "%" : $F("txtBranchCd"));
				
				LOV.show({
					controller : "ACUploadingLOVController",
					urlParameters : {
						action : "getGiacs609BranchLOV",
						moduleId : "GIACS003",
						searchString : searchString,
						page : 1
					},
					title : "List of Branch Codes",
					width : 380,
					height : 400,
					columnModel : [ {
						id : 'branchCd',
						title : 'Branch Cd',
						altTitle : 'Branch Code',
						width : '80px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'branchName',
						title : 'Branch Name',
						width : '280px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					} ],
					draggable : true,
					autoSelectOneRecord : true,
					filterText : escapeHTML2(searchString),
					onSelect : function(row) {
						if (row != null || row != undefined) {
							$("txtBranchCd").value = unescapeHTML2(row.branchCd);
							$("txtBranchCd").setAttribute("lastValidValue", unescapeHTML2(row.branchCd));
							$("txtDspBranchName").value = unescapeHTML2(row.branchName);

							changeTag = 1;
							editSw = true;
							changeTagFunc = saveGiacs609JVPaytDtl;
							
							if (isIconClicked) {
								$("txtBranchCd").focus();
							}
						}
					},
					onCancel : function() {
						$("txtBranchCd").focus();
						$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
					},
					onUndefinedRow : function() {
						$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
						customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranchCd");
					}
				});
			} catch (e) {
				showErrorMessage("showBranchLOV", e);
			}
		}

		function showJVTranTypeLOV(isIconClicked) {
			try {
				var searchString = isIconClicked ? "%" : ($F("txtDspTranDesc").trim() == "" ? "%" : $F("txtDspTranDesc"));

				LOV.show({
					controller : "ACUploadingLOVController",
					urlParameters : {
						action : "getGiacs609JVTranTypeLOV",
						jvTranTag : $("rdoCash").checked ? 'C' : 'NC',
						searchString : searchString,
						page : 1
					},
					title : "List of JV Tran Types",
					width : 380,
					height : 400,
					columnModel : [ {
						id : 'jvTranType',
						title : 'Tran Cd',
						altTitle : 'Transaction Code',
						width : '80px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'jvTranDesc',
						title : 'Description',
						width : '280px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					} ],
					draggable : true,
					autoSelectOneRecord : true,
					filterText : escapeHTML2(searchString),
					onSelect : function(row) {
						if (row != null || row != undefined) {
							$("txtJVTranType").value = unescapeHTML2(row.jvTranType);
							$("txtDspTranDesc").value = unescapeHTML2(row.jvTranDesc);
							$("txtDspTranDesc").setAttribute("lastValidValue", unescapeHTML2(row.jvTranDesc));

							changeTag = 1;
							editSw = true;
							changeTagFunc = saveGiacs609JVPaytDtl;
							
							if (isIconClicked) {
								$("txtDspTranDesc").focus();
							}
						}
					},
					onCancel : function() {
						$("txtDspTranDesc").focus();
						$("txtDspTranDesc").value = $("txtDspTranDesc").readAttribute("lastValidValue");
					},
					onUndefinedRow : function() {
						$("txtDspTranDesc").value = $("txtDspTranDesc").readAttribute("lastValidValue");
						customShowMessageBox("No record selected.", imgMessage.INFO, "txtDspTranDesc");
					}
				});
			} catch (e) {
				showErrorMessage("showJVTranTypeLOV", e);
			}
		}
		
		function showJVLOV() {
			try {
				LOV.show({
					controller : "ACUploadingLOVController",
					urlParameters : {
						action : "getGiacs609JVLOV",
						tranDate : $F("txtTranDate"),
						page : 1
					},
					title : "JV Details",
					width : 500,
					height : 402,
					columnModel : [ {
						id : 'branchCd',
						title : 'Branch Cd',
						altTitle : 'Branch Code',
						align : 'center',
						titleAlign: 'center',
						width : '80px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'tranDate',
						title : 'Tran Date',
						altTitle : 'Transaction Date',
						align : 'center',
						titleAlign: 'center',
						width : '80px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'jvTranTag',
						title : 'JV Tran Tag',
						align : 'center',
						titleAlign: 'center',
						width : '80px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'jvTranType',
						title : 'JV Tran Type',
						align : 'center',
						titleAlign: 'center',
						width : '86px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'jvTranMm',
						title : 'JV Tran MM',
						altTitle : 'JV Tran Month',
						align : 'center',
						titleAlign: 'center',
						width : '80px',
						renderer : function(value) {
							return (value == "" ? "" : lpad(value, 2, 0));
						}
					}, {
						id : 'jvTranYy',
						title : 'JV Tran YY',
						altTitle : 'JV Tran Year',
						align : 'center',
						titleAlign: 'center',
						width : '80px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'tranYear',
						title : 'Tran Year',
						align : 'center',
						titleAlign: 'center',
						width : '80px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'tranMonth',
						title : 'Tran Month',
						align : 'center',
						titleAlign: 'center',
						width : '80px',
						renderer : function(value) {
							return (value == "" ? "" : lpad(value, 2, 0));
						}
					}, {
						id : 'tranSeqNo',
						title : 'Tran Seq No',
						altTitle : 'Transaction Sequence No',
						align : 'center',
						titleAlign: 'center',
						width : '82px',
						renderer : function(value) {
							return (value == "" ? "" : lpad(value, 6, 0));
						}
					}, {
						id : 'jvPrefSuff',
						title : 'JV Prefix',
						align : 'center',
						titleAlign: 'center',
						width : '80px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'jvNo',
						title : 'JV No',
						align : 'center',
						titleAlign: 'center',
						width : '80px',
						renderer : function(value) {
							return (value == "" ? "" : lpad(value, 6, 0));
						}
					}, {
						id : 'particulars',
						title : 'Particulars',
						width : '450px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					} ],
					draggable : true,
					autoSelectOneRecord : false,
					onSelect : function(row) {
						showConfirmBox("Confirmation", "The JV details provided will be changed to the JV details of the chosen JV No."
								+ "<br> Do you wish to proceed?",
								"Yes", "No", function() {
									populateDtls(row);
									changeTag = 1;
									editSw = true;
									changeTagFunc = saveGiacs609JVPaytDtl;
									$("txtJVNo").focus();
								}, function() {
									$("txtJVNo").focus();
								}, null);
					},
					onCancel : function() {
						$("txtJVNo").focus();
					},
					onUndefinedRow : function() {
						customShowMessageBox("No record selected.", imgMessage.INFO, "txtJVNo");
					}
				});
			} catch (e) {
				showErrorMessage("showJVLOV", e);
			}
		}
		
		/* functions: button */
		function saveGiacs609JVPaytDtl(closeOverlay) {
			try {
				if ((changeTag == 1 && editSw && checkAllRequiredFieldsInDiv('jvPaytDtlDiv'))
						|| (changeTag == 1 && !editSw)) {
					var setRec = new Array();
					var delRec = new Array();

					if (deleteSw) {
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
							action : "saveGiacs609JVPaytDtl",
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
								deleteSw = false;
								editSw = false;
								objGUJV = JSON.parse(response.responseText);
								showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function() {
									if (closeOverlay) {
										overlayJVPaytDtl.close();
									} else {
										initAll();
									}
								});
							}
						}
					});
				}
			} catch (e) {
				showErrorMessage("saveGiacs609JVPaytDtl", e);
			}
		}
		
		/* functions: populate */
		function initAll() {
			if (deleteSw || objGUJV.tranDate == undefined) {
				if (guf.fileStatus == "1") {
					$("txtBranchCd").value = unescapeHTML2(parameters.branchCd);
					$("txtBranchCd").setAttribute("lastValidValue", unescapeHTML2(parameters.branchCd));
					$("txtDspBranchName").value = unescapeHTML2(parameters.branchName);
					$("txtTranDate").value = dateFormat(new Date(), "mm-dd-yyyy");
					$("txtJVTranType").value = unescapeHTML2(parameters.jvTranType);
					$("txtDspTranDesc").value = unescapeHTML2(parameters.jvTranDesc);
					$("txtDspTranDesc").setAttribute("lastValidValue", unescapeHTML2(parameters.jvTranDesc));
					$("txtParticulars").value = "";
				}
				
				$("txtJVTranMm").value = "";
				$("txtJVTranMm").setAttribute("lastValidValue", "");
				$("rdoNonCash").checked = true;
				$("txtJVTranTag").value = "NC";
				disableButton("btnDelete");
				toggleTranMmYy();
			} else {				
				populateDtls(objGUJV);
				enableButton("btnDelete");
			}
			
			if (guf.fileStatus == "1") {
				$("txtBranchCd").focus();
				initializeChangeTagBehavior(saveGiacs609JVPaytDtl);
			} else {
				$("btnReturn").focus();
				$$("div#jvPaytDtlDiv input[type='text'], div#jvPaytDtlDiv textarea, div#jvPaytDtlDiv input[type='radio'],"
					+"div#jvPaytDtlDiv div, div#jvPaytDtlDiv select").each(function(o) {
						$(o).readOnly = true;
						
						if ($(o).hasClassName('required') || $(o).type == "radio") {
							$(o).removeClassName("required");
							$(o).disabled = true;
							if ($(o).nodeName == "DIV") {
								$(o).style.backgroundColor = "#d4d0c8";
							}
						}
				});
				
				disableSearch($("lovBranchCd"));
				disableSearch($("lovNbtTranDesc"));
				disableSearch($("lovJV"));
				disableDate("btnTranDate");
				disableButton("btnDelete");
				disableButton("btnSave");
			}
		}

		function addMonth(monArray) {
			for (var i = 0; i < monArray.length; i++) {
				var opt = document.createElement('option');
				opt.text = monArray[i];
				opt.value = i + 1;
				if (opt.value == 13) {
					opt.value = "";
				}
				$("txtJVTranMm").options.add(opt);
			}
		}
		
		function setObj() {
			var obj = new Object();
			var tranDateArray = $("txtTranDate").value.split("-");

			obj.sourceCd = escapeHTML2(guf.sourceCd);
			obj.fileNo = guf.fileNo;
			obj.branchCd = escapeHTML2($F("txtBranchCd"));
			obj.tranYear = $F("txtTranYear") == "" ? tranDateArray[2] : $F("txtTranYear");
			obj.tranMonth = $F("txtTranMonth") == "" ? tranDateArray[0] : $F("txtTranMonth");
			obj.tranSeqNo = $F("txtTranSeqNo");
			obj.tranDate = escapeHTML2($F("txtTranDate"));
			obj.jvPrefSuff = escapeHTML2(nvl($F("txtJVPrefSuff"), "JV"));
			obj.jvNo = $F("txtJVNo");
			obj.particulars = escapeHTML2($F("txtParticulars"));
			obj.jvTranTag = escapeHTML2($F("txtJVTranTag"));
			obj.jvTranType = escapeHTML2($F("txtJVTranType"));
			obj.jvTranMm = $F("txtJVTranMm");
			obj.jvTranYy = $F("txtJVTranYy");
			obj.tranId = $F("hidTranId") == undefined ? "" : $F("hidTranId");

			return obj;
		}
		
		function populateDtls(row) {
			if (row != null || row != undefined) {
				$("txtBranchCd").value = unescapeHTML2(row.branchCd);
				$("txtBranchCd").setAttribute("lastValidValue", unescapeHTML2(row.branchCd));
				$("txtDspBranchName").value = unescapeHTML2(row.dspBranchName);
				$("txtJVTranTag").value = unescapeHTML2(row.jvTranTag);
				row.jvTranTag == "NC" ? $("rdoNonCash").checked = true : $("rdoCash").checked = true;
				$("txtTranDate").value = unescapeHTML2(row.tranDate);
				$("txtTranDate").setAttribute("lastValidValue", row.tranDate);
				$("txtTranYear").value = row.tranYear;
				$("txtTranMonth").value = lpad(row.tranMonth, 2, 0);
				$("txtTranSeqNo").value = lpad(row.tranSeqNo, 6, 0);
				$("txtJVTranType").value = unescapeHTML2(row.jvTranType);
				$("txtDspTranDesc").value = unescapeHTML2(row.dspJvTranDesc);
				$("txtDspTranDesc").setAttribute("lastValidValue", unescapeHTML2(row.dspJvTranDesc));
				$("txtJVTranMm").value = row.jvTranMm;
				$("txtJVTranMm").setAttribute("lastValidValue", row.jvTranMm);
				$("txtJVTranYy").value = row.jvTranYy;
				$("txtJVPrefSuff").value = unescapeHTML2(row.jvPrefSuff);
				$("txtJVNo").value = lpad(row.jvNo, 6, 0);
				$("txtParticulars").value = unescapeHTML2(row.particulars);
				$("hidTranId").value = row.tranId == undefined ? "" : row.tranId;
				toggleTranMmYy();
			}
		}
		
		function toggleTranMmYy() {
			$$("[name='txtJVTranMmYy']").each(function(o) {
				if ($F("txtJVTranTag") == "C") {
					$(o).addClassName("required");
				} else {
					$(o).removeClassName("required");
				}
			});
		}
		
		/* populate */
		addMonth(month);
		initAll();
		initializeAll();
	} catch (e) {
		showErrorMessage("Page Error", e);
	}
</script>