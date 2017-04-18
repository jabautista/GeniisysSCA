<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="perCedingMainDiv" >
	<!-- <div id="perCedingSubMenu">
	 	<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="btnExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div> -->
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Claim Listing per Ceding Company</label>
	   	</div>
	</div>	
	<div class="sectionDiv" style="padding: 0 0 10px 0;">
		<div style="float: left;">
			<table style="margin: 10px 10px 5px 65px;">
				<tr>
					<td class="rightAligned">Cedant</td>
					<td class="leftAligned">
						<span class="lovSpan" style="width: 400px; margin-right: 30px;">
							<input type="text" id="txtCedant" style="width: 370px; float: left; border: none; height: 14px; margin: 0;" class="" tabindex="101"/>  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchCedant" alt="Go" style="float: right;" tabindex="102"/>
						</span>
					</td>
				</tr>
			</table>
			<div style="float: left; margin-left: 115px; margin-bottom: 10px;">
				<fieldset style="width: 385px;">
					<legend>Search By</legend>
					<table>
						<tr>
							<td class="rightAligned">
								<input type="radio" name="searchBy" id="rdoClaimFileDate" style="float: left; margin: 3px 2px 3px 70px;" tabindex="103" />
								<label for="rdoClaimFileDate" style="float: left; height: 20px; padding-top: 3px;" title="Claim File Date">Claim File Date</label>
							</td>
							<td class="rightAligned">
								<input type="radio" name="searchBy" id="rdoLossDate" style="float: left; margin: 3px 2px 3px 50px;" tabindex="104" />
								<label for="rdoLossDate" style="float: left; height: 20px; padding-top: 3px;" title="Loss Date">Loss Date</label>
							</td>
						</tr>
					</table>
				</fieldset>
			</div>
		</div>
		<div class="sectionDiv" style="float: right; width: 255px; margin: 12px 60px 0 0;">
			<table style="margin: 8px;">	
				<tr>
					<td class="rightAligned"><input type="radio" name="byDate" id="rdoAsOf" title="As of" style="float: left;" tabindex="105"/><label for="rdoAsOf" title="As of" style="float: left; height: 20px; padding-top: 3px;">As of</label></td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv" id="divAsOf">
							<input type="text" removeStyle="true" id="txtAsOf" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="106"/>
							<img id="imgAsOf" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As of Date" tabindex="107"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned"><input type="radio" name="byDate" id="rdoFrom" title="From" style="float: left;" tabindex="108"/><label for="rdoFrom" style="float: left; height: 20px; padding-top: 3px;">From</label></td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv" id="divFrom">
							<input type="text" removeStyle="true" id="txtFrom" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="109"/>
							<img id="imgFrom" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" tabindex="110"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">To</td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv" id="divTo">
							<input type="text" removeStyle="true" id="txtTo" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="111"/>
							<img id="imgTo" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" tabindex="112"/>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>	
	<div class="sectionDiv" style="margin-bottom: 50px;">
		<div id="perCedingTableDiv" style="padding: 10px 0 0 10px;">
			<div id="perCedingTable" style="height: 300px; margin-left: auto;"></div>
		</div>
		<div style="margin: 5px; float: right; margin-right: 20px;">
			<table>
				<tr>
					<td class="rightAligned">Totals</td>
					<td class=""><input type="text" id="txtTotLossReserve" style="width: 120px; text-align: right;" readonly="readonly" tabindex="202"/></td>
					<td class=""><input type="text" id="txtTotExpenseReserve" style="width: 120px; text-align: right;" readonly="readonly" tabindex="203"/></td>
					<td class=""><input type="text" id="txtTotLossesPaid" style="width: 120px; text-align: right;" readonly="readonly" tabindex="204"/></td>
					<td class=""><input type="text" id="txtTotExpensesPaid" style="width: 120px; text-align: right;" readonly="readonly" tabindex="205"/></td>
				</tr>
			</table>
		</div>
		<div class="sectionDiv" style="margin: 10px; float: left; width: 97.5%;">
			<table style="margin: 5px; float: left;">
				<tr>
					<td class="rightAligned">Policy Number</td>
					<td class="leftAligned"><input type="text" id="txtPolicyNo" style="width: 370px;" readonly="readonly" tabindex="301"/></td>
					<td width="50px"></td>
					<td class="rightAligned">Loss Date</td>
					<td class="leftAligned"><input type="text" id="txtLossDate" style="width: 230px;" readonly="readonly" tabindex="303"/></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 110px;">Assured</td>
					<td class="leftAligned"><input type="text" id="txtAssured" style="width: 370px;" readonly="readonly" tabindex="302"/></td>
					<td></td>
					<td class="rightAligned">File Date</td>
					<td class="leftAligned"><input type="text" id="txtFileDate" style="width: 230px;" readonly="readonly" tabindex="304"/></td>
				</tr>			
			</table>
		</div>
		<div style="float: left; width: 100%; margin-bottom: 10px;" align="center">
			<input type="button" class="disabledButton" id="btnPrintReport" value="Print Report" tabindex="401"/>
		</div>		
	</div>
