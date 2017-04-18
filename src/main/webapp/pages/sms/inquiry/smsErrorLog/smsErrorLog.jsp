<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="mainNav" name="mainNav">
	<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
		<ul>
			<li><a id="menuExit">Exit</a></li>
		</ul>
	</div>
</div>
<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
   		<label>SMS Error Log</label>
   		<span class="refreshers" style="margin-top: 0;">
 			<label id="btnReloadForm" name="gro" style="margin-left: 5px;">Reload Form</label>
		</span>
   	</div>
</div>
<div class="sectionDiv" style="float: none; clear: both;">
	<div style="padding: 10px 0 10px 10px;">
		<div id="tableGridDiv" style="height: 300px; width: 700px; margin: auto;"></div>
	</div>
	<div style="text-align: center; margin-bottom: 10px;">
		<input type="button" id="btnAssign" value="Assign" class="button" style="width: 100px;"/>
		<input type="button" id="btnPurge" value="Purge" class="button" style="width: 100px;"/>
	</div>
</div>

<script type="text/javascript">
	try {
		
		$("mainNav").hide();
		setModuleId("GISMS008");
		setDocumentTitle("SMS Error Log");
		var selectedIndex = -1;
		
		var jsonTG = JSON.parse('${jsonTG}');
		SMSErrorLogTableModel = {
				url : contextPath + "/GISMMessagesReceivedController?refresh=1&action=showSMSErrorLog",
				options: {
					toolbar: {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
					},
					width: '700px',
					height: '275px',
					onCellFocus : function(element, value, x, y, id) {
						//setDetails(tbgSMSErrorLog.geniisysRows[y]);
						selectedIndex = y;
						enableButton("btnAssign");
						tbgSMSErrorLog.keys.removeFocus(tbgSMSErrorLog.keys._nCurrentFocus, true);
						tbgSMSErrorLog.keys.releaseKeys();
					},
					onRemoveRowFocus : function(element, value, x, y, id){					
						//setDetails(null);
						selectedIndex = -1;
						disableButton("btnAssign");
						tbgSMSErrorLog.keys.removeFocus(tbgSMSErrorLog.keys._nCurrentFocus, true);
						tbgSMSErrorLog.keys.releaseKeys();
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
						id : "purgeTag",
						altTitle : 'Purge',
						width: 30,
						align: "center",
						editable: true,
						defaultValue: false,
						sortable: false,
						editor:new MyTableGrid.CellCheckbox({getValueOf : function(value) {
							if (value){
								return"Y";
							}else{
								return"N";
							}
						}})
					},
					{
						id : "dateReceived",
						title: "Date Received",
						width: 120,
						align: "center",
						titleAlign: "center",
						filterOption : true,
						filterOptionType: "formattedDate",
						renderer: function(val){
							return val == "" ? "" : dateFormat(val, "mm-dd-yyyy");
						}
					},
					{
						id : "cellphoneNo",
						title: "Cellphone No.",
						width: 200,
						filterOption : true,
					},
					{
						id : "name",
						title: "Name",
						width: 319,
						filterOption : true/* ,
						renderer: function(val){
							return unescapeHTML2(val);
						} */
					}
					
				],
				rows: jsonTG.rows
			};
		
		tbgSMSErrorLog = new MyTableGrid(SMSErrorLogTableModel);
		tbgSMSErrorLog.pager = jsonTG;
		tbgSMSErrorLog.render('tableGridDiv');
		tbgSMSErrorLog.afterRender = function(){
			selectedIndex = -1;
			disableButton("btnAssign");
		};
		
		function assign(number){
			var row = tbgSMSErrorLog.geniisysRows[selectedIndex];
			new Ajax.Request(contextPath + "/GISMMessagesReceivedController",{
				method: "POST",
				parameters: {
						     action : "gisms008Assign",
						     number : number, //assdNo or intmNo
						     cellphoneNo : row.cellphoneNo,
						     keyword : row.keyword,
						     message : row.message,
						     classCd : row.classCd
				},
				asynchronous: false,
				onComplete : function(response){
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						tbgSMSErrorLog._refreshList();
						showMessageBox("Assigning successful.", "S");
					}
				}
			});
		}
		
		function getLOV(){
			
			var obj = tbgSMSErrorLog.geniisysRows[selectedIndex];
			var action = "";
			var noTitle = "";
			var nameTitle = "";
			var lovTitle = "";
			
			if(obj.classCd == "A"){
				action = "getGISMS008AssuredLOV";
				noTitle = "Assured No.";
				nameTitle = "Assured Name";
				lovTitle = "List of Assured";
			} else if (obj.classCd == "I") {
				action = "getGISMS008IntmLOV";
				noTitle = "Intermediary No.";
				nameTitle = "Intermediary Name";
				lovTitle = "List of Intermediaries";
			} else
				return;
			
			LOV.show({
				controller : "SmsLOVController",
				urlParameters : {
					action : action,
					gmrName : obj.name,
					page : 1,
				},
				title : lovTitle,
				width : 480,
				height : 386,
				columnModel : [ {
					id : "number",
					title : noTitle,
					width : '120px',
				}, {
					id : "name",
					title : nameTitle,
					width : '345px',
					renderer: function(value) {
						return unescapeHTML2(value);
					}
				} ],
				draggable : true,
				//autoSelectOneRecord: true,
				onSelect : function(row) {
					assign(row.number, obj.classCd == "A" ? "gisms008AssignAssured" : "gisms008AssignIntm");
				},
				onCancel : function () {
					
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", imgMessage.INFO);
				}
			});
		}
		
		$("btnAssign").observe("click", getLOV);
		
		function purge(){
			var rows = tbgSMSErrorLog.geniisysRows;
			var taggedRows = new Array();
			var obj = new Object();
			
			
			for(var x = 0; x < rows.length; x++){
				if($("mtgInput"+tbgSMSErrorLog._mtgId+"_2," + x).checked){
					taggedRows.push(rows[x]);
				}	
			}
			
			obj.rows = taggedRows;
			
			if(taggedRows.length == 0){
				showMessageBox("Please tag at least one record.", "I");
				return;
			}
			
			new Ajax.Request(contextPath + "/GISMMessagesReceivedController",{
				method: "POST",
				parameters: {
						     action : "gisms008Purge",
						     rows : JSON.stringify(obj)
				},
				asynchronous: false,
				onComplete : function(response){
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						tbgSMSErrorLog._refreshList();
						showMessageBox("Purging successful.", "S");
					}
				}
			});
				
		}
		
		$("btnPurge").observe("click", purge);
		
		function exit(){
			goToModule("/GIISUserController?action=goToSMS", "SMS Main", null);
		}
		
		$("menuExit").observe("click", exit);
		
		$("btnReloadForm").observe("click", function(){
			try{
				new Ajax.Request(contextPath + "/GISMMessagesReceivedController", {
					parameters : {
						action : "showSMSErrorLog"
					},
					onCreate : showNotice("Loading, please wait..."),
					onComplete : function(response){
						hideNotice();
						if(checkErrorOnResponse(response)){
							$("mainContents").update(response.responseText);
							
						}
					}
				});
			}catch(e){
				showErrorMessage("showSMSErrorLog",e);
			}
		});
		
		$("btnReloadForm").hide();
		
	} catch (e) {
		showErrorMessage("SMS Error Log", e);
	}
</script>