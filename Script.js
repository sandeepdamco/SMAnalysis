function openMarketWatch()
{

if(count!=0)
{
console.log(count)
$('.mobile-context-menu-list li:nth-child(3) a span').attr('id','test')
$('#test').click()
}
if(totalLength>count)
{
$(item[count]).trigger('click');
}
count =count +1
setTimeout(function(){ if(totalLength+2>count) openMarketWatch() }, 1000);
}

var script = document.createElement('script');
script.type = 'text/javascript';
script.src = 'https://code.jquery.com/jquery-1.12.4.min.js';
document.head.appendChild(script)
script.onload = function() {
	item = $('.instruments').find('.price');
	count =0;
	totalLength = item.length;
     openMarketWatch();
	 test()
};

function test() {
    var list =[];


$('.active-marketdepth').each(function(key,value){
try
{
var test = value.innerHTML;
var row={};

buystring= $(test).find('.buy')[0].innerHTML;
sellstring= $(test).find('.sell')[0].innerHTML;
row.Open=test.split("<label>Open</label> <span class=\"value\">")[1].split("</span>")[0];
row.High=test.split("<label>High</label> <span class=\"value\">")[1].split("</span>")[0];
row.Low=test.split("<label>Low</label> <span class=\"value\">")[1].split("</span>")[0];
row.Close=test.split("<label>Close</label> <span class=\"value\">")[1].split("</span>")[0];
row.Volume=test.split("<label>Volume</label> <span class=\"value\">")[1].split("</span>")[0];
row.Volume =row.Volume.replace(new RegExp(','), '');
row.AvgPrice=test.split("<label>Avg. price</label> <span class=\"value\">")[1].split("</span>")[0];
row.Name=test.split("<span class=\"nice-name\">")[1].split("</span>")[0];
row.LastPrice=test.split("<span class=\"last-price\">")[1].split("</span>")[0];
row.buycolumn=buystring;
row.sellColumn=sellstring;
var orderColumn = test.split('</table>');
var buycolumn= orderColumn[0];
var sellColumn= orderColumn[1];
row.BuyOrders=buycolumn.split('<tfoot><tr><td>Total</td> <td colspan=\"2\" class=\"text-right\">')[1].split('</td>')[0];
row.BuyOrders =row.BuyOrders.replace(new RegExp(','), '');;
row.SellOrders=sellColumn.split('<tfoot><tr><td>Total</td> <!----> <td colspan=\"2\" class=\"text-right\">')[1].split('</td>')[0];
row.SellOrders = row.SellOrders.replace(new RegExp(','), '');;
list.push(row);
}
catch{}
});
if(list.length>0)
{
var ajaxdata ={list:list}
$.ajax({
  type: "POST",
  url: "http://localhost:96/Home/DataPost",
  data: JSON.stringify(ajaxdata),
  contentType: "application/json",
    dataType: 'json',
  success: function(){},
  dataType:  function(){}
});

	
}
setTimeout(test, 3000);
}



$($('.instruments').find('.price')).click()
setTimeout(function(){
$('.mobile-context-menu-list li:nth-child(1) a span').attr('id','test')
$('#test').click()
setTimeout(function(){
$('.row-4 a').click()
$('.varieties [title="Bracket order"] input').click()
$('.content .quantity .su-input-group input').value="0"
$('.content .price .su-input-group input').value="2046.5"
$('.content .stoploss-price .su-input-group input').value="3"
$('.content .squareoff-price .su-input-group input').value="3"
//$('.content .actions button.button-blue').click()
},1000)
},1000)

//$($('.instruments').find('.nice-name'))
//$($('.instruments').find('.price'))

$($('.instruments').find('.nice-name:contains("BHARTIARTL")')).click()
setTimeout(function(){
$('.mobile-context-menu-list li:nth-child(2) a span').attr('id','test')
$('#test').click()
setTimeout(function(){
if($('.row-4 a').length>0)
{
$('.row-4 a')[0].click()
}
setTimeout(function(){
$('.varieties [title="Bracket order"] input')[0].click()
$('.content .quantity .su-input-group input')[0].value="200"
$('.content .price .su-input-group input')[0].value="2046.5"
$('.content .stoploss-price .su-input-group input')[0].value="3"
$('.content .squareoff-price .su-input-group input')[0].value="3"
setTimeout(function(){
//$('.content .actions button.button-blue').click()
},100)
},300)
},100)
},100)
