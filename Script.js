item = $('.instruments').find('.price');
count =0;
totalLength = item.length;
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
openMarketWatch();


var script = document.createElement('script');
script.type = 'text/javascript';
script.src = 'https://code.jquery.com/jquery-1.12.4.min.js';
document.head.appendChild(script)





function test() {
    var list =[];


$('.active-marketdepth').each(function(key,value){
try
{
var test = value.innerHTML;
var row={};
row.Open=test.split("<label>Open</label> <span class=\"value\">")[1].split("</span>")[0];
row.High=test.split("<label>High</label> <span class=\"value\">")[1].split("</span>")[0];
row.Low=test.split("<label>Low</label> <span class=\"value\">")[1].split("</span>")[0];
row.Close=test.split("<label>Close</label> <span class=\"value\">")[1].split("</span>")[0];
row.Volume=test.split("<label>Volume</label> <span class=\"value\">")[1].split("</span>")[0];
row.AvgPrice=test.split("<label>Avg. price</label> <span class=\"value\">")[1].split("</span>")[0];
row.Name=test.split("<span class=\"nice-name\">")[1].split("</span>")[0];
row.LastPrice=test.split("<span class=\"last-price\">")[1].split("</span>")[0];
var orderColumn = test.split('</table>');
var buycolumn= orderColumn[0];
var sellColumn= orderColumn[1];
row.BuyOrders=buycolumn.split('<tfoot><tr><td>Total</td> <td colspan=\"2\" class=\"text-right\">')[1].split('</td>')[0];
row.SellOrders=sellColumn.split('<tfoot><tr><td>Total</td> <!----> <td colspan=\"2\" class=\"text-right\">')[1].split('</td>')[0];
console.log(row);
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

	setTimeout(test, 3000);
}
}
test()