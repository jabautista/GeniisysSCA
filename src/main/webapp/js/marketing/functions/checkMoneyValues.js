function checkMoneyValues(){
	$$("input[type='text'].discountAmt").each(function (m) {
		m.observe("blur", function ()	{
			if (formatCurrency(m.value) < 0 ||  isNaN(m.value) || (m.value).blank()) {
				showMessageBox("Invalid Discount Amount. Value should be greater than 0.00 but not greater than Net Premium Amount.", imgMessage.ERROR);
				m.value = 0;
			}
			m.value = formatCurrency(m.value);
			m.focus();
		});
	});	
	$$("input[type='text'].surchargeAmt").each(function (m) {
		m.observe("blur", function ()	{
			if (formatCurrency(m.value) < 0 ||  isNaN(m.value) || (m.value).blank()) {
				showMessageBox("Invalid Surcharge Amount. Value should be greater than 0.00 but should not result to a Net Premium Amount greater than TSI Amount.", imgMessage.ERROR);
				m.value = 0;
			}
			m.value = formatCurrency(m.value);
			m.focus();
			
		});
	});	
	$$("input[type='text'].discountRt").each(function (m) {
		m.observe("blur", function ()	{
			if (formatRate(m.value) < 0 ||  isNaN(m.value) || (m.value).blank() || formatRate(m.value) > 100 ) {
				customShowMessageBox("Invalid Discount Rate. Value should be from 0.0000 to 100.0000.", imgMessage.ERROR, m);
				//m.value = 0;
			}
			m.value = formatRate(m.value == "" ? 0 : m.value);
			m.focus();
			
		});
	});	
	$$("input[type='text'].surchargeRt").each(function (m) {
		m.observe("blur", function ()	{
			if (formatRate(m.value) < 0 ||  isNaN(m.value) || (m.value).blank() || formatRate(m.value) > 100 ) {
				customShowMessageBox("Invalid Surcharge Rate. Value should be from 0.0000 to 100.0000.", imgMessage.ERROR, m);
				//m.value = 0;
			}
			m.value = formatRate(m.value == "" ? 0 : m.value);
			m.focus();
	
		});
	});	
}