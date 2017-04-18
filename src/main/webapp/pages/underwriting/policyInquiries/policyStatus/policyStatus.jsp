<div id="viewPolicyStatusMainDiv">
	<!-- 
	removed by robert 10.07.2013 
	<div id="viewPolicyStatusSubMenu">
	 	<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="viewPolicyStatusExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div> -->
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>View Policy Status</label>
	   	</div>
	</div>
	<div class="sectionDiv">
		<div style="float: left; margin: 10px 0 0 20px; width: 700px;">
			<span style="float: left;">Search By</span>
			<table style="clear: both; float: left; margin: 0 30px 0 25px;">
				<tr>
					<td>
						<input type="radio" id="rdoInceptDate" name="rdoSearchBy" tabindex="101"/>
					</td>
					<td>
						<label for="rdoInceptDate">Incept Date</label>
					</td>
				</tr>
				<tr>
					<td>
						<input type="radio" id="rdoIssueDate" name="rdoSearchBy" tabindex="102" />
					</td>
					<td>
						<label for="rdoIssueDate">Issue Date</label>
					</td>
				</tr>
				<tr>
					<td>
						<input type="radio" id="rdoEffDate" name="rdoSearchBy" tabindex="103" />
					</td>
					<td>
						<label for="rdoEffDate">Effectivity Date</label>
					</td>
				</tr>
			</table>
			<table style="float: left;">
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
			<div style="float: left; width: 200px; padding: 15px 0 0 40px;">
				<span style="width: 100%;"><label for="txtCredBranch">Crediting Branch</label></span>
				<input style="margin: 5px 0 0 25px; width: 170px;" type="text" class="allCaps" id="txtCredBranch" tabindex="109" />
			</div>
			<div id="poliycyStatusTableDiv" style="clear: both; padding: 5px 0 0 0px; float: left;">
				<div id="policyStatusTable" style="height: 235px; margin-left: auto;"></div>
			</div>
			<div style="clear: both; text-align: center; margin: 0 auto 10px;">
				<input type="button" class="disabledButton" id="btnPolicyInfo" value="Policy Information" />
			</div>
		</div>
		<div style="float: right; margin: 20px 20px 0 0; width: 170px;">
			<div class="sectionDiv" style="text-align: center; padding-top: 15px;">
				<strong>POLICY STATUS</strong>
				<table style="margin: 10px 0 15px 15px;">
					<tr>
						<td><input type="radio" name="rdoPolicyStat" id="rdoNew" tabindex="110" /></td>
						<td><label for="rdoNew" >New</label></td>
					</tr>
					<tr>
						<td><input type="radio" name="rdoPolicyStat" id="rdoRenewals" tabindex="111" /></td>
						<td><label for="rdoRenewals" >Renewals</label></td>
					</tr>
					<tr>
						<td><input type="radio" name="rdoPolicyStat" id="rdoReplacements" tabindex="112" /></td>
						<td><label for="rdoReplacements" >Replacements</label></td>
					</tr>
					<tr>
						<td><input type="radio" name="rdoPolicyStat" id="rdoCancelled" tabindex="113" /></td>
						<td><label for="rdoCancelled" >Cancelled</label></td>
					</tr>
					<tr>
						<td><input type="radio" name="rdoPolicyStat" id="rdoSpoiled" tabindex="114" /></td>
						<td><label for="rdoSpoiled" >Spoiled</label></td>
					</tr>
					<tr>
						<td><input type="radio" name="rdoPolicyStat" id="rdoTagForSpoilage" tabindex="115" /></td>
						<td><label for="rdoTagForSpoilage" >Tag for Spoilage</label></td>
					</tr>
					<tr>
						<td><input type="radio" name="rdoPolicyStat" id="rdoExpired" tabindex="116" /></td>
						<td><label for="rdoExpired" >Expired</label></td>
					</tr>
					<tr>
						<td><input type="radio" name="rdoPolicyStat" id="rdoAll" tabindex="117" /></td>
						<td><label for="rdoAll" >All of the Above</label></td>
					</tr>
				</table>
			</div>
			<div class="sectionDiv" style="margin-top: 5px;">
				<table style="margin: 15px 0 15px 15px;">
					<tr>
						<td><input type="radio" name="rdoSearchByOpt" id="rdoDistributed" tabindex="118" /></td>
						<td><label for="rdoDistributed">Distributed</label></td>
					</tr>
					<tr>
						<td><input type="radio" name="rdoSearchByOpt" id="rdoUndistributed" tabindex="119" /></td>
						<td><label for="rdoUndistributed">Undistributed</label></td>
					</tr>
					<tr>
						<td><input type="radio" name="rdoSearchByOpt" id="rdoBoth" tabindex="120" /></td>
						<td><label for="rdoBoth">Both</label></td>
					</tr>
				</table>
			</div>
		</div>
	</div>
	<div class="sectionDiv" style="margin-bottom: 50px;">
		<div style="float: left; margin: 0px 0 0 20px; width: 700px;">
			<table style="margin: 15px auto;">
				<tr>
					<td class="rightAligned">Incept Date</td>
					<td class="leftAligned"><input type="text" id="txtInceptDate" style="width: 180px;"  readonly="readonly" tabindex="201"/></td>
					<td style="width: 20px;"></td>
					<td class="rightAligned">Expiry Date</td>
					<td class="leftAligned"><input type="text" id="txtExpiryDate" style="width: 180px;" readonly="readonly" tabindex="203"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Effectivity Date</td>
					<td class="leftAligned"><input type="text" id="txtEffDate" style="width: 180px;" readonly="readonly" tabindex="202"/></td>
					<td></td>
					<td class="rightAligned">Issue Date</td>
					<td class="leftAligned"><input type="text" id="txtIssueDate" style="width: 180px;" readonly="readonly" tabindex="204"/></td>
				</tr>
			</table>
		</div>
		<div style="float: right; margin: 15px 20px 0 0; width: 170px;">
			<center><strong>Details</strong></center>
			<div style="margin: 0 auto; width: 41px; /* border: 1px solid #456179; */" >
				<img style="margin: 0;" id="imgHistory" src="${pageContext.request.contextPath}/images/misc/history.PNG" alt="History"  tabindex="207"/>
			</div>
		</div>
	</div>	
