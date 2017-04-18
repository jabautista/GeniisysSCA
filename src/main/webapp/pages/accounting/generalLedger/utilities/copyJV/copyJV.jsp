<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
		<label>Copy Journal Voucher</label>
	</div>
</div>
<div class="sectionDiv">
	<div class="sectionDiv" style="width: 550px; padding: 20px 0; margin: 80px auto 15px; float: none;">
		<table align="center">
			<tr>
				<td class="rightAligned"><label style="float: right;">Copy From</label></td>
				<td>
					<span class="lovSpan required" style="width: 86px; margin-bottom: 0;">
						<input type="text" id="txtBranchCdFrom" style="width: 61px; float: left;" class="withIcon allCaps required"  maxlength="30"  tabindex="101"/>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgBranchCdFrom" alt="Go" style="float: right;" />
					</span>
				</td>
				<td>
					<span class="lovSpan required" style="width: 70px; margin-bottom: 0;">
						<input type="text" id="txtDocumentYearFrom" style="width: 40px; float: left;" class="withIcon required integerNoNegativeUnformattedNoComma"  maxlength="4"  tabindex="102"/>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgDocumentYearFrom" alt="Go" style="float: right;" />
					</span>
				</td>
				<td>
					<input type="text" id="txtDocumentMmFrom" maxlength="2" class="integerNoNegativeUnformattedNoComma" tabindex="103" style="height: 14px; width: 60px;"/>
				</td>
				<td>
					<span class="lovSpan required" style="width: 86px; margin-bottom: 0;">
						<input type="text" id="txtDocSeqNoFrom" style="width: 61px; float: left;" class="withIcon integerNoNegativeUnformattedNoComma required"  maxlength="6"  tabindex="104"/>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgDocSeqNoFrom" alt="Go" style="float: right;" />
					</span>
				</td>
			</tr>
			<tr>
				<td class="rightAligned"><label style="float: right;">Copy To</label></td>
				<td>
					<span class="lovSpan required" style="width: 86px; margin-bottom: 0;">
						<input type="text" id="txtBranchCdTo" style="width: 61px; float: left;" class="withIcon allCaps required"  maxlength="30"  tabindex="105"/>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgBranchCdTo" alt="Go" style="float: right;" />
					</span>
				</td>
				<td>
					<input type="text" id="txtDocumentYearTo" class="integerNoNegativeUnformattedNoComma" maxlength="4" style="height: 14px; width: 64px;" tabindex="106"/>
				</td>
				<td colspan="2" style="text-align: left;">
					<input type="text" id="txtDocumentMmTo" maxlength="2" class="integerNoNegativeUnformattedNoComma" tabindex="107" style="height: 14px; width: 60px;"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned"><label style="float: right;">Tran Date</label></td>
				<td colspan="2">
					<div style="float: left; width: 162px; height: 20px; margin: 0;" class="withIconDiv">
						<input type="text" removeStyle="true" id="txtTranDate" class="withIcon" readonly="readonly" style="width: 138px;" tabindex="108"/>
						<img id="imgTranDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" style="margin : 1px 1px 0 0; cursor: pointer"/>
					</div>
				</td>
			</tr>
		</table>
	</div>
	<div style="margin-bottom: 80px;">
		<input type="button" id="btnCopy" class="button" value="Copy" style="width: 100px;" />
		<input type="button" id="btnEdit" class="button" value="Edit JV" style="width: 100px;" />
	</div>
