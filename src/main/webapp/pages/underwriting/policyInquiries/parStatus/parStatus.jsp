<div id="viewParStatusMainDiv">
	<!-- 
	removed by robert 10.07.2013 
	<div id="viewParStatusSubMenu">
	 	<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="viewParStatusExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div> -->	
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>View PAR Status</label>
	   	</div>
	</div>
	<div class="sectionDiv">
		<div style="float: right;">
			<div class="sectionDiv" style="margin: 10px 10px 0 10px; padding: 5px 0 0 10px; float: right; width: 220px;">
				<span>Search By</span>
				<table style="margin: 0 auto;">
					<tr>
						<td><input type="radio" name="rdoSearchByDateType" id="rdoInceptDate" tabindex="101" /></td>
						<td><label for="rdoInceptDate">Incept Date</label></td>
					</tr>
					<tr>
						<td><input type="radio" name="rdoSearchByDateType" id="rdoIssueDate" tabindex="102" /></td>
						<td><label for="rdoIssueDate">Issue Date</label></td>
					</tr>
					<tr>
						<td><input type="radio" name="rdoSearchByDateType" id="rdoEffectivityDate" tabindex="103" /></td>
						<td><label for="rdoEffectivityDate">Effectivity Date</label></td>
					</tr>
				</table>
				<table border="0" style="margin: 5px 0px 5px 5px;">
					<tr>
						<td class="rightAligned"><input type="radio" name="rdoSearchByDate" id="rdoAsOf" style="float: left;" tabindex="104"/><label for="rdoAsOf" style="float: left; height: 20px; padding-top: 3px;">As of</label></td>
						<td class="leftAligned">
							<div style="float: left; width: 140px;" class="withIconDiv" id="divAsOf">
								<input type="text" removeStyle="true" id="txtAsOf" class="withIcon" readonly="readonly" style="width: 115px;" tabindex="105"/>
								<img id="imgAsOf" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As of Date" />
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned"><input type="radio" name="rdoSearchByDate" id="rdoFrom" style="float: left;" tabindex="106"/><label for="rdoFrom" style="float: left; height: 20px; padding-top: 3px;">From</label></td>
						<td class="leftAligned">
							<div style="float: left; width: 140px;" class="withIconDiv" id="divFrom">
								<input type="text" removeStyle="true" id="txtFrom" class="withIcon" readonly="readonly" style="width: 115px;" tabindex="107"/>
								<img id="imgFrom" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" />
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned"><label style="float: right; height: 20px; padding-top: 3px; margin-right: 2px;">To</label></td>
						<td class="leftAligned">
							<div style="float: left; width: 140px;" class="withIconDiv" id="divTo">
								<input type="text" removeStyle="true" id="txtTo" class="withIcon" readonly="readonly" style="width: 115px;" tabindex="108"/>
								<img id="imgTo" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" />
							</div>
						</td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" style="clear: both; margin: 10px 10px 10px 10px; padding: 5px 0 0 10px; float: right; width: 220px;">
				<center><strong>PAR Status</strong></center>
				<table style="margin: 0 auto 10px;"> <!-- modify table by carloR 07.26.2016 -->
					<tr>
						<td><input type="radio" name="rdoStatusType" id="rdoNew" tabindex="109" /></td>
						<td colspan="2"><label for="rdoNew">Newly Created Just Assigned</label></td>
					</tr>
					<tr id="trRdoUpdated">
						<td><input type="radio" name="rdoStatusType" id="rdoUpdated" tabindex="110" /></td>
						<td colspan="2"><label for="rdoUpdated">Being Updated</label></td>
					</tr>
					<tr id="trRdoWithBasicInfo"> <!-- CarloR START-->
						<td></td>
						<td><input type="radio" name="rdoStatusType" id="rdoWithBasicInfo" tabindex="111" /></td>
						<td><label for="rdoWithBasicInfo">With Basic Info</label></td>
					</tr>
					<tr id="trRdoWithItemInfo">
						<td></td> 
						<td><input type="radio" name="rdoStatusType" id="rdoWithItemInfo" tabindex="112" /></td>
						<td><label for="rdoWithItemInfo">With Item Info</label></td>
					</tr>
					<tr id="trRdoWithPerilInfo">
						<td></td>
						<td><input type="radio" name="rdoStatusType" id="rdoWithPerilInfo" tabindex="113" /></td>
						<td><label for="rdoPerilInfo">With Peril Info</label></td>
					</tr>
					<tr id="trRdoWithBill">
						<td></td>
						<td><input type="radio" name="rdoStatusType" id="rdoWithBill" tabindex="114"  /></td>
						<td><label for="rdoWithBill">With Bill</label></td>
					</tr><!-- END -->
					<tr>
						<td><input type="radio" name="rdoStatusType" id="rdoPosted" tabindex="115" /></td>
						<td colspan="2"><label for="rdoPosted">Posted</label></td>
					</tr>
					<tr>
						<td><input type="radio" name="rdoStatusType" id="rdoDeleted" tabindex="116" /></td>
						<td colspan="2"><label for="rdoDeleted">Deleted</label></td>
					</tr>
					<tr>
						<td><input type="radio" name="rdoStatusType" id="rdoCancelled" tabindex="117" /></td> <!-- jhing 08.14.2015 -->
						<td colspan="2"><label for="rdoCancelled">Cancelled</label></td>
					</tr>
					<tr>
						<td><input type="radio" name="rdoStatusType" id="rdoAll" tabindex="118" /></td>  
						<td colspan="2"><label for="rdoAll">All of the Above</label></td>
					</tr>
				</table>
			</div>
		</div>
		<div id="parStatusTableDiv" style="padding: 10px 0 0 10px; width: 640px; float: left;">
			<div id="parStatusTable" style="height: 300px; margin-left: auto;"></div>
		</div>
	</div>
	<div class="sectionDiv" style="margin-bottom: 50px;">
		<div style="width: 680px; float: left; margin-left: 50px;">
			<table cellpadding="0" cellspacing="0" style="margin : 20px auto 20px;">
				<tr>
					<td class="rightAligned"><span id="policyBondSpan">Policy No.</span></td>
					<td class="leftAligned"><input type="text" id="txtPolicyNo" readonly="readonly" style="width: 220px;" tabindex="201" /></td>
					<td style="width: 20px;"></td>
					<td class="rightAligned">Endt No.</td> <!-- jhing 08.14.2015 from Renewal No to Endorsement No --> 
					<td class="leftAligned"><input type="text" id="txtRenewNo" readonly="readonly" style="width: 220px" tabindex="204"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Incept Date</td>
					<td class="leftAligned"><input type="text" id="txtInceptDate" readonly="readonly" style="width: 220px;" tabindex="202" /></td>
					<td style="width: 20px;"></td>
					<td class="rightAligned">Expiry Date</td>
					<td class="leftAligned"><input type="text" id="txtExpiryDate" readonly="readonly" style="width: 220px" tabindex="205" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Effectivity Date</td>
					<td class="leftAligned"><input type="text" id="txtEffectivityDate" readonly="readonly" style="width: 220px;" tabindex="203" /></td>
					<td style="width: 20px;"></td>
					<td class="rightAligned">Issue Date</td>
					<td class="leftAligned"><input type="text" id="txtIssueDate" readonly="readonly" style="width: 220px" tabindex="206" /></td>
				</tr>
			</table>
		</div>
		<div style="width: 150px; float: right; margin: 20px 30px 0 0;">
			<center><strong>Details</strong></center>
			<div style="margin: 5px auto; width: 41px; /* border: 1px solid #456179; */" >
				<img style="margin: 0;" id="imgHistory" src="${pageContext.request.contextPath}/images/misc/history.PNG" alt="History"  tabindex="207"/>
			</div>
		</div>
	</div>
