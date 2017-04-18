<div id="dataCheckingMainDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Data Checking</label>
	   		<label id="reloadForm" style="float: right; cursor: pointer;" onclick="showDataChecking();">Reload Form</label>
	   	</div>
	</div>
	<div class="sectionDiv">
		<div style="width: 500px; margin: 10px auto;">
			<label style="float: none;">Booking Month / Year</label>
			<select id="selMonth" style="width: 120px;">
				<option value="1">January</option>
				<option value="2">February</option>
				<option value="3">March</option>
				<option value="4">April</option>
				<option value="5">May</option>
				<option value="6">June</option>
				<option value="7">July</option>
				<option value="8">August</option>
				<option value="9">September</option>
				<option value="10">October</option>
				<option value="11">November</option>
				<option value="12">December</option>
			</select>
			<select id="selYear"></select>
		</div>
	</div>
	<div class="sectionDiv" align="center">
		<div  style="padding: 10px;">
			<div>
				<div id="EOMCheckingScriptsTable" style="height: 295px; width: 800px; margin: 0 auto; "></div>
			</div>
		</div>
		<input type="button" class="button" id="btnTagAll" value="Untag All" style="margin: 15px;" />
		<input type="button" class="button" id="btnGenerateCSV" value="Generate CSV" style="margin: 15px;" />
	</div>
