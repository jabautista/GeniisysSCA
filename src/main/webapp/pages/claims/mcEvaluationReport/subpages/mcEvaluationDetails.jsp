
<div  class="sectionDiv" style="height: 400px;" changeTagAttr="true">
	<table align="" >
		<th>---Evaluation Summary---</th>
		<th>---Evaluation Other Details---</th>
		<tr>
			
			<td>
				<table style="width: 400px;">
					<tr> 
						<td class="rightAligned" >Parts: Gross Amt:</td>
						<td class="leftAligned">
							<input type="text" id="replaceGross" name="replaceGross" value="" style="width: 180px;" readonly="readonly" class="money">
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >Net Amt:</td>
						<td class="leftAligned">
							<input type="text" id="replaceAmt" name="replaceAmt" value=""  readonly="readonly" style="width: 180px; text-align: right;">
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >Labors & Materials: Gross Amt</td>
						<td class="leftAligned">
							<input type="text" id="repairGross" name="repairGross" value=""  readonly="readonly" style="width: 180px; text-align: right;">
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >Net Amt:</td>
						<td class="leftAligned">
							<input type="text" id="repairAmt" name="repairAmt" value=""  readonly="readonly" style="width: 180px; text-align: right;">
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >V.A.T.:</td>
						<td class="leftAligned">
							<input type="text" id="vat" name="vat" value=""  readonly="readonly" style="width: 180px; text-align: right;">
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >Total Estimated Repair Cost:</td>
						<td class="leftAligned">
							<input type="text" id="totErc" name="totErc" value=""  readonly="readonly" style="width: 180px; text-align: right;">
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >Loss: Deductible:</td>
						<td class="leftAligned">
							<input type="text" id="deductible" name="deductible" value=""  readonly="readonly" style="width: 180px; text-align: right;">
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >Depreciation:</td>
						<td class="leftAligned">
							<input type="text" id="depreciation" name="depreciation" value=""  readonly="readonly" style="width: 180px; text-align: right;">
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >Discount:</td>
						<td class="leftAligned">
							<input type="text" id="dspDiscount" name="dspDiscount" value=""  readonly="readonly" style="width: 180px; text-align: right;">
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >Insured's Net Participation:</td>
						<td class="leftAligned">
							<input type="text" id="totInp" name="totInp" value=""  readonly="readonly" style="width: 180px; text-align: right;">
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >Insurer's Net Liabilities:</td>
						<td class="leftAligned">
							<input type="text" id="totInl" name="totInl" value=""  readonly="readonly" style="width: 180px; text-align: right;">
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >Currency:</td>
						<td class="leftAligned">
							<input type="text" id="dspCurrShortname" name="dspCurrShortname" value=""  readonly="readonly" style="width: 50px; ">
							<input type="text" id="currencyRate" name="currencyRate" value=""  readonly="readonly" style="width: 118px; text-align: right;">
						</td>
					</tr>
				</table>
			</td>
			<td>
				<table style="width: 500px;">
					<tr>
						<td class="rightAligned" >Evaluation No.:</td>
						<td>
							<input type="text" id="detSublineCd" name="detSublineCd" value="" style="width: 59px; margin-left: 5px" readonly="readonly">
							<input type="text" id="detIssCd" name="detIssCd" value="" style="width: 43px;"  readonly="readonly">
							<input type="text" id="evalYy" name="evalYy" value="" style="width: 43px; text-align: right;"  readonly="readonly">
							<input type="text" id="evalSeqNo" name="evalSeqNo" value="" style="width: 64px; text-align: right;" readonly="readonly">
							<input type="text" id="evalVersion" name="evalVersion" value="" style="width: 43px; text-align: right;" readonly="readonly">
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >Claim Service Officer:</td>
						<td class="leftAligned">
							<input type="text" id="csoId" name="csoId" value=""  readonly="readonly" style="width: 301px;">
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >Evaluation Date:</td>
						<td class="leftAligned">
							<input type="text" id="evalDate" name="evalDate" value=""  readonly="readonly" style="width: 301px;">
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >Inspection Date:</td>
						<td class="leftAligned">
							<div style="float:left; border: solid 1px gray; width: 307px; height: 21px; " >
					    		<input style="width: 279px; border: none; height: 13px;" id="inspectDate" name="inspectDate" type="text" readonly="readonly" />
					    		<img id="hrefInspectDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('inspectDate'),this, null);" alt="Inspection Date" />
							</div>
							<!-- <input type="text" id="inspectDate" name="inspectDate" value=""  readonly="readonly" style="width: 301px;"> -->
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >Place Inspected:</td>
						<td class="leftAligned">
							<input type="text" id="inspectPlace" name="inspectPlace" value=""  readonly="readonly" style="width: 301px; " maxlength="100">
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >Adjuster:</td>
						<td class="leftAligned">
							<!-- <input type="text" id="dspAdjusterDesc" name="dspAdjusterDesc" value=""  readonly="readonly" style="width: 301px;">-->
							<div style="width: 307px; float: left;" class="withIconDiv">
								<input id="clmAdjId" name="" type="hidden" />
								<input type="text" id="dspAdjusterDesc" name="dspAdjusterDesc" value="" style="width: 278px;" class="withIcon "   readonly="readonly">
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="dspAdjusterDescIcon" name="dspAdjusterDescIcon" alt="Go" />
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >Third Party:</td>
						<td class="leftAligned">
							<input type="text" id="dspPayee" name="dspPayee" value=""  readonly="readonly" style="width: 301px;">
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >Report Status:</td>
						<td class="leftAligned">
							<input type="text" id="dspEvalDesc" name="dspEvalDesc" value=""  readonly="readonly" style="width: 301px;">
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >Report Type:</td>
						<td class="leftAligned">
							<input type="text" id="dspReportTypeDesc" name="dspReportTypeDesc" value=""  readonly="readonly" style="width: 301px;">
						</td>
					</tr>
					<tr >
						<td class="rightAligned" >Remarks:</td>
						<td class="leftAligned">
							<span id="particularsSpan" style="border: 1px solid gray; width: 307px; height: 21px; float: left;"> 
								<input type="text" id="remarks" name="remarks" style="border: none; float: left; width: 90%; background: transparent;" onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);"readonly="readonly"/> 
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" id="btnRemarks" name="btnRemarks" alt="Go" style="background: transparent;" />
							</span>
						</td>
					</tr>
					
				</table>
			</td>
		</tr>
	</table>

</div>