</div>
<script>
	try{
		//$("mainNav").hide();
		var onSearch = false;
		
		function initGIPIS131(){
			setModuleId("GIPIS131");
			setDocumentTitle("View PAR Status");
			objGIPIS131 = new Object();
			$("trRdoWithBill").hide(); //added by CarloR 07.26.2016 start
			$("trRdoWithBasicInfo").hide();
			$("trRdoWithItemInfo").hide();
			$("trRdoWithPerilInfo").hide(); //end
			$("rdoInceptDate").checked = true;
			$("rdoAsOf").checked = true;
			//$("rdoNew").checked = true;// commented out by jeffdojello 05.04.2013
			$("rdoAll").checked = true; // added by jeffdojello 05.04.2013 [SR-12941]
			$("btnToolbarPrint").hide();
			$("txtAsOf").value = getCurrentDate();
			//disableToolbarButton("btnToolbarEnterQuery");
			onSearch = true;
			disableFromToFields();
			hideToolbarButton("btnToolbarExecuteQuery");
		}
		
		function resetForm() {
			tbgViewParStatus.url = contextPath+"/GIPIPolbasicController?action=showGIPIS131&refresh=1&onSearch=1&clear=1";
			tbgViewParStatus._refreshList();
			objGIPIS131 = new Object();
			$("rdoInceptDate").checked = true;
			$("rdoAsOf").checked = true;
			$("rdoAll").checked = true;
			$("txtAsOf").value = getCurrentDate();
			$("rdoAsOf").disabled = false;
			$("rdoFrom").disabled = false;
			//disableToolbarButton("btnToolbarEnterQuery");
			onSearch = true;
			disableFromToFields();
			enableToolbarButton("btnToolbarExecuteQuery");
		}
		
		
		function setDetails(obj){
			if(obj != null){
				$("txtPolicyNo").value = unescapeHTML2(obj.policyNo);
				$("txtRenewNo").value = unescapeHTML2(obj.endtNo);
				$("txtInceptDate").value = obj.inceptDate == null ? '' : dateFormat(obj.inceptDate, 'mm-dd-yyyy');
				$("txtExpiryDate").value = obj.expiryDate == null ? '' : dateFormat(obj.expiryDate, 'mm-dd-yyyy');
				$("txtEffectivityDate").value = obj.effDate == null ? '' : dateFormat(obj.effDate, 'mm-dd-yyyy');
				$("txtIssueDate").value = obj.issueDate == null ? '' : dateFormat(obj.issueDate, 'mm-dd-yyyy');
				objGIPIS131.parId = obj.parId;
				if(obj.plistLineCd == "SU"){
					$("policyBondSpan").update("Bond No.");
				} else {
					$("policyBondSpan").update("Policy No.");
				}
			} else {
				$("txtPolicyNo").clear();
				$("txtRenewNo").clear();
				$("txtInceptDate").clear();
				$("txtExpiryDate").clear();
				$("txtEffectivityDate").clear();
				$("txtIssueDate").clear();
				
				objGIPIS131.parId = null;
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
			$("txtFrom").value = getCurrentDate();
			$("txtTo").value = getCurrentDate();
			$("txtFrom").setStyle({backgroundColor: '#FFFACD'});
			$("divFrom").setStyle({backgroundColor: '#FFFACD'});
			$("txtTo").setStyle({backgroundColor: '#FFFACD'});
			$("divTo").setStyle({backgroundColor: '#FFFACD'});
			$("txtAsOf").setStyle({backgroundColor: '#F0F0F0'});
			$("divAsOf").setStyle({backgroundColor: '#F0F0F0'});
		}
		
		function disableFields() {
			$("txtAsOf").disabled = true;
			$("imgAsOf").disabled = true;
			$("txtFrom").disabled = true;
			$("txtTo").disabled = true;
			$("imgFrom").disabled = true;
			$("imgTo").disabled = true;
			disableDate("imgFrom");
			disableDate("imgTo");
			disableDate("imgAsOf");
			$("txtFrom").setStyle({backgroundColor: '#F0F0F0'});
			$("divFrom").setStyle({backgroundColor: '#F0F0F0'});
			$("txtTo").setStyle({backgroundColor: '#F0F0F0'});
			$("divTo").setStyle({backgroundColor: '#F0F0F0'});
			$("txtAsOf").setStyle({backgroundColor: '#F0F0F0'});
			$("divAsOf").setStyle({backgroundColor: '#F0F0F0'});
			$("rdoAsOf").disabled = true;
			$("rdoFrom").disabled = true;
			disableToolbarButton("btnToolbarExecuteQuery");
		}
		
		function getDateParams(){
			var dateParams = "&dateAsOf=" + $("txtAsOf").value +
							 "&dateFrom=" + $("txtFrom").value +
							 "&dateTo=" + $("txtTo").value;
			return dateParams;
		}
		
		function getFilterByParStat(){
			if($("rdoNew").checked)
				return "new";
			else if ($("rdoUpdated").checked)
				return "being_updated";
			else if ($("rdoPosted").checked)
				return "posted";
			else if ($("rdoDeleted").checked)
				return "deleted";
			else if ($("rdoCancelled").checked) // added by jhing 08.14.2015 
				return "cancelled";
			else if ($("rdoWithBill").checked) //added by CarloR 07.26.2016 START
				return "with_bill";
			else if ($("rdoWithBasicInfo").checked)
				return "with_basic";
			else if ($("rdoWithItemInfo").checked)
				return "with_item";
			else if ($("rdoWithPerilInfo").checked)
				return "with_peril";  //END
			else
				return "";
		}
		
		function getSearchByOption(){
			var searchByOpt = "&searchByOpt=";
			if($("rdoInceptDate").checked)
				searchByOpt = searchByOpt + "inceptDate";
			else if ($("rdoIssueDate").checked)
				searchByOpt = searchByOpt + "issueDate";
			else
				searchByOpt = searchByOpt + "effDate";
			
			return searchByOpt;
		}
		
		function executeQuery(){
			var mtgId = tbgViewParStatus._mtgId;
			saveFilterText = saveFilterForQuery(mtgId);
			tbgViewParStatus.url = contextPath+"/GIPIPolbasicController?action=showGIPIS131&refresh=1&onSearch=1&clear=0&parStat=" + getFilterByParStat() + getDateParams() + getSearchByOption();
			onSearch = true;
			enableToolbarButton("btnToolbarEnterQuery");
			
			if(saveFilterText != ""){
				$('mtgFilterText'+ mtgId).value = saveFilterText;
				fireEvent($('mtgBtnAddFilter'+mtgId), "click");
				fireEvent($('mtgBtnOkFilter'+mtgId), "click");
			} else {
				tbgViewParStatus._refreshList();
			}
		}		
		
		/* $("btnToolbarExecuteQuery").observe("click", function(){
			if(validateRequiredDates()){
				disableFields();
				executeQuery();
			}
			
		}); */
		
		$("txtAsOf").observe("focus", function(){
			if ($("imgAsOf").disabled == true) return;
			var asOfDate = $F("txtAsOf") != "" ? new Date($F("txtAsOf").replace(/-/g,"/")) :"";
			var sysdate = new Date();
			if (asOfDate > sysdate && asOfDate != ""){
				customShowMessageBox("Date should not be greater than the current date.", "I", "txtAsOf");
				$("txtAsOf").clear();
				return false;
			}
		});
		
	 	$("txtFrom").observe("focus", function(){
			if ($("imgFrom").disabled == true) return;
			var fromDate = $F("txtFrom") != "" ? new Date($F("txtFrom").replace(/-/g,"/")) :"";
			var sysdate = new Date();
			var toDate = $F("txtTo") != "" ? new Date($F("txtTo").replace(/-/g,"/")) :"";
			if (fromDate > sysdate && fromDate != ""){
				customShowMessageBox("Date should not be greater than the current date.", "I", "txtFrom");
				$("txtFrom").clear();
				$("txtTo").clear();
				return false;
			}
			if (toDate < fromDate && toDate != ""){
				customShowMessageBox("TO Date should not be less than the FROM date.", "I", "txtTo");
				$("txtFrom").clear();
				$("txtTo").clear();
				return false;
			}
		});
	 	
	 	$("txtTo").observe("focus", function(){
			if ($("imgTo").disabled == true) return;
			var toDate = $F("txtTo") != "" ? new Date($F("txtTo").replace(/-/g,"/")) :"";
			var fromDate = $F("txtFrom") != "" ? new Date($F("txtFrom").replace(/-/g,"/")) :"";
			var sysdate = new Date();
			if (toDate > sysdate && toDate != ""){
				customShowMessageBox("Date should not be greater than the current date.", "I", "txtTo");
				$("txtTo").clear();
				return false;
			}
			if (toDate < fromDate && toDate != ""){
				customShowMessageBox("TO Date should not be less than the FROM date.", "I", "txtTo");
				$("txtTo").clear();
				return false;
			}
			if(fromDate=="" && toDate!=""){
				customShowMessageBox("Please enter FROM date first.", "I", "txtTo");
				$("txtTo").clear();
				$("txtFrom").clear();
				return false;
			}
		});
		
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
		
		$("imgAsOf").observe("click", function() {
			if ($("imgAsOf").disabled == true)
				return;
			scwNextAction = validateAsOfDateThenQuery.runsAfterSCW(this, null);
			scwShow($('txtAsOf'), this, null);
		});
		
		$("imgFrom").observe("click", function() {
			if ($("imgFrom").disabled == true)
				return;
			
			scwNextAction = executeQueryUponDateSelect.runsAfterSCW(this, null);
			scwShow($('txtFrom'), this, null);
		});
		
		$("imgTo").observe("click", function() {
			if ($("imgTo").disabled == true)
				return;
			
			scwNextAction = executeQueryUponDateSelect.runsAfterSCW(this, null);
			scwShow($('txtTo'), this, null);
		});
		
		function executeQueryUponDateSelect(){
			if($("txtTo").value != "" && $("txtFrom").value != ""){
				if ($("imgTo").disabled == true) return;
				var toDate = $F("txtTo") != "" ? new Date($F("txtTo").replace(/-/g,"/")) :"";
				var fromDate = $F("txtFrom") != "" ? new Date($F("txtFrom").replace(/-/g,"/")) :"";
				var sysdate = new Date();
				if (toDate > sysdate && toDate != ""){
					customShowMessageBox("Date should not be greater than the current date.", "I", "txtTo");
					$("txtTo").clear();
					return false;
				}
				if (toDate < fromDate && toDate != ""){
					customShowMessageBox("TO Date should not be less than the FROM date.", "I", "txtTo");
					$("txtTo").clear();
					return false;
				}
				if(fromDate=="" && toDate!=""){
					customShowMessageBox("Please enter FROM date first.", "I", "txtTo");
					$("txtTo").clear();
					$("txtFrom").clear();
					return false;
				}
				
				executeQuery();
			}
		}
		
		$("rdoAsOf").observe("click", function(){
			disableFromToFields();
			executeQuery();
		});
		
		$("rdoFrom").observe("click", function() {
			disableAsOfFields();
			executeQuery();
		});

		/* 
		removed by robert 10.07.2013
		$("viewParStatusExit").observe("click", function(){
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}); */
		
		$("btnToolbarExit").observe("click", function(){
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		});
		
		$("rdoInceptDate").observe("click", function(){
			if(onSearch){
				executeQuery();
			}
		});
		
		$("rdoIssueDate").observe("click", function(){
			if(onSearch){
				executeQuery();
			}
		});
		
		$("rdoEffectivityDate").observe("click", function(){
			if(onSearch){
				executeQuery();
			}
		});
		
		$("rdoNew").observe("click", function(){
		 	$("trRdoWithBill").hide(); //Added by CarloR 07.26.2016 START
			$("trRdoWithBasicInfo").hide();
			$("trRdoWithItemInfo").hide();
			$("trRdoWithPerilInfo").hide(); //end
			if(onSearch){
				executeQuery();
			}
		});
		
		$("rdoUpdated").observe("click", function(){
			$("trRdoWithBill").show(); //Added by CarloR 07.26.2016 START
			$("trRdoWithBasicInfo").show();
			$("trRdoWithItemInfo").show();
			$("trRdoWithPerilInfo").show(); //end
			if(onSearch){
				executeQuery();
			}
		});
		
		$("rdoPosted").observe("click", function(){
		 	$("trRdoWithBill").hide(); //Added by CarloR 07.26.2016 START
			$("trRdoWithBasicInfo").hide();
			$("trRdoWithItemInfo").hide();
			$("trRdoWithPerilInfo").hide(); //end
			if(onSearch){
				executeQuery();
			}
		});
		
		$("rdoDeleted").observe("click", function(){
		 	$("trRdoWithBill").hide(); //Added by CarloR 07.26.2016 START
			$("trRdoWithBasicInfo").hide();
			$("trRdoWithItemInfo").hide();
			$("trRdoWithPerilInfo").hide(); //end
			if(onSearch){
				executeQuery();
			}
		});
		
		// added by Jhing 08.14.2015
		$("rdoCancelled").observe("click", function(){
		 	$("trRdoWithBill").hide(); //Added by CarloR 07.26.2016 START
			$("trRdoWithBasicInfo").hide();
			$("trRdoWithItemInfo").hide();
			$("trRdoWithPerilInfo").hide(); //end
			if(onSearch){
				executeQuery();
			}
		});
		
		$("rdoAll").observe("click", function(){
		 	$("trRdoWithBill").hide(); //Added by CarloR 07.26.2016 START
			$("trRdoWithBasicInfo").hide();
			$("trRdoWithItemInfo").hide();
			$("trRdoWithPerilInfo").hide(); //end
			if(onSearch){
				executeQuery();
			}
		});
		
		$("rdoWithBill").observe("click", function(){ //CarloR Start 07.26.2016
			if(onSearch){
				executeQuery();
			}
		});
		
		$("rdoWithBasicInfo").observe("click", function(){ 
			if(onSearch){
				executeQuery();
			}
		});
		
		$("rdoWithPerilInfo").observe("click", function(){ 
			if(onSearch){
				executeQuery();
			}
		});
		
		$("rdoWithItemInfo").observe("click", function(){ 
			if(onSearch){
				executeQuery();
			}
		}); //end
		
		function showParStatusHistory() {
			try {
			overlayParStatusHistory = 
				Overlay.show(contextPath+"/GIPIPolbasicController", {
					urlContent: true,
					urlParameters: {action : "showGipis131ParStatusHistory",																
									ajax : "1",
									parId : objGIPIS131.parId
					},
				    title: "Par History",
				    height: 250,
				    width: 500,
				    draggable: true
				});
			} catch (e) {
				showErrorMessage("overlay error: " , e);
			}
		}
		
		$("imgHistory").observe("click", function(){
			if(objGIPIS131.parId != null)
				showParStatusHistory();
		});
		
		$("btnToolbarEnterQuery").observe("click", resetForm);
		
		jsonViewParStatus = JSON.parse('${jsonParStatus}');
		var parStatusTableModel = {
				url: contextPath+"/GIPIPolbasicController?action=showGIPIS131&refresh=1&onSearch=1&clear=0&parStat=" + getFilterByParStat() + getDateParams() + getSearchByOption(),
				options: {
					hideColumnChildTitle: true,
					pager : {},
					toolbar: {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
					},
					width: '660px',
					height: '295px',
					onCellFocus : function(element, value, x, y, id) {
						tbgViewParStatus.keys.removeFocus(tbgViewParStatus.keys._nCurrentFocus, true);
						tbgViewParStatus.keys.releaseKeys();
						setDetails(tbgViewParStatus.geniisysRows[y]);
					},
					onRemoveRowFocus : function(element, value, x, y, id){
						tbgViewParStatus.keys.removeFocus(tbgViewParStatus.keys._nCurrentFocus, true);
						tbgViewParStatus.keys.releaseKeys();
						setDetails(null);
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
						id : "plistLineCd plistIssCd parYy parSeqNo quoteSeqNo",
						title: "Par No.",
						width: 140,
						filterOption: false,
						children : [
							{
								id : 'plistLineCd',
								title : 'Line Cd',
								width : 30,
								filterOption : true
							},
							{
								id : 'plistIssCd',
								title : 'Iss Cd',
								width : 30,
								filterOption : true
							},
							{
								id : 'parYy',
								title : 'Par YY',
								width : 30,
								filterOption : true,
								filterOptionType: 'number',
								align : 'right',
								titleAlign : 'right'
							},
							{
								id : 'parSeqNo',
								title : 'Par Seq No',
								width : 50,
								filterOption : true,
								filterOptionType: 'number',
								align : 'right',
								renderer : function(value){
									return formatNumberDigits(value,6);
								}
							},
							{
								id : 'quoteSeqNo',
								title : 'Quote Seq No',
								width : 30,
								filterOption : true,
								filterOptionType: 'number',
								align : 'right',
								renderer : function(value){
									return formatNumberDigits(value,2);
								}
							}
						]
					},
					{
						id : "assdName",
						title: "Assured Name",
						width: '160px',
						filterOption : true,
						renderer : function(value){
							return unescapeHTML2(value);
						}
					},
					{  // added by Jhing 08.14.2015
						id : "credBranch",
						title: "Cred Branch",
						width: '80px',						
						filterOption : true
					},
					{
						id : "parType",
						title: "Type",
						width: '40px',
						filterOption : true
					},
					{
						id : "underwriter",
						title: "User ID",
						//width: '100px',   // replaced by jhing 08.14.2015 
						width: '50px',     
						filterOption : true
					},
					{
						id : "drvParStatus",
						title: "Status",
						//width: '149px',   // replaced by jhing 08.14.2015 
						width: '120px',
						//filterOption : true
						filterOption : false   // jhing 08.14.2015 to reduce complexity of filtering.
					}
				],
				rows: jsonViewParStatus.rows
			};
		
		tbgViewParStatus = new MyTableGrid(parStatusTableModel);
		tbgViewParStatus.pager = jsonViewParStatus;
		tbgViewParStatus.render('parStatusTable');
		tbgViewParStatus.afterRender = function(){
			setDetails(null);
		};
		
		function saveFilterForQuery(mtgId){
			return $('mtgFilterText'+ mtgId).value;
		}
		
		function validateAsOfDateThenQuery(){
			if ($("imgAsOf").disabled == true) return;
			var asOfDate = $F("txtAsOf") != "" ? new Date($F("txtAsOf").replace(/-/g,"/")) :"";
			var sysdate = new Date();
			if (asOfDate > sysdate && asOfDate != ""){
				customShowMessageBox("Date should not be greater than the current date.", "I", "txtAsOf");
				$("txtAsOf").clear();
				return false;
			}
			
			executeQuery();
		}
		
		initializeAll();
		initGIPIS131();
	} catch(e){
		showErrorMessage("Error : " , e);
	}
</script>