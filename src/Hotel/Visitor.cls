Class Hotel.Visitor Extends %Persistent
{

Index visitorID On (name, floor, room, status) [ PrimaryKey ];

Property name As %String;

Property floor As %Integer;

Property room As %Integer;

Property status As %String;

Storage Default
{
<Data name="VisitorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>name</Value>
</Value>
<Value name="3">
<Value>floor</Value>
</Value>
<Value name="4">
<Value>room</Value>
</Value>
<Value name="5">
<Value>status</Value>
</Value>
</Data>
<DataLocation>^Hotel.VisitorD</DataLocation>
<DefaultData>VisitorDefaultData</DefaultData>
<IdLocation>^Hotel.VisitorD</IdLocation>
<IndexLocation>^Hotel.VisitorI</IndexLocation>
<StreamLocation>^Hotel.VisitorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

ClassMethod saveVisitor(visitor As Hotel.Visitor) As %Status
{
    set obj = ##class(Hotel.Visitor).%New()
    set obj.name = visitor.name
    set obj.floor = visitor.floor
    set obj.room = visitor.room
    set obj.status = visitor.status
    set result = obj.%Save()
    Return ##class(Hotel.Utils).getStatus(result)
}

ClassMethod getAllVisitors() As %Library.DynamicArray
{
	set data = ##class(%Library.DynamicArray).%New()
	&sql(
	 	DECLARE MyCursor CURSOR FOR
	    SELECT id, name, floor, room, status
	    INTO :id, :name, :floor, :room, :status
	    FROM Hotel.Visitor
 	)
 	&sql(OPEN MyCursor)
 	
  FOR { 
    &sql(FETCH MyCursor)
    if (SQLCODE) quit

    set obj = {"visitorID": (id), "name": (name), "floor": (floor), "room": (room), "status": (status), "id":(id), "value":(name_"/"_id)}
    do data.%Push(obj)
 	}
 	&sql(CLOSE MyCursor)

 	return data
}

}
