Class web.ordersList Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
    do ..header()
    do ..body()
    do ..footer()
    Quit $$$OK
}

ClassMethod header() As %Status
{
    &HTML<
    <html>
        <head>
            <script type="text/javascript" src="webix/webix.min.js" ></script>
            <link rel="stylesheet" type="text/css" href="webix/webix.min.css">
            <link rel="stylesheet" href="https://cdn.materialdesignicons.com/2.7.94/css/materialdesignicons.css?v=7.2.0" type="text/css" charset="utf-8">
        </head>
    >

  Quit $$$OK
}

ClassMethod body() As %Status
{
    &JS<
        <script type="text/javascript">

        var submitOrder = (rawData) => {
            let data = JSON.parse(rawData);
            let message;
            if (data.result) {
                message = { type:"success", text: "Order is saved", expire:-1};
                $$('tab2_content').clear();
            }
            else
                message = { type:"error", text: data.message, expire:-1};
            webix.message(message);
        }

        var order_list_template = {
            id:"tab1_content",
            view:"datatable",
            columns:[

                { id:"orderID", header:"OrderID", adjust:"true" },

                { id:"visitor", header:"VisitorID", adjust:"true" },

                { id:"date", header:"Date", adjust:"true" },

                { id:"service", header:"ServiceID", adjust:"true" },

                { id:"sum", header:"Sum", adjust:"true" },

                { 
                    id:"", 
                    template:"<input class='delbtn' type='button' value='Delete'>",	
                    css:"padding_less",
                    width:100 
                }
  
            ],
            url:"/hotel/listOrders"
        };


        var order_form_template = {
            id:"tab2_content",
            view:"form",
            width: "400",
            elements:[
                {
                    view: "richselect",
                    name: "visitor",
                    width: 200,
                    value: 1, 
                    options: "/hotel/listVisitors",
                    label: "Visitor"
                },
                {
                    view:"datepicker",
                    name: "date", 
                    label: "Date", 
                    type:"month",
                    timepicker: false,
                    width: 300  
                },
                {
                    view: "richselect",
                    name: "service",
                    width: 200,
                    value: 1, 
                    options: "/hotel/listServices",
                    label: "Service1"
                },
                {view: "text", name: "sum", label: "Sum"},
                { view:"button",  value:"Save", id:"btn", 
                    click:function(){
                            var values = this.getFormView().getValues();
                            console.log(values)
                            webix.ajax().post("/hotel/saveOrder", values, submitOrder);
                            var url = $$(`tab1_content`).data.url
                            $$(`tab1_content`).clearAll();
                            $$(`tab1_content`).load(url);
                        }
                }
            ]
        };
        var menu_data = [
	        {id: "tab1", icon: "mdi mdi-table", value:"Orders list"},
	        {id: "tab2", icon: "mdi mdi-pencil", value:"Order form"},
        ];
        var ui_template = {
            height: '100%',
            rows: [
                    { 
                        view: "toolbar", 
                        padding:3, 
                        elements: [
                            { 
                                view: "button",
                                type: "icon", 
                                icon: "mdi mdi-menu",
                                width: 37, align: "left", css: "app_button", click: function(){
                                    $$("$sidebar1").toggle();
                                }
                            },
                            { 
                                view: "label", 
                                label: "OrderList Controller"
                            },
                        ]
                    },
                    { 
                        cols:[
                                {
                                    view: "sidebar",
                                    data: menu_data,
                                    on:{
                                        onAfterSelect: function(id){
                                            $$(`${id}_content`).show();
                                        }
                                    }
                                },
                                { 
                                    id:"t1_content",
                                    cells:[
                                            order_form_template,
                                            order_list_template
                                    ]   
                                }
                        ]
                    }
            ]
        };


        webix.ready(function(){
            webix.ui(ui_template);
            $$("tab1_content").on_click.delbtn=function(e, id, trg){
               
                var val = $$("tab1_content").getItem(id).orderID;
                webix.message("Delete order: "+ val);
                webix.ajax().post("/hotel/deleteOrder", {"id":val});
                var url = $$(`tab1_content`).data.url
                $$(`tab1_content`).clearAll();
                $$(`tab1_content`).load(url);
                //block default onclick event
                return false;
            };
        });
        </script>
    >
    Quit $$$OK
}

ClassMethod footer() As %Status
{
  &HTML<
    </body></html>
  >
  Quit $$$OK
}

}
