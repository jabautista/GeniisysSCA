<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
	request.setAttribute("path", request.getContextPath());
%>

<div id=lineSublineMainDiv name="lineSublineMainDiv" style="margin-top: 1px;" >
	<form id="lineSublineForm" name="lineSublineForm">

		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>Line and Subline Coverages</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
				</span>
			</div>
		</div>
		
		<div id="lineSublineFormDiv" name="lineSublineFormDiv" class="sectionDiv"  align="center" >
			<div id="lineSublineInfoDiv" name=lineSublineInfoDiv style="margin: 10px; width: 450px;" changeTagAttr="true">
				<div class="tableHeader" id="lineSublineInfoTable" name="lineSublineInfoTable">
					<label style="width: 185px; text-align: left; margin-left: 10px;">Line</label>
					<label style="width: 230px; text-align: left; margin-left: 5px;">Subline</label>
					<!-- <label style="width: 130px; text-align: left; margin-left: 5px;">Remarks</label> -->
				</div>
				<input type="hidden" id="selectedRow" value=""/>
				<div class="tableContainer" id="lineSublineList" name="lineSublineList">
				</div>
			</div>
			
			<div id="lineSublineInfoFormDiv" name="lineSublineInfoFormDiv" style="width: 100%; margin: 10px 0px 5px 0px" >
				<table align="center" width="70%">
					<tr>
						<td class="rightAligned" width="20%">Line</td>
						<td class="leftAligned" width="80%">
							<input type="text" id="displayLine" readonly="readonly" class="required" style="width: 68%; display: none;" />
							<select id="packLineCdOpt" name="packLineCdOpt" style="width: 70%;" class="required">
								<option value=""></option>
							</select>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" width="20%">Subline</td>
						<td class="leftAligned" width="80%">
							<input type="text" id="displaySubline" readonly="readonly" class="required" style="width: 68%; display: none;" />
							<select id="packSublineCdOpt" name="packSublineCdOpt" style="width: 70%;" class="required">
								<option value=""></option>
								
							</select>
						</td>
					</tr>
				</table>				
			</div>		
			<div style="margin-bottom: 10px;" changeTagAttr="true">
				<input type="button" class="button" style="width: 60px;" id="btnAdd" name="btnAdd" value="Add" />
				<input type="button" class="button" style="width: 60px;" id="btnDelete" name="btnDelete" value="Delete"/>
			</div>	
		</div>
		
		<div class="buttonsDiv" id="infoButtonsDiv">
			<input type="button" class="button" style="width: 90px;" id="btnOk" name="btnOk" value="Ok" />
		</div>
		
	</form>
