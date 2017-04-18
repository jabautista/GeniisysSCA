<div id="specialCSRMainDiv" name="specialCSRMainDiv">
	<div id="scsrListingMenu" style="display: none;"> <!-- changed div id by robert 10.24.2013 -->
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="exit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<%-- <div id="tempMenu" style="display: none;"> 
		<jsp:include page="/pages/claims/claimBasicInformation/basicMenu.jsp"></jsp:include>		
	</div> --%>
	
	<div id="specialCSRListingDiv">
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label>Special Claim Settlement Request Listing</label>
<%-- 				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
			 		<input type="hidden" id="lineCd" name="lineCd" value="${lineCd}"> 
			 		<label id="reloadForm" name="reloadForm">Reload Form</label>
				</span> --%>
			</div>
		</div>
		
		<div id="specialCSRTagTableGridSectionDiv" class="sectionDiv" style="height: 406px;">
			<div id="specialCSRTableGridDiv" style="padding: 10px 10px 35px 10px;">
				<div id="specialCSRTableGrid" style="height: 320px;"></div>
			</div>
			
			<table align="center">
				<tr>
					<td><label>Particulars</label></td>
					<td>
						<div style="border: 1px solid gray; height: 20px; width: 500px; float: left;">
							<textarea id="txtParticulars" name="txtParticulars" style="width: 470px; border: none; height: 13px; margin: 0px; resize: none;" maxlength="2000" readonly="readonly"/></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="viewParticulars" />
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>
	
	<div id="specialCSRInfoDiv" style="display: none;">
		
	</div>
</div>

