Class Hotel.Order Extends %Persistent
{

Index orderID On (date, visitor, service) [ PrimaryKey ];

Property visitor As Hotel.Visitor;

Property date As %Date;

Property service As Hotel.Service;

Property sum As %Integer;

Storage Default
{
<Data name="OrderDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>data</Value>
</Value>
<Value name="3">
<Value>visitor</Value>
</Value>
<Value name="4">
<Value>summ</Value>
</Value>
<Value name="5">
<Value>sum</Value>
</Value>
<Value name="6">
<Value>service</Value>
</Value>
<Value name="7">
<Value>date</Value>
</Value>
</Data>
<DataLocation>^Hotel.OrderD</DataLocation>
<DefaultData>OrderDefaultData</DefaultData>
<IdLocation>^Hotel.OrderD</IdLocation>
<IndexLocation>^Hotel.OrderI</IndexLocation>
<StreamLocation>^Hotel.OrderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

ClassMethod saveOrder(order As Hotel.Order) As %Status
{
    set obj = ##class(Hotel.Order).%New()
    set obj.visitor = ##class(Hotel.Visitor).%OpenId(order.visitor)
    set obj.date = order.date
    set obj.service = ##class(Hotel.Service).%OpenId(order.service)
    set obj.sum = order.sum
    set result = obj.%Save()
    Return ##class(Hotel.Utils).getStatus(result)
}

ClassMethod getAllOrders() As %Library.DynamicArray
{
	set data = ##class(%Library.DynamicArray).%New()
	&sql(
	 	DECLARE MyCursor CURSOR FOR
	    SELECT "id", "visitor", "date", "service", "sum"
	    INTO :id, :visitor, :date, :service, :sum
	    FROM Hotel.Order
 	)
 	&sql(OPEN MyCursor)
 	
  FOR { 
    &sql(FETCH MyCursor)
    if (SQLCODE) quit
    set obj = {"orderID": (id), "visitor": (visitor), "date": ($ZDATE(date)), "service": (service), "sum": (sum)}
    do data.%Push(obj)
 	}
 	&sql(CLOSE MyCursor)
 	
 	return data
}

}