</div>
<script type="text/javascript">
/*  THIS JSP IS BASED ONE packLineSublineCoverages.jsp 
  	Create By Irwin Tabisora, 3.23.2011    
*/	disableButton("btnDelete");
	objLineSubline =  JSON.parse('${objLineSubline}'.replace(/\\/g, '\\\\'));
	//var objLineSublineItems = JSON.parse('${objLineSublineItems}'.replace(/\\/g, '\\\\'));
	objGIPIWPackLineSublineCreatePack = JSON.parse('${objLineSublineItems}'.replace(/\\/g, '\\\\'));
	$("btnOk").observe("click", function(){
		hasLineSubline = 'N';
		$$("div[name='rowLineSubline']").each(function (){
			hasLineSubline = 'Y';
		});
		Modalbox.hide();
	});
	setPackLineCd(objLineSubline);

	$("btnAdd").observe("click", validateLineSubline);
	$("btnDelete").observe("click", function(){
		deleteLineSubline();
	});
	showLineSublineItems();
	function showLineSublineItems(){
		try{
			var objItems;
			if(objGIPIWPackLineSublineCreatePack.size() == 0){
				hasLineSubline = 'N';
				objItems = objGIPIWPackLineSublineTemp;
			}else{
				objItems = objGIPIWPackLineSublineCreatePack;
			}
			for(var i =0;i<objItems.length ; i++){
				var parId = objItems[i].parId;
				var packParId = objItems[i].packParId;
				var packLineCd = objItems[i].packLineCd;
				var packLineName = objItems[i].packLineName;
				var packSublineCd = objItems[i].packSublineCd;
				var packSublineName = objItems[i].packSublineName;
				//var remarks 		= changeSingleAndDoubleQuotes2(nvl(objItems[i].remarks, "---"));
				var dspTag = objItems[i].dspTag;
				var newDiv 			= new Element("div");
				newDiv.setAttribute("id", "lineSublineItem"+packLineCd+packSublineCd);
				newDiv.setAttribute("name", "rowLineSubline");
				newDiv.addClassName("tableRow");
				newDiv.setStyle("display: none;");
				var content = '<input type="hidden" id="packLineCd'+packLineCd+packSublineCd+parId+'" name="packLineCd" value="'+packLineCd+'"/>'
					+'<input type="hidden" id="packLineName'+packLineCd+packSublineCd+parId+'" name="packLineName" value="'+packLineName+'"/>'
					+'<input type="hidden" id="packSublineCd'+packLineCd+packSublineCd+parId+'" name="packSublineCd" value="'+packSublineCd+'"/>'
					+'<input type="hidden" id="packSublineName'+packLineCd+packSublineCd+parId+'" name="packSublineName" value="'+packSublineName+'"/>'
					+'<input type="hidden" id="remarks'+packLineCd+packSublineCd+parId+'" name="remarks" value="'+changeSingleAndDoubleQuotes2(nvl(objItems[i].remarks,''))+'"/>'
					+'<input type="hidden" id="parId'+packLineCd+packSublineCd+parId+'" value="'+parId+'"/>'
					+'<input type="hidden" id="dspTag'+packLineCd+packSublineCd+parId+'" value="'+dspTag+'"/>'
					+'<input type="hidden" id="newRec'+packLineCd+packSublineCd+parId+'" value="N"/>'
					+'<label style="width: 180px; text-align: left; margin-left: 10px;" name="lineName" id="lineName">'+packLineCd+' - '+packLineName+'</label>'
					+'<label style="width: 225px; text-align: left; margin-left: 10px;" name="sublineText" >'+packSublineCd+' - '+packSublineName+'</label>';
				//	+'<label style="width: 225px; text-align: left; margin-left: 10px;" name="remarksText" id="remarksText'+packLineCd+packSublineCd+parId+'" >'+remarks+'</label>';
				newDiv.update(content);
				$("lineSublineList").insert({bottom: newDiv});
				Effect.Appear("lineSublineItem"+packLineCd+packSublineCd, {
					duration: .2,
					afterFinish: function () {
						checkTableIfEmptyinModalbox("rowLineSubline", "lineSublineInfoDiv");
						checkIfToResizeTable("lineSublineList", "rowLineSubline");
					}
				});
			}
		}catch(e){
			showMessageBox("ERROR addLineSubline. "+e);
		}	
	}

	function deleteLineSubline(){
		try{
			$$("div[name='rowLineSubline']").each(function (row)	{
				if (row.hasClassName("selectedRow"))	{
					var packLineCd = row.down("input", 0).value;
					var packSublineCd = row.down("input", 2).value;
					var parId = row.down("input", 5).value;
					var newRec = row.down("input", 7).value;
					if(newRec == 'Y'){
						for ( var i = 0; i < objGIPIWPackLineSublineTemp.length; i++) {
							if (objGIPIWPackLineSublineTemp[i].packLineCd == packLineCd && objGIPIWPackLineSublineTemp[i].packSublineCd == packSublineCd && objGIPIWPackLineSublineTemp[i].parId == parId){
								 if(objGIPIWPackLineSublineTemp[i].recordStatus == 0){
									 objGIPIWPackLineSublineTemp.splice(i, 1); //added second condition for newly-added record so no need to send object to database 
								}
							}	
						}
						
					}else{
						var objLineSublineItem = new Object();
						objLineSublineItem.packLineCd = packLineCd;
						objLineSublineItem.packSublineCd = packSublineCd;
						objLineSublineItem.parId = parId;
						objLineSublineItem.recordStatus = -1;
						objGIPIWPackLineSublineTemp.push(objLineSublineItem);
						changeTag =1;
					}
					

					Effect.Fade(row, {
						duration: .2,
						afterFinish: function ()	{
							row.remove();
							resetFields();
							checkTableIfEmptyinModalbox("rowLineSubline", "lineSublineInfoDiv");
							checkIfToResizeTable("lineSublineList", "rowLineSubline");
							$("btnAdd").value = "Add";
						}
					});
					
					enableButton("btnAdd") ;
					disableButton("btnDelete");
				}	
			});	
			
			
		}catch(e){
			showErrorMessage("deleteLineSubline", e);
		}
	}

	function addLineSubline(){
		try{
			//add
			var packLineCd = $F("packLineCdOpt");
			var packLineName = $("packLineCdOpt").options[$("packLineCdOpt").selectedIndex].getAttribute("lineName");
			var packSublineCd = $F("packSublineCdOpt");
			var packSublineName = $("packSublineCdOpt").options[$("packSublineCdOpt").selectedIndex].text;
			//var remarks 		= $F("remarks");
			var lineExist = false;
			var sublineExist = false;
			$$("input[name='packLineCd']").any(function(v){
				if(v.value == packLineCd){
					lineExist = true;
				}
			});
			$$("input[name='packSublineCd']").any(function(v){
				if(v.value == packSublineCd){
					sublineExist = true;
				}
			});
			if(lineExist && sublineExist){
				showMessageBox("Cannot create same record.");
				return false;
			}	
			changeTag =1;
			var objLineSublineItem = new Object();
			objLineSublineItem.packLineCd = packLineCd;
			objLineSublineItem.packLineName= escapeHTML2(packLineName);
			objLineSublineItem.packSublineCd = packSublineCd;
			objLineSublineItem.packSublineName = escapeHTML2(packSublineName);
		//	objLineSublineItem.remarks = remarks;
			objLineSublineItem.parId = '';
			objLineSublineItem.recordStatus	 = 0;
			//objLineSublineItems.push(objLineSublineItem); // main item list
			//dsp tag here
			objGIPIWPackLineSublineTemp.push(objLineSublineItem);
			
			//
			var parId = '';			
			var newDiv = new Element("div");
			newDiv.setAttribute("id", "lineSublineItem"+packLineCd+packSublineCd+parId);
			newDiv.setAttribute("name", "rowLineSubline");
			newDiv.addClassName("tableRow");
			newDiv.setStyle("display: none;");
			var content = '<input type="hidden" id="packLineCd'+packLineCd+packSublineCd+parId+'" name="packLineCd" value="'+packLineCd+'"/>'
				+'<input type="hidden" id="packLineName'+packLineCd+packSublineCd+parId+'" name="packLineName" value="'+packLineName+'"/>'
				+'<input type="hidden" id="packSublineCd'+packLineCd+packSublineCd+parId+'" name="packSublineCd" value="'+packSublineCd+'"/>'
				+'<input type="hidden" id="packSublineName'+packLineCd+packSublineCd+parId+'" name="packSublineName" value="'+packSublineName+'"/>'
				+'<input type="hidden" id="remarks'+packLineCd+packSublineCd+parId+'" name="remarks" value=""/>'
				+'<input type="hidden" id="parId'+packLineCd+packSublineCd+parId+'" name="parId" value=""/>'
				+'<input type="hidden" id="dspTag'+packLineCd+packSublineCd+parId+'" name="dspTag" value=""/>'
				+'<input type="hidden" id="newRec'+packLineCd+packSublineCd+parId+'" value="Y"/>'
				+'<label style="width: 180px; text-align: left; margin-left: 10px;" name="lineName" id="lineName">'+packLineCd+' - '+packLineName+'</label>'
				+'<label style="width: 225px; text-align: left; margin-left: 10px;" name="sublineText" >'+packSublineCd+' - '+packSublineName+'</label>';
				//+'<label style="width: 225px; text-align: left; margin-left: 10px;" name="remarksText" id="remarksText'+packLineCd+packSublineCd+parId+'">'+changeSingleAndDoubleQuotes2(nvl(remarks, "---"))+'</label>';
			newDiv.update(content);
			$("lineSublineList").insert({bottom: newDiv});
			
	
			newDiv.observe("mouseover", function ()	{
				newDiv.addClassName("lightblue");
			});
			
			newDiv.observe("mouseout", function ()	{
				newDiv.removeClassName("lightblue");
			});
	
			newDiv.observe("click", function(){
				newDiv.toggleClassName("selectedRow");
				if (newDiv.hasClassName("selectedRow")){
					$$("div[name='rowLineSubline']").each(function (r)	{
						if (newDiv.getAttribute("id") != r.getAttribute("id"))	{
							r.removeClassName("selectedRow");
						}
					});
					displayLineSublineItemInfo(true, newDiv);
				} else {
					displayLineSublineItemInfo(false, null);
				} 
			});
	
			Effect.Appear("lineSublineItem"+packLineCd+packSublineCd, {
				duration: .2,
				afterFinish: function () {
					//checkTableIfEmpty("rowLineSubline", "lineSublineInfoDiv");
					checkTableIfEmptyinModalbox("rowLineSubline", "lineSublineInfoDiv");
					checkIfToResizeTable("lineSublineList", "rowLineSubline");
					trimLabelTexts();
				}
			});
			resetFields();
		}catch(e){
			showErrorMessage("addLineSubline", e);
		}	

	}

	$("packLineCdOpt").observe("change", function(){
		setPackSublineCd(objLineSubline);
	});

	function validateLineSubline(){
		if ($F("btnAdd") == "Add"){
			if($F("packLineCdOpt") == ""){
				showMessageBox("Line is required.", imgMessage.ERROR);
				return false;
			}else if($F("packSublineCdOpt") == ""){
				showMessageBox("Subline is required.", imgMessage.ERROR);
				return false;
			}else{
				addLineSubline();
			}
		}else{
			addLineSubline();
		}	
	}

	function resetFields(){
		$("packLineCdOpt").selectedIndex = 0;
		$("displayLine").clear();
		$("displayLine").hide();
		$("packSublineCdOpt").selectedIndex = 0;
		$("displaySubline").clear();
		$("displaySubline").hide();
		$("packLineCdOpt").show();
		$("packSublineCdOpt").show();
		$("packSublineCdOpt").update("");
	}

	function displayLineSublineItemInfo(bool, row){
		try {
			if(!bool){
				resetFields();
				$("btnAdd").value = "Add";
				$("selectedRow").value = "";
			} else {
				var packLineCdOpt = $("packLineCdOpt");
				var packSublineCdOpt = $("packSublineCdOpt");
				var lineDisplay = row.down("input", 0).value+' - '+row.down("input", 1).value;
				var sublineDisplay = row.down("input", 2).value+' - '+row.down("input", 3).value;
				
				packLineCdOpt.hide();
				packSublineCdOpt.hide();
				$("displayLine").value = lineDisplay;
				$("displayLine").show();
				$("displaySubline").value = sublineDisplay;
				$("displaySubline").show();
			//	$("remarks").value = row.down("input",4).value;
			//	$("btnAdd").value = "Update";
				$("selectedRow").value = row.down("input", 0).value+row.down("input", 2).value+row.down("input", 5).value;// sets the selected row
			}
			(row == null ? enableButton("btnAdd") : disableButton("btnAdd"));
			(row == null ? disableButton("btnDelete") : enableButton("btnDelete"));
		} catch(e){
			showErrorMessage("displayLineSublineItemInfo", e);
		}
	}

	$$("div[name='rowLineSubline']").each(function (row){
		row.observe("click", function(){
			if (row.hasClassName("selectedRow")){
				displayLineSublineItemInfo(false, null);
			} else {
				displayLineSublineItemInfo(true, row);
			} 
		});
	});
	addStyleToInputs();
	initializeAll();
	initializeAccordion();
	initializeTable("tableContainer", "rowLineSubline", "", "");
	//checkTableIfEmpty("rowLineSubline", "lineSublineInfoDiv");
	checkTableIfEmptyinModalbox("rowLineSubline", "lineSublineInfoDiv");
	checkIfToResizeTable("lineSublineList", "rowLineSubline");
	trimLabelTexts();
</script>