<script>
	setModuleId(null);
	/**
		Irwin Tabisora
		12.08.11
	**/
	
	specialCSR.isInfo = 'N'; //added by robert 10.24.2013
	
	if (nvl(objCLMGlobal.fromClaimItemInfo,"N") =="Y") {
		$("scsrListingMenu").hide(); //added by robert 10.24.2013
	/* 	$("tempMenu").show();
		initializeMenu(); */
	}else{
		$("scsrListingMenu").show(); //added by robert 10.24.2013
		//marco - 05.06.2013 - added condition
		if(nvl(objCLMGlobal.callingForm, "") == "GIACS086"){
			$("mainNav").show();
		}else{
			//$("claimListingMenu").show(); //commented out by Halley 11.19.13 - causing errors
		}
		/* if(nvl(objCLMGlobal.callingForm, "") != ""){
			if(nvl(objCLMGlobal.callingForm, "") == "GIACS086"){
				$("mainNav").show();
			}else{
				$("claimListingMenu").show();
			}
		} */
	}
	try{
		var objSCSRTG = JSON.parse('${specialCSRListingTG}'.replace(/\\/g, '\\\\'));
		objGICLBatchDv = null;
		var sCSRSelectedIndex = -1;
		var mtgId;
		var sCSRTable = {
			url: contextPath+"/GIACBatchDVController?action=getSpecialCSRListing&refresh=1&callingForm="+objCLMGlobal.callingForm+"&claimId="+nvl(objCLMGlobal.claimId,"")+"&branchCd="+"${paramBranchCd}",
			options: {
				width: '900px',
			//	height: '306px',
				onCellFocus: function(element, value, x, y, id) {
					mtgId = sCSRGrid._mtgId;
					sCSRSelectedIndex = y;
					$("txtParticulars").value = unescapeHTML2(sCSRGrid.geniisysRows[y].particulars);
					sCSRGrid.keys.removeFocus(sCSRGrid.keys._nCurrentFocus, true);
					sCSRGrid.keys.releaseKeys();
				},onRowDoubleClick: function(y){
					objGICLBatchDv = sCSRGrid.getRow(y);
					specialCSR.showSpecialCSRInfo("Y");
				},onRemoveRowFocus : function(){
					sCSRSelectedIndex = -1;
					$("txtParticulars").value = "";
					sCSRGrid.keys.removeFocus(sCSRGrid.keys._nCurrentFocus, true);
					sCSRGrid.keys.releaseKeys();
			  	}, 
			  	toolbar: {
					elements: (objCLMGlobal.fromMenu == "cancelRequest" ? [MyTableGrid.VIEW_BTN, MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN] : [MyTableGrid.ADD_BTN,MyTableGrid.EDIT_BTN ,MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]),
					onAdd: function(){ // remove the function from onAdd because when the user returns from the add page, the added row still remains
						sCSRGrid.keys.releaseKeys();
						specialCSR.showSpecialCSRInfo("N");
					},
					onEdit: function(){
						if(sCSRSelectedIndex >= 0){
							objGICLBatchDv = sCSRGrid.getRow(sCSRSelectedIndex);
							specialCSR.showSpecialCSRInfo("Y");
						}else{
							showMessageBox("Please select a record first.", "E");
						}
					} 	
				}
			}, columnModel : [ 
				{   
					id: 'recordStatus',
				    width: '0',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	
					id: 'divCtrId',
					width: '0',
					visible: false
				},{
					id: 'batchNo',
					title: 'Batch Number',
				  	width: '135',
				  	filterOption: false
			 	},{
					id: 'batchDate',
					title: 'Batch Date',
				  	width: '85',
				  	align : 'center',
				  	titleAlign : 'center',
				  	filterOption: true,
				  	filterOptionType: 'formattedDate' //marco - 05.06.2013
			 	},{
					id: 'dspPayeeClass',
					title: 'Payee Class',
				  	width: '100',
				  	filterOption: true
			 	} ,{
					id: 'dspPayee',
					title: 'Payee Name',
				  	width: '170',
				  	filterOption: true
			 	},{
					id: 'particulars',
					title: 'Particulars',
				  	width: '200',
				  	filterOption: true,
				  	renderer : function(value){
				  		return unescapeHTML2(value);
				  	}
			 	},{
					id: 'fcurrAmt',
					title: 'Paid Amount',
				  	width: '100',
				  	filterOption: true,
				  	geniisysClass: 'money',
					align: 'right',
					titleAlign: 'right',
				  	visible: true
					
				  	
			 	},{
					id: 'paidAmt',
					title: 'Local Amount',
				  	width: '100',
				  	filterOption: true,
				  	geniisysClass: 'money',
					align: 'right',
					titleAlign: 'right',
				  	visible: true
			 	},{
					id: 'dspCurrency',
					title: 'Currency',
				  	width: '100',
				  	filterOption: true,
				  	visible: true
			 	},{
					id: 'fundCd',
					title: 'Fund Code',
				  	width: '0',
				  	filterOption: true,
				  	visible: false
			 	} ,{
					id: 'branchCd',
					title: 'Branch Code',
				  	width: '0',
				  	filterOption: true,
				  	visible: false
			 	},{
					id: 'batchYear',
					title: 'Batch Year',
				  	width: '0',
				  	filterOption: true,
				  	visible: false,
				  	filterOptionType: 'integerNoNegative'
			 	},{
					id: 'branchMM',
					title: 'Branch Month',
				  	width: '0',
				  	filterOption: true,
				  	visible: false
			 	},{
					id: 'branchSeqNo',
					title: 'Branch Sequence No.',
				  	width: '0',
				  	filterOption: true,
				  	visible: false,
				  	filterOptionType: 'integerNoNegative'
			 	},{
					id: 'batchDvId',
					title: '',
				  	width: '0',
				  	visible: false
			 	},{
					id: 'batchFlag',
				  	width: '0',
				  	visible: false
			 	},{
					id: 'payeeClassCd',
				  	width: '0',
				  	visible: false
			 	},{
					id: 'payeeCd',
				  	width: '0',
				  	visible: false
			 	},{
					id: 'tranId',
				  	width: '0',
				  	visible: false
			 	},{
					id: 'currencyCd',
				  	width: '0',
				  	visible: false
			 	},{
					id: 'convertRate',
				  	width: '0',
				  	visible: false
			 	},{
					id: 'userId',
				  	width: '0',
				  	visible: false
			 	},{
					id: 'strLastUpdate',
				  	width: '0',
				  	visible: false
			 	},{
					id: 'payeeRemarks',
				  	width: '0',
				  	visible: false
			 	},{
					id: 'printDetailsSw',
				  	width: '0',
				  	visible: false
			 	}                
			],
			resetChangeTag: true,
			rows: objSCSRTG.rows
		};
		sCSRGrid = new MyTableGrid(sCSRTable);
		sCSRGrid.pager = objSCSRTG;
		sCSRGrid.render('specialCSRTableGrid');
		sCSRGrid.afterRender = function(){
			adjustTableColumns(); //marco - 09.13.2013
			sCSRGrid.onRemoveRowFocus();
		};
	}catch(e){
		showErrorMessage("special CSR listing",e );
	}
	
	function adjustTableColumns(){
		if(sCSRGrid.geniisysRows.length > 0){
			sCSRGrid._resizeColumn(sCSRGrid.getColumnIndex('dspPayee'), "170");
			sCSRGrid._resizeColumn(sCSRGrid.getColumnIndex('particulars'), "200");
		}else{
			sCSRGrid._resizeColumn(sCSRGrid.getColumnIndex('dspPayee'), "114");
			sCSRGrid._resizeColumn(sCSRGrid.getColumnIndex('particulars'), "114");
		}
	}
	
	//marco - 10.08.2013
	$("viewParticulars").observe("click", function(){
		showEditor("txtParticulars", 2000, 'true');
	});
	
	$("exit").observe("click", function (){
		if(specialCSR.isInfo=="Y"){ //added condition by robert 10.24.2013
			//showSpecialCSRListing("", "", "N");
			if($("acExit") != null){
				showSpecialCSRListing("", objACGlobal.otherBranchCd, "N");
			} else {		
				fadeElement("specialCSRInfoDiv", .2, function(){
					$("specialCSRListingDiv").show();
					sCSRGrid._refreshList();
					specialCSR.isInfo = 'N'; //added by robert 11.04.2013
				});
			}
		}else{
			if(objCLMGlobal.fromClaimMenu == 'Y'){ //added by robert 11.28.2013
				goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
			}else{
				goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
			}
		}
	});
	
