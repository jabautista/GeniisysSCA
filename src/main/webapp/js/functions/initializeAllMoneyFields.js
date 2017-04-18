// initialize all fields or labels with class=money
function initializeAllMoneyFields() {
	$$("input[type='text'].money, input[type='hidden'].money").each(function (m) {
		m.observe("focus", function ()	{
			m.select();
			m.value = (m.value).replace(/,/g, "");
		});

		m.observe("blur", function ()	{
			/*
			if (isNaN(m.value.replace(/,/g, "")) || m.value.blank() ){ //|| formatCurrency(m.value) < 0) { //nok - comment ko ito..nag e-error hindi na nya mabasa ung ibang trigger kasi dito palang naka blank na.tanong nyo sakin kung ibabalik nio
				m.value = "";
			}
			m.value = (m.value == "" ? "" :formatCurrency(m.value));
			*/
			//start - added by Nok 
			if (isNaN(parseFloat(m.value.replace(/,/g, "") * 1))){
				m.value = "";
				if (m.getAttribute("errorMsg")){
					showMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR);
					return false;
				}
			}else{
				if (m.getAttribute("min")){
					if (parseFloat(m.value.replace(/,/g, "")) < parseFloat(m.getAttribute("min"))){
						m.value = "";
						if (m.getAttribute("errorMsg")){
							showMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR);
							return false;
						}
					}	
				}
				if (m.getAttribute("max")){
					if (parseFloat(m.value.replace(/,/g, "")) > parseFloat(m.getAttribute("max"))){
						m.value = "";
						if (m.getAttribute("errorMsg")){
							showMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR);
							return false;
						}
					}
				}
				m.value = (m.value == "" ? "" :formatCurrency(m.value));
			}
			//end - added by Nok
		});		
		
		m.observe("keyup", function () {
			m.value = m.value.strip();			
		});
	
		m.value = (m.value == "" ? "" :formatCurrency(m.value));
	});
	
	/*	Modified by		: mark jm
	 * 	Date Modified	: 08.23.2010
	 * 	Description		: to restrict input in money fields
	 */
	$$("input[type='text'].money2, input[type='hidden'].money2").each(function (m){
		var previousValue = "";
		m.observe("focus", function(){
			m.select();
			m.value = (m.value).replace(/,/g, "");
			previousValue = m.value;
		});
		
		m.observe("blur", function(){
			
			if(isNaN(m.value.replace(/,/g, "") || m.value.blank())){
				m.value = "";
			}else{				
				if(parseFloat(m.value.replace(/,/g, "")) < parseFloat(m.getAttribute("min")) || parseFloat(m.value.replace(/,/g, "")) > parseFloat(m.getAttribute("max"))){				
					//m.value = "";					
					customShowMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR, m.id);	
					m.value = previousValue;
				}
			}
			m.value = (m.value == "" ? "" : addSeparatorToNumber(removeLeadingZero(m.value), ",")); 
		});
		
		m.observe("keyup", function(e){
			m.value = m.value.strip().replace(/,/g, "");
			
			if(m.value != "." && isNaN(m.value)){	//added exception for period : shan 11.25.2014
				m.value = m.value.substr(0, m.value.length - 1);
				return false;
			}else{
				return true;				
			}
		});
		
		m.value = (m.value == "" ? "" : formatCurrency(m.value)); 
	});	
	
	/*	Modified by		: steven 
	 * 	Date Modified	: 11.06.2013
	 * 	Description		: to restrict input in money fields,allows positive/negative value depending on the "min" attribute
	 */
	$$("input[type='text'].money4, input[type='hidden'].money4").each(function (m){
		var previousValue = "";
		m.observe("focus", function(){
			m.select();
			m.value = (m.value).replace(/,/g, "");
			previousValue = m.value;
		});
		m.observe("keyup", function(e){
			m.value = m.value.strip().replace(/,/g, "");
			if (parseFloat(m.getAttribute("min")) < 0 && (e.keyCode == 109 && m.value.length == 1)){
				return true;
			} else{	
				for(i=0;i<1;){
					if (isNaN(parseInt(m.value * 1))) { 
						m.value = m.value.substring(m.value.length-1,"");
					} else{
						i++;
					}	
				}
			}
		});
		m.observe("blur", function(){
			if(isNaN(m.value.replace(/,/g, "") || m.value.blank())){
				m.value = "";
			}else{				
				if(parseFloat(m.value.replace(/,/g, "")) < parseFloat(m.getAttribute("min")) || parseFloat(m.value.replace(/,/g, "")) > parseFloat(m.getAttribute("max"))){				
					//m.value = "";					
					showWaitingMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR, function() {
						m.value = previousValue;
						m.focus();
					});					
				}
			}
			m.value = (m.value == "" ? "" : addSeparatorToNumber(removeLeadingZero(m.value), ",")); 
			m.value = (m.value == "" ? "" : formatCurrency(m.value)); 
		});
		m.value = (m.value == "" ? "" : formatCurrency(m.value)); 
	});	
	
	$$("input[type='text'].moneyRate, input[type='hidden'].moneyRate").each(function (m) {
		m.observe("focus", function ()	{
			m.select();
			m.value = (m.value).replace(/,/g, "");
		});

		m.observe("blur", function(){
			if (formatCurrency(m.value)<0||isNaN(m.value)||m.value.blank()) {
				m.value = "";
			}
			m.value = m.value == "" ? "" :formatToNineDecimal(m.value);
		});

		m.observe("keyup", function () {
			m.value = m.value.strip();
		});
		
		m.value = (m.value == "" ? "" :formatToNineDecimal(m.value));
	});
	
	/*	Modified by		: mark jm
	 * 	Date Modified	: 09.21.2010
	 * 	Description		: to restrict input in money/currency rate fields
	 */
	$$("input[type='text'].moneyRate2, input[type='hidden'].moneyRate2").each(function (m) {
		m.observe("focus", function ()	{
			m.select();
			m.value = (m.value).replace(/,/g, "");
		});
		
		if(m.blur.toString() == undefined){
			m.observe("blur", function(){
				if(isNaN(m.value.replace(/,/g, "")) || m.value.blank()){				
					m.value = "";
				}else{
					if(parseFloat(m.value) < parseFloat(m.getAttribute("min")) || parseFloat(m.value) > parseFloat(m.getAttribute("max"))){					
						customShowMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR, m.id);					
					}else{
						m.value = (m.value == "" ? "" : formatTo9DecimalNoParseFloat(m.value));
					}
				}			
			});
		}		

		m.observe("keyup", function () {
			m.value = m.value.strip().replace(/,/g, "");
			
			if(isNaN(m.value)){
				m.value = m.value.substr(0, m.value.length - 1);
				return false;
			}else{
				return true;				
			}
		});
		
		m.value = (m.value == "" ? "" : formatTo9DecimalNoParseFloat(m.value));
	});
	
	$$("input[type='text'].fourDeciRate, input[type='hidden'].fourDeciRate").each(function (m) {
		m.observe("focus", function(){
			m.select();
			m.value = (m.value).replace(/,/g, "");
		});

		m.observe("blur", function(){
			if (formatRate(m.value) < 0 ||  isNaN(m.value) || formatRate(m.value) > 100.0000) {
				showMessageBox("Invalid Rate. Value should be from 0.0000 to 100.0000", imgMessage.ERROR);
				m.value = 0;

			}
			m.value = formatRate(m.value);
			m.focus();
		});

		m.observe("keyup", function () {
			m.value = m.value.strip();
		});
		
		m.value = formatRate(m.value == "" ? "0" : m.value);
	});
	
	//added by Nok 01262011 for fourDeciRate2 class
	$$("input[type='text'].fourDeciRate2, input[type='hidden'].fourDeciRate2").each(function (m) {
		m.observe("focus", function ()	{
			m.select();
			m.value = (m.value).replace(/,/g, "");
		});
		m.observe("keyup", function ()	{
//			m.value = m.value.strip();
			//added by steven 10/5/2012; to delete the non-numeric characters
			m.value = m.value.strip().replace(/,/g, ""); 
			if(m.value != "." && isNaN(m.value)){	//added exception for period : shan 11.25.2014
				m.value = m.value.substr(0, m.value.length - 1);
				return false;
			}else{
				return true;				
			}
		});
		m.observe("blur", function (e)	{
			if (isNaN(parseFloat(m.value.replace(/,/g, "") * 1))) {
				m.value = "";
				if (m.getAttribute("errorMsg")){
					showMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR);
					return false;
				}
			}else{
				if (m.getAttribute("min")){
					if (parseFloat(m.value.replace(/,/g, "")) < parseFloat(m.getAttribute("min"))){
						m.value = "";
						if (m.getAttribute("errorMsg")){
							showMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR);
							return false;
						}
					}	
				}
				if (m.getAttribute("max")){
					if (parseFloat(m.value.replace(/,/g, "")) > parseFloat(m.getAttribute("max"))){
						m.value = "";
						if (m.getAttribute("errorMsg")){
							showMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR);
							return false;
						}
					}
				}
				m.value = (m.value == "" ? "" :formatRate(m.value.replace(/,/g, "")));
			}	
		});
		m.value = (m.value == "" ? "" :formatRate(m.value.replace(/,/g, "")));
	});
	
	//added by Nok 03162011 for rate using nth decimal class
	$$("input[type='text'].nthDecimal, input[type='hidden'].nthDecimal").each(function (m) {
		m.observe("focus", function(){
			m.select();
			m.value = (m.value).replace(/,/g, "");
		});
		m.observe("keyup", function(e){
			m.value = m.value.strip(); 
		});
		m.observe("blur", function(e){
			if (isNaN(parseFloat(m.value.replace(/,/g, "") * 1))){
				m.value = "";
				if (m.getAttribute("errorMsg")){
					showMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR);
					return false;
				}
			}else{
				if (m.getAttribute("min")){
					if (parseFloat(m.value.replace(/,/g, "")) < parseFloat(m.getAttribute("min"))){
						m.value = "";
						if (m.getAttribute("errorMsg")){
							showMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR);
							return false;
						}
					}	
				}
				if (m.getAttribute("max")){
					if (parseFloat(m.value.replace(/,/g, "")) > parseFloat(m.getAttribute("max"))){
						m.value = "";
						if (m.getAttribute("errorMsg")){
							showMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR);
							return false;
						}
					}
				}
				m.value = (m.value == "" ? "" :formatToNthDecimal(m.value.replace(/,/g, ""),(m.getAttribute("nthDecimal")?m.getAttribute("nthDecimal"):9)));
			}
		});
		m.value = (m.value == "" ? "" :formatToNthDecimal(m.value.replace(/,/g, ""),(m.getAttribute("nthDecimal")?m.getAttribute("nthDecimal"):9)));
	});
	//end - Nok
	//added by steven 04.02.2014; for rate standard
	$$("input[type='text'].nthDecimal2, input[type='hidden'].nthDecimal2").each(function (m) {
		var previousValue = ""; 
		m.observe("focus", function(){
			m.select();
			m.value = (m.value).replace(/,/g, "");
			previousValue = m.value;
		});
		m.observe("keyup", function(e){
			m.value = m.value.strip(); 
			if(isNaN(m.value)){
				m.value = m.value.substr(0, m.value.length - 1);
				return false;
			}else{
				return true;				
			}
		});
		m.observe("blur", function(e){
			if(isNaN(m.value.replace(/,/g, "") || m.value.blank())){
				m.value = "";
			}else{
				if(parseFloat(m.value.replace(/,/g, "")) < parseFloat(m.getAttribute("min")) || parseFloat(m.value.replace(/,/g, "")) > parseFloat(m.getAttribute("max"))){				
					showWaitingMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR, function() {
						m.value = previousValue;
						m.focus();
					});					
				}
			}
			m.value = (m.value == "" ? "" :formatToNthDecimal(m.value.replace(/,/g, ""),(m.getAttribute("nthDecimal")?m.getAttribute("nthDecimal"):9)));
		});
		m.value = (m.value == "" ? "" :formatToNthDecimal(m.value.replace(/,/g, ""),(m.getAttribute("nthDecimal")?m.getAttribute("nthDecimal"):9)));
	});
	
	$$("input[type='text'].percentRate, input[type='hidden'].percentRate").each(function (m) {
		m.observe("focus", function ()	{
			m.select();
		});

		m.observe("blur", function ()	{
			if (formatToNineDecimal(m.value) > 100.000000000 || formatToNineDecimal(m.value) < 0.000000000 || isNaN(m.value)) {
				if (m.getAttribute("message") == "new"){//added by steven
					showMessageBox("Entered Premium Rate is invalid. Valid value is from 0.000000000 to 100.000000000.", imgMessage.ERROR);
				}else{
					showMessageBox("Invalid Currency Rate. Value should be from 0.000000001 to 100.000000000", imgMessage.ERROR);
				}
				m.value = "0";
			}

			m.value = formatToNineDecimal(m.value);
			m.focus();
		});
		
		m.observe("keyup", function () {
			m.value = m.value.strip();
		});

		m.value = formatToNineDecimal(m.value == "" ? "0" : m.value);
	});
	
	// Same as above, except for the error message; "per
	$$("input[type='text'].nineDecimalPercentage, input[type='hidden'].nineDecimalPercentage").each(function (m) {
		m.observe("focus", function ()	{
			m.select();
		});

		m.observe("blur", function ()	{
			if (formatToNineDecimal(m.value) > 100.000000000 || formatToNineDecimal(m.value) < 0.000000000 || isNaN(m.value)) {
				showMessageBox("Invalid Rate. Value should be from 0.000000001 to 100.000000000", imgMessage.ERROR);
				m.value = "0";
			}

			m.value = formatToNineDecimal(m.value);
			m.focus();
		});
		
		m.observe("keyup", function () {
			m.value = m.value.strip();
		});

		m.value = formatToNineDecimal(m.value == "" ? "0" : m.value);
	});
	
	$$("input[type='text'].customRate, input[type='hidden'].customRate").each(function (m) {
		m.observe("focus", function ()	{
			m.select();
		});

		m.observe("blur", function ()	{
			if(parseFloat(m.value) < 0){
				showMessageBox($F("customRateErrorMessage"), imgMessage.ERROR);
				m.value = m.value*(-1);
			} else if (formatToNineDecimal(m.value) > 100.000000000 || formatToNineDecimal(m.value) < 0.000000000 || m.value == "") {
				showMessageBox($F("customRateErrorMessage"), imgMessage.ERROR);
				m.value = "0";
			}
			m.value = formatToNineDecimal(m.value);
			m.focus();
		});
		
		m.observe("keyup", function () {
			m.value = m.value.strip();
		});

		m.value = formatToNineDecimal(m.value == "" ? "0" : m.value);
	});
	
	$$("label.money").each(function (m) {		
		m.update((m.innerHTML == "" ? "" :formatCurrency(m.innerHTML)));
	});
	
	$$("label.moneyRate").each(function (m) {
		m.update(formatToNineDecimal(m.innerHTML));
	});
	
	/*	Created by		: Anthony Santos
	 * 	Date Created	: 01.5.2011
	 * 	Description		: To fix rounding of input. sample I input 999.999, the result is 1000.00;
	 */
	$$("input[type='text'].money3, input[type='hidden'].money3").each(function (m){
		m.observe("focus", function(){
			m.select();
			m.value = (m.value).replace(/,/g, "");
		});
		
		m.observe("blur", function(){
			if(isNaN(m.value.replace(/,/g, "") || m.value.blank())){
				m.value = "";
			}else{				
				if(parseFloat(m.value.replace(/,/g, "")) < parseFloat(m.getAttribute("min")) || parseFloat(m.value.replace(/,/g, "")) > parseFloat(m.getAttribute("max")) || getDecimalLength(m.value) > 2){				
					//m.value = "";					
					customShowMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR, m.id);					
				}
			}
			if (getDecimalLength(m.value) <= 2){
				m.value = (m.value == "" ? "" : formatCurrency(m.value)); 
			}
		});
		
		m.observe("keyup", function(e){
			m.value = m.value.strip().replace(/,/g, "");
			
			if(isNaN(m.value)){
				m.value = m.value.substr(0, m.value.length - 1);
				return false;
			}else{
				return true;				
			}
		});
		
		if (getDecimalLength(m.value) <= 2){
			m.value = (m.value == "" ? "" : formatCurrency(m.value)); 
		}
	});	
	/*
	$$("input[type='text'].moneyRate2, input[type='hidden'].moneyRate2").each(function (m) {
		m.observe("focus", function ()	{
			m.select();
			m.value = (m.value).replace(/,/g, "");
		});

		m.observe("blur", function(){			
			if(isNaN(m.value.replace(/,/g, "")) || m.value.blank()){				
				m.value = "";
			}else{
				if(parseFloat(m.value) < parseFloat(m.getAttribute("min")) || parseFloat(m.value) > parseFloat(m.getAttribute("max"))){					
					//customShowMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR, m.id);
					showWaitingMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR, function(){
						var currencyLOV = m.getAttribute("currencyLOV");
						var rateLOV = m.getAttribute("rateLOV");
						
						if(currencyLOV != null){
							$(m.id).value = formatToNineDecimal($(rateLOV).options[$(currencyLOV).selectedIndex].value);
						}
						
						$(m.id).focus();
					});
					return false;
				}else{
					m.value = (m.value == "" ? "" : formatTo9DecimalNoParseFloat(m.value));
				}
			}			
		});

		m.observe("keyup", function(){			
			 this.value = (this.value).match(RegExDecimal.positive.digit3.deci9)[0];
		});
		
		m.value = (m.value == "" ? "" : formatTo9DecimalNoParseFloat(m.value));
	});
	*/
	
	//added by steven 04.02.2014; for rate standard
	$$("input[type='text'].nthDecimal2, input[type='hidden'].nthDecimal2").each(function (m) {
		var previousValue = ""; 
		m.observe("focus", function(){
			m.select();
			m.value = (m.value).replace(/,/g, "");
			previousValue = m.value;
		});
		m.observe("keyup", function(e){
			m.value = m.value.strip(); 
			if(isNaN(m.value)){
				m.value = m.value.substr(0, m.value.length - 1);
				return false;
			}else{
				return true;				
			}
		});
		m.observe("blur", function(e){
			if(isNaN(m.value.replace(/,/g, "") || m.value.blank())){
				m.value = "";
			}else{
				if(parseFloat(m.value.replace(/,/g, "")) < parseFloat(m.getAttribute("min")) || parseFloat(m.value.replace(/,/g, "")) > parseFloat(m.getAttribute("max"))){				
					showWaitingMessageBox(m.getAttribute("errorMsg"), imgMessage.ERROR, function() {
						m.value = previousValue;
						m.focus();
					});					
				}
			}
			m.value = (m.value == "" ? "" :formatToNthDecimal(m.value.replace(/,/g, ""),(m.getAttribute("nthDecimal")?m.getAttribute("nthDecimal"):9)));
		});
		m.value = (m.value == "" ? "" :formatToNthDecimal(m.value.replace(/,/g, ""),(m.getAttribute("nthDecimal")?m.getAttribute("nthDecimal"):9)));
	});
}