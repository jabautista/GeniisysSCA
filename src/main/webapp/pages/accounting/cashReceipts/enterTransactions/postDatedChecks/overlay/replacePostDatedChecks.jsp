<div class="sectionDiv" style="width: 600px; margin-top: 5px;">
	<div id="replacePDCTableDiv" style="padding-top: 10px;">
		<div id="replacePDCTable" style="height: 180px; padding-left: 10px;"></div>
	</div>
	<table style="width: 200px; float: right; margin-right: 65px;">
		<tr>
			<td>Net Total</td>
			<td><input type="text" id="txtNetTotal" class="rightAligned" name="txtNetTotal" ignoreDelKey="1" style="width: 110px; height: 15px;" readonly="readonly"/></td>
		</tr>
	</table>
</div>
<div align="center" class="sectionDiv" style="width: 600px; margin-top: 5px;" id="paramFormDiv">
	<table cellspacing="2" style="width: 200px; margin-top: 10px; margin-bottom: 10px;">
		<tr>
			<th>Bank</th>
			<th>Check Number</th>
			<th>Amount</th>
		</tr>
		<tr>
			<td class="leftAligned" style="width:120px;">
				<input id="bankSname" type="text" ignoreDelKey="1" class="disableDelKey allCaps" style="width: 100px;" tabindex="101" readonly="readonly">
			</td>
			<td class="leftAligned">
				<input id="checkNo" type="text" ignoreDelKey="1" class="disableDelKey allCaps" style="width: 100px;" tabindex="102" readonly="readonly">
			</td>
			<td class="leftAligned">
				<input id="amount" type="text" ignoreDelKey="1" class="disableDelKey allCaps rightAligned " style="width: 100px;" tabindex="103" readonly="readonly">
			</td>
			<td>
				<label style="width: 100px; text-align: right;">DCB Date</label>
			</td>
			<td class="leftAligned">
				<div id="dcbDateDiv" class="required" style="float: left; border: 1px solid gray; width: 110px; height: 20px;">
					<input id="dcbDate" name="DCB Date." ignoreDelKey="1" readonly="readonly" type="text" class=" required date " maxlength="10" style="border: none; float: left; width: 85px; height: 13px; margin: 0px;" value="" tabindex="104"/>
					<img id="imgDCBDate" alt="imgDCBDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('dcbDate'),this, null);" />
				</div>
			</td>
		</tr>
	</table>
</div>
<div align="center" class="sectionDiv" style="width: 600px; margin-top: 5px;" id="paramFormDiv">	
	<table style="margin-top: 5px;">
		<tr>
			<td class="rightAligned">Pay Mode</td>
			<td class="leftAligned">
				<select id="selPayMode" class="required" style="width: 150px;">
					<option value="CA">CA</option>
					<option value="CHK">CHK</option>
					<option value="CM">C.M.</option>
					<option value="CC">C.C.</option>
					<option value="PDC">PDC</option>
				</select>
			</td>
			<td class="rightAligned">Local Currency Amount</td>
			<td class="leftAligned">
				<span class="lovSpan " style="border: none; height: 21px; margin: 0 2px 0 0; float: left;">
					<input type="text" id="txtCurrAmt" name="txtCurrAmt" ignoreDelKey="1" style="width: 126px; float: left; height: 15px;" class="required applyDecimalRegExp2" maxlength="" regExpPatt="pDeci1202" min="0.00" max="999999999999.99" customLabel="Local Currency Amount" tabindex="201" />
				</span>
				<span class="lovSpan required" style="width: 69px; height: 21px; margin: 2px 2px 0 0; float: left;">
					<input type="text" id="txtCurrCd" name="txtCurrCd" ignoreDelKey="1" style="width: 42px; float: left; border: none; height: 13px;" class="required disableDelKey allCaps" maxlength="3" tabindex="202" />
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchCurrCd" name="searchCurrCd" alt="Go" style="float: right;">
				</span> 
			</td>
		</tr>	
		<tr>
			<td class="rightAligned">Check Class</td>
			<td class="leftAligned">
				<select id="selCheckClass" style="width: 150px;">
					<option value=""></option>
					<option value="L">Local Clearing</option>
					<option value="M">Manager's Check</option>
					<option value="O">On-us</option>
					<option value="R">Regional</option>
				</select>
			</td>
			<td class="rightAligned" width="145px">Bank</td>
			<td class="leftAligned">
				<span id="searchBankSpan" class="lovSpan" style="width: 205px; height: 21px; margin: 2px 2px 0 0; float: left;">
					<input type="text" id="txtBank" name="txtBank" style="width: 173px; float: left; border: none; height: 13px;" class="allCaps" maxlength="10" tabindex="203" />
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBank" name="searchBank" alt="Go" style="float: right;">
				</span> 
			</td>
		</tr>	
		<tr>
			<td class="rightAligned">Check Date</td>
			<td class="leftAligned">
				<div id="startDateDiv" class="" style="float: left; border: 1px solid gray; width: 148px; height: 20px;">
					<input id="checkDate" name="Check Date." ignoreDelKey="1" readonly="readonly" type="text" class="date " maxlength="10" style="border: none; float: left; width: 123px; height: 13px; margin: 0px;" value="" tabindex="204"/>
					<img id="imgCheckDate" alt="imgCheckDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('checkDate'),this, null);" />
				</div>
			</td>
			<td class="rightAligned">Check/Credit Card No.</td>
			<td class="leftAligned">
				<input id="txtChkCdtCardNo" type="text" class="allCaps" style="width: 199px;" tabindex="205" maxlength="25">
			</td>
		</tr>
	</table>
