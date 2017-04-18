<div id="mainNav" name="mainNav">
	<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
		<ul>
			<li><a id="btnExit">Exit</a></li>
		</ul>
	</div>
</div>
<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
   		<label>View Binder List</label>
   		<span class="refreshers" style="margin-top: 0;">
 			<label id="btnReloadForm" name="gro" style="margin-left: 5px;">Reload Form</label>
		</span>
   	</div>
</div>
<div class="sectionDiv" style="margin-bottom: 50px;">
	<div style="padding: 10px 0 0 10px;">
		<div id="binderListTable" style="height: 310px; margin-left: auto; float: left;"></div>
		<div class="sectionDiv" style="float: right; margin-right: 10px; width: 135px; text-align: center; padding-top: 10px;">
			<span><b>Status</b></span>
			<table style="margin: 25px 0 12px 5px;">
				<tr>
					<td style="height: 35px; vertical-align: top;">
						<input type="radio" id="rdoAll" name="radioGroup" />
					</td>
					<td style="height: 35px; vertical-align: top;">
						<label style="margin-top: 3px;" for="rdoAll">All</label>
					</td>
				</tr>
				<tr>
					<td style="height: 35px; vertical-align: top;">
						<input type="radio" id="rdoConfirmed" name="radioGroup" />
					</td>
					<td style="height: 35px; vertical-align: top;"><label style="margin-top: 3px;" for="rdoConfirmed">Confirmed</label></td>
				</tr>
				<tr>
					<td valign="top">
						<input type="radio" id="rdoUnconfirmed" name="radioGroup" />
					</td>
					<td style="height: 35px; vertical-align: top;"><label style="margin-top: 3px;" for="rdoUnconfirmed">Unconfirmed / Released</label></td>
				</tr>
				<tr>
					<td style="height: 35px; vertical-align: top;">
						<input type="radio" id="rdoUnreleased" name="radioGroup" />
					</td>
					<td style="height: 35px; vertical-align: top;"><label style="margin-top: 3px;" for="rdoUnreleased">Unreleased</label></td>
				</tr>
				<tr>
					<td style="height: 35px; vertical-align: top;">
						<input type="radio" id="rdoReversed" name="radioGroup" />
					</td>
					<td style="height: 35px; vertical-align: top;"><label style="margin-top: 3px;" for="rdoReversed">Reversed</label></td>
				</tr>
				<tr>
					<td style="height: 35px; vertical-align: top;">
						<input type="radio" id="rdoReplaced" name="radioGroup" />
					</td>
					<td style="height: 35px; vertical-align: top;"><label style="margin-top: 3px;" for="rdoReplaced">Replaced</label></td>
				</tr>
			</table>
		</div>
	</div>
	<div class="sectionDiv" style="margin: 0 0 10px 10px; width: 900px; clear: both;">
		<table align="center" style="margin: 10px auto;">
			<tr>
				<td>
					<label style="float: right; margin-right: 5px;">Policy No.</label>
				</td>
				<td>
				      <input type="text" readonly="readonly" id="txtPolicyNo" style="width: 265px; margin-right: 20px;"/>
				</td>
				<td>
				      <label style="float: right; margin-right: 5px;">Assured Name</label>
				</td>
				<td>
				      <input type="text" readonly="readonly" id="txtAssdName" style="width: 265px;"/>
			    </td>
			</tr>
			<tr>
		    	<td>
	            	<label style="float: right; margin-right: 5px;">FRPS No.</label>
				</td>
				<td>
					<input type="text" readonly="readonly" id="txtFRPSNo" style="width: 265px;"/>
				</td>
				<td>
				    <label style="float: right; margin-right: 5px;">Ref. Binder No.</label>
				</td>
				<td>
					<input type="text" readonly="readonly" id="txtRefBinderNo" style="width: 265px;"/>
				</td>
			</tr>
			<tr>
	        	<td>
            		<label style="float: right; margin-right: 5px;">Confirm No.</label>
				</td>
				<td>
			    	<input type="text" readonly="readonly" id="txtConfirmNo" style="width: 265px;"/>
				</td>
				<td>
				    <label style="float: right; margin-right: 5px;">Confirm Date</label>
				</td>
				<td>
					<input type="text" readonly="readonly" id="txtConfirmDate" style="width: 265px;"/>
		        </td>
			</tr>
			<tr>
		    	<td>
			    	<label style="float: right; margin-right: 5px;">Release Date</label>
				</td>
				<td>
			    	<input type="text" readonly="readonly" id="txtReleaseDate" style="width: 265px;"/>
				</td>
				<td>
					<label style="float: right; margin-right: 5px;">Released By</label>
				</td>
				<td>
			    	<input type="text" readonly="readonly" id="txtReleasedBy" style="width: 265px;"/>
			    </td>
		    </tr>
		</table>
	</div>
