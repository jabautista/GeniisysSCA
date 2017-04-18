<div id="copyIntmRateMainDiv" style="width: 99.5%; margin-top: 5px;">
    <div class="sectionDiv">
		<table style="margin: 10px 10px 10px 84px;">
			<tr>
				<td class="rightAligned">Copy To</td>
				<td class="leftAligned">
					<span class="required lovSpan" style="float: left; width: 85px; margin: 2px 5px 0px 3px;">
						<input class="required integerNoNegativeUnformatted" type="text" id="txtIntmNo" name="headerField" style="width: 60px; float: left; border: none; height: 13px; margin: 0; text-align: right;" maxlength="12" tabindex="201" lastValidValue=""/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchTxtIntmNo" name="searchTxtIntmNo" alt="Go" style="float: right;"/>
					</span>
					<input id="txtIntmName" name="headerField" type="text" style="width: 275px; height: 15px;" readonly="readonly" tabindex="202"/>
				</td>
			</tr>
		</table>
    </div>
    
    <div class="sectionDiv">
    	<table style="margin: 10px auto;">
    		<tr>
    			<td class="rightAligned">Copy From</td>
    			<td>
    				<span class="required lovSpan" style="float: left; width: 85px; margin: 2px 5px 0px 3px;">
						<input class="required integerNoNegativeUnformatted" type="text" id="txtFromIntmNo" name="headerField" style="width: 60px; float: left; border: none; height: 13px; margin: 0; text-align: right;" maxlength="12" tabindex="203" lastValidValue=""/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchTxtFromIntmNo" name="searchTxtFromIntmNo" alt="Go" style="float: right;"/>
					</span>
					<input id="txtFromIntmName" name="headerField" type="text" style="width: 275px; height: 15px;" readonly="readonly" tabindex="204"/>
    			</td>
    		</tr>
    		<tr>
    			<td class="rightAligned">Issue Code</td>
    			<td>
    				<span class="lovSpan" style="float: left; width: 85px; margin: 2px 5px 0px 3px;">
						<input class="upper" type="text" id="txtIssCd" name="headerField" style="width: 60px; float: left; border: none; height: 13px; margin: 0;" maxlength="2" tabindex="205" lastValidValue=""/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchTxtIssCd" name="searchTxtIssCd" alt="Go" style="float: right;"/>
					</span>
					<input id="txtIssName" name="headerField" type="text" style="width: 275px; height: 15px;" readonly="readonly" value="ALL ISSUE SOURCE" tabindex="206"/>
    			</td>
    		</tr>
    		<tr>
    			<td class="rightAligned">Line Code</td>
    			<td>
    				<span class="lovSpan" style="float: left; width: 85px; margin: 2px 5px 0px 3px;">
						<input class="upper" type="text" id="txtLineCd" name="headerField" style="width: 60px; float: left; border: none; height: 13px; margin: 0;" maxlength="2" tabindex="207" lastValidValue=""/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchTxtLineCd" name="searchTxtLineCd" alt="Go" style="float: right;"/>
					</span>
					<input id="txtLineName" name="headerField" type="text" style="width: 275px; height: 15px;" readonly="readonly" value="ALL LINES" tabindex="208"/>
    			</td>
    		</tr>
    		<tr>
    			<td class="rightAligned">Subline Code</td>
    			<td>
    				<span class="lovSpan" style="float: left; width: 85px; margin: 2px 5px 0px 3px;">
						<input class="upper" type="text" id="txtSublineCd" name="headerField" style="width: 60px; float: left; border: none; height: 13px; margin: 0;" maxlength="7" tabindex="209" lastValidValue=""/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchTxtSublineCd" name="searchTxtSublineCd" alt="Go" style="float: right;"/>
					</span>
					<input id="txtSublineName" name="headerField" type="text" style="width: 275px; height: 15px;" readonly="readonly" value="ALL SUBLINES" tabindex="210"/>
    			</td>
    		</tr>
    	</table>
    </div>
    
    <div style="margin: 8px 0px 0px 200px; float: left;">
    	<input type="button" class="button" id="btnCopyIntm" value="Copy" tabindex="211">
		<input type="button" class="button" id="btnCancelIntm" value="Cancel" tabindex="212">
    </div>