</div>
<script type="text/javascript">
	try {
		
		setModuleId("GIACS051");
		setDocumentTitle("Facility to Copy Journal Voucher");
		objGIACS051 = new Object();
		var onLOV = false;
		var checkBranchFrom = "";
		var checkDocYear = "";
		var checkDocSeqNo = "";
		var checkBranchTo = "";
		
		function initGIACS051(){
			$("txtBranchCdFrom").focus();
			$("txtDocumentYearFrom").readOnly = true;
			$("txtDocumentMmFrom").readOnly = true;
			$("txtDocSeqNoFrom").readOnly = true;
			$("txtDocumentYearTo").readOnly = true;
			$("txtDocumentMmTo").readOnly = true;
			disableSearch("imgDocumentYearFrom");
			disableSearch("imgDocSeqNoFrom");
			disableDate("imgTranDate");
			$("imgTranDate").next().setStyle({margin : "1px 1px 0 0", cursor : "pointer"});
			disableButton("btnCopy");
			disableButton("btnEdit");
			
		}
		
		function getGIACS051BranchCdFromLOV() {
			onLOV = true;
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS051BranchCdFromLOV",
					searchString : checkBranchFrom == "" ? $("txtBranchCdFrom").value : "",
					page : 1
				},
				title : "List of Branch Code",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "gibrBranchCd",
					title : "Branch Code",
					width : '120px',
				}, {
					id : "issName",
					title : "Branch Name",
					width : '345px',
					renderer: function(value) {
						return unescapeHTML2(value);
					}
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText:  checkBranchFrom == "" ? $("txtBranchCdFrom").value : "",
				onSelect : function(row) {
					onLOV = false;
					if($("txtBranchCdFrom").value != row.gibrBranchCd)
						branchFromKeyPress("clear");
					$("txtBranchCdFrom").value = row.gibrBranchCd;
					checkBranchFrom = row.gibrBranchCd;
					$("txtDocumentYearFrom").readOnly = false;
					enableSearch("imgDocumentYearFrom");
					$("txtDocumentYearFrom").focus();
				},
				onCancel : function () {
					onLOV = false;
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranchCdFrom");
					onLOV = false;
				}
			});
		}
		
		function getGIACS051DocYearLOV() {
			onLOV = true;
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS051DocYearLOV",
					branchCdFrom : $("txtBranchCdFrom").value,
					searchString : checkDocYear == "" ? $("txtDocumentYearFrom").value : "",
					page : 1
				},
				title : "Valid Values for Doc Year and  Doc Month",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "docYear",
					title : "Doc Year",
					width : '120px',
				}, {
					id : "docMm",
					title : "Doc Month",
					width : '345px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText:  checkDocYear == "" ? $("txtDocumentYearFrom").value : "",
				onSelect : function(row) {
					onLOV = false;
					if($("txtDocumentYearFrom").value != row.docYear)
						docYearKeyPress("clear");
					$("txtDocumentYearFrom").value = row.docYear;
					checkDocYear = row.docYear;
					$("txtDocumentMmFrom").value = formatNumberDigits(row.docMm, 2);
					$("txtDocumentMmFrom").readOnly = false;
					$("txtDocSeqNoFrom").readOnly = false;
					enableSearch("imgDocSeqNoFrom");
					$("txtDocSeqNoFrom").focus();
				},
				onCancel : function () {
					onLOV = false;
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranchCdFrom");
					onLOV = false;
				}
			});
		}
		
		function getGIACS051DocSeqNoLOV() {
			onLOV = true;
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS051DocSeqNoLOV",
					branchCdFrom : $("txtBranchCdFrom").value,
					docYear : $("txtDocumentYearFrom").value,
					docMm : $("txtDocumentMmFrom").value,
					//docSeqNo : removeLeadingZero($("txtDocSeqNoFrom").value),
					searchString : checkDocSeqNo == "" ? removeLeadingZero($("txtDocSeqNoFrom").value) : "",
					page : 1
				},
				title : "Valid Values for Document Sequence No.",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "docSeqNo",
					title : "Doc Seq No",
					width : '120px',
				}, {
					id : "particulars",
					title : "Particulars",
					width : '345px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText:  checkDocSeqNo == "" ? removeLeadingZero($("txtDocSeqNoFrom").value) : "",
				onSelect : function(row) {
					onLOV = false;
					$("txtDocSeqNoFrom").value = formatNumberDigits(row.docSeqNo, 6);
					checkDocSeqNo = formatNumberDigits(row.docSeqNo, 6);
					$("txtTranDate").value = dateFormat(row.tranDate, 'mm-dd-yyyy');
					enableDate("imgTranDate");
					$("txtDocumentYearTo").value = $("txtDocumentYearFrom").value;
					$("txtDocumentMmTo").value = $("txtDocumentMmFrom").value;
					$("txtBranchCdTo").focus();
					enableButton("btnCopy");
					
					objGIACS051.row = row;
				},
				onCancel : function () {
					onLOV = false;
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranchCdFrom");
					onLOV = false;
				}
			});
		}
		
		function getGIACS051BranchCdToLOV() {
			onLOV = true;
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS051BranchCdToLOV",
					searchString : checkBranchTo == "" ? $("txtBranchCdTo").value : "",
					page : 1
				},
				title : "List of Branch Code",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "issCd",
					title : "Branch Code",
					width : '120px',
				}, {
					id : "issName",
					title : "Branch Name",
					width : '345px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText:  checkBranchTo == "" ? $("txtBranchCdTo").value : "",
				onSelect : function(row) {
					onLOV = false;
					$("txtBranchCdTo").value = row.issCd;
					checkBranchTo = row.issCd;
				},
				onCancel : function () {
					onLOV = false;
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranchCdFrom");
					onLOV = false;
				}
			});
		}
		
		function giacs051CheckCreateTransaction(){
			var tranDate = $("txtTranDate").value;
			var branchTo = $("txtBranchCdTo").value;
			var tag = "";
			new Ajax.Request(contextPath+"/GIACCopyJVController",{
				method: "POST",
				parameters: {
						     action : "giacs051CheckCreateTransaction",
						     tranDate : tranDate,
						     branchTo : branchTo
				},
				asynchronous: false,
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						tag = response.responseText;
					}
				}
			});
			
			return tag;
		}
		
		function copyJV() {
			var tranDate = $("txtTranDate").value.split("-");
			var month = getMonthWordEquivalent(parseInt(removeLeadingZero(tranDate[0])) - 1);
			var year = tranDate[2];
			var tag = trim(giacs051CheckCreateTransaction());
			
			if(tag == "Y") {
				showMessageBox("You are no longer allowed to create a transaction for " + month + " " + year + ". This transaction is already closed.", "E");
			} else if (tag == "T") {
				showMessageBox("You are no longer allowed to create a transaction for " + month + " " + year + ". This transaction is temporarily closed.", "E");
			} else {
				
				var branchTo = $("txtBranchCdTo").value;
				var tranDateFrom = $("txtTranDate").value;
				var docYearFrom = $("txtDocumentYearFrom").value;
				var docMmFrom = removeLeadingZero($("txtDocumentMmFrom").value);
				var docSeqNoFrom = removeLeadingZero($("txtDocSeqNoFrom").value);
				var branchFrom = $("txtBranchCdFrom").value;
				var docYearTo = $("txtDocumentYearTo").value;
				var docMmTo = removeLeadingZero($("txtDocumentMmTo").value);
				
				new Ajax.Request(contextPath+"/GIACCopyJVController",{
					method: "POST",
					parameters: {
							     action : "giacs051CopyJV",
							     fundCdFrom : objGIACS051.row.gfunFundCd,
							     branchTo : branchTo,
							     tranDateFrom : tranDateFrom,
							     docYearFrom : docYearFrom,
							     docMmFrom : docMmFrom,
							     docSeqNoFrom : docSeqNoFrom,
							     branchFrom : branchFrom,
							     docYearTo : docYearTo,
							     docMmTo : docMmTo,
							     tranIdFrom : objGIACS051.row.tranId
					},
					asynchronous: false,
					onCreate : showNotice("Copying Journal Voucher.."),
					onComplete : function(response){
						hideNotice();
						if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
							var res = response.responseText.split("#"); // bonok :: 10.10.2014 :: start
							objGIACS051.newTranNo = res[0].trim();
							objGIACS051.row.tranId = res[1].trim();
							// bonok :: 10.10.2014 :: end
							//objGIACS051.newTranNo = response.responseText;
							objGIACS051.oldTranNo = branchFrom + " - " + docYearFrom + " - " + formatNumberDigits(docMmFrom, 6) + " - " + formatNumberDigits(docSeqNoFrom, 6);
						}
					}
				});
				showNewTransactionNo();
			}
		}
		
		function validateField(action) {
			var ajaxResponse = "";
			var branchFrom = $("txtBranchCdFrom").value;
			var docYearFrom = $("txtDocumentYearFrom").value;
			var docMmFrom = removeLeadingZero($("txtDocumentMmFrom").value);
			var docSeqNoFrom = removeLeadingZero($("txtDocSeqNoFrom").value);
			var branchTo = $("txtBranchCdTo").value;
			
			new Ajax.Request(contextPath+"/GIACCopyJVController",{
				method: "POST",
				parameters: {
						     action : action,
						     branchFrom : branchFrom,
						     docYearFrom : docYearFrom,
						     docMmFrom : docMmFrom,
						     docSeqNoFrom : docSeqNoFrom,
						     branchTo : branchTo
				},
				asynchronous: false,
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						if(action == "giacs051ValidateDocSeqNo")
							ajaxResponse = JSON.parse(response.responseText);
						else
							ajaxResponse = trim(response.responseText);
					}
				}
			});
			
			return ajaxResponse;
		}
		
		function validateBranchCdFrom() {
			if($("txtBranchCdFrom").value == "")
				return;
			
			var check = validateField("giacs051ValidateBranchCdFrom");
			if(check == "ERROR"){
				customShowMessageBox("Please enter valid document branch code.", "E", "txtBranchCdFrom");
			} else {
				$("txtDocumentYearFrom").readOnly = false;
				enableSearch("imgDocumentYearFrom");
			}
		}
		
		function validateDocYearFrom() {
			if($("txtDocumentYearFrom").value == "")
				return;
			
			var check = validateField("giacs051ValidateDocYear");
			if(check == "ERROR"){
				customShowMessageBox("Please enter valid document year.", "E", "txtDocumentYearFrom");
			} else {
				$("txtDocumentMmFrom").readOnly = false;
			}
			
		}
		
		function validateDocMmFrom() {
			if($("txtDocumentMmFrom").value == "")
				return;
			
			var check = validateField("giacs051ValidateDocMm");
			if(check == "ERROR"){
				customShowMessageBox("Please enter valid document month.", "E", "txtDocumentMmFrom");
			} else {
				$("txtDocumentMmFrom").value = formatNumberDigits($("txtDocumentMmFrom").value, 2);
				$("txtDocSeqNoFrom").readOnly = false;
				enableSearch("imgDocSeqNoFrom");
				$("txtDocSeqNoFrom").focus();
			}
		}
		
		function showNewTransactionNo() {
			
			
			overlayNewTransactionNo = 
				Overlay.show(contextPath+"/GIACCopyJVController", {
					urlContent: true,
					urlParameters: {action : "showNewTransactionNo",																
									ajax : "1"
					},
				    title: "",
				    height: 174,
				    width: 320,
				    draggable: true
				});
		}
		
		$("txtDocumentYearFrom").observe("focus", validateBranchCdFrom);
		$("txtDocumentMmFrom").observe("focus", validateDocYearFrom);
		$("txtDocSeqNoFrom").observe("focus", validateDocMmFrom);
		
		$("txtDocSeqNoFrom").observe("change", function(){
			if(this.value != ""){
				var row = validateField("giacs051ValidateDocSeqNo");
				if(row.recCount == 0)
					customShowMessageBox("Please enter valid document sequence number.", "E", this.id);
				else if (row.recCount > 1) {
					$("imgDocSeqNoFrom").click();
				} else {
					$("txtDocSeqNoFrom").value = formatNumberDigits(row.docSeqNo, 6);
					$("txtTranDate").value = dateFormat(row.tranDate, 'mm-dd-yyyy');
					enableDate("imgTranDate");
					$("txtDocumentYearTo").value = $("txtDocumentYearFrom").value;
					$("txtDocumentMmTo").value = $("txtDocumentMmFrom").value;
					$("txtBranchCdTo").focus();
					//$("txtDocumentYearTo").readOnly = false;
					enableButton("btnCopy");
					
					objGIACS051.row = row;
				}
			}
		});
		
		$("txtBranchCdTo").observe("change", function(){
			if(this.value != ""){
				var check = validateField("giacs051ValidateBranchCdTo");
				if(check == "ERROR"){
					customShowMessageBox("Please enter valid document branch code.", "E", this.id);
				} else {
					var x = check.split("#");
					if(x[1] != "Y") {
						customShowMessageBox("You cannot copy a JV transaction to a branch that is not online.", "E", this.id);
					}
				}
			}
		});
		
		
		$("imgBranchCdFrom").observe("click", function(){
			if(onLOV)
				return;
			getGIACS051BranchCdFromLOV();
		});
		
		$("txtBranchCdFrom").observe("keypress", function(event) {
			if(event.keyCode == 13)
				$("imgBranchCdFrom").click();
		});
		
		$("imgDocumentYearFrom").observe("click", function(){
			if(onLOV)
				return;
			getGIACS051DocYearLOV();
		});
		
		$("txtDocumentYearFrom").observe("keypress", function(event) {
			if(event.keyCode == 13)
				$("imgDocumentYearFrom").click();
		});
		
		$("imgDocSeqNoFrom").observe("click", function(){
			if(onLOV)
				return;
			getGIACS051DocSeqNoLOV();
		});
		
		$("txtDocSeqNoFrom").observe("keypress", function(event) {
			if(event.keyCode == 13)
				$("imgDocSeqNoFrom").click();
		});
		
		$("imgBranchCdTo").observe("click", function(){
			if(onLOV)
				return;
			getGIACS051BranchCdToLOV();
		});
		
		$("txtBranchCdTo").observe("keypress", function(event) {
			if(event.keyCode == 13)
				$("imgBranchCdTo").click();
		});
		
		$("imgTranDate").observe("click", function(){
			scwShow($("txtTranDate"), this, null);	
		});
		
		$("btnCopy").observe("click", function(){
			if($("txtBranchCdTo").value == "")
				customShowMessageBox("Required fields must be entered.", "E", "txtBranchCdTo");
			else {
				var check = validateField("giacs051ValidateBranchCdTo");
				if(check == "ERROR"){
					customShowMessageBox("Please enter valid document branch code.", "E", "txtBranchCdTo");
				} else {
					var x = check.split("#");
					if(x[1] != "Y") {
						customShowMessageBox("You cannot copy a JV transaction to a branch that is not online.", "E", "txtBranchCdTo");
					} else {
						copyJV();
					}
				}
			}
		});
		
		
		
		function branchFromKeyPress(event){
			if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0 || event == "clear") {
				$("txtDocumentYearFrom").clear();
				$("txtDocumentYearFrom").readOnly = true;
				$("txtDocumentMmFrom").clear();
				$("txtDocumentMmFrom").readOnly = true;
				$("txtDocSeqNoFrom").clear();
				$("txtDocSeqNoFrom").readOnly = true;
				$("txtDocumentYearTo").clear();
				$("txtDocumentMmTo").clear();
				$("txtTranDate").clear();
				disableSearch("imgDocumentYearFrom");
				disableSearch("imgDocSeqNoFrom");
				disableDate("imgTranDate");
				$("imgTranDate").next().setStyle({margin : "1px 1px 0 0", cursor : "pointer"});
				disableButton("btnCopy");
				disableButton("btnEdit");
				objGIACS051 = new Object();
				enableSearch("imgBranchCdFrom");
				checkBranchFrom = "";
				checkDocYear = "";
				checkDocSeqNo = "";
			}
		}
		
		$("txtBranchCdFrom").observe("keypress", branchFromKeyPress);
		
		function docYearKeyPress(event){
			if($("txtDocumentYearFrom").readOnly)
				return;
			if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0 || event == "clear") {
				$("txtDocumentMmFrom").clear();
				$("txtDocumentMmFrom").readOnly = true;
				$("txtDocSeqNoFrom").clear();
				$("txtDocSeqNoFrom").readOnly = true;
				$("txtDocumentYearTo").clear();
				$("txtDocumentMmTo").clear();
				$("txtTranDate").clear();
				disableSearch("imgDocSeqNoFrom");
				disableDate("imgTranDate");
				$("imgTranDate").next().setStyle({margin : "1px 1px 0 0", cursor : "pointer"});
				disableButton("btnCopy");
				disableButton("btnEdit");
				objGIACS051 = new Object();
				enableSearch("imgDocumentYearFrom");
				checkDocYear = "";
				checkDocSeqNo = "";
			}
		}
		
		$("txtDocumentYearFrom").observe("keypress", docYearKeyPress);
		
		$("txtDocumentMmFrom").observe("keypress", function(event) {
			if(this.readOnly)
				return;
			if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0) {
				$("txtDocSeqNoFrom").clear();
				$("txtDocSeqNoFrom").readOnly = true;
				$("txtDocumentYearTo").clear();
				$("txtDocumentMmTo").clear();
				$("txtTranDate").clear();
				disableSearch("imgDocSeqNoFrom");
				disableDate("imgTranDate");
				$("imgTranDate").next().setStyle({margin : "1px 1px 0 0", cursor : "pointer"});
				disableButton("btnCopy");
				disableButton("btnEdit");
				objGIACS051 = new Object();
				checkDocSeqNo = "";
			}
		});
		
		function docSeqNoKeyPress(event){
			if($("txtDocSeqNoFrom").readOnly)
				return;
			if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0 || event == "clear") {
				$("txtDocumentYearTo").clear();
				$("txtDocumentMmTo").clear();
				$("txtTranDate").clear();
				disableDate("imgTranDate");
				$("imgTranDate").next().setStyle({margin : "1px 1px 0 0", cursor : "pointer"});
				disableButton("btnCopy");
				disableButton("btnEdit");
				objGIACS051 = new Object();
				enableSearch("imgDocSeqNoFrom");
				checkDocSeqNo = "";
			}
		}
		
		$("txtDocSeqNoFrom").observe("keypress", docSeqNoKeyPress);
		
		$("txtBranchCdTo").observe("keypress", function(event) {
			if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0) {
				disableButton("btnEdit");
				enableSearch("imgBranchCdTo");
				checkBranchTo = "";
			}
		});
		
		$("txtTranDate").observe("focus", function(){
			if(this.value == "")
				return;
			
			var tranDate = this.value.split("-");
			
			$("txtDocumentYearTo").value = tranDate[2];
			$("txtDocumentMmTo").value = tranDate[0];
		});
		
		$("btnEdit").observe("click", function(){
			objACGlobal.callingForm = "GIACS051";
			var tranId = objGIACS051.row.tranId;
			var fundCd = objGIACS051.row.gfunFundCd;
			//var branchCd = objGIACS051.row.gibrBranchCd;
			var branchCd = $F("txtBranchCdTo"); // bonok :: 10.10.2014
			showJournalListing("showJournalEntries","getJournalEntries","GIACS003", fundCd,branchCd,tranId,null);
		});
		
		$("acExit").stopObserving();
		
		$("acExit").observe("click", function(){
			delete objGIACS051;
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		});
		
		
		initializeAll();
		initGIACS051();
		
	} catch(e) {
		showErrorMessage("copyJV", e);
	}
</script>