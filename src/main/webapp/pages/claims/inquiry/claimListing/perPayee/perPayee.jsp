<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="clmListingPerPayeeMainDiv" name="clmListingPerPayeeMainDiv" style="float: left; margin-bottom: 50px;">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Claim Listing per Payee</label> 
		</div>
	</div>	
	<div id = "clmListingPerPayeeHeader" class="sectionDiv">
		<input type="hidden" id="hidClaimId" name="hidClaimId">
		<div style="float: left;">
			<table style="margin: 10px 10px 5px 60px;">
				<tr>
					<td class="rightAligned">Payee Class</td>
					<td class="leftAligned">
						<span class="lovSpan required" style="width: 400px; margin-right: 30px;">
							<input type="hidden" id="hidPayeeClassCd" name="hidPayeeClassCd">
							<input type="text" id="txtPayeeClass" name="txtPayeeClass" style="width: 370px; float: left; border: none; height: 14px; margin: 0;" class="disableDelKey required" tabindex="101"/>  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchPayeeClass" name="imgSearchPayeeClass" alt="Go" style="float: right;" tabindex="102"/>
						</span>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Payee</td>
					<td class="leftAligned">
						<span class="lovSpan required" style="width: 400px; margin-right: 30px;">
							<input type="hidden" id="hidPayeeCd" name="hidPayeeCd">
							<input type="text" id="txtPayee" name="txtPayee" style="width: 370px; float: left; border: none; height: 14px; margin: 0;" class="disableDelKey required" tabindex="103"/>  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchPayee" name="imgSearchPayee" alt="Go" style="float: right;" tabindex="104"/>
						</span>
					</td>
				</tr>
			</table>
			<div style="float: left; margin-left: 134px; margin-bottom: 10px;">
				<fieldset style="width: 386px;">
					<legend>Search By</legend>
					<table>
						<tr>
							<td class="rightAligned">
								<input type="radio" name="searchBy" id="rdoNbtDateType1" style="float: left; margin: 3px 2px 3px 70px;" tabindex="105" />
								<label for="rdoNbtDateType1" style="float: left; height: 20px; padding-top: 3px;" title="Claim File Date">Claim File Date</label>
							</td>
							<td class="rightAligned">
								<input type="radio" name="searchBy" id="rdoNbtDateType2" style="float: left; margin: 3px 2px 3px 50px;" tabindex="106"/>
								<label for="rdoNbtDateType2" style="float: left; height: 20px; padding-top: 3px;" title="Loss Date">Loss Date</label>
							</td>
						</tr>
					</table>
				</fieldset>
			</div>	
		</div>
		<div class="sectionDiv" style="float: left; width: 255px; margin: 12px;">
			<table style="margin: 8px;">	
				<tr>
					<td class="rightAligned"><input type="radio" name="byDate" id="rdoAsOf" title="As of" style="float: left;" tabindex="107"/><label for="rdoAsOf" title="As of" style="float: left; height: 20px; padding-top: 3px;">As of</label></td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv">
							<input type="text" id="txtNbtAsOfDate" name="txtNbtAsOfDate" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="108"/>
							<img id="hrefNbtAsOfDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As of Date" tabindex="109"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned"><input type="radio" name="byDate" id="rdoFrom" title="From" style="float: left;" tabindex="110"/><label for="rdoFrom" style="float: left; height: 20px; padding-top: 3px;">From</label></td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv">
							<input type="text" id="txtNbtFromDate" name="txtNbtFromDate" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="111"/>
							<img id="hrefNbtFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" tabindex="112"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">To</td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv">
							<input type="text" id="txtNbtToDate" name="txtNbtToDate" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="113"/>
							<img id="hrefNbtToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" tabindex="114"/>
						</div>
					</td>
				</tr>
			</table>
		</div>	
	</div>
	<div class="sectionDiv">
		<div id="perPayeeTableDiv" style="padding: 10px 0 0 10px;">
			<div id="perPayeeTable" style="height: 340px"></div>
		</div>
		<div class="buttonDiv" id="clmPerPayeeButtonDiv" align="center" style="float: left; width: 100%; margin-top: 20px; margin-bottom: 10px;">
			<input type="button" class="button" id="btnDetailsClmPerPayee" name="btnDetailsClmPerPayee" value="Details" style="width: 90px;" tabindex="115"/>
			<input type="button" class="button" id="btnPrintClmPerPayee" name="btnPrintClmPerPayee" value="Print Report" style="width: 90px;" tabindex="116"/>
		</div>
	</div>