</div>
<div align="center" class="sectionDiv" style="width: 600px; margin-top: 5px;" id="paramFormDiv">
	<table cellspacing="2" style="width: 200px; margin-top: 10px; margin-bottom: 10px;">
		<tr>
			<th>Gross Amount</th>
			<th>Comm. Amount</th>
			<th>VAT Amount</th>
		</tr>
		<tr>
			<td class="leftAligned" style="width:120px;">
				<input id="grossAmt" type="text" ignoreDelKey="1" class="applyDecimalRegExp2 rightAligned" style="width: 130px;" tabindex="301" maxlength="" regExpPatt="pDeci1202" min="0.01" max="999999999999.99" customLabel="Gross Amount" readonly="readonly">
			</td>
			<td class="leftAligned">
				<input id="commAmt" type="text" ignoreDelKey="1" class="applyDecimalRegExp2 rightAligned" style="width: 130px;" tabindex="302" maxlength="" regExpPatt="pDeci1202" min="0.01" max="999999999999.99" customLabel="Comm. Amount" readonly="readonly">
			</td>
			<td class="leftAligned">
				<input id="vatAmt" type="text" ignoreDelKey="1" class="applyDecimalRegExp2 rightAligned " style="width: 130px;" tabindex="303" maxlength="" regExpPatt="pDeci1202" min="0.01" max="999999999999.99" customLabel="VAT Amount" readonly="readonly">
			</td>
		</tr>
	</table>
	<div style="margin: 10px;" align="center">
		<input type="button" class="button" id="btnAdd" value="Add" tabindex="208">
		<input type="button" class="button" id="btnDelete" value="Delete" tabindex="209">
	</div>
</div>
<div align="center">
	<input type="button" class="button" value="Save" id="btnSave" style="margin-top: 10px; width: 100px;" />
	<input type="button" class="button" value="Return" id="btnReturn" style="margin-top: 10px; width: 100px;" />