/* 	//marco - 05.06.2013 - added condition if from accounting
	if(nvl(objCLMGlobal.callingForm, "") != ""){
		observeReloadForm("reloadForm",function(){
			showSpecialCSRListing();
		});
	}else{
		observeReloadForm("reloadForm", function(){
			showSpecialCSRListing("", "", "N");
			$("dynamicDiv").down("div",0).show();
			$("acExit").show();
		});
	} */
	
	//$("mtgAddBtn1").observe("click",function(){
		
	//});
	
	specialCSR = {

		showSpecialCSRInfo : function(isEdit){
			try{
				$("specialCSRListingDiv").hide();
				$("specialCSRInfoDiv").show();
				new Ajax.Updater("specialCSRInfoDiv", contextPath+"/GIACBatchDVController",{
					parameters : {
						action : "getSpecialCSRInfo",
						batchDvId: (isEdit == "Y" ?objGICLBatchDv.batchDvId : null),
						payeeClassCd: (isEdit == "Y" ?objGICLBatchDv.payeeClassCd : null),
						payeeCd: (isEdit == "Y" ? objGICLBatchDv.payeeCd : null),
						claimId : nvl(objCLMGlobal.claimId, ""),
						moduleId: "GIACS086",
						isEdit: isEdit
					},
					asynchronous: false,
					evalScripts: true,
				//	onCreate: showNotice("Loading, please wait..."),
					onComplete: function(response){
						hideNotice("");
						if(checkErrorOnResponse(response)) {
							$("isSpecial").value = "Y";
							specialCSR.populateSCSRFields((isEdit == "Y" ? objGICLBatchDv: null));
						}
					}
				});
			}catch(e){
				showErrorMessage("showSpecialCSRInfo",e);
			}
		},

		populateSCSRFields : function(obj){
			try{
				$("batchNumber").value = obj != null ? obj.batchNo : null;
				$("payeeClass").value = obj != null ? obj.dspPayeeClass : null;	
				$("particulars").value = obj != null ? unescapeHTML2(obj.particulars) : null;	
				$("payeeRemarks").value = obj != null ? unescapeHTML2(obj.payeeRemarks) : null;	
				$("payee").value = obj != null ? unescapeHTML2(obj.dspPayee) : null;//added unescape by reymon 04292013
				$("paidAmount").value = obj != null ? obj.fcurrAmt : null;
				$("currency").value = obj != null ? obj.dspCurrency : null;
				$("convertRate").value = obj != null ? formatToNineDecimal(obj.convertRate) : null;
				$("localAmount").value = obj != null ? obj.paidAmt : null;
				$("userId").value = obj != null ? obj.userId : null;
				$("lastUpdate").value = obj != null ? obj.strLastUpdate : null;
			}catch(e){
				showErrorMessage("populateSCSRFields" , e);
			}
		}
	};
	specialCSR.originalURL = "";
	specialCSR.paramBranchCd = "${paramBranchCd}";
	
	//setModuleId("GIACS086"); - andrew, this listing has no moduleId
	setDocumentTitle("Special Claim Settlement Request Listing");
	//initializeAccordion();

	if($("acExit") != null){
	 	$("acExit").stopObserving("click");
		$("acExit").observe("click", function(){
			if(objACGlobal.callingModule == "GIACS000"){
				goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);			
			} else if(objACGlobal.callingModule == "GIACS055") {
				showOtherBranchRequests("", "", "SCSR");
			}
	
			if(objCLMGlobal.fromMenu == "cancelRequest"){
				objCLMGlobal.fromMenu = "";
			}
			objACGlobal.callingModule = "";
		});
	}	
</script>