</div>
<script type="text/javascript">
	try {
		
		function initGIUTS030() {
			setModuleId("GIUTS030");
			setDocumentTitle("View Binder List");
			$("rdoAll").checked = true;
		}
		
		function getBinderStatus(){
			var binderStat;
			
			if($("rdoAll").checked)
				binderStat = 6;
			else if($("rdoConfirmed").checked)
				binderStat = 1;
			else if($("rdoUnconfirmed").checked)
				binderStat = 2;
			else if($("rdoUnreleased").checked)
				binderStat = 3;
			else if($("rdoReversed").checked)
				binderStat = 4;
			else if($("rdoReplaced").checked)
				binderStat = 5;
			else
				binderStat = 6;
			
			return binderStat;
		}
		
		var jsonGIUTS030BinderList = JSON.parse('${jsonGIUTS030BinderList}');
		binderListTableModel = {
				url : contextPath+"/GIRIInpolbasController?action=showBinderList&refresh=1&moduleId=GIUTS030&status=" + getBinderStatus(),
				options: {
					toolbar: {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
					},
					width: '750px',
					height: '275px',
					hideColumnChildTitle : true,
					onCellFocus : function(element, value, x, y, id) {
						setDetails(tbgBinderList.geniisysRows[y]);					
						tbgBinderList.keys.removeFocus(tbgBinderList.keys._nCurrentFocus, true);
						tbgBinderList.keys.releaseKeys();
					},
					onRemoveRowFocus : function(element, value, x, y, id){					
						setDetails(null);
						tbgBinderList.keys.removeFocus(tbgBinderList.keys._nCurrentFocus, true);
						tbgBinderList.keys.releaseKeys();
					},
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
						id : "lineCd binderYy binderSeqNo",
						title: "Binder No.",
						children: [
							{
								id: "lineCd",
								title: "Line Cd",
								width: 30,
								filterOption: true
							},
							{
								id: "binderYy",
								title: "Binder YY",
								width: 30,
								align: "right",
								filterOption: true,
								filterOptionType: "integerNoNegative"
							},
							{
								id: "binderSeqNo",
								title: "Binder Seq No",
								width: 50,
								align: "right",
								renderer: function(val){
									return formatNumberDigits(val, 5);
								},
								filterOption: true,
								filterOptionType: "integerNoNegative"
								
							}
			            ]
					},
					{
						id : "riName",
						title: "Reinsurer",
						width: 159,
						renderer: function(val){
							return unescapeHTML2(val);
						},
						filterOption: true
					},
					{
						id : "binderDate",
						title: "Binder Date",
						width: 80,
						align : "center",
						titleAlign : "center",
						renderer: function(val){
							return val != "" ? dateFormat(val, "mm-dd-yyyy") : "";
						},
						filterOption: true,
						filterOptionType : "formattedDate"
					},
					{
						id : "reverseDate",
						title: "Reverse Date",
						width: 80,
						align : "center",
						titleAlign : "center",
						renderer: function(val){
							return val != "" ? dateFormat(val, "mm-dd-yyyy") : "";
						},
						filterOption: true,
						filterOptionType : "formattedDate"
					},
					{
						id : "riTsiAmt",
						title: "RI TSI Amt",
						width: 100,
						align : "right",
						titleAlign : "right",
						geniisysClass : "money",
						filterOption: true,
						filterOptionType: "number"
					},
					{
						id : "riPremAmt",
						title: "RI Prem Amt",
						width: 100,
						width: 100,
						align : "right",
						titleAlign : "right",
						geniisysClass : "money",
						filterOption: true,
						filterOptionType: "number"
					},
					{
						id : "bndrStatDesc",
						title: "Status",
						width: 80,
						renderer: function(val){
							return unescapeHTML2(val);
						},
						filterOption : true
					}
				],
				rows: jsonGIUTS030BinderList.rows
			};
		
		tbgBinderList = new MyTableGrid(binderListTableModel);
		tbgBinderList.pager = jsonGIUTS030BinderList;
		tbgBinderList.render('binderListTable');
		tbgBinderList.afterRender = function(){
			setDetails(null);
		};
		
		function setDetails(row){
			if(row != null) {
				$("txtPolicyNo").value = row.policyNo;
				$("txtAssdName").value = unescapeHTML2(row.assdName);
				$("txtFRPSNo").value = row.frpsNo;
				$("txtRefBinderNo").value = row.refBinderNo;
				$("txtConfirmNo").value = row.confirmNo;
				$("txtConfirmDate").value = row.confirmDate != null ? dateFormat(row.confirmDate, "mm-dd-yyyy") : "";
				$("txtReleaseDate").value = row.releaseDate != null ? dateFormat(row.releaseDate, "mm-dd-yyyy") : "";
				$("txtReleasedBy").value = unescapeHTML2(row.releasedBy);
			} else {
				$("txtPolicyNo").clear();
				$("txtAssdName").clear();
				$("txtFRPSNo").clear();
				$("txtRefBinderNo").clear();
				$("txtConfirmNo").clear();
				$("txtConfirmDate").clear();
				$("txtReleaseDate").clear();
				$("txtReleasedBy").clear();
			}
		}
		
		
		
		function changeBinderStatus(){			
			tbgBinderList.url = contextPath+"/GIRIInpolbasController?action=showBinderList&refresh=1&moduleId=GIUTS030&status=" + getBinderStatus();
			tbgBinderList._refreshList();
		}
		
		$$("input[type=radio]").each(function(obj){
			obj.observe("click", function(){
				if(this.checked)
					changeBinderStatus();
			});
		});
		
		$("btnExit").observe("click", function(){
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		});
		
		$("btnReloadForm").observe("click", showBinderList);
		
		initializeAll();
		initGIUTS030();
		
	} catch (e) {
		showErrorMessage("Error", e);
	}
</script>