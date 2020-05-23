Class Hotel.Api Extends %CSP.REST
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="/saveVisitor" Method="POST" Call="saveVisitor"/>
    <Route Url="/deleteVisitor" Method="POST" Call="deleteVisitor"/>
    <Route Url="/listVisitors" Method="GET" Call="listVisitors"/>

    <Route Url="/saveOrder" Method="POST" Call="saveOrder"/>
    <Route Url="/deleteOrder" Method="POST" Call="deleteOrder"/>
    <Route Url="/listOrders" Method="GET" Call="listOrders"/>

    <Route Url="/saveService" Method="POST" Call="saveService"/>
    <Route Url="/deleteService" Method="POST" Call="deleteService"/>
    <Route Url="/listServices" Method="GET" Call="listServices"/>

    <Route Url="/saveDiscount" Method="POST" Call="saveDiscount"/>
    <Route Url="/deleteDiscount" Method="POST" Call="deleteDiscount"/>
    <Route Url="/listDiscounts" Method="GET" Call="listDiscounts"/>

    <Route Url="/saveFeedback" Method="POST" Call="saveFeedback"/>
    <Route Url="/deleteFeedback" Method="POST" Call="deleteFeedback"/>
    <Route Url="/listFeedbacks" Method="GET" Call="listFeedbacks"/>

</Routes>
}

ClassMethod saveVisitor() As %Status
{
    set obj = {}
    set obj.name = %request.Get("name")
    set obj.floor = %request.Get("floor")
    set obj.room = %request.Get("room")
    set obj.status = %request.Get("status")
    set result = ##class(Hotel.Visitor).saveVisitor(obj)
    write result.%ToJSON()
    Return result
}

ClassMethod deleteVisitor() As %Status
{
    set id = %request.Get("id")
    set result = ##class(Hotel.Visitor).%DeleteId(id)
    Return result
}

ClassMethod listVisitors() As %Status
{
  set list = ##class(Hotel.Visitor).getAllVisitors()
  write list.%ToJSON()
  Return $$$OK
}

ClassMethod truncateVisitors() As %Status
{
    set sql = "truncate table Hotel.Visitor"
	set sqlObj = ##class(%SQL.Statement).%New()
	set qStatus = sqlObj.%Prepare(sql)

	set rset = sqlObj.%Execute()
    return $$$OK
}

ClassMethod saveOrder() As %Status
{
    set obj = {}

    set obj.visitor =  %request.Get("visitor")
    set obj.date = $ZDATEH(%request.Get("date"), 3)
    set obj.service = %request.Get("service")
    set obj.sum = %request.Get("sum")
    set result = ##class(Hotel.Order).saveOrder(obj)
    write result.%ToJSON()
    Return result
}

ClassMethod saveOrderTest() As %Status
{
    set obj = {}
    set obj.visitor =  $PIECE("name/1", "/", 2)
    set obj.date = $ZDATEH("2020-09-22", 3)
    set obj.service = $PIECE("service/1","/",2)
    write obj.visitor," ", obj.service
    set obj.sum = 100
    set result = ##class(Hotel.Order).saveOrder(obj)
    write result.%ToJSON()
    Return result
}

ClassMethod deleteOrder() As %Status
{
    set id = %request.Get("id")
    set result = ##class(Hotel.Order).%DeleteId(id)
    Return result
}

ClassMethod listOrders() As %Status
{
  set list = ##class(Hotel.Order).getAllOrders()
  write list.%ToJSON()
  Return $$$OK
}

ClassMethod saveService() As %Status
{
    set obj = {}
    set obj.name = %request.Get("name")
    set obj.price = %request.Get("price")

    set result = ##class(Hotel.Service).saveService(obj)
    write result.%ToJSON()
    Return result
}

ClassMethod deleteService() As %Status
{
    set id = %request.Get("id")
    set result = ##class(Hotel.Service).%DeleteId(id)
    Return result
}

ClassMethod listServices() As %Status
{
  set list = ##class(Hotel.Service).getAllServices()
  write list.%ToJSON()
  Return $$$OK
}

ClassMethod saveDiscount() As %Status
{
    set obj = {}
    set obj.visitor = %request.Get("visitor")
    set obj.feedback = %request.Get("feedback")
    set obj.issue = %request.Get("issue")

    set result = ##class(Hotel.DiscountList).saveDiscount(obj)
    write result.%ToJSON()
    Return result
}

ClassMethod deleteDiscount() As %Status
{
    set id = %request.Get("id")
    set result = ##class(Hotel.DiscountList).%DeleteId(id)
    Return result
}

ClassMethod listDiscounts() As %Status
{
  set list = ##class(Hotel.DiscountList).getAllDiscounts()
  write list.%ToJSON()
  Return $$$OK
}

ClassMethod saveFeedback() As %Status
{
    set obj = {}
    set obj.date = $ZDATEH(%request.Get("date"), 3)
    set obj.description = %request.Get("description")

    set result = ##class(Hotel.Feedback).saveFeedback(obj)
    write result.%ToJSON()
    Return result
}

ClassMethod deleteFeedback() As %Status
{
    set id = %request.Get("id")
    set result = ##class(Hotel.Feedback).%DeleteId(id)
    Return result
}

ClassMethod listFeedbacks() As %Status
{
  set list = ##class(Hotel.Feedback).getAllFeedbacks()
  write list.%ToJSON()
  Return $$$OK
}

}