</div>
<script type="text/javascript">
	initializeAll();
	formatAppearance();
	toggleDateFields();
	var executeChangeTag = 0;
	var claimNo = "";
	var policyNo = "";
	var assured = "";
	var lossDate = "";
	
	//Show Table Grid
	try {
		var jsonClmListPerPayee = JSON.parse('${jsonClmListPerPayee}');
		perPayeeTableModel = {
			url : contextPath+ "/GICLClaimListingInquiryController?action=showClaimListingPerPayee&refresh=1",
			options : {
				width : '900px',
				height : '350px',
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					var obj = tbgClaimsPerPayee.geniisysRows[y];
					populatePerPayee(obj);
					tbgClaimsPerPayee.keys.removeFocus(tbgClaimsPerPayee.keys._nCurrentFocus, true);
					tbgClaimsPerPayee.keys.releaseKeys();
				},
				onRowDoubleClick: function(y){
					var obj = tbgClaimsPerPayee.geniisysRows[y];
					populatePerPayee(obj);
					perPayeeDtlOverlay(claimNo, policyNo, assured, lossDate);
					tbgClaimsPerPayee.keys.releaseKeys();
				},
				postPager : function() {
					populatePerPayee(null);
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					populatePerPayee(null);
				},
				onSort : function(){
					populatePerPayee(null);
				},
				afterRender : function() {

				},
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
					onFilter : function(){
						populatePerPayee(null);
						tbgClaimsPerPayee.keys.removeFocus(tbgClaimsPerPayee.keys._nCurrentFocus, true);
						tbgClaimsPerPayee.keys.releaseKeys();
					},
					onRefresh : function(){
						populatePerPayee(null);
					},
				}
			},
			columnModel : [ 
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
					id : "claimNumber",
					title : "Claim Number",
					width : '230px',
					filterOption : true
				}, 
				{
					id : "policyNumber",
					title : "Policy Number",
					width : '180px',
					filterOption : true
				}, 
				{
					id : "assuredName",
					title : "Assured Name",
					width : '230px',
					filterOption : true
				}, 
				{
					id : "fileDate",
					title : "File Date",
					width : '130px',
					filterOption : true,
					filterOptionType: 'formattedDate',
					align : "center",
					titleAlign : "center",
					renderer: function(value) {
						return nvl(value, "") == '' ? '' : dateFormat(value, 'mm-dd-yyyy');
					}
				}, 
				{
					id : "lossDate",
					title : "Loss Date",
					width : '130px',
					filterOption : true,
					filterOptionType: 'formattedDate',
					align : "center",
					titleAlign : "center",
					renderer: function(value) {
						return nvl(value, "") == '' ? '' : dateFormat(value, 'mm-dd-yyyy');
					}
				} 
			],
			rows : jsonClmListPerPayee.rows
		};
		tbgClaimsPerPayee = new MyTableGrid(perPayeeTableModel);
		tbgClaimsPerPayee.pager = jsonClmListPerPayee;
		tbgClaimsPerPayee.render('perPayeeTable');
	} catch (e) {
		showErrorMessage("perPayeeTableModel", e);
	}

	//Show Payee Class List
	function showGICLS259PayeeClassLOV(findText2) {
		try {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
				action : "getGIISPayeeClassLOV3",
				searchString: findText2,
				page : 1
			},
			title : "List of Payee Class",
			width : 400,
			height : 400,
			columnModel : [ {
				id : "payeeClassCd",
				title : "Payee Class",
				width : '100px',
			}, {
				id : "classDesc",
				title : "Class Description",
				width : '273px'
			} ],
			draggable : true,
			filterText: findText2,
			onSelect : function(row) {
				$("txtPayeeClass").value = row.classDesc;
				$("hidPayeeClassCd").value = row.payeeClassCd;
				$("txtPayee").clear();
				$("txtPayee").readOnly = false;
				enableSearch("imgSearchPayee");
				enableToolbarButton("btnToolbarEnterQuery");
				disableToolbarButton("btnToolbarExecuteQuery");
			}
		});
	} catch (e) {
			showErrorMessage("showGICLS259PayeeClassLOV", e);
		}
	}

	//Show Payees List
	function showGICLS259PayeeLOV(findText2) {
		try {
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
				action : "getGiisPayeeListForGICLS259",
				payeeClassCd : $F("hidPayeeClassCd"),
				searchString: findText2,
				page : 1
			},
				title : "List of Payee",
				width : 400,
				height : 400,
				columnModel : [ {
				id : "payeeNo",
				title : "Payee No",
				width : '100px',
			}, {
				id : "nbtPayeeName",
				title : "Name",
				width : '273px'
			}],
			draggable : true,
			filterText: findText2,
			onSelect : function(row) {
			$("txtPayee").value = unescapeHTML2(row.nbtPayeeName);
			$("hidPayeeCd").value = row.payeeNo;
			enableToolbarButton("btnToolbarEnterQuery");
			enableToolbarButton("btnToolbarExecuteQuery");
			}
		});

		} catch (e) {
			showErrorMessage("showGICLS259PayeeLOV", e);
		}
	}
	
	function perPayeeDtlOverlay(claimNo,policyNo,assured,lossDate) {
		try{
			overlayPerPayeeDtl = Overlay.show(contextPath+"/GICLClaimListingInquiryController?action=showPerPayeeDtl&payeeClassCd=" + $F("hidPayeeClassCd") + "&payeeCd=" + $F("hidPayeeCd") + "&claimId=" + $F("hidClaimId")
																							  +"&claimNo="+claimNo+"&policyNo="+policyNo+"&assured="+encodeURIComponent(assured)+"&lossDate="+encodeURIComponent(lossDate), 
					{urlContent: true,
					 title: "Claim Details",
					 height: 440,
					 width: 835,
					 draggable: false
					});
		}catch (e) {
			showErrorMessage("perPayeeDtlOverlay",e);
		}
	}
	
	function populatePerPayee(obj) {
		try{
			$("hidClaimId").value = (obj) == null ? "" : nvl(obj.claimId,"");
			 claimNo = (obj) == null ? "" : nvl(obj.claimNumber,"");
			 policyNo = (obj) == null ? "" : nvl(obj.policyNumber,"");
			 assured = (obj) == null ? "" : nvl(obj.assuredName,"");
			 lossDate = (obj) == null ? "" : nvl(obj.lossDate,"");
			if (obj==null) {
				disableButton("btnDetailsClmPerPayee");
// 				disableButton("btnPrintClmPerPayee");
// 				disableToolbarButton("btnToolbarPrint");
				
			}else{
				enableButton("btnDetailsClmPerPayee");
// 				enableButton("btnPrintClmPerPayee");
// 				enableToolbarButton("btnToolbarPrint");
			}
		}catch (e) {
			showErrorMessage("populatePerPayee",e);
		}
	}
	
	function disableAllFields() {
		$("txtPayeeClass").readOnly = true;
		$("txtPayee").readOnly = true;
		$("txtNbtAsOfDate").disable();
		$("txtNbtFromDate").disable();
		$("txtNbtToDate").disable();
		$("rdoAsOf").disable();
		$("rdoFrom").disable();
		disableSearch("imgSearchPayeeClass");
		disableSearch("imgSearchPayee");
		disableDate("hrefNbtAsOfDate");
		disableDate("hrefNbtFromDate");
		disableDate("hrefNbtToDate");
		enableToolbarButton("btnToolbarEnterQuery");
	}
	
	function toggleDateFields() {
		if ($("rdoAsOf").checked == true) {
			enableDate("hrefNbtAsOfDate");
			disableDate("hrefNbtFromDate");
			disableDate("hrefNbtToDate");
			$("txtNbtFromDate").disabled = true;
			$("txtNbtToDate").disabled 	 = true;
			$("txtNbtAsOfDate").disabled 	 = false;
			$("txtNbtFromDate").clear();
			$("txtNbtToDate").clear();
			$("txtNbtAsOfDate").value = getCurrentDate();
		} else if ($("rdoFrom").checked == true) {
			disableDate("hrefNbtAsOfDate");
			enableDate("hrefNbtFromDate");
			enableDate("hrefNbtToDate");
			$("txtNbtFromDate").disabled = false;
			$("txtNbtToDate").disabled 	 = false;
			$("txtNbtAsOfDate").disabled 	 = true;
			$("txtNbtAsOfDate").clear();
		}
	}
	
	function formatAppearance() {
		try{
			setModuleId("GICLS259");
			setDocumentTitle("Claim Listing Per Payee");
			$("txtPayeeClass").focus();
			$("rdoAsOf").checked = true;
			$("rdoNbtDateType1").checked = true;
			$("txtPayee").readOnly = true;
			$("txtPayeeClass").readOnly = false;
			disableButton("btnDetailsClmPerPayee");
			disableSearch("imgSearchPayee");
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
			disableToolbarButton("btnToolbarPrint");
			disableButton("btnPrintClmPerPayee");
			
			$("txtPayeeClass").clear();
			$("txtPayee").clear();
			
			$("txtNbtAsOfDate").enable();
			$("txtNbtFromDate").disable();
			$("txtNbtToDate").disable();
			$("rdoAsOf").enable();
			$("rdoFrom").enable();
			enableSearch("imgSearchPayeeClass");
			enableDate("hrefNbtAsOfDate");
			disableDate("hrefNbtFromDate");
			disableDate("hrefNbtToDate");
		}catch (e) {
			showErrorMessage("formatAppearance",e);
		}
	}
	
	function notAllowedKey(keyCode) {
		if(keyCode==32 || keyCode==8 || keyCode==46 || (keyCode>=48 && keyCode<=90) || (keyCode>=96 && keyCode<=111) || (keyCode>=186 && keyCode<=222)){
			return true;
		}
		return false;
	}
	
	function executeQuery(showMsg) {
		try {
			var fileDate = $("rdoNbtDateType1").checked == true ? "fileDate" : "";
			var lossDate = $("rdoNbtDateType2").checked == true ? "lossDate" : "";
			var fromDate = $F("txtNbtFromDate") != "" ? new Date($F("txtNbtFromDate").replace(/-/g,"/")) :null;
			var toDate = $F("txtNbtToDate") != "" ? new Date($F("txtNbtToDate").replace(/-/g,"/")) :null;
			if($F("hidPayeeClassCd") != "" && $F("hidPayeeCd") != "") {
				if ($("rdoAsOf").checked == false) {
					if (fromDate == "" || fromDate == null) {
						if (showMsg) {
							customShowMessageBox("Please enter FROM date.", "I", "txtNbtFromDate");
						}
						return;
					}else if (toDate == "" || toDate == null) {
						if (showMsg) {
							customShowMessageBox("Please enter TO date.", "I", "txtNbtToDate");
						}
						return;
					}
				}
				tbgClaimsPerPayee.url = contextPath+ "/GICLClaimListingInquiryController?action=showClaimListingPerPayee&refresh=1&payeeClassCd="+$F("hidPayeeClassCd")+"&payeeCd="+$F("hidPayeeCd")+"&fileDate2="+fileDate+"&lossDate2="+lossDate+"&asOfDate="+$F("txtNbtAsOfDate")+"&fromDate="+$F("txtNbtFromDate")+"&toDate="+$F("txtNbtToDate");
				tbgClaimsPerPayee._refreshList();
				disableAllFields();
				disableToolbarButton("btnToolbarExecuteQuery");
				enableButton("btnPrintClmPerPayee");
				enableToolbarButton("btnToolbarPrint");
				if (tbgClaimsPerPayee.geniisysRows.length == 0) {
					customShowMessageBox("Query caused no records to be retrieved. Re-enter.", imgMessage.INFO, "txtPayeeClass");
					disableButton("btnPrintClmPerPayee");
					disableButton("btnDetailsClmPerPayee");
					disableToolbarButton("btnToolbarPrint");
				} 
			}
		}catch (e) {
			showErrorMessage("executeQuery",e);
		}
	}
	
	function printGICLR259() {
		try {
			var withCSV=null; //CarloR SR-5369 06.23.2016 -start
			if($("rdoCsv").checked){
				withCSV="CSV";
			}else if($("rdoPdf").checked){
				withCSV=null;
			}//SR-5369 end
			var dateType = $("rdoNbtDateType1").checked == true ? "fileDate" : "lossDate";
			var fileType = $("rdoPdf").checked ? "PDF" : "CSV"; //Changed from xls to csv by CarloR SR 5369 06.23.2016
			var content = contextPath+"/PrintClaimListingInquiryController?action=printReport"
			+"&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination")
			+"&payeeClassCd="+$F("hidPayeeClassCd")
			+"&payeeCd="+$F("hidPayeeCd")
			+"&reportId=GICLR259"	
			+"&fromDate="+$F("txtNbtFromDate")
			+"&toDate="+$F("txtNbtToDate")
			+"&asOfDate="+$F("txtNbtAsOfDate")
			+"&dateType="+dateType
			+"&fileType="+fileType;	
			printGenericReport(content, "CLAIMS LISTING PER PAYEE", null, withCSV); //Changed by CarloR SR-5369 06.23.2016
		} catch (e) {
			showErrorMessage("printGICLR259",e);
		}
	}
	function resetFields() {
		try {
			formatAppearance();
			toggleDateFields();
			executeChangeTag = 0;
			claimNo = "";
			policyNo = "";
			assured = "";
			lossDate = "";
			$("txtNbtAsOfDate").value = dateFormat(new Date(), "mm-dd-yyyy");
			tbgClaimsPerPayee.url = contextPath+ "/GICLClaimListingInquiryController?action=showClaimListingPerPayee&refresh=1";
			tbgClaimsPerPayee._refreshList();
		} catch (e) {
			showErrorMessage("resetFields",e);
		}
	}
	try {
		$$("div#clmListingPerPayeeHeader input[type='text'].disableDelKey").each(function (a) {
			$(a).observe("keydown",function(e){
				if($(a).readOnly && e.keyCode === 46){
					$(a).blur();
				}
			});
		});
		$("imgSearchPayeeClass").observe("click", function() {
			var txtpayeeClass = $F("txtPayeeClass").trim() == "" ? "%" : $F("txtPayeeClass");
			showGICLS259PayeeClassLOV(txtpayeeClass);
		});
		$("imgSearchPayee").observe("click", function() {
			var txtpayee = $F("txtPayee").trim() == "" ? "%" : $F("txtPayee");
			showGICLS259PayeeLOV(txtpayee);
		});

		$("btnToolbarExit").observe("click", function(){
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
		});
		$("btnToolbarEnterQuery").observe("click", function(){
			resetFields();
		});
		$("btnToolbarExecuteQuery").observe("click", function(){
			executeChangeTag = 1;
			executeQuery(true);
		});
		$("btnToolbarPrint").observe("click", function(){
			showGenericPrintDialog("Print Claim Listing Per Payee",printGICLR259,function(){$("csvOptionDiv").show();},true);
		});
		$("btnPrintClmPerPayee").observe("click", function(){
			showGenericPrintDialog("Print Claim Listing Per Payee",printGICLR259,function(){$("csvOptionDiv").show();},true);
		});
		$("rdoNbtDateType1").observe("click", function(){
			if (executeChangeTag == 1) {
				executeQuery(false);
			}
		});
		$("rdoNbtDateType2").observe("click", function(){
			if (executeChangeTag == 1) {
				executeQuery(false);
			}
		});
		$("rdoAsOf").observe("click", function(){
			toggleDateFields();
		});
		$("rdoFrom").observe("click", function(){
			toggleDateFields();
		});
		$("btnDetailsClmPerPayee").observe("click", function() {
			perPayeeDtlOverlay(claimNo, policyNo, assured, lossDate);
		});
		$("txtPayeeClass").observe("change", function(e) {
				var txtpayeeClass2 = $F("txtPayeeClass").trim() == "" ? "%" : $F("txtPayeeClass");
				var cond = validateTextFieldLOV("/ClaimsLOVController?action=getGIISPayeeClassLOV3",txtpayeeClass2,"Searching Payee Class, please wait...");
				if (cond == 2) {
					showGICLS259PayeeClassLOV(txtpayeeClass2);
				} else if(cond == 0) {
					$("txtPayeeClass").clear();
					showMessageBox("There is no record of this class_desc or payee_class_cd in GIIS_PAYEE_CLASS.", imgMessage.INFO);
				}else{
					$("txtPayeeClass").value = unescapeHTML2(cond.rows[0].classDesc);
					$("hidPayeeClassCd").value = cond.rows[0].payeeClassCd;
					$("txtPayee").clear();
					$("txtPayee").focus();
					$("txtPayee").readOnly = false;
					enableSearch("imgSearchPayee");
					enableToolbarButton("btnToolbarEnterQuery");
					disableToolbarButton("btnToolbarExecuteQuery");
				}
		});
		$("txtPayee").observe("change", function(e) {
					var txtpayee2 = $F("txtPayee").trim() == "" ? "%" : $F("txtPayee");
					var cond = validateTextFieldLOV("/ClaimsLOVController?action=getGiisPayeeListForGICLS259&payeeClassCd="+$F("hidPayeeClassCd"),txtpayee2,"Searching Payee, please wait...");
					if (cond == 2) {
						showGICLS259PayeeLOV(txtpayee2);
					} else if(cond == 0) {
						$("txtPayee").clear();
						showMessageBox("There is no record of this nbt_payee_name or payee_no in GIIS_PAYEE_CLASS.", imgMessage.INFO);
					}else{
						$("txtPayee").value = unescapeHTML2(cond.rows[0].nbtPayeeName);
						$("hidPayeeCd").value = cond.rows[0].payeeNo;
						enableToolbarButton("btnToolbarEnterQuery");
						enableToolbarButton("btnToolbarExecuteQuery");
					}
		});
		$("txtPayeeClass").observe("keyup", function(e) {
			if($("txtPayeeClass").readOnly)return;
			if (notAllowedKey(e.keyCode)) {
				$("hidPayeeClassCd").clear();
				$("txtPayee").clear();
				$("txtPayee").readOnly = true;
				disableSearch("imgSearchPayee");
				disableToolbarButton("btnToolbarExecuteQuery");
			}
		});
		$("txtPayee").observe("keyup", function(e) {
			if($F("hidPayeeClassCd")!=""){
				if (notAllowedKey(e.keyCode)) {
					if($("txtPayee").readOnly)return;
					$("hidPayeeCd").clear();
					disableToolbarButton("btnToolbarExecuteQuery");
				}
			}
		});
	} catch (e) {
		showErrorMessage("perPayee.jsp observe", e);
	}
	
	
	//Observe delete on DATE field
	observeBackSpaceOnDate("txtNbtAsOfDate");
	observeBackSpaceOnDate("txtNbtFromDate");
	observeBackSpaceOnDate("txtNbtToDate");
	
	
	//As of Date ICON CLICK event
	$("hrefNbtAsOfDate").observe("click", function(){
		if ($("hrefNbtAsOfDate").disabled == true) return;
		scwShow($('txtNbtAsOfDate'),this, null);
	});
	
	//As of Date validate event
	$("txtNbtAsOfDate").observe("focus", function(){
		if ($("hrefNbtAsOfDate").disabled == true) return;
		var asOfDate = $F("txtNbtAsOfDate") != "" ? new Date($F("txtNbtAsOfDate").replace(/-/g,"/")) :"";
		var sysdate = new Date();
		if (asOfDate > sysdate && asOfDate != ""){
			customShowMessageBox("Date should not be greater than the current date.", "I", "txtNbtAsOfDate");
			$("txtNbtAsOfDate").clear();
			return false;
		}
	});
	
	//From Date ICON CLICK event
	$("hrefNbtFromDate").observe("click", function(){
		if ($("hrefNbtFromDate").disabled == true) return;
		scwShow($('txtNbtFromDate'),this, null);
	});
	
	//From Date validate event
	$("txtNbtFromDate").observe("focus", function(){
		if ($("hrefNbtFromDate").disabled == true) return;
		var fromDate = $F("txtNbtFromDate") != "" ? new Date($F("txtNbtFromDate").replace(/-/g,"/")) :"";
		var toDate = $F("txtNbtToDate") != "" ? new Date($F("txtNbtToDate").replace(/-/g,"/")) :"";
		var sysdate = new Date();
		if (fromDate > sysdate && fromDate != ""){
			customShowMessageBox("Date should not be greater than the current date.", "I", "txtNbtFromDate");
			$("txtNbtFromDate").clear();
			return false;
		}
		if (fromDate > toDate && toDate != ""){
			customShowMessageBox("FROM Date should not be greater than the TO date.", "I", "txtNbtFromDate");
			$("txtNbtFromDate").clear();
			return false;
		}
	});
	
	//To Date ICON CLICK event
	$("hrefNbtToDate").observe("click", function(){
		if ($("hrefNbtToDate").disabled == true) return;
		scwShow($('txtNbtToDate'),this, null);
	});
	
	//To Date validate event
	$("txtNbtToDate").observe("focus", function(){
		if ($("hrefNbtToDate").disabled == true) return;
		var toDate = $F("txtNbtToDate") != "" ? new Date($F("txtNbtToDate").replace(/-/g,"/")) :"";
		var fromDate = $F("txtNbtFromDate") != "" ? new Date($F("txtNbtFromDate").replace(/-/g,"/")) :"";
		var sysdate = new Date();
		if (toDate > sysdate && toDate != ""){
			customShowMessageBox("Date should not be greater than the current date.", "I", "txtNbtToDate");
			$("txtNbtToDate").clear();
			return false;
		}
		if (toDate < fromDate && toDate != ""){
			customShowMessageBox("TO Date should not be less than the FROM date.", "I", "txtNbtToDate");
			$("txtNbtToDate").clear();
			return false;
		}
	});
	
// 	observeReloadForm("reloadclmListingPerPayee", function(){
// 		showClaimListingPerPayee(null,null,"Loading, please wait...");
// 	});
</script>