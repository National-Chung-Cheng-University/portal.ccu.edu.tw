$(function(){
	//在表格標頭文字下產生篩選的下拉式選單
	GenerateFilterSelect();
	//下拉式選單事件綁定
	FilterSelectBind();
});

function GenerateFilterSelect(){
	//表格標頭列所有欄位
	var $ThColumns = $("table.pure-table-trading > thead > tr > th"); 
	//表格所有資料列
	var $TrDataRows = $("table.pure-table-trading > tbody > tr"); 
	//各欄位 DISTINCT 的資料儲存陣列
	var AllColumnDistinctDataArray = new Array($ThColumns.size());

	for(var ColumnIndex = 0;ColumnIndex < AllColumnDistinctDataArray.length;ColumnIndex++){
		AllColumnDistinctDataArray[ColumnIndex] = [];
		$.each($TrDataRows.find("td:eq(" + ColumnIndex + ")"),function(DataRowIndex,value){
			if($.inArray(value.innerText,AllColumnDistinctDataArray[ColumnIndex]) < 0){
				AllColumnDistinctDataArray[ColumnIndex].push(value.innerText);
			}
		});
	}
	
	var $ForCopySelect = $(document.createElement("Select"));
	var $ForCopyOption = $(document.createElement("Option"));
	
	$.each($ThColumns,function(indexThTd,valueThTd){
		var $CurrentSelect = $ForCopySelect.clone();
		var $CurrentOption = $ForCopyOption.clone();
		//預設有「全部」選項
		$CurrentSelect.append($CurrentOption.text("全部").val(""));
		//將選項寫進下拉式選單
		$.each(AllColumnDistinctDataArray[indexThTd],function(index,value){
			$CurrentOption = $ForCopyOption.clone();
			$CurrentSelect.append($CurrentOption.text(value).val(value));
		});
	
		$(valueThTd).append($CurrentSelect);
	});
}

function FilterSelectBind(){
	//表格標頭列所有欄位
	var $ThColumns = $("table.pure-table-trading > thead > tr > th"); 
	//表格所有資料列
	var $TrDataRows = $("table.pure-table-trading > tbody > tr"); 
	$ThColumns.on("change","select",function(){
		//先全部隱藏
		$TrDataRows.hide();
		var optionTexts = [];
		$ThColumns.find("select").each(function() { optionTexts.push($(this).val()) });
		var $CurrentSelectedRows = $TrDataRows;
		$.each(optionTexts,function(ColumnIndex,FilterData){
			if(FilterData != "")
				$CurrentSelectedRows = FilterRow($CurrentSelectedRows,ColumnIndex,FilterData);
		});
		//指定顯示
		$CurrentSelectedRows.show();
	});
}

function FilterRow($SelectedTrs,ColumnIndex,FilterData){
	return $SelectedTrs.filter(function() { return $(this).find("td:eq("+ ColumnIndex + ")").text().trim() == FilterData ;});
}