</div>
<script type="text/javascript">
	try {
		var onLOV = false;
		var riCd = "";
		setModuleId("GICLS267");
		setDocumentTitle("Claim Listing Per Ceding Company");
		
		function initGICLS267(){
			$("txtCedant").focus();
			$("rdoAsOf").checked = true;
			$("rdoClaimFileDate").checked = true;
			$("txtAsOf").value = getCurrentDate();
			disableFromToFields();
			disableToolbarButton("btnToolbarExecuteQuery");
			disableToolbarButton("btnToolbarEnterQuery");
			setPrintButtons(false);
			riCd = "";
			onLOV = false;
		}
		
		function setPrintButtons(x){
			if(x){
				enableButton("btnPrintReport");
				enableToolbarButton("btnToolbarPrint");
			} else {
				disableButton("btnPrintReport");
				disableToolbarButton("btnToolbarPrint");
			}
		}
		
		function disableFromToFields() {
			$("txtAsOf").disabled = false;
			$("imgAsOf").disabled = false;
			$("txtFrom").disabled = true;
			$("txtTo").disabled = true;
			$("imgFrom").disabled = true;
			$("imgTo").disabled = true;
			$("txtFrom").value = "";
			$("txtTo").value = "";
			$("rdoAsOf").checked = true;
			$("txtAsOf").value = getCurrentDate();
			disableDate("imgFrom");
			disableDate("imgTo");
			enableDate("imgAsOf");
			$("txtFrom").setStyle({backgroundColor: '#F0F0F0'});
			$("divFrom").setStyle({backgroundColor: '#F0F0F0'});
			$("txtTo").setStyle({backgroundColor: '#F0F0F0'});
			$("divTo").setStyle({backgroundColor: '#F0F0F0'});
			$("txtAsOf").setStyle({backgroundColor: 'white'});
			$("divAsOf").setStyle({backgroundColor: 'white'});
		}
		
		function disableAsOfFields() {
			$("txtFrom").disabled = false;
			$("imgFrom").disabled = false;
			$("imgTo").disabled = false;
			$("txtTo").disabled = false;
			$("txtAsOf").disabled = true;
			$("imgAsOf").disabled = true;
			$("txtAsOf").value = "";
			$("rdoFrom").checked = true;
			disableDate("imgAsOf");
			enableDate("imgFrom");
			enableDate("imgTo");
			$("txtFrom").setStyle({backgroundColor: '#FFFACD'});
			$("divFrom").setStyle({backgroundColor: '#FFFACD'});
			$("txtTo").setStyle({backgroundColor: '#FFFACD'});
			$("divTo").setStyle({backgroundColor: '#FFFACD'});
			$("txtAsOf").setStyle({backgroundColor: '#F0F0F0'});
			$("divAsOf").setStyle({backgroundColor: '#F0F0F0'});
		}
		
		function disableFields() {
			$("rdoAsOf").disable();
			$("txtAsOf").disable();
			$("rdoFrom").disable();
			$("txtFrom").disable();
			$("txtTo").disable();
			$("imgAsOf").disabled = true;
			$("imgFrom").disabled = true;
			$("imgTo").disabled = true;
			disableSearch("imgSearchCedant");
			disableDate("imgAsOf");
			disableDate("imgFrom");
			disableDate("imgTo");
			$("txtCedant").readOnly = true;
			$("txtFrom").setStyle({backgroundColor: '#F0F0F0'});
			$("divFrom").setStyle({backgroundColor: '#F0F0F0'});
			$("txtTo").setStyle({backgroundColor: '#F0F0F0'});
			$("divTo").setStyle({backgroundColor: '#F0F0F0'});
			$("txtAsOf").setStyle({backgroundColor: '#F0F0F0'});
			$("divAsOf").setStyle({backgroundColor: '#F0F0F0'});
			disableToolbarButton("btnToolbarExecuteQuery");	
		}
		
		function resetForm(){
			$("txtCedant").clear();
			$("txtCedant").readOnly = false;
			enableSearch("imgSearchCedant");
			$("rdoAsOf").enable();
			$("rdoClaimFileDate").checked = true;
			$("rdoLossDate").checked = false;
			$("rdoFrom").disabled = false;
			setDetails(null);
			$("txtTotLossReserve").clear();
			$("txtTotExpenseReserve").clear();
			$("txtTotLossesPaid").clear();
			$("txtTotExpensesPaid").clear();
			tbgClaimsPerCeding.url = contextPath + "/GICLClaimListingInquiryController?action=showClaimListingPerCedingCompany&refresh=1";
			tbgClaimsPerCeding._refreshList();
			initGICLS267();
		}
		
		function validateRequiredDates(){
			if($("rdoFrom").checked){
				if($("txtFrom").value == ""){
					customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.INFO, "txtFrom");
					return false;	
				}
				else if($("txtTo").value == ""){
					customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.INFO, "txtTo");
					return false;
				}
			}
			return true;
		}
		
		function getParams() {
			var params = "";
			if($("rdoClaimFileDate").checked)
				params = "&searchByOpt=fileDate";
			else
				params = "&searchByOpt=lossDate";
			params = params + "&dateAsOf=" + $("txtAsOf").value + "&dateFrom=" + $("txtFrom").value + "&dateTo=" + $("txtTo").value;
			return params;
		}
		
		function setDetails(rec) {
			try {
				$("txtPolicyNo").value = rec == null ? "" : rec.policyNumber;
				$("txtAssured").value = rec == null ? "" : unescapeHTML2(rec.assuredName);
				$("txtLossDate").value = rec == null ? "" : dateFormat(rec.lossDate, "mm-dd-yyyy");
				$("txtFileDate").value = rec == null ? "" : dateFormat(rec.clmFileDate, "mm-dd-yyyy");
			} catch (e) {
				showErrorMessage("setDetails", e);
			}
		}
		
		
		function showGICLS267CedingLOV() {
			onLOV = true;
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getClaimCedantLOV",
					searchString : $("txtCedant").value,
					page : 1
				},
				title : "Ceding Company",
				width : 455,
				height : 400,
				columnModel : [ {
					id : "riCd",
					title : "Ri Code",
					width : "120px",
				}, {
					id : "riName",
					title : "Ri Name",
					width : "320px",
					renderer : function(val){
						return escapeHTML2(val);
					}
				} ],
				draggable : true,
				filterText : $("txtCedant").value,
				autoSelectOneRecord : true,
				onSelect : function(row) {
					onLOV = false;
					$("txtCedant").value = unescapeHTML2(row.riName);
					riCd = row.riCd;
					enableToolbarButton("btnToolbarExecuteQuery");
					enableToolbarButton("btnToolbarEnterQuery");
			   },
			   onCancel : function(){
				   onLOV = false;
				   $("txtCedant").focus();
			   },
			   onUndefinedRow : function(){
				   onLOV = false;
				   customShowMessageBox("No record selected.", imgMessage.INFO, "txtCedant");
			   }
			});
		}
		
		function executeQuery(){
			tbgClaimsPerCeding.url = contextPath + "/GICLClaimListingInquiryController?action=showClaimListingPerCedingCompany&refresh=1&riCd=" + riCd + getParams();
			tbgClaimsPerCeding._refreshList();
			if(tbgClaimsPerCeding.geniisysRows.length == 0){
				customShowMessageBox("Query caused no records to be retrieved. Re-enter.", imgMessage.INFO, "txtCedant");
				setPrintButtons(false);
			} else
				setPrintButtons(true);
			disableFields();
		}
		
		function changeSearchByOpt() {
			if($("txtCedant").readOnly){
				tbgClaimsPerCeding.url = contextPath + "/GICLClaimListingInquiryController?action=showClaimListingPerCedingCompany&refresh=1&riCd=" + riCd + getParams();
				tbgClaimsPerCeding._refreshList();
				if(tbgClaimsPerCeding.geniisysRows.length == 0){
					setPrintButtons(false);
				} else
					setPrintButtons(true);
			}
		}
		
		var jsonClmListPerCeding = JSON.parse('${jsonClmListPerCeding}');
		perCedingTableModel = {
			options : {
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN,MyTableGrid.REFRESH_BTN ]
				},
				width : '900px',
				height : '275px',
				onCellFocus : function(element, value, x, y, id) {
					setDetails(tbgClaimsPerCeding.geniisysRows[y]);
					tbgClaimsPerCeding.keys.removeFocus(tbgClaimsPerCeding.keys._nCurrentFocus, true);
					tbgClaimsPerCeding.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					setDetails(null);
					tbgClaimsPerCeding.keys.removeFocus(tbgClaimsPerCeding.keys._nCurrentFocus, true);
					tbgClaimsPerCeding.keys.releaseKeys();
				}
			},
			columnModel : [ {
				id : "recordStatus",
				title : "",
				width : "0",
				visible : false
			}, {
				id : "divCtrId",
				width : "0",
				visible : false
			}, {
				id : "claimNo",
				title : "Claim Number",
				width : "199px",
				filterOption : true,
				align : "left",
				titleAlign : "left"
			}, {
				id : "clmStatDesc",
				title : "Claim Status",
				width : "186px",
				filterOption : true
			}, {
				id : "lossResAmt",
				title : "Loss Reserve",
				width : "120px",
				filterOption : true,
				filterOptionType : 'number',
				align : "right",
				titleAlign : "right",
				renderer : function(value){
					return formatCurrency(value);
				}
			}, {
				id : "expResAmt",
				title : "Expense Reserve",
				width : "120px",
				filterOption : true,
				filterOptionType : 'number',
				align : "right",
				titleAlign : "right",
				renderer : function(value){
					return formatCurrency(value);
				}
			}, {
				id : "lossPdAmt",
				title : "Losses Paid",
				width : "120px",
				filterOption : true,
				filterOptionType : 'number',
				align : "right",
				titleAlign : "right",
				renderer : function(value){
					return formatCurrency(value);
				}
			}, {
				id : "expPdAmt",
				title : "Expenses Paid",
				width : "120px",
				filterOption : true,
				filterOptionType : 'number',
				align : "right",
				titleAlign : "right",
				renderer : function(value){
					return formatCurrency(value);
				}
			}, ],
			rows : jsonClmListPerCeding.rows
		};

		tbgClaimsPerCeding = new MyTableGrid(perCedingTableModel);
		tbgClaimsPerCeding.pager = jsonClmListPerCeding;
		tbgClaimsPerCeding.render("perCedingTable");
		tbgClaimsPerCeding.afterRender = function() {
			setDetails(null);
			if (tbgClaimsPerCeding.geniisysRows.length > 0) {
				var rec = tbgClaimsPerCeding.geniisysRows[0];
				$("txtTotLossReserve").value = formatCurrency(rec.totLossResAmt);
				$("txtTotLossesPaid").value = formatCurrency(rec.totLossPdAmt);
				$("txtTotExpenseReserve").value = formatCurrency(rec.totExpResAmt);
				$("txtTotExpensesPaid").value = formatCurrency(rec.totExpPdAmt);
			} else {
				$("txtTotLossReserve").clear();
				$("txtTotLossesPaid").clear();
				$("txtTotExpenseReserve").clear();
				$("txtTotExpensesPaid").clear();
			}
		};
		
		$("rdoAsOf").observe("click", disableFromToFields);
		$("rdoFrom").observe("click", disableAsOfFields);
		$("rdoClaimFileDate").observe("click", changeSearchByOpt);
		$("rdoLossDate").observe("click", changeSearchByOpt);
	
		$("btnToolbarExecuteQuery").observe("click", function(){
			if(validateRequiredDates())
				executeQuery();
		});
		
		$("imgSearchCedant").observe("click", function(){
			if(onLOV)
				return;
			showGICLS267CedingLOV();
		});

		$("txtCedant").observe("keypress", function(event){
			if(event.keyCode == Event.KEY_RETURN) {
		    	if(onLOV)
		    		return;
		    	showGICLS267CedingLOV();
		    } else
		    	disableToolbarButton("btnToolbarExecuteQuery");
		});	
		
		/* 
		removed by robert 01.06.2014
		$("btnExit").observe("click", function(){
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
		}); 
		*/
		
		$("btnToolbarExit").observe("click", function(){
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
		});
		$("btnToolbarEnterQuery").observe("click", resetForm);
		
		$("btnPrintReport").observe("click", function(){
			showGenericPrintDialog("Print Claim Listing per Ceding Company", doPrint, "", true);
			$("csvOptionDiv").show(); //Bernadeth Quitain 03.31.2016 SR-5405
		});
		
		$("btnToolbarPrint").observe("click", function(){
			showGenericPrintDialog("Print Claim Listing per Ceding Company", doPrint, "", true);
		});
		
		var reports = [];
		function doPrint(){
			var content;
			var searchBy;
			if($("rdoClaimFileDate").checked){
				searchBy = "claimFileDate";
			}else{
				searchBy = "lossDate";
			}
			content = contextPath+"/PrintClaimListingInquiryController?action=printReport&reportId=GICLR267"					
					+"&riCd="+riCd+"&searchBy="+searchBy+"&fromDate="+$F("txtFrom")+"&toDate="+$F("txtTo")+"&asOfDate="+$F("txtAsOf")
					+ "&noOfCopies=" + $F("txtNoOfCopies")
                    + "&printerName=" + $F("selPrinter")
                    + "&destination=" + $F("selDestination");
			
			
			if($F("selDestination") == "screen"){
				reports.push({reportUrl : content, reportTitle : "Claim Listing Per Ceding Company"});		
				showMultiPdfReport(reports);
				reports = [];
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					method: "GET",
					parameters : {noOfCopies : $F("txtNoOfCopies"),
							 	 printerName : $F("selPrinter")
							 	 },
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						if (checkErrorOnResponse(response)){
						
						}
					}
				});
			}else if($F("selDestination") == "file"){
				new Ajax.Request(content, {
					method: "POST",
					parameters : {destination : "file",
								  fileType    : $("rdoPdf").checked ? "PDF" : "CSV"}, //changed from XLS to CSV by carlo rubenecia SR5405 04.27.2016 SR 5405
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							if ($("rdoCsv").checked){ //added by carlo rubecia 04.27.2016 SR 5405 --START
								copyFileToLocal(response, "csv");
								deleteCSVFileFromServer(response.responseText);
							}else						//added by carlo rubecia 04.27.2016 SR 5405 --END
								copyFileToLocal(response);
						}
					}
				});
			}else if("local" == $F("selDestination")){
				new Ajax.Request(content, {
					method: "POST",
					parameters : {destination : "local"},
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							var message = printToLocalPrinter(response.responseText);
							if(message != "SUCCESS"){
								showMessageBox(message, imgMessage.ERROR);
							}
						}
					}
				});
			}
		}
		
		$("imgAsOf").observe("click", function() {
			if ($("imgAsOf").disabled == true)
				return;
			scwShow($('txtAsOf'), this, null);
		});
		
		$("imgFrom").observe("click", function() {
			if ($("imgFrom").disabled == true)
				return;
			scwShow($('txtFrom'), this, null);
		});
		
		$("imgTo").observe("click", function() {
			if ($("imgTo").disabled == true)
				return;
			scwShow($('txtTo'), this, null);
		});
		
		initializeAll();
		initGICLS267();

	} catch(e) {
		showErrorMessage("Error in Claim Listing per Ceding Company : ", e);
	}
</script>