<script type="text/javascript">
	try {
		function initGIACS353() {
			setModuleId("GIACS353");
			setDocumentTitle("Data Checking");
			setDate();
		}
		
		function setDate() {
			var currentYear = getCurrentYear();
			var html = "";
			for (var i = currentYear; i >= currentYear - 15; i--) {
				html = html + "<option>" + i + "</option>";
			}
			
			$("selYear").update(html);
			var currentMonth = getCurrentDate();
			currentMonth = currentMonth.split('-');
			$("selMonth").value = removeLeadingZero(currentMonth[0]);
		}
		
		var jsonEOMCheckingScripts = JSON.parse('${jsonEOMCheckingScripts}');
		EOMCheckingScriptsTableModel = {
				url: contextPath+"/GIACDataCheckController?action=showDataChecking&refresh=1",
				options: {
					toolbar: {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
					},
					width: '800px',
					height: '275px',
					onCellFocus : function(element, value, x, y, id) {
						tbgEOMCheckingScripts.keys.removeFocus(tbgEOMCheckingScripts.keys._nCurrentFocus, true);
						tbgEOMCheckingScripts.keys.releaseKeys();
					},
					onRemoveRowFocus : function(element, value, x, y, id){
						tbgEOMCheckingScripts.keys.removeFocus(tbgEOMCheckingScripts.keys._nCurrentFocus, true);
						tbgEOMCheckingScripts.keys.releaseKeys();
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
						id : "writeTag",
						title: "Tag",
						width: '30px',					
						align : "center",
						editable: true,
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
						id : "eomScriptNo",
						title: "Script No.",
						width: '70px',
						align: 'right',
						titleAlign : 'right',
						filterOption : true,
						filterOptionType : 'number',
						renderer : function(val) {
							return formatNumberDigits(val, 3);
						}
					},
					{ //mikel 06.20.2016; GENQA 5544
						id : "checkBookDate",
						title: "JM",
						width: '30px',
						filterOption : false,
						visible : false,
						renderer : function(val) {
							return unescapeHTML2(val);
						}
					},
					{
						id : "eomScriptTitle",
						title: "End of Month Checking Script",
						width: '370px',
						filterOption : true,
						
						renderer : function(val) {
							return unescapeHTML2(val);
						}
					},
					{
						id : "eomScriptSoln",
						title: "Solution",
						width: '960px',
						filterOption : true,
						renderer : function(val) {
							return unescapeHTML2(val);
						}
					}
				],
				rows: jsonEOMCheckingScripts.rows
			};
		
		tbgEOMCheckingScripts = new MyTableGrid(EOMCheckingScriptsTableModel);
		tbgEOMCheckingScripts.pager = jsonEOMCheckingScripts;
		tbgEOMCheckingScripts.render('EOMCheckingScriptsTable');
		tbgEOMCheckingScripts.afterRender = function(){
			for(var i = 0; i < tbgEOMCheckingScripts.geniisysRows.length; i++) {
				$("mtgInput"+tbgEOMCheckingScripts._mtgId+"_2,"+i).checked = true;
			}	
		};
		
		function generateCSV() {
			var eomSripts = tbgEOMCheckingScripts.geniisysRows;
			var header = true;
			var check = false;
			var invalidScriptNo = "";
			
			var bookDate = " AND LAST_DAY (TO_DATE (INITCAP(multi_booking_mm) || '-' || multi_booking_yy, 'MM-YYYY')) <= " + "LAST_DAY (TO_DATE( '" 
							+ $("selMonth").options[$("selMonth").selectedIndex].text + "-" + $("selYear").value + "'))";
			var scriptType = "ALL";
			var moduleId = "GIACS353";
			patchRecords(selMonth, selYear, scriptType, moduleId); //mikel 06.20.2016; GENQA 5544
			
			for(var i = 0; i < eomSripts.length; i++) {
				showNotice("Generating CSV, please wait...");
				if($("mtgInput"+tbgEOMCheckingScripts._mtgId+"_2,"+i).checked == true) {
					if (nvl(eomSripts[i].checkBookDate, "N") == "Y") //mikel 06.20.2016; GENQA 5544
						var query = unescapeHTML2(eomSripts[i].eomScriptText1 + " " + nvl(eomSripts[i].eomScriptText2, "") + bookDate);
					else {
						var query = unescapeHTML2(eomSripts[i].eomScriptText1 + " " + nvl(eomSripts[i].eomScriptText2, ""));
					}
					//alert(query);
					var scriptNo = removeLeadingZero(eomSripts[i].eomScriptNo);
					var scriptTitle = unescapeHTML2(eomSripts[i].eomScriptTitle);
					var x = createCSV(scriptNo, scriptTitle, query, header);
					if(invalidScriptNo == "")
						invalidScriptNo = x;
					header = false;
					check = true;
				}
			}
			
			if(check) {
				copyFile();
				if(invalidScriptNo != "")
					showMessageBox("Cannot create CSV file for EOM Script No. " + invalidScriptNo + ". Kindly check the checking script or contact the administrator for assistance.", "E");
				else{
					if(message == "CSV Created.")
						showMessageBox("CSV Created.", "S");
					else
						showMessageBox(message, "E");
				}	
				message = "CSV Created.";
				filePaths = [];
				scriptLogPath = "";
			} else {
				showMessageBox("Please check script/s to generate.", "I");
			}
			closeConnection();
		}
		
		function getConnection() {
			new Ajax.Request(contextPath+"/GIACDataCheckController",{
				method: "POST",
				parameters: {
				     action : "getConnection"
				},
				evalScripts: false,
				asynchronous: false,
				onCreate: showNotice("Connecting to database..."),
				onComplete : function(response){
					//hideNotice();
				}
			});
		}
		
		var filePaths = [];
		var scriptLogPath;
		var dir;
		var message = "CSV Created.";
		var checkingScriptFilename = "";
		var uploadPath;
		
		function createCSV(scriptNo, scriptTitle, query, header){
			var invalidScriptNo = "";
			new Ajax.Request(contextPath+"/GIACDataCheckController",{
				method: "POST",
				parameters: {
				     action : "createCSV",
				     month : $("selMonth").options[$("selMonth").selectedIndex].text,
				     year : $("selYear").value,
				     scriptNo : scriptNo,
				     scriptTitle : scriptTitle,
				     query : query,
				     header : header,
				     checkingScriptFilename : checkingScriptFilename
				},
				evalScripts: false,
				asynchronous: false,
				onComplete : function(response){
					var info = response.responseText.split("@");
					var fileName = trim(info[0]);
					checkingScriptFilename = trim(info[1]);
					uploadPath = trim(info[2]);
					var stat = trim(info[3]);
					var path = trim(info[4]);
					
					if(info.length == 7)
						message = trim(info[6]);
					
					if(checkErrorOnResponse(response)) {
						if(stat == "SUCCESS") {
						} else {
							invalidScriptNo = scriptNo;
						}
					}
					var filePath = path + fileName;
					scriptLogPath = path + checkingScriptFilename;
					dir = path;
					
					if(info[5] > 1){
						filePaths.push(filePath);
					}
				}
			});
			
			return invalidScriptNo;
		}
		
		function copyFile(){
			var appletMessage;
			
			if($("geniisysAppletUtil") == null || $("geniisysAppletUtil").copyFileToLocal == undefined){
				showMessageBox("Local printer applet is not configured properly. Please verify if you have accepted to run the Geniisys Utility Applet and if the java plugin in your browser is enabled.", imgMessage.ERROR);
				return;
			} else {
				appletMessage = $("geniisysAppletUtil").copyFileToLocal(scriptLogPath, "csv");
				checkingScriptFilename = "";
				uploadPath = "";
				
				if(appletMessage.include("SUCCESS")){
					for(var x = 0; x < filePaths.length; x++){
						appletMessage = $("geniisysAppletUtil").copyFileToLocal(filePaths[x], "csv");
						if(!appletMessage.include("SUCCESS")){
							showMessageBox(appletMessage, "E");
							break;
						}
						deleteGeneratedFileFromServer(filePaths[x]);
					}
				} else {
					showMessageBox(appletMessage, "E");
				}
			}			
			
		}
		
		function deleteGeneratedFileFromServer(path){
			new Ajax.Request(contextPath + "/GIACDataCheckController", {
				parameters : {
					action : "deleteGeneratedFileFromServer",
					path : path
				}
			});
		}
		
		function closeConnection() {
			new Ajax.Request(contextPath+"/GIACDataCheckController",{
				method: "POST",
				parameters: {
				     action : "closeConnection",
				     url : dir + "csv\\"
				},
				evalScripts: false,
				asynchronous: false,
				onCreate: showNotice("Closing Database Connection..."),
				onComplete : function(response){
					//hideNotice();
				}
			});
		}
		
		//mikel 06.20.2016; GENQA 5544
		function patchRecords(month, year, scriptType, moduleId){
			new Ajax.Request(contextPath+"/GIACDataCheckController",{
				method: "POST",
				parameters: {
				     action : "patchRecords",
				     month : $("selMonth").options[$("selMonth").selectedIndex].text,
				     year : $("selYear").value,
				     scriptType : scriptType,
				     moduleId : moduleId
				},
				evalScripts: false,
				asynchronous: false,
				onCreate: hideNotice(),
				onComplete : function(response){
					hideNotice();
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					}
				}
			});
		}
		
		function unTagAll() {
			var eomSripts = tbgEOMCheckingScripts.geniisysRows;
			if ($("btnTagAll").value == "Tag All"){
				for(var i = 0; i < eomSripts.length; i++) {
						$("mtgInput"+tbgEOMCheckingScripts._mtgId+"_2,"+i).checked = true;
					}
				$("btnTagAll").value = "Untag All";
			} else {
				for(var i = 0; i < eomSripts.length; i++) {
					$("mtgInput"+tbgEOMCheckingScripts._mtgId+"_2,"+i).checked = false;
				}
				$("btnTagAll").value = "Tag All";
			}
		}
		
		$("btnTagAll").observe("click", unTagAll); //test end mikel
		
		$("btnGenerateCSV").observe("click", generateCSV);
		
		initializeAll();
		initGIACS353();
		
	} catch (e) {
		showErrorMessage("dataChecking", e);
	}
	
</script>