</div>

<script type="text/javascript">
	function showIntmNoToLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {
					action: "getGiiss082IntmNoLOV",
					filterText: $F("txtIntmNo") != $("txtIntmNo").getAttribute("lastValidValue") ? nvl($F("txtIntmNo"), "%") : "%"
				},
				title: "List of Intermediaries",
				width: 425,
				height: 386,
				columnModel:[
								{	id: "intmNo",
									title: "Intm No",
									width: "100px",
									titleAlign: 'right',
									align: 'right'
								},
								{	id: "intmName",
									title: "Intm Name",
									width: "310px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText: $F("txtIntmNo") != $("txtIntmNo").getAttribute("lastValidValue") ? nvl($F("txtIntmNo"), "%") : "%",
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
					if(row != undefined) {
						$("txtIntmNo").value = row.intmNo;
						$("txtIntmName").value = unescapeHTML2(row.intmName);
						$("txtIntmNo").setAttribute("lastValidValue", row.intmNo);
					}
				},
				onCancel: function(){
					$("txtIntmNo").value = $("txtIntmNo").getAttribute("lastValidValue");
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("txtIntmNo").value = $("txtIntmNo").getAttribute("lastValidValue");
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showIntmNoToLOV", e);
		}
	}
	
	function showCopyIntmNoLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {
					action: "getCopyIntmLOV",
					filterText: $F("txtFromIntmNo") != $("txtFromIntmNo").getAttribute("lastValidValue") ? nvl($F("txtFromIntmNo"), "%") : "%"
				},
				title: "List of Intermediaries",
				width: 425,
				height: 386,
				columnModel:[
								{	id: "intmNo",
									title: "Intm No",
									width: "100px",
									titleAlign: 'right',
									align: 'right'
								},
								{	id: "intmName",
									title: "Intm Name",
									width: "310px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText: $F("txtFromIntmNo") != $("txtFromIntmNo").getAttribute("lastValidValue") ? nvl($F("txtFromIntmNo"), "%") : "%",
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
					if(row != undefined) {
						$("txtFromIntmNo").value = row.intmNo;
						$("txtFromIntmName").value = unescapeHTML2(row.intmName);
						$("txtFromIntmNo").setAttribute("lastValidValue", row.intmNo);
						
						$("txtIssCd").value = "";
						$("txtIssName").value = "ALL ISSUE SOURCE";
						$("txtIssCd").setAttribute("lastValidValue", "");
						
						$("txtLineCd").value = "";
						$("txtLineName").value = "ALL LINES";
						$("txtLineCd").setAttribute("lastValidValue", "");
						
						$("txtSublineCd").value = "";
						$("txtSublineName").value = "ALL SUBLINES";
						$("txtSublineCd").setAttribute("lastValidValue", "");
					}
				},
				onCancel: function(){
					$("txtFromIntmNo").value = $("txtFromIntmNo").getAttribute("lastValidValue");
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("txtFromIntmNo").value = $("txtFromIntmNo").getAttribute("lastValidValue");
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showCopyIntmNoLOV", e);
		}
	}
	
	function showCopyIssCdLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {
					action: "getCopyIssCdLOV",
					intmNo: $F("txtFromIntmNo"),
					filterText: $F("txtIssCd") != $("txtIssCd").getAttribute("lastValidValue") ? nvl($F("txtIssCd"), "%") : "%"
				},
				title: "List of Issue Sources",
				width: 365,
				height: 386,
				columnModel:[
								{	id: "issCd",
									title: "Issue Code",
									width: "100px"
								},
								{	id: "issName",
									title: "Issue Name",
									width: "250px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText: $F("txtIssCd") != $("txtIssCd").getAttribute("lastValidValue") ? nvl($F("txtIssCd"), "%") : "%",
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
					if(row != undefined) {
						$("txtIssCd").value = unescapeHTML2(row.issCd);
						$("txtIssName").value = unescapeHTML2(row.issName);
						$("txtIssCd").setAttribute("lastValidValue", unescapeHTML2(row.issCd));
						
						$("txtLineCd").value = "";
						$("txtLineName").value = "ALL LINES";
						$("txtLineCd").setAttribute("lastValidValue", "");
						
						$("txtSublineCd").value = "";
						$("txtSublineName").value = "ALL SUBLINES";
						$("txtSublineCd").setAttribute("lastValidValue", "");
					}
				},
				onCancel: function(){
					$("txtIssCd").value = $("txtIssCd").getAttribute("lastValidValue");
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("txtIssCd").value = $("txtIssCd").getAttribute("lastValidValue");
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showCopyIssCdLOV", e);
		}
	}
	
	function showCopyLineCdLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {
					action: "getCopyLineCdLOV",
					intmNo: $F("txtFromIntmNo"),
					issCd: $F("txtIssCd"),
					filterText: $F("txtLineCd") != $("txtLineCd").getAttribute("lastValidValue") ? nvl($F("txtLineCd"), "%") : "%"
				},
				title: "List of Lines",
				width: 365,
				height: 386,
				columnModel:[
								{	id: "lineCd",
									title: "Line Code",
									width: "100px"
								},
								{	id: "lineName",
									title: "Line Name",
									width: "250px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText: $F("txtLineCd") != $("txtLineCd").getAttribute("lastValidValue") ? nvl($F("txtLineCd"), "%") : "%",
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
					if(row != undefined) {
						$("txtLineCd").value = unescapeHTML2(row.lineCd);
						$("txtLineName").value = unescapeHTML2(row.lineName);
						$("txtLineCd").setAttribute("lastValidValue", unescapeHTML2(row.lineCd));
						
						$("txtSublineCd").value = "";
						$("txtSublineName").value = "ALL SUBLINES";
						$("txtSublineCd").setAttribute("lastValidValue", "");
					}
				},
				onCancel: function(){
					$("txtLineCd").value = $("txtLineCd").getAttribute("lastValidValue");
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("txtLineCd").value = $("txtLineCd").getAttribute("lastValidValue");
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showCopyLineCdLOV", e);
		}
	}
	
	function showCopySublineCdLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {
					action: "getCopySublineCdLOV",
					intmNo: $F("txtFromIntmNo"),
					issCd: $F("txtIssCd"),
					lineCd: $F("txtLineCd"),
					filterText: $F("txtSublineCd") != $("txtSublineCd").getAttribute("lastValidValue") ? nvl($F("txtSublineCd"), "%") : "%"
				},
				title: "List of Sublines",
				width: 365,
				height: 386,
				columnModel:[
								{	id: "sublineCd",
									title: "Subline Code",
									width: "100px"
								},
								{	id: "sublineName",
									title: "Subline Name",
									width: "250px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText: $F("txtSublineCd") != $("txtSublineCd").getAttribute("lastValidValue") ? nvl($F("txtSublineCd"), "%") : "%",
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
					if(row != undefined) {
						$("txtSublineCd").value = unescapeHTML2(row.sublineCd);
						$("txtSublineName").value = unescapeHTML2(row.sublineName);
						$("txtSublineCd").setAttribute("lastValidValue", unescapeHTML2(row.sublineCd));
					}
				},
				onCancel: function(){
					$("txtSublineCd").value = $("txtSublineCd").getAttribute("lastValidValue");
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("txtSublineCd").value = $("txtSublineCd").getAttribute("lastValidValue");
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showCopySublineCdLOV", e);
		}
	}
	
	function copyIntm(){
		if(checkAllRequiredFieldsInDiv("copyIntmRateMainDiv")){
			new Ajax.Request(contextPath+"/GIISIntmSpecialRateController", {
				method: "POST",
				parameters: {
					action: "copyIntmRate",
					intmNoTo: $F("txtIntmNo"),
					intmNoFrom: $F("txtFromIntmNo"),
					lineCd: $F("txtLineCd"),
					issCd: $F("txtIssCd"),
					sublineCd: $F("txtSublineCd")
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){
							closeCopyOverlay();
							commRateTG._refreshList();
							if(nvl(commRateTG.pager.perilList, "") == ""){
								perilList = [];
							}else{
								perilList = commRateTG.pager.perilList.toString().split(",");
							}
						});
					}
				}
			});
		}
	}
	
	function closeCopyOverlay(){
		copyOverlay.close();
		delete copyOverlay;
	}
	
	$("txtIntmNo").observe("change", function(){
		if($F("txtIntmNo") != "" && (isNaN($F("txtIntmNo")) || parseInt($F("txtIntmNo")) < 1  || $F("txtIntmNo").include("."))){
			showWaitingMessageBox("Invalid Intermediary No. Valid value should be from 1 to 999999999999.", "E", function(){
				$("txtIntmNo").value = $("txtIntmNo").getAttribute("lastValidValue");
				$("txtIntmNo").focus();
			});
		}else if($F("txtIntmNo") == ""){
			$("txtIntmNo").setAttribute("lastValidValue", "");
			$("txtIntmName").value = "";
		}else{
			showIntmNoToLOV();
		}
	});
	
	$("txtFromIntmNo").observe("change", function(){
		if($F("txtFromIntmNo") != "" && (isNaN($F("txtFromIntmNo")) || parseInt($F("txtFromIntmNo")) < 1  || $F("txtFromIntmNo").include("."))){
			showWaitingMessageBox("Invalid Intermediary No. Valid value should be from 1 to 999999999999.", "E", function(){
				$("txtFromIntmNo").value = $("txtFromIntmNo").getAttribute("lastValidValue");
				$("txtFromIntmNo").focus();
			});
		}else if($F("txtFromIntmNo") == ""){
			$("txtFromIntmNo").setAttribute("lastValidValue", "");
			$("txtFromIntmName").value = "";
		}else{
			showCopyIntmNoLOV();
		}
	});
	
	$("txtIssCd").observe("change", function(){
		if($F("txtIssCd") == ""){
			$("txtIssCd").setAttribute("lastValidValue", "");
			$("txtIssName").value = "ALL ISSUE SOURCE";
		}else{
			showCopyIssCdLOV();
		}
	});
	
	$("txtLineCd").observe("change", function(){
		if($F("txtLineCd") == ""){
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").value = "ALL LINES";
			
			$("txtSublineCd").value = "";
			$("txtSublineCd").setAttribute("lastValidValue", "");
			$("txtSublineName").value = "ALL SUBLINES";
		}else{
			showCopyLineCdLOV();
		}
	});
	
	$("txtSublineCd").observe("change", function(){
		if($F("txtSublineCd") == ""){
			$("txtSublineCd").setAttribute("lastValidValue", "");
			$("txtSublineName").value = "ALL SUBLINES";
		}else{
			showCopySublineCdLOV();
		}
	});
	
	$("searchTxtIntmNo").observe("click", showIntmNoToLOV);
	$("searchTxtFromIntmNo").observe("click", showCopyIntmNoLOV);
	$("searchTxtIssCd").observe("click", showCopyIssCdLOV);
	$("searchTxtLineCd").observe("click", showCopyLineCdLOV);
	$("searchTxtSublineCd").observe("click", showCopySublineCdLOV);
	$("btnCancelIntm").observe("click", closeCopyOverlay);
	$("btnCopyIntm").observe("click", copyIntm);
	
	initializeAll();
	makeInputFieldUpperCase();
	$("txtIntmNo").focus();
</script>