</div>
<script type="text/javascript">	
	initializeAll();
	initializeAccordion();
	var object = JSON.parse('${object}');
	toggleRequiredFields("CA");
	$("dcbDate").value = "05-24-2007";
	var orCurrencyCd = "";
	
	$("btnReturn").observe("click",function(){
		overlayReplace.close();
		delete overlayReplace;
	});
	
	$("bankSname").value = object.bankSname;
	$("checkNo").value = object.checkNo;
	$("amount").value = formatCurrency(object.amount);
	var giacs032Object = {};
	giacs032Object.dcbNo = "";
	
	/*var dcbDate = new Date();
	$("dcbDate").value = dateFormat(dcbDate, 'mm-dd-yyyy');*/
	
	$("searchCurrCd").observe("click",function(){
		showCurrencyLOV();
	});
	
	function showCurrencyLOV(){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					  action : "getGiacs032CurrencyLOV",
					  filterText: $F("txtCurrCd") != $("txtCurrCd").getAttribute("lastValidValue") ? nvl(($F("txtCurrCd")), "%") : "%",  
						page : 1
				},
				title: "List of Currency Code",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'shortName',
						title: 'Code',
						width : '100px',
						align: 'left'
					},
					{
						id : 'currencyDesc',
						title: 'Desc',
					    width: '335px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				filterText: $F("txtCurrCd") != $("txtCurrCd").getAttribute("lastValidValue") ? nvl(($F("txtCurrCd")), "%") : "%",  
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtCurrCd").value = unescapeHTML2(row.shortName);
						giacs032Object.currencyRt = row.currencyRt;
						giacs032Object.currencyCd = row.mainCurrencyCd;
						if(orCurrencyCd != ""){
							if(orCurrencyCd != row.mainCurrencyCd){
								showWaitingMessageBox("Only one currency is allowed per O.R.", "I", function(){
									$("txtCurrCd").value = "";
									giacs032Object.currencyRt = "";
									giacs032Object.currencyCd = "";
								});
							}
						}
					}
				},
				onCancel: function(){
					$("txtCurrCd").value = $("txtCurrCd").getAttribute("lastValidValue");
					$("txtCurrCd").focus();
		  		},
		  		onUndefinedRow: function(){
		  			$("txtCurrCd").value = $("txtCurrCd").getAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtCurrCd");
		  		}
			});
		}catch(e){
			showErrorMessage("showCurrencyLOV",e);
		}
	}
	
	$("txtCurrCd").observe("change", function(){
		if($F("txtCurrCd") != ""){
			showCurrencyLOV();
		} else {
			giacs032Object.currencyRt = "";
			giacs032Object.currencyCd = "";
		}
	});
	
	$("searchBank").observe("click",function(){
		showBankLOV();
	});
	
	function showBankLOV(){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					  action : "getGiacs032BankLOV",
					  filterText: $F("txtBank") != $("txtBank").getAttribute("lastValidValue") ? nvl(($F("txtBank")), "%") : "%",  
						page : 1
				},
				title: "List of Banks",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'bankSname',
						title: 'Code',
						width : '100px',
						align: 'left'
					},
					{
						id : 'bankName',
						title: 'Desc',
					    width: '335px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				filterText: $F("txtBank") != $("txtBank").getAttribute("lastValidValue") ? nvl(($F("txtBank")), "%") : "%",  
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtBank").value = unescapeHTML2(row.bankSname);
						giacs032Object.bankCd = (row.bankCd);
					}
				},
				onCancel: function(){
					$("txtBank").value = $("txtBank").getAttribute("lastValidValue");
					$("txtBank").focus();
		  		},
		  		onUndefinedRow: function(){
		  			$("txtBank").value = $("txtBank").getAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtBank");
		  		}
			});
		}catch(e){
			showErrorMessage("showBankLOV",e);
		}
	}
	
	$("txtBank").observe("change", function(){
		if($F("txtBank") != ""){
			showBankLOV();
		} else {
			giacs032Object.bankCd = "";
		}
	});
	
	$("selPayMode").observe("change", function(){
		var payMode = $F("selPayMode");
		toggleRequiredFields(payMode);
	});	
	
	function toggleRequiredFields(payMode){
		if(payMode == "CA"){
			//erase values
			$("selCheckClass").value = "";
			$("txtChkCdtCardNo").value = "";
			$("checkDate").value = "";
			$("txtBank").value = "";
			//disable fields
			$("selCheckClass").disabled = true;
			disableDate("imgCheckDate");
			disableSearch("searchBank");
			$("txtBank").readOnly = true;
			$("txtChkCdtCardNo").readOnly = true;
			//remove highlight
			$("selCheckClass").removeClassName("required");
			$("checkDate").removeClassName("required");
			$("txtChkCdtCardNo").removeClassName("required");
			$("txtBank").removeClassName("required");
			$("searchBankSpan").setStyle("background-color: white;");
			$("startDateDiv").setStyle("background-color: white;");
		} else if(payMode == "CM"){
			//erase values
			$("selCheckClass").value = "";
			$("txtChkCdtCardNo").value = "";
			$("checkDate").value = "";
			$("txtBank").value = "";
			//disable fields
			$("selCheckClass").disabled = true;
			disableDate("imgCheckDate");
			enableSearch("searchBank");
			$("txtBank").readOnly = false;
			$("txtChkCdtCardNo").readOnly = true;
			//remove highlight
			$("selCheckClass").removeClassName("required");
			$("checkDate").removeClassName("required");
			$("txtChkCdtCardNo").removeClassName("required");
			$("txtBank").addClassName("required");
			$("searchBankSpan").setStyle("background-color: white;");
			$("startDateDiv").setStyle("background-color: white;");
		} else if(payMode == "CC"){
			//erase values
			$("selCheckClass").value = "";
			$("txtChkCdtCardNo").value = "";
			$("checkDate").value = "";
			$("txtBank").value = "";
			//disable fields
			$("selCheckClass").disabled = true;
			disableDate("imgCheckDate");
			enableSearch("searchBank");
			$("txtBank").readOnly = false;
			$("txtChkCdtCardNo").readOnly = false;
			//remove highlight
			$("selCheckClass").removeClassName("required");
			$("checkDate").removeClassName("required");
			$("txtChkCdtCardNo").addClassName("required");
			$("txtBank").addClassName("required");
			$("searchBankSpan").setStyle("background-color: white;");
			$("startDateDiv").setStyle("background-color: white;");
		} else {
			//erase values
			$("selCheckClass").value = "";
			$("txtChkCdtCardNo").value = "";
			$("checkDate").value = "";
			$("txtBank").value = "";
			//disable fields
			$("selCheckClass").disabled = false;
			enableSearch("imgCheckDate");
			enableSearch("searchBank");
			$("txtBank").readOnly = false;
			$("txtChkCdtCardNo").readOnly = false;
			//remove highlight
			$("selCheckClass").addClassName("required");
			$("checkDate").addClassName("required");
			$("txtChkCdtCardNo").addClassName("required");
			$("txtBank").addClassName("required");
			$("searchBankSpan").setStyle("background-color: #FFFACD;");
			$("startDateDiv").setStyle("background-color: #FFFACD;");
		}
	}
	
	$("txtCurrAmt").observe("change", function(){
		if($F("txtCurrAmt") != ""){
			if(parseFloat($F("txtCurrAmt").replace(/,/g, "")) > parseFloat($F("amount").replace(/,/g, ""))){
				showWaitingMessageBox("Amount Entered should not be greater than the amount of the checked replaced.", "I", function(){
					$("txtCurrAmt").value = "";
					$("grossAmt").value = "";
					$("commAmt").value = "";
					$("vatAmt").value = "";
				});
			} else { 
				$("commAmt").readOnly = false;
				$("vatAmt").readOnly = false;
				
				$("grossAmt").value = "";
				$("commAmt").value = "";
				$("vatAmt").value = "";
				
				$("grossAmt").value = formatCurrency($F("txtCurrAmt"));
			}
		} else {
			$("grossAmt").value = "";
			$("commAmt").readOnly = true;
			$("vatAmt").readOnly = true;
		}
	});
	
	$("commAmt").observe("change", function(){
		if($("commAmt").value != ""){
			if($("vatAmt").value != ""){
				$("txtCurrAmt").value = formatCurrency(parseFloat($F("grossAmt").replace(/,/g, "")) - (parseFloat($F("vatAmt").replace(/,/g, "")) + parseFloat($F("commAmt").replace(/,/g, ""))));
			} else {
				$("txtCurrAmt").value = formatCurrency(parseFloat($F("grossAmt").replace(/,/g, "")) - parseFloat($F("commAmt").replace(/,/g, "")));
			}
		} else {
			if($("vatAmt").value != ""){
				$("txtCurrAmt").value = formatCurrency(parseFloat($F("grossAmt").replace(/,/g, "")) - parseFloat($F("vatAmt").replace(/,/g, "")));
			} else {
				$("txtCurrAmt").value = formatCurrency(parseFloat($F("grossAmt").replace(/,/g, "")));
			}
		}
		checkNetAmount(this);
	});
	
	$("vatAmt").observe("change", function(){
		if($("vatAmt").value != ""){
			if($("commAmt").value != ""){
				$("txtCurrAmt").value = formatCurrency(parseFloat($F("grossAmt").replace(/,/g, "")) - (parseFloat($F("vatAmt").replace(/,/g, "")) + parseFloat($F("commAmt").replace(/,/g, ""))));
			} else {
				$("txtCurrAmt").value = formatCurrency(parseFloat($F("grossAmt").replace(/,/g, "")) - parseFloat($F("vatAmt").replace(/,/g, "")));
			}
		} else {
			if($("commAmt").value != ""){
				$("txtCurrAmt").value = formatCurrency(parseFloat($F("grossAmt").replace(/,/g, "")) - parseFloat($F("commAmt").replace(/,/g, "")));
			} else {
				$("txtCurrAmt").value = formatCurrency(parseFloat($F("grossAmt").replace(/,/g, "")));
			}
		}
		checkNetAmount(this);
	});
	
	
	function checkNetAmount(field){
		if(parseFloat($F("txtCurrAmt").replace(/,/g, "")) <= 0){
			showWaitingMessageBox("Net Amount should not be zero.", "I", function(){
				field.focus();
 				field.value = "";
 				$("txtCurrAmt").value = formatCurrency(parseFloat($F("grossAmt").replace(/,/g, "")) - parseFloat(nvl($F("vatAmt").replace(/,/g, ""),0)) - parseFloat(nvl($F("commAmt").replace(/,/g, ""),0)));
			});
		}
	}
	
	var prevDcbDate = "";
	$("dcbDate").observe("blur", function(){
		if($F("dcbDate") != ""){
			new Ajax.Request(contextPath+"/GIACPdcChecksController", {
				method: "POST",
				parameters : {
								action : "checkDateForDeposit",
								fundCd: object.fundCd,
								branchCd: object.branchCd,
								dcbDate: $F("dcbDate") 
							},
				onCreate : showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					var obj = JSON.parse(response.responseText);
					if(obj.dcbflag == "T" || obj.dcbflag == "C"){
						showWaitingMessageBox("DCB for " + dateFormat(obj.tranDate,"mmmm d, yyyy") + " has already been closed." , imgMessage.INFO, function(){
							$("dcbDate").value = "";
							prevDcbDate = "";
						});
					} else if (obj.dcbNo == null && obj.dcbflag == null && obj.tranDate == null) {
						showWaitingMessageBox("There is no open DCB for " + dateFormat($F("dcbDate") ,"mmmm d, yyyy") + "." , imgMessage.INFO, function(){
							$("dcbDate").value = "";
							prevDcbDate = "";
						});
					} else if (Date.parse($F("dcbDate")) < Date.parse(object.checkDate)){
						showWaitingMessageBox("DCB Date should be equal or later than check date." , imgMessage.INFO, function(){
							$("dcbDate").value = "";
							prevDcbDate = "";
						});
 					} else {
 						giacs032Object.dcbNo = obj.dcbNo;
 						prevDcbDate = $F("dcbDate");
 					}
				}
			}); 
		}
	});
	
	/* $("btnOk").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("paramFormDiv")){
			if(parseFloat($F("txtCurrAmt").replace(/,/g, "")) != parseFloat($F("amount").replace(/,/g, ""))){
				showWaitingMessageBox("Total replacement amount should be equal to the check amount" , imgMessage.INFO, function(){
					$("txtCurrAmt").focus();
				});
			} else {
				alert(dcbNo);
			}
		}
	}); */
	
	var rowIndex = -1;
	var objCurrRepPDC = null;
	replacePDCTable = {
			url : contextPath,
			options : {
				width : '580px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrRepPDC = tbgReplacePDC.geniisysRows[y];
					setFieldValues(objCurrRepPDC);
					tbgReplacePDC.keys.removeFocus(tbgReplacePDC.keys._nCurrentFocus, true);
					tbgReplacePDC.keys.releaseKeys();
					$("selPayMode").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgReplacePDC.keys.removeFocus(tbgReplacePDC.keys._nCurrentFocus, true);
					tbgReplacePDC.keys.releaseKeys();
					$("selPayMode").focus();
				},					
				/* beforeSort : function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				}, */
				/* onSort: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgReplacePDC.keys.removeFocus(tbgReplacePDC.keys._nCurrentFocus, true);
					tbgReplacePDC.keys.releaseKeys();
				}, */
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgReplacePDC.keys.removeFocus(tbgReplacePDC.keys._nCurrentFocus, true);
					tbgReplacePDC.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					rowIndex = -1;
					setFieldValues(null);
					tbgReplacePDC.keys.removeFocus(tbgReplacePDC.keys._nCurrentFocus, true);
					tbgReplacePDC.keys.releaseKeys();
				},
				checkChanges: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTag == 1 ? true : false);
				}
			},								
			columnModel: [
				{
					    id: 'recordStatus',
					    title: '',
					    width: '0',
					    visible: false
					},
					{
						id: 'divCtrId',
						width: '0',
						visible: false 
					},				
					{
						id : "payMode", 
						title: "Pay Mode",
						width: '70px',
						sortable: false
						
					},
					{
						id : "checkClass", 
						title: "Check Class",
						width: '90px',
						sortable: false
					},
					{
						id : "checkNo", 
						title: "Check/Credit Card No.",
						width: '140px',
						sortable: false
					},
					{
						id : "checkDate",
						title: "Check Date",
						width: '80px',
						align : "center",
						titleAlign : "center",
						sortable: false,
						renderer: function (value){
							var dateTemp;
							if(value=="" || value==null){
								dateTemp = "";
							}else{
								dateTemp = dateFormat(value,"mm-dd-yyyy");
							}
							value = dateTemp;
							return value;
						}
					},
					{
						id : "amt", 
						title: "Local Amount",
						width: '100px',
						geniisysClass : 'money',
						align : "right",
						titleAlign : "right",
						sortable: false
					},
					{
						id : "currency", 
						title: "Currency",
						width: '70px',
						sortable: false
					}
			],
			rows: []
		};
	
	tbgReplacePDC = new MyTableGrid(replacePDCTable);
	tbgReplacePDC.render('replacePDCTable');
	
	function setFieldValues(rec){
		try{
			$("selPayMode").value = (rec == null ? "CA" : rec.payMode);
			$("txtCurrAmt").value = (rec == null ? "" : formatCurrency(rec.amt));
			$("txtCurrCd").value = (rec == null ? "" : unescapeHTML2(rec.currency));
			$("selCheckClass").value = (rec == null ? "" : unescapeHTML2(rec.checkClass));
			$("checkDate").value = (rec == null ? "" : rec.checkDate);
			$("txtBank").value = (rec == null ? "" : unescapeHTML2(rec.bankName));
			$("txtChkCdtCardNo").value = (rec == null ? "" : unescapeHTML2(rec.checkNo));
			$("grossAmt").value = (rec == null ? "" : formatCurrency(rec.grossAmt));
			$("commAmt").value = (rec == null ? "" : formatCurrency(rec.commAmt));
			$("vatAmt").value = (rec == null ? "" : formatCurrency(rec.vatAmt));
			$("dcbDate").value = (rec == null ? "" : rec.dueDcbDate);
			
			if(rec != null){
				disableSearch("searchCurrCd");
				disableSearch("searchBank");
				disableDate("imgDCBDate");
				disableDate("imgCheckDate");
				$("selPayMode").disabled = true;
				$("selCheckClass").disabled = true;
				$("txtCurrAmt").readOnly = true;
				$("txtCurrCd").readOnly = true;
				$("grossAmt").readOnly = true;
				$("commAmt").readOnly = true;
				$("vatAmt").readOnly = true;
				$("txtBank").readOnly = true;
				$("txtChkCdtCardNo").readOnly = true;
			} else{
				$("selPayMode").disabled = false;
				enableSearch("searchCurrCd");
				enableDate("imgDCBDate");
				$("txtCurrAmt").readOnly = false;
				$("txtCurrCd").readOnly = false;
				toggleRequiredFields("CA");
			}
			
			rec == null ? enableButton("btnAdd") : disableButton("btnAdd");
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrRepPDC = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.payMode = $F("selPayMode");
			obj.checkClass = escapeHTML2($F("selCheckClass"));
			obj.checkNo = escapeHTML2($F("txtChkCdtCardNo"));
			obj.checkDate = escapeHTML2($F("checkDate"));
			obj.amt = $F("txtCurrAmt").replace(/,/g, "");
			obj.bankName = escapeHTML2($F("txtBank"));
			obj.grossAmt = $F("grossAmt").replace(/,/g, "");
			obj.commAmt = $F("commAmt").replace(/,/g, "");
			obj.vatAmt = $F("vatAmt").replace(/,/g, "");
			obj.gaccTranId = object.gaccTranId;
			obj.itemNo = object.itemNo;
			obj.fundCd = object.fundCd;
			obj.branchCd = object.branchCd;
			obj.dcbNo = giacs032Object.dcbNo;
			obj.dueDcbDate = $F("dcbDate");
			obj.currencyRt = giacs032Object.currencyRt;
			obj.currencyCd = giacs032Object.currencyCd;
			obj.currency = $F("txtCurrCd");
			obj.bankCd = giacs032Object.bankCd;
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	$("checkDate").observe("focus", function(){
		if($F("checkDate") != "" && $F("dcbDate") == ""){
			$("checkDate").value = "";
			customShowMessageBox("Please Enter DCB Date.", imgMessage.INFO, "dcbDate");
		} else if(compareDatesIgnoreTime(Date.parse($F("checkDate"), 'mm-dd-yyyy'), Date.parse($F("dcbDate"), 'mm-dd-yyyy')) == -1){
			showWaitingMessageBox("This check is post-dated.", imgMessage.INFO, function(){
				$("checkDate").value = "";
			});
		}
	});
	
	function addRec(){
		try {
			if(checkAllRequiredFieldsInDiv("paramFormDiv")){
				changeTagFunc = saveReplacePDC;
				var pdcRec = setRec(objCurrRepPDC);
				if($F("btnAdd") == "Add"){
					tbgReplacePDC.addBottomRow(pdcRec);
				} else {
					tbgReplacePDC.updateVisibleRowOnly(pdcRec, rowIndex, false);
				}
				changeTag = 1;
				setFieldValues(null);
				tbgReplacePDC.keys.removeFocus(tbgReplacePDC.keys._nCurrentFocus, true);
				tbgReplacePDC.keys.releaseKeys();
				computeTotal();
				setOrCurrency();
			}
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}	
	
	$("btnAdd").observe("click", addRec);
	$("btnDelete").observe("click", deleteReplacePDC);
	$("btnSave").observe("click", saveReplacePDC);
	
	function deleteReplacePDC() {
		objCurrRepPDC.recordStatus = -1;
		tbgReplacePDC.deleteRow(rowIndex);
		setFieldValues(null);
		computeTotal();
		setOrCurrency();
	}
	
	function saveReplacePDC(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		if($F("amount").replace(/,/g, "") != $F("txtNetTotal").replace(/,/g, "")){
			showWaitingMessageBox("Total replacement amount should be equal to the check amount.", imgMessage.INFO, function(){
				$("txtNetTotal").focus();
			});
		} else {
			var setRows = getAddedAndModifiedJSONObjects(tbgReplacePDC.geniisysRows);
			new Ajax.Request(contextPath+"/GIACPdcChecksController", {
				method: "POST",
				parameters : {action : "saveReplacePDC",
						 	  setRows : prepareJsonAsParameter(setRows),
							  fundCd : $F("txtFundCd"),
							  branchCd : $F("txtBranchCd"),
							  oldAmt: object.amount,
							  itemId: object.itemId},
				onCreate : showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						changeTagFunc = "";
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							fireEvent($("btnReturn"), "click");
							tbgPostDatedChecks._refreshList();
						});
						changeTag = 0;
					}
				}
			});
		}
	}
	
	function computeTotal(){
		var total = 0.00;
		if(tbgReplacePDC.geniisysRows.length > 0){
			for(var i = 0; tbgReplacePDC.geniisysRows.length > i; i++){
				if(tbgReplacePDC.geniisysRows[i].recordStatus != -1){
					total = parseFloat(total) + parseFloat(tbgReplacePDC.geniisysRows[i].amt.replace(/,/g, ""));
				}
			}
			$("txtNetTotal").value = formatCurrency(total);
		} else {
			$("txtNetTotal").value = "";
		}
	}
	
	function setOrCurrency(){
		orCurrencyCd = "";
		if(tbgReplacePDC.geniisysRows.length > 0){
			for(var i = 0; tbgReplacePDC.geniisysRows.length > i; i++){
				if(tbgReplacePDC.geniisysRows[i].recordStatus != -1){
					orCurrencyCd = tbgReplacePDC.geniisysRows[i].currencyCd;
					break;
				} 
			}
		} else {
			orCurrencyCd = "";
		}
	}
</script>