</div>
<div id="policyInformationDiv"></div> <!-- Added by CarloR 7.25.2016 -->
<script>
	try{
		//$("mainNav").hide();
		var onSearch = false;
		var policyId = '';
		objGIPIS100.callingForm = "GIPIS132";
		var credBranch = "";
		
		function initGIPIS132(){
			setModuleId("GIPIS132");
			setDocumentTitle("View Policy Status");
			$("rdoInceptDate").checked = true;
			$("rdoAsOf").checked = true;
			//$("rdoNew").checked = true; commented out by reymon 05082013
			$("rdoAll").checked = true;
			$("btnToolbarPrint").hide();
			$("txtAsOf").value = getCurrentDate();
			//$("rdoDistributed").checked = true; commented out by reymon 05082013
			$("rdoBoth").checked = true;
			disableToolbarButton("btnToolbarEnterQuery");
			disableFromToFields();
			onSearch = false;
			objGIPIS131 = new Object(); //for par history
			if(typeof objGIPIS132 == 'undefined'){
				$("rdoInceptDate").focus();
				objGIPIS132 = new Object();
			} else {
				$(objGIPIS132.filterByPolFlag).checked = true;
				$(objGIPIS132.filterByDist).checked = true;
				$(objGIPIS132.dateOption).checked = true;
				$(objGIPIS132.filterByDate).checked = true;
				
				$("txtAsOf").value = objGIPIS132.asOf;
				$("txtFrom").value = objGIPIS132.from;
				$("txtTo").value = objGIPIS132.to;
			} 
			
			if($("rdoSpoiled").checked){
				$("rdoDistributed").disable();
				$("rdoDistributed").checked = true;
				$("rdoUndistributed").disable();
				$("rdoBoth").disable();
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
			$("txtAsOf").setStyle({backgroundColor: '#FFFACD'});
			$("divAsOf").setStyle({backgroundColor: '#FFFACD'});
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
			$("txtCredBranch").readOnly = true;
			disableToolbarButton("btnToolbarExecuteQuery");
			enableToolbarButton("btnToolbarEnterQuery");
			onSearch = true;
		}
		
		function resetForm() {
			credBranch = "";
			tbgViewPolicyStatus.url = contextPath+"/GIPIPolbasicController?action=showGIPIS132&refresh=1&onSearch=1&clear=1";
			tbgViewPolicyStatus._refreshList();
			objGIPIS131 = new Object();
			$("rdoInceptDate").checked = true;
			//$("rdoNew").checked = true; commented out by reymon 05082013
			$("rdoAll").checked = true;
			//$("rdoDistributed").checked = true; commented out by reymon 05082013
			$("rdoBoth").checked = true;
			$("rdoAsOf").checked = true;
			$("txtAsOf").value = getCurrentDate();
			$("rdoAsOf").disabled = false;
			$("rdoFrom").disabled = false;
			disableToolbarButton("btnToolbarEnterQuery");
			onSearch = false;
			disableFromToFields();
			enableToolbarButton("btnToolbarExecuteQuery");
			$("txtCredBranch").readOnly = false;
			objGIPIS131 = new Object();
			policyId = '';
			$("txtCredBranch").clear();
		}
		
		//var jsonPolicyStatus = JSON.parse('${jsonPolicyStatus}');
		policyStatusTableModel = {
				url: contextPath+"/GIPIPolbasicController?action=showGIPIS132&refresh=1",	
				options: {
					hideColumnChildTitle: true,
					toolbar: {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
					},
					width: '700px',
					height: '203px',
					onCellFocus : function(element, value, x, y, id) {
						tbgViewPolicyStatus.keys.removeFocus(tbgViewPolicyStatus.keys._nCurrentFocus, true);
						tbgViewPolicyStatus.keys.releaseKeys();
						setDetails(tbgViewPolicyStatus.geniisysRows[y]);
					},
					onRemoveRowFocus : function(element, value, x, y, id){
						tbgViewPolicyStatus.keys.removeFocus(tbgViewPolicyStatus.keys._nCurrentFocus, true);
						tbgViewPolicyStatus.keys.releaseKeys();
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
						id : "policyNo",
						title: "Policy Number",
						children : [
							{
								id : "lineCd",
								title : 'Line Cd',
								width : 30,
								filterOption : true
							},
							{
								id : "sublineCd",
								title : 'Subline Cd',
								width : 35,
								filterOption : true
							},
							{
								id : "issCd",
								title : 'Iss Cd',
								width : 30,
								filterOption : true
							},
							{
								id : "issueYy",
								title : 'Issue Yr.',
								width : 30,
								filterOption : true,
								filterOptionType : 'number',
								align : 'right'
							},
							{
								id : "polSeqNo",
								title : 'Pol Seq No',
								width : 50,
								filterOption : true,
								filterOptionType : 'number',
								align : 'right',
								renderer : function(value){
									return formatNumberDigits(value,7);
								}
							},
							{
								id : "renewNo",
								title : 'Renew No',
								width : 30,
								filterOption : true,
								filterOptionType : 'number',
								align : 'right',
								renderer : function(value){
									return formatNumberDigits(value, 2);
								}
							}
			            ]
					},
					{
						id : "endorsementNo",
						title: "Endorsement No.",
						children : [
							{
								id : "endtIssCd",
								title : 'Endt Iss Cd',
								width : 30,
								filterOption : true
							},
							{
								id : "endtYy",
								title : 'Endorsement Yr.',
								width : 30,
								align: 'right',
								filterOption : true,
								filterOptionType : 'number',
							},
							{
								id : "endtSeqNo",
								title : 'Endorsement Seq No',
								width : 50,
								filterOption : true,
								filterOptionType : 'number',
								align: 'right',
								renderer : function(value){
									return value == '' ? '' : formatNumberDigits(value, 6);
								}
							}
			            ]
					},
					{
						id: 'assdName',
						title : 'Assured Name',
						width : "180px",
						filterOption : true,
						renderer : function(value){
							return unescapeHTML2(value);
						}
					},
					{
						id: 'userId2',
						title: 'User ID',
						width: "77px",
						filterOption : true
					},
					{
						id: 'meanPolFlag',
						title : 'Status',
						width: "81px",
						filterOption: false,
						renderer : function(val){
							if(val == "Cancelation")
								return "Cancellation";
							else
								return val;
						}
					}
				],
				rows: []
			};
		
		tbgViewPolicyStatus = new MyTableGrid(policyStatusTableModel);
		tbgViewPolicyStatus.pager = [];
		tbgViewPolicyStatus.render('policyStatusTable');
		tbgViewPolicyStatus.afterRender = function() {
 			if(objGIPIS132.tableGridUrl != null){
				disableFields();
				tbgViewPolicyStatus.url = objGIPIS132.tableGridUrl;
				objGIPIS132.tableGridUrl = null;
				tbgViewPolicyStatus._refreshList();
			} 
			setDetails(null);
		};
		
		function setDetails(obj){
			if(obj != null){
				objGIPIS132.lineCd = obj.lineCd;
				objGIPIS132.sublineCd = unescapeHTML2(obj.sublineCd); //carloR 07.25.2016 add unescapehtml2
				objGIPIS132.issCd = obj.issCd;
				objGIPIS132.issueYy = obj.issueYy;
				objGIPIS132.polSeqNo = obj.polSeqNo;
				objGIPIS132.renewNo = obj.renewNo;
				$("txtCredBranch").value = obj.credBranchName == null ? '' : unescapeHTML2(obj.credBranchName); //CarloR 07.25.2016 add unescapehtml2
				$("txtInceptDate").value = obj.inceptDate == null ? '' : dateFormat(obj.inceptDate, 'mm-dd-yyyy');
				$("txtExpiryDate").value = obj.expiryDate == null ? '' : dateFormat(obj.expiryDate, 'mm-dd-yyyy');
				$("txtEffDate").value = obj.effDate == null ? '' : dateFormat(obj.effDate, 'mm-dd-yyyy');
				$("txtIssueDate").value = obj.issueDate == null ? '' : dateFormat(obj.issueDate, 'mm-dd-yyyy');
				objGIPIS131.parId = obj.parId == null ? null : obj.parId;
				if(obj.policyId != null){
					policyId = obj.policyId;
					enableButton("btnPolicyInfo");
				} else {
					policyId = null;
					disableButton("btnPolicyInfo");
				}
			} else {
				objGIPIS132.lineCd = null;
				objGIPIS132.sublineCd = null;
				objGIPIS132.issCd = null;
				objGIPIS132.issueYy = null;
				objGIPIS132.polSeqNo = null;
				objGIPIS132.renewNo = null;
				$("txtInceptDate").clear();
				$("txtExpiryDate").clear();
				$("txtEffDate").clear();
				$("txtIssueDate").clear();
				objGIPIS131.parId = null;
				policyId = null;
				disableButton("btnPolicyInfo");
				
				if(tbgViewPolicyStatus.geniisysRows.length > 0)
					$("txtCredBranch").clear();
			}
		};
		
		function getPolFlag(){
			var polFLag = "&polFlag=";
			
			if($("rdoNew").checked){
				objGIPIS132.filterByPolFlag = "rdoNew";
				return polFLag + "1";
			} else if($("rdoRenewals").checked){
				objGIPIS132.filterByPolFlag = "rdoRenewals";
				return polFLag + "2";
			} else if($("rdoReplacements").checked) {
				objGIPIS132.filterByPolFlag = "rdoReplacements";
				return polFLag + "3";
			} else if ($("rdoCancelled").checked) {
				objGIPIS132.filterByPolFlag = "rdoCancelled";
				return polFLag + "4";
			} else if ($("rdoSpoiled").checked) {
				objGIPIS132.filterByPolFlag = "rdoSpoiled";
				return polFLag + "5";
			} else if ($("rdoExpired").checked) {
				objGIPIS132.filterByPolFlag = "rdoExpired";
				return polFLag + "X";
			} else if($("rdoTagForSpoilage").checked) {
				objGIPIS132.filterByPolFlag = "rdoTagForSpoilage";
				return polFLag + "7";
			} else {
				objGIPIS132.filterByPolFlag = "rdoAll";
				return polFLag + "8";
			}
				
		}
		
		function getDistFlag(){
			var distFlag = "&distFlag=";
			if($("rdoUndistributed").checked){
				objGIPIS132.filterByDist = "rdoUndistributed";
				return distFlag + "1";
			} else if($("rdoDistributed").checked) {
				objGIPIS132.filterByDist = "rdoDistributed";
				return distFlag + "3";
			} else {
				objGIPIS132.filterByDist = "rdoBoth";
				return distFlag + "4";
			} 
				
		}
		
		function getDateParams(){
			if($("rdoAsOf").checked)
				objGIPIS132.filterByDate = "rdoAsOf";
			else
				objGIPIS132.filterByDate = "rdoFrom";
			
			objGIPIS132.asOf = $("txtAsOf").value;
			objGIPIS132.from = $("txtFrom").value;
			objGIPIS132.to = $("txtTo").value;
			
			var dateParams = "&dateAsOf=" + $("txtAsOf").value +
							 "&dateFrom=" + $("txtFrom").value +
							 "&dateTo=" + $("txtTo").value;
			return dateParams;
		}
		
		function getSearchByOption(){
			var searchByOpt = "&searchByOpt=";
			if($("rdoInceptDate").checked){
				objGIPIS132.dateOption = "rdoInceptDate";
				searchByOpt = searchByOpt + "inceptDate";
			} else if ($("rdoIssueDate").checked){
				objGIPIS132.dateOption = "rdoIssueDate";
				searchByOpt = searchByOpt + "issueDate";
			} else {
				objGIPIS132.dateOption = "rdoEffDate";
				searchByOpt = searchByOpt + "effDate";
			}
			return searchByOpt;
		}
		
		function executeQuery(){
			tbgViewPolicyStatus.url = contextPath+"/GIPIPolbasicController?action=showGIPIS132&refresh=1&onSearch=1&clear=0&credBranch=" + encodeURIComponent(credBranch) + getPolFlag() + getDistFlag() + getDateParams() + getSearchByOption();
			tbgViewPolicyStatus._refreshList();
			enableToolbarButton("btnToolbarEnterQuery");
		}
		
		function changeSearchOptions() {
			if($("rdoSpoiled").checked){
				$("rdoDistributed").disable();
				//$("rdoDistributed").checked = true;
				$("rdoUndistributed").disable();
				$("rdoBoth").disable();
			} else {
				$("rdoDistributed").enable();
				$("rdoUndistributed").enable();
				$("rdoBoth").enable();
			}
			
			if(onSearch) {
				if(tbgViewPolicyStatus.geniisysRows.length > 0)
					$("txtCredBranch").clear();
				executeQuery();
			}
		}
		
		function getMainPolicyId(){
			new Ajax.Request(contextPath+"/GIPIPolbasicController?action=getMainPolicyId",{
				method: "POST",
				parameters: {lineCd : objGIPIS132.lineCd,
							 sublineCd : objGIPIS132.sublineCd,
							 issCd : objGIPIS132.issCd, 
							 issueYy : objGIPIS132.issueYy,
							 polSeqNo : objGIPIS132.polSeqNo,
						     renewNo : objGIPIS132.renewNo
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function (response) {
					//objGIPIS132.policyId = Integer.parseInt(response.responseText);
					var policyId = response.responseText;
					showViewPolicyInformationPage(trim(policyId));
				}
			});

		}
		
		function showPolicyInfo() {
			objGIPIS132.tableGridUrl = tbgViewPolicyStatus.url;
			getMainPolicyId();
			objGIPIS100.callingForm = "GIPIS132"; //CarloR 7.25.2016
		}
		
		$("btnPolicyInfo").observe("click", showPolicyInfo);
		
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
		
		$("btnToolbarExecuteQuery").observe("click", function(){
			if(validateRequiredDates()){
				credBranch = $("txtCredBranch").value;
				disableFields();
				executeQuery();
			}
		});
		
		$("txtAsOf").observe("blur", function(){
			if($("rdoAsOf").checked && $("txtAsOf").value == ''){
				$("txtAsOf").value = getCurrentDate();
				objGIPIS132.asOfDate = $("txtAsOf").value;
				objGIPIS132.fromDate = '';
				objGIPIS132.toDate = '';
			}
		});
		
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
		
		$("rdoEffDate").observe("click", function(){
			if(onSearch){
				executeQuery();
			}
		});
		
		$("rdoDistributed").observe("click", function(){
			if(onSearch){
				executeQuery();
			}
		});
		
		$("rdoUndistributed").observe("click", function(){
			if(onSearch){
				executeQuery();
			}
		});
		
		$("rdoBoth").observe("click", function(){
			if(onSearch){
				executeQuery();
			}
		});
		
		$("btnToolbarEnterQuery").observe("click", resetForm);
		$("rdoAsOf").observe("click", disableFromToFields);
		$("rdoFrom").observe("click", disableAsOfFields);
		$("rdoNew").observe("click", changeSearchOptions);
		$("rdoRenewals").observe("click", changeSearchOptions);
		$("rdoReplacements").observe("click", changeSearchOptions);
		$("rdoCancelled").observe("click", changeSearchOptions);
		$("rdoSpoiled").observe("click", changeSearchOptions);
		$("rdoTagForSpoilage").observe("click", changeSearchOptions);
		$("rdoExpired").observe("click", changeSearchOptions);
		$("rdoAll").observe("click", changeSearchOptions);
		
		initGIPIS132();
		initializeAll();
		
		/* 
		removed by robert 10.07.2013 
		$("viewPolicyStatusExit").observe("click", function(){
			delete objGIPIS132;
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}); */
		
		$("btnToolbarExit").observe("click", function(){
			delete objGIPIS132;
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		});
		
	} catch(e){
		showErrorMessage("Error : " , e);
	}
</script>